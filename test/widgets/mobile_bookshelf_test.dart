import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_card.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_header.dart';
import 'package:mangayomi/modules/main_view/widgets/nodelane_mobile_navigation.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_glass_surface.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

final coverImage = MemoryImage(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aX1cAAAAASUVORK5CYII=',
  ),
);

Widget app(Widget child, {double scale = 1, bool dark = false}) => MaterialApp(
  locale: const Locale('zh'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
  home: Scaffold(body: child),
);

void main() {
  testWidgets(
    'floating tabs keep safe area, RTL targets and accessible badges',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      String? selected;
      Widget navigation(bool highContrast) => app(
        MediaQuery(
          data: MediaQueryData(
            size: const Size(320, 700),
            viewPadding: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.only(bottom: 24),
            textScaler: const TextScaler.linear(2),
            highContrast: highContrast,
            disableAnimations: true,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: NodeLaneMobileNavigation(
                routes: const [
                  '/MangaLibrary',
                  '/updates',
                  '/browse',
                  '/browser',
                  '/more',
                ],
                location: '/MangaLibrary',
                visible: true,
                nativeIos: false,
                badges: const {'/updates': 120},
                onSelected: (value) => selected = value,
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(navigation(false));
      await tester.pumpAndSettle();
      final rect = tester.getRect(find.byType(NodeLaneGlassSurface));
      expect(rect.left, 16);
      expect(rect.right, 304);
      expect(rect.bottom, 700 - 24 - 8);
      expect(
        tester.getCenter(find.text('书架')).dx,
        greaterThan(tester.getCenter(find.text('更多')).dx),
      );
      expect(find.text('99+'), findsOneWidget);
      expect(tester.getSemantics(find.bySemanticsLabel('更新')).value, '120');
      await tester.tap(find.text('来源'));
      expect(selected, '/browse');
      await tester.pumpWidget(navigation(true));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(NodeLaneGlassSurface)), rect);
      expect(find.byType(BackdropFilter), findsNothing);
      await tester.tap(find.text('更多'));
      expect(selected, '/more');
      expect(tester.takeException(), isNull);
    },
  );

  test('display mode owns density and narrow screens keep usable cards', () {
    expect(mobileBookshelfColumns(350, comfortable: true), 2);
    expect(mobileBookshelfColumns(350, comfortable: false), 3);
    expect(mobileBookshelfColumns(280, comfortable: false), 2);
    expect(mobileBookshelfColumns(700, comfortable: true), 4);
    expect(
      mobileBookshelfColumns(
        350,
        comfortable: false,
        textScaler: TextScaler.linear(2),
      ),
      1,
    );
  });

  for (final mode in ['list', 'comfortable', 'compact', 'cover']) {
    testWidgets(
      '$mode keeps one local identity and a separate download count',
      (tester) async {
        final list = mode == 'list', coverOnly = mode == 'cover';
        await tester.pumpWidget(
          app(
            Center(
              child: SizedBox(
                width: list
                    ? 350
                    : mode == 'comfortable'
                    ? 168
                    : 106,
                height: list ? null : 320,
                child: MobileBookshelfCard(
                  title: '海岸来信',
                  image: coverImage,
                  selected: false,
                  isLocal: true,
                  source: 'Local',
                  language: 'local',
                  unreadCount: 12,
                  downloadCount: 3,
                  list: list,
                  coverOnly: coverOnly,
                  onTap: () {},
                  onLongPress: () {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final card = find.byType(MobileBookshelfCard);
        final folder = NodeLaneIcons.of(tester.element(card)).folderOutline;
        expect(find.byIcon(folder), coverOnly ? findsOneWidget : findsNothing);
        expect(find.textContaining('Local', findRichText: true), findsNothing);
        expect(find.textContaining('LOCAL', findRichText: true), findsNothing);
        final metadata = find.byWidgetPredicate(
          (w) => w is Text && w.semanticsLabel == '本地',
        );
        expect(metadata, coverOnly ? findsNothing : findsOneWidget);
        final badges = find.byType(NodeLaneCoverBadge);
        expect(badges, findsNWidgets(coverOnly ? 3 : 2));
        final download = find.byWidgetPredicate(
          (w) => w is NodeLaneCoverBadge && w.label == '3',
        );
        final cover = tester.getRect(find.byType(Image));
        if (!list) {
          expect(tester.getRect(download).bottom, lessThan(cover.bottom));
        } else {
          expect(
            tester.getCenter(metadata).dy,
            closeTo(tester.getCenter(download).dy, .5),
          );
          if (!list) {
            expect(tester.getRect(download).top, greaterThan(cover.bottom));
          }
        }
        expect(
          tester.getRect(download).right,
          lessThanOrEqualTo(tester.getRect(card).right),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'hidden local identity never falls back to archive source or language',
    (tester) async {
      await tester.pumpWidget(
        app(
          SizedBox(
            width: 168,
            height: 320,
            child: MobileBookshelfCard(
              title: '本地作品',
              image: coverImage,
              selected: false,
              isLocal: true,
              showLocal: false,
              source: 'Local',
              language: 'local',
              onTap: () {},
              onLongPress: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NodeLaneCoverBadge), findsNothing);
      expect(
        find.byWidgetPredicate((w) => w is Text && w.semanticsLabel != null),
        findsNothing,
      );
      expect(find.textContaining('LOCAL', findRichText: true), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'remote identity and download share one line, including long sources',
    (tester) async {
      await tester.pumpWidget(
        app(
          Center(
            child: SizedBox(
              width: 350,
              child: MobileBookshelfCard(
                title: '雨后的街角',
                list: true,
                image: coverImage,
                selected: false,
                source: '  很长的示例来源  ',
                language: 'zh',
                downloadCount: 3,
                onTap: () {},
                onLongPress: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final identity = find.byWidgetPredicate(
        (w) => w is Text && w.semanticsLabel == '很长的示例来源 · ZH',
      );
      expect(identity, findsOneWidget);
      final badge = find.byType(NodeLaneCoverBadge);
      expect(tester.getCenter(identity).dy, tester.getCenter(badge).dy);
      expect(
        tester.getRect(identity).right,
        lessThan(tester.getRect(badge).left),
      );
      final t = NodeLaneTokens.of(tester.element(badge));
      final background = tester.widget<Container>(
        find.descendant(of: badge, matching: find.byType(Container)),
      );
      expect((background.decoration! as BoxDecoration).color, t.soft);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'large counts keep real semantics and selection retains one local label',
    (tester) async {
      final semantics = tester.ensureSemantics();
      var selecting = false;
      late StateSetter change;
      await tester.pumpWidget(
        app(
          StatefulBuilder(
            builder: (context, setState) {
              change = setState;
              return Center(
                child: SizedBox(
                  width: 168,
                  height: 350,
                  child: MobileBookshelfCard(
                    title: '海岸来信',
                    image: coverImage,
                    selected: selecting,
                    isLocal: true,
                    source: '本地',
                    language: 'zh',
                    unreadCount: 1234,
                    downloadCount: 2345,
                    onTap: () {},
                    onLongPress: () {},
                    continueButton: NodeLaneIconButton(
                      icon: Icons.book,
                      tooltip: '继续',
                      onPressed: () {},
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('999+'), findsNWidgets(2));
      expect(find.bySemanticsLabel(RegExp(r': 1234')), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp(r': 2345')), findsOneWidget);
      final before = tester.getRect(find.byType(Image));
      change(() => selecting = true);
      await tester.pumpAndSettle();
      expect(find.byType(NodeLaneCoverBadge), findsOneWidget);
      expect(find.text('999+'), findsNothing);
      expect(find.byTooltip('继续'), findsNothing);
      expect(
        find.byWidgetPredicate((w) => w is Text && w.semanticsLabel == '本地'),
        findsOneWidget,
      );
      expect(tester.getRect(find.byType(Image)), before);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    },
  );

  testWidgets(
    'responsive cards fit titles, metadata and accessibility text settings',
    (tester) async {
      for (final (scale, list, local, metadata, lineHeight) in [
        (1.0, false, false, false, null),
        (1.0, false, false, false, 2.0),
        (1.3, false, false, true, null),
        (2.0, false, true, true, 2.0),
        (2.5, false, false, true, null),
        (1.0, true, false, true, null),
        (1.0, true, true, true, null),
        (2.0, true, true, true, null),
        (2.5, true, false, true, null),
      ]) {
        final title = metadata ? '书名比较长时仍然保留最多两行' : '던전을 그리는 화가';
        await tester.pumpWidget(
          app(
            MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(scale),
                lineHeightScaleFactorOverride: lineHeight,
              ),
              child: Builder(
                builder: (context) {
                  final columns = mobileBookshelfColumns(
                    280,
                    comfortable: false,
                    textScaler: MediaQuery.textScalerOf(context),
                  );
                  // Match the compact emulator card for the title-only regression.
                  final width = metadata
                      ? (280 - (columns - 1) * NodeLaneTokens.shelfGap) /
                            columns
                      : 114.5;
                  return Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: list ? 280 : width,
                      height: list
                          ? null
                          : width * NodeLaneTokens.shelfCoverAspectRatio +
                                MobileBookshelfCard.captionHeight(
                                  context,
                                  metadata: metadata,
                                ),
                      child: MobileBookshelfCard(
                        title: title,
                        image: coverImage,
                        selected: false,
                        list: list,
                        isLocal: local,
                        source: metadata ? '示例来源' : null,
                        language: metadata ? 'zh' : null,
                        unreadCount: 1234,
                        downloadCount: metadata ? 2345 : 0,
                        onTap: () {},
                        onLongPress: () {},
                        continueButton: NodeLaneIconButton(
                          icon: Icons.book,
                          tooltip: '继续',
                          onPressed: () {},
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            dark: scale > 1,
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason:
              'scale=$scale list=$list local=$local metadata=$metadata lineHeight=$lineHeight',
        );
        expect(
          tester.getSize(find.byType(NodeLaneIconButton)),
          const Size(44, 44),
        );
        final titleRect = tester.getRect(find.text(title));
        final cardRect = tester.getRect(find.byType(MobileBookshelfCard));
        expect(titleRect.bottom, lessThanOrEqualTo(cardRect.bottom));
        if (!list) {
          final coverRect = tester.getRect(find.byType(Image));
          expect(
            titleRect.top - coverRect.bottom,
            closeTo(NodeLaneTokens.space8, .001),
          );
          expect(
            coverRect.height,
            closeTo(
              coverRect.width * NodeLaneTokens.shelfCoverAspectRatio,
              .001,
            ),
          );
        }
      }
    },
  );

  testWidgets(
    'different title lengths keep cover sizes aligned and selection hides resume',
    (tester) async {
      var selecting = false;
      late StateSetter change;
      await tester.pumpWidget(
        app(
          StatefulBuilder(
            builder: (context, setState) {
              change = setState;
              return Row(
                children: [
                  for (final title in ['短名', '比较长的漫画名称会占据两行空间'])
                    SizedBox(
                      width: 150,
                      height: 300,
                      child: MobileBookshelfCard(
                        title: title,
                        image: coverImage,
                        selected: false,
                        selectionMode: selecting,
                        unreadCount: 12,
                        onTap: () {},
                        onLongPress: () {},
                        continueButton: IconButton(
                          tooltip: '继续',
                          onPressed: () {},
                          icon: const Icon(Icons.book),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      final sizes = tester
          .widgetList<Image>(find.byType(Image))
          .map((widget) => tester.getSize(find.byWidget(widget)))
          .toList();
      expect(sizes[0], sizes[1]);
      expect(find.byTooltip('继续'), findsNWidgets(2));
      change(() => selecting = true);
      await tester.pumpAndSettle();
      expect(find.byTooltip('继续'), findsNothing);
      expect(find.text('12'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'opening a detail page does not clamp the retained shelf scroll position',
    (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      var covered = false;
      await tester.pumpWidget(
        app(
          StatefulBuilder(
            builder: (context, setState) => Scaffold(
              extendBody: true,
              bottomNavigationBar: NodeLaneMobileNavigation(
                routes: const ['/MangaLibrary', '/browse', '/more'],
                location: covered ? '/mangaDetail' : '/MangaLibrary',
                visible: !covered,
                maintainSpace: true,
                nativeIos: false,
                onSelected: (_) {},
              ),
              body: Scaffold(
                body: Builder(
                  builder: (bodyContext) => ListView.builder(
                    controller: controller,
                    itemCount: 30,
                    itemExtent: 100,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(bodyContext).bottom + 24,
                    ),
                    itemBuilder: (context, index) => ListTile(
                      title: Text('Book $index'),
                      onTap: () async {
                        setState(() => covered = true);
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => Scaffold(
                              appBar: AppBar(title: const Text('Detail')),
                            ),
                          ),
                        );
                        setState(() => covered = false);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pumpAndSettle();
      final before = controller.offset;
      await tester.tap(find.text('Book 29'));
      await tester.pumpAndSettle();
      expect(find.text('Detail'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(controller.offset, closeTo(before, .5));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'shelf search dismisses on outside touch without losing the query or action access',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var changes = 0, imports = 0, filters = 0;
      await tester.pumpWidget(
        app(
          Align(
            alignment: Alignment.topCenter,
            child: Builder(
              builder: (context) => SizedBox(
                height: MobileBookshelfHeader.preferredHeight(context),
                child: MobileBookshelfHeader(
                  searchLabel: '搜索',
                  importLabel: '导入',
                  filterLabel: '筛选',
                  controller: controller,
                  onSearchChanged: () => changes++,
                  onImport: () => imports++,
                  onFilter: () => filters++,
                  mediaMenu: MobileMediaMenu(
                    value: ItemType.manga,
                    availableTypes: ItemType.values,
                    onChanged: (_) {},
                  ),
                  menu: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz),
                  ),
                  filtered: true,
                ),
              ),
            ),
          ),
          scale: 2,
        ),
      );
      final field = find.byType(TextField);
      final input = tester.widget<EditableText>(find.byType(EditableText));
      await tester.tap(field);
      await tester.pump();
      expect(input.focusNode.hasFocus, isTrue);
      expect(tester.testTextInput.isVisible, isTrue);
      await tester.tapAt(const Offset(160, 600));
      await tester.pump();
      expect(input.focusNode.hasFocus, isFalse);
      expect(tester.testTextInput.isVisible, isFalse);

      await tester.enterText(find.byType(TextField), '月');
      await tester.pump();
      await tester.dragFrom(const Offset(160, 600), const Offset(0, -100));
      await tester.pump();
      expect(input.focusNode.hasFocus, isFalse);
      expect(tester.testTextInput.isVisible, isFalse);
      expect(controller.text, '月');

      await tester.tap(field);
      await tester.pump();
      await tester.tap(
        find.byIcon(NodeLaneIcons.of(tester.element(field)).clear),
      );
      await tester.pump();
      expect(input.focusNode.hasFocus, isTrue);
      await tester.tap(find.byTooltip('导入'));
      await tester.tap(find.byTooltip('筛选'));
      expect(controller.text, isEmpty);
      expect((changes, imports, filters), (2, 1, 1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'category pills keep taps and page swipes in sync at large text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        app(
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const NodeLaneTabSegments(
                  scrollable: true,
                  labels: ['全部 12', '收藏 8', '计划阅读 4'],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      Center(child: Text('全部内容')),
                      Center(child: Text('收藏内容')),
                      Center(child: Text('计划内容')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          scale: 2,
        ),
      );
      await tester.pumpAndSettle();
      final controller = tester.widget<TabBar>(find.byType(TabBar)).controller!;
      await tester.ensureVisible(find.text('收藏 8'));
      await tester.tap(find.text('收藏 8'));
      await tester.pumpAndSettle();
      expect(controller.index, 1);
      expect(find.text('收藏内容'), findsOneWidget);
      await tester.drag(find.byType(TabBarView), const Offset(-280, 0));
      await tester.pumpAndSettle();
      expect(controller.index, 2);
      expect(find.text('计划内容'), findsOneWidget);
      expect(tester.getRect(find.text('计划阅读 4')).right, lessThanOrEqualTo(320));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('card action slots do not trigger the enclosing book action', (
    tester,
  ) async {
    var opens = 0, selections = 0, resumes = 0;
    await tester.pumpWidget(
      app(
        Center(
          child: SizedBox(
            width: 140,
            height: 330,
            child: MobileBookshelfCard(
              title: '很长的漫画书名，用于两行排版',
              isLocal: true,
              image: coverImage,
              selected: false,
              onTap: () => opens++,
              onLongPress: () => selections++,
              continueButton: IconButton(
                tooltip: '继续',
                onPressed: () => resumes++,
                icon: const Icon(Icons.play_arrow),
              ),
            ),
          ),
        ),
        scale: 2,
        dark: true,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('继续'));
    expect((opens, resumes), (0, 1));
    await tester.longPress(find.text('很长的漫画书名，用于两行排版'));
    expect(selections, 1);
    await tester.tap(find.text('很长的漫画书名，用于两行排版'));
    expect(opens, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty state remains scrollable when space is constrained', (
    tester,
  ) async {
    var imports = 0;
    await tester.pumpWidget(
      app(
        SizedBox(
          height: 200,
          width: 320,
          child: NodeLaneEmptyState(
            scrollable: true,
            icon: Icons.book,
            title: '书架还是空的',
            action: FilledButton(
              onPressed: () => imports++,
              child: const Text('导入'),
            ),
          ),
        ),
        scale: 2,
      ),
    );
    await tester.ensureVisible(find.text('导入'));
    expect(tester.getCenter(find.widgetWithText(FilledButton, '导入')).dx, 160);
    await tester.tap(find.text('导入'));
    expect(imports, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'mobile navigation remembers media, exposes overflow and respects hidden routes',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var location = '/NovelLibrary';
      var routes = [
        '/MangaLibrary',
        '/AnimeLibrary',
        '/NovelLibrary',
        '/updates',
        '/browse',
        '/browser',
        '/more',
        '/trackerLibrary',
      ];
      Future<void> render() => tester.pumpWidget(
        app(
          Align(
            alignment: Alignment.bottomCenter,
            child: NodeLaneMobileNavigation(
              routes: routes,
              location: location,
              visible: true,
              nativeIos: false,
              onSelected: (value) => location = value,
            ),
          ),
          scale: 2,
          dark: true,
        ),
      );
      await render();
      expect(
        tester
            .widget<NodeLaneFlutterTabBar>(find.byType(NodeLaneFlutterTabBar))
            .items
            .length,
        5,
      );
      await tester.tap(find.text('浏览器'));
      await render();
      await tester.tap(find.text('书架'));
      expect(location, '/NovelLibrary');
      await render();
      await tester.tap(find.text('更多'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('追踪'));
      await tester.pumpAndSettle();
      expect(location, '/trackerLibrary');
      routes = ['/AnimeLibrary', '/updates', '/browse', '/more'];
      await render();
      await tester.tap(find.text('书架'));
      expect(location, '/AnimeLibrary');
      expect(tester.takeException(), isNull);
    },
  );
}
