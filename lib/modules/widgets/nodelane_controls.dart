import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'
    show CupertinoPicker, CupertinoPickerDefaultSelectionOverlay;
import 'package:mangayomi/modules/widgets/nodelane_glass_surface.dart';
import 'package:mangayomi/modules/widgets/nodelane_reveal.dart';
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
    this.child,
    this.children,
    this.margin,
    this.outlined = false,
    this.first = true,
    this.last = true,
    this.selected = false,
  }) : assert((child == null) != (children == null));
  final Widget? child;
  final List<Widget>? children;
  final EdgeInsetsGeometry? margin;
  final bool outlined;
  final bool first, last, selected;
  @override
  Widget build(BuildContext context) => Padding(
    padding: margin ?? EdgeInsets.zero,
    child: Material(
      color: selected
          ? NodeLaneTokens.of(context).accentSoft
          : NodeLaneTokens.of(context).surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: first
              ? const Radius.circular(NodeLaneTokens.groupRadius)
              : Radius.zero,
          bottom: last
              ? const Radius.circular(NodeLaneTokens.groupRadius)
              : Radius.zero,
        ),
        side: outlined
            ? BorderSide(
                color: selected
                    ? NodeLaneTokens.of(context).accent
                    : NodeLaneTokens.of(context).line,
              )
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child:
          child ??
          Column(
            children: [
              for (var i = 0; i < children!.length; i++) ...[
                if (i > 0) const NodeLaneGroupDivider(),
                children![i],
              ],
            ],
          ),
    ),
  );
}

class NodeLaneGroupDivider extends StatelessWidget {
  const NodeLaneGroupDivider({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: NodeLaneTokens.space16),
    child: Divider(
      height: 1,
      thickness: .5,
      color: NodeLaneTokens.of(context).line,
    ),
  );
}

/// One row for settings, choices and card actions. Card edges are supplied by
/// lazy list callers; the content and tap behavior are shared with grouped rows.
class NodeLaneRow extends StatelessWidget {
  const NodeLaneRow({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleMaxLines,
    this.value,
    this.valueLeading,
    this.icon,
    this.leading,
    this.leadingSize = const Size.square(NodeLaneTokens.websiteIconSize),
    this.minHeight,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected,
    this.destructive = false,
    this.compact = false,
    this.prominent = false,
    this.accented = false,
    this.checkable = false,
    this.enabled = true,
    this.openOnReveal = false,
  }) : assert(icon == null || leading == null),
       _card = false,
       first = true,
       last = true;

  const NodeLaneRow.card({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleMaxLines,
    this.value,
    this.valueLeading,
    this.icon,
    this.leading,
    this.leadingSize = const Size.square(NodeLaneTokens.websiteIconSize),
    this.minHeight,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected,
    this.destructive = false,
    this.compact = false,
    this.prominent = false,
    this.accented = false,
    this.checkable = false,
    this.enabled = true,
    this.openOnReveal = false,
    this.first = true,
    this.last = true,
  }) : assert(icon == null || leading == null),
       _card = true;

  final String title;

  /// Supporting explanation; current selections belong in [value].
  final String? subtitle;

  /// Current selection, aligned to the trailing side of the title.
  final String? value;
  final int? subtitleMaxLines;
  final IconData? icon;
  final Size leadingSize;
  final double? minHeight;
  final Widget? leading, trailing, valueLeading;
  final VoidCallback? onTap, onLongPress;
  final bool? selected;
  final bool destructive, checkable, enabled, first, last, _card;
  final bool compact, prominent, accented;

  /// Opt in only for navigation and opening a picker, never preference writes.
  final bool openOnReveal;

