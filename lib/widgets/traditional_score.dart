import 'dart:math';

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

/// Small points of one digit, written at the end of what the sheet held when
/// they were written: after its first [at] marks, those in hand at the top,
/// those owed at the bottom.
class SheetNote {
  final int value;
  final int at;
  final bool crossed;

  const SheetNote(this.value, {required this.at, this.crossed = false});

  SheetNote get crossedOut => SheetNote(value, at: at, crossed: true);

  @override
  bool operator ==(Object other) =>
      other is SheetNote && other.value == value && other.at == at && other.crossed == crossed;

  @override
  int get hashCode => Object.hash(value, at, crossed);

  @override
  String toString() => '${crossed ? '~$value~' : '$value'}@$at';

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
      notes[i] = notes[i].crossedOut;
    }
    var rest = net;
    while (rest >= 20) {
      _addStick(marks);
      rest -= 20;
    }
    if (rest > 0) notes.addAll(_digits(marks, rest));
    for (var owed = -rest; owed > 0; owed -= 9) {
      notes.add(SheetNote(-(owed < 9 ? owed : 9), at: marks.length));
    }
  }

  /// [points] under 20 as one-digit small points: up to nine as they are,
  /// ten as nine and one, more as a stick and what it lacks owed.
  static List<SheetNote> _digits(List<SheetMark> marks, int points) {
    if (points <= 9) return [SheetNote(points, at: marks.length)];
    if (points == 10) return [SheetNote(9, at: marks.length), SheetNote(1, at: marks.length)];
    _addStick(marks);
    return [SheetNote(points - 20, at: marks.length)];
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
    // Nothing, or a score penalties have taken below nothing, has no marks to
    // write and is written as a number.
    final total = value;
    if (total <= 0) {
      return SizedBox(
        height: u * 1.8,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(total == 0 ? '0' : '−${-total}', style: TextStyle(fontSize: u * 0.5,
              color: total == 0 ? color.withValues(alpha: 0.3) : color, fontWeight: FontWeight.w700)),
        ),
      );
    }

    final sheet = ScoreSheet.write(changes);
    final faded = color.withValues(alpha: 0.65);
    final margin = u * 0.4;
    final gap = u * 0.1;
    final noteGap = u * 0.12;
    final direction = Directionality.of(context);

    TextStyle noteStyle(SheetNote n) => TextStyle(
      fontSize: u * 0.34, height: 1.0, fontWeight: FontWeight.w700,
      color: n.crossed ? faded.withValues(alpha: 0.4) : faded,
    );
    double noteWidth(SheetNote n) => (TextPainter(
      text: TextSpan(text: n.label, style: noteStyle(n)),
      textDirection: direction,
      maxLines: 1,
    )..layout()).width;

    // The marks keep their places whatever is written in the margins.
    final children = <Widget>[];
    final ends = <double>[0];
    var x = 0.0;
    for (final m in sheet.marks) {
      if (x > 0) x += gap;
      final w = m.isCircle ? u : _sticksWidth;
      children.add(PositionedDirectional(
        start: x, top: margin, width: w, height: u,
        child: CustomPaint(painter: m.isCircle ? _Circle(color, crossed: m.isComplete) : _Sticks(color, m.value)),
      ));
      x += w;
      ends.add(x);
    }

    // Small points go in the margins, from where their deal's marks ended:
    // in hand above, owed below, each after whatever is already there.
    var width = x;
    final cursor = {true: 0.0, false: 0.0};
    for (final n in sheet.notes) {
      final owed = n.value < 0;
      final start = max(ends[n.at], cursor[owed]!);
      final w = noteWidth(n);
      children.add(PositionedDirectional(
        start: start,
        top: owed ? margin + u : 0,
        height: margin,
        child: Align(
          alignment: owed ? AlignmentDirectional.topStart : AlignmentDirectional.bottomStart,
          child: CustomPaint(
            foregroundPainter: n.crossed ? _Slash(faded, u * 0.05) : null,
            child: Text(n.label, maxLines: 1, softWrap: false, style: noteStyle(n)),
          ),
        ),
      ));
      cursor[owed] = start + w + noteGap;
      if (start + w > width) width = start + w;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: width,
        height: u + margin * 2,
        child: Stack(clipBehavior: Clip.none, children: children),
      ),
    );
  }

  /// Room for a whole group, so the sticks never push what follows.
  double get _sticksWidth => 3 * u * 0.24 + u * 0.09;
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

/// Crosses out a small point with one stroke from bottom left to top right.
class _Slash extends CustomPainter {
  final Color c;
  final double width;
  _Slash(this.c, this.width);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = c..strokeWidth = width..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-width, size.height + width), Offset(size.width + width, -width), p);
  }
  @override bool shouldRepaint(_Slash old) => old.c != c || old.width != width;
}
