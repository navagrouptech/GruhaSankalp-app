import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';
import 'storage_service.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  String? get token => _token;

  Map<String, String> _buildHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final activeToken = _token ?? StorageService.instance.getAccessToken();
    if (activeToken != null && activeToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $activeToken';
    }
    return headers;
  }

  Uri _uri(String path, [Map<String, dynamic>? queryParams]) {
    final base = AppEnv.apiUrl.replaceAll(RegExp(r'/+$'), '');
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final fullUrl = '$base$cleanPath';
    if (queryParams != null && queryParams.isNotEmpty) {
      final filtered = <String, String>{};
      queryParams.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          filtered[key] = value.toString();
        }
      });
      return Uri.parse(fullUrl).replace(queryParameters: filtered);
    }
    return Uri.parse(fullUrl);
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParams, Duration timeout = const Duration(seconds: 10)}) async {
    try {
      final response = await http
          .get(_uri(path, queryParams), headers: _buildHeaders())
          .timeout(timeout);
      return _processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(String path, {dynamic body, Duration timeout = const Duration(seconds: 15)}) async {
    try {
      final response = await http
          .post(
            _uri(path),
            headers: _buildHeaders(),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);
      return _processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patch(String path, {dynamic body, Duration timeout = const Duration(seconds: 10)}) async {
    try {
      final response = await http
          .patch(
            _uri(path),
            headers: _buildHeaders(),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);
      return _processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(String path, {Duration timeout = const Duration(seconds: 10)}) async {
    try {
      final response = await http
          .delete(_uri(path), headers: _buildHeaders())
          .timeout(timeout);
      return _processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          return decoded['data'];
        }
        return decoded;
      } catch (_) {
        return response.body;
      }
    } else {
      String errMsg = 'Request failed with status $statusCode';
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded.containsKey('message')) {
          errMsg = decoded['message'].toString();
        }
      } catch (_) {}
      throw ApiException(statusCode, errMsg);
    }
  }
}
