/// All battle-relevant stats shared by heroes and monsters.
///
/// Combat always reads [CombatStats.finalOf]; progression sources never
/// mutate base values directly — they add [StatModifier]s instead.
enum StatId {
  maxHp,
  maxMana,
  attack,
  magicAttack,
  defense,
  magicDefense,
  attackSpeed,
  moveSpeed,
  criticalRate,
  criticalDamage,
  healPower,
  shieldPower,
  cooldownReduction,
  threat,
  range,
  accuracy,
  evasion,

  /// Max poise — hits build stagger; break → hurt/stun instead of every flinch.
  poise,
}
