import 'package:mangayomi/l10n/generated/app_localizations.dart';

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
import 'package:mangayomi/modules/translation/translation_image_status.dart';
import 'package:mangayomi/modules/translation/translation_image_actions.dart';

import 'image_archive.dart';

class WebTranslationBridge {
  WebTranslationBridge(
    this.controller,
    this.view,
    this.tabId, {
    required AppLocalizations l10n,
    Map<String, Object> theme = const {},
    this.onImageMenu,
  }) : _theme = theme,
       _l10n = l10n {
    controller.addJavaScriptHandler(
      handlerName: 'nodelaneImages',
      callback: (JavaScriptHandlerFunctionData data) => _receive(data),
    );
    view.addListener(_changed);
  }
  late final _archive = WebImageArchive(
    save: (path) => controller.saveWebArchive(filePath: path),
    apple: Platform.isIOS || Platform.isMacOS,
  );
  ChannelRuntime? _archiveRuntime;
  final InAppWebViewController controller;
  final TranslationViewController view;
  final String tabId;
  final Future<void> Function(TranslationTarget)? onImageMenu;
  Map<String, Object> _theme;
  AppLocalizations _l10n;

  void updatePresentation(Map<String, Object> theme, AppLocalizations l10n) {
    if (jsonEncode(theme) == jsonEncode(_theme) &&
        l10n.localeName == _l10n.localeName) {
      return;
    }
    _theme = theme;
    _l10n = l10n;
    _changed();
  }

  final _inputQueue = DbWriteQueue(), _outputQueue = DbWriteQueue();
  final _elements = <String, Map<String, dynamic>>{};
  final _displayed = <String, String>{};
  final _sending = <String>{};
  String _token = '', _document = '', _state = '';
  int _sequence = 0, _epoch = 0;
  bool _ready = false, _disposed = false;
  bool get active => view.foreground && view.runtime != null && !_disposed;

  void navigate() {
    _archive.clear();
    _epoch++;
    _ready = false;
    _token = '';
    _sequence = 0;
    _state = '';
    _elements.clear();
    _displayed.clear();
    view.window(const []);
  }

