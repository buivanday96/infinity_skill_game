import 'package:infinity_skill_game/features/battle/domain/combatant.dart';
import 'package:infinity_skill_game/features/progression/domain/growth_curve.dart';
import 'package:infinity_skill_game/features/skill/domain/skill_model.dart';
import 'package:infinity_skill_game/features/stats/domain/combat_stats.dart';
import 'package:infinity_skill_game/features/stats/domain/modifier_source.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_id.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_modifier.dart';

enum MonsterRank {
  normal,
  elite,
  boss,
}

class MonsterModel extends Combatant {
  MonsterModel({
    required super.id,
    required super.name,
    required super.stats,
    super.level,
    super.skills,
    super.currentHp,
    super.currentMana,
    super.currentShield,
    this.rank = MonsterRank.normal,
    this.rewardExp = 10,
    this.rewardGold = 5,
  });

  final MonsterRank rank;
  int rewardExp;
  int rewardGold;

  /// Scales base-derived power for the current dungeon floor.
  /// Uses modifiers so removing/rebuilding floors stays clean.
  void applyFloorScaling(int floor, {GrowthCurve? curve}) {
    final c = curve ?? GrowthCurve.standard();
    final mult = c.monsterFloorMultiplier(floor);
    final key = 'floor_scale:$id';

    stats.removeBySourceKey(key);
    stats.addModifiers([
      StatModifier(
        id: '$key:hp',
        stat: StatId.maxHp,
        source: ModifierSource.floorScaling,
        sourceKey: key,
        percent: mult - 1,
      ),
      StatModifier(
        id: '$key:atk',
        stat: StatId.attack,
        source: ModifierSource.floorScaling,
        sourceKey: key,
        percent: mult - 1,
      ),
      StatModifier(
        id: '$key:def',
        stat: StatId.defense,
        source: ModifierSource.floorScaling,
        sourceKey: key,
        percent: (mult - 1) * 0.6,
      ),
    ]);

    // Elites / bosses get an extra permanent-looking bump via same source.
    final rankBonus = switch (rank) {
      MonsterRank.normal => 0.0,
      MonsterRank.elite => 0.5,
      MonsterRank.boss => 1.5,
    };
    if (rankBonus > 0) {
      stats.addModifiers([
        StatModifier(
          id: '$key:rank_hp',
          stat: StatId.maxHp,
          source: ModifierSource.floorScaling,
          sourceKey: key,
          percent: rankBonus,
        ),
        StatModifier(
          id: '$key:rank_atk',
          stat: StatId.attack,
          source: ModifierSource.floorScaling,
          sourceKey: key,
          percent: rankBonus * 0.7,
        ),
      ]);
    }

    rewardExp = (rewardExp * mult * (1 + rankBonus)).round();
    rewardGold = (rewardGold * mult * (1 + rankBonus * 0.5)).round();
    fullHeal();
  }

  factory MonsterModel.slime({
    String id = 'monster_slime',
    String name = 'Slime',
    int level = 1,
    MonsterRank rank = MonsterRank.normal,
  }) {
    final stats = CombatStats(
      bases: {
        StatId.maxHp: 120,
        StatId.maxMana: 0,
        StatId.attack: 18,
        StatId.magicAttack: 0,
        StatId.defense: 6,
        StatId.magicDefense: 4,
        StatId.attackSpeed: 0.8,
        StatId.moveSpeed: 70,
        StatId.criticalRate: 0.02,
        StatId.criticalDamage: 1.3,
        StatId.healPower: 0,
        StatId.shieldPower: 0,
        StatId.cooldownReduction: 0,
        StatId.threat: 10,
        StatId.range: 1,
        StatId.accuracy: 0.9,
        StatId.evasion: 0.02,
        StatId.poise: 55,
      },
    );

    return MonsterModel(
      id: id,
      name: name,
      level: level,
      rank: rank,
      stats: stats,
      rewardExp: 12,
      rewardGold: 4,
      skills: [
        SkillInstance(
          definition: const SkillDefinition(
            id: 'slime_bite',
            name: 'Bite',
            category: SkillCategory.singleTargetDamage,
            baseCooldown: 2.5,
            basePower: 12,
            range: 1,
          ),
        ),
      ],
    );
  }

