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
    final nameTrimmed = fullName.trim();
    final emailTrimmed = email.trim();
    final passwordTrimmed = password;
    final confirmTrimmed = confirmPassword;

    if (nameTrimmed.isEmpty ||
        emailTrimmed.isEmpty ||
        passwordTrimmed.isEmpty ||
        confirmTrimmed.isEmpty) {
      state = state.copyWith(error: AppStrings.fillAllFields);
      return false;
    }

    if (passwordTrimmed != confirmTrimmed) {
      state = state.copyWith(error: AppStrings.passwordsDoNotMatch);
      return false;
    }

    if (passwordTrimmed.length < 6) {
      state = state.copyWith(error: AppStrings.passwordTooShort);
      return false;
    }

    if (!_isValidEmail(emailTrimmed)) {
      state = state.copyWith(error: AppStrings.invalidEmail);
      return false;
    }

    if (!state.agreeToTerms) {
      state = state.copyWith(error: AppStrings.mustAgreeToTerms);
      return false;
    }

    state = state.copyWith(isLoading: true, error: null, registerSuccess: false);

    try {
      final success = await _authRepository.register(
        fullName: nameTrimmed,
        email: emailTrimmed,
        password: passwordTrimmed,
      );

      if (success) {
        state = state.copyWith(isLoading: false, registerSuccess: true);
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
  final bool registerSuccess;

  RegisterState({
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.agreeToTerms,
    required this.isLoading,
    required this.registerSuccess,
    this.error,
    required this.benefits,
  });

  factory RegisterState.initial() {
    return RegisterState(
      obscurePassword: true,
      obscureConfirmPassword: true,
      agreeToTerms: false,
      isLoading: false,
      registerSuccess: false,
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
    bool? registerSuccess,
  }) {
    return RegisterState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      benefits: benefits ?? this.benefits,
      registerSuccess: registerSuccess ?? this.registerSuccess,
    );
  }
}
