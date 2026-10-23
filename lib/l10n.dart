import 'models.dart';

/// The languages the app speaks, in the order the settings offer them.
const kLanguages = ['uk', 'en', 'fr', 'bg', 'hr'];

/// The language an app starts in before one is chosen: the device's own when
/// players of the game commonly use it, English otherwise.
String defaultLanguage(GameRules rules, String deviceLanguage) {
  final native = switch (rules.id) {
    'deberc' => ['uk', 'fr'],
    'belot'  => ['bg'],
    // Bosnian and Serbian readers follow Croatian without effort.
    'bela'   => ['hr', 'bs', 'sr'],
    _        => ['fr'],
  };
  if (!native.contains(deviceLanguage)) return 'en';
  return kLanguages.contains(deviceLanguage) ? deviceLanguage : native.first;
}

class AppStrings {
  final String lang;
  /// The game the words are for; a few terms differ between games.
  final GameRules game;
  const AppStrings(this.lang, [this.game = GameRules.deberc]);

  bool get isUk => lang == 'uk';
  bool get isFr => lang == 'fr';
  bool get _belote => game.id == 'belote';
  bool get _belot => game.id == 'belot';
  bool get _bela => game.id == 'bela';

  /// The text in the current language: Ukrainian, English, French, Bulgarian
  /// or Croatian.
  String _t(String uk, String en, String fr, String bg, String hr) => switch (lang) {
    'uk' => uk,
    'fr' => fr,
    'bg' => bg,
    'hr' => hr,
    _    => en,
  };

  // Setup
  String get appTitle        => _bela
      ? _t('Бела', 'Bela', 'Bela', 'Бела', 'Bela')
      : _belot
      ? _t('Белот', 'Belot', 'Belot', 'Белот', 'Belot')
      : _belote
          ? _t('Белот', 'Belote', 'Belote', 'Белот', 'Belote')
          : _t('Деберць', 'Deberc', 'Deberc', 'Деберц', 'Deberc');
  String get teams           => _t('Команди', 'Teams', 'Équipes', 'Отбори', 'Ekipe');
  String get whoDealsFirst   => _t('Хто роздає першим', 'Who deals first', 'Qui distribue en premier', 'Кой раздава пръв', 'Tko prvi dijeli');
  String get playTo          => _t('Гра до', 'Play to', 'Partie en', 'Игра до', 'Igra do');
  String get newGame         => _t('Нова гра ♠', 'New game ♠', 'Nouvelle partie ♠', 'Нова игра ♠', 'Nova igra ♠');
  String get continuePrev    => _t('Продовжити попередню →', 'Continue previous →', 'Reprendre la partie →',
      'Продължи предишната →', 'Nastavi prethodnu →');
  String get settingsBtn     => _t('⚙ Налаштування', '⚙ Settings', '⚙ Réglages', '⚙ Настройки', '⚙ Postavke');
  String get rulesBtn        => _t('📖 Правила та історія', '📖 Rules and history', '📖 Règles et histoire',
      '📖 Правила и история', '📖 Pravila i povijest');
  String get rulesTitle      => _t('Правила та історія', 'Rules and history', 'Règles et histoire', 'Правила и история', 'Pravila i povijest');
  String get ourTeamHint     => _t('Наша команда', 'Our team', 'Notre équipe', 'Нашият отбор', 'Naša ekipa');
  String get otherTeamHint   => _t('Інша команда', 'Other team', 'L\'autre équipe', 'Другият отбор', 'Druga ekipa');
  String get players         => _t('Гравці', 'Players', 'Joueurs', 'Играчи', 'Igrači');
  String get howManyPlay     => _t('Скільки грає', 'How many play', 'Nombre de joueurs', 'Колко играят', 'Koliko igra');
  String playersOption(int n) => n == 4 ? '2 × 2' : '$n';
  String player(int n)       => _t('Гравець $n', 'Player $n', 'Joueur $n', 'Играч $n', 'Igrač $n');
  /// The names a game starts with: two teams, or one per player.
  List<String> defaultNames(int players) => players == 4
      ? [_t('Ми', 'Us', 'Nous', 'Ние', 'Mi'), _t('Вони', 'Them', 'Eux', 'Те', 'Vi')]
      : [for (var i = 1; i <= players; i++) player(i)];
  /// The [names] as typed, with the default in place of any left blank.
  List<String> namesOrDefaults(List<String> names, int players) {
    final defaults = defaultNames(players);
    return [for (var i = 0; i < names.length; i++) names[i].trim().isEmpty ? defaults[i] : names[i].trim()];
  }
  String nameHint(int players, int side) => players == 4
      ? (side == 0 ? ourTeamHint : otherTeamHint)
      : player(side + 1);
  String get rules           => _t('Правила', 'Rules', 'Règles', 'Правила', 'Pravila');
  String get dealerMustPlay  => _t('Роздавач зобов\'язаний грати', 'Dealer must play', 'Le donneur doit jouer',
      'Раздаващият е длъжен да играе', 'Djelitelj mora igrati');
  String get dealerMustPlayDesc => _t(
      'Якщо всі спасували, козир бере той, хто роздавав',
      'If everyone passes, the dealer has to take the trump',
      'Si tout le monde passe, le donneur doit prendre l\'atout',
      'Ако всички пасуват, раздаващият трябва да вземе коза', 'Ako svi kažu dalje, djelitelj mora zvati aduta');

