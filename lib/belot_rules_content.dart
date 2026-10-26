import 'rules_content.dart';

/// The rules of Bulgarian Belot in [lang], English when there is none.
List<RulesSection> belotRulesContent(String lang) => switch (lang) {
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
    'Belot is played by four in two teams of two, partners sitting opposite each other, with a 32-card deck, '
        'seven to ace in each suit. The deal and the play go counter-clockwise.',
    'The dealer gives each player five cards, three and then two. After the bidding everybody gets three more, '
        'so each holds eight.',
  ]),
  RulesSection('Bidding', [
    'Starting next to the dealer, each player may pass or bid higher than the bid before: clubs, diamonds, '
        'hearts, spades, no trumps, all trumps. An opponent of the last bidder may say contra, which doubles the '
        'deal, and the bidding side may answer re-contra, which doubles it again.',
    'The bidding ends after three passes in a row. If all four pass, the cards are thrown in and the next player '
        'deals.',
  ]),
  RulesSection('Card values', [
    'The last trick adds 10. A suit deal is worth 162 points, a no-trumps deal 130 and an all-trumps deal 258.',
  ], tableHeader: ['Card', 'Trump', 'No trumps'], table: [
    ['Jack', '20', '2'],
    ['Nine', '14', '0'],
    ['Ace', '11', '11'],
    ['Ten', '10', '10'],
    ['King', '4', '4'],
    ['Queen', '3', '3'],
    ['Eight, seven', '0', '0'],
  ]),
  RulesSection('Declarations', [
    'Combinations are declared on the first trick and added to the side\'s points. Nothing is declared in a '
        'no-trumps deal. In an all-trumps deal a belot can be declared in every suit.',
  ], tableHeader: ['Declaration', 'Points'], table: [
    ['Tierce — three in a row', '20'],
    ['Quarte — four in a row', '50'],
    ['Quinte — five in a row', '100'],
    ['Four aces, tens, kings or queens', '100'],
    ['Four nines', '150'],
    ['Four jacks', '200'],
    ['Belot — king and queen of trumps', '20'],
    ['Valat — every trick', '90'],
  ]),
  RulesSection('Game points', [
    'Card points are turned into game points by dropping the last digit: a suit deal is worth 16, a no-trumps or '
        'all-trumps deal 26. A no-trumps deal is counted twice before it is rounded.',
    'The side with fewer points rounds up from 6 in a suit, from 5 in no trumps and from 4 in all trumps; the side '
        'with more rounds up from 7, 5 and 5. So 87 to 75 in a suit gives 9 and 7.',
  ]),
  RulesSection('Inside', [
    'If the side that won the bidding scores less than its opponents, it is inside: the opponents get the whole '
        'deal.',
  ]),
  RulesSection('Hanging points', [
    'If both sides score the same, the opponents write down their points and the bidding side\'s points hang: '
        'they go to whoever wins the next deal.',
  ]),
  RulesSection('Contra and re-contra', [
    'A doubled deal is worth twice as much, a redoubled one four times. The side with more points takes the whole '
        'deal; with equal points the whole deal hangs.',
  ]),
  RulesSection('Winning', [
    'The first side to reach 151 wins. When both pass it in the same deal, the side with more points wins; on an '
        'equal score play goes on. A valat cannot end the game: the next deal decides.',
  ]),
  RulesSection('Keeping the score in the app', [
    'After each deal tap "New round", choose who won the bidding, the contract and any contra, and enter the '
        'points of one side with the declarations counted in; the app works out the other side and the game '
        'points, and shows what will be written down before you save.',
    '"Everyone passed" records a redeal and hands the deal on. "Inside" records a lost deal without entering '
        'points.',
  ]),
];

