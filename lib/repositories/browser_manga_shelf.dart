import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/webview/browser_manga_preview.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';
import 'package:mangayomi/repositories/browser_reader_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';

typedef BrowserShelfEntry = ({String link, int? favoriteId});

Future<Source> _owner(BrowserMangaPreview preview) async {
  final source = await findBrowserPreviewSource(Uri.parse(preview.link));
  if (source == null || source.id != preview.sourceId) {
    throw StateError('Preview source changed');
  }
  return source;
}

QueryBuilder<Manga, Manga, QAfterFilterCondition> _books(
  Source source,
  BrowserMangaPreview preview,
  String link,
) {
  final links = {
    ...browserStoredLinks(source, Uri.parse(preview.link)),
    if (link != preview.link) ...browserStoredLinks(source, Uri.parse(link)),
  };
  // 旧记录可能没有来源 ID；只有来源名、语言和作品网址同时吻合才复用。
  return isar.mangas
      .where()
      .itemTypeEqualTo(ItemType.manga)
      .filter()
      .group(
        (q) => q
            .sourceIdEqualTo(source.id)
            .or()
            .group(
              (q) => q
                  .sourceIdIsNull()
                  .sourceEqualTo(source.name)
                  .langEqualTo(source.lang)
                  .not()
                  .isLocalArchiveEqualTo(true),
            ),
      )
      .anyOf(links, (q, url) => q.linkEqualTo(url));
}

Future<Manga?> _match(Source source, List<Manga> books) async {
  if (books.isEmpty) return null;
  // 同址有历史副本时优先唯一的收藏；有歧义就不修改任何记录。
  final book =
      books.where((book) => book.favorite == true).singleOrNull ?? books.single;
  if (book.sourceId == null && !isBrowserUrl(book.link)) {
    // 未绑定的相对地址不含域名；同名同语言的多个已装来源之间无法确认归属。
    final owners = await isar.sources
        .where()
        .itemTypeIsAddedEqualTo(ItemType.manga, true)
        .filter()
        .nameEqualTo(source.name)
        .langEqualTo(source.lang)
        .sourceCodeIsNotEmpty()
        .limit(2)
        .count();
    if (owners != 1) throw StateError('Ambiguous legacy source');
  }
  return book;
}

final browserMangaShelfProvider = StreamProvider.autoDispose
    .family<BrowserShelfEntry, BrowserMangaPreview>((ref, preview) async* {
      final source = await _owner(preview);
      var link = preview.link;
      final targetUrl = Uri.parse(preview.targetUrl).removeFragment();
      if (targetUrl != Uri.parse(link).removeFragment() &&
          await _books(source, preview, link).isEmpty()) {
        // 章节页有时只给会重定向的作品短链。优先用本地章节，未收录才请来源确认规范地址。
        final target = await findBrowserReaderTarget(targetUrl.toString());
        final chapter = target?.chapter == true
            ? await chapterRepository.findById(target!.id)
            : null;
        final book = chapter?.manga.value;
        final local = book?.sourceId == source.id
            ? resolveBrowserLink(book?.link ?? '', source.baseUrl)
            : null;
        if (local != null &&
            Uri.parse(local).origin == Uri.parse(link).origin) {
          link = local;
        } else if (ref.mounted) {
          link =
              (await browserMangaFromLink(source, Uri.parse(link)))?.link ??
              link;
        }
      }
      if (!ref.mounted) return;
      yield* _books(
        source,
        preview,
        link,
      ).watch(fireImmediately: true).asyncMap((books) async {
        final book = await _match(source, books);
        return (
          link: link,
          favoriteId: book?.favorite == true ? book!.id : null,
        );
      });
    });

Future<void> addBrowserManga(BrowserMangaPreview preview, String link) =>
    mangaRepository.writeTransactionAsync(() async {
      // 点击时重新核对来源和收藏；两个标签同时加入也只更新一条，绝不切换成移除。
      final source = await _owner(preview);
      final existing = await _match(
        source,
        await _books(source, preview, link).findAll(),
      );
      if (existing?.favorite == true) return;
      final book =
          existing ??
          Manga(
            source: source.name,
            sourceId: source.id,
            lang: source.lang,
            link: link,
            name: preview.name,
            imageUrl: preview.imageUrl,
            author: preview.author ?? '',
            status: preview.status,
            genre: [],
            artist: '',
            description: '',
            lastUpdate: 0,
          );
      final now = DateTime.now().millisecondsSinceEpoch;
      await mangaRepository.putAsync(
        book
          ..sourceId = source.id
          ..favorite = true
          ..dateAdded = now
          ..updatedAt = now,
      );
    });

Future<Manga> browserShelfFavorite(
  BrowserMangaPreview preview,
  BrowserShelfEntry entry,
) => mangaRepository.writeTransactionAsync(() async {
  final source = await _owner(preview);
  final book = await _match(
    source,
    await _books(source, preview, entry.link).findAll(),
  );
  if (book == null || book.favorite != true || book.id != entry.favoriteId) {
    throw StateError('Favorite changed');
  }
  // 仅在显式阅读时补绑定旧收藏，防止详情更新按同名来源误取目录。
  if (book.sourceId == null) {
    await mangaRepository.putAsync(
      book
        ..sourceId = source.id
        ..updatedAt = DateTime.now().millisecondsSinceEpoch,
    );
  }
  return book;
});
