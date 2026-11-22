import 'package:extended_image/extended_image.dart'
    show ExtendedNetworkImageProvider;
import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class NodeLaneWebsiteIcon extends StatelessWidget {
  const NodeLaneWebsiteIcon({super.key, this.url, this.icon});
  final String? url;
  final IconData? icon;
  static final _missing = <String, DateTime>{};
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final fallback = Center(
      child: Icon(
        icon ?? NodeLaneIcons.of(context).web,
        color: t.ink,
        size: NodeLaneTokens.iconSize,
      ),
    );
    final src = url;
    Widget image(String src) {
      if (_missing[src]?.isAfter(DateTime.now()) ?? false) return fallback;
      final provider = ExtendedNetworkImageProvider(
        src,
        cache: true,
        retries: 0,
        printError: false,
        cacheMaxAge: const Duration(days: 30),
      );
      return Image(
        image: provider,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) {
          _missing[src] = DateTime.now().add(const Duration(minutes: 1));
          if (_missing.length > 128) _missing.remove(_missing.keys.first);
          provider.evict();
          return fallback;
        },
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
      child: SizedBox.square(
        dimension: NodeLaneTokens.websiteIconSize,
        child: ColoredBox(
          color: t.soft,
          child: src == null || src.isEmpty ? fallback : image(src),
        ),
      ),
    );
  }
}

class NodeLaneCatalogHeading extends StatelessWidget {
  const NodeLaneCatalogHeading(
    this.title, {
    super.key,
    this.action,
    this.onAction,
  });
  final String title;
  final String? action;
  final ValueChanged<BuildContext>? onAction;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: NodeLaneTokens.space8,
        bottom: NodeLaneTokens.space8,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: NodeLaneTokens.minTapTarget,
        ),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  title,
                  style: t.readerLabel.copyWith(
                    color: t.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (action != null)
              Builder(
                builder: (anchor) => TextButton(
                  onPressed: onAction == null ? null : () => onAction!(anchor),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(
                      NodeLaneTokens.minTapTarget,
                      NodeLaneTokens.minTapTarget,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: NodeLaneTokens.space4,
                    ),
                  ),
                  child: Text(
                    action!,
                    style: t.label.copyWith(
                      color: t.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
