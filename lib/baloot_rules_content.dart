import 'rules_content.dart';

/// The rules of Baloot in [lang], English when there is none.
List<RulesSection> balootRulesContent(String lang) => switch (lang) {
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
    'Baloot is played by four in two teams of two, partners sitting opposite each other, with a 32-card deck, '
        'seven to ace in each suit. Play goes counter-clockwise.',
    'Each player first gets five cards and one card is turned face up. The player who buys it takes that card '
        'and the others get the rest of their eight cards.',
  ]),
  RulesSection('Hokm and Sun', [
    'Each player in turn may buy the turned-up card as Hokm, a deal with trumps, or as Sun, a deal without '
        'trumps; Sun outranks Hokm. In Hokm the suit of the card is trump, or, in a second round, another suit '
        'the buyer names.',
    'A Hokm deal is worth 16 game points and a Sun deal 26, before projects.',
  ]),
  RulesSection('Card values', [
    'The last trick adds 10, so the cards of a Hokm deal are worth 162 points and those of a Sun deal 130.',
  ], tableHeader: ['Card', 'Hokm trump', 'Other suits and Sun'], table: [
    ['Jack', '20', '2'],
    ['Nine', '14', '0'],
    ['Ace', '11', '11'],
    ['Ten', '10', '10'],
    ['King', '4', '4'],
    ['Queen', '3', '3'],
    ['Eight, seven', '0', '0'],
  ]),
  RulesSection('Projects and the baloot', [
    'Players declare their sequences and four of a kind with the first card. Only the side with the best project '
        'scores its projects. In game points a project counts twice as much in Sun as in Hokm.',
    'The king and queen of trumps in one hand are the baloot, 2 game points in Hokm that always stay with their '
        'holder and are never doubled.',
  ], tableHeader: ['Project', 'Hokm', 'Sun'], table: [
    ['Sira — three in a row', '2', '4'],
    ['Fifty — four in a row', '5', '10'],
    ['Hundred — five in a row, or four kings, queens, jacks or tens; four aces in Hokm', '10', '20'],
    ['Four hundred — four aces', '—', '40'],
    ['Baloot — king and queen of trumps', '2', '—'],
  ]),
  RulesSection('Counting a deal', [
    'One side counts its card points and turns them into game points; the other side gets the rest. In Hokm the '
        'points are rounded to tens, a five rounding down, and divided by ten; in Sun they are rounded the same '
        'way and doubled, while a five is simply halved.',
    'Normally the opponents of the buyer count. The buyer wins the deal by scoring more game points than the '
        'opponents, projects and baloot included; then each side scores its own. When the buyer scores less, the '
        'opponents take the whole deal: 16 or 26 with every project.',
    'On equal game points the last digit of the counting side decides. In Hokm the counting side wins on 2 to 5, '
        'the buyer on 1 and on 6 to 0; in Sun a five goes to the buyer.',
  ]),
  RulesSection('Kaboot', [
    'A side that takes every trick makes a kaboot: 25 game points in Hokm and 44 in Sun, plus its projects.',
  ]),
  RulesSection('Double, three, four and gahwa', [
    'The opponents may double a deal; in Hokm the buyer may answer with a three, the opponents with a four, and '
        'the buyer with a gahwa. A Sun deal can only be doubled.',
    'A doubled deal goes whole to the side that wins it: 16 or 26 times two, three or four, with the projects '
        'doubled and the baloot as it is. Whoever wins a gahwa wins the whole match.',
  ]),
  RulesSection('Winning', [
    'The match is played to 152 game points. The first side past 152 wins; when both pass it in the same deal '
        'the higher score wins, and equal scores play another deal.',
    'Tables differ on some details, such as who counts a doubled deal and how a tie is settled. The app follows '
        'the scoring described here.',
  ]),
  RulesSection('Keeping the score in the app', [
    'After each deal tap "New round", pick the side that bought, choose Hokm or Sun, mark a double, three, four '
        'or gahwa, count the projects and type the card points of one side; the app turns them into game points, '
        'spots a lost deal and keeps track of who deals.',
    'Tap any deal in the history to correct or delete it, and ↶ to undo the last one.',
  ]),
];

