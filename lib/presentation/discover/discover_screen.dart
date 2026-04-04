import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herbisense/config/app_config.dart';
import 'package:herbisense/core/constants/colors.dart';
import 'package:herbisense/common/network/api_client.dart';
import 'package:herbisense/common/network/api_endpoints.dart';
import 'package:herbisense/core/widgets/inputs/search_bar.dart';
import 'package:herbisense/core/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:herbisense/core/widgets/shared/header_widget.dart';
import 'package:herbisense/core/constants/data/models/herb_model.dart';
import 'package:herbisense/core/constants/data/repositories/herb_repository.dart';
import 'package:herbisense/core/constants/data/repositories/favorites_repository.dart';
import 'package:herbisense/core/constants/data/repositories/saved_herbs_repository.dart';
import 'package:http/http.dart' as http;
import 'herb_detail_screen.dart';
import 'package:herbisense/core/state/language_provider.dart';

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

/// Favorited herb ids so we can show filled heart on the list.
final favoriteHerbIdsProvider =
    FutureProvider.autoDispose<Set<String>>((ref) async {
  // Skip network call when user isn't authenticated.
  if (ApiClient.authToken == null || ApiClient.authToken!.isEmpty) {
    return <String>{};
  }
  final repo = ref.read(favoritesRepositoryProvider);
  final favs = await repo.getFavorites();
  // Prefer herbId, fallback to favorite record id.
  return favs
      .map((f) => (f.herbId ?? f.id).toString())
      .where((id) => id.isNotEmpty)
      .toSet();
});

/// Saved herb ids so we can show filled bookmark on the list.
final savedHerbIdsProvider =
    FutureProvider.autoDispose<Set<String>>((ref) async {
  // Skip network call when user isn't authenticated.
  if (ApiClient.authToken == null || ApiClient.authToken!.isEmpty) {
    return <String>{};
  }
  final repo = ref.read(savedHerbsRepositoryProvider);
  final saved = await repo.getSavedHerbs();
  return saved.map((h) => h.id).toSet();
});

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
    final favsAsync = ref.watch(favoriteHerbIdsProvider);
    final savedAsync = ref.watch(savedHerbIdsProvider);
    final language = ref.watch(languageProvider);
    final languageNotifier = ref.read(languageProvider.notifier);

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
            language: language,
            languageOptions: const ['eng', 'amh', 'or'],
            onLanguageSelected: languageNotifier.setLanguage,
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
                  // Trigger initial loads; UI waits until both sets are ready.
                  favsAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (favIds) => const SizedBox.shrink(),
                  ),
                  savedAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (savedIds) => const SizedBox.shrink(),
                  ),
                  herbsAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, _) => _buildError(err.toString()),
                    data: (herbs) {
                      final favIds = favsAsync.maybeWhen(
                        data: (ids) => ids,
                        orElse: () => <String>{},
                      );
                      final savedIds = savedAsync.maybeWhen(
                        data: (ids) => ids,
                        orElse: () => <String>{},
                      );
                      return herbs.isEmpty
                          ? _buildEmptyState()
                          : _buildList(herbs, favIds, savedIds);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
      List<HerbModel> herbs, Set<String> favoriteIds, Set<String> savedIds) {
    final apiClient = ref.read(apiClientProvider);
    final isLoggedIn =
        ApiClient.authToken != null && ApiClient.authToken!.isNotEmpty;
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              herb.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _QuickActions(
                            herbId: herb.id,
                            apiClient: apiClient,
                            initiallyFavorite: favoriteIds.contains(herb.id),
                            initiallySaved: savedIds.contains(herb.id),
                            canMutate: isLoggedIn,
                          ),
                        ],
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

  // Build upload URL (JSON endpoint) while gracefully handling base URLs that may or may not end with "/api".
  // Backend sample: GET /uploads/{id} or /uploads/herbs/{id} -> { data: [ { image_url: "http://.../uploads/herbs/<file>" } ] }
  String _buildUploadUrl(
    String herbId, {
    required bool withHerbsSegment,
    required bool keepApiPrefix,
  }) {
    final base = AppConfig.apiBaseUrl;
    final uri = Uri.parse(base);
    var path = uri.path;
    if (path.endsWith('/')) path = path.substring(0, path.length - 1);
    if (!keepApiPrefix && path.endsWith('/api')) {
      path = path.substring(0, path.length - 4); // drop trailing /api
    }
    final uploadPath = withHerbsSegment
        ? '$path/uploads/herbs/$herbId'
        : '$path/uploads/$herbId';
    return uri.replace(path: uploadPath).toString();
  }

  List<String> _imageCandidates(HerbModel herb) {
    final direct = _normalizeRelativeImage(herb.imageUrl);

    return [
      direct,
      // Try JSON upload endpoints with and without /api prefix, and with/without /herbs segment
      _buildUploadUrl(herb.id, withHerbsSegment: true, keepApiPrefix: true),
      _buildUploadUrl(herb.id, withHerbsSegment: false, keepApiPrefix: true),
      _buildUploadUrl(herb.id, withHerbsSegment: true, keepApiPrefix: false),
      _buildUploadUrl(herb.id, withHerbsSegment: false, keepApiPrefix: false),
    ].whereType<String>().where((u) => u.isNotEmpty).toList();
  }

  String? _normalizeRelativeImage(String? url) {
    if (url == null || url.isEmpty) return null;
    final parsed = Uri.tryParse(url);
    if (parsed != null && parsed.hasScheme) return url;

    final base = Uri.parse(AppConfig.apiBaseUrl);
    var path = base.path;
    if (path.endsWith('/')) path = path.substring(0, path.length - 1);
    // Keep /api for relative assets; backend likely serves them under same prefix.

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
  List<String> _resolved = [];
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _resolved = [];
    _maybeResolveUploadApis();
  }

  Future<void> _maybeResolveUploadApis() async {
    final List<String> expanded = [];
    for (final url in widget.urls) {
      if (_looksLikeUploadApi(url)) {
        final resolved = await _fetchUploadImageUrl(url);
        if (resolved != null && resolved.isNotEmpty) {
          expanded.add(resolved);
        }
        continue; // skip the raw /uploads/{id} URL to avoid 404s
      }
      expanded.add(url);
    }

    if (!mounted) return;
    setState(() {
      _resolved = expanded;
      _index = 0;
    });
  }

  bool _looksLikeUploadApi(String url) {
    // Heuristic: endpoint path contains "/uploads" but final segment lacks an extension.
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final last = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    final hasExt = last.contains('.') && last.split('.').length > 1;
    return uri.path.contains('/uploads') && !hasExt;
  }

  Future<String?> _fetchUploadImageUrl(String url) async {
    try {
      final resp = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          if (ApiClient.authToken != null)
            'Authorization': 'Bearer ${ApiClient.authToken}',
        },
      ).timeout(const Duration(seconds: 8));
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final body = resp.body;
        final decoded = jsonDecode(body);
        if (decoded is Map &&
            decoded['data'] is List &&
            decoded['data'].isNotEmpty) {
          final first = decoded['data'][0];
          if (first is Map && first['image_url'] != null) {
            return first['image_url'].toString();
          }
        }
      }
    } catch (_) {
      // Silently fall back to original list.
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_resolved.isEmpty) {
      return _placeholder();
    }

    final url = _resolved[_index];
    return LayoutBuilder(
      builder: (context, constraints) {
        // Keep images square and clamp to a reasonable pixel size.
        final boxWidth =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0;
        final boxHeight =
            constraints.maxHeight.isFinite ? constraints.maxHeight : 200.0;
        final dpr = MediaQuery.of(context).devicePixelRatio;
        final targetWidth = (boxWidth * dpr).clamp(64, 512).toInt();
        final targetHeight = (boxHeight * dpr).clamp(64, 512).toInt();

        return AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            url,
            width: boxWidth,
            height: boxHeight,
            fit: BoxFit.cover,
            cacheWidth: targetWidth,
            cacheHeight: targetHeight,
            filterQuality: FilterQuality.medium,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return _placeholder(isLoading: true);
            },
            errorBuilder: (_, err, ___) {
              _lastError = '$err';
              // Try the next candidate while keeping layout stable.
              if (_index < _resolved.length - 1) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _index += 1);
                });
              }
              debugPrint('Image load failed: $url ($_lastError)');
              return _placeholder();
            },
          ),
        );
      },
    );
  }

  Widget _placeholder({bool isLoading = false}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey,
                size: 30,
              ),
      ),
    );
  }
}

