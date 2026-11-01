import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_source_card.dart';

class SourceListTile extends StatelessWidget {
  final ItemType itemType;
  final Source source;

  bool get isLocal => source.name == "local" && source.lang == "";

  const SourceListTile({
    super.key,
    required this.source,
    required this.itemType,
  });

  void _openSource(BuildContext context) {
    if (!isLocal) sourceRepository.markLastUsed(itemType, source.id);
    context.push('/mangaHome', extra: (source, false));
  }

  Widget _icon(BuildContext context) {
    if (isMobile && !isTv) {
      final colors = NodeLaneTokens.of(context);
      final icons = NodeLaneIcons.of(context);
      if (isLocal) return Icon(icons.folder, color: colors.accent, size: 36);
      return ClipRRect(
        borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
        child: ColoredBox(
          color: colors.soft,
          child: (source.iconUrl ?? '').isEmpty
              ? Icon(icons.extensions, color: colors.accent)
              : cachedNetworkImage(
                  imageUrl: source.iconUrl!,
                  fit: BoxFit.contain,
                  width: 40,
                  height: 40,
                  errorWidget: Icon(icons.extensions, color: colors.muted),
                  useCustomNetworkImage: false,
                ),
        ),
      );
    }
    return Container(
      height: 37,
      width: 37,
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(isMobile && !isTv ? 10 : 5),
      ),
      child: (source.iconUrl ?? '').isEmpty
          ? Icon(isLocal ? Icons.folder_outlined : Icons.extension_rounded)
          : cachedNetworkImage(
              imageUrl: source.iconUrl!,
              fit: BoxFit.contain,
              width: 37,
              height: 37,
              errorWidget: const Icon(Icons.extension_rounded),
              useCustomNetworkImage: false,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = isLocal
        ? "${context.l10n.local_source} ${source.itemType.localized(context.l10n)}"
        : source.name ?? '';
    if (isMobile && !isTv) {
      return MobileSourceCard(
        title: isLocal ? context.l10n.local_source : title,
        icon: _icon(context),
        onTap: () => _openSource(context),
        metadata: isLocal
            ? Text(source.itemType.localized(context.l10n))
            : Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Text(completeLanguageName((source.lang ?? '').toLowerCase())),
                  if (source.isNsfw ?? false)
                    Text(
                      'NSFW',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
        actions: Row(
          children: [
            Expanded(
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size(44, 44),
                ),
                onPressed: () =>
                    context.push('/mangaHome', extra: (source, true)),
                icon: Icon(NodeLaneIcons.of(context).latest, size: 20),
                label: Text(context.l10n.latest),
              ),
            ),
            if (!isLocal)
              IconButton(
                tooltip: context.l10n.pinned,
                isSelected: source.isPinned ?? false,
                onPressed: () => sourceRepository.save(
                  source..isPinned = !(source.isPinned ?? false),
                ),
                icon: Icon(NodeLaneIcons.of(context).pin, size: 20),
                selectedIcon: Icon(
                  NodeLaneIcons.of(context).pinSelected,
                  size: 20,
                  color: context.primaryColor,
                ),
              ),
          ],
        ),
      );
    }
    return Consumer(
      builder: (context, ref, child) => ListTile(
        onTap: () => _openSource(context),
        leading: _icon(context),
        subtitle: Row(
          children: [
            Text(
              completeLanguageName(source.lang!.toLowerCase()),
              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
            ),
            if (source.isNsfw ?? false)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "NSFW",
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(title),
        trailing: SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  // final supportsLatest =  ref.watch(supportsLatestProvider(source: source));
                  // if (supportsLatest) {
                  return TextButton(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(10)),
                    ),
                    onPressed: () =>
                        context.push('/mangaHome', extra: (source, true)),
                    child: Text(context.l10n.latest),
                  );
                  // }
                  // return const SizedBox.shrink();
                },
              ),
              const SizedBox(width: 10),
              if (!isLocal)
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    sourceRepository.save(source..isPinned = !source.isPinned!);
                  },
                  icon: Icon(
                    Icons.push_pin_outlined,
                    color: source.isPinned! ? context.primaryColor : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// TV variant of [SourceListTile]: three independently d-pad-focusable buttons
/// in a row — the source (opens popular), Latest, and Pin — so the remote moves
/// Left/Right between them and Up/Down between rows. See #729.
class TvSourceRow extends StatelessWidget {
  final Source source;
  final ItemType itemType;
  final FocusNode? sourceNode;
  final FocusNode? latestNode;
  final FocusNode? pinNode;

  const TvSourceRow({
    super.key,
    required this.source,
    required this.itemType,
    this.sourceNode,
    this.latestNode,
    this.pinNode,
  });

  bool get isLocal => source.name == "local" && source.lang == "";

  void _openPopular(BuildContext context) {
    if (!isLocal) {
      final sources = sourceRepository.getByItemType(itemType);
      final now = DateTime.now().millisecondsSinceEpoch;
      for (var src in sources) {
        src
          ..lastUsed = src.id == source.id
          ..updatedAt = now;
      }
      sourceRepository.putAll(sources);
    }
    context.push('/mangaHome', extra: (source, false));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => TvListRow(
        children: [
          Expanded(
            child: TvRowButton(
              focusNode: sourceNode,
              onTap: () => _openPopular(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 37,
                      width: 37,
                      decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: source.iconUrl!.isEmpty
                          ? const Icon(Icons.extension_rounded)
                          : cachedNetworkImage(
                              imageUrl: source.iconUrl!,
                              fit: BoxFit.contain,
                              width: 37,
                              height: 37,
                              errorWidget: const SizedBox(
                                width: 37,
                                height: 37,
                                child: Center(
                                  child: Icon(Icons.extension_rounded),
                                ),
                              ),
                              useCustomNetworkImage: false,
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            !isLocal
                                ? source.name!
                                : "${context.l10n.local_source} ${source.itemType.localized(context.l10n)}",
                            style: const TextStyle(fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Text(
                                completeLanguageName(
                                  source.lang!.toLowerCase(),
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                              ),
                              if (source.isNsfw ?? false)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "NSFW",
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          TvRowButton(
            focusNode: latestNode,
            onTap: () => context.push('/mangaHome', extra: (source, true)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Text(
                context.l10n.latest,
                style: TextStyle(color: context.primaryColor),
              ),
            ),
          ),
          if (!isLocal) ...[
            const SizedBox(width: 6),
            TvRowButton(
              focusNode: pinNode,
              onTap: () {
                sourceRepository.save(source..isPinned = !source.isPinned!);
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.push_pin_outlined,
                  color: source.isPinned! ? context.primaryColor : null,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