const _ar = [
  RulesSection('اللاعبون والأوراق', [
    'يلعب البلوت أربعة لاعبين في فريقين، كل شريكين متقابلين، باثنتين وثلاثين ورقة، من السبعة إلى الإكَّة في كل '
        'نوع. يدور اللعب عكس عقارب الساعة.',
    'يأخذ كل لاعب خمس أوراق أولاً وتُكشف ورقة واحدة. من يشتريها يأخذها، ثم يُكمل الباقون أوراقهم الثمانية.',
  ]),
  RulesSection('الحكم والصن', [
    'يستطيع كل لاعب بدوره أن يشتري الورقة المكشوفة حكماً، أي لعباً بالحكم، أو صناً، أي لعباً بلا حكم، والصن '
        'أعلى من الحكم. في الحكم يكون نوع الورقة هو الحكم، أو نوعاً آخر يسميه المشتري في الدور الثاني.',
    'جولة الحكم تساوي 16 نقطة والصن 26 نقطة، قبل المشاريع.',
  ]),
  RulesSection('قيمة الأوراق', [
    'الأكلة الأخيرة تضيف 10، فتكون أوراق الحكم 162 بنطاً وأوراق الصن 130.',
  ], tableHeader: ['الورقة', 'حكم', 'الأنواع الأخرى والصن'], table: [
    ['الولد', '20', '2'],
    ['التسعة', '14', '0'],
    ['الإكَّة', '11', '11'],
    ['العشرة', '10', '10'],
    ['الشايب', '4', '4'],
    ['البنت', '3', '3'],
    ['الثمانية والسبعة', '0', '0'],
  ]),
  RulesSection('المشاريع والبلوت', [
    'يعلن اللاعبون مشاريعهم مع الورقة الأولى. يسجّل مشاريعه فقط الفريق صاحب أعلى مشروع. والمشروع في الصن '
        'ضعف قيمته في الحكم.',
    'الشايب والبنت من الحكم في يد واحدة هما البلوت، نقطتان في الحكم تبقيان دائماً لصاحبهما ولا تُضاعفان.',
  ], tableHeader: ['المشروع', 'حكم', 'صن'], table: [
    ['سرا — ثلاث متتالية', '2', '4'],
    ['خمسين — أربع متتالية', '5', '10'],
    ['مية — خمس متتالية، أو أربعة شياب أو بنات أو أولاد أو عشرات؛ وأربع إكَك في الحكم', '10', '20'],
    ['أربعمية — أربع إكَك', '—', '40'],
    ['بلوت — الشايب والبنت من الحكم', '2', '—'],
  ]),
  RulesSection('حساب الجولة', [
    'يحسب فريق واحد أبناطه ويحوّلها إلى نقاط، ويأخذ الفريق الآخر الباقي. في الحكم تُقرَّب الأبناط إلى العشرات، '
        'والخمسة تُنزَّل، ثم تُقسم على عشرة؛ وفي الصن تُقرَّب بالطريقة نفسها وتُضاعف، أما الخمسة فتُقسم على خمسة.',
    'في العادة يحسب خصوم المشتري. يربح المشتري الجولة إذا جمع نقاطاً أكثر من خصومه، مع المشاريع والبلوت، '
        'ويسجّل كل فريق نقاطه. وإذا جمع أقل خسر، ويأخذ الخصوم الجولة كلها: 16 أو 26 مع كل المشاريع.',
    'عند تساوي النقاط يحسم الأمر آخر رقم عند الفريق الحاسب. في الحكم يربح الحاسب على 2 إلى 5، والمشتري على 1 '
        'وعلى 6 إلى 0؛ وفي الصن تكون الخمسة للمشتري.',
  ]),
  RulesSection('الكبوت', [
    'الفريق الذي يأخذ كل الأكلات يسجّل كبوت: 25 نقطة في الحكم و44 في الصن، مع مشاريعه.',
  ]),
  RulesSection('الدبل والثري والفور والقهوة', [
    'يستطيع الخصوم أن يدبّلوا الجولة؛ وفي الحكم يردّ المشتري بالثري، والخصوم بالفور، والمشتري بالقهوة. '
        'أما الصن فلا يُلعب إلا بالدبل.',
    'الجولة المدبّلة تذهب كلها للفريق الفائز بها: 16 أو 26 مضروبة في اثنين أو ثلاثة أو أربعة، والمشاريع مضاعفة '
        'والبلوت كما هو. ومن يربح القهوة يربح الصكة كلها.',
  ]),
  RulesSection('الفوز', [
    'تُلعب الصكة حتى 152 نقطة. يفوز أول فريق يتجاوز 152؛ وإذا تجاوزها الفريقان في الجولة نفسها فاز صاحب '
        'النتيجة الأعلى، وعند التساوي تُلعب جولة أخرى.',
    'تختلف الجلسات في بعض التفاصيل، مثل من يحسب الجولة المدبّلة وكيف يُحسم التعادل. يتّبع التطبيق الحساب الموصوف هنا.',
  ]),
  RulesSection('تسجيل النتيجة في التطبيق', [
    'بعد كل جولة اضغط «جولة جديدة»، واختر الفريق المشتري، وحدّد حكم أو صن، وعلّم الدبل أو الثري أو الفور أو '
        'القهوة، واحسب المشاريع، واكتب أبناط أحد الفريقين؛ يحوّلها التطبيق إلى نقاط ويكشف الخسارة ويتابع من يوزّع.',
    'اضغط على أي جولة في السجل لتصحيحها أو حذفها، و↶ للتراجع عن الأخيرة.',
  ]),
];

