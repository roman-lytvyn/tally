import 'rules_content.dart';

/// The rules of Belote in [lang], English when there is none.
List<RulesSection> beloteRulesContent(String lang) => switch (lang) {
  'uk' => _uk,
  'fr' => _fr,
  'bg' => _bg,
  'hr' => _hr,
  'nl' => _nl,
  'ar' => _ar,
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

const _bg = [
  RulesSection('Играчи и карти', [
    'Френският белот се играе от четирима в два отбора по двама, като партньорите седят един срещу друг; могат да '
        'играят и двама или трима, всеки за себе си. Играе се с тесте от 32 карти, от седмица до асо във всяка боя.',
    'Раздаващият дава на всеки играч по пет карти, три и после две, и обръща следващата карта с лицето нагоре. '
        'Раздаването върви около масата: след всяка раздача следващият раздава играчът отляво на раздаващия.',
  ]),
  RulesSection('Вземане на коза', [
    'Като се започне от играча отляво на раздаващия, всеки може да вземе обърнатата карта, така че боята ѝ става '
        'коз, или да пасува. Ако всички пасуват, във втори кръг играч може да обяви която и да е друга боя. Ако '
        'всички пак пасуват, картите се хвърлят и раздава следващият играч.',
    'Играчът, който взема коза, получава обърнатата карта и още две; всички останали получават по три, така че '
        'всеки държи осем.',
    'Който вземе коза, трябва да събере в тази раздача повече от противниците.',
  ]),
  RulesSection('Игра на картите', [
    'Играчите трябва да отговарят на изиграната боя. Който не може, трябва да цака с коз, освен ако партньорът му '
        'вече не печели взятката, а коз, сложен върху коз, трябва да го надвиши винаги когато може.',
    'В коза редът е вале, деветка, асо, десетка, поп, дама, осмица, седмица; в другите бои — асо, десетка, поп, '
        'дама, вале, деветка, осмица, седмица.',
  ]),
  RulesSection('Стойност на картите', [
    'Картите струват общо 152 точки, а последната взятка, „dix de der", добавя 10, така че всяка раздача струва 162 '
        'преди анонсите.',
  ], tableHeader: ['Карта', 'Коз', 'Другите бои'], table: [
    ['Вале', '20', '2'],
    ['Деветка', '14', '0'],
    ['Асо', '11', '11'],
    ['Десетка', '10', '10'],
    ['Поп', '4', '4'],
    ['Дама', '3', '3'],
    ['Осмица, седмица', '0', '0'],
  ]),
  RulesSection('Анонси', [
    'Комбинациите се обявяват на първата взятка. Поредиците си записва само страната с най-добрата поредица, а '
        'каретата — само страната с най-доброто каре. Всичко обявено се добавя към стойността на раздаването.',
  ], tableHeader: ['Анонс', 'Точки'], table: [
    ['Терца — три поред', '20'],
    ['Петдесет — четири поредни', '50'],
    ['Сто — пет поредни', '100'],
    ['Каре валета', '200'],
    ['Каре деветки', '150'],
    ['Каре аса, десетки, попове или дами', '100'],
    ['Белот-ребелот — поп и дама коз', '20'],
  ]),
  RulesSection('Белот-ребелот', [
    'Играч с поп и дама коз казва „белот", когато играе първата от тях, и „ребелот", когато играе втората. 20-те '
        'точки остават за тази страна, каквото и да стане с раздаването.',
  ]),
  RulesSection('Капот', [
    'Страна, която вземе всички взятки, прави капот: тогава картите струват 252 вместо 162.',
  ]),
  RulesSection('Дедан', [
    'Ако страната, взела коза, събере по-малко от противниците, тя е дедан: противниците получават цялото раздаване '
        'с всички анонси, а взелият коза запазва само своя белот-ребелот.',
  ]),
  RulesSection('Литиж — равна раздача', [
    'Ако взелият коза събере точно колкото противниците, раздаването е литиж. Противниците записват своите точки, а '
        'точките на взелия коза чакат победителя в следващата раздача. Приложението позволява да го решите по друг '
        'начин, ако на вашата маса се играе така.',
  ]),
  RulesSection('Победа', [
    'Печели страната, която първа стигне уговорената цел: 1000 точки или 500 за кратка игра. Когато и двете я '
        'прехвърлят в една раздача, печели страната с повече точки или, ако на вашата маса се играе така, страната, '
        'взела коза.',
  ]),
  RulesSection('Как се води резултатът в приложението', [
    'След всяка раздача натиснете „Нова раздача", изберете кой е взел коза, пребройте анонсите, отбележете капот и '
        'кой е имал белота и въведете точките на едната страна; приложението изчислява останалото, разпознава дедан '
        'и литиж и следи кой раздава.',
    'Докоснете която и да е раздача в историята, за да я поправите или изтриете, и ↶, за да отмените последната.',
  ]),
];

const _hr = [
  RulesSection('Igrači i karte', [
    'Belote igraju četvorica u dva para, a partneri sjede jedan nasuprot drugome; mogu igrati i dvojica ili '
        'trojica, svatko za sebe. Igra se špilom od 32 karte, od sedmice do asa u svakoj boji.',
    'Djelitelj svakom igraču daje pet karata, tri pa dvije, i okreće sljedeću kartu licem prema gore. Dijeljenje '
        'ide oko stola: nakon svakog dijeljenja sljedeći dijeli igrač lijevo od djelitelja.',
  ]),
  RulesSection('Uzimanje aduta', [
    'Počevši od igrača lijevo od djelitelja, svaki može uzeti okrenutu kartu, čime njezina boja postaje adut, ili '
        'reći dalje. Ako svi kažu dalje, u drugom krugu igrač može zvati bilo koju drugu boju. Ako svi opet kažu '
        'dalje, karte se bacaju i dijeli sljedeći igrač.',
    'Igrač koji uzme aduta dobiva okrenutu kartu i još dvije; svi ostali dobivaju po tri, pa svatko drži osam.',
    'Tko uzme aduta, mora u tom dijeljenju skupiti više od protivnika.',
  ]),
  RulesSection('Igranje karata', [
    'Igrači moraju odgovoriti na boju koja je izašla. Tko ne može, mora rezati adutom, osim ako njegov partner već '
        'dobiva štih, a adut bačen na aduta mora ga nadjačati kad god može.',
    'U adutu je redoslijed dečko, devetka, as, desetka, kralj, dama, osmica, sedmica; u ostalim bojama as, desetka, '
        'kralj, dama, dečko, devetka, osmica, sedmica.',
  ]),
  RulesSection('Vrijednost karata', [
    'Karte ukupno vrijede 152 boda, a zadnji štih, dix de der, dodaje 10, pa svako dijeljenje vrijedi 162 prije '
        'zvanja.',
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
    'Kombinacije se zovu na prvom štihu. Svoje nizove upisuje samo strana s najboljim nizom, a svoje četvorke samo '
        'strana s najboljom četvorkom. Sve što je zvano dodaje se vrijednosti dijeljenja.',
  ], tableHeader: ['Zvanje', 'Bodovi'], table: [
    ['Terca — tri zaredom', '20'],
    ['Pedeset — četiri zaredom', '50'],
    ['Sto — pet zaredom', '100'],
    ['Četiri dečka', '200'],
    ['Četiri devetke', '150'],
    ['Četiri asa, desetke, kralja ili babe', '100'],
    ['Belote-rebelote — kralj i dama aduta', '20'],
  ]),
  RulesSection('Belote-rebelote', [
    'Igrač koji ima kralja i damu aduta kaže „belote" kad baci prvu od njih i „rebelote" kad baci drugu. Tih 20 '
        'bodova ostaje toj strani što god se dogodilo s dijeljenjem.',
  ]),
  RulesSection('Kapot', [
    'Strana koja uzme sve štihove radi kapot: karte tada vrijede 252 umjesto 162.',
  ]),
  RulesSection('Dedans', [
    'Ako strana koja je uzela aduta skupi manje od protivnika, to je dedans: protivnici dobivaju cijelo dijeljenje '
        'sa svim zvanjima, a onaj tko je uzeo aduta zadržava samo svoj belote-rebelote.',
  ]),
  RulesSection('Litige — izjednačeno dijeljenje', [
    'Ako onaj tko je uzeo aduta skupi točno koliko i protivnici, dijeljenje je litige. Protivnici upisuju svoje '
        'bodove, a bodovi onoga tko je uzeo aduta čekaju pobjednika sljedećeg dijeljenja. Aplikacija omogućuje da '
        'to riješite drukčije ako se za vašim stolom tako igra.',
  ]),
  RulesSection('Pobjeda', [
    'Pobjeđuje strana koja prva dosegne dogovoreni cilj: 1000 bodova ili 500 za kratku igru. Kad obje prijeđu cilj '
        'u istom dijeljenju, pobjeđuje strana s više bodova ili, ako se za vašim stolom tako igra, strana koja je '
        'uzela aduta.',
  ]),
  RulesSection('Vođenje rezultata u aplikaciji', [
    'Nakon svakog dijeljenja dodirnite „Novo dijeljenje", odaberite tko je uzeo aduta, prebrojite zvanja, označite '
        'kapot i tko je imao belote te upišite bodove jedne strane; aplikacija izračuna ostalo, prepoznaje dedans i '
        'litige i prati tko dijeli.',
    'Dodirnite bilo koje dijeljenje u povijesti da ga ispravite ili izbrišete, a ↶ da poništite zadnje.',
  ]),
];

const _nl = [
  RulesSection('Spelers en kaarten', [
    'Belote wordt met vier gespeeld in twee teams van twee, met de partners tegenover elkaar; met twee of drie kan '
        'ook, ieder voor zich. Er wordt gespeeld met 32 kaarten, zeven tot en met aas in elke kleur.',
    'De gever geeft elke speler vijf kaarten, eerst drie en dan twee, en legt de volgende kaart open. Het delen '
        'gaat de tafel rond: na elk spel deelt de speler links van de gever.',
  ]),
  RulesSection('Troef nemen', [
    'Te beginnen bij de speler links van de gever mag ieder de open kaart nemen, waarmee die kleur troef wordt, of '
        'passen. Als iedereen past, mag een speler in een tweede ronde een andere kleur noemen. Past iedereen '
        'opnieuw, dan worden de kaarten ingegooid en deelt de volgende speler.',
    'Wie troef neemt, krijgt de open kaart en nog twee; alle anderen krijgen er drie, zodat ieder er acht heeft.',
    'Wie troef neemt, moet in dat spel meer halen dan de tegenpartij.',
  ]),
  RulesSection('Kaarten spelen', [
    'Spelers moeten de gevraagde kleur bekennen. Wie dat niet kan, moet troeven, tenzij de partner de slag al wint, '
        'en een troef op een troef moet die overtroeven wanneer dat kan.',
    'In troef is de volgorde boer, negen, aas, tien, heer, vrouw, acht, zeven; in de andere kleuren aas, tien, '
        'heer, vrouw, boer, negen, acht, zeven.',
  ]),
  RulesSection('Waarde van de kaarten', [
    'De kaarten zijn samen 152 punten waard en de laatste slag, dix de der, geeft er 10 bij, dus elk spel is 162 '
        'waard vóór de roem.',
  ], tableHeader: ['Kaart', 'Troef', 'Andere kleuren'], table: [
    ['Boer', '20', '2'],
    ['Negen', '14', '0'],
    ['Aas', '11', '11'],
    ['Tien', '10', '10'],
    ['Heer', '4', '4'],
    ['Vrouw', '3', '3'],
    ['Acht, zeven', '0', '0'],
  ]),
  RulesSection('Roem', [
    'Combinaties worden bij de eerste slag gemeld. Alleen de partij met de beste reeks schrijft haar reeksen, en '
        'alleen de partij met de beste vier gelijke schrijft haar vieren. Alle gemelde roem komt bij de waarde van '
        'het spel.',
  ], tableHeader: ['Roem', 'Punten'], table: [
    ['Drie op een rij', '20'],
    ['Vijftig — vier op een rij', '50'],
    ['Honderd — vijf op een rij', '100'],
    ['Vier boeren', '200'],
    ['Vier negens', '150'],
    ['Vier azen, tienen, heren of vrouwen', '100'],
    ['Belote-rebelote — heer en vrouw van troef', '20'],
  ]),
  RulesSection('Belote-rebelote', [
    'Wie heer en vrouw van troef heeft, zegt ‘belote\' bij het spelen van de eerste en ‘rebelote\' bij de tweede. '
        'De 20 punten blijven bij die partij, wat er ook met het spel gebeurt.',
  ]),
  RulesSection('Capot', [
    'Een partij die alle slagen haalt, maakt capot: de kaarten zijn dan 252 waard in plaats van 162.',
  ]),
  RulesSection('Dedans', [
    'Als de partij die troef nam minder haalt dan de tegenpartij, is ze dedans: de tegenpartij krijgt het hele spel '
        'met alle roem, en de troefnemer houdt alleen haar belote-rebelote.',
  ]),
  RulesSection('Litige — een gelijk spel', [
    'Als de troefnemer precies evenveel haalt als de tegenpartij, is het spel een litige. De tegenpartij schrijft '
        'haar punten, en de punten van de troefnemer wachten op de winnaar van het volgende spel. In de app kun je '
        'het anders regelen als jullie tafel dat doet.',
  ]),
  RulesSection('Winnen', [
    'De eerste partij die het afgesproken doel haalt, wint: 1000 punten, of 500 voor een kort spel. Halen beide het '
        'doel in hetzelfde spel, dan wint de partij met de meeste punten of, als jullie tafel het zo speelt, de '
        'partij die troef nam.',
  ]),
  RulesSection('De stand bijhouden in de app', [
    'Tik na elk spel op ‘Nieuw spel\', kies wie troef nam, tel de roem, geef capot aan en wie de belote had, en '
        'voer de punten van één partij in; de app rekent de rest uit, ziet dedans en litige en houdt bij wie deelt.',
    'Tik op een spel in de lijst om het te verbeteren of te verwijderen, en op ↶ om het laatste ongedaan te maken.',
  ]),
];

const _ar = [
  RulesSection('اللاعبون والأوراق', [
    'تُلعب البيلوت بأربعة لاعبين في فريقين من لاعبَين، ويجلس الشريكان متقابلين؛ ويمكن أن يلعب اثنان أو ثلاثة أيضًا، '
        'كلٌّ لنفسه. تُستخدم 32 ورقة، من السبعة إلى الإكَّة في كل نوع.',
    'يعطي الموزّع كل لاعب خمس أوراق، ثلاثًا ثم اثنتين، ويكشف الورقة التالية. يدور التوزيع حول الطاولة: بعد كل جولة '
        'يوزّع اللاعب الجالس على يسار الموزّع.',
  ]),
  RulesSection('أخذ الحكم', [
    'بدءًا من اللاعب على يسار الموزّع، يستطيع كل لاعب أن يأخذ الورقة المكشوفة فيصبح نوعها حكمًا، أو أن يمرّر. إذا '
        'مرّر الجميع، يستطيع لاعب في دور ثانٍ أن يسمّي أي نوع آخر. وإذا مرّر الجميع مرة أخرى، تُرمى الأوراق ويوزّع '
        'اللاعب التالي.',
    'يأخذ آخذ الحكم الورقة المكشوفة وورقتين أخريين؛ ويأخذ الباقون ثلاثًا لكل منهم، فيكون مع كل لاعب ثماني أوراق.',
    'من يأخذ الحكم عليه أن يجمع في تلك الجولة أكثر من خصومه.',
  ]),
  RulesSection('لعب الأوراق', [
    'على اللاعبين أن يلعبوا من النوع المطلوب. ومن لا يستطيع فعليه أن يقطع بالحكم، إلا إذا كان شريكه يربح الأكلة، '
        'وورقة الحكم الملعوبة فوق ورقة حكم يجب أن تعلوها كلما أمكن.',
    'في الحكم يكون الترتيب: الولد، التسعة، الإكَّة، العشرة، الشايب، البنت، الثمانية، السبعة؛ وفي الأنواع الأخرى: '
        'الإكَّة، العشرة، الشايب، البنت، الولد، التسعة، الثمانية، السبعة.',
  ]),
  RulesSection('قيمة الأوراق', [
    'مجموع قيمة الأوراق 152 نقطة، والأكلة الأخيرة، dix de der، تضيف 10، فتساوي كل جولة 162 قبل المشاريع.',
  ], tableHeader: ['الورقة', 'الحكم', 'الأنواع الأخرى'], table: [
    ['الولد', '20', '2'],
    ['التسعة', '14', '0'],
    ['الإكَّة', '11', '11'],
    ['العشرة', '10', '10'],
    ['الشايب', '4', '4'],
    ['البنت', '3', '3'],
    ['الثمانية، السبعة', '0', '0'],
  ]),
  RulesSection('المشاريع', [
    'تُعلن التشكيلات في الأكلة الأولى. لا يسجّل متتالياته إلا الطرف صاحب أفضل متتالية، ولا يسجّل الأربع المتشابهة '
        'إلا الطرف صاحب أفضل أربع. ويُضاف كل ما أُعلن إلى قيمة الجولة.',
  ], tableHeader: ['المشروع', 'النقاط'], table: [
    ['سرا — ثلاث متتالية', '20'],
    ['خمسين — أربع متتالية', '50'],
    ['مية — خمس متتالية', '100'],
    ['أربعة أولاد', '200'],
    ['أربع تسعات', '150'],
    ['أربع إكَك أو عشرات أو شياب أو بنات', '100'],
    ['بيلوت-ريبيلوت — الشايب والبنت من الحكم', '20'],
  ]),
  RulesSection('بيلوت-ريبيلوت', [
    'من يملك الشايب والبنت من الحكم يقول «بيلوت» حين يلعب الأولى منهما و«ريبيلوت» حين يلعب الثانية. وتبقى النقاط '
        'العشرون لذلك الطرف مهما حدث في الجولة.',
  ]),
  RulesSection('الكابو', [
    'الطرف الذي يأخذ كل الأكلات يسجّل كابو: وتساوي الأوراق حينئذ 252 بدل 162.',
  ]),
  RulesSection('الدودان', [
    'إذا جمع الطرف الذي أخذ الحكم أقل من خصومه، يكون دودان: يأخذ الخصوم الجولة كلها مع كل المشاريع، ولا يحتفظ آخذ '
        'الحكم إلا ببيلوت-ريبيلوت.',
  ]),
  RulesSection('الليتيج — جولة متعادلة', [
    'إذا جمع آخذ الحكم مثل خصومه تمامًا، تكون الجولة ليتيج. يسجّل الخصوم نقاطهم، وتنتظر نقاط آخذ الحكم الفائز '
        'بالجولة التالية. ويتيح التطبيق حسمها بطريقة أخرى إن كانت طاولتكم تلعب هكذا.',
  ]),
  RulesSection('الفوز', [
    'يفوز أول طرف يبلغ الهدف المتفق عليه: 1000 نقطة، أو 500 للعبة قصيرة. وإذا تجاوزه الطرفان في الجولة نفسها، يفوز '
        'الطرف صاحب النقاط الأكثر، أو، إن كانت طاولتكم تلعب هكذا، الطرف الذي أخذ الحكم.',
  ]),
  RulesSection('تسجيل النتيجة في التطبيق', [
    'بعد كل جولة اضغط «جولة جديدة»، واختر من أخذ الحكم، واحسب المشاريع، وعلّم الكابو ومن كانت معه البيلوت، واكتب '
        'نقاط أحد الطرفين؛ يحسب التطبيق الباقي، ويكشف الدودان والليتيج، ويتابع من يوزّع.',
    'اضغط على أي جولة في السجل لتصحيحها أو حذفها، و↶ للتراجع عن الأخيرة.',
  ]),
];
