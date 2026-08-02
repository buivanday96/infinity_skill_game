class Stats {
  double atk;
  double flatAtk;
  double percentageAtk;
  double def;
  double flatDef;
  double percentageDef;
  double hp;
  double flatHp;
  double percentageHp;
  double energy;
  double flatEnergy;
  double percentageEnergy;
  double spd;
  double flatSpd;
  double percentageSpd;
  double critChance;
  double flatCritChance;
  double percentageCritChance;
  double critDamage;
  double flatCritDamage;
  double percentageCritDamage;
  double accuracy;
  double flatAccuracy;
  double percentageAccuracy;
  double evasion;
  double flatEvasion;
  double percentageEvasion;
  Stats({
    this.atk = 0,
    this.flatAtk = 0,
    this.percentageAtk = 0,
    this.def = 0,
    this.flatDef = 0,
    this.percentageDef = 0,
    this.hp = 0,
    this.flatHp = 0,
    this.percentageHp = 0,
    this.energy = 0,
    this.flatEnergy = 0,
    this.percentageEnergy = 0,
    this.spd = 0,
    this.flatSpd = 0,
    this.percentageSpd = 0,
    required this.critChance,
    this.flatCritChance = 0,
    this.percentageCritChance = 0,
    this.critDamage = 0,
    this.flatCritDamage = 0,
    this.percentageCritDamage = 0,
    this.accuracy = 0,
    this.flatAccuracy = 0,
    this.percentageAccuracy = 0,
    this.evasion = 0,
    this.flatEvasion = 0,
    this.percentageEvasion = 0,
  });

  double get totalEnergy => energy + flatEnergy + ((energy + flatEnergy) * percentageEnergy);
  double get totalAtk => atk + flatAtk + ((atk + flatAtk) * percentageAtk);
  double get totalDef => def + flatDef + ((def + flatDef) * percentageDef);
  double get totalHp => hp + flatHp + ((hp + flatHp) * percentageHp);
  double get totalSpd => spd + flatSpd + ((spd + flatSpd) * percentageSpd);
  double get totalCritChance => critChance + flatCritChance + ((critChance + flatCritChance) * percentageCritChance);
  double get totalCritDamage => critDamage + flatCritDamage + ((critDamage + flatCritDamage) * percentageCritDamage);
  double get totalAccuracy => accuracy + flatAccuracy + ((accuracy + flatAccuracy) * percentageAccuracy);
  double get totalEvasion => evasion + flatEvasion + ((evasion + flatEvasion) * percentageEvasion);

  static Stats baseStats() {
    return Stats(
      atk: 100,
      flatAtk: 60,
      percentageAtk: 0.3,
      def: 1,
      flatDef: 0,
      percentageDef: 0,
      hp: 1,
      flatHp: 1,
      percentageHp: 0,
      energy: 100,
      flatEnergy: 0,
      percentageEnergy: 0,
      spd: 1,
      flatSpd: 1,
      percentageSpd: 0,
      critChance: 1,
      flatCritChance: 1,
      percentageCritChance: 0,
      critDamage: 1,
      flatCritDamage: 1,
      percentageCritDamage: 0,
      accuracy: 1,
      flatAccuracy: 0,
      percentageAccuracy: 0,
      evasion: 1,
      flatEvasion: 1,
      percentageEvasion: 0,
    );
  }
}
