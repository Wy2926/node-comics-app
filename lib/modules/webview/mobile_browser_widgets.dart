import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'browser_url.dart';

/// Pure presentation. WebViews, translation and persistence stay in the host.
class MobileBrowserHeader extends StatelessWidget {
  const MobileBrowserHeader({
    super.key,
    required this.title,
    required this.url,
    required this.onAddress,
    required this.onClose,
    required this.menu,
    this.onReload,
  });
  final String title, url;
  final VoidCallback onAddress, onClose;
  final VoidCallback? onReload;
  final Widget menu;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final uri = Uri.tryParse(url);
    return Material(
      color: t.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              TextButton(
                onPressed: onClose,
                style: TextButton.styleFrom(
                  foregroundColor: t.ink,
                  minimumSize: const Size(64, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                child: Row(
                  children: [
                    Icon(icons.back, size: 20),
                    const SizedBox(width: 4),
                    Text('返回', style: t.readerSecondary),
                  ],
                ),
              ),
              Expanded(
                child: Material(
                  color: t.soft,
                  borderRadius: BorderRadius.circular(
                    NodeLaneTokens.controlRadius,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: onAddress,
                          borderRadius: BorderRadius.circular(
                            NodeLaneTokens.controlRadius,
                          ),
                          child: Semantics(
                            button: true,
                            label: '编辑网址',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    uri?.scheme == 'https'
                                        ? icons.lock
                                        : icons.web,
                                    size: 14,
                                    color: t.muted,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      uri?.host.isNotEmpty == true
                                          ? uri!.host
                                          : '输入网址',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.readerSecondary.copyWith(
                                        color: t.ink,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: '刷新',
                        onPressed: onReload,
                        icon: Icon(icons.refresh, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
              menu,
            ],
          ),
        ),
      ),
    );
  }
}

class MobileBrowserToolbar extends StatelessWidget {
  const MobileBrowserToolbar({
    super.key,
    required this.tabCount,
    required this.translating,
    required this.onTabs,
    required this.onTranslate,
    this.onBack,
    this.onForward,
    this.showTranslation = true,
    this.onDisplayChanged,
    this.onControls,
  });
  final int tabCount;
  final bool translating, showTranslation;
  final VoidCallback onTabs, onTranslate;
  final VoidCallback? onBack, onForward, onControls;
  final ValueChanged<bool>? onDisplayChanged;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.line, width: .5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: NodeLaneTokens.browserToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: '后退',
                  onPressed: onBack,
                  icon: Icon(icons.back),
                ),
                IconButton(
                  tooltip: '前进',
                  onPressed: onForward,
                  icon: Icon(icons.forward),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: translating || onDisplayChanged != null
                      ? NodeLaneSegments<bool>(
                          value: showTranslation,
                          pill: true,
                          labelStyle: t.readerSecondary,
                          segments: const [
                            ButtonSegment(value: false, label: Text('原图')),
                            ButtonSegment(value: true, label: Text('译图')),
                          ],
                          onChanged: onDisplayChanged ?? (_) {},
                        )
                      : FilledButton.icon(
                          onPressed: onTranslate,
                          icon: Icon(icons.translate, size: 20),
                          label: const Text('翻译'),
                        ),
                ),
                if (onControls != null)
                  IconButton(
                    tooltip: '网页翻译',
                    onPressed: onControls,
                    icon: Icon(icons.down, size: 18),
                  ),
                Semantics(
                  label: '标签页 · $tabCount',
                  child: TextButton(
                    onPressed: onTabs,
                    style: TextButton.styleFrom(
                      foregroundColor: t.ink,
                      minimumSize: const Size(52, 44),
                      padding: const EdgeInsets.all(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icons.browser, size: 24),
                        const SizedBox(width: 4),
                        Text('$tabCount'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileBrowserTabCard extends StatelessWidget {
  const MobileBrowserTabCard({
    super.key,
    required this.title,
    required this.url,
    required this.selected,
    required this.onSelect,
    required this.onClose,
    this.preview,
  });
  final String title, url;
  final bool selected;
  final VoidCallback onSelect, onClose;
  final Uint8List? preview;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return Material(
      color: t.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NodeLaneTokens.groupRadius),
        side: BorderSide(
          color: selected ? t.accent : t.line,
          width: selected ? 2 : .5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onSelect,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (preview != null)
                    ExcludeSemantics(
                      child: Image.memory(
                        preview!,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        cacheWidth: 360,
                        errorBuilder: (_, _, _) => ColoredBox(
                          color: t.soft,
                          child: Icon(icons.web, size: 36, color: t.muted),
                        ),
                      ),
                    )
                  else
                    ColoredBox(
                      color: t.soft,
                      child: Center(
                        child: Icon(icons.web, size: 36, color: t.muted),
                      ),
                    ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: NodeLaneCloseButton(
                      tooltip: '关闭标签页',
                      backgroundColor: t.surface,
                      onPressed: onClose,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selected)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: t.accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          child: Text(
                            '当前',
                            style: t.caption.copyWith(
                              color: t.onAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Text(
                    title.isEmpty ? '网页' : title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.readerLabel,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Uri.tryParse(url)?.host ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.readerSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> showBrowserAddress(
  BuildContext context, {
  String initialUrl = '',
  bool newTab = false,
}) => showDialog<String>(
  context: context,
  builder: (_) => NodeLaneSurface(
    child: BrowserAddressDialog(initialUrl: initialUrl, newTab: newTab),
  ),
);

class BrowserAddressDialog extends StatefulWidget {
  const BrowserAddressDialog({
    super.key,
    this.initialUrl = '',
    this.newTab = false,
  });
  final String initialUrl;
  final bool newTab;
  @override
  State<BrowserAddressDialog> createState() => _BrowserAddressDialogState();
}

class _BrowserAddressDialogState extends State<BrowserAddressDialog> {
  late final input = TextEditingController(text: widget.initialUrl)
    ..selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.initialUrl.length,
    );
  bool invalid = false;

  void _submit() {
    final value = normalizeBrowserAddress(input.text);
    if (value == null) {
      setState(() => invalid = true);
      return;
    }
    Navigator.pop(context, value);
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NodeLaneAlertDialog(
    scrollable: true,
    title: Text(widget.newTab ? '新标签页' : '打开网址'),
    content: TextField(
      controller: input,
      autofocus: true,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.go,
      autocorrect: false,
      enableSuggestions: false,
      onChanged: (_) {
        if (invalid) setState(() => invalid = false);
      },
      onSubmitted: (_) => _submit(),
      decoration: InputDecoration(
        labelText: '网址',
        hintText: 'https://example.com',
        errorText: invalid ? '请输入有效的 http 或 https 网址' : null,
        errorMaxLines: 3,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('取消'),
      ),
      FilledButton(onPressed: _submit, child: const Text('打开')),
    ],
  );
}

class MobileBrowserLoadError extends StatelessWidget {
  const MobileBrowserLoadError({super.key, required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Material(
    color: NodeLaneTokens.of(context).canvas,
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.public_off_outlined,
              color: NodeLaneTokens.of(context).muted,
              size: 40,
            ),
            const SizedBox(height: 16),
            const Text('网页暂时无法打开', textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('检查网络或修改上方网址后重试。', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(onPressed: onRetry, child: const Text('重新载入')),
          ],
        ),
      ),
    ),
  );
}
