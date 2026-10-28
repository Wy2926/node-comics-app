import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
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

  void _clearCookies() {
    MClient.deleteAllCookies(source.baseUrl ?? '');
    botToast(context.l10n.cookies_deleted);
  }

  void _confirmUninstall() {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        scrollable: true,
        title: Text(source.name ?? ''),
        content: Text(l10n.uninstall_extension(source.name ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              sourceRepository.uninstall(ref, source);
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: NodeLaneTokens.of(context).muted,
      ),
    ),
  );

  Widget _mobileView(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final developerMode = ref.watch(developerModeStateProvider);
    return MobileBrowsePage(
      title: l10n.extension_detail,
      leading: BackButton(onPressed: () => Navigator.pop(context, source)),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        children: [
          if (source.sourceCodeLanguage == SourceCodeLanguage.mihon)
            const ExtensionServerWarningBanner(),
          MobileBrowseGroup(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: colors.soft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: (source.iconUrl ?? '').isEmpty
                            ? Icon(
                                Icons.extension_outlined,
                                color: colors.muted,
                              )
                            : cachedNetworkImage(
                                imageUrl: source.iconUrl!,
                                width: 56,
                                height: 56,
                                fit: BoxFit.contain,
                                useCustomNetworkImage: false,
                                errorWidget: Center(
                                  child: Icon(
                                    Icons.extension_outlined,
                                    color: colors.muted,
                                  ),
                                ),
                                headers: const {},
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          source.name ?? '',
                          style: TextStyle(
                            color: colors.ink,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${l10n.version} ${source.version ?? ''} · ${completeLanguageName(source.lang ?? '')}',
                    style: TextStyle(fontSize: 14, color: colors.muted),
                  ),
                  if (source.isNsfw ?? false) ...[
                    const SizedBox(height: 8),
                    Text(
                      'NSFW (18+)',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (source.repo?.website != null) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: () =>
                            _launchInBrowser(Uri.parse(source.repo!.website!)),
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: Text(l10n.open_in_browser),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (sourcePreference?.isNotEmpty ?? false) ...[
            _sectionLabel(l10n.settings),
            MobileBrowseGroup(
              child: SourcePreferenceWidget(
                sourcePreference: sourcePreference!,
                source: source,
              ),
            ),
          ],
          _sectionLabel(l10n.advanced),
          MobileBrowseGroup(
            child: Column(
              children: [
                if (developerMode)
                  ListTile(
                    leading: const Icon(Icons.code_rounded),
                    title: Text(l10n.edit_code),
                    onTap: _editCode,
                  ),
                if (developerMode && (source.isLocal ?? false))
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text('Edit metadata'),
                    onTap: _editMetadata,
                  ),
                ListTile(
                  leading: const Icon(Icons.cookie_outlined),
                  title: Text(l10n.delete_all_cookies),
                  onTap: _clearCookies,
                ),
                Divider(height: 1, color: colors.line),
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded),
                  iconColor: Theme.of(context).colorScheme.error,
                  textColor: Theme.of(context).colorScheme.error,
                  title: Text(l10n.uninstall),
                  onTap: _confirmUninstall,
                ),
              ],
            ),
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
