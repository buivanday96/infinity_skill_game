import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:infinity_skill_game/features/battle/data/skill_vfx_catalog.dart';
import 'package:infinity_skill_game/game/combat_demo_game.dart';
import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';

/// Decorative (or damaging) burst fixed in world space — used for AOE satellites.
class WorldBurstEffect extends PositionComponent
    with HasGameReference<CombatDemoGame> {
  WorldBurstEffect({
    required this.vfx,
    required Vector2 worldPosition,
    this.onImpact,
    this.onFinished,
    this.sizeScale = 1,
    this.startDelay = 0,
    int? drawPriority,
  }) : super(
          position: worldPosition.clone(),
          anchor: Anchor.bottomCenter,
          priority: drawPriority ?? 520,
        );

  final SkillVfxSpec vfx;
  final void Function()? onImpact;
  final void Function()? onFinished;
  final double sizeScale;
  final double startDelay;

  SpriteAnimationComponent? _strikeSprite;
  double _impactAt = 0.55;
  double _elapsed = 0;
  double _delayLeft = 0;
  bool _started = false;
  bool _impacted = false;
  bool _finished = false;

  @override
  Future<void> onLoad() async {
    _delayLeft = startDelay;
    if (_delayLeft <= 0) {
      await _begin();
    }
  }

  Future<void> _begin() async {
    if (_started || _finished) return;
    _started = true;

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
      size: Vector2(vfx.strikeWidth, vfx.strikeHeight) * sizeScale,
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
    if (_finished) return;

    if (!_started) {
      _delayLeft -= dt;
      if (_delayLeft <= 0) {
        unawaited(_begin());
      }
      return;
    }

    if (_impacted) return;
    _elapsed += dt;
    if (_elapsed >= _impactAt) {
      unawaited(_resolveImpact());
    }
  }

  Future<void> _resolveImpact() async {
    if (_impacted || _finished) return;
    _impacted = true;
    onImpact?.call();
    await _playSplash();
  }

  Future<void> _playSplash() async {
    final splashEntry = vfx.hitEffect;
    if (splashEntry == null) {
      _finish();
      return;
    }

    final splash = await _loadAnim(splashEntry);
    final splashSprite = SpriteAnimationComponent(
      animation: splash,
      size: Vector2(vfx.splashWidth, vfx.splashHeight) * sizeScale,
      anchor: Anchor.center,
      position: Vector2(0, -vfx.strikeHeight * sizeScale * 0.35),
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

/// Spread offsets around an epicenter for decorative AOE particles.
List<Vector2> aoeParticleOffsets({
  required int count,
  required double radiusPx,
  required math.Random rng,
}) {
  if (count <= 1) return [Vector2.zero()];
  final out = <Vector2>[Vector2.zero()];
  for (var i = 1; i < count; i++) {
    final angle = (i / count) * math.pi * 2 + rng.nextDouble() * 0.4;
    final dist = radiusPx * (0.35 + rng.nextDouble() * 0.55);
    out.add(Vector2(math.cos(angle) * dist, math.sin(angle) * dist * 0.55));
  }
  return out;
}
