import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class ExtensionServerWarningBanner extends ConsumerWidget {
  const ExtensionServerWarningBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isDesktop) return const SizedBox.shrink();

    final installedAsync = ref.watch(isExtensionServerInstalledStreamProvider);

    return installedAsync.when(
      data: (isInstalled) {
        if (isInstalled) return const SizedBox.shrink();

        final l10n = context.l10n;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NodeLaneTokens.gutter,
            vertical: NodeLaneTokens.space8,
          ),
          child: NodeLaneNotice(
            message: l10n.android_proxy_server_mihon,
            description: l10n.extension_server_intro_with_jre,
            actionLabel: l10n.download,
            onAction: () => context.push('/extensionServer'),
          ),
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
