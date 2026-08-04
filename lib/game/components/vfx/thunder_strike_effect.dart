import 'dart:async';

import 'package:flame/components.dart';
import 'package:infinity_skill_game/features/battle/data/skill_vfx_catalog.dart';
import 'package:infinity_skill_game/game/combat_demo_game.dart';
import 'package:infinity_skill_game/game/components/combatant_actor.dart';
import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';

/// Top-down thunder: strike at target, then splash on impact.
class ThunderStrikeEffect extends PositionComponent with HasGameReference<CombatDemoGame> {
  ThunderStrikeEffect({
    required this.vfx,
    required this.target,
    required this.onImpact,
    this.onFinished,
  }) : super(
         // Feet for the bolt; splash repositions to hitbox center.
         position: target.absolutePosition.clone(),
         anchor: Anchor.bottomCenter,
         priority: target.priority + 50,
       );

  final SkillVfxSpec vfx;
  final CombatantActor target;
  final void Function() onImpact;
  final void Function()? onFinished;

  SpriteAnimationComponent? _strikeSprite;
  double _impactAt = 0.55;
  double _elapsed = 0;
  bool _impacted = false;
  bool _finished = false;

  @override
  Future<void> onLoad() async {
    final strikeEntry = vfx.strikeEffect;
    if (strikeEntry == null) {
      _finish();
      return;
    }

    final strike = await _loadAnim(strikeEntry);
    final strikeDuration = _animDuration(strike);
    _impactAt = strikeDuration * 0.55;

    _strikeSprite = SpriteAnimationComponent(
      animation: strike,
      size: Vector2(vfx.strikeWidth, vfx.strikeHeight),
      anchor: Anchor.bottomCenter,
      position: Vector2.zero(),
    );
    add(_strikeSprite!);

    _strikeSprite!.animationTicker?.onComplete = () {
      _strikeSprite?.removeFromParent();
      _strikeSprite = null;
      if (!_impacted) {
        unawaited(_resolveImpact());
      }
    };
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Keep strike locked on the moving target's feet, drawn above them.
    if (target.isMounted && !_finished) {
      position.setFrom(target.absolutePosition);
      priority = target.priority + 50;
    }
    if (_finished || _impacted) return;
    _elapsed += dt;
    if (_elapsed >= _impactAt) {
      unawaited(_resolveImpact());
    }
  }

  Future<void> _resolveImpact() async {
    if (_impacted || _finished) return;
    _impacted = true;
    onImpact();
    await _playSplash();
  }

  Future<void> _playSplash() async {
    final splashEntry = vfx.hitEffect;
    if (splashEntry == null) {
      _finish();
      return;
    }

    final splash = await _loadAnim(splashEntry);
    // Place splash on body hitbox center (not feet / border).
    final localSplash = _hitboxCenterLocal();
    final splashSprite = SpriteAnimationComponent(
      animation: splash,
      size: Vector2(vfx.splashWidth, vfx.splashHeight),
      anchor: Anchor.center,
      position: localSplash,
      priority: 10,
    );
    add(splashSprite);

    final done = Completer<void>();
    splashSprite.animationTicker?.onComplete = () {
      if (!done.isCompleted) done.complete();
    };
    await done.future.timeout(
      const Duration(seconds: 2),
      onTimeout: () {},
    );

    _finish();
  }

  Vector2 _hitboxCenterLocal() {
    if (!target.isMounted) {
      return Vector2(0, -vfx.strikeHeight * 0.35);
    }
    final center = target.hitboxCenter;
    return Vector2(center.x - position.x, center.y - position.y);
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    onFinished?.call();
    removeFromParent();
  }

  Future<SpriteAnimation> _loadAnim(AsepriteEntry entry) async {
    final result = await loadAsepriteAnimation(
      entry: entry,
      images: game.images,
      loop: false,
    );
    return result.animation;
  }

  double _animDuration(SpriteAnimation anim) {
    var total = 0.0;
    for (final frame in anim.frames) {
      total += frame.stepTime;
    }
    return total <= 0 ? 0.8 : total;
  }
}
