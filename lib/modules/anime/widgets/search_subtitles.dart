import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/more/settings/player/subtitle_service_screen.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/subtitles/subtitle_preferences.dart';
import 'package:mangayomi/services/subtitles/subtitle_service.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:path/path.dart' as path;

class SubtitlesWidgetSearch extends ConsumerStatefulWidget {
  const SubtitlesWidgetSearch({
    required this.chapter,
    required this.isLocal,
    super.key,
  });
  final Chapter chapter;
  final bool isLocal;

  @override
  ConsumerState<SubtitlesWidgetSearch> createState() =>
      _SubtitlesWidgetSearchState();
}

class _SubtitlesWidgetSearchState extends ConsumerState<SubtitlesWidgetSearch> {
  final _scope = Object();

  @override
  Widget build(BuildContext context) {
    Widget status(Widget child) => NodeLaneCatalogSheet(
      title: context.l10n.search_subtitles,
      fitContent: true,
      child: ListView(
        shrinkWrap: true,
        padding: NodeLaneTokens.pagePadding,
        children: [const SubtitleServiceSettingsRow(), child],
      ),
    );
    return ref
        .watch(subtitleSearchServiceProvider(_scope))
        .when(
          skipLoadingOnRefresh: false,
          loading: () => status(
            NodeLaneNotice(
              message: context.l10n.mass_migration_loading,
              kind: NodeLaneNoticeKind.progress,
            ),
          ),
          error: (_, _) => status(
            NodeLaneNotice(
              message: context.l10n.subtitle_storage_failed,
              kind: NodeLaneNoticeKind.error,
              actionLabel: context.l10n.retry,
              onAction: () => ref.invalidate(subtitlePreferencesProvider),
            ),
          ),
          data: (service) => service == null
              ? status(
                  NodeLaneNotice(message: context.l10n.subtitle_setup_required),
                )
              : _SubtitleSearchResults(
                  key: ObjectKey(service),
                  service: service,
                  chapter: widget.chapter,
                  isLocal: widget.isLocal,
                ),
        );
  }
}

class _SubtitleSearchResults extends StatefulWidget {
  const _SubtitleSearchResults({
    super.key,
    required this.service,
    required this.chapter,
    required this.isLocal,
  });
  final SubtitleSearchService service;
  final Chapter chapter;
  final bool isLocal;

  @override
  State<_SubtitleSearchResults> createState() => _SubtitleSearchResultsState();
}

class _SubtitleSearchResultsState extends State<_SubtitleSearchResults> {
  late final _controller = TextEditingController(
    text: widget.chapter.manga.value?.name?.trim() ?? '',
  );
  List<SubtitleTitle> _titles = [];
  SubtitleTitle? _title;
  List<SubtitleEpisode>? _episodes;
  List<SubtitleMatch>? _subtitles;
  bool _busy = false;
  SubtitleFailure? _error;
  Future<void> Function()? _retry;

