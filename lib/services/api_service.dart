import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/route.dart';
import '../utils/api_constants.dart';

class ApiService {
  final SharedPreferences sharedPreferences;

  ApiService({required this.sharedPreferences});

  /// Prevents parallel 401s from firing multiple logouts / refreshes.
  bool _logoutInProgress = false;
  Future<bool>? _refreshInFlight;

  // GET request
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    return _sendWithAuthRetry(
      url,
      (hdrs) => http.get(Uri.parse(url), headers: hdrs),
      headers: headers,
    );
  }

  // POST request
  Future<dynamic> post(String url,
      {dynamic body, Map<String, String>? headers}) async {
    return _sendWithAuthRetry(
      url,
      (hdrs) => http.post(
        Uri.parse(url),
        headers: hdrs,
        body: _encodeJsonBody(body),
      ),
      headers: headers,
    );
  }

  // Multipart request (supports POST, PATCH, etc.)
  Future<dynamic> multipartRequest(
    String url, {
    String method = 'POST',
    Map<String, String>? fields,
    Map<String, String>? files,
    Map<String, List<int>>? fileBytes,
    Map<String, String>? fileNames,
    Map<String, String>? headers,
  }) async {
    return _sendWithAuthRetry(
      url,
      (hdrs) async {
        final request = http.MultipartRequest(method, Uri.parse(url));
        final requestHeaders = Map<String, String>.from(hdrs)
          ..remove('Content-Type');
        request.headers.addAll(requestHeaders);

        if (fields != null) {
          request.fields.addAll(fields);
        }

        if (fileBytes != null) {
          for (final entry in fileBytes.entries) {
            if (entry.value.isEmpty) continue;
            final filename = fileNames?[entry.key] ?? '${entry.key}.jpg';
            final mimeType = mime(filename) ?? 'image/jpeg';
            request.files.add(http.MultipartFile.fromBytes(
              entry.key,
              entry.value,
              filename: filename,
              contentType: MediaType.parse(mimeType),
            ));
          }
        } else if (files != null) {
          for (final entry in files.entries) {
            if (entry.value.isNotEmpty) {
              final mimeType = mime(entry.value);
              request.files.add(await http.MultipartFile.fromPath(
                entry.key,
                entry.value,
                contentType:
                    mimeType != null ? MediaType.parse(mimeType) : null,
              ));
            }
          }
        }

        final streamedResponse = await request.send();
        return http.Response.fromStream(streamedResponse);
      },
      headers: headers,
    );
  }

  // Multipart POST request (deprecated in favor of multipartRequest)
  Future<dynamic> multipartPost(String url,
      {Map<String, String>? fields,
      Map<String, String>? files,
      Map<String, String>? headers}) async {
    return multipartRequest(url,
        method: 'POST', fields: fields, files: files, headers: headers);
  }

  // PUT request
  Future<dynamic> put(String url,
      {dynamic body, Map<String, String>? headers}) async {
    return _sendWithAuthRetry(
      url,
      (hdrs) => http.put(
        Uri.parse(url),
        headers: hdrs,
        body: _encodeJsonBody(body),
      ),
      headers: headers,
    );
  }

  // DELETE request
  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    return _sendWithAuthRetry(
      url,
      (hdrs) => http.delete(Uri.parse(url), headers: hdrs),
      headers: headers,
    );
  }

  // PATCH request
  Future<dynamic> patch(String url,
      {dynamic body, Map<String, String>? headers}) async {
    return _sendWithAuthRetry(
      url,
      (hdrs) => http.patch(
        Uri.parse(url),
        headers: hdrs,
        body: _encodeJsonBody(body),
      ),
      headers: headers,
    );
  }

  /// Runs [request] with auth headers. On 401, tries one token refresh + retry;
  /// if that fails (or refresh is impossible), clears the session and goes to sign-in.
  Future<dynamic> _sendWithAuthRetry(
    String url,
    Future<http.Response> Function(Map<String, String> headers) request, {
    Map<String, String>? headers,
    bool retried = false,
  }) async {
    try {
      final hdrs = headers ?? await _getHeaders();
      final response = await request(hdrs);

      if (_isUnauthorized(response) &&
          !_isPublicAuthUrl(url) &&
          !_logoutInProgress) {
        if (!retried) {
          final refreshed = await _refreshAccessToken();
          if (refreshed) {
            return _sendWithAuthRetry(
              url,
              request,
              headers: null, // rebuild with new access token
              retried: true,
            );
          }
        }
        await forceLogout(
          reason: _messageFromResponse(response) ??
              'Session expired. Please sign in again.',
        );
        throw ApiError(
          message: 'Session expired. Please sign in again.',
          statusCode: response.statusCode,
        );
      }

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  bool _isUnauthorized(http.Response response) {
    if (response.statusCode == 401) return true;
    if (response.statusCode != 403) return false;
    final msg = (_messageFromResponse(response) ?? '').toLowerCase();
    return msg.contains('token') ||
        msg.contains('unauthorized') ||
        msg.contains('unauthenticated') ||
        msg.contains('invalidated');
  }

  /// Auth flows that may legitimately return 401 (wrong password, OTP, etc.).
  bool _isPublicAuthUrl(String url) {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    const publicPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/auth/forgot-password',
      '/auth/verify-forgot-password-otp',
      '/auth/resend-forgot-password-otp',
      '/auth/reset-password',
      '/auth/verify-email',
      '/auth/resend-verification-otp',
      '/auth/reset-password/verify-otp',
      '/users/check-username',
    ];
    return publicPaths.any(path.contains);
  }

  String? _messageFromResponse(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['message'] != null) {
        return body['message'].toString();
      }
    } catch (_) {}
    return null;
  }

  Future<bool> _refreshAccessToken() async {
    if (_refreshInFlight != null) {
      return _refreshInFlight!;
    }

    _refreshInFlight = () async {
      final refreshToken =
          sharedPreferences.getString(ApiConstants.keyRefreshToken);
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      try {
        final response = await http.post(
          Uri.parse(ApiConstants.refreshToken),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        );

        if (response.statusCode < 200 || response.statusCode >= 300) {
          return false;
        }

        final body = jsonDecode(response.body);
        if (body is! Map || body['success'] != true) {
          return false;
        }

        final data = body['data'];
        // Backend may return tokens nested or flat.
        final tokens = data is Map
            ? (data['tokens'] is Map ? data['tokens'] as Map : data)
            : null;
        if (tokens == null) return false;

        final access = tokens['accessToken']?.toString();
        final refresh = tokens['refreshToken']?.toString() ?? refreshToken;
        if (access == null || access.isEmpty) return false;

        await saveTokens(
          accessToken: access,
          refreshToken: refresh,
          accessTokenExpiresAt:
              tokens['accessTokenExpiresAt']?.toString() ?? '',
          refreshTokenExpiresAt:
              tokens['refreshTokenExpiresAt']?.toString() ?? '',
        );
        return true;
      } catch (e) {
        debugPrint('Token refresh failed: $e');
        return false;
      }
    }();

    try {
      return await _refreshInFlight!;
    } finally {
      _refreshInFlight = null;
    }
  }

  /// Clears local session and navigates to sign-in (once).
  Future<void> forceLogout({String? reason}) async {
    if (_logoutInProgress) return;
    _logoutInProgress = true;
    try {
      await clearUserData();
      final route = Get.currentRoute;
      final onAuthGate = route == AppRoutes.signInScreen ||
          route == AppRoutes.onboardScreen ||
          route == AppRoutes.splashScreen;
      if (!onAuthGate) {
        Get.offAllNamed(AppRoutes.signInScreen);
      }
      if (reason != null && reason.isNotEmpty) {
        debugPrint('Forced logout: $reason');
      }
    } finally {
      // Keep lock briefly so parallel 401s don't re-enter mid-navigation.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      _logoutInProgress = false;
    }
  }

  String _encodeJsonBody(dynamic body) {
    if (body == null) return jsonEncode(<String, dynamic>{});
    return jsonEncode(body);
  }

  // Handle response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final raw = response.body.trim();

    dynamic body;
    if (raw.isEmpty) {
      body = <String, dynamic>{'success': statusCode >= 200 && statusCode < 300};
    } else {
      try {
        body = jsonDecode(raw);
      } catch (_) {
        if (statusCode >= 200 && statusCode < 300) {
          return <String, dynamic>{'success': true, 'message': raw};
        }
        throw ApiError(
          message: raw.isNotEmpty ? raw : 'Something went wrong',
          statusCode: statusCode,
        );
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    }

    String errorMessage = 'Something went wrong';
    if (body is Map) {
      if (body['message'] != null) {
        if (body['message'] is List) {
          final messages = body['message'] as List;
          if (messages.isNotEmpty) {
            final firstError = messages[0];
            if (firstError is Map && firstError['constraints'] != null) {
              final constraints = firstError['constraints'];
              if (constraints is Map && constraints.isNotEmpty) {
                errorMessage = constraints.values.first.toString();
              }
            } else if (firstError is Map && firstError['message'] != null) {
              errorMessage = firstError['message'].toString();
            } else {
              errorMessage = firstError.toString();
            }
          }
        } else if (body['message'] is Map) {
          errorMessage = jsonEncode(body['message']);
        } else {
          errorMessage = body['message'].toString();
        }
      } else if (body['errors'] != null) {
        final errors = body['errors'];
        if (errors is List && errors.isNotEmpty) {
          errorMessage = errors.map((e) => e.toString()).join(', ');
        } else {
          errorMessage = errors.toString();
        }
      } else if (body['error'] != null) {
        errorMessage = body['error'].toString();
      }
    } else {
      errorMessage = body.toString();
    }

    throw ApiError(
      message: errorMessage,
      statusCode: statusCode,
    );
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
    final accessToken =
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
    _logoutInProgress = false;
  }

  // Save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await sharedPreferences.setString(
        ApiConstants.keyUserData, jsonEncode(userData));
    await sharedPreferences.setBool(ApiConstants.keyIsLoggedIn, true);
    _logoutInProgress = false;
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