const _uk = [
  RulesSection('Гравці й карти', [
    'У балут грають четверо двома командами по двоє, партнери сидять навпроти, колодою з 32 карт, від сімки до '
        'туза в кожній масті. Гра йде проти годинникової стрілки.',
    'Спершу кожен отримує п\'ять карт, і одну карту відкривають. Той, хто її купує, бере цю карту, а решта '
        'добирають свої вісім карт.',
  ]),
  RulesSection('Хокм і сан', [
    'Кожен гравець по черзі може купити відкриту карту як хокм — гру з козирем, або як сан — гру без козиря; сан '
        'старший за хокм. У хокмі козир — масть цієї карти або, у другому колі, інша масть, яку назве покупець.',
    'Роздача хокм коштує 16 ігрових очок, а сан — 26, без проєктів.',
  ]),
  RulesSection('Вартість карт', [
    'Остання взятка додає 10, тож карти роздачі хокм коштують 162 очки, а роздачі сан — 130.',
  ], tableHeader: ['Карта', 'Козир у хокмі', 'Інші масті й сан'], table: [
    ['Валет', '20', '2'],
    ['Дев\'ятка', '14', '0'],
    ['Туз', '11', '11'],
    ['Десятка', '10', '10'],
    ['Король', '4', '4'],
    ['Дама', '3', '3'],
    ['Вісімка, сімка', '0', '0'],
  ]),
  RulesSection('Проєкти й балут', [
    'Послідовності й каре оголошують з першою картою. Записує проєкти лише сторона з найстаршим проєктом. В '
        'ігрових очках проєкт у сані коштує вдвічі більше, ніж у хокмі.',
    'Король і дама козирів в одній руці — це балут, 2 ігрові очки в хокмі, які завжди лишаються їхньому власнику '
        'й ніколи не подвоюються.',
  ], tableHeader: ['Проєкт', 'Хокм', 'Сан'], table: [
    ['Сира — три підряд', '2', '4'],
    ['П\'ятдесят — чотири підряд', '5', '10'],
    ['Сотня — п\'ять підряд або чотири королі, дами, валети чи десятки; чотири тузи в хокмі', '10', '20'],
    ['Чотириста — чотири тузи', '—', '40'],
    ['Балут — король і дама козирів', '2', '—'],
  ]),
  RulesSection('Як рахують роздачу', [
    'Одна сторона рахує свої очки за карти й переводить їх в ігрові; друга отримує решту. У хокмі очки '
        'округлюють до десятків, п\'ятірку вниз, і ділять на десять; у сані округлюють так само й подвоюють, а '
        'п\'ятірку просто ділять на п\'ять.',
    'Зазвичай рахують суперники покупця. Покупець виграє роздачу, коли набирає більше ігрових очок, ніж '
        'суперники, разом із проєктами й балутом; тоді кожна сторона записує своє. Коли покупець набирає менше, '
        'суперники забирають усю роздачу: 16 або 26 з усіма проєктами.',
    'За рівних ігрових очок вирішує остання цифра сторони, що рахує. У хокмі вона виграє на 2–5, а покупець — на '
        '1 і на 6–0; у сані п\'ятірка дістається покупцеві.',
  ]),
  RulesSection('Кабут', [
    'Сторона, що взяла всі взятки, робить кабут: 25 ігрових очок у хокмі й 44 у сані, плюс її проєкти.',
  ]),
  RulesSection('Дабл, тріо, фор і кахва', [
    'Суперники можуть подвоїти роздачу — дабл; у хокмі покупець може відповісти тріо, суперники — фором, а '
        'покупець — кахвою. Роздачу сан можна лише подвоїти.',
    'Подвоєна роздача цілком дістається стороні, що її виграла: 16 або 26, помножені на два, три чи чотири, з '
        'подвоєними проєктами й балутом як є. Хто виграє кахву, той виграє всю партію.',
  ]),
  RulesSection('Перемога', [
    'Партію грають до 152 ігрових очок. Перемагає сторона, що першою перейде 152; якщо обидві перейшли в одній '
        'роздачі, перемагає більший рахунок, а за рівного грають ще одну роздачу.',
    'За різними столами деякі деталі відрізняються, наприклад хто рахує подвоєну роздачу і як вирішують нічию. '
        'Застосунок рахує так, як описано тут.',
  ]),
  RulesSection('Як вести рахунок у застосунку', [
    'Після кожної роздачі натисни «Нова роздача», обери сторону, що купила, вибери хокм або сан, познач дабл, '
        'тріо, фор чи кахву, порахуй проєкти та введи очки за карти однієї сторони; застосунок переведе їх в '
        'ігрові, помітить програну роздачу й стежитиме, хто роздає.',
    'Торкнися будь-якої роздачі в історії, щоб виправити чи видалити її, а ↶ скасовує останню.',
  ]),
];

