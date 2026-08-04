import 'package:flutter/foundation.dart';

/// Mirrors [DungeonPhase] for the Flutter HUD without importing Flame.
enum CombatHudPhase {
  battling,
  choosing,
  defeat,
}

@immutable
class FloorChoiceHud {
  const FloorChoiceHud({
    required this.id,
    required this.title,
    required this.description,
    required this.rarity,
    required this.rarityLabel,
    required this.accentArgb,
    required this.fillArgb,
    this.iconAsset,
  });

  final String id;
  final String title;
  final String description;
  final String rarity;
  final String rarityLabel;
  final int accentArgb;
  final int fillArgb;
  final String? iconAsset;
}

@immutable
class CombatHudState {
  const CombatHudState({
    this.heroesAlive = 0,
    this.heroesTotal = 0,
    this.monstersAlive = 0,
    this.monstersTotal = 0,
    this.currentFloor = 1,
    this.phase = CombatHudPhase.battling,
    this.pendingChoices = const [],
    this.statusMessage = '',
  });

  final int heroesAlive;
  final int heroesTotal;
  final int monstersAlive;
  final int monstersTotal;
  final int currentFloor;
  final CombatHudPhase phase;
  final List<FloorChoiceHud> pendingChoices;
  final String statusMessage;

  bool get isChoosing => phase == CombatHudPhase.choosing;
  bool get isDefeat => phase == CombatHudPhase.defeat;
  bool get battleOver => phase != CombatHudPhase.battling;
  bool get heroWon => phase == CombatHudPhase.choosing;

  static const empty = CombatHudState();
}
