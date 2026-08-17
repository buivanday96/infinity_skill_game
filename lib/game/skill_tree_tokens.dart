import 'package:flutter/material.dart';

import '../models/skill_tree_state.dart';
import '../models/upgrade_data.dart';
import '../models/upgrades.dart';
import 'node_colors.dart';

/// Godot `get_token_type_color` used for milestone highlights.
Color tokenHighlightColor(String costToken) => NodeColors.tokenTypeColor(costToken);

int tokenBalance(SkillTreeState state, String costToken) {
  switch (costToken) {
    case 'advanced':
      return state.blueSquarePoints;
    case 'star':
      return state.yellowStarPoints;
    case 'time':
      return state.pinkHourglassPoints;
    case 'challenge':
      return state.greenCrownPoints;
    case 'basic':
    default:
      return state.unspentPoints;
  }
}

bool canAffordUpgrade(
  SkillTreeState state,
  UpgradeData data,
  int currentLevel,
) {
  if (currentLevel >= data.maxLevel) return false;
  return tokenBalance(state, data.costToken) >= data.getCost(currentLevel);
}

/// Deducts [amount] from the wallet matching [costToken].
/// Returns `null` if the balance is insufficient.
SkillTreeState? spendTokens(
  SkillTreeState state,
  String costToken,
  int amount,
) {
  if (amount < 0 || tokenBalance(state, costToken) < amount) return null;

  return switch (costToken) {
    'advanced' => state.copyWith(
      blueSquarePoints: state.blueSquarePoints - amount,
    ),
    'star' => state.copyWith(
      yellowStarPoints: state.yellowStarPoints - amount,
    ),
    'time' => state.copyWith(
      pinkHourglassPoints: state.pinkHourglassPoints - amount,
    ),
    'challenge' => state.copyWith(
      greenCrownPoints: state.greenCrownPoints - amount,
    ),
    _ => state.copyWith(unspentPoints: state.unspentPoints - amount),
  };
}

/// Godot `is_affordable_milestone` in `upgrade_node.gd`.
bool shouldShowMilestoneHighlight({
  required UpgradeData data,
  required ActivationLevel activationLevel,
  required bool canAfford,
}) {
  return data.isMilestone && canAfford && activationLevel == ActivationLevel.available;
}
