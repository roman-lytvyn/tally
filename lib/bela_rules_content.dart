import 'rules_content.dart';

/// The rules and history of Bela in [lang], English when there is none.
List<RulesSection> belaRulesContent(String lang) => switch (lang) {
  'hr' => _hr,
  'uk' => _uk,
  _    => _en,
};

const _en = [
  RulesSection('Where the game comes from', [
    'Bela is the Croatian member of the Jass, or jack–nine, family of card games, in which the jack and the nine '
        'are the highest trumps. It came to the Adriatic from the Hungarian and French forms of the game and is '
        'now played all over Croatia, Bosnia and Herzegovina, Serbia and Montenegro, in cafés as much as at home.',
    'Its relatives include the French Belote, the Bulgarian Belot, the Saudi Baloot, the Dutch Klaverjas and the '
        'Ukrainian Deberc.',
  ]),
  RulesSection('Players and cards', [
    'Bela is played by four in two teams of two, partners sitting opposite each other, with a 32-card deck, '
        'seven to ace in each suit. The deal and the play go counter-clockwise. Two can play as well, each for '
        'themselves.',
    'Each player gets eight cards: six face up in the hand and two face down, the talon, which are picked up once '
        'the trump is called.',
  ]),
  RulesSection('Calling the trump', [
    'Starting next to the dealer, each player either calls a trump suit or passes. If the first three pass, the '
        'dealer must call: the dealer cannot pass.',
  ]),
  RulesSection('Card values', [
    'The last trick adds 10, so the cards of a deal are worth 162 points.',
  ], tableHeader: ['Card', 'Trump', 'Other suit'], table: [
    ['Jack', '20', '2'],
    ['Nine', '14', '0'],
    ['Ace', '11', '11'],
    ['Ten', '10', '10'],
    ['King', '4', '4'],
    ['Queen', '3', '3'],
    ['Eight, seven', '0', '0'],
  ]),
  RulesSection('Declarations', [
    'Sequences and four of a kind are declared on the first trick. Only the side with the highest declaration '
        'scores its declarations; the other side scores none. The bela is declared when its first card is played.',
  ], tableHeader: ['Declaration', 'Points'], table: [
    ['Tierce — three in a row', '20'],
    ['Quarte — four in a row', '50'],
    ['Quinte or longer', '100'],
    ['Four aces, tens, kings or queens', '100'],
    ['Four nines', '150'],
    ['Four jacks', '200'],
    ['Bela — king and queen of trumps', '20'],
    ['Štiglja — every trick', '90'],
  ]),
  RulesSection('Belot', [
    'All eight cards of one suit in a single hand are called a belot, and the side holding it wins the whole '
        'game at once.',
  ]),
  RulesSection('The fall', [
    'The side that called the trump has to score more than its opponents, declarations included. If it does '
        'not, it falls: the opponents get the whole deal, the caller\'s declarations and bela too.',
  ]),
  RulesSection('Equal points', [
    'When both sides score the same, the side that called the trump falls as well. Some tables hold its points '
        'over for the winner of the next deal or let each side keep its own instead; the app lets you choose.',
  ]),
  RulesSection('Winning', [
    'The first side to reach 1001 wins; a shorter game goes to 501 or 701. When both pass it in the same deal, '
        'the side with more points wins.',
  ]),
  RulesSection('Keeping the score in the app', [
    'After each deal tap "New round", choose who called the trump, count the declarations and enter the points '
        'of one side; the app works out the other side and shows what will be written down before you save.',
    '"Belot" ends the game for the side that held it. "Fall" records a lost deal without entering points.',
  ]),
];

