import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/source_catalog_config.dart';
export 'package:mangayomi/services/source_catalog_config.dart'
    show nodeLaneCatalogUrl;

/// The development catalog is served from this checkout, independently of the
/// user's third-party repositories. For an iPhone, use the Mac's LAN address.

bool isNodeLaneCatalogSource(Source source, Repo? official) =>
    official != null && source.repo?.jsonUrl == official.jsonUrl;

final nodeLaneCatalogRepositoryProvider = Provider.family<Repo?, ItemType>((
  ref,
  type,
) {
  if (type != ItemType.manga) return null;
  return Repo(
    name: 'NodeLane 官方 · 本地开发',
    website: Uri.parse(nodeLaneCatalogUrl).resolve('repo.json').toString(),
    jsonUrl: nodeLaneCatalogUrl,
  );
});

final nodeLaneCatalogLoadProvider = FutureProvider.family<void, ItemType>((
  ref,
  type,
) async {
  final repo = ref.watch(nodeLaneCatalogRepositoryProvider(type));
  if (repo == null) return;
  await fetchSourcesList(
    refresh: true,
    androidProxyServer: ref.read(androidProxyServerStateProvider),
    autoUpdateExtensions: false,
    itemType: type,
    repo: repo,
  );
});

/// Read all entries so directory language choices can reveal inactive languages
/// without changing installation flags or the preferences used by other pages.
final mobileCatalogEntriesProvider =
    StreamProvider.family<List<Source>, ItemType>(
      (ref, type) => sourceRepository.watchByItemType(type),
    );
