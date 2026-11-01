import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
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
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 36, height: 36, child: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(subtitle!, style: TextStyle(color: colors.muted)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Semantics(
              label: '${connected ? l10n.log_out : l10n.login} $title',
              button: true,
              enabled: onAction != null,
              onTap: onAction,
              excludeSemantics: true,
              child: TextButton.icon(
                onPressed: onAction,
                icon: Icon(
                  connected ? Icons.logout_rounded : Icons.login_rounded,
                ),
                label: Text(connected ? l10n.log_out : l10n.login),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Returns only the decision. The owning page runs its existing operation.
Future<bool> showMobileSettingsConfirmation(
  BuildContext context, {
  required String title,
  String? message,
  required String confirmLabel,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => NodeLaneAlertDialog(
        scrollable: true,
        title: Text(title),
        content: message == null ? null : Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    ) ??
    false;
