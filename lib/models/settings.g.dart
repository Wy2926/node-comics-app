// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsCollection on Isar {
  IsarCollection<Settings> get settings => this.collection();
}

const SettingsSchema = CollectionSchema(
  name: r'Settings',
  id: -8656046621518759136,
  properties: {
    r'algorithmWeights': PropertySchema(
      id: 0,
      name: r'algorithmWeights',
      type: IsarType.object,

      target: r'AlgorithmWeights',
    ),
    r'allowConcurrentDownloads': PropertySchema(
      id: 1,
      name: r'allowConcurrentDownloads',
      type: IsarType.bool,
    ),
    r'androidProxyServer': PropertySchema(
      id: 2,
      name: r'androidProxyServer',
      type: IsarType.string,
    ),
    r'aniSkipTimeoutLength': PropertySchema(
      id: 3,
      name: r'aniSkipTimeoutLength',
      type: IsarType.long,
    ),
    r'animeDisplayType': PropertySchema(
      id: 4,
      name: r'animeDisplayType',
      type: IsarType.byte,
      enumMap: _SettingsanimeDisplayTypeEnumValueMap,
    ),
    r'animeExtensionsRepo': PropertySchema(
      id: 5,
      name: r'animeExtensionsRepo',
      type: IsarType.objectList,

      target: r'Repo',
    ),
    r'animeGridSize': PropertySchema(
      id: 6,
      name: r'animeGridSize',
      type: IsarType.long,
    ),
    r'animeLibraryDownloadedChapters': PropertySchema(
      id: 7,
      name: r'animeLibraryDownloadedChapters',
      type: IsarType.bool,
    ),
    r'animeLibraryLocalSource': PropertySchema(
      id: 8,
      name: r'animeLibraryLocalSource',
      type: IsarType.bool,
    ),
    r'animeLibraryShowCategoryTabs': PropertySchema(
      id: 9,
      name: r'animeLibraryShowCategoryTabs',
      type: IsarType.bool,
    ),
    r'animeLibraryShowContinueReadingButton': PropertySchema(
      id: 10,
      name: r'animeLibraryShowContinueReadingButton',
      type: IsarType.bool,
    ),
    r'animeLibraryShowLanguage': PropertySchema(
      id: 11,
      name: r'animeLibraryShowLanguage',
      type: IsarType.bool,
    ),
    r'animeLibraryShowNumbersOfItems': PropertySchema(
      id: 12,
      name: r'animeLibraryShowNumbersOfItems',
      type: IsarType.bool,
    ),
    r'appFontFamily': PropertySchema(
      id: 13,
      name: r'appFontFamily',
      type: IsarType.string,
    ),
    r'appLockEnabled': PropertySchema(
      id: 14,
      name: r'appLockEnabled',
      type: IsarType.bool,
    ),
    r'appUiScale': PropertySchema(
      id: 15,
      name: r'appUiScale',
      type: IsarType.double,
    ),
    r'askDownloadDestination': PropertySchema(
      id: 16,
      name: r'askDownloadDestination',
      type: IsarType.bool,
    ),
    r'audioChannels': PropertySchema(
      id: 17,
      name: r'audioChannels',
      type: IsarType.byte,
      enumMap: _SettingsaudioChannelsEnumValueMap,
    ),
    r'audioPreferredLanguages': PropertySchema(
      id: 18,
      name: r'audioPreferredLanguages',
      type: IsarType.string,
    ),
    r'autoBackupLocation': PropertySchema(
      id: 19,
      name: r'autoBackupLocation',
      type: IsarType.string,
    ),
    r'autoExtensionsUpdates': PropertySchema(
      id: 20,
      name: r'autoExtensionsUpdates',
      type: IsarType.bool,
    ),
    r'autoLibraryUpdateInterval': PropertySchema(
      id: 21,
      name: r'autoLibraryUpdateInterval',
      type: IsarType.long,
    ),
    r'autoLibraryUpdateWifiOnly': PropertySchema(
      id: 22,
      name: r'autoLibraryUpdateWifiOnly',
      type: IsarType.bool,
    ),
    r'autoPlayNextEpisode': PropertySchema(
      id: 23,
      name: r'autoPlayNextEpisode',
      type: IsarType.bool,
    ),
    r'autoReadDuplicateChapters': PropertySchema(
      id: 24,
      name: r'autoReadDuplicateChapters',
      type: IsarType.bool,
    ),
    r'autoScrollPages': PropertySchema(
      id: 25,
      name: r'autoScrollPages',
      type: IsarType.objectList,

      target: r'AutoScrollPages',
    ),
    r'autoStartExtensionServerOnLaunch': PropertySchema(
      id: 26,
      name: r'autoStartExtensionServerOnLaunch',
      type: IsarType.bool,
    ),
    r'backupCompressionLevel': PropertySchema(
      id: 27,
      name: r'backupCompressionLevel',
      type: IsarType.long,
    ),
    r'backupEncryptionEnabled': PropertySchema(
      id: 28,
      name: r'backupEncryptionEnabled',
      type: IsarType.bool,
    ),
    r'backupFrequency': PropertySchema(
      id: 29,
      name: r'backupFrequency',
      type: IsarType.long,
    ),
    r'backupListOptions': PropertySchema(
      id: 30,
      name: r'backupListOptions',
      type: IsarType.longList,
    ),
    r'btServerAddress': PropertySchema(
      id: 31,
      name: r'btServerAddress',
      type: IsarType.string,
    ),
    r'btServerPort': PropertySchema(
      id: 32,
      name: r'btServerPort',
      type: IsarType.long,
    ),
    r'cfProxyUrl': PropertySchema(
      id: 33,
      name: r'cfProxyUrl',
      type: IsarType.string,
    ),
    r'chapterFilterBookmarkedList': PropertySchema(
      id: 34,
      name: r'chapterFilterBookmarkedList',
      type: IsarType.objectList,

      target: r'ChapterFilterBookmarked',
    ),
    r'chapterFilterDownloadedList': PropertySchema(
      id: 35,
      name: r'chapterFilterDownloadedList',
      type: IsarType.objectList,

      target: r'ChapterFilterDownloaded',
    ),
    r'chapterFilterUnreadList': PropertySchema(
      id: 36,
      name: r'chapterFilterUnreadList',
      type: IsarType.objectList,

      target: r'ChapterFilterUnread',
    ),
    r'chapterPageIndexList': PropertySchema(
      id: 37,
      name: r'chapterPageIndexList',
      type: IsarType.objectList,

      target: r'ChapterPageIndex',
    ),
    r'chapterSwipeEndAction': PropertySchema(
      id: 38,
      name: r'chapterSwipeEndAction',
      type: IsarType.long,
    ),
    r'chapterSwipeStartAction': PropertySchema(
      id: 39,
      name: r'chapterSwipeStartAction',
      type: IsarType.long,
    ),
    r'checkForAppUpdates': PropertySchema(
      id: 40,
      name: r'checkForAppUpdates',
      type: IsarType.bool,
    ),
    r'checkForExtensionUpdates': PropertySchema(
      id: 41,
      name: r'checkForExtensionUpdates',
      type: IsarType.bool,
    ),
    r'clearChapterCacheOnAppLaunch': PropertySchema(
      id: 42,
      name: r'clearChapterCacheOnAppLaunch',
      type: IsarType.bool,
    ),
    r'comicReaderPreferences': PropertySchema(
      id: 43,
      name: r'comicReaderPreferences',
      type: IsarType.string,
    ),
    r'concurrentDownloads': PropertySchema(
      id: 44,
      name: r'concurrentDownloads',
      type: IsarType.long,
    ),
    r'cookiesList': PropertySchema(
      id: 45,
      name: r'cookiesList',
      type: IsarType.objectList,

      target: r'MCookie',
    ),
    r'customDns': PropertySchema(
      id: 46,
      name: r'customDns',
      type: IsarType.string,
    ),
    r'customDohUrl': PropertySchema(
      id: 47,
      name: r'customDohUrl',
      type: IsarType.string,
    ),
    r'dateFormat': PropertySchema(
      id: 48,
      name: r'dateFormat',
      type: IsarType.string,
    ),
    r'debandingType': PropertySchema(
      id: 49,
      name: r'debandingType',
      type: IsarType.byte,
      enumMap: _SettingsdebandingTypeEnumValueMap,
    ),
    r'defaultDoubleTapToSkipLength': PropertySchema(
      id: 50,
      name: r'defaultDoubleTapToSkipLength',
      type: IsarType.long,
    ),
    r'defaultPlayBackSpeed': PropertySchema(
      id: 51,
      name: r'defaultPlayBackSpeed',
      type: IsarType.double,
    ),
    r'defaultSkipIntroLength': PropertySchema(
      id: 52,
      name: r'defaultSkipIntroLength',
      type: IsarType.long,
    ),
    r'defaultSubtitleLang': PropertySchema(
      id: 53,
      name: r'defaultSubtitleLang',
      type: IsarType.object,

      target: r'L10nLocale',
    ),
    r'deleteDownloadAfterReading': PropertySchema(
      id: 54,
      name: r'deleteDownloadAfterReading',
      type: IsarType.bool,
    ),
    r'developerMode': PropertySchema(
      id: 55,
      name: r'developerMode',
      type: IsarType.bool,
    ),
    r'disableSectionType': PropertySchema(
      id: 56,
      name: r'disableSectionType',
      type: IsarType.byte,
      enumMap: _SettingsdisableSectionTypeEnumValueMap,
    ),
    r'displayType': PropertySchema(
      id: 57,
      name: r'displayType',
      type: IsarType.byte,
      enumMap: _SettingsdisplayTypeEnumValueMap,
    ),
    r'doHEnabled': PropertySchema(
      id: 58,
      name: r'doHEnabled',
      type: IsarType.bool,
    ),
    r'doHProviderId': PropertySchema(
      id: 59,
      name: r'doHProviderId',
      type: IsarType.long,
    ),
    r'doublePageAuto': PropertySchema(
      id: 60,
      name: r'doublePageAuto',
      type: IsarType.bool,
    ),
    r'downloadDelaySeconds': PropertySchema(
      id: 61,
      name: r'downloadDelaySeconds',
      type: IsarType.long,
    ),
    r'downloadLocalFolderName': PropertySchema(
      id: 62,
      name: r'downloadLocalFolderName',
      type: IsarType.string,
    ),
    r'downloadLocation': PropertySchema(
      id: 63,
      name: r'downloadLocation',
      type: IsarType.string,
    ),
    r'downloadOnlyOnWifi': PropertySchema(
      id: 64,
      name: r'downloadOnlyOnWifi',
      type: IsarType.bool,
    ),
    r'downloadQueueOrder': PropertySchema(
      id: 65,
      name: r'downloadQueueOrder',
      type: IsarType.longList,
    ),
    r'downloadedOnlyMode': PropertySchema(
      id: 66,
      name: r'downloadedOnlyMode',
      type: IsarType.bool,
    ),
    r'enableAniSkip': PropertySchema(
      id: 67,
      name: r'enableAniSkip',
      type: IsarType.bool,
    ),
    r'enableAudioPitchCorrection': PropertySchema(
      id: 68,
      name: r'enableAudioPitchCorrection',
      type: IsarType.bool,
    ),
    r'enableAutoSkip': PropertySchema(
      id: 69,
      name: r'enableAutoSkip',
      type: IsarType.bool,
    ),
    r'enableDiscordRpc': PropertySchema(
      id: 70,
      name: r'enableDiscordRpc',
      type: IsarType.bool,
    ),
    r'enableGpuNext': PropertySchema(
      id: 71,
      name: r'enableGpuNext',
      type: IsarType.bool,
    ),
    r'enableHardwareAcceleration': PropertySchema(
      id: 72,
      name: r'enableHardwareAcceleration',
      type: IsarType.bool,
    ),
    r'enableLogs': PropertySchema(
      id: 73,
      name: r'enableLogs',
      type: IsarType.bool,
    ),
    r'extensionServerPath': PropertySchema(
      id: 74,
      name: r'extensionServerPath',
      type: IsarType.string,
    ),
    r'filterScanlatorList': PropertySchema(
      id: 75,
      name: r'filterScanlatorList',
      type: IsarType.objectList,

      target: r'FilterScanlator',
    ),
    r'flexColorSchemeBlendLevel': PropertySchema(
      id: 76,
      name: r'flexColorSchemeBlendLevel',
      type: IsarType.double,
    ),
    r'flexSchemeColorIndex': PropertySchema(
      id: 77,
      name: r'flexSchemeColorIndex',
      type: IsarType.long,
    ),
    r'followSystemTheme': PropertySchema(
      id: 78,
      name: r'followSystemTheme',
      type: IsarType.bool,
    ),
    r'forceLandscapePlayer': PropertySchema(
      id: 79,
      name: r'forceLandscapePlayer',
      type: IsarType.bool,
    ),
    r'fullScreenPlayer': PropertySchema(
      id: 80,
      name: r'fullScreenPlayer',
      type: IsarType.bool,
    ),
    r'fullScreenReader': PropertySchema(
      id: 81,
      name: r'fullScreenReader',
      type: IsarType.bool,
    ),
    r'hideDiscordRpcInIncognito': PropertySchema(
      id: 82,
      name: r'hideDiscordRpcInIncognito',
      type: IsarType.bool,
    ),
    r'hideItems': PropertySchema(
      id: 83,
      name: r'hideItems',
      type: IsarType.stringList,
    ),
    r'hwdecMode': PropertySchema(
      id: 84,
      name: r'hwdecMode',
      type: IsarType.string,
    ),
    r'incognitoMode': PropertySchema(
      id: 85,
      name: r'incognitoMode',
      type: IsarType.bool,
    ),
    r'jrePath': PropertySchema(id: 86, name: r'jrePath', type: IsarType.string),
    r'keepScreenOnReader': PropertySchema(
      id: 87,
      name: r'keepScreenOnReader',
      type: IsarType.bool,
    ),
    r'lastAutoLibraryUpdate': PropertySchema(
      id: 88,
      name: r'lastAutoLibraryUpdate',
      type: IsarType.long,
    ),
    r'lastTrackerLibraryLocation': PropertySchema(
      id: 89,
      name: r'lastTrackerLibraryLocation',
      type: IsarType.string,
    ),
    r'libraryDownloadedChapters': PropertySchema(
      id: 90,
      name: r'libraryDownloadedChapters',
      type: IsarType.bool,
    ),
    r'libraryFilterAnimeBookMarkedType': PropertySchema(
      id: 91,
      name: r'libraryFilterAnimeBookMarkedType',
      type: IsarType.long,
    ),
    r'libraryFilterAnimeCompletedType': PropertySchema(
      id: 92,
      name: r'libraryFilterAnimeCompletedType',
      type: IsarType.long,
    ),
    r'libraryFilterAnimeDownloadType': PropertySchema(
      id: 93,
      name: r'libraryFilterAnimeDownloadType',
      type: IsarType.long,
    ),
    r'libraryFilterAnimeSourceIds': PropertySchema(
      id: 94,
      name: r'libraryFilterAnimeSourceIds',
      type: IsarType.stringList,
    ),
    r'libraryFilterAnimeStartedType': PropertySchema(
      id: 95,
      name: r'libraryFilterAnimeStartedType',
      type: IsarType.long,
    ),
    r'libraryFilterAnimeTrackingType': PropertySchema(
      id: 96,
      name: r'libraryFilterAnimeTrackingType',
      type: IsarType.long,
    ),
    r'libraryFilterAnimeUnreadType': PropertySchema(
      id: 97,
      name: r'libraryFilterAnimeUnreadType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasBookMarkedType': PropertySchema(
      id: 98,
      name: r'libraryFilterMangasBookMarkedType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasCompletedType': PropertySchema(
      id: 99,
      name: r'libraryFilterMangasCompletedType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasDownloadType': PropertySchema(
      id: 100,
      name: r'libraryFilterMangasDownloadType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasSourceIds': PropertySchema(
      id: 101,
      name: r'libraryFilterMangasSourceIds',
      type: IsarType.stringList,
    ),
    r'libraryFilterMangasStartedType': PropertySchema(
      id: 102,
      name: r'libraryFilterMangasStartedType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasTrackingType': PropertySchema(
      id: 103,
      name: r'libraryFilterMangasTrackingType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasUnreadType': PropertySchema(
      id: 104,
      name: r'libraryFilterMangasUnreadType',
      type: IsarType.long,
    ),
    r'libraryFilterNovelBookMarkedType': PropertySchema(
      id: 105,
      name: r'libraryFilterNovelBookMarkedType',
      type: IsarType.long,
    ),
    r'libraryFilterNovelCompletedType': PropertySchema(
      id: 106,
      name: r'libraryFilterNovelCompletedType',
      type: IsarType.long,
    ),
    r'libraryFilterNovelDownloadType': PropertySchema(
      id: 107,
      name: r'libraryFilterNovelDownloadType',
      type: IsarType.long,
    ),
    r'libraryFilterNovelSourceIds': PropertySchema(
      id: 108,
      name: r'libraryFilterNovelSourceIds',
      type: IsarType.stringList,
    ),
    r'libraryFilterNovelStartedType': PropertySchema(
      id: 109,
      name: r'libraryFilterNovelStartedType',
      type: IsarType.long,
    ),
    r'libraryFilterNovelTrackingType': PropertySchema(
      id: 110,
      name: r'libraryFilterNovelTrackingType',
      type: IsarType.long,
    ),
    r'libraryFilterNovelUnreadType': PropertySchema(
      id: 111,
      name: r'libraryFilterNovelUnreadType',
      type: IsarType.long,
    ),
    r'libraryLocalSource': PropertySchema(
      id: 112,
      name: r'libraryLocalSource',
      type: IsarType.bool,
    ),
    r'libraryShowCategoryTabs': PropertySchema(
      id: 113,
      name: r'libraryShowCategoryTabs',
      type: IsarType.bool,
    ),
    r'libraryShowContinueReadingButton': PropertySchema(
      id: 114,
      name: r'libraryShowContinueReadingButton',
      type: IsarType.bool,
    ),
    r'libraryShowLanguage': PropertySchema(
      id: 115,
      name: r'libraryShowLanguage',
      type: IsarType.bool,
    ),
    r'libraryShowNumbersOfItems': PropertySchema(
      id: 116,
      name: r'libraryShowNumbersOfItems',
      type: IsarType.bool,
    ),
    r'localFolders': PropertySchema(
      id: 117,
      name: r'localFolders',
      type: IsarType.stringList,
    ),
    r'locale': PropertySchema(
      id: 118,
      name: r'locale',
      type: IsarType.object,

      target: r'L10nLocale',
    ),
    r'mangaExtensionsRepo': PropertySchema(
      id: 119,
      name: r'mangaExtensionsRepo',
      type: IsarType.objectList,

      target: r'Repo',
    ),
    r'mangaGridSize': PropertySchema(
      id: 120,
      name: r'mangaGridSize',
      type: IsarType.long,
    ),
    r'mangaHomeDisplayType': PropertySchema(
      id: 121,
      name: r'mangaHomeDisplayType',
      type: IsarType.byte,
      enumMap: _SettingsmangaHomeDisplayTypeEnumValueMap,
    ),
    r'markEpisodeAsSeenType': PropertySchema(
      id: 122,
      name: r'markEpisodeAsSeenType',
      type: IsarType.long,
    ),
    r'mergeLibraryNavMobile': PropertySchema(
      id: 123,
      name: r'mergeLibraryNavMobile',
      type: IsarType.bool,
    ),
    r'namedLocalFolders': PropertySchema(
      id: 124,
      name: r'namedLocalFolders',
      type: IsarType.objectList,

      target: r'LocalFolder',
    ),
    r'navigationOrder': PropertySchema(
      id: 125,
      name: r'navigationOrder',
      type: IsarType.stringList,
    ),
    r'novelDisplayType': PropertySchema(
      id: 126,
      name: r'novelDisplayType',
      type: IsarType.byte,
      enumMap: _SettingsnovelDisplayTypeEnumValueMap,
    ),
    r'novelExtensionsRepo': PropertySchema(
      id: 127,
      name: r'novelExtensionsRepo',
      type: IsarType.objectList,

      target: r'Repo',
    ),
    r'novelFontFamily': PropertySchema(
      id: 128,
      name: r'novelFontFamily',
      type: IsarType.string,
    ),
    r'novelFontSize': PropertySchema(
      id: 129,
      name: r'novelFontSize',
      type: IsarType.long,
    ),
    r'novelGridSize': PropertySchema(
      id: 130,
      name: r'novelGridSize',
      type: IsarType.long,
    ),
    r'novelLibraryDownloadedChapters': PropertySchema(
      id: 131,
      name: r'novelLibraryDownloadedChapters',
      type: IsarType.bool,
    ),
    r'novelLibraryLocalSource': PropertySchema(
      id: 132,
      name: r'novelLibraryLocalSource',
      type: IsarType.bool,
    ),
    r'novelLibraryShowCategoryTabs': PropertySchema(
      id: 133,
      name: r'novelLibraryShowCategoryTabs',
      type: IsarType.bool,
    ),
    r'novelLibraryShowContinueReadingButton': PropertySchema(
      id: 134,
      name: r'novelLibraryShowContinueReadingButton',
      type: IsarType.bool,
    ),
    r'novelLibraryShowLanguage': PropertySchema(
      id: 135,
      name: r'novelLibraryShowLanguage',
      type: IsarType.bool,
    ),
    r'novelLibraryShowNumbersOfItems': PropertySchema(
      id: 136,
      name: r'novelLibraryShowNumbersOfItems',
      type: IsarType.bool,
    ),
    r'novelReaderLineHeight': PropertySchema(
      id: 137,
      name: r'novelReaderLineHeight',
      type: IsarType.double,
    ),
    r'novelReaderPadding': PropertySchema(
      id: 138,
      name: r'novelReaderPadding',
      type: IsarType.long,
    ),
    r'novelReaderTextColor': PropertySchema(
      id: 139,
      name: r'novelReaderTextColor',
      type: IsarType.string,
    ),
    r'novelReaderTheme': PropertySchema(
      id: 140,
      name: r'novelReaderTheme',
      type: IsarType.string,
    ),
    r'novelRemoveExtraParagraphSpacing': PropertySchema(
      id: 141,
      name: r'novelRemoveExtraParagraphSpacing',
      type: IsarType.bool,
    ),
    r'novelShowScrollPercentage': PropertySchema(
      id: 142,
      name: r'novelShowScrollPercentage',
      type: IsarType.bool,
    ),
    r'novelTapToScroll': PropertySchema(
      id: 143,
      name: r'novelTapToScroll',
      type: IsarType.bool,
    ),
    r'novelTextAlign': PropertySchema(
      id: 144,
      name: r'novelTextAlign',
      type: IsarType.byte,
      enumMap: _SettingsnovelTextAlignEnumValueMap,
    ),
    r'onboardingCompleted': PropertySchema(
      id: 145,
      name: r'onboardingCompleted',
      type: IsarType.bool,
    ),
    r'onlyIncludePinnedSources': PropertySchema(
      id: 146,
      name: r'onlyIncludePinnedSources',
      type: IsarType.bool,
    ),
    r'personalPageModeList': PropertySchema(
      id: 147,
      name: r'personalPageModeList',
      type: IsarType.objectList,

      target: r'PersonalPageMode',
    ),
    r'personalReaderModeList': PropertySchema(
      id: 148,
      name: r'personalReaderModeList',
      type: IsarType.objectList,

      target: r'PersonalReaderMode',
    ),
    r'playerSubtitleSettings': PropertySchema(
      id: 149,
      name: r'playerSubtitleSettings',
      type: IsarType.object,

      target: r'PlayerSubtitleSettings',
    ),
    r'pureBlackDarkMode': PropertySchema(
      id: 150,
      name: r'pureBlackDarkMode',
      type: IsarType.bool,
    ),
    r'relativeTimesTamps': PropertySchema(
      id: 151,
      name: r'relativeTimesTamps',
      type: IsarType.long,
    ),
    r'rpcShowCoverImage': PropertySchema(
      id: 152,
      name: r'rpcShowCoverImage',
      type: IsarType.bool,
    ),
    r'rpcShowReadingWatchingProgress': PropertySchema(
      id: 153,
      name: r'rpcShowReadingWatchingProgress',
      type: IsarType.bool,
    ),
    r'rpcShowTitle': PropertySchema(
      id: 154,
      name: r'rpcShowTitle',
      type: IsarType.bool,
    ),
    r'saveAsCBZArchive': PropertySchema(
      id: 155,
      name: r'saveAsCBZArchive',
      type: IsarType.bool,
    ),
    r'savedSearchesList': PropertySchema(
      id: 156,
      name: r'savedSearchesList',
      type: IsarType.objectList,

      target: r'SavedSearch',
    ),
    r'showNSFW': PropertySchema(
      id: 157,
      name: r'showNSFW',
      type: IsarType.bool,
    ),
    r'showNavDoubleTapTooltip': PropertySchema(
      id: 158,
      name: r'showNavDoubleTapTooltip',
      type: IsarType.bool,
    ),
    r'showSourceBadge': PropertySchema(
      id: 159,
      name: r'showSourceBadge',
      type: IsarType.bool,
    ),
    r'sortChapterList': PropertySchema(
      id: 160,
      name: r'sortChapterList',
      type: IsarType.objectList,

      target: r'SortChapter',
    ),
    r'sortLibraryAnime': PropertySchema(
      id: 161,
      name: r'sortLibraryAnime',
      type: IsarType.object,

      target: r'SortLibraryManga',
    ),
    r'sortLibraryManga': PropertySchema(
      id: 162,
      name: r'sortLibraryManga',
      type: IsarType.object,

      target: r'SortLibraryManga',
    ),
    r'sortLibraryNovel': PropertySchema(
      id: 163,
      name: r'sortLibraryNovel',
      type: IsarType.object,

      target: r'SortLibraryManga',
    ),
    r'startDatebackup': PropertySchema(
      id: 164,
      name: r'startDatebackup',
      type: IsarType.long,
    ),
    r'themeIsDark': PropertySchema(
      id: 165,
      name: r'themeIsDark',
      type: IsarType.bool,
    ),
    r'ttsLanguage': PropertySchema(
      id: 166,
      name: r'ttsLanguage',
      type: IsarType.string,
    ),
    r'ttsPitch': PropertySchema(
      id: 167,
      name: r'ttsPitch',
      type: IsarType.double,
    ),
    r'ttsSpeechRate': PropertySchema(
      id: 168,
      name: r'ttsSpeechRate',
      type: IsarType.double,
    ),
    r'ttsVoice': PropertySchema(
      id: 169,
      name: r'ttsVoice',
      type: IsarType.string,
    ),
    r'tvAnimeOnlyOverride': PropertySchema(
      id: 170,
      name: r'tvAnimeOnlyOverride',
      type: IsarType.bool,
    ),
    r'tvHomeGenreRows': PropertySchema(
      id: 171,
      name: r'tvHomeGenreRows',
      type: IsarType.bool,
    ),
    r'tvHomeStyle': PropertySchema(
      id: 172,
      name: r'tvHomeStyle',
      type: IsarType.bool,
    ),
    r'tvPlayerStyle': PropertySchema(
      id: 173,
      name: r'tvPlayerStyle',
      type: IsarType.bool,
    ),
    r'updateErrorsList': PropertySchema(
      id: 174,
      name: r'updateErrorsList',
      type: IsarType.objectList,

      target: r'UpdateError',
    ),
    r'updateProgressAfterReading': PropertySchema(
      id: 175,
      name: r'updateProgressAfterReading',
      type: IsarType.bool,
    ),
    r'updatedAt': PropertySchema(
      id: 176,
      name: r'updatedAt',
      type: IsarType.long,
    ),
    r'useFloatingNavigationBar': PropertySchema(
      id: 177,
      name: r'useFloatingNavigationBar',
      type: IsarType.bool,
    ),
    r'useLibass': PropertySchema(
      id: 178,
      name: r'useLibass',
      type: IsarType.bool,
    ),
    r'useMpvConfig': PropertySchema(
      id: 179,
      name: r'useMpvConfig',
      type: IsarType.bool,
    ),
    r'useYUV420P': PropertySchema(
      id: 180,
      name: r'useYUV420P',
      type: IsarType.bool,
    ),
    r'userAgent': PropertySchema(
      id: 181,
      name: r'userAgent',
      type: IsarType.string,
    ),
    r'volumeBoostCap': PropertySchema(
      id: 182,
      name: r'volumeBoostCap',
      type: IsarType.long,
    ),
  },

  estimateSize: _settingsEstimateSize,
  serialize: _settingsSerialize,
  deserialize: _settingsDeserialize,
  deserializeProp: _settingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'sources': LinkSchema(
      id: 4350160784948077250,
      name: r'sources',
      target: r'Sources',
      single: false,
    ),
  },
  embeddedSchemas: {
    r'SortLibraryManga': SortLibraryMangaSchema,
    r'SortChapter': SortChapterSchema,
    r'ChapterFilterDownloaded': ChapterFilterDownloadedSchema,
    r'ChapterFilterUnread': ChapterFilterUnreadSchema,
    r'ChapterFilterBookmarked': ChapterFilterBookmarkedSchema,
    r'ChapterPageIndex': ChapterPageIndexSchema,
    r'MCookie': MCookieSchema,
    r'UpdateError': UpdateErrorSchema,
    r'SavedSearch': SavedSearchSchema,
    r'PersonalReaderMode': PersonalReaderModeSchema,
    r'FilterScanlator': FilterScanlatorSchema,
    r'L10nLocale': L10nLocaleSchema,
    r'PersonalPageMode': PersonalPageModeSchema,
    r'AutoScrollPages': AutoScrollPagesSchema,
    r'PlayerSubtitleSettings': PlayerSubtitleSettingsSchema,
    r'Repo': RepoSchema,
    r'AlgorithmWeights': AlgorithmWeightsSchema,
    r'LocalFolder': LocalFolderSchema,
  },

  getId: _settingsGetId,
  getLinks: _settingsGetLinks,
  attach: _settingsAttach,
  version: '3.3.2',
);

int _settingsEstimateSize(
  Settings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.algorithmWeights;
    if (value != null) {
      bytesCount +=
          3 +
          AlgorithmWeightsSchema.estimateSize(
            value,
            allOffsets[AlgorithmWeights]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.androidProxyServer;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.animeExtensionsRepo;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Repo]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += RepoSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.appFontFamily;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.audioPreferredLanguages;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.autoBackupLocation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.autoScrollPages;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[AutoScrollPages]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += AutoScrollPagesSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.backupListOptions;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.btServerAddress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cfProxyUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.chapterFilterBookmarkedList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ChapterFilterBookmarked]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += ChapterFilterBookmarkedSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.chapterFilterDownloadedList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ChapterFilterDownloaded]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += ChapterFilterDownloadedSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.chapterFilterUnreadList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ChapterFilterUnread]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += ChapterFilterUnreadSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.chapterPageIndexList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ChapterPageIndex]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += ChapterPageIndexSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.comicReaderPreferences;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.cookiesList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[MCookie]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += MCookieSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.customDns;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.customDohUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dateFormat;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.defaultSubtitleLang;
    if (value != null) {
      bytesCount +=
          3 +
          L10nLocaleSchema.estimateSize(
            value,
            allOffsets[L10nLocale]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.downloadLocalFolderName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.downloadLocation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.downloadQueueOrder;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.extensionServerPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.filterScanlatorList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[FilterScanlator]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += FilterScanlatorSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.hideItems;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.hwdecMode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.jrePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastTrackerLibraryLocation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.libraryFilterAnimeSourceIds;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.libraryFilterMangasSourceIds;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.libraryFilterNovelSourceIds;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.localFolders;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.locale;
    if (value != null) {
      bytesCount +=
          3 +
          L10nLocaleSchema.estimateSize(
            value,
            allOffsets[L10nLocale]!,
            allOffsets,
          );
    }
  }
  {
    final list = object.mangaExtensionsRepo;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Repo]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += RepoSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.namedLocalFolders;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[LocalFolder]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += LocalFolderSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.navigationOrder;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.novelExtensionsRepo;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Repo]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += RepoSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.novelFontFamily;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.novelReaderTextColor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.novelReaderTheme;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.personalPageModeList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[PersonalPageMode]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += PersonalPageModeSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.personalReaderModeList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[PersonalReaderMode]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += PersonalReaderModeSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.playerSubtitleSettings;
    if (value != null) {
      bytesCount +=
          3 +
          PlayerSubtitleSettingsSchema.estimateSize(
            value,
            allOffsets[PlayerSubtitleSettings]!,
            allOffsets,
          );
    }
  }
  {
    final list = object.savedSearchesList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[SavedSearch]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += SavedSearchSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.sortChapterList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[SortChapter]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += SortChapterSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.sortLibraryAnime;
    if (value != null) {
      bytesCount +=
          3 +
          SortLibraryMangaSchema.estimateSize(
            value,
            allOffsets[SortLibraryManga]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.sortLibraryManga;
    if (value != null) {
      bytesCount +=
          3 +
          SortLibraryMangaSchema.estimateSize(
            value,
            allOffsets[SortLibraryManga]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.sortLibraryNovel;
    if (value != null) {
      bytesCount +=
          3 +
          SortLibraryMangaSchema.estimateSize(
            value,
            allOffsets[SortLibraryManga]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.ttsLanguage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ttsVoice;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.updateErrorsList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[UpdateError]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += UpdateErrorSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.userAgent;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _settingsSerialize(
  Settings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<AlgorithmWeights>(
    offsets[0],
    allOffsets,
    AlgorithmWeightsSchema.serialize,
    object.algorithmWeights,
  );
  writer.writeBool(offsets[1], object.allowConcurrentDownloads);
  writer.writeString(offsets[2], object.androidProxyServer);
  writer.writeLong(offsets[3], object.aniSkipTimeoutLength);
  writer.writeByte(offsets[4], object.animeDisplayType.index);
  writer.writeObjectList<Repo>(
    offsets[5],
    allOffsets,
    RepoSchema.serialize,
    object.animeExtensionsRepo,
  );
  writer.writeLong(offsets[6], object.animeGridSize);
  writer.writeBool(offsets[7], object.animeLibraryDownloadedChapters);
  writer.writeBool(offsets[8], object.animeLibraryLocalSource);
  writer.writeBool(offsets[9], object.animeLibraryShowCategoryTabs);
  writer.writeBool(offsets[10], object.animeLibraryShowContinueReadingButton);
  writer.writeBool(offsets[11], object.animeLibraryShowLanguage);
  writer.writeBool(offsets[12], object.animeLibraryShowNumbersOfItems);
  writer.writeString(offsets[13], object.appFontFamily);
  writer.writeBool(offsets[14], object.appLockEnabled);
  writer.writeDouble(offsets[15], object.appUiScale);
  writer.writeBool(offsets[16], object.askDownloadDestination);
  writer.writeByte(offsets[17], object.audioChannels.index);
  writer.writeString(offsets[18], object.audioPreferredLanguages);
  writer.writeString(offsets[19], object.autoBackupLocation);
  writer.writeBool(offsets[20], object.autoExtensionsUpdates);
  writer.writeLong(offsets[21], object.autoLibraryUpdateInterval);
  writer.writeBool(offsets[22], object.autoLibraryUpdateWifiOnly);
  writer.writeBool(offsets[23], object.autoPlayNextEpisode);
  writer.writeBool(offsets[24], object.autoReadDuplicateChapters);
  writer.writeObjectList<AutoScrollPages>(
    offsets[25],
    allOffsets,
    AutoScrollPagesSchema.serialize,
    object.autoScrollPages,
  );
  writer.writeBool(offsets[26], object.autoStartExtensionServerOnLaunch);
  writer.writeLong(offsets[27], object.backupCompressionLevel);
  writer.writeBool(offsets[28], object.backupEncryptionEnabled);
  writer.writeLong(offsets[29], object.backupFrequency);
  writer.writeLongList(offsets[30], object.backupListOptions);
  writer.writeString(offsets[31], object.btServerAddress);
  writer.writeLong(offsets[32], object.btServerPort);
  writer.writeString(offsets[33], object.cfProxyUrl);
  writer.writeObjectList<ChapterFilterBookmarked>(
    offsets[34],
    allOffsets,
    ChapterFilterBookmarkedSchema.serialize,
    object.chapterFilterBookmarkedList,
  );
  writer.writeObjectList<ChapterFilterDownloaded>(
    offsets[35],
    allOffsets,
    ChapterFilterDownloadedSchema.serialize,
    object.chapterFilterDownloadedList,
  );
  writer.writeObjectList<ChapterFilterUnread>(
    offsets[36],
    allOffsets,
    ChapterFilterUnreadSchema.serialize,
    object.chapterFilterUnreadList,
  );
  writer.writeObjectList<ChapterPageIndex>(
    offsets[37],
    allOffsets,
    ChapterPageIndexSchema.serialize,
    object.chapterPageIndexList,
  );
  writer.writeLong(offsets[38], object.chapterSwipeEndAction);
  writer.writeLong(offsets[39], object.chapterSwipeStartAction);
  writer.writeBool(offsets[40], object.checkForAppUpdates);
  writer.writeBool(offsets[41], object.checkForExtensionUpdates);
  writer.writeBool(offsets[42], object.clearChapterCacheOnAppLaunch);
  writer.writeString(offsets[43], object.comicReaderPreferences);
  writer.writeLong(offsets[44], object.concurrentDownloads);
  writer.writeObjectList<MCookie>(
    offsets[45],
    allOffsets,
    MCookieSchema.serialize,
    object.cookiesList,
  );
  writer.writeString(offsets[46], object.customDns);
  writer.writeString(offsets[47], object.customDohUrl);
  writer.writeString(offsets[48], object.dateFormat);
  writer.writeByte(offsets[49], object.debandingType.index);
  writer.writeLong(offsets[50], object.defaultDoubleTapToSkipLength);
  writer.writeDouble(offsets[51], object.defaultPlayBackSpeed);
  writer.writeLong(offsets[52], object.defaultSkipIntroLength);
  writer.writeObject<L10nLocale>(
    offsets[53],
    allOffsets,
    L10nLocaleSchema.serialize,
    object.defaultSubtitleLang,
  );
  writer.writeBool(offsets[54], object.deleteDownloadAfterReading);
  writer.writeBool(offsets[55], object.developerMode);
  writer.writeByte(offsets[56], object.disableSectionType.index);
  writer.writeByte(offsets[57], object.displayType.index);
  writer.writeBool(offsets[58], object.doHEnabled);
  writer.writeLong(offsets[59], object.doHProviderId);
  writer.writeBool(offsets[60], object.doublePageAuto);
  writer.writeLong(offsets[61], object.downloadDelaySeconds);
  writer.writeString(offsets[62], object.downloadLocalFolderName);
  writer.writeString(offsets[63], object.downloadLocation);
  writer.writeBool(offsets[64], object.downloadOnlyOnWifi);
  writer.writeLongList(offsets[65], object.downloadQueueOrder);
  writer.writeBool(offsets[66], object.downloadedOnlyMode);
  writer.writeBool(offsets[67], object.enableAniSkip);
  writer.writeBool(offsets[68], object.enableAudioPitchCorrection);
  writer.writeBool(offsets[69], object.enableAutoSkip);
  writer.writeBool(offsets[70], object.enableDiscordRpc);
  writer.writeBool(offsets[71], object.enableGpuNext);
  writer.writeBool(offsets[72], object.enableHardwareAcceleration);
  writer.writeBool(offsets[73], object.enableLogs);
  writer.writeString(offsets[74], object.extensionServerPath);
  writer.writeObjectList<FilterScanlator>(
    offsets[75],
    allOffsets,
    FilterScanlatorSchema.serialize,
    object.filterScanlatorList,
  );
  writer.writeDouble(offsets[76], object.flexColorSchemeBlendLevel);
  writer.writeLong(offsets[77], object.flexSchemeColorIndex);
  writer.writeBool(offsets[78], object.followSystemTheme);
  writer.writeBool(offsets[79], object.forceLandscapePlayer);
  writer.writeBool(offsets[80], object.fullScreenPlayer);
  writer.writeBool(offsets[81], object.fullScreenReader);
  writer.writeBool(offsets[82], object.hideDiscordRpcInIncognito);
  writer.writeStringList(offsets[83], object.hideItems);
  writer.writeString(offsets[84], object.hwdecMode);
  writer.writeBool(offsets[85], object.incognitoMode);
  writer.writeString(offsets[86], object.jrePath);
  writer.writeBool(offsets[87], object.keepScreenOnReader);
  writer.writeLong(offsets[88], object.lastAutoLibraryUpdate);
  writer.writeString(offsets[89], object.lastTrackerLibraryLocation);
  writer.writeBool(offsets[90], object.libraryDownloadedChapters);
  writer.writeLong(offsets[91], object.libraryFilterAnimeBookMarkedType);
  writer.writeLong(offsets[92], object.libraryFilterAnimeCompletedType);
  writer.writeLong(offsets[93], object.libraryFilterAnimeDownloadType);
  writer.writeStringList(offsets[94], object.libraryFilterAnimeSourceIds);
  writer.writeLong(offsets[95], object.libraryFilterAnimeStartedType);
  writer.writeLong(offsets[96], object.libraryFilterAnimeTrackingType);
  writer.writeLong(offsets[97], object.libraryFilterAnimeUnreadType);
  writer.writeLong(offsets[98], object.libraryFilterMangasBookMarkedType);
  writer.writeLong(offsets[99], object.libraryFilterMangasCompletedType);
  writer.writeLong(offsets[100], object.libraryFilterMangasDownloadType);
  writer.writeStringList(offsets[101], object.libraryFilterMangasSourceIds);
  writer.writeLong(offsets[102], object.libraryFilterMangasStartedType);
  writer.writeLong(offsets[103], object.libraryFilterMangasTrackingType);
  writer.writeLong(offsets[104], object.libraryFilterMangasUnreadType);
  writer.writeLong(offsets[105], object.libraryFilterNovelBookMarkedType);
  writer.writeLong(offsets[106], object.libraryFilterNovelCompletedType);
  writer.writeLong(offsets[107], object.libraryFilterNovelDownloadType);
  writer.writeStringList(offsets[108], object.libraryFilterNovelSourceIds);
  writer.writeLong(offsets[109], object.libraryFilterNovelStartedType);
  writer.writeLong(offsets[110], object.libraryFilterNovelTrackingType);
  writer.writeLong(offsets[111], object.libraryFilterNovelUnreadType);
  writer.writeBool(offsets[112], object.libraryLocalSource);
  writer.writeBool(offsets[113], object.libraryShowCategoryTabs);
  writer.writeBool(offsets[114], object.libraryShowContinueReadingButton);
  writer.writeBool(offsets[115], object.libraryShowLanguage);
  writer.writeBool(offsets[116], object.libraryShowNumbersOfItems);
  writer.writeStringList(offsets[117], object.localFolders);
  writer.writeObject<L10nLocale>(
    offsets[118],
    allOffsets,
    L10nLocaleSchema.serialize,
    object.locale,
  );
  writer.writeObjectList<Repo>(
    offsets[119],
    allOffsets,
    RepoSchema.serialize,
    object.mangaExtensionsRepo,
  );
  writer.writeLong(offsets[120], object.mangaGridSize);
  writer.writeByte(offsets[121], object.mangaHomeDisplayType.index);
  writer.writeLong(offsets[122], object.markEpisodeAsSeenType);
  writer.writeBool(offsets[123], object.mergeLibraryNavMobile);
  writer.writeObjectList<LocalFolder>(
    offsets[124],
    allOffsets,
    LocalFolderSchema.serialize,
    object.namedLocalFolders,
  );
  writer.writeStringList(offsets[125], object.navigationOrder);
  writer.writeByte(offsets[126], object.novelDisplayType.index);
  writer.writeObjectList<Repo>(
    offsets[127],
    allOffsets,
    RepoSchema.serialize,
    object.novelExtensionsRepo,
  );
  writer.writeString(offsets[128], object.novelFontFamily);
  writer.writeLong(offsets[129], object.novelFontSize);
  writer.writeLong(offsets[130], object.novelGridSize);
  writer.writeBool(offsets[131], object.novelLibraryDownloadedChapters);
  writer.writeBool(offsets[132], object.novelLibraryLocalSource);
  writer.writeBool(offsets[133], object.novelLibraryShowCategoryTabs);
  writer.writeBool(offsets[134], object.novelLibraryShowContinueReadingButton);
  writer.writeBool(offsets[135], object.novelLibraryShowLanguage);
  writer.writeBool(offsets[136], object.novelLibraryShowNumbersOfItems);
  writer.writeDouble(offsets[137], object.novelReaderLineHeight);
  writer.writeLong(offsets[138], object.novelReaderPadding);
  writer.writeString(offsets[139], object.novelReaderTextColor);
  writer.writeString(offsets[140], object.novelReaderTheme);
  writer.writeBool(offsets[141], object.novelRemoveExtraParagraphSpacing);
  writer.writeBool(offsets[142], object.novelShowScrollPercentage);
  writer.writeBool(offsets[143], object.novelTapToScroll);
  writer.writeByte(offsets[144], object.novelTextAlign.index);
  writer.writeBool(offsets[145], object.onboardingCompleted);
  writer.writeBool(offsets[146], object.onlyIncludePinnedSources);
  writer.writeObjectList<PersonalPageMode>(
    offsets[147],
    allOffsets,
    PersonalPageModeSchema.serialize,
    object.personalPageModeList,
  );
  writer.writeObjectList<PersonalReaderMode>(
    offsets[148],
    allOffsets,
    PersonalReaderModeSchema.serialize,
    object.personalReaderModeList,
  );
  writer.writeObject<PlayerSubtitleSettings>(
    offsets[149],
    allOffsets,
    PlayerSubtitleSettingsSchema.serialize,
    object.playerSubtitleSettings,
  );
  writer.writeBool(offsets[150], object.pureBlackDarkMode);
  writer.writeLong(offsets[151], object.relativeTimesTamps);
  writer.writeBool(offsets[152], object.rpcShowCoverImage);
  writer.writeBool(offsets[153], object.rpcShowReadingWatchingProgress);
  writer.writeBool(offsets[154], object.rpcShowTitle);
  writer.writeBool(offsets[155], object.saveAsCBZArchive);
  writer.writeObjectList<SavedSearch>(
    offsets[156],
    allOffsets,
    SavedSearchSchema.serialize,
    object.savedSearchesList,
  );
  writer.writeBool(offsets[157], object.showNSFW);
  writer.writeBool(offsets[158], object.showNavDoubleTapTooltip);
  writer.writeBool(offsets[159], object.showSourceBadge);
  writer.writeObjectList<SortChapter>(
    offsets[160],
    allOffsets,
    SortChapterSchema.serialize,
    object.sortChapterList,
  );
  writer.writeObject<SortLibraryManga>(
    offsets[161],
    allOffsets,
    SortLibraryMangaSchema.serialize,
    object.sortLibraryAnime,
  );
  writer.writeObject<SortLibraryManga>(
    offsets[162],
    allOffsets,
    SortLibraryMangaSchema.serialize,
    object.sortLibraryManga,
  );
  writer.writeObject<SortLibraryManga>(
    offsets[163],
    allOffsets,
    SortLibraryMangaSchema.serialize,
    object.sortLibraryNovel,
  );
  writer.writeLong(offsets[164], object.startDatebackup);
  writer.writeBool(offsets[165], object.themeIsDark);
  writer.writeString(offsets[166], object.ttsLanguage);
  writer.writeDouble(offsets[167], object.ttsPitch);
  writer.writeDouble(offsets[168], object.ttsSpeechRate);
  writer.writeString(offsets[169], object.ttsVoice);
  writer.writeBool(offsets[170], object.tvAnimeOnlyOverride);
  writer.writeBool(offsets[171], object.tvHomeGenreRows);
  writer.writeBool(offsets[172], object.tvHomeStyle);
  writer.writeBool(offsets[173], object.tvPlayerStyle);
  writer.writeObjectList<UpdateError>(
    offsets[174],
    allOffsets,
    UpdateErrorSchema.serialize,
    object.updateErrorsList,
  );
  writer.writeBool(offsets[175], object.updateProgressAfterReading);
  writer.writeLong(offsets[176], object.updatedAt);
  writer.writeBool(offsets[177], object.useFloatingNavigationBar);
  writer.writeBool(offsets[178], object.useLibass);
  writer.writeBool(offsets[179], object.useMpvConfig);
  writer.writeBool(offsets[180], object.useYUV420P);
  writer.writeString(offsets[181], object.userAgent);
  writer.writeLong(offsets[182], object.volumeBoostCap);
}

Settings _settingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Settings(
    algorithmWeights: reader.readObjectOrNull<AlgorithmWeights>(
      offsets[0],
      AlgorithmWeightsSchema.deserialize,
      allOffsets,
    ),
    allowConcurrentDownloads: reader.readBoolOrNull(offsets[1]),
    androidProxyServer: reader.readStringOrNull(offsets[2]),
    aniSkipTimeoutLength: reader.readLongOrNull(offsets[3]),
    animeDisplayType:
        _SettingsanimeDisplayTypeValueEnumMap[reader.readByteOrNull(
          offsets[4],
        )] ??
        DisplayType.comfortableGrid,
    animeExtensionsRepo: reader.readObjectList<Repo>(
      offsets[5],
      RepoSchema.deserialize,
      allOffsets,
      Repo(),
    ),
    animeGridSize: reader.readLongOrNull(offsets[6]),
    animeLibraryDownloadedChapters: reader.readBoolOrNull(offsets[7]),
    animeLibraryLocalSource: reader.readBoolOrNull(offsets[8]),
    animeLibraryShowCategoryTabs: reader.readBoolOrNull(offsets[9]),
    animeLibraryShowContinueReadingButton: reader.readBoolOrNull(offsets[10]),
    animeLibraryShowLanguage: reader.readBoolOrNull(offsets[11]),
    animeLibraryShowNumbersOfItems: reader.readBoolOrNull(offsets[12]),
    appFontFamily: reader.readStringOrNull(offsets[13]),
    appLockEnabled: reader.readBoolOrNull(offsets[14]),
    appUiScale: reader.readDoubleOrNull(offsets[15]),
    askDownloadDestination: reader.readBoolOrNull(offsets[16]),
    audioChannels:
        _SettingsaudioChannelsValueEnumMap[reader.readByteOrNull(
          offsets[17],
        )] ??
        AudioChannel.autoSafe,
    audioPreferredLanguages: reader.readStringOrNull(offsets[18]),
    autoBackupLocation: reader.readStringOrNull(offsets[19]),
    autoExtensionsUpdates: reader.readBoolOrNull(offsets[20]),
    autoLibraryUpdateInterval: reader.readLongOrNull(offsets[21]),
    autoLibraryUpdateWifiOnly: reader.readBoolOrNull(offsets[22]),
    autoPlayNextEpisode: reader.readBoolOrNull(offsets[23]),
    autoReadDuplicateChapters: reader.readBoolOrNull(offsets[24]),
    autoScrollPages: reader.readObjectList<AutoScrollPages>(
      offsets[25],
      AutoScrollPagesSchema.deserialize,
      allOffsets,
      AutoScrollPages(),
    ),
    autoStartExtensionServerOnLaunch: reader.readBoolOrNull(offsets[26]),
    backupCompressionLevel: reader.readLongOrNull(offsets[27]),
    backupEncryptionEnabled: reader.readBoolOrNull(offsets[28]),
    backupFrequency: reader.readLongOrNull(offsets[29]),
    backupListOptions: reader.readLongList(offsets[30]),
    btServerAddress: reader.readStringOrNull(offsets[31]),
    btServerPort: reader.readLongOrNull(offsets[32]),
    cfProxyUrl: reader.readStringOrNull(offsets[33]),
    chapterFilterDownloadedList: reader.readObjectList<ChapterFilterDownloaded>(
      offsets[35],
      ChapterFilterDownloadedSchema.deserialize,
      allOffsets,
      ChapterFilterDownloaded(),
    ),
    chapterPageIndexList: reader.readObjectList<ChapterPageIndex>(
      offsets[37],
      ChapterPageIndexSchema.deserialize,
      allOffsets,
      ChapterPageIndex(),
    ),
    chapterSwipeEndAction: reader.readLongOrNull(offsets[38]),
    chapterSwipeStartAction: reader.readLongOrNull(offsets[39]),
    checkForAppUpdates: reader.readBoolOrNull(offsets[40]),
    checkForExtensionUpdates: reader.readBoolOrNull(offsets[41]),
    clearChapterCacheOnAppLaunch: reader.readBoolOrNull(offsets[42]),
    comicReaderPreferences: reader.readStringOrNull(offsets[43]),
    concurrentDownloads: reader.readLongOrNull(offsets[44]),
    cookiesList: reader.readObjectList<MCookie>(
      offsets[45],
      MCookieSchema.deserialize,
      allOffsets,
      MCookie(),
    ),
    customDns: reader.readStringOrNull(offsets[46]),
    customDohUrl: reader.readStringOrNull(offsets[47]),
    dateFormat: reader.readStringOrNull(offsets[48]),
    debandingType:
        _SettingsdebandingTypeValueEnumMap[reader.readByteOrNull(
          offsets[49],
        )] ??
        DebandingType.none,
    defaultDoubleTapToSkipLength: reader.readLongOrNull(offsets[50]),
    defaultPlayBackSpeed: reader.readDoubleOrNull(offsets[51]),
    defaultSkipIntroLength: reader.readLongOrNull(offsets[52]),
    deleteDownloadAfterReading: reader.readBoolOrNull(offsets[54]),
    developerMode: reader.readBoolOrNull(offsets[55]),
    disableSectionType:
        _SettingsdisableSectionTypeValueEnumMap[reader.readByteOrNull(
          offsets[56],
        )] ??
        SectionType.all,
    displayType:
        _SettingsdisplayTypeValueEnumMap[reader.readByteOrNull(offsets[57])] ??
        DisplayType.comfortableGrid,
    doHEnabled: reader.readBoolOrNull(offsets[58]),
    doHProviderId: reader.readLongOrNull(offsets[59]),
    doublePageAuto: reader.readBoolOrNull(offsets[60]),
    downloadDelaySeconds: reader.readLongOrNull(offsets[61]),
    downloadLocalFolderName: reader.readStringOrNull(offsets[62]),
    downloadLocation: reader.readStringOrNull(offsets[63]),
    downloadOnlyOnWifi: reader.readBoolOrNull(offsets[64]),
    downloadQueueOrder: reader.readLongList(offsets[65]),
    downloadedOnlyMode: reader.readBoolOrNull(offsets[66]),
    enableAniSkip: reader.readBoolOrNull(offsets[67]),
    enableAudioPitchCorrection: reader.readBoolOrNull(offsets[68]),
    enableAutoSkip: reader.readBoolOrNull(offsets[69]),
    enableDiscordRpc: reader.readBoolOrNull(offsets[70]),
    enableGpuNext: reader.readBoolOrNull(offsets[71]),
    enableHardwareAcceleration: reader.readBoolOrNull(offsets[72]),
    enableLogs: reader.readBoolOrNull(offsets[73]),
    extensionServerPath: reader.readStringOrNull(offsets[74]),
    flexColorSchemeBlendLevel: reader.readDoubleOrNull(offsets[76]),
    flexSchemeColorIndex: reader.readLongOrNull(offsets[77]),
    followSystemTheme: reader.readBoolOrNull(offsets[78]),
    forceLandscapePlayer: reader.readBoolOrNull(offsets[79]),
    fullScreenPlayer: reader.readBoolOrNull(offsets[80]),
    fullScreenReader: reader.readBoolOrNull(offsets[81]),
    hideDiscordRpcInIncognito: reader.readBoolOrNull(offsets[82]),
    hideItems: reader.readStringList(offsets[83]),
    hwdecMode: reader.readStringOrNull(offsets[84]),
    id: id,
    incognitoMode: reader.readBoolOrNull(offsets[85]),
    jrePath: reader.readStringOrNull(offsets[86]),
    keepScreenOnReader: reader.readBoolOrNull(offsets[87]),
    lastAutoLibraryUpdate: reader.readLongOrNull(offsets[88]),
    lastTrackerLibraryLocation: reader.readStringOrNull(offsets[89]),
    libraryDownloadedChapters: reader.readBoolOrNull(offsets[90]),
    libraryFilterAnimeBookMarkedType: reader.readLongOrNull(offsets[91]),
    libraryFilterAnimeCompletedType: reader.readLongOrNull(offsets[92]),
    libraryFilterAnimeDownloadType: reader.readLongOrNull(offsets[93]),
    libraryFilterAnimeSourceIds: reader.readStringList(offsets[94]),
    libraryFilterAnimeStartedType: reader.readLongOrNull(offsets[95]),
    libraryFilterAnimeTrackingType: reader.readLongOrNull(offsets[96]),
    libraryFilterAnimeUnreadType: reader.readLongOrNull(offsets[97]),
    libraryFilterMangasBookMarkedType: reader.readLongOrNull(offsets[98]),
    libraryFilterMangasCompletedType: reader.readLongOrNull(offsets[99]),
    libraryFilterMangasDownloadType: reader.readLongOrNull(offsets[100]),
    libraryFilterMangasSourceIds: reader.readStringList(offsets[101]),
    libraryFilterMangasStartedType: reader.readLongOrNull(offsets[102]),
    libraryFilterMangasTrackingType: reader.readLongOrNull(offsets[103]),
    libraryFilterMangasUnreadType: reader.readLongOrNull(offsets[104]),
    libraryFilterNovelBookMarkedType: reader.readLongOrNull(offsets[105]),
    libraryFilterNovelCompletedType: reader.readLongOrNull(offsets[106]),
    libraryFilterNovelDownloadType: reader.readLongOrNull(offsets[107]),
    libraryFilterNovelSourceIds: reader.readStringList(offsets[108]),
    libraryFilterNovelStartedType: reader.readLongOrNull(offsets[109]),
    libraryFilterNovelTrackingType: reader.readLongOrNull(offsets[110]),
    libraryFilterNovelUnreadType: reader.readLongOrNull(offsets[111]),
    libraryLocalSource: reader.readBoolOrNull(offsets[112]),
    libraryShowCategoryTabs: reader.readBoolOrNull(offsets[113]),
    libraryShowContinueReadingButton: reader.readBoolOrNull(offsets[114]),
    libraryShowLanguage: reader.readBoolOrNull(offsets[115]),
    libraryShowNumbersOfItems: reader.readBoolOrNull(offsets[116]),
    localFolders: reader.readStringList(offsets[117]),
    mangaExtensionsRepo: reader.readObjectList<Repo>(
      offsets[119],
      RepoSchema.deserialize,
      allOffsets,
      Repo(),
    ),
    mangaGridSize: reader.readLongOrNull(offsets[120]),
    mangaHomeDisplayType:
        _SettingsmangaHomeDisplayTypeValueEnumMap[reader.readByteOrNull(
          offsets[121],
        )] ??
        DisplayType.comfortableGrid,
    markEpisodeAsSeenType: reader.readLongOrNull(offsets[122]),
    mergeLibraryNavMobile: reader.readBoolOrNull(offsets[123]),
    namedLocalFolders: reader.readObjectList<LocalFolder>(
      offsets[124],
      LocalFolderSchema.deserialize,
      allOffsets,
      LocalFolder(),
    ),
    navigationOrder: reader.readStringList(offsets[125]),
    novelDisplayType:
        _SettingsnovelDisplayTypeValueEnumMap[reader.readByteOrNull(
          offsets[126],
        )] ??
        DisplayType.comfortableGrid,
    novelExtensionsRepo: reader.readObjectList<Repo>(
      offsets[127],
      RepoSchema.deserialize,
      allOffsets,
      Repo(),
    ),
    novelFontFamily: reader.readStringOrNull(offsets[128]),
    novelFontSize: reader.readLongOrNull(offsets[129]),
    novelLibraryDownloadedChapters: reader.readBoolOrNull(offsets[131]),
    novelLibraryLocalSource: reader.readBoolOrNull(offsets[132]),
    novelLibraryShowCategoryTabs: reader.readBoolOrNull(offsets[133]),
    novelLibraryShowContinueReadingButton: reader.readBoolOrNull(offsets[134]),
    novelLibraryShowLanguage: reader.readBoolOrNull(offsets[135]),
    novelLibraryShowNumbersOfItems: reader.readBoolOrNull(offsets[136]),
    novelReaderLineHeight: reader.readDoubleOrNull(offsets[137]),
    novelReaderPadding: reader.readLongOrNull(offsets[138]),
    novelReaderTextColor: reader.readStringOrNull(offsets[139]),
    novelReaderTheme: reader.readStringOrNull(offsets[140]),
    novelRemoveExtraParagraphSpacing: reader.readBoolOrNull(offsets[141]),
    novelShowScrollPercentage: reader.readBoolOrNull(offsets[142]),
    novelTapToScroll: reader.readBoolOrNull(offsets[143]),
    novelTextAlign:
        _SettingsnovelTextAlignValueEnumMap[reader.readByteOrNull(
          offsets[144],
        )] ??
        NovelTextAlign.left,
    onboardingCompleted: reader.readBoolOrNull(offsets[145]),
    onlyIncludePinnedSources: reader.readBoolOrNull(offsets[146]),
    personalPageModeList: reader.readObjectList<PersonalPageMode>(
      offsets[147],
      PersonalPageModeSchema.deserialize,
      allOffsets,
      PersonalPageMode(),
    ),
    personalReaderModeList: reader.readObjectList<PersonalReaderMode>(
      offsets[148],
      PersonalReaderModeSchema.deserialize,
      allOffsets,
      PersonalReaderMode(),
    ),
    playerSubtitleSettings: reader.readObjectOrNull<PlayerSubtitleSettings>(
      offsets[149],
      PlayerSubtitleSettingsSchema.deserialize,
      allOffsets,
    ),
    pureBlackDarkMode: reader.readBoolOrNull(offsets[150]),
    relativeTimesTamps: reader.readLongOrNull(offsets[151]),
    rpcShowCoverImage: reader.readBoolOrNull(offsets[152]),
    rpcShowReadingWatchingProgress: reader.readBoolOrNull(offsets[153]),
    rpcShowTitle: reader.readBoolOrNull(offsets[154]),
    saveAsCBZArchive: reader.readBoolOrNull(offsets[155]),
    savedSearchesList: reader.readObjectList<SavedSearch>(
      offsets[156],
      SavedSearchSchema.deserialize,
      allOffsets,
      SavedSearch(),
    ),
    showNSFW: reader.readBoolOrNull(offsets[157]),
    showNavDoubleTapTooltip: reader.readBoolOrNull(offsets[158]),
    showSourceBadge: reader.readBoolOrNull(offsets[159]),
    sortChapterList: reader.readObjectList<SortChapter>(
      offsets[160],
      SortChapterSchema.deserialize,
      allOffsets,
      SortChapter(),
    ),
    sortLibraryAnime: reader.readObjectOrNull<SortLibraryManga>(
      offsets[161],
      SortLibraryMangaSchema.deserialize,
      allOffsets,
    ),
    sortLibraryManga: reader.readObjectOrNull<SortLibraryManga>(
      offsets[162],
      SortLibraryMangaSchema.deserialize,
      allOffsets,
    ),
    sortLibraryNovel: reader.readObjectOrNull<SortLibraryManga>(
      offsets[163],
      SortLibraryMangaSchema.deserialize,
      allOffsets,
    ),
    startDatebackup: reader.readLongOrNull(offsets[164]),
    themeIsDark: reader.readBoolOrNull(offsets[165]),
    ttsLanguage: reader.readStringOrNull(offsets[166]),
    ttsPitch: reader.readDoubleOrNull(offsets[167]),
    ttsSpeechRate: reader.readDoubleOrNull(offsets[168]),
    ttsVoice: reader.readStringOrNull(offsets[169]),
    tvAnimeOnlyOverride: reader.readBoolOrNull(offsets[170]),
    tvHomeGenreRows: reader.readBoolOrNull(offsets[171]),
    tvHomeStyle: reader.readBoolOrNull(offsets[172]),
    tvPlayerStyle: reader.readBoolOrNull(offsets[173]),
    updateErrorsList: reader.readObjectList<UpdateError>(
      offsets[174],
      UpdateErrorSchema.deserialize,
      allOffsets,
      UpdateError(),
    ),
    updateProgressAfterReading: reader.readBoolOrNull(offsets[175]),
    updatedAt: reader.readLongOrNull(offsets[176]),
    useFloatingNavigationBar: reader.readBoolOrNull(offsets[177]),
    useLibass: reader.readBoolOrNull(offsets[178]),
    useMpvConfig: reader.readBoolOrNull(offsets[179]),
    useYUV420P: reader.readBoolOrNull(offsets[180]),
    userAgent: reader.readStringOrNull(offsets[181]),
    volumeBoostCap: reader.readLongOrNull(offsets[182]),
  );
  object.chapterFilterBookmarkedList = reader
      .readObjectList<ChapterFilterBookmarked>(
        offsets[34],
        ChapterFilterBookmarkedSchema.deserialize,
        allOffsets,
        ChapterFilterBookmarked(),
      );
  object.chapterFilterUnreadList = reader.readObjectList<ChapterFilterUnread>(
    offsets[36],
    ChapterFilterUnreadSchema.deserialize,
    allOffsets,
    ChapterFilterUnread(),
  );
  object.defaultSubtitleLang = reader.readObjectOrNull<L10nLocale>(
    offsets[53],
    L10nLocaleSchema.deserialize,
    allOffsets,
  );
  object.filterScanlatorList = reader.readObjectList<FilterScanlator>(
    offsets[75],
    FilterScanlatorSchema.deserialize,
    allOffsets,
    FilterScanlator(),
  );
  object.locale = reader.readObjectOrNull<L10nLocale>(
    offsets[118],
    L10nLocaleSchema.deserialize,
    allOffsets,
  );
  object.novelGridSize = reader.readLongOrNull(offsets[130]);
  return object;
}

P _settingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<AlgorithmWeights>(
            offset,
            AlgorithmWeightsSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (_SettingsanimeDisplayTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DisplayType.comfortableGrid)
          as P;
    case 5:
      return (reader.readObjectList<Repo>(
            offset,
            RepoSchema.deserialize,
            allOffsets,
            Repo(),
          ))
          as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readBoolOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset)) as P;
    case 12:
      return (reader.readBoolOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readBoolOrNull(offset)) as P;
    case 15:
      return (reader.readDoubleOrNull(offset)) as P;
    case 16:
      return (reader.readBoolOrNull(offset)) as P;
    case 17:
      return (_SettingsaudioChannelsValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              AudioChannel.autoSafe)
          as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readBoolOrNull(offset)) as P;
    case 21:
      return (reader.readLongOrNull(offset)) as P;
    case 22:
      return (reader.readBoolOrNull(offset)) as P;
    case 23:
      return (reader.readBoolOrNull(offset)) as P;
    case 24:
      return (reader.readBoolOrNull(offset)) as P;
    case 25:
      return (reader.readObjectList<AutoScrollPages>(
            offset,
            AutoScrollPagesSchema.deserialize,
            allOffsets,
            AutoScrollPages(),
          ))
          as P;
    case 26:
      return (reader.readBoolOrNull(offset)) as P;
    case 27:
      return (reader.readLongOrNull(offset)) as P;
    case 28:
      return (reader.readBoolOrNull(offset)) as P;
    case 29:
      return (reader.readLongOrNull(offset)) as P;
    case 30:
      return (reader.readLongList(offset)) as P;
    case 31:
      return (reader.readStringOrNull(offset)) as P;
    case 32:
      return (reader.readLongOrNull(offset)) as P;
    case 33:
      return (reader.readStringOrNull(offset)) as P;
    case 34:
      return (reader.readObjectList<ChapterFilterBookmarked>(
            offset,
            ChapterFilterBookmarkedSchema.deserialize,
            allOffsets,
            ChapterFilterBookmarked(),
          ))
          as P;
    case 35:
      return (reader.readObjectList<ChapterFilterDownloaded>(
            offset,
            ChapterFilterDownloadedSchema.deserialize,
            allOffsets,
            ChapterFilterDownloaded(),
          ))
          as P;
    case 36:
      return (reader.readObjectList<ChapterFilterUnread>(
            offset,
            ChapterFilterUnreadSchema.deserialize,
            allOffsets,
            ChapterFilterUnread(),
          ))
          as P;
    case 37:
      return (reader.readObjectList<ChapterPageIndex>(
            offset,
            ChapterPageIndexSchema.deserialize,
            allOffsets,
            ChapterPageIndex(),
          ))
          as P;
    case 38:
      return (reader.readLongOrNull(offset)) as P;
    case 39:
      return (reader.readLongOrNull(offset)) as P;
    case 40:
      return (reader.readBoolOrNull(offset)) as P;
    case 41:
      return (reader.readBoolOrNull(offset)) as P;
    case 42:
      return (reader.readBoolOrNull(offset)) as P;
    case 43:
      return (reader.readStringOrNull(offset)) as P;
    case 44:
      return (reader.readLongOrNull(offset)) as P;
    case 45:
      return (reader.readObjectList<MCookie>(
            offset,
            MCookieSchema.deserialize,
            allOffsets,
            MCookie(),
          ))
          as P;
    case 46:
      return (reader.readStringOrNull(offset)) as P;
    case 47:
      return (reader.readStringOrNull(offset)) as P;
    case 48:
      return (reader.readStringOrNull(offset)) as P;
    case 49:
      return (_SettingsdebandingTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DebandingType.none)
          as P;
    case 50:
      return (reader.readLongOrNull(offset)) as P;
    case 51:
      return (reader.readDoubleOrNull(offset)) as P;
    case 52:
      return (reader.readLongOrNull(offset)) as P;
    case 53:
      return (reader.readObjectOrNull<L10nLocale>(
            offset,
            L10nLocaleSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 54:
      return (reader.readBoolOrNull(offset)) as P;
    case 55:
      return (reader.readBoolOrNull(offset)) as P;
    case 56:
      return (_SettingsdisableSectionTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              SectionType.all)
          as P;
    case 57:
      return (_SettingsdisplayTypeValueEnumMap[reader.readByteOrNull(offset)] ??
              DisplayType.comfortableGrid)
          as P;
    case 58:
      return (reader.readBoolOrNull(offset)) as P;
    case 59:
      return (reader.readLongOrNull(offset)) as P;
    case 60:
      return (reader.readBoolOrNull(offset)) as P;
    case 61:
      return (reader.readLongOrNull(offset)) as P;
    case 62:
      return (reader.readStringOrNull(offset)) as P;
    case 63:
      return (reader.readStringOrNull(offset)) as P;
    case 64:
      return (reader.readBoolOrNull(offset)) as P;
    case 65:
      return (reader.readLongList(offset)) as P;
    case 66:
      return (reader.readBoolOrNull(offset)) as P;
    case 67:
      return (reader.readBoolOrNull(offset)) as P;
    case 68:
      return (reader.readBoolOrNull(offset)) as P;
    case 69:
      return (reader.readBoolOrNull(offset)) as P;
    case 70:
      return (reader.readBoolOrNull(offset)) as P;
    case 71:
      return (reader.readBoolOrNull(offset)) as P;
    case 72:
      return (reader.readBoolOrNull(offset)) as P;
    case 73:
      return (reader.readBoolOrNull(offset)) as P;
    case 74:
      return (reader.readStringOrNull(offset)) as P;
    case 75:
      return (reader.readObjectList<FilterScanlator>(
            offset,
            FilterScanlatorSchema.deserialize,
            allOffsets,
            FilterScanlator(),
          ))
          as P;
    case 76:
      return (reader.readDoubleOrNull(offset)) as P;
    case 77:
      return (reader.readLongOrNull(offset)) as P;
    case 78:
      return (reader.readBoolOrNull(offset)) as P;
    case 79:
      return (reader.readBoolOrNull(offset)) as P;
    case 80:
      return (reader.readBoolOrNull(offset)) as P;
    case 81:
      return (reader.readBoolOrNull(offset)) as P;
    case 82:
      return (reader.readBoolOrNull(offset)) as P;
    case 83:
      return (reader.readStringList(offset)) as P;
    case 84:
      return (reader.readStringOrNull(offset)) as P;
    case 85:
      return (reader.readBoolOrNull(offset)) as P;
    case 86:
      return (reader.readStringOrNull(offset)) as P;
    case 87:
      return (reader.readBoolOrNull(offset)) as P;
    case 88:
      return (reader.readLongOrNull(offset)) as P;
    case 89:
      return (reader.readStringOrNull(offset)) as P;
    case 90:
      return (reader.readBoolOrNull(offset)) as P;
    case 91:
      return (reader.readLongOrNull(offset)) as P;
    case 92:
      return (reader.readLongOrNull(offset)) as P;
    case 93:
      return (reader.readLongOrNull(offset)) as P;
    case 94:
      return (reader.readStringList(offset)) as P;
    case 95:
      return (reader.readLongOrNull(offset)) as P;
    case 96:
      return (reader.readLongOrNull(offset)) as P;
    case 97:
      return (reader.readLongOrNull(offset)) as P;
    case 98:
      return (reader.readLongOrNull(offset)) as P;
    case 99:
      return (reader.readLongOrNull(offset)) as P;
    case 100:
      return (reader.readLongOrNull(offset)) as P;
    case 101:
      return (reader.readStringList(offset)) as P;
    case 102:
      return (reader.readLongOrNull(offset)) as P;
    case 103:
      return (reader.readLongOrNull(offset)) as P;
    case 104:
      return (reader.readLongOrNull(offset)) as P;
    case 105:
      return (reader.readLongOrNull(offset)) as P;
    case 106:
      return (reader.readLongOrNull(offset)) as P;
    case 107:
      return (reader.readLongOrNull(offset)) as P;
    case 108:
      return (reader.readStringList(offset)) as P;
    case 109:
      return (reader.readLongOrNull(offset)) as P;
    case 110:
      return (reader.readLongOrNull(offset)) as P;
    case 111:
      return (reader.readLongOrNull(offset)) as P;
    case 112:
      return (reader.readBoolOrNull(offset)) as P;
    case 113:
      return (reader.readBoolOrNull(offset)) as P;
    case 114:
      return (reader.readBoolOrNull(offset)) as P;
    case 115:
      return (reader.readBoolOrNull(offset)) as P;
    case 116:
      return (reader.readBoolOrNull(offset)) as P;
    case 117:
      return (reader.readStringList(offset)) as P;
    case 118:
      return (reader.readObjectOrNull<L10nLocale>(
            offset,
            L10nLocaleSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 119:
      return (reader.readObjectList<Repo>(
            offset,
            RepoSchema.deserialize,
            allOffsets,
            Repo(),
          ))
          as P;
    case 120:
      return (reader.readLongOrNull(offset)) as P;
    case 121:
      return (_SettingsmangaHomeDisplayTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DisplayType.comfortableGrid)
          as P;
    case 122:
      return (reader.readLongOrNull(offset)) as P;
    case 123:
      return (reader.readBoolOrNull(offset)) as P;
    case 124:
      return (reader.readObjectList<LocalFolder>(
            offset,
            LocalFolderSchema.deserialize,
            allOffsets,
            LocalFolder(),
          ))
          as P;
    case 125:
      return (reader.readStringList(offset)) as P;
    case 126:
      return (_SettingsnovelDisplayTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DisplayType.comfortableGrid)
          as P;
    case 127:
      return (reader.readObjectList<Repo>(
            offset,
            RepoSchema.deserialize,
            allOffsets,
            Repo(),
          ))
          as P;
    case 128:
      return (reader.readStringOrNull(offset)) as P;
    case 129:
      return (reader.readLongOrNull(offset)) as P;
    case 130:
      return (reader.readLongOrNull(offset)) as P;
    case 131:
      return (reader.readBoolOrNull(offset)) as P;
    case 132:
      return (reader.readBoolOrNull(offset)) as P;
    case 133:
      return (reader.readBoolOrNull(offset)) as P;
    case 134:
      return (reader.readBoolOrNull(offset)) as P;
    case 135:
      return (reader.readBoolOrNull(offset)) as P;
    case 136:
      return (reader.readBoolOrNull(offset)) as P;
    case 137:
      return (reader.readDoubleOrNull(offset)) as P;
    case 138:
      return (reader.readLongOrNull(offset)) as P;
    case 139:
      return (reader.readStringOrNull(offset)) as P;
    case 140:
      return (reader.readStringOrNull(offset)) as P;
    case 141:
      return (reader.readBoolOrNull(offset)) as P;
    case 142:
      return (reader.readBoolOrNull(offset)) as P;
    case 143:
      return (reader.readBoolOrNull(offset)) as P;
    case 144:
      return (_SettingsnovelTextAlignValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              NovelTextAlign.left)
          as P;
    case 145:
      return (reader.readBoolOrNull(offset)) as P;
    case 146:
      return (reader.readBoolOrNull(offset)) as P;
    case 147:
      return (reader.readObjectList<PersonalPageMode>(
            offset,
            PersonalPageModeSchema.deserialize,
            allOffsets,
            PersonalPageMode(),
          ))
          as P;
    case 148:
      return (reader.readObjectList<PersonalReaderMode>(
            offset,
            PersonalReaderModeSchema.deserialize,
            allOffsets,
            PersonalReaderMode(),
          ))
          as P;
    case 149:
      return (reader.readObjectOrNull<PlayerSubtitleSettings>(
            offset,
            PlayerSubtitleSettingsSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 150:
      return (reader.readBoolOrNull(offset)) as P;
    case 151:
      return (reader.readLongOrNull(offset)) as P;
    case 152:
      return (reader.readBoolOrNull(offset)) as P;
    case 153:
      return (reader.readBoolOrNull(offset)) as P;
    case 154:
      return (reader.readBoolOrNull(offset)) as P;
    case 155:
      return (reader.readBoolOrNull(offset)) as P;
    case 156:
      return (reader.readObjectList<SavedSearch>(
            offset,
            SavedSearchSchema.deserialize,
            allOffsets,
            SavedSearch(),
          ))
          as P;
    case 157:
      return (reader.readBoolOrNull(offset)) as P;
    case 158:
      return (reader.readBoolOrNull(offset)) as P;
    case 159:
      return (reader.readBoolOrNull(offset)) as P;
    case 160:
      return (reader.readObjectList<SortChapter>(
            offset,
            SortChapterSchema.deserialize,
            allOffsets,
            SortChapter(),
          ))
          as P;
    case 161:
      return (reader.readObjectOrNull<SortLibraryManga>(
            offset,
            SortLibraryMangaSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 162:
      return (reader.readObjectOrNull<SortLibraryManga>(
            offset,
            SortLibraryMangaSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 163:
      return (reader.readObjectOrNull<SortLibraryManga>(
            offset,
            SortLibraryMangaSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 164:
      return (reader.readLongOrNull(offset)) as P;
    case 165:
      return (reader.readBoolOrNull(offset)) as P;
    case 166:
      return (reader.readStringOrNull(offset)) as P;
    case 167:
      return (reader.readDoubleOrNull(offset)) as P;
    case 168:
      return (reader.readDoubleOrNull(offset)) as P;
    case 169:
      return (reader.readStringOrNull(offset)) as P;
    case 170:
      return (reader.readBoolOrNull(offset)) as P;
    case 171:
      return (reader.readBoolOrNull(offset)) as P;
    case 172:
      return (reader.readBoolOrNull(offset)) as P;
    case 173:
      return (reader.readBoolOrNull(offset)) as P;
    case 174:
      return (reader.readObjectList<UpdateError>(
            offset,
            UpdateErrorSchema.deserialize,
            allOffsets,
            UpdateError(),
          ))
          as P;
    case 175:
      return (reader.readBoolOrNull(offset)) as P;
    case 176:
      return (reader.readLongOrNull(offset)) as P;
    case 177:
      return (reader.readBoolOrNull(offset)) as P;
    case 178:
      return (reader.readBoolOrNull(offset)) as P;
    case 179:
      return (reader.readBoolOrNull(offset)) as P;
    case 180:
      return (reader.readBoolOrNull(offset)) as P;
    case 181:
      return (reader.readStringOrNull(offset)) as P;
    case 182:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SettingsanimeDisplayTypeEnumValueMap = {
  'compactGrid': 0,
  'comfortableGrid': 1,
  'coverOnlyGrid': 2,
  'list': 3,
};
const _SettingsanimeDisplayTypeValueEnumMap = {
  0: DisplayType.compactGrid,
  1: DisplayType.comfortableGrid,
  2: DisplayType.coverOnlyGrid,
  3: DisplayType.list,
};
const _SettingsaudioChannelsEnumValueMap = {
  'auto': 0,
  'autoSafe': 1,
  'mono': 2,
  'stereo': 3,
  'reverseStereo': 4,
};
const _SettingsaudioChannelsValueEnumMap = {
  0: AudioChannel.auto,
  1: AudioChannel.autoSafe,
  2: AudioChannel.mono,
  3: AudioChannel.stereo,
  4: AudioChannel.reverseStereo,
};
const _SettingsdebandingTypeEnumValueMap = {'none': 0, 'cpu': 1, 'gpu': 2};
const _SettingsdebandingTypeValueEnumMap = {
  0: DebandingType.none,
  1: DebandingType.cpu,
  2: DebandingType.gpu,
};
const _SettingsdisableSectionTypeEnumValueMap = {
  'all': 0,
  'anime': 1,
  'manga': 2,
};
const _SettingsdisableSectionTypeValueEnumMap = {
  0: SectionType.all,
  1: SectionType.anime,
  2: SectionType.manga,
};
const _SettingsdisplayTypeEnumValueMap = {
  'compactGrid': 0,
  'comfortableGrid': 1,
  'coverOnlyGrid': 2,
  'list': 3,
};
const _SettingsdisplayTypeValueEnumMap = {
  0: DisplayType.compactGrid,
  1: DisplayType.comfortableGrid,
  2: DisplayType.coverOnlyGrid,
  3: DisplayType.list,
};
const _SettingsmangaHomeDisplayTypeEnumValueMap = {
  'compactGrid': 0,
  'comfortableGrid': 1,
  'coverOnlyGrid': 2,
  'list': 3,
};
const _SettingsmangaHomeDisplayTypeValueEnumMap = {
  0: DisplayType.compactGrid,
  1: DisplayType.comfortableGrid,
  2: DisplayType.coverOnlyGrid,
  3: DisplayType.list,
};
const _SettingsnovelDisplayTypeEnumValueMap = {
  'compactGrid': 0,
  'comfortableGrid': 1,
  'coverOnlyGrid': 2,
  'list': 3,
};
const _SettingsnovelDisplayTypeValueEnumMap = {
  0: DisplayType.compactGrid,
  1: DisplayType.comfortableGrid,
  2: DisplayType.coverOnlyGrid,
  3: DisplayType.list,
};
const _SettingsnovelTextAlignEnumValueMap = {
  'left': 0,
  'center': 1,
  'right': 2,
  'block': 3,
};
const _SettingsnovelTextAlignValueEnumMap = {
  0: NovelTextAlign.left,
  1: NovelTextAlign.center,
  2: NovelTextAlign.right,
  3: NovelTextAlign.block,
};

Id _settingsGetId(Settings object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _settingsGetLinks(Settings object) {
  return [object.sources];
}

void _settingsAttach(IsarCollection<dynamic> col, Id id, Settings object) {
  object.id = id;
  object.sources.attach(col, col.isar.collection<Source>(), r'sources', id);
}

extension SettingsQueryWhereSort on QueryBuilder<Settings, Settings, QWhere> {
  QueryBuilder<Settings, Settings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsQueryWhere on QueryBuilder<Settings, Settings, QWhereClause> {
  QueryBuilder<Settings, Settings, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SettingsQueryFilter
    on QueryBuilder<Settings, Settings, QFilterCondition> {
  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  algorithmWeightsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'algorithmWeights'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  algorithmWeightsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'algorithmWeights'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  allowConcurrentDownloadsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'allowConcurrentDownloads'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  allowConcurrentDownloadsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'allowConcurrentDownloads'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  allowConcurrentDownloadsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'allowConcurrentDownloads',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'androidProxyServer'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'androidProxyServer'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'androidProxyServer',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'androidProxyServer',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'androidProxyServer', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'androidProxyServer', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'aniSkipTimeoutLength'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'aniSkipTimeoutLength'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'aniSkipTimeoutLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'aniSkipTimeoutLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'aniSkipTimeoutLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'aniSkipTimeoutLength',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeDisplayTypeEqualTo(DisplayType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'animeDisplayType', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeDisplayTypeGreaterThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'animeDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeDisplayTypeLessThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'animeDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeDisplayTypeBetween(
    DisplayType lower,
    DisplayType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'animeDisplayType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'animeExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'animeExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'animeExtensionsRepo',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'animeExtensionsRepo', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'animeExtensionsRepo', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'animeExtensionsRepo', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'animeExtensionsRepo',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'animeExtensionsRepo',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeGridSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'animeGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeGridSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'animeGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> animeGridSizeEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'animeGridSize', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeGridSizeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'animeGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> animeGridSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'animeGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> animeGridSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'animeGridSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryDownloadedChaptersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'animeLibraryDownloadedChapters',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryDownloadedChaptersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'animeLibraryDownloadedChapters',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryDownloadedChaptersEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryDownloadedChapters',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryLocalSourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'animeLibraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryLocalSourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'animeLibraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryLocalSourceEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryLocalSource',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowCategoryTabsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'animeLibraryShowCategoryTabs'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowCategoryTabsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'animeLibraryShowCategoryTabs',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowCategoryTabsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryShowCategoryTabs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowContinueReadingButtonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'animeLibraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowContinueReadingButtonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'animeLibraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowContinueReadingButtonEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryShowContinueReadingButton',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'animeLibraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'animeLibraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowLanguageEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryShowLanguage',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowNumbersOfItemsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'animeLibraryShowNumbersOfItems',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowNumbersOfItemsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'animeLibraryShowNumbersOfItems',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowNumbersOfItemsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryShowNumbersOfItems',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'appFontFamily'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'appFontFamily'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'appFontFamily',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'appFontFamily',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'appFontFamily', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'appFontFamily', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appLockEnabledIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'appLockEnabled'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appLockEnabledIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'appLockEnabled'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appLockEnabledEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'appLockEnabled', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appUiScaleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'appUiScale'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appUiScaleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'appUiScale'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appUiScaleEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'appUiScale',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appUiScaleGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'appUiScale',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appUiScaleLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'appUiScale',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appUiScaleBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'appUiScale',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  askDownloadDestinationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'askDownloadDestination'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  askDownloadDestinationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'askDownloadDestination'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  askDownloadDestinationEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'askDownloadDestination',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> audioChannelsEqualTo(
    AudioChannel value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'audioChannels', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioChannelsGreaterThan(AudioChannel value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'audioChannels',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> audioChannelsLessThan(
    AudioChannel value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'audioChannels',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> audioChannelsBetween(
    AudioChannel lower,
    AudioChannel upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'audioChannels',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'audioPreferredLanguages'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'audioPreferredLanguages'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'audioPreferredLanguages',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'audioPreferredLanguages',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'audioPreferredLanguages',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'audioPreferredLanguages',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoBackupLocation'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoBackupLocation'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'autoBackupLocation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'autoBackupLocation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoBackupLocation', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'autoBackupLocation', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoExtensionsUpdatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoExtensionsUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoExtensionsUpdatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoExtensionsUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoExtensionsUpdatesEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'autoExtensionsUpdates',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoLibraryUpdateIntervalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoLibraryUpdateInterval'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoLibraryUpdateIntervalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoLibraryUpdateInterval'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoLibraryUpdateIntervalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'autoLibraryUpdateInterval',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoLibraryUpdateIntervalGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'autoLibraryUpdateInterval',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoLibraryUpdateIntervalLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'autoLibraryUpdateInterval',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoLibraryUpdateIntervalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'autoLibraryUpdateInterval',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoLibraryUpdateWifiOnlyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoLibraryUpdateWifiOnly'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoLibraryUpdateWifiOnlyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoLibraryUpdateWifiOnly'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoLibraryUpdateWifiOnlyEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'autoLibraryUpdateWifiOnly',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoPlayNextEpisodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoPlayNextEpisode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoPlayNextEpisodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoPlayNextEpisode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoPlayNextEpisodeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoPlayNextEpisode', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoReadDuplicateChaptersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoReadDuplicateChapters'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoReadDuplicateChaptersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoReadDuplicateChapters'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoReadDuplicateChaptersEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'autoReadDuplicateChapters',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoScrollPages'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoScrollPages'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'autoScrollPages', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'autoScrollPages', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'autoScrollPages', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'autoScrollPages', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'autoScrollPages',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'autoScrollPages',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoStartExtensionServerOnLaunchIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'autoStartExtensionServerOnLaunch',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoStartExtensionServerOnLaunchIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'autoStartExtensionServerOnLaunch',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoStartExtensionServerOnLaunchEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'autoStartExtensionServerOnLaunch',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupCompressionLevelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backupCompressionLevel'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupCompressionLevelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backupCompressionLevel'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupCompressionLevelEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'backupCompressionLevel',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupCompressionLevelGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backupCompressionLevel',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupCompressionLevelLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backupCompressionLevel',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupCompressionLevelBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backupCompressionLevel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupEncryptionEnabledIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backupEncryptionEnabled'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupEncryptionEnabledIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backupEncryptionEnabled'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupEncryptionEnabledEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'backupEncryptionEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backupFrequency'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backupFrequency'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backupFrequency', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backupFrequency',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backupFrequency',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backupFrequency',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backupListOptions'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backupListOptions'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backupListOptions', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backupListOptions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backupListOptions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backupListOptions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'backupListOptions', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'backupListOptions', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'backupListOptions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'backupListOptions', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'backupListOptions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'backupListOptions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'btServerAddress'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'btServerAddress'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'btServerAddress',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'btServerAddress',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'btServerAddress', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'btServerAddress', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> btServerPortIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'btServerPort'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerPortIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'btServerPort'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> btServerPortEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'btServerPort', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerPortGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'btServerPort',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> btServerPortLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'btServerPort',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> btServerPortBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'btServerPort',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cfProxyUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cfProxyUrl'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cfProxyUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cfProxyUrl'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cfProxyUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'cfProxyUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cfProxyUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cfProxyUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cfProxyUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cfProxyUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cfProxyUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cfProxyUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cfProxyUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'cfProxyUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cfProxyUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'cfProxyUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cfProxyUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'cfProxyUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cfProxyUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'cfProxyUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cfProxyUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cfProxyUrl', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cfProxyUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'cfProxyUrl', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterFilterBookmarkedList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'chapterFilterBookmarkedList',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterBookmarkedList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'chapterFilterBookmarkedList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterBookmarkedList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterBookmarkedList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterBookmarkedList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterBookmarkedList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterDownloadedListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterFilterDownloadedList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterDownloadedListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'chapterFilterDownloadedList',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterDownloadedListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterDownloadedList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterDownloadedListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'chapterFilterDownloadedList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterDownloadedListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterDownloadedList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterDownloadedListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterDownloadedList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterDownloadedListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterDownloadedList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterDownloadedListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterDownloadedList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterUnreadListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterFilterUnreadList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterUnreadListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterFilterUnreadList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterUnreadListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterUnreadList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterUnreadListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'chapterFilterUnreadList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterUnreadListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterUnreadList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterUnreadListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterUnreadList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterUnreadListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterUnreadList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterUnreadListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterUnreadList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterPageIndexList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterPageIndexList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageIndexList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'chapterPageIndexList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'chapterPageIndexList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageIndexList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageIndexList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageIndexList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeEndActionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterSwipeEndAction'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeEndActionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterSwipeEndAction'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeEndActionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'chapterSwipeEndAction',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeEndActionGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chapterSwipeEndAction',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeEndActionLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chapterSwipeEndAction',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeEndActionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chapterSwipeEndAction',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeStartActionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterSwipeStartAction'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeStartActionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterSwipeStartAction'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeStartActionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'chapterSwipeStartAction',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeStartActionGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chapterSwipeStartAction',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeStartActionLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chapterSwipeStartAction',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterSwipeStartActionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chapterSwipeStartAction',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForAppUpdatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'checkForAppUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForAppUpdatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'checkForAppUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForAppUpdatesEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'checkForAppUpdates', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForExtensionUpdatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'checkForExtensionUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForExtensionUpdatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'checkForExtensionUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForExtensionUpdatesEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'checkForExtensionUpdates',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  clearChapterCacheOnAppLaunchIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'clearChapterCacheOnAppLaunch'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  clearChapterCacheOnAppLaunchIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'clearChapterCacheOnAppLaunch',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  clearChapterCacheOnAppLaunchEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'clearChapterCacheOnAppLaunch',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'comicReaderPreferences'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'comicReaderPreferences'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'comicReaderPreferences',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'comicReaderPreferences',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'comicReaderPreferences',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'comicReaderPreferences',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'comicReaderPreferences',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'comicReaderPreferences',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'comicReaderPreferences',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'comicReaderPreferences',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'comicReaderPreferences', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  comicReaderPreferencesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'comicReaderPreferences',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'concurrentDownloads'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'concurrentDownloads'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'concurrentDownloads', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'concurrentDownloads',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'concurrentDownloads',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'concurrentDownloads',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cookiesListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cookiesList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cookiesListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cookiesList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cookiesListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cookiesList', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cookiesListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cookiesList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cookiesListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cookiesList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cookiesListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cookiesList', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cookiesListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cookiesList', length, include, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cookiesListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cookiesList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customDns'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customDns'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'customDns',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'customDns',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customDns', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  customDnsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customDns', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDohUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customDohUrl'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  customDohUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customDohUrl'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDohUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'customDohUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  customDohUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'customDohUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDohUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'customDohUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDohUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'customDohUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  customDohUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'customDohUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDohUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'customDohUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDohUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'customDohUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDohUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'customDohUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  customDohUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customDohUrl', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  customDohUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customDohUrl', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dateFormat'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  dateFormatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dateFormat'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateFormat',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dateFormat',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateFormat', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  dateFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dateFormat', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> debandingTypeEqualTo(
    DebandingType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'debandingType', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  debandingTypeGreaterThan(DebandingType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'debandingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> debandingTypeLessThan(
    DebandingType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'debandingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> debandingTypeBetween(
    DebandingType lower,
    DebandingType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'debandingType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'defaultDoubleTapToSkipLength'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'defaultDoubleTapToSkipLength',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultDoubleTapToSkipLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultDoubleTapToSkipLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultDoubleTapToSkipLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultDoubleTapToSkipLength',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'defaultPlayBackSpeed'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'defaultPlayBackSpeed'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultPlayBackSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultPlayBackSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultPlayBackSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultPlayBackSpeed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'defaultSkipIntroLength'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'defaultSkipIntroLength'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultSkipIntroLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultSkipIntroLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultSkipIntroLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultSkipIntroLength',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSubtitleLangIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'defaultSubtitleLang'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSubtitleLangIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'defaultSubtitleLang'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  deleteDownloadAfterReadingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'deleteDownloadAfterReading'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  deleteDownloadAfterReadingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'deleteDownloadAfterReading',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  deleteDownloadAfterReadingEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'deleteDownloadAfterReading',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  developerModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'developerMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  developerModeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'developerMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> developerModeEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'developerMode', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  disableSectionTypeEqualTo(SectionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'disableSectionType', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  disableSectionTypeGreaterThan(SectionType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'disableSectionType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  disableSectionTypeLessThan(SectionType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'disableSectionType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  disableSectionTypeBetween(
    SectionType lower,
    SectionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'disableSectionType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> displayTypeEqualTo(
    DisplayType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'displayType', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  displayTypeGreaterThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'displayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> displayTypeLessThan(
    DisplayType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'displayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> displayTypeBetween(
    DisplayType lower,
    DisplayType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'displayType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> doHEnabledIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'doHEnabled'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doHEnabledIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'doHEnabled'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> doHEnabledEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'doHEnabled', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doHProviderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'doHProviderId'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doHProviderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'doHProviderId'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> doHProviderIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'doHProviderId', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doHProviderIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'doHProviderId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> doHProviderIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'doHProviderId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> doHProviderIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'doHProviderId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doublePageAutoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'doublePageAuto'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doublePageAutoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'doublePageAuto'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> doublePageAutoEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'doublePageAuto', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadDelaySecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'downloadDelaySeconds'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadDelaySecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'downloadDelaySeconds'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadDelaySecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'downloadDelaySeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadDelaySecondsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'downloadDelaySeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadDelaySecondsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'downloadDelaySeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadDelaySecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'downloadDelaySeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'downloadLocalFolderName'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'downloadLocalFolderName'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'downloadLocalFolderName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'downloadLocalFolderName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'downloadLocalFolderName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'downloadLocalFolderName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'downloadLocalFolderName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'downloadLocalFolderName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'downloadLocalFolderName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'downloadLocalFolderName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'downloadLocalFolderName',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocalFolderNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'downloadLocalFolderName',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'downloadLocation'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'downloadLocation'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'downloadLocation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'downloadLocation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'downloadLocation', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'downloadLocation', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadOnlyOnWifiIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'downloadOnlyOnWifi'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadOnlyOnWifiIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'downloadOnlyOnWifi'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadOnlyOnWifiEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'downloadOnlyOnWifi', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'downloadQueueOrder'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'downloadQueueOrder'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'downloadQueueOrder', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'downloadQueueOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'downloadQueueOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'downloadQueueOrder',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'downloadQueueOrder',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'downloadQueueOrder', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'downloadQueueOrder', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'downloadQueueOrder', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'downloadQueueOrder',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadQueueOrderLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'downloadQueueOrder',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadedOnlyModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'downloadedOnlyMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadedOnlyModeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'downloadedOnlyMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadedOnlyModeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'downloadedOnlyMode', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAniSkipIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableAniSkip'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAniSkipIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'enableAniSkip'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> enableAniSkipEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'enableAniSkip', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAudioPitchCorrectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableAudioPitchCorrection'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAudioPitchCorrectionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'enableAudioPitchCorrection',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAudioPitchCorrectionEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'enableAudioPitchCorrection',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAutoSkipIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableAutoSkip'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAutoSkipIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'enableAutoSkip'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> enableAutoSkipEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'enableAutoSkip', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableDiscordRpcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableDiscordRpc'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableDiscordRpcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'enableDiscordRpc'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableDiscordRpcEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'enableDiscordRpc', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableGpuNextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableGpuNext'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableGpuNextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'enableGpuNext'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> enableGpuNextEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'enableGpuNext', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableHardwareAccelerationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableHardwareAcceleration'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableHardwareAccelerationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'enableHardwareAcceleration',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableHardwareAccelerationEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'enableHardwareAcceleration',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> enableLogsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableLogs'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableLogsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'enableLogs'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> enableLogsEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'enableLogs', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'extensionServerPath'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'extensionServerPath'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'extensionServerPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'extensionServerPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'extensionServerPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'extensionServerPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'extensionServerPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'extensionServerPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'extensionServerPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'extensionServerPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'extensionServerPath', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  extensionServerPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'extensionServerPath',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'filterScanlatorList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'filterScanlatorList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'filterScanlatorList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'filterScanlatorList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'filterScanlatorList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'filterScanlatorList', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'filterScanlatorList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'filterScanlatorList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexColorSchemeBlendLevelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'flexColorSchemeBlendLevel'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexColorSchemeBlendLevelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'flexColorSchemeBlendLevel'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexColorSchemeBlendLevelEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'flexColorSchemeBlendLevel',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexColorSchemeBlendLevelGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'flexColorSchemeBlendLevel',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexColorSchemeBlendLevelLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'flexColorSchemeBlendLevel',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexColorSchemeBlendLevelBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'flexColorSchemeBlendLevel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexSchemeColorIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'flexSchemeColorIndex'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexSchemeColorIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'flexSchemeColorIndex'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexSchemeColorIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'flexSchemeColorIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexSchemeColorIndexGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'flexSchemeColorIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexSchemeColorIndexLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'flexSchemeColorIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexSchemeColorIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'flexSchemeColorIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  followSystemThemeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'followSystemTheme'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  followSystemThemeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'followSystemTheme'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  followSystemThemeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'followSystemTheme', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  forceLandscapePlayerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'forceLandscapePlayer'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  forceLandscapePlayerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'forceLandscapePlayer'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  forceLandscapePlayerEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'forceLandscapePlayer',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenPlayerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fullScreenPlayer'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenPlayerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fullScreenPlayer'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenPlayerEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fullScreenPlayer', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenReaderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fullScreenReader'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenReaderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fullScreenReader'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenReaderEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fullScreenReader', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideDiscordRpcInIncognitoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hideDiscordRpcInIncognito'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideDiscordRpcInIncognitoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hideDiscordRpcInIncognito'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideDiscordRpcInIncognitoEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hideDiscordRpcInIncognito',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hideItemsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hideItems'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hideItemsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hideItems'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hideItems',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'hideItems',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hideItems', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'hideItems', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'hideItems', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hideItemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'hideItems', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'hideItems', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'hideItems', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'hideItems', length, include, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hideItems',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hwdecMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hwdecMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hwdecMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'hwdecMode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hwdecMode', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hwdecModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'hwdecMode', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  incognitoModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'incognitoMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  incognitoModeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'incognitoMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> incognitoModeEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'incognitoMode', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'jrePath'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'jrePath'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'jrePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'jrePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'jrePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'jrePath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'jrePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'jrePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'jrePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'jrePath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'jrePath', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> jrePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'jrePath', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  keepScreenOnReaderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'keepScreenOnReader'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  keepScreenOnReaderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'keepScreenOnReader'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  keepScreenOnReaderEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'keepScreenOnReader', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastAutoLibraryUpdateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastAutoLibraryUpdate'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastAutoLibraryUpdateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastAutoLibraryUpdate'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastAutoLibraryUpdateEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastAutoLibraryUpdate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastAutoLibraryUpdateGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastAutoLibraryUpdate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastAutoLibraryUpdateLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastAutoLibraryUpdate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastAutoLibraryUpdateBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastAutoLibraryUpdate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastTrackerLibraryLocation'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'lastTrackerLibraryLocation',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastTrackerLibraryLocation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastTrackerLibraryLocation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastTrackerLibraryLocation',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'lastTrackerLibraryLocation',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryDownloadedChaptersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryDownloadedChapters'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryDownloadedChaptersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryDownloadedChapters'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryDownloadedChaptersEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryDownloadedChapters',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterAnimeBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterAnimeBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterAnimeBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterAnimeBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterAnimeBookMarkedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeCompletedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterAnimeCompletedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeCompletedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterAnimeCompletedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeCompletedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeCompletedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeCompletedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterAnimeCompletedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeCompletedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterAnimeCompletedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeCompletedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterAnimeCompletedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterAnimeDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterAnimeDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterAnimeDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterAnimeDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterAnimeDownloadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryFilterAnimeSourceIds'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterAnimeSourceIds',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterAnimeSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterAnimeSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterAnimeSourceIds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'libraryFilterAnimeSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'libraryFilterAnimeSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsElementContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'libraryFilterAnimeSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsElementMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'libraryFilterAnimeSourceIds',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeSourceIds',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'libraryFilterAnimeSourceIds',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterAnimeSourceIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'libraryFilterAnimeSourceIds', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterAnimeSourceIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterAnimeSourceIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterAnimeSourceIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeSourceIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterAnimeSourceIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterAnimeStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterAnimeStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterAnimeStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterAnimeStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterAnimeStartedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeTrackingTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterAnimeTrackingType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeTrackingTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterAnimeTrackingType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeTrackingTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeTrackingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeTrackingTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterAnimeTrackingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeTrackingTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterAnimeTrackingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeTrackingTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterAnimeTrackingType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryFilterAnimeUnreadType'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterAnimeUnreadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterAnimeUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterAnimeUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterAnimeUnreadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasBookMarkedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterMangasBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasBookMarkedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterMangasBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasBookMarkedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasBookMarkedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterMangasBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasBookMarkedTypeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterMangasBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasBookMarkedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterMangasBookMarkedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasCompletedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterMangasCompletedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasCompletedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterMangasCompletedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasCompletedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasCompletedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasCompletedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterMangasCompletedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasCompletedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterMangasCompletedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasCompletedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterMangasCompletedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasDownloadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterMangasDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasDownloadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterMangasDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasDownloadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasDownloadTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterMangasDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasDownloadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterMangasDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasDownloadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterMangasDownloadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryFilterMangasSourceIds'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterMangasSourceIds',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterMangasSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterMangasSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterMangasSourceIds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'libraryFilterMangasSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'libraryFilterMangasSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsElementContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'libraryFilterMangasSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsElementMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'libraryFilterMangasSourceIds',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasSourceIds',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'libraryFilterMangasSourceIds',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterMangasSourceIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterMangasSourceIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterMangasSourceIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterMangasSourceIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterMangasSourceIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasSourceIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterMangasSourceIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasStartedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterMangasStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasStartedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterMangasStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasStartedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasStartedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterMangasStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasStartedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterMangasStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasStartedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterMangasStartedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasTrackingTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterMangasTrackingType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasTrackingTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterMangasTrackingType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasTrackingTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasTrackingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasTrackingTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterMangasTrackingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasTrackingTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterMangasTrackingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasTrackingTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterMangasTrackingType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasUnreadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterMangasUnreadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasUnreadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterMangasUnreadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasUnreadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasUnreadTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterMangasUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasUnreadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterMangasUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasUnreadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterMangasUnreadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterNovelBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterNovelBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterNovelBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterNovelBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterNovelBookMarkedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelCompletedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterNovelCompletedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelCompletedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterNovelCompletedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelCompletedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelCompletedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelCompletedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterNovelCompletedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelCompletedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterNovelCompletedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelCompletedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterNovelCompletedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterNovelDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterNovelDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterNovelDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterNovelDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterNovelDownloadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryFilterNovelSourceIds'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterNovelSourceIds',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterNovelSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterNovelSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterNovelSourceIds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'libraryFilterNovelSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'libraryFilterNovelSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsElementContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'libraryFilterNovelSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsElementMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'libraryFilterNovelSourceIds',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelSourceIds',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'libraryFilterNovelSourceIds',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterNovelSourceIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'libraryFilterNovelSourceIds', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterNovelSourceIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterNovelSourceIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterNovelSourceIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelSourceIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'libraryFilterNovelSourceIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterNovelStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterNovelStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterNovelStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterNovelStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterNovelStartedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelTrackingTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterNovelTrackingType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelTrackingTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterNovelTrackingType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelTrackingTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelTrackingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelTrackingTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterNovelTrackingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelTrackingTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterNovelTrackingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelTrackingTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterNovelTrackingType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryFilterNovelUnreadType'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterNovelUnreadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterNovelUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterNovelUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterNovelUnreadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryLocalSourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryLocalSourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryLocalSourceEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'libraryLocalSource', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowCategoryTabsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryShowCategoryTabs'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowCategoryTabsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryShowCategoryTabs'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowCategoryTabsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryShowCategoryTabs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowContinueReadingButtonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowContinueReadingButtonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowContinueReadingButtonEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryShowContinueReadingButton',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowLanguageEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'libraryShowLanguage', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowNumbersOfItemsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryShowNumbersOfItems'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowNumbersOfItemsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryShowNumbersOfItems'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowNumbersOfItemsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryShowNumbersOfItems',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> localFoldersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'localFolders'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'localFolders'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localFolders',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localFolders',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localFolders',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localFolders',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'localFolders',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'localFolders',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'localFolders',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'localFolders',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'localFolders', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'localFolders', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'localFolders', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'localFolders', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'localFolders', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'localFolders', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'localFolders', length, include, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  localFoldersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localFolders',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> localeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'locale'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> localeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'locale'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mangaExtensionsRepo',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'mangaExtensionsRepo', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'mangaExtensionsRepo', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'mangaExtensionsRepo', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mangaExtensionsRepo',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mangaExtensionsRepo',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaGridSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaGridSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> mangaGridSizeEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaGridSize', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaGridSizeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> mangaGridSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> mangaGridSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaGridSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaHomeDisplayTypeEqualTo(DisplayType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mangaHomeDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaHomeDisplayTypeGreaterThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaHomeDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaHomeDisplayTypeLessThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaHomeDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaHomeDisplayTypeBetween(
    DisplayType lower,
    DisplayType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaHomeDisplayType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'markEpisodeAsSeenType'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'markEpisodeAsSeenType'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'markEpisodeAsSeenType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'markEpisodeAsSeenType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'markEpisodeAsSeenType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'markEpisodeAsSeenType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mergeLibraryNavMobileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mergeLibraryNavMobile'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mergeLibraryNavMobileIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mergeLibraryNavMobile'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mergeLibraryNavMobileEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mergeLibraryNavMobile',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  namedLocalFoldersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'namedLocalFolders'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  namedLocalFoldersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'namedLocalFolders'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  namedLocalFoldersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'namedLocalFolders', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  namedLocalFoldersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'namedLocalFolders', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  namedLocalFoldersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'namedLocalFolders', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  namedLocalFoldersLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'namedLocalFolders', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  namedLocalFoldersLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'namedLocalFolders',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  namedLocalFoldersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'namedLocalFolders',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'navigationOrder'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'navigationOrder'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'navigationOrder',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'navigationOrder',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'navigationOrder', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'navigationOrder', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'navigationOrder', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'navigationOrder', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'navigationOrder', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'navigationOrder', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'navigationOrder',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'navigationOrder',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelDisplayTypeEqualTo(DisplayType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelDisplayType', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelDisplayTypeGreaterThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelDisplayTypeLessThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelDisplayTypeBetween(
    DisplayType lower,
    DisplayType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelDisplayType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'novelExtensionsRepo',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'novelExtensionsRepo', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'novelExtensionsRepo', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'novelExtensionsRepo', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'novelExtensionsRepo',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'novelExtensionsRepo',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelFontFamily'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelFontFamily'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelFontFamily',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'novelFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'novelFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'novelFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'novelFontFamily',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelFontFamily', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontFamilyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'novelFontFamily', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelFontSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelFontSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelFontSizeEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelFontSize', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontSizeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelFontSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelFontSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelFontSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelFontSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelFontSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelGridSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelGridSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelGridSizeEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelGridSize', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelGridSizeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelGridSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelGridSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelGridSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryDownloadedChaptersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'novelLibraryDownloadedChapters',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryDownloadedChaptersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'novelLibraryDownloadedChapters',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryDownloadedChaptersEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryDownloadedChapters',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryLocalSourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelLibraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryLocalSourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelLibraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryLocalSourceEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryLocalSource',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowCategoryTabsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelLibraryShowCategoryTabs'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowCategoryTabsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'novelLibraryShowCategoryTabs',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowCategoryTabsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryShowCategoryTabs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowContinueReadingButtonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'novelLibraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowContinueReadingButtonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'novelLibraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowContinueReadingButtonEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryShowContinueReadingButton',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelLibraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelLibraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowLanguageEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryShowLanguage',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowNumbersOfItemsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'novelLibraryShowNumbersOfItems',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowNumbersOfItemsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'novelLibraryShowNumbersOfItems',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowNumbersOfItemsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryShowNumbersOfItems',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderLineHeightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelReaderLineHeight'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderLineHeightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelReaderLineHeight'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderLineHeightEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelReaderLineHeight',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderLineHeightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelReaderLineHeight',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderLineHeightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelReaderLineHeight',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderLineHeightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelReaderLineHeight',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderPaddingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelReaderPadding'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderPaddingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelReaderPadding'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderPaddingEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelReaderPadding', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderPaddingGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelReaderPadding',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderPaddingLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelReaderPadding',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderPaddingBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelReaderPadding',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelReaderTextColor'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelReaderTextColor'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelReaderTextColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelReaderTextColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelReaderTextColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelReaderTextColor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'novelReaderTextColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'novelReaderTextColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'novelReaderTextColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'novelReaderTextColor',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelReaderTextColor', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderTextColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'novelReaderTextColor',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelReaderTheme'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelReaderTheme'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelReaderTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelReaderTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelReaderTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelReaderTheme',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'novelReaderTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'novelReaderTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'novelReaderTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'novelReaderTheme',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelReaderTheme', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelReaderThemeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'novelReaderTheme', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelRemoveExtraParagraphSpacingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'novelRemoveExtraParagraphSpacing',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelRemoveExtraParagraphSpacingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'novelRemoveExtraParagraphSpacing',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelRemoveExtraParagraphSpacingEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelRemoveExtraParagraphSpacing',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelShowScrollPercentageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelShowScrollPercentage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelShowScrollPercentageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelShowScrollPercentage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelShowScrollPercentageEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelShowScrollPercentage',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelTapToScrollIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelTapToScroll'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelTapToScrollIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelTapToScroll'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelTapToScrollEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelTapToScroll', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelTextAlignEqualTo(
    NovelTextAlign value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelTextAlign', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelTextAlignGreaterThan(NovelTextAlign value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelTextAlign',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelTextAlignLessThan(NovelTextAlign value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelTextAlign',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelTextAlignBetween(
    NovelTextAlign lower,
    NovelTextAlign upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelTextAlign',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  onboardingCompletedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'onboardingCompleted'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  onboardingCompletedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'onboardingCompleted'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  onboardingCompletedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'onboardingCompleted', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  onlyIncludePinnedSourcesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'onlyIncludePinnedSources'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  onlyIncludePinnedSourcesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'onlyIncludePinnedSources'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  onlyIncludePinnedSourcesEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'onlyIncludePinnedSources',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'personalPageModeList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'personalPageModeList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalPageModeList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'personalPageModeList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'personalPageModeList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalPageModeList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalPageModeList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalPageModeList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'personalReaderModeList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'personalReaderModeList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalReaderModeList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'personalReaderModeList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalReaderModeList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalReaderModeList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalReaderModeList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalReaderModeList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  playerSubtitleSettingsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'playerSubtitleSettings'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  playerSubtitleSettingsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'playerSubtitleSettings'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pureBlackDarkModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pureBlackDarkMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pureBlackDarkModeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pureBlackDarkMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pureBlackDarkModeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pureBlackDarkMode', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  relativeTimesTampsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'relativeTimesTamps'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  relativeTimesTampsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'relativeTimesTamps'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  relativeTimesTampsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'relativeTimesTamps', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  relativeTimesTampsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'relativeTimesTamps',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  relativeTimesTampsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'relativeTimesTamps',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  relativeTimesTampsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'relativeTimesTamps',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowCoverImageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'rpcShowCoverImage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowCoverImageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'rpcShowCoverImage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowCoverImageEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rpcShowCoverImage', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowReadingWatchingProgressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'rpcShowReadingWatchingProgress',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowReadingWatchingProgressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'rpcShowReadingWatchingProgress',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowReadingWatchingProgressEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rpcShowReadingWatchingProgress',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> rpcShowTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'rpcShowTitle'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'rpcShowTitle'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> rpcShowTitleEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rpcShowTitle', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  saveAsCBZArchiveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'saveAsCBZArchive'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  saveAsCBZArchiveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'saveAsCBZArchive'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  saveAsCBZArchiveEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'saveAsCBZArchive', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  savedSearchesListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'savedSearchesList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  savedSearchesListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'savedSearchesList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  savedSearchesListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'savedSearchesList', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  savedSearchesListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'savedSearchesList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  savedSearchesListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'savedSearchesList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  savedSearchesListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'savedSearchesList', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  savedSearchesListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'savedSearchesList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  savedSearchesListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'savedSearchesList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> showNSFWIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'showNSFW'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> showNSFWIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'showNSFW'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> showNSFWEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showNSFW', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  showNavDoubleTapTooltipIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'showNavDoubleTapTooltip'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  showNavDoubleTapTooltipIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'showNavDoubleTapTooltip'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  showNavDoubleTapTooltipEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'showNavDoubleTapTooltip',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  showSourceBadgeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'showSourceBadge'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  showSourceBadgeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'showSourceBadge'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  showSourceBadgeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showSourceBadge', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sortChapterList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sortChapterList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sortChapterList', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sortChapterList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sortChapterList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sortChapterList', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sortChapterList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sortChapterList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortLibraryAnimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sortLibraryAnime'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortLibraryAnimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sortLibraryAnime'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortLibraryMangaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sortLibraryManga'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortLibraryMangaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sortLibraryManga'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortLibraryNovelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sortLibraryNovel'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortLibraryNovelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sortLibraryNovel'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startDatebackup'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startDatebackup'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startDatebackup', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startDatebackup',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startDatebackup',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startDatebackup',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> themeIsDarkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'themeIsDark'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  themeIsDarkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'themeIsDark'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> themeIsDarkEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'themeIsDark', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'ttsLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  ttsLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'ttsLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsLanguageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ttsLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  ttsLanguageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ttsLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsLanguageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ttsLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsLanguageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ttsLanguage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsLanguageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'ttsLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'ttsLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsLanguageContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'ttsLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsLanguageMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'ttsLanguage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ttsLanguage', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  ttsLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ttsLanguage', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsPitchIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'ttsPitch'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsPitchIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'ttsPitch'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsPitchEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ttsPitch',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsPitchGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ttsPitch',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsPitchLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ttsPitch',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsPitchBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ttsPitch',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  ttsSpeechRateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'ttsSpeechRate'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  ttsSpeechRateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'ttsSpeechRate'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsSpeechRateEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ttsSpeechRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  ttsSpeechRateGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ttsSpeechRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsSpeechRateLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ttsSpeechRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsSpeechRateBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ttsSpeechRate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'ttsVoice'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'ttsVoice'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ttsVoice',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ttsVoice',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ttsVoice',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ttsVoice',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'ttsVoice',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'ttsVoice',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'ttsVoice',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'ttsVoice',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ttsVoice', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> ttsVoiceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ttsVoice', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  tvAnimeOnlyOverrideIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'tvAnimeOnlyOverride'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  tvAnimeOnlyOverrideIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'tvAnimeOnlyOverride'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  tvAnimeOnlyOverrideEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tvAnimeOnlyOverride', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  tvHomeGenreRowsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'tvHomeGenreRows'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  tvHomeGenreRowsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'tvHomeGenreRows'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  tvHomeGenreRowsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tvHomeGenreRows', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> tvHomeStyleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'tvHomeStyle'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  tvHomeStyleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'tvHomeStyle'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> tvHomeStyleEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tvHomeStyle', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  tvPlayerStyleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'tvPlayerStyle'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  tvPlayerStyleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'tvPlayerStyle'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> tvPlayerStyleEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tvPlayerStyle', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateErrorsListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updateErrorsList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateErrorsListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updateErrorsList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateErrorsListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'updateErrorsList', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateErrorsListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'updateErrorsList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateErrorsListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'updateErrorsList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateErrorsListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'updateErrorsList', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateErrorsListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'updateErrorsList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateErrorsListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'updateErrorsList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateProgressAfterReadingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updateProgressAfterReading'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateProgressAfterReadingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'updateProgressAfterReading',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateProgressAfterReadingEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'updateProgressAfterReading',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  useFloatingNavigationBarIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'useFloatingNavigationBar'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  useFloatingNavigationBarIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'useFloatingNavigationBar'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  useFloatingNavigationBarEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'useFloatingNavigationBar',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useLibassIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'useLibass'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useLibassIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'useLibass'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useLibassEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'useLibass', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useMpvConfigIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'useMpvConfig'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  useMpvConfigIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'useMpvConfig'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useMpvConfigEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'useMpvConfig', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useYUV420PIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'useYUV420P'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  useYUV420PIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'useYUV420P'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useYUV420PEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'useYUV420P', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'userAgent'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'userAgent'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userAgent',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userAgent',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userAgent', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  userAgentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userAgent', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  volumeBoostCapIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'volumeBoostCap'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  volumeBoostCapIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'volumeBoostCap'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> volumeBoostCapEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'volumeBoostCap', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  volumeBoostCapGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'volumeBoostCap',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  volumeBoostCapLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'volumeBoostCap',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> volumeBoostCapBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'volumeBoostCap',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SettingsQueryObject
    on QueryBuilder<Settings, Settings, QFilterCondition> {
  QueryBuilder<Settings, Settings, QAfterFilterCondition> algorithmWeights(
    FilterQuery<AlgorithmWeights> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'algorithmWeights');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoElement(FilterQuery<Repo> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'animeExtensionsRepo');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesElement(FilterQuery<AutoScrollPages> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'autoScrollPages');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListElement(FilterQuery<ChapterFilterBookmarked> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'chapterFilterBookmarkedList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterDownloadedListElement(FilterQuery<ChapterFilterDownloaded> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'chapterFilterDownloadedList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterUnreadListElement(FilterQuery<ChapterFilterUnread> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'chapterFilterUnreadList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListElement(FilterQuery<ChapterPageIndex> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'chapterPageIndexList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cookiesListElement(
    FilterQuery<MCookie> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'cookiesList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> defaultSubtitleLang(
    FilterQuery<L10nLocale> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'defaultSubtitleLang');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListElement(FilterQuery<FilterScanlator> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'filterScanlatorList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> locale(
    FilterQuery<L10nLocale> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'locale');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoElement(FilterQuery<Repo> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'mangaExtensionsRepo');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  namedLocalFoldersElement(FilterQuery<LocalFolder> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'namedLocalFolders');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoElement(FilterQuery<Repo> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'novelExtensionsRepo');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListElement(FilterQuery<PersonalPageMode> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'personalPageModeList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListElement(FilterQuery<PersonalReaderMode> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'personalReaderModeList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  playerSubtitleSettings(FilterQuery<PlayerSubtitleSettings> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'playerSubtitleSettings');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  savedSearchesListElement(FilterQuery<SavedSearch> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'savedSearchesList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListElement(FilterQuery<SortChapter> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sortChapterList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sortLibraryAnime(
    FilterQuery<SortLibraryManga> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sortLibraryAnime');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sortLibraryManga(
    FilterQuery<SortLibraryManga> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sortLibraryManga');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sortLibraryNovel(
    FilterQuery<SortLibraryManga> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sortLibraryNovel');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateErrorsListElement(FilterQuery<UpdateError> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'updateErrorsList');
    });
  }
}

extension SettingsQueryLinks
    on QueryBuilder<Settings, Settings, QFilterCondition> {
  QueryBuilder<Settings, Settings, QAfterFilterCondition> sources(
    FilterQuery<Source> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'sources');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sourcesLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sources', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sourcesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sources', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sourcesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sources', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sourcesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sources', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sourcesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sources', length, include, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sourcesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'sources',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension SettingsQuerySortBy on QueryBuilder<Settings, Settings, QSortBy> {
  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAllowConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowConcurrentDownloads', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAllowConcurrentDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowConcurrentDownloads', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAndroidProxyServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidProxyServer', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAndroidProxyServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidProxyServer', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAniSkipTimeoutLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniSkipTimeoutLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAniSkipTimeoutLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniSkipTimeoutLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAnimeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAnimeDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAnimeGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAnimeGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryLocalSource', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'animeLibraryShowContinueReadingButton',
        Sort.asc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'animeLibraryShowContinueReadingButton',
        Sort.desc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAppFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appFontFamily', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAppFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appFontFamily', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAppLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appLockEnabled', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAppLockEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appLockEnabled', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAppUiScale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appUiScale', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAppUiScaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appUiScale', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAskDownloadDestination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'askDownloadDestination', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAskDownloadDestinationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'askDownloadDestination', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAudioChannels() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioChannels', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAudioChannelsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioChannels', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAudioPreferredLanguages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPreferredLanguages', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAudioPreferredLanguagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPreferredLanguages', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAutoBackupLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoBackupLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupLocation', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAutoExtensionsUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoExtensionsUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoExtensionsUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoExtensionsUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoLibraryUpdateInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoLibraryUpdateInterval', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoLibraryUpdateIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoLibraryUpdateInterval', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoLibraryUpdateWifiOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoLibraryUpdateWifiOnly', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoLibraryUpdateWifiOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoLibraryUpdateWifiOnly', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAutoPlayNextEpisode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayNextEpisode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoPlayNextEpisodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayNextEpisode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoReadDuplicateChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoReadDuplicateChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoReadDuplicateChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoReadDuplicateChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoStartExtensionServerOnLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartExtensionServerOnLaunch', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoStartExtensionServerOnLaunchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartExtensionServerOnLaunch', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByBackupCompressionLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupCompressionLevel', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByBackupCompressionLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupCompressionLevel', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByBackupEncryptionEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupEncryptionEnabled', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByBackupEncryptionEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupEncryptionEnabled', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBackupFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFrequency', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBackupFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFrequency', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBtServerAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerAddress', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBtServerAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerAddress', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBtServerPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerPort', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBtServerPortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerPort', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCfProxyUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cfProxyUrl', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCfProxyUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cfProxyUrl', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByChapterSwipeEndAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterSwipeEndAction', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByChapterSwipeEndActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterSwipeEndAction', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByChapterSwipeStartAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterSwipeStartAction', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByChapterSwipeStartActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterSwipeStartAction', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCheckForAppUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForAppUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByCheckForAppUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForAppUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByCheckForExtensionUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForExtensionUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByCheckForExtensionUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForExtensionUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByClearChapterCacheOnAppLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearChapterCacheOnAppLaunch', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByClearChapterCacheOnAppLaunchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearChapterCacheOnAppLaunch', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByComicReaderPreferences() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comicReaderPreferences', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByComicReaderPreferencesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comicReaderPreferences', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concurrentDownloads', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByConcurrentDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concurrentDownloads', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCustomDns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDns', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCustomDnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDns', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCustomDohUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDohUrl', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCustomDohUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDohUrl', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDateFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDateFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDebandingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debandingType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDebandingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debandingType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDefaultDoubleTapToSkipLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDoubleTapToSkipLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDefaultDoubleTapToSkipLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDoubleTapToSkipLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDefaultPlayBackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlayBackSpeed', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDefaultPlayBackSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlayBackSpeed', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDefaultSkipIntroLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSkipIntroLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDefaultSkipIntroLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSkipIntroLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDeleteDownloadAfterReading() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteDownloadAfterReading', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDeleteDownloadAfterReadingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteDownloadAfterReading', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDeveloperMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'developerMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDeveloperModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'developerMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDisableSectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableSectionType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDisableSectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableSectionType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDoHEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doHEnabled', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDoHEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doHEnabled', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDoHProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doHProviderId', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDoHProviderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doHProviderId', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDoublePageAuto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doublePageAuto', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDoublePageAutoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doublePageAuto', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDownloadDelaySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadDelaySeconds', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDownloadDelaySecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadDelaySeconds', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDownloadLocalFolderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocalFolderName', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDownloadLocalFolderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocalFolderName', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDownloadLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDownloadLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocation', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDownloadOnlyOnWifi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadOnlyOnWifi', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDownloadOnlyOnWifiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadOnlyOnWifi', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDownloadedOnlyMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedOnlyMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDownloadedOnlyModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedOnlyMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableAniSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAniSkip', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableAniSkipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAniSkip', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByEnableAudioPitchCorrection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAudioPitchCorrection', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByEnableAudioPitchCorrectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAudioPitchCorrection', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableAutoSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAutoSkip', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableAutoSkipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAutoSkip', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableDiscordRpc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDiscordRpc', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableDiscordRpcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDiscordRpc', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableGpuNext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableGpuNext', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableGpuNextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableGpuNext', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByEnableHardwareAcceleration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHardwareAcceleration', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByEnableHardwareAccelerationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHardwareAcceleration', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableLogs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableLogs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableLogsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableLogs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByExtensionServerPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extensionServerPath', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByExtensionServerPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extensionServerPath', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByFlexColorSchemeBlendLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexColorSchemeBlendLevel', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByFlexColorSchemeBlendLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexColorSchemeBlendLevel', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFlexSchemeColorIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeColorIndex', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByFlexSchemeColorIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeColorIndex', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFollowSystemTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followSystemTheme', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFollowSystemThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followSystemTheme', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByForceLandscapePlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forceLandscapePlayer', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByForceLandscapePlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forceLandscapePlayer', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFullScreenPlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenPlayer', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFullScreenPlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenPlayer', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFullScreenReader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenReader', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFullScreenReaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenReader', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByHideDiscordRpcInIncognito() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideDiscordRpcInIncognito', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByHideDiscordRpcInIncognitoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideDiscordRpcInIncognito', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByHwdecMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hwdecMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByHwdecModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hwdecMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByIncognitoMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incognitoMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByIncognitoModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incognitoMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByJrePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jrePath', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByJrePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jrePath', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByKeepScreenOnReader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keepScreenOnReader', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByKeepScreenOnReaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keepScreenOnReader', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByLastAutoLibraryUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAutoLibraryUpdate', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLastAutoLibraryUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAutoLibraryUpdate', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLastTrackerLibraryLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTrackerLibraryLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLastTrackerLibraryLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTrackerLibraryLocation', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeCompletedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeCompletedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeCompletedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeCompletedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeTrackingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeTrackingType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeTrackingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeTrackingType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeUnreadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasCompletedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasCompletedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasCompletedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasCompletedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasTrackingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasTrackingType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasTrackingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasTrackingType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterMangasUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasUnreadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelCompletedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelCompletedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelCompletedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelCompletedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelTrackingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelTrackingType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelTrackingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelTrackingType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelUnreadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryLocalSource', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowContinueReadingButton', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowContinueReadingButton', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByMangaGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByMangaGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByMangaHomeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaHomeDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByMangaHomeDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaHomeDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByMarkEpisodeAsSeenType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markEpisodeAsSeenType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByMarkEpisodeAsSeenTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markEpisodeAsSeenType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByMergeLibraryNavMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mergeLibraryNavMobile', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByMergeLibraryNavMobileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mergeLibraryNavMobile', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontFamily', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontFamily', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryLocalSource', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'novelLibraryShowContinueReadingButton',
        Sort.asc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'novelLibraryShowContinueReadingButton',
        Sort.desc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelReaderLineHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderLineHeight', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelReaderLineHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderLineHeight', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelReaderPadding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderPadding', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelReaderPaddingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderPadding', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelReaderTextColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderTextColor', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelReaderTextColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderTextColor', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelReaderTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderTheme', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelReaderThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderTheme', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelRemoveExtraParagraphSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelRemoveExtraParagraphSpacing', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelRemoveExtraParagraphSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelRemoveExtraParagraphSpacing', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelShowScrollPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelShowScrollPercentage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelShowScrollPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelShowScrollPercentage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelTapToScroll() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTapToScroll', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelTapToScrollDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTapToScroll', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelTextAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTextAlign', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelTextAlignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTextAlign', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByOnlyIncludePinnedSources() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlyIncludePinnedSources', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByOnlyIncludePinnedSourcesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlyIncludePinnedSources', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByPureBlackDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pureBlackDarkMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByPureBlackDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pureBlackDarkMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByRelativeTimesTamps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimesTamps', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByRelativeTimesTampsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimesTamps', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByRpcShowCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowCoverImage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByRpcShowCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowCoverImage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByRpcShowReadingWatchingProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowReadingWatchingProgress', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByRpcShowReadingWatchingProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowReadingWatchingProgress', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByRpcShowTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowTitle', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByRpcShowTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowTitle', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortBySaveAsCBZArchive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveAsCBZArchive', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortBySaveAsCBZArchiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveAsCBZArchive', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByShowNSFW() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNSFW', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByShowNSFWDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNSFW', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByShowNavDoubleTapTooltip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNavDoubleTapTooltip', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByShowNavDoubleTapTooltipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNavDoubleTapTooltip', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByShowSourceBadge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showSourceBadge', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByShowSourceBadgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showSourceBadge', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByStartDatebackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDatebackup', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByStartDatebackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDatebackup', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByThemeIsDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeIsDark', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByThemeIsDarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeIsDark', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTtsLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTtsLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTtsPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsPitch', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTtsPitchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsPitch', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTtsSpeechRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsSpeechRate', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTtsSpeechRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsSpeechRate', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTtsVoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsVoice', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTtsVoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsVoice', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTvAnimeOnlyOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvAnimeOnlyOverride', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByTvAnimeOnlyOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvAnimeOnlyOverride', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTvHomeGenreRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvHomeGenreRows', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTvHomeGenreRowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvHomeGenreRows', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTvHomeStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvHomeStyle', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTvHomeStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvHomeStyle', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTvPlayerStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvPlayerStyle', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByTvPlayerStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvPlayerStyle', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByUpdateProgressAfterReading() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateProgressAfterReading', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByUpdateProgressAfterReadingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateProgressAfterReading', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByUseFloatingNavigationBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useFloatingNavigationBar', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByUseFloatingNavigationBarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useFloatingNavigationBar', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseLibass() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useLibass', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseLibassDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useLibass', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseMpvConfig() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMpvConfig', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseMpvConfigDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMpvConfig', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseYUV420P() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYUV420P', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseYUV420PDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYUV420P', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUserAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAgent', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUserAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAgent', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByVolumeBoostCap() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeBoostCap', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByVolumeBoostCapDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeBoostCap', Sort.desc);
    });
  }
}

extension SettingsQuerySortThenBy
    on QueryBuilder<Settings, Settings, QSortThenBy> {
  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAllowConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowConcurrentDownloads', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAllowConcurrentDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowConcurrentDownloads', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAndroidProxyServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidProxyServer', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAndroidProxyServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidProxyServer', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAniSkipTimeoutLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniSkipTimeoutLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAniSkipTimeoutLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniSkipTimeoutLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAnimeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAnimeDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAnimeGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAnimeGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryLocalSource', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'animeLibraryShowContinueReadingButton',
        Sort.asc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'animeLibraryShowContinueReadingButton',
        Sort.desc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAppFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appFontFamily', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAppFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appFontFamily', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAppLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appLockEnabled', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAppLockEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appLockEnabled', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAppUiScale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appUiScale', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAppUiScaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appUiScale', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAskDownloadDestination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'askDownloadDestination', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAskDownloadDestinationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'askDownloadDestination', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAudioChannels() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioChannels', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAudioChannelsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioChannels', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAudioPreferredLanguages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPreferredLanguages', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAudioPreferredLanguagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPreferredLanguages', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAutoBackupLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoBackupLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupLocation', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAutoExtensionsUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoExtensionsUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoExtensionsUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoExtensionsUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoLibraryUpdateInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoLibraryUpdateInterval', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoLibraryUpdateIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoLibraryUpdateInterval', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoLibraryUpdateWifiOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoLibraryUpdateWifiOnly', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoLibraryUpdateWifiOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoLibraryUpdateWifiOnly', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAutoPlayNextEpisode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayNextEpisode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoPlayNextEpisodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayNextEpisode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoReadDuplicateChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoReadDuplicateChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoReadDuplicateChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoReadDuplicateChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoStartExtensionServerOnLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartExtensionServerOnLaunch', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoStartExtensionServerOnLaunchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartExtensionServerOnLaunch', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByBackupCompressionLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupCompressionLevel', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByBackupCompressionLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupCompressionLevel', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByBackupEncryptionEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupEncryptionEnabled', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByBackupEncryptionEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupEncryptionEnabled', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBackupFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFrequency', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBackupFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFrequency', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBtServerAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerAddress', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBtServerAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerAddress', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBtServerPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerPort', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBtServerPortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerPort', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCfProxyUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cfProxyUrl', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCfProxyUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cfProxyUrl', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByChapterSwipeEndAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterSwipeEndAction', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByChapterSwipeEndActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterSwipeEndAction', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByChapterSwipeStartAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterSwipeStartAction', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByChapterSwipeStartActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterSwipeStartAction', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCheckForAppUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForAppUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByCheckForAppUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForAppUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByCheckForExtensionUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForExtensionUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByCheckForExtensionUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForExtensionUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByClearChapterCacheOnAppLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearChapterCacheOnAppLaunch', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByClearChapterCacheOnAppLaunchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearChapterCacheOnAppLaunch', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByComicReaderPreferences() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comicReaderPreferences', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByComicReaderPreferencesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comicReaderPreferences', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concurrentDownloads', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByConcurrentDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concurrentDownloads', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCustomDns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDns', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCustomDnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDns', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCustomDohUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDohUrl', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCustomDohUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDohUrl', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDateFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDateFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDebandingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debandingType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDebandingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debandingType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDefaultDoubleTapToSkipLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDoubleTapToSkipLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDefaultDoubleTapToSkipLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDoubleTapToSkipLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDefaultPlayBackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlayBackSpeed', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDefaultPlayBackSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlayBackSpeed', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDefaultSkipIntroLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSkipIntroLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDefaultSkipIntroLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSkipIntroLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDeleteDownloadAfterReading() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteDownloadAfterReading', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDeleteDownloadAfterReadingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteDownloadAfterReading', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDeveloperMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'developerMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDeveloperModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'developerMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDisableSectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableSectionType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDisableSectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableSectionType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDoHEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doHEnabled', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDoHEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doHEnabled', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDoHProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doHProviderId', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDoHProviderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doHProviderId', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDoublePageAuto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doublePageAuto', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDoublePageAutoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doublePageAuto', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDownloadDelaySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadDelaySeconds', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDownloadDelaySecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadDelaySeconds', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDownloadLocalFolderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocalFolderName', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDownloadLocalFolderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocalFolderName', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDownloadLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDownloadLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocation', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDownloadOnlyOnWifi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadOnlyOnWifi', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDownloadOnlyOnWifiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadOnlyOnWifi', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDownloadedOnlyMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedOnlyMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDownloadedOnlyModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedOnlyMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableAniSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAniSkip', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableAniSkipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAniSkip', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByEnableAudioPitchCorrection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAudioPitchCorrection', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByEnableAudioPitchCorrectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAudioPitchCorrection', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableAutoSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAutoSkip', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableAutoSkipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAutoSkip', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableDiscordRpc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDiscordRpc', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableDiscordRpcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDiscordRpc', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableGpuNext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableGpuNext', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableGpuNextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableGpuNext', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByEnableHardwareAcceleration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHardwareAcceleration', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByEnableHardwareAccelerationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHardwareAcceleration', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableLogs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableLogs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableLogsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableLogs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByExtensionServerPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extensionServerPath', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByExtensionServerPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extensionServerPath', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByFlexColorSchemeBlendLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexColorSchemeBlendLevel', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByFlexColorSchemeBlendLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexColorSchemeBlendLevel', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFlexSchemeColorIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeColorIndex', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByFlexSchemeColorIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeColorIndex', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFollowSystemTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followSystemTheme', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFollowSystemThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followSystemTheme', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByForceLandscapePlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forceLandscapePlayer', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByForceLandscapePlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forceLandscapePlayer', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFullScreenPlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenPlayer', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFullScreenPlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenPlayer', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFullScreenReader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenReader', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFullScreenReaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenReader', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByHideDiscordRpcInIncognito() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideDiscordRpcInIncognito', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByHideDiscordRpcInIncognitoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideDiscordRpcInIncognito', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByHwdecMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hwdecMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByHwdecModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hwdecMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByIncognitoMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incognitoMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByIncognitoModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incognitoMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByJrePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jrePath', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByJrePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jrePath', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByKeepScreenOnReader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keepScreenOnReader', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByKeepScreenOnReaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keepScreenOnReader', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByLastAutoLibraryUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAutoLibraryUpdate', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLastAutoLibraryUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAutoLibraryUpdate', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLastTrackerLibraryLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTrackerLibraryLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLastTrackerLibraryLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTrackerLibraryLocation', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeCompletedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeCompletedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeCompletedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeCompletedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeTrackingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeTrackingType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeTrackingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeTrackingType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeUnreadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasCompletedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasCompletedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasCompletedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasCompletedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasTrackingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasTrackingType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasTrackingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasTrackingType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterMangasUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasUnreadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelCompletedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelCompletedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelCompletedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelCompletedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelTrackingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelTrackingType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelTrackingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelTrackingType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelUnreadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryLocalSource', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowContinueReadingButton', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowContinueReadingButton', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByMangaGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByMangaGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByMangaHomeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaHomeDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByMangaHomeDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaHomeDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByMarkEpisodeAsSeenType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markEpisodeAsSeenType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByMarkEpisodeAsSeenTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markEpisodeAsSeenType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByMergeLibraryNavMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mergeLibraryNavMobile', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByMergeLibraryNavMobileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mergeLibraryNavMobile', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontFamily', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontFamily', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryLocalSource', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'novelLibraryShowContinueReadingButton',
        Sort.asc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'novelLibraryShowContinueReadingButton',
        Sort.desc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelReaderLineHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderLineHeight', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelReaderLineHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderLineHeight', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelReaderPadding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderPadding', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelReaderPaddingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderPadding', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelReaderTextColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderTextColor', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelReaderTextColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderTextColor', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelReaderTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderTheme', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelReaderThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelReaderTheme', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelRemoveExtraParagraphSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelRemoveExtraParagraphSpacing', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelRemoveExtraParagraphSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelRemoveExtraParagraphSpacing', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelShowScrollPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelShowScrollPercentage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelShowScrollPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelShowScrollPercentage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelTapToScroll() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTapToScroll', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelTapToScrollDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTapToScroll', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelTextAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTextAlign', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelTextAlignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTextAlign', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByOnlyIncludePinnedSources() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlyIncludePinnedSources', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByOnlyIncludePinnedSourcesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlyIncludePinnedSources', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByPureBlackDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pureBlackDarkMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByPureBlackDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pureBlackDarkMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByRelativeTimesTamps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimesTamps', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByRelativeTimesTampsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimesTamps', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByRpcShowCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowCoverImage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByRpcShowCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowCoverImage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByRpcShowReadingWatchingProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowReadingWatchingProgress', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByRpcShowReadingWatchingProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowReadingWatchingProgress', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByRpcShowTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowTitle', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByRpcShowTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowTitle', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenBySaveAsCBZArchive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveAsCBZArchive', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenBySaveAsCBZArchiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveAsCBZArchive', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByShowNSFW() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNSFW', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByShowNSFWDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNSFW', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByShowNavDoubleTapTooltip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNavDoubleTapTooltip', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByShowNavDoubleTapTooltipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNavDoubleTapTooltip', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByShowSourceBadge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showSourceBadge', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByShowSourceBadgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showSourceBadge', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByStartDatebackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDatebackup', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByStartDatebackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDatebackup', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByThemeIsDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeIsDark', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByThemeIsDarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeIsDark', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTtsLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTtsLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTtsPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsPitch', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTtsPitchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsPitch', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTtsSpeechRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsSpeechRate', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTtsSpeechRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsSpeechRate', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTtsVoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsVoice', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTtsVoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsVoice', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTvAnimeOnlyOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvAnimeOnlyOverride', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByTvAnimeOnlyOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvAnimeOnlyOverride', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTvHomeGenreRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvHomeGenreRows', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTvHomeGenreRowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvHomeGenreRows', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTvHomeStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvHomeStyle', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTvHomeStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvHomeStyle', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTvPlayerStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvPlayerStyle', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByTvPlayerStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvPlayerStyle', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByUpdateProgressAfterReading() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateProgressAfterReading', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByUpdateProgressAfterReadingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateProgressAfterReading', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByUseFloatingNavigationBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useFloatingNavigationBar', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByUseFloatingNavigationBarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useFloatingNavigationBar', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseLibass() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useLibass', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseLibassDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useLibass', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseMpvConfig() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMpvConfig', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseMpvConfigDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMpvConfig', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseYUV420P() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYUV420P', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseYUV420PDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYUV420P', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUserAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAgent', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUserAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAgent', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByVolumeBoostCap() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeBoostCap', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByVolumeBoostCapDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeBoostCap', Sort.desc);
    });
  }
}

extension SettingsQueryWhereDistinct
    on QueryBuilder<Settings, Settings, QDistinct> {
  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAllowConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allowConcurrentDownloads');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAndroidProxyServer({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'androidProxyServer',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAniSkipTimeoutLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aniSkipTimeoutLength');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAnimeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeDisplayType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAnimeGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeGridSize');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryLocalSource');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryShowLanguage');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAppFontFamily({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'appFontFamily',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAppLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appLockEnabled');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAppUiScale() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appUiScale');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAskDownloadDestination() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'askDownloadDestination');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAudioChannels() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioChannels');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAudioPreferredLanguages({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'audioPreferredLanguages',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAutoBackupLocation({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'autoBackupLocation',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAutoExtensionsUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoExtensionsUpdates');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAutoLibraryUpdateInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoLibraryUpdateInterval');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAutoLibraryUpdateWifiOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoLibraryUpdateWifiOnly');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAutoPlayNextEpisode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoPlayNextEpisode');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAutoReadDuplicateChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoReadDuplicateChapters');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAutoStartExtensionServerOnLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoStartExtensionServerOnLaunch');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByBackupCompressionLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backupCompressionLevel');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByBackupEncryptionEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backupEncryptionEnabled');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByBackupFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backupFrequency');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByBackupListOptions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backupListOptions');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByBtServerAddress({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'btServerAddress',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByBtServerPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'btServerPort');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByCfProxyUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cfProxyUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByChapterSwipeEndAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterSwipeEndAction');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByChapterSwipeStartAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterSwipeStartAction');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByCheckForAppUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkForAppUpdates');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByCheckForExtensionUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkForExtensionUpdates');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByClearChapterCacheOnAppLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clearChapterCacheOnAppLaunch');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByComicReaderPreferences({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'comicReaderPreferences',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'concurrentDownloads');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByCustomDns({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customDns', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByCustomDohUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customDohUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDateFormat({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateFormat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDebandingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debandingType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByDefaultDoubleTapToSkipLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultDoubleTapToSkipLength');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDefaultPlayBackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultPlayBackSpeed');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByDefaultSkipIntroLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultSkipIntroLength');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByDeleteDownloadAfterReading() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deleteDownloadAfterReading');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDeveloperMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'developerMode');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDisableSectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'disableSectionType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDoHEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doHEnabled');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDoHProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doHProviderId');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDoublePageAuto() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doublePageAuto');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDownloadDelaySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadDelaySeconds');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByDownloadLocalFolderName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'downloadLocalFolderName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDownloadLocation({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'downloadLocation',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDownloadOnlyOnWifi() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadOnlyOnWifi');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDownloadQueueOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadQueueOrder');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDownloadedOnlyMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadedOnlyMode');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByEnableAniSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableAniSkip');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByEnableAudioPitchCorrection() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableAudioPitchCorrection');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByEnableAutoSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableAutoSkip');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByEnableDiscordRpc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableDiscordRpc');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByEnableGpuNext() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableGpuNext');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByEnableHardwareAcceleration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableHardwareAcceleration');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByEnableLogs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableLogs');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByExtensionServerPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'extensionServerPath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByFlexColorSchemeBlendLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flexColorSchemeBlendLevel');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByFlexSchemeColorIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flexSchemeColorIndex');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByFollowSystemTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followSystemTheme');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByForceLandscapePlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forceLandscapePlayer');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByFullScreenPlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullScreenPlayer');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByFullScreenReader() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullScreenReader');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByHideDiscordRpcInIncognito() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hideDiscordRpcInIncognito');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByHideItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hideItems');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByHwdecMode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hwdecMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByIncognitoMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'incognitoMode');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByJrePath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jrePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByKeepScreenOnReader() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keepScreenOnReader');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLastAutoLibraryUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAutoLibraryUpdate');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLastTrackerLibraryLocation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'lastTrackerLibraryLocation',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterAnimeBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterAnimeBookMarkedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterAnimeCompletedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterAnimeCompletedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterAnimeDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterAnimeDownloadType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterAnimeSourceIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterAnimeSourceIds');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterAnimeStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterAnimeStartedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterAnimeTrackingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterAnimeTrackingType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterAnimeUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterAnimeUnreadType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterMangasBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterMangasBookMarkedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterMangasCompletedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterMangasCompletedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterMangasDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterMangasDownloadType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterMangasSourceIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterMangasSourceIds');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterMangasStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterMangasStartedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterMangasTrackingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterMangasTrackingType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterMangasUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterMangasUnreadType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterNovelBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterNovelBookMarkedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterNovelCompletedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterNovelCompletedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterNovelDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterNovelDownloadType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterNovelSourceIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterNovelSourceIds');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterNovelStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterNovelStartedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterNovelTrackingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterNovelTrackingType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterNovelUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterNovelUnreadType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryLocalSource');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryShowLanguage');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByLocalFolders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localFolders');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByMangaGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaGridSize');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByMangaHomeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaHomeDisplayType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByMarkEpisodeAsSeenType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'markEpisodeAsSeenType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByMergeLibraryNavMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mergeLibraryNavMobile');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNavigationOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'navigationOrder');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelDisplayType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelFontFamily({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'novelFontFamily',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelFontSize');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelGridSize');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryLocalSource');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryShowLanguage');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelReaderLineHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelReaderLineHeight');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelReaderPadding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelReaderPadding');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelReaderTextColor({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'novelReaderTextColor',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelReaderTheme({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'novelReaderTheme',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelRemoveExtraParagraphSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelRemoveExtraParagraphSpacing');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelShowScrollPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelShowScrollPercentage');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelTapToScroll() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelTapToScroll');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelTextAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelTextAlign');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingCompleted');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByOnlyIncludePinnedSources() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onlyIncludePinnedSources');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByPureBlackDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pureBlackDarkMode');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByRelativeTimesTamps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relativeTimesTamps');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByRpcShowCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rpcShowCoverImage');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByRpcShowReadingWatchingProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rpcShowReadingWatchingProgress');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByRpcShowTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rpcShowTitle');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctBySaveAsCBZArchive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saveAsCBZArchive');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByShowNSFW() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showNSFW');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByShowNavDoubleTapTooltip() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showNavDoubleTapTooltip');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByShowSourceBadge() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showSourceBadge');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByStartDatebackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDatebackup');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByThemeIsDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeIsDark');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByTtsLanguage({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ttsLanguage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByTtsPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ttsPitch');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByTtsSpeechRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ttsSpeechRate');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByTtsVoice({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ttsVoice', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByTvAnimeOnlyOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tvAnimeOnlyOverride');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByTvHomeGenreRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tvHomeGenreRows');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByTvHomeStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tvHomeStyle');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByTvPlayerStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tvPlayerStyle');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByUpdateProgressAfterReading() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updateProgressAfterReading');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByUseFloatingNavigationBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useFloatingNavigationBar');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUseLibass() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useLibass');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUseMpvConfig() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useMpvConfig');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUseYUV420P() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useYUV420P');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUserAgent({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userAgent', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByVolumeBoostCap() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volumeBoostCap');
    });
  }
}

