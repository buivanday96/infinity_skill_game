import 'package:freezed_annotation/freezed_annotation.dart';

/// Coarse view of Godot `ActivationLevel` for UI/state consumers.
///
/// Paints are **not** derived from this enum. Godot colors nodes from
/// activation + cost token + affordability via `NodeColors`.
enum NodeState {
  @JsonValue('disabled')
  disabled,
  @JsonValue('enabled')
  enabled,
  @JsonValue('active')
  active,
  @JsonValue('upgraded')
  upgraded,
}
