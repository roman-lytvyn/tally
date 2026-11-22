import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';
import '../rules_content.dart';
import '../layout.dart';

class RulesScreen extends StatelessWidget {
  final AppTheme theme;
  final AppStrings strings;
  final VoidCallback onBack;

  const RulesScreen({super.key, required this.theme, required this.strings, required this.onBack});

  AppTheme get t => theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(gradient: t.headerGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                child: Row(children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(10)),
                      child: Text(strings.backBtn,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.tx2)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(strings.rulesTitle,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: t.tx)),
                  )),
                ]),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                children: _body(rulesContent(strings.lang, strings.game), isWideLayout(MediaQuery.sizeOf(context))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// One column, or two of about equal length when the screen is wide.
  List<Widget> _body(List<RulesSection> sections, bool wide) {
    if (!wide || sections.length < 2) return [for (final s in sections) _section(s)];
    int weight(RulesSection s) =>
        80 + s.paragraphs.fold<int>(0, (n, p) => n + p.length) + s.table.length * 60;
    final total = sections.fold<int>(0, (n, s) => n + weight(s));
    final left = <Widget>[], right = <Widget>[];
    var sum = 0;
    for (final s in sections) {
      final w = weight(s);
      // A section goes left while that keeps the left half closer to half the total.
      final toLeft = left.isEmpty || (sum + w / 2) < total / 2;
      (toLeft ? left : right).add(_section(s));
      if (toLeft) sum += w;
    }
    return [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: left)),
        const SizedBox(width: 28),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: right)),
      ]),
    ];
  }

  Widget _section(RulesSection s) => Padding(
    padding: const EdgeInsets.only(top: 14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(s.title.toUpperCase(),
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1, color: t.acc)),
      const SizedBox(height: 6),
      for (final p in s.paragraphs) _paragraph(p),
      if (s.table.isNotEmpty) _table(s),
    ]),
  );

  Widget _paragraph(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: TextStyle(fontSize: 14, height: 1.4, color: t.tx)),
  );

  Widget _table(RulesSection s) {
    final header = s.tableHeader;
    TableRow row(List<String> cells, {bool head = false}) => TableRow(
      decoration: head ? BoxDecoration(color: t.surf2) : null,
      children: [
        for (var i = 0; i < cells.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Text(cells[i],
                textAlign: i == 0 ? TextAlign.start : TextAlign.center,
                style: TextStyle(fontSize: 13, color: head ? t.tx2 : t.tx,
                    fontWeight: head ? FontWeight.w700 : FontWeight.w500)),
          ),
      ],
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.surf, border: Border.all(color: t.bdr),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(2)},
        border: TableBorder(horizontalInside: BorderSide(color: t.bdr)),
        children: [
          if (header != null) row(header, head: true),
          for (final r in s.table) row(r),
        ],
      ),
    );
  }
}
