import 'models.dart';

/// The languages the app speaks, in the order the settings offer them.
const kLanguages = ['uk', 'en', 'fr'];

/// The language an app starts in before one is chosen: the device's own when
/// players of the game commonly use it, English otherwise.
String defaultLanguage(GameRules rules, String deviceLanguage) {
  final native = rules.id == 'deberc' ? ['uk', 'fr'] : ['fr'];
  return native.contains(deviceLanguage) ? deviceLanguage : 'en';
}

class AppStrings {
  final String lang;
  /// The game the words are for; a few terms differ between games.
  final GameRules game;
  const AppStrings(this.lang, [this.game = GameRules.deberc]);

  bool get isUk => lang == 'uk';
  bool get isFr => lang == 'fr';
  bool get _belote => game.id == 'belote';

  /// The text in the current language: Ukrainian, English or French.
  String _t(String uk, String en, String fr) => switch (lang) {
    'uk' => uk,
    'fr' => fr,
    _    => en,
  };

  // Setup
  String get appTitle        => _belote ? _t('Белот', 'Belote', 'Belote') : _t('Деберць', 'Deberc', 'Deberc');
  String get teams           => _t('Команди', 'Teams', 'Équipes');
  String get whoDealsFirst   => _t('Хто роздає першим', 'Who deals first', 'Qui distribue en premier');
  String get playTo          => _t('Гра до', 'Play to', 'Partie en');
  String get newGame         => _t('Нова гра ♠', 'New game ♠', 'Nouvelle partie ♠');
  String get continuePrev    => _t('Продовжити попередню →', 'Continue previous →', 'Reprendre la partie →');
  String get settingsBtn     => _t('⚙ Налаштування', '⚙ Settings', '⚙ Réglages');
  String get rulesBtn        => _t('📖 Правила та історія', '📖 Rules and history', '📖 Règles et histoire');
  String get rulesTitle      => _t('Правила та історія', 'Rules and history', 'Règles et histoire');
  String get ourTeamHint     => _t('Наша команда', 'Our team', 'Notre équipe');
  String get otherTeamHint   => _t('Інша команда', 'Other team', 'L\'autre équipe');
  String get players         => _t('Гравці', 'Players', 'Joueurs');
  String get howManyPlay     => _t('Скільки грає', 'How many play', 'Nombre de joueurs');
  String playersOption(int n) => n == 4 ? '2 × 2' : '$n';
  String player(int n)       => _t('Гравець $n', 'Player $n', 'Joueur $n');
  /// The names a game starts with: two teams, or one per player.
  List<String> defaultNames(int players) => players == 4
      ? [_t('Ми', 'Us', 'Nous'), _t('Вони', 'Them', 'Eux')]
      : [for (var i = 1; i <= players; i++) player(i)];
  /// The [names] as typed, with the default in place of any left blank.
  List<String> namesOrDefaults(List<String> names, int players) {
    final defaults = defaultNames(players);
    return [for (var i = 0; i < names.length; i++) names[i].trim().isEmpty ? defaults[i] : names[i].trim()];
  }
  String nameHint(int players, int side) => players == 4
      ? (side == 0 ? ourTeamHint : otherTeamHint)
      : player(side + 1);
  String get rules           => _t('Правила', 'Rules', 'Règles');
  String get dealerMustPlay  => _t('Роздавач зобов\'язаний грати', 'Dealer must play', 'Le donneur doit jouer');
  String get dealerMustPlayDesc => _t(
      'Якщо всі спасували, козир бере той, хто роздавав',
      'If everyone passes, the dealer has to take the trump',
      'Si tout le monde passe, le donneur doit prendre l\'atout');

  /// What a lost contract is called in the game.
  String get _lost           => _belote ? _t('дедан', 'dedans', 'dedans') : _t('байт', 'bait', 'dedans');
  String get _lostTitle           => _lost[0].toUpperCase() + _lost.substring(1);
  /// What a tied deal is called in the game.
  String get _tie            => _belote ? _t('Літиж', 'Litige', 'Litige') : _t('Яйця', 'Eggs', 'Litige');

