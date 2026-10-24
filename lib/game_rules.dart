/// The points in every deal before declarations: the cards plus the last trick.
const kBaseGV = 162;

/// A bid to take every trick, the highest a deal can be played for; the
/// tricks of a capot count this much instead of the card points.
const kCapot = 250;

/// A doubling beyond four, as in Baloot's gahwa: the deal stakes the whole
/// match, and the side that wins it wins the match.
const kGahwa = 5;

/// A combination players can declare in a deal, which raises its value.
class DeclarationKind {
  final String id;
  final int value;
  /// How many of it one deal can have; a single one is simply declared or not.
  final int max;
  /// Its points stay with the side that declared it even when that side
  /// loses the deal.
  final bool staysWithHolder;
  /// The one contract it can be declared in, when the others do not allow it.
  final String? only;

  const DeclarationKind(this.id, this.value, {this.max = 9, this.staysWithHolder = false, this.only});

  bool get isSingle => max == 1;
}

/// The kind of deal a contract sets in a game that has several, such as a
/// suit, no trumps or all trumps in Bulgarian Belot, and how its card points
/// turn into game points.
class Contract {
  final String id;
  /// What the cards and the last trick are worth together.
  final int cardPoints;
  /// The card points count twice before they are turned into game points.
  final bool doubled;
  /// Whether combinations can be declared, other than taking every trick.
  final bool hasDeclarations;
  /// How many belots one deal can have.
  final int belots;
  /// The last digit from which the side with fewer points, and the side
  /// with more, round their tens up.
  final int lowerRoundsUpFrom;
  final int higherRoundsUpFrom;
  /// The game points the cards are worth together where one side counts
  /// them for both, as in Baloot; null where each side counts its own.
  final int? dealPoints;
  /// What taking every trick is worth in game points where one side counts
  /// for both, instead of the cards.
  final int valatPoints;
  /// The doublings the contract can be played with: 2 for a double, 4 for a
  /// redouble, and in Baloot 3 and a [kGahwa] as well.
  final List<int> doublings;

  const Contract(this.id, {
    required this.cardPoints, this.doubled = false, this.hasDeclarations = true, this.belots = 1,
    required this.lowerRoundsUpFrom, required this.higherRoundsUpFrom,
    this.dealPoints, this.valatPoints = 0, this.doublings = const [2, 4],
  });

  /// Whether one side counts the cards for both, as in Baloot.
  bool get countedByOneSide => dealPoints != null;

  /// How many of the declaration [k] the contract allows in one deal.
  int allows(DeclarationKind k) => k.only != null && k.only != id
      ? 0
      : k.id == 'valat'
      ? k.max
      : !hasDeclarations
          ? 0
          : k.id == 'belot'
              ? belots
              : k.max;

  /// The game points of [points] counted by one side: rounded to tens, a
  /// five rounding down; a doubled contract counts twice as many, and there
  /// a five counts as it is.
  int gamePoints(int points) {
    final tens = points ~/ 10 + (points % 10 >= higherRoundsUpFrom ? 1 : 0);
    if (!doubled) return tens;
    return points % 10 == 5 ? points ~/ 5 : tens * 2;
  }

  static const suit = Contract('suit', cardPoints: 162, lowerRoundsUpFrom: 6, higherRoundsUpFrom: 7);
  static const noTrumps = Contract('noTrumps', cardPoints: 130, doubled: true, hasDeclarations: false,
      lowerRoundsUpFrom: 5, higherRoundsUpFrom: 5);
  static const allTrumps = Contract('allTrumps', cardPoints: 258, belots: 4,
      lowerRoundsUpFrom: 4, higherRoundsUpFrom: 5);

  /// Baloot's trump deal, 16 game points, which can be doubled up to a gahwa.
  static const hokm = Contract('hokm', cardPoints: 162, dealPoints: 16, valatPoints: 25,
      lowerRoundsUpFrom: 6, higherRoundsUpFrom: 6, doublings: [2, 3, 4, kGahwa]);
  /// Baloot's deal without trumps, 26 game points, which can only be doubled.
  static const sun = Contract('sun', cardPoints: 130, doubled: true, dealPoints: 26, valatPoints: 44,
      lowerRoundsUpFrom: 5, higherRoundsUpFrom: 5, doublings: [2]);

  static const all = [suit, noTrumps, allTrumps, hokm, sun];

  /// The contract with the [id]; none for a deal of a game without contracts.
  static Contract? of(String? id) {
    for (final c in all) {
      if (c.id == id) return c;
    }
    return null;
  }
}

