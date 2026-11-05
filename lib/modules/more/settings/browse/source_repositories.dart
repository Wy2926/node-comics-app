import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/browse/mobile_repository_sheets.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mangayomi/modules/more/widgets/outlined_field_decoration.dart';

class SourceRepositories extends ConsumerStatefulWidget {
  final ItemType itemType;
  const SourceRepositories({required this.itemType, super.key});

  @override
  ConsumerState<SourceRepositories> createState() => _SourceRepositoriesState();
}

class _SourceRepositoriesState extends ConsumerState<SourceRepositories> {
  bool isRefreshing = false;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  String _repositoryName(Repo repo) {
    if (repo.name != null &&
        repo.name!.isNotEmpty &&
        !repo.name!.endsWith('.json')) {
      return repo.name!;
    }
    return repo.jsonUrl
            ?.replaceAll(RegExp(r'/[^/]+\.json$'), '')
            .split('/')
            .where((part) => part.isNotEmpty)
            .lastOrNull ??
        repo.jsonUrl ??
        'Invalid source - remove it';
  }

  bool _containsRepository(String address) {
    final clean = address.trim().toLowerCase();
    return ref.read(extensionsRepoStateProvider(widget.itemType)).any((repo) {
      final url = repo.jsonUrl?.trim().toLowerCase();
      return url != null &&
          (url == clean || url == '$clean/' || '$url/' == clean);
    });
  }

