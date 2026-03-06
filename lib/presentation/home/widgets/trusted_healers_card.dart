import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/widgets/cards/chip_with_icon.dart';

class TrustedHealersCard extends StatelessWidget {
  const TrustedHealersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.trustedTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.trustedDesc,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: const [
              ChipWithIcon(icon: Icons.verified, label: AppStrings.whoVerified),
              ChipWithIcon(icon: Icons.people, label: 'Traditional Healers'),
              ChipWithIcon(icon: Icons.groups, label: AppStrings.communityDriven),
              ChipWithIcon(icon: Icons.star, label: AppStrings.accuracy98),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.darkCardBorder),
          const SizedBox(height: 8),
          const Text(
            '• ${AppStrings.alignedStrategy}\n'
            '• ${AppStrings.healersContribute}\n'
            '• ${AppStrings.activeMembers}\n'
            '• ${AppStrings.verifiedSite}',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
