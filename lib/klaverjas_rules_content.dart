import 'rules_content.dart';

/// The rules of Klaverjas in [lang], English when there is none.
List<RulesSection> klaverjasRulesContent(String lang) => switch (lang) {
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
    'Klaverjas is played by four in two teams of two, partners sitting opposite each other, with a 32-card deck, '
        'seven to ace in each suit. Every player gets eight cards.',
    'The side that chooses the trump is the playing side; the other side tries to stop it. Tables choose the trump '
        'in different ways: in turn, by a turned-up card, or with the first player obliged to choose one.',
  ]),
  RulesSection('Card values', [
    'The last trick adds 10, so the cards of a deal are worth 162 points. The jack of trumps is called the jas, '
        'the nine of trumps the nel.',
  ], tableHeader: ['Card', 'Trump', 'Other suit'], table: [
    ['Jack', '20', '2'],
    ['Nine', '14', '0'],
    ['Ace', '11', '11'],
    ['Ten', '10', '10'],
    ['King', '4', '4'],
    ['Queen', '3', '3'],
    ['Eight, seven', '0', '0'],
  ]),
  RulesSection('Amsterdam and Rotterdam rules', [
    'There are two main ways to play. In both, a player has to follow suit and, when unable to, has to trump, '
        'overtrumping a trump already played if possible.',
    'In the Rotterdam rules a player has to trump even when the partner is already winning the trick. In the '
        'Amsterdam rules that is not required: a player whose partner is winning may play any card.',
    'The app follows the Amsterdam rules. The difference lies only in the play, so the score is kept the same way '
        'under both.',
  ]),
  RulesSection('Roem', [
    'Roem is counted in the tricks: the side that wins a trick scores the roem among its four cards. Runs count '
        'in the order seven, eight, nine, ten, jack, queen, king, ace, within one suit. The roem is added to the '
        'value of the deal.',
  ], tableHeader: ['Roem', 'Points'], table: [
    ['Three in a row', '20'],
    ['Four in a row', '50'],
    ['Four aces, kings, queens or tens', '100'],
    ['Four jacks', '200'],
    ['Stuk — king and queen of trumps', '20'],
  ]),
  RulesSection('Pit', [
    'A side that takes all eight tricks makes pit and scores 100 more on top of the 162 of the cards.',
  ]),
  RulesSection('Nat', [
    'The playing side has to score more than its opponents, roem included. If it does not, it goes nat: the '
        'opponents get the 162 of the cards and all the roem of the deal, the playing side\'s too, and the playing '
        'side gets nothing. Equal points also count as nat.',
  ]),
  RulesSection('Winning', [
    'A game often runs for an agreed number of deals, usually sixteen, after which the higher total wins; many '
        'tables play to 1500 points instead. The app plays to 1500: the first side to reach it wins, and when both '
        'reach it in the same deal, the higher score wins.',
  ]),
  RulesSection('Keeping the score in the app', [
    'After each deal tap "New round", pick the playing side, count the roem and type the points of one side; the '
        'app works out the rest, spots nat and keeps track of who deals.',
    'Tap any deal in the history to correct or delete it, and ↶ to undo the last one.',
  ]),
];

