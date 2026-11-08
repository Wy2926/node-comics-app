// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get app_update_details_hint => 'リリース ノートとインストール オプションを表示する';

  @override
  String get app_update_download => 'ダウンロードアップデート';

  @override
  String get app_update_download_hint => 'ダウンロード後、プロンプトに従ってアップデートをインストールします。';

  @override
  String get bookshelf_all => 'すべて';

  @override
  String get bookshelf_search => 'ライブラリの検索';

  @override
  String get app_update_allow_install =>
      'システム設定でアプリのインストールを許可し、戻って「インストール」をタップします。';

  @override
  String get app_update_waiting => 'システムがダウンロードを再開するのを待っています…';

  @override
  String get app_update_cancel_download => 'ダウンロードのキャンセル';

  @override
  String get app_update_remove_package => 'ダウンロードしたパッケージを削除する';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => '一致する設定がありません';

  @override
  String get search_empty_hint => '別のキーワードを試すか、検索をクリアしてすべてを表示してください。';

  @override
  String get search_clear => '検索をクリアする';

  @override
  String get app_updates => 'アプリのアップデート';

  @override
  String get app_update_auto => '起動時のチェック';

  @override
  String get app_update_view => 'ビューの更新';

  @override
  String get app_update_later => 'その後';

  @override
  String get app_update_external_hint => 'ブラウザで更新リンクを開きます';

  @override
  String get app_update_failed => '更新をチェックできない。もう一度試してください。';

  @override
  String get app_update_opened => '更新リンクが開きました';

  @override
  String get app_diagnostics => '診断とログ';

  @override
  String get library => 'ライブラリ';

  @override
  String get updates_search => '検索の更新';

  @override
  String get updates => '更新';

  @override
  String get history => '履歴';

  @override
  String get browse => 'ブラウズ';

  @override
  String get more => 'その他';

  @override
  String get open_random_entry => 'ランダムに開く';

  @override
  String get import => 'インポート';

  @override
  String get filter => 'フィルター';

  @override
  String get ignore_filters => 'フィルターを無視';

  @override
  String get downloaded => 'ダウンロード済み';

  @override
  String get unread => '未読';

  @override
  String get unwatched => '未視聴';

  @override
  String get started => '開始済み';

  @override
  String get bookmarked => 'ブックマーク済み';

  @override
  String get sort => '並び替え';

  @override
  String get alphabetically => 'アルファベット順';

  @override
  String get last_read => '最後に読んだ';

  @override
  String get last_watched => '最後に視聴';

  @override
  String get last_update_check => '最終更新確認';

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
      other: 'この$mediaTypeのすべての$count個の$entryTypePluralをライブラリから削除しようとしています。',
      one: 'この$mediaTypeの唯一の$entryTypeをライブラリから削除しようとしています。',
    );
    return '$_temp0\nこれにより、$mediaType全体もライブラリから削除されます。\n\n注：ファイル自体は削除されません。';
  }

  @override
  String get chapter => 'チャプター';

  @override
  String get episode => 'エピソード';

  @override
  String get unread_count => '未読数';

  @override
  String get unwatched_count => '未視聴数';

  @override
  String get latest_chapter => '最新チャプター';

  @override
  String get latest_episode => '最新エピソード';

  @override
  String get date_added => '追加日';

  @override
  String get display => '表示';

  @override
  String get display_mode => '表示モード';

  @override
  String get compact_grid => 'コンパクトグリッド';

  @override
  String get compression_level => '圧縮レベル';

  @override
  String compression_info(Object level) {
    return '圧縮が高い=スペースが少ないがCPUが多い。デフォルト: $level';
  }

  @override
  String get comfortable_grid => '快適グリッド';

  @override
  String get cover_only_grid => 'カバーのみグリッド';

  @override
  String get list => 'リスト';

  @override
  String get badges => 'バッジ';

  @override
  String get downloaded_chapters => 'ダウンロード済みチャプター';

  @override
  String get downloaded_episodes => 'ダウンロード済みエピソード';

  @override
  String get language => '言語';

  @override
  String get local_source => 'ローカルソース';

  @override
  String get tabs => 'タブ';

  @override
  String get show_category_tabs => 'カテゴリタブを表示';

  @override
  String get show_numbers_of_items => 'アイテム数を表示';

  @override
  String get other => 'その他';

  @override
  String get show_continue_reading_buttons => '読み続けるボタンを表示';

  @override
  String get show_continue_watching_buttons => '視聴を続けるボタンを表示';

  @override
  String get empty_library => 'ライブラリが空です';

  @override
  String get search => '検索';

  @override
  String get no_recent_updates => '最近の更新がありません';

  @override
  String get remove_everything => 'すべて削除';

  @override
  String get remove_everything_msg => '本当にすべてを削除しますか？すべての履歴が失われます';

  @override
  String get remove_all_update_msg => '本当によろしいですか？すべての更新がクリアされます';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'キャンセル';

  @override
  String get remove => '削除';

  @override
  String get remove_history_msg => 'このチャプターの読取日を削除します。よろしいですか？';

  @override
  String get last_used => '最後に使用';

  @override
  String get pinned => 'ピン留め済み';

  @override
  String get sources => 'ソース';

  @override
  String get install => 'インストール';

  @override
  String get update => '更新';

  @override
  String get latest => '最新';

  @override
  String get extensions => '拡張機能';

  @override
  String get migrate => '移行';

  @override
  String get mass_migration_title => '一括移行';

  @override
  String get mass_migration_preview_items => 'プレビューアイテム';

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
  String get migrate_confirm => '別のソースに移行';

  @override
  String get clean_database => 'データベースをクリーン';

  @override
  String cleaned_database(Object x) {
    return 'データベースがクリーンされました！$x個のエントリが削除されました';
  }

  @override
  String get clean_database_desc => 'これによりライブラリに追加されていないすべてのアイテムが削除されます！';

  @override
  String get incognito_mode => 'シークレットモード';

  @override
  String get incognito_mode_description => '読取履歴を一時停止';

  @override
  String get downloaded_only => 'ダウンロード済みのみ';

  @override
  String get downloaded_only_description => 'ライブラリにダウンロード済みエントリのみを表示';

  @override
  String get download_queue => 'ダウンロードキュー';

  @override
  String get categories => 'カテゴリ';

  @override
  String get statistics => '統計';

  @override
  String get settings => '設定';

  @override
  String get about => 'について';

  @override
  String get help => 'ヘルプ';

  @override
  String get no_downloads => 'ダウンロードなし';

  @override
  String get edit_categories => 'カテゴリ編集';

  @override
  String get edit_categories_description =>
      'カテゴリがありません。プラスボタンをタップして、ライブラリを整理するためのカテゴリを作成してください';

  @override
  String get add => '追加';

  @override
  String get add_category => 'カテゴリを追加';

  @override
  String get name => '名前';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*必須';

  @override
  String get add_category_error_exist => 'このカテゴリ名は既に存在します！';

  @override
  String get delete_category => 'カテゴリを削除';

  @override
  String delete_category_msg(Object name) {
    return 'カテゴリ$nameを削除しますか？';
  }

  @override
  String get rename_category => 'カテゴリ名を変更';

  @override
  String get general => '一般';

  @override
  String get general_subtitle => 'アプリ言語';

  @override
  String get app_language => 'アプリ言語';

  @override
  String get default_subtitle_language => 'デフォルト字幕言語';

  @override
  String get appearance => '外観';

  @override
  String get appearance_subtitle => 'テーマ、日時形式';

  @override
  String get theme => 'テーマ';

  @override
  String get dark_mode => 'ダークモード';

  @override
  String get follow_system_theme => 'システムテーマに従う';

  @override
  String get on => 'オン';

  @override
  String get off => 'オフ';

  @override
  String get pure_black_dark_mode => '純黒ダークモード';

  @override
  String get timestamp => 'タイムスタンプ';

  @override
  String get relative_timestamp => '相対タイムスタンプ';

  @override
  String get relative_timestamp_short => '短い(今日、昨日)';

  @override
  String get relative_timestamp_long => '長い(短い+、n日前)';

  @override
  String get date_format => '日付形式';

  @override
  String get reader => 'リーダー';

  @override
  String get refresh => '更新';

  @override
  String get reader_subtitle => '読取モード、表示、ナビゲーション';

  @override
  String get default_reading_mode => 'デフォルト読取モード';

  @override
  String get reading_mode_vertical => '垂直';

  @override
  String get reading_mode_horizontal => '水平';

  @override
  String get reading_mode_left_to_right => '左から右へ';

  @override
  String get reading_mode_right_to_left => '右から左へ';

  @override
  String get reading_mode_vertical_continuous => '垂直連続';

  @override
  String get reading_mode_webtoon => 'ウェブトゥーン';

  @override
  String get double_tap_animation_speed => 'ダブルタップアニメーション速度';

  @override
  String get normal => '普通';

  @override
  String get fast => '速い';

  @override
  String get no_animation => 'アニメーションなし';

  @override
  String get animate_page_transitions => 'ページ遷移をアニメーション化';

  @override
  String get crop_borders => '境界をトリミング';

  @override
  String get downloads => 'ダウンロード';

  @override
  String get downloads_subtitle => 'ダウンロード設定';

  @override
  String get download_location => 'ダウンロード場所';

  @override
  String get custom_location => 'カスタムロケーション';

  @override
  String get only_on_wifi => 'Wi-Fiのみ';

  @override
  String get save_as_cbz_archive => 'CBZアーカイブとして保存';

  @override
  String get delete_download_after_reading => '読後に削除';

  @override
  String get concurrent_downloads => '同時ダウンロード';

  @override
  String get browse_subtitle => 'ソース、グローバル検索';

  @override
  String get only_include_pinned_sources => 'ピン留め済みソースのみを含める';

  @override
  String get nsfw_sources => 'NSFW (+18) ソース';

  @override
  String get nsfw_sources_show => 'ソースと拡張機能のリストに表示';

  @override
  String get nsfw_sources_info =>
      'これは、非公式またはおそらく不正にフラグが付いた拡張機能がアプリ内でNSFW（18+）コンテンツをサーフェスするのを防ぎません';

  @override
  String get version => 'バージョン';

  @override
  String beta_version(Object version) {
    return 'ベータ ($version)';
  }

  @override
  String get check_for_update => '更新を確認';

  @override
  String get logs_on => 'ログを有効にする';

  @override
  String get share_app_logs => 'アプリログを共有';

  @override
  String get no_app_logs => 'log.txtファイルが利用できません！';

  @override
  String get failed => '失敗！';

  @override
  String n_days_ago(Object days) {
    return '$days日前';
  }

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get a_week_ago => '1週間前';

  @override
  String get next_week => '来週';

  @override
  String get add_to_library => 'ライブラリに追加';

  @override
  String get completed => '完了';

  @override
  String get ongoing => '進行中';

  @override
  String get on_hiatus => '休止中';

  @override
  String get canceled => 'キャンセル';

  @override
  String get publishing_finished => '出版が終了';

  @override
  String get unknown => '不明';

  @override
  String get empty_placeholder => '空';

  @override
  String get error => 'エラー';

  @override
  String error_with_message(Object error) {
    return 'エラー: $error';
  }

  @override
  String get no_pages_available => 'エラー: 利用可能なページがありません';

  @override
  String get set_categories => 'カテゴリを設定';

  @override
  String get edit => '編集';

  @override
  String get in_library => 'ライブラリに追加済み';

  @override
  String get filter_scanlator_groups => 'スキャンレータグループをフィルター';

  @override
  String get reset => 'リセット';

  @override
  String get by_source => 'ソース別';

  @override
  String get by_chapter_number => 'チャプター番号別';

  @override
  String get by_episode_number => 'エピソード番号別';

  @override
  String get by_upload_date => 'アップロード日時別';

  @override
  String get source_title => 'ソースタイトル';

  @override
  String get create_extension => '拡張機能を作成';

  @override
  String get developer_mode => '開発者モード';

  @override
  String get developer_mode_subtitle => '拡張機能の開発者ツール（拡張機能の作成、コード編集）を表示';

  @override
  String get choose_extension_language => '拡張機能の言語を選択';

  @override
  String get lang => '言語';

  @override
  String get base_url => 'ベースURL';

  @override
  String get api_url_optional => 'API URL（任意）';

  @override
  String get icon_url => 'アイコンURL';

  @override
  String get source_icon_url => 'ソースアイコンURL';

  @override
  String get notes => '備考';

  @override
  String get extension_name_example => '例: myAnime';

  @override
  String get language_code_example => '例: ja';

  @override
  String get base_url_example => '例: https://example.com';

  @override
  String get api_url_example => '例: https://api.example.com';

  @override
  String get extension_notes_example => '例: この拡張機能にはログインが必要です';

  @override
  String get type => 'タイプ';

  @override
  String get target => 'ターゲット';

  @override
  String get source_type_single => '単一';

  @override
  String get source_type_multi => '複数';

  @override
  String get source_type_torrent => 'トレント';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReaderコンパイル済みJS';

  @override
  String get source_created_successfully => 'ソースが正常に作成されました';

  @override
  String get source_already_exists => 'ソースは既に存在します';

  @override
  String get error_when_creating_source => 'ソース作成エラー';

  @override
  String get cookies_deleted => 'Cookieを削除しました！';

  @override
  String get delete_all_cookies => 'すべてのCookieを削除';

  @override
  String get chapter_number => 'チャプター番号';

  @override
  String get episode_number => 'エピソード番号';

  @override
  String get share => '共有';

  @override
  String n_chapters(Object n) {
    return '$n チャプター';
  }

  @override
  String missing_chapters(Object count) {
    return '不足している話数: $count';
  }

  @override
  String get no_description => '説明なし';

  @override
  String get resume => '再開';

  @override
  String get read => '読む';

  @override
  String get watch => '視聴';

  @override
  String get popular => '人気';

  @override
  String get open_in_browser => 'ブラウザーで開く';

  @override
  String get clear_cookie => 'クッキーをクリア';

  @override
  String get show_page_number => 'ページ番号を表示';

  @override
  String get from_library => 'ライブラリから';

  @override
  String get downloaded_chapter => 'ダウンロード済みチャプター';

  @override
  String page(Object page) {
    return '$page ページ';
  }

  @override
  String get global_search => 'グローバル検索';

  @override
  String get color_blend_level => 'カラーブレンドレベル';

  @override
  String current(Object char) {
    return '現在の$char';
  }

  @override
  String finished(Object char) {
    return '完了した$char';
  }

  @override
  String next(Object char) {
    return '次の$char';
  }

  @override
  String previous(Object char) {
    return '前の$char';
  }

  @override
  String get no_more_chapter => 'もうチャプターはありません';

  @override
  String get no_result => '結果がありません';

  @override
  String get send => '送信';

  @override
  String get delete => '削除';

  @override
  String get start_downloading => '今すぐダウンロード開始';

  @override
  String get retry => '再試行';

  @override
  String get add_chapters => 'チャプターを追加';

  @override
  String get delete_chapters => 'チャプターを削除しますか？';

  @override
  String get default0 => 'デフォルト';

  @override
  String get total_chapters => '総チャプター数';

  @override
  String get total_episodes => '総エピソード数';

  @override
  String get import_local_file => 'ローカルファイルをインポート';

  @override
  String get import_files => 'ファイル';

  @override
  String get split_epub_chapters => 'チャプターに分割';

  @override
  String get split_epub_chapters_description => '各EPUBチャプターを別のエントリとしてインポート';

  @override
  String get nothing_read_recently => '最近読んだものがありません';

  @override
  String get status => 'ステータス';

  @override
  String get not_started => '未開始';

  @override
  String get score => 'スコア';

  @override
  String get start_date => '開始日';

  @override
  String get finish_date => '完了日';

  @override
  String get reading => '読書中';

  @override
  String get on_hold => '保留中';

  @override
  String get dropped => '中断';

  @override
  String get plan_to_read => '読む予定';

  @override
  String get re_reading => '再読中';

  @override
  String get chapters => 'チャプター';

  @override
  String get add_tracker => 'トラッキングを追加';

  @override
  String get one_tracker => '1トラッカー';

  @override
  String n_tracker(Object n) {
    return '$nトラッカー';
  }

  @override
  String get tracking => 'トラッキング';

  @override
  String get syncing => '同期中';

  @override
  String get sync_logged => 'ログイン成功';

  @override
  String get syncing_subtitle =>
      '同期サーバーのアドレスを入力し、ブラウザーでログインすると、読書の進行状況をデバイス間で同期できます。';

  @override
  String get sync_service => 'セルフホスト同期';

  @override
  String get last_sync => '最終同期日時: ';

  @override
  String get sync_login_browser => 'ブラウザでログイン';

  @override
  String get sync_server => '同期サーバーアドレス';

  @override
  String get sync_starting => '同期を開始しています...';

  @override
  String get sync_finished => '同期完了';

  @override
  String get sync_failed => '同期失敗';

  @override
  String get sync_restore_in_progress => '同期をスキップ — 復元中';

  @override
  String sync_progress_percent(Object percent) {
    return '同期中… $percent%';
  }

  @override
  String get sync_progress_indeterminate => '同期中…';

  @override
  String get sync_button_sync => '進行状況を同期';

  @override
  String get sync_button_upload => 'アップロードのみ';

  @override
  String get sync_button_upload_info => 'この操作はリモートデータを完全にローカルデータで置き換えます！';

  @override
  String get sync_button_download => 'ダウンロードのみ';

  @override
  String get sync_button_download_info => 'この操作はローカルデータを完全にリモートデータで置き換えます！';

  @override
  String get sync_status_not_configured => '未接続';

  @override
  String get sync_status_checking => '接続を確認中...';

  @override
  String get sync_status_connected => '接続済み';

  @override
  String get sync_status_unauthorized => 'セッションが切れました。再ログインしてください';

  @override
  String get sync_status_unreachable => 'サーバーに接続できません';

  @override
  String get sync_section_general => '一般';

  @override
  String get sync_on => '同期を有効化';

  @override
  String get sync_auto => '自動同期';

  @override
  String get sync_auto_warning => '自動同期は現在実験的な機能です！';

  @override
  String get sync_auto_off => 'オフ';

  @override
  String get sync_auto_5_minutes => '5分ごと';

  @override
  String get sync_auto_10_minutes => '10分ごと';

  @override
  String get sync_auto_30_minutes => '30分ごと';

  @override
  String get sync_auto_1_hour => '1時間ごと';

  @override
  String get sync_auto_3_hours => '3時間ごと';

  @override
  String get sync_auto_6_hours => '6時間ごと';

  @override
  String get sync_auto_12_hours => '12時間ごと';

  @override
  String get server_error => 'サーバーエラー！';

  @override
  String get dialog_confirm => '確認';

  @override
  String get description => '説明';

  @override
  String get reorder_navigation => 'ナビゲーションをカスタマイズ';

  @override
  String get reorder_navigation_description =>
      'ニーズに合わせて各ナビゲーションを並べ替えたり切り替えたりします。';

  @override
  String get floating_navigation_bar => 'フローティング ナビゲーション バー';

  @override
  String get floating_navigation_bar_description =>
      '標準付属のナビゲーション バーの代わりにフローティング カプセルを使用します。';

  @override
  String get full_screen_player => 'フルスクリーンを使用';

  @override
  String get full_screen_player_info => '動画再生時に自動的にフルスクリーンを使用します。';

  @override
  String episode_progress(Object n) {
    return '進行状況: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n エピソード';
  }

  @override
  String missing_episodes(Object count) {
    return '不足しているエピソード: $count';
  }

  @override
  String get manga_sources => 'マンガソース';

  @override
  String get anime_sources => 'アニメソース';

  @override
  String get novel_sources => '小説ソース';

  @override
  String get anime_extensions => 'アニメ拡張機能';

  @override
  String get manga_extensions => 'マンガ拡張機能';

  @override
  String get novel_extensions => '小説拡張機能';

  @override
  String get extension_settings => '拡張機能設定';

  @override
  String get anime => 'アニメ';

  @override
  String get manga => 'マンガ';

  @override
  String get novel => '小説';

  @override
  String get library_no_category_exist => 'まだカテゴリがありません';

  @override
  String get watching => '視聴中';

  @override
  String get plan_to_watch => '視聴予定';

  @override
  String get re_watching => '再視聴中';

  @override
  String get episodes => 'エピソード';

  @override
  String get download => 'ダウンロード';

  @override
  String get new_update_available => '新しい更新が利用可能です';

  @override
  String app_version(Object v) {
    return 'アプリバージョン : v$v';
  }

  @override
  String get searching_for_updates => '更新を検索しています...';

  @override
  String get no_new_updates_available => '新しい更新は利用できません';

  @override
  String get uninstall => 'アンインストール';

  @override
  String uninstall_extension(Object ext) {
    return '$ext拡張機能をアンインストールしますか？';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'ダブルタップしてすべての$typeを検索';
  }

  @override
  String get show_nav_double_tap_tooltip => 'ダブルタップ検索のヒントを表示';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'マンガ/アニメ/ノベルのナビゲーションで、ダブルタップで全体検索が開くことを示すツールチップを表示します。';

  @override
  String already_in_library(Object source, Object title) {
    return '「$title」はすでに$source経由でライブラリに存在します。';
  }

  @override
  String get add_anyway => 'それでも追加';

  @override
  String get langauage => '言語';

  @override
  String get extension_detail => '拡張機能の詳細';

  @override
  String get scale_type => 'スケールタイプ';

  @override
  String get scale_type_fit_screen => '画面にフィット';

  @override
  String get scale_type_stretch => 'ストレッチ';

  @override
  String get scale_type_fit_width => '幅にフィット';

  @override
  String get scale_type_fit_height => '高さにフィット';

  @override
  String get scale_type_original_size => 'オリジナルサイズ';

  @override
  String get scale_type_smart_fit => 'スマートフィット';

  @override
  String get page_preload_amount => 'ページプリロード量';

  @override
  String get page_preload_amount_subtitle =>
      '読取時にプリロードするページ数。値が高いほど、スムーズな読取体験が得られます。ただし、キャッシュとネットワーク使用量が増加します。';

  @override
  String get image_loading_error => 'この画像を読み込めませんでした';

  @override
  String get add_episodes => 'エピソードを追加';

  @override
  String get video_quality => '品質';

  @override
  String get video_subtitle => '字幕';

  @override
  String get check_for_extension_updates => '拡張機能の更新を確認';

  @override
  String get auto_extensions_updates => '自動拡張機能更新';

  @override
  String get auto_extensions_updates_subtitle =>
      '新しいバージョンが利用可能な場合は、拡張機能を自動的に更新します。';

  @override
  String get check_for_app_updates => '起動時にアプリ更新を確認';

  @override
  String get reading_mode => '読取モード';

  @override
  String get custom_filter => 'カスタムフィルター';

  @override
  String get background_color => '背景色';

  @override
  String get white => '白';

  @override
  String get black => '黒';

  @override
  String get grey => 'グレー';

  @override
  String get automaic => '自動';

  @override
  String get preferred_domain => '推奨ドメイン';

  @override
  String get load_more => 'もっと読み込む';

  @override
  String get cancel_all_for_this_series => 'このシリーズのすべてをキャンセル';

  @override
  String get login => 'ログイン';

  @override
  String login_into(Object tracker) {
    return '$trackerにログイン';
  }

  @override
  String get email_adress => 'メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String log_out_from(Object tracker) {
    return '$trackerからログアウトしますか？';
  }

  @override
  String get log_out => 'ログアウト';

  @override
  String get update_pending => '更新保留中';

  @override
  String get update_all => 'すべて更新';

  @override
  String get backup_and_restore => 'バックアップと復元';

  @override
  String get create_backup => 'バックアップを作成';

  @override
  String get create_backup_dialog_title => '何をバックアップしたいですか？';

  @override
  String get create_backup_subtitle => '現在のライブラリを復元するために使用できます';

  @override
  String get restore_backup => 'バックアップを復元';

  @override
  String get encrypt_backups => 'バックアップを暗号化';

  @override
  String get encrypt_backups_info => 'AES暗号化によりバックアップをパスワード保護します';

  @override
  String get no_secure_storage => '安全なストレージが見つかりません';

  @override
  String get no_keyring_warning =>
      'キーリングサービスがないためパスワードを安全に保存できません。\n\nローカルデータベースに暗号化なしで保存しますか？';

  @override
  String get enter_backup_password => 'バックアップパスワードを入力';

  @override
  String get incorrect_password_try_again => 'パスワードが正しくありません。再試行してください。';

  @override
  String get set_backup_password => 'バックアップパスワードを設定';

  @override
  String get confirm_password => 'パスワードを確認';

  @override
  String get passwords_do_not_match => 'パスワードが一致しません';

  @override
  String get password_required_to_restore => '復元にはパスワードが必要です。';

  @override
  String get restore_backup_subtitle => 'バックアップファイルからライブラリを復元';

  @override
  String get automatic_backups => '自動バックアップ';

  @override
  String get backup_frequency => 'バックアップ頻度';

  @override
  String get backup_location => 'バックアップロケーション';

  @override
  String get backup_options => 'バックアップオプション';

  @override
  String get backup_options_dialog_title => '何をバックアップしたいですか？';

  @override
  String get backup_options_subtitle => 'バックアップファイルに含める情報';

  @override
  String get backup_and_restore_warning_info =>
      'バックアップのコピーを他の場所にも保管することをお勧めします';

  @override
  String get library_entries => 'ライブラリエントリ';

  @override
  String get chapters_and_episode => 'チャプターとエピソード';

  @override
  String get every_6_hours => '6時間ごと';

  @override
  String get every_12_hours => '12時間ごと';

  @override
  String get daily => '毎日';

  @override
  String get every_2_days => '2日ごと';

  @override
  String get weekly => '週ごと';

  @override
  String get restore_backup_warning_title =>
      'バックアップを復元すると、すべての既存データが上書きされます。\\n\\n復元を続けますか？';

  @override
  String get restore_sync_question_title => 'この復元を同期しますか？';

  @override
  String get restore_sync_question_message => '復元されたデータを今すぐ同期サーバーにアップロードしますか？';

  @override
  String get restore_sync_question_confirm => 'はい、同期する';

  @override
  String get restore_sync_question_deny => 'いいえ、同期を無効化';

  @override
  String get sync_disabled_after_restore => '同期が無効になりました。設定から再度有効にできます。';

  @override
  String get restore_sync_disabled_question_title => '同期は現在無効です';

  @override
  String get restore_sync_disabled_question_message =>
      '同期を再有効化してサーバーにアップロードしますか？';

  @override
  String get restore_sync_question_reenable => 'はい、有効化して同期';

  @override
  String get restore_sync_question_keep_disabled => '無効のままにする';

  @override
  String get restore_sync_uploading => '復元データをサーバーに同期中…';

  @override
  String get restore_sync_upload_success => '復元データをサーバーに同期しました';

  @override
  String get services => 'サービス';

  @override
  String get tracking_warning_info =>
      'トラッキングサービスのチャプター進度を更新するための一方向同期。トラッキングボタンから個々のエントリの追跡を設定します。';

  @override
  String get use_page_tap_zones => 'ページタップゾーンを使用';

  @override
  String get manage_trackers => 'トラッカーを管理';

  @override
  String get restore => '復元';

  @override
  String get backups => 'バックアップ';

  @override
  String get by_scanlator => 'スキャンレーター別';

  @override
  String get by_name => '名前別';

  @override
  String get installed => 'インストール済み';

  @override
  String get auto_scroll => '自動スクロール';

  @override
  String get video_audio => 'オーディオ';

  @override
  String get video_audio_info => '優先言語、ピッチ補正、オーディオチャンネル';

  @override
  String get player => 'プレーヤー';

  @override
  String get markEpisodeAsSeenSetting => 'エピソードを視聴済みにするタイミング';

  @override
  String get mark_duplicate_chapters_read => '重複する章番号を読済みとしてマーク';

  @override
  String get default_skip_intro_length => 'デフォルトイントロスキップ長';

  @override
  String get default_playback_speed_length => 'デフォルト再生速度長';

  @override
  String get updateProgressAfterReading => '読後にプログレスを更新';

  @override
  String get no_sources_installed => 'ソースがインストールされていません！';

  @override
  String get show_extensions => '拡張機能を表示';

  @override
  String get default_skip_forward_skip_length => 'デフォルトスキップフォワードスキップ長';

  @override
  String get aniskip_requires_info =>
      'AniSkipを機能させるには、アニメをMALまたはAnilistで追跡する必要があります。';

  @override
  String get enable_aniskip => 'AniSkipを有効化';

  @override
  String get enable_auto_skip => '自動スキップを有効化';

  @override
  String get aniskip_button_timeout => 'ボタンタイムアウト';

  @override
  String get skip_opening => 'オープニングをスキップ';

  @override
  String get skip_ending => 'エンディングをスキップ';

  @override
  String get fullscreen => 'フルスクリーン';

  @override
  String get update_library => 'ライブラリを更新';

  @override
  String get next_chapter => '次のチャプター';

  @override
  String get next_5_chapters => '次の5チャプター';

  @override
  String get next_10_chapters => '次の10チャプター';

  @override
  String get next_25_chapters => '次の25チャプター';

  @override
  String get all_chapters => 'すべてのチャプター';

  @override
  String get next_episode => '次のエピソード';

  @override
  String get next_5_episodes => '次の5エピソード';

  @override
  String get next_10_episodes => '次の10エピソード';

  @override
  String get next_25_episodes => '次の25エピソード';

  @override
  String get all_episodes => 'すべてのエピソード';

  @override
  String get cover_saved => 'カバーを保存しました';

  @override
  String get set_as_cover => 'カバーに設定';

  @override
  String get use_this_as_cover_art => 'これをカバーアートとして使用しますか？';

  @override
  String get save => '保存';

  @override
  String get picture_saved => '画像を保存しました';

  @override
  String get cover_updated => 'カバーを更新しました';

  @override
  String get include_subtitles => '字幕を含める';

  @override
  String get blend_mode_default => 'デフォルト';

  @override
  String get blend_mode_multiply => '乗算';

  @override
  String get blend_mode_screen => 'スクリーン';

  @override
  String get blend_mode_overlay => 'オーバーレイ';

  @override
  String get blend_mode_colorDodge => 'ColorDodge';

  @override
  String get blend_mode_lighten => '明るく';

  @override
  String get blend_mode_colorBurn => 'ColorBurn';

  @override
  String get blend_mode_darken => '暗く';

  @override
  String get blend_mode_difference => '差';

  @override
  String get blend_mode_saturation => '彩度';

  @override
  String get blend_mode_softLight => 'SoftLight';

  @override
  String get blend_mode_plus => 'プラス';

  @override
  String get blend_mode_exclusion => '除外';

  @override
  String get custom_color_filter => 'カスタムカラーフィルター';

  @override
  String get color_filter_blend_mode => 'カラーフィルターブレンドモード';

  @override
  String get enable_all => 'すべて有効化';

  @override
  String get disable_all => 'すべて無効化';

  @override
  String get font => 'フォント';

  @override
  String get color => '色';

  @override
  String get font_size => 'フォントサイズ';

  @override
  String get text => 'テキスト';

  @override
  String get border => '境界線';

  @override
  String get background => '背景';

  @override
  String get no_subtite_warning_message => 'このビデオには字幕トラックがないため効果はありません';

  @override
  String get grid_size => 'グリッドサイズ';

  @override
  String n_per_row(Object n) {
    return '1行あたり$n個';
  }

  @override
  String get horizontal_continious => '横スクロール連続';

  @override
  String get edit_code => 'コードを編集';

  @override
  String get use_libass => 'libassを有効化';

  @override
  String get use_libass_info => 'ネイティブバックエンドにlibassベースの字幕レンダリングを使用します。';

  @override
  String get libass_not_disable_message =>
      '字幕をカスタマイズできるようにするには、プレーヤー設定で「libassを使用」を無効にしてください。';

  @override
  String get override_ass_subtitles => 'ASS字幕をオーバーライド';

  @override
  String get override_ass_subtitles_info => 'ASS/SSA字幕にカスタムスタイルを適用';

  @override
  String get torrent_stream => 'トレントストリーム';

  @override
  String get add_torrent => 'トレントを追加';

  @override
  String get enter_torrent_hint_text => 'マグネットまたはトレントファイルurlを入力';

  @override
  String get torrent_url => 'トレントurl';

  @override
  String get or => 'または';

  @override
  String get advanced => '詳細設定';

  @override
  String get advanced_info => 'mpv設定';

  @override
  String get use_native_http_client => 'ネイティブhttpクライアントを使用';

  @override
  String get use_native_http_client_info =>
      'VPNのようなプラットフォーム機能を自動的にサポートし、HTTP/3のようなより多くのHTTP機能をサポートし、カスタムリダイレクト処理';

  @override
  String n_hour_ago(Object hour) {
    return '$hour時間前';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours時間前';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute分前';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes分前';
  }

  @override
  String n_day_ago(Object day) {
    return '$day日前';
  }

  @override
  String get now => '今';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'ライブラリ最終更新: $lastUpdated';
  }

  @override
  String get data_and_storage => 'データとストレージ';

  @override
  String get download_location_info => 'チャプターダウンロードに使用';

  @override
  String get storage => 'ストレージ';

  @override
  String get clear_chapter_and_episode_cache => 'チャプターとエピソードキャッシュをクリア';

  @override
  String get cache_cleared => 'キャッシュをクリアしました';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'アプリ起動時にチャプター/エピソードキャッシュをクリア';

  @override
  String get app_settings => 'アプリ設定';

  @override
  String get sources_settings => 'ソース設定';

  @override
  String get include_sensitive_settings => '機密設定を含める（例：トラッカーログイントークン）';

  @override
  String get create => '作成';

  @override
  String get downloads_are_limited_to_wifi => 'ダウンロードはWi-Fiに制限されています';

  @override
  String get recommendations => 'おすすめ';

  @override
  String get recommendations_similar => '類似';

  @override
  String get recommendations_weights => 'おすすめの重み';

  @override
  String get recommendations_weights_genre => 'ジャンル類似度';

  @override
  String get recommendations_weights_setting => '設定類似度';

  @override
  String get recommendations_weights_synopsis => 'あらすじ類似度';

  @override
  String get recommendations_weights_theme => 'テーマ類似度';

  @override
  String get manga_extensions_repo => 'マンガ拡張機能リポジトリ';

  @override
  String get anime_extensions_repo => 'アニメ拡張機能リポジトリ';

  @override
  String get novel_extensions_repo => '小説拡張機能リポジトリ';

  @override
  String get custom_dns => 'カスタムDNS（システムDNSを使用する場合は空のままにしてください）';

  @override
  String get android_proxy_server => 'Androidプロキシサーバー（M-Extension-Server）';

  @override
  String get get_m_extension_server => 'M-Extension-Serverを入手';

  @override
  String get undefined => '未定義';

  @override
  String get empty_extensions_repo => 'リポジトリURLがありません。追加するにはプラスボタンをクリックしてください！';

  @override
  String get add_extensions_repo => 'リポジトリURLを追加';

  @override
  String get remove_extensions_repo => 'リポジトリURLを削除';

  @override
  String get manage_manga_repo_urls => 'マンガリポジトリURLを管理';

  @override
  String get manage_anime_repo_urls => 'アニメリポジトリURLを管理';

  @override
  String get manage_novel_repo_urls => '小説リポジトリURLを管理';

  @override
  String get url_cannot_be_empty => 'URLは空にできません';

  @override
  String get url_must_end_with_dot_json_or_dot_pb => 'URLは.jsonで終わる必要があります';

  @override
  String get repo_url => 'リポジトリURL';

  @override
  String get invalid_url_format => '無効なURL形式';

  @override
  String get clear_all_sources => 'すべてのソースをクリア';

  @override
  String get clear_all_sources_msg =>
      'これによりアプリケーションのすべてのソースが完全に削除されます。続行してもよろしいですか？';

  @override
  String get sources_cleared => 'ソースがクリアされました！！！';

  @override
  String get repo_added => 'ソースリポジトリが追加されました！';

  @override
  String get repo_already_exists => 'リポジトリは既に存在します！';

  @override
  String get add_repo => 'リポジトリを追加しますか？';

  @override
  String get add_repo_sources_to_add => '追加される拡張子リスト:';

  @override
  String get add_repo_warning =>
      'これらのリポジトリからの拡張機能は、アプリ内で実行される。信頼できるリポジトリのみを追加してください。';

  @override
  String get genre_search_library => 'ライブラリでジャンル検索';

  @override
  String get genre_search_source => 'ソースでブラウズ';

  @override
  String get source_not_added => 'ソースがインストールされていません！';

  @override
  String get load_own_subtitles => '独自の字幕を読み込む...';

  @override
  String get search_subtitles => 'オンラインで字幕を検索...';

  @override
  String extension_notes(Object notes) {
    return '注：$notes';
  }

  @override
  String get unsupported_repo =>
      'このソースリポジトリを追加できませんでした。リポジトリのアドレスを確認するか、管理者にお問い合わせください。';

  @override
  String get you_have_finished_reading => '読了しました';

  @override
  String get hwdec => 'ハードウェアデコーダー';

  @override
  String get enable_hardware_accel => 'ハードウェアアクセラレーション';

  @override
  String get enable_hardware_accel_info => 'バグやクラッシュが発生している場合はオン/オフを切り替えてください';

  @override
  String get track_library_navigate => '既存のローカルエントリに移動';

  @override
  String get track_library_add => 'ローカルライブラリに追加';

  @override
  String get track_library_add_confirm => '追跡アイテムをローカルライブラリに追加';

  @override
  String get track_library_not_logged => 'この機能を使用するには、対応するトラッカーにログインしてください！';

  @override
  String get track_library_switch => '別のトラッカーに切り替え';

  @override
  String get go_back => '戻る';

  @override
  String get merge_library_nav_mobile => 'モバイルでライブラリナビゲーションを統合';

  @override
  String get enable_discord_rpc => 'Discord RPCを有効化';

  @override
  String get hide_discord_rpc_incognito => 'シークレットモードでDiscord RPCを非表示';

  @override
  String get rpc_show_reading_watching_progress =>
      'Discordに現在のチャプターを表示（再起動が必要）';

  @override
  String get rpc_show_title => 'Discordに現在のタイトルを表示';

  @override
  String get rpc_show_cover_image => 'Discordに現在のカバー画像を表示';

  @override
  String get enable_mpv => 'mpvシェーダー/スクリプトを有効化';

  @override
  String get mpv_info => 'mpv/scripts/配下の.jsスクリプトをサポート';

  @override
  String get mpv_redownload => 'mpv設定ファイルを再ダウンロード';

  @override
  String get mpv_redownload_info => '古い設定ファイルを新しいものに置き換えます！';

  @override
  String get mpv_download => 'MPV設定ファイルが必要です！\n今すぐダウンロードしますか？';

  @override
  String get custom_buttons => 'カスタムボタン';

  @override
  String get custom_buttons_info => 'カスタムボタンでluaコードを実行';

  @override
  String get custom_buttons_edit => 'カスタムボタンを編集';

  @override
  String get custom_buttons_add => 'カスタムボタンを追加';

  @override
  String get custom_buttons_added => 'カスタムボタンが追加されました！';

  @override
  String get custom_buttons_delete => 'カスタムボタンを削除';

  @override
  String get custom_buttons_text => 'ボタンテキスト';

  @override
  String get custom_buttons_text_req => 'ボタンテキストが必要です';

  @override
  String get custom_buttons_js_code => 'luaコード';

  @override
  String get custom_buttons_js_code_req => 'luaコードが必要です';

  @override
  String get custom_buttons_js_code_long => 'luaコード（長押し時）';

  @override
  String get custom_buttons_startup => 'luaコード（起動時）';

  @override
  String get custom_buttons_add_warning =>
      'このボタンは、ビデオ プレーヤーで以下の Lua コードを実行し、ファイルにアクセスしてプログラムを実行できます。このリンクの出所が信頼できる場合にのみ追加してください。';

  @override
  String n_days(Object n) {
    return '$n日';
  }

  @override
  String get decoder => 'デコーダー';

  @override
  String get decoder_info => 'ハードウェアデコーディング、ピクセル形式、デバンディング';

  @override
  String get enable_gpu_next => 'gpu-nextを有効化（Androidのみ）';

  @override
  String get enable_gpu_next_info => '新しいビデオレンダリングエンジン';

  @override
  String get debanding => 'デバンディング';

  @override
  String get use_yuv420p => 'YUV420Pピクセル形式を使用';

  @override
  String get use_yuv420p_info =>
      '一部のビデオコーデックで黒い画面を修正し、品質を犠牲にしてパフォーマンスを向上させることもできます';

  @override
  String get audio_preferred_languages => '優先言語';

  @override
  String get audio_preferred_languages_info =>
      '複数のオーディオストリームを持つビデオでデフォルトで選択されるオーディオ言語、2/3文字の言語コード（例：ja、en）。複数の値はカンマで区切ることができます。';

  @override
  String get enable_audio_pitch_correction => 'オーディオピッチ補正を有効化';

  @override
  String get enable_audio_pitch_correction_info =>
      '高速再生時にオーディオが高音になり、低速再生時に低音になるのを防ぎます';

  @override
  String get audio_channels => 'オーディオチャンネル';

  @override
  String get volume_boost_cap => '音量ブーストキャップ';

  @override
  String get internal_player => '内蔵プレーヤー';

  @override
  String get internal_player_info => '進行状況、コントロール、向き';

  @override
  String get subtitle_delay_text => '字幕遅延';

  @override
  String get subtitle_delay => '遅延（ms）';

  @override
  String get subtitle_speed => '速度';

  @override
  String get tracks => 'トラック';

  @override
  String get playback_speed => '再生速度';

  @override
  String get shaders => 'シェーダー';

  @override
  String get video_fit => '画面サイズに合わせる';

  @override
  String get calendar => 'カレンダー';

  @override
  String get calendar_no_data => 'まだデータがありません。';

  @override
  String get calendar_info =>
      'カレンダーは過去のアップロードに基づいて次のチャプターアップロードを予測できるだけです。一部のデータは100％正確ではない可能性があります！';

  @override
  String in_n_day(Object days) {
    return '$days日後';
  }

  @override
  String in_n_days(Object days) {
    return '$days日後';
  }

  @override
  String get clear_library => 'ライブラリをクリア';

  @override
  String get clear_library_desc => 'すべてのマンガ、アニメ、および/または小説エントリをクリアする選択';

  @override
  String get clear_library_input =>
      'すべての関連エントリを削除するには「manga」、「anime」、および/または「novel」と入力してください（カンマ区切り）';

  @override
  String get watch_order => '視聴順';

  @override
  String get watch_order_role_current => '現在';

  @override
  String get watch_order_role_previous => '前へ';

  @override
  String get watch_order_role_next => '次へ';

  @override
  String get watch_order_source_release_order => 'リリース命令';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name by $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return '公式 Trakt コレクション: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt コレクション: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return '$titleの季節';
  }

  @override
  String get watch_order_select_source => '注文元';

  @override
  String watch_order_season(int number) {
    return 'シーズン$number';
  }

  @override
  String watch_order_episode(int number) {
    return 'エピソード$number';
  }

  @override
  String get sequels => '続編';

  @override
  String get recommendations_similarity => '類似度：';

  @override
  String recommendation_rating_accessibility(String rating) {
    return '評価$rating';
  }

  @override
  String get local_folder_structure => 'ローカルフォルダ構造';

  @override
  String get local_folder => 'ローカルフォルダ';

  @override
  String get add_local_folder => 'ローカルフォルダを追加';

  @override
  String get rescan_local_folder => 'すべてのローカルフォルダを今すぐ再スキャン';

  @override
  String get default_download_destination => 'デフォルトのダウンロード先';

  @override
  String get ask_download_destination => 'ダウンロード先を毎回確認';

  @override
  String get ask_download_destination_desc => 'ダウンロード開始時にフォルダを選択します。';

  @override
  String get select_download_destination => 'ダウンロード先を選択';

  @override
  String get clear_local_library => 'ローカルライブラリをクリア';

  @override
  String get clear_local_library_desc => 'ローカルフォルダおよびアーカイブをライブラリから削除します。';

  @override
  String get clear_local_library_msg => 'ライブラリから削除されます（ファイル自体は削除されません）。';

  @override
  String get custom => 'カスタム';

  @override
  String get no_local_folder_available_for_downloads => '利用可能なダウンロードフォルダがありません';

  @override
  String failed_to_create_cbz(Object error) {
    return 'CBZの作成に失敗しました: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'カバー画像の読み込みエラー: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'メタデータの読み込みエラー: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'ライブラリ保存エラー: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return '章カバー画像の読み込みエラー: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'アーカイブカバー画像の読み込みエラー: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'ローカルライブラリ取得エラー: $error';
  }

  @override
  String get export_metadata => 'メタデータをエクスポート';

  @override
  String get exported => 'エクスポートしました';

  @override
  String failed_to_export_metadata(Object error) {
    return 'メタデータのエクスポートに失敗: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count話の番号を自動取得できませんでした。';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Cloudflare解決サーバーを起動できませんでした。';

  @override
  String tracker_token_expired(Object tracker) {
    return '$trackerのトークンが期限切れです';
  }

  @override
  String get video_list_empty => '動画リストが空です';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return '$url を開けませんでした';
  }

  @override
  String get text_size => 'テキストサイズ：';

  @override
  String get text_align => 'テキスト配置';

  @override
  String get line_height => '行の高さ';

  @override
  String get show_scroll_percentage => 'スクロール率を表示';

  @override
  String get remove_extra_paragraph_spacing => '余分な段落間隔を削除';

  @override
  String select_label_color(Object label) {
    return '$labelの色を選択';
  }

  @override
  String get default_user_agent => '既定のユーザーエージェント';

  @override
  String get forceLandscapeMode => 'ランドスケープモードを強制';

  @override
  String get forceLandscapeModeSubtitle => 'プレーヤーを強制的にランドスケープ向きで使用させます。';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNSプロバイダー';

  @override
  String get tracked => '追跡中';

  @override
  String get auth_unlock_msg => 'NodeLane Comicsのロックを解除するために認証してください';

  @override
  String get app_locked => 'NodeLane Comicsはロックされています';

  @override
  String get auth_to_continue => '続行するために認証してください';

  @override
  String get authenticating => '認証中です...';

  @override
  String get lock => 'ロック';

  @override
  String get unlock => 'ロック解除';

  @override
  String get security => 'セキュリティ';

  @override
  String get auth_to_change_security_setting => 'セキュリティ設定を変更するために認証してください';

  @override
  String get app_lock => 'アプリのロック';

  @override
  String get require_biometric_or_device_credential =>
      'アプリを開くには、生体認証またはデバイスの認証情報が必要です';

  @override
  String get biometric_or_device_credential_not_available =>
      'このデバイスでは生体認証は使用できません';

  @override
  String get app_lock_description =>
      'アプリのロックが有効な場合、アプリを開くたびに認証するよう求められます\\nバックグラウンドから戻る場合。';

  @override
  String get checking_device_authentication => 'デバイス認証を確認しています…';

  @override
  String get device_authentication_incomplete => '認証が完了しませんでした。設定は変更されていません。';

  @override
  String get keep_screen_on => '画面をオンに保つ';

  @override
  String get webtoon_side_padding => 'ウェブトゥーンのサイドパディング';

  @override
  String get show_page_gaps => 'ページギャップを表示';

  @override
  String get invert_colors => '色を反転';

  @override
  String get grayscale => 'グレースケール';

  @override
  String get brightness => '明るさ';

  @override
  String get contrast => 'コントラスト';

  @override
  String get saturation => '彩度';

  @override
  String get navigation_layout => 'ナビゲーションレイアウト';

  @override
  String get nav_layout_default => '既定';

  @override
  String get nav_layout_l_shaped => 'L字型';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'エッジ';

  @override
  String get nav_layout_right_and_left => '右と左';

  @override
  String get nav_layout_disabled => '無効';

  @override
  String get color_enhancements => '色の強化';

  @override
  String get total => '合計';

  @override
  String get mean_per_title => 'タイトルごとの平均';

  @override
  String get completion_rate => '完了率';

  @override
  String get watching_time => '視聴時間';

  @override
  String get reading_time => '読書時間';

  @override
  String average_chapters_per_title(Object title) {
    return '$title あたりの平均チャプター数';
  }

  @override
  String get read_percentage => '読みの割合';

  @override
  String get entries => 'エントリ';

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
  String get up_to_date => '最新';

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
  String get zero_interpreter => 'Zero インタープリタ';

  @override
  String get zero_interpreter_description => 'Zero インタープリタサーバーを制御します。';

  @override
  String get start_server_on_launch => '起動時にサーバーを開始';

  @override
  String get runtime_status => '実行状態';

  @override
  String get running => '実行中';

  @override
  String get stopped => '停止';

  @override
  String get start => '開始';

  @override
  String get stop => '停止';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'テキスト読み上げ';

  @override
  String get tts_speed => '速度';

  @override
  String get tts_pitch => 'ピッチ';

  @override
  String get tts_language => '言語';

  @override
  String get tts_voice => 'ボイス';

  @override
  String get tts_stop => '停止';

  @override
  String get tts_play => '再生';

  @override
  String get tts_pause => '一時停止';

  @override
  String get tts_previous => '前の段落';

  @override
  String get tts_next => '次の段落';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return '段落$current/$total';
  }

  @override
  String get tts_settings => 'TTS設定';

  @override
  String get tts_default => 'デフォルト';

  @override
  String get webtoon_disable_zoom_out => 'Webtoonの縮小を無効化';

  @override
  String get webtoon_double_tap_zoom_enabled => 'Webtoonダブルタップズーム';

  @override
  String get navigate_to_pan => 'ナビゲーションをスクロールに変換';

  @override
  String get navigate_to_pan_subtitle => 'ページをめくる前に拡大した画像を移動する';

  @override
  String get split_wide_pages => '見開きページを分割';

  @override
  String get dual_page_invert => '分割した半ページの左右を反転';

  @override
  String get dual_page_rotate_to_fit => '画面に合わせて回転';

  @override
  String get dual_page_rotate_to_fit_invert => '回転方向を反転';

  @override
  String get double_page_single_first_page => '最初のページを単独表示';

  @override
  String get double_page_single_first_page_subtitle =>
      '見開きモードで最初のページ（表紙）を単独で表示する';

  @override
  String get double_page_auto => '自動見開き表示';

  @override
  String get double_page_auto_subtitle => '横向き時に自動で見開き表示モードに切り替える';

  @override
  String get landscape_zoom => '横画面自動ズーム';

  @override
  String get zoom_start_position => 'ズーム開始位置';

  @override
  String get zoom_start_left => '左';

  @override
  String get zoom_start_right => '右';

  @override
  String get zoom_start_center => '中央';

  @override
  String get automatic_background => '自動背景色';

  @override
  String get tapping_inversion => 'タップ反転';

  @override
  String get tapping_inversion_none => 'なし';

  @override
  String get tapping_inversion_horizontal => '横方向';

  @override
  String get tapping_inversion_vertical => '縦方向';

  @override
  String get tapping_inversion_both => '両方';

  @override
  String get flash_on_page_change => 'ページ切り替え時に点滅';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED焼き付き防止アシスタント';

  @override
  String get flash_color => '点滅の色';

  @override
  String get flash_color_black => '黒';

  @override
  String get flash_color_white => '白';

  @override
  String get flash_color_white_black => '白 & 黒';

  @override
  String get flash_interval_label => '点滅間隔';

  @override
  String flash_interval_value(String n) {
    return '$nページ';
  }

  @override
  String flash_interval(String n) {
    return '点滅間隔：$nページ';
  }

  @override
  String get flash_duration_label => '点滅時間';

  @override
  String flash_duration_value(String n) {
    return '$nミリ秒';
  }

  @override
  String flash_duration(String n) {
    return '点滅時間：$nミリ秒';
  }

  @override
  String get show_navigation_overlay_on_start => '起動時にナビゲーションオーバーレイを表示';

  @override
  String get reader_hide_threshold => 'リーダーを隠す閾値';

  @override
  String get reader_hide_threshold_highest => '最も高い (5 px)';

  @override
  String get reader_hide_threshold_high => '高い (13 px)';

  @override
  String get reader_hide_threshold_low => '低い (31 px)';

  @override
  String get reader_hide_threshold_lowest => '最も低い (47 px)';

  @override
  String get error_no_pages_available => 'エラー：利用可能なページがありません';

  @override
  String get app_ui_scale => 'インターフェーススケール';

  @override
  String get app_ui_scale_subtitle =>
      'インターフェースをお使いのスクリーンと視聴距離に合わせて大きくまたは小さくします。';

  @override
  String get allow_concurrent_downloads => '同時ダウンロードを許可';

  @override
  String get allow_concurrent_downloads_subtitle =>
      '異なるソースから同時にダウンロードします。1つのソースは依然として一度に1つの章をダウンロードするため、過負荷になりません。すべての場所で1つずつダウンロードするには、オフにしてください。';

  @override
  String get download_delay => 'ダウンロード遅延';

  @override
  String get download_delay_subtitle =>
      'オフ。ソースに優しくするために、章間にランダムジッターを伴う待機を追加します。';

  @override
  String get save_search => '検索を保存';

  @override
  String get saved_searches => '保存済み検索';

  @override
  String get enter_search_to_save_first => 'まず検索を入力して保存してください';

  @override
  String get no_saved_searches =>
      'このソースの保存済み検索はまだありません。\n検索を実行してから、「検索を保存」を選択してください。';

  @override
  String get source => 'ソース';

  @override
  String get something_went_wrong => '問題が発生しました';

  @override
  String get startup_failed => 'NodeLane Comicsの起動に失敗しました';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のソースで結果なし',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'どのようにインポートしますか？';

  @override
  String get import_mode_message => '現在のライブラリに統合するか、完全に置き換えるか選択してください。';

  @override
  String get import_mode_keep_existing => '統合';

  @override
  String get import_mode_keep_existing_subtitle => '新しい作品を追加し、一致するものを更新します。';

  @override
  String get import_mode_replace => '置換';

  @override
  String get import_mode_replace_subtitle => '現在のライブラリを削除しバックアップで置き換えます。';

  @override
  String get replace_summary_title => 'ライブラリを置き換える準備ができました';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return '現在の$currentCount作品を削除し、バックアップの$backupCount作品に置き換えます。';
  }

  @override
  String get replace_summary_confirm => '置換';

  @override
  String replace_result_message(Object count) {
    return 'ライブラリを$count作品に置き換えました。';
  }

  @override
  String get category_conflict_title => '既存のカテゴリが見つかりました';

  @override
  String get category_conflict_message => 'バックアップに既存のカテゴリが含まれています。';

  @override
  String get category_conflict_keep => '保持 — 既存カテゴリに統合';

  @override
  String get category_conflict_delete => '削除 — 未分類にする';

  @override
  String get source_conflict_title => 'ソースが見つかりません';

  @override
  String get source_conflict_message => '一部のソースに対応する拡張機能がありません。';

  @override
  String get source_conflict_keep => '元の名前を保持';

  @override
  String get import_summary_title => 'インポート準備完了';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '新規$newSeries作品、更新$updatedSeries作品、新規$newChapters話を追加します。';
  }

  @override
  String get import_summary_confirm => 'インポート';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '新規$newSeries作品、更新$updatedSeries作品、$newChapters話を追加しました。';
  }

  @override
  String get roll_back => 'ロールバック';

  @override
  String get roll_back_confirm_message => '変更前のスナップショットにライブラリを復元します。';

  @override
  String get roll_back_done => '以前のスナップショットにロールバックしました。';

  @override
  String get restoring_backup => 'ライブラリを復元中…';

  @override
  String get roll_back_last_change => '前回の変更をロールバック';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return '$date のスナップショット — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return 'ロールバック可能な変更: $count件';
  }

  @override
  String get delete_source_title => 'ソースと作品を削除';

  @override
  String get delete_source_subtitle => '選択したソースの作品、話、ダウンロード、履歴をすべて削除します。';

  @override
  String get delete_source_pick_title => '削除するソースを選択';

  @override
  String get delete_source_empty => 'ライブラリにソースが見つかりません。';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '$sourceNameを削除しますか？';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'これにより、$mangaCount マンガ、$chapterCount 章、$historyCount 履歴エントリ、$updateCount 更新エントリが完全に削除されます。追跡リンクは保持されます。これを元に戻すには、ロールバックする必要があります。';
  }

  @override
  String get delete_source_also_remove_extension => 'インストール済み拡張機能も削除';

  @override
  String get delete_source_keep_history => '読書履歴を保持';

  @override
  String get delete_source_keep_downloads => 'ダウンロード記録を保持';

  @override
  String get delete_source_button => '削除';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '$sourceNameから$mangaCount作品を削除しました。';
  }

  @override
  String get merge_manga_title => '重複作品を統合';

  @override
  String get merge_manga_subtitle => '同じソース内の同名作品を統合します。';

  @override
  String get merge_manga_none_found => '重複作品は見つかりませんでした。';

  @override
  String get merge_manga_pick_title => '重複の可能性がある作品';

  @override
  String get merge_manga_choose_primary_title => 'どの作品に統合しますか？';

  @override
  String get merge_manga_choose_primary_message => '話、履歴、追跡情報が選択した作品に集約されます。';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 話',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => '統合';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '$count件の重複作品を$mangaNameに統合しました。';
  }

  @override
  String get merge_preview_title => '統合の確認';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters 章が他のエントリ全体で見つかりました。 $duplicateChapters は重複しているため、削除されます (読み取りが進行しているコピーを保持します)。 $keptChapters が追加されます。 $duplicateTracks 重複したトラッキング リンクも削除されます。';
  }

  @override
  String get memory_overlay => 'メモリ使用量を表示';

  @override
  String get memory_overlay_subtitle =>
      'アプリが保持しているメモリのリアルタイム表示。推測ではなく端末上で測定するために、ライブラリのスクロールや閲覧中に確認できます。';

  @override
  String get beta => 'ベータ';

  @override
  String get error_reports => 'エラーレポート';

  @override
  String get error_reports_subtitle => 'アプリで発生したエラーの確認と報告';

  @override
  String get error_reports_empty => 'エラーはありません。';

  @override
  String get error_reports_likely_cause => '考えられる原因';

  @override
  String get error_reports_report => 'GitHubで報告';

  @override
  String get error_reports_banner => 'エラーが発生しました';

  @override
  String get error_reports_banner_action => '表示';

  @override
  String get error_reports_copy => 'コピー';

  @override
  String get error_reports_copied => 'クリップボードにコピーしました';

  @override
  String get error_reports_clear => 'クリア';

  @override
  String get error_reports_extension_failure =>
      'これはNodeLane Comicsではなく拡張機能に起因するエラーです。拡張機能はインストール元のリポジトリ管理者によって作成・管理されているため、そちらで修正する必要があります。ソース名と開こうとした項目を伝えると役立ちます。';

  @override
  String get error_reports_already_reported => '報告済み';

  @override
  String get error_reports_expected_failure =>
      'これは通常、アプリではなくソースまたはネットワークの問題です（リンクの期限切れ、サーバーダウン、接続切断など）。他では動作しているソースで発生し続ける場合にのみ報告することをお勧めします。';

  @override
  String get share_unavailable_copied => '共有機能が利用できないためクリップボードにコピーしました。';

  @override
  String get onboarding_title => 'NodeLane Comicsへようこそ';

  @override
  String get onboarding_libraries_body => '読みたいもの、観たいものを選択してください。';

  @override
  String get onboarding_nav_title => 'ライブラリ';

  @override
  String get onboarding_nav_body => '個別のタブで表示するか、1つのライブラリタブにまとめるか選択できます。';

  @override
  String get onboarding_nav_split => '個別のタブ';

  @override
  String get onboarding_nav_merged => '1つのライブラリタブ';

  @override
  String get onboarding_nav_inside => 'ライブラリをタップして切り替え';

  @override
  String get onboarding_next => '次へ';

  @override
  String get onboarding_restore => 'バックアップを復元';

  @override
  String get onboarding_or_local => 'または手持ちのファイルを使用';

  @override
  String get onboarding_local_folder => 'フォルダを追加';

  @override
  String onboarding_local_existing(Object count) {
    return '設定済みフォルダ: $count個';
  }

  @override
  String get onboarding_local_any_type => 'マンガ、アニメ、小説に対応しています。';

  @override
  String get onboarding_local_scanning => 'フォルダをスキャン中';

  @override
  String onboarding_local_found(Object count) {
    return '$count作品見つかりました';
  }

  @override
  String get onboarding_local_remove => 'フォルダを削除';

  @override
  String get onboarding_local_in_downloads => 'これはアプリのダウンロードフォルダです。';

  @override
  String get onboarding_local_empty => '見つかりませんでした。親フォルダを選択してください。';

  @override
  String get onboarding_repo_failed => 'リポジトリを読み込めませんでした。';

  @override
  String get onboarding_repo_title => 'ソースを追加';

  @override
  String get onboarding_body => 'リポジトリを追加して拡張機能をインストールしましょう。';

  @override
  String get onboarding_add => 'リポジトリを追加';

  @override
  String get onboarding_skip => '今はスキップ';

  @override
  String get onboarding_continue => '続ける';

  @override
  String get onboarding_later => '設定 > 閲覧から後で追加できます。';

  @override
  String get onboarding_replay => 'ウェルカム画面を表示';

  @override
  String get onboarding_replay_subtitle => '初期設定画面を再度開きます。';

  @override
  String get missing_source_check_title => '不足しているソースを確認';

  @override
  String get missing_source_check_subtitle => '拡張機能が未インストールの作品を検出します。';

  @override
  String get missing_source_check_none_found => 'すべてのソースがインストールされています。';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のソースが未インストール',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return '$itemTypeのソースがインストールされていません。';
  }

  @override
  String get global_search_no_sources_hint =>
      '「ブラウズ」でリポジトリを追加し、拡張機能をインストールしてください。';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件',
    );
    return '対象のソースが$_temp0ありますが、固定されたソースのみが検索されます。';
  }

  @override
  String get global_search_only_pinned_hint =>
      'ソースをピン留めするか、ブラウズ設定で「固定されたソースのみ含める」を無効にしてください。';

  @override
  String get global_search_all_nsfw => 'この項目のすべてのソースがNSFWに設定されており、非表示になっています。';

  @override
  String get global_search_all_nsfw_hint => '検索するにはブラウズ設定でNSFWソースを有効にしてください。';

  @override
  String get missing_source_check_result_message =>
      'これらの作品のソースがインストールされていません。移行するか拡張機能をインストールしてください。';

  @override
  String get related_titles => '関連作品';

  @override
  String get related_none => 'この作品に関連する作品は見つかりませんでした。';

  @override
  String get relation_adaptation => 'メディアミックス';

  @override
  String get relation_sequel => '続編';

  @override
  String get relation_prequel => '前日譚';

  @override
  String get relation_parent => '本編';

  @override
  String get relation_side_story => '外伝';

  @override
  String get relation_spin_off => 'スピンオフ';

  @override
  String get relation_alternative => '別バージョン';

  @override
  String get auto_library_update => 'ライブラリの自動更新';

  @override
  String get auto_library_update_subtitle =>
      'アプリ起動時にライブラリ内のすべての作品の最新話をチェックします。';

  @override
  String get auto_library_update_never => '更新しない';

  @override
  String get auto_library_update_12_hours => '12時間ごと';

  @override
  String get auto_library_update_daily => '毎日';

  @override
  String get auto_library_update_2_days => '2日ごと';

  @override
  String get auto_library_update_weekly => '毎週';

  @override
  String get auto_library_update_wifi_only => 'Wi-Fi接続時のみ';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'モバイルデータ通信中は予定された更新をスキップします。';

  @override
  String get padding => '余白';

  @override
  String get page_mode => 'ページモード';

  @override
  String get single_page => '単一ページ';

  @override
  String get double_page => '見開きページ';

  @override
  String get speed => '速度';

  @override
  String get theme_dark => 'ダーク';

  @override
  String get theme_light => 'ライト';

  @override
  String get theme_black => 'ブラック';

  @override
  String get theme_sepia => 'セピア';

  @override
  String get decrease => '減らす';

  @override
  String get increase => '増やす';

  @override
  String get chapter_swipe_actions => 'チャプタースワイプ操作';

  @override
  String get chapter_swipe_start => '右にスワイプ';

  @override
  String get chapter_swipe_end => '左にスワイプ';

  @override
  String get chapter_swipe_toggle_bookmark => 'ブックマークを切り替え';

  @override
  String get chapter_swipe_toggle_read => '既読/未読を切り替え';

  @override
  String get chapter_swipe_download => 'ダウンロード';

  @override
  String get chapter_swipe_disabled => '無効';

  @override
  String get update_errors => 'アップデートエラー';

  @override
  String get no_update_errors => '更新エラーがない';

  @override
  String get clear_all => '全てクリア';

  @override
  String get dismiss => '却下';

  @override
  String get previous_episode => '前のエピソード';

  @override
  String get clear_logs => 'ログをクリアする';

  @override
  String get bold => '太字';

  @override
  String get italic => '斜体';

  @override
  String get color_yellow => 'イエロー';

  @override
  String get color_cyan => 'シアン';

  @override
  String get color_green => 'グリーン';

  @override
  String get color_orange => 'オレンジ';

  @override
  String get continue_watching => '視聴を続ける';

  @override
  String get search_your_anime => 'アニメを検索する';

  @override
  String get category => 'カテゴリー';

  @override
  String get hidden_categories => '隠しカテゴリー';

  @override
  String get new_category => '新しいカテゴリー';

  @override
  String get local => 'ローカル';

  @override
  String get tv_home_rows => '行';

  @override
  String get genre_rows => 'ジャンル行';

  @override
  String get share_backup_file => 'NodeLane Comics バックアップ ファイルを共有します';

  @override
  String get close => '閉じる';

  @override
  String get migrate_source => '移行元';

  @override
  String get cloudflare_bypass_proxy => 'Cloudflareバイパスプロキシ';

  @override
  String get custom_doh_url => 'カスタム DoH URL';

  @override
  String get custom_doh_url_helper => 'https DoH (JSON) エンドポイントである必要があります';

  @override
  String get anime_only_tv_layout => 'アニメ専用TVレイアウト';

  @override
  String get anime_only_beta => 'アニメのみ（ベータ版）';

  @override
  String get tv_home_beta => 'テレビホーム（ベータ版）';

  @override
  String get tv_player_beta => 'TVプレーヤー（ベータ版）';

  @override
  String get network_settings => 'ネットワーク';

  @override
  String get reader_page_layout => 'ページレイアウト';

  @override
  String get reader_continuous_options => '連続読み取り';

  @override
  String get reader_default_mode_hint =>
      'デフォルトの読み取りモードは、読み取り中に個別のモードが設定されていないタイトルに適用されます。';

  @override
  String get extension_service => '延長サービス';

  @override
  String get extension_service_description => '拡張機能のランタイムとプロキシ アドレスを管理します。';

  @override
  String get proxy_address => 'プロキシアドレス';

  @override
  String get checking_runtime_status => 'ステータスを確認中…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + ランダムな遅延';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 章',
      one: '1章',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint => 'タイトルのチャプターリストからダウンロードを追加します。';

  @override
  String get download_queue_order_hint => 'ハンドルをドラッグして並べ替えます';

  @override
  String get download_queue_empty => 'キューにダウンロードはありません';

  @override
  String get download_queue_actions => 'ダウンロードアクション';

  @override
  String get download_queue_cancel_chapter => 'この章のダウンロードをキャンセルします';

  @override
  String get download_queue_cancel_series => 'このタイトルのすべてのダウンロードをキャンセルします';

  @override
  String get download_queue_start => 'ダウンロードの開始';

  @override
  String get download_queue_retry => 'ダウンロードを再試行する';

  @override
  String get download_queue_active => 'ダウンロード中';

  @override
  String get download_queue_waiting => 'ダウンロードを待っています';

  @override
  String get download_queue_failed => 'ダウンロードに失敗しました';

  @override
  String get cf_proxy_helper => 'FlareSolver/Byparr エンドポイント。無効にするには空のままにします。';

  @override
  String get mobile_navigation_description =>
      'ドラッグして並べ替えます。マンガ、アニメ、小説は「ライブラリ」タブを共有します。最初に表示されるアイテムは起動時に開きます。 「参照」と「その他」は表示されたままになります。 [その他] の下に追加のタブが表示されます。';

  @override
  String get text_align_justify => '正当化する';

  @override
  String get novel_session_modes_hint =>
      'タイトルを読みながら、読み取りモードと 1 ページまたは 2 ページを設定します。';

  @override
  String get tts_languages_failed => '音声エンジンから言語をロードできなかった。';

  @override
  String get tts_languages_empty => '音声エンジンは言語を返さなかった。保存した選択内容は保持されます。';

  @override
  String get tts_language_unavailable => 'この保存された言語は、デバイスの現在のリストには含まれていません。';

  @override
  String get tts_apply_failed => 'この設定を音声エンジンに適用することはできなかった。再試行できます。';

  @override
  String get player_controls => 'コントロール';

  @override
  String get audio_channel_auto => '自動';

  @override
  String get audio_channel_auto_safe => '自動（安全）';

  @override
  String get audio_channel_mono => 'モノラル';

  @override
  String get audio_channel_stereo => 'ステレオ';

  @override
  String get audio_channel_reverse_stereo => '逆ステレオ';

  @override
  String get mpv_bundled_config_hint =>
      'アプリに含まれる構成、スクリプト、およびシェーダを復元する。同名のファイルは上書きされます。';

  @override
  String get mpv_restore_bundled => 'バンドルされた構成を復元する';

  @override
  String get mpv_restore_confirm =>
      'バンドルされた MPV 構成を復元しますか?同じ名前の既存の設定、スクリプト、シェーダーは上書きされます。他のファイルは保持されます。';

  @override
  String get player_operation_incomplete =>
      '操作を完了できませんでした。ファイルアクセスを確認して、再試行してください。';

  @override
  String get custom_buttons_empty_hint => 'ラベルおよびプレスアクションを備えたプレーヤーボタンを追加する。';

  @override
  String get custom_button_primary => 'デフォルトボタン';

  @override
  String get show_password => 'パスワードを表示する';

  @override
  String get hide_password => 'パスワードを隠す';

  @override
  String get tracking_accounts_empty => 'トラッキング設定でサービスを接続して、そのエントリを管理する。';

  @override
  String get tracking_entries_empty =>
      'このメディアタイプには追跡されたエントリが存在しない。タイトルの詳細ページからトラッキングを追加します。';

  @override
  String get change_tracking_match => '一致するタイトルを変更する';

  @override
  String get remove_tracking => '追跡を削除する';

  @override
  String remove_tracking_confirm(String title) {
    return '「$title」のトラッキングリンクを削除しますか?追跡サービスへの入力は保持されます。';
  }

  @override
  String get tracking_refresh_required =>
      'トラッキング状態は確認できませんでした。別の変更を加える前に更新してください。';

  @override
  String get tracking_entry_unlinked =>
      'このレコードはローカルタイトルにリンクされていないため、ここで編集することはできない。';

  @override
  String get backup_selection_shared =>
      'これらの選択に対する変更はすぐに保存され、自動バックアップにも適用されます。';

  @override
  String get library_snapshot_history => 'ライブラリスナップショットを復元する';

  @override
  String get library_snapshot_empty => '利用可能な安全スナップショットは存在しない。';

  @override
  String get library_snapshot_restore_message =>
      '現在のデータは、このスナップショットによって置き換えられる。それ以降に行われた変更は失われます。削除したダウンロードは復元できません。利用可能な安全スナップショットは成功後にクリアされます。';

  @override
  String get library_maintenance_working => 'ライブラリを更新中…';

  @override
  String get library_safety_snapshot_note =>
      '安全スナップショットは、この操作の前に保存される。ダウンロードしたファイルは含まれません。';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'ライブラリ エントリ: $mangaCount。章: $chapterCount。履歴エントリ: $historyCount。更新: $updateCount。\n\n以下に保持するものを選択してください。';
  }

  @override
  String get library_delete_pick_message => 'ソースを選択して、その内容と削除オプションを確認します。';

  @override
  String get mobile_categories_hint =>
      'ドラッグして並べ替える。カテゴリを開いて名前を変更するか、その表示と更新を変更します。';

  @override
  String get mobile_category_visible => '図書館で見せる';

  @override
  String get mobile_category_hidden => 'ライブラリから隠されている';

  @override
  String get mobile_category_updates => 'ライブラリ更新に含める';

  @override
  String get statistics_watched => '見ました';

  @override
  String get calendar_month => '月';

  @override
  String get calendar_two_weeks => '2週間';

  @override
  String get calendar_week => '週';

  @override
  String get calendar_show_all_dates => 'すべての日付を表示';

  @override
  String get update_check_no_result =>
      'インストール可能なアップデートが見つからない。後でもう一度試すことができます。';

  @override
  String get release_notes => 'リリースノート';

  @override
  String get no_release_notes => 'リリースノートは提供されていない。';

  @override
  String get downloading_update => 'アップデートをダウンロード中…';

  @override
  String get preparing_installation => 'インストールを準備しています…';

  @override
  String get onboarding_mobile_libraries_body => '何を読むかを選択してください。これは後で変更できます。';

  @override
  String get onboarding_content_title => '読書を開始する';

  @override
  String get onboarding_mobile_sources_body => '開始方法を選択するか、後でコンテンツを追加します。';

  @override
  String onboarding_step_count(int step, int total) {
    return '$total のステップ $step';
  }

  @override
  String global_search_results_for(String query) {
    return '「$query」の結果';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ソース',
      one: '1 ソース',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => '目的のタイトルを検索します。';

  @override
  String get migration_original_item => '現行品';

  @override
  String get migration_target_item => '選択項目';

  @override
  String get migration_partial_failure =>
      '操作は終了しなかった。一部の変更が保存されている可能性があります。再試行する前に、ライブラリでこのアイテムを確認してください。';

  @override
  String get migration_no_categories => 'カテゴリはありません。このアイテムはカテゴリなしで追加できます。';

  @override
  String get mass_migration_select_source => '電流源を選択する';

  @override
  String get mass_migration_select_all => 'すべて選択';

  @override
  String get mass_migration_deselect_all => 'すべての選択を解除する';

  @override
  String get mass_migration_needs_review => '不完全な移行を確認する';

  @override
  String get bookshelf_actions => '本棚アクション';

  @override
  String get bookshelf_ignore_filters => '検索時にフィルタを無視する';

  @override
  String get bookshelf_ignore_filters_hint =>
      'フィルタによって隠されている作品も含めて、このカテゴリ内のすべての作品を検索します。';

  @override
  String get bookshelf_stop_update => 'ライブラリ更新の停止';

  @override
  String bookshelf_selected_count(int count) {
    return '$count作品が選ばれました';
  }

  @override
  String get bookshelf_remove_library => '本棚から取り出す';

  @override
  String get bookshelf_remove_library_hint => 'お気に入りを削除する。現地輸入者も蔵書や読書記録を失う。';

  @override
  String get bookshelf_remove_downloads => 'ダウンロードしたファイルを削除する';

  @override
  String get bookshelf_remove_downloads_hint =>
      '作品情報を保持したまま、ダウンロードされたファイルを削除する。';

  @override
  String get bookshelf_remove_local_files_hint =>
      'また、選択されたローカルインポートファイルを削除し、それらのライブラリレコードを削除する。これらのファイルはここでは回復できません。';

  @override
  String get bookshelf_remove_incomplete =>
      '操作は終了しなかった。一部の作品やファイルは加工されている場合があります。続行する前に、このダイアログを閉じて本棚とダウンロードを確認してください。';

  @override
  String get bookshelf_processing => '処理中…';

  @override
  String get bookshelf_mark_read => '既読マーク';

  @override
  String get bookshelf_mark_unread => '未読としてマークを付ける';

  @override
  String get bookshelf_select_all => 'すべて選択';

  @override
  String get bookshelf_invert_selection => '選択の反転';

  @override
  String get bookshelf_settings => '本棚設定';

  @override
  String get bookshelf_settings_live => 'フィルタ、ソートおよび表示の変更は直ちに有効になる。';

  @override
  String get bookshelf_filter_any => '任意';

  @override
  String get bookshelf_filter_include => '以下を含む';

  @override
  String get bookshelf_filter_exclude => '除外する';

  @override
  String get bookshelf_all_sources => 'すべての情報源';

  @override
  String bookshelf_sources_selected(int count) {
    return '$count 個のソースが選択されました';
  }

  @override
  String get bookshelf_sort_ascending => '昇順';

  @override
  String get bookshelf_sort_descending => '降順';

  @override
  String get bookshelf_layout => '本棚のレイアウト';

  @override
  String get bookshelf_sources_hint =>
      'すべてのソースを表示するには、何も選択しません。 「フィルター」をタップすると、変更が適用されます。';

  @override
  String get bookshelf_choose_files => 'ファイルを選択する';

  @override
  String get bookshelf_import_wait => 'ピッカーでファイルを選択し、インポートが完了するのを待ちます。';

  @override
  String get bookshelf_import_incomplete =>
      'インポートは完了しなかった。一部のファイルはすでに本棚にある可能性があります。再度インポートする前に、このダイアログを閉じて確認してください。';

  @override
  String get bookshelf_categories_replace =>
      '保存すると、これらのカテゴリが選択されたすべての作品に割り当てられ、以前のカテゴリが置き換えられます。';

  @override
  String get bookshelf_categories_hint => '１つ以上のカテゴリを選択するか、選択を空のままにして何も割り当てない。';

  @override
  String get bookshelf_categories_hidden => '既存の隠しカテゴリは、この作業のために保持される。';

  @override
  String get bookshelf_categories_incomplete =>
      'カテゴリを完全に保存できなかった。再試行する前に、このダイアログを閉じて本棚を確認してください。';

  @override
  String get bookshelf_categories_none_visible =>
      'ここでは利用可能なカテゴリは存在しない。カテゴリ管理を開いて確認してください。';

  @override
  String get bookshelf_manage_categories => 'カテゴリの管理';

  @override
  String get manga_actions => 'コミックアクション';

  @override
  String get manga_download_scope => '章をダウンロードする';

  @override
  String get manga_download_scope_hint =>
      '現在のフィルター内のチャプターを選択します。ダウンロードしたチャプターはスキップされます。';

  @override
  String get manga_download_scope_empty =>
      '現在のフィルターに一致するチャプターはありません。このメニューを閉じて、チャプターフィルターを調整します。';

  @override
  String get manga_action_incomplete => 'アクションは終了しなかった。再試行する前に現在の状態を確認してください。';

  @override
  String get chapter_settings => 'チャプター設定';

  @override
  String get chapter_settings_live => 'フィルタおよびソートの変更は直ちに適用される。';

  @override
  String get chapter_scanlators_all => 'すべてのスキャンレータ グループを表示';

  @override
  String get chapter_scanlators_hint =>
      'チャプタを非表示にするグループを選択します。 「フィルター」をタップすると、変更が適用されます。';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count スキャンレータ グループが隠されています';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count 章が選択されました';
  }

  @override
  String get chapter_add_bookmark => 'ブックマーク';

  @override
  String get chapter_remove_bookmark => 'ブックマークを解除する';

  @override
  String get chapter_read_following => '以下を読んでください';

  @override
  String get chapter_delete_records => 'チャプターレコードの削除';

  @override
  String get chapter_delete_local_hint =>
      '選択した章の記録と読書の進行状況を削除します。オリジナルのローカル アーカイブは保持されます。ダウンロードされたコピーはクリーンアップされます。';

  @override
  String get chapter_delete_last_hint =>
      'これらはこのコミックのすべての章です。削除すると、本棚からもコミックが削除されます。';

  @override
  String get chapter_action_incomplete =>
      'アクションは終了しませんでした。一部の変更はすでに保存されている可能性があります。続行する前に、章とダウンロードを閉じて確認してください。';

  @override
  String get reader_display_scope =>
      'このコミックには読書モードとマニュアルページレイアウトが適用されます。変更を選択して読書に戻ります。';

  @override
  String get reader_display_single_only => '横方向の連続読み取りでは、単一ページが使用されます。';

  @override
  String get reader_display_manual_pages =>
      'ページ レイアウトを変更すると、すべてのコミックの自動見開きページがオフになります。';

  @override
  String get reader_display_crop_scope => 'すべてのコミックに適用されます。';

  @override
  String get reader_chapter_locate => '現在の章を見つける';

  @override
  String get reader_chapter_search => 'チャプターまたはスキャンレーターを検索する';

  @override
  String get reader_chapter_scope =>
      '章フィルタとコミックの詳細からのソート順序を使用する。ブックマークはすぐに保存されます。';

  @override
  String get reader_chapter_current_hidden => 'あなたが読んでいる章は現在のフィルタの外にあります。';

  @override
  String get reader_chapter_current => '今読んでいます';

  @override
  String get reader_chapter_read => '読み取り';

  @override
  String get reader_chapter_bookmark_failed =>
      'ブックマークの保存が確認できませんでした。リストを閉じて、現在の状態を確認します。';

  @override
  String get reader_image_actions => 'イメージアクション';

  @override
  String get reader_image_original =>
      '翻訳、トリミング、またはリーダーカラーフィルターを使用せずに、オリジナルのページ全体を使用します。';

  @override
  String get reader_image_save_ios => '現在のアプリの保存場所のピクチャフォルダに保存します。';

  @override
  String get reader_image_save_android =>
      'デバイスのPictures/nodelane-comicsフォルダに保存します。';

  @override
  String get reader_image_share => 'システム共有シートを開きます。';

  @override
  String get reader_image_cover => '確認後、このコミックの表紙を変更します。';

  @override
  String get reader_image_cover_limit =>
      'カバー画像は 5 MB 未満である必要があります。保存と共有は引き続き利用できます。';

  @override
  String get reader_image_action_failed =>
      '動作は確認できませんでした。再試行する前に、このメニューを閉じて結果を確認してください。';

  @override
  String get reader_settings_book_scope => 'この設定はこの漫画にのみ適用されます。';

  @override
  String get reader_settings_global_scope => 'これらの設定はすべてのコミックに適用され、すぐに保存されます。';

  @override
  String get reader_filters => '画像フィルター';

  @override
  String get reader_filter_scope => 'すべてのコミックに適用されます。元の画像を変更せずに読み取り表示を変更します。';

  @override
  String get reader_auto_scroll_pause => '設定が開いている間、スクロールは一時停止します。';

  @override
  String get manga_synopsis => '概要';

  @override
  String manga_author(String author) {
    return '著者: $author';
  }

  @override
  String get manga_continue_reading => '続きを読む';

  @override
  String get reader_settings_title => 'リーダーの設定';

  @override
  String get reader_picker_book_scope => 'このコミックス限定';

  @override
  String get reader_picker_global_scope => 'すべてのコミックに適用';

  @override
  String get reader_picker_apply_hint => 'タップして保存し、前のレベルに戻ります。';

  @override
  String get reader_scale_fit_screen_hint => 'ページ全体を画面に合わせる';

  @override
  String get reader_scale_stretch_hint => '読み取り領域を埋める';

  @override
  String get reader_scale_fit_width_hint => 'ページを幅に合わせる';

  @override
  String get reader_scale_fit_height_hint => 'ページを高さに合わせる';

  @override
  String get source_filter_active => '適用';

  @override
  String get source_filter_apply => 'フィルタを適用する';

  @override
  String get source_filter_scope => 'フィルタはこのウェブサイトにのみ適用される。';

  @override
  String get source_filter_apply_hint => 'フィルタを適用して、選択したものを使用します。';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'ジャンル',
      'author': '著者',
      'artist': 'アーティスト',
      'title': 'タイトル',
      'year': '年',
      'tags': 'タグ',
      'format': 'フォーマット',
      'publisher': '出版社',
      'relevance': '関連性',
      'rating': '評価',
      'views': 'ビュー',
      'random': 'ランダム',
      'all': 'すべて',
      'none': 'なし',
      'action': 'アクション',
      'adventure': '冒険',
      'comedy': 'コメディ',
      'drama': 'ドラマ',
      'fantasy': 'ファンタジー',
      'romance': 'ロマンス',
      'science_fiction': 'サイエンスフィクション',
      'slice_of_life': '人生の一部',
      'mystery': 'ミステリー',
      'horror': 'ホラー',
      'psychological': '心理学',
      'historical': '歴史的',
      'sports': 'スポーツ',
      'supernatural': 'スーパーナチュラル',
      'school_life': '学校生活',
      'tragedy': '悲劇',
      'shounen': '少年',
      'shoujo': '少女',
      'seinen': '青年',
      'josei': 'じょうせい',
      'isekai': '異世界',
      'martial_arts': '武道',
      'mecha': 'メカ',
      'music': '音楽',
      'doujinshi': '同人誌',
      'trending': 'トレンド',
      'new': '新しい',
      'adult_content': 'アダルトコンテンツ',
      'only': 'のみ',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'さらなる表示オプション';

  @override
  String get bookshelf_more_display_hint => 'バッジ、ソース、カテゴリ';

  @override
  String get bookshelf_download_count => 'ダウンロード数';

  @override
  String get bookshelf_source_global_hint => 'ソース可視性は、共有表示設定を使用する。';

  @override
  String get bookshelf_select_entries => 'セレクト作品';

  @override
  String get bookshelf_search_options => '検索オプション';

  @override
  String get bookshelf_empty_hint => 'ソースから作品を収集するか、ローカルファイルをインポートします。';

  @override
  String get bookshelf_no_match_hint => '他のキーワードを試すか、現在のフィルタを調整してください。';

  @override
  String get bookshelf_clear_query => 'キーワードを明確にする';

  @override
  String get bookshelf_view_selection => '選択した作品を見る';

  @override
  String get bookshelf_import_formats => 'ローカルファイルを選択して、それを本棚に追加します。';

  @override
  String get bookshelf_import_canceled_hint =>
      'ファイルピッカーをキャンセルした後、再度選択することができます。';

  @override
  String get bookshelf_browse_sources => 'ソースを閲覧する';

  @override
  String get bookshelf_empty_title => 'あなたの本棚は空です';

  @override
  String get bookshelf_no_match_title => '一致する作品がない';

  @override
  String get bookshelf_mark_watched => 'マークは見ました';

  @override
  String get bookshelf_mark_unwatched => '未視聴のマークを付ける';

  @override
  String get nodelane_account => 'NodeLane アカウント';

  @override
  String get nodelane_sign_in => 'NodeLane にサインインします';

  @override
  String get nodelane_account_intro => 'アカウント、サブスクリプション、および翻訳割り当てを表示します';

  @override
  String get nodelane_login_action => 'サインインを続ける';

  @override
  String get nodelane_login_browser => 'システムブラウザを通じてサインインし、アプリに戻ります。';

  @override
  String get nodelane_account_id => 'アカウントID';

  @override
  String get nodelane_account_init_error =>
      'アカウントストレージは利用できない。アプリを再起動して、もう一度試してください。';

  @override
  String get nodelane_account_refresh_error => 'アカウント情報を更新できませんでした';

  @override
  String get nodelane_account_auth_error => 'セッションの有効期限が切れました。再度サインインしてください';

  @override
  String get nodelane_account_unknown => '購読情報が利用できない';

  @override
  String get nodelane_account_current => '現在のサブスクリプション';

  @override
  String get nodelane_account_free => '無料アカウント';

  @override
  String get nodelane_account_no_subscription => 'アクティブなサブスクリプションがありません';

  @override
  String get nodelane_account_active => 'アクティブ';

  @override
  String get nodelane_account_expired => '期限切れ';

  @override
  String get nodelane_account_expiry => 'まで有効';

  @override
  String get nodelane_account_renewal => 'リニューアル';

  @override
  String get nodelane_renewal_auto => '自動更新';

  @override
  String get nodelane_renewal_manual => '手動更新';

  @override
  String get nodelane_renewal_stopped => '自動更新停止';

  @override
  String get nodelane_renewal_gift => 'ギフト会員権';

  @override
  String get nodelane_renewal_attention => 'ウェブサイトで更新ステータスを確認する';

  @override
  String get nodelane_next_billing => '次回の請求日';

  @override
  String get nodelane_billing_unavailable => '更新情報が入手できない';

  @override
  String get nodelane_manage_account => 'ウェブサイトで管理';

  @override
  String get nodelane_view_plans => 'サブスクリプションプランを表示する';

  @override
  String get nodelane_translation_quota => '翻訳割り当て';

  @override
  String get nodelane_quota_free => '無料割り当て';

  @override
  String get nodelane_quota_subscription => 'サブスクリプション割り当て';

  @override
  String get nodelane_quota_purchase => '購入した割り当て';

  @override
  String get nodelane_quota_details => 'クォータの詳細を表示する';

  @override
  String get nodelane_quota_expanded => 'クォータの詳細';

  @override
  String get nodelane_quota_unlimited => '無制限';

  @override
  String get nodelane_quota_not_subscribed => '購読していません';

  @override
  String get nodelane_quota_unknown => '利用不可';

  @override
  String get nodelane_quota_used => '使用済み';

  @override
  String get nodelane_quota_reserved => '進行中';

  @override
  String get nodelane_quota_reset => '次のリセット';

  @override
  String get nodelane_quota_expiry => '次の有効期限';

  @override
  String get nodelane_quota_no_expiry => '有効期限なし';

  @override
  String get nodelane_quota_reservation_note =>
      '進行中のページは、利用可能なクォータからすでに差し引かれています';

  @override
  String nodelane_quota_available(int count) {
    return '残り$countページ';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count ページ';
  }

  @override
  String get nodelane_sign_out => 'サインアウト';

  @override
  String get nodelane_sign_out_confirm =>
      'サインアウトすると、このデバイス上の公式翻訳が一時停止される。ライブラリと読書の進捗状況は保持されます。';

  @override
  String get settings_search_hint => '検索設定';

  @override
  String get settings_frequent => '頻繁に使用される';

  @override
  String get settings_reading_translation => '読書と翻訳';

  @override
  String get settings_app_preferences => 'アプリの設定';

  @override
  String get settings_data_management => 'データと管理';

  @override
  String get settings_more_tools => 'その他のツール';

  @override
  String get settings_more_tools_hint => 'カテゴリ、統計およびカレンダー';

  @override
  String get settings_appearance_interface => '外観とインターフェース';

  @override
  String get settings_security_privacy => 'セキュリティとプライバシー';

  @override
  String get settings_source_preferences => 'ソース設定';

  @override
  String get settings_about_help => '概要とヘルプ';

  @override
  String get settings_storage_backup => 'ストレージとバックアップ';

  @override
  String settings_pending_downloads(int count) {
    return '$count 保留中';
  }

  @override
  String get settings_translation_language => '翻訳言語';

  @override
  String get settings_translation_scope => 'リーダーおよびウェブページの翻訳で使用される';

  @override
  String get settings_immediate_choice => '変更はすぐに適用されます';

  @override
  String get settings_translation_init_error =>
      '翻訳設定は使用できません。アプリを再起動して、もう一度試してください。';

  @override
  String get settings_local_cache => 'ローカルキャッシュ';

  @override
  String get settings_chapter_cache => 'チャプターおよびエピソードのキャッシュ';

  @override
  String get settings_cover_cache => 'カバーキャッシュ';

  @override
  String get settings_translation_cache => '翻訳画像キャッシュ';

  @override
  String get settings_translation_cache_hint => '翻訳記録を保持し、必要に応じて翻訳済み画像を再度取得する';

  @override
  String get settings_cache_clear => 'クリア';

  @override
  String get settings_translation_cache_done =>
      '翻訳された画像キャッシュがクリアされる。翻訳記録が保存される';

  @override
  String settings_cache_confirmation(String name) {
    return '$nameをクリアしますか？キャッシュされたコンテンツは再度取得できます。ライブラリのエントリは保持されます。';
  }

  @override
  String get settings_advanced_options => '高度なオプション';

  @override
  String get settings_manga_reader => 'マンガリーダー';

  @override
  String get settings_novel_reader => '小説リーダー';

  @override
  String get settings_downloads => 'ダウンロード設定';

  @override
  String get onboarding_welcome => 'へようこそ';

  @override
  String get onboarding_reading_content => '読書内容';

  @override
  String get onboarding_choose_one => '少なくとも 1 つを選択してください';

  @override
  String get onboarding_restore_hint => 'バックアップからライブラリを復元する';

  @override
  String get onboarding_browse_hint => 'サポートされている Web サイトでタイトルを検索する';

  @override
  String get onboarding_import_folder => 'ローカルフォルダをインポートする';

  @override
  String get onboarding_import_folder_hint => 'マンガ、小説、アニメをデバイス上で読む';

  @override
  String get onboarding_third_party => 'サードパーティのリポジトリを追加する';

  @override
  String get onboarding_third_party_hint => 'すでに持っているリポジトリ アドレスを使用する';

  @override
  String get onboarding_repository_hint => 'リポジトリによって提供されるアドレスを入力します。';

  @override
  String get onboarding_repository_address => '住所';

  @override
  String get onboarding_repository_address_hint => 'リポジトリアドレスを入力してください';

  @override
  String get onboarding_add_repository => 'リポジトリの追加';

  @override
  String get onboarding_start => '始めましょう';

  @override
  String get onboarding_open_library => 'オープンライブラリ';

  @override
  String get onboarding_view_imports => 'インポートされたコンテンツを表示する';

  @override
  String get onboarding_view_folders => 'フォルダを表示する';

  @override
  String get notice_backup_created => 'バックアップが作成されました';

  @override
  String get notice_backup_ready => 'バックアップファイルを保存または共有する。';

  @override
  String get notice_backup_restored => 'バックアップが復元されました';

  @override
  String get notice_backup_unsupported => 'このバックアップ形式はサポートされていません。';

  @override
  String get notice_verification_required => 'ウェブサイト認証が必要';

  @override
  String get notice_verification_hint => '閲覧を続けるには検証を完了してください。';

  @override
  String get notice_verify => 'ウェブサイトを確認する';

  @override
  String get notice_action_incomplete => 'アクションは終了しなかった。再試行する前に結果を確認してください。';

  @override
  String get notice_library_updating => 'ライブラリの更新';

  @override
  String notice_library_progress(Object current, Object total) {
    return '$current / $total タイトルをチェックしました';
  }

  @override
  String get notice_library_failed => '一部のタイトルが更新できなかった';

  @override
  String get notice_import_completed => 'インポート完了';

  @override
  String get notice_operation_incomplete => 'アクションが不完全';

  @override
  String get subtitle_service => 'オンライン字幕サービス';

  @override
  String get subtitle_service_mode => '字幕ソース';

  @override
  String get subtitle_service_disabled => 'オフ - 保存された認証情報をクリア';

  @override
  String get subtitle_personal_key => '私の Wyzie キー';

  @override
  String get subtitle_custom_service => '私の字幕サービス';

  @override
  String get subtitle_key => 'Wyzie API キー';

  @override
  String get subtitle_key_hint =>
      '独自の Wyzie キーを入力します。このデバイス上に残り、アプリのバックアップには含まれません。';

  @override
  String get subtitle_get_key => '個人キーを取得する';

  @override
  String get subtitle_service_address => '字幕検索 URL';

  @override
  String get subtitle_service_token => 'サービスアクセストークン（オプション）';

  @override
  String get subtitle_custom_hint =>
      'パス (/search など) を含む、Wyzie-compatible サービスの完全な HTTPS 検索 URL を使用します。サービスでアクセス トークンが必要な場合にのみ、アクセス トークンを入力します。';

  @override
  String get subtitle_service_off_hint =>
      'オンライン字幕検索はオフである。埋め込み、ソース提供、ローカル字幕は引き続き利用可能です。';

  @override
  String get subtitle_setup_required => '検索する前に字幕サービスを選択する。';

  @override
  String get subtitle_invalid_key => 'スペースを入れずにキーを入力してください。';

  @override
  String get subtitle_invalid_address =>
      'クエリ、フラグメント、または埋め込まれた認証情報を含まない完全な HTTPS URL を使用します。';

  @override
  String get subtitle_invalid_token => 'アクセス トークンにはスペースを含めることはできません。';

  @override
  String get subtitle_storage_failed =>
      '字幕設定を読み取ることも保存することもできなかった。もう一度試してください。';

  @override
  String get subtitle_auth_failed =>
      '字幕サービスはアクセスを拒否した。キーまたはサービス トークンを確認してください。';

  @override
  String get subtitle_quota_exhausted =>
      '字幕サービス割り当ては使い果たされている。そのサービスのアカウントを確認してください。';

  @override
  String get subtitle_network_failed => '字幕サービスにアクセスできませんでした。もう一度試してください。';

  @override
  String get subtitle_response_invalid => '字幕サービスは、サポートされていない応答またはファイルを返した。';

  @override
  String get detail_loading_chapters => '章をロード中…';

  @override
  String get reader_opening_chapter => '冒頭の章';

  @override
  String get reader_open_chapter => '章を開く';

  @override
  String get reader_loading_pages => 'チャプター画像を取得しています…';

  @override
  String get reader_loading_pages_hint => '準備が整うと自動的に読み取りが開始されます。';

  @override
  String get reader_loading_failed => 'この章をロードできませんでした';

  @override
  String get reader_loading_retry_hint => '接続を確認して、再試行してください。';

  @override
  String get reader_no_pages => 'この章の画像は見つかりませんでした';

  @override
  String get reader_loading_previous => '前の章をロード中…';

  @override
  String get reader_previous_failed => '前の章をロードできませんでした';

  @override
  String get reader_reached_start => '最初の章に到達しました';

  @override
  String get reader_loading_next => '次の章を読み込んでいます…';

  @override
  String get reader_next_failed => '次の章をロードできませんでした';

  @override
  String get reader_image_loading => '画像を読み込み中…';

  @override
  String get reader_image_failure_hint => '他のページを読み続けることができます。';

  @override
  String get comic_paged => 'ページごとに';

  @override
  String get comic_scroll => '下にスクロールします';

  @override
  String get comic_book_scope => 'この本にのみ適用されます。変更はすぐに保存されます';

  @override
  String get comic_defaults_title => 'デフォルトと習慣';

  @override
  String get comic_defaults_hint => 'デフォルトは、書籍用にカスタマイズしていないフィールドに適用されます。';

  @override
  String get comic_habits_hint => 'これらの習慣はどの漫画にも当てはまります。';

  @override
  String get comic_turn => 'スワイプして次のページへ';

  @override
  String get comic_left => '左';

  @override
  String get comic_right => 'そうです';

  @override
  String get comic_up => 'アップ';

  @override
  String get comic_fit => 'ページフィット';

  @override
  String get comic_fit_contain => 'ページ全体';

  @override
  String get comic_fit_width => 'フィット幅';

  @override
  String get comic_fit_height => 'フィット高さ';

  @override
  String get comic_layout => 'ページレイアウト';

  @override
  String get comic_auto => '自動';

  @override
  String get comic_layout_hint => '十分な幅がある場合、自動は広がりを示します。';

  @override
  String get comic_width => 'コンテンツ幅';

  @override
  String get comic_full => 'フル';

  @override
  String get comic_comfortable => '快適';

  @override
  String get comic_narrow => '狭い';

  @override
  String get comic_gap => 'ページ間隔';

  @override
  String get comic_no_gap => 'シームレス';

  @override
  String get comic_small_gap => '小';

  @override
  String get comic_image_title => '画像の微調整';

  @override
  String get comic_image_hint => 'トリミングとトーンはこの本にのみ影響します。';

  @override
  String get comic_wide => 'ワイドページ';

  @override
  String get comic_intact => '丸ごと保存';

  @override
  String get comic_split => '分割';

  @override
  String get comic_rotate => '回転';

  @override
  String get comic_wide_hint => '分割はページめくりの方向に従います。単一ページの読み取りに適用されます。';

  @override
  String get comic_cover => '章ごとに 1 つの表紙';

  @override
  String get comic_effects_reset => '画像調整をリセットする';

  @override
  String get comic_book_reset => 'ブックのデフォルトを復元する';

  @override
  String get comic_book_reset_hint => 'この本のカスタム読書設定をクリアします。翻訳は変更されていません。';

  @override
  String get comic_canvas => '読者の背景';

  @override
  String get comic_system => 'システム';

  @override
  String get comic_black => 'ブラック';

  @override
  String get comic_gray => 'グレー';

  @override
  String get comic_paper => '紙';

  @override
  String get comic_tap => 'タップしてページをめくる';

  @override
  String get comic_tap_hint => '移動するにはエッジをタップします。中央をタップしてコントロールを表示します。';

  @override
  String get comic_scroll_start => '自動スクロールの開始';

  @override
  String get comic_scroll_pause => '自動スクロールを一時停止する';

  @override
  String get comic_scroll_speed => 'スクロール速度';

  @override
  String get comic_scroll_hint => 'このパネルが閉じるとスタートします。アプリがフォアグラウンドを離れると一時停止します。';

  @override
  String get comic_save_failed => '保存できませんでした。もう一度試してください。';

  @override
  String get comic_reading => '読書';

  @override
  String get comic_chapter_habits_hint => '章リストの習慣はすべての本に適用されます。';

  @override
  String get browser_title => 'ブラウザ';

  @override
  String get translation_image_display => '画像表示';

  @override
  String get translation_display_hint =>
      '最初に既存の翻訳を表示します。翻訳が入手できない場合は、原本を保管してください。';

  @override
  String get translation_sign_in_required => 'サインインして翻訳を有効にする';

  @override
  String get translation_sign_in_hint => 'サインイン後、翻訳済み画像に切り替えて自動的に翻訳する。';

  @override
  String get translation_automatic => '自動翻訳';

  @override
  String get translation_original_hint => 'オリジナルを表示する。翻訳された画像に切り替えて自動的に翻訳します。';

  @override
  String get translation_window_hint => '翻訳を表示している間のみ、現在および今後の画像を処理する。';

  @override
  String get translation_channel => '翻訳チャネル';

  @override
  String get translation_no_images => 'このページには翻訳可能な画像がまだ見つかりません';

  @override
  String get translation_waiting_image => '現在の画像を待っています';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues画像には注意が必要です',
      one: ' · 1 枚の画像に注意が必要です',
      zero: '',
    );
    return '完成した$complete / $total画像$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      '画像をタッチアンドホールドすると、再度翻訳するなどのさらなるアクションが可能になる。';

  @override
  String get translation_title => 'マンガ翻訳';

  @override
  String get translation_system_sign_in => 'システムブラウザを使用してサインインします。';

  @override
  String get translation_target_language => 'ターゲット言語';

  @override
  String get translation_clear_cache => '翻訳された画像キャッシュをクリアする';

  @override
  String get translation_cache_hint => '翻訳記録を保持し、必要に応じて結果を再度取得する。';

  @override
  String get translation_saved_read_failed => '保存された翻訳をロードできませんでした';

  @override
  String get translation_read_failed => '翻訳された画像をロードできませんでした';

  @override
  String get operation_retry => 'アクションは終了しなかった。もう一度試してください。';

  @override
  String get translation_original => 'オリジナル';

  @override
  String get translation_translated => '翻訳済み';

  @override
  String get translation_regenerate_image => 'この画像を再度翻訳します';

  @override
  String get translation_read_image => '翻訳された画像をリロードする';

  @override
  String get translation_image_actions => 'さらなる画像アクション';

  @override
  String get translation_processing => '処理';

  @override
  String get translation_reading => '翻訳された画像のロード';

  @override
  String get translation_waiting => '翻訳を待っています';

  @override
  String get translation_preparing => '翻訳の準備';

  @override
  String get translation_uploading => 'オリジナルのアップロード';

  @override
  String get translation_running => '翻訳';

  @override
  String get translation_uncertain => 'ステータスの確認が必要です';

  @override
  String get translation_failed => '翻訳に失敗しました';

  @override
  String get translation_verify => '検証する';

  @override
  String get translation_reread => 'リロード';

  @override
  String get browser_back => '戻る';

  @override
  String get browser_translation => 'ウェブページの翻訳';

  @override
  String get browser_new_tab_action => '新しいタブを開く';

  @override
  String get browser_current_tab => '電流';

  @override
  String get browser_close_tab => 'タブを閉じる';

  @override
  String get browser_new_tab => '新しいタブ';

  @override
  String get browser_page => 'ウェブページ';

  @override
  String get browser_unopened => 'まだページが開いていません';

  @override
  String get browser_address_hint => 'URL を入力または貼り付けてください';

  @override
  String get browser_invalid_address => '有効な URL を入力してください';

  @override
  String get browser_clear_address => 'URL をクリア';

  @override
  String get browser_paste_address => 'URL を貼り付け';

  @override
  String get browser_open_address => 'URL を開く';

  @override
  String browser_tab_count(int count) {
    return 'タブ · $count';
  }

  @override
  String get browser_load_failed => 'このページを開けませんでした';

  @override
  String get browser_load_failed_hint => '接続と URL を確認してください。';

  @override
  String get browser_edit_address => 'URL を編集';

  @override
  String get browser_clear_cookies_confirm =>
      'すべての Web サイトのサインイン セッションをクリアしますか?';

  @override
  String get browser_clear_cookies_hint =>
      'ウェブサイトのすべてのタブでは、再度サインインする必要がある場合があります。';

  @override
  String get browser_clear_cookies_action => 'サインイン セッションをクリアします';

  @override
  String get browser_tab_limit => '最大 12 個のタブを開いたままにすることができます。まず 1 つを閉じます。';

  @override
  String get browser_forward => '前進';

  @override
  String get browser_clear_all_cookies => 'すべての Web サイトのサインイン セッションをクリアする';

  @override
  String get browser_clear_failed => 'セッションをクリアできませんでした。もう一度試してください。';

  @override
  String get browser_save_failed => 'タブを保存できませんでした。もう一度試してください。';

  @override
  String get browser_tabs_full => '12 個のタブがすでに開いています';

  @override
  String get browser_no_tabs => '開いているタブはまだありません';

  @override
  String get browser_close_failed => 'タブを保存できませんでした。再試行するには、もう一度「閉じる」をタップします。';

  @override
  String get source_pinned_websites => 'ピン留めされたウェブサイト';

  @override
  String get manage => '管理する';

  @override
  String get translation_settings_hint => '自動翻訳、ターゲット言語、およびチャネル';

  @override
  String get translation_show_original => 'タップするとオリジナルが表示されます';

  @override
  String get translation_show_translated => 'タップすると翻訳が表示されます';

  @override
  String get source_display => 'ディスプレイ';

  @override
  String get source_cover_title => '表紙とタイトル';

  @override
  String get source_cover_only => 'カバーのみ';

  @override
  String get source_save_search => '現在の検索を保存する';

  @override
  String get source_saved_searches => '保存された検索';

  @override
  String get source_website_info => 'ウェブサイト情報';

  @override
  String source_saved_search_title(String title) {
    return '$title · タップして検索';
  }

  @override
  String get action_done => '完了';

  @override
  String source_search_keyword(String query) {
    return 'キーワード:$query';
  }

  @override
  String get source_no_saved_searches => '保存された検索はまだありません';

  @override
  String get source_save_search_hint => 'キーワードを検索し、Web サイトのアクションから保存します。';

  @override
  String get source_saved_search_scope => 'キーワードはこの Web サイトのみに保存されます。';

  @override
  String get source_search_here => 'このウェブサイトのタイトルを検索する';

  @override
  String get source_filter_results => 'フィルタリングされた結果';

  @override
  String get source_search_results => '検索結果';

  @override
  String get source_return_popular => '人気に戻る';

  @override
  String get source_popular_titles => '人気タイトル';

  @override
  String get source_no_titles => '一致するタイトルが見つかりませんでした';

  @override
  String get source_no_titles_hint => 'キーワードやフィルタを変更するか、人気のあるタイトルに戻ります。';

  @override
  String get source_load_more_failed => 'これ以上ロードできませんでした。もう一度試してください。';

  @override
  String get source_load_pull_retry =>
      'この Web サイトを読み込めませんでした。プルダウンして再試行してください。';

  @override
  String get source_clear_failed => 'クリアできませんでした。もう一度試してください。';

  @override
  String get source_uninstall_failed => 'アンインストールを完了できませんでした。もう一度試してください。';

  @override
  String get source_details => 'ソースの詳細';

  @override
  String get source_repository_website => 'リポジトリウェブサイト';

  @override
  String get source_provided_settings => 'ソースによって提供される設定';

  @override
  String get source_advanced_actions => '高度なアクション';

  @override
  String get source_edit_metadata => 'ソース情報の編集';

  @override
  String get source_clear_cookies => 'このウェブサイトの Cookie をクリアします';

  @override
  String get source_clear_cookies_hint => '次回の訪問時に再度サインインする必要がある場合があります。';

  @override
  String get source_uninstall => 'アンインストールソース';

  @override
  String get source_settings_save_failed => '保存が完了しなかった。ソース設定を再度開いて確認します。';

  @override
  String get repository_third_party => 'サードパーティのリポジトリ';

  @override
  String get repository_refresh_failed =>
      'カタログを更新できませんでした。キャッシュされたコンテンツは保持されます。もう一度試してください。';

  @override
  String get repository_show_sources => 'このリポジトリからのソースを表示';

  @override
  String get repository_copy_catalog => 'カタログリンクのコピー';

  @override
  String get repository_remove => 'リポジトリを削除する';

  @override
  String get repository_remove_hint =>
      'インストールされたソースを保持し、アンインストールされたカタログエントリを削除する。';

  @override
  String get repository_empty => 'サードパーティのリポジトリはまだ追加されていません';

  @override
  String get repository_built_in => '公式カタログ内蔵';

  @override
  String get repository_hidden => '隠された';

  @override
  String get repository_refreshing => 'さわやか…';

  @override
  String get repository_refresh => 'カタログを更新する';

  @override
  String get repository_manage_hint => 'サードパーティのソースがどこからダウンロードされるかを管理する。';

  @override
  String get repository_invalid_address => '有効な HTTP または HTTPS URL を入力してください';

  @override
  String get repository_already_added => 'このリポジトリはすでに追加されています';

  @override
  String get repository_unrecognized =>
      'サポートされているカタログが見つかりません。リンクを確認して、もう一度試してください。';

  @override
  String get repository_read_failed => 'カタログを読み取れませんでした。もう一度試してください。';

  @override
  String get repository_save_failed => '保存が完了しませんでした。リポジトリ リストを確認してください。';

  @override
  String get repository_paste_hint => 'サードパーティのリポジトリカタログリンクを貼り付けます';

  @override
  String get repository_address => 'リポジトリ URL';

  @override
  String get repository_paste_link => 'リンクの貼り付け';

  @override
  String repository_recognized(String type) {
    return '$type · カタログが認識されました';
  }

  @override
  String get repository_choose_sources_hint => 'リポジトリを追加した後、必要なソースを選択します。';

  @override
  String get search_scope => '検索範囲';

  @override
  String get search_scope_hint => '検索する Web サイトを選択してください';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ウェブサイトを検索',
      one: '1 つのウェブサイトを検索',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'ウェブサイトを探す';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個の Web サイトが選択されました',
      one: '1 つの Web サイトが選択されました',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'クリア';

  @override
  String get search_deselect_results => '一致するウェブサイトの選択を解除する';

  @override
  String get search_select_results => '一致するウェブサイトを選択する';

  @override
  String get search_no_websites_hint => '一致するウェブサイトがありません。別の名前または言語を試してください。';

  @override
  String get search_select_website_hint => '検索する少なくとも１つのウェブサイトを選択する。';

  @override
  String get search_start_title => 'キーワードを入力してタイトルを検索する';

  @override
  String get search_start_hint => '一度に複数のウェブサイトを検索し、一致するタイトルを表示する。';

  @override
  String get search_empty_scope => 'この範囲では検索可能なウェブサイトはありません';

  @override
  String get search_empty_scope_hint => 'すべてのウェブサイトに切り替えるか、検索するウェブサイトを選択します。';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countの結果',
      one: '1 件の結果',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'タイトルの検索';

  @override
  String get search_actions => '検索アクション';

  @override
  String get search_details => '検索詳細';

  @override
  String get search_title_hint => 'タイトルによる検索';

  @override
  String get search_searching => '検索';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countの結果が見つかりました',
      one: '1 件の結果が見つかりました',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => '一致する結果はありません';

  @override
  String get search_failed => '検索に失敗しました';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count タイトルが見つかりました',
      one: '1 タイトルが見つかりました',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: '$websites ウェブサイト',
      one: '１つのウェブサイト',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'タイトルの検索';

  @override
  String get search_complete => '検索完了';

  @override
  String get search_in_progress => '検索';

  @override
  String get search_finding_related => '一致するタイトルを探しています…';

  @override
  String get search_no_results_yet => '検索結果はまだありません';

  @override
  String get search_no_matching_titles => '一致するタイトルが見つかりませんでした';

  @override
  String get search_results_appear_hint => '結果は、見つかったときにここに表示されます。';

  @override
  String get search_failed_websites_hint =>
      '一部のウェブサイトは検索を完了できなかった。検索の詳細で再試行してください。';

  @override
  String get search_change_keywords_hint =>
      'より短いキーワードを試すか、より多くのウェブサイトを検索してください。';

  @override
  String get search_view_details => '検索の詳細を表示する';

  @override
  String get search_adjust_scope => '検索範囲を調整する';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ウェブサイト',
      one: '１つのウェブサイト',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return '$completed / $total を完了しました';
  }

  @override
  String get search_retry_website_hint => '失敗したウェブサイトを個別に再試行する';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count項目が選択されました',
      one: '1 つのアイテムが選択されました',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => '検索言語';

  @override
  String get source_deselect => '選択を解除する';

  @override
  String get source_select => 'ソースの選択';

  @override
  String get source_multilingual => '多言語対応';

  @override
  String get source_language_unknown => '言語が指定されていない';

  @override
  String get source_adult_content => '18 歳以上のコンテンツが含まれています';

  @override
  String get source_classification_unknown => '分類は特定されていない';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'すべてのソース情報、$count のその他のカテゴリを表示',
      one: 'すべてのソース情報を表示、さらに 1 つのカテゴリ',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'ウェブサイトの読み込み中';

  @override
  String get source_unpin => 'ピン留めを解除する';

  @override
  String get source_pin => 'ピン';

  @override
  String get source_open => '開く';

  @override
  String get source_metadata_hint =>
      '情報はソースカタログから得られる。カテゴリは、Web サイトでカバーされるコンテンツを説明します。';

  @override
  String get source_region => '地域';

  @override
  String get source_format => 'フォーマット';

  @override
  String get source_creation => '創造';

  @override
  String get source_unspecified => '指定なし';

  @override
  String get source_pricing => '価格設定';

  @override
  String get source_region_jp => '日本の漫画';

  @override
  String get source_region_kr => '韓国の漫画';

  @override
  String get source_region_cn => '中国の漫画';

  @override
  String get source_region_hk_tw => '香港と台湾の漫画';

  @override
  String get source_region_western => '西洋漫画';

  @override
  String get source_region_other => 'その他の地域';

  @override
  String get source_format_page => 'ページ付き漫画';

  @override
  String get source_format_vertical => '縦型コミック';

  @override
  String get source_format_strip => '漫画';

  @override
  String get source_creation_original => 'オリジナル';

  @override
  String get source_creation_fan => 'ファン作品';

  @override
  String get source_free_watch => '視聴無料';

  @override
  String get source_free_read => '無料で読むことができます';

  @override
  String get source_partial_paid => '一部支払い済み';

  @override
  String get source_paid_watch => '有料視聴';

  @override
  String get source_paid_read => '有料読書';

  @override
  String get source_pricing_unknown => '価格は指定されていない';

  @override
  String get source_language_filter => '言語によるフィルタリング';

  @override
  String get source_language_filter_hint =>
      'このカタログのみをフィルタリングします。インストールされているソースは影響を受けません。';

  @override
  String get source_all_languages => 'すべての言語';

  @override
  String get action_apply => '適用する';

  @override
  String get source_load_retry => 'このウェブサイトをロードできませんでした。もう一度試してください。';

  @override
  String get source_catalog_refresh_failed =>
      'カタログを更新できませんでした。現在のコンテンツは保持されます。プルダウンして再試行してください。';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countソースをアンインストールしますか?',
      one: '1 つのソースをアンインストールしますか?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      '選択したソースをアンインストールし、その設定をクリアします。ライブラリのタイトルとダウンロードを保持します。';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ソースのアクションが失敗しました。',
      one: '1 つのソースに対するアクションが失敗しました。',
    );
    return '$_temp0 選択は維持されました。もう一度試してください。';
  }

  @override
  String get source_latest_content => '最新コンテンツ';

  @override
  String get source_actions => 'ソースアクション';

  @override
  String get source_bulk_manage => '複数のソースを管理する';

  @override
  String get source_update_installed => 'インストールされているソースを更新します';

  @override
  String get source_no_matching_websites => '一致する Web サイトがありません';

  @override
  String get source_no_websites => '利用可能なウェブサイトがありません';

  @override
  String get source_search_installed_hint => 'インストールされているソース内のタイトルを検索する';

  @override
  String get source_global_search => 'ソース全体の検索';

  @override
  String get source_manage_repositories => 'リポジトリの管理';

  @override
  String get source_view_third_party => 'サードパーティのソースを表示する';

  @override
  String get source_catalog_load_failed => 'カタログをロードできませんでした。プルダウンして再試行してください。';

  @override
  String get source_all_websites => 'すべてのウェブサイト';

  @override
  String get source_available => 'インストール可能';

  @override
  String get source_third_party => 'サードパーティ';

  @override
  String get source_name_or_title => 'ウェブサイトの名前またはタイトル';

  @override
  String get view_all => '全て見る';

  @override
  String get search_searching_ellipsis => '検索中…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · 未テスト';
  }

  @override
  String get onboarding_untested => '未テスト';

  @override
  String get source_custom_scope => 'カスタム';

  @override
  String get source_custom_websites => '選択されたウェブサイト';

  @override
  String get tv_hidden_library_hint =>
      'あらゆるタイトルは、隠されたカテゴリに位置する。\n「すべて」で OK を押したままにすると、1 つが再表示されます。';

  @override
  String get tv_no_matching_anime => '一致するアニメがありません';

  @override
  String tv_no_matching_category(String category) {
    return '「$category」には一致するアニメがありません';
  }

  @override
  String get tv_filtered_empty_hint =>
      '現在のフィルタに一致するアニメはない。\n検索の横にあるボタンから変更します。';

  @override
  String get tv_new_episodes => '新しいエピソード';

  @override
  String get tv_recently_added => '最近追加されたもの';

  @override
  String get tv_empty_category_hint =>
      'このカテゴリにはまだアニメがありません。\nタイトルの詳細ページからタイトルを追加します。';

  @override
  String get tv_empty_library => 'あなたのアニメライブラリは空です';

  @override
  String get tv_empty_library_hint => 'ブラウズからアニメを追加して家を満たす';

  @override
  String get tv_browse_anime => 'アニメを閲覧する';

  @override
  String tv_new_count(int count) {
    return '$count 新しい';
  }

  @override
  String tv_category_hidden(String category) {
    return '「$category」を非表示にする・「すべて」でOKを押し続けると再表示されます';
  }

  @override
  String get tv_no_hidden_categories => '隠しカテゴリなし';

  @override
  String get import_torrent_file => '.torrentファイルをインポートする';

  @override
  String get import_video_formats => '.mp4、.mkv、.aviなど';

  @override
  String get cloudflare_proxy_optional => 'オプションの FlareSolver / Byparr URL';

  @override
  String get tv_home_layout_hint =>
      'フラットグリッドの代わりに行ベースのアニメホーム（継続・新しいエピソード・カテゴリー）';

  @override
  String get tv_hide_libraries_hint => '漫画および小説ライブラリを非表示にする（テレビではデフォルトでオン）';

  @override
  String get anime_only_hint => 'アプリ全体でマンガと小説を非表示にします。すべてを表示するにはオフにします。';

  @override
  String get audio_auto_safe => 'オートセーフ';

  @override
  String get tv_player_hint => 'オン：専用のＴＶプレーヤー。  オフ: オリジナル (デスクトップ) プレーヤー。';

  @override
  String get release_open_failed => 'リリースを開けません';

  @override
  String get tv_replay => 'リプレイ';

  @override
  String get tv_no_episodes => 'エピソードはまだありません';

  @override
  String get tracker_continue_series => 'シリーズの視聴を続ける';

  @override
  String get tracker_watchlist_series => 'ウォッチリストシリーズ';

  @override
  String get tracker_continue_movies => '映画を見続ける';

  @override
  String get tracker_watchlist_movies => 'ウォッチリストの映画';

  @override
  String get tracker_trending_series => 'トレンドシリーズ';

  @override
  String get tracker_trending_movies => 'トレンド映画';

  @override
  String get tracker_popular_series => '人気シリーズ';

  @override
  String get tracker_popular_movies => '人気の映画';

  @override
  String get tracker_top_series => 'トップシリーズ（オールタイム）';

  @override
  String get tracker_top_movies => 'トップ映画 (オールタイム)';

  @override
  String get tracker_airing_series => '放映シリーズ';

  @override
  String get tracker_airing_anime => '放送中のアニメ';

  @override
  String get tracker_popular_anime => '人気アニメ';

  @override
  String get tracker_upcoming_anime => '今後のアニメ';

  @override
  String get tracker_popular_manga => '人気マンガ';

  @override
  String get tracker_top_manga => 'トップマンガ';

  @override
  String get tracker_top_manhwa => 'トップ漫画';

  @override
  String get tracker_top_manhua => 'トップマンファ';

  @override
  String get tracker_latest_anime => '最新アニメ';

  @override
  String get tracker_best_anime => '最高評価のアニメ';

  @override
  String get tracker_latest_manga => '最新マンガ';

  @override
  String get tracker_best_manga => '最高評価のマンガ';

  @override
  String get tracker_trending_anime => 'トレンドアニメ';

  @override
  String get tracker_upcoming_manga => '今後のマンガ';

  @override
  String get tracker_trending_manga => 'トレンドマンガ';

  @override
  String selection_progress(int selected, int total) {
    return '$selected/$total が選択されました';
  }

  @override
  String get source_code_editor => 'コードエディタ';

  @override
  String get source_code_execute => '実行';

  @override
  String get source_console_logs => 'コンソールログ';

  @override
  String get source_no_logs => 'ログはまだありません';

  @override
  String get source_updated_successfully => 'ソースは正常に更新されました';

  @override
  String get source_obsolete => '廃止されました';

  @override
  String player_seek_forward_seconds(int seconds) {
    return '$seconds秒前方シーク';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return '$seconds秒後方へシークする';
  }

  @override
  String get player_autoplay_on => '次のエピソードを自動再生: オン';

  @override
  String get player_autoplay_off => '次のエピソードの自動再生: オフ';

  @override
  String get player_no_other_quality => '他の品質はありません';

  @override
  String get player_no_subtitles => '字幕なし';

  @override
  String get player_no_audio_tracks => 'オーディオトラックなし';

  @override
  String get player_seek_forward => '前方を探す';

  @override
  String get player_seek_backward => '後方探索';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds秒',
      one: '1秒',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'ロレム・イプサム・ドール・シット・アメット';

  @override
  String get subtitle_style => 'スタイル';

  @override
  String get translation_official_channel => 'NodeLane 公式';

  @override
  String get translation_auth_required => 'まず、翻訳アカウントにサインインします。';

  @override
  String get translation_source_changed => '元の画像が変化した。リロードしてください。';

  @override
  String get translation_source_missing => '元の画像は現在入手できない。';

  @override
  String get translation_resource_limit => 'この画像はデバイスの処理制限を超えています。原本は保管されています。';

  @override
  String get translation_storage_full => '翻訳ストレージがいっぱいです。まず翻訳された画像をクリアしてください。';

  @override
  String get translation_invalid_image => '無効な画像フォーマットまたはコンテンツ。';

  @override
  String get translation_unsupported_image =>
      'この画像の翻訳はサポートされていません。原本は保管されています。';

  @override
  String get translation_invalid_result => '翻訳された画像の検証に失敗しました。リロードしてください。';

  @override
  String get translation_result_unavailable => '翻訳された画像は利用できません。リロードしてください。';

  @override
  String get translation_result_expired => '翻訳された画像の有効期限が切れました。もう一度訳してください。';

  @override
  String get translation_analysis_too_large =>
      '分析するには画像コンテンツが多すぎる。画像サイズを小さくして再試行してください。';

  @override
  String get translation_region_limit => '画像にはテキスト領域が多すぎる。分割して再試行してください。';

  @override
  String get translation_text_limit => 'テキスト領域が長すぎる。画像を調整して再試行してください。';

  @override
  String get translation_unavailable => 'この翻訳はもう入手できません。';

  @override
  String get translation_outcome_unknown => '結果は検証が必要です。再提出されていません。';

  @override
  String get translation_rate_limited => 'リクエストには制限があります。翻訳は自動的に再開されます。';

  @override
  String get translation_quota_exhausted => '翻訳割り当てが不十分です。';

  @override
  String get translation_unsupported_language => 'このサービスはこのターゲット言語をサポートしていません。';

  @override
  String get translation_upgrade_required => '変換プロトコルに互換性がありません。アプリを更新します。';

  @override
  String get translation_remote_failed => 'このページの翻訳は失敗しました。手動で再試行できます。';

  @override
  String get translation_bridge_invalid => 'Web ページが変更されました。翻訳を再度有効にします。';

  @override
  String get translation_connection_failed => '接続に失敗しました。もう一度試してください。';

  @override
  String get translation_paused => '翻訳は一時停止した。進捗状況を確認できます。';

  @override
  String get translation_preparing_ellipsis => '翻訳を準備中…';

  @override
  String get translation_checking_original => '元の画像を確認中…';

  @override
  String get translation_submitting => '送信中…';

  @override
  String get translation_uploading_ellipsis => 'オリジナルをアップロード中…';

  @override
  String get translation_waiting_ellipsis => '翻訳を待っています…';

  @override
  String get translation_running_ellipsis => '翻訳中…';

  @override
  String get translation_verify_result => '結果は検証が必要である';

  @override
  String get translation_partial => '一部のコンテンツは翻訳されています';

  @override
  String get translation_ready => '翻訳済み画像の準備完了';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => '遊び';

  @override
  String get player_quality => '品質';

  @override
  String get player_subtitles => '字幕';

  @override
  String get player_audio => 'オーディオ';

  @override
  String get player_statistics => 'オタクのための統計';

  @override
  String get player_auto => '自動';

  @override
  String get source_information => '出典情報';

  @override
  String get source_code_page => 'ページ';

  @override
  String get source_code_query => 'クエリ';

  @override
  String get repository_invalid_source => '無効なソース - 削除してください';

  @override
  String get player_fit_contain => '含有する';

  @override
  String get player_fit_cover => 'カバー';

  @override
  String get player_fit_fill => 'フィル';

  @override
  String get player_fit_height => '高さ';

  @override
  String get player_fit_width => '幅';

  @override
  String get player_fit_scale => 'スケール';

  @override
  String get player_fit_none => 'なし';

  @override
  String get player_shader_clear => 'オフ（シェーダをクリア）';

  @override
  String get player_shader_luma => 'ルマアップスケーリング';

  @override
  String get player_decoder_auto => '自動 (ハードウェア)';

  @override
  String get player_decoder_software => 'ソフトウェア (ハードウェアなし)';

  @override
  String get player_stats_toggle => 'オーバーレイの切り替え';

  @override
  String get player_stats_general => '一般';

  @override
  String get player_stats_frames => 'フレームタイミング';

  @override
  String get player_stats_cache => '入力キャッシュ';

  @override
  String get player_stats_filters => 'アクティブフィルタ';

  @override
  String get player_stats_log => 'ログ';

  @override
  String get source_mark_pinned => 'ピン';

  @override
  String translation_image_action(String action) {
    return '$action この画像';
  }

  @override
  String get memory_waiting => 'メモリ：サンプルを待っています';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current ピーク $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'キャッシュ$current / $limit ピーク$peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'アイテム $count / $limit ライブ $live ピーク $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countサンプル',
      one: '１サンプル',
    );
    return '$_temp0 の完全な $percent%';
  }

  @override
  String get memory_reset_hint => '設定でオフとオンを切り替えてリセットします';

  @override
  String get action_hide => '隠す';

  @override
  String discord_get_app(String app) {
    return '$appを取得する';
  }

  @override
  String get discord_idle => 'アイドル';

  @override
  String discord_watching_title(String title) {
    return '$titleを視聴中';
  }

  @override
  String discord_reading_title(String title) {
    return '$titleの読み取り';
  }
}
