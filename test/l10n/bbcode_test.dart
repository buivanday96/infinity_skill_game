import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/l10n/bbcode.dart';
import 'package:infinity_skill_game/ui/core/app_color.dart';

void main() {
  const base = TextStyle(color: Colors.white, fontSize: 15);

  List<TextSpan> leaves(TextSpan root) {
    final out = <TextSpan>[];
    void walk(InlineSpan span) {
      if (span is! TextSpan) {
        return;
      }
      if (span.text != null && span.text!.isNotEmpty) {
        out.add(span);
      }
      for (final child in span.children ?? const <InlineSpan>[]) {
        walk(child);
      }
    }

    walk(root);
    return out;
  }

  group('Bbcode.parse', () {
    test('colors highlight and keyword tags', () {
      final span = Bbcode.parse(
        '[highlight]Arrow[/highlight] [kw_burn]Burn[/kw_burn]',
        base: base,
      );
      final text = leaves(span);
      expect(text.map((s) => s.text).join(), 'Arrow Burn');
      expect(
        text.firstWhere((s) => s.text == 'Arrow').style?.color,
        AppColor.highlightedForeground,
      );
      expect(
        text.firstWhere((s) => s.text == 'Burn').style?.color,
        AppColor.keywordBurn,
      );
    });

    test('colors value_before and value_after', () {
      final span = Bbcode.parse(
        '[value_before]8[/value_before] → [value_after]10[/value_after]',
        base: base,
      );
      final text = leaves(span);
      expect(text[0].style?.color, AppColor.highlightedForeground);
      expect(text[0].text, '8');
      expect(text[2].style?.color, AppColor.highlightedForeground2);
      expect(text[2].text, '10');
    });

    test('strips icon tags and renders arrow_icon as an arrow', () {
      final span = Bbcode.parse(
        '[coin_icon]Coins[arrow_icon]next',
        base: base,
      );
      expect(leaves(span).map((s) => s.text).join(), 'Coins → next');
    });
  });
}
