import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Shared presentation only. Controllers, navigation and writes stay outside.
class NodeLanePageHeading extends StatelessWidget {
  const NodeLanePageHeading({
    super.key,
    required this.title,
    this.mediaMenu,
    this.actions = const [],
  });
  final String title;
  final Widget? mediaMenu;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: NodeLaneTokens.of(context).pageTitle),
            ),
          ),
          ...actions,
        ],
      ),
      if (mediaMenu != null) ...[
        const SizedBox(height: NodeLaneTokens.space4),
        mediaMenu!,
      ],
    ],
  );
}

class NodeLaneGroupSurface extends StatelessWidget {
  const NodeLaneGroupSurface({
    super.key,
    required this.child,
    this.outlined = false,
  });
  final Widget child;
  final bool outlined;
  @override
  Widget build(BuildContext context) => Material(
    color: NodeLaneTokens.of(context).surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(NodeLaneTokens.groupRadius),
      side: outlined
          ? BorderSide(color: NodeLaneTokens.of(context).line)
          : BorderSide.none,
    ),
    clipBehavior: Clip.antiAlias,
    child: child,
  );
}

class NodeLaneSectionHeading extends StatelessWidget {
  const NodeLaneSectionHeading(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(title, style: NodeLaneTokens.of(context).sectionTitle),
  );
}

enum NodeLaneIconButtonStyle { plain, tonal, field }

class NodeLaneIconButton extends StatelessWidget {
  const NodeLaneIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.style = NodeLaneIconButtonStyle.tonal,
    this.active = false,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final NodeLaneIconButtonStyle style;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: NodeLaneTokens.iconSize),
      style: IconButton.styleFrom(
        minimumSize: const Size(
          NodeLaneTokens.minTapTarget,
          NodeLaneTokens.minTapTarget,
        ),
        foregroundColor: style == NodeLaneIconButtonStyle.field && !active
            ? colors.muted
            : colors.accent,
        backgroundColor: switch (style) {
          NodeLaneIconButtonStyle.plain => Colors.transparent,
          NodeLaneIconButtonStyle.tonal => colors.accentSoft,
          NodeLaneIconButtonStyle.field =>
            active ? colors.accentSoft : colors.soft,
        },
        shape: style == NodeLaneIconButtonStyle.field
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  NodeLaneTokens.controlRadius,
                ),
              )
            : const CircleBorder(),
      ),
    );
  }
}

/// A neutral close target shared by sheets and webpage thumbnail cards.
class NodeLaneCloseButton extends StatelessWidget {
  const NodeLaneCloseButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    this.backgroundColor,
  });
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(width: 44, height: 44),
      padding: const EdgeInsets.all(6),
      style: IconButton.styleFrom(
        minimumSize: const Size(44, 44),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: backgroundColor ?? t.soft,
          shape: BoxShape.circle,
        ),
        child: Icon(NodeLaneIcons.of(context).close, size: 18, color: t.muted),
      ),
    );
  }
}

class NodeLaneSearchField extends StatelessWidget {
  const NodeLaneSearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.clearLabel,
    this.onSubmitted,
    this.enabled = true,
  });
  final TextEditingController controller;
  final String hint;
  final String? clearLabel;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    return TextField(
      enabled: enabled,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted ?? (_) => FocusScope.of(context).unfocus(),
      textInputAction: TextInputAction.search,
      style: colors.body,
      decoration: colors.searchDecoration(
        hint,
        prefixIcon: Icon(
          icons.search,
          size: NodeLaneTokens.smallIconSize,
          color: colors.muted,
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip:
                      clearLabel ??
                      MaterialLocalizations.of(context).deleteButtonTooltip,
                  icon: Icon(
                    icons.clear,
                    size: NodeLaneTokens.smallIconSize,
                    color: colors.muted,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
      ),
    );
  }
}

