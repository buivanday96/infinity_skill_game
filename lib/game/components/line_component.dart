import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/skill_node.dart';
import '../../models/upgrades.dart';

class LineComponent extends PositionComponent {
  final SkillNode startNode;
  final SkillNode endNode;

  LineComponent({
    required this.startNode,
    required this.endNode,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = _getLineColor()
      ..strokeWidth = 2.0;

    canvas.drawLine(
      startNode.position.toOffset(),
      endNode.position.toOffset(),
      paint,
    );
  }

  Color _getLineColor() {
    final discoveredEndpoint =
        startNode.activationLevel == ActivationLevel.discovered ||
            endNode.activationLevel == ActivationLevel.discovered;
    if (discoveredEndpoint) {
      return Colors.white.withValues(alpha: 0.2);
    }
    if (startNode.activationLevel.index < ActivationLevel.available.index ||
        endNode.activationLevel.index < ActivationLevel.available.index) {
      return Colors.white.withValues(alpha: 0.35);
    }
    return Colors.white;
  }
}
