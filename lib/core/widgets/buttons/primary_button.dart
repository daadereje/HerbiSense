import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isOutlined;
  final Color? textColor;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isOutlined = false,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.secondaryGreen,
          side: BorderSide(color: textColor ?? AppColors.secondaryGreen),
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(label),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.secondaryGreen,
        foregroundColor: textColor ?? AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(label),
    );
  }
}
