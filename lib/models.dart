/// The points in every deal before declarations: the cards plus the last trick.
const kBaseGV = 162;

/// The targets a game can be played to: the short game, the usual and the long one.
const kScoreLimits = [301, 501, 1001];

/// How many can play: two or three each for themselves, or four in two teams.
const kPlayerCounts = [2, 3, 4];

/// How many sides keep a score when [players] play.
int sidesFor(int players) => players == 4 ? 2 : players;

/// The most a deal can be worth: the cards, every suit split into a hundred
/// and a tierce held by two players (4 × 120) and the bella.
const kMaxDealValue = kBaseGV + 4 * 120 + 20;

/// Every value a deal can have, lowest first: the cards plus any mix of
/// tierces and bella (20 each) and fifties (50 each), up to [kMaxDealValue].
final List<int> kDealValues = {
  for (var twenties = 0; twenties <= 10; twenties++)
    for (var fifties = 0; fifties <= 9; fifties++) kBaseGV + twenties * 20 + fifties * 50,
}.where((v) => v <= kMaxDealValue).toList()..sort();

/// The combinations declared in a deal, which raise its game value.
class Declarations {
  /// Three cards in a row of one suit, worth 20 each.
  final int tierces;
  /// Four cards in a row of one suit, worth 50 each.
  final int fifties;
  /// King and queen of trumps, worth 20; there is only one per deal.
  final bool bella;

  const Declarations({this.tierces = 0, this.fifties = 0, this.bella = false});

  int get value => tierces * 20 + fifties * 50 + (bella ? 20 : 0);
  int get gv => kBaseGV + value;

  Declarations copyWith({int? tierces, int? fifties, bool? bella}) => Declarations(
    tierces: tierces ?? this.tierces,
    fifties: fifties ?? this.fifties,
    bella: bella ?? this.bella,
  );

  /// Splits a game value saved without its declarations back into them.
  /// Bella and a tierce are worth the same, so both count as tierces.
  factory Declarations.fromGv(int gv) {
    final extra = gv - kBaseGV;
    for (var fifties = extra ~/ 50; fifties >= 0; fifties--) {
      final rest = extra - fifties * 50;
      if (rest % 20 == 0) return Declarations(tierces: rest ~/ 20, fifties: fifties);
    }
    return const Declarations();
  }

  Map<String, dynamic> toJson() => {'tierces': tierces, 'fifties': fifties, 'bella': bella};

  factory Declarations.fromJson(Map<String, dynamic> j) => Declarations(
    tierces: j['tierces'] ?? 0, fifties: j['fifties'] ?? 0, bella: j['bella'] ?? false,
  );
}

/// What happens to the points of a tied deal ("eggs"), where the side that
/// took the trump scored exactly as much as its opponents.
enum TieRule {
  /// The opponents keep their half; the trump-taker's half is held and goes
  /// to whoever wins the next deal.
  hanging,
  /// A tie counts as a loss for the trump-taker: the opponents get it all.
  opponentsTakeAll,
  /// Each side keeps the points it scored.
  eachKeepsOwn,
}

/// Who wins when several sides pass the target in the same deal.
enum FinishRule {
  /// The side with the highest total wins.
  mostPoints,
  /// The side that took the trump in that deal wins.
  taker,
}

/// Which of a side's baits cost it a penalty on top of the lost deal.
enum BaitPenalty {
  /// Bait costs nothing more than the deal.
  none,
  /// Only the third bait.
  third,
  /// The third bait and every one after it.
  thirdAndAfter,
  /// Every third bait: the third, the sixth and so on.
  everyThird,
}

/// The sizes a penalty can have.
const kPenaltyPoints = [50, 100];

/// The penalties a game is played with; by default there are none.
class Penalties {
  final BaitPenalty bait;
  /// What a penalised bait costs.
  final int baitPoints;
  /// Baits count only in a row: a deal the side takes the trump in and does
  /// not lose starts its count again. Otherwise they count over the game.
  final bool baitsInARow;
  /// What a side loses for a deal in which it took no tricks ("skis"); 0
  /// when that costs nothing.
  final int noTricksPoints;