const _nl = [
  RulesSection('Spelers en kaarten', [
    'Klaverjassen speel je met vier in twee teams van twee, partners tegenover elkaar, met een spel van 32 kaarten, '
        'zeven tot en met aas in elke kleur. Iedere speler krijgt acht kaarten.',
    'De partij die troef maakt is de spelende partij; de andere partij probeert haar tegen te houden. Hoe troef '
        'wordt gekozen verschilt per tafel: om de beurt, met een opengedraaide kaart, of verplicht door de eerste '
        'speler.',
  ]),
  RulesSection('Waarde van de kaarten', [
    'De laatste slag telt 10 punten, dus de kaarten van een spel zijn samen 162 punten waard. De troefboer heet de '
        'jas, de troefnegen de nel.',
  ], tableHeader: ['Kaart', 'Troef', 'Andere kleur'], table: [
    ['Boer', '20', '2'],
    ['Negen', '14', '0'],
    ['Aas', '11', '11'],
    ['Tien', '10', '10'],
    ['Heer', '4', '4'],
    ['Vrouw', '3', '3'],
    ['Acht, zeven', '0', '0'],
  ]),
  RulesSection('Amsterdams en Rotterdams', [
    'Er zijn twee hoofdvormen. In beide moet je kleur bekennen en, als dat niet kan, troeven, en waar mogelijk '
        'overtroeven als er al getroefd is.',
    'Bij Rotterdams moet je ook troeven als je partner de slag al heeft. Bij Amsterdams hoeft dat niet: als je '
        'partner de slag heeft, mag je elke kaart bijspelen.',
    'De app volgt de Amsterdamse regels. Het verschil zit alleen in het spelen, dus de telling is bij beide '
        'hetzelfde.',
  ]),
  RulesSection('Roem', [
    'Roem wordt in de slagen geteld: de partij die een slag haalt, krijgt de roem in de vier kaarten van die slag. '
        'Een reeks telt in de volgorde zeven, acht, negen, tien, boer, vrouw, heer, aas, in één kleur. De roem komt '
        'bij de waarde van het spel.',
  ], tableHeader: ['Roem', 'Punten'], table: [
    ['Drie op een rij', '20'],
    ['Vier op een rij', '50'],
    ['Vier azen, heren, vrouwen of tienen', '100'],
    ['Vier boeren', '200'],
    ['Stuk — troefheer en troefvrouw', '20'],
  ]),
  RulesSection('Pit', [
    'Een partij die alle acht slagen haalt, is pit en krijgt 100 punten extra bovenop de 162 van de kaarten.',
  ]),
  RulesSection('Nat', [
    'De spelende partij moet meer punten halen dan de tegenpartij, roem meegeteld. Lukt dat niet, dan gaat ze nat: '
        'de tegenpartij krijgt de 162 van de kaarten en alle roem van het spel, ook die van de spelende partij, en de '
        'spelende partij krijgt niets. Bij gelijke punten is de spelende partij ook nat.',
  ]),
  RulesSection('Winnen', [
    'Vaak wordt een afgesproken aantal spellen gespeeld, meestal zestien, waarna het hoogste totaal wint; veel '
        'tafels spelen in plaats daarvan tot 1500 punten. De app speelt tot 1500: de partij die dat het eerst haalt, '
        'wint, en halen beide het in hetzelfde spel, dan wint de hoogste stand.',
  ]),
  RulesSection('De stand bijhouden in de app', [
    'Tik na elk spel op „Nieuw spel”, kies de spelende partij, tel de roem en vul de punten van één partij in; de '
        'app rekent de rest uit, ziet wanneer iemand nat gaat en houdt bij wie er geeft.',
    'Tik op een spel in de lijst om het te verbeteren of te verwijderen, en op ↶ om het laatste ongedaan te maken.',
  ]),
];

