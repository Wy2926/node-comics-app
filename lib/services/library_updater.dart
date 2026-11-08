import 'package:mangayomi/modules/updates/update_errors_screen.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/more/settings/security/providers/security_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/update_errors_provider.dart';

/// Tracks whether a library update is running and lets the UI request its
/// cancellation. The update loop checks [LibraryUpdateState.cancelRequested]
/// between entries and stops early.
class LibraryUpdateState {
  final bool running;
  final bool cancelRequested;
  final int done, total;
  const LibraryUpdateState({
    this.running = false,
    this.cancelRequested = false,
    this.done = 0,
    this.total = 0,
  });
  LibraryUpdateState copyWith({
    bool? running,
    bool? cancelRequested,
    int? done,
    int? total,
  }) => LibraryUpdateState(
    running: running ?? this.running,
    cancelRequested: cancelRequested ?? this.cancelRequested,
    done: done ?? this.done,
    total: total ?? this.total,
  );
}

class LibraryUpdateNotifier extends Notifier<LibraryUpdateState> {
  @override
  LibraryUpdateState build() => const LibraryUpdateState();
  void begin({int total = 0}) =>
      state = LibraryUpdateState(running: true, total: total);
  void progress(int done, int total) =>
      state = state.copyWith(done: done, total: total);
  void requestCancel() {
    if (state.running) state = state.copyWith(cancelRequested: true);
  }

  void end() => state = const LibraryUpdateState();
}

final libraryUpdateProvider =
    NotifierProvider<LibraryUpdateNotifier, LibraryUpdateState>(
      LibraryUpdateNotifier.new,
    );

/// Refreshes every entry in [mangaList], reporting progress through
/// [onProgress] rather than touching the UI, so the same loop can run both
/// behind the library's update button and unattended on launch. The app-owned
/// container keeps the task alive when the initiating page or notice closes.
///
/// Returns the entries that failed. Honours the Stop button: the caller has
/// already marked the run as started, and this checks for a cancellation
/// between entries.
Future<List<UpdateError>> _runUpdate({
  required ProviderContainer container,
  required List<Manga> mangaList,
  required String itemtype,
  void Function(int done, int total)? onProgress,
}) async {
  final failures = <UpdateError>[];
  for (var i = 0; i < mangaList.length; i++) {
    // Stop early if the user pressed Stop.
    if (container.read(libraryUpdateProvider).cancelRequested) break;
    final manga = mangaList[i];
    try {
      await container.read(
        updateMangaDetailProvider(
          mangaId: manga.id,
          isInit: false,
          showToast: false,
        ).future,
      );
    } catch (e) {
      AppLogger.log("Failed to update $itemtype:", logLevel: LogLevel.error);
      AppLogger.log(e.toString(), logLevel: LogLevel.error);
      failures.add(
        UpdateError(
          mangaId: manga.id!,
          name: manga.name ?? "Unknown $itemtype",
          error: e.toString(),
        ),
      );
    }
    container
        .read(libraryUpdateProvider.notifier)
        .progress(i + 1, mangaList.length);
    onProgress?.call(i + 1, mangaList.length);
  }
  return failures;
}

Future<void> updateLibrary({
  required WidgetRef ref,
  required BuildContext context,
  required List<Manga> mangaList,
  required ItemType itemType,
  bool showProgressNotice = true,
}) async {
  final container = ProviderScope.containerOf(ref.context, listen: false);
  if (mangaList.isEmpty || container.read(libraryUpdateProvider).running) {
    return;
  }
  final l10n = context.l10n;
  final notifier = container.read(libraryUpdateProvider.notifier);
  notifier.begin(total: mangaList.length);
  final notice = showProgressNotice
      ? showNodeLaneNotice(
          l10n.notice_library_updating,
          description: l10n.notice_library_progress(0, mangaList.length),
          kind: NodeLaneNoticeKind.progress,
          progress: 0,
        )
      : null;
  try {
    final failures = await _runUpdate(
      container: container,
      mangaList: mangaList,
      itemtype: itemType.name,
      onProgress: (done, total) => notice?.update(
        l10n.notice_library_updating,
        description: l10n.notice_library_progress(done, total),
        progress: total == 0 ? 0 : done / total,
      ),
    );
    container.read(updateErrorsProvider.notifier).set(failures);
    notice?.dismiss();
    if (context.mounted && failures.isNotEmpty && showProgressNotice) {
      showNodeLaneNotice(
        l10n.notice_library_failed,
        kind: NodeLaneNoticeKind.error,
        actionLabel: l10n.update_errors,
        onAction: () {
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const UpdateErrorsScreen(),
              ),
            );
          }
        },
      );
    }
  } finally {
    notice?.dismiss();
    notifier.end();
  }
}

