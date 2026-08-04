import 'package:infinity_skill_game/features/hero/domain/hero_model.dart';
import 'package:infinity_skill_game/features/skill/domain/skill_model.dart';
import 'package:infinity_skill_game/features/stats/domain/modifier_source.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_id.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_modifier.dart';

/// One node in the persistent skill tree.
class SkillTreeNode {
  const SkillTreeNode({
    required this.id,
    required this.name,
    required this.description,
    this.cost = 1,
    this.requires = const [],
    this.modifiers = const [],
    this.unlockSkill,
    this.upgradeSkillId,
    this.maxRanks = 1,
  });

  final String id;
  final String name;
  final String description;
  final int cost;

  /// Prerequisite node ids that must already be unlocked.
  final List<String> requires;

  final List<StatModifier> modifiers;
  final SkillDefinition? unlockSkill;
  final String? upgradeSkillId;

  /// How many times this node can be purchased (rank stacking).
  final int maxRanks;
}

class SkillTree {
  SkillTree({required this.nodes});

  final List<SkillTreeNode> nodes;

  SkillTreeNode? nodeById(String id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }

  int ranksOf(HeroModel hero, String nodeId) {
    var count = 0;
    for (final key in hero.unlockedSkillTreeNodes) {
      if (key == nodeId || key.startsWith('$nodeId#')) count++;
    }
    return count;
  }

  bool canUnlock(HeroModel hero, String nodeId) {
    final node = nodeById(nodeId);
    if (node == null) return false;
    if (hero.skillPoints < node.cost) return false;
    if (ranksOf(hero, nodeId) >= node.maxRanks) return false;
    for (final req in node.requires) {
      if (ranksOf(hero, req) < 1) return false;
    }
    return true;
  }

  /// Spends skill points and applies modifiers / skills.
  /// Returns `false` if locked or unaffordable.
  bool unlock(HeroModel hero, String nodeId) {
    if (!canUnlock(hero, nodeId)) return false;
    final node = nodeById(nodeId)!;
    final nextRank = ranksOf(hero, nodeId) + 1;
    final key = nextRank == 1 ? nodeId : '$nodeId#$nextRank';

    hero.skillPoints -= node.cost;
    hero.unlockedSkillTreeNodes.add(key);

    final sourceKey = 'skill_tree:$nodeId';
    if (node.modifiers.isNotEmpty) {
      hero.applyModifiers(
        node.modifiers.map(
          (m) => m.copyWith(
            id: '$sourceKey:r$nextRank:${m.stat.name}',
            source: ModifierSource.skillTree,
            sourceKey: sourceKey,
          ),
        ),
      );
    }

    if (node.unlockSkill != null) {
      hero.addSkill(SkillInstance(definition: node.unlockSkill!));
    }
    if (node.upgradeSkillId != null) {
      hero.skillById(node.upgradeSkillId!)?.upgrade();
    }
    return true;
  }

  factory SkillTree.starter() {
    return SkillTree(
      nodes: const [
        SkillTreeNode(
          id: 'root_vitality',
          name: 'Vitality',
          description: '+50 Max HP.',
          cost: 1,
          modifiers: [
            StatModifier(
              id: 'tpl',
              stat: StatId.maxHp,
              source: ModifierSource.skillTree,
              flat: 50,
            ),
          ],
        ),
        SkillTreeNode(
          id: 'root_might',
          name: 'Might',
          description: '+8 Attack.',
          cost: 1,
          modifiers: [
            StatModifier(
              id: 'tpl',
              stat: StatId.attack,
              source: ModifierSource.skillTree,
              flat: 8,
            ),
          ],
        ),
        SkillTreeNode(
          id: 'root_haste',
          name: 'Haste',
          description: '+5% Attack Speed.',
          cost: 1,
          modifiers: [
            StatModifier(
              id: 'tpl',
              stat: StatId.attackSpeed,
              source: ModifierSource.skillTree,
              percent: 0.05,
            ),
          ],
        ),
        SkillTreeNode(
          id: 'branch_berserk',
          name: 'Berserk',
          description: '+10% Attack, -5% Defense.',
          cost: 2,
          requires: ['root_might'],
          maxRanks: 3,
          modifiers: [
            StatModifier(
              id: 'tpl_atk',
              stat: StatId.attack,
              source: ModifierSource.skillTree,
              percent: 0.10,
            ),
            StatModifier(
              id: 'tpl_def',
              stat: StatId.defense,
              source: ModifierSource.skillTree,
              percent: -0.05,
            ),
          ],
        ),
        SkillTreeNode(
          id: 'branch_iron',
          name: 'Iron Skin',
          description: '+12 Defense.',
          cost: 2,
          requires: ['root_vitality'],
          maxRanks: 3,
          modifiers: [
            StatModifier(
              id: 'tpl',
              stat: StatId.defense,
              source: ModifierSource.skillTree,
              flat: 12,
            ),
          ],
        ),
        SkillTreeNode(
          id: 'branch_swift',
          name: 'Swift Feet',
          description: '+8% Move Speed.',
          cost: 2,
          requires: ['root_haste'],
          maxRanks: 2,
          modifiers: [
            StatModifier(
              id: 'tpl',
              stat: StatId.moveSpeed,
              source: ModifierSource.skillTree,
              percent: 0.08,
            ),
          ],
        ),
      ],
    );
  }
}