const _fr = [
  RulesSection('Joueurs et cartes', [
    'Le Baloot se joue à quatre en deux équipes de deux, les partenaires assis face à face, avec 32 cartes, du sept '
        'à l\'as dans chaque couleur. Le jeu tourne dans le sens inverse des aiguilles d\'une montre.',
    'Chaque joueur reçoit d\'abord cinq cartes et une carte est retournée. Le joueur qui l\'achète prend cette '
        'carte et les autres reçoivent le reste de leurs huit cartes.',
  ]),
  RulesSection('Hokm et Sun', [
    'Chaque joueur à son tour peut acheter la carte retournée en Hokm, une donne avec atout, ou en Sun, une donne '
        'sans atout ; le Sun l\'emporte sur le Hokm. En Hokm, la couleur de la carte est l\'atout ou, au second '
        'tour, une autre couleur que l\'acheteur nomme.',
    'Une donne en Hokm vaut 16 points de partie et une donne en Sun 26, hors projets.',
  ]),
  RulesSection('Valeur des cartes', [
    'Le dernier pli ajoute 10, donc les cartes d\'une donne en Hokm valent 162 points et celles d\'une donne en Sun '
        '130.',
  ], tableHeader: ['Carte', 'Atout en Hokm', 'Autres couleurs et Sun'], table: [
    ['Valet', '20', '2'],
    ['Neuf', '14', '0'],
    ['As', '11', '11'],
    ['Dix', '10', '10'],
    ['Roi', '4', '4'],
    ['Dame', '3', '3'],
    ['Huit, sept', '0', '0'],
  ]),
  RulesSection('Projets et baloot', [
    'Les joueurs annoncent leurs suites et leurs carrés avec la première carte. Seul le camp qui a le meilleur '
        'projet marque ses projets. En points de partie, un projet compte deux fois plus en Sun qu\'en Hokm.',
    'Le roi et la dame d\'atout dans une même main forment le baloot : 2 points de partie en Hokm, qui restent '
        'toujours à leur détenteur et ne sont jamais doublés.',
  ], tableHeader: ['Projet', 'Hokm', 'Sun'], table: [
    ['Sira — trois à la suite', '2', '4'],
    ['Cinquante — quatre qui se suivent', '5', '10'],
    ['Cent — cinq à la suite, ou quatre rois, dames, valets ou dix ; quatre as en Hokm', '10', '20'],
    ['Quatre cents — quatre as', '—', '40'],
    ['Baloot — roi et dame d\'atout', '2', '—'],
  ]),
  RulesSection('Compter une donne', [
    'Un camp compte ses points de cartes et les convertit en points de partie ; l\'autre camp reçoit le reste. En '
        'Hokm, les points sont arrondis à la dizaine, un cinq arrondi vers le bas, puis divisés par dix ; en Sun, '
        'ils sont arrondis de la même façon et doublés, tandis qu\'un cinq est simplement divisé par deux.',
    'D\'habitude, ce sont les adversaires de l\'acheteur qui comptent. L\'acheteur gagne la donne s\'il marque plus '
        'de points de partie que ses adversaires, projets et baloot compris ; chaque camp marque alors les siens. '
        'Si l\'acheteur marque moins, les adversaires prennent toute la donne : 16 ou 26 avec tous les projets.',
    'À égalité de points de partie, le dernier chiffre du camp qui compte décide. En Hokm, le camp qui compte gagne '
        'sur 2 à 5, l\'acheteur sur 1 et sur 6 à 0 ; en Sun, un cinq va à l\'acheteur.',
  ]),
  RulesSection('Kaboot', [
    'Un camp qui fait tous les plis fait un kaboot : 25 points de partie en Hokm et 44 en Sun, plus ses projets.',
  ]),
  RulesSection('Double, three, four et gahwa', [
    'Les adversaires peuvent doubler une donne ; en Hokm, l\'acheteur peut répondre par un three, les adversaires '
        'par un four, et l\'acheteur par une gahwa. Une donne en Sun ne peut qu\'être doublée.',
    'Une donne doublée va entière au camp qui la gagne : 16 ou 26 fois deux, trois ou quatre, avec les projets '
        'doublés et le baloot tel quel. Qui gagne une gahwa gagne toute la partie.',
  ]),
  RulesSection('La victoire', [
    'La partie se joue en 152 points de partie. Le premier camp à dépasser 152 gagne ; quand les deux le dépassent '
        'dans la même donne, le score le plus élevé gagne, et à égalité on joue une donne de plus.',
    'Les tables diffèrent sur certains détails, comme qui compte une donne doublée et comment se règle une égalité. '
        'L\'application suit le compte décrit ici.',
  ]),
  RulesSection('Tenir le score dans l\'application', [
    'Après chaque donne, touchez « Nouvelle donne », choisissez le camp qui a acheté, choisissez Hokm ou Sun, '
        'marquez un double, three, four ou gahwa, comptez les projets et saisissez les points de cartes d\'un camp '
        '; l\'application les convertit en points de partie, voit une donne perdue et sait qui donne.',
    'Touchez une donne de l\'historique pour la corriger ou la supprimer, et ↶ pour annuler la dernière.',
  ]),
];

