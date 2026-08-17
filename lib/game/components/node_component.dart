import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../../models/skill_node.dart';
import '../../models/upgrade_data.dart';
import '../../models/upgrades.dart';
import '../../ui/core/app_color.dart';
import '../node_colors.dart';
import '../skill_tree_tokens.dart';
import 'circle_highlight_component.dart';
import 'diamond_highlight_component.dart';
import 'milestone_highlight.dart';

class NodeComponent extends PositionComponent with TapCallbacks {
  static const _questionMarkPath = 'sprites/question_mark_icon.png';

  SkillNode node;
  bool canAfford;
  final void Function(Upgrade) onNodeTapped;
  Sprite? _iconSprite;
  MilestoneHighlight? _highlight;
  bool _wasMystery = false;

  NodeComponent({
    required this.node,
    required this.onNodeTapped,
    this.canAfford = false,
  }) : super(
         position: node.position,
         size: Vector2(128, 128),
         anchor: Anchor.center,
       );

  bool get _isMystery => node.activationLevel == ActivationLevel.discovered;

  @override
  Future<void> onLoad() async {
    _wasMystery = _isMystery;
    await _loadIcon();
    await _ensureHighlight();
    _syncHighlight();
  }

  Future<void> updateFrom(SkillNode next, {required bool canAfford}) {
    node = next;
    this.canAfford = canAfford;
    position = next.position;
    final mysteryChanged = _wasMystery != _isMystery;
    _wasMystery = _isMystery;
    _syncHighlight();
    if (mysteryChanged) {
      return _loadIcon();
    }
    return Future.value();
  }

  Future<void> _loadIcon() async {
    final iconPath = _isMystery
        ? _questionMarkPath
        : upgradesMap[node.id]?.iconPath?.replaceFirst('assets/', '');
    if (iconPath == null) {
      _iconSprite = null;
      return;
    }

    try {
      // Flame.images.prefix is 'assets/' (set in main.dart).
      _iconSprite = await Sprite.load(iconPath);
    } catch (e) {
      debugPrint('Failed to load sprite: $iconPath ($e)');
    }
  }

  Future<void> _ensureHighlight() async {
    final data = upgradesMap[node.id];
    if (data == null || !data.isMilestone || _highlight != null) return;

    final color = tokenHighlightColor(data.costToken);
    final PositionComponent highlight = data.isArtifact
        ? DiamondHighlightComponent(color: color)
        : CircleHighlightComponent(color: color);
    _highlight = highlight as MilestoneHighlight;
    await add(highlight);
  }

  void _syncHighlight() {
    final data = upgradesMap[node.id];
    final highlight = _highlight;
    if (data == null || highlight == null) return;

    highlight.syncVisibility(
      shouldShow: shouldShowMilestoneHighlight(
        data: data,
        activationLevel: node.activationLevel,
        canAfford: canAfford,
      ),
      color: tokenHighlightColor(data.costToken),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = (size / 2).toOffset();

    final tileRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: size.x * 0.8,
        height: size.y * 0.8,
      ),
      const Radius.circular(16),
    );

    final shadowPaint = Paint()..color = AppColor.shadow;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center + const Offset(4, 4),
          width: size.x * 0.8,
          height: size.y * 0.8,
        ),
        const Radius.circular(16),
      ),
      shadowPaint,
    );

    final basePaint = Paint()..color = _tileTopColor();
    canvas.drawRRect(tileRect, basePaint);

    final outlineColor = _outlineColor();
    if (outlineColor.a > 0) {
      final outlinePaint = Paint()
        ..color = outlineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;
      canvas.drawRRect(tileRect, outlinePaint);
    }

    if (_iconSprite != null) {
      final iconPaint = Paint()
        ..colorFilter = ColorFilter.mode(_iconColor(), BlendMode.modulate);
      _iconSprite!.render(
        canvas,
        position: size / 2,
        size: Vector2(64, 64),
        anchor: Anchor.center,
        overridePaint: iconPaint,
      );
    }
  }

  UpgradeData? get _data => upgradesMap[node.id];

  Color _tileTopColor() {
    final data = _data;
    return NodeColors.tileTopColor(
      activationLevel: node.activationLevel,
      costToken: data?.costToken ?? 'basic',
      canAfford: canAfford,
      isArtifact: data?.isArtifact ?? false,
      enchant: data?.data?['enchant'] as String?,
    );
  }

  Color _outlineColor() {
    return NodeColors.outlineColor(
      activationLevel: node.activationLevel,
      costToken: _data?.costToken ?? 'basic',
      canAfford: canAfford,
    );
  }

  Color _iconColor() {
    return NodeColors.iconColor(activationLevel: node.activationLevel);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onNodeTapped(node.id);
  }
}
