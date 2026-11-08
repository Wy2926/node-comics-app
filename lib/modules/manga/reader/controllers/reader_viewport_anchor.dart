import 'dart:async';

import 'package:flutter/foundation.dart' show precisionErrorTolerance;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// Preserve an in-flight page-scroll animation when layout changes its origin.
/// Drag input already uses the current pixels; ballistic activities restart on
/// new dimensions. Driven animations need their absolute samples translated.
class ReaderScrollController extends ScrollController {
  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) => _ReaderScrollPosition(
    physics: physics,
    context: context,
    oldPosition: oldPosition,
  );
}

class _ReaderScrollPosition extends ScrollPositionWithSingleContext {
  _ReaderScrollPosition({
    required super.physics,
    required super.context,
    super.oldPosition,
  });

  double _drivenCorrection = 0;

  @override
  void beginActivity(ScrollActivity? newActivity) {
    _drivenCorrection = 0;
    super.beginActivity(newActivity);
  }

  @override
  void correctBy(double correction) {
    if (activity is DrivenScrollActivity) _drivenCorrection += correction;
    super.correctBy(correction);
  }

  @override
  double setPixels(double newPixels) => super.setPixels(
    newPixels + (activity is DrivenScrollActivity ? _drivenCorrection : 0),
  );
}

/// A visible item's position inside the viewport, independent of its list index.
class ReaderViewportAnchor {
  const ReaderViewportAnchor(this.identity, this.leading);
  final String identity;
  final double leading;
}

/// Only mounted cells are retained. Chapter loading and page grouping stay with
/// the caller; this controller measures and restores an image's viewport offset.
class ReaderViewportAnchorController {
  final _items = <String, BuildContext>{};
  final _retained = ValueNotifier<String?>(null);
  _RenderReaderViewport? _viewport;
  _AnchorRequest? _pending;
  bool _disposed = false;

  void dispose() {
    cancelRestore();
    _disposed = true;
    _viewport = null;
    _items.clear();
    _retained.dispose();
  }

  void cancelRestore() {
    final pending = _pending;
    _pending = null;
    _retained.value = null;
    if (pending != null && !pending.done.isCompleted) pending.done.complete();
  }

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

  // SuperSliverList uses dead reckoning: its laid-out origin can differ from
  // the sum of unmeasured extents. Start at a mounted cell, including its heading.
  double _offsetForIndex(
    int index,
    ListController list,
    _RenderReaderViewport viewport,
  ) {
    var target = 0.0;
    var from = 0;
    for (final context in _items.values) {
      RenderObject? cell = context.findRenderObject();
      while (cell != null &&
          cell.parentData is! SliverMultiBoxAdaptorParentData) {
        cell = cell.parent;
      }
      if (cell is! RenderBox || !cell.attached || !cell.hasSize) continue;
      final data = cell.parentData! as SliverMultiBoxAdaptorParentData;
      if (data.keptAlive || data.index == null) continue;
      final local = cell.localToGlobal(Offset.zero, ancestor: viewport);
      final leading = switch (viewport.axisDirection) {
        AxisDirection.down => local.dy,
        AxisDirection.up => viewport.size.height - local.dy - cell.size.height,
        AxisDirection.right => local.dx,
        AxisDirection.left => viewport.size.width - local.dx - cell.size.width,
      };
      target = viewport.offset.pixels + leading;
      from = data.index!;
      break;
    }
    for (var i = from; i < index; i++) {
      target += list.extentForIndex(i).$1;
    }
    for (var i = index; i < from; i++) {
      target -= list.extentForIndex(i).$1;
    }
    return target;
  }

  ReaderViewportAnchor? capture(ScrollController scroll) {
    if (!scroll.hasClients) return null;
    return _capture(scroll.position.axisDirection);
  }

