import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';
import '../models.dart';
import '../scoring.dart';

/// The bottom panel for entering a new deal or correcting a recorded one.
/// It starts from [initial] when given and is reset by giving it a new key.
class EntryPanel extends StatefulWidget {
  final AppTheme theme;
  final AppStrings strings;
  final GameRules rules;
  final List<String> teamNames;
  final int dealer;
  final int firstToBid;
  final bool dealerMustPlay;
  final TieRule tieRule;
  /// The value of the deal is picked on a scroll wheel instead of counted
  /// up from its declarations.
  final bool valueWheel;
  final Round? initial;
  final int? number;
  final VoidCallback onCancel;
  final void Function(Round) onSave;
  final VoidCallback? onDelete;

  const EntryPanel({
    super.key, required this.theme, required this.strings, required this.rules,
    required this.teamNames, required this.dealer, required this.firstToBid,
    required this.dealerMustPlay, required this.tieRule,
    this.valueWheel = false, this.initial, this.number,
    required this.onCancel, required this.onSave, this.onDelete,
  });

  @override
  State<EntryPanel> createState() => _EntryPanelState();
}

/// Space between a score and the edge of the score row or the colon.
const _scoreGap = 14.0;

class _EntryPanelState extends State<EntryPanel> {
  late Declarations _decl;
  /// What has been typed for each side; null for a side worked out from the rest.
  late List<String?> _raws;
  /// The sides typed in, oldest first. All sides but one are typed and the
  /// last one gets what remains of the deal.
  late List<int> _entered;
  late int _activeInput;
  late int _taker;
  /// The side holding a deberc, when one was declared.
  int? _debercBy;
  /// The side holding what stays with its holder, such as the belote.
  int? _keeper;
  /// The contract of the deal, in a game that has contracts.
  String? _contract;
  /// 1, or 2 when the contract was doubled and 4 when redoubled; in Baloot
  /// also 3, or a [kGahwa].
  late int _doubling;
  /// The bid the deal is played for, in a game with bids.
  int? _bid;

  int get _sides => widget.teamNames.length;
  int get _dealer => widget.initial?.dealer ?? widget.dealer;
  Contract? get _c => Contract.of(_contract);
  int get _gv => (_c?.cardPoints ?? widget.rules.cardPoints) + _decl.value;

  /// How many of the declaration [k] the deal can have.
  int _max(DeclarationKind k) => _c?.allows(k) ?? k.max;

  /// The doublings the deal's contract can be played with.
  List<int> get _doublings => _c?.doublings ?? const [2, 4];

  /// Whether the doublings sit in the contract row, where they are too many
  /// for the column under the sides, as in Baloot.
  bool get _doublingsWithContracts => widget.rules.contracts.any((c) => c.doublings.length > 2);

  (Key, String, bool, VoidCallback) _doublingChoice(int d) => (ValueKey('doubling.$d'), s.doublingName(d),
      _doubling == d, () => setState(() => _doubling = _doubling == d ? 1 : d));

  /// Switches the deal to contract [id], dropping what it does not allow.
  void _setContract(String id) {
    _contract = id;
    if (!_doublings.contains(_doubling)) _doubling = 1;
    _decl = Declarations(widget.rules, {
      for (final k in widget.rules.declarations)
        if (_decl[k.id] > 0 && _max(k) > 0) k.id: _decl[k.id] < _max(k) ? _decl[k.id] : _max(k),
    });
  }
  Round? get _scored {
    final r = widget.initial;
    return r != null && r.isPlayed && !r.isBait ? r : null;
  }

  @override
  void initState() {
    super.initState();
    final r = widget.initial;
    _taker = r?.taker ?? widget.firstToBid;
    _decl = r?.declarationsIn(widget.rules) ?? Declarations(widget.rules);
    _debercBy = r?.deberc;
    _keeper = r?.keeper;
    _contract = r?.contract ?? (widget.rules.hasContracts ? widget.rules.contracts.first.id : null);
    _doubling = r?.doubling ?? 1;
    _bid = r?.bid ?? (widget.rules.hasBids ? widget.rules.bids.first : null);
    _startInput(_firstCounted(_taker));
    final scored = _scored;
    if (scored != null) {
      _entered = [for (var k = 1; k < _sides; k++) (_taker + k) % _sides];
      _raws = List.generate(_sides, (i) => _entered.contains(i) ? '${scored.score[i]}' : null);
    }
  }

