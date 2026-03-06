import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../buttons/nav_button.dart';

class TopNavigationBar extends StatelessWidget {
  const TopNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                AppStrings.appTagline,
                style: TextStyle(
                  fontSize: 8,
                  color: AppColors.secondaryGreen,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          NavButton(label: 'Home', onPressed: () {}),
          NavButton(label: 'Herbs', onPressed: () {}),
          NavButton(label: 'Recommendation', onPressed: () {}),
          NavButton(label: 'About', onPressed: () {}),
          NavButton(label: 'Contact', onPressed: () {}),
          _buildLanguageSelector(),
          const SizedBox(width: 8),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondaryGreen),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'EN',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.secondaryGreen,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryGreen,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text('Login'),
    );
  }
}
