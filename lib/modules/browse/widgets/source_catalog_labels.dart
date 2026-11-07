import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source_catalog_metadata.dart';

extension SourceCatalogLabels on SourceCatalogMetadata {
  List<String> get regionLabels => _labels(regions, const {
    'jp': '日漫',
    'kr': '韩漫',
    'cn': '国漫',
    'hk_tw': '港台漫画',
    'western': '欧美漫画',
    'other': '其他地区',
  });
  List<String> get formatLabels =>
      _labels(formats, const {'page': '页漫', 'vertical': '条漫', 'strip': '短篇条格'});
  List<String> get creationLabels => _labels(creations, const {
    'original': '原创',
    'fan': '同人',
    'adaptation': '改编',
  });
  List<String> get classificationLabels => [
    ...regionLabels,
    ...formatLabels,
    ...creationLabels,
  ];
}

List<String> _labels(List<String> keys, Map<String, String> labels) =>
    keys.map((key) => labels[key]).whereType<String>().toSet().toList();

String sourcePricingLabel(SourcePricing pricing, ItemType type) =>
    switch (pricing) {
      SourcePricing.free => type == ItemType.anime ? '免费观看' : '免费阅读',
      SourcePricing.partial => '部分收费',
      SourcePricing.paid => type == ItemType.anime ? '付费观看' : '付费阅读',
      SourcePricing.unknown => '收费未标注',
    };
