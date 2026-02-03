import 'dart:convert';

import 'package:http/http.dart' as http;

import 'constants.dart';
import 'logger_helper.dart';

class ApiClient {
  static Uri _buildUri(String path, [Map<String, String>? query]) {
    final baseUrl = AppConstants.appsScriptBaseUrl;
    final sanitizedPath = path.replaceFirst('/', '');
    final queryParams = <String, String>{'path': sanitizedPath};
    if (query != null) {
      queryParams.addAll(query);
    }
    return Uri.parse(baseUrl).replace(queryParameters: queryParams);
  }

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = _buildUri(path);
    LoggerHelper.logger.i('POST $uri');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    LoggerHelper.logger.i('Response ${response.statusCode}: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('API error: ${response.statusCode}');
  }

  static Future<List<dynamic>> getList(
    String path,
    Map<String, String> query,
  ) async {
    final uri = _buildUri(path, query);
    LoggerHelper.logger.i('GET $uri');
    final response = await http.get(uri);
    LoggerHelper.logger.i('Response ${response.statusCode}: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded;
      }
      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        return decoded['data'] as List<dynamic>;
      }
      return [];
    }
    throw Exception('API error: ${response.statusCode}');
  }
}
