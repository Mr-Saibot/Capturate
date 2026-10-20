import 'package:flutter_test/flutter_test.dart';

import 'package:capturate/app.dart';

void main() {
  testWidgets('La pantalla inicial muestra el paso 1 y el botón principal', (tester) async {
    await tester.pumpWidget(const AplicacionCapturate());

    expect(find.text('1. Seleccionar'), findsOneWidget);
    expect(find.text('Elegir imagen'), findsOneWidget);
  });
}