  const Penalties({
    this.bait = BaitPenalty.none, this.baitPoints = 100,
    this.baitsInARow = false, this.noTricksPoints = 0,
  });

  /// Whether a side's [count]-th bait is penalised.
  bool penalisesBait(int count) => switch (bait) {
    BaitPenalty.none          => false,
    BaitPenalty.third         => count == 3,
    BaitPenalty.thirdAndAfter => count >= 3,
    BaitPenalty.everyThird    => count > 0 && count % 3 == 0,
  };

  Penalties copyWith({BaitPenalty? bait, int? baitPoints, bool? baitsInARow, int? noTricksPoints}) => Penalties(
    bait: bait ?? this.bait,
    baitPoints: baitPoints ?? this.baitPoints,
    baitsInARow: baitsInARow ?? this.baitsInARow,
    noTricksPoints: noTricksPoints ?? this.noTricksPoints,
  );

  Map<String, dynamic> toJson() => {
    'bait': bait.name, 'baitPoints': baitPoints, 'baitsInARow': baitsInARow, 'noTricksPoints': noTricksPoints,
  };

  factory Penalties.fromJson(Map<String, dynamic> j) => Penalties(
    bait: BaitPenalty.values.asNameMap()[j['bait']] ?? BaitPenalty.none,
    baitPoints: kPenaltyPoints.contains(j['baitPoints']) ? j['baitPoints'] : 100,
    baitsInARow: j['baitsInARow'] ?? false,
    noTricksPoints: j['noTricksPoints'] == 0 || kPenaltyPoints.contains(j['noTricksPoints'])
        ? j['noTricksPoints'] : 0,
  );
}

/// One deal exactly as the players entered it; what each side earns from it
/// is worked out by the scoring rules, never stored.
class Round {
  final int gv;
  final int dealer;
  /// The side that took the trump and so has to win the deal.
  final int taker;
  final List<int> score;
  final bool isBait;
  final Declarations? _declarations;
  /// The side that declared a deberc — seven trumps in a row — and so won
  /// the whole game with this deal.
  final int? deberc;
  /// Everybody passed, so the cards were thrown in and nobody scored; the
  /// deal still passes to the next dealer.
  final bool isRedeal;

  const Round({
    required this.gv,
    required this.dealer,
    required this.taker,
    required this.score,
    this.isBait = false,
    Declarations? declarations,
    this.deberc,
    this.isRedeal = false,
  }) : _declarations = declarations;

  /// A thrown-in deal by [dealer] where nobody took the trump.
  Round.redeal({required this.dealer, int sides = 2})
      : gv = kBaseGV, taker = dealer, score = List.filled(sides, 0), isBait = false,
        _declarations = null, deberc = null, isRedeal = true;

  /// The sides playing against the trump-taker.
  Iterable<int> get opponents sync* {
    for (var i = 0; i < score.length; i++) {
      if (i != taker) yield i;
    }
  }

  int get _bestOpponentScore => opponents.map((i) => score[i]).reduce((a, b) => a > b ? a : b);

  /// The opponents who take the deal when the trump-taker loses it: the one
  /// who scored the most, or all who share the most.
  List<int> get baitTakers => [for (final i in opponents) if (score[i] == _bestOpponentScore) i];

  /// What was declared in the deal; for deals saved with only a game value
  /// it is worked back out of that value.
  Declarations get declarations => _declarations ?? Declarations.fromGv(gv);

  bool get isDeberc => deberc != null;

  /// Whether the deal was actually played out and scored.
  bool get isPlayed => !isDeberc && !isRedeal;

  /// The side that took the trump scored exactly as much as the best of its
  /// opponents.
  bool get isTie => isPlayed && !isBait && score[taker] == _bestOpponentScore;

