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
  String get rules           => isUk ? 'Правила'                            : 'Rules';
  String get dealerMustPlay  => isUk ? 'Роздавач зобов\'язаний грати'        : 'Dealer must play';
  String get dealerMustPlayDesc => isUk
      ? 'Якщо всі спасували, козир бере той, хто роздавав'
      : 'If everyone passes, the dealer has to take the trump';

  // Game
  String get exitBtn         => isUk ? '← Вихід'                           : '← Exit';
  String get undoBtn         => '↶';
  String get deals           => isUk ? 'роздає'                             : 'deals';
  String get noRoundsYet     => isUk ? 'Ще немає роздач'                    : 'No rounds yet';
  String get tapNewRound     => isUk ? 'Натисни «Нова роздача» нижче'       : 'Tap "New round" below';
  String get badgeBait       => isUk ? 'БАЙТ'                               : 'BAIT';
  String get badgeEggs       => isUk ? 'ЯЙЦЯ'                               : 'EGGS';
  String get pts             => isUk ? 'оч'                                 : 'pts';

  // Win
  String get winLabel        => isUk ? 'перемагають!'                       : 'win!';
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
  String eggsMsg(int a, int b) => isUk
      ? 'Яйця! Однакова кількість очок — $a:$b'
      : 'Eggs! Equal points — $a:$b';
  String baitMsg(String opponents, int gv) => isUk
      ? 'Байт! Усі $gv отримують $opponents'
      : 'Bait! $opponents get all $gv';
  String get inputting       => isUk ? '▼ вводиш'                           : '▼ input';
  String get auto            => isUk ? 'авто'                               : 'auto';
  String get cancel          => isUk ? 'Скасувати'                          : 'Cancel';
  String get delete          => isUk ? 'Видалити'                           : 'Delete';
  String editingRound(int n) => isUk ? '✎ Роздача #$n'                      : '✎ Round #$n';
  String get bait            => isUk ? 'Байт'                               : 'Bait';
  String get save            => isUk ? 'Зберегти'                           : 'Save';
}
