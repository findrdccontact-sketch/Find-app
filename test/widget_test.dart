import 'package:flutter_test/flutter_test.dart';
import 'package:find_app/main.dart';

void main() {
  testWidgets('FIND App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FindApp());
    expect(find.text('FIND'), findsOneWidget);
    expect(find.text('« Trouvez votre prochain chez-vous. »'), findsOneWidget);
  });
}
