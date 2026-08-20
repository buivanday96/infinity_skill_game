import 'en.g.dart';

/// Godot-style `tr(key)` lookup over the imported English string table.
abstract final class GameStrings {
  static String tr(String key) => kEnStrings[key] ?? key;

  static bool has(String key) => kEnStrings.containsKey(key);

  /// Godot `String.format({key: value})` — replaces `{key}` placeholders.
  static String format(String template, Map<String, String> values) {
    return template.replaceAllMapped(RegExp(r'\{([A-Za-z0-9_]+)\}'), (match) {
      final name = match.group(1)!;
      return values[name] ?? match.group(0)!;
    });
  }
}
