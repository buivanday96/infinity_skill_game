/// Categories from chapter 9 — data only; effects live in SkillSystem later.
enum SkillCategory {
  heal,
  partyHeal,
  shield,
  buff,
  debuff,
  singleTargetDamage,
  aoeDamage,
  passive,
  ultimate,
}

enum SkillTargetType {
  self,
  ally,
  enemy,
  allAllies,
  allEnemies,
  area,
}

/// Immutable skill definition (catalog / JSON later).
///
/// Shape notes:
/// - [beamCount] = multiple independent rays/projectiles (multi-target shots).
///   This is NOT AOE — each beam picks its own target.
/// - [aoeRadius] = one cast damages everyone in a circle around the epicenter.
/// - [aoeParticleCount] = extra decorative VFX inside that circle (spectacle only).
class SkillDefinition {
  const SkillDefinition({
    required this.id,
    required this.name,
    required this.category,
    this.description = '',
    this.baseCooldown = 5,
    this.baseManaCost = 0,
    this.basePower = 0,
    this.range = 1,

    /// Circle radius in the same units as [range] (0 = single target).
    this.aoeRadius = 0,

    /// Independent skill rays / projectiles per cast (1 = single beam).
    this.beamCount = 1,

    /// Extra AOE VFX copies in the circle (0 = auto from [aoeRadius]).
    this.aoeParticleCount = 0,

    /// Peak lift in world pixels (0 = no knock-up).
    this.knockUp = 0,

    /// Horizontal throw distance in world pixels (0 = no knock-back).
    this.knockBack = 0,

    /// Stun duration in seconds (0 = no stun).
    this.stunDuration = 0,

    /// Freeze duration in seconds (0 = no freeze).
    this.freezeDuration = 0,

    /// Channel / spin duration in seconds (0 = instant cast).
    this.channelDuration = 0,
    this.targetType = SkillTargetType.enemy,
    this.maxRank = 5,
    this.powerPerRank = 0,
    this.cooldownPerRank = 0,
    this.manaCostPerRank = 0,
  });

  final String id;
  final String name;
  final SkillCategory category;
  final String description;

  final double baseCooldown;
  final double baseManaCost;

  /// Damage, heal, or shield amount before combat multipliers.
  final double basePower;

  final double range;

  /// AOE circle radius (range-stat units). `0` = hit primary target only.
  final double aoeRadius;

  /// How many independent beams/projectiles one cast fires.
  final int beamCount;

  /// Decorative particle bursts inside the AOE (0 → derive from radius).
  final int aoeParticleCount;

  /// Visual / combat knock-up height in pixels.
  final double knockUp;

  /// Knock-back travel distance in pixels (away from blast epicenter).
  final double knockBack;

  /// Seconds the target cannot move or act.
  final double stunDuration;

  /// Seconds the target is frozen (cannot move or act; ice tint).
  final double freezeDuration;

  /// Seconds to hold a channelled cast (e.g. spin slash).
  final double channelDuration;

  final SkillTargetType targetType;
  final int maxRank;

  final double powerPerRank;
  final double cooldownPerRank;
  final double manaCostPerRank;

  bool get isAoe => aoeRadius > 0 || category == SkillCategory.aoeDamage || targetType == SkillTargetType.area || targetType == SkillTargetType.allEnemies;

  bool get hasMultiBeam => beamCount > 1;

  bool get hasLaunch => knockUp > 0 || knockBack > 0;

  bool get hasStun => stunDuration > 0;

  bool get hasFreeze => freezeDuration > 0;

  bool get isChannel => channelDuration > 0;

  /// Visual AOE particle count — scales with radius when not set explicitly.
  int get resolvedAoeParticles {
    if (!isAoe || aoeRadius <= 0) return 1;
    if (aoeParticleCount > 0) return aoeParticleCount.clamp(1, 12);
    // Larger radius → more pillars/splashes (min 2, max 8).
    return (1 + (aoeRadius * 1.8).round()).clamp(2, 8);
  }
}

/// Owned / unlocked skill on a combatant — rank can grow via skill tree.
class SkillInstance {
  SkillInstance({
    required this.definition,
    this.rank = 1,
    this.cooldownRemaining = 0,
  });

  final SkillDefinition definition;
  int rank;
  double cooldownRemaining;

  bool get isReady => cooldownRemaining <= 0;
  bool get isPassive => definition.category == SkillCategory.passive;

  double get power => definition.basePower + definition.powerPerRank * (rank - 1);

  double get cooldown => (definition.baseCooldown + definition.cooldownPerRank * (rank - 1)).clamp(0.1, double.infinity);

  double get manaCost => (definition.baseManaCost + definition.manaCostPerRank * (rank - 1)).clamp(0, double.infinity);

  bool get canUpgrade => rank < definition.maxRank;

  void upgrade() {
    if (!canUpgrade) return;
    rank += 1;
  }

  void tickCooldown(double dt) {
    if (cooldownRemaining <= 0) return;
    cooldownRemaining = (cooldownRemaining - dt).clamp(0, cooldown);
  }

  void startCooldown({double cooldownReduction = 0}) {
    final cdr = cooldownReduction.clamp(0.0, 0.8);
    cooldownRemaining = cooldown * (1 - cdr);
  }
}
