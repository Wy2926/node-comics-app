import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileMigrationSearchPage extends StatelessWidget {
  const MobileMigrationSearchPage({
    super.key,
    required this.title,
    required this.subject,
    required this.query,
    required this.controller,
    required this.onSubmit,
    required this.onClear,
    required this.sourceCount,
    required this.sourceBuilder,
    this.empty,
  });
  final String title, subject, query;
  final TextEditingController controller;
  final VoidCallback onSubmit, onClear;
  final int sourceCount;
  final IndexedWidgetBuilder sourceBuilder;
  final Widget? empty;

  @override
  Widget build(BuildContext context) => MobileBrowsePage(
    title: title,
    body: LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight * .5),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: NodeLaneTextField.search(
                controller: controller,
                hint: context.l10n.search,
                clearLabel: context.l10n.reset,
                onSubmitted: (_) => onSubmit(),
                onClear: onClear,
              ),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              key: ValueKey(query),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          subject,
                          style: TextStyle(
                            color: NodeLaneTokens.of(context).muted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          query.isEmpty
                              ? context.l10n.migration_search_prompt
                              : context.l10n.global_search_results_for(query),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                if (empty != null)
                  SliverToBoxAdapter(child: empty)
                else if (query.isNotEmpty)
                  SliverList.builder(
                    itemCount: sourceCount,
                    itemBuilder: sourceBuilder,
                    addAutomaticKeepAlives: false,
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

enum MigrationPreviewOutcome { completed, failed }

/// Owns presentation and a single explicit submission. Data requests and writes
/// stay with the existing migration/tracker callers.
class MobileMigrationPreviewPage extends StatefulWidget {
  const MobileMigrationPreviewPage({
    super.key,
    required this.oldTitle,
    required this.oldSource,
    required this.targetTitle,
    required this.targetSource,
    required this.loadPreview,
    required this.onConfirm,
    required this.formatDate,
    this.watchCategories,
    this.onEditCategories,
  });
  final String oldTitle, oldSource, targetTitle, targetSource;
  final Future<MManga> Function() loadPreview;
  final Future<void> Function(MManga preview, List<int> categoryIds) onConfirm;
  final String Function(String value) formatDate;
  final Stream<List<Category>> Function()? watchCategories;
  final Future<void> Function()? onEditCategories;

  @override
  State<MobileMigrationPreviewPage> createState() =>
      _MobileMigrationPreviewPageState();
}

class _MobileMigrationPreviewPageState
    extends State<MobileMigrationPreviewPage> {
  MManga? _preview;
  Object? _loadError, _writeError;
  bool _loading = false,
      _saving = false,
      _submitted = false,
      _showChapters = true;
  final _selected = <int>{};
  late Stream<List<Category>>? _categories = widget.watchCategories?.call();
  bool get _tracking => widget.watchCategories != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final preview = await widget.loadPreview();
      if (mounted) setState(() => _preview = preview);
    } catch (error) {
      if (mounted) setState(() => _loadError = error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirm(List<int> categoryIds) async {
    if (_submitted || _saving || _preview == null) return;
    setState(() {
      _saving = true;
      _submitted = true;
    });
    try {
      await widget.onConfirm(_preview!, categoryIds);
      if (mounted) Navigator.pop(context, MigrationPreviewOutcome.completed);
    } catch (error) {
      // Migration and tracker addition may have written before failing. A
      // second invocation here could duplicate work or erase recoverable state.
      if (mounted) setState(() => _writeError = error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _close() => Navigator.pop(
    context,
    _writeError == null ? null : MigrationPreviewOutcome.failed,
  );

  @override
  Widget build(BuildContext context) => _tracking
      ? StreamBuilder<List<Category>>(
          stream: _categories,
          builder: (context, snapshot) => _page(snapshot),
        )
      : _page(null);

  Widget _page(AsyncSnapshot<List<Category>>? categories) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final entries = categories?.data ?? const <Category>[];
    final categoryBusy =
        categories != null && !categories.hasData && !categories.hasError;
    final categoryError = categories?.error;
    final chapters = _preview?.chapters ?? [];
    final canConfirm =
        !_loading &&
        _loadError == null &&
        _preview != null &&
        !categoryBusy &&
        categoryError == null &&
        !_submitted;
    return PopScope(
      canPop: !_saving,
      child: MobileBrowsePage(
        title: _tracking
            ? l10n.track_library_add_confirm
            : l10n.migrate_confirm,
        leading: IconButton(
          tooltip: l10n.cancel,
          onPressed: _saving ? null : _close,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        body: _writeError != null
            ? SingleChildScrollView(
                child: _message(l10n.migration_partial_failure, _writeError),
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: NodeLaneGroupSurface(
                      margin: const EdgeInsets.fromLTRB(
                        NodeLaneTokens.gutter,
                        0,
                        NodeLaneTokens.gutter,
                        NodeLaneTokens.space12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.migration_original_item,
                              style: TextStyle(color: colors.muted),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.oldTitle,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (widget.oldSource.isNotEmpty)
                              Text(widget.oldSource),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Icon(
                                Icons.arrow_downward_rounded,
                                color: colors.muted,
                              ),
                            ),
                            Text(
                              l10n.migration_target_item,
                              style: TextStyle(color: colors.muted),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.targetTitle,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(widget.targetSource),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_loading)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  else if (_loadError != null)
                    SliverToBoxAdapter(
                      child: _message(
                        l10n.something_went_wrong,
                        _loadError,
                        onRetry: _load,
                      ),
                    )
                  else ...[
                    if (_tracking) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.set_categories,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                              ),
                              TextButton(
                                onPressed: _submitted
                                    ? null
                                    : widget.onEditCategories,
                                child: Text(l10n.edit),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (categoryBusy)
                        const SliverToBoxAdapter(
                          child: LinearProgressIndicator(),
                        )
                      else if (categoryError != null)
                        SliverToBoxAdapter(
                          child: _message(
                            l10n.something_went_wrong,
                            categoryError,
                            onRetry: _submitted
                                ? null
                                : () => setState(
                                    () =>
                                        _categories = widget.watchCategories!(),
                                  ),
                          ),
                        )
                      else if (entries.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                            child: Text(l10n.migration_no_categories),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          sliver: SliverList.builder(
                            itemCount: entries.length,
                            itemBuilder: (context, index) {
                              final entry = entries[index];
                              return CheckboxListTile(
                                value: _selected.contains(entry.id),
                                title: Text(entry.name ?? ''),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: _submitted || entry.id == null
                                    ? null
                                    : (value) => setState(() {
                                        if (value == true) {
                                          _selected.add(entry.id!);
                                        } else {
                                          _selected.remove(entry.id);
                                        }
                                      }),
                              );
                            },
                          ),
                        ),
                    ],
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.n_chapters(chapters.length)),
                          trailing: chapters.isEmpty
                              ? null
                              : Icon(
                                  _showChapters
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
                          onTap: chapters.isEmpty
                              ? null
                              : () => setState(
                                  () => _showChapters = !_showChapters,
                                ),
                        ),
                      ),
                    ),
                    if (_showChapters)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList.builder(
                          itemCount: chapters.length,
                          itemBuilder: (context, index) {
                            final chapter = chapters[index];
                            final metadata = [
                              if (chapter.dateUpload?.isNotEmpty == true)
                                _formatDate(chapter.dateUpload!),
                              if (chapter.scanlator?.isNotEmpty == true)
                                chapter.scanlator!,
                            ].join(' · ');
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              title: Text(chapter.name ?? ''),
                              subtitle: metadata.isEmpty
                                  ? null
                                  : Text(metadata),
                            );
                          },
                        ),
                      ),
                  ],
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
        bottomAction: _writeError != null
            ? FilledButton(onPressed: _close, child: Text(l10n.close))
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_saving)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: LinearProgressIndicator(),
                    ),
                  FilledButton(
                    onPressed: canConfirm
                        ? () => _confirm(
                            entries
                                .where((e) => _selected.contains(e.id))
                                .map((e) => e.id!)
                                .toList(),
                          )
                        : null,
                    child: Text(
                      _tracking ? l10n.track_library_add : l10n.migrate,
                    ),
                  ),
                  TextButton(
                    onPressed: _saving ? null : _close,
                    child: Text(l10n.cancel),
                  ),
                ],
              ),
      ),
    );
  }

  String _formatDate(String value) {
    try {
      return widget.formatDate(value);
    } catch (_) {
      return value;
    }
  }

  Widget _message(String title, Object? detail, {VoidCallback? onRetry}) =>
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title),
            if (detail != null) ...[
              const SizedBox(height: 8),
              Text(
                detail.toString(),
                style: TextStyle(color: NodeLaneTokens.of(context).muted),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              NodeLaneSecondaryButton(
                onPressed: onRetry,
                child: Text(context.l10n.retry),
              ),
            ],
          ],
        ),
      );
}
