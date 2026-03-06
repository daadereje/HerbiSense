import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';

class MissionSection extends StatelessWidget {
  const MissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.ourMission,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            AppStrings.missionDescription1,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          SizedBox(height: 12),
          Text(
            AppStrings.missionDescription2,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}
