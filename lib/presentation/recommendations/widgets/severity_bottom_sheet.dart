import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/skin_concern_model.dart';

class SeverityBottomSheet extends StatefulWidget {
  final SkinConcernModel concern;
  final Function(int) onSeveritySelected;

  const SeverityBottomSheet({
    super.key,
    required this.concern,
    required this.onSeveritySelected,
  });

  @override
  State<SeverityBottomSheet> createState() => _SeverityBottomSheetState();
}

class _SeverityBottomSheetState extends State<SeverityBottomSheet> {
  late int _selectedSeverity;

  @override
  void initState() {
    super.initState();
    _selectedSeverity = widget.concern.severity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 20),
          Text(
            'Select severity for ${widget.concern.title}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _buildSeverityOption(1, 'Mild', 'Slight discomfort, barely noticeable'),
          _buildSeverityOption(2, 'Moderate', 'Noticeable, occasional discomfort'),
          _buildSeverityOption(3, 'Severe', 'Intense, frequent discomfort'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSeveritySelected(_selectedSeverity);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryGreen,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityOption(int level, String label, String description) {
    final isSelected = _selectedSeverity == level;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSeverity = level;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardBackground : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.secondaryGreen : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.secondaryGreen : AppColors.black,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.secondaryGreen),
          ],
        ),
      ),
    );
  }
}
