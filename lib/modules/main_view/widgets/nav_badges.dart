import 'package:mangayomi/utils/version.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';

int _extensionUpdateCount(Iterable<Source> sources) => sources
    .where(
      (source) =>
          (source.isAdded ?? false) &&
          !(source.isObsolete ?? false) &&
          compareVersions(source.version ?? '', source.versionLast ?? '') < 0,
    )
    .length;

/// Supplies the same repository badge counts to native and Flutter tab bars.
class NavigationBadgeCounts extends ConsumerWidget {
  const NavigationBadgeCounts({
    super.key,
    required this.routes,
    required this.builder,
  });
  final List<String> routes;
  final Widget Function(Map<String, int>) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hidden = ref.watch(hideItemsStateProvider);
    return StreamBuilder(
      stream: routes.contains('/updates')
          ? updateRepository.watchUnreadExcludingHiddenItemTypes(
              hideManga: hidden.contains('/MangaLibrary'),
              hideAnime: hidden.contains('/AnimeLibrary'),
              hideNovel: hidden.contains('/NovelLibrary'),
            )
          : null,
      builder: (context, updates) => StreamBuilder(
        stream: routes.contains('/browse')
            ? sourceRepository.watchActiveExcludingHiddenItemTypes(
                hideManga: hidden.contains('/MangaLibrary'),
                hideAnime: hidden.contains('/AnimeLibrary'),
                hideNovel: hidden.contains('/NovelLibrary'),
              )
            : null,
        builder: (context, sources) => builder({
          '/updates': updates.data?.length ?? 0,
          '/browse': _extensionUpdateCount(sources.data ?? const []),
        }),
      ),
    );
  }
}

class ExtensionBadgeWidget extends ConsumerWidget {
  const ExtensionBadgeWidget({
    super.key,
    required this.icon,
    required this.ref,
  });

  final Widget icon;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideItems = ref.watch(hideItemsStateProvider);

    return StreamBuilder(
      stream: sourceRepository.watchActiveExcludingHiddenItemTypes(
        hideManga: hideItems.contains("/MangaLibrary"),
        hideAnime: hideItems.contains("/AnimeLibrary"),
        hideNovel: hideItems.contains("/NovelLibrary"),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return icon;
        }

        final count = _extensionUpdateCount(snapshot.data!);

        if (count == 0) {
          return icon;
        }

        return Badge(label: Text('$count'), child: icon);
      },
    );
  }
}

class UpdatesBadgeWidget extends ConsumerWidget {
  const UpdatesBadgeWidget({super.key, required this.icon, required this.ref});

  final Widget icon;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideItems = ref.watch(hideItemsStateProvider);

    return StreamBuilder(
      stream: updateRepository.watchUnreadExcludingHiddenItemTypes(
        hideManga: hideItems.contains("/MangaLibrary"),
        hideAnime: hideItems.contains("/AnimeLibrary"),
        hideNovel: hideItems.contains("/NovelLibrary"),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return icon;
        }

        return Badge(label: Text("${snapshot.data!.length}"), child: icon);
      },
    );
  }
}
