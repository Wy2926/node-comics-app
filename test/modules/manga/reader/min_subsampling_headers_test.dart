import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/src/min_subsampling_image_view.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/modules/manga/archive_reader/models/models.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

import '../../../helpers/cached_reader_png.dart';

void main() {
  testWidgets(
    'an evicted archive image loads on the mounted cell and releases its bitmap on removal',
    (tester) async {
      final bytes = await cachedReaderPng(tester, 5, 3);
      final archive = ReaderArchive('fixture.cbz');
      final model = GetChapterPagesModel(
        path: null,
        pageUrls: [],
        uChapDataPreload: [],
        archive: archive,
      );
      final page = UChapDataPreload(null, null, null, true, bytes, 0, model, 0)
        ..archiveImage = null;
      model.uChapDataPreload.add(page);
      final started = Completer<void>(), gate = Completer<LocalArchive>();
      final ready = Completer<void>();
      final failures = <bool>[];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getArchiveDataFromFileProvider(archive.path).overrideWith((ref) {
              started.complete();
              return gate.future;
            }),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MinSubsamplingImage(
              data: page,
              fit: BoxFit.contain,
              cropBorders: false,
              isHorizontal: false,
              failedToLoadImage: failures.add,
              onImageLoaded: (_, _) => ready.complete(),
            ),
          ),
        ),
      );
      expect(started.isCompleted, isTrue);
      gate.complete(LocalArchive()..images = [LocalImage()..image = bytes]);
      await tester.pumpAndSettle();
      expect(ready.isCompleted, isTrue);
      expect(failures, [false]);
      final bitmap = tester.widget<RawImage>(find.byType(RawImage)).image!;
      expect(bitmap.debugDisposed, isFalse);
      await tester.pumpWidget(const SizedBox());
      expect(bitmap.debugDisposed, isTrue);
    },
  );
  testWidgets(
    'cached-path loading reads headers in initState and after page replacement',
    (tester) async {
      final manga = Manga(
        source: 'Fixture',
        sourceId: 123,
        lang: 'en',
        name: 'Fixture',
        author: '',
        artist: '',
        genre: [],
        imageUrl: '',
        link: '',
        description: '',
        status: Status.ongoing,
      );
      final chapter = Chapter(mangaId: manga.id, name: 'Chapter 1')
        ..manga.value = manga;
      UChapDataPreload page(int width) => UChapDataPreload(
        chapter,
        null,
        PageUrl(
          'data:image/png;base64,${base64Encode(img.encodePng(img.Image(width: width, height: 2)))}',
        ),
        false,
        null,
        width,
        null,
        width,
      )..resolvedFilePath = '/unused/cached-path.png';
      final first = page(2), second = page(3);
      var headerReads = 0;
      final container = ProviderContainer(
        overrides: [
          headersProvider.overrideWith((ref, args) {
            headerReads++;
            return {'Referer': 'https://fixture.test/'};
          }),
        ],
      );
      addTearDown(container.dispose);
      Widget app(UChapDataPreload data) => UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MinSubsamplingImage(
            data: data,
            fit: BoxFit.contain,
            cropBorders: false,
            isHorizontal: false,
            failedToLoadImage: (_) {},
          ),
        ),
      );
      await tester.pumpWidget(app(first));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(headerReads, 1);
      await tester.pumpWidget(app(second));
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
}
