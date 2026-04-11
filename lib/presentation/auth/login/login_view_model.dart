import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/data/repositories/auth_repository.dart';
import '../../../common/network/api_exception.dart';

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginViewModel(authRepository);
});

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository) : super(LoginState.initial());

  void toggleRememberMe(bool? value) {
    state = state.copyWith(rememberMe: value ?? false);
  }

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        error: 'Please fill in all fields',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null, loginSuccess: false);

    try {
      final success = await _authRepository.login(email, password);

      if (success) {
        state = state.copyWith(isLoading: false, loginSuccess: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'invalid credential',
        );
      }
    } on ApiException catch (e) {
      final isAuthError = e.statusCode == 400 || e.statusCode == 401;
      state = state.copyWith(
        isLoading: false,
        error: isAuthError ? 'invalid credential' : e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class LoginState {
  final bool rememberMe;
  final bool obscurePassword;
  final bool isLoading;
  final String? error;
  final bool loginSuccess;

  LoginState({
    required this.rememberMe,
    required this.obscurePassword,
    required this.isLoading,
    required this.loginSuccess,
    this.error,
  });

  factory LoginState.initial() {
    return LoginState(
      rememberMe: false,
      obscurePassword: true,
      isLoading: false,
      loginSuccess: false,
      error: null,
    );
  }

  LoginState copyWith({
    bool? rememberMe,
    bool? obscurePassword,
    bool? isLoading,
    String? error,
    bool? loginSuccess,
  }) {
    return LoginState(
      rememberMe: rememberMe ?? this.rememberMe,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      loginSuccess: loginSuccess ?? this.loginSuccess,
    );
  }
}