  factory MonsterModel.golem({
    String id = 'monster_golem',
    String name = 'Golem',
    int level = 1,
    MonsterRank rank = MonsterRank.normal,
  }) {
    final stats = CombatStats(
      bases: {
        StatId.maxHp: 220,
        StatId.maxMana: 0,
        StatId.attack: 26,
        StatId.magicAttack: 0,
        StatId.defense: 18,
        StatId.magicDefense: 10,
        StatId.attackSpeed: 0.7,
        StatId.moveSpeed: 55,
        StatId.criticalRate: 0.03,
        StatId.criticalDamage: 1.35,
        StatId.healPower: 0,
        StatId.shieldPower: 0,
        StatId.cooldownReduction: 0,
        StatId.threat: 30,
        StatId.range: 1,
        StatId.accuracy: 0.92,
        StatId.evasion: 0.01,
        StatId.poise: 160,
      },
    );

    return MonsterModel(
      id: id,
      name: name,
      level: level,
      rank: rank,
      stats: stats,
      rewardExp: 22,
      rewardGold: 10,
      skills: [
        SkillInstance(
          definition: const SkillDefinition(
            id: 'golem_smash',
            name: 'Smash',
            category: SkillCategory.singleTargetDamage,
            baseCooldown: 3,
            basePower: 22,
            range: 1,
          ),
        ),
      ],
    );
  }

  factory MonsterModel.goblin({
    String id = 'monster_goblin',
    String name = 'Goblin',
    int level = 1,
    MonsterRank rank = MonsterRank.normal,
  }) {
    final stats = CombatStats(
      bases: {
        StatId.maxHp: 160,
        StatId.maxMana: 20,
        StatId.attack: 28,
        StatId.magicAttack: 0,
        StatId.defense: 10,
        StatId.magicDefense: 6,
        StatId.attackSpeed: 1.1,
        StatId.moveSpeed: 100,
        StatId.criticalRate: 0.08,
        StatId.criticalDamage: 1.4,
        StatId.healPower: 0,
        StatId.shieldPower: 0,
        StatId.cooldownReduction: 0,
        StatId.threat: 20,
        StatId.range: 1,
        StatId.accuracy: 0.88,
        StatId.evasion: 0.1,
        StatId.poise: 80,
      },
    );

    return MonsterModel(
      id: id,
      name: name,
      level: level,
      rank: rank,
      stats: stats,
      rewardExp: 18,
      rewardGold: 8,
      skills: [
        SkillInstance(
          definition: const SkillDefinition(
            id: 'goblin_stab',
            name: 'Stab',
            category: SkillCategory.singleTargetDamage,
            baseCooldown: 2,
            basePower: 18,
            range: 1,
            powerPerRank: 5,
          ),
        ),
      ],
    );
  }

  /// Ranged flyer — keeps distance and hurls hellfire bolts.
  factory MonsterModel.flyingDemon({
    String id = 'monster_flying_demon',
    String name = 'Flying Demon',
    int level = 1,
    MonsterRank rank = MonsterRank.normal,
  }) {
    final stats = CombatStats(
      bases: {
        StatId.maxHp: 140,
        StatId.maxMana: 40,
        StatId.attack: 22,
        StatId.magicAttack: 28,
        StatId.defense: 8,
        StatId.magicDefense: 12,
        StatId.attackSpeed: 0.95,
        StatId.moveSpeed: 85,
        StatId.criticalRate: 0.06,
        StatId.criticalDamage: 1.4,
        StatId.healPower: 0,
        StatId.shieldPower: 0,
        StatId.cooldownReduction: 0,
        StatId.threat: 16,
        StatId.range: 5,
        StatId.accuracy: 0.9,
        StatId.evasion: 0.12,
        StatId.poise: 70,
      },
    );

    return MonsterModel(
      id: id,
      name: name,
      level: level,
      rank: rank,
      stats: stats,
      rewardExp: 20,
      rewardGold: 9,
      skills: [
        SkillInstance(
          definition: const SkillDefinition(
            id: 'hellfire_bolt',
            name: 'Hellfire Bolt',
            category: SkillCategory.singleTargetDamage,
            description: 'Spit a blazing firebolt at a distant foe.',
            baseCooldown: 1.8,
            baseManaCost: 0,
            basePower: 26,
            range: 5,
            powerPerRank: 6,
          ),
        ),
      ],
    );
  }
}
