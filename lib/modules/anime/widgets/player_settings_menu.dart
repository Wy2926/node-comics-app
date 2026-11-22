import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/anime/widgets/player_settings_navigation.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

Future<void> showPlayerSettingsMenu(
  BuildContext anchor, {
  required String title,
  required List<SettingsEntry> entries,
  required bool mobile,
  int initialIndex = -1,
}) => showNodeLaneBubble<void>(
  anchor,
  label: title,
  width: mobile
      ? NodeLaneTokens.bubbleSettingsWidth
      : NodeLaneTokens.bubbleToolWidth,
  child: _PlayerSettingsPanel(
    title: title,
    entries: entries,
    mobile: mobile,
    initialIndex: initialIndex,
  ),
);

class _PlayerSettingsPanel extends StatefulWidget {
  const _PlayerSettingsPanel({
    required this.title,
    required this.entries,
    required this.mobile,
    required this.initialIndex,
  });

  final String title;
  final bool mobile;
  final List<SettingsEntry> entries;
  final int initialIndex;

  @override
  State<_PlayerSettingsPanel> createState() => _PlayerSettingsPanelState();
}

class _PlayerSettingsPanelState extends State<_PlayerSettingsPanel> {
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final base = Theme.of(context);
    final active = _active;
    final canGoBack = !_direct && active != null;

    return Theme(
      data: widget.mobile
          ? base.copyWith(
              colorScheme: base.colorScheme.copyWith(
                surface: colors.surface,
                onSurface: colors.ink,
                onSurfaceVariant: colors.muted,
                surfaceContainerHighest: colors.soft,
                outline: colors.line,
                outlineVariant: colors.line,
              ),
              dividerColor: colors.line,
            )
          : base,
      child: SettingsDrilldownScope(
        goHome: _goHome,
        close: _close,
        isDirectShortcut: _direct,
        mobile: widget.mobile,
        child: IgnorePointer(
          ignoring: _closing,
          child: PopScope(
            canPop: !canGoBack,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop && canGoBack) _goHome();
            },
            child: NodeLaneBubblePanel(
              title: active == null
                  ? widget.title
                  : widget.entries[active].label,
              actions: [
                if (canGoBack)
                  NodeLaneBubbleAction.back.button(context, _goHome),
              ],
              onDismiss: _close,
              // The builders need this inner context so the
              // existing onDone callbacks can find their scope.
              child: Builder(
                builder: (sectionContext) {
                  final body = active == null
                      ? ListView.separated(
                          shrinkWrap: true,
                          key: const PageStorageKey('player-settings-home'),
                          controller: _homeScroll,
                          padding: widget.mobile
                              ? NodeLaneTokens.groupPadding
                              : const EdgeInsets.only(
                                  bottom: NodeLaneTokens.space12,
                                ),
                          itemCount: widget.entries.length,
                          separatorBuilder: (_, _) => SizedBox(
                            height: widget.mobile ? NodeLaneTokens.space8 : 0,
                          ),
                          itemBuilder: (context, index) {
                            final entry = widget.entries[index];
                            return _SettingsEntryRow(
                              entry: entry,
                              mobile: widget.mobile,
                              onTap: () {
                                if (entry.onTap != null) {
                                  entry.onTap!(context);
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
                          child: widget.entries[active].contentBuilder!(
                            sectionContext,
                          ),
                        );
                  return widget.mobile
                      ? body
                      : NodeLaneMotion.resize(
                          context,
                          NodeLaneContentMotion(
                            value: active,
                            reverse: active == null,
                            child: body,
                          ),
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsEntryRow extends StatelessWidget {
  const _SettingsEntryRow({
    required this.entry,
    required this.mobile,
    required this.onTap,
  });
  final SettingsEntry entry;
  final bool mobile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final value = entry.valueBuilder?.call(context);
    if (!mobile) {
      return NodeLaneRow(
        compact: true,
        title: entry.label,
        icon: entry.icon,
        valueLeading: value == null
            ? null
            : DefaultTextStyle.merge(
                style: colors.secondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: value,
              ),
        onTap: onTap,
      );
    }
    return NodeLaneGroupSurface(
      outlined: true,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: NodeLaneTokens.space16,
          vertical: NodeLaneTokens.space4,
        ),
        minTileHeight: NodeLaneTokens.readerActionHeight,
        leading: Icon(entry.icon, color: colors.accent),
        title: Text(entry.label, style: colors.body),
        subtitle: value == null
            ? null
            : DefaultTextStyle.merge(style: colors.secondary, child: value),
        trailing: Icon(
          Icons.chevron_right,
          size: NodeLaneTokens.smallIconSize,
          color: colors.muted,
        ),
      ),
    );
  }
}
