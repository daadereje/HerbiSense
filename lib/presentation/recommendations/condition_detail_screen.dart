import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/data/models/skin_concern_model.dart';
import '../../core/state/language_provider.dart';

class ConditionDetailScreen extends ConsumerWidget {
  final SkinConcernModel concern;

  const ConditionDetailScreen({super.key, required this.concern});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final title = concern.titleFor(language);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
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
        child: ConditionDetailContent(concern: concern),
      ),
    );
  }
}

class ConditionDetailSheet extends ConsumerWidget {
  final SkinConcernModel concern;

  const ConditionDetailSheet({super.key, required this.concern});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ConditionDetailContent(concern: concern),
            ],
          ),
        ),
      ),
    );
  }
}

class ConditionDetailContent extends ConsumerWidget {
  final SkinConcernModel concern;

  const ConditionDetailContent({super.key, required this.concern});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final description = concern.descriptionFor(language);
    final hasTranslation = concern.translatedTitle?.isNotEmpty == true ||
        concern.translatedDescription?.isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (concern.id != null)
        //   Text(
        //     'Condition ID: ${concern.id}',
        //     style: const TextStyle(
        //       color: AppColors.secondaryGreen,
        //       fontSize: 12,
        //     ),
        //   ),
        // if (concern.id != null) const SizedBox(height: 10),
        // Text(
        //   'Overview',
        //   style: const TextStyle(
        //     fontWeight: FontWeight.w700,
        //     color: AppColors.textPrimary,
        //     fontSize: 16,
        //   ),
        // ),
        // const SizedBox(height: 8),
        // Text(
        //   description.isNotEmpty ? description : 'No details available.',
        //   style: const TextStyle(
        //     color: AppColors.textSecondary,
        //     fontSize: 14,
        //     height: 1.5,
        //   ),
        // ),
        if (hasTranslation) ...[
          // const SizedBox(height: 24),
          const Text(
            'Translation',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          if (concern.translatedTitle?.isNotEmpty == true)
            _DetailRow(
              label: 'Translated Condition',
              value: concern.translatedTitle!,
            ),
          if (concern.translatedDescription?.isNotEmpty == true)
            _DetailRow(
              label: 'Translated Description',
              value: concern.translatedDescription!,
            ),
          // if (concern.translationLanguage?.isNotEmpty == true)
          //   _DetailRow(
          //     label: 'Language',
          //     value: concern.translationLanguage!,
          //   ),
        ],
        const SizedBox(height: 24),
        const Text(
          'Original',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _DetailRow(label: 'Condition', value: concern.title),
        _DetailRow(label: 'Description', value: concern.description),
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
