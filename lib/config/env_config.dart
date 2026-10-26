import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuración de variables de entorno para la aplicación.
class EnvConfig {
  /// URL base de la API Colombia.
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://api-colombia.com/api/v1';
}
