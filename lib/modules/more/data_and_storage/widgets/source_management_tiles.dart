import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_preview_screen.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/delete_source.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/pre_import_backup.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';

import 'mobile_library_action.dart';
import 'mobile_library_choices.dart';

String _itemTypeLabel(BuildContext context, ItemType itemType) {
  final l10n = context.l10n;
  return switch (itemType) {
    ItemType.manga => l10n.manga,
    ItemType.anime => l10n.anime,
    ItemType.novel => l10n.novel,
  };
}

class DeleteSourceTile extends ConsumerWidget {
  const DeleteSourceTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (isMobile && !isTv) {
      return MobileLibraryAction(
        title: l10n.delete_source_title,
        subtitle: l10n.library_delete_pick_message,
        icon: Icons.delete_sweep_outlined,
        onOpen: () => _deleteSource(context, ref),
      );
    }
    return ListTile(
      leading: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
      title: Text(
        l10n.delete_source_title,
        style: const TextStyle(color: Colors.red),
      ),
      subtitle: Text(
        l10n.delete_source_subtitle,
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      onTap: () => _deleteSource(context, ref),
    );
  }
}

class MissingSourceCheckTile extends ConsumerWidget {
  const MissingSourceCheckTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (isMobile && !isTv) {
      return MobileLibraryAction(
        title: l10n.missing_source_check_title,
        subtitle: l10n.missing_source_check_subtitle,
        icon: Icons.extension_off_outlined,
        onOpen: () => _checkMissingSources(context),
      );
    }
    return ListTile(
      leading: const Icon(Icons.extension_off_outlined, color: Colors.orange),
      title: Text(l10n.missing_source_check_title),
      subtitle: Text(
        l10n.missing_source_check_subtitle,
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      onTap: () => _checkMissingSources(context),
    );
  }
}

class MergeDuplicateMangaTile extends ConsumerWidget {
  const MergeDuplicateMangaTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (isMobile && !isTv) {
      return MobileLibraryAction(
        title: l10n.merge_manga_title,
        subtitle: l10n.merge_manga_subtitle,
        icon: Icons.join_full_rounded,
        onOpen: () => _mergeDuplicateManga(context, ref),
      );
    }
    return ListTile(
      leading: const Icon(Icons.join_full_rounded),
      title: Text(l10n.merge_manga_title),
      subtitle: Text(
        l10n.merge_manga_subtitle,
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      onTap: () => _mergeDuplicateManga(context, ref),
    );
  }
}

Future<void> _checkMissingSources(BuildContext context) async {
  final l10n = context.l10n;
  final groups = librarySourceGroupsMissingSource();
  if (isMobile && !isTv) {
    final group = await showMobileLibrarySourcePicker(
      context,
      groups: groups,
      title: l10n.missing_source_check_title,
      description: groups.isEmpty
          ? null
          : l10n.missing_source_check_result_message,
      emptyMessage: l10n.missing_source_check_none_found,
    );
    if (group != null && context.mounted) {
      await _openMissingSource(context, group);
    }
    return;
  }
  if (groups.isEmpty) {
    botToast(l10n.missing_source_check_none_found);
    return;
  }

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.missing_source_check_result_title(groups.length)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.missing_source_check_result_message,
                style: TextStyle(
                  fontSize: 12,
                  color: dialogContext.secondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: groups.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (itemContext, index) {
                    final g = groups[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                      ),
                      title: Text(
                        g.lang != null
                            ? "${g.sourceName} (${g.lang})"
                            : g.sourceName,
                      ),
                      subtitle: Text(
                        "${_itemTypeLabel(itemContext, g.itemType)} • ${g.mangaCount}",
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(dialogContext);
                        _openMissingSource(context, g);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.ok),
          ),
        ],
      );
    },
  );
}

Future<void> _openMissingSource(
  BuildContext context,
  LibrarySourceGroup group,
) async {
  final migrationGroups = buildMassMigrationSourceGroups(
    itemType: group.itemType,
  );
  MassMigrationSourceGroup? migrationGroup;
  for (final candidate in migrationGroups) {
    if (candidate.sourceName.trim() == group.sourceName.trim() &&
        candidate.lang == group.lang) {
      migrationGroup = candidate;
      break;
    }
  }
  if (migrationGroup == null || !context.mounted) return;
  await Navigator.push(
    context,
    createRoute(page: MassMigrationPreviewScreen(sourceGroup: migrationGroup)),
  );
}

