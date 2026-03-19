import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isActive;

  const NavButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isActive ? AppColors.secondaryGreen : AppColors.textPrimary,
        textStyle: TextStyle(
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      child: Text(label),
    );
  }
}
