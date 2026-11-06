import 'dart:collection';
import 'dart:convert';

import 'package:mangayomi/services/source_package.dart';
import 'package:mangayomi/services/source_catalog_config.dart';

import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/eval/javascript/dom_selector.dart';
import 'package:mangayomi/eval/javascript/js_errors.dart';
import 'package:mangayomi/eval/http_response_extensions.dart';
import 'package:mangayomi/eval/javascript/extractors.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/javascript/preferences.dart';
import 'package:mangayomi/eval/javascript/utils.dart';
import 'package:mangayomi/eval/javascript/source_runtime.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';

import '../interface.dart';

class JsExtensionService implements ExtensionService {
  late SourceJavascriptRuntime runtime;
  @override
  late Source source;
  bool _isInitialized = false;
  JsDomSelector? _jsDomSelector;
  bool _hasRuntime = false;

  JsExtensionService(this.source, {this.executionTimeout});
  final Duration? executionTimeout;

  void _init() {
    if (_isInitialized) return;
    runtime = SourceJavascriptRuntime(
      timeout: executionTimeout?.inMilliseconds,
    );
    _hasRuntime = true;
    try {
      JsHttpClient(runtime, package: SourcePackage.of(source)).init();
      _jsDomSelector = JsDomSelector(runtime)..init();
      JsUtils(runtime).init();
      JsVideosExtractors(runtime).init();
      JsPreferences(runtime, source).init();
      final sourceJson = jsonEncode(source.toMSource().toJson());

      runtime.evaluate('''
const NodeLane = Object.freeze({capabilities: Object.freeze(${jsonEncode(nodeLaneHostCapabilities.toList())})});
class MProvider {
    get source() {
        return $sourceJson;
    }
    get supportsLatest() {
        throw new Error("supportsLatest not implemented");
    }
    getHeaders(url) {
        throw new Error("getHeaders not implemented");
    }
    async getPopular(page) {
        throw new Error("getPopular not implemented");
    }
    async getLatestUpdates(page) {
        throw new Error("getLatestUpdates not implemented");
    }
    async search(query, page, filters) {
        throw new Error("search not implemented");
    }
    async getDetail(url) {
        throw new Error("getDetail not implemented");
    }
    async getPageList() {
        throw new Error("getPageList not implemented");
    }
    async getVideoList(url) {
        throw new Error("getVideoList not implemented");
    }
    async getHtmlContent(name, url) {
        throw new Error("getHtmlContent not implemented");
    }
    async cleanHtmlContent(html) {
        throw new Error("cleanHtmlContent not implemented");
    }
    getFilterList() {
        throw new Error("getFilterList not implemented");
    }
    getSourcePreferences() {
        throw new Error("getSourcePreferences not implemented");
    }
}
async function jsonStringify(fn) {
    return JSON.stringify(await fn());
}
''');
      // evaluate() reports a failure by returning a result with isError set; it
      // does not throw. Ignoring that meant a source which failed to evaluate
      // still set _isInitialized, so `extention` was never created and every
      // later call answered its default. That is what "Video list is empty"
      // was: not an empty list from the source, but a source that never loaded.
      // See #873.
      _throwIfError(
        runtime.evaluate('''${source.sourceCode}
var extention = new DefaultExtension();
'''),
        'loading the source',
      );
      _isInitialized = true;
    } catch (_) {
      dispose();
      rethrow;
    }
  }

  @override
  void dispose() {
    _jsDomSelector?.dispose();
    _jsDomSelector = null;
    if (_hasRuntime) runtime.dispose();
    _hasRuntime = false;
    _isInitialized = false;
  }

  @override
  Map<String, String> getHeaders() {
    return _extensionCall<Map>(
      'getHeaders(${jsonEncode(source.baseUrl ?? '')})',
      {},
    ).toMapStringString!;
  }

  @override
  bool get supportsLatest {
    return _extensionCall<bool>('supportsLatest', true);
  }

  @override
  String get sourceBaseUrl {
    return source.baseUrl!;
  }

  @override
  Future<MPages> getPopular(int page) async {
    return MPages.fromJson(await _extensionCallAsync('getPopular($page)'));
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    return MPages.fromJson(
      await _extensionCallAsync('getLatestUpdates($page)'),
    );
  }

