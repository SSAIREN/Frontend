import 'package:flutter_test/flutter_test.dart';
import 'package:ssairen/app.dart';

void main() {
  testWidgets('SSAIREN app renders calling screen smoke test', (tester) async {
    await tester.pumpWidget(const SsairenApp());

    expect(find.text('010-8765-4321'), findsOneWidget);
    expect(find.text('보이스피싱 확률'), findsOneWidget);
  });
}