extension SettingsQueryProperty
    on QueryBuilder<Settings, Settings, QQueryProperty> {
  QueryBuilder<Settings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Settings, AlgorithmWeights?, QQueryOperations>
  algorithmWeightsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'algorithmWeights');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  allowConcurrentDownloadsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allowConcurrentDownloads');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  androidProxyServerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'androidProxyServer');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  aniSkipTimeoutLengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aniSkipTimeoutLength');
    });
  }

  QueryBuilder<Settings, DisplayType, QQueryOperations>
  animeDisplayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeDisplayType');
    });
  }

  QueryBuilder<Settings, List<Repo>?, QQueryOperations>
  animeExtensionsRepoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeExtensionsRepo');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> animeGridSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeGridSize');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryDownloadedChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryLocalSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryLocalSource');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryShowCategoryTabsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryShowContinueReadingButtonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryShowLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryShowLanguage');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryShowNumbersOfItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> appFontFamilyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appFontFamily');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> appLockEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appLockEnabled');
    });
  }

  QueryBuilder<Settings, double?, QQueryOperations> appUiScaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appUiScale');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  askDownloadDestinationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'askDownloadDestination');
    });
  }

  QueryBuilder<Settings, AudioChannel, QQueryOperations>
  audioChannelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioChannels');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  audioPreferredLanguagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioPreferredLanguages');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  autoBackupLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoBackupLocation');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  autoExtensionsUpdatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoExtensionsUpdates');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  autoLibraryUpdateIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoLibraryUpdateInterval');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  autoLibraryUpdateWifiOnlyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoLibraryUpdateWifiOnly');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  autoPlayNextEpisodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoPlayNextEpisode');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  autoReadDuplicateChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoReadDuplicateChapters');
    });
  }

  QueryBuilder<Settings, List<AutoScrollPages>?, QQueryOperations>
  autoScrollPagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoScrollPages');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  autoStartExtensionServerOnLaunchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoStartExtensionServerOnLaunch');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  backupCompressionLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupCompressionLevel');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  backupEncryptionEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupEncryptionEnabled');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> backupFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupFrequency');
    });
  }

  QueryBuilder<Settings, List<int>?, QQueryOperations>
  backupListOptionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupListOptions');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> btServerAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'btServerAddress');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> btServerPortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'btServerPort');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> cfProxyUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cfProxyUrl');
    });
  }

  QueryBuilder<Settings, List<ChapterFilterBookmarked>?, QQueryOperations>
  chapterFilterBookmarkedListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterFilterBookmarkedList');
    });
  }

  QueryBuilder<Settings, List<ChapterFilterDownloaded>?, QQueryOperations>
  chapterFilterDownloadedListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterFilterDownloadedList');
    });
  }

  QueryBuilder<Settings, List<ChapterFilterUnread>?, QQueryOperations>
  chapterFilterUnreadListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterFilterUnreadList');
    });
  }

  QueryBuilder<Settings, List<ChapterPageIndex>?, QQueryOperations>
  chapterPageIndexListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterPageIndexList');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  chapterSwipeEndActionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterSwipeEndAction');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  chapterSwipeStartActionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterSwipeStartAction');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> checkForAppUpdatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkForAppUpdates');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  checkForExtensionUpdatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkForExtensionUpdates');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  clearChapterCacheOnAppLaunchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clearChapterCacheOnAppLaunch');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  comicReaderPreferencesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'comicReaderPreferences');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> concurrentDownloadsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'concurrentDownloads');
    });
  }

  QueryBuilder<Settings, List<MCookie>?, QQueryOperations>
  cookiesListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cookiesList');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> customDnsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customDns');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> customDohUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customDohUrl');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> dateFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateFormat');
    });
  }

  QueryBuilder<Settings, DebandingType, QQueryOperations>
  debandingTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debandingType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  defaultDoubleTapToSkipLengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultDoubleTapToSkipLength');
    });
  }

  QueryBuilder<Settings, double?, QQueryOperations>
  defaultPlayBackSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultPlayBackSpeed');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  defaultSkipIntroLengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultSkipIntroLength');
    });
  }

  QueryBuilder<Settings, L10nLocale?, QQueryOperations>
  defaultSubtitleLangProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultSubtitleLang');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  deleteDownloadAfterReadingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deleteDownloadAfterReading');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> developerModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'developerMode');
    });
  }

  QueryBuilder<Settings, SectionType, QQueryOperations>
  disableSectionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'disableSectionType');
    });
  }

  QueryBuilder<Settings, DisplayType, QQueryOperations> displayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayType');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> doHEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doHEnabled');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> doHProviderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doHProviderId');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> doublePageAutoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doublePageAuto');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  downloadDelaySecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadDelaySeconds');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  downloadLocalFolderNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadLocalFolderName');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> downloadLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadLocation');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> downloadOnlyOnWifiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadOnlyOnWifi');
    });
  }

  QueryBuilder<Settings, List<int>?, QQueryOperations>
  downloadQueueOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadQueueOrder');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> downloadedOnlyModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadedOnlyMode');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> enableAniSkipProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableAniSkip');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  enableAudioPitchCorrectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableAudioPitchCorrection');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> enableAutoSkipProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableAutoSkip');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> enableDiscordRpcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableDiscordRpc');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> enableGpuNextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableGpuNext');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  enableHardwareAccelerationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableHardwareAcceleration');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> enableLogsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableLogs');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  extensionServerPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extensionServerPath');
    });
  }

  QueryBuilder<Settings, List<FilterScanlator>?, QQueryOperations>
  filterScanlatorListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filterScanlatorList');
    });
  }

  QueryBuilder<Settings, double?, QQueryOperations>
  flexColorSchemeBlendLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flexColorSchemeBlendLevel');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  flexSchemeColorIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flexSchemeColorIndex');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> followSystemThemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followSystemTheme');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  forceLandscapePlayerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forceLandscapePlayer');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> fullScreenPlayerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullScreenPlayer');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> fullScreenReaderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullScreenReader');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  hideDiscordRpcInIncognitoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hideDiscordRpcInIncognito');
    });
  }

  QueryBuilder<Settings, List<String>?, QQueryOperations> hideItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hideItems');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> hwdecModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hwdecMode');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> incognitoModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'incognitoMode');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> jrePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jrePath');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> keepScreenOnReaderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keepScreenOnReader');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  lastAutoLibraryUpdateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAutoLibraryUpdate');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  lastTrackerLibraryLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTrackerLibraryLocation');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  libraryDownloadedChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterAnimeBookMarkedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterAnimeBookMarkedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterAnimeCompletedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterAnimeCompletedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterAnimeDownloadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterAnimeDownloadType');
    });
  }

  QueryBuilder<Settings, List<String>?, QQueryOperations>
  libraryFilterAnimeSourceIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterAnimeSourceIds');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterAnimeStartedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterAnimeStartedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterAnimeTrackingTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterAnimeTrackingType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterAnimeUnreadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterAnimeUnreadType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterMangasBookMarkedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterMangasBookMarkedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterMangasCompletedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterMangasCompletedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterMangasDownloadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterMangasDownloadType');
    });
  }

  QueryBuilder<Settings, List<String>?, QQueryOperations>
  libraryFilterMangasSourceIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterMangasSourceIds');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterMangasStartedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterMangasStartedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterMangasTrackingTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterMangasTrackingType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterMangasUnreadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterMangasUnreadType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterNovelBookMarkedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterNovelBookMarkedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterNovelCompletedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterNovelCompletedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterNovelDownloadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterNovelDownloadType');
    });
  }

  QueryBuilder<Settings, List<String>?, QQueryOperations>
  libraryFilterNovelSourceIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterNovelSourceIds');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterNovelStartedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterNovelStartedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterNovelTrackingTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterNovelTrackingType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterNovelUnreadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterNovelUnreadType');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> libraryLocalSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryLocalSource');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  libraryShowCategoryTabsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  libraryShowContinueReadingButtonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  libraryShowLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryShowLanguage');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  libraryShowNumbersOfItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, List<String>?, QQueryOperations>
  localFoldersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localFolders');
    });
  }

  QueryBuilder<Settings, L10nLocale?, QQueryOperations> localeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locale');
    });
  }

  QueryBuilder<Settings, List<Repo>?, QQueryOperations>
  mangaExtensionsRepoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaExtensionsRepo');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> mangaGridSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaGridSize');
    });
  }

  QueryBuilder<Settings, DisplayType, QQueryOperations>
  mangaHomeDisplayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaHomeDisplayType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  markEpisodeAsSeenTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'markEpisodeAsSeenType');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  mergeLibraryNavMobileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mergeLibraryNavMobile');
    });
  }

  QueryBuilder<Settings, List<LocalFolder>?, QQueryOperations>
  namedLocalFoldersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'namedLocalFolders');
    });
  }

  QueryBuilder<Settings, List<String>?, QQueryOperations>
  navigationOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'navigationOrder');
    });
  }

  QueryBuilder<Settings, DisplayType, QQueryOperations>
  novelDisplayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelDisplayType');
    });
  }

  QueryBuilder<Settings, List<Repo>?, QQueryOperations>
  novelExtensionsRepoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelExtensionsRepo');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> novelFontFamilyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelFontFamily');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> novelFontSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelFontSize');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> novelGridSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelGridSize');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryDownloadedChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryLocalSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryLocalSource');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryShowCategoryTabsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryShowContinueReadingButtonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryShowLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryShowLanguage');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryShowNumbersOfItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, double?, QQueryOperations>
  novelReaderLineHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelReaderLineHeight');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> novelReaderPaddingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelReaderPadding');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  novelReaderTextColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelReaderTextColor');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> novelReaderThemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelReaderTheme');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelRemoveExtraParagraphSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelRemoveExtraParagraphSpacing');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelShowScrollPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelShowScrollPercentage');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> novelTapToScrollProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelTapToScroll');
    });
  }

  QueryBuilder<Settings, NovelTextAlign, QQueryOperations>
  novelTextAlignProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelTextAlign');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  onboardingCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingCompleted');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  onlyIncludePinnedSourcesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onlyIncludePinnedSources');
    });
  }

  QueryBuilder<Settings, List<PersonalPageMode>?, QQueryOperations>
  personalPageModeListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personalPageModeList');
    });
  }

  QueryBuilder<Settings, List<PersonalReaderMode>?, QQueryOperations>
  personalReaderModeListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personalReaderModeList');
    });
  }

  QueryBuilder<Settings, PlayerSubtitleSettings?, QQueryOperations>
  playerSubtitleSettingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerSubtitleSettings');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> pureBlackDarkModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pureBlackDarkMode');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> relativeTimesTampsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relativeTimesTamps');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> rpcShowCoverImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rpcShowCoverImage');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  rpcShowReadingWatchingProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rpcShowReadingWatchingProgress');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> rpcShowTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rpcShowTitle');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> saveAsCBZArchiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saveAsCBZArchive');
    });
  }

  QueryBuilder<Settings, List<SavedSearch>?, QQueryOperations>
  savedSearchesListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savedSearchesList');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> showNSFWProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showNSFW');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  showNavDoubleTapTooltipProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showNavDoubleTapTooltip');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> showSourceBadgeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showSourceBadge');
    });
  }

  QueryBuilder<Settings, List<SortChapter>?, QQueryOperations>
  sortChapterListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortChapterList');
    });
  }

  QueryBuilder<Settings, SortLibraryManga?, QQueryOperations>
  sortLibraryAnimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortLibraryAnime');
    });
  }

  QueryBuilder<Settings, SortLibraryManga?, QQueryOperations>
  sortLibraryMangaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortLibraryManga');
    });
  }

  QueryBuilder<Settings, SortLibraryManga?, QQueryOperations>
  sortLibraryNovelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortLibraryNovel');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> startDatebackupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDatebackup');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> themeIsDarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeIsDark');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> ttsLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ttsLanguage');
    });
  }

  QueryBuilder<Settings, double?, QQueryOperations> ttsPitchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ttsPitch');
    });
  }

  QueryBuilder<Settings, double?, QQueryOperations> ttsSpeechRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ttsSpeechRate');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> ttsVoiceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ttsVoice');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  tvAnimeOnlyOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tvAnimeOnlyOverride');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> tvHomeGenreRowsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tvHomeGenreRows');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> tvHomeStyleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tvHomeStyle');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> tvPlayerStyleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tvPlayerStyle');
    });
  }

  QueryBuilder<Settings, List<UpdateError>?, QQueryOperations>
  updateErrorsListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updateErrorsList');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  updateProgressAfterReadingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updateProgressAfterReading');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  useFloatingNavigationBarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useFloatingNavigationBar');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> useLibassProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useLibass');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> useMpvConfigProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useMpvConfig');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> useYUV420PProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useYUV420P');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> userAgentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userAgent');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> volumeBoostCapProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volumeBoostCap');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const UpdateErrorSchema = Schema(
  name: r'UpdateError',
  id: -6793279269818166592,
  properties: {
    r'error': PropertySchema(id: 0, name: r'error', type: IsarType.string),
    r'mangaId': PropertySchema(id: 1, name: r'mangaId', type: IsarType.long),
    r'name': PropertySchema(id: 2, name: r'name', type: IsarType.string),
  },

  estimateSize: _updateErrorEstimateSize,
  serialize: _updateErrorSerialize,
  deserialize: _updateErrorDeserialize,
  deserializeProp: _updateErrorDeserializeProp,
);

