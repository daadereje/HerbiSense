import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class StatsSection extends StatelessWidget {
  final int totalHerbs;
  final int publishedCount;
  final String lastSync;

  const StatsSection({
    super.key,
    required this.totalHerbs,
    required this.publishedCount,
    required this.lastSync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Herbs', totalHerbs.toString()),
          _buildStatItem('Published', publishedCount.toString()),
          _buildStatItem('Last Sync', lastSync),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryGreen,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
