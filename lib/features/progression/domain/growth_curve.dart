import 'package:infinity_skill_game/features/stats/domain/combat_stats.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_id.dart';

/// Tunable growth formulas — never hardcode balance inside Hero/Monster.
///
/// Level-up grows the **base** layer.
/// Floor / skill-tree / buffs grow via modifiers elsewhere.
class GrowthCurve {
  const GrowthCurve({
    required this.baseExp,
    required this.expGrowth,
    required this.skillPointsPerLevel,
    required this.perLevelFlat,
    required this.monsterFloorBase,
    required this.monsterFloorGrowth,
  });

  /// EXP needed for level 2.
  final int baseExp;

  /// EXP(level) = baseExp * growth^(level-2) for level >= 2.
  final double expGrowth;

  final int skillPointsPerLevel;

  /// Flat base increases applied each time the hero reaches [newLevel].
  final Map<StatId, double> perLevelFlat;

  /// Monster power at floor 1.
  final double monsterFloorBase;

  /// Multiplier grows roughly exponentially with floor.
  final double monsterFloorGrowth;

  factory GrowthCurve.standard() {
    return const GrowthCurve(
      baseExp: 100,
      expGrowth: 1.35,
      skillPointsPerLevel: 1,
      perLevelFlat: {
        StatId.maxHp: 35,
        StatId.maxMana: 8,
        StatId.attack: 4,
        StatId.magicAttack: 3,
        StatId.defense: 2,
        StatId.magicDefense: 2,
        StatId.attackSpeed: 0.02,
        StatId.moveSpeed: 1,
        StatId.criticalRate: 0.002,
        StatId.threat: 2,
      },
      monsterFloorBase: 1.0,
      monsterFloorGrowth: 1.08,
    );
  }

  int expRequiredFor(int level) {
    if (level <= 1) return 0;
    // level 2 → baseExp; thereafter geometric.
    var need = baseExp.toDouble();
    for (var l = 3; l <= level; l++) {
      need *= expGrowth;
    }
    return need.round();
  }

  /// Applies flat base growth for reaching [newLevel].
  void applyLevelGrowth(CombatStats stats, int newLevel) {
    if (newLevel <= 1) return;
    for (final entry in perLevelFlat.entries) {
      stats.addBase(entry.key, entry.value);
    }
  }

  /// Floor 1 → ~1.0, floor 10 → ~2.0, floor 20 → ~4.3 (with growth 1.08).
  double monsterFloorMultiplier(int floor) {
    final f = floor < 1 ? 1 : floor;
    return monsterFloorBase * _pow(monsterFloorGrowth, f - 1);
  }

  static double _pow(double base, int exp) {
    var r = 1.0;
    for (var i = 0; i < exp; i++) {
      r *= base;
    }
    return r;
  }
}