const _bg = [
  RulesSection('Играчи и карти', [
    'Белот играят четирима в два отбора по двама, партньорите седят един срещу друг, с колода от 32 карти, от '
        'седмица до асо във всяка боя. Раздаването и играта вървят обратно на часовниковата стрелка.',
    'Раздаващият дава на всеки по пет карти, три и после две. След обявяването всеки получава още три, така че '
        'всеки има по осем.',
  ]),
  RulesSection('Обявяване', [
    'Започвайки до раздаващия, всеки играч може да каже пас или по-висока обява от предишната: спатия, каро, '
        'купа, пика, без коз, всичко коз. Противник на последния обявил може да каже контра, която удвоява '
        'раздаването, а обявилите могат да отговорят с реконтра, която го удвоява още веднъж.',
    'Обявяването свършва след три поредни паса. Ако и четиримата пасуват, картите се хвърлят и раздава следващият.',
  ]),
  RulesSection('Стойност на картите', [
    'Последната ръка носи 10. Раздаване в боя струва 162 точки, без коз — 130, всичко коз — 258.',
  ], tableHeader: ['Карта', 'Коз', 'Без коз'], table: [
    ['Вале', '20', '2'],
    ['Деветка', '14', '0'],
    ['Асо', '11', '11'],
    ['Десетка', '10', '10'],
    ['Поп', '4', '4'],
    ['Дама', '3', '3'],
    ['Осмица, седмица', '0', '0'],
  ]),
  RulesSection('Анонси', [
    'Комбинациите се обявяват на първата ръка и се добавят към точките на страната. При без коз не се обявява '
        'нищо. При всичко коз белот може да има във всяка боя.',
  ], tableHeader: ['Анонс', 'Точки'], table: [
    ['Терца — три поред', '20'],
    ['Кварта — четири поред', '50'],
    ['Квинта — пет поред', '100'],
    ['Каре аса, десетки, попове или дами', '100'],
    ['Каре деветки', '150'],
    ['Каре валета', '200'],
    ['Белот — поп и дама коз', '20'],
    ['Валат — всички ръце', '90'],
  ]),
  RulesSection('Игрови точки', [
    'Точките от картите стават игрови, като се махне последната цифра: раздаване в боя струва 16, без коз или '
        'всичко коз — 26. При без коз точките се удвояват преди закръглянето.',
    'Страната с по-малко точки закръгля нагоре от 6 в боя, от 5 при без коз и от 4 при всичко коз; страната с '
        'повече — от 7, 5 и 5. Така 87 на 75 в боя дава 9 и 7.',
  ]),
  RulesSection('Вътре', [
    'Ако обявилата страна събере по-малко точки от противниците, тя е вътре: противниците получават цялото '
        'раздаване.',
  ]),
  RulesSection('Висящи точки', [
    'Ако двете страни съберат еднакво, противниците записват своите точки, а точките на обявилите висят: '
        'отиват при победителя в следващото раздаване.',
  ]),
  RulesSection('Контра и реконтра', [
    'Раздаване с контра струва двойно, с реконтра — четворно. Страната с повече точки взема цялото раздаване; '
        'при равни точки виси цялото раздаване.',
  ]),
  RulesSection('Победа', [
    'Печели страната, която първа стигне 151. Ако и двете го минат в едно раздаване, печели тази с повече точки; '
        'при равен резултат играта продължава. Валат не може да спечели играта: решава следващото раздаване.',
  ]),
  RulesSection('Как се води резултатът в приложението', [
    'След всяко раздаване натисни „Нова раздача“, избери кой е обявил, договора и контрата, ако има, и въведи '
        'точките на едната страна заедно с анонсите; приложението смята другата страна и игровите точки и '
        'показва какво ще се запише, преди да запазиш.',
    '„Всички пас“ записва нова раздача и предава раздаването нататък. „Вътре“ записва загубено раздаване без '
        'въвеждане на точки.',
  ]),
];

