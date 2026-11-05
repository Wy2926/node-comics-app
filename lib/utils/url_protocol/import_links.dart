import 'protocol.dart';

/// Accepts only app import actions and suppresses duplicate in-flight events.
class ImportLinks {
  final _pending = <Uri>{};

  Future<void> handle(Uri uri, Future<void> Function(Uri) onImport) async {
    if (uri.scheme != appUrlScheme ||
        !const {'add-repo', 'add-button'}.contains(uri.host) ||
        uri.userInfo.isNotEmpty ||
        uri.hasPort ||
        (uri.path.isNotEmpty && uri.path != '/') ||
        uri.hasFragment) {
      return;
    }
    final action = uri.replace(path: '');
    if (!_pending.add(action)) return;
    try {
      await onImport(action);
    } finally {
      _pending.remove(action);
    }
  }
}
