import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/nodelane_requests.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('identity uses installed version and runtime ABI with safe fallback', () async {
    final platform =
        '(${Platform.operatingSystem}; ${Abi.current().toString().split('_').last})';
    // No package plugin is registered in this test process.
    expect(
      await NodeLaneRequests.userAgent,
      'nodelane-comics/unknown $platform',
    );
    for (final (version, build, expected) in [
      ('9.8.7-beta', '654', '9.8.7-beta+654'),
      ('1.2.3', '', '1.2.3'),
      ('', '654', 'unknown'),
      ('1.2.3\r\nInjected: value', '654', 'unknown'),
    ]) {
      PackageInfo.setMockInitialValues(
        appName: 'NodeLane Comics',
        packageName: 'com.nodelane.comics',
        version: version,
        buildNumber: build,
        buildSignature: '',
      );
      expect(
        await NodeLaneRequests.userAgent,
        'nodelane-comics/$expected $platform',
      );
    }
  });
}
