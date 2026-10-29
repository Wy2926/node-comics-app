import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_widget.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/constant.dart';

class MobileTrackingMenu extends StatelessWidget {
  const MobileTrackingMenu({
    super.key,
    required this.manga,
    required this.accounts,
  });
  final Manga manga;
  final List<TrackPreference> accounts;

  @override
  Widget build(BuildContext context) => NodeLaneSurface(
    child: Scaffold(
      appBar: AppBar(title: Text(context.l10n.tracking)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              manga.name ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            if (accounts.isEmpty) Text(context.l10n.tracking_accounts_empty),
            for (final account in accounts)
              _TrackedAccount(
                key: ValueKey(account.syncId),
                manga: manga,
                syncId: account.syncId!,
              ),
          ],
        ),
      ),
    ),
  );
}

class _TrackedAccount extends ConsumerStatefulWidget {
  const _TrackedAccount({super.key, required this.manga, required this.syncId});
  final Manga manga;
  final int syncId;
  @override
  ConsumerState<_TrackedAccount> createState() => _TrackedAccountState();
}

class _TrackedAccountState extends ConsumerState<_TrackedAccount> {
  late Stream<List<Track>> _entries;
  bool _busy = false, _failed = false;

  @override
  void initState() {
    super.initState();
    _entries = _load();
  }

  Stream<List<Track>> _load() =>
      trackRepository.watchBySyncIdAndMangaId(widget.syncId, widget.manga.id!);

  Future<void> _add() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      final selected = await trackersSearchDraggableMenu(
        context,
        itemType: widget.manga.itemType,
        track: Track(
          status: TrackStatus.planToRead,
          syncId: widget.syncId,
          title: widget.manga.name,
        ),
      ) as TrackSearch?;
      if (!mounted || selected == null) return;
      await ref
          .read(
            trackStateProvider(
              track: null,
              itemType: widget.manga.itemType,
              widgetRef: ref,
            ).notifier,
          )
          .setTrackSearch(selected, widget.manga.id!, widget.syncId);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: StreamBuilder<List<Track>>(
      stream: _entries,
      builder: (context, snapshot) {
        final track = snapshot.data?.firstOrNull;
        if (track != null) {
          return TrackerWidget(
            key: ValueKey((widget.syncId, track.mediaId, widget.manga.id)),
            itemType: widget.manga.itemType,
            syncId: widget.syncId,
            trackRes: track,
            mangaId: widget.manga.id!,
          );
        }
        return MobileSettingsGroup(
          title: trackInfos(widget.syncId).$2,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      _busy)
                    const LinearProgressIndicator()
                  else if (snapshot.hasError) ...[
                    Text(context.l10n.failed),
                    TextButton(
                      onPressed: () => setState(() => _entries = _load()),
                      child: Text(context.l10n.retry),
                    ),
                  ] else ...[
                    if (_failed) Text(context.l10n.failed),
                    OutlinedButton.icon(
                      onPressed: _add,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(context.l10n.add_tracker),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}
