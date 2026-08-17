import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/skill_tree_game.dart';
import '../notifiers/skill_tree_notifier.dart';
import '../models/upgrades.dart';
import 'hud_overlay.dart';
import 'upgrade_tooltip.dart';

class SkillTreeScreen extends ConsumerStatefulWidget {
  const SkillTreeScreen({super.key});

  @override
  ConsumerState<SkillTreeScreen> createState() => _SkillTreeScreenState();
}

class _SkillTreeScreenState extends ConsumerState<SkillTreeScreen> {
  late final SkillTreeGame _game;

  @override
  void initState() {
    super.initState();
    _game = SkillTreeGame(ref);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to state changes and update the Flame game
    ref.listen(skillTreeProvider, (previous, next) {
      if (previous?.nodes != next.nodes ||
          previous?.unspentPoints != next.unspentPoints ||
          previous?.blueSquarePoints != next.blueSquarePoints ||
          previous?.yellowStarPoints != next.yellowStarPoints ||
          previous?.pinkHourglassPoints != next.pinkHourglassPoints ||
          previous?.greenCrownPoints != next.greenCrownPoints) {
        _game.updateSkillTree(next);
      }
    });

    final state = ref.watch(skillTreeProvider);
    final selectedNodeId = state.selectedNodeId;
    final selectedNode = selectedNodeId != null ? state.nodes[selectedNodeId] : null;
    final selectedData = selectedNodeId != null ? upgradesMap[selectedNodeId] : null;

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
          if (selectedNode != null &&
              selectedData != null &&
              selectedNode.activationLevel.index >=
                  ActivationLevel.revealed.index)
            Positioned(
              right: 32,
              bottom: 32,
              child: UpgradeTooltip(
                upgrade: selectedNodeId!,
                node: selectedNode,
                data: selectedData,
                onUpgrade: () {
                  ref.read(skillTreeProvider.notifier).levelUpNode(selectedNodeId);
                },
                onRefund: () {
                  // Implement refund logic later
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