Future<void> _deleteSource(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final groups = librarySourceGroups();
  final mobile = isMobile && !isTv;
  if (groups.isEmpty && !mobile) {
    botToast(l10n.delete_source_empty);
    return;
  }

  final group = mobile
      ? await showMobileLibrarySourcePicker(
          context,
          groups: groups,
          title: l10n.delete_source_pick_title,
          description: groups.isEmpty ? null : l10n.library_delete_pick_message,
          emptyMessage: l10n.delete_source_empty,
        )
      : await showDialog<LibrarySourceGroup>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text(l10n.delete_source_pick_title),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: groups.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final g = groups[index];
                    return ListTile(
                      title: Text(
                        g.lang != null
                            ? "${g.sourceName} (${g.lang})"
                            : g.sourceName,
                      ),
                      subtitle: Text(
                        "${_itemTypeLabel(context, g.itemType)} • ${g.mangaCount}",
                      ),
                      onTap: () => Navigator.pop(dialogContext, g),
                    );
                  },
                ),
              ),
              actions: dialogCancelOnlyAction(dialogContext),
            );
          },
        );
  if (group == null || !context.mounted) return;

  final mangaList = mangaForGroup(group);
  final counts = previewDeleteSource(mangaList);
  var removeExtension = group.sourceId != null;
  var keepHistory = false;
  var keepDownloads = false;
  final bool? confirmed;
  if (mobile) {
    final choices = await Navigator.push<LibraryDeleteChoices>(
      context,
      MaterialPageRoute(
        builder: (_) => MobileDeleteSourceChoices(group: group, counts: counts),
      ),
    );
    confirmed = choices != null;
    if (choices != null) {
      keepHistory = choices.keepHistory;
      keepDownloads = choices.keepDownloads;
      removeExtension = choices.removeExtension;
    }
  } else {
    confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: Text(
                l10n.delete_source_confirm_title(
                  "${group.sourceName} (${_itemTypeLabel(context, group.itemType)})",
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.delete_source_confirm_message(
                      counts.mangaCount,
                      counts.chapterCount,
                      counts.historyCount,
                      counts.updateCount,
                    ),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.delete_source_keep_history,
                      style: const TextStyle(fontSize: 13),
                    ),
                    value: keepHistory,
                    onChanged: (value) =>
                        setState(() => keepHistory = value ?? false),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.delete_source_keep_downloads,
                      style: const TextStyle(fontSize: 13),
                    ),
                    value: keepDownloads,
                    onChanged: (value) =>
                        setState(() => keepDownloads = value ?? false),
                  ),
                  if (group.sourceId != null)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.delete_source_also_remove_extension,
                        style: const TextStyle(fontSize: 13),
                      ),
                      value: removeExtension,
                      onChanged: (value) =>
                          setState(() => removeExtension = value ?? true),
                    ),
                ],
              ),
              actions: dialogCancelConfirmActions(
                dialogContext: dialogContext,
                confirmLabel: l10n.delete_source_button,
                confirmColor: Colors.red,
              ),
            );
          },
        );
      },
    );
  }
  if (confirmed != true || !context.mounted) return;

  if (mobile) showBusyDialog(context, l10n.library_maintenance_working);
  try {
    final safetyBackupPath = await createLibrarySafetyBackup();
    await writeLastLibrarySnapshot(
      LibrarySafetySnapshot(
        backupPath: safetyBackupPath,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        description: l10n.delete_source_result_message(
          counts.mangaCount,
          group.sourceName,
        ),
      ),
    );
    if (mobile && context.mounted) ref.invalidate(lastLibrarySnapshotProvider);
    await deleteSourceLibrary(
      mangaList,
      group,
      keepHistory: keepHistory,
      keepDownloads: keepDownloads,
      alsoRemoveExtension: removeExtension,
    );
    if (!context.mounted) return;
    if (!mobile) ref.invalidate(lastLibrarySnapshotProvider);
    botToast(
      l10n.delete_source_result_message(counts.mangaCount, group.sourceName),
    );
  } catch (e) {
    botToast("Error deleting source: $e");
  } finally {
    if (mobile && context.mounted) hideBusyDialog(context);
  }
}

class _TaggedMangaCluster {
  _TaggedMangaCluster(this.group, this.cluster);

  final LibrarySourceGroup group;
  final DuplicateMangaCluster cluster;
}

