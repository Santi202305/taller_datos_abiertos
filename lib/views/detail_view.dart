import 'package:flutter/material.dart';

import '../services/api_exception.dart';
import '../services/api_service.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

/// Pantalla de detalle que muestra la información completa de un registro.
///
/// Puede recibir los datos por `extra` (navegación desde la lista) o
/// cargarlos por ID desde la API (acceso directo por URL).
class DetailView extends StatefulWidget {
  /// Nombre del endpoint (ej: 'Department', 'President').
  final String endpoint;

  /// ID del registro a mostrar.
  final int id;

  /// Datos opcionales pasados por navegación (extra).
  final Map<String, dynamic>? item;

  const DetailView({
    super.key,
    required this.endpoint,
    required this.id,
    this.item,
  });

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  Map<String, dynamic>? _data;
  bool _isLoading = true;
  String? _errorMessage;

  /// Mapeo de endpoint a título en español.
  static const Map<String, String> _endpointTitles = {
    'Department': 'Departamento',
    'President': 'Presidente',
    'TouristicAttraction': 'Atracción Turística',
    'Region': 'Región',
    'TypicalDish': 'Plato Típico',
  };

  /// Etiquetas en español para los campos del JSON.
  static const Map<String, String> _fieldLabels = {
    'name': 'Nombre',
    'lastName': 'Apellido',
    'description': 'Descripción',
    'politicalParty': 'Partido Político',
    'startPeriodDate': 'Inicio del Periodo',
    'endPeriodDate': 'Fin del Periodo',
    'municipalities': 'Municipios',
    'surface': 'Superficie (km²)',
    'population': 'Población',
    'phonePrefix': 'Prefijo Telefónico',
    'ingredients': 'Ingredientes',
    'latitude': 'Latitud',
    'longitude': 'Longitud',
  };

  /// Campos que no se muestran en la vista de detalle.
  static const Set<String> _hiddenFields = {
    'id',
    'cityCapitalId',
    'countryId',
    'regionId',
    'cityId',
    'departmentId',
    'image',
    'imageUrl',
    'images',
    'cityCapital',
    'country',
    'cities',
    'region',
    'naturalAreas',
    'maps',
    'indigenousReservations',
    'airports',
    'city',
    'department',
  };

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _data = widget.item;
      _isLoading = false;
    } else {
      _fetchDetail();
    }
  }

  /// Obtiene los datos del detalle desde la API cuando no se pasaron por extra.
  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final service = ApiService();
      final result = await service.getByIdRaw(widget.endpoint, widget.id);
      _data = result;
      _isLoading = false;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      _isLoading = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _endpointTitles[widget.endpoint] ?? widget.endpoint;

    return Scaffold(
      appBar: AppBar(title: Text('Detalle de $title')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando detalle...');
    }

    if (_errorMessage != null) {
      return ErrorDisplayWidget(message: _errorMessage!, onRetry: _fetchDetail);
    }

    if (_data == null) {
      return const Center(child: Text('No se encontraron datos'));
    }

    return _buildDetailContent(_data!);
  }

  Widget _buildDetailContent(Map<String, dynamic> data) {
    // Intentar obtener una imagen para mostrar en la parte superior
    final imageUrl = data['image'] as String? ?? data['imageUrl'] as String?;
    final images = data['images'] as List<dynamic>?;
    final firstImage =
        imageUrl ??
        (images != null && images.isNotEmpty ? images[0] as String? : null);

    // Filtrar campos visibles
    final visibleEntries = data.entries
        .where((e) => !_hiddenFields.contains(e.key) && e.value != null)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen principal si existe
          if (firstImage != null) _buildImageHeader(firstImage),

          // Título principal
          if (data['name'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                widget.endpoint == 'President'
                    ? '${data['name']} ${data['lastName'] ?? ''}'.trim()
                    : data['name'].toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

          // Tarjeta con todos los campos relevantes
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  ...visibleEntries.map((entry) {
                    final label =
                        _fieldLabels[entry.key] ?? _formatFieldName(entry.key);
                    final value = entry.value.toString();
                    return _buildInfoRow(label, value);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la cabecera con imagen.
  Widget _buildImageHeader(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              height: 220,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 220,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.broken_image,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Construye una fila de información (etiqueta + valor).
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  /// Formatea un nombre de campo camelCase a texto legible.
  String _formatFieldName(String fieldName) {
    final result = fieldName.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => ' ${match.group(0)}',
    );
    return result[0].toUpperCase() + result.substring(1);
  }
}
