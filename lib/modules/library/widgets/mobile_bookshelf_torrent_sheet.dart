import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Collects either an address or a file choice; importing stays with the caller.
class MobileBookshelfTorrentSheet extends StatefulWidget {
  const MobileBookshelfTorrentSheet({super.key, required this.onAdd});
  final Future<void> Function(String? url) onAdd;

  @override
  State<MobileBookshelfTorrentSheet> createState() =>
      _MobileBookshelfTorrentSheetState();
}

class _MobileBookshelfTorrentSheetState
    extends State<MobileBookshelfTorrentSheet> {
  final _url = TextEditingController();
  bool _busy = false, _failed = false, _leaving = false;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _add({bool file = false}) async {
    if (_busy || _failed || _leaving || (!file && _url.text.trim().isEmpty)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _busy = true);
    try {
      await widget.onAdd(file ? null : _url.text.trim());
      if (!mounted) return;
      _leaving = true;
      Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _failed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: NodeLaneCatalogSheet(
        title: l10n.add_torrent,
        canClose: !_busy,
        heightFactor: .9,
        fitContent: true,
        bottom: _failed
            ? null
            : NodeLaneModalActions(
                actions: [
                  NodeLaneDialogAction(
                    label: l10n.add,
                    busy: _busy,
                    onPressed: _url.text.trim().isEmpty ? null : _add,
                  ),
                ],
              ),
        child: ListView(
          shrinkWrap: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(NodeLaneTokens.gutter),
          children: [
            if (_failed)
              NodeLaneNotice(
                message: l10n.bookshelf_import_incomplete,
                kind: NodeLaneNoticeKind.error,
                contained: false,
              )
            else ...[
              NodeLaneTextField(
                controller: _url,
                label: l10n.torrent_url,
                hint: l10n.enter_torrent_hint_text,
                enabled: !_busy,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.go,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _add(),
              ),
              const SizedBox(height: NodeLaneTokens.space24),
              NodeLaneRow.card(
                title: l10n.bookshelf_choose_files,
                enabled: !_busy,
                subtitle: '.torrent',
                icon: NodeLaneIcons.of(context).folderOutline,
                onTap: _busy ? null : () => _add(file: true),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
