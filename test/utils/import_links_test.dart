import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/url_protocol/import_links.dart';

void main() {
  test(
    'routes NodeLane import links without losing repeated or encoded data',
    () async {
      final links = ImportLinks();
      final delivered = <Uri>[];
      final repo = Uri(
        scheme: 'nodelane-comics',
        host: 'add-repo',
        queryParameters: {
          'repo_name': '来源 A+B',
          'manga_url': [
            'https://a.example/index.json',
            'https://b.example/index.json',
          ],
          'anime_url': 'https://anime.example/index.json',
          'novel_url': 'https://novel.example/index.json',
        },
      );
      final button = Uri(
        scheme: 'nodelane-comics',
        host: 'add-button',
        queryParameters: {
          'button': ['a+b/c==', 'second'],
        },
      );
      for (final uri in [repo, button]) {
        await links.handle(uri, (value) async => delivered.add(value));
      }
      expect(delivered, [repo, button]);
      expect(delivered.first.queryParameters['repo_name'], '来源 A+B');
      expect(delivered.first.queryParametersAll['manga_url'], hasLength(2));
      expect(delivered.last.queryParametersAll['button'], [
        'a+b/c==',
        'second',
      ]);
    },
  );

  test(
    'rejects the upstream scheme, OAuth callbacks and unrelated routes',
    () async {
      final links = ImportLinks();
      for (final value in [
        'mangayomi://add-repo?manga_url=https%3A%2F%2Fa.example',
        'mangayomi://add-button?button=e30%3D',
        'https://add-repo',
        'nodelane-comics://nodelane-auth?code=private',
        'nodelane-comics://oauth-callback?code=private',
        'nodelane-comics://success?code=private',
        'nodelane-comics://',
        'nodelane-comics://unknown',
        'nodelane-comics://user@add-repo',
        'nodelane-comics://add-repo:443',
        'nodelane-comics://add-repo/nested',
        'nodelane-comics://add-button#fragment',
      ]) {
        await links.handle(
          Uri.parse(value),
          (_) async => fail('Routed $value'),
        );
      }
    },
  );

  test('deduplicates while confirmation or saving is pending, then allows retry', () async {
    final links = ImportLinks();
    final uri = Uri.parse('nodelane-comics://add-repo?manga_url=one');
    final pending = Completer<void>();
    var count = 0;
    Future<void> confirmAndSave(Uri _) async {
      count++;
      await pending.future;
    }

    final first = links.handle(uri, confirmAndSave);
    await links.handle(uri, confirmAndSave);
    await links.handle(uri.replace(path: '/'), confirmAndSave);
    expect(count, 1);
    pending.complete();
    await first;

    // A cancelled confirmation also returns normally and must not blacklist it.
    await links.handle(uri, confirmAndSave);
    expect(count, 2);
  });

  test(
    'a failed import releases its slot and does not suppress other links',
    () async {
      final links = ImportLinks();
      final repo = Uri.parse('nodelane-comics://add-repo?manga_url=one');
      final button = Uri.parse('nodelane-comics://add-button?button=e30%3D');
      final pending = Completer<void>();
      var count = 0;
      Future<void> saveButton(Uri _) async {
        count++;
        await pending.future;
      }

      final saving = links.handle(button, saveButton);
      await expectLater(
        links.handle(repo, (_) async => throw StateError('failed')),
        throwsStateError,
      );
      await links.handle(repo, (_) async => count++);
      await links.handle(button, saveButton);
      expect(count, 2);
      pending.complete();
      await saving;
    },
  );
}
