import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// Search controls stay above a single, full-width results viewport.
class SourceResultsLayout extends StatelessWidget {
  const SourceResultsLayout({
    super.key,
    required this.tools,
    required this.results,
  });
  final Widget tools, results;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: box.maxHeight * .5),
          child: SingleChildScrollView(
            primary: false,
            padding: NodeLaneTokens.headerPadding,
            child: tools,
          ),
        ),
        Divider(height: 1, color: NodeLaneTokens.of(context).line),
        Expanded(child: results),
      ],
    ),
  );
}

/// System Back removes the same inline level as the pane's back button.
class SourceBrowseHistory<T extends Object>
    extends ValueNotifier<({T? site, int? book, int visit})> {
  SourceBrowseHistory() : super((site: null, book: null, visit: 0));
  LocalHistoryEntry? _site, _book;
  bool _disposed = false;

  LocalHistoryEntry _entry(BuildContext context, VoidCallback remove) {
    final entry = LocalHistoryEntry(
      onRemove: () {
        if (!_disposed) remove();
      },
    );
    ModalRoute.of(context)!.addLocalHistoryEntry(entry);
    return entry;
  }

  // Tapping the same card after scrolling back up also reveals its existing row.
  void _show(T? site, int? book) =>
      value = (site: site, book: book, visit: value.visit + 1);

  void openSite(BuildContext context, T site, {VoidCallback? onClose}) {
    _book?.remove();
    _site ??= _entry(context, () {
      _site = null;
      _show(null, null);
      onClose?.call();
    });
    _show(site, null);
  }

  void openBook(BuildContext context, int id) {
    _book ??= _entry(context, () {
      _book = null;
      _show(value.site, null);
    });
    _show(value.site, id);
  }

  void clear() {
    _book?.remove();
    _site?.remove();
  }

  @override
  void dispose() {
    _disposed = true;
    clear();
    super.dispose();
  }
}

/// Two content panes share the first row when they fit. Deeper levels add
/// rows in reading order, without replacing the parent's scrollable or focus.
class SourceBrowsePanes extends StatefulWidget {
  const SourceBrowsePanes({
    super.key,
    required this.directory,
    required this.visit,
    this.website,
    this.book,
    this.lockParents = false,
    this.onDirectorySettled,
  });

  final Widget directory;
  final int visit;
  final Widget? website, book;
  final bool lockParents;
  final VoidCallback? onDirectorySettled;

  @override
  State<SourceBrowsePanes> createState() => _SourceBrowsePanesState();
}

class _SourceBrowsePanesState extends State<SourceBrowsePanes> {
  final _rows = ScrollController(keepScrollOffset: false);
  final _visible = ValueNotifier((0, 0));
  ({int row, int visit, double extent})? _layout;

  @override
  void initState() {
    super.initState();
    _rows.addListener(_markVisible);
  }

  void _markVisible() {
    final extent = _layout?.extent ?? 0;
    if (extent <= 0 ||
        !_rows.hasClients ||
        !_rows.position.hasContentDimensions) {
      return;
    }
    final top = _rows.offset.clamp(0.0, _rows.position.maxScrollExtent);
    _visible.value = (
      (top / extent).floor(),
      ((top + _rows.position.viewportDimension) / extent).ceil() - 1,
    );
  }

  void _reveal(int row, double extent) {
    final next = (row: row, visit: widget.visit, extent: extent);
    if (_layout == next) return;
    final previous = _layout;
    final targetRow =
        previous != null &&
            previous.visit == next.visit &&
            previous.row == row &&
            _rows.hasClients &&
            !_rows.position.isScrollingNotifier.value
        ? _rows.offset / previous.extent
        : row.toDouble();
    _layout = next;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _layout != next || !_rows.hasClients) return;
      widget.onDirectorySettled?.call();
      _markVisible();
      final target = (targetRow * extent).clamp(
        0.0,
        _rows.position.maxScrollExtent,
      );
      if (target == _rows.offset) return;
      final duration = NodeLaneMotion.time(context);
      if (duration == Duration.zero || previous?.extent != extent) {
        _rows.jumpTo(target);
      } else {
        _rows.animateTo(
          target,
          duration: duration,
          curve: NodeLaneMotion.curve,
        );
      }
    });
  }

  @override
  void dispose() {
    _rows.dispose();
    _visible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final width = box.maxWidth, height = box.maxHeight;
      final site = widget.website, book = widget.book;
      final paired = site != null && context.hasPaneWidth(width);
      final parents =
          (site != null && !paired ? 1 : 0) + (book != null ? 1 : 0);
      final scale = context.paneTextScale;
      // Appending a row must not shrink or lay out the parent list again.
      final extent = math.max(
        height,
        kToolbarHeight + NodeLaneTokens.minTapTarget * scale,
      );
      final side = paired
          ? math.min(
              NodeLaneTokens.tabletSupportingWidth * scale,
              width * NodeLaneTokens.paneMaxFraction,
            )
          : width;
      _reveal(parents, extent);
      Widget pane(
        String key,
        Widget child,
        double w,
        int row, {
        bool beside = false,
        bool locked = false,
      }) {
        final edge = BorderSide(
          color: NodeLaneTokens.of(context).line,
          width: NodeLaneTokens.glassStroke,
        );
        return SizedBox(
          key: ValueKey(key),
          width: w,
          height: extent,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              border: BorderDirectional(
                start: beside ? edge : BorderSide.none,
                top: row > 0 ? edge : BorderSide.none,
              ),
            ),
            child: ValueListenableBuilder(
              valueListenable: _visible,
              child: PrimaryScrollController.none(child: child),
              builder: (_, range, content) {
                final active = !locked && row >= range.$1 && row <= range.$2;
                return TickerMode(
                  enabled: active,
                  child: ExcludeFocus(
                    excluding: !active,
                    child: ExcludeSemantics(
                      excluding: locked,
                      child: IgnorePointer(ignoring: locked, child: content),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }

      return SingleChildScrollView(
        controller: _rows,
        primary: false,
        child: Wrap(
          children: [
            pane(
              'directory',
              widget.directory,
              side,
              0,
              locked: widget.lockParents,
            ),
            if (site != null)
              pane(
                'site',
                site,
                paired ? width - side : width,
                paired ? 0 : 1,
                beside: paired,
                locked: widget.lockParents,
              ),
            if (book != null) pane('book', book, width, parents),
          ],
        ),
      );
    },
  );
}
