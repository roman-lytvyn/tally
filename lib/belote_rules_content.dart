import 'rules_content.dart';

/// The rules of Belote in [lang], English when there is none.
List<RulesSection> beloteRulesContent(String lang) => switch (lang) {
  'uk' => _uk,
  'fr' => _fr,
  _    => _en,
};

const _en = [
  RulesSection('Players and cards', [
    'Belote is played by four in two teams of two, partners sitting opposite each other; two or three can also '
        'play, each for themselves. The game uses a 32-card deck, seven to ace in each suit.',
    'The dealer gives each player five cards, three and then two, and turns the next card face up. The deal '
        'goes round the table: after each deal the player on the dealer\'s left deals next.',
  ]),
  RulesSection('Taking the trump', [
    'Starting with the player on the dealer\'s left, each may take the turned-up card, making its suit trump, '
        'or pass. If everybody passes, a second round lets a player name any other suit. If everybody passes '
        'again, the cards are thrown in and the next player deals.',
    'The player who takes the trump gets the turned-up card and two more; everybody else gets three, so each '
        'holds eight.',
    'Whoever takes the trump has to score more than the opponents in that deal.',
  ]),
  RulesSection('Playing the cards', [
    'Players must follow the suit led. A player who cannot must trump, unless their partner is already winning '
        'the trick, and a trump played on a trump must beat it whenever it can.',
    'In trumps the order is jack, nine, ace, ten, king, queen, eight, seven; in the other suits ace, ten, king, '
        'queen, jack, nine, eight, seven.',
  ]),
  RulesSection('Card values', [
    'The cards are worth 152 points in all and the last trick, dix de der, adds 10, so every deal is worth 162 '
        'before declarations.',
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
    'Combinations are declared on the first trick. Only the side with the best sequence scores its sequences, '
        'and only the side with the best four of a kind scores its fours. Everything declared is added to the '
        'value of the deal.',
  ], tableHeader: ['Declaration', 'Points'], table: [
    ['Tierce — three in a row', '20'],
    ['Fifty — four in a row', '50'],
    ['Hundred — five in a row', '100'],
    ['Four jacks', '200'],
    ['Four nines', '150'],
    ['Four aces, tens, kings or queens', '100'],
    ['Belote-rebelote — king and queen of trumps', '20'],
  ]),
  RulesSection('Belote-rebelote', [
    'A player holding the king and queen of trumps says "belote" on playing the first of them and "rebelote" '
        'on playing the second. The 20 points stay with that side whatever happens to the deal.',
  ]),
  RulesSection('Capot', [
    'A side that takes every trick makes a capot: the cards are then worth 252 instead of 162.',
  ]),
  RulesSection('Dedans', [
    'If the side that took the trump scores less than its opponents, it is dedans: the opponents get the whole '
        'deal with every declaration, and the trump-taker keeps only its belote-rebelote.',
  ]),
  RulesSection('Litige — a tied deal', [
    'If the trump-taker scores exactly as much as the opponents, the deal is a litige. The opponents score '
        'their points, and the trump-taker\'s points wait for whoever wins the next deal. The app lets you settle '
        'it differently if your table does.',
  ]),
  RulesSection('Winning', [
    'The first side to reach the agreed target wins: 1000 points, or 500 for a short game. When both pass the '
        'target in the same deal, the side with more points wins, or, if your table plays it that way, the side '
        'that took the trump.',
  ]),
  RulesSection('Keeping the score in the app', [
    'After each deal tap "New round", pick who took the trump, count the declarations, mark a capot and who '
        'held the belote, and type the points of one side; the app works out the rest, spots dedans and litige, '
        'and keeps track of who deals.',
    'Tap any deal in the history to correct or delete it, and ↶ to undo the last one.',
  ]),
];

