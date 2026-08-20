import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/skill_tree_tokens.dart';
import '../l10n/bbcode.dart';
import '../models/skill_node.dart';
import '../models/upgrade_data.dart';
import '../models/upgrades.dart';
import '../notifiers/skill_tree_notifier.dart';
import 'core/app_color.dart';
import 'mobile_upgrade_button.dart';
import 'upgrade_tooltip_styles.dart';

class UpgradeTooltip extends ConsumerWidget {
  static const rankKey = Key('upgrade-tooltip-rank');
  static const costBarKey = Key('upgrade-tooltip-cost-bar');
  static const legendKey = Key('upgrade-tooltip-legend');
  static const mobileButtonsKey = Key('upgrade-tooltip-mobile-buttons');
  static const freeMilestoneKey = Key('upgrade-tooltip-free-milestone');

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
    final view = UpgradeTooltipViewData.from(
      upgrade: upgrade,
      data: data,
      currentLevel: node.currentLevel,
      isAffordable: canAffordUpgrade(
        ref.watch(skillTreeProvider),
        data,
        node.currentLevel,
      ),
    );
    final isMobile = _isMobile(context);

    Widget panel = Container(
      width: UpgradeTooltipStyles.width,
      decoration: BoxDecoration(
        color: UpgradeTooltipStyles.panelColor,
        borderRadius: BorderRadius.circular(UpgradeTooltipStyles.panelRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (view.showFreeMilestone) ...[
                  Text(
                    UpgradeTooltipStyles.freeMilestoneLabel,
                    key: UpgradeTooltip.freeMilestoneKey,
                    style: GoogleFonts.nunito(
                      color: UpgradeTooltipStyles.freeMilestoneColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                _Header(view: view),
                const SizedBox(height: 8),
                Text.rich(
                  Bbcode.parse(
                    view.description,
                    base: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ),
                if (isMobile) ...[
                  const SizedBox(height: 16),
                  _MobileButtons(
                    view: view,
                    onUpgrade: onUpgrade,
                    onRefund: onRefund,
                  ),
                  const SizedBox(height: 14),
                ] else if (view.showActionLegend) ...[
                  const SizedBox(height: 16),
                  _ActionLegend(view: view),
                  const SizedBox(height: 14),
                ] else
                  const SizedBox(height: 14),
              ],
            ),
          ),
          if (!isMobile) _CostBar(view: view),
        ],
      ),
    );

    if (!isMobile) {
      panel = GestureDetector(
        onTap: view.canUpgrade ? onUpgrade : null,
        onSecondaryTap: view.canRefund ? onRefund : null,
        child: panel,
      );
    }

    return panel;
  }
}

bool _isMobile(BuildContext context) {
  final platform = Theme.of(context).platform;
  return platform == TargetPlatform.iOS || platform == TargetPlatform.android;
}

class _Header extends StatelessWidget {
  const _Header({required this.view});

  final UpgradeTooltipViewData view;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            view.title,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ),
        if (view.showRank)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              view.rankText,
              key: UpgradeTooltip.rankKey,
              style: GoogleFonts.nunito(
                color: view.rankColor,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionLegend extends StatelessWidget {
  const _ActionLegend({required this.view});

  final UpgradeTooltipViewData view;

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.nunito(
      color: AppColor.subtleForeground,
      fontSize: 11,
      fontWeight: FontWeight.w700,
    );

    return Opacity(
      opacity: 0.67,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          key: UpgradeTooltip.legendKey,
          children: [
            Opacity(
              opacity: view.upgradeActionOpacity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    UpgradeTooltipStyles.leftClickAsset,
                    width: 14,
                    height: 14,
                    filterQuality: FilterQuality.medium,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    UpgradeTooltipStyles.upgradeActionLabel,
                    style: labelStyle,
                  ),
                ],
              ),
            ),
            if (view.showRefundHint) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('/', style: labelStyle),
              ),
              Opacity(
                opacity: view.refundActionOpacity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      UpgradeTooltipStyles.rightClickAsset,
                      width: 14,
                      height: 14,
                      filterQuality: FilterQuality.medium,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      UpgradeTooltipStyles.refundActionLabel,
                      style: labelStyle,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(width: 16),
            Text(UpgradeTooltipStyles.shiftLabel, style: labelStyle),
          ],
        ),
      ),
    );
  }
}

class _CostBar extends StatelessWidget {
  const _CostBar({required this.view});

  final UpgradeTooltipViewData view;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: UpgradeTooltip.costBarKey,
      height: UpgradeTooltipStyles.costBarHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: view.barStyle.background),
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: view.progress,
              heightFactor: 1,
              child: ColoredBox(color: view.barStyle.fill),
            ),
          ),
          Center(child: _CostBarOverlay(view: view)),
        ],
      ),
    );
  }
}

class _CostBarOverlay extends StatelessWidget {
  const _CostBarOverlay({required this.view});

  final UpgradeTooltipViewData view;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.nunito(
      color: view.costColor,
      fontSize: 16,
      fontWeight: FontWeight.w800,
    );

    switch (view.costContent) {
      case UpgradeTooltipCostContent.milestoneUnlock:
      case UpgradeTooltipCostContent.milestoneClaimed:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _MilestoneCostLine(view: view),
        );
      case UpgradeTooltipCostContent.maxed:
        return Text(view.costText, style: textStyle);
      case UpgradeTooltipCostContent.regular:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (view.showTokenIcon) ...[
              Image.asset(
                view.tokenIconAsset,
                width: 24,
                height: 24,
                filterQuality: FilterQuality.medium,
              ),
              const SizedBox(width: 6),
            ],
            Text(view.costText, style: textStyle),
          ],
        );
    }
  }
}

class _MilestoneCostLine extends StatelessWidget {
  const _MilestoneCostLine({required this.view});

  final UpgradeTooltipViewData view;

  @override
  Widget build(BuildContext context) {
    final subtle = GoogleFonts.nunito(
      color: AppColor.subtleForeground,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    );
    final valueStyle = GoogleFonts.nunito(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w800,
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (view.milestoneLeading.isNotEmpty) Text(view.milestoneLeading, style: subtle),
          if (view.showMilestoneCost) ...[
            Image.asset(
              view.tokenIconAsset,
              width: 16,
              height: 16,
              filterQuality: FilterQuality.medium,
            ),
            const SizedBox(width: 4),
            Text('${view.milestoneCost}', style: valueStyle),
          ],
          if (view.milestoneTrailing.isNotEmpty) Text(view.milestoneTrailing, style: subtle),
        ],
      ),
    );
  }
}

class _MobileButtons extends StatelessWidget {
  const _MobileButtons({
    required this.view,
    required this.onUpgrade,
    required this.onRefund,
  });

  final UpgradeTooltipViewData view;
  final VoidCallback onUpgrade;
  final VoidCallback onRefund;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: UpgradeTooltip.mobileButtonsKey,
      children: [
        if (view.showMobileRefund) ...[
          Expanded(
            child: MobileUpgradeButton(
              label: UpgradeTooltipStyles.refundActionLabel,
              cost: 0,
              costToken: view.costToken,
              showCost: false,
              backgroundColor: view.mobileRefundBackground,
              onPressed: view.canRefund ? onRefund : null,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: MobileUpgradeButton(
            label: view.mobileUpgradeLabel,
            cost: view.cost,
            costToken: view.costToken,
            isMaxed: view.isMaxed,
            isAffordable: view.isAffordable,
            showCost: view.showMobileCost,
            backgroundColor: view.mobileUpgradeBackground,
            onPressed: view.canUpgrade ? onUpgrade : null,
          ),
        ),
      ],
    );
  }
}
