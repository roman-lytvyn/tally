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

  const Tally({
    required this.earned, required this.totals, required this.winner,
    required this.dealer, this.held = 0,
  });
}

/// What each side earns from a single deal, before any held points.
List<int> scoreRound(Round r, {TieRule tieRule = TieRule.eachKeepsOwn}) {
  // A deberc decides the game on its own and a thrown-in deal is not played;
  // neither adds any points.
  if (!r.isPlayed) return List.filled(r.score.length, 0);
  if (r.isBaited || (r.isTie && tieRule == TieRule.opponentsTakeAll)) {
    // The deal goes to the opponent who scored the most; opponents level on
    // the most share it.
    final earned = List.filled(r.score.length, 0);
    final takers = r.baitTakers;
    for (final i in takers) {
      earned[i] = r.gv ~/ takers.length;
    }
    return earned;
  }
  if (r.isTie && tieRule == TieRule.hanging) {
    final earned = [...r.score];
    earned[r.taker] = 0;
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
  final totals = List.filled(game.sides, 0);
  var held = 0;
  int? winner;

  for (final r in game.rounds) {
    final e = scoreRound(r, tieRule: game.tieRule);
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
    if (r.isTie && game.tieRule == TieRule.hanging) {
      held += r.score[r.taker];
    } else if (held > 0) {
      e[_best(e)] += held;
      held = 0;
    }
    earned.add(e);
    for (var i = 0; i < totals.length; i++) {
      totals[i] += e[i];
    }
    winner = _finisher(totals, game.scoreLimit, r.taker, game.finishRule);
    if (winner != null) break;
  }

  return Tally(
    earned: earned,
    totals: totals,
    winner: winner,
    dealer: (game.firstDealer + game.rounds.length) % game.sides,
    held: held,
  );
}
