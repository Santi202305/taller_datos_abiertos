/// Excepción personalizada para errores de la API.
class ApiException implements Exception {
  /// Mensaje descriptivo del error.
  final String message;

  /// Código de estado HTTP, si aplica.
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}