class _QuickActions extends StatefulWidget {
  const _QuickActions({
    required this.herbId,
    required this.apiClient,
    required this.initiallyFavorite,
    required this.initiallySaved,
    required this.canMutate,
    Key? key,
  }) : super(key: key);

  final String herbId;
  final ApiClient apiClient;
  final bool initiallyFavorite;
  final bool initiallySaved;
  final bool canMutate;

  @override
  State<_QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<_QuickActions> {
  bool _saving = false;
  bool _favoriting = false;
  late bool _isFavorite;
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initiallyFavorite;
    _isSaved = widget.initiallySaved;
  }

  @override
  Widget build(BuildContext context) {
    final canMutate = widget.canMutate;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(
                  _isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                  color: AppColors.secondaryGreen,
                ),
          tooltip: _isSaved ? 'Saved' : 'Save herb',
          onPressed: !canMutate
              ? null
              : (_saving
                  ? null
                  : () => _post(ApiEndpoints.savedHerbs, isSave: true)),
        ),
        IconButton(
          icon: _favoriting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent,
                ),
          tooltip: _isFavorite ? 'Favorited' : 'Add to favorites',
          onPressed: !canMutate
              ? null
              : (_favoriting
                  ? null
                  : () => _post(ApiEndpoints.favorites, isSave: false)),
        ),
      ],
    );
  }

  Future<void> _post(String endpoint, {required bool isSave}) async {
    // Require auth before attempting mutations.
    if (ApiClient.authToken == null || ApiClient.authToken!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to log in to perform this action.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      if (isSave) {
        _saving = true;
      } else {
        _favoriting = true;
      }
    });
    try {
      final parsedId = int.tryParse(widget.herbId);
      if (isSave && _isSaved) {
        // Toggle off saved: DELETE /saved-herbs/{id}
        await widget.apiClient.delete(
          '$endpoint/${parsedId ?? widget.herbId}',
        );
        if (!mounted) return;
        _isSaved = false;
      } else if (!isSave && _isFavorite) {
        // Toggle off favorite: DELETE /favorites/{id}
        await widget.apiClient.delete(
          '$endpoint/${parsedId ?? widget.herbId}',
        );
        if (!mounted) return;
        _isFavorite = false;
      } else {
        await widget.apiClient.post(
          endpoint,
          body: {'herbId': parsedId ?? widget.herbId},
        );
        if (!mounted) return;
        if (isSave) {
          _isSaved = true;
        } else {
          _isFavorite = true;
        }
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSave
                ? (_isSaved ? 'Saved herb' : 'Removed from saved')
                : (_isFavorite
                    ? 'Added to favorites'
                    : 'Removed from favorites'),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        if (isSave) {
          _saving = false;
        } else {
          _favoriting = false;
        }
      });
    }
  }
}