const _uk = [
  RulesSection('Гравці й карти', [
    'У белот грають четверо, двома командами по двоє, партнери сидять один навпроти одного, колодою з 32 карт, '
        'від сімки до туза в кожній масті. Роздача й гра йдуть проти годинникової стрілки.',
    'Роздавач дає кожному по п\'ять карт, три й потім дві. Після торгу кожен отримує ще три, тож у кожного по вісім.',
  ]),
  RulesSection('Торг', [
    'Починаючи з сусіда роздавача, кожен може спасувати або назвати вищий контракт, ніж попередній: трефи, бубни, '
        'чирви, піки, без козиря, всі козирі. Суперник останнього, хто назвав контракт, може сказати контра — це '
        'подвоює роздачу, а та сторона може відповісти реконтрою, яка подвоює її ще раз.',
    'Торг закінчується після трьох пасів поспіль. Якщо пасують усі четверо, карти скидають і роздає наступний.',
  ]),
  RulesSection('Вартість карт', [
    'Остання взятка дає 10. Роздача в масті коштує 162 очки, без козиря — 130, всі козирі — 258.',
  ], tableHeader: ['Карта', 'Козир', 'Без козиря'], table: [
    ['Валет', '20', '2'],
    ['Дев\'ятка', '14', '0'],
    ['Туз', '11', '11'],
    ['Десятка', '10', '10'],
    ['Король', '4', '4'],
    ['Дама', '3', '3'],
    ['Вісімка, сімка', '0', '0'],
  ]),
  RulesSection('Комбінації', [
    'Комбінації оголошують на першій взятці й додають до очок сторони. Без козиря нічого не оголошують. Коли всі '
        'козирі, белот може бути в кожній масті.',
  ], tableHeader: ['Комбінація', 'Очки'], table: [
    ['Терц — три підряд', '20'],
    ['Кварта — чотири підряд', '50'],
    ['Квінта — п\'ять підряд', '100'],
    ['Чотири тузи, десятки, королі чи дами', '100'],
    ['Чотири дев\'ятки', '150'],
    ['Чотири валети', '200'],
    ['Белот — король і дама козирів', '20'],
    ['Валат — усі взятки', '90'],
  ]),
  RulesSection('Ігрові очки', [
    'Очки за карти стають ігровими, якщо відкинути останню цифру: роздача в масті коштує 16, без козиря чи всі '
        'козирі — 26. Без козиря очки подвоюють перед округленням.',
    'Сторона з меншими очками округлює вгору від 6 у масті, від 5 без козиря і від 4, коли всі козирі; сторона з '
        'більшими — від 7, 5 і 5. Тож 87 на 75 у масті дає 9 і 7.',
  ]),
  RulesSection('Вътре — програна роздача', [
    'Якщо сторона, що виграла торг, набрала менше за суперників, вона «вътре»: суперники отримують усю роздачу.',
  ]),
  RulesSection('Висячі очки', [
    'Якщо обидві сторони набрали порівну, суперники записують свої очки, а очки тих, хто грав, висять: їх '
        'отримує переможець наступної роздачі.',
  ]),
  RulesSection('Контра й реконтра', [
    'Роздача з контрою коштує вдвічі більше, з реконтрою — вчетверо. Сторона з більшими очками забирає всю '
        'роздачу; за рівних очок уся роздача висить.',
  ]),
  RulesSection('Перемога', [
    'Перемагає сторона, що першою набере 151. Якщо обидві перейшли цю межу в одній роздачі, перемагає та, у якої '
        'більше; за рівного рахунку гра триває. Валат не може завершити гру: вирішує наступна роздача.',
  ]),
  RulesSection('Як вести рахунок у застосунку', [
    'Після кожної роздачі натисни «Нова роздача», обери, хто виграв торг, контракт і контру, якщо була, та введи '
        'очки однієї сторони разом із комбінаціями; застосунок порахує другу сторону й ігрові очки та покаже, що '
        'буде записано, ще до збереження.',
    '«Усі пасували» записує перездачу й передає роздачу далі. «Вътре» записує програну роздачу без введення очок.',
  ]),
];

