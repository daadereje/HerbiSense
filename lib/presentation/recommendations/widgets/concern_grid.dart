import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/data/models/skin_concern_model.dart';

class ConcernGrid extends StatelessWidget {
  final List<SkinConcernModel> concerns;
  final Function(BuildContext, int) onConcernTap;
  final String language;

  const ConcernGrid({
    super.key,
    required this.concerns,
    required this.onConcernTap,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: concerns.length,
      itemBuilder: (context, index) {
        final concern = concerns[index];
        return GestureDetector(
          onTap: () => onConcernTap(context, index),
          child: ConcernCard(concern: concern, language: language),
        );
      },
    );
  }
}

class ConcernCard extends StatelessWidget {
  final SkinConcernModel concern;
  final String language;

  const ConcernCard({super.key, required this.concern, required this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: concern.selected ? AppColors.cardBackground : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: concern.selected ? AppColors.secondaryGreen : AppColors.cardBorder,
          width: concern.selected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  concern.titleFor(language),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (concern.selected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.secondaryGreen,
                  size: 18,
                ),
            ],
          ),
          Text(
            concern.descriptionFor(language),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (concern.severity > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                concern.severityText,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.secondaryGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
