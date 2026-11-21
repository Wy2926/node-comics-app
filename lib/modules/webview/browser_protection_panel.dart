import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'browser_page_controller.dart';

/// Re-read the active document on uBO badge changes, never on a polling timer.
class BrowserProtectionButton extends StatefulWidget {
  const BrowserProtectionButton({
    super.key,
    required this.protection,
    required this.url,
    required this.ready,
    required this.onAction,
  });
  final BrowserProtection protection;
  final String url;
  final bool ready;
  final ValueChanged<SiteProtectionAction> onAction;
  @override
  State<BrowserProtectionButton> createState() =>
      _BrowserProtectionButtonState();
}

class _BrowserProtectionButtonState extends State<BrowserProtectionButton> {
  SiteProtectionState? status;
  int generation = 0;
  Timer? _scheduled;
  bool _reading = false, _dirty = false, _openPanel = false;
  @override
  void initState() {
    super.initState();
    widget.protection.changes.addListener(_changed);
    if (widget.ready) _read();
  }

  @override
  void didUpdateWidget(BrowserProtectionButton old) {
    super.didUpdateWidget(old);
    final differentPage =
        old.url != widget.url || old.protection != widget.protection;
    if (old.protection != widget.protection) {
      old.protection.changes.removeListener(_changed);
      widget.protection.changes.addListener(_changed);
    }
    if (differentPage || (old.ready && !widget.ready)) {
      generation++;
      status = null;
    }
    if (widget.ready && (differentPage || !old.ready)) _changed();
  }

  @override
  void dispose() {
    _scheduled?.cancel();
    widget.protection.changes.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    if (!widget.ready) return;
    _dirty = true;
    if (_reading || _openPanel) return;
    _scheduled ??= Timer(const Duration(milliseconds: 250), () {
      _scheduled = null;
      if (widget.ready && !_openPanel) _read();
    });
  }

  Future<void> _read() async {
    _reading = true;
    _dirty = false;
    final ticket = ++generation;
    SiteProtectionState? next;
    try {
      next = await widget.protection.site(widget.url);
    } catch (_) {}
    if (!mounted) return;
    _reading = false;
    if (ticket == generation && status != next) setState(() => status = next);
    if (_dirty) _changed();
  }

  Future<void> _open() async {
    if (_openPanel) return;
    _openPanel = true;
    final ticket = ++generation;
    try {
      final result = await showNodeLaneBubble<SiteProtectionAction>(
        context,
        label: context.l10n.browser_protection,
        width: NodeLaneTokens.bubbleToolWidth,
        child: BrowserProtectionPanel(
          protection: widget.protection,
          url: widget.url,
          onChanged: (next) {
            if (mounted && ticket == generation) setState(() => status = next);
          },
        ),
      );
      if (mounted && ticket == generation && result != null) {
        widget.onAction(result);
      }
    } finally {
      _openPanel = false;
      if (mounted) _changed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n,
        t = NodeLaneTokens.of(context),
        icons = NodeLaneIcons.of(context);
    final state = status;
    final number = MaterialLocalizations.of(context).formatDecimal;
    final label = state == null
        ? l.browser_protection
        : '${l.browser_protection} · ${state.enabled ? '${l.browser_blocked_here}: ${number(state.blocked)}' : l.nav_layout_disabled}';
    return NodeLaneIconButton(
      tooltip: label,
      style: NodeLaneIconButtonStyle.plain,
      onPressed: _open,
      iconWidget: Badge(
        isLabelVisible: state != null && (state.blocked > 0 || !state.enabled),
        backgroundColor: state?.enabled == false ? t.muted : t.accent,
        textColor: state?.enabled == false
            ? t.surface
            : Theme.of(context).colorScheme.onPrimary,
        label: ExcludeSemantics(
          child: state?.enabled == false
              ? Icon(icons.pause, size: 10, color: t.surface)
              : Text(
                  (state?.blocked ?? 0) > 99
                      ? '${number(99)}+'
                      : number(state?.blocked ?? 0),
                ),
        ),
        child: Icon(
          icons.shield,
          size: NodeLaneTokens.iconSize,
          color: state?.enabled == true ? t.accent : t.muted,
        ),
      ),
    );
  }
}

class BrowserProtectionPanel extends StatefulWidget {
  const BrowserProtectionPanel({
    super.key,
    required this.protection,
    required this.url,
    this.onChanged,
  });
  final BrowserProtection protection;
  final String url;
  final ValueChanged<SiteProtectionState?>? onChanged;

