import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/source_catalog_metadata.dart';

void main() {
  test('directory facts round-trip independently from package data', () {
    final source = Source.fromJson({
      'id': 1,
      'name': 'Fixture',
      'lang': 'zh',
      'nodelane': {'schema': 1, 'slug': 'fixture'},
      'catalogMetadata': {
        'schema': 1,
        'pricing': 'partial',
        'regions': ['kr', 'cn', 'kr', 3],
        'formats': ['vertical'],
        'creations': ['fan'],
      },
    });
    final restored = Source.fromJson(jsonDecode(jsonEncode(source.toJson())));
    expect(restored.catalogMetadata.pricing, SourcePricing.partial);
    expect(restored.catalogMetadata.regions, ['kr', 'cn']);
    expect(restored.catalogMetadata.formats, ['vertical']);
    expect(restored.catalogMetadata.creations, ['fan']);
    expect(restored.toJson()['nodelane'], {'schema': 1, 'slug': 'fixture'});
  });

  test(
    'missing, invalid and future optional facts never imply free content',
    () {
      for (final value in [
        null,
        [],
        {'schema': 2, 'pricing': 'free'},
        {'schema': 1, 'pricing': 'subscription', 'regions': 4},
      ]) {
        final source = Source.fromJson({
          'id': 1,
          'name': '免费漫画',
          'lang': 'ja',
          'catalogMetadata': value,
        });
        expect(source.catalogMetadata.pricing, SourcePricing.unknown);
        expect(source.catalogMetadata.regions, isEmpty);
      }
      expect(
        Source(catalogMetadataJson: 'broken').catalogMetadata.pricing,
        SourcePricing.unknown,
      );
    },
  );
}
