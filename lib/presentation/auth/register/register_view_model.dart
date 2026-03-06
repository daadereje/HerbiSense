import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/strings.dart';
import '../../../data/models/benefit_model.dart';
import '../../../data/repositories/auth_repository.dart';

final registerViewModelProvider = StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterViewModel(authRepository);
});

class RegisterViewModel extends StateNotifier<RegisterState> {
  final AuthRepository _authRepository;

  RegisterViewModel(this._authRepository) : super(RegisterState.initial());

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
  }

  void toggleTermsAgreement(bool? value) {
    state = state.copyWith(agreeToTerms: value ?? false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      state = state.copyWith(error: AppStrings.fillAllFields);
      return false;
    }

    if (password != confirmPassword) {
      state = state.copyWith(error: AppStrings.passwordsDoNotMatch);
      return false;
    }

    if (password.length < 6) {
      state = state.copyWith(error: AppStrings.passwordTooShort);
      return false;
    }

    if (!_isValidEmail(email)) {
      state = state.copyWith(error: AppStrings.invalidEmail);
      return false;
    }

    if (!state.agreeToTerms) {
      state = state.copyWith(error: AppStrings.mustAgreeToTerms);
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _authRepository.register(
        fullName: fullName,
        email: email,
        password: password,
      );

      if (success) {
        state = state.copyWith(isLoading: false);
        return true;
      }

      state = state.copyWith(
        isLoading: false,
        error: AppStrings.registrationFailed,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}

class RegisterState {
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool agreeToTerms;
  final bool isLoading;
  final String? error;
  final List<BenefitModel> benefits;

  RegisterState({
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.agreeToTerms,
    required this.isLoading,
    this.error,
    required this.benefits,
  });

  factory RegisterState.initial() {
    return RegisterState(
      obscurePassword: true,
      obscureConfirmPassword: true,
      agreeToTerms: false,
      isLoading: false,
      error: null,
      benefits: BenefitModel.getRegisterBenefits(),
    );
  }

  RegisterState copyWith({
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? agreeToTerms,
    bool? isLoading,
    String? error,
    List<BenefitModel>? benefits,
  }) {
    return RegisterState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      benefits: benefits ?? this.benefits,
    );
  }
}
