import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
      ),
      body: const Center(
        child: Text(
          'Recommendations will appear here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
