import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/languages/strings.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF0A3B0A),
      child: Column(
        children: [
          const Text(
            AppStrings.commitmentStatement,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textLight,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.footer,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
