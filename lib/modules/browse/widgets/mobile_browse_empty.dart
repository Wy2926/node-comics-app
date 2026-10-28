import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, size: 32, color: colors.accent),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colors.ink,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(44, 44)),
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
    );
  }
}
