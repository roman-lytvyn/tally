import 'models.dart';

/// The score of a game, worked out from its deals.
class Tally {
  /// What each side earned in each deal, in the order the deals were played.
  final List<List<int>> earned;
  final List<int> totals;
  final int? winner;
  final int dealer;
  /// Which of the dealing team's two players deals now, 0 for the one who
  /// dealt the team's first deal and 1 for the partner. The deal goes round
  /// the table, so each team's players take turns.
  final int dealerSeat;
  /// Points from tied deals still waiting for the winner of the next deal.
  final int held;

  const Tally({
    required this.earned, required this.totals, required this.winner,
    required this.dealer, this.dealerSeat = 0, this.held = 0,
  });
}

/// What each side earns from a single deal, before any held points.
List<int> scoreRound(Round r, {TieRule tieRule = TieRule.eachKeepsOwn}) {
  // A deberc decides the game on its own and a thrown-in deal is not played;
  // neither adds any points.
  if (!r.isPlayed) return [0, 0];
  if (r.isBaited || (r.isTie && tieRule == TieRule.opponentsTakeAll)) {
    final earned = [0, 0];
    earned[1 - r.taker] = r.gv;
    return earned;
  }
  if (r.isTie && tieRule == TieRule.hanging) {
    final earned = [r.score[0], r.score[1]];
    earned[r.taker] = 0;
    return earned;
  }
  return [r.score[0], r.score[1]];
}

/// The side that wins once the [totals] after a deal reach the [limit].
/// When several sides pass it together the one that took the trump in that
/// deal goes out first; otherwise the highest total wins, and on an equal
/// total nobody has won yet and play goes on.
int? _finisher(List<int> totals, int limit, int taker) {
  final passed = [for (var i = 0; i < totals.length; i++) if (totals[i] >= limit) i];
  if (passed.isEmpty) return null;
  if (passed.length == 1) return passed.single;
  if (passed.contains(taker)) return taker;
  passed.sort((a, b) => totals[b] - totals[a]);
  return totals[passed[0]] == totals[passed[1]] ? null : passed[0];
}

Tally tally(GameState game) {
  final earned = <List<int>>[];
  final totals = [0, 0];
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
      e[e[0] > e[1] ? 0 : 1] += held;
      held = 0;
    }
    earned.add(e);
    totals[0] += e[0];
    totals[1] += e[1];
    winner = _finisher(totals, game.scoreLimit, r.taker);
    if (winner != null) break;
  }

  return Tally(
    earned: earned,
    totals: totals,
    winner: winner,
    dealer: (game.firstDealer + game.rounds.length) % 2,
    dealerSeat: (game.rounds.length ~/ 2) % 2,
    held: held,
  );
}
