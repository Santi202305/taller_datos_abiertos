import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_router.dart';
import '../widgets/dashboard_card.dart';

/// Pantalla principal (Dashboard) que muestra las categorías de la API.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  /// Lista de endpoints disponibles con su configuración visual.
  static const List<Map<String, dynamic>> _endpoints = [
    {
      'key': 'Department',
      'title': 'Departamentos',
      'description': 'Departamentos de Colombia',
      'icon': 'map',
    },
    {
      'key': 'President',
      'title': 'Presidentes',
      'description': 'Presidentes de Colombia',
      'icon': 'person',
    },
    {
      'key': 'TouristicAttraction',
      'title': 'Atracciones Turísticas',
      'description': 'Lugares turísticos destacados',
      'icon': 'place',
    },
    {
      'key': 'Region',
      'title': 'Regiones',
      'description': 'Regiones naturales del país',
      'icon': 'public',
    },
    {
      'key': 'TypicalDish',
      'title': 'Platos Típicos',
      'description': 'Gastronomía colombiana',
      'icon': 'restaurant',
    },
  ];

  /// Convierte el nombre del ícono a un IconData de Material.
  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'map':
        return Icons.map;
      case 'person':
        return Icons.person;
      case 'place':
        return Icons.place;
      case 'public':
        return Icons.public;
      case 'restaurant':
        return Icons.restaurant;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Colombia'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Datos Abiertos de Colombia',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withAlpha(200),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.95,
          ),
          itemCount: _endpoints.length,
          itemBuilder: (context, index) {
            final endpoint = _endpoints[index];
            return DashboardCard(
              icon: _getIcon(endpoint['icon'] as String),
              title: endpoint['title'] as String,
              description: endpoint['description'] as String,
              onTap: () {
                context.pushNamed(
                  AppRouter.listName,
                  pathParameters: {'endpoint': endpoint['key'] as String},
                );
              },
            );
          },
        ),
      ),
    );
  }
}