Future<void> _mergeDuplicateManga(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final taggedClusters = <_TaggedMangaCluster>[];
  for (final group in librarySourceGroups(favoritesOnly: true)) {
    final mangaList = mangaForGroup(group, favoritesOnly: true);
    for (final cluster in findDuplicateMangaClusters(mangaList)) {
      taggedClusters.add(_TaggedMangaCluster(group, cluster));
    }
  }
  final mobile = isMobile && !isTv;
  if (taggedClusters.isEmpty && !mobile) {
    botToast(l10n.merge_manga_none_found);
    return;
  }

  final picked = mobile
      ? (await showMobileSettingsPicker<_TaggedMangaCluster?>(
          context,
          title: l10n.merge_manga_pick_title,
          current: null,
          searchable: taggedClusters.isNotEmpty,
          description: taggedClusters.isEmpty
              ? null
              : l10n.merge_manga_subtitle,
          emptyMessage: l10n.merge_manga_none_found,
          options: [
            for (final tagged in taggedClusters)
              MobileSettingOption(
                tagged,
                tagged.cluster.mangaList.first.name ?? '',
                subtitle:
                    '${tagged.group.sourceName} · '
                    '${librarySourceDetails(context, tagged.group, entryCount: tagged.cluster.mangaList.length)}',
              ),
          ],
        ))?.value
      : await showDialog<_TaggedMangaCluster>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text(l10n.merge_manga_pick_title),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: taggedClusters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final t = taggedClusters[index];
                    return ListTile(
                      title: Text(t.cluster.mangaList.first.name ?? ''),
                      subtitle: Text(
                        "${_itemTypeLabel(context, t.group.itemType)} • ${t.group.sourceName} • "
                        "${t.cluster.mangaList.length}",
                      ),
                      onTap: () => Navigator.pop(dialogContext, t),
                    );
                  },
                ),
              ),
              actions: dialogCancelOnlyAction(dialogContext),
            );
          },
        );
  if (picked == null || !context.mounted) return;

  final mangaList = [...picked.cluster.mangaList];
  final chapterCounts = <int, int>{
    for (final m in mangaList) m.id!: chapterRepository.countByMangaId(m.id),
  };
  mangaList.sort(
    (a, b) => (chapterCounts[b.id!] ?? 0).compareTo(chapterCounts[a.id!] ?? 0),
  );

  final primary = mobile
      ? await Navigator.push<Manga>(
          context,
          MaterialPageRoute(
            builder: (_) => MobileMergePrimary(
              manga: mangaList,
              chapterCounts: chapterCounts,
            ),
          ),
        )
      : await showDialog<Manga>(
          context: context,
          builder: (dialogContext) {
            var selected = mangaList.first;
            return StatefulBuilder(
              builder: (dialogContext, setState) {
                return AlertDialog(
                  title: Text(l10n.merge_manga_choose_primary_title),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.merge_manga_choose_primary_message,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.secondaryColor,
                          ),
                        ),
                        ...mangaList.map(
                          (m) => RadioListTile<Manga>(
                            value: m,
                            // ignore: deprecated_member_use
                            groupValue: selected,
                            // ignore: deprecated_member_use
                            onChanged: (v) => setState(() => selected = v!),
                            title: Text(m.name ?? ''),
                            subtitle: Text(
                              l10n.merge_manga_chapters_subtitle(
                                chapterCounts[m.id!] ?? 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: dialogCancelConfirmActions(
                    dialogContext: dialogContext,
                    confirmLabel: l10n.merge_manga_button,
                    onCancel: () => Navigator.pop(dialogContext, null),
                    onConfirm: () => Navigator.pop(dialogContext, selected),
                  ),
                );
              },
            );
          },
        );
  if (primary == null || !context.mounted) return;

  final others = mangaList.where((m) => m.id != primary.id).toList();
  final preview = previewMergeManga(primary, others);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        scrollable: mobile,
        title: Text(l10n.merge_preview_title),
        content: Text(
          (mobile ? '${primary.name ?? ''}\n\n' : '') +
              l10n.merge_manga_preview_message(
                preview.totalChapters,
                preview.duplicateChapters,
                preview.keptChapters,
                preview.duplicateTracks,
              ) +
              (mobile ? '\n\n${l10n.library_safety_snapshot_note}' : ''),
        ),
        actions: dialogCancelConfirmActions(
          dialogContext: dialogContext,
          confirmLabel: l10n.merge_manga_button,
        ),
      );
    },
  );
  if (confirmed != true || !context.mounted) return;

  if (mobile) showBusyDialog(context, l10n.library_maintenance_working);
  try {
    final safetyBackupPath = await createLibrarySafetyBackup();
    await writeLastLibrarySnapshot(
      LibrarySafetySnapshot(
        backupPath: safetyBackupPath,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        description: l10n.merge_manga_result_message(
          others.length,
          primary.name ?? '',
        ),
      ),
    );
    if (mobile && context.mounted) ref.invalidate(lastLibrarySnapshotProvider);
    await mergeMangaGroup(primary, others);
    if (!context.mounted) return;
    if (!mobile) ref.invalidate(lastLibrarySnapshotProvider);
    botToast(
      l10n.merge_manga_result_message(others.length, primary.name ?? ''),
    );
  } catch (e) {
    botToast("Error merging manga: $e");
  } finally {
    if (mobile && context.mounted) hideBusyDialog(context);
  }
}
