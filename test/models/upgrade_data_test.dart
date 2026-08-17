import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/models/upgrade_data.dart';
import 'package:infinity_skill_game/models/upgrades.dart';

void main() {
  group('UpgradeData.getCost', () {
    const arrayCost = UpgradeData(
      maxLevel: 2,
      cost: _arrayCost,
      costToken: 'basic',
    );
    const constantCost = UpgradeData(
      maxLevel: 1,
      cost: 5,
      costToken: 'basic',
    );

    test('returns the table value for each purchase level', () {
      expect(arrayCost.getCost(0), 3);
      expect(arrayCost.getCost(1), 50);
    });

    test('returns 0 at maxLevel without invoking the cost table', () {
      expect(arrayCost.getCost(2), 0);
      expect(arrayCost.getCost(-1), 0);
    });

    test('returns a constant int cost below maxLevel', () {
      expect(constantCost.getCost(0), 5);
      expect(constantCost.getCost(1), 0);
    });

    test('does not throw at maxLevel for any generated upgrade', () {
      for (final data in upgradesMap.values) {
        expect(data.getCost(data.maxLevel), 0);
      }
    });
  });
}

int _arrayCost(int level) => [3, 50][level];
