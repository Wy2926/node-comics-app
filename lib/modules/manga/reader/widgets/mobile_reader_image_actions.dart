import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

enum _ImageAction { save, share, cover }

/// Presents one original page. Loading and platform work stay in callbacks;
/// opening this menu does not decode another full-size image or start translation.
class MobileReaderImageActions extends StatefulWidget {
  const MobileReaderImageActions({
    super.key,
    required this.bookTitle,
    required this.chapterTitle,
    required this.pageNumber,
    required this.loadImage,
    required this.onSave,
    required this.onShare,
    required this.onSetCover,
    this.translationActions,
  });
  final String bookTitle, chapterTitle;
  final Widget? translationActions;
  final int? pageNumber;
  final Future<Uint8List?> Function() loadImage;
  final Future<void> Function(Uint8List) onSave, onSetCover;
  final Future<void> Function(BuildContext, Uint8List) onShare;

  @override
  State<MobileReaderImageActions> createState() =>
      _MobileReaderImageActionsState();
}

class _MobileReaderImageActionsState extends State<MobileReaderImageActions> {
  Uint8List? _bytes;
  bool _loading = false, _loadFailed = false, _actionFailed = false;
  bool _saved = false, _confirmCover = false, _leaving = false;
  _ImageAction? _working;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_loading || _bytes != null || _leaving || !mounted) return;
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    try {
      final bytes = await widget.loadImage();
      if (mounted && !_leaving) {
        setState(() {
          _bytes = bytes?.isNotEmpty == true ? bytes : null;
          _loadFailed = _bytes == null;
        });
      }
    } catch (_) {
      if (mounted && !_leaving) setState(() => _loadFailed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _close() {
    if (_leaving ||
        _working != null ||
        !mounted ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _leaving = true;
    Navigator.pop(context);
  }

  Future<void> _run(_ImageAction action) async {
    final bytes = _bytes;
    if (bytes == null ||
        _working != null ||
        _leaving ||
        _actionFailed ||
        !mounted ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    if (action == _ImageAction.save && _saved) return;
    if (action == _ImageAction.cover &&
        (!_confirmCover || bytes.lengthInBytes >= maxMangaCoverImageBytes)) {
      return;
    }
    setState(() => _working = action);
    var close = false;
    try {
      switch (action) {
        case _ImageAction.save:
          await widget.onSave(bytes);
          if (mounted) setState(() => _saved = true);
        case _ImageAction.share:
          await widget.onShare(context, bytes);
        case _ImageAction.cover:
          await widget.onSetCover(bytes);
          close = true;
      }
    } catch (_) {
      if (mounted) setState(() => _actionFailed = true);
    } finally {
      if (mounted) setState(() => _working = null);
    }
    if (close && mounted) _close();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final busy = _working != null;
    final available = !busy && !_actionFailed;
    final canCover =
        _bytes != null && _bytes!.lengthInBytes < maxMangaCoverImageBytes;
    final saveHint = Theme.of(context).platform == TargetPlatform.iOS
        ? l10n.reader_image_save_ios
        : l10n.reader_image_save_android;
    return PopScope(
      canPop: !busy,
      child: NodeLaneReaderSurface(
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: math.min(
                  MediaQuery.sizeOf(context).height * .8,
                  constraints.maxHeight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NodeLaneReaderHeading(
                    title: _confirmCover
                        ? l10n.set_as_cover
                        : l10n.reader_image_actions,
                    closeLabel: l10n.close,
                    onClose: busy ? null : _close,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.bookTitle,
                            style: colors.readerLabel.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            [
                              widget.chapterTitle,
                              if (widget.pageNumber != null)
                                l10n.page('${widget.pageNumber}'),
                            ].join(' · '),
                            style: colors.readerSecondary,
                          ),
                          const SizedBox(height: 12),
                          if (!_confirmCover &&
                              widget.translationActions != null) ...[
                            widget.translationActions!,
                            const SizedBox(height: NodeLaneTokens.space12),
                          ],
                          Text(
                            l10n.reader_image_original,
                            style: colors.readerSecondary,
                          ),
                          const SizedBox(height: 12),
                          if (_loading)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (_loadFailed) ...[
                            Text(l10n.image_loading_error),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: _load,
                                icon: Icon(NodeLaneIcons.of(context).refresh),
                                label: Text(l10n.retry),
                              ),
                            ),
                          ] else if (_confirmCover)
                            Text(l10n.use_this_as_cover_art)
                          else
                            NodeLaneGroupSurface(
                              child: Column(
                                children: [
                                  _action(
                                    context,
                                    action: _ImageAction.save,
                                    title: _saved
                                        ? l10n.picture_saved
                                        : l10n.save,
                                    subtitle: saveHint,
                                    icon: _saved
                                        ? NodeLaneIcons.of(context).downloaded
                                        : NodeLaneIcons.of(context).saveImage,
                                    onTap: available && !_saved
                                        ? () => _run(_ImageAction.save)
                                        : null,
                                  ),
                                  Divider(
                                    height: 1,
                                    indent: 56,
                                    color: colors.line,
                                  ),
                                  _action(
                                    context,
                                    action: _ImageAction.share,
                                    title: l10n.share,
                                    subtitle: l10n.reader_image_share,
                                    icon: NodeLaneIcons.of(context).share,
                                    onTap: available
                                        ? () => _run(_ImageAction.share)
                                        : null,
                                  ),
                                  Divider(
                                    height: 1,
                                    indent: 56,
                                    color: colors.line,
                                  ),
                                  _action(
                                    context,
                                    action: _ImageAction.cover,
                                    title: l10n.set_as_cover,
                                    subtitle: canCover
                                        ? l10n.reader_image_cover
                                        : l10n.reader_image_cover_limit,
                                    icon: NodeLaneIcons.of(context).image,
                                    onTap: available && canCover
                                        ? () {
                                            if (_working == null &&
                                                !_leaving &&
                                                !_actionFailed &&
                                                mounted &&
                                                ModalRoute.of(context)
                                                        ?.isCurrent ==
                                                    true) {
                                              setState(
                                                () => _confirmCover = true,
                                              );
                                            }
                                          }
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          if (_actionFailed)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                l10n.reader_image_action_failed,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (_confirmCover)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: busy
                                  ? null
                                  : () => setState(() => _confirmCover = false),
                              child: Text(l10n.cancel),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: available
                                  ? () => _run(_ImageAction.cover)
                                  : null,
                              child: busy
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(l10n.set_as_cover),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _action(
    BuildContext context, {
    required _ImageAction action,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback? onTap,
  }) => ListTile(
    minTileHeight: NodeLaneTokens.readerImageActionHeight,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    leading: _working == action
        ? const SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(icon, size: 24, color: NodeLaneTokens.of(context).accent),
    title: Text(title, style: NodeLaneTokens.of(context).readerLabel),
    trailing: action == _ImageAction.cover
        ? Icon(
            NodeLaneIcons.of(context).forward,
            size: 16,
            color: NodeLaneTokens.of(context).muted,
          )
        : null,
    subtitle: Text(subtitle, style: NodeLaneTokens.of(context).readerSecondary),
    onTap: onTap,
  );
}
