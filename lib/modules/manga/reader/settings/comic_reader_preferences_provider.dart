import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

import 'comic_reader_preferences.dart';

final comicReaderPreferencesProvider =
    NotifierProvider<ComicReaderPreferencesController, ComicReaderPreferences>(
      ComicReaderPreferencesController.new,
    );

class ComicReaderPreferencesController
    extends Notifier<ComicReaderPreferences> {
  @override
  bool updateShouldNotify(
    ComicReaderPreferences previous,
    ComicReaderPreferences next,
  ) => previous.encode() != next.encode();

  @override
  ComicReaderPreferences build() {
    final subscription = settingsRepository
        .watch()
        .map((settings) => settings.comicReaderPreferences)
        .distinct()
        .listen((value) {
          state = ComicReaderPreferences.decode(value);
        });
    ref.onDispose(subscription.cancel);
    return ComicReaderPreferences.decode(
      settingsRepository.current.comicReaderPreferences,
    );
  }

  /// Apply the edit to the latest persisted value inside the shared write queue.
  /// Book edits cannot overwrite another book or concurrent global edits.
  Future<void> update(
    ComicReaderPreferences Function(ComicReaderPreferences) edit,
  ) async {
    late ComicReaderPreferences saved;
    await settingsRepository.update((settings) {
      saved = edit(
        ComicReaderPreferences.decode(settings.comicReaderPreferences),
      );
      settings.comicReaderPreferences = saved.encode();
    });
    state = saved;
  }
}
