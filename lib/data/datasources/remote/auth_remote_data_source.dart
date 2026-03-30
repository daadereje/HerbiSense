import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/network/api_client.dart';
import '../../../common/network/api_endpoints.dart';
import '../../models/user_model.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  return AuthRemoteDataSource(client);
});

class AuthRemoteDataSource {
  final ApiClient _client;

  AuthRemoteDataSource(this._client);

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> data =
        await _client.post(ApiEndpoints.login, body: {'email': email, 'password': password});
    return data['success'] == true || data['token'] != null;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> data = await _client.post(ApiEndpoints.register, body: {
      'fullName': fullName,
      'email': email,
      'password': password,
    });
    return data['success'] == true;
  }

  Future<void> logout() async {
    await _client.post(ApiEndpoints.logout);
  }

  Future<UserModel?> getCurrentUser() async {
    final Map<String, dynamic> data = await _client.get(ApiEndpoints.currentUser);
    final dynamic userData = data['data'] ?? data['user'] ?? data;
    if (userData is Map<String, dynamic>) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  Future<bool> resetPassword(String email) async {
    final Map<String, dynamic> data =
        await _client.post(ApiEndpoints.resetPassword, body: {'email': email});
    return data['success'] == true;
  }
}
