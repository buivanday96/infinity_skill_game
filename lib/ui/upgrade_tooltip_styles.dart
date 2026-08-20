import 'package:flutter/material.dart';

import '../game/skill_tree_tokens.dart' as tokens;
import '../l10n/game_strings.dart';
import '../l10n/upgrade_tooltip_text.dart';
import '../models/upgrade_data.dart';
import '../models/upgrades.dart';
import 'core/app_color.dart';
import 'core/color_utils.dart';

/// Godot `upgrade_tooltip.gd` `setup_styleboxes` bar state.
enum UpgradeTooltipBarState { afford, unavailable, maxed }

/// Fill + background pair for the cost / level progress bar.
class UpgradeTooltipBarStyle {
  const UpgradeTooltipBarStyle({required this.fill, required this.background});

  final Color fill;
  final Color background;
}

/// What the cost bar overlay shows (Godot RegularUnlock vs MilestoneUnlock).
enum UpgradeTooltipCostContent {
  regular,
  milestoneUnlock,
  milestoneClaimed,
  maxed,
}

/// Godot `tooltip_panel.tres` + `setup_styleboxes`.
abstract final class UpgradeTooltipStyles {
  /// `ui/tooltip_panel.tres` `bg_color`.
  static const panelColor = Color.from(
    alpha: 0.89411765,
    red: 0.026026683,
    green: 0.0096,
    blue: 0.08,
  );

  static const panelRadius = 12.0;
  static const width = 320.0;
  static const costBarHeight = 36.0;

  static const leftClickAsset = 'assets/ui/left_click.png';
  static const rightClickAsset = 'assets/ui/right_click.png';

  static String get upgradeActionLabel => GameStrings.tr('TOOLTIP_UPGRADE');
  static String get refundActionLabel => GameStrings.tr('TOOLTIP_REFUND');
  static const shiftLabel = '[Shift]';
  static String get maxedLabel => GameStrings.tr('UPGRADE_MAXED');
  static const unlocksDescription = 'Unlocks this upgrade';
  static String get milestoneUnlockLabel =>
      GameStrings.tr('TOOLTIP_MILESTONE_UNLOCK_SHORT');
  static String get milestoneClaimedLabel =>
      GameStrings.tr('TOOLTIP_MILESTONE_CLAIMED_SHORT');
  static String get freeMilestoneLabel => GameStrings.tr('FREE_MILESTONE');
  static String get milestoneClaimedDynamicLabel =>
      GameStrings.tr('TOOLTIP_MILESTONE_CLAIMED_DYNAMIC');
  static const milestoneUnlockLeading = 'Available at ';
  static const milestoneUnlockTrailing = ' total collected';
  static const milestoneClaimedTrailing = ' total milestone claimed';

  /// Godot `MilestoneLabel` theme override in `upgrade_tooltip.tscn`.
  static const freeMilestoneColor = Color.from(
    alpha: 1,
    red: 0.14901961,
    green: 0.7294118,
    blue: 0.59607846,
  );

  /// Godot `match token_type` tint used for afford fill.
  static Color tokenColor(String costToken) {
    switch (costToken) {
      case 'challenge':
        return AppColor.highlightedTileTopChallenge;
      case 'time':
        return ColorUtils.desaturated(AppColor.highlightedTileTopTime, 0.2);
      case 'star':
        return AppColor.highlightedTileTopStar;
      case 'advanced':
        return AppColor.highlightedTileTopAdvanced;
      default:
        return AppColor.tileTop;
    }
  }

