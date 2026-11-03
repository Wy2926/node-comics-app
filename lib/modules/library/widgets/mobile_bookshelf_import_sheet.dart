import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileBookshelfImportSheet extends StatefulWidget {
  const MobileBookshelfImportSheet({
    super.key,
    required this.onImport,
    this.itemType = ItemType.manga,
  });
  final ItemType itemType;
  final Future<int> Function(bool splitChapters) onImport;
  @override
  State<MobileBookshelfImportSheet> createState() =>
      _MobileBookshelfImportSheetState();
}

class _MobileBookshelfImportSheetState
    extends State<MobileBookshelfImportSheet> {
  bool _busy = false, _failed = false, _leaving = false, _splitChapters = true;
  Future<void> _choose() async {
    if (_busy || _failed || _leaving) return;
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
    if (_busy || _leaving) return;
    _leaving = true;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n, t = NodeLaneTokens.of(context);
    final formats = switch (widget.itemType) {
      ItemType.manga => 'ZIP · CBZ',
      ItemType.novel => 'EPUB',
      ItemType.anime => 'MP4 · MOV · AVI · FLV · WMV · MPEG · MKV',
    };
    return PopScope(
      canPop: !_busy,
      child: NodeLaneCatalogSheet(
        title: l10n.import_local_file,
        onClose: _close,
        canClose: !_busy,
        heightFactor: widget.itemType == ItemType.novel ? .74 : .62,
        bottom: NodeLaneSecondaryButton(
          onPressed: _busy ? null : _close,
          child: Text(_failed ? l10n.close : l10n.cancel),
        ),
        child: ListView(
          padding: const EdgeInsets.all(NodeLaneTokens.gutter),
          children: [
            Center(
              child: Container(
                width: NodeLaneTokens.avatarSize,
                height: NodeLaneTokens.avatarSize,
                decoration: BoxDecoration(
                  color: t.accentSoft,
                  borderRadius: BorderRadius.circular(
                    NodeLaneTokens.groupRadius,
                  ),
                ),
                child: Icon(
                  NodeLaneIcons.of(context).folderOutline,
                  size: NodeLaneTokens.choicePreviewHeight,
                  color: t.accent,
                ),
              ),
            ),
            const SizedBox(height: NodeLaneTokens.space16),
            Text(
              l10n.bookshelf_import_formats,
              textAlign: TextAlign.center,
              style: t.readerLabel,
            ),
            const SizedBox(height: NodeLaneTokens.space8),
            Text(
              formats,
              textAlign: TextAlign.center,
              style: t.readerSecondary,
            ),
            const SizedBox(height: NodeLaneTokens.space20),
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
              if (widget.itemType == ItemType.novel) ...[
                NodeLaneGroupSurface(
                  children: [
                    NodeLaneRow(
                      title: l10n.split_epub_chapters,
                      subtitle: l10n.split_epub_chapters_description,
                      trailing: Switch.adaptive(
                        value: _splitChapters,
                        onChanged: _busy
                            ? null
                            : (v) => setState(() => _splitChapters = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: NodeLaneTokens.space16),
              ],
              NodeLaneRow.card(
                title: l10n.bookshelf_choose_files,
                enabled: !_busy,
                icon: NodeLaneIcons.of(context).folderOutline,
                onTap: _busy ? null : _choose,
              ),
              const SizedBox(height: NodeLaneTokens.space12),
              Text(
                _busy
                    ? l10n.bookshelf_import_wait
                    : l10n.bookshelf_import_canceled_hint,
                style: t.readerSecondary,
              ),
              if (_busy)
                const Padding(
                  padding: EdgeInsets.only(top: NodeLaneTokens.space16),
                  child: LinearProgressIndicator(),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
