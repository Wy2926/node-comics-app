import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/data_and_storage/mobile_create_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/mobile_data_and_storage.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/auto_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_compression.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_encryption.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/storage_usage.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/mobile_backup_password_dialog.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/mobile_restore_choices.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';

final _writes = <(String, Object)>[];

void main() {
  var keyboard = 0.0;
  setUp(() {
    keyboard = 0;
    _writes.clear();
  });
  Widget app(Widget home, {ProviderContainer? container}) {
    final result = MaterialApp(
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
      home: home,
    );
    return container == null
        ? result
        : UncontrolledProviderScope(container: container, child: result);
  }

  Future<void> start(
    WidgetTester tester,
    Widget home, {
    ProviderContainer? container,
  }) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(home, container: container));
    await tester.pumpAndSettle();
  }

  Future<void> reveal(
    WidgetTester tester,
    Finder target, {
    double delta = 250,
  }) async {
    for (var attempt = 0; attempt < 2; attempt++) {
      if (target.evaluate().isEmpty) {
        await tester.scrollUntilVisible(
          target,
          delta,
          scrollable: find.byType(Scrollable).first,
        );
      }
      await Scrollable.ensureVisible(tester.element(target), alignment: .5);
      await tester.pump(const Duration(milliseconds: 350));
      if (target.hitTestable().evaluate().isNotEmpty) return;
    }
  }

  Future<void> tap(
    WidgetTester tester,
    Finder target, {
    double delta = 250,
  }) async {
    await reveal(tester, target, delta: delta);
    await tester.tap(target);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  testWidgets(
    'storage preferences keep independent values, cancelled paths and one pending operation',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          backupFrequencyStateProvider.overrideWith(_Frequency.new),
          autoBackupLocationStateProvider.overrideWith(_BackupLocation.new),
          downloadLocationStateProvider.overrideWith(_DownloadLocation.new),
          backupCompressionLevelProvider.overrideWith(_Compression.new),
          backupEncryptionEnabledProvider.overrideWith(_Encryption.new),
          totalChapterCacheSizeStateProvider.overrideWith(_Cache.new),
          clearChapterCacheOnAppLaunchStateProvider.overrideWith(
            _ClearOnLaunch.new,
          ),
        ],
      );
      addTearDown(container.dispose);
      String? chosenPath;
      var directoryCalls = 0, restoreCalls = 0, maintenanceCalls = 0;
      final restore = Completer<void>();
      final home = MobileDataAndStorage(
        onCreate: () => _writes.add(('create', true)),
        onRestore: () {
          restoreCalls++;
          return restore.future;
        },
        onChooseDirectory: () async {
          directoryCalls++;
          return chosenPath;
        },
        onEncryptionChanged: (value) async {
          _writes.add(('encrypt-request', value));
        },
        canChooseBackupLocation: true,
        maintenance: [
          TextButton(
            onPressed: () => maintenanceCalls++,
            child: const Text('Existing tool'),
          ),
        ],
      );
      await start(tester, home, container: container);
      await tap(tester, find.text('Backup frequency'));
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(_writes, isEmpty);
      await tap(tester, find.text('Backup frequency'));
      await tap(tester, find.text('Off'));
      expect(container.read(backupFrequencyStateProvider), 0);
      expect(
        container.read(autoBackupLocationStateProvider).$2,
        '/kept/backup',
      );
      await tap(tester, find.text('Backup location'));
      expect(directoryCalls, 1);
      expect(_writes, [('frequency', 0)]);
      chosenPath = '/chosen/backup';
      await tap(tester, find.text('Backup location'));
      expect(container.read(autoBackupLocationStateProvider).$2, chosenPath);
      expect(
        container.read(downloadLocationStateProvider).$2,
        '/kept/download',
      );
      await tap(tester, find.text('Encrypt backups'));
      expect(container.read(backupEncryptionEnabledProvider), isFalse);
      expect(_writes.where((e) => e.$1 == 'encrypt-request'), [
        ('encrypt-request', true),
      ]);
      final slider = find.byType(Slider);
      await reveal(tester, slider);
      final box = tester.getRect(slider);
      final drag = await tester.startGesture(
        Offset(box.left + 25, box.center.dy),
      );
      await drag.moveTo(Offset(box.center.dx, box.center.dy));
      await tester.pump();
      expect(_writes.where((e) => e.$1 == 'compression'), isEmpty);
      await drag.up();
      await tester.pumpAndSettle();
      expect(_writes.where((e) => e.$1 == 'compression'), hasLength(1));
      await tap(tester, find.text('Download location'));
      await tap(tester, find.text('Default'));
      expect(container.read(downloadLocationStateProvider).$2, '');
      expect(
        container.read(autoBackupLocationStateProvider).$2,
        '/chosen/backup',
      );
      await tap(tester, find.text('Advanced'));
      expect(maintenanceCalls, 0);
      await tap(tester, find.text('Existing tool'));
      expect(maintenanceCalls, 1);
      await tap(tester, find.text('Restore backup'), delta: -300);
      // The pending operation deliberately absorbs this second pointer tap.
      await tester.tap(find.text('Restore backup'), warnIfMissed: false);
      await tester.pump();
      expect(restoreCalls, 1);
      restore.completeError(StateError('private path'));
      await tester.pumpAndSettle();
      expect(find.textContaining('private path'), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'backup selection persists independently and snapshots the original options for one pending create',
    (tester) async {
      var selected = <int>[0, 7, 99];
      final calls = <List<int>>[];
      var create = Completer<void>();
      final home = Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            child: const Text('Open'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => StatefulBuilder(
                  builder: (context, setState) => MobileCreateBackup(
                    libraryOptions: const [
                      ('Library entries', 0),
                      ('Categories', 1),
                      ('Chapters and episodes', 2),
                      ('Tracking', 3),
                      ('History', 4),
                      ('Updates', 5),
                    ],
                    settingsOptions: const [
                      ('App settings', 6),
                      ('Custom buttons', 10),
                      ('Sources settings', 7),
                      ('Include sensitive settings with a long explanation', 8),
                    ],
                    extensionOptions: const [('Extensions', 9)],
                    selected: selected,
                    onToggle: (id) => setState(() {
                      selected = selected.contains(id)
                          ? selected.where((value) => value != id).toList()
                          : [...selected, id];
                    }),
                    onCreate: (selection) {
                      calls.add(selection);
                      return create.future;
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await start(tester, home);
      await tap(tester, find.text('Open'));
      await tap(tester, find.byKey(const ValueKey('backup-option-10')));
      await tap(tester, find.byKey(const ValueKey('backup-option-8')));
      await tap(tester, find.byKey(const ValueKey('backup-option-9')));
      expect(selected, [0, 7, 99, 10, 8, 9]);
      await tap(tester, find.byType(FilledButton));
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(calls, [
        [0, 7, 99, 10, 8, 9],
      ]);
      expect(identical(calls.single, selected), isFalse);
      expect(
        await Navigator.of(tester.element(find.byType(MobileCreateBackup)))
            .maybePop(),
        isTrue,
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(MobileCreateBackup), findsOneWidget);
      create.completeError(StateError('private filename'));
      await tester.pumpAndSettle();
      expect(find.textContaining('private filename'), findsNothing);
      expect(selected, calls.single);
      create = Completer<void>();
      await tap(tester, find.byType(FilledButton));
      expect(calls, hasLength(2));
      create.complete();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tap(tester, find.text('Open'));
      await reveal(tester, find.byKey(const ValueKey('backup-option-8')));
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const ValueKey('backup-option-8')),
            )
            .value,
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'backup password drafts validate, preserve raw input on failure and guard saving',
    (tester) async {
      var save = Completer<bool>();
      final calls = <String>[];
      bool? result;
      final home = Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            child: const Text('Open'),
            onPressed: () async {
              result = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => MobileBackupPasswordDialog(
                  onSave: (value) {
                    calls.add(value);
                    return save.future;
                  },
                ),
              );
            },
          ),
        ),
      );
      await start(tester, home);
      await tap(tester, find.text('Open'));
      keyboard = 280;
      await tester.pumpWidget(app(home));
      await tester.enterText(
        find.byKey(const ValueKey('backup-password')),
        ' sample password ',
      );
      await tester.enterText(
        find.byKey(const ValueKey('backup-password-confirm')),
        'mismatch',
      );
      await tester.pump();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tap(tester, find.widgetWithText(TextButton, 'Cancel'));
      expect(result, isNull);
      expect(calls, isEmpty);
      await tap(tester, find.text('Open'));
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('backup-password')))
            .controller!
            .text,
        '',
      );
      await tester.enterText(
        find.byKey(const ValueKey('backup-password')),
        ' sample password ',
      );
      await tap(tester, find.byTooltip('Show password'));
      expect(
        find.byKey(const ValueKey('backup-password-confirm')),
        findsNothing,
      );
      await tap(tester, find.byType(FilledButton));
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(calls, [' sample password ']);
      await Navigator.of(
        tester.element(find.byType(MobileBackupPasswordDialog)),
      ).maybePop();
      await tester.pump();
      expect(find.byType(MobileBackupPasswordDialog), findsOneWidget);
      save.completeError(StateError('private secret'));
      await tester.pumpAndSettle();
      expect(find.textContaining('private secret'), findsNothing);
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('backup-password')))
            .controller!
            .text,
        ' sample password ',
      );
      save = Completer<bool>();
      await tap(tester, find.byType(FilledButton));
      save.complete(true);
      await tester.pumpAndSettle();
      expect(result, isTrue);
      expect(calls, [' sample password ', ' sample password ']);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'decrypt prompt distinguishes cancel from the untrimmed password',
    (tester) async {
      String? result;
      final home = Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            child: const Text('Open'),
            onPressed: () async {
              result = await showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const MobileBackupPasswordDialog(wasIncorrect: true),
              );
            },
          ),
        ),
      );
      await start(tester, home);
      await tap(tester, find.text('Open'));
      keyboard = 280;
      await tester.pumpWidget(app(home));
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tester.enterText(
        find.byKey(const ValueKey('backup-password')),
        ' draft ',
      );
      await tap(tester, find.widgetWithText(TextButton, 'Cancel'));
      expect(result, isNull);
      await tap(tester, find.text('Open'));
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('backup-password')))
            .controller!
            .text,
        '',
      );
      await tester.enterText(
        find.byKey(const ValueKey('backup-password')),
        ' exact password ',
      );
      await tap(tester, find.byType(FilledButton));
      expect(result, ' exact password ');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'restore mode and category decisions preserve cancel, replace and per-category defaults',
    (tester) async {
      Object? result;
      Widget choice = const MobileRestoreMode();
      final home = Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            child: const Text('Open'),
            onPressed: () async {
              result = await Navigator.push(
                context,
                MaterialPageRoute<Object>(builder: (_) => choice),
              );
            },
          ),
        ),
      );
      await start(tester, home);
      await tap(tester, find.text('Open'));
      await tap(tester, find.text('Replace'));
      expect(result, isFalse);
      await tap(tester, find.text('Open'));
      await tap(tester, find.text('Merge'));
      expect(result, isTrue);
      await tap(tester, find.text('Open'));
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(result, isNull);
      choice = const MobileRestoreCategories(
        conflicts: [
          'A long existing category with several words',
          'Second category',
        ],
      );
      await tap(tester, find.text('Open'));
      await tap(tester, find.text('Second category'));
      await tap(tester, find.widgetWithText(TextButton, 'Cancel'));
      expect(result, isNull);
      await tap(tester, find.text('Open'));
      await reveal(tester, find.text('Second category'));
      expect(
        tester
            .widget<CheckboxListTile>(
              find.ancestor(
                of: find.text('Second category'),
                matching: find.byType(CheckboxListTile),
              ),
            )
            .value,
        isTrue,
      );
      await tap(tester, find.text('Second category'));
      await tap(tester, find.byType(FilledButton));
      expect(result, {
        'A long existing category with several words': true,
        'Second category': false,
      });
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'restore source picker isolates media and distinguishes clearing a match from cancellation',
    (tester) async {
      Map<String, int>? result;
      final home = Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            child: const Text('Open'),
            onPressed: () async {
              result = await Navigator.push(
                context,
                MaterialPageRoute<Map<String, int>>(
                  builder: (_) => MobileRestoreSources(
                    unmatched: const {
                      'Missing manga source': ItemType.manga,
                      'Missing anime source': ItemType.anime,
                    },
                    sources: {
                      ItemType.manga: [
                        Source(
                          id: 101,
                          name: 'Manga destination with a long name',
                          lang: 'en',
                          itemType: ItemType.manga,
                        ),
                      ],
                      ItemType.anime: [
                        Source(
                          id: 202,
                          name: 'Anime destination',
                          lang: 'ja',
                          itemType: ItemType.anime,
                        ),
                      ],
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
      await start(tester, home);
      await tap(tester, find.text('Open'));
      await tap(tester, find.text('Missing manga source'));
      expect(find.text('Anime destination (ja)'), findsNothing);
      await tester.enterText(find.byType(TextField), 'Manga');
      await tester.pumpAndSettle();
      await tap(tester, find.text('Manga destination with a long name (en)'));
      await tap(tester, find.text('Missing manga source'));
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Manga destination with a long name'),
        findsOneWidget,
      );
      await tap(tester, find.text('Missing manga source'));
      await tap(tester, find.text('Keep original name (no live source)'));
      expect(
        find.textContaining('Manga destination with a long name'),
        findsNothing,
      );
      await tap(tester, find.text('Missing anime source'));
      expect(
        find.textContaining('Manga destination with a long name'),
        findsNothing,
      );
      await tester.enterText(find.byType(TextField), 'not found');
      await tester.pumpAndSettle();
      keyboard = 280;
      await tester.pumpWidget(app(home));
      await tap(tester, find.byTooltip('Reset'));
      keyboard = 0;
      await tester.pumpWidget(app(home));
      await tap(tester, find.text('Anime destination (ja)'));
      await tap(tester, find.byType(FilledButton));
      expect(result, {'Missing anime source': 202});
      expect(tester.takeException(), isNull);
    },
  );
}

class _Frequency extends BackupFrequencyState {
  @override
  int build() {
    ref.keepAlive();
    return 2;
  }

  @override
  void set(int value) {
    state = value;
    _writes.add(('frequency', value));
  }
}

class _BackupLocation extends AutoBackupLocationState {
  @override
  (String, String) build() {
    ref.keepAlive();
    return ('/default/backup', '/kept/backup');
  }

  @override
  void set(String value) {
    state = (state.$1, value);
    _writes.add(('backup-location', value));
  }
}

class _DownloadLocation extends DownloadLocationState {
  @override
  (String, String) build() {
    ref.keepAlive();
    return ('/default/download', '/kept/download');
  }

  @override
  void set(String value) {
    state = (state.$1, value);
    _writes.add(('download-location', value));
  }
}

class _Compression extends BackupCompressionLevel {
  @override
  int build() {
    ref.keepAlive();
    return 6;
  }

  @override
  Future<void> set(int value) async {
    state = value;
    _writes.add(('compression', value));
  }
}

class _Encryption extends BackupEncryptionEnabled {
  @override
  bool build() {
    ref.keepAlive();
    return false;
  }
}

class _Cache extends TotalChapterCacheSizeState {
  @override
  String build() {
    ref.keepAlive();
    return '42 MB';
  }

  @override
  Future<void> clearCache({bool showToast = true}) async {
    _writes.add(('cache', true));
  }
}

class _ClearOnLaunch extends ClearChapterCacheOnAppLaunchState {
  @override
  bool build() {
    ref.keepAlive();
    return false;
  }

  @override
  void set(bool value) {
    state = value;
    _writes.add(('cache-launch', value));
  }
}
