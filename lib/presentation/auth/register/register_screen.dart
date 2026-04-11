import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:herbisense/core/widgets/navigation/app_bottom_nav_bar.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/languages/strings.dart';
import 'register_view_model.dart';
import '../../profile/profile_screen.dart'
    show ProfileScreen, currentUserProvider;
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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

    ref.listen(registerViewModelProvider, (prev, next) {
      if (next.registerSuccess) {
        ref.invalidate(currentUserProvider);
        context.go('/profile');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const TopNavigationBar(),
              const RegisterHero(),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 800;

                    final benefitsSection =
                        BenefitsSection(benefits: state.benefits);

                    final formSection = RegisterForm(
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
                      onToggleConfirmPassword:
                          notifier.toggleConfirmPasswordVisibility,
                      onTermsChanged: notifier.toggleTermsAgreement,
                      onSubmit: () => _handleRegister(notifier),
                    );

                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          benefitsSection,
                          const SizedBox(height: 24),
                          formSection,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: benefitsSection),
                        const SizedBox(width: 30),
                        Expanded(flex: 7, child: formSection),
                      ],
                    );
                  },
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