  /// What a lost contract is called in the game.
  String get _lost           => _bela
      ? _t('пад', 'fall', 'chute', 'пад', 'pad')
      : _belot
      ? _t('вътре', 'inside', 'dedans', 'вътре', 'unutra')
      : _belote
          ? _t('дедан', 'dedans', 'dedans', 'дедан', 'dedans')
          : _t('байт', 'bait', 'dedans', 'байт', 'bait');
  String get _lostTitle           => _lost[0].toUpperCase() + _lost.substring(1);
  /// What a tied deal is called in the game.
  String get _tie            => _bela
      ? _t('Нарівно', 'Equal points', 'Égalité', 'Равни', 'Jednako')
      : _belot
      ? _t('Висячі', 'Hanging', 'Litige', 'Висящи', 'Viseći')
      : _belote
          ? _t('Літиж', 'Litige', 'Litige', 'Литиж', 'Litige')
          : _t('Яйця', 'Eggs', 'Litige', 'Яйца', 'Jaja');

  String get tieRuleTitle    => _t('$_tie (нічия)', '$_tie (a tied deal)', '$_tie (égalité)', '$_tie (равенство)', '$_tie (izjednačeno dijeljenje)');
  String tieRuleName(TieRule r) => switch (r) {
    TieRule.hanging          => _t('Висять', 'Held over', 'En suspens', 'Висят', 'Visi'),
    TieRule.opponentsTakeAll => _t('Суперникам', 'To opponents', 'Aux adversaires', 'За противниците', 'Protivnicima'),
    TieRule.eachKeepsOwn     => _t('Кожному своє', 'Each keeps own', 'Chacun ses points', 'Всеки своите', 'Svakom svoje'),
  };
  String tieRuleDesc(TieRule r) => switch (r) {
    TieRule.hanging => _t(
        'Суперники записують свої очки, а очки тих, хто грав, переходять до переможця наступної роздачі',
        'The opponents score their points; the trump-taker\'s points go to whoever wins the next deal',
        'Les adversaires marquent leurs points ; ceux du preneur vont au gagnant de la donne suivante',
        'Противниците записват своите точки, а точките на играещите отиват при победителя в следващата раздача', 'Protivnici upisuju svoje bodove, a bodovi onih koji su zvali idu pobjedniku sljedećeg dijeljenja'),
    TieRule.opponentsTakeAll => _t(
        'Нічия — як $_lost: суперники отримують усю гру',
        'A tie counts as $_lost: the opponents get the whole deal',
        'L\'égalité compte comme dedans : les adversaires prennent toute la donne',
        'Равенството се брои за $_lost: противниците получават цялата раздача', 'Izjednačeno se broji kao $_lost: protivnici dobivaju cijelo dijeljenje'),
    TieRule.eachKeepsOwn => _t(
        'Кожна сторона записує те, що набрала',
        'Each side scores what it took',
        'Chaque camp marque ce qu\'il a pris',
        'Всяка страна записва каквото е взела', 'Svaka strana upisuje ono što je uzela'),
  };
  String get finishRuleTitle => _t('Обидві сторони набрали суму гри', 'Both sides pass the target',
      'Les deux camps atteignent le total', 'И двете страни стигат целта', 'Obje strane prijeđu cilj');
  String finishRuleName(FinishRule r) => switch (r) {
    FinishRule.taker      => _t('Хто грав', 'Trump-taker', 'Le preneur', 'Играещият', 'Tko je zvao'),
    FinishRule.mostPoints => _t('Більше очок', 'Most points', 'Le plus de points', 'Повече точки', 'Više bodova'),
  };
  String finishRuleDesc(FinishRule r) => switch (r) {
    FinishRule.taker => _t(
        'Перемагає сторона, що взяла козир в останній роздачі, навіть якщо в неї менше очок',
        'The side that took the trump in the last deal wins, even with fewer points',
        'Le camp qui a pris l\'atout à la dernière donne gagne, même avec moins de points',
        'Печели страната, взела коза в последната раздача, дори с по-малко точки', 'Pobjeđuje strana koja je zvala aduta u zadnjem dijeljenju, čak i s manje bodova'),
    FinishRule.mostPoints => _t(
        'Перемагає сторона, в якої більше очок; за рівного рахунку гра триває',
        'The side with more points wins; on an equal score play goes on',
        'Le camp qui a le plus de points gagne ; à égalité la partie continue',
        'Печели страната с повече точки; при равен резултат играта продължава', 'Pobjeđuje strana s više bodova; kod jednakog rezultata igra se dalje'),
  };
  String get baitPenaltyTitle => _t('Штраф за байти', 'Penalty for bait', 'Pénalité pour dedans', 'Наказание за байт', 'Kazna za pad');
  String baitPenaltyName(BaitPenalty p) => switch (p) {
    BaitPenalty.none          => _t('Немає', 'None', 'Aucune', 'Няма', 'Nema'),
    BaitPenalty.third         => _t('Третій', 'The third', 'Le troisième', 'Третият', 'Treći'),
    BaitPenalty.thirdAndAfter => _t('Третій і далі', 'Third and after', 'Le 3e et suivants', 'Третият и след него', 'Treći i dalje'),
    BaitPenalty.everyThird    => _t('Кожен третій', 'Every third', 'Chaque 3e', 'Всеки трети', 'Svaki treći'),
  };
  String baitPenaltyDesc(BaitPenalty p, int points) => switch (p) {
    BaitPenalty.none => _t(
        'Байт коштує лише програної роздачі',
        'Bait costs nothing more than the lost deal',
        'Un dedans ne coûte que la donne perdue',
        'Байтът струва само загубената раздача', 'Pad ne košta ništa osim izgubljenog dijeljenja'),
    BaitPenalty.third => _t(
        'За третій байт сторона втрачає ще $points очок',
        'A side loses $points more points for its third bait',
        'Un camp perd $points points de plus à son troisième dedans',
        'За третия байт страната губи още $points точки', 'Za treći pad strana gubi još $points bodova'),
    BaitPenalty.thirdAndAfter => _t(
        'За третій і кожен наступний байт сторона втрачає ще по $points очок',
        'A side loses $points more points for its third bait and each one after it',
        'Un camp perd $points points de plus à son troisième dedans et à chacun des suivants',
        'За третия и всеки следващ байт страната губи още по $points точки', 'Za treći i svaki sljedeći pad strana gubi još po $points bodova'),
    BaitPenalty.everyThird => _t(
        'За кожен третій байт — третій, шостий, дев\'ятий — сторона втрачає ще $points очок',
        'A side loses $points more points for every third bait: the third, sixth, ninth',
        'Un camp perd $points points de plus à chaque troisième dedans : le 3e, le 6e, le 9e',
        'За всеки трети байт — третия, шестия, деветия — страната губи още $points точки', 'Za svaki treći pad — treći, šesti, deveti — strana gubi još $points bodova'),
  };
  String get penaltySize     => _t('Розмір штрафу', 'Penalty size', 'Montant de la pénalité', 'Размер на наказанието', 'Iznos kazne');
  String get points          => _t('очок', 'points', 'points', 'точки', 'bodova');
  String get baitsCountTitle => _t('Байти рахуються', 'Baits are counted', 'Les dedans se comptent', 'Байтовете се броят', 'Padovi se broje');
  String get baitsPerGame    => _t('За всю гру', 'Over the game', 'Sur la partie', 'За цялата игра', 'Kroz cijelu igru');
  String get baitsInARow     => _t('Лише підряд', 'Only in a row', 'Seulement d\'affilée', 'Само поред', 'Samo zaredom');
  String baitsCountDesc(bool inARow) => inARow
      ? _t('Рахунок байтів починається знову, щойно сторона зіграє роздачу без байта',
          'The count starts again once the side plays a deal without bait',
          'Le compte repart dès que le camp joue une donne sans dedans',
          'Броят започва отначало, щом страната изиграе раздача без байт', 'Brojanje kreće iznova čim strana odigra dijeljenje bez pada')
      : _t('Рахуються всі байти сторони за гру, не обов\'язково підряд',
          'All of a side\'s baits in the game count, not only those in a row',
          'Tous les dedans du camp dans la partie comptent, pas seulement ceux d\'affilée',
          'Броят се всички байтове на страната в играта, не само поредните', 'Broje se svi padovi strane u igri, ne samo oni zaredom');
  String get noTricksTitle   => _t('Лижі — жодної взятки', 'Skis — no tricks taken', 'Aucun pli',
      'Ски — нито една взятка', 'Bez ijednog štiha');
  String get noPenalty       => _t('Немає', 'None', 'Aucune', 'Няма', 'Nema');
  String noTricksDesc(int points) => points == 0
      ? _t('Роздача без жодної взятки нічого не коштує', 'A deal without a trick costs nothing more',
          'Une donne sans pli ne coûte rien de plus', 'Раздача без взятка не струва нищо повече', 'Dijeljenje bez štiha ne košta ništa više')
      : _t('Сторона, що за роздачу не взяла жодної взятки (записано 0 очок), втрачає $points очок',
          'A side that took no tricks in a deal (0 points entered) loses $points points',
          'Un camp qui n\'a fait aucun pli dans une donne (0 point saisi) perd $points points',
          'Страна без нито една взятка в раздачата (записани 0 точки) губи $points точки', 'Strana koja u dijeljenju nije uzela nijedan štih (upisano 0 bodova) gubi $points bodova');

