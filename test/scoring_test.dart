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
      final t = tally(game([Round.redeal(dealer: 0)]));

      expect(t.totals, [0, 0]);
      expect(t.dealer, 1);
    });

    test('leaves held points waiting for the next deal that is won', () {
      final t = tally(game([
        tie,
        Round.redeal(dealer: 1),
        const Round(gv: 162, dealer: 0, taker: 1, score: [62, 100]),
      ]));

      expect(t.earned[1], [0, 0]);
      expect(t.earned[2], [62, 191]);
      expect(t.held, 0);
    });

    test('is neither bait nor a tie, and is remembered when saved', () {
      final r = Round.redeal(dealer: 1);

      expect(r.isBaited, isFalse);
      expect(r.isTie, isFalse);
      expect(Round.fromJson(r.toJson()).isRedeal, isTrue);
    });
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

  group('three players each for themselves', () {
    GameState three(List<Round> rounds, {int firstDealer = 0}) => GameState(
      teamNames: const ['A', 'B', 'C'], scoreLimit: 501, rounds: rounds,
      firstDealer: firstDealer, tieRule: TieRule.eachKeepsOwn, players: 3,
    );

    test('each keeps what they took when the trump-taker scores the most', () {
      final t = tally(three(const [Round(gv: 162, dealer: 0, taker: 1, score: [40, 82, 40])]));

      expect(t.totals, [40, 82, 40]);
    });

    test('a trump-taker who is outscored gives the whole deal to the best opponent', () {
      final t = tally(three(const [Round(gv: 162, dealer: 0, taker: 1, score: [30, 60, 72])]));

      expect(t.totals, [0, 0, 162]);
    });

    test('opponents level on the most share the bait', () {
      final t = tally(three(const [Round(gv: 162, dealer: 0, taker: 0, score: [42, 60, 60])]));

      expect(t.totals, [0, 81, 81]);
    });

    test('the deal and the first bid go round all three', () {
      const r = Round(gv: 162, dealer: 0, taker: 0, score: [100, 31, 31]);

      expect([for (var n = 0; n < 4; n++) tally(three(List.filled(n, r), firstDealer: 2)).dealer], [2, 0, 1, 2]);
      expect(three(const []).firstToBid(2), 0);
    });

    test('is remembered when the game is saved', () {
      final g = three(const []);

      expect(GameState.fromJson(g.toJson()).players, 3);
      expect(GameState.fromJson({...g.toJson()}..remove('players')).players, 4);
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