const _fr = [
  RulesSection('Joueurs et cartes', [
    'Le Belot se joue à quatre en deux équipes de deux, les partenaires assis face à face, avec 32 cartes, du sept '
        'à l\'as dans chaque couleur. La donne et le jeu tournent dans le sens inverse des aiguilles d\'une montre.',
    'Le donneur distribue cinq cartes à chaque joueur, trois puis deux. Après les enchères, chacun en reçoit trois '
        'de plus, et tient donc huit cartes.',
  ]),
  RulesSection('Les enchères', [
    'En commençant à côté du donneur, chaque joueur peut passer ou annoncer plus haut que l\'enchère précédente : '
        'trèfle, carreau, cœur, pique, sans atout, tout atout. Un adversaire du dernier enchérisseur peut dire '
        'contre, ce qui double la donne, et le camp enchérisseur peut répondre surcontre, ce qui la double encore.',
    'Les enchères s\'arrêtent après trois passes de suite. Si les quatre passent, les cartes sont jetées et le '
        'joueur suivant donne.',
  ]),
  RulesSection('Valeur des cartes', [
    'Le dernier pli ajoute 10. Une donne à la couleur vaut 162 points, une donne sans atout 130 et une donne tout '
        'atout 258.',
  ], tableHeader: ['Carte', 'Atout', 'Sans atout'], table: [
    ['Valet', '20', '2'],
    ['Neuf', '14', '0'],
    ['As', '11', '11'],
    ['Dix', '10', '10'],
    ['Roi', '4', '4'],
    ['Dame', '3', '3'],
    ['Huit, sept', '0', '0'],
  ]),
  RulesSection('Annonces', [
    'Les combinaisons s\'annoncent au premier pli et s\'ajoutent aux points du camp. Rien ne s\'annonce dans une '
        'donne sans atout. Dans une donne tout atout, une belote peut s\'annoncer dans chaque couleur.',
  ], tableHeader: ['Annonce', 'Points'], table: [
    ['Tierce — trois cartes qui se suivent', '20'],
    ['Quarte — quatre cartes qui se suivent', '50'],
    ['Quinte — cinq cartes qui se suivent', '100'],
    ['Carré d\'as, de dix, de rois ou de dames', '100'],
    ['Carré de neuf', '150'],
    ['Carré de valets', '200'],
    ['Belote — roi et dame d\'atout', '20'],
    ['Capot — tous les plis', '90'],
  ]),
  RulesSection('Points de partie', [
    'Les points des cartes deviennent des points de partie en supprimant le dernier chiffre : une donne à la '
        'couleur vaut 16, une donne sans atout ou tout atout 26. Une donne sans atout est comptée double avant '
        'l\'arrondi.',
    'Le camp qui a le moins de points arrondit vers le haut à partir de 6 à la couleur, de 5 à sans atout et de 4 à '
        'tout atout ; le camp qui en a le plus, à partir de 7, 5 et 5. Ainsi, 87 contre 75 à la couleur donne 9 et '
        '7.',
  ]),
  RulesSection('Dedans', [
    'Si le camp qui a remporté les enchères marque moins que ses adversaires, il est dedans : les adversaires '
        'reçoivent toute la donne.',
  ]),
  RulesSection('Litige', [
    'Si les deux camps marquent autant, les adversaires inscrivent leurs points et ceux du camp enchérisseur '
        'restent en litige : ils vont au gagnant de la donne suivante.',
  ]),
  RulesSection('Contre et surcontre', [
    'Une donne contrée vaut le double, une donne surcontrée le quadruple. Le camp qui a le plus de points prend '
        'toute la donne ; à égalité, toute la donne reste en litige.',
  ]),
  RulesSection('La victoire', [
    'Le premier camp à atteindre 151 gagne. Quand les deux le dépassent dans la même donne, le camp qui a le plus '
        'de points gagne ; à égalité, la partie continue. Un capot ne peut pas terminer la partie : c\'est la donne '
        'suivante qui décide.',
  ]),
  RulesSection('Tenir le score dans l\'application', [
    'Après chaque donne, touchez « Nouvelle donne », choisissez qui a remporté les enchères, le contrat et '
        'l\'éventuel contre, et saisissez les points d\'un camp, annonces comprises ; l\'application calcule '
        'l\'autre camp et les points de partie, et montre ce qui sera inscrit avant d\'enregistrer.',
    '« Tout le monde passe » enregistre une redonne et passe la donne au suivant. « Dedans » enregistre une donne '
        'perdue sans saisir de points.',
  ]),
];

