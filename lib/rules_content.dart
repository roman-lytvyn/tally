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
    : switch (lang) {
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

const _fr = [
  RulesSection('Joueurs et cartes', [
    'Deux ou trois joueurs jouent chacun pour soi ; à quatre, on joue en deux équipes de deux, les partenaires '
        'assis face à face. Le jeu utilise 32 cartes, du sept à l\'as dans chaque couleur.',
    'La donne tourne autour de la table : après chaque donne, le joueur à gauche du donneur donne à son tour.',
  ]),
  RulesSection('Prendre l\'atout', [
    'Après la distribution, une carte est retournée. Le joueur à gauche du donneur peut prendre sa couleur comme '
        'atout ou passer, et le droit fait le tour de la table. Si tout le monde passe, une autre couleur peut être '
        'nommée au second tour ; si tout le monde passe encore, les cartes sont jetées et le joueur suivant donne.',
    'Certaines tables jouent « avec obligation » : quand tous les autres passent, le donneur doit prendre l\'atout.',
    'Le preneur doit marquer plus de points que ses adversaires dans la donne.',
  ]),
  RulesSection('Valeur des cartes', [
    'Les cartes valent 152 points au total et le dernier pli ajoute 10, donc chaque donne vaut 162 avant les '
        'annonces.',
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
    'Les suites d\'une même couleur s\'annoncent au début de la donne ; seul le camp qui a la plus forte suite '
        'marque ses suites. Tout ce qui est annoncé s\'ajoute à la valeur de la donne.',
  ], tableHeader: ['Annonce', 'Points'], table: [
    ['Tierce — trois cartes qui se suivent', '20'],
    ['Cinquante — quatre qui se suivent', '50'],
    ['Bella — roi et dame d\'atout', '20'],
    ['Deberc — sept atouts qui se suivent', 'gagne la partie'],
  ]),
  RulesSection('Dedans', [
    'Si le camp qui a pris l\'atout marque moins qu\'un adversaire, la donne est dedans : les adversaires reçoivent '
        'toute la valeur de la donne et le preneur n\'a rien. À trois joueurs, la donne va à l\'adversaire qui a '
        'marqué le plus, et deux adversaires à égalité en tête se la partagent.',
  ]),
  RulesSection('Pénalités', [
    'Beaucoup de tables ajoutent des pénalités, fixées avant la partie ; l\'application permet de les choisir dans '
        'les réglages et les retire du score d\'elle-même :',
    '• Dedans répétés — un camp perd 50 ou 100 points de plus pour son troisième dedans, pour le troisième et '
        'chacun des suivants, ou pour chaque troisième. Les dedans se comptent sur toute la partie ou seulement '
        'd\'affilée ; en équipe, le dedans compte pour l\'équipe.',
    '• Aucun pli — un camp qui ne fait aucun pli dans une donne perd 50 ou 100 points.',
  ]),
  RulesSection('Litige — une donne à égalité', [
    'Si le preneur marque exactement autant que les adversaires, la donne est en « litige ». Les tables le règlent '
        'différemment, et l\'application permet de choisir avant la partie :',
    '• En suspens — les adversaires marquent leurs points ; ceux du preneur attendent le gagnant de la donne '
        'suivante.',
    '• Aux adversaires — l\'égalité compte comme dedans.',
    '• Chacun ses points — les deux camps marquent ce qu\'ils ont pris.',
  ]),
  RulesSection('Deberc', [
    'Sept atouts qui se suivent dans une même main font un deberc. Le camp qui l\'annonce gagne toute la partie '
        'd\'un coup, quel que soit le score.',
  ]),
  RulesSection('La victoire', [
    'Le premier camp à atteindre le total convenu gagne : 301 pour une partie courte, 501 ou 1001. Quand les deux '
        'le dépassent dans la même donne, les tables le règlent différemment, et l\'application permet de choisir '
        'avant la partie :',
    '• Le plus de points — le camp au score le plus élevé gagne ; à égalité, la partie continue.',
    '• Le preneur — le camp qui a pris l\'atout dans cette donne gagne, même avec moins de points.',
  ]),
  RulesSection('Tenir le score dans l\'application', [
    'Après chaque donne, touchez « Nouvelle donne », choisissez qui a pris l\'atout, comptez les annonces et '
        'saisissez les points d\'un camp ; l\'application calcule le reste, repère le dedans et le litige, et sait '
        'qui donne.',
    'Touchez une donne de l\'historique pour la corriger ou la supprimer, et ↶ pour annuler la dernière.',
  ]),
];

const _bg = [
  RulesSection('Играчи и карти', [
    'Двама или трима играчи играят всеки за себе си; четирима играят в два отбора по двама, като партньорите седят '
        'един срещу друг. Играе се с тесте от 32 карти, от седмица до асо във всяка боя.',
    'Раздаването върви около масата: след всяка раздача следващият раздава играчът отляво на раздаващия.',
  ]),
  RulesSection('Вземане на коза', [
    'След раздаването една карта се обръща с лицето нагоре. Играчът отляво на раздаващия може да вземе боята ѝ за '
        'коз или да пасува, и правото обикаля масата. Ако всички пасуват, във втори кръг може да се обяви друга '
        'боя; ако всички пак пасуват, картите се хвърлят и раздава следващият играч.',
    'На някои маси се играе „със задължение": когато всички останали пасуват, раздаващият трябва да вземе коза.',
    'Който вземе коза, трябва да събере в тази раздача повече от противниците.',
  ]),
  RulesSection('Стойност на картите', [
    'Картите струват общо 152 точки, а последната взятка добавя 10, така че всяка раздача струва 162 преди анонсите.',
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
    'Поредиците от една боя се обявяват в началото на раздаването; поредиците си записва само страната с '
        'най-високата поредица. Всичко обявено се добавя към стойността на раздаването.',
  ], tableHeader: ['Анонс', 'Точки'], table: [
    ['Терца — три поред', '20'],
    ['Петдесет — четири поредни', '50'],
    ['Бела — поп и дама коз', '20'],
    ['Деберц — седем поредни коза', 'печели играта'],
  ]),
  RulesSection('Байт', [
    'Ако страната, взела коза, събере по-малко от някой противник, раздаването е байт: противниците получават '
        'цялата стойност на раздаването, а взелият коза не получава нищо. При трима играчи раздаването отива при '
        'противника, събрал повече, а двама противници с равен най-висок резултат го делят.',
  ]),
  RulesSection('Наказания', [
    'Много маси добавят наказания, уговорени преди играта; приложението позволява да ги изберете в настройките и '
        'сам ги изважда от резултата:',
    '• Повторен байт — страната губи още 50 или 100 точки за третия си байт, за третия и всеки следващ или за всеки '
        'трети. Байтовете се броят за цялата игра или само поред; при отбори байтът се брои на отбора.',
    '• Ски — страна, която не вземе нито една взятка в раздаването, губи 50 или 100 точки.',
  ]),
  RulesSection('Яйца — равна раздача', [
    'Ако взелият коза събере точно колкото противниците, раздаването е „яйца". Масите го решават различно, а '
        'приложението позволява да изберете преди играта:',
    '• Висят — противниците записват своите точки; точките на взелия коза чакат победителя в следващата раздача.',
    '• За противниците — равенството се брои за байт.',
    '• Всеки своите — двете страни записват каквото са взели.',
  ]),
  RulesSection('Деберц', [
    'Седем поредни коза в една ръка са деберц. Страната, която го обяви, печели цялата игра наведнъж, независимо от '
        'резултата.',
  ]),
  RulesSection('Победа', [
    'Печели страната, която първа стигне уговорената цел: 301 за кратка игра, 501 или 1001. Когато и двете я '
        'прехвърлят в една раздача, масите го решават различно, а приложението позволява да изберете преди играта:',
    '• Повече точки — печели страната с по-висок резултат; при равен резултат играта продължава.',
    '• Играещият — печели страната, взела коза в тази раздача, дори с по-малко точки.',
  ]),
  RulesSection('Как се води резултатът в приложението', [
    'След всяка раздача натиснете „Нова раздача", изберете кой е взел коза, пребройте анонсите и въведете точките '
        'на едната страна; приложението изчислява останалото, разпознава байт и яйца и следи кой раздава.',
    'Докоснете която и да е раздача в историята, за да я поправите или изтриете, и ↶, за да отмените последната.',
  ]),
];

const _hr = [
  RulesSection('Igrači i karte', [
    'Dva ili tri igrača igraju svatko za sebe; četvorica igraju u dva para, a partneri sjede jedan nasuprot '
        'drugome. Igra se špilom od 32 karte, od sedmice do asa u svakoj boji.',
    'Dijeljenje ide oko stola: nakon svakog dijeljenja sljedeći dijeli igrač lijevo od djelitelja.',
  ]),
  RulesSection('Uzimanje aduta', [
    'Nakon dijeljenja jedna se karta okreće licem prema gore. Igrač lijevo od djelitelja može uzeti njezinu boju za '
        'aduta ili reći dalje, a pravo ide oko stola. Ako svi kažu dalje, u drugom krugu može se zvati druga boja; '
        'ako svi opet kažu dalje, karte se bacaju i dijeli sljedeći igrač.',
    'Za nekim se stolovima igra „s obvezom": kad svi ostali kažu dalje, djelitelj mora uzeti aduta.',
    'Tko uzme aduta, mora u tom dijeljenju skupiti više od protivnika.',
  ]),
  RulesSection('Vrijednost karata', [
    'Karte ukupno vrijede 152 boda, a zadnji štih dodaje 10, pa svako dijeljenje vrijedi 162 prije zvanja.',
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
    'Nizovi u istoj boji zovu se na početku dijeljenja; svoje nizove upisuje samo strana s najjačim nizom. Sve što '
        'je zvano dodaje se vrijednosti dijeljenja.',
  ], tableHeader: ['Zvanje', 'Bodovi'], table: [
    ['Terca — tri zaredom', '20'],
    ['Pedeset — četiri zaredom', '50'],
    ['Bela — kralj i dama aduta', '20'],
    ['Deberc — sedam aduta zaredom', 'osvaja igru'],
  ]),
  RulesSection('Bait', [
    'Ako strana koja je uzela aduta skupi manje od nekog protivnika, dijeljenje je bait: protivnici dobivaju cijelu '
        'vrijednost dijeljenja, a onaj tko je uzeo aduta ne dobiva ništa. Kod tri igrača dijeljenje ide protivniku '
        'koji je skupio više, a dva protivnika s jednakim najvećim rezultatom dijele ga.',
  ]),
  RulesSection('Kazne', [
    'Mnogi stolovi dodaju kazne, dogovorene prije igre; aplikacija ih omogućuje odabrati u postavkama i sama ih '
        'oduzima od rezultata:',
    '• Ponovljeni bait — strana gubi još 50 ili 100 bodova za svoj treći bait, za treći i svaki sljedeći ili za '
        'svaki treći. Baitovi se broje kroz cijelu igru ili samo zaredom; u paru se bait broji timu.',
    '• Bez ijednog štiha — strana koja u dijeljenju ne uzme nijedan štih gubi 50 ili 100 bodova.',
  ]),
  RulesSection('Jaja — izjednačeno dijeljenje', [
    'Ako onaj tko je uzeo aduta skupi točno koliko i protivnici, dijeljenje su „jaja". Stolovi to rješavaju '
        'različito, a aplikacija omogućuje odabir prije igre:',
    '• Visi — protivnici upisuju svoje bodove; bodovi onoga tko je uzeo aduta čekaju pobjednika sljedećeg '
        'dijeljenja.',
    '• Protivnicima — izjednačeno se broji kao bait.',
    '• Svakom svoje — obje strane upisuju ono što su uzele.',
  ]),
  RulesSection('Deberc', [
    'Sedam aduta zaredom u jednoj ruci čine deberc. Strana koja ga zove odjednom osvaja cijelu igru, bez obzira na '
        'rezultat.',
  ]),
  RulesSection('Pobjeda', [
    'Pobjeđuje strana koja prva dosegne dogovoreni cilj: 301 za kratku igru, 501 ili 1001. Kad obje prijeđu cilj u '
        'istom dijeljenju, stolovi to rješavaju različito, a aplikacija omogućuje odabir prije igre:',
    '• Više bodova — pobjeđuje strana s višim rezultatom; kod jednakog rezultata igra se dalje.',
    '• Tko je zvao — pobjeđuje strana koja je u tom dijeljenju uzela aduta, čak i s manje bodova.',
  ]),
  RulesSection('Vođenje rezultata u aplikaciji', [
    'Nakon svakog dijeljenja dodirnite „Novo dijeljenje", odaberite tko je uzeo aduta, prebrojite zvanja i upišite '
        'bodove jedne strane; aplikacija izračuna ostalo, prepoznaje bait i jaja i prati tko dijeli.',
    'Dodirnite bilo koje dijeljenje u povijesti da ga ispravite ili izbrišete, a ↶ da poništite zadnje.',
  ]),
];

const _nl = [
  RulesSection('Spelers en kaarten', [
    'Twee of drie spelers spelen ieder voor zich; met vier speel je in twee teams van twee, met de partners '
        'tegenover elkaar. Er wordt gespeeld met 32 kaarten, zeven tot en met aas in elke kleur.',
    'Het delen gaat de tafel rond: na elk spel deelt de speler links van de gever.',
  ]),
  RulesSection('Troef nemen', [
    'Na het delen wordt één kaart opengelegd. De speler links van de gever mag die kleur als troef nemen of passen, '
        'en het recht gaat de tafel rond. Als iedereen past, mag in een tweede ronde een andere kleur genoemd '
        'worden; past iedereen opnieuw, dan worden de kaarten ingegooid en deelt de volgende speler.',
    'Aan sommige tafels wordt ‘met verplichting\' gespeeld: als alle anderen passen, moet de gever de troef nemen.',
    'Wie troef neemt, moet in dat spel meer halen dan de tegenpartij.',
  ]),
  RulesSection('Waarde van de kaarten', [
    'De kaarten zijn samen 152 punten waard en de laatste slag geeft er 10 bij, dus elk spel is 162 waard vóór de '
        'roem.',
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
    'Reeksen in één kleur worden aan het begin van het spel gemeld; alleen de partij met de hoogste reeks schrijft '
        'haar reeksen. Alle gemelde roem komt bij de waarde van het spel.',
  ], tableHeader: ['Roem', 'Punten'], table: [
    ['Drie op een rij', '20'],
    ['Vijftig — vier op een rij', '50'],
    ['Bella — heer en vrouw van troef', '20'],
    ['Deberc — zeven troeven op een rij', 'wint het spel'],
  ]),
  RulesSection('Bait', [
    'Als de partij die troef nam minder haalt dan een tegenstander, is het spel bait: de tegenpartij krijgt de hele '
        'waarde van het spel en de troefnemer krijgt niets. Met drie spelers gaat het spel naar de tegenstander die '
        'het meest haalde, en twee tegenstanders die gelijk bovenaan staan delen het.',
  ]),
  RulesSection('Straffen', [
    'Veel tafels voegen straffen toe, vooraf afgesproken; in de app kies je ze bij de instellingen en hij trekt ze '
        'zelf van de score af:',
    '• Herhaalde bait — een partij verliest 50 of 100 punten extra bij haar derde bait, bij de derde en elke '
        'volgende, of bij elke derde. Baits tellen over het hele spel of alleen achter elkaar; in teams telt de '
        'bait voor het team.',
    '• Geen slag — een partij die in een spel geen enkele slag haalt, verliest 50 of 100 punten.',
  ]),
  RulesSection('Eieren — een gelijk spel', [
    'Als de troefnemer precies evenveel haalt als de tegenpartij, is het spel ‘eieren\'. Tafels regelen dat '
        'verschillend, en in de app kies je vooraf:',
    '• Blijft hangen — de tegenpartij schrijft haar punten; de punten van de troefnemer wachten op de winnaar van '
        'het volgende spel.',
    '• Naar de tegenpartij — gelijk telt als bait.',
    '• Ieder het zijne — beide partijen schrijven wat ze haalden.',
  ]),
  RulesSection('Deberc', [
    'Zeven troeven op een rij in één hand zijn een deberc. De partij die hem meldt, wint in één keer het hele spel, '
        'wat de stand ook is.',
  ]),
  RulesSection('Winnen', [
    'De eerste partij die het afgesproken doel haalt, wint: 301 voor een kort spel, 501 of 1001. Halen beide het '
        'doel in hetzelfde spel, dan regelen tafels dat verschillend, en in de app kies je vooraf:',
    '• Meeste punten — de partij met de hoogste score wint; bij gelijke stand wordt doorgespeeld.',
    '• Spelende partij — de partij die in dat spel troef nam wint, ook met minder punten.',
  ]),
  RulesSection('De stand bijhouden in de app', [
    'Tik na elk spel op ‘Nieuw spel\', kies wie troef nam, tel de roem en voer de punten van één partij in; de app '
        'rekent de rest uit, ziet bait en eieren en houdt bij wie deelt.',
    'Tik op een spel in de lijst om het te verbeteren of te verwijderen, en op ↶ om het laatste ongedaan te maken.',
  ]),
];

const _ar = [
  RulesSection('اللاعبون والأوراق', [
    'يلعب لاعبان أو ثلاثة كلٌّ لنفسه؛ ويلعب أربعة في فريقين من لاعبَين، ويجلس الشريكان متقابلين. تُستخدم 32 ورقة، '
        'من السبعة إلى الإكَّة في كل نوع.',
    'يدور التوزيع حول الطاولة: بعد كل جولة يوزّع اللاعب الجالس على يسار الموزّع.',
  ]),
  RulesSection('أخذ الحكم', [
    'بعد التوزيع تُكشف ورقة واحدة. يستطيع اللاعب على يسار الموزّع أن يأخذ نوعها حكمًا أو أن يمرّر، ويدور الحق حول '
        'الطاولة. إذا مرّر الجميع، يمكن تسمية نوع آخر في دور ثانٍ؛ وإذا مرّر الجميع مرة أخرى، تُرمى الأوراق ويوزّع '
        'اللاعب التالي.',
    'تلعب بعض الطاولات «بالإلزام»: إذا مرّر الجميع، وجب على الموزّع أن يأخذ الحكم.',
    'من يأخذ الحكم عليه أن يجمع في تلك الجولة أكثر من خصومه.',
  ]),
  RulesSection('قيمة الأوراق', [
    'مجموع قيمة الأوراق 152 نقطة، والأكلة الأخيرة تضيف 10، فتساوي كل جولة 162 قبل المشاريع.',
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
    'تُعلن المتتاليات من نوع واحد في بداية الجولة؛ ولا يسجّل متتالياته إلا الطرف صاحب أعلى متتالية. ويُضاف كل ما '
        'أُعلن إلى قيمة الجولة.',
  ], tableHeader: ['المشروع', 'النقاط'], table: [
    ['سرا — ثلاث متتالية', '20'],
    ['خمسين — أربع متتالية', '50'],
    ['بيلا — الشايب والبنت من الحكم', '20'],
    ['ديبيرتس — سبع أوراق حكم متتالية', 'تفوز باللعبة'],
  ]),
  RulesSection('البايت', [
    'إذا جمع الطرف الذي أخذ الحكم أقل من أحد خصومه، تكون الجولة بايت: يأخذ الخصوم قيمة الجولة كلها ولا يأخذ آخذ '
        'الحكم شيئًا. ومع ثلاثة لاعبين تذهب الجولة إلى الخصم الذي جمع أكثر، ويتقاسمها خصمان متساويان في الصدارة.',
  ]),
  RulesSection('العقوبات', [
    'تضيف طاولات كثيرة عقوبات يُتفق عليها قبل اللعبة؛ ويتيح التطبيق اختيارها في الإعدادات ويخصمها من النتيجة بنفسه:',
    '• البايت المتكرر — يخسر الطرف 50 أو 100 نقطة إضافية عند البايت الثالث، أو عند الثالث وكل بايت بعده، أو عند كل '
        'ثالث. تُحسب البايتات على مدى اللعبة أو المتتالية فقط؛ وفي الفرق يُحسب البايت للفريق.',
    '• بلا أكلة — الطرف الذي لا يأخذ أي أكلة في الجولة يخسر 50 أو 100 نقطة.',
  ]),
  RulesSection('البيض — جولة متعادلة', [
    'إذا جمع آخذ الحكم مثل خصومه تمامًا، تكون الجولة «بيضًا». تحسم الطاولات ذلك بطرق مختلفة، ويتيح التطبيق الاختيار '
        'قبل اللعبة:',
    '• معلّقة — يسجّل الخصوم نقاطهم؛ وتنتظر نقاط آخذ الحكم الفائز بالجولة التالية.',
    '• للخصوم — يُحسب التعادل بايت.',
    '• لكلٍّ نقاطه — يسجّل كل طرف ما أخذه.',
  ]),
  RulesSection('ديبيرتس', [
    'سبع أوراق حكم متتالية في يد واحدة هي ديبيرتس. والطرف الذي يعلنها يفوز باللعبة كلها دفعة واحدة، مهما كانت '
        'النتيجة.',
  ]),
  RulesSection('الفوز', [
    'يفوز أول طرف يبلغ الهدف المتفق عليه: 301 للعبة قصيرة، أو 501، أو 1001. وإذا تجاوزه الطرفان في الجولة نفسها، '
        'تحسم الطاولات ذلك بطرق مختلفة، ويتيح التطبيق الاختيار قبل اللعبة:',
    '• الأكثر نقاطاً — يفوز الطرف صاحب النتيجة الأعلى؛ وعند التساوي يستمر اللعب.',
    '• آخذ الحكم — يفوز الطرف الذي أخذ الحكم في تلك الجولة، حتى بنقاط أقل.',
  ]),
  RulesSection('تسجيل النتيجة في التطبيق', [
    'بعد كل جولة اضغط «جولة جديدة»، واختر من أخذ الحكم، واحسب المشاريع، واكتب نقاط أحد الطرفين؛ يحسب التطبيق '
        'الباقي، ويكشف البايت والبيض، ويتابع من يوزّع.',
    'اضغط على أي جولة في السجل لتصحيحها أو حذفها، و↶ للتراجع عن الأخيرة.',
  ]),
];
