import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// Change only the bookmark on the latest record, preserving reader progress
/// written while the chapter picker was open. Do not recreate removed records.
Future<void> saveReaderChapterBookmark(Chapter chapter, bool value) =>
    chapterRepository.writeTransaction(() {
      final current = chapterRepository.findByIdSync(chapter.id!);
      if (current == null || current.mangaId != chapter.mangaId) {
        throw StateError('Chapter no longer available');
      }
      current.isBookmarked = value;
      current.updatedAt = DateTime.now().millisecondsSinceEpoch;
      chapterRepository.putSync(current);
    });

class MobileReaderChaptersButton extends StatefulWidget {
  const MobileReaderChaptersButton({
    super.key,
    required this.chapter,
    this.onChanged,
  });
  final Chapter chapter;
  final ValueChanged<bool>? onChanged;

  @override
  State<MobileReaderChaptersButton> createState() =>
      _MobileReaderChaptersButtonState();
}

class _MobileReaderChaptersButtonState
    extends State<MobileReaderChaptersButton> {
  bool _open = false;

  Future<void> _show() async {
    if (_open || ModalRoute.of(context)?.isCurrent != true) return;
    _open = true;
    final owner = widget.chapter;
    widget.onChanged?.call(false);
    try {
      final chapters = owner.manga.value!.getSortedFilteredChapters();
      final selected = await showModalBottomSheet<Chapter>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        showDragHandle: false,
        shape: NodeLaneTokens.readerSheetShape,
        builder: (_) => MobileReaderChaptersSheet(
          chapter: owner,
          chapters: chapters,
          onBookmark: saveReaderChapterBookmark,
        ),
      );
      if (!mounted ||
          selected == null ||
          widget.chapter.id != owner.id ||
          ModalRoute.of(context)?.isCurrent != true) {
        return;
      }
      final latest = chapterRepository.findByIdSync(selected.id!);
      if (latest == null || latest.mangaId != owner.mangaId) {
        throw StateError('Chapter no longer available');
      }
      MangaChapterPageGalleryState.setNavigatingToChapter();
      pushReplacementMangaReaderView(context: context, chapter: latest);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.manga_action_incomplete)),
        );
      }
    } finally {
      _open = false;
      if (mounted) widget.onChanged?.call(true);
    }
  }

  @override
  Widget build(BuildContext context) => MobileReaderAction(
    label: context.l10n.chapters,
    icon: NodeLaneIcons.of(context).chapters,
    onPressed: _show,
  );
}

/// A local search over the reader's existing sorted, filtered chapter snapshot.
/// Selection returns to the owning reader before it performs route replacement.
class MobileReaderChaptersSheet extends StatefulWidget {
  const MobileReaderChaptersSheet({
    super.key,
    required this.chapter,
    required this.chapters,
    required this.onBookmark,
  });
  final Chapter chapter;
  final List<Chapter> chapters;
  final Future<void> Function(Chapter, bool) onBookmark;

  @override
  State<MobileReaderChaptersSheet> createState() =>
      _MobileReaderChaptersSheetState();
}

class _MobileReaderChaptersSheetState extends State<MobileReaderChaptersSheet> {
  final _search = TextEditingController();
  final _scroll = ScrollController();
  final _list = ListController();
  final _bookmarks = <int, bool>{};
  late List<Chapter> _visible = widget.chapters;
  late final _currentIndex = widget.chapters.indexWhere(_isCurrent);
  int _jumpRevision = 0;
  int? _savingId;
  bool _leaving = false, _failed = false;
  bool get _busy => _savingId != null;

  bool _isCurrent(Chapter chapter) =>
      chapter.id == widget.chapter.id &&
      chapter.mangaId == widget.chapter.mangaId;

  @override
  void initState() {
    super.initState();
    if (_currentIndex >= 0) _schedulePosition(_currentIndex);
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    _list.dispose();
    super.dispose();
  }

