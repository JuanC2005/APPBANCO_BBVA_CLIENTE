import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client _client = http.Client();

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'auth_token');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> get(String path) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await _client
        .get(url, headers: await _headers())
        .timeout(ApiConfig.timeout);
    return _handleResponse(response);
  }

  Future<List<dynamic>> getList(String path) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await _client
        .get(url, headers: await _headers())
        .timeout(ApiConfig.timeout);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw HttpException('Error ${response.statusCode}: ${response.body}');
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await _client
        .post(url, headers: await _headers(), body: jsonEncode(body))
        .timeout(ApiConfig.timeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await _client
        .put(url, headers: await _headers(), body: jsonEncode(body))
        .timeout(ApiConfig.timeout);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw HttpException('Error ${response.statusCode}: ${response.body}');
  }

  void dispose() {
    _client.close();
  }
}
