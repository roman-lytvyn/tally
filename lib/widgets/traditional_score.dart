import 'package:flutter/material.dart';

/// One mark on a score sheet: a circle worth 50 that its cross makes 100, or
/// a group of sticks worth 20 each that two bars close at 100.
class SheetMark {
  final bool isCircle;
  final int value;

  const SheetMark.circle(this.value) : isCircle = true;
  const SheetMark.sticks(this.value) : isCircle = false;

  bool get isComplete => value >= 100;

  @override
  bool operator ==(Object other) => other is SheetMark && other.isCircle == isCircle && other.value == value;

  @override
  int get hashCode => Object.hash(isCircle, value);

  @override
  String toString() => isCircle ? (isComplete ? '⊗' : '○') : '|$value';
}

/// Small points of one digit: those in hand written above the marks, those
/// owed below them.
class SheetNote {
  final int value;
  final bool crossed;

  const SheetNote(this.value, {this.crossed = false});

  @override
  bool operator ==(Object other) => other is SheetNote && other.value == value && other.crossed == crossed;

  @override
  int get hashCode => Object.hash(value, crossed);

  @override
  String toString() => crossed ? '~$value~' : '$value';

  String get label => value < 0 ? '−${-value}' : '$value';
}

/// A side's score as it is written on paper, deal after deal: what a deal
/// brings first completes the unfinished circle and sticks, and what is left
/// is written as new marks after them. Nothing written is ever redrawn, except
/// when a deal takes points away: then the sheet starts again from the new
/// total.
class ScoreSheet {
  final List<SheetMark> marks;
  final List<SheetNote> notes;

  const ScoreSheet._(this.marks, this.notes);

  static const empty = ScoreSheet._([], []);

  /// The sheet after the deals that changed the score by [changes].
  factory ScoreSheet.write(Iterable<int> changes) {
    var sheet = empty;
    var total = 0;
    for (final c in changes) {
      if (c == 0) continue;
      final wasPositive = total > 0;
      total += c;
      sheet = c > 0 && wasPositive ? sheet.add(c) : empty.add(total);
    }
    return sheet;
  }

  /// The points the sheet adds up to; crossed out notes no longer count.
  int get value =>
      marks.fold(0, (s, m) => s + m.value) + notes.fold(0, (s, n) => s + (n.crossed ? 0 : n.value));

  /// The sheet with [points] written onto it.
  ScoreSheet add(int points) {
    if (points <= 0) return this;
    final marks = [...this.marks];
    final notes = [...this.notes];
    var rest = points;

    final circle = marks.indexWhere((m) => m.isCircle && !m.isComplete);
    if (circle >= 0 && rest >= 50) {
      marks[circle] = const SheetMark.circle(100);
      rest -= 50;
    }
    rest = _growSticks(marks, rest);

    while (rest >= 100) {
      marks.add(const SheetMark.circle(100));
      rest -= 100;
    }
    // A circle only when it leaves fewer small points than sticks alone would.
    if (rest >= 50 && (rest - 50) % 20 <= rest % 20) {
      marks.add(const SheetMark.circle(50));
      rest -= 50;
    }
    if (rest >= 20) {
      marks.add(SheetMark.sticks(rest - rest % 20));
      rest %= 20;
    }

    if (rest > 0) _note(marks, notes, rest);
    return ScoreSheet._(List.unmodifiable(marks), List.unmodifiable(notes));
  }

  /// Writes [points] (under 20) as small points of one digit each. Once the small points
  /// owed and the ones in hand meet, or the ones in hand reach a stick, they
  /// are crossed out and what they come to is written again.
  static void _note(List<SheetMark> marks, List<SheetNote> notes, int points) {
    notes.addAll(_digits(marks, points));
    final open = [for (var i = 0; i < notes.length; i++) if (!notes[i].crossed) i];
    final net = open.fold(0, (s, i) => s + notes[i].value);
    final mixed = open.any((i) => notes[i].value > 0) && open.any((i) => notes[i].value < 0);
    if (!mixed && net < 20) return;
    for (final i in open) {
      notes[i] = SheetNote(notes[i].value, crossed: true);
    }
    var rest = net;
    while (rest >= 20) {
      _addStick(marks);
      rest -= 20;
    }
    if (rest > 0) notes.addAll(_digits(marks, rest));
    for (var owed = -rest; owed > 0; owed -= 9) {
      notes.add(SheetNote(-(owed < 9 ? owed : 9)));
    }
  }

  /// [points] under 20 as one-digit small points: up to nine as they are,
  /// ten as nine and one, more as a stick and what it lacks owed.
  static List<SheetNote> _digits(List<SheetMark> marks, int points) {
    if (points <= 9) return [SheetNote(points)];
    if (points == 10) return const [SheetNote(9), SheetNote(1)];
    _addStick(marks);
    return [SheetNote(points - 20)];
  }

  static void _addStick(List<SheetMark> marks) {
    if (_growSticks(marks, 20) > 0) marks.add(const SheetMark.sticks(20));
  }

