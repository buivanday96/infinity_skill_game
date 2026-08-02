import 'package:infinity_skill_game/game/entities/hero_model.dart';
import 'package:infinity_skill_game/game/entities/monster_model.dart';
import 'package:infinity_skill_game/game/entities/skill_model.dart';

void castSkill(SkillModel skill, HeroModel atk, MonsterModel def) {
  switch (skill.type) {
    case SkillType.heal:
      final damage = skill.damage;
      final newHp = (atk.hp + damage).clamp(0, atk.maxHp);
      atk.hp = newHp.toInt();
      print("Hero healed $damage HP");
      print("Hero HP: ${atk.hp}");
      break;
    case SkillType.atk:
      final damage = skill.damage;
      final newHp = (def.hp - damage).clamp(0, def.maxHp);
      def.hp = newHp.toInt();
      print("Monster took $damage damage");
      print("Monster HP: ${def.hp}");
      break;
    case SkillType.buff:
      final duration = skill.duration;
      final cooldown = skill.cooldown;
      final energyCost = skill.energyCost;
      final energyGain = skill.energyGain;
      print("Hero gained $energyGain energy");
      print("Hero Energy: ${atk.stats.totalEnergy}");
      break;
    case SkillType.debuff:
      final duration = skill.duration;
      final cooldown = skill.cooldown;
      final energyCost = skill.energyCost;
      final energyGain = skill.energyGain;
      print("Monster lost $energyGain energy");
      print("Monster Energy: ${def.stats.totalEnergy}");
      break;
  }
}
