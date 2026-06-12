import 'package:flutter/material.dart';

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

    int s = value.clamp(0, 99999);
    final hundreds = s ~/ 100; s %= 100;
    final fifties  = s ~/ 50;  s %= 50;
    final twenties = s ~/ 20;  s %= 20;
    final rem      = s;

    final fullGroups = twenties ~/ 3;
    final leftover   = twenties % 3;
    final gap        = u * 0.1;

    final children = <Widget>[];

    for (int i = 0; i < hundreds; i++) {
      children.add(_circle(crossed: true));
    }
    for (int i = 0; i < fifties; i++) {
      children.add(_circle(crossed: false));
    }
    for (int i = 0; i < fullGroups; i++) {
      children.add(_sticks(3));
    }
    if (leftover > 0) children.add(_sticks(leftover));
    if (rem > 0) {
      children.add(Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(bottom: 2),
          child: Text('+$rem', style: TextStyle(fontSize: u * 0.3, color: color.withValues(alpha: 0.65), fontWeight: FontWeight.w700)),
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
