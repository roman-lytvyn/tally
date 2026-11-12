import 'package:flutter_test/flutter_test.dart';

import 'package:deberc/models.dart';
import 'package:deberc/scoring.dart';

GameState game(List<Round> rounds, {
  int limit = 501, int firstDealer = 0, TieRule tieRule = TieRule.hanging,
  FinishRule finishRule = FinishRule.taker, Penalties penalties = const Penalties(),
}) => GameState(
  teamNames: const ['A', 'B'], scoreLimit: limit, rounds: rounds, firstDealer: firstDealer,
  tieRule: tieRule, finishRule: finishRule, penalties: penalties,
);

/// A deal side [taker] took the trump in and lost.
Round baited(int taker) => Round(gv: 162, dealer: 0, taker: taker, score: const [0, 0], isBait: true);

/// A deal side [taker] took the trump in and won, 100 to 62.
Round won(int taker) => Round(gv: 162, dealer: 0, taker: taker,
    score: taker == 0 ? const [100, 62] : const [62, 100]);

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
    });

    test('credits the winner what it lacks to reach the game score', () {
      final g = game(const [
        Round(gv: 162, dealer: 0, taker: 0, score: [150, 12]),
        Round(gv: 162, dealer: 1, taker: 0, score: [0, 0], deberc: 1),
      ]);
      final t = tally(g);

      expect(t.totals, [150, g.scoreLimit]);
      expect(t.earned.last, [0, g.scoreLimit - 12]);
      expect(t.changes.last, [0, g.scoreLimit - 12]);
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

    test('the side with the most points wins when the table plays it that way', () {
      final t = tally(game(const [
        Round(gv: 900, dealer: 0, taker: 0, score: [480, 420]),
        Round(gv: 162, dealer: 1, taker: 1, score: [62, 100]),
      ], tieRule: TieRule.eachKeepsOwn, finishRule: FinishRule.mostPoints));

      expect(t.totals, [542, 520]);
      expect(t.winner, 0);
    });

    test('play goes on on an equal score when the most points win', () {
      final t = tally(game(const [
        start,
        Round(gv: 162, dealer: 1, taker: 1, score: [81, 81]),
      ], tieRule: TieRule.eachKeepsOwn, finishRule: FinishRule.mostPoints));

      expect(t.totals, [531, 531]);
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

  group('bait penalty', () {
    /// The bait penalties of side 0, deal by deal.
    List<int> penalised(List<Round> rounds, Penalties p) =>
        [for (final d in tally(game(rounds, limit: 5001, penalties: p)).baitPenalties) d[0]];

    final fiveBaits = [for (var k = 0; k < 5; k++) baited(0)];

    test('costs nothing by default', () {
      final t = tally(game([baited(0), baited(0), baited(0)], limit: 5001));

      expect(t.totals, [0, 486]);
      expect(t.baits, [3, 0]);
    });

    test('can fall on the third bait only', () {
      expect(penalised(fiveBaits, const Penalties(bait: BaitPenalty.third)), [0, 0, 100, 0, 0]);
    });

    test('can fall on the third bait and every one after it', () {
      expect(penalised(fiveBaits, const Penalties(bait: BaitPenalty.thirdAndAfter)), [0, 0, 100, 100, 100]);
    });

    test('can fall on every third bait', () {
      final six = [...fiveBaits, baited(0)];
      expect(penalised(six, const Penalties(bait: BaitPenalty.everyThird)), [0, 0, 100, 0, 0, 100]);
    });

    test('can be 50 points and is taken off the score', () {
      final t = tally(game([baited(0), baited(0), baited(0)], limit: 5001,
          penalties: const Penalties(bait: BaitPenalty.third, baitPoints: 50)));

      expect(t.totals, [-50, 486]);
      expect(t.earned.last, [0, 162]);
    });

    test('counts baits over the game, with won deals in between', () {
      final rounds = [baited(0), won(0), baited(0), won(0), baited(0)];
      expect(penalised(rounds, const Penalties(bait: BaitPenalty.third)), [0, 0, 0, 0, 100]);
    });

    test('counts only baits in a row when the rules say so', () {
      const p = Penalties(bait: BaitPenalty.third, baitsInARow: true);
      // A won deal of the other side does not break the run.
      expect(penalised([baited(0), won(1), baited(0), won(0), baited(0)], p), [0, 0, 0, 0, 0]);
      expect(penalised([baited(0), won(1), baited(0), baited(0)], p), [0, 0, 0, 100]);
    });

    test('counts a tie the opponents take as bait', () {
      final t = tally(game([tie, tie, tie], limit: 5001, tieRule: TieRule.opponentsTakeAll,
          penalties: const Penalties(bait: BaitPenalty.third)));

      expect(t.baits, [0, 3]);
      expect(t.baitPenalties.last, [0, 100]);
    });
  });

  group('no tricks penalty', () {
    const skis = Round(gv: 162, dealer: 0, taker: 0, score: [162, 0]);

    test('costs nothing by default', () {
      expect(tally(game(const [skis])).totals, [162, 0]);
    });

    test('takes the chosen points off a side that scored nothing', () {
      final t = tally(game(const [skis], penalties: const Penalties(noTricksPoints: 50)));

      expect(t.noTricksPenalties, [[0, 50]]);
      expect(t.totals, [162, -50]);
    });

    test('leaves bait recorded without points alone', () {
      final t = tally(game([baited(0)], penalties: const Penalties(noTricksPoints: 100)));

      expect(t.noTricksPenalties, [[0, 0]]);
    });
  });

  group('belote', () {
    const rules = GameRules.belote;
    Declarations decl(Map<String, int> counts) => Declarations(rules, counts);
    GameState belote(List<Round> rounds) => GameState(
      rules: rules, teamNames: const ['A', 'B'], scoreLimit: 1000, rounds: rounds, firstDealer: 0,
    );

    test('a deal is worth its cards and declarations, a capot 252', () {
      expect(decl({'tierce': 1, 'belote': 1}).gv, 202);
      expect(decl({'capot': 1}).gv, 252);
      expect(decl({'jacks': 1, 'nines': 1, 'hundred': 1}).gv, 612);
      expect(rules.dealValues, containsAll([162, 182, 252, 362, 512]));
    });

    test('a lost contract gives the opponents everything but the taker\'s belote', () {
      final t = tally(belote([
        Round(gv: 202, dealer: 0, taker: 0, score: const [90, 112],
            declarations: decl({'tierce': 1, 'belote': 1}), keeper: 0),
      ]));

      expect(t.totals, [20, 182]);
    });

    test('the opponents\' belote is simply part of the deal they take', () {
      final t = tally(belote([
        Round(gv: 182, dealer: 0, taker: 0, score: const [0, 0], isBait: true,
            declarations: decl({'belote': 1}), keeper: 1),
      ]));

      expect(t.totals, [0, 182]);
    });

    test('on equal points the taker keeps its belote and the rest is held', () {
      final t = tally(belote([
        Round(gv: 182, dealer: 0, taker: 0, score: const [91, 91],
            declarations: decl({'belote': 1}), keeper: 0),
        Round(gv: 162, dealer: 1, taker: 1, score: const [62, 100]),
      ]));

      expect(t.earned.first, [20, 91]);
      expect(t.totals, [82, 262]);
    });

    test('remembers who held the belote', () {
      final r = Round(gv: 182, dealer: 0, taker: 0, score: const [100, 82],
          declarations: decl({'belote': 1}), keeper: 1);
      final back = Round.fromJson(r.toJson(), rules: rules);

      expect(back.keeper, 1);
      expect(back.keptPoints, 20);
    });

    test('has no Deberc win or penalties and plays to 501 or 1000', () {
      expect(rules.hasDebercWin, isFalse);
      expect(rules.hasPenalties, isFalse);
      expect(rules.scoreLimits, [500, 1000]);
      expect(GameRules.of('belote'), same(rules));
    });
  });

  group('belot', () {
    const rules = GameRules.belot;
    Declarations decl(Map<String, int> counts) => Declarations(rules, counts);
    GameState belot(List<Round> rounds) => GameState(
      rules: rules, teamNames: const ['A', 'B'], scoreLimit: 151, rounds: rounds, firstDealer: 0,
      dealerMustPlay: false, tieRule: TieRule.hanging, finishRule: FinishRule.mostPoints,
    );
    Round deal(String contract, List<int> score, {int taker = 0, int doubling = 1, Declarations? declarations}) =>
        Round(gv: score[0] + score[1], dealer: 0, taker: taker, score: score,
            contract: contract, doubling: doubling, declarations: declarations);

    test('a suit deal is worth 16, rounded by who scored more', () {
      expect(scoreRound(deal('suit', const [86, 76])), [8, 8]);
      expect(scoreRound(deal('suit', const [87, 75])), [9, 7]);
    });

    test('an all-trumps deal and a doubled no-trumps deal are worth 26', () {
      expect(scoreRound(deal('allTrumps', const [134, 124])), [13, 13]);
      expect(scoreRound(deal('noTrumps', const [66, 64])), [13, 13]);
    });

    test('inside, the opponents take the whole deal', () {
      expect(scoreRound(deal('suit', const [70, 92])), [0, 16]);
      final bait = Round(gv: 162, dealer: 0, taker: 0, score: const [0, 0], isBait: true, contract: 'suit');
      expect(scoreRound(bait), [0, 16]);
    });

    test('on equal points the opponents keep theirs and the taker\'s hang', () {
      final t = tally(belot([
        deal('suit', const [106, 106], declarations: decl({'fifty': 1})),
        deal('suit', const [62, 100], taker: 1),
      ]));

      expect(t.earned, [[0, 10], [6, 21]]);
      expect(t.heldIn, [11, 0]);
      expect(t.totals, [6, 31]);
    });

    test('a doubled deal goes whole, multiplied, to the side with more points', () {
      expect(scoreRound(deal('suit', const [90, 72], doubling: 2)), [32, 0]);
      expect(scoreRound(deal('suit', const [70, 92], doubling: 4)), [0, 64]);
    });

    test('a doubled deal with equal points hangs whole', () {
      final t = tally(belot([deal('suit', const [81, 81], doubling: 2)]));

      expect(t.earned.single, [0, 0]);
      expect(t.held, 32);
    });

    test('a valat\'s 90 is added after a no-trumps deal is doubled', () {
      expect(scoreRound(deal('noTrumps', const [220, 0], declarations: decl({'valat': 1}))), [35, 0]);
    });

    test('a valat does not end the game, the deal after it does', () {
      final rounds = [
        deal('suit', const [150, 12]),
        deal('allTrumps', const [348, 0], doubling: 4, declarations: decl({'valat': 1})),
      ];
      final afterValat = tally(belot(rounds));
      expect(afterValat.totals, [155, 1]);
      expect(afterValat.winner, isNull);

      expect(tally(belot([...rounds, deal('suit', const [100, 62])])).winner, 0);
    });

    test('remembers the contract and the doubling', () {
      final back = Round.fromJson(deal('noTrumps', const [80, 50], doubling: 4).toJson(), rules: rules);

      expect(back.contract, 'noTrumps');
      expect(back.doubling, 4);
    });

    test('plays four in two teams to 151 with the table rules set', () {
      expect(rules.playerCounts, [4]);
      expect(rules.scoreLimits, [151]);
      expect(rules.hasFixedTableRules, isTrue);
      expect(Contract.noTrumps.allows(rules.declarations.firstWhere((k) => k.id == 'tierce')), 0);
      expect(Contract.allTrumps.allows(rules.declarations.firstWhere((k) => k.id == 'belot')), 4);
      expect(GameRules.of('belot'), same(rules));
    });
  });

  group('bela', () {
    const rules = GameRules.bela;
    Declarations decl(Map<String, int> counts) => Declarations(rules, counts);
    GameState bela(List<Round> rounds, {TieRule tieRule = TieRule.opponentsTakeAll}) => GameState(
      rules: rules, teamNames: const ['A', 'B'], scoreLimit: 1001, rounds: rounds, firstDealer: 0,
      tieRule: tieRule, finishRule: FinishRule.mostPoints,
    );

    test('a deal is worth its cards and declarations, a štiglja 252', () {
      expect(decl({'tierce': 1, 'bella': 1}).gv, 202);
      expect(decl({'stiglja': 1}).gv, 252);
      expect(decl({'jacks': 1, 'nines': 1}).gv, 512);
      expect(rules.dealValues, containsAll([162, 182, 252, 362, 512]));
    });

    test('a fall gives the opponents the whole deal with the bela', () {
      final t = tally(bela([
        Round(gv: 202, dealer: 0, taker: 0, score: const [100, 102],
            declarations: decl({'tierce': 1, 'bella': 1})),
      ]));

      expect(t.totals, [0, 202]);
    });

    test('on equal points the side that took the trump falls', () {
      final t = tally(bela([Round(gv: 162, dealer: 0, taker: 0, score: const [81, 81])]));

      expect(t.totals, [0, 162]);
      expect(t.held, 0);
    });

    test('a belot wins the game at once', () {
      final t = tally(bela([
        Round(gv: 162, dealer: 0, taker: 0, score: const [150, 12]),
        Round(gv: 162, dealer: 1, taker: 1, score: const [0, 0], deberc: 1),
      ]));

      expect(t.winner, 1);
    });

    test('plays to 1001 by default, in two or in two teams', () {
      expect(rules.defaultScoreLimit, 1001);
      expect(rules.scoreLimits, [501, 701, 1001]);
      expect(rules.playerCounts, [2, 4]);
      expect(rules.hasDebercWin, isTrue);
      expect(rules.hasPenalties, isFalse);
      expect(rules.tieFallsByDefault, isTrue);
      expect(GameRules.of('bela'), same(rules));
    });
  });

  group('klaverjas', () {
    const rules = GameRules.klaverjas;
    Declarations decl(Map<String, int> counts) => Declarations(rules, counts);
    GameState klaverjas(List<Round> rounds) => GameState(
      rules: rules, teamNames: const ['A', 'B'], scoreLimit: 1500, rounds: rounds, firstDealer: 0,
      tieRule: TieRule.opponentsTakeAll, finishRule: FinishRule.mostPoints,
    );

    test('a deal is worth its cards and roem, a pit 100 more', () {
      expect(decl({'tierce': 1, 'stuk': 1}).gv, 202);
      expect(decl({'pit': 1}).gv, 262);
      expect(decl({'jacks': 1, 'fifty': 1}).gv, 412);
      expect(rules.dealValues, containsAll([162, 182, 212, 262, 362]));
      expect(rules.dealValues.last, 162 + rules.maxDeclared);
    });

    test('nat gives the opponents the cards and all the roem', () {
      final t = tally(klaverjas([
        Round(gv: 212, dealer: 0, taker: 1, score: const [110, 102],
            declarations: decl({'fifty': 1})),
      ]));

      expect(t.totals, [212, 0]);
    });

    test('equal points are nat for the playing side', () {
      final t = tally(klaverjas([Round(gv: 162, dealer: 0, taker: 1, score: const [81, 81])]));

      expect(t.totals, [162, 0]);
      expect(t.held, 0);
    });

    test('each side keeps its points when the playing side scores more', () {
      final t = tally(klaverjas([Round(gv: 182, dealer: 0, taker: 1, score: const [60, 122])]));

      expect(t.totals, [60, 122]);
    });

    test('plays to 1500 in two teams of two', () {
      expect(rules.defaultScoreLimit, 1500);
      expect(rules.scoreLimits, [1500]);
      expect(rules.playerCounts, [4]);
      expect(rules.hasDebercWin, isFalse);
      expect(rules.hasPenalties, isFalse);
      expect(rules.tieFallsByDefault, isTrue);
      expect(GameRules.of('klaverjas'), same(rules));
    });
  });

  group('coinche', () {
    const rules = GameRules.coinche;
    Declarations decl(Map<String, int> counts) => Declarations(rules, counts);
    Round deal(int bid, List<int> score, {int doubling = 1, Declarations? declarations, int? keeper}) => Round(
      gv: declarations?.gv ?? 162, dealer: 1, taker: 0, score: score, bid: bid, doubling: doubling,
      declarations: declarations, keeper: keeper,
    );
    GameState coinche(List<Round> rounds) => GameState(
      rules: rules, teamNames: const ['A', 'B'], scoreLimit: 2000, rounds: rounds, firstDealer: 1,
      tieRule: TieRule.hanging, finishRule: FinishRule.mostPoints,
    );

    test('a made bid scores the points made plus the bid, rounded to tens', () {
      final r = deal(100, const [112, 50]);

      expect(r.isBaited, isFalse);
      expect(r.isTie, isFalse);
      expect(scoreRound(r), [210, 50]);
      expect(scoreRound(deal(80, const [85, 77])), [170, 80]);
    });

    test('a bid made exactly is made, and equal points are no tie', () {
      expect(scoreRound(deal(80, const [81, 81])), [160, 80]);
      expect(deal(80, const [81, 81]).isTie, isFalse);
    });

    test('a failed bid gives the opponents 160 plus the bid', () {
      final r = deal(120, const [100, 62]);

      expect(r.isBaited, isTrue);
      expect(scoreRound(r), [0, 280]);
    });

    test('a coinche doubles only the bid, and the belote stays with its holder', () {
      final r = deal(100, const [90, 92], doubling: 2, declarations: decl({'belote': 1}), keeper: 0);

      expect(scoreRound(r), [20, 360]);
      expect(scoreRound(deal(80, const [82, 80], doubling: 4)), [400, 80]);
    });

    test('a capot counts its tricks as 250 and is made only by taking them all', () {
      expect(scoreRound(deal(kCapot, const [162, 0])), [500, 0]);
      expect(scoreRound(deal(kCapot, const [182, 0], declarations: decl({'belote': 1}), keeper: 0)), [520, 0]);
      expect(scoreRound(deal(kCapot, const [150, 12])), [0, 410]);
    });

    test('a bid recorded as lost without points goes to the opponents', () {
      final r = Round(gv: 162, dealer: 1, taker: 0, score: const [0, 0], isBait: true, bid: 110);

      expect(scoreRound(r), [0, 270]);
    });

    test('keeps the bid of a saved deal', () {
      final back = Round.fromJson(deal(130, const [140, 22], doubling: 2).toJson(), rules: rules);

      expect(back.bid, 130);
      expect(back.doubling, 2);
      expect(Round.fromJson(deal(130, const [140, 22]).toJson()).bid, isNull);
    });

    test('the first side past 2000 wins', () {
      final t = tally(coinche([
        for (var i = 0; i < 3; i++) deal(kCapot, const [162, 0]),
        deal(160, const [162, 0]),
        deal(80, const [82, 80]),
        deal(80, const [82, 80]),
      ]));

      expect(t.totals, [1980 + 160, 160]);
      expect(t.winner, 0);
    });

    test('plays to 2000 in two teams of two, every deal for a bid', () {
      expect(rules.defaultScoreLimit, 2000);
      expect(rules.scoreLimits, [1000, 1500, 2000, 3000]);
      expect(rules.playerCounts, [4]);
      expect(rules.hasBids, isTrue);
      expect(rules.bids.first, 80);
      expect(rules.bids.last, kCapot);
      expect(rules.hasDoubling, isTrue);
      expect(rules.hasContracts, isFalse);
      expect(rules.hasDebercWin, isFalse);
      expect(rules.hasPenalties, isFalse);
      expect(GameRules.of('coinche'), same(rules));
    });
  });

  group('baloot', () {
    const rules = GameRules.baloot;
    Declarations decl(Map<String, int> counts) => Declarations(rules, counts);
    Round deal(String contract, List<int> score, {int doubling = 1, Map<String, int> declared = const {},
        int? keeper}) {
      final d = decl(declared);
      return Round(
        gv: Contract.of(contract)!.cardPoints + d.value, dealer: 1, taker: 0, score: score,
        contract: contract, doubling: doubling, declarations: d, keeper: keeper,
      );
    }
    GameState baloot(List<Round> rounds) => GameState(
      rules: rules, teamNames: const ['A', 'B'], scoreLimit: 152, rounds: rounds, firstDealer: 1,
      tieRule: TieRule.hanging, finishRule: FinishRule.mostPoints,
    );

    test('the opponents count a Hokm deal and the buyer gets the rest of 16', () {
      final r = deal('hokm', const [100, 62]);

      expect(r.isBaited, isFalse);
      expect(r.isTie, isFalse);
      expect(scoreRound(r), [10, 6]);
      expect(scoreRound(deal('hokm', const [96, 66])), [9, 7]);
    });

    test('a Sun deal is worth 26, and a five is counted as it is', () {
      expect(scoreRound(deal('sun', const [80, 50])), [16, 10]);
      expect(scoreRound(deal('sun', const [66, 64])), [14, 12]);
    });

    test('a buyer with fewer game points loses the whole deal', () {
      final r = deal('hokm', const [60, 102]);

      expect(r.isBaited, isTrue);
      expect(scoreRound(r), [0, 16]);
      expect(scoreRound(deal('sun', const [50, 80], declared: {'sira': 1})), [0, 30]);
    });

    test('equal game points are decided by the last digit of the counting side', () {
      // Hokm: 2 to 5 for the counting side, 1 for the buyer, otherwise the buyer.
      expect(scoreRound(deal('hokm', const [80, 82])), [0, 16]);
      expect(scoreRound(deal('hokm', const [81, 81])), [8, 8]);
      expect(scoreRound(deal('hokm', const [85, 77])), [8, 8]);
      // Sun: a five goes to the buyer.
      expect(scoreRound(deal('sun', const [65, 65])), [13, 13]);
      expect(scoreRound(deal('sun', const [64, 66])), [0, 26]);
    });

    test('projects add to the deal, and the baloot always stays with its holder', () {
      expect(scoreRound(deal('hokm', const [120, 62], declared: {'sira': 1})), [12, 6]);
      expect(scoreRound(deal('sun', const [100, 50], declared: {'sira': 1})), [20, 10]);
      expect(scoreRound(deal('hokm', const [120, 62], declared: {'baloot': 1}, keeper: 0)), [12, 6]);
      expect(scoreRound(deal('hokm', const [60, 122], declared: {'baloot': 1}, keeper: 1)), [0, 18]);
    });

    test('a doubled deal goes whole to its winner, projects doubled', () {
      expect(scoreRound(deal('hokm', const [100, 62], doubling: 2)), [32, 0]);
      expect(scoreRound(deal('hokm', const [100, 62], doubling: 3)), [48, 0]);
      expect(scoreRound(deal('hokm', const [100, 62], doubling: 4)), [64, 0]);
      expect(scoreRound(deal('hokm', const [60, 102], doubling: 2)), [0, 32]);
      expect(scoreRound(deal('sun', const [80, 50], doubling: 2)), [52, 0]);
      expect(scoreRound(deal('hokm', const [120, 62], doubling: 2, declared: {'sira': 1, 'baloot': 1}, keeper: 1)),
          [36, 2]);
    });

    test('a kaboot is worth 25 in Hokm and 44 in Sun', () {
      expect(scoreRound(deal('hokm', const [252, 0], declared: {'valat': 1})), [25, 0]);
      expect(scoreRound(deal('sun', const [240, 0], declared: {'valat': 1, 'sira': 1})), [48, 0]);
      expect(scoreRound(deal('hokm', const [0, 252], declared: {'valat': 1})), [0, 25]);
      expect(scoreRound(deal('hokm', const [252, 0], doubling: 2, declared: {'valat': 1})), [50, 0]);
    });

    test('the four hundred is a Sun project and the baloot a Hokm one', () {
      final fourHundred = rules.declarations.firstWhere((k) => k.id == 'fourHundred');
      final baloot = rules.declarations.firstWhere((k) => k.id == 'baloot');

      expect(Contract.sun.allows(fourHundred), 1);
      expect(Contract.hokm.allows(fourHundred), 0);
      expect(Contract.hokm.allows(baloot), 1);
      expect(Contract.sun.allows(baloot), 0);
      expect(scoreRound(deal('sun', const [230, 100], declared: {'fourHundred': 1})), [26 + 40 - 20, 20]);
    });

    test('a gahwa wins the match', () {
      final t = tally(baloot([
        deal('hokm', const [60, 102]),
        deal('hokm', const [100, 62], doubling: kGahwa),
      ]));

      expect(t.totals, [64, 16]);
      expect(t.winner, 0);
    });

    test('keeps a three and a gahwa of a saved deal', () {
      for (final d in const [3, kGahwa]) {
        expect(Round.fromJson(deal('hokm', const [100, 62], doubling: d).toJson(), rules: rules).doubling, d);
      }
    });

    test('the first side past 152 wins, and equal totals play on', () {
      final win = tally(baloot([for (var i = 0; i < 10; i++) deal('hokm', const [162, 0])]));
      expect(win.winner, 0);
      expect(win.totals[0], 160);
      final even = tally(baloot([
        for (var i = 0; i < 5; i++) ...[deal('sun', const [130, 0]), deal('sun', const [0, 130])],
        deal('hokm', const [81, 81]),
      ]));
      expect(even.totals, [138, 138]);
      expect(even.winner, isNull);
    });

    test('plays to 152 in two teams of two, every deal Hokm or Sun', () {
      expect(rules.defaultScoreLimit, 152);
      expect(rules.playerCounts, [4]);
      expect(rules.contracts, [Contract.hokm, Contract.sun]);
      expect(rules.hasDoubling, isTrue);
      expect(rules.hasBids, isFalse);
      expect(rules.hasDebercWin, isFalse);
      expect(rules.hasCirclesAndSticks, isFalse);
      expect(GameRules.of('baloot'), same(rules));
    });
  });
}
