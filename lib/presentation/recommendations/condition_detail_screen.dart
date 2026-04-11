import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/data/models/skin_concern_model.dart';
import '../../core/constants/languages/condition_detail_strings.dart';
import '../../core/state/language_provider.dart';

class ConditionDetailScreen extends ConsumerWidget {
  final SkinConcernModel concern;

  const ConditionDetailScreen({super.key, required this.concern});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final title = concern.titleFor(language);
    final strings = ConditionDetailStrings.fromLanguage(language);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.textPrimary),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConditionDetailContent(
          concern: concern,
          strings: strings,
          language: language,
        ),
      ),
    );
  }
}

class ConditionDetailSheet extends ConsumerWidget {
  final SkinConcernModel concern;

  const ConditionDetailSheet({super.key, required this.concern});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final strings = ConditionDetailStrings.fromLanguage(language);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ConditionDetailContent(
                concern: concern,
                strings: strings,
                language: language,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConditionDetailContent extends ConsumerWidget {
  final SkinConcernModel concern;
  final ConditionDetailStrings strings;
  final String language;

  const ConditionDetailContent({
    super.key,
    required this.concern,
    required this.strings,
    required this.language,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final description = concern.descriptionFor(language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 7),
        Text(
          strings.conditionDetails,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _DetailRow(
            label: strings.conditionName, value: concern.titleFor(language)),
        _DetailRow(label: strings.conditionDescription, value: description),
        if (concern.linkedHerbName?.isNotEmpty == true)
          _DetailRow(
              label: strings.primaryHerb, value: concern.linkedHerbName!),
        if (concern.herbs.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            strings.recommendedHerbs,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ...concern.herbs.asMap().entries.map((entry) => _HerbInfoSection(
                herb: entry.value,
                language: language,
                strings: strings,
                isLast: entry.key == concern.herbs.length - 1,
              )),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HerbInfoSection extends StatelessWidget {
  final ConditionHerbModel herb;
  final String language;
  final ConditionDetailStrings strings;
  final bool isLast;

  const _HerbInfoSection({
    required this.herb,
    required this.language,
    required this.strings,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Herb Used (name)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (herb.ratingValue != null) ...[
              const Icon(Icons.star, size: 16, color: AppColors.secondaryGreen),
              const SizedBox(width: 6),
              Text(
                herb.ratingValue!.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryGreen,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                herb.nameFor(language),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Herb Scientific Name
        Text(
          herb.scientificName,
          style: const TextStyle(
            color: AppColors.secondaryGreen,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
        // Herb Image
        if (herb.imageUrl?.isNotEmpty == true) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              herb.imageUrl!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, size: 50),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Herb Status and Rating
        if (herb.descriptionFor(language).isNotEmpty) ...[
          Text(
            strings.medicineDescription,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            herb.descriptionFor(language),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Medicine Preparation
        if (herb.preparationFor(language).isNotEmpty) ...[
          Text(
            strings.medicinePreparation,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            herb.preparationFor(language),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Safety Warning
        if (herb.safetyFor(language).isNotEmpty) ...[
          Text(
            strings.safetyWarning,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            herb.safetyFor(language),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],

        // Divider between herbs
        if (!isLast) ...[
          const SizedBox(height: 20),
          Divider(color: Colors.grey.shade300, thickness: 1),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
