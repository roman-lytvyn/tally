import 'models.dart';

class AppStrings {
  final String lang;
  const AppStrings(this.lang);

  bool get isUk => lang == 'uk';

  // Setup
  String get appTitle        => isUk ? 'Деберц'                             : 'Deberc';
  String get teams           => isUk ? 'Команди'                            : 'Teams';
  String get whoDealsFirst   => isUk ? 'Хто роздає першим'                  : 'Who deals first';
  String get playTo          => isUk ? 'Гра до'                             : 'Play to';
  String get newGame         => isUk ? 'Нова гра ♠'                         : 'New game ♠';
  String get continuePrev    => isUk ? 'Продовжити попередню →'             : 'Continue previous →';
  String get settingsBtn     => isUk ? '⚙ Налаштування'                     : '⚙ Settings';
  String get ourTeamHint     => isUk ? 'Наша команда'                       : 'Our team';
  String get otherTeamHint   => isUk ? 'Інша команда'                       : 'Other team';
  String get players         => isUk ? 'Гравці'                             : 'Players';
  String get howManyPlay     => isUk ? 'Скільки грає'                       : 'How many play';
  String playersOption(int n) => n == 4 ? '2 × 2' : '$n';
  String player(int n)       => isUk ? 'Гравець $n'                         : 'Player $n';
  /// The names a game starts with: two teams, or one per player.
  List<String> defaultNames(int players) => players == 4
      ? (isUk ? ['Ми', 'Вони'] : ['Us', 'Them'])
      : [for (var i = 1; i <= players; i++) player(i)];
  /// The [names] as typed, with the default in place of any left blank.
  List<String> namesOrDefaults(List<String> names, int players) {
    final defaults = defaultNames(players);
    return [for (var i = 0; i < names.length; i++) names[i].trim().isEmpty ? defaults[i] : names[i].trim()];
  }
  String nameHint(int players, int side) => players == 4
      ? (side == 0 ? ourTeamHint : otherTeamHint)
      : player(side + 1);
  String get rules           => isUk ? 'Правила'                            : 'Rules';
  String get dealerMustPlay  => isUk ? 'Роздавач зобов\'язаний грати'        : 'Dealer must play';
  String get dealerMustPlayDesc => isUk
      ? 'Якщо всі спасували, козир бере той, хто роздавав'
      : 'If everyone passes, the dealer has to take the trump';
  String get tieRuleTitle    => isUk ? 'Яйця (нічия)'                       : 'Eggs (a tied deal)';
  String tieRuleName(TieRule r) => switch (r) {
    TieRule.hanging          => isUk ? 'Висять'                             : 'Held over',
    TieRule.opponentsTakeAll => isUk ? 'Суперникам'                         : 'To opponents',
    TieRule.eachKeepsOwn     => isUk ? 'Кожному своє'                       : 'Each keeps own',
  };
  String tieRuleDesc(TieRule r) => switch (r) {
    TieRule.hanging => isUk
        ? 'Суперники записують свої очки, а очки тих, хто грав, переходять до переможця наступної роздачі'
        : 'The opponents score their points; the trump-taker\'s points go to whoever wins the next deal',
    TieRule.opponentsTakeAll => isUk
        ? 'Нічия — як байт: суперники отримують усю гру'
        : 'A tie counts as bait: the opponents get the whole deal',
    TieRule.eachKeepsOwn => isUk
        ? 'Кожна сторона записує те, що набрала'
        : 'Each side scores what it took',
  };

  // Game
  String get exitBtn         => isUk ? '← Вихід'                           : '← Exit';
  String get undoBtn         => '↶';
  String get deals           => isUk ? 'роздає'                             : 'deals';
  /// Which of the team's two players deals: 1 for the one who dealt first.
  String dealsSeat(int player) => isUk ? 'роздає гравець $player'           : 'player $player deals';
  String get badgeRedeal     => isUk ? 'ПЕРЕЗДАЧА'                          : 'REDEAL';
  String get allPassed       => isUk ? 'Усі пасували — перездача'           : 'Everyone passed — redeal';
  String get noRoundsYet     => isUk ? 'Ще немає роздач'                    : 'No rounds yet';
  String get tapNewRound     => isUk ? 'Натисни «Нова роздача» нижче'       : 'Tap "New round" below';
  String get badgeBait       => isUk ? 'БАЙТ'                               : 'BAIT';
  String get badgeEggs       => isUk ? 'ЯЙЦЯ'                               : 'EGGS';
  String get pts             => isUk ? 'оч'                                 : 'pts';

