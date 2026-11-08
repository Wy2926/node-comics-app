import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/modules/manga/detail/widgets/custom_floating_action_btn.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/mass_migration/services/mass_migration_service.dart';
import 'package:mangayomi/modules/widgets/category_selection_dialog.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_view.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';

enum _DuplicateLibraryAction { addAnyway, migrate }

class MangaDetailsView extends ConsumerStatefulWidget {
  final Manga manga;
  final bool sourceExist;
  final bool loading;
  final Future<void> Function() onRefresh;
  const MangaDetailsView({
    super.key,
    required this.sourceExist,
    required this.manga,
    required this.onRefresh,
    this.loading = false,
  });

  @override
  ConsumerState<MangaDetailsView> createState() => _MangaDetailsViewState();
}

class _MangaDetailsViewState extends ConsumerState<MangaDetailsView> {
  /// "Add to library" entry point: checks whether this exact title is
  /// already favorited under a different source first, so the same manga
  /// can't end up as two separate library entries by accident. Only warns —
  /// the underlying add still runs unchanged when there's no duplicate, or
  /// once the user picks Add Anyway.
  Future<void> _onAddToLibraryPressed(BuildContext context) async {
    final model = widget.manga;
    final duplicates = (await mangaRepository.findFavoritesByItemTypeAndName(
      model.itemType,
      model.name,
    )).where((m) => m.id != model.id).toList();

    if (duplicates.isNotEmpty) {
      final oldManga = duplicates.first;
      final oldSource = oldManga.sourceId != null
          ? sourceRepository.getById(oldManga.sourceId!)
          : null;
      if (!context.mounted) return;
      final action = await _showAlreadyInLibraryDialog(
        context,
        model,
        oldSource?.name ?? '',
      );
      if (action == null) return;
      if (!context.mounted) return;
      if (action == _DuplicateLibraryAction.migrate) {
        await _migrateExistingToThisSource(context, oldManga, model);
        return;
      }
      // addAnyway falls through to the normal add below.
    }
    if (context.mounted) await _addToLibrary(context, model);
  }

  Future<void> _addToLibrary(BuildContext context, Manga model) async {
    final checkCategoryList = categoryRepository.isNotEmptyByItemType(
      model.itemType,
    );
    if (checkCategoryList) {
      showCategorySelectionDialog(
        context: context,
        ref: ref,
        itemType: model.itemType,
        singleManga: model,
      );
    } else {
      model.favorite = true;
      model.dateAdded = DateTime.now().millisecondsSinceEpoch;
      await mangaRepository.save(model);
    }
  }

