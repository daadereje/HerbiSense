import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final double height;

  const HeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: height,
      pinned: true,
      backgroundColor: AppColors.secondaryGreen,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondaryGreen, AppColors.softGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                  if (actions != null) ...[
                    const SizedBox(height: 16),
                    Row(children: actions!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