const _hr = [
  RulesSection('Odakle dolazi igra', [
    'Bela je hrvatska inačica obitelji kartaških igara Jass, u kojoj su dečko i devetka najjači aduti. Na Jadran '
        'je stigla iz mađarskih i francuskih oblika igre, a danas se igra po cijeloj Hrvatskoj, Bosni i '
        'Hercegovini, Srbiji i Crnoj Gori, u kafiću jednako kao i kod kuće.',
    'Njezini su rođaci francuska Belote, bugarski Belot, saudijski Baloot, nizozemski Klaverjas i ukrajinski '
        'Deberc.',
  ]),
  RulesSection('Igrači i karte', [
    'Belu igraju četvorica u dvije ekipe po dvoje, partneri sjede jedan nasuprot drugome, s 32 karte, od sedmice '
        'do asa u svakoj boji. Dijeli se i igra suprotno od kazaljke na satu. Mogu igrati i dvojica, svatko za '
        'sebe.',
    'Svaki igrač dobiva osam karata: šest u ruku i dvije okrenute licem prema dolje, talon, koje uzima kad je '
        'adut zvan.',
  ]),
  RulesSection('Zvanje aduta', [
    'Počevši od igrača do djelitelja, svatko ili zove adutsku boju ili kaže dalje. Ako prva trojica kažu dalje, '
        'djelitelj mora zvati: djelitelj ne može reći dalje.',
  ]),
  RulesSection('Vrijednost karata', [
    'Zadnji štih donosi 10, pa karte jednog dijeljenja vrijede 162 boda.',
  ], tableHeader: ['Karta', 'Adut', 'Ostale boje'], table: [
    ['Dečko', '20', '2'],
    ['Devetka', '14', '0'],
    ['As', '11', '11'],
    ['Desetka', '10', '10'],
    ['Kralj', '4', '4'],
    ['Baba', '3', '3'],
    ['Osmica, sedmica', '0', '0'],
  ]),
  RulesSection('Zvanja', [
    'Nizovi i četiri iste karte zovu se u prvom štihu. Zvanja upisuje samo strana s najjačim zvanjem; druga '
        'strana ne upisuje nijedno. Bela se zove kad se odigra njezina prva karta.',
  ], tableHeader: ['Zvanje', 'Bodovi'], table: [
    ['Terca — tri zaredom', '20'],
    ['Kvarta — četiri zaredom', '50'],
    ['Kvinta ili duži niz', '100'],
    ['Četiri asa, desetke, kralja ili babe', '100'],
    ['Četiri devetke', '150'],
    ['Četiri dečka', '200'],
    ['Bela — kralj i baba u adutu', '20'],
    ['Štiglja — svi štihovi', '90'],
  ]),
  RulesSection('Belot', [
    'Svih osam karata jedne boje u jednoj ruci zove se belot, i strana koja ga ima odmah dobiva cijelu igru.',
  ]),
  RulesSection('Pad', [
    'Strana koja je zvala aduta mora skupiti više od protivnika, zajedno sa zvanjima. Ako ne skupi, pada: '
        'protivnici dobivaju cijelo dijeljenje, i zvanja i belu strane koja je zvala.',
  ]),
  RulesSection('Jednaki bodovi', [
    'Kad obje strane skupe jednako, strana koja je zvala aduta također pada. Za nekim se stolovima njezini bodovi '
        'ostavljaju pobjedniku sljedećeg dijeljenja ili svatko zadržava svoje; u aplikaciji to možete odabrati.',
  ]),
  RulesSection('Pobjeda', [
    'Pobjeđuje strana koja prva dođe do 1001; kraća igra ide do 501 ili 701. Kad obje strane prijeđu cilj u '
        'istom dijeljenju, pobjeđuje ona s više bodova.',
  ]),
  RulesSection('Vođenje rezultata u aplikaciji', [
    'Nakon svakog dijeljenja dodirnite „Novo dijeljenje”, odaberite tko je zvao aduta, prebrojite zvanja i '
        'upišite bodove jedne strane; aplikacija izračuna drugu stranu i prije spremanja pokaže što će se upisati.',
    '„Belot” završava igru u korist strane koja ga je imala. „Pad” upisuje izgubljeno dijeljenje bez unosa '
        'bodova.',
  ]),
];

