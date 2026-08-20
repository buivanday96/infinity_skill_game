/// Coarse view of Godot `ActivationLevel` for UI/state consumers.
///
/// Paints are **not** derived from this enum. Godot colors nodes from
/// activation + cost token + affordability via `NodeColors`.
enum NodeState {
  disabled,
  enabled,
  active,
  upgraded,
}
