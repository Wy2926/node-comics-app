import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source_catalog_metadata.dart';
import 'package:mangayomi/utils/language.dart';

String sourceLanguageLabel(String code, AppLocalizations l10n) =>
    switch (code.toLowerCase()) {
      '' => l10n.source_language_unknown,
      'all' => l10n.source_multilingual,
      final language => completeLanguageName(language),
    };

Map<String, String> sourceRegions(AppLocalizations l10n) => {
  'jp': l10n.source_region_jp,
  'kr': l10n.source_region_kr,
  'cn': l10n.source_region_cn,
  'hk_tw': l10n.source_region_hk_tw,
  'western': l10n.source_region_western,
  'other': l10n.source_region_other,
};
Map<String, String> sourceFormats(AppLocalizations l10n) => {
  'page': l10n.source_format_page,
  'vertical': l10n.source_format_vertical,
  'strip': l10n.source_format_strip,
};
Map<String, String> sourceCreations(AppLocalizations l10n) => {
  'original': l10n.source_creation_original,
  'fan': l10n.source_creation_fan,
  'adaptation': l10n.relation_adaptation,
};

extension SourceCatalogLabels on SourceCatalogMetadata {
  List<String> regionLabels(AppLocalizations l10n) =>
      _labels(regions, sourceRegions(l10n));
  List<String> formatLabels(AppLocalizations l10n) =>
      _labels(formats, sourceFormats(l10n));
  List<String> creationLabels(AppLocalizations l10n) =>
      _labels(creations, sourceCreations(l10n));
  List<String> classificationLabels(AppLocalizations l10n) => [
    ...regionLabels(l10n),
    ...formatLabels(l10n),
    ...creationLabels(l10n),
  ];
}

List<String> _labels(List<String> keys, Map<String, String> labels) =>
    keys.map((key) => labels[key]).whereType<String>().toSet().toList();

String sourcePricingLabel(
  SourcePricing pricing,
  ItemType type,
  AppLocalizations l10n,
) => switch (pricing) {
  SourcePricing.free =>
    type == ItemType.anime ? l10n.source_free_watch : l10n.source_free_read,
  SourcePricing.partial => l10n.source_partial_paid,
  SourcePricing.paid =>
    type == ItemType.anime ? l10n.source_paid_watch : l10n.source_paid_read,
  SourcePricing.unknown => l10n.source_pricing_unknown,
};
