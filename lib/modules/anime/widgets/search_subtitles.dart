import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/fetch_subtitles.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:path/path.dart' as path;

class SubtitlesWidgetSearch extends ConsumerStatefulWidget {
  final Chapter chapter;
  final bool isLocal;
  const SubtitlesWidgetSearch({
    required this.chapter,
    required this.isLocal,
    super.key,
  });

  @override
  ConsumerState<SubtitlesWidgetSearch> createState() =>
      _SubtitlesWidgetSearchState();
}

class _SubtitlesWidgetSearchState extends ConsumerState<SubtitlesWidgetSearch> {
  late final _controller = TextEditingController(text: query);
  List<ImdbTitle> titles = [];
  List<ImdbEpisode>? episodes;
  List<ImdbSubtitle>? subtitles;
  late String query = widget.chapter.manga.value?.name?.trim() ?? "";
  bool _isLoading = true;
  String? _errorMsg;

  @override
  initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Yield to microtask queue so initState completes before async work
    await Future(() {});
    try {
      titles = await fetchImdbTitles(query);
    } catch (e) {
      _errorMsg = e.toString();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String value) async {
    if (_isLoading) return;
    FocusManager.instance.primaryFocus?.unfocus();
    query = value.trim();
    setState(() {
      _isLoading = true;
      _errorMsg = null;
      episodes = null;
      subtitles = null;
    });
    await _init();
  }

  Future<void> _choose(int index) async {
    if (_isLoading) return;
    if (subtitles != null) {
      Navigator.pop(context, subtitles![index]);
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      if (episodes != null) {
        subtitles = await fetchImdbSubtitles(episodes![index].id);
      } else {
        episodes = await fetchImdbEpisodes(titles[index].id);
        if (episodes == null || episodes!.isEmpty) {
          episodes = null;
          subtitles = await fetchImdbSubtitles(titles[index].id);
        }
      }
    } catch (e) {
      _errorMsg = e.toString();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n, icons = NodeLaneIcons.of(context);
    final count = subtitles?.length ?? episodes?.length ?? titles.length;
    return NodeLaneCatalogSheet(
      title: l10n.search_subtitles,
      heightFactor: .85,
      fitContent: true,
      onBack: !_isLoading && (subtitles != null || episodes != null)
          ? () => setState(() {
              if (subtitles != null) {
                subtitles = null;
              } else {
                episodes = null;
              }
              _errorMsg = null;
            })
          : null,
      child: ListView(
        shrinkWrap: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          NodeLaneTextField.search(
            controller: _controller,
            hint: l10n.search,
            enabled: !_isLoading,
            onSubmitted: _search,
          ),
          const SizedBox(height: NodeLaneTokens.space16),
          if (_isLoading)
            NodeLaneNotice(
              message: l10n.mass_migration_loading,
              kind: NodeLaneNoticeKind.progress,
            )
          else if (_errorMsg != null)
            NodeLaneNotice(message: l10n.failed, kind: NodeLaneNoticeKind.error)
          else if (count == 0)
            NodeLaneNotice(message: l10n.no_result)
          else
            NodeLaneGroupSurface(
              children: [
                for (var index = 0; index < count; index++)
                  NodeLaneRow(
                    title: subtitles != null
                        ? subtitles![index].name ?? l10n.video_subtitle
                        : episodes != null
                        ? 'S${episodes![index].season}E${episodes![index].episode}: ${episodes![index].title}'
                        : titles[index].primaryTitle,
                    subtitle: subtitles != null
                        ? [
                            subtitles![index].displayLang,
                            subtitles![index].format?.toUpperCase(),
                            subtitles![index].encoding,
                          ].whereType<String>().join(' · ')
                        : episodes != null
                        ? null
                        : '${titles[index].startYear ?? "—"} · ${l10n.score} ${titles[index].aggregateRating?.toStringAsFixed(1) ?? "—"}',
                    icon: subtitles != null ? icons.subtitles : icons.anime,
                    onTap: () => _choose(index),
                    trailing: subtitles != null && widget.isLocal
                        ? NodeLaneIconButton(
                            icon: icons.download,
                            tooltip: l10n.download,
                            onPressed: () => _downloadSubtitle(index),
                          )
                        : null,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _downloadSubtitle(int index) async {
    showNodeLaneNotice(context.l10n.started);
    try {
      final subtitle = subtitles![index];
      final storageProvider = StorageProvider();
      final resolvedArchivePath =
          widget.chapter.archivePath?.isNotEmpty ?? false
          ? await resolveLocalArchivePath(widget.chapter.archivePath!)
          : null;
      final animeDir =
          resolvedArchivePath != null &&
              widget.chapter.manga.value?.source == "local"
          ? Directory(path.dirname(resolvedArchivePath))
          : null;
      final chapterDirectory = (await storageProvider.getMangaChapterDirectory(
        widget.chapter,
        mangaMainDirectory: animeDir,
      ))!;
      final subtitleFile = File(
        path.join(
          '${chapterDirectory.path}_subtitles',
          '${subtitle.language}.srt',
        ),
      );
      final client = MClient.httpClient(
        settings: const ClientSettings(
          throwOnStatusCode: false,
          tlsSettings: TlsSettings(verifyCertificates: false),
        ),
      );
      await subtitleFile.create(recursive: true);
      final response = await _withRetry(
        () => client.get(Uri.parse(subtitle.url ?? '')),
      );
      if (response.statusCode != 200) {
        AppLogger.log(
          'Warning: Failed to download subtitle file: ${subtitle.language}',
        );
        return;
      }
      AppLogger.log('Subtitle file downloaded: ${subtitle.language}');
      await subtitleFile.writeAsBytes(response.bodyBytes);
      if (mounted) {
        showNodeLaneNotice(
          context.l10n.finished(""),
          kind: NodeLaneNoticeKind.success,
        );
      }
    } catch (e) {
      AppLogger.log("Failed to download subtitle:", logLevel: LogLevel.error);
      AppLogger.log(e.toString(), logLevel: LogLevel.error);
      if (mounted) {
        showNodeLaneNotice(context.l10n.failed, kind: NodeLaneNoticeKind.error);
      }
    }
  }

  Future<T> _withRetry<T>(Future<T> Function() operation) async {
    int attempts = 0;
    while (true) {
      try {
        attempts++;
        return await operation();
      } catch (e) {
        if (attempts >= 3) {
          AppLogger.log("Request retries failed", logLevel: LogLevel.error);
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: 300 * attempts));
      }
    }
  }
}

Future<dynamic> subtitlesSearchraggableMenu(
  BuildContext context, {
  required Chapter chapter,
  required bool isLocal,
}) async {
  return showNodeLaneCatalogSheet(
    context,
    SubtitlesWidgetSearch(chapter: chapter, isLocal: isLocal),
  );
}
