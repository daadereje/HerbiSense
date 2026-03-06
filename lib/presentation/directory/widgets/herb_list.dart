import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../data/models/herb_model.dart';
import 'herb_card.dart';

class HerbList extends StatelessWidget {
  final List<HerbModel> herbs;
  final int totalCount;

  const HerbList({
    super.key,
    required this.herbs,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Directory header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppStrings.herbalDirectory,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Showing ${herbs.length} of $totalCount herbs',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Herb cards
        if (herbs.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'No herbs found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        else
          ...herbs.map((herb) => HerbCard(herb: herb)),
      ],
    );
  }
}
