import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

enum _FolderAction { add, remove }

/// What became of the folder that was just added.
class OnboardingFolderStatus extends StatefulWidget {
  const OnboardingFolderStatus({
    super.key,
    required this.message,
    this.path,
    this.titles = const [],
    this.busy = false,
    this.warn = false,
    this.mobile = false,
    this.onAddFolder,
    this.onRemoveFolder,
    this.actionsEnabled = true,
  });

  final String message;

  /// Where the folder is, so the user can tell which one they picked before
  /// deciding whether to take it back.
  final String? path;

  /// What it turned out to hold. A count says the scan worked; the names say
  /// it found the right things.
  final List<String> titles;

  final bool busy;
  final bool warn;
  final bool mobile;
  final VoidCallback? onAddFolder, onRemoveFolder;
  final bool actionsEnabled;

  @override
  State<OnboardingFolderStatus> createState() => _FolderStatusState();
}

class _FolderStatusState extends State<OnboardingFolderStatus> {
  /// Whether the full list of widget.titles is showing.
  ///
  /// Three names answer "did the scan work". They do not always answer "is
  /// this the right folder", which is the question worth answering here while
  /// Remove is still one tap away.
  bool _expanded = false;

  /// Enough to recognise a folder by, and a stop before a first run screen
  /// turns into a library listing.
  static const _expandedLimit = 40;

  /// The tail of a widget.path.
  ///
  /// On iOS the front of one of these is a hundred characters of container
  /// UUID, so truncating the end would leave only the part that identifies
  /// nothing.
  static String _tail(String path) {
    final parts = p.split(path).where((part) => part != '/').toList();
    if (parts.length <= 3) return path;
    return '…/${parts.sublist(parts.length - 3).join('/')}';
  }

  /// The titles, collapsed to a few names or opened to the lot.
  ///
  /// Tapping toggles it. The count is the affordance: it is drawn in the
  /// accent colour so it reads as something to press, which is as much
  /// decoration as a first run screen should spend on this.
  Widget _titleList(TextStyle? muted) {
    final scheme = Theme.of(context).colorScheme;
    final collapsedCount = widget.titles.length <= 4 ? widget.titles.length : 3;
    final shown = _expanded
        ? widget.titles.take(_expandedLimit).toList()
        : widget.titles.take(collapsedCount).toList();
    final hidden = widget.titles.length - shown.length;

    return GestureDetector(
      onTap: hidden > 0 || _expanded
          ? () => setState(() => _expanded = !_expanded)
          : null,
      behavior: HitTestBehavior.opaque,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: shown.join(' · ')),
            if (hidden > 0)
              TextSpan(
                text: '  +$hidden',
                style: muted?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              )
            else if (_expanded)
              TextSpan(
                text: '  ${'−'}',
                style: muted?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        textAlign: TextAlign.center,
        // Opened, it grows inside the step's scroll view rather than
        // clipping. Closed, it stays two lines so the buttons keep their
        // place.
        maxLines: _expanded ? null : 2,
        overflow: _expanded ? TextOverflow.clip : TextOverflow.ellipsis,
        style: muted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mobile) {
      final t = NodeLaneTokens.of(context), l = context.l10n;
      final icons = NodeLaneIcons.of(context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            liveRegion: true,
            child: NodeLaneRow(
              title: widget.path == null
                  ? l.local_folder
                  : p.basename(widget.path!),
              subtitle: widget.message,
              icon: icons.folderOutline,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.busy)
                    const SizedBox.square(
                      dimension: NodeLaneTokens.smallIconSize,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(
                      widget.warn ? icons.error : icons.check,
                      size: NodeLaneTokens.iconSize,
                      color: widget.warn
                          ? Theme.of(context).colorScheme.error
                          : t.accent,
                    ),
                  if (widget.onAddFolder != null ||
                      widget.onRemoveFolder != null) ...[
                    const SizedBox(width: NodeLaneTokens.space8),
                    NodeLaneMenuButton<_FolderAction>(
                      icon: icons.more,
                      tooltip: l.more,
                      enabled: widget.actionsEnabled && !widget.busy,
                      onSelected: (action) => switch (action) {
                        _FolderAction.add => widget.onAddFolder?.call(),
                        _FolderAction.remove => widget.onRemoveFolder?.call(),
                      },
                      itemBuilder: (_) => [
                        if (widget.onAddFolder != null)
                          PopupMenuItem(
                            value: _FolderAction.add,
                            height: NodeLaneTokens.menuItemHeight,
                            child: Text(l.onboarding_local_folder),
                          ),
                        if (widget.onRemoveFolder != null)
                          PopupMenuItem(
                            value: _FolderAction.remove,
                            height: NodeLaneTokens.menuItemHeight,
                            child: Text(
                              l.onboarding_local_remove,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (widget.titles.isNotEmpty || widget.path != null) ...[
            const NodeLaneGroupDivider(),
            NodeLaneDisclosure(
              key: ValueKey((
                'onboarding-folder-titles',
                widget.path,
                widget.message,
              )),
              compact: true,
              title: widget.path != null && widget.titles.isNotEmpty
                  ? l.onboarding_view_imports
                  : l.onboarding_view_folders,
              child: Padding(
                padding: NodeLaneTokens.groupPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.path != null) ...[
                      Text(widget.path!, style: t.readerSecondary),
                      const SizedBox(height: NodeLaneTokens.space8),
                    ],
                    for (final title in widget.titles.take(_expandedLimit))
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: NodeLaneTokens.space8,
                        ),
                        child: Text(title, style: t.readerSecondary),
                      ),
                    if (widget.titles.length > _expandedLimit)
                      Text(
                        '+${widget.titles.length - _expandedLimit}',
                        style: t.readerSecondary,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    }
    final theme = Theme.of(context);
    final color = widget.warn ? theme.colorScheme.error : theme.hintColor;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.busy)
              SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            else
              Icon(
                widget.warn ? Icons.info_outline : Icons.check_circle_outline,
                size: 18,
                color: color,
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.message,
                style: theme.textTheme.bodySmall?.copyWith(color: color),
              ),
            ),
          ],
        ),
        if (widget.path != null) ...[
          const SizedBox(height: 6),
          Text(
            _tail(widget.path!),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: muted?.copyWith(fontSize: 11),
          ),
        ],
        if (widget.titles.isNotEmpty) ...[
          const SizedBox(height: 4),
          _titleList(muted),
        ],
      ],
    );
  }
}
