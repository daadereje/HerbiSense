import 'package:flutter/material.dart';

class AboutStatModel {
  final String value;
  final String label;
  final IconData icon;

  AboutStatModel({
    required this.value,
    required this.label,
    required this.icon,
  });

  static List<AboutStatModel> getMockStats() {
    return [
      AboutStatModel(
        value: '250+',
        label: 'Traditional Products',
        icon: Icons.inventory,
      ),
      AboutStatModel(
        value: '100+',
        label: 'Certified Herbs',
        icon: Icons.eco,
      ),
      AboutStatModel(
        value: '3000+',
        label: 'Years of Tradition',
        icon: Icons.history,
      ),
      AboutStatModel(
        value: '98.7%',
        label: 'Accuracy Rate',
        icon: Icons.verified,
      ),
    ];
  }
}
