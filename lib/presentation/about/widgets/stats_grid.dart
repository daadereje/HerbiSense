import 'package:flutter/material.dart';
import '../../../core/constants/data/models/about_stat_model.dart';
import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  final List<AboutStatModel> stats;

  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return StatCard(stat: stats[index]);
        },
      ),
    );
  }
}
