import 'package:flutter/material.dart';
import '../../../core/constants/strings.dart';
import 'organization_link_card.dart';

class OrganizationLinks extends StatelessWidget {
  const OrganizationLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: OrganizationLinkCard(
              title: AppStrings.research,
              subtitle: AppStrings.researchCenter,
              link: AppStrings.ourMethodology,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: OrganizationLinkCard(
              title: AppStrings.organization,
              subtitle: AppStrings.organizationCenter,
              link: AppStrings.community,
            ),
          ),
        ],
      ),
    );
  }
}
