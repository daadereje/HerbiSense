import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herbisense/config/app_config.dart';
import 'package:herbisense/core/constants/colors.dart';
import 'package:herbisense/core/constants/data/models/herb_model.dart';
import 'package:herbisense/core/constants/data/models/skin_concern_model.dart';
import 'package:herbisense/core/constants/languages/strings.dart';
import 'package:herbisense/core/state/language_provider.dart';
import 'package:herbisense/presentation/recommendations/condition_detail_screen.dart';
import 'package:herbisense/common/network/api_client.dart';
import 'package:http/http.dart' as http;

class HerbDetailScreen extends ConsumerWidget {
  final HerbModel herb;
  const HerbDetailScreen({super.key, required this.herb});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final displayName = herb.nameFor(language);
    final displayUses = herb.usesFor(language);
    final displayPrep = herb.preparationFor(language);
    final displaySafety = herb.safetyFor(language);
    final displaySource = herb.sourceFor(language);
    final scientificNameLabel =
        AppStrings.translate(AppStrings.scientificName, language);
    final conditionsUsedForLabel =
        AppStrings.translate(AppStrings.conditionsUsedFor, language);
    final herbDescriptionLabel =
        AppStrings.translate(AppStrings.herbDescription, language);
    final medicinePreparationLabel =
        AppStrings.translate(AppStrings.medicinePreparation, language);
    final safetyWarningLabel =
        AppStrings.translate(AppStrings.safetyWarning, language);
    final sourceLabel = AppStrings.translate(AppStrings.source, language);
    final noPrepPlaceholder =
        AppStrings.translate(AppStrings.noPreparationInstructions, language);
    final noSafetyPlaceholder =
        AppStrings.translate(AppStrings.noSafetyWarnings, language);
    final imageLabel = AppStrings.translate(AppStrings.image, language);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
        title: Text(
          displayName,
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
              "$scientificNameLabel: ${herb.scientificName}",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.secondaryGreen,
                fontSize: 14,
              ),
            ),
            if (herb.conditions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                conditionsUsedForLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...herb.conditions.map(
                (condition) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConditionDetailScreen(
                              concern: condition,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.healing,
                                size: 18, color: AppColors.secondaryGreen),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: condition.titleFor(language),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    if (condition
                                        .descriptionFor(language)
                                        .trim()
                                        .isNotEmpty)
                                      TextSpan(
                                        text:
                                            ': ${condition.descriptionFor(language)}',
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              if (herb.conditionName != null && herb.conditionName!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        final selectedCondition = SkinConcernModel.initial(
                          herb.conditionName!,
                          herb.conditionDescription ?? '',
                          id: herb.conditionId != null
                              ? int.tryParse(herb.conditionId!)
                              : null,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConditionDetailScreen(
                              concern: selectedCondition,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.healing,
                                size: 18, color: AppColors.secondaryGreen),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: herb.conditionName!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    if (herb.conditionDescription != null &&
                                        herb.conditionDescription!.isNotEmpty)
                                      TextSpan(
                                        text: ': ${herb.conditionDescription!}',
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (herb.skinConditions.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  conditionsUsedForLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: herb.skinConditions
                      .map(
                        (condition) => Chip(
                          label: Text(
                            condition,
                            style: const TextStyle(fontSize: 12),
                          ),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: AppColors.cardBackground,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
            const SizedBox(height: 20),
            _section(
              title: herbDescriptionLabel,
              value: displayUses,
            ),
            _section(
              title: medicinePreparationLabel,
              value: displayPrep,
              placeholder: noPrepPlaceholder,
            ),
            _section(
              title: safetyWarningLabel,
              value: displaySafety,
              placeholder: noSafetyPlaceholder,
            ),
            if (displaySource.isNotEmpty)
              _section(
                title: sourceLabel,
                value: displaySource,
                valueStyle: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
              ),
            const SizedBox(height: 12),
            _HerbImageBox(herb: herb, title: imageLabel),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required String value,
    String placeholder = 'Not provided.',
    TextStyle? valueStyle,
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
            style: valueStyle ??
                const TextStyle(
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

class _HerbImageBox extends StatefulWidget {
  final HerbModel herb;
  final String title;
  const _HerbImageBox({required this.herb, required this.title});

  @override
  State<_HerbImageBox> createState() => _HerbImageBoxState();
}

class _HerbImageBoxState extends State<_HerbImageBox> {
  late List<String> _candidates;
  int _index = 0;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _candidates = [];
    _resolveUploadApis();
  }

  Future<void> _resolveUploadApis() async {
    // Try to replace /uploads/{id} JSON endpoints with the actual image_url
    final baseCandidates = _imageCandidates(widget.herb);
    final List<String> resolved = [];
    for (final url in baseCandidates) {
      if (_looksLikeUploadApi(url)) {
        final img = await _fetchUploadImageUrl(url);
        if (img != null && img.isNotEmpty) {
          resolved.add(img);
          continue;
        }
        // if resolution fails, skip the raw /uploads/{id} URL to avoid 404s
        continue;
      }
      resolved.add(url);
    }
    if (mounted) {
      setState(() {
        _candidates = resolved;
        _index = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _candidates.isEmpty
                ? _placeholder(isLoading: false)
                : Image.network(
                    _candidates[_index],
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return _placeholder(isLoading: true);
                    },
                    errorBuilder: (_, err, ___) {
                      _lastError = '$err';
                      if (_index < _candidates.length - 1) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) setState(() => _index += 1);
                        });
                        return const SizedBox.shrink();
                      }
                      debugPrint(
                          'Herb detail image load failed: ${_candidates[_index]} ($_lastError)');
                      return _placeholder(isLoading: false);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder({required bool isLoading}) {
    return Container(
      color: Colors.grey[100],
      alignment: Alignment.center,
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.image_not_supported_outlined,
              color: Colors.grey, size: 36),
    );
  }

  bool _looksLikeUploadApi(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final last = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    final hasExt = last.contains('.') && last.split('.').length > 1;
    return uri.path.contains('/uploads') && !hasExt;
  }

  Future<String?> _fetchUploadImageUrl(String url) async {
    try {
      final resp = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          if (ApiClient.authToken != null)
            'Authorization': 'Bearer ${ApiClient.authToken}',
        },
      ).timeout(const Duration(seconds: 8));
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final decoded = jsonDecode(resp.body);
        if (decoded is Map &&
            decoded['data'] is List &&
            decoded['data'].isNotEmpty) {
          final first = decoded['data'][0];
          if (first is Map && first['image_url'] != null) {
            return first['image_url'].toString();
          }
        }
      }
    } catch (_) {
      // ignore and let fallback handle it
    }
    return null;
  }

  List<String> _imageCandidates(HerbModel herb) {
    final direct = _normalizeRelativeImage(herb.imageUrl);
    return [
      if (direct != null && direct.isNotEmpty) direct,
      _buildUploadUrl(herb.id, withHerbsSegment: true, keepApiPrefix: true),
      _buildUploadUrl(herb.id, withHerbsSegment: false, keepApiPrefix: true),
      _buildUploadUrl(herb.id, withHerbsSegment: true, keepApiPrefix: false),
      _buildUploadUrl(herb.id, withHerbsSegment: false, keepApiPrefix: false),
    ];
  }

  String _buildUploadUrl(
    String herbId, {
    required bool withHerbsSegment,
    required bool keepApiPrefix,
  }) {
    final base = AppConfig.apiBaseUrl;
    final uri = Uri.parse(base);
    var path = uri.path;
    if (path.endsWith('/')) path = path.substring(0, path.length - 1);
    if (!keepApiPrefix && path.endsWith('/api')) {
      path = path.substring(0, path.length - 4);
    }
    final uploadPath = withHerbsSegment
        ? '$path/uploads/herbs/$herbId'
        : '$path/uploads/$herbId';
    return uri.replace(path: uploadPath).toString();
  }

  String? _normalizeRelativeImage(String? url) {
    if (url == null || url.isEmpty) return null;
    final parsed = Uri.tryParse(url);
    if (parsed != null && parsed.hasScheme) return url;

    final base = Uri.parse(AppConfig.apiBaseUrl);
    var path = base.path;
    if (path.endsWith('/')) path = path.substring(0, path.length - 1);
    // Keep /api for relative assets; backend likely serves them under the same prefix.

    final resolvedPath = url.startsWith('/') ? '$path$url' : '$path/$url';
    return base.replace(path: resolvedPath).toString();
  }
}
