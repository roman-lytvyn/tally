import 'models.dart';

/// The score of a game, worked out from its deals.
class Tally {
  /// What each side earned in each deal, in the order the deals were played.
  final List<List<int>> earned;
  final List<int> totals;
  final int? winner;
  final int dealer;
  /// Points from tied deals still waiting for the winner of the next deal.
  final int held;
  /// What each side lost in each deal for a penalised bait.
  final List<List<int>> baitPenalties;
  /// What each side lost in each deal for taking no tricks in it.
  final List<List<int>> noTricksPenalties;
  /// The points each deal left hanging for the winner of the next one.
  final List<int> heldIn;
  /// The baits each side has counted so far: over the game, or the ones in a
  /// row when only those count.
  final List<int> baits;

  const Tally({
    required this.earned, required this.totals, required this.winner,
    required this.dealer, this.held = 0,
    this.baitPenalties = const [], this.noTricksPenalties = const [], this.heldIn = const [],
    this.baits = const [],
  });
}

/// The tens of [points], rounded up once the last digit reaches [upFrom].
int _tens(int points, int upFrom) => points ~/ 10 + (points % 10 >= upFrom ? 1 : 0);

/// The card points of side [i] in a deal played in contract [c], doubled
/// when the contract says so; a valat's 90 is never doubled.
int _counted(Round r, Contract c, int i) {
  final points = r.score[i];
  if (!c.doubled) return points;
  final other = i == r.taker ? r.opponents.first : r.taker;
  final valat = r.isValat && points > r.score[other] && points >= 90 ? 90 : 0;
  return (points - valat) * 2 + valat;
}

/// What a deal played in a contract earns each side in game points, and how
/// much of it hangs for the winner of the next deal.
///
/// Each side's card points become tens, the side with fewer points and the
/// side with more rounding up from the digits the contract sets; on equal
/// points the opponents round as the side with more. The contract side keeps
/// its points only when it scored more than its opponents: when it scored
/// less, the opponents take the whole deal, and on equal points its own hang.
/// A doubled or redoubled deal goes whole, multiplied, to the side with more
/// points, or hangs whole on equal points.
({List<int> earned, int held}) contractScore(Round r) {
  final c = Contract.of(r.contract)!;
  final earned = List.filled(r.score.length, 0);
  if (!r.isPlayed) return (earned: earned, held: 0);
  final taker = r.taker;
  final opponent = r.opponents.first;
  if (r.isBait) {
    // Recorded without points: the opponents take what the deal is worth.
    final valat = r.isValat ? 90 : 0;
    final counted = c.doubled ? (r.gv - valat) * 2 + valat : r.gv;
    earned[opponent] = (counted + 5) ~/ 10 * r.doubling;
    return (earned: earned, held: 0);
  }
  final ahead = r.score[taker] > r.score[opponent];
  final points = List.filled(r.score.length, 0)
    ..[taker] = _tens(_counted(r, c, taker), ahead ? c.higherRoundsUpFrom : c.lowerRoundsUpFrom)
    ..[opponent] = _tens(_counted(r, c, opponent), ahead ? c.lowerRoundsUpFrom : c.higherRoundsUpFrom);
  final whole = (points[taker] + points[opponent]) * r.doubling;
  if (r.isTie) {
    if (r.doubling > 1) return (earned: earned, held: whole);
    earned[opponent] = points[opponent];
    return (earned: earned, held: points[taker]);
  }
  if (r.doubling > 1 || r.isBaited) {
    earned[ahead ? taker : opponent] = whole;
    return (earned: earned, held: 0);
  }
  return (earned: points, held: 0);
}

