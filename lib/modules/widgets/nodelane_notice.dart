import 'dart:async';
import 'dart:math' as math;

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_progress.dart';
import 'package:flutter/rendering.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_glass_surface.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/utils/localized_message.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

enum NodeLaneNoticeKind {
  info,
  success,
  error,
  progress,
  verification,
  recovery,
}

/// One content layout for transient notices and persistent, in-page feedback.
/// Actions and task state stay with the caller; this widget only renders them.
class NodeLaneNotice extends StatelessWidget {
  const NodeLaneNotice({
    super.key,
    required this.message,
    this.description,
    this.kind = NodeLaneNoticeKind.info,
    this.actionLabel,
    this.onAction,
    this.onClose,
    this.progress,
    this.floating = false,
    this.contained = true,
  }) : assert((actionLabel == null) == (onAction == null));

  final String message;
  final String? description, actionLabel;
  final NodeLaneNoticeKind kind;
  final VoidCallback? onAction, onClose;
  final double? progress;
  final bool floating;

  /// A surrounding modal or group can supply the surface and spacing.
  final bool contained;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final busy = kind == NodeLaneNoticeKind.progress;
    final compact = description == null && onAction == null && !busy;
    final icon = switch (kind) {
      NodeLaneNoticeKind.success => compact ? icons.check : icons.downloaded,
      NodeLaneNoticeKind.error => icons.error,
      NodeLaneNoticeKind.verification => icons.web,
      NodeLaneNoticeKind.recovery => icons.reset,
      _ => icons.info,
    };
    final content = Stack(
      children: [
        Padding(
          padding: contained ? NodeLaneTokens.groupPadding : EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: compact
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (busy)
                SizedBox.square(
                  dimension: NodeLaneTokens.iconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: NodeLaneTokens.progressTrackHeight,
                    color: t.accent,
                  ),
                )
              else
                Icon(
                  icon,
                  size: NodeLaneTokens.iconSize,
                  color: kind == NodeLaneNoticeKind.error
                      ? Theme.of(context).colorScheme.error
                      : t.ink,
                ),
              const SizedBox(width: NodeLaneTokens.space12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message, style: compact ? t.body : t.readerLabel),
                    if (description case final description?) ...[
                      const SizedBox(height: NodeLaneTokens.space4),
                      Text(description, style: t.readerSecondary),
                    ],
                    if (busy && progress != null) ...[
                      const SizedBox(height: NodeLaneTokens.space16),
                      NodeLaneProgress(value: progress),
                    ],
                    if (onAction != null) ...[
                      const SizedBox(height: NodeLaneTokens.space8),
                      TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          alignment: AlignmentDirectional.centerStart,
                        ),
                        child: Text(actionLabel!),
                      ),
                    ],
                  ],
                ),
              ),
              if (onClose != null) ...[
                const SizedBox(width: NodeLaneTokens.space4),
                const SizedBox(width: NodeLaneTokens.minTapTarget),
              ],
            ],
          ),
        ),
        if (onClose != null)
          PositionedDirectional(
            top: NodeLaneTokens.space4,
            end: NodeLaneTokens.space4,
            child: NodeLaneCloseButton(
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              backgroundColor: Colors.transparent,
              onPressed: onClose!,
            ),
          ),
      ],
    );
    return NodeLaneModalScope(
      child: Semantics(
        container: true,
        liveRegion: true,
        child: floating
            ? NodeLaneGlassSurface(
                elevated: true,
                borderRadius: BorderRadius.circular(
                  NodeLaneTokens.capsuleRadius,
                ),
                child: content,
              )
            : contained
            ? NodeLaneGroupSurface(child: content)
            : content,
      ),
    );
  }
}

/// Owns only this notice. A late completion can never close another message.
class NodeLaneNoticeHandle {
  NodeLaneNoticeHandle(NodeLaneNotice notice)
    : _content = ValueNotifier(notice);
  final ValueNotifier<NodeLaneNotice> _content;
  VoidCallback? _cancel;
  bool _closed = false;

  void dismiss() {
    if (_closed) return;
    _closed = true;
    _cancel?.call();
  }

  void update(String message, {String? description, double? progress}) {
    if (_closed) return;
    final old = _content.value;
    _content.value = NodeLaneNotice(
      message: message,
      description: description,
      kind: old.kind,
      progress: progress,
      floating: true,
      onClose: dismiss,
      actionLabel: old.actionLabel,
      onAction: old.onAction,
    );
  }
}

NodeLaneNoticeHandle? _currentNotice;

/// Retained bottom-tab branches do not emit Navigator push/pop events.
/// Hide their old presentation without stopping the owning task.
void dismissNodeLaneNotice() => _currentNotice?.dismiss();

