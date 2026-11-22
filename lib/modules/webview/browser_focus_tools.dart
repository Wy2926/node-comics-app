import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_glass_surface.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'mobile_browser_widgets.dart' show BrowserDisplayButton;

/// One reversible transition; the page receives touches as soon as dismissal starts.
class BrowserFocusOverlay extends StatelessWidget {
  const BrowserFocusOverlay({
    super.key,
    required this.visible,
    required this.onReveal,
    required this.child,
  });
  final bool visible;
  final VoidCallback onReveal;
  final Widget child;

  @override
  Widget build(BuildContext context) => SafeArea(
    minimum: const EdgeInsets.all(NodeLaneTokens.space12),
    child: Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        ignoring: !visible,
        child: ExcludeSemantics(
          excluding: !visible,
          child: FocusableActionDetector(
            includeFocusSemantics: false,
            descendantsAreFocusable: visible,
            descendantsAreTraversable: visible,
            onShowFocusHighlight: (show) {
              if (show) onReveal();
            },
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: visible ? 1 : 0),
              duration: NodeLaneMotion.time(context),
              curve: NodeLaneMotion.curve,
              builder: (_, t, panel) => t == 0
                  ? const SizedBox.shrink()
                  : Transform.translate(
                      offset: Offset(0, (1 - t) * NodeLaneTokens.space20),
                      child: Opacity(opacity: t, child: panel),
                    ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: NodeLaneTokens.bubbleToolWidth,
                ),
                child: RepaintBoundary(child: child),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class BrowserFocusTools extends StatelessWidget {
  const BrowserFocusTools({
    super.key,
    required this.onClose,
    required this.onExit,
    required this.onClip,
    required this.translated,
    required this.onDisplay,
    this.onNext,
  });
  final bool translated;
  final VoidCallback onExit, onClose;
  final VoidCallback? onClip, onNext;
  final ValueChanged<bool> onDisplay;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    Widget action(String label, IconData icon, VoidCallback? run) =>
        NodeLaneIconButton(
          tooltip: label,
          icon: icon,
          style: NodeLaneIconButtonStyle.plain,
          onPressed: run == null
              ? null
              : () {
                  onClose();
                  run();
                },
        );
    final actions = [
      action(l.browser_clip_here, icons.bookmarkOutline, onClip),
      if (onNext != null)
        action(l.browser_next_chapter, icons.nextChapter, onNext),
      action(l.browser_exit_focus, icons.signOut, onExit),
      NodeLaneCloseButton(
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        onPressed: onClose,
      ),
    ];
    return NodeLaneGlassSurface(
      grouped: true,
      elevated: true,
      borderRadius: BorderRadius.circular(NodeLaneTokens.capsuleRadius),
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: l.browser_focus,
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(NodeLaneTokens.space4),
          child: LayoutBuilder(
            builder: (_, constraints) => Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: NodeLaneTokens.space4,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: math.max(
                      NodeLaneTokens.minTapTarget,
                      constraints.maxWidth -
                          actions.length *
                              (NodeLaneTokens.minTapTarget +
                                  NodeLaneTokens.space4),
                    ),
                  ),
                  child: BrowserDisplayButton(
                    translated: translated,
                    onChanged: onDisplay,
                  ),
                ),
                ...actions,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
