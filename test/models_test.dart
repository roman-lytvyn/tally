import 'package:flutter_test/flutter_test.dart';

import 'package:deberc/models.dart';

void main() {
  group('Round', () {
    const round = Round(gv: 182, dealer: 1, taker: 1, score: [90, 92], isBait: true);

    test('survives being saved and read back', () {
      final restored = Round.fromJson(round.toJson());

      expect(restored.gv, round.gv);
      expect(restored.dealer, round.dealer);
      expect(restored.score, round.score);
      expect(restored.isBait, round.isBait);
    });

    test('reads a deal saved by an earlier version of the app', () {
      final restored = Round.fromJson({
        'gv': 162, 'dealer': 0, 'score': [81, 81],
        'fell': false, 'yaytsia': true, 'isBait': false, 'earned': [81, 81],
      });

      expect(restored.score, [81, 81]);
      expect(restored.isTie, isTrue);
      // Earlier versions assumed the dealing side always played.
      expect(restored.taker, 0);
    });

    test('remembers which side took the trump', () {
      const r = Round(gv: 162, dealer: 0, taker: 1, score: [62, 100]);

      expect(Round.fromJson(r.toJson()).taker, 1);
    });
  });

  group('GameState', () {
    const game = GameState(
      teamNames: ['Наші', 'Інші'],
      scoreLimit: 501,
      rounds: [
        Round(gv: 162, dealer: 0, taker: 0, score: [100, 62]),
        Round(gv: 202, dealer: 1, taker: 1, score: [0, 0], isBait: true),
      ],
      firstDealer: 0,
      dealerMustPlay: true,
      tieRule: TieRule.opponentsTakeAll,
      finishRule: FinishRule.mostPoints,
    );

    test('survives being saved and read back', () {
      final restored = GameState.fromJson(game.toJson());

      expect(restored.dealerMustPlay, isTrue);
      expect(restored.tieRule, TieRule.opponentsTakeAll);
      expect(restored.finishRule, FinishRule.mostPoints);
      expect(restored.teamNames, game.teamNames);
      expect(restored.scoreLimit, game.scoreLimit);
      expect(restored.firstDealer, game.firstDealer);
      expect(restored.rounds, hasLength(game.rounds.length));
      expect(restored.rounds.last.isBait, isTrue);
    });

    test('works out the first dealer of a game saved by an earlier version', () {
      final restored = GameState.fromJson({
        'screen': 'game', 'teamNames': ['A', 'B'], 'scoreLimit': 501,
        'rounds': [
          {'gv': 162, 'dealer': 1, 'score': [100, 62], 'fell': false, 'yaytsia': false, 'isBait': false, 'earned': [100, 62]},
        ],
        'scores': [100, 62], 'dealer': 0,
      });

      expect(restored.firstDealer, 1);
      expect(restored.dealerMustPlay, isFalse);
      // Its ties keep being split the way they were when it was played.
      expect(restored.tieRule, TieRule.eachKeepsOwn);
      expect(restored.finishRule, FinishRule.taker);
    });

    test('gives the first right to the trump to the side left of the dealer', () {
      expect(game.firstToBid(0), 1);
      expect(game.firstToBid(1), 0);
    });

    test('is stored under the game screen, so a saved game reopens there', () {
      expect(game.toJson()['screen'], 'game');
    });
  });

  group('Declarations', () {
    test('a deal with nothing declared is worth the 162 points of the cards', () {
      expect(const Declarations().gv, 162);
    });

    test('add 20 for each tierce, 50 for each fifty and 20 for bella', () {
      expect(const Declarations(tierces: 2, fifties: 1, bella: true).gv, 162 + 40 + 50 + 20);
    });

    test('can reach any value players declare, not only a fixed list', () {
      expect(const Declarations(tierces: 1, fifties: 3).gv, 332);
      expect(const Declarations(fifties: 2, bella: true).gv, 282);
    });

    test('are worked back out of a deal saved with only its value', () {
      final d = Round.fromJson({'gv': 252, 'dealer': 0, 'score': [152, 100]}).declarations;

      expect(d.gv, 252);
      expect(d.fifties, 1);
      expect(d.tierces, 2);
    });

    test('are kept when a deal is saved and read back', () {
      const r = Round(gv: 232, dealer: 0, taker: 0, score: [132, 100],
          declarations: Declarations(fifties: 1, bella: true));
      final d = Round.fromJson(r.toJson()).declarations;

      expect(d.fifties, 1);
      expect(d.bella, isTrue);
      expect(d.tierces, 0);
    });
  });
}
