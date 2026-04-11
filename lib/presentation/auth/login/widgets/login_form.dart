import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/languages/auth_strings.dart';
import '../../../../core/widgets/inputs/email_field.dart';
import '../../../../core/widgets/inputs/password_field.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final Function(bool?) onRememberMeChanged;
  final VoidCallback onSubmit;
  final bool isLoading;
  final String? error;
  final AuthStrings strings;

  LoginForm({
    super.key,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onSubmit,
    required this.isLoading,
    required this.strings,
    this.error,
  })  : emailController = emailController ??
            TextEditingController(text: 'admin@herbisense.com'),
        passwordController =
            passwordController ?? TextEditingController(text: 'admin123');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error!,
                      style: TextStyle(color: Colors.red[700], fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            strings.emailAddress,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          EmailField(
            controller: emailController,
            hintText: strings.yourEmail,
          ),
          const SizedBox(height: 20),
          Text(
            strings.password,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          PasswordField(
            controller: passwordController,
            hintText: strings.enterPassword,
          ),
          const SizedBox(height: 16),
          _buildRememberMeRow(),
          const SizedBox(height: 24),
          _buildSignInButton(),
          const SizedBox(height: 16),
          _buildSignUpLink(context),
        ],
      ),
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: rememberMe,
            onChanged: onRememberMeChanged,
            activeColor: AppColors.secondaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          strings.rememberMe,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondaryGreen,
          ),
          child: Text(strings.forgotPassword),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryGreen,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    strings.signIn,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          strings.noAccount,
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: isLoading
              ? null
              : () {
                  context.go('/register');
                },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondaryGreen,
          ),
          child: Text(
            strings.signUp,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
