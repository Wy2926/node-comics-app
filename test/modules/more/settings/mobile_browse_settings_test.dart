import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/settings/browse/mobile_browse_cleanup_dialog.dart';
import 'package:mangayomi/modules/more/settings/browse/mobile_browse_settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';

void main() {
  Widget app(Widget child, {double scale = 1}) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(scale),
        padding: const EdgeInsets.only(top: 24, bottom: 34),
      ),
      child: child!,
    ),
    home: child,
  );

  ProviderContainer preferences() {
    final container = ProviderContainer(
      overrides: [
        checkForExtensionsUpdateStateProvider.overrideWith(_CheckUpdates.new),
        autoUpdateExtensionsStateProvider.overrideWith(_AutoUpdate.new),
        onlyIncludePinnedSourceStateProvider.overrideWith(_Pinned.new),
        showNSFWStateProvider.overrideWith(_Nsfw.new),
        developerModeStateProvider.overrideWith(_Developer.new),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> reveal(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(
      find.text(text),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'browse repositories keep their media identity and update preferences remain independent',
    (tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = preferences();
      final repositories = <ItemType>[];
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: app(
            MobileBrowseSettings(
              showProxyServer: false,
              onRepositories: repositories.add,
              onProxyServer: () => fail('Android has no proxy settings link'),
              onClearSources: () => fail('No cleanup requested'),
              onCleanDatabase: () => fail('No cleanup requested'),
              onClearLibrary: () => fail('No cleanup requested'),
              onClearLocalLibrary: () => fail('No cleanup requested'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final label in [
        'Manga extensions repo',
        'Anime extensions repo',
        'Novel extensions repo',
      ]) {
        await tester.tap(find.text(label));
      }
      expect(repositories, ItemType.values);
      expect(find.text('Extension service'), findsNothing);
      await reveal(tester, 'Check for extension updates');
      await tester.tap(find.text('Check for extension updates'));
      await tester.pumpAndSettle();
      expect(find.text('Auto extension updates'), findsNothing);
      expect(container.read(autoUpdateExtensionsStateProvider), isTrue);
      await tester.tap(find.text('Check for extension updates'));
      await tester.pumpAndSettle();
      await reveal(tester, 'Auto extension updates');
      await tester.tap(find.text('Auto extension updates'));
      await tester.pumpAndSettle();
      expect(
        (container.read(
          autoUpdateExtensionsStateProvider.notifier,
        ) as _AutoUpdate).writes,
        [false],
      );
      expect(
        (container.read(
          checkForExtensionsUpdateStateProvider.notifier,
        ) as _CheckUpdates).writes,
        [false, true],
      );
      await reveal(tester, 'Only include pinned sources');
      await tester.tap(find.text('Only include pinned sources'));
      await tester.pumpAndSettle();
      expect(container.read(onlyIncludePinnedSourceStateProvider), isTrue);
      expect(container.read(showNSFWStateProvider), isFalse);
      expect(container.read(developerModeStateProvider), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'large text keeps proxy and maintenance actions reachable without running them on expansion',
    (tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = preferences();
      final actions = <String>[];
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: app(
            MobileBrowseSettings(
              showProxyServer: true,
              onRepositories: (_) => fail('No repository requested'),
              onProxyServer: () => actions.add('proxy'),
              onClearSources: () => actions.add('sources'),
              onCleanDatabase: () => actions.add('database'),
              onClearLibrary: () => actions.add('library'),
              onClearLocalLibrary: () => actions.add('local'),
            ),
            scale: 2.5,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await reveal(tester, 'Extension service');
      await tester.tap(find.text('Extension service'));
      expect(actions, ['proxy']);
      await reveal(tester, 'Data and storage');
      expect(find.text('Clear all sources'), findsNothing);
      await tester.tap(find.text('Data and storage'));
      await tester.pumpAndSettle();
      expect(actions, ['proxy']);
      for (final label in [
        'Clean database',
        'Clear all sources',
        'Clear library',
        'Clear local library',
      ]) {
        await reveal(tester, label);
        await tester.tap(find.text(label));
      }
      expect(actions, ['proxy', 'database', 'sources', 'library', 'local']);
      expect(container.read(developerModeStateProvider), isFalse);
      expect(container.read(showNSFWStateProvider), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'cleanup selection cancels safely and waits for one action before closing or showing failure',
    (tester) async {
      tester.view.physicalSize = const Size(320, 440);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final selected = <List<ItemType>>[];
      final requests = <Completer<void>>[];
      var chooseTypes = true;
      await tester.pumpWidget(
        app(
          Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => MobileBrowseCleanupDialog(
                    title: 'Clear library',
                    message:
                        'Choose to clear all manga, anime and/or novel entries',
                    chooseTypes: chooseTypes,
                    onConfirm: (types) {
                      selected.add(types);
                      final request = Completer<void>();
                      requests.add(request);
                      return request.future;
                    },
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
          scale: 2.5,
        ),
      );
      Future<void> open() async {
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
      }

      Future<void> choose(String label) async {
        await reveal(tester, label);
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
      }

      await open();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await choose('Manga');
      await choose('Novel');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(requests, isEmpty);
      await open();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await choose('Anime');
      await tester.tap(find.byType(FilledButton));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.byType(FilledButton));
      expect(selected, [
        [ItemType.anime],
      ]);
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Cancel'))
            .onPressed,
        isNull,
      );
      expect(
        tester
            .widget<CheckboxListTile>(
              find.widgetWithText(CheckboxListTile, 'Anime'),
            )
            .onChanged,
        isNull,
      );
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.byType(MobileBrowseCleanupDialog), findsOneWidget);
      requests.single.completeError(StateError('private storage detail'));
      await tester.pumpAndSettle();
      expect(find.text('Failed!'), findsOneWidget);
      expect(find.textContaining('private storage detail'), findsNothing);
      expect(find.byType(MobileBrowseCleanupDialog), findsOneWidget);
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(selected, [
        [ItemType.anime],
        [ItemType.anime],
      ]);
      requests.last.complete();
      await tester.pumpAndSettle();
      expect(find.byType(MobileBrowseCleanupDialog), findsNothing);

      chooseTypes = false;
      await open();
      expect(find.byType(CheckboxListTile), findsNothing);
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(selected.last, isEmpty);
      await tester.pumpWidget(const SizedBox());
      requests.last.complete();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}

class _CheckUpdates extends CheckForExtensionsUpdateState {
  final writes = <bool>[];
  @override
  bool build() => true;
  @override
  void set(bool value) {
    writes.add(value);
    state = value;
  }
}

class _AutoUpdate extends AutoUpdateExtensionsState {
  final writes = <bool>[];
  @override
  bool build() => true;
  @override
  void set(bool value) {
    writes.add(value);
    state = value;
  }
}

class _Pinned extends OnlyIncludePinnedSourceState {
  @override
  bool build() => false;
  @override
  void set(bool value) => state = value;
}

class _Nsfw extends ShowNSFWState {
  @override
  bool build() => false;
  @override
  void set(bool value) => state = value;
}

class _Developer extends DeveloperModeState {
  @override
  bool build() => false;
  @override
  void set(bool value) => state = value;
}
