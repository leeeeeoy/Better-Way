import 'dart:convert';
import 'package:better_way/core/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<http.Response> post(String path, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$path');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(data);

    if (kDebugMode) {
      print('API Request: POST $url');
      print('Headers: $headers');
      print('Body: $body');
    }

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (kDebugMode) {
        print('API Response: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }
      rethrow;
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final workerBaseUrl = appConfig.baseUrl;

  return ApiService(workerBaseUrl);
});
