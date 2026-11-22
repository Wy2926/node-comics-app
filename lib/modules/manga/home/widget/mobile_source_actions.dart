import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/home/providers/saved_searches_provider.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/browse/widgets/source_tool_menu.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

enum SourceCatalogAction { save, saved, settings, info, filter }

class MobileSourceMenu extends StatelessWidget {
  const MobileSourceMenu({
    super.key,
    required this.canSave,
    required this.local,
    required this.hasFilters,
    required this.filtering,
    required this.onSelected,
  });
  final bool canSave, local;
  final bool Function() filtering;
  // Some plugins execute code to describe their filters. Ask only on opening.
  final bool Function() hasFilters;
  final Future<void> Function(BuildContext, SourceCatalogAction) onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    return NodeLaneIconButton(
      icon: icons.more,
      tooltip: l.source_actions,
      onPressed: () {
        final available = hasFilters();
        showSourceToolMenu<SourceCatalogAction>(
          context,
          title: l.source_actions,
          onSelected: onSelected,
          items: () => [
            if (available)
              (
                SourceCatalogAction.filter,
                filtering()
                    ? '${l.filter} · ${l.source_filter_active}'
                    : l.filter,
                icons.adjustments,
              ),
            if (canSave)
              (
                SourceCatalogAction.save,
                l.source_save_search,
                icons.bookmarkOutline,
              ),
            (
              SourceCatalogAction.saved,
              l.source_saved_searches,
              icons.bookmark,
            ),
            if (!local) ...[
              (SourceCatalogAction.info, l.source_website_info, icons.info),
              (
                SourceCatalogAction.settings,
                l.sources_settings,
                icons.settings,
              ),
            ],
          ],
        );
      },
    );
  }
}

class MobileSavedSearches extends ConsumerStatefulWidget {
  const MobileSavedSearches({
    super.key,
    required this.sourceId,
    required this.title,
  });
  final int sourceId;
  final String title;
  @override
  ConsumerState<MobileSavedSearches> createState() =>
      _MobileSavedSearchesState();
}

class _MobileSavedSearchesState extends ConsumerState<MobileSavedSearches> {
  bool managing = false;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final entries =
        ref.watch(savedSearchesProvider)[widget.sourceId] ??
        const <SavedSearch>[];
    return MobileBrowsePage.form(
      title: context.l10n.source_saved_searches,
      actions: [
        if (entries.isNotEmpty)
          TextButton(
            onPressed: () => setState(() => managing = !managing),
            child: Text(
              managing ? context.l10n.action_done : context.l10n.manage,
            ),
          ),
      ],
      body: ListView(
        padding: NodeLaneTokens.pagePadding,
        children: [
          Text(widget.title, style: t.secondary),
          const SizedBox(height: NodeLaneTokens.space12),
          for (var i = 0; i < entries.length; i++)
            NodeLaneRow.card(
              title: entries[i].name,
              subtitle: context.l10n.source_search_keyword(entries[i].query),
              leading: Icon(icons.bookmarkOutline),
              first: i == 0,
              last: i == entries.length - 1,
              onTap: managing
                  ? null
                  : () {
                      if (ModalRoute.isCurrentOf(context) == true) {
                        Navigator.pop(context, entries[i].query);
                      }
                    },
              trailing: managing
                  ? NodeLaneIconButton(
                      tooltip: context.l10n.remove,
                      icon: icons.delete,
                      style: NodeLaneIconButtonStyle.plain,
                      destructive: true,
                      onPressed: () => ref
                          .read(savedSearchesProvider.notifier)
                          .remove(widget.sourceId, entries[i].name),
                    )
                  : null,
            ),
          if (entries.isEmpty)
            NodeLaneGroupSurface(
              children: [
                NodeLaneRow(
                  title: context.l10n.source_no_saved_searches,
                  icon: icons.bookmarkOutline,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
