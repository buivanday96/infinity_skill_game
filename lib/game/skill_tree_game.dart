import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/skill_tree_state.dart';
import '../models/upgrades.dart';
import '../notifiers/skill_tree_notifier.dart';
import 'components/line_component.dart';
import 'components/node_component.dart';
import 'skill_tree_tokens.dart';

class SkillTreeGame extends FlameGame
    with ScaleDetector, ScrollDetector, TapCallbacks {
  static const double defaultZoom = 0.35;
  static const double maxZoom = 2.5;
  static const double _absoluteMinZoom = 0.05;
  static const double _zoomFactor = 1.25;
  static const double _nodeRadius = 64;
  static const double _fitPadding = 240;

  final WidgetRef ref;
  @override
  final world = World();
  late final CameraComponent cam = CameraComponent(world: world);

  /// Current zoom, for Flutter overlay controls.
  final ValueNotifier<double> zoomListenable = ValueNotifier(defaultZoom);

  /// Notifies when the camera position or zoom changes.
  final ValueNotifier<int> cameraUpdateNotifier = ValueNotifier(0);
  final Vector2 _lastCamPosition = Vector2.zero();
  double _lastCamZoom = 0;

  double _minZoom = 0.08;
  double _pinchStartZoom = defaultZoom;
  Rect? _treeBounds;

  final Map<Upgrade, NodeComponent> _nodeComponents = {};

  SkillTreeGame(this.ref);

  double get minZoom => _minZoom;

  @override
  Color backgroundColor() => const Color(0xFF1A1A24);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    cam.viewfinder.zoom = defaultZoom;
    addAll([world, cam]);

    final notifier = ref.read(skillTreeProvider.notifier);
    if (ref.read(skillTreeProvider).nodes.isEmpty) {
      notifier.generateInitialTree();
    } else {
      updateSkillTree(ref.read(skillTreeProvider));
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!isLoaded) return;
    _recalculateMinZoom();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (cam.viewfinder.position != _lastCamPosition || cam.viewfinder.zoom != _lastCamZoom) {
      _lastCamPosition.setFrom(cam.viewfinder.position);
      _lastCamZoom = cam.viewfinder.zoom;
      cameraUpdateNotifier.value++;
    }
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    _pinchStartZoom = cam.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (info.pointerCount >= 2) {
      setZoom(
        _pinchStartZoom * info.scale.global.x,
        focus: info.eventPosition.widget,
      );
      return;
    }

    cam.viewfinder.position -= info.delta.global / cam.viewfinder.zoom;
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Empty-canvas taps reach the game; node taps are consumed by NodeComponent.
    if (ref.read(skillTreeProvider).selectedNodeId != null) {
      ref.read(skillTreeProvider.notifier).selectNode(null);
    }
  }

  @override
  void onScroll(PointerScrollInfo info) {
    final factor = info.scrollDelta.global.y > 0 ? 1 / _zoomFactor : _zoomFactor;
    setZoom(cam.viewfinder.zoom * factor, focus: info.eventPosition.widget);
  }

  void zoomIn() => setZoom(cam.viewfinder.zoom * _zoomFactor);

  void zoomOut() => setZoom(cam.viewfinder.zoom / _zoomFactor);

  void setZoom(double nextZoom, {Vector2? focus}) {
    final clamped = nextZoom.clamp(_minZoom, maxZoom);
    final previous = cam.viewfinder.zoom;
    if ((clamped - previous).abs() < 0.0001) {
      zoomListenable.value = clamped;
      return;
    }

    final focusCanvas = focus ?? size / 2;
    final worldBefore = cam.globalToLocal(focusCanvas);
    cam.viewfinder.zoom = clamped;
    final worldAfter = cam.globalToLocal(focusCanvas);
    cam.viewfinder.position += worldBefore - worldAfter;
    zoomListenable.value = clamped;
  }

  void fitToTree() {
    final bounds = _treeBounds;
    if (bounds == null) return;

    cam.viewfinder.position = Vector2(bounds.center.dx, bounds.center.dy);
    _recalculateMinZoom();
    setZoom(_minZoom);
  }

  void updateSkillTree(SkillTreeState state) {
    world.children.whereType<LineComponent>().toList().forEach((c) => c.removeFromParent());

    _treeBounds = _computeTreeBounds(state);

    for (final node in state.nodes.values) {
      if (!node.isVisible) continue;
      for (final connectedId in node.connectedNodeIds) {
        final connectedNode = state.nodes[connectedId];
        if (connectedNode != null && connectedNode.isVisible) {
          world.add(
            LineComponent(
              startNode: node,
              endNode: connectedNode,
            ),
          );
        }
      }
    }

    final visibleIds = <Upgrade>{};
    for (final node in state.nodes.values) {
      if (!node.isVisible) continue;
      visibleIds.add(node.id);
      final data = upgradesMap[node.id];
      final affordable =
          data != null && canAffordUpgrade(state, data, node.currentLevel);
      final existing = _nodeComponents[node.id];
      if (existing != null) {
        existing.updateFrom(node, canAfford: affordable);
      } else {
        final component = NodeComponent(
          node: node,
          canAfford: affordable,
          onNodeTapped: (id) {
            ref.read(skillTreeProvider.notifier).selectNode(id);
          },
        );
        _nodeComponents[node.id] = component;
        world.add(component);
      }
    }

    for (final id in _nodeComponents.keys.toList()) {
      if (visibleIds.contains(id)) continue;
      _nodeComponents.remove(id)?.removeFromParent();
    }

    _recalculateMinZoom();
  }

  Rect? _computeTreeBounds(SkillTreeState state) {
    if (state.nodes.isEmpty) return null;

    var minX = double.infinity;
    var maxX = double.negativeInfinity;
    var minY = double.infinity;
    var maxY = double.negativeInfinity;

    var hasVisible = false;
    for (final node in state.nodes.values) {
      if (!node.isVisible) continue;
      hasVisible = true;
      minX = math.min(minX, node.position.x);
      maxX = math.max(maxX, node.position.x);
      minY = math.min(minY, node.position.y);
      maxY = math.max(maxY, node.position.y);
    }

    if (!hasVisible) return null;

    return Rect.fromLTRB(
      minX - _nodeRadius,
      minY - _nodeRadius,
      maxX + _nodeRadius,
      maxY + _nodeRadius,
    );
  }

  void _recalculateMinZoom() {
    final bounds = _treeBounds;
    if (bounds == null || size.x <= 0 || size.y <= 0) return;

    final paddedWidth = bounds.width + _fitPadding;
    final paddedHeight = bounds.height + _fitPadding;
    final fitZoom = math.min(size.x / paddedWidth, size.y / paddedHeight);
    _minZoom = fitZoom.clamp(_absoluteMinZoom, defaultZoom);

    if (cam.viewfinder.zoom < _minZoom) {
      setZoom(_minZoom);
    }
  }
}
