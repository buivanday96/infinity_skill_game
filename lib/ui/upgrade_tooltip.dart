import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/skill_tree_tokens.dart';
import '../models/skill_node.dart';
import '../models/upgrade_data.dart';
import '../models/upgrades.dart';
import '../notifiers/skill_tree_notifier.dart';
import 'mobile_upgrade_button.dart';

class UpgradeTooltip extends ConsumerWidget {
  final Upgrade upgrade;
  final SkillNode node;
  final UpgradeData data;
  final VoidCallback onUpgrade;
  final VoidCallback onRefund;

  const UpgradeTooltip({
    super.key,
    required this.upgrade,
    required this.node,
    required this.data,
    required this.onUpgrade,
    required this.onRefund,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLevel = node.currentLevel;
    final maxLevel = data.maxLevel;
    final isMaxed = currentLevel >= maxLevel;
    final cost = data.getCost(currentLevel);
    final isAffordable = canAffordUpgrade(
      ref.watch(skillTreeProvider),
      data,
      currentLevel,
    );

    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getBorderColor(),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  upgrade.name.toUpperCase().replaceAll('_', ' '),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!data.isMilestone)
                Text(
                  '$currentLevel / $maxLevel',
                  style: TextStyle(
                    color: isMaxed ? Colors.amber : Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Value: ${data.getValue(currentLevel)}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),

          // Progress bar
          if (!data.isMilestone)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: maxLevel > 0 ? currentLevel / maxLevel : 0,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(_getBorderColor()),
                minHeight: 8,
              ),
            ),

          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              Expanded(
                child: MobileUpgradeButton(
                  label: isMaxed ? 'MAXED' : 'UPGRADE',
                  cost: cost,
                  costToken: data.costToken,
                  isMaxed: isMaxed,
                  isAffordable: isAffordable,
                  backgroundColor: isMaxed ? Colors.amber.withValues(alpha: 0.5) : (isAffordable ? Colors.blue.withValues(alpha: 0.5) : Colors.red.withValues(alpha: 0.5)),
                  onPressed: isMaxed || !isAffordable ? null : onUpgrade,
                ),
              ),
              if (!data.isMilestone && currentLevel > 0) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: MobileUpgradeButton(
                    label: 'REFUND',
                    cost: 0,
                    costToken: '',
                    showCost: false,
                    backgroundColor: Colors.grey.withValues(alpha: 0.5),
                    onPressed: onRefund,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getBorderColor() {
    switch (data.costToken) {
      case 'basic':
        return Colors.blue;
      case 'advanced':
        return Colors.purple;
      case 'star':
        return Colors.yellow;
      case 'time':
        return Colors.green;
      case 'challenge':
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
