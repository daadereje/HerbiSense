import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import 'api_exception.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    client: http.Client(),
  );
});

class ApiClient {
  ApiClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  static String? authToken;
  final String baseUrl;
  final http.Client _client;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParams);
    final response = await _client.get(uri, headers: _buildHeaders(headers));
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParams);
    final response = await _client.post(
      uri,
      headers: _buildHeaders(headers),
      body: body == null ? null : jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParams);
    final response = await _client.put(
      uri,
      headers: _buildHeaders(headers),
      body: body == null ? null : jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParams);
    final response = await _client.delete(
      uri,
      headers: _buildHeaders(headers),
      body: body == null ? null : jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Uri _buildUri(String path, Map<String, dynamic>? queryParams) {
    final base = Uri.parse(baseUrl);
    final normalizedPath = _joinPaths(base.path, path);
    return base.replace(
      path: normalizedPath,
      queryParameters:
          queryParams?.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  String _joinPaths(String basePath, String path) {
    final cleanBase = basePath.endsWith('/')
        ? basePath.substring(0, basePath.length - 1)
        : basePath;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    if (cleanBase.isEmpty) return '/$cleanPath';
    return '$cleanBase/$cleanPath';
  }

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    final authHeader =
        authToken != null ? {'Authorization': 'Bearer $authToken'} : {};
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...authHeader,
      ...?headers,
    };
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = _safeDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    }

    throw ApiException(
      statusCode: statusCode,
      message: _extractErrorMessage(body) ?? 'Request failed',
      details: body,
    );
  }

  String? _extractErrorMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      return body['message']?.toString() ?? body['error']?.toString();
    }
    return null;
  }

  dynamic _safeDecode(String raw) {
    if (raw.isEmpty) return null;
    try {
      return jsonDecode(raw);
    } catch (_) {
      // Return raw string when response isn't valid JSON
      return raw;
    }
  }
}
