import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/interface.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/log/log.dart';

class _IsolateData {
  final SendPort sendPort;
  final RootIsolateToken rootIsolateToken;
  final String databasePath;
  final String databaseName;

  _IsolateData({
    required this.sendPort,
    required this.rootIsolateToken,
    required this.databasePath,
    required this.databaseName,
  });
}

class _IsolateWorker {
  Isolate? isolate;
  ReceivePort? receivePort;
  StreamSubscription? receiveSub;
  SendPort? sendPort;
  bool isBusy = false;
  bool stopped = false;
  void Function()? cancelRequest;
  final _shutdown = Completer<void>();
  Future<void>? _stopping;

  Future<void> start(RootIsolateToken rootToken) async {
    receivePort = ReceivePort();
    isolate = await Isolate.spawn(
      GetIsolateService._getIsolateServiceEntryPoint,
      _IsolateData(
        sendPort: receivePort!.sendPort,
        rootIsolateToken: rootToken,
        databasePath: isar.directory!,
        databaseName: isar.name,
      ),
    );
    if (stopped) {
      isolate?.kill(priority: Isolate.immediate);
      throw StateError('Isolate service stopped');
    }

    final completer = Completer<SendPort>();
    receiveSub = receivePort!.listen((message) {
      if (message == null && !_shutdown.isCompleted) _shutdown.complete();
      if (message is SendPort) {
        completer.complete(message);
      }
      if (message is String) {
        final logged = redactHeadersInText(message);
        if (logged.startsWith('LoggerLevel.warning:')) {
          Logger.add(
            LoggerLevel.warning,
            logged.replaceFirst('LoggerLevel.warning:', ''),
          );
        } else {
          Logger.add(LoggerLevel.info, logged);
        }
        if (kDebugMode) {
          print(message.replaceFirst('LoggerLevel.warning:', ''));
        }
      }
    });

    try {
      sendPort = await completer.future.timeout(const Duration(seconds: 5));
    } catch (_) {
      await stop();
      rethrow;
    }
  }

  Future<void> stop() => _stopping ??= _stop();

  Future<void> _stop() async {
    stopped = true;
    cancelRequest?.call();
    cancelRequest = null;
    sendPort?.send('dispose');
    if (sendPort != null) {
      // Let cooperative workers release native engines/database handles before
      // killing the isolate. An unresponsive worker is never returned to the pool.
      await _shutdown.future.timeout(
        const Duration(milliseconds: 500),
        onTimeout: () {},
      );
    }
    isolate?.kill(priority: Isolate.immediate);
    await receiveSub?.cancel();
    receivePort?.close();
  }
}

class GetIsolateService {
  GetIsolateService({this.responseTimeout = const Duration(seconds: 40)});

  final Duration responseTimeout;
  bool _isRunning = false;
  final List<_IsolateWorker> _workers = [];
  final List<Completer<_IsolateWorker>> _pendingWorkers = [];
  static const int _poolSize = 4;

  Future<void> start() async {
    _isRunning =
        true; // Workers are created on demand, up to the existing limit.
  }

  static Future<void> _getIsolateServiceEntryPoint(
    _IsolateData isolateData,
  ) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(
      isolateData.rootIsolateToken,
    );

    await initializeDateFormatting();

    isar = await StorageProvider().openDB(
      isolateData.databasePath,
      name: isolateData.databaseName,
    );