  String get tieRuleTitle    => _t('$_tie (нічия)', '$_tie (a tied deal)', '$_tie (égalité)');
  String tieRuleName(TieRule r) => switch (r) {
    TieRule.hanging          => _t('Висять', 'Held over', 'En suspens'),
    TieRule.opponentsTakeAll => _t('Суперникам', 'To opponents', 'Aux adversaires'),
    TieRule.eachKeepsOwn     => _t('Кожному своє', 'Each keeps own', 'Chacun ses points'),
  };
  String tieRuleDesc(TieRule r) => switch (r) {
    TieRule.hanging => _t(
        'Суперники записують свої очки, а очки тих, хто грав, переходять до переможця наступної роздачі',
        'The opponents score their points; the trump-taker\'s points go to whoever wins the next deal',
        'Les adversaires marquent leurs points ; ceux du preneur vont au gagnant de la donne suivante'),
    TieRule.opponentsTakeAll => _t(
        'Нічия — як $_lost: суперники отримують усю гру',
        'A tie counts as $_lost: the opponents get the whole deal',
        'L\'égalité compte comme dedans : les adversaires prennent toute la donne'),
    TieRule.eachKeepsOwn => _t(
        'Кожна сторона записує те, що набрала',
        'Each side scores what it took',
        'Chaque camp marque ce qu\'il a pris'),
  };
  String get finishRuleTitle => _t('Обидві сторони набрали суму гри', 'Both sides pass the target',
      'Les deux camps atteignent le total');
  String finishRuleName(FinishRule r) => switch (r) {
    FinishRule.taker      => _t('Хто грав', 'Trump-taker', 'Le preneur'),
    FinishRule.mostPoints => _t('Більше очок', 'Most points', 'Le plus de points'),
  };
  String finishRuleDesc(FinishRule r) => switch (r) {
    FinishRule.taker => _t(
        'Перемагає сторона, що взяла козир в останній роздачі, навіть якщо в неї менше очок',
        'The side that took the trump in the last deal wins, even with fewer points',
        'Le camp qui a pris l\'atout à la dernière donne gagne, même avec moins de points'),
    FinishRule.mostPoints => _t(
        'Перемагає сторона, в якої більше очок; за рівного рахунку гра триває',
        'The side with more points wins; on an equal score play goes on',
        'Le camp qui a le plus de points gagne ; à égalité la partie continue'),
  };
  String get baitPenaltyTitle => _t('Штраф за байти', 'Penalty for bait', 'Pénalité pour dedans');
  String baitPenaltyName(BaitPenalty p) => switch (p) {
    BaitPenalty.none          => _t('Немає', 'None', 'Aucune'),
    BaitPenalty.third         => _t('Третій', 'The third', 'Le troisième'),
    BaitPenalty.thirdAndAfter => _t('Третій і далі', 'Third and after', 'Le 3e et suivants'),
    BaitPenalty.everyThird    => _t('Кожен третій', 'Every third', 'Chaque 3e'),
  };
  String baitPenaltyDesc(BaitPenalty p, int points) => switch (p) {
    BaitPenalty.none => _t(
        'Байт коштує лише програної роздачі',
        'Bait costs nothing more than the lost deal',
        'Un dedans ne coûte que la donne perdue'),
    BaitPenalty.third => _t(
        'За третій байт сторона втрачає ще $points очок',
        'A side loses $points more points for its third bait',
        'Un camp perd $points points de plus à son troisième dedans'),
    BaitPenalty.thirdAndAfter => _t(
        'За третій і кожен наступний байт сторона втрачає ще по $points очок',
        'A side loses $points more points for its third bait and each one after it',
        'Un camp perd $points points de plus à son troisième dedans et à chacun des suivants'),
    BaitPenalty.everyThird => _t(
        'За кожен третій байт — третій, шостий, дев\'ятий — сторона втрачає ще $points очок',
        'A side loses $points more points for every third bait: the third, sixth, ninth',
        'Un camp perd $points points de plus à chaque troisième dedans : le 3e, le 6e, le 9e'),
  };
  String get penaltySize     => _t('Розмір штрафу', 'Penalty size', 'Montant de la pénalité');
  String get points          => _t('очок', 'points', 'points');
  String get baitsCountTitle => _t('Байти рахуються', 'Baits are counted', 'Les dedans se comptent');
  String get baitsPerGame    => _t('За всю гру', 'Over the game', 'Sur la partie');
  String get baitsInARow     => _t('Лише підряд', 'Only in a row', 'Seulement d\'affilée');
  String baitsCountDesc(bool inARow) => inARow
      ? _t('Рахунок байтів починається знову, щойно сторона зіграє роздачу без байта',
          'The count starts again once the side plays a deal without bait',
          'Le compte repart dès que le camp joue une donne sans dedans')
      : _t('Рахуються всі байти сторони за гру, не обов\'язково підряд',
          'All of a side\'s baits in the game count, not only those in a row',
          'Tous les dedans du camp dans la partie comptent, pas seulement ceux d\'affilée');
  String get noTricksTitle   => _t('Лижі — жодної взятки', 'Skis — no tricks taken', 'Aucun pli');
  String get noPenalty       => _t('Немає', 'None', 'Aucune');
  String noTricksDesc(int points) => points == 0
      ? _t('Роздача без жодної взятки нічого не коштує', 'A deal without a trick costs nothing more',
          'Une donne sans pli ne coûte rien de plus')
      : _t('Сторона, що за роздачу не взяла жодної взятки (записано 0 очок), втрачає $points очок',
          'A side that took no tricks in a deal (0 points entered) loses $points points',
          'Un camp qui n\'a fait aucun pli dans une donne (0 point saisi) perd $points points');

