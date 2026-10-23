// Switches the checkout to one app of the family before it is built: the
// app's name, package id and file names on every platform, and its own icons
// when it has them.
//
// Each app is described by devops/apps/<app>.env. The platform files keep the
// values of whichever app the checkout was last switched to, Deberc in the
// repository, so switching to Deberc changes nothing. Files laid over the
// checkout from another app's folder stay until they are checked out again.
//
// Run from the repository root: dart run devops/apps/use_app.dart <app>
import 'dart:io';

/// The app's identity from devops/apps/[app].env: KEY="value" lines, with
/// blank lines and # comments skipped.
Map<String, String> readProfile(Directory root, String app) {
  final file = File('${root.path}/devops/apps/$app.env');
  if (!file.existsSync()) throw ArgumentError('No app profile at ${file.path}');
  return {
    for (final line in file.readAsLinesSync())
      if (line.trim().isNotEmpty && !line.trimLeft().startsWith('#'))
        line.substring(0, line.indexOf('=')).trim(): _unquote(line.substring(line.indexOf('=') + 1).trim()),
  };
}

String _unquote(String v) => v.length >= 2 && v.startsWith('"') && v.endsWith('"') ? v.substring(1, v.length - 1) : v;

/// Where each identity value sits in a platform file: a pattern whose second
/// group is the value, between what comes before and after it.
const places = <(String, String, String)>[
  ('android/app/build.gradle.kts', r'(applicationId = ")([^"]*)(")', 'APP_PACKAGE_ID'),
  ('android/app/src/main/res/values/strings.xml', r'(<string name="app_name">)([^<]*)(<)', 'APP_NAME'),
  ('android/app/src/main/res/values-uk/strings.xml', r'(<string name="app_name">)([^<]*)(<)', 'APP_NAME_UK'),
  ('android/app/src/main/res/values-fr/strings.xml', r'(<string name="app_name">)([^<]*)(<)', 'APP_NAME_FR'),
  ('linux/CMakeLists.txt', r'(set\(BINARY_NAME ")([^"]*)(")', 'APP_FILE_NAME'),
  ('linux/CMakeLists.txt', r'(set\(APPLICATION_ID ")([^"]*)(")', 'APP_PACKAGE_ID'),
  ('linux/runner/my_application.cc', r'(_set_title\(\w+, ")([^"]*)(")', 'APP_TITLE'),
  ('windows/CMakeLists.txt', r'(project\()(\S+)( LANGUAGES)', 'APP_FILE_NAME'),
  ('windows/CMakeLists.txt', r'(set\(BINARY_NAME ")([^"]*)(")', 'APP_FILE_NAME'),
  ('windows/runner/main.cpp', r'(window\.Create\(L")([^"]*)(")', 'APP_FILE_NAME'),
  ('windows/runner/Runner.rc', r'(VALUE "(?:FileDescription|InternalName|ProductName)", ")([^"]*)(")', 'APP_FILE_NAME'),
  ('windows/runner/Runner.rc', r'(VALUE "OriginalFilename", ")([^"]*)(\.exe")', 'APP_FILE_NAME'),
  ('pubspec.yaml', r'(\n  display_name: )([^\r\n]*)()', 'APP_TITLE'),
  ('pubspec.yaml', r'(\n  identity_name: )([^\r\n]*)()', 'APP_PACKAGE_ID'),
];

/// Writes the identity of [app] into the platform files under [root] and lays
/// its own files from devops/apps/[app]/ over the checkout.
void useApp(Directory root, String app) {
  final profile = readProfile(root, app);
  for (final (path, pattern, key) in places) {
    final value = profile[key];
    if (value == null) throw ArgumentError('$app.env has no $key');
    final file = File('${root.path}/$path');
    final text = file.readAsStringSync();
    final re = RegExp(pattern);
    if (!re.hasMatch(text)) throw StateError('$path no longer has the place for $key');
    final updated = text.replaceAllMapped(re, (m) => '${m[1]}$value${m[3]}');
    if (updated != text) file.writeAsStringSync(updated);
  }

  final own = Directory('${root.path}/devops/apps/$app');
  if (own.existsSync()) {
    for (final file in own.listSync(recursive: true).whereType<File>()) {
      final target = File('${root.path}/${file.path.substring(own.path.length + 1)}');
      target.parent.createSync(recursive: true);
      file.copySync(target.path);
    }
  }
}

void main(List<String> args) {
  if (args.length != 1) {
    stderr.writeln('Usage: dart run devops/apps/use_app.dart <app>');
    exit(64);
  }
  useApp(Directory.current, args.single);
  stdout.writeln('Switched to ${args.single}');
}
