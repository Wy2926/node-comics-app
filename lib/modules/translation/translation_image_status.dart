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

  factory TranslationImageStatus.forTarget(
    TranslationViewController controller,
    TranslationTarget target,
  ) {
    final state = controller.state(target);
    if (controller.isPerforming(target)) {
      return const TranslationImageStatus('正在处理', working: true);
    }
    if (controller.isReading(target) &&
        state.phase == TranslationPhase.succeeded) {
      return const TranslationImageStatus('正在读取译图', working: true);
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
      TranslationPhase.idle || TranslationPhase.queued => '等待翻译',
      TranslationPhase.preparing => '准备翻译',
      TranslationPhase.submitting || TranslationPhase.awaitingInput => '上传原图',
      TranslationPhase.running => '正在翻译',
      TranslationPhase.uncertain => '状态待确认',
      TranslationPhase.failed => state.result == null ? '翻译失败' : '译图读取失败',
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
      issue:
          state.phase == TranslationPhase.failed ||
          state.phase == TranslationPhase.uncertain,
      action: action,
    );
  }

  String get actionLabel => switch (action) {
    TranslationAction.retry => '重试',
    TranslationAction.verify => '核实',
    TranslationAction.readResult => '重新读取',
    _ => '',
  };
  Map<String, Object?> toJson() => {
    'label': label,
    'visible': visible,
    'detail': detail,
    'working': working,
    'issue': issue,
    'action': action?.name,
    'actionLabel': actionLabel,
  };
}

/// Sits inside the image, outside its color filter. Only the button takes taps.
class TranslationImageBadge extends StatelessWidget {
  const TranslationImageBadge({super.key, required this.status, this.onAction});
  final TranslationImageStatus status;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    if (!status.visible) return const SizedBox.shrink();
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final color = status.issue ? Theme.of(context).colorScheme.error : t.accent;
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
                        status.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: t.secondary.copyWith(color: t.ink),
                      ),
                    ),
                    const SizedBox(width: NodeLaneTokens.space8),
                  ],
                ),
              ),
              if (status.action != null)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: t.accent,
                    minimumSize: const Size(
                      NodeLaneTokens.minTapTarget,
                      NodeLaneTokens.minTapTarget,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: NodeLaneTokens.space12,
                    ),
                    textStyle: t.readerSecondary.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(status.actionLabel),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
