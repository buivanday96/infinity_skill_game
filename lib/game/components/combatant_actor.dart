import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:infinity_skill_game/features/battle/domain/hit_reaction.dart';
import 'package:infinity_skill_game/game/combat_demo_game.dart';
import 'package:infinity_skill_game/game/components/overhead_bars.dart';
import 'package:infinity_skill_game/core/debug/debug_hitbox.dart';
import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';

enum CombatantAnim { idle, walk, attack, hurt, dead, buff, channel }

/// Animated fighter on the battle field (hero or slime).
class CombatantActor extends PositionComponent with HasGameReference<CombatDemoGame>, DebugHitbox {
  CombatantActor({
    required this.actorId,
    required this.facingRight,
    required this.idleEntry,
    required this.attackEntry,
    required this.hurtEntry,
    required this.deadEntry,
    required Vector2 worldPosition,
    this.walkEntry,
    this.buffEntry,
    this.displaySize = 140,
    this.showManaBar = false,
    this.hitboxInset = const HitboxInset(
      left: 0.28,
      top: 0.18,
      right: 0.28,
      bottom: 0.06,
    ),
    this.isHeroTeam = true,
    this.footShadowLift = 0,
    this.footShadowWidth = 0.48,
    this.footShadowHeight = 0.14,
    this.artFacesLeft = false,
    double? maxPoise,
  }) : hitReaction = HitReactionState(
         maxPoise: maxPoise ?? HitReactionState.defaultMaxPoise,
       ),
       super(
         position: worldPosition,
         size: Vector2.all(displaySize),
         anchor: Anchor.bottomCenter,
       );

  final String actorId;
  final double displaySize;
  final bool showManaBar;
  final bool isHeroTeam;
  final HitboxInset hitboxInset;
  final double footShadowLift;
  final double footShadowWidth;
  final double footShadowHeight;

  /// Source sheets face left; flip logic is inverted vs right-facing kits.
  final bool artFacesLeft;

  final AsepriteEntry idleEntry;
  final AsepriteEntry? walkEntry;
  final AsepriteEntry attackEntry;
  final AsepriteEntry hurtEntry;
  final AsepriteEntry deadEntry;
  final AsepriteEntry? buffEntry;

  /// Poise / hit-react gate (shared rules for heroes & monsters).
  final HitReactionState hitReaction;

  late final SpriteAnimationComponent _sprite;
  late final OverheadBars bars;
  final Map<CombatantAnim, SpriteAnimation> _anims = {};

  bool facingRight;
  bool _moving = false;
  CombatantAnim _current = CombatantAnim.idle;

  /// Attack reach in world pixels — set by battle system for range ring.
  double attackRangePx = 0;

  // ── Knock-up / knock-back (sprite lifts; feet + shadow stay grounded) ──
  static const double _launchGravity = 1600;
  bool _airborne = false;
  double _airLift = 0;
  double _liftVel = 0;
  double _knockVx = 0;
  double _knockVy = 0;

  // ── Stun / Freeze (crowd control) ──
  double _stunRemaining = 0;
  double _freezeRemaining = 0;

  bool get isMoving => _moving;

  bool get isAirborne => _airborne;

  bool get isStunned => _stunRemaining > 0;

  bool get isFrozen => _freezeRemaining > 0;

  bool get isCrowdControlled => isStunned || isFrozen;

  /// Attack / buff / channel — hyper-armor vs hit interrupt.
  bool get isCommittedAction =>
      _current == CombatantAnim.attack ||
      _current == CombatantAnim.buff ||
      _current == CombatantAnim.channel;

  bool get isBusy =>
      _current == CombatantAnim.attack ||
      _current == CombatantAnim.hurt ||
      _current == CombatantAnim.dead ||
      _current == CombatantAnim.buff ||
      _current == CombatantAnim.channel ||
      _airborne ||
      isCrowdControlled;

  bool get isDead => _current == CombatantAnim.dead;

  bool get isChanneling => _current == CombatantAnim.channel;

  bool get hasBuffAnim => _anims.containsKey(CombatantAnim.buff);

  void configurePoise(double max) => hitReaction.configure(max: max);

  @override
  bool get showHitbox => !isDead && game.debugFlags.value.hitbox;

  @override
  bool get showCollision => !isDead && game.debugFlags.value.collision;

  @override
  bool get showAction => !isDead && game.debugFlags.value.action;

  @override
  Color get hitboxColor => isHeroTeam ? const Color(0xFF69F0AE) : const Color(0xFFFF8A80);

  @override
  Color get attackRangeColor => isHeroTeam ? const Color(0x66FFEB3B) : const Color(0x66FF9800);

