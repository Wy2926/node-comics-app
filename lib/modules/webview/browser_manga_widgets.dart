import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/browser_manga_shelf.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';

import 'browser_manga_preview.dart';

class BrowserMangaButton extends StatelessWidget {
  const BrowserMangaButton(
    this.preview, {
    super.key,
    required this.openChapter,
  });
  final BrowserMangaPreview preview;
  final ValueChanged<int> openChapter;

  @override
  Widget build(BuildContext context) => NodeLaneLiveBubbleButton(
    title: context.l10n.manga,
    editor: SingleChildScrollView(child: _MangaCard(preview, openChapter)),
    builder: (_, open, expanded) => NodeLaneIconButton(
      tooltip: '${context.l10n.manga} · ${preview.name}',
      icon: NodeLaneIcons.of(context).manga,
      style: NodeLaneIconButtonStyle.plain,
      active: expanded,
      onPressed: open,
    ),
  );
}

class _MangaCard extends ConsumerStatefulWidget {
  _MangaCard(this.preview, this.openChapter) : super(key: ValueKey(preview));
  final BrowserMangaPreview preview;
  final ValueChanged<int> openChapter;

  @override
  ConsumerState<_MangaCard> createState() => _MangaCardState();
}

class _MangaCardState extends ConsumerState<_MangaCard> {
  bool _busy = false;
  String? _error;
  bool get _current => mounted && ModalRoute.isCurrentOf(context) == true;

  Future<void> _act(BrowserShelfEntry entry) async {
    if (_busy || !_current) return;
    final preview = widget.preview, l = context.l10n;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (entry.favoriteId == null) {
        await addBrowserManga(preview, entry.link);
        return;
      }
      var book = await browserShelfFavorite(preview, entry);
      if (!_current) return;
      // 已有目录离线也能续读；没有目录时才走原来源的详情更新，失败保留收藏。
      if (book.chapters.isEmpty) {
        await ref.read(
          updateMangaDetailProvider(
            mangaId: book.id,
            isInit: true,
            showToast: false,
          ).future,
        );
        if (!_current) return;
        book = await browserShelfFavorite(preview, entry);
        if (!_current) return;
      }
      final chapter = book
          .resumeChapter(incognito: ref.read(incognitoModeStateProvider))
          ?.resumeTarget;
      if (chapter == null) {
        _error = l.mass_migration_no_chapters_found;
        return;
      }
      if (!mounted) return;
      Navigator.pop(context);
      widget.openChapter(chapter.id!);
    } catch (_) {
      if (mounted) _error = l.operation_retry;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = browserMangaShelfProvider(widget.preview);
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MangaRow(widget.preview),
        ref
            .watch(provider)
            .when(
              loading: () =>
                  NodeLaneRow(compact: true, title: l.mass_migration_loading),
              error: (_, _) => NodeLaneRow(
                compact: true,
                title: l.retry,
                subtitle: l.browser_data_failed,
                icon: icons.refresh,
                onTap: () => ref.invalidate(provider),
              ),
              data: (entry) {
                final saved = entry.favoriteId != null;
                return NodeLaneRow(
                  title: saved ? l.browser_open_reader : l.add_to_library,
                  subtitle: saved ? l.in_library : l.not_in_library,
                  metadata: _busy ? l.mass_migration_loading : _error,
                  icon: saved ? icons.manga : icons.add,
                  accented: true,
                  enabled: !_busy,
                  onTap: () => _act(entry),
                );
              },
            ),
      ],
    );
  }
}

class _MangaRow extends StatelessWidget {
  const _MangaRow(this.preview);
  final BrowserMangaPreview preview;

  @override
  Widget build(BuildContext context) {
    final details = [
      ?preview.author,
      if (preview.status != Status.unknown)
        getMangaStatusName(preview.status, context),
    ];
    return NodeLaneRow(
      prominent: true,
      title: preview.name,
      subtitle: details.isEmpty ? null : details.join(' · '),
      metadata: preview.chapterName,
      leadingSize: const Size(
        NodeLaneTokens.shelfThumbnailWidth,
        NodeLaneTokens.shelfThumbnailHeight,
      ),
      leading: preview.imageUrl == null
          ? null
          : ClipRRect(
              borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
              child: Image(
                image: coverProvider(
                  preview.imageUrl!,
                  cache: false,
                  headers: {'Referer': '${Uri.parse(preview.link).origin}/'},
                ),
                width: NodeLaneTokens.shelfThumbnailWidth,
                height: NodeLaneTokens.shelfThumbnailHeight,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                errorBuilder: (_, _, _) =>
                    Icon(NodeLaneIcons.of(context).library),
              ),
            ),
    );
  }
}

class BrowserLinkPanel extends StatefulWidget {
  const BrowserLinkPanel({
    super.key,
    required this.url,
    required this.load,
    required this.openChapter,
  });
  final String url;
  final Future<BrowserMangaPreview?> Function() load;
  final ValueChanged<int> openChapter;

  @override
  State<BrowserLinkPanel> createState() => _BrowserLinkPanelState();
}

class _BrowserLinkPanelState extends State<BrowserLinkPanel> {
  late var result = widget.load();
  @override
  Widget build(BuildContext context) => NodeLaneBubblePanel(
    title: Uri.parse(widget.url).host,
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
            future: result,
            builder: (_, state) {
              // 换 Future 后仍可能暂存上次的错误，等待期间不重复发起重试。
              if (state.connectionState != ConnectionState.done) {
                return const SizedBox.shrink();
              }
              if (state.data case final preview?) {
                return _MangaCard(preview, widget.openChapter);
              }
              if (state.hasError) {
                return NodeLaneRow(
                  title: context.l10n.retry,
                  icon: NodeLaneIcons.of(context).refresh,
                  onTap: () => setState(() {
                    result = widget.load();
                  }),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          NodeLaneRow(
            title: context.l10n.browser_background_tab,
            icon: NodeLaneIcons.of(context).add,
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ),
  );
}
