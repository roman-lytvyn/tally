import 'models.dart';

/// The languages the app speaks, in the order the settings offer them.
const kLanguages = ['uk', 'en', 'fr', 'bg', 'hr', 'nl', 'ar'];

/// The language an app starts in before one is chosen: the device's own when
/// players of the game commonly use it, English otherwise.
String defaultLanguage(GameRules rules, String deviceLanguage) {
  final native = switch (rules.id) {
    'deberc' => ['uk', 'fr'],
    'belot'  => ['bg'],
    // Bosnian and Serbian readers follow Croatian without effort.
    'bela'   => ['hr', 'bs', 'sr'],
    'klaverjas' => ['nl'],
    'baloot' => ['ar'],
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
  bool get _klaverjas => game.id == 'klaverjas';
  bool get _coinche => game.id == 'coinche';
  bool get _baloot => game.id == 'baloot';

  /// Whether the language is written right to left.
  bool get isRtl => lang == 'ar';

  /// The text in the current language: Ukrainian, English, French, Bulgarian,
  /// Croatian, Dutch or Arabic.
  String _t(String uk, String en, String fr, String bg, String hr, String nl, String ar) => switch (lang) {
    'uk' => uk,
    'fr' => fr,
    'bg' => bg,
    'hr' => hr,
    'nl' => nl,
    'ar' => ar,
    _    => en,
  };

  // Setup
  String get appTitle        => _baloot
      ? _t('Балут', 'Baloot', 'Baloot', 'Балут', 'Baloot', 'Baloot', 'بلوت')
      : _coinche
      ? _t('Куанш', 'Coinche', 'Coinche', 'Коанш', 'Coinche', 'Coinche', 'كوانش')
      : _klaverjas
      ? _t('Клаверяс', 'Klaverjas', 'Klaverjas', 'Клаверяс', 'Klaverjas', 'Klaverjas', 'كلافرياس')
      : _bela
      ? _t('Бела', 'Bela', 'Bela', 'Бела', 'Bela', 'Bela', 'بيلا')
      : _belot
      ? _t('Белот', 'Belot', 'Belot', 'Белот', 'Belot', 'Belot', 'بيلوت')
      : _belote
          ? _t('Белот', 'Belote', 'Belote', 'Белот', 'Belote', 'Belote', 'بيلوت')
          : _t('Деберць', 'Deberc', 'Deberc', 'Деберц', 'Deberc', 'Deberc', 'ديبيرتس');
  String get teams           => _t('Команди', 'Teams', 'Équipes', 'Отбори', 'Ekipe', 'Teams', 'الفرق');
  String get whoDealsFirst   => _t('Хто роздає першим', 'Who deals first', 'Qui distribue en premier', 'Кой раздава пръв', 'Tko prvi dijeli', 'Wie geeft eerst', 'من يوزّع أولاً');
  String get playTo          => _t('Гра до', 'Play to', 'Partie en', 'Игра до', 'Igra do', 'Spelen tot', 'اللعب حتى');
  String get newGame         => _t('Нова гра ♠', 'New game ♠', 'Nouvelle partie ♠', 'Нова игра ♠', 'Nova igra ♠', 'Nieuw spel ♠', 'لعبة جديدة ♠');
  String get continuePrev    => _t('Продовжити попередню →', 'Continue previous →', 'Reprendre la partie →',
      'Продължи предишната →', 'Nastavi prethodnu →', 'Vorig spel hervatten →', 'متابعة اللعبة السابقة ←');
  String get settingsBtn     => _t('⚙ Налаштування', '⚙ Settings', '⚙ Réglages', '⚙ Настройки', '⚙ Postavke', '⚙ Instellingen', '⚙ الإعدادات');
  String get rulesBtn        => _t('📖 Правила', '📖 Rules', '📖 Règles', '📖 Правила', '📖 Pravila', '📖 Regels', '📖 القواعد');
  String get rulesTitle      => _t('Правила', 'Rules', 'Règles', 'Правила', 'Pravila', 'Regels', 'القواعد');
  String get ourTeamHint     => _t('Наша команда', 'Our team', 'Notre équipe', 'Нашият отбор', 'Naša ekipa', 'Ons team', 'فريقنا');
  String get otherTeamHint   => _t('Інша команда', 'Other team', 'L\'autre équipe', 'Другият отбор', 'Druga ekipa', 'Het andere team', 'الفريق الآخر');
  String get players         => _t('Гравці', 'Players', 'Joueurs', 'Играчи', 'Igrači', 'Spelers', 'اللاعبون');
  String get howManyPlay     => _t('Скільки грає', 'How many play', 'Nombre de joueurs', 'Колко играят', 'Koliko igra', 'Aantal spelers', 'عدد اللاعبين');
  String playersOption(int n) => n == 4 ? '2 × 2' : '$n';
  String player(int n)       => _t('Гравець $n', 'Player $n', 'Joueur $n', 'Играч $n', 'Igrač $n', 'Speler $n', 'اللاعب $n');
  /// The names a game starts with: two teams, or one per player.
  List<String> defaultNames(int players) => players == 4
      ? [_t('Ми', 'Us', 'Nous', 'Ние', 'Mi', 'Wij', 'لنا'), _t('Вони', 'Them', 'Eux', 'Те', 'Vi', 'Zij', 'لهم')]
      : [for (var i = 1; i <= players; i++) player(i)];
  /// The [names] as typed, with the default in place of any left blank.
  List<String> namesOrDefaults(List<String> names, int players) {
    final defaults = defaultNames(players);
    return [for (var i = 0; i < names.length; i++) names[i].trim().isEmpty ? defaults[i] : names[i].trim()];
  }
  String nameHint(int players, int side) => players == 4
      ? (side == 0 ? ourTeamHint : otherTeamHint)
      : player(side + 1);
  String get rules           => _t('Правила', 'Rules', 'Règles', 'Правила', 'Pravila', 'Regels', 'القواعد');
  String get dealerMustPlay  => _t('Роздавач зобов\'язаний грати', 'Dealer must play', 'Le donneur doit jouer',
      'Раздаващият е длъжен да играе', 'Djelitelj mora igrati', 'Gever moet spelen', 'الموزّع ملزم باللعب');
  String get dealerMustPlayDesc => _t(
      'Якщо всі спасували, козир бере той, хто роздавав',
      'If everyone passes, the dealer has to take the trump',
      'Si tout le monde passe, le donneur doit prendre l\'atout',
      'Ако всички пасуват, раздаващият трябва да вземе коза', 'Ako svi kažu dalje, djelitelj mora zvati aduta', 'Als iedereen past, moet de gever troef maken', 'إذا مرّر الجميع، يجب على الموزّع أن يأخذ الحكم');

  /// What a lost contract is called in the game.
  String get _lost           => _baloot
      ? _t('програш', 'lost', 'perdu', 'загуба', 'izgubljeno', 'verloren', 'خسران')
      : _coinche
      ? _t('провал', 'down', 'chute', 'провал', 'pad', 'down', 'خسارة')
      : _klaverjas
      ? _t('нат', 'nat', 'nat', 'нат', 'nat', 'nat', 'نات')
      : _bela
      ? _t('пад', 'fall', 'chute', 'пад', 'pad', 'val', 'سقوط')
      : _belot
      ? _t('вътре', 'inside', 'dedans', 'вътре', 'unutra', 'binnen', 'داخل')
      : _belote
          ? _t('дедан', 'dedans', 'dedans', 'дедан', 'dedans', 'dedans', 'دودان')
          : _t('байт', 'bait', 'dedans', 'байт', 'bait', 'bait', 'بايت');
  String get _lostTitle           => _lost[0].toUpperCase() + _lost.substring(1);
  /// What a tied deal is called in the game.
  String get _tie            => _bela || _klaverjas
      ? _t('Нарівно', 'Equal points', 'Égalité', 'Равни', 'Jednako', 'Gelijk', 'تعادل')
      : _belot
      ? _t('Висячі', 'Hanging', 'Litige', 'Висящи', 'Viseći', 'Hangend', 'معلّقة')
      : _belote
          ? _t('Літиж', 'Litige', 'Litige', 'Литиж', 'Litige', 'Litige', 'ليتيج')
          : _t('Яйця', 'Eggs', 'Litige', 'Яйца', 'Jaja', 'Eieren', 'بيض');

  String get tieRuleTitle    => _t('$_tie (нічия)', '$_tie (a tied deal)', '$_tie (égalité)', '$_tie (равенство)', '$_tie (izjednačeno dijeljenje)', '$_tie (gelijkspel)', '$_tie (جولة متعادلة)');
  String tieRuleName(TieRule r) => switch (r) {
    TieRule.hanging          => _t('Висять', 'Held over', 'En suspens', 'Висят', 'Visi', 'Blijft hangen', 'معلّقة'),
    TieRule.opponentsTakeAll => _t('Суперникам', 'To opponents', 'Aux adversaires', 'За противниците', 'Protivnicima', 'Naar de tegenpartij', 'للخصوم'),
    TieRule.eachKeepsOwn     => _t('Кожному своє', 'Each keeps own', 'Chacun ses points', 'Всеки своите', 'Svakom svoje', 'Ieder het zijne', 'لكلٍّ نقاطه'),
  };
  String tieRuleDesc(TieRule r) => switch (r) {
    TieRule.hanging => _t(
        'Суперники записують свої очки, а очки тих, хто грав, переходять до переможця наступної роздачі',
        'The opponents score their points; the trump-taker\'s points go to whoever wins the next deal',
        'Les adversaires marquent leurs points ; ceux du preneur vont au gagnant de la donne suivante',
        'Противниците записват своите точки, а точките на играещите отиват при победителя в следващата раздача', 'Protivnici upisuju svoje bodove, a bodovi onih koji su zvali idu pobjedniku sljedećeg dijeljenja', 'De tegenpartij schrijft haar punten; de punten van de spelende partij gaan naar wie het volgende spel wint', 'يسجّل الخصوم نقاطهم، وتذهب نقاط آخذ الحكم إلى الفائز بالجولة التالية'),
    TieRule.opponentsTakeAll => _t(
        'Нічия — як $_lost: суперники отримують усю гру',
        'A tie counts as $_lost: the opponents get the whole deal',
        'L\'égalité compte comme dedans : les adversaires prennent toute la donne',
        'Равенството се брои за $_lost: противниците получават цялата раздача', 'Izjednačeno se broji kao $_lost: protivnici dobivaju cijelo dijeljenje', 'Gelijk telt als $_lost: de tegenpartij krijgt het hele spel', 'التعادل يُحسب $_lost: يأخذ الخصوم الجولة كلها'),
    TieRule.eachKeepsOwn => _t(
        'Кожна сторона записує те, що набрала',
        'Each side scores what it took',
        'Chaque camp marque ce qu\'il a pris',
        'Всяка страна записва каквото е взела', 'Svaka strana upisuje ono što je uzela', 'Elke partij schrijft wat ze heeft gehaald', 'يسجّل كل طرف ما أخذه'),
  };
  String get finishRuleTitle => _t('Обидві сторони набрали суму гри', 'Both sides pass the target',
      'Les deux camps atteignent le total', 'И двете страни стигат целта', 'Obje strane prijeđu cilj', 'Beide partijen halen het doel', 'تجاوز الطرفان الهدف');
  String finishRuleName(FinishRule r) => switch (r) {
    FinishRule.taker      => _t('Хто грав', 'Trump-taker', 'Le preneur', 'Играещият', 'Tko je zvao', 'Spelende partij', 'آخذ الحكم'),
    FinishRule.mostPoints => _t('Більше очок', 'Most points', 'Le plus de points', 'Повече точки', 'Više bodova', 'Meeste punten', 'الأكثر نقاطاً'),
  };
  String finishRuleDesc(FinishRule r) => switch (r) {
    FinishRule.taker => _t(
        'Перемагає сторона, що взяла козир в останній роздачі, навіть якщо в неї менше очок',
        'The side that took the trump in the last deal wins, even with fewer points',
        'Le camp qui a pris l\'atout à la dernière donne gagne, même avec moins de points',
        'Печели страната, взела коза в последната раздача, дори с по-малко точки', 'Pobjeđuje strana koja je zvala aduta u zadnjem dijeljenju, čak i s manje bodova', 'De partij die in het laatste spel troef maakte wint, ook met minder punten', 'يفوز الطرف الذي أخذ الحكم في الجولة الأخيرة، حتى بنقاط أقل'),
    FinishRule.mostPoints => _t(
        'Перемагає сторона, в якої більше очок; за рівного рахунку гра триває',
        'The side with more points wins; on an equal score play goes on',
        'Le camp qui a le plus de points gagne ; à égalité la partie continue',
        'Печели страната с повече точки; при равен резултат играта продължава', 'Pobjeđuje strana s više bodova; kod jednakog rezultata igra se dalje', 'De partij met de meeste punten wint; bij gelijke stand wordt doorgespeeld', 'يفوز الطرف صاحب النقاط الأكثر؛ وعند التساوي يستمر اللعب'),
  };
  String get baitPenaltyTitle => _t('Штраф за байти', 'Penalty for bait', 'Pénalité pour dedans', 'Наказание за байт', 'Kazna za pad', 'Straf voor nat', 'عقوبة الخسارة');
  String baitPenaltyName(BaitPenalty p) => switch (p) {
    BaitPenalty.none          => _t('Немає', 'None', 'Aucune', 'Няма', 'Nema', 'Geen', 'لا شيء'),
    BaitPenalty.third         => _t('Третій', 'The third', 'Le troisième', 'Третият', 'Treći', 'De derde', 'الثالثة'),
    BaitPenalty.thirdAndAfter => _t('Третій і далі', 'Third and after', 'Le 3e et suivants', 'Третият и след него', 'Treći i dalje', 'De derde en verder', 'الثالثة وما بعدها'),
    BaitPenalty.everyThird    => _t('Кожен третій', 'Every third', 'Chaque 3e', 'Всеки трети', 'Svaki treći', 'Elke derde', 'كل ثالثة'),
  };
  String baitPenaltyDesc(BaitPenalty p, int points) => switch (p) {
    BaitPenalty.none => _t(
        'Байт коштує лише програної роздачі',
        'Bait costs nothing more than the lost deal',
        'Un dedans ne coûte que la donne perdue',
        'Байтът струва само загубената раздача', 'Pad ne košta ništa osim izgubljenog dijeljenja', 'Nat kost niets meer dan het verloren spel', 'الخسارة لا تكلّف أكثر من الجولة الخاسرة'),
    BaitPenalty.third => _t(
        'За третій байт сторона втрачає ще $points очок',
        'A side loses $points more points for its third bait',
        'Un camp perd $points points de plus à son troisième dedans',
        'За третия байт страната губи още $points точки', 'Za treći pad strana gubi još $points bodova', 'Een partij verliest $points punten extra bij haar derde keer nat', 'يخسر الطرف $points نقطة إضافية عند خسارته الثالثة'),
    BaitPenalty.thirdAndAfter => _t(
        'За третій і кожен наступний байт сторона втрачає ще по $points очок',
        'A side loses $points more points for its third bait and each one after it',
        'Un camp perd $points points de plus à son troisième dedans et à chacun des suivants',
        'За третия и всеки следващ байт страната губи още по $points точки', 'Za treći i svaki sljedeći pad strana gubi još po $points bodova', 'Een partij verliest $points punten extra bij haar derde keer nat en elke keer daarna', 'يخسر الطرف $points نقطة إضافية عند خسارته الثالثة وكل خسارة بعدها'),
    BaitPenalty.everyThird => _t(
        'За кожен третій байт — третій, шостий, дев\'ятий — сторона втрачає ще $points очок',
        'A side loses $points more points for every third bait: the third, sixth, ninth',
        'Un camp perd $points points de plus à chaque troisième dedans : le 3e, le 6e, le 9e',
        'За всеки трети байт — третия, шестия, деветия — страната губи още $points точки', 'Za svaki treći pad — treći, šesti, deveti — strana gubi još $points bodova', 'Een partij verliest $points punten extra bij elke derde keer nat: de derde, zesde, negende', 'يخسر الطرف $points نقطة إضافية عند كل خسارة ثالثة: الثالثة والسادسة والتاسعة'),
  };
  String get penaltySize     => _t('Розмір штрафу', 'Penalty size', 'Montant de la pénalité', 'Размер на наказанието', 'Iznos kazne', 'Hoogte van de straf', 'مقدار العقوبة');
  String get points          => _t('очок', 'points', 'points', 'точки', 'bodova', 'punten', 'نقطة');
  String get baitsCountTitle => _t('Байти рахуються', 'Baits are counted', 'Les dedans se comptent', 'Байтовете се броят', 'Padovi se broje', 'Nat wordt geteld', 'تُحسب الخسارات');
  String get baitsPerGame    => _t('За всю гру', 'Over the game', 'Sur la partie', 'За цялата игра', 'Kroz cijelu igru', 'Over het hele spel', 'على مدى اللعبة');
  String get baitsInARow     => _t('Лише підряд', 'Only in a row', 'Seulement d\'affilée', 'Само поред', 'Samo zaredom', 'Alleen achter elkaar', 'المتتالية فقط');
  String baitsCountDesc(bool inARow) => inARow
      ? _t('Рахунок байтів починається знову, щойно сторона зіграє роздачу без байта',
          'The count starts again once the side plays a deal without bait',
          'Le compte repart dès que le camp joue une donne sans dedans',
          'Броят започва отначало, щом страната изиграе раздача без байт', 'Brojanje kreće iznova čim strana odigra dijeljenje bez pada', 'De telling begint opnieuw zodra de partij een spel speelt zonder nat', 'يبدأ العدّ من جديد حين يلعب الطرف جولة بلا خسارة')
      : _t('Рахуються всі байти сторони за гру, не обов\'язково підряд',
          'All of a side\'s baits in the game count, not only those in a row',
          'Tous les dedans du camp dans la partie comptent, pas seulement ceux d\'affilée',
          'Броят се всички байтове на страната в играта, не само поредните', 'Broje se svi padovi strane u igri, ne samo oni zaredom', 'Alle keren nat van een partij in het spel tellen, niet alleen die achter elkaar', 'تُحسب كل خسارات الطرف في اللعبة، لا المتتالية فقط');
  String get noTricksTitle   => _t('Лижі — жодної взятки', 'Skis — no tricks taken', 'Aucun pli',
      'Ски — нито една взятка', 'Bez ijednog štiha', 'Geen enkele slag', 'بلا أكلة واحدة');
  String get noPenalty       => _t('Немає', 'None', 'Aucune', 'Няма', 'Nema', 'Geen', 'لا شيء');
  String noTricksDesc(int points) => points == 0
      ? _t('Роздача без жодної взятки нічого не коштує', 'A deal without a trick costs nothing more',
          'Une donne sans pli ne coûte rien de plus', 'Раздача без взятка не струва нищо повече', 'Dijeljenje bez štiha ne košta ništa više', 'Een spel zonder slag kost niets extra', 'الجولة بلا أكلة لا تكلّف شيئاً إضافياً')
      : _t('Сторона, що за роздачу не взяла жодної взятки (записано 0 очок), втрачає $points очок',
          'A side that took no tricks in a deal (0 points entered) loses $points points',
          'Un camp qui n\'a fait aucun pli dans une donne (0 point saisi) perd $points points',
          'Страна без нито една взятка в раздачата (записани 0 точки) губи $points точки', 'Strana koja u dijeljenju nije uzela nijedan štih (upisano 0 bodova) gubi $points bodova', 'Een partij die in een spel geen slag haalde (0 punten ingevuld) verliest $points punten', 'الطرف الذي لم يأخذ أي أكلة في الجولة (أُدخل 0) يخسر $points نقطة');

  // Game
  String get exitBtn         => _t('← Вихід', '← Exit', '← Quitter', '← Изход', '← Izlaz', '← Stoppen', '→ خروج');
  String get undoBtn         => '↶';
  String get deals           => _t('роздає', 'deals', 'donne', 'раздава', 'dijeli', 'geeft', 'يوزّع');
  String get badgeRedeal     => _t('ПЕРЕЗДАЧА', 'REDEAL', 'REDONNE', 'ПРЕРАЗДАВАНЕ', 'NOVO DIJELJENJE', 'OPNIEUW GEVEN', 'إعادة توزيع');
  String get allPassed       => _t('Усі пасували — перездача', 'Everyone passed — redeal', 'Tout le monde passe — redonne',
      'Всички пас — нова раздача', 'Svi su rekli dalje — dijeli se ponovo', 'Iedereen past — opnieuw geven', 'مرّر الجميع — إعادة توزيع');
  String get noRoundsYet     => _t('Ще немає роздач', 'No rounds yet', 'Aucune donne pour l\'instant',
      'Още няма раздавания', 'Još nema dijeljenja', 'Nog geen spellen', 'لا جولات بعد');
  String get tapNewRound     => _t('Натисни «Нова роздача» нижче', 'Tap "New round" below',
      'Appuyez sur « Nouvelle donne » ci-dessous', 'Натисни „Нова раздача“ отдолу', 'Dodirni „Novo dijeljenje” ispod', 'Tik hieronder op „Nieuw spel”', 'اضغط «جولة جديدة» في الأسفل');
  String get badgeBait       => _lost.toUpperCase();
  String get badgeEggs       => _tie.toUpperCase();
  String get pts             => _t('оч', 'pts', 'pts', 'т.', 'b.', 'pt', 'ن');
  String badgeNoTricks(int points) => _t('ЛИЖІ −$points', 'SKIS −$points', 'SANS PLI −$points', 'СКИ −$points', 'BEZ ŠTIHA −$points', 'GEEN SLAG −$points', 'بلا أكلة −$points');
  String baitsSoFar(int n)   => _baloot
      ? _t('програші: $n', 'lost: $n', 'perdus : $n', 'загуби: $n', 'izgubljeno: $n', 'verloren: $n', 'خسران: $n')
      : _coinche
      ? _t('провали: $n', 'down: $n', 'chutes : $n', 'провали: $n', 'padovi: $n', 'down: $n', 'خسارات: $n')
      : _klaverjas
      ? _t('нат: $n', 'nat: $n', 'nat : $n', 'нат: $n', 'nat: $n', 'nat: $n', 'نات: $n')
      : _bela
      ? _t('пади: $n', 'falls: $n', 'chutes : $n', 'падове: $n', 'padovi: $n', 'vallen: $n', 'سقوط: $n')
      : _belote
      ? _t('дедани: $n', 'dedans: $n', 'dedans : $n', 'дедани: $n', 'dedans: $n', 'dedans: $n', 'دودان: $n')
      : _t('байти: $n', 'baits: $n', 'dedans : $n', 'байтове: $n', 'baitovi: $n', 'keer nat: $n', 'خسارات: $n');
  String toGo(int points)    => _t('ще $points', '$points to go', 'encore $points', 'още $points', 'još $points', 'nog $points', 'باقي $points');

  // Win
  String get winLabel        => _t('перемагають!', 'win!', 'gagnent !', 'печелят!', 'pobjeđuju!', 'winnen!', 'يفوزون!');
  String get winLabelOne     => _t('перемагає!', 'wins!', 'gagne !', 'печели!', 'pobjeđuje!', 'wint!', 'يفوز!');
  String get finalScore      => _t('Фінальний рахунок', 'Final score', 'Score final', 'Краен резултат', 'Konačni rezultat', 'Eindstand', 'النتيجة النهائية');
  String get undoLastRound   => _t('↶ Скасувати останню роздачу', '↶ Undo the last round', '↶ Annuler la dernière donne',
      '↶ Отмени последната раздача', '↶ Poništi zadnje dijeljenje', '↶ Laatste spel ongedaan maken', '↶ تراجع عن الجولة الأخيرة');

  // Settings
  String get settingsTitle   => _t('Налаштування', 'Settings', 'Réglages', 'Настройки', 'Postavke', 'Instellingen', 'الإعدادات');
  String get backBtn         => _t('← Назад', '← Back', '← Retour', '← Назад', '← Natrag', '← Terug', '→ رجوع');
  String get appearance      => _t('Зовнішній вигляд', 'Appearance', 'Apparence', 'Външен вид', 'Izgled', 'Weergave', 'المظهر');
  String get themeLabel      => _t('Тема', 'Theme', 'Thème', 'Тема', 'Tema', 'Thema', 'السمة');
  String get themeLight      => _t('Світла', 'Light', 'Clair', 'Светла', 'Svijetla', 'Licht', 'فاتحة');
  String get themeDark       => _t('Темна', 'Dark', 'Sombre', 'Тъмна', 'Tamna', 'Donker', 'داكنة');
  String get scoreDisplay    => _t('Вигляд рахунку', 'Score display', 'Affichage du score', 'Изглед на резултата', 'Prikaz rezultata', 'Weergave van de stand', 'عرض النتيجة');
  String get displayStyle    => _t('Стиль відображення', 'Display style', 'Style d\'affichage', 'Стил на показване', 'Stil prikaza', 'Weergavestijl', 'نمط العرض');
  String get displayStyleDesc => _t('Як рахунок показується на екрані гри', 'How score looks on game screen',
      'Comment le score apparaît à l\'écran de jeu', 'Как изглежда резултатът на екрана на играта', 'Kako rezultat izgleda na zaslonu igre', 'Hoe de stand eruitziet op het spelscherm', 'كيف تظهر النتيجة في شاشة اللعب');
  String get circlesSticks   => _t('Кружечки і палички', 'Circles and sticks', 'Ronds et bâtons', 'Кръгчета и чертички', 'Kružići i crtice', 'Rondjes en streepjes', 'دوائر وعصي');
  String get regularNums     => _t('Звичайні цифри', 'Regular numbers', 'Chiffres', 'Обикновени цифри', 'Obični brojevi', 'Gewone cijfers', 'أرقام عادية');
  String get gameValue       => _t('Скільки йде гра', 'Deal value', 'Valeur de la donne', 'Стойност на раздачата', 'Vrijednost dijeljenja', 'Waarde van het spel', 'قيمة الجولة');
  String get gameValueDesc   => _t('Як задається, скільки йде роздача з комбінаціями',
      'How the value of a deal with its declarations is set',
      'Comment se fixe la valeur d\'une donne avec ses annonces',
      'Как се задава стойността на раздача с обявите ѝ', 'Kako se zadaje vrijednost dijeljenja sa zvanjima', 'Hoe de waarde van een spel met zijn roem wordt bepaald', 'كيف تُحدَّد قيمة الجولة مع مشاريعها');
  String get valueCounters   => _klaverjas
      ? _t('Терц, 50, 100, стук', 'Tierce, 50, 100, stuk', 'Tierce, 50, 100, stuk', 'Терца, 50, 100, стук', 'Terca, 50, 100, stuk', 'Roem: 20, 50, 100, stuk', 'سرا، 50، 100، ستوك')
      : _belote || _coinche
      ? _t('Терц, 50, 100, белот', 'Tierce, 50, 100, belote', 'Tierce, 50, 100, belote', 'Терца, 50, 100, белот', 'Terca, 50, 100, belote', 'Terts, 50, 100, belote', 'سرا، 50، 100، بيلوت')
      : _t('Терц, 50, бела', 'Tierce, 50, bella', 'Tierce, 50, bella', 'Терца, 50, бела', 'Terca, 50, bela', 'Terts, 50, bella', 'سرا، 50، بيلا');
  String get valueWheel      => _t('Колесо: 162, 182, 202…', 'Wheel: 162, 182, 202…', 'Roue : 162, 182, 202…',
      'Колело: 162, 182, 202…', 'Kotačić: 162, 182, 202…', 'Wiel: 162, 182, 202…', 'عجلة: 162، 182، 202…');
  String get rulesForNewGames => _t('Правила діють для нових ігор; почата гра лишається на своїх',
      'The rules apply to new games; a game in progress keeps its own',
      'Les règles valent pour les nouvelles parties ; une partie en cours garde les siennes',
      'Правилата важат за новите игри; започнатата игра запазва своите', 'Pravila vrijede za nove igre; započeta igra zadržava svoja', 'De regels gelden voor nieuwe spellen; een lopend spel houdt zijn eigen regels', 'تنطبق القواعد على الألعاب الجديدة؛ اللعبة الجارية تحتفظ بقواعدها');
  String get language        => _t('Мова', 'Language', 'Langue', 'Език', 'Jezik', 'Taal', 'اللغة');
  String get activeLang      => _t('Активна мова', 'Active language', 'Langue active', 'Активен език', 'Aktivni jezik', 'Actieve taal', 'اللغة الحالية');
  /// The name of the language [code] in that language itself.
  static String languageName(String code) => switch (code) {
    'uk' => 'Українська',
    'fr' => 'Français',
    'bg' => 'Български',
    'hr' => 'Hrvatski',
    'nl' => 'Nederlands',
    'ar' => 'العربية',
    _    => 'English',
  };
  static String languageFlag(String code) => switch (code) {
    'uk' => '🇺🇦',
    'fr' => '🇫🇷',
    'bg' => '🇧🇬',
    'hr' => '🇭🇷',
    'nl' => '🇳🇱',
    'ar' => '🇸🇦',
    _    => '🇬🇧',
  };

  // Entry panel
  String get newRound        => _t('+ Нова роздача', '+ New round', '+ Nouvelle donne', '+ Нова раздача', '+ Novo dijeljenje', '+ Nieuw spel', '+ جولة جديدة');
  String get declarations    => _baloot
      ? _t('Проєкти', 'Projects', 'Projets', 'Проекти', 'Projekti', 'Projecten', 'المشاريع')
      : _t('Комбінації', 'Declarations', 'Annonces', 'Анонси', 'Zvanja', 'Roem', 'المشاريع');
  String get done            => _t('Готово', 'Done', 'OK', 'Готово', 'Gotovo', 'Klaar', 'تم');
  String get trumpTakenBy    => _baloot
      ? _t('Купили:', 'Bought by:', 'Acheté par :', 'Купиха:', 'Kupili su:', 'Gekocht door:', 'المشتري:')
      : _t('Козир узяли:', 'Trump taken by:', 'Atout pris par :', 'Коз взеха:', 'Aduta su zvali:', 'Troef gemaakt door:', 'أخذ الحكم:');
  String eggsMsg(TieRule rule, int points, String opponents) => switch (rule) {
    TieRule.hanging => _t(
        '$_tie! $points очок висять до наступної роздачі',
        '$_tie! $points points are held until the next deal',
        '$_tie ! $points points restent en suspens jusqu\'à la donne suivante',
        '$_tie! $points точки висят до следващата раздача', '$_tie! $points bodova visi do sljedećeg dijeljenja', '$_tie! $points punten blijven hangen tot het volgende spel', '$_tie! $points نقطة معلّقة حتى الجولة التالية'),
    TieRule.opponentsTakeAll => _t(
        '$_tie! Усю гру отримують $opponents',
        '$_tie! $opponents get the whole deal',
        '$_tie ! $opponents prennent toute la donne',
        '$_tie! Цялата раздача получават $opponents', '$_tie! Cijelo dijeljenje dobivaju $opponents', '$_tie! $opponents krijgen het hele spel', '$_tie! يأخذ $opponents الجولة كلها'),
    TieRule.eachKeepsOwn => _t(
        '$_tie! Кожному по $points',
        '$_tie! $points each',
        '$_tie ! $points chacun',
        '$_tie! По $points за всеки', '$_tie! Svakome po $points', '$_tie! Ieder $points', '$_tie! $points لكل طرف'),
  };
  String heldMsg(int points) => _t(
      '🥚 $points очок чекають на переможця наступної роздачі',
      '🥚 $points points go to the winner of the next deal',
      '🥚 $points points iront au gagnant de la donne suivante',
      '🥚 $points точки отиват при победителя в следващата раздача', '🥚 $points bodova ide pobjedniku sljedećeg dijeljenja', '🥚 $points punten gaan naar de winnaar van het volgende spel', '🥚 $points نقطة تذهب إلى الفائز بالجولة التالية');
  String baitMsg(String opponents, int gv) => _t(
      '$_lostTitle! Усі $gv отримують $opponents',
      '$_lostTitle! $opponents get all $gv',
      '$_lostTitle ! $opponents prennent les $gv',
      '$_lostTitle! Всичките $gv получават $opponents', '$_lostTitle! Svih $gv dobivaju $opponents', '$_lostTitle! $opponents krijgen alle $gv', '$_lostTitle! يأخذ $opponents كل الـ $gv');
  String get tierce          => _t('Терц', 'Tierce', 'Tierce', 'Терца', 'Terca', 'Drie op een rij', 'سرا');
  String get fifty           => _t('П\'ятдесят', 'Fifty', 'Cinquante', 'Кварта', 'Pedeset', 'Vier op een rij', 'خمسين');
  String get bella           => _t('Бела', 'Bella', 'Bella', 'Бела', 'Bela', 'Bella', 'بيلا');
  /// The name of the declaration [id] of a game's rules.
  String declaration(String id) => switch (id) {
    'tierce'  => tierce,
    'sira'    => _t('Сира', 'Sira', 'Sira', 'Сира', 'Sira', 'Sira', 'سرا'),
    'fourHundred' => _t('Чотириста', 'Four hundred', 'Quatre cents', 'Четиристотин', 'Četiristo', 'Vierhonderd', 'أربعمية'),
    'baloot'  => _t('Балут', 'Baloot', 'Baloot', 'Балут', 'Baloot', 'Baloot', 'بلوت'),
    'valat' when _baloot => _t('Кабут', 'Kaboot', 'Kaboot', 'Кабут', 'Kaboot', 'Kaboot', 'كبوت'),
    'fifty'   => fifty,
    'bella'   => bella,
    'hundred' => _t('Сотня', 'Hundred', 'Cent', 'Сто', 'Sto', 'Honderd', 'مية'),
    'belote'  => _t('Белот', 'Belote', 'Belote', 'Белот', 'Belote', 'Belote', 'بيلوت'),
    'jacks'   => _t('Каре В', 'Carré J', 'Carré V', 'Каре вале', 'Četiri dečka', 'Vier boeren', 'أربعة أولاد'),
    'nines'   => _t('Каре 9', 'Carré 9', 'Carré 9', 'Каре деветки', 'Četiri devetke', 'Vier negens', 'أربع تسعات'),
    'capot'   => _t('Капот', 'Capot', 'Capot', 'Капот', 'Capot', 'Capot', 'كابو'),
    'belot'   => _t('Белот', 'Belot', 'Belote', 'Белот', 'Belot', 'Belot', 'بيلوت'),
    'valat'   => _t('Валат', 'Valat', 'Capot', 'Валат', 'Valat', 'Valat', 'كبوت'),
    'stiglja' => _t('Штиґля', 'Štiglja', 'Štiglja', 'Щигля', 'Štiglja', 'Štiglja', 'شتيليا'),
    'stuk'    => _t('Стук', 'Stuk', 'Stuk', 'Стук', 'Stuk', 'Stuk', 'ستوك'),
    'pit'     => _t('Піт', 'Pit', 'Pit', 'Пит', 'Pit', 'Pit', 'بيت'),
    _         => id,
  };
  /// The name of the contract [id] in the entry panel.
  String contractName(String id) => switch (id) {
    'hokm'      => _t('Хокм', 'Hokm', 'Hokm', 'Хокм', 'Hokm', 'Hokm', 'حكم'),
    'sun'       => _t('Сан', 'Sun', 'Sun', 'Сан', 'Sun', 'Sun', 'صن'),
    'noTrumps'  => _t('Без козиря', 'No trumps', 'Sans atout', 'Без коз', 'Bez aduta', 'Zonder troef', 'بلا حكم'),
    'allTrumps' => _t('Всі козирі', 'All trumps', 'Tout atout', 'Всичко коз', 'Sve aduti', 'Alles troef', 'كله حكم'),
    _           => _t('Масть', 'Suit', 'Couleur', 'Боя', 'Boja', 'Kleur', 'لون'),
  };
  /// The contract [id] as it is marked in the list of deals.
  String contractShort(String id) => switch (id) {
    'hokm'      => _t('Хокм', 'Hokm', 'Hokm', 'Хокм', 'Hokm', 'Hokm', 'حكم'),
    'sun'       => _t('Сан', 'Sun', 'Sun', 'Сан', 'Sun', 'Sun', 'صن'),
    'noTrumps'  => _t('БК', 'NT', 'SA', 'БК', 'BA', 'ZT', 'ب.ح'),
    'allTrumps' => _t('ВК', 'AT', 'TA', 'ВК', 'SA', 'AT', 'ك.ح'),
    _           => _t('Масть', 'Suit', 'Coul.', 'Боя', 'Boja', 'Kleur', 'لون'),
  };
  /// What the side that won the bidding undertook to make.
  String get bid             => _t('Замовлення', 'Bid', 'Contrat', 'Обява', 'Licitacija', 'Bod', 'الطلب');
  /// The bid [points] as it is shown: its value, or capot.
  String bidName(int points) => points == kCapot ? declaration('capot') : '$points';
  /// A doubled contract when [doubling] is 2, a redoubled one when it is 4;
  /// in Baloot also a three, or a gahwa.
  String doublingName(int doubling) => _baloot
      ? switch (doubling) {
          3 => _t('Тріо', 'Three', 'Trois', 'Три', 'Tri', 'Drie', 'ثري'),
          4 => _t('Фор', 'Four', 'Quatre', 'Четири', 'Četiri', 'Vier', 'فور'),
          kGahwa => _t('Кахва', 'Gahwa', 'Gahwa', 'Кахва', 'Gahwa', 'Gahwa', 'قهوة'),
          _ => _t('Дабл', 'Double', 'Double', 'Дабъл', 'Dupla', 'Dubbel', 'دبل'),
        }
      : _coinche
      ? doubling == 4
          ? _t('Сюркуанш', 'Surcoinche', 'Surcoinche', 'Сюркоанш', 'Surcoinche', 'Surcoinche', 'سوركوانش')
          : _t('Куанш', 'Coinche', 'Coinche', 'Коанш', 'Coinche', 'Coinche', 'كوانش')
      : doubling == 4
      ? _t('Реконтра', 'Re-contra', 'Surcontre', 'Реконтра', 'Rekontra', 'Rekontra', 'ري-كونترا')
      : _t('Контра', 'Contra', 'Contre', 'Контра', 'Kontra', 'Kontra', 'كونترا');
  /// How a doubling is marked next to a deal.
  String doublingMark(int doubling) => doubling == kGahwa ? '☕' : '×$doubling';
  String gahwaWins(String side) => _t(
      'Кахва — $side виграють партію',
      'Gahwa — $side win the match',
      'Gahwa — $side gagnent la partie',
      'Кахва — $side печелят играта', 'Gahwa — $side pobjeđuju u igri', 'Gahwa — $side winnen het spel', 'قهوة — $side يفوزون باللعبة');
  String takesAllMsg(String side, int points) => _t(
      'Усі $points отримують $side',
      '$side get all $points',
      '$side prennent les $points',
      'Всичките $points получават $side', 'Svih $points dobivaju $side', '$side krijgen alle $points', 'يأخذ $side كل الـ $points');
  /// The game points a deal adds to each side.
  String recordedMsg(List<int> points) =>
      _t('До рахунку: ', 'Scores: ', 'Au score : ', 'Записва се: ', 'U rezultat: ', 'In de stand: ', 'إلى النتيجة: ') + points.join(' : ');
  /// The label before the side that holds the declaration [name].
  String heldBy(String name) => _t('$name у', '$name held by', '$name chez', '$name у', '$name kod', '$name bij', '$name عند');
  String dealValue(int gv)   => _t('Гра: $gv', 'Deal: $gv', 'Donne : $gv', 'Раздача: $gv', 'Dijeljenje: $gv', 'Spel: $gv', 'الجولة: $gv');
  /// The hand that wins the game on its own: a deberc, or a belot in Bela.
  String get deberc          => _bela
      ? _t('Белот', 'Belot', 'Belote', 'Белот', 'Belot', 'Belot', 'بيلوت')
      : _t('Деберць', 'Deberc', 'Deberc', 'Деберц', 'Deberc', 'Deberc', 'ديبيرتس');
  String get debercBy        => _bela
      ? _t('Белот у', 'Belot held by', 'Belote chez', 'Белот у', 'Belot kod', 'Belot bij', 'البيلوت عند')
      : _t('Деберць у', 'Deberc held by', 'Deberc chez', 'Деберц у', 'Deberc kod', 'Deberc bij', 'الديبيرتس عند');
  String debercWins(String side) => _bela
      ? _t(
          'Усі вісім карт однієї масті — $side виграють гру',
          'All eight cards of one suit — $side win the game',
          'Les huit cartes d\'une couleur — $side gagnent la partie',
          'Осемте карти от една боя — $side печелят играта', 'Svih osam karata jedne boje — $side pobjeđuju', 'Alle acht kaarten van één kleur — $side winnen het spel', 'ثماني أوراق من لون واحد — $side يفوزون باللعبة')
      : _t(
      'Сім козирів підряд — $side виграють гру',
      'Seven trumps in a row — $side win the game',
      'Sept atouts de suite — $side gagnent la partie',
      'Седем поредни коза — $side печелят играта', 'Sedam aduta zaredom — $side pobjeđuju u igri', 'Zeven troeven op een rij — $side winnen het spel', 'سبعة حكم متتالية — $side يفوزون باللعبة');
  String get badgeDeberc     => deberc.toUpperCase();
  String get cancel          => _t('Скасувати', 'Cancel', 'Annuler', 'Отказ', 'Odustani', 'Annuleren', 'إلغاء');
  String get delete          => _t('Видалити', 'Delete', 'Supprimer', 'Изтрий', 'Izbriši', 'Verwijderen', 'حذف');
  String deleteRoundTitle(int n) => _t('Видалити роздачу #$n?', 'Delete round #$n?', 'Supprimer la donne n° $n ?',
      'Да се изтрие ли раздача №$n?', 'Izbrisati dijeljenje #$n?', 'Spel #$n verwijderen?', 'حذف الجولة رقم $n؟');
  String get deleteRoundDesc => _t('Її очки зникнуть з рахунку.', 'Its points will be removed from the score.',
      'Ses points seront retirés du score.', 'Точките ѝ ще бъдат махнати от резултата.', 'Njegovi bodovi bit će uklonjeni iz rezultata.', 'De punten ervan verdwijnen uit de stand.', 'ستُحذف نقاطها من النتيجة.');
  String editingRound(int n) => _t('✎ Роздача #$n', '✎ Round #$n', '✎ Donne n° $n', '✎ Раздача №$n', '✎ Dijeljenje #$n', '✎ Spel #$n', '✎ الجولة رقم $n');
  String get bait            => _lostTitle;
  String get save            => _t('Зберегти', 'Save', 'Enregistrer', 'Запази', 'Spremi', 'Opslaan', 'حفظ');
}
