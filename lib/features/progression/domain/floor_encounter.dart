import 'package:infinity_skill_game/features/monster/domain/monster_model.dart';

/// Which factory / sprite kit to use when spawning a monster.
enum MonsterArchetype {
  slime,
  golem,
  flyingDemon,
}

/// One monster slot in a floor encounter.
class MonsterSpawnSpec {
  const MonsterSpawnSpec({
    required this.archetype,
    this.rank = MonsterRank.normal,
    this.laneHint = 0,
  });

  final MonsterArchetype archetype;
  final MonsterRank rank;

  /// Preferred vertical lane index (0 = top, 1 = mid, 2 = bot).
  final int laneHint;
}

/// Monsters to spawn for a single dungeon floor (generated on demand).
class FloorEncounter {
  const FloorEncounter({
    required this.floor,
    required this.spawns,
  });

  final int floor;
  final List<MonsterSpawnSpec> spawns;
}
