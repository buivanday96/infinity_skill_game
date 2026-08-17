import 'package:freezed_annotation/freezed_annotation.dart';
import 'skill_node.dart';
import 'upgrades.dart';

part 'skill_tree_state.freezed.dart';
part 'skill_tree_state.g.dart';

@freezed
abstract class SkillTreeState with _$SkillTreeState {
  const factory SkillTreeState({
    @Default({}) Map<Upgrade, SkillNode> nodes,
    Upgrade? selectedNodeId,
    @Default(100) int unspentPoints,
    @Default(100000) int totalPoints,
    @Default(100) int blueSquarePoints,
    @Default(100000) int totalBlueSquarePoints,
    @Default(0) int yellowStarPoints,
    @Default(19) int totalYellowStarPoints,
    @Default(0) int pinkHourglassPoints,
    @Default(36) int totalPinkHourglassPoints,
    @Default(0) int greenCrownPoints,
    @Default(36) int totalGreenCrownPoints,
  }) = _SkillTreeState;

  factory SkillTreeState.fromJson(Map<String, dynamic> json) => _$SkillTreeStateFromJson(json);
}
