/// The points in every deal before declarations: the cards plus the last trick.
const kBaseGV = 162;

/// A combination players can declare in a deal, which raises its value.
class DeclarationKind {
  final String id;
  final int value;
  /// How many of it one deal can have; a single one is simply declared or not.
  final int max;
  /// Its points stay with the side that declared it even when that side
  /// loses the deal.
  final bool staysWithHolder;

  const DeclarationKind(this.id, this.value, {this.max = 9, this.staysWithHolder = false});

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

  const Contract(this.id, {
    required this.cardPoints, this.doubled = false, this.hasDeclarations = true, this.belots = 1,
    required this.lowerRoundsUpFrom, required this.higherRoundsUpFrom,
  });

  /// How many of the declaration [k] the contract allows in one deal.
  int allows(DeclarationKind k) => k.id == 'valat'
      ? k.max
      : !hasDeclarations
          ? 0
          : k.id == 'belot'
              ? belots
              : k.max;

  static const suit = Contract('suit', cardPoints: 162, lowerRoundsUpFrom: 6, higherRoundsUpFrom: 7);
  static const noTrumps = Contract('noTrumps', cardPoints: 130, doubled: true, hasDeclarations: false,
      lowerRoundsUpFrom: 5, higherRoundsUpFrom: 5);
  static const allTrumps = Contract('allTrumps', cardPoints: 258, belots: 4,
      lowerRoundsUpFrom: 4, higherRoundsUpFrom: 5);

  static const all = [suit, noTrumps, allTrumps];

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
  /// Seven trumps in a row, declared, win the whole game at once.
  final bool hasDebercWin;
  /// Repeated bait and deals without a trick can cost a penalty.
  final bool hasPenalties;
  /// The contracts a deal can be played in, the first one by default; none
  /// when every deal is played the same way.
  final List<Contract> contracts;
  /// A contract can be doubled and redoubled, and the side with more points
  /// then takes the whole deal.
  final bool hasDoubling;
  /// How many can play.
  final List<int> playerCounts;
  /// The score can be shown as circles and sticks.
  final bool hasCirclesAndSticks;
  /// The table rules are set by the game, not chosen by the players: the
  /// dealer does not have to play, a tie hangs and the higher score wins.
  final bool hasFixedTableRules;
  /// A deal in which one side takes every trick does not end the game.
  final bool noWinByValat;

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
    this.playerCounts = const [2, 3, 4],
    this.hasCirclesAndSticks = true,
    this.hasFixedTableRules = false,
    this.noWinByValat = false,
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

  /// Every game an app can be built for.
  static const all = [deberc, belote, belot];

  /// The game with the [id], or Deberc when there is none.
  static GameRules of(String id) => all.firstWhere((g) => g.id == id, orElse: () => deberc);

  /// Whether a deal is scored by its contract, in game points.
  bool get hasContracts => contracts.isNotEmpty;


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