/// A navigation affordance styled like search, without a fake editable field.
class NodeLaneSearchLink extends StatelessWidget {
  const NodeLaneSearchLink({
    super.key,
    required this.hint,
    required this.onTap,
  });
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Semantics(
      button: true,
      child: Material(
        color: colors.soft,
        borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: NodeLaneTokens.searchHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NodeLaneTokens.space12,
              ),
              child: Row(
                children: [
                  Icon(
                    NodeLaneIcons.of(context).search,
                    size: NodeLaneTokens.smallIconSize,
                    color: colors.muted,
                  ),
                  const SizedBox(width: NodeLaneTokens.space12),
                  Expanded(
                    child: Text(
                      hint,
                      style: colors.body.copyWith(color: colors.muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One visual and selection contract for page sections and filter choices.
class NodeLaneSegments<T> extends StatelessWidget {
  const NodeLaneSegments({
    super.key,
    required this.value,
    required this.segments,
    required this.onChanged,
    this.compact = false,
    this.prominent = false,
    this.pill = false,
    this.labelStyle,
  });
  final T value;
  final bool compact, prominent, pill;
  final TextStyle? labelStyle;
  final List<ButtonSegment<T>> segments;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: prominent
            ? colors.accentSoft
            : compact
            ? colors.detailChipSurface
            : colors.soft,
        borderRadius: BorderRadius.circular(
          prominent || pill ? 22 : NodeLaneTokens.controlRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          compact || prominent || pill ? 0 : NodeLaneTokens.segmentInset,
        ),
        child: Row(
          children: [
            for (final segment in segments)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: segment.value == value,
                  enabled: onChanged != null && segment.enabled,
                  inMutuallyExclusiveGroup: true,
                  child: Material(
                    color: segment.value == value
                        ? colors.accent
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      prominent || pill ? 20 : NodeLaneTokens.segmentRadius,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onChanged == null || !segment.enabled
                          ? null
                          : () {
                              if (segment.value != value) {
                                onChanged!(segment.value);
                              }
                            },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: prominent
                              ? 48
                              : NodeLaneTokens.minTapTarget,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: NodeLaneTokens.space4,
                            vertical: NodeLaneTokens.space8,
                          ),
                          child: IconTheme(
                            data: IconThemeData(
                              size: 18,
                              color: segment.value == value
                                  ? colors.onAccent
                                  : prominent
                                  ? colors.accent
                                  : colors.muted,
                            ),
                            child: DefaultTextStyle(
                              style: (labelStyle ?? colors.label).copyWith(
                                fontWeight: prominent
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: segment.value == value
                                    ? colors.onAccent
                                    : prominent
                                    ? colors.accent
                                    : colors.muted,
                              ),
                              textAlign: TextAlign.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (segment.icon != null) ...[
                                    segment.icon!,
                                    const SizedBox(
                                      width: NodeLaneTokens.space4,
                                    ),
                                  ],
                                  if (segment.label != null)
                                    Flexible(child: segment.label!),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Keeps the existing TabController and TabBarView/page storage intact.
class NodeLaneTabSegments extends StatelessWidget {
  const NodeLaneTabSegments({
    super.key,
    required this.labels,
    this.prominent = false,
    this.labelStyle,
  });
  final List<String> labels;
  final bool prominent;
  final TextStyle? labelStyle;
  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => NodeLaneSegments<int>(
        value: controller.index,
        prominent: prominent,
        labelStyle: labelStyle,
        segments: [
          for (var i = 0; i < labels.length; i++)
            ButtonSegment(value: i, label: Text(labels[i])),
        ],
        onChanged: controller.animateTo,
      ),
    );
  }
}

/// Inline at regular phone widths; stacks without shrinking text on short rows.
class NodeLaneChoiceRow<T> extends StatelessWidget {
  const NodeLaneChoiceRow({
    super.key,
    required this.title,
    required this.value,
    required this.segments,
    required this.onChanged,
    this.compact = false,
  });
  final String title;
  final bool compact;
  final T value;
  final List<ButtonSegment<T>> segments;
  final ValueChanged<T> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: compact
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : NodeLaneTokens.rowPadding,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final controls = NodeLaneSegments(
          value: value,
          compact: compact,
          segments: segments,
          onChanged: onChanged,
        );
        final label = Text(
          title,
          style: NodeLaneTokens.of(context).body
              .copyWith(fontWeight: compact ? FontWeight.w600 : null),
        );
        if (constraints.maxWidth < 290 ||
            MediaQuery.textScalerOf(context).scale(16) > 20) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              label,
              const SizedBox(height: NodeLaneTokens.space8),
              controls,
            ],
          );
        }
        return Row(
          children: [
            Expanded(flex: 2, child: label),
            const SizedBox(width: NodeLaneTokens.space12),
            Expanded(flex: 5, child: controls),
          ],
        );
      },
    ),
  );
}