    final receivePort = ReceivePort();
    final activeServices = <ExtensionService>{};
    Zone.current
        .fork(
          specification: ZoneSpecification(
            print: (self, parent, zone, line) {
              isolateData.sendPort.send(line);
            },
          ),
        )
        .run(() async {
          isolateData.sendPort.send(receivePort.sendPort);
          receivePort.listen((message) async {
            if (message is Map<String, dynamic>) {
              final responsePort = message['responsePort'] as SendPort;
              try {
                final url = message['url'] as String?;
                final page = message['page'] as int?;
                final query = message['query'] as String?;
                final filterList = message['filterList'] as List?;
                final source = message['source'] as Source?;
                final proxyServer = message['proxyServer'] as String?;
                final serviceType = message['serviceType'] as String?;
                final useLoggerValue = message['useLogger'] as bool?;
                cfPort = message['cfPort'] as int;
                if (useLoggerValue != null) {
                  useLogger = useLoggerValue;
                }
                final service =
                    serviceType == 'prepareInstallation' &&
                        source?.sourceCodeLanguage ==
                            SourceCodeLanguage.javascript
                    ? JsExtensionService(
                        source!,
                        executionTimeout: const Duration(seconds: 5),
                      )
                    : getExtensionService(source!, proxyServer ?? '');
                activeServices.add(service);
                try {
                  final result = await (() async {
                    switch (serviceType) {
                      case 'getDetail':
                        return await service.getDetail(url!);
                      case 'getPopular':
                        return await service.getPopular(page!);
                      case 'getLatestUpdates':
                        return await service.getLatestUpdates(page!);
                      case 'search':
                        return await service.search(query!, page!, filterList!);
                      case 'getVideoList':
                        return await service.getVideoList(url!);
                      case 'getPageList':
                        return await service.getPageList(url!);
                      case 'getHtmlContent':
                        return await service.getHtmlContent(query ?? '', url!);
                      case 'getHeaders':
                      case 'prepareInstallation':
                        return Future.value(service.getHeaders());
                      default:
                        throw Exception('Unknown service type: $serviceType');
                    }
                  })();
                  responsePort.send({'success': true, 'data': result});
                } finally {
                  if (activeServices.remove(service)) service.dispose();
                }
              } catch (e) {
                responsePort.send({'success': false, 'error': e.toString()});
              } finally {
                useLogger = false;
              }
            } else if (message == 'dispose') {
              for (final service in activeServices) {
                service.dispose();
              }
              activeServices.clear();
              await isar.close();
              isolateData.sendPort.send(null);
              receivePort.close();
            }
          });
        });
  }

  Future<_IsolateWorker> _getAvailableWorker() async {
    if (!_isRunning) {
      throw Exception('Isolate service not running');
    }
    for (final worker in _workers) {
      if (!worker.isBusy) {
        worker.isBusy = true;
        return worker;
      }
    }
    if (_workers.length < _poolSize) {
      final worker = _IsolateWorker()..isBusy = true;
      _workers.add(worker);
      try {
        await worker.start(RootIsolateToken.instance!);
        if (!_isRunning || worker.stopped) {
          throw StateError('Isolate service stopped');
        }
        return worker;
      } catch (error, stack) {
        _workers.remove(worker);
        await worker.stop();
        for (final waiting in _pendingWorkers) {
          waiting.completeError(error, stack);
        }
        _pendingWorkers.clear();
        rethrow;
      }
    }
    final completer = Completer<_IsolateWorker>();
    _pendingWorkers.add(completer);
    return completer.future;
  }

  void _releaseWorker(_IsolateWorker worker) {
    if (!_isRunning || !_workers.contains(worker)) return;
    worker.isBusy = false;
    if (_pendingWorkers.isNotEmpty) {
      final next = _pendingWorkers.removeAt(0);
      worker.isBusy = true;
      next.complete(worker);
    }
  }

  Future<T> get<T>({
    String? url,
    int? page,
    String? query,
    List<dynamic>? filterList,
    Source? source,
    String? serviceType,
    String? proxyServer,
    bool? autoUpdateExtensions,
    String? androidProxyServer,
    bool? useLogger,
  }) async {
    if (serviceType != 'prepareInstallation' &&
        source?.sourceCodeLanguage != SourceCodeLanguage.lnreader) {
      return withExtensionService(source!, proxyServer ?? '', (service) async {
        switch (serviceType) {
          case 'getDetail':
            return (await service.getDetail(url!)) as T;
          case 'getPopular':
            return (await service.getPopular(page!)) as T;
          case 'getLatestUpdates':
            return (await service.getLatestUpdates(page!)) as T;
          case 'search':
            return (await service.search(query!, page!, filterList!)) as T;
          case 'getVideoList':
            return (await service.getVideoList(url!)) as T;
          case 'getPageList':
            return (await service.getPageList(url!)) as T;
          case 'getHtmlContent':
            return (await service.getHtmlContent(query ?? '', url!)) as T;
          case 'getHeaders':
            return (service.getHeaders()) as T;
          default:
            throw Exception('Unknown service type: $serviceType');
        }
      });
    }
    if (!_isRunning) {
      await start();
    }

    final worker = await _getAvailableWorker();
    final responsePort = ReceivePort();
    final completer = Completer<T>();
    late final StreamSubscription sub;

    final timer = Timer(responseTimeout, () async {
      if (!completer.isCompleted) {
        completer.completeError(TimeoutException('Isolate response timeout'));
        sub.cancel();
        responsePort.close();
        worker.cancelRequest = null;
        _workers.remove(worker);
        await worker.stop();
        if (_isRunning && _pendingWorkers.isNotEmpty) {
          final waiting = _pendingWorkers.removeAt(0);
          _getAvailableWorker().then(
            waiting.complete,
            onError: waiting.completeError,
          );
        }
      }
    });
    worker.cancelRequest = () {
      if (!completer.isCompleted) {
        completer.completeError(StateError('Isolate service stopped'));
      }
      timer.cancel();
      sub.cancel();
      responsePort.close();
    };

    sub = responsePort.listen((response) {
      if (completer.isCompleted) return;
      timer.cancel();
      worker.cancelRequest = null;
      sub.cancel();
      responsePort.close();
      _releaseWorker(worker);
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          completer.complete(response['data'] as T);
        } else {
          completer.completeError(response['error']);
        }
      } else {
        completer.completeError('Invalid isolate response: $response');
      }
    });

    try {
      worker.sendPort!.send({
        'url': ?url,
        'page': ?page,
        'query': ?query,
        'filterList': ?filterList,
        'serviceType': ?serviceType,
        'source': ?source,
        'proxyServer': ?proxyServer,
        'responsePort': responsePort.sendPort,
        'useLogger': ?useLogger,
        'cfPort': cfPort,
      });
    } catch (e) {
      timer.cancel();
      worker.cancelRequest = null;
      sub.cancel();
      responsePort.close();
      _releaseWorker(worker);
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<void> stop() async {
    _isRunning = false;
    final workers = _workers.toList();
    _workers.clear();
    for (final worker in workers) {
      await worker.stop();
    }
    for (final pending in _pendingWorkers) {
      if (!pending.isCompleted) {
        pending.completeError(StateError('Isolate service stopped'));
      }
    }
    _pendingWorkers.clear();
    _isRunning = false;
  }
}

final getIsolateService = GetIsolateService();
