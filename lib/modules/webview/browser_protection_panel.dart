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
  bool _busy = false, _dirty = false, _unavailable = false;
  @override
  void initState() {
    super.initState();
    widget.protection.changes.addListener(_changed);
    if (widget.ready) _sync();
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
      _unavailable = false;
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
    if (_busy) return;
    _scheduled ??= Timer(const Duration(milliseconds: 250), () {
      _scheduled = null;
      _sync();
    });
  }

  Future<void> _sync([bool? enabled]) async {
    if (_busy || !widget.ready || (enabled != null && status == null)) return;
    _scheduled?.cancel();
    _scheduled = null;
    _dirty = false;
    final ticket = generation;
    setState(() => _busy = true);
    SiteProtectionState? next;
    try {
      next = await widget.protection.site(widget.url, enabled: enabled);
    } catch (_) {
      // A write may have taken effect; only a fresh read may re-enable the switch.
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (ticket == generation) {
        status = next;
        _unavailable = next == null;
      }
    });
    if (_dirty) _changed();
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
    final ticket = generation;
    final canRetry = widget.ready && _unavailable && !_busy;
    return NodeLaneLiveBubbleButton(
      key: ValueKey(ticket),
      title: l.browser_protection,
      editor: _BrowserProtectionContent(
        url: widget.url,
        name: widget.protection.name,
        state: state,
        busy: _busy,
        statusText: !widget.ready
            ? l.browser_filter_waiting
            : canRetry
            ? l.browser_filter_unavailable
            : l.checking_runtime_status,
        canRetry: canRetry,
        onSync: (enabled) {
          if (mounted && ticket == generation) _sync(enabled);
        },
        onAction: (action) {
          if (mounted && ticket == generation) widget.onAction(action);
        },
      ),
      builder: (_, open, _) => NodeLaneIconButton(
        tooltip: label,
        style: NodeLaneIconButtonStyle.plain,
        onPressed: open == null
            ? null
            : () {
                _sync();
                open();
              },
        iconWidget: Badge(
          isLabelVisible:
              state != null && (state.blocked > 0 || !state.enabled),
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
      ),
    );
  }
}

class _BrowserProtectionContent extends StatelessWidget {
  const _BrowserProtectionContent({
    required this.url,
    required this.name,
    required this.state,
    required this.busy,
    required this.statusText,
    required this.canRetry,
    required this.onSync,
    required this.onAction,
  });
  final String url, name, statusText;
  final SiteProtectionState? state;
  final bool busy, canRetry;
  final ValueChanged<bool?> onSync;
  final ValueChanged<SiteProtectionAction> onAction;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    final number = MaterialLocalizations.of(context).formatDecimal;
    final host = Uri.parse(url).host;
    final state = this.state;
    final colors = NodeLaneTokens.of(context);
    void select(SiteProtectionAction action) {
      if (ModalRoute.isCurrentOf(context) != true) return;
      Navigator.pop(context);
      onAction(action);
    }

    Widget counter(String label, int count) => Expanded(
      child: Semantics(
        container: true,
        child: Padding(
          padding: const EdgeInsets.all(NodeLaneTokens.space12),
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
      padding: NodeLaneTokens.bubbleContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state == null)
            NodeLaneGroupSurface(
              outlined: true,
              child: NodeLaneRow(
                icon: icons.shield,
                title: host,
                subtitle: statusText,
                trailing: canRetry
                    ? NodeLaneIconButton(
                        tooltip: l.retry,
                        icon: icons.refresh,
                        style: NodeLaneIconButtonStyle.plain,
                        onPressed: () => onSync(null),
                      )
                    : busy
                    ? const NodeLaneEmptyState.loading()
                    : null,
              ),
            )
          else ...[
            NodeLaneGroupSurface(
              outlined: true,
              selected: state.enabled,
              child: NodeLaneSwitchRow(
                title: l.browser_filter_site,
                subtitle: host,
                icon: icons.shield,
                value: state.enabled,
                onChanged: busy ? null : onSync,
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
          const SizedBox(height: NodeLaneTokens.space12),
          NodeLaneDisclosure(
            title: name,
            icon: icons.adjustments,
            child: Column(
              children: [
                NodeLaneRow(
                  title: l.browser_filter_tools,
                  icon: icons.adjustments,
                  enabled: !busy,
                  onTap: () => select(SiteProtectionAction.tools),
                ),
                NodeLaneRow(
                  title: l.browser_filter_dashboard,
                  icon: icons.settings,
                  enabled: !busy,
                  onTap: () => select(SiteProtectionAction.dashboard),
                ),
                NodeLaneRow(
                  title: l.source_clear_cookies,
                  icon: icons.cookies,
                  enabled: !busy,
                  onTap: () => select(SiteProtectionAction.clearSite),
                ),
              ],
            ),
          ),
          const SizedBox(height: NodeLaneTokens.space12),
          NodeLaneSecondaryButton(
            icon: icons.refresh,
            onPressed: busy ? null : () => select(SiteProtectionAction.reload),
            child: Text(l.browser_reload_page),
          ),
        ],
      ),
    );
  }
}
