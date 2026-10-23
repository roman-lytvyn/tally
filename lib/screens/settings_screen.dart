import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';
import '../models.dart';

class SettingsScreen extends StatelessWidget {
  final AppTheme theme;
  final AppStrings strings;
  final GameRules rules;
  final String scoreStyle;
  final String valueInput;
  final String lang;
  final String themeMode;
  /// The rules new games start with.
  final bool dealerMustPlay;
  final TieRule tieRule;
  final FinishRule finishRule;
  final Penalties penalties;
  final void Function(String) onThemeModeChanged;
  final void Function(String) onScoreStyleChanged;
  final void Function(String) onValueInputChanged;
  final void Function(bool) onDealerMustPlayChanged;
  final void Function(TieRule) onTieRuleChanged;
  final void Function(FinishRule) onFinishRuleChanged;
  final void Function(Penalties) onPenaltiesChanged;
  final void Function(String) onLangChanged;
  final VoidCallback onBack;

  const SettingsScreen({
    super.key, required this.theme, required this.strings, this.rules = GameRules.deberc, required this.scoreStyle,
    required this.valueInput, required this.lang, required this.themeMode,
    required this.dealerMustPlay, required this.tieRule, required this.finishRule,
    this.penalties = const Penalties(),
    required this.onThemeModeChanged, required this.onScoreStyleChanged,
    required this.onValueInputChanged, required this.onDealerMustPlayChanged,
    required this.onTieRuleChanged, required this.onFinishRuleChanged,
    required this.onPenaltiesChanged,
    required this.onLangChanged, required this.onBack,
  });

