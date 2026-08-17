import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/ui/core/color_utils.dart';

void main() {
  group('ColorUtils.darkened', () {
    test('multiplies RGB by (1 - amount)', () {
      const white = Color(0xFFFFFFFF);
      final result = ColorUtils.darkened(white, 0.5);
      expect(result.r, closeTo(0.5, 0.001));
      expect(result.g, closeTo(0.5, 0.001));
      expect(result.b, closeTo(0.5, 0.001));
      expect(result.a, closeTo(1.0, 0.001));
    });

    test('preserves alpha', () {
      final result = ColorUtils.darkened(
        const Color.from(alpha: 0.4, red: 1, green: 0, blue: 0),
        0.25,
      );
      expect(result.a, closeTo(0.4, 0.001));
      expect(result.r, closeTo(0.75, 0.001));
    });
  });

  group('ColorUtils.lightened', () {
    test('mixes toward white by amount', () {
      const black = Color(0xFF000000);
      final result = ColorUtils.lightened(black, 0.5);
      expect(result.r, closeTo(0.5, 0.001));
      expect(result.g, closeTo(0.5, 0.001));
      expect(result.b, closeTo(0.5, 0.001));
    });
  });

  group('ColorUtils.mixColors', () {
    test('strength 0 returns the first color', () {
      const a = Color(0xFFFF0000);
      const b = Color(0xFF0000FF);
      expect(ColorUtils.mixColors(a, b), a);
    });

    test('strength 0.5 averages channels', () {
      const black = Color(0xFF000000);
      const white = Color(0xFFFFFFFF);
      final result = ColorUtils.mixColors(black, white, 0.5);
      expect(result.r, closeTo(0.5, 0.001));
      expect(result.g, closeTo(0.5, 0.001));
      expect(result.b, closeTo(0.5, 0.001));
    });
  });

  group('ColorUtils.darkenedHueShift', () {
    test('darkens and shifts hue toward purple', () {
      const teal = Color(0xFF2BD4AE);
      final original = HSVColor.fromColor(teal);
      final shifted = HSVColor.fromColor(ColorUtils.darkenedHueShift(teal));

      expect(shifted.value, lessThan(original.value));

      const purpleHue = 270.0;
      final originalDist = _hueDistance(original.hue, purpleHue);
      final shiftedDist = _hueDistance(shifted.hue, purpleHue);
      expect(shiftedDist, lessThan(originalDist));
    });
  });

  group('ColorUtils.desaturated', () {
    test('reduces HSV saturation', () {
      const color = Color(0xFF2BD4AE);
      final original = HSVColor.fromColor(color);
      final result = HSVColor.fromColor(ColorUtils.desaturated(color, 0.2));
      expect(result.saturation, closeTo(original.saturation - 0.2, 0.01));
    });
  });
}

double _hueDistance(double from, double to) {
  final diff = (to - from).abs() % 360;
  return diff > 180 ? 360 - diff : diff;
}
