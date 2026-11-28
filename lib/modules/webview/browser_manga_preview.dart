import 'dart:convert';

import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/browser_reader_repository.dart';
import 'package:mangayomi/services/isolate_service.dart';

import 'browser_url.dart';
import 'reader_transport.dart';

typedef BrowserMangaPreview = ({
  int sourceId,
  String targetUrl,
  String name,
  String link,
  String? imageUrl,
  String? author,
  Status status,
  String? chapterName,
});

BrowserMangaPreview? _parsePreview(Object? value, Uri target, int sourceId) {
  if (value == null) return null;
  if (value case {'name': String name, 'link': String link}
      when name.trim().isNotEmpty &&
          isBrowserUrl(link) &&
          Uri.parse(link).origin == target.origin) {
    String? text(dynamic field) =>
        field is String && field.trim().isNotEmpty ? field.trim() : null;
    final map = value as Map;
    return (
      // 来源和触点取自宿主，插件返回的数据不能指定要修改的本地记录。
      sourceId: sourceId,
      targetUrl: target.toString(),
      name: name.trim(),
      link: link,
      imageUrl: isBrowserUrl(map['imageUrl'])
          ? map['imageUrl'] as String
          : null,
      author: text(map['author']),
      status: MManga.sourceStatus(map['status'] is int ? map['status'] : null),
      chapterName: text(map['chapterName']),
    );
  }
  throw const FormatException('Invalid browser manga preview');
}

Future<BrowserMangaPreview?> browserMangaFromLink(
  Source source,
  Uri target,
) async => _parsePreview(
  await getIsolateService.get<Map<String, dynamic>?>(
    source: source,
    serviceType: 'resolveBrowserManga',
    url: target.toString(),
  ),
  target,
  source.id!,
);

Future<BrowserMangaPreview?> resolveBrowserMangaPreview({
  required String documentUrl,
  required String targetUrl,
  required bool link,
  required bool Function() current,
  required BrowserDocumentCall? page,
}) async {
  if (!isBrowserUrl(targetUrl) || !isBrowserUrl(documentUrl)) return null;
  final target = Uri.parse(targetUrl);
  if (target.scheme != 'https') return null;
  final source = await findBrowserPreviewSource(target);
  if (source == null || !current()) return null;
  if (page != null && Uri.parse(documentUrl).origin == target.origin) {
    final context = await page('mangaContext', {if (link) 'link': targetUrl});
    if (context case {'index': int index, 'timeOrigin': num timeOrigin}
        when current() && (!link || index >= 0)) {
      final method = await getIsolateService.get<String>(
        source: source,
        serviceType: 'browserMangaScript',
      );
      if (!current()) return null;
      final value = await page('browserMangaPreview', {
        'program': browserMangaProgram(
          method,
          documentUrl,
          targetUrl,
          link ? index : null,
          timeOrigin,
        ),
      }).timeout(const Duration(seconds: 10));
      if (!current()) return null;
      final preview = _parsePreview(value, target, source.id!);
      if (preview != null) return preview;
    }
  }
  // 跨站长按只给目标来源网址；普通页面不会为探测书名再请求一次。
  if (!link || !current()) return null;
  final preview = await browserMangaFromLink(source, target);
  return current() ? preview : null;
}

/// index 来自实际触点；即使 DOM 重排，也不能拿另一条链接的卡片充当摘要。
String browserMangaProgram(
  String method,
  String pageUrl,
  String targetUrl,
  int? index,
  num timeOrigin,
) =>
    '''(async () => {
  const doc = window.top.document, url = ${jsonEncode(targetUrl)};
  if (window.top.performance.timeOrigin !== $timeOrigin ||
      doc.URL !== new URL(${jsonEncode(pageUrl)}).href ||
      new URL(url).origin !== doc.location.origin) return null;
  const anchor = ${index == null ? 'null' : 'doc.links[$index]'};
  ${index == null ? '' : 'if (!anchor || anchor.href !== new URL(url).href) return null;'}
  const value = await ({$method}).browserMangaPreview({document: doc, url, anchor});
  // 原生通道只接收 JSON；略去 JS 可选字段的 undefined。
  return value == null ? null : JSON.parse(JSON.stringify(value));
})()''';
