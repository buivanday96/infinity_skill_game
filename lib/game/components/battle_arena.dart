import 'dart:ui';

import 'package:flame/components.dart';

/// Top strip of the screen (1/4 height) rendered as a dungeon wall.
class WallBackdrop extends PositionComponent {
  WallBackdrop({required Vector2 size})
      : super(
          size: size,
          position: Vector2.zero(),
          priority: -5,
        );

  static final _wallPaint = Paint()..color = const Color(0xFF2A2520);
  static final _mortarPaint = Paint()
    ..color = const Color(0xFF1A1612)
    ..strokeWidth = 2;
  static final _ledgePaint = Paint()..color = const Color(0xFF3D342C);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _wallPaint);

    const brickH = 22.0;
    const brickW = 48.0;
    for (var row = 0; row * brickH < size.y; row++) {
      final y = row * brickH;
      final offset = row.isOdd ? brickW / 2 : 0.0;
      canvas.drawLine(Offset(0, y), Offset(size.x, y), _mortarPaint);
      for (var x = offset; x < size.x; x += brickW) {
        canvas.drawLine(Offset(x, y), Offset(x, y + brickH), _mortarPaint);
      }
    }

    canvas.drawRect(
      Rect.fromLTWH(0, size.y - 10, size.x, 10),
      _ledgePaint,
    );

    final shadow = Paint()
      ..shader = Gradient.linear(
        Offset(0, size.y - 4),
        Offset(0, size.y + 24),
        const [Color(0x99000000), Color(0x00000000)],
      );
    canvas.drawRect(
      Rect.fromLTWH(0, size.y - 4, size.x, 28),
      shadow,
    );
  }
}

/// Battle ground occupying the lower 3/4 of the screen.
class BattleFloor extends PositionComponent {
  BattleFloor({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, priority: -8);

  static final _floorPaint = Paint()..color = const Color(0xFF1A2A1E);
  static final _bandPaint = Paint()..color = const Color(0xFF243528);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _floorPaint);
    final laneH = size.y / 3;
    for (var i = 0; i < 3; i++) {
      if (i.isOdd) {
        canvas.drawRect(
          Rect.fromLTWH(0, i * laneH, size.x, laneH),
          _bandPaint,
        );
      }
    }
  }
}
