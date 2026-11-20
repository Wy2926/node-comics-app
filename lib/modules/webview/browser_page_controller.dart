import 'dart:typed_data';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

typedef SiteProtectionState = ({bool enabled, int blocked, int total});

enum SiteProtectionAction { reload, tools, dashboard }

abstract interface class BrowserProtection {
  String get name;
  Future<SiteProtectionState> site(String url, {bool? enabled});
  Future<void> perform(String url, SiteProtectionAction action);
}

/// Operations owned by the browser chrome, independent of a tab's engine.
abstract class BrowserPageController {
  Future<void> load(String url);
  Future<void> reload();
  Future<void> stop();
  Future<Uint8List?> preview();
  BrowserProtection? get protection => null;
}

class SystemBrowserPage extends BrowserPageController {
  SystemBrowserPage(this.web);
  final InAppWebViewController web;
  @override
  Future<void> load(String url) =>
      web.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  @override
  Future<void> reload() => web.reload();
  @override
  Future<void> stop() => web.stopLoading();
  @override
  Future<Uint8List?> preview() => web.takeScreenshot(
    screenshotConfiguration: ScreenshotConfiguration(
      snapshotWidth: 340,
      compressFormat: CompressFormat.JPEG,
      quality: 55,
    ),
  );
}
