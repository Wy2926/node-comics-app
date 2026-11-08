import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:mangayomi/utils/url_protocol/protocol.dart';
import 'package:url_launcher/url_launcher.dart';

/// Browser transport only; each tracker validates its own OAuth response.
class TrackerOAuthBrowser {
  Completer<Uri>? _desktopCallback;

  void dispose() {
    final pending = _desktopCallback;
    if (pending != null && !pending.isCompleted) {
      pending.completeError(StateError('Tracker login cancelled'));
    }
  }

  Future<Uri> authenticate(
    Uri authorization, {
    required String callbackHost,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.windows &&
        defaultTargetPlatform != TargetPlatform.linux) {
      return Uri.parse(
        await FlutterWebAuth2.authenticate(
          url: authorization.toString(),
          callbackUrlScheme: appUrlScheme,
        ),
      );
    }

    // The desktop web-auth plugin only accepts HTTP loopback callbacks.
    // Existing app protocol registration preserves both query and fragment.
    final callback = Completer<Uri>();
    _desktopCallback = callback;
    final subscription = AppLinks().uriLinkStream.listen(
      (uri) {
        if (!callback.isCompleted &&
            uri.scheme == appUrlScheme &&
            uri.host == callbackHost) {
          callback.complete(uri);
        }
      },
      onError: (Object error, StackTrace stack) {
        if (!callback.isCompleted) callback.completeError(error, stack);
      },
    );
    try {
      final results = await Future.wait<Object>([
        callback.future,
        launchUrl(authorization, mode: LaunchMode.externalApplication).then((
          opened,
        ) {
          if (!opened) throw StateError('Could not open tracker login');
          return opened;
        }),
      ], eagerError: true).timeout(const Duration(minutes: 10));
      return results.first as Uri;
    } finally {
      _desktopCallback = null;
      await subscription.cancel();
    }
  }
}
