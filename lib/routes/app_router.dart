import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/dashboard_view.dart';
import '../views/list_view.dart';
import '../views/detail_view.dart';

class AppRouter {
  static const String dashboardName = 'dashboard';
  static const String listName = 'list';
  static const String detailName = 'detail';

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: dashboardName,
        builder: (context, state) => const DashboardView(),
      ),
      GoRoute(
        path: '/list/:endpoint',
        name: listName,
        builder: (context, state) {
          final endpoint = state.pathParameters['endpoint']!;
          return EndpointListView(endpoint: endpoint);
        },
      ),
      GoRoute(
        path: '/detail/:endpoint/:id',
        name: detailName,
        builder: (context, state) {
          final endpoint = state.pathParameters['endpoint']!;
          final id = int.parse(state.pathParameters['id']!);
          return DetailView(
            endpoint: endpoint,
            id: id,
            item: state.extra as Map<String, dynamic>?,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Página no encontrada')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Ruta no encontrada: ${state.uri}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.goNamed(dashboardName),
              child: const Text('Volver al Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
}