  // Game
  String get exitBtn         => _t('← Вихід', '← Exit', '← Quitter', '← Изход', '← Izlaz');
  String get undoBtn         => '↶';
  String get deals           => _t('роздає', 'deals', 'donne', 'раздава', 'dijeli');
  String get badgeRedeal     => _t('ПЕРЕЗДАЧА', 'REDEAL', 'REDONNE', 'ПРЕРАЗДАВАНЕ', 'NOVO DIJELJENJE');
  String get allPassed       => _t('Усі пасували — перездача', 'Everyone passed — redeal', 'Tout le monde passe — redonne',
      'Всички пас — нова раздача', 'Svi su rekli dalje — dijeli se ponovo');
  String get noRoundsYet     => _t('Ще немає роздач', 'No rounds yet', 'Aucune donne pour l\'instant',
      'Още няма раздавания', 'Još nema dijeljenja');
  String get tapNewRound     => _t('Натисни «Нова роздача» нижче', 'Tap "New round" below',
      'Appuyez sur « Nouvelle donne » ci-dessous', 'Натисни „Нова раздача“ отдолу', 'Dodirni „Novo dijeljenje” ispod');
  String get badgeBait       => _lost.toUpperCase();
  String get badgeEggs       => _tie.toUpperCase();
  String get pts             => _t('оч', 'pts', 'pts', 'т.', 'b.');
  String badgeNoTricks(int points) => _t('ЛИЖІ −$points', 'SKIS −$points', 'SANS PLI −$points', 'СКИ −$points', 'BEZ ŠTIHA −$points');
  String baitsSoFar(int n)   => _bela
      ? _t('пади: $n', 'falls: $n', 'chutes : $n', 'падове: $n', 'padovi: $n')
      : _belote
      ? _t('дедани: $n', 'dedans: $n', 'dedans : $n', 'дедани: $n', 'dedans: $n')
      : _t('байти: $n', 'baits: $n', 'dedans : $n', 'байтове: $n', 'baitovi: $n');
  String toGo(int points)    => _t('ще $points', '$points to go', 'encore $points', 'още $points', 'još $points');