  void _schedulePosition([int? index]) {
    final revision = ++_jumpRevision;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || revision != _jumpRevision || !_scroll.hasClients) return;
      if (index != null && _list.isAttached && index < _visible.length) {
        _list.jumpToItem(
          index: index,
          scrollController: _scroll,
          alignment: .2,
        );
      } else {
        _scroll.jumpTo(0);
      }
    });
  }

  void _filter(String value) {
    final query = value.trim().toLowerCase();
    setState(() {
      _visible = query.isEmpty
          ? widget.chapters
          : widget.chapters
                .where(
                  (chapter) =>
                      (chapter.name ?? '').toLowerCase().contains(query) ||
                      (chapter.scanlator ?? '').toLowerCase().contains(query),
                )
                .toList();
    });
    _schedulePosition();
  }

  void _locate() {
    _search.clear();
    FocusScope.of(context).unfocus();
    setState(() => _visible = widget.chapters);
    _schedulePosition(_currentIndex);
  }

  void _close([Chapter? chapter]) {
    if (_busy ||
        _leaving ||
        !mounted ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _leaving = true;
    Navigator.pop(
      context,
      chapter != null && !_isCurrent(chapter) ? chapter : null,
    );
  }

  Future<void> _bookmark(Chapter chapter) async {
    if (_busy ||
        _failed ||
        _leaving ||
        !mounted ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    final value = !(_bookmarks[chapter.id] ?? chapter.isBookmarked ?? false);
    FocusScope.of(context).unfocus();
    setState(() => _savingId = chapter.id);
    try {
      await widget.onBookmark(chapter, value);
      if (mounted) setState(() => _bookmarks[chapter.id!] = value);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _savingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    final media = MediaQuery.of(context);
    return PopScope(
      canPop: !_busy,
      child: Padding(
        padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
        child: LayoutBuilder(
          builder: (context, constraints) => NodeLaneReaderSurface(
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: math.min(
                  media.size.height * NodeLaneTokens.readerSheetFraction -
                      media.padding.bottom,
                  constraints.maxHeight - media.padding.bottom,
                ),
                child: Column(
                  children: [
                    NodeLaneReaderHeading(
                      title: '${l10n.chapters} · ${_visible.length}',
                      closeLabel: l10n.close,
                      onClose: _busy ? null : () => _close(),
                      actions: [
                        IconButton(
                          tooltip: l10n.reader_chapter_locate,
                          onPressed: _currentIndex >= 0 && !_busy
                              ? _locate
                              : null,
                          icon: Icon(
                            NodeLaneIcons.of(context).locate,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: NodeLaneTextField.search(
                        controller: _search,
                        enabled: !_busy,
                        hint: l10n.reader_chapter_search,
                        clearLabel: l10n.error_reports_clear,
                        onChanged: _filter,
                      ),
                    ),
                    if (_failed)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        child: Text(
                          l10n.reader_chapter_bookmark_failed,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Scrollbar(
                        controller: _scroll,
                        child: CustomScrollView(
                          controller: _scroll,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  4,
                                  20,
                                  12,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      widget.chapter.manga.value?.name ?? '',
                                      style: colors.readerLabel.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      l10n.reader_chapter_scope,
                                      style: colors.readerSecondary,
                                    ),
                                    if (_currentIndex < 0)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          l10n.reader_chapter_current_hidden,
                                          style: colors.readerSecondary,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (_visible.isEmpty)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    l10n.no_result,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              sliver: SuperSliverList.builder(
                                listController: _list,
                                itemCount: _visible.length,
                                itemBuilder: (context, index) {
                                  final chapter = _visible[index];
                                  final bookmarked =
                                      _bookmarks[chapter.id] ??
                                      chapter.isBookmarked ??
                                      false;
                                  return Padding(
                                    key: ValueKey(chapter.id),
                                    padding: EdgeInsets.zero,
                                    child: _ReaderChapterRow(
                                      first: index == 0,
                                      last: index == _visible.length - 1,
                                      chapter: chapter,
                                      current: _isCurrent(chapter),
                                      bookmarked: bookmarked,
                                      saving: _savingId == chapter.id,
                                      onSelect: _busy
                                          ? null
                                          : () => _close(chapter),
                                      onBookmark: _busy || _failed
                                          ? null
                                          : () => _bookmark(chapter),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReaderChapterRow extends ConsumerWidget {
  const _ReaderChapterRow({
    required this.chapter,
    required this.first,
    required this.last,
    required this.current,
    required this.bookmarked,
    required this.saving,
    this.onSelect,
    this.onBookmark,
  });
  final Chapter chapter;
  final bool current, bookmarked, saving, first, last;
  final VoidCallback? onSelect, onBookmark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    String date = '';
    if (!(chapter.manga.value?.isLocalArchive ?? false) &&
        (chapter.dateUpload?.isNotEmpty ?? false)) {
      try {
        date = dateFormat(chapter.dateUpload, ref: ref, context: context);
      } catch (_) {
        /* Invalid source dates do not hide a chapter. */
      }
    }
    final details = <String>[
      current
          ? l10n.reader_chapter_current
          : (chapter.isRead ?? false)
          ? l10n.reader_chapter_read
          : l10n.unread,
      if (date.isNotEmpty) date,
      if (chapter.scanlator?.isNotEmpty ?? false) chapter.scanlator!,
      if (!(chapter.isRead ?? false) &&
          (chapter.lastPageRead?.isNotEmpty ?? false) &&
          chapter.lastPageRead != '1')
        l10n.page(chapter.lastPageRead!),
    ];
    return Semantics(
      selected: current,
      child: Material(
        color: current ? colors.accentSoft : colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(first ? NodeLaneTokens.groupRadius : 0),
          bottom: Radius.circular(last ? NodeLaneTokens.groupRadius : 0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              minTileHeight: NodeLaneTokens.readerChapterHeight,
              contentPadding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
              title: Text(
                chapter.name ?? '',
                style: colors.readerLabel.copyWith(
                  fontWeight: current ? FontWeight.w600 : FontWeight.w400,
                  color: current ? colors.accent : colors.ink,
                ),
              ),
              subtitle: Text(
                details.join(' · '),
                style: colors.readerSecondary.copyWith(
                  color: current ? colors.accent : colors.muted,
                ),
              ),
              onTap: onSelect,
              trailing: saving
                  ? const SizedBox(
                      width: 48,
                      child: Center(
                        child: SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : IconButton(
                      tooltip: bookmarked
                          ? l10n.chapter_remove_bookmark
                          : l10n.chapter_add_bookmark,
                      onPressed: onBookmark,
                      icon: Icon(
                        bookmarked
                            ? NodeLaneIcons.of(context).bookmark
                            : NodeLaneIcons.of(context).bookmarkOutline,
                        color: bookmarked ? colors.accent : colors.ink,
                      ),
                    ),
            ),
            if (!last) Divider(height: 1, indent: 16, color: colors.line),
          ],
        ),
      ),
    );
  }
}
