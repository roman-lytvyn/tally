import 'package:flutter/material.dart';
import '../l10n.dart';
import '../theme.dart';

/// The presentation beside the start screen in landscape: the name of the
/// game, what the app does for the players, and the footer last.
class WelcomePanel extends StatelessWidget {
  final AppTheme theme;
  final AppStrings strings;

  /// Shown under the text, e.g. links to other screens.
  final Widget? footer;

  const WelcomePanel({super.key, required this.theme, required this.strings, this.footer});

  AppTheme get t => theme;

  /// Below this height the type shrinks, so the panel fits a phone held
  /// sideways without scrolling.
  static const double _compactHeight = 520;

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
        child: LayoutBuilder(builder: (context, box) {
          final compact = box.maxHeight < _compactHeight;
          return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: box.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(36, compact ? 12 : 28, 36, compact ? 12 : 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _brand(compact),
                      SizedBox(height: compact ? 10 : 18),
                      Text(strings.welcomeTagline, key: const ValueKey('welcome.tagline'),
                          style: TextStyle(fontSize: compact ? 20 : 24, fontWeight: FontWeight.w700, height: 1.2, color: t.acc)),
                      SizedBox(height: compact ? 6 : 10),
                      Text(strings.welcomeDesc,
                          style: TextStyle(fontSize: compact ? 13 : 15, height: 1.4, color: t.tx2)),
                      if (footer != null) ...[
                        SizedBox(height: compact ? 8 : 18),
                        footer!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        }),
      ),
    ]);
  }

  Widget _brand(bool compact) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(strings.appTitle, style: TextStyle(fontSize: compact ? 36 : 52, fontWeight: FontWeight.w800,
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
}
