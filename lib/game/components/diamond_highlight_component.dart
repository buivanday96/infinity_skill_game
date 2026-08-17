import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'milestone_highlight.dart';

class DiamondHighlightComponent extends PositionComponent with MilestoneHighlight {
  static const double _size = 176.584;
  static const double _cornerRadius = 20;
  static const double _strokeWidth = 12;
  static const double _dash = 18;
  static const double _gap = 14;
  static const double _scrollSpeed = 180;

  double _dashOffset = 0;

  DiamondHighlightComponent({Color color = Colors.white})
      : super(
          size: Vector2.all(64),
          anchor: Anchor.center,
          position: Vector2.all(64),
        ) {
    highlightColor = color;
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateHighlight(dt, baseScale: 0.9);
    _dashOffset += dt * _scrollSpeed;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (opacity <= 0) return;

    final paint = Paint()
      ..color = highlightColor.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(math.pi / 4);

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset.zero,
        width: _size,
        height: _size,
      ),
      const Radius.circular(_cornerRadius),
    );
    final path = Path()..addRRect(rect);
    canvas.drawPath(_dashPath(path, offset: _dashOffset), paint);
    canvas.restore();
  }

  Path _dashPath(Path source, {required double offset}) {
    final dest = Path();
    final period = _dash + _gap;
    for (final metric in source.computeMetrics()) {
      var distance = ((-offset) % period + period) % period;
      var draw = distance <= _dash;
      var remainingInPhase =
          draw ? (_dash - distance) : (_gap - (distance - _dash));
      if (remainingInPhase <= 0) {
        draw = !draw;
        remainingInPhase = draw ? _dash : _gap;
      }
      var cursor = 0.0;
      while (cursor < metric.length) {
        final segmentLength = math.min(remainingInPhase, metric.length - cursor);
        if (draw) {
          dest.addPath(
            metric.extractPath(cursor, cursor + segmentLength),
            Offset.zero,
          );
        }
        cursor += segmentLength;
        remainingInPhase -= segmentLength;
        if (remainingInPhase <= 0) {
          draw = !draw;
          remainingInPhase = draw ? _dash : _gap;
        }
      }
    }
    return dest;
  }
}