  @override
  void initState() {
    super.initState();
    _search(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() operation) async {
    if (_busy || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
      _retry = null;
    });
    try {
      await operation();
    } catch (error) {
      if (mounted) {
        _error = error is SubtitleFailure
            ? error
            : const SubtitleFailure(SubtitleFailureCode.response);
        _retry = operation;
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _search(String value) => _run(() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _title = null;
    _episodes = null;
    _subtitles = null;
    _titles = await widget.service.catalog.searchTitles(value);
  });

  Future<void> _choose(int index) => _run(() async {
    if (_subtitles != null) {
      final content = await _subtitles![index].load();
      if (mounted) Navigator.pop(context, content);
    } else if (_episodes != null) {
      final episode = _episodes![index];
      _subtitles = await widget.service.source.search(
        SubtitleQuery(
          _title!.id,
          season: episode.season,
          episode: episode.episode,
        ),
      );
    } else {
      final title = _titles[index];
      if (title.isSeries) {
        final episodes = await widget.service.catalog.episodes(title.id);
        _title = title;
        _episodes = episodes;
      } else {
        _subtitles = await widget.service.source.search(
          SubtitleQuery(title.id),
        );
        _title = title;
      }
    }
  });

  Future<void> _download(int index) => _run(() async {
    final subtitle = await _subtitles![index].load();
    if (!mounted) return;
    final archive = widget.chapter.archivePath;
    final resolved = archive != null && archive.isNotEmpty
        ? await resolveLocalArchivePath(archive)
        : null;
    final directory = await StorageProvider().getMangaChapterDirectory(
      widget.chapter,
      mangaMainDirectory:
          resolved != null && widget.chapter.manga.value?.source == 'local'
          ? Directory(path.dirname(resolved))
          : null,
    );
    if (!mounted) return;
    if (directory == null) {
      throw const FileSystemException('Subtitle directory unavailable');
    }
    final language = subtitle.language.replaceAll(
      RegExp(r'[^a-zA-Z0-9_-]'),
      '_',
    );
    final file = File(
      path.join(
        '${directory.path}_subtitles',
        '${language.isEmpty ? 'und' : language}.${subtitle.format}',
      ),
    );
    await file.parent.create(recursive: true);
    final staging = await file.parent.createTemp('.subtitle-');
    try {
      final completed = await File(path.join(staging.path, 'subtitle'))
          .writeAsString(subtitle.text, flush: true);
      await completed.rename(file.path);
    } finally {
      await staging.delete(recursive: true);
    }
    if (mounted) {
      showNodeLaneNotice(
        context.l10n.finished(''),
        kind: NodeLaneNoticeKind.success,
      );
    }
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    final count = _subtitles?.length ?? _episodes?.length ?? _titles.length;
    return NodeLaneCatalogSheet(
      title: l.search_subtitles,
      heightFactor: .85,
      fitContent: true,
      onBack: !_busy && (_subtitles != null || _episodes != null)
          ? () => setState(() {
              if (_subtitles != null) {
                _subtitles = null;
              } else {
                _episodes = null;
                _title = null;
              }
              _error = null;
              _retry = null;
            })
          : null,
      child: ListView(
        shrinkWrap: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          AbsorbPointer(
            absorbing: _busy,
            child: const SubtitleServiceSettingsRow(),
          ),
          NodeLaneTextField.search(
            controller: _controller,
            hint: l.search,
            enabled: !_busy,
            onSubmitted: _search,
          ),
          const SizedBox(height: NodeLaneTokens.space16),
          if (_busy)
            NodeLaneNotice(
              message: l.mass_migration_loading,
              kind: NodeLaneNoticeKind.progress,
            )
          else if (_error != null)
            NodeLaneNotice(
              message: switch (_error!.code) {
                SubtitleFailureCode.configuration => l.subtitle_setup_required,
                SubtitleFailureCode.authentication => l.subtitle_auth_failed,
                SubtitleFailureCode.quota => l.subtitle_quota_exhausted,
                SubtitleFailureCode.network => l.subtitle_network_failed,
                SubtitleFailureCode.response => l.subtitle_response_invalid,
              },
              kind: NodeLaneNoticeKind.error,
              actionLabel: l.retry,
              onAction: () => _run(_retry!),
            )
          else if (count == 0)
            NodeLaneNotice(message: l.no_result)
          else
            NodeLaneGroupSurface(
              children: [
                for (var index = 0; index < count; index++)
                  NodeLaneRow(
                    title: _subtitles != null
                        ? (_subtitles![index].name.isEmpty
                              ? l.video_subtitle
                              : _subtitles![index].name)
                        : _episodes != null
                        ? 'S${_episodes![index].season}E${_episodes![index].episode}: ${_episodes![index].name}'
                        : _titles[index].name,
                    subtitle: _subtitles != null
                        ? '${_subtitles![index].displayLanguage} · ${_subtitles![index].format.toUpperCase()}'
                        : _episodes != null
                        ? null
                        : '${_titles[index].year ?? '—'} · ${l.score} ${_titles[index].rating?.toStringAsFixed(1) ?? '—'}',
                    icon: _subtitles != null ? icons.subtitles : icons.anime,
                    onTap: () => _choose(index),
                    trailing: _subtitles != null && widget.isLocal
                        ? NodeLaneIconButton(
                            icon: icons.download,
                            tooltip: l.download,
                            onPressed: () => _download(index),
                          )
                        : null,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

Future<SubtitleContent?> showSubtitleSearch(
  BuildContext context, {
  required Chapter chapter,
  required bool isLocal,
}) => showNodeLaneCatalogSheet<SubtitleContent>(
  context,
  SubtitlesWidgetSearch(chapter: chapter, isLocal: isLocal),
);
