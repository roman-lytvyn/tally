import 'package:flutter_test/flutter_test.dart';

import 'package:deberc/models.dart';

void main() {
  group('Round', () {
    const round = Round(
      gv: 162,
      dealer: 1,
      score: [90, 72],
      fell: true,
      yaytsia: false,
      isBait: true,
      earned: [0, 162],
    );

    test('survives being saved and read back', () {
      final restored = Round.fromJson(round.toJson());

      expect(restored.gv, round.gv);
      expect(restored.dealer, round.dealer);
      expect(restored.score, round.score);
      expect(restored.fell, round.fell);
      expect(restored.yaytsia, round.yaytsia);
      expect(restored.isBait, round.isBait);
      expect(restored.earned, round.earned);
    });
  });

  group('GameState', () {
    const game = GameState(
      teamNames: ['Наші', 'Інші'],
      scoreLimit: 501,
      rounds: [
        Round(gv: 162, dealer: 0, score: [100, 62], fell: false, yaytsia: false, isBait: false, earned: [100, 62]),
        Round(gv: 202, dealer: 1, score: [0, 202], fell: true, yaytsia: true, isBait: false, earned: [0, 202]),
      ],
      scores: [100, 264],
      dealer: 0,
    );

    test('survives being saved and read back', () {
      final restored = GameState.fromJson(game.toJson());

      expect(restored.teamNames, game.teamNames);
      expect(restored.scoreLimit, game.scoreLimit);
      expect(restored.scores, game.scores);
      expect(restored.dealer, game.dealer);
      expect(restored.rounds, hasLength(game.rounds.length));
      expect(restored.rounds.last.earned, game.rounds.last.earned);
    });

    test('is stored under the game screen, so a saved game reopens there', () {
      expect(game.toJson()['screen'], 'game');
    });
  });

  group('game values', () {
    test('start at the lowest deal and only ever grow', () {
      expect(kGV.first, 162);
      for (var i = 1; i < kGV.length; i++) {
        expect(kGV[i], greaterThan(kGV[i - 1]), reason: 'value at $i');
      }
    });

    test('are all even, as every deal in this game is', () {
      expect(kGV.where((value) => value.isOdd), isEmpty);
    });
  });
}
