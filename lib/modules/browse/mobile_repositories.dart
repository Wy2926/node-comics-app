import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
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

Future<void> showMobileAddRepository(BuildContext context, ItemType type) =>
    pushBrowsePage<void>(context, MobileAddRepository(itemType: type));

class MobileRepositoryManager extends ConsumerStatefulWidget {
  const MobileRepositoryManager({super.key, required this.itemType});
  final ItemType itemType;
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

  Future<void> _remove(Repo repo) async {
    final l = context.l10n, type = widget.itemType;
    if (!await showNodeLaneConfirmation(
          context,
          title: l.repository_remove,
          message: l.repository_remove_hint,
          confirmLabel: l.remove,
          destructive: true,
        ) ||
        !mounted) {
      return;
    }
    final provider = extensionsRepoStateProvider(type);
    await ref
        .read(provider.notifier)
        .set(
          ref.read(provider).where((r) => r.jsonUrl != repo.jsonUrl).toList(),
        );
    final ids = sourceRepository
        .getByItemType(type)
        .where(
          (s) =>
              s.repo?.jsonUrl == repo.jsonUrl &&
              (s.sourceCode?.isEmpty ?? true),
        )
        .map((s) => s.id!)
        .toList();
    if (ids.isNotEmpty) await sourceRepository.deleteAll(ids);
  }

  Widget _repository(Repo repo, bool builtIn) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: NodeLaneTokens.space8),
      child: NodeLaneDisclosure(
        key: ValueKey(repo.jsonUrl),
        title: repositoryName(context, repo),
        icon: icons.repository,
        subtitle: [
          if (builtIn) l.repository_built_in,
          Uri.tryParse(repo.jsonUrl ?? '')?.host ?? '',
          if (repo.hidden == true) l.repository_hidden,
        ].join(' · '),
        child: Column(
          children: [
            if (!builtIn)
              NodeLaneSwitchRow(
                title: l.repository_show_sources,
                value: repo.hidden != true,
                onChanged: (value) => ref
                    .read(extensionsRepoStateProvider(widget.itemType).notifier)
                    .setVisibility(repo, !value),
              ),
            NodeLaneRow(
              title: l.repository_copy_catalog,
              subtitle: repo.jsonUrl,
              icon: icons.webLink,
              onTap: () =>
                  Clipboard.setData(ClipboardData(text: repo.jsonUrl ?? '')),
            ),
            if (isBrowserUrl(repo.website))
              NodeLaneRow(
                title: l.source_repository_website,
                icon: icons.web,
                onTap: () => launchUrl(
                  Uri.parse(repo.website!),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            if (!builtIn)
              NodeLaneRow(
                title: l.repository_remove,
                icon: icons.delete,
                destructive: true,
                onTap: () => _remove(repo),
              ),
          ],
        ),
      ),
    );
  }

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
      padding: NodeLaneTokens.pagePadding,
      children: [
        Text(context.l10n.repository_manage_hint, style: t.readerSecondary),
        const SizedBox(height: NodeLaneTokens.space16),
        if (repos.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              context.l10n.repository_empty,
              style: t.readerSecondary,
            ),
          ),
        for (var i = 0; i < repos.length; i++)
          _repository(repos[i], builtIn && i == 0),
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
    return MobileBrowsePage.form(
      title: context.l10n.repository_third_party,
      body: list,
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
      child: MobileBrowsePage.form(
        title: context.l10n.onboarding_add,
        bottomAction: FilledButton(
          onPressed: preview == null || saving ? null : _save,
          child: Text(context.l10n.onboarding_add),
        ),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(context.l10n.repository_paste_hint, style: t.readerSecondary),
            const SizedBox(height: NodeLaneTokens.space16),
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