  /// The side whose points are typed first when [taker] took the trump: the
  /// one after it, as the taker usually wins the deal and the defenders, who
  /// took fewer cards, count theirs. The taker is the side worked out.
  int _firstCounted(int taker) => (taker + 1) % _sides;

  /// Starts entering the deal again from side [i] alone.
  void _startInput(int i) {
    _raws = List.filled(_sides, null)..[i] = '';
    _entered = [i];
    _activeInput = i;
  }

  /// Moves the input to side [i]; when that would leave no side to work out,
  /// the side typed longest ago becomes the worked-out one.
  void _selectInput(int i) {
    if (!_entered.contains(i)) {
      _entered.add(i);
      _raws[i] = '';
      if (_entered.length > _sides - 1) _raws[_entered.removeAt(0)] = null;
    }
    _activeInput = i;
  }

  void _tap(String k) {
    final raw = _raws[_activeInput] ?? '';
    if (k == '⌫') { setState(() => _raws[_activeInput] = raw.isEmpty ? '' : raw.substring(0, raw.length - 1)); return; }
    if (raw.length >= 3) return;
    setState(() => _raws[_activeInput] = raw + k);
  }

  /// Each side's points, or null for every side while something is missing.
  List<int?> get _score {
    final missing = List<int?>.filled(_sides, null);
    if (_entered.length != _sides - 1 || _entered.any((i) => _raws[i]!.isEmpty)) return missing;
    final typed = [for (final raw in _raws) raw == null ? null : (int.tryParse(raw) ?? 0).clamp(0, _gv)];
    final rest = _gv - typed.fold<int>(0, (sum, v) => sum + (v ?? 0));
    return [for (final v in typed) v ?? rest.clamp(0, _gv)];
  }

  bool get _complete => _score.every((v) => v != null);

  /// Whether something that stays with its holder was declared.
  bool get _hasKept => widget.rules.declarations.any((k) => k.staysWithHolder && _decl[k.id] > 0);

  int? get _keptBy => _hasKept ? _keeper ?? _taker : null;

  Round get _round => Round(gv: _gv, dealer: _dealer, taker: _taker,
      score: [for (final v in _score) v ?? 0], declarations: _decl, keeper: _keptBy,
      contract: _contract, doubling: _doubling, bid: _bid);

  bool get _yaytsia => _complete && _round.isTie;

  bool get _baited => _complete && _round.isBaited;

  /// A doubled deal the contract side won, which it takes whole.
  bool get _doubledWin => _complete && _bid == null && _doubling > 1 && _doubling != kGahwa
      && !_round.isTie && !_round.isBaited;

  /// A gahwa, whose winner wins the match.
  bool get _gahwa => _complete && _doubling == kGahwa;

  /// The points a tied deal leaves hanging.
  int get _hanging => _c != null ? contractScore(_round).held : _score[_taker] ?? 0;

  void _save() {
    if (_debercBy != null) {
      widget.onSave(Round(gv: _gv, dealer: _dealer, taker: _taker, score: List.filled(_sides, 0),
          declarations: _decl, deberc: _debercBy));
      return;
    }
    if (!_complete) return;
    widget.onSave(_round);
  }

  void _bait() {
    widget.onSave(Round(gv: _gv, dealer: _dealer, taker: _taker, score: List.filled(_sides, 0), isBait: true,
        declarations: _decl, keeper: _keptBy, contract: _contract, doubling: _doubling, bid: _bid));
  }

  /// What the opponents taking a lost deal get between them.
  int get _baitValue {
    final earned = scoreRound(_round, tieRule: widget.tieRule);
    return _round.baitTakers.fold(0, (sum, i) => sum + earned[i]);
  }

