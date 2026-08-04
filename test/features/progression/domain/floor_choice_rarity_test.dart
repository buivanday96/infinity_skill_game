import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/shared/domain.dart';

void main() {
  group('FloorChoiceRarity', () {
    test('power multiplies upward with rarity', () {
      expect(
        FloorChoiceRarity.legendary.powerMultiplier,
        greaterThan(FloorChoiceRarity.epic.powerMultiplier),
      );
      expect(
        FloorChoiceRarity.epic.powerMultiplier,
        greaterThan(FloorChoiceRarity.rare.powerMultiplier),
      );
      expect(
        FloorChoiceRarity.rare.powerMultiplier,
        greaterThan(FloorChoiceRarity.common.powerMultiplier),
      );
    });

    test('each rarity has distinct accent color', () {
      final colors = FloorChoiceRarity.values.map((r) => r.accentArgb).toSet();
      expect(colors.length, FloorChoiceRarity.values.length);
    });
  });

  group('FloorChoiceTemplate.materialize', () {
    test('legendary attack boost is stronger than common', () {
      const tpl = FloorChoiceTemplate(
        id: 'atk_pct',
        kind: FloorChoiceKind.statBoost,
        description: 'atk',
        stat: StatId.attack,
        basePercent: 0.10,
      );
      final common = tpl.materialize(FloorChoiceRarity.common);
      final legendary = tpl.materialize(FloorChoiceRarity.legendary);

      expect(common.modifiers.single.percent, closeTo(0.10, 0.001));
      expect(
        legendary.modifiers.single.percent,
        closeTo(0.10 * FloorChoiceRarity.legendary.powerMultiplier, 0.001),
      );
      expect(legendary.rarity, FloorChoiceRarity.legendary);
      expect(legendary.id, 'atk_pct:legendary');
      expect(legendary.title, contains('%'));
    });

    test('heal scales with rarity but caps at 100%', () {
      const tpl = FloorChoiceTemplate(
        id: 'mend',
        kind: FloorChoiceKind.heal,
        description: 'heal',
        baseHealPercent: 0.28,
      );
      final common = tpl.materialize(FloorChoiceRarity.common);
      final legendary = tpl.materialize(FloorChoiceRarity.legendary);
      expect(common.healPercent, closeTo(0.28, 0.001));
      expect(legendary.healPercent, lessThanOrEqualTo(1.0));
      expect(legendary.healPercent, greaterThan(common.healPercent));
    });
  });

  group('FloorChoiceCatalog.offerForFloor', () {
    test('returns 3 choices with rarities', () {
      final catalog = const FloorChoiceCatalog();
      final picks = catalog.offerForFloor(1, rng: math.Random(42));
      expect(picks, hasLength(3));
      expect(picks.map((c) => c.id).toSet().length, 3);
      for (final p in picks) {
        expect(FloorChoiceRarity.values, contains(p.rarity));
      }
    });

    test('deeper floors can still offer choices', () {
      final catalog = const FloorChoiceCatalog();
      final picks = catalog.offerForFloor(25, rng: math.Random(7));
      expect(picks, hasLength(3));
    });

    test('each offered choice has a named icon asset', () {
      final catalog = const FloorChoiceCatalog();
      final picks = catalog.offerForFloor(1, count: 8, rng: math.Random(1));
      for (final p in picks) {
        expect(p.iconAsset, isNotNull);
        expect(p.iconAsset, startsWith('assets/icons/'));
      }
    });
  });
}