  @override
  Widget build(BuildContext context) {
    NodeLaneRevealScope.reveal(
      context,
      title,
      open: openOnReveal && enabled && !destructive ? onTap : null,
    );
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final color = !enabled
        ? t.muted.withValues(alpha: .5)
        : destructive
        ? Theme.of(context).colorScheme.error
        : accented
        ? t.accent
        : t.ink;
    final content = InkWell(
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  minHeight ??
                  (compact
                      ? NodeLaneTokens.minTapTarget
                      : _card
                      ? NodeLaneTokens.catalogRowHeight
                      : NodeLaneTokens.rowHeight),
            ),
            child: Padding(
              padding: NodeLaneTokens.rowPadding,
              child: Row(
                children: [
                  if (leading != null || icon != null) ...[
                    if (leading != null)
                      SizedBox.fromSize(
                        size: leadingSize,
                        child: ExcludeSemantics(
                          child: IconTheme(
                            data: IconThemeData(
                              size: NodeLaneTokens.iconSize,
                              color: color,
                            ),
                            child: Center(child: leading!),
                          ),
                        ),
                      )
                    else
                      Icon(icon, size: NodeLaneTokens.iconSize, color: color),
                    const SizedBox(width: NodeLaneTokens.space12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _NodeLaneLabelValue(
                          title: title,
                          titleStyle:
                              (prominent ? t.readerTitle : t.readerLabel)
                                  .copyWith(color: color),
                          value: value,
                          valueLeading: valueLeading,
                        ),
                        if (subtitle?.isNotEmpty == true) ...[
                          const SizedBox(height: NodeLaneTokens.space4),
                          Text(
                            subtitle!,
                            style: t.readerSecondary,
                            maxLines: subtitleMaxLines,
                            overflow: subtitleMaxLines == null
                                ? null
                                : TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: NodeLaneTokens.space12),
                    trailing!,
                  ] else if (checkable) ...[
                    const SizedBox(width: NodeLaneTokens.space12),
                    Icon(
                      selected == true ? icons.selected : icons.unselected,
                      color: selected == true ? t.accent : t.muted,
                      size: NodeLaneTokens.iconSize,
                    ),
                  ] else if (!_card && selected != null) ...[
                    const SizedBox(width: NodeLaneTokens.space12),
                    SizedBox(
                      width: NodeLaneTokens.iconSize,
                      child: selected!
                          ? Icon(
                              icons.check,
                              size: NodeLaneTokens.iconSize,
                              color: t.accent,
                            )
                          : null,
                    ),
                  ] else if (onTap != null && !destructive) ...[
                    const SizedBox(width: NodeLaneTokens.space12),
                    Icon(
                      icons.forward,
                      size: NodeLaneTokens.smallIconSize,
                      color: t.muted,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_card && !last) const NodeLaneGroupDivider(),
        ],
      ),
    );
    return Semantics(
      container: true,
      selected: checkable ? null : selected,
      checked: checkable ? selected == true : null,
      button: onTap != null || !enabled,
      enabled: onTap != null || !enabled || checkable ? enabled : null,
      child: _card
          ? NodeLaneGroupSurface(
              first: first,
              last: last,
              selected: selected == true,
              child: content,
            )
          : content,
    );
  }
}

/// The same label/value alignment for choice rows and slider headers.
class _NodeLaneLabelValue extends StatelessWidget {
  const _NodeLaneLabelValue({
    required this.title,
    required this.titleStyle,
    this.value,
    this.valueLeading,
  });
  final String title;
  final TextStyle titleStyle;
  final String? value;
  final Widget? valueLeading;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(title, style: titleStyle)),
      if (valueLeading != null) ...[
        const SizedBox(width: NodeLaneTokens.space12),
        valueLeading!,
      ],
      if (value != null) ...[
        const SizedBox(width: NodeLaneTokens.space12),
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            value!,
            style: NodeLaneTokens.of(context).readerValue,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ],
  );
}

enum NodeLaneBadgeTone { overlay, accent, softAccent, neutral, soft }

/// One annotation geometry for covers and compact status information.
class NodeLaneCoverBadge extends StatelessWidget {
  const NodeLaneCoverBadge(
    this.label, {
    super.key,
    this.icon,
    this.semanticsLabel,
    this.tone = NodeLaneBadgeTone.overlay,
  });
  final String label;
  final IconData? icon;
  final String? semanticsLabel;
  final NodeLaneBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final foreground = switch (tone) {
      NodeLaneBadgeTone.overlay => Colors.white,
      NodeLaneBadgeTone.accent => t.onAccent,
      NodeLaneBadgeTone.softAccent => t.accent,
      NodeLaneBadgeTone.neutral || NodeLaneBadgeTone.soft => t.ink,
    };
    return Semantics(
      label: semanticsLabel,
      excludeSemantics: semanticsLabel != null,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: NodeLaneTokens.badgeHeight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: NodeLaneTokens.space8),
        decoration: BoxDecoration(
          color: switch (tone) {
            NodeLaneBadgeTone.overlay => t.ink.withValues(alpha: .78),
            NodeLaneBadgeTone.accent => t.accent,
            NodeLaneBadgeTone.softAccent => t.accentSoft,
            NodeLaneBadgeTone.neutral => t.surface,
            NodeLaneBadgeTone.soft => t.soft,
          },
          borderRadius: BorderRadius.circular(NodeLaneTokens.capsuleRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: NodeLaneTokens.badgeIconSize, color: foreground),
              if (label.isNotEmpty)
                const SizedBox(width: NodeLaneTokens.space4),
            ],
            if (label.isNotEmpty)
              Text(
                label,
                style: t.caption.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A visual choice uses the same grouped surface and selection roles as rows.
class NodeLaneChoiceCard extends StatelessWidget {
  const NodeLaneChoiceCard({
    super.key,
    required this.title,
    required this.preview,
    required this.selected,
    required this.onTap,
  });
  final String title;
  final Widget preview;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: NodeLaneGroupSurface(
      outlined: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: NodeLaneTokens.groupPadding,
          child: Column(
            children: [
              ExcludeSemantics(
                child: SizedBox(
                  height: NodeLaneTokens.choicePreviewHeight,
                  child: preview,
                ),
              ),
              const SizedBox(height: NodeLaneTokens.space8),
              Row(
                children: [
                  Expanded(
                    child: Text(title, style: NodeLaneTokens.of(context).label),
                  ),
                  const SizedBox(width: NodeLaneTokens.space4),
                  SizedBox.square(
                    dimension: NodeLaneTokens.smallIconSize,
                    child: selected
                        ? Icon(
                            NodeLaneIcons.of(context).selected,
                            size: NodeLaneTokens.smallIconSize,
                            color: NodeLaneTokens.of(context).accent,
                          )
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class NodeLaneSecondaryButton extends StatelessWidget {
  const NodeLaneSecondaryButton({
    super.key,
    required this.child,
    this.onPressed,
    this.icon,
  });
  final Widget child;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final style = FilledButton.styleFrom(
      backgroundColor: t.soft,
      foregroundColor: t.ink,
      iconColor: t.ink,
    );
    if (icon != null) {
      return FilledButton.icon(
        style: style,
        onPressed: onPressed,
        icon: Icon(icon, size: NodeLaneTokens.iconSize),
        label: child,
      );
    }
    return FilledButton(style: style, onPressed: onPressed, child: child);
  }
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

/// A switch is the same row as other controls, including its full-row target.
class NodeLaneSwitchRow extends StatelessWidget {
  const NodeLaneSwitchRow({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
  });
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: NodeLaneRow(
      title: title,
      subtitle: subtitle,
      icon: icon,
      enabled: onChanged != null,
      onTap: onChanged == null ? null : () => onChanged!(!value),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: NodeLaneTokens.of(context).accent,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
    ),
  );
}

/// Collapsed optional settings keep their values; only presentation is owned here.
class NodeLaneDisclosure extends StatefulWidget {
  const NodeLaneDisclosure({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.expandedTitle,
    this.icon,
    this.compact = false,
    this.initiallyExpanded = false,
    this.minHeight,
  });
  final String title;
  final String? subtitle;
  final String? expandedTitle;
  final IconData? icon;
  final Widget child;
  final bool initiallyExpanded;
  final bool compact;
  final double? minHeight;
  @override
  State<NodeLaneDisclosure> createState() => _NodeLaneDisclosureState();
}

class _NodeLaneDisclosureState extends State<NodeLaneDisclosure> {
  late final _controller = ExpansibleController();
  // Descendant scrollables must not read Expansible's boolean as an offset.
  final _bodyStorage = PageStorageBucket();
  bool _revealed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_revealed && NodeLaneRevealScope.expands(context, widget.title)) {
      _revealed = true;
      _controller.expand();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initiallyExpanded) _controller.expand();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NodeLaneGroupSurface(
    child: Expansible(
      key: PageStorageKey(widget.key ?? widget.title),
      controller: _controller,
      maintainState: false,
      animationStyle: MediaQuery.disableAnimationsOf(context)
          ? AnimationStyle.noAnimation
          : const AnimationStyle(
              duration: NodeLaneTokens.disclosureDuration,
              curve: Curves.easeInOut,
            ),
      headerBuilder: (context, animation) => Semantics(
        expanded: _controller.isExpanded,
        child: NodeLaneRow(
          title: _controller.isExpanded
              ? widget.expandedTitle ?? widget.title
              : widget.title,
          subtitle: widget.subtitle,
          compact: widget.compact,
          minHeight: widget.minHeight,
          icon: widget.icon,
          onTap: () => _controller.isExpanded
              ? _controller.collapse()
              : _controller.expand(),
          trailing: RotationTransition(
            turns: animation.drive(Tween(begin: 0.0, end: .5)),
            child: Icon(
              NodeLaneIcons.of(context).down,
              size: NodeLaneTokens.smallIconSize,
              color: NodeLaneTokens.of(context).muted,
            ),
          ),
        ),
      ),
      bodyBuilder: (context, animation) => PageStorage(
        bucket: _bodyStorage,
        child: Column(children: [const NodeLaneGroupDivider(), widget.child]),
      ),
    ),
  );
}

/// The existing setting row opens a compact wheel anchored to its value.
class NodeLaneNumberRow extends StatelessWidget {
  const NodeLaneNumberRow({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
    this.label,
    this.valueLabel,
    this.subtitle,
    this.icon,
    this.enabled = true,
  }) : assert(min <= max),
       assert(step > 0);
  final String title;
  final int value, min, max, step;
  final ValueChanged<int> onChanged;
  final String Function(int)? label;
  final String? valueLabel, subtitle;
  final IconData? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) => NodeLaneNumberPicker(
    value: value,
    min: min,
    max: max,
    step: step,
    label: label,
    enabled: enabled,
    onChanged: onChanged,
    builder: (context, toggle, isOpen) => NodeLaneRow(
      title: title,
      subtitle: subtitle,
      value: valueLabel ?? label?.call(value) ?? '$value',
      icon: icon,
      enabled: enabled,
      openOnReveal: true,
      onTap: toggle,
      trailing: Icon(
        NodeLaneIcons.of(context).down,
        size: NodeLaneTokens.smallIconSize,
        color: NodeLaneTokens.of(context).muted,
      ),
    ),
  );
}

/// One anchored picker for settings rows and reader/player toolbar actions.
/// It never changes the page layout or pushes a modal route.
class NodeLaneNumberPicker extends StatefulWidget {
  const NodeLaneNumberPicker({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.builder,
    this.controller,
    this.onClose,
    this.step = 1,
    this.label,
    this.enabled = true,
  }) : assert(min <= max),
       assert(step > 0);
  final int value, min, max, step;
  final ValueChanged<int> onChanged;
  final String Function(int)? label;
  final bool enabled;
  final Widget Function(BuildContext, VoidCallback?, bool) builder;
  final MenuController? controller;
  final VoidCallback? onClose;

  @override
  State<NodeLaneNumberPicker> createState() => _NodeLaneNumberPickerState();
}

class _NodeLaneNumberPickerState extends State<NodeLaneNumberPicker> {
  final _menu = MenuController();

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final width =
        (NodeLaneTokens.numberPickerWidth *
                (MediaQuery.textScalerOf(context).scale(17) / 17).clamp(1, 1.5))
            .clamp(
              0.0,
              MediaQuery.sizeOf(context).width - NodeLaneTokens.gutter * 2,
            );
    return MenuAnchor(
      controller: widget.controller ?? _menu,
      onClose: widget.onClose,
      consumeOutsideTap: true,
      animated: !MediaQuery.disableAnimationsOf(context),
      clipBehavior: Clip.none,
      alignmentOffset: Offset(-width, NodeLaneTokens.space8),
      reservedPadding: const EdgeInsets.all(NodeLaneTokens.space8),
      style: const MenuStyle(
        alignment: AlignmentDirectional.bottomEnd,
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        elevation: WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        side: WidgetStatePropertyAll(BorderSide.none),
      ),
      menuChildren: [
        SizedBox(
          width: width,
          child: NodeLaneGlassSurface(
            borderRadius: t.inputRadius,
            elevated: true,
            child: _NodeLaneNumberWheel(
              value: widget.value,
              min: widget.min,
              max: widget.max,
              step: widget.step,
              label: widget.label,
              enabled: widget.enabled,
              onChanged: widget.onChanged,
            ),
          ),
        ),
      ],
      builder: (context, controller, _) => widget.builder(
        context,
        widget.enabled
            ? () => controller.isOpen ? controller.close() : controller.open()
            : null,
        controller.isOpen,
      ),
    );
  }
}

/// Lazy wheel. Report only the settled item, not every frame of a fling.
class _NodeLaneNumberWheel extends StatefulWidget {
  const _NodeLaneNumberWheel({
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
    required this.enabled,
    this.label,
  });
  final int value, min, max, step;
  final ValueChanged<int> onChanged;
  final String Function(int)? label;
  final bool enabled;

  @override
  State<_NodeLaneNumberWheel> createState() => _NodeLaneNumberWheelState();
}

class _NodeLaneNumberWheelState extends State<_NodeLaneNumberWheel> {
  int get _count => (widget.max - widget.min) ~/ widget.step + 1;
  int get _index =>
      ((widget.value - widget.min) ~/ widget.step).clamp(0, _count - 1);
  // The popover shares the route's PageStorage with its anchor's list.
  // Reopen from the setting value, never from a page/list scroll offset.
  late final _scroll = FixedExtentScrollController(
    initialItem: _index,
    keepScrollOffset: false,
  );

  @override
  void didUpdateWidget(covariant _NodeLaneNumberWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.min != widget.min ||
        oldWidget.max != widget.max ||
        oldWidget.step != widget.step) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scroll.hasClients && _scroll.selectedItem != _index) {
          _scroll.jumpToItem(_index);
        }
      });
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final scaled = MediaQuery.textScalerOf(context).scale(17);
    final extent = scaled * 1.5 > NodeLaneTokens.minTapTarget
        ? scaled * 1.5
        : NodeLaneTokens.minTapTarget;
    return Padding(
      padding: const EdgeInsets.all(NodeLaneTokens.space12),
      child: SizedBox(
        height: extent * 3,
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: CupertinoPicker.builder(
            scrollController: _scroll,
            itemExtent: extent,
            childCount: _count,
            changeReportingBehavior: ChangeReportingBehavior.onScrollEnd,
            selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: t.accent.withValues(alpha: .12),
            ),
            onSelectedItemChanged: (index) {
              final value = widget.min + index * widget.step;
              if (widget.enabled && value != widget.value) {
                widget.onChanged(value);
              }
            },
            itemBuilder: (context, index) {
              final value = widget.min + index * widget.step;
              return Center(
                child: Text(
                  widget.label?.call(value) ?? '$value',
                  style: t.readerLabel.copyWith(
                    color: widget.enabled ? t.ink : t.muted,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Pins existing content without duplicating its controller, focus or layout.
/// PinnedHeaderSliver measures the child, including accessibility text scaling.
class NodeLanePinnedHeader extends StatelessWidget {
  const NodeLanePinnedHeader({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => PinnedHeaderSliver(
    child: Padding(padding: NodeLaneTokens.headerPadding, child: child),
  );
}

/// Shared slider presentation and local drag draft. A gesture commits once;
/// callers may opt into live preview without moving persistence into the view.
class NodeLaneSliderRow extends StatefulWidget {
  const NodeLaneSliderRow({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.label,
    this.subtitle,
    this.divisions,
    this.onPreview,
    this.enabled = true,
  });
  final String title;
  final bool enabled;
  final String? subtitle;
  final double value, min, max;
  final int? divisions;
  final String Function(double)? label;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onPreview;
  @override
  State<NodeLaneSliderRow> createState() => _NodeLaneSliderRowState();
}

class _NodeLaneSliderRowState extends State<NodeLaneSliderRow> {
  late double _draft = widget.value.clamp(widget.min, widget.max);
  @override
  void didUpdateWidget(covariant NodeLaneSliderRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.min != widget.min ||
        oldWidget.max != widget.max) {
      _draft = widget.value.clamp(widget.min, widget.max);
    }
  }

  @override
  Widget build(BuildContext context) {
    NodeLaneRevealScope.reveal(context, widget.title);
    final t = NodeLaneTokens.of(context);
    final valueLabel = widget.label?.call(_draft) ?? _draft.round().toString();
    return Padding(
      padding: NodeLaneTokens.groupPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NodeLaneLabelValue(
            title: widget.title,
            titleStyle: t.readerLabel,
            value: valueLabel,
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: NodeLaneTokens.space4),
            Text(widget.subtitle!, style: t.readerSecondary),
          ],
          Slider.adaptive(
            value: _draft,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            label: valueLabel,
            semanticFormatterCallback: (_) => valueLabel,
            onChanged: !widget.enabled
                ? null
                : (value) {
                    setState(() => _draft = value);
                    widget.onPreview?.call(value);
                  },
            onChangeEnd: !widget.enabled
                ? null
                : (value) {
                    if (value != widget.value || widget.onPreview != null) {
                      widget.onChanged(value);
                    }
                  },
          ),
        ],
      ),
    );
  }
}

AppBar nodeLaneAppBar(
  BuildContext context, {
  required String title,
  List<Widget> actions = const [],
  bool busy = false,
  VoidCallback? onBack,
  TextStyle? titleStyle,
  String? semanticTitle,
}) => AppBar(
  title: Text(
    title,
    semanticsLabel: semanticTitle,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
  titleTextStyle: titleStyle ?? NodeLaneTokens.of(context).readerTitle,
  centerTitle: true,
  toolbarHeight: (MediaQuery.textScalerOf(context).scale(22) * 1.3 + 16).clamp(
    kToolbarHeight,
    double.infinity,
  ),
  automaticallyImplyLeading: false,
  leadingWidth: 64,
  leading: onBack != null || Navigator.of(context).canPop()
      ? Padding(
          padding: const EdgeInsets.only(left: NodeLaneTokens.space20),
          child: NodeLaneIconButton(
            icon: NodeLaneIcons.of(context).back,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: busy
                ? null
                : onBack ?? () => Navigator.maybePop(context),
          ),
        )
      : null,
  actions: [
    ...actions,
    if (actions.isNotEmpty) const SizedBox(width: NodeLaneTokens.space20),
  ],
  bottom: busy
      ? const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: LinearProgressIndicator(minHeight: 2),
        )
      : null,
);

enum NodeLaneIconButtonStyle { plain, tonal, field }

class NodeLaneIconButton extends StatelessWidget {
  const NodeLaneIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.style = NodeLaneIconButtonStyle.tonal,
    this.active = false,
    this.destructive = false,
    this.busy = false,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final NodeLaneIconButtonStyle style;
  final bool active, destructive, busy;

  @override
  Widget build(BuildContext context) {
    return _iconButtonSurface(
      context,
      style: style,
      child: IconButton(
        tooltip: tooltip,
        onPressed: busy ? null : onPressed,
        icon: busy
            ? SizedBox.square(
                dimension: NodeLaneTokens.smallIconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  semanticsLabel: tooltip,
                ),
              )
            : Icon(icon, size: NodeLaneTokens.iconSize),
        style: _iconButtonStyle(
          context,
          style: style,
          active: active,
          destructive: destructive,
        ),
      ),
    );
  }
}

/// A menu trigger uses the same geometry and material as a toolbar action.
class NodeLaneMenuButton<T> extends StatelessWidget {
  const NodeLaneMenuButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.itemBuilder,
    required this.onSelected,
    this.enabled = true,
  }) : label = null;

  const NodeLaneMenuButton.label({
    super.key,
    required this.label,
    required this.tooltip,
    required this.itemBuilder,
    required this.onSelected,
    this.enabled = true,
  }) : icon = null;

  final IconData? icon;
  final String? label;
  final String tooltip;
  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      final t = NodeLaneTokens.of(context);
      return PopupMenuButton<T>(
        enabled: enabled,
        tooltip: tooltip,
        itemBuilder: itemBuilder,
        onSelected: onSelected,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: NodeLaneTokens.minTapTarget,
            minHeight: NodeLaneTokens.minTapTarget,
          ),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Container(
              constraints: const BoxConstraints(
                minHeight: NodeLaneTokens.tagHeight,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: NodeLaneTokens.space12,
                vertical: NodeLaneTokens.space4,
              ),
              decoration: BoxDecoration(
                color: t.soft,
                borderRadius: t.inputRadius,
              ),
              child: Text(label!, style: t.readerValue),
            ),
          ),
        ),
      );
    }
    return _iconButtonSurface(
      context,
      style: NodeLaneIconButtonStyle.tonal,
      child: PopupMenuButton<T>(
        enabled: enabled,
        tooltip: tooltip,
        icon: Icon(icon, size: NodeLaneTokens.iconSize),
        style: _iconButtonStyle(context),
        itemBuilder: itemBuilder,
        onSelected: onSelected,
      ),
    );
  }
}

