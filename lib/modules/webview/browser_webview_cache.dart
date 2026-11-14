import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final browserWebViewCache = BrowserWebViewCache();

class BrowserWebViewLease {
  final keepAlive = InAppWebViewKeepAlive();
  bool created = false;
  bool loadFailed = false;
  bool attached = true;
  bool _discard = false;
}

/// Keep a bounded set of native documents, including across browser routes.
class BrowserWebViewCache with WidgetsBindingObserver {
  BrowserWebViewCache() {
    WidgetsBinding.instance.addObserver(this);
  }

  static const capacity = 3;
  final _pages = <String, BrowserWebViewLease>{};

  BrowserWebViewLease acquire(String id) {
    final previous = _pages.remove(id);
    assert(previous?.attached != true, 'A native page cannot have two owners');
    final page = previous ?? BrowserWebViewLease();
    page.attached = true;
    _pages[id] = page;
    _trim();
    return page;
  }

  void touch(String id) {
    final page = _pages.remove(id);
    if (page != null) _pages[id] = page;
  }

  void release(BrowserWebViewLease page) {
    page.attached = false;
    if (page._discard) {
      _disposePage(page);
    } else {
      _trim();
    }
  }

  void remove(String id) {
    final page = _pages.remove(id);
    if (page == null) return;
    page._discard = true;
    if (!page.attached) _disposePage(page);
  }

  void _trim() {
    for (final id in _pages.keys.toList()) {
      if (_pages.length <= capacity) break;
      if (!_pages[id]!.attached) remove(id);
    }
  }

  @override
  void didHaveMemoryPressure() {
    for (final id in _pages.keys.toList()) {
      if (!_pages[id]!.attached) remove(id);
    }
  }

  void _disposePage(BrowserWebViewLease page) {
    // A platform view may already be gone after an engine/process shutdown.
    unawaited(
      InAppWebViewController.disposeKeepAlive(page.keepAlive)
          .catchError((_) {}),
    );
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final id in _pages.keys.toList()) {
      remove(id);
    }
  }
}