  @override
  Future<MPages> search(String query, int page, List<dynamic> filters) async {
    return MPages.fromJson(
      await _extensionCallAsync(
        'search(${jsonEncode(query)},$page,${jsonEncode(filterValuesListToJson(filters))})',
      ),
    );
  }

  @override
  Future<MManga> getDetail(String url) async {
    return MManga.fromJson(
      await _extensionCallAsync('getDetail(${jsonEncode(url)})'),
    );
  }

  @override
  Future<List<PageUrl>> getPageList(String url) async {
    // Repeated URLs may be distinct page slots; retain source order and count.
    final pages = <PageUrl>[];

    for (final e in await _extensionCallAsync<List>(
      'getPageList(${jsonEncode(url)})',
    )) {
      if (e != null) {
        final page = e is String
            ? PageUrl(e.trim())
            : PageUrl.fromJson((e as Map).toMapStringDynamic!);
        pages.add(page);
      }
    }

    return pages.toList();
  }

  @override
  Future<List<Video>> getVideoList(String url) async {
    final videos = LinkedHashSet<Video>(
      equals: (a, b) => a.url == b.url && a.originalUrl == b.originalUrl,
      hashCode: (v) => Object.hash(v.url, v.originalUrl),
    );

    for (final element in await _extensionCallAsync<List>(
      'getVideoList(${jsonEncode(url)})',
    )) {
      if (element['url'] != null && element['originalUrl'] != null) {
        videos.add(Video.fromJson(element));
      }
    }
    return videos.toList();
  }

  @override
  Future<String> getHtmlContent(String name, String url) async {
    _init();
    final res = (await runtime.run(
      () async => runtime.handlePromise(
        await runtime.evaluateAsync(
          'jsonStringify(() => extention.getHtmlContent(${jsonEncode(name)}, ${jsonEncode(url)}))',
        ),
      ),
    )).stringResult;
    return res;
  }

  @override
  Future<String> cleanHtmlContent(String html) async {
    _init();
    final res = (await runtime.run(
      () async => runtime.handlePromise(
        await runtime.evaluateAsync(
          'jsonStringify(() => extention.cleanHtmlContent(${jsonEncode(html)}))',
        ),
      ),
    )).stringResult;
    return res;
  }

  @override
  FilterList getFilterList() {
    List<dynamic> list;

    try {
      list = fromJsonFilterValuesToList(_extensionCall('getFilterList()', []));
    } catch (_) {
      list = [];
    }

    return FilterList(list);
  }

  @override
  List<SourcePreference> getSourcePreferences() {
    return _extensionCall(
      'getSourcePreferences()',
      [],
    ).map((e) => SourcePreference.fromJson(e)..sourceId = source.id).toList();
  }

  T _extensionCall<T>(String call, T def) {
    _init();

    final res = runtime.evaluate('JSON.stringify(extention.$call)');
    if (res.isError) {
      // A source that simply does not implement an optional method is not a
      // failure, and falling back is the whole point of `def`. Anything else
      // is a real error and used to arrive as a JSON parse failure, or as
      // silence when def was non-null.
      if (_isNotImplemented(res) && def != null) return def;
      _throwIfError(res, call);
    }

    try {
      return jsonDecode(res.stringResult) as T;
    } catch (_) {
      if (def != null) return def;
      rethrow;
    }
  }

  Future<T> _extensionCallAsync<T>(String call) async {
    _init();

    final evaluated = await runtime.evaluateAsync(
      'jsonStringify(() => extention.$call)',
    );
    _throwIfError(evaluated, call);

    final promised = await runtime.run(() => runtime.handlePromise(evaluated));
    _throwIfError(promised, call);

    return jsonDecode(promised.stringResult) as T;
  }

  /// Turns a failed evaluation into an error that says what the source
  /// actually reported.
  ///
  /// Without this the message reaching the reader is either nothing at all or
  /// a JSON parse failure, neither of which says which source broke or why.
  void _throwIfError(JsEvalResult result, String what) {
    if (!result.isError) return;
    throw Exception(
      jsExtensionErrorMessage(
        sourceName: source.name ?? 'unknown',
        whileDoing: what,
        reported: result.stringResult,
      ),
    );
  }

  /// Whether this is the base class saying the source does not implement
  /// something, rather than the source going wrong.
  bool _isNotImplemented(JsEvalResult result) =>
      isNotImplementedError(result.stringResult);
}
