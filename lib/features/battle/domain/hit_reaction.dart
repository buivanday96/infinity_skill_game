/// Hit-react / poise rules (Souls-like flinch gate).
///
/// Combined rules:
/// 1. Committed actions (attack / buff / channel) are never interrupted.
/// 2. Hurt flinch anim has a short cooldown.
/// 3. Poise must break before a full stagger (hurt + brief stun / launch).
/// 4. Only one hit per [reactWindow] may trigger hit/stagger/CC effects;
///    other hits in that window deal HP only.
class HitReactionState {
  HitReactionState({this.maxPoise = defaultMaxPoise}) : poise = 0;

  static const double defaultMaxPoise = 100;
  static const double reactWindow = 0.25;
  static const double hitAnimCooldown = 0.3;
  static const double poiseRegenPerSec = 28;
  static const double poiseRegenDelay = 0.9;
  static const double staggerStunDuration = 0.45;

  double maxPoise;

  /// Accumulated stagger damage; breaks at [maxPoise].
  double poise;

  /// Blocks another hit/stagger/CC react (multi-attacker gate).
  double reactLockout = 0;

  /// Blocks repeating hurt flinch anim.
  double hitAnimCooldownLeft = 0;

  /// Delay before poise starts regenerating after a hit that spent the window.
  double regenDelay = 0;

  /// Poise broke during a committed action — apply when free.
  bool staggerQueued = false;

  void configure({required double max}) {
    maxPoise = max <= 0 ? defaultMaxPoise : max;
    poise = poise.clamp(0, maxPoise);
  }

  void fullRestore() {
    poise = 0;
    reactLockout = 0;
    hitAnimCooldownLeft = 0;
    regenDelay = 0;
    staggerQueued = false;
  }

  void tick(double dt) {
    if (reactLockout > 0) {
      reactLockout = (reactLockout - dt).clamp(0, 10);
    }
    if (hitAnimCooldownLeft > 0) {
      hitAnimCooldownLeft = (hitAnimCooldownLeft - dt).clamp(0, 10);
    }
    if (regenDelay > 0) {
      regenDelay = (regenDelay - dt).clamp(0, 10);
    }
    if (regenDelay <= 0 && poise > 0) {
      poise = (poise - poiseRegenPerSec * dt).clamp(0, maxPoise);
    }
  }

  /// Resolve whether this hit may flinch / stagger / apply skill CC.
  ///
  /// HP damage is always applied by the caller — this only gates reactions.
  HitReactDecision resolve({
    required double poiseDamage,
    required bool isCommitted,
    required bool isDead,
    bool wantsSkillCc = false,
  }) {
    if (isDead) {
      return const HitReactDecision(kind: HitReactKind.none);
    }

    // Multi-hit gate: HP only.
    if (reactLockout > 0) {
      return const HitReactDecision(kind: HitReactKind.none);
    }

    // Claim the exclusive react slot for this window.
    reactLockout = reactWindow;
    regenDelay = poiseRegenDelay;

    final dmg = poiseDamage < 0 ? 0.0 : poiseDamage;
    poise = (poise + dmg).clamp(0, maxPoise * 1.5);
    final broke = poise >= maxPoise;

    if (broke) {
      poise = 0;
      if (isCommitted) {
        staggerQueued = true;
        // Hyper-armor: no interrupt / no skill CC mid-swing.
        return const HitReactDecision(
          kind: HitReactKind.deferredStagger,
          flash: true,
        );
      }
      hitAnimCooldownLeft = hitAnimCooldown;
      return const HitReactDecision(
        kind: HitReactKind.stagger,
        applySkillCc: true,
        flash: true,
      );
    }

    if (isCommitted) {
      // Build poise only; never interrupt the swing.
      return const HitReactDecision(
        kind: HitReactKind.none,
        flash: true,
      );
    }

    final canFlinch = hitAnimCooldownLeft <= 0;
    if (canFlinch) {
      hitAnimCooldownLeft = hitAnimCooldown;
    }

    return HitReactDecision(
      kind: canFlinch ? HitReactKind.flinch : HitReactKind.none,
      applySkillCc: wantsSkillCc,
      flash: true,
    );
  }

  /// Call when a committed action ends and [staggerQueued] is set.
  HitReactDecision consumeQueuedStagger() {
    if (!staggerQueued) {
      return const HitReactDecision(kind: HitReactKind.none);
    }
    staggerQueued = false;
    hitAnimCooldownLeft = hitAnimCooldown;
    reactLockout = reactWindow;
    return const HitReactDecision(
      kind: HitReactKind.stagger,
      applySkillCc: false,
      flash: true,
    );
  }
}

enum HitReactKind {
  /// No anim / no CC from this hit (HP may still apply).
  none,

  /// Short hurt flinch (does not hard-stun beyond hurt busy time).
  flinch,

  /// Poise break — hurt + stagger stun (+ optional launch/CC).
  stagger,

  /// Poise broke while attacking — stagger after the action finishes.
  deferredStagger,
}

class HitReactDecision {
  const HitReactDecision({
    required this.kind,
    this.applySkillCc = false,
    this.flash = false,
  });

  final HitReactKind kind;
  final bool applySkillCc;
  final bool flash;

  bool get playHurt =>
      kind == HitReactKind.flinch || kind == HitReactKind.stagger;

  bool get isStagger => kind == HitReactKind.stagger;
}
