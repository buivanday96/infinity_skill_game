import 'package:infinity_skill_game/game/entities/stats.dart';

double dealDamage(Stats atk, Stats def) {
  print("Atk: ${atk.totalAtk}, Def: ${def.totalDef}");
  final damage = atk.totalAtk - def.totalDef;

  return damage < 1 ? 1 : damage;
}
