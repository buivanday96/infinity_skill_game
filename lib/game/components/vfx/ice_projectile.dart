import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:infinity_skill_game/features/battle/data/skill_vfx_catalog.dart';
import 'package:infinity_skill_game/game/combat_demo_game.dart';
import 'package:infinity_skill_game/game/components/combatant_actor.dart';
import 'package:infinity_skill_game/core/debug/debug_hitbox.dart';
import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';

enum _ProjectilePhase { start, flying, hit, ending, done }

/// Skill projectile: optional start → fly → hit → optional ending.
///
/// Used by Ice Bolt, Water Ball, and future projectile skills.
class IceProjectile extends SpriteAnimationComponent
    with HasGameReference<CombatDemoGame>, DebugHitbox {
  IceProjectile({
    required this.vfx,
    required Vector2 spawn,
    required this.target,
    required this.onImpact,
    this.onFinished,
  }) : super(
          position: spawn.clone(),
          size: vfx.projectileSize.clone(),
          anchor: Anchor.center,
          // Above typical combatant Y-priorities while in flight.
          priority: 500,
        );

  final SkillVfxSpec vfx;
  final CombatantActor target;
  final void Function() onImpact;
  final void Function()? onFinished;

  SpriteAnimation? _start;
  late SpriteAnimation _flying;
  SpriteAnimation? _hit;
  SpriteAnimation? _ending;

  _ProjectilePhase _phase = _ProjectilePhase.start;
  bool _impacted = false;

  @override
  bool get showHitbox => game.debugFlags.value.hitbox;

  @override
  bool get showCollision => game.debugFlags.value.collision;

  @override
  bool get showAction => false;

  @override
  Color get hitboxColor => const Color(0xFF40C4FF);

  @override
  Rect get localHitbox => const HitboxInset(
        left: 0.2,
        top: 0.25,
        right: 0.15,
        bottom: 0.25,
      ).toLocalRect(size);

  @override
  Future<void> onLoad() async {
    final flyEntry = vfx.projectileFly;
    if (flyEntry == null) {
      onFinished?.call();
      removeFromParent();
      return;
    }

    if (vfx.projectileStart != null) {
      _start = await _load(vfx.projectileStart!, loop: false);
    }
    _flying = await _load(flyEntry, loop: true);
    if (vfx.hitEffect != null) {
      _hit = await _load(vfx.hitEffect!, loop: false);
    }
    if (vfx.endEffect != null) {
      _ending = await _load(vfx.endEffect!, loop: false);
    }

    if (_start != null) {
      _setPhase(_ProjectilePhase.start);
    } else {
      _setPhase(_ProjectilePhase.flying);
    }
  }

  Future<SpriteAnimation> _load(AsepriteEntry entry, {required bool loop}) async {
    final result = await loadAsepriteAnimation(
      entry: entry,
      images: game.images,
      loop: loop,
    );
    return result.animation;
  }

  void _setPhase(_ProjectilePhase phase) {
    _phase = phase;
    switch (phase) {
      case _ProjectilePhase.start:
        animation = _start;
        animationTicker?.reset();
        animationTicker?.onComplete = () {
          if (_phase == _ProjectilePhase.start) {
            _setPhase(_ProjectilePhase.flying);
          }
        };
      case _ProjectilePhase.flying:
        animation = _flying;
        animationTicker?.reset();
        animationTicker?.onComplete = null;
      case _ProjectilePhase.hit:
        if (_hit == null) {
          _finishAfterHit();
          return;
        }
        animation = _hit;
        animationTicker?.reset();
        animationTicker?.onComplete = () {
          if (_phase == _ProjectilePhase.hit) {
            if (_ending != null) {
              _setPhase(_ProjectilePhase.ending);
            } else {
              _complete();
            }
          }
        };
      case _ProjectilePhase.ending:
        animation = _ending;
        animationTicker?.reset();
        animationTicker?.onComplete = () {
          if (_phase == _ProjectilePhase.ending) {
            _complete();
          }
        };
      case _ProjectilePhase.done:
        break;
    }
  }

  void _finishAfterHit() {
    if (_ending != null) {
      _setPhase(_ProjectilePhase.ending);
    } else {
      _complete();
    }
  }

  void _complete() {
    _phase = _ProjectilePhase.done;
    onFinished?.call();
    removeFromParent();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_phase != _ProjectilePhase.flying) return;

    if (target.isMounted) {
      priority = target.priority + 50;
    }

    final aim = target.hitboxCenter;
    final dx = aim.x - position.x;
    final dy = aim.y - position.y;
    final dist = math.sqrt(dx * dx + dy * dy);

    if (dist > 0.001) {
      final step = math.min(vfx.projectileSpeed * dt, dist);
      position.x += (dx / dist) * step;
      position.y += (dy / dist) * step;
      final aimAngle = math.atan2(dy, dx);
      angle = vfx.projectileFacesLeft ? aimAngle + math.pi : aimAngle;
    }

    if (target.isMounted && absoluteHitbox().overlaps(target.absoluteHitbox())) {
      _resolveImpact();
      return;
    }

    if (position.x < -40 ||
        position.x > game.size.x + 40 ||
        position.y < -40 ||
        position.y > game.size.y + 40) {
      _setPhase(_ProjectilePhase.hit);
    }
  }

  void _resolveImpact() {
    if (_impacted) return;
    _impacted = true;
    _snapHitVfxToTargetCollision();
    onImpact();
    _setPhase(_ProjectilePhase.hit);
  }

  /// Pin hit / end VFX on the monster body center, drawn above the sprite.
  void _snapHitVfxToTargetCollision() {
    if (target.isMounted) {
      position.setFrom(target.hitboxCenter);
      // Combatants use Y as priority (~hundreds); stay above the target.
      priority = target.priority + 50;
    }
    angle = 0;
  }
}
