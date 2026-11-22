import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/about/software_update_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_progress.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation only; release checks, transfers and installation stay with owners.
class SoftwareUpdateView extends StatelessWidget {
  const SoftwareUpdateView({
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
    this.openedInBrowser = false,
    this.readyToInstall = false,
    this.waiting = false,
    this.permissionRequired = false,
    this.onCancelDownload,
    this.downloadLabel,
    this.onRecheck,
    this.checkFailed = false,
  });
  final String currentVersion, targetVersion, notes;
  final String? downloadLabel;
  final VoidCallback? onRecheck;
  final bool checkFailed;
  final bool downloadOnDevice,
      busy,
      installing,
      hasError,
      openedInBrowser,
      readyToInstall,
      waiting,
      permissionRequired;
  final int received, total;
  final VoidCallback onContinue;
  final VoidCallback? onCancelDownload;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final progress = total > 0 ? (received / total).clamp(0.0, 1.0) : null;
    final hasStatus = busy || hasError || readyToInstall || permissionRequired;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppUpdateHeader(
          version: targetVersion,
          currentVersion: currentVersion,
          available: true,
        ),
        const SizedBox(height: NodeLaneTokens.space24),
        NodeLaneGroupSurface(
          child: Padding(
            padding: const EdgeInsets.all(NodeLaneTokens.space20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(l.release_notes, style: t.detailSectionTitle),
                ),
                const SizedBox(height: NodeLaneTokens.space12),
                SelectableText(
                  notes.isEmpty ? l.no_release_notes : notes,
                  style: t.detailMetadata.copyWith(color: t.ink),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    final status = permissionRequired
        ? l.app_update_allow_install
        : checkFailed
        ? l.app_update_failed
        : hasError
        ? l.failed
        : busy
        ? installing
              ? l.preparing_installation
              : downloadOnDevice
              ? waiting
                    ? l.app_update_waiting
                    : l.downloading_update
              : l.open_in_browser
        : readyToInstall
        ? l.downloaded
        : l.app_update_opened;
    final footer = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (busy ||
            hasError ||
            openedInBrowser ||
            readyToInstall ||
            permissionRequired)
          Padding(
            padding: const EdgeInsets.only(bottom: NodeLaneTokens.space16),
            child: Semantics(
              liveRegion: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    status,
                    style: t.readerSecondary.copyWith(
                      color: hasError
                          ? Theme.of(context).colorScheme.error
                          : t.ink,
                    ),
                  ),
                  if (busy) ...[
                    const SizedBox(height: NodeLaneTokens.space12),
                    NodeLaneProgress(
                      value: installing || !downloadOnDevice ? null : progress,
                      semanticsLabel: status,
                    ),
                    if (downloadOnDevice && !installing) ...[
                      const SizedBox(height: NodeLaneTokens.space8),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: NodeLaneTokens.space12,
                        runSpacing: NodeLaneTokens.space4,
                        children: [
                          if (progress != null)
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}%',
                              style: t.label,
                            ),
                          Text(
                            total > 0
                                ? '${(received / 1048576).toStringAsFixed(1)} / ${(total / 1048576).toStringAsFixed(1)} MB'
                                : '${(received / 1048576).toStringAsFixed(1)} MB',
                            style: t.secondary,
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        if (!busy || hasError)
          FilledButton(
            onPressed: onContinue,
            child: Text(
              downloadOnDevice
                  ? readyToInstall
                        ? l.install
                        : downloadLabel ??
                              (hasError ? l.retry : l.app_update_download)
                  : l.open_in_browser,
              textAlign: TextAlign.center,
            ),
          ),
        if (onRecheck != null)
          TextButton(onPressed: onRecheck, child: Text(l.check_for_update)),
        if (onCancelDownload != null) ...[
          const SizedBox(height: NodeLaneTokens.space8),
          TextButton(
            onPressed: onCancelDownload,
            child: Text(
              readyToInstall
                  ? l.app_update_remove_package
                  : l.app_update_cancel_download,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
    return NodeLaneModalScope(
      child: AppUpdatePageLayout(
        content: content,
        footer: hasStatus
            ? NodeLaneGroupSurface(
                child: Padding(
                  padding: NodeLaneTokens.groupPadding,
                  child: footer,
                ),
              )
            : footer,
      ),
    );
  }
}
