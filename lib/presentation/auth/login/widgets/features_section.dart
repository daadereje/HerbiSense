import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import 'feature_item.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
            AppStrings.continueJourney,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.journeyDescription,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          const FeatureItem(
            icon: Icons.person_outline,
            title: AppStrings.personalizedRecommendations,
            subtitle: AppStrings.tailoredSuggestions,
          ),
          const SizedBox(height: 12),
          const FeatureItem(
            icon: Icons.bookmark_border,
            title: AppStrings.saveFavorites,
            subtitle: AppStrings.bookmarkHerbs,
          ),
          const SizedBox(height: 12),
          const FeatureItem(
            icon: Icons.groups,
            title: AppStrings.communityAccess,
            subtitle: AppStrings.connectWithHealers,
          ),
        ],
      ),
    );
  }
}