const _uk = [
  RulesSection('Звідки походить гра', [
    'Бела — хорватська гра з родини карткових ігор Jass, у яких валет і дев\'ятка — найстарші козирі. На '
        'Адріатику вона прийшла з угорських і французьких різновидів гри, а тепер у неї грають по всій Хорватії, '
        'Боснії і Герцеговині, Сербії та Чорногорії — і в кав\'ярнях, і вдома.',
    'Її родичі — французький белот, болгарський белот, саудівський балот, нідерландський клаверяс і '
        'український деберць.',
  ]),
  RulesSection('Гравці та карти', [
    'У белу грають учотирьох, двома командами по двоє, партнери сидять один навпроти одного, колодою з 32 карт, '
        'від сімки до туза в кожній масті. Роздають і ходять проти годинникової стрілки. Можна грати й удвох, '
        'кожен сам за себе.',
    'Кожен отримує вісім карт: шість у руку і дві сорочкою догори — прикуп, який бере, коли козир названо.',
  ]),
  RulesSection('Вибір козиря', [
    'Починаючи від гравця поруч із роздавачем, кожен або називає козирну масть, або пасує. Якщо перші троє '
        'спасували, козир мусить назвати роздавач: пасувати він не може.',
  ]),
  RulesSection('Вартість карт', [
    'Остання взятка дає ще 10, тож карти однієї роздачі разом важать 162 очки.',
  ], tableHeader: ['Карта', 'Козир', 'Інша масть'], table: [
    ['Валет', '20', '2'],
    ['Дев\'ятка', '14', '0'],
    ['Туз', '11', '11'],
    ['Десятка', '10', '10'],
    ['Король', '4', '4'],
    ['Дама', '3', '3'],
    ['Вісімка, сімка', '0', '0'],
  ]),
  RulesSection('Комбінації', [
    'Послідовності й чотири однакові карти оголошують на першій взятці. Комбінації записує лише сторона з '
        'найстаршою комбінацією; друга сторона не записує жодної. Белу оголошують, коли ходять її першою картою.',
  ], tableHeader: ['Комбінація', 'Очки'], table: [
    ['Терц — три підряд', '20'],
    ['Кварта — чотири підряд', '50'],
    ['Квінта або довша послідовність', '100'],
    ['Чотири тузи, десятки, королі або дами', '100'],
    ['Чотири дев\'ятки', '150'],
    ['Чотири валети', '200'],
    ['Бела — король і дама козирної масті', '20'],
    ['Штиґля — усі взятки', '90'],
  ]),
  RulesSection('Белот', [
    'Усі вісім карт однієї масті в одній руці називають белотом, і сторона, що його має, одразу виграє всю гру.',
  ]),
  RulesSection('Пад', [
    'Сторона, що назвала козир, має набрати більше за суперників, разом із комбінаціями. Якщо не набрала, вона '
        'падає: суперники отримують усю роздачу, разом із комбінаціями й белою тих, хто грав.',
  ]),
  RulesSection('Нарівно', [
    'Коли обидві сторони набрали порівну, сторона, що назвала козир, теж падає. За деякими столами її очки '
        'чекають на переможця наступної роздачі або кожен лишає своє; у застосунку це можна вибрати.',
  ]),
  RulesSection('Перемога', [
    'Перемагає сторона, що першою набере 1001; коротша гра — до 501 або 701. Коли обидві сторони перейшли суму '
        'гри в одній роздачі, перемагає та, в якої більше очок.',
  ]),
  RulesSection('Рахунок у застосунку', [
    'Після кожної роздачі натисніть «Нова роздача», виберіть, хто назвав козир, порахуйте комбінації та введіть '
        'очки однієї сторони; застосунок порахує другу і перед збереженням покаже, що буде записано.',
    '«Белот» завершує гру на користь сторони, що його мала. «Пад» записує програну роздачу без введення очок.',
  ]),
];
