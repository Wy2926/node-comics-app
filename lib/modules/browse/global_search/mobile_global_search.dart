import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation only: editing a draft does not submit a source request.
class MobileGlobalSearchPage extends StatelessWidget {
  const MobileGlobalSearchPage({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.onClear,
    required this.scope,
    required this.query,
    required this.results,
    this.onScope,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit, onClear;
  final VoidCallback? onScope;
  final String scope, query;
  final Widget results;

  @override
  Widget build(BuildContext context) {
    return MobileBrowsePage(
      title: '跨来源搜索',
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * .55,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: NodeLaneTextField.search(
                    controller: controller,
                    hint: context.l10n.search,
                    clearLabel: context.l10n.reset,
                    onSubmitted: (_) => onSubmit(),
                    onClear: onClear,
                    autofocus: controller.text.isEmpty,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: NodeLaneGroupSurface(
                children: [
                  NodeLaneRow(
                    title: '搜索范围',
                    value: scope,
                    icon: NodeLaneIcons.of(context).adjustments,
                    onTap: onScope,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ValueKey(query),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [results],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileGlobalSourceSection extends StatelessWidget {
  const MobileGlobalSourceSection({
    super.key,
    required this.title,
    required this.language,
    this.onOpen,
    this.status,
    required this.loading,
    required this.count,
    required this.itemBuilder,
  });

  final String title, language;
  final VoidCallback? onOpen;
  final Widget? status;
  final bool loading;
  final int count;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NodeLaneTokens.gutter,
        0,
        NodeLaneTokens.gutter,
        NodeLaneTokens.space24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onOpen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: t.readerLabel.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (language.isNotEmpty)
                        Text(language, style: t.secondary),
                    ],
                  ),
                ),
              ),
              if (onOpen != null && !loading && count > 0)
                TextButton(
                  onPressed: onOpen,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('查看全部'),
                      Icon(icons.forward, size: NodeLaneTokens.smallIconSize),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: NodeLaneTokens.space12),
          if (loading)
            Row(
              children: [
                SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: t.accent,
                  ),
                ),
                const SizedBox(width: NodeLaneTokens.space12),
                Text('正在搜索…', style: t.readerSecondary),
              ],
            )
          else if (status != null)
            status!
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final width = ((constraints.maxWidth - 12) / 2).clamp(
                  100.0,
                  180.0,
                );
                final height =
                    width * NodeLaneTokens.coverAspectRatio +
                    10 +
                    MediaQuery.textScalerOf(context).scale(15) * 1.3 * 2;
                return SizedBox(
                  height: height,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: count,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: NodeLaneTokens.space12),
                    itemBuilder: (context, i) =>
                        SizedBox(width: width, child: itemBuilder(context, i)),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class GlobalSearchPrompt extends StatelessWidget {
  const GlobalSearchPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(NodeLaneIcons.of(context).search, size: 28, color: t.muted),
          const SizedBox(height: 12),
          Text('输入关键词搜索作品', style: t.readerLabel),
          const SizedBox(height: 8),
          Text('在当前分类的已安装来源中搜索', style: t.readerSecondary),
        ],
      ),
    );
  }
}

class MobileGlobalSearchEmpty extends StatelessWidget {
  const MobileGlobalSearchEmpty({
    super.key,
    required this.message,
    required this.hint,
    required this.actionLabel,
    required this.onAction,
  });
  final String message, hint, actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => NodeLaneGroupSurface(
    margin: const EdgeInsets.fromLTRB(
      NodeLaneTokens.gutter,
      0,
      NodeLaneTokens.gutter,
      NodeLaneTokens.space12,
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            NodeLaneIcons.of(context).extensions,
            size: 36,
            color: NodeLaneTokens.of(context).muted,
          ),
          const SizedBox(height: 16),
          Text(message, style: NodeLaneTokens.of(context).readerLabel),
          const SizedBox(height: 8),
          Text(hint, style: NodeLaneTokens.of(context).readerSecondary),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onAction,
            child: Text(actionLabel, textAlign: TextAlign.center),
          ),
        ],
      ),
    ),
  );
}

class MobileGlobalResultCard extends StatelessWidget {
  const MobileGlobalResultCard({
    super.key,
    required this.title,
    required this.cover,
    required this.inLibrary,
    required this.onOpen,
    this.onQuickAdd,
  });
  final String title;
  final Widget cover;
  final bool inLibrary;
  final VoidCallback onOpen;
  final VoidCallback? onQuickAdd;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
          onTap: onOpen,
          onLongPress: onQuickAdd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    NodeLaneTokens.coverRadius,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ExcludeSemantics(
                        child: ColoredBox(color: colors.soft, child: cover),
                      ),
                      if (inLibrary)
                        PositionedDirectional(
                          top: 8,
                          start: 8,
                          child: NodeLaneCoverBadge(context.l10n.in_library),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ExcludeSemantics(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
