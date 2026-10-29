import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/widgets/mobile_error_list.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// The caller retains report order, seen/reported state, copy and issue routing.
class MobileErrorReportsScreen extends StatelessWidget {
  const MobileErrorReportsScreen({
    super.key,
    required this.reports,
    required this.wasReported,
    required this.onReport,
    required this.onCopy,
    required this.onClear,
  });

  final List<CrashReport> reports;
  final bool Function(CrashReport report) wasReported;
  final ValueChanged<CrashReport> onReport, onCopy;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => MobileErrorList(
    title: context.l10n.error_reports,
    emptyMessage: context.l10n.error_reports_empty,
    clearLabel: context.l10n.error_reports_clear,
    itemCount: reports.length,
    onClear: onClear,
    findChildIndexCallback: (key) {
      final index = reports.indexOf((key as ObjectKey).value as CrashReport);
      return index < 0 ? null : index;
    },
    itemBuilder: (context, index) {
      final report = reports[index];
      final scope = crashReportScope(report);
      final cause = report.likelyCause;
      final reported = wasReported(report);
      final colors = NodeLaneTokens.of(context);
      final l10n = context.l10n;
      return MobileSettingsGroup(
        key: ObjectKey(report),
        children: [
          ExpansionTile(
            key: PageStorageKey(report),
            shape: const Border(),
            collapsedShape: const Border(),
            tilePadding: const EdgeInsets.all(16),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            title: Text(
              report.summary,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.ink,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text('${report.time.toLocal()}'.split('.').first),
                  if (report.screen != null) Text(report.screen!),
                  if (report.occurrences > 1) Text('×${report.occurrences}'),
                ],
              ),
            ),
            children: [
              if (scope != CrashReportScope.app) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.soft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    scope == CrashReportScope.extension
                        ? l10n.error_reports_extension_failure
                        : l10n.error_reports_expected_failure,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (cause != null) ...[
                Text(
                  l10n.error_reports_likely_cause,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(cause),
                const SizedBox(height: 16),
              ],
              SelectableText(
                report.error,
                key: const PageStorageKey('report-error'),
              ),
              if (report.stack != null) ...[
                const SizedBox(height: 16),
                // Wrapped, selectable details stay within the phone viewport.
                SelectableText(
                  report.stack!,
                  key: const PageStorageKey('report-stack'),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: colors.muted,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (scope == CrashReportScope.app)
                    FilledButton.icon(
                      onPressed: reported ? null : () => onReport(report),
                      icon: const Icon(Icons.bug_report_outlined),
                      label: Text(
                        reported
                            ? l10n.error_reports_already_reported
                            : l10n.error_reports_report,
                      ),
                    ),
                  TextButton.icon(
                    onPressed: () => onCopy(report),
                    icon: const Icon(Icons.copy_rounded),
                    label: Text(l10n.error_reports_copy),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    },
  );
}
