import 'package:mangayomi/modules/browse/extension/providers/extensions_provider.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/mobile_sources_screen.dart';
import 'package:mangayomi/modules/browse/mobile_repository_sheets.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/webview/mobile_browser_home.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class _Repos extends ExtensionsRepoState {
  int writes = 0;
  @override
  List<Repo> build(ItemType itemType) => [];
  @override
  Future<void> set(List<Repo> value) async {
    writes++;
    state = value;
  }
}

class _Hidden extends HideItemsState {
  @override
  List<String> build() => [];
}

class _Nsfw extends ShowNSFWState {
  @override
  bool build() => false;
}

void main() {
  final repo = Repo(name: '社区目录', jsonUrl: 'https://example.org/index.json');
  Future<void> mount(
    WidgetTester tester,
    Widget child,
    ProviderContainer container,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            platform: TargetPlatform.iOS,
            colorSchemeSeed: NodeLaneTokens.defaultMobileAccent,
          ),
          home: Scaffold(body: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'directory rows open directly while third party exposes install/update',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          extensionsRepoStateProvider(ItemType.manga).overrideWith(_Repos.new),
          hideItemsStateProvider.overrideWith(_Hidden.new),
          showNSFWStateProvider.overrideWith(_Nsfw.new),
          temporaryCatalogRepositoryProvider(ItemType.manga)
              .overrideWithValue(repo),
          temporaryCatalogLoadProvider(ItemType.manga)
              .overrideWith((ref) async {}),
          fetchItemSourcesListProvider(
            reFresh: false,
            itemType: ItemType.manga,
          ).overrideWith((ref) async {}),
          mobileCatalogEntriesProvider(ItemType.manga).overrideWith(
            (ref) => Stream.value([
              Source(
                id: 1,
                name: 'MangaDex',
                lang: 'en',
                repo: repo,
                isPinned: true,
                isAdded: true,
                sourceCode: 'existing',
                version: '1.0.0',
                versionLast: '2.0.0',
              ),
              Source(id: 2, name: 'WEBTOON', lang: 'en', repo: repo),
            ]),
          ),
        ],
      );
      addTearDown(container.dispose);
      await mount(tester, const MobileSourcesScreen(), container);
      expect(find.text('MangaDex'), findsOneWidget);
      expect(find.text('安装'), findsNothing);
      expect(find.text('更新'), findsNothing);
      expect(find.textContaining('临时目录'), findsOneWidget);
      await tester.tap(find.text('第三方'));
      await tester.pumpAndSettle();
      expect(find.text('安装'), findsOneWidget);
      expect(find.text('更新'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'missing');
      await tester.pumpAndSettle();
      expect(find.text('没有匹配的网站'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('a trailing source action never opens its row', (tester) async {
    var opened = 0, installed = 0;
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await mount(
      tester,
      NodeLaneCatalogRow(
        title: 'Website',
        leading: const Icon(Icons.public),
        onTap: () => opened++,
        trailing: TextButton(
          onPressed: () => installed++,
          child: const Text('安装'),
        ),
      ),
      container,
    );
    await tester.tap(find.text('安装'));
    expect([opened, installed], [0, 1]);
    await tester.tap(find.text('Website'));
    expect([opened, installed], [1, 1]);
  });
  testWidgets(
    'language choices only filter their directory and never change installation flags',
    (tester) async {
      final english = Source(
        id: 1,
        name: 'English site',
        lang: 'en',
        repo: repo,
        isAdded: true,
      );
      final japanese = Source(
        id: 2,
        name: 'Japanese site',
        lang: 'ja',
        repo: repo,
        isActive: false,
      );
      final container = ProviderContainer(
        overrides: [
          extensionsRepoStateProvider(ItemType.manga).overrideWith(_Repos.new),
          hideItemsStateProvider.overrideWith(_Hidden.new),
          showNSFWStateProvider.overrideWith(_Nsfw.new),
          temporaryCatalogRepositoryProvider(ItemType.manga)
              .overrideWithValue(repo),
          temporaryCatalogLoadProvider(ItemType.manga)
              .overrideWith((ref) async {}),
          fetchItemSourcesListProvider(
            reFresh: false,
            itemType: ItemType.manga,
          ).overrideWith((ref) async {}),
          mobileCatalogEntriesProvider(ItemType.manga)
              .overrideWith((ref) => Stream.value([english, japanese])),
        ],
      );
      addTearDown(container.dispose);
      await mount(tester, const MobileSourcesScreen(), container);
      await tester.tap(find.byTooltip('来源操作'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('语言筛选'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('English'));
      await tester.tap(find.text('日本語'));
      await tester.tap(find.text('应用'));
      await tester.pumpAndSettle();
      expect(find.text('Japanese site'), findsOneWidget);
      expect(find.text('English site'), findsNothing);
      expect(english.isAdded, isTrue);
      expect(english.isActive, isTrue);
      expect(japanese.isAdded, isFalse);
      expect(japanese.isActive, isFalse);
      await tester.tap(find.text('第三方'));
      await tester.pumpAndSettle();
      expect(find.text('English site'), findsOneWidget);
      expect(find.text('Japanese site'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'browser common sites include uninstalled pinned sources and respect NSFW preference',
    (tester) async {
      FlutterSecureStorage.setMockInitialValues({});
      final container = ProviderContainer(
        overrides: [
          showNSFWStateProvider.overrideWith(_Nsfw.new),
          for (final type in ItemType.values) ...[
            extensionsRepoStateProvider(type).overrideWith(_Repos.new),
            getExtensionsStreamProvider(type).overrideWith(
              (ref) => Stream.value(
                type == ItemType.manga
                    ? [
                        Source(
                          id: 1,
                          name: 'Pinned website',
                          baseUrl: 'https://example.org',
                          isPinned: true,
                          isAdded: false,
                        ),
                        Source(
                          id: 2,
                          name: 'Unpinned website',
                          baseUrl: 'https://example.net',
                          isPinned: false,
                        ),
                        Source(
                          id: 3,
                          name: 'Hidden website',
                          baseUrl: 'https://example.com',
                          isPinned: true,
                          isNsfw: true,
                        ),
                      ]
                    : <Source>[],
              ),
            ),
          ],
        ],
      );
      addTearDown(container.dispose);
      await mount(tester, const MobileBrowserHome(), container);
      expect(find.text('Pinned website'), findsOneWidget);
      expect(find.text('Unpinned website'), findsNothing);
      expect(find.text('Hidden website'), findsNothing);
      await tester.enterText(find.byType(TextField), 'example.org');
      await tester.pumpAndSettle();
      expect(find.byTooltip('打开网址'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'repository preview ignores a stale response and duplicate add is prevented',
    (tester) async {
      final first = Completer<Repo?>();
      final second = Completer<Repo?>();
      final container = ProviderContainer(
        overrides: [
          extensionsRepoStateProvider(ItemType.manga).overrideWith(_Repos.new),
          getRepoInfosProvider(jsonUrl: 'https://first.example/index.json')
              .overrideWith((ref) => first.future),
          getRepoInfosProvider(jsonUrl: 'https://second.example/index.json')
              .overrideWith((ref) => second.future),
        ],
      );
      addTearDown(container.dispose);
      final listener = container.listen(
        extensionsRepoStateProvider(ItemType.manga),
        (_, _) {},
      );
      addTearDown(listener.close);
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showMobileAddRepository(context, ItemType.manga),
            child: const Text('打开'),
          ),
        ),
        container,
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField),
        'https://first.example/index.json',
      );
      await tester.pump(const Duration(milliseconds: 700));
      await tester.enterText(
        find.byType(TextField),
        'https://second.example/index.json',
      );
      await tester.pump(const Duration(milliseconds: 700));
      second.complete(
        Repo(name: '第二目录', jsonUrl: 'https://second.example/index.json'),
      );
      await tester.pumpAndSettle();
      first.complete(
        Repo(name: '旧目录', jsonUrl: 'https://first.example/index.json'),
      );
      await tester.pumpAndSettle();
      expect(find.text('第二目录'), findsOneWidget);
      expect(find.text('旧目录'), findsNothing);
      await tester.tap(find.widgetWithText(FilledButton, '添加仓库'));
      await tester.pumpAndSettle();
      final notifier = container.read(
        extensionsRepoStateProvider(ItemType.manga).notifier,
      ) as _Repos;
      expect(notifier.writes, 1);
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField),
        'https://second.example/index.json',
      );
      await tester.pumpAndSettle();
      expect(find.text('此仓库已添加'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, '添加仓库'))
            .onPressed,
        isNull,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
