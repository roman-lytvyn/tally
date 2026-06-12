const kGV = [162, 182, 202, 212, 222, 232, 252, 262, 282, 302, 332, 362, 412, 462, 512];

class Round {
  final int gv;
  final int dealer;
  final List<int> score;
  final bool fell;
  final bool yaytsia;
  final bool isBait;
  final List<int> earned;

  const Round({
    required this.gv,
    required this.dealer,
    required this.score,
    required this.fell,
    required this.yaytsia,
    required this.isBait,
    required this.earned,
  });

  Map<String, dynamic> toJson() => {
    'gv': gv, 'dealer': dealer, 'score': score,
    'fell': fell, 'yaytsia': yaytsia, 'isBait': isBait, 'earned': earned,
  };

  factory Round.fromJson(Map<String, dynamic> j) => Round(
    gv: j['gv'], dealer: j['dealer'],
    score: List<int>.from(j['score']),
    fell: j['fell'], yaytsia: j['yaytsia'], isBait: j['isBait'],
    earned: List<int>.from(j['earned']),
  );
}

class GameState {
  final List<String> teamNames;
  final int scoreLimit;
  final List<Round> rounds;
  final List<int> scores;
  final int dealer;

  const GameState({
    required this.teamNames, required this.scoreLimit,
    required this.rounds, required this.scores, required this.dealer,
  });

  Map<String, dynamic> toJson() => {
    'screen': 'game',
    'teamNames': teamNames,
    'scoreLimit': scoreLimit,
    'rounds': rounds.map((r) => r.toJson()).toList(),
    'scores': scores,
    'dealer': dealer,
  };

  factory GameState.fromJson(Map<String, dynamic> j) => GameState(
    teamNames: List<String>.from(j['teamNames']),
    scoreLimit: j['scoreLimit'],
    rounds: (j['rounds'] as List).map((r) => Round.fromJson(r as Map<String, dynamic>)).toList(),
    scores: List<int>.from(j['scores']),
    dealer: j['dealer'],
  );
}
