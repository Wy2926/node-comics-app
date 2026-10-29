import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/ios_archive_path.dart';

void main() {
  test('recovers an existing file only at its relative path in the current iOS container', () async {
    final root = await Directory.systemTemp.createTemp('nodelane-ios-archive-');
    addTearDown(() => root.delete(recursive: true));
    final base = '${root.path}/Containers/Data/Application';
    final oldRoot = '$base/11111111-1111-1111-1111-111111111111';
    final newRoot = '$base/22222222-2222-2222-2222-222222222222';
    final documents = '$newRoot/Documents';
    final current = File('$newRoot/tmp/Reader.cbz');
    await current.parent.create(recursive: true);
    await current.writeAsString('original archive');
    Future<String> resolve(String path) =>
        resolveRelocatedIosArchivePath(path, documentsPath: documents);
    final previous = '$oldRoot/tmp/Reader.cbz';
    expect(await resolve(previous), current.path);
    expect(
      await resolve('$oldRoot/tmp/Missing.cbz'),
      '$oldRoot/tmp/Missing.cbz',
    );
    expect(
      await resolve('$oldRoot/Documents/Reader.cbz'),
      '$oldRoot/Documents/Reader.cbz',
    );
    expect(
      await resolve('${root.path}/External/Reader.cbz'),
      '${root.path}/External/Reader.cbz',
    );
    expect(await resolve('local/Reader.cbz'), 'local/Reader.cbz');
    expect(
      await resolve('$oldRoot/tmp/../../outside.cbz'),
      '$oldRoot/tmp/../../outside.cbz',
    );
    expect(
      await resolve('$base/not-a-container/tmp/Reader.cbz'),
      '$base/not-a-container/tmp/Reader.cbz',
    );
    final old = File(previous);
    await old.parent.create(recursive: true);
    await old.writeAsString('still available original');
    expect(await resolve(previous), previous);
    expect(await current.readAsString(), 'original archive');
    expect(await old.readAsString(), 'still available original');
  });
}
