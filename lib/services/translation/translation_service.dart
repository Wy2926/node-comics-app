import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mangayomi/models/translation_entry.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';
import 'package:mangayomi/repositories/translation_repository.dart';

import 'contracts.dart';
import 'image_work.dart';
import 'channels/nodelane/channel.dart';
import 'channels/nodelane/session.dart';
import 'channels/nodelane/account.dart';

final translationServiceProvider = Provider<TranslationService>((ref) {
  final service = TranslationService();
  ref.onDispose(service.dispose);
  return service;
});

/// Composition root: source and presentation code depend only on ChannelRuntime.
/// A separate private database keeps receipts out of library backup and sync.
class TranslationService extends ChangeNotifier {
  TranslationService({NodeLaneSession? session})
    : _session =
          session ??
          NodeLaneSession(
            Uri.parse(
              const String.fromEnvironment(
                'NODELANE_API_BASE',
                defaultValue: 'https://comics.nodelane.net',
              ),
            ),
          );
  final NodeLaneSession _session;
  ChannelRuntime? runtime;
  TranslationRepository? _repository;
  TranslationImageWork? _images;
  Future<void>? _initializing;
  String language = 'zh-Hans';
  bool busy = false;
  String? error;
  bool get loggedIn => _session.userId != null;
  String get accountName => _session.name;
  String? get accountId => _session.userId;
  NodeLaneAccount? account;
  bool accountLoading = false;
  bool accountLoadFailed = false;
  bool accountAuthRequired = false;
  Future<void>? _accountRequest;
  TranslationCancellation? _accountCancellation;

  /// Refreshing presentation data never replaces the reading runtime or tasks.
  Future<void> refreshAccount() => _accountRequest ??= _readAccount();
  Future<void> _readAccount() async {
    final cancel = TranslationCancellation();
    _accountCancellation = cancel;
    accountLoading = true;
    accountLoadFailed = false;
    accountAuthRequired = false;
    notifyListeners();
    try {
      await initialize();
      if (!loggedIn) return;
      final next = await _session.readAccount(cancel);
      cancel.check();
      account = next;
    } on TranslationCancelled {
      // Account replacement and disposal invalidate in-flight reads.
    } catch (e) {
      if (!cancel.isCancelled) {
        accountLoadFailed = true;
        accountAuthRequired =
            e is TranslationFailure && e.code == 'AUTH_REQUIRED';
      }
    } finally {
      if (_accountCancellation == cancel) {
        _accountCancellation = null;
        _accountRequest = null;
        accountLoading = false;
        notifyListeners();
      }
    }
  }

  void _clearAccount() {
    _accountCancellation?.cancel();
    _accountCancellation = null;
    _accountRequest = null;
    account = null;
    accountLoading = false;
    accountLoadFailed = false;
    accountAuthRequired = false;
  }

  Future<void> initialize() => _initializing ??= _initialize();
  Future<void> _initialize() async {
    final root = await nodeLanePrivateDirectory();
    final db = await Isar.open(
      [TranslationEntrySchema],
      directory: root.path,
      name: 'nodelaneTranslation',
      inspector: false,
    );
    _repository = TranslationRepository(db, root);
    final temp = Directory(
      '${(await getTemporaryDirectory()).path}/nodelane-translation',
    );
    if (await temp.exists()) await temp.delete(recursive: true);
    // Crash leftovers have no live owner at service startup. Keep the receipt
    // store intact; only source/bridge scratch files are disposable here.
    await for (final entry in temp.parent.list()) {
      if (entry is File &&
          (entry.uri.pathSegments.last.startsWith('nodelane-source-') ||
              entry.uri.pathSegments.last.startsWith('nodelane-bridge-'))) {
        await entry.delete();
      }
    }
    _images = TranslationImageWork(temp);
    try {
      await _session.restore();
    } on TranslationFailure catch (e) {
      error = e.message;
    }
    final prefs = await _repository!.read('preferences');
    language = prefs?['language'] as String? ?? language;
    await _replaceRuntime();
  }

  Future<void> _replaceRuntime() async {
    final old = runtime;
    runtime = null;
    notifyListeners();
    await old?.dispose();
    if (loggedIn) {
      runtime = NodeLaneChannel(
        base: _session.base,
        userId: _session.userId!,
        accessToken: _session.accessToken,
        repository: _repository!,
        images: _images!,
      ).createRuntime(TranslationOptions(language: language));
    }
    notifyListeners();
  }

  Future<void> login() => _act(() async {
    await initialize();
    await _session.login();
    _clearAccount();
    await _replaceRuntime();
    unawaited(refreshAccount());
  });
  Future<void> logout() => _act(() async {
    _clearAccount();
    await _session.logout();
    await _replaceRuntime();
  });
  Future<void> setLanguage(String value) => _act(() async {
    await initialize();
    language = value;
    await _repository!.write('preferences', 'app', 'preferences', {
      'language': language,
    });
    await _replaceRuntime();
  });
  Future<void> clearResults() => _act(() async {
    await initialize();
    final old = runtime;
    runtime = null;
    notifyListeners();
    await old?.dispose();
    await _repository!.clearResults();
    await _replaceRuntime();
  });
  Future<void> _act(Future<void> Function() body) async {
    if (busy) return;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await body();
    } catch (e) {
      error = e is TranslationFailure ? e.message : '操作未完成，请重试';
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _clearAccount();
    runtime?.dispose();
    super.dispose();
  }
}