const _hr = [
  RulesSection('Igrači i karte', [
    'Belot igraju četvorica u dva para, a partneri sjede jedan nasuprot drugome, sa špilom od 32 karte, od sedmice '
        'do asa u svakoj boji. Dijeljenje i igra idu suprotno od kazaljke na satu.',
    'Djelitelj svakom igraču daje pet karata, tri pa dvije. Nakon licitacije svatko dobiva još tri, pa svatko drži '
        'osam.',
  ]),
  RulesSection('Licitacija', [
    'Počevši do djelitelja, svaki igrač može reći dalje ili licitirati više od prethodne licitacije: tref, karo, '
        'herc, pik, bez aduta, sve adut. Protivnik posljednjeg licitanta može reći kontra, što udvostručuje '
        'dijeljenje, a strana koja je licitirala može odgovoriti rekontra, što ga ponovno udvostručuje.',
    'Licitacija završava nakon tri uzastopna „dalje". Ako sva četvorica kažu dalje, karte se bacaju i dijeli '
        'sljedeći igrač.',
  ]),
  RulesSection('Vrijednost karata', [
    'Zadnji štih dodaje 10. Dijeljenje u boji vrijedi 162 boda, bez aduta 130, a sve adut 258.',
  ], tableHeader: ['Karta', 'Adut', 'Bez aduta'], table: [
    ['Dečko', '20', '2'],
    ['Devetka', '14', '0'],
    ['As', '11', '11'],
    ['Desetka', '10', '10'],
    ['Kralj', '4', '4'],
    ['Baba', '3', '3'],
    ['Osmica, sedmica', '0', '0'],
  ]),
  RulesSection('Zvanja', [
    'Kombinacije se zovu na prvom štihu i dodaju bodovima strane. U dijeljenju bez aduta ne zove se ništa. U '
        'dijeljenju sve adut belot se može zvati u svakoj boji.',
  ], tableHeader: ['Zvanje', 'Bodovi'], table: [
    ['Terca — tri zaredom', '20'],
    ['Kvarta — četiri zaredom', '50'],
    ['Kvinta — pet u nizu', '100'],
    ['Četiri asa, desetke, kralja ili babe', '100'],
    ['Četiri devetke', '150'],
    ['Četiri dečka', '200'],
    ['Belot — kralj i dama aduta', '20'],
    ['Valat — svi štihovi', '90'],
  ]),
  RulesSection('Bodovi igre', [
    'Bodovi karata pretvaraju se u bodove igre tako da se izbriše zadnja znamenka: dijeljenje u boji vrijedi 16, '
        'bez aduta ili sve adut 26. Dijeljenje bez aduta broji se dvostruko prije zaokruživanja.',
    'Strana s manje bodova zaokružuje prema gore od 6 u boji, od 5 bez aduta i od 4 u sve adut; strana s više '
        'bodova od 7, 5 i 5. Tako 87 prema 75 u boji daje 9 i 7.',
  ]),
  RulesSection('Unutra', [
    'Ako strana koja je dobila licitaciju skupi manje od protivnika, ona je unutra: protivnici dobivaju cijelo '
        'dijeljenje.',
  ]),
  RulesSection('Viseći bodovi', [
    'Ako obje strane skupe jednako, protivnici upisuju svoje bodove, a bodovi strane koja je licitirala vise: idu '
        'pobjedniku sljedećeg dijeljenja.',
  ]),
  RulesSection('Kontra i rekontra', [
    'Dijeljenje s kontrom vrijedi dvostruko, s rekontrom četverostruko. Strana s više bodova uzima cijelo '
        'dijeljenje; kod jednakih bodova visi cijelo dijeljenje.',
  ]),
  RulesSection('Pobjeda', [
    'Pobjeđuje strana koja prva dosegne 151. Kad ga obje prijeđu u istom dijeljenju, pobjeđuje strana s više '
        'bodova; kod jednakog rezultata igra se dalje. Valat ne može završiti igru: odlučuje sljedeće dijeljenje.',
  ]),
  RulesSection('Vođenje rezultata u aplikaciji', [
    'Nakon svakog dijeljenja dodirnite „Novo dijeljenje", odaberite tko je dobio licitaciju, ugovor i eventualnu '
        'kontru te upišite bodove jedne strane sa zvanjima; aplikacija izračuna drugu stranu i bodove igre i prije '
        'spremanja pokazuje što će se upisati.',
    '„Svi su rekli dalje" bilježi ponovno dijeljenje i predaje dijeljenje dalje. „Unutra" bilježi izgubljeno '
        'dijeljenje bez upisivanja bodova.',
  ]),
];