const _uk = [
  RulesSection('Гравці й карти', [
    'У клаверяс грають учотирьох двома командами по двоє, партнери сидять навпроти. Колода — 32 карти, від сімки '
        'до туза в кожній масті. Кожен гравець отримує вісім карт.',
    'Сторона, що обирає козир, — гравча; інша сторона намагається їй завадити. Козир за різними столами обирають '
        'по-різному: по черзі, за відкритою картою або з обов\'язком першого гравця обрати його.',
  ]),
  RulesSection('Вартість карт', [
    'Остання взятка додає 10, тож карти однієї роздачі коштують 162 очки. Козирного валета називають яс, козирну '
        'дев\'ятку — нел.',
  ], tableHeader: ['Карта', 'Козир', 'Інша масть'], table: [
    ['Валет', '20', '2'],
    ['Дев\'ятка', '14', '0'],
    ['Туз', '11', '11'],
    ['Десятка', '10', '10'],
    ['Король', '4', '4'],
    ['Дама', '3', '3'],
    ['Вісімка, сімка', '0', '0'],
  ]),
  RulesSection('Амстердамські й роттердамські правила', [
    'Є два основні способи гри. В обох треба класти карту в масть, а коли її немає — козиряти, і за змоги '
        'перебивати козир, що вже лежить.',
    'За роттердамськими правилами козиряти треба навіть тоді, коли взятку вже бере партнер. За амстердамськими '
        'цього не треба: якщо взятку бере партнер, можна покласти будь-яку карту.',
    'Застосунок іде за амстердамськими правилами. Різниця лише в розіграші, тож рахунок за обома ведуть однаково.',
  ]),
  RulesSection('Роем', [
    'Роем рахують у взятках: сторона, що бере взятку, отримує роем серед її чотирьох карт. Послідовність іде в '
        'порядку сімка, вісімка, дев\'ятка, десятка, валет, дама, король, туз, в одній масті. Роем додається до '
        'вартості роздачі.',
  ], tableHeader: ['Роем', 'Очки'], table: [
    ['Три підряд', '20'],
    ['Чотири підряд', '50'],
    ['Чотири тузи, королі, дами чи десятки', '100'],
    ['Чотири валети', '200'],
    ['Стук — король і дама козирів', '20'],
  ]),
  RulesSection('Піт', [
    'Сторона, що бере всі вісім взяток, робить піт і отримує ще 100 очок понад 162 за карти.',
  ]),
  RulesSection('Нат', [
    'Гравча сторона має набрати більше за суперників, разом із роемом. Якщо ні, вона йде нат: суперники отримують '
        '162 за карти і весь роем роздачі, також і роем гравців, а гравча сторона — нічого. Рівні очки теж '
        'рахуються як нат.',
  ]),
  RulesSection('Перемога', [
    'Часто грають домовлену кількість роздач, найчастіше шістнадцять, і перемагає більша сума; багато хто натомість '
        'грає до 1500 очок. Застосунок грає до 1500: перемагає сторона, що першою їх набере, а якщо обидві набрали '
        'в одній роздачі, — та, в якої рахунок більший.',
  ]),
  RulesSection('Як вести рахунок у застосунку', [
    'Після кожної роздачі натисни «Нова роздача», обери гравчу сторону, порахуй роем і введи очки однієї сторони; '
        'решту застосунок порахує сам, помітить нат і стежитиме, хто роздає.',
    'Торкнися будь-якої роздачі в історії, щоб виправити чи видалити її, а ↶ скасовує останню.',
  ]),
];

const _fr = [
  RulesSection('Joueurs et cartes', [
    'Le Klaverjas se joue à quatre en deux équipes de deux, les partenaires assis face à face, avec 32 cartes, du '
        'sept à l\'as dans chaque couleur. Chaque joueur reçoit huit cartes.',
    'Le camp qui choisit l\'atout est le camp qui joue ; l\'autre camp essaie de l\'en empêcher. Les tables '
        'choisissent l\'atout de différentes façons : à tour de rôle, par une carte retournée, ou avec le premier '
        'joueur obligé d\'en choisir un.',
  ]),
  RulesSection('Valeur des cartes', [
    'Le dernier pli ajoute 10, donc les cartes d\'une donne valent 162 points. Le valet d\'atout s\'appelle le jas, '
        'le neuf d\'atout le nel.',
  ], tableHeader: ['Carte', 'Atout', 'Autre couleur'], table: [
    ['Valet', '20', '2'],
    ['Neuf', '14', '0'],
    ['As', '11', '11'],
    ['Dix', '10', '10'],
    ['Roi', '4', '4'],
    ['Dame', '3', '3'],
    ['Huit, sept', '0', '0'],
  ]),
  RulesSection('Règles d\'Amsterdam et de Rotterdam', [
    'Il y a deux grandes façons de jouer. Dans les deux, il faut fournir la couleur et, si on ne le peut pas, '
        'couper, en surcoupant un atout déjà joué si possible.',
    'Selon les règles de Rotterdam, il faut couper même quand le partenaire est déjà maître du pli. Selon les '
        'règles d\'Amsterdam, ce n\'est pas obligatoire : un joueur dont le partenaire est maître peut jouer '
        'n\'importe quelle carte.',
    'L\'application suit les règles d\'Amsterdam. La différence ne touche que le jeu, donc le score se tient de la '
        'même façon dans les deux cas.',
  ]),
  RulesSection('Roem', [
    'Le roem se compte dans les plis : le camp qui gagne un pli marque le roem formé par ses quatre cartes. Les '
        'suites se comptent dans l\'ordre sept, huit, neuf, dix, valet, dame, roi, as, dans une même couleur. Le '
        'roem s\'ajoute à la valeur de la donne.',
  ], tableHeader: ['Roem', 'Points'], table: [
    ['Trois à la suite', '20'],
    ['Quatre à la suite', '50'],
    ['Quatre as, rois, dames ou dix', '100'],
    ['Carré de valets', '200'],
    ['Stuk — roi et dame d\'atout', '20'],
  ]),
  RulesSection('Pit', [
    'Un camp qui fait les huit plis fait pit et marque 100 de plus en plus des 162 des cartes.',
  ]),
  RulesSection('Nat', [
    'Le camp qui joue doit marquer plus que ses adversaires, roem compris. Sinon, il est nat : les adversaires '
        'reçoivent les 162 des cartes et tout le roem de la donne, y compris celui du camp qui joue, et le camp qui '
        'joue ne reçoit rien. L\'égalité de points compte aussi comme nat.',
  ]),
  RulesSection('La victoire', [
    'Une partie se joue souvent en un nombre convenu de donnes, en général seize, après quoi le total le plus élevé '
        'gagne ; beaucoup de tables jouent plutôt en 1500 points. L\'application joue en 1500 : le premier camp qui '
        'les atteint gagne, et quand les deux les atteignent dans la même donne, le score le plus élevé gagne.',
  ]),
  RulesSection('Tenir le score dans l\'application', [
    'Après chaque donne, touchez « Nouvelle donne », choisissez le camp qui joue, comptez le roem et saisissez les '
        'points d\'un camp ; l\'application calcule le reste, voit le nat et sait qui donne.',
    'Touchez une donne de l\'historique pour la corriger ou la supprimer, et ↶ pour annuler la dernière.',
  ]),
];

