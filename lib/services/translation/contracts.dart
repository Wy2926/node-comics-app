import 'dart:async';
import 'dart:io';

/// The source owns this identity and its locator. No URL or credentials are
/// sent to a translation channel. Split-page views use the same source key.
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
  void setWindow(String consumer, List<TranslationTarget> targets);
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
  String get message => switch (code) {
    'AUTH_REQUIRED' => '请先登录翻译账号',
    'SOURCE_CHANGED' => '原图已变化，请重新载入',
    'SOURCE_MISSING' => '原图暂不可用',
    'RESOURCE_LIMIT' => '当前图片超出本机处理预算，已保留原图',
    'STORAGE_FULL' => '翻译存储空间不足，请先清理译图',
    'INVALID_IMAGE' => '图片格式或内容无效',
    'UNSUPPORTED_IMAGE' => '暂不支持此图片的翻译，已保留原图',
    'INVALID_RESULT' => '译图校验失败，请重新读取',
    'RESULT_UNAVAILABLE' => '译图暂不可用，请重新读取',
    'TRANSLATION_UNAVAILABLE' => '此翻译已不可用',
    'OUTCOME_UNKNOWN' => '结果待核实，未重新提交',
    'RATE_LIMITED' => '请求受限，稍后自动恢复',
    'QUOTA_EXHAUSTED' => '当前翻译额度不足',
    'UNSUPPORTED_LANGUAGE' => '服务暂不支持此目标语言',
    'CLIENT_UPGRADE_REQUIRED' => '翻译协议不兼容，请更新应用',
    'REMOTE_FAILED' => '本页翻译失败，可手动重试',
    'BRIDGE_INVALID' => '网页已变化，请重新开启翻译',
    _ => '连接失败，请重试',
  };
  @override
  String toString() => 'TranslationFailure($code)';
}
