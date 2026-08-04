import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/painting.dart';
import 'package:infinity_skill_game/game/battle_effects/effects/damage_text_animation.dart';
import 'package:infinity_skill_game/game/battle_effects/effects/damage_text_style_resolver.dart';
import 'package:infinity_skill_game/game/battle_effects/models/damage_text_data.dart';

/// Presentation-only floating text. No battle / hero / enemy knowledge.
class DamageTextComponent extends PositionComponent with HasPaint {
  DamageTextComponent({
    DamageTextStyleResolver? styleResolver,
    DamageTextAnimation? animation,
    math.Random? rng,
    this.onFinished,
  })  : _styleResolver = styleResolver ?? const DamageTextStyleResolver(),
        _animation = animation ?? DamageTextAnimation(rng: rng),
        _rng = rng ?? math.Random(),
        super(
          anchor: Anchor.center,
          priority: 200,
        );

  final DamageTextStyleResolver _styleResolver;
  final DamageTextAnimation _animation;
  final math.Random _rng;

  /// Called when the float animation ends (pool releases on this).
  void Function(DamageTextComponent component)? onFinished;

  TextPainter? _painter;
  String _text = '';
  bool _active = false;
  bool _shown = false;

  bool get isActive => _active;
  bool get isShown => _shown;

  /// Activate with [data]: position, style, animate, then [onFinished].
  void show(DamageTextData data) {
    reset();

    _text = data.text;
    final style = _styleResolver.resolve(data.type);
    _painter = TextPainter(
      text: TextSpan(text: _text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    size = Vector2(
      _painter!.width.clamp(8, 400),
      _painter!.height.clamp(8, 120),
    );

    var pos = data.worldPosition.clone();
    if (data.randomOffset) {
      pos += Vector2(
        (_rng.nextDouble() * 20) - 10,
        (_rng.nextDouble() * 10) - 5,
      );
    }
    position.setFrom(pos);
    scale.setValues(1, 1);
    opacity = 1;
    _shown = true;
    _active = true;

    void startAnim() {
      if (!_active) return;
      _animation.play(
        target: this,
        type: data.type,
        onComplete: _finish,
      );
    }

    if (data.delay > 0) {
      add(
        TimerComponent(
          period: data.delay,
          removeOnFinish: true,
          onTick: startAnim,
        ),
      );
    } else {
      startAnim();
    }
  }

  void hide() {
    _shown = false;
    _active = false;
  }

  /// Clears visual state so the component can be reused from the pool.
  void reset() {
    removeAll(children.whereType<Effect>());
    removeAll(children.whereType<TimerComponent>());
    _painter = null;
    _text = '';
    opacity = 1;
    scale.setValues(1, 1);
    _shown = false;
    _active = false;
  }

  void _finish() {
    if (!_active) return;
    _active = false;
    onFinished?.call(this);
  }

  @override
  void render(Canvas canvas) {
    final painter = _painter;
    if (painter == null || !_shown) return;
    final op = opacity;
    if (op <= 0) return;
    if (op < 1) {
      canvas.saveLayer(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()..color = Color.fromRGBO(255, 255, 255, op),
      );
      painter.paint(canvas, Offset.zero);
      canvas.restore();
    } else {
      painter.paint(canvas, Offset.zero);
    }
  }
}
