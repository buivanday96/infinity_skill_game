import 'package:infinity_skill_game/features/stats/domain/modifier_source.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_id.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_modifier.dart';

/// Layered view of one stat: base + flat + percent → final.
class StatChannel {
  const StatChannel({
    required this.stat,
    required this.base,
    this.flatBonus = 0,
    this.percentBonus = 0,
  });

  final StatId stat;
  final double base;
  final double flatBonus;
  final double percentBonus;

  /// `(base + flat) * (1 + percent)`.
  double get finalValue {
    final stacked = base + flatBonus;
    return stacked * (1 + percentBonus);
  }

  StatChannel copyWith({
    double? base,
    double? flatBonus,
    double? percentBonus,
  }) {
    return StatChannel(
      stat: stat,
      base: base ?? this.base,
      flatBonus: flatBonus ?? this.flatBonus,
      percentBonus: percentBonus ?? this.percentBonus,
    );
  }
}

/// Mutable container of all combat stats for one entity.
///
/// - [setBase] / growth on level-up changes the permanent base layer.
/// - Everything else goes through [addModifier] / [removeModifier].
/// - Battle systems must only read [finalOf] / [channelOf].
class CombatStats {
  CombatStats({Map<StatId, double>? bases})
      : _bases = {
          for (final id in StatId.values) id: bases?[id] ?? 0,
        };

  final Map<StatId, double> _bases;
  final List<StatModifier> _modifiers = [];

  List<StatModifier> get modifiers => List.unmodifiable(_modifiers);

  double baseOf(StatId id) => _bases[id] ?? 0;

  void setBase(StatId id, double value) {
    _bases[id] = value;
  }

  /// Adds [delta] to the base layer (used by level-up growth).
  void addBase(StatId id, double delta) {
    _bases[id] = baseOf(id) + delta;
  }

  void addModifier(StatModifier modifier) {
    _modifiers.removeWhere((m) => m.id == modifier.id);
    _modifiers.add(modifier);
  }

  void addModifiers(Iterable<StatModifier> mods) {
    for (final m in mods) {
      addModifier(m);
    }
  }

  bool removeModifier(String id) {
    final before = _modifiers.length;
    _modifiers.removeWhere((m) => m.id == id);
    return _modifiers.length < before;
  }

  int removeBySource(ModifierSource source) {
    final before = _modifiers.length;
    _modifiers.removeWhere((m) => m.source == source);
    return before - _modifiers.length;
  }

  int removeBySourceKey(String sourceKey) {
    final before = _modifiers.length;
    _modifiers.removeWhere((m) => m.sourceKey == sourceKey);
    return before - _modifiers.length;
  }

  void clearModifiers() => _modifiers.clear();

  StatChannel channelOf(StatId id) {
    var flat = 0.0;
    var percent = 0.0;
    for (final m in _modifiers) {
      if (m.stat != id) continue;
      flat += m.flat;
      percent += m.percent;
    }
    return StatChannel(
      stat: id,
      base: baseOf(id),
      flatBonus: flat,
      percentBonus: percent,
    );
  }

  double finalOf(StatId id) => channelOf(id).finalValue;

  /// Snapshot of every final value — useful for UI / debug overlays.
  Map<StatId, double> get allFinals => {
        for (final id in StatId.values) id: finalOf(id),
      };

  CombatStats copy() {
    final copy = CombatStats(bases: Map<StatId, double>.from(_bases));
    copy._modifiers.addAll(_modifiers);
    return copy;
  }
}