  // Win
  String get winLabel        => _t('перемагають!', 'win!', 'gagnent !', 'печелят!', 'pobjeđuju!');
  String get winLabelOne     => _t('перемагає!', 'wins!', 'gagne !', 'печели!', 'pobjeđuje!');
  String get finalScore      => _t('Фінальний рахунок', 'Final score', 'Score final', 'Краен резултат', 'Konačni rezultat');
  String get undoLastRound   => _t('↶ Скасувати останню роздачу', '↶ Undo the last round', '↶ Annuler la dernière donne',
      '↶ Отмени последната раздача', '↶ Poništi zadnje dijeljenje');

  // Settings
  String get settingsTitle   => _t('Налаштування', 'Settings', 'Réglages', 'Настройки', 'Postavke');
  String get backBtn         => _t('← Назад', '← Back', '← Retour', '← Назад', '← Natrag');
  String get appearance      => _t('Зовнішній вигляд', 'Appearance', 'Apparence', 'Външен вид', 'Izgled');
  String get themeLabel      => _t('Тема', 'Theme', 'Thème', 'Тема', 'Tema');
  String get themeLight      => _t('Світла', 'Light', 'Clair', 'Светла', 'Svijetla');
  String get themeDark       => _t('Темна', 'Dark', 'Sombre', 'Тъмна', 'Tamna');
  String get scoreDisplay    => _t('Вигляд рахунку', 'Score display', 'Affichage du score', 'Изглед на резултата', 'Prikaz rezultata');
  String get displayStyle    => _t('Стиль відображення', 'Display style', 'Style d\'affichage', 'Стил на показване', 'Stil prikaza');
  String get displayStyleDesc => _t('Як рахунок показується на екрані гри', 'How score looks on game screen',
      'Comment le score apparaît à l\'écran de jeu', 'Как изглежда резултатът на екрана на играта', 'Kako rezultat izgleda na zaslonu igre');
  String get circlesSticks   => _t('Кружечки і палички', 'Circles and sticks', 'Ronds et bâtons', 'Кръгчета и чертички', 'Kružići i crtice');
  String get regularNums     => _t('Звичайні цифри', 'Regular numbers', 'Chiffres', 'Обикновени цифри', 'Obični brojevi');
  String get gameValue       => _t('Скільки йде гра', 'Deal value', 'Valeur de la donne', 'Стойност на раздачата', 'Vrijednost dijeljenja');
  String get gameValueDesc   => _t('Як задається, скільки йде роздача з комбінаціями',
      'How the value of a deal with its declarations is set',
      'Comment se fixe la valeur d\'une donne avec ses annonces',
      'Как се задава стойността на раздача с обявите ѝ', 'Kako se zadaje vrijednost dijeljenja sa zvanjima');
  String get valueCounters   => _belote
      ? _t('Терц, 50, 100, белот', 'Tierce, 50, 100, belote', 'Tierce, 50, 100, belote', 'Терца, 50, 100, белот', 'Terca, 50, 100, belote')
      : _t('Терц, 50, бела', 'Tierce, 50, bella', 'Tierce, 50, bella', 'Терца, 50, бела', 'Terca, 50, bela');
  String get valueWheel      => _t('Колесо: 162, 182, 202…', 'Wheel: 162, 182, 202…', 'Roue : 162, 182, 202…',
      'Колело: 162, 182, 202…', 'Kotačić: 162, 182, 202…');
  String get rulesForNewGames => _t('Правила діють для нових ігор; почата гра лишається на своїх',
      'The rules apply to new games; a game in progress keeps its own',
      'Les règles valent pour les nouvelles parties ; une partie en cours garde les siennes',
      'Правилата важат за новите игри; започнатата игра запазва своите', 'Pravila vrijede za nove igre; započeta igra zadržava svoja');
  String get language        => _t('Мова', 'Language', 'Langue', 'Език', 'Jezik');
  String get activeLang      => _t('Активна мова', 'Active language', 'Langue active', 'Активен език', 'Aktivni jezik');
  /// The name of the language [code] in that language itself.
  static String languageName(String code) => switch (code) {
    'uk' => 'Українська',
    'fr' => 'Français',
    'bg' => 'Български',
    'hr' => 'Hrvatski',
    _    => 'English',
  };
  static String languageFlag(String code) => switch (code) {
    'uk' => '🇺🇦',
    'fr' => '🇫🇷',
    'bg' => '🇧🇬',
    'hr' => '🇭🇷',
    _    => '🇬🇧',
  };

