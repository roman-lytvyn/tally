import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deberc/widgets/traditional_score.dart';

const circle = SheetMark.circle(50);
const crossed = SheetMark.circle(100);
SheetMark sticks(int v) => SheetMark.sticks(v);

void main() {
  group('the score sheet', () {
    test('writes a first deal as a circle, a stick and the small points', () {
      final s = ScoreSheet.write([72]);

      expect(s.marks, [circle, sticks(20)]);
      expect(s.notes, [const SheetNote(2)]);
    });

    test('crosses the circle and grows the sticks before writing anything new', () {
      final s = ScoreSheet.write([72, 110]);

      expect(s.marks, [crossed, sticks(80)]);
      expect(s.notes, [const SheetNote(2)]);
    });

    test('closes the sticks at a hundred and starts a new group after them', () {
      final s = ScoreSheet.write([72, 110, 44]);

      expect(s.marks, [crossed, sticks(100), sticks(20)]);
      expect(s.notes, [const SheetNote(2), const SheetNote(4)]);
      expect(s.value, 226);
    });

    test('never redraws what is already written while the score grows', () {
      final rnd = Random(7);
      for (var game = 0; game < 200; game++) {
        var sheet = ScoreSheet.empty;
        for (var deal = 0; deal < 12; deal++) {
          final next = sheet.add(rnd.nextInt(250) + 1);
          for (var i = 0; i < sheet.marks.length; i++) {
            final before = sheet.marks[i], after = next.marks[i];
            expect(after.isCircle, before.isCircle);
            expect(after.value, greaterThanOrEqualTo(before.value));
          }
          for (var i = 0; i < sheet.notes.length; i++) {
            expect(next.notes[i].value, sheet.notes[i].value);
            if (sheet.notes[i].crossed) expect(next.notes[i].crossed, isTrue);
          }
          sheet = next;
        }
      }
    });

    test('crosses the small points out for a stick once they reach twenty', () {
      final s = ScoreSheet.write([72, 8, 15]);

      expect(s.notes, [const SheetNote(2, crossed: true), const SheetNote(8, crossed: true),
          const SheetNote(15, crossed: true), const SheetNote(5)]);
      expect(s.marks, [circle, sticks(40)]);
      expect(s.value, 95);
    });

    test('writes sticks rather than a circle that would leave more small points', () {
      expect(ScoreSheet.write([60]).marks, [sticks(60)]);
      expect(ScoreSheet.write([80]).marks, [sticks(80)]);
      expect(ScoreSheet.write([150]).marks, [crossed, circle]);
    });

    test('starts again from the new total after a penalty', () {
      final s = ScoreSheet.write([72, 110, -100]);

      expect(s.marks, [sticks(80)]);
      expect(s.notes, [const SheetNote(2)]);
    });

    test('always adds up to the real score', () {
      final rnd = Random(3);
      for (var game = 0; game < 300; game++) {
        final changes = [for (var d = 0; d < 15; d++) rnd.nextInt(300) - 60];
        var total = 0;
        for (var d = 0; d < changes.length; d++) {
          total += changes[d];
          final s = ScoreSheet.write(changes.take(d + 1));
          expect(s.value, max(total, 0), reason: '${changes.take(d + 1)}');
        }
      }
    });
  });

  testWidgets('writes the small points above the marks', (tester) async {
    await tester.pumpWidget(const Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: TraditionalScore(changes: [72, 110, 44], color: Color(0xFF000000))),
    ));

    expect(find.text('2'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.byType(CustomPaint), findsAtLeastNWidgets(3));
  });
}
