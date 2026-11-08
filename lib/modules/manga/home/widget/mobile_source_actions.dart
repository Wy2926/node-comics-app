import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/home/providers/saved_searches_provider.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

enum SourceCatalogAction { save, saved, settings, filter }

class MobileSourceActions extends StatefulWidget {
  const MobileSourceActions({
    super.key,
    required this.title,
    required this.display,
    required this.canSave,
    required this.local,
    this.host,
    this.notes,
    this.hasFilters = false,
    this.filtering = false,
  });
  final String title;
  final String? host, notes;
  final DisplayType display;
  final bool canSave, local, hasFilters, filtering;
  @override
  State<MobileSourceActions> createState() => _MobileSourceActionsState();
}

class _MobileSourceActionsState extends State<MobileSourceActions> {
  bool showNotes = false;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final l10n = context.l10n;
    void choose(Object value) => Navigator.pop(context, value);
    return NodeLaneCatalogSheet(
      title: widget.title,
      subtitle: widget.host,
      heightFactor: widget.notes?.trim().isNotEmpty == true ? .70 : .58,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          NodeLaneTokens.gutter,
          0,
          NodeLaneTokens.gutter,
          NodeLaneTokens.space20,
        ),
        children: [
          NodeLaneCatalogHeading(context.l10n.source_display),
          NodeLaneSegments<DisplayType>(
            value: widget.display,
            labelStyle: t.readerLabel,
            segments: [
              ButtonSegment(
                value: DisplayType.comfortableGrid,
                label: Text(context.l10n.source_cover_title),
              ),
              ButtonSegment(
                value: DisplayType.compactGrid,
                label: Text(context.l10n.source_cover_only),
              ),
              ButtonSegment(
                value: DisplayType.list,
                label: Text(context.l10n.list),
              ),
            ],
            onChanged: choose,
          ),
          const SizedBox(height: 20),
          NodeLaneGroupSurface(
            children: [
              if (widget.canSave)
                NodeLaneRow(
                  title: context.l10n.source_save_search,
                  icon: icons.bookmarkOutline,
                  onTap: () => choose(SourceCatalogAction.save),
                ),
              NodeLaneRow(
                title: context.l10n.source_saved_searches,
                icon: icons.manga,
                onTap: () => choose(SourceCatalogAction.saved),
              ),
            ],
          ),
          if (!widget.local) ...[
            const SizedBox(height: 20),
            NodeLaneGroupSurface(
              children: [
                if (widget.hasFilters)
                  NodeLaneRow(
                    title: l10n.filter,
                    icon: icons.filter,
                    value: widget.filtering ? l10n.source_filter_active : null,
                    onTap: () => choose(SourceCatalogAction.filter),
                  ),
                NodeLaneRow(
                  title: context.l10n.sources_settings,
                  icon: icons.settings,
                  onTap: () => choose(SourceCatalogAction.settings),
                ),
              ],
            ),
          ],
          if (widget.notes?.trim().isNotEmpty == true) ...[
            const SizedBox(height: NodeLaneTokens.space20),
            NodeLaneGroupSurface(
              children: [
                NodeLaneRow(
                  title: context.l10n.source_website_info,
                  icon: icons.info,
                  trailing: Icon(
                    showNotes ? icons.down : icons.forward,
                    size: NodeLaneTokens.smallIconSize,
                    color: t.muted,
                  ),
                  onTap: () => setState(() => showNotes = !showNotes),
                ),
                if (showNotes)
                  Padding(
                    padding: NodeLaneTokens.groupPadding,
                    child: SelectableText(
                      widget.notes!,
                      style: t.readerSecondary,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
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
    return NodeLaneCatalogSheet(
      title: context.l10n.source_saved_searches,
      subtitle: context.l10n.source_saved_search_title(widget.title),
      heightFactor: entries.isEmpty ? .38 : .58,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          if (entries.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => managing = !managing),
                child: Text(
                  managing ? context.l10n.action_done : context.l10n.manage,
                ),
              ),
            ),
          for (var i = 0; i < entries.length; i++)
            NodeLaneRow.card(
              title: entries[i].name,
              subtitle: context.l10n.source_search_keyword(entries[i].query),
              leading: Icon(icons.bookmarkOutline),
              first: i == 0,
              last: i == entries.length - 1,
              onTap: managing
                  ? null
                  : () => Navigator.pop(context, entries[i].query),
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
                  subtitle: context.l10n.source_save_search_hint,
                  icon: icons.bookmarkOutline,
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              context.l10n.source_saved_search_scope,
              style: t.readerSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
