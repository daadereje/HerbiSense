import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';

class RoadmapWidget extends StatelessWidget {
  const RoadmapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoadmapYear(text: AppStrings.ourRoadmap, isTitle: true),
              RoadmapYear(text: '2025'),
              RoadmapYear(text: '2030'),
              RoadmapYear(text: '2040'),
              RoadmapYear(text: '2050'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.25,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        ],
      ),
    );
  }
}

class RoadmapYear extends StatelessWidget {
  final String text;
  final bool isTitle;

  const RoadmapYear({
    super.key,
    required this.text,
    this.isTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isTitle ? 13 : 12,
        fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
        color: isTitle ? Colors.amber : AppColors.white,
      ),
    );
  }
}
