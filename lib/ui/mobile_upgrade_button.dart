import 'package:flutter/material.dart';

class MobileUpgradeButton extends StatelessWidget {
  final String label;
  final int cost;
  final String costToken;
  final bool showCost;
  final bool isAffordable;
  final bool isMaxed;
  final VoidCallback? onPressed;
  final Color backgroundColor;

  const MobileUpgradeButton({
    super.key,
    required this.label,
    required this.cost,
    required this.costToken,
    this.showCost = true,
    this.isAffordable = true,
    this.isMaxed = false,
    this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (showCost && !isMaxed) ...[
                const SizedBox(width: 8),
                Text(
                  cost.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 4),
                // We would load token icon here, just using a colored circle for now
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getTokenColor(costToken),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getTokenColor(String token) {
    switch (token) {
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
