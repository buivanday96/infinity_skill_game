import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinity_skill_game/models/skill_node.dart';
import 'package:infinity_skill_game/models/skill_tree_state.dart';
import 'package:infinity_skill_game/models/upgrade_data.dart';
import 'package:infinity_skill_game/models/upgrades.dart';
import 'package:infinity_skill_game/notifiers/skill_tree_notifier.dart';
import 'package:infinity_skill_game/ui/mobile_upgrade_button.dart';
import 'package:infinity_skill_game/ui/upgrade_tooltip.dart';
import 'package:infinity_skill_game/ui/upgrade_tooltip_styles.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  const regular = UpgradeData(maxLevel: 1, cost: 10, costToken: 'basic');
  const milestone = UpgradeData(
    maxLevel: 1,
    cost: 5,
    costToken: 'basic',
    isMilestone: true,
  );

  SkillNode node({int level = 0}) {
    return SkillNode(
      id: Upgrade.arrow_tower_unlock,
      position: Vector2.zero(),
      currentLevel: level,
    );
  }

  Future<void> pumpTooltip(
    WidgetTester tester, {
    required UpgradeData data,
    SkillNode? skillNode,
    SkillTreeState state = const SkillTreeState(unspentPoints: 100),
    TargetPlatform platform = TargetPlatform.macOS,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [skillTreeProvider.overrideWithValue(state)],
        child: MaterialApp(
          theme: ThemeData(platform: platform),
          home: Scaffold(
            body: UpgradeTooltip(
              upgrade: Upgrade.arrow_tower_unlock,
              node: skillNode ?? node(),
              data: data,
              onUpgrade: () {},
              onRefund: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows rank 0 / 1, cost 10, and the desktop click legend', (
    tester,
  ) async {
    await pumpTooltip(tester, data: regular);

    expect(find.text('Arrow Tower Unlock'), findsOneWidget);
    expect(find.byKey(UpgradeTooltip.rankKey), findsOneWidget);
    expect(find.text('0 / 1'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.textContaining('Unlocks the'), findsOneWidget);
    expect(find.textContaining('Arrow Tower'), findsWidgets);
    expect(find.byKey(UpgradeTooltip.legendKey), findsOneWidget);
    expect(find.text('Upgrade'), findsOneWidget);
    expect(find.text('Refund'), findsOneWidget);
    expect(find.text('[Shift]'), findsOneWidget);
    expect(find.byKey(UpgradeTooltip.costBarKey), findsOneWidget);
    expect(find.byKey(UpgradeTooltip.mobileButtonsKey), findsNothing);
  });

  testWidgets('hides rank for a milestone and shows unlock copy', (
    tester,
  ) async {
    await pumpTooltip(tester, data: milestone);

    expect(find.byKey(UpgradeTooltip.rankKey), findsNothing);
    expect(find.text('0 / 1'), findsNothing);
    expect(find.byKey(UpgradeTooltip.freeMilestoneKey), findsOneWidget);
    expect(find.text('Free Milestone'), findsOneWidget);
    expect(find.text('Available at '), findsOneWidget);
    expect(find.text(' total collected'), findsOneWidget);
  });

  testWidgets('maxed regular node shows Max and keeps the legend', (
    tester,
  ) async {
    await pumpTooltip(tester, data: regular, skillNode: node(level: 1));

    expect(find.text('Max'), findsOneWidget);
    expect(find.byKey(UpgradeTooltip.legendKey), findsOneWidget);
    expect(find.text('1 / 1'), findsOneWidget);
  });

  testWidgets('maxed milestone hides the click legend', (tester) async {
    await pumpTooltip(tester, data: milestone, skillNode: node(level: 1));

    expect(find.byKey(UpgradeTooltip.legendKey), findsNothing);
    expect(find.byKey(UpgradeTooltip.freeMilestoneKey), findsNothing);
    expect(find.text(' total milestone claimed'), findsOneWidget);
  });

  testWidgets('unaffordable cost bar uses the fail background', (tester) async {
    await pumpTooltip(
      tester,
      data: regular,
      state: const SkillTreeState(unspentPoints: 0),
    );

    final expected = UpgradeTooltipStyles.setup(
      costToken: 'basic',
      state: UpgradeTooltipBarState.unavailable,
    );
    final boxes = tester.widgetList<ColoredBox>(
      find.descendant(
        of: find.byKey(UpgradeTooltip.costBarKey),
        matching: find.byType(ColoredBox),
      ),
    );
    expect(boxes.first.color, expected.background);
  });

  testWidgets('shows mobile buttons and hides the desktop legend on iOS', (
    tester,
  ) async {
    await pumpTooltip(
      tester,
      data: regular,
      platform: TargetPlatform.iOS,
    );

    expect(find.byKey(UpgradeTooltip.legendKey), findsNothing);
    expect(find.byKey(UpgradeTooltip.costBarKey), findsNothing);
    expect(find.byKey(UpgradeTooltip.mobileButtonsKey), findsOneWidget);
    expect(find.byType(MobileUpgradeButton), findsNWidgets(2));
    expect(find.text('Upgrade'), findsOneWidget);
    expect(find.text('Refund'), findsOneWidget);
  });
}
