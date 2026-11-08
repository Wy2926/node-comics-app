import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/source_catalog_metadata.dart';
import 'package:mangayomi/modules/browse/widgets/source_website_card.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

Source _source(SourcePricing pricing, {bool adult = false}) => Source(
  name: '一个较长的来源名称，用于验证同一尺寸与文字保持',
  lang: 'zh',
  isNsfw: adult,
  catalogMetadataJson: jsonEncode(
    SourceCatalogMetadata(
      regions: const ['jp', 'kr', 'cn', 'western'],
      formats: const ['page', 'vertical'],
      creations: const ['original', 'fan'],
      pricing: pricing,
    ).toJson(),
  ),
);

void main() {
  Future<void> mount(
    WidgetTester tester,
    Widget child, {
    double scale = 1,
    double width = 350,
    Brightness brightness = Brightness.light,
    TextDirection direction = TextDirection.ltr,
    double? lineHeight,
    double? letterSpacing,
  }) async {
    tester.view.physicalSize = Size(width + 40, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          brightness: brightness,
          colorSchemeSeed: NodeLaneTokens.defaultMobileAccent,
        ),
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQueryData(
            size: MediaQuery.sizeOf(context),
            textScaler: TextScaler.linear(scale),
            lineHeightScaleFactorOverride: lineHeight,
            letterSpacingOverride: letterSpacing,
          ),
          child: Directionality(textDirection: direction, child: child!),
        ),
        home: Scaffold(
          body: Center(
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  for (final (width, scale, lineHeight, brightness) in [
    (350.0, 1.0, null, Brightness.light),
    (280.0, 2.0, null, Brightness.dark),
    (350.0, 3.0, null, Brightness.light),
    (350.0, 1.1, 1.6, Brightness.dark),
    (280.0, 2.0, 2.0, Brightness.light),
  ]) {
    testWidgets(
      'card dimensions and text fit at width $width, scale $scale, line height $lineHeight',
      (tester) async {
        Size? reference;
        for (final action in SourceCardAction.values) {
          for (final pricing in SourcePricing.values) {
            final source = _source(pricing, adult: pricing.index.isEven);
            await mount(
              tester,
              SourceWebsiteCard(
                source: source,
                action: action,
                onOpen: () {},
                onAction: () {},
                onDetails: () {},
                onLongPress: () {},
              ),
              width: width,
              scale: scale,
              lineHeight: lineHeight,
              brightness: brightness,
            );
            final size = tester.getSize(find.byType(SourceWebsiteCard));
            reference ??= size;
            expect(
              size,
              reference,
              reason: '$action $pricing changed the geometry',
            );
            final language = tester.getRect(find.text('中文(Zhōngwén)'));
            final classification = tester.getRect(find.textContaining('日漫'));
            expect(language.bottom, lessThanOrEqualTo(classification.top));
            for (final element
                in find
                    .descendant(
                      of: find.byType(SourceWebsiteCard),
                      matching: find.byType(RichText),
                    )
                    .evaluate()) {
              final paragraph = element.renderObject! as RenderParagraph;
              expect(
                paragraph.size.height,
                greaterThanOrEqualTo(
                  paragraph.getMaxIntrinsicHeight(paragraph.size.width) - .001,
                ),
                reason: '${paragraph.text.toPlainText()} is clipped',
              );
            }
            expect(tester.takeException(), isNull);
          }
        }
      },
    );
  }

  testWidgets(
    'classification count follows width and text settings on resize',
    (tester) async {
      final card = SourceWebsiteCard(
        source: _source(SourcePricing.free),
        action: SourceCardAction.open,
        onOpen: () {},
        onAction: () {},
        onDetails: () {},
        onLongPress: () {},
      );
      for (final (width, scale, spacing, visible, hidden) in [
        (350.0, 1.0, null, '日漫 / 韩漫 / 国漫 / 欧美漫画', 4),
        (539.0, 1.0, null, '日漫 / 韩漫 / 国漫 / 欧美漫画 / 页漫 / 条漫 / 原创 / 同人', 0),
        (538.0, 1.0, null, '日漫 / 韩漫 / 国漫 / 欧美漫画 / 页漫 / 条漫 / 原创', 1),
        (280.0, 1.0, null, '日漫 / 韩漫 / 国漫', 5),
        (350.0, 2.0, null, '日漫 / 韩漫', 6),
        (350.0, 1.0, 2.0, '日漫 / 韩漫 / 国漫', 5),
        (350.0, 1.0, null, '日漫 / 韩漫 / 国漫 / 欧美漫画', 4),
      ]) {
        await mount(
          tester,
          card,
          width: width,
          scale: scale,
          letterSpacing: spacing,
        );
        expect(find.text(visible), findsOneWidget);
        expect(
          find.textContaining(RegExp(r'^\+\d+$')),
          hidden == 0 ? findsNothing : findsOneWidget,
        );
        if (hidden > 0) {
          expect(find.text('+$hidden'), findsOneWidget);
          expect(
            tester.getRect(find.text(visible)).right,
            lessThan(tester.getRect(find.text('+$hidden')).left),
          );
        }
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text(visible),
        );
        expect(
          paragraph.size.width,
          greaterThanOrEqualTo(
            paragraph.getMaxIntrinsicWidth(double.infinity) - .001,
          ),
        );
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('whole labels hide with exact single and double digit counts', (
    tester,
  ) async {
    const many = SourceCatalogMetadata(
      regions: ['jp', 'kr', 'cn', 'hk_tw', 'western', 'other'],
      formats: ['page', 'vertical', 'strip'],
      creations: ['original', 'fan', 'adaptation'],
    );
    for (final (metadata, width, visible, hidden) in [
      (const SourceCatalogMetadata(regions: ['hk_tw', 'cn']), 130.0, '', 2),
      (many, 220.0, '日漫 / 韩漫', 10),
      (many, 270.0, '日漫 / 韩漫 / 国漫', 9),
    ]) {
      await mount(
        tester,
        SourceWebsiteCard(
          source: Source(
            name: 'Fixture',
            lang: 'zh',
            catalogMetadataJson: jsonEncode(metadata.toJson()),
          ),
          action: SourceCardAction.open,
          onOpen: () {},
          onAction: () {},
          onDetails: () {},
          onLongPress: () {},
        ),
        width: width,
        direction: TextDirection.rtl,
      );
      expect(find.text(visible), findsOneWidget);
      expect(find.text('+$hidden'), findsOneWidget);
      expect(find.textContaining('港台漫画'), findsNothing);
      if (visible.isNotEmpty) {
        expect(
          tester.getRect(find.text('+$hidden')).right,
          lessThan(tester.getRect(find.text(visible)).left),
        );
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets(
    'footer and metadata actions are isolated; complete labels stay available',
    (tester) async {
      var opened = 0, updated = 0, longPressed = 0;
      final source = _source(SourcePricing.free, adult: true);
      await mount(
        tester,
        Builder(
          builder: (context) => SourceWebsiteCard(
            source: source,
            action: SourceCardAction.update,
            onOpen: () => opened++,
            onAction: () => updated++,
            onLongPress: () => longPressed++,
            onDetails: () => showSourceWebsiteInfo(context, source),
          ),
        ),
      );
      await tester.tap(find.text('更新'));
      expect([opened, updated], [0, 1]);
      await tester.tap(find.text('+4'));
      await tester.pumpAndSettle();
      expect(find.byType(NodeLaneCatalogSheet), findsOneWidget);
      expect(find.text('日漫、韩漫、国漫、欧美漫画'), findsOneWidget);
      expect(opened, 0);
      Navigator.of(tester.element(find.text('地区'))).pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text(source.name!));
      await tester.longPress(find.text(source.name!));
      expect([opened, longPressed], [1, 1]);
    },
  );

  testWidgets(
    'only an explicit NSFW flag shows the adult corner in RTL; pricing stays unknown',
    (tester) async {
      final semantics = tester.ensureSemantics();
      for (final flag in [true, false, null]) {
        await mount(
          tester,
          SourceWebsiteCard(
            source: Source(name: 'Fixture', lang: 'en', isNsfw: flag),
            action: SourceCardAction.retry,
            onOpen: () {},
            onAction: () {},
            onDetails: () {},
            onLongPress: () {},
          ),
          direction: TextDirection.rtl,
        );
        final adult = flag == true ? findsOneWidget : findsNothing;
        expect(find.text('18+'), adult);
        expect(find.bySemanticsLabel(RegExp('含 18')), adult);
        expect(find.text('收费未标注'), findsOneWidget);
        expect(find.text('分类未标注'), findsOneWidget);
        expect(find.text('免费阅读'), findsNothing);
        expect(tester.takeException(), isNull);
      }
      semantics.dispose();
    },
  );
}
