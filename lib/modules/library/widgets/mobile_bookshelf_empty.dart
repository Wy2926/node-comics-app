import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

class MobileBookshelfEmpty extends StatelessWidget {
  const MobileBookshelfEmpty({
    super.key,
    required this.title,
    required this.primaryLabel,
    required this.onPrimary,
    this.subtitle,
    this.secondaryLabel,
    this.onSecondary,
    this.filtered = false,
  });
  final String title, primaryLabel;
  final String? subtitle, secondaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final bool filtered;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
            minWidth: constraints.maxWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.all(NodeLaneTokens.gutter),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: NodeLaneTokens.avatarSize,
                  height: NodeLaneTokens.avatarSize,
                  decoration: BoxDecoration(
                    color: t.soft,
                    borderRadius: BorderRadius.circular(
                      NodeLaneTokens.groupRadius,
                    ),
                  ),
                  child: Icon(
                    filtered ? icons.search : icons.manga,
                    size: NodeLaneTokens.choicePreviewHeight,
                    color: t.muted,
                  ),
                ),
                const SizedBox(height: NodeLaneTokens.space24),
                Text(title, textAlign: TextAlign.center, style: t.title),
                if (subtitle != null) ...[
                  const SizedBox(height: NodeLaneTokens.space8),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: t.readerSecondary,
                  ),
                ],
                const SizedBox(height: NodeLaneTokens.space24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onPrimary,
                      child: Text(primaryLabel),
                    ),
                  ),
                ),
                if (secondaryLabel != null && onSecondary != null) ...[
                  const SizedBox(height: NodeLaneTokens.space8),
                  if (filtered)
                    TextButton(
                      onPressed: onSecondary,
                      child: Text(secondaryLabel!),
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: SizedBox(
                        width: double.infinity,
                        child: NodeLaneSecondaryButton(
                          onPressed: onSecondary,
                          child: Text(secondaryLabel!),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
