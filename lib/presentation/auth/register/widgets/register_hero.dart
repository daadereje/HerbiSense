import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/buttons/primary_button.dart';

class RegisterHero extends StatelessWidget {
  const RegisterHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            AppStrings.appTagline,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: () {},
            label: AppStrings.joinEnthusiasts,
            isOutlined: true,
            textColor: AppColors.secondaryGreen,
            backgroundColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}
