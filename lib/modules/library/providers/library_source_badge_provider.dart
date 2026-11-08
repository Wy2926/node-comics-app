import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

/// Whether to show the source name as a badge on library covers. On by default.
/// Persisted on the Settings collection.
final librarySourceBadgeProvider = NotifierProvider<LibrarySourceBadge, bool>(
  LibrarySourceBadge.new,
);

class LibrarySourceBadge extends Notifier<bool> {
  @override
  bool build() => settingsRepository.current.showSourceBadge ?? true;

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.showSourceBadge = value);
  }
}
