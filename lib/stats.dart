import 'dart:convert';
import 'dart:io';
import 'dart:math';

/// Sends one event body to the statistics server; returns nothing and never throws.
typedef StatsSender = Future<void> Function(Uri url, String body);

/// Anonymous usage statistics: which versions, platforms, languages and screens
/// are in use. Nothing typed into the app is sent, and no identifier outlives a
/// launch: each start picks a fresh random one held only in memory.
///
/// The server and its public project key come from the release build
/// (`--dart-define=STATS_HOST=…`, `--dart-define=STATS_KEY=…`), so local runs and
/// tests send nothing.
class Stats {
  static const _host = String.fromEnvironment('STATS_HOST');
  static const _key = String.fromEnvironment('STATS_KEY');
  static const appVersion = String.fromEnvironment('APP_VERSION', defaultValue: 'dev');

  final String host;
  final String apiKey;
  final String platform;
  final StatsSender _send;
  final String _launchId;

  /// Whether the person allows statistics; set from Settings.
  bool enabled;

  Stats({
    this.host = _host,
    this.apiKey = _key,
    String? platform,
    StatsSender? send,
    this.enabled = true,
  })  : platform = platform ?? Platform.operatingSystem,
        _send = send ?? _post,
        _launchId = _randomId();

  bool get configured => host.isNotEmpty && apiKey.isNotEmpty;

  /// Reports that the app was started.
  void appOpened(String lang) => _capture('app_opened', lang, const {});

  /// Reports that a screen was opened.
  void screen(String name, String lang) => _capture(r'$screen', lang, {r'$screen_name': name});

  void _capture(String event, String lang, Map<String, Object> extra) {
    if (!enabled || !configured) return;
    final body = jsonEncode({
      'api_key': apiKey,
      'event': event,
      'distinct_id': _launchId,
      'properties': {
        r'$process_person_profile': false,
        r'$lib': 'deberc-app',
        r'$app_version': appVersion,
        r'$os': platform,
        'language': lang,
        ...extra,
      },
    });
    _send(Uri.parse('$host/i/v0/e/'), body);
  }

  static String _randomId() {
    final r = Random.secure();
    return List.generate(16, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }

  /// Posts quietly: no connection or a slow server never reaches the player.
  static Future<void> _post(Uri url, String body) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
    try {
      final req = await client.postUrl(url);
      req.headers.contentType = ContentType.json;
      req.write(body);
      final res = await req.close().timeout(const Duration(seconds: 10));
      await res.drain<void>();
    } catch (_) {
      // Statistics are best effort.
    } finally {
      client.close(force: true);
    }
  }
}
