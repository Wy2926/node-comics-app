import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_widget.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/widgets/tracker_account_avatar.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/constant.dart';

class MobileTrackingDetail extends StatelessWidget {
  const MobileTrackingDetail({
    super.key,
    required this.preference,
    required this.controller,
    required this.moviesOnly,
  });
  final TrackPreference preference;
  final TabController controller;
  final bool moviesOnly;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final types = [if (!moviesOnly) ItemType.manga, ItemType.anime];
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            preference.syncId == -1
                ? l10n.local
                : trackInfos(preference.syncId!).$2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          bottom: TabBar(
            controller: controller,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              for (final type in types)
                Tab(
                  height: math.max(
                    48,
                    MediaQuery.textScalerOf(context).scale(16) * 1.4 + 24,
                  ),
                  text: type == ItemType.manga ? l10n.manga : l10n.anime,
                ),
            ],
          ),
        ),
        body: SafeArea(
          top: false,
          child: TabBarView(
            controller: controller,
            children: [
              for (final type in types)
                MobileTrackingEntries(
                  key: ValueKey((preference.syncId, type)),
                  syncId: preference.syncId!,
                  itemType: type,
                  accountName: preference.accountLabel,
                  load: () => trackRepository.watchByItemTypeAndSyncId(
                    type,
                    preference.syncId!,
                  ),
                  editorBuilder: (_, track) => TrackerWidget(
                    key: ValueKey((track.syncId, track.mediaId, track.mangaId)),
                    itemType: type,
                    syncId: preference.syncId!,
                    mangaId: track.mangaId!,
                    trackRes: track,
                    hide: true,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One stable local subscription per media tab. Expanding a row uses that
/// service's representative record, without another query by shared media ID.
class MobileTrackingEntries extends StatefulWidget {
  const MobileTrackingEntries({
    super.key,
    required this.syncId,
    required this.itemType,
    required this.load,
    required this.editorBuilder,
    this.accountName,
  });
  final int syncId;
  final ItemType itemType;
  final String? accountName;
  final Stream<List<Track>> Function() load;
  final Widget Function(BuildContext, Track) editorBuilder;

  @override
  State<MobileTrackingEntries> createState() => _MobileTrackingEntriesState();
}

class _MobileTrackingEntriesState extends State<MobileTrackingEntries>
    with AutomaticKeepAliveClientMixin {
  late Stream<List<Track>> _entries;
  final _search = TextEditingController();
  String _query = '';
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _entries = widget.load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clear() {
    _search.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return StreamBuilder<List<Track>>(
      stream: _entries,
      builder: (context, snapshot) {
        final byMedia = <int, Track>{};
        for (final track in snapshot.data ?? const <Track>[]) {
          if (track.syncId == widget.syncId &&
              track.itemType == widget.itemType &&
              track.mediaId != null) {
            final previous = byMedia[track.mediaId];
            if (previous == null ||
                (previous.mangaId == null && track.mangaId != null)) {
              byMedia[track.mediaId!] = track;
            }
          }
        }
        final records = byMedia.values
            .where(
              (track) => (track.title ?? '').toLowerCase().contains(
                _query.trim().toLowerCase(),
              ),
            )
            .toList();
        return CustomScrollView(
          key: PageStorageKey((
            'tracking-entries',
            widget.syncId,
            widget.itemType,
          )),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.accountName != null) ...[
                      Text(
                        widget.accountName!,
                        style: TextStyle(color: colors.muted),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Semantics(
                      label: l10n.search,
                      child: TextField(
                        controller: _search,
                        onChanged: (value) => setState(() => _query = value),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          hintText: l10n.search,
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _query.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: l10n.reset,
                                  onPressed: _clear,
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
                  ],
                ),
              ),
            ),
            if (snapshot.connectionState == ConnectionState.waiting)
              const SliverToBoxAdapter(child: LinearProgressIndicator())
            else if (snapshot.hasError)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(l10n.failed),
                      TextButton(
                        onPressed: () =>
                            setState(() => _entries = widget.load()),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              )
            else if (records.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        _query.trim().isEmpty
                            ? l10n.tracking_entries_empty
                            : l10n.no_result,
                      ),
                      if (_query.isNotEmpty)
                        TextButton(onPressed: _clear, child: Text(l10n.reset)),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final track = records[index];
                    return MobileSettingsGroup(
                      children: [
                        ExpansionTile(
                          key: PageStorageKey((
                            'tracked-entry',
                            widget.syncId,
                            widget.itemType,
                            track.mediaId,
                          )),
                          shape: const Border(),
                          collapsedShape: const Border(),
                          title: Text(track.title ?? l10n.unknown),
                          subtitle: Text(
                            getTrackStatus(
                              toTrackStatus(
                                track.status,
                                widget.itemType,
                                widget.syncId,
                              ),
                              context,
                            ),
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            12,
                            0,
                            12,
                            0,
                          ),
                          children: [
                            if (track.mangaId == null)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(l10n.tracking_entry_unlinked),
                              )
                            else
                              widget.editorBuilder(context, track),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
