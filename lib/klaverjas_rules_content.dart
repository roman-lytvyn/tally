import 'rules_content.dart';

/// The rules of Klaverjas in [lang], English when there is none.
List<RulesSection> klaverjasRulesContent(String lang) => switch (lang) {
  'nl' => _nl,
  'uk' => _uk,
  _    => _en,
};

const _en = [
  RulesSection('Players and cards', [
    'Klaverjas is played by four in two teams of two, partners sitting opposite each other, with a 32-card deck, '
        'seven to ace in each suit. Every player gets eight cards.',
    'The side that chooses the trump is the playing side; the other side tries to stop it. Tables choose the trump '
        'in different ways: in turn, by a turned-up card, or with the first player obliged to choose one.',
  ]),
  RulesSection('Card values', [
    'The last trick adds 10, so the cards of a deal are worth 162 points. The jack of trumps is called the jas, '
        'the nine of trumps the nel.',
  ], tableHeader: ['Card', 'Trump', 'Other suit'], table: [
    ['Jack', '20', '2'],
    ['Nine', '14', '0'],
    ['Ace', '11', '11'],
    ['Ten', '10', '10'],
    ['King', '4', '4'],
    ['Queen', '3', '3'],
    ['Eight, seven', '0', '0'],
  ]),
  RulesSection('Amsterdam and Rotterdam rules', [
    'There are two main ways to play. In both, a player has to follow suit and, when unable to, has to trump, '
        'overtrumping a trump already played if possible.',
    'In the Rotterdam rules a player has to trump even when the partner is already winning the trick. In the '
        'Amsterdam rules that is not required: a player whose partner is winning may play any card.',
    'The app follows the Amsterdam rules. The difference lies only in the play, so the score is kept the same way '
        'under both.',
  ]),
  RulesSection('Roem', [
    'Roem is counted in the tricks: the side that wins a trick scores the roem among its four cards. Runs count '
        'in the order seven, eight, nine, ten, jack, queen, king, ace, within one suit. The roem is added to the '
        'value of the deal.',
  ], tableHeader: ['Roem', 'Points'], table: [
    ['Three in a row', '20'],
    ['Four in a row', '50'],
    ['Four aces, kings, queens or tens', '100'],
    ['Four jacks', '200'],
    ['Stuk — king and queen of trumps', '20'],
  ]),
  RulesSection('Pit', [
    'A side that takes all eight tricks makes pit and scores 100 more on top of the 162 of the cards.',
  ]),
  RulesSection('Nat', [
    'The playing side has to score more than its opponents, roem included. If it does not, it goes nat: the '
        'opponents get the 162 of the cards and all the roem of the deal, the playing side\'s too, and the playing '
        'side gets nothing. Equal points also count as nat.',
  ]),
  RulesSection('Winning', [
    'A game often runs for an agreed number of deals, usually sixteen, after which the higher total wins; many '
        'tables play to 1500 points instead. The app plays to 1500: the first side to reach it wins, and when both '
        'reach it in the same deal, the higher score wins.',
  ]),
  RulesSection('Keeping the score in the app', [
    'After each deal tap "New round", pick the playing side, count the roem and type the points of one side; the '
        'app works out the rest, spots nat and keeps track of who deals.',
    'Tap any deal in the history to correct or delete it, and ↶ to undo the last one.',
  ]),
];

const _nl = [
  RulesSection('Spelers en kaarten', [
    'Klaverjassen speel je met vier in twee teams van twee, partners tegenover elkaar, met een spel van 32 kaarten, '
        'zeven tot en met aas in elke kleur. Iedere speler krijgt acht kaarten.',
    'De partij die troef maakt is de spelende partij; de andere partij probeert haar tegen te houden. Hoe troef '
        'wordt gekozen verschilt per tafel: om de beurt, met een opengedraaide kaart, of verplicht door de eerste '
        'speler.',
  ]),
  RulesSection('Waarde van de kaarten', [
    'De laatste slag telt 10 punten, dus de kaarten van een spel zijn samen 162 punten waard. De troefboer heet de '
        'jas, de troefnegen de nel.',
  ], tableHeader: ['Kaart', 'Troef', 'Andere kleur'], table: [
    ['Boer', '20', '2'],
    ['Negen', '14', '0'],
    ['Aas', '11', '11'],
    ['Tien', '10', '10'],
    ['Heer', '4', '4'],
    ['Vrouw', '3', '3'],
    ['Acht, zeven', '0', '0'],
  ]),
  RulesSection('Amsterdams en Rotterdams', [
    'Er zijn twee hoofdvormen. In beide moet je kleur bekennen en, als dat niet kan, troeven, en waar mogelijk '
        'overtroeven als er al getroefd is.',
    'Bij Rotterdams moet je ook troeven als je partner de slag al heeft. Bij Amsterdams hoeft dat niet: als je '
        'partner de slag heeft, mag je elke kaart bijspelen.',
    'De app volgt de Amsterdamse regels. Het verschil zit alleen in het spelen, dus de telling is bij beide '
        'hetzelfde.',
  ]),
  RulesSection('Roem', [
    'Roem wordt in de slagen geteld: de partij die een slag haalt, krijgt de roem in de vier kaarten van die slag. '
        'Een reeks telt in de volgorde zeven, acht, negen, tien, boer, vrouw, heer, aas, in één kleur. De roem komt '
        'bij de waarde van het spel.',
  ], tableHeader: ['Roem', 'Punten'], table: [
    ['Drie op een rij', '20'],
    ['Vier op een rij', '50'],
    ['Vier azen, heren, vrouwen of tienen', '100'],
    ['Vier boeren', '200'],
    ['Stuk — troefheer en troefvrouw', '20'],
  ]),
  RulesSection('Pit', [
    'Een partij die alle acht slagen haalt, is pit en krijgt 100 punten extra bovenop de 162 van de kaarten.',
  ]),
  RulesSection('Nat', [
    'De spelende partij moet meer punten halen dan de tegenpartij, roem meegeteld. Lukt dat niet, dan gaat ze nat: '
        'de tegenpartij krijgt de 162 van de kaarten en alle roem van het spel, ook die van de spelende partij, en de '
        'spelende partij krijgt niets. Bij gelijke punten is de spelende partij ook nat.',
  ]),
  RulesSection('Winnen', [
    'Vaak wordt een afgesproken aantal spellen gespeeld, meestal zestien, waarna het hoogste totaal wint; veel '
        'tafels spelen in plaats daarvan tot 1500 punten. De app speelt tot 1500: de partij die dat het eerst haalt, '
        'wint, en halen beide het in hetzelfde spel, dan wint de hoogste stand.',
  ]),
  RulesSection('De stand bijhouden in de app', [
    'Tik na elk spel op „Nieuw spel”, kies de spelende partij, tel de roem en vul de punten van één partij in; de '
        'app rekent de rest uit, ziet wanneer iemand nat gaat en houdt bij wie er geeft.',
    'Tik op een spel in de lijst om het te verbeteren of te verwijderen, en op ↶ om het laatste ongedaan te maken.',
  ]),
];

