import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/services/nodelane_requests.dart';
import 'package:mangayomi/services/support_requests.dart';
import 'package:package_info_plus/package_info_plus.dart';

const _receipt = 'b741e1fb-9e21-4df4-bc46-6f122868922a';

class _FailingStorage extends SupportRequests {
  _FailingStorage({required super.client});
  bool failPending = true, failReceipt = true;

  @override
  Future<void> save(SupportRequestDraft draft) {
    if (draft.receipt == null ? failPending : failReceipt) {
      return Future.error(StateError('vault unavailable'));
    }
    return super.save(draft);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'NodeLane Comics',
      packageName: 'com.nodelane.comics',
      version: '9.8.7',
      buildNumber: '654',
      buildSignature: '',
    );
  });

  test('website suggestions omit page paths, credentials and signed data', () {
    expect(
      supportWebsiteUrl(
        'https://comics.example/private/chapter?token=secret#x',
      ),
      'https://comics.example/',
    );
    expect(supportWebsiteUrl('comics.example'), 'https://comics.example/');
    for (final value in [
      '',
      'javascript:alert(1)',
      'file:///private/data',
      'https://user:secret@comics.example/',
      'https://comics.example:1234/',
      'https://comics.example:wrong/',
      'https://comics.example/\nsecret',
      r'https://comics.example\@localhost/',
      'https://comics.local/',
    ]) {
      expect(supportWebsiteUrl(value), isNull, reason: value);
    }
  });

  test('app feedback uses the existing kind and stays separate from website drafts', () async {
    final requests = SupportRequests(
      base: Uri.parse('https://feedback.example/api/'),
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/support-requests');
        expect(request.headers['User-Agent'], await NodeLaneRequests.userAgent);
        expect(request.headers['Accept'], 'application/json');
        expect(request.headers['Authorization'], isNull);
        expect(request.headers['Cookie'], isNull);
        expect(request.followRedirects, isFalse);
        final body = jsonDecode(request.body);
        expect(body['kind'], 'plugin');
        expect(body['site_name'], '');
        expect(body['url'], '');
        expect(body['comment'], '${supportAppCommentPrefix}A suggestion');
        return http.Response('{}', 429);
      }),
    );
    addTearDown(requests.close);
    final website = SupportRequestDraft(
      kind: SupportRequestKind.website,
      siteName: 'Example',
      url: 'https://comics.example/',
      comment: '',
    );
    await requests.save(website);
    final app = SupportRequestDraft(
      kind: SupportRequestKind.app,
      comment: 'A suggestion',
    );
    await expectLater(
      requests.submit(app),
      throwsA(
        isA<SupportRequestRejected>().having((e) => e.status, 'status', 429),
      ),
    );
    await requests.clear(SupportRequestKind.app);
    expect((await requests.load(SupportRequestKind.website))!.key, website.key);
  });

  test(
    'storage failures never send an unrecorded request or lose the replay key',
    () async {
      final sentKeys = <String>[];
      final requests = _FailingStorage(
        client: MockClient((request) async {
          sentKeys.add(request.headers['Idempotency-Key']!);
          return http.Response(
            jsonEncode({'id': _receipt, 'created_at': '2026-11-17T00:00:00Z'}),
            201,
          );
        }),
      );
      addTearDown(requests.close);
      final draft = SupportRequestDraft(
        kind: SupportRequestKind.app,
        comment: 'Preserve this report',
      );
      await expectLater(requests.submit(draft), throwsStateError);
      expect(sentKeys, isEmpty);
      requests.failPending = false;
      await expectLater(requests.submit(draft), throwsStateError);
      final pending = (await requests.load(SupportRequestKind.app))!;
      expect(pending.receipt, isNull);
      requests.failReceipt = false;
      expect((await requests.submit(pending)).receipt, _receipt);
      expect((await requests.load(SupportRequestKind.app))!.receipt, _receipt);
      expect(sentKeys, [draft.key, draft.key]);
    },
  );

  test('invalid receipts and redirects retain the pending request for confirmation', () async {
    for (final response in [
      http.Response('{"id":"not-a-receipt"}', 201),
      http.Response('{}', 302, headers: {'location': 'https://other.example/'}),
      http.Response('{}', 500),
      http.Response('{"error":{"code":"IDEMPOTENCY_CONFLICT"}}', 409),
    ]) {
      final requests = SupportRequests(
        client: MockClient((_) async => response),
      );
      final draft = SupportRequestDraft(
        kind: SupportRequestKind.app,
        comment: 'Test',
      );
      await expectLater(requests.submit(draft), throwsFormatException);
      expect((await requests.load(SupportRequestKind.app))!.key, draft.key);
      expect((await requests.load(SupportRequestKind.app))!.receipt, isNull);
      requests.close();
    }
  });
}
