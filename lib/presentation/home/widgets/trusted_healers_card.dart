import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/languages/home_strings.dart';
import '../../../core/widgets/cards/chip_with_icon.dart';

class TrustedHealersCard extends StatelessWidget {
  final HomeStrings strings;

  const TrustedHealersCard({super.key, required this.strings});

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
        mainAxisSize: MainAxisSize.min, // This is important!
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.trustedTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            strings.trustedDesc,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          // Use LayoutBuilder to make chips responsive
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  ChipWithIcon(icon: Icons.verified, label: strings.whoVerified),
                  ChipWithIcon(icon: Icons.people, label: strings.traditionalWisdom),
                  ChipWithIcon(icon: Icons.groups, label: strings.communityDriven),
                  ChipWithIcon(icon: Icons.star, label: strings.accuracy98),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.darkCardBorder),
          const SizedBox(height: 8),

          Text(
            '• ${strings.alignedStrategy}\n'
            '• ${strings.healersContribute}\n'
            '• ${strings.verifiedSite}',
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          // Add a tiny bit of extra padding at the bottom
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
