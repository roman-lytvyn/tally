import 'package:flutter_test/flutter_test.dart';
import 'package:deberc/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DebertsApp());
    await tester.pump();
    expect(find.text('Деберц'), findsOneWidget);
  });
}
