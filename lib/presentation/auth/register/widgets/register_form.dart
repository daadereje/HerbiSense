import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/inputs/text_field_with_icon.dart';
import '../../../../core/widgets/inputs/password_field_with_icon.dart';
import 'terms_checkbox.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool agreeToTerms;
  final bool isLoading;
  final String? error;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final Function(bool?) onTermsChanged;
  final VoidCallback onSubmit;

  const RegisterForm({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.agreeToTerms,
    required this.isLoading,
    this.error,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onTermsChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.createAccount,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.signUpToExplore,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
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
          _buildFieldLabel(AppStrings.fullName),
          const SizedBox(height: 6),
          TextFieldWithIcon(
            controller: fullNameController,
            hintText: AppStrings.enterFullName,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildFieldLabel(AppStrings.emailAddress),
          const SizedBox(height: 6),
          TextFieldWithIcon(
            controller: emailController,
            hintText: AppStrings.enterEmail,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildFieldLabel(AppStrings.password),
          const SizedBox(height: 6),
          PasswordFieldWithIcon(
            controller: passwordController,
            hintText: AppStrings.createPassword,
            obscureText: obscurePassword,
            onToggle: onTogglePassword,
          ),
          const SizedBox(height: 16),
          _buildFieldLabel(AppStrings.confirmPassword),
          const SizedBox(height: 6),
          PasswordFieldWithIcon(
            controller: confirmPasswordController,
            hintText: AppStrings.confirmYourPassword,
            obscureText: obscureConfirmPassword,
            onToggle: onToggleConfirmPassword,
          ),
          const SizedBox(height: 20),
          TermsCheckbox(
            value: agreeToTerms,
            onChanged: onTermsChanged,
          ),
          const SizedBox(height: 24),
          _buildCreateAccountButton(),
          const SizedBox(height: 16),
          _buildSignInLink(),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryGreen,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
            : const Text(
                AppStrings.createAccount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount,
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondaryGreen,
          ),
          child: const Text(
            AppStrings.signIn,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
