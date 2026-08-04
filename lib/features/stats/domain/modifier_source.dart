/// Where a [StatModifier] comes from.
///
/// Enables remove-by-source (buff expire, unequip, respec skill tree)
/// without touching base stats.
enum ModifierSource {
  /// Permanent growth baked into base on level-up (via growth formula).
  levelUp,

  /// Roguelike pick after clearing a floor (Infinite Skill choice).
  floorChoice,

  /// Persistent unlock / rank from the skill tree.
  skillTree,

  /// Equipped gear.
  equipment,

  /// Temporary combat buff / debuff.
  buff,

  /// Passive from class or unlocked skill.
  passive,

  /// Floor difficulty / elite / boss scaling for monsters.
  floorScaling,
}