const _nl = [
  RulesSection('Spelers en kaarten', [
    'Belot wordt met vier gespeeld in twee teams van twee, met de partners tegenover elkaar, met 32 kaarten, zeven '
        'tot en met aas in elke kleur. Het delen en spelen gaat tegen de klok in.',
    'De gever geeft elke speler vijf kaarten, eerst drie en dan twee. Na het bieden krijgt iedereen er nog drie, '
        'zodat ieder er acht heeft.',
  ]),
  RulesSection('Bieden', [
    'Te beginnen naast de gever mag elke speler passen of hoger bieden dan het vorige bod: klaveren, ruiten, '
        'harten, schoppen, zonder troef, alles troef. Een tegenstander van de laatste bieder mag kontra zeggen, wat '
        'het spel verdubbelt, en de biedende partij mag antwoorden met rekontra, wat het nog eens verdubbelt.',
    'Het bieden eindigt na drie keer passen achter elkaar. Als alle vier passen, worden de kaarten ingegooid en '
        'deelt de volgende speler.',
  ]),
  RulesSection('Waarde van de kaarten', [
    'De laatste slag geeft er 10 bij. Een spel in een kleur is 162 punten waard, zonder troef 130 en alles troef '
        '258.',
  ], tableHeader: ['Kaart', 'Troef', 'Zonder troef'], table: [
    ['Boer', '20', '2'],
    ['Negen', '14', '0'],
    ['Aas', '11', '11'],
    ['Tien', '10', '10'],
    ['Heer', '4', '4'],
    ['Vrouw', '3', '3'],
    ['Acht, zeven', '0', '0'],
  ]),
  RulesSection('Roem', [
    'Combinaties worden bij de eerste slag gemeld en bij de punten van de partij opgeteld. In een spel zonder troef '
        'wordt niets gemeld. In een spel alles troef kan in elke kleur een belot gemeld worden.',
  ], tableHeader: ['Roem', 'Punten'], table: [
    ['Drie op een rij', '20'],
    ['Vier op een rij', '50'],
    ['Vijf op een rij', '100'],
    ['Vier azen, tienen, heren of vrouwen', '100'],
    ['Vier negens', '150'],
    ['Vier boeren', '200'],
    ['Belot — heer en vrouw van troef', '20'],
    ['Valat — alle slagen', '90'],
  ]),
  RulesSection('Spelpunten', [
    'Kaartpunten worden spelpunten door het laatste cijfer weg te laten: een spel in een kleur is 16 waard, zonder '
        'troef of alles troef 26. Een spel zonder troef wordt vóór het afronden dubbel geteld.',
    'De partij met minder punten rondt naar boven af vanaf 6 in een kleur, vanaf 5 zonder troef en vanaf 4 bij '
        'alles troef; de partij met meer vanaf 7, 5 en 5. Zo geeft 87 tegen 75 in een kleur 9 en 7.',
  ]),
  RulesSection('Binnen', [
    'Als de partij die het bieden won minder haalt dan de tegenpartij, is ze binnen: de tegenpartij krijgt het hele '
        'spel.',
  ]),
  RulesSection('Hangende punten', [
    'Als beide partijen evenveel halen, schrijft de tegenpartij haar punten en blijven de punten van de biedende '
        'partij hangen: ze gaan naar wie het volgende spel wint.',
  ]),
  RulesSection('Kontra en rekontra', [
    'Een spel met kontra is dubbel zoveel waard, met rekontra vier keer zoveel. De partij met de meeste punten '
        'krijgt het hele spel; bij gelijke punten blijft het hele spel hangen.',
  ]),
  RulesSection('Winnen', [
    'De eerste partij die 151 haalt, wint. Halen beide het in hetzelfde spel, dan wint de partij met de meeste '
        'punten; bij gelijke stand wordt doorgespeeld. Een valat kan het spel niet beëindigen: het volgende spel '
        'beslist.',
  ]),
  RulesSection('De stand bijhouden in de app', [
    'Tik na elk spel op ‘Nieuw spel\', kies wie het bieden won, het contract en een eventuele kontra, en voer de '
        'punten van één partij in, roem inbegrepen; de app rekent de andere partij en de spelpunten uit en laat '
        'zien wat er geschreven wordt voordat je opslaat.',
    '‘Iedereen past\' registreert opnieuw geven en geeft het delen door. ‘Binnen\' registreert een verloren spel '
        'zonder punten in te voeren.',
  ]),
];

