import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/widgets/navigation/top_navigation_bar.dart';
import 'register_view_model.dart';
import 'widgets/register_hero.dart';
import 'widgets/benefits_section.dart';
import 'widgets/register_form.dart';
import '../../../core/widgets/shared/footer_widget.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registerViewModelProvider.notifier).clearError();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerViewModelProvider);
    final notifier = ref.read(registerViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopNavigationBar(),
              const RegisterHero(),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: BenefitsSection(
                        benefits: state.benefits,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 7,
                      child: RegisterForm(
                        fullNameController: _fullNameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        obscurePassword: state.obscurePassword,
                        obscureConfirmPassword: state.obscureConfirmPassword,
                        agreeToTerms: state.agreeToTerms,
                        isLoading: state.isLoading,
                        error: state.error,
                        onTogglePassword: notifier.togglePasswordVisibility,
                        onToggleConfirmPassword: notifier.toggleConfirmPasswordVisibility,
                        onTermsChanged: notifier.toggleTermsAgreement,
                        onSubmit: () => _handleRegister(notifier),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegister(RegisterViewModel notifier) {
    notifier
        .register(
          fullName: _fullNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        )
        .then((success) {
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.accountCreated),
            backgroundColor: AppColors.secondaryGreen,
          ),
        );
      }
    });
  }
}
