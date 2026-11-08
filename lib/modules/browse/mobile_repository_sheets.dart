import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';
import 'package:url_launcher/url_launcher.dart';

String repositoryName(BuildContext context, Repo repo) =>
    repo.jsonUrl == nodeLaneCatalogUrl
    ? context.l10n.translation_official_channel
    : repo.name?.isNotEmpty == true
    ? repo.name!
    : Uri.tryParse(repo.jsonUrl ?? '')?.host ??
          context.l10n.repository_third_party;

String repositoryKey(String value) {
  final uri = Uri.tryParse(value.trim());
  if (uri == null) return value.trim();
  return uri
      .replace(
        scheme: uri.scheme.toLowerCase(),
        host: uri.host.toLowerCase(),
        path: uri.path.replaceFirst(RegExp(r'/+$'), ''),
        fragment: '',
      )
      .toString();
}

Future<void> showMobileRepositories(BuildContext context, ItemType type) =>
    showNodeLaneCatalogSheet<void>(
      context,
      MobileRepositoryManager(itemType: type),
    );
Future<void> showMobileAddRepository(BuildContext context, ItemType type) =>
    showNodeLaneCatalogSheet<void>(
      context,
      MobileAddRepository(itemType: type),
    );

class MobileRepositoryManager extends ConsumerStatefulWidget {
  const MobileRepositoryManager({
    super.key,
    required this.itemType,
    this.asPage = false,
  });
  final ItemType itemType;
  final bool asPage;
  @override
  ConsumerState<MobileRepositoryManager> createState() =>
      _MobileRepositoryManagerState();
}

