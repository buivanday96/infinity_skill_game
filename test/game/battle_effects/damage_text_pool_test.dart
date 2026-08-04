import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/game/battle_effects/components/damage_text_component.dart';
import 'package:infinity_skill_game/game/battle_effects/pool/damage_text_pool.dart';

void main() {
  group('DamageTextPool', () {
    test('obtain creates when empty and release returns to available', () {
      var created = 0;
      final pool = DamageTextPool(
        create: () {
          created++;
          return DamageTextComponent();
        },
      );

      final a = pool.obtain();
      expect(created, 1);
      expect(pool.usingCount, 1);
      expect(pool.availableCount, 0);

      pool.release(a);
      expect(pool.usingCount, 0);
      expect(pool.availableCount, 1);
      expect(a.isShown, isFalse);
    });

    test('obtain reuses released component without creating new', () {
      var created = 0;
      final pool = DamageTextPool(
        create: () {
          created++;
          return DamageTextComponent();
        },
      );

      final first = pool.obtain();
      pool.release(first);
      final second = pool.obtain();

      expect(identical(first, second), isTrue);
      expect(created, 1);
      expect(pool.usingCount, 1);
      expect(pool.availableCount, 0);
    });

    test('grows when all instances are in use', () {
      final pool = DamageTextPool(create: DamageTextComponent.new);
      final a = pool.obtain();
      final b = pool.obtain();
      expect(identical(a, b), isFalse);
      expect(pool.usingCount, 2);
      expect(pool.totalCount, 2);
    });

    test('prewarm parks idle instances', () {
      final pool = DamageTextPool(create: DamageTextComponent.new);
      pool.prewarm(5);
      expect(pool.availableCount, 5);
      expect(pool.usingCount, 0);

      pool.obtain();
      expect(pool.availableCount, 4);
      expect(pool.usingCount, 1);
      expect(pool.totalCount, 5);
    });

    test('releaseAll returns every in-use instance', () {
      final pool = DamageTextPool(create: DamageTextComponent.new);
      pool.obtain();
      pool.obtain();
      pool.releaseAll();
      expect(pool.usingCount, 0);
      expect(pool.availableCount, 2);
    });
  });
}
