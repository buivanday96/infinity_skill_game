import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/models/upgrades.dart';
import 'package:infinity_skill_game/notifiers/skill_tree_notifier.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    container.listen(skillTreeProvider, (_, __) {});
  });

  tearDown(() {
    container.dispose();
  });

  SkillTreeNotifier notifier() => container.read(skillTreeProvider.notifier);

  group('SkillTreeNotifier.levelUpNode', () {
    test('spends 1 basic token for arrow_tower_unlock', () {
      notifier().generateInitialTree();
      final before = container.read(skillTreeProvider);

      notifier().levelUpNode(Upgrade.arrow_tower_unlock);

      final after = container.read(skillTreeProvider);
      expect(after.nodes[Upgrade.arrow_tower_unlock]?.currentLevel, 1);
      expect(after.unspentPoints, before.unspentPoints - 1);
      expect(after.blueSquarePoints, before.blueSquarePoints);
      expect(after.totalPoints, before.totalPoints);
    });

    test('spends 3 basic tokens for starting_gems at level 0', () {
      notifier().generateInitialTree();
      notifier().levelUpNode(Upgrade.arrow_tower_unlock);
      final before = container.read(skillTreeProvider);

      notifier().levelUpNode(Upgrade.starting_gems);

      final after = container.read(skillTreeProvider);
      expect(after.nodes[Upgrade.starting_gems]?.currentLevel, 1);
      expect(after.unspentPoints, before.unspentPoints - 3);
    });

    test('does not level up or spend when the player cannot afford it', () {
      notifier().generateInitialTree();
      notifier().levelUpNode(Upgrade.arrow_tower_unlock);
      // starting_gems costs [3, 10, 20, 40, 100]; after four buys remaining
      // unspent is 26, which cannot cover the last level.
      for (var i = 0; i < 4; i++) {
        notifier().levelUpNode(Upgrade.starting_gems);
      }

      final before = container.read(skillTreeProvider);
      expect(before.nodes[Upgrade.starting_gems]?.currentLevel, 4);
      expect(before.unspentPoints, 26);

      notifier().levelUpNode(Upgrade.starting_gems);

      final after = container.read(skillTreeProvider);
      expect(after.nodes[Upgrade.starting_gems]?.currentLevel, 4);
      expect(after.unspentPoints, 26);
    });
  });
}
