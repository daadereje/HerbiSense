import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeaturePill({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: AppColors.cardBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.secondaryGreen,
            size: 28,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
