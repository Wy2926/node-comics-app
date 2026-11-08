// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_update_details_hint =>
      'View release notes and installation options';

  @override
  String get app_update_download => 'Download update';

  @override
  String get app_update_download_hint =>
      'After downloading, follow the prompts to install the update.';

  @override
  String get bookshelf_all => 'All';

  @override
  String get bookshelf_search => 'Search library';

  @override
  String get app_update_allow_install =>
      'Allow app installation in system settings, then return and tap Install.';

  @override
  String get app_update_waiting =>
      'Waiting for the system to resume the download…';

  @override
  String get app_update_cancel_download => 'Cancel download';

  @override
  String get app_update_remove_package => 'Remove downloaded package';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'No matching settings';

  @override
  String get search_empty_hint =>
      'Try another keyword, or clear the search to see everything.';

  @override
  String get search_clear => 'Clear search';

  @override
  String get app_updates => 'App updates';

  @override
  String get app_update_auto => 'Check on launch';

  @override
  String get app_update_view => 'View update';

  @override
  String get app_update_later => 'Later';

  @override
  String get app_update_external_hint =>
      'Opens the update link in your browser';

  @override
  String get app_update_failed =>
      'Unable to check for updates. Please try again.';

  @override
  String get app_update_opened => 'Update link opened';

  @override
  String get app_diagnostics => 'Diagnostics and logs';

  @override
  String get library => 'Library';

  @override
  String get updates_search => 'Search updates';

  @override
  String get updates => 'Updates';

  @override
  String get history => 'History';

  @override
  String get browse => 'Browse';

  @override
  String get more => 'More';

  @override
  String get open_random_entry => 'Open random entry';

  @override
  String get import => 'Import';

  @override
  String get filter => 'Filter';

  @override
  String get ignore_filters => 'Ignore Filters';

  @override
  String get downloaded => 'Downloaded';

  @override
  String get unread => 'Unread';

  @override
  String get unwatched => 'Unwatched';

  @override
  String get started => 'Started';

  @override
  String get bookmarked => 'Bookmarked';

  @override
  String get sort => 'Sort';

  @override
  String get alphabetically => 'Alphabetically';

  @override
  String get last_read => 'Last read';

  @override
  String get last_watched => 'Last watched';

  @override
  String get last_update_check => 'Last update check';

  @override
  String last_entry_delete_warning(
    num count,
    Object entryType,
    Object entryTypePlural,
    Object mediaType,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'You are deleting all $count $entryTypePlural of this $mediaType from the library.',
      one:
          'You are deleting the only $entryType of this $mediaType from the library.',
    );
    return '$_temp0\nThis will also remove the whole $mediaType from your library.\n\nNote: The files themselves will not be deleted.';
  }

  @override
  String get chapter => 'chapter';

  @override
  String get episode => 'episode';

  @override
  String get unread_count => 'Unread count';

  @override
  String get unwatched_count => 'Unwatched count';

  @override
  String get latest_chapter => 'Latest chapter';

  @override
  String get latest_episode => 'Latest episode';

  @override
  String get date_added => 'Date added';

  @override
  String get display => 'Display';

  @override
  String get display_mode => 'Display mode';

  @override
  String get compact_grid => 'Compact grid';

  @override
  String get compression_level => 'Compression level';

  @override
  String compression_info(Object level) {
    return 'The higher the compression, the less space the backup file takes, but it uses more CPU. Default: $level';
  }

  @override
  String get comfortable_grid => 'Comfortable grid';

  @override
  String get cover_only_grid => 'Cover-only grid';

  @override
  String get list => 'List';

  @override
  String get badges => 'Badges';

  @override
  String get downloaded_chapters => 'Downloaded chapters';

  @override
  String get downloaded_episodes => 'Downloaded episodes';

  @override
  String get language => 'Language';

  @override
  String get local_source => 'Local source';

  @override
  String get tabs => 'Tabs';

  @override
  String get show_category_tabs => 'Show category tabs';

  @override
  String get show_numbers_of_items => 'Show numbers of items';

  @override
  String get other => 'Other';

  @override
  String get show_continue_reading_buttons => 'Show continue reading buttons';

  @override
  String get show_continue_watching_buttons => 'Show continue watching buttons';

  @override
  String get empty_library => 'Empty library';

  @override
  String get search => 'Search...';

  @override
  String get no_recent_updates => 'No recent updates';

  @override
  String get remove_everything => 'Remove everything';

  @override
  String get remove_everything_msg => 'Are you sure? All history will be lost';

  @override
  String get remove_all_update_msg =>
      'Are you sure? The whole update will be cleared';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get remove => 'Remove';

  @override
  String get remove_history_msg =>
      'This will remove the read date of this chapter. Are you sure?';

  @override
  String get last_used => 'Last Used';

  @override
  String get pinned => 'Pinned';

  @override
  String get sources => 'Sources';

  @override
  String get install => 'Install';

  @override
  String get update => 'Update';

  @override
  String get latest => 'Latest';

  @override
  String get extensions => 'Extensions';

  @override
  String get migrate => 'Migrate';

  @override
  String get mass_migration_title => 'Mass migration';

  @override
  String get mass_migration_preview_items => 'Preview items';

  @override
  String get mass_migration_destination_source => 'Destination source';

  @override
  String get mass_migration_no_library_items =>
      'No library items are available for mass migration.';

  @override
  String get mass_migration_no_destination_sources =>
      'No installed destination sources are available.';

  @override
  String get mass_migration_installed => 'Installed';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items ready for review',
      one: '1 item ready for review',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Select destination source';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Finding matches in $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Processing item $current of $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Waiting 2 seconds before the next item...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Waiting 2 seconds before the next migration...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Matched so far: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'No match: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Review matches for $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Found matches: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'No matches: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Selected to migrate: $count';
  }

  @override
  String get mass_migration_finish_review => 'Finish review';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migrate selected items ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Migrating selected items to $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'No items selected for migration.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migrating item $current of $total';
  }

  @override
  String get mass_migration_complete => 'Mass migration complete';

  @override
  String get mass_migration_complete_success_message =>
      'All selected items were processed successfully.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migration finished with a few items that still need manual attention.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Processed';

  @override
  String get mass_migration_matched => 'Matched';

  @override
  String get mass_migration_migrated => 'Migrated';

  @override
  String get mass_migration_skipped => 'Skipped';

  @override
  String get mass_migration_failed => 'Failed';

  @override
  String get mass_migration_failed_items => 'Failed Items';

  @override
  String get mass_migration_exit => 'Exit Mass Migration';

  @override
  String get mass_migration_no_destination_match =>
      'No destination match found';

  @override
  String mass_migration_query(Object query) {
    return 'Query: $query';
  }

  @override
  String get mass_migration_skip => 'Skip';

  @override
  String get mass_migration_loading => 'Loading...';

  @override
  String get mass_migration_choose_another_result => 'Choose another result';

  @override
  String get mass_migration_source_chapters => 'Source chapters';

  @override
  String get mass_migration_destination_chapters => 'Destination chapters';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count source chapters',
      one: '1 source chapter',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destination chapters',
      one: '1 destination chapter',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'No chapters found.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'And $count more...';
  }

  @override
  String get mass_migration_unknown_title => 'Unknown title';

  @override
  String get mass_migration_unknown_match => 'Unknown match';

  @override
  String get mass_migration_unknown_source => 'Unknown source';

  @override
  String get mass_migration_unknown_chapter => 'Unknown chapter';

  @override
  String get migrate_confirm => 'Migrate to another source';

  @override
  String get clean_database => 'Clean database';

  @override
  String cleaned_database(Object x) {
    return 'Database cleaned! $x entries removed';
  }

  @override
  String get clean_database_desc =>
      'This will remove all items that are not added to the library!';

  @override
  String get incognito_mode => 'Incognito Mode';

  @override
  String get incognito_mode_description => 'Pauses reading history';

  @override
  String get downloaded_only => 'Downloaded only';

  @override
  String get downloaded_only_description =>
      'Only show downloaded entries in your library';

  @override
  String get download_queue => 'Download Queue';

  @override
  String get categories => 'Categories';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get help => 'Help';

  @override
  String get no_downloads => 'No Downloads';

  @override
  String get edit_categories => 'Edit Categories';

  @override
  String get edit_categories_description =>
      'You have no categories. Tap the plus button to create one for organizing your library';

  @override
  String get add => 'Add';

  @override
  String get add_category => 'Add Category';

  @override
  String get name => 'Name';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Required';

  @override
  String get add_category_error_exist =>
      'A category with this name already exist!';

  @override
  String get delete_category => 'Delete Category';

  @override
  String delete_category_msg(Object name) {
    return 'Do you wish to delete the category $name?';
  }

  @override
  String get rename_category => 'Rename Category';

  @override
  String get general => 'General';

  @override
  String get general_subtitle => 'App language';

  @override
  String get app_language => 'App language';

  @override
  String get default_subtitle_language => 'Default subtitle language';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearance_subtitle => 'Theme, date & time format';

  @override
  String get theme => 'Theme';

  @override
  String get dark_mode => 'Dark mode';

  @override
  String get follow_system_theme => 'Follow system theme';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get pure_black_dark_mode => 'Pure black dark mode';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get relative_timestamp => 'Relative timestamp';

  @override
  String get relative_timestamp_short => 'Short (Today, Yesterday)';

  @override
  String get relative_timestamp_long => 'Long (Short+, n days ago)';

  @override
  String get date_format => 'Date format';

  @override
  String get reader => 'Reader';

  @override
  String get refresh => 'Refresh';

  @override
  String get reader_subtitle => 'Reading mode, display, navigation';

  @override
  String get default_reading_mode => 'Default reading mode';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Left to Right';

  @override
  String get reading_mode_right_to_left => 'Right to Left';

  @override
  String get reading_mode_vertical_continuous => 'Vertical continuous';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Double tap animation speed';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Fast';

  @override
  String get no_animation => 'No animation';

  @override
  String get animate_page_transitions => 'Animate page transitions';

  @override
  String get crop_borders => 'Crop borders';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloads_subtitle => 'Downloads settings';

  @override
  String get download_location => 'Download location';

  @override
  String get custom_location => 'Custom location';

  @override
  String get only_on_wifi => 'Only on wifi';

  @override
  String get save_as_cbz_archive => 'Save as CBZ archive';

  @override
  String get delete_download_after_reading => 'Delete download after reading';

  @override
  String get concurrent_downloads => 'Concurrent downloads';

  @override
  String get browse_subtitle => 'Sources, global search';

  @override
  String get only_include_pinned_sources => 'Only include pinned sources';

  @override
  String get nsfw_sources => 'NSFW (+18) sources';

  @override
  String get nsfw_sources_show => 'Show in sources and extensions lists';

  @override
  String get nsfw_sources_info =>
      'This does not prevent unofficial or potentially incorrectly flagged extensions from surfacing NSFW (18+) content within the app';

  @override
  String get version => 'Version';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Check for update';

  @override
  String get logs_on => 'Enable logging';

  @override
  String get share_app_logs => 'Share app logs';

  @override
  String get no_app_logs => 'No log.txt available!';

  @override
  String get failed => 'Failed!';

  @override
  String n_days_ago(Object days) {
    return '$days days ago';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get a_week_ago => 'A week ago';

  @override
  String get next_week => 'Next week';

  @override
  String get add_to_library => 'Add to library';

  @override
  String get completed => 'Completed';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get on_hiatus => 'On Hiatus';

  @override
  String get canceled => 'Canceled';

  @override
  String get publishing_finished => 'Publishing finished';

  @override
  String get unknown => 'Unknown';

  @override
  String get empty_placeholder => 'EMPTY\nMPTY\nMTY\nMT\n\n';

  @override
  String get error => 'Error';

  @override
  String error_with_message(Object error) {
    return 'Error: $error';
  }

  @override
  String get no_pages_available => 'Error: no pages available';

  @override
  String get set_categories => 'Set categories';

  @override
  String get edit => 'Edit';

  @override
  String get in_library => 'In library';

  @override
  String get filter_scanlator_groups => 'Filter scanlator groups';

  @override
  String get reset => 'Reset';

  @override
  String get by_source => 'By source';

  @override
  String get by_chapter_number => 'By chapter number';

  @override
  String get by_episode_number => 'By episode number';

  @override
  String get by_upload_date => 'By upload date';

  @override
  String get source_title => 'Source title';

  @override
  String get create_extension => 'Create Extension';

  @override
  String get developer_mode => 'Developer mode';

  @override
  String get developer_mode_subtitle =>
      'Show extension developer tools (create extension, edit code)';

  @override
  String get choose_extension_language => 'Choose extension language';

  @override
  String get lang => 'Lang';

  @override
  String get base_url => 'BaseUrl';

  @override
  String get api_url_optional => 'ApiUrl (optional)';

  @override
  String get icon_url => 'iconUrl';

  @override
  String get source_icon_url => 'Source icon url';

  @override
  String get notes => 'notes';

  @override
  String get extension_name_example => 'ex: myAnime';

  @override
  String get language_code_example => 'ex: en';

  @override
  String get base_url_example => 'ex: https://example.com';

  @override
  String get api_url_example => 'ex: https://api.example.com';

  @override
  String get extension_notes_example => 'ex: this extension requires login';

  @override
  String get type => 'Type';

  @override
  String get target => 'Target';

  @override
  String get source_type_single => 'single';

  @override
  String get source_type_multi => 'multi';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader compiled JS';

  @override
  String get source_created_successfully => 'Source created successfully';

  @override
  String get source_already_exists => 'Source already exists';

  @override
  String get error_when_creating_source => 'Error when creating source';

  @override
  String get cookies_deleted => 'Cookies deleted!';

  @override
  String get delete_all_cookies => 'Delete all cookies';

  @override
  String get chapter_number => 'Chapter number';

  @override
  String get episode_number => 'Episode number';

  @override
  String get share => 'Share';

  @override
  String n_chapters(Object n) {
    return '$n chapters';
  }

  @override
  String missing_chapters(Object count) {
    return 'Missing $count chapters';
  }

  @override
  String get no_description => 'No description';

  @override
  String get resume => 'Resume';

  @override
  String get read => 'Read';

  @override
  String get watch => 'Watch';

  @override
  String get popular => 'Popular';

  @override
  String get open_in_browser => 'Open in browser';

  @override
  String get clear_cookie => 'Clear cookie';

  @override
  String get show_page_number => 'Show page number';

  @override
  String get from_library => 'From library';

  @override
  String get downloaded_chapter => 'Downloaded chapter';

  @override
  String page(Object page) {
    return 'Page $page';
  }

  @override
  String get global_search => 'Global search';

  @override
  String get color_blend_level => 'Color blend level';

  @override
  String current(Object char) {
    return 'Current $char';
  }

  @override
  String finished(Object char) {
    return 'Finished $char';
  }

  @override
  String next(Object char) {
    return 'Next $char';
  }

  @override
  String previous(Object char) {
    return 'Previous $char';
  }

  @override
  String get no_more_chapter => 'There\'s no more chapter';

  @override
  String get no_result => 'No result';

  @override
  String get send => 'Send';

  @override
  String get delete => 'Delete';

  @override
  String get start_downloading => 'Start downloading now';

  @override
  String get retry => 'Retry';

  @override
  String get add_chapters => 'Add Chapters';

  @override
  String get delete_chapters => 'Delete Chapter?';

  @override
  String get default0 => 'Default';

  @override
  String get total_chapters => 'Total Chapters';

  @override
  String get total_episodes => 'Total episodes';

  @override
  String get import_local_file => 'Import Local file';

  @override
  String get import_files => 'Files';

  @override
  String get split_epub_chapters => 'Split into chapters';

  @override
  String get split_epub_chapters_description =>
      'Import each EPUB chapter as a separate entry';

  @override
  String get nothing_read_recently => 'Nothing read recently';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Not started';

  @override
  String get score => 'Score';

  @override
  String get start_date => 'Start date';

  @override
  String get finish_date => 'Finish date';

  @override
  String get reading => 'Reading';

  @override
  String get on_hold => 'On hold';

  @override
  String get dropped => 'Dropped';

  @override
  String get plan_to_read => 'Plan to read';

  @override
  String get re_reading => 'Rereading';

  @override
  String get chapters => 'Chapters';

  @override
  String get add_tracker => 'Add tracking';

  @override
  String get one_tracker => '1 tracker';

  @override
  String n_tracker(Object n) {
    return '$n trackers';
  }

  @override
  String get tracking => 'Tracking';

  @override
  String get syncing => 'Sync';

  @override
  String get sync_logged => 'Login successful';

  @override
  String get syncing_subtitle =>
      'Enter your sync server address and sign in through the browser to sync reading progress across devices.';

  @override
  String get sync_service => 'Self-hosted sync';

  @override
  String get last_sync => 'Last sync at: ';

  @override
  String get sync_login_browser => 'Log in with browser';

  @override
  String get sync_server => 'Sync Server Address';

  @override
  String get sync_starting => 'Starting sync...';

  @override
  String get sync_finished => 'Sync finished';

  @override
  String get sync_failed => 'Sync failed';

  @override
  String get sync_restore_in_progress => 'Sync skipped — restore in progress';

  @override
  String sync_progress_percent(Object percent) {
    return 'Syncing… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Syncing…';

  @override
  String get sync_button_sync => 'Sync progress';

  @override
  String get sync_button_upload => 'Upload only';

  @override
  String get sync_button_upload_info =>
      'This device\'s data will overwrite the server\'s for anything it also has. Nothing on the server gets deleted.';

  @override
  String get sync_button_download => 'Download only';

  @override
  String get sync_button_download_info =>
      'Pulls in everything from the server. Nothing on this device gets deleted.';

  @override
  String get sync_status_not_configured => 'Not connected';

  @override
  String get sync_status_checking => 'Checking connection...';

  @override
  String get sync_status_connected => 'Connected';

  @override
  String get sync_status_unauthorized => 'Session expired, please log in again';

  @override
  String get sync_status_unreachable => 'Can\'t reach server';

  @override
  String get sync_section_general => 'General';

  @override
  String get sync_on => 'Enable sync';

  @override
  String get sync_auto => 'Auto Sync';

  @override
  String get sync_auto_warning =>
      'Auto Sync is currently an experimental feature!';

  @override
  String get sync_auto_off => 'Off';

  @override
  String get sync_auto_5_minutes => 'Every 5 minutes';

  @override
  String get sync_auto_10_minutes => 'Every 10 minutes';

  @override
  String get sync_auto_30_minutes => 'Every 30 minutes';

  @override
  String get sync_auto_1_hour => 'Every 1 hour';

  @override
  String get sync_auto_3_hours => 'Every 3 hours';

  @override
  String get sync_auto_6_hours => 'Every 6 hours';

  @override
  String get sync_auto_12_hours => 'Every 12 hours';

  @override
  String get server_error => 'Server error!';

  @override
  String get dialog_confirm => 'Confirm';

  @override
  String get description => 'Description';

  @override
  String get reorder_navigation => 'Customize navigation';

  @override
  String get reorder_navigation_description =>
      'Reorder and toggle each navigation to your needs.';

  @override
  String get floating_navigation_bar => 'Floating navigation bar';

  @override
  String get floating_navigation_bar_description =>
      'Use a floating capsule instead of the standard attached navigation bar.';

  @override
  String get full_screen_player => 'Use Fullscreen';

  @override
  String get full_screen_player_info =>
      'Automatically use fullscreen when playing a video.';

  @override
  String episode_progress(Object n) {
    return 'Progress: $n';
  }

  @override
  String n_episodes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n episodes',
      one: '1 episode',
    );
    return '$_temp0';
  }

  @override
  String missing_episodes(Object count) {
    return 'Missing $count episodes';
  }

  @override
  String get manga_sources => 'Manga Sources';

  @override
  String get anime_sources => 'Anime Sources';

  @override
  String get novel_sources => 'Novel Sources';

  @override
  String get anime_extensions => 'Anime Extensions';

  @override
  String get manga_extensions => 'Manga Extensions';

  @override
  String get novel_extensions => 'Novel Extensions';

  @override
  String get extension_settings => 'Extension settings';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'You don\'t have any categories yet';

  @override
  String get watching => 'Watching';

  @override
  String get plan_to_watch => 'Plan to watch';

  @override
  String get re_watching => 'Rewatching';

  @override
  String get episodes => 'Episodes';

  @override
  String get download => 'Download';

  @override
  String get new_update_available => 'New update available';

  @override
  String app_version(Object v) {
    return 'App Version : v$v';
  }

  @override
  String get searching_for_updates => 'Searching for updates...';

  @override
  String get no_new_updates_available => 'No new updates available';

  @override
  String get uninstall => 'Uninstall';

  @override
  String uninstall_extension(Object ext) {
    return 'Uninstall $ext extension?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Double-tap to search all $type';
  }

  @override
  String get show_nav_double_tap_tooltip => 'Show double-tap search hint';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Show a tooltip on the Manga/Anime/Novel nav destinations explaining that double-tapping opens Global Search.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" is already in your library via $source.';
  }

  @override
  String get add_anyway => 'Add Anyway';

  @override
  String get langauage => 'Language';

  @override
  String get extension_detail => 'Extension detail';

  @override
  String get scale_type => 'Scale type';

  @override
  String get scale_type_fit_screen => 'Fit screen';

  @override
  String get scale_type_stretch => 'Stretch';

  @override
  String get scale_type_fit_width => 'Fit width';

  @override
  String get scale_type_fit_height => 'Fit height';

  @override
  String get scale_type_original_size => 'Original size';

  @override
  String get scale_type_smart_fit => 'Smart fit';

  @override
  String get page_preload_amount => 'Page preload amount';

  @override
  String get page_preload_amount_subtitle =>
      'The amount of pages to preload when reading. Higher values will result in a smoother reading experience, at the cost of higher cache and network usage.';

  @override
  String get image_loading_error => 'This image couldn\'t be loaded';

  @override
  String get add_episodes => 'Add Episodes';

  @override
  String get video_quality => 'Quality';

  @override
  String get video_subtitle => 'Subtitle';

  @override
  String get check_for_extension_updates =>
      'Check for third-party extension updates';

  @override
  String get auto_extensions_updates => 'Auto-update third-party extensions';

  @override
  String get auto_extensions_updates_subtitle =>
      'Automatically update installed third-party extensions. Official plugins are always installed and updated automatically.';

  @override
  String get check_for_app_updates => 'Check for app updates on startup';

  @override
  String get reading_mode => 'Reading mode';

  @override
  String get custom_filter => 'Custom filter';

  @override
  String get background_color => 'Background color';

  @override
  String get white => 'White';

  @override
  String get black => 'Black';

  @override
  String get grey => 'Grey';

  @override
  String get automaic => 'Automatic';

  @override
  String get preferred_domain => 'Preferred Domain';

  @override
  String get load_more => 'Load More';

  @override
  String get cancel_all_for_this_series => 'Cancel all for this series';

  @override
  String get login => 'Login';

  @override
  String login_into(Object tracker) {
    return 'Login into $tracker';
  }

  @override
  String get email_adress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String log_out_from(Object tracker) {
    return 'Log out from $tracker?';
  }

  @override
  String get log_out => 'Log out';

  @override
  String get update_pending => 'Update pending';

  @override
  String get update_all => 'Update all';

  @override
  String get backup_and_restore => 'Backup and restore';

  @override
  String get create_backup => 'Create backup';

  @override
  String get create_backup_dialog_title => 'What do you want to backup?';

  @override
  String get create_backup_subtitle => 'Can be used to restore current library';

  @override
  String get restore_backup => 'Restore backup';

  @override
  String get encrypt_backups => 'Encrypt backups';

  @override
  String get encrypt_backups_info =>
      'Password-protect backup files using AES encryption';

  @override
  String get no_secure_storage => 'No secure storage found';

  @override
  String get no_keyring_warning =>
      'This system doesn\'t have a keyring service available (e.g. gnome-keyring or kwallet on Linux), so the password can\'t be stored securely.\n\nStore it unencrypted in the local app database instead? Anyone with access to this device\'s app data would be able to read it.';

  @override
  String get enter_backup_password => 'Enter backup password';

  @override
  String get incorrect_password_try_again => 'Incorrect password, try again.';

  @override
  String get set_backup_password => 'Set backup password';

  @override
  String get confirm_password => 'Confirm password';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get password_required_to_restore =>
      'A password is required to restore this backup.';

  @override
  String get restore_backup_subtitle => 'Restore library from backup file';

  @override
  String get automatic_backups => 'Automatic backups';

  @override
  String get backup_frequency => 'Backup frequency';

  @override
  String get backup_location => 'Backup location';

  @override
  String get backup_options => 'Backup options';

  @override
  String get backup_options_dialog_title => 'What do you want to backup?';

  @override
  String get backup_options_subtitle =>
      'What information to include in the backup file?';

  @override
  String get backup_and_restore_warning_info =>
      'You should keep copies of backups in other places as well';

  @override
  String get library_entries => 'Library entries';

  @override
  String get chapters_and_episode => 'Chapters and episode';

  @override
  String get every_6_hours => 'Every 6 hours';

  @override
  String get every_12_hours => 'Every 12 hours';

  @override
  String get daily => 'Daily';

  @override
  String get every_2_days => 'Every 2 days';

  @override
  String get weekly => 'Weekly';

  @override
  String get restore_backup_warning_title =>
      'Restoring a backup will overwrite all existing data.\n\nContinue restoring?';

  @override
  String get restore_sync_question_title => 'Sync this restore?';

  @override
  String get restore_sync_question_message =>
      'This device is connected to a sync server. Upload this restored data to it now? If not, sync will be turned off so the server\'s old data doesn\'t overwrite what you just restored.';

  @override
  String get restore_sync_question_confirm => 'Yes, sync';

  @override
  String get restore_sync_question_deny => 'No, disable sync';

  @override
  String get sync_disabled_after_restore =>
      'Sync is disabled. You can turn it on again in Settings.';

  @override
  String get restore_sync_disabled_question_title =>
      'Sync is currently disabled';

  @override
  String get restore_sync_disabled_question_message =>
      'Sync is turned off. Turn it back on and upload this restored data to your server?';

  @override
  String get restore_sync_question_reenable => 'Yes, re-enable and sync';

  @override
  String get restore_sync_question_keep_disabled => 'Keep it disabled';

  @override
  String get restore_sync_uploading => 'Syncing restored data to server…';

  @override
  String get restore_sync_upload_success => 'Restored data synced to server';

  @override
  String get services => 'Services';

  @override
  String get tracking_warning_info =>
      'One-way sync to update the chapter progress in tracking services. Set up tracking for individual entries from their tracking button.';

  @override
  String get use_page_tap_zones => 'Use page tap zones';

  @override
  String get manage_trackers => 'Manage trackers';

  @override
  String get restore => 'Restore';

  @override
  String get backups => 'Backups';

  @override
  String get by_scanlator => 'By scanlator';

  @override
  String get by_name => 'By name';

  @override
  String get installed => 'Installed';

  @override
  String get auto_scroll => 'Auto scroll';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Preferred languages, pitch correction, audio channels';

  @override
  String get player => 'Player';

  @override
  String get markEpisodeAsSeenSetting =>
      'At what point to mark the episode as seen';

  @override
  String get mark_duplicate_chapters_read =>
      'Mark duplicate chapter numbers as read';

  @override
  String get default_skip_intro_length => 'Intro skip duration';

  @override
  String get default_playback_speed_length => 'Default playback speed';

  @override
  String get updateProgressAfterReading => 'Update progress after reading';

  @override
  String get no_sources_installed => 'No sources installed!';

  @override
  String get show_extensions => 'Show extensions';

  @override
  String get default_skip_forward_skip_length => 'Double-tap seek duration';

  @override
  String get aniskip_requires_info =>
      'AniSkip requires the anime to be tracked with MAL or Anilist to work.';

  @override
  String get enable_aniskip => 'Enable AniSkip';

  @override
  String get enable_auto_skip => 'Enable auto skip';

  @override
  String get aniskip_button_timeout => 'Button timeout';

  @override
  String get skip_opening => 'Skip opening';

  @override
  String get skip_ending => 'Skip ending';

  @override
  String get fullscreen => 'Fullscreen';

  @override
  String get update_library => 'Update library';

  @override
  String get next_chapter => 'Next chapter';

  @override
  String get next_5_chapters => 'Next 5 chapters';

  @override
  String get next_10_chapters => 'Next 10 chapters';

  @override
  String get next_25_chapters => 'Next 25 chapters';

  @override
  String get all_chapters => 'All chapters';

  @override
  String get next_episode => 'Next episode';

  @override
  String get next_5_episodes => 'Next 5 episodes';

  @override
  String get next_10_episodes => 'Next 10 episodes';

  @override
  String get next_25_episodes => 'Next 25 episodes';

  @override
  String get all_episodes => 'All episodes';

  @override
  String get cover_saved => 'Cover saved';

  @override
  String get set_as_cover => 'Set as cover';

  @override
  String get use_this_as_cover_art => 'Use this as cover art?';

  @override
  String get save => 'Save';

  @override
  String get picture_saved => 'Picture saved';

  @override
  String get cover_updated => 'Cover updated';

  @override
  String get include_subtitles => 'Include subtitles';

  @override
  String get blend_mode_default => 'Default';

  @override
  String get blend_mode_multiply => 'Multiply';

  @override
  String get blend_mode_screen => 'Screen';

  @override
  String get blend_mode_overlay => 'Overlay';

  @override
  String get blend_mode_colorDodge => 'ColorDodge';

  @override
  String get blend_mode_lighten => 'Lighten';

  @override
  String get blend_mode_colorBurn => 'ColorBurn';

  @override
  String get blend_mode_darken => 'Darken';

  @override
  String get blend_mode_difference => 'Difference';

  @override
  String get blend_mode_saturation => 'Saturation';

  @override
  String get blend_mode_softLight => 'SoftLight';

  @override
  String get blend_mode_plus => 'Plus';

  @override
  String get blend_mode_exclusion => 'Exclusion';

  @override
  String get custom_color_filter => 'Custom color filter';

  @override
  String get color_filter_blend_mode => 'Color filter blend mode';

  @override
  String get enable_all => 'Enable all';

  @override
  String get disable_all => 'Disable all';

  @override
  String get font => 'Font';

  @override
  String get color => 'Color';

  @override
  String get font_size => 'Font size';

  @override
  String get text => 'Text';

  @override
  String get border => 'Border';

  @override
  String get background => 'Background';

  @override
  String get no_subtite_warning_message =>
      'Has no effect because there aren\'t any subtitle tracks in this video';

  @override
  String get grid_size => 'Grid size';

  @override
  String n_per_row(Object n) {
    return '$n per row';
  }

  @override
  String get horizontal_continious => 'Horizontal continuous';

  @override
  String get edit_code => 'Edit code';

  @override
  String get use_libass => 'Enable libass';

  @override
  String get use_libass_info =>
      'Use libass based subtitle rendering for native backend.';

  @override
  String get libass_not_disable_message =>
      'Disable `use libass` in player settings to be able to customize the subtitles.';

  @override
  String get override_ass_subtitles => 'Override ASS subtitles';

  @override
  String get override_ass_subtitles_info =>
      'Apply custom styling to ASS/SSA subtitles';

  @override
  String get torrent_stream => 'Torrent Stream';

  @override
  String get add_torrent => 'Add torrent';

  @override
  String get enter_torrent_hint_text => 'Enter magnet or torrent file url';

  @override
  String get torrent_url => 'Torrent url';

  @override
  String get or => 'OR';

  @override
  String get advanced => 'Advanced';

  @override
  String get advanced_info => 'mpv config';

  @override
  String get use_native_http_client => 'Use native http client';

  @override
  String get use_native_http_client_info =>
      'it automatically supports platform features such VPNs, support more HTTP features such as HTTP/3 and custom redirect handling';

  @override
  String n_hour_ago(Object hour) {
    return '$hour hour ago';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours hours ago';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute minute ago';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes minutes ago';
  }

  @override
  String n_day_ago(Object day) {
    return '$day day ago';
  }

  @override
  String get now => 'now';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Library last updated: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Data and storage';

  @override
  String get download_location_info => 'Used for chapter downloads';

  @override
  String get storage => 'Storage';

  @override
  String get clear_chapter_and_episode_cache =>
      'Clear chapter and episode cache';

  @override
  String get cache_cleared => 'Cache cleared';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Clear chapter/episode cache on app launch';

  @override
  String get app_settings => 'App settings';

  @override
  String get sources_settings => 'Sources settings';

  @override
  String get include_sensitive_settings =>
      'Include sensitive settings (e.g., tracker login tokens)';

  @override
  String get create => 'Create';

  @override
  String get downloads_are_limited_to_wifi =>
      'Downloads are limited to Wi-Fi only';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get recommendations_similar => 'similar';

  @override
  String get recommendations_weights => 'Recommendation Weights';

  @override
  String get recommendations_weights_genre => 'Genre Similarity';

  @override
  String get recommendations_weights_setting => 'Setting Similarity';

  @override
  String get recommendations_weights_synopsis => 'Story Similarity';

  @override
  String get recommendations_weights_theme => 'Theme Similarity';

  @override
  String get manga_extensions_repo => 'Manga extensions repo';

  @override
  String get anime_extensions_repo => 'Anime extensions repo';

  @override
  String get novel_extensions_repo => 'Novel extensions repo';

  @override
  String get custom_dns => 'Custom DNS (leave blank to use system DNS)';

  @override
  String get android_proxy_server =>
      'Android Proxy Server (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Get M-Extension-Server';

  @override
  String get undefined => 'undefined';

  @override
  String get empty_extensions_repo => 'No extension repositories yet';

  @override
  String get add_extensions_repo => 'Add repo URL';

  @override
  String get remove_extensions_repo => 'Remove repo URL';

  @override
  String get manage_manga_repo_urls => 'Manage Manga Repo URLs';

  @override
  String get manage_anime_repo_urls => 'Manage Anime Repo URLs';

  @override
  String get manage_novel_repo_urls => 'Manage Novel Repo URLs';

  @override
  String get url_cannot_be_empty => 'URL cannot be empty';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL must end with .json / .pb';

  @override
  String get repo_url => 'Repo URL';

  @override
  String get invalid_url_format => 'Invalid URL format';

  @override
  String get clear_all_sources => 'Clear all sources';

  @override
  String get clear_all_sources_msg =>
      'This will completely erase all sources of the application. Are you sure you want to continue?';

  @override
  String get sources_cleared => 'Sources cleared!!!';

  @override
  String get repo_added => 'Source repository added!';

  @override
  String get repo_already_exists => 'Repository already exists!';

  @override
  String get add_repo => 'Add Repository?';

  @override
  String get add_repo_sources_to_add => 'Extension lists that will be added:';

  @override
  String get add_repo_warning =>
      'Extensions from these repositories run inside the app. Only add repositories you trust.';

  @override
  String get genre_search_library => 'Search genre in library';

  @override
  String get genre_search_source => 'Browse in source';

  @override
  String get source_not_added => 'Source is not installed!';

  @override
  String get load_own_subtitles => 'Load your own subtitles...';

  @override
  String get search_subtitles => 'Search subtitles online...';

  @override
  String extension_notes(Object notes) {
    return 'Notes: $notes';
  }

  @override
  String get unsupported_repo =>
      'Unable to add this source repository. Check the repository address or contact its maintainer.';

  @override
  String get you_have_finished_reading => 'You have finished reading';

  @override
  String get hwdec => 'Hardware Decoder';

  @override
  String get enable_hardware_accel => 'Hardware Acceleration';

  @override
  String get enable_hardware_accel_info =>
      'Turn it on/off if you are experiencing bugs or crashes';

  @override
  String get track_library_navigate => 'Go to existing local entry';

  @override
  String get track_library_add => 'Add to local library';

  @override
  String get track_library_add_confirm => 'Add tracked item to local library';

  @override
  String get track_library_not_logged =>
      'Login to the corresponding tracker to use this feature!';

  @override
  String get track_library_switch => 'Switch to another tracker';

  @override
  String get go_back => 'Go back';

  @override
  String get merge_library_nav_mobile => 'Merge library navigation on mobile';

  @override
  String get enable_discord_rpc => 'Enable Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Hide Discord RPC while in Incognito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Show current chapter in Discord (requires a restart)';

  @override
  String get rpc_show_title => 'Show current title in Discord';

  @override
  String get rpc_show_cover_image => 'Show current cover image in Discord';

  @override
  String get enable_mpv => 'Enable mpv shaders / scripts';

  @override
  String get mpv_info => 'Supports .js scripts under mpv/scripts/';

  @override
  String get mpv_redownload => 'Redownload mpv config files';

  @override
  String get mpv_redownload_info => 'Replaces old config files with new one!';

  @override
  String get mpv_download => 'MPV config files are required!\nDownload now?';

  @override
  String get custom_buttons => 'Custom buttons';

  @override
  String get custom_buttons_info => 'Execute lua code with custom buttons';

  @override
  String get custom_buttons_edit => 'Edit custom buttons';

  @override
  String get custom_buttons_add => 'Add custom button';

  @override
  String get custom_buttons_added => 'Custom button added!';

  @override
  String get custom_buttons_delete => 'Delete custom button';

  @override
  String get custom_buttons_text => 'Button text';

  @override
  String get custom_buttons_text_req => 'Button text required';

  @override
  String get custom_buttons_js_code => 'lua code';

  @override
  String get custom_buttons_js_code_req => 'lua code required';

  @override
  String get custom_buttons_js_code_long => 'lua code (on long press)';

  @override
  String get custom_buttons_startup => 'lua code (on startup)';

  @override
  String get custom_buttons_add_warning =>
      'This button runs the Lua code below in the video player, which can access your files and run programs. Only add it if you trust where this link came from.';

  @override
  String n_days(Object n) {
    return '$n days';
  }

  @override
  String get decoder => 'Decoder';

  @override
  String get decoder_info => 'Hardware decoding, pixel format, debanding';

  @override
  String get enable_gpu_next => 'Enable gpu-next (Android only)';

  @override
  String get enable_gpu_next_info => 'A new video rendering backend';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Use YUV420P pixel format';

  @override
  String get use_yuv420p_info =>
      'May fix black screens on some video codecs, can also improve performance at the cost of quality';

  @override
  String get audio_preferred_languages => 'Preferred languages';

  @override
  String get audio_preferred_languages_info =>
      'Audio languages to prefer when a video has multiple audio tracks. Use two- or three-letter codes, separated by commas (for example: ja, en).';

  @override
  String get enable_audio_pitch_correction => 'Enable audio pitch correction';

  @override
  String get enable_audio_pitch_correction_info =>
      'Prevents the audio from becoming high-pitched at faster speeds and low-pitched at slower speeds';

  @override
  String get audio_channels => 'Audio channels';

  @override
  String get volume_boost_cap => 'Volume boost cap';

  @override
  String get internal_player => 'Internal player';

  @override
  String get internal_player_info => 'Progress, controls, orientation';

  @override
  String get subtitle_delay_text => 'Subtitle delay';

  @override
  String get subtitle_delay => 'Delay (ms)';

  @override
  String get subtitle_speed => 'Speed';

  @override
  String get tracks => 'Tracks';

  @override
  String get playback_speed => 'Playback speed';

  @override
  String get shaders => 'Shaders';

  @override
  String get video_fit => 'Fit';

  @override
  String get calendar => 'Calendar';

  @override
  String get calendar_no_data => 'No data yet.';

  @override
  String get calendar_info =>
      'The calendar is only able to predict the next chapter upload based on the older uploads. Some data might not be 100% accurate!';

  @override
  String in_n_day(Object days) {
    return 'in $days day';
  }

  @override
  String in_n_days(Object days) {
    return 'in $days days';
  }

  @override
  String get clear_library => 'Clear library';

  @override
  String get clear_library_desc =>
      'Choose to clear all manga, anime and/or novel entries';

  @override
  String get clear_library_input =>
      'Type \'manga\', \'anime\' and/or \'novel\' (separated by a comma) to remove all related entries';

  @override
  String get watch_order => 'Watch order';

  @override
  String get watch_order_role_current => 'Current';

  @override
  String get watch_order_role_previous => 'Previous';

  @override
  String get watch_order_role_next => 'Next';

  @override
  String get watch_order_source_release_order => 'Release order';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name by $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Official Trakt collection: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt collection: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Seasons for $title';
  }

  @override
  String get watch_order_select_source => 'Order source';

  @override
  String watch_order_season(int number) {
    return 'Season $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Episode $number';
  }

  @override
  String get sequels => 'Sequels';

  @override
  String get recommendations_similarity => 'Similarity:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Rating $rating';
  }

  @override
  String get local_folder_structure => 'Structure of a local folder';

  @override
  String get local_folder => 'Local folders';

  @override
  String get add_local_folder => 'Add local folder';

  @override
  String get rescan_local_folder => 'Rescan all local folders now';

  @override
  String get default_download_destination => 'Default download destination';

  @override
  String get ask_download_destination => 'Ask for download destination';

  @override
  String get ask_download_destination_desc =>
      'Choose a local folder each time a download starts.';

  @override
  String get select_download_destination => 'Select download destination';

  @override
  String get clear_local_library => 'Clear local library';

  @override
  String get clear_local_library_desc =>
      'Remove local folder and archive entries from the library.';

  @override
  String get clear_local_library_msg =>
      'This will remove local folder and archive entries from your library. It will not delete files from disk.';

  @override
  String get custom => 'Custom';

  @override
  String get no_local_folder_available_for_downloads =>
      'No local folder is available for downloads';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Failed to create CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Error reading cover image: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Error reading metadata: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Error saving chapter/episode to library: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Error reading chapter cover image: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Error reading archive cover image: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Error getting local library: $error';
  }

  @override
  String get export_metadata => 'Export metadata';

  @override
  String get exported => 'Exported';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Failed to export metadata: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count chapter(s) couldn\'t be auto-numbered and may be out of order or missing from the reader.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Couldn\'t start Cloudflare Resolution Webview Server.';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker Token expired';
  }

  @override
  String get video_list_empty => 'Video list is empty';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Could not launch $url';
  }

  @override
  String get text_size => 'Text Size :';

  @override
  String get text_align => 'Text Align';

  @override
  String get line_height => 'Line Height';

  @override
  String get show_scroll_percentage => 'Show Scroll Percentage';

  @override
  String get remove_extra_paragraph_spacing => 'Remove Extra Paragraph Spacing';

  @override
  String select_label_color(Object label) {
    return 'Select $label Color';
  }

  @override
  String get default_user_agent => 'Default user agent';

  @override
  String get forceLandscapeMode => 'Force landscape mode';

  @override
  String get forceLandscapeModeSubtitle =>
      'Force the player to use landscape orientation.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNS Provider';

  @override
  String get tracked => 'Tracked';

  @override
  String get auth_unlock_msg => 'Authenticate to unlock the app';

  @override
  String get app_locked => 'App locked';

  @override
  String get auth_to_continue => 'Authenticate to continue';

  @override
  String get authenticating => 'Authenticating...';

  @override
  String get lock => 'Lock';

  @override
  String get unlock => 'Unlock';

  @override
  String get security => 'Security';

  @override
  String get auth_to_change_security_setting =>
      'Authenticate to change security settings';

  @override
  String get app_lock => 'App lock';

  @override
  String get require_biometric_or_device_credential =>
      'Require biometric or device credential to open the app';

  @override
  String get biometric_or_device_credential_not_available =>
      'Biometric or device credential authentication is not available on this device';

  @override
  String get app_lock_description =>
      'When app lock is enabled, you will be asked to authenticate every time you open the app or switch back to it from the background.';

  @override
  String get checking_device_authentication =>
      'Checking device authentication…';

  @override
  String get device_authentication_incomplete =>
      'Authentication was not completed. Your setting has not changed.';

  @override
  String get keep_screen_on => 'Keep screen on';

  @override
  String get webtoon_side_padding => 'Webtoon side padding';

  @override
  String get show_page_gaps => 'Show page gaps';

  @override
  String get invert_colors => 'Invert colors';

  @override
  String get grayscale => 'Grayscale';

  @override
  String get brightness => 'Brightness';

  @override
  String get contrast => 'Contrast';

  @override
  String get saturation => 'Saturation';

  @override
  String get navigation_layout => 'Navigation layout';

  @override
  String get nav_layout_default => 'Default';

  @override
  String get nav_layout_l_shaped => 'L-shaped';

  @override
  String get nav_layout_kindle => 'Kindle-ish';

  @override
  String get nav_layout_edge => 'Edge';

  @override
  String get nav_layout_right_and_left => 'Right and left';

  @override
  String get nav_layout_disabled => 'Disabled';

  @override
  String get color_enhancements => 'Color enhancements';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Mean per Title';

  @override
  String get completion_rate => 'Completion Rate';

  @override
  String get watching_time => 'Watch Time';

  @override
  String get reading_time => 'Reading Time';

  @override
  String average_chapters_per_title(Object title) {
    return 'Average Chapters per $title';
  }

  @override
  String get read_percentage => 'Read Percentage';

  @override
  String get entries => 'Entries';

  @override
  String get android_proxy_server_mihon => 'Android Proxy Server (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Download and configure the proxy server required to use Mihon extensions.';

  @override
  String get mihon_proxy_server => 'Mihon proxy server';

  @override
  String get extension_server_intro_with_jre =>
      'Download the proxy server bundle before using Mihon extensions. The bundle includes the JRE and extension server JAR.';

  @override
  String get extension_server_intro_ios =>
      'Download the proxy server JAR before using Mihon extensions. iOS only needs the extension server JAR.';

  @override
  String get checking_files => 'Checking files';

  @override
  String get files_installed => 'Files installed';

  @override
  String get files_missing => 'Files missing';

  @override
  String get update_files => 'Update files';

  @override
  String get up_to_date => 'Up to date';

  @override
  String get choose_location => 'Choose location';

  @override
  String get import_existing_jar => 'Import existing JAR';

  @override
  String get detect_files_in_selected_folder =>
      'Detect files in selected folder';

  @override
  String get preparing_download => 'Preparing download...';

  @override
  String get app_install_location => 'App install location';

  @override
  String get install_location => 'Install location';

  @override
  String get jre_executable => 'JRE executable';

  @override
  String get extension_server_jar => 'Extension server JAR';

  @override
  String get installed_version => 'Installed version';

  @override
  String get latest_version => 'Latest version';

  @override
  String get m_extension_server_description =>
      'Use M-Extension-Server when you need a separate Android device proxy. Set the proxy address here and download the APK from GitHub.';

  @override
  String get set_proxy_address => 'Set proxy address';

  @override
  String get no_newer_proxy_server_release_available =>
      'No newer proxy server release is available.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Could not check for proxy server updates.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'No extension server bundle is available for this platform.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Failed to download bundle ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'The downloaded bundle does not contain the expected files.';

  @override
  String get extension_server_files_ready =>
      'Extension server files are ready.';

  @override
  String get ios_extension_server_import_hint =>
      'On iOS the server is installed inside the app sandbox. Use \"Import existing JAR\" to bring in a downloaded file.';

  @override
  String get select_extension_server_folder => 'Select extension server folder';

  @override
  String get selected_folder_does_not_exist =>
      'The selected folder does not exist.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'No extension server files were found in the selected folder.';

  @override
  String get extension_server_files_linked =>
      'Extension server files were linked.';

  @override
  String get select_extension_server_jar => 'Select extension server JAR';

  @override
  String get selected_file_could_not_be_accessed =>
      'The selected file could not be accessed.';

  @override
  String get extension_server_jar_imported =>
      'Extension server JAR was imported.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Could not launch the M-Extension-Server page.';

  @override
  String get proxy_server_ip_hint =>
      'Server IP (e.g., 10.0.0.5 or https://example.com)';

  @override
  String get not_configured => 'Not configured';

  @override
  String get zero_interpreter => 'Zero interpreter';

  @override
  String get zero_interpreter_description =>
      'Control the Zero interpreter server automatically or manually.';

  @override
  String get start_server_on_launch => 'Start server on launch';

  @override
  String get runtime_status => 'Runtime status';

  @override
  String get running => 'Running';

  @override
  String get stopped => 'Stopped';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Text-to-Speech';

  @override
  String get tts_speed => 'Speed';

  @override
  String get tts_pitch => 'Pitch';

  @override
  String get tts_language => 'Language';

  @override
  String get tts_voice => 'Voice';

  @override
  String get tts_stop => 'Stop';

  @override
  String get tts_play => 'Play';

  @override
  String get tts_pause => 'Pause';

  @override
  String get tts_previous => 'Previous paragraph';

  @override
  String get tts_next => 'Next paragraph';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Paragraph $current of $total';
  }

  @override
  String get tts_settings => 'TTS Settings';

  @override
  String get tts_default => 'Default';

  @override
  String get webtoon_disable_zoom_out => 'Webtoon disable zoom out';

  @override
  String get webtoon_double_tap_zoom_enabled => 'Webtoon double tap zoom';

  @override
  String get navigate_to_pan => 'Navigate to pan';

  @override
  String get navigate_to_pan_subtitle =>
      'Move zoomed image before turning page';

  @override
  String get split_wide_pages => 'Split wide pages';

  @override
  String get dual_page_invert => 'Invert cut half pages';

  @override
  String get dual_page_rotate_to_fit => 'Rotate to fit';

  @override
  String get dual_page_rotate_to_fit_invert => 'Invert rotation direction';

  @override
  String get double_page_single_first_page => 'Single first page';

  @override
  String get double_page_single_first_page_subtitle =>
      'Display the first page alone in double page mode';

  @override
  String get double_page_auto => 'Automatic double page';

  @override
  String get double_page_auto_subtitle =>
      'Switch to double page mode automatically in landscape';

  @override
  String get landscape_zoom => 'Automatic landscape zoom';

  @override
  String get zoom_start_position => 'Zoom start position';

  @override
  String get zoom_start_left => 'Left';

  @override
  String get zoom_start_right => 'Right';

  @override
  String get zoom_start_center => 'Center';

  @override
  String get automatic_background => 'Automatic background';

  @override
  String get tapping_inversion => 'Tapping Inversion';

  @override
  String get tapping_inversion_none => 'None';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertical';

  @override
  String get tapping_inversion_both => 'Both';

  @override
  String get flash_on_page_change => 'Flash on page change';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED anti-retention helper';

  @override
  String get flash_color => 'Flash Color';

  @override
  String get flash_color_black => 'Black';

  @override
  String get flash_color_white => 'White';

  @override
  String get flash_color_white_black => 'White & Black';

  @override
  String get flash_interval_label => 'Flash Interval';

  @override
  String flash_interval_value(String n) {
    return '$n pages';
  }

  @override
  String flash_interval(String n) {
    return 'Flash Interval: $n pages';
  }

  @override
  String get flash_duration_label => 'Flash Duration';

  @override
  String flash_duration_value(String n) {
    return '$n ms';
  }

  @override
  String flash_duration(String n) {
    return 'Flash Duration: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Show Navigation Overlay on startup';

  @override
  String get reader_hide_threshold => 'Reader Hide Threshold';

  @override
  String get reader_hide_threshold_highest => 'Highest (5 px)';

  @override
  String get reader_hide_threshold_high => 'High (13 px)';

  @override
  String get reader_hide_threshold_low => 'Low (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Lowest (47 px)';

  @override
  String get error_no_pages_available => 'Error: no pages available';

  @override
  String get app_ui_scale => 'Interface scale';

  @override
  String get app_ui_scale_subtitle =>
      'Make the interface larger or smaller to suit your screen and viewing distance.';

  @override
  String get allow_concurrent_downloads => 'Allow concurrent downloads';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Download from different sources at the same time. A single source still downloads one chapter at a time so it isn\'t overloaded. Turn off to download one at a time everywhere.';

  @override
  String get download_delay => 'Download delay';

  @override
  String get download_delay_subtitle =>
      'Off. Add a wait with random jitter between chapters to be gentler on sources.';

  @override
  String get save_search => 'Save search';

  @override
  String get saved_searches => 'Saved searches';

  @override
  String get enter_search_to_save_first => 'Enter a search to save first';

  @override
  String get no_saved_searches =>
      'No saved searches for this source yet.\nRun a search, then pick \"Save search\".';

  @override
  String get source => 'Source';

  @override
  String get something_went_wrong => 'Something went wrong';

  @override
  String get startup_failed => 'NodeLane Comics could not finish starting up';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources with no results',
      one: '1 source with no results',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'How should this be imported?';

  @override
  String get import_mode_message =>
      'Choose whether to merge this backup into your current library, or replace your entire library with it.';

  @override
  String get import_mode_keep_existing => 'Merge';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Adds new series and updates matching ones. Nothing in your current library is removed.';

  @override
  String get import_mode_replace => 'Replace';

  @override
  String get import_mode_replace_subtitle =>
      'Deletes your entire current library and replaces it with this backup.';

  @override
  String get replace_summary_title => 'Ready to replace your library';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'This deletes your entire current library ($currentCount series) and replaces it with $backupCount series from this backup. This can only be undone by rolling back.';
  }

  @override
  String get replace_summary_confirm => 'Replace';

  @override
  String replace_result_message(Object count) {
    return 'Replaced your library with $count series from this backup.';
  }

  @override
  String get category_conflict_title => 'Existing categories found';

  @override
  String get category_conflict_message =>
      'The backup has categories that already exist in your library. Keep to fold incoming series into the existing category, or delete to leave those series uncategorized instead.';

  @override
  String get category_conflict_keep => 'Keep — merge into existing category';

  @override
  String get category_conflict_delete => 'Delete — leave series uncategorized';

  @override
  String get source_conflict_title => 'Sources not found';

  @override
  String get source_conflict_message =>
      'These backup sources don\'t match an installed extension. Keep the original name (imported without a working source), or migrate to an installed extension so these series can be updated.';

  @override
  String get source_conflict_keep => 'Keep original name (no live source)';

  @override
  String get import_summary_title => 'Ready to import';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries new series, $updatedSeries existing series will be updated, and $newChapters new chapters will be added. Nothing already in your library will be removed.';
  }

  @override
  String get import_summary_confirm => 'Import';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Imported $newSeries new series, updated $updatedSeries existing, added $newChapters new chapters.';
  }

  @override
  String get roll_back => 'Roll back';

  @override
  String get roll_back_confirm_message =>
      'This restores your library to the safety snapshot taken right before this change, undoing everything it just did.';

  @override
  String get roll_back_done => 'Rolled back to the pre-change snapshot.';

  @override
  String get restoring_backup => 'Restoring your library…';

  @override
  String get roll_back_last_change => 'Roll back last change';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Snapshot from $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count recent changes available to roll back to';
  }

  @override
  String get delete_source_title => 'Delete a source & its manga';

  @override
  String get delete_source_subtitle =>
      'Pick a source and remove every manga it has in your library, along with their chapters, downloads, history and tracking.';

  @override
  String get delete_source_pick_title => 'Pick a source to delete';

  @override
  String get delete_source_empty => 'No sources found in your library.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Delete $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'This permanently deletes $mangaCount manga, $chapterCount chapters, $historyCount history entries and $updateCount update entries. Tracking links are kept. This cannot be undone except by rolling back.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Also remove the installed extension';

  @override
  String get delete_source_keep_history => 'Keep reading history';

  @override
  String get delete_source_keep_downloads => 'Keep download records';

  @override
  String get delete_source_button => 'Delete';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Deleted $mangaCount manga from $sourceName.';
  }

  @override
  String get merge_manga_title => 'Merge duplicate manga';

  @override
  String get merge_manga_subtitle =>
      'Finds manga with matching titles under the same source (e.g. after merging duplicate sources) and folds them into one, without deleting anything you\'d want kept.';

  @override
  String get merge_manga_none_found => 'No likely duplicate manga found.';

  @override
  String get merge_manga_pick_title => 'Possible duplicate manga';

  @override
  String get merge_manga_choose_primary_title =>
      'Which one should the others merge into?';

  @override
  String get merge_manga_choose_primary_message =>
      'Chapters, history and tracking from the other entries will be folded into whichever one you pick — nothing is deleted.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Merge';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Merged $count duplicate manga into $mangaName.';
  }

  @override
  String get merge_preview_title => 'Confirm merge';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters chapters found across the other entries. $duplicateChapters are duplicates and will be dropped (keeping whichever copy has reading progress); $keptChapters will be added. $duplicateTracks duplicate tracking link(s) will also be dropped.';
  }

  @override
  String get memory_overlay => 'Show memory usage';

  @override
  String get memory_overlay_subtitle =>
      'A live readout of what the app is holding. For measuring on the device rather than guessing: watch it while scrolling the library or reading a chapter.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Error reports';

  @override
  String get error_reports_subtitle =>
      'Errors the app caught, and a way to report them';

  @override
  String get error_reports_empty =>
      'Nothing has gone wrong. Errors the app catches are kept here so you can report them.';

  @override
  String get error_reports_likely_cause => 'Likely cause';

  @override
  String get error_reports_report => 'Report on GitHub';

  @override
  String get error_reports_banner => 'NodeLane Comics ran into an error';

  @override
  String get error_reports_banner_action => 'See it';

  @override
  String get error_reports_copy => 'Copy';

  @override
  String get error_reports_copied => 'Copied to the clipboard';

  @override
  String get error_reports_clear => 'Clear';

  @override
  String get error_reports_extension_failure =>
      'This came from an extension, not from NodeLane Comics. Extensions are written and maintained by whoever runs the repository you installed this source from, so a fix has to go there. The source name and what you were opening are the useful details to give them.';

  @override
  String get error_reports_already_reported => 'Already reported';

  @override
  String get error_reports_expected_failure =>
      'This one is usually the source or the network rather than the app: a link that expired, a server that was down, or a connection that dropped. Worth reporting only if it keeps happening on a source that works elsewhere.';

  @override
  String get share_unavailable_copied =>
      'Sharing isn\'t available on this platform, so it was copied to the clipboard instead.';

  @override
  String get onboarding_title => 'Welcome to NodeLane Comics';

  @override
  String get onboarding_libraries_body =>
      'Pick what you read and watch. The ones you leave out stay out of the navigation bar, and you can change this later under Appearance.';

  @override
  String get onboarding_nav_title => 'Your libraries';

  @override
  String get onboarding_nav_body =>
      'Keep a tab for each of them, or put them together behind one Library tab you can switch inside.';

  @override
  String get onboarding_nav_split => 'A tab each';

  @override
  String get onboarding_nav_merged => 'One Library tab';

  @override
  String get onboarding_nav_inside => 'Tapping Library swaps the bar for these';

  @override
  String get onboarding_next => 'Next';

  @override
  String get onboarding_restore => 'Restore a backup';

  @override
  String get onboarding_or_local => 'Or use files you already have';

  @override
  String get onboarding_local_folder => 'Add a folder';

  @override
  String onboarding_local_existing(Object count) {
    return '$count folders already set up';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime and novels all work. Each title goes to the right library based on what is inside it.';

  @override
  String get onboarding_local_scanning => 'Scanning the folder';

  @override
  String onboarding_local_found(Object count) {
    return '$count titles found';
  }

  @override
  String get onboarding_local_remove => 'Remove that folder';

  @override
  String get onboarding_local_in_downloads =>
      'That is the app\'s downloads folder. Adding it makes a second, local copy of a library the app already manages.';

  @override
  String get onboarding_local_empty =>
      'Nothing found. Pick the folder that holds your manga folders, not one manga.';

  @override
  String get onboarding_repo_failed =>
      'Couldn\'t read that repository. Check the address and your connection.';

  @override
  String get onboarding_repo_title => 'Add a source';

  @override
  String get onboarding_body =>
      'NodeLane Comics comes with no sources of its own. Add a repository and the extensions it holds become available to install and browse.';

  @override
  String get onboarding_add => 'Add repository';

  @override
  String get onboarding_skip => 'Skip for now';

  @override
  String get onboarding_continue => 'Continue';

  @override
  String get onboarding_later =>
      'You can add one later in Settings, under Browse.';

  @override
  String get onboarding_replay => 'Show the welcome screen';

  @override
  String get onboarding_replay_subtitle =>
      'Opens the first-run screen again, the one a new install starts on.';

  @override
  String get missing_source_check_title => 'Check for missing sources';

  @override
  String get missing_source_check_subtitle =>
      'Find library entries whose extension isn\'t installed - restoring a backup can leave entries pointing at a source you never installed on this device.';

  @override
  String get missing_source_check_none_found =>
      'Every library entry\'s source is installed.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources missing',
      one: '1 source missing',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'No $itemType sources are installed.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Add a repository under Browse, then install an extension for it.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
    );
    return 'You have $_temp0 for this, but only pinned ones are searched.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Pin one, or turn off \"Only include pinned sources\" in Browse settings.';

  @override
  String get global_search_all_nsfw =>
      'Every source you have for this is marked NSFW, and those are hidden.';

  @override
  String get global_search_all_nsfw_hint =>
      'Turn on NSFW sources in Browse settings to search them.';

  @override
  String get missing_source_check_result_message =>
      'These library entries point at a source that isn\'t installed on this device. Tap one to migrate it to an installed source, install the matching extension, or use \"Delete a source & its manga\" to remove them.';

  @override
  String get related_titles => 'Related';

  @override
  String get related_none => 'Nothing related was found for this title.';

  @override
  String get relation_adaptation => 'Adaptation';

  @override
  String get relation_sequel => 'Sequel';

  @override
  String get relation_prequel => 'Prequel';

  @override
  String get relation_parent => 'Parent story';

  @override
  String get relation_side_story => 'Side story';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Alternative version';

  @override
  String get auto_library_update => 'Automatic library updates';

  @override
  String get auto_library_update_subtitle =>
      'Check every entry in your library for new chapters when the app starts.';

  @override
  String get auto_library_update_never => 'Never';

  @override
  String get auto_library_update_12_hours => 'Every 12 hours';

  @override
  String get auto_library_update_daily => 'Daily';

  @override
  String get auto_library_update_2_days => 'Every 2 days';

  @override
  String get auto_library_update_weekly => 'Weekly';

  @override
  String get auto_library_update_wifi_only => 'Only on Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Skip the scheduled update while on mobile data.';

  @override
  String get padding => 'Padding';

  @override
  String get page_mode => 'Page mode';

  @override
  String get single_page => 'Single page';

  @override
  String get double_page => 'Double page';

  @override
  String get speed => 'Speed';

  @override
  String get theme_dark => 'Dark';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_black => 'Black';

  @override
  String get theme_sepia => 'Sepia';

  @override
  String get decrease => 'Decrease';

  @override
  String get increase => 'Increase';

  @override
  String get chapter_swipe_actions => 'Chapter swipe actions';

  @override
  String get chapter_swipe_start => 'Swipe right';

  @override
  String get chapter_swipe_end => 'Swipe left';

  @override
  String get chapter_swipe_toggle_bookmark => 'Toggle bookmark';

  @override
  String get chapter_swipe_toggle_read => 'Toggle read';

  @override
  String get chapter_swipe_download => 'Download';

  @override
  String get chapter_swipe_disabled => 'Disabled';

  @override
  String get update_errors => 'Update errors';

  @override
  String get no_update_errors => 'No update errors';

  @override
  String get clear_all => 'Clear all';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get previous_episode => 'Previous episode';

  @override
  String get clear_logs => 'Clear logs';

  @override
  String get bold => 'Bold';

  @override
  String get italic => 'Italic';

  @override
  String get color_yellow => 'Yellow';

  @override
  String get color_cyan => 'Cyan';

  @override
  String get color_green => 'Green';

  @override
  String get color_orange => 'Orange';

  @override
  String get continue_watching => 'Continue Watching';

  @override
  String get search_your_anime => 'Search your anime';

  @override
  String get category => 'Category';

  @override
  String get hidden_categories => 'Hidden categories';

  @override
  String get new_category => 'New category';

  @override
  String get local => 'Local';

  @override
  String get tv_home_rows => 'Rows';

  @override
  String get genre_rows => 'Genre rows';

  @override
  String get share_backup_file => 'Share NodeLane Comics backup file';

  @override
  String get close => 'Close';

  @override
  String get migrate_source => 'Migrate source';

  @override
  String get cloudflare_bypass_proxy => 'Cloudflare bypass proxy';

  @override
  String get custom_doh_url => 'Custom DoH URL';

  @override
  String get custom_doh_url_helper => 'Must be an https DoH (JSON) endpoint';

  @override
  String get anime_only_tv_layout => 'Anime-only TV layout';

  @override
  String get anime_only_beta => 'Anime only (beta)';

  @override
  String get tv_home_beta => 'TV home (beta)';

  @override
  String get tv_player_beta => 'TV player (beta)';

  @override
  String get network_settings => 'Network';

  @override
  String get reader_page_layout => 'Page layout';

  @override
  String get reader_continuous_options => 'Continuous reading';

  @override
  String get reader_default_mode_hint =>
      'The default reading mode applies to titles without an individual mode set while reading.';

  @override
  String get extension_service => 'Extension service';

  @override
  String get extension_service_description =>
      'Manage the extension runtime and proxy address.';

  @override
  String get proxy_address => 'Proxy address';

  @override
  String get checking_runtime_status => 'Checking status…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + random delay';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Add downloads from a title’s chapter list.';

  @override
  String get download_queue_order_hint => 'Drag handles to reorder';

  @override
  String get download_queue_empty => 'No downloads queued';

  @override
  String get download_queue_actions => 'Download actions';

  @override
  String get download_queue_cancel_chapter => 'Cancel this chapter’s download';

  @override
  String get download_queue_cancel_series =>
      'Cancel all downloads for this title';

  @override
  String get download_queue_start => 'Start downloads';

  @override
  String get download_queue_retry => 'Retry downloads';

  @override
  String get download_queue_active => 'Downloading';

  @override
  String get download_queue_waiting => 'Waiting to download';

  @override
  String get download_queue_failed => 'Download failed';

  @override
  String get cf_proxy_helper =>
      'FlareSolverr / Byparr endpoint. Leave empty to disable.';

  @override
  String get mobile_navigation_description =>
      'Drag to reorder. Manga, anime and novels share the Library tab. The first visible item opens at launch. Browse and More stay visible; extra tabs appear under More.';

  @override
  String get text_align_justify => 'Justify';

  @override
  String get novel_session_modes_hint =>
      'Set reading mode and single or double pages while reading a title.';

  @override
  String get tts_languages_failed =>
      'Could not load languages from the speech engine.';

  @override
  String get tts_languages_empty =>
      'The speech engine returned no languages. Your saved selection is kept.';

  @override
  String get tts_language_unavailable =>
      'This saved language is not in the device’s current list.';

  @override
  String get tts_apply_failed =>
      'Could not apply this setting to the speech engine. You can retry.';

  @override
  String get player_controls => 'Controls';

  @override
  String get audio_channel_auto => 'Automatic';

  @override
  String get audio_channel_auto_safe => 'Automatic (safe)';

  @override
  String get audio_channel_mono => 'Mono';

  @override
  String get audio_channel_stereo => 'Stereo';

  @override
  String get audio_channel_reverse_stereo => 'Reverse stereo';

  @override
  String get mpv_bundled_config_hint =>
      'Restore the configuration, scripts and shaders included with the app. Files with the same names will be overwritten.';

  @override
  String get mpv_restore_bundled => 'Restore bundled configuration';

  @override
  String get mpv_restore_confirm =>
      'Restore the bundled MPV configuration? Existing configuration, scripts and shaders with the same names will be overwritten. Other files will be kept.';

  @override
  String get player_operation_incomplete =>
      'The operation could not be completed. Check file access and try again.';

  @override
  String get custom_buttons_empty_hint =>
      'Add a player button with a label and a press action.';

  @override
  String get custom_button_primary => 'Default button';

  @override
  String get show_password => 'Show password';

  @override
  String get hide_password => 'Hide password';

  @override
  String get tracking_accounts_empty =>
      'Connect a service in Tracking settings to manage its entries.';

  @override
  String get tracking_entries_empty =>
      'No tracked entries for this media type. Add tracking from a title’s detail page.';

  @override
  String get change_tracking_match => 'Change matching title';

  @override
  String get remove_tracking => 'Remove tracking';

  @override
  String remove_tracking_confirm(String title) {
    return 'Remove the tracking link for “$title”? The entry in the tracking service will be kept.';
  }

  @override
  String get tracking_refresh_required =>
      'The tracking state could not be confirmed. Refresh before making another change.';

  @override
  String get tracking_entry_unlinked =>
      'This record is not linked to a local title, so it cannot be edited here.';

  @override
  String get backup_selection_shared =>
      'Changes to these selections are saved immediately and also apply to automatic backups.';

  @override
  String get library_snapshot_history => 'Restore a library snapshot';

  @override
  String get library_snapshot_empty => 'No safety snapshots available.';

  @override
  String get library_snapshot_restore_message =>
      'Current data will be replaced by this snapshot. Changes made since then will be lost. Deleted downloads cannot be restored. Available safety snapshots will be cleared after success.';

  @override
  String get library_maintenance_working => 'Updating library…';

  @override
  String get library_safety_snapshot_note =>
      'A safety snapshot will be saved before this operation. It does not include downloaded files.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Library entries: $mangaCount. Chapters: $chapterCount. History entries: $historyCount. Updates: $updateCount.\n\nChoose what to keep below.';
  }

  @override
  String get library_delete_pick_message =>
      'Choose a source to review its contents and deletion options.';

  @override
  String get mobile_categories_hint =>
      'Drag to reorder. Open a category to rename it or change its visibility and updates.';

  @override
  String get mobile_category_visible => 'Show in library';

  @override
  String get mobile_category_hidden => 'Hidden from library';

  @override
  String get mobile_category_updates => 'Include in library updates';

  @override
  String get statistics_watched => 'Watched';

  @override
  String get calendar_month => 'Month';

  @override
  String get calendar_two_weeks => '2 weeks';

  @override
  String get calendar_week => 'Week';

  @override
  String get calendar_show_all_dates => 'Show all dates';

  @override
  String get update_check_no_result =>
      'No installable update found. You can try again later.';

  @override
  String get release_notes => 'Release notes';

  @override
  String get no_release_notes => 'No release notes provided.';

  @override
  String get downloading_update => 'Downloading update…';

  @override
  String get preparing_installation => 'Preparing installation…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Choose what to read. You can change this later.';

  @override
  String get onboarding_content_title => 'Start reading';

  @override
  String get onboarding_mobile_sources_body =>
      'Choose a way to start, or add content later.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'Results for “$query”';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Search for the destination title.';

  @override
  String get migration_original_item => 'Current item';

  @override
  String get migration_target_item => 'Selected item';

  @override
  String get migration_partial_failure =>
      'The operation did not finish. Some changes may have been saved. Check this item in your library before trying again.';

  @override
  String get migration_no_categories =>
      'No categories. You can add this item without a category.';

  @override
  String get mass_migration_select_source => 'Choose the current source';

  @override
  String get mass_migration_select_all => 'Select all';

  @override
  String get mass_migration_deselect_all => 'Deselect all';

  @override
  String get mass_migration_needs_review => 'Review incomplete migrations';

  @override
  String get bookshelf_actions => 'Bookshelf actions';

  @override
  String get bookshelf_ignore_filters => 'Ignore filters when searching';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Search all works in this category, including those hidden by filters.';

  @override
  String get bookshelf_stop_update => 'Stop library update';

  @override
  String bookshelf_selected_count(int count) {
    return '$count works selected';
  }

  @override
  String get bookshelf_remove_library => 'Remove from bookshelf';

  @override
  String get bookshelf_remove_library_hint =>
      'Removes favorites. Local imports also lose their library and reading records.';

  @override
  String get bookshelf_remove_downloads => 'Delete downloaded files';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Removes downloaded files while keeping work information.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Also deletes selected local imported files and removes their library records. These files cannot be recovered here.';

  @override
  String get bookshelf_remove_incomplete =>
      'The operation did not finish. Some works or files may have been processed. Close this dialog and check your bookshelf and downloads before continuing.';

  @override
  String get bookshelf_processing => 'Processing…';

  @override
  String get bookshelf_mark_read => 'Mark read';

  @override
  String get bookshelf_mark_unread => 'Mark unread';

  @override
  String get bookshelf_select_all => 'Select all';

  @override
  String get bookshelf_invert_selection => 'Invert selection';

  @override
  String get bookshelf_settings => 'Bookshelf settings';

  @override
  String get bookshelf_settings_live =>
      'Filter, sort and display changes take effect immediately.';

  @override
  String get bookshelf_filter_any => 'Any';

  @override
  String get bookshelf_filter_include => 'Include';

  @override
  String get bookshelf_filter_exclude => 'Exclude';

  @override
  String get bookshelf_all_sources => 'All sources';

  @override
  String bookshelf_sources_selected(int count) {
    return '$count sources selected';
  }

  @override
  String get bookshelf_sort_ascending => 'Ascending';

  @override
  String get bookshelf_sort_descending => 'Descending';

  @override
  String get bookshelf_layout => 'Bookshelf layout';

  @override
  String get bookshelf_sources_hint =>
      'Select none to show all sources. Changes apply when you tap Filter.';

  @override
  String get bookshelf_choose_files => 'Choose files';

  @override
  String get bookshelf_import_wait =>
      'Choose a file in the picker and wait for the import to finish.';

  @override
  String get bookshelf_import_incomplete =>
      'Import did not finish. Some files may already be in your bookshelf. Close this dialog and check before importing again.';

  @override
  String get bookshelf_categories_replace =>
      'Saving assigns these categories to every selected work, replacing their previous categories.';

  @override
  String get bookshelf_categories_hint =>
      'Choose one or more categories, or leave the selection empty to assign none.';

  @override
  String get bookshelf_categories_hidden =>
      'Existing hidden categories are kept for this work.';

  @override
  String get bookshelf_categories_incomplete =>
      'Categories could not be saved completely. Close this dialog and check the bookshelf before trying again.';

  @override
  String get bookshelf_categories_none_visible =>
      'No categories are available here. Open category management to review them.';

  @override
  String get bookshelf_manage_categories => 'Manage categories';

  @override
  String get manga_actions => 'Comic actions';

  @override
  String get manga_download_scope => 'Download chapters';

  @override
  String get manga_download_scope_hint =>
      'Choose chapters within the current filters. Downloaded chapters are skipped.';

  @override
  String get manga_download_scope_empty =>
      'No chapters match the current filters. Close this menu and adjust the chapter filters.';

  @override
  String get manga_action_incomplete =>
      'The action did not finish. Check the current state before trying again.';

  @override
  String get chapter_settings => 'Chapter settings';

  @override
  String get chapter_settings_live =>
      'Filter and sort changes apply immediately.';

  @override
  String get chapter_scanlators_all => 'Show all scanlator groups';

  @override
  String get chapter_scanlators_hint =>
      'Select groups to hide their chapters. Changes apply when you tap Filter.';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count scanlator groups hidden';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count chapters selected';
  }

  @override
  String get chapter_add_bookmark => 'Bookmark';

  @override
  String get chapter_remove_bookmark => 'Unbookmark';

  @override
  String get chapter_read_following => 'Read below';

  @override
  String get chapter_delete_records => 'Delete chapter records';

  @override
  String get chapter_delete_local_hint =>
      'Removes the selected chapter records and reading progress. Original local archives are kept; downloaded copies are cleaned up.';

  @override
  String get chapter_delete_last_hint =>
      'These are all chapters in this comic. Deleting them also removes the comic from your bookshelf.';

  @override
  String get chapter_action_incomplete =>
      'The action did not finish. Some changes may already be saved. Close and check the chapters and downloads before continuing.';

  @override
  String get reader_display_scope =>
      'Reading mode and manual page layout apply to this comic. Choose a change to return to reading.';

  @override
  String get reader_display_single_only =>
      'Horizontal continuous reading uses single pages.';

  @override
  String get reader_display_manual_pages =>
      'Changing page layout turns off automatic double page for all comics.';

  @override
  String get reader_display_crop_scope => 'Applies to all comics.';

  @override
  String get reader_chapter_locate => 'Locate current chapter';

  @override
  String get reader_chapter_search => 'Search chapters or scanlators';

  @override
  String get reader_chapter_scope =>
      'Uses the chapter filters and sort order from comic details. Bookmarks are saved immediately.';

  @override
  String get reader_chapter_current_hidden =>
      'The chapter you are reading is outside the current filters.';

  @override
  String get reader_chapter_current => 'Reading now';

  @override
  String get reader_chapter_read => 'Read';

  @override
  String get reader_chapter_bookmark_failed =>
      'Bookmark save could not be confirmed. Close the list and check its current state.';

  @override
  String get reader_image_actions => 'Image actions';

  @override
  String get reader_image_original =>
      'Uses the full original page, without translation, cropping or reader color filters.';

  @override
  String get reader_image_save_ios =>
      'Save to the Pictures folder in the current app storage location.';

  @override
  String get reader_image_save_android =>
      'Save to the device’s Pictures/nodelane-comics folder.';

  @override
  String get reader_image_share => 'Open the system share sheet.';

  @override
  String get reader_image_cover =>
      'Change this comic’s cover after confirmation.';

  @override
  String get reader_image_cover_limit =>
      'Cover images must be smaller than 5 MB. Saving and sharing remain available.';

  @override
  String get reader_image_action_failed =>
      'The action could not be confirmed. Close this menu and check the result before trying again.';

  @override
  String get reader_settings_book_scope =>
      'These settings apply only to this comic.';

  @override
  String get reader_settings_global_scope =>
      'These settings apply to all comics and save immediately.';

  @override
  String get reader_filters => 'Image filters';

  @override
  String get reader_filter_scope =>
      'Applies to all comics. Changes the reading display without modifying original images.';

  @override
  String get reader_auto_scroll_pause =>
      'Scrolling pauses while settings are open.';

  @override
  String get manga_synopsis => 'Synopsis';

  @override
  String manga_author(String author) {
    return 'Author: $author';
  }

  @override
  String get manga_continue_reading => 'Continue reading';

  @override
  String get reader_settings_title => 'Reader settings';

  @override
  String get reader_picker_book_scope => 'Only for this comic';

  @override
  String get reader_picker_global_scope => 'Applies to all comics';

  @override
  String get reader_picker_apply_hint =>
      'Tap to save and return to the previous level.';

  @override
  String get reader_scale_fit_screen_hint => 'Fit the whole page on screen';

  @override
  String get reader_scale_stretch_hint => 'Fill the reading area';

  @override
  String get reader_scale_fit_width_hint => 'Fit the page to the width';

  @override
  String get reader_scale_fit_height_hint => 'Fit the page to the height';

  @override
  String get source_filter_active => 'Applied';

  @override
  String get source_filter_apply => 'Apply filters';

  @override
  String get source_filter_scope => 'Filters apply to this website only.';

  @override
  String get source_filter_apply_hint =>
      'Apply filters to use your selections.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Genres',
      'author': 'Author',
      'artist': 'Artist',
      'title': 'Title',
      'year': 'Year',
      'tags': 'Tags',
      'format': 'Format',
      'publisher': 'Publisher',
      'relevance': 'Relevance',
      'rating': 'Rating',
      'views': 'Views',
      'random': 'Random',
      'all': 'All',
      'none': 'None',
      'action': 'Action',
      'adventure': 'Adventure',
      'comedy': 'Comedy',
      'drama': 'Drama',
      'fantasy': 'Fantasy',
      'romance': 'Romance',
      'science_fiction': 'Science fiction',
      'slice_of_life': 'Slice of life',
      'mystery': 'Mystery',
      'horror': 'Horror',
      'psychological': 'Psychological',
      'historical': 'Historical',
      'sports': 'Sports',
      'supernatural': 'Supernatural',
      'school_life': 'School life',
      'tragedy': 'Tragedy',
      'shounen': 'Shounen',
      'shoujo': 'Shoujo',
      'seinen': 'Seinen',
      'josei': 'Josei',
      'isekai': 'Isekai',
      'martial_arts': 'Martial arts',
      'mecha': 'Mecha',
      'music': 'Music',
      'doujinshi': 'Doujinshi',
      'trending': 'Trending',
      'new': 'New',
      'adult_content': 'Adult content',
      'only': 'Only',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'More display options';

  @override
  String get bookshelf_more_display_hint => 'Badges, sources and categories';

  @override
  String get bookshelf_download_count => 'Download count';

  @override
  String get bookshelf_source_global_hint =>
      'Source visibility uses the shared display preference.';

  @override
  String get bookshelf_select_entries => 'Select works';

  @override
  String get bookshelf_search_options => 'Search options';

  @override
  String get bookshelf_empty_hint =>
      'Collect works from sources or import local files.';

  @override
  String get bookshelf_no_match_hint =>
      'Try other keywords or adjust the current filters.';

  @override
  String get bookshelf_clear_query => 'Clear keywords';

  @override
  String get bookshelf_view_selection => 'View selected works';

  @override
  String get bookshelf_import_formats =>
      'Choose a local file to add it to your bookshelf.';

  @override
  String get bookshelf_import_canceled_hint =>
      'You can choose again after cancelling the file picker.';

  @override
  String get bookshelf_browse_sources => 'Browse sources';

  @override
  String get bookshelf_empty_title => 'Your bookshelf is empty';

  @override
  String get bookshelf_no_match_title => 'No matching works';

  @override
  String get bookshelf_mark_watched => 'Mark watched';

  @override
  String get bookshelf_mark_unwatched => 'Mark unwatched';

  @override
  String get nodelane_account => 'NodeLane account';

  @override
  String get nodelane_sign_in => 'Sign in to NodeLane';

  @override
  String get nodelane_account_intro =>
      'View your account, subscription and translation quota';

  @override
  String get nodelane_login_action => 'Continue to sign in';

  @override
  String get nodelane_login_browser =>
      'Sign in through the system browser, then return to the app';

  @override
  String get nodelane_account_id => 'Account ID';

  @override
  String get nodelane_account_init_error =>
      'Account storage is unavailable. Restart the app and try again.';

  @override
  String get nodelane_account_refresh_error =>
      'Could not refresh account information';

  @override
  String get nodelane_account_auth_error =>
      'Your session has expired. Sign in again';

  @override
  String get nodelane_account_unknown =>
      'Subscription information is unavailable';

  @override
  String get nodelane_account_current => 'Current subscription';

  @override
  String get nodelane_account_free => 'Free account';

  @override
  String get nodelane_account_no_subscription => 'No active subscription';

  @override
  String get nodelane_account_active => 'Active';

  @override
  String get nodelane_account_expired => 'Expired';

  @override
  String get nodelane_account_expiry => 'Valid until';

  @override
  String get nodelane_account_renewal => 'Renewal';

  @override
  String get nodelane_renewal_auto => 'Automatic renewal';

  @override
  String get nodelane_renewal_manual => 'Manual renewal';

  @override
  String get nodelane_renewal_stopped => 'Automatic renewal stopped';

  @override
  String get nodelane_renewal_gift => 'Gift membership';

  @override
  String get nodelane_renewal_attention =>
      'Check your renewal status on the website';

  @override
  String get nodelane_next_billing => 'Next billing date';

  @override
  String get nodelane_billing_unavailable =>
      'Renewal information is unavailable';

  @override
  String get nodelane_manage_account => 'Manage on website';

  @override
  String get nodelane_view_plans => 'View subscription plans';

  @override
  String get nodelane_translation_quota => 'Translation quota';

  @override
  String get nodelane_quota_free => 'Free quota';

  @override
  String get nodelane_quota_subscription => 'Subscription quota';

  @override
  String get nodelane_quota_purchase => 'Purchased quota';

  @override
  String get nodelane_quota_details => 'View quota details';

  @override
  String get nodelane_quota_expanded => 'Quota details';

  @override
  String get nodelane_quota_unlimited => 'Unlimited';

  @override
  String get nodelane_quota_not_subscribed => 'Not subscribed';

  @override
  String get nodelane_quota_unknown => 'Unavailable';

  @override
  String get nodelane_quota_used => 'Used';

  @override
  String get nodelane_quota_reserved => 'In progress';

  @override
  String get nodelane_quota_reset => 'Next reset';

  @override
  String get nodelane_quota_expiry => 'Next expiry';

  @override
  String get nodelane_quota_no_expiry => 'No expiry date';

  @override
  String get nodelane_quota_reservation_note =>
      'Pages in progress are already deducted from the available quota';

  @override
  String nodelane_quota_available(int count) {
    return '$count pages remaining';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count pages';
  }

  @override
  String get nodelane_sign_out => 'Sign out';

  @override
  String get nodelane_sign_out_confirm =>
      'Signing out pauses official translation on this device. Your library and reading progress are kept.';

  @override
  String get settings_search_hint => 'Search settings';

  @override
  String get settings_frequent => 'Frequently used';

  @override
  String get settings_reading_translation => 'Reading and translation';

  @override
  String get settings_app_preferences => 'App preferences';

  @override
  String get settings_data_management => 'Data and management';

  @override
  String get settings_more_tools => 'More tools';

  @override
  String get settings_more_tools_hint => 'Categories, statistics and calendar';

  @override
  String get settings_appearance_interface => 'Appearance and interface';

  @override
  String get settings_security_privacy => 'Security and privacy';

  @override
  String get settings_source_preferences => 'Source settings';

  @override
  String get settings_about_help => 'About and help';

  @override
  String get settings_storage_backup => 'Storage and backup';

  @override
  String settings_pending_downloads(int count) {
    return '$count pending';
  }

  @override
  String get settings_translation_language => 'Translation language';

  @override
  String get settings_translation_scope =>
      'Used in the reader and web page translation';

  @override
  String get settings_immediate_choice => 'Changes apply immediately';

  @override
  String get settings_translation_init_error =>
      'Translation settings are unavailable. Restart the app and try again.';

  @override
  String get settings_local_cache => 'Local cache';

  @override
  String get settings_chapter_cache => 'Chapter and episode cache';

  @override
  String get settings_cover_cache => 'Cover cache';

  @override
  String get settings_translation_cache => 'Translated image cache';

  @override
  String get settings_translation_cache_hint =>
      'Keep translation records and retrieve translated images again when needed';

  @override
  String get settings_cache_clear => 'Clear';

  @override
  String get settings_translation_cache_done =>
      'Translated image cache cleared; translation records kept';

  @override
  String settings_cache_confirmation(String name) {
    return 'Clear $name? Cached content can be retrieved again. Library entries will be kept.';
  }

  @override
  String get settings_advanced_options => 'Advanced options';

  @override
  String get settings_manga_reader => 'Manga Reader';

  @override
  String get settings_novel_reader => 'Novel Reader';

  @override
  String get settings_downloads => 'Download settings';

  @override
  String get onboarding_welcome => 'Welcome to';

  @override
  String get onboarding_reading_content => 'Reading content';

  @override
  String get onboarding_choose_one => 'Choose at least one';

  @override
  String get onboarding_restore_hint => 'Restore your library from a backup';

  @override
  String get onboarding_browse_hint => 'Find titles on supported websites';

  @override
  String get onboarding_import_folder => 'Import a local folder';

  @override
  String get onboarding_import_folder_hint =>
      'Read manga, novels and anime on your device';

  @override
  String get onboarding_third_party => 'Add a third-party repository';

  @override
  String get onboarding_third_party_hint =>
      'Use a repository address you already have';

  @override
  String get onboarding_repository_hint =>
      'Enter the address provided by the repository.';

  @override
  String get onboarding_repository_address => 'Address';

  @override
  String get onboarding_repository_address_hint => 'Enter repository address';

  @override
  String get onboarding_add_repository => 'Add repository';

  @override
  String get onboarding_start => 'Get started';

  @override
  String get onboarding_open_library => 'Open library';

  @override
  String get onboarding_view_imports => 'View imported content';

  @override
  String get onboarding_view_folders => 'View folders';

  @override
  String get notice_backup_created => 'Backup created';

  @override
  String get notice_backup_ready => 'Save or share the backup file.';

  @override
  String get notice_backup_restored => 'Backup restored';

  @override
  String get notice_backup_unsupported =>
      'This backup format is not supported.';

  @override
  String get notice_verification_required => 'Website verification required';

  @override
  String get notice_verification_hint =>
      'Complete verification to continue browsing.';

  @override
  String get notice_verify => 'Verify website';

  @override
  String get notice_action_incomplete =>
      'The action did not finish. Check its result before trying again.';

  @override
  String get notice_library_updating => 'Updating library';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'Checked $current / $total titles';
  }

  @override
  String get notice_library_failed => 'Some titles could not be updated';

  @override
  String get notice_import_completed => 'Import completed';

  @override
  String get notice_operation_incomplete => 'Action incomplete';

  @override
  String get subtitle_service => 'Online subtitle service';

  @override
  String get subtitle_service_mode => 'Subtitle source';

  @override
  String get subtitle_service_disabled => 'Off · clear saved credentials';

  @override
  String get subtitle_personal_key => 'My Wyzie key';

  @override
  String get subtitle_custom_service => 'My subtitle service';

  @override
  String get subtitle_key => 'Wyzie API Key';

  @override
  String get subtitle_key_hint =>
      'Enter your own Wyzie key. It stays on this device and is not included in app backups.';

  @override
  String get subtitle_get_key => 'Get a personal key';

  @override
  String get subtitle_service_address => 'Subtitle search URL';

  @override
  String get subtitle_service_token => 'Service access token (optional)';

  @override
  String get subtitle_custom_hint =>
      'Use the full HTTPS search URL of a Wyzie-compatible service, including its path (for example, /search). Enter an access token only if your service requires one.';

  @override
  String get subtitle_service_off_hint =>
      'Online subtitle search is off. Embedded, source-provided and local subtitles remain available.';

  @override
  String get subtitle_setup_required =>
      'Choose a subtitle service before searching.';

  @override
  String get subtitle_invalid_key => 'Enter a key without spaces.';

  @override
  String get subtitle_invalid_address =>
      'Use a complete HTTPS URL without a query, fragment or embedded credentials.';

  @override
  String get subtitle_invalid_token =>
      'The access token cannot contain spaces.';

  @override
  String get subtitle_storage_failed =>
      'Could not read or save subtitle settings. Please try again.';

  @override
  String get subtitle_auth_failed =>
      'The subtitle service refused access. Check your key or service token.';

  @override
  String get subtitle_quota_exhausted =>
      'The subtitle service quota is exhausted. Check your account with that service.';

  @override
  String get subtitle_network_failed =>
      'Could not reach the subtitle service. Please try again.';

  @override
  String get subtitle_response_invalid =>
      'The subtitle service returned an unsupported response or file.';

  @override
  String get detail_loading_chapters => 'Loading chapters…';

  @override
  String get reader_opening_chapter => 'Opening chapter';

  @override
  String get reader_open_chapter => 'Open chapter';

  @override
  String get reader_loading_pages => 'Getting chapter images…';

  @override
  String get reader_loading_pages_hint =>
      'Reading will start automatically when ready.';

  @override
  String get reader_loading_failed => 'Could not load this chapter';

  @override
  String get reader_loading_retry_hint =>
      'Check your connection and try again.';

  @override
  String get reader_no_pages => 'No images found for this chapter';

  @override
  String get reader_loading_previous => 'Loading previous chapter…';

  @override
  String get reader_previous_failed => 'Could not load the previous chapter';

  @override
  String get reader_reached_start => 'You have reached the first chapter';

  @override
  String get reader_loading_next => 'Loading next chapter…';

  @override
  String get reader_next_failed => 'Could not load the next chapter';

  @override
  String get reader_image_loading => 'Loading image…';

  @override
  String get reader_image_failure_hint => 'You can keep reading other pages.';

  @override
  String get comic_paged => 'Page by page';

  @override
  String get comic_scroll => 'Scroll down';

  @override
  String get comic_book_scope =>
      'Applies only to this book · changes save immediately';

  @override
  String get comic_defaults_title => 'Defaults & habits';

  @override
  String get comic_defaults_hint =>
      'Defaults apply to fields you have not customized for a book.';

  @override
  String get comic_habits_hint => 'These habits apply to every comic.';

  @override
  String get comic_turn => 'Swipe to the next page';

  @override
  String get comic_left => 'Left';

  @override
  String get comic_right => 'Right';

  @override
  String get comic_up => 'Up';

  @override
  String get comic_fit => 'Page fit';

  @override
  String get comic_fit_contain => 'Whole page';

  @override
  String get comic_fit_width => 'Fit width';

  @override
  String get comic_fit_height => 'Fit height';

  @override
  String get comic_layout => 'Page layout';

  @override
  String get comic_auto => 'Auto';

  @override
  String get comic_layout_hint =>
      'Auto shows a spread when there is enough width.';

  @override
  String get comic_width => 'Content width';

  @override
  String get comic_full => 'Full';

  @override
  String get comic_comfortable => 'Comfortable';

  @override
  String get comic_narrow => 'Narrow';

  @override
  String get comic_gap => 'Page spacing';

  @override
  String get comic_no_gap => 'Seamless';

  @override
  String get comic_small_gap => 'Small';

  @override
  String get comic_image_title => 'Fine-tune image';

  @override
  String get comic_image_hint => 'Crop and tone affect only this book.';

  @override
  String get comic_wide => 'Wide pages';

  @override
  String get comic_intact => 'Keep whole';

  @override
  String get comic_split => 'Split';

  @override
  String get comic_rotate => 'Rotate';

  @override
  String get comic_wide_hint =>
      'Splitting follows the page-turn direction. Applies to single-page reading.';

  @override
  String get comic_cover => 'One cover per chapter';

  @override
  String get comic_effects_reset => 'Reset image adjustments';

  @override
  String get comic_book_reset => 'Restore book defaults';

  @override
  String get comic_book_reset_hint =>
      'Clears this book’s custom reading settings. Translation is unchanged.';

  @override
  String get comic_canvas => 'Reader background';

  @override
  String get comic_system => 'System';

  @override
  String get comic_black => 'Black';

  @override
  String get comic_gray => 'Gray';

  @override
  String get comic_paper => 'Paper';

  @override
  String get comic_tap => 'Tap to turn pages';

  @override
  String get comic_tap_hint =>
      'Tap the edges to move; tap the center to show controls.';

  @override
  String get comic_scroll_start => 'Start auto scroll';

  @override
  String get comic_scroll_pause => 'Pause auto scroll';

  @override
  String get comic_scroll_speed => 'Scroll speed';

  @override
  String get comic_scroll_hint =>
      'Starts when this panel closes. Pauses when the app leaves the foreground.';

  @override
  String get comic_save_failed => 'Could not save. Please try again.';

  @override
  String get comic_reading => 'Reading';

  @override
  String get comic_chapter_habits_hint =>
      'Chapter list habits apply to all books.';

  @override
  String get browser_title => 'Browser';

  @override
  String get translation_image_display => 'Image display';

  @override
  String get translation_display_hint =>
      'Show existing translations first. Keep the original when no translation is available.';

  @override
  String get translation_sign_in_required => 'Sign in to enable translation';

  @override
  String get translation_sign_in_hint =>
      'After signing in, switch to translated images to translate automatically.';

  @override
  String get translation_automatic => 'Automatic translation';

  @override
  String get translation_original_hint =>
      'Showing originals. Switch to translated images to translate automatically.';

  @override
  String get translation_window_hint =>
      'Process current and upcoming images only while showing translations.';

  @override
  String get translation_channel => 'Translation channel';

  @override
  String get translation_no_images =>
      'No translatable images found on this page yet';

  @override
  String get translation_waiting_image => 'Waiting for the current image';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues images need attention',
      one: ' · 1 image needs attention',
      zero: '',
    );
    return 'Completed $complete / $total images$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'Touch and hold an image for more actions, including translating it again.';

  @override
  String get translation_title => 'Manga translation';

  @override
  String get translation_system_sign_in => 'Sign in using your system browser';

  @override
  String get translation_target_language => 'Target language';

  @override
  String get translation_clear_cache => 'Clear translated image cache';

  @override
  String get translation_cache_hint =>
      'Keep translation records and retrieve results again when needed.';

  @override
  String get translation_saved_read_failed =>
      'Could not load the saved translation';

  @override
  String get translation_read_failed => 'Could not load the translated image';

  @override
  String get operation_retry => 'The action did not finish. Please try again.';

  @override
  String get translation_original => 'Original';

  @override
  String get translation_translated => 'Translated';

  @override
  String get translation_regenerate_image => 'Translate this image again';

  @override
  String get translation_read_image => 'Reload translated image';

  @override
  String get translation_image_actions => 'More image actions';

  @override
  String get translation_processing => 'Processing';

  @override
  String get translation_reading => 'Loading translated image';

  @override
  String get translation_waiting => 'Waiting for translation';

  @override
  String get translation_preparing => 'Preparing translation';

  @override
  String get translation_uploading => 'Uploading original';

  @override
  String get translation_running => 'Translating';

  @override
  String get translation_uncertain => 'Status needs verification';

  @override
  String get translation_failed => 'Translation failed';

  @override
  String get translation_verify => 'Verify';

  @override
  String get translation_reread => 'Reload';

  @override
  String get browser_back => 'Back';

  @override
  String get browser_translation => 'Web page translation';

  @override
  String get browser_new_tab_action => 'Open new tab';

  @override
  String get browser_current_tab => 'Current';

  @override
  String get browser_close_tab => 'Close tab';

  @override
  String get browser_new_tab => 'New tab';

  @override
  String get browser_page => 'Web page';

  @override
  String get browser_unopened => 'No page opened yet';

  @override
  String get browser_address_hint => 'Enter or paste a URL';

  @override
  String get browser_invalid_address => 'Enter a valid URL';

  @override
  String get browser_clear_address => 'Clear URL';

  @override
  String get browser_paste_address => 'Paste URL';

  @override
  String get browser_open_address => 'Open URL';

  @override
  String browser_tab_count(int count) {
    return 'Tabs · $count';
  }

  @override
  String get browser_load_failed => 'Could not open this page';

  @override
  String get browser_load_failed_hint => 'Check your connection and the URL.';

  @override
  String get browser_edit_address => 'Edit URL';

  @override
  String get browser_clear_cookies_confirm =>
      'Clear sign-in sessions for all websites?';

  @override
  String get browser_clear_cookies_hint =>
      'Websites in all tabs may require you to sign in again.';

  @override
  String get browser_clear_cookies_action => 'Clear sign-in sessions';

  @override
  String get browser_tab_limit =>
      'You can keep up to 12 tabs open. Close one first.';

  @override
  String get browser_forward => 'Forward';

  @override
  String get browser_clear_all_cookies => 'Clear all website sign-in sessions';

  @override
  String get browser_clear_failed =>
      'Could not clear sessions. Please try again.';

  @override
  String get browser_save_failed => 'Could not save tabs. Please try again.';

  @override
  String get browser_tabs_full => '12 tabs are already open';

  @override
  String get browser_no_tabs => 'No open tabs yet';

  @override
  String get browser_close_failed =>
      'Could not save tabs. Tap close again to retry.';

  @override
  String get source_pinned_websites => 'Pinned websites';

  @override
  String get manage => 'Manage';

  @override
  String get translation_settings_hint =>
      'Automatic translation, target language and channel';

  @override
  String get translation_show_original => 'Tap to show the original';

  @override
  String get translation_show_translated => 'Tap to show the translation';

  @override
  String get source_display => 'Display';

  @override
  String get source_cover_title => 'Cover and title';

  @override
  String get source_cover_only => 'Cover only';

  @override
  String get source_save_search => 'Save current search';

  @override
  String get source_saved_searches => 'Saved searches';

  @override
  String get source_website_info => 'Website information';

  @override
  String source_saved_search_title(String title) {
    return '$title · Tap to search';
  }

  @override
  String get action_done => 'Done';

  @override
  String source_search_keyword(String query) {
    return 'Keyword: $query';
  }

  @override
  String get source_no_saved_searches => 'No saved searches yet';

  @override
  String get source_save_search_hint =>
      'Search for a keyword, then save it from the website actions.';

  @override
  String get source_saved_search_scope =>
      'Keywords are saved for this website only.';

  @override
  String get source_search_here => 'Search titles on this website';

  @override
  String get source_filter_results => 'Filtered results';

  @override
  String get source_search_results => 'Search results';

  @override
  String get source_return_popular => 'Back to popular';

  @override
  String get source_popular_titles => 'Popular titles';

  @override
  String get source_no_titles => 'No matching titles found';

  @override
  String get source_no_titles_hint =>
      'Change your keywords or filters, or return to popular titles.';

  @override
  String get source_load_more_failed =>
      'Could not load more. Please try again.';

  @override
  String get source_load_pull_retry =>
      'Could not load this website. Pull down to retry.';

  @override
  String get source_clear_failed =>
      'Could not finish clearing. Please try again.';

  @override
  String get source_uninstall_failed =>
      'Could not finish uninstalling. Please try again.';

  @override
  String get source_details => 'Source details';

  @override
  String get source_repository_website => 'Repository website';

  @override
  String get source_provided_settings => 'Settings provided by the source';

  @override
  String get source_advanced_actions => 'Advanced actions';

  @override
  String get source_edit_metadata => 'Edit source information';

  @override
  String get source_clear_cookies => 'Clear cookies for this website';

  @override
  String get source_clear_cookies_hint =>
      'You may need to sign in again on your next visit.';

  @override
  String get source_uninstall => 'Uninstall source';

  @override
  String get source_settings_save_failed =>
      'Saving did not finish. Reopen source settings to check.';

  @override
  String get repository_third_party => 'Third-party repositories';

  @override
  String get repository_refresh_failed =>
      'Could not refresh the catalog. Cached content is kept. Please try again.';

  @override
  String get repository_show_sources => 'Show sources from this repository';

  @override
  String get repository_copy_catalog => 'Copy catalog link';

  @override
  String get repository_remove => 'Remove repository';

  @override
  String get repository_remove_hint =>
      'Keep installed sources and remove uninstalled catalog entries.';

  @override
  String get repository_empty => 'No third-party repositories added yet';

  @override
  String get repository_built_in => 'Built-in official catalog';

  @override
  String get repository_hidden => 'Hidden';

  @override
  String get repository_refreshing => 'Refreshing…';

  @override
  String get repository_refresh => 'Refresh catalog';

  @override
  String get repository_manage_hint =>
      'Manage where third-party sources are downloaded from.';

  @override
  String get repository_invalid_address => 'Enter a valid HTTP or HTTPS URL';

  @override
  String get repository_already_added =>
      'This repository has already been added';

  @override
  String get repository_unrecognized =>
      'No supported catalog found. Check the link and try again.';

  @override
  String get repository_read_failed =>
      'Could not read the catalog. Please try again.';

  @override
  String get repository_save_failed =>
      'Saving did not finish. Check your repository list.';

  @override
  String get repository_paste_hint =>
      'Paste a third-party repository catalog link';

  @override
  String get repository_address => 'Repository URL';

  @override
  String get repository_paste_link => 'Paste link';

  @override
  String repository_recognized(String type) {
    return '$type · Catalog recognized';
  }

  @override
  String get repository_choose_sources_hint =>
      'After adding the repository, choose the sources you need.';

  @override
  String get search_scope => 'Search scope';

  @override
  String get search_scope_hint => 'Choose the websites to search';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Search $count websites',
      one: 'Search 1 website',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Find a website';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count websites selected',
      one: '1 website selected',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Clear';

  @override
  String get search_deselect_results => 'Deselect matching websites';

  @override
  String get search_select_results => 'Select matching websites';

  @override
  String get search_no_websites_hint =>
      'No matching websites. Try another name or language.';

  @override
  String get search_select_website_hint =>
      'Select at least one website to search.';

  @override
  String get search_start_title => 'Enter keywords to find titles';

  @override
  String get search_start_hint =>
      'Search multiple websites at once and show matching titles.';

  @override
  String get search_empty_scope => 'No searchable websites in this scope';

  @override
  String get search_empty_scope_hint =>
      'Switch to all websites or choose websites to search.';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'Search titles';

  @override
  String get search_actions => 'Search actions';

  @override
  String get search_details => 'Search details';

  @override
  String get search_title_hint => 'Search by title';

  @override
  String get search_searching => 'Searching';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Found $count results',
      one: 'Found 1 result',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'No matching results';

  @override
  String get search_failed => 'Search failed';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titles found',
      one: '1 title found',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: '$websites websites',
      one: '1 website',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Finding titles';

  @override
  String get search_complete => 'Search complete';

  @override
  String get search_in_progress => 'Searching';

  @override
  String get search_finding_related => 'Looking for matching titles…';

  @override
  String get search_no_results_yet => 'No search results yet';

  @override
  String get search_no_matching_titles => 'No matching titles found';

  @override
  String get search_results_appear_hint =>
      'Results will appear here as they are found.';

  @override
  String get search_failed_websites_hint =>
      'Some websites could not finish searching. Retry them in search details.';

  @override
  String get search_change_keywords_hint =>
      'Try shorter keywords or search more websites.';

  @override
  String get search_view_details => 'View search details';

  @override
  String get search_adjust_scope => 'Adjust search scope';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count websites',
      one: '1 website',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Completed $completed / $total';
  }

  @override
  String get search_retry_website_hint => 'Retry failed websites individually';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items selected',
      one: '1 item selected',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Search languages';

  @override
  String get source_deselect => 'Deselect';

  @override
  String get source_select => 'Select source';

  @override
  String get source_multilingual => 'Multilingual';

  @override
  String get source_language_unknown => 'Language not specified';

  @override
  String get source_adult_content => 'Contains 18+ content';

  @override
  String get source_classification_unknown => 'Classification not specified';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'View all source information, $count more categories',
      one: 'View all source information, 1 more category',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Loading website';

  @override
  String get source_unpin => 'Unpin';

  @override
  String get source_pin => 'Pin';

  @override
  String get source_open => 'Open';

  @override
  String get source_metadata_hint =>
      'Information comes from the source catalog. Categories describe the content covered by the website.';

  @override
  String get source_region => 'Region';

  @override
  String get source_format => 'Format';

  @override
  String get source_creation => 'Creation';

  @override
  String get source_unspecified => 'Not specified';

  @override
  String get source_pricing => 'Pricing';

  @override
  String get source_region_jp => 'Japanese comics';

  @override
  String get source_region_kr => 'Korean comics';

  @override
  String get source_region_cn => 'Chinese comics';

  @override
  String get source_region_hk_tw => 'Hong Kong and Taiwan comics';

  @override
  String get source_region_western => 'Western comics';

  @override
  String get source_region_other => 'Other regions';

  @override
  String get source_format_page => 'Paged comics';

  @override
  String get source_format_vertical => 'Vertical comics';

  @override
  String get source_format_strip => 'Comic strips';

  @override
  String get source_creation_original => 'Original';

  @override
  String get source_creation_fan => 'Fan works';

  @override
  String get source_free_watch => 'Free to watch';

  @override
  String get source_free_read => 'Free to read';

  @override
  String get source_partial_paid => 'Partially paid';

  @override
  String get source_paid_watch => 'Paid viewing';

  @override
  String get source_paid_read => 'Paid reading';

  @override
  String get source_pricing_unknown => 'Pricing not specified';

  @override
  String get source_language_filter => 'Filter by language';

  @override
  String get source_language_filter_hint =>
      'Filter this catalog only. Installed sources are unaffected.';

  @override
  String get source_all_languages => 'All languages';

  @override
  String get action_apply => 'Apply';

  @override
  String get source_load_retry =>
      'Could not load this website. Please try again.';

  @override
  String get source_catalog_refresh_failed =>
      'Could not refresh the catalog. Current content is kept. Pull down to retry.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uninstall $count sources?',
      one: 'Uninstall 1 source?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Uninstall the selected sources and clear their settings. Keep library titles and downloads.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Actions failed for $count sources.',
      one: 'Action failed for 1 source.',
    );
    return '$_temp0 Selection kept. Please try again.';
  }

  @override
  String get source_latest_content => 'Latest content';

  @override
  String get source_actions => 'Source actions';

  @override
  String get source_bulk_manage => 'Manage multiple sources';

  @override
  String get source_update_installed => 'Update installed sources';

  @override
  String get source_no_matching_websites => 'No matching websites';

  @override
  String get source_no_websites => 'No websites available';

  @override
  String get source_search_installed_hint =>
      'Search titles in installed sources';

  @override
  String get source_global_search => 'Search across sources';

  @override
  String get source_manage_repositories => 'Manage repositories';

  @override
  String get source_view_third_party => 'View third-party sources';

  @override
  String get source_catalog_load_failed =>
      'Could not load the catalog. Pull down to retry.';

  @override
  String get source_all_websites => 'All websites';

  @override
  String get source_available => 'Available to install';

  @override
  String get source_third_party => 'Third-party';

  @override
  String get source_name_or_title => 'Website name or title';

  @override
  String get view_all => 'View all';

  @override
  String get search_searching_ellipsis => 'Searching…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · Untested';
  }

  @override
  String get onboarding_untested => 'Untested';

  @override
  String get source_custom_scope => 'Custom';

  @override
  String get source_custom_websites => 'Selected websites';

  @override
  String get tv_hidden_library_hint =>
      'Every title sits in a hidden category.\nHold OK on “All” to unhide one.';

  @override
  String get tv_no_matching_anime => 'No matching anime';

  @override
  String tv_no_matching_category(String category) {
    return 'No matching anime in “$category”';
  }

  @override
  String get tv_filtered_empty_hint =>
      'No anime matches the current filters.\nChange them from the button beside search.';

  @override
  String get tv_new_episodes => 'New Episodes';

  @override
  String get tv_recently_added => 'Recently Added';

  @override
  String get tv_empty_category_hint =>
      'No anime in this category yet.\nAdd titles to it from a title’s detail page.';

  @override
  String get tv_empty_library => 'Your anime library is empty';

  @override
  String get tv_empty_library_hint => 'Add anime from Browse to fill your home';

  @override
  String get tv_browse_anime => 'Browse anime';

  @override
  String tv_new_count(int count) {
    return '$count new';
  }

  @override
  String tv_category_hidden(String category) {
    return 'Hid “$category” · hold OK on “All” to unhide';
  }

  @override
  String get tv_no_hidden_categories => 'No hidden categories';

  @override
  String get import_torrent_file => 'import .torrent file';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi, and more';

  @override
  String get cloudflare_proxy_optional => 'Optional FlareSolverr / Byparr URL';

  @override
  String get tv_home_layout_hint =>
      'Rows-based anime home (Continue · New Episodes · categories) instead of the flat grid';

  @override
  String get tv_hide_libraries_hint =>
      'Hide the manga & novel libraries (on by default on TV)';

  @override
  String get anime_only_hint =>
      'Hide manga & novel across the app. Turn off to show everything.';

  @override
  String get audio_auto_safe => 'Auto-safe';

  @override
  String get tv_player_hint =>
      'On: dedicated TV player.  Off: original (desktop) player.';

  @override
  String get release_open_failed => 'Unable to open release';

  @override
  String get tv_replay => 'Replay';

  @override
  String get tv_no_episodes => 'No episodes yet';

  @override
  String get tracker_continue_series => 'Continue watching series';

  @override
  String get tracker_watchlist_series => 'Watchlist series';

  @override
  String get tracker_continue_movies => 'Continue watching movies';

  @override
  String get tracker_watchlist_movies => 'Watchlist movies';

  @override
  String get tracker_trending_series => 'Trending Series';

  @override
  String get tracker_trending_movies => 'Trending Movies';

  @override
  String get tracker_popular_series => 'Popular Series';

  @override
  String get tracker_popular_movies => 'Popular Movies';

  @override
  String get tracker_top_series => 'Top Series (All Time)';

  @override
  String get tracker_top_movies => 'Top Movies (All Time)';

  @override
  String get tracker_airing_series => 'Airing Series';

  @override
  String get tracker_airing_anime => 'Airing Anime';

  @override
  String get tracker_popular_anime => 'Popular Anime';

  @override
  String get tracker_upcoming_anime => 'Upcoming Anime';

  @override
  String get tracker_popular_manga => 'Popular Manga';

  @override
  String get tracker_top_manga => 'Top Manga';

  @override
  String get tracker_top_manhwa => 'Top Manhwa';

  @override
  String get tracker_top_manhua => 'Top Manhua';

  @override
  String get tracker_latest_anime => 'Latest Anime';

  @override
  String get tracker_best_anime => 'Best Rated Anime';

  @override
  String get tracker_latest_manga => 'Latest Manga';

  @override
  String get tracker_best_manga => 'Best Rated Manga';

  @override
  String get tracker_trending_anime => 'Trending Anime';

  @override
  String get tracker_upcoming_manga => 'Upcoming Manga';

  @override
  String get tracker_trending_manga => 'Trending Manga';

  @override
  String selection_progress(int selected, int total) {
    return '$selected/$total selected';
  }

  @override
  String get source_code_editor => 'Code Editor';

  @override
  String get source_code_execute => 'Execute';

  @override
  String get source_console_logs => 'Console Logs';

  @override
  String get source_no_logs => 'No logs yet';

  @override
  String get source_updated_successfully => 'Source updated successfully';

  @override
  String get source_obsolete => 'OBSOLETE';

  @override
  String player_seek_forward_seconds(int seconds) {
    return 'Seek forward $seconds seconds';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return 'Seek backward $seconds seconds';
  }

  @override
  String get player_autoplay_on => 'Autoplay next episode: on';

  @override
  String get player_autoplay_off => 'Autoplay next episode: off';

  @override
  String get player_no_other_quality => 'No other quality';

  @override
  String get player_no_subtitles => 'No subtitles';

  @override
  String get player_no_audio_tracks => 'No audio tracks';

  @override
  String get player_seek_forward => 'Seek forward';

  @override
  String get player_seek_backward => 'Seek backward';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds seconds',
      one: '1 second',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'Lorem ipsum dolor sit amet';

  @override
  String get subtitle_style => 'Style';

  @override
  String get translation_official_channel => 'NodeLane Official';

  @override
  String get translation_auth_required =>
      'Sign in to your translation account first.';

  @override
  String get translation_source_changed =>
      'The original image changed. Please reload it.';

  @override
  String get translation_source_missing =>
      'The original image is currently unavailable.';

  @override
  String get translation_resource_limit =>
      'This image exceeds the device processing limit. The original is kept.';

  @override
  String get translation_storage_full =>
      'Translation storage is full. Clear translated images first.';

  @override
  String get translation_invalid_image => 'Invalid image format or content.';

  @override
  String get translation_unsupported_image =>
      'Translation is not supported for this image. The original is kept.';

  @override
  String get translation_invalid_result =>
      'Translated image validation failed. Please reload it.';

  @override
  String get translation_result_unavailable =>
      'The translated image is unavailable. Please reload it.';

  @override
  String get translation_result_expired =>
      'The translated image expired. Please translate it again.';

  @override
  String get translation_analysis_too_large =>
      'There is too much image content to analyze. Reduce the image size and try again.';

  @override
  String get translation_region_limit =>
      'The image has too many text regions. Split it and try again.';

  @override
  String get translation_text_limit =>
      'A text region is too long. Adjust the image and try again.';

  @override
  String get translation_unavailable =>
      'This translation is no longer available.';

  @override
  String get translation_outcome_unknown =>
      'The result needs verification. It has not been resubmitted.';

  @override
  String get translation_rate_limited =>
      'Requests are limited. Translation will resume automatically.';

  @override
  String get translation_quota_exhausted => 'Insufficient translation quota.';

  @override
  String get translation_unsupported_language =>
      'The service does not support this target language.';

  @override
  String get translation_upgrade_required =>
      'The translation protocol is incompatible. Update the app.';

  @override
  String get translation_remote_failed =>
      'Translation failed for this page. You can retry manually.';

  @override
  String get translation_bridge_invalid =>
      'The web page changed. Enable translation again.';

  @override
  String get translation_connection_failed =>
      'Connection failed. Please try again.';

  @override
  String get translation_paused =>
      'Translation paused. You can verify its progress.';

  @override
  String get translation_preparing_ellipsis => 'Preparing translation…';

  @override
  String get translation_checking_original => 'Checking original image…';

  @override
  String get translation_submitting => 'Submitting…';

  @override
  String get translation_uploading_ellipsis => 'Uploading original…';

  @override
  String get translation_waiting_ellipsis => 'Waiting for translation…';

  @override
  String get translation_running_ellipsis => 'Translating…';

  @override
  String get translation_verify_result => 'Result needs verification';

  @override
  String get translation_partial => 'Some content has been translated';

  @override
  String get translation_ready => 'Translated image ready';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Play';

  @override
  String get player_quality => 'Quality';

  @override
  String get player_subtitles => 'Subtitles';

  @override
  String get player_audio => 'Audio';

  @override
  String get player_statistics => 'Stats for nerds';

  @override
  String get player_auto => 'Auto';

  @override
  String get source_information => 'Source information';

  @override
  String get source_code_page => 'Page';

  @override
  String get source_code_query => 'Query';

  @override
  String get repository_invalid_source => 'Invalid source - remove it';

  @override
  String get player_fit_contain => 'Contain';

  @override
  String get player_fit_cover => 'Cover';

  @override
  String get player_fit_fill => 'Fill';

  @override
  String get player_fit_height => 'Height';

  @override
  String get player_fit_width => 'Width';

  @override
  String get player_fit_scale => 'Scale';

  @override
  String get player_fit_none => 'None';

  @override
  String get player_shader_clear => 'Off (clear shaders)';

  @override
  String get player_shader_luma => 'Luma Upscaling';

  @override
  String get player_decoder_auto => 'Auto (hardware)';

  @override
  String get player_decoder_software => 'Software (no hardware)';

  @override
  String get player_stats_toggle => 'Toggle overlay';

  @override
  String get player_stats_general => 'General';

  @override
  String get player_stats_frames => 'Frame timings';

  @override
  String get player_stats_cache => 'Input cache';

  @override
  String get player_stats_filters => 'Active filters';

  @override
  String get player_stats_log => 'Log';

  @override
  String get source_mark_pinned => 'Pin';

  @override
  String translation_image_action(String action) {
    return '$action this image';
  }

  @override
  String get memory_waiting => 'memory: waiting for a sample';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS   $current   peak $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'cache $current / $limit   peak $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'items $count / $limit   live $live   peak $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count samples',
      one: '1 sample',
    );
    return 'full  $percent% of $_temp0';
  }

  @override
  String get memory_reset_hint => 'toggle it off and on in settings to reset';

  @override
  String get action_hide => 'Hide';

  @override
  String discord_get_app(String app) {
    return 'Get $app';
  }

  @override
  String get discord_idle => 'Idle';

  @override
  String discord_watching_title(String title) {
    return 'Watching $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'Reading $title';
  }
}
