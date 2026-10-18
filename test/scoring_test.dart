import 'package:flutter_test/flutter_test.dart';

import 'package:deberc/models.dart';
import 'package:deberc/scoring.dart';

GameState game(List<Round> rounds, {
  int limit = 501, int firstDealer = 0, TieRule tieRule = TieRule.hanging,
}) => GameState(
  teamNames: const ['A', 'B'], scoreLimit: limit, rounds: rounds, firstDealer: firstDealer,
  tieRule: tieRule,
);

const tie = Round(gv: 182, dealer: 0, taker: 1, score: [91, 91]);

void main() {
  test('a game with no deals has no score and the first dealer deals', () {
    final t = tally(game(const [], firstDealer: 1));

    expect(t.totals, [0, 0]);
    expect(t.winner, isNull);
    expect(t.dealer, 1);
  });

  test('adds up what each side earned', () {
    final t = tally(game(const [
      Round(gv: 162, dealer: 0, taker: 0, score: [100, 62]),
      Round(gv: 182, dealer: 1, taker: 1, score: [52, 130]),
    ]));

    expect(t.earned, [[100, 62], [52, 130]]);
    expect(t.totals, [152, 192]);
  });

  test('passes the deal to the other side after every deal', () {
    expect(tally(game(const [Round(gv: 162, dealer: 0, taker: 0, score: [100, 62])])).dealer, 1);
  });

  test('bait gives the whole deal to the opponents of the side that took the trump', () {
    final t = tally(game(const [Round(gv: 202, dealer: 0, taker: 0, score: [0, 0], isBait: true)]));

    expect(t.totals, [0, 202]);
  });

  test('the side that took the trump and scored less is baited automatically', () {
    const r = Round(gv: 182, dealer: 0, taker: 1, score: [100, 82]);
    final t = tally(game(const [r]));

    expect(r.isBaited, isTrue);
    expect(t.totals, [182, 0]);
  });

  test('the side that took the trump and scored more keeps its points', () {
    const r = Round(gv: 182, dealer: 0, taker: 1, score: [82, 100]);
    final t = tally(game(const [r]));

    expect(r.isBaited, isFalse);
    expect(t.totals, [82, 100]);
  });

  test('bait goes to the dealing side when the other side took the trump', () {
    final t = tally(game(const [Round(gv: 202, dealer: 0, taker: 1, score: [0, 0], isBait: true)]));

    expect(t.totals, [202, 0]);
  });

  group('a tied deal', () {
    test('by default holds the trump-taker\'s points while the opponents keep theirs', () {
      final t = tally(game(const [tie]));

      expect(t.totals, [91, 0]);
      expect(t.held, 91);
    });

    test('hands the held points to whoever wins the next deal', () {
      final t = tally(game(const [tie, Round(gv: 162, dealer: 1, taker: 1, score: [62, 100])]));

      expect(t.earned.last, [62, 191]);
      expect(t.totals, [153, 191]);
      expect(t.held, 0);
    });

    test('hands the held points to the opponents when the next deal is bait', () {
      final t = tally(game(const [tie, Round(gv: 162, dealer: 1, taker: 0, score: [0, 0], isBait: true)]));

      expect(t.earned.last, [0, 253]);
    });

    test('keeps holding the points through several ties in a row', () {
      final t = tally(game(const [tie, tie]));

      expect(t.totals, [182, 0]);
      expect(t.held, 182);
    });

    test('can give the whole deal to the opponents instead', () {
      final t = tally(game(const [tie], tieRule: TieRule.opponentsTakeAll));

      expect(t.totals, [182, 0]);
      expect(t.held, 0);
    });

    test('can let each side keep its own points instead', () {
      final t = tally(game(const [tie], tieRule: TieRule.eachKeepsOwn));

      expect(t.totals, [91, 91]);
      expect(t.held, 0);
    });
  });

  test('ends the game once a side reaches the target', () {
    final t = tally(game(const [
      Round(gv: 512, dealer: 0, taker: 0, score: [400, 112]),
      Round(gv: 162, dealer: 1, taker: 1, score: [120, 42]),
    ]));

    expect(t.winner, 0);
  });

  group('a deberc', () {
    test('wins the game at once for the side that declared it, whatever the score', () {
      final t = tally(game(const [
        Round(gv: 162, dealer: 0, taker: 0, score: [150, 12]),
        Round(gv: 162, dealer: 1, taker: 0, score: [0, 0], deberc: 1),
      ]));

      expect(t.winner, 1);
      expect(t.totals, [150, 12]);
    });

    test('is neither bait nor a tie', () {
      const r = Round(gv: 162, dealer: 0, taker: 0, score: [0, 0], deberc: 0);

      expect(r.isBaited, isFalse);
      expect(r.isTie, isFalse);
    });

    test('is remembered when the game is saved', () {
      const r = Round(gv: 162, dealer: 0, taker: 0, score: [0, 0], deberc: 1);

      expect(Round.fromJson(r.toJson()).deberc, 1);
    });
  });

  group('a thrown-in deal', () {
    test('scores nothing but passes the deal on', () {
      final t = tally(game(const [Round.redeal(dealer: 0)]));

      expect(t.totals, [0, 0]);
      expect(t.dealer, 1);
    });

    test('leaves held points waiting for the next deal that is won', () {
      final t = tally(game(const [
        tie,
        Round.redeal(dealer: 1),
        Round(gv: 162, dealer: 0, taker: 1, score: [62, 100]),
      ]));

      expect(t.earned[1], [0, 0]);
      expect(t.earned[2], [62, 191]);
      expect(t.held, 0);
    });

    test('is neither bait nor a tie, and is remembered when saved', () {
      const r = Round.redeal(dealer: 1);

      expect(r.isBaited, isFalse);
      expect(r.isTie, isFalse);
      expect(Round.fromJson(r.toJson()).isRedeal, isTrue);
    });
  });

  test('the deal goes round the table, so each team\'s players take turns', () {
    const r = Round(gv: 162, dealer: 0, taker: 0, score: [100, 62]);
    expect([for (var n = 0; n < 5; n++) tally(game(List.filled(n, r))).dealerSeat], [0, 0, 1, 1, 0]);
  });

  group('when both sides pass the target in the same deal', () {
    const start = Round(gv: 900, dealer: 0, taker: 0, score: [450, 450]);

    test('the side that took the trump goes out, even with fewer points', () {
      final t = tally(game(const [
        Round(gv: 900, dealer: 0, taker: 0, score: [460, 440]),
        Round(gv: 162, dealer: 1, taker: 1, score: [62, 100]),
      ], tieRule: TieRule.eachKeepsOwn));

      expect(t.totals, [522, 540]);
      expect(t.winner, 1);
    });

    test('the side that took the trump goes out, even when it had more points before', () {
      final t = tally(game(const [
        Round(gv: 900, dealer: 0, taker: 0, score: [480, 420]),
        Round(gv: 162, dealer: 1, taker: 0, score: [81, 81]),
      ], tieRule: TieRule.eachKeepsOwn));

      expect(t.totals, [561, 501]);
      expect(t.winner, 0);
    });

    test('nobody wins while neither has reached the target', () {
      final t = tally(game(const [start], tieRule: TieRule.eachKeepsOwn));

      expect(t.winner, isNull);
    });
  });

  test('a removed deal no longer counts', () {
    final rounds = [
      const Round(gv: 512, dealer: 0, taker: 0, score: [400, 112]),
      const Round(gv: 162, dealer: 1, taker: 1, score: [120, 42]),
    ]..removeLast();

    final t = tally(game(rounds));

    expect(t.totals, [400, 112]);
    expect(t.winner, isNull);
  });
}