class _MobileRepositoryManagerState
    extends ConsumerState<MobileRepositoryManager> {
  bool refreshing = false;
  String? refreshError;
  Future<void> _refresh() async {
    if (refreshing) return;
    setState(() {
      refreshing = true;
      refreshError = null;
    });
    try {
      final refreshed = ref.refresh(
        fetchItemSourcesListProvider(
          reFresh: true,
          itemType: widget.itemType,
        ).future,
      );
      await refreshed;
    } catch (_) {
      if (mounted) {
        setState(() => refreshError = context.l10n.repository_refresh_failed);
      }
    } finally {
      if (mounted) setState(() => refreshing = false);
    }
  }

  void _details(
    Repo repo, {
    bool builtIn = false,
  }) => showNodeLaneCatalogSheet<void>(
    context,
    Consumer(
      builder: (sheetContext, sheetRef, _) {
        final current =
            sheetRef
                .watch(extensionsRepoStateProvider(widget.itemType))
                .where((r) => r.jsonUrl == repo.jsonUrl)
                .firstOrNull ??
            repo;
        final icons = NodeLaneIcons.of(sheetContext);
        return NodeLaneCatalogSheet(
          title: repositoryName(context, current),
          subtitle: current.jsonUrl,
          heightFactor: .58,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              if (!builtIn)
                NodeLaneGroupSurface(
                  child: NodeLaneSwitchRow(
                    title: context.l10n.repository_show_sources,
                    value: current.hidden != true,
                    onChanged: (value) => sheetRef
                        .read(
                          extensionsRepoStateProvider(widget.itemType).notifier,
                        )
                        .setVisibility(current, !value),
                  ),
                ),
              const SizedBox(height: 12),
              NodeLaneRow.card(
                title: context.l10n.repository_copy_catalog,
                leading: Icon(icons.webLink),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: current.jsonUrl ?? ''));
                  Navigator.pop(sheetContext);
                },
              ),
              if (isBrowserUrl(current.website)) ...[
                const SizedBox(height: 12),
                NodeLaneRow.card(
                  title: context.l10n.source_repository_website,
                  leading: Icon(icons.web),
                  onTap: () => launchUrl(
                    Uri.parse(current.website!),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (!builtIn)
                NodeLaneRow.card(
                  title: context.l10n.repository_remove,
                  leading: Icon(icons.delete),
                  onTap: () async {
                    final yes = await showDialog<bool>(
                      context: sheetContext,
                      builder: (dialogContext) => NodeLaneAlertDialog(
                        title: Text(context.l10n.repository_remove),
                        content: Text(context.l10n.repository_remove_hint),
                        actions: [
                          NodeLaneDialogAction(
                            label: context.l10n.cancel,
                            secondary: true,
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                          ),
                          NodeLaneDialogAction(
                            label: context.l10n.remove,
                            destructive: true,
                            onPressed: () => Navigator.pop(dialogContext, true),
                          ),
                        ],
                      ),
                    );
                    if (yes != true || !mounted || !sheetContext.mounted) {
                      return;
                    }
                    final notifier = ref.read(
                      extensionsRepoStateProvider(widget.itemType).notifier,
                    );
                    final repos = ref.read(
                      extensionsRepoStateProvider(widget.itemType),
                    );
                    await notifier.set(
                      repos.where((r) => r.jsonUrl != current.jsonUrl).toList(),
                    );
                    final ids = sourceRepository
                        .getByItemType(widget.itemType)
                        .where(
                          (s) =>
                              s.repo?.jsonUrl == current.jsonUrl &&
                              (s.sourceCode?.isEmpty ?? true),
                        )
                        .map((s) => s.id!)
                        .toList();
                    if (ids.isNotEmpty) await sourceRepository.deleteAll(ids);
                    if (sheetContext.mounted) Navigator.pop(sheetContext);
                  },
                ),
            ],
          ),
        );
      },
    ),
  );
  @override
  Widget build(BuildContext context) {
    final configured = ref.watch(extensionsRepoStateProvider(widget.itemType));
    final official = ref.watch(
      nodeLaneCatalogRepositoryProvider(widget.itemType),
    );
    final builtIn =
        official != null &&
        !configured.any((r) => r.jsonUrl == official.jsonUrl);
    final repos = [if (builtIn) official, ...configured];
    final icons = NodeLaneIcons.of(context), t = NodeLaneTokens.of(context);
    final list = ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        if (repos.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              context.l10n.repository_empty,
              style: t.readerSecondary,
            ),
          ),
        for (var i = 0; i < repos.length; i++)
          NodeLaneRow.card(
            title: repositoryName(context, repos[i]),
            subtitle: [
              if (builtIn && i == 0) context.l10n.repository_built_in,
              Uri.tryParse(repos[i].jsonUrl ?? '')?.host ?? '',
              if (repos[i].hidden == true) context.l10n.repository_hidden,
            ].join(' · '),
            first: i == 0,
            last: i == repos.length - 1,
            leading: Icon(icons.repository),
            onTap: () => _details(repos[i], builtIn: builtIn && i == 0),
          ),
        const SizedBox(height: 20),
        NodeLaneRow.card(
          title: context.l10n.onboarding_add,
          leading: Icon(icons.add),
          onTap: () => showMobileAddRepository(context, widget.itemType),
        ),
        const SizedBox(height: 20),
        NodeLaneRow.card(
          title: refreshing
              ? context.l10n.repository_refreshing
              : context.l10n.repository_refresh,
          leading: refreshing
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(icons.refresh),
          onTap: refreshing ? null : _refresh,
        ),
        if (refreshError != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(refreshError!, style: t.readerSecondary),
          ),
      ],
    );
    return widget.asPage
        ? NodeLaneSurface(
            child: Scaffold(
              appBar: nodeLaneAppBar(
                context,
                title: context.l10n.repository_third_party,
              ),
              body: list,
            ),
          )
        : NodeLaneCatalogSheet(
            title: context.l10n.repository_third_party,
            subtitle: context.l10n.repository_manage_hint,
            heightFactor: .58,
            child: list,
          );
  }
}

class MobileAddRepository extends ConsumerStatefulWidget {
  const MobileAddRepository({super.key, required this.itemType});
  final ItemType itemType;
  @override
  ConsumerState<MobileAddRepository> createState() =>
      _MobileAddRepositoryState();
}

