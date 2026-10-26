import 'rules_content.dart';

/// The rules of Coinche in [lang], English when there is none.
List<RulesSection> coincheRulesContent(String lang) => switch (lang) {
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

const _bg = [
  RulesSection('Играчи и карти', [
    'Коанш се играе от четирима в два отбора по двама, като партньорите седят един срещу друг, с тесте от 32 карти, '
        'от седмица до асо във всяка боя. Всеки играч получава осем карти и не се обръща карта.',
  ]),
  RulesSection('Стойност на картите', [
    'Последната взятка, „dix de der", добавя 10, така че картите в една раздача струват 162 точки.',
  ], tableHeader: ['Карта', 'Коз', 'Друга боя'], table: [
    ['Вале', '20', '2'],
    ['Деветка', '14', '0'],
    ['Асо', '11', '11'],
    ['Десетка', '10', '10'],
    ['Поп', '4', '4'],
    ['Дама', '3', '3'],
    ['Осмица, седмица', '0', '0'],
  ]),
  RulesSection('Обявяване', [
    'Като се започне отляво на раздаващия, всеки играч пасува или обявява брой точки и коз. Най-ниската обява е 80, '
        'всяка обява трябва да е по-висока от предишната, през десет, до 160; най-високата обява е капот — обещание '
        'да се вземат всички взятки.',
    'Наддаването свършва, когато другите трима пасуват подред след обява. Ако и четиримата пасуват в началото, '
        'картите се раздават отново.',
  ]),
  RulesSection('Коанш и сюркоанш', [
    'Противник, който се съмнява, че обявата може да бъде изпълнена, може да я коанширува: това приключва '
        'наддаването и удвоява стойността на обявата. Обявилата страна може да отговори със сюркоанш, който я '
        'удвоява отново.',
  ]),
  RulesSection('Анонси и белот', [
    'С първата карта играчите обявяват поредиците си в една боя и каретата си. Анонсите си записва само страната с '
        'най-добрия анонс, и то всичките.',
    'Играч с поп и дама коз казва „белот", когато играе първата, и „ребелот", когато играе втората, за 20 точки, '
        'които остават за тази страна, каквото и да стане с договора.',
  ], tableHeader: ['Анонс', 'Точки'], table: [
    ['Терца — три поред', '20'],
    ['Кварта — четири поредни', '50'],
    ['Квинта — пет поредни', '100'],
    ['Каре аса, десетки, попове или дами', '100'],
    ['Каре деветки', '150'],
    ['Каре валета', '200'],
    ['Белот — поп и дама коз', '20'],
  ]),
  RulesSection('Изпълнение на договора', [
    'Обявилата страна изпълнява договора, когато точките ѝ, заедно с анонсите и белота, достигнат обявата; капот се '
        'изпълнява само ако се вземат всичките осем взятки. Тогава страната записва точките си плюс обявата, а '
        'противниците записват своите точки. Взятките при капот струват 250 вместо 162.',
    'Когато договорът е провален, противниците записват 160 плюс обявата, а обявилата страна запазва само белота '
        'си. Коанш удвоява обявата, а сюркоанш я учетворява, докато точките от картите остават същите. Всички '
        'резултати се закръглят до най-близките десет, петиците нагоре.',
    'Клубовете се различават в тези подробности: някои броят само обявата, други умножават целия резултат, трети '
        'изискват обявилата страна и да надиграе противниците. Приложението следва описаното тук броене.',
  ]),
  RulesSection('Победа', [
    'Играта обикновено е до 2000 точки, понякога до 1000, 1500 или 3000. Печели страната, която първа стигне целта; '
        'когато и двете я стигнат в една раздача, печели по-високият резултат.',
  ]),
  RulesSection('Как се води резултатът в приложението', [
    'След всяка раздача натиснете „Нова раздача", изберете страната, спечелила наддаването, задайте обявата ѝ с − и '
        '+, отбележете коанш или сюркоанш, пребройте анонсите и въведете точките на едната страна; приложението '
        'изчислява останалото, добавя обявата, разпознава провален договор и следи кой раздава.',
    'Докоснете която и да е раздача в историята, за да я поправите или изтриете, и ↶, за да отмените последната.',
  ]),
];

const _hr = [
  RulesSection('Igrači i karte', [
    'Coinche igraju četvorica u dva para, a partneri sjede jedan nasuprot drugome, sa špilom od 32 karte, od '
        'sedmice do asa u svakoj boji. Svaki igrač dobiva osam karata i nijedna se karta ne okreće.',
  ]),
  RulesSection('Vrijednost karata', [
    'Zadnji štih, dix de der, dodaje 10, pa karte jednog dijeljenja vrijede 162 boda.',
  ], tableHeader: ['Karta', 'Adut', 'Ostale boje'], table: [
    ['Dečko', '20', '2'],
    ['Devetka', '14', '0'],
    ['As', '11', '11'],
    ['Desetka', '10', '10'],
    ['Kralj', '4', '4'],
    ['Baba', '3', '3'],
    ['Osmica, sedmica', '0', '0'],
  ]),
  RulesSection('Licitacija', [
    'Počevši lijevo od djelitelja, svaki igrač kaže dalje ili licitira broj bodova i boju aduta. Najniža licitacija '
        'je 80, svaka mora biti viša od prethodne, za po deset, do 160; najviša licitacija od svih je kapot, '
        'obećanje da će se uzeti svi štihovi.',
    'Licitacija završava kad ostala trojica nakon licitacije redom kažu dalje. Ako sva četvorica na početku kažu '
        'dalje, karte se dijele ponovno.',
  ]),
  RulesSection('Coinche i surcoinche', [
    'Protivnik koji sumnja da se licitacija može ispuniti može je coinchirati, čime licitacija završava, a '
        'vrijednost licitacije se udvostručuje. Strana koja je licitirala može odgovoriti surcoincheom, koji je '
        'ponovno udvostručuje.',
  ]),
  RulesSection('Zvanja i belote', [
    'S prvom kartom igrači zovu svoje nizove u jednoj boji i svoje četvorke. Svoja zvanja upisuje samo strana s '
        'najboljim zvanjem, i to sva.',
    'Igrač koji ima kralja i damu aduta kaže „belote" kad baci prvu i „rebelote" kad baci drugu, za 20 bodova koji '
        'ostaju toj strani što god se dogodilo s ugovorom.',
  ], tableHeader: ['Zvanje', 'Bodovi'], table: [
    ['Terca — tri zaredom', '20'],
    ['Cinquante — četiri zaredom', '50'],
    ['Cent — pet zaredom', '100'],
    ['Četiri asa, desetke, kralja ili babe', '100'],
    ['Četiri devetke', '150'],
    ['Četiri dečka', '200'],
    ['Belote — kralj i dama aduta', '20'],
  ]),
  RulesSection('Ispunjenje ugovora', [
    'Strana koja je licitirala ispunjava ugovor kad njezini bodovi, sa zvanjima i belote, dosegnu licitaciju; kapot '
        'se ispunjava samo uzimanjem svih osam štihova. Tada upisuje svoje bodove plus licitaciju, a protivnici '
        'upisuju svoje bodove. Štihovi kapota vrijede 250 umjesto 162.',
    'Kad ugovor padne, protivnici upisuju 160 plus licitaciju, a strana koja je licitirala zadržava samo svoj '
        'belote. Coinche udvostručuje licitaciju, a surcoinche je učetverostručuje, dok bodovi karata ostaju isti. '
        'Svi se rezultati zaokružuju na najbližu deseticu, petice prema gore.',
    'Klubovi se razlikuju u tim pojedinostima: neki broje samo licitaciju, neki množe cijeli rezultat, neki traže '
        'da strana koja je licitirala i nadigra protivnike. Aplikacija slijedi ovdje opisano brojanje.',
  ]),
  RulesSection('Pobjeda', [
    'Igra se obično igra do 2000 bodova, ponekad do 1000, 1500 ili 3000. Pobjeđuje strana koja prva dosegne cilj; '
        'kad ga obje dosegnu u istom dijeljenju, pobjeđuje viši rezultat.',
  ]),
  RulesSection('Vođenje rezultata u aplikaciji', [
    'Nakon svakog dijeljenja dodirnite „Novo dijeljenje", odaberite stranu koja je dobila licitaciju, postavite '
        'njezinu licitaciju s − i +, označite coinche ili surcoinche, prebrojite zvanja i upišite bodove jedne '
        'strane; aplikacija izračuna ostalo, dodaje licitaciju, prepoznaje pali ugovor i prati tko dijeli.',
    'Dodirnite bilo koje dijeljenje u povijesti da ga ispravite ili izbrišete, a ↶ da poništite zadnje.',
  ]),
];

const _nl = [
  RulesSection('Spelers en kaarten', [
    'Coinche wordt met vier gespeeld in twee teams van twee, met de partners tegenover elkaar, met 32 kaarten, '
        'zeven tot en met aas in elke kleur. Elke speler krijgt acht kaarten en er wordt geen kaart opengelegd.',
  ]),
  RulesSection('Waarde van de kaarten', [
    'De laatste slag, de dix de der, geeft er 10 bij, dus de kaarten van een spel zijn 162 punten waard.',
  ], tableHeader: ['Kaart', 'Troef', 'Andere kleur'], table: [
    ['Boer', '20', '2'],
    ['Negen', '14', '0'],
    ['Aas', '11', '11'],
    ['Tien', '10', '10'],
    ['Heer', '4', '4'],
    ['Vrouw', '3', '3'],
    ['Acht, zeven', '0', '0'],
  ]),
  RulesSection('Bieden', [
    'Te beginnen links van de gever past elke speler of biedt een aantal punten en een troefkleur. Het laagste bod '
        'is 80, elk bod moet hoger zijn dan het vorige, in stappen van tien, tot 160; het hoogste bod van allemaal '
        'is capot, de belofte om alle slagen te halen.',
    'Het bieden eindigt als de andere drie na een bod om de beurt passen. Als alle vier aan het begin passen, wordt '
        'er opnieuw gedeeld.',
  ]),
  RulesSection('Coinche en surcoinche', [
    'Een tegenstander die betwijfelt of een bod gehaald kan worden, kan het coinchen: dat beëindigt het bieden en '
        'verdubbelt de waarde van het bod. De biedende partij kan antwoorden met een surcoinche, die het opnieuw '
        'verdubbelt.',
  ]),
  RulesSection('Roem en de belote', [
    'Bij de eerste kaart melden spelers hun reeksen in één kleur en hun vier gelijke. Alleen de partij met de beste '
        'roem schrijft haar roem, en dan alles.',
    'Wie heer en vrouw van troef heeft, zegt ‘belote\' bij het spelen van de eerste en ‘rebelote\' bij de tweede, '
        'voor 20 punten die bij die partij blijven, wat er ook met het contract gebeurt.',
  ], tableHeader: ['Roem', 'Punten'], table: [
    ['Drie op een rij', '20'],
    ['Cinquante — vier op een rij', '50'],
    ['Cent — vijf op een rij', '100'],
    ['Vier azen, tienen, heren of vrouwen', '100'],
    ['Vier negens', '150'],
    ['Vier boeren', '200'],
    ['Belote — heer en vrouw van troef', '20'],
  ]),
  RulesSection('Het contract halen', [
    'De biedende partij haalt haar contract als haar punten, met roem en belote, het bod bereiken; een capot is '
        'alleen gehaald met alle acht slagen. Ze schrijft dan haar punten plus het bod, en de tegenpartij schrijft '
        'haar eigen punten. De slagen van een capot tellen 250 in plaats van 162.',
    'Mislukt het contract, dan schrijft de tegenpartij 160 plus het bod, en de biedende partij houdt alleen haar '
        'belote. Een coinche verdubbelt het bod en een surcoinche verviervoudigt het, terwijl de kaartpunten '
        'blijven zoals ze zijn. Alle scores worden afgerond op het dichtstbijzijnde tiental, vijven naar boven.',
    'Clubs verschillen in deze details: sommige tellen alleen het bod, sommige vermenigvuldigen de hele score, '
        'sommige eisen dat de biedende partij ook meer haalt dan de tegenpartij. De app volgt de telling die hier '
        'beschreven staat.',
  ]),
  RulesSection('Winnen', [
    'Er wordt meestal tot 2000 punten gespeeld, soms tot 1000, 1500 of 3000. De eerste partij die het doel haalt, '
        'wint; halen beide het in hetzelfde spel, dan wint de hoogste score.',
  ]),
  RulesSection('De stand bijhouden in de app', [
    'Tik na elk spel op ‘Nieuw spel\', kies de partij die het bieden won, stel haar bod in met − en +, geef een '
        'coinche of surcoinche aan, tel de roem en voer de punten van één partij in; de app rekent de rest uit, '
        'telt het bod erbij, ziet een mislukt contract en houdt bij wie deelt.',
    'Tik op een spel in de lijst om het te verbeteren of te verwijderen, en op ↶ om het laatste ongedaan te maken.',
  ]),
];

const _ar = [
  RulesSection('اللاعبون والأوراق', [
    'تُلعب كوانش بأربعة لاعبين في فريقين من لاعبَين، ويجلس الشريكان متقابلين، بـ32 ورقة، من السبعة إلى الإكَّة في '
        'كل نوع. يأخذ كل لاعب ثماني أوراق ولا تُكشف أي ورقة.',
  ]),
  RulesSection('قيمة الأوراق', [
    'الأكلة الأخيرة، dix de der، تضيف 10، فتساوي أوراق الجولة 162 نقطة.',
  ], tableHeader: ['الورقة', 'الحكم', 'نوع آخر'], table: [
    ['الولد', '20', '2'],
    ['التسعة', '14', '0'],
    ['الإكَّة', '11', '11'],
    ['العشرة', '10', '10'],
    ['الشايب', '4', '4'],
    ['البنت', '3', '3'],
    ['الثمانية، السبعة', '0', '0'],
  ]),
  RulesSection('المزايدة', [
    'بدءًا من يسار الموزّع، يمرّر كل لاعب أو يزايد بعدد من النقاط ونوع للحكم. أدنى مزايدة 80، ويجب أن تعلو كل '
        'مزايدة على سابقتها، بعشرة كل مرة، حتى 160؛ وأعلى مزايدة على الإطلاق هي الكابو، أي التعهد بأخذ كل الأكلات.',
    'تنتهي المزايدة حين يمرّر الثلاثة الآخرون تباعًا بعد مزايدة. وإذا مرّر الأربعة في البداية، تُوزَّع الأوراق من '
        'جديد.',
  ]),
  RulesSection('الكوانش والسوركوانش', [
    'الخصم الذي يشك في إمكان تنفيذ المزايدة يستطيع أن يقول كوانش، فتنتهي المزايدة وتتضاعف قيمتها. ويستطيع الطرف '
        'المزايد أن يردّ بسوركوانش، فتتضاعف مرة أخرى.',
  ]),
  RulesSection('المشاريع والبيلوت', [
    'مع الورقة الأولى يعلن اللاعبون متتالياتهم من نوع واحد وأربعهم المتشابهة. ولا يسجّل مشاريعه إلا الطرف صاحب أفضل '
        'مشروع، ويسجّلها كلها.',
    'من يملك الشايب والبنت من الحكم يقول «بيلوت» حين يلعب الأولى و«ريبيلوت» حين يلعب الثانية، مقابل 20 نقطة تبقى '
        'لذلك الطرف مهما حدث للعقد.',
  ], tableHeader: ['المشروع', 'النقاط'], table: [
    ['سرا — ثلاث متتالية', '20'],
    ['خمسين — أربع متتالية', '50'],
    ['مية — خمس متتالية', '100'],
    ['أربع إكَك أو عشرات أو شياب أو بنات', '100'],
    ['أربع تسعات', '150'],
    ['أربعة أولاد', '200'],
    ['بيلوت — الشايب والبنت من الحكم', '20'],
  ]),
  RulesSection('تنفيذ العقد', [
    'ينفّذ الطرف المزايد عقده حين تبلغ نقاطه، مع المشاريع والبيلوت، قيمة المزايدة؛ ولا يُنفَّذ الكابو إلا بأخذ '
        'الأكلات الثماني كلها. فيسجّل حينئذ نقاطه مضافًا إليها المزايدة، ويسجّل الخصوم نقاطهم. وتُحسب أكلات الكابو '
        '250 بدل 162.',
    'وإذا فشل العقد، يسجّل الخصوم 160 مضافًا إليها المزايدة، ولا يحتفظ الطرف المزايد إلا ببيلوته. الكوانش يضاعف '
        'المزايدة والسوركوانش يضربها في أربعة، أما نقاط الأوراق فتبقى كما هي. وتُقرَّب كل النتائج إلى أقرب عشرة، '
        'والخمسة إلى الأعلى.',
    'تختلف النوادي في هذه التفاصيل: بعضها يحسب المزايدة وحدها، وبعضها يضاعف النتيجة كلها، وبعضها يشترط أن يتفوق '
        'الطرف المزايد على خصومه أيضًا. ويتّبع التطبيق الحساب الموصوف هنا.',
  ]),
  RulesSection('الفوز', [
    'تُلعب اللعبة عادةً حتى 2000 نقطة، وأحيانًا حتى 1000 أو 1500 أو 3000. يفوز أول طرف يبلغ الهدف؛ وإذا بلغه '
        'الطرفان في الجولة نفسها، تفوز النتيجة الأعلى.',
  ]),
  RulesSection('تسجيل النتيجة في التطبيق', [
    'بعد كل جولة اضغط «جولة جديدة»، واختر الطرف الذي فاز بالمزايدة، وحدّد مزايدته بـ− و+، وعلّم الكوانش أو '
        'السوركوانش، واحسب المشاريع، واكتب نقاط أحد الطرفين؛ يحسب التطبيق الباقي، ويضيف المزايدة، ويكشف العقد '
        'الفاشل، ويتابع من يوزّع.',
    'اضغط على أي جولة في السجل لتصحيحها أو حذفها، و↶ للتراجع عن الأخيرة.',
  ]),
];
