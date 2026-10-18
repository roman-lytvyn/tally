import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';
import '../models.dart';
import '../scoring.dart';
import '../widgets/entry_panel.dart';
import '../widgets/traditional_score.dart';

class GameScreen extends StatefulWidget {
  final AppTheme theme;
  final AppStrings strings;
  final List<String> teamNames;
  final int scoreLimit;
  final int players;
  final bool dealerMustPlay;
  final TieRule tieRule;
  final List<Round> rounds;
  final Tally tally;
  final String scoreStyle;
  final void Function(Round) onAddRound;
  final void Function(int, Round) onReplaceRound;
  final void Function(int) onRemoveRound;
  final VoidCallback onUndo;
  final VoidCallback onBack;
  final VoidCallback onSettings;

  const GameScreen({
    super.key, required this.theme, required this.strings, required this.teamNames,
    required this.scoreLimit, this.players = 4, required this.dealerMustPlay, required this.tieRule, required this.rounds, required this.tally,
    required this.scoreStyle, required this.onAddRound, required this.onReplaceRound,
    required this.onRemoveRound, required this.onUndo,
    required this.onBack, required this.onSettings,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _entryOpen = false;
  int? _editing;
  // Bumped on every opening so the panel starts from a clean slate.
  int _session = 0;

  AppTheme get t => widget.theme;
  AppStrings get strings => widget.strings;
  List<String> get teamNames => widget.teamNames;
  List<int> get scores => widget.tally.totals;
  int get dealer => widget.tally.dealer;
  List<Round> get rounds => widget.rounds;
  bool get isTraditional => widget.scoreStyle == 'traditional';
  int get sides => teamNames.length;
  // Only a team has two players to tell apart.
  String get _dealsLabel =>
      widget.players == 4 ? strings.dealsSeat(widget.tally.dealerSeat + 1) : strings.deals;

  void _openEntry([int? index]) => setState(() { _entryOpen = true; _editing = index; _session++; });

  void _closeEntry() => setState(() { _entryOpen = false; _editing = null; });

  void _saveEntry(Round r) {
    final index = _editing;
    _closeEntry();
    if (index == null) {
      widget.onAddRound(r);
    } else {
      widget.onReplaceRound(index, r);
    }
  }

  void _deleteEntry() {
    final index = _editing;
    _closeEntry();
    if (index != null) widget.onRemoveRound(index);
  }

  @override
  Widget build(BuildContext context) {
    final editing = _editing;
    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildScoreSection(),
            if (!isTraditional) _buildProgressBars(),
            if (widget.tally.held > 0) _buildHeld(),
            Expanded(child: _buildRoundsList()),
            EntryPanel(
              key: ValueKey(_session),
              theme: t, strings: strings, teamNames: teamNames, dealer: dealer,
              firstToBid: (dealer + 1) % sides, dealerMustPlay: widget.dealerMustPlay, tieRule: widget.tieRule,
              open: _entryOpen,
              initial: editing != null ? rounds[editing] : null,
              number: editing != null ? editing + 1 : null,
              onOpen: () => _openEntry(),
              onCancel: _closeEntry,
              onSave: _saveEntry,
              onDelete: editing != null ? _deleteEntry : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    decoration: BoxDecoration(gradient: t.headerGradient),
    padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
    child: Row(children: [
      _iconBtn(strings.exitBtn, widget.onBack),
      Expanded(child: Text(strings.appTitle.toUpperCase(), textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: t.tx3, letterSpacing: 0.5))),
      if (rounds.isNotEmpty) ...[
        _iconBtn(strings.undoBtn, () { _closeEntry(); widget.onUndo(); }),
        const SizedBox(width: 8),
      ],
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
        decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(20)),
        child: Text('#${rounds.length + 1}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: t.tx2)),
      ),
      const SizedBox(width: 8),
      _iconBtn('⚙', widget.onSettings),
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
      children: List.generate(sides, (i) => Padding(
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
                child: Text(_dealsLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
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
                value: (scores[i] / widget.scoreLimit).clamp(0.0, 1.0),
                backgroundColor: t.surf2,
                valueColor: AlwaysStoppedAnimation(t.teamColor(i)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          TraditionalScore(value: scores[i], u: sides > 2 ? 22 : 30, color: t.teamColor(i)),
        ]),
      )),
    ),
  );

  Widget _buildNumericScores() => Padding(
    padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(sides, (i) => Column(children: [
        Text(teamNames[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
            letterSpacing: 0.4, color: t.teamColor(i))),
        const SizedBox(height: 2),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: dealer == i ? 1.0 : 0.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: t.teamDim(i), borderRadius: BorderRadius.circular(20)),
            child: Text(_dealsLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: t.teamColor(i))),
          ),
        ),
      ]))),
      const SizedBox(height: 2),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var i = 0; i < sides; i++) ...[
          if (i > 0) Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: t.tx3))),
          Text('${scores[i]}', style: TextStyle(fontSize: sides > 2 ? 40 : 56, fontWeight: FontWeight.w800,
              height: 1, letterSpacing: -2, color: _leads(i) ? t.teamColor(i) : t.tx)),
        ],
      ]),
    ]),
  );

  /// Whether side [i] is ahead of every other side.
  bool _leads(int i) => [for (var j = 0; j < sides; j++) if (j != i) scores[j]].every((s) => scores[i] > s);

  Widget _buildProgressBars() => Padding(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
    child: Column(children: [
      Row(children: [
        for (var i = 0; i < sides; i++) ...[
          if (i > 0) Container(width: 1, height: 10, color: t.bdr, margin: const EdgeInsets.symmetric(horizontal: 4)),
          Expanded(child: _progressBar(i)),
        ],
      ]),
      const SizedBox(height: 4),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        for (var i = 0; i < sides; i++)
          Text('${scores[i]}/${widget.scoreLimit}', style: TextStyle(fontSize: 11, color: t.tx3)),
      ]),
    ]),
  );

  Widget _progressBar(int i) => ClipRRect(
    borderRadius: BorderRadius.circular(3),
    child: SizedBox(
      height: 5,
      child: LinearProgressIndicator(
        value: (scores[i] / widget.scoreLimit).clamp(0.0, 1.0),
        backgroundColor: t.surf2,
        valueColor: AlwaysStoppedAnimation(t.teamColor(i)),
      ),
    ),
  );

  Widget _buildHeld() => Padding(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(color: t.eggDim, borderRadius: BorderRadius.circular(10)),
      child: Text(strings.heldMsg(widget.tally.held), textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: t.egg)),
    ),
  );

  Widget _buildRoundsList() {
    if (rounds.isEmpty) {
      // Shrinks rather than overflows while the entry panel takes up the space.
      return Center(
        child: FittedBox(fit: BoxFit.scaleDown, child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🃏', style: TextStyle(fontSize: 34)),
          const SizedBox(height: 10),
          Text(strings.noRoundsYet, style: TextStyle(fontSize: 13, color: t.tx3)),
          const SizedBox(height: 3),
          Text(strings.tapNewRound, style: TextStyle(fontSize: 12, color: t.tx3)),
        ])),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      itemCount: rounds.length,
      itemBuilder: (_, idx) {
        final index = rounds.length - 1 - idx;
        final r = rounds[index];
        final earned = widget.tally.earned[index];
        final selected = _editing == index;
        return GestureDetector(
          onTap: () => _openEntry(index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? t.accDim : t.surf,
              border: Border.all(color: selected ? t.accBdr : t.bdr),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: 26,
                      child: Center(child: Text('#${index + 1}',
                          style: TextStyle(fontSize: 11, color: t.tx3, fontWeight: FontWeight.w700)))),
                  for (var i = 0; i < sides; i++) ...[
                    if (i > 0) Container(
                        width: 1, color: t.bdr,
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1)),
                    Expanded(child: _roundScore(r, earned, i)),
                  ],
                  SizedBox(
                    width: 72,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(fit: BoxFit.scaleDown, child: _roundMeta(r)),
                    ),
                  ),
                ],
              ),
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
      if (r.isRedeal) _badge(strings.badgeRedeal, t.tx3, t.surf2),
      if (r.isDeberc) _badge(strings.badgeDeberc, t.acc, t.accDim),
      if (r.isBaited) _badge(strings.badgeBait, t.danger, t.dangerDim),
      if (r.isTie) _badge(strings.badgeEggs, t.egg, t.eggDim),
      if (r.isDeberc || r.isBaited || r.isTie) const SizedBox(width: 3),
      if (!r.isRedeal) Text('${r.gv}${strings.pts}', style: TextStyle(fontSize: 9, color: t.tx3)),
    ],
  );

  Widget _roundScore(Round r, List<int> earned, int i) {
    // On a tie the trump-taker's own points, when not scored, show crossed out.
    final lost = r.isTie && r.taker == i && earned[i] < r.score[i];
    // The trump-taker's points carry a ♠ on the side facing away from the divider.
    final value = r.isRedeal ? '—' : '${lost ? r.score[i] : earned[i]}';
    // With three sides every column is centred and the ♠ follows the points.
    final first = i == 0 && sides == 2;
    final label = r.taker != i || r.isRedeal ? value : (first ? '♠ $value' : '$value ♠');
    return Align(
      alignment: sides > 2 ? Alignment.center : first ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700,
          color: lost ? t.danger : t.teamColor(i),
          decoration: lost ? TextDecoration.lineThrough : null,
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
