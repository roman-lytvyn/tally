import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'models.dart';
import 'l10n.dart';
import 'screens/setup_screen.dart';
import 'screens/game_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/win_screen.dart';

const _storeKey = 'deberc_v2';
const _themeKey = 'deberc_theme';
const _styleKey = 'deberc_style';
const _langKey  = 'deberc_lang';

enum AppScreen { setup, game, settings, win }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const DebertsApp());
}

class DebertsApp extends StatelessWidget {
  const DebertsApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    title: 'Деберц',
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
  String _lang = 'uk';
  AppScreen _screen = AppScreen.setup;
  AppScreen _prevScreen = AppScreen.setup;

  List<String> _teamNames = ['', ''];
  int _scoreLimit = 1001;
  int _firstDealer = 0;
  List<Round> _rounds = [];
  List<int> _scores = [0, 0];
  int _dealer = 0;
  int? _winner;
  GameState? _savedGame;

  SharedPreferences? _prefs;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(_themeKey) ?? 'system';
    final style = prefs.getString(_styleKey) ?? 'traditional';
    final lang  = prefs.getString(_langKey)  ?? 'uk';
    final raw   = prefs.getString(_storeKey);

    GameState? saved;
    if (raw != null) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        if (data['screen'] == 'game') saved = GameState.fromJson(data);
      } catch (_) {}
    }

    final resolvedLang = lang == 'en' ? 'en' : 'uk';
    final defaultNames = resolvedLang == 'en' ? ['Us', 'Them'] : ['Ми', 'Вони'];

    if (!mounted) return;
    setState(() {
      _prefs       = prefs;
      _themeMode   = ['dark', 'light', 'system'].contains(theme) ? theme : 'system';
      _scoreStyle  = style == 'normal' ? 'normal' : 'traditional';
      _lang        = resolvedLang;
      _teamNames   = saved?.teamNames ?? defaultNames;
      _savedGame   = saved;
      _ready       = true;
    });
  }

  void _persist() {
    if (_screen == AppScreen.game) {
      _prefs?.setString(_storeKey, jsonEncode(GameState(
        teamNames: _teamNames, scoreLimit: _scoreLimit,
        rounds: _rounds, scores: _scores, dealer: _dealer,
      ).toJson()));
    }
  }

  void _goTo(AppScreen s) => setState(() { _prevScreen = _screen; _screen = s; });

  void _startNew() {
    setState(() {
      _rounds = []; _scores = [0, 0]; _dealer = _firstDealer; _winner = null; _savedGame = null;
    });
    _prefs?.remove(_storeKey);
    _goTo(AppScreen.game);
    WidgetsBinding.instance.addPostFrameCallback((_) => _persist());
  }

  void _continueSaved() {
    final g = _savedGame;
    if (g == null) return;
    setState(() {
      _teamNames = g.teamNames; _scoreLimit = g.scoreLimit;
      _rounds = g.rounds; _scores = g.scores; _dealer = g.dealer;
      _savedGame = null;
    });
    _goTo(AppScreen.game);
  }

  void _addRound(Round rd) {
    final ns = [_scores[0] + rd.earned[0], _scores[1] + rd.earned[1]];
    setState(() { _rounds = [..._rounds, rd]; _scores = ns; _dealer = 1 - _dealer; });

    if (ns[0] >= _scoreLimit || ns[1] >= _scoreLimit) {
      setState(() => _winner = ns[0] >= ns[1] ? 0 : 1);
      _prefs?.remove(_storeKey);
      _goTo(AppScreen.win);
    } else {
      _persist();
    }
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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _buildScreen(theme, strings),
    );
  }

  Widget _buildScreen(AppTheme theme, AppStrings strings) {
    switch (_screen) {
      case AppScreen.setup:
        return SetupScreen(
          key: const ValueKey('setup'),
          theme: theme, strings: strings,
          teamNames: _teamNames,
          scoreLimit: _scoreLimit, firstDealer: _firstDealer, hasSavedGame: _savedGame != null,
          onTeamNamesChanged: (v) => setState(() => _teamNames = v),
          onScoreLimitChanged: (v) => setState(() => _scoreLimit = v),
          onFirstDealerChanged: (v) => setState(() => _firstDealer = v),
          onNewGame: _startNew, onContinue: _continueSaved,
          onSettings: () => _goTo(AppScreen.settings),
        );
      case AppScreen.game:
        return GameScreen(
          key: const ValueKey('game'),
          theme: theme, strings: strings,
          teamNames: _teamNames, scores: _scores,
          scoreLimit: _scoreLimit, rounds: _rounds, dealer: _dealer,
          scoreStyle: _scoreStyle, onAddRound: _addRound,
          onBack: () {
            if (_rounds.isNotEmpty) {
              setState(() => _savedGame = GameState(
                teamNames: _teamNames, scoreLimit: _scoreLimit,
                rounds: _rounds, scores: _scores, dealer: _dealer,
              ));
            }
            _goTo(AppScreen.setup);
          },
          onSettings: () => _goTo(AppScreen.settings),
        );
      case AppScreen.settings:
        return SettingsScreen(
          key: const ValueKey('settings'),
          theme: theme, strings: strings,
          scoreStyle: _scoreStyle, lang: _lang,
          themeMode: _themeMode,
          onThemeModeChanged: (v) {
            setState(() => _themeMode = v);
            _prefs?.setString(_themeKey, v);
          },
          onScoreStyleChanged: (v) {
            setState(() => _scoreStyle = v);
            _prefs?.setString(_styleKey, v);
          },
          onBack: () => _goTo(_prevScreen),
        );
      case AppScreen.win:
        return WinScreen(
          key: const ValueKey('win'),
          theme: theme, strings: strings,
          teamNames: _teamNames, scores: _scores,
          winner: _winner ?? 0, onNewGame: () => _goTo(AppScreen.setup),
        );
    }
  }
}
