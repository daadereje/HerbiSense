import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/network/api_client.dart';
import '../../../../common/network/api_endpoints.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRepository(apiClient, ref);
});

/// Global auth token provider to trigger dependent listeners when token changes.
final authTokenProvider = StateProvider<String?>((ref) => ApiClient.authToken);

class AuthRepository {
  AuthRepository(this._apiClient, this._ref);

  final Ref _ref;

  static UserModel? _cachedUser;
  static const _tokenKey = 'auth_token';

  final ApiClient _apiClient;

  Future<bool> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response is Map<String, dynamic>) {
      final data = response['data'] ?? response;
      if (data is Map<String, dynamic>) {
        final rawToken = data['token'] ?? data['access_token'];
        if (rawToken != null) {
          ApiClient.authToken = rawToken.toString();
          _ref.read(authTokenProvider.notifier).state = ApiClient.authToken;
          await _persistToken(ApiClient.authToken);
        }
        if (data['user'] != null && data['user'] is Map<String, dynamic>) {
          _cachedUser = UserModel.fromJson(
              Map<String, dynamic>.from(data['user'] as Map<String, dynamic>));
          if (ApiClient.authToken != null) {
            _cachedUser = _cachedUser!.copyWith(token: ApiClient.authToken);
          }
        }
        return ApiClient.authToken != null;
      }
    }

    return false;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      body: {
        // Send both snake_case and camelCase for compatibility with backend parsers
        'full_name': fullName.trim(),
        'fullName': fullName.trim(),
        'email': email.trim(),
        'password': password,
      },
    );

    if (response is Map<String, dynamic>) {
      final data = response['data'] ?? response;
      if (data is Map<String, dynamic>) {
        final rawToken = data['token'] ?? data['access_token'];
        if (rawToken != null) {
          ApiClient.authToken = rawToken.toString();
          _ref.read(authTokenProvider.notifier).state = ApiClient.authToken;
          await _persistToken(ApiClient.authToken);
        }
        if (data['user'] != null && data['user'] is Map<String, dynamic>) {
          _cachedUser = UserModel.fromJson(
            Map<String, dynamic>.from(data['user'] as Map<String, dynamic>),
          );
          if (ApiClient.authToken != null) {
            _cachedUser = _cachedUser!.copyWith(token: ApiClient.authToken);
          }
        }
        return ApiClient.authToken != null;
      }
    }

    return false;
  }

  Future<void> logout() async {
    await _apiClient.post(ApiEndpoints.logout);
    ApiClient.authToken = null;
    _ref.read(authTokenProvider.notifier).state = null;
    await _clearToken();
  }

  Future<UserModel?> getCurrentUser() async {
    // Serve cached user first to avoid flashing errors.
    if (_cachedUser != null) return _cachedUser;
    if (ApiClient.authToken == null) {
      await restoreSession();
      if (ApiClient.authToken == null) return null;
    }

    try {
      final response = await _apiClient.get(ApiEndpoints.currentUser);
      if (response is Map<String, dynamic>) {
        final payload = response['data'] ?? response;
        if (payload is Map<String, dynamic>) {
          final userMap = payload['user'] ?? payload;
          final user = UserModel.fromJson(
              Map<String, dynamic>.from(userMap as Map<String, dynamic>));
          final rawToken = payload['token'] ?? payload['access_token'];
          if (rawToken != null) {
            ApiClient.authToken = rawToken.toString();
            _cachedUser = user.copyWith(token: rawToken.toString());
            await _persistToken(ApiClient.authToken);
          } else {
            _cachedUser = user;
          }
        }
      }
    } catch (_) {
      // ignore errors
    }

    return _cachedUser;
  }

  Future<bool> resetPassword(String email) async {
    final response = await _apiClient.post(
      ApiEndpoints.resetPassword,
      body: {'email': email},
    );

    return response != null;
  }

  static Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null && token.isNotEmpty) {
      ApiClient.authToken = token;
    }
  }

  static Future<void> _persistToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null || token.isEmpty) {
      await prefs.remove(_tokenKey);
    } else {
      await prefs.setString(_tokenKey, token);
    }
  }

  static Future<void> _clearToken() => _persistToken(null);
}
