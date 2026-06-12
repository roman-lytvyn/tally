import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';
import '../models.dart';

class EntryPanel extends StatefulWidget {
  final AppTheme theme;
  final AppStrings strings;
  final List<String> teamNames;
  final int dealer;
  final void Function(Round) onSave;

  const EntryPanel({
    super.key, required this.theme, required this.strings,
    required this.teamNames, required this.dealer, required this.onSave,
  });

  @override
  State<EntryPanel> createState() => _EntryPanelState();
}

class _EntryPanelState extends State<EntryPanel> {
  bool _open = false;
  int _gv = 162;
  String _raw = '';
  late int _activeInput;

  @override
  void initState() {
    super.initState();
    _activeInput = widget.dealer;
  }

  void _openPanel() {
    setState(() { _open = true; _activeInput = widget.dealer; _raw = ''; _gv = 162; });
  }

  void _cancel() => setState(() { _open = false; _raw = ''; });

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

  void _save() {
    final p = _parsed;
    if (p == null) return;
    final s = _score;
    final earned = [s[0] ?? 0, s[1] ?? 0];
    widget.onSave(Round(gv: _gv, dealer: widget.dealer, score: [s[0] ?? 0, s[1] ?? 0],
        fell: false, yaytsia: _yaytsia, isBait: false, earned: earned));
    _cancel();
  }

  void _bait() {
    final earned = [0, 0];
    earned[1 - widget.dealer] = _gv;
    widget.onSave(Round(gv: _gv, dealer: widget.dealer, score: [0, 0],
        fell: false, yaytsia: false, isBait: true, earned: earned));
    _cancel();
  }

  AppTheme get t => widget.theme;
  AppStrings get s => widget.strings;

  @override
  Widget build(BuildContext context) {
    if (!_open) {
      return Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: t.bdr))),
        padding: const EdgeInsets.fromLTRB(18, 11, 18, 18),
        child: _ctaBtn(s.newRound, _openPanel),
      );
    }

    final score = _score;
    final parsed = _parsed;

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
              Text(s.dealsNow, style: TextStyle(fontSize: 12, color: t.tx2, fontWeight: FontWeight.w600)),
              Text(widget.teamNames[widget.dealer],
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: t.teamColor(widget.dealer))),
            ],
          ),
          const SizedBox(height: 8),
          // GV selector
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kGV.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final v = kGV[i];
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
            Container(
              decoration: BoxDecoration(color: t.eggDim,
                  border: Border.all(color: t.egg.withValues(alpha: 0.25)),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              child: Row(children: [
                const Text('🥚', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 6),
                Expanded(child: Text(s.eggsMsg(score[0] ?? 0, score[1] ?? 0),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: t.egg))),
              ]),
            ),
          ],
          const SizedBox(height: 8),
          // numpad
          _buildNumpad(),
          const SizedBox(height: 8),
          // actions
          Row(children: [
            _ghostBtn(s.cancel, _cancel),
            const SizedBox(width: 6),
            _baitBtn(),
            const SizedBox(width: 6),
            Expanded(child: _saveBtn()),
          ]),
        ],
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

  Widget _baitBtn() => GestureDetector(
    onTap: _bait,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: t.t1.withValues(alpha: 0.13),
        border: Border.all(color: t.t1.withValues(alpha: 0.3), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(s.bait, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: t.t1)),
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
