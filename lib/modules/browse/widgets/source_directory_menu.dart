import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

enum DirectoryAction {
  search,
  local,
  request,
  repositories,
  bulk,
  update,
  create,
}

class SourceDirectoryMenu extends ConsumerWidget {
  const SourceDirectoryMenu({
    super.key,
    required this.type,
    required this.onOpened,
    required this.onSelected,
  });
  final ItemType type;
  final VoidCallback onOpened;
  final ValueChanged<DirectoryAction> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    PopupMenuItem<DirectoryAction> item(
      DirectoryAction action,
      String label,
      IconData icon,
    ) => nodeLaneSelectionMenuItem(
      context,
      value: action,
      label: label,
      icon: icon,
    );
    return NodeLaneMenuButton<DirectoryAction>.label(
      label: l.manage,
      tooltip: l.manage,
      onOpened: onOpened,
      onSelected: onSelected,
      itemBuilder: (_) => [
        item(DirectoryAction.search, l.search_titles, icons.search),
        item(DirectoryAction.local, l.local_source, icons.folderOutline),
        const PopupMenuDivider(),
        item(DirectoryAction.request, l.feedback_source, icons.add),
        item(
          DirectoryAction.repositories,
          l.source_manage_repositories,
          icons.repository,
        ),
        if (ref.read(mobileDirectorySourcesProvider((type, true))).isNotEmpty)
          item(DirectoryAction.bulk, l.source_bulk_manage, icons.selected),
        item(DirectoryAction.update, l.source_update_installed, icons.refresh),
        if (ref.read(developerModeStateProvider))
          item(DirectoryAction.create, l.create_extension, icons.code),
      ],
    );
  }
}