ButtonStyle _iconButtonStyle(
  BuildContext context, {
  NodeLaneIconButtonStyle style = NodeLaneIconButtonStyle.tonal,
  bool active = false,
  bool destructive = false,
}) {
  final t = NodeLaneTokens.of(context);
  final glass = t.usesGlass && style != NodeLaneIconButtonStyle.plain;
  return IconButton.styleFrom(
    minimumSize: const Size.square(NodeLaneTokens.minTapTarget),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    foregroundColor: destructive
        ? Theme.of(context).colorScheme.error
        : active
        ? t.accent
        : t.ink,
    backgroundColor: glass
        ? Colors.transparent
        : switch (style) {
            NodeLaneIconButtonStyle.plain => Colors.transparent,
            NodeLaneIconButtonStyle.tonal => t.accentSoft,
            NodeLaneIconButtonStyle.field => active ? t.accentSoft : t.soft,
          },
    shape: style == NodeLaneIconButtonStyle.field && !glass
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
          )
        : const CircleBorder(),
  );
}

Widget _iconButtonSurface(
  BuildContext context, {
  required NodeLaneIconButtonStyle style,
  required Widget child,
}) => Center(
  widthFactor: 1,
  heightFactor: 1,
  child: SizedBox.square(
    dimension: NodeLaneTokens.minTapTarget,
    child:
        NodeLaneTokens.of(context).usesGlass &&
            style != NodeLaneIconButtonStyle.plain
        ? NodeLaneGlassSurface(
            borderRadius: BorderRadius.circular(NodeLaneTokens.capsuleRadius),
            elevated: true,
            child: child,
          )
        : child,
  ),
);

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
        child: Icon(
          NodeLaneIcons.of(context).close,
          size: NodeLaneTokens.smallIconSize,
          color: t.ink,
        ),
      ),
    );
  }
}

