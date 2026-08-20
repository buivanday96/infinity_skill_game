import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/skill_tree_game.dart';
import '../notifiers/skill_tree_notifier.dart';
import '../models/upgrades.dart';
import '../models/skill_node.dart';
import '../models/upgrade_data.dart';
import 'hud_overlay.dart';
import 'smart_tooltip_positioner.dart';
import 'upgrade_tooltip.dart';

class SkillTreeScreen extends ConsumerStatefulWidget {
  const SkillTreeScreen({super.key});

  @override
  ConsumerState<SkillTreeScreen> createState() => _SkillTreeScreenState();
}

class _SkillTreeScreenState extends ConsumerState<SkillTreeScreen> {
  late final SkillTreeGame _game;

  Upgrade? _lastSelectedNodeId;
  SkillNode? _lastSelectedNode;
  UpgradeData? _lastSelectedData;

  @override
  void initState() {
    super.initState();
    _game = SkillTreeGame(ref);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to state changes and update the Flame game
    ref.listen(skillTreeProvider, (previous, next) {
      if (previous?.nodes != next.nodes || previous?.unspentPoints != next.unspentPoints || previous?.blueSquarePoints != next.blueSquarePoints || previous?.yellowStarPoints != next.yellowStarPoints || previous?.pinkHourglassPoints != next.pinkHourglassPoints || previous?.greenCrownPoints != next.greenCrownPoints) {
        _game.updateSkillTree(next);
      }
    });

    final state = ref.watch(skillTreeProvider);
    final selectedNodeId = state.selectedNodeId;
    final selectedNode = selectedNodeId != null ? state.nodes[selectedNodeId] : null;
    final selectedData = selectedNodeId != null ? upgradesMap[selectedNodeId] : null;

    final isTooltipVisible = selectedNode != null && selectedData != null && selectedNode.activationLevel.index >= ActivationLevel.revealed.index;

    if (isTooltipVisible) {
      _lastSelectedNodeId = selectedNodeId;
      _lastSelectedNode = selectedNode;
      _lastSelectedData = selectedData;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A24),
      body: Stack(
        children: [
          GameWidget(game: _game),
          const HudOverlay(),
          Positioned(
            left: 20,
            bottom: 20,
            child: _SkillTreeZoomControls(game: _game),
          ),
          if (_lastSelectedNode != null && _lastSelectedData != null)
            SmartTooltipPositioner(
              game: _game,
              nodeWorldPosition: _lastSelectedNode!.position,
              nodeSize: Vector2(128, 128),
              isTooltipVisible: isTooltipVisible,
              child: UpgradeTooltip(
                upgrade: _lastSelectedNodeId!,
                node: _lastSelectedNode!,
                data: _lastSelectedData!,
                onUpgrade: () {
                  ref.read(skillTreeProvider.notifier).levelUpNode(_lastSelectedNodeId!);
                },
                onRefund: () {
                  final keys = HardwareKeyboard.instance.logicalKeysPressed;
                  final isShiftPressed = keys.contains(LogicalKeyboardKey.shiftLeft) || keys.contains(LogicalKeyboardKey.shiftRight);
                  ref
                      .read(skillTreeProvider.notifier)
                      .refundNode(
                        _lastSelectedNodeId!,
                        allLevels: isShiftPressed,
                      );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SkillTreeZoomControls extends StatelessWidget {
  const _SkillTreeZoomControls({required this.game});

  final SkillTreeGame game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: game.zoomListenable,
      builder: (context, zoom, _) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A24).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Zoom in',
                onPressed: zoom < SkillTreeGame.maxZoom - 0.001 ? game.zoomIn : null,
                icon: const Icon(Icons.add, color: Colors.white),
              ),
              IconButton(
                tooltip: 'Fit tree',
                onPressed: game.fitToTree,
                icon: const Icon(Icons.center_focus_strong, color: Colors.white),
              ),
              IconButton(
                tooltip: 'Zoom out',
                onPressed: zoom > game.minZoom + 0.001 ? game.zoomOut : null,
                icon: const Icon(Icons.remove, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
