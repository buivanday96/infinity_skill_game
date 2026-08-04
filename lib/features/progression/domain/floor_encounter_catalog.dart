import 'package:infinity_skill_game/features/monster/domain/monster_model.dart';
import 'package:infinity_skill_game/features/progression/domain/floor_encounter.dart';

/// Builds the encounter for the **current** floor only (no pre-generation).
///
/// Deterministic by floor index so replay / tests stay stable.
class FloorEncounterCatalog {
  const FloorEncounterCatalog();

  FloorEncounter encounterFor(int floor) {
    final f = floor < 1 ? 1 : floor;
    final count = _monsterCount(f);
    final spawns = <MonsterSpawnSpec>[];

    for (var i = 0; i < count; i++) {
      spawns.add(
        MonsterSpawnSpec(
          archetype: _archetypeFor(f, i),
          rank: MonsterRank.normal,
          laneHint: i % 3,
        ),
      );
    }

    // Boss every 10 floors (replaces last spawn). Elite every 5 (when not boss).
    if (f % 10 == 0 && spawns.isNotEmpty) {
      final last = spawns.length - 1;
      spawns[last] = MonsterSpawnSpec(
        archetype: spawns[last].archetype,
        rank: MonsterRank.boss,
        laneHint: spawns[last].laneHint,
      );
    } else if (f % 5 == 0 && spawns.isNotEmpty) {
      final last = spawns.length - 1;
      spawns[last] = MonsterSpawnSpec(
        archetype: spawns[last].archetype,
        rank: MonsterRank.elite,
        laneHint: spawns[last].laneHint,
      );
    }

    return FloorEncounter(floor: f, spawns: spawns);
  }

  /// Floor 1–2: 2 monsters; then grows slowly up to 4.
  static int _monsterCount(int floor) {
    if (floor <= 2) return 2;
    return 2 + (floor ~/ 3).clamp(0, 2);
  }

  static MonsterArchetype _archetypeFor(int floor, int index) {
    if (floor <= 2) return MonsterArchetype.slime;

    // Rotate mix by floor + slot so composition feels varied but deterministic.
    final mix = (floor + index * 2) % 5;
    return switch (mix) {
      0 || 1 => MonsterArchetype.slime,
      2 || 3 => MonsterArchetype.golem,
      _ => MonsterArchetype.flyingDemon,
    };
  }
}
