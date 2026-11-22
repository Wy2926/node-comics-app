import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// A visible account action; tapping the account name never signs it out.
class MobileServiceAccount extends StatelessWidget {
  const MobileServiceAccount({
    super.key,
    required this.title,
    required this.icon,
    required this.connected,
    required this.onAction,
    this.subtitle,
  });
  final String title;
  final Widget icon;
  final bool connected;
  final String? subtitle;
  final ValueChanged<BuildContext>? onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: NodeLaneTokens.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NodeLaneRow(title: title, subtitle: subtitle, leading: icon),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Builder(
              builder: (anchor) => Semantics(
                label: '${connected ? l10n.log_out : l10n.login} $title',
                button: true,
                enabled: onAction != null,
                onTap: onAction == null ? null : () => onAction!(anchor),
                excludeSemantics: true,
                child: TextButton.icon(
                  onPressed: onAction == null ? null : () => onAction!(anchor),
                  icon: Icon(
                    connected
                        ? NodeLaneIcons.of(context).signOut
                        : NodeLaneIcons.of(context).signIn,
                  ),
                  label: Text(connected ? l10n.log_out : l10n.login),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
