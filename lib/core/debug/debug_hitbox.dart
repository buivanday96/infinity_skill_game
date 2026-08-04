import 'dart:ui';

import 'package:flame/components.dart';

/// Fractional insets (0–1) from each edge of the sprite [size].
///
/// Example — tighter body hitbox:
/// ```dart
/// const HitboxInset(left: 0.3, top: 0.15, right: 0.25, bottom: 0.05)
/// ```
class HitboxInset {
  const HitboxInset({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;

  Rect toLocalRect(Vector2 size) {
    return Rect.fromLTRB(
      size.x * left,
      size.y * top,
      size.x * (1 - right),
      size.y * (1 - bottom),
    );
  }
}

/// Custom local AABB + debug draw. Collision should use [absoluteHitbox].
mixin DebugHitbox on PositionComponent {
  /// Body hitbox AABB (inset rect used for combat spacing).
  bool get showHitbox => true;

  /// Full sprite bounds — useful for comparing art vs collision.
  bool get showCollision => showHitbox;

  /// Attack / action range ring.
  bool get showAction => showHitbox;

  Color get hitboxColor => const Color(0xFF69F0AE);

  Color get collisionColor => hitboxColor.withValues(alpha: 0.35);

  /// Optional attack-range radius in local pixels (0 = hide).
  double get debugAttackRangePx => 0;

  Color get attackRangeColor => const Color(0x66FFEB3B);

  /// Hitbox in local component space (top-left origin).
  /// Override with [HitboxInset.toLocalRect] or any custom [Rect].
  Rect get localHitbox {
    if (size.x <= 0 || size.y <= 0) return Rect.zero;
    return Offset.zero & Size(size.x, size.y);
  }

  /// World-space AABB of [localHitbox] (handles flip / scale / anchor).
  Rect absoluteHitbox() {
    final local = localHitbox;
    if (local.isEmpty) return Rect.zero;

    final a = absolutePositionOf(Vector2(local.left, local.top));
    final b = absolutePositionOf(Vector2(local.right, local.bottom));
    return Rect.fromLTRB(
      a.x < b.x ? a.x : b.x,
      a.y < b.y ? a.y : b.y,
      a.x > b.x ? a.x : b.x,
      a.y > b.y ? a.y : b.y,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (size.x <= 0 || size.y <= 0) return;
    if (!showHitbox && !showCollision && !showAction) return;

    if (showCollision) {
      canvas.drawRect(
        Offset.zero & Size(size.x, size.y),
        Paint()
          ..color = collisionColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    if (showHitbox) {
      final box = localHitbox;
      if (!box.isEmpty) {
        canvas.drawRect(
          box,
          Paint()
            ..color = hitboxColor.withValues(alpha: 0.18)
            ..style = PaintingStyle.fill,
        );
        canvas.drawRect(
          box,
          Paint()
            ..color = hitboxColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }

    if (showAction) {
      final range = debugAttackRangePx;
      if (range > 0) {
        // Feet / anchor sits at bottom-center of the component box.
        final origin = Offset(size.x / 2, size.y);
        canvas.drawCircle(
          origin,
          range,
          Paint()
            ..color = attackRangeColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.25,
        );
      }
    }
  }
}
