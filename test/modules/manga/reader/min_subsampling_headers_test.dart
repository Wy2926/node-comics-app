import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/src/min_subsampling_image_view.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/utils/headers.dart';

class _Background extends BackgroundColorState {
  @override
  BackgroundColor build() => BackgroundColor.black;
}

void main() {
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
      addTearDown(() {
        first.decodedImage?.dispose();
        second.decodedImage?.dispose();
      });
      var headerReads = 0;
      final container = ProviderContainer(
        overrides: [
          backgroundColorStateProvider.overrideWith(_Background.new),
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