  String get _keptNames => [
    for (final k in widget.rules.declarations) if (k.staysWithHolder && _decl[k.id] > 0) s.declaration(k.id),
  ].join(', ');

  String _names(Iterable<int> sides) => sides.map((i) => widget.teamNames[i]).join(', ');

  AppTheme get t => widget.theme;
  AppStrings get s => widget.strings;

  @override
  Widget build(BuildContext context) {
    final score = _score;

    return Container(
      decoration: BoxDecoration(
        color: t.bg,
        border: Border(top: BorderSide(color: t.bdr)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // An earlier round names itself and who dealt in it; for a new one the
          // badge above the score already shows who deals.
          if (widget.number != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.editingRound(widget.number!),
                    style: TextStyle(fontSize: 14, color: t.tx2, fontWeight: FontWeight.w600)),
                Text(widget.teamNames[_dealer],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: t.teamColor(_dealer))),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (_wheel) _takerAndWheel() else _takerRow(),
          if (widget.rules.hasContracts) ...[
            const SizedBox(height: _gap),
            _choiceRow([
              for (final c in widget.rules.contracts)
                (ValueKey('contract.${c.id}'), s.contractName(c.id), _contract == c.id,
                    () => setState(() => _setContract(c.id))),
              if (widget.rules.hasDoubling && _doublingsWithContracts)
                for (final d in _doublings) _doublingChoice(d),
            ]),
          ],
          // A contra and a re-contra are said about the contract the taker set.
          if (widget.rules.hasDoubling && !_doublingsWithContracts) ...[
            const SizedBox(height: _gap),
            _choiceRow([for (final d in _doublings) _doublingChoice(d)]),
          ],
          if (_wheel && _bid != null) ...[
            const SizedBox(height: _gap),
            _bidRow(),
          ] else if (!_wheel && (_hasValue || _bid != null)) ...[
            const SizedBox(height: _gap),
            _valueSection(),
          ],
          if (_keptBy != null && _debercBy == null) ...[
            const SizedBox(height: 6),
            _sideRow(s.heldBy(_keptNames), _keptBy!, '✓', (i) => setState(() => _keeper = i)),
          ],
          if (_debercBy != null) ...[
            const SizedBox(height: 6),
            _sideRow(s.debercBy, _debercBy!, '✦', (i) => setState(() => _debercBy = i)),
            const SizedBox(height: 6),
            _hint('✦', s.debercWins(widget.teamNames[_debercBy!]), t.acc, t.accDim),
          ] else ...[
          const SizedBox(height: 8),
          // score input row
          Container(
            decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(13)),
            padding: const EdgeInsets.symmetric(horizontal: _scoreGap, vertical: 9),
            child: Row(
              children: [
                for (var i = 0; i < _sides; i++) ...[
                  // The colon keeps the highlighted side as far away as the row's edges do.
                  if (i > 0) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _scoreGap),
                    child: Text(':', style: TextStyle(fontSize: 18, color: t.tx3, fontWeight: FontWeight.w700)),
                  ),
                  Expanded(child: _teamInput(i, score[i])),
                ],
              ],
            ),
          ),
          if (_yaytsia) ...[
            const SizedBox(height: 6),
            _hint('🥚', s.eggsMsg(widget.tieRule, _hanging, _names(_round.opponents)), t.egg, t.eggDim),
          ],
          if (_baited) ...[
            const SizedBox(height: 6),
            _hint('⚠', s.baitMsg(_names(_round.baitTakers), _baitValue), t.danger, t.dangerDim),
          ],
          if (_doubledWin) ...[
            const SizedBox(height: 6),
            _hint(s.doublingMark(_doubling), s.takesAllMsg(widget.teamNames[_taker], scoreRound(_round)[_taker]),
                t.acc, t.accDim),
          ],
          if (_gahwa) ...[
            const SizedBox(height: 6),
            _hint(s.doublingMark(_doubling), s.gahwaWins(widget.teamNames[_round.countedWinner]), t.acc, t.accDim),
          ],
          // Card points are entered, so a deal scored in game points, or
          // with its bid added, shows what it adds to the score.
          if ((_c != null || _bid != null) && _complete && !_yaytsia && !_baited && !_doubledWin && !_gahwa) ...[
            const SizedBox(height: 6),
            _hint('=', s.recordedMsg(scoreRound(_round)), t.acc, t.accDim),
          ],
          ],
          const SizedBox(height: 8),
          // The keypad stays in place while a deberc is recorded, so the
          // Deberc key beside 0 can switch it off again.
          _buildNumpad(),
          const SizedBox(height: 8),
          // actions
          Row(children: [
            _ghostBtn(s.cancel, widget.onCancel),
            if (widget.onDelete != null) ...[
              const SizedBox(width: 6),
              _deleteBtn(),
            ],
            // With three players it is the points that tell which opponent
            // takes the deal, so bait cannot be recorded without them.
            if (_debercBy == null && _sides == 2) ...[
              const SizedBox(width: 6),
              _baitBtn(),
            ],
            const SizedBox(width: 6),
            Expanded(child: _saveBtn()),
          ]),
        ],
      ),
    );
  }

  Widget _hint(String icon, String text, Color color, Color bg) => Container(
    decoration: BoxDecoration(color: bg,
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    child: Row(children: [
      Text(icon, style: TextStyle(fontSize: 15, color: color)),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color))),
    ]),
  );

  /// What the sides below are picked for, and the way to record a redeal
  /// when the rules allow one.
  Widget _takerHeader() => SizedBox(
        height: _headerHeight,
        child: Row(children: [
          Text(s.trumpTakenBy, style: TextStyle(fontSize: 14, color: t.tx2, fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          if (!widget.dealerMustPlay)
            Expanded(child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _redealBtn(),
            )),
        ]),
      );

  Widget _redealBtn() => GestureDetector(
    key: const ValueKey('redeal'),
    onTap: () => widget.onSave(Round.redeal(dealer: _dealer, sides: _sides, gv: widget.rules.cardPoints)),
    child: Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: t.surf,
        border: Border.all(color: t.bdr, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.refresh, size: 16, color: t.tx2),
        const SizedBox(width: 4),
        Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(s.allPassed, maxLines: 1,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: t.tx)))),
      ]),
    ),
  );

  void _pickTaker(int i) => setState(() { _taker = i; _startInput(_firstCounted(i)); });

  /// Who took the trump, the sides next to each other.
  Widget _takerRow() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _takerHeader(),
      const SizedBox(height: 4),
      SizedBox(
        height: _rowHeight,
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (var i = 0; i < _sides; i++) ...[
            if (i > 0) const SizedBox(width: _gap),
            Expanded(key: ValueKey('taker.$i'), child: _sideChip(i, _taker == i, '♠', () => _pickTaker(i))),
          ],
        ]),
      ),
    ],
  );

  /// Who took the trump, the sides one under another in a column wide enough
  /// for long names, beside the wheel the value of the deal is picked on.
  Widget _takerAndWheel() => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _takerHeader(),
      for (var i = 0; i < _sides; i++) ...[
        SizedBox(height: i == 0 ? 4 : _gap),
        SizedBox(key: ValueKey('taker.$i'), height: _rowHeight,
            child: _sideChip(i, _taker == i, '♠', () => _pickTaker(i))),
      ],
    ])),
    const SizedBox(width: _gap),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SizedBox(height: _headerHeight, child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: Text(s.dealValue(_gv),
          key: const ValueKey('dealValue'), maxLines: 1,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: t.acc))))),
      const SizedBox(height: 4),
      Container(
        key: const ValueKey('valueWheel'),
        height: _sides * _rowHeight + (_sides - 1) * _gap,
        decoration: BoxDecoration(color: t.nk, borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: _ValueWheel(
          theme: t, values: widget.rules.dealValues, value: _gv,
          onChanged: (gv) => setState(() => _decl = Declarations.fromGv(gv, widget.rules)),
        ),
      ),
    ])),
  ]);

  /// The value is picked on a wheel instead of counted up from declarations.
  bool get _wheel => widget.valueWheel && !widget.rules.hasContracts;

  /// Whether the deal has a value of its own to set: declarations, or the wheel.
  bool get _hasValue => _wheel || widget.rules.declarations.isNotEmpty;

  /// The declarations the deal's contract allows, in the order the rules give them.
  List<DeclarationKind> get _allowed => [for (final k in widget.rules.declarations) if (_max(k) > 0) k];

  /// The value of the deal with the bid it is played for, then the
  /// declarations that make the value up.
  Widget _valueSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (_bid != null)
        SizedBox(
          height: _rowHeight,
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (_hasValue) ...[
              Expanded(child: _valueLabel()),
              const SizedBox(width: _gap),
            ],
            Expanded(child: _bidRow()),
          ]),
        )
      else
        SizedBox(height: 30, child: _valueLabel()),
      if (_allowed.isNotEmpty) ...[
        const SizedBox(height: _gap),
        _declarationGrid(),
      ],
    ],
  );

  /// The declarations caption, and the value of the deal.
  Widget _valueLabel() => Row(children: [
    Expanded(child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Text(s.declarations, maxLines: 1,
          style: TextStyle(fontSize: 14, color: t.tx2, fontWeight: FontWeight.w600)),
    )),
    const SizedBox(width: 8),
    Text(s.dealValue(_gv), key: const ValueKey('dealValue'), maxLines: 1,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: t.acc)),
  ]);

  /// The declarations the deal can have, two to a row, or three when there are
  /// so many that two would push the keypad off a phone.
  Widget _declarationGrid() {
    final kinds = _allowed;
    final perRow = kinds.length > 4 ? 3 : 2;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (var i = 0; i < kinds.length; i += perRow) ...[
        if (i > 0) const SizedBox(height: _gap),
        SizedBox(
          // The border is drawn inside, so the cell is taller by its width.
          height: _rowHeight + 3,
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            for (var j = i; j < i + perRow; j++) ...[
              if (j > i) const SizedBox(width: _gap),
              Expanded(child: j < kinds.length ? _declaration(kinds[j]) : const SizedBox()),
            ],
          ]),
        ),
      ],
    ]);
  }

  /// A declaration: a tap adds one more, up to as many as the deal can have.
  /// One that can be declared only once is taken back with another tap, the
  /// others with the minus beside the count.
  Widget _declaration(DeclarationKind k) {
    final count = _decl[k.id];
    final on = count > 0;
    final once = _max(k) == 1;
    final color = on ? t.acc : t.tx2;
    void set(int to) => setState(() => _decl = _decl.withCount(k.id, to));
    return Container(
      decoration: BoxDecoration(
        color: on ? t.accDim : Colors.transparent,
        border: Border.all(color: on ? t.accBdr : t.bdr, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: GestureDetector(
          key: ValueKey(once ? k.id : '${k.id}.+'),
          behavior: HitTestBehavior.opaque,
          onTap: once ? () => set(on ? 0 : 1) : count < _max(k) ? () => set(count + 1) : null,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12, end: 10),
            child: Row(children: [
              Expanded(child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(s.declaration(k.id), maxLines: 1,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
              )),
              const SizedBox(width: 6),
              if (once)
                Icon(on ? Icons.check_circle : Icons.circle_outlined, size: 22, color: on ? t.acc : t.tx3)
              else if (on)
                Text('$count', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color))
              else
                Icon(Icons.add, size: 22, color: t.tx3),
            ]),
          ),
        )),
        if (!once && on)
          GestureDetector(
            key: ValueKey('${k.id}.−'),
            behavior: HitTestBehavior.opaque,
            onTap: () => set(count - 1),
            child: Container(
              width: 44,
              decoration: BoxDecoration(border: BorderDirectional(start: BorderSide(color: t.accBdr))),
              alignment: Alignment.center,
              child: Text('−', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: t.tx)),
            ),
          ),
      ]),
    );
  }

  /// The bid of the deal, stepped through the bids the game allows.
  Widget _bidRow() {
    final bids = widget.rules.bids;
    final at = bids.indexOf(_bid!);
    Widget step(String sign, int to) {
      final enabled = to >= 0 && to < bids.length;
      return GestureDetector(
        key: ValueKey('bid.$sign'),
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => setState(() => _bid = bids[to]) : null,
        child: SizedBox(width: 44, child: Center(child: Text(sign,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: enabled ? t.tx2 : t.tx3)))),
      );
    }
    return Container(
      height: _rowHeight,
      decoration: BoxDecoration(
        color: t.accDim,
        border: Border.all(color: t.accBdr, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        step('−', at - 1),
        Expanded(child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: Text('${s.bid}: ${s.bidName(_bid!)}',
            key: const ValueKey('bid'), maxLines: 1,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: t.acc))))),
        step('+', at + 1),
      ]),
    );
  }

  /// Options side by side, the selected ones marked.
  Widget _choiceRow(List<(Key, String, bool, VoidCallback)> options) => SizedBox(
    height: _rowHeight,
    child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final (i, (key, label, on, onTap)) in options.indexed) ...[
        if (i > 0) const SizedBox(width: _gap),
        Expanded(child: GestureDetector(
          key: key,
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: on ? t.accDim : Colors.transparent,
              border: Border.all(color: on ? t.accBdr : t.bdr, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FittedBox(fit: BoxFit.scaleDown, child: Text(label, maxLines: 1,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: on ? t.acc : t.tx2))),
          ),
        )),
      ],
    ]),
  );

  static const double _rowHeight = 46;
  static const double _headerHeight = 40;
  static const double _gap = 6;

  /// A label followed by one chip per side, the [selected] one marked.
  Widget _sideRow(String label, int selected, String mark, void Function(int) onSelect) => Row(children: [
    Text(label, style: TextStyle(fontSize: 14, color: t.tx2, fontWeight: FontWeight.w600)),
    const SizedBox(width: 8),
    for (var i = 0; i < widget.teamNames.length; i++) ...[
      if (i > 0) const SizedBox(width: _gap),
      Expanded(child: SizedBox(height: 40, child: _sideChip(i, selected == i, mark, () => onSelect(i)))),
    ],
  ]);

  Widget _debercKey() {
    final on = _debercBy != null;
    return GestureDetector(
      key: const ValueKey('deberc'),
      onTap: () => setState(() => _debercBy = on ? null : _taker),
      // Once pressed the key looks like the win it stands for.
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: on ? t.ctaGradient : null,
          color: on ? null : t.nk,
          borderRadius: BorderRadius.circular(10),
          boxShadow: on ? [BoxShadow(color: t.acc.withValues(alpha: 0.45), blurRadius: 10)] : null,
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('${on ? '🏆 ' : '✦ '}${s.deberc}', maxLines: 1,
              style: TextStyle(fontSize: 15, fontWeight: on ? FontWeight.w800 : FontWeight.w700,
                  color: on ? const Color(0xFF111111) : t.tx2)),
        ),
      ),
    );
  }

  Widget _sideChip(int i, bool on, String mark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: on ? t.teamDim(i) : Colors.transparent,
          border: Border.all(color: on ? t.teamColor(i) : t.bdr, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text('${on ? '$mark ' : ''}${widget.teamNames[i]}', maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: on ? t.teamColor(i) : t.tx2)),
      ),
    );
  }

  Widget _teamInput(int idx, int? val) {
    final active = _activeInput == idx;
    final raw = _raws[idx];
    final typed = raw != null;
    // A typed side shows what was typed even before the deal adds up.
    final shown = !typed ? val : raw.isEmpty ? null : (int.tryParse(raw) ?? 0).clamp(0, _gv);
    return GestureDetector(
      key: ValueKey('score.$idx'),
      onTap: () { if (!active) setState(() => _selectInput(idx)); },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: active ? t.surf2 : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          children: [
            Text(widget.teamNames[idx],
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.4,
                    color: t.teamColor(idx))),
            const SizedBox(height: 2),
            Text(
              shown != null ? '$shown' : '—',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, height: 1.1,
                  color: shown != null ? t.tx : t.tx3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    const keys = ['1','2','3','4','5','6','7','8','9','','0','⌫'];
    // Points are not typed while a deberc is recorded.
    final typing = _debercBy == null;
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: _gap, crossAxisSpacing: _gap, mainAxisExtent: _rowHeight),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: keys.map((k) {
        if (k.isEmpty) return widget.rules.hasDebercWin ? _debercKey() : const SizedBox();
        final isDel = k == '⌫';
        return GestureDetector(
          onTap: typing ? () => _tap(k) : null,
          child: Opacity(
            opacity: typing ? 1 : 0.35,
            child: Container(
              decoration: BoxDecoration(
                color: isDel ? t.nkDel : t.nk,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(k, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600,
                  color: isDel ? t.danger : t.tx)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _ghostBtn(String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: _rowHeight,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: t.tx2)),
    ),
  );

  /// Deletes the round only once the player confirms, since its points leave the score.
  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: t.bg2,
        title: Text(s.deleteRoundTitle(widget.number ?? 0),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: t.tx)),
        content: Text(s.deleteRoundDesc, style: TextStyle(fontSize: 14, color: t.tx2)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(s.cancel, style: TextStyle(fontWeight: FontWeight.w600, color: t.tx2)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(s.delete, style: TextStyle(fontWeight: FontWeight.w800, color: t.danger)),
          ),
        ],
      ),
    );
    if (confirmed == true) widget.onDelete?.call();
  }

  /// A trash can rather than a word, so an edited round's buttons fit a narrow phone.
  Widget _deleteBtn() => Tooltip(
    message: s.delete,
    child: GestureDetector(
      key: const ValueKey('delete'),
      onTap: _confirmDelete,
      child: Container(
        height: _rowHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: t.dangerDim, borderRadius: BorderRadius.circular(12)),
        child: Icon(Icons.delete_outline, size: 23, color: t.danger),
      ),
    ),
  );

  Widget _baitBtn() => GestureDetector(
    onTap: _bait,
    child: Container(
      height: _rowHeight,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: t.dangerDim,
        border: Border.all(color: t.danger.withValues(alpha: 0.3), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(s.bait, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: t.danger)),
    ),
  );

  Widget _saveBtn() {
    final enabled = _complete || _debercBy != null;
    return GestureDetector(
      onTap: enabled ? _save : null,
      child: Container(
        height: _rowHeight,
        decoration: BoxDecoration(
          gradient: enabled ? t.ctaGradient : null,
          color: enabled ? null : t.acc.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(s.save,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                color: enabled ? const Color(0xFF111111) : t.tx3)),
      ),
    );
  }
}

/// A scroll wheel of the values a deal can have. Spinning it up raises the
/// value.
class _ValueWheel extends StatefulWidget {
  final AppTheme theme;
  /// The values to pick from, lowest first.
  final List<int> values;
  final int value;
  final void Function(int) onChanged;

  const _ValueWheel({required this.theme, required this.values, required this.value, required this.onChanged});

  @override
  State<_ValueWheel> createState() => _ValueWheelState();
}

class _ValueWheelState extends State<_ValueWheel> {
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
        initialItem: widget.values.indexOf(widget.value).clamp(0, widget.values.length - 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return ScrollConfiguration(
      // A mouse drags the wheel as a finger does.
      behavior: ScrollConfiguration.of(context).copyWith(dragDevices: PointerDeviceKind.values.toSet()),
      child: CupertinoPicker.builder(
        scrollController: _controller,
        itemExtent: 44,
        childCount: widget.values.length,
        selectionOverlay: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: t.accDim,
            border: Border.all(color: t.accBdr, width: 1.5),
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        onSelectedItemChanged: (i) => widget.onChanged(widget.values[i]),
        itemBuilder: (context, i) => Center(
          child: Text('${widget.values[i]}',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: t.tx)),
        ),
      ),
    );
  }
}
