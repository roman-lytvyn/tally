import 'dart:io';

import 'package:deberc/game_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../devops/apps/use_app.dart';

void main() {
  late Directory root;

  // A copy of the files the switch touches, so the test never changes the
  // checkout it runs in.
  setUp(() {
    root = Directory.systemTemp.createTempSync('use_app');
    final paths = {for (final (path, _, _) in places) path, 'devops/apps/deberc.env'};
    for (final path in paths) {
      final copy = File('${root.path}/$path')..parent.createSync(recursive: true);
      File(path).copySync(copy.path);
    }
    File('${root.path}/devops/apps/other.env').writeAsStringSync(
      File('devops/apps/deberc.env').readAsStringSync()
          .replaceAll('"app.tallycards.deberc"', '"org.example.other"')
          .replaceAll('"deberc"', '"other"')
          .replaceAll('"Deberc"', '"Other"')
          .replaceAll('"Деберць"', '"Інша"')
          .replaceAll('"Деберц"', '"Друга"'),
    );
    File('${root.path}/devops/apps/other/devops/linux/icons/16.png')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync('icon');
  });

  tearDown(() => root.deleteSync(recursive: true));

  String read(String path) => File('${root.path}/$path').readAsStringSync();

  test('switching to Deberc leaves the checkout as it is', () {
    final before = {for (final (path, _, _) in places) path: read(path)};
    useApp(root, 'deberc');
    expect({for (final path in before.keys) path: read(path)}, before);
  });

  test('switching to another app renames it on every platform', () {
    useApp(root, 'other');

    expect(read('android/app/build.gradle.kts'), contains('applicationId = "org.example.other"'));
    // The code's own namespace stays, so the app's sources need no move.
    expect(read('android/app/build.gradle.kts'), contains('namespace = "app.tallycards"'));
    expect(read('android/app/src/main/res/values/strings.xml'), contains('>Other<'));
    expect(read('android/app/src/main/res/values-uk/strings.xml'), contains('>Інша<'));
    expect(read('android/app/src/main/res/values-fr/strings.xml'), contains('>Other<'));
    expect(read('android/app/src/main/res/values-bg/strings.xml'), contains('>Друга<'));
    expect(read('android/app/src/main/res/values-hr/strings.xml'), contains('>Other<'));
    expect(read('android/app/src/main/res/values-nl/strings.xml'), contains('>Other<'));
    expect(read('android/app/src/main/res/values-ar/strings.xml'), contains('>Other<'));
    expect(read('linux/CMakeLists.txt'), allOf(contains('"other"'), contains('"org.example.other"')));
    expect(read('linux/runner/my_application.cc'), isNot(contains('Деберць')));
    expect(read('windows/CMakeLists.txt'), allOf(contains('project(other '), isNot(contains('"deberc"'))));
    expect(read('windows/runner/main.cpp'), contains('L"other"'));
    expect(read('windows/runner/Runner.rc'), allOf(contains('"other.exe"'), isNot(contains('"deberc'))));
    expect(read('ios/Runner/Info.plist'), allOf(contains('<string>Other</string>'), contains('<string>other</string>')));
    for (final path in ['ios/Runner.xcodeproj/project.pbxproj', 'macos/Runner.xcodeproj/project.pbxproj']) {
      expect(read(path), allOf(contains('org.example.other.RunnerTests;'), isNot(contains('app.tallycards.deberc'))));
    }
    expect(read('ios/Runner.xcodeproj/project.pbxproj'), contains('PRODUCT_BUNDLE_IDENTIFIER = org.example.other;'));
    expect(read('macos/Runner/Configs/AppInfo.xcconfig'),
        allOf(contains('PRODUCT_NAME = Other'), contains('PRODUCT_BUNDLE_IDENTIFIER = org.example.other')));
    expect(read('pubspec.yaml'), allOf(contains('display_name: Інша'), contains('identity_name: org.example.other')));
    expect(read('web/index.html'), allOf(contains('<title>Other</title>'), contains('-title" content="Other"')));
    expect(read('web/manifest.json'), allOf(contains('"name": "Other"'), contains('"short_name": "Other"')));
    expect(read('devops/linux/icons/16.png'), 'icon');
  });

  test('every app of the family has a profile and its own identity', () {
    final apps = {for (final game in GameRules.all) game.id: readProfile(Directory.current, game.id)};
    for (final MapEntry(key: id, value: profile) in apps.entries) {
      expect(profile['APP_GAME'], id);
      expect(profile['APP_FILE_NAME'], id);
      for (final (_, _, key) in places) {
        expect(profile[key], isNotEmpty, reason: '$id.env has no $key');
      }
    }
    for (final key in ['APP_PACKAGE_ID', 'APP_WINDOWS_ID', 'APP_MS_STORE_ID', 'APP_MS_IDENTITY_NAME']) {
      expect({for (final p in apps.values) p[key]}, hasLength(apps.length), reason: '$key is shared');
    }
    for (final MapEntry(key: id, value: profile) in apps.entries) {
      expect(profile['APP_MS_STORE'], 'true', reason: '$id has no Store listing');
      expect(profile['APP_MS_STORE_ID'], matches(RegExp(r'^9[0-9A-Z]{11}$')), reason: '$id has no Store ID');
      expect(profile['APP_MS_IDENTITY_NAME'], startsWith('RomanLytvyn.'), reason: '$id has no Store identity');
    }
    for (final app in ['belote', 'belot', 'bela', 'klaverjas', 'coinche', 'baloot']) {
      expect(File('devops/apps/$app/windows/runner/resources/app_icon.ico').existsSync(), isTrue);
      expect(File('devops/apps/$app/web/icons/Icon-maskable-512.png').existsSync(), isTrue);
      expect(File('devops/apps/$app/macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png').existsSync(),
          isTrue);
    }
  });

  test('switching back restores Deberc', () {
    final before = {for (final (path, _, _) in places) path: read(path)};
    useApp(root, 'other');
    useApp(root, 'deberc');
    expect({for (final path in before.keys) path: read(path)}, before);
  });
}
