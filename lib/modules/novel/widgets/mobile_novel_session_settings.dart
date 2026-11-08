import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// The caller retains the per-book controller and auto-scroll notifiers.
class MobileNovelSessionSettings extends ConsumerStatefulWidget {
  const MobileNovelSessionSettings({
    super.key,
    required this.readerMode,
    required this.pageMode,
    required this.autoScroll,
    required this.speed,
    required this.onReaderModeChanged,
    required this.onPageModeChanged,
    required this.onAutoScrollChanged,
    required this.onSpeedPreview,
    required this.onSpeedChanged,
  });
  final ReaderMode readerMode;
  final PageMode pageMode;
  final ValueListenable<bool> autoScroll;
  final ValueListenable<double> speed;
  final ValueChanged<ReaderMode> onReaderModeChanged;
  final ValueChanged<PageMode> onPageModeChanged;
  final ValueChanged<bool> onAutoScrollChanged;
  final ValueChanged<double> onSpeedPreview, onSpeedChanged;

  @override
  ConsumerState<MobileNovelSessionSettings> createState() =>
      _MobileNovelSessionSettingsState();
}

class _MobileNovelSessionSettingsState
    extends ConsumerState<MobileNovelSessionSettings> {
  late ReaderMode _readerMode = widget.readerMode;
  late PageMode _pageMode = widget.pageMode;

  @override
  void didUpdateWidget(covariant MobileNovelSessionSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.readerMode != widget.readerMode) {
      _readerMode = widget.readerMode;
    }
    if (oldWidget.pageMode != widget.pageMode) _pageMode = widget.pageMode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final automatic = ref.watch(doublePageAutoStateProvider);
    final effectivePage = automatic
        ? MediaQuery.orientationOf(context) == Orientation.landscape
              ? PageMode.doublePage
              : PageMode.onePage
        : _pageMode;
    return Column(
      children: [
        MobileSettingsGroup(
          title: l10n.reading_mode,
          children: [
            NodeLaneRow(
              title: l10n.reading_mode,
              icon: NodeLaneIcons.of(context).manga,
              subtitle: _readerMode.isContinuous
                  ? l10n.reading_mode_vertical_continuous
                  : l10n.reading_mode_left_to_right,
              onTap: () async {
                final picked = await showMobileSettingsPicker<ReaderMode>(
                  context,
                  title: l10n.reading_mode,
                  current: _readerMode.isContinuous
                      ? ReaderMode.verticalContinuous
                      : ReaderMode.ltr,
                  options: [
                    MobileSettingOption(
                      ReaderMode.verticalContinuous,
                      l10n.reading_mode_vertical_continuous,
                    ),
                    MobileSettingOption(
                      ReaderMode.ltr,
                      l10n.reading_mode_left_to_right,
                    ),
                  ],
                );
                if (!mounted || picked == null || picked.value == _readerMode) {
                  return;
                }
                widget.onReaderModeChanged(picked.value);
                setState(() => _readerMode = picked.value);
              },
            ),
            if (!_readerMode.isContinuous) ...[
              NodeLaneRow(
                title: l10n.page_mode,
                icon: Icons.view_carousel_outlined,
                subtitle: effectivePage == PageMode.onePage
                    ? l10n.single_page
                    : l10n.double_page,
                onTap: () async {
                  final picked = await showMobileSettingsPicker<PageMode>(
                    context,
                    title: l10n.page_mode,
                    current: effectivePage,
                    options: [
                      MobileSettingOption(PageMode.onePage, l10n.single_page),
                      MobileSettingOption(
                        PageMode.doublePage,
                        l10n.double_page,
                      ),
                    ],
                  );
                  if (!mounted || picked == null) return;
                  // An explicit page choice keeps the original rule: disable
                  // orientation-based auto selection and retain this book's mode.
                  if (ref.read(doublePageAutoStateProvider)) {
                    ref.read(doublePageAutoStateProvider.notifier).set(false);
                  }
                  if (picked.value != _pageMode) {
                    widget.onPageModeChanged(picked.value);
                  }
                  setState(() => _pageMode = picked.value);
                },
              ),
              NodeLaneSwitchRow(
                title: l10n.double_page_auto,
                icon: NodeLaneIcons.of(context).rotate,
                value: automatic,
                onChanged: ref.read(doublePageAutoStateProvider.notifier).set,
              ),
            ],
          ],
        ),
        if (_readerMode.isContinuous)
          ValueListenableBuilder<bool>(
            valueListenable: widget.autoScroll,
            builder: (context, enabled, _) => MobileSettingsGroup(
              children: [
                NodeLaneSwitchRow(
                  title: l10n.auto_scroll,
                  icon: NodeLaneIcons.of(context).timer,
                  value: enabled,
                  onChanged: widget.onAutoScrollChanged,
                ),
                if (enabled)
                  ValueListenableBuilder<double>(
                    valueListenable: widget.speed,
                    builder: (context, value, _) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(l10n.speed),
                          Text('${value.toStringAsFixed(1)}x'),
                          Slider(
                            min: 2,
                            max: 30,
                            divisions: 28,
                            value: value.clamp(2, 30),
                            onChanged: widget.onSpeedPreview,
                            onChangeEnd: widget.onSpeedChanged,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
