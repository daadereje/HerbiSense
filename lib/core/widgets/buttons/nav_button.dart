import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const NavButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
      ),
      child: Text(label),
    );
  }
}
