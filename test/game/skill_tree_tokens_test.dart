import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/game/skill_tree_tokens.dart';
import 'package:infinity_skill_game/models/skill_tree_state.dart';
import 'package:infinity_skill_game/models/upgrade_data.dart';
import 'package:infinity_skill_game/models/upgrades.dart';

void main() {
  const milestone = UpgradeData(
    maxLevel: 1,
    cost: 5,
    costToken: 'basic',
    isMilestone: true,
  );
  const artifact = UpgradeData(
    maxLevel: 1,
    cost: 5,
    costToken: 'star',
    isMilestone: true,
    isArtifact: true,
  );
  const regular = UpgradeData(
    maxLevel: 1,
    cost: 5,
    costToken: 'basic',
  );

  group('shouldShowMilestoneHighlight', () {
    test('shows for an affordable available milestone', () {
      expect(
        shouldShowMilestoneHighlight(
          data: milestone,
          activationLevel: ActivationLevel.available,
          canAfford: true,
        ),
        isTrue,
      );
    });

    test('shows for an affordable available artifact milestone', () {
      expect(
        shouldShowMilestoneHighlight(
          data: artifact,
          activationLevel: ActivationLevel.available,
          canAfford: true,
        ),
        isTrue,
      );
    });

    test('hides when the player cannot afford it', () {
      expect(
        shouldShowMilestoneHighlight(
          data: milestone,
          activationLevel: ActivationLevel.available,
          canAfford: false,
        ),
        isFalse,
      );
    });

    test('hides when the node is not available', () {
      expect(
        shouldShowMilestoneHighlight(
          data: milestone,
          activationLevel: ActivationLevel.discovered,
          canAfford: true,
        ),
        isFalse,
      );
    });

    test('hides for a regular non-milestone node', () {
      expect(
        shouldShowMilestoneHighlight(
          data: regular,
          activationLevel: ActivationLevel.available,
          canAfford: true,
        ),
        isFalse,
      );
    });
  });

  group('canAffordUpgrade', () {
    test('basic tokens use unspentPoints', () {
      expect(
        canAffordUpgrade(
          const SkillTreeState(unspentPoints: 5),
          milestone,
          0,
        ),
        isTrue,
      );
      expect(
        canAffordUpgrade(
          const SkillTreeState(unspentPoints: 4),
          milestone,
          0,
        ),
        isFalse,
      );
    });

    test('star tokens use yellowStarPoints', () {
      expect(
        canAffordUpgrade(
          const SkillTreeState(yellowStarPoints: 5),
          artifact,
          0,
        ),
        isTrue,
      );
      expect(
        canAffordUpgrade(
          const SkillTreeState(yellowStarPoints: 0),
          artifact,
          0,
        ),
        isFalse,
      );
    });

    test('returns false when already at maxLevel even with enough tokens', () {
      expect(
        canAffordUpgrade(
          const SkillTreeState(unspentPoints: 999),
          milestone,
          1,
        ),
        isFalse,
      );
    });
  });

  group('spendTokens', () {
    const wallet = SkillTreeState(
      unspentPoints: 10,
      totalPoints: 100,
      blueSquarePoints: 8,
      yellowStarPoints: 6,
      pinkHourglassPoints: 4,
      greenCrownPoints: 2,
    );

    test('deducts basic tokens from unspentPoints', () {
      final spent = spendTokens(wallet, 'basic', 3);
      expect(spent?.unspentPoints, 7);
      expect(spent?.totalPoints, 100);
      expect(spent?.blueSquarePoints, 8);
    });

    test('deducts the matching special token type', () {
      expect(spendTokens(wallet, 'advanced', 2)?.blueSquarePoints, 6);
      expect(spendTokens(wallet, 'star', 1)?.yellowStarPoints, 5);
      expect(spendTokens(wallet, 'time', 3)?.pinkHourglassPoints, 1);
      expect(spendTokens(wallet, 'challenge', 2)?.greenCrownPoints, 0);
    });

    test('returns null when the balance is insufficient', () {
      expect(spendTokens(wallet, 'basic', 11), isNull);
      expect(spendTokens(wallet, 'star', 7), isNull);
    });
  });

  group('tokenIconAsset', () {
    test('maps each cost token to the ui sprite', () {
      expect(tokenIconAsset('basic'), 'assets/ui/basic_token.png');
      expect(tokenIconAsset('advanced'), 'assets/ui/advanced_token.png');
      expect(tokenIconAsset('star'), 'assets/ui/star_token.png');
      expect(tokenIconAsset('time'), 'assets/ui/time_token.png');
      expect(tokenIconAsset('challenge'), 'assets/ui/challenge_token.png');
    });
  });
}