  /// The side that took the trump scored less than an opponent, either by
  /// the points entered or because the deal was recorded straight as bait.
  bool get isBaited => isPlayed && (isBait || score[taker] < _bestOpponentScore);

  /// Whether side [i] took no tricks in the deal: its points were entered as
  /// none at all. Bait recorded without points tells nothing about the tricks.
  bool tookNoTricks(int i) => isPlayed && !isBait && score[i] == 0;

  Map<String, dynamic> toJson() => {
    'gv': gv, 'dealer': dealer, 'taker': taker, 'score': score, 'isBait': isBait,
    if (_declarations != null) 'declarations': _declarations.toJson(),
    if (deberc != null) 'deberc': deberc,
    if (isRedeal) 'isRedeal': true,
  };

  factory Round.fromJson(Map<String, dynamic> j) => Round(
    gv: j['gv'], dealer: j['dealer'],
    // Earlier versions always treated the dealing side as the one playing.
    taker: j['taker'] ?? j['dealer'],
    score: List<int>.from(j['score']),
    isBait: j['isBait'] ?? false,
    declarations: j['declarations'] == null
        ? null
        : Declarations.fromJson(j['declarations'] as Map<String, dynamic>),
    deberc: j['deberc'],
    isRedeal: j['isRedeal'] ?? false,
  );
}

class GameState {
  /// One name per side: a team when four play, a player otherwise.
  final List<String> teamNames;
  final int scoreLimit;
  final List<Round> rounds;
  final int firstDealer;
  /// When nobody else takes the trump the dealer has to play the deal.
  final bool dealerMustPlay;
  final TieRule tieRule;
  final FinishRule finishRule;
  /// 2 or 3 playing each for themselves, or 4 in two teams.
  final int players;
  final Penalties penalties;

  const GameState({
    required this.teamNames, required this.scoreLimit,
    required this.rounds, required this.firstDealer,
    this.dealerMustPlay = false,
    this.tieRule = TieRule.hanging,
    this.finishRule = FinishRule.mostPoints,
    this.players = 4,
    this.penalties = const Penalties(),
  });

  int get sides => sidesFor(players);

  Map<String, dynamic> toJson() => {
    'screen': 'game',
    'teamNames': teamNames,
    'scoreLimit': scoreLimit,
    'rounds': rounds.map((r) => r.toJson()).toList(),
    'firstDealer': firstDealer,
    'dealerMustPlay': dealerMustPlay,
    'tieRule': tieRule.name,
    'finishRule': finishRule.name,
    'players': players,
    'penalties': penalties.toJson(),
  };

  factory GameState.fromJson(Map<String, dynamic> j) {
    final rounds = (j['rounds'] as List).map((r) => Round.fromJson(r as Map<String, dynamic>)).toList();
    return GameState(
      teamNames: List<String>.from(j['teamNames']),
      scoreLimit: j['scoreLimit'],
      rounds: rounds,
      // Games saved before the first dealer was stored keep the current
      // dealer instead; the deal alternates, so the first one follows from it.
      firstDealer: j['firstDealer'] ?? ((j['dealer'] as int) + rounds.length) % 2,
      dealerMustPlay: j['dealerMustPlay'] ?? false,
      // Games saved before the rule was chosen kept each side's own points.
      tieRule: TieRule.values.asNameMap()[j['tieRule']] ?? TieRule.eachKeepsOwn,
      // Games saved before the rule was chosen let the trump-taker win.
      finishRule: FinishRule.values.asNameMap()[j['finishRule']] ?? FinishRule.taker,
      players: j['players'] ?? 4,
      // Games saved before penalties were chosen play without them.
      penalties: j['penalties'] == null
          ? const Penalties()
          : Penalties.fromJson(j['penalties'] as Map<String, dynamic>),
    );
  }

  /// The side with the first right to the trump: the player to the dealer's left.
  int firstToBid(int dealer) => (dealer + 1) % sides;
}
