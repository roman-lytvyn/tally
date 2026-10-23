import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';
import '../models.dart';

class SetupScreen extends StatelessWidget {
  final AppTheme theme;
  final AppStrings strings;
  final GameRules rules;
  final List<String> teamNames;
  final int players;
  final void Function(int) onPlayersChanged;
  final int scoreLimit;
  final int firstDealer;
  final bool hasSavedGame;
  final void Function(List<String>) onTeamNamesChanged;
  final void Function(int) onScoreLimitChanged;
  final void Function(int) onFirstDealerChanged;
  final VoidCallback onNewGame;
  final VoidCallback onContinue;
  final VoidCallback onSettings;
  final VoidCallback onRules;

  const SetupScreen({
    super.key, required this.theme, required this.strings, this.rules = GameRules.deberc, required this.teamNames,
    this.players = 4, required this.onPlayersChanged,
    required this.scoreLimit, required this.firstDealer, required this.hasSavedGame,
    required this.onTeamNamesChanged, required this.onScoreLimitChanged,
    required this.onFirstDealerChanged, required this.onNewGame,
    required this.onContinue, required this.onSettings, required this.onRules,
  });

  AppTheme get t => theme;
  List<String> get shownNames => strings.namesOrDefaults(teamNames, players);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      body: Container(
        decoration: BoxDecoration(gradient: t.setupGradient),
        child: SafeArea(
          // Scrolls on short screens while the buttons stay pinned to the
          // bottom whenever everything fits.
          child: LayoutBuilder(builder: (context, box) => SingleChildScrollView(
            child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: box.maxHeight),
            child: IntrinsicHeight(
            child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // logo
                Column(children: [
                  Text(strings.appTitle, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800,
                      letterSpacing: -1, color: t.tx)),
                  const SizedBox(height: 4),
                  RichText(text: TextSpan(
                    style: TextStyle(fontSize: 22, letterSpacing: 8, color: t.tx.withValues(alpha: 0.55)),
                    children: const [
                      TextSpan(text: '♠'),
                      TextSpan(text: '♥', style: TextStyle(color: Color(0xFFE05252))),
                      TextSpan(text: '♦', style: TextStyle(color: Color(0xFFE05252))),
                      TextSpan(text: '♣'),
                    ],
                  )),
                ]),
                const SizedBox(height: 24),

                // how many play
                if (rules.playerCounts.length > 1) ...[
                _label(strings.howManyPlay),
                Row(children: [
                  for (final n in rules.playerCounts) ...[
                    if (n != rules.playerCounts.first) const SizedBox(width: 8),
                    Expanded(child: _segBtn(strings.playersOption(n), players == n, -1,
                        () => onPlayersChanged(n), key: ValueKey('players.$n'))),
                  ],
                ]),
                const SizedBox(height: 20),
                ],

                // team or player names
                _label(players == 4 ? strings.teams : strings.players),
                for (var i = 0; i < teamNames.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _TeamInput(key: ValueKey('name.$players.$i'), theme: t, index: i, value: teamNames[i],
                      hint: strings.nameHint(players, i),
                      onChanged: (v) { final n = [...teamNames]; n[i] = v; onTeamNamesChanged(n); }),
                ],
                const SizedBox(height: 20),

                // first dealer
                _label(strings.whoDealsFirst),
                Row(children: [
                  for (var i = 0; i < teamNames.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(child: _segBtn(shownNames[i], firstDealer == i, i, () => onFirstDealerChanged(i))),
                  ],
                ]),
                const SizedBox(height: 20),

                // score limit
                _label(strings.playTo),
                Row(children: [
                  for (final limit in rules.scoreLimits) ...[
                    if (limit != rules.scoreLimits.first) const SizedBox(width: 8),
                    Expanded(child: _segBtn('$limit', scoreLimit == limit, -1, () => onScoreLimitChanged(limit))),
                  ],
                ]),
                const SizedBox(height: 24),

                const Spacer(),

                // buttons
                _ctaBtn(strings.newGame, onNewGame),
                if (hasSavedGame) ...[
                  const SizedBox(height: 9),
                  _ghostBtn(strings.continuePrev, onContinue),
                ],
                const SizedBox(height: 10),
                Wrap(alignment: WrapAlignment.center, children: [
                  TextButton(
                    onPressed: onRules,
                    child: Text(strings.rulesBtn, style: TextStyle(fontSize: 13, color: t.tx2)),
                  ),
                  TextButton(
                    onPressed: onSettings,
                    child: Text(strings.settingsBtn, style: TextStyle(fontSize: 13, color: t.tx2)),
                  ),
                ]),
              ],
            ),
            ),
            ),
            ),
          )),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: t.tx2)),
  );

  Widget _segBtn(String label, bool active, int teamIdx, VoidCallback onTap, {double fontSize = 15, Key? key}) {
    final color = teamIdx >= 0 ? t.teamColor(teamIdx) : t.acc;
    final dim   = teamIdx >= 0 ? t.teamDim(teamIdx)   : t.accDim;
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: active ? dim : Colors.transparent,
          border: Border.all(color: active ? color : t.bdr, width: 1.5),
          borderRadius: BorderRadius.circular(11),
        ),
        alignment: Alignment.center,
        child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: fontSize,
            fontWeight: FontWeight.w600, color: active ? color : t.tx2)),
      ),
    );
  }

  Widget _ctaBtn(String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 17),
      decoration: BoxDecoration(gradient: t.ctaGradient, borderRadius: BorderRadius.circular(15)),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
    ),
  );

  Widget _ghostBtn(String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 17),
      decoration: BoxDecoration(
        border: Border.all(color: t.bdr, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: t.tx2)),
    ),
  );
}

class _TeamInput extends StatefulWidget {
  final AppTheme theme;
  final int index;
  final String value;
  final String hint;
  final void Function(String) onChanged;

  const _TeamInput({
    super.key, required this.theme, required this.index,
    required this.value, required this.hint, required this.onChanged,
  });

  @override
  State<_TeamInput> createState() => _TeamInputState();
}

class _TeamInputState extends State<_TeamInput> {
  late TextEditingController _ctrl;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_TeamInput old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && _ctrl.text != widget.value) {
      _ctrl.text = widget.value;
      _ctrl.selection = TextSelection.collapsed(offset: widget.value.length);
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: t.surf,
        border: Border.all(color: _focused ? t.accBdr : t.bdr, width: 1.5),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(children: [
        Container(
          width: 9, height: 9,
          decoration: BoxDecoration(color: t.teamColor(widget.index), shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Focus(
            onFocusChange: (f) => setState(() => _focused = f),
            child: TextField(
              controller: _ctrl,
              onChanged: widget.onChanged,
              maxLength: 12,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: t.tx),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintText: widget.hint,
                hintStyle: TextStyle(color: t.tx3),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
