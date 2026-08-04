import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

/// Compact HP (+ shield overlay) / MP bars anchored above a combatant.
///
/// Matches number_game [HealthBarComponent]:
/// - HP fill from the left (green → yellow → red)
/// - Shield is a translucent blue layer **on top of** HP from the left
///   (`shield / maxHp`), not stacked after HP.
class OverheadBars extends PositionComponent {
  OverheadBars({
    required this.barWidth,
    this.showMana = false,
    this.barHeight = 5,
  }) : super(
          size: Vector2(
            barWidth,
            showMana ? barHeight + _manaGap + _manaHeight : barHeight,
          ),
          anchor: Anchor.bottomCenter,
          priority: 20,
        );

  static const double _manaGap = 2;
  static const double _manaHeight = 3;

  final double barWidth;
  final double barHeight;
  final bool showMana;

  late final RectangleComponent _hpBg;
  late final RectangleComponent _hpFill;
  late final RectangleComponent _shieldFill;
  RectangleComponent? _manaBg;
  RectangleComponent? _manaFill;

  double _hp = 1;
  double _maxHp = 1;
  double _shield = 0;
  double _mana = 0;
  double _maxMana = 1;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _hpBg = RectangleComponent(
      size: Vector2(barWidth, barHeight),
      paint: Paint()..color = const Color(0xFF1F2937),
    );
    _hpFill = RectangleComponent(
      size: Vector2(barWidth, barHeight),
      paint: Paint()..color = const Color(0xFF22C55E),
    );
    // Drawn after HP so it overlays from the left.
    _shieldFill = RectangleComponent(
      size: Vector2(0, barHeight),
      paint: Paint()..color = const Color(0xFF60A5FA).withValues(alpha: 0.7),
    );

    await addAll([_hpBg, _hpFill, _shieldFill]);

    if (showMana) {
      final manaY = barHeight + _manaGap;
      _manaBg = RectangleComponent(
        position: Vector2(0, manaY),
        size: Vector2(barWidth, _manaHeight),
        paint: Paint()..color = const Color(0xFF1F2937),
      );
      _manaFill = RectangleComponent(
        position: Vector2(0, manaY),
        size: Vector2(barWidth, _manaHeight),
        paint: Paint()..color = const Color(0xFF3B82F6),
      );
      await addAll([_manaBg!, _manaFill!]);
    }

    _applyVisuals();
  }

  void setResources({
    required double hp,
    required double maxHp,
    double shield = 0,
    double mana = 0,
    double maxMana = 1,
  }) {
    _hp = hp;
    _maxHp = maxHp;
    _shield = shield;
    _mana = mana;
    _maxMana = maxMana;
    if (isLoaded) _applyVisuals();
  }

  void _applyVisuals() {
    final max = _maxHp <= 0 ? 1.0 : _maxHp;
    final current = _hp.clamp(0, max);
    final hpRatio = current / max;

    _hpFill.size.x = barWidth * hpRatio;
    _hpFill.paint.color = _colorForRatio(hpRatio);

    final shieldRatio = (_shield / max).clamp(0.0, 1.0);
    _shieldFill.size.x = barWidth * shieldRatio;

    final manaFill = _manaFill;
    if (manaFill != null) {
      final manaRatio =
          _maxMana <= 0 ? 0.0 : (_mana / _maxMana).clamp(0.0, 1.0);
      manaFill.size.x = barWidth * manaRatio;
    }
  }

  Color _colorForRatio(double ratio) {
    if (ratio > 0.55) return const Color(0xFF22C55E);
    if (ratio > 0.25) return const Color(0xFFEAB308);
    return const Color(0xFFEF4444);
  }
}
