import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

mixin MilestoneHighlight on PositionComponent {
  static const fadeDuration = 0.35;
  static const pulseAmount = 0.075;

  Color highlightColor = Colors.white;
  double opacity = 0;
  double targetOpacity = 0;
  double elapsed = 0;

  bool get isShown => targetOpacity > 0;

  void appear() {
    targetOpacity = 1;
  }

  void disappear() {
    targetOpacity = 0;
  }

  void syncVisibility({required bool shouldShow, required Color color}) {
    highlightColor = color;
    if (shouldShow && !isShown) {
      appear();
    } else if (!shouldShow && isShown) {
      disappear();
    }
  }

  void updateHighlight(double dt, {required double baseScale, bool rotate = false}) {
    elapsed += dt;
    if (opacity < targetOpacity) {
      opacity = math.min(targetOpacity, opacity + dt / fadeDuration);
    } else if (opacity > targetOpacity) {
      opacity = math.max(targetOpacity, opacity - dt / fadeDuration);
    }

    final pulse = math.sin(elapsed * math.pi) * pulseAmount;
    scale = Vector2.all(baseScale + pulse);
    if (rotate) {
      angle += dt * math.pi / 2;
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) => false;
}
