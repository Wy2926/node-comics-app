import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';
import 'package:mangayomi/services/source_catalog_config.dart';
import 'package:mangayomi/services/source_package.dart';

typedef BrowserReaderTarget = ({bool chapter, int id});

Future<Iterable<Source>> _matchingSources(
  Uri page, {
  bool jsOnly = false,
}) async {
  final sources = await isar.sources
      .where()
      .itemTypeIsAddedEqualTo(ItemType.manga, true)
      .filter()
      .isActiveEqualTo(true)
      .optional(
        jsOnly,
        (q) => q.sourceCodeLanguageEqualTo(SourceCodeLanguage.javascript),
      )
      .sourceCodeIsNotEmpty()
      .baseUrlStartsWith(page.origin, caseSensitive: false)
      .findAll();
  // 请求白名单还可能含 API、CDN；认领网页只能用作品网站的精确 origin。
  return sources.where(
    (s) =>
        isBrowserUrl(s.baseUrl) && Uri.parse(s.baseUrl!).origin == page.origin,
  );
}

Future<Source?> findBrowserPreviewSource(Uri target) async =>
    (await _matchingSources(target, jsOnly: true))
        .where(
          (source) =>
              SourcePackage.of(source)?.capabilities
                  .contains(browserMangaPreviewCapability) ==
              true,
        )
        .singleOrNull;

/// 来源可能保存完整 URL、根相对或基址相对路径；只认能还原到同一地址的写法。
Set<String> browserStoredLinks(Source source, Uri page) {
  final base = Uri.parse(source.baseUrl!);
  final directory = base.path.endsWith('/')
      ? base
      : base.replace(path: '${base.path}/');
  final url = page.toString(), local = url.substring(page.origin.length);
  return {
    url,
    local,
    if (local.startsWith(directory.path))
      local.substring(directory.path.length),
  }..removeWhere((link) => link.isEmpty || directory.resolve(link) != page);
}

/// 用 App 阅读器打开时，仍只接受唯一匹配的本地作品或章节。
Future<BrowserReaderTarget?> findBrowserReaderTarget(String url) async {
  if (!isBrowserUrl(url)) return null;
  final page = Uri.parse(url);
  if ((page.path.isEmpty || page.path == '/') &&
      !page.hasQuery &&
      !page.hasFragment) {
    return null;
  }
  final matches = <BrowserReaderTarget>[];
  for (final source in await _matchingSources(page)) {
    final links = browserStoredLinks(source, page);
    final books = await isar.mangas
        .filter()
        .sourceIdEqualTo(source.id)
        .itemTypeEqualTo(ItemType.manga)
        .anyOf(links, (q, link) => q.linkEqualTo(link))
        .limit(2)
        .idProperty()
        .findAll();
    final chapters = await isar.chapters
        .filter()
        .anyOf(links, (q, link) => q.urlEqualTo(link))
        .manga(
          (q) => q.itemTypeEqualTo(ItemType.manga).sourceIdEqualTo(source.id),
        )
        .limit(2)
        .idProperty()
        .findAll();
    matches.addAll([
      for (final id in books.nonNulls) (chapter: false, id: id),
      for (final id in chapters.nonNulls) (chapter: true, id: id),
    ]);
    if (matches.length > 1) return null;
  }
  return matches.singleOrNull;
}
