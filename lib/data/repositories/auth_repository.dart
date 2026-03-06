import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthRepository {
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty && fullName.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel.getMockUser();
  }

  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
