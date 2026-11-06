import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/source_catalog_config.dart';
import 'package:mangayomi/services/source_catalog_refresh.dart';
import 'package:mangayomi/modules/more/settings/security/providers/security_state_provider.dart';
export 'package:mangayomi/services/source_catalog_config.dart'
    show nodeLaneCatalogUrl;

bool isNodeLaneCatalogSource(Source source, Repo? official) =>
    official != null && source.repo?.jsonUrl == official.jsonUrl;

final nodeLaneCatalogRepositoryProvider = Provider.family<Repo?, ItemType>((
  ref,
  type,
) {
  if (type != ItemType.manga) return null;
  return Repo(
    name: 'NodeLane 官方',
    website: 'https://github.com/Wy2926/nodelane-comics-extensions',
    jsonUrl: nodeLaneCatalogUrl,
  );
});

final nodeLaneCatalogRefreshProvider = Provider<SourceCatalogRefresh>((ref) {
  return SourceCatalogRefresh(
    url: nodeLaneCatalogUrl,
    stateFile: () async => File(
      '${(await getApplicationSupportDirectory()).path}/nodelane-catalog-refresh.json',
    ),
    update: () async {
      final repo = ref.read(nodeLaneCatalogRepositoryProvider(ItemType.manga));
      if (repo == null) return;
      await fetchSourcesList(
        refresh: true,
        androidProxyServer: ref.read(androidProxyServerStateProvider),
        autoUpdateExtensions:
            ref.read(checkForExtensionsUpdateStateProvider) &&
            ref.read(autoUpdateExtensionsStateProvider),
        itemType: ItemType.manga,
        repo: repo,
        canContinueUpdates: () =>
            WidgetsBinding.instance.lifecycleState !=
                AppLifecycleState.paused &&
            WidgetsBinding.instance.lifecycleState !=
                AppLifecycleState.hidden &&
            WidgetsBinding.instance.lifecycleState !=
                AppLifecycleState.detached &&
            ref.read(appUnlockedStateProvider),
      );
    },
  );
});

Future<void> refreshOfficialCatalogIfDue(WidgetRef ref) async {
  if (!ref.read(appUnlockedStateProvider) ||
      !ref.read(checkForExtensionsUpdateStateProvider)) {
    return;
  }
  try {
    await ref.read(nodeLaneCatalogRefreshProvider).refresh();
  } catch (_) {
    // Background failures retain the cache and retry after the short cooldown.
    // A manual refresh uses the same operation and surfaces its error in the UI.
  }
}

final nodeLaneCatalogLoadProvider = FutureProvider.family<void, ItemType>((
  ref,
  type,
) async {
  final repo = ref.watch(nodeLaneCatalogRepositoryProvider(type));
  if (repo == null) return;
  await ref.read(nodeLaneCatalogRefreshProvider).refresh();
});

/// Read all entries so directory language choices can reveal inactive languages
/// without changing installation flags or the preferences used by other pages.
final mobileCatalogEntriesProvider =
    StreamProvider.family<List<Source>, ItemType>(
      (ref, type) => sourceRepository.watchByItemType(type),
    );
