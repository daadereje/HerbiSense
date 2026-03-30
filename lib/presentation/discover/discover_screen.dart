import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herbisense/common/network/api_endpoints.dart';
import 'package:herbisense/config/app_config.dart';
import 'package:herbisense/core/constants/colors.dart';
import 'package:herbisense/core/widgets/inputs/search_bar.dart';
import 'package:herbisense/core/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:herbisense/core/widgets/shared/header_widget.dart';
import 'package:herbisense/data/models/herb_model.dart';
import 'package:herbisense/data/repositories/herb_repository.dart';

final discoverHerbsProvider =
    FutureProvider.autoDispose.family<List<HerbModel>, String>(
  (ref, query) async {
    final repo = ref.read(herbRepositoryProvider);
    if (query.trim().isEmpty) {
      return repo.getAllHerbs();
    }
    return repo.searchHerbs(
      query: query,
      page: 1,
      limit: 20,
      sort: 'created_at',
    );
  },
);

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final herbsAsync = ref.watch(discoverHerbsProvider(_query));

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
      // appBar: AppBar(
      //   backgroundColor: AppColors.secondaryGreen,
      //    elevation: 0,
      //   // toolbarHeight: 160.0,
      //   title: const Text(
      //     'Discover',
      //     style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      // ),    
      body: CustomScrollView(
        slivers: [
          HeaderWidget.compact(
            title: 'Discover',
            subtitle: 'Browse herb images',
            // showBack: true,
            height: 120,
            solidColor: true,

          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchBar(
                    controller: _searchController,
                    hintText: 'Search herbs...',
                    onChanged: (val) =>
                        setState(() => _query = val.trim().toLowerCase()),
                  ),
                  const SizedBox(height: 16),
                  herbsAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, _) => _buildError(err.toString()),
                    data: (herbs) =>
                        herbs.isEmpty ? _buildEmptyState() : _buildGrid(herbs),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<HerbModel> herbs) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemCount: herbs.length,
      itemBuilder: (_, index) {
        final herb = herbs[index];
        final imageUrl =
            '${AppConfig.apiBaseUrl}${ApiEndpoints.uploadHerbById(herb.id)}';
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  herb.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: const [
            Icon(Icons.photo_library_outlined, size: 56, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No herb images available yet.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 12),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 8),
            Text(
              'Could not load herbs',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
