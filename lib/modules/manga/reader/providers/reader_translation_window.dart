import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_coordinator.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_provider.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_types.dart';

final readerTranslationWindowProvider =
    ChangeNotifierProvider.autoDispose<ReaderTranslationWindow>(
      (ref) => ReaderTranslationWindow(ref.watch(translationProvider.notifier)),
    );

/// Ephemeral reader intent only. Durable tasks and all execution stay in the
/// application coordinator; this object never owns a second task queue or DB.
class ReaderTranslationWindow extends ChangeNotifier {
  ReaderTranslationWindow(this.service) {
    _scope = service.scope;
    _configuration = configuration;
    service.addListener(_changed);
  }
  final TranslationCoordinator service;
  List<TranslationPage> _pages = [];
  final _attempted = <String>{};
  bool enabled = false, _running = false, _disposed = false;
  String? error, _scope;
  late String _configuration;
  String get configuration => '${service.scope}/${service.language}';
  String signature(TranslationPage page) =>
      '${page.key}/${page.locatorSignature}';

  void setEnabled(bool value) {
    enabled = value;
    error = null;
    if (value) _attempted.clear();
    notifyListeners();
    _schedule();
  }

  void update(Iterable<TranslationPage> pages) {
    final unique = <String, TranslationPage>{};
    for (final page in pages) {
      unique.putIfAbsent(page.key, () => page);
      if (unique.length == 4) break;
    }
    _pages = unique.values.toList();
    final active = _pages.map(signature).toSet();
    _attempted.removeWhere((key) => !active.contains(key));
    _schedule();
  }

  void _changed() {
    if (_disposed) return;
    if (_scope != service.scope) {
      _scope = service.scope;
      enabled = false;
      error = null;
      notifyListeners();
    }
    if (_configuration != configuration) {
      _configuration = configuration;
      _attempted.clear();
    }
    _schedule();
  }

  void _schedule() {
    if (_disposed ||
        _running ||
        !enabled ||
        !service.foreground ||
        !service.initialized ||
        service.scope == null) {
      return;
    }
    _running = true;
    unawaited(_run());
  }

  Future<void> _run() async {
    try {
      while (!_disposed &&
          enabled &&
          service.foreground &&
          service.scope != null) {
        final page = _pages
            .where((p) => !_attempted.contains(signature(p)))
            .firstOrNull;
        if (page == null) break;
        final config = configuration;
        final key = signature(page);
        _attempted.add(key);
        bool wanted() =>
            !_disposed &&
            enabled &&
            config == configuration &&
            _pages.any((p) => signature(p) == key);
        try {
          await service.translate(page, isWanted: wanted);
        } catch (e) {
          if (wanted()) {
            error = translationErrorMessage(translationError(e));
            notifyListeners();
          }
        }
      }
    } finally {
      _running = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _pages = [];
    service.removeListener(_changed);
    super.dispose();
  }
}
