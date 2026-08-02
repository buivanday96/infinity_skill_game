enum SkillType {
  heal,
  atk,
  buff,
  debuff,
}

class SkillModel {
  String name;
  int level;
  SkillType type;
  double damage;
  double duration;
  double cooldown;
  double energyCost;
  double energyGain;

  SkillModel({
    this.name = 'Skill',
    this.level = 1,
    this.type = SkillType.atk,
    this.damage = 0,
    this.duration = 0,
    this.cooldown = 0,
    this.energyCost = 0,
    this.energyGain = 0,
  });

  factory SkillModel.heal() {
    return SkillModel(
      name: 'Heal',
      type: SkillType.heal,
      damage: 20,
      duration: 0,
      cooldown: 10,
      energyCost: 10,
      energyGain: 5,
    );
  }
  factory SkillModel.atk() {
    return SkillModel(
      name: 'Atk',
      type: SkillType.atk,
      damage: 10,
      duration: 0,
      cooldown: 5,
      energyCost: 5,
      energyGain: 0,
    );
  }
}
