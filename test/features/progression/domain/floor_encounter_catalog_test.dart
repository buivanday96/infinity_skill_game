import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/shared/domain.dart';

void main() {
  const catalog = FloorEncounterCatalog();

  group('FloorEncounterCatalog', () {
    test('floor 1–2 spawn exactly 2 monsters', () {
      expect(catalog.encounterFor(1).spawns, hasLength(2));
      expect(catalog.encounterFor(2).spawns, hasLength(2));
    });

    test('monster count grows with floor up to 4', () {
      expect(catalog.encounterFor(3).spawns.length, greaterThanOrEqualTo(2));
      expect(catalog.encounterFor(9).spawns.length, lessThanOrEqualTo(4));
      expect(catalog.encounterFor(12).spawns, hasLength(4));
    });

    test('floor 5 has one elite', () {
      final e = catalog.encounterFor(5);
      expect(e.spawns.where((s) => s.rank == MonsterRank.elite), hasLength(1));
      expect(e.spawns.where((s) => s.rank == MonsterRank.boss), isEmpty);
    });

    test('floor 10 has one boss (not elite)', () {
      final e = catalog.encounterFor(10);
      expect(e.spawns.where((s) => s.rank == MonsterRank.boss), hasLength(1));
      expect(e.spawns.where((s) => s.rank == MonsterRank.elite), isEmpty);
    });

    test('same floor is deterministic', () {
      final a = catalog.encounterFor(7);
      final b = catalog.encounterFor(7);
      expect(a.spawns.length, b.spawns.length);
      for (var i = 0; i < a.spawns.length; i++) {
        expect(a.spawns[i].archetype, b.spawns[i].archetype);
        expect(a.spawns[i].rank, b.spawns[i].rank);
      }
    });
  });
}
