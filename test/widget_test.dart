import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:deberc/main.dart';
import 'package:deberc/l10n.dart';
import 'package:deberc/models.dart';

void main() {
  const uk = AppStrings('uk');

  setUp(() {
    // The app reads the saved game and settings on startup; without this the
    // plugin has no platform to talk to and the app never finishes loading.
    SharedPreferences.setMockInitialValues({'deberc_lang': 'uk'});
  });

  /// The app is locked to portrait on a phone, while the default test surface is
  /// a landscape desktop one the screens were never laid out for.
  Future<void> openApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DebertsApp());
    await tester.pumpAndSettle();
  }

  /// Taps a piece of text, scrolling it into view first.
  Future<void> tapText(WidgetTester tester, String text) async {
    // A list builds only the rows near the screen, so scroll until it exists.
    if (find.text(text).evaluate().isEmpty) {
      await tester.scrollUntilVisible(find.text(text), 200, scrollable: find.byType(Scrollable).first);
    }
    await tester.ensureVisible(find.text(text));
    await tester.pumpAndSettle();
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  /// Starts a new game and opens the panel for its first deal.
  Future<void> openRound(WidgetTester tester) async {
    await openApp(tester);
    await tapText(tester, uk.newGame);
    await tapText(tester, uk.newRound);
  }

  testWidgets('keeps the highlighted score as far from the colon as from the row edges', (tester) async {
    await openRound(tester);

    final us = tester.getRect(find.byKey(const ValueKey('score.0')));
    final them = tester.getRect(find.byKey(const ValueKey('score.1')));
    final row = tester.getRect(find.ancestor(of: find.byKey(const ValueKey('score.0')), matching: find.byType(DecoratedBox)).first);
    final colon = tester.getRect(find.descendant(
        of: find.ancestor(of: find.byKey(const ValueKey('score.0')), matching: find.byType(Row)).first,
        matching: find.text(':')));

    final edge = us.left - row.left;
    expect(edge, greaterThan(0));
    expect(colon.left - us.right, edge);
    expect(them.left - colon.right, edge);
    expect(row.right - them.right, edge);
  });

  testWidgets('opens on the setup screen', (tester) async {
    await openApp(tester);

    // Section labels are rendered upper-cased by the screen itself.
    expect(find.text(uk.appTitle), findsOneWidget);
    expect(find.text(uk.teams.toUpperCase()), findsOneWidget);
    expect(find.text(uk.playTo.toUpperCase()), findsOneWidget);
    expect(find.text(uk.newGame), findsOneWidget);
  });

  testWidgets('names the app for the system', (tester) async {
    await openApp(tester);

    expect(tester.widget<Title>(find.byType(Title).last).title, uk.appTitle);
  });

  group('language', () {
    const en = AppStrings('en');

    testWidgets('follows a Ukrainian device until one is chosen', (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.platformDispatcher.localeTestValue = const Locale('uk', 'UA');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      await openApp(tester);

      expect(find.text(uk.newGame), findsOneWidget);
    });

    testWidgets('is English on any other device', (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.platformDispatcher.localeTestValue = const Locale('de', 'DE');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      await openApp(tester);

      expect(find.text(en.newGame), findsOneWidget);
      expect(find.text('Us'), findsWidgets);
    });

    testWidgets('lays out a whole deal in English', (tester) async {
      SharedPreferences.setMockInitialValues({'deberc_lang': 'en'});
      await openApp(tester);
      await tapText(tester, en.newGame);
      await tapText(tester, en.newRound);

      expect(find.text(en.trumpTakenBy), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('deberc')));
      await tester.pump();
      expect(find.text(en.debercWins('Them')), findsOneWidget);

      await tapText(tester, en.save);
      expect(find.text(en.winLabel), findsOneWidget);
    });

    testWidgets('can be switched in the settings and is remembered', (tester) async {
      await openApp(tester);
      await tapText(tester, uk.settingsBtn);
      await tapText(tester, 'English');

      expect(find.text(en.settingsTitle), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('deberc_lang'), 'en');

      await tapText(tester, en.backBtn);
      expect(find.text(en.newGame), findsOneWidget);
      // Names left at their defaults follow the language.
      expect(find.text('Them'), findsWidgets);
    });
  });

  testWidgets('explains the rules and where the game comes from', (tester) async {
    await openApp(tester);
    await tapText(tester, uk.rulesBtn);

    expect(find.text(uk.rulesTitle), findsOneWidget);
    expect(find.text('ЗВІДКИ ПОХОДИТЬ ГРА'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('ЯЙЦЯ — НІЧИЯ'), 300);
    expect(find.text('ЯЙЦЯ — НІЧИЯ'), findsOneWidget);

    await tapText(tester, uk.backBtn);
    expect(find.text(uk.newGame), findsOneWidget);
  });

  testWidgets('offers no way to continue when nothing was played', (tester) async {
    await openApp(tester);

    expect(find.text(uk.continuePrev), findsNothing);
  });

  testWidgets('asks for both team names', (tester) async {
    await openApp(tester);

    expect(find.widgetWithText(TextField, uk.ourTeamHint), findsOneWidget);
    expect(find.widgetWithText(TextField, uk.otherTeamHint), findsOneWidget);
  });

  testWidgets('keeps the rules off the home screen, which fits a phone without scrolling', (tester) async {
    await openApp(tester);

    expect(find.text(uk.dealerMustPlay), findsNothing);
    expect(find.text(uk.tieRuleTitle), findsNothing);
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable).first);
    expect(scroll.position.maxScrollExtent, 0);
  });

  group('rules in the settings', () {
    testWidgets('have the dealer play by default, which players can switch off', (tester) async {
      await openApp(tester);
      await tapText(tester, uk.settingsBtn);

      final toggle = find.byType(Switch);
      expect(tester.widget<Switch>(toggle).value, isTrue);

      await tapText(tester, uk.dealerMustPlay);

      expect(tester.widget<Switch>(toggle).value, isFalse);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('deberc_dealer_must_play'), isFalse);
    });

    testWidgets('explain what a tied deal is worth under the chosen rule', (tester) async {
      await openApp(tester);
      await tapText(tester, uk.settingsBtn);
      await tapText(tester, uk.tieRuleName(TieRule.opponentsTakeAll));

      expect(find.text(uk.tieRuleDesc(TieRule.opponentsTakeAll)), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('deberc_tie_rule'), 'opponentsTakeAll');
    });

    testWidgets('let players choose who wins when both sides pass the target together', (tester) async {
      await openApp(tester);
      await tapText(tester, uk.settingsBtn);
      expect(find.text(uk.finishRuleDesc(FinishRule.mostPoints)), findsOneWidget);

      await tapText(tester, uk.finishRuleName(FinishRule.taker));

      expect(find.text(uk.finishRuleDesc(FinishRule.taker)), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('deberc_finish_rule'), 'taker');
    });

    testWidgets('are remembered between launches', (tester) async {
      SharedPreferences.setMockInitialValues({
        'deberc_lang': 'uk', 'deberc_dealer_must_play': false, 'deberc_tie_rule': 'eachKeepsOwn',
      });
      await openApp(tester);
      await tapText(tester, uk.settingsBtn);

      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
      expect(find.text(uk.tieRuleDesc(TieRule.eachKeepsOwn)), findsOneWidget);
    });

    testWidgets('leave a game in progress on the rules it started with', (tester) async {
      await openApp(tester);
      await tapText(tester, uk.newGame);

      await tapText(tester, '⚙');
      await tapText(tester, uk.dealerMustPlay);
      expect(find.text(uk.rulesForNewGames), findsOneWidget);
      await tapText(tester, uk.backBtn);
      await tapText(tester, uk.newRound);

      expect(find.text(uk.allPassed), findsNothing);
    });
  });

  testWidgets('marks the dealing team in a 2 × 2 game without a player number', (tester) async {
    await openApp(tester);
    await tapText(tester, uk.newGame);

    expect(find.text(uk.deals), findsWidgets);
    expect(find.textContaining('гравець'), findsNothing);
  });

  group('shows how many points each side still needs', () {
    Future<void> playDeal(WidgetTester tester) async {
      await tapText(tester, uk.newGame);
      await tapText(tester, uk.newRound);
      // One side takes 82 of 162, the other the remaining 80.
      await tester.tap(find.text('8'));
      await tester.tap(find.text('2'));
      await tester.pump();
      await tapText(tester, uk.save);
    }

    testWidgets('beside the circles and sticks', (tester) async {
      await openApp(tester);
      await playDeal(tester);

      expect(find.text(uk.toGo(1001 - 82)), findsOneWidget);
      expect(find.text(uk.toGo(1001 - 80)), findsOneWidget);
    });

    testWidgets('beside the regular numbers', (tester) async {
      SharedPreferences.setMockInitialValues({'deberc_lang': 'uk', 'deberc_style': 'normal'});
      await openApp(tester);
      await playDeal(tester);

      expect(find.text('82/1001'), findsOneWidget);
      expect(find.text(uk.toGo(1001 - 82)), findsOneWidget);
      expect(find.text(uk.toGo(1001 - 80)), findsOneWidget);
    });
  });

  testWidgets('asks who took the trump, offering it first to the player left of the dealer', (tester) async {
    await openRound(tester);

    expect(find.text(uk.trumpTakenBy), findsOneWidget);
    // The first team deals first, so the second team has the first right.
    expect(find.text('♠ Вони'), findsOneWidget);
  });

  testWidgets('warns about bait as soon as the trump-taker is entered with fewer points', (tester) async {
    await openRound(tester);

    await tester.tap(find.text('5'));
    await tester.tap(find.text('0').last);
    await tester.pump();

    expect(find.text(uk.baitMsg('Ми', 162)), findsOneWidget);
  });

  testWidgets('builds the value of the deal from the declarations', (tester) async {
    await openRound(tester);
    expect(find.text(uk.dealValue(162)), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('tierce.+')));
    await tester.tap(find.byKey(const ValueKey('fifty.+')));
    await tester.tap(find.byKey(const ValueKey('bella')));
    await tester.pump();

    expect(find.text(uk.dealValue(252)), findsOneWidget);
  });

  testWidgets('leaves who deals in a new round to the badge above the score', (tester) async {
    await openRound(tester);

    expect(find.text(uk.deals), findsWidgets);
    expect(find.textContaining('✎'), findsNothing);
  });

  testWidgets('fits the buttons of an edited round on a phone and deletes it with the trash can once confirmed', (tester) async {
    await openRound(tester);
    await tester.tap(find.text('8'));
    await tester.tap(find.text('2'));
    await tester.pump();
    await tapText(tester, uk.save);
    await tapText(tester, '#1');

    // The panel names the round being changed; nothing in it overflows.
    expect(find.text(uk.editingRound(1)), findsOneWidget);
    expect(find.byTooltip(uk.delete), findsOneWidget);

    // Cancelling the question keeps the round.
    await tester.tap(find.byKey(const ValueKey('delete')));
    await tester.pumpAndSettle();
    expect(find.text(uk.deleteRoundTitle(1)), findsOneWidget);
    await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.text(uk.cancel)));
    await tester.pumpAndSettle();
    expect(find.text(uk.deleteRoundTitle(1)), findsNothing);
    expect(find.text(uk.editingRound(1)), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.text(uk.delete)));
    await tester.pumpAndSettle();
    // The header counts the next round, back to the first one.
    expect(find.text(uk.editingRound(1)), findsNothing);
    expect(find.text('#1'), findsOneWidget);
    expect(find.text('#2'), findsNothing);
  });

  testWidgets('ends the game when a deberc is recorded', (tester) async {
    await openRound(tester);

    await tester.ensureVisible(find.byKey(const ValueKey('deberc')));
    await tester.tap(find.byKey(const ValueKey('deberc')));
    await tester.pump();
    // The side that took the trump is offered first.
    expect(find.text(uk.debercWins('Вони')), findsOneWidget);
    // The pressed key is dressed as a win.
    expect(find.text('🏆 ${uk.deberc}'), findsOneWidget);

    await tapText(tester, uk.save);

    expect(find.text(uk.newRound), findsNothing);
  });

  testWidgets('keeps the Deberc key in the keypad beside 0, where it can be switched off', (tester) async {
    await openRound(tester);

    final deberc = tester.getRect(find.byKey(const ValueKey('deberc')));
    final zero = tester.getRect(find.text('0').last);
    expect(deberc.center.dy, closeTo(zero.center.dy, 1));
    expect(deberc.right, lessThan(zero.left));

    await tester.tap(find.byKey(const ValueKey('deberc')));
    await tester.pump();
    // Digits do nothing while a deberc is recorded.
    await tester.tap(find.text('5'));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('deberc')));
    await tester.pump();

    expect(find.text(uk.debercWins('Вони')), findsNothing);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('—'), findsNWidgets(2));
  });

  group('deal value wheel', () {
    /// The points shown for side [i] in the score row.
    Finder shownFor(int i, String text) =>
        find.descendant(of: find.byKey(ValueKey('score.$i')), matching: find.text(text));

    test('offers every value a deal can have, lowest first', () {
      expect(kDealValues.take(8), [162, 182, 202, 212, 222, 232, 242, 252]);
    });

    testWidgets('can be chosen in the settings and is remembered', (tester) async {
      await openApp(tester);
      await tapText(tester, uk.settingsBtn);
      await tapText(tester, uk.valueWheel);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('deberc_value_input'), 'wheel');
    });

    testWidgets('takes the place of the declaration counters, keeping the keypad', (tester) async {
      SharedPreferences.setMockInitialValues({'deberc_lang': 'uk', 'deberc_value_input': 'wheel'});
      await openRound(tester);

      expect(find.byType(CupertinoPicker), findsOneWidget);
      expect(find.byKey(const ValueKey('tierce.+')), findsNothing);
      expect(find.text('⌫'), findsOneWidget);
    });

    testWidgets('sets the value of the deal, raising it when spun up', (tester) async {
      SharedPreferences.setMockInitialValues({'deberc_lang': 'uk', 'deberc_value_input': 'wheel'});
      await openRound(tester);

      final wheel = tester.widget<CupertinoPicker>(find.byType(CupertinoPicker)).scrollController!;
      expect(wheel.selectedItem, 0);
      await tester.drag(find.byType(CupertinoPicker), const Offset(0, -60));
      await tester.pumpAndSettle();
      expect(wheel.selectedItem, greaterThan(0));

      wheel.jumpToItem(kDealValues.indexOf(252));
      await tester.pumpAndSettle();
      // The trump-taker is entered first and the rest of the 252 goes to the others.
      await tester.tap(find.text('1'));
      await tester.tap(find.text('0').last);
      await tester.tap(find.text('0').last);
      await tester.pump();
      expect(shownFor(0, '152'), findsOneWidget);

      await tapText(tester, uk.save);
      expect(find.text('#2'), findsOneWidget);
      expect(find.text('252${uk.pts}'), findsOneWidget);
    });
  });

  testWidgets('records a redeal when everyone passed and hands the deal on', (tester) async {
    await openApp(tester);
    await tapText(tester, uk.settingsBtn);
    await tapText(tester, uk.dealerMustPlay);
    await tapText(tester, uk.backBtn);
    await tapText(tester, uk.newGame);
    await tapText(tester, uk.newRound);

    await tapText(tester, uk.allPassed);

    expect(find.text(uk.badgeRedeal), findsOneWidget);
    expect(find.text('#2'), findsOneWidget);
  });

  testWidgets('offers no redeal when the dealer must play', (tester) async {
    await openRound(tester);

    expect(find.text(uk.allPassed), findsNothing);
  });

  testWidgets('stacks the trump choice beside the deal value', (tester) async {
    await openRound(tester);

    final us = tester.getRect(find.byKey(const ValueKey('taker.0')));
    final them = tester.getRect(find.byKey(const ValueKey('taker.1')));
    expect(them.top, greaterThan(us.bottom));
    expect(them.left, us.left);

    final tierce = tester.getRect(find.byKey(const ValueKey('tierce.−')));
    final fifty = tester.getRect(find.byKey(const ValueKey('fifty.+')));
    final bella = tester.getRect(find.byKey(const ValueKey('bella')));
    expect(tierce.left, greaterThan(us.right));
    expect(fifty.top, tierce.top);
    expect(bella.top, greaterThan(tierce.bottom));
    expect(bella.left, lessThanOrEqualTo(tierce.left));
    expect(bella.right, greaterThanOrEqualTo(fifty.right));
    expect(tierce.top, closeTo(us.top, 2));
    expect(bella.bottom, them.bottom);
    expect(find.text(uk.dealValue(162)), findsOneWidget);
  });

  testWidgets('makes the value wheel as tall as the side buttons', (tester) async {
    SharedPreferences.setMockInitialValues({'deberc_lang': 'uk', 'deberc_value_input': 'wheel'});
    await openRound(tester);

    final us = tester.getRect(find.byKey(const ValueKey('taker.0')));
    final them = tester.getRect(find.byKey(const ValueKey('taker.1')));
    final wheel = tester.getRect(find.byKey(const ValueKey('valueWheel')));
    expect(wheel.top, us.top);
    expect(wheel.bottom, them.bottom);
  });

  testWidgets('offers the short game to 301 alongside 501 and 1001', (tester) async {
    await openApp(tester);

    for (final limit in ['301', '501', '1001']) {
      expect(find.text(limit), findsOneWidget);
    }
  });

  testWidgets('sets up a game for three players and works out the third score', (tester) async {
    await openApp(tester);
    await tester.tap(find.byKey(const ValueKey('players.3')));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(3));

    await tapText(tester, uk.newGame);
    await tapText(tester, uk.newRound);
    // The first player deals, so the second has the first right to the trump.
    expect(find.text('♠ ${uk.player(2)}'), findsOneWidget);

    // Two of the three scores are typed; the last one follows from the deal.
    await tester.tap(find.text('8'));
    await tester.tap(find.text('2'));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('score.2')));
    await tester.tap(find.text('4'));
    await tester.tap(find.text('0').last);
    await tester.pump();

    expect(find.text('40'), findsWidgets);
    await tapText(tester, uk.save);
    expect(find.text('#2'), findsOneWidget);
  });

  testWidgets('uses the default name for a team whose name was left blank', (tester) async {
    await openApp(tester);
    await tester.enterText(find.byType(TextField).last, '   ');
    await tester.pump();

    // The dealer choice already reads the default name.
    expect(find.text('Вони'), findsOneWidget);

    await tapText(tester, uk.newGame);
    await tapText(tester, uk.newRound);

    expect(find.text('♠ Вони'), findsOneWidget);
  });
}