  static Color maxedFillColor(String costToken) {
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

  /// Godot `setup_styleboxes` for one token + bar state.
  static UpgradeTooltipBarStyle setup({
    required String costToken,
    required UpgradeTooltipBarState state,
  }) {
    switch (state) {
      case UpgradeTooltipBarState.afford:
        final fill = ColorUtils.withAlpha(tokenColor(costToken), 0.3);
        return UpgradeTooltipBarStyle(
          fill: fill,
          background: ColorUtils.withAlpha(fill, 0.3),
        );
      case UpgradeTooltipBarState.unavailable:
        final fill = ColorUtils.withAlpha(AppColor.failBackground, 0.3);
        return UpgradeTooltipBarStyle(fill: fill, background: fill);
      case UpgradeTooltipBarState.maxed:
        final fill = ColorUtils.withAlpha(maxedFillColor(costToken), 0.5);
        return UpgradeTooltipBarStyle(fill: fill, background: fill);
    }
  }

  static Color unaffordableCostColor() {
    return ColorUtils.darkened(AppColor.subtleForeground, 0.1);
  }

  static Color mobileUpgradeBackground({
    required String costToken,
    required UpgradeTooltipBarState state,
  }) {
    final bar = setup(costToken: costToken, state: state);
    if (state == UpgradeTooltipBarState.afford) {
      return ColorUtils.withAlpha(bar.fill, 0.65);
    }
    return bar.fill;
  }

  static Color mobileRefundBackground({required bool canRefund}) {
    return ColorUtils.withAlpha(
      AppColor.subtleForeground,
      canRefund ? 0.25 : 0.0,
    );
  }
}

/// Presentational snapshot so [UpgradeTooltip] stays a dumb view.
class UpgradeTooltipViewData {
  const UpgradeTooltipViewData({
    required this.title,
    required this.rankText,
    required this.showRank,
    required this.rankColor,
    required this.description,
    required this.showRefundHint,
    required this.showActionLegend,
    required this.showFreeMilestone,
    required this.upgradeActionOpacity,
    required this.refundActionOpacity,
    required this.barState,
    required this.barStyle,
    required this.progress,
    required this.costText,
    required this.costColor,
    required this.tokenIconAsset,
    required this.showTokenIcon,
    required this.costContent,
    required this.milestoneLeading,
    required this.milestoneTrailing,
    required this.showMilestoneCost,
    required this.milestoneCost,
    required this.isMaxed,
    required this.isAffordable,
    required this.canUpgrade,
    required this.canRefund,
    required this.mobileUpgradeLabel,
    required this.mobileUpgradeBackground,
    required this.mobileRefundBackground,
    required this.showMobileRefund,
    required this.showMobileCost,
    required this.cost,
    required this.costToken,
  });

  final String title;
  final String rankText;
  final bool showRank;
  final Color rankColor;
  final String description;
  final bool showRefundHint;
  final bool showActionLegend;
  final bool showFreeMilestone;
  final double upgradeActionOpacity;
  final double refundActionOpacity;
  final UpgradeTooltipBarState barState;
  final UpgradeTooltipBarStyle barStyle;
  final double progress;
  final String costText;
  final Color costColor;
  final String tokenIconAsset;
  final bool showTokenIcon;
  final UpgradeTooltipCostContent costContent;
  final String milestoneLeading;
  final String milestoneTrailing;
  final bool showMilestoneCost;
  final int milestoneCost;
  final bool isMaxed;
  final bool isAffordable;
  final bool canUpgrade;
  final bool canRefund;
  final String mobileUpgradeLabel;
  final Color mobileUpgradeBackground;
  final Color mobileRefundBackground;
  final bool showMobileRefund;
  final bool showMobileCost;
  final int cost;
  final String costToken;

