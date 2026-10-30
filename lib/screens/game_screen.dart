import 'dart:math' as math;
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
  final GameRules rules;
  final List<String> teamNames;
  final int scoreLimit;
  final int players;
  final bool dealerMustPlay;
  final TieRule tieRule;
  /// Each side's baits so far are shown while bait can be penalised.
  final bool showBaits;
  final List<Round> rounds;
  final Tally tally;
  final String scoreStyle;
  final String valueInput;
  final void Function(Round) onAddRound;
  final void Function(int, Round) onReplaceRound;
  final void Function(int) onRemoveRound;
  final VoidCallback onUndo;
  final VoidCallback onBack;
  final VoidCallback onSettings;

  const GameScreen({
    super.key, required this.theme, required this.strings, required this.rules, required this.teamNames,
    required this.scoreLimit, this.players = 4, required this.dealerMustPlay, required this.tieRule, this.showBaits = false, required this.rounds, required this.tally,
    required this.scoreStyle, this.valueInput = 'counters', required this.onAddRound, required this.onReplaceRound,
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
        // The popup lies over the game, which stays in place underneath.
        child: Stack(children: [
          Column(
            children: [
              _buildHeader(),
              _buildScoreSection(),
              if (!isTraditional) _buildProgressBars(),
              if (widget.tally.held > 0) _buildHeld(),
              Expanded(child: _buildRoundsList()),
              _buildNewRound(),
            ],
          ),
          if (_entryOpen) Positioned.fill(child: _buildEntryPopup(editing)),
        ]),
      ),
    );
  }

  Widget _buildNewRound() => Container(
    decoration: BoxDecoration(border: Border(top: BorderSide(color: t.bdr))),
    padding: const EdgeInsets.fromLTRB(18, 11, 18, 18),
    child: GestureDetector(
      onTap: _openEntry,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(gradient: t.ctaGradient, borderRadius: BorderRadius.circular(14)),
        alignment: Alignment.center,
        child: Text(strings.newRound,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
      ),
    ),
  );

  /// The narrowest the entry panel is laid out; its rows need this much.
  static const double _entryMinWidth = 360;

  /// The panel for entering a deal, at the bottom over a dimmed game. It takes
  /// the height it needs, and on a screen too small for that it shrinks whole,
  /// so it never scrolls.
  Widget _buildEntryPopup(int? editing) => ColoredBox(
    color: Colors.black54,
    child: LayoutBuilder(builder: (context, area) => FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: math.max(area.maxWidth, _entryMinWidth),
        child: EntryPanel(
          key: ValueKey(_session),
          theme: t, strings: strings, rules: widget.rules, teamNames: teamNames, dealer: dealer,
          firstToBid: (dealer + 1) % sides, dealerMustPlay: widget.dealerMustPlay, tieRule: widget.tieRule,
          valueWheel: widget.valueInput == 'wheel',
          initial: editing != null ? rounds[editing] : null,
          number: editing != null ? editing + 1 : null,
          onCancel: _closeEntry,
          onSave: _saveEntry,
          onDelete: editing != null ? _deleteEntry : null,
        ),
      ),
    )),
  );

  Widget _buildHeader() => Container(
    decoration: BoxDecoration(gradient: t.headerGradient),
    padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
    child: Row(children: [
      _iconBtn(strings.exitBtn, widget.onBack),
      Expanded(child: Text(strings.appTitle.toUpperCase(), textAlign: TextAlign.center,
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: t.tx3, letterSpacing: 0.5))),
      if (rounds.isNotEmpty) ...[
        _iconBtn(strings.undoBtn, () { _closeEntry(); widget.onUndo(); }),
        const SizedBox(width: 8),
      ],
      Container(
        height: _buttonHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(22)),
        child: Text('#${rounds.length + 1}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: t.tx2)),
      ),
      const SizedBox(width: 8),
      _iconBtn('⚙', widget.onSettings),
    ]),
  );

  /// The height of the buttons on the top bar, the size of a fingertip.
  static const double _buttonHeight = 44;

  Widget _iconBtn(String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: _buttonHeight,
      constraints: const BoxConstraints(minWidth: _buttonHeight),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: t.tx2)),
    ),
  );

  /// The score in the way picked in the settings.
  Widget _buildScoreSection() => isTraditional ? _buildTraditionalScores() : _buildNumericScores();

  Widget _buildTraditionalScores() => Padding(
    padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
    child: Column(
      children: List.generate(sides, (i) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Row(children: [
              // A long name gives way to the badges beside it.
              Flexible(child: Text(teamNames[i], maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                      letterSpacing: 0.4, color: t.teamColor(i)))),
              const SizedBox(width: 6),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: dealer == i ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(color: t.teamDim(i), borderRadius: BorderRadius.circular(20)),
                  child: Text(strings.deals, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
                      color: t.teamColor(i), letterSpacing: 0.5)),
                ),
              ),
              if (_baitsShown(i)) ...[const SizedBox(width: 6), _baitCount(i)],
            ])),
            _toGo(i),
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
      // Every side gets an equal share of the row; a long name shrinks into it.
      Row(children: List.generate(sides, (i) => Expanded(child: Column(children: [
        FittedBox(fit: BoxFit.scaleDown, child: Text(teamNames[i], maxLines: 1,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                letterSpacing: 0.4, color: t.teamColor(i)))),
        const SizedBox(height: 2),
        FittedBox(fit: BoxFit.scaleDown, child: Row(mainAxisSize: MainAxisSize.min, children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: dealer == i ? 1.0 : 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(color: t.teamDim(i), borderRadius: BorderRadius.circular(20)),
              child: Text(strings.deals, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: t.teamColor(i))),
            ),
          ),
          if (_baitsShown(i)) ...[const SizedBox(width: 4), _baitCount(i)],
        ])),
      ])))),
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

  bool _baitsShown(int i) => widget.showBaits && widget.tally.baits.length > i && widget.tally.baits[i] > 0;

  /// How many baits side [i] has towards the penalty.
  Widget _baitCount(int i) => _badge(strings.baitsSoFar(widget.tally.baits[i]), t.danger, t.dangerDim,
      key: ValueKey('baits.$i'));

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
        for (var i = 0; i < sides; i++) _toGo(i),
      ]),
    ]),
  );

  /// A small label with the points side [i] still needs to reach the target;
  /// nothing once it has.
  Widget _toGo(int i) {
    final left = widget.scoreLimit - scores[i];
    if (left <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: t.teamDim(i), borderRadius: BorderRadius.circular(20)),
      child: Text(strings.toGo(left), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: t.teamColor(i))),
    );
  }

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
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: t.egg)),
    ),
  );

  Widget _buildRoundsList() {
    if (rounds.isEmpty) {
      // Shrinks rather than overflows while the entry panel takes up the space.
      return Center(
        child: FittedBox(fit: BoxFit.scaleDown, child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🃏', style: TextStyle(fontSize: 88)),
          const SizedBox(height: 14),
          Text(strings.noRoundsYet, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: t.tx3)),
          const SizedBox(height: 4),
          Text(strings.tapNewRound, style: TextStyle(fontSize: 15, color: t.tx3)),
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
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? t.accDim : t.surf,
              border: Border.all(color: selected ? t.accBdr : t.bdr),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // The round number and the deal value get slots of the same
                  // width, so the sides' columns stay centred in the row.
                  SizedBox(width: _metaWidth,
                      child: Align(alignment: AlignmentDirectional.centerStart, child: Text('#${index + 1}',
                          style: TextStyle(fontSize: 14, color: t.tx3, fontWeight: FontWeight.w700)))),
                  for (var i = 0; i < sides; i++) ...[
                    if (i > 0) Container(
                        key: ValueKey('divider.$index.$i'),
                        width: 1, color: t.bdr,
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1)),
                    Expanded(child: _roundScore(r, earned, i, index)),
                  ],
                  SizedBox(
                    width: _metaWidth,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
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

  static const double _metaWidth = 76;

  Widget _roundMeta(Round r) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (r.isRedeal) _badge(strings.badgeRedeal, t.tx3, t.surf2),
      if (r.isDeberc) _badge(strings.badgeDeberc, t.acc, t.accDim),
      if (r.isDeberc) const SizedBox(width: 3),
      if (!r.isRedeal && r.contract != null)
        Text('${strings.contractShort(r.contract!)}${r.doubling > 1 ? ' ${strings.doublingMark(r.doubling)}' : ''}',
            style: TextStyle(fontSize: 12, color: t.tx3)),
      if (!r.isRedeal && r.bid != null)
        Text('${strings.bidName(r.bid!)}${r.doubling > 1 ? ' ${strings.doublingMark(r.doubling)}' : ''}',
            style: TextStyle(fontSize: 12, color: t.tx3)),
      if (!r.isRedeal && r.contract == null && r.bid == null)
        Text('${r.gv}${strings.pts}', style: TextStyle(fontSize: 12, color: t.tx3)),
    ],
  );

  Widget _roundScore(Round r, List<int> earned, int i, int index) {
    final baitPenalty = widget.tally.baitPenalties[index][i];
    final noTricksPenalty = widget.tally.noTricksPenalties[index][i];
    // On a tie the trump-taker's own points, when not scored, show crossed out.
    // A deal played in a contract is scored in game points, so what it left
    // hanging stands for its own points.
    final held = r.contract != null ? widget.tally.heldIn[index] : r.score[i];
    final lost = r.isTie && r.taker == i &&
        (r.contract != null ? held > 0 : earned[i] < r.score[i]);
    // The trump-taker's points carry a ♠ on the side facing away from the divider.
    final value = r.isRedeal ? '—' : '${lost ? held : earned[i]}';
    // With three sides every column is centred and the ♠ follows the points.
    final first = i == 0 && sides == 2;
    final taker = r.taker == i && !r.isRedeal;
    // Bait and eggs belong to the side that took the trump, so their marks sit
    // in its column: bait in place of its zero, eggs on the outer side.
    final baited = taker && r.isBaited;
    final eggs = taker && r.isTie;
    final style = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w700,
      color: lost ? t.danger : t.teamColor(i),
      decoration: lost ? TextDecoration.lineThrough : null,
    );
    final points = baited
        ? _badge(strings.badgeBait, t.danger, t.dangerDim, key: ValueKey('bait.$i'))
        : Text(value, style: style);
    final spade = Text('♠', style: style.copyWith(decoration: TextDecoration.none));
    const gap = SizedBox(width: 4);
    final parts = <Widget>[
      points,
      if (taker) ...[gap, spade],
      if (eggs) ...[gap, _badge(strings.badgeEggs, t.egg, t.eggDim, key: ValueKey('eggs.$i'))],
      // Penalties are taken off the side's score, so they follow its points.
      if (baitPenalty > 0)
        ...[gap, _badge('−$baitPenalty', t.danger, t.dangerDim, key: ValueKey('baitPenalty.$index.$i'))],
      if (noTricksPenalty > 0) ...[gap, _badge(strings.badgeNoTricks(noTricksPenalty), t.danger, t.dangerDim,
          key: ValueKey('noTricks.$index.$i'))],
    ];
    return Align(
      alignment: sides > 2 ? Alignment.center : first ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          // The left column reads towards the divider, so its parts run in reverse.
          children: first ? parts.reversed.toList() : parts,
        ),
      ),
    );
  }

  Widget _badge(String text, Color color, Color bg, {Key? key}) => Container(
    key: key,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.4)),
  );
}