int _updateErrorEstimateSize(
  UpdateError object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.error.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _updateErrorSerialize(
  UpdateError object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.error);
  writer.writeLong(offsets[1], object.mangaId);
  writer.writeString(offsets[2], object.name);
}

UpdateError _updateErrorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UpdateError(
    error: reader.readStringOrNull(offsets[0]) ?? '',
    mangaId: reader.readLongOrNull(offsets[1]) ?? 0,
    name: reader.readStringOrNull(offsets[2]) ?? '',
  );
  return object;
}

P _updateErrorDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension UpdateErrorQueryFilter
    on QueryBuilder<UpdateError, UpdateError, QFilterCondition> {
  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> errorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'error',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition>
  errorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'error',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> errorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'error',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> errorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'error',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> errorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'error',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> errorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'error',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> errorContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'error',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> errorMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'error',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> errorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'error', value: ''),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition>
  errorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'error', value: ''),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> mangaIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition>
  mangaIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> mangaIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> mangaIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<UpdateError, UpdateError, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }
}

extension UpdateErrorQueryObject
    on QueryBuilder<UpdateError, UpdateError, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SavedSearchSchema = Schema(
  name: r'SavedSearch',
  id: -4038919227263572545,
  properties: {
    r'name': PropertySchema(id: 0, name: r'name', type: IsarType.string),
    r'query': PropertySchema(id: 1, name: r'query', type: IsarType.string),
    r'sourceId': PropertySchema(id: 2, name: r'sourceId', type: IsarType.long),
  },

  estimateSize: _savedSearchEstimateSize,
  serialize: _savedSearchSerialize,
  deserialize: _savedSearchDeserialize,
  deserializeProp: _savedSearchDeserializeProp,
);