/// The refresh intervals offered in settings, in hours. 0 means never.
const libraryUpdateIntervals = <int>[0, 12, 24, 48, 168];

/// Whether a scheduled refresh is due, given the configured [intervalHours]
/// (0 meaning never), when the last one started, and the current time. All
/// times are epoch milliseconds.
///
/// A library that has never refreshed automatically counts as due, so turning
/// the setting on runs one at the next opportunity rather than a day later.
bool isLibraryUpdateDue({
  required int intervalHours,
  required int? lastRun,
  required int now,
}) {
  if (intervalHours <= 0) return false;
  return now - (lastRun ?? 0) >= intervalHours * Duration.millisecondsPerHour;
}

/// Runs the scheduled library refresh when one is due, then records when it
/// started so the next launch knows to leave it alone.
///
/// This is deliberately quiet: it runs on launch, without anyone watching, so
/// it shows no progress toast and no failure dialog. What it does surface is
/// the same Stop button the manual update uses, and its failures land in the
/// Updates tab's error screen like any other run's.
Future<void> autoUpdateLibraryIfDue(WidgetRef ref) async {
  final container = ProviderScope.containerOf(ref.context, listen: false);
  // Behind the app lock, nothing should be happening yet. Checked before the
  // timestamp below is written, so a launch that stops at the lock screen
  // leaves the refresh due rather than burning the interval on it.
  if (!container.read(appUnlockedStateProvider)) return;

  final settings = settingsRepository.current;
  if (!isLibraryUpdateDue(
    intervalHours: settings.autoLibraryUpdateInterval ?? 0,
    lastRun: settings.lastAutoLibraryUpdate,
    now: DateTime.now().millisecondsSinceEpoch,
  )) {
    return;
  }

  // Never fight a run the user started themselves. Claimed here, before the
  // first await, so that a launch and a resume arriving together can't both
  // get past this check and start a run each.
  if (container.read(libraryUpdateProvider).running) return;
  container.read(libraryUpdateProvider.notifier).begin();

  try {
    if (settings.autoLibraryUpdateWifiOnly ?? true) {
      final connectivity = await Connectivity().checkConnectivity();
      final unmetered =
          connectivity.contains(ConnectivityResult.wifi) ||
          connectivity.contains(ConnectivityResult.ethernet);
      if (!unmetered) {
        AppLogger.log("Scheduled library update skipped: metered connection.");
        return;
      }
    }

    // Local archives have no source to refresh from, so they're left out.
    final entries = <Manga>[];
    for (final itemType in ItemType.values) {
      entries.addAll(
        await mangaRepository.getFavoritesNonLocalArchiveByItemType(itemType),
      );
    }
    if (entries.isEmpty) return;
    container.read(libraryUpdateProvider.notifier).progress(0, entries.length);

    // Stamped before the run rather than after: a run cut short by the app
    // closing shouldn't make every following launch start over. Nothing above
    // stamps, so a run that never starts stays due.
    await settingsRepository.update(
      (s) => s.lastAutoLibraryUpdate = DateTime.now().millisecondsSinceEpoch,
    );

    AppLogger.log(
      "Starting scheduled library update (${entries.length} entries)...",
    );
    final failures = await _runUpdate(
      container: container,
      mangaList: entries,
      itemtype: "Library",
    );
    container.read(updateErrorsProvider.notifier).set(failures);
    AppLogger.log(
      "Scheduled library update finished, ${failures.length} of "
      "${entries.length} failed.",
    );
  } finally {
    container.read(libraryUpdateProvider.notifier).end();
  }
}
