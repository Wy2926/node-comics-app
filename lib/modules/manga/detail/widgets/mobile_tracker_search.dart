import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/cached_network.dart';

class MobileTrackerSearchScreen extends ConsumerWidget {
  const MobileTrackerSearchScreen({
    super.key,
    required this.track,
    required this.itemType,
  });
  final Track track;
  final ItemType itemType;

  @override
  Widget build(BuildContext context, WidgetRef ref) => MobileTrackerSearch(
    initialQuery: track.title?.trim() ?? '',
    search: (query) => ref
        .read(
          trackStateProvider(
            track: track,
            itemType: itemType,
            widgetRef: ref,
          ).notifier,
        )
        .search(query),
  );
}

class MobileTrackerSearch extends StatefulWidget {
  const MobileTrackerSearch({
    super.key,
    required this.initialQuery,
    required this.search,
  });
  final String initialQuery;
  final Future<List<TrackSearch>?> Function(String) search;

  @override
  State<MobileTrackerSearch> createState() => _MobileTrackerSearchState();
}

class _MobileTrackerSearchState extends State<MobileTrackerSearch> {
  late final _query = TextEditingController(text: widget.initialQuery);
  List<TrackSearch> _results = [];
  bool _loading = false, _failed = false, _searched = false;

  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      if (mounted && widget.initialQuery.isNotEmpty) await _search();
    });
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _query.text.trim();
    if (_loading || query.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _failed = false;
      _results = [];
    });
    try {
      final results = await widget.search(query);
      if (mounted) setState(() => _results = results ?? []);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _searched = true;
        });
      }
    }
  }

  void _editQuery() => setState(() {
    _results = [];
    _failed = false;
    _searched = false;
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.tracking,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Semantics(
                        label: l10n.search,
                        child: TextField(
                          controller: _query,
                          enabled: !_loading,
                          textInputAction: TextInputAction.search,
                          onChanged: (_) => _editQuery(),
                          onSubmitted: (_) => _search(),
                          decoration: InputDecoration(
                            hintText: l10n.search,
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _query.text.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: l10n.reset,
                                    onPressed: _loading
                                        ? null
                                        : () {
                                            _query.clear();
                                            _editQuery();
                                          },
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                            filled: true,
                            fillColor: colors.soft,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _loading || _query.text.trim().isEmpty
                            ? null
                            : _search,
                        icon: const Icon(Icons.search_rounded),
                        label: Text(_failed ? l10n.retry : l10n.search),
                      ),
                      if (_loading) ...[
                        const SizedBox(height: 16),
                        const LinearProgressIndicator(),
                      ],
                      if (_failed) ...[
                        const SizedBox(height: 16),
                        Semantics(liveRegion: true, child: Text(l10n.failed)),
                      ] else if (!_loading &&
                          _searched &&
                          _results.isEmpty) ...[
                        const SizedBox(height: 16),
                        Text(l10n.no_result),
                      ],
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Semantics(
                        button: true,
                        enabled: result.mediaId != null,
                        child: Material(
                          color: colors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: colors.line),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: result.mediaId == null
                                ? null
                                : () => Navigator.pop(context, result),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          width: 64,
                                          height: 96,
                                          child:
                                              result.coverUrl?.isNotEmpty ==
                                                  true
                                              ? Image(
                                                  image: coverProvider(
                                                    result.coverUrl!,
                                                  ),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, _, _) =>
                                                      const Icon(
                                                        Icons.book_outlined,
                                                      ),
                                                )
                                              : const Icon(Icons.book_outlined),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              result.title ?? l10n.unknown,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            if (result
                                                    .publishingType
                                                    ?.isNotEmpty ==
                                                true)
                                              Text(
                                                '${l10n.type}: ${result.publishingType}',
                                                style: TextStyle(
                                                  color: colors.muted,
                                                ),
                                              ),
                                            if (result
                                                    .publishingStatus
                                                    ?.isNotEmpty ==
                                                true)
                                              Text(
                                                '${l10n.status}: ${result.publishingStatus}',
                                                style: TextStyle(
                                                  color: colors.muted,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (result.summary?.isNotEmpty == true) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      result.summary!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: colors.muted),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