  Future<void> install(Uri url) async {
    if (_disposed || !{'https', 'http'}.contains(url.scheme)) return;
    // WebView can report load completion more than once for one document.
    // A new script starts a new sequence and invalidates the prior display.
    navigate();
    final epoch = _epoch;
    final token = translationUuid();
    _token = token;
    _document = url.removeFragment().toString();
    final script = await rootBundle.loadString('assets/nodelane_reader.js');
    if (_disposed || epoch != _epoch) return;
    await controller.evaluateJavascript(
      source: script.replaceFirst(
        '__NODELANE_CONFIG__',
        jsonEncode({'token': token}),
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
    if (value['token'] != _token ||
        value['seq'] is! int ||
        value['seq'] <= _sequence) {
      return false;
    }
    _sequence = value['seq'] as int;
    if (value['action'] != null) {
      final id = value['id'];
      final entry = _elements[id];
      if (entry == null || value['revision'] != entry['revision']) {
        return false;
      }
      final page = entry['page'] as TranslationPage;
      final target = view.targetFor(page);
      if (target == null) return false;
      if (value['action'] == 'menu') {
        if (onImageMenu == null ||
            translationImageMenuActions(view, target).isEmpty) {
          return false;
        }
        await onImageMenu!(target);
        return true;
      }
      final action = TranslationAction.values
          .where((a) => a.name == value['action'])
          .firstOrNull;
      if (action == null ||
          TranslationImageStatus.forTarget(view, target, _l10n).action !=
              action) {
        return false;
      }
      await view.perform(target, action);
      return true;
    }
    final items = value['items'];
    if (items is! List || items.length > 4) return false;
    final targets = <TranslationTarget>[];
    final entries = <String, Map<String, dynamic>>{};
    for (final item in items) {
      if (item is! Map ||
          item['id'] is! String ||
          item['revision'] is! String ||
          !{'http', 'pixels'}.contains(item['kind']) ||
          item['url'] is! String) {
        return false;
      }
      final id = item['id'] as String;
      if (!RegExp(r'^\d+$').hasMatch(id) || entries.containsKey(id)) {
        return false;
      }
      final entry = Map<String, dynamic>.from(item);
      final page = TranslationPage(
        translationKey(['web', _token, id]),
        translationKey(item['revision']),
      );
      entry['page'] = page;
      entries[id] = entry;
      targets.add(
        TranslationTarget(page, _WebImageSource(this, id, entry, _epoch)),
      );
    }
    _elements
      ..clear()
      ..addAll(entries);
    _displayed.removeWhere((id, _) => !entries.containsKey(id));
    _syncArchive();
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
    final result = await controller.callAsyncJavaScript(
      functionBody: '''
try {
  return {value: await window.__nodelaneReader.call(token, operation, args)};
} catch (error) {
  return {error: error.message};
}
''',
      arguments: {'token': _token, 'operation': operation, 'args': args},
    );
    if (!_ready || _disposed || epoch != _epoch) {
      throw const TranslationCancelled();
    }
    if (result == null || result.error != null || result.value is! Map) {
      throw const TranslationFailure('BRIDGE_INVALID');
    }
    final payload = result.value as Map;
    if (payload['error'] == 'SOURCE_CHANGED') {
      throw const TranslationCancelled();
    }
    if (payload['error'] != null) {
      throw TranslationFailure(switch (payload['error']) {
        'SOURCE_MISSING' || 'RESOURCE_LIMIT' => payload['error'] as String,
        _ => 'BRIDGE_INVALID',
      });
    }
    return payload['value'];
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
    _syncArchive();
    if (!_ready || _disposed) return;
    final status = {
      'active': active,
      'translated': view.showTranslation,
      'theme': _theme,
      'items': [
        if (active)
          for (final entry in _elements.entries)
            if (view.targetFor(entry.value['page'] as TranslationPage)
                case final target?)
              {
                'id': entry.key,
                'revision': entry.value['revision'],
                'menu':
                    onImageMenu != null &&
                    translationImageMenuActions(view, target).isNotEmpty,
                ...TranslationImageStatus.forTarget(
                  view,
                  target,
                  _l10n,
                ).toJson(_l10n),
              },
      ],
    };
    final state = jsonEncode(status);
    if (_state != state) {
      _state = state;
      if (!active || !view.showTranslation) _displayed.clear();
      final epoch = _epoch;
      // Display switches must not wait behind a full image's chunk transfer.
      _call('state', status, epoch).catchError((_) {
        if (epoch == _epoch && _state == state) _state = '';
        return null;
      });
    }
    if (!active || !view.showTranslation) return;
    for (final entry in _elements.entries) {
      final page = entry.value['page'] as TranslationPage;
      final image = view.images[page.identity];
      final signature = '${entry.value['revision']}:${image?.file.path}';
      if (image == null && _displayed.remove(entry.key) != null) {
        final epoch = _epoch;
        _outputQueue
            .run(() => _call('resultClear', {'id': entry.key}, epoch))
            .catchError((_) => null);
      }
      if (image == null ||
          _displayed[entry.key] == signature ||
          !_sending.add(entry.key)) {
        continue;
      }
      final epoch = _epoch;
      _outputQueue
          .run(() async {
            if (!active ||
                epoch != _epoch ||
                view.images[page.identity] != image) {
              return;
            }
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
                if (!active || view.images[page.identity] != image) {
                  throw const TranslationCancelled();
                }
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
              if (!active || view.images[page.identity] != image) {
                throw const TranslationCancelled();
              }
              await _call('resultEnd', {'id': entry.key}, epoch);
              if (epoch == _epoch) {
                if (view.images[page.identity] == image) {
                  _displayed[entry.key] = signature;
                } else {
                  await _call('resultClear', {'id': entry.key}, epoch);
                }
              }
            } finally {
              await file.close();
            }
          })
          .catchError((_) async {
            if (_ready && epoch == _epoch) {
              await _call('resultAbort', {}, epoch).catchError((_) => null);
            }
          })
          .whenComplete(() {
            _sending.remove(entry.key);
            if (epoch != _epoch || view.images[page.identity] != image) {
              _changed();
            }
          });
    }
  }

  void _syncArchive() {
    if (!active || !identical(_archiveRuntime, view.runtime)) {
      _archive.clear();
      _archiveRuntime = view.runtime;
    }
    if (active) {
      _archive.retain({
        for (final entry in _elements.values)
          if (entry['kind'] == 'http')
            (entry['page'] as TranslationPage).identity: Uri.parse(
              entry['url'] as String,
            ).removeFragment().toString(),
      });
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
      // Runtime scheduling can start before the view's changed notification.
      _syncArchive();
      final pageUrl = Uri.parse(_document),
          url = Uri.parse(entry['url'] as String);
      final original =
          await _archive.acquire(
            (entry['page'] as TranslationPage).identity,
            cancel,
          ) ??
          await HttpSourceImageReader(
            url,
            headers: (target) async {
              final cookies = await CookieManager.instance().getCookies(
                url: WebUri(target.toString()),
              );
              final sameOrigin = target.origin == pageUrl.origin;
              return {
                'Referer': sameOrigin ? _document : '${pageUrl.origin}/',
                'Cookie': cookies
                    .map((cookie) => '${cookie.name}=${cookie.value}')
                    .join('; '),
                'User-Agent':
                    await InAppWebViewController.getDefaultUserAgent(),
              };
            },
          ).acquire(entry['page'] as TranslationPage, cancel);
      try {
        cancel.check();
        if (!active ||
            epoch != _epoch ||
            _elements[id]?['revision'] != entry['revision']) {
          throw const TranslationCancelled();
        }
        await _call('validate', {
          'id': id,
          'revision': entry['revision'],
        }, epoch);
        return original;
      } catch (_) {
        original.release();
        rethrow;
      }
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
        if (meta is! Map || meta['size'] is! int || meta['size'] <= 0) {
          throw const TranslationFailure('BRIDGE_INVALID');
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
    _archive.clear();
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
