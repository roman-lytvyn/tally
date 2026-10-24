import 'game_rules.dart';

export 'game_rules.dart';

/// How many can play: two or three each for themselves, or four in two teams.
const kPlayerCounts = [2, 3, 4];

/// How many sides keep a score when [players] play.
int sidesFor(int players) => players == 4 ? 2 : players;

/// The combinations declared in a deal, which raise its game value: how many
/// of each of the game's [DeclarationKind]s, by its id.
class Declarations {
  final GameRules rules;
  final Map<String, int> counts;

  const Declarations(this.rules, [this.counts = const {}]);

  /// How many of the declaration [id] there are.
  int operator [](String id) => counts[id] ?? 0;

  int get value => rules.declarations.fold(0, (sum, k) => sum + this[k.id] * k.value);
  int get gv => rules.cardPoints + value;

  Declarations withCount(String id, int n) =>
      Declarations(rules, {...counts, id: n}..removeWhere((_, v) => v == 0));

  /// Splits a game value saved without its declarations back into them, as
  /// many of the more valuable ones as fit. Single declarations are left
  /// out: one worth as much as a repeatable one counts as that one.
  factory Declarations.fromGv(int gv, GameRules rules) {
    final kinds = [for (final k in rules.declarations) if (!k.isSingle) k]
      ..sort((a, b) => b.value - a.value);
    Map<String, int>? split(int rest, int from) {
      if (rest == 0) return {};
      if (from == kinds.length) return null;
      final k = kinds[from];
      for (var n = rest ~/ k.value; n >= 0; n--) {
        final more = split(rest - n * k.value, from + 1);
        if (more != null) return {if (n > 0) k.id: n, ...more};
      }
      return null;
    }
    return Declarations(rules, split(gv - rules.cardPoints, 0) ?? const {});
  }

  Map<String, dynamic> toJson() => counts;

  factory Declarations.fromJson(Map<String, dynamic> j, GameRules rules) {
    // Earlier versions saved Deberc's tierces and fifties as counts and the
    // bella as a flag.
    if (j.containsKey('tierces') || j.containsKey('fifties') || j['bella'] is bool) {
      return Declarations(rules, {
        if ((j['tierces'] ?? 0) > 0) 'tierce': j['tierces'],
        if ((j['fifties'] ?? 0) > 0) 'fifty': j['fifties'],
        if (j['bella'] == true) 'bella': 1,
      });
    }
    return Declarations(rules, {
      for (final k in rules.declarations)
        if (j[k.id] is int && j[k.id] > 0) k.id: j[k.id] as int,
    });
  }
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
  /// What was declared in the deal, when it was recorded.
  final Declarations? declarations;
  /// The side that declared a deberc — seven trumps in a row — and so won
  /// the whole game with this deal.
  final int? deberc;
  /// Everybody passed, so the cards were thrown in and nobody scored; the
  /// deal still passes to the next dealer.
  final bool isRedeal;
  /// The side that declared what stays with its holder whatever happens to
  /// the deal, such as Belote's belote-rebelote.
  final int? keeper;
  /// The contract the deal was played in, in a game that has contracts.
  final String? contract;
  /// 1 for a plain contract, 2 when it was doubled and 4 when redoubled; in
  /// Baloot also 3, or a [kGahwa].
  final int doubling;
  /// What the side that won the bidding undertook to make, in a game with bids.
  final int? bid;

  const Round({
    required this.gv,
    required this.dealer,
    required this.taker,
    required this.score,
    this.isBait = false,
    this.declarations,
    this.deberc,
    this.isRedeal = false,
    this.keeper,
    this.contract,
    this.doubling = 1,
    this.bid,
  });

  /// A thrown-in deal by [dealer] where nobody took the trump.
  Round.redeal({required this.dealer, int sides = 2, this.gv = kBaseGV})
      : taker = dealer, score = List.filled(sides, 0), isBait = false,
        declarations = null, deberc = null, isRedeal = true, keeper = null, contract = null, doubling = 1,
        bid = null;

  /// One side took every trick.
  bool get isValat => (declarations?['valat'] ?? 0) > 0;

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

  /// What was declared in the deal under the [rules]; for a deal recorded
  /// with only its value it is worked back out of that value.
  Declarations declarationsIn(GameRules rules) => declarations ?? Declarations.fromGv(gv, rules);

  /// The points the [keeper] holds on to whoever wins the deal.
  int get keptPoints {
    final d = declarations;
    if (keeper == null || d == null) return 0;
    return d.rules.declarations.fold(0, (sum, k) => k.staysWithHolder ? sum + d[k.id] * k.value : sum);
  }

  /// The contract of a deal one side counts for both, as in Baloot.
  Contract? get _countedContract {
    final c = Contract.of(contract);
    return c != null && c.countedByOneSide ? c : null;
  }

  /// In a deal one side counts for both: the side that counts. The
  /// opponents of the buyer count, unless a double or a four puts the buyer
  /// to it.
  int get countingSide => doubling == 2 || doubling == 4 ? taker : opponents.first;

