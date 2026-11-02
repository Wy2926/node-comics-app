import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extensions_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';

import 'browser_url.dart';

// Both browser entry points use the existing pinned-source preferences.
final browserPinnedSourcesProvider = Provider<List<Source>>((ref) {
  final showNsfw = ref.watch(showNSFWStateProvider);
  final hiddenRepositories = {
    for (final type in ItemType.values)
      for (final repo in ref.watch(extensionsRepoStateProvider(type)))
        if (repo.hidden == true) repo.jsonUrl,
  };
  final seen = <String>{};
  return <Source>[
        for (final type in ItemType.values)
          ...ref.watch(getExtensionsStreamProvider(type)).value ?? <Source>[],
      ]
      .where(
        (source) =>
            source.isPinned == true &&
            (showNsfw || source.isNsfw != true) &&
            !hiddenRepositories.contains(source.repo?.jsonUrl) &&
            isBrowserUrl(source.baseUrl) &&
            seen.add(source.baseUrl!),
      )
      .take(8)
      .toList();
});
