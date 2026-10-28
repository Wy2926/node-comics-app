import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/identity.dart';
import 'package:mangayomi/services/translation/source_file.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';

class WebTranslationBridge {
  WebTranslationBridge(this.controller, this.view, this.tabId) {
    controller.addJavaScriptHandler(
      handlerName: 'nodelaneImages',
      callback: (JavaScriptHandlerFunctionData data) => _receive(data),
    );
    view.addListener(_changed);
  }
  final InAppWebViewController controller;
  final TranslationViewController view;
  final String tabId;
  final _inputQueue = DbWriteQueue(), _outputQueue = DbWriteQueue();
  final _elements = <String, Map<String, dynamic>>{};
  final _displayed = <String, String>{};
  final _sending = <String>{};
  String _token = '', _document = '', _state = '';
  int _sequence = 0, _epoch = 0;
  bool _ready = false, _disposed = false;
  DateTime _lastMessage = DateTime.fromMillisecondsSinceEpoch(0);
  bool get active =>
      view.enabled && view.foreground && view.runtime != null && !_disposed;

  void navigate() {
    _epoch++;
    _ready = false;
    _token = '';
    _sequence = 0;
    _lastMessage = DateTime.fromMillisecondsSinceEpoch(0);
    _state = '';
    _elements.clear();
    _displayed.clear();
    view.window(const []);
  }

  Future<void> install(Uri url) async {
    if (_disposed || !{'https', 'http'}.contains(url.scheme)) return;
    final epoch = _epoch;
    final token = translationUuid();
    _token = token;
    _document = url.removeFragment().toString();
    final script = await rootBundle.loadString('assets/nodelane_reader.js');
    if (_disposed || epoch != _epoch) return;
    await controller.evaluateJavascript(
      source: script.replaceFirst(
        '__NODELANE_CONFIG__',
        jsonEncode({
          'token': token,
          'canvas': const bool.fromEnvironment('NODELANE_READABLE_CANVAS'),
        }),
      ),
    );
    if (_disposed || epoch != _epoch) return;
    _ready = true;
    _state = '';
    _changed();
  }

  Future<bool> _receive(JavaScriptHandlerFunctionData data) async {
    if (!active ||
        !_ready ||
        !data.isMainFrame ||
        data.args.length != 1 ||
        data.args.first is! Map) {
      return false;
    }
    final document = Uri.tryParse(_document);
    if (document == null ||
        data.origin.toString() != document.origin ||
        Uri.tryParse(data.requestUrl.toString())?.removeFragment().toString() !=
            _document) {
      return false;
    }
    final value = data.args.first as Map;
    if (jsonEncode(value).length > 65536 ||
        value['token'] != _token ||
        value['seq'] is! int ||
        value['seq'] <= _sequence) {
      return false;
    }
    _sequence = value['seq'] as int;
    if (DateTime.now().difference(_lastMessage) <
        const Duration(milliseconds: 80)) {
      return false;
    }
    _lastMessage = DateTime.now();
    final items = value['items'];
    if (items is! List || items.length > 4) return false;
    final epoch = _epoch;
    if ((await controller.getUrl())?.toString().split('#').first != _document ||
        epoch != _epoch ||
        !active) {
      return false;
    }
    final targets = <TranslationTarget>[];
    final entries = <String, Map<String, dynamic>>{};
    for (final item in items) {
      if (item is! Map ||
          item['id'] is! String ||
          item['revision'] is! String ||
          item['slot'] is! int ||
          (item['slot'] as int) < 0 ||
          (item['slot'] as int) >= 512 ||
          !{'http', 'blob', 'canvas'}.contains(item['kind']) ||
          item['url'] is! String) {
        return false;
      }
      final id = item['id'] as String;
      if (!RegExp(r'^\d{1,8}$').hasMatch(id) || entries.containsKey(id)) {
        return false;
      }
      final entry = Map<String, dynamic>.from(item);
      final page = TranslationPage(
        translationKey(['web', _document, item['slot']]),
        translationKey(item['revision']),
      );
      entry['page'] = page;
      entries[id] = entry;
      targets.add(
        TranslationTarget(page, _WebImageSource(this, id, entry, epoch)),
      );
    }
    _elements
      ..clear()
      ..addAll(entries);
    _displayed.removeWhere((id, _) => !entries.containsKey(id));
    view.window(targets);
    return true;
  }

  Future<dynamic> _call(
    String operation,
    Map<String, dynamic> args,
    int epoch,
  ) async {
    if (!_ready || _disposed || epoch != _epoch) {
      throw const TranslationCancelled();
    }
    final result = await controller
        .callAsyncJavaScript(
          functionBody: 'return await window.__nodelaneReader.call(token, operation, args);',
          arguments: {'token': _token, 'operation': operation, 'args': args},
        )
        .timeout(const Duration(seconds: 10));
    if (!_ready || _disposed || epoch != _epoch) {
      throw const TranslationCancelled();
    }
    if (result == null || result.error != null) {
      throw const TranslationFailure('BRIDGE_INVALID');
    }
    return result.value;
  }

