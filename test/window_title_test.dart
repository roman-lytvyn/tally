import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deberc/window_title.dart';

void main() {
  const channel = MethodChannel('tally/window');
  late List<Object?> titles;

  setUp(() {
    titles = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'setTitle') titles.add(call.arguments);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  Widget titled(String title) =>
      WindowTitle(title: title, child: const SizedBox());

  testWidgets('a desktop window takes the title and follows its changes', (tester) async {
    await tester.pumpWidget(titled('Belote'));
    await tester.pumpWidget(titled('Belote'));
    await tester.pumpWidget(titled('Белот'));
    expect(titles, ['Belote', 'Белот']);
  }, variant: const TargetPlatformVariant({TargetPlatform.windows, TargetPlatform.linux}));

  testWidgets('a phone has no window title to set', (tester) async {
    await tester.pumpWidget(titled('Belote'));
    expect(titles, isEmpty);
  }, variant: const TargetPlatformVariant({TargetPlatform.android, TargetPlatform.iOS}));
}
