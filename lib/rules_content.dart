import 'baloot_rules_content.dart';
import 'bela_rules_content.dart';
import 'belot_rules_content.dart';
import 'belote_rules_content.dart';
import 'coinche_rules_content.dart';
import 'game_rules.dart';
import 'klaverjas_rules_content.dart';

/// A section of the rules page: a heading, its paragraphs and, optionally,
/// a table of rows.
class RulesSection {
  final String title;
  final List<String> paragraphs;
  final List<String>? tableHeader;
  final List<List<String>> table;

  const RulesSection(this.title, this.paragraphs, {this.tableHeader, this.table = const []});
}

/// The rules of [game] in [lang], English when there is none.
List<RulesSection> rulesContent(String lang, [GameRules game = GameRules.deberc]) =>
    game.id == GameRules.belote.id ? beloteRulesContent(lang)
    : game.id == GameRules.belot.id ? belotRulesContent(lang)
    : game.id == GameRules.bela.id ? belaRulesContent(lang)
    : game.id == GameRules.klaverjas.id ? klaverjasRulesContent(lang)
    : game.id == GameRules.coinche.id ? coincheRulesContent(lang)
    : game.id == GameRules.baloot.id ? balootRulesContent(lang)
    : lang == 'uk' ? _uk : _en;

const _en = [
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
