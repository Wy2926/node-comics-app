import 'package:mangayomi/modules/widgets/nodelane_notice.dart';

import 'dart:convert';

import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';
import 'package:mangayomi/modules/browse/extension/widgets/source_preference_widget.dart';
import 'package:mangayomi/modules/widgets/extension_server_warning_banner.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_source_preference.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class ExtensionDetail extends ConsumerStatefulWidget {
  final Source source;
  const ExtensionDetail({super.key, required this.source});

  @override
  ConsumerState<ExtensionDetail> createState() => _ExtensionDetailState();
}

class _ExtensionDetailState extends ConsumerState<ExtensionDetail> {
  late Source source = sourceRepository.getById(widget.source.id!)!;
  late List<SourcePreference>? sourcePreference = () {
    try {
      if (source.sourceCodeLanguage == SourceCodeLanguage.mihon &&
          source.preferenceList != null) {
        return (jsonDecode(source.preferenceList!) as List)
            .map((e) => SourcePreference.fromJson(e))
            .toList();
      }
      return getSourcePreference(source: source)
          .map((e) => getSourcePreferenceEntry(e.key!, source.id!))
          .toList();
    } catch (e) {
      return null;
    }
  }();
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _editCode() async {
    final res = await context.push('/codeEditor', extra: source.id);
    if (res != null && mounted) {
      setState(() {
        source = res as Source;
        sourcePreference = getSourcePreference(source: source)
            .map((e) => getSourcePreferenceEntry(e.key!, source.id!))
            .toList();
      });
    }
  }

  Future<void> _editMetadata() async {
    final res = await context.push('/createExtension', extra: source);
    if (res != null && mounted) setState(() => source = res as Source);
  }

  bool _busy = false;

  Future<void> _clearCookies() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await MClient.deleteAllCookies(source.baseUrl ?? '');
      if (mounted) {
        showNodeLaneNotice(
          context.l10n.cookies_deleted,
          kind: NodeLaneNoticeKind.success,
        );
      }
    } catch (_) {
      if (mounted) {
        showNodeLaneNotice('清理未完成，请重试。', kind: NodeLaneNoticeKind.error);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmUninstall() async {
    if (_busy) return;
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        scrollable: true,
        title: Text(source.name ?? ''),
        content: Text(l10n.uninstall_extension(source.name ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true || _busy) return;
    setState(() => _busy = true);
    try {
      await sourceRepository.uninstall(ref, source);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        showNodeLaneNotice('卸载未完成，请重试。', kind: NodeLaneNoticeKind.error);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _mobileView(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final developerMode = ref.watch(developerModeStateProvider);
    return MobileBrowsePage(
      title: '来源详情',
      leading: NodeLaneIconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () => Navigator.pop(context, source),
        icon: icons.back,
      ),
      body: ListView(
        padding: NodeLaneTokens.pagePadding,
        children: [
          if (source.sourceCodeLanguage == SourceCodeLanguage.mihon)
            const ExtensionServerWarningBanner(),
          NodeLaneGroupSurface(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox.square(
                      dimension: NodeLaneTokens.websiteIconSize,
                      child: NodeLaneWebsiteIcon(url: source.iconUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            source.name ?? '',
                            style: t.readerLabel.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '第三方 · ${source.repo?.name ?? (source.isLocal == true ? '本地扩展' : '来源适配器')}',
                            style: t.readerSecondary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '版本 ${source.version ?? ''} · ${completeLanguageName(source.lang ?? '')}',
                            style: t.readerSecondary,
                          ),
                          if (source.isNsfw == true)
                            Text(
                              'NSFW (18+)',
                              style: t.readerSecondary.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (source.repo?.website?.isNotEmpty == true)
                NodeLaneRow(
                  title: '仓库网站',
                  icon: icons.external,
                  onTap: () =>
                      _launchInBrowser(Uri.parse(source.repo!.website!)),
                ),
            ],
          ),
          if (sourcePreference?.isNotEmpty == true) ...[
            const NodeLaneCatalogHeading('来源提供的设置'),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('选项由当前来源提供', style: t.readerSecondary),
            ),
            SourcePreferenceWidget(
              sourcePreference: sourcePreference!,
              source: source,
            ),
          ],
          const NodeLaneCatalogHeading('高级操作'),
          NodeLaneGroupSurface(
            children: [
              if (developerMode)
                NodeLaneRow(
                  title: context.l10n.edit_code,
                  icon: icons.code,
                  onTap: _editCode,
                ),
              if (developerMode && source.isLocal == true)
                NodeLaneRow(
                  title: '编辑来源信息',
                  icon: icons.edit,
                  onTap: _editMetadata,
                ),
              NodeLaneRow(
                title: '清除此网站 Cookie',
                subtitle: '下次访问可能需要重新登录',
                icon: icons.cookies,
                onTap: _busy ? null : _clearCookies,
              ),
              NodeLaneRow(
                title: '卸载来源',
                icon: icons.delete,
                destructive: true,
                onTap: _busy ? null : _confirmUninstall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (isMobile && !isTv) return _mobileView(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.extension_detail),
        leading: BackButton(onPressed: () => Navigator.pop(context, source)),
        actions: [
          if (source.repo?.website != null)
            IconButton(
              onPressed: () {
                _launchInBrowser(Uri.parse(source.repo!.website!));
              },
              icon: Icon(Icons.open_in_new_outlined),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (source.sourceCodeLanguage == SourceCodeLanguage.mihon)
              const ExtensionServerWarningBanner(),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: widget.source.iconUrl!.isEmpty
                    ? const Icon(Icons.source_outlined, size: 140)
                    : cachedNetworkImage(
                        imageUrl: widget.source.iconUrl!,
                        fit: BoxFit.contain,
                        width: 140,
                        height: 140,
                        errorWidget: const SizedBox(
                          width: 140,
                          height: 140,
                          child: Center(
                            child: Icon(Icons.source_outlined, size: 140),
                          ),
                        ),
                        headers: {},
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.source.name!,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (widget.source.isNsfw!)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "NSFW (18+)",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.source.version!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.version,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            completeLanguageName(widget.source.lang!),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.language,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (ref.watch(developerModeStateProvider))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: context.width(1),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: _editCode,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            l10n.edit_code,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.code),
                      ],
                    ),
                  ),
                ),
              ),
            if ((source.isLocal ?? false) &&
                ref.watch(developerModeStateProvider))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: context.width(1),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: _editMetadata,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Edit metadata",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.edit_outlined),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: context.width(1),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: _clearCookies,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      context.l10n.delete_all_cookies,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: context.width(1),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    side: BorderSide(color: context.primaryColor, width: 0.3),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: _confirmUninstall,
                  child: Text(
                    l10n.uninstall,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            if (sourcePreference != null)
              SourcePreferenceWidget(
                sourcePreference: sourcePreference!,
                source: source,
              ),
          ],
        ),
      ),
    );
  }
}
