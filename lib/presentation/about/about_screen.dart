import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import 'about_view_model.dart';
import 'widgets/hero_section.dart';
import 'widgets/stats_grid.dart';
import 'widgets/mission_section.dart';
import 'widgets/organization_links.dart';
import 'widgets/legacy_section.dart';
import 'widgets/values_section.dart';
import 'widgets/future_section.dart';
import 'widgets/footer_section.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(aboutViewModelProvider.notifier).loadAboutData());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aboutViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeroSection(),
              const SizedBox(height: 24),
              StatsGrid(stats: state.stats),
              const SizedBox(height: 24),
              const MissionSection(),
              const SizedBox(height: 16),
              const OrganizationLinks(),
              const SizedBox(height: 28),
              const LegacySection(),
              const SizedBox(height: 24),
              const ValuesSection(),
              const FutureSection(),
              const FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}
