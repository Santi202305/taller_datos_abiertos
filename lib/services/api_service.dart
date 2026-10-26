import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/env_config.dart';
import 'api_exception.dart';

/// Servicio genérico para consumir la API Colombia.
///
/// Proporciona métodos tipados y sin tipado (raw) para obtener
/// listas de elementos y elementos individuales por ID.
class ApiService {
  final String _baseUrl = EnvConfig.baseUrl;

  /// Obtiene una lista tipada de elementos desde el endpoint indicado.
  Future<List<T>> getAll<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final data = await getAllRaw(endpoint);
    return data.map((json) => fromJson(json)).toList();
  }

  /// Obtiene un elemento tipado por su ID desde el endpoint indicado.
  Future<T> getById<T>(
    String endpoint,
    int id,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final data = await getByIdRaw(endpoint, id);
    return fromJson(data);
  }

  /// Obtiene la lista cruda (raw) de mapas JSON desde el endpoint indicado.
  Future<List<Map<String, dynamic>>> getAllRaw(String endpoint) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al obtener datos de $endpoint',
          statusCode: response.statusCode,
        );
      }

      final String body = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonList = json.decode(body) as List<dynamic>;
      return jsonList.map((item) => item as Map<String, dynamic>).toList();
    } on SocketException {
      throw ApiException(
        'Sin conexión a internet. Verifica tu red e intenta de nuevo.',
      );
    } on TimeoutException {
      throw ApiException('La solicitud tardó demasiado. Intenta de nuevo.');
    } on FormatException {
      throw ApiException('Error al procesar la respuesta del servidor.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Obtiene un único mapa JSON por ID desde el endpoint indicado.
  Future<Map<String, dynamic>> getByIdRaw(String endpoint, int id) async {
    final url = Uri.parse('$_baseUrl/$endpoint/$id');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al obtener el detalle de $endpoint/$id',
          statusCode: response.statusCode,
        );
      }

      final String body = utf8.decode(response.bodyBytes);
      return json.decode(body) as Map<String, dynamic>;
    } on SocketException {
      throw ApiException(
        'Sin conexión a internet. Verifica tu red e intenta de nuevo.',
      );
    } on TimeoutException {
      throw ApiException('La solicitud tardó demasiado. Intenta de nuevo.');
    } on FormatException {
      throw ApiException('Error al procesar la respuesta del servidor.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }
}
