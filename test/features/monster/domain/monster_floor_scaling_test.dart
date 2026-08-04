import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/shared/domain.dart';

void main() {
  group('MonsterModel.applyFloorScaling', () {
    test('floor 10 increases HP and attack vs floor 1', () {
      final a = MonsterModel.slime(id: 'a')..applyFloorScaling(1);
      final b = MonsterModel.slime(id: 'b')..applyFloorScaling(10);

      expect(b.maxHp, greaterThan(a.maxHp));
      expect(b.stats.finalOf(StatId.attack), greaterThan(a.stats.finalOf(StatId.attack)));
      expect(b.rewardExp, greaterThan(a.rewardExp));
    });

    test('elite gets extra HP/ATK over normal on same floor', () {
      final normal = MonsterModel.slime(id: 'n', rank: MonsterRank.normal)
        ..applyFloorScaling(5);
      final elite = MonsterModel.slime(id: 'e', rank: MonsterRank.elite)
        ..applyFloorScaling(5);

      expect(elite.maxHp, greaterThan(normal.maxHp));
      expect(
        elite.stats.finalOf(StatId.attack),
        greaterThan(normal.stats.finalOf(StatId.attack)),
      );
    });

    test('boss is stronger than elite on same floor', () {
      final elite = MonsterModel.golem(id: 'e', rank: MonsterRank.elite)
        ..applyFloorScaling(10);
      final boss = MonsterModel.golem(id: 'b', rank: MonsterRank.boss)
        ..applyFloorScaling(10);

      expect(boss.maxHp, greaterThan(elite.maxHp));
    });
  });
}
