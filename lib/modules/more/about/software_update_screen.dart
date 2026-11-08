import 'package:mangayomi/services/app_update_manifest.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/about/software_update_view.dart';
import 'package:mangayomi/modules/more/about/software_update_widgets.dart';
import 'package:mangayomi/modules/more/about/providers/get_package_info.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_progress.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/app_update_downloads.dart';
import 'package:url_launcher/url_launcher.dart';

/// Owns update checks and actions; leaving never cancels a system download.
class SoftwareUpdateScreen extends ConsumerStatefulWidget {
  const SoftwareUpdateScreen({super.key, this.update});
  final UpdateInfo? update;

  @override
  ConsumerState<SoftwareUpdateScreen> createState() =>
      _SoftwareUpdateScreenState();
}

class _SoftwareUpdateScreenState extends ConsumerState<SoftwareUpdateScreen>
    with WidgetsBindingObserver {
  AppUpdateDownloads? _downloads;
  UpdateDownload? _download;
  Timer? _poll;
  UpdateInfo? _update;
  bool _checking = false, _checkFailed = false;
  bool _busy = false, _querying = false, _error = false;
  bool _openedInBrowser = false, _permissionRequired = false;
  bool _visible = true, _foreground = true;
  int _epoch = 0;

  @override
  void initState() {
    super.initState();
    _downloads = ref.read(appUpdateDownloadsProvider);
    WidgetsBinding.instance.addObserver(this);
    _foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    unawaited(_check());
  }

  UpdateInfo _releaseFor(UpdateDownload task) => UpdateInfo(
    version: task.version,
    build: task.build,
    notes: task.notes,
    url: task.url,
  );

  Future<void> _check() async {
    if (_checking || _busy) return;
    final epoch = ++_epoch;
    setState(() {
      _checking = true;
      _checkFailed = false;
    });
    try {
      UpdateDownload? local;
      try {
        local = await _downloads?.current();
      } catch (_) {
        // An unavailable native service must not prevent release discovery.
      }
      if (!mounted || epoch != _epoch) return;
      final release = local != null
          ? _releaseFor(local)
          : widget.update ?? await ref.read(manualAppUpdateCheckProvider)();
      if (mounted && epoch == _epoch) {
        setState(() {
          _update = release;
          _download = local;
          _error = false;
        });
      }
    } catch (_) {
      if (mounted && epoch == _epoch) setState(() => _checkFailed = true);
    } finally {
      if (mounted && epoch == _epoch) setState(() => _checking = false);
      _schedule();
    }
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
    if (mounted &&
        _visible &&
        _foreground &&
        !_error &&
        !_checking &&
        _download?.active == true) {
      _poll = Timer(const Duration(seconds: 1), _refresh);
    }
  }

  Future<void> _refresh() async {
    if (!mounted || _downloads == null || _querying || _busy || _checking) {
      return;
    }
    _querying = true;
    final epoch = _epoch;
    try {
      final download = await _downloads!.current();
      if (mounted && epoch == _epoch) {
        setState(() {
          _download = download;
          if (download != null) _update ??= _releaseFor(download);
          _error = false;
        });
      }
    } catch (_) {
      if (mounted && epoch == _epoch) setState(() => _error = true);
    } finally {
      _querying = false;
      _schedule();
    }
  }

  @override
  void dispose() {
    _poll?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _continue() async {
    if (!mounted || _busy || _checking || _update == null) return;
    final l10n = context.l10n;
    final title = l10n.app_name;
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
          Uri.parse(_update!.externalUrl),
          mode: LaunchMode.externalApplication,
        );
        if (!opened) throw StateError(l10n.release_open_failed);
        if (!mounted) return;
        setState(() => _openedInBrowser = true);
      } else if (download?.phase == UpdateDownloadPhase.ready) {
        final result = await downloads.install(download!);
        if (mounted) {
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
            version: current?.version ?? _update!.version,
            build: current?.build ?? _update!.build,
            url: current?.url ?? _update!.url,
            title: title,
            notes: current?.notes ?? _update!.notes,
          );
        }
        if (mounted) setState(() => _download = current);
      }
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _busy = false);
      _schedule();
    }
  }

  Future<void> _cancelDownload() async {
    final download = _download;
    if (!mounted || _busy || download == null) return;
    ++_epoch;
    setState(() => _busy = true);
    try {
      await _downloads!.cancel(download);
      if (mounted) {
        setState(() {
          _download = null;
          _error = false;
          _permissionRequired = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _busy = false);
      _schedule();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final currentVersion =
        ref.watch(getPackageInfoProvider).asData?.value.version ?? '';
    final download = _download;
    final ready = download?.phase == UpdateDownloadPhase.ready;
    final release = _update;
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: l.app_updates),
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: release != null && !_checking
                  ? SoftwareUpdateView(
                      currentVersion: currentVersion,
                      targetVersion: download?.version ?? release.version,
                      notes: download?.notes ?? release.notes,
                      downloadOnDevice: _downloads != null,
                      busy: _busy || download?.active == true,
                      installing: _busy && ready,
                      readyToInstall: ready,
                      waiting:
                          download?.phase == UpdateDownloadPhase.waiting ||
                          download?.phase == UpdateDownloadPhase.queued,
                      permissionRequired: _permissionRequired,
                      openedInBrowser: _openedInBrowser,
                      received: download?.received ?? 0,
                      total: download?.total ?? 0,
                      hasError:
                          _error ||
                          download?.phase == UpdateDownloadPhase.failed,
                      onContinue: _continue,
                      onCancelDownload: download != null && !_busy
                          ? _cancelDownload
                          : null,
                    )
                  : AppUpdatePageLayout(
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppUpdateHeader(
                            version: currentVersion.isEmpty
                                ? '—'
                                : currentVersion,
                            currentVersion: currentVersion,
                            available: false,
                          ),
                          const SizedBox(height: NodeLaneTokens.space24),
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              _checking
                                  ? l.searching_for_updates
                                  : _checkFailed
                                  ? l.app_update_failed
                                  : l.update_check_no_result,
                              textAlign: TextAlign.center,
                              style: t.readerSecondary.copyWith(
                                color: _checkFailed
                                    ? Theme.of(context).colorScheme.error
                                    : t.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      footer: _checking
                          ? NodeLaneProgress(
                              semanticsLabel: l.searching_for_updates,
                            )
                          : FilledButton(
                              onPressed: _check,
                              child: Text(
                                _checkFailed ? l.retry : l.check_for_update,
                              ),
                            ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
