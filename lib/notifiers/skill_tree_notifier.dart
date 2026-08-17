import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../game/skill_tree_activation.dart';
import '../game/skill_tree_tokens.dart';
import '../models/skill_node.dart';
import '../models/skill_tree_state.dart';
import '../models/upgrades.dart';
import '../models/upgrade_positions.dart';

part 'skill_tree_notifier.g.dart';

@riverpod
class SkillTreeNotifier extends _$SkillTreeNotifier {
  final Map<Upgrade, List<Upgrade>> _dependents = buildDependentsIndex(upgradesMap);

  @override
  SkillTreeState build() {
    return const SkillTreeState();
  }

  void generateInitialTree() {
    final newNodes = <Upgrade, SkillNode>{};

    for (final entry in upgradesMap.entries) {
      final upgrade = entry.key;
      final data = entry.value;
      final position = upgradePositions[upgrade];

      if (position != null) {
        final connectedNodeIds = <Upgrade>[];
        if (data.dependency != null) {
          connectedNodeIds.add(data.dependency!);
        }

        newNodes[upgrade] = SkillNode(
          id: upgrade,
          position: position,
          connectedNodeIds: connectedNodeIds,
          currentLevel: 0,
        );
      }
    }

    propagateFromRoot(
      newNodes,
      dependents: _dependents,
      upgrades: upgradesMap,
    );

    state = state.copyWith(nodes: newNodes);
  }

  void levelUpNode(Upgrade upgrade) {
    final node = state.nodes[upgrade];
    if (node == null) return;
    if (node.activationLevel.index < ActivationLevel.revealed.index) return;

    final data = upgradesMap[upgrade];
    if (data == null) return;
    if (node.currentLevel >= data.maxLevel) return;
    if (!canAffordUpgrade(state, data, node.currentLevel)) return;

    final spent = spendTokens(
      state,
      data.costToken,
      data.getCost(node.currentLevel),
    );
    if (spent == null) return;

    final newNodes = Map<Upgrade, SkillNode>.from(spent.nodes);
    newNodes[upgrade] = node.copyWith(currentLevel: node.currentLevel + 1);

    updateActivationLevel(
      newNodes,
      upgrade,
      dependents: _dependents,
      upgrades: upgradesMap,
      forceUpdate: true,
    );

    state = spent.copyWith(nodes: newNodes);
  }

  void selectNode(Upgrade? upgrade) {
    state = state.copyWith(selectedNodeId: upgrade);
  }
}
