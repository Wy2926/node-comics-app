import 'dart:io';
import 'dart:typed_data';

import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/isolate_service.dart';
import 'package:mangayomi/services/http/source_session_client.dart';
import 'package:mangayomi/services/chapter_cache.dart';
import 'package:mangayomi/services/chapter_load_error.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/modules/manga/archive_reader/models/models.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/downloaded_chapter.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_chapter_pages.g.dart';

/// Archive bytes belong to the chapter; concurrent page readers share a reload.
class ReaderArchive {
  ReaderArchive(this.path);
  final String path;
  Future<List<LocalImage>?>? _reading;
  bool _retain = true;

  void evict() {
    _retain = false;
    _reading = null;
  }

  void retain() => _retain = true;

  Future<Uint8List> read(
    int index,
    List<UChapDataPreload> pages,
    Future<List<LocalImage>?> Function(String path) load,
  ) async {
    final request = _reading ??= load(path);
    try {
      final images = await request;
      if (images == null ||
          index >= images.length ||
          images[index].image == null) {
        throw const FileSystemException('Archive page unavailable');
      }
      if (_retain && identical(_reading, request)) {
        for (final page in pages) {
          final i = page.index!;
          if (i < images.length) page.archiveImage = images[i].image;
        }
      }
      return images[index].image!;
    } finally {
      if (identical(_reading, request)) _reading = null;
    }
  }
}

class GetChapterPagesModel {
  Directory? path;
  List<PageUrl> pageUrls = [];
  final ReaderArchive? archive;
  final Set<String> sessionOrigins;
  final String? sessionScope;
  List<UChapDataPreload> uChapDataPreload;
  GetChapterPagesModel({
    required this.path,
    required this.pageUrls,
    this.archive,
    this.sessionOrigins = const {},
    this.sessionScope,
    required this.uChapDataPreload,
  });
}

@riverpod
Future<GetChapterPagesModel> getChapterPages(
  Ref ref, {
  required Chapter chapter,
  bool forceRefresh = false,
}) async {
  final keepAlive = ref.keepAlive();
  try {
    Directory? path;
    List<PageUrl> pageUrls = [];
    Set<String> sessionOrigins = const {};
    String? sessionScope;
    List<bool> isLocaleList = [];
    final incognitoMode = ref.read(incognitoModeStateProvider);
    final storageProvider = StorageProvider();
    final mangaDirectory = await storageProvider.getMangaMainDirectory(chapter);
    path = await storageProvider.getMangaChapterDirectory(
      chapter,
      mangaMainDirectory: mangaDirectory,
    );

    List<Uint8List?> archiveImages = [];
    bool pagesFromCache = false;
    final isLocalArchive = (chapter.archivePath ?? '').isNotEmpty;
    final resolvedArchivePath = isLocalArchive
        ? await resolveLocalArchivePath(chapter.archivePath!)
        : null;

    // A downloaded chapter has to open from disk, not from its source. Finding
    // the local copy before any network call is what lets it open with the
    // extension uninstalled, the site down, or no connection at all: getPageList
    // used to run first and its failure took the whole chapter down even though
    // every page was already on disk.
    final downloaded = isLocalArchive
        ? null
        : await findDownloadedChapter(chapter);
    if (downloaded?.pagesDirectory != null) path = downloaded!.pagesDirectory;

    if (!chapter.manga.value!.isLocalArchive!) {
      final manga = chapter.manga.value!;
      final source = downloaded == null
          ? getSource(
              manga.lang!,
              manga.source!,
              manga.sourceId,
              installedOnly: true,
            )
          : null;
      final origins = sourceSessionOrigins(source);
      if (await SourceSessionClient.cacheScope(origins) case final scope?) {
        sessionOrigins = origins;
        sessionScope = '${source!.id}:$scope';
      }
      final chapterCache = ChapterCache();
      final cachedPages = (!forceRefresh && downloaded == null)
          ? await chapterCache.getPageListFromCache(
              chapter,
              sessionScope: sessionScope,
            )
          : null;

      if (cachedPages != null && cachedPages.isNotEmpty) {
        pagesFromCache = true;
        pageUrls = cachedPages;
      } else if (downloaded == null) {
        // Only ask the source when there is nothing on disk to read. The
        // extension can be missing when a local copy is available.
        if (source == null) throw ChapterDataError.missingSource;
        final url = chapter.url;
        if (url == null) throw ChapterDataError.missingUrl;
        pageUrls = await getIsolateService.get<List<PageUrl>>(
          url: url,
          source: source,
          serviceType: 'getPageList',
          proxyServer: ref.read(androidProxyServerStateProvider),
        );
      }
    }

    final archivePath = isLocalArchive
        ? resolvedArchivePath
        : downloaded?.archive?.path;
    final localImagePaths = <String?>[];
    final chapterModel = GetChapterPagesModel(
      path: path,
      pageUrls: pageUrls,
      sessionOrigins: sessionOrigins,
      sessionScope: sessionScope,
      archive: archivePath == null ? null : ReaderArchive(archivePath),
      uChapDataPreload: [],
    );

    if (pageUrls.isNotEmpty || archivePath != null || downloaded != null) {
      if (archivePath != null) {
        final local = await ref.read(
          getArchiveDataFromFileProvider(archivePath).future,
        );
        for (var image in local.images!) {
          // Folder pages carry a real path instead of pre-read bytes (see
          // LocalImage.path) - keep archiveImages/localImagePaths parallel
          // to isLocaleList so index i always refers to the same page across
          // all three lists.
          archiveImages.add(image.image);
          localImagePaths.add(image.path);
          isLocaleList.add(true);
        }
      } else {
        // With no urls from the cache and none from the source, the folder on
        // disk is the only thing that knows how many pages there are.
        final pageCount = pageUrls.isNotEmpty
            ? pageUrls.length
            : downloaded!.pageCount;
        for (var i = 0; i < pageCount; i++) {
          archiveImages.add(null);
          localImagePaths.add(null);
          if (await findDownloadedPageFileAsync(path!, i) != null) {
            isLocaleList.add(true);
          } else {
            isLocaleList.add(false);
          }
        }
      }
      // The reader indexes pageUrls, isLocaleList and archiveImages together,
      // so the three have to agree: local pages carry no url, and an archive
      // is the authority on how many pages the chapter actually has.
      if (pageUrls.length > isLocaleList.length) {
        pageUrls.removeRange(isLocaleList.length, pageUrls.length);
      } else {
        for (var i = pageUrls.length; i < isLocaleList.length; i++) {
          pageUrls.add(PageUrl(""));
        }
      }
      if (!incognitoMode &&
          !pagesFromCache &&
          downloaded == null &&
          pageUrls.isNotEmpty) {
        await ChapterCache().putPageListToCache(
          chapter,
          pageUrls,
          sessionScope: sessionScope,
        );
      }
      for (var i = 0; i < pageUrls.length; i++) {
        chapterModel.uChapDataPreload.add(
          UChapDataPreload(
            chapter,
            path,
            pageUrls[i],
            isLocaleList[i],
            archiveImages[i],
            i,
            chapterModel,
            i,
            localImagePath: localImagePaths[i],
          ),
        );
      }
    }
    keepAlive.close();
    return chapterModel;
  } catch (e) {
    keepAlive.close();
    rethrow;
  }
}
