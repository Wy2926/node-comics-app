import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/mixins/chapter_controller_mixin.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

/// Shared reader-specific settings and actions for a [Chapter].
///
/// This mixin builds on top of [ChapterControllerMixin] and provides:
/// - bookmark toggling
/// - auto-scroll preferences
///
/// It is intended for reader-like controllers (manga/novel), not anime.
///
/// Classes using this mixin may override [onSettingsMutated] to react to
/// settings changes (e.g. invalidate caches).
mixin ChapterReaderSettingsMixin on ChapterControllerMixin {
  // ---------------------------------------------------------------------------
  // Hooks
  // ---------------------------------------------------------------------------

  /// Called after any settings mutation (e.g. [setAutoScroll], [setReaderMode],
  /// [setPageMode], [setShowPageNumber], [setPageIndex]).
  ///
  /// Default is a no-op. Controllers can override this to invalidate caches
  /// or trigger updates when settings change.
  @protected
  void onSettingsMutated() {}

  // ---------------------------------------------------------------------------
  // Bookmarks
  // ---------------------------------------------------------------------------

  /// Toggles the bookmark state of the current [chapter].
  ///
  /// Updates the persisted chapter and bumps its [updatedAt] timestamp.
  /// No-op in incognito mode.
  void setChapterBookmarked() {
    if (incognitoMode) return;
    final isBookmarked = getChapterBookmarked();
    final chap = chapter;
    chap.isBookmarked = !isBookmarked;
    chapterRepository.save(chap);
  }

  /// Returns whether the current [chapter] is bookmarked.
  ///
  /// Reads directly from the database to ensure consistency.
  bool getChapterBookmarked() {
    return chapterRepository.getById(chapter.id!).isBookmarked!;
  }

  // ---------------------------------------------------------------------------
  // Auto-scroll
  // ---------------------------------------------------------------------------

  /// Returns the auto-scroll configuration for the current manga.
  ///
  /// The tuple contains:
  /// - whether auto-scroll is enabled
  /// - the page offset (scroll speed / distance)
  ///
  /// Falls back to `(false, 10)` if no custom setting exists.
  (bool, double) autoScrollValues() {
    final autoScrollPagesList = getIsarSetting().autoScrollPages ?? [];
    final autoScrollPages = autoScrollPagesList.where(
      (element) => element.mangaId == getManga().id,
    );
    if (autoScrollPages.isNotEmpty) {
      return (
        autoScrollPages.first.autoScroll ?? false,
        autoScrollPages.first.pageOffset ?? 10,
      );
    }
    return (false, 10);
  }

  /// Persists auto-scroll settings for the current manga.
  ///
  /// Merges this manga's entry inside the existing settings write queue.
  /// Calls [onSettingsMutated] afterwards so
  /// controllers can react (e.g. invalidate cached settings).
  void setAutoScroll(bool value, double offset) {
    final mangaId = getManga().id;
    settingsRepository.update((settings) {
      settings.autoScrollPages = [
        for (final entry in settings.autoScrollPages ?? <AutoScrollPages>[])
          if (entry.mangaId != mangaId) entry,
        AutoScrollPages()
          ..mangaId = mangaId
          ..pageOffset = offset
          ..autoScroll = value,
      ];
    });
    onSettingsMutated();
  }

  // ---------------------------------------------------------------------------
  // Page mode
  // ---------------------------------------------------------------------------

  /// Returns the configured [PageMode] for the current manga / novel.
  ///
  /// Falls back to [PageMode.onePage] if no custom setting exists.
  PageMode getPageMode() {
    final personalPageModeList = getIsarSetting().personalPageModeList ?? [];
    final personalPageMode = personalPageModeList.where(
      (element) => element.mangaId == getManga().id,
    );
    if (personalPageMode.isNotEmpty) {
      return personalPageMode.first.pageMode;
    }
    return PageMode.onePage;
  }

  /// Persists the [PageMode] for the current manga / novel.
  void setPageMode(PageMode newPageMode) {
    final mangaId = getManga().id;
    settingsRepository.update((settings) {
      settings.personalPageModeList = [
        for (final entry
            in settings.personalPageModeList ?? <PersonalPageMode>[])
          if (entry.mangaId != mangaId) entry,
        PersonalPageMode(mangaId: mangaId, pageMode: newPageMode),
      ];
    });
    onSettingsMutated();
  }
}
