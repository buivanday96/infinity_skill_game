import 'package:flutter/material.dart';

import '../ui/core/app_color.dart';

/// Parses Outhold tooltip BBCode into a [TextSpan].
///
/// Icon tags are stripped. `[arrow_icon]` becomes ` → `.
abstract final class Bbcode {
  static const _tagPattern = r'\[(/?)([A-Za-z0-9_]+)\]';

  static const _iconTags = {
    'coin_icon',
    'coin_icon_small',
    'arrow_icon',
    'small_arrow_icon',
    'basic_token_icon',
    'advanced_token_icon',
    'time_token_icon',
    'star_token_icon',
    'challenge_token_icon',
    'grunt_icon',
    'explosive_grunt_icon',
    'runner_icon',
    'explosive_runner_icon',
    'leaper_icon',
    'core_icon',
    'core_icon_small',
    'artifact_icon',
    'upgrade_icon',
    'left_click_icon',
    'right_click_icon',
    'import_icon',
    'export_icon',
    'not_in_demo',
  };

  static final _tagColors = <String, Color>{
    'highlight': AppColor.highlightedForeground,
    'value_before': AppColor.highlightedForeground,
    'value_after': AppColor.highlightedForeground2,
    'kw_vulnerable': AppColor.keywordVulnerable,
    'kw_overkill': AppColor.keywordOverkill,
    'kw_burn': AppColor.keywordBurn,
    'kw_slow': AppColor.keywordSlow,
    'kw_charge': AppColor.keywordCharge,
    'kw_stun': AppColor.keywordStun,
    'kw_shock': AppColor.keywordShock,
    'kw_pool': AppColor.keywordPool,
    'kw_explosion': AppColor.keywordExplosive,
    'kw_combustion': AppColor.keywordCombustion,
    'kw_poison': AppColor.keywordPoison,
    'kw_light_enchant': AppColor.lightEnchant,
    'kw_earth_enchant': AppColor.earthEnchant,
    'kw_fire_enchant': AppColor.fireEnchant,
    'kw_wind_enchant': AppColor.windEnchant,
    'kw_ice_enchant': AppColor.iceEnchant,
    'kw_accelerated': AppColor.keywordAccelerated,
    'kw_frostfire': AppColor.keywordFrostfire,
    'kw_shielded': AppColor.keywordShielded,
  };

  static TextSpan parse(String text, {TextStyle? base}) {
    final children = <InlineSpan>[];
    final active = <String>[];
    final regex = RegExp(_tagPattern);
    var cursor = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > cursor) {
        children.add(
          _textSpan(text.substring(cursor, match.start), active, base),
        );
      }

      final closing = match.group(1) == '/';
      final tag = match.group(2)!;
      if (_iconTags.contains(tag)) {
        if (!closing) {
          if (tag == 'arrow_icon' || tag == 'small_arrow_icon') {
            children.add(_textSpan(' → ', active, base));
          } else {
            final widgetSpan = _iconSpan(tag, base);
            if (widgetSpan != null) {
              children.add(widgetSpan);
            }
          }
        }
      } else if (closing) {
        active.remove(tag);
      } else {
        active.add(tag);
      }
      cursor = match.end;
    }

    if (cursor < text.length) {
      children.add(_textSpan(text.substring(cursor), active, base));
    }

    return TextSpan(style: base, children: children);
  }

  static WidgetSpan? _iconSpan(String tag, TextStyle? base) {
    String? assetPath;
    Color? color;
    double size = (base?.fontSize ?? 15.0) * 1.2;

    switch (tag) {
      case 'coin_icon':
      case 'coin_icon_small':
        assetPath = 'assets/ui/gem.png';
        break;
      case 'basic_token_icon':
        assetPath = 'assets/ui/basic_token.png';
        break;
      case 'advanced_token_icon':
        assetPath = 'assets/ui/advanced_token.png';
        break;
      case 'time_token_icon':
        assetPath = 'assets/ui/time_token.png';
        break;
      case 'star_token_icon':
        assetPath = 'assets/ui/star_token.png';
        break;
      case 'challenge_token_icon':
        assetPath = 'assets/ui/challenge_token.png';
        break;
      case 'grunt_icon':
        assetPath = 'assets/sprites/grunt.png';
        color = AppColor.failForeground;
        break;
      case 'explosive_grunt_icon':
        assetPath = 'assets/sprites/grunt.png';
        color = AppColor.explosiveStatus;
        break;
      case 'runner_icon':
        assetPath = 'assets/sprites/runner_right.png';
        color = AppColor.core;
        break;
      case 'explosive_runner_icon':
        assetPath = 'assets/sprites/runner_right.png';
        color = AppColor.explosiveStatus;
        break;
      case 'leaper_icon':
        assetPath = 'assets/sprites/leaper.png';
        color = AppColor.enemyLeaper;
        break;
      case 'core_icon':
      case 'core_icon_small':
        assetPath = 'assets/sprites/core.png';
        color = AppColor.core;
        break;
      case 'artifact_icon':
        assetPath = 'assets/sprites/artifact_unlock_icon.png';
        break;
      case 'upgrade_icon':
        assetPath = 'assets/sprites/upgrade_icon.png';
        break;
      case 'left_click_icon':
        assetPath = 'assets/ui/left_click.png';
        break;
      case 'right_click_icon':
        assetPath = 'assets/ui/right_click.png';
        break;
      case 'import_icon':
        assetPath = 'assets/ui/import.png';
        break;
      case 'export_icon':
        assetPath = 'assets/ui/export.png';
        break;
    }

    if (assetPath == null) return null;

    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          color: color,
        ),
      ),
    );
  }

  static TextSpan _textSpan(
    String text,
    List<String> active,
    TextStyle? base,
  ) {
    if (text.isEmpty) {
      return const TextSpan(text: '');
    }

    var style = base ?? const TextStyle();
    Color? color;
    var bold = false;
    for (final tag in active) {
      final tagColor = _tagColors[tag];
      if (tagColor != null) {
        color = tagColor;
        bold = true;
      }
    }
    if (color != null) {
      style = style.copyWith(
        color: color,
        fontWeight: bold ? FontWeight.w800 : style.fontWeight,
      );
    }
    return TextSpan(text: text, style: style);
  }
}
