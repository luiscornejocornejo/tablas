import 'package:flutter_test/flutter_test.dart';
import 'package:tablas_primaria/main.dart';

void main() {
  testWidgets('La pantalla principal carga correctamente', (tester) async {
    await tester.pumpWidget(const TablasApp());
    await tester.pumpAndSettle();

    expect(find.text('¡Aprende las Tablas!'), findsOneWidget);
    expect(find.text('Modo Práctica'), findsOneWidget);
    expect(find.text('Ver Todas las Tablas'), findsOneWidget);
    expect(find.text('Elige tu tabla'), findsOneWidget);
  });
}
