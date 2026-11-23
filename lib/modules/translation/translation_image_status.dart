import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'translation_view_controller.dart';

/// Pass resolved native tokens to the document, including dark/high contrast themes.
Map<String, Object> translationImageTheme(BuildContext context) {
  final t = NodeLaneTokens.of(context);
  String css(Color color) =>
      '#${(color.toARGB32() & 0xffffff).toRadixString(16).padLeft(6, '0')}';
  return {
    'surface': css(t.surface),
    'ink': css(t.ink),
    'line': css(t.line),
    'accent': css(t.accent),
    'error': css(Theme.of(context).colorScheme.error),
    'radius': NodeLaneTokens.capsuleRadius,
    'inset': NodeLaneTokens.space8,
    'gap': NodeLaneTokens.space8,
    'padding': NodeLaneTokens.space12,
    'tap': NodeLaneTokens.minTapTarget,
    'fontSize': MediaQuery.textScalerOf(context).scale(t.secondary.fontSize!),
    'reduceMotion': MediaQuery.disableAnimationsOf(context),
  };
}

/// Shared copy and actions for native image badges and the WebView bridge.
class TranslationImageStatus {
  const TranslationImageStatus(
    this.label, {
    this.detail = '',
    this.working = false,
    this.issue = false,
    this.visible = true,
    this.action,
  });
  final String label, detail;
  final bool working, issue, visible;
  final TranslationAction? action;
  String get visibleLabel =>
      issue && detail.isNotEmpty && detail != label ? '$label\n$detail' : label;

  factory TranslationImageStatus.forTarget(
    TranslationViewController controller,
    TranslationTarget target,
    AppLocalizations l10n,
  ) {
    if (!controller.showTranslation) {
      return const TranslationImageStatus('', visible: false);
    }
    final state = controller.state(target);
    if (controller.isPerforming(target)) {
      return TranslationImageStatus(l10n.translation_processing, working: true);
    }
    if (state.failure?.quotaExhausted == true) {
      return TranslationImageStatus(
        l10n.translation_quota_exhausted,
        issue: true,
        action: TranslationAction.upgrade,
      );
    }
    if (controller.isReading(target) &&
        state.phase == TranslationPhase.succeeded) {
      return TranslationImageStatus(l10n.translation_reading, working: true);
    }
    if (state.noText ||
        state.phase == TranslationPhase.succeeded ||
        (state.phase == TranslationPhase.idle &&
            !controller.shouldTranslateAutomatically)) {
      return const TranslationImageStatus('', visible: false);
    }
    final working = const {
      TranslationPhase.preparing,
      TranslationPhase.submitting,
      TranslationPhase.awaitingInput,
      TranslationPhase.queued,
      TranslationPhase.running,
    }.contains(state.phase);
    final label = switch (state.phase) {
      TranslationPhase.idle ||
      TranslationPhase.queued => l10n.translation_waiting,
      TranslationPhase.preparing => l10n.translation_preparing,
      TranslationPhase.submitting ||
      TranslationPhase.awaitingInput => l10n.translation_uploading,
      TranslationPhase.running => l10n.translation_running,
      TranslationPhase.uncertain => l10n.translation_uncertain,
      TranslationPhase.failed =>
        state.result == null
            ? l10n.translation_failed
            : l10n.translation_read_failed,
      TranslationPhase.succeeded => '',
    };
    final action = working
        ? null
        : [
            if (state.phase == TranslationPhase.failed)
              TranslationAction.readResult,
            TranslationAction.retry,
            TranslationAction.verify,
          ].where(state.actions.contains).firstOrNull;
    return TranslationImageStatus(
      label,
      detail: state.message,
      working: working,
      issue: state.hasIssue,
      action: action,
    );
  }

  String actionLabel(AppLocalizations l10n) => switch (action) {
    TranslationAction.retry => l10n.retry,
    TranslationAction.verify => l10n.translation_verify,
    TranslationAction.readResult => l10n.translation_reread,
    TranslationAction.upgrade => l10n.translation_upgrade_quota,
    _ => '',
  };
  Map<String, Object?> toJson(AppLocalizations l10n) => {
    'label': visibleLabel,
    'visible': visible,
    'detail': detail,
    'working': working,
    'issue': issue,
    'action': action?.name,
    'actionLabel': actionLabel(l10n),
    'actionSemanticLabel': l10n.translation_image_action(actionLabel(l10n)),
  };
}

/// Sits inside the image, outside its color filter. Only the button takes taps.
class TranslationImageBadge extends StatelessWidget {
  const TranslationImageBadge({
    super.key,
    required this.status,
    this.onAction,
    this.actionRegion,
  });
  final TranslationImageStatus status;
  final VoidCallback? onAction;
  final Widget Function(Widget button)? actionRegion;

  @override
  Widget build(BuildContext context) {
    if (!status.visible) return const SizedBox.shrink();
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final color = status.issue ? Theme.of(context).colorScheme.error : t.accent;
    late final button = TextButton(
      onPressed: onAction,
      style: TextButton.styleFrom(
        foregroundColor: t.accent,
        minimumSize: const Size(
          NodeLaneTokens.minTapTarget,
          NodeLaneTokens.minTapTarget,
        ),
        padding: const EdgeInsets.symmetric(horizontal: NodeLaneTokens.space12),
        textStyle: t.readerSecondary.copyWith(fontWeight: FontWeight.w600),
      ),
      child: Text(status.actionLabel(context.l10n)),
    );
    return Tooltip(
      message: status.detail.isEmpty ? status.label : status.detail,
      child: Material(
        color: t.surface,
        shape: StadiumBorder(side: BorderSide(color: t.line)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.only(
            left: NodeLaneTokens.space12,
            right: NodeLaneTokens.space4,
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: NodeLaneTokens.space8,
                  horizontal: NodeLaneTokens.space4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (status.working)
                      SizedBox.square(
                        dimension: NodeLaneTokens.badgeIconSize,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color,
                        ),
                      )
                    else
                      Icon(
                        status.issue ? icons.error : icons.translate,
                        size: NodeLaneTokens.badgeIconSize,
                        color: color,
                      ),
                    const SizedBox(width: NodeLaneTokens.space8),
                    Flexible(
                      child: Text(
                        status.visibleLabel,
                        maxLines: status.issue ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: t.secondary.copyWith(color: t.ink),
                      ),
                    ),
                    const SizedBox(width: NodeLaneTokens.space8),
                  ],
                ),
              ),
              if (status.action != null) actionRegion?.call(button) ?? button,
            ],
          ),
        ),
      ),
    );
  }
}
