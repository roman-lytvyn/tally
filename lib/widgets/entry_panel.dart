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
  final bool open;
  /// The value of the deal is picked on a scroll wheel instead of counted
  /// up from its declarations.
  final bool valueWheel;
  final Round? initial;
  final int? number;
  final VoidCallback onOpen;
  final VoidCallback onCancel;
  final void Function(Round) onSave;
  final VoidCallback? onDelete;

  const EntryPanel({
    super.key, required this.theme, required this.strings, required this.rules,
    required this.teamNames, required this.dealer, required this.firstToBid,
    required this.dealerMustPlay, required this.tieRule, required this.open,
    this.valueWheel = false, this.initial, this.number,
    required this.onOpen, required this.onCancel, required this.onSave, this.onDelete,
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

  int get _sides => widget.teamNames.length;
  int get _dealer => widget.initial?.dealer ?? widget.dealer;
  int get _gv => _decl.gv;
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
    _startInput(_taker);
    final scored = _scored;
    if (scored != null) {
      _entered = [for (var k = 0; k < _sides - 1; k++) (_taker + k) % _sides];
      _raws = List.generate(_sides, (i) => _entered.contains(i) ? '${scored.score[i]}' : null);
    }
  }

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
      score: [for (final v in _score) v ?? 0], declarations: _decl, keeper: _keptBy);

  bool get _yaytsia => _complete && _round.isTie;

  bool get _baited => _complete && _round.isBaited;

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
        declarations: _decl, keeper: _keptBy));
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
    if (!widget.open) {
      return Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: t.bdr))),
        padding: const EdgeInsets.fromLTRB(18, 11, 18, 18),
        child: _ctaBtn(s.newRound, widget.onOpen),
      );
    }

    final score = _score;

    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: t.bdr))),
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
                    style: TextStyle(fontSize: 12, color: t.tx2, fontWeight: FontWeight.w600)),
                Text(widget.teamNames[_dealer],
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: t.teamColor(_dealer))),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 2, child: _takerColumn()),
            const SizedBox(width: 10),
            Expanded(flex: 3, child: _valueColumn()),
          ]),
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
                    child: Text(':', style: TextStyle(fontSize: 14, color: t.tx3, fontWeight: FontWeight.w700)),
                  ),
                  Expanded(child: _teamInput(i, score[i])),
                ],
              ],
            ),
          ),
          if (_yaytsia) ...[
            const SizedBox(height: 6),
            _hint('🥚', s.eggsMsg(widget.tieRule, score[_taker] ?? 0, _names(_round.opponents)), t.egg, t.eggDim),
          ],
          if (_baited) ...[
            const SizedBox(height: 6),
            _hint('⚠', s.baitMsg(_names(_round.baitTakers), _baitValue), t.danger, t.dangerDim),
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
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    child: Row(children: [
      Text(icon, style: TextStyle(fontSize: 13, color: color)),
      const SizedBox(width: 6),
      Expanded(child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color))),
    ]),
  );

  /// Who took the trump, one side under another, and the way to record a
  /// redeal when the rules allow one.
  Widget _takerColumn() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _columnHeader(Text(s.trumpTakenBy,
          style: TextStyle(fontSize: 12, color: t.tx2, fontWeight: FontWeight.w600))),
      for (var i = 0; i < _sides; i++) ...[
        if (i > 0) const SizedBox(height: _gap),
        SizedBox(key: ValueKey('taker.$i'), height: _rowHeight, child: _sideChip(i, _taker == i, '♠',
            () => setState(() { _taker = i; _startInput(i); }))),
      ],
      if (!widget.dealerMustPlay) ...[
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => widget.onSave(Round.redeal(dealer: _dealer, sides: _sides, gv: widget.rules.cardPoints)),
          child: Text(s.allPassed, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
              color: t.tx2, decoration: TextDecoration.underline, decorationColor: t.tx3)),
        ),
      ],
    ],
  );

  /// The value of the deal: counted up from tierces, fifties and bella, or
  /// picked on a wheel, either way as tall as the side buttons beside it.
  Widget _valueColumn() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _columnHeader(Text(s.dealValue(_gv),
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: t.acc))),
      SizedBox(
        height: _rowHeight * _valueRows + _gap * (_valueRows - 1),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: widget.valueWheel
              ? Container(
                  key: const ValueKey('valueWheel'),
                  decoration: BoxDecoration(color: t.nk, borderRadius: BorderRadius.circular(12)),
                  clipBehavior: Clip.antiAlias,
                  child: _ValueWheel(
                    theme: t, values: widget.rules.dealValues, value: _gv,
                    onChanged: (gv) => setState(() => _decl = Declarations.fromGv(gv, widget.rules)),
                  ),
                )
              : Column(key: const ValueKey('counters'), crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  for (final (i, row) in _declarationRows.indexed) ...[
                    if (i > 0) const SizedBox(height: _gap),
                    Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      for (final (j, k) in row.indexed) ...[
                        if (j > 0) const SizedBox(width: _gap),
                        Expanded(child: k.isSingle ? _toggle(k) : _counter(k)),
                      ],
                    ])),
                  ],
                ]),
        ),
      ),
    ],
  );

  /// The declarations laid out two to a row, in the order the rules give them.
  List<List<DeclarationKind>> get _declarationRows {
    final kinds = widget.rules.declarations;
    return [for (var i = 0; i < kinds.length; i += 2) kinds.sublist(i, i + 2 > kinds.length ? kinds.length : i + 2)];
  }

  /// The value column is as tall as the side buttons, or as the declarations
  /// when there are more rows of them.
  int get _valueRows => _declarationRows.length > _sides ? _declarationRows.length : _sides;

  static const double _rowHeight = 31;
  static const double _gap = 4;

  Widget _columnHeader(Widget child) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: SizedBox(height: 16, child: Align(alignment: Alignment.centerLeft, child: child)),
  );

  /// A label followed by one chip per side, the [selected] one marked.
  Widget _sideRow(String label, int selected, String mark, void Function(int) onSelect) => Row(children: [
    Text(label, style: TextStyle(fontSize: 12, color: t.tx2, fontWeight: FontWeight.w600)),
    const SizedBox(width: 8),
    for (var i = 0; i < widget.teamNames.length; i++) ...[
      if (i > 0) const SizedBox(width: 6),
      Expanded(child: _sideChip(i, selected == i, mark, () => onSelect(i))),
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
              style: TextStyle(fontSize: 13, fontWeight: on ? FontWeight.w800 : FontWeight.w700,
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
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: on ? t.teamColor(i) : t.tx2)),
      ),
    );
  }

  Widget _counter(DeclarationKind k) {
    final count = _decl[k.id];
    final label = s.declaration(k.id);
    final on = count > 0;
    Widget step(String sign, int to, bool enabled) => GestureDetector(
      key: ValueKey('${k.id}.$sign'),
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? () => setState(() => _decl = _decl.withCount(k.id, to)) : null,
      child: SizedBox(width: 22, child: Center(child: Text(sign,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: enabled ? t.tx2 : t.tx3)))),
    );
    return Container(
      decoration: BoxDecoration(
        color: on ? t.accDim : Colors.transparent,
        border: Border.all(color: on ? t.accBdr : t.bdr, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        step('−', count - 1, on),
        Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          FittedBox(fit: BoxFit.scaleDown, child: Text(label, maxLines: 1,
              style: TextStyle(fontSize: 9, height: 1, fontWeight: FontWeight.w700, color: on ? t.acc : t.tx3))),
          const SizedBox(height: 2),
          Text('$count', style: TextStyle(fontSize: 14, height: 1, fontWeight: FontWeight.w800,
              color: on ? t.acc : t.tx2)),
        ])),
        step('+', count + 1, count < k.max),
      ]),
    );
  }

  Widget _toggle(DeclarationKind k) {
    final on = _decl[k.id] > 0;
    return GestureDetector(
      key: ValueKey(k.id),
      onTap: () => setState(() => _decl = _decl.withCount(k.id, on ? 0 : 1)),
      child: Container(
        decoration: BoxDecoration(
          color: on ? t.accDim : Colors.transparent,
          border: Border.all(color: on ? t.accBdr : t.bdr, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text('${on ? '✓ ' : ''}${s.declaration(k.id)}', maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: on ? t.acc : t.tx2)),
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
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.4,
                    color: t.teamColor(idx))),
            const SizedBox(height: 2),
            Text(
              shown != null ? '$shown' : '—',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.1,
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
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      childAspectRatio: 3.2,
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
              child: Text(k, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,
                  color: isDel ? t.danger : t.tx)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _ctaBtn(String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(gradient: t.ctaGradient, borderRadius: BorderRadius.circular(14)),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
    ),
  );

  Widget _ghostBtn(String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.tx2)),
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
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        decoration: BoxDecoration(color: t.dangerDim, borderRadius: BorderRadius.circular(12)),
        child: Icon(Icons.delete_outline, size: 21, color: t.danger),
      ),
    ),
  );

  Widget _baitBtn() => GestureDetector(
    onTap: _bait,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: t.dangerDim,
        border: Border.all(color: t.danger.withValues(alpha: 0.3), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(s.bait, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: t.danger)),
    ),
  );

  Widget _saveBtn() {
    final enabled = _complete || _debercBy != null;
    return GestureDetector(
      onTap: enabled ? _save : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: enabled ? t.ctaGradient : null,
          color: enabled ? null : t.acc.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(s.save,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
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
        itemExtent: 28,
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
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.tx)),
        ),
      ),
    );
  }
}
