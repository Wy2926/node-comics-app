import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Shared content for centered queue and search states. The page owns the
/// available height and scrolling so this also works above the keyboard.
class NodeLaneEmptyState extends StatelessWidget {
  const NodeLaneEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.all(NodeLaneTokens.gutter),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: NodeLaneTokens.emptyStateIconSize, color: t.muted),
          const SizedBox(height: NodeLaneTokens.space16),
          Text(title, textAlign: TextAlign.center, style: t.title),
          if (message != null) ...[
            const SizedBox(height: NodeLaneTokens.space8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: t.readerSecondary,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: NodeLaneTokens.space16),
            action!,
          ],
        ],
      ),
    );
  }
}
