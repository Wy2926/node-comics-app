import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class _Routes extends NavigatorObserver {
  final pushed = <Route<dynamic>>[];
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      pushed.add(route);
}

Widget _app(Widget child, {ThemeData? theme, NavigatorObserver? observer}) =>
    MaterialApp(
      theme: nodeLaneModalTheme(
        theme ?? ThemeData(platform: TargetPlatform.iOS),
      ),
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: [?observer],
      home: Scaffold(body: SafeArea(child: child)),
    );

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets(
    'media menu uses the root overlay and preserves cancel/current selection',
    (tester) async {
      _phone(tester);
      final root = _Routes(), nested = _Routes();
      final changes = <ItemType>[];
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          Navigator(
            observers: [nested],
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: MobileMediaMenu(
                    value: ItemType.manga,
                    availableTypes: ItemType.values,
                    onChanged: changes.add,
                    badgeBuilder: (type) =>
                        type == ItemType.novel ? const Text('7') : null,
                  ),
                ),
              ),
            ),
          ),
          observer: root,
        ),
      );
      try {
        expect(
          tester
              .getSemantics(find.byType(MobileMediaMenu))
              .getSemanticsData()
              .flagsCollection
              .isButton,
          isTrue,
        );
      } finally {
        semantics.dispose();
      }
      Future<void> open() async {
        await tester.tap(find.byType(MobileMediaMenu));
        await tester.pumpAndSettle();
        expect(find.byType(PopupMenuItem<ItemType>), findsNWidgets(3));
        expect(root.pushed.last, isA<PopupRoute<dynamic>>());
        expect(nested.pushed, hasLength(1));
        expect(find.text('7'), findsOneWidget);
      }

      await open();
      await tester.tap(find.widgetWithText(PopupMenuItem<ItemType>, 'Manga'));
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
      await open();
      await tester.tapAt(const Offset(380, 800));
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
      await open();
      await tester.tap(find.widgetWithText(PopupMenuItem<ItemType>, 'Novel'));
      await tester.pumpAndSettle();
      expect(changes, [ItemType.novel]);
      expect(find.byType(PopupMenuItem<ItemType>), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('hidden media stays absent and a single media has no dead menu', (
    tester,
  ) async {
    _phone(tester);
    final changes = <ItemType>[];
    await tester.pumpWidget(
      _app(
        MobileMediaMenu(
          value: ItemType.anime,
          availableTypes: const [ItemType.anime, ItemType.novel],
          onChanged: changes.add,
        ),
      ),
    );
    await tester.tap(find.byType(MobileMediaMenu));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(PopupMenuItem<ItemType>, 'Manga'), findsNothing);
    expect(find.byType(PopupMenuItem<ItemType>), findsNWidgets(2));
    await tester.tapAt(const Offset(380, 800));
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      _app(
        MobileMediaMenu(
          value: ItemType.anime,
          availableTypes: const [ItemType.anime],
          onChanged: changes.add,
        ),
      ),
    );
    await tester.tap(find.byType(MobileMediaMenu));
    await tester.pumpAndSettle();
    expect(find.byType(PopupMenuItem<ItemType>), findsNothing);
    expect(find.byIcon(Icons.expand_more_rounded), findsNothing);
    expect(changes, isEmpty);
    expect(
      tester.getSize(find.byType(MobileMediaMenu)).height,
      greaterThanOrEqualTo(44),
    );
  });

  testWidgets(
    'dialog tokens follow light/dark/black and keyboard cancel retains the draft',
    (tester) async {
      _phone(tester);
      final input = TextEditingController(text: 'Original');
      addTearDown(input.dispose);
      final themes = [
        ThemeData(colorSchemeSeed: Colors.teal),
        ThemeData(brightness: Brightness.dark, colorSchemeSeed: Colors.orange),
        ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
        ),
      ];
      for (final theme in themes) {
        bool? result;
        var completed = false;
        await tester.pumpWidget(
          _app(
            Builder(
              builder: (context) => TextButton(
                child: const Text('Open'),
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (context) => NodeLaneAlertDialog(
                      title: const Text('Edit'),
                      content: TextField(controller: input),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                  completed = true;
                },
              ),
            ),
            theme: theme,
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        final dialogTheme = Theme.of(tester.element(find.byType(AlertDialog)));
        expect(
          dialogTheme.dialogTheme.backgroundColor,
          NodeLaneTokens.fromTheme(theme).surface,
        );
        expect(dialogTheme.colorScheme.primary, theme.colorScheme.primary);
        await tester.enterText(find.byType(TextField), 'Draft');
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        await tester.pumpAndSettle();
        expect(tester.getBottomRight(find.text('Cancel')).dy, lessThan(544));
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(completed, isTrue);
        expect(result, isNull);
        expect(input.text, 'Draft');
        expect(tester.takeException(), isNull);
        tester.view.resetViewInsets();
      }
    },
  );
}
