import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/services/chapter_cache.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/fetch_interval.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'update_manga_detail_providers.g.dart';

@riverpod
Future<dynamic> updateMangaDetail(
  Ref ref, {
  required int? mangaId,
  required bool isInit,
  bool showToast = true,
}) async {
  try {
    final manga = mangaRepository.findById(mangaId!);
    if (manga == null) return;

    manga.chapters.loadSync();

    if ((manga.isLocalArchive ?? false) ||
        (manga.chapters.isNotEmpty && isInit)) {
      return;
    }
    final source = getSource(
      manga.lang!,
      manga.source!,
      manga.sourceId,
      installedOnly: true,
    );
    if (source == null) return;

    final getManga = await ref.read(
      getDetailProvider(url: manga.link!, source: source).future,
    );

    final genre =
        getManga.genre
            ?.map((e) => e.toString().trim())
            .toList()
            .toSet()
            .toList() ??
        [];

    final imgUrl = getManga.imageUrl.trimmedOrDefault(manga.imageUrl);
    final now = DateTime.now().millisecondsSinceEpoch;

    manga
      ..imageUrl = imgUrl == null
          ? null
          : imgUrl.startsWith('http')
          ? imgUrl
          : '${source.baseUrl ?? ''}/${imgUrl.getUrlWithoutDomain}'
      ..name = getManga.name.trimmedOrDefault(manga.name)
      ..genre = (genre.isEmpty ? null : genre) ?? manga.genre ?? []
      ..author = getManga.author.trimmedOrDefault(manga.author) ?? ""
      ..artist = getManga.artist.trimmedOrDefault(manga.artist) ?? ""
      ..status = getManga.status == Status.unknown
          ? manga.status
          : getManga.status ?? Status.unknown
      ..description =
          getManga.description.trimmedOrDefault(manga.description) ?? ""
      ..link = getManga.link.trimmedOrDefault(manga.link)
      ..source = manga.source
      ..lang = manga.lang
      ..itemType = source.itemType
      ..lastUpdate = now
      ..updatedAt = now;

    final chaps = getManga.chapters;

    await mangaRepository.writeTransactionAsync(() async {
      final savedMangaId = await mangaRepository.putAsync(manga);

      if (chaps == null || chaps.isEmpty) return;

      final existingChapters = manga.chapters.toList();
      final recognition = ChapterRecognition();

      // A URL identifies a chapter. Number/season/group is only a fallback
      // for an unambiguous URL replacement, never grounds to drop entries.
      // For example, 64.2 and 64.20 can be distinct parts on the source site.
      String? identityOf(Chapter c, {bool withScanlator = true}) {
        if (c.name == null) return null;
        return recognition.chapterIdentityKey(
          manga.name ?? '',
          c.name!,
          withScanlator ? (c.scanlator ?? '') : null,
        );
      }

      final existingByUrl = <String, Chapter>{};
      final duplicateIds = <int>{};
      for (final c in existingChapters) {
        final u = c.url?.trim();
        final urlKey = (u == null || u.isEmpty) ? null : u;
        final prior = urlKey != null ? existingByUrl[urlKey] : null;
        if (prior == null) {
          if (urlKey != null) existingByUrl[urlKey] = c;
        } else {
          final priorHasState =
              (prior.isRead ?? false) || (prior.lastPageRead ?? '').isNotEmpty;
          final keep = priorHasState ? prior : c;
          final drop = identical(keep, prior) ? c : prior;
          if (urlKey != null) existingByUrl[urlKey] = keep;
          if (drop.id != null) duplicateIds.add(drop.id!);
        }
      }

      final existingByComposite = <String, List<Chapter>>{};
      for (final c in existingChapters) {
        if (duplicateIds.contains(c.id)) continue;
        final key = identityOf(c);
        if (key != null) {
          existingByComposite.putIfAbsent(key, () => []).add(c);
        }
      }
      final incomingByUrl = <String, MChapter>{};
      final incomingByComposite = <String, int>{};
      for (final chap in chaps) {
        final url = chap.url?.trim();
        if (url == null || url.isEmpty || incomingByUrl.containsKey(url)) {
          continue;
        }
        incomingByUrl[url] = chap;
        final key = chap.name == null
            ? null
            : recognition.chapterIdentityKey(
                manga.name ?? '',
                chap.name!,
                chap.scanlator ?? '',
              );
        if (key != null) {
          incomingByComposite[key] = (incomingByComposite[key] ?? 0) + 1;
        }
      }

      // Carry read state only between explicitly named, unambiguous groups.
      // An unknown group or two same-number URLs may instead be split parts.
      final readByEpisode = <String, Set<String>>{};
      for (final group in existingByComposite.values) {
        if (group.length != 1) continue;
        final c = group.single;
        final scanlator = c.scanlator?.trim() ?? '';
        final key = identityOf(c, withScanlator: false);
        if (key != null && scanlator.isNotEmpty && (c.isRead ?? false)) {
          readByEpisode.putIfAbsent(key, () => {}).add(scanlator);
        }
      }

      final newChapters = <Chapter>[];
      final chaptersToUpdate = <Chapter>[];

      for (final entry in incomingByUrl.entries) {
        final url = entry.key, chap = entry.value;
        final rawDate = chap.dateUpload?.trim();
        final timestamp = int.tryParse(rawDate ?? '');
        // Empty/zero explicitly means unknown. An omitted or invalid field
        // leaves a known stored date intact; discovery time is not upload time.
        final uploadDate = rawDate == '' || rawDate == '0'
            ? ''
            : timestamp != null &&
                  timestamp > 0 &&
                  timestamp <= 8640000000000000
            ? timestamp.toString()
            : null;
        final compositeKey = chap.name == null
            ? null
            : recognition.chapterIdentityKey(
                manga.name!,
                chap.name!,
                chap.scanlator ?? '',
              );
        final episodeKey = chap.name == null
            ? null
            : recognition.chapterIdentityKey(manga.name!, chap.name!);

        var existing = existingByUrl[url];
        final candidates = existingByComposite[compositeKey];
        if (existing == null &&
            incomingByComposite[compositeKey] == 1 &&
            candidates?.length == 1 &&
            candidates!.single.name?.trim() == chap.name?.trim() &&
            !incomingByUrl.containsKey(candidates.single.url?.trim())) {
          existing = candidates.single;
        }

        if (existing == null) {
          final scanlator = chap.scanlator?.trim() ?? '';
          final alreadyRead =
              scanlator.isNotEmpty &&
              incomingByComposite[compositeKey] == 1 &&
              (readByEpisode[episodeKey]?.any((group) => group != scanlator) ??
                  false);

          final newChapter = Chapter(
            name: chap.name!,
            url: url,
            dateUpload: uploadDate ?? '',
            scanlator: chap.scanlator ?? '',
            mangaId: savedMangaId,
            updatedAt: now,
            isFiller: chap.isFiller,
            thumbnailUrl: chap.thumbnailUrl,
            description: chap.description,
            downloadSize: chap.downloadSize,
            duration: chap.duration,
          )..manga.value = manga;

          if (alreadyRead) {
            newChapter.isRead = alreadyRead;
            newChapter.lastPageRead = "1";
          }

          newChapters.add(newChapter);
        } else {
          if (existing.url != url) {
            ChapterCache().remove(existing);
          }
          existing
            ..name = chap.name
            ..url = url
            ..scanlator = chap.scanlator
            ..updatedAt = now
            ..isFiller = chap.isFiller
            ..thumbnailUrl = chap.thumbnailUrl
            ..description = chap.description
            ..downloadSize = chap.downloadSize
            ..duration = chap.duration;
          if (uploadDate != null) existing.dateUpload = uploadDate;
          chaptersToUpdate.add(existing);
        }
      }

      if (chaptersToUpdate.isNotEmpty) {
        await chapterRepository.putAllAsync(chaptersToUpdate);
      }

      if (newChapters.isNotEmpty) {
        final hasExisting = existingChapters.isNotEmpty;

        final orderedNew = newChapters.reversed.toList();

        for (final chap in orderedNew) {
          chap.manga.value = manga;
        }

        await chapterRepository.putAllAsync(orderedNew);
        for (final chap in orderedNew) {
          await chap.manga.save();
        }

        final updatesToInsert = <Update>[];
        for (final chap in orderedNew) {
          if (hasExisting && !(chap.isRead ?? false)) {
            updatesToInsert.add(
              Update(
                mangaId: savedMangaId,
                chapterName: chap.name,
                date: now.toString(),
                updatedAt: now,
              )..chapter.value = chap,
            );
          }
        }

        if (updatesToInsert.isNotEmpty) {
          await updateRepository.putAllAsync(updatesToInsert);
          for (final upd in updatesToInsert) {
            await upd.chapter.save();
          }
        }
      }

      if (duplicateIds.isNotEmpty) {
        await chapterRepository.deleteAllAsync(duplicateIds.toList());
      }

      final dedupedExisting = duplicateIds.isEmpty
          ? existingChapters
          : existingChapters
                .where((c) => c.id == null || !duplicateIds.contains(c.id))
                .toList();
      final allChapters = newChapters.isEmpty
          ? dedupedExisting
          : [...dedupedExisting, ...newChapters];
      if (allChapters.isNotEmpty) {
        final interval = FetchInterval.calculateInterval(allChapters);
        manga
          ..id = savedMangaId
          ..smartUpdateDays = interval;
        await mangaRepository.putAsync(manga);
      }
    });
  } catch (e, s) {
    if (showToast) {
      toastError(e, stack: s, source: 'updateMangaDetail');
    } else {
      rethrow;
    }
  }
}
