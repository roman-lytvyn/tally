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
  final bool open;
  final Round? initial;
  final int? number;
  final VoidCallback onOpen;
  final VoidCallback onCancel;
  final void Function(Round) onSave;
  final VoidCallback? onDelete;

  const EntryPanel({
    super.key, required this.theme, required this.strings,
    required this.teamNames, required this.dealer, required this.firstToBid,
    required this.dealerMustPlay, required this.open,
    this.initial, this.number,
    required this.onOpen, required this.onCancel, required this.onSave, this.onDelete,
  });

  @override
  State<EntryPanel> createState() => _EntryPanelState();
}

class _EntryPanelState extends State<EntryPanel> {
  int _gv = 162;
  String _raw = '';
  late int _activeInput;
  late int _taker;

  int get _dealer => widget.initial?.dealer ?? widget.dealer;

  @override
  void initState() {
    super.initState();
    final r = widget.initial;
    _taker = r?.taker ?? widget.firstToBid;
    _activeInput = _taker;
    if (r != null) {
      _gv = r.gv;
      if (!r.isBait) _raw = '${r.score[_taker]}';
    }
  }

  void _tap(String k) {
    if (k == '⌫') { setState(() => _raw = _raw.isEmpty ? '' : _raw.substring(0, _raw.length - 1)); return; }
    if (_raw.length >= 3) return;
    setState(() => _raw = _raw + k);
  }

  int? get _parsed {
    if (_raw.isEmpty) return null;
    final v = int.tryParse(_raw) ?? 0;
    return v.clamp(0, _gv);
  }

  List<int?> get _score {
    final p = _parsed;
    if (p == null) return [null, null];
    return _activeInput == 0 ? [p, (_gv - p).clamp(0, _gv)] : [(_gv - p).clamp(0, _gv), p];
  }

  bool get _yaytsia {
    final s = _score;
    return _parsed != null && s[0] != null && s[1] != null && s[0] == s[1];
  }

  bool get _baited {
    final s = _score;
    return _parsed != null && s[_taker]! < s[1 - _taker]!;
  }

  void _save() {
    if (_parsed == null) return;
    final s = _score;
    widget.onSave(Round(gv: _gv, dealer: _dealer, taker: _taker, score: [s[0] ?? 0, s[1] ?? 0]));
  }

  void _bait() {
    widget.onSave(Round(gv: _gv, dealer: _dealer, taker: _taker, score: const [0, 0], isBait: true));
  }

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
    final parsed = _parsed;
    final gvs = kGV.contains(_gv) ? kGV : ([...kGV, _gv]..sort());

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
          if (widget.dealerMustPlay) ...[
            const SizedBox(height: 3),
            Text(s.dealerPlaysIfAllPass, style: TextStyle(fontSize: 10, color: t.tx3)),
          ],
          const SizedBox(height: 8),
          // GV selector
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: gvs.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final v = gvs[i];
                final on = _gv == v;
                return GestureDetector(
                  onTap: () => setState(() { _gv = v; _raw = ''; }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    decoration: BoxDecoration(
                      color: on ? t.accDim : Colors.transparent,
                      border: Border.all(color: on ? t.accBdr : t.bdr, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$v', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                        color: on ? t.acc : t.tx2)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // score input row
          Container(
            decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(13)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              children: [
                Expanded(child: _teamInput(0, score[0])),
                Text(':', style: TextStyle(fontSize: 14, color: t.tx3, fontWeight: FontWeight.w700)),
                Expanded(child: _teamInput(1, score[1])),
              ],
            ),
          ),
          if (_yaytsia && parsed != null) ...[
            const SizedBox(height: 6),
            _hint('🥚', s.eggsMsg(score[0] ?? 0, score[1] ?? 0), t.egg, t.eggDim),
          ],
          if (_baited) ...[
            const SizedBox(height: 6),
            _hint('⚠', s.baitMsg(widget.teamNames[1 - _taker], _gv), t.danger, t.dangerDim),
          ],
          const SizedBox(height: 8),
          // numpad
          _buildNumpad(),
          const SizedBox(height: 8),
          // actions
          Row(children: [
            _ghostBtn(s.cancel, widget.onCancel),
            if (widget.onDelete != null) ...[
              const SizedBox(width: 6),
              _deleteBtn(),
            ],
            const SizedBox(width: 6),
            _baitBtn(),
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

  Widget _takerRow() => Row(children: [
    Text(s.trumpTakenBy, style: TextStyle(fontSize: 12, color: t.tx2, fontWeight: FontWeight.w600)),
    const SizedBox(width: 8),
    for (var i = 0; i < widget.teamNames.length; i++) ...[
      if (i > 0) const SizedBox(width: 6),
      Expanded(child: _takerChip(i)),
    ],
  ]);

  Widget _takerChip(int i) {
    final on = _taker == i;
    return GestureDetector(
      onTap: () => setState(() { _taker = i; _activeInput = i; _raw = ''; }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: on ? t.teamDim(i) : Colors.transparent,
          border: Border.all(color: on ? t.teamColor(i) : t.bdr, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text('${on ? '♠ ' : ''}${widget.teamNames[i]}', maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: on ? t.teamColor(i) : t.tx2)),
      ),
    );
  }

  Widget _teamInput(int idx, int? val) {
    final active = _activeInput == idx;
    return GestureDetector(
      onTap: () { if (!active) setState(() { _activeInput = idx; _raw = ''; }); },
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
              val != null ? '$val' : '—',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.1,
                  color: val != null ? t.tx : t.tx3),
            ),
            const SizedBox(height: 1),
            Text(active ? s.inputting : s.auto,
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.3,
                    color: active ? t.teamColor(idx) : t.tx3)),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    const keys = ['1','2','3','4','5','6','7','8','9','','0','⌫'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      childAspectRatio: 3.2,
      children: keys.map((k) {
        if (k.isEmpty) return const SizedBox();
        final isDel = k == '⌫';
        return GestureDetector(
          onTap: () => _tap(k),
          child: Container(
            decoration: BoxDecoration(
              color: isDel ? t.nkDel : t.nk,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(k, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,
                color: isDel ? t.danger : t.tx)),
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
    final enabled = _parsed != null;
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
