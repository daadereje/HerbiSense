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

  factory AboutStatModel.fromJson(Map<String, dynamic> json) {
    return AboutStatModel(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      icon: _iconFromString(json['icon']?.toString()),
    );
  }

  static IconData _iconFromString(String? name) {
    switch (name) {
      case 'inventory':
        return Icons.inventory;
      case 'eco':
        return Icons.eco;
      case 'history':
        return Icons.history;
      case 'verified':
        return Icons.verified;
      default:
        return Icons.insights;
    }
  }

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
