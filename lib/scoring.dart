import 'models.dart';

/// The score of a game, worked out from its deals.
class Tally {
  /// What each side earned in each deal, in the order the deals were played.
  final List<List<int>> earned;
  final List<int> totals;
  final int? winner;
  final int dealer;

  const Tally({required this.earned, required this.totals, required this.winner, required this.dealer});
}

/// What each side earns from a single deal.
List<int> scoreRound(Round r) {
  if (r.isBait) {
    final earned = [0, 0];
    earned[1 - r.dealer] = r.gv;
    return earned;
  }
  return [r.score[0], r.score[1]];
}

Tally tally(GameState game) {
  final earned = <List<int>>[];
  final totals = [0, 0];
  int? winner;

  for (final r in game.rounds) {
    final e = scoreRound(r);
    earned.add(e);
    totals[0] += e[0];
    totals[1] += e[1];
    if (totals[0] >= game.scoreLimit || totals[1] >= game.scoreLimit) {
      winner = totals[0] >= totals[1] ? 0 : 1;
      break;
    }
  }

  return Tally(
    earned: earned,
    totals: totals,
    winner: winner,
    dealer: (game.firstDealer + game.rounds.length) % 2,
  );
}