const _ar = [
  RulesSection('اللاعبون والأوراق', [
    'يُلعب البيلوت بأربعة لاعبين في فريقين من لاعبَين، ويجلس الشريكان متقابلين، بـ32 ورقة، من السبعة إلى الإكَّة في '
        'كل نوع. ويدور التوزيع واللعب عكس عقارب الساعة.',
    'يعطي الموزّع كل لاعب خمس أوراق، ثلاثًا ثم اثنتين. وبعد المزايدة يأخذ كل لاعب ثلاثًا أخرى، فيكون مع كل لاعب '
        'ثماني أوراق.',
  ]),
  RulesSection('المزايدة', [
    'بدءًا من الجالس بجانب الموزّع، يستطيع كل لاعب أن يمرّر أو يزايد أعلى من المزايدة السابقة: سباتي، ديناري، كبّة، '
        'بستوني، بلا حكم، كل حكم. ويستطيع خصم آخر مزايد أن يقول كونترا، فتتضاعف الجولة، ويستطيع الطرف المزايد أن '
        'يردّ بري-كونترا، فتتضاعف مرة أخرى.',
    'تنتهي المزايدة بعد ثلاث تمريرات متتالية. وإذا مرّر الأربعة، تُرمى الأوراق ويوزّع اللاعب التالي.',
  ]),
  RulesSection('قيمة الأوراق', [
    'الأكلة الأخيرة تضيف 10. جولة النوع تساوي 162 نقطة، وجولة بلا حكم 130، وجولة كل حكم 258.',
  ], tableHeader: ['الورقة', 'الحكم', 'بلا حكم'], table: [
    ['الولد', '20', '2'],
    ['التسعة', '14', '0'],
    ['الإكَّة', '11', '11'],
    ['العشرة', '10', '10'],
    ['الشايب', '4', '4'],
    ['البنت', '3', '3'],
    ['الثمانية، السبعة', '0', '0'],
  ]),
  RulesSection('المشاريع', [
    'تُعلن التشكيلات في الأكلة الأولى وتُضاف إلى نقاط الطرف. ولا يُعلن شيء في جولة بلا حكم. وفي جولة كل حكم يمكن '
        'إعلان بيلوت في كل نوع.',
  ], tableHeader: ['المشروع', 'النقاط'], table: [
    ['سرا — ثلاث متتالية', '20'],
    ['كوارت — أربع متتالية', '50'],
    ['كوينت — خمس متتالية', '100'],
    ['أربع إكَك أو عشرات أو شياب أو بنات', '100'],
    ['أربع تسعات', '150'],
    ['أربعة أولاد', '200'],
    ['بيلوت — الشايب والبنت من الحكم', '20'],
    ['كبوت — كل الأكلات', '90'],
  ]),
  RulesSection('نقاط اللعبة', [
    'تتحوّل نقاط الأوراق إلى نقاط لعبة بحذف الرقم الأخير: جولة النوع تساوي 16، وجولة بلا حكم أو كل حكم 26. وتُحسب '
        'جولة بلا حكم مضاعفة قبل التقريب.',
    'الطرف صاحب النقاط الأقل يقرّب إلى الأعلى ابتداءً من 6 في النوع، ومن 5 في بلا حكم، ومن 4 في كل حكم؛ والطرف صاحب '
        'النقاط الأكثر ابتداءً من 7 و5 و5. فتعطي 87 مقابل 75 في النوع 9 و7.',
  ]),
  RulesSection('داخل', [
    'إذا جمع الطرف الفائز بالمزايدة أقل من خصومه، يكون داخل: يأخذ الخصوم الجولة كلها.',
  ]),
  RulesSection('النقاط المعلّقة', [
    'إذا جمع الطرفان القدر نفسه، يسجّل الخصوم نقاطهم وتبقى نقاط الطرف المزايد معلّقة: تذهب إلى الفائز بالجولة '
        'التالية.',
  ]),
  RulesSection('الكونترا والري-كونترا', [
    'الجولة مع الكونترا تساوي الضعف، ومع الري-كونترا أربعة أضعاف. ويأخذ الطرف صاحب النقاط الأكثر الجولة كلها؛ وعند '
        'تساوي النقاط تبقى الجولة كلها معلّقة.',
  ]),
  RulesSection('الفوز', [
    'يفوز أول طرف يبلغ 151. وإذا تجاوزه الطرفان في الجولة نفسها، يفوز الطرف صاحب النقاط الأكثر؛ وعند التساوي يستمر '
        'اللعب. ولا يمكن للكبوت أن ينهي اللعبة: الجولة التالية هي التي تحسم.',
  ]),
  RulesSection('تسجيل النتيجة في التطبيق', [
    'بعد كل جولة اضغط «جولة جديدة»، واختر من فاز بالمزايدة، والعقد، والكونترا إن وُجدت، وأدخل نقاط أحد الطرفين مع '
        'المشاريع؛ يحسب التطبيق الطرف الآخر ونقاط اللعبة، ويعرض ما سيُسجَّل قبل الحفظ.',
    '«مرّر الجميع» تسجّل إعادة توزيع وتنقل التوزيع إلى التالي. و«داخل» تسجّل جولة خاسرة دون إدخال نقاط.',
  ]),
];