  @override
  double get debugAttackRangePx => attackRangePx;

  @override
  Rect get localHitbox => hitboxInset.toLocalRect(size);

  @override
  Future<void> onLoad() async {
    await _loadAnim(CombatantAnim.idle, idleEntry, loop: true);
    if (walkEntry != null) {
      await _loadAnim(CombatantAnim.walk, walkEntry!, loop: true);
    }
    await _loadAnim(CombatantAnim.attack, attackEntry, loop: false);
    await _loadAnim(CombatantAnim.hurt, hurtEntry, loop: false);
    await _loadAnim(CombatantAnim.dead, deadEntry, loop: false);
    if (buffEntry != null) {
      await _loadAnim(CombatantAnim.buff, buffEntry!, loop: false);
    }

    _sprite = SpriteAnimationComponent(
      animation: _anims[CombatantAnim.idle],
      size: size.clone(),
      anchor: Anchor.bottomCenter,
      position: Vector2(size.x / 2, size.y),
    );
    if (artFacesLeft ? facingRight : !facingRight) {
      _sprite.flipHorizontally();
    }

    add(
      _FootShadow(
          width: displaySize * footShadowWidth,
          height: displaySize * footShadowHeight,
        )
        ..position = Vector2(
          size.x / 2,
          size.y - displaySize * footShadowLift,
        ),
    );
    add(_sprite);

    bars = OverheadBars(
      barWidth: displaySize * 0.85,
      showMana: showManaBar,
    )..position = Vector2(size.x / 2, -4);
    add(bars);
  }

  @override
  void update(double dt) {
    super.update(dt);

    hitReaction.tick(dt);

    var ccChanged = false;
    if (_stunRemaining > 0) {
      _stunRemaining = (_stunRemaining - dt).clamp(0, 30);
      if (_stunRemaining <= 0) ccChanged = true;
    }
    if (_freezeRemaining > 0) {
      _freezeRemaining = (_freezeRemaining - dt).clamp(0, 30);
      if (_freezeRemaining <= 0) ccChanged = true;
    }
    if (ccChanged) {
      _refreshCrowdControlVisual();
    }

    if (!_airborne) return;

    position.x += _knockVx * dt;
    position.y += _knockVy * dt;
    _clampToBattlefield();

    _liftVel -= _launchGravity * dt;
    _airLift += _liftVel * dt;
    if (_airLift <= 0) {
      _airLift = 0;
      _liftVel = 0;
      _knockVx = 0;
      _knockVy = 0;
      _airborne = false;
    }
    _syncAirLiftVisuals();
  }

  /// Gate hurt / stagger / skill CC through poise + multi-hit window.
  ///
  /// Always call after HP damage. Returns the decision for HUD / VFX.
  HitReactDecision applyHitReaction({
    required double poiseDamage,
    Vector2? launchOrigin,
    double knockBack = 0,
    double knockUp = 0,
    double skillStun = 0,
    double skillFreeze = 0,
  }) {
    final wantsCc =
        knockBack > 0 || knockUp > 0 || skillStun > 0 || skillFreeze > 0;
    final decision = hitReaction.resolve(
      poiseDamage: poiseDamage,
      isCommitted: isCommittedAction,
      isDead: isDead,
      wantsSkillCc: wantsCc,
    );
    _executeHitDecision(
      decision,
      launchOrigin: launchOrigin,
      knockBack: knockBack,
      knockUp: knockUp,
      skillStun: skillStun,
      skillFreeze: skillFreeze,
    );
    return decision;
  }

  void _executeHitDecision(
    HitReactDecision decision, {
    Vector2? launchOrigin,
    double knockBack = 0,
    double knockUp = 0,
    double skillStun = 0,
    double skillFreeze = 0,
  }) {
    if (decision.flash) _flash();

    if (decision.playHurt) {
      unawaited(_playHurtInternal(stagger: decision.isStagger));
    }

    if (decision.isStagger) {
      final stun = math.max(HitReactionState.staggerStunDuration, skillStun);
      applyStun(stun);
      if (skillFreeze > 0) applyFreeze(skillFreeze);
      if (launchOrigin != null && (knockBack > 0 || knockUp > 0)) {
        launchAwayFrom(
          launchOrigin,
          knockBack: knockBack,
          knockUp: knockUp,
        );
      }
    } else if (decision.applySkillCc) {
      if (launchOrigin != null && (knockBack > 0 || knockUp > 0)) {
        launchAwayFrom(
          launchOrigin,
          knockBack: knockBack,
          knockUp: knockUp,
        );
      }
      if (skillStun > 0) applyStun(skillStun);
      if (skillFreeze > 0) applyFreeze(skillFreeze);
    }
  }

