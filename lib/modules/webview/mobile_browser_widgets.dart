import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'browser_url.dart';

/// Address and tab controls carry only display data and callbacks. They never
/// own WebViews, translation consumers, or navigation history.
class MobileBrowserHeader extends StatelessWidget {
  const MobileBrowserHeader({
    super.key,
    required this.title,
    required this.url,
    required this.onAddress,
    required this.onClose,
    required this.menu,
  });
  final String title, url;
  final VoidCallback onAddress, onClose;
  final Widget menu;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final host = Uri.tryParse(url)?.host ?? '';
    return Material(
      color: colors.surface,
      child: SafeArea(
        bottom: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .28,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(4, 6, 4, 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: '返回应用',
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                ),
                Expanded(
                  child: Material(
                    color: colors.soft,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: onAddress,
                      child: Semantics(
                        button: true,
                        label: '编辑网址',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title.isEmpty ? '网页浏览' : title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: colors.ink,
                                ),
                              ),
                              Text(
                                host.isEmpty ? '输入网址' : host,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                menu,
              ],
            ),
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
  });
  final int tabCount;
  final bool translating;
  final VoidCallback onTabs, onTranslate;
  final VoidCallback? onBack, onForward;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .28,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _action(context, '后退', const Icon(Icons.chevron_left), onBack),
                _action(
                  context,
                  '前进',
                  const Icon(Icons.chevron_right),
                  onForward,
                ),
                _action(
                  context,
                  '翻译',
                  Icon(
                    Icons.translate_rounded,
                    color: translating ? colors.accent : null,
                  ),
                  onTranslate,
                ),
                _action(
                  context,
                  '标签',
                  Badge.count(
                    count: tabCount,
                    child: const Icon(Icons.tab_outlined),
                  ),
                  onTabs,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _action(
    BuildContext context,
    String label,
    Widget icon,
    VoidCallback? callback,
  ) => Expanded(
    child: TextButton(
      style: TextButton.styleFrom(
        foregroundColor: NodeLaneTokens.of(context).ink,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        minimumSize: const Size(48, 56),
      ),
      onPressed: callback,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

class MobileBrowserTabCard extends StatelessWidget {
  const MobileBrowserTabCard({
    super.key,
    required this.title,
    required this.url,
    required this.selected,
    required this.onSelect,
    required this.onClose,
  });
  final String title, url;
  final bool selected;
  final VoidCallback onSelect, onClose;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Material(
      color: selected ? colors.accentSoft : colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: selected ? colors.accent : colors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        selected: selected,
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text(
          title.isEmpty ? '网页' : title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          Uri.tryParse(url)?.host ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, color: colors.muted),
        ),
        onTap: onSelect,
        trailing: IconButton(
          tooltip: '关闭标签页',
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded),
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
    final value = input.text.trim();
    if (!isBrowserUrl(value)) {
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
