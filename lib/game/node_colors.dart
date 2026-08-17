import 'package:flutter/material.dart';

import '../models/upgrades.dart';
import '../ui/core/app_color.dart';
import '../ui/core/color_utils.dart';

/// Godot `upgrade_node.gd` tile/outline/icon color rules (non-hover path).
abstract final class NodeColors {
  static Color tokenTypeColor(String costToken) {
    switch (costToken) {
      case 'star':
        return AppColor.highlightedTileTopStar;
      case 'challenge':
        return AppColor.highlightedTileTopChallenge;
      case 'time':
        return AppColor.highlightedTileTopTime;
      case 'basic':
        return AppColor.tileTop;
      case 'advanced':
        return AppColor.highlightedTileTopAdvanced;
      default:
        return Colors.white;
    }
  }

  static Color enchantColor(String? enchant) {
    switch (enchant) {
      case 'FIRE':
        return AppColor.fireEnchant;
      case 'LIGHT':
        return AppColor.lightEnchant;
      case 'EARTH':
        return AppColor.earthEnchant;
      case 'ICE':
        return AppColor.iceEnchant;
      case 'WIND':
        return AppColor.windEnchant;
      default:
        return Colors.white;
    }
  }

  static Color tileTopColor({
    required ActivationLevel activationLevel,
    required String costToken,
    required bool canAfford,
    bool isArtifact = false,
    String? enchant,
  }) {
    if (activationLevel == ActivationLevel.maxed) {
      if (isArtifact) {
        return enchantColor(enchant);
      }
      switch (costToken) {
        case 'challenge':
          return AppColor.highlightedTileTopChallengeMaxed;
        case 'time':
          return AppColor.highlightedTileTopTimeMaxed;
        case 'star':
          return AppColor.highlightedTileTopStarMaxed;
        case 'advanced':
          return AppColor.highlightedTileTopAdvancedMaxed;
        default:
          return AppColor.highlightedTileTopMaxed;
      }
    }

    if (activationLevel == ActivationLevel.leveled) {
      if (canAfford) {
        switch (costToken) {
          case 'challenge':
            return AppColor.highlightedTileTopChallenge;
          case 'time':
            return AppColor.highlightedTileTopTime;
          case 'advanced':
            return AppColor.highlightedTileTopAdvanced;
          default:
            return AppColor.tileTop;
        }
      }
      return AppColor.unavailableTileTop;
    }

    return AppColor.background;
  }

  static Color tileBottomColor({
    required ActivationLevel activationLevel,
    required String costToken,
    required bool canAfford,
    bool isArtifact = false,
    String? enchant,
  }) {
    if (activationLevel == ActivationLevel.maxed) {
      if (isArtifact) {
        return ColorUtils.darkenedHueShift(enchantColor(enchant));
      }
      switch (costToken) {
        case 'challenge':
          return ColorUtils.mixColors(
            ColorUtils.darkened(AppColor.highlightedTileBottomChallenge, 0.2),
            AppColor.background,
            0.3,
          );
        case 'time':
          return ColorUtils.mixColors(
            ColorUtils.darkened(AppColor.highlightedTileBottomTime, 0.2),
            AppColor.background,
            0.3,
          );
        case 'star':
          return ColorUtils.darkened(AppColor.highlightedTileBottomStar, 0.15);
        case 'advanced':
          return AppColor.highlightedTileBottomAdvancedMaxed;
        default:
          return AppColor.highlightedTileBottomMaxed;
      }
    }

    if (activationLevel == ActivationLevel.leveled) {
      if (canAfford) {
        switch (costToken) {
          case 'challenge':
            return AppColor.highlightedTileBottomChallenge;
          case 'time':
            return AppColor.highlightedTileBottomTime;
          case 'advanced':
            return AppColor.highlightedTileBottomAdvanced;
          default:
            return AppColor.tileBottom;
        }
      }
      return AppColor.unavailableTileBottom;
    }

    return ColorUtils.darkened(AppColor.background, 0.15);
  }

  static Color outlineColor({
    required ActivationLevel activationLevel,
    required String costToken,
    required bool canAfford,
    bool ignoreAffordability = false,
  }) {
    var color = AppColor.tileTop;
    final availableColor = tokenTypeColor(costToken);

    if (activationLevel == ActivationLevel.available) {
      color = availableColor;
    } else if (activationLevel == ActivationLevel.revealed) {
      switch (costToken) {
        case 'challenge':
          color = AppColor.highlightedTileTopChallenge;
        case 'time':
          color = AppColor.highlightedTileTopTime;
        default:
          color = ColorUtils.darkened(AppColor.subtleForeground, 0.6);
      }
    }

    if (activationLevel == ActivationLevel.revealed && costToken != 'basic') {
      color = ColorUtils.mixColors(
        availableColor,
        ColorUtils.darkened(AppColor.subtleForeground, 0.4),
        0.75,
      );
    } else if (!ignoreAffordability && !canAfford) {
      color = ColorUtils.darkened(AppColor.unavailableTileTop, 0.15);
    }

    if (activationLevel == ActivationLevel.discovered) {
      color = ColorUtils.withAlpha(
        ColorUtils.darkened(AppColor.subtleForeground, 0.6),
        0.25,
      );
    }

    if (activationLevel.index >= ActivationLevel.leveled.index) {
      color = ColorUtils.withAlpha(color, 0.0);
    }

    return color;
  }

  static Color iconColor({
    required ActivationLevel activationLevel,
    bool isHovering = false,
  }) {
    if (activationLevel == ActivationLevel.maxed) {
      return ColorUtils.withAlpha(Colors.white, isHovering ? 1.0 : 0.65);
    }
    if (activationLevel.index >= ActivationLevel.available.index) {
      return Colors.white;
    }
    return const Color.from(alpha: 0.25, red: 1, green: 1, blue: 1);
  }
}
