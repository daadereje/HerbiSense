import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import 'legacy_feature_card.dart';

class LegacySection extends StatelessWidget {
  const LegacySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.legacyTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            AppStrings.legacyDescription1,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          SizedBox(height: 12),
          Text(
            AppStrings.legacyDescription2,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          SizedBox(height: 12),
          Text(
            AppStrings.legacyDescription3,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: LegacyFeatureCard(
                  title: AppStrings.traditionalHealing,
                  subtitle: AppStrings.traditionalMedicineCenters,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: LegacyFeatureCard(
                  title: AppStrings.wholesomeIngredients,
                  subtitle: AppStrings.naturalIngredients,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: LegacyFeatureCard(
                  title: AppStrings.digitalPreservation,
                  subtitle: AppStrings.digitalPreservationCenters,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