/// BotToast remains the existing overlay/lifecycle transport, not a second UI.
/// Every notification enters here; no caller supplies its own style/position.
NodeLaneNoticeHandle showNodeLaneNotice(
  String message, {
  String? description,
  NodeLaneNoticeKind kind = NodeLaneNoticeKind.info,
  String? actionLabel,
  FutureOr<void> Function()? onAction,
  int? seconds,
  double? progress,
}) {
  assert((actionLabel == null) == (onAction == null));
  late final NodeLaneNoticeHandle handle;
  var actionTaken = false;
  final notice = NodeLaneNotice(
    message: message,
    description: description,
    kind: kind,
    progress: progress,
    floating: true,
    actionLabel: actionLabel,
    onAction: onAction == null
        ? null
        : () async {
            if (actionTaken || handle._closed) return;
            actionTaken = true;
            handle.dismiss();
            try {
              await onAction();
            } catch (error, stack) {
              CrashReports.record(
                source: 'notice-action',
                error: error,
                stack: stack,
              );
              showNodeLaneNotice(
                localizedMessage((l) => l.notice_operation_incomplete),
                description: localizedMessage(
                  (l) => l.notice_action_incomplete,
                ),
                kind: NodeLaneNoticeKind.error,
              );
            }
          },
    onClose:
        onAction != null ||
            kind == NodeLaneNoticeKind.progress ||
            kind == NodeLaneNoticeKind.error ||
            description != null
        ? () => handle.dismiss()
        : null,
  );
  handle = NodeLaneNoticeHandle(notice);
  _currentNotice = handle;
  handle._cancel = BotToast.showAnimationWidget(
    groupKey: 'nodelane-notices',
    toastBuilder: (_) => Overlay.wrap(
      child: _FloatingNotice(
        content: handle._content,
        onDismiss: handle.dismiss,
      ),
    ),
    allowClick: true,
    clickClose: false,
    ignoreContentClick: false,
    enableKeyboardSafeArea: false,
    onlyOne: true,
    crossPage: false,
    wrapToastAnimation: (controller, _, child) => Builder(
      builder: (context) => MediaQuery.disableAnimationsOf(context)
          ? child
          : FadeTransition(opacity: controller, child: child),
    ),
    animationDuration: NodeLaneTokens.disclosureDuration,
    animationReverseDuration: NodeLaneTokens.disclosureDuration,
    duration: kind == NodeLaneNoticeKind.progress
        ? null
        : Duration(
            seconds:
                seconds ??
                (onAction != null
                    ? 8
                    : kind == NodeLaneNoticeKind.error
                    ? 6
                    : 3),
          ),
    onClose: () {
      handle._closed = true;
      if (identical(_currentNotice, handle)) _currentNotice = null;
      handle._content.dispose();
    },
  );
  return handle;
}

class _FloatingNotice extends StatelessWidget {
  const _FloatingNotice({required this.content, required this.onDismiss});
  final ValueNotifier<NodeLaneNotice> content;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _noticeObstacles,
    builder: (context, _) {
      final media = MediaQuery.of(context);
      final bottom =
          math.max(
            math.max(media.viewInsets.bottom, media.viewPadding.bottom),
            _noticeObstacles.bottom,
          ) +
          NodeLaneTokens.space12;
      return Padding(
        padding: EdgeInsets.fromLTRB(
          math.max(NodeLaneTokens.gutter, media.viewPadding.left),
          media.viewPadding.top + NodeLaneTokens.space12,
          math.max(NodeLaneTokens.gutter, media.viewPadding.right),
          bottom,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: NodeLaneTokens.dialogMaxWidth,
            ),
            child: SingleChildScrollView(
              child: ValueListenableBuilder<NodeLaneNotice>(
                valueListenable: content,
                builder: (_, notice, _) => Dismissible(
                  key: ObjectKey(content),
                  direction: DismissDirection.horizontal,
                  confirmDismiss: (_) async {
                    onDismiss();
                    return false;
                  },
                  child: notice,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

final _noticeObstacles = _NoticeObstacles();

class _NoticeObstacles extends ChangeNotifier {
  final _bottoms = <Object, double>{};
  double get bottom => _bottoms.values.fold(0, math.max);
  void set(Object owner, double bottom) {
    if ((_bottoms[owner] ?? 0) == bottom) return;
    if (bottom == 0) {
      _bottoms.remove(owner);
    } else {
      _bottoms[owner] = bottom;
    }
    notifyListeners();
  }
}

/// Measures the real bottom navigation/tool surface, including its safe area.
/// Updates only when it moves/resizes; no polling, route names or guessed heights.
class NodeLaneNoticeAvoidance extends StatefulWidget {
  const NodeLaneNoticeAvoidance({
    super.key,
    required this.child,
    this.enabled = true,
  });
  final Widget child;
  final bool enabled;
  @override
  State<NodeLaneNoticeAvoidance> createState() => _NoticeAvoidanceState();
}

class _NoticeAvoidanceState extends State<NodeLaneNoticeAvoidance> {
  double _bottom = 0;
  void _report(double value) {
    if (_bottom == value) return;
    _bottom = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _noticeObstacles.set(this, _bottom);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _noticeObstacles.set(this, 0),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active =
        widget.enabled && (ModalRoute.of(context)?.isCurrent ?? true);
    if (!active) _report(0);
    final view = View.of(context);
    return _NoticeMeasure(
      // localToGlobal already includes AppUiScale; use the same view space.
      screenHeight: view.physicalSize.height / view.devicePixelRatio,
      onPosition: (value) => _report(active ? value : 0),
      child: widget.child,
    );
  }
}

class _NoticeMeasure extends SingleChildRenderObjectWidget {
  const _NoticeMeasure({
    required this.screenHeight,
    required this.onPosition,
    required super.child,
  });
  final double screenHeight;
  final ValueChanged<double> onPosition;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      _NoticeMeasureRender(screenHeight, onPosition);
  @override
  void updateRenderObject(
    BuildContext context,
    _NoticeMeasureRender renderObject,
  ) {
    renderObject
      ..screenHeight = screenHeight
      ..onPosition = onPosition;
    renderObject.markNeedsPaint();
  }
}

class _NoticeMeasureRender extends RenderProxyBox {
  _NoticeMeasureRender(this.screenHeight, this.onPosition);
  double screenHeight;
  ValueChanged<double> onPosition;
  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    onPosition(
      size.height <= 0
          ? 0
          : (screenHeight - localToGlobal(Offset.zero).dy).clamp(
              0,
              screenHeight,
            ),
    );
  }
}
