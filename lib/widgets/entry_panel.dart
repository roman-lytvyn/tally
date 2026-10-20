import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';
import '../models.dart';

/// The bottom panel for entering a new deal or correcting a recorded one.
/// It starts from [initial] when given and is reset by giving it a new key.
class EntryPanel extends StatefulWidget {
  final AppTheme theme;
  final AppStrings strings;
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
    super.key, required this.theme, required this.strings,
    required this.teamNames, required this.dealer, required this.firstToBid,
    required this.dealerMustPlay, required this.tieRule, required this.open,
    this.valueWheel = false, this.initial, this.number,
    required this.onOpen, required this.onCancel, required this.onSave, this.onDelete,
  });

  @override
  State<EntryPanel> createState() => _EntryPanelState();
}

class _EntryPanelState extends State<EntryPanel> {
  Declarations _decl = const Declarations();
  /// What has been typed for each side; null for a side worked out from the rest.
  late List<String?> _raws;
  /// The sides typed in, oldest first. All sides but one are typed and the
  /// last one gets what remains of the deal.
  late List<int> _entered;
  late int _activeInput;
  late int _taker;
  /// The side holding a deberc, when one was declared.
  int? _debercBy;

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
    _decl = r?.declarations ?? const Declarations();
    _debercBy = r?.deberc;
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

  Round get _round => Round(gv: _gv, dealer: _dealer, taker: _taker,
      score: [for (final v in _score) v ?? 0], declarations: _decl);

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
        declarations: _decl));
  }

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
          // dealer row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.number != null ? s.editingRound(widget.number!) : s.dealsNow,
                  style: TextStyle(fontSize: 12, color: t.tx2, fontWeight: FontWeight.w600)),
              Text(widget.teamNames[_dealer],
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: t.teamColor(_dealer))),
            ],
          ),
          const SizedBox(height: 8),
          _takerRow(),
          const SizedBox(height: 6),
          widget.dealerMustPlay
              ? Text(s.dealerPlaysIfAllPass, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: t.tx3))
              : Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => widget.onSave(Round.redeal(dealer: _dealer, sides: _sides)),
                    child: Text(s.allPassed, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                        color: t.tx2, decoration: TextDecoration.underline, decorationColor: t.tx3)),
                  ),
                ),
          const SizedBox(height: 8),
          _declarationsRow(),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              children: [
                for (var i = 0; i < _sides; i++) ...[
                  if (i > 0) Text(':', style: TextStyle(fontSize: 14, color: t.tx3, fontWeight: FontWeight.w700)),
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
            _hint('⚠', s.baitMsg(_names(_round.baitTakers), _gv), t.danger, t.dangerDim),
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

  Widget _takerRow() => _sideRow(s.trumpTakenBy, _taker, '♠',
      (i) => setState(() { _taker = i; _startInput(i); }));

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
      child: Container(
        decoration: BoxDecoration(
          color: on ? t.accDim : t.nk,
          border: Border.all(color: on ? t.accBdr : Colors.transparent, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('${on ? '✓ ' : '✦ '}${s.deberc}', maxLines: 1,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: on ? t.acc : t.tx2)),
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

  /// The declarations made in the deal, which together with the 162 points
  /// of the cards make up its value.
  Widget _declarationsRow() => widget.valueWheel ? _valueWheelRow() : Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(s.declarations, style: TextStyle(fontSize: 12, color: t.tx2, fontWeight: FontWeight.w600)),
          Text(s.dealValue(_gv), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: t.acc)),
        ],
      ),
      const SizedBox(height: 5),
      Row(children: [
        Expanded(child: _counter('tierce', s.tierce, _decl.tierces,
            (n) => _decl.copyWith(tierces: n))),
        const SizedBox(width: 6),
        Expanded(child: _counter('fifty', s.fifty, _decl.fifties,
            (n) => _decl.copyWith(fifties: n))),
        const SizedBox(width: 6),
        Expanded(child: _bellaChip()),
      ]),
    ],
  );

  /// The value of the deal picked straight from every value it can have.
  Widget _valueWheelRow() => Row(children: [
    Expanded(child: Text(s.declarations,
        style: TextStyle(fontSize: 12, color: t.tx2, fontWeight: FontWeight.w600))),
    Container(
      width: 140, height: 84,
      decoration: BoxDecoration(color: t.nk, borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: _ValueWheel(
        theme: t, value: _gv,
        onChanged: (gv) => setState(() => _decl = Declarations.fromGv(gv)),
      ),
    ),
  ]);

  Widget _counter(String id, String label, int count, Declarations Function(int) change) {
    final on = count > 0;
    Widget step(String sign, int to, bool enabled) => GestureDetector(
      key: ValueKey('$id.$sign'),
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? () => setState(() => _decl = change(to)) : null,
      child: SizedBox(width: 26, height: 30, child: Center(child: Text(sign,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: enabled ? t.tx2 : t.tx3)))),
    );
    return Container(
      decoration: BoxDecoration(
        color: on ? t.accDim : Colors.transparent,
        border: Border.all(color: on ? t.accBdr : t.bdr, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        step('−', count - 1, on),
        Expanded(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: on ? t.acc : t.tx3)),
          Text('$count', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: on ? t.acc : t.tx2)),
        ])),
        step('+', count + 1, count < 9),
      ]),
    );
  }

  Widget _bellaChip() {
    final on = _decl.bella;
    return GestureDetector(
      key: const ValueKey('bella'),
      onTap: () => setState(() => _decl = _decl.copyWith(bella: !on)),
      child: Container(
        height: 33,
        decoration: BoxDecoration(
          color: on ? t.accDim : Colors.transparent,
          border: Border.all(color: on ? t.accBdr : t.bdr, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text('${on ? '✓ ' : ''}${s.bella}', maxLines: 1, overflow: TextOverflow.ellipsis,
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
            const SizedBox(height: 1),
            Text(active ? s.inputting : typed ? ' ' : s.auto,
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.3,
                    color: active ? t.teamColor(idx) : t.tx3)),
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
        if (k.isEmpty) return _debercKey();
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

  Widget _deleteBtn() => GestureDetector(
    onTap: widget.onDelete,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(color: t.dangerDim, borderRadius: BorderRadius.circular(12)),
      child: Text(s.delete, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: t.danger)),
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
  final int value;
  final void Function(int) onChanged;

  const _ValueWheel({required this.theme, required this.value, required this.onChanged});

  @override
  State<_ValueWheel> createState() => _ValueWheelState();
}

class _ValueWheelState extends State<_ValueWheel> {
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
        initialItem: kDealValues.indexOf(widget.value).clamp(0, kDealValues.length - 1));
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
        childCount: kDealValues.length,
        selectionOverlay: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: t.accDim,
            border: Border.all(color: t.accBdr, width: 1.5),
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        onSelectedItemChanged: (i) => widget.onChanged(kDealValues[i]),
        itemBuilder: (context, i) => Center(
          child: Text('${kDealValues[i]}',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.tx)),
        ),
      ),
    );
  }
}
