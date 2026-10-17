const kGV = [162, 182, 202, 212, 222, 232, 252, 262, 282, 302, 332, 362, 412, 462, 512];

/// One deal exactly as the players entered it; what each side earns from it
/// is worked out by the scoring rules, never stored.
class Round {
  final int gv;
  final int dealer;
  final List<int> score;
  final bool isBait;

  const Round({
    required this.gv,
    required this.dealer,
    required this.score,
    this.isBait = false,
  });

  bool get isTie => !isBait && score[0] == score[1];

  Map<String, dynamic> toJson() => {
    'gv': gv, 'dealer': dealer, 'score': score, 'isBait': isBait,
  };

  factory Round.fromJson(Map<String, dynamic> j) => Round(
    gv: j['gv'], dealer: j['dealer'],
    score: List<int>.from(j['score']),
    isBait: j['isBait'] ?? false,
  );
}

class GameState {
  final List<String> teamNames;
  final int scoreLimit;
  final List<Round> rounds;
  final int firstDealer;

  const GameState({
    required this.teamNames, required this.scoreLimit,
    required this.rounds, required this.firstDealer,
  });

  Map<String, dynamic> toJson() => {
    'screen': 'game',
    'teamNames': teamNames,
    'scoreLimit': scoreLimit,
    'rounds': rounds.map((r) => r.toJson()).toList(),
    'firstDealer': firstDealer,
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
    );
  }
}
