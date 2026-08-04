import 'package:infinity_skill_game/features/skill/domain/skill_model.dart';
import 'package:infinity_skill_game/features/stats/domain/combat_stats.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_id.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_modifier.dart';

/// Shared battle identity for heroes and monsters.
///
/// Holds runtime resources (HP / mana / shield) and layered [CombatStats].
/// No combat math lives here — BattleSystem asks for finals only.
abstract class Combatant {
  Combatant({
    required this.id,
    required this.name,
    required this.stats,
    this.level = 1,
    List<SkillInstance>? skills,
    double? currentHp,
    double? currentMana,
    this.currentShield = 0,
  })  : skills = skills ?? [],
        currentHp = currentHp ?? stats.finalOf(StatId.maxHp),
        currentMana = currentMana ?? stats.finalOf(StatId.maxMana);

  final String id;
  String name;
  int level;
  final CombatStats stats;
  final List<SkillInstance> skills;

  double currentHp;
  double currentMana;
  double currentShield;

  bool get isAlive => currentHp > 0;
  bool get isDead => !isAlive;

  double get maxHp => stats.finalOf(StatId.maxHp);
  double get maxMana => stats.finalOf(StatId.maxMana);
  double get attack => stats.finalOf(StatId.attack);
  double get defense => stats.finalOf(StatId.defense);
  double get attackSpeed => stats.finalOf(StatId.attackSpeed);
  double get moveSpeed => stats.finalOf(StatId.moveSpeed);
  double get range => stats.finalOf(StatId.range);
  double get poise => stats.finalOf(StatId.poise);
  double get criticalRate => stats.finalOf(StatId.criticalRate);
  double get criticalDamage => stats.finalOf(StatId.criticalDamage);
  double get cooldownReduction => stats.finalOf(StatId.cooldownReduction);

  /// Seconds between basic attacks from attackSpeed (attacks / second).
  double get basicAttackInterval {
    final spd = attackSpeed <= 0 ? 0.01 : attackSpeed;
    return 1 / spd;
  }

  double get hpRatio => maxHp <= 0 ? 0 : (currentHp / maxHp).clamp(0.0, 1.0);

  void applyModifiers(Iterable<StatModifier> mods) {
    final oldMaxHp = maxHp;
    final oldMaxMana = maxMana;
    stats.addModifiers(mods);
    _syncResourcesAfterMaxChange(oldMaxHp, oldMaxMana);
  }

  void removeModifiersBySourceKey(String sourceKey) {
    final oldMaxHp = maxHp;
    final oldMaxMana = maxMana;
    stats.removeBySourceKey(sourceKey);
    _syncResourcesAfterMaxChange(oldMaxHp, oldMaxMana);
  }

  /// Keep current HP/Mana in sync when max changes (level-up, pick, etc.).
  void _syncResourcesAfterMaxChange(double oldMaxHp, double oldMaxMana) {
    final hpRatio = oldMaxHp <= 0 ? 1.0 : (currentHp / oldMaxHp).clamp(0.0, 1.0);
    final manaRatio =
        oldMaxMana <= 0 ? 1.0 : (currentMana / oldMaxMana).clamp(0.0, 1.0);
    currentHp = maxHp * hpRatio;
    currentMana = maxMana * manaRatio;
    if (currentShield > maxHp) currentShield = maxHp;
  }

  void fullHeal() {
    currentHp = maxHp;
    currentMana = maxMana;
    currentShield = 0;
  }

  void takeDamage(double amount) {
    if (amount <= 0 || isDead) return;
    var remaining = amount;
    // Shield absorbs first; leftover hits HP.
    if (currentShield > 0) {
      final absorbed = remaining < currentShield ? remaining : currentShield;
      currentShield = (currentShield - absorbed).clamp(0, maxHp);
      remaining -= absorbed;
    }
    if (remaining > 0) {
      currentHp = (currentHp - remaining).clamp(0, maxHp);
    }
  }

  void heal(double amount) {
    if (amount <= 0 || isDead) return;
    currentHp = (currentHp + amount).clamp(0, maxHp);
  }

  void spendMana(double amount) {
    currentMana = (currentMana - amount).clamp(0, maxMana);
  }

  void restoreMana(double amount) {
    currentMana = (currentMana + amount).clamp(0, maxMana);
  }

  void addShield(double amount) {
    if (amount <= 0) return;
    currentShield = (currentShield + amount).clamp(0, maxHp);
  }

  SkillInstance? skillById(String skillId) {
    for (final s in skills) {
      if (s.definition.id == skillId) return s;
    }
    return null;
  }

  void addSkill(SkillInstance skill) {
    final existing = skillById(skill.definition.id);
    if (existing != null) {
      if (skill.rank > existing.rank) existing.rank = skill.rank;
      return;
    }
    skills.add(skill);
  }
}
