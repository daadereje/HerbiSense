import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/languages/strings.dart';
import 'roadmap_widget.dart';

class FutureSection extends StatelessWidget {
  const FutureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryGreen,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.shapingFuture,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            AppStrings.futureDescription,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
              height: 1.6,
            ),
          ),
          SizedBox(height: 16),
          RoadmapWidget(),
        ],
      ),
    );
  }
}