  // Entry panel
  String get newRound        => _t('+ Нова роздача', '+ New round', '+ Nouvelle donne', '+ Нова раздача', '+ Novo dijeljenje');
  String get trumpTakenBy    => _t('Козир узяли:', 'Trump taken by:', 'Atout pris par :', 'Коз взеха:', 'Aduta su zvali:');
  String eggsMsg(TieRule rule, int points, String opponents) => switch (rule) {
    TieRule.hanging => _t(
        '$_tie! $points очок висять до наступної роздачі',
        '$_tie! $points points are held until the next deal',
        '$_tie ! $points points restent en suspens jusqu\'à la donne suivante',
        '$_tie! $points точки висят до следващата раздача', '$_tie! $points bodova visi do sljedećeg dijeljenja'),
    TieRule.opponentsTakeAll => _t(
        '$_tie! Усю гру отримують $opponents',
        '$_tie! $opponents get the whole deal',
        '$_tie ! $opponents prennent toute la donne',
        '$_tie! Цялата раздача получават $opponents', '$_tie! Cijelo dijeljenje dobivaju $opponents'),
    TieRule.eachKeepsOwn => _t(
        '$_tie! Кожному по $points',
        '$_tie! $points each',
        '$_tie ! $points chacun',
        '$_tie! По $points за всеки', '$_tie! Svakome po $points'),
  };
  String heldMsg(int points) => _t(
      '🥚 $points очок чекають на переможця наступної роздачі',
      '🥚 $points points go to the winner of the next deal',
      '🥚 $points points iront au gagnant de la donne suivante',
      '🥚 $points точки отиват при победителя в следващата раздача', '🥚 $points bodova ide pobjedniku sljedećeg dijeljenja');
  String baitMsg(String opponents, int gv) => _t(
      '$_lostTitle! Усі $gv отримують $opponents',
      '$_lostTitle! $opponents get all $gv',
      '$_lostTitle ! $opponents prennent les $gv',
      '$_lostTitle! Всичките $gv получават $opponents', '$_lostTitle! Svih $gv dobivaju $opponents');
  String get tierce          => _t('Терц', 'Tierce', 'Tierce', 'Терца', 'Terca');
  String get fifty           => _t('П\'ятдесят', 'Fifty', 'Cinquante', 'Кварта', 'Pedeset');
  String get bella           => _t('Бела', 'Bella', 'Bella', 'Бела', 'Bela');
  /// The name of the declaration [id] of a game's rules.
  String declaration(String id) => switch (id) {
    'tierce'  => tierce,
    'fifty'   => fifty,
    'bella'   => bella,
    'hundred' => _t('Сотня', 'Hundred', 'Cent', 'Сто', 'Sto'),
    'belote'  => _t('Белот', 'Belote', 'Belote', 'Белот', 'Belote'),
    'jacks'   => _t('Каре В', 'Carré J', 'Carré V', 'Каре вале', 'Četiri dečka'),
    'nines'   => _t('Каре 9', 'Carré 9', 'Carré 9', 'Каре деветки', 'Četiri devetke'),
    'capot'   => _t('Капот', 'Capot', 'Capot', 'Капот', 'Capot'),
    'belot'   => _t('Белот', 'Belot', 'Belote', 'Белот', 'Belot'),
    'valat'   => _t('Валат', 'Valat', 'Capot', 'Валат', 'Valat'),
    'stiglja' => _t('Штиґля', 'Štiglja', 'Štiglja', 'Щигля', 'Štiglja'),
    _         => id,
  };
  /// The name of the contract [id] in the entry panel.
  String contractName(String id) => switch (id) {
    'noTrumps'  => _t('Без козиря', 'No trumps', 'Sans atout', 'Без коз', 'Bez aduta'),
    'allTrumps' => _t('Всі козирі', 'All trumps', 'Tout atout', 'Всичко коз', 'Sve aduti'),
    _           => _t('Масть', 'Suit', 'Couleur', 'Боя', 'Boja'),
  };
  /// The contract [id] as it is marked in the list of deals.
  String contractShort(String id) => switch (id) {
    'noTrumps'  => _t('БК', 'NT', 'SA', 'БК', 'BA'),
    'allTrumps' => _t('ВК', 'AT', 'TA', 'ВК', 'SA'),
    _           => _t('Масть', 'Suit', 'Coul.', 'Боя', 'Boja'),
  };
  /// A doubled contract when [doubling] is 2, a redoubled one when it is 4.
  String doublingName(int doubling) => doubling == 4
      ? _t('Реконтра', 'Re-contra', 'Surcontre', 'Реконтра', 'Rekontra')
      : _t('Контра', 'Contra', 'Contre', 'Контра', 'Kontra');
  String takesAllMsg(String side, int points) => _t(
      'Усі $points отримують $side',
      '$side get all $points',
      '$side prennent les $points',
      'Всичките $points получават $side', 'Svih $points dobivaju $side');
  /// The game points a deal adds to each side.
  String recordedMsg(List<int> points) =>
      _t('До рахунку: ', 'Scores: ', 'Au score : ', 'Записва се: ', 'U rezultat: ') + points.join(' : ');
  /// The label before the side that holds the declaration [name].
  String heldBy(String name) => _t('$name у', '$name held by', '$name chez', '$name у', '$name kod');
  String dealValue(int gv)   => _t('Гра: $gv', 'Deal: $gv', 'Donne : $gv', 'Раздача: $gv', 'Dijeljenje: $gv');
  /// The hand that wins the game on its own: a deberc, or a belot in Bela.
  String get deberc          => _bela
      ? _t('Белот', 'Belot', 'Belote', 'Белот', 'Belot')
      : _t('Деберць', 'Deberc', 'Deberc', 'Деберц', 'Deberc');
  String get debercBy        => _bela
      ? _t('Белот у', 'Belot held by', 'Belote chez', 'Белот у', 'Belot kod')
      : _t('Деберць у', 'Deberc held by', 'Deberc chez', 'Деберц у', 'Deberc kod');
  String debercWins(String side) => _bela
      ? _t(
          'Усі вісім карт однієї масті — $side виграють гру',
          'All eight cards of one suit — $side win the game',
          'Les huit cartes d\'une couleur — $side gagnent la partie',
          'Осемте карти от една боя — $side печелят играта', 'Svih osam karata jedne boje — $side pobjeđuju')
      : _t(
      'Сім козирів підряд — $side виграють гру',
      'Seven trumps in a row — $side win the game',
      'Sept atouts de suite — $side gagnent la partie',
      'Седем поредни коза — $side печелят играта', 'Sedam aduta zaredom — $side pobjeđuju u igri');
  String get badgeDeberc     => deberc.toUpperCase();
  String get cancel          => _t('Скасувати', 'Cancel', 'Annuler', 'Отказ', 'Odustani');
  String get delete          => _t('Видалити', 'Delete', 'Supprimer', 'Изтрий', 'Izbriši');
  String deleteRoundTitle(int n) => _t('Видалити роздачу #$n?', 'Delete round #$n?', 'Supprimer la donne n° $n ?',
      'Да се изтрие ли раздача №$n?', 'Izbrisati dijeljenje #$n?');
  String get deleteRoundDesc => _t('Її очки зникнуть з рахунку.', 'Its points will be removed from the score.',
      'Ses points seront retirés du score.', 'Точките ѝ ще бъдат махнати от резултата.', 'Njegovi bodovi bit će uklonjeni iz rezultata.');
  String editingRound(int n) => _t('✎ Роздача #$n', '✎ Round #$n', '✎ Donne n° $n', '✎ Раздача №$n', '✎ Dijeljenje #$n');
  String get bait            => _lostTitle;
  String get save            => _t('Зберегти', 'Save', 'Enregistrer', 'Запази', 'Spremi');
}
