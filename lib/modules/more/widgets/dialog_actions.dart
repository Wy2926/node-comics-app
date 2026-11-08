import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

List<Widget> dialogCancelConfirmActions({
  required BuildContext dialogContext,
  required String confirmLabel,
  bool destructive = false,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
}) => [
  NodeLaneDialogAction(
    label: dialogContext.l10n.cancel,
    secondary: true,
    onPressed: onCancel ?? () => Navigator.pop(dialogContext, false),
  ),
  NodeLaneDialogAction(
    label: confirmLabel,
    destructive: destructive,
    onPressed: onConfirm ?? () => Navigator.pop(dialogContext, true),
  ),
];

List<Widget> dialogCancelOnlyAction(BuildContext dialogContext) => [
  NodeLaneDialogAction(
    label: dialogContext.l10n.cancel,
    secondary: true,
    onPressed: () => Navigator.pop(dialogContext),
  ),
];

/// Restore still requires an explicit decision before updating the server.
Future<bool?> confirmSyncAfterRestore(
  BuildContext context, {
  required bool syncOn,
}) {
  final l10n = context.l10n;
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => PopScope(
      canPop: false,
      child: NodeLaneAlertDialog(
        title: Text(
          syncOn
              ? l10n.restore_sync_question_title
              : l10n.restore_sync_disabled_question_title,
        ),
        content: Text(
          syncOn
              ? l10n.restore_sync_question_message
              : l10n.restore_sync_disabled_question_message,
        ),
        actions: [
          NodeLaneDialogAction(
            label: syncOn
                ? l10n.restore_sync_question_deny
                : l10n.restore_sync_question_keep_disabled,
            secondary: true,
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          NodeLaneDialogAction(
            label: syncOn
                ? l10n.restore_sync_question_confirm
                : l10n.restore_sync_question_reenable,
            destructive: syncOn,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    ),
  );
}

void showBusyDialog(BuildContext context, String message) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: NodeLaneAlertDialog(
        content: NodeLaneNotice(
          message: message,
          kind: NodeLaneNoticeKind.progress,
          contained: false,
        ),
      ),
    ),
  );
}

void hideBusyDialog(BuildContext context) {
  final navigator = Navigator.of(context, rootNavigator: true);
  if (navigator.canPop()) navigator.pop();
}

void showLogOutDialog(
  BuildContext context, {
  required String serviceName,
  required VoidCallback onLogOut,
}) async {
  final confirmed = await showNodeLaneConfirmation(
    context,
    title: context.l10n.log_out_from(serviceName),
    confirmLabel: context.l10n.log_out,
  );
  if (confirmed && context.mounted) onLogOut();
}
