import 'package:flutter/material.dart';
import 'package:herbisense/core/constants/colors.dart';
import 'package:herbisense/data/models/herb_model.dart';

class HerbDetailScreen extends StatelessWidget {
  final HerbModel herb;
  const HerbDetailScreen({super.key, required this.herb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
        title: Text(
          herb.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              herb.scientificName,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.secondaryGreen,
                fontSize: 14,
              ),
            ),
            if (herb.conditionName != null && herb.conditionName!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.healing,
                        size: 18, color: AppColors.secondaryGreen),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        herb.conditionName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (herb.conditionDescription != null &&
                herb.conditionDescription!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  herb.conditionDescription!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            _section(
              title: 'Description',
              value: herb.description,
            ),
            _section(
              title: 'Preparation',
              value: herb.preparation ?? '',
              placeholder: 'No preparation instructions provided.',
            ),
            _section(
              title: 'Safety Warning',
              value: herb.safetyWarning ?? '',
              placeholder: 'No safety warnings provided.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required String value,
    String placeholder = 'Not provided.',
  }) {
    final display = value.trim().isEmpty ? placeholder : value.trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            display,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
