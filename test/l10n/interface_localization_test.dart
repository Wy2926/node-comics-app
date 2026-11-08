import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/generated/app_localizations_en.dart';
import 'package:mangayomi/l10n/generated/app_localizations_zh.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/source_catalog_metadata.dart';
import 'package:mangayomi/modules/browse/global_search/source_search_scope.dart';
import 'package:mangayomi/modules/browse/widgets/source_website_card.dart';
import 'package:mangayomi/modules/translation/translation_display_switch.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/translation/contracts.dart';

void main() {
  test(
    'counts and optional translation issues use localized complete messages',
    () {
      final en = AppLocalizationsEn(), zh = AppLocalizationsZh();
      expect(en.search_websites_action(1), 'Search 1 website');
      expect(en.search_websites_action(2), 'Search 2 websites');
      expect(en.source_selected_count(0), '0 items selected');
      expect(zh.source_selected_count(2), '已选择 2 项');
      expect(en.translation_progress(1, 2, 0), 'Completed 1 / 2 images');
      expect(
        en.translation_progress(1, 2, 1),
        contains('1 image needs attention'),
      );
      expect(
        en.translation_progress(1, 3, 2),
        contains('2 images need attention'),
      );
      expect(zh.translation_progress(1, 3, 2), '已完成 1 / 3 张 · 2 张需要处理');
      for (final locale in AppLocalizations.supportedLocales) {
        final l10n = lookupAppLocalizations(locale);
        expect(l10n.browser_tab_count(2), isNotEmpty);
        expect(l10n.translation_progress(1, 3, 2), isNot(contains('{')));
      }
    },
  );

  testWidgets(
    'switching languages keeps source selection and translation value',
    (tester) async {
      final locale = ValueNotifier(const Locale('en'));
      addTearDown(locale.dispose);
      var translated = false;
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, value, _) => MaterialApp(
            navigatorKey: navigatorKey,
            locale: value,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    TranslationDisplaySwitch(
                      translated: translated,
                      onChanged: (value) => setState(() => translated = value),
                    ),
                    Expanded(
                      child: SourceSearchScopeSheet(
                        sources: [
                          Source(id: 1, name: 'Example', lang: 'en'),
                          Source(id: 2, name: 'Second', lang: 'en'),
                        ],
                        current: const SourceSearchScope(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Search 2 websites'), findsOneWidget);
      await tester.tap(find.text('Example'));
      await tester.pumpAndSettle();
      expect(find.text('Search 1 website'), findsOneWidget);
      expect(
        const TranslationFailure('AUTH_REQUIRED').message,
        AppLocalizationsEn().translation_auth_required,
      );
      await tester.tap(find.text('Translated'));
      await tester.pumpAndSettle();
      expect(translated, isTrue);
      locale.value = const Locale('zh');
      await tester.pumpAndSettle();
      expect(find.text('搜索这 1 个网站'), findsOneWidget);
      expect(find.text('译图'), findsOneWidget);
      expect(
        const TranslationFailure('AUTH_REQUIRED').message,
        AppLocalizationsZh().translation_auth_required,
      );
      expect(find.text('Translated'), findsNothing);
      expect(translated, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('English source metadata fits a narrow screen', (tester) async {
    tester.view.physicalSize = const Size(320, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SourceWebsiteCard(
                  source: Source(
                    name: 'Example source',
                    lang: 'all',
                    catalogMetadataJson: jsonEncode(
                      const SourceCatalogMetadata(
                        regions: ['hk_tw'],
                        pricing: SourcePricing.unknown,
                      ).toJson(),
                    ),
                  ),
                  action: SourceCardAction.retry,
                  onAction: () {},
                  onOpen: () {},
                  onDetails: () {},
                  onLongPress: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Pricing not specified'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.byTooltip('重试'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
