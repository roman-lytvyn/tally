import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deberc/widgets/traditional_score.dart';

void main() {
  group('the score-sheet notation', () {
    test('writes ten points or more past a stick as one more stick, short of the rest', () {
      final m = TraditionalMarks.of(36);

      expect([m.sticks, m.short, m.extra], [2, 4, 0]);
    });

    test('adds fewer than ten points after the sticks', () {
      final m = TraditionalMarks.of(44);

      expect([m.sticks, m.short, m.extra], [2, 0, 4]);
    });

    test('uses circles for fifty and crossed circles for a hundred', () {
      final m = TraditionalMarks.of(250);

      expect([m.hundreds, m.fifties, m.sticks, m.short, m.extra], [2, 1, 0, 0, 0]);
    });

    test('stays below the next circle', () {
      final m = TraditionalMarks.of(49);

      expect([m.fifties, m.sticks, m.extra], [0, 2, 9]);
    });

    test('always adds up to the real score', () {
      for (var v = 0; v <= 1200; v++) {
        expect(TraditionalMarks.of(v).value, v, reason: '$v');
      }
    });
  });

  testWidgets('shows what the last stick lacks', (tester) async {
    await tester.pumpWidget(const Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: TraditionalScore(value: 136, color: Color(0xFF000000))),
    ));

    expect(find.text('−4'), findsOneWidget);
    expect(find.textContaining('+'), findsNothing);
  });
}
