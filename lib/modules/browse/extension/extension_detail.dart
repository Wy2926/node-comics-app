import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
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
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';

import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'widgets/create_extension.dart';

Future<Source?> showSourceSettings(BuildContext menu, Source source) async {
  final id = source.id!;
  final before = sourceRepository.getById(id);
  if (before != null && before.isAdded == true) {
    final updated = await ExtensionDetail.show(menu, before);
    if (!menu.mounted) return null;
    final current = sourceRepository.getById(id);
    if (current != null && current.isAdded == true) {
      // Replacing an unchanged Source would re-fetch its paginated results.
      return current.updatedAt != before.updatedAt ? updated ?? current : null;
    }
  }
  // Uninstall can delete a local source entirely. Don't return to its stale actions.
  if (menu.mounted && ModalRoute.isCurrentOf(menu) == true) Navigator.pop(menu);
  return null;
}

class ExtensionDetail extends ConsumerStatefulWidget {
  final Source source;
  const ExtensionDetail({super.key, required this.source});

  static Future<Source?> show(BuildContext anchor, Source source) =>
      NodeLaneBubbleFlow.open<Source>(
        anchor,
        title: anchor.l10n.settings_source_preferences,
        child: ExtensionDetail(source: source),
      );

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
    // Editing and running source code needs the editor, service controls and console together.
    final res = await context.push<Source>('/codeEditor', extra: source.id);
    if (res != null && mounted) {
      setState(() {
        source = res;
        sourcePreference = getSourcePreference(source: source)
            .map((e) => getSourcePreferenceEntry(e.key!, source.id!))
            .toList();
      });
    }
  }

  Future<void> _editMetadata(BuildContext anchor) async {
    final res = await NodeLaneBubbleFlow.open<Source>(
      anchor,
      title: context.l10n.source_edit_metadata,
      child: CreateExtension(editSource: source),
    );
    if (res != null && mounted) setState(() => source = res);
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
        showNodeLaneNotice(
          context.l10n.source_clear_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmUninstall(BuildContext anchor) async {
    if (_busy) return;
    final l10n = context.l10n;
    final confirmed = await showNodeLaneConfirmation(
      anchor,
      title: source.name ?? '',
      message: l10n.uninstall_extension(source.name ?? ''),
      confirmLabel: l10n.uninstall,
      destructive: true,
    );
    if (!mounted || confirmed != true || _busy) return;
    setState(() => _busy = true);
    try {
      await sourceRepository.uninstall(ref, source);
      if (mounted && ModalRoute.isCurrentOf(context) == true) {
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        showNodeLaneNotice(
          context.l10n.source_uninstall_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _mobileView(BuildContext context) {
    final icons = NodeLaneIcons.of(context);
    final developerMode = ref.watch(developerModeStateProvider);
    final inBubble = NodeLaneBubbleFlow.contains(context);
    final identity = [
      completeLanguageName(source.lang ?? ''),
      if (source.version?.isNotEmpty == true) 'v${source.version}',
      if (source.isNsfw == true) '18+',
    ].where((part) => part.isNotEmpty).join(' · ');
    void dismiss() => Navigator.maybePop(context, source);
    final body = ListView(
      primary: inBubble ? false : null,
      shrinkWrap: inBubble,
      padding: inBubble
          ? NodeLaneTokens.bubbleContentPadding
          : NodeLaneTokens.pagePadding,
      children: [
        if (source.sourceCodeLanguage == SourceCodeLanguage.mihon)
          const ExtensionServerWarningBanner(),
        if (!inBubble)
          NodeLaneRow.card(
            title: source.name ?? '',
            subtitle: identity,
            leading: NodeLaneWebsiteIcon(url: source.iconUrl),
          ),
        if (source.repo?.website?.isNotEmpty == true) ...[
          if (!inBubble) const SizedBox(height: NodeLaneTokens.space24),
          NodeLaneRow.card(
            title: context.l10n.source_repository_website,
            icon: icons.external,
            onTap: () => _launchInBrowser(Uri.parse(source.repo!.website!)),
          ),
        ],
        if (sourcePreference?.isNotEmpty == true) ...[
          NodeLaneCatalogHeading(context.l10n.source_provided_settings),
          IgnorePointer(
            ignoring: _busy,
            child: SourcePreferenceWidget(
              sourcePreference: sourcePreference!,
              source: source,
              onSave: (pref, owner) async {
                setState(() => _busy = true);
                try {
                  await savePreferenceSetting(pref, owner);
                } finally {
                  if (mounted) setState(() => _busy = false);
                }
              },
            ),
          ),
        ],
        const SizedBox(height: NodeLaneTokens.space24),
        NodeLaneDisclosure(
          title: context.l10n.source_advanced_actions,
          icon: icons.extensions,
          child: Column(
            children: [
              if (developerMode)
                NodeLaneRow(
                  title: context.l10n.edit_code,
                  icon: icons.code,
                  onTap: _busy ? null : _editCode,
                ),
              if (developerMode && source.isLocal == true)
                NodeLaneRow(
                  title: context.l10n.source_edit_metadata,
                  icon: icons.edit,
                  onOpen: _busy ? null : _editMetadata,
                ),
              NodeLaneRow(
                title: context.l10n.source_clear_cookies,
                subtitle: context.l10n.source_clear_cookies_hint,
                icon: icons.cookies,
                onTap: _busy ? null : _clearCookies,
              ),
              NodeLaneRow(
                title: context.l10n.source_uninstall,
                icon: icons.delete,
                destructive: true,
                onOpen: _busy ? null : _confirmUninstall,
              ),
            ],
          ),
        ),
      ],
    );
    if (inBubble) {
      final title = context.l10n.settings_source_preferences;
      return NodeLaneBubblePanel(
        title: title,
        titleContent: Row(
          children: [
            ExcludeSemantics(
              child: SizedBox.square(
                dimension: NodeLaneTokens.smallIconSize,
                child: NodeLaneWebsiteIcon(url: source.iconUrl),
              ),
            ),
            const SizedBox(width: NodeLaneTokens.space8),
            Flexible(child: Text(title)),
          ],
        ),
        subtitle: [?source.name, if (identity.isNotEmpty) identity].join(' · '),
        onDismiss: dismiss,
        dismissEnabled: !_busy,
        child: body,
      );
    }
    return MobileBrowsePage(
      title: context.l10n.source_details,
      onDismiss: dismiss,
      busy: _busy,
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (NodeLaneBubbleFlow.contains(context) || (isMobile && !isTv)) {
      return _mobileView(context);
    }
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
                    onPressed: () => _editMetadata(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            context.l10n.source_edit_metadata,
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
                  onPressed: () => _confirmUninstall(context),
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
