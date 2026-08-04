import 'package:infinity_skill_game/features/battle/domain/combatant.dart';
import 'package:infinity_skill_game/features/progression/domain/growth_curve.dart';
import 'package:infinity_skill_game/features/skill/domain/skill_model.dart';
import 'package:infinity_skill_game/features/stats/domain/combat_stats.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_id.dart';

enum HeroClass {
  tank,
  archer,
  mage,
  healer,
}

class HeroModel extends Combatant {
  HeroModel({
    required super.id,
    required super.name,
    required this.heroClass,
    required super.stats,
    super.level,
    super.skills,
    super.currentHp,
    super.currentMana,
    super.currentShield,
    this.exp = 0,
    this.skillPoints = 0,
    Set<String>? unlockedSkillTreeNodes,
  }) : unlockedSkillTreeNodes = unlockedSkillTreeNodes ?? {};

  final HeroClass heroClass;
  int exp;
  int skillPoints;
  final Set<String> unlockedSkillTreeNodes;

  int expToNextLevel(GrowthCurve curve) => curve.expRequiredFor(level + 1);

  /// Returns `true` if at least one level was gained.
  bool gainExp(int amount, GrowthCurve curve) {
    if (amount <= 0) return false;
    exp += amount;
    var leveled = false;
    while (exp >= curve.expRequiredFor(level + 1)) {
      exp -= curve.expRequiredFor(level + 1);
      levelUp(curve);
      leveled = true;
    }
    return leveled;
  }

  void levelUp(GrowthCurve curve) {
    final oldMaxHp = maxHp;
    final oldMaxMana = maxMana;
    level += 1;
    skillPoints += curve.skillPointsPerLevel;
    curve.applyLevelGrowth(stats, level);
    _preserveResourceRatio(oldMaxHp, oldMaxMana);
  }

  void _preserveResourceRatio(double oldMaxHp, double oldMaxMana) {
    final hpRatio = oldMaxHp <= 0 ? 1.0 : (currentHp / oldMaxHp).clamp(0.0, 1.0);
    final manaRatio =
        oldMaxMana <= 0 ? 1.0 : (currentMana / oldMaxMana).clamp(0.0, 1.0);
    currentHp = maxHp * hpRatio;
    currentMana = maxMana * manaRatio;
  }

  /// Starter knight-like defaults — replace with data-driven catalogs later.
  factory HeroModel.knight({String id = 'hero_knight', String name = 'Knight'}) {
    final stats = CombatStats(
      bases: {
        StatId.maxHp: 500,
        StatId.maxMana: 80,
        StatId.attack: 40,
        StatId.magicAttack: 10,
        StatId.defense: 25,
        StatId.magicDefense: 15,
        StatId.attackSpeed: 1.0,
        StatId.moveSpeed: 120,
        StatId.criticalRate: 0.05,
        StatId.criticalDamage: 1.5,
        StatId.healPower: 0,
        StatId.shieldPower: 0.1,
        StatId.cooldownReduction: 0,
        StatId.threat: 100,
        StatId.range: 1,
        StatId.accuracy: 0.95,
        StatId.evasion: 0.05,
        StatId.poise: 120,
      },
    );

    return HeroModel(
      id: id,
      name: name,
      heroClass: HeroClass.tank,
      stats: stats,
      skills: [
        SkillInstance(definition: _slash),
        SkillInstance(definition: whirlwind),
        SkillInstance(definition: _guard),
      ],
    );
  }

  factory HeroModel.mage({String id = 'hero_mage', String name = 'Mage'}) {
    final stats = CombatStats(
      bases: {
        StatId.maxHp: 280,
        StatId.maxMana: 200,
        StatId.attack: 12,
        StatId.magicAttack: 55,
        StatId.defense: 10,
        StatId.magicDefense: 30,
        // x3 base (0.9 → 2.7) so the wizard casts / swings quickly.
        StatId.attackSpeed: 2.7,
        StatId.moveSpeed: 110,
        StatId.criticalRate: 0.08,
        StatId.criticalDamage: 1.6,
        StatId.healPower: 0,
        StatId.shieldPower: 0,
        StatId.cooldownReduction: 0.05,
        StatId.threat: 40,
        StatId.range: 4,
        StatId.accuracy: 0.92,
        StatId.evasion: 0.08,
        StatId.poise: 70,
      },
    );

    return HeroModel(
      id: id,
      name: name,
      heroClass: HeroClass.mage,
      stats: stats,
      skills: [
        SkillInstance(definition: iceBolt),
        SkillInstance(definition: thunderStrike),
        SkillInstance(definition: waterBall),
        SkillInstance(definition: waterBlast),
        SkillInstance(definition: windBreath),
        SkillInstance(definition: _manaShield),
      ],
    );
  }
}

