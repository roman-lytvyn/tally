import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'models.dart';
import 'scoring.dart';
import 'l10n.dart';
import 'screens/setup_screen.dart';
import 'screens/game_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/win_screen.dart';
import 'screens/rules_screen.dart';

const _storeKey = 'deberc_v2';
const _themeKey = 'deberc_theme';
const _styleKey = 'deberc_style';
const _langKey  = 'deberc_lang';
const _valueKey = 'deberc_value_input';

enum AppScreen { setup, game, settings, win, rules }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const DebertsApp());
}

class DebertsApp extends StatelessWidget {
  const DebertsApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    title: 'Deberc',
    debugShowCheckedModeBanner: false,
    home: AppRoot(),
  );
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  String _themeMode = 'system';
  String _scoreStyle = 'traditional';
  String _valueInput = 'counters';
  String _lang = 'uk';
  AppScreen _screen = AppScreen.setup;
  AppScreen _prevScreen = AppScreen.setup;

  List<String> _teamNames = ['', ''];
  int _scoreLimit = 1001;
  int _firstDealer = 0;
  bool _dealerMustPlay = false;
  TieRule _tieRule = TieRule.hanging;
  int _players = 4;
  List<Round> _rounds = [];
  GameState? _savedGame;

  SharedPreferences? _prefs;
  bool _ready = false;

  GameState get _game => GameState(
    teamNames: AppStrings(_lang).namesOrDefaults(_teamNames, _players), scoreLimit: _scoreLimit,
    rounds: _rounds, firstDealer: _firstDealer,
    dealerMustPlay: _dealerMustPlay, tieRule: _tieRule, players: _players,
  );

  /// Switches between team and individual play, starting from the default
  /// names whenever the number of sides changes.
  void _setPlayers(int players) {
    if (players == _players) return;
    final strings = AppStrings(_lang);
    setState(() {
      final wasTeams = _players == 4;
      _players = players;
      final defaults = strings.defaultNames(players);
      _teamNames = wasTeams == (players == 4)
          ? [for (var i = 0; i < defaults.length; i++) i < _teamNames.length ? _teamNames[i] : defaults[i]]
          : defaults;
      if (_firstDealer >= sidesFor(players)) _firstDealer = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(_themeKey) ?? 'system';
    final style = prefs.getString(_styleKey) ?? 'traditional';
    final valueIn = prefs.getString(_valueKey) ?? 'counters';
    // Until a language is chosen, Ukrainian devices get Ukrainian and every
    // other device English.
    final lang  = prefs.getString(_langKey)
        ?? WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final raw   = prefs.getString(_storeKey);

    GameState? saved;
    if (raw != null) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        if (data['screen'] == 'game') saved = GameState.fromJson(data);
      } catch (_) {}
    }

    final resolvedLang = lang == 'uk' ? 'uk' : 'en';
    final defaultNames = AppStrings(resolvedLang).defaultNames(4);

    if (!mounted) return;
    setState(() {
      _prefs       = prefs;
      _themeMode   = ['dark', 'light', 'system'].contains(theme) ? theme : 'system';
      _scoreStyle  = style == 'normal' ? 'normal' : 'traditional';
      _valueInput  = valueIn == 'wheel' ? 'wheel' : 'counters';
      _lang        = resolvedLang;
      _teamNames   = saved?.teamNames ?? defaultNames;
      _players     = saved?.players ?? 4;
      _savedGame   = saved;
      _ready       = true;
    });
  }

  void _persist() {
    if (tally(_game).winner != null) {
      _prefs?.remove(_storeKey);
    } else {
      _prefs?.setString(_storeKey, jsonEncode(_game.toJson()));
    }
  }

  /// Switches the language; names still at their defaults follow it.
  void _setLang(String lang) {
    final before = AppStrings(_lang).defaultNames(_players);
    final after = AppStrings(lang).defaultNames(_players);
    setState(() {
      _lang = lang;
      _teamNames = [for (var i = 0; i < _teamNames.length; i++) _teamNames[i] == before[i] ? after[i] : _teamNames[i]];
    });
    _prefs?.setString(_langKey, lang);
    if (_rounds.isNotEmpty) _persist();
  }

  void _goTo(AppScreen s) => setState(() { _prevScreen = _screen; _screen = s; });

  void _startNew() {
    setState(() { _teamNames = _game.teamNames; _rounds = []; _savedGame = null; });
    _prefs?.remove(_storeKey);
    _goTo(AppScreen.game);
    WidgetsBinding.instance.addPostFrameCallback((_) => _persist());
  }

  void _continueSaved() {
    final g = _savedGame;
    if (g == null) return;
    setState(() {
      _teamNames = g.teamNames; _scoreLimit = g.scoreLimit;
      _rounds = g.rounds; _firstDealer = g.firstDealer;
      _dealerMustPlay = g.dealerMustPlay; _tieRule = g.tieRule;
      _players = g.players;
      _savedGame = null;
    });
    _goTo(AppScreen.game);
  }

  /// Replaces the list of deals and moves to whichever screen the new score
  /// calls for, so adding, correcting and removing a deal all end the same way.
  void _setRounds(List<Round> rounds) {
    setState(() => _rounds = rounds);
    _persist();
    final over = tally(_game).winner != null;
    if (over && _screen != AppScreen.win) _goTo(AppScreen.win);
    if (!over && _screen == AppScreen.win) _goTo(AppScreen.game);
  }

  void _addRound(Round rd) => _setRounds([..._rounds, rd]);

  void _replaceRound(int index, Round rd) => _setRounds([..._rounds]..[index] = rd);

  void _removeRound(int index) => _setRounds([..._rounds]..removeAt(index));

  void _undoLast() {
    if (_rounds.isNotEmpty) _removeRound(_rounds.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return Container(color: const Color(0xFF111118));

    final isDark = switch (_themeMode) {
      'dark'  => true,
      'light' => false,
      _       => MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
    final theme   = AppTheme(isDark);
    final strings = AppStrings(_lang);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: theme.bg,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));

    // The name the system shows for the app follows the chosen language.
    return Title(
      title: strings.appTitle,
      color: theme.acc,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _buildScreen(theme, strings),
      ),
    );
  }

  Widget _buildScreen(AppTheme theme, AppStrings strings) {
    switch (_screen) {
      case AppScreen.setup:
        return SetupScreen(
          key: const ValueKey('setup'),
          theme: theme, strings: strings,
          teamNames: _teamNames,
          players: _players, onPlayersChanged: _setPlayers,
          scoreLimit: _scoreLimit, firstDealer: _firstDealer, hasSavedGame: _savedGame != null,
          dealerMustPlay: _dealerMustPlay,
          onDealerMustPlayChanged: (v) => setState(() => _dealerMustPlay = v),
          tieRule: _tieRule,
          onTieRuleChanged: (v) => setState(() => _tieRule = v),
          onTeamNamesChanged: (v) => setState(() => _teamNames = v),
          onScoreLimitChanged: (v) => setState(() => _scoreLimit = v),
          onFirstDealerChanged: (v) => setState(() => _firstDealer = v),
          onNewGame: _startNew, onContinue: _continueSaved,
          onSettings: () => _goTo(AppScreen.settings),
          onRules: () => _goTo(AppScreen.rules),
        );
      case AppScreen.rules:
        return RulesScreen(
          key: const ValueKey('rules'),
          theme: theme, strings: strings,
          onBack: () => _goTo(AppScreen.setup),
        );
      case AppScreen.game:
        return GameScreen(
          key: const ValueKey('game'),
          theme: theme, strings: strings,
          teamNames: _game.teamNames, scoreLimit: _scoreLimit, players: _players,
          dealerMustPlay: _dealerMustPlay, tieRule: _tieRule,
          rounds: _rounds, tally: tally(_game),
          scoreStyle: _scoreStyle, valueInput: _valueInput,
          onAddRound: _addRound, onReplaceRound: _replaceRound, onRemoveRound: _removeRound,
          onUndo: _undoLast,
          onBack: () {
            if (_rounds.isNotEmpty) setState(() => _savedGame = _game);
            _goTo(AppScreen.setup);
          },
          onSettings: () => _goTo(AppScreen.settings),
        );
      case AppScreen.settings:
        return SettingsScreen(
          key: const ValueKey('settings'),
          theme: theme, strings: strings,
          scoreStyle: _scoreStyle, valueInput: _valueInput, lang: _lang,
          themeMode: _themeMode,
          onThemeModeChanged: (v) {
            setState(() => _themeMode = v);
            _prefs?.setString(_themeKey, v);
          },
          onScoreStyleChanged: (v) {
            setState(() => _scoreStyle = v);
            _prefs?.setString(_styleKey, v);
          },
          onValueInputChanged: (v) {
            setState(() => _valueInput = v);
            _prefs?.setString(_valueKey, v);
          },
          onLangChanged: _setLang,
          onBack: () => _goTo(_prevScreen),
        );
      case AppScreen.win:
        final t = tally(_game);
        return WinScreen(
          key: const ValueKey('win'),
          theme: theme, strings: strings,
          teamNames: _game.teamNames, scores: t.totals, players: _players,
          winner: t.winner ?? 0,
          onUndo: _undoLast,
          onNewGame: () => _goTo(AppScreen.setup),
        );
    }
  }
}
