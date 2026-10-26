import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_router.dart';
import '../services/api_exception.dart';
import '../services/api_service.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/list_item_card.dart';
import '../widgets/loading_widget.dart';

/// Enum para controlar el estado de la pantalla.
enum DataState { loading, success, error }

/// Pantalla de listado genérica para cualquier endpoint de la API.
class EndpointListView extends StatefulWidget {
  /// Nombre del endpoint a consultar (ej: 'Department', 'President').
  final String endpoint;

  const EndpointListView({super.key, required this.endpoint});

  @override
  State<EndpointListView> createState() => _EndpointListViewState();
}

class _EndpointListViewState extends State<EndpointListView> {
  DataState _state = DataState.loading;
  List<Map<String, dynamic>> _items = [];
  String _errorMessage = '';

  /// Mapeo de endpoint a título en español para el AppBar.
  static const Map<String, String> _endpointTitles = {
    'Department': 'Departamentos',
    'President': 'Presidentes',
    'TouristicAttraction': 'Atracciones Turísticas',
    'Region': 'Regiones',
    'TypicalDish': 'Platos Típicos',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Obtiene los datos del endpoint desde la API.
  Future<void> _loadData() async {
    setState(() {
      _state = DataState.loading;
    });

    try {
      final service = ApiService();
      final response = await service.getAllRaw(widget.endpoint);
      _items = response;
      _state = DataState.success;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _state = DataState.error;
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      _state = DataState.error;
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Extrae el subtítulo de un elemento según el endpoint.
  String _getSubtitle(Map<String, dynamic> item) {
    switch (widget.endpoint) {
      case 'Department':
        final pop = item['population'];
        final mun = item['municipalities'];
        if (pop != null && mun != null) {
          return 'Población: $pop · Municipios: $mun';
        }
        return item['description']?.toString().substring(
              0,
              (item['description']?.toString().length ?? 0) > 80
                  ? 80
                  : item['description']?.toString().length ?? 0,
            ) ??
            'Sin descripción';
      case 'President':
        final lastName = item['lastName'] ?? '';
        final party = item['politicalParty'] ?? '';
        return '$lastName · $party';
      case 'TouristicAttraction':
        return item['description']?.toString().substring(
              0,
              (item['description']?.toString().length ?? 0) > 80
                  ? 80
                  : item['description']?.toString().length ?? 0,
            ) ??
            'Sin descripción';
      case 'Region':
        return item['description']?.toString().substring(
              0,
              (item['description']?.toString().length ?? 0) > 80
                  ? 80
                  : item['description']?.toString().length ?? 0,
            ) ??
            'Sin descripción';
      case 'TypicalDish':
        return item['ingredients']?.toString() ?? 'Sin ingredientes';
      default:
        return item['description']?.toString() ?? '';
    }
  }

  /// Extrae el título de un elemento según el endpoint.
  String _getTitle(Map<String, dynamic> item) {
    if (widget.endpoint == 'President') {
      final name = item['name'] ?? '';
      final lastName = item['lastName'] ?? '';
      return '$name $lastName'.trim();
    }
    return item['name']?.toString() ?? 'Sin nombre';
  }

  /// Devuelve un ícono leading según el tipo de endpoint.
  Widget? _getLeadingWidget(Map<String, dynamic> item) {
    // Para presidentes, mostrar la imagen si está disponible
    if (widget.endpoint == 'President' && item['image'] != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(item['image'] as String),
        onBackgroundImageError: (exception, stackTrace) {},
      );
    }
    // Para platos típicos, mostrar la imagen si está disponible
    if (widget.endpoint == 'TypicalDish' && item['imageUrl'] != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(item['imageUrl'] as String),
        onBackgroundImageError: (exception, stackTrace) {},
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final title = _endpointTitles[widget.endpoint] ?? widget.endpoint;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case DataState.loading:
        return const LoadingWidget(message: 'Cargando datos...');
      case DataState.error:
        return ErrorDisplayWidget(message: _errorMessage, onRetry: _loadData);
      case DataState.success:
        if (_items.isEmpty) {
          return const EmptyWidget(message: 'No se encontraron elementos');
        }
        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return ListItemCard(
                title: _getTitle(item),
                subtitle: _getSubtitle(item),
                leading: _getLeadingWidget(item),
                onTap: () {
                  context.pushNamed(
                    AppRouter.detailName,
                    pathParameters: {
                      'endpoint': widget.endpoint,
                      'id': item['id'].toString(),
                    },
                    extra: item,
                  );
                },
              );
            },
          ),
        );
    }
  }
}
