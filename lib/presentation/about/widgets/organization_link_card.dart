import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class OrganizationLinkCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String link;

  const OrganizationLinkCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                link,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.secondaryGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.secondaryGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
