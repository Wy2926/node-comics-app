import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

final pendingDownloadCountProvider = StreamProvider.autoDispose<int>(
  (_) => downloadRepository
      .watchPending()
      .map((entries) => entries.length)
      .distinct(),
);

class DownloadQueueButton extends ConsumerWidget {
  const DownloadQueueButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(pendingDownloadCountProvider).asData?.value ?? 0;
    final l = context.l10n, t = NodeLaneTokens.of(context);
    return NodeLaneIconButton(
      tooltip: l.download_queue,
      iconWidget: Semantics(
        label: count > 0 ? l.settings_pending_downloads(count) : null,
        excludeSemantics: true,
        child: Badge.count(
          count: count,
          maxCount: 99,
          isLabelVisible: count > 0,
          backgroundColor: t.accentSoft,
          textColor: t.accent,
          child: Icon(
            NodeLaneIcons.of(context).download,
            size: NodeLaneTokens.iconSize,
          ),
        ),
      ),
      onPressed: () {
        FocusScope.of(context).unfocus();
        context.push('/downloadQueue');
      },
    );
  }
}
