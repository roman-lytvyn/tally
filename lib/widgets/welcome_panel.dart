import 'package:flutter/material.dart';
import '../l10n.dart';
import '../theme.dart';
import 'traditional_score.dart';

/// The presentation beside the start screen in landscape: the name of the
/// game, what the app does for the players, and a sample of its score sheet.
class WelcomePanel extends StatelessWidget {
  final AppTheme theme;
  final AppStrings strings;

  const WelcomePanel({super.key, required this.theme, required this.strings});

  AppTheme get t => theme;

  /// The sample sheet needs this much height on top of the rest to be shown.
  static const double _sheetMinHeight = 620;

  static const _glyphs = ['↻', '+', '✎', '✦'];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // The lamp over the table: a soft gold glow in the top corner.
      Positioned.fill(child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.9, -1.0),
            radius: 1.1,
            colors: [t.acc.withValues(alpha: t.isDark ? 0.16 : 0.12), t.acc.withValues(alpha: 0)],
          ),
        ),
      )),
      SafeArea(
        child: LayoutBuilder(builder: (context, box) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: box.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36, 28, 36, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _brand(),
                      const SizedBox(height: 18),
                      Text(strings.welcomeTagline, key: const ValueKey('welcome.tagline'),
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.2, color: t.acc)),
                      const SizedBox(height: 10),
                      Text(strings.welcomeDesc,
                          style: TextStyle(fontSize: 15, height: 1.45, color: t.tx2)),
                      if (box.maxHeight >= _sheetMinHeight) ...[
                        const SizedBox(height: 22),
                        _sheet(),
                      ],
                      const SizedBox(height: 22),
                      for (final (i, f) in strings.welcomeFeatures.indexed) ...[
                        if (i > 0) const SizedBox(height: 14),
                        _feature(_glyphs[i % _glyphs.length], f.$1, f.$2),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        )),
      ),
    ]);
  }

  Widget _brand() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(strings.appTitle, style: TextStyle(fontSize: 52, fontWeight: FontWeight.w800,
        letterSpacing: -1.5, height: 1.05, color: t.tx)),
    const SizedBox(height: 6),
    RichText(text: TextSpan(
      style: TextStyle(fontSize: 22, letterSpacing: 8, color: t.tx.withValues(alpha: 0.55)),
      children: const [
        TextSpan(text: '♠'),
        TextSpan(text: '♥', style: TextStyle(color: Color(0xFFE05252))),
        TextSpan(text: '♦', style: TextStyle(color: Color(0xFFE05252))),
        TextSpan(text: '♣'),
      ],
    )),
  ]);

  /// A small score sheet of two sides, written the way the app writes it.
  Widget _sheet() {
    final names = strings.defaultNames(2);
    const sample = [[62, 20, 81, 40], [100, 0, 91, 20]];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: t.surf, border: Border.all(color: t.bdr),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (var i = 0; i < 2; i++) ...[
          if (i > 0) Container(width: 1, height: 96, color: t.bdr, margin: const EdgeInsets.symmetric(horizontal: 14)),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(names[i], maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.4, color: t.teamColor(i))),
            const SizedBox(height: 4),
            TraditionalScore(changes: sample[i], u: 24, color: t.teamColor(i)),
          ])),
        ],
      ]),
    );
  }

  Widget _feature(String glyph, String title, String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 36, height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: t.accDim, border: Border.all(color: t.accBdr), borderRadius: BorderRadius.circular(11)),
        child: Text(glyph, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: t.acc)),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: t.tx)),
        const SizedBox(height: 2),
        Text(text, style: TextStyle(fontSize: 13, height: 1.35, color: t.tx2)),
      ])),
    ],
  );
}