  Future<_DuplicateLibraryAction?> _showAlreadyInLibraryDialog(
    BuildContext context,
    Manga model,
    String oldSourceName,
  ) {
    final l10n = l10nLocalizations(context)!;
    return showDialog<_DuplicateLibraryAction>(
      context: context,
      builder: (ctx) => NodeLaneAlertDialog(
        title: Text(model.name ?? ''),
        content: Text(l10n.already_in_library(oldSourceName, model.name ?? '')),
        actions: [
          NodeLaneDialogAction(
            label: l10n.migrate,
            onPressed: () =>
                Navigator.pop(ctx, _DuplicateLibraryAction.migrate),
          ),
          NodeLaneDialogAction(
            label: l10n.add_anyway,
            secondary: true,
            onPressed: () =>
                Navigator.pop(ctx, _DuplicateLibraryAction.addAnyway),
          ),
          NodeLaneDialogAction(
            label: l10n.cancel,
            secondary: true,
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  /// Rewrites [oldManga] (the existing library entry) to track this source
  /// instead, folding in its chapters/progress via the same path the manual
  /// Migrate screen uses, then drops [newManga] — the row for the page
  /// currently open — since its data is now redundant with the migrated
  /// [oldManga].
  Future<void> _migrateExistingToThisSource(
    BuildContext context,
    Manga oldManga,
    Manga newManga,
  ) async {
    if (newManga.sourceId == null || newManga.link == null) return;
    final destinationSource = sourceRepository.getById(newManga.sourceId!);
    if (destinationSource == null) return;

    final selectedManga = MManga(
      name: newManga.name,
      link: newManga.link,
      imageUrl: newManga.imageUrl,
    );
    final preview = await ref.read(
      getDetailProvider(url: newManga.link!, source: destinationSource).future,
    );
    await migrateLibraryItem(
      ref: ref,
      oldManga: oldManga,
      selectedManga: selectedManga,
      preview: preview,
      destinationSource: destinationSource,
    );
    await mangaRepository.deleteLibrarySourceGroup([newManga]);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    bool? isLocalArchive = widget.manga.isLocalArchive ?? false;
    final mobile = isMobile && !isTv;
    final page = Scaffold(
      floatingActionButton: mobile ? null : _readingAction(false),
      body: MangaDetailView(
        loading: widget.loading,
        readingAction: mobile ? _readingAction(true) : null,
        titleDescription: mobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.loading &&
                      !(widget.manga.author?.trim().isNotEmpty ?? false))
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: NodeLaneTokens.space4,
                      ),
                      child: NodeLaneSkeleton(
                        height: NodeLaneTokens.space12,
                        width: 96,
                      ),
                    )
                  else
                    Text(
                      l10n.manga_author(
                        (widget.manga.author?.trim().isNotEmpty ?? false)
                            ? widget.manga.author!
                            : l10n.unknown,
                      ),
                    ),
                  if (widget.loading && widget.manga.status == Status.unknown)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: NodeLaneTokens.space4,
                      ),
                      child: NodeLaneSkeleton(
                        height: NodeLaneTokens.space12,
                        width: 64,
                      ),
                    )
                  else
                    Text(getMangaStatusName(widget.manga.status, context)),
                  if (!isLocalArchive)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '${widget.manga.source} · ${widget.manga.lang!.toUpperCase()}',
                        ),
                        if (!widget.sourceExist)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.warning_amber,
                              color: Colors.deepOrangeAccent,
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        mobile
                            ? NodeLaneIcons.of(context).account
                            : Icons.person_outline,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        (widget.manga.author?.isEmpty ?? false)
                            ? l10n.unknown
                            : widget.manga.author!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(getMangaStatusIcon(widget.manga.status), size: 14),
                      const SizedBox(width: 4),
                      Text(getMangaStatusName(widget.manga.status, context)),
                      if (!isLocalArchive) const Text(' • '),
                      if (!isLocalArchive) Text(widget.manga.source!),
                      if (!isLocalArchive)
                        Text(' (${widget.manga.lang!.toUpperCase()})'),
                      if (!isLocalArchive && !widget.sourceExist)
                        const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.warning_amber,
                            color: Colors.deepOrangeAccent,
                            size: 14,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
        action: mobile
            ? NodeLaneSecondaryButton(
                icon: widget.manga.favorite!
                    ? NodeLaneIcons.of(context).check
                    : NodeLaneIcons.of(context).add,
                onPressed: _onFavoritePressed,
                child: Text(
                  widget.manga.favorite!
                      ? l10n.in_library
                      : l10n.add_to_library,
                ),
              )
            : widget.manga.favorite!
            ? SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                  ),
                  onPressed: _onFavoritePressed,
                  child: Column(
                    children: [
                      const Icon(Icons.favorite, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        l10n.in_library,
                        style: const TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                ),
                onPressed: _onFavoritePressed,
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 20,
                      color: context.secondaryColor,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.add_to_library,
                      style: TextStyle(
                        color: context.secondaryColor,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
        manga: widget.manga,
        isExtended: (value) {
          ref.read(isExtendedStateProvider.notifier).update(value);
        },
        sourceExist: widget.sourceExist,
        onRefresh: widget.onRefresh,
        itemType: widget.manga.itemType,
      ),
    );
    return mobile ? NodeLaneSurface(child: page) : page;
  }

  Future<void> _onFavoritePressed() async {
    final model = widget.manga;
    if (model.favorite!) {
      model.favorite = false;
      model.dateAdded = 0;
      await mangaRepository.save(model);
    } else {
      await _onAddToLibraryPressed(context);
    }
  }

  Widget _readingAction(bool mobile) {
    final l10n = context.l10n;
    return Consumer(
      builder: (context, ref, child) {
        final chapters = ref.watch(chaptersListttStateProvider);
        final selecting = ref.watch(isLongPressedStateProvider);
        if (selecting || chapters.isEmpty) return const SizedBox.shrink();
        final isExtended = mobile ? false : ref.watch(isExtendedStateProvider);
        final incognito = ref.watch(incognitoModeStateProvider);
        final anime = widget.manga.itemType == ItemType.anime;
        return StreamBuilder(
          stream: historyRepository.watchByItemType(widget.manga.itemType),
          builder: (context, snapshot) {
            final historyChapter = snapshot.data
                ?.where((entry) => entry.mangaId == widget.manga.id)
                .lastOrNull
                ?.chapter
                .value;
            final resume =
                !incognito &&
                historyChapter != null &&
                chapters.any((chapter) => !(chapter.isRead ?? false));
            return _readingButton(
              mobile: mobile,
              isExtended: !isExtended,
              label: resume
                  ? (mobile && !anime
                        ? l10n.manga_continue_reading
                        : l10n.resume)
                  : (anime ? l10n.watch : l10n.read),
              onPressed: () {
                final chapter = resume
                    ? historyChapter
                    : widget.manga.getChapterListForReading().firstOrNull;
                chapter?.pushToReaderView(context);
              },
            );
          },
        );
      },
    );
  }

  Widget _readingButton({
    required bool mobile,
    required bool isExtended,
    required String label,
    required VoidCallback onPressed,
  }) => mobile
      ? FilledButton.icon(
          label: Text(label),
          icon: Icon(
            widget.manga.itemType == ItemType.anime
                ? NodeLaneIcons.of(context).anime
                : NodeLaneIcons.of(context).manga,
            size: NodeLaneTokens.iconSize,
          ),
          onPressed: onPressed,
        )
      : CustomFloatingActionBtn(
          isExtended: isExtended,
          label: label,
          onPressed: onPressed,
        );
}
