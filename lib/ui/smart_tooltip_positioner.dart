import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../game/skill_tree_game.dart';

enum TooltipDirection { up, down, left, right }

Offset _getPositionForDirection(
  TooltipDirection dir,
  Offset center,
  double halfNodeW,
  double halfNodeH,
  Size childSize,
  double margin,
) {
  switch (dir) {
    case TooltipDirection.up:
      return Offset(
        center.dx - childSize.width / 2,
        center.dy - halfNodeH - margin - childSize.height,
      );
    case TooltipDirection.down:
      return Offset(
        center.dx - childSize.width / 2,
        center.dy + halfNodeH + margin,
      );
    case TooltipDirection.left:
      return Offset(
        center.dx - halfNodeW - margin - childSize.width,
        center.dy - childSize.height / 2,
      );
    case TooltipDirection.right:
      return Offset(
        center.dx + halfNodeW + margin,
        center.dy - childSize.height / 2,
      );
  }
}

bool _isInside(Offset pos, Size childSize, Size viewportSize) {
  return pos.dx >= 0 &&
      pos.dy >= 0 &&
      pos.dx + childSize.width <= viewportSize.width &&
      pos.dy + childSize.height <= viewportSize.height;
}

class SmartTooltipPositioner extends StatelessWidget {
  final SkillTreeGame game;
  final Vector2 nodeWorldPosition;
  final Vector2 nodeSize;
  final bool isTooltipVisible;
  final Widget child;

  const SmartTooltipPositioner({
    super.key,
    required this.game,
    required this.nodeWorldPosition,
    required this.nodeSize,
    required this.isTooltipVisible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: game.cameraUpdateNotifier,
      builder: (context, _, child) {
        // Convert world position to screen position
        final screenPosition = game.cam.localToGlobal(nodeWorldPosition);
        final zoom = game.cam.viewfinder.zoom;
        final center = Offset(screenPosition.x, screenPosition.y);
        final viewportSize = MediaQuery.of(context).size;
        
        final halfNodeW = (nodeSize.x * zoom) / 2;
        final halfNodeH = (nodeSize.y * zoom) / 2;
        const margin = 24.0; // Margin similar to Godot spacing

        final estimatedDir = _estimateDirection(center, viewportSize, halfNodeW, halfNodeH, margin);
        final alignment = _getAlignmentForDirection(estimatedDir);

        return CustomSingleChildLayout(
          delegate: _TooltipLayoutDelegate(
            nodeScreenPosition: center,
            nodeScreenSize: Size(nodeSize.x * zoom, nodeSize.y * zoom),
            margin: margin,
          ),
          child: child!
              .animate(target: isTooltipVisible ? 1 : 0)
              .scale(
                alignment: alignment,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                begin: const Offset(0.0, 0.0),
                end: const Offset(1.0, 1.0),
              )
              .fade(
                duration: const Duration(milliseconds: 150),
              ),
        );
      },
      child: child,
    );
  }

  TooltipDirection _estimateDirection(
    Offset center,
    Size viewportSize,
    double halfNodeW,
    double halfNodeH,
    double margin,
  ) {
    const estimatedChildSize = Size(320, 200);
    final directions = [
      TooltipDirection.up,
      TooltipDirection.down,
      TooltipDirection.left,
      TooltipDirection.right,
    ];

    for (final dir in directions) {
      final pos = _getPositionForDirection(
          dir, center, halfNodeW, halfNodeH, estimatedChildSize, margin);
      if (_isInside(pos, estimatedChildSize, viewportSize)) {
        return dir;
      }
    }
    return TooltipDirection.up;
  }

  Alignment _getAlignmentForDirection(TooltipDirection dir) {
    switch (dir) {
      case TooltipDirection.up:
        return Alignment.bottomCenter;
      case TooltipDirection.down:
        return Alignment.topCenter;
      case TooltipDirection.left:
        return Alignment.centerRight;
      case TooltipDirection.right:
        return Alignment.centerLeft;
    }
  }
}

class _TooltipLayoutDelegate extends SingleChildLayoutDelegate {
  final Offset nodeScreenPosition;
  final Size nodeScreenSize;
  final double margin;

  _TooltipLayoutDelegate({
    required this.nodeScreenPosition,
    required this.nodeScreenSize,
    required this.margin,
  });

  @override
  bool shouldRelayout(_TooltipLayoutDelegate oldDelegate) {
    return oldDelegate.nodeScreenPosition != nodeScreenPosition ||
        oldDelegate.nodeScreenSize != nodeScreenSize ||
        oldDelegate.margin != margin;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final center = nodeScreenPosition;
    final halfNodeW = nodeScreenSize.width / 2;
    final halfNodeH = nodeScreenSize.height / 2;

    final directions = [
      TooltipDirection.up,
      TooltipDirection.down,
      TooltipDirection.left,
      TooltipDirection.right,
    ];

    Offset bestPosition = _getPositionForDirection(
        TooltipDirection.up, center, halfNodeW, halfNodeH, childSize, margin);

    for (final dir in directions) {
      final pos = _getPositionForDirection(
          dir, center, halfNodeW, halfNodeH, childSize, margin);
      if (_isInside(pos, childSize, size)) {
        return pos;
      }
    }

    // Fallback: clamp the first preferred position (UP) to the screen bounds
    return Offset(
      bestPosition.dx.clamp(0.0, size.width - childSize.width),
      bestPosition.dy.clamp(0.0, size.height - childSize.height),
    );
  }
}
