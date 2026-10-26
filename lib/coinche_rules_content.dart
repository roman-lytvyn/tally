import 'rules_content.dart';

/// The rules of Coinche in [lang], English when there is none.
List<RulesSection> coincheRulesContent(String lang) => switch (lang) {
  'fr' => _fr,
  'uk' => _uk,
  _    => _en,
};

const _en = [
  RulesSection('Players and cards', [
    'Coinche is played by four in two teams of two, partners sitting opposite each other, with a 32-card deck, '
        'seven to ace in each suit. Every player gets eight cards and no card is turned up.',
  ]),
  RulesSection('Card values', [
    'The last trick, the dix de der, adds 10, so the cards of a deal are worth 162 points.',
  ], tableHeader: ['Card', 'Trump', 'Other suit'], table: [
    ['Jack', '20', '2'],
    ['Nine', '14', '0'],
    ['Ace', '11', '11'],
    ['Ten', '10', '10'],
    ['King', '4', '4'],
    ['Queen', '3', '3'],
    ['Eight, seven', '0', '0'],
  ]),
  RulesSection('Bidding', [
    'Starting left of the dealer, each player passes or bids a number of points and a trump suit. The lowest bid '
        'is 80, each bid must be higher than the last, in steps of ten, up to 160; the highest bid of all is '
        'capot, a promise to take every trick.',
    'Bidding ends when the other three pass in turn after a bid. If all four pass at the start, the cards are '
        'dealt again.',
  ]),
  RulesSection('Coinche and surcoinche', [
    'An opponent who doubts that a bid can be made may coinche it, which ends the bidding and doubles the value '
        'of the bid. The bidding side may answer with a surcoinche, which doubles it again.',
  ]),
  RulesSection('Announcements and the belote', [
    'With the first card, players announce their sequences in one suit and their four of a kind. Only the side '
        'with the best announcement scores its announcements, and it scores all of them.',
    'Holding the king and queen of trumps, a player says "belote" when playing the first and "rebelote" when '
        'playing the second, for 20 points that stay with that side whatever happens to the contract.',
  ], tableHeader: ['Announcement', 'Points'], table: [
    ['Tierce — three in a row', '20'],
    ['Cinquante — four in a row', '50'],
    ['Cent — five in a row', '100'],
    ['Four aces, tens, kings or queens', '100'],
    ['Four nines', '150'],
    ['Four jacks', '200'],
    ['Belote — king and queen of trumps', '20'],
  ]),
  RulesSection('Making the contract', [
    'The bidding side makes its contract when its points, with its announcements and belote, reach the bid; a '
        'capot is made only by taking all eight tricks. It then scores its points plus the bid, and the opponents '
        'score their own points. The tricks of a capot count 250 instead of 162.',
    'When the contract fails, the opponents score 160 plus the bid, and the bidding side keeps only its belote. '
        'A coinche doubles the bid and a surcoinche quadruples it, while the points of the cards stay as they are. '
        'All scores are rounded to the nearest ten, fives up.',
    'Clubs vary these details: some count only the bid, some multiply the whole score, some require the bidding '
        'side to also beat its opponents. The app follows the scoring described here.',
  ]),
  RulesSection('Winning', [
    'The game is usually played to 2000 points, sometimes to 1000, 1500 or 3000. The first side to reach the '
        'target wins; when both reach it in the same deal, the higher score wins.',
  ]),
  RulesSection('Keeping the score in the app', [
    'After each deal tap "New round", pick the side that won the bidding, set its bid with − and +, mark a '
        'coinche or surcoinche, count the announcements and type the points of one side; the app works out the '
        'rest, adds the bid, spots a failed contract and keeps track of who deals.',
    'Tap any deal in the history to correct or delete it, and ↶ to undo the last one.',
  ]),
];

