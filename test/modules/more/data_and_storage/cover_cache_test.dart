import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
// Use path_provider's existing platform seam in the test fixture.
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/storage_usage.dart';

void main() {
  test('cover cleanup is repeatable and leaves chapter, translation and download data alone', () async {
    final root = await Directory.systemTemp.createTemp('nodelane-cover-test-');
    final paths = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _Paths(root.path);
    addTearDown(() async {
      PathProviderPlatform.instance = paths;
      await root.delete(recursive: true);
    });
    for (final directory in [
      'cacheimagecover',
      'cacheimagemanga',
      'chapter_disk_cache',
      'downloads',
      'nodelaneTranslation',
    ]) {
      final file = File('${root.path}/$directory/keep');
      await file.create(recursive: true);
      await file.writeAsString('fixture');
    }
    await clearCoverImageCache();
    await clearCoverImageCache();
    expect(Directory('${root.path}/cacheimagecover').existsSync(), isFalse);
    for (final directory in [
      'cacheimagemanga',
      'chapter_disk_cache',
      'downloads',
      'nodelaneTranslation',
    ]) {
      expect(
        File('${root.path}/$directory/keep').readAsStringSync(),
        'fixture',
      );
    }
  });
}

class _Paths extends PathProviderPlatform {
  _Paths(this.path);
  final String path;
  @override
  Future<String?> getApplicationCachePath() async => path;
}