  Future<void> _flushQueuedStagger() async {
    final decision = hitReaction.consumeQueuedStagger();
    if (decision.kind == HitReactKind.none) return;
    _executeHitDecision(decision);
  }

  /// Launch away from [epicenter]: knock-up into the air + knock-back on ground.
  void launchAwayFrom(
    Vector2 epicenter, {
    required double knockBack,
    required double knockUp,
  }) {
    if (isDead || (knockBack <= 0 && knockUp <= 0)) return;

    setMoving(false);

    var dx = position.x - epicenter.x;
    var dy = position.y - epicenter.y;
    var len = math.sqrt(dx * dx + dy * dy);
    if (len < 4) {
      // Standing on blast center — fling opposite of facing (usually right for foes).
      dx = facingRight ? -1.0 : 1.0;
      dy = 0;
      len = 1;
    }
    final nx = dx / len;
    final ny = (dy / len) * 0.4;

    final up = knockUp.clamp(0, 160);
    final back = knockBack.clamp(0, 200);
    final upSpeed = up <= 0 ? 0.0 : math.sqrt(2 * _launchGravity * up);
    final airTime = upSpeed <= 0 ? 0.28 : (2 * upSpeed / _launchGravity);

    _knockVx = nx * (back / airTime);
    _knockVy = ny * (back / airTime);
    // Fresh upward burst; keep residual height if already airborne.
    _liftVel = math.max(_liftVel, upSpeed);
    _airborne = true;
    _syncAirLiftVisuals();
  }

  /// Stun — cannot move/act; yellow tint.
  void applyStun(double duration) {
    if (isDead || duration <= 0) return;
    setMoving(false);
    _stunRemaining = math.max(_stunRemaining, duration);
    _refreshCrowdControlVisual();
  }

  /// Freeze — cannot move/act; ice-blue tint.
  void applyFreeze(double duration) {
    if (isDead || duration <= 0) return;
    setMoving(false);
    _freezeRemaining = math.max(_freezeRemaining, duration);
    _refreshCrowdControlVisual();
  }

  void _refreshCrowdControlVisual() {
    if (isFrozen) {
      _sprite.paint.colorFilter = const ColorFilter.mode(
        Color(0xAA80D8FF),
        BlendMode.modulate,
      );
    } else if (isStunned) {
      _sprite.paint.colorFilter = const ColorFilter.mode(
        Color(0xCCFFEB3B),
        BlendMode.modulate,
      );
    } else {
      _sprite.paint.colorFilter = null;
    }
  }

  void _syncAirLiftVisuals() {
    _sprite.position = Vector2(size.x / 2, size.y - _airLift);
    if (bars.isMounted) {
      bars.position = Vector2(size.x / 2, -4 - _airLift);
    }
  }

  void _clampToBattlefield() {
    final minX = game.size.x * 0.06;
    final maxX = game.size.x * 0.94;
    final minY = game.battleTop + game.battleHeight * 0.28;
    final maxY = game.battleTop + game.battleHeight * 0.94;
    position.x = position.x.clamp(minX, maxX);
    position.y = position.y.clamp(minY, maxY);
  }

  void updateBars({
    required double hp,
    required double maxHp,
    double shield = 0,
    double mana = 0,
    double maxMana = 1,
  }) {
    if (!bars.isMounted) return;
    bars.setResources(
      hp: hp,
      maxHp: maxHp,
      shield: shield,
      mana: mana,
      maxMana: maxMana,
    );
  }

  void setFacingRight(bool right) {
    if (facingRight == right) return;
    facingRight = right;
    _sprite.flipHorizontally();
  }

  /// Toggle walk/idle when not in a one-shot action.
  void setMoving(bool moving) {
    if (_moving == moving) return;
    _moving = moving;
    if (isBusy) return;
    _applyLocomotionAnim();
  }

  void _applyLocomotionAnim() {
    if (_moving && _anims.containsKey(CombatantAnim.walk)) {
      _current = CombatantAnim.walk;
      _sprite.animation = _anims[CombatantAnim.walk];
    } else {
      _current = CombatantAnim.idle;
      _sprite.animation = _anims[CombatantAnim.idle];
    }
  }

  Future<void> _loadAnim(
    CombatantAnim kind,
    AsepriteEntry entry, {
    required bool loop,
  }) async {
    final result = await loadAsepriteAnimation(
      entry: entry,
      images: game.images,
      loop: loop,
    );
    _anims[kind] = result.animation;
  }

  Future<void> playAttack({void Function(int frame)? onFrame}) async {
    if (_current == CombatantAnim.dead) return;
    await _playOnce(CombatantAnim.attack, onFrame: onFrame);
    await _flushQueuedStagger();
  }

