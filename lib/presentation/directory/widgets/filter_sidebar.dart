import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';

class FilterSidebar extends StatelessWidget {
  final String selectedCondition;
  final Function(String) onConditionSelected;

  const FilterSidebar({
    super.key,
    required this.selectedCondition,
    required this.onConditionSelected,
  });

  final List<String> _skinConditions = const [
    'All Conditions',
    'Acute inflammation',
    'Downitis',
    'Itching',
    'Dry Skin',
    'Skin infections',
    'Scars',
    'Aging Skin',
  ];

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
          const Text(
            AppStrings.skinCondition,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._skinConditions.map((condition) {
            final isSelected = selectedCondition == condition;
            return GestureDetector(
              onTap: () => onConditionSelected(condition),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cardBackground : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (isSelected)
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.secondaryGreen,
                        size: 18,
                      ),
                    const SizedBox(width: 4),
                    Text(
                      condition,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.secondaryGreen : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