int _savedSearchEstimateSize(
  SavedSearch object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.query.length * 3;
  return bytesCount;
}

void _savedSearchSerialize(
  SavedSearch object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
  writer.writeString(offsets[1], object.query);
  writer.writeLong(offsets[2], object.sourceId);
}

SavedSearch _savedSearchDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedSearch(
    name: reader.readStringOrNull(offsets[0]) ?? '',
    query: reader.readStringOrNull(offsets[1]) ?? '',
    sourceId: reader.readLongOrNull(offsets[2]),
  );
  return object;
}

P _savedSearchDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SavedSearchQueryFilter
    on QueryBuilder<SavedSearch, SavedSearch, QFilterCondition> {
  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> queryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'query',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition>
  queryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'query',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> queryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'query',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> queryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'query',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> queryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'query',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> queryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'query',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> queryContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'query',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> queryMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'query',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> queryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'query', value: ''),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition>
  queryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'query', value: ''),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition>
  sourceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sourceId'),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition>
  sourceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sourceId'),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> sourceIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceId', value: value),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition>
  sourceIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition>
  sourceIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedSearch, SavedSearch, QAfterFilterCondition> sourceIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SavedSearchQueryObject
    on QueryBuilder<SavedSearch, SavedSearch, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MCookieSchema = Schema(
  name: r'MCookie',
  id: -1854909335245943751,
  properties: {
    r'cookie': PropertySchema(id: 0, name: r'cookie', type: IsarType.string),
    r'host': PropertySchema(id: 1, name: r'host', type: IsarType.string),
  },

  estimateSize: _mCookieEstimateSize,
  serialize: _mCookieSerialize,
  deserialize: _mCookieDeserialize,
  deserializeProp: _mCookieDeserializeProp,
);

