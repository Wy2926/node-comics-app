import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Layout only: the detail page supplies its existing cover and title actions.
class MobileDetailHeading extends StatelessWidget {
  const MobileDetailHeading({
    super.key,
    required this.cover,
    required this.title,
    required this.metadata,
  });

  final Widget cover, title, metadata;

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, const SizedBox(height: 8), metadata],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
        if (constraints.maxWidth < 280 || scale > 1.5) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [cover, const SizedBox(height: 16), text],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cover,
            const SizedBox(width: 16),
            Expanded(child: text),
          ],
        );
      },
    );
  }
}

class MobileDetailButton extends StatelessWidget {
  const MobileDetailButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: primary ? colors.accent : colors.soft,
        foregroundColor: primary ? colors.onAccent : colors.ink,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

/// Keeps the existing filter controls inside one bounded, scrollable sheet.
class MobileChapterFilterSheet extends StatelessWidget {
  const MobileChapterFilterSheet({
    super.key,
    required this.labels,
    required this.children,
    required this.closeLabel,
    required this.onClose,
  }) : assert(labels.length == children.length);

  final List<String> labels;
  final List<Widget> children;
  final String closeLabel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final tabHeight = (MediaQuery.textScalerOf(context).scale(14) + 24).clamp(
      48.0,
      double.infinity,
    );
    return NodeLaneSurface(
      child: DefaultTabController(
        length: labels.length,
        child: Builder(
          builder: (context) {
            final controller = DefaultTabController.of(context);
            return ListenableBuilder(
              listenable: controller,
              builder: (context, _) => SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            labelStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelColor: colors.muted,
                            dividerColor: Colors.transparent,
                            tabs: [
                              for (final label in labels)
                                Tab(text: label, height: tabHeight),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: closeLabel,
                          onPressed: onClose,
                          icon: const Icon(Icons.close),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                    Divider(height: 1, color: colors.line),
                    Flexible(
                      child: SingleChildScrollView(
                        key: PageStorageKey(controller.index),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: children[controller.index],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Chapter text and controls have separate hit targets; no repository work or
/// progress calculation belongs in this view.
class MobileChapterTile extends StatelessWidget {
  const MobileChapterTile({
    super.key,
    required this.title,
    required this.metadata,
    required this.read,
    required this.bookmarked,
    required this.selecting,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    this.description,
    this.thumbnail,
    this.trailing,
  });

  final String title, metadata;
  final String? description;
  final bool read, bookmarked, selecting, selected;
  final VoidCallback onTap, onLongPress;
  final Widget? thumbnail, trailing;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Semantics(
      selected: selecting ? selected : null,
      child: Material(
        color: selected ? colors.accentSoft : colors.surface,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          onSecondaryTap: onLongPress,
          child: Container(
            constraints: const BoxConstraints(minHeight: 76),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.line)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExcludeSemantics(
                  child: Icon(
                    selecting
                        ? selected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked
                        : bookmarked
                        ? Icons.bookmark_rounded
                        : read
                        ? Icons.check_rounded
                        : Icons.circle,
                    size: selecting || bookmarked || read ? 20 : 8,
                    color: read && !selected && !bookmarked
                        ? colors.muted
                        : colors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                if (thumbnail != null) ...[
                  thumbnail!,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: read ? FontWeight.w400 : FontWeight.w600,
                          color: read ? colors.muted : colors.ink,
                        ),
                      ),
                      if (description?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 4),
                        Text(
                          description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: colors.muted),
                        ),
                      ],
                      if (metadata.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          metadata,
                          style: TextStyle(fontSize: 12, color: colors.muted),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
