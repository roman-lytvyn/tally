/// A section of the rules page: a heading, its paragraphs and, optionally,
/// a table of rows.
class RulesSection {
  final String title;
  final List<String> paragraphs;
  final List<String>? tableHeader;
  final List<List<String>> table;

  const RulesSection(this.title, this.paragraphs, {this.tableHeader, this.table = const []});
}

List<RulesSection> rulesContent(String lang) => lang == 'uk' ? _uk : _en;

const _en = [
  RulesSection('Where the game comes from', [
    'Deberc has no single inventor and no documented birthday. It belongs to the Jass, or jack–nine, family of '
        'card games, in which the jack and the nine are the highest trumps.',
    'The family comes from the Low Countries: the Dutch klaverjassen is recorded in the 18th century, and from '
        'there the game reached Switzerland, where Jass is first mentioned in 1796. Its relatives include the Swiss '
        'Jass, the French Belote, the Bulgarian Bela, the Cypriot Pilotta and the Armenian Bazar Blot.',
    'Under names such as Klabberjass, Kalabriás and Klabrias the game spread through the German lands and '
        'Austria-Hungary and became especially loved in Jewish communities, which later carried it to Britain, '
        'the United States, South Africa and Israel.',
    'Many of those communities lived in today\'s Ukraine — Odesa, Galicia, Podillia, the Kyiv region — and this '
        'is where the game took the form known as Deberc. Its words still show the route: the Odesa variant is '
        'called klabor, the trump nine is the manela, and a lost deal is bait, like the bête of Klaberjass.',
    'Stories that the game was invented in a particular prison camp or village are repeated online but are not '
        'backed by any document. The origin of the word Deberc itself is not known.',
  ]),
  RulesSection('Players and cards', [
    'Two players or three each play for themselves; four play in two teams of two, partners sitting opposite '
        'each other. The game uses a 32-card deck, seven to ace in each suit.',
    'The deal goes round the table: after each deal the player on the dealer\'s left deals next.',
  ]),
  RulesSection('Taking the trump', [
    'After the deal one card is turned face up. The player on the dealer\'s left may take its suit as trump or '
        'pass, and the right goes round the table. If everybody passes, another suit may be named in a second '
        'round; if everybody passes again, the cards are thrown in and the next player deals.',
    'Some tables play "with obligation": when everybody else passes, the dealer must take the trump.',
    'Whoever takes the trump has to score more than the opponents in that deal.',
  ]),
  RulesSection('Card values', [
    'The cards are worth 152 points in all and the last trick adds 10, so every deal is worth 162 before '
        'declarations.',
  ], tableHeader: ['Card', 'Trump', 'Other suits'], table: [
    ['Jack', '20', '2'],
    ['Nine', '14', '0'],
    ['Ace', '11', '11'],
    ['Ten', '10', '10'],
    ['King', '4', '4'],
    ['Queen', '3', '3'],
    ['Eight, seven', '0', '0'],
  ]),
  RulesSection('Declarations', [
    'Sequences of one suit are declared at the start of the deal; only the side with the highest sequence '
        'scores its sequences. Everything declared is added to the value of the deal.',
  ], tableHeader: ['Declaration', 'Points'], table: [
    ['Tierce — three in a row', '20'],
    ['Fifty — four in a row', '50'],
    ['Bella — king and queen of trumps', '20'],
    ['Deberc — seven trumps in a row', 'wins the game'],
  ]),
  RulesSection('Bait', [
    'If the side that took the trump scores less than an opponent, the deal is bait: the opponents get the '
        'whole value of the deal and the trump-taker gets nothing. With three players the deal goes to the '
        'opponent who scored more, and two opponents level on the most share it.',
  ]),
  RulesSection('Penalties', [
    'Many tables add penalties, settled before the game; the app lets you choose them in the settings and '
        'takes them off the score on its own:',
    '• Repeated bait — a side loses 50 or 100 more points for its third bait, for the third and each one '
        'after it, or for every third. Baits count over the whole game or only in a row; in a pair the bait '
        'counts for the team.',
    '• Skis — a side that takes no tricks in a deal loses 50 or 100 points.',
  ]),
  RulesSection('Eggs — a tied deal', [
    'If the trump-taker scores exactly as much as the opponents, the deal is "eggs". Tables settle it '
        'differently, and the app lets you choose before the game:',
    '• Held over — the opponents score their points; the trump-taker\'s points wait for whoever wins the next deal.',
    '• To opponents — a tie counts as bait.',
    '• Each keeps own — both sides score what they took.',
  ]),
  RulesSection('Deberc', [
    'Seven trumps in a row in one hand is a deberc. The side that declares it wins the whole game at once, '
        'whatever the score.',
  ]),
  RulesSection('Winning', [
    'The first side to reach the agreed target wins: 301 for a short game, 501 or 1001. When both pass the '
        'target in the same deal, tables settle it differently, and the app lets you choose before the game:',
    '• Most points — the side with the higher score wins; on an equal score play goes on.',
    '• Trump-taker — the side that took the trump in that deal wins, even with fewer points.',
  ]),
  RulesSection('Keeping the score in the app', [
    'After each deal tap "New round", pick who took the trump, count the declarations and type the points of '
        'one side; the app works out the rest, spots bait and eggs, and keeps track of who deals.',
    'Tap any deal in the history to correct or delete it, and ↶ to undo the last one.',
  ]),
];

