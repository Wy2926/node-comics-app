import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_header.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_source_card.dart';
import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_header.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Widget _app(Widget child, {bool dark = false}) => MaterialApp(
  theme: ThemeData(
    platform: TargetPlatform.iOS,
    brightness: dark ? Brightness.dark : Brightness.light,
  ),
  locale: const Locale('en'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: NodeLaneSurface(
    child: Scaffold(body: SafeArea(child: child)),
  ),
);

void main() {
  testWidgets(
    'shelf heading retains independent media, import, filter and clear actions',
    (tester) async {
      _phone(tester);
      final input = TextEditingController();
      addTearDown(input.dispose);
      var imports = 0, filters = 0, changes = 0;
      final media = <ItemType>[];
      await tester.pumpWidget(
        _app(
          Column(
            children: [
              SizedBox(
                height: MobileBookshelfHeader.preferredHeight(1),
                child: MobileBookshelfHeader(
                  title: 'Library',
                  searchLabel: 'Search',
                  importLabel: 'Import',
                  filterLabel: 'Filter',
                  controller: input,
                  onSearchChanged: () => changes++,
                  onImport: () => imports++,
                  onFilter: () => filters++,
                  mediaMenu: MobileMediaMenu(
                    value: ItemType.manga,
                    availableTypes: ItemType.values,
                    onChanged: media.add,
                  ),
                  menu: IconButton(
                    tooltip: 'More',
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz),
                  ),
                  filtered: false,
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      await tester.enterText(find.byType(TextField), 'sea');
      await tester.pump();
      expect(changes, 1);
      await tester.tap(find.byTooltip('Delete'));
      await tester.pump();
      expect(input.text, isEmpty);
      expect(changes, 2);
      await tester.tap(find.byTooltip('Import'));
      await tester.tap(find.byTooltip('Filter'));
      expect([imports, filters], [1, 1]);
      await tester.tap(find.byType(MobileMediaMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(PopupMenuItem<ItemType>, 'Novel'));
      await tester.pumpAndSettle();
      expect(media, [ItemType.novel]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'browse segments retain drafts and restore the heading after keyboard dismissal',
    (tester) async {
      _phone(tester);
      final input = TextEditingController();
      addTearDown(input.dispose);
      var extensions = false, selections = 0, searches = 0;
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (context, setState) => Column(
              children: [
                MobileBrowseHeader(
                  title: 'Browse',
                  mediaMenu: const Text('Manga'),
                  sourcesLabel: 'Sources',
                  extensionsLabel: 'Extensions',
                  extensionsSelected: extensions,
                  onSectionChanged: (value) => setState(() {
                    extensions = value;
                    selections++;
                  }),
                  searchHint: extensions
                      ? 'Search extensions'
                      : 'Global search',
                  searchController: input,
                  onQueryChanged: (_) => setState(() {}),
                  onGlobalSearch: () => searches++,
                  filterLabel: 'Filter',
                  onFilter: () {},
                  clearLabel: 'Clear',
                  actions: const [],
                  updateCount: 3,
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          dark: true,
        ),
      );
      await tester.tap(find.text('Global search'));
      expect(searches, 1);
      await tester.tap(find.text('Extensions'));
      await tester.pump();
      await tester.tap(find.text('Extensions'));
      expect(selections, 1);
      await tester.enterText(find.byType(TextField), 'draft');
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      expect(find.text('Browse'), findsNothing);
      expect(input.text, 'draft');
      tester.view.resetViewInsets();
      await tester.pumpAndSettle();
      expect(find.text('Browse'), findsOneWidget);
      await tester.tap(find.text('Sources'));
      await tester.pump();
      await tester.tap(find.text('Extensions'));
      await tester.pump();
      expect(input.text, 'draft');
      await tester.tap(find.byTooltip('Clear'));
      await tester.pump();
      expect(input.text, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'inline choices select once and source actions remain independent',
    (tester) async {
      _phone(tester);
      var value = 0, changes = 0, opened = 0, latest = 0;
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (context, setState) => ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: NodeLaneGroupSurface(
                    child: NodeLaneChoiceRow<int>(
                      title: 'Unread',
                      value: value,
                      segments: const [
                        ButtonSegment(value: 0, label: Text('Any')),
                        ButtonSegment(value: 1, label: Text('Include')),
                        ButtonSegment(value: 2, label: Text('Exclude')),
                      ],
                      onChanged: (next) => setState(() {
                        value = next;
                        changes++;
                      }),
                    ),
                  ),
                ),
                MobileSourceCard(
                  title: 'Local source',
                  icon: const Icon(Icons.folder),
                  onTap: () => opened++,
                  actions: TextButton(
                    onPressed: () => latest++,
                    child: const Text('Latest'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      expect(
        tester.getCenter(find.text('Unread')).dy,
        closeTo(tester.getCenter(find.text('Any')).dy, 1),
      );
      await tester.tap(find.text('Include'));
      await tester.pump();
      await tester.tap(find.text('Include'));
      expect([value, changes], [1, 1]);
      await tester.tap(find.text('Latest'));
      expect([opened, latest], [0, 1]);
      await tester.tap(find.text('Local source'));
      expect(opened, 1);
      expect(tester.takeException(), isNull);
    },
  );
}