const _slash = SkillDefinition(
  id: 'slash',
  name: 'Slash',
  category: SkillCategory.singleTargetDamage,
  description: 'Basic melee strike.',
  baseCooldown: 3,
  baseManaCost: 0,
  basePower: 30,
  range: 1,
  powerPerRank: 8,
);

const _guard = SkillDefinition(
  id: 'guard',
  name: 'Guard',
  category: SkillCategory.shield,
  description: 'Raise a temporary shield.',
  baseCooldown: 8,
  baseManaCost: 15,
  basePower: 320,
  targetType: SkillTargetType.self,
  range: 0,
  powerPerRank: 40,
);

/// Knight spin — loop attack4 for [channelDuration], damaging nearby foes.
const whirlwind = SkillDefinition(
  id: 'whirlwind',
  name: 'Whirlwind',
  category: SkillCategory.aoeDamage,
  description: 'Spin continuously for 5s, slashing all nearby enemies.',
  baseCooldown: 12,
  baseManaCost: 25,
  basePower: 22,
  range: 1.2,
  aoeRadius: 1.6,
  channelDuration: 5,
  targetType: SkillTargetType.area,
  powerPerRank: 5,
);

/// Wizard ice — multi-beam freeze shards.
const iceBolt = SkillDefinition(
  id: 'ice_bolt',
  name: 'Ice Bolt',
  category: SkillCategory.singleTargetDamage,
  description:
      'Hurl multiple ice shards that damage and freeze enemies.',
  baseCooldown: 3,
  baseManaCost: 18,
  basePower: 48,
  range: 5,
  beamCount: 3,
  freezeDuration: 2.0,
  powerPerRank: 12,
);

/// Wizard thunder — multi-bolt strike that stuns.
const thunderStrike = SkillDefinition(
  id: 'thunder_strike',
  name: 'Thunder Strike',
  category: SkillCategory.singleTargetDamage,
  description:
      'Call several lightning bolts that damage and stun enemies.',
  baseCooldown: 3,
  baseManaCost: 22,
  basePower: 62,
  range: 5,
  beamCount: 2,
  stunDuration: 1.6,
  powerPerRank: 14,
);

/// Wizard water — projectile using waterball sheets.
const waterBall = SkillDefinition(
  id: 'water_ball',
  name: 'Water Ball',
  category: SkillCategory.singleTargetDamage,
  description: 'Launch a spinning orb of water at a single enemy.',
  baseCooldown: 3,
  baseManaCost: 16,
  basePower: 44,
  range: 5,
  powerPerRank: 11,
);

/// Wizard water AOE — wide blast with extra pillars for spectacle.
const waterBlast = SkillDefinition(
  id: 'water_blast',
  name: 'Water Blast',
  category: SkillCategory.aoeDamage,
  description:
      'Erupt water pillars in a circle — damage, knock-up, and knock-back.',
  baseCooldown: 3,
  baseManaCost: 28,
  basePower: 38,
  range: 5,
  aoeRadius: 2.8,
  aoeParticleCount: 5,
  knockUp: 78,
  knockBack: 96,
  targetType: SkillTargetType.area,
  powerPerRank: 10,
);

/// Wizard wind — gust that shoves enemies away and stuns them.
const windBreath = SkillDefinition(
  id: 'wind_breath',
  name: 'Wind Breath',
  category: SkillCategory.singleTargetDamage,
  description:
      'Unleash a wind gust that knocks enemies far back and stuns them.',
  baseCooldown: 3,
  baseManaCost: 20,
  basePower: 40,
  range: 4.5,
  beamCount: 2,
  knockBack: 150,
  knockUp: 28,
  stunDuration: 1.3,
  powerPerRank: 10,
);

const _manaShield = SkillDefinition(
  id: 'mana_shield',
  name: 'Mana Shield',
  category: SkillCategory.shield,
  description: 'Convert mana into a protective barrier.',
  baseCooldown: 14,
  baseManaCost: 25,
  basePower: 100,
  targetType: SkillTargetType.self,
  range: 0,
  powerPerRank: 25,
);
