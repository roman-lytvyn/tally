const kGV = [162, 182, 202, 212, 222, 232, 252, 262, 282, 302, 332, 362, 412, 462, 512];

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

/// One deal exactly as the players entered it; what each side earns from it
/// is worked out by the scoring rules, never stored.
class Round {
  final int gv;
  final int dealer;
  /// The side that took the trump and so has to win the deal.
  final int taker;
  final List<int> score;
  final bool isBait;

  const Round({
    required this.gv,
    required this.dealer,
    required this.taker,
    required this.score,
    this.isBait = false,
  });

  bool get isTie => !isBait && score[0] == score[1];

  /// The side that took the trump scored less than its opponents, either by
  /// the points entered or because the deal was recorded straight as bait.
  bool get isBaited => isBait || score[taker] < score[1 - taker];

  Map<String, dynamic> toJson() => {
    'gv': gv, 'dealer': dealer, 'taker': taker, 'score': score, 'isBait': isBait,
  };

  factory Round.fromJson(Map<String, dynamic> j) => Round(
    gv: j['gv'], dealer: j['dealer'],
    // Earlier versions always treated the dealing side as the one playing.
    taker: j['taker'] ?? j['dealer'],
    score: List<int>.from(j['score']),
    isBait: j['isBait'] ?? false,
  );
}

class GameState {
  final List<String> teamNames;
  final int scoreLimit;
  final List<Round> rounds;
  final int firstDealer;
  /// When nobody else takes the trump the dealer has to play the deal.
  final bool dealerMustPlay;
  final TieRule tieRule;

  const GameState({
    required this.teamNames, required this.scoreLimit,
    required this.rounds, required this.firstDealer,
    this.dealerMustPlay = false,
    this.tieRule = TieRule.hanging,
  });

  Map<String, dynamic> toJson() => {
    'screen': 'game',
    'teamNames': teamNames,
    'scoreLimit': scoreLimit,
    'rounds': rounds.map((r) => r.toJson()).toList(),
    'firstDealer': firstDealer,
    'dealerMustPlay': dealerMustPlay,
    'tieRule': tieRule.name,
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
    );
  }

  /// The side with the first right to the trump: the player to the dealer's left.
  int firstToBid(int dealer) => 1 - dealer;
}
