import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/webview/browser_webview_cache.dart';

class _Platform extends InAppWebViewPlatform {
  final disposed = <InAppWebViewKeepAlive>[];
  @override
  PlatformInAppWebViewController createPlatformInAppWebViewControllerStatic() =>
      _Controller(disposed);
}

class _Controller extends PlatformInAppWebViewController {
  _Controller(this.disposed)
    : super.implementation(
        const PlatformInAppWebViewControllerCreationParams(id: null),
      );
  final List<InAppWebViewKeepAlive> disposed;
  @override
  Future<void> disposeKeepAlive(InAppWebViewKeepAlive keepAlive) async {
    disposed.add(keepAlive);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _Platform platform;
  late BrowserWebViewCache cache;
  setUp(() {
    final original = InAppWebViewPlatform.instance;
    platform = _Platform();
    InAppWebViewPlatform.instance = platform;
    cache = BrowserWebViewCache();
    addTearDown(() {
      cache.dispose();
      if (original != null) InAppWebViewPlatform.instance = original;
    });
  });

  testWidgets(
    'recent documents survive idle time; LRU and memory pressure release only detached pages',
    (tester) async {
      final first = cache.acquire('a')..created = true;
      cache.release(first);
      final second = cache.acquire('b')..created = true;
      cache.release(second);
      final third = cache.acquire('c')..created = true;
      cache.release(third);
      await tester.pump(const Duration(minutes: 5));
      expect(platform.disposed, isEmpty);
      expect(cache.acquire('a'), same(first));
      cache.release(first);
      final fourth = cache.acquire('d');
      expect(platform.disposed, [second.keepAlive]);
      cache.didHaveMemoryPressure();
      expect(platform.disposed.toSet(), {
        second.keepAlive,
        first.keepAlive,
        third.keepAlive,
      });
      expect(platform.disposed, isNot(contains(fourth.keepAlive)));
      cache.remove('d');
      expect(platform.disposed, isNot(contains(fourth.keepAlive)));
      cache.release(fourth);
      expect(platform.disposed, contains(fourth.keepAlive));
      final fresh = cache.acquire('a');
      expect(fresh.keepAlive, isNot(same(first.keepAlive)));
      expect(fresh.created, isFalse);
      cache.release(fresh);
    },
  );

  testWidgets('touch updates recency while the native view stays mounted', (
    tester,
  ) async {
    final pages = [
      for (final id in ['a', 'b', 'c']) cache.acquire(id),
    ];
    cache.touch('a');
    final fourth = cache.acquire('d');
    expect(platform.disposed, isEmpty);
    cache.release(pages[1]);
    expect(platform.disposed, [pages[1].keepAlive]);
    cache.release(pages[0]);
    expect(cache.acquire('a'), same(pages[0]));
    cache.release(pages[0]);
    cache.release(pages[2]);
    cache.release(fourth);
  });
}