const _fr = [
  RulesSection('Joueurs et cartes', [
    'La belote se joue à quatre, en deux équipes de deux, les partenaires face à face ; on peut aussi y jouer à '
        'deux ou à trois, chacun pour soi. Le jeu compte 32 cartes, du sept à l\'as dans chaque couleur.',
    'Le donneur distribue cinq cartes à chacun, trois puis deux, et retourne la suivante. La donne tourne : '
        'après chaque donne, le joueur à gauche du donneur distribue à son tour.',
  ]),
  RulesSection('Prendre l\'atout', [
    'En commençant par le joueur à gauche du donneur, chacun peut prendre la carte retournée, dont la couleur '
        'devient l\'atout, ou passer. Si tout le monde passe, un second tour permet de choisir une autre couleur. '
        'Si tout le monde passe encore, on redonne et le joueur suivant distribue.',
    'Le preneur reçoit la carte retournée et deux autres ; les autres joueurs en reçoivent trois, et chacun '
        'en tient huit.',
    'Le preneur doit marquer plus de points que ses adversaires dans la donne.',
  ]),
  RulesSection('Jouer les cartes', [
    'Il faut fournir la couleur demandée. Qui ne peut pas doit couper, sauf si son partenaire est maître du pli, '
        'et un atout joué sur un atout doit monter dès que possible.',
    'À l\'atout l\'ordre est valet, neuf, as, dix, roi, dame, huit, sept ; dans les autres couleurs as, dix, '
        'roi, dame, valet, neuf, huit, sept.',
  ]),
  RulesSection('Valeur des cartes', [
    'Les cartes valent 152 points en tout et le dernier pli, le dix de der, en ajoute 10 : chaque donne vaut '
        'donc 162 avant les annonces.',
  ], tableHeader: ['Carte', 'Atout', 'Autres couleurs'], table: [
    ['Valet', '20', '2'],
    ['Neuf', '14', '0'],
    ['As', '11', '11'],
    ['Dix', '10', '10'],
    ['Roi', '4', '4'],
    ['Dame', '3', '3'],
    ['Huit, sept', '0', '0'],
  ]),
  RulesSection('Annonces', [
    'Les annonces se font au premier pli. Seul le camp qui a la meilleure suite marque ses suites, et seul '
        'celui qui a le meilleur carré marque ses carrés. Tout ce qui est annoncé s\'ajoute à la valeur de la '
        'donne.',
  ], tableHeader: ['Annonce', 'Points'], table: [
    ['Tierce — trois cartes qui se suivent', '20'],
    ['Cinquante — quatre qui se suivent', '50'],
    ['Cent — cinq qui se suivent', '100'],
    ['Carré de valets', '200'],
    ['Carré de neuf', '150'],
    ['Carré d\'as, de dix, de rois ou de dames', '100'],
    ['Belote-rebelote — roi et dame d\'atout', '20'],
  ]),
  RulesSection('Belote-rebelote', [
    'Le joueur qui a le roi et la dame d\'atout dit « belote » en jouant le premier et « rebelote » en jouant '
        'le second. Les 20 points restent à son camp quoi qu\'il arrive à la donne.',
  ]),
  RulesSection('Capot', [
    'Le camp qui fait tous les plis est capot : les cartes valent alors 252 au lieu de 162.',
  ]),
  RulesSection('Dedans', [
    'Si le preneur marque moins que ses adversaires, il est dedans : les adversaires prennent toute la donne '
        'avec toutes les annonces, et le preneur ne garde que sa belote-rebelote.',
  ]),
  RulesSection('Litige — l\'égalité', [
    'Si le preneur marque autant que ses adversaires, il y a litige. Les adversaires marquent leurs points, et '
        'ceux du preneur vont au gagnant de la donne suivante. L\'application permet d\'en décider autrement si '
        'votre table le fait.',
  ]),
  RulesSection('La victoire', [
    'Le premier camp qui atteint le total convenu gagne : 1000 points, ou 500 pour une partie courte. Si les '
        'deux le dépassent dans la même donne, le camp qui a le plus de points gagne, ou, si votre table le joue '
        'ainsi, le preneur.',
  ]),
  RulesSection('Tenir le score dans l\'application', [
    'Après chaque donne, touchez « Nouvelle donne », choisissez le preneur, comptez les annonces, indiquez un '
        'capot et qui avait la belote, et saisissez les points d\'un camp ; l\'application calcule le reste, '
        'repère le dedans et le litige, et sait qui distribue.',
    'Touchez une donne de l\'historique pour la corriger ou la supprimer, et ↶ pour annuler la dernière.',
  ]),
];