int _mCookieEstimateSize(
  MCookie object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cookie;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.host;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _mCookieSerialize(
  MCookie object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cookie);
  writer.writeString(offsets[1], object.host);
}

MCookie _mCookieDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MCookie(
    cookie: reader.readStringOrNull(offsets[0]),
    host: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _mCookieDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MCookieQueryFilter
    on QueryBuilder<MCookie, MCookie, QFilterCondition> {
  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cookie'),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cookie'),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cookie',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'cookie',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cookie', value: ''),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'cookie', value: ''),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'host'),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'host'),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'host',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'host',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'host', value: ''),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'host', value: ''),
      );
    });
  }
}

extension MCookieQueryObject
    on QueryBuilder<MCookie, MCookie, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SortLibraryMangaSchema = Schema(
  name: r'SortLibraryManga',
  id: -8485569296691672246,
  properties: {
    r'index': PropertySchema(id: 0, name: r'index', type: IsarType.long),
    r'reverse': PropertySchema(id: 1, name: r'reverse', type: IsarType.bool),
  },

  estimateSize: _sortLibraryMangaEstimateSize,
  serialize: _sortLibraryMangaSerialize,
  deserialize: _sortLibraryMangaDeserialize,
  deserializeProp: _sortLibraryMangaDeserializeProp,
);

