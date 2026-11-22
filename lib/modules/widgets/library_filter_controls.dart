import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Shared shelf and chapter presentation. The caller owns each filter's state.
class LibraryFilterGroup extends StatelessWidget {
  const LibraryFilterGroup(this.filters, {super.key});
  final List<(String, int, ValueChanged<int>)> filters;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = [
      (0, l.bookshelf_filter_any),
      (1, l.bookshelf_filter_include),
      (2, l.bookshelf_filter_exclude),
    ];
    return NodeLaneGroupSurface(
      outlined: true,
      children: [
        for (final (title, value, change) in filters)
          NodeLaneOptionSwitch<int>(
            title: title,
            value: value,
            options: options,
            onChanged: change,
          ),
      ],
    );
  }
}

class LibrarySettingsTabs extends StatelessWidget {
  const LibrarySettingsTabs(this.labels, {super.key});
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    return ColoredBox(
      color: t.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: NodeLaneTokens.space12),
        child: LayoutBuilder(
          builder: (_, box) => TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: EdgeInsets.zero,
            labelColor: t.accent,
            labelStyle: t.label,
            unselectedLabelColor: t.muted,
            indicatorColor: t.accent,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: t.line,
            tabs: [
              for (final label in labels)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: box.maxWidth / labels.length,
                    minHeight: NodeLaneTokens.minTapTarget,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NodeLaneTokens.space12,
                      vertical: NodeLaneTokens.space8,
                    ),
                    child: Center(child: Text(label)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
