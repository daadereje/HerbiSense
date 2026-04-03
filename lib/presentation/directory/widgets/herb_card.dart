import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/network/api_exception.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/data/repositories/saved_herbs_repository.dart';

class HerbCard extends ConsumerStatefulWidget {
  final dynamic herb;

  const HerbCard({
    super.key,
    required this.herb,
  });

  @override
  ConsumerState<HerbCard> createState() => _HerbCardState();
}

class _HerbCardState extends ConsumerState<HerbCard> {
  bool _saving = false;
  bool _saved = false;

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
                      widget.herb.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.herb.scientificName,
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBookmarkButton(context),
                  const SizedBox(width: 8),
                  _buildViewCount(widget.herb.views),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.herb.description,
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
              _buildCategoryChip(widget.herb.category),
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

  Widget _buildBookmarkButton(BuildContext context) {
    return IconButton(
      icon: _saving
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              _saved ? Icons.bookmark : Icons.bookmark_border,
              color: AppColors.secondaryGreen,
            ),
      tooltip: 'Save herb',
      onPressed: _saving ? null : _saveHerb,
    );
  }

  Future<void> _saveHerb() async {
    setState(() => _saving = true);
    try {
      final repo = ref.read(savedHerbsRepositoryProvider);
      await repo.addSavedHerb(widget.herb.id.toString());
      if (!mounted) return;
      setState(() => _saved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Herb saved to your list'),
          backgroundColor: AppColors.secondaryGreen,
        ),
      );
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Could not save herb. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
