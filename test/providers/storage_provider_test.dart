// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

void main() {
  test('Linux documents fallback preserves the home directory location', () {
    expect(
      linuxDocumentsFallbackPath({'HOME': '/home/reader'}),
      '/home/reader',
    );
    expect(linuxDocumentsFallbackPath({'HOME': '  '}), isNull);
    expect(linuxDocumentsFallbackPath(const {}), isNull);
  });

  test(
    'NodeLane storage reopens its own database without adopting old data',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final httpOverrides = HttpOverrides.current;
      HttpOverrides.global = null;
      try {
        await Isar.initializeIsarCore(download: true);
      } finally {
        HttpOverrides.global = httpOverrides;
      }
      final root = await Directory.systemTemp.createTemp('nodelane-storage-');
      final previousPaths = PathProviderPlatform.instance;
      PathProviderPlatform.instance = _Paths(root.path);
      Isar? database;
      addTearDown(() async {
        if (database?.isOpen ?? false) await database!.close();
        PathProviderPlatform.instance = previousPaths;
        await root.delete(recursive: true);
      });

      final oldFile = File(
        p.join(root.path, 'Documents', 'Mangayomi', 'databases', 'legacy'),
      );
      await oldFile.parent.create(recursive: true);
      await oldFile.writeAsString('upstream data');
      final storage = StorageProvider();
      final defaultDir = (await storage.getDefaultDirectory())!;
      expect(
        defaultDir.path,
        p.join(root.path, 'Documents', 'nodelane-comics'),
      );
      final dbDir = (await storage.getDatabaseDirectory())!;
      expect(
        dbDir.path,
        p.join(
          root.path,
          Platform.isMacOS ? 'Support' : 'Documents',
          'nodelane-comics',
          'databases',
        ),
      );

      final upstream = await Isar.open(
        [SettingsSchema, SourceSchema],
        directory: dbDir.path,
        name: 'mangayomiDb',
      );
      database = upstream;
      await upstream.writeTxn(() async {
        await upstream.settings.put(
          Settings()..downloadLocation = 'upstream-location',
        );
      });
      await upstream.close();

      final current = await storage.initDB(null);
      database = app.isar = current;
      expect(current.name, 'nodelane-comics');
      expect(current.settings.getSync(227)!.downloadLocation, isEmpty);
      expect((await storage.getDirectory())!.path, defaultDir.path);
      expect(await oldFile.readAsString(), 'upstream data');
      expect(File(p.join(dbDir.path, 'mangayomiDb.isar')).existsSync(), isTrue);
      final custom = p.join(root.path, 'chosen');
      await current.writeTxn(() async {
        await current.settings.put(Settings()..downloadLocation = custom);
      });
      await current.close();

      final reopened = await storage.initDB(null);
      database = app.isar = reopened;
      expect(reopened.settings.getSync(227)!.downloadLocation, custom);
      expect(
        (await storage.getDirectory())!.path,
        p.join(custom, 'nodelane-comics'),
      );
    },
  );
}

class _Paths extends PathProviderPlatform {
  _Paths(this.root);
  final String root;

  @override
  Future<String?> getApplicationDocumentsPath() async =>
      p.join(root, 'Documents');

  @override
  Future<String?> getApplicationSupportPath() async => p.join(root, 'Support');
}
