import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/more/settings/downloads/mobile_downloads_screen.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';

const _customName = 'A custom folder with a long descriptive collection name';
const _customPath = '/storage/emulated/0/Documents/comics/collection';

void main() {
  Widget app(Widget child, {double textScale = 1}) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
        padding: const EdgeInsets.only(top: 24, bottom: 34),
      ),
      child: child!,
    ),
    home: child,
  );

  ProviderContainer preferences() {
    final container = ProviderContainer(
      overrides: [
        onlyOnWifiStateProvider.overrideWith(_Wifi.new),
        allowConcurrentDownloadsStateProvider.overrideWith(
          _AllowConcurrent.new,
        ),
        concurrentDownloadsStateProvider.overrideWith(_Count.new),
        downloadDelaySecondsStateProvider.overrideWith(_Delay.new),
        saveAsCBZArchiveStateProvider.overrideWith(_Archive.new),
        deleteDownloadAfterReadingStateProvider.overrideWith(_DeleteRead.new),
        downloadLocationStateProvider.overrideWith(_Location.new),
        localFoldersStateProvider.overrideWith(_Folders.new),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> reveal(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(
      target,
      220,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'download preferences validate drafts and preserve hidden values',
    (tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = preferences();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: app(
            MobileDownloadsScreen(
              defaultFolder: Future.value(null),
              onPickLocation: () {},
              onAddFolder: () {},
              onRemoveFolder: (_) {},
              onRescan: () {},
              onHelp: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final count =
          container.read(concurrentDownloadsStateProvider.notifier) as _Count;
      final delay =
          container.read(downloadDelaySecondsStateProvider.notifier) as _Delay;
      Future<void> openWheel(String title) async {
        await reveal(tester, find.text(title));
        await tester.tap(find.text(title));
        await tester.pumpAndSettle();
        expect(find.byType(Dialog), findsNothing);
      }

      await openWheel('Concurrent downloads');
      expect(count.writes, isEmpty);
      tester
          .widget<CupertinoPicker>(find.byType(CupertinoPicker))
          .scrollController!
          .jumpToItem(2);
      await tester.pumpAndSettle();
      expect(count.writes, [3]);
      await tester.tap(find.text('Concurrent downloads'));
      await tester.pumpAndSettle();
      await reveal(tester, find.text('Allow concurrent downloads'));
      await tester.tap(find.text('Allow concurrent downloads'));
      await tester.pumpAndSettle();
      expect(find.text('Concurrent downloads'), findsNothing);
      expect(container.read(concurrentDownloadsStateProvider), 3);
      await tester.tap(find.text('Allow concurrent downloads'));
      await tester.pumpAndSettle();
      expect(find.text('3'), findsWidgets);
      expect(count.writes, [3]);

      await openWheel('Download delay');
      final picker = find.byType(CupertinoPicker);
      tester.widget<CupertinoPicker>(picker).scrollController!.jumpToItem(0);
      await tester.pumpAndSettle();
      expect(delay.writes, [0]);
      await tester.tap(find.text('Download delay'));
      await tester.pumpAndSettle();

      await reveal(tester, find.text('Only on wifi'));
      await tester.tap(find.text('Only on wifi'));
      await tester.pumpAndSettle();
      expect(container.read(onlyOnWifiStateProvider), isTrue);
      expect(container.read(saveAsCBZArchiveStateProvider), isFalse);
      await reveal(tester, find.text('Save as CBZ archive'));
      await tester.tap(find.text('Save as CBZ archive'));
      await tester.pumpAndSettle();
      expect(container.read(saveAsCBZArchiveStateProvider), isTrue);
      expect(container.read(deleteDownloadAfterReadingStateProvider), isFalse);
      expect(container.read(onlyOnWifiStateProvider), isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'large text folders reveal paths without scanning or deleting the default',
    (tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = preferences();
      var scans = 0;
      var adds = 0;
      var help = 0;
      final removed = <LocalFolder>[];
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: app(
            MobileDownloadsScreen(
              defaultFolder: Future.value(
                LocalFolder(name: 'local', path: '/app/local'),
              ),
              onPickLocation: () {},
              onAddFolder: () => adds++,
              onRemoveFolder: removed.add,
              onRescan: () => scans++,
              onHelp: () => help++,
            ),
            textScale: 2.5,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await reveal(tester, find.text('local'));
      await tester.tap(find.text('local'));
      await tester.pumpAndSettle();
      expect(find.text('/app/local'), findsOneWidget);
      expect(find.text('Delete'), findsNothing);
      await reveal(tester, find.text(_customName));
      await tester.tap(find.text(_customName));
      await tester.pumpAndSettle();
      expect(find.text(_customPath), findsOneWidget);
      expect(scans, 0);
      expect(removed, isEmpty);
      await reveal(tester, find.text('Delete'));
      await tester.tap(find.text('Delete'));
      expect(removed.single.path, _customPath);
      await reveal(tester, find.text('Add local folder'));
      await tester.tap(find.text('Add local folder'));
      await reveal(tester, find.text('Rescan all local folders now'));
      await tester.tap(find.text('Rescan all local folders now'));
      await reveal(tester, find.text('Structure of a local folder'));
      await tester.tap(find.text('Structure of a local folder'));
      expect((adds, scans, help), (1, 1, 1));
      expect(tester.takeException(), isNull);
    },
  );
}

class _Wifi extends OnlyOnWifiState {
  @override
  bool build() => false;
  @override
  void set(bool value) => state = value;
}

class _AllowConcurrent extends AllowConcurrentDownloadsState {
  @override
  bool build() => true;
  @override
  void set(bool value) => state = value;
}

class _Count extends ConcurrentDownloadsState {
  final writes = <int>[];
  @override
  int build() => 1;
  @override
  void set(int value) {
    writes.add(value);
    state = value;
  }
}

class _Delay extends DownloadDelaySecondsState {
  final writes = <int>[];
  @override
  int build() => 5;
  @override
  void set(int value) {
    writes.add(value);
    state = value;
  }
}

class _Archive extends SaveAsCBZArchiveState {
  @override
  bool build() => false;
  @override
  void set(bool value) => state = value;
}

class _DeleteRead extends DeleteDownloadAfterReadingState {
  @override
  bool build() => false;
  @override
  void set(bool value) => state = value;
}

class _Location extends DownloadLocationState {
  @override
  (String, String) build() => ('/app/downloads', '');
}

class _Folders extends LocalFoldersState {
  @override
  List<LocalFolder> build() => [
    LocalFolder(name: _customName, path: _customPath),
  ];
}
