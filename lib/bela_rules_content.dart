import 'rules_content.dart';

/// The rules of Bela in [lang], English when there is none.
List<RulesSection> belaRulesContent(String lang) => switch (lang) {
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

const _fr = [
  RulesSection('Joueurs et cartes', [
    'La Bela se joue à quatre en deux équipes de deux, les partenaires assis face à face, avec 32 cartes, du sept à '
        'l\'as dans chaque couleur. La donne et le jeu tournent dans le sens inverse des aiguilles d\'une montre. '
        'On peut aussi jouer à deux, chacun pour soi.',
    'Chaque joueur reçoit huit cartes : six en main, faces visibles pour lui, et deux faces cachées, le talon, '
        'qu\'il ramasse une fois l\'atout appelé.',
  ]),
  RulesSection('L\'appel de l\'atout', [
    'En commençant à côté du donneur, chaque joueur appelle une couleur d\'atout ou passe. Si les trois premiers '
        'passent, le donneur doit appeler : il ne peut pas passer.',
  ]),
  RulesSection('Valeur des cartes', [
    'Le dernier pli ajoute 10, donc les cartes d\'une donne valent 162 points.',
  ], tableHeader: ['Carte', 'Atout', 'Autre couleur'], table: [
    ['Valet', '20', '2'],
    ['Neuf', '14', '0'],
    ['As', '11', '11'],
    ['Dix', '10', '10'],
    ['Roi', '4', '4'],
    ['Dame', '3', '3'],
    ['Huit, sept', '0', '0'],
  ]),
  RulesSection('Annonces', [
    'Les suites et les carrés s\'annoncent au premier pli. Seul le camp qui a la plus forte annonce marque ses '
        'annonces ; l\'autre camp n\'en marque aucune. La bela s\'annonce quand sa première carte est jouée.',
  ], tableHeader: ['Annonce', 'Points'], table: [
    ['Tierce — trois cartes qui se suivent', '20'],
    ['Quarte — quatre cartes qui se suivent', '50'],
    ['Quinte ou plus longue', '100'],
    ['Carré d\'as, de dix, de rois ou de dames', '100'],
    ['Carré de neuf', '150'],
    ['Carré de valets', '200'],
    ['Bela — roi et dame d\'atout', '20'],
    ['Štiglja — tous les plis', '90'],
  ]),
  RulesSection('Belot bulgare', [
    'Les huit cartes d\'une même couleur dans une seule main forment un belot, et le camp qui le tient gagne toute '
        'la partie d\'un coup.',
  ]),
  RulesSection('La chute', [
    'Le camp qui a appelé l\'atout doit marquer plus que ses adversaires, annonces comprises. Sinon, il chute : les '
        'adversaires reçoivent toute la donne, avec les annonces et la bela du camp appelant.',
  ]),
  RulesSection('L\'égalité', [
    'Quand les deux camps marquent autant, le camp qui a appelé l\'atout chute aussi. Certaines tables gardent ses '
        'points en suspens pour le gagnant de la donne suivante ou laissent plutôt chaque camp garder les siens ; '
        'l\'application vous laisse choisir.',
  ]),
  RulesSection('La victoire', [
    'Le premier camp à atteindre 1001 gagne ; une partie plus courte se joue en 501 ou 701. Quand les deux le '
        'dépassent dans la même donne, le camp qui a le plus de points gagne.',
  ]),
  RulesSection('Tenir le score dans l\'application', [
    'Après chaque donne, touchez « Nouvelle donne », choisissez qui a appelé l\'atout, comptez les annonces et '
        'saisissez les points d\'un camp ; l\'application calcule l\'autre camp et montre ce qui sera inscrit avant '
        'd\'enregistrer.',
    '« Belot » termine la partie pour le camp qui le tenait. « Chute » enregistre une donne perdue sans saisir de '
        'points.',
  ]),
];

const _bg = [
  RulesSection('Играчи и карти', [
    'Белата се играе от четирима в два отбора по двама, като партньорите седят един срещу друг, с тесте от 32 '
        'карти, от седмица до асо във всяка боя. Раздаването и играта вървят обратно на часовниковата стрелка. '
        'Могат да играят и двама, всеки за себе си.',
    'Всеки играч получава осем карти: шест в ръката и две с лицето надолу, талонът, които се вземат, след като '
        'козът е обявен.',
  ]),
  RulesSection('Обявяване на коза', [
    'Като се започне до раздаващия, всеки играч обявява боя за коз или пасува. Ако първите трима пасуват, '
        'раздаващият трябва да обяви: раздаващият не може да пасува.',
  ]),
  RulesSection('Стойност на картите', [
    'Последната взятка добавя 10, така че картите в една раздача струват 162 точки.',
  ], tableHeader: ['Карта', 'Коз', 'Друга боя'], table: [
    ['Вале', '20', '2'],
    ['Деветка', '14', '0'],
    ['Асо', '11', '11'],
    ['Десетка', '10', '10'],
    ['Поп', '4', '4'],
    ['Дама', '3', '3'],
    ['Осмица, седмица', '0', '0'],
  ]),
  RulesSection('Анонси', [
    'Поредиците и каретата се обявяват на първата взятка. Анонсите си записва само страната с най-високия анонс; '
        'другата страна не записва нито един. Белата се обявява, когато се изиграе първата ѝ карта.',
  ], tableHeader: ['Анонс', 'Точки'], table: [
    ['Терца — три поред', '20'],
    ['Кварта — четири поред', '50'],
    ['Квинта или по-дълга', '100'],
    ['Каре аса, десетки, попове или дами', '100'],
    ['Каре деветки', '150'],
    ['Каре валета', '200'],
    ['Бела — поп и дама коз', '20'],
    ['Щигля — всички взятки', '90'],
  ]),
  RulesSection('Белот', [
    'Всичките осем карти от една боя в една ръка се наричат белот и страната, която го държи, печели цялата игра '
        'наведнъж.',
  ]),
  RulesSection('Падът', [
    'Страната, обявила коза, трябва да събере повече от противниците, заедно с анонсите. Ако не събере, тя пада: '
        'противниците получават цялото раздаване, заедно с анонсите и белата на обявилите.',
  ]),
  RulesSection('Равни точки', [
    'Когато двете страни съберат еднакво, страната, обявила коза, също пада. На някои маси точките ѝ чакат '
        'победителя в следващото раздаване или всяка страна запазва своите; в приложението можете да изберете.',
  ]),
  RulesSection('Победа', [
    'Печели страната, която първа стигне 1001; по-кратката игра е до 501 или 701. Когато и двете го прехвърлят в '
        'една раздача, печели страната с повече точки.',
  ]),
  RulesSection('Как се води резултатът в приложението', [
    'След всяка раздача натиснете „Нова раздача", изберете кой е обявил коза, пребройте анонсите и въведете точките '
        'на едната страна; приложението изчислява другата страна и показва какво ще се запише, преди да запазите.',
    '„Белот" завършва играта в полза на страната, която го е държала. „Пад" записва загубено раздаване без '
        'въвеждане на точки.',
  ]),
];

const _nl = [
  RulesSection('Spelers en kaarten', [
    'Bela wordt met vier gespeeld in twee teams van twee, met de partners tegenover elkaar, met 32 kaarten, zeven '
        'tot en met aas in elke kleur. Het delen en spelen gaat tegen de klok in. Met twee kan ook, ieder voor zich.',
    'Elke speler krijgt acht kaarten: zes in de hand en twee gedekt, de talon, die hij oppakt zodra de troef '
        'gemaakt is.',
  ]),
  RulesSection('Troef maken', [
    'Te beginnen naast de gever maakt elke speler een troefkleur of past. Als de eerste drie passen, moet de gever '
        'troef maken: de gever kan niet passen.',
  ]),
  RulesSection('Waarde van de kaarten', [
    'De laatste slag geeft er 10 bij, dus de kaarten van een spel zijn 162 punten waard.',
  ], tableHeader: ['Kaart', 'Troef', 'Andere kleur'], table: [
    ['Boer', '20', '2'],
    ['Negen', '14', '0'],
    ['Aas', '11', '11'],
    ['Tien', '10', '10'],
    ['Heer', '4', '4'],
    ['Vrouw', '3', '3'],
    ['Acht, zeven', '0', '0'],
  ]),
  RulesSection('Roem', [
    'Reeksen en vier gelijke worden bij de eerste slag gemeld. Alleen de partij met de hoogste roem schrijft haar '
        'roem; de andere partij schrijft niets. De bela wordt gemeld als haar eerste kaart gespeeld wordt.',
  ], tableHeader: ['Roem', 'Punten'], table: [
    ['Drie op een rij', '20'],
    ['Vier op een rij', '50'],
    ['Vijf op een rij of langer', '100'],
    ['Vier azen, tienen, heren of vrouwen', '100'],
    ['Vier negens', '150'],
    ['Vier boeren', '200'],
    ['Bela — heer en vrouw van troef', '20'],
    ['Štiglja — alle slagen', '90'],
  ]),
  RulesSection('Bulgaarse belot', [
    'Alle acht kaarten van één kleur in één hand heten een belot, en de partij die hem heeft wint in één keer de '
        'hele partij.',
  ]),
  RulesSection('De val', [
    'De partij die troef maakte, moet meer halen dan de tegenpartij, roem inbegrepen. Lukt dat niet, dan valt ze: '
        'de tegenpartij krijgt het hele spel, ook de roem en de bela van de partij die troef maakte.',
  ]),
  RulesSection('Gelijke punten', [
    'Als beide partijen evenveel halen, valt de partij die troef maakte ook. Aan sommige tafels blijven haar punten '
        'bewaard voor de winnaar van het volgende spel, of houdt elke partij juist de hare; in de app kun je kiezen.',
  ]),
  RulesSection('Winnen', [
    'De eerste partij die 1001 haalt, wint; een kortere partij gaat tot 501 of 701. Halen beide het in hetzelfde '
        'spel, dan wint de partij met de meeste punten.',
  ]),
  RulesSection('De stand bijhouden in de app', [
    'Tik na elk spel op ‘Nieuw spel\', kies wie troef maakte, tel de roem en voer de punten van één partij in; de '
        'app rekent de andere partij uit en laat zien wat er geschreven wordt voordat je opslaat.',
    '‘Belot\' beëindigt de partij voor de partij die hem had. ‘Val\' registreert een verloren spel zonder punten in '
        'te voeren.',
  ]),
];

const _ar = [
  RulesSection('اللاعبون والأوراق', [
    'تُلعب بيلا بأربعة لاعبين في فريقين من لاعبَين، ويجلس الشريكان متقابلين، بـ32 ورقة، من السبعة إلى الإكَّة في كل '
        'نوع. ويدور التوزيع واللعب عكس عقارب الساعة. ويمكن أن يلعب اثنان أيضًا، كلٌّ لنفسه.',
    'يأخذ كل لاعب ثماني أوراق: ستًّا في يده واثنتين مقلوبتين، هما التالون، يلتقطهما بعد إعلان الحكم.',
  ]),
  RulesSection('إعلان الحكم', [
    'بدءًا من الجالس بجانب الموزّع، يعلن كل لاعب نوعًا للحكم أو يمرّر. وإذا مرّر الثلاثة الأوائل، وجب على الموزّع '
        'أن يعلن: لا يستطيع الموزّع أن يمرّر.',
  ]),
  RulesSection('قيمة الأوراق', [
    'الأكلة الأخيرة تضيف 10، فتساوي أوراق الجولة 162 نقطة.',
  ], tableHeader: ['الورقة', 'الحكم', 'نوع آخر'], table: [
    ['الولد', '20', '2'],
    ['التسعة', '14', '0'],
    ['الإكَّة', '11', '11'],
    ['العشرة', '10', '10'],
    ['الشايب', '4', '4'],
    ['البنت', '3', '3'],
    ['الثمانية، السبعة', '0', '0'],
  ]),
  RulesSection('المشاريع', [
    'تُعلن المتتاليات والأربع المتشابهة في الأكلة الأولى. ولا يسجّل مشاريعه إلا الطرف صاحب أعلى مشروع؛ ولا يسجّل '
        'الطرف الآخر شيئًا. وتُعلن البيلا حين تُلعب أولى ورقتيها.',
  ], tableHeader: ['المشروع', 'النقاط'], table: [
    ['سرا — ثلاث متتالية', '20'],
    ['كوارت — أربع متتالية', '50'],
    ['كوينت أو أطول', '100'],
    ['أربع إكَك أو عشرات أو شياب أو بنات', '100'],
    ['أربع تسعات', '150'],
    ['أربعة أولاد', '200'],
    ['بيلا — الشايب والبنت من الحكم', '20'],
    ['شتيليا — كل الأكلات', '90'],
  ]),
  RulesSection('البيلوت البلغاري', [
    'الأوراق الثماني كلها من نوع واحد في يد واحدة تُسمّى بيلوت، والطرف الذي يملكها يفوز باللعبة كلها دفعة واحدة.',
  ]),
  RulesSection('السقوط', [
    'على الطرف الذي أعلن الحكم أن يجمع أكثر من خصومه، مع المشاريع. وإن لم يفعل، يسقط: يأخذ الخصوم الجولة كلها، '
        'ومعها مشاريع الطرف المعلن وبيلته.',
  ]),
  RulesSection('التعادل', [
    'إذا جمع الطرفان القدر نفسه، يسقط الطرف الذي أعلن الحكم أيضًا. وتحفظ بعض الطاولات نقاطه للفائز بالجولة التالية '
        'أو تترك لكل طرف نقاطه؛ ويتيح لكم التطبيق الاختيار.',
  ]),
  RulesSection('الفوز', [
    'يفوز أول طرف يبلغ 1001؛ وتُلعب اللعبة الأقصر حتى 501 أو 701. وإذا تجاوزه الطرفان في الجولة نفسها، يفوز الطرف '
        'صاحب النقاط الأكثر.',
  ]),
  RulesSection('تسجيل النتيجة في التطبيق', [
    'بعد كل جولة اضغط «جولة جديدة»، واختر من أعلن الحكم، واحسب المشاريع، وأدخل نقاط أحد الطرفين؛ يحسب التطبيق الطرف '
        'الآخر ويعرض ما سيُسجَّل قبل الحفظ.',
    '«بيلوت» تُنهي اللعبة لصالح الطرف الذي امتلكه. و«سقوط» تسجّل جولة خاسرة دون إدخال نقاط.',
  ]),
];
