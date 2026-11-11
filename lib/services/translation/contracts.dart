import 'package:mangayomi/utils/localized_message.dart';

import 'dart:async';
import 'dart:io';

/// A source-owned display locator, not a persistent translation identity.
/// Translation reuse is based on the acquired image's content hash.
class TranslationPage {
  const TranslationPage(this.key, this.revision);
  final String key;
  final String revision;
  String get identity => '$key:$revision';
}

class TranslationCancelled implements Exception {
  const TranslationCancelled();
}

class TranslationCancellation {
  bool _cancelled = false;
  final _listeners = <void Function()>{};
  bool get isCancelled => _cancelled;

  void check() {
    if (_cancelled) throw const TranslationCancelled();
  }

  void Function() onCancel(void Function() listener) {
    if (_cancelled) {
      listener();
      return () {};
    }
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }

  void cancel() {
    if (_cancelled) return;
    _cancelled = true;
    final listeners = List.of(_listeners);
    _listeners.clear();
    for (final listener in listeners) {
      listener();
    }
  }
}

class OriginalImageLease {
  OriginalImageLease(this.file, {void Function()? release})
    : _release = release;
  final File file;
  void Function()? _release;
  void release() {
    final callback = _release;
    _release = null;
    callback?.call();
  }
}

abstract interface class SourceImageReader {
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  );
}

class TranslationTarget {
  const TranslationTarget(this.page, this.source);
  final TranslationPage page;
  final SourceImageReader source;
}

class TranslationOptions {
  const TranslationOptions({this.language = 'zh-Hans'});
  final String language;
}

enum TranslationPhase {
  idle,
  preparing,
  submitting,
  awaitingInput,
  queued,
  running,
  uncertain,
  succeeded,
  failed,
}

enum TranslationAction { verify, readResult, retry, regenerate }

/// An adapter-owned reference. Consumers cannot build service URLs from it.
class TranslationResultRef {
  const TranslationResultRef(this.scope, this.operationId);
  final String scope;
  final String operationId;
}

class DisplayImageLease {
  DisplayImageLease({
    required this.file,
    required this.width,
    required this.height,
    this.mime = 'image/png',
    void Function()? release,
  }) : _release = release;
  final File file;
  final int width;
  final int height;
  final String mime;
  void Function()? _release;
  void release() {
    final callback = _release;
    _release = null;
    callback?.call();
  }
}

class PageTranslationState {
  const PageTranslationState({
    this.phase = TranslationPhase.idle,
    this.message = '',
    this.result,
    this.noText = false,
    this.actions = const {},
  });
  final TranslationPhase phase;
  final String message;
  final TranslationResultRef? result;
  final bool noText;
  final Set<TranslationAction> actions;
}

/// Only the composition root imports a concrete channel. A complete-image
/// channel need not implement official UUIDs, overlays, subscriptions or billing.
abstract interface class TranslationChannel {
  String get id;
  String get label;
  String get scope;
  ChannelRuntime createRuntime(TranslationOptions options);
}

abstract interface class ChannelRuntime {
  Stream<void> get changes;
  PageTranslationState stateFor(TranslationPage page);
  Future<void> restore(List<TranslationTarget> targets);

  /// Keeps visible images available for cached results and explicit actions.
  /// Only [automatic] authorizes creating translations for untouched images.
  void setWindow(
    String consumer,
    List<TranslationTarget> targets, {
    bool automatic = true,
  });
  void pause(String consumer);
  Future<void> perform(TranslationTarget target, TranslationAction action);
  Future<DisplayImageLease> readResult(
    TranslationResultRef result,
    TranslationCancellation cancellation,
  );
  Future<void> clearResults();
  Future<void> dispose();
}

/// Safe error codes only: never display raw HTTP bodies, source URLs or tokens.
class TranslationFailure implements Exception {
  const TranslationFailure(this.code, {this.retryAfter});
  final String code;
  final Duration? retryAfter;
  String get message => localizedMessage(
    (l10n) => switch (code) {
      'AUTH_REQUIRED' => l10n.translation_auth_required,
      'SOURCE_CHANGED' => l10n.translation_source_changed,
      'SOURCE_MISSING' => l10n.translation_source_missing,
      'RESOURCE_LIMIT' => l10n.translation_resource_limit,
      'STORAGE_FULL' => l10n.translation_storage_full,
      'INVALID_IMAGE' => l10n.translation_invalid_image,
      'UNSUPPORTED_IMAGE' => l10n.translation_unsupported_image,
      'INVALID_RESULT' => l10n.translation_invalid_result,
      'RESULT_UNAVAILABLE' => l10n.translation_result_unavailable,
      'RESULT_EXPIRED' => l10n.translation_result_expired,
      'CLASSIC_ANALYSIS_TOO_LARGE' => l10n.translation_analysis_too_large,
      'CLASSIC_REGION_LIMIT_EXCEEDED' => l10n.translation_region_limit,
      'CLASSIC_TEXT_LIMIT_EXCEEDED' => l10n.translation_text_limit,
      'TRANSLATION_UNAVAILABLE' ||
      'RESULT_FORMAT_UNAVAILABLE' ||
      'TRANSLATION_MODE_UNAVAILABLE' => l10n.translation_unavailable,
      'OUTCOME_UNKNOWN' => l10n.translation_outcome_unknown,
      'RATE_LIMITED' => l10n.translation_rate_limited,
      'QUOTA_EXHAUSTED' => l10n.translation_quota_exhausted,
      'UNSUPPORTED_LANGUAGE' => l10n.translation_unsupported_language,
      'CLIENT_UPGRADE_REQUIRED' => l10n.translation_upgrade_required,
      'REMOTE_FAILED' => l10n.translation_remote_failed,
      'BRIDGE_INVALID' => l10n.translation_bridge_invalid,
      _ => l10n.translation_connection_failed,
    },
  );
  @override
  String toString() => 'TranslationFailure($code)';
}
