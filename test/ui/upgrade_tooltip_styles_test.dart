import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/game/skill_tree_tokens.dart';
import 'package:infinity_skill_game/models/upgrade_data.dart';
import 'package:infinity_skill_game/models/upgrades.dart';
import 'package:infinity_skill_game/ui/core/app_color.dart';
import 'package:infinity_skill_game/ui/core/color_utils.dart';
import 'package:infinity_skill_game/ui/upgrade_tooltip_styles.dart';

void main() {
  group('UpgradeTooltipStyles.tokenColor', () {
    test('maps each cost token to the Godot setup_styleboxes tint', () {
      expect(
        UpgradeTooltipStyles.tokenColor('challenge'),
        AppColor.highlightedTileTopChallenge,
      );
      expect(
        UpgradeTooltipStyles.tokenColor('time'),
        ColorUtils.desaturated(AppColor.highlightedTileTopTime, 0.2),
      );
      expect(
        UpgradeTooltipStyles.tokenColor('star'),
        AppColor.highlightedTileTopStar,
      );
      expect(
        UpgradeTooltipStyles.tokenColor('advanced'),
        AppColor.highlightedTileTopAdvanced,
      );
      expect(UpgradeTooltipStyles.tokenColor('basic'), AppColor.tileTop);
    });
  });

  group('UpgradeTooltipStyles.setup', () {
    test('afford uses token at 0.3 then that color at 0.3 again', () {
      final style = UpgradeTooltipStyles.setup(
        costToken: 'basic',
        state: UpgradeTooltipBarState.afford,
      );
      final expectedFill = ColorUtils.withAlpha(AppColor.tileTop, 0.3);
      expect(style.fill, expectedFill);
      expect(style.background, ColorUtils.withAlpha(expectedFill, 0.3));
    });

    test('unavailable uses failBackground at 0.3 for fill and background', () {
      final style = UpgradeTooltipStyles.setup(
        costToken: 'star',
        state: UpgradeTooltipBarState.unavailable,
      );
      final expected = ColorUtils.withAlpha(AppColor.failBackground, 0.3);
      expect(style.fill, expected);
      expect(style.background, expected);
    });

    test('maxed uses the token maxed tint at 0.5 alpha', () {
      final style = UpgradeTooltipStyles.setup(
        costToken: 'advanced',
        state: UpgradeTooltipBarState.maxed,
      );
      final expected = ColorUtils.withAlpha(
        AppColor.highlightedTileTopAdvancedMaxed,
        0.5,
      );
      expect(style.fill, expected);
      expect(style.background, expected);
    });
  });

  group('UpgradeTooltipViewData', () {
    const regular = UpgradeData(
      maxLevel: 1,
      cost: 10,
      costToken: 'basic',
    );
    const milestone = UpgradeData(
      maxLevel: 1,
      cost: 5,
      costToken: 'basic',
      isMilestone: true,
    );
    const valued = UpgradeData(
      maxLevel: 5,
      cost: 3,
      costToken: 'basic',
      value: 8,
    );

    test('shows rank 0 / 1, cost 10, and unlocks copy for a regular node', () {
      final view = UpgradeTooltipViewData.from(
        upgrade: Upgrade.arrow_tower_unlock,
        data: regular,
        currentLevel: 0,
        isAffordable: true,
      );

      expect(view.title, 'Arrow Tower Unlock');
      expect(view.rankText, '0 / 1');
      expect(view.showRank, isTrue);
      expect(view.costText, '10');
      expect(view.description, contains('Unlocks the'));
      expect(view.description, contains('Arrow Tower'));
      expect(view.barState, UpgradeTooltipBarState.afford);
      expect(view.showTokenIcon, isTrue);
      expect(view.tokenIconAsset, tokenIconAsset('basic'));
      expect(view.progress, 0);
    });

    test('hides rank and regular cost for an unclaimed milestone', () {
      final view = UpgradeTooltipViewData.from(
        upgrade: Upgrade.arrow_tower_unlock,
        data: milestone,
        currentLevel: 0,
        isAffordable: true,
      );

      expect(view.showRank, isFalse);
      expect(view.showRefundHint, isFalse);
      expect(view.showMobileRefund, isFalse);
      expect(view.showFreeMilestone, isTrue);
      expect(view.showActionLegend, isTrue);
      expect(view.costContent, UpgradeTooltipCostContent.milestoneUnlock);
      expect(
        view.milestoneLeading,
        UpgradeTooltipStyles.milestoneUnlockLeading,
      );
      expect(
        view.milestoneTrailing,
        UpgradeTooltipStyles.milestoneUnlockTrailing,
      );
      expect(view.milestoneCost, 5);
      expect(
        view.mobileUpgradeLabel,
        UpgradeTooltipStyles.milestoneUnlockLabel,
      );
    });

    test('dims the upgrade hint and uses fail bar when unaffordable', () {
      final view = UpgradeTooltipViewData.from(
        upgrade: Upgrade.arrow_tower_unlock,
        data: regular,
        currentLevel: 0,
        isAffordable: false,
      );

      expect(view.barState, UpgradeTooltipBarState.unavailable);
      expect(
        view.barStyle.fill,
        UpgradeTooltipStyles.setup(
          costToken: 'basic',
          state: UpgradeTooltipBarState.unavailable,
        ).fill,
      );
      expect(view.costColor, UpgradeTooltipStyles.unaffordableCostColor());
      expect(view.canUpgrade, isFalse);
      expect(view.upgradeActionOpacity, 0.5);
      expect(view.refundActionOpacity, 0.5);
    });

    test('maxed regular node shows Max, hides token, dims upgrade hint', () {
      final view = UpgradeTooltipViewData.from(
        upgrade: Upgrade.arrow_tower_unlock,
        data: regular,
        currentLevel: 1,
        isAffordable: false,
      );

      expect(view.isMaxed, isTrue);
      expect(view.barState, UpgradeTooltipBarState.maxed);
      expect(view.costText, UpgradeTooltipStyles.maxedLabel);
      expect(view.showTokenIcon, isFalse);
      expect(view.upgradeActionOpacity, 0.5);
      expect(view.refundActionOpacity, 1.0);
      expect(view.mobileUpgradeLabel, UpgradeTooltipStyles.maxedLabel);
      expect(view.progress, 1.0);
    });

    test('maxed non-artifact milestone hides the action legend', () {
      final view = UpgradeTooltipViewData.from(
        upgrade: Upgrade.arrow_tower_unlock,
        data: milestone,
        currentLevel: 1,
        isAffordable: false,
      );

      expect(view.showActionLegend, isFalse);
      expect(view.showFreeMilestone, isFalse);
      expect(view.costContent, UpgradeTooltipCostContent.milestoneClaimed);
      expect(
        view.milestoneTrailing,
        UpgradeTooltipStyles.milestoneClaimedTrailing,
      );
      expect(view.showMilestoneCost, isTrue);
      expect(
        view.mobileUpgradeLabel,
        UpgradeTooltipStyles.milestoneClaimedLabel,
      );
    });

    test('maxed dynamic-cost milestone shows Milestone claimed', () {
      const dynamicMilestone = UpgradeData(
        maxLevel: 1,
        cost: 5,
        costToken: 'star',
        isMilestone: true,
        isArtifact: true,
        dynamicCost: true,
      );
      final view = UpgradeTooltipViewData.from(
        upgrade: Upgrade.arrow_tower_unlock,
        data: dynamicMilestone,
        currentLevel: 1,
        isAffordable: false,
      );

      expect(view.showActionLegend, isTrue);
      expect(
        view.milestoneLeading,
        UpgradeTooltipStyles.milestoneClaimedDynamicLabel,
      );
      expect(view.showMilestoneCost, isFalse);
    });

    test('formats a localized numeric value description', () {
      final view = UpgradeTooltipViewData.from(
        upgrade: Upgrade.starting_gems,
        data: valued,
        currentLevel: 0,
        isAffordable: true,
      );
      expect(view.description, contains('start each run'));
      expect(view.description, contains('[value_after]8[/value_after]'));
    });
  });

  group('tooltipTitle', () {
    test('humanizes the upgrade enum name when no title is mapped', () {
      expect(tooltipTitle(Upgrade.arrow_tower_unlock), 'Arrow Tower Unlock');
    });

    test('uses recovered Godot titles', () {
      expect(tooltipTitle(Upgrade.gem_cannon), 'Coin Cannon');
      expect(tooltipTitle(Upgrade.lightning_tower_overkill_damage), 'Overkill');
      expect(tooltipTitle(Upgrade.slow_tower_damage_link), 'Damage Link');
    });
  });
}
