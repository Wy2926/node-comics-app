import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/modules/anime/widgets/player_settings_navigation.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Phone presentation only. Entries and their playback callbacks remain owned
/// by the player; leaving a section releases its listeners and text fields.
class MobilePlayerSettingsSheet extends StatefulWidget {
  const MobilePlayerSettingsSheet({
    super.key,
    required this.title,
    required this.entries,
    required this.onClose,
    this.initialIndex = -1,
  });

  final String title;
  final List<SettingsEntry> entries;
  final int initialIndex;
  final VoidCallback onClose;

  @override
  State<MobilePlayerSettingsSheet> createState() =>
      _MobilePlayerSettingsSheetState();
}

class _MobilePlayerSettingsSheetState extends State<MobilePlayerSettingsSheet> {
  late int? _active = _section(widget.initialIndex);
  final _homeScroll = ScrollController();
  bool _closing = false;

  int? _section(int index) =>
      index >= 0 &&
          index < widget.entries.length &&
          widget.entries[index].contentBuilder != null
      ? index
      : null;

  bool get _direct => _section(widget.initialIndex) != null;

  @override
  void didUpdateWidget(MobilePlayerSettingsSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _active = _section(widget.initialIndex);
    } else if (_active != null) {
      _active = _section(_active!);
    }
  }

  @override
  void dispose() {
    _homeScroll.dispose();
    super.dispose();
  }

  void _goHome() {
    if (!mounted || _closing) return;
    FocusScope.of(context).unfocus();
    setState(() => _active = null);
  }

  void _close() {
    if (!mounted || _closing) return;
    setState(() => _closing = true);
    FocusScope.of(context).unfocus();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final base = Theme.of(context);
    final active = _active;
    final canGoBack = !_direct && active != null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          // Constraints already account for the keyboard and modal safe area.
          // A fixed header and flexible body also work in landscape.
          height: constraints.maxHeight * .9,
          width: 640,
          child: Theme(
            data: base.copyWith(
              colorScheme: base.colorScheme.copyWith(
                surface: colors.surface,
                onSurface: colors.ink,
                onSurfaceVariant: colors.muted,
                surfaceContainerHighest: colors.soft,
                outline: colors.line,
                outlineVariant: colors.line,
              ),
              dividerColor: colors.line,
            ),
            child: SettingsDrilldownScope(
              goHome: _goHome,
              close: _close,
              isDirectShortcut: _direct,
              mobile: true,
              child: IgnorePointer(
                ignoring: _closing,
                child: PopScope(
                  canPop: !canGoBack,
                  onPopInvokedWithResult: (didPop, _) {
                    if (!didPop && canGoBack) _goHome();
                  },
                  child: NodeLaneSheetSurface(
                    grouped: true,
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 4),
                            child: Container(
                              width: 32,
                              height: 4,
                              decoration: BoxDecoration(
                                color: colors.line,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                if (canGoBack)
                                  BackButton(
                                    key: const ValueKey('player-settings-back'),
                                    onPressed: _goHome,
                                    color: colors.ink,
                                  )
                                else
                                  const SizedBox(width: 12),
                                Expanded(
                                  child: Semantics(
                                    header: true,
                                    child: Text(
                                      active == null
                                          ? widget.title
                                          : widget.entries[active].label,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: colors.ink,
                                      ),
                                    ),
                                  ),
                                ),
                                CloseButton(
                                  key: const ValueKey('player-settings-close'),
                                  onPressed: _close,
                                  color: colors.ink,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Divider(height: 1, color: colors.line),
                          Expanded(
                            // The builders need this inner context so the
                            // existing onDone callbacks can find their scope.
                            child: Builder(
                              builder: (sectionContext) => active == null
                                  ? ListView.separated(
                                      key: const PageStorageKey(
                                        'player-settings-home',
                                      ),
                                      controller: _homeScroll,
                                      padding: const EdgeInsets.all(16),
                                      itemCount: widget.entries.length,
                                      separatorBuilder: (_, _) =>
                                          const SizedBox(height: 8),
                                      itemBuilder: (context, index) {
                                        final entry = widget.entries[index];
                                        return _MobileSettingsEntry(
                                          entry: entry,
                                          onTap: () {
                                            if (entry.onTap != null) {
                                              entry.onTap!(sectionContext);
                                            } else {
                                              setState(() => _active = index);
                                            }
                                          },
                                        );
                                      },
                                    )
                                  : SingleChildScrollView(
                                      key: PageStorageKey(
                                        'player-settings-section-$active',
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 16,
                                      ),
                                      child: widget
                                          .entries[active]
                                          .contentBuilder!(sectionContext),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileSettingsEntry extends StatelessWidget {
  const _MobileSettingsEntry({required this.entry, required this.onTap});
  final SettingsEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minTileHeight: 64,
        leading: Icon(entry.icon, color: colors.accent),
        title: Text(
          entry.label,
          style: TextStyle(fontSize: 16, color: colors.ink),
        ),
        subtitle: entry.valueBuilder == null
            ? null
            : DefaultTextStyle.merge(
                style: TextStyle(fontSize: 13, color: colors.muted),
                child: entry.valueBuilder!(context),
              ),
        trailing: Icon(Icons.chevron_right, size: 20, color: colors.muted),
      ),
    );
  }
}
