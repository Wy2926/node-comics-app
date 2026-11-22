import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_progress.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

Future<int?> showLocalFileImport(
  BuildContext anchor,
  ItemType type, {
  Manga? book,
}) {
  final store = ProviderScope.containerOf(anchor, listen: false);
  return MobileBookshelfImportPanel(
    itemType: type,
    onImport: (split) => store.refresh(
      importArchivesFromFileProvider(
        book,
        itemType: type,
        init: book == null,
        splitChapters: split,
      ).future,
    ),
  ).show(anchor);
}

class MobileBookshelfImportPanel extends StatefulWidget {
  const MobileBookshelfImportPanel({
    super.key,
    required this.onImport,
    this.itemType = ItemType.manga,
  });
  final ItemType itemType;
  final Future<int> Function(bool splitChapters) onImport;
  @override
  State<MobileBookshelfImportPanel> createState() =>
      _MobileBookshelfImportPanelState();
  Future<int?> show(BuildContext anchor) => showNodeLaneBubble<int>(
    anchor,
    label: anchor.l10n.import_local_file,
    width: NodeLaneTokens.bubbleToolWidth,
    child: this,
  );
}

class _MobileBookshelfImportPanelState
    extends State<MobileBookshelfImportPanel> {
  bool _busy = false, _failed = false, _leaving = false, _splitChapters = true;
  Future<void> _choose() async {
    if (_busy ||
        _failed ||
        _leaving ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    setState(() => _busy = true);
    try {
      final count = await widget.onImport(_splitChapters);
      if (!mounted) return;
      if (count > 0) {
        _leaving = true;
        Navigator.pop(context, count);
      } else {
        setState(() => _busy = false);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _failed = true;
        });
      }
    }
  }

  void _close() {
    if (_busy || _leaving || ModalRoute.of(context)?.isCurrent != true) return;
    _leaving = true;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n, t = NodeLaneTokens.of(context);
    return NodeLaneBubblePanel(
      title: l10n.import_local_file,
      onDismiss: _close,
      dismissEnabled: !_busy,
      child: ListView(
        shrinkWrap: true,
        padding: NodeLaneTokens.bubbleContentPadding,
        children: [
          if (_failed)
            Semantics(
              liveRegion: true,
              child: Text(
                l10n.bookshelf_import_incomplete,
                style: t.readerSecondary.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            )
          else ...[
            if (widget.itemType == ItemType.novel)
              NodeLaneSwitchRow(
                title: l10n.split_epub_chapters,
                value: _splitChapters,
                onChanged: _busy
                    ? null
                    : (v) => setState(() => _splitChapters = v),
              ),
            NodeLaneRow.card(
              title: l10n.bookshelf_choose_files,
              subtitle: localArchiveExtensions(widget.itemType)
                  .join(' · ')
                  .toUpperCase(),
              enabled: !_busy,
              icon: NodeLaneIcons.of(context).folderOutline,
              onTap: _busy ? null : _choose,
            ),
            if (_busy)
              Padding(
                padding: EdgeInsets.only(top: NodeLaneTokens.space16),
                child: NodeLaneProgress(
                  semanticsLabel: l10n.translation_processing,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
