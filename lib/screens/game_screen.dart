import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';
import '../models.dart';
import '../widgets/entry_panel.dart';
import '../widgets/traditional_score.dart';

class GameScreen extends StatelessWidget {
  final AppTheme theme;
  final AppStrings strings;
  final List<String> teamNames;
  final List<int> scores;
  final int scoreLimit;
  final List<Round> rounds;
  final int dealer;
  final String scoreStyle;
  final void Function(Round) onAddRound;
  final VoidCallback onBack;
  final VoidCallback onSettings;

  const GameScreen({
    super.key, required this.theme, required this.strings, required this.teamNames, required this.scores,
    required this.scoreLimit, required this.rounds, required this.dealer,
    required this.scoreStyle, required this.onAddRound,
    required this.onBack, required this.onSettings,
  });

  AppTheme get t => theme;
  bool get isTraditional => scoreStyle == 'traditional';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildScoreSection(),
            if (!isTraditional) _buildProgressBars(),
            Expanded(child: _buildRoundsList()),
            EntryPanel(theme: t, strings: strings, teamNames: teamNames, dealer: dealer, onSave: onAddRound),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    decoration: BoxDecoration(gradient: t.headerGradient),
    padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
    child: Row(children: [
      _iconBtn(strings.exitBtn, onBack),
      Expanded(child: Text(strings.appTitle.toUpperCase(), textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: t.tx3, letterSpacing: 0.5))),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
        decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(20)),
        child: Text('#${rounds.length + 1}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: t.tx2)),
      ),
      const SizedBox(width: 8),
      _iconBtn('⚙', onSettings),
    ]),
  );

  Widget _iconBtn(String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.tx2)),
    ),
  );

  Widget _buildScoreSection() {
    if (isTraditional) return _buildTraditionalScores();
    return _buildNumericScores();
  }

  Widget _buildTraditionalScores() => Padding(
    padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
    child: Column(
      children: List.generate(2, (i) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(teamNames[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                letterSpacing: 0.4, color: t.teamColor(i))),
            const SizedBox(width: 6),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: dealer == i ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: t.teamDim(i), borderRadius: BorderRadius.circular(20)),
                child: Text(strings.deals, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                    color: t.teamColor(i), letterSpacing: 0.5)),
              ),
            ),
          ]),
          const SizedBox(height: 4),
          SizedBox(
            height: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: (scores[i] / scoreLimit).clamp(0.0, 1.0),
                backgroundColor: t.surf2,
                valueColor: AlwaysStoppedAnimation(t.teamColor(i)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          TraditionalScore(value: scores[i], u: 30, color: t.teamColor(i)),
        ]),
      )),
    ),
  );

  Widget _buildNumericScores() => Padding(
    padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(2, (i) => Column(children: [
        Text(teamNames[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
            letterSpacing: 0.4, color: t.teamColor(i))),
        const SizedBox(height: 2),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: dealer == i ? 1.0 : 0.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: t.teamDim(i), borderRadius: BorderRadius.circular(20)),
            child: Text(strings.deals, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: t.teamColor(i))),
          ),
        ),
      ]))),
      const SizedBox(height: 2),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('${scores[0]}', style: TextStyle(fontSize: 56, fontWeight: FontWeight.w800, height: 1,
            letterSpacing: -2, color: scores[0] > scores[1] ? t.t0 : t.tx)),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: t.tx3))),
        Text('${scores[1]}', style: TextStyle(fontSize: 56, fontWeight: FontWeight.w800, height: 1,
            letterSpacing: -2, color: scores[1] > scores[0] ? t.t1 : t.tx)),
      ]),
    ]),
  );

  Widget _buildProgressBars() => Padding(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
    child: Column(children: [
      Row(children: [
        Expanded(child: _progressBar(0)),
        Container(width: 1, height: 10, color: t.bdr, margin: const EdgeInsets.symmetric(horizontal: 4)),
        Expanded(child: _progressBar(1)),
      ]),
      const SizedBox(height: 4),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${scores[0]}/$scoreLimit', style: TextStyle(fontSize: 11, color: t.tx3)),
        Text('${scores[1]}/$scoreLimit', style: TextStyle(fontSize: 11, color: t.tx3)),
      ]),
    ]),
  );

  Widget _progressBar(int i) => ClipRRect(
    borderRadius: BorderRadius.circular(3),
    child: SizedBox(
      height: 5,
      child: LinearProgressIndicator(
        value: (scores[i] / scoreLimit).clamp(0.0, 1.0),
        backgroundColor: t.surf2,
        valueColor: AlwaysStoppedAnimation(t.teamColor(i)),
      ),
    ),
  );

  Widget _buildRoundsList() {
    if (rounds.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🃏', style: TextStyle(fontSize: 34)),
          const SizedBox(height: 10),
          Text(strings.noRoundsYet, style: TextStyle(fontSize: 13, color: t.tx3)),
          const SizedBox(height: 3),
          Text(strings.tapNewRound, style: TextStyle(fontSize: 12, color: t.tx3)),
        ]),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      itemCount: rounds.length,
      itemBuilder: (_, idx) {
        final r = rounds[rounds.length - 1 - idx];
        final num = rounds.length - idx;
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: t.surf, border: Border.all(color: t.bdr),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 26,
                    child: Center(child: Text('#$num',
                        style: TextStyle(fontSize: 11, color: t.tx3, fontWeight: FontWeight.w700)))),
                Expanded(child: _roundScore(r, 0)),
                Container(
                    width: 1, color: t.bdr,
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1)),
                Expanded(child: _roundScore(r, 1)),
                SizedBox(
                  width: 72,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _roundMeta(r),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _roundMeta(Round r) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (r.isBait) _badge(strings.badgeBait, t.t1, t.t1.withValues(alpha: 0.13)),
      if (r.yaytsia) _badge(strings.badgeEggs, t.egg, t.eggDim),
      if (r.fell && !r.isBait && !r.yaytsia) _badge(strings.badgeFell, t.danger, t.dangerDim),
      if (r.isBait || r.yaytsia || r.fell) const SizedBox(width: 3),
      Text('${r.gv}${strings.pts}', style: TextStyle(fontSize: 9, color: t.tx3)),
    ],
  );

  Widget _roundScore(Round r, int i) {
    final fell = (r.fell || r.yaytsia) && r.dealer == i;
    return Align(
      alignment: i == 0 ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        '${r.earned[i]}',
        style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700,
          color: fell ? t.danger : t.teamColor(i),
          decoration: fell ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }

  Widget _badge(String text, Color color, Color bg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.4)),
  );
}
