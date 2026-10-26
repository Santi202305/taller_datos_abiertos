import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_datos_abiertos/main.dart';
import 'package:taller_datos_abiertos/themes/app_theme.dart';
import 'package:taller_datos_abiertos/views/detail_view.dart';
import 'package:taller_datos_abiertos/widgets/error_widget.dart';
import 'package:taller_datos_abiertos/widgets/list_item_card.dart';
import 'package:taller_datos_abiertos/widgets/loading_widget.dart';

void main() {
  setUp(() {
    dotenv.loadFromString(
      envString: 'BASE_URL=https://api-colombia.com/api/v1',
    );
  });

  testWidgets('Generate dashboard screenshot', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MyApp),
      matchesGoldenFile('../docs/screenshots/01_dashboard.png'),
    );
  });

  testWidgets('Generate listado screenshot', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          appBar: AppBar(title: const Text('Departamentos')),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ListItemCard(
                title: 'Arauca',
                subtitle: 'Población: 304978 · Municipios: 7',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Atlántico',
                subtitle: 'Población: 2804025 · Municipios: 23',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Antioquia',
                subtitle: 'Población: 6887306 · Municipios: 125',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Bolívar',
                subtitle: 'Población: 2180976 · Municipios: 46',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Boyacá',
                subtitle: 'Población: 1242731 · Municipios: 123',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/02_listado.png'),
    );
  });

  testWidgets('Generate detalle screenshot', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const DetailView(
          endpoint: 'Department',
          id: 3,
          item: {
            'id': 3,
            'name': 'Arauca',
            'description':
                'Arauca es uno de los treinta y dos departamentos que forman la República de Colombia. Su capital es la homónima Arauca.',
            'municipalities': 7,
            'surface': 23818,
            'population': 304978,
            'phonePrefix': '7',
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/03_detalle.png'),
    );
  });

  testWidgets('Generate loading state screenshot', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: LoadingWidget(message: 'Cargando datos...'),
        ),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/04_estado_cargando.png'),
    );
  });

  testWidgets('Generate error state screenshot', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: ErrorDisplayWidget(
            message:
                'Sin conexión a internet. Verifica tu red e intenta de nuevo.',
            onRetry: () {},
          ),
        ),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/05_estado_error.png'),
    );
  });
}
