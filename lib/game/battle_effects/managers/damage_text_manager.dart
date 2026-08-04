import 'package:flame/components.dart';
import 'package:infinity_skill_game/game/battle_effects/components/damage_text_component.dart';
import 'package:infinity_skill_game/game/battle_effects/enums/damage_type.dart';
import 'package:infinity_skill_game/game/battle_effects/models/damage_text_data.dart';
import 'package:infinity_skill_game/game/battle_effects/pool/damage_text_pool.dart';

/// Spawns and recycles floating damage text. No render/animation of its own.
class DamageTextManager extends Component {
  DamageTextManager({this.staggerStep = 0.015, this.prewarmCount = 24});

  /// Extra delay between same-frame spawns (seconds).
  final double staggerStep;

  final int prewarmCount;

  late final DamageTextPool _pool;

  /// Pending [DamageTextData] waiting for delay (manager-owned stagger).
  final List<_QueuedText> _queue = [];

  int _sameFrameCount = 0;
  bool _countedThisFrame = false;

  @override
  Future<void> onLoad() async {
    _pool = DamageTextPool(
      create: () {
        final c = DamageTextComponent(onFinished: _onComponentFinished);
        // Parent immediately so pool never removeFromParent.
        add(c);
        return c;
      },
    );
    for (final c in _pool.prewarm(prewarmCount)) {
      if (c.parent == null) add(c);
    }
  }

  void showDamage(DamageTextData data) {
    final stamped = _withStagger(data);
    if (stamped.delay > 0) {
      _queue.add(_QueuedText(data: stamped, remaining: stamped.delay));
      return;
    }
    _spawn(stamped);
  }

  void showCritical(DamageTextData data) =>
      showDamage(_copyWithType(data, DamageType.critical));

  void showHeal(DamageTextData data) =>
      showDamage(_copyWithType(data, DamageType.heal));

  void showGold(DamageTextData data) =>
      showDamage(_copyWithType(data, DamageType.gold));

  void showExp(DamageTextData data) =>
      showDamage(_copyWithType(data, DamageType.exp));

  void showMiss(DamageTextData data) =>
      showDamage(_copyWithType(data, DamageType.miss));

  void showShield(DamageTextData data) =>
      showDamage(_copyWithType(data, DamageType.shield));

  void clear() {
    _queue.clear();
    _pool.releaseAll();
  }

  void dispose() => clear();

  @override
  void update(double dt) {
    super.update(dt);
    _sameFrameCount = 0;
    _countedThisFrame = false;

    if (_queue.isEmpty) return;

    for (final item in _queue) {
      item.remaining -= dt;
    }
    final ready = _queue.where((q) => q.remaining <= 0).toList();
    _queue.removeWhere((q) => q.remaining <= 0);
    for (final item in ready) {
      _spawn(item.data.copyWithDelay(0));
    }
  }

  DamageTextData _withStagger(DamageTextData data) {
    if (data.delay > 0) return data;
    if (!_countedThisFrame) {
      _countedThisFrame = true;
    }
    final extra = _sameFrameCount * staggerStep;
    _sameFrameCount++;
    if (extra <= 0) return data;
    return data.copyWithDelay(extra);
  }

  void _spawn(DamageTextData data) {
    final component = _pool.obtain();
    if (component.parent == null) {
      add(component);
    }
    component.onFinished = _onComponentFinished;
    component.show(data);
  }

  void _onComponentFinished(DamageTextComponent component) {
    _pool.release(component);
  }

  DamageTextData _copyWithType(DamageTextData data, DamageType type) {
    return DamageTextData(
      text: data.text,
      type: type,
      worldPosition: data.worldPosition,
      delay: data.delay,
      randomOffset: data.randomOffset,
    );
  }
}

class _QueuedText {
  _QueuedText({required this.data, required this.remaining});

  final DamageTextData data;
  double remaining;
}

extension on DamageTextData {
  DamageTextData copyWithDelay(double delay) => DamageTextData(
        text: text,
        type: type,
        worldPosition: worldPosition,
        delay: delay,
        randomOffset: randomOffset,
      );
}