  Future<void> _refreshRepositories() async {
    if (isRefreshing) return;
    setState(() => isRefreshing = true);
    try {
      final refresh = ref.refresh(
        fetchItemSourcesListProvider(
          id: null,
          reFresh: true,
          itemType: widget.itemType,
        ).future,
      );
      await refresh;
    } finally {
      if (mounted) setState(() => isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isMobile && !isTv) {
      return MobileRepositoryManager(itemType: widget.itemType, asPage: true);
    }
    final l10n = context.l10n;
    final repositories = ref.watch(
      extensionsRepoStateProvider(widget.itemType),
    );
    return Scaffold(
      appBar: AppBar(
        title: switch (widget.itemType) {
          ItemType.manga => Text(l10n.manage_manga_repo_urls),
          ItemType.anime => Text(l10n.manage_anime_repo_urls),
          _ => Text(l10n.manage_novel_repo_urls),
        },
        actions: [
          isRefreshing
              ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: IconButton(
                    splashRadius: 20,
                    onPressed: _refreshRepositories,
                    icon: Icon(
                      Icons.refresh,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
        ],
      ),
      body: repositories.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  l10n.empty_extensions_repo,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SuperListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repo = repositories[index];
                final isHidden = repo.hidden ?? false;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Opacity(
                            opacity: isHidden ? 0.3 : 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: SizedBox.square(
                                    dimension: 64,
                                    child: Icon(
                                      Icons.source_outlined,
                                      size: 32,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _repositoryName(repo),
                                    style: TextStyle(
                                      decoration: isHidden
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (repo.website != null)
                                IconButton(
                                  onPressed: () {
                                    _launchInBrowser(Uri.parse(repo.website!));
                                  },
                                  icon: Icon(Icons.open_in_new_outlined),
                                ),
                              SizedBox(width: 10),
                              IconButton(
                                onPressed: () async {
                                  if (repo.jsonUrl != null) {
                                    await Clipboard.setData(
                                      ClipboardData(text: repo.jsonUrl!),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.content_copy),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                onPressed: () => ref
                                    .read(
                                      extensionsRepoStateProvider(
                                        widget.itemType,
                                      ).notifier,
                                    )
                                    .setVisibility(repo, !isHidden),
                                icon: Stack(
                                  children: [
                                    const Icon(Icons.remove_red_eye_outlined),
                                    if (isHidden)
                                      Positioned(
                                        right: 8,
                                        child: Transform.scale(
                                          scaleX: 2.5,
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '\\',
                                                style: TextStyle(fontSize: 17),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                onPressed: () =>
                                    _showRemoveRepoDialog(context, repo),
                                icon: const Icon(Icons.delete_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRepoDialog(context),
        label: Row(
          children: [
            const Icon(Icons.add),
            const SizedBox(width: 10),
            Text(l10n.add),
          ],
        ),
      ),
    );
  }

  /// #774: when a repo is removed, drop its *not-installed* sources so they
  /// don't linger as placeholders with a dead install button. Installed
  /// sources (non-empty [Source.sourceCode]) are kept so users don't lose them.
  Future<void> _removeOrphanSources(Repo removedRepo) async {
    final repoUrl = removedRepo.jsonUrl;
    if (repoUrl == null) return;
    final orphanIds = sourceRepository
        .getByItemType(widget.itemType)
        .where(
          (s) => s.repo?.jsonUrl == repoUrl && (s.sourceCode?.isEmpty ?? true),
        )
        .map((s) => s.id!)
        .toList();
    if (orphanIds.isNotEmpty) {
      await sourceRepository.deleteAll(orphanIds);
    }
  }

  void _showRemoveRepoDialog(BuildContext context, Repo removedRepo) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = context.l10n;
        return AlertDialog(
          scrollable: true,
          title: Text(l10n.remove_extensions_repo),
          content: Text(_repositoryName(removedRepo)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                final repositories = ref
                    .read(extensionsRepoStateProvider(widget.itemType))
                    .toList();
                repositories.removeWhere((repo) => repo == removedRepo);
                await ref
                    .read(extensionsRepoStateProvider(widget.itemType).notifier)
                    .set(repositories);
                await _removeOrphanSources(removedRepo);
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  void _showAddRepoDialog(BuildContext context) {
    bool isLoading = false;
    final controller = TextEditingController();
    final navigator = Navigator.of(context, rootNavigator: true);
    final route = DialogRoute<void>(
      context: context,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
      builder: (context) {
        return SizedBox(
          child: StatefulBuilder(
            builder: (context, setState) {
              final l10n = context.l10n;
              return AlertDialog(
                scrollable: true,
                title: Text(l10n.add_extensions_repo),
                content: TextFormField(
                  controller: controller,
                  // On Android TV, don't autofocus: it instantly pops the
                  // full-screen leanback keyboard over the dialog before the
                  // user can even see the Cancel/Add buttons. Let them navigate
                  // to the field and open the keyboard with select instead.
                  // Desktop keeps autofocus for the usual ready-to-type flow.
                  autofocus: !isTv,
                  keyboardType: TextInputType.url,
                  onChanged: (value) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.url_cannot_be_empty;
                    }
                    try {
                      final uri = Uri.parse(value.trim());
                      if (!uri.isAbsolute ||
                          (uri.scheme != 'http' && uri.scheme != 'https')) {
                        return l10n.invalid_url_format;
                      }
                      final clean = value.trim().toLowerCase();
                      final alreadyExists = _containsRepository(clean);
                      if (alreadyExists) {
                        return l10n.repo_already_exists;
                      }
                      return null;
                    } catch (e) {
                      return l10n.invalid_url_format;
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: outlinedFieldDecoration(
                    hintText: l10n.url_must_end_with_dot_json_or_dot_pb,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(l10n.cancel),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      final text = controller.text.trim();
                      final clean = text.toLowerCase();
                      final alreadyExists = _containsRepository(clean);
                      final isValid =
                          text.isNotEmpty &&
                          !alreadyExists &&
                          Uri.tryParse(text)?.isAbsolute == true;
                      return TextButton(
                        onPressed: !isValid || isLoading
                            ? null
                            : () async {
                                setState(() => isLoading = true);
                                try {
                                  final repoNotifier = ref.read(
                                    extensionsRepoStateProvider(widget.itemType)
                                        .notifier,
                                  );
                                  final currentRepos = ref.read(
                                    extensionsRepoStateProvider(
                                      widget.itemType,
                                    ),
                                  );
                                  final repo = await ref.read(
                                    getRepoInfosProvider(jsonUrl: text).future,
                                  );
                                  if (repo == null) {
                                    if (context.mounted) {
                                      setState(() => isLoading = false);
                                    }
                                    showNodeLaneNotice(
                                      l10n.unsupported_repo,
                                      kind: NodeLaneNoticeKind.error,
                                    );
                                    return;
                                  }
                                  final repoUrl = repo.jsonUrl
                                      ?.trim()
                                      .toLowerCase();
                                  final isDuplicate = currentRepos.any((r) {
                                    final rUrl = r.jsonUrl
                                        ?.trim()
                                        .toLowerCase();
                                    return (rUrl != null &&
                                            (rUrl == repoUrl ||
                                                rUrl == clean ||
                                                rUrl == '$clean/' ||
                                                '$rUrl/' == clean ||
                                                (repoUrl != null &&
                                                    (rUrl == '$repoUrl/' ||
                                                        '$rUrl/' ==
                                                            repoUrl)))) ||
                                        r == repo;
                                  });
                                  if (isDuplicate) {
                                    setState(() => isLoading = false);
                                    showNodeLaneNotice(
                                      l10n.repo_already_exists,
                                    );
                                    return;
                                  }
                                  await repoNotifier.set([
                                    ...currentRepos,
                                    repo,
                                  ]);
                                  showNodeLaneNotice(
                                    l10n.repo_added,
                                    kind: NodeLaneNoticeKind.success,
                                  );
                                } catch (e, s) {
                                  if (context.mounted) {
                                    setState(() => isLoading = false);
                                  }
                                  toastError(
                                    e,
                                    stack: s,
                                    source: 'sourceRepositories',
                                  );
                                  return;
                                }

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                l10n.add,
                                style: TextStyle(
                                  color: !isValid
                                      ? Theme.of(context).primaryColor
                                            .withValues(alpha: 0.2)
                                      : null,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
    navigator.push(route);
    // The pop future resolves before the closing animation. Keep the field
    // alive until the route and its widgets have actually been removed.
    route.completed.whenComplete(controller.dispose);
  }
}
