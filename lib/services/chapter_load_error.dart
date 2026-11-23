import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/services/http/rhttp/rhttp.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:mangayomi/utils/localized_message.dart';

enum ChapterDataError implements Exception {
  missingChapter,
  missingSource,
  missingUrl;

  String message(AppLocalizations l10n) => switch (this) {
    missingChapter => l10n.reader_chapter_missing,
    missingSource => l10n.source_not_added,
    missingUrl => l10n.invalid_url_format,
  };

  @override
  String toString() => localizedMessage(message);
}

final _httpStatus = RegExp(
  r'^(?:http(?:\s+error)?|(?:http\s+)?status(?:\s*code)?)\s*[:=]?\s*([45]\d\d)\.?$',
  caseSensitive: false,
);

String? chapterLoadErrorDescription(AppLocalizations l10n, Object error) {
  if (error is RhttpWrappedClientException) error = error.rhttpException;
  if (error is ChapterDataError) return error.message(l10n);
  if (error is FileSystemException) return l10n.reader_file_unavailable;
  if (error is FormatException) return l10n.reader_invalid_chapter_data;

  // Extensions and the Android bridge can return text instead of Dart exceptions.
  // Prefer their first diagnostic over a stack or the bridge's trailing status.
  final message =
      switch (error) {
            PlatformException(:final message, :final code) => message ?? code,
            HttpException(:final message) => message,
            StateError(:final message) => message,
            _ => error.toString(),
          }
          .replaceFirst(RegExp(r'^Exception:\s*'), '')
          .replaceFirst(
            RegExp(r'^Extension "[^\n]*" failed while getPageList:\s*'),
            '',
          )
          .replaceFirst(RegExp(r'^(?:Error|java\.[\w.]+Exception):\s*'), '');
  if (message.trim().isEmpty) return null;
  final detail = errorToastMessage(message);
  final text = detail.toLowerCase();
  if (text.startsWith('no images found in archive:') ||
      text.startsWith('no images found in folder:')) {
    return l10n.reader_no_pages;
  }
  if (error is TimeoutException ||
      error is RhttpTimeoutException ||
      text.contains('timeoutexception') ||
      text.contains('timed out')) {
    return l10n.reader_request_timeout;
  }
  if (text.contains('cloudflare challenge') ||
      text.contains('blocked by cloudflare') ||
      text.contains('failed to bypass cloudflare') ||
      text.contains('captcha required')) {
    return l10n.notice_verification_required;
  }
  final status = error is RhttpStatusCodeException
      ? error.statusCode.toString()
      : _httpStatus.firstMatch(detail)?[1];
  if (status != null) {
    final reason = switch (status) {
      '401' => 'login',
      '403' => 'denied',
      '404' || '410' => 'missing',
      '429' => 'limited',
      _ when status.startsWith('5') => 'server',
      _ => 'other',
    };
    return l10n.reader_http_failure(reason, status);
  }
  if (error is SocketException ||
      error is RhttpConnectionException ||
      text.contains('socketexception') ||
      text.contains('failed host lookup') ||
      text.contains('unknownhostexception') ||
      text.contains('connection refused') ||
      text.contains('rhttpconnectionexception')) {
    return l10n.reader_loading_retry_hint;
  }
  return detail;
}
