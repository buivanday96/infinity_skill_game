import 'package:flame/components.dart';
import 'package:infinity_skill_game/game/battle_effects/enums/damage_type.dart';

/// Payload for one floating damage / status text spawn.
///
/// No Color or Font — [DamageType] drives style via [DamageTextStyleResolver].
class DamageTextData {
  const DamageTextData({
    required this.text,
    required this.type,
    required this.worldPosition,
    this.delay = 0,
    this.randomOffset = true,
  });

  final String text;
  final DamageType type;
  final Vector2 worldPosition;

  /// Seconds before the text becomes visible and animates.
  final double delay;

  /// When true, apply a small XY jitter so stacked hits do not overlap.
  final bool randomOffset;
}
