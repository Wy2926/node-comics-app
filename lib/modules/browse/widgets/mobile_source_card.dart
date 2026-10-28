import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Source identity and extension actions are supplied by the existing tiles.
/// Keeping actions below the title leaves room for long names and large text.
class MobileSourceCard extends StatelessWidget {
  const MobileSourceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.metadata,
    this.actions,
  });

  final String title;
  final Widget icon;
  final Widget? metadata, actions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colors.line),
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ExcludeSemantics(
                      child: SizedBox(width: 40, height: 40, child: icon),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colors.ink,
                            ),
                          ),
                          if (metadata != null) ...[
                            const SizedBox(height: 4),
                            DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.muted,
                              ),
                              child: metadata!,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: colors.muted,
                    ),
                  ],
                ),
              ),
            ),
            if (actions != null) ...[
              Divider(height: 1, color: colors.line),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                child: actions!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MobileBrowseSectionTitle extends StatelessWidget {
  const MobileBrowseSectionTitle(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
    child: Text(
      title,
      style: TextStyle(
        color: NodeLaneTokens.of(context).muted,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