const _fr = [
  RulesSection('Joueurs et cartes', [
    'La coinche se joue à quatre, en deux équipes de deux, les partenaires face à face, avec un jeu de 32 cartes, '
        'du sept à l\'as dans chaque couleur. Chaque joueur reçoit huit cartes et aucune carte n\'est retournée.',
  ]),
  RulesSection('Valeur des cartes', [
    'Le dernier pli, le dix de der, vaut 10 points : les cartes d\'une donne valent donc 162 points.',
  ], tableHeader: ['Carte', 'Atout', 'Autre couleur'], table: [
    ['Valet', '20', '2'],
    ['Neuf', '14', '0'],
    ['As', '11', '11'],
    ['Dix', '10', '10'],
    ['Roi', '4', '4'],
    ['Dame', '3', '3'],
    ['Huit, sept', '0', '0'],
  ]),
  RulesSection('Les enchères', [
    'En commençant à gauche du donneur, chaque joueur passe ou annonce un nombre de points et une couleur d\'atout. '
        'L\'enchère la plus basse est 80, chaque enchère doit dépasser la précédente, de dix en dix, jusqu\'à 160 ; '
        'la plus haute de toutes est le capot, la promesse de faire tous les plis.',
    'Les enchères s\'arrêtent quand les trois autres joueurs passent après une annonce. Si les quatre passent dès '
        'le départ, on redonne.',
  ]),
  RulesSection('Coinche et surcoinche', [
    'Un adversaire qui doute qu\'un contrat puisse être réalisé peut le coincher : les enchères s\'arrêtent et la '
        'valeur du contrat est doublée. Le camp preneur peut répondre par une surcoinche, qui la double encore.',
  ]),
  RulesSection('Les annonces et la belote', [
    'À la première carte, les joueurs annoncent leurs suites dans une couleur et leurs carrés. Seul le camp qui a '
        'la meilleure annonce marque ses annonces, et il les marque toutes.',
    'Le joueur qui a le roi et la dame d\'atout dit « belote » en jouant le premier et « rebelote » en jouant le '
        'second : 20 points qui restent à son camp quel que soit le sort du contrat.',
  ], tableHeader: ['Annonce', 'Points'], table: [
    ['Tierce — trois cartes qui se suivent', '20'],
    ['Cinquante — quatre cartes qui se suivent', '50'],
    ['Cent — cinq cartes qui se suivent', '100'],
    ['Carré d\'as, de dix, de rois ou de dames', '100'],
    ['Carré de neuf', '150'],
    ['Carré de valets', '200'],
    ['Belote — roi et dame d\'atout', '20'],
  ]),
  RulesSection('Réaliser le contrat', [
    'Le camp preneur réalise son contrat quand ses points, annonces et belote comprises, atteignent l\'enchère ; un '
        'capot n\'est réalisé qu\'en faisant les huit plis. Il marque alors ses points plus l\'enchère, et les '
        'adversaires marquent leurs propres points. Les plis d\'un capot comptent 250 au lieu de 162.',
    'Quand le contrat chute, les adversaires marquent 160 plus l\'enchère, et le camp preneur ne garde que sa '
        'belote. La coinche double l\'enchère et la surcoinche la quadruple, les points des cartes restant les '
        'mêmes. Tous les scores sont arrondis à la dizaine la plus proche, 5 vers le haut.',
    'Les clubs varient sur ces détails : certains ne comptent que l\'enchère, d\'autres multiplient tout le score, '
        'd\'autres exigent aussi que le preneur fasse plus que ses adversaires. L\'application suit le décompte '
        'décrit ici.',
  ]),
  RulesSection('Gagner la partie', [
    'La partie se joue le plus souvent en 2000 points, parfois en 1000, 1500 ou 3000. Le premier camp à atteindre '
        'le total gagne ; si les deux l\'atteignent à la même donne, le plus haut score l\'emporte.',
  ]),
  RulesSection('Tenir le score dans l\'application', [
    'Après chaque donne, appuyez sur « Nouvelle donne », choisissez le camp qui a remporté les enchères, réglez son '
        'contrat avec − et +, indiquez une coinche ou une surcoinche, comptez les annonces et saisissez les points '
        'd\'un camp ; l\'application calcule le reste, ajoute le contrat, repère une chute et suit qui distribue.',
    'Touchez une donne de l\'historique pour la corriger ou la supprimer, et ↶ pour annuler la dernière.',
  ]),
];