int _sortLibraryMangaEstimateSize(
  SortLibraryManga object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _sortLibraryMangaSerialize(
  SortLibraryManga object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.index);
  writer.writeBool(offsets[1], object.reverse);
}

SortLibraryManga _sortLibraryMangaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SortLibraryManga(
    index: reader.readLongOrNull(offsets[0]),
    reverse: reader.readBoolOrNull(offsets[1]),
  );
  return object;
}

P _sortLibraryMangaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SortLibraryMangaQueryFilter
    on QueryBuilder<SortLibraryManga, SortLibraryManga, QFilterCondition> {
  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  indexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'index'),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  indexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'index'),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  indexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'index', value: value),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  indexGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  indexLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  indexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'index',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  reverseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'reverse'),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  reverseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'reverse'),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  reverseEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reverse', value: value),
      );
    });
  }
}

extension SortLibraryMangaQueryObject
    on QueryBuilder<SortLibraryManga, SortLibraryManga, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SortChapterSchema = Schema(
  name: r'SortChapter',
  id: -468129901904543096,
  properties: {
    r'index': PropertySchema(id: 0, name: r'index', type: IsarType.long),
    r'mangaId': PropertySchema(id: 1, name: r'mangaId', type: IsarType.long),
    r'reverse': PropertySchema(id: 2, name: r'reverse', type: IsarType.bool),
  },

  estimateSize: _sortChapterEstimateSize,
  serialize: _sortChapterSerialize,
  deserialize: _sortChapterDeserialize,
  deserializeProp: _sortChapterDeserializeProp,
);