  AppTheme get t => theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(gradient: t.headerGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                child: Row(children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(10)),
                      child: Text(strings.backBtn,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.tx2)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(strings.settingsTitle,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: t.tx)),
                  )),
                ]),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                _groupLabel(strings.appearance),
                _group([
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(strings.themeLabel,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: t.tx)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(child: _themeOpt('☀️', strings.themeLight, 'light')),
                        const SizedBox(width: 6),
                        Expanded(child: _themeOpt('🌙', strings.themeDark, 'dark')),
                      ]),
                    ]),
                  ),
                ]),
                const SizedBox(height: 14),
                _groupLabel(strings.scoreDisplay),
                _group([
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(strings.displayStyle,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: t.tx)),
                      const SizedBox(height: 2),
                      Text(strings.displayStyleDesc, style: TextStyle(fontSize: 12, color: t.tx2)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(child: _styleOpt('⊗ ○ |', strings.circlesSticks, 'traditional')),
                        const SizedBox(width: 6),
                        Expanded(child: _styleOpt('123', strings.regularNums, 'normal')),
                      ]),
                    ]),
                  ),
                  _divider(),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(strings.gameValue,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: t.tx)),
                      const SizedBox(height: 2),
                      Text(strings.gameValueDesc, style: TextStyle(fontSize: 12, color: t.tx2)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(child: _option('+ −', strings.valueCounters, valueInput == 'counters',
                            () => onValueInputChanged('counters'))),
                        const SizedBox(width: 6),
                        Expanded(child: _option('⇅', strings.valueWheel, valueInput == 'wheel',
                            () => onValueInputChanged('wheel'))),
                      ]),
                    ]),
                  ),
                ]),
                const SizedBox(height: 14),
                _groupLabel(strings.rules),
                _group([
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onDealerMustPlayChanged(!dealerMustPlay),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 9, 8, 9),
                      child: Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(strings.dealerMustPlay,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: t.tx)),
                          const SizedBox(height: 2),
                          Text(strings.dealerMustPlayDesc, style: TextStyle(fontSize: 12, color: t.tx2)),
                        ])),
                        Switch(value: dealerMustPlay, onChanged: onDealerMustPlayChanged, activeThumbColor: t.acc),
                      ]),
                    ),
                  ),
                  _divider(),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(strings.tieRuleTitle,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: t.tx)),
                      const SizedBox(height: 10),
                      Row(children: [
                        for (final rule in TieRule.values) ...[
                          if (rule != TieRule.values.first) const SizedBox(width: 6),
                          Expanded(child: _option(_tieRuleIcon(rule), strings.tieRuleName(rule),
                              tieRule == rule, () => onTieRuleChanged(rule))),
                        ],
                      ]),
                      const SizedBox(height: 8),
                      Text(strings.tieRuleDesc(tieRule), style: TextStyle(fontSize: 12, color: t.tx2)),
                    ]),
                  ),
                  _divider(),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(strings.finishRuleTitle,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: t.tx)),
                      const SizedBox(height: 10),
                      Row(children: [
                        for (final rule in FinishRule.values) ...[
                          if (rule != FinishRule.values.first) const SizedBox(width: 6),
                          Expanded(child: _option(_finishRuleIcon(rule), strings.finishRuleName(rule),
                              finishRule == rule, () => onFinishRuleChanged(rule))),
                        ],
                      ]),
                      const SizedBox(height: 8),
                      Text(strings.finishRuleDesc(finishRule), style: TextStyle(fontSize: 12, color: t.tx2)),
                    ]),
                  ),
                  if (rules.hasPenalties) ...[
                    _divider(),
                    _baitPenalty(),
                    _divider(),
                    _noTricksPenalty(),
                  ],
                ]),
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 2),
                  child: Text(strings.rulesForNewGames, style: TextStyle(fontSize: 11, color: t.tx3)),
                ),
                const SizedBox(height: 14),
                _groupLabel(strings.language),
                _group([
                  for (final (i, code) in kLanguages.indexed) ...[
                    if (i > 0) _divider(),
                    _langRow(AppStrings.languageFlag(code), AppStrings.languageName(code), code),
                  ],
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6, left: 2),
    child: Text(text.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1, color: t.tx2)),
  );

  Widget _group(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: t.surf, border: Border.all(color: t.bdr),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
  );

  Widget _divider() => Divider(height: 1, color: t.bdr, indent: 15);

  Widget _themeOpt(String icon, String label, String value) {
    // Until a theme is chosen the one the device is using is shown as picked.
    final on = (themeMode == 'system' ? (t.isDark ? 'dark' : 'light') : themeMode) == value;
    return GestureDetector(
      key: ValueKey('theme.$value'),
      onTap: () => onThemeModeChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: on ? t.accDim : Colors.transparent,
          border: Border.all(color: on ? t.accBdr : t.bdr, width: 1.5),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: on ? t.acc : t.tx2, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _title(String text) =>
      Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: t.tx));

  Widget _desc(String text) => Text(text, style: TextStyle(fontSize: 12, color: t.tx2));

  /// Which baits are penalised and, once some are, by how much and how they
  /// are counted.
  Widget _baitPenalty() {
    final p = penalties;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _title(strings.baitPenaltyTitle),
        const SizedBox(height: 10),
        Row(children: [
          for (final rule in BaitPenalty.values) ...[
            if (rule != BaitPenalty.values.first) const SizedBox(width: 6),
            Expanded(child: _option(_baitPenaltyIcon(rule), strings.baitPenaltyName(rule), p.bait == rule,
                () => onPenaltiesChanged(p.copyWith(bait: rule)), key: ValueKey('baitPenalty.${rule.name}'))),
          ],
        ]),
        const SizedBox(height: 8),
        _desc(strings.baitPenaltyDesc(p.bait, p.baitPoints)),
        if (p.bait != BaitPenalty.none) ...[
          const SizedBox(height: 14),
          _title(strings.penaltySize),
          const SizedBox(height: 10),
          Row(children: [
            for (final points in kPenaltyPoints) ...[
              if (points != kPenaltyPoints.first) const SizedBox(width: 6),
              Expanded(child: _option('−$points', strings.points, p.baitPoints == points,
                  () => onPenaltiesChanged(p.copyWith(baitPoints: points)), key: ValueKey('baitPoints.$points'))),
            ],
          ]),
          const SizedBox(height: 14),
          _title(strings.baitsCountTitle),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _option('Σ', strings.baitsPerGame, !p.baitsInARow,
                () => onPenaltiesChanged(p.copyWith(baitsInARow: false)), key: const ValueKey('baitsPerGame'))),
            const SizedBox(width: 6),
            Expanded(child: _option('⋯', strings.baitsInARow, p.baitsInARow,
                () => onPenaltiesChanged(p.copyWith(baitsInARow: true)), key: const ValueKey('baitsInARow'))),
          ]),
          const SizedBox(height: 8),
          _desc(strings.baitsCountDesc(p.baitsInARow)),
        ],
      ]),
    );
  }

  Widget _noTricksPenalty() {
    final p = penalties;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _title(strings.noTricksTitle),
        const SizedBox(height: 10),
        Row(children: [
          for (final points in [0, ...kPenaltyPoints]) ...[
            if (points != 0) const SizedBox(width: 6),
            Expanded(child: _option(points == 0 ? '✕' : '−$points', points == 0 ? strings.noPenalty : strings.points,
                p.noTricksPoints == points, () => onPenaltiesChanged(p.copyWith(noTricksPoints: points)),
                key: ValueKey('noTricks.$points'))),
          ],
        ]),
        const SizedBox(height: 8),
        _desc(strings.noTricksDesc(p.noTricksPoints)),
      ]),
    );
  }

  static String _baitPenaltyIcon(BaitPenalty p) => switch (p) {
    BaitPenalty.none          => '✕',
    BaitPenalty.third         => '3',
    BaitPenalty.thirdAndAfter => '3, 4, 5…',
    BaitPenalty.everyThird    => '3, 6, 9…',
  };

  static String _tieRuleIcon(TieRule r) => switch (r) {
    TieRule.hanging          => '⏳',
    TieRule.opponentsTakeAll => '→',
    TieRule.eachKeepsOwn     => '⇄',
  };

  static String _finishRuleIcon(FinishRule r) => switch (r) {
    FinishRule.taker      => '♣',
    FinishRule.mostPoints => '↑',
  };

  Widget _styleOpt(String icon, String label, String value) =>
      _option(icon, label, scoreStyle == value, () => onScoreStyleChanged(value));

  Widget _option(String icon, String label, bool on, VoidCallback onTap, {Key? key}) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: on ? t.accDim : Colors.transparent,
          border: Border.all(color: on ? t.accBdr : t.bdr, width: 1.5),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(children: [
          Text(icon, style: TextStyle(fontSize: 13, color: on ? t.acc : t.tx2, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: on ? t.acc : t.tx2, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _langRow(String flag, String name, String code) {
    final active = lang == code;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onLangChanged(code),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        child: Row(children: [
          Text(flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: t.tx)),
            if (active)
              Text(strings.activeLang, style: TextStyle(fontSize: 12, color: t.tx2)),
          ])),
          if (active) Text('✓', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: t.acc)),
        ]),
      ),
    );
  }
}
