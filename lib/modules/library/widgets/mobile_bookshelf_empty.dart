import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

class MobileBookshelfEmpty extends StatelessWidget {
  const MobileBookshelfEmpty({
    super.key,
    required this.title,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.filtered = false,
  });
  final String title, primaryLabel;
  final String? secondaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
            minWidth: constraints.maxWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.all(NodeLaneTokens.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  filtered
                      ? NodeLaneIcons.of(context).search
                      : NodeLaneIcons.of(context).manga,
                  size: 52,
                  color: colors.muted.withValues(alpha: .65),
                ),
                const SizedBox(height: NodeLaneTokens.space20),
                Text(title, textAlign: TextAlign.center, style: colors.body),
                const SizedBox(height: NodeLaneTokens.space20),
                FilledButton.icon(
                  onPressed: onPrimary,
                  icon: Icon(
                    filtered
                        ? NodeLaneIcons.of(context).filter
                        : NodeLaneIcons.of(context).add,
                  ),
                  label: Text(primaryLabel),
                ),
                if (secondaryLabel != null && onSecondary != null)
                  TextButton(
                    onPressed: onSecondary,
                    child: Text(secondaryLabel!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