int _sortChapterEstimateSize(
  SortChapter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _sortChapterSerialize(
  SortChapter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.index);
  writer.writeLong(offsets[1], object.mangaId);
  writer.writeBool(offsets[2], object.reverse);
}

SortChapter _sortChapterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SortChapter(
    index: reader.readLongOrNull(offsets[0]),
    mangaId: reader.readLongOrNull(offsets[1]),
    reverse: reader.readBoolOrNull(offsets[2]),
  );
  return object;
}

P _sortChapterDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SortChapterQueryFilter
    on QueryBuilder<SortChapter, SortChapter, QFilterCondition> {
  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> indexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'index'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  indexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'index'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> indexEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'index', value: value),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  indexGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> indexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> indexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'index',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> mangaIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> mangaIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  reverseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'reverse'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  reverseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'reverse'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> reverseEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reverse', value: value),
      );
    });
  }
}

extension SortChapterQueryObject
    on QueryBuilder<SortChapter, SortChapter, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterFilterDownloadedSchema = Schema(
  name: r'ChapterFilterDownloaded',
  id: -5772236935601996927,
  properties: {
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'type': PropertySchema(id: 1, name: r'type', type: IsarType.long),
  },

  estimateSize: _chapterFilterDownloadedEstimateSize,
  serialize: _chapterFilterDownloadedSerialize,
  deserialize: _chapterFilterDownloadedDeserialize,
  deserializeProp: _chapterFilterDownloadedDeserializeProp,
);

int _chapterFilterDownloadedEstimateSize(
  ChapterFilterDownloaded object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _chapterFilterDownloadedSerialize(
  ChapterFilterDownloaded object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeLong(offsets[1], object.type);
}

ChapterFilterDownloaded _chapterFilterDownloadedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterFilterDownloaded(
    mangaId: reader.readLongOrNull(offsets[0]),
    type: reader.readLongOrNull(offsets[1]),
  );
  return object;
}

P _chapterFilterDownloadedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ChapterFilterDownloadedQueryFilter
    on
        QueryBuilder<
          ChapterFilterDownloaded,
          ChapterFilterDownloaded,
          QFilterCondition
        > {
  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'type'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'type'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ChapterFilterDownloadedQueryObject
    on
        QueryBuilder<
          ChapterFilterDownloaded,
          ChapterFilterDownloaded,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterFilterUnreadSchema = Schema(
  name: r'ChapterFilterUnread',
  id: 2999193805790237469,
  properties: {
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'type': PropertySchema(id: 1, name: r'type', type: IsarType.long),
  },

  estimateSize: _chapterFilterUnreadEstimateSize,
  serialize: _chapterFilterUnreadSerialize,
  deserialize: _chapterFilterUnreadDeserialize,
  deserializeProp: _chapterFilterUnreadDeserializeProp,
);

int _chapterFilterUnreadEstimateSize(
  ChapterFilterUnread object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _chapterFilterUnreadSerialize(
  ChapterFilterUnread object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeLong(offsets[1], object.type);
}

ChapterFilterUnread _chapterFilterUnreadDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterFilterUnread(
    mangaId: reader.readLongOrNull(offsets[0]),
    type: reader.readLongOrNull(offsets[1]),
  );
  return object;
}

P _chapterFilterUnreadDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ChapterFilterUnreadQueryFilter
    on
        QueryBuilder<
          ChapterFilterUnread,
          ChapterFilterUnread,
          QFilterCondition
        > {
  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'type'),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'type'),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  typeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  typeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  typeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  typeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ChapterFilterUnreadQueryObject
    on
        QueryBuilder<
          ChapterFilterUnread,
          ChapterFilterUnread,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterFilterBookmarkedSchema = Schema(
  name: r'ChapterFilterBookmarked',
  id: -4183165879060895626,
  properties: {
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'type': PropertySchema(id: 1, name: r'type', type: IsarType.long),
  },

  estimateSize: _chapterFilterBookmarkedEstimateSize,
  serialize: _chapterFilterBookmarkedSerialize,
  deserialize: _chapterFilterBookmarkedDeserialize,
  deserializeProp: _chapterFilterBookmarkedDeserializeProp,
);

