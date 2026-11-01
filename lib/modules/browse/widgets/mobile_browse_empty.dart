import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Non-scrolling content so sources and extensions retain their own scroll
/// controller, refresh gesture and bottom navigation insets.
class MobileBrowseEmpty extends StatelessWidget {
  const MobileBrowseEmpty({
    super.key,
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String title, actionLabel;
  final String? secondaryLabel;
  final VoidCallback onAction;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NodeLaneTokens.gutter,
        NodeLaneTokens.space8,
        NodeLaneTokens.gutter,
        NodeLaneTokens.space12,
      ),
      child: NodeLaneGroupSurface(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 260),
          child: Padding(
            padding: const EdgeInsets.all(NodeLaneTokens.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 52,
                  color: colors.muted.withValues(alpha: .65),
                ),
                const SizedBox(height: NodeLaneTokens.space20),
                Text(title, textAlign: TextAlign.center, style: colors.body),
                const SizedBox(height: NodeLaneTokens.space20),
                FilledButton(
                  onPressed: onAction,
                  child: Text(actionLabel, textAlign: TextAlign.center),
                ),
                if (secondaryLabel != null && onSecondary != null)
                  TextButton(
                    onPressed: onSecondary,
                    child: Text(secondaryLabel!, textAlign: TextAlign.center),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
