import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/source_images.dart';

class _Source implements SourceImageReader {
  _Source(this.file);
  final File file;
  int reads = 0, releases = 0;
  Completer<void>? pending;
  @override
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  ) async {
    reads++;
    if (pending != null) await pending!.future;
    return OriginalImageLease(file, release: () => releases++);
  }
}

void main() {
  late Directory directory;
  late _Source source;
  late SourceImages images;
  late TranslationTarget target;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp(
      'nodelane-source-images-',
    );
    source = _Source(
      await File('${directory.path}/original').writeAsBytes([1, 2, 3]),
    );
    images = SourceImages();
    target = TranslationTarget(
      const TranslationPage('element', 'image-a'),
      source,
    );
  });
  tearDown(() async {
    images.dispose();
    await directory.delete(recursive: true);
  });

  test('preparation and restore share bytes; leaving the window waits for active leases', () async {
    final leases = await Future.wait([
      images.acquire(target, TranslationCancellation()),
      images.acquire(target, TranslationCancellation()),
    ]);
    expect(source.reads, 1);
    expect(leases[0].sha, leases[1].sha);
    images.retain(const []);
    expect(source.releases, 0);
    leases[0].release();
    leases[1].release();
    expect(source.releases, 1);
  });

  test(
    'navigation releases a late original and does not poison the replacement',
    () async {
      source.pending = Completer<void>();
      final old = images.acquire(target, TranslationCancellation());
      final cancelled = expectLater(old, throwsA(isA<TranslationCancelled>()));
      final next = TranslationTarget(
        const TranslationPage('element', 'image-b'),
        source,
      );
      images.retain([next.page]);
      source.pending!.complete();
      await cancelled;
      expect(source.releases, 1);
      final current = await images.acquire(next, TranslationCancellation());
      expect(source.reads, 2);
      current.release();
      images.dispose();
      expect(source.releases, 2);
    },
  );
}
