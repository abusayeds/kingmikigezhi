import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class ApiService {
  final SharedPreferences sharedPreferences;

  ApiService({required this.sharedPreferences});

  // GET request
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers ?? await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<dynamic> post(String url,
      {dynamic body, Map<String, String>? headers}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers ?? await _getHeaders(),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Multipart POST request
  Future<dynamic> multipartPost(String url,
      {Map<String, String>? fields,
      Map<String, String>? files,
      Map<String, String>? headers}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      var defaultHeaders = await _getHeaders();
      defaultHeaders.remove('Content-Type'); // MultipartRequest sets its own Content-Type
      if (headers != null) {
        defaultHeaders.addAll(headers);
      }
      request.headers.addAll(defaultHeaders);

      // Add fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add files
      if (files != null) {
        for (var entry in files.entries) {
          request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value));
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<dynamic> put(String url,
      {dynamic body, Map<String, String>? headers}) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers ?? await _getHeaders(),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers ?? await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH request
  Future<dynamic> patch(String url,
      {dynamic body, Map<String, String>? headers}) async {
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers ?? await _getHeaders(),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Handle response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = jsonDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    } else {
      String errorMessage = 'Something went wrong';

      // Handle different error response formats
      if (body['message'] != null) {
        if (body['message'] is List) {
          // Handle validation errors array format
          List messages = body['message'];
          if (messages.isNotEmpty) {
            var firstError = messages[0];
            if (firstError['constraints'] != null) {
              // Extract first constraint message
              var constraints = firstError['constraints'];
              errorMessage = constraints.values.first;
            } else if (firstError['message'] != null) {
              errorMessage = firstError['message'];
            } else {
              errorMessage = firstError.toString();
            }
          }
        } else {
          // Simple string message
          errorMessage = body['message'];
        }
      } else if (body['error'] != null) {
        errorMessage = body['error'];
      }

      throw ApiError(
        message: errorMessage,
        statusCode: statusCode,
      );
    }
  }

  // Handle errors
  String _handleError(dynamic error) {
    if (error is ApiError) {
      return error.message;
    }
    if (error is http.ClientException) {
      return 'Network error. Please check your connection.';
    }
    if (error is FormatException) {
      return 'Invalid response format.';
    }
    return 'An unexpected error occurred.';
  }

  // Get headers
  Future<Map<String, String>> _getHeaders() async {
    String? accessToken =
        sharedPreferences.getString(ApiConstants.keyAccessToken);

    return {
      'Content-Type': 'application/json',
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
    };
  }

  // Save tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String accessTokenExpiresAt,
    required String refreshTokenExpiresAt,
  }) async {
    await sharedPreferences.setString(ApiConstants.keyAccessToken, accessToken);
    await sharedPreferences.setString(
        ApiConstants.keyRefreshToken, refreshToken);
    await sharedPreferences.setString(
        ApiConstants.keyAccessTokenExpiresAt, accessTokenExpiresAt);
    await sharedPreferences.setString(
        ApiConstants.keyRefreshTokenExpiresAt, refreshTokenExpiresAt);
  }

  // Save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await sharedPreferences.setString(
        ApiConstants.keyUserData, jsonEncode(userData));
    await sharedPreferences.setBool(ApiConstants.keyIsLoggedIn, true);
  }

  // Get access token
  String? getAccessToken() {
    return sharedPreferences.getString(ApiConstants.keyAccessToken);
  }

  // Clear user data (logout)
  Future<void> clearUserData() async {
    await sharedPreferences.remove(ApiConstants.keyAccessToken);
    await sharedPreferences.remove(ApiConstants.keyRefreshToken);
    await sharedPreferences.remove(ApiConstants.keyAccessTokenExpiresAt);
    await sharedPreferences.remove(ApiConstants.keyRefreshTokenExpiresAt);
    await sharedPreferences.remove(ApiConstants.keyUserData);
    await sharedPreferences.setBool(ApiConstants.keyIsLoggedIn, false);
  }
}

class ApiError implements Exception {
  final String message;
  final int statusCode;

  ApiError({required this.message, required this.statusCode});

  @override
  String toString() => message;
}
