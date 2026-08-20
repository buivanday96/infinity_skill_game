import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import 'node_state.dart';
import 'upgrades.dart';

class SkillNode {
  const SkillNode({
    required this.id,
    required this.position,
    this.state = NodeState.disabled,
    this.activationLevel = ActivationLevel.hidden,
    this.connectedNodeIds = const [],
    this.currentLevel = 0,
  });

  factory SkillNode.fromJson(Map<String, dynamic> json) {
    return SkillNode(
      id: Upgrade.values.byName(json['id'] as String),
      position: _vector2FromJson(json['position'] as Map<String, dynamic>),
      state: json['state'] == null
          ? NodeState.disabled
          : NodeState.values.byName(json['state'] as String),
      activationLevel: json['activationLevel'] == null
          ? ActivationLevel.hidden
          : ActivationLevel.values.byName(json['activationLevel'] as String),
      connectedNodeIds:
          (json['connectedNodeIds'] as List<dynamic>?)
              ?.map((e) => Upgrade.values.byName(e as String))
              .toList() ??
          const [],
      currentLevel: (json['currentLevel'] as num?)?.toInt() ?? 0,
    );
  }

  final Upgrade id;
  final Vector2 position;
  final NodeState state;
  final ActivationLevel activationLevel;
  final List<Upgrade> connectedNodeIds;
  final int currentLevel;

  bool get isVisible =>
      activationLevel.index >= ActivationLevel.discovered.index;

  SkillNode copyWith({
    Upgrade? id,
    Vector2? position,
    NodeState? state,
    ActivationLevel? activationLevel,
    List<Upgrade>? connectedNodeIds,
    int? currentLevel,
  }) {
    return SkillNode(
      id: id ?? this.id,
      position: position ?? this.position,
      state: state ?? this.state,
      activationLevel: activationLevel ?? this.activationLevel,
      connectedNodeIds: connectedNodeIds ?? this.connectedNodeIds,
      currentLevel: currentLevel ?? this.currentLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.name,
      'position': _vector2ToJson(position),
      'state': state.name,
      'activationLevel': activationLevel.name,
      'connectedNodeIds': connectedNodeIds.map((e) => e.name).toList(),
      'currentLevel': currentLevel,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is SkillNode &&
        other.id == id &&
        other.position == position &&
        other.state == state &&
        other.activationLevel == activationLevel &&
        listEquals(other.connectedNodeIds, connectedNodeIds) &&
        other.currentLevel == currentLevel;
  }

  @override
  int get hashCode => Object.hash(
    id,
    position,
    state,
    activationLevel,
    Object.hashAll(connectedNodeIds),
    currentLevel,
  );

  @override
  String toString() {
    return 'SkillNode(id: $id, position: $position, state: $state, '
        'activationLevel: $activationLevel, connectedNodeIds: $connectedNodeIds, '
        'currentLevel: $currentLevel)';
  }
}

Vector2 _vector2FromJson(Map<String, dynamic> json) {
  return Vector2(
    (json['x'] as num).toDouble(),
    (json['y'] as num).toDouble(),
  );
}

Map<String, dynamic> _vector2ToJson(Vector2 vector) {
  return {'x': vector.x, 'y': vector.y};
}
