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

  const GameRules({
    required this.id,
    this.cardPoints = kBaseGV,
    required this.declarations,
    required this.maxDeclared,
    required this.scoreLimits,
    required this.defaultScoreLimit,
    this.hasDebercWin = false,
    this.hasPenalties = false,
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
    scoreLimits: [501, 1000],
    defaultScoreLimit: 1000,
  );

  /// Every game an app can be built for.
  static const all = [deberc, belote];

  /// The game with the [id], or Deberc when there is none.
  static GameRules of(String id) => all.firstWhere((g) => g.id == id, orElse: () => deberc);

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