const _uk = [
  RulesSection('Гравці й карти', [
    'У клаверяс грають учотирьох двома командами по двоє, партнери сидять навпроти. Колода — 32 карти, від сімки '
        'до туза в кожній масті. Кожен гравець отримує вісім карт.',
    'Сторона, що обирає козир, — гравча; інша сторона намагається їй завадити. Козир за різними столами обирають '
        'по-різному: по черзі, за відкритою картою або з обов\'язком першого гравця обрати його.',
  ]),
  RulesSection('Вартість карт', [
    'Остання взятка додає 10, тож карти однієї роздачі коштують 162 очки. Козирного валета називають яс, козирну '
        'дев\'ятку — нел.',
  ], tableHeader: ['Карта', 'Козир', 'Інша масть'], table: [
    ['Валет', '20', '2'],
    ['Дев\'ятка', '14', '0'],
    ['Туз', '11', '11'],
    ['Десятка', '10', '10'],
    ['Король', '4', '4'],
    ['Дама', '3', '3'],
    ['Вісімка, сімка', '0', '0'],
  ]),
  RulesSection('Амстердамські й роттердамські правила', [
    'Є два основні способи гри. В обох треба класти карту в масть, а коли її немає — козиряти, і за змоги '
        'перебивати козир, що вже лежить.',
    'За роттердамськими правилами козиряти треба навіть тоді, коли взятку вже бере партнер. За амстердамськими '
        'цього не треба: якщо взятку бере партнер, можна покласти будь-яку карту.',
    'Застосунок іде за амстердамськими правилами. Різниця лише в розіграші, тож рахунок за обома ведуть однаково.',
  ]),
  RulesSection('Роем', [
    'Роем рахують у взятках: сторона, що бере взятку, отримує роем серед її чотирьох карт. Послідовність іде в '
        'порядку сімка, вісімка, дев\'ятка, десятка, валет, дама, король, туз, в одній масті. Роем додається до '
        'вартості роздачі.',
  ], tableHeader: ['Роем', 'Очки'], table: [
    ['Три підряд', '20'],
    ['Чотири підряд', '50'],
    ['Чотири тузи, королі, дами чи десятки', '100'],
    ['Чотири валети', '200'],
    ['Стук — король і дама козирів', '20'],
  ]),
  RulesSection('Піт', [
    'Сторона, що бере всі вісім взяток, робить піт і отримує ще 100 очок понад 162 за карти.',
  ]),
  RulesSection('Нат', [
    'Гравча сторона має набрати більше за суперників, разом із роемом. Якщо ні, вона йде нат: суперники отримують '
        '162 за карти і весь роем роздачі, також і роем гравців, а гравча сторона — нічого. Рівні очки теж '
        'рахуються як нат.',
  ]),
  RulesSection('Перемога', [
    'Часто грають домовлену кількість роздач, найчастіше шістнадцять, і перемагає більша сума; багато хто натомість '
        'грає до 1500 очок. Застосунок грає до 1500: перемагає сторона, що першою їх набере, а якщо обидві набрали '
        'в одній роздачі, — та, в якої рахунок більший.',
  ]),
  RulesSection('Як вести рахунок у застосунку', [
    'Після кожної роздачі натисни «Нова роздача», обери гравчу сторону, порахуй роем і введи очки однієї сторони; '
        'решту застосунок порахує сам, помітить нат і стежитиме, хто роздає.',
    'Торкнися будь-якої роздачі в історії, щоб виправити чи видалити її, а ↶ скасовує останню.',
  ]),
];
