import 'package:infinity_skill_game/features/stats/domain/modifier_source.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_id.dart';

/// One additive contribution to a single [StatId].
///
/// Final formula (chapter 7):
///   final = (base + sum(flat)) * (1 + sum(percent))
///
/// [percent] is a fraction: `0.15` means +15%.
class StatModifier {
  const StatModifier({
    required this.id,
    required this.stat,
    required this.source,
    this.flat = 0,
    this.percent = 0,
    this.sourceKey,
  });

  /// Unique id for this modifier instance (e.g. `floor_3_atk_pct`).
  final String id;

  final StatId stat;
  final ModifierSource source;

  /// Flat points added before percent is applied.
  final double flat;

  /// Percent multiplier contribution (0.2 = +20%).
  final double percent;

  /// Optional group key so several mods can be removed together
  /// (`equipment:sword_01`, `skill_tree:node_crit`, `buff:rage`).
  final String? sourceKey;

  StatModifier copyWith({
    String? id,
    StatId? stat,
    ModifierSource? source,
    double? flat,
    double? percent,
    String? sourceKey,
  }) {
    return StatModifier(
      id: id ?? this.id,
      stat: stat ?? this.stat,
      source: source ?? this.source,
      flat: flat ?? this.flat,
      percent: percent ?? this.percent,
      sourceKey: sourceKey ?? this.sourceKey,
    );
  }

  @override
  String toString() =>
      'StatModifier($id, $stat, $source, flat=$flat, pct=$percent)';
}
