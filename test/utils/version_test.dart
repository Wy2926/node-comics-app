import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/version.dart';

void main() {
  test('version ordering normalizes tags and compares numeric components', () {
    for (final (left, right, expected) in [
      ('0.1.0', '0.1.0', 0),
      ('0.1.0', '0.1.1', -1),
      ('0.9.9', '1.0.0', -1),
      ('0.9.1', '0.10.0', -1),
      ('0.9', '0.9.0', 0),
      ('0.9.1', '0.9.1.1', -1),
      (' v0.9.1 ', 'V0.9.1', 0),
      ('0.9.1+119', '0.9.1-beta', 0),
      ('v0.9.1-alpha.1', '0.9.2', -1),
    ]) {
      expect(compareVersions(left, right), expected, reason: '$left / $right');
      if (expected != 0) {
        expect(compareVersions(right, left), -expected);
      }
    }
  });
}