const _uk = [
  RulesSection('Гравці та карти', [
    'У куанш грають учотирьох, двома командами по двоє, партнери сидять навпроти, колодою з 32 карт, від сімки до '
        'туза в кожній масті. Кожен гравець отримує вісім карт, жодна карта не відкривається.',
  ]),
  RulesSection('Вартість карт', [
    'Остання взятка додає 10, тож карти однієї роздачі вартують 162 очки.',
  ], tableHeader: ['Карта', 'Козир', 'Інша масть'], table: [
    ['Валет', '20', '2'],
    ['Дев\'ятка', '14', '0'],
    ['Туз', '11', '11'],
    ['Десятка', '10', '10'],
    ['Король', '4', '4'],
    ['Дама', '3', '3'],
    ['Вісімка, сімка', '0', '0'],
  ]),
  RulesSection('Торгівля', [
    'Починаючи з гравця ліворуч від роздавача, кожен пасує або замовляє кількість очок і козирну масть. '
        'Найменше замовлення — 80, кожне наступне має бути вищим за попереднє, кроком у десять, до 160; найвище '
        'з усіх — капот, обіцянка взяти всі взятки.',
    'Торгівля закінчується, коли після замовлення троє інших пасують по черзі. Якщо всі четверо пасують одразу, '
        'карти роздають знову.',
  ]),
  RulesSection('Куанш і сюркуанш', [
    'Суперник, який сумнівається, що замовлення можна виконати, може сказати «куанш»: торгівля закінчується, а '
        'вартість замовлення подвоюється. Сторона, що замовила, може відповісти «сюркуанш», і вартість '
        'подвоюється ще раз.',
  ]),
  RulesSection('Комбінації та белот', [
    'З першою картою гравці оголошують свої послідовності в одній масті та каре. Комбінації записує лише сторона '
        'з найстаршою комбінацією, і вона записує всі свої.',
    'Гравець, що має короля й даму козирів, каже «белот», ходячи першою з них, і «ребелот», ходячи другою: 20 '
        'очок, які лишаються його стороні, хай би що сталося із замовленням.',
  ], tableHeader: ['Комбінація', 'Очки'], table: [
    ['Терц — три карти підряд', '20'],
    ['П\'ятдесят — чотири карти підряд', '50'],
    ['Сотня — п\'ять карт підряд', '100'],
    ['Каре тузів, десяток, королів чи дам', '100'],
    ['Каре дев\'яток', '150'],
    ['Каре валетів', '200'],
    ['Белот — король і дама козирів', '20'],
  ]),
  RulesSection('Виконання замовлення', [
    'Сторона, що замовила, виконує замовлення, коли її очки разом із комбінаціями та белотом сягають '
        'замовленого; капот виконано лише тоді, коли взято всі вісім взяток. Тоді вона записує свої очки плюс '
        'замовлення, а суперники — свої очки. Взятки капоту рахуються як 250 замість 162.',
    'Якщо замовлення провалено, суперники записують 160 плюс замовлення, а сторона, що замовила, зберігає лише свій '
        'белот. Куанш подвоює замовлення, сюркуанш — учетверяє, а очки карт лишаються як є. Усі очки округлюються '
        'до найближчого десятка, п\'ятірка — догори.',
    'У клубах ці деталі різняться: десь рахують лише замовлення, десь множать увесь рахунок, десь вимагають, '
        'щоб сторона, що замовила, ще й набрала більше за суперників. Застосунок рахує так, як описано тут.',
  ]),
  RulesSection('Перемога', [
    'Зазвичай грають до 2000 очок, іноді до 1000, 1500 чи 3000. Перемагає сторона, що першою досягла суми; якщо '
        'обидві досягли її в одній роздачі, перемагає та, у якої більше очок.',
  ]),
  RulesSection('Рахунок у застосунку', [
    'Після кожної роздачі натисніть «Нова роздача», виберіть сторону, що виграла торгівлю, встановіть її '
        'замовлення кнопками − і +, позначте куанш чи сюркуанш, порахуйте комбінації та введіть очки однієї '
        'сторони; застосунок порахує решту, додасть замовлення, помітить провал і стежитиме, хто роздає.',
    'Торкніться будь-якої роздачі в історії, щоб виправити чи видалити її, а ↶ — щоб скасувати останню.',
  ]),
];