  Future<Map<String, dynamic>?> captureAnchor() async {
    try {
      final value = await _call(
        'anchor',
        {},
        _epoch,
      ).timeout(const Duration(seconds: 2));
      return value is Map ? Map<String, dynamic>.from(value) : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> restoreAnchor(Map<String, dynamic>? anchor) async {
    if (anchor != null) await _call('restore', anchor, _epoch);
  }

  void _changed() {
    if (!_ready || _disposed) return;
    final state = '$active:${view.showTranslation}';
    if (_state != state) {
      _state = state;
      if (!active) _displayed.clear();
      _call('state', {
        'active': active,
        'translated': view.showTranslation,
      }, _epoch).catchError((_) => null);
    }
    if (!active || !view.showTranslation) return;
    for (final entry in _elements.entries) {
      final page = entry.value['page'] as TranslationPage;
      final image = view.images[page.identity];
      final signature = '${entry.value['revision']}:${image?.file.path}';
      if (image == null ||
          _displayed[entry.key] == signature ||
          !_sending.add(entry.key)) {
        continue;
      }
      final epoch = _epoch;
      _outputQueue
          .run(() async {
            if (!active || epoch != _epoch) return;
            final length = await image.file.length();
            await _call('resultBegin', {
              'id': entry.key,
              'revision': entry.value['revision'],
              'size': length,
            }, epoch);
            var offset = 0;
            final file = await image.file.open();
            try {
              while (offset < length) {
                if (!active) throw const TranslationCancelled();
                final bytes = await file.read(128 * 1024);
                if (bytes.isEmpty) {
                  throw const TranslationFailure('INVALID_RESULT');
                }
                await _call('resultChunk', {
                  'id': entry.key,
                  'offset': offset,
                  'data': base64Encode(bytes),
                }, epoch);
                offset += bytes.length;
              }
              await _call('resultEnd', {'id': entry.key}, epoch);
              if (epoch == _epoch) _displayed[entry.key] = signature;
            } finally {
              await file.close();
            }
          })
          .catchError((_) async {
            if (_ready && epoch == _epoch) {
              await _call('resultAbort', {}, epoch).catchError((_) => null);
            }
          })
          .whenComplete(() => _sending.remove(entry.key));
    }
  }

  Future<OriginalImageLease> acquire(
    String id,
    Map<String, dynamic> entry,
    int epoch,
    TranslationCancellation cancel,
  ) async {
    cancel.check();
    if (!active ||
        epoch != _epoch ||
        _elements[id]?['revision'] != entry['revision']) {
      throw const TranslationCancelled();
    }
    if (entry['kind'] == 'http') {
      final pageUrl = Uri.parse(_document),
          url = Uri.parse(entry['url'] as String);
      return HttpSourceImageReader(
        url,
        publicOnly: true,
        headers: (target) async {
          final cookies = await CookieManager.instance().getCookies(
            url: WebUri(target.toString()),
          );
          final sameOrigin = target.origin == pageUrl.origin;
          return {
            'Referer': sameOrigin ? _document : '${pageUrl.origin}/',
            'Cookie': cookies
                .where(
                  (cookie) =>
                      sameOrigin ||
                      (cookie.sameSite == HTTPCookieSameSitePolicy.NONE &&
                          cookie.isSecure == true),
                )
                .map((cookie) => '${cookie.name}=${cookie.value}')
                .join('; '),
            'User-Agent': await InAppWebViewController.getDefaultUserAgent(),
          };
        },
      ).acquire(entry['page'] as TranslationPage, cancel);
    }
    return _inputQueue.run(() async {
      cancel.check();
      final file = File(
        '${(await getTemporaryDirectory()).path}/nodelane-bridge-${translationUuid()}',
      );
      try {
        final meta = await _call('inputBegin', {
          'id': id,
          'revision': entry['revision'],
        }, epoch);
        if (meta is! Map ||
            meta['size'] is! int ||
            meta['size'] <= 0 ||
            meta['size'] > 32 * 1024 * 1024) {
          throw const TranslationFailure('RESOURCE_LIMIT');
        }
        final sink = file.openWrite();
        var offset = 0;
        try {
          while (offset < meta['size']) {
            cancel.check();
            final chunk = await _call('inputChunk', {
              'id': id,
              'offset': offset,
            }, epoch);
            if (chunk is! String || chunk.length > 174764) {
              throw const TranslationFailure('BRIDGE_INVALID');
            }
            final Uint8List bytes = base64Decode(chunk);
            if (bytes.isEmpty ||
                bytes.length > 128 * 1024 ||
                offset + bytes.length > meta['size']) {
              throw const TranslationFailure('BRIDGE_INVALID');
            }
            offset += bytes.length;
            sink.add(bytes);
            await sink.flush();
          }
        } finally {
          await sink.close();
        }
        cancel.check();
        return OriginalImageLease(
          file,
          release: () {
            file.delete().catchError((_) => file);
          },
        );
      } catch (_) {
        await file.delete().catchError((_) => file);
        rethrow;
      } finally {
        if (_ready && epoch == _epoch) {
          await _call('inputEnd', {}, epoch).catchError((_) => null);
        }
      }
    });
  }

  void dispose() {
    _disposed = true;
    _ready = false;
    _epoch++;
    view.removeListener(_changed);
    controller.removeJavaScriptHandler(handlerName: 'nodelaneImages');
  }
}

class _WebImageSource implements SourceImageReader {
  _WebImageSource(this.bridge, this.id, this.entry, this.epoch);
  final WebTranslationBridge bridge;
  final String id;
  final Map<String, dynamic> entry;
  final int epoch;
  @override
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  ) => bridge.acquire(id, entry, epoch, cancellation);
}
