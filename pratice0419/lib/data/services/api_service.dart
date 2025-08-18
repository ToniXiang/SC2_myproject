import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/app_constants.dart';

class ApiService {
  /// Sends a POST request to the specified endpoint with the given body.
  static Future<Map<String, dynamic>> postRequest(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Token $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'HTTP POST request failed. Status code: ${response.statusCode}, Response: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('HTTP POST request encountered an error: $e');
    }
  }

  /// Sends a GET request to the specified endpoint.
  static Future<dynamic> getRequest(String endpoint, {String? token}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else if (decoded is List) {
          return decoded;
        } else {
          throw Exception('API 回傳格式非 Map 或 List');
        }
      } else {
        throw Exception(
          'HTTP GET request failed. Status code: ${response.statusCode}, Response: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('HTTP GET request encountered an error: $e');
    }
  }
}
