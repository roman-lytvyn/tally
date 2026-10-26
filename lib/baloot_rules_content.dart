import 'rules_content.dart';

/// The rules of Baloot in [lang], English when there is none.
List<RulesSection> balootRulesContent(String lang) => switch (lang) {
  'ar' => _ar,
  'uk' => _uk,
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
