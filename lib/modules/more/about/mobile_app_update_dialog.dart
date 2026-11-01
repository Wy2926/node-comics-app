import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Release data and transfer state stay with the existing update owner.
class MobileAppUpdateDialog extends StatelessWidget {
  const MobileAppUpdateDialog({
    super.key,
    required this.currentVersion,
    required this.targetVersion,
    required this.notes,
    required this.downloadOnDevice,
    required this.busy,
    required this.installing,
    required this.received,
    required this.total,
    required this.hasError,
    required this.onContinue,
    required this.onCancel,
  });

  final String currentVersion, targetVersion, notes;
  final bool downloadOnDevice, busy, installing, hasError;
  final int received, total;
  final VoidCallback onContinue, onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final progress = total > 0 ? (received / total).clamp(0.0, 1.0) : null;
    return NodeLaneDialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: NodeLaneTokens.dialogMaxWidth,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: SingleChildScrollView(
                key: const PageStorageKey('mobile-app-update'),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.new_update_available,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (currentVersion.isNotEmpty) ...[
                      Text(
                        '${l10n.installed_version} · $currentVersion',
                        style: TextStyle(color: colors.muted),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text('${l10n.latest_version} · $targetVersion'),
                    if (busy) ...[
                      const SizedBox(height: 20),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          installing
                              ? l10n.preparing_installation
                              : downloadOnDevice
                              ? l10n.downloading_update
                              : l10n.open_in_browser,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: installing ? null : progress,
                      ),
                      if (downloadOnDevice && !installing) ...[
                        const SizedBox(height: 8),
                        if (progress != null)
                          Text('${(progress * 100).toStringAsFixed(0)}%'),
                        Text(
                          total > 0
                              ? '${(received / 1048576).toStringAsFixed(1)} / ${(total / 1048576).toStringAsFixed(1)} MB'
                              : '${(received / 1048576).toStringAsFixed(1)} MB',
                        ),
                      ],
                    ],
                    if (hasError) ...[
                      const SizedBox(height: 16),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          l10n.failed,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      l10n.release_notes,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      key: const PageStorageKey('mobile-app-update-notes'),
                      notes.isEmpty ? l10n.no_release_notes : notes,
                      style: TextStyle(color: colors.muted, height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: colors.line),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!busy) ...[
                    FilledButton.icon(
                      onPressed: onContinue,
                      icon: Icon(
                        downloadOnDevice
                            ? Icons.download_rounded
                            : Icons.open_in_browser_rounded,
                      ),
                      label: Text(
                        downloadOnDevice ? l10n.download : l10n.open_in_browser,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  TextButton(onPressed: onCancel, child: Text(l10n.cancel)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
