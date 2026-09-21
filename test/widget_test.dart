import 'package:flutter_test/flutter_test.dart';
import 'package:trunocrazy/main.dart';

void main() {
  testWidgets('abre o baralho de Truco', (tester) async {
    await tester.pumpWidget(const TrunoCrazyApp());
    await tester.pumpAndSettle();

    expect(find.text('Baralho de Truco'), findsOneWidget);
  });
}
