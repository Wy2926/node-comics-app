/// The same navigation boundary is used by address input and WebView requests.
bool isBrowserUrl(dynamic value) {
  if (value is! String || value.length > 8192) return false;
  final uri = Uri.tryParse(value);
  return uri != null &&
      {'http', 'https'}.contains(uri.scheme) &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty;
}