  @override
  State<BrowserProtectionPanel> createState() => _BrowserProtectionPanelState();
}

class _BrowserProtectionPanelState extends State<BrowserProtectionPanel> {
  SiteProtectionState? _state;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  Future<void> _sync([bool? enabled]) async {
    if (_busy) return;
    setState(() => _busy = true);
    SiteProtectionState? result;
    try {
      result = await widget.protection.site(widget.url, enabled: enabled);
    } catch (_) {
      // A failed write can have taken effect. Retry reads the engine before allowing another.
      result = null;
    }
    if (!mounted) return;
    widget.onChanged?.call(result);
    setState(() {
      _state = result;
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    final host = Uri.parse(widget.url).host;
    final number = MaterialLocalizations.of(context).formatDecimal;
    final state = _state;
    final colors = NodeLaneTokens.of(context);
    Widget counter(String label, int count) => Expanded(
      child: Semantics(
        container: true,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: colors.secondary),
              Text(number(count), style: colors.title),
            ],
          ),
        ),
      ),
    );
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NodeLaneBubbleHeading(l.browser_protection),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state == null)
                  NodeLaneGroupSurface(
                    child: Padding(
                      padding: NodeLaneTokens.groupPadding,
                      child: _busy
                          ? const NodeLaneEmptyState.loading()
                          : NodeLaneEmptyState.error(
                              title: l.browser_action_failed,
                              compact: true,
                              onRetry: _sync,
                            ),
                    ),
                  )
                else ...[
                  NodeLaneGroupSurface(
                    selected: state.enabled,
                    child: NodeLaneSwitchRow(
                      title: l.browser_filter_site,
                      subtitle: host,
                      icon: icons.shield,
                      value: state.enabled,
                      onChanged: _busy ? null : _sync,
                    ),
                  ),
                  const SizedBox(height: NodeLaneTokens.space12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.soft,
                      borderRadius: BorderRadius.circular(
                        NodeLaneTokens.controlRadius,
                      ),
                    ),
                    child: Row(
                      children: [
                        counter(l.browser_blocked_here, state.blocked),
                        counter(l.browser_blocked_total, state.total),
                      ],
                    ),
                  ),
                ],
                NodeLaneDisclosure(
                  title: widget.protection.name,
                  icon: icons.adjustments,
                  child: Column(
                    children: [
                      NodeLaneRow(
                        title: l.browser_filter_tools,
                        icon: icons.adjustments,
                        enabled: !_busy,
                        onTap: () =>
                            Navigator.pop(context, SiteProtectionAction.tools),
                      ),
                      NodeLaneRow(
                        title: l.browser_filter_dashboard,
                        icon: icons.settings,
                        enabled: !_busy,
                        onTap: () => Navigator.pop(
                          context,
                          SiteProtectionAction.dashboard,
                        ),
                      ),
                      NodeLaneRow(
                        title: l.source_clear_cookies,
                        icon: icons.cookies,
                        enabled: !_busy,
                        onTap: () => Navigator.pop(
                          context,
                          SiteProtectionAction.clearSite,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: NodeLaneTokens.space16),
                NodeLaneSecondaryButton(
                  icon: icons.refresh,
                  onPressed: _busy
                      ? null
                      : () =>
                            Navigator.pop(context, SiteProtectionAction.reload),
                  child: Text(l.browser_reload_page),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
