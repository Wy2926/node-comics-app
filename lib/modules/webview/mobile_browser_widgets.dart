import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'browser_url.dart';

ButtonStyle _barIconStyle(Color color, {Color? background}) =>
    IconButton.styleFrom(
      fixedSize: const Size.square(NodeLaneTokens.minTapTarget),
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
      iconSize: NodeLaneTokens.iconSize,
      foregroundColor: color,
      backgroundColor: background,
    );

/// Pure presentation. WebViews, translation and persistence stay in the host.
class MobileBrowserHeader extends StatelessWidget {
  const MobileBrowserHeader({
    super.key,
    required this.url,
    required this.onSubmitted,
    required this.addressFocus,
    required this.onClose,
    required this.menu,
    this.onReload,
  });
  final String url;
  final ValueChanged<String> onSubmitted;
  final FocusNode addressFocus;
  final VoidCallback onClose;
  final VoidCallback? onReload;
  final Widget menu;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return Material(
      color: t.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NodeLaneTokens.space4,
            vertical:
                (NodeLaneTokens.browserToolbarHeight -
                    NodeLaneTokens.browserAddressHeight) /
                2,
          ),
          child: ListenableBuilder(
            listenable: addressFocus,
            builder: (context, _) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!addressFocus.hasFocus) ...[
                  TextButton(
                    onPressed: onClose,
                    style: TextButton.styleFrom(
                      foregroundColor: t.accent,
                      fixedSize: const Size(
                        NodeLaneTokens.browserBackWidth,
                        NodeLaneTokens.minTapTarget,
                      ),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.standard,
                    ),
                    child: Row(
                      children: [
                        Icon(icons.back, size: NodeLaneTokens.smallIconSize),
                        const SizedBox(width: NodeLaneTokens.space4),
                        Text(
                          '返回',
                          style: t.readerLabel.copyWith(color: t.accent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: NodeLaneTokens.space8),
                ],
                Expanded(
                  key: const ValueKey('address'),
                  child: MobileBrowserAddressField(
                    url: url,
                    compact: true,
                    focusNode: addressFocus,
                    onSubmitted: onSubmitted,
                    onReload: onReload,
                  ),
                ),
                if (!addressFocus.hasFocus) ...[
                  const SizedBox(width: NodeLaneTokens.space8),
                  SizedBox.square(
                    dimension: NodeLaneTokens.minTapTarget,
                    child: IconButtonTheme(
                      data: IconButtonThemeData(style: _barIconStyle(t.accent)),
                      child: menu,
                    ),
                  ),
                ],
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
    required this.onNew,
    required this.onTranslate,
    this.onBack,
    this.showTranslation = true,
    this.onDisplayChanged,
    this.onControls,
  });
  final int tabCount;
  final bool translating, showTranslation;
  final VoidCallback onTabs, onNew;
  final VoidCallback? onTranslate, onBack, onControls;
  final ValueChanged<bool>? onDisplayChanged;
  @override
  Widget build(BuildContext context) =>
      NodeLaneNoticeAvoidance(child: _buildToolbar(context));

  Widget _buildToolbar(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(
              horizontal: NodeLaneTokens.space16,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 328;
                return Row(
                  children: [
                    IconButton(
                      tooltip: '后退',
                      onPressed: onBack,
                      style: _barIconStyle(t.ink),
                      icon: Icon(icons.back),
                    ),
                    SizedBox(
                      width: narrow
                          ? NodeLaneTokens.space8
                          : NodeLaneTokens.space24,
                    ),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: translating || onDisplayChanged != null
                                ? NodeLaneTokens.browserDisplayWidth
                                : NodeLaneTokens.browserTranslationWidth,
                          ),
                          child: onTranslate == null
                              ? const SizedBox.shrink()
                              : translating || onDisplayChanged != null
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: NodeLaneSegments<bool>(
                                        value: showTranslation,
                                        pill: true,
                                        labelStyle: t.readerLabel,
                                        segments: const [
                                          ButtonSegment(
                                            value: false,
                                            label: Text('原图'),
                                          ),
                                          ButtonSegment(
                                            value: true,
                                            label: Text('译图'),
                                          ),
                                        ],
                                        onChanged: onDisplayChanged ?? (_) {},
                                      ),
                                    ),
                                    if (onControls != null)
                                      IconButton(
                                        tooltip: '网页翻译',
                                        onPressed: onControls,
                                        style: _barIconStyle(t.ink),
                                        icon: Icon(
                                          icons.down,
                                          size: NodeLaneTokens.smallIconSize,
                                        ),
                                      ),
                                  ],
                                )
                              : Material(
                                  color: t.accent,
                                  borderRadius: BorderRadius.circular(
                                    NodeLaneTokens.capsuleRadius,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: onTranslate,
                                          style: TextButton.styleFrom(
                                            minimumSize: const Size(
                                              NodeLaneTokens.minTapTarget,
                                              NodeLaneTokens.minTapTarget,
                                            ),
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            visualDensity:
                                                VisualDensity.standard,
                                            foregroundColor: t.onAccent,
                                          ),
                                          child: Text(
                                            '翻译',
                                            style: t.readerLabel.copyWith(
                                              color: t.onAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (onControls != null) ...[
                                        SizedBox(
                                          height: NodeLaneTokens.space16,
                                          child: VerticalDivider(
                                            width: 1,
                                            color: t.onAccent.withValues(
                                              alpha: .4,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: '网页翻译',
                                          onPressed: onControls,
                                          style: _barIconStyle(t.onAccent),
                                          icon: Icon(
                                            icons.down,
                                            size: NodeLaneTokens.smallIconSize,
                                            color: t.onAccent,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: '新建标签页',
                      onPressed: onNew,
                      style: _barIconStyle(t.ink),
                      icon: Icon(icons.add, size: NodeLaneTokens.iconSize),
                    ),
                    SizedBox(
                      width: narrow
                          ? NodeLaneTokens.space8
                          : NodeLaneTokens.space20,
                    ),
                    MobileBrowserTabsButton(count: tabCount, onPressed: onTabs),
                  ],
                );
              },
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
    return NodeLaneGroupSurface(
      selected: selected,
      outlined: true,
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
                          child: Icon(
                            icons.web,
                            size: NodeLaneTokens.websiteIconSize,
                            color: t.muted,
                          ),
                        ),
                      ),
                    )
                  else
                    ColoredBox(
                      color: t.soft,
                      child: Center(
                        child: Icon(
                          url.isEmpty ? icons.browserStart : icons.web,
                          size: NodeLaneTokens.websiteIconSize,
                          color: t.muted,
                        ),
                      ),
                    ),
                  if (selected)
                    Positioned(
                      top: NodeLaneTokens.space8,
                      left: NodeLaneTokens.space8,
                      child: const NodeLaneCoverBadge(
                        '当前',
                        tone: NodeLaneBadgeTone.accent,
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
              padding: const EdgeInsets.all(NodeLaneTokens.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    url.isEmpty ? '新标签页' : (title.isEmpty ? '网页' : title),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.readerLabel,
                  ),
                  const SizedBox(height: NodeLaneTokens.space4),
                  Text(
                    url.isEmpty ? '尚未打开网页' : Uri.tryParse(url)?.host ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.secondary,
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

/// Inline draft state only. A URL is handed to the host only after validation.
class MobileBrowserAddressField extends StatefulWidget {
  const MobileBrowserAddressField({
    super.key,
    required this.onSubmitted,
    this.url = '',
    this.compact = false,
    this.focusNode,
    this.onReload,
  });
  final String url;
  final bool compact;
  final FocusNode? focusNode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback? onReload;

  @override
  State<MobileBrowserAddressField> createState() =>
      _MobileBrowserAddressFieldState();
}

class _MobileBrowserAddressFieldState extends State<MobileBrowserAddressField> {
  late final focus = widget.focusNode ?? FocusNode();
  late final input = TextEditingController(text: _displayUrl);
  bool invalid = false;
  String get _displayUrl =>
      widget.compact ? Uri.tryParse(widget.url)?.host ?? '' : widget.url;

  @override
  void initState() {
    super.initState();
    focus.addListener(_focusChanged);
  }

  void _focusChanged() {
    if (widget.compact) {
      input.text = focus.hasFocus ? widget.url : _displayUrl;
      if (focus.hasFocus) {
        input.selection = TextSelection(
          baseOffset: 0,
          extentOffset: input.text.length,
        );
      }
    }
    setState(() => invalid = false);
  }

  @override
  void didUpdateWidget(MobileBrowserAddressField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url && !focus.hasFocus) {
      input.text = _displayUrl;
    }
  }

  void _submit() {
    final url = normalizeBrowserAddress(input.text);
    if (url == null) {
      setState(() => invalid = true);
      return;
    }
    focus.unfocus();
    widget.onSubmitted(url);
  }

  @override
  void dispose() {
    focus.removeListener(_focusChanged);
    if (widget.focusNode == null) focus.dispose();
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: input,
            builder: (context, _, _) => NodeLaneTextField(
              controller: input,
              focusNode: focus,
              compact: widget.compact,
              hint: '输入或粘贴网址',
              textAlign: widget.compact && !focus.hasFocus
                  ? TextAlign.center
                  : TextAlign.start,
              leading: widget.compact && widget.url.startsWith('https:')
                  ? icons.lock
                  : icons.web,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              autocorrect: false,
              enableSuggestions: false,
              onSubmitted: (_) => _submit(),
              onEditingComplete: () {},
              onTapOutside: (_) => focus.unfocus(),
              onChanged: (_) {
                if (invalid) setState(() => invalid = false);
              },
              errorText: invalid ? '请输入有效的网址' : null,
              trailing: NodeLaneIconButton(
                tooltip: widget.compact
                    ? (focus.hasFocus ? '清空网址' : '刷新')
                    : (input.text.isEmpty ? '粘贴网址' : '打开网址'),
                style: NodeLaneIconButtonStyle.plain,
                icon: widget.compact
                    ? (focus.hasFocus ? icons.clear : icons.refresh)
                    : (input.text.isEmpty ? icons.clipboard : icons.forward),
                onPressed: widget.compact
                    ? (focus.hasFocus ? input.clear : widget.onReload)
                    : () async {
                        if (input.text.isNotEmpty) {
                          _submit();
                          return;
                        }
                        final data = await Clipboard.getData(
                          Clipboard.kTextPlain,
                        );
                        if (!mounted || data?.text == null) return;
                        input.text = data!.text!.trim();
                        focus.requestFocus();
                      },
              ),
            ),
          ),
        ),
        if (widget.compact && focus.hasFocus) ...[
          const SizedBox(width: NodeLaneTokens.space8),
          TextButton(
            onPressed: focus.unfocus,
            style: TextButton.styleFrom(
              fixedSize: const Size(
                NodeLaneTokens.browserBackWidth,
                NodeLaneTokens.minTapTarget,
              ),
              padding: EdgeInsets.zero,
              foregroundColor: t.accent,
              textStyle: t.readerLabel,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.standard,
            ),
            child: const Text('取消'),
          ),
        ],
      ],
    );
  }
}

class MobileBrowserTabsButton extends StatelessWidget {
  const MobileBrowserTabsButton({
    super.key,
    required this.count,
    this.onPressed,
    this.tonal = false,
  });
  final int count;
  final VoidCallback? onPressed;
  final bool tonal;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    return NodeLaneIconButton(
      tooltip: '标签页 · $count',
      onPressed: onPressed,
      style: tonal
          ? NodeLaneIconButtonStyle.glass
          : NodeLaneIconButtonStyle.plain,
      iconWidget: SizedBox(
        width: NodeLaneTokens.iconSize,
        height: NodeLaneTokens.iconSize,
        child: Stack(
          children: [
            for (final front in [false, true])
              Positioned(
                left: front ? NodeLaneTokens.space4 : 0,
                top: front ? NodeLaneTokens.space4 : 0,
                width: NodeLaneTokens.smallIconSize,
                height: NodeLaneTokens.smallIconSize,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: t.surface,
                    borderRadius: BorderRadius.circular(
                      NodeLaneTokens.controlRadius / 2,
                    ),
                    border: Border.all(color: t.ink, width: 1.5),
                  ),
                  child: front
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$count',
                            maxLines: 1,
                            style: t.caption.copyWith(
                              color: t.ink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MobileBrowserLoadError extends StatelessWidget {
  const MobileBrowserLoadError({
    super.key,
    required this.onRetry,
    required this.onEditAddress,
  });
  final VoidCallback onRetry, onEditAddress;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    return Material(
      color: t.canvas,
      child: NodeLaneEmptyState(
        icon: NodeLaneIcons.of(context).web,
        title: '网页暂时无法打开',
        message: '检查网络，或确认网址是否正确。',
        scrollable: true,
        action: Wrap(
          alignment: WrapAlignment.center,
          spacing: NodeLaneTokens.space8,
          runSpacing: NodeLaneTokens.space8,
          children: [
            NodeLaneSecondaryButton(
              onPressed: onRetry,
              icon: NodeLaneIcons.of(context).refresh,
              child: const Text('重试'),
            ),
            TextButton(onPressed: onEditAddress, child: const Text('编辑网址')),
          ],
        ),
      ),
    );
  }
}

Future<bool> confirmClearBrowserLogins(BuildContext context) =>
    showNodeLaneConfirmation(
      context,
      title: '清除所有网站登录状态？',
      message: '所有标签页中的网站可能需要重新登录。',
      confirmLabel: '清除登录状态',
      destructive: true,
    );
