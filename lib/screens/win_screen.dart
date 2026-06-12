import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';

class WinScreen extends StatelessWidget {
  final AppTheme theme;
  final AppStrings strings;
  final List<String> teamNames;
  final List<int> scores;
  final int winner;
  final VoidCallback onNewGame;

  const WinScreen({
    super.key, required this.theme, required this.strings, required this.teamNames,
    required this.scores, required this.winner, required this.onNewGame,
  });

  AppTheme get t => theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      body: Container(
        decoration: BoxDecoration(gradient: t.setupGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('🏆', textAlign: TextAlign.center, style: TextStyle(fontSize: 58)),
                const SizedBox(height: 20),
                Text(teamNames[winner], textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: t.teamColor(winner))),
                const SizedBox(height: 4),
                Text(strings.winLabel, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.acc)),
                const SizedBox(height: 20),
                Text(strings.finalScore, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: t.tx2)),
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                    decoration: BoxDecoration(
                      color: t.surf, border: Border.all(color: t.bdr),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      _scoreItem(0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(':', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: t.tx3)),
                      ),
                      _scoreItem(1),
                    ]),
                  ),
                ),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: onNewGame,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    decoration: BoxDecoration(gradient: t.ctaGradient, borderRadius: BorderRadius.circular(15)),
                    alignment: Alignment.center,
                    child: Text(strings.newGame,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scoreItem(int i) => Column(children: [
    Text(teamNames[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
        letterSpacing: 0.4, color: t.teamColor(i))),
    const SizedBox(height: 3),
    Text('${scores[i]}', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800,
        color: i == winner ? t.teamColor(i) : t.tx)),
  ]);
}
