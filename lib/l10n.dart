import 'models.dart';

class AppStrings {
  final String lang;
  const AppStrings(this.lang);

  bool get isUk => lang == 'uk';

  // Setup
  String get appTitle        => isUk ? 'Деберць'                            : 'Deberc';
  String get teams           => isUk ? 'Команди'                            : 'Teams';
  String get whoDealsFirst   => isUk ? 'Хто роздає першим'                  : 'Who deals first';
  String get playTo          => isUk ? 'Гра до'                             : 'Play to';
  String get newGame         => isUk ? 'Нова гра ♠'                         : 'New game ♠';
  String get continuePrev    => isUk ? 'Продовжити попередню →'             : 'Continue previous →';
  String get settingsBtn     => isUk ? '⚙ Налаштування'                     : '⚙ Settings';
  String get rulesBtn        => isUk ? '📖 Правила та історія'              : '📖 Rules and history';
  String get rulesTitle      => isUk ? 'Правила та історія'                 : 'Rules and history';
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
  String get finishRuleTitle => isUk ? 'Обидві сторони набрали суму гри'    :'Both sides pass the target';
  String finishRuleName(FinishRule r) => switch (r) {
    FinishRule.taker      => isUk ? 'Хто грав'                              : 'Trump-taker',
    FinishRule.mostPoints => isUk ? 'Більше очок'                           : 'Most points',
  };
  String finishRuleDesc(FinishRule r) => switch (r) {
    FinishRule.taker => isUk
        ? 'Перемагає сторона, що взяла козир в останній роздачі, навіть якщо в неї менше очок'
        : 'The side that took the trump in the last deal wins, even with fewer points',
    FinishRule.mostPoints => isUk
        ? 'Перемагає сторона, в якої більше очок; за рівного рахунку гра триває'
        : 'The side with more points wins; on an equal score play goes on',
  };
  String get baitPenaltyTitle => isUk ? 'Штраф за байти'                    : 'Penalty for bait';
  String baitPenaltyName(BaitPenalty p) => switch (p) {
    BaitPenalty.none          => isUk ? 'Немає'                             : 'None',
    BaitPenalty.third         => isUk ? 'Третій'                            : 'The third',
    BaitPenalty.thirdAndAfter => isUk ? 'Третій і далі'                     : 'Third and after',
    BaitPenalty.everyThird    => isUk ? 'Кожен третій'                      : 'Every third',
  };
  String baitPenaltyDesc(BaitPenalty p, int points) => switch (p) {
    BaitPenalty.none => isUk
        ? 'Байт коштує лише програної роздачі'
        : 'Bait costs nothing more than the lost deal',
    BaitPenalty.third => isUk
        ? 'За третій байт сторона втрачає ще $points очок'
        : 'A side loses $points more points for its third bait',
    BaitPenalty.thirdAndAfter => isUk
        ? 'За третій і кожен наступний байт сторона втрачає ще по $points очок'
        : 'A side loses $points more points for its third bait and each one after it',
    BaitPenalty.everyThird => isUk
        ? 'За кожен третій байт — третій, шостий, дев\'ятий — сторона втрачає ще $points очок'
        : 'A side loses $points more points for every third bait: the third, sixth, ninth',
  };
  String get penaltySize     => isUk ? 'Розмір штрафу'                      : 'Penalty size';
  String get points          => isUk ? 'очок'                               : 'points';
  String get baitsCountTitle => isUk ? 'Байти рахуються'                    : 'Baits are counted';
  String get baitsPerGame    => isUk ? 'За всю гру'                         : 'Over the game';
  String get baitsInARow     => isUk ? 'Лише підряд'                        : 'Only in a row';
  String baitsCountDesc(bool inARow) => inARow
      ? (isUk
          ? 'Рахунок байтів починається знову, щойно сторона зіграє роздачу без байта'
          : 'The count starts again once the side plays a deal without bait')
      : (isUk
          ? 'Рахуються всі байти сторони за гру, не обов\'язково підряд'
          : 'All of a side\'s baits in the game count, not only those in a row');
  String get noTricksTitle   => isUk ? 'Лижі — жодної взятки'               : 'Skis — no tricks taken';
  String get noPenalty       => isUk ? 'Немає'                              : 'None';
  String noTricksDesc(int points) => points == 0
      ? (isUk ? 'Роздача без жодної взятки нічого не коштує' : 'A deal without a trick costs nothing more')
      : (isUk
          ? 'Сторона, що за роздачу не взяла жодної взятки (записано 0 очок), втрачає $points очок'
          : 'A side that took no tricks in a deal (0 points entered) loses $points points');

