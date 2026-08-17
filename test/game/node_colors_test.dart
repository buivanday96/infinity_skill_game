import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/game/node_colors.dart';
import 'package:infinity_skill_game/game/skill_tree_tokens.dart';
import 'package:infinity_skill_game/models/upgrades.dart';
import 'package:infinity_skill_game/ui/core/app_color.dart';
import 'package:infinity_skill_game/ui/core/color_utils.dart';

void main() {
  group('NodeColors.tokenTypeColor', () {
    test('maps each cost token to the Godot tile tint', () {
      expect(NodeColors.tokenTypeColor('basic'), AppColor.tileTop);
      expect(
        NodeColors.tokenTypeColor('advanced'),
        AppColor.highlightedTileTopAdvanced,
      );
      expect(
        NodeColors.tokenTypeColor('star'),
        AppColor.highlightedTileTopStar,
      );
      expect(
        NodeColors.tokenTypeColor('time'),
        AppColor.highlightedTileTopTime,
      );
      expect(
        NodeColors.tokenTypeColor('challenge'),
        AppColor.highlightedTileTopChallenge,
      );
    });

    test('tokenHighlightColor delegates to tokenTypeColor', () {
      expect(tokenHighlightColor('star'), NodeColors.tokenTypeColor('star'));
      expect(
        tokenHighlightColor('advanced'),
        NodeColors.tokenTypeColor('advanced'),
      );
    });
  });

  group('NodeColors.tileTopColor', () {
    test('uses background before the node is leveled', () {
      expect(
        NodeColors.tileTopColor(
          activationLevel: ActivationLevel.available,
          costToken: 'basic',
          canAfford: true,
        ),
        AppColor.background,
      );
      expect(
        NodeColors.tileTopColor(
          activationLevel: ActivationLevel.revealed,
          costToken: 'star',
          canAfford: false,
        ),
        AppColor.background,
      );
    });

    test('uses token highlight when leveled and affordable', () {
      expect(
        NodeColors.tileTopColor(
          activationLevel: ActivationLevel.leveled,
          costToken: 'challenge',
          canAfford: true,
        ),
        AppColor.highlightedTileTopChallenge,
      );
      expect(
        NodeColors.tileTopColor(
          activationLevel: ActivationLevel.leveled,
          costToken: 'basic',
          canAfford: true,
        ),
        AppColor.tileTop,
      );
    });

    test('uses unavailable tint when leveled and unaffordable', () {
      expect(
        NodeColors.tileTopColor(
          activationLevel: ActivationLevel.leveled,
          costToken: 'star',
          canAfford: false,
        ),
        AppColor.unavailableTileTop,
      );
    });

    test('uses maxed token tints, or enchant color for artifacts', () {
      expect(
        NodeColors.tileTopColor(
          activationLevel: ActivationLevel.maxed,
          costToken: 'time',
          canAfford: true,
        ),
        AppColor.highlightedTileTopTimeMaxed,
      );
      expect(
        NodeColors.tileTopColor(
          activationLevel: ActivationLevel.maxed,
          costToken: 'star',
          canAfford: true,
          isArtifact: true,
          enchant: 'FIRE',
        ),
        AppColor.fireEnchant,
      );
    });
  });

  group('NodeColors.outlineColor', () {
    test('uses token color when available and affordable', () {
      expect(
        NodeColors.outlineColor(
          activationLevel: ActivationLevel.available,
          costToken: 'basic',
          canAfford: true,
        ),
        AppColor.tileTop,
      );
      expect(
        NodeColors.outlineColor(
          activationLevel: ActivationLevel.available,
          costToken: 'advanced',
          canAfford: true,
        ),
        AppColor.highlightedTileTopAdvanced,
      );
    });

    test('sets alpha 0.25 for discovered nodes', () {
      final color = NodeColors.outlineColor(
        activationLevel: ActivationLevel.discovered,
        costToken: 'basic',
        canAfford: false,
      );
      expect(color.a, closeTo(0.25, 0.001));
      expect(
        color.r,
        closeTo(ColorUtils.darkened(AppColor.subtleForeground, 0.6).r, 0.001),
      );
    });

    test('is fully transparent when leveled or maxed', () {
      expect(
        NodeColors.outlineColor(
          activationLevel: ActivationLevel.leveled,
          costToken: 'basic',
          canAfford: true,
        ).a,
        closeTo(0.0, 0.001),
      );
      expect(
        NodeColors.outlineColor(
          activationLevel: ActivationLevel.maxed,
          costToken: 'star',
          canAfford: true,
        ).a,
        closeTo(0.0, 0.001),
      );
    });
  });

  group('NodeColors.iconColor', () {
    test('is dim white when revealed or discovered', () {
      expect(
        NodeColors.iconColor(activationLevel: ActivationLevel.revealed).a,
        closeTo(0.25, 0.001),
      );
      expect(
        NodeColors.iconColor(activationLevel: ActivationLevel.discovered).a,
        closeTo(0.25, 0.001),
      );
    });

    test('is full white when available or leveled', () {
      expect(
        NodeColors.iconColor(activationLevel: ActivationLevel.available).a,
        closeTo(1.0, 0.001),
      );
      expect(
        NodeColors.iconColor(activationLevel: ActivationLevel.leveled).a,
        closeTo(1.0, 0.001),
      );
    });

    test('is 0.65 white when maxed and not hovering', () {
      expect(
        NodeColors.iconColor(activationLevel: ActivationLevel.maxed).a,
        closeTo(0.65, 0.001),
      );
    });
  });
}
