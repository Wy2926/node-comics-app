import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// Bar, that appears at the bottom of the screen when long-pressing (selecting)
/// a Manga/Anime/Novel or Chapter/Episode
class BottomSelectBar extends StatelessWidget {
  final bool isVisible;
  final List<BottomSelectButton> actions;
  final Color? backgroundColor;
  final bool respectSafeArea;

  const BottomSelectBar({
    super.key,
    required this.isVisible,
    required this.actions,
    this.backgroundColor,
    this.respectSafeArea = false,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = respectSafeArea
        ? MediaQuery.viewPaddingOf(context).bottom
        : 0.0;
    return IgnorePointer(
      ignoring: !isVisible,
      child: ExcludeSemantics(
        excluding: !isVisible,
        child: ClipRect(
          child: AnimatedContainer(
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  context.primaryColor.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            duration: const Duration(milliseconds: 100),
            height: isVisible ? 70 + bottom : 0,
            width: context.width(1),
            child: Padding(
              padding: EdgeInsets.only(bottom: isVisible ? bottom : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: actions,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Button for the BottomSelectBar
class BottomSelectButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final String? label;

  const BottomSelectButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 70,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: label == null
                ? null
                : const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          ),
          onPressed: onPressed,
          child: label != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon,
                    const SizedBox(height: 4),
                    Text(
                      label!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )
              : tooltip == null
              ? icon
              : Tooltip(message: tooltip!, child: icon),
        ),
      ),
    );
  }
}
