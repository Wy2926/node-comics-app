import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/browse/widgets/source_tool_menu.dart';
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
  final Future<void> Function(BuildContext, DirectoryAction) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    return TextButton.icon(
      label: Text(l.manage),
      icon: Icon(icons.down),
      iconAlignment: IconAlignment.end,
      onPressed: () {
        onOpened();
        showSourceToolMenu<DirectoryAction>(
          context,
          title: l.manage,
          onSelected: onSelected,
          items: () => [
            (DirectoryAction.search, l.search_titles, icons.search),
            (DirectoryAction.local, l.local_source, icons.folderOutline),
            (DirectoryAction.request, l.feedback_source, icons.add),
            (
              DirectoryAction.repositories,
              l.source_manage_repositories,
              icons.repository,
            ),
            if (ref
                .read(mobileDirectorySourcesProvider((type, true)))
                .isNotEmpty)
              (DirectoryAction.bulk, l.source_bulk_manage, icons.selected),
            (DirectoryAction.update, l.source_update_installed, icons.refresh),
            if (ref.read(developerModeStateProvider))
              (DirectoryAction.create, l.create_extension, icons.code),
          ],
        );
      },
    );
  }
}
