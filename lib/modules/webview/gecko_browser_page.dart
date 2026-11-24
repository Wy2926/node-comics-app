import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show PlatformViewHitTestBehavior;
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/services/browser_host.dart';

import 'browser_page_controller.dart';
import 'browser_url.dart';
import 'image_archive.dart';
import 'reader_transport.dart';

class GeckoBrowserPage extends BrowserPageController
    implements ReaderTransport, BrowserProtection {
  GeckoBrowserPage(int id, Future<void> Function(MethodCall) onEvent)
    : _channel = MethodChannel('${browserHost.name}/$id') {
    _channel.setMethodCallHandler((event) async {
      if (event.method == 'blockerBadge') {
        _badge.value = event.arguments as String?;
        return null;
      }
      if (event.method == 'start') _badge.value = null;
      if (event.method == 'images') {
        final data = jsonDecode(event.arguments as String);
        if (data is! Map || !isBrowserUrl(data['url'])) return false;
        final url = data['url'] as String;
        return await _receive?.call(
              Uri.parse(url).origin,
              url,
              data['message'],
            ) ??
            false;
      }
      await onEvent(event);
      return null;
    });
  }
  final MethodChannel _channel;
  final _badge = ValueNotifier<String?>(null);
  @override
  Listenable get changes => _badge;
  ReaderMessage? _receive;
  static Widget view(Object leaseOrTicket, [ValueChanged<int>? created]) =>
      Builder(
        builder: (context) => PlatformViewLink(
          viewType: browserHost.name,
          surfaceFactory: (_, controller) => AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const {},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          ),
          // Gecko's SurfaceView needs the Activity window for the Android IME.
          onCreatePlatformView: (params) =>
              PlatformViewsService.initSurfaceAndroidView(
                id: params.id,
                viewType: params.viewType,
                layoutDirection: Directionality.of(context),
                creationParams: leaseOrTicket,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () => params.onFocusChanged(true),
              )..addOnPlatformViewCreatedListener((id) {
                params.onPlatformViewCreated(id);
                created?.call(id);
              }),
        ),
      );
  static Future<void> release(String lease) =>
      browserHost.invokeMethod('release', lease);
  static Future<void> clearCookies() =>
      browserHost.invokeMethod('clearCookies');
  Future<bool> attach(String url, bool active) async =>
      await _channel.invokeMethod<bool>('attach', {
        'url': url,
        'active': active,
      }) ??
      false;
  Future<void> visible(bool active) => _channel.invokeMethod('visible', active);
  Future<List<int>> find(String? text, bool forward) async =>
      await _channel.invokeListMethod<int>('find', {
        'text': text,
        'forward': forward,
      }) ??
      [0, 0];
  Future<void> clearFind() => _channel.invokeMethod('clearFind');
  @override
  BrowserProtection get protection => this;
  @override
  String get name => 'uBlock Origin';
  @override
  Future<SiteProtectionState> site(String url, {bool? enabled}) async {
    final reply = await call(url, '', 'siteProtection', {'enabled': ?enabled});
    if (reply['value']
        case {'enabled': bool on, 'blocked': int blocked, 'total': int total}
        when reply['error'] == null && blocked >= 0 && total >= 0) {
      return (enabled: on, blocked: blocked, total: total);
    }
    throw StateError('Site protection unavailable');
  }

  @override
  Future<void> perform(String url, SiteProtectionAction action) =>
      _channel.invokeMethod('blocker', {'url': url, 'action': action.name});

  static Future<void> releaseTools(int ticket) =>
      browserHost.invokeMethod('releasePanel', ticket);

  static Future<void> showTools(BuildContext context, int ticket) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final channel = MethodChannel('${browserHost.name}/panel/$ticket');
    final route = MaterialPageRoute<void>(
      builder: (context) => NodeLaneSurface(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('uBlock Origin'),
            leading: NodeLaneCloseButton(
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(top: false, child: view(ticket)),
        ),
      ),
    );
    channel.setMethodCallHandler((event) async {
      if (event.method == 'close' && route.isActive) {
        if (route.isCurrent) {
          navigator.pop();
        } else {
          navigator.removeRoute(route);
        }
      }
    });
    try {
      await navigator.push(route);
    } finally {
      channel.setMethodCallHandler(null);
      await releaseTools(ticket);
    }
  }

  @override
  Future<void> load(String url) => _channel.invokeMethod('load', url);
  @override
  Future<bool> traverse(int delta) async =>
      await _channel.invokeMethod<bool>('traverse', delta) == true;
  @override
  Future<void> reload() => _channel.invokeMethod('reload');
  @override
  Future<void> stop() => _channel.invokeMethod('stop');
  @override
  Future<Uint8List?> preview() => _channel.invokeMethod<Uint8List>('preview');
  @override
  WebImageArchive? get archive => null;
  @override
  void listen(ReaderMessage? receive) => _receive = receive;
  @override
  Future<void> install(
    String url,
    String token,
    bool Function() isCurrent,
  ) async {
    final reply = await call(url, token, 'install', const {});
    if (reply['error'] != null) throw StateError('Document unavailable');
  }

  @override
  Future<Map<String, dynamic>> call(
    String url,
    String token,
    String operation,
    Map<String, dynamic> args,
  ) async {
    final reply = await _channel.invokeMethod<String>(
      'reader',
      jsonEncode({
        'url': url,
        'token': token,
        'operation': operation,
        'args': args,
      }),
    );
    return jsonDecode(reply!) as Map<String, dynamic>;
  }

  void detach() {
    _channel.setMethodCallHandler(null);
    _badge.dispose();
  }
}
