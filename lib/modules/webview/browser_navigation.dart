import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'browser_url.dart';

NavigationActionPolicy browserNavigationPolicy(
  NavigationAction action, {
  required bool isIos,
  required bool active,
  required void Function(String) openTab,
}) {
  final url = action.request.url?.toString();
  if (!isBrowserUrl(url)) return NavigationActionPolicy.CANCEL;
  if (isIos && !action.isForMainFrame && action.targetFrame == null) {
    // WKWebView asks for a new window when the target frame is nil. Cancel
    // before onCreateWindow: this plugin's false-result fallback loads the
    // request in the original tab, even if Dart already opened another tab.
    if (active &&
        (action.hasGesture == true ||
            action.navigationType == NavigationType.LINK_ACTIVATED)) {
      openTab(url!);
    }
    return NavigationActionPolicy.CANCEL;
  }
  return NavigationActionPolicy.ALLOW;
}
