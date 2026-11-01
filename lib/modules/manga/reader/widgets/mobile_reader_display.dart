import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_widgets.dart';
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
      final choice = await showModalBottomSheet<Object>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        showDragHandle: false,
        shape: NodeLaneTokens.readerSheetShape,
        builder: (_) => _ReaderDisplaySheet(
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
  Widget build(BuildContext context) => MobileReaderAction(
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
    final size = MediaQuery.sizeOf(context);
    final pageMode = mode?.isHorizontalContinuous == true
        ? PageMode.onePage
        : widget.readPageMode();
    final canChangePages =
        widget.canChangePageMode &&
        mode != null &&
        !mode.isHorizontalContinuous;
    return NodeLaneReaderSurface(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * NodeLaneTokens.readerDisplayFraction,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NodeLaneReaderHeading(
                title: l10n.display,
                closeLabel: l10n.close,
                onClose: () => _close(),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                        l10n.reader_display_scope,
                        style: colors.readerSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.reading_mode, style: colors.sectionTitle),
                      const SizedBox(height: 8),
                      NodeLaneGroupSurface(
                        child: Column(
                          children: [
                            for (
                              var i = 0;
                              i < ReaderMode.values.length;
                              i++
                            ) ...[
                              if (i > 0)
                                Divider(
                                  height: 1,
                                  indent: 16,
                                  color: colors.line,
                                ),
                              Semantics(
                                selected: mode == ReaderMode.values[i],
                                child: ListTile(
                                  key: ValueKey(ReaderMode.values[i]),
                                  minTileHeight:
                                      NodeLaneTokens.readerModeRowHeight,
                                  dense: true,
                                  visualDensity: VisualDensity.standard,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  title: Text(
                                    getReaderModeName(
                                      ReaderMode.values[i],
                                      context,
                                    ),
                                    style: colors.readerLabel,
                                  ),
                                  trailing: mode == ReaderMode.values[i]
                                      ? Icon(
                                          NodeLaneIcons.of(context).check,
                                          color: colors.accent,
                                          size: 24,
                                        )
                                      : null,
                                  onTap: mode == ReaderMode.values[i]
                                      ? null
                                      : () => _close(ReaderMode.values[i]),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      NodeLaneSegments<PageMode>(
                        pill: true,
                        labelStyle: colors.readerLabel,
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
                                if (value != widget.readPageMode()) {
                                  _close(value);
                                }
                              }
                            : null,
                      ),
                      if (mode?.isHorizontalContinuous == true ||
                          automatic) ...[
                        const SizedBox(height: 8),
                        Text(
                          mode?.isHorizontalContinuous == true
                              ? l10n.reader_display_single_only
                              : l10n.reader_display_manual_pages,
                          style: colors.readerSecondary,
                        ),
                      ],
                      const SizedBox(height: 16),
                      NodeLaneGroupSurface(
                        child: SwitchListTile.adaptive(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          title: Text(
                            l10n.crop_borders,
                            style: colors.readerLabel,
                          ),
                          subtitle: Text(
                            l10n.reader_display_crop_scope,
                            style: colors.readerSecondary,
                          ),
                          value: crop,
                          onChanged: (value) => _close(value),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
