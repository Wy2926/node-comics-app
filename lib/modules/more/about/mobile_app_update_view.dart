import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_brand_mark.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// One update presentation, embedded in About or hosted by the startup dialog.
/// Fetching, downloading and opening the release stay with the existing owner.
class MobileAppUpdateView extends StatelessWidget {
  const MobileAppUpdateView({
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
    this.embedded = false,
    this.openedInBrowser = false,
  });
  final String currentVersion, targetVersion, notes;
  final bool downloadOnDevice,
      busy,
      installing,
      hasError,
      embedded,
      openedInBrowser;
  final int received, total;
  final VoidCallback onContinue, onCancel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final progress = total > 0 ? (received / total).clamp(0.0, 1.0) : null;
    final version = Text(
      '${l.installed_version} $currentVersion',
      textAlign: embedded ? TextAlign.start : TextAlign.center,
      style: t.readerSecondary,
    );
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: NodeLaneTokens.groupPadding,
          child: embedded
              ? Row(
                  children: [
                    const NodeLaneBrandMark(
                      size: NodeLaneTokens.brandCompactMarkSize,
                    ),
                    const SizedBox(width: NodeLaneTokens.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${l.app_name} $targetVersion', style: t.title),
                          if (currentVersion.isNotEmpty) ...[
                            const SizedBox(height: NodeLaneTokens.space4),
                            version,
                          ],
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const NodeLaneBrandMark(size: NodeLaneTokens.avatarSize),
                    const SizedBox(height: NodeLaneTokens.space16),
                    Semantics(
                      header: true,
                      child: Text(
                        l.new_update_available,
                        textAlign: TextAlign.center,
                        style: t.readerTitle,
                      ),
                    ),
                    const SizedBox(height: NodeLaneTokens.space8),
                    Text(
                      l.app_name,
                      textAlign: TextAlign.center,
                      style: t.readerLabel,
                    ),
                    const SizedBox(height: NodeLaneTokens.space4),
                    Text(targetVersion, style: t.readerTitle),
                    if (currentVersion.isNotEmpty) ...[
                      const SizedBox(height: NodeLaneTokens.space4),
                      version,
                    ],
                  ],
                ),
        ),
        const NodeLaneGroupDivider(),
        NodeLaneDisclosure(
          key: ValueKey(('app-update-notes', targetVersion)),
          title: l.release_notes,
          compact: true,
          child: Padding(
            padding: NodeLaneTokens.groupPadding,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: SelectableText(
                notes.isEmpty ? l.no_release_notes : notes,
                style: t.readerSecondary.copyWith(height: 1.45),
              ),
            ),
          ),
        ),
        if (busy || hasError || openedInBrowser)
          Padding(
            padding: NodeLaneTokens.groupPadding,
            child: Semantics(
              liveRegion: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    hasError
                        ? l.failed
                        : busy
                        ? installing
                              ? l.preparing_installation
                              : downloadOnDevice
                              ? l.downloading_update
                              : l.open_in_browser
                        : l.app_update_opened,
                    style: t.readerSecondary.copyWith(
                      color: hasError
                          ? Theme.of(context).colorScheme.error
                          : t.muted,
                    ),
                  ),
                  if (busy) ...[
                    const SizedBox(height: NodeLaneTokens.space8),
                    LinearProgressIndicator(
                      value: installing || !downloadOnDevice ? null : progress,
                    ),
                    if (downloadOnDevice && !installing) ...[
                      const SizedBox(height: NodeLaneTokens.space8),
                      if (progress != null)
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: t.readerSecondary,
                        ),
                      Text(
                        total > 0
                            ? '${(received / 1048576).toStringAsFixed(1)} / ${(total / 1048576).toStringAsFixed(1)} MB'
                            : '${(received / 1048576).toStringAsFixed(1)} MB',
                        style: t.readerSecondary,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
      ],
    );
    final actions = Padding(
      padding: NodeLaneTokens.groupPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!busy)
            FilledButton(
              onPressed: onContinue,
              child: Text(downloadOnDevice ? l.download : l.app_update_view),
            ),
          if (!embedded || busy) ...[
            const SizedBox(height: NodeLaneTokens.space8),
            TextButton(
              onPressed: onCancel,
              child: Text(busy ? l.cancel : l.app_update_later),
            ),
          ],
          if (!downloadOnDevice && !busy) ...[
            const SizedBox(height: NodeLaneTokens.space8),
            Text(
              l.app_update_external_hint,
              textAlign: TextAlign.center,
              style: t.readerSecondary,
            ),
          ],
        ],
      ),
    );
    if (embedded) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [content, actions],
      );
    }
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
                child: content,
              ),
            ),
            actions,
          ],
        ),
      ),
    );
  }
}