const _bg = [
  RulesSection('Играчи и карти', [
    'Балутът се играе от четирима в два отбора по двама, като партньорите седят един срещу друг, с тесте от 32 '
        'карти, от седмица до асо във всяка боя. Играта върви обратно на часовниковата стрелка.',
    'Всеки играч първо получава пет карти и една карта се обръща с лицето нагоре. Играчът, който я купи, взема тази '
        'карта, а останалите получават остатъка от осемте си карти.',
  ]),
  RulesSection('Хокм и сун', [
    'Всеки играч поред може да купи обърнатата карта като хокм — раздаване с коз, или като сун — раздаване без коз; '
        'сун е по-силен от хокм. При хокм боята на картата е коз или, във втори кръг, друга боя, която купувачът '
        'назове.',
    'Раздаване хокм струва 16 точки за играта, а раздаване сун — 26, без проектите.',
  ]),
  RulesSection('Стойност на картите', [
    'Последната взятка добавя 10, така че картите в раздаване хокм струват 162 точки, а в раздаване сун — 130.',
  ], tableHeader: ['Карта', 'Коз при хокм', 'Другите бои и сун'], table: [
    ['Вале', '20', '2'],
    ['Деветка', '14', '0'],
    ['Асо', '11', '11'],
    ['Десетка', '10', '10'],
    ['Поп', '4', '4'],
    ['Дама', '3', '3'],
    ['Осмица, седмица', '0', '0'],
  ]),
  RulesSection('Проекти и балут', [
    'Играчите обявяват поредиците и каретата си с първата карта. Проектите си записва само страната с най-добрия '
        'проект. В точки за играта проектът струва два пъти повече при сун, отколкото при хокм.',
    'Поп и дама коз в една ръка са балутът — 2 точки за играта при хокм, които винаги остават за притежателя си и '
        'никога не се удвояват.',
  ], tableHeader: ['Проект', 'Хокм', 'Сун'], table: [
    ['Сира — три поредни', '2', '4'],
    ['Петдесет — четири поредни', '5', '10'],
    ['Сто — пет поредни или четири попа, дами, валета или десетки; четири аса при хокм', '10', '20'],
    ['Четиристотин — четири аса', '—', '40'],
    ['Балут — поп и дама коз', '2', '—'],
  ]),
  RulesSection('Броене на раздаването', [
    'Едната страна брои точките от картите си и ги превръща в точки за играта; другата страна получава остатъка. '
        'При хокм точките се закръглят до десетици, като петицата се закръгля надолу, и се делят на десет; при сун '
        'се закръглят по същия начин и се удвояват, а петицата просто се дели на две.',
    'Обикновено броят противниците на купувача. Купувачът печели раздаването, ако събере повече точки за играта от '
        'противниците, заедно с проектите и балута; тогава всяка страна записва своите. Ако купувачът събере '
        'по-малко, противниците вземат цялото раздаване: 16 или 26 с всички проекти.',
    'При равни точки за играта решава последната цифра на броящата страна. При хокм броящата страна печели при 2 до '
        '5, а купувачът при 1 и при 6 до 0; при сун петицата е за купувача.',
  ]),
  RulesSection('Кабут', [
    'Страната, която вземе всички взятки, прави кабут: 25 точки за играта при хокм и 44 при сун, плюс проектите си.',
  ]),
  RulesSection('Дабъл, три, четири и гахуа', [
    'Противниците могат да удвоят раздаването; при хокм купувачът може да отговори с три, противниците с четири, а '
        'купувачът с гахуа. Раздаване сун може само да се удвои.',
    'Удвоеното раздаване отива цялото при страната, която го спечели: 16 или 26 по две, три или четири, с удвоени '
        'проекти и балута без промяна. Който спечели гахуа, печели цялата игра.',
  ]),
  RulesSection('Победа', [
    'Играта е до 152 точки. Печели първата страна, която надхвърли 152; когато и двете го надхвърлят в една '
        'раздача, печели по-високият резултат, а при равенство се играе още едно раздаване.',
    'Масите се различават в някои подробности, например кой брои удвоено раздаване и как се решава равенство. '
        'Приложението следва броенето, описано тук.',
  ]),
  RulesSection('Как се води резултатът в приложението', [
    'След всяка раздача натиснете „Нова раздача", изберете купилата страна, изберете хокм или сун, отбележете '
        'дабъл, три, четири или гахуа, пребройте проектите и въведете точките от картите на едната страна; '
        'приложението ги превръща в точки за играта, разпознава загубено раздаване и следи кой раздава.',
    'Докоснете която и да е раздача в историята, за да я поправите или изтриете, и ↶, за да отмените последната.',
  ]),
];

