import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'reader_state_provider.g.dart';

@riverpod
class FullScreenReaderState extends _$FullScreenReaderState {
  @override
  bool build() {
    return settingsRepository.current.fullScreenReader ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.fullScreenReader = value);
  }
}

@riverpod
class NavigationOrderState extends _$NavigationOrderState {
  final items = [
    '/MangaLibrary',
    '/AnimeLibrary',
    '/NovelLibrary',
    '/updates',
    '/browse',
    '/browser',
    '/more',
    '/trackerLibrary',
  ];

  @override
  List<String> build() {
    return _checkMissingItems(
      settingsRepository.current.navigationOrder?.toList() ?? [],
    );
  }

  List<String> _checkMissingItems(List<String> navigationOrder) {
    navigationOrder.removeWhere(
      (route) => route == '/history' || !items.contains(route),
    );
    if (!navigationOrder.contains('/browser') &&
        navigationOrder.contains('/browse')) {
      navigationOrder.insert(
        navigationOrder.indexOf('/browse') + 1,
        '/browser',
      );
    }
    navigationOrder.addAll(
      items.where((e) => !navigationOrder.contains(e)).toList(),
    );
    return navigationOrder;
  }

  void set(List<String> values) {
    state = values;
    settingsRepository.update((s) => s.navigationOrder = values);
  }
}

@riverpod
class HideItemsState extends _$HideItemsState {
  @override
  List<String> build() {
    return settingsRepository.current.hideItems ?? ['/trackerLibrary'];
  }

  void set(List<String> values) {
    state = values;
    settingsRepository.update((s) => s.hideItems = values);
  }
}

@riverpod
class MergeLibraryNavMobileState extends _$MergeLibraryNavMobileState {
  @override
  bool build() {
    return settingsRepository.current.mergeLibraryNavMobile ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.mergeLibraryNavMobile = value);
  }
}

@riverpod
class NovelFontSizeState extends _$NovelFontSizeState {
  @override
  int build() {
    return settingsRepository.current.novelFontSize ?? 14;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.novelFontSize = value);
  }
}

@riverpod
class NovelTextAlignState extends _$NovelTextAlignState {
  @override
  NovelTextAlign build() {
    return settingsRepository.current.novelTextAlign;
  }

  void set(NovelTextAlign value) {
    state = value;
    settingsRepository.update((s) => s.novelTextAlign = value);
  }
}

@riverpod
class NovelReaderThemeState extends _$NovelReaderThemeState {
  @override
  String build() {
    return settingsRepository.current.novelReaderTheme ?? '#292832';
  }

  void set(String value) {
    state = value;
    settingsRepository.update((s) => s.novelReaderTheme = value);
  }
}

@riverpod
class NovelReaderTextColorState extends _$NovelReaderTextColorState {
  @override
  String build() {
    return settingsRepository.current.novelReaderTextColor ?? '#CCCCCC';
  }

  void set(String value) {
    state = value;
    settingsRepository.update((s) => s.novelReaderTextColor = value);
  }
}

@riverpod
class NovelReaderPaddingState extends _$NovelReaderPaddingState {
  @override
  int build() {
    return settingsRepository.current.novelReaderPadding ?? 16;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.novelReaderPadding = value);
  }
}

@riverpod
class NovelReaderLineHeightState extends _$NovelReaderLineHeightState {
  @override
  double build() {
    return settingsRepository.current.novelReaderLineHeight ?? 1.5;
  }

  void set(double value) {
    state = value;
    settingsRepository.update((s) => s.novelReaderLineHeight = value);
  }
}

@riverpod
class NovelFontFamilyState extends _$NovelFontFamilyState {
  @override
  String? build() {
    return settingsRepository.current.novelFontFamily;
  }

  void set(String? value) {
    state = value;
    settingsRepository.update((s) => s.novelFontFamily = value);
  }
}

@riverpod
class NovelShowScrollPercentageState extends _$NovelShowScrollPercentageState {
  @override
  bool build() {
    return settingsRepository.current.novelShowScrollPercentage ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.novelShowScrollPercentage = value);
  }
}

@riverpod
class NovelRemoveExtraParagraphSpacingState
    extends _$NovelRemoveExtraParagraphSpacingState {
  @override
  bool build() {
    return settingsRepository.current.novelRemoveExtraParagraphSpacing ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update(
      (s) => s.novelRemoveExtraParagraphSpacing = value,
    );
  }
}

@riverpod
class NovelTapToScrollState extends _$NovelTapToScrollState {
  @override
  bool build() {
    return settingsRepository.current.novelTapToScroll ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.novelTapToScroll = value);
  }
}

@riverpod
class KeepScreenOnReaderState extends _$KeepScreenOnReaderState {
  @override
  bool build() {
    return settingsRepository.current.keepScreenOnReader ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.keepScreenOnReader = value);
  }
}

@riverpod
class AutoReadDuplicateChaptersState extends _$AutoReadDuplicateChaptersState {
  @override
  bool build() {
    return settingsRepository.current.autoReadDuplicateChapters ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.autoReadDuplicateChapters = value);
  }
}

@riverpod
class TtsSpeechRateState extends _$TtsSpeechRateState {
  @override
  double build() {
    return settingsRepository.current.ttsSpeechRate ?? 0.5;
  }

  void set(double value) {
    state = value;
    settingsRepository.update((s) => s.ttsSpeechRate = value);
  }
}

@riverpod
class TtsPitchState extends _$TtsPitchState {
  @override
  double build() {
    return settingsRepository.current.ttsPitch ?? 1.0;
  }

  void set(double value) {
    state = value;
    settingsRepository.update((s) => s.ttsPitch = value);
  }
}

@riverpod
class TtsLanguageState extends _$TtsLanguageState {
  @override
  String? build() {
    return settingsRepository.current.ttsLanguage;
  }

  void set(String? value) {
    state = value;
    settingsRepository.update((s) => s.ttsLanguage = value);
  }
}

@riverpod
class TtsVoiceState extends _$TtsVoiceState {
  @override
  String? build() {
    return settingsRepository.current.ttsVoice;
  }

  void set(String? value) {
    state = value;
    settingsRepository.update((s) => s.ttsVoice = value);
  }
}

@riverpod
class DoublePageAutoState extends _$DoublePageAutoState {
  @override
  bool build() {
    return settingsRepository.current.doublePageAuto ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.doublePageAuto = value);
  }
}

@riverpod
class ChapterSwipeStartActionState extends _$ChapterSwipeStartActionState {
  @override
  ChapterSwipeAction build() {
    final idx = settingsRepository.current.chapterSwipeStartAction ?? 0;
    if (idx >= 0 && idx < ChapterSwipeAction.values.length) {
      return ChapterSwipeAction.values[idx];
    }
    return ChapterSwipeAction.toggleBookmark;
  }

  void set(ChapterSwipeAction value) {
    state = value;
    settingsRepository.update((s) => s.chapterSwipeStartAction = value.index);
  }
}

@riverpod
class ChapterSwipeEndActionState extends _$ChapterSwipeEndActionState {
  @override
  ChapterSwipeAction build() {
    final idx = settingsRepository.current.chapterSwipeEndAction ?? 1;
    if (idx >= 0 && idx < ChapterSwipeAction.values.length) {
      return ChapterSwipeAction.values[idx];
    }
    return ChapterSwipeAction.toggleRead;
  }

  void set(ChapterSwipeAction value) {
    state = value;
    settingsRepository.update((s) => s.chapterSwipeEndAction = value.index);
  }
}
