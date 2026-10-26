import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_datos_abiertos/main.dart';

void main() {
  setUp(() {
    dotenv.loadFromString(
      envString: 'BASE_URL=https://api-colombia.com/api/v1',
    );
  });

  testWidgets('Dashboard smoke test loads title and endpoint cards', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('API Colombia'), findsOneWidget);
    expect(find.text('Departamentos'), findsOneWidget);
    expect(find.text('Presidentes'), findsOneWidget);
    expect(find.text('Atracciones Turísticas'), findsOneWidget);
    expect(find.text('Regiones'), findsOneWidget);
    expect(find.text('Platos Típicos'), findsOneWidget);
  });
}
