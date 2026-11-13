import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:deberc/rules_content.dart';
import 'package:deberc/main.dart';
import 'package:deberc/l10n.dart';
import 'package:deberc/models.dart';
import 'package:deberc/screens/about_screen.dart';
import 'package:deberc/screens/settings_screen.dart';
import 'package:deberc/theme.dart';
import 'package:deberc/widgets/entry_panel.dart';
import 'package:deberc/widgets/traditional_score.dart';

void main() {
  const uk = AppStrings('uk');

  setUp(() {
    // The app reads the saved game and settings on startup; without this the
    // plugin has no platform to talk to and the app never finishes loading.
    SharedPreferences.setMockInitialValues({'deberc_lang': 'uk'});
  });

  /// The app is locked to portrait on a phone, while the default test surface is
  /// a landscape desktop one the screens were never laid out for.
  Future<void> openApp(WidgetTester tester, {GameRules rules = GameRules.deberc}) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(DebertsApp(rules: rules));
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

  /// Presses a key of the keypad, scrolling the panel to it first.
  Future<void> press(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.text(key).last);
    await tester.pump();
    await tester.tap(find.text(key).last);
  }

  /// Taps the widget with [key], scrolling the panel to it first.
  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(ValueKey(key)));
    await tester.pump();
    await tester.tap(find.byKey(ValueKey(key)));
  }

  /// The points shown for side [i] in the score row.
  Finder shownFor(int i, String text) =>
      find.descendant(of: find.byKey(ValueKey('score.$i')), matching: find.text(text));

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

  testWidgets('keeps the width of a large phone in a wide window, centred', (tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const DebertsApp());
    await tester.pumpAndSettle();

    final screen = tester.getRect(find.byType(Scaffold).first);
    // Less the thin edge drawn on each side.
    expect(screen.width, closeTo(maxAppWidth, 2));
    expect(screen.height, 1080);
    expect(screen.center.dx, 960);
  });

  testWidgets('fills a phone screen from edge to edge', (tester) async {
    await openApp(tester);

    expect(tester.getRect(find.byType(Scaffold).first), const Rect.fromLTWH(0, 0, 360, 780));
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

  group('game rules', () {
    const plain = GameRules(
      id: 'plain',
      declarations: [DeclarationKind('tierce', 20), DeclarationKind('bella', 20, max: 1)],
      maxDeclared: 100,
      scoreLimits: [501, 1001],
      defaultScoreLimit: 501,
    );

    testWidgets('offer the targets and declarations of the game', (tester) async {
      await openApp(tester, rules: plain);

      expect(find.text('301'), findsNothing);
      expect(find.text('501'), findsOneWidget);
      await tapText(tester, uk.newGame);
      await tapText(tester, uk.newRound);
      expect(find.byKey(const ValueKey('tierce.+')), findsOneWidget);
      expect(find.byKey(const ValueKey('fifty.+')), findsNothing);
      expect(find.byKey(const ValueKey('bella')), findsOneWidget);
    });

    testWidgets('leave out the Deberc win and penalties of a game without them', (tester) async {
      await openApp(tester, rules: plain);
      await tapText(tester, uk.newGame);
      await tapText(tester, uk.newRound);
      expect(find.byKey(const ValueKey('deberc')), findsNothing);

      await tapText(tester, uk.cancel);
      await tapText(tester, uk.exitBtn);
      await tapText(tester, uk.settingsBtn);
      expect(find.text(uk.baitPenaltyTitle), findsNothing);
      expect(find.text(uk.noTricksTitle), findsNothing);
    });

    testWidgets('ask who holds the belote, which a lost contract leaves to its holder', (tester) async {
      await openApp(tester, rules: GameRules.belote);
      await tapText(tester, uk.newGame);
      await tapText(tester, uk.newRound);
      expect(find.text(uk.heldBy(uk.declaration('belote'))), findsNothing);

      await tapKey(tester, 'belote');
      await tester.pump();
      expect(find.text(uk.dealValue(182)), findsOneWidget);
      expect(find.text(uk.heldBy(uk.declaration('belote'))), findsOneWidget);

      await press(tester, '1');
      await press(tester, '3');
      await press(tester, '2');
      await tester.pump();
      expect(find.text(const AppStrings('uk', GameRules.belote).baitMsg('Ми', 162)), findsOneWidget);
    });

    testWidgets('score a Bulgarian Belot deal by its contract and doubling', (tester) async {
      const bg = AppStrings('uk', GameRules.belot);
      await openApp(tester, rules: GameRules.belot);
      expect(find.text(uk.howManyPlay), findsNothing);
      await tapText(tester, uk.newGame);
      await tapText(tester, uk.newRound);

      await tapKey(tester, 'contract.noTrumps');
      await tester.pump();
      expect(find.text(uk.dealValue(130)), findsOneWidget);
      expect(find.byKey(const ValueKey('tierce.+')), findsNothing);

      await press(tester, '5');
      await press(tester, '0');
      await tester.pump();
      // The player left of the dealer takes the trump and the defenders'
      // 50 of 130 leave it 80.
      expect(find.text(bg.recordedMsg([10, 16])), findsOneWidget);

      await tapKey(tester, 'doubling.2');
      await tester.pump();
      expect(find.text(bg.takesAllMsg('Вони', 52)), findsOneWidget);

      await tapText(tester, uk.save);
      expect(find.text('БК ×2'), findsOneWidget);
      expect(find.text('52'), findsWidgets);

      await tapText(tester, uk.exitBtn);
      await tapText(tester, uk.settingsBtn);
      expect(find.text(uk.tieRuleTitle), findsNothing);
      expect(find.text(uk.displayStyle), findsNothing);
    });

    testWidgets('score a Baloot deal in game points, Hokm or Sun', (tester) async {
      const ba = AppStrings('uk', GameRules.baloot);
      await openApp(tester, rules: GameRules.baloot);
      await tapText(tester, uk.newGame);
      await tapText(tester, uk.newRound);
      expect(find.text(ba.trumpTakenBy), findsOneWidget);
      expect(find.text(uk.dealValue(162)), findsOneWidget);
      expect(find.byKey(const ValueKey('fourHundred.+')), findsNothing);

      // The buyer's own points are typed this time.
      await tapKey(tester, 'score.1');
      await press(tester, '1');
      await press(tester, '0');
      await press(tester, '0');
      await tester.pump();
      // The player left of the dealer buys and takes 100 of 162; the
      // opponents count their 62 as 6 and the buyer gets the other 10.
      expect(find.text(ba.recordedMsg([6, 10])), findsOneWidget);

      await tapKey(tester, 'doubling.$kGahwa');
      await tester.pump();
      expect(find.text(ba.gahwaWins('Вони')), findsOneWidget);

      await tapKey(tester, 'contract.sun');
      await tester.pump();
      expect(find.byKey(const ValueKey('doubling.3')), findsNothing);
      expect(find.text(uk.dealValue(130)), findsOneWidget);
      // Now 100 of 130: the opponents' 30 count as 6 in Sun.
      expect(find.text(ba.recordedMsg([6, 20])), findsOneWidget);

      await tapText(tester, uk.save);
      expect(find.text('Сан'), findsOneWidget);
      expect(find.text('20'), findsWidgets);
    });

    testWidgets('lays the app out right to left in Arabic', (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.platformDispatcher.localeTestValue = const Locale('ar', 'SA');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      await openApp(tester, rules: GameRules.baloot);

      const ar = AppStrings('ar', GameRules.baloot);
      expect(find.text(ar.newGame), findsOneWidget);
      expect(Directionality.of(tester.element(find.text(ar.newGame))), TextDirection.rtl);
    });

    testWidgets('score a Coinche deal by its bid and coinche', (tester) async {
      const co = AppStrings('uk', GameRules.coinche);
      await openApp(tester, rules: GameRules.coinche);
      await tapText(tester, uk.newGame);
      await tapText(tester, uk.newRound);
      expect(find.text('${co.bid}: 80'), findsOneWidget);
      expect(find.byKey(const ValueKey('bid.−')), findsOneWidget);

      for (var i = 0; i < 2; i++) {
        await tapKey(tester, 'bid.+');
        await tester.pump();
      }
      expect(find.text('${co.bid}: 100'), findsOneWidget);

      await press(tester, '5');
      await press(tester, '0');
      await tester.pump();
      // The player left of the dealer wins the bidding and the defenders'
      // 50 of 162 leave it 112.
      expect(find.text(co.recordedMsg([50, 210])), findsOneWidget);

      await tapKey(tester, 'doubling.2');
      await tester.pump();
      expect(find.text(co.recordedMsg([50, 310])), findsOneWidget);

      await tapText(tester, uk.save);
      expect(find.text('100 ×2'), findsOneWidget);
      expect(find.text('310'), findsWidgets);
    });
  });

  group('theme', () {
    bool isDark(WidgetTester tester) => tester.widget<SettingsScreen>(find.byType(SettingsScreen)).theme.isDark;

    testWidgets('follows the device until one is chosen, then stays', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await openApp(tester);
      await tapText(tester, uk.settingsBtn);

      expect(isDark(tester), isTrue);
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pumpAndSettle();
      expect(isDark(tester), isFalse);

      await tapKey(tester, 'theme.dark');
      await tester.pumpAndSettle();
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pumpAndSettle();
      expect(isDark(tester), isTrue);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('deberc_theme'), 'dark');
    });

    testWidgets('offers only light and dark', (tester) async {
      await openApp(tester);
      await tapText(tester, uk.settingsBtn);

      expect(find.byKey(const ValueKey('theme.light')), findsOneWidget);
      expect(find.byKey(const ValueKey('theme.dark')), findsOneWidget);
      expect(find.byKey(const ValueKey('theme.system')), findsNothing);
    });
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
      await tapKey(tester, 'deberc');
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

    testWidgets('follows a French device and can be chosen in the settings', (tester) async {
      const fr = AppStrings('fr');
      SharedPreferences.setMockInitialValues({});
      tester.platformDispatcher.localeTestValue = const Locale('fr', 'FR');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      await openApp(tester);
      expect(find.text(fr.newGame), findsOneWidget);
      expect(find.text('Nous'), findsWidgets);

      await tapText(tester, fr.settingsBtn);
      await tapText(tester, 'Українська');
      await tapText(tester, 'Français');
      expect(find.text(fr.settingsTitle), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('deberc_lang'), 'fr');

      await tapText(tester, fr.backBtn);
      await tapText(tester, fr.newGame);
      await tapText(tester, fr.newRound);
      expect(find.text(fr.trumpTakenBy), findsOneWidget);
    });

    testWidgets('starts Belote in French on French devices and in English elsewhere', (tester) async {
      SharedPreferences.setMockInitialValues({});
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      tester.platformDispatcher.localeTestValue = const Locale('uk', 'UA');
      await openApp(tester, rules: GameRules.belote);
      expect(find.text(en.newGame), findsOneWidget);

      SharedPreferences.setMockInitialValues({});
      tester.platformDispatcher.localeTestValue = const Locale('fr', 'BE');
      await tester.pumpWidget(const SizedBox());
      await openApp(tester, rules: GameRules.belote);
      expect(find.text(const AppStrings('fr').newGame), findsOneWidget);
    });

    testWidgets('starts Bulgarian Belot in Bulgarian on Bulgarian devices', (tester) async {
      const bg = AppStrings('bg', GameRules.belot);
      SharedPreferences.setMockInitialValues({});
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      tester.platformDispatcher.localeTestValue = const Locale('bg', 'BG');
      await openApp(tester, rules: GameRules.belot);
      expect(find.text(bg.newGame), findsOneWidget);
      expect(find.text('Ние'), findsWidgets);

      await tapText(tester, bg.newGame);
      await tapText(tester, bg.newRound);
      expect(find.text('Без коз'), findsOneWidget);
      expect(find.text('Контра'), findsOneWidget);
      expect(find.text('ВЪТРЕ'), findsNothing);
      expect(find.text('Вътре'), findsOneWidget);
    });

    test('offers Bulgarian in every app, starting in it only in Bulgarian Belot', () {
      expect(kLanguages, contains('bg'));
      expect(AppStrings.languageName('bg'), 'Български');
      expect(defaultLanguage(GameRules.belot, 'bg'), 'bg');
      expect(defaultLanguage(GameRules.belot, 'uk'), 'en');
      expect(defaultLanguage(GameRules.deberc, 'bg'), 'en');
      expect(const AppStrings('bg', GameRules.belot).badgeEggs, 'ВИСЯЩИ');
    });

    testWidgets('starts Bela in Croatian on Croatian devices, with a tie falling', (tester) async {
      const hr = AppStrings('hr', GameRules.bela);
      SharedPreferences.setMockInitialValues({});
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      tester.platformDispatcher.localeTestValue = const Locale('hr', 'HR');
      await openApp(tester, rules: GameRules.bela);
      expect(find.text(hr.newGame), findsOneWidget);
      expect(find.text('Mi'), findsWidgets);

      await tapText(tester, hr.settingsBtn);
      await tester.scrollUntilVisible(find.text(hr.tieRuleDesc(TieRule.opponentsTakeAll)), 300);
      expect(find.text(hr.tieRuleDesc(TieRule.opponentsTakeAll)), findsOneWidget);
    });

    test('offers Croatian in every app, starting in it only in Bela', () {
      expect(kLanguages, contains('hr'));
      expect(AppStrings.languageName('hr'), 'Hrvatski');
      expect(defaultLanguage(GameRules.bela, 'hr'), 'hr');
      expect(defaultLanguage(GameRules.bela, 'sr'), 'hr');
      expect(defaultLanguage(GameRules.bela, 'uk'), 'en');
      expect(defaultLanguage(GameRules.deberc, 'hr'), 'en');
      expect(const AppStrings('hr', GameRules.bela).badgeBait, 'PAD');
      expect(const AppStrings('hr', GameRules.bela).badgeDeberc, 'BELOT');
      expect(const AppStrings('hr', GameRules.bela).declaration('stiglja'), 'Štiglja');
    });

    test('offers Dutch in every app, starting in it only in Klaverjas', () {
      expect(kLanguages, contains('nl'));
      expect(AppStrings.languageName('nl'), 'Nederlands');
      expect(defaultLanguage(GameRules.klaverjas, 'nl'), 'nl');
      expect(defaultLanguage(GameRules.klaverjas, 'uk'), 'en');
      expect(defaultLanguage(GameRules.deberc, 'nl'), 'en');
      expect(const AppStrings('nl', GameRules.klaverjas).appTitle, 'Klaverjas');
      expect(const AppStrings('nl', GameRules.klaverjas).badgeBait, 'NAT');
      expect(const AppStrings('nl', GameRules.klaverjas).declaration('stuk'), 'Stuk');
      expect(const AppStrings('nl', GameRules.klaverjas).declaration('pit'), 'Pit');
    });

    test('starts Coinche in French on French devices and names its terms', () {
      expect(defaultLanguage(GameRules.coinche, 'fr'), 'fr');
      expect(defaultLanguage(GameRules.coinche, 'uk'), 'en');
      const fr = AppStrings('fr', GameRules.coinche);
      expect(fr.appTitle, 'Coinche');
      expect(fr.badgeBait, 'CHUTE');
      expect(fr.doublingName(2), 'Coinche');
      expect(fr.doublingName(4), 'Surcoinche');
      expect(fr.bidName(kCapot), 'Capot');
      expect(fr.bidName(120), '120');
    });

    test('starts Baloot in Arabic on Arabic devices and names its terms', () {
      expect(defaultLanguage(GameRules.baloot, 'ar'), 'ar');
      expect(defaultLanguage(GameRules.baloot, 'fr'), 'en');
      const ar = AppStrings('ar', GameRules.baloot);
      expect(ar.isRtl, isTrue);
      expect(const AppStrings('en', GameRules.baloot).isRtl, isFalse);
      expect(ar.appTitle, 'بلوت');
      expect(ar.contractName('hokm'), 'حكم');
      expect(ar.contractName('sun'), 'صن');
      expect(ar.doublingName(kGahwa), 'قهوة');
      expect(ar.doublingMark(kGahwa), '☕');
      expect(ar.doublingMark(3), '×3');
      expect(const AppStrings('en', GameRules.baloot).declaration('valat'), 'Kaboot');
      expect(const AppStrings('en').declaration('valat'), 'Valat');
      expect(AppStrings.languageName('ar'), 'العربية');
    });

    test('uses the terms of the game being played', () {
      expect(const AppStrings('en').badgeBait, 'BAIT');
      expect(const AppStrings('en', GameRules.belote).badgeBait, 'DEDANS');
      expect(const AppStrings('fr').badgeEggs, 'LITIGE');
      expect(const AppStrings('fr', GameRules.belote).appTitle, 'Belote');
      expect(const AppStrings('uk').eggsMsg(TieRule.hanging, 91, ''), startsWith('Яйця!'));
    });
  });

  testWidgets('explains the rules of the game', (tester) async {
    await openApp(tester);
    await tapText(tester, uk.rulesBtn);

    expect(find.text(uk.rulesTitle), findsOneWidget);
    expect(find.text('ГРАВЦІ Й КАРТИ'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('ЯЙЦЯ — НІЧИЯ'), 300);
    expect(find.text('ЯЙЦЯ — НІЧИЯ'), findsOneWidget);

    await tapText(tester, uk.backBtn);
    expect(find.text(uk.newGame), findsOneWidget);
  });

  testWidgets('explains the rules of Belote in the language of the app', (tester) async {
    SharedPreferences.setMockInitialValues({});
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    tester.platformDispatcher.localeTestValue = const Locale('fr', 'FR');
    await openApp(tester, rules: GameRules.belote);
    await tapText(tester, const AppStrings('fr', GameRules.belote).rulesBtn);

    expect(find.text('JOUEURS ET CARTES'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('BELOTE-REBELOTE'), 300);
    expect(find.text('BELOTE-REBELOTE'), findsOneWidget);
  });

  test('has the rules of every game in every language', () {
    for (final game in GameRules.all) {
      final en = rulesContent('en', game);
      for (final lang in kLanguages) {
        final other = rulesContent(lang, game);
        expect(other.first.title, isIn(const [
          'Players and cards', 'Гравці й карти', 'Гравці та карти', 'Joueurs et cartes', 'Играчи и карти',
          'Igrači i karte', 'Spelers en kaarten', 'اللاعبون والأوراق',
        ]));
        if (lang != 'en') expect(other.first.title, isNot(en.first.title), reason: '${game.id} $lang');
      }
    }
    expect(rulesContent('fr', GameRules.belote).first.title, 'Joueurs et cartes');
    expect(rulesContent('uk', GameRules.belote), isNot(rulesContent('uk')));
    expect(rulesContent('hr', GameRules.klaverjas).first.title, 'Igrači i karte');
    expect(rulesContent('ar').first.title, 'اللاعبون والأوراق');
  });

  test('gives every rules language of a game the same sections, table rows and numbers', () {
    for (final game in GameRules.all) {
      final en = rulesContent('en', game);
      for (final lang in kLanguages) {
        final other = rulesContent(lang, game);
        final where = '${game.id} $lang';
        expect(other.length, en.length, reason: where);
        for (var i = 0; i < en.length; i++) {
          expect(other[i].paragraphs.length, en[i].paragraphs.length, reason: '$where §$i');
          expect(other[i].tableHeader?.length, en[i].tableHeader?.length, reason: '$where §$i');
          expect(other[i].table.length, en[i].table.length, reason: '$where §$i');
          for (var j = 0; j < en[i].table.length; j++) {
            expect(other[i].table[j].length, en[i].table[j].length, reason: '$where §$i row $j');
            // The points in a table are the same in every language; only the words change.
            for (var k = 0; k < en[i].table[j].length; k++) {
              final cell = en[i].table[j][k];
              if (RegExp(r'^[\d\s,.+−–/×%-]+$').hasMatch(cell)) {
                expect(other[i].table[j][k], cell, reason: '$where §$i row $j');
              }
            }
          }
        }
      }
    }
  });

  testWidgets('shows the rules in the language chosen in the settings', (tester) async {
    const hr = AppStrings('hr', GameRules.klaverjas);
    await openApp(tester, rules: GameRules.klaverjas);
    await tapText(tester, const AppStrings('uk', GameRules.klaverjas).settingsBtn);
    await tapText(tester, 'Hrvatski');
    await tapText(tester, hr.backBtn);
    await tapText(tester, hr.rulesBtn);

    expect(find.text('IGRAČI I KARTE'), findsOneWidget);
  });

  testWidgets('reads the Arabic rules right to left', (tester) async {
    SharedPreferences.setMockInitialValues({'deberc_lang': 'ar'});
    await openApp(tester, rules: GameRules.belote);
    await tapText(tester, const AppStrings('ar', GameRules.belote).rulesBtn);

    final title = find.text('اللاعبون والأوراق');
    expect(title, findsOneWidget);
    expect(Directionality.of(tester.element(title)), TextDirection.rtl);
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

    testWidgets('let players choose penalties for repeated bait and for skis', (tester) async {
      await openApp(tester);
      await tapText(tester, uk.settingsBtn);
      expect(find.byKey(const ValueKey('baitPoints.50')), findsNothing);

      await tapText(tester, uk.baitPenaltyName(BaitPenalty.thirdAndAfter));
      await tester.ensureVisible(find.byKey(const ValueKey('baitPoints.50')));
      await tapKey(tester, 'baitPoints.50');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('baitsInARow')));
      await tapKey(tester, 'baitsInARow');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('noTricks.100')));
      await tapKey(tester, 'noTricks.100');
      await tester.pumpAndSettle();

      final prefs = await SharedPreferences.getInstance();
      expect(jsonDecode(prefs.getString('deberc_penalties')!), const Penalties(
          bait: BaitPenalty.thirdAndAfter, baitPoints: 50, baitsInARow: true, noTricksPoints: 100).toJson());
    });

    testWidgets('leave a game in progress on the rules it started with', (tester) async {
      await openApp(tester);
      await tapText(tester, uk.newGame);

      await tapText(tester, '⚙');
      await tapText(tester, uk.dealerMustPlay);
      await tester.scrollUntilVisible(find.text(uk.rulesForNewGames), 200, scrollable: find.byType(Scrollable).first);
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
      // The defenders take 80 of 162, the trump-taker the remaining 82.
      await press(tester, '8');
      await press(tester, '0');
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

      // The score itself is left to the large digits above the bars.
      expect(find.textContaining('/1001'), findsNothing);
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

  testWidgets('starts the points on the defenders, leaving the trump-taker to be worked out', (tester) async {
    await openRound(tester);
    await tapKey(tester, 'taker.0');
    await tester.pump();

    await press(tester, '6');
    await press(tester, '2');
    await tester.pump();

    expect(shownFor(1, '62'), findsOneWidget);
    expect(shownFor(0, '100'), findsOneWidget);
  });

  testWidgets('keeps the typed points when another side is picked as the trump-taker', (tester) async {
    await openRound(tester);
    // The second team took the trump, so the points start on the first team.
    await press(tester, '6');
    await press(tester, '2');
    await tester.pump();

    await tapKey(tester, 'taker.0');
    await tester.pump();

    expect(find.text('♠ Ми'), findsOneWidget);
    expect(shownFor(0, '62'), findsOneWidget);
    expect(shownFor(1, '100'), findsOneWidget);
    // Typing goes on in the same place.
    await press(tester, '⌫');
    await tester.pump();
    expect(shownFor(0, '6'), findsOneWidget);
    // The first team took the trump with fewer points, so it fell.
    await press(tester, '2');
    await tester.pump();
    expect(find.text(uk.baitMsg('Вони', 162)), findsOneWidget);
  });

  testWidgets('warns about bait as soon as the defenders are entered with more points', (tester) async {
    await openRound(tester);

    await press(tester, '1');
    await press(tester, '1');
    await press(tester, '2');
    await tester.pump();

    expect(find.text(uk.baitMsg('Ми', 162)), findsOneWidget);
  });

  testWidgets('builds the value of the deal from the declarations', (tester) async {
    await openRound(tester);
    expect(find.text(uk.dealValue(162)), findsOneWidget);

    await tapKey(tester, 'tierce.+');
    await tapKey(tester, 'fifty.+');
    await tapKey(tester, 'bella');
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
    await press(tester, '8');
    await press(tester, '2');
    await tester.pump();
    await tapText(tester, uk.save);
    await tapText(tester, '#1');

    // The panel names the round being changed; nothing in it overflows.
    expect(find.text(uk.editingRound(1)), findsOneWidget);
    expect(find.byTooltip(uk.delete), findsOneWidget);

    // Cancelling the question keeps the round.
    await tapKey(tester, 'delete');
    await tester.pumpAndSettle();
    expect(find.text(uk.deleteRoundTitle(1)), findsOneWidget);
    await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.text(uk.cancel)));
    await tester.pumpAndSettle();
    expect(find.text(uk.deleteRoundTitle(1)), findsNothing);
    expect(find.text(uk.editingRound(1)), findsOneWidget);

    await tapKey(tester, 'delete');
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
    await tapKey(tester, 'deberc');
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

    await tapKey(tester, 'deberc');
    await tester.pump();
    // Digits do nothing while a deberc is recorded.
    await press(tester, '5');
    await tester.pump();
    await tapKey(tester, 'deberc');
    await tester.pump();

    expect(find.text(uk.debercWins('Вони')), findsNothing);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('—'), findsNWidgets(2));
  });

  group('deal value wheel', () {
    test('offers every value a deal can have, lowest first', () {
      expect(GameRules.deberc.dealValues.take(8), [162, 182, 202, 212, 222, 232, 242, 252]);
    });

    test('goes no higher than a deal can reach', () {
      expect(GameRules.deberc.dealValues.last, 662);
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
      expect(find.text('⌫'), findsOneWidget);

      expect(find.byType(CupertinoPicker), findsOneWidget);
      expect(find.byKey(const ValueKey('tierce.+')), findsNothing);
    });

    testWidgets('sets the value of the deal, raising it when spun up', (tester) async {
      SharedPreferences.setMockInitialValues({'deberc_lang': 'uk', 'deberc_value_input': 'wheel'});
      await openRound(tester);

      final wheel = tester.widget<CupertinoPicker>(find.byType(CupertinoPicker)).scrollController!;
      expect(wheel.selectedItem, 0);
      await tester.drag(find.byType(CupertinoPicker), const Offset(0, -60));
      await tester.pumpAndSettle();
      expect(wheel.selectedItem, greaterThan(0));

      wheel.jumpToItem(GameRules.deberc.dealValues.indexOf(252));
      await tester.pumpAndSettle();
      // The defenders are entered first and the rest of the 252 goes to the trump-taker.
      await press(tester, '1');
      await press(tester, '0');
      await press(tester, '0');
      await tester.pump();
      expect(shownFor(1, '152'), findsOneWidget);

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

  testWidgets('marks bait and eggs in the column of the side that took the trump', (tester) async {
    const game = GameState(
      teamNames: ['Ми', 'Вони'], scoreLimit: 501, firstDealer: 0, tieRule: TieRule.hanging,
      rounds: [
        Round(gv: 162, dealer: 0, taker: 0, score: [0, 0], isBait: true),
        Round(gv: 162, dealer: 1, taker: 1, score: [0, 0], isBait: true),
        Round(gv: 162, dealer: 0, taker: 1, score: [81, 81]),
      ],
    );
    SharedPreferences.setMockInitialValues({'deberc_lang': 'uk', 'deberc_v2': jsonEncode(game.toJson())});
    await openApp(tester);
    await tapText(tester, uk.continuePrev);

    // Newer deals are listed first: the second deal's 162 sits in the first
    // column, and the first deal's 162 in the second.
    expect(find.text(uk.badgeBait), findsNWidgets(2));
    expect(tester.getRect(find.byKey(const ValueKey('bait.0'))).right,
        lessThan(tester.getRect(find.text('162').last).left));
    expect(tester.getRect(find.byKey(const ValueKey('bait.1'))).left,
        greaterThan(tester.getRect(find.text('162').first).right));
    expect(find.byKey(const ValueKey('eggs.1')), findsOneWidget);
    expect(find.byKey(const ValueKey('eggs.0')), findsNothing);

    // The line between the two sides runs down the middle of each row.
    expect(tester.getCenter(find.byKey(const ValueKey('divider.0.1'))).dx,
        moreOrLessEquals(tester.getCenter(find.byType(ListView)).dx, epsilon: 0.5));
  });

  testWidgets('counts baits and marks the penalties taken off in the history', (tester) async {
    const game = GameState(
      teamNames: ['Ми', 'Вони'], scoreLimit: 501, firstDealer: 0,
      penalties: Penalties(bait: BaitPenalty.third, noTricksPoints: 50),
      rounds: [
        Round(gv: 162, dealer: 0, taker: 0, score: [0, 0], isBait: true),
        Round(gv: 162, dealer: 1, taker: 0, score: [0, 0], isBait: true),
        Round(gv: 162, dealer: 0, taker: 0, score: [0, 0], isBait: true),
        Round(gv: 162, dealer: 1, taker: 1, score: [0, 162]),
      ],
    );
    SharedPreferences.setMockInitialValues({'deberc_lang': 'uk', 'deberc_v2': jsonEncode(game.toJson())});
    await openApp(tester);
    await tapText(tester, uk.continuePrev);

    expect(find.byKey(const ValueKey('baits.0')), findsOneWidget);
    expect(find.text(uk.baitsSoFar(3)), findsOneWidget);
    expect(find.byKey(const ValueKey('baits.1')), findsNothing);
    expect(find.byKey(const ValueKey('baitPenalty.2.0')), findsOneWidget);
    expect(find.byKey(const ValueKey('baitPenalty.1.0')), findsNothing);
    expect(find.byKey(const ValueKey('noTricks.3.0')), findsOneWidget);
  });

  testWidgets('offers no redeal when the dealer must play', (tester) async {
    await openRound(tester);

    expect(find.text(uk.allPassed), findsNothing);
  });

  testWidgets('lays the trump choice out side by side above the declarations, sized for a finger', (tester) async {
    await openRound(tester);

    final us = tester.getRect(find.byKey(const ValueKey('taker.0')));
    final them = tester.getRect(find.byKey(const ValueKey('taker.1')));
    expect(them.top, us.top);
    expect(them.left, greaterThan(us.right));
    expect(us.height, greaterThanOrEqualTo(44));

    final tierce = tester.getRect(find.byKey(const ValueKey('tierce.+')));
    expect(tierce.top, greaterThan(us.bottom));
    expect(find.text(uk.dealValue(162)), findsOneWidget);
  });

  testWidgets('enters the declarations in the panel itself, two to a row, the size of a finger', (tester) async {
    await openRound(tester);
    expect(find.byKey(const ValueKey('tierce.−')), findsNothing);

    await tapKey(tester, 'tierce.+');
    await tester.pump();
    for (final key in ['tierce.−', 'tierce.+', 'fifty.+', 'bella']) {
      final rect = tester.getRect(find.byKey(ValueKey(key)));
      expect(rect.height, greaterThanOrEqualTo(44), reason: key);
      expect(rect.width, greaterThanOrEqualTo(44), reason: key);
    }
    final tierce = tester.getRect(find.byKey(const ValueKey('tierce.+')));
    final fifty = tester.getRect(find.byKey(const ValueKey('fifty.+')));
    final bella = tester.getRect(find.byKey(const ValueKey('bella')));
    expect(fifty.top, tierce.top);
    expect(bella.top, greaterThan(tierce.bottom));

    await tapKey(tester, 'tierce.−');
    await tester.pump();
    expect(find.text(uk.dealValue(162)), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('puts the value wheel in a narrow column beside the trump choice', (tester) async {
    SharedPreferences.setMockInitialValues({'deberc_lang': 'uk', 'deberc_value_input': 'wheel'});
    await openRound(tester);

    final wheel = tester.getRect(find.byKey(const ValueKey('valueWheel')));
    final us = tester.getRect(find.byKey(const ValueKey('taker.0')));
    final them = tester.getRect(find.byKey(const ValueKey('taker.1')));
    expect(them.top, greaterThan(us.bottom));
    expect(wheel.left, greaterThan(us.right));
    expect(wheel.top, us.top);
    expect(wheel.bottom, them.bottom);
    expect(us.width, greaterThan(wheel.width * 2.5));
    expect(us.height, greaterThanOrEqualTo(44));

    // The deal value names itself; no caption is needed above the wheel.
    expect(find.text(uk.dealValue(162)), findsOneWidget);
    expect(find.text(uk.gameValue), findsNothing);
  });

  for (final style in ['traditional', 'numeric']) {
    testWidgets('leaves the $style score and the deals where they are when the popup opens', (tester) async {
      SharedPreferences.setMockInitialValues({'deberc_lang': 'uk', 'deberc_style': style});
      await openRound(tester);
      await tapKey(tester, 'taker.0');
      await tester.pump();
      await press(tester, '8');
      await press(tester, '0');
      await tapText(tester, uk.save);

      final shown = find.byType(Text).evaluate().toList();
      List<Rect> rects() => [
        for (final e in shown)
          (e.renderObject! as RenderBox).localToGlobal(Offset.zero) & (e.renderObject! as RenderBox).size,
      ];
      final before = rects();

      await tapText(tester, uk.newRound);

      expect(find.byType(EntryPanel), findsOneWidget);
      expect(rects(), before);
    });
  }

  testWidgets('opens the popup over the game and leaves it only through its own buttons', (tester) async {
    await openRound(tester);

    // The game underneath takes no taps while the popup is open.
    await tester.tapAt(tester.getCenter(find.text(uk.exitBtn)));
    await tester.pumpAndSettle();
    expect(find.byType(EntryPanel), findsOneWidget);

    await tapText(tester, uk.cancel);
    expect(find.byType(EntryPanel), findsNothing);
    expect(find.text(uk.newRound), findsOneWidget);
  });

  testWidgets('keeps the circles and sticks while a deal is entered', (tester) async {
    SharedPreferences.setMockInitialValues({'deberc_lang': 'uk', 'deberc_style': 'traditional'});
    await openRound(tester);

    expect(find.byType(TraditionalScore), findsNWidgets(2));
  });

  group('deal entry popup never scrolls', () {
    const sizes = [Size(411, 830), Size(360, 640), Size(320, 480), Size(830, 411)];

    /// Fails if the popup could scroll or reaches past the screen.
    void expectFits(WidgetTester tester, Size size) {
      expect(find.ancestor(of: find.byType(EntryPanel), matching: find.byType(Scrollable)), findsNothing);
      expect(find.descendant(of: find.byType(EntryPanel), matching: find.byType(SingleChildScrollView)), findsNothing);
      final panel = tester.getRect(find.byType(EntryPanel));
      expect(panel.top, greaterThanOrEqualTo(0));
      expect(panel.left, greaterThanOrEqualTo(0));
      expect(panel.bottom, lessThanOrEqualTo(size.height + 0.01));
      expect(panel.right, lessThanOrEqualTo(size.width + 0.01));
    }

    for (final rules in GameRules.all) {
      for (final size in sizes) {
        for (final wheel in [false, true]) {
          testWidgets('${rules.id} at ${size.width}x${size.height}${wheel ? ' with the wheel' : ''}', (tester) async {
            SharedPreferences.setMockInitialValues({'deberc_lang': 'uk', if (wheel) 'deberc_value_input': 'wheel'});
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.reset);
            await tester.pumpWidget(DebertsApp(rules: rules));
            await tester.pumpAndSettle();
            await tapText(tester, uk.newGame);
            await tapText(tester, uk.newRound);
            expectFits(tester, size);

            // A chosen taker brings in more of the panel.
            await tester.tap(find.byKey(const ValueKey('taker.0')));
            await tester.pumpAndSettle();
            expectFits(tester, size);
            if (size == sizes.first) {
              expect(tester.getSize(find.byType(EntryPanel)).width, size.width,
                  reason: 'a phone this size shows the popup at full size');
            }
          });
        }
      }
    }
  });

  testWidgets('shows everyone passed as a button of a finger size', (tester) async {
    await openApp(tester);
    await tapText(tester, uk.settingsBtn);
    await tapText(tester, uk.dealerMustPlay);
    await tapText(tester, uk.backBtn);
    await tapText(tester, uk.newGame);
    await tapText(tester, uk.newRound);

    final redeal = find.byKey(const ValueKey('redeal'));
    expect(tester.getSize(redeal).height, greaterThanOrEqualTo(32));
    expect(find.descendant(of: redeal, matching: find.byIcon(Icons.refresh)), findsOneWidget);
    expect(find.descendant(of: redeal, matching: find.text(uk.allPassed)), findsOneWidget);

    await tester.tap(redeal);
    await tester.pumpAndSettle();
    expect(find.byType(EntryPanel), findsNothing);
    expect(find.text('#1'), findsOneWidget);
  });

  testWidgets('shows the version and the author on the about page, reached from the settings', (tester) async {
    await openApp(tester);
    await tapText(tester, uk.newGame);
    await tapText(tester, '⚙');

    final row = find.byKey(const ValueKey('settings.about'));
    await tester.scrollUntilVisible(row, 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    expect(find.descendant(of: row, matching: find.text(kAppVersion)), findsOneWidget);
    await tester.tap(row);
    await tester.pumpAndSettle();

    expect(find.text(uk.aboutTitle), findsOneWidget);
    expect(find.text(uk.appTitle), findsOneWidget);
    expect(find.text(kAppVersion), findsOneWidget);
    expect(find.text(uk.authorName), findsOneWidget);

    // Back leads to the settings, and from them to the game they were opened from.
    await tapText(tester, uk.backBtn);
    expect(find.byType(SettingsScreen), findsOneWidget);
    await tapText(tester, uk.backBtn);
    expect(find.text(uk.newRound), findsOneWidget);
  });

  testWidgets('opens the website from the about page', (tester) async {
    final opened = <Uri>[];
    await tester.pumpWidget(MaterialApp(
      home: AboutScreen(
        theme: const AppTheme(true), strings: uk, onBack: () {},
        openLink: (url) async => opened.add(url),
      ),
    ));

    await tester.tap(find.byKey(const ValueKey('about.website')));
    await tester.pump();

    expect(opened, [Uri.parse('https://tallycards.app')]);
  });

  testWidgets('offers the short game to 301 alongside 501 and 1001', (tester) async {
    await openApp(tester);

    for (final limit in ['301', '501', '1001']) {
      expect(find.text(limit), findsOneWidget);
    }
  });

  testWidgets('sets up a game for three players and works out the third score', (tester) async {
    await openApp(tester);
    await tapKey(tester, 'players.3');
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(3));

    await tapText(tester, uk.newGame);
    await tapText(tester, uk.newRound);
    // The first player deals, so the second has the first right to the trump.
    expect(find.text('♠ ${uk.player(2)}'), findsOneWidget);

    // The defenders' scores are typed; the trump-taker's follows from the deal.
    await press(tester, '4');
    await press(tester, '0');
    await tester.pump();
    await tapKey(tester, 'score.0');
    await press(tester, '4');
    await press(tester, '1');
    await tester.pump();

    expect(shownFor(1, '81'), findsOneWidget);
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

  group('the system Back button', () {
    Future<bool> back(WidgetTester tester) async {
      final handled = await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      return handled;
    }

    testWidgets('returns from the settings to the start screen', (tester) async {
      await openApp(tester);
      await tapText(tester, uk.settingsBtn);
      expect(find.text(uk.newGame), findsNothing);

      expect(await back(tester), isTrue);
      expect(find.text(uk.newGame), findsOneWidget);
    });

    testWidgets('closes an open deal first, then leaves the game', (tester) async {
      await openRound(tester);

      expect(await back(tester), isTrue);
      expect(find.text(uk.newRound), findsOneWidget);
      expect(find.text(uk.newGame), findsNothing);

      expect(await back(tester), isTrue);
      expect(find.text(uk.newGame), findsOneWidget);
    });

    testWidgets('leaves the app from the start screen', (tester) async {
      await openApp(tester);

      expect(await back(tester), isFalse);
    });
  });

  group('the screen orientation', () {
    /// The orientations the app last asked the system for.
    Future<List<dynamic>?> requested(WidgetTester tester, Size size, double ratio) async {
      List<dynamic>? last;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'SystemChrome.setPreferredOrientations') last = call.arguments as List<dynamic>;
        return null;
      });
      addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = ratio;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const DebertsApp());
      await tester.pumpAndSettle();
      return last;
    }

    testWidgets('stays portrait on a phone', (tester) async {
      expect(await requested(tester, const Size(1080, 2340), 3), ['DeviceOrientation.portraitUp']);
    });

    testWidgets('follows the device on a tablet', (tester) async {
      expect(await requested(tester, const Size(2560, 1600), 2), isEmpty);
    });
  });
}
