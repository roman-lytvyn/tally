import 'package:flutter_test/flutter_test.dart';

import 'package:deberc/models.dart';
import 'package:deberc/scoring.dart';

GameState game(List<Round> rounds, {int limit = 501, int firstDealer = 0}) => GameState(
  teamNames: const ['A', 'B'], scoreLimit: limit, rounds: rounds, firstDealer: firstDealer,
);

void main() {
  test('a game with no deals has no score and the first dealer deals', () {
    final t = tally(game(const [], firstDealer: 1));

    expect(t.totals, [0, 0]);
    expect(t.winner, isNull);
    expect(t.dealer, 1);
  });

  test('adds up what each side earned', () {
    final t = tally(game(const [
      Round(gv: 162, dealer: 0, score: [100, 62]),
      Round(gv: 182, dealer: 1, score: [52, 130]),
    ]));

    expect(t.earned, [[100, 62], [52, 130]]);
    expect(t.totals, [152, 192]);
  });

  test('passes the deal to the other side after every deal', () {
    expect(tally(game(const [Round(gv: 162, dealer: 0, score: [100, 62])])).dealer, 1);
  });

  test('bait gives the whole deal to the opponents of the dealing side', () {
    final t = tally(game(const [Round(gv: 202, dealer: 0, score: [0, 0], isBait: true)]));

    expect(t.totals, [0, 202]);
  });

  test('ends the game once a side reaches the target', () {
    final t = tally(game(const [
      Round(gv: 512, dealer: 0, score: [400, 112]),
      Round(gv: 162, dealer: 1, score: [120, 42]),
    ]));

    expect(t.winner, 0);
  });

  test('a removed deal no longer counts', () {
    final rounds = [
      const Round(gv: 512, dealer: 0, score: [400, 112]),
      const Round(gv: 162, dealer: 1, score: [120, 42]),
    ]..removeLast();

    final t = tally(game(rounds));

    expect(t.totals, [400, 112]);
    expect(t.winner, isNull);
  });
}
