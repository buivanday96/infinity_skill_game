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

  void refundNode(Upgrade upgrade, {bool allLevels = false}) {
    final node = state.nodes[upgrade];
    if (node == null) return;
    
    final data = upgradesMap[upgrade];
    if (data == null) return;

    if (node.currentLevel <= 0) return;
    if (data.isMilestone && !data.isArtifact) return;

    final newNodes = Map<Upgrade, SkillNode>.from(state.nodes);
    var currentState = state;

    void refundRecursive(Upgrade currentUpgrade, int levelsToDecrease) {
      final currentNode = newNodes[currentUpgrade];
      if (currentNode == null) return;
      final currentData = upgradesMap[currentUpgrade];
      if (currentData == null) return;

      if (currentNode.currentLevel <= 0) return;
      if (currentData.isMilestone && !currentData.isArtifact) return;

      int currentLvl = currentNode.currentLevel;
      for (int i = 0; i < levelsToDecrease; i++) {
        currentLvl -= 1;
        currentState = refundTokens(
          currentState,
          currentData.costToken,
          currentData.getCost(currentLvl),
        );
      }
      
      newNodes[currentUpgrade] = currentNode.copyWith(currentLevel: currentLvl);

      if (currentLvl == 0) {
        final dependentList = _dependents[currentUpgrade] ?? const [];
        for (final dependent in dependentList) {
          final depNode = newNodes[dependent];
          if (depNode != null && depNode.currentLevel > 0) {
            refundRecursive(dependent, depNode.currentLevel);
          }
        }
      }
    }

    final levelsToDecrease = allLevels ? node.currentLevel : 1;
    refundRecursive(upgrade, levelsToDecrease);

    // Update activation levels across the entire tree
    propagateFromRoot(
      newNodes,
      dependents: _dependents,
      upgrades: upgradesMap,
    );

    state = currentState.copyWith(nodes: newNodes);
  }
}
