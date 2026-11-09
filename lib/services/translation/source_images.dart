import 'contracts.dart';
import 'image_work.dart';

/// Keeps one compressed original per visible locator. Content, not its DOM or
/// chapter position, identifies translation work. No channel or WebView types.
class SourceImages {
  final _reads = <String, _SourceRead>{};

  String? hashFor(TranslationPage page) => _reads[page.identity]?.sha;

  Future<SourceImageLease> acquire(
    TranslationTarget target,
    TranslationCancellation cancellation,
  ) async {
    cancellation.check();
    final key = target.page.identity;
    final read = _reads.putIfAbsent(key, () => _SourceRead(target));
    try {
      await read.ready;
    } catch (_) {
      if (identical(_reads[key], read)) _reads.remove(key);
      read.close();
      rethrow;
    }
    cancellation.check();
    read.cancel.check();
    return read.lease();
  }

  void retain(Iterable<TranslationPage> pages) {
    final keep = pages.map((page) => page.identity).toSet();
    for (final key in _reads.keys.toList()) {
      if (!keep.contains(key)) _reads.remove(key)!.close();
    }
  }

  void dispose() => retain(const []);
}

class SourceImageLease extends OriginalImageLease {
  SourceImageLease(super.file, this.sha, {required super.release});
  final String sha;
}

class _SourceRead {
  _SourceRead(TranslationTarget target) {
    ready = _read(target);
  }
  final cancel = TranslationCancellation();
  late final Future<void> ready;
  OriginalImageLease? _original;
  String? sha;
  int _leases = 0;

  Future<void> _read(TranslationTarget target) async {
    final original = await target.source.acquire(target.page, cancel);
    try {
      cancel.check();
      sha = await imageDigest(original.file);
      cancel.check();
      _original = original;
    } catch (_) {
      original.release();
      rethrow;
    }
  }

  SourceImageLease lease() {
    _leases++;
    return SourceImageLease(
      _original!.file,
      sha!,
      release: () {
        _leases--;
        _release();
      },
    );
  }

  void close() {
    cancel.cancel();
    _release();
  }

  void _release() {
    if (cancel.isCancelled && _leases == 0) {
      _original?.release();
      _original = null;
    }
  }
}
