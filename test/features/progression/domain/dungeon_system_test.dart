import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/shared/domain.dart';

void main() {
  group('DungeonSystem', () {
    late DungeonSystem dungeon;

    setUp(() {
      dungeon = DungeonSystem();
    });

    test('startRun begins at floor 1 battling', () {
      final encounter = dungeon.startRun();
      expect(dungeon.floor, 1);
      expect(dungeon.phase, DungeonPhase.battling);
      expect(encounter.floor, 1);
      expect(encounter.spawns, isNotEmpty);
    });

    test('victory → choosing → pick → floor+1 battling', () {
      dungeon.startRun();
      final hero = HeroModel.knight();
      final killed = [
        MonsterModel.slime(id: 'k1')..applyFloorScaling(1),
      ];

      dungeon.onBattleVictory(heroes: [hero], killedMonsters: killed);
      expect(dungeon.phase, DungeonPhase.choosing);
      expect(dungeon.pendingChoices, hasLength(3));

      final choice = dungeon.pendingChoices.first;
      final next = dungeon.pickChoice([hero], choice);
      expect(next, isNotNull);
      expect(dungeon.floor, 2);
      expect(dungeon.phase, DungeonPhase.battling);
      expect(dungeon.pendingChoices, isEmpty);
      expect(next!.floor, 2);
    });

    test('pickChoiceById works', () {
      dungeon.startRun();
      dungeon.onBattleVictory(
        heroes: [HeroModel.knight()],
        killedMonsters: [MonsterModel.slime(id: 'k')],
      );
      final id = dungeon.pendingChoices.first.id;
      final next = dungeon.pickChoiceById([HeroModel.knight()], id);
      expect(next, isNotNull);
      expect(dungeon.floor, 2);
    });

    test('defeat then retry resets to floor 1', () {
      dungeon.startRun();
      dungeon.onBattleVictory(
        heroes: [HeroModel.knight()],
        killedMonsters: [],
      );
      dungeon.pickChoiceById(
        [HeroModel.knight()],
        dungeon.pendingChoices.first.id,
      );
      expect(dungeon.floor, 2);

      // Simulate reaching battling then dying.
      dungeon.onBattleDefeat();
      expect(dungeon.phase, DungeonPhase.defeat);

      final again = dungeon.retry();
      expect(dungeon.floor, 1);
      expect(dungeon.phase, DungeonPhase.battling);
      expect(again.floor, 1);
    });

    test('pickChoice ignored when not choosing', () {
      dungeon.startRun();
      final fake = FloorChoice(
        id: 'atk_pct',
        title: 'x',
        description: 'x',
        kind: FloorChoiceKind.statBoost,
      );
      expect(dungeon.pickChoice([HeroModel.knight()], fake), isNull);
      expect(dungeon.floor, 1);
    });
  });
}
