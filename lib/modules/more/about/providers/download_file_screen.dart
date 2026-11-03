import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/more/about/mobile_app_update_view.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadFileScreen extends ConsumerStatefulWidget {
  final (String, String, String, List<dynamic>) updateAvailable;
  const DownloadFileScreen({
    required this.updateAvailable,
    super.key,
    this.embedded = false,
    this.onDismiss,
  }) : assert(!embedded || onDismiss != null);
  final bool embedded;
  final VoidCallback? onDismiss;

  @override
  ConsumerState<DownloadFileScreen> createState() => _DownloadFileScreenState();
}

class _DownloadFileScreenState extends ConsumerState<DownloadFileScreen> {
  int _total = 0;
  int _received = 0;
  bool _isDownloading = false;
  bool _isInstalling = false;
  String? _errorMessage;
  String _currentVersion = '';
  bool _openedInBrowser = false;

  bool _closed = false;
  bool get _active => mounted && !_closed;
  http.Client? _client;
  http.Client get _httpClient => _client ??= http.Client();
  List<int> _bytes = [];
  StreamSubscription<List<int>>? _subscription;
  final ScrollController _changelogScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCurrentVersion();
  }

  Future<void> _loadCurrentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (_active) {
        setState(() {
          _currentVersion = info.version;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _stop();
    _changelogScrollController.dispose();
    super.dispose();
  }

  void _stop() {
    if (_closed) return;
    _closed = true;
    _client?.close();
    unawaited(_subscription?.cancel().catchError((Object _) {}));
    _bytes.clear();
  }

  void _cancel() {
    if (!_active) return;
    _stop();
    if (widget.embedded) {
      widget.onDismiss!();
    } else if (mounted) {
      Navigator.pop(context);
    }
  }

  void _finish({bool browser = false}) {
    if (!_active) return;
    if (!widget.embedded || !browser) {
      _cancel();
      return;
    }
    setState(() {
      _isDownloading = false;
      _isInstalling = false;
      _openedInBrowser = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _stop();
      },
      child: widget.embedded || (isMobile && !isTv)
          ? MobileAppUpdateView(
              embedded: widget.embedded,
              openedInBrowser: _openedInBrowser,
              currentVersion: _currentVersion,
              targetVersion: widget.updateAvailable.$1,
              notes: _cleanChangelog(widget.updateAvailable.$2),
              downloadOnDevice: Platform.isAndroid,
              busy: _isDownloading,
              installing: _isInstalling,
              received: _received,
              total: _total,
              hasError: _errorMessage != null,
              onContinue: () => _handleDownloadOrOpen(widget.updateAvailable),
              onCancel: _cancel,
            )
          : _buildLegacyDialog(context),
    );
  }

  Widget _buildLegacyDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = l10nLocalizations(context)!;
    final updateAvailable = widget.updateAvailable;
    final targetVersion = updateAvailable.$1;
    final changelog = updateAvailable.$2;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 6,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header (Icon + Title + Version Badges)
              _buildHeader(context, colorScheme, theme, l10n, targetVersion),
              const SizedBox(height: 18),

              // 2. Changelog / Release Notes Box
              _buildChangelogBox(context, colorScheme, theme, changelog),
              const SizedBox(height: 18),

              // 3. Progress or Error Section
              if (_isDownloading) ...[
                _buildProgressCard(context, colorScheme, theme),
                const SizedBox(height: 18),
              ] else if (_errorMessage != null) ...[
                _buildErrorBanner(context, colorScheme, theme),
                const SizedBox(height: 18),
              ],

              // 4. Action Buttons
              _buildActions(context, colorScheme, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
    dynamic l10n,
    String targetVersion,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.system_update_rounded,
            color: colorScheme.primary,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.new_update_available,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (_currentVersion.isNotEmpty) ...[
                    Text(
                      'v$_currentVersion',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'v$targetVersion',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChangelogBox(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
    String changelog,
  ) {
    final cleanNotes = _cleanChangelog(changelog);
    return Flexible(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 220),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Scrollbar(
          controller: _changelogScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _changelogScrollController,
            child: SelectableText(
              cleanNotes.isEmpty
                  ? 'Aucune note de version fournie.'
                  : cleanNotes,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.45,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final progress = _total > 0 ? (_received / _total).clamp(0.0, 1.0) : 0.0;
    final percentText = _total > 0
        ? '${(progress * 100).toStringAsFixed(0)}%'
        : '';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (_total > 0 ? percentText : ''),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              if (_total > 0 && !_isInstalling)
                Text(
                  '${(_received / 1048576.0).toStringAsFixed(1)} / ${(_total / 1048576.0).toStringAsFixed(1)} MB',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _isInstalling ? null : (_total > 0 ? progress : null),
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: colorScheme.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    ColorScheme colorScheme,
    dynamic l10n,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: _cancel, child: Text(l10n.cancel)),
        const SizedBox(width: 10),
        if (!_isDownloading)
          FilledButton.icon(
            icon: Icon(
              Platform.isAndroid
                  ? Icons.download_rounded
                  : Icons.open_in_browser_rounded,
              size: 18,
            ),
            label: Text(Platform.isAndroid ? l10n.download : (l10n.download)),
            onPressed: () => _handleDownloadOrOpen(widget.updateAvailable),
          ),
      ],
    );
  }

  String _cleanChangelog(String raw) {
    final lines = raw.split('\n');
    final formatted = <String>[];
    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('**Full Changelog**') ||
          trimmed.startsWith('Full Changelog:')) {
        continue;
      }
      formatted.add(line);
    }
    return formatted.join('\n').trim();
  }

  Future<void> _handleDownloadOrOpen(
    (String, String, String, List<dynamic>) updateAvailable,
  ) async {
    if (!_active || _isDownloading) return;
    setState(() {
      _isDownloading = true;
      _isInstalling = false;
      _errorMessage = null;
      _received = 0;
      _total = 0;
      _openedInBrowser = false;
    });
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        if (!_active) return;
        String apkUrl = '';
        final apks = updateAvailable.$4
            .whereType<String>()
            .where((apk) => apk.toLowerCase().endsWith('.apk'))
            .toList();

        final filteredApks = isTv
            ? apks
                  .where((apk) => apk.toLowerCase().contains('android-tv'))
                  .toList()
            : apks
                  .where((apk) => !apk.toLowerCase().contains('android-tv'))
                  .toList();

        final candidateApks = filteredApks.isNotEmpty ? filteredApks : apks;

        for (String abi in androidInfo.supportedAbis) {
          for (final apk in candidateApks) {
            if (apk.toLowerCase().contains(abi.toLowerCase())) {
              apkUrl = apk;
              break;
            }
          }
          if (apkUrl.isNotEmpty) break;
        }
        if (apkUrl.isEmpty && candidateApks.isNotEmpty) {
          apkUrl = candidateApks.first;
        }

        if (apkUrl.isNotEmpty) {
          await _downloadApk(apkUrl);
        } else {
          await _launchInBrowser(Uri.parse(updateAvailable.$3));
          _finish(browser: true);
        }
      } else {
        await _launchInBrowser(Uri.parse(updateAvailable.$3));
        _finish(browser: true);
      }
    } catch (_) {
      _fail('Échec du téléchargement.');
    }
  }

  void _fail(String message) {
    if (!_active) return;
    _bytes.clear();
    setState(() {
      _isDownloading = false;
      _isInstalling = false;
      _errorMessage = message;
    });
  }

  Future<void> _downloadApk(String url) async {
    var status = await Permission.storage.status;
    if (!_active) return;
    if (!status.isGranted) {
      await Permission.storage.request();
      if (!_active) return;
    }
    Directory? dir = Directory('/storage/emulated/0/Download');
    final hasDownloads = await dir.exists();
    if (!_active) return;
    if (!hasDownloads) dir = await getExternalStorageDirectory();
    if (!_active) return;
    final file = File(
      '${dir!.path}/${url.split("/").lastOrNull ?? "NodeLane-Comics.apk"}',
    );

    // If a file already exists, verify its integrity by comparing its size
    // against the server's Content-Length. A corrupt or incomplete download
    // would have a smaller size — delete it and re-download in that case.
    final fileExists = await file.exists();
    if (!_active) return;
    if (fileExists) {
      bool fileIsValid = false;
      try {
        final headResponse = await _httpClient.head(Uri.parse(url));
        if (!_active) return;
        final contentLength = int.tryParse(
          headResponse.headers['content-length'] ?? '',
        );
        final localSize = await file.length();
        if (!_active) return;
        if (contentLength != null && localSize == contentLength) {
          fileIsValid = true;
        }
      } catch (_) {
        // Network unavailable: fall back to assuming the file is valid so the
        // user can at least attempt installation while offline.
        fileIsValid = true;
      }

      if (!_active) return;
      if (fileIsValid) {
        setState(() {
          _isInstalling = true;
        });
        await _installApk(file);
        _cancel();
        return;
      } else {
        // File is corrupted or incomplete — delete and re-download.
        try {
          await file.delete();
        } catch (_) {}
      }
    }

    if (!_active) return;
    _bytes.clear();
    _received = 0;

    final response = await _httpClient.send(
      http.Request('GET', Uri.parse(url)),
    );
    if (!_active) return;
    setState(() => _total = response.contentLength ?? 0);
    _subscription = response.stream.listen(
      (value) {
        if (!_active) return;
        setState(() {
          _bytes.addAll(value);
          _received += value.length;
        });
      },
      onError: (Object _) => _fail('Erreur réseau lors du téléchargement.'),
      cancelOnError: true,
      onDone: () async {
        if (!_active || !_isDownloading) return;
        // Transfer ownership without copying the APK. Closing the dialog must
        // not mutate bytes that an already-started file write is still using.
        final bytes = _bytes;
        _bytes = [];
        try {
          setState(() => _isInstalling = true);
          await file.writeAsBytes(bytes);
          if (!_active) return;
          await _installApk(file);
          _cancel();
        } catch (_) {
          _fail("Erreur lors de l'écriture du fichier APK.");
        }
      },
    );
  }

  Future<void> _installApk(File file) async {
    if (!_active) return;
    var status = await Permission.requestInstallPackages.status;
    if (!_active) return;
    if (!status.isGranted) {
      await Permission.requestInstallPackages.request();
      if (!_active) return;
    }
    await ApkInstaller.installApk(file.path);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!_active) return;
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}

class ApkInstaller {
  static const _platform = MethodChannel('com.kodjodevf.mangayomi.apk_install');
  static Future<void> installApk(String filePath) async {
    try {
      await _platform.invokeMethod('installApk', {'filePath': filePath});
    } catch (e) {
      if (kDebugMode) {
        log("Erreur d'installation : $e");
      }
    }
  }
}