  // Game
  String get exitBtn        => isUk ? '← Вихід'                           : '← Exit';
  String get undoBtn         => '↶';
  String get deals           => isUk ? 'роздає'                             : 'deals';
  String get badgeRedeal     => isUk ? 'ПЕРЕЗДАЧА'                          : 'REDEAL';
  String get allPassed       => isUk ? 'Усі пасували — перездача'           : 'Everyone passed — redeal';
  String get noRoundsYet     => isUk ? 'Ще немає роздач'                    : 'No rounds yet';
  String get tapNewRound     => isUk ? 'Натисни «Нова роздача» нижче'       : 'Tap "New round" below';
  String get badgeBait       => isUk ? 'БАЙТ'                               : 'BAIT';
  String get badgeEggs       => isUk ? 'ЯЙЦЯ'                               : 'EGGS';
  String get pts             => isUk ? 'оч'                                 : 'pts';
  String badgeNoTricks(int points) => isUk ? 'ЛИЖІ −$points'                : 'SKIS −$points';
  String baitsSoFar(int n)   => isUk ? 'байти: $n'                          : 'baits: $n';
  String toGo(int points)    => isUk ? 'ще $points'                         : '$points to go';

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
  String get scoreDisplay    => isUk ? 'Вигляд рахунку'                     : 'Score display';
  String get displayStyle    => isUk ? 'Стиль відображення'                 : 'Display style';
  String get displayStyleDesc => isUk ? 'Як рахунок показується на екрані гри' : 'How score looks on game screen';
  String get circlesSticks   => isUk ? 'Кружечки і палички'                 : 'Circles and sticks';
  String get regularNums     => isUk ? 'Звичайні цифри'                     : 'Regular numbers';
  String get gameValue       => isUk ? 'Скільки йде гра'                    : 'Deal value';
  String get gameValueDesc   => isUk ? 'Як задається, скільки йде роздача з комбінаціями'
                                     : 'How the value of a deal with its declarations is set';
  String get valueCounters   => isUk ? 'Терц, 50, бела'                     : 'Tierce, 50, bella';
  String get valueWheel      => isUk ? 'Колесо: 162, 182, 202…'             : 'Wheel: 162, 182, 202…';
  String get rulesForNewGames => isUk ? 'Правила діють для нових ігор; почата гра лишається на своїх'
                                      : 'The rules apply to new games; a game in progress keeps its own';
  String get language        => isUk ? 'Мова'                             : 'Language';
  String get activeLang      => isUk ? 'Активна мова'                       : 'Active language';

  // Entry panel
  String get newRound        => isUk ? '+ Нова роздача'                     : '+ New round';
  String get trumpTakenBy    => isUk ? 'Козир узяли:'                       : 'Trump taken by:';
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
  String get tierce          => isUk ? 'Терц'                               : 'Tierce';
  String get fifty           => isUk ? 'П\'ятдесят'                         : 'Fifty';
  String get bella           => isUk ? 'Бела'                               : 'Bella';
  /// The name of the declaration [id] of a game's rules.
  String declaration(String id) => switch (id) {
    'tierce' => tierce,
    'fifty'  => fifty,
    'bella'  => bella,
    _        => id,
  };
  String dealValue(int gv)   => isUk ? 'Гра: $gv'                           : 'Deal: $gv';
  String get deberc          => isUk ? 'Деберць'                            : 'Deberc';
  String get debercBy        => isUk ? 'Деберць у'                          : 'Deberc held by';
  String debercWins(String side) => isUk
      ? 'Сім козирів підряд — $side виграють гру'
      : 'Seven trumps in a row — $side win the game';
  String get badgeDeberc     => isUk ? 'ДЕБЕРЦЬ'                            : 'DEBERC';
  String get cancel          => isUk ? 'Скасувати'                          : 'Cancel';
  String get delete          => isUk ? 'Видалити'                           : 'Delete';
  String deleteRoundTitle(int n) => isUk ? 'Видалити роздачу #$n?'          : 'Delete round #$n?';
  String get deleteRoundDesc => isUk ? 'Її очки зникнуть з рахунку.'        : 'Its points will be removed from the score.';
  String editingRound(int n) => isUk ? '✎ Роздача #$n'                      : '✎ Round #$n';
  String get bait            => isUk ? 'Байт'                               : 'Bait';
  String get save            => isUk ? 'Зберегти'                           : 'Save';
}
