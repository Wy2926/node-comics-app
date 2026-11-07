import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_card.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_section.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/tracker_library_cache_repository.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class TrackerSectionScreen extends StatefulWidget {
  final TrackLibrarySection section;

  const TrackerSectionScreen({super.key, required this.section});

  @override
  State<TrackerSectionScreen> createState() => _TrackerSectionScreenState();
}

class _TrackerSectionScreenState extends State<TrackerSectionScreen> {
  String _errorMessage = "";
  bool _isLoading = true;
  List<TrackSearch> _tracks = [];
  late StreamSubscription<List<Track>> _trackStreamSub;
  Map<int, Track> _trackIndex = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
    _subscribeToTracks();
  }

  void _subscribeToTracks() {
    _trackStreamSub = trackRepository
        .watchByItemTypeAndSyncId(
          widget.section.itemType,
          widget.section.syncId,
        )
        .listen((tracks) {
          if (mounted) {
            setState(() {
              _trackIndex = {
                for (final t in tracks)
                  if (t.mediaId != null && t.mangaId != null) t.mediaId!: t,
              };
            });
          }
        });
  }

  @override
  void dispose() {
    _trackStreamSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget content;
    if (_isLoading) {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: NodeLaneTokens.space12),
              const NodeLaneSkeleton(
                width: NodeLaneTokens.detailCoverWidth,
                height: NodeLaneTokens.detailCoverHeight,
                radius: NodeLaneTokens.groupRadius,
              ),
            ],
          ],
        ),
      );
    } else if (_errorMessage.isNotEmpty) {
      content = NodeLaneEmptyState.error(
        compact: true,
        message: _errorMessage,
        onRetry: () {
          setState(() {
            _isLoading = true;
            _errorMessage = '';
          });
          _fetchData();
        },
      );
    } else if (_tracks.isEmpty) {
      content = NodeLaneEmptyState(
        icon: NodeLaneIcons.of(context).tracking,
        title: l10n.no_result,
      );
    } else {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < _tracks.length; i++) ...[
              if (i > 0) const SizedBox(width: NodeLaneTokens.space12),
              TrackerLibraryImageCard(
                track: _tracks[i],
                itemType: widget.section.itemType,
                libraryTrack: _trackIndex[_tracks[i].mediaId],
              ),
            ],
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: NodeLaneTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [NodeLaneCatalogHeading(widget.section.name), content],
      ),
    );
  }

  Future<void> _fetchData() async {
    final section = widget.section;
    final key = '${section.syncId}-${section.itemType.name}-${section.name}';
    try {
      final cached = section.isSearch
          ? null
          : await trackerLibraryCacheRepository.get(key);
      if (!mounted) return;
      final tracks = cached ?? await section.func() ?? <TrackSearch>[];
      if (!mounted) return;
      if (cached == null && !section.isSearch) {
        await trackerLibraryCacheRepository.put(key, tracks);
      }
      if (mounted) {
        setState(() {
          _tracks = tracks;
          _errorMessage = '';
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.toString();
          _isLoading = false;
        });
      }
    }
  }
}
