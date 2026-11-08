import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// UIKit owns drawing, materials, accessibility and selection animation.
class IosNativeTabBar extends StatefulWidget {
  const IosNativeTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.accent,
    required this.dark,
    required this.onSelected,
  });
  final List<Map<String, Object?>> items;
  final int selectedIndex;
  final Color accent;
  final bool dark;
  final ValueChanged<int> onSelected;
  @override
  State<IosNativeTabBar> createState() => _IosNativeTabBarState();
}

class _IosNativeTabBarState extends State<IosNativeTabBar> {
  MethodChannel? _channel;
  Map<String, Object?> get _configuration => {
    'items': widget.items,
    'selected': widget.selectedIndex,
    'accent': widget.accent.toARGB32(),
    'dark': widget.dark,
  };
  String _sent = '';
  void _update() {
    final configuration = _configuration;
    final signature = jsonEncode(configuration);
    if (_channel != null && signature != _sent) {
      _sent = signature;
      _channel!.invokeMethod<void>('update', configuration);
    }
  }

  @override
  void didUpdateWidget(IosNativeTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _update();
  }

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => UiKitView(
    viewType: 'nodelane/native_tab_bar',
    creationParams: _configuration,
    creationParamsCodec: const StandardMessageCodec(),
    onPlatformViewCreated: (id) {
      if (!mounted) return;
      _channel = MethodChannel('nodelane/native_tab_bar/$id');
      _channel!.setMethodCallHandler((call) async {
        if (!mounted || call.method != 'select' || call.arguments is! int) {
          return;
        }
        final index = call.arguments as int;
        if (index >= 0 && index < widget.items.length) widget.onSelected(index);
      });
      _update();
    },
  );
}
