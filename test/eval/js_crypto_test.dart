import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';

void main() {
  test('extension MD5 is UTF-8 and AES-ECB uses raw keys with PKCS7 padding', () {
    expect(MBridge.md5('测试 🌊'), 'f2d69c95e9241af198adf2e67bedb958');
    // Synthetic vector generated independently with OpenSSL-compatible AES-256-ECB.
    const encrypted =
        'FtKlqeXe6hB9yQ/Kj5zCKNzXuF9fFWx0PJHCqeMSH7ffUwfEnqGrhLkYXNMmLr5aE3iHATeqJjDCMPlfdYlKCBTD8ypNqRetO3Nx7ptkBiCSRjEZumGAmgW6DzXkIJOguArhlaYv9TnzY9OU7BAKlg==';
    final key = '8cfb3f3e758920f655c817f7882c9548'.codeUnits
        .map((c) => c.toRadixString(16).padLeft(2, '0'))
        .join();
    expect(
      MBridge.decryptAESECB(encrypted, key),
      '{"search_query":"fixture","total":1,"content":[{"id":"500000","name":"Fixture &amp; 测试 🌊"}]}',
    );
    expect(() => MBridge.decryptAESECB(encrypted, 'bad'), throwsArgumentError);
    expect(() => MBridge.decryptAESECB('broken', key), throwsA(anything));
  });
}
