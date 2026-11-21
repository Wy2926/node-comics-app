import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/browse/mobile_repositories.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/feedback/support_request_page.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_pane_layout.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';
import 'package:mangayomi/services/support_requests.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';

enum SourceManagementAction { search, local, bulk, update, create }

enum _Detail { repositories, request }

/// One management visit owns the form, including while its pane is hidden.
class MobileSourceManagement extends ConsumerStatefulWidget {
  const MobileSourceManagement({
    super.key,
    required this.type,
    required this.types,
    required this.repositories,
    required this.onMediaChanged,
  });
  final ItemType type;
  final List<ItemType> types;
  final bool repositories;
  final ValueChanged<ItemType> onMediaChanged;

  @override
  ConsumerState<MobileSourceManagement> createState() => _ManagementState();
}

class _ManagementState extends ConsumerState<MobileSourceManagement> {
  late var type = widget.type;
  late _Detail? _detail = widget.repositories ? _Detail.repositories : null;
  bool _requestVisited = false;

  void _choose(_Detail detail) {
    FocusScope.of(context).unfocus();
    setState(() {
      _detail = detail;
      if (detail == _Detail.request) _requestVisited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    final canManage = ref
        .watch(mobileDirectorySourcesProvider((type, true)))
        .isNotEmpty;
    final developer = ref.watch(developerModeStateProvider);
    final media = MobileMediaMenu(
      value: type,
      availableTypes: widget.types,
      onChanged: (value) {
        FocusScope.of(context).unfocus();
        setState(() => type = value);
        widget.onMediaChanged(value);
      },
    );
    void finish(SourceManagementAction action) =>
        Navigator.pop(context, action);
    Widget menu(bool split) {
      final active = split ? _detail ?? _Detail.repositories : null;
      return ListView(
        key: const PageStorageKey('catalog-management-menu'),
        padding: NodeLaneTokens.pagePadding,
        children: [
          if (split)
            NodeLanePageHeading(
              title: l.manage,
              actions: [Flexible(child: media)],
            ),
          NodeLaneCatalogHeading(l.browse),
          NodeLaneGroupSurface(
            children: [
              NodeLaneRow(
                title: l.search_titles,
                icon: icons.search,
                onTap: () => finish(SourceManagementAction.search),
              ),
              NodeLaneRow(
                title: l.local_source,
                icon: icons.folderOutline,
                onTap: () => finish(SourceManagementAction.local),
              ),
              NodeLaneRow(
                title: l.feedback_source,
                icon: icons.add,
                accented: active == _Detail.request,
                selected: active == _Detail.request ? true : null,
                onTap: () => _choose(_Detail.request),
              ),
            ],
          ),
          NodeLaneCatalogHeading(l.repository_third_party),
          NodeLaneGroupSurface(
            children: [
              NodeLaneRow(
                title: l.source_manage_repositories,
                icon: icons.repository,
                accented: active == _Detail.repositories,
                selected: active == _Detail.repositories ? true : null,
                onTap: () => _choose(_Detail.repositories),
              ),
              if (canManage)
                NodeLaneRow(
                  title: l.source_bulk_manage,
                  icon: icons.selected,
                  onTap: () => finish(SourceManagementAction.bulk),
                ),
              NodeLaneRow(
                title: l.source_update_installed,
                icon: icons.refresh,
                onTap: () => finish(SourceManagementAction.update),
              ),
              if (developer)
                NodeLaneRow(
                  title: l.create_extension,
                  icon: icons.code,
                  onTap: () => finish(SourceManagementAction.create),
                ),
            ],
          ),
        ],
      );
    }

    return NodeLaneSurface(
      child: SafeArea(
        top: false,
        bottom: false,
        child: NodeLanePaneLayout(
          pane: (_) => Scaffold(body: SafeArea(child: menu(true))),
          body: (_, split) {
            // An automatically shown repository stays open if the window narrows.
            final active = _detail ??= split ? _Detail.repositories : null;
            return PopScope(
              canPop:
                  split ||
                  active == null ||
                  (widget.repositories && active == _Detail.repositories),
              onPopInvokedWithResult: (popped, _) {
                if (!popped) {
                  FocusScope.of(context).unfocus();
                  setState(() => _detail = null);
                }
              },
              child: NodeLaneContentMotion(
                value: active,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Visibility(
                      visible: active == _Detail.repositories,
                      maintainState: true,
                      child: MobileRepositoryManager(
                        key: ValueKey(type),
                        itemType: type,
                      ),
                    ),
                    if (_requestVisited)
                      Visibility(
                        visible: active == _Detail.request,
                        maintainState: true,
                        child: const SupportRequestPage(
                          kind: SupportRequestKind.website,
                        ),
                      ),
                    if (active == null)
                      MobileBrowsePage(
                        title: l.manage,
                        actions: [media],
                        body: menu(false),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