const _bg = [
  RulesSection('Играчи и карти', [
    'Клаверясът се играе от четирима в два отбора по двама, като партньорите седят един срещу друг, с тесте от 32 '
        'карти, от седмица до асо във всяка боя. Всеки играч получава осем карти.',
    'Страната, която избира коза, е играещата страна; другата страна се опитва да я спре. Масите избират коза по '
        'различен начин: поред, с обърната карта или като първият играч е длъжен да избере.',
  ]),
  RulesSection('Стойност на картите', [
    'Последната взятка добавя 10, така че картите в една раздача струват 162 точки. Валето коз се нарича яс, '
        'деветката коз — нел.',
  ], tableHeader: ['Карта', 'Коз', 'Друга боя'], table: [
    ['Вале', '20', '2'],
    ['Деветка', '14', '0'],
    ['Асо', '11', '11'],
    ['Десетка', '10', '10'],
    ['Поп', '4', '4'],
    ['Дама', '3', '3'],
    ['Осмица, седмица', '0', '0'],
  ]),
  RulesSection('Амстердамски и ротердамски правила', [
    'Има два основни начина на игра. И при двата играчът трябва да отговори на боята, а ако не може — да цака, като '
        'надцаква вече изиграния коз, ако е възможно.',
    'По ротердамските правила играчът трябва да цака дори когато партньорът му вече взима взятката. По '
        'амстердамските правила това не е задължително: играч, чийто партньор взима, може да играе всяка карта.',
    'Приложението следва амстердамските правила. Разликата е само в играта, така че резултатът се води еднакво и '
        'при двете.',
  ]),
  RulesSection('Роем', [
    'Роемът се брои във взятките: страната, която спечели взятка, записва роема сред четирите ѝ карти. Поредиците '
        'се броят в реда седмица, осмица, деветка, десетка, вале, дама, поп, асо, в една боя. Роемът се добавя към '
        'стойността на раздаването.',
  ], tableHeader: ['Роем', 'Точки'], table: [
    ['Три поредни', '20'],
    ['Четири поредни', '50'],
    ['Четири аса, попа, дами или десетки', '100'],
    ['Каре валета', '200'],
    ['Щук — поп и дама коз', '20'],
  ]),
  RulesSection('Пит', [
    'Страната, която вземе всичките осем взятки, прави пит и получава още 100 над 162-те точки от картите.',
  ]),
  RulesSection('Нат', [
    'Играещата страна трябва да събере повече от противниците, заедно с роема. Ако не събере, тя е нат: '
        'противниците получават 162-те точки от картите и целия роем от раздаването, включително този на играещата '
        'страна, а играещата страна не получава нищо. Равните точки също се броят за нат.',
  ]),
  RulesSection('Победа', [
    'Често играта е за уговорен брой раздавания, обикновено шестнайсет, след което печели по-високият сбор; много '
        'маси вместо това играят до 1500 точки. Приложението играе до 1500: печели страната, която първа ги '
        'достигне, а когато и двете ги достигнат в една раздача, печели по-високият резултат.',
  ]),
  RulesSection('Как се води резултатът в приложението', [
    'След всяка раздача натиснете „Нова раздача", изберете играещата страна, пребройте роема и въведете точките на '
        'едната страна; приложението изчислява останалото, разпознава нат и следи кой раздава.',
    'Докоснете която и да е раздача в историята, за да я поправите или изтриете, и ↶, за да отмените последната.',
  ]),
];

