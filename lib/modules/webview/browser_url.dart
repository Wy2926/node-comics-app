/// The same navigation boundary is used by address input and WebView requests.
bool isBrowserUrl(dynamic value) {
  if (value is! String || value.length > 8192) return false;
  final uri = Uri.tryParse(value);
  return uri != null &&
      {'http', 'https'}.contains(uri.scheme) &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty;
}

String? normalizeBrowserAddress(String value) {
  final text = value.trim();
  if (isBrowserUrl(text)) return text;
  if (text.contains('://') || text.contains(RegExp(r'\s'))) return null;
  final candidate = 'https://$text';
  final host = Uri.tryParse(candidate)?.host ?? '';
  return host.contains('.') && isBrowserUrl(candidate) ? candidate : null;
}
