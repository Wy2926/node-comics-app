import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';

typedef BrowserReaderTarget = ({bool chapter, int id});

/// A URL alone is never sent to a plugin. Only offer an unambiguous local ID.
Future<BrowserReaderTarget?> findBrowserReaderTarget(String url) async {
  if (!isBrowserUrl(url)) return null;
  final page = Uri.parse(url);
  if ((page.path.isEmpty || page.path == '/') &&
      !page.hasQuery &&
      !page.hasFragment) {
    return null;
  }
  final sources = await isar.sources
      .where()
      .itemTypeIsAddedEqualTo(ItemType.manga, true)
      .filter()
      .isActiveEqualTo(true)
      .sourceCodeIsNotEmpty()
      .baseUrlStartsWith(page.origin, caseSensitive: false)
      .findAll();
  final matches = <BrowserReaderTarget>[];
  for (final source in sources) {
    if (!isBrowserUrl(source.baseUrl)) continue;
    final base = Uri.parse(source.baseUrl!);
    if (base.origin != page.origin) continue;
    final directory = base.path.endsWith('/')
        ? base
        : base.replace(path: '${base.path}/');
    final local = page.toString().substring(page.origin.length);
    final links = {
      url,
      local,
      if (local.startsWith(directory.path))
        local.substring(directory.path.length),
    }..removeWhere((link) => link.isEmpty || directory.resolve(link) != page);
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