const _hr = [
  RulesSection('Igrači i karte', [
    'Klaverjas igraju četvorica u dva para, a partneri sjede jedan nasuprot drugome, sa špilom od 32 karte, od '
        'sedmice do asa u svakoj boji. Svaki igrač dobiva osam karata.',
    'Strana koja bira adut je strana koja igra; druga strana je pokušava zaustaviti. Stolovi biraju adut na '
        'različite načine: redom, okrenutom kartom ili tako da prvi igrač mora izabrati.',
  ]),
  RulesSection('Vrijednost karata', [
    'Zadnji štih donosi 10, pa karte jednog dijeljenja vrijede 162 boda. Dečko u adutu zove se jas, devetka u adutu '
        'nel.',
  ], tableHeader: ['Karta', 'Adut', 'Ostale boje'], table: [
    ['Dečko', '20', '2'],
    ['Devetka', '14', '0'],
    ['As', '11', '11'],
    ['Desetka', '10', '10'],
    ['Kralj', '4', '4'],
    ['Baba', '3', '3'],
    ['Osmica, sedmica', '0', '0'],
  ]),
  RulesSection('Amsterdamska i roterdamska pravila', [
    'Postoje dva glavna načina igre. U oba igrač mora odgovoriti na boju, a ako ne može, mora rezati adutom, i to '
        'višim od već odigranog aduta ako je moguće.',
    'Po roterdamskim pravilima igrač mora rezati i kad njegov partner već nosi štih. Po amsterdamskim pravilima to '
        'nije obavezno: igrač čiji partner nosi štih smije odigrati bilo koju kartu.',
    'Aplikacija slijedi amsterdamska pravila. Razlika je samo u igri, pa se rezultat vodi jednako u oba slučaja.',
  ]),
  RulesSection('Roem', [
    'Roem se broji u štihovima: strana koja dobije štih upisuje roem među njegove četiri karte. Nizovi se broje '
        'redom sedmica, osmica, devetka, desetka, dečko, baba, kralj, as, u jednoj boji. Roem se dodaje vrijednosti '
        'dijeljenja.',
  ], tableHeader: ['Roem', 'Bodovi'], table: [
    ['Tri u nizu', '20'],
    ['Četiri u nizu', '50'],
    ['Četiri asa, kralja, babe ili desetke', '100'],
    ['Četiri dečka', '200'],
    ['Stuk — kralj i baba u adutu', '20'],
  ]),
  RulesSection('Pit', [
    'Strana koja uzme svih osam štihova ima pit i dobiva još 100 povrh 162 boda od karata.',
  ]),
  RulesSection('Nat', [
    'Strana koja igra mora skupiti više od protivnika, uključujući roem. Ako ne skupi, ona je nat: protivnici '
        'dobivaju 162 boda od karata i sav roem dijeljenja, i onaj strane koja igra, a strana koja igra ne dobiva '
        'ništa. I jednak broj bodova računa se kao nat.',
  ]),
  RulesSection('Pobjeda', [
    'Partija se često igra na dogovoreni broj dijeljenja, obično šesnaest, nakon čega pobjeđuje veći zbroj; mnogi '
        'stolovi umjesto toga igraju do 1500 bodova. Aplikacija igra do 1500: pobjeđuje strana koja ih prva '
        'dosegne, a kad ih obje dosegnu u istom dijeljenju, pobjeđuje veći rezultat.',
  ]),
  RulesSection('Vođenje rezultata u aplikaciji', [
    'Nakon svakog dijeljenja dodirnite „Novo dijeljenje", odaberite stranu koja igra, prebrojite roem i upišite '
        'bodove jedne strane; aplikacija izračuna ostalo, prepoznaje nat i prati tko dijeli.',
    'Dodirnite bilo koje dijeljenje u povijesti da ga ispravite ili izbrišete, a ↶ da poništite zadnje.',
  ]),
];

