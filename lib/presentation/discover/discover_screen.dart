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
import 'herb_detail_screen.dart';

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
            subtitle: 'Browse herbs',
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
                        herbs.isEmpty ? _buildEmptyState() : _buildList(herbs),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<HerbModel> herbs) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: herbs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final herb = herbs[index];
        final candidates = _imageCandidates(herb);

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HerbDetailScreen(herb: herb),
              ),
            );
          },
          child: Container(
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
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: _ResilientImage(urls: candidates),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        herb.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        herb.scientificName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppColors.secondaryGreen,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            herb.isVerified
                                ? Icons.verified
                                : Icons.eco_outlined,
                            size: 16,
                            color: AppColors.secondaryGreen,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              herb.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (herb.skinConditions.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: -4,
                          children: herb.skinConditions
                              .take(3)
                              .map(
                                (c) => Chip(
                                  label: Text(
                                    c,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: AppColors.cardBackground,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
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

  // Build upload URL while gracefully handling base URLs that end with "/api".
  String _buildUploadUrl(String herbId, {required bool withHerbsSegment}) {
    final base = AppConfig.apiBaseUrl;
    final uri = Uri.parse(base);
    var path = uri.path;
    if (path.endsWith('/')) path = path.substring(0, path.length - 1);
    if (path.endsWith('/api')) {
      path = path.substring(0, path.length - 4); // drop trailing /api
    }
    final uploadPath = withHerbsSegment
        ? '$path/uploads/herbs/$herbId'
        : '$path/uploads/$herbId';
    return uri.replace(path: uploadPath).toString();
  }

  List<String> _imageCandidates(HerbModel herb) {
    final direct = _normalizeRelativeImage(herb.imageUrl);
    final fallback = _buildUploadUrl(herb.id, withHerbsSegment: true);
    final altFallback = _buildUploadUrl(herb.id, withHerbsSegment: false);

    return [
      direct,
      fallback,
      altFallback,
    ].whereType<String>().where((u) => u.isNotEmpty).toList();
  }

  String? _normalizeRelativeImage(String? url) {
    if (url == null || url.isEmpty) return null;
    final parsed = Uri.tryParse(url);
    if (parsed != null && parsed.hasScheme) return url;

    final base = Uri.parse(AppConfig.apiBaseUrl);
    var path = base.path;
    if (path.endsWith('/')) path = path.substring(0, path.length - 1);
    if (path.endsWith('/api')) path = path.substring(0, path.length - 4);

    final resolvedPath = url.startsWith('/') ? '$path$url' : '$path/$url';
    return base.replace(path: resolvedPath).toString();
  }
}

class _ResilientImage extends StatefulWidget {
  final List<String> urls;
  const _ResilientImage({required this.urls});

  @override
  State<_ResilientImage> createState() => _ResilientImageState();
}

class _ResilientImageState extends State<_ResilientImage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.urls.isEmpty) {
      return _placeholder();
    }

    final url = widget.urls[_index];
    return LayoutBuilder(
      builder: (context, constraints) {
        final dpr = MediaQuery.of(context).devicePixelRatio;
        final targetWidth = (constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : 200) *
            dpr;
        final targetHeight = (constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : 200) *
            dpr;

        return Image.network(
          url,
          fit: BoxFit.cover,
          cacheWidth: targetWidth.ceil(),
          cacheHeight: targetHeight.ceil(),
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) {
            if (_index < widget.urls.length - 1) {
              setState(() => _index += 1);
              return const SizedBox.shrink();
            }
            return _placeholder();
          },
        );
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
        size: 32,
      ),
    );
  }
}
