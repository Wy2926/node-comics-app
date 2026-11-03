import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/modules/more/settings/player/mobile_custom_button_editor.dart';
import 'package:mangayomi/modules/more/settings/player/mobile_custom_button_screen.dart';
import 'package:mangayomi/modules/more/settings/player/mobile_player_action_dialog.dart';
import 'package:mangayomi/modules/more/settings/player/mobile_player_advanced_screen.dart';
import 'package:mangayomi/modules/more/settings/player/providers/custom_buttons_provider.dart';
import 'package:mangayomi/repositories/custom_button_repository.dart';

void main() {
  var keyboard = 0.0;
  late _Buttons repository;
  late ProviderContainer container;

  setUp(() {
    keyboard = 0;
    repository = _Buttons();
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        getCustomButtonsStreamProvider.overrideWith(
          (ref) => repository.watchAllSortedByPos(),
        ),
      ],
    );
  });
  tearDown(() async {
    container.dispose();
    await repository.changes.close();
  });

  Widget app(Widget screen) => UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(2.5),
          padding: const EdgeInsets.only(top: 24, bottom: 34),
          viewInsets: EdgeInsets.only(bottom: keyboard),
        ),
        child: child!,
      ),
      home: screen,
    ),
  );

  Future<void> start(WidgetTester tester, {Widget? screen}) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      app(screen ?? MobileCustomButtonScreen(repository: repository)),
    );
    await tester.pumpAndSettle();
  }

  Future<void> reveal(
    WidgetTester tester,
    Finder target, {
    double delta = 250,
  }) async {
    if (target.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        target,
        delta,
        scrollable: find.byType(Scrollable).first,
      );
    }
    await Scrollable.ensureVisible(tester.element(target), alignment: .5);
    await tester.pumpAndSettle();
  }

  Finder field(String name) => find.byKey(ValueKey('custom-button-$name'));
  Finder card(int id) => find.byKey(ValueKey('custom-button-$id'));
  Finder action(int id, String tooltip) =>
      find.descendant(of: card(id), matching: find.byTooltip(tooltip));

  testWidgets(
    'default and one-place reorder persist once without mutating the watched list on failure',
    (tester) async {
      final originals = List<CustomButton>.of(repository.records);
      await start(tester);
      final primary = find.descendant(
        of: card(1),
        matching: find.widgetWithText(TextButton, 'Default button'),
      );
      await reveal(tester, primary);
      final wait = Completer<void>();
      repository.batchWait = wait.future;
      final choose = tester.widget<TextButton>(primary).onPressed!;
      choose();
      choose();
      await tester.pump();
      expect(repository.batchWrites, 1);
      expect(originals.first.isFavourite, false);
      expect(originals.last.isFavourite, true);
      wait.completeError(StateError('unavailable'));
      await tester.pumpAndSettle();
      expect(find.text('Failed!'), findsOneWidget);
      expect(repository.records.first.isFavourite, false);
      repository.batchWait = null;
      await tester.tap(primary);
      await tester.pumpAndSettle();
      expect(repository.records.map((button) => button.isFavourite), [
        true,
        false,
      ]);
      final list = tester.widget<ReorderableListView>(
        find.byType(ReorderableListView),
      );
      list.onReorderItem!(0, 1);
      await tester.pumpAndSettle();
      expect(repository.records.map((button) => button.id), [2, 1]);
      expect(repository.records.map((button) => button.pos), [3, 8]);
      expect(repository.records.last.isFavourite, true);
      expect(originals.map((button) => button.pos), [3, 8]);
      expect(repository.batchWrites, 3);
      tester
          .widget<ReorderableListView>(find.byType(ReorderableListView))
          .onReorderItem!(1, 1);
      await tester.pumpAndSettle();
      expect(repository.batchWrites, 3);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'editor preserves four exact fields and identity, keeps drafts after failed save and rejects duplicate saves',
    (tester) async {
      final original = repository.records.first;
      await start(tester);
      await reveal(tester, action(1, 'Edit'));
      await tester.tap(action(1, 'Edit'));
      await tester.pumpAndSettle();
      await tester.enterText(field('title'), ' Changed label ');
      await reveal(tester, field('press'));
      await tester.enterText(field('press'), '  press(\$id)\nnext()  ');
      await reveal(tester, field('long-press'));
      await tester.enterText(field('long-press'), '');
      await reveal(tester, field('startup'));
      keyboard = 300;
      await tester.pumpWidget(
        app(MobileCustomButtonScreen(repository: repository)),
      );
      await tester.enterText(field('startup'), 'start(\$isPrimary)\n');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final wait = Completer<void>();
      repository.saveWait = wait.future;
      final save = tester
          .widget<NodeLaneIconButton>(
            find.byKey(const ValueKey('save-custom-button')),
          )
          .onPressed!;
      save();
      save();
      await tester.pump();
      expect(repository.saves, 1);
      expect(
        original.title,
        'First player action with a long descriptive label',
      );
      await Navigator.of(tester.element(find.byType(MobileCustomButtonEditor)))
          .maybePop();
      await tester.pump();
      expect(find.byType(MobileCustomButtonEditor), findsOneWidget);
      wait.completeError(StateError('unavailable'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<NodeLaneTextField>(field('startup')).controller!.text,
        'start(\$isPrimary)\n',
      );
      expect(find.byType(MobileCustomButtonEditor), findsOneWidget);
      repository.saveWait = null;
      keyboard = 0;
      await tester.pumpWidget(
        app(MobileCustomButtonScreen(repository: repository)),
      );
      await tester.tap(find.byKey(const ValueKey('save-custom-button')));
      await tester.pumpAndSettle();
      final saved = repository.records.first;
      expect(
        (saved.id, saved.pos, saved.isFavourite, saved.updatedAt),
        (1, 3, false, 42),
      );
      expect(
        (saved.title, saved.codePress, saved.codeLongPress, saved.codeStartup),
        (
          ' Changed label ',
          '  press(\$id)\nnext()  ',
          '',
          'start(\$isPrimary)\n',
        ),
      );
      expect(repository.saves, 2);
      expect(find.byType(MobileCustomButtonEditor), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'delete confirmation cancels without writing, blocks repeats and permits an explicit retry',
    (tester) async {
      await start(tester);
      await reveal(tester, action(1, 'Delete'));
      await tester.tap(action(1, 'Delete'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(repository.deletes, 0);
      await tester.tap(action(1, 'Delete'));
      await tester.pumpAndSettle();
      final wait = Completer<void>();
      repository.deleteWait = wait.future;
      final confirm = find.widgetWithText(FilledButton, 'Delete');
      final remove = tester.widget<FilledButton>(confirm).onPressed!;
      remove();
      remove();
      await tester.pump();
      expect(repository.deletes, 1);
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Cancel'))
            .onPressed,
        isNull,
      );
      await Navigator.of(tester.element(find.byType(MobilePlayerActionDialog)))
          .maybePop();
      await tester.pump();
      expect(find.byType(MobilePlayerActionDialog), findsOneWidget);
      wait.completeError(StateError('unavailable'));
      await tester.pumpAndSettle();
      expect(repository.records.length, 2);
      expect(find.text('Failed!'), findsOneWidget);
      repository.deleteWait = null;
      await tester.tap(confirm);
      await tester.pumpAndSettle();
      expect(repository.records.map((button) => button.id), [2]);
      expect(repository.deletes, 2);
      expect(find.byType(MobilePlayerActionDialog), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'load retry and empty state open a fresh editor; cancelling and missing fields never save',
    (tester) async {
      repository.records.clear();
      repository.loadFails = true;
      await start(tester);
      expect(find.text('Failed!'), findsOneWidget);
      repository.loadFails = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(
        find.text('Add a player button with a label and a press action.'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('add-custom-button')));
      await tester.pumpAndSettle();
      final saveKey = find.byKey(const ValueKey('save-custom-button'));
      expect(tester.widget<NodeLaneIconButton>(saveKey).onPressed, isNull);
      await tester.enterText(field('title'), 'Temporary');
      expect(tester.widget<NodeLaneIconButton>(saveKey).onPressed, isNull);
      await reveal(tester, field('press'));
      await tester.enterText(field('press'), 'draft()');
      await tester.pump();
      expect(tester.widget<NodeLaneIconButton>(saveKey).onPressed, isNotNull);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(repository.saves, 0);
      await tester.tap(find.byKey(const ValueKey('add-custom-button')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<NodeLaneTextField>(field('title')).controller!.text,
        '',
      );
      expect(tester.widget<NodeLaneIconButton>(saveKey).onPressed, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'MPV view distinguishes cancel from failure, waits once and retains independent restore and enable actions',
    (tester) async {
      var enabled = false, writes = 0, restores = 0;
      var result = Completer<bool?>();
      late StateSetter update;
      await start(
        tester,
        screen: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return MobilePlayerAdvancedScreen(
              enabled: enabled,
              onEnabledChanged: (value) async {
                writes++;
                final completed = await result.future;
                if (completed == true) update(() => enabled = value);
                return completed;
              },
              onRestore: () async {
                restores++;
                return result.future;
              },
            );
          },
        ),
      );
      final control = find.byType(NodeLaneSwitchRow);
      final toggle = tester.widget<NodeLaneSwitchRow>(control).onChanged!;
      toggle(true);
      toggle(true);
      await tester.pump();
      expect(writes, 1);
      expect(tester.widget<NodeLaneSwitchRow>(control).onChanged, isNull);
      result.complete(null);
      await tester.pumpAndSettle();
      expect(enabled, false);
      expect(find.text('Completed'), findsNothing);
      expect(
        find.text(
          'The operation could not be completed. Check file access and try again.',
        ),
        findsNothing,
      );
      result = Completer<bool?>();
      tester.widget<NodeLaneSwitchRow>(control).onChanged!(true);
      result.complete(false);
      await tester.pumpAndSettle();
      expect(enabled, false);
      await reveal(
        tester,
        find.text(
          'The operation could not be completed. Check file access and try again.',
        ),
      );
      result = Completer<bool?>();
      final restore = find.widgetWithText(
        OutlinedButton,
        'Restore bundled configuration',
      );
      await reveal(tester, restore);
      await tester.tap(restore);
      await tester.pump();
      expect(restores, 1);
      expect(tester.widget<OutlinedButton>(restore).onPressed, isNull);
      result.complete(true);
      await tester.pumpAndSettle();
      expect(enabled, false);
      await reveal(tester, control, delta: -250);
      result = Completer<bool?>();
      tester.widget<NodeLaneSwitchRow>(control).onChanged!(true);
      result.complete(true);
      await tester.pumpAndSettle();
      expect(enabled, true);
      expect(writes, 3);
      expect(tester.takeException(), isNull);
    },
  );
}

class _Buttons extends CustomButtonRepository {
  List<CustomButton> records = [
    CustomButton(
      id: 1,
      title: 'First player action with a long descriptive label',
      codePress: 'press()',
      codeLongPress: 'hold()',
      codeStartup: 'start()',
      pos: 3,
      updatedAt: 42,
    ),
    CustomButton(
      id: 2,
      title: 'Second',
      codePress: 'second()',
      pos: 8,
      isFavourite: true,
    ),
  ];
  final changes = StreamController<List<CustomButton>>.broadcast();
  Future<void>? batchWait, saveWait, deleteWait;
  int batchWrites = 0, saves = 0, deletes = 0;
  bool loadFails = false;
  @override
  Stream<List<CustomButton>> watchAllSortedByPos() async* {
    if (loadFails) throw StateError('unavailable');
    yield records;
    yield* changes.stream;
  }

  @override
  Future<CustomButton?> findById(int? id) async =>
      records.where((button) => button.id == id).firstOrNull;
  @override
  Future<int> count() async => records.length;
  @override
  Future<void> putAll(List<CustomButton> buttons) async {
    batchWrites++;
    await batchWait;
    records = buttons;
    changes.add(records);
  }

  @override
  Future<void> save(CustomButton button) async {
    saves++;
    await saveWait;
    final index = records.indexWhere((existing) => existing.id == button.id);
    if (index == -1) {
      records.add(button);
    } else {
      records[index] = button;
    }
    changes.add(List.of(records));
  }

  @override
  Future<void> delete(int id) async {
    deletes++;
    await deleteWait;
    records.removeWhere((button) => button.id == id);
    changes.add(List.of(records));
  }
}
