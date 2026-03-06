import 'package:flutter/material.dart';

class BenefitModel {
  final IconData icon;
  final String title;
  final String description;

  BenefitModel({
    required this.icon,
    required this.title,
    required this.description,
  });

  static List<BenefitModel> getRegisterBenefits() {
    return [
      BenefitModel(
        icon: Icons.person_outline,
        title: 'Personalized Experience',
        description: 'Get tailored herb recommendations based on your interests',
      ),
      BenefitModel(
        icon: Icons.bookmark_border,
        title: 'Save Favorites',
        description: 'Bookmark your favorite herbs for quick access',
      ),
      BenefitModel(
        icon: Icons.groups,
        title: 'Community Access',
        description: 'Join discussions with herbal enthusiasts',
      ),
      BenefitModel(
        icon: Icons.science_outlined,
        title: 'Research Updates',
        description: 'Stay informed about new herbal discoveries',
      ),
    ];
  }
}
