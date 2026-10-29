// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/reader/providers/color_filter_provider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_settings.dart';
import 'package:mangayomi/modules/more/settings/reader/mobile_reader_settings_sections.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/utils/riverpod.dart';

final _writes = <(String, Object)>[];

void main() {
  late Isar database;
  late Directory root;
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    root = await Directory.systemTemp.createTemp('nodelane-reader-settings-');
    database = await Isar.open(
      [SettingsSchema, MangaSchema, ChapterSchema, SourceSchema],
      directory: root.path,
      name: 'reader_settings',
    );
    app.isar = database;
    database.writeTxnSync(() => database.settings.putSync(Settings(id: 227)));
  });
  tearDownAll(() async {
    await database.close(deleteFromDisk: true);
    await root.delete(recursive: true);
  });
  setUp(_writes.clear);

  ProviderContainer preferences() {
    final container = ProviderContainer(
      overrides: [
        cropBordersStateProvider.overrideWith(_Crop.new),
        readerBrightnessStateProvider.overrideWith(_Brightness.new),
        enableCustomColorFilterStateProvider.overrideWith(_EnableFilter.new),
        customColorFilterStateProvider.overrideWith(_Rgba.new),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(container.listen(cropBordersStateProvider, (_, _) {}).close);
    addTearDown(
      container.listen(readerBrightnessStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(enableCustomColorFilterStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(customColorFilterStateProvider, (_, _) {}).close,
    );
    return container;
  }

  Future<void> mount(
    WidgetTester tester,
    ProviderContainer container, {
    required ProviderListenable<ReaderMode?> mode,
    required ValueNotifier<bool> enabled,
    required ValueNotifier<bool> running,
    required ValueNotifier<double> speed,
    required void Function(bool, double) save,
    required VoidCallback resume,
    void Function(ReaderMode, WidgetRef)? changeMode,
    ValueNotifier<bool>? host,
    String title = 'Comic 1',
  }) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(enabled.dispose);
    addTearDown(running.dispose);
    addTearDown(speed.dispose);
    final visible = host ?? ValueNotifier(true);
    addTearDown(visible.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ValueListenableBuilder<bool>(
              valueListenable: visible,
              builder: (context, shown, _) => shown
                  ? Builder(
                      builder: (readerContext) => TextButton(
                        onPressed: () => showMobileReaderSettings(
                          context: readerContext,
                          bookTitle: title,
                          currentReaderModeProvider: mode,
                          autoScrollPage: enabled,
                          autoScroll: running,
                          pageOffset: speed,
                          onReaderModeChanged: changeMode ?? (_, _) {},
                          onAutoScrollSave: save,
                          onAutoPageScroll: resume,
                        ),
                        child: const Text('Open'),
                      ),
                    )
                  : const Text('Reader removed'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  Finder close() =>
      find.byWidgetPredicate((w) => w is IconButton && w.tooltip == 'Close');
  Finder row(String title) => find.widgetWithText(ListTile, title);
  Future<void> reveal(WidgetTester tester, Finder target, String list) async {
    await tester.scrollUntilVisible(
      target,
      250,
      scrollable: find
          .descendant(
            of: find.byKey(PageStorageKey(list)),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
  }

  Future<void> tab(WidgetTester tester, String name) async {
    await tester.ensureVisible(find.widgetWithText(Tab, name));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(Tab, name));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'mode choices and auto-scroll remain paused until closing and save speed once',
    (tester) async {
      final container = preferences();
      final mode = StateProvider<ReaderMode?>(() => ReaderMode.webtoon);
      final enabled = ValueNotifier(true), running = ValueNotifier(true);
      final speed = ValueNotifier(12.0);
      final saves = <(bool, double)>[];
      final modes = <ReaderMode>[];
      var resumed = 0;
      await mount(
        tester,
        container,
        mode: mode,
        enabled: enabled,
        running: running,
        speed: speed,
        save: (enabled, speed) => saves.add((enabled, speed)),
        resume: () => resumed++,
        changeMode: (value, ref) {
          modes.add(value);
          ref.read(mode.notifier).state = value;
          running.value = enabled.value && value.isContinuous;
        },
      );
      expect(running.value, isFalse);
      expect(
        find.text('These settings apply only to this comic.'),
        findsOneWidget,
      );
      final slider = tester.widget<Slider>(
        find
            .descendant(
              of: find.byType(MobileReaderSettingsSlider),
              matching: find.byType(Slider),
            )
            .first,
      );
      slider.onChanged!(14);
      await tester.pump();
      expect(saves, isEmpty);
      slider.onChangeEnd!(14);
      slider.onChangeEnd!(14);
      await tester.pumpAndSettle();
      expect(saves, [(true, 14.0)]);
      expect(speed.value, 14);
      await tester.tap(row('Reading mode'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(modes, isEmpty);
      await tester.tap(row('Reading mode'));
      await tester.pumpAndSettle();
      final select = tester.widget<ListTile>(row('Vertical')).onTap!;
      select();
      select();
      await tester.pumpAndSettle();
      expect(modes, [ReaderMode.vertical]);
      expect(find.byType(MobileReaderSettings), findsOneWidget);
      expect(find.text('Auto scroll'), findsNothing);
      expect(running.value, isFalse);
      await tester.tap(row('Reading mode'));
      await tester.pumpAndSettle();
      await tester.tap(row('Webtoon'));
      await tester.pumpAndSettle();
      expect(running.value, isFalse);
      final dismiss = tester.widget<IconButton>(close()).onPressed!;
      dismiss();
      dismiss();
      await tester.pumpAndSettle();
      expect(resumed, 1);
      expect(running.value, isTrue);
      expect(find.text('Open'), findsOneWidget);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final toggle = tester
          .widget<SwitchListTile>(
            find.widgetWithText(SwitchListTile, 'Auto scroll'),
          )
          .onChanged!;
      toggle(false);
      toggle(false);
      await tester.pumpAndSettle();
      await tester.tap(close());
      await tester.pumpAndSettle();
      expect(saves, [(true, 14.0), (false, 14.0)]);
      expect(resumed, 1);
      expect(running.value, isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'global scope, dependent controls and image filter channels stay independent',
    (tester) async {
      final container = preferences();
      final mode = StateProvider<ReaderMode?>(() => ReaderMode.webtoon);
      final title = 'A complete title ${'with more words ' * 12}';
      await mount(
        tester,
        container,
        mode: mode,
        enabled: ValueNotifier(false),
        running: ValueNotifier(false),
        speed: ValueNotifier(10.0),
        save: (_, _) {},
        resume: () {},
        title: title,
      );
      expect(find.text(title), findsOneWidget);
      await reveal(
        tester,
        find.widgetWithText(SwitchListTile, 'Crop borders'),
        'reader-settings-mode',
      );
      expect(
        find.text('These settings apply to all comics and save immediately.'),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(SwitchListTile, 'Crop borders'));
      await tester.pumpAndSettle();
      expect(_writes, [('crop', true)]);
      final layout = find.byWidgetPredicate(
        (w) =>
            w is ExpansionTile &&
            w.key == const PageStorageKey('reader-details-page-layout'),
      );
      await reveal(tester, layout, 'reader-settings-mode');
      await tester.tap(layout);
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(SwitchListTile, 'Split wide pages'),
        findsOneWidget,
      );
      expect(find.text('Automatic landscape zoom'), findsNothing);
      expect(_writes, [('crop', true)]);
      await tab(tester, 'General');
      final nav = find.byWidgetPredicate(
        (w) =>
            w is ExpansionTile &&
            w.key == const PageStorageKey('reader-details-navigation'),
      );
      await reveal(tester, nav, 'reader-settings-general');
      await tester.tap(nav);
      await tester.pumpAndSettle();
      expect(find.text('Chapter swipe actions'), findsNothing);
      await tab(tester, 'Image filters');
      expect(
        find.text(
          'Applies to all comics. Changes the reading display without modifying original images.',
        ),
        findsOneWidget,
      );
      await reveal(
        tester,
        find.byTooltip('Reset: Brightness'),
        'reader-settings-filter',
      );
      await tester.tap(find.byTooltip('Reset: Brightness'));
      await tester.pumpAndSettle();
      expect(container.read(readerBrightnessStateProvider), 0);
      expect(container.read(readerContrastStateProvider), 1);
      expect(container.read(readerSaturationStateProvider), 1);
      await reveal(
        tester,
        find.widgetWithText(SwitchListTile, 'Custom color filter'),
        'reader-settings-filter',
      );
      await tester.tap(
        find.widgetWithText(SwitchListTile, 'Custom color filter'),
      );
      await tester.pumpAndSettle();
      final channels = find.byWidgetPredicate(
        (w) => w is Slider && w.max == 255,
      );
      final red = tester.widget<Slider>(channels.at(0));
      final green = tester.widget<Slider>(channels.at(1));
      red.onChanged!(100);
      green.onChanged!(200);
      green.onChangeEnd!(201);
      await tester.pumpAndSettle();
      final rgba = container.read(customColorFilterStateProvider)!;
      expect((rgba.a, rgba.r, rgba.g, rgba.b), (11, 100, 201, 44));
      expect(_writes.last, ('rgba', (11, 100, 201, 44, true)));
      await reveal(
        tester,
        row('Color filter blend mode'),
        'reader-settings-filter',
      );
      await tester.tap(row('Color filter blend mode'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(container.read(customColorFilterStateProvider)!.r, 100);
      tester.view.physicalSize = const Size(740, 360);
      await tester.pumpAndSettle();
      expect(close().hitTestable(), findsOneWidget);
      await tester.tap(close());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'removed reader ignores a pending mode selection and does not resume scrolling',
    (tester) async {
      final container = preferences();
      final mode = StateProvider<ReaderMode?>(() => ReaderMode.webtoon);
      final host = ValueNotifier(true);
      final running = ValueNotifier(true);
      var calls = 0;
      await mount(
        tester,
        container,
        mode: mode,
        enabled: ValueNotifier(true),
        running: running,
        speed: ValueNotifier(10.0),
        save: (_, _) => calls++,
        resume: () => calls++,
        changeMode: (_, _) => calls++,
        host: host,
      );
      await tester.tap(row('Reading mode'));
      await tester.pumpAndSettle();
      host.value = false;
      await tester.pumpAndSettle();
      await tester.tap(row('Vertical'));
      await tester.pumpAndSettle();
      await tester.tap(close());
      await tester.pumpAndSettle();
      expect(calls, 0);
      expect(running.value, isFalse);
      expect(find.text('Reader removed'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

class _Crop extends CropBordersState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('crop', value));
  }
}

class _Brightness extends ReaderBrightnessState {
  @override
  double build() => .4;
  @override
  void set(double value) {
    state = value;
    _writes.add(('brightness', value));
  }
}

class _EnableFilter extends EnableCustomColorFilterState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('filter', value));
  }
}

class _Rgba extends CustomColorFilterState {
  CustomColorFilter _value = CustomColorFilter()
    ..a = 11
    ..r = 22
    ..g = 33
    ..b = 44;
  @override
  CustomColorFilter? build() =>
      ref.watch(enableCustomColorFilterStateProvider) ? _value : null;
  @override
  void set(int a, int r, int g, int b, bool end) {
    _value = CustomColorFilter()
      ..a = a
      ..r = r
      ..g = g
      ..b = b;
    state = _value;
    _writes.add(('rgba', (a, r, g, b, end)));
  }
}
