import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_datos_abiertos/main.dart';
import 'package:taller_datos_abiertos/themes/app_theme.dart';
import 'package:taller_datos_abiertos/views/detail_view.dart';
import 'package:taller_datos_abiertos/widgets/empty_widget.dart';
import 'package:taller_datos_abiertos/widgets/error_widget.dart';
import 'package:taller_datos_abiertos/widgets/list_item_card.dart';
import 'package:taller_datos_abiertos/widgets/loading_widget.dart';

Future<void> _loadFonts() async {
  final fontLoader = FontLoader('Roboto');
  final fontFile = File('/usr/share/fonts/noto/NotoSans-Regular.ttf');
  if (fontFile.existsSync()) {
    final bytes = fontFile.readAsBytesSync();
    fontLoader.addFont(Future.value(ByteData.view(bytes.buffer)));
    await fontLoader.load();
  }

  final iconLoader = FontLoader('MaterialIcons');
  final iconFile = File(
      '/home/vulkan/.local/share/flutterup/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
  if (iconFile.existsSync()) {
    final bytes = iconFile.readAsBytesSync();
    iconLoader.addFont(Future.value(ByteData.view(bytes.buffer)));
    await iconLoader.load();
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _loadFonts();
    dotenv.loadFromString(
      envString: 'BASE_URL=https://api-colombia.com/api/v1',
    );
  });

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('01-dashboard', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MyApp),
      matchesGoldenFile('../docs/screenshots/01-dashboard.png'),
    );
  });

  testWidgets('02-listado-department', (WidgetTester tester) async {
    configureViewport(tester);
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
                subtitle: 'Población: 304,978 · Municipios: 7',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Atlántico',
                subtitle: 'Población: 2,804,025 · Municipios: 23',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Antioquia',
                subtitle: 'Población: 6,887,306 · Municipios: 125',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Bolívar',
                subtitle: 'Población: 2,180,976 · Municipios: 46',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Boyacá',
                subtitle: 'Población: 1,242,731 · Municipios: 123',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Caldas',
                subtitle: 'Población: 1,018,453 · Municipios: 27',
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
      matchesGoldenFile('../docs/screenshots/02-listado-department.png'),
    );
  });

  testWidgets('03-detalle-department', (WidgetTester tester) async {
    configureViewport(tester);
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
                'Arauca es uno de los treinta y dos departamentos que, junto con Bogotá, Distrito Capital, forman la República de Colombia. Su capital es la homónima Arauca. Está ubicado al este del país, en la región Orinoquía, limitando al norte y este con Venezuela, al sur con Vichada y Casanare, y al oeste con Boyacá.',
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
      matchesGoldenFile('../docs/screenshots/03-detalle-department.png'),
    );
  });

  testWidgets('02-listado-president', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          appBar: AppBar(title: const Text('Presidentes')),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ListItemCard(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                title: 'Rafael Nuñez Moledo',
                subtitle: 'Nuñez Moledo · Partido nacional',
                onTap: () {},
              ),
              ListItemCard(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                title: 'Carlos Holguín Mallarino',
                subtitle: 'Holguín Mallarino · Partido nacional',
                onTap: () {},
              ),
              ListItemCard(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                title: 'Miguel Antonio Caro',
                subtitle: 'Caro · Partido nacional',
                onTap: () {},
              ),
              ListItemCard(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                title: 'Manuel Antonio Sanclemente',
                subtitle: 'Sanclemente · Partido nacional',
                onTap: () {},
              ),
              ListItemCard(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                title: 'José Manuel Marroquín',
                subtitle: 'Marroquín · Partido Conservador',
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
      matchesGoldenFile('../docs/screenshots/02-listado-president.png'),
    );
  });

  testWidgets('03-detalle-president', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const DetailView(
          endpoint: 'President',
          id: 3,
          item: {
            'id': 3,
            'name': 'Rafael',
            'lastName': 'Nuñez Moledo',
            'politicalParty': 'Partido nacional',
            'startPeriodDate': '1887-06-04',
            'endPeriodDate': '1888-08-07',
            'description':
                'Rafael Wenceslao Núñez Moledo fue un abogado, periodista, escritor, político y militar colombiano, presidente de Colombia en 4 ocasiones, autor de la letra del Himno Nacional y promotor de la Constitución de 1886.',
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/03-detalle-president.png'),
    );
  });

  testWidgets('02-listado-touristicattraction', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          appBar: AppBar(title: const Text('Atracciones Turísticas')),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ListItemCard(
                title: 'Hacienda Nápoles',
                subtitle:
                    'Parque temático familiar y santuario de protección de fauna y flora.',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Santa Fe de Antioquia',
                subtitle:
                    'Monumento nacional por su arquitectura colonial con 7 iglesias históricas.',
                onTap: () {},
              ),
              ListItemCard(
                title: 'La Ventana al Mundo',
                subtitle:
                    'Monumento público ubicado en Barranquilla en homenaje a la cultura caribeña.',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Catedral de Sal de Zipaquirá',
                subtitle:
                    'Recinto subterráneo construido en el interior de las minas de sal de Zipaquirá.',
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
      matchesGoldenFile(
          '../docs/screenshots/02-listado-touristicattraction.png'),
    );
  });

  testWidgets('03-detalle-touristicattraction', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const DetailView(
          endpoint: 'TouristicAttraction',
          id: 36,
          item: {
            'id': 36,
            'name': 'Hacienda Nápoles',
            'description':
                'La Hacienda Nápoles es un parque temático y centro de entretenimiento familiar a espacio abierto ubicado en Puerto Triunfo, Antioquia. Su eje central es un enorme santuario para la protección de fauna en peligro de extinción, atracciones acuáticas y contenidos culturales.',
            'latitude': '5.887894',
            'longitude': '-74.6418',
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
          '../docs/screenshots/03-detalle-touristicattraction.png'),
    );
  });

  testWidgets('02-listado-region', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          appBar: AppBar(title: const Text('Regiones')),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ListItemCard(
                title: 'Caribe',
                subtitle:
                    'Costas caribeñas, Sierra Nevada de Santa Marta y Parque Nacional Tayrona.',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Pacífico',
                subtitle:
                    'Litoral pacífico, bosques húmedos tropicales y alta biodiversidad mundial.',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Orinoquía',
                subtitle:
                    'Llanos orientales, reservas de gas natural, paisajes de sabana y ganadería.',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Amazonía',
                subtitle:
                    'Pulmón del mundo con más del 10% de la biodiversidad del planeta.',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Andina',
                subtitle:
                    'Centro económico y social del país, hogar de las cordilleras y Bogotá.',
                onTap: () {},
              ),
              ListItemCard(
                title: 'Insular',
                subtitle:
                    'Archipiélago de San Andrés, Providencia, Gorgona y Malpelo en ambos océanos.',
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
      matchesGoldenFile('../docs/screenshots/02-listado-region.png'),
    );
  });

  testWidgets('03-detalle-region', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const DetailView(
          endpoint: 'Region',
          id: 1,
          item: {
            'id': 1,
            'name': 'Caribe',
            'description':
                'La región caribe es una de las regiones más importantes del territorio colombiano. En sus costas hospeda la formación montañosa costera más grande del mundo: la Sierra Nevada de Santa Marta y el Parque Natural Tayrona. Además, posee puertos estratégicos conectados al comercio internacional.',
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/03-detalle-region.png'),
    );
  });

  testWidgets('02-listado-typicaldish', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          appBar: AppBar(title: const Text('Platos Típicos')),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ListItemCard(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber.shade100,
                  child: const Icon(Icons.restaurant, color: Colors.orange),
                ),
                title: 'Bandeja Paisa',
                subtitle:
                    'Frijoles, arroz, carne molida, chicharrón, huevo, plátano, chorizo, arepa.',
                onTap: () {},
              ),
              ListItemCard(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber.shade100,
                  child: const Icon(Icons.restaurant, color: Colors.orange),
                ),
                title: 'Sancocho Antioqueño',
                subtitle:
                    'Carne de res, pollo, plátano verde, yuca, papa, mazorca y cilantro.',
                onTap: () {},
              ),
              ListItemCard(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber.shade100,
                  child: const Icon(Icons.restaurant, color: Colors.orange),
                ),
                title: 'Ajiaco Santafereño',
                subtitle:
                    'Sopa tradicional bogotana con pollo, papas criollas, pastusas, mazorca y guascas.',
                onTap: () {},
              ),
              ListItemCard(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber.shade100,
                  child: const Icon(Icons.restaurant, color: Colors.orange),
                ),
                title: 'Lechona Tolimense',
                subtitle:
                    'Carne de cerdo horneada con arvejas amarillas, arroz y corteza crocante.',
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
      matchesGoldenFile('../docs/screenshots/02-listado-typicaldish.png'),
    );
  });

  testWidgets('03-detalle-typicaldish', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const DetailView(
          endpoint: 'TypicalDish',
          id: 1,
          item: {
            'id': 1,
            'name': 'Bandeja Paisa',
            'description':
                'La bandeja paisa es el orgullo de la cocina paisa y uno de los platos más emblemáticos de Colombia. Originaria de Antioquia y departamentos vecinos, refleja la tradición culinaria y abundancia gastronómica de la región.',
            'ingredients':
                'Frijoles rojos, arroz blanco, carne molida, chicharrón de cerdo, huevo frito, tajadas de plátano maduro, chorizo antioqueño, arepa de maíz y aguacate.',
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/03-detalle-typicaldish.png'),
    );
  });

  testWidgets('04-estado-carga', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          appBar: AppBar(title: const Text('Departamentos')),
          body: const LoadingWidget(
              message: 'Cargando información desde API Colombia...'),
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/04-estado-carga.png'),
    );
  });

  testWidgets('05-estado-error', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          appBar: AppBar(title: const Text('Departamentos')),
          body: ErrorDisplayWidget(
            message:
                'Error al conectar con https://api-colombia.com. Verifique su conexión de red e intente de nuevo.',
            onRetry: () {},
          ),
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/05-estado-error.png'),
    );
  });

  testWidgets('06-estado-vacio', (WidgetTester tester) async {
    configureViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          appBar: AppBar(title: const Text('Departamentos')),
          body: const EmptyWidget(
            message:
                'No se encontraron registros disponibles para este endpoint.',
          ),
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/06-estado-vacio.png'),
    );
  });
}
