import 'package:com.rado.quick_mart/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Counter increments smoke test',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MyApp(),
      );
    },
  );
}
