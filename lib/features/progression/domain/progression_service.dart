import 'dart:math' as math;

import 'package:infinity_skill_game/features/hero/domain/hero_model.dart';
import 'package:infinity_skill_game/features/monster/domain/monster_model.dart';
import 'package:infinity_skill_game/features/progression/domain/floor_choice.dart';
import 'package:infinity_skill_game/features/progression/domain/floor_encounter.dart';
import 'package:infinity_skill_game/features/progression/domain/growth_curve.dart';
import 'package:infinity_skill_game/features/progression/domain/skill_tree.dart';

/// Coordinates level-up, floor picks, and skill-tree unlocks.
///
/// Keep UI / Flame out of this class — call from dungeon / battle flow only.
class ProgressionService {
  ProgressionService({
    GrowthCurve? growth,
    FloorChoiceCatalog? floorChoices,
    SkillTree? skillTree,
  })  : growth = growth ?? GrowthCurve.standard(),
        floorChoices = floorChoices ?? const FloorChoiceCatalog(),
        skillTree = skillTree ?? SkillTree.starter();

  final GrowthCurve growth;
  final FloorChoiceCatalog floorChoices;
  final SkillTree skillTree;

  bool grantExp(HeroModel hero, int amount) => hero.gainExp(amount, growth);

  List<FloorChoice> offerFloorChoices(
    int floor, {
    int count = 3,
    math.Random? rng,
  }) =>
      floorChoices.offerForFloor(floor, count: count, rng: rng);

  void pickFloorChoice(HeroModel hero, FloorChoice choice, int floor) {
    choice.applyTo(hero, floor: floor);
  }

  bool unlockSkillTreeNode(HeroModel hero, String nodeId) =>
      skillTree.unlock(hero, nodeId);

  /// Spawns a monster already scaled for [floor].
  ///
  /// [factory] should create the base archetype (including [MonsterRank]).
  MonsterModel spawnScaled({
    required MonsterModel Function() factory,
    required int floor,
  }) {
    final monster = factory();
    monster.applyFloorScaling(floor, curve: growth);
    return monster;
  }

  /// Builds a scaled monster from archetype + rank for the given [floor].
  MonsterModel spawnFromArchetype({
    required MonsterArchetype archetype,
    required int floor,
    MonsterRank rank = MonsterRank.normal,
    String? id,
  }) {
    final resolvedId = id ?? '${archetype.name}_f${floor}_${rank.name}';
    return spawnScaled(
      floor: floor,
      factory: () => switch (archetype) {
        MonsterArchetype.slime => MonsterModel.slime(
            id: resolvedId,
            rank: rank,
          ),
        MonsterArchetype.golem => MonsterModel.golem(
            id: resolvedId,
            rank: rank,
          ),
        MonsterArchetype.flyingDemon => MonsterModel.flyingDemon(
            id: resolvedId,
            rank: rank,
          ),
      },
    );
  }
}
