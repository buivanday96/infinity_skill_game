import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinity_skill_game/game/entities/hero_model.dart';
import 'package:infinity_skill_game/game/entities/monster_model.dart';
import 'package:infinity_skill_game/game/entities/skill_model.dart';
import 'package:infinity_skill_game/game/entities/stats.dart';
import 'package:infinity_skill_game/game/system/combat_system.dart';
import 'package:infinity_skill_game/game/system/skill_system.dart';

class DungeonGame extends FlameGame {
  @override
  FutureOr<void> onLoad() {
    final heroModel = HeroModel(
      name: 'Hero',
      level: 1,
      hp: 50,
      maxHp: 100,
      stats: Stats.baseStats(),
    );
    var hero = HeroComponent(hero: heroModel);

    final monsterModel = MonsterModel(
      name: 'Monster',
      level: 1,
      hp: 50,
      maxHp: 100,
      stats: Stats.baseStats(),
    );
    var monster = MonsterComponent(monster: monsterModel);

    print(heroModel.stats.totalAtk);

    world.add(hero);
    world.add(monster);

    camera.follow(hero);

    print("Monster HP: ${monsterModel.hp}");
    final damage = dealDamage(heroModel.stats, monsterModel.stats);
    monsterModel.hp = (monsterModel.hp - damage.toInt()).clamp(0, monsterModel.maxHp);
    print("Hero dealt $damage damage to Monster");
    print("Monster HP: ${monsterModel.hp}");

    castSkill(SkillModel.atk(), heroModel, monsterModel);
    castSkill(SkillModel.heal(), heroModel, monsterModel);
    return super.onLoad();
  }
}

class HeroComponent extends PositionComponent {
  final HeroModel hero;

  HeroComponent({required this.hero});

  @override
  FutureOr<void> onLoad() {
    size = Vector2(50, 100);
    position = Vector2(100, 100);
    add(HealthBarComponent(hero: hero));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x += 100 * dt;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), Paint()..color = Colors.red);
    super.render(canvas);
  }
}

class HealthBarComponent extends PositionComponent {
  final HeroModel hero;

  HealthBarComponent({required this.hero});
  @override
  FutureOr<void> onLoad() {
    size = Vector2(hero.hp / hero.maxHp * 50, 5);
    position = Vector2(0, -10);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), Paint()..color = Colors.green);
    super.render(canvas);
  }
}

class MonsterComponent extends PositionComponent {
  final MonsterModel monster;

  MonsterComponent({required this.monster});

  @override
  FutureOr<void> onLoad() {
    size = Vector2(50, 100);
    position = Vector2(100, 100);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), Paint()..color = Colors.blue);
    super.render(canvas);
  }
}
