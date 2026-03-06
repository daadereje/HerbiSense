import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.secondaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: AppStrings.iAgreeTo,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
              children: const [
                TextSpan(
                  text: AppStrings.termsOfService,
                  style: TextStyle(
                    color: AppColors.secondaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: AppStrings.privacyPolicy,
                  style: TextStyle(
                    color: AppColors.secondaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
