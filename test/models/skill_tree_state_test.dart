import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/models/skill_node.dart';
import 'package:infinity_skill_game/models/skill_tree_state.dart';
import 'package:infinity_skill_game/models/upgrades.dart';

void main() {
  group('SkillTreeState', () {
    test('copyWith can clear selectedNodeId', () {
      const selected = SkillTreeState(
        selectedNodeId: Upgrade.arrow_tower_unlock,
      );

      expect(
        selected.copyWith(selectedNodeId: null).selectedNodeId,
        isNull,
      );
    });

    test('copyWith keeps selectedNodeId when omitted', () {
      const selected = SkillTreeState(
        selectedNodeId: Upgrade.arrow_tower_unlock,
      );

      expect(
        selected.copyWith(unspentPoints: 1).selectedNodeId,
        Upgrade.arrow_tower_unlock,
      );
    });

    test('fromJson round-trips toJson', () {
      final original = SkillTreeState(
        nodes: {
          Upgrade.arrow_tower_unlock: SkillNode(
            id: Upgrade.arrow_tower_unlock,
            position: Vector2(10, 20),
            currentLevel: 1,
          ),
        },
        selectedNodeId: Upgrade.arrow_tower_unlock,
        unspentPoints: 7,
      );

      expect(SkillTreeState.fromJson(original.toJson()), original);
    });
  });
}
