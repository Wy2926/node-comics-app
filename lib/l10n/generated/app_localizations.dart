import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_as.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('as'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('es', '419'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('th'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'NodeLane Comics'**
  String get app_name;

  /// No description provided for @settings_search_empty.
  ///
  /// In en, this message translates to:
  /// **'No matching settings'**
  String get settings_search_empty;

  /// No description provided for @search_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'Try another keyword, or clear the search to see everything.'**
  String get search_empty_hint;

  /// No description provided for @search_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get search_clear;

  /// No description provided for @app_updates.
  ///
  /// In en, this message translates to:
  /// **'App updates'**
  String get app_updates;

  /// No description provided for @app_update_auto.
  ///
  /// In en, this message translates to:
  /// **'Check on launch'**
  String get app_update_auto;

  /// No description provided for @app_update_view.
  ///
  /// In en, this message translates to:
  /// **'View update'**
  String get app_update_view;

  /// No description provided for @app_update_later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get app_update_later;

  /// No description provided for @app_update_external_hint.
  ///
  /// In en, this message translates to:
  /// **'Opens the release page in your browser'**
  String get app_update_external_hint;

  /// No description provided for @app_update_failed.
  ///
  /// In en, this message translates to:
  /// **'Unable to check for updates. Please try again.'**
  String get app_update_failed;

  /// No description provided for @app_update_opened.
  ///
  /// In en, this message translates to:
  /// **'Release page opened'**
  String get app_update_opened;

  /// No description provided for @app_diagnostics.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics and logs'**
  String get app_diagnostics;

  /// No description provided for @app_upstream_community.
  ///
  /// In en, this message translates to:
  /// **'Upstream community'**
  String get app_upstream_community;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @open_random_entry.
  ///
  /// In en, this message translates to:
  /// **'Open random entry'**
  String get open_random_entry;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @ignore_filters.
  ///
  /// In en, this message translates to:
  /// **'Ignore Filters'**
  String get ignore_filters;

  /// No description provided for @downloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get downloaded;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @unwatched.
  ///
  /// In en, this message translates to:
  /// **'Unwatched'**
  String get unwatched;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// No description provided for @bookmarked.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked'**
  String get bookmarked;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @alphabetically.
  ///
  /// In en, this message translates to:
  /// **'Alphabetically'**
  String get alphabetically;

  /// No description provided for @last_read.
  ///
  /// In en, this message translates to:
  /// **'Last read'**
  String get last_read;

  /// No description provided for @last_watched.
  ///
  /// In en, this message translates to:
  /// **'Last watched'**
  String get last_watched;

  /// No description provided for @last_update_check.
  ///
  /// In en, this message translates to:
  /// **'Last update check'**
  String get last_update_check;

  /// Warning when deleting all entries (chapters/episodes) of a manga/anime.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You are deleting the only {entryType} of this {mediaType} from the library.} other{You are deleting all {count} {entryTypePlural} of this {mediaType} from the library.}}\nThis will also remove the whole {mediaType} from your library.\n\nNote: The files themselves will not be deleted.'**
  String last_entry_delete_warning(
    num count,
    Object entryType,
    Object entryTypePlural,
    Object mediaType,
  );

  /// No description provided for @chapter.
  ///
  /// In en, this message translates to:
  /// **'chapter'**
  String get chapter;

  /// No description provided for @episode.
  ///
  /// In en, this message translates to:
  /// **'episode'**
  String get episode;

  /// No description provided for @unread_count.
  ///
  /// In en, this message translates to:
  /// **'Unread count'**
  String get unread_count;

  /// No description provided for @unwatched_count.
  ///
  /// In en, this message translates to:
  /// **'Unwatched count'**
  String get unwatched_count;

  /// No description provided for @latest_chapter.
  ///
  /// In en, this message translates to:
  /// **'Latest chapter'**
  String get latest_chapter;

  /// No description provided for @latest_episode.
  ///
  /// In en, this message translates to:
  /// **'Latest episode'**
  String get latest_episode;

  /// No description provided for @date_added.
  ///
  /// In en, this message translates to:
  /// **'Date added'**
  String get date_added;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @display_mode.
  ///
  /// In en, this message translates to:
  /// **'Display mode'**
  String get display_mode;

  /// No description provided for @compact_grid.
  ///
  /// In en, this message translates to:
  /// **'Compact grid'**
  String get compact_grid;

  /// No description provided for @compression_level.
  ///
  /// In en, this message translates to:
  /// **'Compression level'**
  String get compression_level;

  /// No description provided for @compression_info.
  ///
  /// In en, this message translates to:
  /// **'The higher the compression, the less space the backup file takes, but it uses more CPU. Default: {level}'**
  String compression_info(Object level);

  /// No description provided for @comfortable_grid.
  ///
  /// In en, this message translates to:
  /// **'Comfortable grid'**
  String get comfortable_grid;

  /// No description provided for @cover_only_grid.
  ///
  /// In en, this message translates to:
  /// **'Cover-only grid'**
  String get cover_only_grid;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @downloaded_chapters.
  ///
  /// In en, this message translates to:
  /// **'Downloaded chapters'**
  String get downloaded_chapters;

  /// No description provided for @downloaded_episodes.
  ///
  /// In en, this message translates to:
  /// **'Downloaded episodes'**
  String get downloaded_episodes;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @local_source.
  ///
  /// In en, this message translates to:
  /// **'Local source'**
  String get local_source;

  /// No description provided for @tabs.
  ///
  /// In en, this message translates to:
  /// **'Tabs'**
  String get tabs;

  /// No description provided for @show_category_tabs.
  ///
  /// In en, this message translates to:
  /// **'Show category tabs'**
  String get show_category_tabs;

  /// No description provided for @show_numbers_of_items.
  ///
  /// In en, this message translates to:
  /// **'Show numbers of items'**
  String get show_numbers_of_items;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @show_continue_reading_buttons.
  ///
  /// In en, this message translates to:
  /// **'Show continue reading buttons'**
  String get show_continue_reading_buttons;

  /// No description provided for @show_continue_watching_buttons.
  ///
  /// In en, this message translates to:
  /// **'Show continue watching buttons'**
  String get show_continue_watching_buttons;

  /// No description provided for @empty_library.
  ///
  /// In en, this message translates to:
  /// **'Empty library'**
  String get empty_library;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @no_recent_updates.
  ///
  /// In en, this message translates to:
  /// **'No recent updates'**
  String get no_recent_updates;

  /// No description provided for @remove_everything.
  ///
  /// In en, this message translates to:
  /// **'Remove everything'**
  String get remove_everything;

  /// No description provided for @remove_everything_msg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? All history will be lost'**
  String get remove_everything_msg;

  /// No description provided for @remove_all_update_msg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? The whole update will be cleared'**
  String get remove_all_update_msg;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @remove_history_msg.
  ///
  /// In en, this message translates to:
  /// **'This will remove the read date of this chapter. Are you sure?'**
  String get remove_history_msg;

  /// No description provided for @last_used.
  ///
  /// In en, this message translates to:
  /// **'Last Used'**
  String get last_used;

  /// No description provided for @pinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinned;

  /// No description provided for @sources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sources;

  /// No description provided for @install.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get install;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @extensions.
  ///
  /// In en, this message translates to:
  /// **'Extensions'**
  String get extensions;

  /// No description provided for @migrate.
  ///
  /// In en, this message translates to:
  /// **'Migrate'**
  String get migrate;

  /// No description provided for @mass_migration_title.
  ///
  /// In en, this message translates to:
  /// **'Mass migration'**
  String get mass_migration_title;

  /// No description provided for @mass_migration_preview_items.
  ///
  /// In en, this message translates to:
  /// **'Preview items'**
  String get mass_migration_preview_items;

  /// No description provided for @mass_migration_destination_source.
  ///
  /// In en, this message translates to:
  /// **'Destination source'**
  String get mass_migration_destination_source;

  /// No description provided for @mass_migration_no_library_items.
  ///
  /// In en, this message translates to:
  /// **'No library items are available for mass migration.'**
  String get mass_migration_no_library_items;

  /// No description provided for @mass_migration_no_destination_sources.
  ///
  /// In en, this message translates to:
  /// **'No installed destination sources are available.'**
  String get mass_migration_no_destination_sources;

  /// No description provided for @mass_migration_installed.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get mass_migration_installed;

  /// No description provided for @mass_migration_items_ready_for_review.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item ready for review} other{{count} items ready for review}}'**
  String mass_migration_items_ready_for_review(int count);

  /// No description provided for @mass_migration_item_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String mass_migration_item_count(int count);

  /// No description provided for @mass_migration_select_destination_source.
  ///
  /// In en, this message translates to:
  /// **'Select destination source'**
  String get mass_migration_select_destination_source;

  /// No description provided for @mass_migration_finding_matches.
  ///
  /// In en, this message translates to:
  /// **'Finding matches in {source} • {language}'**
  String mass_migration_finding_matches(Object source, Object language);

  /// No description provided for @mass_migration_processing_item.
  ///
  /// In en, this message translates to:
  /// **'Processing item {current} of {total}'**
  String mass_migration_processing_item(int current, int total);

  /// No description provided for @mass_migration_waiting_next_item.
  ///
  /// In en, this message translates to:
  /// **'Waiting 2 seconds before the next item...'**
  String get mass_migration_waiting_next_item;

  /// No description provided for @mass_migration_waiting_next_migration.
  ///
  /// In en, this message translates to:
  /// **'Waiting 2 seconds before the next migration...'**
  String get mass_migration_waiting_next_migration;

  /// No description provided for @mass_migration_matched_so_far.
  ///
  /// In en, this message translates to:
  /// **'Matched so far: {count}'**
  String mass_migration_matched_so_far(int count);

  /// No description provided for @mass_migration_no_match_count.
  ///
  /// In en, this message translates to:
  /// **'No match: {count}'**
  String mass_migration_no_match_count(int count);

  /// No description provided for @mass_migration_review_matches.
  ///
  /// In en, this message translates to:
  /// **'Review matches for {source}'**
  String mass_migration_review_matches(Object source);

  /// No description provided for @mass_migration_found_matches.
  ///
  /// In en, this message translates to:
  /// **'Found matches: {count}'**
  String mass_migration_found_matches(int count);

  /// No description provided for @mass_migration_no_matches.
  ///
  /// In en, this message translates to:
  /// **'No matches: {count}'**
  String mass_migration_no_matches(int count);

  /// No description provided for @mass_migration_selected_to_migrate.
  ///
  /// In en, this message translates to:
  /// **'Selected to migrate: {count}'**
  String mass_migration_selected_to_migrate(int count);

  /// No description provided for @mass_migration_finish_review.
  ///
  /// In en, this message translates to:
  /// **'Finish review'**
  String get mass_migration_finish_review;

  /// No description provided for @mass_migration_migrate_selected.
  ///
  /// In en, this message translates to:
  /// **'Migrate selected items ({count})'**
  String mass_migration_migrate_selected(int count);

  /// No description provided for @mass_migration_migrating_selected.
  ///
  /// In en, this message translates to:
  /// **'Migrating selected items to {source}'**
  String mass_migration_migrating_selected(Object source);

  /// No description provided for @mass_migration_no_items_selected.
  ///
  /// In en, this message translates to:
  /// **'No items selected for migration.'**
  String get mass_migration_no_items_selected;

  /// No description provided for @mass_migration_migrating_item.
  ///
  /// In en, this message translates to:
  /// **'Migrating item {current} of {total}'**
  String mass_migration_migrating_item(int current, int total);

  /// No description provided for @mass_migration_complete.
  ///
  /// In en, this message translates to:
  /// **'Mass migration complete'**
  String get mass_migration_complete;

  /// No description provided for @mass_migration_complete_success_message.
  ///
  /// In en, this message translates to:
  /// **'All selected items were processed successfully.'**
  String get mass_migration_complete_success_message;

  /// No description provided for @mass_migration_complete_partial_message.
  ///
  /// In en, this message translates to:
  /// **'Migration finished with a few items that still need manual attention.'**
  String get mass_migration_complete_partial_message;

  /// No description provided for @mass_migration_route_summary.
  ///
  /// In en, this message translates to:
  /// **'{source} → {destination}'**
  String mass_migration_route_summary(Object source, Object destination);

  /// No description provided for @mass_migration_processed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get mass_migration_processed;

  /// No description provided for @mass_migration_matched.
  ///
  /// In en, this message translates to:
  /// **'Matched'**
  String get mass_migration_matched;

  /// No description provided for @mass_migration_migrated.
  ///
  /// In en, this message translates to:
  /// **'Migrated'**
  String get mass_migration_migrated;

  /// No description provided for @mass_migration_skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get mass_migration_skipped;

  /// No description provided for @mass_migration_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get mass_migration_failed;

  /// No description provided for @mass_migration_failed_items.
  ///
  /// In en, this message translates to:
  /// **'Failed Items'**
  String get mass_migration_failed_items;

  /// No description provided for @mass_migration_exit.
  ///
  /// In en, this message translates to:
  /// **'Exit Mass Migration'**
  String get mass_migration_exit;

  /// No description provided for @mass_migration_no_destination_match.
  ///
  /// In en, this message translates to:
  /// **'No destination match found'**
  String get mass_migration_no_destination_match;

  /// No description provided for @mass_migration_query.
  ///
  /// In en, this message translates to:
  /// **'Query: {query}'**
  String mass_migration_query(Object query);

  /// No description provided for @mass_migration_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get mass_migration_skip;

  /// No description provided for @mass_migration_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get mass_migration_loading;

  /// No description provided for @mass_migration_choose_another_result.
  ///
  /// In en, this message translates to:
  /// **'Choose another result'**
  String get mass_migration_choose_another_result;

  /// No description provided for @mass_migration_source_chapters.
  ///
  /// In en, this message translates to:
  /// **'Source chapters'**
  String get mass_migration_source_chapters;

  /// No description provided for @mass_migration_destination_chapters.
  ///
  /// In en, this message translates to:
  /// **'Destination chapters'**
  String get mass_migration_destination_chapters;

  /// No description provided for @mass_migration_chapter_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 chapter} other{{count} chapters}}'**
  String mass_migration_chapter_count(int count);

  /// No description provided for @mass_migration_source_chapter_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 source chapter} other{{count} source chapters}}'**
  String mass_migration_source_chapter_count(int count);

  /// No description provided for @mass_migration_destination_chapter_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 destination chapter} other{{count} destination chapters}}'**
  String mass_migration_destination_chapter_count(int count);

  /// No description provided for @mass_migration_no_chapters_found.
  ///
  /// In en, this message translates to:
  /// **'No chapters found.'**
  String get mass_migration_no_chapters_found;

  /// No description provided for @mass_migration_and_more_chapters.
  ///
  /// In en, this message translates to:
  /// **'And {count} more...'**
  String mass_migration_and_more_chapters(int count);

  /// No description provided for @mass_migration_unknown_title.
  ///
  /// In en, this message translates to:
  /// **'Unknown title'**
  String get mass_migration_unknown_title;

  /// No description provided for @mass_migration_unknown_match.
  ///
  /// In en, this message translates to:
  /// **'Unknown match'**
  String get mass_migration_unknown_match;

  /// No description provided for @mass_migration_unknown_source.
  ///
  /// In en, this message translates to:
  /// **'Unknown source'**
  String get mass_migration_unknown_source;

  /// No description provided for @mass_migration_unknown_chapter.
  ///
  /// In en, this message translates to:
  /// **'Unknown chapter'**
  String get mass_migration_unknown_chapter;

  /// No description provided for @migrate_confirm.
  ///
  /// In en, this message translates to:
  /// **'Migrate to another source'**
  String get migrate_confirm;

  /// No description provided for @clean_database.
  ///
  /// In en, this message translates to:
  /// **'Clean database'**
  String get clean_database;

  /// No description provided for @cleaned_database.
  ///
  /// In en, this message translates to:
  /// **'Database cleaned! {x} entries removed'**
  String cleaned_database(Object x);

  /// No description provided for @clean_database_desc.
  ///
  /// In en, this message translates to:
  /// **'This will remove all items that are not added to the library!'**
  String get clean_database_desc;

  /// No description provided for @incognito_mode.
  ///
  /// In en, this message translates to:
  /// **'Incognito Mode'**
  String get incognito_mode;

  /// No description provided for @incognito_mode_description.
  ///
  /// In en, this message translates to:
  /// **'Pauses reading history'**
  String get incognito_mode_description;

  /// No description provided for @downloaded_only.
  ///
  /// In en, this message translates to:
  /// **'Downloaded only'**
  String get downloaded_only;

  /// No description provided for @downloaded_only_description.
  ///
  /// In en, this message translates to:
  /// **'Only show downloaded entries in your library'**
  String get downloaded_only_description;

  /// No description provided for @download_queue.
  ///
  /// In en, this message translates to:
  /// **'Download Queue'**
  String get download_queue;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @no_downloads.
  ///
  /// In en, this message translates to:
  /// **'No Downloads'**
  String get no_downloads;

  /// No description provided for @edit_categories.
  ///
  /// In en, this message translates to:
  /// **'Edit Categories'**
  String get edit_categories;

  /// No description provided for @edit_categories_description.
  ///
  /// In en, this message translates to:
  /// **'You have no categories. Tap the plus button to create one for organizing your library'**
  String get edit_categories_description;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @add_category.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get add_category;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @label_value.
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}'**
  String label_value(Object label, Object value);

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @category_name_required.
  ///
  /// In en, this message translates to:
  /// **'*Required'**
  String get category_name_required;

  /// No description provided for @add_category_error_exist.
  ///
  /// In en, this message translates to:
  /// **'A category with this name already exist!'**
  String get add_category_error_exist;

  /// No description provided for @delete_category.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get delete_category;

  /// No description provided for @delete_category_msg.
  ///
  /// In en, this message translates to:
  /// **'Do you wish to delete the category {name}?'**
  String delete_category_msg(Object name);

  /// No description provided for @rename_category.
  ///
  /// In en, this message translates to:
  /// **'Rename Category'**
  String get rename_category;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @general_subtitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get general_subtitle;

  /// No description provided for @app_language.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get app_language;

  /// No description provided for @default_subtitle_language.
  ///
  /// In en, this message translates to:
  /// **'Default subtitle language'**
  String get default_subtitle_language;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearance_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme, date & time format'**
  String get appearance_subtitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get dark_mode;

  /// No description provided for @follow_system_theme.
  ///
  /// In en, this message translates to:
  /// **'Follow system theme'**
  String get follow_system_theme;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @pure_black_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Pure black dark mode'**
  String get pure_black_dark_mode;

  /// No description provided for @timestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get timestamp;

  /// No description provided for @relative_timestamp.
  ///
  /// In en, this message translates to:
  /// **'Relative timestamp'**
  String get relative_timestamp;

  /// No description provided for @relative_timestamp_short.
  ///
  /// In en, this message translates to:
  /// **'Short (Today, Yesterday)'**
  String get relative_timestamp_short;

  /// No description provided for @relative_timestamp_long.
  ///
  /// In en, this message translates to:
  /// **'Long (Short+, n days ago)'**
  String get relative_timestamp_long;

  /// No description provided for @date_format.
  ///
  /// In en, this message translates to:
  /// **'Date format'**
  String get date_format;

  /// No description provided for @reader.
  ///
  /// In en, this message translates to:
  /// **'Reader'**
  String get reader;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @reader_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Reading mode, display, navigation'**
  String get reader_subtitle;

  /// No description provided for @default_reading_mode.
  ///
  /// In en, this message translates to:
  /// **'Default reading mode'**
  String get default_reading_mode;

  /// No description provided for @reading_mode_vertical.
  ///
  /// In en, this message translates to:
  /// **'Vertical'**
  String get reading_mode_vertical;

  /// No description provided for @reading_mode_horizontal.
  ///
  /// In en, this message translates to:
  /// **'Horizontal'**
  String get reading_mode_horizontal;

  /// No description provided for @reading_mode_left_to_right.
  ///
  /// In en, this message translates to:
  /// **'Left to Right'**
  String get reading_mode_left_to_right;

  /// No description provided for @reading_mode_right_to_left.
  ///
  /// In en, this message translates to:
  /// **'Right to Left'**
  String get reading_mode_right_to_left;

  /// No description provided for @reading_mode_vertical_continuous.
  ///
  /// In en, this message translates to:
  /// **'Vertical continuous'**
  String get reading_mode_vertical_continuous;

  /// No description provided for @reading_mode_webtoon.
  ///
  /// In en, this message translates to:
  /// **'Webtoon'**
  String get reading_mode_webtoon;

  /// No description provided for @double_tap_animation_speed.
  ///
  /// In en, this message translates to:
  /// **'Double tap animation speed'**
  String get double_tap_animation_speed;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// No description provided for @no_animation.
  ///
  /// In en, this message translates to:
  /// **'No animation'**
  String get no_animation;

  /// No description provided for @animate_page_transitions.
  ///
  /// In en, this message translates to:
  /// **'Animate page transitions'**
  String get animate_page_transitions;

  /// No description provided for @crop_borders.
  ///
  /// In en, this message translates to:
  /// **'Crop borders'**
  String get crop_borders;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @downloads_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Downloads settings'**
  String get downloads_subtitle;

  /// No description provided for @download_location.
  ///
  /// In en, this message translates to:
  /// **'Download location'**
  String get download_location;

  /// No description provided for @custom_location.
  ///
  /// In en, this message translates to:
  /// **'Custom location'**
  String get custom_location;

  /// No description provided for @only_on_wifi.
  ///
  /// In en, this message translates to:
  /// **'Only on wifi'**
  String get only_on_wifi;

  /// No description provided for @save_as_cbz_archive.
  ///
  /// In en, this message translates to:
  /// **'Save as CBZ archive'**
  String get save_as_cbz_archive;

  /// No description provided for @delete_download_after_reading.
  ///
  /// In en, this message translates to:
  /// **'Delete download after reading'**
  String get delete_download_after_reading;

  /// No description provided for @concurrent_downloads.
  ///
  /// In en, this message translates to:
  /// **'Concurrent downloads'**
  String get concurrent_downloads;

  /// No description provided for @browse_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sources, global search'**
  String get browse_subtitle;

  /// No description provided for @only_include_pinned_sources.
  ///
  /// In en, this message translates to:
  /// **'Only include pinned sources'**
  String get only_include_pinned_sources;

  /// No description provided for @nsfw_sources.
  ///
  /// In en, this message translates to:
  /// **'NSFW (+18) sources'**
  String get nsfw_sources;

  /// No description provided for @nsfw_sources_show.
  ///
  /// In en, this message translates to:
  /// **'Show in sources and extensions lists'**
  String get nsfw_sources_show;

  /// No description provided for @nsfw_sources_info.
  ///
  /// In en, this message translates to:
  /// **'This does not prevent unofficial or potentially incorrectly flagged extensions from surfacing NSFW (18+) content within the app'**
  String get nsfw_sources_info;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @beta_version.
  ///
  /// In en, this message translates to:
  /// **'Beta ({version})'**
  String beta_version(Object version);

  /// No description provided for @check_for_update.
  ///
  /// In en, this message translates to:
  /// **'Check for update'**
  String get check_for_update;

  /// No description provided for @logs_on.
  ///
  /// In en, this message translates to:
  /// **'Enable logging'**
  String get logs_on;

  /// No description provided for @share_app_logs.
  ///
  /// In en, this message translates to:
  /// **'Share app logs'**
  String get share_app_logs;

  /// No description provided for @no_app_logs.
  ///
  /// In en, this message translates to:
  /// **'No log.txt available!'**
  String get no_app_logs;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed!'**
  String get failed;

  /// No description provided for @n_days_ago.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String n_days_ago(Object days);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @a_week_ago.
  ///
  /// In en, this message translates to:
  /// **'A week ago'**
  String get a_week_ago;

  /// No description provided for @next_week.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get next_week;

  /// No description provided for @add_to_library.
  ///
  /// In en, this message translates to:
  /// **'Add to library'**
  String get add_to_library;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @on_hiatus.
  ///
  /// In en, this message translates to:
  /// **'On Hiatus'**
  String get on_hiatus;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @publishing_finished.
  ///
  /// In en, this message translates to:
  /// **'Publishing finished'**
  String get publishing_finished;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @empty_placeholder.
  ///
  /// In en, this message translates to:
  /// **'EMPTY\nMPTY\nMTY\nMT\n\n'**
  String get empty_placeholder;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @error_with_message.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error_with_message(Object error);

  /// No description provided for @no_pages_available.
  ///
  /// In en, this message translates to:
  /// **'Error: no pages available'**
  String get no_pages_available;

  /// No description provided for @set_categories.
  ///
  /// In en, this message translates to:
  /// **'Set categories'**
  String get set_categories;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @in_library.
  ///
  /// In en, this message translates to:
  /// **'In library'**
  String get in_library;

  /// No description provided for @filter_scanlator_groups.
  ///
  /// In en, this message translates to:
  /// **'Filter scanlator groups'**
  String get filter_scanlator_groups;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @by_source.
  ///
  /// In en, this message translates to:
  /// **'By source'**
  String get by_source;

  /// No description provided for @by_chapter_number.
  ///
  /// In en, this message translates to:
  /// **'By chapter number'**
  String get by_chapter_number;

  /// No description provided for @by_episode_number.
  ///
  /// In en, this message translates to:
  /// **'By episode number'**
  String get by_episode_number;

  /// No description provided for @by_upload_date.
  ///
  /// In en, this message translates to:
  /// **'By upload date'**
  String get by_upload_date;

  /// No description provided for @source_title.
  ///
  /// In en, this message translates to:
  /// **'Source title'**
  String get source_title;

  /// No description provided for @create_extension.
  ///
  /// In en, this message translates to:
  /// **'Create Extension'**
  String get create_extension;

  /// No description provided for @developer_mode.
  ///
  /// In en, this message translates to:
  /// **'Developer mode'**
  String get developer_mode;

  /// No description provided for @developer_mode_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Show extension developer tools (create extension, edit code)'**
  String get developer_mode_subtitle;

  /// No description provided for @choose_extension_language.
  ///
  /// In en, this message translates to:
  /// **'Choose extension language'**
  String get choose_extension_language;

  /// No description provided for @lang.
  ///
  /// In en, this message translates to:
  /// **'Lang'**
  String get lang;

  /// No description provided for @base_url.
  ///
  /// In en, this message translates to:
  /// **'BaseUrl'**
  String get base_url;

  /// No description provided for @api_url_optional.
  ///
  /// In en, this message translates to:
  /// **'ApiUrl (optional)'**
  String get api_url_optional;

  /// No description provided for @icon_url.
  ///
  /// In en, this message translates to:
  /// **'iconUrl'**
  String get icon_url;

  /// No description provided for @source_icon_url.
  ///
  /// In en, this message translates to:
  /// **'Source icon url'**
  String get source_icon_url;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'notes'**
  String get notes;

  /// No description provided for @extension_name_example.
  ///
  /// In en, this message translates to:
  /// **'ex: myAnime'**
  String get extension_name_example;

  /// No description provided for @language_code_example.
  ///
  /// In en, this message translates to:
  /// **'ex: en'**
  String get language_code_example;

  /// No description provided for @base_url_example.
  ///
  /// In en, this message translates to:
  /// **'ex: https://example.com'**
  String get base_url_example;

  /// No description provided for @api_url_example.
  ///
  /// In en, this message translates to:
  /// **'ex: https://api.example.com'**
  String get api_url_example;

  /// No description provided for @extension_notes_example.
  ///
  /// In en, this message translates to:
  /// **'ex: this extension requires login'**
  String get extension_notes_example;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @source_type_single.
  ///
  /// In en, this message translates to:
  /// **'single'**
  String get source_type_single;

  /// No description provided for @source_type_multi.
  ///
  /// In en, this message translates to:
  /// **'multi'**
  String get source_type_multi;

  /// No description provided for @source_type_torrent.
  ///
  /// In en, this message translates to:
  /// **'torrent'**
  String get source_type_torrent;

  /// No description provided for @source_language_dart.
  ///
  /// In en, this message translates to:
  /// **'Dart'**
  String get source_language_dart;

  /// No description provided for @source_language_javascript.
  ///
  /// In en, this message translates to:
  /// **'JavaScript'**
  String get source_language_javascript;

  /// No description provided for @source_language_lnreader_compiled_js.
  ///
  /// In en, this message translates to:
  /// **'LNReader compiled JS'**
  String get source_language_lnreader_compiled_js;

  /// No description provided for @source_created_successfully.
  ///
  /// In en, this message translates to:
  /// **'Source created successfully'**
  String get source_created_successfully;

  /// No description provided for @source_already_exists.
  ///
  /// In en, this message translates to:
  /// **'Source already exists'**
  String get source_already_exists;

  /// No description provided for @error_when_creating_source.
  ///
  /// In en, this message translates to:
  /// **'Error when creating source'**
  String get error_when_creating_source;

  /// No description provided for @cookies_deleted.
  ///
  /// In en, this message translates to:
  /// **'Cookies deleted!'**
  String get cookies_deleted;

  /// No description provided for @delete_all_cookies.
  ///
  /// In en, this message translates to:
  /// **'Delete all cookies'**
  String get delete_all_cookies;

  /// No description provided for @chapter_number.
  ///
  /// In en, this message translates to:
  /// **'Chapter number'**
  String get chapter_number;

  /// No description provided for @episode_number.
  ///
  /// In en, this message translates to:
  /// **'Episode number'**
  String get episode_number;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @n_chapters.
  ///
  /// In en, this message translates to:
  /// **'{n} chapters'**
  String n_chapters(Object n);

  /// No description provided for @missing_chapters.
  ///
  /// In en, this message translates to:
  /// **'Missing {count} chapters'**
  String missing_chapters(Object count);

  /// No description provided for @no_description.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get no_description;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @watch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watch;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @open_in_browser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get open_in_browser;

  /// No description provided for @clear_cookie.
  ///
  /// In en, this message translates to:
  /// **'Clear cookie'**
  String get clear_cookie;

  /// No description provided for @show_page_number.
  ///
  /// In en, this message translates to:
  /// **'Show page number'**
  String get show_page_number;

  /// No description provided for @from_library.
  ///
  /// In en, this message translates to:
  /// **'From library'**
  String get from_library;

  /// No description provided for @downloaded_chapter.
  ///
  /// In en, this message translates to:
  /// **'Downloaded chapter'**
  String get downloaded_chapter;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String page(Object page);

  /// No description provided for @global_search.
  ///
  /// In en, this message translates to:
  /// **'Global search'**
  String get global_search;

  /// No description provided for @color_blend_level.
  ///
  /// In en, this message translates to:
  /// **'Color blend level'**
  String get color_blend_level;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current {char}'**
  String current(Object char);

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished {char}'**
  String finished(Object char);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next {char}'**
  String next(Object char);

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous {char}'**
  String previous(Object char);

  /// No description provided for @no_more_chapter.
  ///
  /// In en, this message translates to:
  /// **'There\'s no more chapter'**
  String get no_more_chapter;

  /// No description provided for @no_result.
  ///
  /// In en, this message translates to:
  /// **'No result'**
  String get no_result;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @start_downloading.
  ///
  /// In en, this message translates to:
  /// **'Start downloading now'**
  String get start_downloading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @add_chapters.
  ///
  /// In en, this message translates to:
  /// **'Add Chapters'**
  String get add_chapters;

  /// No description provided for @delete_chapters.
  ///
  /// In en, this message translates to:
  /// **'Delete Chapter?'**
  String get delete_chapters;

  /// No description provided for @default0.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get default0;

  /// No description provided for @total_chapters.
  ///
  /// In en, this message translates to:
  /// **'Total Chapters'**
  String get total_chapters;

  /// No description provided for @total_episodes.
  ///
  /// In en, this message translates to:
  /// **'Total episodes'**
  String get total_episodes;

  /// No description provided for @import_local_file.
  ///
  /// In en, this message translates to:
  /// **'Import Local file'**
  String get import_local_file;

  /// No description provided for @import_files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get import_files;

  /// No description provided for @split_epub_chapters.
  ///
  /// In en, this message translates to:
  /// **'Split into chapters'**
  String get split_epub_chapters;

  /// No description provided for @split_epub_chapters_description.
  ///
  /// In en, this message translates to:
  /// **'Import each EPUB chapter as a separate entry'**
  String get split_epub_chapters_description;

  /// No description provided for @nothing_read_recently.
  ///
  /// In en, this message translates to:
  /// **'Nothing read recently'**
  String get nothing_read_recently;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @not_started.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get not_started;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @start_date.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get start_date;

  /// No description provided for @finish_date.
  ///
  /// In en, this message translates to:
  /// **'Finish date'**
  String get finish_date;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// No description provided for @on_hold.
  ///
  /// In en, this message translates to:
  /// **'On hold'**
  String get on_hold;

  /// No description provided for @dropped.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get dropped;

  /// No description provided for @plan_to_read.
  ///
  /// In en, this message translates to:
  /// **'Plan to read'**
  String get plan_to_read;

  /// No description provided for @re_reading.
  ///
  /// In en, this message translates to:
  /// **'Rereading'**
  String get re_reading;

  /// No description provided for @chapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// No description provided for @add_tracker.
  ///
  /// In en, this message translates to:
  /// **'Add tracking'**
  String get add_tracker;

  /// No description provided for @one_tracker.
  ///
  /// In en, this message translates to:
  /// **'1 tracker'**
  String get one_tracker;

  /// No description provided for @n_tracker.
  ///
  /// In en, this message translates to:
  /// **'{n} trackers'**
  String n_tracker(Object n);

  /// No description provided for @tracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get tracking;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncing;

  /// No description provided for @sync_logged.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get sync_logged;

  /// No description provided for @syncing_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync your progress across multiple devices via a self-hosted \nserver. Check out our discord server for more info!'**
  String get syncing_subtitle;

  /// No description provided for @last_sync.
  ///
  /// In en, this message translates to:
  /// **'Last sync at: '**
  String get last_sync;

  /// No description provided for @sync_login_browser.
  ///
  /// In en, this message translates to:
  /// **'Log in with browser'**
  String get sync_login_browser;

  /// No description provided for @sync_server.
  ///
  /// In en, this message translates to:
  /// **'Sync Server Address'**
  String get sync_server;

  /// No description provided for @sync_starting.
  ///
  /// In en, this message translates to:
  /// **'Starting sync...'**
  String get sync_starting;

  /// No description provided for @sync_finished.
  ///
  /// In en, this message translates to:
  /// **'Sync finished'**
  String get sync_finished;

  /// No description provided for @sync_failed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get sync_failed;

  /// No description provided for @sync_restore_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Sync skipped — restore in progress'**
  String get sync_restore_in_progress;

  /// No description provided for @sync_progress_percent.
  ///
  /// In en, this message translates to:
  /// **'Syncing… {percent}%'**
  String sync_progress_percent(Object percent);

  /// No description provided for @sync_progress_indeterminate.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get sync_progress_indeterminate;

  /// No description provided for @sync_button_sync.
  ///
  /// In en, this message translates to:
  /// **'Sync progress'**
  String get sync_button_sync;

  /// No description provided for @sync_button_upload.
  ///
  /// In en, this message translates to:
  /// **'Upload only'**
  String get sync_button_upload;

  /// No description provided for @sync_button_upload_info.
  ///
  /// In en, this message translates to:
  /// **'This device\'s data will overwrite the server\'s for anything it also has. Nothing on the server gets deleted.'**
  String get sync_button_upload_info;

  /// No description provided for @sync_button_download.
  ///
  /// In en, this message translates to:
  /// **'Download only'**
  String get sync_button_download;

  /// No description provided for @sync_button_download_info.
  ///
  /// In en, this message translates to:
  /// **'Pulls in everything from the server. Nothing on this device gets deleted.'**
  String get sync_button_download_info;

  /// No description provided for @sync_status_not_configured.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get sync_status_not_configured;

  /// No description provided for @sync_status_checking.
  ///
  /// In en, this message translates to:
  /// **'Checking connection...'**
  String get sync_status_checking;

  /// No description provided for @sync_status_connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get sync_status_connected;

  /// No description provided for @sync_status_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session expired, please log in again'**
  String get sync_status_unauthorized;

  /// No description provided for @sync_status_unreachable.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach server'**
  String get sync_status_unreachable;

  /// No description provided for @sync_section_general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sync_section_general;

  /// No description provided for @sync_on.
  ///
  /// In en, this message translates to:
  /// **'Enable sync'**
  String get sync_on;

  /// No description provided for @sync_auto.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync'**
  String get sync_auto;

  /// No description provided for @sync_auto_warning.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync is currently an experimental feature!'**
  String get sync_auto_warning;

  /// No description provided for @sync_auto_off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get sync_auto_off;

  /// No description provided for @sync_auto_5_minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 5 minutes'**
  String get sync_auto_5_minutes;

  /// No description provided for @sync_auto_10_minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 10 minutes'**
  String get sync_auto_10_minutes;

  /// No description provided for @sync_auto_30_minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 30 minutes'**
  String get sync_auto_30_minutes;

  /// No description provided for @sync_auto_1_hour.
  ///
  /// In en, this message translates to:
  /// **'Every 1 hour'**
  String get sync_auto_1_hour;

  /// No description provided for @sync_auto_3_hours.
  ///
  /// In en, this message translates to:
  /// **'Every 3 hours'**
  String get sync_auto_3_hours;

  /// No description provided for @sync_auto_6_hours.
  ///
  /// In en, this message translates to:
  /// **'Every 6 hours'**
  String get sync_auto_6_hours;

  /// No description provided for @sync_auto_12_hours.
  ///
  /// In en, this message translates to:
  /// **'Every 12 hours'**
  String get sync_auto_12_hours;

  /// No description provided for @server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error!'**
  String get server_error;

  /// No description provided for @dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dialog_confirm;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @reorder_navigation.
  ///
  /// In en, this message translates to:
  /// **'Customize navigation'**
  String get reorder_navigation;

  /// No description provided for @reorder_navigation_description.
  ///
  /// In en, this message translates to:
  /// **'Reorder and toggle each navigation to your needs.'**
  String get reorder_navigation_description;

  /// No description provided for @floating_navigation_bar.
  ///
  /// In en, this message translates to:
  /// **'Floating navigation bar'**
  String get floating_navigation_bar;

  /// No description provided for @floating_navigation_bar_description.
  ///
  /// In en, this message translates to:
  /// **'Use a floating capsule instead of the standard attached navigation bar.'**
  String get floating_navigation_bar_description;

  /// No description provided for @full_screen_player.
  ///
  /// In en, this message translates to:
  /// **'Use Fullscreen'**
  String get full_screen_player;

  /// No description provided for @full_screen_player_info.
  ///
  /// In en, this message translates to:
  /// **'Automatically use fullscreen when playing a video.'**
  String get full_screen_player_info;

  /// No description provided for @episode_progress.
  ///
  /// In en, this message translates to:
  /// **'Progress: {n}'**
  String episode_progress(Object n);

  /// No description provided for @n_episodes.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1 {1 episode} other {{n} episodes}}'**
  String n_episodes(int n);

  /// No description provided for @missing_episodes.
  ///
  /// In en, this message translates to:
  /// **'Missing {count} episodes'**
  String missing_episodes(Object count);

  /// No description provided for @manga_sources.
  ///
  /// In en, this message translates to:
  /// **'Manga Sources'**
  String get manga_sources;

  /// No description provided for @anime_sources.
  ///
  /// In en, this message translates to:
  /// **'Anime Sources'**
  String get anime_sources;

  /// No description provided for @novel_sources.
  ///
  /// In en, this message translates to:
  /// **'Novel Sources'**
  String get novel_sources;

  /// No description provided for @anime_extensions.
  ///
  /// In en, this message translates to:
  /// **'Anime Extensions'**
  String get anime_extensions;

  /// No description provided for @manga_extensions.
  ///
  /// In en, this message translates to:
  /// **'Manga Extensions'**
  String get manga_extensions;

  /// No description provided for @novel_extensions.
  ///
  /// In en, this message translates to:
  /// **'Novel Extensions'**
  String get novel_extensions;

  /// No description provided for @extension_settings.
  ///
  /// In en, this message translates to:
  /// **'Extension settings'**
  String get extension_settings;

  /// No description provided for @anime.
  ///
  /// In en, this message translates to:
  /// **'Anime'**
  String get anime;

  /// No description provided for @manga.
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get manga;

  /// No description provided for @novel.
  ///
  /// In en, this message translates to:
  /// **'Novel'**
  String get novel;

  /// No description provided for @library_no_category_exist.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any categories yet'**
  String get library_no_category_exist;

  /// No description provided for @watching.
  ///
  /// In en, this message translates to:
  /// **'Watching'**
  String get watching;

  /// No description provided for @plan_to_watch.
  ///
  /// In en, this message translates to:
  /// **'Plan to watch'**
  String get plan_to_watch;

  /// No description provided for @re_watching.
  ///
  /// In en, this message translates to:
  /// **'Rewatching'**
  String get re_watching;

  /// No description provided for @episodes.
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get episodes;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @new_update_available.
  ///
  /// In en, this message translates to:
  /// **'New update available'**
  String get new_update_available;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version : v{v}'**
  String app_version(Object v);

  /// No description provided for @searching_for_updates.
  ///
  /// In en, this message translates to:
  /// **'Searching for updates...'**
  String get searching_for_updates;

  /// No description provided for @no_new_updates_available.
  ///
  /// In en, this message translates to:
  /// **'No new updates available'**
  String get no_new_updates_available;

  /// No description provided for @uninstall.
  ///
  /// In en, this message translates to:
  /// **'Uninstall'**
  String get uninstall;

  /// No description provided for @uninstall_extension.
  ///
  /// In en, this message translates to:
  /// **'Uninstall {ext} extension?'**
  String uninstall_extension(Object ext);

  /// No description provided for @double_tap_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Double-tap to search all {type}'**
  String double_tap_search_hint(Object type);

  /// No description provided for @show_nav_double_tap_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Show double-tap search hint'**
  String get show_nav_double_tap_tooltip;

  /// No description provided for @show_nav_double_tap_tooltip_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Show a tooltip on the Manga/Anime/Novel nav destinations explaining that double-tapping opens Global Search.'**
  String get show_nav_double_tap_tooltip_subtitle;

  /// No description provided for @already_in_library.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" is already in your library via {source}.'**
  String already_in_library(Object source, Object title);

  /// No description provided for @add_anyway.
  ///
  /// In en, this message translates to:
  /// **'Add Anyway'**
  String get add_anyway;

  /// No description provided for @langauage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get langauage;

  /// No description provided for @extension_detail.
  ///
  /// In en, this message translates to:
  /// **'Extension detail'**
  String get extension_detail;

  /// No description provided for @scale_type.
  ///
  /// In en, this message translates to:
  /// **'Scale type'**
  String get scale_type;

  /// No description provided for @scale_type_fit_screen.
  ///
  /// In en, this message translates to:
  /// **'Fit screen'**
  String get scale_type_fit_screen;

  /// No description provided for @scale_type_stretch.
  ///
  /// In en, this message translates to:
  /// **'Stretch'**
  String get scale_type_stretch;

  /// No description provided for @scale_type_fit_width.
  ///
  /// In en, this message translates to:
  /// **'Fit width'**
  String get scale_type_fit_width;

  /// No description provided for @scale_type_fit_height.
  ///
  /// In en, this message translates to:
  /// **'Fit height'**
  String get scale_type_fit_height;

  /// No description provided for @scale_type_original_size.
  ///
  /// In en, this message translates to:
  /// **'Original size'**
  String get scale_type_original_size;

  /// No description provided for @scale_type_smart_fit.
  ///
  /// In en, this message translates to:
  /// **'Smart fit'**
  String get scale_type_smart_fit;

  /// No description provided for @page_preload_amount.
  ///
  /// In en, this message translates to:
  /// **'Page preload amount'**
  String get page_preload_amount;

  /// No description provided for @page_preload_amount_subtitle.
  ///
  /// In en, this message translates to:
  /// **'The amount of pages to preload when reading. Higher values will result in a smoother reading experience, at the cost of higher cache and network usage.'**
  String get page_preload_amount_subtitle;

  /// No description provided for @image_loading_error.
  ///
  /// In en, this message translates to:
  /// **'This image couldn\'t be loaded'**
  String get image_loading_error;

  /// No description provided for @add_episodes.
  ///
  /// In en, this message translates to:
  /// **'Add Episodes'**
  String get add_episodes;

  /// No description provided for @video_quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get video_quality;

  /// No description provided for @video_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get video_subtitle;

  /// No description provided for @check_for_extension_updates.
  ///
  /// In en, this message translates to:
  /// **'Check for extension updates'**
  String get check_for_extension_updates;

  /// No description provided for @auto_extensions_updates.
  ///
  /// In en, this message translates to:
  /// **'Auto extension updates'**
  String get auto_extensions_updates;

  /// No description provided for @auto_extensions_updates_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Will automatically update the extension when a new version is available.'**
  String get auto_extensions_updates_subtitle;

  /// No description provided for @check_for_app_updates.
  ///
  /// In en, this message translates to:
  /// **'Check for app updates on startup'**
  String get check_for_app_updates;

  /// No description provided for @reading_mode.
  ///
  /// In en, this message translates to:
  /// **'Reading mode'**
  String get reading_mode;

  /// No description provided for @custom_filter.
  ///
  /// In en, this message translates to:
  /// **'Custom filter'**
  String get custom_filter;

  /// No description provided for @background_color.
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get background_color;

  /// No description provided for @white.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get white;

  /// No description provided for @black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get black;

  /// No description provided for @grey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get grey;

  /// No description provided for @automaic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automaic;

  /// No description provided for @preferred_domain.
  ///
  /// In en, this message translates to:
  /// **'Preferred Domain'**
  String get preferred_domain;

  /// No description provided for @load_more.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get load_more;

  /// No description provided for @cancel_all_for_this_series.
  ///
  /// In en, this message translates to:
  /// **'Cancel all for this series'**
  String get cancel_all_for_this_series;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @login_into.
  ///
  /// In en, this message translates to:
  /// **'Login into {tracker}'**
  String login_into(Object tracker);

  /// No description provided for @email_adress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_adress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @log_out_from.
  ///
  /// In en, this message translates to:
  /// **'Log out from {tracker}?'**
  String log_out_from(Object tracker);

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get log_out;

  /// No description provided for @update_pending.
  ///
  /// In en, this message translates to:
  /// **'Update pending'**
  String get update_pending;

  /// No description provided for @update_all.
  ///
  /// In en, this message translates to:
  /// **'Update all'**
  String get update_all;

  /// No description provided for @backup_and_restore.
  ///
  /// In en, this message translates to:
  /// **'Backup and restore'**
  String get backup_and_restore;

  /// No description provided for @create_backup.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get create_backup;

  /// No description provided for @create_backup_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'What do you want to backup?'**
  String get create_backup_dialog_title;

  /// No description provided for @create_backup_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Can be used to restore current library'**
  String get create_backup_subtitle;

  /// No description provided for @restore_backup.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get restore_backup;

  /// No description provided for @encrypt_backups.
  ///
  /// In en, this message translates to:
  /// **'Encrypt backups'**
  String get encrypt_backups;

  /// No description provided for @encrypt_backups_info.
  ///
  /// In en, this message translates to:
  /// **'Password-protect backup files using AES encryption'**
  String get encrypt_backups_info;

  /// No description provided for @no_secure_storage.
  ///
  /// In en, this message translates to:
  /// **'No secure storage found'**
  String get no_secure_storage;

  /// No description provided for @no_keyring_warning.
  ///
  /// In en, this message translates to:
  /// **'This system doesn\'t have a keyring service available (e.g. gnome-keyring or kwallet on Linux), so the password can\'t be stored securely.\n\nStore it unencrypted in the local app database instead? Anyone with access to this device\'s app data would be able to read it.'**
  String get no_keyring_warning;

  /// No description provided for @enter_backup_password.
  ///
  /// In en, this message translates to:
  /// **'Enter backup password'**
  String get enter_backup_password;

  /// No description provided for @incorrect_password_try_again.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password, try again.'**
  String get incorrect_password_try_again;

  /// No description provided for @set_backup_password.
  ///
  /// In en, this message translates to:
  /// **'Set backup password'**
  String get set_backup_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirm_password;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @password_required_to_restore.
  ///
  /// In en, this message translates to:
  /// **'A password is required to restore this backup.'**
  String get password_required_to_restore;

  /// No description provided for @restore_backup_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore library from backup file'**
  String get restore_backup_subtitle;

  /// No description provided for @automatic_backups.
  ///
  /// In en, this message translates to:
  /// **'Automatic backups'**
  String get automatic_backups;

  /// No description provided for @backup_frequency.
  ///
  /// In en, this message translates to:
  /// **'Backup frequency'**
  String get backup_frequency;

  /// No description provided for @backup_location.
  ///
  /// In en, this message translates to:
  /// **'Backup location'**
  String get backup_location;

  /// No description provided for @backup_options.
  ///
  /// In en, this message translates to:
  /// **'Backup options'**
  String get backup_options;

  /// No description provided for @backup_options_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'What do you want to backup?'**
  String get backup_options_dialog_title;

  /// No description provided for @backup_options_subtitle.
  ///
  /// In en, this message translates to:
  /// **'What information to include in the backup file?'**
  String get backup_options_subtitle;

  /// No description provided for @backup_and_restore_warning_info.
  ///
  /// In en, this message translates to:
  /// **'You should keep copies of backups in other places as well'**
  String get backup_and_restore_warning_info;

  /// No description provided for @library_entries.
  ///
  /// In en, this message translates to:
  /// **'Library entries'**
  String get library_entries;

  /// No description provided for @chapters_and_episode.
  ///
  /// In en, this message translates to:
  /// **'Chapters and episode'**
  String get chapters_and_episode;

  /// No description provided for @every_6_hours.
  ///
  /// In en, this message translates to:
  /// **'Every 6 hours'**
  String get every_6_hours;

  /// No description provided for @every_12_hours.
  ///
  /// In en, this message translates to:
  /// **'Every 12 hours'**
  String get every_12_hours;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @every_2_days.
  ///
  /// In en, this message translates to:
  /// **'Every 2 days'**
  String get every_2_days;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @restore_backup_warning_title.
  ///
  /// In en, this message translates to:
  /// **'Restoring a backup will overwrite all existing data.\n\nContinue restoring?'**
  String get restore_backup_warning_title;

  /// No description provided for @restore_sync_question_title.
  ///
  /// In en, this message translates to:
  /// **'Sync this restore?'**
  String get restore_sync_question_title;

  /// No description provided for @restore_sync_question_message.
  ///
  /// In en, this message translates to:
  /// **'This device is connected to a sync server. Upload this restored data to it now? If not, sync will be turned off so the server\'s old data doesn\'t overwrite what you just restored.'**
  String get restore_sync_question_message;

  /// No description provided for @restore_sync_question_confirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, sync'**
  String get restore_sync_question_confirm;

  /// No description provided for @restore_sync_question_deny.
  ///
  /// In en, this message translates to:
  /// **'No, disable sync'**
  String get restore_sync_question_deny;

  /// No description provided for @sync_disabled_after_restore.
  ///
  /// In en, this message translates to:
  /// **'Sync is disabled. You can turn it on again in Settings.'**
  String get sync_disabled_after_restore;

  /// No description provided for @restore_sync_disabled_question_title.
  ///
  /// In en, this message translates to:
  /// **'Sync is currently disabled'**
  String get restore_sync_disabled_question_title;

  /// No description provided for @restore_sync_disabled_question_message.
  ///
  /// In en, this message translates to:
  /// **'Sync is turned off. Turn it back on and upload this restored data to your server?'**
  String get restore_sync_disabled_question_message;

  /// No description provided for @restore_sync_question_reenable.
  ///
  /// In en, this message translates to:
  /// **'Yes, re-enable and sync'**
  String get restore_sync_question_reenable;

  /// No description provided for @restore_sync_question_keep_disabled.
  ///
  /// In en, this message translates to:
  /// **'Keep it disabled'**
  String get restore_sync_question_keep_disabled;

  /// No description provided for @restore_sync_uploading.
  ///
  /// In en, this message translates to:
  /// **'Syncing restored data to server…'**
  String get restore_sync_uploading;

  /// No description provided for @restore_sync_upload_success.
  ///
  /// In en, this message translates to:
  /// **'Restored data synced to server'**
  String get restore_sync_upload_success;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @tracking_warning_info.
  ///
  /// In en, this message translates to:
  /// **'One-way sync to update the chapter progress in tracking services. Set up tracking for individual entries from their tracking button.'**
  String get tracking_warning_info;

  /// No description provided for @use_page_tap_zones.
  ///
  /// In en, this message translates to:
  /// **'Use page tap zones'**
  String get use_page_tap_zones;

  /// No description provided for @manage_trackers.
  ///
  /// In en, this message translates to:
  /// **'Manage trackers'**
  String get manage_trackers;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @backups.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get backups;

  /// No description provided for @by_scanlator.
  ///
  /// In en, this message translates to:
  /// **'By scanlator'**
  String get by_scanlator;

  /// No description provided for @by_name.
  ///
  /// In en, this message translates to:
  /// **'By name'**
  String get by_name;

  /// No description provided for @installed.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// No description provided for @auto_scroll.
  ///
  /// In en, this message translates to:
  /// **'Auto scroll'**
  String get auto_scroll;

  /// No description provided for @video_audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get video_audio;

  /// No description provided for @video_audio_info.
  ///
  /// In en, this message translates to:
  /// **'Preferred languages, pitch correction, audio channels'**
  String get video_audio_info;

  /// No description provided for @player.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get player;

  /// No description provided for @markEpisodeAsSeenSetting.
  ///
  /// In en, this message translates to:
  /// **'At what point to mark the episode as seen'**
  String get markEpisodeAsSeenSetting;

  /// No description provided for @mark_duplicate_chapters_read.
  ///
  /// In en, this message translates to:
  /// **'Mark duplicate chapter numbers as read'**
  String get mark_duplicate_chapters_read;

  /// No description provided for @default_skip_intro_length.
  ///
  /// In en, this message translates to:
  /// **'Intro skip duration'**
  String get default_skip_intro_length;

  /// No description provided for @default_playback_speed_length.
  ///
  /// In en, this message translates to:
  /// **'Default playback speed'**
  String get default_playback_speed_length;

  /// No description provided for @updateProgressAfterReading.
  ///
  /// In en, this message translates to:
  /// **'Update progress after reading'**
  String get updateProgressAfterReading;

  /// No description provided for @no_sources_installed.
  ///
  /// In en, this message translates to:
  /// **'No sources installed!'**
  String get no_sources_installed;

  /// No description provided for @show_extensions.
  ///
  /// In en, this message translates to:
  /// **'Show extensions'**
  String get show_extensions;

  /// No description provided for @default_skip_forward_skip_length.
  ///
  /// In en, this message translates to:
  /// **'Double-tap seek duration'**
  String get default_skip_forward_skip_length;

  /// No description provided for @aniskip_requires_info.
  ///
  /// In en, this message translates to:
  /// **'AniSkip requires the anime to be tracked with MAL or Anilist to work.'**
  String get aniskip_requires_info;

  /// No description provided for @enable_aniskip.
  ///
  /// In en, this message translates to:
  /// **'Enable AniSkip'**
  String get enable_aniskip;

  /// No description provided for @enable_auto_skip.
  ///
  /// In en, this message translates to:
  /// **'Enable auto skip'**
  String get enable_auto_skip;

  /// No description provided for @aniskip_button_timeout.
  ///
  /// In en, this message translates to:
  /// **'Button timeout'**
  String get aniskip_button_timeout;

  /// No description provided for @skip_opening.
  ///
  /// In en, this message translates to:
  /// **'Skip opening'**
  String get skip_opening;

  /// No description provided for @skip_ending.
  ///
  /// In en, this message translates to:
  /// **'Skip ending'**
  String get skip_ending;

  /// No description provided for @fullscreen.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get fullscreen;

  /// No description provided for @update_library.
  ///
  /// In en, this message translates to:
  /// **'Update library'**
  String get update_library;

  /// No description provided for @updating_library.
  ///
  /// In en, this message translates to:
  /// **'Updating library ({cur} / {max}) - Failed: {failed}'**
  String updating_library(Object cur, Object failed, Object max);

  /// No description provided for @next_chapter.
  ///
  /// In en, this message translates to:
  /// **'Next chapter'**
  String get next_chapter;

  /// No description provided for @next_5_chapters.
  ///
  /// In en, this message translates to:
  /// **'Next 5 chapters'**
  String get next_5_chapters;

  /// No description provided for @next_10_chapters.
  ///
  /// In en, this message translates to:
  /// **'Next 10 chapters'**
  String get next_10_chapters;

  /// No description provided for @next_25_chapters.
  ///
  /// In en, this message translates to:
  /// **'Next 25 chapters'**
  String get next_25_chapters;

  /// No description provided for @all_chapters.
  ///
  /// In en, this message translates to:
  /// **'All chapters'**
  String get all_chapters;

  /// No description provided for @next_episode.
  ///
  /// In en, this message translates to:
  /// **'Next episode'**
  String get next_episode;

  /// No description provided for @next_5_episodes.
  ///
  /// In en, this message translates to:
  /// **'Next 5 episodes'**
  String get next_5_episodes;

  /// No description provided for @next_10_episodes.
  ///
  /// In en, this message translates to:
  /// **'Next 10 episodes'**
  String get next_10_episodes;

  /// No description provided for @next_25_episodes.
  ///
  /// In en, this message translates to:
  /// **'Next 25 episodes'**
  String get next_25_episodes;

  /// No description provided for @all_episodes.
  ///
  /// In en, this message translates to:
  /// **'All episodes'**
  String get all_episodes;

  /// No description provided for @cover_saved.
  ///
  /// In en, this message translates to:
  /// **'Cover saved'**
  String get cover_saved;

  /// No description provided for @set_as_cover.
  ///
  /// In en, this message translates to:
  /// **'Set as cover'**
  String get set_as_cover;

  /// No description provided for @use_this_as_cover_art.
  ///
  /// In en, this message translates to:
  /// **'Use this as cover art?'**
  String get use_this_as_cover_art;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @picture_saved.
  ///
  /// In en, this message translates to:
  /// **'Picture saved'**
  String get picture_saved;

  /// No description provided for @cover_updated.
  ///
  /// In en, this message translates to:
  /// **'Cover updated'**
  String get cover_updated;

  /// No description provided for @include_subtitles.
  ///
  /// In en, this message translates to:
  /// **'Include subtitles'**
  String get include_subtitles;

  /// No description provided for @blend_mode_default.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get blend_mode_default;

  /// No description provided for @blend_mode_multiply.
  ///
  /// In en, this message translates to:
  /// **'Multiply'**
  String get blend_mode_multiply;

  /// No description provided for @blend_mode_screen.
  ///
  /// In en, this message translates to:
  /// **'Screen'**
  String get blend_mode_screen;

  /// No description provided for @blend_mode_overlay.
  ///
  /// In en, this message translates to:
  /// **'Overlay'**
  String get blend_mode_overlay;

  /// No description provided for @blend_mode_colorDodge.
  ///
  /// In en, this message translates to:
  /// **'ColorDodge'**
  String get blend_mode_colorDodge;

  /// No description provided for @blend_mode_lighten.
  ///
  /// In en, this message translates to:
  /// **'Lighten'**
  String get blend_mode_lighten;

  /// No description provided for @blend_mode_colorBurn.
  ///
  /// In en, this message translates to:
  /// **'ColorBurn'**
  String get blend_mode_colorBurn;

  /// No description provided for @blend_mode_darken.
  ///
  /// In en, this message translates to:
  /// **'Darken'**
  String get blend_mode_darken;

  /// No description provided for @blend_mode_difference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get blend_mode_difference;

  /// No description provided for @blend_mode_saturation.
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get blend_mode_saturation;

  /// No description provided for @blend_mode_softLight.
  ///
  /// In en, this message translates to:
  /// **'SoftLight'**
  String get blend_mode_softLight;

  /// No description provided for @blend_mode_plus.
  ///
  /// In en, this message translates to:
  /// **'Plus'**
  String get blend_mode_plus;

  /// No description provided for @blend_mode_exclusion.
  ///
  /// In en, this message translates to:
  /// **'Exclusion'**
  String get blend_mode_exclusion;

  /// No description provided for @custom_color_filter.
  ///
  /// In en, this message translates to:
  /// **'Custom color filter'**
  String get custom_color_filter;

  /// No description provided for @color_filter_blend_mode.
  ///
  /// In en, this message translates to:
  /// **'Color filter blend mode'**
  String get color_filter_blend_mode;

  /// No description provided for @enable_all.
  ///
  /// In en, this message translates to:
  /// **'Enable all'**
  String get enable_all;

  /// No description provided for @disable_all.
  ///
  /// In en, this message translates to:
  /// **'Disable all'**
  String get disable_all;

  /// No description provided for @font.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get font;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @font_size.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get font_size;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @border.
  ///
  /// In en, this message translates to:
  /// **'Border'**
  String get border;

  /// No description provided for @background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get background;

  /// No description provided for @no_subtite_warning_message.
  ///
  /// In en, this message translates to:
  /// **'Has no effect because there aren\'t any subtitle tracks in this video'**
  String get no_subtite_warning_message;

  /// No description provided for @grid_size.
  ///
  /// In en, this message translates to:
  /// **'Grid size'**
  String get grid_size;

  /// No description provided for @n_per_row.
  ///
  /// In en, this message translates to:
  /// **'{n} per row'**
  String n_per_row(Object n);

  /// No description provided for @horizontal_continious.
  ///
  /// In en, this message translates to:
  /// **'Horizontal continuous'**
  String get horizontal_continious;

  /// No description provided for @edit_code.
  ///
  /// In en, this message translates to:
  /// **'Edit code'**
  String get edit_code;

  /// No description provided for @use_libass.
  ///
  /// In en, this message translates to:
  /// **'Enable libass'**
  String get use_libass;

  /// No description provided for @use_libass_info.
  ///
  /// In en, this message translates to:
  /// **'Use libass based subtitle rendering for native backend.'**
  String get use_libass_info;

  /// No description provided for @libass_not_disable_message.
  ///
  /// In en, this message translates to:
  /// **'Disable `use libass` in player settings to be able to customize the subtitles.'**
  String get libass_not_disable_message;

  /// No description provided for @override_ass_subtitles.
  ///
  /// In en, this message translates to:
  /// **'Override ASS subtitles'**
  String get override_ass_subtitles;

  /// No description provided for @override_ass_subtitles_info.
  ///
  /// In en, this message translates to:
  /// **'Apply custom styling to ASS/SSA subtitles'**
  String get override_ass_subtitles_info;

  /// No description provided for @torrent_stream.
  ///
  /// In en, this message translates to:
  /// **'Torrent Stream'**
  String get torrent_stream;

  /// No description provided for @add_torrent.
  ///
  /// In en, this message translates to:
  /// **'Add torrent'**
  String get add_torrent;

  /// No description provided for @enter_torrent_hint_text.
  ///
  /// In en, this message translates to:
  /// **'Enter magnet or torrent file url'**
  String get enter_torrent_hint_text;

  /// No description provided for @torrent_url.
  ///
  /// In en, this message translates to:
  /// **'Torrent url'**
  String get torrent_url;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @advanced_info.
  ///
  /// In en, this message translates to:
  /// **'mpv config'**
  String get advanced_info;

  /// No description provided for @use_native_http_client.
  ///
  /// In en, this message translates to:
  /// **'Use native http client'**
  String get use_native_http_client;

  /// No description provided for @use_native_http_client_info.
  ///
  /// In en, this message translates to:
  /// **'it automatically supports platform features such VPNs, support more HTTP features such as HTTP/3 and custom redirect handling'**
  String get use_native_http_client_info;

  /// No description provided for @n_hour_ago.
  ///
  /// In en, this message translates to:
  /// **'{hour} hour ago'**
  String n_hour_ago(Object hour);

  /// No description provided for @n_hours_ago.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String n_hours_ago(Object hours);

  /// No description provided for @n_minute_ago.
  ///
  /// In en, this message translates to:
  /// **'{minute} minute ago'**
  String n_minute_ago(Object minute);

  /// No description provided for @n_minutes_ago.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes ago'**
  String n_minutes_ago(Object minutes);

  /// No description provided for @n_day_ago.
  ///
  /// In en, this message translates to:
  /// **'{day} day ago'**
  String n_day_ago(Object day);

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get now;

  /// No description provided for @library_last_updated.
  ///
  /// In en, this message translates to:
  /// **'Library last updated: {lastUpdated}'**
  String library_last_updated(Object lastUpdated);

  /// No description provided for @data_and_storage.
  ///
  /// In en, this message translates to:
  /// **'Data and storage'**
  String get data_and_storage;

  /// No description provided for @download_location_info.
  ///
  /// In en, this message translates to:
  /// **'Used for chapter downloads'**
  String get download_location_info;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @clear_chapter_and_episode_cache.
  ///
  /// In en, this message translates to:
  /// **'Clear chapter and episode cache'**
  String get clear_chapter_and_episode_cache;

  /// No description provided for @cache_cleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get cache_cleared;

  /// No description provided for @clear_chapter_or_episode_cache_on_app_launch.
  ///
  /// In en, this message translates to:
  /// **'Clear chapter/episode cache on app launch'**
  String get clear_chapter_or_episode_cache_on_app_launch;

  /// No description provided for @app_settings.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get app_settings;

  /// No description provided for @sources_settings.
  ///
  /// In en, this message translates to:
  /// **'Sources settings'**
  String get sources_settings;

  /// No description provided for @include_sensitive_settings.
  ///
  /// In en, this message translates to:
  /// **'Include sensitive settings (e.g., tracker login tokens)'**
  String get include_sensitive_settings;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @downloads_are_limited_to_wifi.
  ///
  /// In en, this message translates to:
  /// **'Downloads are limited to Wi-Fi only'**
  String get downloads_are_limited_to_wifi;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @recommendations_similar.
  ///
  /// In en, this message translates to:
  /// **'similar'**
  String get recommendations_similar;

  /// No description provided for @recommendations_weights.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Weights'**
  String get recommendations_weights;

  /// No description provided for @recommendations_weights_genre.
  ///
  /// In en, this message translates to:
  /// **'Genre Similarity'**
  String get recommendations_weights_genre;

  /// No description provided for @recommendations_weights_setting.
  ///
  /// In en, this message translates to:
  /// **'Setting Similarity'**
  String get recommendations_weights_setting;

  /// No description provided for @recommendations_weights_synopsis.
  ///
  /// In en, this message translates to:
  /// **'Story Similarity'**
  String get recommendations_weights_synopsis;

  /// No description provided for @recommendations_weights_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme Similarity'**
  String get recommendations_weights_theme;

  /// No description provided for @manga_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'Manga extensions repo'**
  String get manga_extensions_repo;

  /// No description provided for @anime_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'Anime extensions repo'**
  String get anime_extensions_repo;

  /// No description provided for @novel_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'Novel extensions repo'**
  String get novel_extensions_repo;

  /// No description provided for @custom_dns.
  ///
  /// In en, this message translates to:
  /// **'Custom DNS (leave blank to use system DNS)'**
  String get custom_dns;

  /// No description provided for @android_proxy_server.
  ///
  /// In en, this message translates to:
  /// **'Android Proxy Server (M-Extension-Server)'**
  String get android_proxy_server;

  /// No description provided for @get_m_extension_server.
  ///
  /// In en, this message translates to:
  /// **'Get M-Extension-Server'**
  String get get_m_extension_server;

  /// No description provided for @get_sync_server.
  ///
  /// In en, this message translates to:
  /// **'Get Sync Server here'**
  String get get_sync_server;

  /// No description provided for @undefined.
  ///
  /// In en, this message translates to:
  /// **'undefined'**
  String get undefined;

  /// No description provided for @empty_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'No extension repositories yet'**
  String get empty_extensions_repo;

  /// No description provided for @add_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'Add repo URL'**
  String get add_extensions_repo;

  /// No description provided for @remove_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'Remove repo URL'**
  String get remove_extensions_repo;

  /// No description provided for @manage_manga_repo_urls.
  ///
  /// In en, this message translates to:
  /// **'Manage Manga Repo URLs'**
  String get manage_manga_repo_urls;

  /// No description provided for @manage_anime_repo_urls.
  ///
  /// In en, this message translates to:
  /// **'Manage Anime Repo URLs'**
  String get manage_anime_repo_urls;

  /// No description provided for @manage_novel_repo_urls.
  ///
  /// In en, this message translates to:
  /// **'Manage Novel Repo URLs'**
  String get manage_novel_repo_urls;

  /// No description provided for @url_cannot_be_empty.
  ///
  /// In en, this message translates to:
  /// **'URL cannot be empty'**
  String get url_cannot_be_empty;

  /// No description provided for @url_must_end_with_dot_json_or_dot_pb.
  ///
  /// In en, this message translates to:
  /// **'URL must end with .json / .pb'**
  String get url_must_end_with_dot_json_or_dot_pb;

  /// No description provided for @repo_url.
  ///
  /// In en, this message translates to:
  /// **'Repo URL'**
  String get repo_url;

  /// No description provided for @invalid_url_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL format'**
  String get invalid_url_format;

  /// No description provided for @clear_all_sources.
  ///
  /// In en, this message translates to:
  /// **'Clear all sources'**
  String get clear_all_sources;

  /// No description provided for @clear_all_sources_msg.
  ///
  /// In en, this message translates to:
  /// **'This will completely erase all sources of the application. Are you sure you want to continue?'**
  String get clear_all_sources_msg;

  /// No description provided for @sources_cleared.
  ///
  /// In en, this message translates to:
  /// **'Sources cleared!!!'**
  String get sources_cleared;

  /// No description provided for @repo_added.
  ///
  /// In en, this message translates to:
  /// **'Source repository added!'**
  String get repo_added;

  /// No description provided for @repo_already_exists.
  ///
  /// In en, this message translates to:
  /// **'Repository already exists!'**
  String get repo_already_exists;

  /// No description provided for @add_repo.
  ///
  /// In en, this message translates to:
  /// **'Add Repository?'**
  String get add_repo;

  /// No description provided for @add_repo_sources_to_add.
  ///
  /// In en, this message translates to:
  /// **'Extension lists that will be added:'**
  String get add_repo_sources_to_add;

  /// No description provided for @add_repo_warning.
  ///
  /// In en, this message translates to:
  /// **'Extensions from these repositories run inside the app. Only add repositories you trust.'**
  String get add_repo_warning;

  /// No description provided for @genre_search_library.
  ///
  /// In en, this message translates to:
  /// **'Search genre in library'**
  String get genre_search_library;

  /// No description provided for @genre_search_source.
  ///
  /// In en, this message translates to:
  /// **'Browse in source'**
  String get genre_search_source;

  /// No description provided for @source_not_added.
  ///
  /// In en, this message translates to:
  /// **'Source is not installed!'**
  String get source_not_added;

  /// No description provided for @load_own_subtitles.
  ///
  /// In en, this message translates to:
  /// **'Load your own subtitles...'**
  String get load_own_subtitles;

  /// No description provided for @search_subtitles.
  ///
  /// In en, this message translates to:
  /// **'Search subtitles online...'**
  String get search_subtitles;

  /// No description provided for @extension_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes: {notes}'**
  String extension_notes(Object notes);

  /// No description provided for @unsupported_repo.
  ///
  /// In en, this message translates to:
  /// **'You\'ve tried to add an unsupported repository. Please check the discord server for support!'**
  String get unsupported_repo;

  /// No description provided for @end_of_chapter.
  ///
  /// In en, this message translates to:
  /// **'End of chapter'**
  String get end_of_chapter;

  /// No description provided for @chapter_completed.
  ///
  /// In en, this message translates to:
  /// **'Chapter completed'**
  String get chapter_completed;

  /// No description provided for @continue_to_next_chapter.
  ///
  /// In en, this message translates to:
  /// **'Continue scrolling to read the next chapter'**
  String get continue_to_next_chapter;

  /// No description provided for @no_next_chapter.
  ///
  /// In en, this message translates to:
  /// **'No next chapter'**
  String get no_next_chapter;

  /// No description provided for @you_have_finished_reading.
  ///
  /// In en, this message translates to:
  /// **'You have finished reading'**
  String get you_have_finished_reading;

  /// No description provided for @return_to_the_list_of_chapters.
  ///
  /// In en, this message translates to:
  /// **'Return to the list of chapters'**
  String get return_to_the_list_of_chapters;

  /// No description provided for @hwdec.
  ///
  /// In en, this message translates to:
  /// **'Hardware Decoder'**
  String get hwdec;

  /// No description provided for @enable_hardware_accel.
  ///
  /// In en, this message translates to:
  /// **'Hardware Acceleration'**
  String get enable_hardware_accel;

  /// No description provided for @enable_hardware_accel_info.
  ///
  /// In en, this message translates to:
  /// **'Turn it on/off if you are experiencing bugs or crashes'**
  String get enable_hardware_accel_info;

  /// No description provided for @track_library_navigate.
  ///
  /// In en, this message translates to:
  /// **'Go to existing local entry'**
  String get track_library_navigate;

  /// No description provided for @track_library_add.
  ///
  /// In en, this message translates to:
  /// **'Add to local library'**
  String get track_library_add;

  /// No description provided for @track_library_add_confirm.
  ///
  /// In en, this message translates to:
  /// **'Add tracked item to local library'**
  String get track_library_add_confirm;

  /// No description provided for @track_library_not_logged.
  ///
  /// In en, this message translates to:
  /// **'Login to the corresponding tracker to use this feature!'**
  String get track_library_not_logged;

  /// No description provided for @track_library_switch.
  ///
  /// In en, this message translates to:
  /// **'Switch to another tracker'**
  String get track_library_switch;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get go_back;

  /// No description provided for @merge_library_nav_mobile.
  ///
  /// In en, this message translates to:
  /// **'Merge library navigation on mobile'**
  String get merge_library_nav_mobile;

  /// No description provided for @enable_discord_rpc.
  ///
  /// In en, this message translates to:
  /// **'Enable Discord RPC'**
  String get enable_discord_rpc;

  /// No description provided for @hide_discord_rpc_incognito.
  ///
  /// In en, this message translates to:
  /// **'Hide Discord RPC while in Incognito'**
  String get hide_discord_rpc_incognito;

  /// No description provided for @rpc_show_reading_watching_progress.
  ///
  /// In en, this message translates to:
  /// **'Show current chapter in Discord (requires a restart)'**
  String get rpc_show_reading_watching_progress;

  /// No description provided for @rpc_show_title.
  ///
  /// In en, this message translates to:
  /// **'Show current title in Discord'**
  String get rpc_show_title;

  /// No description provided for @rpc_show_cover_image.
  ///
  /// In en, this message translates to:
  /// **'Show current cover image in Discord'**
  String get rpc_show_cover_image;

  /// No description provided for @enable_mpv.
  ///
  /// In en, this message translates to:
  /// **'Enable mpv shaders / scripts'**
  String get enable_mpv;

  /// No description provided for @mpv_info.
  ///
  /// In en, this message translates to:
  /// **'Supports .js scripts under mpv/scripts/'**
  String get mpv_info;

  /// No description provided for @mpv_redownload.
  ///
  /// In en, this message translates to:
  /// **'Redownload mpv config files'**
  String get mpv_redownload;

  /// No description provided for @mpv_redownload_info.
  ///
  /// In en, this message translates to:
  /// **'Replaces old config files with new one!'**
  String get mpv_redownload_info;

  /// No description provided for @mpv_download.
  ///
  /// In en, this message translates to:
  /// **'MPV config files are required!\nDownload now?'**
  String get mpv_download;

  /// No description provided for @custom_buttons.
  ///
  /// In en, this message translates to:
  /// **'Custom buttons'**
  String get custom_buttons;

  /// No description provided for @custom_buttons_info.
  ///
  /// In en, this message translates to:
  /// **'Execute lua code with custom buttons'**
  String get custom_buttons_info;

  /// No description provided for @custom_buttons_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit custom buttons'**
  String get custom_buttons_edit;

  /// No description provided for @custom_buttons_add.
  ///
  /// In en, this message translates to:
  /// **'Add custom button'**
  String get custom_buttons_add;

  /// No description provided for @custom_buttons_added.
  ///
  /// In en, this message translates to:
  /// **'Custom button added!'**
  String get custom_buttons_added;

  /// No description provided for @custom_buttons_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete custom button'**
  String get custom_buttons_delete;

  /// No description provided for @custom_buttons_text.
  ///
  /// In en, this message translates to:
  /// **'Button text'**
  String get custom_buttons_text;

  /// No description provided for @custom_buttons_text_req.
  ///
  /// In en, this message translates to:
  /// **'Button text required'**
  String get custom_buttons_text_req;

  /// No description provided for @custom_buttons_js_code.
  ///
  /// In en, this message translates to:
  /// **'lua code'**
  String get custom_buttons_js_code;

  /// No description provided for @custom_buttons_js_code_req.
  ///
  /// In en, this message translates to:
  /// **'lua code required'**
  String get custom_buttons_js_code_req;

  /// No description provided for @custom_buttons_js_code_long.
  ///
  /// In en, this message translates to:
  /// **'lua code (on long press)'**
  String get custom_buttons_js_code_long;

  /// No description provided for @custom_buttons_startup.
  ///
  /// In en, this message translates to:
  /// **'lua code (on startup)'**
  String get custom_buttons_startup;

  /// No description provided for @custom_buttons_add_warning.
  ///
  /// In en, this message translates to:
  /// **'This button runs the Lua code below in the video player, which can access your files and run programs. Only add it if you trust where this link came from.'**
  String get custom_buttons_add_warning;

  /// No description provided for @n_days.
  ///
  /// In en, this message translates to:
  /// **'{n} days'**
  String n_days(Object n);

  /// No description provided for @decoder.
  ///
  /// In en, this message translates to:
  /// **'Decoder'**
  String get decoder;

  /// No description provided for @decoder_info.
  ///
  /// In en, this message translates to:
  /// **'Hardware decoding, pixel format, debanding'**
  String get decoder_info;

  /// No description provided for @enable_gpu_next.
  ///
  /// In en, this message translates to:
  /// **'Enable gpu-next (Android only)'**
  String get enable_gpu_next;

  /// No description provided for @enable_gpu_next_info.
  ///
  /// In en, this message translates to:
  /// **'A new video rendering backend'**
  String get enable_gpu_next_info;

  /// No description provided for @debanding.
  ///
  /// In en, this message translates to:
  /// **'Debanding'**
  String get debanding;

  /// No description provided for @use_yuv420p.
  ///
  /// In en, this message translates to:
  /// **'Use YUV420P pixel format'**
  String get use_yuv420p;

  /// No description provided for @use_yuv420p_info.
  ///
  /// In en, this message translates to:
  /// **'May fix black screens on some video codecs, can also improve performance at the cost of quality'**
  String get use_yuv420p_info;

  /// No description provided for @audio_preferred_languages.
  ///
  /// In en, this message translates to:
  /// **'Preferred languages'**
  String get audio_preferred_languages;

  /// No description provided for @audio_preferred_languages_info.
  ///
  /// In en, this message translates to:
  /// **'Audio languages to prefer when a video has multiple audio tracks. Use two- or three-letter codes, separated by commas (for example: ja, en).'**
  String get audio_preferred_languages_info;

  /// No description provided for @enable_audio_pitch_correction.
  ///
  /// In en, this message translates to:
  /// **'Enable audio pitch correction'**
  String get enable_audio_pitch_correction;

  /// No description provided for @enable_audio_pitch_correction_info.
  ///
  /// In en, this message translates to:
  /// **'Prevents the audio from becoming high-pitched at faster speeds and low-pitched at slower speeds'**
  String get enable_audio_pitch_correction_info;

  /// No description provided for @audio_channels.
  ///
  /// In en, this message translates to:
  /// **'Audio channels'**
  String get audio_channels;

  /// No description provided for @volume_boost_cap.
  ///
  /// In en, this message translates to:
  /// **'Volume boost cap'**
  String get volume_boost_cap;

  /// No description provided for @internal_player.
  ///
  /// In en, this message translates to:
  /// **'Internal player'**
  String get internal_player;

  /// No description provided for @internal_player_info.
  ///
  /// In en, this message translates to:
  /// **'Progress, controls, orientation'**
  String get internal_player_info;

  /// No description provided for @subtitle_delay_text.
  ///
  /// In en, this message translates to:
  /// **'Subtitle delay'**
  String get subtitle_delay_text;

  /// No description provided for @subtitle_delay.
  ///
  /// In en, this message translates to:
  /// **'Delay (ms)'**
  String get subtitle_delay;

  /// No description provided for @subtitle_speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get subtitle_speed;

  /// No description provided for @tracks.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get tracks;

  /// No description provided for @playback_speed.
  ///
  /// In en, this message translates to:
  /// **'Playback speed'**
  String get playback_speed;

  /// No description provided for @shaders.
  ///
  /// In en, this message translates to:
  /// **'Shaders'**
  String get shaders;

  /// No description provided for @video_fit.
  ///
  /// In en, this message translates to:
  /// **'Fit'**
  String get video_fit;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @calendar_no_data.
  ///
  /// In en, this message translates to:
  /// **'No data yet.'**
  String get calendar_no_data;

  /// No description provided for @calendar_info.
  ///
  /// In en, this message translates to:
  /// **'The calendar is only able to predict the next chapter upload based on the older uploads. Some data might not be 100% accurate!'**
  String get calendar_info;

  /// No description provided for @in_n_day.
  ///
  /// In en, this message translates to:
  /// **'in {days} day'**
  String in_n_day(Object days);

  /// No description provided for @in_n_days.
  ///
  /// In en, this message translates to:
  /// **'in {days} days'**
  String in_n_days(Object days);

  /// No description provided for @clear_library.
  ///
  /// In en, this message translates to:
  /// **'Clear library'**
  String get clear_library;

  /// No description provided for @clear_library_desc.
  ///
  /// In en, this message translates to:
  /// **'Choose to clear all manga, anime and/or novel entries'**
  String get clear_library_desc;

  /// No description provided for @clear_library_input.
  ///
  /// In en, this message translates to:
  /// **'Type \'manga\', \'anime\' and/or \'novel\' (separated by a comma) to remove all related entries'**
  String get clear_library_input;

  /// No description provided for @watch_order.
  ///
  /// In en, this message translates to:
  /// **'Watch order'**
  String get watch_order;

  /// Role label for the title currently being viewed in a watch order.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get watch_order_role_current;

  /// Role label for an earlier title in a watch order.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get watch_order_role_previous;

  /// Role label for a later title in a watch order.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get watch_order_role_next;

  /// Source label for a watch order based on release dates.
  ///
  /// In en, this message translates to:
  /// **'Release order'**
  String get watch_order_source_release_order;

  /// Source label for a community-created Trakt list.
  ///
  /// In en, this message translates to:
  /// **'{name} by {author}'**
  String watch_order_source_community_list(String name, String author);

  /// Source label for an official Trakt collection.
  ///
  /// In en, this message translates to:
  /// **'Official Trakt collection: {name}'**
  String watch_order_source_official_collection(String name);

  /// Source label for a Trakt collection when it is not marked as official.
  ///
  /// In en, this message translates to:
  /// **'Trakt collection: {name}'**
  String watch_order_source_trakt_collection(String name);

  /// Fallback source label when the watch order contains a show's seasons.
  ///
  /// In en, this message translates to:
  /// **'Seasons for {title}'**
  String watch_order_source_seasons(String title);

  /// Label for choosing among available watch-order sources.
  ///
  /// In en, this message translates to:
  /// **'Order source'**
  String get watch_order_select_source;

  /// Season metadata shown in a watch order.
  ///
  /// In en, this message translates to:
  /// **'Season {number}'**
  String watch_order_season(int number);

  /// Episode metadata shown in a watch order.
  ///
  /// In en, this message translates to:
  /// **'Episode {number}'**
  String watch_order_episode(int number);

  /// No description provided for @sequels.
  ///
  /// In en, this message translates to:
  /// **'Sequels'**
  String get sequels;

  /// No description provided for @recommendations_similarity.
  ///
  /// In en, this message translates to:
  /// **'Similarity:'**
  String get recommendations_similarity;

  /// Accessible label for a recommendation rating in the provider's display format.
  ///
  /// In en, this message translates to:
  /// **'Rating {rating}'**
  String recommendation_rating_accessibility(String rating);

  /// No description provided for @local_folder_structure.
  ///
  /// In en, this message translates to:
  /// **'Structure of a local folder'**
  String get local_folder_structure;

  /// No description provided for @local_folder.
  ///
  /// In en, this message translates to:
  /// **'Local folders'**
  String get local_folder;

  /// No description provided for @add_local_folder.
  ///
  /// In en, this message translates to:
  /// **'Add local folder'**
  String get add_local_folder;

  /// No description provided for @rescan_local_folder.
  ///
  /// In en, this message translates to:
  /// **'Rescan all local folders now'**
  String get rescan_local_folder;

  /// No description provided for @default_download_destination.
  ///
  /// In en, this message translates to:
  /// **'Default download destination'**
  String get default_download_destination;

  /// No description provided for @ask_download_destination.
  ///
  /// In en, this message translates to:
  /// **'Ask for download destination'**
  String get ask_download_destination;

  /// No description provided for @ask_download_destination_desc.
  ///
  /// In en, this message translates to:
  /// **'Choose a local folder each time a download starts.'**
  String get ask_download_destination_desc;

  /// No description provided for @select_download_destination.
  ///
  /// In en, this message translates to:
  /// **'Select download destination'**
  String get select_download_destination;

  /// No description provided for @clear_local_library.
  ///
  /// In en, this message translates to:
  /// **'Clear local library'**
  String get clear_local_library;

  /// No description provided for @clear_local_library_desc.
  ///
  /// In en, this message translates to:
  /// **'Remove local folder and archive entries from the library.'**
  String get clear_local_library_desc;

  /// No description provided for @clear_local_library_msg.
  ///
  /// In en, this message translates to:
  /// **'This will remove local folder and archive entries from your library. It will not delete files from disk.'**
  String get clear_local_library_msg;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @no_local_folder_available_for_downloads.
  ///
  /// In en, this message translates to:
  /// **'No local folder is available for downloads'**
  String get no_local_folder_available_for_downloads;

  /// No description provided for @failed_to_create_cbz.
  ///
  /// In en, this message translates to:
  /// **'Failed to create CBZ: {error}'**
  String failed_to_create_cbz(Object error);

  /// No description provided for @error_reading_cover_image.
  ///
  /// In en, this message translates to:
  /// **'Error reading cover image: {error}'**
  String error_reading_cover_image(Object error);

  /// No description provided for @error_reading_metadata.
  ///
  /// In en, this message translates to:
  /// **'Error reading metadata: {error}'**
  String error_reading_metadata(Object error);

  /// No description provided for @error_saving_chapter_episode_to_library.
  ///
  /// In en, this message translates to:
  /// **'Error saving chapter/episode to library: {error}'**
  String error_saving_chapter_episode_to_library(Object error);

  /// No description provided for @error_reading_chapter_cover_image.
  ///
  /// In en, this message translates to:
  /// **'Error reading chapter cover image: {error}'**
  String error_reading_chapter_cover_image(Object error);

  /// No description provided for @error_reading_archive_cover_image.
  ///
  /// In en, this message translates to:
  /// **'Error reading archive cover image: {error}'**
  String error_reading_archive_cover_image(Object error);

  /// No description provided for @error_getting_local_library.
  ///
  /// In en, this message translates to:
  /// **'Error getting local library: {error}'**
  String error_getting_local_library(Object error);

  /// No description provided for @export_metadata.
  ///
  /// In en, this message translates to:
  /// **'Export metadata'**
  String get export_metadata;

  /// No description provided for @exported.
  ///
  /// In en, this message translates to:
  /// **'Exported'**
  String get exported;

  /// No description provided for @failed_to_export_metadata.
  ///
  /// In en, this message translates to:
  /// **'Failed to export metadata: {error}'**
  String failed_to_export_metadata(Object error);

  /// No description provided for @unrecognized_chapter_numbers.
  ///
  /// In en, this message translates to:
  /// **'{count} chapter(s) couldn\'t be auto-numbered and may be out of order or missing from the reader.'**
  String unrecognized_chapter_numbers(Object count);

  /// No description provided for @cloudflare_resolution_webview_server_start_failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start Cloudflare Resolution Webview Server.'**
  String get cloudflare_resolution_webview_server_start_failed;

  /// No description provided for @tracker_token_expired.
  ///
  /// In en, this message translates to:
  /// **'{tracker} Token expired'**
  String tracker_token_expired(Object tracker);

  /// No description provided for @video_list_empty.
  ///
  /// In en, this message translates to:
  /// **'Video list is empty'**
  String get video_list_empty;

  /// No description provided for @playback_speed_multiplier.
  ///
  /// In en, this message translates to:
  /// **'x{value}'**
  String playback_speed_multiplier(Object value);

  /// No description provided for @could_not_launch_url.
  ///
  /// In en, this message translates to:
  /// **'Could not launch {url}'**
  String could_not_launch_url(Object url);

  /// No description provided for @text_size.
  ///
  /// In en, this message translates to:
  /// **'Text Size :'**
  String get text_size;

  /// No description provided for @text_align.
  ///
  /// In en, this message translates to:
  /// **'Text Align'**
  String get text_align;

  /// No description provided for @line_height.
  ///
  /// In en, this message translates to:
  /// **'Line Height'**
  String get line_height;

  /// No description provided for @show_scroll_percentage.
  ///
  /// In en, this message translates to:
  /// **'Show Scroll Percentage'**
  String get show_scroll_percentage;

  /// No description provided for @remove_extra_paragraph_spacing.
  ///
  /// In en, this message translates to:
  /// **'Remove Extra Paragraph Spacing'**
  String get remove_extra_paragraph_spacing;

  /// No description provided for @select_label_color.
  ///
  /// In en, this message translates to:
  /// **'Select {label} Color'**
  String select_label_color(Object label);

  /// No description provided for @default_user_agent.
  ///
  /// In en, this message translates to:
  /// **'Default user agent'**
  String get default_user_agent;

  /// No description provided for @forceLandscapeMode.
  ///
  /// In en, this message translates to:
  /// **'Force landscape mode'**
  String get forceLandscapeMode;

  /// No description provided for @forceLandscapeModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Force the player to use landscape orientation.'**
  String get forceLandscapeModeSubtitle;

  /// No description provided for @dns_over_https.
  ///
  /// In en, this message translates to:
  /// **'DNS-over-HTTPS (DoH)'**
  String get dns_over_https;

  /// No description provided for @dns_provider.
  ///
  /// In en, this message translates to:
  /// **'DNS Provider'**
  String get dns_provider;

  /// No description provided for @tracked.
  ///
  /// In en, this message translates to:
  /// **'Tracked'**
  String get tracked;

  /// No description provided for @auth_unlock_msg.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to unlock the app'**
  String get auth_unlock_msg;

  /// No description provided for @app_locked.
  ///
  /// In en, this message translates to:
  /// **'App locked'**
  String get app_locked;

  /// No description provided for @auth_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to continue'**
  String get auth_to_continue;

  /// No description provided for @authenticating.
  ///
  /// In en, this message translates to:
  /// **'Authenticating...'**
  String get authenticating;

  /// No description provided for @lock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lock;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @auth_to_change_security_setting.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to change security settings'**
  String get auth_to_change_security_setting;

  /// No description provided for @app_lock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get app_lock;

  /// No description provided for @require_biometric_or_device_credential.
  ///
  /// In en, this message translates to:
  /// **'Require biometric or device credential to open the app'**
  String get require_biometric_or_device_credential;

  /// No description provided for @biometric_or_device_credential_not_available.
  ///
  /// In en, this message translates to:
  /// **'Biometric or device credential authentication is not available on this device'**
  String get biometric_or_device_credential_not_available;

  /// No description provided for @app_lock_description.
  ///
  /// In en, this message translates to:
  /// **'When app lock is enabled, you will be asked to authenticate every time you open the app or switch back to it from the background.'**
  String get app_lock_description;

  /// No description provided for @checking_device_authentication.
  ///
  /// In en, this message translates to:
  /// **'Checking device authentication…'**
  String get checking_device_authentication;

  /// No description provided for @device_authentication_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Authentication was not completed. Your setting has not changed.'**
  String get device_authentication_incomplete;

  /// No description provided for @keep_screen_on.
  ///
  /// In en, this message translates to:
  /// **'Keep screen on'**
  String get keep_screen_on;

  /// No description provided for @webtoon_side_padding.
  ///
  /// In en, this message translates to:
  /// **'Webtoon side padding'**
  String get webtoon_side_padding;

  /// No description provided for @show_page_gaps.
  ///
  /// In en, this message translates to:
  /// **'Show page gaps'**
  String get show_page_gaps;

  /// No description provided for @invert_colors.
  ///
  /// In en, this message translates to:
  /// **'Invert colors'**
  String get invert_colors;

  /// No description provided for @grayscale.
  ///
  /// In en, this message translates to:
  /// **'Grayscale'**
  String get grayscale;

  /// No description provided for @brightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get brightness;

  /// No description provided for @contrast.
  ///
  /// In en, this message translates to:
  /// **'Contrast'**
  String get contrast;

  /// No description provided for @saturation.
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get saturation;

  /// No description provided for @navigation_layout.
  ///
  /// In en, this message translates to:
  /// **'Navigation layout'**
  String get navigation_layout;

  /// No description provided for @nav_layout_default.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get nav_layout_default;

  /// No description provided for @nav_layout_l_shaped.
  ///
  /// In en, this message translates to:
  /// **'L-shaped'**
  String get nav_layout_l_shaped;

  /// No description provided for @nav_layout_kindle.
  ///
  /// In en, this message translates to:
  /// **'Kindle-ish'**
  String get nav_layout_kindle;

  /// No description provided for @nav_layout_edge.
  ///
  /// In en, this message translates to:
  /// **'Edge'**
  String get nav_layout_edge;

  /// No description provided for @nav_layout_right_and_left.
  ///
  /// In en, this message translates to:
  /// **'Right and left'**
  String get nav_layout_right_and_left;

  /// No description provided for @nav_layout_disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get nav_layout_disabled;

  /// No description provided for @color_enhancements.
  ///
  /// In en, this message translates to:
  /// **'Color enhancements'**
  String get color_enhancements;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @mean_per_title.
  ///
  /// In en, this message translates to:
  /// **'Mean per Title'**
  String get mean_per_title;

  /// No description provided for @completion_rate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completion_rate;

  /// No description provided for @watching_time.
  ///
  /// In en, this message translates to:
  /// **'Watch Time'**
  String get watching_time;

  /// No description provided for @reading_time.
  ///
  /// In en, this message translates to:
  /// **'Reading Time'**
  String get reading_time;

  /// No description provided for @average_chapters_per_title.
  ///
  /// In en, this message translates to:
  /// **'Average Chapters per {title}'**
  String average_chapters_per_title(Object title);

  /// No description provided for @read_percentage.
  ///
  /// In en, this message translates to:
  /// **'Read Percentage'**
  String get read_percentage;

  /// No description provided for @entries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get entries;

  /// No description provided for @android_proxy_server_mihon.
  ///
  /// In en, this message translates to:
  /// **'Android Proxy Server (Mihon)'**
  String get android_proxy_server_mihon;

  /// No description provided for @android_proxy_server_mihon_description.
  ///
  /// In en, this message translates to:
  /// **'Download and configure the proxy server required to use Mihon extensions.'**
  String get android_proxy_server_mihon_description;

  /// No description provided for @mihon_proxy_server.
  ///
  /// In en, this message translates to:
  /// **'Mihon proxy server'**
  String get mihon_proxy_server;

  /// No description provided for @extension_server_intro_with_jre.
  ///
  /// In en, this message translates to:
  /// **'Download the proxy server bundle before using Mihon extensions. The bundle includes the JRE and extension server JAR.'**
  String get extension_server_intro_with_jre;

  /// No description provided for @extension_server_intro_ios.
  ///
  /// In en, this message translates to:
  /// **'Download the proxy server JAR before using Mihon extensions. iOS only needs the extension server JAR.'**
  String get extension_server_intro_ios;

  /// No description provided for @checking_files.
  ///
  /// In en, this message translates to:
  /// **'Checking files'**
  String get checking_files;

  /// No description provided for @files_installed.
  ///
  /// In en, this message translates to:
  /// **'Files installed'**
  String get files_installed;

  /// No description provided for @files_missing.
  ///
  /// In en, this message translates to:
  /// **'Files missing'**
  String get files_missing;

  /// No description provided for @update_files.
  ///
  /// In en, this message translates to:
  /// **'Update files'**
  String get update_files;

  /// No description provided for @up_to_date.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get up_to_date;

  /// No description provided for @choose_location.
  ///
  /// In en, this message translates to:
  /// **'Choose location'**
  String get choose_location;

  /// No description provided for @import_existing_jar.
  ///
  /// In en, this message translates to:
  /// **'Import existing JAR'**
  String get import_existing_jar;

  /// No description provided for @detect_files_in_selected_folder.
  ///
  /// In en, this message translates to:
  /// **'Detect files in selected folder'**
  String get detect_files_in_selected_folder;

  /// No description provided for @preparing_download.
  ///
  /// In en, this message translates to:
  /// **'Preparing download...'**
  String get preparing_download;

  /// No description provided for @app_install_location.
  ///
  /// In en, this message translates to:
  /// **'App install location'**
  String get app_install_location;

  /// No description provided for @install_location.
  ///
  /// In en, this message translates to:
  /// **'Install location'**
  String get install_location;

  /// No description provided for @jre_executable.
  ///
  /// In en, this message translates to:
  /// **'JRE executable'**
  String get jre_executable;

  /// No description provided for @extension_server_jar.
  ///
  /// In en, this message translates to:
  /// **'Extension server JAR'**
  String get extension_server_jar;

  /// No description provided for @installed_version.
  ///
  /// In en, this message translates to:
  /// **'Installed version'**
  String get installed_version;

  /// No description provided for @latest_version.
  ///
  /// In en, this message translates to:
  /// **'Latest version'**
  String get latest_version;

  /// No description provided for @m_extension_server_description.
  ///
  /// In en, this message translates to:
  /// **'Use M-Extension-Server when you need a separate Android device proxy. Set the proxy address here and download the APK from GitHub.'**
  String get m_extension_server_description;

  /// No description provided for @set_proxy_address.
  ///
  /// In en, this message translates to:
  /// **'Set proxy address'**
  String get set_proxy_address;

  /// No description provided for @no_newer_proxy_server_release_available.
  ///
  /// In en, this message translates to:
  /// **'No newer proxy server release is available.'**
  String get no_newer_proxy_server_release_available;

  /// No description provided for @could_not_check_proxy_server_updates.
  ///
  /// In en, this message translates to:
  /// **'Could not check for proxy server updates.'**
  String get could_not_check_proxy_server_updates;

  /// No description provided for @no_extension_server_bundle_available_for_this_platform.
  ///
  /// In en, this message translates to:
  /// **'No extension server bundle is available for this platform.'**
  String get no_extension_server_bundle_available_for_this_platform;

  /// No description provided for @failed_to_download_bundle.
  ///
  /// In en, this message translates to:
  /// **'Failed to download bundle ({statusCode}).'**
  String failed_to_download_bundle(Object statusCode);

  /// No description provided for @downloaded_bundle_missing_expected_files.
  ///
  /// In en, this message translates to:
  /// **'The downloaded bundle does not contain the expected files.'**
  String get downloaded_bundle_missing_expected_files;

  /// No description provided for @extension_server_files_ready.
  ///
  /// In en, this message translates to:
  /// **'Extension server files are ready.'**
  String get extension_server_files_ready;

  /// No description provided for @ios_extension_server_import_hint.
  ///
  /// In en, this message translates to:
  /// **'On iOS the server is installed inside the app sandbox. Use \"Import existing JAR\" to bring in a downloaded file.'**
  String get ios_extension_server_import_hint;

  /// No description provided for @select_extension_server_folder.
  ///
  /// In en, this message translates to:
  /// **'Select extension server folder'**
  String get select_extension_server_folder;

  /// No description provided for @selected_folder_does_not_exist.
  ///
  /// In en, this message translates to:
  /// **'The selected folder does not exist.'**
  String get selected_folder_does_not_exist;

  /// No description provided for @no_extension_server_files_found_in_selected_folder.
  ///
  /// In en, this message translates to:
  /// **'No extension server files were found in the selected folder.'**
  String get no_extension_server_files_found_in_selected_folder;

  /// No description provided for @extension_server_files_linked.
  ///
  /// In en, this message translates to:
  /// **'Extension server files were linked.'**
  String get extension_server_files_linked;

  /// No description provided for @select_extension_server_jar.
  ///
  /// In en, this message translates to:
  /// **'Select extension server JAR'**
  String get select_extension_server_jar;

  /// No description provided for @selected_file_could_not_be_accessed.
  ///
  /// In en, this message translates to:
  /// **'The selected file could not be accessed.'**
  String get selected_file_could_not_be_accessed;

  /// No description provided for @extension_server_jar_imported.
  ///
  /// In en, this message translates to:
  /// **'Extension server JAR was imported.'**
  String get extension_server_jar_imported;

  /// No description provided for @could_not_launch_apk_bridge_page.
  ///
  /// In en, this message translates to:
  /// **'Could not launch the M-Extension-Server page.'**
  String get could_not_launch_apk_bridge_page;

  /// No description provided for @proxy_server_ip_hint.
  ///
  /// In en, this message translates to:
  /// **'Server IP (e.g., 10.0.0.5 or https://example.com)'**
  String get proxy_server_ip_hint;

  /// No description provided for @not_configured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get not_configured;

  /// No description provided for @zero_interpreter.
  ///
  /// In en, this message translates to:
  /// **'Zero interpreter'**
  String get zero_interpreter;

  /// No description provided for @zero_interpreter_description.
  ///
  /// In en, this message translates to:
  /// **'Control the Zero interpreter server automatically or manually.'**
  String get zero_interpreter_description;

  /// No description provided for @start_server_on_launch.
  ///
  /// In en, this message translates to:
  /// **'Start server on launch'**
  String get start_server_on_launch;

  /// No description provided for @runtime_status.
  ///
  /// In en, this message translates to:
  /// **'Runtime status'**
  String get runtime_status;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// No description provided for @stopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stopped;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @webview.
  ///
  /// In en, this message translates to:
  /// **'Webview'**
  String get webview;

  /// No description provided for @tts.
  ///
  /// In en, this message translates to:
  /// **'Text-to-Speech'**
  String get tts;

  /// No description provided for @tts_speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get tts_speed;

  /// No description provided for @tts_pitch.
  ///
  /// In en, this message translates to:
  /// **'Pitch'**
  String get tts_pitch;

  /// No description provided for @tts_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get tts_language;

  /// No description provided for @tts_voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get tts_voice;

  /// No description provided for @tts_stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get tts_stop;

  /// No description provided for @tts_play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get tts_play;

  /// No description provided for @tts_pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get tts_pause;

  /// No description provided for @tts_previous.
  ///
  /// In en, this message translates to:
  /// **'Previous paragraph'**
  String get tts_previous;

  /// No description provided for @tts_next.
  ///
  /// In en, this message translates to:
  /// **'Next paragraph'**
  String get tts_next;

  /// No description provided for @tts_paragraph_progress.
  ///
  /// In en, this message translates to:
  /// **'Paragraph {current} of {total}'**
  String tts_paragraph_progress(Object current, Object total);

  /// No description provided for @tts_settings.
  ///
  /// In en, this message translates to:
  /// **'TTS Settings'**
  String get tts_settings;

  /// No description provided for @tts_default.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get tts_default;

  /// No description provided for @webtoon_disable_zoom_out.
  ///
  /// In en, this message translates to:
  /// **'Webtoon disable zoom out'**
  String get webtoon_disable_zoom_out;

  /// No description provided for @webtoon_double_tap_zoom_enabled.
  ///
  /// In en, this message translates to:
  /// **'Webtoon double tap zoom'**
  String get webtoon_double_tap_zoom_enabled;

  /// No description provided for @navigate_to_pan.
  ///
  /// In en, this message translates to:
  /// **'Navigate to pan'**
  String get navigate_to_pan;

  /// No description provided for @navigate_to_pan_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Move zoomed image before turning page'**
  String get navigate_to_pan_subtitle;

  /// No description provided for @split_wide_pages.
  ///
  /// In en, this message translates to:
  /// **'Split wide pages'**
  String get split_wide_pages;

  /// No description provided for @dual_page_invert.
  ///
  /// In en, this message translates to:
  /// **'Invert cut half pages'**
  String get dual_page_invert;

  /// No description provided for @dual_page_rotate_to_fit.
  ///
  /// In en, this message translates to:
  /// **'Rotate to fit'**
  String get dual_page_rotate_to_fit;

  /// No description provided for @dual_page_rotate_to_fit_invert.
  ///
  /// In en, this message translates to:
  /// **'Invert rotation direction'**
  String get dual_page_rotate_to_fit_invert;

  /// No description provided for @double_page_single_first_page.
  ///
  /// In en, this message translates to:
  /// **'Single first page'**
  String get double_page_single_first_page;

  /// No description provided for @double_page_single_first_page_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Display the first page alone in double page mode'**
  String get double_page_single_first_page_subtitle;

  /// No description provided for @double_page_auto.
  ///
  /// In en, this message translates to:
  /// **'Automatic double page'**
  String get double_page_auto;

  /// No description provided for @double_page_auto_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch to double page mode automatically in landscape'**
  String get double_page_auto_subtitle;

  /// No description provided for @landscape_zoom.
  ///
  /// In en, this message translates to:
  /// **'Automatic landscape zoom'**
  String get landscape_zoom;

  /// No description provided for @zoom_start_position.
  ///
  /// In en, this message translates to:
  /// **'Zoom start position'**
  String get zoom_start_position;

  /// No description provided for @zoom_start_left.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get zoom_start_left;

  /// No description provided for @zoom_start_right.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get zoom_start_right;

  /// No description provided for @zoom_start_center.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get zoom_start_center;

  /// No description provided for @automatic_background.
  ///
  /// In en, this message translates to:
  /// **'Automatic background'**
  String get automatic_background;

  /// No description provided for @tapping_inversion.
  ///
  /// In en, this message translates to:
  /// **'Tapping Inversion'**
  String get tapping_inversion;

  /// No description provided for @tapping_inversion_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get tapping_inversion_none;

  /// No description provided for @tapping_inversion_horizontal.
  ///
  /// In en, this message translates to:
  /// **'Horizontal'**
  String get tapping_inversion_horizontal;

  /// No description provided for @tapping_inversion_vertical.
  ///
  /// In en, this message translates to:
  /// **'Vertical'**
  String get tapping_inversion_vertical;

  /// No description provided for @tapping_inversion_both.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get tapping_inversion_both;

  /// No description provided for @flash_on_page_change.
  ///
  /// In en, this message translates to:
  /// **'Flash on page change'**
  String get flash_on_page_change;

  /// No description provided for @flash_on_page_change_subtitle.
  ///
  /// In en, this message translates to:
  /// **'AMOLED anti-retention helper'**
  String get flash_on_page_change_subtitle;

  /// No description provided for @flash_color.
  ///
  /// In en, this message translates to:
  /// **'Flash Color'**
  String get flash_color;

  /// No description provided for @flash_color_black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get flash_color_black;

  /// No description provided for @flash_color_white.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get flash_color_white;

  /// No description provided for @flash_color_white_black.
  ///
  /// In en, this message translates to:
  /// **'White & Black'**
  String get flash_color_white_black;

  /// No description provided for @flash_interval.
  ///
  /// In en, this message translates to:
  /// **'Flash Interval: {n} pages'**
  String flash_interval(String n);

  /// No description provided for @flash_duration.
  ///
  /// In en, this message translates to:
  /// **'Flash Duration: {n} ms'**
  String flash_duration(String n);

  /// No description provided for @show_navigation_overlay_on_start.
  ///
  /// In en, this message translates to:
  /// **'Show Navigation Overlay on startup'**
  String get show_navigation_overlay_on_start;

  /// No description provided for @reader_hide_threshold.
  ///
  /// In en, this message translates to:
  /// **'Reader Hide Threshold'**
  String get reader_hide_threshold;

  /// No description provided for @reader_hide_threshold_highest.
  ///
  /// In en, this message translates to:
  /// **'Highest (5 px)'**
  String get reader_hide_threshold_highest;

  /// No description provided for @reader_hide_threshold_high.
  ///
  /// In en, this message translates to:
  /// **'High (13 px)'**
  String get reader_hide_threshold_high;

  /// No description provided for @reader_hide_threshold_low.
  ///
  /// In en, this message translates to:
  /// **'Low (31 px)'**
  String get reader_hide_threshold_low;

  /// No description provided for @reader_hide_threshold_lowest.
  ///
  /// In en, this message translates to:
  /// **'Lowest (47 px)'**
  String get reader_hide_threshold_lowest;

  /// No description provided for @error_no_pages_available.
  ///
  /// In en, this message translates to:
  /// **'Error: no pages available'**
  String get error_no_pages_available;

  /// No description provided for @app_ui_scale.
  ///
  /// In en, this message translates to:
  /// **'Interface scale'**
  String get app_ui_scale;

  /// No description provided for @app_ui_scale_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Make the interface larger or smaller to suit your screen and viewing distance.'**
  String get app_ui_scale_subtitle;

  /// No description provided for @allow_concurrent_downloads.
  ///
  /// In en, this message translates to:
  /// **'Allow concurrent downloads'**
  String get allow_concurrent_downloads;

  /// No description provided for @allow_concurrent_downloads_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Download from different sources at the same time. A single source still downloads one chapter at a time so it isn\'t overloaded. Turn off to download one at a time everywhere.'**
  String get allow_concurrent_downloads_subtitle;

  /// No description provided for @download_delay.
  ///
  /// In en, this message translates to:
  /// **'Download delay'**
  String get download_delay;

  /// No description provided for @download_delay_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Off. Add a wait with random jitter between chapters to be gentler on sources.'**
  String get download_delay_subtitle;

  /// No description provided for @save_search.
  ///
  /// In en, this message translates to:
  /// **'Save search'**
  String get save_search;

  /// No description provided for @saved_searches.
  ///
  /// In en, this message translates to:
  /// **'Saved searches'**
  String get saved_searches;

  /// No description provided for @enter_search_to_save_first.
  ///
  /// In en, this message translates to:
  /// **'Enter a search to save first'**
  String get enter_search_to_save_first;

  /// No description provided for @no_saved_searches.
  ///
  /// In en, this message translates to:
  /// **'No saved searches for this source yet.\nRun a search, then pick \"Save search\".'**
  String get no_saved_searches;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @startup_failed.
  ///
  /// In en, this message translates to:
  /// **'NodeLane Comics could not finish starting up'**
  String get startup_failed;

  /// Header of the collapsed group in global search holding every source that failed or found nothing.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 source with no results} other{{count} sources with no results}}'**
  String sources_with_no_results(int count);

  /// No description provided for @import_mode_title.
  ///
  /// In en, this message translates to:
  /// **'How should this be imported?'**
  String get import_mode_title;

  /// No description provided for @import_mode_message.
  ///
  /// In en, this message translates to:
  /// **'Choose whether to merge this backup into your current library, or replace your entire library with it.'**
  String get import_mode_message;

  /// No description provided for @import_mode_keep_existing.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get import_mode_keep_existing;

  /// No description provided for @import_mode_keep_existing_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Adds new series and updates matching ones. Nothing in your current library is removed.'**
  String get import_mode_keep_existing_subtitle;

  /// No description provided for @import_mode_replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get import_mode_replace;

  /// No description provided for @import_mode_replace_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Deletes your entire current library and replaces it with this backup.'**
  String get import_mode_replace_subtitle;

  /// No description provided for @replace_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Ready to replace your library'**
  String get replace_summary_title;

  /// No description provided for @replace_summary_message.
  ///
  /// In en, this message translates to:
  /// **'This deletes your entire current library ({currentCount} series) and replaces it with {backupCount} series from this backup. This can only be undone by rolling back.'**
  String replace_summary_message(Object currentCount, Object backupCount);

  /// No description provided for @replace_summary_confirm.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace_summary_confirm;

  /// No description provided for @replace_result_message.
  ///
  /// In en, this message translates to:
  /// **'Replaced your library with {count} series from this backup.'**
  String replace_result_message(Object count);

  /// No description provided for @category_conflict_title.
  ///
  /// In en, this message translates to:
  /// **'Existing categories found'**
  String get category_conflict_title;

  /// No description provided for @category_conflict_message.
  ///
  /// In en, this message translates to:
  /// **'The backup has categories that already exist in your library. Keep to fold incoming series into the existing category, or delete to leave those series uncategorized instead.'**
  String get category_conflict_message;

  /// No description provided for @category_conflict_keep.
  ///
  /// In en, this message translates to:
  /// **'Keep — merge into existing category'**
  String get category_conflict_keep;

  /// No description provided for @category_conflict_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete — leave series uncategorized'**
  String get category_conflict_delete;

  /// No description provided for @source_conflict_title.
  ///
  /// In en, this message translates to:
  /// **'Sources not found'**
  String get source_conflict_title;

  /// No description provided for @source_conflict_message.
  ///
  /// In en, this message translates to:
  /// **'These backup sources don\'t match an installed extension. Keep the original name (imported without a working source), or migrate to an installed extension so these series can be updated.'**
  String get source_conflict_message;

  /// No description provided for @source_conflict_keep.
  ///
  /// In en, this message translates to:
  /// **'Keep original name (no live source)'**
  String get source_conflict_keep;

  /// No description provided for @import_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Ready to import'**
  String get import_summary_title;

  /// No description provided for @import_summary_message.
  ///
  /// In en, this message translates to:
  /// **'{newSeries} new series, {updatedSeries} existing series will be updated, and {newChapters} new chapters will be added. Nothing already in your library will be removed.'**
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  );

  /// No description provided for @import_summary_confirm.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import_summary_confirm;

  /// No description provided for @import_result_message.
  ///
  /// In en, this message translates to:
  /// **'Imported {newSeries} new series, updated {updatedSeries} existing, added {newChapters} new chapters.'**
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  );

  /// No description provided for @roll_back.
  ///
  /// In en, this message translates to:
  /// **'Roll back'**
  String get roll_back;

  /// No description provided for @roll_back_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'This restores your library to the safety snapshot taken right before this change, undoing everything it just did.'**
  String get roll_back_confirm_message;

  /// No description provided for @roll_back_done.
  ///
  /// In en, this message translates to:
  /// **'Rolled back to the pre-change snapshot.'**
  String get roll_back_done;

  /// No description provided for @restoring_backup.
  ///
  /// In en, this message translates to:
  /// **'Restoring your library…'**
  String get restoring_backup;

  /// No description provided for @roll_back_last_change.
  ///
  /// In en, this message translates to:
  /// **'Roll back last change'**
  String get roll_back_last_change;

  /// No description provided for @roll_back_last_change_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Snapshot from {date} — {description}'**
  String roll_back_last_change_subtitle(Object date, Object description);

  /// No description provided for @roll_back_available_count.
  ///
  /// In en, this message translates to:
  /// **'{count} recent changes available to roll back to'**
  String roll_back_available_count(Object count);

  /// No description provided for @delete_source_title.
  ///
  /// In en, this message translates to:
  /// **'Delete a source & its manga'**
  String get delete_source_title;

  /// No description provided for @delete_source_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a source and remove every manga it has in your library, along with their chapters, downloads, history and tracking.'**
  String get delete_source_subtitle;

  /// No description provided for @delete_source_pick_title.
  ///
  /// In en, this message translates to:
  /// **'Pick a source to delete'**
  String get delete_source_pick_title;

  /// No description provided for @delete_source_empty.
  ///
  /// In en, this message translates to:
  /// **'No sources found in your library.'**
  String get delete_source_empty;

  /// No description provided for @delete_source_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Delete {sourceName}?'**
  String delete_source_confirm_title(Object sourceName);

  /// No description provided for @delete_source_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes {mangaCount} manga, {chapterCount} chapters, {historyCount} history entries and {updateCount} update entries. Tracking links are kept. This cannot be undone except by rolling back.'**
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  );

  /// No description provided for @delete_source_also_remove_extension.
  ///
  /// In en, this message translates to:
  /// **'Also remove the installed extension'**
  String get delete_source_also_remove_extension;

  /// No description provided for @delete_source_keep_history.
  ///
  /// In en, this message translates to:
  /// **'Keep reading history'**
  String get delete_source_keep_history;

  /// No description provided for @delete_source_keep_downloads.
  ///
  /// In en, this message translates to:
  /// **'Keep download records'**
  String get delete_source_keep_downloads;

  /// No description provided for @delete_source_button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_source_button;

  /// No description provided for @delete_source_result_message.
  ///
  /// In en, this message translates to:
  /// **'Deleted {mangaCount} manga from {sourceName}.'**
  String delete_source_result_message(Object mangaCount, Object sourceName);

  /// No description provided for @merge_manga_title.
  ///
  /// In en, this message translates to:
  /// **'Merge duplicate manga'**
  String get merge_manga_title;

  /// No description provided for @merge_manga_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Finds manga with matching titles under the same source (e.g. after merging duplicate sources) and folds them into one, without deleting anything you\'d want kept.'**
  String get merge_manga_subtitle;

  /// No description provided for @merge_manga_none_found.
  ///
  /// In en, this message translates to:
  /// **'No likely duplicate manga found.'**
  String get merge_manga_none_found;

  /// No description provided for @merge_manga_pick_title.
  ///
  /// In en, this message translates to:
  /// **'Possible duplicate manga'**
  String get merge_manga_pick_title;

  /// No description provided for @merge_manga_choose_primary_title.
  ///
  /// In en, this message translates to:
  /// **'Which one should the others merge into?'**
  String get merge_manga_choose_primary_title;

  /// No description provided for @merge_manga_choose_primary_message.
  ///
  /// In en, this message translates to:
  /// **'Chapters, history and tracking from the other entries will be folded into whichever one you pick — nothing is deleted.'**
  String get merge_manga_choose_primary_message;

  /// No description provided for @merge_manga_chapters_subtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 chapter} other{{count} chapters}}'**
  String merge_manga_chapters_subtitle(int count);

  /// No description provided for @merge_manga_button.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get merge_manga_button;

  /// No description provided for @merge_manga_result_message.
  ///
  /// In en, this message translates to:
  /// **'Merged {count} duplicate manga into {mangaName}.'**
  String merge_manga_result_message(Object count, Object mangaName);

  /// No description provided for @merge_preview_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm merge'**
  String get merge_preview_title;

  /// No description provided for @merge_manga_preview_message.
  ///
  /// In en, this message translates to:
  /// **'{totalChapters} chapters found across the other entries. {duplicateChapters} are duplicates and will be dropped (keeping whichever copy has reading progress); {keptChapters} will be added. {duplicateTracks} duplicate tracking link(s) will also be dropped.'**
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  );

  /// No description provided for @memory_overlay.
  ///
  /// In en, this message translates to:
  /// **'Show memory usage'**
  String get memory_overlay;

  /// No description provided for @memory_overlay_subtitle.
  ///
  /// In en, this message translates to:
  /// **'A live readout of what the app is holding. For measuring on the device rather than guessing: watch it while scrolling the library or reading a chapter.'**
  String get memory_overlay_subtitle;

  /// No description provided for @beta.
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get beta;

  /// No description provided for @error_reports.
  ///
  /// In en, this message translates to:
  /// **'Error reports'**
  String get error_reports;

  /// No description provided for @error_reports_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Errors the app caught, and a way to report them'**
  String get error_reports_subtitle;

  /// No description provided for @error_reports_empty.
  ///
  /// In en, this message translates to:
  /// **'Nothing has gone wrong. Errors the app catches are kept here so you can report them.'**
  String get error_reports_empty;

  /// No description provided for @error_reports_likely_cause.
  ///
  /// In en, this message translates to:
  /// **'Likely cause'**
  String get error_reports_likely_cause;

  /// No description provided for @error_reports_report.
  ///
  /// In en, this message translates to:
  /// **'Report on GitHub'**
  String get error_reports_report;

  /// No description provided for @error_reports_banner.
  ///
  /// In en, this message translates to:
  /// **'NodeLane Comics ran into an error'**
  String get error_reports_banner;

  /// No description provided for @error_reports_banner_action.
  ///
  /// In en, this message translates to:
  /// **'See it'**
  String get error_reports_banner_action;

  /// No description provided for @error_reports_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get error_reports_copy;

  /// No description provided for @error_reports_copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to the clipboard'**
  String get error_reports_copied;

  /// No description provided for @error_reports_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get error_reports_clear;

  /// No description provided for @error_reports_extension_failure.
  ///
  /// In en, this message translates to:
  /// **'This came from an extension, not from NodeLane Comics. Extensions are written and maintained by whoever runs the repository you installed this source from, so a fix has to go there. The source name and what you were opening are the useful details to give them.'**
  String get error_reports_extension_failure;

  /// No description provided for @error_reports_already_reported.
  ///
  /// In en, this message translates to:
  /// **'Already reported'**
  String get error_reports_already_reported;

  /// No description provided for @error_reports_expected_failure.
  ///
  /// In en, this message translates to:
  /// **'This one is usually the source or the network rather than the app: a link that expired, a server that was down, or a connection that dropped. Worth reporting only if it keeps happening on a source that works elsewhere.'**
  String get error_reports_expected_failure;

  /// No description provided for @share_unavailable_copied.
  ///
  /// In en, this message translates to:
  /// **'Sharing isn\'t available on this platform, so it was copied to the clipboard instead.'**
  String get share_unavailable_copied;

  /// No description provided for @onboarding_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to NodeLane Comics'**
  String get onboarding_title;

  /// No description provided for @onboarding_libraries_body.
  ///
  /// In en, this message translates to:
  /// **'Pick what you read and watch. The ones you leave out stay out of the navigation bar, and you can change this later under Appearance.'**
  String get onboarding_libraries_body;

  /// No description provided for @onboarding_nav_title.
  ///
  /// In en, this message translates to:
  /// **'Your libraries'**
  String get onboarding_nav_title;

  /// No description provided for @onboarding_nav_body.
  ///
  /// In en, this message translates to:
  /// **'Keep a tab for each of them, or put them together behind one Library tab you can switch inside.'**
  String get onboarding_nav_body;

  /// No description provided for @onboarding_nav_split.
  ///
  /// In en, this message translates to:
  /// **'A tab each'**
  String get onboarding_nav_split;

  /// No description provided for @onboarding_nav_merged.
  ///
  /// In en, this message translates to:
  /// **'One Library tab'**
  String get onboarding_nav_merged;

  /// No description provided for @onboarding_nav_inside.
  ///
  /// In en, this message translates to:
  /// **'Tapping Library swaps the bar for these'**
  String get onboarding_nav_inside;

  /// No description provided for @onboarding_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// No description provided for @onboarding_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore a backup'**
  String get onboarding_restore;

  /// No description provided for @onboarding_or_local.
  ///
  /// In en, this message translates to:
  /// **'Or use files you already have'**
  String get onboarding_or_local;

  /// No description provided for @onboarding_local_folder.
  ///
  /// In en, this message translates to:
  /// **'Add a folder'**
  String get onboarding_local_folder;

  /// No description provided for @onboarding_local_existing.
  ///
  /// In en, this message translates to:
  /// **'{count} folders already set up'**
  String onboarding_local_existing(Object count);

  /// No description provided for @onboarding_local_any_type.
  ///
  /// In en, this message translates to:
  /// **'Manga, anime and novels all work. Each title goes to the right library based on what is inside it.'**
  String get onboarding_local_any_type;

  /// No description provided for @onboarding_local_scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning the folder'**
  String get onboarding_local_scanning;

  /// No description provided for @onboarding_local_found.
  ///
  /// In en, this message translates to:
  /// **'{count} titles found'**
  String onboarding_local_found(Object count);

  /// No description provided for @onboarding_local_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove that folder'**
  String get onboarding_local_remove;

  /// No description provided for @onboarding_local_in_downloads.
  ///
  /// In en, this message translates to:
  /// **'That is the app\'s downloads folder. Adding it makes a second, local copy of a library the app already manages.'**
  String get onboarding_local_in_downloads;

  /// No description provided for @onboarding_local_empty.
  ///
  /// In en, this message translates to:
  /// **'Nothing found. Pick the folder that holds your manga folders, not one manga.'**
  String get onboarding_local_empty;

  /// No description provided for @onboarding_repo_failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read that repository. Check the address and your connection.'**
  String get onboarding_repo_failed;

  /// No description provided for @onboarding_repo_title.
  ///
  /// In en, this message translates to:
  /// **'Add a source'**
  String get onboarding_repo_title;

  /// No description provided for @onboarding_body.
  ///
  /// In en, this message translates to:
  /// **'NodeLane Comics comes with no sources of its own. Add a repository and the extensions it holds become available to install and browse.'**
  String get onboarding_body;

  /// No description provided for @onboarding_add.
  ///
  /// In en, this message translates to:
  /// **'Add repository'**
  String get onboarding_add;

  /// No description provided for @onboarding_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboarding_skip;

  /// No description provided for @onboarding_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboarding_continue;

  /// No description provided for @onboarding_later.
  ///
  /// In en, this message translates to:
  /// **'You can add one later in Settings, under Browse.'**
  String get onboarding_later;

  /// No description provided for @onboarding_replay.
  ///
  /// In en, this message translates to:
  /// **'Show the welcome screen'**
  String get onboarding_replay;

  /// No description provided for @onboarding_replay_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Opens the first-run screen again, the one a new install starts on.'**
  String get onboarding_replay_subtitle;

  /// No description provided for @missing_source_check_title.
  ///
  /// In en, this message translates to:
  /// **'Check for missing sources'**
  String get missing_source_check_title;

  /// No description provided for @missing_source_check_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Find library entries whose extension isn\'t installed - restoring a backup can leave entries pointing at a source you never installed on this device.'**
  String get missing_source_check_subtitle;

  /// No description provided for @missing_source_check_none_found.
  ///
  /// In en, this message translates to:
  /// **'Every library entry\'s source is installed.'**
  String get missing_source_check_none_found;

  /// No description provided for @missing_source_check_result_title.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 source missing} other{{count} sources missing}}'**
  String missing_source_check_result_title(int count);

  /// No description provided for @global_search_no_sources.
  ///
  /// In en, this message translates to:
  /// **'No {itemType} sources are installed.'**
  String global_search_no_sources(String itemType);

  /// No description provided for @global_search_no_sources_hint.
  ///
  /// In en, this message translates to:
  /// **'Add a repository under Browse, then install an extension for it.'**
  String get global_search_no_sources_hint;

  /// No description provided for @global_search_only_pinned.
  ///
  /// In en, this message translates to:
  /// **'You have {count, plural, =1{1 source} other{{count} sources}} for this, but only pinned ones are searched.'**
  String global_search_only_pinned(int count);

  /// No description provided for @global_search_only_pinned_hint.
  ///
  /// In en, this message translates to:
  /// **'Pin one, or turn off \"Only include pinned sources\" in Browse settings.'**
  String get global_search_only_pinned_hint;

  /// No description provided for @global_search_all_nsfw.
  ///
  /// In en, this message translates to:
  /// **'Every source you have for this is marked NSFW, and those are hidden.'**
  String get global_search_all_nsfw;

  /// No description provided for @global_search_all_nsfw_hint.
  ///
  /// In en, this message translates to:
  /// **'Turn on NSFW sources in Browse settings to search them.'**
  String get global_search_all_nsfw_hint;

  /// No description provided for @missing_source_check_result_message.
  ///
  /// In en, this message translates to:
  /// **'These library entries point at a source that isn\'t installed on this device. Tap one to migrate it to an installed source, install the matching extension, or use \"Delete a source & its manga\" to remove them.'**
  String get missing_source_check_result_message;

  /// No description provided for @related_titles.
  ///
  /// In en, this message translates to:
  /// **'Related'**
  String get related_titles;

  /// No description provided for @related_none.
  ///
  /// In en, this message translates to:
  /// **'Nothing related was found for this title.'**
  String get related_none;

  /// No description provided for @relation_adaptation.
  ///
  /// In en, this message translates to:
  /// **'Adaptation'**
  String get relation_adaptation;

  /// No description provided for @relation_sequel.
  ///
  /// In en, this message translates to:
  /// **'Sequel'**
  String get relation_sequel;

  /// No description provided for @relation_prequel.
  ///
  /// In en, this message translates to:
  /// **'Prequel'**
  String get relation_prequel;

  /// No description provided for @relation_parent.
  ///
  /// In en, this message translates to:
  /// **'Parent story'**
  String get relation_parent;

  /// No description provided for @relation_side_story.
  ///
  /// In en, this message translates to:
  /// **'Side story'**
  String get relation_side_story;

  /// No description provided for @relation_spin_off.
  ///
  /// In en, this message translates to:
  /// **'Spin-off'**
  String get relation_spin_off;

  /// No description provided for @relation_alternative.
  ///
  /// In en, this message translates to:
  /// **'Alternative version'**
  String get relation_alternative;

  /// No description provided for @auto_library_update.
  ///
  /// In en, this message translates to:
  /// **'Automatic library updates'**
  String get auto_library_update;

  /// No description provided for @auto_library_update_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Check every entry in your library for new chapters when the app starts.'**
  String get auto_library_update_subtitle;

  /// No description provided for @auto_library_update_never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get auto_library_update_never;

  /// No description provided for @auto_library_update_12_hours.
  ///
  /// In en, this message translates to:
  /// **'Every 12 hours'**
  String get auto_library_update_12_hours;

  /// No description provided for @auto_library_update_daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get auto_library_update_daily;

  /// No description provided for @auto_library_update_2_days.
  ///
  /// In en, this message translates to:
  /// **'Every 2 days'**
  String get auto_library_update_2_days;

  /// No description provided for @auto_library_update_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get auto_library_update_weekly;

  /// No description provided for @auto_library_update_wifi_only.
  ///
  /// In en, this message translates to:
  /// **'Only on Wi-Fi'**
  String get auto_library_update_wifi_only;

  /// No description provided for @auto_library_update_wifi_only_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Skip the scheduled update while on mobile data.'**
  String get auto_library_update_wifi_only_subtitle;

  /// No description provided for @padding.
  ///
  /// In en, this message translates to:
  /// **'Padding'**
  String get padding;

  /// No description provided for @page_mode.
  ///
  /// In en, this message translates to:
  /// **'Page mode'**
  String get page_mode;

  /// No description provided for @single_page.
  ///
  /// In en, this message translates to:
  /// **'Single page'**
  String get single_page;

  /// No description provided for @double_page.
  ///
  /// In en, this message translates to:
  /// **'Double page'**
  String get double_page;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;

  /// No description provided for @theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light;

  /// No description provided for @theme_black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get theme_black;

  /// No description provided for @theme_sepia.
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get theme_sepia;

  /// No description provided for @decrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decrease;

  /// No description provided for @increase.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increase;

  /// No description provided for @chapter_swipe_actions.
  ///
  /// In en, this message translates to:
  /// **'Chapter swipe actions'**
  String get chapter_swipe_actions;

  /// No description provided for @chapter_swipe_start.
  ///
  /// In en, this message translates to:
  /// **'Swipe right'**
  String get chapter_swipe_start;

  /// No description provided for @chapter_swipe_end.
  ///
  /// In en, this message translates to:
  /// **'Swipe left'**
  String get chapter_swipe_end;

  /// No description provided for @chapter_swipe_toggle_bookmark.
  ///
  /// In en, this message translates to:
  /// **'Toggle bookmark'**
  String get chapter_swipe_toggle_bookmark;

  /// No description provided for @chapter_swipe_toggle_read.
  ///
  /// In en, this message translates to:
  /// **'Toggle read'**
  String get chapter_swipe_toggle_read;

  /// No description provided for @chapter_swipe_download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get chapter_swipe_download;

  /// No description provided for @chapter_swipe_disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get chapter_swipe_disabled;

  /// No description provided for @update_errors.
  ///
  /// In en, this message translates to:
  /// **'Update errors'**
  String get update_errors;

  /// No description provided for @no_update_errors.
  ///
  /// In en, this message translates to:
  /// **'No update errors'**
  String get no_update_errors;

  /// No description provided for @clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clear_all;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @previous_episode.
  ///
  /// In en, this message translates to:
  /// **'Previous episode'**
  String get previous_episode;

  /// No description provided for @clear_logs.
  ///
  /// In en, this message translates to:
  /// **'Clear logs'**
  String get clear_logs;

  /// No description provided for @bold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get bold;

  /// No description provided for @italic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get italic;

  /// No description provided for @color_yellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get color_yellow;

  /// No description provided for @color_cyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get color_cyan;

  /// No description provided for @color_green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get color_green;

  /// No description provided for @color_orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get color_orange;

  /// No description provided for @continue_watching.
  ///
  /// In en, this message translates to:
  /// **'Continue Watching'**
  String get continue_watching;

  /// No description provided for @search_your_anime.
  ///
  /// In en, this message translates to:
  /// **'Search your anime'**
  String get search_your_anime;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @hidden_categories.
  ///
  /// In en, this message translates to:
  /// **'Hidden categories'**
  String get hidden_categories;

  /// No description provided for @new_category.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get new_category;

  /// No description provided for @local.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get local;

  /// No description provided for @tv_home_rows.
  ///
  /// In en, this message translates to:
  /// **'Rows'**
  String get tv_home_rows;

  /// No description provided for @genre_rows.
  ///
  /// In en, this message translates to:
  /// **'Genre rows'**
  String get genre_rows;

  /// No description provided for @share_backup_file.
  ///
  /// In en, this message translates to:
  /// **'Share NodeLane Comics backup file'**
  String get share_backup_file;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @migrate_source.
  ///
  /// In en, this message translates to:
  /// **'Migrate source'**
  String get migrate_source;

  /// No description provided for @cloudflare_bypass_proxy.
  ///
  /// In en, this message translates to:
  /// **'Cloudflare bypass proxy'**
  String get cloudflare_bypass_proxy;

  /// No description provided for @custom_doh_url.
  ///
  /// In en, this message translates to:
  /// **'Custom DoH URL'**
  String get custom_doh_url;

  /// No description provided for @custom_doh_url_helper.
  ///
  /// In en, this message translates to:
  /// **'Must be an https DoH (JSON) endpoint'**
  String get custom_doh_url_helper;

  /// No description provided for @anime_only_tv_layout.
  ///
  /// In en, this message translates to:
  /// **'Anime-only TV layout'**
  String get anime_only_tv_layout;

  /// No description provided for @anime_only_beta.
  ///
  /// In en, this message translates to:
  /// **'Anime only (beta)'**
  String get anime_only_beta;

  /// No description provided for @tv_home_beta.
  ///
  /// In en, this message translates to:
  /// **'TV home (beta)'**
  String get tv_home_beta;

  /// No description provided for @tv_player_beta.
  ///
  /// In en, this message translates to:
  /// **'TV player (beta)'**
  String get tv_player_beta;

  /// No description provided for @network_settings.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network_settings;

  /// No description provided for @reader_page_layout.
  ///
  /// In en, this message translates to:
  /// **'Page layout'**
  String get reader_page_layout;

  /// No description provided for @reader_continuous_options.
  ///
  /// In en, this message translates to:
  /// **'Continuous reading'**
  String get reader_continuous_options;

  /// No description provided for @reader_default_mode_hint.
  ///
  /// In en, this message translates to:
  /// **'The default reading mode applies to titles without an individual mode set while reading.'**
  String get reader_default_mode_hint;

  /// No description provided for @extension_service.
  ///
  /// In en, this message translates to:
  /// **'Extension service'**
  String get extension_service;

  /// No description provided for @extension_service_description.
  ///
  /// In en, this message translates to:
  /// **'Manage the extension runtime and proxy address.'**
  String get extension_service_description;

  /// No description provided for @proxy_address.
  ///
  /// In en, this message translates to:
  /// **'Proxy address'**
  String get proxy_address;

  /// No description provided for @checking_runtime_status.
  ///
  /// In en, this message translates to:
  /// **'Checking status…'**
  String get checking_runtime_status;

  /// No description provided for @download_delay_value.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s + random delay'**
  String download_delay_value(int seconds);

  /// No description provided for @download_queue_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 chapter} other{{count} chapters}}'**
  String download_queue_count(int count);

  /// No description provided for @download_queue_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'Add downloads from a title’s chapter list.'**
  String get download_queue_empty_hint;

  /// No description provided for @download_queue_order_hint.
  ///
  /// In en, this message translates to:
  /// **'Drag handles to reorder'**
  String get download_queue_order_hint;

  /// No description provided for @download_queue_empty.
  ///
  /// In en, this message translates to:
  /// **'No downloads queued'**
  String get download_queue_empty;

  /// No description provided for @download_queue_actions.
  ///
  /// In en, this message translates to:
  /// **'Download actions'**
  String get download_queue_actions;

  /// No description provided for @download_queue_cancel_chapter.
  ///
  /// In en, this message translates to:
  /// **'Cancel this chapter’s download'**
  String get download_queue_cancel_chapter;

  /// No description provided for @download_queue_cancel_series.
  ///
  /// In en, this message translates to:
  /// **'Cancel all downloads for this title'**
  String get download_queue_cancel_series;

  /// No description provided for @download_queue_start.
  ///
  /// In en, this message translates to:
  /// **'Start downloads'**
  String get download_queue_start;

  /// No description provided for @download_queue_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry downloads'**
  String get download_queue_retry;

  /// No description provided for @download_queue_active.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get download_queue_active;

  /// No description provided for @download_queue_waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting to download'**
  String get download_queue_waiting;

  /// No description provided for @download_queue_failed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get download_queue_failed;

  /// No description provided for @cf_proxy_helper.
  ///
  /// In en, this message translates to:
  /// **'FlareSolverr / Byparr endpoint. Leave empty to disable.'**
  String get cf_proxy_helper;

  /// No description provided for @mobile_navigation_description.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder. Manga, anime and novels share the Library tab. The first visible item opens at launch. Browse and More stay visible; extra tabs appear under More.'**
  String get mobile_navigation_description;

  /// No description provided for @text_align_justify.
  ///
  /// In en, this message translates to:
  /// **'Justify'**
  String get text_align_justify;

  /// No description provided for @novel_session_modes_hint.
  ///
  /// In en, this message translates to:
  /// **'Set reading mode and single or double pages while reading a title.'**
  String get novel_session_modes_hint;

  /// No description provided for @tts_languages_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not load languages from the speech engine.'**
  String get tts_languages_failed;

  /// No description provided for @tts_languages_empty.
  ///
  /// In en, this message translates to:
  /// **'The speech engine returned no languages. Your saved selection is kept.'**
  String get tts_languages_empty;

  /// No description provided for @tts_language_unavailable.
  ///
  /// In en, this message translates to:
  /// **'This saved language is not in the device’s current list.'**
  String get tts_language_unavailable;

  /// No description provided for @tts_apply_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not apply this setting to the speech engine. You can retry.'**
  String get tts_apply_failed;

  /// No description provided for @player_controls.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get player_controls;

  /// No description provided for @audio_channel_auto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get audio_channel_auto;

  /// No description provided for @audio_channel_auto_safe.
  ///
  /// In en, this message translates to:
  /// **'Automatic (safe)'**
  String get audio_channel_auto_safe;

  /// No description provided for @audio_channel_mono.
  ///
  /// In en, this message translates to:
  /// **'Mono'**
  String get audio_channel_mono;

  /// No description provided for @audio_channel_stereo.
  ///
  /// In en, this message translates to:
  /// **'Stereo'**
  String get audio_channel_stereo;

  /// No description provided for @audio_channel_reverse_stereo.
  ///
  /// In en, this message translates to:
  /// **'Reverse stereo'**
  String get audio_channel_reverse_stereo;

  /// No description provided for @mpv_bundled_config_hint.
  ///
  /// In en, this message translates to:
  /// **'Restore the configuration, scripts and shaders included with the app. Files with the same names will be overwritten.'**
  String get mpv_bundled_config_hint;

  /// No description provided for @mpv_restore_bundled.
  ///
  /// In en, this message translates to:
  /// **'Restore bundled configuration'**
  String get mpv_restore_bundled;

  /// No description provided for @mpv_restore_confirm.
  ///
  /// In en, this message translates to:
  /// **'Restore the bundled MPV configuration? Existing configuration, scripts and shaders with the same names will be overwritten. Other files will be kept.'**
  String get mpv_restore_confirm;

  /// No description provided for @player_operation_incomplete.
  ///
  /// In en, this message translates to:
  /// **'The operation could not be completed. Check file access and try again.'**
  String get player_operation_incomplete;

  /// No description provided for @custom_buttons_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'Add a player button with a label and a press action.'**
  String get custom_buttons_empty_hint;

  /// No description provided for @custom_button_primary.
  ///
  /// In en, this message translates to:
  /// **'Default button'**
  String get custom_button_primary;

  /// No description provided for @show_password.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get show_password;

  /// No description provided for @hide_password.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hide_password;

  /// No description provided for @tracking_accounts_empty.
  ///
  /// In en, this message translates to:
  /// **'Connect a service in Tracking settings to manage its entries.'**
  String get tracking_accounts_empty;

  /// No description provided for @tracking_entries_empty.
  ///
  /// In en, this message translates to:
  /// **'No tracked entries for this media type. Add tracking from a title’s detail page.'**
  String get tracking_entries_empty;

  /// No description provided for @change_tracking_match.
  ///
  /// In en, this message translates to:
  /// **'Change matching title'**
  String get change_tracking_match;

  /// No description provided for @remove_tracking.
  ///
  /// In en, this message translates to:
  /// **'Remove tracking'**
  String get remove_tracking;

  /// No description provided for @remove_tracking_confirm.
  ///
  /// In en, this message translates to:
  /// **'Remove the tracking link for “{title}”? The entry in the tracking service will be kept.'**
  String remove_tracking_confirm(String title);

  /// No description provided for @tracking_refresh_required.
  ///
  /// In en, this message translates to:
  /// **'The tracking state could not be confirmed. Refresh before making another change.'**
  String get tracking_refresh_required;

  /// No description provided for @tracking_entry_unlinked.
  ///
  /// In en, this message translates to:
  /// **'This record is not linked to a local title, so it cannot be edited here.'**
  String get tracking_entry_unlinked;

  /// No description provided for @backup_selection_shared.
  ///
  /// In en, this message translates to:
  /// **'Changes to these selections are saved immediately and also apply to automatic backups.'**
  String get backup_selection_shared;

  /// No description provided for @library_snapshot_history.
  ///
  /// In en, this message translates to:
  /// **'Restore a library snapshot'**
  String get library_snapshot_history;

  /// No description provided for @library_snapshot_empty.
  ///
  /// In en, this message translates to:
  /// **'No safety snapshots available.'**
  String get library_snapshot_empty;

  /// No description provided for @library_snapshot_restore_message.
  ///
  /// In en, this message translates to:
  /// **'Current data will be replaced by this snapshot. Changes made since then will be lost. Deleted downloads cannot be restored. Available safety snapshots will be cleared after success.'**
  String get library_snapshot_restore_message;

  /// No description provided for @library_maintenance_working.
  ///
  /// In en, this message translates to:
  /// **'Updating library…'**
  String get library_maintenance_working;

  /// No description provided for @library_safety_snapshot_note.
  ///
  /// In en, this message translates to:
  /// **'A safety snapshot will be saved before this operation. It does not include downloaded files.'**
  String get library_safety_snapshot_note;

  /// No description provided for @library_delete_summary.
  ///
  /// In en, this message translates to:
  /// **'Library entries: {mangaCount}. Chapters: {chapterCount}. History entries: {historyCount}. Updates: {updateCount}.\n\nChoose what to keep below.'**
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  );

  /// No description provided for @library_delete_pick_message.
  ///
  /// In en, this message translates to:
  /// **'Choose a source to review its contents and deletion options.'**
  String get library_delete_pick_message;

  /// No description provided for @mobile_categories_hint.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder. Open a category to rename it or change its visibility and updates.'**
  String get mobile_categories_hint;

  /// No description provided for @mobile_category_visible.
  ///
  /// In en, this message translates to:
  /// **'Show in library'**
  String get mobile_category_visible;

  /// No description provided for @mobile_category_hidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden from library'**
  String get mobile_category_hidden;

  /// No description provided for @mobile_category_updates.
  ///
  /// In en, this message translates to:
  /// **'Include in library updates'**
  String get mobile_category_updates;

  /// No description provided for @statistics_watched.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get statistics_watched;

  /// No description provided for @calendar_month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calendar_month;

  /// No description provided for @calendar_two_weeks.
  ///
  /// In en, this message translates to:
  /// **'2 weeks'**
  String get calendar_two_weeks;

  /// No description provided for @calendar_week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get calendar_week;

  /// No description provided for @calendar_show_all_dates.
  ///
  /// In en, this message translates to:
  /// **'Show all dates'**
  String get calendar_show_all_dates;

  /// No description provided for @update_check_no_result.
  ///
  /// In en, this message translates to:
  /// **'No installable update found. You can try again later.'**
  String get update_check_no_result;

  /// No description provided for @release_notes.
  ///
  /// In en, this message translates to:
  /// **'Release notes'**
  String get release_notes;

  /// No description provided for @no_release_notes.
  ///
  /// In en, this message translates to:
  /// **'No release notes provided.'**
  String get no_release_notes;

  /// No description provided for @downloading_update.
  ///
  /// In en, this message translates to:
  /// **'Downloading update…'**
  String get downloading_update;

  /// No description provided for @preparing_installation.
  ///
  /// In en, this message translates to:
  /// **'Preparing installation…'**
  String get preparing_installation;

  /// No description provided for @onboarding_mobile_libraries_body.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one type of content. Switch types at the top of Library. You can change this later in Settings.'**
  String get onboarding_mobile_libraries_body;

  /// No description provided for @onboarding_content_title.
  ///
  /// In en, this message translates to:
  /// **'Add reading content'**
  String get onboarding_content_title;

  /// No description provided for @onboarding_mobile_sources_body.
  ///
  /// In en, this message translates to:
  /// **'Add an extension repository or a folder of your own files. You can also skip this and add them later.'**
  String get onboarding_mobile_sources_body;

  /// No description provided for @onboarding_step_count.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String onboarding_step_count(int step, int total);

  /// No description provided for @global_search_results_for.
  ///
  /// In en, this message translates to:
  /// **'Results for “{query}”'**
  String global_search_results_for(String query);

  /// No description provided for @global_search_scope.
  ///
  /// In en, this message translates to:
  /// **'{type} · {count, plural, =1{1 source} other{{count} sources}}'**
  String global_search_scope(String type, int count);

  /// No description provided for @migration_search_prompt.
  ///
  /// In en, this message translates to:
  /// **'Search for the destination title.'**
  String get migration_search_prompt;

  /// No description provided for @migration_original_item.
  ///
  /// In en, this message translates to:
  /// **'Current item'**
  String get migration_original_item;

  /// No description provided for @migration_target_item.
  ///
  /// In en, this message translates to:
  /// **'Selected item'**
  String get migration_target_item;

  /// No description provided for @migration_partial_failure.
  ///
  /// In en, this message translates to:
  /// **'The operation did not finish. Some changes may have been saved. Check this item in your library before trying again.'**
  String get migration_partial_failure;

  /// No description provided for @migration_no_categories.
  ///
  /// In en, this message translates to:
  /// **'No categories. You can add this item without a category.'**
  String get migration_no_categories;

  /// No description provided for @mass_migration_select_source.
  ///
  /// In en, this message translates to:
  /// **'Choose the current source'**
  String get mass_migration_select_source;

  /// No description provided for @mass_migration_select_all.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get mass_migration_select_all;

  /// No description provided for @mass_migration_deselect_all.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get mass_migration_deselect_all;

  /// No description provided for @mass_migration_needs_review.
  ///
  /// In en, this message translates to:
  /// **'Review incomplete migrations'**
  String get mass_migration_needs_review;

  /// No description provided for @bookshelf_actions.
  ///
  /// In en, this message translates to:
  /// **'Bookshelf actions'**
  String get bookshelf_actions;

  /// No description provided for @bookshelf_ignore_filters.
  ///
  /// In en, this message translates to:
  /// **'Ignore filters when searching'**
  String get bookshelf_ignore_filters;

  /// No description provided for @bookshelf_ignore_filters_hint.
  ///
  /// In en, this message translates to:
  /// **'Search all works in this category, including those hidden by filters.'**
  String get bookshelf_ignore_filters_hint;

  /// No description provided for @bookshelf_stop_update.
  ///
  /// In en, this message translates to:
  /// **'Stop library update'**
  String get bookshelf_stop_update;

  /// No description provided for @bookshelf_selected_count.
  ///
  /// In en, this message translates to:
  /// **'{count} works selected'**
  String bookshelf_selected_count(int count);

  /// No description provided for @bookshelf_remove_library.
  ///
  /// In en, this message translates to:
  /// **'Remove from bookshelf'**
  String get bookshelf_remove_library;

  /// No description provided for @bookshelf_remove_library_hint.
  ///
  /// In en, this message translates to:
  /// **'Removes favorites. Local imports also lose their library and reading records.'**
  String get bookshelf_remove_library_hint;

  /// No description provided for @bookshelf_remove_downloads.
  ///
  /// In en, this message translates to:
  /// **'Delete downloaded files'**
  String get bookshelf_remove_downloads;

  /// No description provided for @bookshelf_remove_downloads_hint.
  ///
  /// In en, this message translates to:
  /// **'Removes downloaded files while keeping work information.'**
  String get bookshelf_remove_downloads_hint;

  /// No description provided for @bookshelf_remove_local_files_hint.
  ///
  /// In en, this message translates to:
  /// **'Also deletes selected local imported files and removes their library records. These files cannot be recovered here.'**
  String get bookshelf_remove_local_files_hint;

  /// No description provided for @bookshelf_remove_incomplete.
  ///
  /// In en, this message translates to:
  /// **'The operation did not finish. Some works or files may have been processed. Close this dialog and check your bookshelf and downloads before continuing.'**
  String get bookshelf_remove_incomplete;

  /// No description provided for @bookshelf_processing.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get bookshelf_processing;

  /// No description provided for @bookshelf_mark_read.
  ///
  /// In en, this message translates to:
  /// **'Mark read'**
  String get bookshelf_mark_read;

  /// No description provided for @bookshelf_mark_unread.
  ///
  /// In en, this message translates to:
  /// **'Mark unread'**
  String get bookshelf_mark_unread;

  /// No description provided for @bookshelf_select_all.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get bookshelf_select_all;

  /// No description provided for @bookshelf_invert_selection.
  ///
  /// In en, this message translates to:
  /// **'Invert selection'**
  String get bookshelf_invert_selection;

  /// No description provided for @bookshelf_settings.
  ///
  /// In en, this message translates to:
  /// **'Bookshelf settings'**
  String get bookshelf_settings;

  /// No description provided for @bookshelf_settings_live.
  ///
  /// In en, this message translates to:
  /// **'Filter, sort and display changes take effect immediately.'**
  String get bookshelf_settings_live;

  /// No description provided for @bookshelf_filter_any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get bookshelf_filter_any;

  /// No description provided for @bookshelf_filter_include.
  ///
  /// In en, this message translates to:
  /// **'Include'**
  String get bookshelf_filter_include;

  /// No description provided for @bookshelf_filter_exclude.
  ///
  /// In en, this message translates to:
  /// **'Exclude'**
  String get bookshelf_filter_exclude;

  /// No description provided for @bookshelf_all_sources.
  ///
  /// In en, this message translates to:
  /// **'All sources'**
  String get bookshelf_all_sources;

  /// No description provided for @bookshelf_sources_selected.
  ///
  /// In en, this message translates to:
  /// **'{count} sources selected'**
  String bookshelf_sources_selected(int count);

  /// No description provided for @bookshelf_sort_ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get bookshelf_sort_ascending;

  /// No description provided for @bookshelf_sort_descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get bookshelf_sort_descending;

  /// No description provided for @bookshelf_layout.
  ///
  /// In en, this message translates to:
  /// **'Bookshelf layout'**
  String get bookshelf_layout;

  /// No description provided for @bookshelf_sources_hint.
  ///
  /// In en, this message translates to:
  /// **'Select none to show all sources. Changes apply when you tap Filter.'**
  String get bookshelf_sources_hint;

  /// No description provided for @bookshelf_choose_files.
  ///
  /// In en, this message translates to:
  /// **'Choose files'**
  String get bookshelf_choose_files;

  /// No description provided for @bookshelf_import_wait.
  ///
  /// In en, this message translates to:
  /// **'Choose a file in the picker and wait for the import to finish.'**
  String get bookshelf_import_wait;

  /// No description provided for @bookshelf_import_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Import did not finish. Some files may already be in your bookshelf. Close this dialog and check before importing again.'**
  String get bookshelf_import_incomplete;

  /// No description provided for @bookshelf_categories_replace.
  ///
  /// In en, this message translates to:
  /// **'Saving assigns these categories to every selected work, replacing their previous categories.'**
  String get bookshelf_categories_replace;

  /// No description provided for @bookshelf_categories_hint.
  ///
  /// In en, this message translates to:
  /// **'Choose one or more categories, or leave the selection empty to assign none.'**
  String get bookshelf_categories_hint;

  /// No description provided for @bookshelf_categories_hidden.
  ///
  /// In en, this message translates to:
  /// **'Existing hidden categories are kept for this work.'**
  String get bookshelf_categories_hidden;

  /// No description provided for @bookshelf_categories_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Categories could not be saved completely. Close this dialog and check the bookshelf before trying again.'**
  String get bookshelf_categories_incomplete;

  /// No description provided for @bookshelf_categories_none_visible.
  ///
  /// In en, this message translates to:
  /// **'No categories are available here. Open category management to review them.'**
  String get bookshelf_categories_none_visible;

  /// No description provided for @bookshelf_manage_categories.
  ///
  /// In en, this message translates to:
  /// **'Manage categories'**
  String get bookshelf_manage_categories;

  /// No description provided for @manga_actions.
  ///
  /// In en, this message translates to:
  /// **'Comic actions'**
  String get manga_actions;

  /// No description provided for @manga_download_scope.
  ///
  /// In en, this message translates to:
  /// **'Download chapters'**
  String get manga_download_scope;

  /// No description provided for @manga_download_scope_hint.
  ///
  /// In en, this message translates to:
  /// **'Choose chapters within the current filters. Downloaded chapters are skipped.'**
  String get manga_download_scope_hint;

  /// No description provided for @manga_download_scope_empty.
  ///
  /// In en, this message translates to:
  /// **'No chapters match the current filters. Close this menu and adjust the chapter filters.'**
  String get manga_download_scope_empty;

  /// No description provided for @manga_action_incomplete.
  ///
  /// In en, this message translates to:
  /// **'The action did not finish. Check the current state before trying again.'**
  String get manga_action_incomplete;

  /// No description provided for @chapter_settings.
  ///
  /// In en, this message translates to:
  /// **'Chapter settings'**
  String get chapter_settings;

  /// No description provided for @chapter_settings_live.
  ///
  /// In en, this message translates to:
  /// **'Filter and sort changes apply immediately.'**
  String get chapter_settings_live;

  /// No description provided for @chapter_scanlators_all.
  ///
  /// In en, this message translates to:
  /// **'Show all scanlator groups'**
  String get chapter_scanlators_all;

  /// No description provided for @chapter_scanlators_hint.
  ///
  /// In en, this message translates to:
  /// **'Select groups to hide their chapters. Changes apply when you tap Filter.'**
  String get chapter_scanlators_hint;

  /// No description provided for @chapter_scanlators_hidden.
  ///
  /// In en, this message translates to:
  /// **'{count} scanlator groups hidden'**
  String chapter_scanlators_hidden(int count);

  /// No description provided for @chapter_selected_count.
  ///
  /// In en, this message translates to:
  /// **'{count} chapters selected'**
  String chapter_selected_count(int count);

  /// No description provided for @chapter_add_bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get chapter_add_bookmark;

  /// No description provided for @chapter_remove_bookmark.
  ///
  /// In en, this message translates to:
  /// **'Unbookmark'**
  String get chapter_remove_bookmark;

  /// No description provided for @chapter_read_following.
  ///
  /// In en, this message translates to:
  /// **'Read below'**
  String get chapter_read_following;

  /// No description provided for @chapter_delete_records.
  ///
  /// In en, this message translates to:
  /// **'Delete chapter records'**
  String get chapter_delete_records;

  /// No description provided for @chapter_delete_local_hint.
  ///
  /// In en, this message translates to:
  /// **'Removes the selected chapter records and reading progress. Original local archives are kept; downloaded copies are cleaned up.'**
  String get chapter_delete_local_hint;

  /// No description provided for @chapter_delete_last_hint.
  ///
  /// In en, this message translates to:
  /// **'These are all chapters in this comic. Deleting them also removes the comic from your bookshelf.'**
  String get chapter_delete_last_hint;

  /// No description provided for @chapter_action_incomplete.
  ///
  /// In en, this message translates to:
  /// **'The action did not finish. Some changes may already be saved. Close and check the chapters and downloads before continuing.'**
  String get chapter_action_incomplete;

  /// No description provided for @reader_display_scope.
  ///
  /// In en, this message translates to:
  /// **'Reading mode and manual page layout apply to this comic. Choose a change to return to reading.'**
  String get reader_display_scope;

  /// No description provided for @reader_display_single_only.
  ///
  /// In en, this message translates to:
  /// **'Horizontal continuous reading uses single pages.'**
  String get reader_display_single_only;

  /// No description provided for @reader_display_manual_pages.
  ///
  /// In en, this message translates to:
  /// **'Changing page layout turns off automatic double page for all comics.'**
  String get reader_display_manual_pages;

  /// No description provided for @reader_display_crop_scope.
  ///
  /// In en, this message translates to:
  /// **'Applies to all comics.'**
  String get reader_display_crop_scope;

  /// No description provided for @reader_chapter_locate.
  ///
  /// In en, this message translates to:
  /// **'Locate current chapter'**
  String get reader_chapter_locate;

  /// No description provided for @reader_chapter_search.
  ///
  /// In en, this message translates to:
  /// **'Search chapters or scanlators'**
  String get reader_chapter_search;

  /// No description provided for @reader_chapter_scope.
  ///
  /// In en, this message translates to:
  /// **'Uses the chapter filters and sort order from comic details. Bookmarks are saved immediately.'**
  String get reader_chapter_scope;

  /// No description provided for @reader_chapter_current_hidden.
  ///
  /// In en, this message translates to:
  /// **'The chapter you are reading is outside the current filters.'**
  String get reader_chapter_current_hidden;

  /// No description provided for @reader_chapter_current.
  ///
  /// In en, this message translates to:
  /// **'Reading now'**
  String get reader_chapter_current;

  /// No description provided for @reader_chapter_read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get reader_chapter_read;

  /// No description provided for @reader_chapter_bookmark_failed.
  ///
  /// In en, this message translates to:
  /// **'Bookmark save could not be confirmed. Close the list and check its current state.'**
  String get reader_chapter_bookmark_failed;

  /// No description provided for @reader_image_actions.
  ///
  /// In en, this message translates to:
  /// **'Image actions'**
  String get reader_image_actions;

  /// No description provided for @reader_image_original.
  ///
  /// In en, this message translates to:
  /// **'Uses the full original page, without translation, cropping or reader color filters.'**
  String get reader_image_original;

  /// No description provided for @reader_image_save_ios.
  ///
  /// In en, this message translates to:
  /// **'Save to the Pictures folder in the current app storage location.'**
  String get reader_image_save_ios;

  /// No description provided for @reader_image_save_android.
  ///
  /// In en, this message translates to:
  /// **'Save to the device’s Pictures/Mangayomi folder.'**
  String get reader_image_save_android;

  /// No description provided for @reader_image_share.
  ///
  /// In en, this message translates to:
  /// **'Open the system share sheet.'**
  String get reader_image_share;

  /// No description provided for @reader_image_cover.
  ///
  /// In en, this message translates to:
  /// **'Change this comic’s cover after confirmation.'**
  String get reader_image_cover;

  /// No description provided for @reader_image_cover_limit.
  ///
  /// In en, this message translates to:
  /// **'Cover images must be smaller than 5 MB. Saving and sharing remain available.'**
  String get reader_image_cover_limit;

  /// No description provided for @reader_image_action_failed.
  ///
  /// In en, this message translates to:
  /// **'The action could not be confirmed. Close this menu and check the result before trying again.'**
  String get reader_image_action_failed;

  /// No description provided for @reader_settings_book_scope.
  ///
  /// In en, this message translates to:
  /// **'These settings apply only to this comic.'**
  String get reader_settings_book_scope;

  /// No description provided for @reader_settings_global_scope.
  ///
  /// In en, this message translates to:
  /// **'These settings apply to all comics and save immediately.'**
  String get reader_settings_global_scope;

  /// No description provided for @reader_filters.
  ///
  /// In en, this message translates to:
  /// **'Image filters'**
  String get reader_filters;

  /// No description provided for @reader_filter_scope.
  ///
  /// In en, this message translates to:
  /// **'Applies to all comics. Changes the reading display without modifying original images.'**
  String get reader_filter_scope;

  /// No description provided for @reader_auto_scroll_pause.
  ///
  /// In en, this message translates to:
  /// **'Scrolling pauses while settings are open.'**
  String get reader_auto_scroll_pause;

  /// No description provided for @manga_synopsis.
  ///
  /// In en, this message translates to:
  /// **'Synopsis'**
  String get manga_synopsis;

  /// No description provided for @manga_author.
  ///
  /// In en, this message translates to:
  /// **'Author: {author}'**
  String manga_author(String author);

  /// No description provided for @manga_continue_reading.
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get manga_continue_reading;

  /// No description provided for @reader_settings_title.
  ///
  /// In en, this message translates to:
  /// **'Reader settings'**
  String get reader_settings_title;

  /// No description provided for @reader_picker_book_scope.
  ///
  /// In en, this message translates to:
  /// **'Only for this comic'**
  String get reader_picker_book_scope;

  /// No description provided for @reader_picker_global_scope.
  ///
  /// In en, this message translates to:
  /// **'Applies to all comics'**
  String get reader_picker_global_scope;

  /// No description provided for @reader_picker_apply_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap to save and return to the previous level.'**
  String get reader_picker_apply_hint;

  /// No description provided for @reader_scale_fit_screen_hint.
  ///
  /// In en, this message translates to:
  /// **'Fit the whole page on screen'**
  String get reader_scale_fit_screen_hint;

  /// No description provided for @reader_scale_stretch_hint.
  ///
  /// In en, this message translates to:
  /// **'Fill the reading area'**
  String get reader_scale_stretch_hint;

  /// No description provided for @reader_scale_fit_width_hint.
  ///
  /// In en, this message translates to:
  /// **'Fit the page to the width'**
  String get reader_scale_fit_width_hint;

  /// No description provided for @reader_scale_fit_height_hint.
  ///
  /// In en, this message translates to:
  /// **'Fit the page to the height'**
  String get reader_scale_fit_height_hint;

  /// No description provided for @source_filter_active.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get source_filter_active;

  /// No description provided for @source_filter_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get source_filter_apply;

  /// No description provided for @source_filter_scope.
  ///
  /// In en, this message translates to:
  /// **'Filters apply to this website only.'**
  String get source_filter_scope;

  /// No description provided for @source_filter_apply_hint.
  ///
  /// In en, this message translates to:
  /// **'Apply filters to use your selections.'**
  String get source_filter_apply_hint;

  /// Common extension filter display labels. Plugin values are never translated.
  ///
  /// In en, this message translates to:
  /// **'{term, select, genres{Genres} author{Author} artist{Artist} title{Title} year{Year} tags{Tags} format{Format} publisher{Publisher} relevance{Relevance} rating{Rating} views{Views} random{Random} all{All} none{None} action{Action} adventure{Adventure} comedy{Comedy} drama{Drama} fantasy{Fantasy} romance{Romance} science_fiction{Science fiction} slice_of_life{Slice of life} mystery{Mystery} horror{Horror} psychological{Psychological} historical{Historical} sports{Sports} supernatural{Supernatural} school_life{School life} tragedy{Tragedy} shounen{Shounen} shoujo{Shoujo} seinen{Seinen} josei{Josei} isekai{Isekai} martial_arts{Martial arts} mecha{Mecha} music{Music} doujinshi{Doujinshi} trending{Trending} new{New} adult_content{Adult content} only{Only} other{{term}}}'**
  String source_filter_term(String term);

  /// No description provided for @bookshelf_more_display.
  ///
  /// In en, this message translates to:
  /// **'More display options'**
  String get bookshelf_more_display;

  /// No description provided for @bookshelf_more_display_hint.
  ///
  /// In en, this message translates to:
  /// **'Badges, sources and categories'**
  String get bookshelf_more_display_hint;

  /// No description provided for @bookshelf_download_count.
  ///
  /// In en, this message translates to:
  /// **'Download count'**
  String get bookshelf_download_count;

  /// No description provided for @bookshelf_source_global_hint.
  ///
  /// In en, this message translates to:
  /// **'Source visibility uses the shared display preference.'**
  String get bookshelf_source_global_hint;

  /// No description provided for @bookshelf_select_entries.
  ///
  /// In en, this message translates to:
  /// **'Select works'**
  String get bookshelf_select_entries;

  /// No description provided for @bookshelf_search_options.
  ///
  /// In en, this message translates to:
  /// **'Search options'**
  String get bookshelf_search_options;

  /// No description provided for @bookshelf_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'Collect works from sources or import local files.'**
  String get bookshelf_empty_hint;

  /// No description provided for @bookshelf_no_match_hint.
  ///
  /// In en, this message translates to:
  /// **'Try other keywords or adjust the current filters.'**
  String get bookshelf_no_match_hint;

  /// No description provided for @bookshelf_clear_query.
  ///
  /// In en, this message translates to:
  /// **'Clear keywords'**
  String get bookshelf_clear_query;

  /// No description provided for @bookshelf_view_selection.
  ///
  /// In en, this message translates to:
  /// **'View selected works'**
  String get bookshelf_view_selection;

  /// No description provided for @bookshelf_import_formats.
  ///
  /// In en, this message translates to:
  /// **'Choose a local file to add it to your bookshelf.'**
  String get bookshelf_import_formats;

  /// No description provided for @bookshelf_import_canceled_hint.
  ///
  /// In en, this message translates to:
  /// **'You can choose again after cancelling the file picker.'**
  String get bookshelf_import_canceled_hint;

  /// No description provided for @bookshelf_browse_sources.
  ///
  /// In en, this message translates to:
  /// **'Browse sources'**
  String get bookshelf_browse_sources;

  /// No description provided for @bookshelf_empty_title.
  ///
  /// In en, this message translates to:
  /// **'Your bookshelf is empty'**
  String get bookshelf_empty_title;

  /// No description provided for @bookshelf_no_match_title.
  ///
  /// In en, this message translates to:
  /// **'No matching works'**
  String get bookshelf_no_match_title;

  /// No description provided for @bookshelf_mark_watched.
  ///
  /// In en, this message translates to:
  /// **'Mark watched'**
  String get bookshelf_mark_watched;

  /// No description provided for @bookshelf_mark_unwatched.
  ///
  /// In en, this message translates to:
  /// **'Mark unwatched'**
  String get bookshelf_mark_unwatched;

  /// No description provided for @nodelane_account.
  ///
  /// In en, this message translates to:
  /// **'NodeLane account'**
  String get nodelane_account;

  /// No description provided for @nodelane_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in to NodeLane'**
  String get nodelane_sign_in;

  /// No description provided for @nodelane_account_intro.
  ///
  /// In en, this message translates to:
  /// **'View your account, subscription and translation quota'**
  String get nodelane_account_intro;

  /// No description provided for @nodelane_login_action.
  ///
  /// In en, this message translates to:
  /// **'Continue to sign in'**
  String get nodelane_login_action;

  /// No description provided for @nodelane_login_browser.
  ///
  /// In en, this message translates to:
  /// **'Sign in through the system browser, then return to the app'**
  String get nodelane_login_browser;

  /// No description provided for @nodelane_account_id.
  ///
  /// In en, this message translates to:
  /// **'Account ID'**
  String get nodelane_account_id;

  /// No description provided for @nodelane_account_init_error.
  ///
  /// In en, this message translates to:
  /// **'Account storage is unavailable. Restart the app and try again.'**
  String get nodelane_account_init_error;

  /// No description provided for @nodelane_account_refresh_error.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh account information'**
  String get nodelane_account_refresh_error;

  /// No description provided for @nodelane_account_auth_error.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Sign in again'**
  String get nodelane_account_auth_error;

  /// No description provided for @nodelane_account_unknown.
  ///
  /// In en, this message translates to:
  /// **'Subscription information is unavailable'**
  String get nodelane_account_unknown;

  /// No description provided for @nodelane_account_current.
  ///
  /// In en, this message translates to:
  /// **'Current subscription'**
  String get nodelane_account_current;

  /// No description provided for @nodelane_account_free.
  ///
  /// In en, this message translates to:
  /// **'Free account'**
  String get nodelane_account_free;

  /// No description provided for @nodelane_account_no_subscription.
  ///
  /// In en, this message translates to:
  /// **'No active subscription'**
  String get nodelane_account_no_subscription;

  /// No description provided for @nodelane_account_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get nodelane_account_active;

  /// No description provided for @nodelane_account_expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get nodelane_account_expired;

  /// No description provided for @nodelane_account_expiry.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get nodelane_account_expiry;

  /// No description provided for @nodelane_account_renewal.
  ///
  /// In en, this message translates to:
  /// **'Renewal'**
  String get nodelane_account_renewal;

  /// No description provided for @nodelane_renewal_auto.
  ///
  /// In en, this message translates to:
  /// **'Automatic renewal'**
  String get nodelane_renewal_auto;

  /// No description provided for @nodelane_renewal_manual.
  ///
  /// In en, this message translates to:
  /// **'Manual renewal'**
  String get nodelane_renewal_manual;

  /// No description provided for @nodelane_renewal_stopped.
  ///
  /// In en, this message translates to:
  /// **'Automatic renewal stopped'**
  String get nodelane_renewal_stopped;

  /// No description provided for @nodelane_renewal_gift.
  ///
  /// In en, this message translates to:
  /// **'Gift membership'**
  String get nodelane_renewal_gift;

  /// No description provided for @nodelane_renewal_attention.
  ///
  /// In en, this message translates to:
  /// **'Check your renewal status on the website'**
  String get nodelane_renewal_attention;

  /// No description provided for @nodelane_next_billing.
  ///
  /// In en, this message translates to:
  /// **'Next billing date'**
  String get nodelane_next_billing;

  /// No description provided for @nodelane_billing_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Renewal information is unavailable'**
  String get nodelane_billing_unavailable;

  /// No description provided for @nodelane_manage_account.
  ///
  /// In en, this message translates to:
  /// **'Manage on website'**
  String get nodelane_manage_account;

  /// No description provided for @nodelane_view_plans.
  ///
  /// In en, this message translates to:
  /// **'View subscription plans'**
  String get nodelane_view_plans;

  /// No description provided for @nodelane_translation_quota.
  ///
  /// In en, this message translates to:
  /// **'Translation quota'**
  String get nodelane_translation_quota;

  /// No description provided for @nodelane_quota_free.
  ///
  /// In en, this message translates to:
  /// **'Free quota'**
  String get nodelane_quota_free;

  /// No description provided for @nodelane_quota_subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription quota'**
  String get nodelane_quota_subscription;

  /// No description provided for @nodelane_quota_purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchased quota'**
  String get nodelane_quota_purchase;

  /// No description provided for @nodelane_quota_details.
  ///
  /// In en, this message translates to:
  /// **'View quota details'**
  String get nodelane_quota_details;

  /// No description provided for @nodelane_quota_expanded.
  ///
  /// In en, this message translates to:
  /// **'Quota details'**
  String get nodelane_quota_expanded;

  /// No description provided for @nodelane_quota_unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get nodelane_quota_unlimited;

  /// No description provided for @nodelane_quota_not_subscribed.
  ///
  /// In en, this message translates to:
  /// **'Not subscribed'**
  String get nodelane_quota_not_subscribed;

  /// No description provided for @nodelane_quota_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get nodelane_quota_unknown;

  /// No description provided for @nodelane_quota_used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get nodelane_quota_used;

  /// No description provided for @nodelane_quota_reserved.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get nodelane_quota_reserved;

  /// No description provided for @nodelane_quota_reset.
  ///
  /// In en, this message translates to:
  /// **'Next reset'**
  String get nodelane_quota_reset;

  /// No description provided for @nodelane_quota_expiry.
  ///
  /// In en, this message translates to:
  /// **'Next expiry'**
  String get nodelane_quota_expiry;

  /// No description provided for @nodelane_quota_no_expiry.
  ///
  /// In en, this message translates to:
  /// **'No expiry date'**
  String get nodelane_quota_no_expiry;

  /// No description provided for @nodelane_quota_reservation_note.
  ///
  /// In en, this message translates to:
  /// **'Pages in progress are already deducted from the available quota'**
  String get nodelane_quota_reservation_note;

  /// No description provided for @nodelane_quota_available.
  ///
  /// In en, this message translates to:
  /// **'{count} pages remaining'**
  String nodelane_quota_available(int count);

  /// No description provided for @nodelane_quota_pages.
  ///
  /// In en, this message translates to:
  /// **'{count} pages'**
  String nodelane_quota_pages(int count);

  /// No description provided for @nodelane_sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get nodelane_sign_out;

  /// No description provided for @nodelane_sign_out_confirm.
  ///
  /// In en, this message translates to:
  /// **'Signing out pauses official translation on this device. Your library and reading progress are kept.'**
  String get nodelane_sign_out_confirm;

  /// No description provided for @settings_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search settings'**
  String get settings_search_hint;

  /// No description provided for @settings_frequent.
  ///
  /// In en, this message translates to:
  /// **'Frequently used'**
  String get settings_frequent;

  /// No description provided for @settings_reading_translation.
  ///
  /// In en, this message translates to:
  /// **'Reading and translation'**
  String get settings_reading_translation;

  /// No description provided for @settings_app_preferences.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get settings_app_preferences;

  /// No description provided for @settings_data_management.
  ///
  /// In en, this message translates to:
  /// **'Data and management'**
  String get settings_data_management;

  /// No description provided for @settings_more_tools.
  ///
  /// In en, this message translates to:
  /// **'More tools'**
  String get settings_more_tools;

  /// No description provided for @settings_more_tools_hint.
  ///
  /// In en, this message translates to:
  /// **'Categories, statistics and calendar'**
  String get settings_more_tools_hint;

  /// No description provided for @settings_appearance_interface.
  ///
  /// In en, this message translates to:
  /// **'Appearance and interface'**
  String get settings_appearance_interface;

  /// No description provided for @settings_security_privacy.
  ///
  /// In en, this message translates to:
  /// **'Security and privacy'**
  String get settings_security_privacy;

  /// No description provided for @settings_source_preferences.
  ///
  /// In en, this message translates to:
  /// **'Source settings'**
  String get settings_source_preferences;

  /// No description provided for @settings_about_help.
  ///
  /// In en, this message translates to:
  /// **'About and help'**
  String get settings_about_help;

  /// No description provided for @settings_storage_backup.
  ///
  /// In en, this message translates to:
  /// **'Storage and backup'**
  String get settings_storage_backup;

  /// No description provided for @settings_pending_downloads.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String settings_pending_downloads(int count);

  /// No description provided for @settings_translation_language.
  ///
  /// In en, this message translates to:
  /// **'Translation language'**
  String get settings_translation_language;

  /// No description provided for @settings_translation_scope.
  ///
  /// In en, this message translates to:
  /// **'Used in the reader and web page translation'**
  String get settings_translation_scope;

  /// No description provided for @settings_immediate_choice.
  ///
  /// In en, this message translates to:
  /// **'Changes apply immediately'**
  String get settings_immediate_choice;

  /// No description provided for @settings_translation_init_error.
  ///
  /// In en, this message translates to:
  /// **'Translation settings are unavailable. Restart the app and try again.'**
  String get settings_translation_init_error;

  /// No description provided for @settings_local_cache.
  ///
  /// In en, this message translates to:
  /// **'Local cache'**
  String get settings_local_cache;

  /// No description provided for @settings_chapter_cache.
  ///
  /// In en, this message translates to:
  /// **'Chapter and episode cache'**
  String get settings_chapter_cache;

  /// No description provided for @settings_cover_cache.
  ///
  /// In en, this message translates to:
  /// **'Cover cache'**
  String get settings_cover_cache;

  /// No description provided for @settings_translation_cache.
  ///
  /// In en, this message translates to:
  /// **'Translated image cache'**
  String get settings_translation_cache;

  /// No description provided for @settings_translation_cache_hint.
  ///
  /// In en, this message translates to:
  /// **'Keep translation records and retrieve translated images again when needed'**
  String get settings_translation_cache_hint;

  /// No description provided for @settings_cache_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settings_cache_clear;

  /// No description provided for @settings_translation_cache_done.
  ///
  /// In en, this message translates to:
  /// **'Translated image cache cleared; translation records kept'**
  String get settings_translation_cache_done;

  /// No description provided for @settings_cache_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Clear {name}? Cached content can be retrieved again. Library entries will be kept.'**
  String settings_cache_confirmation(String name);

  /// No description provided for @settings_advanced_options.
  ///
  /// In en, this message translates to:
  /// **'Advanced options'**
  String get settings_advanced_options;

  /// No description provided for @settings_manga_reader.
  ///
  /// In en, this message translates to:
  /// **'Manga Reader'**
  String get settings_manga_reader;

  /// No description provided for @settings_novel_reader.
  ///
  /// In en, this message translates to:
  /// **'Novel Reader'**
  String get settings_novel_reader;

  /// No description provided for @settings_downloads.
  ///
  /// In en, this message translates to:
  /// **'Download settings'**
  String get settings_downloads;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'as',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'th',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'as':
      return AppLocalizationsAs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