/// What a game of the family is made of: what a deal is worth, what can be
/// declared, what it is played to and which of its own features it has.
class GameRules {
  final String id;
  /// What the cards and the last trick are worth together.
  final int cardPoints;
  /// The combinations that can be declared, in the order they are offered.
  final List<DeclarationKind> declarations;
  /// The most the declarations of one deal can add up to.
  final int maxDeclared;
  /// The targets a game can be played to, lowest first.
  final List<int> scoreLimits;
  final int defaultScoreLimit;
  /// A hand declared at the start of a deal wins the whole game at once:
  /// seven trumps in a row in Deberc, all eight cards of a suit in Bela.
  final bool hasDebercWin;
  /// Repeated bait and deals without a trick can cost a penalty.
  final bool hasPenalties;
  /// The contracts a deal can be played in, the first one by default; none
  /// when every deal is played the same way.
  final List<Contract> contracts;
  /// A contract can be doubled and redoubled, and the side with more points
  /// then takes the whole deal; in a game with bids only the bid is
  /// multiplied.
  final bool hasDoubling;
  /// The bids a deal can be played for, lowest first, the last of them a
  /// [kCapot]; none when a deal is not played for a bid.
  final List<int> bids;
  /// How many can play.
  final List<int> playerCounts;
  /// The score can be shown as circles and sticks.
  final bool hasCirclesAndSticks;
  /// The table rules are set by the game, not chosen by the players: the
  /// dealer does not have to play, a tie hangs and the higher score wins.
  final bool hasFixedTableRules;
  /// A deal in which one side takes every trick does not end the game.
  final bool noWinByValat;
  /// A tied deal counts as lost for the side that took the trump unless the
  /// players choose otherwise.
  final bool tieFallsByDefault;

  const GameRules({
    required this.id,
    this.cardPoints = kBaseGV,
    required this.declarations,
    required this.maxDeclared,
    required this.scoreLimits,
    required this.defaultScoreLimit,
    this.hasDebercWin = false,
    this.hasPenalties = false,
    this.contracts = const [],
    this.hasDoubling = false,
    this.bids = const [],
    this.playerCounts = const [2, 3, 4],
    this.hasCirclesAndSticks = true,
    this.hasFixedTableRules = false,
    this.noWinByValat = false,
    this.tieFallsByDefault = false,
  });

  static const deberc = GameRules(
    id: 'deberc',
    declarations: [
      DeclarationKind('tierce', 20),
      DeclarationKind('fifty', 50),
      DeclarationKind('bella', 20, max: 1),
    ],
    // Every suit split into a hundred and a tierce held by two players
    // (4 × 120) and the bella.
    maxDeclared: 4 * 120 + 20,
    // The short game, the usual and the long one.
    scoreLimits: [301, 501, 1001],
    defaultScoreLimit: 1001,
    hasDebercWin: true,
    hasPenalties: true,
  );

  /// Belote classique, as played in France.
  static const belote = GameRules(
    id: 'belote',
    declarations: [
      DeclarationKind('tierce', 20),
      DeclarationKind('fifty', 50),
      // A quinte, or four aces, tens, kings or queens.
      DeclarationKind('hundred', 100),
      DeclarationKind('belote', 20, max: 1, staysWithHolder: true),
      DeclarationKind('jacks', 200, max: 1),
      DeclarationKind('nines', 150, max: 1),
      // Taking every trick makes the cards worth 252 instead of 162.
      DeclarationKind('capot', 90, max: 1),
    ],
    // A capot, both high carrés, two hundreds and the belote.
    maxDeclared: 90 + 200 + 150 + 2 * 100 + 20,
    scoreLimits: [500, 1000],
    defaultScoreLimit: 1000,
  );

  /// Bulgarian Belot, scored in game points: a suit deal is worth 16, a
  /// no-trumps or all-trumps deal 26.
  static const belot = GameRules(
    id: 'belot',
    declarations: [
      DeclarationKind('tierce', 20),
      DeclarationKind('fifty', 50),
      // A quinte, or four aces, tens, kings or queens.
      DeclarationKind('hundred', 100),
      DeclarationKind('belot', 20, max: 4),
      DeclarationKind('jacks', 200, max: 1),
      DeclarationKind('nines', 150, max: 1),
      DeclarationKind('valat', 90, max: 1),
    ],
    maxDeclared: 90 + 200 + 150 + 2 * 100 + 4 * 20,
    scoreLimits: [151],
    defaultScoreLimit: 151,
    contracts: [Contract.suit, Contract.noTrumps, Contract.allTrumps],
    hasDoubling: true,
    playerCounts: [4],
    hasCirclesAndSticks: false,
    hasFixedTableRules: true,
    noWinByValat: true,
  );

  /// Bela, as played in Croatia and its neighbours.
  static const bela = GameRules(
    id: 'bela',
    declarations: [
      DeclarationKind('tierce', 20),
      DeclarationKind('fifty', 50),
      // A quinte or longer, or four aces, tens, kings or queens.
      DeclarationKind('hundred', 100),
      DeclarationKind('bella', 20, max: 1),
      DeclarationKind('jacks', 200, max: 1),
      DeclarationKind('nines', 150, max: 1),
      // Taking every trick makes the cards worth 252 instead of 162.
      DeclarationKind('stiglja', 90, max: 1),
    ],
    // A štiglja, both high carrés, two hundreds and the bela.
    maxDeclared: 90 + 200 + 150 + 2 * 100 + 20,
    scoreLimits: [501, 701, 1001],
    defaultScoreLimit: 1001,
    // A belot, all eight cards of one suit, wins the game.
    hasDebercWin: true,
    playerCounts: [2, 4],
    hasCirclesAndSticks: false,
    tieFallsByDefault: true,
  );

