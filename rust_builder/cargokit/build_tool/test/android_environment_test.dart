import 'dart:io';

import 'package:build_tool/src/android_environment.dart';
import 'package:build_tool/src/target.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  test('recognizes matching standalone NDKs without accepting partial installs',
      () async {
    final directory = await Directory.systemTemp.createTemp('cargokit_ndk_');
    addTearDown(() => directory.delete(recursive: true));
    const revision = '28.2.13676358';
    final environment = AndroidEnvironment(
      sdkPath: directory.path,
      ndkVersion: revision,
      minSdkVersion: 24,
      targetTempDir: directory.path,
      target: Target.all.firstWhere((e) => e.rust == 'x86_64-linux-android'),
    );
    expect(environment.ndkIsInstalled(), isFalse);
    final ndk = Directory(path.join(directory.path, 'ndk', revision));
    await ndk.create(recursive: true);
    final properties = File(path.join(ndk.path, 'source.properties'));
    await properties.writeAsString('Pkg.Revision = $revision\n');
    expect(environment.ndkIsInstalled(), isFalse);
    final host = Platform.isWindows
        ? 'windows-x86_64'
        : Platform.isMacOS
            ? 'darwin-x86_64'
            : 'linux-x86_64';
    final clang = File(path.join(ndk.path, 'toolchains', 'llvm', 'prebuilt',
        host, 'bin', Platform.isWindows ? 'clang.exe' : 'clang'));
    await clang.create(recursive: true);
    expect(environment.ndkIsInstalled(), isTrue);
    await properties.writeAsString('Pkg.Revision = 27.0.0\n');
    expect(environment.ndkIsInstalled(), isFalse);
    await File(path.join(ndk.path, 'package.xml')).create();
    expect(environment.ndkIsInstalled(), isTrue);
  });
}
