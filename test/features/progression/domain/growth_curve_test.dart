import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/shared/domain.dart';

void main() {
  group('GrowthCurve.monsterFloorMultiplier', () {
    final curve = GrowthCurve.standard();

    test('floor 1 is base (~1.0)', () {
      expect(curve.monsterFloorMultiplier(1), closeTo(1.0, 0.001));
    });

    test('floor 10 is ~2.0 with growth 1.08', () {
      // 1.08^9 ≈ 1.999
      expect(curve.monsterFloorMultiplier(10), closeTo(1.999, 0.02));
    });

    test('floor below 1 clamps to floor 1', () {
      expect(curve.monsterFloorMultiplier(0), curve.monsterFloorMultiplier(1));
    });
  });
}
