int compareVersions(String version1, String version2) {
  final clean1 = version1
      .trim()
      .replaceFirst(RegExp(r'^[vV]'), '')
      .split(RegExp(r'[-+]'))
      .first;
  final clean2 = version2
      .trim()
      .replaceFirst(RegExp(r'^[vV]'), '')
      .split(RegExp(r'[-+]'))
      .first;

  final v1Parts = clean1.split('.');
  final v2Parts = clean2.split('.');
  final maxLength = v1Parts.length > v2Parts.length
      ? v1Parts.length
      : v2Parts.length;

  for (var i = 0; i < maxLength; i++) {
    final v1Value = i < v1Parts.length ? (int.tryParse(v1Parts[i]) ?? 0) : 0;
    final v2Value = i < v2Parts.length ? (int.tryParse(v2Parts[i]) ?? 0) : 0;

    final comparison = v1Value.compareTo(v2Value);
    if (comparison != 0) return comparison;
  }

  return 0;
}
