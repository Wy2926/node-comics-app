import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_settings_labels.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Selects one change and returns to reading, as the original quick menu did.
/// The reader still owns layout, effective page mode, and position conversion.
class MobileReaderDisplayButton extends ConsumerStatefulWidget {
  const MobileReaderDisplayButton({
    super.key,
    required this.bookTitle,
    required this.currentReaderModeProvider,
    required this.readPageMode,
    required this.onReaderModeChanged,
    this.onPageModeToggle,
  });
  final String bookTitle;
  final ProviderListenable<ReaderMode?> currentReaderModeProvider;
  final PageMode Function() readPageMode;
  final void Function(ReaderMode, WidgetRef) onReaderModeChanged;
  final VoidCallback? onPageModeToggle;

  @override
  ConsumerState<MobileReaderDisplayButton> createState() =>
      _MobileReaderDisplayButtonState();
}

class _MobileReaderDisplayButtonState
    extends ConsumerState<MobileReaderDisplayButton> {
  bool _open = false;

  Future<void> _show() async {
    if (_open || !mounted || ModalRoute.of(context)?.isCurrent != true) return;
    setState(() => _open = true);
    try {
      final choice = await showNodeLaneCatalogSheet<Object>(
        context,
        _ReaderDisplaySheet(
          bookTitle: widget.bookTitle,
          currentReaderModeProvider: widget.currentReaderModeProvider,
          readPageMode: () => widget.readPageMode(),
          canChangePageMode: widget.onPageModeToggle != null,
        ),
      );
      if (!mounted || choice == null) return;
      final mode = ref.read(widget.currentReaderModeProvider);
      if (choice is ReaderMode) {
        if (mode != choice) widget.onReaderModeChanged(choice, ref);
      } else if (choice is bool) {
        if (ref.read(cropBordersStateProvider) != choice) {
          ref.read(cropBordersStateProvider.notifier).set(choice);
        }
      } else if (choice is PageMode &&
          mode != null &&
          !mode.isHorizontalContinuous &&
          widget.readPageMode() != choice) {
        widget.onPageModeToggle?.call();
      }
    } finally {
      if (mounted) setState(() => _open = false);
    }
  }

  @override
  Widget build(BuildContext context) => NodeLaneToolbarAction(
    label: context.l10n.display,
    icon: NodeLaneIcons.of(context).manga,
    onPressed: _show,
  );
}

class _ReaderDisplaySheet extends ConsumerStatefulWidget {
  const _ReaderDisplaySheet({
    required this.bookTitle,
    required this.currentReaderModeProvider,
    required this.readPageMode,
    required this.canChangePageMode,
  });
  final String bookTitle;
  final ProviderListenable<ReaderMode?> currentReaderModeProvider;
  final PageMode Function() readPageMode;
  final bool canChangePageMode;

  @override
  ConsumerState<_ReaderDisplaySheet> createState() =>
      _ReaderDisplaySheetState();
}

class _ReaderDisplaySheetState extends ConsumerState<_ReaderDisplaySheet> {
  bool _leaving = false;
  void _close([Object? choice]) {
    if (_leaving || !mounted || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _leaving = true;
    Navigator.pop(context, choice);
  }

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    final mode = ref.watch(widget.currentReaderModeProvider);
    final crop = ref.watch(cropBordersStateProvider);
    final automatic = ref.watch(doublePageAutoStateProvider);
    // Re-read the reader's effective page layout when the viewport changes.
    MediaQuery.sizeOf(context);
    final pageMode = mode?.isHorizontalContinuous == true
        ? PageMode.onePage
        : widget.readPageMode();
    final canChangePages =
        widget.canChangePageMode &&
        mode != null &&
        !mode.isHorizontalContinuous;
    return NodeLaneCatalogSheet(
      title: l10n.display,
      subtitle: l10n.reader_display_scope,
      fitContent: true,
      heightFactor: NodeLaneTokens.readerDisplayFraction,
      onClose: () => _close(),
      child: SingleChildScrollView(
        padding: NodeLaneTokens.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.bookTitle.isNotEmpty) ...[
              Text(widget.bookTitle, style: colors.readerLabel),
              const SizedBox(height: NodeLaneTokens.space12),
            ],
            Semantics(
              container: true,
              label: l10n.reading_mode,
              child: NodeLaneGroupSurface(
                children: [
                  for (final option in ReaderMode.values)
                    Semantics(
                      inMutuallyExclusiveGroup: true,
                      child: NodeLaneGroupSurface(
                        selected: mode == option,
                        child: NodeLaneRow(
                          key: ValueKey(option),
                          title: getReaderModeName(option, context),
                          icon: getReaderModeIcon(option, context),
                          selected: mode == option,
                          onTap: mode == option ? null : () => _close(option),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: NodeLaneTokens.space16),
            NodeLaneSegments<PageMode>(
              segments: [
                ButtonSegment(
                  value: PageMode.onePage,
                  label: Text(l10n.single_page),
                ),
                ButtonSegment(
                  value: PageMode.doublePage,
                  label: Text(l10n.double_page),
                ),
              ],
              value: pageMode,
              onChanged: canChangePages
                  ? (value) {
                      if (value != widget.readPageMode()) _close(value);
                    }
                  : null,
            ),
            if (mode?.isHorizontalContinuous == true || automatic) ...[
              const SizedBox(height: NodeLaneTokens.space8),
              Text(
                mode?.isHorizontalContinuous == true
                    ? l10n.reader_display_single_only
                    : l10n.reader_display_manual_pages,
                style: colors.readerSecondary,
              ),
            ],
            const SizedBox(height: NodeLaneTokens.space16),
            NodeLaneGroupSurface(
              child: NodeLaneSwitchRow(
                title: l10n.crop_borders,
                subtitle: l10n.reader_display_crop_scope,
                icon: NodeLaneIcons.of(context).crop,
                value: crop,
                onChanged: (value) => _close(value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
