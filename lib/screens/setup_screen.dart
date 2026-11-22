import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';
import '../layout.dart';
import '../models.dart';
import '../widgets/welcome_panel.dart';

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

  /// Below this window height the landscape form is laid out tightly.
  static const double _shortHeight = 560;

  AppTheme get t => theme;
  List<String> get shownNames => strings.namesOrDefaults(teamNames, players);

  @override
  Widget build(BuildContext context) {
    // In landscape the form keeps its place on the right and the left half
    // presents the app, so the form leaves out the logo.
    final size = MediaQuery.sizeOf(context);
    final wide = isWideLayout(size);
    // A short window gets the tight form; a tall one keeps the roomy form.
    final short = size.height < _shortHeight;
    return Scaffold(
      backgroundColor: t.bg,
      body: Container(
        decoration: BoxDecoration(gradient: t.setupGradient),
        child: wide
            ? Row(children: [
                Expanded(flex: 38, child: WelcomePanel(theme: t, strings: strings, footer: Wrap(children: _links()))),
                Container(width: 1, color: t.bdr),
                Expanded(flex: 62, child: Center(child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: _form(showLogo: false, compact: short, showLinks: false),
                ))),
              ])
            : _form(showLogo: true),
      ),
    );
  }

  Widget _form({required bool showLogo, bool compact = false, bool showLinks = true}) {
    final gap = compact ? 12.0 : 20.0;
    final fields = <Widget>[
      if (showLogo) ...[
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
      ],

      // how many play
      if (rules.playerCounts.length > 1) ...[
        _label(strings.howManyPlay, compact),
        Row(children: [
          for (final n in rules.playerCounts) ...[
            if (n != rules.playerCounts.first) const SizedBox(width: 8),
            Expanded(child: _segBtn(strings.playersOption(n), players == n, -1,
                () => onPlayersChanged(n), key: ValueKey('players.$n'), compact: compact)),
          ],
        ]),
        SizedBox(height: gap),
      ],

      // team or player names; side by side when the screen is short
      _label(players == 4 ? strings.teams : strings.players, compact),
      if (compact)
        Row(children: [
          for (var i = 0; i < teamNames.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: _nameInput(i, compact)),
          ],
        ])
      else
        for (var i = 0; i < teamNames.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _nameInput(i, compact),
        ],
      SizedBox(height: gap),

      // first dealer
      _label(strings.whoDealsFirst, compact),
      Row(children: [
        for (var i = 0; i < teamNames.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _segBtn(shownNames[i], firstDealer == i, i, () => onFirstDealerChanged(i), compact: compact)),
        ],
      ]),
      SizedBox(height: gap),

      // score limit
      _label(strings.playTo, compact),
      Row(children: [
        for (final limit in rules.scoreLimits) ...[
          if (limit != rules.scoreLimits.first) const SizedBox(width: 8),
          Expanded(child: _segBtn('$limit', scoreLimit == limit, -1, () => onScoreLimitChanged(limit), compact: compact)),
        ],
      ]),
    ];

    final links = _links();

    if (compact) {
      // The fields scroll if the screen is very short, but the buttons stay
      // pinned below them, so starting a game never needs a scroll.
      return SafeArea(
        child: Column(children: [
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 6),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: fields),
          )),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 6),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                Expanded(child: _ctaBtn(strings.newGame, onNewGame, compact: true)),
                if (hasSavedGame) ...[
                  const SizedBox(width: 8),
                  Expanded(child: _ghostBtn(strings.continuePrev, onContinue, compact: true)),
                ],
              ]),
            ]),
          ),
        ]),
      );
    }

    return SafeArea(
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
                  ...fields,
                  const SizedBox(height: 24),
                  const Spacer(),
                  _ctaBtn(strings.newGame, onNewGame),
                  if (hasSavedGame) ...[
                    const SizedBox(height: 9),
                    _ghostBtn(strings.continuePrev, onContinue),
                  ],
                  if (showLinks) ...[
                    const SizedBox(height: 10),
                    Wrap(alignment: WrapAlignment.center, children: links),
                  ],
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  /// The Rules and Settings links.
  List<Widget> _links() => [
    TextButton(
      onPressed: onRules,
      child: Text(strings.rulesBtn, style: TextStyle(fontSize: 13, color: t.tx2)),
    ),
    TextButton(
      onPressed: onSettings,
      child: Text(strings.settingsBtn, style: TextStyle(fontSize: 13, color: t.tx2)),
    ),
  ];

  Widget _nameInput(int i, bool compact) => _TeamInput(
    key: ValueKey('name.$players.$i'), theme: t, index: i, value: teamNames[i],
    hint: strings.nameHint(players, i), compact: compact,
    onChanged: (v) { final n = [...teamNames]; n[i] = v; onTeamNamesChanged(n); },
  );

  Widget _label(String text, [bool compact = false]) => Padding(
    padding: EdgeInsets.only(bottom: compact ? 6 : 8),
    child: Text(text.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: t.tx2)),
  );

  Widget _segBtn(String label, bool active, int teamIdx, VoidCallback onTap, {double fontSize = 15, Key? key, bool compact = false}) {
    final color = teamIdx >= 0 ? t.teamColor(teamIdx) : t.acc;
    final dim   = teamIdx >= 0 ? t.teamDim(teamIdx)   : t.accDim;
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: compact ? 9 : 11),
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

  Widget _ctaBtn(String label, VoidCallback onTap, {bool compact = false}) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: compact ? 14 : 17),
      decoration: BoxDecoration(gradient: t.ctaGradient, borderRadius: BorderRadius.circular(15)),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
    ),
  );

  Widget _ghostBtn(String label, VoidCallback onTap, {bool compact = false}) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: compact ? 11 : 17),
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
  final bool compact;

  const _TeamInput({
    super.key, required this.theme, required this.index,
    required this.value, required this.hint, required this.onChanged, this.compact = false,
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
      padding: EdgeInsets.symmetric(horizontal: widget.compact ? 12 : 15, vertical: widget.compact ? 3 : 5),
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
              style: TextStyle(fontSize: widget.compact ? 14 : 16, fontWeight: FontWeight.w500, color: t.tx),
              decoration: InputDecoration(
                isDense: widget.compact,
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