const _hr = [
  RulesSection('Igrači i karte', [
    'Balot igraju četvorica u dva para, a partneri sjede jedan nasuprot drugome, sa špilom od 32 karte, od sedmice '
        'do asa u svakoj boji. Igra ide suprotno od kazaljke na satu.',
    'Svaki igrač najprije dobiva pet karata i jedna se karta okrene licem prema gore. Igrač koji je kupi uzima tu '
        'kartu, a ostali dobivaju ostatak svojih osam karata.',
  ]),
  RulesSection('Hokm i sun', [
    'Svaki igrač redom može kupiti okrenutu kartu kao hokm, dijeljenje s adutom, ili kao sun, dijeljenje bez aduta; '
        'sun je jači od hokma. U hokmu je boja karte adut ili, u drugom krugu, neka druga boja koju kupac imenuje.',
    'Dijeljenje u hokmu vrijedi 16 bodova igre, a dijeljenje u sunu 26, bez projekata.',
  ]),
  RulesSection('Vrijednost karata', [
    'Zadnji štih donosi 10, pa karte dijeljenja u hokmu vrijede 162 boda, a u sunu 130.',
  ], tableHeader: ['Karta', 'Adut u hokmu', 'Ostale boje i sun'], table: [
    ['Dečko', '20', '2'],
    ['Devetka', '14', '0'],
    ['As', '11', '11'],
    ['Desetka', '10', '10'],
    ['Kralj', '4', '4'],
    ['Baba', '3', '3'],
    ['Osmica, sedmica', '0', '0'],
  ]),
  RulesSection('Projekti i balot', [
    'Igrači prijavljuju nizove i četiri iste s prvom kartom. Projekte upisuje samo strana s najboljim projektom. U '
        'bodovima igre projekt u sunu vrijedi dvostruko više nego u hokmu.',
    'Kralj i baba u adutu u istoj ruci čine balot, 2 boda igre u hokmu koji uvijek ostaju vlasniku i nikad se ne '
        'udvostručuju.',
  ], tableHeader: ['Projekt', 'Hokm', 'Sun'], table: [
    ['Sira — tri u nizu', '2', '4'],
    ['Pedeset — četiri zaredom', '5', '10'],
    ['Sto — pet u nizu ili četiri kralja, babe, dečka ili desetke; četiri asa u hokmu', '10', '20'],
    ['Četiristo — četiri asa', '—', '40'],
    ['Balot — kralj i baba u adutu', '2', '—'],
  ]),
  RulesSection('Brojanje dijeljenja', [
    'Jedna strana broji svoje bodove karata i pretvara ih u bodove igre; druga strana dobiva ostatak. U hokmu se '
        'bodovi zaokružuju na desetice, petica se zaokružuje prema dolje, i dijele s deset; u sunu se zaokružuju na '
        'isti način i udvostručuju, a petica se jednostavno prepolovi.',
    'Obično broje protivnici kupca. Kupac dobiva dijeljenje ako skupi više bodova igre od protivnika, uključujući '
        'projekte i balot; tada svaka strana upisuje svoje. Ako kupac skupi manje, protivnici uzimaju cijelo '
        'dijeljenje: 16 ili 26 sa svim projektima.',
    'Kod jednakih bodova igre odlučuje zadnja znamenka strane koja broji. U hokmu strana koja broji dobiva na 2 do '
        '5, a kupac na 1 i na 6 do 0; u sunu petica ide kupcu.',
  ]),
  RulesSection('Kabut', [
    'Strana koja uzme sve štihove ima kabut: 25 bodova igre u hokmu i 44 u sunu, uz svoje projekte.',
  ]),
  RulesSection('Dabl, tri, četiri i gahva', [
    'Protivnici mogu udvostručiti dijeljenje; u hokmu kupac može odgovoriti s tri, protivnici s četiri, a kupac s '
        'gahvom. Dijeljenje u sunu može se samo udvostručiti.',
    'Udvostručeno dijeljenje ide cijelo strani koja ga dobije: 16 ili 26 puta dva, tri ili četiri, s udvostručenim '
        'projektima i balotom kakav jest. Tko dobije gahvu, dobiva cijelu partiju.',
  ]),
  RulesSection('Pobjeda', [
    'Partija se igra do 152 boda igre. Pobjeđuje prva strana koja prijeđe 152; kad ih obje prijeđu u istom '
        'dijeljenju, pobjeđuje veći rezultat, a kod jednakog rezultata igra se još jedno dijeljenje.',
    'Stolovi se razlikuju u nekim pojedinostima, primjerice tko broji udvostručeno dijeljenje i kako se rješava '
        'neriješeno. Aplikacija slijedi brojanje opisano ovdje.',
  ]),
  RulesSection('Vođenje rezultata u aplikaciji', [
    'Nakon svakog dijeljenja dodirnite „Novo dijeljenje", odaberite stranu koja je kupila, odaberite hokm ili sun, '
        'označite dabl, tri, četiri ili gahvu, prebrojite projekte i upišite bodove karata jedne strane; aplikacija '
        'ih pretvara u bodove igre, prepoznaje izgubljeno dijeljenje i prati tko dijeli.',
    'Dodirnite bilo koje dijeljenje u povijesti da ga ispravite ili izbrišete, a ↶ da poništite zadnje.',
  ]),
];

