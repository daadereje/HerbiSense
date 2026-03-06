import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import 'login_view_model.dart';
import 'widgets/login_header.dart';
import 'widgets/login_form.dart';
import 'widgets/features_section.dart';
import 'widgets/login_footer.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final notifier = ref.read(loginViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const LoginHeader(),
              const SizedBox(height: 30),
              _buildWelcomeMessage(),
              const SizedBox(height: 30),
              LoginForm(
                emailController: _emailController,
                passwordController: _passwordController,
                rememberMe: state.rememberMe,
                onRememberMeChanged: notifier.toggleRememberMe,
                onSubmit: () => notifier.login(
                  _emailController.text,
                  _passwordController.text,
                ),
                isLoading: state.isLoading,
                error: state.error,
              ),
              const SizedBox(height: 30),
              const FeaturesSection(),
              const SizedBox(height: 30),
              const LoginFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.welcomeBack,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.signInToContinue,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
