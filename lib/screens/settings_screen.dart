import 'package:flutter/material.dart';
import '../theme.dart';
import '../l10n.dart';

class SettingsScreen extends StatelessWidget {
  final AppTheme theme;
  final AppStrings strings;
  final String scoreStyle;
  final String lang;
  final String themeMode;
  final void Function(String) onThemeModeChanged;
  final void Function(String) onScoreStyleChanged;
  final VoidCallback onBack;

  const SettingsScreen({
    super.key, required this.theme, required this.strings, required this.scoreStyle,
    required this.lang, required this.themeMode, required this.onThemeModeChanged,
    required this.onScoreStyleChanged, required this.onBack,
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
                  Text(strings.settingsTitle,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: t.tx)),
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
                        Expanded(child: _themeOpt('🌗', strings.themeSystem, 'system')),
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
                ]),
                const SizedBox(height: 14),
                _groupLabel(strings.language),
                _group([
                  _langRow('🇺🇦', 'Українська', strings.activeLang, true),
                  _divider(),
                  Opacity(
                    opacity: 0.38,
                    child: _langRow('🇬🇧', 'English', strings.activeLang, false),
                  ),
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
    final on = themeMode == value;
    return GestureDetector(
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

  Widget _styleOpt(String icon, String label, String value) {
    final on = scoreStyle == value;
    return GestureDetector(
      onTap: () => onScoreStyleChanged(value),
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

  Widget _langRow(String flag, String name, String activeLabelText, bool active) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        child: Row(children: [
          Text(flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: t.tx)),
            if (active)
              Text(activeLabelText, style: TextStyle(fontSize: 12, color: t.tx2)),
          ])),
          if (active) Text('✓', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: t.acc)),
        ]),
      );
}
