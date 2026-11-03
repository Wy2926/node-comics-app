import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_card.dart';
import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_empty.dart';
import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_header.dart';
import 'package:mangayomi/modules/main_view/widgets/nodelane_mobile_navigation.dart';

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
  test('display mode owns density and narrow screens keep usable cards', () {
    expect(mobileBookshelfColumns(350, comfortable: true), 2);
    expect(mobileBookshelfColumns(350, comfortable: false), 3);
    expect(mobileBookshelfColumns(280, comfortable: false), 2);
    expect(mobileBookshelfColumns(700, comfortable: true), 4);
  });

  testWidgets(
    'different title lengths keep cover sizes aligned and selection hides resume',
    (tester) async {
      final image = MemoryImage(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aX1cAAAAASUVORK5CYII=',
        ),
      );
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
                        image: image,
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
    'narrow shelf keeps search, clear and import reachable with large text',
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
            child: SizedBox(
              height: MobileBookshelfHeader.preferredHeight(2),
              child: MobileBookshelfHeader(
                title: '书架',
                searchLabel: '搜索',
                importLabel: '导入',
                filterLabel: '筛选',
                controller: controller,
                onSearchChanged: () => changes++,
                onImport: () => imports++,
                onFilter: () => filters++,
                mediaMenu: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('漫画', style: TextStyle(fontSize: 13)),
                ),
                menu: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                ),
                filtered: true,
              ),
            ),
          ),
          scale: 2,
        ),
      );
      await tester.enterText(find.byType(TextField), '月');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.cancel_rounded));
      await tester.tap(find.byTooltip('导入'));
      await tester.tap(find.byTooltip('筛选'));
      expect(controller.text, isEmpty);
      expect((changes, imports, filters), (2, 1, 1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('card action slots do not trigger the enclosing book action', (
    tester,
  ) async {
    final image = MemoryImage(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aX1cAAAAASUVORK5CYII=',
      ),
    );
    var opens = 0, selections = 0, resumes = 0;
    await tester.pumpWidget(
      app(
        Center(
          child: SizedBox(
            width: 140,
            height: 330,
            child: MobileBookshelfCard(
              title: '很长的漫画书名，用于两行排版',
              subtitle: '本地 · ZH',
              image: image,
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
          child: MobileBookshelfEmpty(
            title: '书架还是空的',
            primaryLabel: '导入',
            onPrimary: () => imports++,
            secondaryLabel: '浏览',
            onSecondary: () {},
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
            .widget<AndroidMobileTabBar>(find.byType(AndroidMobileTabBar))
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
