import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';

/// A reversible substitute until the NodeLane catalog exists. Prefer the
/// user's visible repository. Do not relabel its authorship as official.
final temporaryCatalogRepositoryProvider = Provider.family<Repo?, ItemType>((
  ref,
  type,
) {
  final repos = ref.watch(extensionsRepoStateProvider(type));
  final existing = repos.where((repo) => repo.hidden != true).firstOrNull;
  if (existing != null) return existing;
  if (type == ItemType.anime) return null;
  return Repo(
    name: 'Mangayomi 社区目录',
    website: 'https://github.com/kodjodevf/mangayomi-extensions',
    jsonUrl:
        'https://kodjodevf.github.io/mangayomi-extensions/${type == ItemType.novel ? 'novel_index' : 'index'}.json',
  );
});

final temporaryCatalogLoadProvider = FutureProvider.family<void, ItemType>((
  ref,
  type,
) async {
  final repo = ref.watch(temporaryCatalogRepositoryProvider(type));
  if (repo == null) return;
  await fetchSourcesList(
    refresh: true,
    androidProxyServer: ref.read(androidProxyServerStateProvider),
    autoUpdateExtensions: false,
    itemType: type,
    repo: repo,
  );
});