  /// The points of side [i] without what stays with its holder.
  int _ownPoints(int i) => score[i] - (keeper == i ? keptPoints : 0);

  /// The game points of everything declared in a deal one side counts for
  /// both, without a kaboot and what stays with its holder.
  int get countedProjects {
    final c = _countedContract!;
    return c.gamePoints(gv - c.cardPoints - keptPoints - (isValat ? 90 : 0));
  }

  /// What each side scored in game points in a deal one side counts for
  /// both, what stays with its holder left out: the counting side turns its
  /// points into game points and the other side gets the rest.
  List<int> get countedPoints {
    final c = _countedContract!;
    final counting = countingSide;
    final points = c.gamePoints(_ownPoints(counting));
    final total = c.dealPoints! + countedProjects;
    return [for (var i = 0; i < score.length; i++) i == counting ? points : total - points];
  }

  /// The side that wins a deal one side counts for both: the one with more
  /// game points, what stays with its holder included. On equal points the
  /// last digit of the counting side's points decides: in Hokm it wins on 2
  /// to 5 and the buyer on 1, in Sun it wins on 1 to 4 and the buyer on 0
  /// or 5; on any other digit the other side wins.
  int get countedWinner {
    final opponent = opponents.first;
    if (isBait) return opponent;
    if (isValat) return score[taker] >= score[opponent] ? taker : opponent;
    final c = _countedContract!;
    final points = countedPoints;
    int all(int i) => points[i] + (keeper == i ? keptPoints ~/ 10 : 0);
    if (all(taker) != all(opponent)) return all(taker) > all(opponent) ? taker : opponent;
    final counting = countingSide;
    final other = counting == taker ? opponent : taker;
    final digit = _ownPoints(counting) % 10;
    if (c.doubled) {
      if (digit == 0 || digit == 5) return taker;
      return digit <= 4 ? counting : other;
    }
    if (digit == 1) return taker;
    return digit >= 2 && digit <= 5 ? counting : other;
  }

  bool get isDeberc => deberc != null;

  /// Whether the deal was actually played out and scored.
  bool get isPlayed => !isDeberc && !isRedeal;

  /// The side that won the bidding made its bid: its points reached it, or
  /// for a capot it took every trick, leaving the opponents nothing.
  bool get madeBid => bid == kCapot ? _bestOpponentScore == 0 : score[taker] >= bid!;

  /// The side that took the trump scored exactly as much as the best of its
  /// opponents; a deal played for a bid is made or not, never tied.
  bool get isTie => isPlayed && !isBait && bid == null && _countedContract == null
      && score[taker] == _bestOpponentScore;

  /// The side that took the trump scored less than an opponent, or fell
  /// short of its bid, either by the points entered or because the deal was
  /// recorded straight as bait.
  bool get isBaited => isPlayed && (isBait || (bid != null
      ? !madeBid
      : _countedContract != null
          ? countedWinner != taker
          : score[taker] < _bestOpponentScore));

  /// Whether side [i] took no tricks in the deal: its points were entered as
  /// none at all. Bait recorded without points tells nothing about the tricks.
  bool tookNoTricks(int i) => isPlayed && !isBait && score[i] == 0;

  Map<String, dynamic> toJson() => {
    'gv': gv, 'dealer': dealer, 'taker': taker, 'score': score, 'isBait': isBait,
    if (declarations != null) 'declarations': declarations!.toJson(),
    if (deberc != null) 'deberc': deberc,
    if (isRedeal) 'isRedeal': true,
    if (keeper != null) 'keeper': keeper,
    if (contract != null) 'contract': contract,
    if (doubling != 1) 'doubling': doubling,
    if (bid != null) 'bid': bid,
  };

  factory Round.fromJson(Map<String, dynamic> j, {GameRules rules = GameRules.deberc}) => Round(
    gv: j['gv'], dealer: j['dealer'],
    // Earlier versions always treated the dealing side as the one playing.
    taker: j['taker'] ?? j['dealer'],
    score: List<int>.from(j['score']),
    isBait: j['isBait'] ?? false,
    declarations: j['declarations'] == null
        ? null
        : Declarations.fromJson(j['declarations'] as Map<String, dynamic>, rules),
    deberc: j['deberc'],
    isRedeal: j['isRedeal'] ?? false,
    keeper: j['keeper'],
    contract: j['contract'],
    doubling: const [1, 2, 3, 4, kGahwa].contains(j['doubling']) ? j['doubling'] : 1,
    bid: rules.bids.contains(j['bid']) ? j['bid'] : null,
  );
}

class GameState {
  final GameRules rules;
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
    this.rules = GameRules.deberc,
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
    'game': rules.id,
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

  factory GameState.fromJson(Map<String, dynamic> j, {GameRules rules = GameRules.deberc}) {
    final rounds = (j['rounds'] as List)
        .map((r) => Round.fromJson(r as Map<String, dynamic>, rules: rules)).toList();
    return GameState(
      rules: rules,
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