  /// Adds sticks from [points] to the unfinished group, 20 at a time, and
  /// returns what is left.
  static int _growSticks(List<SheetMark> marks, int points) {
    final open = marks.indexWhere((m) => !m.isCircle && !m.isComplete);
    if (open < 0) return points;
    final room = 100 - marks[open].value;
    final taken = (points ~/ 20 * 20).clamp(0, room);
    if (taken > 0) marks[open] = SheetMark.sticks(marks[open].value + taken);
    return points - taken;
  }
}

class TraditionalScore extends StatelessWidget {
  /// How much each deal changed this side's total, in the order played.
  final List<int> changes;
  final double u;
  final Color color;

  const TraditionalScore({super.key, required this.changes, this.u = 30, required this.color});

  int get value => changes.fold(0, (s, c) => s + c);

  @override
  Widget build(BuildContext context) {
    final noteHeight = u * 0.4;
    // Nothing, or a score penalties have taken below nothing, has no marks to
    // write and is written as a number.
    final total = value;
    if (total <= 0) {
      return SizedBox(
        height: u + noteHeight,
        child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: SizedBox(
            height: u,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(total == 0 ? '0' : '−${-total}', style: TextStyle(fontSize: u * 0.5,
                  color: total == 0 ? color.withValues(alpha: 0.3) : color, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      );
    }

    final sheet = ScoreSheet.write(changes);
    final gap = u * 0.1;
    final faded = color.withValues(alpha: 0.65);

    Widget notes(bool owed) => SizedBox(
      height: noteHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: u * 0.2,
        children: [
          for (final n in sheet.notes)
            if ((n.value < 0) == owed)
              Text(n.label, style: TextStyle(
                fontSize: u * 0.32, height: 1.1, fontWeight: FontWeight.w700,
                color: n.crossed ? faded.withValues(alpha: 0.4) : faded,
                decoration: n.crossed ? TextDecoration.lineThrough : null,
                decorationColor: faded,
                decorationThickness: 2,
              )),
        ],
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          notes(false),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: gap,
            children: [for (final m in sheet.marks) m.isCircle ? _circle(m) : _sticks(m)],
          ),
          if (sheet.notes.any((n) => n.value < 0)) notes(true),
        ],
      ),
    );
  }

  Widget _circle(SheetMark m) => SizedBox(
    width: u, height: u,
    child: CustomPaint(painter: _Circle(color, crossed: m.isComplete)),
  );

  Widget _sticks(SheetMark m) {
    final count = (m.value ~/ 20).clamp(1, 3);
    final w = count * u * 0.24 + u * 0.09;
    return SizedBox(width: w, height: u, child: CustomPaint(painter: _Sticks(color, m.value)));
  }
}

class _Circle extends CustomPainter {
  final Color c;
  final bool crossed;
  _Circle(this.c, {required this.crossed});
  @override
  void paint(Canvas canvas, Size size) {
    final u = size.width;
    final p = Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = u * 0.09..strokeCap = StrokeCap.round;
    final center = Offset(u / 2, u / 2);
    final r = u * 0.37;
    canvas.drawCircle(center, r, p);
    if (!crossed) return;
    final d = r * 0.62;
    canvas.drawLine(Offset(center.dx - d, center.dy - d), Offset(center.dx + d, center.dy + d), p);
    canvas.drawLine(Offset(center.dx + d, center.dy - d), Offset(center.dx - d, center.dy + d), p);
  }
  @override bool shouldRepaint(_Circle old) => old.c != c || old.crossed != crossed;
}

/// Sticks up to three, then a bar on top for 80 and one below for 100.
class _Sticks extends CustomPainter {
  final Color c;
  final int value;
  _Sticks(this.c, this.value);
  @override
  void paint(Canvas canvas, Size size) {
    final u  = size.height;
    final sw = u * 0.09;
    final h  = u * 0.86;
    final sg = u * 0.24;
    final count = (value ~/ 20).clamp(1, 3);
    final top = value >= 80;
    final bottom = value >= 100;
    final p = Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = sw..strokeCap = StrokeCap.round;
    final yOff = (u - h) / 2;
    final y1 = top ? yOff + sw * 1.2 : yOff;
    final y2 = bottom ? yOff + h - sw * 1.2 : yOff + h;
    if (top) canvas.drawLine(Offset(sw / 2, yOff + sw / 2), Offset(size.width - sw / 2, yOff + sw / 2), p);
    if (bottom) {
      canvas.drawLine(Offset(sw / 2, yOff + h - sw / 2), Offset(size.width - sw / 2, yOff + h - sw / 2), p);
    }
    for (int i = 0; i < count; i++) {
      final x = sw / 2 + sg / 2 + i * sg;
      canvas.drawLine(Offset(x, y1), Offset(x, y2), p);
    }
  }
  @override bool shouldRepaint(_Sticks old) => old.c != c || old.value != value;
}
