import 'package:infinity_skill_game/game/battle_effects/components/damage_text_component.dart';

/// Reuses [DamageTextComponent] instances — never removeFromParent.
class DamageTextPool {
  DamageTextPool({required this.create});

  final DamageTextComponent Function() create;

  final List<DamageTextComponent> _available = [];
  final Set<DamageTextComponent> _using = {};

  int get availableCount => _available.length;
  int get usingCount => _using.length;
  int get totalCount => _available.length + _using.length;

  /// Returns an idle component, or creates one when the pool is empty.
  DamageTextComponent obtain() {
    final component = _available.isNotEmpty ? _available.removeLast() : create();
    _using.add(component);
    return component;
  }

  /// Resets and parks [component] for reuse. Does not remove from the tree.
  void release(DamageTextComponent component) {
    if (!_using.remove(component)) return;
    component.reset();
    component.hide();
    if (!_available.contains(component)) {
      _available.add(component);
    }
  }

  /// Creates [count] idle components via [create] and parks them.
  List<DamageTextComponent> prewarm(int count) {
    final created = <DamageTextComponent>[];
    for (var i = 0; i < count; i++) {
      final c = create();
      c.hide();
      _available.add(c);
      created.add(c);
    }
    return created;
  }

  /// Releases every in-use component back to available.
  void releaseAll() {
    for (final c in List<DamageTextComponent>.from(_using)) {
      release(c);
    }
  }
}
