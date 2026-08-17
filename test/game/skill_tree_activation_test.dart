import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/game/skill_tree_activation.dart';
import 'package:infinity_skill_game/models/node_state.dart';
import 'package:infinity_skill_game/models/skill_node.dart';
import 'package:infinity_skill_game/models/upgrade_data.dart';
import 'package:infinity_skill_game/models/upgrades.dart';

void main() {
  group('computeActivationLevel', () {
    test('root with no dependency and level 0 is available', () {
      expect(
        computeActivationLevel(
          currentLevel: 0,
          maxLevel: 1,
          current: ActivationLevel.hidden,
          dependencyLevel: null,
        ),
        ActivationLevel.available,
      );
    });

    test('child of an available parent is discovered', () {
      expect(
        computeActivationLevel(
          currentLevel: 0,
          maxLevel: 5,
          current: ActivationLevel.hidden,
          dependencyLevel: ActivationLevel.available,
        ),
        ActivationLevel.discovered,
      );
    });

    test('grandchild stays hidden when parent is only discovered', () {
      expect(
        computeActivationLevel(
          currentLevel: 0,
          maxLevel: 5,
          current: ActivationLevel.hidden,
          dependencyLevel: ActivationLevel.discovered,
        ),
        ActivationLevel.hidden,
      );
    });

    test('child of a leveled parent is available', () {
      expect(
        computeActivationLevel(
          currentLevel: 0,
          maxLevel: 5,
          current: ActivationLevel.discovered,
          dependencyLevel: ActivationLevel.leveled,
        ),
        ActivationLevel.available,
      );
    });

    test('once available, refunded parent leaves child revealed', () {
      expect(
        computeActivationLevel(
          currentLevel: 0,
          maxLevel: 5,
          current: ActivationLevel.available,
          dependencyLevel: ActivationLevel.available,
        ),
        ActivationLevel.revealed,
      );
    });

    test('max level is maxed', () {
      expect(
        computeActivationLevel(
          currentLevel: 5,
          maxLevel: 5,
          current: ActivationLevel.leveled,
          dependencyLevel: ActivationLevel.leveled,
        ),
        ActivationLevel.maxed,
      );
    });

    test('partial progress is leveled', () {
      expect(
        computeActivationLevel(
          currentLevel: 2,
          maxLevel: 5,
          current: ActivationLevel.available,
          dependencyLevel: ActivationLevel.leveled,
        ),
        ActivationLevel.leveled,
      );
    });
  });

  group('nodeStateFrom', () {
    test('maps activation levels to visual node states', () {
      expect(nodeStateFrom(ActivationLevel.hidden), NodeState.disabled);
      expect(nodeStateFrom(ActivationLevel.discovered), NodeState.disabled);
      expect(nodeStateFrom(ActivationLevel.revealed), NodeState.disabled);
      expect(nodeStateFrom(ActivationLevel.available), NodeState.enabled);
      expect(nodeStateFrom(ActivationLevel.leveled), NodeState.active);
      expect(nodeStateFrom(ActivationLevel.maxed), NodeState.upgraded);
    });
  });

  group('propagateActivation', () {
    late Map<Upgrade, UpgradeData> upgrades;
    late Map<Upgrade, List<Upgrade>> dependents;

    SkillNode hiddenNode(Upgrade id) {
      return SkillNode(
        id: id,
        position: Vector2.zero(),
        currentLevel: 0,
      );
    }

    setUp(() {
      upgrades = {
        Upgrade.arrow_tower_unlock: const UpgradeData(
          maxLevel: 1,
          cost: 1,
          costToken: 'basic',
        ),
        Upgrade.starting_gems: const UpgradeData(
          maxLevel: 5,
          cost: 1,
          costToken: 'basic',
          dependency: Upgrade.arrow_tower_unlock,
        ),
        Upgrade.starting_gems_2: const UpgradeData(
          maxLevel: 5,
          cost: 1,
          costToken: 'basic',
          dependency: Upgrade.starting_gems,
        ),
      };
      dependents = buildDependentsIndex(upgrades);
    });

    test('initial spread: root available, child discovered, grandchild hidden', () {
      final nodes = <Upgrade, SkillNode>{
        Upgrade.arrow_tower_unlock: hiddenNode(Upgrade.arrow_tower_unlock),
        Upgrade.starting_gems: hiddenNode(Upgrade.starting_gems),
        Upgrade.starting_gems_2: hiddenNode(Upgrade.starting_gems_2),
      };

      propagateFromRoot(
        nodes,
        dependents: dependents,
        upgrades: upgrades,
      );

      expect(
        nodes[Upgrade.arrow_tower_unlock]!.activationLevel,
        ActivationLevel.available,
      );
      expect(
        nodes[Upgrade.starting_gems]!.activationLevel,
        ActivationLevel.discovered,
      );
      expect(
        nodes[Upgrade.starting_gems_2]!.activationLevel,
        ActivationLevel.hidden,
      );
      expect(nodes[Upgrade.starting_gems]!.isVisible, isTrue);
      expect(nodes[Upgrade.starting_gems_2]!.isVisible, isFalse);
    });

    test('buying the root makes children available and grandchildren discovered', () {
      final nodes = <Upgrade, SkillNode>{
        Upgrade.arrow_tower_unlock: hiddenNode(Upgrade.arrow_tower_unlock),
        Upgrade.starting_gems: hiddenNode(Upgrade.starting_gems),
        Upgrade.starting_gems_2: hiddenNode(Upgrade.starting_gems_2),
      };

      propagateFromRoot(
        nodes,
        dependents: dependents,
        upgrades: upgrades,
      );

      nodes[Upgrade.arrow_tower_unlock] = nodes[Upgrade.arrow_tower_unlock]!
          .copyWith(currentLevel: 1);
      updateActivationLevel(
        nodes,
        Upgrade.arrow_tower_unlock,
        dependents: dependents,
        upgrades: upgrades,
        forceUpdate: true,
      );

      expect(
        nodes[Upgrade.arrow_tower_unlock]!.activationLevel,
        ActivationLevel.maxed,
      );
      expect(
        nodes[Upgrade.starting_gems]!.activationLevel,
        ActivationLevel.available,
      );
      expect(
        nodes[Upgrade.starting_gems_2]!.activationLevel,
        ActivationLevel.discovered,
      );
    });

    test('refunded parent leaves a previously available child revealed', () {
      final nodes = <Upgrade, SkillNode>{
        Upgrade.arrow_tower_unlock: hiddenNode(Upgrade.arrow_tower_unlock),
        Upgrade.starting_gems: hiddenNode(Upgrade.starting_gems),
        Upgrade.starting_gems_2: hiddenNode(Upgrade.starting_gems_2),
      };

      propagateFromRoot(
        nodes,
        dependents: dependents,
        upgrades: upgrades,
      );
      nodes[Upgrade.arrow_tower_unlock] = nodes[Upgrade.arrow_tower_unlock]!
          .copyWith(currentLevel: 1);
      updateActivationLevel(
        nodes,
        Upgrade.arrow_tower_unlock,
        dependents: dependents,
        upgrades: upgrades,
        forceUpdate: true,
      );

      nodes[Upgrade.arrow_tower_unlock] = nodes[Upgrade.arrow_tower_unlock]!
          .copyWith(currentLevel: 0);
      updateActivationLevel(
        nodes,
        Upgrade.arrow_tower_unlock,
        dependents: dependents,
        upgrades: upgrades,
        forceUpdate: true,
      );

      expect(
        nodes[Upgrade.arrow_tower_unlock]!.activationLevel,
        ActivationLevel.available,
      );
      expect(
        nodes[Upgrade.starting_gems]!.activationLevel,
        ActivationLevel.revealed,
      );
      expect(
        nodes[Upgrade.starting_gems_2]!.activationLevel,
        ActivationLevel.discovered,
      );
    });
  });
}
