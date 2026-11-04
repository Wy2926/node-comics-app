import 'package:mangayomi/modules/widgets/nodelane_notice.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/about/providers/download_file_screen.dart';
import 'package:mangayomi/modules/more/about/providers/get_package_info.dart';
import 'package:mangayomi/modules/more/about/providers/logs_state.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';
import 'package:mangayomi/modules/widgets/nodelane_brand_mark.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mobile_about_screen.dart';

import 'package:mangayomi/modules/onboarding/providers/onboarding_state_provider.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final checkForUpdates = ref.watch(checkForAppUpdatesProvider);
    final enableLogs = ref.watch(logsStateProvider);
    if (isMobile && !isTv) {
      return MobileAboutScreen(
        onOnboarding: () =>
            ref.read(onboardingCompletedStateProvider.notifier).showAgain(),
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
        onCheck: performManualUpdateCheck,
        updateBuilder: (update, onDismiss) => DownloadFileScreen(
          key: ValueKey(update.$1),
          updateAvailable: update,
          embedded: true,
          onDismiss: onDismiss,
        ),
        onShareLogs: () => _shareLogs(context),
        onGitHub: () =>
            _launchInBrowser(Uri.parse(NodeLaneBrand.repositoryUrl)),
        onDiscord: () => _launchInBrowser(
          Uri.parse('https://discord.com/invite/EjfBuYahsP'),
        ),
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
                        onTap: () {},
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
                        onTap: () async {
                          showNodeLaneNotice(l10n.searching_for_updates);
                          try {
                            final updateInfo = await performManualUpdateCheck();
                            if (updateInfo != null) {
                              showNodeLaneNotice(l10n.new_update_available);
                              await Future.delayed(const Duration(seconds: 1));
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (_) => DownloadFileScreen(
                                    updateAvailable: updateInfo,
                                  ),
                                );
                              }
                            } else {
                              showNodeLaneNotice(l10n.no_new_updates_available);
                            }
                          } catch (_) {
                            showNodeLaneNotice(l10n.no_new_updates_available);
                          }
                        },
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
                      // ListTile(
                      //   onTap: () {},
                      //   title: const Text("What's news"),
                      // ),
                      // ListTile(
                      //   onTap: () {},
                      //   title: const Text('Help translation'),
                      // ),
                      // ListTile(
                      //   onTap: () {},
                      //   title: const Text('Privacy policy'),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              _launchInBrowser(
                                Uri.parse(NodeLaneBrand.repositoryUrl),
                              );
                            },
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 2.5, right: 2.5),
                              child: FaIcon(FontAwesomeIcons.github),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _launchInBrowser(
                                Uri.parse(
                                  'https://discord.com/invite/EjfBuYahsP',
                                ),
                              );
                            },
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: FaIcon(FontAwesomeIcons.discord),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            error: (error, stackTrace) => ErrorWidget(error),
            loading: () => const ProgressCenter(),
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
