import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.discoverHerbiSense,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.bridgingWisdom,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.herbiSenseDescription,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.herbiSenseMission,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