/// A single input implementation. Search only changes keyboard and leading
/// affordance; callers own drafts, submission and clearing side effects.
class NodeLaneTextField extends StatefulWidget {
  const NodeLaneTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint = '',
    this.onChanged,
    this.onClear,
    this.clearLabel,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.keyboardType,
    this.textInputAction,
    this.minLines = 1,
    this.maxLines = 1,
    this.code = false,
    this.focusNode,
    this.autofillHints,
    this.obscureText = false,
    this.trailing,
    this.validator,
  }) : assert(controller == null || initialValue == null),
       _search = false;

  const NodeLaneTextField.search({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.onClear,
    this.clearLabel,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
  }) : validator = null,
       focusNode = null,
       autofillHints = null,
       obscureText = false,
       trailing = null,
       code = false,
       initialValue = null,
       label = null,
       autocorrect = true,
       enableSuggestions = true,
       keyboardType = TextInputType.text,
       textInputAction = TextInputAction.search,
       minLines = 1,
       maxLines = 1,
       _search = true;

  final TextEditingController? controller;
  final String? initialValue, label, clearLabel;
  final String hint;
  final ValueChanged<String>? onChanged, onSubmitted;
  final VoidCallback? onClear;
  final bool enabled, autofocus, autocorrect, enableSuggestions, _search;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int minLines;
  final int? maxLines;
  final bool code, obscureText;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final Widget? trailing;
  final FormFieldValidator<String>? validator;

  @override
  State<NodeLaneTextField> createState() => _NodeLaneTextFieldState();

  Widget _build(BuildContext context, FocusNode inputFocus) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final field = TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: inputFocus,
      obscureText: obscureText,
      autofillHints: autofillHints,
      enabled: enabled,
      autofocus: autofocus,
      autocorrect: !code && autocorrect,
      enableSuggestions: !code && enableSuggestions,
      smartDashesType: code || !autocorrect ? SmartDashesType.disabled : null,
      smartQuotesType: code || !autocorrect ? SmartQuotesType.disabled : null,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChanged,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      style: code
          ? t.readerSecondary.copyWith(fontFamily: 'monospace', color: t.ink)
          : t.body,
      decoration: t
          .inputDecoration(
            hint,
            prefixIcon: _search
                ? Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: NodeLaneTokens.space16,
                      end: NodeLaneTokens.space12,
                    ),
                    child: Icon(
                      icons.search,
                      size: NodeLaneTokens.smallIconSize,
                      color: t.muted,
                    ),
                  )
                : null,
            suffixIcon:
                trailing ??
                (controller == null
                    ? null
                    : ValueListenableBuilder<TextEditingValue>(
                        valueListenable: controller!,
                        builder: (context, value, _) => value.text.isEmpty
                            ? const SizedBox.shrink()
                            : IconButton(
                                tooltip:
                                    clearLabel ??
                                    MaterialLocalizations.of(context)
                                        .deleteButtonTooltip,
                                icon: Icon(
                                  icons.clear,
                                  size: NodeLaneTokens.smallIconSize,
                                  color: t.muted,
                                ),
                                onPressed: !enabled
                                    ? null
                                    : () {
                                        if (onClear != null) {
                                          onClear!();
                                        } else {
                                          controller!.clear();
                                          onChanged?.call('');
                                        }
                                      },
                              ),
                      )),
          )
          .copyWith(
            fillColor: t.usesGlass ? Colors.transparent : null,
            border: t.usesGlass ? InputBorder.none : null,
            enabledBorder: t.usesGlass ? InputBorder.none : null,
            focusedBorder: t.usesGlass ? InputBorder.none : null,
            disabledBorder: t.usesGlass ? InputBorder.none : null,
          ),
    );
    final input = t.usesGlass
        ? NodeLaneGlassSurface(
            borderRadius: t.inputRadius,
            input: true,
            elevated: true,
            child: field,
          )
        : field;
    if (label?.isNotEmpty != true) return input;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: NodeLaneTokens.space4,
            bottom: NodeLaneTokens.space8,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: enabled ? inputFocus.requestFocus : null,
            child: ExcludeSemantics(
              child: Text(
                label!,
                style: t.readerLabel.copyWith(color: enabled ? t.ink : t.muted),
              ),
            ),
          ),
        ),
        Semantics(label: label, child: input),
      ],
    );
  }
}

