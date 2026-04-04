import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/languages/recommendations_strings.dart';

class TipsCard extends StatelessWidget {
  final RecommendationsStrings strings;
  const TipsCard({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: AppColors.secondaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                strings.tipsForBestResults,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTip(strings.tip1),
          _buildTip(strings.tip2),
          _buildTip(strings.tip3),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14, color: AppColors.secondaryGreen)),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