  // Game
  String get exitBtn         => _t('← Вихід', '← Exit', '← Quitter');
  String get undoBtn         => '↶';
  String get deals           => _t('роздає', 'deals', 'donne');
  String get badgeRedeal     => _t('ПЕРЕЗДАЧА', 'REDEAL', 'REDONNE');
  String get allPassed       => _t('Усі пасували — перездача', 'Everyone passed — redeal', 'Tout le monde passe — redonne');
  String get noRoundsYet     => _t('Ще немає роздач', 'No rounds yet', 'Aucune donne pour l\'instant');
  String get tapNewRound     => _t('Натисни «Нова роздача» нижче', 'Tap "New round" below',
      'Appuyez sur « Nouvelle donne » ci-dessous');
  String get badgeBait       => _lost.toUpperCase();
  String get badgeEggs       => _tie.toUpperCase();
  String get pts             => _t('оч', 'pts', 'pts');
  String badgeNoTricks(int points) => _t('ЛИЖІ −$points', 'SKIS −$points', 'SANS PLI −$points');
  String baitsSoFar(int n)   => _belote
      ? _t('дедани: $n', 'dedans: $n', 'dedans : $n')
      : _t('байти: $n', 'baits: $n', 'dedans : $n');
  String toGo(int points)    => _t('ще $points', '$points to go', 'encore $points');

  // Win
  String get winLabel        => _t('перемагають!', 'win!', 'gagnent !');
  String get winLabelOne     => _t('перемагає!', 'wins!', 'gagne !');
  String get finalScore      => _t('Фінальний рахунок', 'Final score', 'Score final');
  String get undoLastRound   => _t('↶ Скасувати останню роздачу', '↶ Undo the last round', '↶ Annuler la dernière donne');

  // Settings
  String get settingsTitle   => _t('Налаштування', 'Settings', 'Réglages');
  String get backBtn         => _t('← Назад', '← Back', '← Retour');
  String get appearance      => _t('Зовнішній вигляд', 'Appearance', 'Apparence');
  String get themeLabel      => _t('Тема', 'Theme', 'Thème');
  String get themeLight      => _t('Світла', 'Light', 'Clair');
  String get themeDark       => _t('Темна', 'Dark', 'Sombre');
  String get scoreDisplay    => _t('Вигляд рахунку', 'Score display', 'Affichage du score');
  String get displayStyle    => _t('Стиль відображення', 'Display style', 'Style d\'affichage');
  String get displayStyleDesc => _t('Як рахунок показується на екрані гри', 'How score looks on game screen',
      'Comment le score apparaît à l\'écran de jeu');
  String get circlesSticks   => _t('Кружечки і палички', 'Circles and sticks', 'Ronds et bâtons');
  String get regularNums     => _t('Звичайні цифри', 'Regular numbers', 'Chiffres');
  String get gameValue       => _t('Скільки йде гра', 'Deal value', 'Valeur de la donne');
  String get gameValueDesc   => _t('Як задається, скільки йде роздача з комбінаціями',
      'How the value of a deal with its declarations is set',
      'Comment se fixe la valeur d\'une donne avec ses annonces');
  String get valueCounters   => _belote
      ? _t('Терц, 50, 100, белот', 'Tierce, 50, 100, belote', 'Tierce, 50, 100, belote')
      : _t('Терц, 50, бела', 'Tierce, 50, bella', 'Tierce, 50, bella');
  String get valueWheel      => _t('Колесо: 162, 182, 202…', 'Wheel: 162, 182, 202…', 'Roue : 162, 182, 202…');
  String get rulesForNewGames => _t('Правила діють для нових ігор; почата гра лишається на своїх',
      'The rules apply to new games; a game in progress keeps its own',
      'Les règles valent pour les nouvelles parties ; une partie en cours garde les siennes');
  String get language        => _t('Мова', 'Language', 'Langue');
  String get activeLang      => _t('Активна мова', 'Active language', 'Langue active');
  /// The name of the language [code] in that language itself.
  static String languageName(String code) => switch (code) {
    'uk' => 'Українська',
    'fr' => 'Français',
    _    => 'English',
  };
  static String languageFlag(String code) => switch (code) {
    'uk' => '🇺🇦',
    'fr' => '🇫🇷',
    _    => '🇬🇧',
  };

