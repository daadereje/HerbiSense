import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class HerbCard extends StatelessWidget {
  final dynamic herb;

  const HerbCard({
    super.key,
    required this.herb,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      herb.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      herb.scientificName,
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              _buildViewCount(herb.views),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            herb.description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryChip(herb.category),
              _buildViewButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewCount(int views) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.remove_red_eye_outlined,
            size: 14,
            color: AppColors.secondaryGreen,
          ),
          const SizedBox(width: 4),
          Text(
            views.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.secondaryGreen,
        ),
      ),
    );
  }

  Widget _buildViewButton() {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondaryGreen,
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child: const Row(
        children: [
          Text('View', style: TextStyle(fontWeight: FontWeight.w500)),
          Icon(Icons.arrow_forward, size: 16),
        ],
      ),
    );
  }
}
