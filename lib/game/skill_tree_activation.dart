import '../models/node_state.dart';
import '../models/skill_node.dart';
import '../models/upgrade_data.dart';
import '../models/upgrades.dart';

bool isNodeVisible(ActivationLevel level) =>
    level.index >= ActivationLevel.discovered.index;

NodeState nodeStateFrom(ActivationLevel level) {
  switch (level) {
    case ActivationLevel.hidden:
    case ActivationLevel.discovered:
    case ActivationLevel.revealed:
      return NodeState.disabled;
    case ActivationLevel.available:
      return NodeState.enabled;
    case ActivationLevel.leveled:
      return NodeState.active;
    case ActivationLevel.maxed:
      return NodeState.upgraded;
  }
}

/// Godot `Upgrades.update_activation_level` without the milestone afford shortcut.
ActivationLevel computeActivationLevel({
  required int currentLevel,
  required int maxLevel,
  required ActivationLevel current,
  required ActivationLevel? dependencyLevel,
}) {
  if (currentLevel >= maxLevel && maxLevel > 0) {
    return ActivationLevel.maxed;
  }
  if (currentLevel > 0) {
    return ActivationLevel.leveled;
  }
  if (dependencyLevel == null ||
      dependencyLevel.index >= ActivationLevel.leveled.index) {
    return ActivationLevel.available;
  }
  if (dependencyLevel.index >= ActivationLevel.revealed.index) {
    if (current.index > ActivationLevel.discovered.index) {
      return ActivationLevel.revealed;
    }
    return ActivationLevel.discovered;
  }
  return current;
}

Map<Upgrade, List<Upgrade>> buildDependentsIndex(
  Map<Upgrade, UpgradeData> upgrades,
) {
  final dependents = <Upgrade, List<Upgrade>>{};
  for (final entry in upgrades.entries) {
    final dependency = entry.value.dependency;
    if (dependency == null) continue;
    dependents.putIfAbsent(dependency, () => []).add(entry.key);
  }
  return dependents;
}

void updateActivationLevel(
  Map<Upgrade, SkillNode> nodes,
  Upgrade upgrade, {
  required Map<Upgrade, List<Upgrade>> dependents,
  required Map<Upgrade, UpgradeData> upgrades,
  bool forceUpdate = false,
}) {
  final node = nodes[upgrade];
  if (node == null) return;
  final data = upgrades[upgrade];
  if (data == null) return;

  ActivationLevel? dependencyLevel;
  if (data.dependency != null) {
    dependencyLevel =
        nodes[data.dependency!]?.activationLevel ?? ActivationLevel.hidden;
  }

  final next = computeActivationLevel(
    currentLevel: node.currentLevel,
    maxLevel: data.maxLevel,
    current: node.activationLevel,
    dependencyLevel: dependencyLevel,
  );

  if (next == node.activationLevel && !forceUpdate) return;

  nodes[upgrade] = node.copyWith(
    activationLevel: next,
    state: nodeStateFrom(next),
  );

  for (final dependent in dependents[upgrade] ?? const <Upgrade>[]) {
    updateActivationLevel(
      nodes,
      dependent,
      dependents: dependents,
      upgrades: upgrades,
    );
  }
}

void propagateFromRoot(
  Map<Upgrade, SkillNode> nodes, {
  required Map<Upgrade, List<Upgrade>> dependents,
  required Map<Upgrade, UpgradeData> upgrades,
  Upgrade root = Upgrade.arrow_tower_unlock,
}) {
  updateActivationLevel(
    nodes,
    root,
    dependents: dependents,
    upgrades: upgrades,
    forceUpdate: true,
  );
}
