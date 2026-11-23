import 'package:flutter/widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:url_launcher/url_launcher.dart';

bool _openingPricing = false;

Future<void> openPricingPage(BuildContext context) async {
  if (_openingPricing) return;
  _openingPricing = true;
  try {
    if (await launchUrl(
      Uri.https('comics.nodelane.net', '/pricing/'),
      mode: LaunchMode.externalApplication,
    )) {
      return;
    }
  } on Exception {
    // Platforms can throw instead of returning false when no browser opens.
  } finally {
    _openingPricing = false;
  }
  if (context.mounted) {
    showNodeLaneNotice(
      context.l10n.browser_load_failed,
      kind: NodeLaneNoticeKind.error,
    );
  }
}
