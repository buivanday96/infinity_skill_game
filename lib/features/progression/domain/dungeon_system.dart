import 'package:infinity_skill_game/features/hero/domain/hero_model.dart';
import 'package:infinity_skill_game/features/monster/domain/monster_model.dart';
import 'package:infinity_skill_game/features/progression/domain/floor_choice.dart';
import 'package:infinity_skill_game/features/progression/domain/floor_encounter.dart';
import 'package:infinity_skill_game/features/progression/domain/floor_encounter_catalog.dart';
import 'package:infinity_skill_game/features/progression/domain/progression_service.dart';

/// High-level dungeon run phase — battle reports outcomes; UI only renders.
enum DungeonPhase {
  battling,
  choosing,
  defeat,
}

/// Coordinates floor loop: encounter → battle → floor choice → next floor.
///
/// Keep Flame / Flutter out of this class (chapter 11).
class DungeonSystem {
  DungeonSystem({
    ProgressionService? progression,
    FloorEncounterCatalog? encounters,
  })  : progression = progression ?? ProgressionService(),
        encounters = encounters ?? const FloorEncounterCatalog();

  final ProgressionService progression;
  final FloorEncounterCatalog encounters;

  int floor = 1;
  DungeonPhase phase = DungeonPhase.battling;
  List<FloorChoice> pendingChoices = const [];
  FloorEncounter? currentEncounter;

  /// Starts (or restarts) a run at floor 1.
  FloorEncounter startRun() {
    floor = 1;
    phase = DungeonPhase.battling;
    pendingChoices = const [];
    currentEncounter = encounters.encounterFor(floor);
    return currentEncounter!;
  }

  /// Called when all monsters are dead. Grants EXP then offers floor choices.
  void onBattleVictory({
    required List<HeroModel> heroes,
    required List<MonsterModel> killedMonsters,
  }) {
    if (phase != DungeonPhase.battling) return;

    var totalExp = 0;
    for (final m in killedMonsters) {
      totalExp += m.rewardExp;
    }
    if (heroes.isNotEmpty && totalExp > 0) {
      final share = (totalExp / heroes.length).ceil();
      for (final hero in heroes) {
        progression.grantExp(hero, share);
      }
    }

    pendingChoices = progression.offerFloorChoices(floor);
    phase = DungeonPhase.choosing;
  }

  /// Applies [choice] to every living hero, advances floor, returns next encounter.
  FloorEncounter? pickChoice(List<HeroModel> heroes, FloorChoice choice) {
    if (phase != DungeonPhase.choosing) return null;
    if (!pendingChoices.any((c) => c.id == choice.id)) return null;

    for (final hero in heroes) {
      progression.pickFloorChoice(hero, choice, floor);
    }

    floor += 1;
    pendingChoices = const [];
    phase = DungeonPhase.battling;
    currentEncounter = encounters.encounterFor(floor);
    return currentEncounter;
  }

  /// Looks up a pending choice by id and applies it.
  FloorEncounter? pickChoiceById(List<HeroModel> heroes, String choiceId) {
    FloorChoice? match;
    for (final c in pendingChoices) {
      if (c.id == choiceId) {
        match = c;
        break;
      }
    }
    if (match == null) return null;
    return pickChoice(heroes, match);
  }

  void onBattleDefeat() {
    if (phase != DungeonPhase.battling) return;
    phase = DungeonPhase.defeat;
    pendingChoices = const [];
  }

  /// Full run reset — caller must rebuild hero models.
  FloorEncounter retry() => startRun();
}
