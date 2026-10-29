import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// A shared phone layout; each caller owns its records and clear operation.
class MobileErrorList extends StatelessWidget {
  const MobileErrorList({
    super.key,
    required this.title,
    required this.emptyMessage,
    required this.clearLabel,
    required this.itemCount,
    required this.itemBuilder,
    required this.onClear,
    this.findChildIndexCallback,
  });

  final String title, emptyMessage, clearLabel;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ChildIndexGetter? findChildIndexCallback;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => NodeLaneSurface(
    child: Scaffold(
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          key: PageStorageKey(title),
          slivers: [
            if (itemCount == 0)
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 44,
                        color: NodeLaneTokens.of(context).accent,
                      ),
                      const SizedBox(height: 20),
                      Text(emptyMessage, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              )
            else ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton.icon(
                      onPressed: onClear,
                      icon: const Icon(Icons.clear_all_rounded),
                      label: Text(clearLabel),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList.builder(
                  itemCount: itemCount,
                  itemBuilder: itemBuilder,
                  findChildIndexCallback: findChildIndexCallback,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
