import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Color math matching Godot `Color` helpers and `utilities/color_utils.gd`.
abstract final class ColorUtils {
  static const _tau = math.pi * 2;
  static const _purpleH = 0.75;
  static const _orangeH = 0.08;

  /// Godot `Color.darkened(amount)` — RGB multiply by `(1 - amount)`.
  static Color darkened(Color color, double amount) {
    final t = 1.0 - amount;
    return Color.from(
      alpha: color.a,
      red: color.r * t,
      green: color.g * t,
      blue: color.b * t,
    );
  }

  /// Godot `Color.lightened(amount)` — mix toward white by `amount`.
  static Color lightened(Color color, double amount) {
    return Color.from(
      alpha: color.a,
      red: color.r + (1.0 - color.r) * amount,
      green: color.g + (1.0 - color.g) * amount,
      blue: color.b + (1.0 - color.b) * amount,
    );
  }

  static Color darkenedHueShift(Color color, [double shift = 0.25]) {
    return shiftTowardsPurple(
      color,
      hueStrength: shift / 1.25,
      darken: shift * 1.25,
      saturate: shift / 2,
    );
  }

  static Color lightenedHueShift(Color color, [double shift = 0.25]) {
    return shiftTowardsOrange(
      color,
      hueStrength: shift / 1.25,
      lighten: shift * 1.25,
      saturate: shift / 2,
    );
  }

  static Color shiftTowardsPurple(
    Color color, {
    double hueStrength = 0.5,
    double darken = 0.2,
    double saturate = 0.0,
  }) {
    final hsv = HSVColor.fromColor(color);
    var h = hsv.saturation == 0 ? _purpleH : hsv.hue / 360.0;
    h =
        _lerpAngle(h * _tau, _purpleH * _tau, hueStrength.clamp(0.0, 1.0)) /
        _tau;
    final s = (hsv.saturation + saturate).clamp(0.0, 1.0);
    final v = (hsv.value * (1.0 - darken.clamp(0.0, 1.0))).clamp(0.0, 1.0);
    return HSVColor.fromAHSV(color.a, _wrapHue(h * 360.0), s, v).toColor();
  }

  static Color shiftTowardsOrange(
    Color color, {
    double hueStrength = 0.5,
    double lighten = 0.2,
    double saturate = 0.0,
  }) {
    final hsv = HSVColor.fromColor(color);
    var h = hsv.saturation == 0 ? _orangeH : hsv.hue / 360.0;
    h =
        _lerpAngle(h * _tau, _orangeH * _tau, hueStrength.clamp(0.0, 1.0)) /
        _tau;
    final s = (hsv.saturation + saturate).clamp(0.0, 1.0);
    final v = (hsv.value + lighten * (1.0 - hsv.value)).clamp(0.0, 1.0);
    return HSVColor.fromAHSV(color.a, _wrapHue(h * 360.0), s, v).toColor();
  }

  static Color withAlpha(Color color, double amount) {
    return color.withValues(alpha: amount);
  }

  static Color saturated(Color color, double amount) {
    final hsv = HSVColor.fromColor(color);
    return hsv
        .withSaturation((hsv.saturation + amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color desaturated(Color color, double amount) {
    return saturated(color, -amount);
  }

  static Color mixColors(Color colorA, Color colorB, [double strength = 0.0]) {
    return Color.lerp(colorA, colorB, strength)!;
  }

  /// Godot `fmod` (sign follows the dividend), used by `lerp_angle`.
  static double _fmod(double x, double y) {
    return x - y * (x / y).truncateToDouble();
  }

  static double _lerpAngle(double from, double to, double weight) {
    return from + _shortAngleDist(from, to) * weight;
  }

  static double _shortAngleDist(double from, double to) {
    final difference = _fmod(to - from, _tau);
    return _fmod(2.0 * difference, _tau) - difference;
  }

  static double _wrapHue(double hue) {
    var wrapped = hue % 360.0;
    if (wrapped < 0) wrapped += 360.0;
    return wrapped;
  }
}
