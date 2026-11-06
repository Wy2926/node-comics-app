import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/about/mobile_app_update_view.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/app_update_downloads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Owns presentation only. Dismissing it never cancels a background download.
class DownloadFileScreen extends ConsumerStatefulWidget {
  const DownloadFileScreen({
    required this.updateAvailable,
    super.key,
    this.embedded = false,
    this.onDismiss,
  }) : assert(!embedded || onDismiss != null);

  final UpdateInfo updateAvailable;
  final bool embedded;
  final VoidCallback? onDismiss;

  @override
  ConsumerState<DownloadFileScreen> createState() => _DownloadFileScreenState();
}

class _DownloadFileScreenState extends ConsumerState<DownloadFileScreen>
    with WidgetsBindingObserver {
  AppUpdateDownloads? _downloads;
  UpdateDownload? _download;
  Timer? _poll;
  String _currentVersion = '';
  bool _busy = false, _querying = false, _error = false;
  bool _openedInBrowser = false, _permissionRequired = false, _closed = false;
  bool _visible = true, _foreground = true;
  int _epoch = 0;
  bool get _active => mounted && !_closed;

  @override
  void initState() {
    super.initState();
    _downloads = ref.read(appUpdateDownloadsProvider);
    WidgetsBinding.instance.addObserver(this);
    _foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    unawaited(_loadVersion());
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (_active) setState(() => _currentVersion = info.version);
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible = TickerMode.valuesOf(context).enabled;
    if (_visible && _foreground) {
      unawaited(_refresh());
    } else {
      _poll?.cancel();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (_foreground && _visible) {
      unawaited(_refresh());
    } else {
      _poll?.cancel();
    }
  }

  void _schedule() {
    _poll?.cancel();
    if (_active &&
        _visible &&
        _foreground &&
        !_error &&
        _download?.active == true) {
      _poll = Timer(const Duration(seconds: 1), _refresh);
    }
  }

  Future<void> _refresh() async {
    if (!_active || _downloads == null || _querying || _busy) return;
    _querying = true;
    final epoch = _epoch;
    try {
      final download = await _downloads!.current();
      if (_active && epoch == _epoch) {
        setState(() {
          _download = download;
          _error = false;
        });
      }
    } catch (_) {
      if (_active && epoch == _epoch) setState(() => _error = true);
    } finally {
      _querying = false;
      _schedule();
    }
  }

  @override
  void dispose() {
    _closed = true;
    _poll?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _dismiss() {
    if (!_active) return;
    _closed = true;
    _poll?.cancel();
    if (widget.embedded) {
      widget.onDismiss!();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _continue() async {
    if (!_active || _busy) return;
    final title = context.l10n.app_name;
    final download = _download;
    ++_epoch;
    setState(() {
      _busy = true;
      _error = false;
      _permissionRequired = false;
    });
    try {
      final downloads = _downloads;
      if (downloads == null) {
        final opened = await launchUrl(
          Uri.parse(widget.updateAvailable.$3),
          mode: LaunchMode.externalApplication,
        );
        if (!opened) throw StateError('Unable to open release');
        if (!_active) return;
        if (widget.embedded) {
          setState(() => _openedInBrowser = true);
        } else {
          _dismiss();
        }
      } else if (download?.phase == UpdateDownloadPhase.ready) {
        final result = await downloads.install(download!);
        if (_active) {
          setState(
            () => _permissionRequired =
                result == UpdateInstallResult.permissionRequired,
          );
        }
      } else {
        // Recover a late enqueue before starting another download.
        var current = await downloads.current();
        if (current == null || current.phase == UpdateDownloadPhase.failed) {
          current = await downloads.start(
            version: current?.version ?? widget.updateAvailable.$1,
            assets: current == null
                ? widget.updateAvailable.$4.whereType<String>().toList()
                : [current.url],
            title: title,
            notes: current?.notes ?? widget.updateAvailable.$2,
          );
        }
        if (_active) setState(() => _download = current);
      }
    } catch (_) {
      if (_active) setState(() => _error = true);
    } finally {
      if (_active) setState(() => _busy = false);
      _schedule();
    }
  }

  Future<void> _cancelDownload() async {
    final download = _download;
    if (!_active || _busy || download == null) return;
    ++_epoch;
    setState(() => _busy = true);
    try {
      await _downloads!.cancel(download);
      if (_active) {
        setState(() {
          _download = null;
          _error = false;
          _permissionRequired = false;
        });
      }
    } catch (_) {
      if (_active) setState(() => _error = true);
    } finally {
      if (_active) setState(() => _busy = false);
      _schedule();
    }
  }

  @override
  Widget build(BuildContext context) {
    final download = _download;
    final ready = download?.phase == UpdateDownloadPhase.ready;
    final active = download?.active == true;
    final version = download?.version ?? widget.updateAvailable.$1;
    return MobileAppUpdateView(
      embedded: widget.embedded,
      openedInBrowser: _openedInBrowser,
      currentVersion: _currentVersion,
      targetVersion: version,
      notes: (download?.notes ?? widget.updateAvailable.$2)
          .split('\n')
          .where(
            (line) =>
                !line.trim().startsWith('**Full Changelog**') &&
                !line.trim().startsWith('Full Changelog:'),
          )
          .join('\n')
          .trim(),
      downloadOnDevice: _downloads != null,
      busy: _busy || active,
      installing: _busy && ready,
      readyToInstall: ready,
      waiting:
          download?.phase == UpdateDownloadPhase.waiting ||
          download?.phase == UpdateDownloadPhase.queued,
      permissionRequired: _permissionRequired,
      received: download?.received ?? 0,
      total: download?.total ?? 0,
      hasError: _error || download?.phase == UpdateDownloadPhase.failed,
      onContinue: _continue,
      onCancel: _dismiss,
      onCancelDownload: download != null && !_busy ? _cancelDownload : null,
    );
  }
}
