import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/list_tile_manga_category.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'mobile_manga_category_dialog.dart';

void showCategorySelectionDialog({
  required BuildContext context,
  required WidgetRef ref,
  required ItemType itemType,
  Manga? singleManga,
  List<Manga>? bulkMangas,
}) {
  assert(
    (singleManga != null) ^ (bulkMangas != null),
    "Provide either singleManga or bulkMangas, not both.",
  );
  if (isMobile && !isTv && itemType == ItemType.manga) {
    _showMobileMangaCategories(context, ref, singleManga, bulkMangas);
    return;
  }
  final l10n = l10nLocalizations(context)!;
  final bool isBulk = bulkMangas != null;
  final bool isFavorite = !isBulk && (singleManga!.favorite ?? false);
  List<int> categoryIds = [];
  if (!isBulk && isFavorite) {
    categoryIds = List<int>.from(singleManga.categories ?? []);
  }
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Container(
          width: context.width(0.85),
          constraints: BoxConstraints(maxHeight: context.height(0.75)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.primaryColor.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.primaryColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.category_rounded,
                        color: context.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.set_categories,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: context.primaryColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: StreamBuilder(
                    stream: categoryRepository.watchByItemType(itemType),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 64,
                                color: Theme.of(context).colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.library_no_category_exist,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      var entries = (snapshot.data!
                        ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0)));
                      if (isFavorite || isBulk) {
                        // When item is in library, hide hidden categories in list
                        entries = entries
                            .where((e) => !(e.hide ?? false))
                            .toList();
                      }
                      if (entries.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 64,
                                color: Theme.of(context).colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.library_no_category_exist,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SuperListView.builder(
                        shrinkWrap: true,
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final category = entries[index];
                          final isSelected = categoryIds.contains(category.id);
                          if (!isBulk) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ListTileChapterFilter(
                                label: category.name!,
                                onTap: () {
                                  setState(() {
                                    isSelected
                                        ? categoryIds.remove(category.id)
                                        : categoryIds.add(category.id!);
                                  });
                                },
                                type: isSelected ? 1 : 0,
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: ListTileMangaCategory(
                              category: category,
                              categoryIds: categoryIds,
                              mangasList: bulkMangas,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    categoryIds.remove(category.id);
                                  } else {
                                    categoryIds.add(category.id!);
                                  }
                                });
                              },
                              res: (res) {
                                if (res.isNotEmpty && !isSelected) {
                                  categoryIds.add(category.id!);
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              // Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: Text(l10n.edit),
                      style: TextButton.styleFrom(
                        foregroundColor: context.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        context.push(
                          "/categories",
                          extra: (
                            true,
                            itemType == ItemType.manga
                                ? 0
                                : itemType == ItemType.anime
                                ? 1
                                : 2,
                          ),
                        );
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.cancel),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (isBulk) {
                              final now = DateTime.now().millisecondsSinceEpoch;
                              for (var manga in bulkMangas) {
                                manga
                                  ..categories = categoryIds
                                  ..updatedAt = now;
                              }
                              mangaRepository.putAll(bulkMangas);
                              ref
                                  .read(mangasListStateProvider.notifier)
                                  .clear();
                              ref
                                  .read(isLongPressedStateProvider.notifier)
                                  .update(false);
                            } else {
                              if (!isFavorite) {
                                singleManga!.favorite = true;
                                singleManga.dateAdded =
                                    DateTime.now().millisecondsSinceEpoch;
                              }
                              singleManga.categories = categoryIds;
                              mangaRepository.save(singleManga);
                            }
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Text(l10n.ok),
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
  );
}

Future<void> _showMobileMangaCategories(
  BuildContext context,
  WidgetRef ref,
  Manga? singleManga,
  List<Manga>? bulkMangas,
) async {
  final isBulk = bulkMangas != null;
  final isFavorite = !isBulk && (singleManga!.favorite ?? false);
  final targets = [if (isBulk) ...bulkMangas else singleManga!]
      .where((manga) => manga.itemType == ItemType.manga)
      .toList(growable: false);
  // Determine the entire union now, independent of lazy row construction.
  final initialIds = <int>{
    if (isBulk || isFavorite)
      for (final manga in targets) ...?manga.categories,
  };
  var editRequested = false;
  final saved = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => Consumer(
      builder: (_, sheetRef, _) {
        final provider = getMangaCategorieStreamProvider(
          itemType: ItemType.manga,
        );
        final categories = sheetRef.watch(provider);
        return MobileMangaCategoryDialog(
          categories: categories.asData?.value,
          initialIds: initialIds,
          bookCount: targets.length,
          bookTitle: isBulk ? null : singleManga!.name,
          isBulk: isBulk,
          showHidden: !isBulk && !isFavorite,
          loading: categories.isLoading,
          readFailed: categories.hasError,
          onRetry: () => sheetRef.invalidate(provider),
          onEdit: () {
            editRequested = true;
            Navigator.pop(dialogContext, false);
          },
          onSave: (ids) => saveMobileMangaCategories(
            targets: targets,
            categoryIds: ids,
            isBulk: isBulk,
            isFavorite: isFavorite,
          ),
        );
      },
    ),
  );
  if (!context.mounted) return;
  if (saved == true && isBulk) {
    ref.read(mangasListStateProvider.notifier).clear();
    ref.read(isLongPressedStateProvider.notifier).update(false);
  }
  if (editRequested) context.push('/categories', extra: (true, 0));
}

/// Keeps the existing uniform replacement and favorite rules, but awaits the
/// existing repository operation and never mutates the caller's display model.
Future<void> saveMobileMangaCategories({
  required List<Manga> targets,
  required List<int> categoryIds,
  required bool isBulk,
  required bool isFavorite,
}) async {
  if (targets.isEmpty) return;
  final available = categoryRepository
      .getByItemType(ItemType.manga)
      .where((category) => !isBulk || !(category.hide ?? false))
      .map((category) => category.id)
      .toSet();
  final ids = categoryIds.where(available.contains).toSet().toList();
  final now = DateTime.now().millisecondsSinceEpoch;
  final copies = <Manga>[];
  for (final target in targets) {
    final latest = target.id == null
        ? null
        : mangaRepository.findById(target.id!);
    if (latest == null && (isBulk || isFavorite)) {
      throw StateError('Selected comic no longer exists');
    }
    final original = latest ?? target;
    if (original.itemType != ItemType.manga) {
      throw StateError('Manga selection required');
    }
    final copy = Manga.fromJson(original.toJson())
      ..isManga = original.isManga
      ..categories = List<int>.of(ids)
      ..updatedAt = now;
    if (!isBulk && !isFavorite && !(copy.favorite ?? false)) {
      copy.favorite = true;
      copy.dateAdded = now;
    }
    copies.add(copy);
  }
  if (isBulk) {
    await mangaRepository.putAll(copies);
  } else {
    await mangaRepository.save(copies.single);
  }
}