int _chapterFilterBookmarkedEstimateSize(
  ChapterFilterBookmarked object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _chapterFilterBookmarkedSerialize(
  ChapterFilterBookmarked object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeLong(offsets[1], object.type);
}

ChapterFilterBookmarked _chapterFilterBookmarkedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterFilterBookmarked(
    mangaId: reader.readLongOrNull(offsets[0]),
    type: reader.readLongOrNull(offsets[1]),
  );
  return object;
}

P _chapterFilterBookmarkedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ChapterFilterBookmarkedQueryFilter
    on
        QueryBuilder<
          ChapterFilterBookmarked,
          ChapterFilterBookmarked,
          QFilterCondition
        > {
  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'type'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'type'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ChapterFilterBookmarkedQueryObject
    on
        QueryBuilder<
          ChapterFilterBookmarked,
          ChapterFilterBookmarked,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterPageurlsSchema = Schema(
  name: r'ChapterPageurls',
  id: 1038916904093795130,
  properties: {
    r'chapterId': PropertySchema(
      id: 0,
      name: r'chapterId',
      type: IsarType.long,
    ),
    r'chapterUrl': PropertySchema(
      id: 1,
      name: r'chapterUrl',
      type: IsarType.string,
    ),
    r'headers': PropertySchema(
      id: 2,
      name: r'headers',
      type: IsarType.stringList,
    ),
    r'urls': PropertySchema(id: 3, name: r'urls', type: IsarType.stringList),
  },

  estimateSize: _chapterPageurlsEstimateSize,
  serialize: _chapterPageurlsSerialize,
  deserialize: _chapterPageurlsDeserialize,
  deserializeProp: _chapterPageurlsDeserializeProp,
);

int _chapterPageurlsEstimateSize(
  ChapterPageurls object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.chapterUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.headers;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.urls;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _chapterPageurlsSerialize(
  ChapterPageurls object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.chapterId);
  writer.writeString(offsets[1], object.chapterUrl);
  writer.writeStringList(offsets[2], object.headers);
  writer.writeStringList(offsets[3], object.urls);
}

ChapterPageurls _chapterPageurlsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterPageurls(
    chapterId: reader.readLongOrNull(offsets[0]),
    urls: reader.readStringList(offsets[3]),
  );
  object.chapterUrl = reader.readStringOrNull(offsets[1]);
  object.headers = reader.readStringList(offsets[2]);
  return object;
}

P _chapterPageurlsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringList(offset)) as P;
    case 3:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ChapterPageurlsQueryFilter
    on QueryBuilder<ChapterPageurls, ChapterPageurls, QFilterCondition> {
  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterId'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterId'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chapterId', value: value),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chapterId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterUrl'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterUrl'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chapterUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'chapterUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chapterUrl', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'chapterUrl', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'headers'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'headers'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'headers',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'headers',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'headers', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'headers', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'headers', length, true, length, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'headers', 0, true, 0, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'headers', 0, false, 999999, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'headers', 0, true, length, include);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'headers', length, include, 999999, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'headers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'urls'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'urls'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'urls',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'urls',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'urls', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'urls', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'urls', length, true, length, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'urls', 0, true, 0, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'urls', 0, false, 999999, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'urls', 0, true, length, include);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'urls', length, include, 999999, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ChapterPageurlsQueryObject
    on QueryBuilder<ChapterPageurls, ChapterPageurls, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterPageIndexSchema = Schema(
  name: r'ChapterPageIndex',
  id: 4458288720043056373,
  properties: {
    r'chapterId': PropertySchema(
      id: 0,
      name: r'chapterId',
      type: IsarType.long,
    ),
    r'index': PropertySchema(id: 1, name: r'index', type: IsarType.long),
  },

  estimateSize: _chapterPageIndexEstimateSize,
  serialize: _chapterPageIndexSerialize,
  deserialize: _chapterPageIndexDeserialize,
  deserializeProp: _chapterPageIndexDeserializeProp,
);

int _chapterPageIndexEstimateSize(
  ChapterPageIndex object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _chapterPageIndexSerialize(
  ChapterPageIndex object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.chapterId);
  writer.writeLong(offsets[1], object.index);
}

ChapterPageIndex _chapterPageIndexDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterPageIndex(
    chapterId: reader.readLongOrNull(offsets[0]),
    index: reader.readLongOrNull(offsets[1]),
  );
  return object;
}

P _chapterPageIndexDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ChapterPageIndexQueryFilter
    on QueryBuilder<ChapterPageIndex, ChapterPageIndex, QFilterCondition> {
  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  chapterIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterId'),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  chapterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterId'),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  chapterIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chapterId', value: value),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  chapterIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  chapterIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  chapterIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chapterId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  indexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'index'),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  indexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'index'),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  indexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'index', value: value),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  indexGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  indexLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  indexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'index',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ChapterPageIndexQueryObject
    on QueryBuilder<ChapterPageIndex, ChapterPageIndex, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PersonalReaderModeSchema = Schema(
  name: r'PersonalReaderMode',
  id: -1072936262658804338,
  properties: {
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'readerMode': PropertySchema(
      id: 1,
      name: r'readerMode',
      type: IsarType.byte,
      enumMap: _PersonalReaderModereaderModeEnumValueMap,
    ),
  },

  estimateSize: _personalReaderModeEstimateSize,
  serialize: _personalReaderModeSerialize,
  deserialize: _personalReaderModeDeserialize,
  deserializeProp: _personalReaderModeDeserializeProp,
);

int _personalReaderModeEstimateSize(
  PersonalReaderMode object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _personalReaderModeSerialize(
  PersonalReaderMode object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeByte(offsets[1], object.readerMode.index);
}

PersonalReaderMode _personalReaderModeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PersonalReaderMode(
    mangaId: reader.readLongOrNull(offsets[0]),
    readerMode:
        _PersonalReaderModereaderModeValueEnumMap[reader.readByteOrNull(
          offsets[1],
        )] ??
        ReaderMode.vertical,
  );
  return object;
}

P _personalReaderModeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (_PersonalReaderModereaderModeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              ReaderMode.vertical)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PersonalReaderModereaderModeEnumValueMap = {
  'vertical': 0,
  'ltr': 1,
  'rtl': 2,
  'verticalContinuous': 3,
  'webtoon': 4,
  'horizontalContinuous': 5,
  'horizontalContinuousRTL': 6,
};
const _PersonalReaderModereaderModeValueEnumMap = {
  0: ReaderMode.vertical,
  1: ReaderMode.ltr,
  2: ReaderMode.rtl,
  3: ReaderMode.verticalContinuous,
  4: ReaderMode.webtoon,
  5: ReaderMode.horizontalContinuous,
  6: ReaderMode.horizontalContinuousRTL,
};

extension PersonalReaderModeQueryFilter
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QFilterCondition> {
  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  readerModeEqualTo(ReaderMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'readerMode', value: value),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  readerModeGreaterThan(ReaderMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'readerMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  readerModeLessThan(ReaderMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'readerMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  readerModeBetween(
    ReaderMode lower,
    ReaderMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'readerMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PersonalReaderModeQueryObject
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AutoScrollPagesSchema = Schema(
  name: r'AutoScrollPages',
  id: -2184999012300377466,
  properties: {
    r'autoScroll': PropertySchema(
      id: 0,
      name: r'autoScroll',
      type: IsarType.bool,
    ),
    r'mangaId': PropertySchema(id: 1, name: r'mangaId', type: IsarType.long),
    r'pageOffset': PropertySchema(
      id: 2,
      name: r'pageOffset',
      type: IsarType.double,
    ),
  },

  estimateSize: _autoScrollPagesEstimateSize,
  serialize: _autoScrollPagesSerialize,
  deserialize: _autoScrollPagesDeserialize,
  deserializeProp: _autoScrollPagesDeserializeProp,
);

int _autoScrollPagesEstimateSize(
  AutoScrollPages object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _autoScrollPagesSerialize(
  AutoScrollPages object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoScroll);
  writer.writeLong(offsets[1], object.mangaId);
  writer.writeDouble(offsets[2], object.pageOffset);
}

AutoScrollPages _autoScrollPagesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AutoScrollPages(
    autoScroll: reader.readBoolOrNull(offsets[0]),
    mangaId: reader.readLongOrNull(offsets[1]),
    pageOffset: reader.readDoubleOrNull(offsets[2]),
  );
  return object;
}

P _autoScrollPagesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AutoScrollPagesQueryFilter
    on QueryBuilder<AutoScrollPages, AutoScrollPages, QFilterCondition> {
  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  autoScrollIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoScroll'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  autoScrollIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoScroll'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  autoScrollEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoScroll', value: value),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pageOffset'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pageOffset'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pageOffset',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pageOffset',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pageOffset',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pageOffset',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension AutoScrollPagesQueryObject
    on QueryBuilder<AutoScrollPages, AutoScrollPages, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RepoSchema = Schema(
  name: r'Repo',
  id: 8520529424681796092,
  properties: {
    r'hashCode': PropertySchema(id: 0, name: r'hashCode', type: IsarType.long),
    r'hidden': PropertySchema(id: 1, name: r'hidden', type: IsarType.bool),
    r'jsonUrl': PropertySchema(id: 2, name: r'jsonUrl', type: IsarType.string),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
    r'website': PropertySchema(id: 4, name: r'website', type: IsarType.string),
  },

  estimateSize: _repoEstimateSize,
  serialize: _repoSerialize,
  deserialize: _repoDeserialize,
  deserializeProp: _repoDeserializeProp,
);

int _repoEstimateSize(
  Repo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.jsonUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.website;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _repoSerialize(
  Repo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.hashCode);
  writer.writeBool(offsets[1], object.hidden);
  writer.writeString(offsets[2], object.jsonUrl);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.website);
}

Repo _repoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Repo(
    hidden: reader.readBoolOrNull(offsets[1]),
    jsonUrl: reader.readStringOrNull(offsets[2]),
    name: reader.readStringOrNull(offsets[3]),
    website: reader.readStringOrNull(offsets[4]),
  );
  return object;
}

P _repoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension RepoQueryFilter on QueryBuilder<Repo, Repo, QFilterCondition> {
  QueryBuilder<Repo, Repo, QAfterFilterCondition> hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hashCode', value: value),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hashCode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hashCode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hashCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hiddenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hidden'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hiddenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hidden'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hiddenEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hidden', value: value),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'jsonUrl'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'jsonUrl'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'jsonUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'jsonUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'jsonUrl', value: ''),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'jsonUrl', value: ''),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'website'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'website'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'website',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'website',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'website', value: ''),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'website', value: ''),
      );
    });
  }
}

extension RepoQueryObject on QueryBuilder<Repo, Repo, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PersonalPageModeSchema = Schema(
  name: r'PersonalPageMode',
  id: -7061860019786197792,
  properties: {
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'pageMode': PropertySchema(
      id: 1,
      name: r'pageMode',
      type: IsarType.byte,
      enumMap: _PersonalPageModepageModeEnumValueMap,
    ),
  },

  estimateSize: _personalPageModeEstimateSize,
  serialize: _personalPageModeSerialize,
  deserialize: _personalPageModeDeserialize,
  deserializeProp: _personalPageModeDeserializeProp,
);

int _personalPageModeEstimateSize(
  PersonalPageMode object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _personalPageModeSerialize(
  PersonalPageMode object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeByte(offsets[1], object.pageMode.index);
}

PersonalPageMode _personalPageModeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PersonalPageMode(
    mangaId: reader.readLongOrNull(offsets[0]),
    pageMode:
        _PersonalPageModepageModeValueEnumMap[reader.readByteOrNull(
          offsets[1],
        )] ??
        PageMode.onePage,
  );
  return object;
}

P _personalPageModeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (_PersonalPageModepageModeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              PageMode.onePage)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PersonalPageModepageModeEnumValueMap = {'onePage': 0, 'doublePage': 1};
const _PersonalPageModepageModeValueEnumMap = {
  0: PageMode.onePage,
  1: PageMode.doublePage,
};

extension PersonalPageModeQueryFilter
    on QueryBuilder<PersonalPageMode, PersonalPageMode, QFilterCondition> {
  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  pageModeEqualTo(PageMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pageMode', value: value),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  pageModeGreaterThan(PageMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pageMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  pageModeLessThan(PageMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pageMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  pageModeBetween(
    PageMode lower,
    PageMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pageMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PersonalPageModeQueryObject
    on QueryBuilder<PersonalPageMode, PersonalPageMode, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const FilterScanlatorSchema = Schema(
  name: r'FilterScanlator',
  id: 3007689993900015493,
  properties: {
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'scanlators': PropertySchema(
      id: 1,
      name: r'scanlators',
      type: IsarType.stringList,
    ),
  },

  estimateSize: _filterScanlatorEstimateSize,
  serialize: _filterScanlatorSerialize,
  deserialize: _filterScanlatorDeserialize,
  deserializeProp: _filterScanlatorDeserializeProp,
);

int _filterScanlatorEstimateSize(
  FilterScanlator object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.scanlators;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _filterScanlatorSerialize(
  FilterScanlator object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeStringList(offsets[1], object.scanlators);
}

FilterScanlator _filterScanlatorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FilterScanlator(
    mangaId: reader.readLongOrNull(offsets[0]),
    scanlators: reader.readStringList(offsets[1]),
  );
  return object;
}

P _filterScanlatorDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension FilterScanlatorQueryFilter
    on QueryBuilder<FilterScanlator, FilterScanlator, QFilterCondition> {
  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'scanlators'),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'scanlators'),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scanlators',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'scanlators',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scanlators', value: ''),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'scanlators', value: ''),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scanlators', length, true, length, true);
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scanlators', 0, true, 0, true);
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scanlators', 0, false, 999999, true);
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scanlators', 0, true, length, include);
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scanlators', length, include, 999999, true);
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanlators',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension FilterScanlatorQueryObject
    on QueryBuilder<FilterScanlator, FilterScanlator, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const L10nLocaleSchema = Schema(
  name: r'L10nLocale',
  id: -880412678425487799,
  properties: {
    r'countryCode': PropertySchema(
      id: 0,
      name: r'countryCode',
      type: IsarType.string,
    ),
    r'languageCode': PropertySchema(
      id: 1,
      name: r'languageCode',
      type: IsarType.string,
    ),
  },

  estimateSize: _l10nLocaleEstimateSize,
  serialize: _l10nLocaleSerialize,
  deserialize: _l10nLocaleDeserialize,
  deserializeProp: _l10nLocaleDeserializeProp,
);

int _l10nLocaleEstimateSize(
  L10nLocale object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.countryCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.languageCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _l10nLocaleSerialize(
  L10nLocale object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.countryCode);
  writer.writeString(offsets[1], object.languageCode);
}

L10nLocale _l10nLocaleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = L10nLocale(
    countryCode: reader.readStringOrNull(offsets[0]),
    languageCode: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _l10nLocaleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension L10nLocaleQueryFilter
    on QueryBuilder<L10nLocale, L10nLocale, QFilterCondition> {
  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'countryCode'),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'countryCode'),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'countryCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'countryCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'countryCode', value: ''),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'countryCode', value: ''),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'languageCode'),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'languageCode'),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'languageCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'languageCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'languageCode', value: ''),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'languageCode', value: ''),
      );
    });
  }
}

extension L10nLocaleQueryObject
    on QueryBuilder<L10nLocale, L10nLocale, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PlayerSubtitleSettingsSchema = Schema(
  name: r'PlayerSubtitleSettings',
  id: 3515720443923320399,
  properties: {
    r'backgroundColorA': PropertySchema(
      id: 0,
      name: r'backgroundColorA',
      type: IsarType.long,
    ),
    r'backgroundColorB': PropertySchema(
      id: 1,
      name: r'backgroundColorB',
      type: IsarType.long,
    ),
    r'backgroundColorG': PropertySchema(
      id: 2,
      name: r'backgroundColorG',
      type: IsarType.long,
    ),
    r'backgroundColorR': PropertySchema(
      id: 3,
      name: r'backgroundColorR',
      type: IsarType.long,
    ),
    r'borderColorA': PropertySchema(
      id: 4,
      name: r'borderColorA',
      type: IsarType.long,
    ),
    r'borderColorB': PropertySchema(
      id: 5,
      name: r'borderColorB',
      type: IsarType.long,
    ),
    r'borderColorG': PropertySchema(
      id: 6,
      name: r'borderColorG',
      type: IsarType.long,
    ),
    r'borderColorR': PropertySchema(
      id: 7,
      name: r'borderColorR',
      type: IsarType.long,
    ),
    r'fontSize': PropertySchema(id: 8, name: r'fontSize', type: IsarType.long),
    r'overrideAssSubtitles': PropertySchema(
      id: 9,
      name: r'overrideAssSubtitles',
      type: IsarType.bool,
    ),
    r'textColorA': PropertySchema(
      id: 10,
      name: r'textColorA',
      type: IsarType.long,
    ),
    r'textColorB': PropertySchema(
      id: 11,
      name: r'textColorB',
      type: IsarType.long,
    ),
    r'textColorG': PropertySchema(
      id: 12,
      name: r'textColorG',
      type: IsarType.long,
    ),
    r'textColorR': PropertySchema(
      id: 13,
      name: r'textColorR',
      type: IsarType.long,
    ),
    r'useBold': PropertySchema(id: 14, name: r'useBold', type: IsarType.bool),
    r'useItalic': PropertySchema(
      id: 15,
      name: r'useItalic',
      type: IsarType.bool,
    ),
  },

  estimateSize: _playerSubtitleSettingsEstimateSize,
  serialize: _playerSubtitleSettingsSerialize,
  deserialize: _playerSubtitleSettingsDeserialize,
  deserializeProp: _playerSubtitleSettingsDeserializeProp,
);

int _playerSubtitleSettingsEstimateSize(
  PlayerSubtitleSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _playerSubtitleSettingsSerialize(
  PlayerSubtitleSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.backgroundColorA);
  writer.writeLong(offsets[1], object.backgroundColorB);
  writer.writeLong(offsets[2], object.backgroundColorG);
  writer.writeLong(offsets[3], object.backgroundColorR);
  writer.writeLong(offsets[4], object.borderColorA);
  writer.writeLong(offsets[5], object.borderColorB);
  writer.writeLong(offsets[6], object.borderColorG);
  writer.writeLong(offsets[7], object.borderColorR);
  writer.writeLong(offsets[8], object.fontSize);
  writer.writeBool(offsets[9], object.overrideAssSubtitles);
  writer.writeLong(offsets[10], object.textColorA);
  writer.writeLong(offsets[11], object.textColorB);
  writer.writeLong(offsets[12], object.textColorG);
  writer.writeLong(offsets[13], object.textColorR);
  writer.writeBool(offsets[14], object.useBold);
  writer.writeBool(offsets[15], object.useItalic);
}

PlayerSubtitleSettings _playerSubtitleSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlayerSubtitleSettings(
    backgroundColorA: reader.readLongOrNull(offsets[0]),
    backgroundColorB: reader.readLongOrNull(offsets[1]),
    backgroundColorG: reader.readLongOrNull(offsets[2]),
    backgroundColorR: reader.readLongOrNull(offsets[3]),
    borderColorA: reader.readLongOrNull(offsets[4]),
    borderColorB: reader.readLongOrNull(offsets[5]),
    borderColorG: reader.readLongOrNull(offsets[6]),
    borderColorR: reader.readLongOrNull(offsets[7]),
    fontSize: reader.readLongOrNull(offsets[8]),
    overrideAssSubtitles: reader.readBoolOrNull(offsets[9]),
    textColorA: reader.readLongOrNull(offsets[10]),
    textColorB: reader.readLongOrNull(offsets[11]),
    textColorG: reader.readLongOrNull(offsets[12]),
    textColorR: reader.readLongOrNull(offsets[13]),
    useBold: reader.readBoolOrNull(offsets[14]),
    useItalic: reader.readBoolOrNull(offsets[15]),
  );
  return object;
}

P _playerSubtitleSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readBoolOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readBoolOrNull(offset)) as P;
    case 15:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PlayerSubtitleSettingsQueryFilter
    on
        QueryBuilder<
          PlayerSubtitleSettings,
          PlayerSubtitleSettings,
          QFilterCondition
        > {
  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backgroundColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backgroundColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorAEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backgroundColorA', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorAGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backgroundColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorALessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backgroundColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorABetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backgroundColorA',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backgroundColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backgroundColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backgroundColorB', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backgroundColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backgroundColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backgroundColorB',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backgroundColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backgroundColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backgroundColorG', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backgroundColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backgroundColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backgroundColorG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorRIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backgroundColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorRIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backgroundColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorREqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backgroundColorR', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorRGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backgroundColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorRLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backgroundColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorRBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backgroundColorR',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'borderColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'borderColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorAEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderColorA', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorAGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorALessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorABetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderColorA',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'borderColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'borderColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderColorB', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderColorB',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'borderColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'borderColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderColorG', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderColorG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorRIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'borderColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorRIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'borderColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorREqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderColorR', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorRGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorRLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorRBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderColorR',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fontSize'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fontSize'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fontSize', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fontSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fontSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fontSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  overrideAssSubtitlesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'overrideAssSubtitles'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  overrideAssSubtitlesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'overrideAssSubtitles'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  overrideAssSubtitlesEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'overrideAssSubtitles',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'textColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'textColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorAEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textColorA', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorAGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorALessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorABetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textColorA',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'textColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'textColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textColorB', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textColorB',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'textColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'textColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textColorG', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textColorG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorRIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'textColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorRIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'textColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorREqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textColorR', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorRGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorRLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorRBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textColorR',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useBoldIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'useBold'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useBoldIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'useBold'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useBoldEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'useBold', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useItalicIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'useItalic'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useItalicIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'useItalic'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useItalicEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'useItalic', value: value),
      );
    });
  }
}

extension PlayerSubtitleSettingsQueryObject
    on
        QueryBuilder<
          PlayerSubtitleSettings,
          PlayerSubtitleSettings,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AlgorithmWeightsSchema = Schema(
  name: r'AlgorithmWeights',
  id: -2865436974642812672,
  properties: {
    r'genre': PropertySchema(id: 0, name: r'genre', type: IsarType.long),
    r'setting': PropertySchema(id: 1, name: r'setting', type: IsarType.long),
    r'synopsis': PropertySchema(id: 2, name: r'synopsis', type: IsarType.long),
    r'theme': PropertySchema(id: 3, name: r'theme', type: IsarType.long),
  },

  estimateSize: _algorithmWeightsEstimateSize,
  serialize: _algorithmWeightsSerialize,
  deserialize: _algorithmWeightsDeserialize,
  deserializeProp: _algorithmWeightsDeserializeProp,
);

int _algorithmWeightsEstimateSize(
  AlgorithmWeights object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _algorithmWeightsSerialize(
  AlgorithmWeights object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.genre);
  writer.writeLong(offsets[1], object.setting);
  writer.writeLong(offsets[2], object.synopsis);
  writer.writeLong(offsets[3], object.theme);
}

AlgorithmWeights _algorithmWeightsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AlgorithmWeights(
    genre: reader.readLongOrNull(offsets[0]),
    setting: reader.readLongOrNull(offsets[1]),
    synopsis: reader.readLongOrNull(offsets[2]),
    theme: reader.readLongOrNull(offsets[3]),
  );
  return object;
}

P _algorithmWeightsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AlgorithmWeightsQueryFilter
    on QueryBuilder<AlgorithmWeights, AlgorithmWeights, QFilterCondition> {
  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'genre'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'genre'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'genre', value: value),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'genre',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'genre',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'genre',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'setting'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'setting'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'setting', value: value),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'setting',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'setting',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'setting',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'synopsis'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'synopsis'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'synopsis', value: value),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'synopsis',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'synopsis',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'synopsis',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'theme'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'theme'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'theme', value: value),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'theme',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'theme',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'theme',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AlgorithmWeightsQueryObject
    on QueryBuilder<AlgorithmWeights, AlgorithmWeights, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LocalFolderSchema = Schema(
  name: r'LocalFolder',
  id: -5658159691360085183,
  properties: {
    r'name': PropertySchema(id: 0, name: r'name', type: IsarType.string),
    r'path': PropertySchema(id: 1, name: r'path', type: IsarType.string),
  },

  estimateSize: _localFolderEstimateSize,
  serialize: _localFolderSerialize,
  deserialize: _localFolderDeserialize,
  deserializeProp: _localFolderDeserializeProp,
);

int _localFolderEstimateSize(
  LocalFolder object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.path;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _localFolderSerialize(
  LocalFolder object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
  writer.writeString(offsets[1], object.path);
}

LocalFolder _localFolderDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalFolder(
    name: reader.readStringOrNull(offsets[0]),
    path: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _localFolderDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LocalFolderQueryFilter
    on QueryBuilder<LocalFolder, LocalFolder, QFilterCondition> {
  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'name'),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition>
  nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'name'),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> pathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'path'),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition>
  pathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'path'),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> pathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> pathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> pathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> pathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'path',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> pathContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> pathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'path',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition> pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'path', value: ''),
      );
    });
  }

  QueryBuilder<LocalFolder, LocalFolder, QAfterFilterCondition>
  pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'path', value: ''),
      );
    });
  }
}

extension LocalFolderQueryObject
    on QueryBuilder<LocalFolder, LocalFolder, QFilterCondition> {}
