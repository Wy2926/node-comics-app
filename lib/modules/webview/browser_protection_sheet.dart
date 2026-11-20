import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'browser_page_controller.dart';

class BrowserProtectionSheet extends StatefulWidget {
  const BrowserProtectionSheet({
    super.key,
    required this.protection,
    required this.url,
  });
  final BrowserProtection protection;
  final String url;

  @override
  State<BrowserProtectionSheet> createState() => _BrowserProtectionSheetState();
}

class _BrowserProtectionSheetState extends State<BrowserProtectionSheet> {
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
    return NodeLaneCatalogSheet(
      title: l.browser_protection,
      fitContent: true,
      heightFactor: NodeLaneTokens.readerDisplayFraction,
      child: SingleChildScrollView(
        padding: NodeLaneTokens.modalContentPadding,
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
              NodeLaneGroupSurface(
                children: [
                  NodeLaneRow(
                    title: l.browser_blocked_here,
                    value: number(state.blocked),
                  ),
                  NodeLaneRow(
                    title: l.browser_blocked_total,
                    value: number(state.total),
                  ),
                ],
              ),
            ],
            NodeLaneCatalogHeading(widget.protection.name),
            NodeLaneGroupSurface(
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
                  onTap: () =>
                      Navigator.pop(context, SiteProtectionAction.dashboard),
                ),
              ],
            ),
            const SizedBox(height: NodeLaneTokens.space16),
            NodeLaneSecondaryButton(
              icon: icons.refresh,
              onPressed: _busy
                  ? null
                  : () => Navigator.pop(context, SiteProtectionAction.reload),
              child: Text(l.browser_reload_page),
            ),
          ],
        ),
      ),
    );
  }
}
