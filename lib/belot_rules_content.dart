import 'rules_content.dart';

/// The rules and history of Bulgarian Belot in [lang], English when there is none.
List<RulesSection> belotRulesContent(String lang) => switch (lang) {
  'bg' => _bg,
  'uk' => _uk,
  _    => _en,
};

const _en = [
  RulesSection('Where the game comes from', [
    'Belot is the Bulgarian member of the Jass, or jack–nine, family of card games, in which the jack and the '
        'nine are the highest trumps. It came to Bulgaria from the French Belote and is now the most played card '
        'game in the country.',
    'The Bulgarian game took its own form: instead of taking a turned-up card, players bid for a contract, as '
        'in bridge, which is why it is also called bridge-belot. A deal can be played in one suit, without trumps '
        'or with every suit trump.',
    'Its relatives include the French Belote, the Croatian Bela, the Armenian Bazar Blot, the Saudi Baloot and '
        'the Ukrainian Deberc.',
  ]),
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
  RulesSection('Откъде идва играта', [
    'Белотът е българският представител на семейството игри джас, в които валето и деветката са най-силните '
        'козове. В България идва от френския белот и днес е най-играната игра на карти в страната.',
    'Българската игра има своя форма: вместо да се вземе обърната карта, играчите обявяват договор, както в '
        'бриджа, затова се нарича и бридж-белот. Раздаването може да се играе в една боя, без коз или всичко коз.',
    'Сродни игри са френският белот, хърватската бела, арменският базар блот, саудитският балут и украинският '
        'деберц.',
  ]),
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
  RulesSection('Звідки походить гра', [
    'Белот — болгарський представник родини джас, карткових ігор, у яких валет і дев\'ятка — найстарші козирі. '
        'До Болгарії він прийшов із французького белоту й сьогодні це найпопулярніша карткова гра в країні.',
    'Болгарська гра має свою форму: замість того щоб брати відкриту карту, гравці торгуються за контракт, як у '
        'бриджі, тому її ще називають бридж-белот. Роздачу можна грати в одній масті, без козиря або коли козирні '
        'всі масті.',
    'Її родичі — французький белот, хорватська бела, вірменський базар блот, саудівський балут і український '
        'деберць.',
  ]),
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
