import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/pre_import_backup.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

String librarySnapshotTime(
  BuildContext context,
  LibrarySafetySnapshot snapshot,
) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMd(locale)
      .add_jm()
      .format(DateTime.fromMillisecondsSinceEpoch(snapshot.createdAt));
}

/// The existing rollback flow owns confirmation, sync and data restoration.
/// This page only displays the available snapshots and serializes UI requests.
class MobileLibrarySnapshots extends ConsumerStatefulWidget {
  const MobileLibrarySnapshots({super.key, required this.onRollback});
  final Future<void> Function(BuildContext, LibrarySafetySnapshot) onRollback;

  @override
  ConsumerState<MobileLibrarySnapshots> createState() =>
      _MobileLibrarySnapshotsState();
}

class _MobileLibrarySnapshotsState
    extends ConsumerState<MobileLibrarySnapshots> {
  bool _busy = false;

  Future<void> _rollback(LibrarySafetySnapshot snapshot) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onRollback(context, snapshot);
    } catch (_) {
      if (mounted) {
        showNodeLaneNotice(context.l10n.failed, kind: NodeLaneNoticeKind.error);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final snapshots = ref.watch(lastLibrarySnapshotProvider);
    return NodeLaneSurface(
      child: PopScope(
        canPop: !_busy,
        child: Scaffold(
          appBar: nodeLaneAppBar(
            context,
            title: l10n.library_snapshot_history,
            busy: _busy,
          ),
          body: SafeArea(
            top: false,
            child: AbsorbPointer(
              absorbing: _busy,
              child: snapshots.when(
                skipLoadingOnRefresh: false,
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(l10n.failed),
                    TextButton(
                      onPressed: () =>
                          ref.invalidate(lastLibrarySnapshotProvider),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
                data: (items) => ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    if (items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(l10n.library_snapshot_empty),
                      )
                    else ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 20),
                        child: Text(
                          l10n.roll_back_available_count(items.length),
                          style: TextStyle(
                            color: NodeLaneTokens.of(context).muted,
                          ),
                        ),
                      ),
                      for (final snapshot in items)
                        MobileSettingsGroup(
                          children: [
                            NodeLaneRow(
                              key: ValueKey(snapshot.backupPath),
                              title: snapshot.description,
                              subtitle: librarySnapshotTime(context, snapshot),
                              icon: Icons.settings_backup_restore_rounded,
                              onTap: () => _rollback(snapshot),
                            ),
                          ],
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
