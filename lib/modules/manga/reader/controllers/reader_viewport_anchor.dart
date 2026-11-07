import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// A visible item's position inside the viewport, independent of its list index.
class ReaderViewportAnchor {
  const ReaderViewportAnchor(this.identity, this.leading);
  final String identity;
  final double leading;
}

/// Only mounted cells are retained. Chapter loading and page grouping stay with
/// the caller; this controller measures and restores an image's viewport offset.
class ReaderViewportAnchorController {
  ReaderViewportAnchorController({this.onLayoutChanged});

  final VoidCallback? onLayoutChanged;
  final _items = <String, BuildContext>{};
  final _retained = ValueNotifier<String?>(null);

  (double, double, double)? _geometry(
    String identity,
    AxisDirection direction,
  ) {
    final context = _items[identity];
    if (context == null || !context.mounted) return null;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    final parent = RenderAbstractViewport.maybeOf(box);
    if (parent is! RenderBox) return null;
    final viewport = parent as RenderBox;
    for (
      RenderObject? item = box;
      item != null && item != viewport;
      item = item.parent
    ) {
      final data = item.parentData;
      if (data is SliverMultiBoxAdaptorParentData && data.keptAlive) {
        return null;
      }
    }
    final offset = box.localToGlobal(Offset.zero, ancestor: viewport);
    final leading = switch (direction) {
      AxisDirection.down => offset.dy,
      AxisDirection.up => viewport.size.height - offset.dy - box.size.height,
      AxisDirection.right => offset.dx,
      AxisDirection.left => viewport.size.width - offset.dx - box.size.width,
    };
    final vertical =
        direction == AxisDirection.up || direction == AxisDirection.down;
    return (
      leading,
      vertical ? box.size.height : box.size.width,
      vertical ? viewport.size.height : viewport.size.width,
    );
  }

  ReaderViewportAnchor? capture(ScrollController scroll) {
    if (!scroll.hasClients) return null;
    ReaderViewportAnchor? anchor;
    for (final itemIdentity in _items.keys) {
      final geometry = _geometry(itemIdentity, scroll.position.axisDirection);
      if (geometry == null) continue;
      final (leading, extent, viewport) = geometry;
      if (leading + extent <= 0.5 || leading >= viewport - 0.5) continue;
      if (anchor == null || leading < anchor.leading) {
        anchor = ReaderViewportAnchor(itemIdentity, leading);
      }
    }
    return anchor;
  }

  /// Move index-based extent measurements with their stable item identities.
  /// Called before the list rebuilds, outside layout.
  void reindex({
    required List<String> oldItems,
    required List<String> newItems,
    required ListController list,
  }) {
    if (!list.isAttached) return;
    if (list.numberOfItems != oldItems.length) {
      // Discovering a wide image can already have regrouped the spreads.
      // Their old sizes cannot be reused against that different grouping.
      list.invalidateAllExtents();
      return;
    }
    var prefix = 0;
    while (prefix < oldItems.length &&
        prefix < newItems.length &&
        oldItems[prefix] == newItems[prefix]) {
      prefix++;
    }
    var suffix = 0;
    while (suffix < oldItems.length - prefix &&
        suffix < newItems.length - prefix &&
        oldItems[oldItems.length - 1 - suffix] ==
            newItems[newItems.length - 1 - suffix]) {
      suffix++;
    }
    for (var i = prefix; i < oldItems.length - suffix; i++) {
      list.removeItem(prefix);
    }
    for (var i = prefix; i < newItems.length - suffix; i++) {
      list.addItem(i);
    }
  }

  Future<void> restore(
    ReaderViewportAnchor anchor, {
    required int index,
    required ListController list,
    required ScrollController scroll,
    required bool Function() isCurrent,
  }) async {
    bool ready() => isCurrent() && scroll.hasClients && list.isAttached;
    double? leading() =>
        _geometry(anchor.identity, scroll.position.axisDirection)?.$1;
    _retained.value = anchor.identity;
    try {
      await WidgetsBinding.instance.endOfFrame;
      if (!ready()) return;
      var offset = leading();
      // Materialize an offscreen anchor once, then measure the actual image
      // inside its heading/gap. Later image resizes notify their own correction.
      if (offset == null) {
        list.jumpToItem(index: index, scrollController: scroll, alignment: 0);
        await WidgetsBinding.instance.endOfFrame;
        if (!ready()) return;
        offset = leading();
      }
      if (offset == null) return;
      final delta = offset - anchor.leading;
      if (delta.abs() < 0.5) return;
      scroll.jumpTo(
        (scroll.offset + delta).clamp(
          scroll.position.minScrollExtent,
          scroll.position.maxScrollExtent,
        ),
      );
      await WidgetsBinding.instance.endOfFrame;
    } finally {
      _retained.value = null;
    }
  }
}

/// Place around the image/spread, inside any chapter heading or page gap.
class ReaderViewportItem extends StatefulWidget {
  const ReaderViewportItem({
    super.key,
    required this.identity,
    required this.controller,
    required this.child,
  });
  final String identity;
  final ReaderViewportAnchorController controller;
  final Widget child;

  @override
  State<ReaderViewportItem> createState() => _ReaderViewportItemState();
}

class _ReaderViewportItemState extends State<ReaderViewportItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive =>
      widget.controller._retained.value == widget.identity;

  @override
  void initState() {
    super.initState();
    widget.controller._items[widget.identity] = context;
    widget.controller._retained.addListener(updateKeepAlive);
  }

  @override
  void didUpdateWidget(ReaderViewportItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.identity != widget.identity ||
        oldWidget.controller != widget.controller) {
      _unregister(oldWidget);
      oldWidget.controller._retained.removeListener(updateKeepAlive);
      widget.controller._items[widget.identity] = context;
      widget.controller._retained.addListener(updateKeepAlive);
      updateKeepAlive();
    }
  }

  void _unregister(ReaderViewportItem item) {
    if (identical(item.controller._items[item.identity], context)) {
      item.controller._items.remove(item.identity);
    }
  }

  @override
  void dispose() {
    _unregister(widget);
    widget.controller._retained.removeListener(updateKeepAlive);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        widget.controller.onLayoutChanged?.call();
        return true;
      },
      child: SizeChangedLayoutNotifier(child: widget.child),
    );
  }
}
