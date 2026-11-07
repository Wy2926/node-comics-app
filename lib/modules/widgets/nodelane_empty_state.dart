import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Shared empty, failure and request states. Empty content follows its page;
/// failures scroll within the available height so retry stays reachable.
class NodeLaneEmptyState extends StatelessWidget {
  const NodeLaneEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
    this.scrollable = false,
  }) : _failure = false,
       _loading = false,
       compact = false,
       autofocusRetry = null,
       onRetry = null;

  /// Scrollable failure content, including short panels and large text.
  const NodeLaneEmptyState.error({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.compact = false,
    this.autofocusRetry,
  }) : icon = null,
       action = null,
       scrollable = false,
       _failure = true,
       _loading = false;

  /// For requests without a content silhouette; content lists use skeletons.
  const NodeLaneEmptyState.loading({super.key})
    : icon = null,
      title = null,
      message = null,
      action = null,
      scrollable = false,
      onRetry = null,
      autofocusRetry = null,
      compact = false,
      _failure = false,
      _loading = true;

  final IconData? icon;
  final String? title;
  final String? message;
  final Widget? action;
  final VoidCallback? onRetry;
  final bool compact, _failure, _loading;
  final bool scrollable;
  final bool? autofocusRetry;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    if (_loading) {
      return Center(
        child: SizedBox.square(
          dimension: NodeLaneTokens.iconSize,
          child: CircularProgressIndicator(
            color: t.accent,
            strokeWidth: NodeLaneTokens.progressTrackHeight,
            semanticsLabel: MaterialLocalizations.of(context)
                .refreshIndicatorSemanticLabel,
          ),
        ),
      );
    }
    final icons = NodeLaneIcons.of(context);
    final detail = message?.trim();
    final actionWidget = onRetry == null
        ? action
        : NodeLaneSecondaryButton(
            autofocus: autofocusRetry ?? isTv,
            onPressed: onRetry,
            icon: icons.refresh,
            child: Text(context.l10n.retry),
          );
    final content = Padding(
      padding: EdgeInsets.all(
        compact ? NodeLaneTokens.space12 : NodeLaneTokens.gutter,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? icons.error,
            size: compact
                ? NodeLaneTokens.iconSize
                : NodeLaneTokens.emptyStateIconSize,
            color: _failure ? Theme.of(context).colorScheme.error : t.muted,
          ),
          SizedBox(
            height: compact ? NodeLaneTokens.space8 : NodeLaneTokens.space16,
          ),
          Text(
            title ?? context.l10n.something_went_wrong,
            textAlign: TextAlign.center,
            style: compact ? t.readerLabel : t.title,
          ),
          if (detail != null && detail.isNotEmpty) ...[
            const SizedBox(height: NodeLaneTokens.space8),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: t.readerSecondary,
              maxLines: _failure ? 4 : null,
              overflow: _failure ? TextOverflow.ellipsis : null,
            ),
          ],
          if (actionWidget != null) ...[
            const SizedBox(height: NodeLaneTokens.space16),
            actionWidget,
          ],
        ],
      ),
    );
    if (scrollable) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Center(child: content),
          ),
        ),
      );
    }
    return _failure
        ? Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: NodeLaneTokens.dialogMaxWidth,
                ),
                child: content,
              ),
            ),
          )
        : content;
  }
}
