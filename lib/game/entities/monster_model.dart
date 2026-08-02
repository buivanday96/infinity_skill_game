import 'package:infinity_skill_game/game/entities/stats.dart';

class MonsterModel {
  String name;
  int level;
  int hp;
  int maxHp;
  Stats stats;

  MonsterModel({
    required this.name,
    required this.level,
    required this.hp,
    required this.maxHp,
    required this.stats,
  });
}
