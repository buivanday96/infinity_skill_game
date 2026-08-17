import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'milestone_highlight.dart';

class CircleHighlightComponent extends SpriteComponent with MilestoneHighlight {
  static const spritePath = 'sprites/circle_highlight.png';

  CircleHighlightComponent({Color color = Colors.white})
      : super(
          size: Vector2.all(240),
          anchor: Anchor.center,
          position: Vector2.all(64),
        ) {
    highlightColor = color;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(spritePath);
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateHighlight(dt, baseScale: 1.0, rotate: true);
    paint.colorFilter = ColorFilter.mode(
      highlightColor.withValues(alpha: opacity),
      BlendMode.modulate,
    );
  }

  @override
  void render(Canvas canvas) {
    if (opacity <= 0) return;
    super.render(canvas);
  }
}
