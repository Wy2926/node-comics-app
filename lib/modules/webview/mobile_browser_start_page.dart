import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'mobile_browser_widgets.dart';

/// The browser landing page and a blank tab share one presentation.
/// Opening, tab lifecycle and source preferences belong to their callers.
class MobileBrowserStartPage extends StatefulWidget {
  const MobileBrowserStartPage({
    super.key,
    required this.sources,
    required this.tabCount,
    required this.onOpen,
    this.onNew,
    this.onTabs,
    this.onClose,
    this.bottomInset = 0,
  });
  final List<Source> sources;
  final int tabCount;
  final void Function(String url, String title) onOpen;
  final VoidCallback? onNew, onTabs, onClose;
  final double bottomInset;

  @override
  State<MobileBrowserStartPage> createState() => _MobileBrowserStartPageState();
}

class _MobileBrowserStartPageState extends State<MobileBrowserStartPage> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final sources = widget.sources.take(expanded ? 8 : 4).toList();
    return SafeArea(
      bottom: false,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(
          NodeLaneTokens.gutter,
          NodeLaneTokens.space12,
          NodeLaneTokens.gutter,
          widget.bottomInset + NodeLaneTokens.space24,
        ),
        children: [
          Row(
            children: [
              if (widget.onClose != null)
                SizedBox.square(
                  dimension: NodeLaneTokens.minTapTarget,
                  child: NodeLaneIconButton(
                    tooltip: '返回',
                    onPressed: widget.onClose,
                    icon: icons.back,
                    style: NodeLaneIconButtonStyle.plain,
                  ),
                ),
              Expanded(
                child: NodeLanePageHeading(
                  title: '浏览器',
                  actions: [
                    SizedBox.square(
                      dimension: NodeLaneTokens.minTapTarget,
                      child: NodeLaneIconButton(
                        tooltip: '新建标签页',
                        icon: icons.add,
                        onPressed: widget.onNew,
                      ),
                    ),
                    const SizedBox(width: NodeLaneTokens.space8),
                    MobileBrowserTabsButton(
                      count: widget.tabCount,
                      onPressed: widget.onTabs,
                      tonal: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: NodeLaneTokens.space20),
          MobileBrowserAddressField(
            onSubmitted: (url) => widget.onOpen(url, ''),
          ),
          if (sources.isNotEmpty) ...[
            NodeLaneCatalogHeading(
              '常用网站',
              action: widget.sources.length > 4
                  ? (expanded ? '收起' : '展开')
                  : null,
              onAction: widget.sources.length > 4
                  ? () => setState(() => expanded = !expanded)
                  : null,
            ),
            LayoutBuilder(
              builder: (context, constraints) => Wrap(
                spacing: NodeLaneTokens.space12,
                runSpacing: NodeLaneTokens.space16,
                children: [
                  for (final source in sources)
                    SizedBox(
                      width:
                          (constraints.maxWidth - 3 * NodeLaneTokens.space12) /
                          4,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            NodeLaneTokens.controlRadius,
                          ),
                          onTap: () =>
                              widget.onOpen(source.baseUrl!, source.name ?? ''),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: NodeLaneTokens.space8,
                            ),
                            child: Column(
                              children: [
                                NodeLaneWebsiteIcon(
                                  url: source.iconUrl,
                                  icon: icons.web,
                                ),
                                const SizedBox(height: NodeLaneTokens.space8),
                                Text(
                                  source.name ??
                                      Uri.parse(source.baseUrl!).host,
                                  style: t.readerSecondary.copyWith(
                                    color: t.ink,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
