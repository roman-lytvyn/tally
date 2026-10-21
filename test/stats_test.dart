import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:deberc/stats.dart';

void main() {
  late List<(Uri, Map<String, dynamic>)> sent;

  Future<void> record(Uri url, String body) async =>
      sent.add((url, jsonDecode(body) as Map<String, dynamic>));

  setUp(() => sent = []);

  Stats configured({bool enabled = true}) => Stats(
        host: 'https://stats.test', apiKey: 'phc_test', platform: 'android',
        send: record, enabled: enabled,
      );

  test('a build without a statistics server sends nothing', () {
    final stats = Stats(host: '', apiKey: '', platform: 'android', send: record);
    stats.appOpened('uk');
    stats.screen('game', 'uk');
    expect(stats.configured, isFalse);
    expect(sent, isEmpty);
  });

  test('turning statistics off stops every event', () {
    final stats = configured(enabled: false);
    stats.appOpened('uk');
    stats.screen('game', 'uk');
    expect(sent, isEmpty);
  });

  test('an event carries only the version, platform, language and screen', () {
    configured().screen('settings', 'en');
    expect(sent, hasLength(1));
    final (url, body) = sent.single;
    expect(url.toString(), 'https://stats.test/i/v0/e/');
    expect(body['api_key'], 'phc_test');
    expect(body['event'], r'$screen');
    expect(body.keys.toSet(), {'api_key', 'event', 'distinct_id', 'properties'});
    expect(body['properties'], {
      r'$process_person_profile': false,
      r'$lib': 'deberc-app',
      r'$app_version': Stats.appVersion,
      r'$os': 'android',
      'language': 'en',
      r'$screen_name': 'settings',
    });
  });

  test('one launch keeps one random id, and the next launch gets another', () {
    final first = configured();
    first.appOpened('uk');
    first.screen('game', 'uk');
    configured().appOpened('uk');
    final ids = [for (final (_, body) in sent) body['distinct_id'] as String];
    expect(ids[0], ids[1]);
    expect(ids[2], isNot(ids[0]));
    expect(ids[0], matches(RegExp(r'^[0-9a-f]{32}$')));
  });
}