  // Win
  String get winLabel        => isUk ? 'перемагають!'                       : 'win!';
  String get winLabelOne     => isUk ? 'перемагає!'                         : 'wins!';
  String get finalScore      => isUk ? 'Фінальний рахунок'                  : 'Final score';
  String get undoLastRound   => isUk ? '↶ Скасувати останню роздачу'        : '↶ Undo the last round';

  // Settings
  String get settingsTitle   => isUk ? 'Налаштування'                       : 'Settings';
  String get backBtn         => isUk ? '← Назад'                           : '← Back';
  String get appearance      => isUk ? 'Зовнішній вигляд'                   : 'Appearance';
  String get themeLabel      => isUk ? 'Тема'                               : 'Theme';
  String get themeLight      => isUk ? 'Світла'                             : 'Light';
  String get themeDark       => isUk ? 'Темна'                              : 'Dark';
  String get themeSystem     => isUk ? 'Системна'                           : 'System';
  String get scoreDisplay    => isUk ? 'Вигляд рахунку'                     : 'Score display';
  String get displayStyle    => isUk ? 'Стиль відображення'                 : 'Display style';
  String get displayStyleDesc => isUk ? 'Як рахунок показується на екрані гри' : 'How score looks on game screen';
  String get circlesSticks   => isUk ? 'Кружечки і палички'                 : 'Circles and sticks';
  String get regularNums     => isUk ? 'Звичайні цифри'                     : 'Regular numbers';
  String get language        => isUk ? 'Мова'                               : 'Language';
  String get activeLang      => isUk ? 'Активна мова'                       : 'Active language';

  // Entry panel
  String get newRound        => isUk ? '+ Нова роздача'                     : '+ New round';
  String get dealsNow        => isUk ? '🃏 Роздає зараз:'                   : '🃏 Deals now:';
  String get trumpTakenBy    => isUk ? 'Козир узяли:'                       : 'Trump taken by:';
  String get dealerPlaysIfAllPass => isUk
      ? 'Якщо всі спасували — грає роздавач'
      : 'If everyone passed, the dealer plays';
  String eggsMsg(TieRule rule, int points, String opponents) => switch (rule) {
    TieRule.hanging => isUk
        ? 'Яйця! $points очок висять до наступної роздачі'
        : 'Eggs! $points points are held until the next deal',
    TieRule.opponentsTakeAll => isUk
        ? 'Яйця! Усю гру отримують $opponents'
        : 'Eggs! $opponents get the whole deal',
    TieRule.eachKeepsOwn => isUk
        ? 'Яйця! Кожному по $points'
        : 'Eggs! $points each',
  };
  String heldMsg(int points) => isUk
      ? '🥚 $points очок чекають на переможця наступної роздачі'
      : '🥚 $points points go to the winner of the next deal';
  String baitMsg(String opponents, int gv) => isUk
      ? 'Байт! Усі $gv отримують $opponents'
      : 'Bait! $opponents get all $gv';
  String get declarations    => isUk ? 'Комбінації'                         : 'Declarations';
  String get tierce          => isUk ? 'Терц'                               : 'Tierce';
  String get fifty           => isUk ? 'П\'ятдесят'                         : 'Fifty';
  String get bella           => isUk ? 'Бела'                               : 'Bella';
  String dealValue(int gv)   => isUk ? 'Гра: $gv'                           : 'Deal: $gv';
  String get deberc          => isUk ? 'Деберц'                             : 'Deberc';
  String get debercBy        => isUk ? 'Деберц у'                           : 'Deberc held by';
  String debercWins(String side) => isUk
      ? 'Сім козирів підряд — $side виграють гру'
      : 'Seven trumps in a row — $side win the game';
  String get badgeDeberc     => isUk ? 'ДЕБЕРЦ'                             : 'DEBERC';
  String get inputting       => isUk ? '▼ вводиш'                           : '▼ input';
  String get auto            => isUk ? 'авто'                               : 'auto';
  String get cancel          => isUk ? 'Скасувати'                          : 'Cancel';
  String get delete          => isUk ? 'Видалити'                           : 'Delete';
  String editingRound(int n) => isUk ? '✎ Роздача #$n'                      : '✎ Round #$n';
  String get bait            => isUk ? 'Байт'                               : 'Bait';
  String get save            => isUk ? 'Зберегти'                           : 'Save';
}