  /// Klaverjas, as played in the Netherlands, by the Amsterdam rules. The
  /// Rotterdam rules only add the duty to trump over a partner who is winning
  /// the trick, so both are scored alike.
  static const klaverjas = GameRules(
    id: 'klaverjas',
    // Roem is counted in the tricks, so a run is at most four cards long.
    declarations: [
      DeclarationKind('tierce', 20),
      DeclarationKind('fifty', 50),
      // Four aces, kings, queens or tens.
      DeclarationKind('hundred', 100),
      DeclarationKind('stuk', 20, max: 1),
      DeclarationKind('jacks', 200, max: 1),
      // Taking every trick adds 100 to the 162 of the cards.
      DeclarationKind('pit', 100, max: 1),
    ],
    // A pit, four jacks, three more fours of a kind, two runs of four and the stuk.
    maxDeclared: 100 + 200 + 3 * 100 + 2 * 50 + 20,
    scoreLimits: [1500],
    defaultScoreLimit: 1500,
    playerCounts: [4],
    hasCirclesAndSticks: false,
    // The playing side has to score more than the opponents, so a tie is nat.
    tieFallsByDefault: true,
  );

  /// Coinche, or Belote contrée, as played in France: every deal is played
  /// for a bid, and points are counted as made, the bid added on top.
  static const coinche = GameRules(
    id: 'coinche',
    declarations: [
      DeclarationKind('tierce', 20),
      DeclarationKind('fifty', 50),
      // A quinte, or four aces, tens, kings or queens.
      DeclarationKind('hundred', 100),
      DeclarationKind('belote', 20, max: 1, staysWithHolder: true),
      DeclarationKind('jacks', 200, max: 1),
      DeclarationKind('nines', 150, max: 1),
    ],
    // Both high carrés, two hundreds and the belote.
    maxDeclared: 200 + 150 + 2 * 100 + 20,
    scoreLimits: [1000, 1500, 2000, 3000],
    defaultScoreLimit: 2000,
    hasDoubling: true,
    bids: [80, 90, 100, 110, 120, 130, 140, 150, 160, kCapot],
    playerCounts: [4],
    hasCirclesAndSticks: false,
    hasFixedTableRules: true,
  );

  /// Baloot, as played in Saudi Arabia and the Gulf, counted in game points:
  /// a Hokm deal is worth 16 and a Sun deal 26, one side counting for both.
  static const baloot = GameRules(
    id: 'baloot',
    declarations: [
      DeclarationKind('sira', 20),
      DeclarationKind('fifty', 50),
      // A run of five, or four of a kind: aces in Hokm, kings, queens, jacks
      // or tens in either.
      DeclarationKind('hundred', 100),
      // Four aces in Sun.
      DeclarationKind('fourHundred', 200, max: 1, only: 'sun'),
      DeclarationKind('baloot', 20, max: 1, staysWithHolder: true, only: 'hokm'),
      // Kaboot: one side takes every trick.
      DeclarationKind('valat', 90, max: 1),
    ],
    // A kaboot, the four hundred, two hundreds and two fifties.
    maxDeclared: 90 + 200 + 2 * 100 + 2 * 50,
    scoreLimits: [152],
    defaultScoreLimit: 152,
    contracts: [Contract.hokm, Contract.sun],
    hasDoubling: true,
    playerCounts: [4],
    hasCirclesAndSticks: false,
    hasFixedTableRules: true,
  );

  /// Every game an app can be built for.
  static const all = [deberc, belote, belot, bela, klaverjas, coinche, baloot];

  /// The game with the [id], or Deberc when there is none.
  static GameRules of(String id) => all.firstWhere((g) => g.id == id, orElse: () => deberc);

  /// Whether a deal is scored by its contract, in game points.
  bool get hasContracts => contracts.isNotEmpty;

  /// Whether every deal is played for a bid.
  bool get hasBids => bids.isNotEmpty;


  /// The most a deal can be worth.
  int get maxDealValue => cardPoints + maxDeclared;

  /// Every value a deal can have, lowest first: the cards plus any mix of
  /// declarations, up to [maxDealValue].
  List<int> get dealValues {
    var sums = {0};
    for (final k in declarations) {
      sums = {
        for (final s in sums)
          for (var n = 0; n <= k.max && s + n * k.value <= maxDeclared; n++) s + n * k.value,
      };
    }
    return [for (final s in sums) cardPoints + s]..sort();
  }
}
