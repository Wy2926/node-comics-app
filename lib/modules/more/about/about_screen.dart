import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/about/mobile_about_screen.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/about/providers/get_package_info.dart';
import 'package:mangayomi/modules/more/about/providers/logs_state.dart';
import 'package:mangayomi/modules/widgets/nodelane_brand_mark.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final checkForUpdates = ref.watch(checkForAppUpdatesProvider);
    final enableLogs = ref.watch(logsStateProvider);
    if (isMobile && !isTv) {
      return MobileAboutScreen(
        packageInfo: ref.watch(getPackageInfoProvider),
        onRetryPackageInfo: () => ref.invalidate(getPackageInfoProvider),
        checkForUpdates: checkForUpdates,
        onAutoCheckChanged: ref.read(checkForAppUpdatesProvider.notifier).set,
        logsEnabled: enableLogs,
        onLogsChanged: (value) async {
          ref.read(logsStateProvider.notifier).set(value);
          if (value) {
            await AppLogger.init();
          } else {
            await AppLogger.dispose();
          }
        },
        reportCount: () => CrashReports.reports.length,
        onReports: () async {
          await context.push('/errorReports');
        },
        onUpdates: () => context.push('/appUpdate'),
        onShareLogs: () => _shareLogs(context),
        onGitHub: () =>
            _launchInBrowser(Uri.parse(NodeLaneBrand.repositoryUrl)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.about)),
      body: ref
          .watch(getPackageInfoProvider)
          .when(
            data: (data) => SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: const NodeLaneBrandMark(),
                  ),
                  Column(
                    children: [
                      const Divider(),
                      ListTile(
                        title: Text(l10n.version),
                        subtitle: Text(
                          l10n.beta_version(data.version),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      SwitchListTile(
                        title: Text(l10n.check_for_app_updates),
                        value: checkForUpdates,
                        onChanged: (value) {
                          ref
                              .read(checkForAppUpdatesProvider.notifier)
                              .set(value);
                        },
                      ),
                      ListTile(
                        onTap: () => context.push('/appUpdate'),
                        title: Text(l10n.check_for_update),
                      ),
                      ListTile(
                        onTap: () => context.push('/errorReports'),
                        title: Text(l10n.error_reports),
                        subtitle: Text(l10n.error_reports_subtitle),
                        trailing: CrashReports.reports.isEmpty
                            ? null
                            : Text('${CrashReports.reports.length}'),
                      ),
                      SwitchListTile(
                        title: Text(l10n.logs_on),
                        value: enableLogs,
                        onChanged: (value) async {
                          ref.read(logsStateProvider.notifier).set(value);
                          if (value) {
                            await AppLogger.init();
                          } else {
                            await AppLogger.dispose();
                          }
                        },
                      ),
                      if (enableLogs)
                        ListTile(
                          onTap: () => _shareLogs(context),
                          title: Text(l10n.share_app_logs),
                        ),
                      ListTile(
                        leading: const FaIcon(FontAwesomeIcons.github),
                        title: const Text('GitHub'),
                        subtitle: const Text(NodeLaneBrand.repository),
                        onTap: () => _launchInBrowser(
                          Uri.parse(NodeLaneBrand.repositoryUrl),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            error: (error, stackTrace) => ErrorWidget(error),
            loading: () => const NodeLaneEmptyState.loading(),
          ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

Future<void> _shareLogs(BuildContext context) async {
  final storage = StorageProvider();
  final directory = await storage.getDefaultDirectory();
  final file = File(path.join(directory!.path, 'logs.txt'));
  if (!await file.exists()) {
    if (context.mounted) showNodeLaneNotice(context.l10n.no_app_logs);
    return;
  }
  if (!context.mounted) return;
  final box = context.findRenderObject() as RenderBox?;
  await shareOrCopy(
    ShareParams(
      files: [XFile(file.path)],
      text: 'log.txt',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    ),
  );
}