  // Entry panel
  String get newRound        => _t('+ Нова роздача', '+ New round', '+ Nouvelle donne');
  String get trumpTakenBy    => _t('Козир узяли:', 'Trump taken by:', 'Atout pris par :');
  String eggsMsg(TieRule rule, int points, String opponents) => switch (rule) {
    TieRule.hanging => _t(
        '$_tie! $points очок висять до наступної роздачі',
        '$_tie! $points points are held until the next deal',
        '$_tie ! $points points restent en suspens jusqu\'à la donne suivante'),
    TieRule.opponentsTakeAll => _t(
        '$_tie! Усю гру отримують $opponents',
        '$_tie! $opponents get the whole deal',
        '$_tie ! $opponents prennent toute la donne'),
    TieRule.eachKeepsOwn => _t(
        '$_tie! Кожному по $points',
        '$_tie! $points each',
        '$_tie ! $points chacun'),
  };
  String heldMsg(int points) => _t(
      '🥚 $points очок чекають на переможця наступної роздачі',
      '🥚 $points points go to the winner of the next deal',
      '🥚 $points points iront au gagnant de la donne suivante');
  String baitMsg(String opponents, int gv) => _t(
      '$_lostTitle! Усі $gv отримують $opponents',
      '$_lostTitle! $opponents get all $gv',
      '$_lostTitle ! $opponents prennent les $gv');
  String get tierce          => _t('Терц', 'Tierce', 'Tierce');
  String get fifty           => _t('П\'ятдесят', 'Fifty', 'Cinquante');
  String get bella           => _t('Бела', 'Bella', 'Bella');
  /// The name of the declaration [id] of a game's rules.
  String declaration(String id) => switch (id) {
    'tierce'  => tierce,
    'fifty'   => fifty,
    'bella'   => bella,
    'hundred' => _t('Сотня', 'Hundred', 'Cent'),
    'belote'  => _t('Белот', 'Belote', 'Belote'),
    'jacks'   => _t('Каре В', 'Carré J', 'Carré V'),
    'nines'   => _t('Каре 9', 'Carré 9', 'Carré 9'),
    'capot'   => _t('Капот', 'Capot', 'Capot'),
    _         => id,
  };
  /// The label before the side that holds the declaration [name].
  String heldBy(String name) => _t('$name у', '$name held by', '$name chez');
  String dealValue(int gv)   => _t('Гра: $gv', 'Deal: $gv', 'Donne : $gv');
  String get deberc          => _t('Деберць', 'Deberc', 'Deberc');
  String get debercBy        => _t('Деберць у', 'Deberc held by', 'Deberc chez');
  String debercWins(String side) => _t(
      'Сім козирів підряд — $side виграють гру',
      'Seven trumps in a row — $side win the game',
      'Sept atouts de suite — $side gagnent la partie');
  String get badgeDeberc     => _t('ДЕБЕРЦЬ', 'DEBERC', 'DEBERC');
  String get cancel          => _t('Скасувати', 'Cancel', 'Annuler');
  String get delete          => _t('Видалити', 'Delete', 'Supprimer');
  String deleteRoundTitle(int n) => _t('Видалити роздачу #$n?', 'Delete round #$n?', 'Supprimer la donne n° $n ?');
  String get deleteRoundDesc => _t('Її очки зникнуть з рахунку.', 'Its points will be removed from the score.',
      'Ses points seront retirés du score.');
  String editingRound(int n) => _t('✎ Роздача #$n', '✎ Round #$n', '✎ Donne n° $n');
  String get bait            => _lostTitle;
  String get save            => _t('Зберегти', 'Save', 'Enregistrer');
}
