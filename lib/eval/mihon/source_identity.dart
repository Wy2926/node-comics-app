import 'dart:convert';

import 'package:mangayomi/models/source.dart';

extension MihonSourceIdentity on Source {
  /// Keep the database ID unchanged, but send the original 64-bit source ID
  /// to the bridge. Dart hashCode is not the JVM's hashCode, and source
  /// factories can contain several sources with the same language and URL.
  Map<String, dynamic> get mihonSourceIdentity {
    String? originalId;
    try {
      final metadata = jsonDecode(additionalParams ?? '');
      if (metadata is Map) {
        originalId = metadata['mihonSourceId']?.toString();
      }
    } on FormatException {
      // Existing installed sources predate original-ID metadata.
    }
    return {
      'sourceId': originalId ?? id?.toString(),
      'sourceBaseUrl': baseUrl,
      'lang': lang,
    };
  }
}
