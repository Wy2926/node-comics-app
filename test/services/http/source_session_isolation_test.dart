import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/services/http/m_client.dart';

void main() {
  final cookies = [
    MCookie()
      ..host = 'comix.to'
      ..cookie = 'cf_clearance=fixture',
    MCookie()
      ..host = 'other.test'
      ..cookie = 'session=other',
  ];
  test('CF cookies match dot boundaries, never lookalike domains', () {
    for (final host in ['comix.to', 'www.comix.to']) {
      expect(MClient.getCookiesPref('https://$host/', cookiesList: cookies), {
        'cookie': 'cf_clearance=fixture',
      });
    }
    for (final host in [
      'notcomix.to',
      'comix.to.evil.test',
      'other-comix.to',
      '127.0.0.1',
    ]) {
      expect(
        MClient.getCookiesPref('https://$host/', cookiesList: cookies),
        isEmpty,
      );
    }
    expect(MClient.removeCookiesForHost(cookies, 'notcomix.to'), hasLength(2));
  });
  test('request diagnostics omit signed values, credentials and fragments', () {
    final redacted = redactRequestUrl(
      Uri.parse(
        'https://user:secret@comix.to/api/v1/manga?_=signed-value&keyword=private#fragment',
      ),
    );
    expect(redacted, contains('/api/v1/manga'));
    for (final secret in [
      'user',
      'secret',
      'signed-value',
      'private',
      'fragment',
    ]) {
      expect(redacted, isNot(contains(secret)));
    }
    expect(
      redactRequestUrl(Uri.parse('http://127.0.0.1:8787/index.json')),
      'http://127.0.0.1:8787/index.json',
    );
  });
}
