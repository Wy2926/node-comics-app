import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/widgets/source_result_widgets.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Both search and migration use the same cover, library match and TV focus.
/// Migration matches its target source; discovery can also mark other editions.
class GlobalSearchResultCard extends ConsumerStatefulWidget {
  const GlobalSearchResultCard({
    super.key,
    required this.manga,
    required this.source,
    required this.onActivate,
    this.onQuickAdd,
    this.padding = EdgeInsets.zero,
    this.autofocus = false,
    this.matchAnySource = false,
    this.carousel,
    this.coverSize = const Size(110, 150),
  });
  final MManga manga;
  final Source source;
  final VoidCallback onActivate;
  final VoidCallback? onQuickAdd;
  final EdgeInsetsGeometry padding;
  final bool autofocus, matchAnySource;

  /// Carousels supply bounded geometry; legacy desktop/TV lists supply a size.
  final bool? carousel;
  final Size coverSize;

  @override
  ConsumerState<GlobalSearchResultCard> createState() =>
      _GlobalSearchResultCardState();
}

class _GlobalSearchResultCardState extends ConsumerState<GlobalSearchResultCard>
    with AutomaticKeepAliveClientMixin<GlobalSearchResultCard> {
  bool _focused = false;
  bool get _carousel => widget.carousel ?? (isMobile && !isTv);
  late Stream<List<Manga>> _library = _watchLibrary();
  Stream<List<Manga>> _watchLibrary() => widget.matchAnySource
      ? mangaRepository.watchFavoritesByItemTypeAndName(
          widget.source.itemType,
          widget.manga.name,
        )
      : mangaRepository.watchByLangNameSource(
          widget.source.lang,
          widget.manga.name,
          widget.source.name,
        );

  Manga? _match(List<Manga> entries) {
    if (!widget.matchAnySource) {
      return entries
          .where((e) => e.sourceId == null || e.sourceId == widget.source.id)
          .firstOrNull;
    }
    return entries
            .where(
              (e) =>
                  e.lang == widget.source.lang &&
                  e.source == widget.source.name,
            )
            .firstOrNull ??
        entries.firstOrNull;
  }

  @override
  void didUpdateWidget(covariant GlobalSearchResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.manga.name != widget.manga.name ||
        oldWidget.source.id != widget.source.id ||
        oldWidget.source.itemType != widget.source.itemType ||
        oldWidget.source.name != widget.source.name ||
        oldWidget.source.lang != widget.source.lang ||
        oldWidget.matchAnySource != widget.matchAnySource) {
      _library = _watchLibrary();
    }
  }

  Widget _cover(Manga? matched, double width) {
    final placeholder = Icon(
      Icons.auto_stories_outlined,
      size: NodeLaneTokens.emptyStateIconSize,
      color: NodeLaneTokens.of(context).muted,
    );
    final bytes = matched?.customCoverImage;
    final rawUrl = matched == null
        ? widget.manga.imageUrl ?? ''
        : matched.customCoverFromTracker ?? matched.imageUrl ?? '';
    if (bytes == null && rawUrl.trim().isEmpty) return placeholder;
    try {
      final image = bytes != null
          ? ResizeImage.resizeIfNeeded(
              (width * MediaQuery.devicePixelRatioOf(context)).round(),
              null,
              MemoryImage(bytes as Uint8List),
            )
          : coverProvider(
              toImgUrl(rawUrl),
              headers: ref.watch(
                headersProvider(
                  source: widget.source.name!,
                  lang: widget.source.lang!,
                  sourceId: widget.source.id,
                ),
              ),
            );
      return Image(
        image: image,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      );
    } catch (_) {
      return placeholder;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Manga>>(
      stream: _library,
      builder: (context, snapshot) {
        final matched = _match(snapshot.data ?? const []);
        Widget card(double width) => SourceResultCover(
          title: widget.manga.name ?? '',
          cover: _cover(matched, width),
          inLibrary: matched?.favorite ?? false,
          onOpen: widget.onActivate,
          onQuickAdd: widget.onQuickAdd,
        );
        if (_carousel) {
          return LayoutBuilder(
            builder: (_, constraints) => card(constraints.maxWidth),
          );
        }
        final t = NodeLaneTokens.of(context);
        return Focus(
          autofocus: widget.autofocus,
          onFocusChange: (focused) {
            setState(() => _focused = focused);
            if (focused && Scrollable.maybeOf(context) != null) {
              Scrollable.ensureVisible(
                context,
                alignment: .5,
                duration: NodeLaneTokens.disclosureDuration,
                curve: Curves.easeOut,
              );
            }
          },
          onKeyEvent: (_, event) {
            if (event is KeyDownEvent && tvIsSelectKey(event.logicalKey)) {
              widget.onActivate();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: Padding(
            padding: widget.padding,
            child: AnimatedContainer(
              duration: NodeLaneTokens.disclosureDuration,
              curve: Curves.easeOut,
              transform: Matrix4.diagonal3Values(
                _focused ? 1.06 : 1,
                _focused ? 1.06 : 1,
                1,
              ),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
                border: Border.all(
                  color: _focused ? t.accent : Colors.transparent,
                  width: 2,
                ),
              ),
              child: SizedBox(
                width: widget.coverSize.width,
                height:
                    widget.coverSize.height +
                    NodeLaneTokens.space8 +
                    SourceResultCover.captionHeight(context),
                child: card(widget.coverSize.width),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => !_carousel;
}
