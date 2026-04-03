import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/languages/strings.dart';
import 'value_pill.dart';

class ValuesSection extends StatelessWidget {
  const ValuesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.accuracyRespectCommunity,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.valuesDescription,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValuePill(label: AppStrings.stabilityTips, icon: Icons.science),
              SizedBox(width: 12),
              ValuePill(label: AppStrings.culturalInsight, icon: Icons.public),
              SizedBox(width: 12),
              ValuePill(label: AppStrings.balanceHarmony, icon: Icons.balance),
            ],
          ),
        ],
      ),
    );
  }
}
