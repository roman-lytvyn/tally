import 'package:flutter/material.dart';

/// A score as it is written on a score sheet: crossed circles for 100,
/// circles for 50 and sticks for 20. Ten points or more beyond the last
/// stick are written as one more stick with what it still lacks noted above
/// it; anything smaller is added after the sticks.
class TraditionalMarks {
  final int hundreds;
  final int fifties;
  final int sticks;
  /// Points the last stick lacks: 36 is two sticks short of 4.
  final int short;
  /// Points left over after the sticks: 44 is two sticks and 4.
  final int extra;

  const TraditionalMarks({
    this.hundreds = 0, this.fifties = 0, this.sticks = 0, this.short = 0, this.extra = 0,
  });

  factory TraditionalMarks.of(int value) {
    var s = value.clamp(0, 99999);
    final hundreds = s ~/ 100; s %= 100;
    final fifties  = s ~/ 50;  s %= 50;
    final sticks   = s ~/ 20;  s %= 20;
    return s >= 10
        ? TraditionalMarks(hundreds: hundreds, fifties: fifties, sticks: sticks + 1, short: 20 - s)
        : TraditionalMarks(hundreds: hundreds, fifties: fifties, sticks: sticks, extra: s);
  }

  int get value => hundreds * 100 + fifties * 50 + sticks * 20 - short + extra;
}

class TraditionalScore extends StatelessWidget {
  final int value;
  final double u;
  final Color color;

  const TraditionalScore({super.key, required this.value, this.u = 30, required this.color});

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return SizedBox(
        height: u,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('0', style: TextStyle(fontSize: u * 0.5, color: color.withValues(alpha: 0.3), fontWeight: FontWeight.w700)),
        ),
      );
    }

    final m   = TraditionalMarks.of(value);
    final gap = u * 0.1;
    final note = TextStyle(fontSize: u * 0.3, color: color.withValues(alpha: 0.65), fontWeight: FontWeight.w700);

    final children = <Widget>[];

    for (int i = 0; i < m.hundreds; i++) {
      children.add(_circle(crossed: true));
    }
    for (int i = 0; i < m.fifties; i++) {
      children.add(_circle(crossed: false));
    }
    if (m.sticks > 0) children.add(_sticks(m.sticks));
    if (m.short > 0) {
      // What the last stick lacks, written up against its top end.
      children.add(SizedBox(
        height: u,
        child: Align(alignment: Alignment.topLeft, child: Text('−${m.short}', style: note)),
      ));
    }
    if (m.extra > 0) {
      children.add(Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text('+${m.extra}', style: note),
        ),
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: gap,
        children: children,
      ),
    );
  }

  Widget _circle({required bool crossed}) => SizedBox(
    width: u, height: u,
    child: CustomPaint(painter: crossed ? _CrossedCircle(color) : _OpenCircle(color)),
  );

  Widget _sticks(int count) {
    final sw = u * 0.09;
    final sg = u * 0.24;
    final w  = count * sg + sw;
    return SizedBox(width: w, height: u, child: CustomPaint(painter: _Sticks(color, count)));
  }
}

class _CrossedCircle extends CustomPainter {
  final Color c;
  _CrossedCircle(this.c);
  @override
  void paint(Canvas canvas, Size size) {
    final u = size.width;
    final p = Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = u * 0.09..strokeCap = StrokeCap.round;
    final center = Offset(u / 2, u / 2);
    final r = u * 0.37;
    canvas.drawCircle(center, r, p);
    final d = r * 0.62;
    canvas.drawLine(Offset(center.dx - d, center.dy - d), Offset(center.dx + d, center.dy + d), p);
    canvas.drawLine(Offset(center.dx + d, center.dy - d), Offset(center.dx - d, center.dy + d), p);
  }
  @override bool shouldRepaint(_) => false;
}

class _OpenCircle extends CustomPainter {
  final Color c;
  _OpenCircle(this.c);
  @override
  void paint(Canvas canvas, Size size) {
    final u = size.width;
    final p = Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = u * 0.09..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(u / 2, u / 2), u * 0.37, p);
  }
  @override bool shouldRepaint(_) => false;
}

class _Sticks extends CustomPainter {
  final Color c;
  final int count;
  _Sticks(this.c, this.count);
  @override
  void paint(Canvas canvas, Size size) {
    final u  = size.height;
    final sw = u * 0.09;
    final h  = u * 0.86;
    final sg = u * 0.24;
    final isBar = count == 3;
    final p = Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = sw..strokeCap = StrokeCap.round;
    final yOff = (u - h) / 2;
    final y1 = isBar ? yOff + sw * 1.2 : yOff;
    final y2 = isBar ? yOff + h - sw * 1.2 : yOff + h;
    if (isBar) {
      canvas.drawLine(Offset(sw / 2, yOff + sw / 2), Offset(size.width - sw / 2, yOff + sw / 2), p);
      canvas.drawLine(Offset(sw / 2, yOff + h + sw / 2), Offset(size.width - sw / 2, yOff + h + sw / 2), p);
    }
    for (int i = 0; i < count; i++) {
      final x = sw / 2 + sg / 2 + i * sg;
      canvas.drawLine(Offset(x, y1), Offset(x, y2), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}
