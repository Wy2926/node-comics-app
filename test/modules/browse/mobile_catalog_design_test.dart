import 'package:mangayomi/modules/browse/extension/providers/extensions_provider.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';

import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/mobile_sources_screen.dart';
import 'package:mangayomi/modules/browse/widgets/source_directory_filters.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/browse/widgets/source_website_card.dart';
import 'package:mangayomi/modules/browse/mobile_repositories.dart';
import 'package:mangayomi/modules/feedback/support_request_page.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/webview/mobile_browser_home.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';

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
  final repo = Repo(
    name: 'NodeLane 官方 · 本地开发',
    jsonUrl: 'http://127.0.0.1:8787/index.json',
  );
  final community = Repo(
    name: '社区目录',
    jsonUrl: 'https://example.org/index.json',
  );
  Future<void> mount(
    WidgetTester tester,
    Widget child,
    ProviderContainer container, {
    double scale = 1,
    bool tablet = false,
    bool reduceMotion = false,
  }) async {
    tester.view.physicalSize = tablet
        ? const Size(1180, 720)
        : const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => BotToastInit()(
            context,
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
                disableAnimations: reduceMotion,
              ),
              child: child!,
            ),
          ),
          navigatorObservers: [BotToastNavigatorObserver()],
          theme: ThemeData(
            platform: tablet ? TargetPlatform.android : TargetPlatform.iOS,
            colorSchemeSeed: NodeLaneTokens.defaultMobileAccent,
          ),
          home: Scaffold(body: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<ProviderContainer> mountCatalog(
    WidgetTester tester,
    Stream<List<Source>> entries, {
    double scale = 1,
    Future<void>? loading,
    bool tablet = false,
    bool reduceMotion = false,
  }) async {
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        extensionsRepoStateProvider(ItemType.manga).overrideWith(_Repos.new),
        hideItemsStateProvider.overrideWith(_Hidden.new),
        showNSFWStateProvider.overrideWith(_Nsfw.new),
        nodeLaneCatalogRepositoryProvider(ItemType.manga)
            .overrideWithValue(repo),
        nodeLaneCatalogLoadProvider(ItemType.manga).overrideWith((_) async {
          await loading;
        }),
        fetchItemSourcesListProvider(
          reFresh: false,
          itemType: ItemType.manga,
        ).overrideWith((_) async {}),
        mobileCatalogEntriesProvider(ItemType.manga)
            .overrideWith((_) => entries),
      ],
    );
    addTearDown(container.dispose);
    await mount(
      tester,
      const MobileSourcesScreen(),
      container,
      scale: scale,
      tablet: tablet,
      reduceMotion: reduceMotion,
    );
    return container;
  }

  testWidgets(
    'the filter stays anchored across tablet resize without moving or reserving space in the grid',
    (tester) async {
      await mountCatalog(
        tester,
        Stream.value([
          for (var i = 0; i < 45; i++)
            Source(
              id: i + 1,
              name: 'Site ${i.toString().padLeft(2, '0')}',
              lang: i.isEven ? 'en' : 'ja',
              repo: repo,
            ),
        ]),
        tablet: true,
      );
      Rect card(String name) =>
          tester.getRect(find.widgetWithText(SourceWebsiteCard, name));
      final before = card('Site 00');
      expect(before.top, card('Site 01').top);
      expect(card('Site 02').top, greaterThan(before.bottom));
      final panel = find.byType(SourceDirectoryFilterPanel);
      expect(panel, findsNothing);
      final chips = find.widgetWithText(FilterChip, '日本語');
      final trigger = find.byTooltip('筛选');
      final anchor = tester.getRect(trigger);
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(ModalRoute.of(tester.element(panel)), isA<PopupRoute>());
      expect(tester.getRect(panel).top, greaterThanOrEqualTo(anchor.bottom));
      expect(card('Site 00'), before);
      await tester.tap(chips);
      await tester.pumpAndSettle();
      expect(find.text('Site 00'), findsNothing);
      expect(card('Site 01'), before);
      expect(tester.widget<FilterChip>(chips).selected, isTrue);
      await tester.tap(find.descendant(of: panel, matching: find.text('形式')));
      await tester.pumpAndSettle();
      final state = tester.state(panel);
      tester.view.physicalSize = const Size(540, 800);
      await tester.pumpAndSettle();
      expect(tester.state(panel), same(state));
      expect(find.text('Site 00'), findsNothing);
      tester.view.physicalSize = const Size(1180, 720);
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: panel, matching: find.text('条漫')),
        findsOneWidget,
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(panel, findsNothing);
      expect(find.text('清空'), findsNothing);
      expect(card('Site 01'), before);
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(tester.widget<FilterChip>(chips).selected, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'anchored management menu opens one task and preserves form edits and directory search',
    (tester) async {
      FlutterSecureStorage.setMockInitialValues({});
      await mountCatalog(
        tester,
        Stream.value([Source(id: 1, name: 'Catalog', lang: 'en', repo: repo)]),
        tablet: true,
      );
      await tester.enterText(find.byType(TextField), 'Cat');
      await tester.pumpAndSettle();
      expect(find.byTooltip('申请新增来源'), findsNothing);
      expect(find.byTooltip('来源操作'), findsNothing);
      await tester.tap(find.text('管理'));
      await tester.pumpAndSettle();
      final trigger = tester.getRect(find.text('管理'));
      final first = tester.getRect(find.text('搜作品'));
      expect(first.top, greaterThanOrEqualTo(trigger.bottom));
      expect(first.right, greaterThan(trigger.left - 200));
      expect(find.byType(MobileRepositoryManager), findsNothing);
      await tester.tap(find.text('申请新增来源'));
      await tester.pumpAndSettle();
      expect(
        ModalRoute.of(tester.element(find.byType(SupportRequestPage))),
        isA<PageRoute>(),
      );
      expect(find.byType(BottomSheet), findsNothing);
      final name = find.byType(TextField).first,
          url = find.byType(TextField).at(1);
      expect(tester.getTopLeft(name).dy, tester.getTopLeft(url).dy);
      await tester.enterText(url, 'https://example.org/');
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Cat'), findsOneWidget);
      await tester.tap(find.text('管理'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('管理仓库'));
      await tester.pumpAndSettle();
      expect(
        NodeLaneBubbleFlow.contains(
          tester.element(find.byType(MobileRepositoryManager)),
        ),
        isTrue,
      );
      await tester.tap(find.text(repo.name!));
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(580, 665);
      await tester.pumpAndSettle();
      expect(find.text('复制目录链接').hitTestable(), findsOneWidget);
      await tester.tap(find.byTooltip('关闭').hitTestable());
      await tester.pumpAndSettle();
      await tester.tap(find.text('申请新增来源').hitTestable());
      await tester.pumpAndSettle();
      expect(find.text('https://example.org/'), findsOneWidget);
      tester.view.physicalSize = const Size(540, 800);
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(url).dy,
        greaterThan(tester.getTopLeft(name).dy),
      );
      expect(find.text('https://example.org/'), findsOneWidget);
      await tester.tap(find.byTooltip('返回'));
      await tester.pumpAndSettle();
      expect(find.text('Cat'), findsOneWidget);
      expect(find.text('Catalog'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'long language lists search by code; reduced motion opens and closes without intermediate layout',
    (tester) async {
      final codes = [
        'en',
        'de',
        'fr',
        'es',
        'it',
        'ko',
        'ar',
        'ja',
        'tr',
        'pl',
        'ru',
        'vi',
      ];
      await mountCatalog(
        tester,
        Stream.value([
          for (final (i, code) in codes.indexed)
            Source(id: i + 1, name: 'Website $code', lang: code, repo: repo),
        ]),
        tablet: true,
        reduceMotion: true,
      );
      final panel = find.byType(SourceDirectoryFilterPanel);
      final trigger = find.byTooltip('筛选');
      expect(panel, findsNothing);
      Rect first() =>
          tester.getRect(find.widgetWithText(SourceWebsiteCard, 'Website ar'));
      final before = first();
      await tester.tap(trigger);
      await tester.pump();
      final open = tester.getSize(panel);
      await tester.pump(const Duration(milliseconds: 80));
      expect(tester.getSize(panel), open);
      expect(first(), before);
      await tester.enterText(
        find.descendant(of: panel, matching: find.byType(TextField)),
        'JA',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilterChip, '日本語'));
      await tester.pumpAndSettle();
      expect(find.text('Website ja'), findsOneWidget);
      expect(
        find.descendant(of: panel, matching: find.textContaining('1 个结果')),
        findsOneWidget,
      );
      await tester.tap(find.text('清空'));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(first(), before);
      expect(panel, findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'directory actions and search stay reachable at text scale $scale',
      (tester) async {
        final container = await mountCatalog(
          tester,
          Stream.value([
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
            Source(
              id: 3,
              name: 'Community Installed',
              lang: 'en',
              repo: community,
              isAdded: true,
              sourceCode: 'existing',
              version: '1.0.0',
              versionLast: '2.0.0',
            ),
            Source(
              id: 4,
              name: 'Community Available',
              lang: 'en',
              repo: community,
            ),
          ]),
          scale: scale,
        );
        expect(find.text('MangaDex'), findsOneWidget);
        await tester.tap(find.text('编辑'));
        await tester.pumpAndSettle();
        expect(find.byTooltip('取消常用'), findsOneWidget);
        expect(find.byTooltip('固定到常用'), findsOneWidget);
        await tester.tap(find.text('完成'));
        await tester.pumpAndSettle();
        await tester.longPress(find.text('MangaDex'));
        await tester.pumpAndSettle();
        expect(find.text('最新内容'), findsOneWidget);
        expect(find.text('来源设置'), findsOneWidget);
        Navigator.of(tester.element(find.text('最新内容'))).pop();
        await tester.pumpAndSettle();
        expect(find.text('安装'), findsNothing);
        expect(find.text('更新'), findsNothing);
        expect(find.textContaining('NodeLane 官方'), findsNothing);
        expect(find.textContaining('127.0.0.1'), findsNothing);
        expect(find.text('Community Available'), findsNothing);
        await tester.tap(find.text('第三方'));
        await tester.pumpAndSettle();
        expect(find.text('MangaDex'), findsNothing);
        expect(find.text('WEBTOON'), findsNothing);
        expect(find.text('Community Available'), findsOneWidget);
        expect(find.text('安装'), findsOneWidget);
        expect(find.text('更新'), findsOneWidget);
        expect(find.text('管理仓库'), findsOneWidget);
        expect(find.byType(SourceWebsiteCard), findsNWidgets(2));
        await tester.longPress(find.text('Community Installed'));
        await tester.pumpAndSettle();
        expect(container.read(isLongPressedStateProvider), isFalse);
        expect(find.text('来源设置'), findsOneWidget);
        Navigator.of(tester.element(find.text('来源设置'))).pop();
        await tester.pumpAndSettle();
        await tester.tap(find.text('管理'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('批量管理'));
        await tester.tap(find.text('批量管理'));
        await tester.pumpAndSettle();
        expect(container.read(isLongPressedStateProvider), isTrue);
        await tester.tap(find.text('Community Installed'));
        await tester.pumpAndSettle();
        expect(find.text('已选择 1 项'), findsOneWidget);
        expect(find.text('第三方'), findsNothing);
        expect(find.text('卸载').hitTestable(), findsOneWidget);
        await tester.tap(find.text('取消'));
        await tester.pumpAndSettle();
        expect(container.read(isLongPressedStateProvider), isFalse);
        await tester.enterText(find.byType(TextField), 'missing');
        await tester.pumpAndSettle();
        expect(find.text('没有匹配的网站'), findsOneWidget);
        tester.view.viewInsets = const FakeViewPadding(bottom: 320);
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('跨来源搜索'));
        await tester.pumpAndSettle();
        expect(find.text('跨来源搜索').hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets(
    'catalog failures float once without moving the cached directory',
    (tester) async {
      final loading = Completer<void>();
      await mountCatalog(
        tester,
        Stream.value([
          Source(id: 1, name: 'Cached site', lang: 'en', repo: repo),
        ]),
        loading: loading.future,
      );
      final before = tester.getRect(find.text('Cached site'));
      loading.completeError(StateError('private endpoint'));
      await tester.pumpAndSettle();
      expect(find.byType(NodeLaneNotice), findsOneWidget);
      expect(tester.getRect(find.text('Cached site')), before);
      expect(find.textContaining('private endpoint'), findsNothing);
      expect(
        find.descendant(
          of: find.byType(CustomScrollView),
          matching: find.text('目录加载失败，可下拉重试。'),
        ),
        findsNothing,
      );
      await tester.pump(const Duration(seconds: 7));
      await tester.pumpAndSettle();
      expect(find.byType(NodeLaneNotice), findsNothing);
      await tester.enterText(find.byType(TextField), 'Cached');
      await tester.pumpAndSettle();
      expect(find.byType(NodeLaneNotice), findsNothing);
      expect(find.text('Cached site'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
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
      await mountCatalog(
        tester,
        Stream.value([
          english,
          japanese,
          Source(id: 3, name: 'English site', lang: 'en', repo: community),
        ]),
      );
      await tester.tap(find.byTooltip('筛选'));
      await tester.pumpAndSettle();
      final all = find.widgetWithText(FilterChip, '全部语言');
      await tester.tap(all);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(SourceDirectoryFilterPanel),
          matching: find.textContaining('2 个结果'),
        ),
        findsOneWidget,
      );
      await tester.tap(all);
      await tester.pumpAndSettle();
      expect(find.text('Japanese site'), findsNothing);
      final japaneseChoice = find.widgetWithText(FilterChip, '日本語');
      await tester.ensureVisible(japaneseChoice);
      await tester.tap(japaneseChoice);
      await tester.pumpAndSettle();
      expect(find.text('Japanese site'), findsOneWidget);
      expect(find.text('English site'), findsNothing);
      expect(english.isAdded, isTrue);
      expect(english.isActive, isTrue);
      expect(japanese.isAdded, isFalse);
      expect(japanese.isActive, isFalse);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Japanese');
      await tester.tap(find.text('第三方'));
      await tester.pumpAndSettle();
      expect(find.text('English site'), findsOneWidget);
      expect(find.text('Japanese site'), findsNothing);
      await tester.tap(find.text('NodeLane'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        'Japanese',
      );
      expect(find.text('Japanese site'), findsOneWidget);
      expect(find.text('English site'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'bubble facets intersect groups, follow catalog updates and clear without losing the query',
    (tester) async {
      final entries = StreamController<List<Source>>();
      addTearDown(entries.close);
      Source site(
        int id,
        String region,
        String price, {
        String? name,
        bool adult = false,
      }) => Source(
        id: id,
        name: name ?? 'Site $id',
        lang: 'en',
        repo: repo,
        isNsfw: adult,
        isPinned: id == 1,
        catalogMetadataJson:
            '{"schema":1,"regions":["$region"],"pricing":"$price"}',
      );
      final initial = [
        site(1, 'jp', 'free'),
        site(2, 'kr', 'paid'),
        site(3, 'jp', 'unknown'),
        site(4, 'jp', 'free', name: 'Archive'),
        site(5, 'jp', 'free', adult: true),
      ];
      entries.add(initial);
      await mountCatalog(tester, entries.stream, scale: 1.5);
      await tester.enterText(find.byType(TextField), 'Site');
      await tester.pumpAndSettle();
      final panel = find.byType(SourceDirectoryFilterPanel);
      Finder inside(String text) =>
          find.descendant(of: panel, matching: find.text(text));
      Finder bubbleCount(int n) => find.descendant(
        of: find.byType(NodeLaneBubblePanel),
        matching: find.textContaining('$n 个结果'),
      );
      Future<void> tap(Finder finder) async {
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      await tap(find.byTooltip('筛选'));
      expect(inside('地区'), findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);
      await tap(inside('收费'));
      expect(bubbleCount(3), findsOneWidget);
      await tap(find.widgetWithText(FilterChip, '免费阅读'));
      expect(bubbleCount(1), findsOneWidget);
      await tap(inside('付费阅读'));
      expect(bubbleCount(2), findsOneWidget);
      await tap(inside('地区'));
      await tap(inside('日漫'));
      expect(bubbleCount(1), findsOneWidget);
      entries.add([...initial, site(6, 'jp', 'paid')]);
      await tester.pumpAndSettle();
      expect(bubbleCount(2), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Site 1'), findsOneWidget);
      expect(find.text('Site 2'), findsNothing);
      expect(find.text('Site 3'), findsNothing);
      await tap(find.byTooltip('筛选'));
      await tap(inside('收费'));
      await tap(find.widgetWithText(FilterChip, '免费阅读'));
      expect(bubbleCount(1), findsOneWidget);
      await tap(find.text('清空').hitTestable());
      expect(bubbleCount(4), findsOneWidget);
      await tap(inside('地区'));
      await tap(inside('国漫'));
      expect(bubbleCount(0), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('没有匹配的网站'), findsOneWidget);
      await tap(find.byTooltip('清除搜索'));
      expect(find.text('清空'), findsNothing);
      await tap(find.byTooltip('筛选'));
      await tap(find.text('清空'));
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel(RegExp('5 个结果')), findsOneWidget);
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