/// What each side earns from a single deal, before any held points.
List<int> scoreRound(Round r, {TieRule tieRule = TieRule.eachKeepsOwn}) {
  if (r.contract != null) return contractScore(r).earned;
  // A deberc decides the game on its own and a thrown-in deal is not played;
  // neither adds any points.
  if (!r.isPlayed) return List.filled(r.score.length, 0);
  if (r.isBaited || (r.isTie && tieRule == TieRule.opponentsTakeAll)) {
    // The deal goes to the opponent who scored the most; opponents level on
    // the most share it. What stays with its holder is not part of it.
    final earned = List.filled(r.score.length, 0);
    final kept = r.keptPoints;
    if (kept > 0) earned[r.keeper!] = kept;
    final takers = r.baitTakers;
    for (final i in takers) {
      earned[i] += (r.gv - kept) ~/ takers.length;
    }
    return earned;
  }
  if (r.isTie && tieRule == TieRule.hanging) {
    final earned = [...r.score];
    earned[r.taker] = r.keeper == r.taker ? r.keptPoints : 0;
    return earned;
  }
  return [...r.score];
}

/// The side that wins once the [totals] after a deal reach the [limit].
/// When several sides pass it together and the [rule] says so, the one that
/// took the trump in that deal goes out first; otherwise the highest total
/// wins, and on an equal total nobody has won yet and play goes on.
int? _finisher(List<int> totals, int limit, int taker, FinishRule rule) {
  final passed = [for (var i = 0; i < totals.length; i++) if (totals[i] >= limit) i];
  if (passed.isEmpty) return null;
  if (passed.length == 1) return passed.single;
  if (rule == FinishRule.taker && passed.contains(taker)) return taker;
  passed.sort((a, b) => totals[b] - totals[a]);
  return totals[passed[0]] == totals[passed[1]] ? null : passed[0];
}

int _best(List<int> values) {
  var best = 0;
  for (var i = 1; i < values.length; i++) {
    if (values[i] > values[best]) best = i;
  }
  return best;
}

Tally tally(GameState game) {
  final earned = <List<int>>[];
  final baitPenalties = <List<int>>[];
  final noTricksPenalties = <List<int>>[];
  final heldIn = <int>[];
  final totals = List.filled(game.sides, 0);
  final baits = List.filled(game.sides, 0);
  final penalties = game.penalties;
  var held = 0;
  int? winner;

  for (final r in game.rounds) {
    final e = scoreRound(r, tieRule: game.tieRule);
    final baitPenalty = List.filled(game.sides, 0);
    final noTricksPenalty = List.filled(game.sides, 0);
    baitPenalties.add(baitPenalty);
    noTricksPenalties.add(noTricksPenalty);
    heldIn.add(0);
    if (r.isDeberc) {
      earned.add(e);
      winner = r.deberc;
      break;
    }
    // Held points wait for a deal that is actually won.
    if (r.isRedeal) {
      earned.add(e);
      continue;
    }
    // A tie the opponents take counts as bait here as well.
    if (r.isBaited || (r.isTie && game.tieRule == TieRule.opponentsTakeAll)) {
      baits[r.taker]++;
      if (penalties.penalisesBait(baits[r.taker])) baitPenalty[r.taker] = penalties.baitPoints;
    } else if (penalties.baitsInARow) {
      baits[r.taker] = 0;
    }
    if (penalties.noTricksPoints > 0) {
      for (var i = 0; i < game.sides; i++) {
        if (r.tookNoTricks(i)) noTricksPenalty[i] = penalties.noTricksPoints;
      }
    }
    if (r.isTie && game.tieRule == TieRule.hanging) {
      final hung = r.contract != null ? contractScore(r).held : r.score[r.taker] - e[r.taker];
      heldIn[heldIn.length - 1] = hung;
      held += hung;
    } else if (held > 0) {
      e[_best(e)] += held;
      held = 0;
    }
    earned.add(e);
    for (var i = 0; i < totals.length; i++) {
      totals[i] += e[i] - baitPenalty[i] - noTricksPenalty[i];
    }
    // Where a valat cannot win the game, the deal after it decides.
    if (game.rules.noWinByValat && r.isValat) continue;
    winner = _finisher(totals, game.scoreLimit, r.taker, game.finishRule);
    if (winner != null) break;
  }

  return Tally(
    earned: earned,
    totals: totals,
    winner: winner,
    dealer: (game.firstDealer + game.rounds.length) % game.sides,
    held: held,
    baitPenalties: baitPenalties,
    noTricksPenalties: noTricksPenalties,
    heldIn: heldIn,
    baits: baits,
  );
}