class _MobileAddRepositoryState extends ConsumerState<MobileAddRepository> {
  final input = TextEditingController();
  Timer? _debounce;
  int _revision = 0;
  Repo? preview;
  bool checking = false, saving = false;
  String? error;
  bool _exists(String value) => ref
      .read(extensionsRepoStateProvider(widget.itemType))
      .any((repo) => repositoryKey(repo.jsonUrl ?? '') == repositoryKey(value));
  void _changed(String value) {
    _debounce?.cancel();
    _revision++;
    setState(() {
      preview = null;
      checking = false;
      error = null;
    });
    if (value.trim().isEmpty) return;
    if (!isBrowserUrl(value.trim())) {
      setState(() => error = context.l10n.repository_invalid_address);
      return;
    }
    if (_exists(value)) {
      setState(() => error = context.l10n.repository_already_added);
      return;
    }
    _debounce = Timer(
      const Duration(milliseconds: 650),
      () => _check(value.trim(), _revision),
    );
  }

  Future<void> _check(String value, int revision) async {
    if (!mounted) return;
    setState(() => checking = true);
    try {
      final repo = await ref.read(getRepoInfosProvider(jsonUrl: value).future);
      if (!mounted || revision != _revision) return;
      setState(() {
        checking = false;
        if (repo == null || !isBrowserUrl(repo.jsonUrl)) {
          error = context.l10n.repository_unrecognized;
        } else if (_exists(repo.jsonUrl!)) {
          error = context.l10n.repository_already_added;
        } else {
          preview = repo;
        }
      });
    } catch (_) {
      if (mounted && revision == _revision) {
        setState(() {
          checking = false;
          error = context.l10n.repository_read_failed;
        });
      }
    }
  }

  Future<void> _save() async {
    final repo = preview;
    if (saving || repo == null) return;
    if (_exists(repo.jsonUrl ?? '') || _exists(input.text)) {
      setState(() => error = context.l10n.repository_already_added);
      return;
    }
    setState(() => saving = true);
    try {
      await ref.read(extensionsRepoStateProvider(widget.itemType).notifier).set(
        [...ref.read(extensionsRepoStateProvider(widget.itemType)), repo],
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() {
          saving = false;
          error = context.l10n.repository_save_failed;
        });
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return PopScope(
      canPop: !saving,
      child: NodeLaneCatalogSheet(
        title: context.l10n.onboarding_add,
        subtitle: context.l10n.repository_paste_hint,
        heightFactor: .9,
        fitContent: true,
        canClose: !saving,
        bottom: NodeLaneModalActions(
          actions: [
            NodeLaneDialogAction(
              label: context.l10n.onboarding_add,
              busy: saving,
              onPressed: preview == null || saving ? null : _save,
            ),
          ],
        ),
        child: ListView(
          shrinkWrap: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            NodeLaneTextField(
              controller: input,
              label: context.l10n.repository_address,
              hint: 'https://…',
              enabled: !saving,
              keyboardType: TextInputType.url,
              autocorrect: false,
              enableSuggestions: false,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              onChanged: _changed,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: saving
                  ? null
                  : () async {
                      final value = await Clipboard.getData(
                        Clipboard.kTextPlain,
                      );
                      if (!mounted || value?.text == null) return;
                      input.text = value!.text!.trim();
                      _changed(input.text);
                    },
              icon: Icon(icons.clipboard),
              label: Text(context.l10n.repository_paste_link),
            ),
            const SizedBox(height: 16),
            if (checking)
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            if (preview != null)
              NodeLaneRow.card(
                title: repositoryName(context, preview!),
                subtitle: context.l10n.repository_recognized(
                  widget.itemType.localized(context.l10n),
                ),
                leading: Icon(icons.repository),
                trailing: Icon(icons.check, color: t.accent),
              ),
            if (error != null) ...[
              Text(
                error!,
                style: t.readerSecondary.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              if (isBrowserUrl(input.text.trim()) && !_exists(input.text))
                TextButton(
                  onPressed: checking
                      ? null
                      : () => _check(input.text.trim(), ++_revision),
                  child: Text(context.l10n.retry),
                ),
            ],
            const SizedBox(height: 12),
            Text(
              context.l10n.repository_choose_sources_hint,
              textAlign: TextAlign.center,
              style: t.readerSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
