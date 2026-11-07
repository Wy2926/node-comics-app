import 'dart:convert';

enum SourcePricing { unknown, free, partial, paid }

/// Optional directory facts, independent of executable package metadata.
/// Missing/unsupported values are unknown, never inferred from a site's name.
class SourceCatalogMetadata {
  const SourceCatalogMetadata({
    this.regions = const [],
    this.formats = const [],
    this.creations = const [],
    this.pricing = SourcePricing.unknown,
  });

  final List<String> regions, formats, creations;
  final SourcePricing pricing;

  factory SourceCatalogMetadata.decode(String? encoded) {
    if (encoded == null) return const SourceCatalogMetadata();
    try {
      return SourceCatalogMetadata.fromJson(jsonDecode(encoded));
    } on FormatException {
      return const SourceCatalogMetadata();
    }
  }

  factory SourceCatalogMetadata.fromJson(Object? value) {
    if (value is! Map || value['schema'] != 1) {
      return const SourceCatalogMetadata();
    }
    List<String> values(String key) {
      final list = value[key];
      if (list is! List) return const [];
      return List.unmodifiable(
        list
            .whereType<String>()
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toSet(),
      );
    }

    return SourceCatalogMetadata(
      regions: values('regions'),
      formats: values('formats'),
      creations: values('creations'),
      pricing:
          SourcePricing.values
              .where((e) => e.name == value['pricing'])
              .firstOrNull ??
          SourcePricing.unknown,
    );
  }

  Map<String, dynamic> toJson() => {
    'schema': 1,
    'regions': regions,
    'formats': formats,
    'creations': creations,
    'pricing': pricing.name,
  };
}
