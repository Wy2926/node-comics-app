import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/pre_import_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'mobile_library_action.dart';
import 'mobile_library_snapshots.dart';

class RollbackLastChangeTile extends ConsumerWidget {
  const RollbackLastChangeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshots = ref.watch(lastLibrarySnapshotProvider).asData?.value;
    final l10n = context.l10n;
    if (isMobile && !isTv) {
      return MobileLibraryAction(
        title: l10n.library_snapshot_history,
        subtitle: snapshots == null
            ? l10n.roll_back_last_change
            : snapshots.isEmpty
            ? l10n.library_snapshot_empty
            : l10n.roll_back_available_count(snapshots.length),
        icon: Icons.settings_backup_restore_rounded,
        onOpen: () => Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (_) => MobileLibrarySnapshots(
              onRollback: (pageContext, snapshot) => offerLibraryRollback(
                pageContext,
                ref,
                snapshot.backupPath,
                snapshot: snapshot,
              ),
            ),
          ),
        ),
      );
    }
    if (snapshots == null || snapshots.isEmpty) return const SizedBox.shrink();

    if (snapshots.length == 1) {
      final snapshot = snapshots.first;
      return ListTile(
        leading: const Icon(
          Icons.settings_backup_restore_rounded,
          color: Colors.red,
        ),
        title: Text(
          l10n.roll_back_last_change,
          style: const TextStyle(color: Colors.red),
        ),
        subtitle: Text(
          l10n.roll_back_last_change_subtitle(
            DateTime.fromMillisecondsSinceEpoch(snapshot.createdAt).toString(),
            snapshot.description,
          ),
          style: TextStyle(fontSize: 11, color: context.secondaryColor),
        ),
        onTap: () => offerLibraryRollback(context, ref, snapshot.backupPath),
      );
    }

    return ExpansionTile(
      leading: const Icon(
        Icons.settings_backup_restore_rounded,
        color: Colors.red,
      ),
      title: Text(
        l10n.roll_back_last_change,
        style: const TextStyle(color: Colors.red),
      ),
      subtitle: Text(
        l10n.roll_back_available_count(snapshots.length),
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      children: [
        for (final snapshot in snapshots)
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(32, 0, 16, 0),
            title: Text(
              snapshot.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              DateTime.fromMillisecondsSinceEpoch(snapshot.createdAt)
                  .toString(),
              style: TextStyle(fontSize: 11, color: context.secondaryColor),
            ),
            onTap: () =>
                offerLibraryRollback(context, ref, snapshot.backupPath),
          ),
      ],
    );
  }
}

Future<void> offerLibraryRollback(
  BuildContext context,
  WidgetRef ref,
  String safetyBackupPath, {
  LibrarySafetySnapshot? snapshot,
}) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        scrollable: isMobile && !isTv,
        title: Text(l10n.roll_back),
        content: Text(
          snapshot == null
              ? l10n.roll_back_confirm_message
              : '${snapshot.description}\n${librarySnapshotTime(context, snapshot)}'
                    '\n\n${l10n.library_snapshot_restore_message}',
        ),
        actions: dialogCancelConfirmActions(
          dialogContext: dialogContext,
          confirmLabel: l10n.roll_back,
          confirmColor: Colors.red,
        ),
      );
    },
  );
  if (confirmed != true || !context.mounted) return;

  bool? syncAfterRestore;
  final syncPreference = ref.read(synchingProvider(syncId: 1));
  final hasServer =
      (syncPreference.authToken?.isNotEmpty ?? false) &&
      (syncPreference.server?.isNotEmpty ?? false);
  if (hasServer) {
    syncAfterRestore = await confirmSyncAfterRestore(
      context,
      syncOn: syncPreference.syncOn,
    );
    if (!context.mounted) return;
  }

  showBusyDialog(context, l10n.restoring_backup);
  try {
    await ref.watch(
      doRestoreProvider(
        path: safetyBackupPath,
        context: context,
        merge: false,
        syncAfterRestore: syncAfterRestore,
      ).future,
    );
  } catch (e, s) {
    // Keep the snapshot: the roll back did not happen, so it is still the
    // way back.
    toastError(e, stack: s, source: 'rollback');
    return;
  } finally {
    if (context.mounted) hideBusyDialog(context);
  }
  await clearLastLibrarySnapshot();
  if (!context.mounted) return;
  ref.invalidate(lastLibrarySnapshotProvider);
  showNodeLaneNotice(l10n.roll_back_done, kind: NodeLaneNoticeKind.success);
}
