import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repository.dart';

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

    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _authRepository.login(email, password);

      if (success) {
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid email or password',
        );
      }
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

  LoginState({
    required this.rememberMe,
    required this.obscurePassword,
    required this.isLoading,
    this.error,
  });

  factory LoginState.initial() {
    return LoginState(
      rememberMe: false,
      obscurePassword: true,
      isLoading: false,
      error: null,
    );
  }

  LoginState copyWith({
    bool? rememberMe,
    bool? obscurePassword,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      rememberMe: rememberMe ?? this.rememberMe,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
