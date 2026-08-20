import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/models/node_state.dart';
import 'package:infinity_skill_game/models/skill_node.dart';
import 'package:infinity_skill_game/models/upgrades.dart';

void main() {
  group('SkillNode', () {
    SkillNode node({
      int currentLevel = 0,
      List<Upgrade> connected = const [],
    }) {
      return SkillNode(
        id: Upgrade.arrow_tower_unlock,
        position: Vector2(1.5, 2.5),
        connectedNodeIds: connected,
        currentLevel: currentLevel,
      );
    }

    test('copyWith updates only the given field', () {
      final original = node();
      final updated = original.copyWith(currentLevel: 3);

      expect(updated.currentLevel, 3);
      expect(updated.id, original.id);
      expect(updated.position, original.position);
    });

    test('fromJson round-trips toJson', () {
      final original =
          node(
            currentLevel: 2,
            connected: const [Upgrade.arrow_tower_damage],
          ).copyWith(
            state: NodeState.enabled,
            activationLevel: ActivationLevel.revealed,
          );

      expect(SkillNode.fromJson(original.toJson()), original);
    });

    test('isVisible is false while hidden', () {
      expect(node().isVisible, isFalse);
      expect(
        node().copyWith(activationLevel: ActivationLevel.discovered).isVisible,
        isTrue,
      );
    });
  });
}
