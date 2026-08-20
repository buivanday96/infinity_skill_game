import 'package:flutter/foundation.dart';

import 'skill_node.dart';
import 'upgrades.dart';

const Object _unset = Object();

class SkillTreeState {
  const SkillTreeState({
    this.nodes = const {},
    this.selectedNodeId,
    this.unspentPoints = 100,
    this.totalPoints = 100000,
    this.blueSquarePoints = 100,
    this.totalBlueSquarePoints = 100000,
    this.yellowStarPoints = 0,
    this.totalYellowStarPoints = 19,
    this.pinkHourglassPoints = 0,
    this.totalPinkHourglassPoints = 36,
    this.greenCrownPoints = 0,
    this.totalGreenCrownPoints = 36,
  });

  factory SkillTreeState.fromJson(Map<String, dynamic> json) {
    return SkillTreeState(
      nodes:
          (json['nodes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              Upgrade.values.byName(k),
              SkillNode.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const {},
      selectedNodeId: json['selectedNodeId'] == null
          ? null
          : Upgrade.values.byName(json['selectedNodeId'] as String),
      unspentPoints: (json['unspentPoints'] as num?)?.toInt() ?? 100,
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 100000,
      blueSquarePoints: (json['blueSquarePoints'] as num?)?.toInt() ?? 100,
      totalBlueSquarePoints:
          (json['totalBlueSquarePoints'] as num?)?.toInt() ?? 100000,
      yellowStarPoints: (json['yellowStarPoints'] as num?)?.toInt() ?? 0,
      totalYellowStarPoints:
          (json['totalYellowStarPoints'] as num?)?.toInt() ?? 19,
      pinkHourglassPoints: (json['pinkHourglassPoints'] as num?)?.toInt() ?? 0,
      totalPinkHourglassPoints:
          (json['totalPinkHourglassPoints'] as num?)?.toInt() ?? 36,
      greenCrownPoints: (json['greenCrownPoints'] as num?)?.toInt() ?? 0,
      totalGreenCrownPoints:
          (json['totalGreenCrownPoints'] as num?)?.toInt() ?? 36,
    );
  }

  final Map<Upgrade, SkillNode> nodes;
  final Upgrade? selectedNodeId;
  final int unspentPoints;
  final int totalPoints;
  final int blueSquarePoints;
  final int totalBlueSquarePoints;
  final int yellowStarPoints;
  final int totalYellowStarPoints;
  final int pinkHourglassPoints;
  final int totalPinkHourglassPoints;
  final int greenCrownPoints;
  final int totalGreenCrownPoints;

  SkillTreeState copyWith({
    Map<Upgrade, SkillNode>? nodes,
    Object? selectedNodeId = _unset,
    int? unspentPoints,
    int? totalPoints,
    int? blueSquarePoints,
    int? totalBlueSquarePoints,
    int? yellowStarPoints,
    int? totalYellowStarPoints,
    int? pinkHourglassPoints,
    int? totalPinkHourglassPoints,
    int? greenCrownPoints,
    int? totalGreenCrownPoints,
  }) {
    return SkillTreeState(
      nodes: nodes ?? this.nodes,
      selectedNodeId: identical(selectedNodeId, _unset)
          ? this.selectedNodeId
          : selectedNodeId as Upgrade?,
      unspentPoints: unspentPoints ?? this.unspentPoints,
      totalPoints: totalPoints ?? this.totalPoints,
      blueSquarePoints: blueSquarePoints ?? this.blueSquarePoints,
      totalBlueSquarePoints:
          totalBlueSquarePoints ?? this.totalBlueSquarePoints,
      yellowStarPoints: yellowStarPoints ?? this.yellowStarPoints,
      totalYellowStarPoints:
          totalYellowStarPoints ?? this.totalYellowStarPoints,
      pinkHourglassPoints: pinkHourglassPoints ?? this.pinkHourglassPoints,
      totalPinkHourglassPoints:
          totalPinkHourglassPoints ?? this.totalPinkHourglassPoints,
      greenCrownPoints: greenCrownPoints ?? this.greenCrownPoints,
      totalGreenCrownPoints:
          totalGreenCrownPoints ?? this.totalGreenCrownPoints,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((k, e) => MapEntry(k.name, e.toJson())),
      'selectedNodeId': selectedNodeId?.name,
      'unspentPoints': unspentPoints,
      'totalPoints': totalPoints,
      'blueSquarePoints': blueSquarePoints,
      'totalBlueSquarePoints': totalBlueSquarePoints,
      'yellowStarPoints': yellowStarPoints,
      'totalYellowStarPoints': totalYellowStarPoints,
      'pinkHourglassPoints': pinkHourglassPoints,
      'totalPinkHourglassPoints': totalPinkHourglassPoints,
      'greenCrownPoints': greenCrownPoints,
      'totalGreenCrownPoints': totalGreenCrownPoints,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is SkillTreeState &&
        mapEquals(other.nodes, nodes) &&
        other.selectedNodeId == selectedNodeId &&
        other.unspentPoints == unspentPoints &&
        other.totalPoints == totalPoints &&
        other.blueSquarePoints == blueSquarePoints &&
        other.totalBlueSquarePoints == totalBlueSquarePoints &&
        other.yellowStarPoints == yellowStarPoints &&
        other.totalYellowStarPoints == totalYellowStarPoints &&
        other.pinkHourglassPoints == pinkHourglassPoints &&
        other.totalPinkHourglassPoints == totalPinkHourglassPoints &&
        other.greenCrownPoints == greenCrownPoints &&
        other.totalGreenCrownPoints == totalGreenCrownPoints;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(
      nodes.entries.map((e) => Object.hash(e.key, e.value)),
    ),
    selectedNodeId,
    unspentPoints,
    totalPoints,
    blueSquarePoints,
    totalBlueSquarePoints,
    yellowStarPoints,
    totalYellowStarPoints,
    pinkHourglassPoints,
    totalPinkHourglassPoints,
    greenCrownPoints,
    totalGreenCrownPoints,
  );
}
