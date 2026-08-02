import 'package:infinity_skill_game/game/entities/stats.dart';

class HeroModel {
  String name;
  int level;
  int hp;
  int maxHp;
  Stats stats;

  HeroModel({
    required this.name,
    required this.level,
    required this.hp,
    required this.maxHp,
    required this.stats,
  });
}
