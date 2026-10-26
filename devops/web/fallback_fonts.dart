// Puts the fonts the Flutter web engine falls back to next to the web app.
//
// When text holds a character the app's fonts lack, the engine downloads a
// Noto font that has it, and Roboto for text in the default font, from a font
// CDN unless told otherwise. The web app points the engine at its own fonts/
// folder instead (web/flutter_bootstrap.js), and this fills that folder with
// every font the engine may ask for, at the same paths it asks for them, so
// the app looks the same and loads nothing from other hosts. The list is read
// from the Flutter SDK running this script, so it always matches the engine
// the app is built with. It fails when a font the service worker keeps ahead
// of time (web/sw.js) is one the engine no longer asks for.
//
// Run from the repository root after the web build:
//   dart run devops/web/fallback_fonts.dart build/web/fonts
import 'dart:io';

const source = 'https://fonts.gstatic.com/s/';

/// The web engine sources of the Flutter SDK this Dart belongs to.
Directory engineSources() {
  // The Dart of a Flutter SDK is <flutter>/bin/cache/dart-sdk/bin/dart.
  final cache = File(Platform.resolvedExecutable).parent.parent.parent;
  final engine = Directory('${cache.path}/flutter_web_sdk/lib/_engine/engine');
  if (!engine.existsSync()) {
    throw StateError('No Flutter web engine at ${engine.path}; build the web app first');
  }
  return engine;
}

/// Every font path the engine may download, relative to its font base URL.
List<String> fontPaths(Directory engine) {
  final fallbacks = File('${engine.path}/font_fallback_data.dart').readAsStringSync();
  final roboto = File('${engine.path}/canvaskit/fonts.dart').readAsStringSync();
  final paths = [
    for (final m in RegExp(r"'([a-z0-9]+/v\d+/[^']+\.woff2)'").allMatches(fallbacks)) m[1]!,
    for (final m in RegExp(r"fontFallbackBaseUrl\}([^']+)'").allMatches(roboto)) m[1]!,
  ];
  if (paths.length < 100 || !paths.any((p) => p.startsWith('roboto/'))) {
    throw StateError('The engine no longer lists its fallback fonts where this script reads them');
  }
  return paths;
}

/// The fonts the service worker keeps ahead of time, from its UI_FONTS list.
List<String> uiFonts(File serviceWorker) {
  final list = RegExp(r'const UI_FONTS = \[([^\]]*)\]').firstMatch(serviceWorker.readAsStringSync());
  if (list == null) throw StateError('${serviceWorker.path} no longer has its UI_FONTS list');
  return [for (final m in RegExp(r"'([^']+)'").allMatches(list[1]!)) m[1]!];
}

Future<void> download(HttpClient http, String path, Directory out) async {
  final file = File('${out.path}/$path');
  if (file.existsSync() && file.lengthSync() > 0) return;
  for (var attempt = 1;; attempt++) {
    try {
      final response = await (await http.getUrl(Uri.parse('$source$path'))).close();
      if (response.statusCode != 200) throw HttpException('HTTP ${response.statusCode}', uri: Uri.parse('$source$path'));
      file.parent.createSync(recursive: true);
      final part = File('${file.path}.part');
      await response.pipe(part.openWrite());
      part.renameSync(file.path);
      return;
    } on IOException catch (e) {
      if (attempt == 3) throw StateError('Could not download $path: $e');
      await Future<void>.delayed(Duration(seconds: attempt * 2));
    }
  }
}

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Usage: dart run devops/web/fallback_fonts.dart <fonts folder>');
    exit(64);
  }
  final out = Directory(args.single);
  final paths = fontPaths(engineSources());
  final missing = uiFonts(File('web/sw.js')).where((font) => !paths.contains(font)).toList();
  if (missing.isNotEmpty) {
    throw StateError('web/sw.js keeps fonts the engine no longer asks for: ${missing.join(', ')}');
  }
  final http = HttpClient();
  final queue = [...paths];
  // A few downloads at a time: hundreds of small files, one CDN.
  await Future.wait([
    for (var i = 0; i < 16; i++)
      () async {
        while (queue.isNotEmpty) {
          await download(http, queue.removeLast(), out);
        }
      }(),
  ]);
  http.close();
  stdout.writeln('${paths.length} fallback fonts in ${out.path}');
}