  ReaderViewportAnchor? _capture(AxisDirection direction) {
    ReaderViewportAnchor? anchor;
    for (final itemIdentity in _items.keys) {
      final geometry = _geometry(itemIdentity, direction);
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

  /// Request a position for the next layout, including the very first frame.
  /// Image loading never schedules navigation or waits for scrolling to stop.
  Future<void> restore(
    ReaderViewportAnchor anchor, {
    required int index,
    required ListController list,
    required bool Function() isCurrent,
  }) {
    cancelRestore();
    final request = _pending = _AnchorRequest(anchor, index, list, isCurrent);
    _retained.value = anchor.identity;
    _viewport?.markNeedsLayout();
    return request.done.future;
  }
}

class _AnchorRequest {
  _AnchorRequest(this.anchor, this.index, this.list, this.isCurrent);
  final ReaderViewportAnchor anchor;
  final int index;
  final ListController list;
  final bool Function() isCurrent;
  final done = Completer<void>();
}

/// The image list owns geometry; network/progress/error widgets only supply
/// content. Keep the visible image in place before painting, including during
/// a drag or ballistic scroll, without jumpTo cancelling the scroll activity.
class ReaderViewportList extends SuperListView {
  ReaderViewportList({
    super.key,
    required this.viewportAnchor,
    required super.itemBuilder,
    required super.itemCount,
    required super.listController,
    required super.controller,
    super.findChildIndexCallback,
    super.extentEstimation,
    this.imageCacheExtent = 250,
    super.physics,
    super.scrollDirection,
    super.reverse,
  }) : super.builder(padding: EdgeInsets.zero, cacheExtent: imageCacheExtent);

  final ReaderViewportAnchorController viewportAnchor;
  final double imageCacheExtent;

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset offset,
    AxisDirection axisDirection,
    List<Widget> slivers,
  ) => _ReaderViewport(
    controller: viewportAnchor,
    offset: offset,
    axisDirection: axisDirection,
    scrollCacheExtent: ScrollCacheExtent.pixels(imageCacheExtent),
    slivers: slivers,
  );
}

class _ReaderViewport extends Viewport {
  _ReaderViewport({
    required this.controller,
    required super.offset,
    required super.axisDirection,
    required super.scrollCacheExtent,
    required super.slivers,
  });
  final ReaderViewportAnchorController controller;

  @override
  RenderViewport createRenderObject(BuildContext context) =>
      _RenderReaderViewport(
        controller,
        offset: offset,
        axisDirection: axisDirection,
        crossAxisDirection: Viewport.getDefaultCrossAxisDirection(
          context,
          axisDirection,
        ),
        scrollCacheExtent: scrollCacheExtent,
      );

  @override
  void updateRenderObject(BuildContext context, RenderViewport renderObject) {
    super.updateRenderObject(context, renderObject);
    (renderObject as _RenderReaderViewport).controller = controller;
  }
}

class _RenderReaderViewport extends RenderViewport {
  _RenderReaderViewport(
    this._controller, {
    required super.offset,
    required super.axisDirection,
    required super.crossAxisDirection,
    required super.scrollCacheExtent,
  });

  ReaderViewportAnchorController _controller;
  ReaderViewportAnchor? _lastAnchor;
  double? _lastPixels;

  set controller(ReaderViewportAnchorController value) {
    if (identical(value, _controller)) return;
    _controller._viewport = null;
    _controller = value;
    if (attached) value._viewport = this;
    _lastAnchor = null;
    _lastPixels = null;
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _controller._viewport = this;
  }

  @override
  void detach() {
    if (identical(_controller._viewport, this)) _controller._viewport = null;
    super.detach();
  }

  // Descendant geometry is read after the slivers finish layout, in the
  // callback phase where Flutter permits access to those measured sizes.
  T _measure<T>(T Function() read) {
    late T result;
    invokeLayoutCallback<BoxConstraints>((_) => result = read());
    return result;
  }

  @override
  void performLayout() {
    final pending = _controller._pending;
    final request = pending != null && pending.isCurrent() ? pending : null;
    final previous = _lastAnchor;
    // Scroll input since the last layout must remain effective. Only changes
    // in content geometry are compensated, never the user's reading movement.
    final expected =
        request?.anchor ??
        (previous == null
            ? null
            : ReaderViewportAnchor(
                previous.identity,
                previous.leading - (offset.pixels - _lastPixels!),
              ));
    super.performLayout();
    if (expected != null) {
      double? leading() => _measure(
        () => _controller._geometry(expected.identity, axisDirection)?.$1,
      );
      double? lastEstimate;
      while (leading() == null && request != null && request.list.isAttached) {
        final target = _measure(
          () => _controller._offsetForIndex(request.index, request.list, this),
        );
        if (!target.isFinite || target == lastEstimate) break;
        lastEstimate = target;
        offset.correctBy(target - offset.pixels);
        super.performLayout();
      }
      final actual = leading();
      if (actual != null) {
        final position = offset as ScrollPosition;
        final target = (offset.pixels + actual - expected.leading).clamp(
          position.minScrollExtent,
          position.maxScrollExtent,
        );
        final delta = target - offset.pixels;
        if (delta.abs() > precisionErrorTolerance) {
          offset.correctBy(delta);
          super.performLayout();
        }
      }
    }
    _lastAnchor = _measure(() => _controller._capture(axisDirection));
    _lastPixels = offset.pixels;
    if (pending != null) {
      final controller = _controller;
      controller._pending = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!controller._disposed && controller._pending == null) {
          controller._retained.value = null;
        }
        if (!pending.done.isCompleted) pending.done.complete();
      });
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
  void activate() {
    super.activate();
    widget.controller._items[widget.identity] = context;
  }

  @override
  void deactivate() {
    _unregister(widget);
    super.deactivate();
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
    return widget.child;
  }
}
