import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

import 'translation_view_controller.dart';

Future<void> openTranslationUpgrade(
  BuildContext context,
  TranslationViewController view,
  TranslationTarget target,
) async {
  final service = ProviderScope.containerOf(
    context,
    listen: false,
  ).read(translationServiceProvider);
  final runtime = view.runtime;
  bool current() =>
      context.mounted &&
      view.foreground &&
      identical(view.runtime, runtime) &&
      view.targetFor(target.page) != null &&
      view.state(target).failure?.quotaExhausted == true;
  try {
    await service.openBillingUpgrade(runtime, current);
  } catch (error) {
    if (context.mounted && current()) {
      showNodeLaneNotice(
        error is TranslationFailure && error.code == 'AUTH_REQUIRED'
            ? context.l10n.translation_auth_required
            : context.l10n.translation_upgrade_unavailable,
        kind: NodeLaneNoticeKind.error,
      );
    }
  }
}
