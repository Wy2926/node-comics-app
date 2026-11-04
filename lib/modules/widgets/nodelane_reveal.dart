import 'package:flutter/material.dart';

/// A one-shot presentation request. The existing control still owns its action;
/// revealing a switch, slider or destructive action never changes its value.
class NodeLaneRevealScope extends StatefulWidget {
  const NodeLaneRevealScope({
    super.key,
    required this.path,
    required this.child,
  });

  final List<String> path;
  final Widget child;

  static bool activeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RevealScope>() != null;

  static bool expands(BuildContext context, String title) =>
      context
          .dependOnInheritedWidgetOfExactType<_RevealScope>()
          ?.request
          .path
          .contains(title) ??
      false;

  static void reveal(
    BuildContext context,
    String title, {
    VoidCallback? open,
  }) => context
      .dependOnInheritedWidgetOfExactType<_RevealScope>()
      ?.request
      .reveal(context, title, open);

  @override
  State<NodeLaneRevealScope> createState() => _NodeLaneRevealScopeState();
}

class _NodeLaneRevealScopeState extends State<NodeLaneRevealScope> {
  late final _request = _RevealRequest(widget.path);

  @override
  Widget build(BuildContext context) =>
      _RevealScope(request: _request, child: widget.child);
}

class _RevealScope extends InheritedWidget {
  const _RevealScope({required this.request, required super.child});
  final _RevealRequest request;

  @override
  bool updateShouldNotify(_RevealScope oldWidget) =>
      request != oldWidget.request;
}

class _RevealRequest {
  _RevealRequest(this.path);
  final List<String> path;
  bool _claimed = false;
  bool _scheduled = false;
  final _candidates = <int, (BuildContext, VoidCallback?)>{};

  void reveal(BuildContext context, String title, VoidCallback? open) {
    final index = path.indexOf(title);
    if (_claimed || index < 0) return;
    _candidates[index] = (context, open);
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _claimed = true;
      final available =
          _candidates.entries.where((entry) => entry.value.$1.mounted).toList()
            ..sort((a, b) => b.key.compareTo(a.key));
      _candidates.clear();
      if (available.isEmpty) return;
      final target = available.first;
      final (targetContext, action) = target.value;
      if (ModalRoute.of(targetContext)?.isCurrent != true) return;
      await Scrollable.ensureVisible(targetContext, alignment: .15);
      if (targetContext.mounted &&
          ModalRoute.of(targetContext)?.isCurrent == true &&
          target.key == path.length - 1) {
        action?.call();
      }
    });
  }
}
