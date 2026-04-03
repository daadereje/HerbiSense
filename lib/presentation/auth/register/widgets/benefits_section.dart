import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/languages/strings.dart';
import '../../../../core/constants/data/models/benefit_model.dart';
import 'benefit_item.dart';

class BenefitsSection extends StatelessWidget {
  final List<BenefitModel> benefits;

  const BenefitsSection({super.key, required this.benefits});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.startYourJourney,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.createAccountDescription,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ...benefits.map(
          (benefit) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: BenefitItem(benefit: benefit),
          ),
        ),
      ],
    );
  }
}