const _ar = [
  RulesSection('اللاعبون والأوراق', [
    'تُلعب كلافرياس بأربعة لاعبين في فريقين من لاعبَين، ويجلس الشريكان متقابلين، بـ32 ورقة، من السبعة إلى الإكَّة '
        'في كل نوع. ويأخذ كل لاعب ثماني أوراق.',
    'الطرف الذي يختار الحكم هو الطرف اللاعب؛ ويحاول الطرف الآخر أن يوقفه. وتختار الطاولات الحكم بطرق مختلفة: '
        'بالدور، أو بورقة مكشوفة، أو بإلزام اللاعب الأول باختياره.',
  ]),
  RulesSection('قيمة الأوراق', [
    'الأكلة الأخيرة تضيف 10، فتساوي أوراق الجولة 162 نقطة. ويُسمّى الولد من الحكم «ياس»، والتسعة من الحكم «نِل».',
  ], tableHeader: ['الورقة', 'الحكم', 'نوع آخر'], table: [
    ['الولد', '20', '2'],
    ['التسعة', '14', '0'],
    ['الإكَّة', '11', '11'],
    ['العشرة', '10', '10'],
    ['الشايب', '4', '4'],
    ['البنت', '3', '3'],
    ['الثمانية، السبعة', '0', '0'],
  ]),
  RulesSection('قواعد أمستردام وروتردام', [
    'هناك طريقتان رئيسيتان للعب. وفي كلتيهما يجب على اللاعب أن يلعب من النوع نفسه، وإن لم يستطع فعليه أن يقطع '
        'بالحكم، وأن يعلو على حكم لُعب قبله إن أمكن.',
    'في قواعد روتردام يجب على اللاعب أن يقطع حتى لو كان شريكه رابحًا للأكلة. وفي قواعد أمستردام لا يلزم ذلك: اللاعب '
        'الذي يربح شريكه الأكلة يستطيع أن يلعب أي ورقة.',
    'يتّبع التطبيق قواعد أمستردام. والفرق في اللعب وحده، فتُحسب النتيجة بالطريقة نفسها في الحالتين.',
  ]),
  RulesSection('الروم', [
    'يُحسب الروم داخل الأكلات: الطرف الذي يربح أكلة يسجّل الروم الموجود بين أوراقها الأربع. وتُحسب المتتاليات '
        'بالترتيب سبعة، ثمانية، تسعة، عشرة، ولد، بنت، شايب، إكَّة، في نوع واحد. ويُضاف الروم إلى قيمة الجولة.',
  ], tableHeader: ['الروم', 'النقاط'], table: [
    ['ثلاث متتالية', '20'],
    ['أربع متتالية', '50'],
    ['أربع إكَك أو شياب أو بنات أو عشرات', '100'],
    ['أربعة أولاد', '200'],
    ['ستوك — الشايب والبنت من الحكم', '20'],
  ]),
  RulesSection('البِت', [
    'الطرف الذي يأخذ الأكلات الثماني كلها يحقق البِت ويسجّل 100 زيادة على نقاط الأوراق الـ162.',
  ]),
  RulesSection('النات', [
    'على الطرف اللاعب أن يجمع أكثر من خصومه، مع الروم. وإن لم يفعل، يصبح نات: يأخذ الخصوم نقاط الأوراق الـ162 وكل '
        'روم الجولة، ومنه روم الطرف اللاعب، ولا يأخذ الطرف اللاعب شيئًا. والتعادل في النقاط يُعدّ نات أيضًا.',
  ]),
  RulesSection('الفوز', [
    'كثيرًا ما تُلعب اللعبة عددًا متفقًا عليه من الجولات، عادةً ست عشرة، ثم يفوز صاحب المجموع الأعلى؛ وتلعب طاولات '
        'كثيرة بدلًا من ذلك حتى 1500 نقطة. ويلعب التطبيق حتى 1500: يفوز أول طرف يبلغها، وإذا بلغها الطرفان في '
        'الجولة نفسها، تفوز النتيجة الأعلى.',
  ]),
  RulesSection('تسجيل النتيجة في التطبيق', [
    'بعد كل جولة اضغط «جولة جديدة»، واختر الطرف اللاعب، واحسب الروم، وأدخل نقاط أحد الطرفين؛ يحسب التطبيق الباقي، '
        'ويكشف النات، ويتابع من يوزّع.',
    'اضغط على أي جولة في السجل لتصحيحها أو حذفها، و↶ للتراجع عن الأخيرة.',
  ]),
];
