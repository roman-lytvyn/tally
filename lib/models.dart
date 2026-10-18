/// The points in every deal before declarations: the cards plus the last trick.
const kBaseGV = 162;

/// The targets a game can be played to: the short game, the usual and the long one.
const kScoreLimits = [301, 501, 1001];

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
  const Round.redeal({required this.dealer})
      : gv = kBaseGV, taker = dealer, score = const [0, 0], isBait = false,
        _declarations = null, deberc = null, isRedeal = true;

  /// What was declared in the deal; for deals saved with only a game value
  /// it is worked back out of that value.
  Declarations get declarations => _declarations ?? Declarations.fromGv(gv);

  bool get isDeberc => deberc != null;

  /// Whether the deal was actually played out and scored.
  bool get isPlayed => !isDeberc && !isRedeal;

  bool get isTie => isPlayed && !isBait && score[0] == score[1];

  /// The side that took the trump scored less than its opponents, either by
  /// the points entered or because the deal was recorded straight as bait.
  bool get isBaited => isPlayed && (isBait || score[taker] < score[1 - taker]);

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
