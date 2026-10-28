import 'package:flutter/material.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Does not fetch, parse or persist repositories; all actions belong to the
/// existing repository settings screen.
class MobileRepositoryCard extends StatelessWidget {
  const MobileRepositoryCard({
    super.key,
    required this.name,
    required this.host,
    required this.visible,
    required this.visibilityLabel,
    required this.onVisibilityChanged,
    required this.copyLabel,
    required this.onCopy,
    required this.removeLabel,
    required this.onRemove,
    required this.browserLabel,
    this.onOpenBrowser,
  });
  final String name,
      host,
      visibilityLabel,
      copyLabel,
      removeLabel,
      browserLabel;
  final bool visible;
  final ValueChanged<bool> onVisibilityChanged;
  final VoidCallback onCopy, onRemove;
  final VoidCallback? onOpenBrowser;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return MobileBrowseGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.soft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.source_outlined,
                    key: const Key('repository-icon'),
                    color: colors.muted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.ink,
                        ),
                      ),
                      if (host.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          host,
                          style: TextStyle(fontSize: 12, color: colors.muted),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          SwitchListTile.adaptive(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              visibilityLabel,
              style: TextStyle(fontSize: 14, color: colors.ink),
            ),
            value: visible,
            onChanged: onVisibilityChanged,
          ),
          Divider(height: 1, color: colors.line),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                TextButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.content_copy_rounded, size: 18),
                  label: Text(copyLabel),
                ),
                if (onOpenBrowser != null)
                  TextButton.icon(
                    onPressed: onOpenBrowser,
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: Text(browserLabel),
                  ),
                IconButton(
                  tooltip: removeLabel,
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
