import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/services/chapter_load_error.dart';

void main() {
  final l = lookupAppLocalizations(const Locale('zh'));
  String? describe(Object error) => chapterLoadErrorDescription(l, error);

  test(
    'chapter failures identify the cause rather than blaming connectivity',
    () {
      expect(
        describe(const SocketException('failed host lookup')),
        l.reader_loading_retry_hint,
      );
      expect(
        describe(TimeoutException('read timed out')),
        l.reader_request_timeout,
      );
      expect(
        describe(const FileSystemException('missing', '/private/book.cbz')),
        l.reader_file_unavailable,
      );
      expect(
        describe(const FormatException('bad JSON')),
        l.reader_invalid_chapter_data,
      );
      expect(describe(ChapterDataError.missingSource), l.source_not_added);
      expect(
        describe(ChapterDataError.missingChapter),
        l.reader_chapter_missing,
      );
      expect(
        describe('Failed to bypass Cloudflare.\nstatusCode: 403'),
        l.notice_verification_required,
      );
      for (final (status, reason) in [
        ('401', 'login'),
        ('403', 'denied'),
        ('404', 'missing'),
        ('410', 'missing'),
        ('429', 'limited'),
        ('503', 'server'),
      ]) {
        expect(
          describe('HTTP error $status\n\n\nstatusCode: 500'),
          l.reader_http_failure(reason, status),
        );
      }
    },
  );

  test('a source explanation survives wrapper codes without its stack or signed link', () {
    expect(
      describe(Exception('本章仅对订阅用户开放\n    at getPageList\n\nstatusCode: 500')),
      '本章仅对订阅用户开放',
    );
    expect(describe('HTTP 403: 本章仅对订阅用户开放'), 'HTTP 403: 本章仅对订阅用户开放');
    expect(
      describe(
        Exception(
          'Extension "A" failed while getPageList: Error: HTTP error 403',
        ),
      ),
      l.reader_http_failure('denied', '403'),
    );
    expect(
      describe(
        'Cannot parse https://example.org/pages?signature=private\n    at getPageList',
      ),
      'Cannot parse https://example.org/...',
    );
    expect(
      describe('Chapter 403 has no scanlation'),
      'Chapter 403 has no scanlation',
    );
    expect(describe('   '), isNull);
  });
}
