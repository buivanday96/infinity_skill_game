import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:infinity_skill_game/game/battle_effects/enums/damage_type.dart';

/// Builds Flame effect sequences for floating damage text by [DamageType].
class DamageTextAnimation {
  DamageTextAnimation({math.Random? rng}) : _rng = rng ?? math.Random();

  final math.Random _rng;

  /// Applies the type-specific motion to [target] and invokes [onComplete]
  /// when the sequence finishes.
  void play({
    required PositionComponent target,
    required DamageType type,
    required void Function() onComplete,
  }) {
    target.removeAll(target.children.whereType<Effect>());

    final effect = switch (type) {
      DamageType.critical => _critical(onComplete),
      DamageType.heal ||
      DamageType.shield ||
      DamageType.mana =>
        _floatUp(onComplete, rise: 48, duration: 0.85),
      DamageType.miss || DamageType.dodge => _floatUp(
          onComplete,
          rise: 28,
          duration: 0.55,
        ),
      DamageType.gold || DamageType.exp => _floatUp(
          onComplete,
          rise: 40,
          duration: 0.9,
        ),
      DamageType.normal ||
      DamageType.poison ||
      DamageType.burn =>
        _floatUp(onComplete, rise: 42, duration: 0.7),
    };

    target.add(effect);
  }

  Effect _floatUp(
    void Function() onComplete, {
    required double rise,
    required double duration,
  }) {
    final fadeStart = duration * 0.45;
    return CombinedEffect(
      [
        MoveByEffect(
          Vector2(0, -rise),
          EffectController(duration: duration, curve: Curves.easeOut),
        ),
        SequenceEffect([
          OpacityEffect.to(1, EffectController(duration: fadeStart)),
          OpacityEffect.to(
            0,
            EffectController(duration: duration - fadeStart),
          ),
        ]),
      ],
      onComplete: onComplete,
    );
  }

  Effect _critical(void Function() onComplete) {
    final shakeX = (_rng.nextBool() ? 1.0 : -1.0) * 4;
    return SequenceEffect(
      [
        ScaleEffect.to(
          Vector2.all(0.6),
          EffectController(duration: 0),
        ),
        ScaleEffect.to(
          Vector2.all(1.4),
          EffectController(duration: 0.12, curve: Curves.easeOutBack),
        ),
        CombinedEffect([
          MoveByEffect(
            Vector2(0, -52),
            EffectController(duration: 0.55, curve: Curves.easeOut),
          ),
          SequenceEffect([
            MoveByEffect(
              Vector2(shakeX, 0),
              EffectController(duration: 0.05),
            ),
            MoveByEffect(
              Vector2(-shakeX * 2, 0),
              EffectController(duration: 0.08),
            ),
            MoveByEffect(
              Vector2(shakeX, 0),
              EffectController(duration: 0.05),
            ),
          ]),
          SequenceEffect([
            OpacityEffect.to(1, EffectController(duration: 0.25)),
            OpacityEffect.fadeOut(EffectController(duration: 0.4)),
          ]),
          ScaleEffect.to(
            Vector2.all(1.0),
            EffectController(duration: 0.35, curve: Curves.easeOut),
          ),
        ]),
      ],
      onComplete: onComplete,
    );
  }
}
