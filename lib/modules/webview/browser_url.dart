final _controlCharacters = RegExp(r'[\x00-\x1f\x7f]');

/// The same navigation boundary is used by address input and WebView requests.
bool isBrowserUrl(dynamic value) {
  if (value is! String ||
      value.length > 8192 ||
      _controlCharacters.hasMatch(value)) {
    return false;
  }
  final uri = Uri.tryParse(value);
  return uri != null &&
      {'http', 'https'}.contains(uri.scheme) &&
      uri.host.isNotEmpty &&
      !RegExp(r'\s|%').hasMatch(uri.host) &&
      uri.userInfo.isEmpty;
}

/// Source base paths are directories; a chapter may also name its own reader host.
String? resolveBrowserLink(String link, String? baseUrl) {
  if (isBrowserUrl(link)) return link;
  final relative = Uri.tryParse(link);
  if (link.isEmpty ||
      _controlCharacters.hasMatch(link) ||
      relative == null ||
      relative.hasScheme ||
      !isBrowserUrl(baseUrl)) {
    return null;
  }
  final base = Uri.parse(baseUrl!);
  final directory = base.path.endsWith('/')
      ? base
      : base.replace(path: '${base.path}/');
  final url = directory.resolveUri(relative).toString();
  return isBrowserUrl(url) ? url : null;
}

String? normalizeBrowserAddress(String value) {
  final text = value.trim();
  if (isBrowserUrl(text)) return text;
  if (text.contains('://') || text.contains(RegExp(r'\s'))) return null;
  final candidate = 'https://$text';
  final host = Uri.tryParse(candidate)?.host ?? '';
  return (host.contains('.') || host == 'localhost' || host.contains(':')) &&
          isBrowserUrl(candidate)
      ? candidate
      : null;
}

enum BrowserSearchEngine {
  google('Google', 'www.google.com', '/search', 'q'),
  bing('Bing', 'www.bing.com', '/search', 'q'),
  baidu('百度', 'www.baidu.com', '/s', 'wd'),
  duckDuckGo('DuckDuckGo', 'duckduckgo.com', '/', 'q'),
  yahoo('Yahoo', 'search.yahoo.com', '/search', 'p'),
  sogou('搜狗', 'www.sogou.com', '/web', 'query');

  const BrowserSearchEngine(this.label, this.host, this.path, this.parameter);
  final String label, host, path, parameter;
  String get logoAsset => 'assets/browser/$name.png';

  String search(String query) =>
      Uri.https(host, path, {parameter: query}).toString();
}

/// Reject explicit unsafe addresses instead of leaking them to a search engine.
String? resolveBrowserInput(
  String input, {
  BrowserSearchEngine engine = BrowserSearchEngine.google,
}) {
  final text = input.trim();
  if (text.isEmpty || _controlCharacters.hasMatch(text)) return null;
  final address = normalizeBrowserAddress(text);
  if (address != null) return address;
  if (text.contains('://') ||
      RegExp(
        r'^(javascript|data|file|about|blob|mailto|tel):',
        caseSensitive: false,
      ).hasMatch(text) ||
      RegExp(r'^[^\s/]+@[^\s/]+').hasMatch(text)) {
    return null;
  }
  final result = engine.search(text);
  return isBrowserUrl(result) ? result : null;
}
