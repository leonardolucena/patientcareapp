import 'dart:convert';
import 'package:http/http.dart' as http;

/// Gateway centralizado para chamadas HTTP
/// 
/// Responsável por:
/// - Configurar URLs base
/// - Fazer chamadas HTTP (GET, POST, PUT, DELETE)
/// - Tratar erros de rede
/// - Adicionar headers padrão
class ApiGateway {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  
  final http.Client _client;

  ApiGateway({http.Client? client}) : _client = client ?? http.Client();

  /// Headers padrão para todas as requisições
  Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  /// GET request
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await _client.get(
        url,
        headers: {..._defaultHeaders, ...?headers},
      );
      
      _checkResponse(response);
      return response;
    } catch (e) {
      throw ApiException('Erro ao fazer requisição GET: $e');
    }
  }

  /// POST request
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await _client.post(
        url,
        headers: {..._defaultHeaders, ...?headers},
        body: body != null ? json.encode(body) : null,
      );
      
      _checkResponse(response);
      return response;
    } catch (e) {
      throw ApiException('Erro ao fazer requisição POST: $e');
    }
  }

  /// PUT request
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await _client.put(
        url,
        headers: {..._defaultHeaders, ...?headers},
        body: body != null ? json.encode(body) : null,
      );
      
      _checkResponse(response);
      return response;
    } catch (e) {
      throw ApiException('Erro ao fazer requisição PUT: $e');
    }
  }

  /// DELETE request
  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await _client.delete(
        url,
        headers: {..._defaultHeaders, ...?headers},
      );
      
      _checkResponse(response);
      return response;
    } catch (e) {
      throw ApiException('Erro ao fazer requisição DELETE: $e');
    }
  }

  /// Verifica o status da resposta
  void _checkResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return; // Sucesso
    }

    switch (response.statusCode) {
      case 400:
        throw ApiException('Requisição inválida (400)');
      case 401:
        throw ApiException('Não autorizado (401)');
      case 403:
        throw ApiException('Acesso negado (403)');
      case 404:
        throw ApiException('Recurso não encontrado (404)');
      case 500:
        throw ApiException('Erro interno do servidor (500)');
      default:
        throw ApiException(
          'Erro na requisição (${response.statusCode})',
        );
    }
  }

  /// Fecha o client HTTP
  void dispose() {
    _client.close();
  }
}

/// Exceção customizada para erros de API
class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}