  factory UpgradeTooltipViewData.from({
    required Upgrade upgrade,
    required UpgradeData data,
    required int currentLevel,
    required bool isAffordable,
  }) {
    // Godot `update()`: level_progress = current / max.
    final maxLevel = data.maxLevel;
    final progress = maxLevel > 0
        ? (currentLevel / maxLevel).clamp(0.0, 1.0)
        : 0.0;
    final isMaxed = progress >= 1.0;
    final cost = data.getCost(currentLevel);
    final showRefundHint = !data.isMilestone || data.isArtifact;
    final canRefund = progress > 0.0 && showRefundHint;

    var showActionLegend = true;
    var showFreeMilestone = false;
    var upgradeActionOpacity = 1.0;
    var refundActionOpacity = progress > 0.0 ? 1.0 : 0.5;
    var mobileUpgradeLabel = UpgradeTooltipStyles.upgradeActionLabel;
    var milestoneLeading = '';
    var milestoneTrailing = '';
    var showMilestoneCost = true;
    var costText = _formatCost(cost);
    var costColor = Colors.white;
    late final UpgradeTooltipBarState barState;
    late final UpgradeTooltipCostContent costContent;

    if (isMaxed) {
      if (data.isMilestone) {
        if (!data.isArtifact) {
          showActionLegend = false;
        }
        if (data.dynamicCost) {
          milestoneLeading = UpgradeTooltipStyles.milestoneClaimedDynamicLabel;
          showMilestoneCost = false;
        } else {
          milestoneTrailing = UpgradeTooltipStyles.milestoneClaimedTrailing;
        }
        mobileUpgradeLabel = UpgradeTooltipStyles.milestoneClaimedLabel;
        costContent = UpgradeTooltipCostContent.milestoneClaimed;
      } else {
        costText = UpgradeTooltipStyles.maxedLabel;
        mobileUpgradeLabel = UpgradeTooltipStyles.maxedLabel;
        costContent = UpgradeTooltipCostContent.maxed;
      }
      barState = UpgradeTooltipBarState.maxed;
      upgradeActionOpacity = 0.5;
      refundActionOpacity = 1.0;
    } else {
      refundActionOpacity = progress > 0.0 ? 1.0 : 0.5;
      if (data.isMilestone) {
        showFreeMilestone = true;
        milestoneLeading = UpgradeTooltipStyles.milestoneUnlockLeading;
        milestoneTrailing = UpgradeTooltipStyles.milestoneUnlockTrailing;
        mobileUpgradeLabel = UpgradeTooltipStyles.milestoneUnlockLabel;
        costContent = UpgradeTooltipCostContent.milestoneUnlock;
      } else {
        mobileUpgradeLabel = UpgradeTooltipStyles.upgradeActionLabel;
        costContent = UpgradeTooltipCostContent.regular;
      }

      if (isAffordable) {
        upgradeActionOpacity = 1.0;
        barState = UpgradeTooltipBarState.afford;
        costText = _formatCost(cost);
        costColor = Colors.white;
      } else {
        upgradeActionOpacity = 0.5;
        barState = UpgradeTooltipBarState.unavailable;
        costText = _formatCost(cost);
        costColor = UpgradeTooltipStyles.unaffordableCostColor();
      }
    }

    return UpgradeTooltipViewData(
      title: tooltipTitle(upgrade),
      rankText: '$currentLevel / $maxLevel',
      showRank: !data.isMilestone,
      rankColor: AppColor.highlightedTileTopStar,
      description: tooltipDescription(upgrade, data, currentLevel),
      showRefundHint: showRefundHint,
      showActionLegend: showActionLegend,
      showFreeMilestone: showFreeMilestone,
      upgradeActionOpacity: upgradeActionOpacity,
      refundActionOpacity: refundActionOpacity,
      barState: barState,
      barStyle: UpgradeTooltipStyles.setup(
        costToken: data.costToken,
        state: barState,
      ),
      progress: progress,
      costText: costText,
      costColor: costColor,
      tokenIconAsset: tokens.tokenIconAsset(data.costToken),
      showTokenIcon:
          progress < 1.0 && costContent == UpgradeTooltipCostContent.regular,
      costContent: costContent,
      milestoneLeading: milestoneLeading,
      milestoneTrailing: milestoneTrailing,
      showMilestoneCost: showMilestoneCost,
      milestoneCost: data.getCost(0),
      isMaxed: isMaxed,
      isAffordable: isAffordable,
      canUpgrade: !isMaxed && isAffordable,
      canRefund: canRefund,
      mobileUpgradeLabel: mobileUpgradeLabel,
      mobileUpgradeBackground: UpgradeTooltipStyles.mobileUpgradeBackground(
        costToken: data.costToken,
        state: barState,
      ),
      mobileRefundBackground: UpgradeTooltipStyles.mobileRefundBackground(
        canRefund: canRefund,
      ),
      showMobileRefund: showRefundHint,
      showMobileCost: !isMaxed && !data.isMilestone,
      cost: cost,
      costToken: data.costToken,
    );
  }
}

String tooltipTitle(Upgrade upgrade) => localizedTooltipTitle(upgrade);

String tooltipDescription(
  Upgrade upgrade,
  UpgradeData data,
  int currentLevel,
) {
  return localizedTooltipDescription(upgrade, data, currentLevel);
}

String _formatCost(int cost) => '$cost';
