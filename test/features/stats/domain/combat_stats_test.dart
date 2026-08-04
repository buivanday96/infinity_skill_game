import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/shared/domain.dart';

void main() {
  group('CombatStats layering', () {
    test('final = (base + flat) * (1 + percent)', () {
      final stats = CombatStats(bases: {StatId.attack: 100});
      stats.addModifier(
        const StatModifier(
          id: 'eq',
          stat: StatId.attack,
          source: ModifierSource.equipment,
          flat: 40,
        ),
      );
      stats.addModifier(
        const StatModifier(
          id: 'buff',
          stat: StatId.attack,
          source: ModifierSource.buff,
          percent: 0.3,
        ),
      );
      expect(stats.finalOf(StatId.attack), closeTo(182, 0.001));
    });
  });

  group('Progression', () {
    test('level up grows base and grants skill points', () {
      final hero = HeroModel.knight();
      final curve = GrowthCurve.standard();
      final atkBefore = hero.stats.baseOf(StatId.attack);
      final leveled = hero.gainExp(curve.expRequiredFor(2), curve);
      expect(leveled, isTrue);
      expect(hero.level, 2);
      expect(hero.skillPoints, curve.skillPointsPerLevel);
      expect(hero.stats.baseOf(StatId.attack), atkBefore + curve.perLevelFlat[StatId.attack]!);
    });

    test('floor choice adds removable modifiers', () {
      final hero = HeroModel.knight();
      final service = ProgressionService();
      final choice = const FloorChoiceTemplate(
        id: 'atk_pct',
        kind: FloorChoiceKind.statBoost,
        description: 'atk',
        stat: StatId.attack,
        basePercent: 0.10,
      ).materialize(FloorChoiceRarity.rare);
      final atkBefore = hero.attack;
      service.pickFloorChoice(hero, choice, 1);
      expect(hero.attack, greaterThan(atkBefore));
      expect(choice.rarity, FloorChoiceRarity.rare);
    });

    test('skill tree unlock spends points and boosts stats', () {
      final hero = HeroModel.knight();
      hero.skillPoints = 1;
      final tree = SkillTree.starter();
      final hpBefore = hero.maxHp;
      expect(tree.unlock(hero, 'root_vitality'), isTrue);
      expect(hero.skillPoints, 0);
      expect(hero.maxHp, hpBefore + 50);
    });

    test('monster floor scaling increases power', () {
      final service = ProgressionService();
      final m1 = service.spawnScaled(
        factory: MonsterModel.slime,
        floor: 1,
      );
      final m10 = service.spawnScaled(
        factory: () => MonsterModel.slime(id: 's10'),
        floor: 10,
      );
      expect(m10.attack, greaterThan(m1.attack));
      expect(m10.maxHp, greaterThan(m1.maxHp));
    });
  });
}