class _NodeLaneTextFieldState extends State<NodeLaneTextField> {
  FocusNode? _localFocus;

  @override
  void dispose() {
    _localFocus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget._build(context, widget.focusNode ?? (_localFocus ??= FocusNode()));
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
          colors.usesGlass
              ? NodeLaneTokens.capsuleRadius
              : prominent || pill
              ? 22
              : NodeLaneTokens.controlRadius,
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
                      colors.usesGlass
                          ? NodeLaneTokens.capsuleRadius -
                                NodeLaneTokens.segmentInset
                          : prominent || pill
                          ? 20
                          : NodeLaneTokens.segmentRadius,
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
        final style = NodeLaneTokens.of(context).body
            .copyWith(fontWeight: compact ? FontWeight.w600 : null);
        final label = Text(title, style: style);
        final titleLayout =
            TextPainter(
              text: TextSpan(text: title, style: style),
              textDirection: Directionality.of(context),
              textScaler: MediaQuery.textScalerOf(context),
              maxLines: 1,
            )..layout(
              maxWidth:
                  (constraints.maxWidth - NodeLaneTokens.space12).clamp(
                    0,
                    double.infinity,
                  ) *
                  2 /
                  7,
            );
        final needsTitleRow = titleLayout.didExceedMaxLines;
        titleLayout.dispose();
        if (constraints.maxWidth < 290 ||
            needsTitleRow ||
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

/// May be used as the child of a popup; without a callback it adds no competing
/// tap handler or disabled semantics to the popup's own target.
class NodeLaneToolbarAction extends StatelessWidget {
  const NodeLaneToolbarAction({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.active = false,
    this.enabled = true,
    this.destructive = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool active, enabled, destructive;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final color = !enabled
        ? colors.muted.withValues(alpha: .5)
        : destructive
        ? Theme.of(context).colorScheme.error
        : active
        ? colors.accent
        : colors.ink;
    final content = Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: NodeLaneTokens.readerActionHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: NodeLaneTokens.space4,
        vertical: NodeLaneTokens.space8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: NodeLaneTokens.readerIconSize),
          const SizedBox(height: NodeLaneTokens.space4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: NodeLaneTokens.captionSize,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
    return onPressed == null
        ? Semantics(enabled: enabled, child: content)
        : TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: enabled ? onPressed : null,
            child: content,
          );
  }
}