const _nl = [
  RulesSection('Spelers en kaarten', [
    'Baloot wordt met vier gespeeld in twee teams van twee, met de partners tegenover elkaar, met 32 kaarten, zeven '
        'tot en met aas in elke kleur. Er wordt tegen de klok in gespeeld.',
    'Elke speler krijgt eerst vijf kaarten en één kaart wordt opengedraaid. De speler die hem koopt, neemt die '
        'kaart en de anderen krijgen de rest van hun acht kaarten.',
  ]),
  RulesSection('Hokm en sun', [
    'Om de beurt mag elke speler de opengedraaide kaart kopen als hokm, een spel met troef, of als sun, een spel '
        'zonder troef; sun gaat boven hokm. Bij hokm is de kleur van de kaart troef, of in een tweede ronde een '
        'andere kleur die de koper noemt.',
    'Een hokm-spel is 16 spelpunten waard en een sun-spel 26, zonder projecten.',
  ]),
  RulesSection('Waarde van de kaarten', [
    'De laatste slag geeft er 10 bij, dus de kaarten van een hokm-spel zijn 162 punten waard en die van een '
        'sun-spel 130.',
  ], tableHeader: ['Kaart', 'Troef bij hokm', 'Andere kleuren en sun'], table: [
    ['Boer', '20', '2'],
    ['Negen', '14', '0'],
    ['Aas', '11', '11'],
    ['Tien', '10', '10'],
    ['Heer', '4', '4'],
    ['Vrouw', '3', '3'],
    ['Acht, zeven', '0', '0'],
  ]),
  RulesSection('Projecten en de baloot', [
    'Spelers melden hun reeksen en vier gelijke bij de eerste kaart. Alleen de partij met het beste project '
        'schrijft haar projecten. In spelpunten telt een project bij sun twee keer zoveel als bij hokm.',
    'Heer en vrouw van troef in één hand zijn de baloot, 2 spelpunten bij hokm die altijd bij hun houder blijven en '
        'nooit verdubbeld worden.',
  ], tableHeader: ['Project', 'Hokm', 'Sun'], table: [
    ['Sira — drie op een rij', '2', '4'],
    ['Vijftig — vier op een rij', '5', '10'],
    ['Honderd — vijf op een rij, of vier heren, vrouwen, boeren of tienen; vier azen bij hokm', '10', '20'],
    ['Vierhonderd — vier azen', '—', '40'],
    ['Baloot — heer en vrouw van troef', '2', '—'],
  ]),
  RulesSection('Een spel tellen', [
    'Eén partij telt haar kaartpunten en zet ze om in spelpunten; de andere partij krijgt de rest. Bij hokm worden '
        'de punten op tientallen afgerond, een vijf naar beneden, en door tien gedeeld; bij sun worden ze op '
        'dezelfde manier afgerond en verdubbeld, terwijl een vijf gewoon gehalveerd wordt.',
    'Normaal tellen de tegenstanders van de koper. De koper wint het spel als hij meer spelpunten haalt dan de '
        'tegenstanders, projecten en baloot inbegrepen; dan schrijft elke partij de hare. Haalt de koper minder, '
        'dan nemen de tegenstanders het hele spel: 16 of 26 met alle projecten.',
    'Bij gelijke spelpunten beslist het laatste cijfer van de tellende partij. Bij hokm wint de tellende partij op '
        '2 tot en met 5, de koper op 1 en op 6 tot en met 0; bij sun gaat een vijf naar de koper.',
  ]),
  RulesSection('Kaboot', [
    'Een partij die alle slagen haalt, maakt kaboot: 25 spelpunten bij hokm en 44 bij sun, plus haar projecten.',
  ]),
  RulesSection('Double, three, four en gahwa', [
    'De tegenstanders mogen een spel verdubbelen; bij hokm kan de koper antwoorden met een three, de tegenstanders '
        'met een four en de koper met een gahwa. Een sun-spel kan alleen verdubbeld worden.',
    'Een verdubbeld spel gaat helemaal naar de partij die het wint: 16 of 26 keer twee, drie of vier, met de '
        'projecten verdubbeld en de baloot zoals hij is. Wie een gahwa wint, wint de hele partij.',
  ]),
  RulesSection('Winnen', [
    'De partij gaat tot 152 spelpunten. De eerste partij die over 152 gaat, wint; gaan beide erover in hetzelfde '
        'spel, dan wint de hoogste stand, en bij gelijke stand wordt nog een spel gespeeld.',
    'Tafels verschillen in sommige details, zoals wie een verdubbeld spel telt en hoe een gelijke stand wordt '
        'beslist. De app volgt de telling die hier beschreven staat.',
  ]),
  RulesSection('De stand bijhouden in de app', [
    'Tik na elk spel op ‘Nieuw spel\', kies de partij die kocht, kies hokm of sun, markeer een double, three, four '
        'of gahwa, tel de projecten en voer de kaartpunten van één partij in; de app zet ze om in spelpunten, ziet '
        'een verloren spel en houdt bij wie deelt.',
    'Tik op een spel in de lijst om het te verbeteren of te verwijderen, en op ↶ om het laatste ongedaan te maken.',
  ]),
];
