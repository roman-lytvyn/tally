import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';
import '../layout.dart';

class WinScreen extends StatelessWidget {
  final AppTheme theme;
  final AppStrings strings;
  final List<String> teamNames;
  final List<int> scores;
  final int winner;
  final int players;
  final VoidCallback onUndo;
  final VoidCallback onNewGame;

  const WinScreen({
    super.key, required this.theme, required this.strings, required this.teamNames,
    required this.scores, required this.winner, this.players = 4, required this.onUndo, required this.onNewGame,
  });

  AppTheme get t => theme;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = isWideLayout(size);
    // A short window sets the trophy and the gaps tighter.
    final tight = size.height < 560;
    return Scaffold(
      backgroundColor: t.bg,
      body: Container(
        decoration: BoxDecoration(gradient: t.setupGradient),
        child: SafeArea(
          child: wide
              ? Row(children: [
                  Expanded(child: _centred(_winner(tight))),
                  Container(width: 1, color: t.bdr),
                  Expanded(child: _centred(_summary(tight))),
                ])
              : LayoutBuilder(builder: (context, box) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: box.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [_winner(false), const SizedBox(height: 20), _summary(false)],
                      ),
                    ),
                  ),
                )),
        ),
      ),
    );
  }

  /// One half of the landscape layout: centred, and scrolling if it must.
  Widget _centred(Widget child) => LayoutBuilder(builder: (context, box) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: child),
            ),
          ),
        ),
      ));

  /// The trophy and who won.
  Widget _winner(bool tight) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('🏆', textAlign: TextAlign.center, style: TextStyle(fontSize: tight ? 44 : 58)),
          SizedBox(height: tight ? 8 : 20),
          Text(teamNames[winner], textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: t.teamColor(winner))),
          const SizedBox(height: 4),
          Text(players == 4 ? strings.winLabel : strings.winLabelOne, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.acc)),
        ],
      );

  /// The final score and the two buttons.
  Widget _summary(bool tight) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(strings.finalScore, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: t.tx2)),
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: tight ? 12 : 18),
              decoration: BoxDecoration(
                color: t.surf, border: Border.all(color: t.bdr),
                borderRadius: BorderRadius.circular(18),
              ),
              child: FittedBox(fit: BoxFit.scaleDown, child: Row(mainAxisSize: MainAxisSize.min, children: [
                for (var i = 0; i < scores.length; i++) ...[
                  if (i > 0) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(':', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: t.tx3)),
                  ),
                  _scoreItem(i),
                ],
              ])),
            ),
          ),
          SizedBox(height: tight ? 16 : 28),
          GestureDetector(
            onTap: onNewGame,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: tight ? 13 : 17),
              decoration: BoxDecoration(gradient: t.ctaGradient, borderRadius: BorderRadius.circular(15)),
              alignment: Alignment.center,
              child: Text(strings.newGame,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
            ),
          ),
          const SizedBox(height: 9),
          GestureDetector(
            onTap: onUndo,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: tight ? 13 : 17),
              decoration: BoxDecoration(
                border: Border.all(color: t.bdr, width: 1.5),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Text(strings.undoLastRound,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: t.tx2)),
            ),
          ),
        ],
      );

  Widget _scoreItem(int i) => Column(children: [
    Text(teamNames[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
        letterSpacing: 0.4, color: t.teamColor(i))),
    const SizedBox(height: 3),
    Text('${scores[i]}', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800,
        color: i == winner ? t.teamColor(i) : t.tx)),
  ]);
}
