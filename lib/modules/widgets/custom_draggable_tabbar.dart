import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

Future<void> customDraggableTabBar({
  required List<Widget> tabs,
  required List<Widget> children,
  required BuildContext context,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  constraints: const BoxConstraints(maxWidth: double.infinity),
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  shape: NodeLaneTokens.readerSheetShape,
  clipBehavior: Clip.antiAlias,
  sheetAnimationStyle: NodeLaneMotion.style(context),
  builder: (_) => _TabSheet(tabs: tabs, children: children),
);

class _TabSheet extends StatefulWidget {
  const _TabSheet({required this.tabs, required this.children})
    : assert(tabs.length == children.length && tabs.length > 0);
  final List<Widget> tabs, children;

  @override
  State<_TabSheet> createState() => _TabSheetState();
}

class _TabSheetState extends State<_TabSheet>
    with SingleTickerProviderStateMixin {
  late final _tabs = NodeLaneMotion.tabs(
    length: widget.tabs.length,
    vsync: this,
  );
  final _sheet = DraggableScrollableController();
  final _header = GlobalKey();
  late final _bodies = List.generate(widget.tabs.length, (_) => GlobalKey());
  static const _max = .8;
  bool _queued = false;
  (int, double)? _fit;

  // Measure only a mounted tab, after layout. A drag must not re-fit the same content.
  void _fitAfterLayout() {
    if (_queued) return;
    _queued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _queued = false;
      if (!mounted || !_sheet.isAttached) return;
      final index = _tabs.index;
      final header = _header.currentContext?.size,
          body = _bodies[index].currentContext?.size;
      if (header == null || body == null) return;
      // Scroll past an overlaid shell bar without increasing a short sheet's height.
      final overlap = FloatingNavigationScope.enabledOf(context)
          ? MediaQuery.paddingOf(context).bottom
          : 0.0;
      final target = _sheet
          .pixelsToSize(header.height + body.height - overlap)
          .clamp(0.0, _max);
      if (_fit == (index, target)) return;
      setState(() => _fit = (index, target));
      _sheet.jumpTo(target);
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    _sheet.dispose();
    super.dispose();
  }

  Widget _page(int i, ScrollController scroll) => ListenableBuilder(
    listenable: _tabs,
    child: SizeChangedLayoutNotifier(
      key: _bodies[i],
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: widget.children[i],
      ),
    ),
    builder: (_, body) {
      // TabBarView retains the outgoing page during a swipe. Only the selected
      // page may attach to the sheet's single vertical scroll position.
      if (_tabs.index == i) _fitAfterLayout();
      return SingleChildScrollView(
        key: PageStorageKey(i),
        primary: false,
        controller: _tabs.index == i ? scroll : null,
        physics: const AlwaysScrollableScrollPhysics(),
        child: body,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final stop = _fit?.$2;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: LayoutBuilder(
        builder: (context, constraints) {
          _fitAfterLayout();
          return DraggableScrollableSheet(
            controller: _sheet,
            expand: false,
            minChildSize: 0,
            maxChildSize: _max,
            initialChildSize: _max,
            snap: true,
            snapSizes: [if (stop != null && stop > 0 && stop < _max) stop],
            builder: (context, scroll) {
              final bar = TabBar(
                key: _header,
                controller: _tabs,
                tabs: widget.tabs,
              );
              final pages = Expanded(
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    for (var i = 0; i < widget.children.length; i++)
                      _page(i, scroll),
                  ],
                ),
              );
              return NotificationListener<SizeChangedLayoutNotification>(
                onNotification: (_) {
                  _fitAfterLayout();
                  return false;
                },
                child: LayoutBuilder(
                  builder: (_, sheet) => Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: sheet.maxHeight),
                        child: bar,
                      ),
                      pages,
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