  /// Plays buff anim (knight `powerup1`). No-op if kit has no buff.
  Future<void> playBuff() async {
    if (_current == CombatantAnim.dead) return;
    if (!hasBuffAnim) return;
    await _playOnce(CombatantAnim.buff);
    await _flushQueuedStagger();
  }

  /// Loop [entry] for [durationSec] (knight whirlwind / attack4).
  Future<void> playChannel(
    AsepriteEntry entry, {
    required double durationSec,
  }) async {
    if (_current == CombatantAnim.dead) return;
    _moving = false;
    _current = CombatantAnim.channel;

    final result = await loadAsepriteAnimation(
      entry: entry,
      images: game.images,
      loop: true,
    );
    if (_current != CombatantAnim.channel) return;
    _sprite.animation = result.animation;

    final ms = (durationSec * 1000).round().clamp(1, 60000);
    await Future<void>.delayed(Duration(milliseconds: ms));

    if (_current != CombatantAnim.channel) return;
    _applyLocomotionAnim();
    await _flushQueuedStagger();
  }

  /// Legacy entry — prefer [applyHitReaction] from combat.
  Future<void> playHurt() async {
    applyHitReaction(poiseDamage: hitReaction.maxPoise);
  }

  Future<void> _playHurtInternal({required bool stagger}) async {
    if (_current == CombatantAnim.dead) return;
    // Channel keeps spinning; flash already handled by caller.
    if (_current == CombatantAnim.channel) return;
    // Never interrupt a committed swing / buff.
    if (isCommittedAction) return;
    // [stagger] reserved for future heavier hurt variant.
    await _playOnce(CombatantAnim.hurt);
  }

  Future<void> playDead() async {
    if (_current == CombatantAnim.dead) return;
    _moving = false;
    _stunRemaining = 0;
    _freezeRemaining = 0;
    hitReaction.fullRestore();
    _refreshCrowdControlVisual();
    _current = CombatantAnim.dead;
    attackRangePx = 0;
    hideResourceBars();

    final anim = _anims[CombatantAnim.dead]!;
    _sprite.animation = anim;
    final ticker = _sprite.animationTicker;
    if (ticker == null) return;
    final done = Completer<void>();
    ticker.onComplete = () {
      if (!done.isCompleted) done.complete();
    };
    await done.future;
  }

  /// Drop HP / mana bars immediately on death.
  void hideResourceBars() {
    if (bars.isMounted) {
      bars.removeFromParent();
    }
  }

  Future<void> _playOnce(
    CombatantAnim kind, {
    void Function(int frame)? onFrame,
  }) async {
    _current = kind;
    final anim = _anims[kind]!;
    _sprite.animation = anim;
    final ticker = _sprite.animationTicker;
    if (ticker == null) {
      _applyLocomotionAnim();
      return;
    }
    final done = Completer<void>();
    ticker.reset();
    ticker.onFrame = onFrame;
    ticker.onComplete = () {
      if (!done.isCompleted) done.complete();
    };
    await done.future;
    if (_current != CombatantAnim.dead) {
      _applyLocomotionAnim();
    }
  }

  void _flash() {
    _sprite.add(
      OpacityEffect.to(
        0.35,
        EffectController(duration: 0.08, reverseDuration: 0.12),
      ),
    );
  }

  /// Anchor point for VFX (chest / center of sprite).
  Vector2 get effectAnchor => absolutePosition + Vector2(0, -displaySize * 0.45);

  /// Center of the body hitbox — prefer this for hit / end VFX.
  Vector2 get hitboxCenter {
    final box = absoluteHitbox();
    if (box.isEmpty) return effectAnchor;
    return Vector2(
      (box.left + box.right) / 2,
      (box.top + box.bottom) / 2,
    );
  }

  /// Spawn point for projectiles (forward of the caster).
  Vector2 get projectileSpawnPoint =>
      absolutePosition +
      Vector2(
        facingRight ? displaySize * 0.28 : -displaySize * 0.28,
        -displaySize * 0.52,
      );
}

/// Soft oval under a fighter's feet for ground contact.
class _FootShadow extends PositionComponent {
  _FootShadow({required double width, required double height})
    : super(
        size: Vector2(width, height),
        anchor: Anchor.center,
        priority: -1,
      );

  static final _fill = Paint()..color = const Color(0x55000000);
  static final _soft = Paint()
    ..color = const Color(0x33000000)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

  @override
  void render(Canvas canvas) {
    final oval = Offset.zero & Size(size.x, size.y);
    canvas.drawOval(oval.inflate(2), _soft);
    canvas.drawOval(oval, _fill);
  }
}
