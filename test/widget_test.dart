import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomade/main.dart';

void main() {
  testWidgets('le menu s\'affiche et lance une partie', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const NomadeApp());
    await tester.pumpAndSettle();
    expect(find.text('NOMADE'), findsOneWidget);

    await tester.tap(find.text('Prendre la route'));
    await tester.pumpAndSettle();
    expect(find.text('Seul·e'), findsNothing); // libellé visible seulement en glissant
    expect(find.textContaining('Jour 0'), findsOneWidget);
  });
}