const _uk = [
  RulesSection('Гравці й карти', [
    'У белот грають учотирьох, двома командами по двоє, партнери сидять навпроти; можна грати й удвох чи втрьох, '
        'кожен сам за себе. Колода — 32 карти, від сімки до туза в кожній масті.',
    'Роздавач дає кожному п\'ять карт, спершу три, потім дві, і відкриває наступну. Роздача йде по колу: після '
        'кожної роздає гравець ліворуч від роздавача.',
  ]),
  RulesSection('Хто бере козир', [
    'Починаючи з гравця ліворуч від роздавача, кожен може взяти відкриту карту — тоді її масть стає козирем — '
        'або спасувати. Якщо всі спасували, у другому колі можна назвати будь-яку іншу масть. Якщо всі спасували '
        'знову, карти перездають, і роздає наступний гравець.',
    'Той, хто взяв козир, отримує відкриту карту й ще дві; решта — по три, тож у кожного по вісім.',
    'Той, хто взяв козир, має набрати в роздачі більше за суперників.',
  ]),
  RulesSection('Як ходять', [
    'Треба ходити в масть. Хто не має масті, мусить бити козирем, якщо взятку не бере вже його партнер, а козир '
        'на козир має бути старшим, якщо є чим.',
    'У козирях порядок такий: валет, дев\'ятка, туз, десятка, король, дама, вісімка, сімка; в інших мастях — '
        'туз, десятка, король, дама, валет, дев\'ятка, вісімка, сімка.',
  ]),
  RulesSection('Вартість карт', [
    'Карти разом коштують 152 очки, а остання взятка — dix de der — додає 10, тож кожна роздача без комбінацій '
        'коштує 162.',
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
    'Комбінації оголошують на першій взятці. Послідовності записує лише сторона з найкращою послідовністю, а '
        'каре — лише сторона з найкращим каре. Усе оголошене додається до вартості роздачі.',
  ], tableHeader: ['Комбінація', 'Очки'], table: [
    ['Терц — три підряд', '20'],
    ['П\'ятдесят — чотири підряд', '50'],
    ['Сотня — п\'ять підряд', '100'],
    ['Каре валетів', '200'],
    ['Каре дев\'яток', '150'],
    ['Каре тузів, десяток, королів чи дам', '100'],
    ['Белот-ребелот — король і дама козирів', '20'],
  ]),
  RulesSection('Белот-ребелот', [
    'Гравець із королем і дамою козирів каже «белот», коли ходить першою з них, і «ребелот», коли другою. Ці 20 '
        'очок лишаються його стороні, хоч би чим закінчилася роздача.',
  ]),
  RulesSection('Капот', [
    'Сторона, що взяла всі взятки, робить капот: карти тоді коштують 252 замість 162.',
  ]),
  RulesSection('Дедан', [
    'Якщо сторона, що взяла козир, набрала менше за суперників, це дедан: суперники отримують усю роздачу з '
        'усіма комбінаціями, а тим, хто грав, лишається хіба їхній белот-ребелот.',
  ]),
  RulesSection('Літиж — нічия', [
    'Якщо той, хто взяв козир, набрав рівно стільки, скільки суперники, це літиж. Суперники записують свої очки, '
        'а очки тих, хто грав, переходять до переможця наступної роздачі. Якщо за вашим столом інакше, це можна '
        'змінити в застосунку.',
  ]),
  RulesSection('Перемога', [
    'Перемагає сторона, що першою набере домовлену суму: 1000 очок або 500 для короткої гри. Якщо обидві '
        'перейшли її в одній роздачі, перемагає та, в якої більше очок, або, якщо так грають за вашим столом, та, '
        'що взяла козир.',
  ]),
  RulesSection('Як вести рахунок у застосунку', [
    'Після кожної роздачі натисніть «Нова роздача», виберіть, хто взяв козир, порахуйте комбінації, позначте '
        'капот і в кого був белот, і введіть очки однієї сторони; решту застосунок порахує сам, помітить дедан і '
        'літиж і стежитиме, хто роздає.',
    'Торкніться будь-якої роздачі в історії, щоб виправити чи видалити її, а ↶ — щоб скасувати останню.',
  ]),
];
