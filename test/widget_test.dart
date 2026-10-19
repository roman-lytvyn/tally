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
    await tester.ensureVisible(find.text(text));
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  /// Starts a new game and opens the panel for its first deal.
  Future<void> openRound(WidgetTester tester) async {
    await openApp(tester);
    await tapText(tester, uk.newGame);
    await tapText(tester, uk.newRound);
  }

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

      expect(find.text(en.allPassed), findsOneWidget);
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

  testWidgets('lets players agree that the dealer must play', (tester) async {
    await openApp(tester);

    final toggle = find.byType(Switch);
    expect(tester.widget<Switch>(toggle).value, isFalse);

    await tapText(tester, uk.dealerMustPlay);

    expect(tester.widget<Switch>(toggle).value, isTrue);
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

  testWidgets('ends the game when a deberc is recorded', (tester) async {
    await openRound(tester);

    await tester.ensureVisible(find.byKey(const ValueKey('deberc')));
    await tester.tap(find.byKey(const ValueKey('deberc')));
    await tester.pump();
    // The side that took the trump is offered first.
    expect(find.text(uk.debercWins('Вони')), findsOneWidget);

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

  testWidgets('records a redeal when everyone passed and hands the deal on', (tester) async {
    await openRound(tester);

    await tapText(tester, uk.allPassed);

    expect(find.text(uk.badgeRedeal), findsOneWidget);
    expect(find.text('#2'), findsOneWidget);
  });

  testWidgets('offers no redeal when the dealer must play', (tester) async {
    await openApp(tester);
    await tapText(tester, uk.dealerMustPlay);
    await tapText(tester, uk.newGame);
    await tapText(tester, uk.newRound);

    expect(find.text(uk.allPassed), findsNothing);
    expect(find.text(uk.dealerPlaysIfAllPass), findsOneWidget);
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

  testWidgets('explains what a tied deal is worth under the chosen rule', (tester) async {
    await openApp(tester);
    await tapText(tester, uk.tieRuleName(TieRule.opponentsTakeAll));

    expect(find.text(uk.tieRuleDesc(TieRule.opponentsTakeAll)), findsOneWidget);
  });
}