const _uk = [
  RulesSection('Звідки походить гра', [
    'Деберць не має одного винахідника чи задокументованої дати народження. Він належить до родини ігор Ясс, '
        'або «валет–дев\'ятка», у яких валет і дев\'ятка — найстарші козирі.',
    'Ця родина походить із Нижніх земель: нідерландський клаверяс відомий з XVIII століття, а звідти гра дійшла '
        'до Швейцарії, де Ясс уперше згадано 1796 року. Її родичі — швейцарський Ясс, французька Белот, болгарська '
        'Бела, кіпрська Пілотта і вірменський Базар Блот.',
    'Під назвами Клаберяс, Калабріаш і Клабріас гра поширилася німецькими землями та Австро-Угорщиною й особливо '
        'полюбилася в єврейських громадах, які згодом принесли її до Британії, США, Південної Африки та Ізраїлю.',
    'Багато цих громад жили на теренах сучасної України — в Одесі, Галичині, на Поділлі, Київщині, — і саме тут '
        'гра набула вигляду, відомого як деберць. Її слова досі показують цей шлях: одеський варіант зветься '
        'клабор, козирна дев\'ятка — манела, а програна роздача — байт, як bête у клаберясі.',
    'Історії про те, що гру вигадали в певному таборі чи селі, повторюються в мережі, але не підтверджені '
        'жодним документом. Походження самого слова «деберць» невідоме.',
  ]),
  RulesSection('Гравці й карти', [
    'Двоє або троє гравців грають кожен за себе; четверо — двома командами по двоє, партнери сидять навпроти. '
        'Колода — 32 карти, від сімки до туза в кожній масті.',
    'Роздача йде по колу: після кожної роздачі наступним роздає гравець ліворуч від роздавача.',
  ]),
  RulesSection('Хто бере козир', [
    'Після роздачі одну карту відкривають. Гравець ліворуч від роздавача може взяти її масть козирем або '
        'спасувати, і право переходить по колу. Якщо всі спасували, у другому колі можна назвати іншу масть; '
        'якщо знову всі пас — карти скидають, і роздає наступний.',
    'За деякими столами грають «з зобов\'язанням»: коли всі інші спасували, козир мусить узяти роздавач.',
    'Той, хто взяв козир, мусить набрати в цій роздачі більше, ніж суперники.',
  ]),
  RulesSection('Вартість карт', [
    'Карти разом коштують 152 очки, остання взятка додає 10, тож кожна роздача без комбінацій — це 162 очки.',
  ], tableHeader: ['Карта', 'Козир', 'Інші масті'], table: [
    ['Валет', '20', '2'],
    ['Дев\'ятка', '14', '0'],
    ['Туз', '11', '11'],
    ['Десятка', '10', '10'],
    ['Король', '4', '4'],
    ['Дама', '3', '3'],
    ['Вісімка, сімка', '0', '0'],
  ]),
  RulesSection('Комбінації', [
    'Послідовності однієї масті оголошують на початку роздачі; записує їх лише сторона з найстаршою '
        'послідовністю. Усе оголошене додається до вартості роздачі.',
  ], tableHeader: ['Комбінація', 'Очки'], table: [
    ['Терц — три підряд', '20'],
    ['П\'ятдесят — чотири підряд', '50'],
    ['Бела — король і дама козирів', '20'],
    ['Деберць — сім козирів підряд', 'виграш гри'],
  ]),
  RulesSection('Байт', [
    'Якщо сторона, що взяла козир, набрала менше за суперника, це байт: суперники отримують усю вартість '
        'роздачі, а ті, хто грав, — нуль. Утрьох роздачу отримує суперник, що набрав більше, а двоє з однаковим '
        'найбільшим результатом ділять її.',
  ]),
  RulesSection('Штрафи', [
    'За багатьма столами грають зі штрафами, про які домовляються перед грою; застосунок дає обрати їх у '
        'налаштуваннях і сам знімає їх з рахунку:',
    '• Повторні байти — сторона втрачає ще 50 або 100 очок за третій байт, за третій і кожен наступний або '
        'за кожен третій. Байти рахуються за всю гру або лише підряд; у парі байт пишеться на команду.',
    '• Лижі — сторона, що за роздачу не взяла жодної взятки, втрачає 50 або 100 очок.',
  ]),
  RulesSection('Яйця — нічия', [
    'Якщо ті, хто взяв козир, набрали рівно стільки ж, скільки суперники, це «яйця». За різними столами їх '
        'рахують по-різному, і застосунок дає обрати правило перед грою:',
    '• Висять — суперники записують свої очки, а очки тих, хто грав, чекають на переможця наступної роздачі.',
    '• Суперникам — нічия рахується як байт.',
    '• Кожному своє — кожна сторона записує те, що набрала.',
  ]),
  RulesSection('Деберць', [
    'Сім козирів підряд на руках — це деберць. Сторона, що його оголосила, одразу виграє всю гру, '
        'незалежно від рахунку.',
  ]),
  RulesSection('Перемога', [
    'Перемагає сторона, яка першою досягне домовленої суми: 301 для короткої гри, 501 або 1001. Якщо обидві '
        'сторони набрали цю суму в одній роздачі, за різними столами це вирішують по-різному, і застосунок дає '
        'обрати правило перед грою:',
    '• Більше очок — перемагає сторона з більшим рахунком; за рівного рахунку гра триває.',
    '• Хто грав — перемагає сторона, що в цій роздачі взяла козир, навіть якщо в неї менше очок.',
  ]),
  RulesSection('Як вести рахунок у застосунку', [
    'Після кожної роздачі натисни «Нова роздача», обери, хто взяв козир, порахуй комбінації та введи очки '
        'однієї сторони; решту застосунок порахує сам, помітить байт і яйця та стежитиме, хто роздає.',
    'Торкнися будь-якої роздачі в історії, щоб виправити чи видалити її, а ↶ скасовує останню.',
  ]),
];
