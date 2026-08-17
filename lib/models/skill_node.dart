import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flame/components.dart';
import 'node_state.dart';
import 'upgrades.dart';

part 'skill_node.freezed.dart';
part 'skill_node.g.dart';

@freezed
abstract class SkillNode with _$SkillNode {
  const SkillNode._();

  const factory SkillNode({
    required Upgrade id,
    @JsonKey(fromJson: _vector2FromJson, toJson: _vector2ToJson)
    required Vector2 position,
    @Default(NodeState.disabled) NodeState state,
    @Default(ActivationLevel.hidden) ActivationLevel activationLevel,
    @Default([]) List<Upgrade> connectedNodeIds,
    @Default(0) int currentLevel,
  }) = _SkillNode;

  factory SkillNode.fromJson(Map<String, dynamic> json) =>
      _$SkillNodeFromJson(json);

  bool get isVisible =>
      activationLevel.index >= ActivationLevel.discovered.index;
}

Vector2 _vector2FromJson(Map<String, dynamic> json) {
  return Vector2(json['x'] as double, json['y'] as double);
}

Map<String, dynamic> _vector2ToJson(Vector2 vector) {
  return {'x': vector.x, 'y': vector.y};
}
