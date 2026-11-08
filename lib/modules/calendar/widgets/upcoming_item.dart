import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/deferred_cover_image.dart';

const _upcomingItemHeight = 96.0;

class UpcomingItem extends ConsumerWidget {
  final Manga manga;
  final VoidCallback onTap;
  final bool mobile;

  const UpcomingItem({
    required this.manga,
    required this.onTap,
    this.mobile = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    if (mobile) {
      final colors = NodeLaneTokens.of(context);
      final imageProvider = _getImageProvider(ref);
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: DeferredCoverImage(
                      width: 56,
                      height: 80,
                      builder: (_) => Image(
                        image: ResizeImage.resizeIfNeeded(
                          168,
                          240,
                          imageProvider,
                        ),
                        width: 56,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => SizedBox(
                          width: 56,
                          height: 80,
                          child: ColoredBox(
                            color: colors.soft,
                            child: const Icon(Icons.image_outlined),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      manga.name ?? '',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded, color: colors.muted),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: _upcomingItemHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Cover image
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  width: 56,
                  height: _upcomingItemHeight - 16,
                  child: Image(
                    image: _getImageProvider(ref),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image, size: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Title
              Expanded(
                child: Text(
                  manga.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(WidgetRef ref) {
    if (manga.customCoverImage != null) {
      final bytes = manga.customCoverImage!;
      return MemoryImage(
        bytes is Uint8List ? bytes : Uint8List.fromList(bytes),
      );
    }
    return coverProvider(
      toImgUrl(manga.customCoverFromTracker ?? manga.imageUrl ?? ''),
      headers: ref.watch(
        headersProvider(
          source: manga.source ?? '',
          lang: manga.lang ?? '',
          sourceId: manga.sourceId,
        ),
      ),
    );
  }
}
