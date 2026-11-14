// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get browser_search_hint => '搜索或输入网址';

  @override
  String get browser_start_hint => '从这里，发现新的精彩。';

  @override
  String get browser_search_engine => '搜索引擎';

  @override
  String get browser_bookmarks => '书签';

  @override
  String get browser_search_library => '搜索标题或网址';

  @override
  String get browser_data_failed => '浏览器数据读取或保存失败，请重试。';

  @override
  String get browser_clear_history => '清除浏览历史';

  @override
  String get browser_clear_history_hint => '删除此设备上的全部浏览历史？书签和网站登录状态将保留。';

  @override
  String get browser_library_empty => '这里还是空的';

  @override
  String get browser_bookmarks_hint => '在网页菜单中添加书签，即可在这里找到它。';

  @override
  String get browser_history_hint => '访问过的网页会留在这里，关闭标签页后也能找回。';

  @override
  String get browser_recent => '最近访问';

  @override
  String get browser_pinned_hint => '在来源中固定常用网站，即可快捷访问。';

  @override
  String get browser_start_page => '开始页';

  @override
  String get browser_remove_bookmark => '移除书签';

  @override
  String get browser_add_bookmark => '添加书签';

  @override
  String get browser_find => '页内查找';

  @override
  String get browser_copy_link => '复制链接';

  @override
  String get browser_action_failed => '操作未完成，请重试。';

  @override
  String get browser_find_previous => '上一个匹配';

  @override
  String get browser_find_next => '下一个匹配';

  @override
  String browser_find_matches(int current, int total) {
    return '第 $current 项，共 $total 项';
  }

  @override
  String get app_update_details_hint => '查看更新说明与安装方式';

  @override
  String get app_update_download => '下载更新';

  @override
  String get app_update_download_hint => '下载完成后，按提示安装更新。';

  @override
  String get bookshelf_all => '全部';

  @override
  String get bookshelf_search => '搜索书架';

  @override
  String get app_update_allow_install => '请在系统设置中允许安装应用，然后返回点击安装。';

  @override
  String get app_update_waiting => '等待系统继续下载…';

  @override
  String get app_update_cancel_download => '取消下载';

  @override
  String get app_update_remove_package => '删除安装包';

  @override
  String get app_name => 'NodeLane漫译';

  @override
  String get settings_search_empty => '未找到相关设置';

  @override
  String get search_empty_hint => '试试其他关键词，或清除搜索查看全部内容。';

  @override
  String get search_clear => '清除搜索';

  @override
  String get app_updates => '软件更新';

  @override
  String get app_update_auto => '启动时检查更新';

  @override
  String get app_update_view => '查看更新';

  @override
  String get app_update_later => '稍后';

  @override
  String get app_update_external_hint => '在浏览器中打开更新链接';

  @override
  String get app_update_failed => '暂时无法检查更新，请重试。';

  @override
  String get app_update_opened => '已打开更新链接';

  @override
  String get app_diagnostics => '诊断与日志';

  @override
  String get library => '书架';

  @override
  String get updates_search => '搜索更新';

  @override
  String get updates => '更新';

  @override
  String get history => '历史';

  @override
  String get browse => '浏览';

  @override
  String get more => '更多';

  @override
  String get open_random_entry => '随机打开条目';

  @override
  String get import => '导入';

  @override
  String get filter => '筛选';

  @override
  String get ignore_filters => '忽略\n筛选';

  @override
  String get downloaded => '已下载';

  @override
  String get unread => '未读';

  @override
  String get unwatched => '未观看';

  @override
  String get started => '已开始';

  @override
  String get bookmarked => '已书签';

  @override
  String get sort => '排序';

  @override
  String get alphabetically => '按字母顺序';

  @override
  String get last_read => '最后阅读';

  @override
  String get last_watched => '上次观看';

  @override
  String get last_update_check => '最后更新检查';

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
      other: '你正在从你的库中删除此$mediaType的全部$count$entryTypePlural。',
      one: '你正在从你的库中删除此$mediaType的唯一$entryType。',
    );
    return '$_temp0\n这也会将整个$mediaType从你的库中移除。\n\n注意：文件本身不会被删除。';
  }

  @override
  String get chapter => '章节';

  @override
  String get episode => '剧集';

  @override
  String get unread_count => '未读计数';

  @override
  String get unwatched_count => '未观看计数';

  @override
  String get latest_chapter => '最新章节';

  @override
  String get latest_episode => '最新一集';

  @override
  String get date_added => '添加日期';

  @override
  String get display => '显示';

  @override
  String get display_mode => '显示模式';

  @override
  String get compact_grid => '紧凑网格';

  @override
  String get compression_level => '压缩级别';

  @override
  String compression_info(Object level) {
    return '压缩率越高，备份文件占用的空间越小，但会消耗更多的CPU。默认值：$level';
  }

  @override
  String get comfortable_grid => '舒适网格';

  @override
  String get cover_only_grid => '仅封面网格';

  @override
  String get list => '列表';

  @override
  String get badges => '徽章';

  @override
  String get downloaded_chapters => '已下载章节';

  @override
  String get downloaded_episodes => '下载的剧集';

  @override
  String get language => '语言';

  @override
  String get local_source => '本地来源';

  @override
  String get tabs => '标签';

  @override
  String get show_category_tabs => '显示类别标签';

  @override
  String get show_numbers_of_items => '显示项目数';

  @override
  String get other => '其他';

  @override
  String get show_continue_reading_buttons => '显示继续阅读按钮';

  @override
  String get show_continue_watching_buttons => '显示继续观看按钮';

  @override
  String get empty_library => '书架还是空的';

  @override
  String get search => '搜索...';

  @override
  String get no_recent_updates => '无最近更新';

  @override
  String get remove_everything => '删除所有';

  @override
  String get remove_everything_msg => '你确定吗？所有历史将丢失';

  @override
  String get remove_all_update_msg => '你确定吗？所有更新将被清除';

  @override
  String get ok => '好';

  @override
  String get cancel => '取消';

  @override
  String get remove => '移除';

  @override
  String get remove_history_msg => '这将移除此章节的阅读日期。你确定吗？';

  @override
  String get last_used => '最后使用';

  @override
  String get pinned => '已固定';

  @override
  String get sources => '来源';

  @override
  String get install => '安装';

  @override
  String get update => '更新';

  @override
  String get latest => '最新';

  @override
  String get extensions => '扩展';

  @override
  String get migrate => '迁移';

  @override
  String get mass_migration_title => '批量迁移';

  @override
  String get mass_migration_preview_items => '选择作品';

  @override
  String get mass_migration_destination_source => '目标来源';

  @override
  String get mass_migration_no_library_items => '书库中暂无可迁移的作品。';

  @override
  String get mass_migration_no_destination_sources => '暂无可用的已安装目标来源。';

  @override
  String get mass_migration_installed => '已安装';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count个项目准备好复检',
      one: '1个项目准备好复检',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 部作品',
      one: '1 部作品',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => '选择目标来源';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return '正在 $source • $language 中寻找匹配项';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return '正在匹配第 $current / $total 部作品';
  }

  @override
  String get mass_migration_waiting_next_item => '等待2秒后处理下一个项目...';

  @override
  String get mass_migration_waiting_next_migration => '等待2秒后处理下一项迁移...';

  @override
  String mass_migration_matched_so_far(int count) {
    return '目前已匹配: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return '未匹配: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return '核对来自 $source 的匹配结果';
  }

  @override
  String mass_migration_found_matches(int count) {
    return '找到匹配项: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return '未找到匹配: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return '已选 $count 部作品';
  }

  @override
  String get mass_migration_finish_review => '结束核对';

  @override
  String mass_migration_migrate_selected(int count) {
    return '迁移所选作品（$count）';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return '正在将选定项目迁移至 $source';
  }

  @override
  String get mass_migration_no_items_selected => '未选择任何作品进行迁移。';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return '正在迁移第 $current / $total 部作品';
  }

  @override
  String get mass_migration_complete => '批量迁移完成';

  @override
  String get mass_migration_complete_success_message => '所有选定项目均已处理成功。';

  @override
  String get mass_migration_complete_partial_message => '迁移结束，但部分项目仍需手动处理。';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => '已处理';

  @override
  String get mass_migration_matched => '已匹配';

  @override
  String get mass_migration_migrated => '已迁移';

  @override
  String get mass_migration_skipped => '已跳过';

  @override
  String get mass_migration_failed => '失败';

  @override
  String get mass_migration_failed_items => '失败项目';

  @override
  String get mass_migration_exit => '退出批量迁移';

  @override
  String get mass_migration_no_destination_match => '未找到目标匹配项';

  @override
  String mass_migration_query(Object query) {
    return '搜索词：$query';
  }

  @override
  String get mass_migration_skip => '跳过';

  @override
  String get mass_migration_loading => '正在加载...';

  @override
  String get mass_migration_choose_another_result => '选择其他结果';

  @override
  String get mass_migration_source_chapters => '原章节';

  @override
  String get mass_migration_destination_chapters => '目标章节';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count个章节',
      one: '1个章节',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count个原章节',
      one: '1个原章节',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count个目标章节',
      one: '1个目标章节',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => '未找到章节。';

  @override
  String mass_migration_and_more_chapters(int count) {
    return '以及更多 $count 个...';
  }

  @override
  String get mass_migration_unknown_title => '未知标题';

  @override
  String get mass_migration_unknown_match => '未知匹配';

  @override
  String get mass_migration_unknown_source => '未知来源';

  @override
  String get mass_migration_unknown_chapter => '未知章节';

  @override
  String get migrate_confirm => '迁移到另一个来源';

  @override
  String get clean_database => '清理数据库';

  @override
  String cleaned_database(Object x) {
    return '数据库已清理！已移除 $x 条目';
  }

  @override
  String get clean_database_desc => '这将移除所有未添加到图书馆的项目！';

  @override
  String get incognito_mode => '隐身模式';

  @override
  String get incognito_mode_description => '暂停阅读历史';

  @override
  String get downloaded_only => '仅已下载';

  @override
  String get downloaded_only_description => '仅显示库中已下载的条目';

  @override
  String get download_queue => '下载队列';

  @override
  String get categories => '类别';

  @override
  String get statistics => '统计';

  @override
  String get settings => '设置';

  @override
  String get about => '关于';

  @override
  String get help => '帮助';

  @override
  String get no_downloads => '无下载';

  @override
  String get edit_categories => '编辑类别';

  @override
  String get edit_categories_description => '你还没有类别。点击加号按钮创建一个来组织你的图书馆';

  @override
  String get add => '添加';

  @override
  String get add_category => '添加类别';

  @override
  String get name => '名称';

  @override
  String label_value(Object label, Object value) {
    return '$label：$value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*必填';

  @override
  String get add_category_error_exist => '此名称的类别已存在！';

  @override
  String get delete_category => '删除类别';

  @override
  String delete_category_msg(Object name) {
    return '你希望删除类别 $name 吗？';
  }

  @override
  String get rename_category => '重命名类别';

  @override
  String get general => '通用';

  @override
  String get general_subtitle => '应用语言';

  @override
  String get app_language => '应用语言';

  @override
  String get default_subtitle_language => '默认字幕语言';

  @override
  String get appearance => '外观';

  @override
  String get appearance_subtitle => '主题，日期和时间格式';

  @override
  String get theme => '主题';

  @override
  String get dark_mode => '暗模式';

  @override
  String get follow_system_theme => '跟随系统主题';

  @override
  String get on => '开';

  @override
  String get off => '关';

  @override
  String get pure_black_dark_mode => '纯黑暗模式';

  @override
  String get timestamp => '时间戳';

  @override
  String get relative_timestamp => '相对时间戳';

  @override
  String get relative_timestamp_short => '短（今天，昨天）';

  @override
  String get relative_timestamp_long => '长（短+，n天前）';

  @override
  String get date_format => '日期格式';

  @override
  String get reader => '阅读器';

  @override
  String get refresh => '刷新';

  @override
  String get reader_subtitle => '阅读模式，显示，导航';

  @override
  String get default_reading_mode => '默认阅读模式';

  @override
  String get reading_mode_vertical => '垂直';

  @override
  String get reading_mode_horizontal => '水平';

  @override
  String get reading_mode_left_to_right => '从左到右';

  @override
  String get reading_mode_right_to_left => '从右到左';

  @override
  String get reading_mode_vertical_continuous => '垂直连续';

  @override
  String get reading_mode_webtoon => '网络漫画';

  @override
  String get double_tap_animation_speed => '双击动画速度';

  @override
  String get normal => '正常';

  @override
  String get fast => '快';

  @override
  String get no_animation => '无动画';

  @override
  String get animate_page_transitions => '动画页面过渡';

  @override
  String get crop_borders => '裁剪边框';

  @override
  String get downloads => '下载';

  @override
  String get downloads_subtitle => '下载设置';

  @override
  String get download_location => '下载位置';

  @override
  String get custom_location => '自定义位置';

  @override
  String get only_on_wifi => '仅在wifi下';

  @override
  String get save_as_cbz_archive => '保存为CBZ档案';

  @override
  String get delete_download_after_reading => '完成阅读后删除下载内容';

  @override
  String get concurrent_downloads => '并发下载';

  @override
  String get browse_subtitle => '来源，全球搜索';

  @override
  String get only_include_pinned_sources => '仅包括固定来源';

  @override
  String get nsfw_sources => 'NSFW（18+）来源';

  @override
  String get nsfw_sources_show => '在来源和扩展列表中显示';

  @override
  String get nsfw_sources_info => '这不会阻止非官方或可能被错误标记的扩展在应用内显示NSFW（18+）内容';

  @override
  String get version => '版本';

  @override
  String beta_version(Object version) {
    return '测试版 ($version)';
  }

  @override
  String get check_for_update => '检查更新';

  @override
  String get logs_on => '启用日志';

  @override
  String get share_app_logs => '分享应用日志';

  @override
  String get no_app_logs => '没有可用的 log.txt 文件！';

  @override
  String get failed => '失败！';

  @override
  String n_days_ago(Object days) {
    return '$days天前';
  }

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get a_week_ago => '一周前';

  @override
  String get next_week => '下周';

  @override
  String get add_to_library => '加入书架';

  @override
  String get completed => '已完成';

  @override
  String get ongoing => '进行中';

  @override
  String get on_hiatus => '暂停';

  @override
  String get canceled => '已取消';

  @override
  String get publishing_finished => '发布完成';

  @override
  String get unknown => '未知';

  @override
  String get empty_placeholder => '空';

  @override
  String get error => '错误';

  @override
  String error_with_message(Object error) {
    return '错误：$error';
  }

  @override
  String get no_pages_available => '错误：无可用页面';

  @override
  String get set_categories => '设置分类';

  @override
  String get edit => '编辑';

  @override
  String get in_library => '已在书架';

  @override
  String get filter_scanlator_groups => '汉化组';

  @override
  String get reset => '重置';

  @override
  String get by_source => '按来源';

  @override
  String get by_chapter_number => '按章节号';

  @override
  String get by_episode_number => '按集数';

  @override
  String get by_upload_date => '按上传日期';

  @override
  String get source_title => '来源标题';

  @override
  String get create_extension => '创建扩展';

  @override
  String get developer_mode => '开发者模式';

  @override
  String get developer_mode_subtitle => '显示扩展开发者工具（创建扩展、编辑代码）';

  @override
  String get choose_extension_language => '选择扩展语言';

  @override
  String get lang => '语言';

  @override
  String get base_url => '基础 URL';

  @override
  String get api_url_optional => 'API URL（可选）';

  @override
  String get icon_url => '图标 URL';

  @override
  String get source_icon_url => '图源图标 URL';

  @override
  String get notes => '备注';

  @override
  String get extension_name_example => '例如：myAnime';

  @override
  String get language_code_example => '例如：zh';

  @override
  String get base_url_example => '例如：https://example.com';

  @override
  String get api_url_example => '例如：https://api.example.com';

  @override
  String get extension_notes_example => '例如：此扩展需要登录';

  @override
  String get type => '类型';

  @override
  String get target => '目标';

  @override
  String get source_type_single => '单一';

  @override
  String get source_type_multi => '多源';

  @override
  String get source_type_torrent => '种子 (Torrent)';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader 编译 JS';

  @override
  String get source_created_successfully => '图源创建成功';

  @override
  String get source_already_exists => '图源已存在';

  @override
  String get error_when_creating_source => '创建图源时出错';

  @override
  String get cookies_deleted => 'Cookie 已删除！';

  @override
  String get delete_all_cookies => '删除所有 Cookie';

  @override
  String get chapter_number => '章节号';

  @override
  String get episode_number => '集数';

  @override
  String get share => '分享';

  @override
  String n_chapters(Object n) {
    return '$n章';
  }

  @override
  String missing_chapters(Object count) {
    return '缺少 $count 个章节';
  }

  @override
  String get no_description => '无描述';

  @override
  String get resume => '继续';

  @override
  String get read => '阅读';

  @override
  String get watch => '观看';

  @override
  String get popular => '流行';

  @override
  String get open_in_browser => '在浏览器中打开';

  @override
  String get clear_cookie => '清除Cookie';

  @override
  String get show_page_number => '显示页码';

  @override
  String get from_library => '来自图书馆';

  @override
  String get downloaded_chapter => '已下载章节';

  @override
  String page(Object page) {
    return '页面 $page';
  }

  @override
  String get global_search => '全局搜索';

  @override
  String get color_blend_level => '颜色混合级别';

  @override
  String current(Object char) {
    return '当前 $char';
  }

  @override
  String finished(Object char) {
    return '完成 $char';
  }

  @override
  String next(Object char) {
    return '下一个 $char';
  }

  @override
  String previous(Object char) {
    return '上一个 $char';
  }

  @override
  String get no_more_chapter => '没有更多章节';

  @override
  String get no_result => '无结果';

  @override
  String get send => '发送';

  @override
  String get delete => '删除';

  @override
  String get start_downloading => '立即开始下载';

  @override
  String get retry => '重试';

  @override
  String get add_chapters => '添加章节';

  @override
  String get delete_chapters => '删除章节？';

  @override
  String get default0 => '默认';

  @override
  String get total_chapters => '总章节数';

  @override
  String get total_episodes => '总集数';

  @override
  String get import_local_file => '导入本地文件';

  @override
  String get import_files => '文件';

  @override
  String get split_epub_chapters => '分章节导入';

  @override
  String get split_epub_chapters_description => '将每个EPUB章节作为单独条目导入';

  @override
  String get nothing_read_recently => '最近未阅读';

  @override
  String get status => '状态';

  @override
  String get not_started => '未开始';

  @override
  String get score => '评分';

  @override
  String get start_date => '开始日期';

  @override
  String get finish_date => '完成日期';

  @override
  String get reading => '阅读';

  @override
  String get on_hold => '搁置';

  @override
  String get dropped => '已放弃';

  @override
  String get plan_to_read => '计划阅读';

  @override
  String get re_reading => '重读';

  @override
  String get chapters => '章节';

  @override
  String get add_tracker => '添加追踪';

  @override
  String get one_tracker => '1个追踪器';

  @override
  String n_tracker(Object n) {
    return '$n个追踪器';
  }

  @override
  String get tracking => '追踪';

  @override
  String get syncing => '同步';

  @override
  String get sync_logged => '登录成功';

  @override
  String get syncing_subtitle => '填写你使用的同步服务器地址，通过浏览器登录后，在设备间同步阅读进度。';

  @override
  String get sync_service => '自建同步服务';

  @override
  String get last_sync => '上次同步时间：';

  @override
  String get sync_login_browser => '使用浏览器登录';

  @override
  String get sync_server => '同步服务器地址';

  @override
  String get sync_starting => '开始同步...';

  @override
  String get sync_finished => '同步完成';

  @override
  String get sync_failed => '同步失败';

  @override
  String get sync_restore_in_progress => '已跳过同步 — 正在恢复中';

  @override
  String sync_progress_percent(Object percent) {
    return '正在同步… $percent%';
  }

  @override
  String get sync_progress_indeterminate => '正在同步…';

  @override
  String get sync_button_sync => '同步进度';

  @override
  String get sync_button_upload => '仅上传';

  @override
  String get sync_button_upload_info => '此操作将完全用本地数据替换远程数据！';

  @override
  String get sync_button_download => '仅下载';

  @override
  String get sync_button_download_info => '此操作将完全用远程数据替换本地数据！';

  @override
  String get sync_status_not_configured => '未连接';

  @override
  String get sync_status_checking => '正在检查连接...';

  @override
  String get sync_status_connected => '已连接';

  @override
  String get sync_status_unauthorized => '会话已过期，请重新登录';

  @override
  String get sync_status_unreachable => '无法连接到服务器';

  @override
  String get sync_section_general => '通用';

  @override
  String get sync_on => '启用同步';

  @override
  String get sync_auto => '自动同步';

  @override
  String get sync_auto_warning => '自动同步目前是实验性功能！';

  @override
  String get sync_auto_off => '关闭';

  @override
  String get sync_auto_5_minutes => '每5分钟';

  @override
  String get sync_auto_10_minutes => '每10分钟';

  @override
  String get sync_auto_30_minutes => '每30分钟';

  @override
  String get sync_auto_1_hour => '每1小时';

  @override
  String get sync_auto_3_hours => '每3小时';

  @override
  String get sync_auto_6_hours => '每6小时';

  @override
  String get sync_auto_12_hours => '每12小时';

  @override
  String get server_error => '服务器错误！';

  @override
  String get dialog_confirm => '确认';

  @override
  String get description => '描述';

  @override
  String get reorder_navigation => '自定义导航';

  @override
  String get reorder_navigation_description => '根据需要重新排序和切换每个导航。';

  @override
  String get floating_navigation_bar => '悬浮导航栏';

  @override
  String get floating_navigation_bar_description => '使用悬浮胶囊式导航栏。';

  @override
  String get full_screen_player => '使用全屏';

  @override
  String get full_screen_player_info => '播放视频时自动使用全屏。';

  @override
  String episode_progress(Object n) {
    return '进度：$n';
  }

  @override
  String n_episodes(int n) {
    return '$n集';
  }

  @override
  String missing_episodes(Object count) {
    return '缺少 $count 集';
  }

  @override
  String get manga_sources => '漫画来源';

  @override
  String get anime_sources => '动画来源';

  @override
  String get novel_sources => '小说来源';

  @override
  String get anime_extensions => '动画扩展';

  @override
  String get manga_extensions => '漫画扩展';

  @override
  String get novel_extensions => '小说扩展';

  @override
  String get extension_settings => '扩展设置';

  @override
  String get anime => '动画';

  @override
  String get manga => '漫画';

  @override
  String get novel => '小说';

  @override
  String get library_no_category_exist => '你还没有任何类别';

  @override
  String get watching => '观看中';

  @override
  String get plan_to_watch => '计划观看';

  @override
  String get re_watching => '重看';

  @override
  String get episodes => '集';

  @override
  String get download => '下载';

  @override
  String get new_update_available => '发现新版本';

  @override
  String app_version(Object v) {
    return '应用版本：v$v';
  }

  @override
  String get searching_for_updates => '正在搜索更新...';

  @override
  String get no_new_updates_available => '没有新的更新可用';

  @override
  String get uninstall => '卸载';

  @override
  String uninstall_extension(Object ext) {
    return '卸载 $ext 扩展？';
  }

  @override
  String double_tap_search_hint(Object type) {
    return '双击以搜索全部 $type';
  }

  @override
  String get show_nav_double_tap_tooltip => '显示双击搜索提示';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      '在漫画/动画/小说导航栏上显示提示，说明双击可打开全局搜索。';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" 已通过 $source 添加到您的书架中。';
  }

  @override
  String get add_anyway => '仍然添加';

  @override
  String get langauage => '语言';

  @override
  String get extension_detail => '扩展详情';

  @override
  String get scale_type => '缩放类型';

  @override
  String get scale_type_fit_screen => '适合屏幕';

  @override
  String get scale_type_stretch => '拉伸';

  @override
  String get scale_type_fit_width => '适合宽度';

  @override
  String get scale_type_fit_height => '适合高度';

  @override
  String get scale_type_original_size => '原始大小';

  @override
  String get scale_type_smart_fit => '智能适配';

  @override
  String get page_preload_amount => '页面预加载量';

  @override
  String get page_preload_amount_subtitle =>
      '阅读时预加载的页面数量。更高的值将导致更顺畅的阅读体验，但会增加缓存和网络使用。';

  @override
  String get image_loading_error => '无法加载此图片';

  @override
  String get add_episodes => '添加集数';

  @override
  String get video_quality => '质量';

  @override
  String get video_subtitle => '字幕';

  @override
  String get check_for_extension_updates => '检查第三方扩展更新';

  @override
  String get auto_extensions_updates => '自动更新第三方扩展';

  @override
  String get auto_extensions_updates_subtitle => '自动更新已安装的第三方扩展。官方插件始终自动安装和更新。';

  @override
  String get check_for_app_updates => '启动时检查应用更新';

  @override
  String get reading_mode => '阅读模式';

  @override
  String get custom_filter => '自定义筛选';

  @override
  String get background_color => '背景颜色';

  @override
  String get white => '白色';

  @override
  String get black => '黑色';

  @override
  String get grey => '灰色';

  @override
  String get automaic => '自动';

  @override
  String get preferred_domain => '首选域';

  @override
  String get load_more => '加载更多';

  @override
  String get cancel_all_for_this_series => '为此系列取消所有';

  @override
  String get login => '登录';

  @override
  String login_into(Object tracker) {
    return '登录到 $tracker';
  }

  @override
  String get email_adress => '电子邮件地址';

  @override
  String get password => '密码';

  @override
  String log_out_from(Object tracker) {
    return '从 $tracker 注销？';
  }

  @override
  String get log_out => '注销';

  @override
  String get update_pending => '更新待定';

  @override
  String get update_all => '更新全部';

  @override
  String get backup_and_restore => '备份和恢复';

  @override
  String get create_backup => '创建备份';

  @override
  String get create_backup_dialog_title => '你想要备份什么？';

  @override
  String get create_backup_subtitle => '可用于恢复当前图书馆';

  @override
  String get restore_backup => '恢复备份';

  @override
  String get encrypt_backups => '加密备份';

  @override
  String get encrypt_backups_info => '使用 AES 加密和密码保护备份文件';

  @override
  String get no_secure_storage => '未找到安全存储';

  @override
  String get no_keyring_warning => '当前系统没有密钥环服务，无法安全存储密码。\n\n是否以明文形式存储在本地数据库中？';

  @override
  String get enter_backup_password => '输入备份密码';

  @override
  String get incorrect_password_try_again => '密码错误，请重试。';

  @override
  String get set_backup_password => '设置备份密码';

  @override
  String get confirm_password => '确认密码';

  @override
  String get passwords_do_not_match => '密码不匹配';

  @override
  String get password_required_to_restore => '需要密码才能恢复此备份。';

  @override
  String get restore_backup_subtitle => '从备份文件恢复图书馆';

  @override
  String get automatic_backups => '自动备份';

  @override
  String get backup_frequency => '备份频率';

  @override
  String get backup_location => '备份位置';

  @override
  String get backup_options => '备份选项';

  @override
  String get backup_options_dialog_title => '你想要备份什么？';

  @override
  String get backup_options_subtitle => '包含在备份文件中的信息';

  @override
  String get backup_and_restore_warning_info => '你应该在其他地方保存备份副本';

  @override
  String get library_entries => '图书馆条目';

  @override
  String get chapters_and_episode => '章节和集数';

  @override
  String get every_6_hours => '每6小时';

  @override
  String get every_12_hours => '每12小时';

  @override
  String get daily => '每日';

  @override
  String get every_2_days => '每2天';

  @override
  String get weekly => '每周';

  @override
  String get restore_backup_warning_title => '恢复备份将覆盖所有现有数据。\n\n继续恢复？';

  @override
  String get restore_sync_question_title => '是否同步此次恢复？';

  @override
  String get restore_sync_question_message => '此设备已连接到同步服务器。是否立即将恢复的数据上传？';

  @override
  String get restore_sync_question_confirm => '是，进行同步';

  @override
  String get restore_sync_question_deny => '否，禁用同步';

  @override
  String get sync_disabled_after_restore => '同步已禁用。您可以在“设置”中重新开启。';

  @override
  String get restore_sync_disabled_question_title => '同步当前已禁用';

  @override
  String get restore_sync_disabled_question_message =>
      '同步已关闭。是否重新开启并将恢复的数据上传到服务器？';

  @override
  String get restore_sync_question_reenable => '是，重新开启并同步';

  @override
  String get restore_sync_question_keep_disabled => '保持禁用';

  @override
  String get restore_sync_uploading => '正在同步恢复的数据到服务器…';

  @override
  String get restore_sync_upload_success => '恢复的数据已同步到服务器';

  @override
  String get services => '服务';

  @override
  String get tracking_warning_info => '单向同步以更新跟踪服务中的章节进度。从它们的跟踪按钮为个别条目设置跟踪。';

  @override
  String get use_page_tap_zones => '使用页面点击区域';

  @override
  String get manage_trackers => '管理跟踪器';

  @override
  String get restore => '恢复';

  @override
  String get backups => '备份';

  @override
  String get by_scanlator => '按翻译者';

  @override
  String get by_name => '按名称';

  @override
  String get installed => '已安装';

  @override
  String get auto_scroll => '自动滚动';

  @override
  String get video_audio => '音频';

  @override
  String get video_audio_info => '首选语言、音调校正、音频通道';

  @override
  String get player => '播放器';

  @override
  String get markEpisodeAsSeenSetting => '标记剧集为已看的时间点';

  @override
  String get mark_duplicate_chapters_read => '将重复的章节号标记为已读';

  @override
  String get default_skip_intro_length => '片头跳过时长';

  @override
  String get default_playback_speed_length => '默认播放速度';

  @override
  String get updateProgressAfterReading => '阅读后更新进度';

  @override
  String get no_sources_installed => '还没有可用来源';

  @override
  String get show_extensions => '显示扩展';

  @override
  String get default_skip_forward_skip_length => '双击快进／快退时长';

  @override
  String get aniskip_requires_info =>
      '使用 AniSkip 前，需要将动画关联到 MyAnimeList 或 AniList 追踪。';

  @override
  String get enable_aniskip => '启用 AniSkip';

  @override
  String get enable_auto_skip => '启用自动跳过';

  @override
  String get aniskip_button_timeout => '按钮超时';

  @override
  String get skip_opening => '跳过片头';

  @override
  String get skip_ending => '跳过片尾';

  @override
  String get fullscreen => '全屏';

  @override
  String get update_library => '更新库';

  @override
  String get next_chapter => '下一章';

  @override
  String get next_5_chapters => '下5章';

  @override
  String get next_10_chapters => '下10章';

  @override
  String get next_25_chapters => '下25章';

  @override
  String get all_chapters => '所有章节';

  @override
  String get next_episode => '下一集';

  @override
  String get next_5_episodes => '接下来的 5 集';

  @override
  String get next_10_episodes => '接下来的 10 集';

  @override
  String get next_25_episodes => '接下来的 25 集';

  @override
  String get all_episodes => '所有剧集';

  @override
  String get cover_saved => '封面已保存';

  @override
  String get set_as_cover => '设置为封面';

  @override
  String get use_this_as_cover_art => '使用此作为封面？';

  @override
  String get save => '保存';

  @override
  String get picture_saved => '图片已保存';

  @override
  String get cover_updated => '封面已更新';

  @override
  String get include_subtitles => '包含字幕';

  @override
  String get blend_mode_default => '默认';

  @override
  String get blend_mode_multiply => '正片叠底';

  @override
  String get blend_mode_screen => '滤色';

  @override
  String get blend_mode_overlay => '叠加';

  @override
  String get blend_mode_colorDodge => '颜色减淡';

  @override
  String get blend_mode_lighten => '变亮';

  @override
  String get blend_mode_colorBurn => '颜色加深';

  @override
  String get blend_mode_darken => '变暗';

  @override
  String get blend_mode_difference => '差异';

  @override
  String get blend_mode_saturation => '饱和度';

  @override
  String get blend_mode_softLight => '柔光';

  @override
  String get blend_mode_plus => '加';

  @override
  String get blend_mode_exclusion => '排除';

  @override
  String get custom_color_filter => '自定义颜色滤镜';

  @override
  String get color_filter_blend_mode => '颜色滤镜混合模式';

  @override
  String get enable_all => '启用全部';

  @override
  String get disable_all => '禁用全部';

  @override
  String get font => '字体';

  @override
  String get color => '颜色';

  @override
  String get font_size => '字号';

  @override
  String get text => '文本';

  @override
  String get border => '边框';

  @override
  String get background => '背景';

  @override
  String get no_subtite_warning_message => '由于此视频中没有字幕轨道，因此无效。';

  @override
  String get grid_size => '网格大小';

  @override
  String n_per_row(Object n) {
    return '$n 每行';
  }

  @override
  String get horizontal_continious => '水平连续';

  @override
  String get edit_code => '编辑代码';

  @override
  String get use_libass => '启用 libass';

  @override
  String get use_libass_info => '使用基于 libass 的字幕渲染作为本地后端。';

  @override
  String get libass_not_disable_message => '在播放器设置中禁用 `use libass` 以便自定义字幕。';

  @override
  String get override_ass_subtitles => '覆盖 ASS 字幕样式';

  @override
  String get override_ass_subtitles_info => '将自定义样式应用到 ASS/SSA 字幕';

  @override
  String get torrent_stream => '种子流';

  @override
  String get add_torrent => '添加种子';

  @override
  String get enter_torrent_hint_text => '输入磁力链接或种子文件 URL';

  @override
  String get torrent_url => '种子 URL';

  @override
  String get or => '或';

  @override
  String get advanced => '高级';

  @override
  String get advanced_info => 'mpv 配置';

  @override
  String get use_native_http_client => '使用本地 HTTP 客户端';

  @override
  String get use_native_http_client_info =>
      '它自动支持平台特性，如 VPN，支持更多 HTTP 特性，如 HTTP/3 和自定义重定向处理';

  @override
  String n_hour_ago(Object hour) {
    return '$hour小时前';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours小时前';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute分钟前';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes分钟前';
  }

  @override
  String n_day_ago(Object day) {
    return '$day天前';
  }

  @override
  String get now => '现在';

  @override
  String library_last_updated(Object lastUpdated) {
    return '图书馆最近更新时间：$lastUpdated';
  }

  @override
  String get data_and_storage => '数据与存储';

  @override
  String get download_location_info => '用于章节下载';

  @override
  String get storage => '存储';

  @override
  String get clear_chapter_and_episode_cache => '清除章节和剧集缓存';

  @override
  String get cache_cleared => '缓存已清除';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch => '启动应用时清除章节/剧集缓存';

  @override
  String get app_settings => '应用设置';

  @override
  String get sources_settings => '来源设置';

  @override
  String get include_sensitive_settings => '包含敏感设置（例如追踪器登录令牌）';

  @override
  String get create => '创建';

  @override
  String get downloads_are_limited_to_wifi => '下载仅限于WiFi';

  @override
  String get recommendations => '推荐';

  @override
  String get recommendations_similar => '相似';

  @override
  String get recommendations_weights => '推荐权重';

  @override
  String get recommendations_weights_genre => '类型相似度';

  @override
  String get recommendations_weights_setting => '设定相似度';

  @override
  String get recommendations_weights_synopsis => '故事相似度';

  @override
  String get recommendations_weights_theme => '主题相似度';

  @override
  String get manga_extensions_repo => '漫画扩展库';

  @override
  String get anime_extensions_repo => '动画扩展库';

  @override
  String get novel_extensions_repo => '小说扩展库';

  @override
  String get custom_dns => '自定义 DNS（留空使用系统 DNS）';

  @override
  String get android_proxy_server => 'Android 代理服务器（M-Extension-Server）';

  @override
  String get get_m_extension_server => '获取 M-Extension-Server';

  @override
  String get undefined => '未定义';

  @override
  String get empty_extensions_repo => '扩展库为空';

  @override
  String get add_extensions_repo => '添加扩展库';

  @override
  String get remove_extensions_repo => '移除扩展库';

  @override
  String get manage_manga_repo_urls => '管理漫画库URL';

  @override
  String get manage_anime_repo_urls => '管理动画库URL';

  @override
  String get manage_novel_repo_urls => '管理小说库URL';

  @override
  String get url_cannot_be_empty => 'URL不能为空';

  @override
  String get url_must_end_with_dot_json_or_dot_pb => 'URL必须以.json结尾';

  @override
  String get repo_url => '库URL';

  @override
  String get invalid_url_format => '无效的URL格式';

  @override
  String get clear_all_sources => '清除所有来源';

  @override
  String get clear_all_sources_msg => '你确定吗？所有来源将被清除';

  @override
  String get sources_cleared => '来源已清除';

  @override
  String get repo_added => '库已添加';

  @override
  String get repo_already_exists => '软件源仓库已存在！';

  @override
  String get add_repo => '添加库';

  @override
  String get add_repo_sources_to_add => '将添加以下扩展列表：';

  @override
  String get add_repo_warning => '这些仓库的扩展会在应用内运行。请仅添加可信的仓库。';

  @override
  String get genre_search_library => '按类别搜索图书馆';

  @override
  String get genre_search_source => '按类别搜索来源';

  @override
  String get source_not_added => '来源未添加';

  @override
  String get load_own_subtitles => '加载自定义字幕';

  @override
  String get search_subtitles => '在线搜索字幕...';

  @override
  String extension_notes(Object notes) {
    return '备注：$notes';
  }

  @override
  String get unsupported_repo => '无法添加此来源仓库。请检查仓库地址，或联系该仓库的维护者。';

  @override
  String get you_have_finished_reading => '您已读完';

  @override
  String get hwdec => '硬件解码器';

  @override
  String get enable_hardware_accel => '硬件加速';

  @override
  String get enable_hardware_accel_info => '如果遇到错误或崩溃，请打开/关闭';

  @override
  String get track_library_navigate => '转到现有本地条目';

  @override
  String get track_library_add => '添加到本地库';

  @override
  String get track_library_add_confirm => '将跟踪项目添加到本地库';

  @override
  String get track_library_not_logged => '请登录相应的跟踪器以使用此功能！';

  @override
  String get track_library_switch => '切换到另一个跟踪器';

  @override
  String get go_back => '返回';

  @override
  String get merge_library_nav_mobile => '在移动设备上合并库导航';

  @override
  String get enable_discord_rpc => '启用 Discord RPC';

  @override
  String get hide_discord_rpc_incognito => '隐身模式下隐藏 Discord RPC';

  @override
  String get rpc_show_reading_watching_progress => '在 Discord 中显示当前章节（需要重启）';

  @override
  String get rpc_show_title => '在 Discord 中显示当前标题';

  @override
  String get rpc_show_cover_image => '在 Discord 中显示当前封面图片';

  @override
  String get enable_mpv => '启用 mpv 着色器/脚本';

  @override
  String get mpv_info => '支持 mpv/scripts/ 下的 .js 脚本';

  @override
  String get mpv_redownload => '重新下载 mpv 配置文件';

  @override
  String get mpv_redownload_info => '用新配置文件替换旧配置文件！';

  @override
  String get mpv_download => '需要 MPV 配置文件！\n现在下载？';

  @override
  String get custom_buttons => '自定义按钮';

  @override
  String get custom_buttons_info => '使用自定义按钮执行 lua 代码';

  @override
  String get custom_buttons_edit => '编辑自定义按钮';

  @override
  String get custom_buttons_add => '添加自定义按钮';

  @override
  String get custom_buttons_added => '已添加自定义按钮！';

  @override
  String get custom_buttons_delete => '删除自定义按钮';

  @override
  String get custom_buttons_text => '按钮文本';

  @override
  String get custom_buttons_text_req => '按钮文本必填';

  @override
  String get custom_buttons_js_code => 'lua 代码';

  @override
  String get custom_buttons_js_code_req => 'lua 代码必填';

  @override
  String get custom_buttons_js_code_long => 'lua 代码（长按时）';

  @override
  String get custom_buttons_startup => 'lua 代码（启动时）';

  @override
  String get custom_buttons_add_warning =>
      '此按钮会在视频播放器中运行下方 Lua 代码，可访问文件并运行程序。请仅在信任此链接来源时添加。';

  @override
  String n_days(Object n) {
    return '$n 天';
  }

  @override
  String get decoder => '解码器';

  @override
  String get decoder_info => '硬件解码、像素格式、去色带';

  @override
  String get enable_gpu_next => '启用 gpu-next（仅限 Android）';

  @override
  String get enable_gpu_next_info => '新的视频渲染引擎';

  @override
  String get debanding => '去色带';

  @override
  String get use_yuv420p => '使用 YUV420P 像素格式';

  @override
  String get use_yuv420p_info => '可以修复某些视频编解码器上的黑屏，也可以以质量为代价提高性能';

  @override
  String get audio_preferred_languages => '首选语言';

  @override
  String get audio_preferred_languages_info =>
      '在具有多个音频流的视频上默认选择的音频语言，2/3 字母语言代码（例如：zh、en、ja）。多个值可以用逗号分隔。';

  @override
  String get enable_audio_pitch_correction => '启用音频音调校正';

  @override
  String get enable_audio_pitch_correction_info => '防止音频在较快速度时变高音，在较慢速度时变低音';

  @override
  String get audio_channels => '音频通道';

  @override
  String get volume_boost_cap => '音量增强上限';

  @override
  String get internal_player => '内部播放器';

  @override
  String get internal_player_info => '进度、控制、方向';

  @override
  String get subtitle_delay_text => '字幕延迟';

  @override
  String get subtitle_delay => '延迟（毫秒）';

  @override
  String get subtitle_speed => '速度';

  @override
  String get tracks => '轨道';

  @override
  String get playback_speed => '播放速度';

  @override
  String get shaders => '着色器';

  @override
  String get video_fit => '画面适配';

  @override
  String get calendar => '日历';

  @override
  String get calendar_no_data => '暂无数据。';

  @override
  String get calendar_info => '日历只能根据旧的上传预测下一章的上传。某些数据可能不是 100% 准确！';

  @override
  String in_n_day(Object days) {
    return '$days 天后';
  }

  @override
  String in_n_days(Object days) {
    return '$days 天后';
  }

  @override
  String get clear_library => '清空库';

  @override
  String get clear_library_desc => '选择清除所有漫画、动画和/或小说条目';

  @override
  String get clear_library_input =>
      '输入 \'manga\'、\'anime\' 和/或 \'novel\'（用逗号分隔）以删除所有相关条目';

  @override
  String get watch_order => '观看顺序';

  @override
  String get watch_order_role_current => '当前';

  @override
  String get watch_order_role_previous => '上一部';

  @override
  String get watch_order_role_next => '下一部';

  @override
  String get watch_order_source_release_order => '发行顺序';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name · 作者：$author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Trakt 官方合集：$name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt 合集：$name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return '《$title》的各季';
  }

  @override
  String get watch_order_select_source => '顺序来源';

  @override
  String watch_order_season(int number) {
    return '第 $number 季';
  }

  @override
  String watch_order_episode(int number) {
    return '第 $number 集';
  }

  @override
  String get sequels => '续集';

  @override
  String get recommendations_similarity => '相似度：';

  @override
  String recommendation_rating_accessibility(String rating) {
    return '评分 $rating';
  }

  @override
  String get local_folder_structure => '本地文件夹结构';

  @override
  String get local_folder => '本地文件夹';

  @override
  String get add_local_folder => '添加本地文件夹';

  @override
  String get rescan_local_folder => '立即重新扫描所有本地文件夹';

  @override
  String get default_download_destination => '默认下载位置';

  @override
  String get ask_download_destination => '每次下载前询问位置';

  @override
  String get ask_download_destination_desc => '每次开始下载时选择本地文件夹。';

  @override
  String get select_download_destination => '选择下载位置';

  @override
  String get clear_local_library => '清空本地书库';

  @override
  String get clear_local_library_desc => '从书库中移除本地文件夹和压缩包条目。';

  @override
  String get clear_local_library_msg => '这将从书库中移除本地条目，不会删除磁盘上的文件。';

  @override
  String get custom => '自定义';

  @override
  String get no_local_folder_available_for_downloads => '没有可用于下载的本地文件夹';

  @override
  String failed_to_create_cbz(Object error) {
    return '创建 CBZ 失败：$error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return '读取封面出错：$error';
  }

  @override
  String error_reading_metadata(Object error) {
    return '读取元数据出错：$error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return '保存到书库时出错：$error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return '读取章节封面出错：$error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return '读取归档封面出错：$error';
  }

  @override
  String error_getting_local_library(Object error) {
    return '获取本地书库时出错：$error';
  }

  @override
  String get export_metadata => '导出元数据';

  @override
  String get exported => '已导出';

  @override
  String failed_to_export_metadata(Object error) {
    return '导出元数据失败：$error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '有 $count 个章节无法自动编号，可能在阅读器中缺失或顺序错乱。';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      '无法启动 Cloudflare 验证 Webview 服务。';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker 令牌已过期';
  }

  @override
  String get video_list_empty => '视频列表为空';

  @override
  String playback_speed_multiplier(Object value) {
    return '${value}x';
  }

  @override
  String could_not_launch_url(Object url) {
    return '无法打开 $url';
  }

  @override
  String get text_size => '文字大小：';

  @override
  String get text_align => '文字对齐';

  @override
  String get line_height => '行高';

  @override
  String get show_scroll_percentage => '显示滚动百分比';

  @override
  String get remove_extra_paragraph_spacing => '删除额外的段落间距';

  @override
  String select_label_color(Object label) {
    return '选择 $label 颜色';
  }

  @override
  String get default_user_agent => '默认用户代理';

  @override
  String get forceLandscapeMode => '强制横屏模式';

  @override
  String get forceLandscapeModeSubtitle => '强制播放器使用横屏方向。';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNS提供商';

  @override
  String get tracked => '已追踪';

  @override
  String get auth_unlock_msg => '验证以解锁应用';

  @override
  String get app_locked => '应用已锁定';

  @override
  String get auth_to_continue => '验证以继续';

  @override
  String get authenticating => '正在验证...';

  @override
  String get lock => '锁定';

  @override
  String get unlock => '解锁';

  @override
  String get security => '安全';

  @override
  String get auth_to_change_security_setting => '验证以更改安全设置';

  @override
  String get app_lock => '应用锁';

  @override
  String get require_biometric_or_device_credential => '需要生物识别或设备凭证才能打开应用';

  @override
  String get biometric_or_device_credential_not_available =>
      '此设备暂不可使用生物识别或设备密码验证';

  @override
  String get app_lock_description => '启用应用锁后，每次打开应用或从后台返回时都会要求您进行身份验证。';

  @override
  String get checking_device_authentication => '正在检查设备验证方式…';

  @override
  String get device_authentication_incomplete => '验证未完成，设置保持不变。';

  @override
  String get keep_screen_on => '保持屏幕开启';

  @override
  String get webtoon_side_padding => 'Webtoon侧边填充';

  @override
  String get show_page_gaps => '显示页面间隙';

  @override
  String get invert_colors => '反转颜色';

  @override
  String get grayscale => '灰度';

  @override
  String get brightness => '亮度';

  @override
  String get contrast => '对比度';

  @override
  String get saturation => '饱和度';

  @override
  String get navigation_layout => '导航布局';

  @override
  String get nav_layout_default => '默认';

  @override
  String get nav_layout_l_shaped => 'L形';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => '边缘';

  @override
  String get nav_layout_right_and_left => '右和左';

  @override
  String get nav_layout_disabled => '已禁用';

  @override
  String get color_enhancements => '色彩增强';

  @override
  String get total => '总计';

  @override
  String get mean_per_title => '单个标题平均';

  @override
  String get completion_rate => '完成率';

  @override
  String get watching_time => '观看时间';

  @override
  String get reading_time => '阅读时间';

  @override
  String average_chapters_per_title(Object title) {
    return '每部$title的平均章节数';
  }

  @override
  String get read_percentage => '阅读百分比';

  @override
  String get entries => '条目';

  @override
  String get android_proxy_server_mihon => 'Android 代理服务器（Mihon）';

  @override
  String get android_proxy_server_mihon_description =>
      '下载并配置使用 Mihon 扩展所需的代理服务器。';

  @override
  String get mihon_proxy_server => 'Mihon 代理服务器';

  @override
  String get extension_server_intro_with_jre =>
      '在使用 Mihon 扩展前请先下载代理服务器包。该包内含 JRE 和扩展服务器 JAR。';

  @override
  String get extension_server_intro_ios =>
      '在使用 Mihon 扩展前请先下载代理服务器 JAR。iOS 仅需扩展服务器 JAR。';

  @override
  String get checking_files => '正在检查文件';

  @override
  String get files_installed => '文件已安装';

  @override
  String get files_missing => '文件缺失';

  @override
  String get update_files => '更新文件';

  @override
  String get up_to_date => '已是最新';

  @override
  String get choose_location => '选择路径';

  @override
  String get import_existing_jar => '导入现有 JAR';

  @override
  String get detect_files_in_selected_folder => '在选定文件夹中检测文件';

  @override
  String get preparing_download => '正在准备下载...';

  @override
  String get app_install_location => '应用安装路径';

  @override
  String get install_location => '安装位置';

  @override
  String get jre_executable => 'JRE 可执行文件';

  @override
  String get extension_server_jar => '扩展服务器 JAR';

  @override
  String get installed_version => '当前版本';

  @override
  String get latest_version => '最新版本';

  @override
  String get m_extension_server_description =>
      '当您需要独立的 Android 设备代理时，请使用 M-Extension-Server。在此设置代理地址，并从 GitHub 下载 APK。';

  @override
  String get set_proxy_address => '设置代理地址';

  @override
  String get no_newer_proxy_server_release_available => '没有可用的新代理服务器版本。';

  @override
  String get could_not_check_proxy_server_updates => '无法检查代理服务器更新。';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      '当前平台没有可用的扩展服务器包。';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return '下载包失败 ($statusCode)。';
  }

  @override
  String get downloaded_bundle_missing_expected_files => '下载的项目不包含预期文件。';

  @override
  String get extension_server_files_ready => '扩展服务器文件已就绪。';

  @override
  String get ios_extension_server_import_hint =>
      '在 iOS 上，服务器安装在应用沙盒内。请使用“导入现有 JAR”来导入已下载的文件。';

  @override
  String get select_extension_server_folder => '选择扩展服务器文件夹';

  @override
  String get selected_folder_does_not_exist => '选定文件夹不存在。';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      '在选定文件夹中未找到扩展服务器文件。';

  @override
  String get extension_server_files_linked => '扩展服务器文件已链接。';

  @override
  String get select_extension_server_jar => '选择扩展服务器 JAR';

  @override
  String get selected_file_could_not_be_accessed => '选定文件无法访问。';

  @override
  String get extension_server_jar_imported => '扩展服务器 JAR 已导入。';

  @override
  String get could_not_launch_apk_bridge_page => '无法启动 M-Extension-Server 页面。';

  @override
  String get proxy_server_ip_hint =>
      '服务器 IP（例如 10.0.0.5 或 https://example.com）';

  @override
  String get not_configured => '未配置';

  @override
  String get zero_interpreter => 'Zero 解释器';

  @override
  String get zero_interpreter_description => '自动或手动控制 Zero 解释器服务。';

  @override
  String get start_server_on_launch => '启动时开启服务';

  @override
  String get runtime_status => '运行状态';

  @override
  String get running => '运行中';

  @override
  String get stopped => '已停止';

  @override
  String get start => '启动';

  @override
  String get stop => '停止';

  @override
  String get webview => 'Webview';

  @override
  String get tts => '文字转语音';

  @override
  String get tts_speed => '速度';

  @override
  String get tts_pitch => '音调';

  @override
  String get tts_language => '语言';

  @override
  String get tts_voice => '语音';

  @override
  String get tts_stop => '停止';

  @override
  String get tts_play => '播放';

  @override
  String get tts_pause => '暂停';

  @override
  String get tts_previous => '上一段';

  @override
  String get tts_next => '下一段';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return '第$current段，共$total段';
  }

  @override
  String get tts_settings => 'TTS设置';

  @override
  String get tts_default => '默认';

  @override
  String get webtoon_disable_zoom_out => 'Webtoon禁用缩小';

  @override
  String get webtoon_double_tap_zoom_enabled => 'Webtoon双击缩放';

  @override
  String get navigate_to_pan => '导航前移动已放大图像';

  @override
  String get navigate_to_pan_subtitle => '翻页前先移动放大的图像';

  @override
  String get split_wide_pages => '拆分双页';

  @override
  String get dual_page_invert => '反转拆分的半页';

  @override
  String get dual_page_rotate_to_fit => '旋转以适应';

  @override
  String get dual_page_rotate_to_fit_invert => '反转旋转方向';

  @override
  String get double_page_single_first_page => '首页单页显示';

  @override
  String get double_page_single_first_page_subtitle => '在双页模式下单页显示第一页（封面）';

  @override
  String get double_page_auto => '自动双页';

  @override
  String get double_page_auto_subtitle => '横屏时自动切换到双页模式';

  @override
  String get landscape_zoom => '横屏自动缩放';

  @override
  String get zoom_start_position => '缩放起始位置';

  @override
  String get zoom_start_left => '左';

  @override
  String get zoom_start_right => '右';

  @override
  String get zoom_start_center => '中';

  @override
  String get automatic_background => '自动背景';

  @override
  String get tapping_inversion => '点击反转';

  @override
  String get tapping_inversion_none => '无';

  @override
  String get tapping_inversion_horizontal => '水平';

  @override
  String get tapping_inversion_vertical => '垂直';

  @override
  String get tapping_inversion_both => '两者';

  @override
  String get flash_on_page_change => '翻页时闪烁';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED 防烧屏辅助';

  @override
  String get flash_color => '闪烁颜色';

  @override
  String get flash_color_black => '黑色';

  @override
  String get flash_color_white => '白色';

  @override
  String get flash_color_white_black => '白与黑';

  @override
  String get flash_interval_label => '闪烁间隔';

  @override
  String flash_interval_value(String n) {
    return '$n页';
  }

  @override
  String flash_interval(String n) {
    return '闪烁间隔：$n页';
  }

  @override
  String get flash_duration_label => '闪烁持续时间';

  @override
  String flash_duration_value(String n) {
    return '$n毫秒';
  }

  @override
  String flash_duration(String n) {
    return '闪烁持续时间：$n毫秒';
  }

  @override
  String get show_navigation_overlay_on_start => '启动时显示导航浮层';

  @override
  String get reader_hide_threshold => '隐藏阅读器界面的阈值';

  @override
  String get reader_hide_threshold_highest => '最高 (5 px)';

  @override
  String get reader_hide_threshold_high => '高 (13 px)';

  @override
  String get reader_hide_threshold_low => '低 (31 px)';

  @override
  String get reader_hide_threshold_lowest => '最低 (47 px)';

  @override
  String get error_no_pages_available => '错误：无可用页面';

  @override
  String get app_ui_scale => '界面缩放';

  @override
  String get app_ui_scale_subtitle => '根据你的屏幕和观看距离，使界面更大或更小。';

  @override
  String get allow_concurrent_downloads => '允许并发下载';

  @override
  String get allow_concurrent_downloads_subtitle =>
      '同时从不同来源下载。单个来源仍然一次下载一个章节，因此不会过载。关闭后，可在任何地方一次下载一个。';

  @override
  String get download_delay => '下载延迟';

  @override
  String get download_delay_subtitle => '关闭。在章节之间添加随机抖动的等待，以便更温柔地对待来源。';

  @override
  String get save_search => '保存搜索';

  @override
  String get saved_searches => '已保存的搜索';

  @override
  String get enter_search_to_save_first => '先输入搜索进行保存';

  @override
  String get no_saved_searches => '此来源还没有保存的搜索。\n执行搜索，然后选择\"保存搜索\"。';

  @override
  String get source => '来源';

  @override
  String get something_went_wrong => '出错了';

  @override
  String get startup_failed => 'NodeLane漫译 无法完成启动';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个图源无结果',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => '如何导入此备份？';

  @override
  String get import_mode_message => '选择将此备份合并到当前书库，还是完全替换当前书库。';

  @override
  String get import_mode_keep_existing => '合并';

  @override
  String get import_mode_keep_existing_subtitle => '添加新条目并更新匹配条目。不会删除现有内容。';

  @override
  String get import_mode_replace => '替换';

  @override
  String get import_mode_replace_subtitle => '清空当前书库并完全替换为备份内容。';

  @override
  String get replace_summary_title => '准备替换书库';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return '这将删除当前的所有条目（$currentCount 项），并替换为备份中的 $backupCount 项。';
  }

  @override
  String get replace_summary_confirm => '替换';

  @override
  String replace_result_message(Object count) {
    return '已将书库替换为备份中的 $count 个条目。';
  }

  @override
  String get category_conflict_title => '发现已有分类';

  @override
  String get category_conflict_message => '备份中包含书库中已存在的分类。';

  @override
  String get category_conflict_keep => '保留 — 合并到已有分类';

  @override
  String get category_conflict_delete => '删除 — 归为未分类';

  @override
  String get source_conflict_title => '未找到图源';

  @override
  String get source_conflict_message => '备份中的部分图源未安装相应扩展。';

  @override
  String get source_conflict_keep => '保留原名';

  @override
  String get import_summary_title => '准备导入';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '将导入 $newSeries 个新条目，更新 $updatedSeries 个已有条目，并添加 $newChapters 个章节。';
  }

  @override
  String get import_summary_confirm => '导入';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '已导入 $newSeries 个新条目，更新 $updatedSeries 个条目，添加 $newChapters 个章节。';
  }

  @override
  String get roll_back => '回滚';

  @override
  String get roll_back_confirm_message => '将书库恢复到本次更改前的安全快照。';

  @override
  String get roll_back_done => '已回滚至更改前的快照。';

  @override
  String get restoring_backup => '正在恢复书库…';

  @override
  String get roll_back_last_change => '回滚上次更改';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return '快照时间：$date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '有 $count 个最近更改可供回滚';
  }

  @override
  String get delete_source_title => '删除图源及其漫画';

  @override
  String get delete_source_subtitle => '从书库中删除指定图源的所有内容（含章节、下载和历史）。';

  @override
  String get delete_source_pick_title => '选择要删除的图源';

  @override
  String get delete_source_empty => '书库中没有找到图源。';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '删除 $sourceName？';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return '将永久删除 $mangaCount 部漫画、$chapterCount 个章节、$historyCount 条历史记录和 $updateCount 条更新记录。追踪关联将保留。除回滚外，此操作无法撤销。';
  }

  @override
  String get delete_source_also_remove_extension => '同时卸载对应扩展';

  @override
  String get delete_source_keep_history => '保留阅读历史';

  @override
  String get delete_source_keep_downloads => '保留下载记录';

  @override
  String get delete_source_button => '删除';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '已从 $sourceName 中删除 $mangaCount 部漫画。';
  }

  @override
  String get merge_manga_title => '合并重复漫画';

  @override
  String get merge_manga_subtitle => '查找同图源下标题相同的漫画并进行合并。';

  @override
  String get merge_manga_none_found => '未找到重复漫画。';

  @override
  String get merge_manga_pick_title => '可能重复的漫画';

  @override
  String get merge_manga_choose_primary_title => '要合并到哪一部漫画？';

  @override
  String get merge_manga_choose_primary_message => '其他条目的章节、历史和追踪将合并到所选项中。';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 章节',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => '合并';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '已将 $count 部重复漫画合并到 $mangaName。';
  }

  @override
  String get merge_preview_title => '确认合并';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '在其他条目中共找到 $totalChapters 个章节。其中 $duplicateChapters 个为重复章节，将保留有阅读进度的副本并移除其余重复项；将添加 $keptChapters 个章节。同时将移除 $duplicateTracks 条重复的追踪关联。';
  }

  @override
  String get memory_overlay => '显示内存占用';

  @override
  String get memory_overlay_subtitle => '实时显示应用占用的内存。可在滚动书架或阅读章节时实时观察设备上的内存变化。';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => '错误报告';

  @override
  String get error_reports_subtitle => '应用捕获的错误及反馈入口';

  @override
  String get error_reports_empty => '运行正常，无错误记录。';

  @override
  String get error_reports_likely_cause => '可能原因';

  @override
  String get error_reports_report => '在 GitHub 上反馈';

  @override
  String get error_reports_banner => 'NodeLane漫译 遇到了一个错误';

  @override
  String get error_reports_banner_action => '查看';

  @override
  String get error_reports_copy => '复制';

  @override
  String get error_reports_copied => '已复制到剪贴板';

  @override
  String get error_reports_clear => '清除';

  @override
  String get error_reports_extension_failure =>
      '此错误来自扩展插件，而非 NodeLane漫译 本身。扩展由插件仓库的维护者编写和维护，因此需要在插件仓库中修复。请向他们提供插件名称和当时正在打开的内容。';

  @override
  String get error_reports_already_reported => '已报告';

  @override
  String get error_reports_expected_failure =>
      '这通常是来源网站或网络问题，而非应用本身的问题（如链接已失效、服务器宕机或网络连接中断）。仅当在其他地方正常工作的来源上持续出现此问题时才有必要报告。';

  @override
  String get share_unavailable_copied => '此平台不支持分享，已复制到剪贴板。';

  @override
  String get onboarding_title => '欢迎使用 NodeLane漫译';

  @override
  String get onboarding_libraries_body => '选择您要阅读和观看的内容类型。';

  @override
  String get onboarding_nav_title => '您的书库';

  @override
  String get onboarding_nav_body => '可以为每种类型设置独立标签页，或合并在一个“书库”标签页中。';

  @override
  String get onboarding_nav_split => '独立标签页';

  @override
  String get onboarding_nav_merged => '统一书库标签页';

  @override
  String get onboarding_nav_inside => '点击“书库”可在各类型间切换';

  @override
  String get onboarding_next => '下一步';

  @override
  String get onboarding_restore => '恢复备份';

  @override
  String get onboarding_or_local => '或使用现有本地文件';

  @override
  String get onboarding_local_folder => '添加文件夹';

  @override
  String onboarding_local_existing(Object count) {
    return '已设置 $count 个文件夹';
  }

  @override
  String get onboarding_local_any_type => '支持漫画、动漫与轻小说。';

  @override
  String get onboarding_local_scanning => '正在扫描文件夹';

  @override
  String onboarding_local_found(Object count) {
    return '找到 $count 个作品';
  }

  @override
  String get onboarding_local_remove => '移除该文件夹';

  @override
  String get onboarding_local_in_downloads => '这是应用的下载文件夹。';

  @override
  String get onboarding_local_empty => '未找到内容。请选择父级文件夹。';

  @override
  String get onboarding_repo_failed => '无法读取该仓库。';

  @override
  String get onboarding_repo_title => '添加图源';

  @override
  String get onboarding_body => '添加仓库即可浏览和安装丰富的扩展插件。';

  @override
  String get onboarding_add => '添加仓库';

  @override
  String get onboarding_skip => '暂时跳过';

  @override
  String get onboarding_continue => '继续';

  @override
  String get onboarding_later => '您可以稍后在“设置 > 浏览”中添加。';

  @override
  String get onboarding_replay => '显示欢迎界面';

  @override
  String get onboarding_replay_subtitle => '重新打开首次运行的引导设置界面。';

  @override
  String get missing_source_check_title => '检查缺失图源';

  @override
  String get missing_source_check_subtitle => '查找未安装对应扩展的书库条目。';

  @override
  String get missing_source_check_none_found => '书库中所有条目的图源均已安装。';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '缺少 $count 个图源',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return '未安装任何 $itemType 来源。';
  }

  @override
  String get global_search_no_sources_hint => '请在“浏览”中添加仓库并安装相应的扩展插件。';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个来源',
    );
    return '您有 $_temp0，但仅会搜索已固定的来源。';
  }

  @override
  String get global_search_only_pinned_hint => '请固定某个来源，或在浏览设置中关闭“仅包含固定的来源”。';

  @override
  String get global_search_all_nsfw => '该分类下的所有来源均被标记为 NSFW 并已被隐藏。';

  @override
  String get global_search_all_nsfw_hint => '请在浏览设置中开启 NSFW 来源后再进行搜索。';

  @override
  String get missing_source_check_result_message =>
      '这些条目关联的图源未安装。点击可进行迁移或安装对应扩展。';

  @override
  String get related_titles => '相关作品';

  @override
  String get related_none => '未找到该作品的相关作品。';

  @override
  String get relation_adaptation => '改编';

  @override
  String get relation_sequel => '续作';

  @override
  String get relation_prequel => '前传';

  @override
  String get relation_parent => '原作/主线';

  @override
  String get relation_side_story => '外传';

  @override
  String get relation_spin_off => '衍生作';

  @override
  String get relation_alternative => '平行/替代版本';

  @override
  String get auto_library_update => '书架自动更新';

  @override
  String get auto_library_update_subtitle => '在应用启动时检查书架中所有作品的最新章节。';

  @override
  String get auto_library_update_never => '从不';

  @override
  String get auto_library_update_12_hours => '每 12 小时';

  @override
  String get auto_library_update_daily => '每天';

  @override
  String get auto_library_update_2_days => '每 2 天';

  @override
  String get auto_library_update_weekly => '每周';

  @override
  String get auto_library_update_wifi_only => '仅限 Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle => '使用移动数据时跳过计划更新。';

  @override
  String get padding => '内边距';

  @override
  String get page_mode => '翻页模式';

  @override
  String get single_page => '单页';

  @override
  String get double_page => '双页';

  @override
  String get speed => '速度';

  @override
  String get theme_dark => '暗色';

  @override
  String get theme_light => '浅色';

  @override
  String get theme_black => '纯黑';

  @override
  String get theme_sepia => '复古';

  @override
  String get decrease => '减少';

  @override
  String get increase => '增加';

  @override
  String get chapter_swipe_actions => '章节滑动操作';

  @override
  String get chapter_swipe_start => '向右滑动';

  @override
  String get chapter_swipe_end => '向左滑动';

  @override
  String get chapter_swipe_toggle_bookmark => '切换书签';

  @override
  String get chapter_swipe_toggle_read => '切换已读状态';

  @override
  String get chapter_swipe_download => '下载';

  @override
  String get chapter_swipe_disabled => '已禁用';

  @override
  String get update_errors => '更新错误';

  @override
  String get no_update_errors => '没有更新错误';

  @override
  String get clear_all => '全部清除';

  @override
  String get dismiss => '忽略';

  @override
  String get previous_episode => '上一集';

  @override
  String get clear_logs => '清空日志';

  @override
  String get bold => '粗体';

  @override
  String get italic => '斜体';

  @override
  String get color_yellow => '黄色';

  @override
  String get color_cyan => '青色';

  @override
  String get color_green => '绿色';

  @override
  String get color_orange => '橙色';

  @override
  String get continue_watching => '继续观看';

  @override
  String get search_your_anime => '搜索你的动画';

  @override
  String get category => '分类';

  @override
  String get hidden_categories => '隐藏分类';

  @override
  String get new_category => '新建分类';

  @override
  String get local => '本地';

  @override
  String get tv_home_rows => '内容行';

  @override
  String get genre_rows => '题材行';

  @override
  String get share_backup_file => '分享 NodeLane Comics 备份文件';

  @override
  String get close => '关闭';

  @override
  String get migrate_source => '迁移来源';

  @override
  String get cloudflare_bypass_proxy => 'Cloudflare 验证代理';

  @override
  String get custom_doh_url => '自定义 DoH 地址';

  @override
  String get custom_doh_url_helper => '须为 HTTPS 的 DoH（JSON）服务地址';

  @override
  String get anime_only_tv_layout => '电视仅动画布局';

  @override
  String get anime_only_beta => '仅限动画（测试版）';

  @override
  String get tv_home_beta => '电视首页（测试版）';

  @override
  String get tv_player_beta => '电视播放器（测试版）';

  @override
  String get network_settings => '网络';

  @override
  String get reader_page_layout => '页面布局';

  @override
  String get reader_continuous_options => '连续阅读';

  @override
  String get reader_default_mode_hint => '默认阅读模式用于尚未在阅读时单独设置模式的漫画。';

  @override
  String get extension_service => '扩展服务';

  @override
  String get extension_service_description => '管理扩展运行服务与代理地址。';

  @override
  String get proxy_address => '代理地址';

  @override
  String get checking_runtime_status => '正在检查状态…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds 秒 + 随机延迟';
  }

  @override
  String download_queue_count(int count) {
    return '$count 个章节';
  }

  @override
  String get download_queue_empty_hint => '从作品的章节列表添加下载';

  @override
  String get download_queue_order_hint => '拖动把手调整顺序';

  @override
  String get download_queue_empty => '暂无下载任务';

  @override
  String get download_queue_actions => '下载操作';

  @override
  String get download_queue_cancel_chapter => '取消本章下载';

  @override
  String get download_queue_cancel_series => '取消本作品全部下载';

  @override
  String get download_queue_start => '开始下载';

  @override
  String get download_queue_retry => '重试下载';

  @override
  String get download_queue_active => '下载中';

  @override
  String get download_queue_waiting => '等待下载';

  @override
  String get download_queue_failed => '下载失败';

  @override
  String get cf_proxy_helper => 'FlareSolverr / Byparr 服务地址，留空关闭。';

  @override
  String get mobile_navigation_description =>
      '拖动调整顺序。漫画、动画和小说共用书架入口，首个显示项目为启动页。浏览与更多始终显示，多余入口收进更多。';

  @override
  String get text_align_justify => '两端对齐';

  @override
  String get novel_session_modes_hint => '阅读模式与单／双页在打开小说后设置。';

  @override
  String get tts_languages_failed => '无法读取语音引擎的语言列表。';

  @override
  String get tts_languages_empty => '语音引擎没有返回可选语言，已保留当前选择。';

  @override
  String get tts_language_unavailable => '设备当前的语言列表中没有这个已保存的语言。';

  @override
  String get tts_apply_failed => '未能向语音引擎应用此设置，可以重试。';

  @override
  String get player_controls => '控制';

  @override
  String get audio_channel_auto => '自动';

  @override
  String get audio_channel_auto_safe => '自动（安全模式）';

  @override
  String get audio_channel_mono => '单声道';

  @override
  String get audio_channel_stereo => '立体声';

  @override
  String get audio_channel_reverse_stereo => '交换左右声道';

  @override
  String get mpv_bundled_config_hint => '恢复应用内置的配置、脚本和着色器。同名文件会被覆盖。';

  @override
  String get mpv_restore_bundled => '恢复内置配置';

  @override
  String get mpv_restore_confirm => '恢复内置 MPV 配置？现有配置、脚本和着色器的同名文件会被覆盖，其他文件保留。';

  @override
  String get player_operation_incomplete => '未能完成操作，请检查文件访问权限后重试。';

  @override
  String get custom_buttons_empty_hint => '添加播放器按钮，设置名称和点击时执行的操作。';

  @override
  String get custom_button_primary => '默认按钮';

  @override
  String get show_password => '显示密码';

  @override
  String get hide_password => '隐藏密码';

  @override
  String get tracking_accounts_empty => '先在追踪设置中登录服务，再管理其中的条目。';

  @override
  String get tracking_entries_empty => '此媒体类型暂无追踪条目，可从作品详情页添加追踪。';

  @override
  String get change_tracking_match => '更换匹配作品';

  @override
  String get remove_tracking => '移除追踪';

  @override
  String remove_tracking_confirm(String title) {
    return '移除“$title”的追踪关联？追踪服务中的条目会保留。';
  }

  @override
  String get tracking_refresh_required => '未能确认追踪状态，请刷新后再进行修改。';

  @override
  String get tracking_entry_unlinked => '此记录尚未关联本地作品，无法在这里编辑。';

  @override
  String get backup_selection_shared => '选择会立即保存，也用于自动备份。';

  @override
  String get library_snapshot_history => '恢复历史快照';

  @override
  String get library_snapshot_empty => '暂无可恢复的安全快照。';

  @override
  String get library_snapshot_restore_message =>
      '当前数据将替换为此快照，快照后的更改会丢失。已删除的下载文件无法恢复。成功后会清除现有安全快照。';

  @override
  String get library_maintenance_working => '正在整理书库…';

  @override
  String get library_safety_snapshot_note => '操作前会保存安全快照。快照不包含下载文件。';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return '此图源包含 $mangaCount 个条目、$chapterCount 个章节、$historyCount 条历史与 $updateCount 条更新。下方选项决定保留哪些内容。';
  }

  @override
  String get library_delete_pick_message => '选择图源，查看其内容和删除选项。';

  @override
  String get mobile_categories_hint => '拖动调整顺序。打开分类可重命名，或设置显示与更新。';

  @override
  String get mobile_category_visible => '在书架中显示';

  @override
  String get mobile_category_hidden => '已从书架隐藏';

  @override
  String get mobile_category_updates => '参与书库更新';

  @override
  String get statistics_watched => '已观看';

  @override
  String get calendar_month => '月';

  @override
  String get calendar_two_weeks => '两周';

  @override
  String get calendar_week => '周';

  @override
  String get calendar_show_all_dates => '查看全部日期';

  @override
  String get update_check_no_result => '暂未找到可安装更新，可稍后再试。';

  @override
  String get release_notes => '更新说明';

  @override
  String get no_release_notes => '未提供更新说明。';

  @override
  String get downloading_update => '正在下载更新…';

  @override
  String get preparing_installation => '正在准备安装…';

  @override
  String get onboarding_mobile_libraries_body => '选择阅读内容，之后也可调整。';

  @override
  String get onboarding_content_title => '开始阅读';

  @override
  String get onboarding_mobile_sources_body => '选择一种方式，也可以稍后添加。';

  @override
  String onboarding_step_count(int step, int total) {
    return '第 $step 步，共 $total 步';
  }

  @override
  String global_search_results_for(String query) {
    return '“$query”的搜索结果';
  }

  @override
  String global_search_scope(String type, int count) {
    return '$type · $count 个来源';
  }

  @override
  String get migration_search_prompt => '搜索目标作品。';

  @override
  String get migration_original_item => '当前作品';

  @override
  String get migration_target_item => '目标作品';

  @override
  String get migration_partial_failure => '操作未完成，可能已保存部分更改。请返回书架核对当前条目后再继续。';

  @override
  String get migration_no_categories => '暂无分类，可直接添加到未分类书架。';

  @override
  String get mass_migration_select_source => '选择当前来源';

  @override
  String get mass_migration_select_all => '全选';

  @override
  String get mass_migration_deselect_all => '取消全选';

  @override
  String get mass_migration_needs_review => '部分作品需要核对';

  @override
  String get bookshelf_actions => '书架操作';

  @override
  String get bookshelf_ignore_filters => '搜索时忽略筛选';

  @override
  String get bookshelf_ignore_filters_hint => '搜索当前分类中的全部作品，包括被筛选条件隐藏的作品。';

  @override
  String get bookshelf_stop_update => '停止书架更新';

  @override
  String bookshelf_selected_count(int count) {
    return '已选择 $count 项';
  }

  @override
  String get bookshelf_remove_library => '从书架移除';

  @override
  String get bookshelf_remove_library_hint => '移除收藏记录。本地导入作品也会移除书架及阅读记录。';

  @override
  String get bookshelf_remove_downloads => '删除下载文件';

  @override
  String get bookshelf_remove_downloads_hint => '删除下载文件，保留作品信息。';

  @override
  String get bookshelf_remove_local_files_hint =>
      '也会删除所选本地导入文件，并移除对应书架记录。这些文件无法在此恢复。';

  @override
  String get bookshelf_remove_incomplete =>
      '操作未完成，部分作品或文件可能已处理。请关闭后先核对书架和下载记录，再继续操作。';

  @override
  String get bookshelf_processing => '正在处理…';

  @override
  String get bookshelf_mark_read => '标为已读';

  @override
  String get bookshelf_mark_unread => '标为未读';

  @override
  String get bookshelf_select_all => '全选';

  @override
  String get bookshelf_invert_selection => '反选';

  @override
  String get bookshelf_settings => '书架设置';

  @override
  String get bookshelf_settings_live => '筛选、排序和显示更改即时生效。';

  @override
  String get bookshelf_filter_any => '不限';

  @override
  String get bookshelf_filter_include => '包含';

  @override
  String get bookshelf_filter_exclude => '排除';

  @override
  String get bookshelf_all_sources => '全部来源';

  @override
  String bookshelf_sources_selected(int count) {
    return '已选 $count 个来源';
  }

  @override
  String get bookshelf_sort_ascending => '升序';

  @override
  String get bookshelf_sort_descending => '降序';

  @override
  String get bookshelf_layout => '书架布局';

  @override
  String get bookshelf_sources_hint => '不选表示全部来源；点按“筛选”后生效。';

  @override
  String get bookshelf_choose_files => '选择文件';

  @override
  String get bookshelf_import_wait => '请在文件选择器中选择文件，并等待导入完成。';

  @override
  String get bookshelf_import_incomplete =>
      '导入未完成，部分文件可能已加入书架。请关闭后先核对，再决定是否重新导入。';

  @override
  String get bookshelf_categories_replace => '所选分类将统一替换这些作品原来的分类。';

  @override
  String get bookshelf_categories_hint => '可多选分类；留空则不分配分类。';

  @override
  String get bookshelf_categories_hidden => '该作品已有的隐藏分类会保留。';

  @override
  String get bookshelf_categories_incomplete => '分类未保存完成。请关闭后先核对书架，再继续操作。';

  @override
  String get bookshelf_categories_none_visible => '没有可选分类，可前往管理分类查看。';

  @override
  String get bookshelf_manage_categories => '管理分类';

  @override
  String get manga_actions => '漫画操作';

  @override
  String get manga_download_scope => '下载章节';

  @override
  String get manga_download_scope_hint => '按当前目录筛选选择章节，已下载的章节会跳过。';

  @override
  String get manga_download_scope_empty => '当前筛选下没有章节。请关闭并调整目录筛选。';

  @override
  String get manga_action_incomplete => '操作未完成。请先核对当前状态，再决定是否重新操作。';

  @override
  String get chapter_settings => '章节设置';

  @override
  String get chapter_settings_live => '筛选与排序即时生效，仅用于当前漫画。';

  @override
  String get chapter_scanlators_all => '全部显示';

  @override
  String get chapter_scanlators_hint => '勾选要隐藏的翻译组，点按“筛选”后生效。';

  @override
  String chapter_scanlators_hidden(int count) {
    return '已隐藏 $count 个翻译组';
  }

  @override
  String chapter_selected_count(int count) {
    return '已选 $count 章';
  }

  @override
  String get chapter_add_bookmark => '添加书签';

  @override
  String get chapter_remove_bookmark => '取消书签';

  @override
  String get chapter_read_following => '下方已读';

  @override
  String get chapter_delete_records => '删除章节记录';

  @override
  String get chapter_delete_local_hint => '移除所选章节与阅读进度，保留原始压缩包，并清理已有下载副本。';

  @override
  String get chapter_delete_last_hint => '所选章节是这部漫画的全部目录，删除后也会从书架移除这部漫画。';

  @override
  String get chapter_action_incomplete => '操作未完成，部分更改可能已保存。请关闭后先核对章节与下载，再继续操作。';

  @override
  String get reader_display_scope => '阅读模式和手动单双页应用于当前漫画；选择后返回阅读。';

  @override
  String get reader_display_single_only => '横向连续阅读仅使用单页。';

  @override
  String get reader_display_manual_pages => '切换单双页会关闭所有漫画的自动双页。';

  @override
  String get reader_display_crop_scope => '应用于所有漫画。';

  @override
  String get reader_chapter_locate => '定位当前章节';

  @override
  String get reader_chapter_search => '搜索章节或翻译组';

  @override
  String get reader_chapter_scope => '沿用漫画详情的筛选和排序，书签即时保存。';

  @override
  String get reader_chapter_current_hidden => '正在阅读的章节不在当前筛选后的目录中。';

  @override
  String get reader_chapter_current => '正在阅读';

  @override
  String get reader_chapter_read => '已读';

  @override
  String get reader_chapter_bookmark_failed => '未能确认书签保存结果，请关闭目录后核对。';

  @override
  String get reader_image_actions => '图片操作';

  @override
  String get reader_image_original => '使用原始整页图片，不含翻译、裁剪或阅读滤镜。';

  @override
  String get reader_image_save_ios => '保存到当前应用存储位置的 Pictures 文件夹。';

  @override
  String get reader_image_save_android =>
      '保存到设备的 Pictures/nodelane-comics 文件夹。';

  @override
  String get reader_image_share => '打开系统分享面板。';

  @override
  String get reader_image_cover => '确认后修改这本漫画的封面。';

  @override
  String get reader_image_cover_limit => '封面图片需小于 5 MB，仍可保存或分享。';

  @override
  String get reader_image_action_failed => '未能确认操作结果，请关闭菜单后核对，再决定是否重试。';

  @override
  String get reader_settings_book_scope => '以下设置仅用于当前漫画。';

  @override
  String get reader_settings_global_scope => '以下设置用于所有漫画，即时保存。';

  @override
  String get reader_filters => '图像滤镜';

  @override
  String get reader_filter_scope => '用于所有漫画，只改变阅读画面，不修改原始图片。';

  @override
  String get reader_auto_scroll_pause => '打开设置期间暂停滚动。';

  @override
  String get manga_synopsis => '简介';

  @override
  String manga_author(String author) {
    return '作者：$author';
  }

  @override
  String get manga_continue_reading => '继续阅读';

  @override
  String get reader_settings_title => '阅读设置';

  @override
  String get reader_picker_book_scope => '仅用于当前漫画';

  @override
  String get reader_picker_global_scope => '应用于所有漫画';

  @override
  String get reader_picker_apply_hint => '点选即保存并返回上一层。';

  @override
  String get reader_scale_fit_screen_hint => '整页适配屏幕';

  @override
  String get reader_scale_stretch_hint => '铺满阅读区域';

  @override
  String get reader_scale_fit_width_hint => '以页面宽度适配';

  @override
  String get reader_scale_fit_height_hint => '以页面高度适配';

  @override
  String get source_filter_active => '已应用';

  @override
  String get source_filter_apply => '应用筛选';

  @override
  String get source_filter_scope => '筛选仅用于当前网站。';

  @override
  String get source_filter_apply_hint => '应用筛选后生效。';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': '题材',
      'author': '作者',
      'artist': '画师',
      'title': '标题',
      'year': '年份',
      'tags': '标签',
      'format': '形式',
      'publisher': '出版社',
      'relevance': '相关度',
      'rating': '评分',
      'views': '浏览量',
      'random': '随机',
      'all': '全部',
      'none': '无',
      'action': '动作',
      'adventure': '冒险',
      'comedy': '喜剧',
      'drama': '剧情',
      'fantasy': '奇幻',
      'romance': '爱情',
      'science_fiction': '科幻',
      'slice_of_life': '日常',
      'mystery': '悬疑',
      'horror': '恐怖',
      'psychological': '心理',
      'historical': '历史',
      'sports': '运动',
      'supernatural': '超自然',
      'school_life': '校园',
      'tragedy': '悲剧',
      'shounen': '少年',
      'shoujo': '少女',
      'seinen': '青年',
      'josei': '女性',
      'isekai': '异世界',
      'martial_arts': '武侠',
      'mecha': '机甲',
      'music': '音乐',
      'doujinshi': '同人',
      'trending': '热门趋势',
      'new': '新上架',
      'adult_content': '成人内容',
      'only': '仅显示',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => '更多显示选项';

  @override
  String get bookshelf_more_display_hint => '徽章、来源与分类';

  @override
  String get bookshelf_download_count => '下载数量';

  @override
  String get bookshelf_source_global_hint => '来源显示沿用全局设置。';

  @override
  String get bookshelf_select_entries => '选择作品';

  @override
  String get bookshelf_search_options => '搜索选项';

  @override
  String get bookshelf_empty_hint => '从来源收藏作品，或导入本地文件。';

  @override
  String get bookshelf_no_match_hint => '试试其他关键词，或调整当前筛选。';

  @override
  String get bookshelf_clear_query => '清空关键词';

  @override
  String get bookshelf_view_selection => '查看所选作品';

  @override
  String get bookshelf_import_formats => '选择本地文件，将作品加入书架。';

  @override
  String get bookshelf_import_canceled_hint => '取消文件选择后，可继续重新选择。';

  @override
  String get bookshelf_browse_sources => '浏览来源';

  @override
  String get bookshelf_empty_title => '书架还是空的';

  @override
  String get bookshelf_no_match_title => '没有匹配的作品';

  @override
  String get bookshelf_mark_watched => '标为已看';

  @override
  String get bookshelf_mark_unwatched => '标为未看';

  @override
  String get nodelane_account => 'NodeLane 账号';

  @override
  String get nodelane_sign_in => '登录 NodeLane';

  @override
  String get nodelane_account_intro => '查看账号、订阅和翻译额度';

  @override
  String get nodelane_login_action => '前往登录';

  @override
  String get nodelane_login_browser => '通过系统浏览器登录后返回应用';

  @override
  String get nodelane_account_id => '账号 ID';

  @override
  String get nodelane_account_init_error => '暂时无法读取账号，请重新启动应用后再试。';

  @override
  String get nodelane_account_refresh_error => '暂时无法更新账号信息';

  @override
  String get nodelane_account_auth_error => '登录已过期，请重新登录';

  @override
  String get nodelane_account_unknown => '暂未读取到订阅信息';

  @override
  String get nodelane_account_current => '当前订阅';

  @override
  String get nodelane_account_free => '免费账户';

  @override
  String get nodelane_account_no_subscription => '暂无有效订阅';

  @override
  String get nodelane_account_active => '生效中';

  @override
  String get nodelane_account_expired => '已到期';

  @override
  String get nodelane_account_expiry => '有效期至';

  @override
  String get nodelane_account_renewal => '续费方式';

  @override
  String get nodelane_renewal_auto => '自动续费';

  @override
  String get nodelane_renewal_manual => '手动续费';

  @override
  String get nodelane_renewal_stopped => '已停止自动续费';

  @override
  String get nodelane_renewal_gift => '赠送会员';

  @override
  String get nodelane_renewal_attention => '续费状态需要核对，请到官网查看';

  @override
  String get nodelane_next_billing => '下次扣款';

  @override
  String get nodelane_billing_unavailable => '续费信息暂时无法读取';

  @override
  String get nodelane_manage_account => '在官网管理';

  @override
  String get nodelane_view_plans => '查看订阅方案';

  @override
  String get nodelane_translation_quota => '翻译额度';

  @override
  String get nodelane_quota_free => '免费额度';

  @override
  String get nodelane_quota_subscription => '订阅额度';

  @override
  String get nodelane_quota_purchase => '购买额度';

  @override
  String get nodelane_quota_details => '查看额度明细';

  @override
  String get nodelane_quota_expanded => '额度明细';

  @override
  String get nodelane_quota_unlimited => '不限量';

  @override
  String get nodelane_quota_not_subscribed => '未开通';

  @override
  String get nodelane_quota_unknown => '暂不可用';

  @override
  String get nodelane_quota_used => '已使用';

  @override
  String get nodelane_quota_reserved => '处理中';

  @override
  String get nodelane_quota_reset => '下次重置';

  @override
  String get nodelane_quota_expiry => '最近到期';

  @override
  String get nodelane_quota_no_expiry => '无到期时间';

  @override
  String get nodelane_quota_reservation_note => '处理中页数已从可用额度扣除';

  @override
  String nodelane_quota_available(int count) {
    return '剩余 $count 页';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count 页';
  }

  @override
  String get nodelane_sign_out => '退出登录';

  @override
  String get nodelane_sign_out_confirm => '退出后暂停本机官方翻译，书架与阅读记录保留。';

  @override
  String get settings_search_hint => '搜索设置';

  @override
  String get settings_frequent => '常用';

  @override
  String get settings_reading_translation => '阅读与翻译';

  @override
  String get settings_app_preferences => '应用偏好';

  @override
  String get settings_data_management => '数据与管理';

  @override
  String get settings_more_tools => '更多工具';

  @override
  String get settings_more_tools_hint => '分类、统计、日历';

  @override
  String get settings_appearance_interface => '外观与界面';

  @override
  String get settings_security_privacy => '安全与隐私';

  @override
  String get settings_source_preferences => '来源设置';

  @override
  String get settings_about_help => '关于与帮助';

  @override
  String get settings_storage_backup => '存储与备份';

  @override
  String settings_pending_downloads(int count) {
    return '$count 项待下载';
  }

  @override
  String get settings_translation_language => '翻译目标语言';

  @override
  String get settings_translation_scope => '用于阅读器和网页翻译';

  @override
  String get settings_immediate_choice => '选择后立即生效';

  @override
  String get settings_translation_init_error => '暂时无法读取翻译设置，请重新启动应用后再试。';

  @override
  String get settings_local_cache => '本机缓存';

  @override
  String get settings_chapter_cache => '章节与剧集缓存';

  @override
  String get settings_cover_cache => '封面缓存';

  @override
  String get settings_translation_cache => '译图缓存';

  @override
  String get settings_translation_cache_hint => '保留翻译记录，需要时重新读取译图';

  @override
  String get settings_cache_clear => '清理';

  @override
  String get settings_translation_cache_done => '译图缓存已清理，翻译记录已保留';

  @override
  String settings_cache_confirmation(String name) {
    return '清理 $name？需要时会重新读取，不会移除书架作品。';
  }

  @override
  String get settings_advanced_options => '高级选项';

  @override
  String get settings_manga_reader => '漫画阅读';

  @override
  String get settings_novel_reader => '小说阅读';

  @override
  String get settings_downloads => '下载设置';

  @override
  String get onboarding_welcome => '欢迎使用';

  @override
  String get onboarding_reading_content => '阅读内容';

  @override
  String get onboarding_choose_one => '至少选择一种';

  @override
  String get onboarding_restore_hint => '从已有备份恢复书库';

  @override
  String get onboarding_browse_hint => '从支持的网站找到作品';

  @override
  String get onboarding_import_folder => '导入本地文件夹';

  @override
  String get onboarding_import_folder_hint => '读取设备中的漫画、小说和动画';

  @override
  String get onboarding_third_party => '添加第三方来源库';

  @override
  String get onboarding_third_party_hint => '已有来源库地址时使用';

  @override
  String get onboarding_repository_hint => '输入来源库提供的地址。';

  @override
  String get onboarding_repository_address => '地址';

  @override
  String get onboarding_repository_address_hint => '输入来源库地址';

  @override
  String get onboarding_add_repository => '添加来源库';

  @override
  String get onboarding_start => '开始使用';

  @override
  String get onboarding_open_library => '进入书架';

  @override
  String get onboarding_view_imports => '查看导入内容';

  @override
  String get onboarding_view_folders => '查看文件夹';

  @override
  String get notice_backup_created => '备份已创建';

  @override
  String get notice_backup_ready => '可将备份文件保存到其他位置。';

  @override
  String get notice_backup_restored => '备份已恢复';

  @override
  String get notice_backup_unsupported => '不支持此备份格式。';

  @override
  String get notice_verification_required => '网站需要验证';

  @override
  String get notice_verification_hint => '完成验证后可继续访问。';

  @override
  String get notice_verify => '前往验证';

  @override
  String get notice_action_incomplete => '操作未完成，请先核对结果再决定是否重试。';

  @override
  String get notice_library_updating => '正在更新书库';

  @override
  String notice_library_progress(Object current, Object total) {
    return '已检查 $current / $total 部作品';
  }

  @override
  String get notice_library_failed => '部分作品更新失败';

  @override
  String get notice_import_completed => '导入完成';

  @override
  String get notice_operation_incomplete => '操作未完成';

  @override
  String get subtitle_service => '在线字幕服务';

  @override
  String get subtitle_service_mode => '字幕来源';

  @override
  String get subtitle_service_disabled => '关闭并清除已存凭据';

  @override
  String get subtitle_personal_key => '我的 Wyzie Key';

  @override
  String get subtitle_custom_service => '我的字幕服务';

  @override
  String get subtitle_key => 'Wyzie API Key';

  @override
  String get subtitle_key_hint => '填写你自己的 Wyzie Key，仅保存在此设备上，不随应用备份导出。';

  @override
  String get subtitle_get_key => '获取个人 Key';

  @override
  String get subtitle_service_address => '字幕搜索地址';

  @override
  String get subtitle_service_token => '服务访问令牌（选填）';

  @override
  String get subtitle_custom_hint =>
      '填写兼容 Wyzie 的完整 HTTPS 搜索地址，包含路径（如 /search）。服务需要鉴权时，再填写它的访问令牌。';

  @override
  String get subtitle_service_off_hint => '在线字幕搜索已关闭，仍可使用内嵌字幕、片源字幕和本地字幕。';

  @override
  String get subtitle_setup_required => '请先配置字幕服务，再搜索字幕。';

  @override
  String get subtitle_invalid_key => '请填写不含空白字符的 Key。';

  @override
  String get subtitle_invalid_address => '请填写完整 HTTPS 地址，不包含查询参数、片段或内嵌凭据。';

  @override
  String get subtitle_invalid_token => '访问令牌不能包含空白字符。';

  @override
  String get subtitle_storage_failed => '字幕配置读取或保存失败，请重试。';

  @override
  String get subtitle_auth_failed => '字幕服务拒绝访问，请检查 Key 或服务令牌。';

  @override
  String get subtitle_quota_exhausted => '字幕服务额度已用完，请到对应服务查看个人账户。';

  @override
  String get subtitle_network_failed => '暂时无法连接字幕服务，请重试。';

  @override
  String get subtitle_response_invalid => '字幕服务返回了不支持的响应或文件。';

  @override
  String get detail_loading_chapters => '加载章节…';

  @override
  String get reader_opening_chapter => '正在打开章节';

  @override
  String get reader_open_chapter => '打开章节';

  @override
  String get reader_loading_pages => '正在获取本话图片…';

  @override
  String get reader_loading_pages_hint => '加载完成后自动进入阅读';

  @override
  String get reader_loading_failed => '暂时无法加载';

  @override
  String get reader_loading_retry_hint => '请检查网络后重试';

  @override
  String get reader_no_pages => '本话暂无可阅读图片';

  @override
  String get reader_loading_previous => '正在加载上一章…';

  @override
  String get reader_previous_failed => '上一章暂时无法加载';

  @override
  String get reader_reached_start => '已到第一章';

  @override
  String get reader_loading_next => '正在加载下一章…';

  @override
  String get reader_next_failed => '下一章暂时无法加载';

  @override
  String get reader_image_loading => '正在加载图片…';

  @override
  String get reader_image_failure_hint => '其他页面仍可继续阅读';

  @override
  String get comic_paged => '翻页';

  @override
  String get comic_scroll => '连续下滑';

  @override
  String get comic_book_scope => '仅本书生效 · 修改即保存';

  @override
  String get comic_defaults_title => '默认与操作习惯';

  @override
  String get comic_defaults_hint => '默认值用于尚未单独设置的书籍选项。';

  @override
  String get comic_habits_hint => '以下习惯对所有漫画生效。';

  @override
  String get comic_turn => '滑向下一页';

  @override
  String get comic_left => '向左';

  @override
  String get comic_right => '向右';

  @override
  String get comic_up => '向上';

  @override
  String get comic_fit => '画面适配';

  @override
  String get comic_fit_contain => '完整显示';

  @override
  String get comic_fit_width => '适合宽度';

  @override
  String get comic_fit_height => '适合高度';

  @override
  String get comic_layout => '页面排布';

  @override
  String get comic_auto => '自动';

  @override
  String get comic_layout_hint => '自动根据可用宽度显示单页或双页。';

  @override
  String get comic_width => '内容宽度';

  @override
  String get comic_full => '铺满';

  @override
  String get comic_comfortable => '舒适';

  @override
  String get comic_narrow => '收窄';

  @override
  String get comic_gap => '页间留白';

  @override
  String get comic_no_gap => '无缝';

  @override
  String get comic_small_gap => '少量';

  @override
  String get comic_image_title => '画面微调';

  @override
  String get comic_image_hint => '裁边与色调仅作用于本书。';

  @override
  String get comic_wide => '横幅页处理';

  @override
  String get comic_intact => '完整保留';

  @override
  String get comic_split => '拆为两页';

  @override
  String get comic_rotate => '旋转适配';

  @override
  String get comic_wide_hint => '拆页顺序跟随翻页方向，仅用于单页翻阅。';

  @override
  String get comic_cover => '每章首页单独显示';

  @override
  String get comic_effects_reset => '重置画面效果';

  @override
  String get comic_book_reset => '恢复本书默认';

  @override
  String get comic_book_reset_hint => '清除本书自定义阅读设置，翻译设置保持原样。';

  @override
  String get comic_canvas => '阅读背景';

  @override
  String get comic_system => '跟随系统';

  @override
  String get comic_black => '纯黑';

  @override
  String get comic_gray => '深灰';

  @override
  String get comic_paper => '纸白';

  @override
  String get comic_tap => '轻点翻页';

  @override
  String get comic_tap_hint => '轻点两侧翻页，中间显示工具栏；下滑阅读时轻点上、下方移动。';

  @override
  String get comic_scroll_start => '开始自动下滑';

  @override
  String get comic_scroll_pause => '暂停自动下滑';

  @override
  String get comic_scroll_speed => '下滑速度';

  @override
  String get comic_scroll_hint => '关闭面板后开始；离开应用会暂停。';

  @override
  String get comic_save_failed => '保存失败，请重试。';

  @override
  String get comic_reading => '阅读';

  @override
  String get comic_chapter_habits_hint => '章节列表操作习惯对所有书籍生效。';

  @override
  String get browser_title => '浏览器';

  @override
  String get translation_image_display => '图片显示';

  @override
  String get translation_display_hint => '译图优先显示已有结果，暂无译图时保留原图。';

  @override
  String get translation_sign_in_required => '登录后开启翻译';

  @override
  String get translation_sign_in_hint => '登录后切换译图，即可自动翻译';

  @override
  String get translation_automatic => '自动翻译';

  @override
  String get translation_original_hint => '当前显示原图，切到译图后自动翻译';

  @override
  String get translation_window_hint => '仅在显示译图时处理当前及后续图片';

  @override
  String get translation_channel => '翻译渠道';

  @override
  String get translation_no_images => '当前页面暂未发现可翻译图片';

  @override
  String get translation_waiting_image => '等待当前图片';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues 张需要处理',
      zero: '',
    );
    return '已完成 $complete / $total 张$_temp0';
  }

  @override
  String get translation_image_actions_hint => '长按图片打开更多操作，可重新翻译单张图片。';

  @override
  String get translation_title => '漫画翻译';

  @override
  String get translation_system_sign_in => '通过系统浏览器登录';

  @override
  String get translation_target_language => '目标语言';

  @override
  String get translation_clear_cache => '清理译图缓存';

  @override
  String get translation_cache_hint => '保留翻译记录，需要时重新读取结果';

  @override
  String get translation_saved_read_failed => '已有译图读取失败';

  @override
  String get translation_read_failed => '译图读取失败';

  @override
  String get operation_retry => '操作未完成，请重试';

  @override
  String get translation_original => '原图';

  @override
  String get translation_translated => '译图';

  @override
  String get translation_regenerate_image => '重新翻译此图';

  @override
  String get translation_read_image => '重新读取译图';

  @override
  String get translation_image_actions => '图片更多操作';

  @override
  String get translation_processing => '正在处理';

  @override
  String get translation_reading => '正在读取译图';

  @override
  String get translation_waiting => '等待翻译';

  @override
  String get translation_preparing => '准备翻译';

  @override
  String get translation_uploading => '上传原图';

  @override
  String get translation_running => '正在翻译';

  @override
  String get translation_uncertain => '状态待确认';

  @override
  String get translation_failed => '翻译失败';

  @override
  String get translation_verify => '核实';

  @override
  String get translation_reread => '重新读取';

  @override
  String get browser_back => '后退';

  @override
  String get browser_translation => '网页翻译';

  @override
  String get browser_new_tab_action => '新建标签页';

  @override
  String get browser_current_tab => '当前';

  @override
  String get browser_close_tab => '关闭标签页';

  @override
  String get browser_new_tab => '新标签页';

  @override
  String get browser_page => '网页';

  @override
  String get browser_unopened => '尚未打开网页';

  @override
  String get browser_invalid_address => '请输入有效的网址';

  @override
  String get browser_clear_address => '清空网址';

  @override
  String get browser_paste_address => '粘贴网址';

  @override
  String get browser_open_address => '打开网址';

  @override
  String browser_tab_count(int count) {
    return '标签页 · $count';
  }

  @override
  String get browser_load_failed => '网页暂时无法打开';

  @override
  String get browser_load_failed_hint => '检查网络，或确认网址是否正确。';

  @override
  String get browser_edit_address => '编辑网址';

  @override
  String get browser_clear_cookies_confirm => '清除所有网站登录状态？';

  @override
  String get browser_clear_cookies_hint => '所有标签页中的网站可能需要重新登录。';

  @override
  String get browser_clear_cookies_action => '清除登录状态';

  @override
  String get browser_tab_limit => '最多保留 12 个标签页，请先关闭一个。';

  @override
  String get browser_forward => '前进';

  @override
  String get browser_clear_all_cookies => '清除所有网站登录状态';

  @override
  String get browser_clear_failed => '清除失败，请重试。';

  @override
  String get browser_save_failed => '标签状态保存失败，请重试。';

  @override
  String get browser_tabs_full => '已打开 12 个标签页';

  @override
  String get browser_no_tabs => '还没有打开的标签页';

  @override
  String get browser_close_failed => '标签状态保存失败，请再次点击关闭重试。';

  @override
  String get source_pinned_websites => '常用网站';

  @override
  String get manage => '管理';

  @override
  String get translation_settings_hint => '自动翻译、目标语言与渠道';

  @override
  String get translation_show_original => '点击切换为原图';

  @override
  String get translation_show_translated => '点击切换为译图';

  @override
  String get source_display => '显示方式';

  @override
  String get source_cover_title => '封面与标题';

  @override
  String get source_cover_only => '仅封面';

  @override
  String get source_save_search => '保存当前搜索';

  @override
  String get source_saved_searches => '已保存搜索';

  @override
  String get source_website_info => '网站说明';

  @override
  String source_saved_search_title(String title) {
    return '$title · 点击立即搜索';
  }

  @override
  String get action_done => '完成';

  @override
  String source_search_keyword(String query) {
    return '关键词：$query';
  }

  @override
  String get source_no_saved_searches => '还没有保存的搜索';

  @override
  String get source_save_search_hint => '输入关键词搜索后，可从网站操作中保存。';

  @override
  String get source_saved_search_scope => '仅保存当前网站的关键词。';

  @override
  String get source_search_here => '搜索本站作品';

  @override
  String get source_filter_results => '筛选结果';

  @override
  String get source_search_results => '搜索结果';

  @override
  String get source_return_popular => '返回热门';

  @override
  String get source_popular_titles => '热门作品';

  @override
  String get source_no_titles => '没有找到相关作品';

  @override
  String get source_no_titles_hint => '调整关键词或筛选条件，也可返回热门浏览。';

  @override
  String get source_load_more_failed => '加载更多失败，请重试。';

  @override
  String get source_load_pull_retry => '网站暂时无法加载，可下拉重试。';

  @override
  String get source_clear_failed => '清理未完成，请重试。';

  @override
  String get source_uninstall_failed => '卸载未完成，请重试。';

  @override
  String get source_details => '来源详情';

  @override
  String get source_repository_website => '仓库网站';

  @override
  String get source_provided_settings => '来源提供的设置';

  @override
  String get source_advanced_actions => '高级操作';

  @override
  String get source_edit_metadata => '编辑来源信息';

  @override
  String get source_clear_cookies => '清除此网站 Cookie';

  @override
  String get source_clear_cookies_hint => '下次访问可能需要重新登录';

  @override
  String get source_uninstall => '卸载来源';

  @override
  String get source_settings_save_failed => '保存未完成，请重新打开来源设置核对。';

  @override
  String get repository_third_party => '第三方仓库';

  @override
  String get repository_refresh_failed => '目录刷新失败，已保留缓存，可重试。';

  @override
  String get repository_show_sources => '显示此仓库的来源';

  @override
  String get repository_copy_catalog => '复制目录链接';

  @override
  String get repository_remove => '移除仓库';

  @override
  String get repository_remove_hint => '保留已安装的来源，移除尚未安装的目录条目。';

  @override
  String get repository_empty => '还没有添加第三方仓库';

  @override
  String get repository_built_in => '内置官方目录';

  @override
  String get repository_hidden => '已隐藏';

  @override
  String get repository_refreshing => '正在刷新…';

  @override
  String get repository_refresh => '刷新目录';

  @override
  String get repository_manage_hint => '管理第三方来源的获取地址';

  @override
  String get repository_invalid_address => '请输入有效的 http 或 https 网址';

  @override
  String get repository_already_added => '此仓库已添加';

  @override
  String get repository_unrecognized => '未识别到可用目录，请检查链接后重试。';

  @override
  String get repository_read_failed => '目录读取失败，请重试。';

  @override
  String get repository_save_failed => '保存未完成，请核对仓库列表。';

  @override
  String get repository_paste_hint => '粘贴第三方仓库的目录链接';

  @override
  String get repository_address => '仓库地址';

  @override
  String get repository_paste_link => '粘贴链接';

  @override
  String repository_recognized(String type) {
    return '$type · 目录已识别';
  }

  @override
  String get repository_choose_sources_hint => '添加后可选择需要的来源。';

  @override
  String get search_scope => '搜索范围';

  @override
  String get search_scope_hint => '选择本次要搜索的网站';

  @override
  String search_websites_action(int count) {
    return '搜索这 $count 个网站';
  }

  @override
  String get search_find_website => '查找网站';

  @override
  String search_selected_websites(int count) {
    return '已选 $count 个网站';
  }

  @override
  String get action_clear => '清空';

  @override
  String get search_deselect_results => '取消当前结果';

  @override
  String get search_select_results => '选中当前结果';

  @override
  String get search_no_websites_hint => '没有匹配的网站，试试其他名称或语言。';

  @override
  String get search_select_website_hint => '至少选择一个网站后即可搜索。';

  @override
  String get search_start_title => '输入关键词搜索作品';

  @override
  String get search_start_hint => '一次搜索多个网站，只展示找到的作品。';

  @override
  String get search_empty_scope => '当前范围没有可搜索的网站';

  @override
  String get search_empty_scope_hint => '切换到全部网站，或重新选择参与搜索的网站。';

  @override
  String search_result_count(int count) {
    return '$count 个结果';
  }

  @override
  String get search_titles => '搜作品';

  @override
  String get search_actions => '搜索操作';

  @override
  String get search_details => '搜索详情';

  @override
  String get search_title_hint => '搜索作品名称';

  @override
  String get search_searching => '正在搜索';

  @override
  String search_found_results(int count) {
    return '找到 $count 个结果';
  }

  @override
  String get search_no_results => '没有匹配结果';

  @override
  String get search_failed => '搜索失败';

  @override
  String search_found_titles(int count, int websites) {
    return '已找到 $count 个作品 · $websites 个网站';
  }

  @override
  String get search_finding_titles => '正在查找作品';

  @override
  String get search_complete => '搜索完成';

  @override
  String get search_in_progress => '搜索中';

  @override
  String get search_finding_related => '正在寻找相关作品…';

  @override
  String get search_no_results_yet => '暂未取得搜索结果';

  @override
  String get search_no_matching_titles => '未找到相关作品';

  @override
  String get search_results_appear_hint => '找到后会直接显示在这里。';

  @override
  String get search_failed_websites_hint => '有网站未能完成搜索，可在搜索详情中重试。';

  @override
  String get search_change_keywords_hint => '试试更短的关键词，或扩大搜索范围。';

  @override
  String get search_view_details => '查看搜索详情';

  @override
  String get search_adjust_scope => '调整搜索范围';

  @override
  String search_query_websites(String query, int count) {
    return '$query · $count 个网站';
  }

  @override
  String search_completed_count(int completed, int total) {
    return '已完成 $completed / $total';
  }

  @override
  String get search_retry_website_hint => '失败网站可单独重试';

  @override
  String source_selected_count(int count) {
    return '已选择 $count 项';
  }

  @override
  String get search_languages => '搜索语言';

  @override
  String get source_deselect => '取消选择';

  @override
  String get source_select => '选择来源';

  @override
  String get source_multilingual => '多语言';

  @override
  String get source_language_unknown => '语言未标注';

  @override
  String get source_adult_content => '含 18+ 内容';

  @override
  String get source_classification_unknown => '分类未标注';

  @override
  String source_more_classifications(int count) {
    return '查看全部来源资料，另有 $count 个分类';
  }

  @override
  String get source_loading_website => '正在加载网站';

  @override
  String get source_unpin => '取消常用';

  @override
  String get source_pin => '固定到常用';

  @override
  String get source_open => '进入';

  @override
  String get source_metadata_hint => '资料由来源目录提供，分类描述网站覆盖范围。';

  @override
  String get source_region => '地区';

  @override
  String get source_format => '形式';

  @override
  String get source_creation => '创作';

  @override
  String get source_unspecified => '未标注';

  @override
  String get source_pricing => '收费';

  @override
  String get source_region_jp => '日漫';

  @override
  String get source_region_kr => '韩漫';

  @override
  String get source_region_cn => '国漫';

  @override
  String get source_region_hk_tw => '港台漫画';

  @override
  String get source_region_western => '欧美漫画';

  @override
  String get source_region_other => '其他地区';

  @override
  String get source_format_page => '页漫';

  @override
  String get source_format_vertical => '条漫';

  @override
  String get source_format_strip => '短篇条格';

  @override
  String get source_creation_original => '原创';

  @override
  String get source_creation_fan => '同人';

  @override
  String get source_free_watch => '免费观看';

  @override
  String get source_free_read => '免费阅读';

  @override
  String get source_partial_paid => '部分收费';

  @override
  String get source_paid_watch => '付费观看';

  @override
  String get source_paid_read => '付费阅读';

  @override
  String get source_pricing_unknown => '收费未标注';

  @override
  String get source_language_filter => '语言筛选';

  @override
  String get source_language_filter_hint => '仅筛选当前目录，不影响已安装来源';

  @override
  String get source_all_languages => '全部语言';

  @override
  String get action_apply => '应用';

  @override
  String get source_load_retry => '网站暂时无法加载，请重试。';

  @override
  String get source_catalog_refresh_failed => '目录刷新失败，已保留当前内容，可下拉重试。';

  @override
  String source_uninstall_count(int count) {
    return '卸载 $count 个来源？';
  }

  @override
  String get source_uninstall_selected_hint => '将卸载所选的已安装来源并清除其来源设置，保留书架作品和下载。';

  @override
  String source_failed_count(int count) {
    return '$count 个来源操作失败，已保留选择，请重试。';
  }

  @override
  String get source_latest_content => '最新内容';

  @override
  String get source_actions => '来源操作';

  @override
  String get source_bulk_manage => '批量管理';

  @override
  String get source_update_installed => '更新已安装来源';

  @override
  String get source_no_matching_websites => '没有匹配的网站';

  @override
  String get source_no_websites => '暂无可用网站';

  @override
  String get source_search_installed_hint => '在已安装来源中搜索作品';

  @override
  String get source_global_search => '跨来源搜索';

  @override
  String get source_manage_repositories => '管理仓库';

  @override
  String get source_view_third_party => '查看第三方';

  @override
  String get source_catalog_load_failed => '目录加载失败，可下拉重试。';

  @override
  String get source_all_websites => '全部网站';

  @override
  String get source_available => '可安装';

  @override
  String get source_third_party => '第三方';

  @override
  String get source_name_or_title => '网站名或作品名';

  @override
  String get view_all => '查看全部';

  @override
  String get search_searching_ellipsis => '正在搜索…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · 待测试';
  }

  @override
  String get onboarding_untested => '待测试';

  @override
  String get source_custom_scope => '自选';

  @override
  String get source_custom_websites => '自选网站';

  @override
  String get tv_hidden_library_hint => '所有作品都在隐藏分类中。\n在「全部」上长按确认键可取消隐藏。';

  @override
  String get tv_no_matching_anime => '没有匹配的动画';

  @override
  String tv_no_matching_category(String category) {
    return '「$category」中没有匹配的动画';
  }

  @override
  String get tv_filtered_empty_hint => '没有符合当前筛选条件的动画。\n可通过搜索旁的按钮调整筛选。';

  @override
  String get tv_new_episodes => '最新剧集';

  @override
  String get tv_recently_added => '最近添加';

  @override
  String get tv_empty_category_hint => '此分类还没有动画。\n可在作品详情页添加。';

  @override
  String get tv_empty_library => '动画书库为空';

  @override
  String get tv_empty_library_hint => '从浏览页面添加动画，即可在此查看';

  @override
  String get tv_browse_anime => '浏览动画';

  @override
  String tv_new_count(int count) {
    return '$count 集未看';
  }

  @override
  String tv_category_hidden(String category) {
    return '已隐藏「$category」· 在「全部」上长按确认键可取消隐藏';
  }

  @override
  String get tv_no_hidden_categories => '没有隐藏的分类';

  @override
  String get import_torrent_file => '导入 .torrent 文件';

  @override
  String get import_video_formats => '.mp4、.mkv、.avi 等格式';

  @override
  String get cloudflare_proxy_optional => 'FlareSolverr / Byparr 地址（可选）';

  @override
  String get tv_home_layout_hint => '按继续观看、最新剧集和分类分行显示动画主页';

  @override
  String get tv_hide_libraries_hint => '隐藏漫画和小说书库（电视端默认开启）';

  @override
  String get anime_only_hint => '在整个应用中隐藏漫画和小说，关闭后显示所有内容。';

  @override
  String get audio_auto_safe => '自动（安全）';

  @override
  String get tv_player_hint => '开启时使用电视专用播放器；关闭时使用桌面播放器。';

  @override
  String get release_open_failed => '无法打开发布页面';

  @override
  String get tv_replay => '重新播放';

  @override
  String get tv_no_episodes => '暂无剧集';

  @override
  String get tracker_continue_series => '继续观看剧集';

  @override
  String get tracker_watchlist_series => '剧集待看列表';

  @override
  String get tracker_continue_movies => '继续观看电影';

  @override
  String get tracker_watchlist_movies => '电影待看列表';

  @override
  String get tracker_trending_series => '热门趋势剧集';

  @override
  String get tracker_trending_movies => '热门趋势电影';

  @override
  String get tracker_popular_series => '热门剧集';

  @override
  String get tracker_popular_movies => '热门电影';

  @override
  String get tracker_top_series => '剧集总榜';

  @override
  String get tracker_top_movies => '电影总榜';

  @override
  String get tracker_airing_series => '热播剧集';

  @override
  String get tracker_airing_anime => '连载动画';

  @override
  String get tracker_popular_anime => '热门动画';

  @override
  String get tracker_upcoming_anime => '即将播出的动画';

  @override
  String get tracker_popular_manga => '热门漫画';

  @override
  String get tracker_top_manga => '日漫排行榜';

  @override
  String get tracker_top_manhwa => '韩漫排行榜';

  @override
  String get tracker_top_manhua => '国漫排行榜';

  @override
  String get tracker_latest_anime => '最新动画';

  @override
  String get tracker_best_anime => '高分动画';

  @override
  String get tracker_latest_manga => '最新漫画';

  @override
  String get tracker_best_manga => '高分漫画';

  @override
  String get tracker_trending_anime => '热门趋势动画';

  @override
  String get tracker_upcoming_manga => '即将推出的漫画';

  @override
  String get tracker_trending_manga => '热门趋势漫画';

  @override
  String selection_progress(int selected, int total) {
    return '已选择 $selected/$total';
  }

  @override
  String get source_code_editor => '代码编辑器';

  @override
  String get source_code_execute => '执行';

  @override
  String get source_console_logs => '控制台日志';

  @override
  String get source_no_logs => '暂无日志';

  @override
  String get source_updated_successfully => '来源已更新';

  @override
  String get source_obsolete => '已过时';

  @override
  String player_seek_forward_seconds(int seconds) {
    return '向前跳转 $seconds 秒';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return '向后跳转 $seconds 秒';
  }

  @override
  String get player_autoplay_on => '自动播放下一集：开启';

  @override
  String get player_autoplay_off => '自动播放下一集：关闭';

  @override
  String get player_no_other_quality => '没有其他画质';

  @override
  String get player_no_subtitles => '暂无字幕';

  @override
  String get player_no_audio_tracks => '暂无音轨';

  @override
  String get player_seek_forward => '向前跳转';

  @override
  String get player_seek_backward => '向后跳转';

  @override
  String player_seconds(int seconds) {
    return '$seconds 秒';
  }

  @override
  String get subtitle_preview => '字幕样式预览';

  @override
  String get subtitle_style => '样式';

  @override
  String get translation_official_channel => 'NodeLane 官方';

  @override
  String get translation_auth_required => '请先登录翻译账号';

  @override
  String get translation_source_changed => '原图已变化，请重新载入';

  @override
  String get translation_source_missing => '原图暂不可用';

  @override
  String get translation_resource_limit => '当前图片超出本机处理预算，已保留原图';

  @override
  String get translation_storage_full => '翻译存储空间不足，请先清理译图';

  @override
  String get translation_invalid_image => '图片格式或内容无效';

  @override
  String get translation_unsupported_image => '暂不支持此图片的翻译，已保留原图';

  @override
  String get translation_invalid_result => '译图校验失败，请重新读取';

  @override
  String get translation_result_unavailable => '译图暂不可用，请重新读取';

  @override
  String get translation_result_expired => '译图已过期，请重新翻译';

  @override
  String get translation_analysis_too_large => '图片分析内容过多，请缩小图片后再翻译';

  @override
  String get translation_region_limit => '图片文字区域过多，请拆分图片后再翻译';

  @override
  String get translation_text_limit => '图片单段文字过长，请调整图片后再翻译';

  @override
  String get translation_unavailable => '此翻译已不可用';

  @override
  String get translation_outcome_unknown => '结果待核实，未重新提交';

  @override
  String get translation_rate_limited => '请求受限，稍后自动恢复';

  @override
  String get translation_quota_exhausted => '当前翻译额度不足';

  @override
  String get translation_unsupported_language => '服务暂不支持此目标语言';

  @override
  String get translation_upgrade_required => '翻译协议不兼容，请更新应用';

  @override
  String get translation_remote_failed => '本页翻译失败，可手动重试';

  @override
  String get translation_bridge_invalid => '网页已变化，请重新开启翻译';

  @override
  String get translation_connection_failed => '连接失败，请重试';

  @override
  String get translation_paused => '翻译已暂停，可核实进度';

  @override
  String get translation_preparing_ellipsis => '准备翻译…';

  @override
  String get translation_checking_original => '核对原图…';

  @override
  String get translation_submitting => '正在提交…';

  @override
  String get translation_uploading_ellipsis => '上传原图…';

  @override
  String get translation_waiting_ellipsis => '等待翻译…';

  @override
  String get translation_running_ellipsis => '正在翻译…';

  @override
  String get translation_verify_result => '结果待核实';

  @override
  String get translation_partial => '部分内容已翻译';

  @override
  String get translation_ready => '译图已就绪';

  @override
  String get list_separator => '、';

  @override
  String get player_play => '播放';

  @override
  String get player_quality => '画质';

  @override
  String get player_subtitles => '字幕';

  @override
  String get player_audio => '音频';

  @override
  String get player_statistics => '播放统计';

  @override
  String get player_auto => '自动';

  @override
  String get source_information => '来源资料';

  @override
  String get source_code_page => '页码';

  @override
  String get source_code_query => '关键词';

  @override
  String get repository_invalid_source => '无效来源，请移除';

  @override
  String get player_fit_contain => '完整';

  @override
  String get player_fit_cover => '覆盖';

  @override
  String get player_fit_fill => '拉伸';

  @override
  String get player_fit_height => '高度';

  @override
  String get player_fit_width => '宽度';

  @override
  String get player_fit_scale => '缩小';

  @override
  String get player_fit_none => '原始';

  @override
  String get player_shader_clear => '关闭着色器';

  @override
  String get player_shader_luma => '亮度升采样';

  @override
  String get player_decoder_auto => '自动（硬件）';

  @override
  String get player_decoder_software => '软件解码';

  @override
  String get player_stats_toggle => '显示或隐藏统计';

  @override
  String get player_stats_general => '概览';

  @override
  String get player_stats_frames => '帧耗时';

  @override
  String get player_stats_cache => '输入缓存';

  @override
  String get player_stats_filters => '启用的滤镜';

  @override
  String get player_stats_log => '日志';

  @override
  String get source_mark_pinned => '设为常用';

  @override
  String translation_image_action(String action) {
    return '$action此图片';
  }

  @override
  String get memory_waiting => '内存：等待采样';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS   $current   峰值 $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return '缓存 $current / $limit   峰值 $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return '图片 $count / $limit   活跃 $live   峰值 $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    return '满载 $percent% · $count 次采样';
  }

  @override
  String get memory_reset_hint => '在设置中关闭后重新开启即可重置';

  @override
  String get action_hide => '隐藏';

  @override
  String discord_get_app(String app) {
    return '获取 $app';
  }

  @override
  String get discord_idle => '空闲';

  @override
  String discord_watching_title(String title) {
    return '正在观看 $title';
  }

  @override
  String discord_reading_title(String title) {
    return '正在阅读 $title';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get browser_search_hint => '搜尋或輸入網址';

  @override
  String get browser_start_hint => '從這裡，發現新的精彩。';

  @override
  String get browser_search_engine => '搜尋引擎';

  @override
  String get browser_bookmarks => '書籤';

  @override
  String get browser_search_library => '搜尋標題或網址';

  @override
  String get browser_data_failed => '瀏覽器資料讀取或儲存失敗，請重試。';

  @override
  String get browser_clear_history => '清除瀏覽記錄';

  @override
  String get browser_clear_history_hint => '刪除此裝置上的全部瀏覽記錄？書籤和網站登入狀態將保留。';

  @override
  String get browser_library_empty => '這裡還是空的';

  @override
  String get browser_bookmarks_hint => '在網頁選單中加入書籤，即可在這裡找到它。';

  @override
  String get browser_history_hint => '造訪過的網頁會留在這裡，關閉分頁後也能找回。';

  @override
  String get browser_recent => '最近造訪';

  @override
  String get browser_pinned_hint => '在來源中釘選常用網站，即可快速造訪。';

  @override
  String get browser_start_page => '起始頁';

  @override
  String get browser_remove_bookmark => '移除書籤';

  @override
  String get browser_add_bookmark => '加入書籤';

  @override
  String get browser_find => '在頁面中尋找';

  @override
  String get browser_copy_link => '複製連結';

  @override
  String get browser_action_failed => '操作未完成，請重試。';

  @override
  String get browser_find_previous => '上一個相符項目';

  @override
  String get browser_find_next => '下一個相符項目';

  @override
  String browser_find_matches(int current, int total) {
    return '第 $current 項，共 $total 項';
  }

  @override
  String get app_update_details_hint => '檢視更新說明與安裝方式';

  @override
  String get app_update_download => '下載更新';

  @override
  String get app_update_download_hint => '下載完成後，按提示安裝更新。';

  @override
  String get bookshelf_all => '全部';

  @override
  String get bookshelf_search => '搜尋書架';

  @override
  String get app_update_allow_install => '請在系統設定中允許安裝應用，然後返回點選安裝。';

  @override
  String get app_update_waiting => '等待系統繼續下載…';

  @override
  String get app_update_cancel_download => '取消下載';

  @override
  String get app_update_remove_package => '刪除安裝包';

  @override
  String get app_name => 'NodeLane漫譯';

  @override
  String get settings_search_empty => '未找到相關設定';

  @override
  String get search_empty_hint => '試試其他關鍵詞，或清除搜尋檢視全部內容。';

  @override
  String get search_clear => '清除搜尋';

  @override
  String get app_updates => '軟體更新';

  @override
  String get app_update_auto => '啟動時檢查更新';

  @override
  String get app_update_view => '檢視更新';

  @override
  String get app_update_later => '稍後';

  @override
  String get app_update_external_hint => '在瀏覽器中開啟更新連結';

  @override
  String get app_update_failed => '暫時無法檢查更新，請重試。';

  @override
  String get app_update_opened => '已開啟更新連結';

  @override
  String get app_diagnostics => '診斷與日誌';

  @override
  String get library => '書架';

  @override
  String get updates_search => '搜尋更新';

  @override
  String get updates => '更新';

  @override
  String get history => '歷史';

  @override
  String get browse => '瀏覽';

  @override
  String get more => '更多';

  @override
  String get open_random_entry => '隨機開啟條目';

  @override
  String get import => '匯入';

  @override
  String get filter => '篩選';

  @override
  String get ignore_filters => '忽略\n篩選';

  @override
  String get downloaded => '已下載';

  @override
  String get unread => '未讀';

  @override
  String get unwatched => '未觀看';

  @override
  String get started => '已開始';

  @override
  String get bookmarked => '已書籤';

  @override
  String get sort => '排序';

  @override
  String get alphabetically => '按字母順序';

  @override
  String get last_read => '最後閱讀';

  @override
  String get last_watched => '上次觀看';

  @override
  String get last_update_check => '最後更新檢查';

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
      other: '你正在從你的庫中刪除此$mediaType的全部$count$entryTypePlural。',
      one: '你正在從你的庫中刪除此$mediaType的唯一$entryType。',
    );
    return '$_temp0\n這也會將整個$mediaType從你的庫中移除。\n\n注意：檔案本身不會被刪除。';
  }

  @override
  String get chapter => '章節';

  @override
  String get episode => '劇集';

  @override
  String get unread_count => '未讀計數';

  @override
  String get unwatched_count => '未觀看計數';

  @override
  String get latest_chapter => '最新章節';

  @override
  String get latest_episode => '最新一集';

  @override
  String get date_added => '新增日期';

  @override
  String get display => '顯示';

  @override
  String get display_mode => '顯示模式';

  @override
  String get compact_grid => '緊湊網格';

  @override
  String get compression_level => '壓縮級別';

  @override
  String compression_info(Object level) {
    return '壓縮率越高，備份檔案佔用的空間越小，但會消耗更多的CPU。預設值：$level';
  }

  @override
  String get comfortable_grid => '舒適網格';

  @override
  String get cover_only_grid => '僅封面網格';

  @override
  String get list => '列表';

  @override
  String get badges => '徽章';

  @override
  String get downloaded_chapters => '已下載章節';

  @override
  String get downloaded_episodes => '下載的劇集';

  @override
  String get language => '語言';

  @override
  String get local_source => '本地來源';

  @override
  String get tabs => '標籤';

  @override
  String get show_category_tabs => '顯示類別標籤';

  @override
  String get show_numbers_of_items => '顯示專案數';

  @override
  String get other => '其他';

  @override
  String get show_continue_reading_buttons => '顯示繼續閱讀按鈕';

  @override
  String get show_continue_watching_buttons => '顯示繼續觀看按鈕';

  @override
  String get empty_library => '書架還是空的';

  @override
  String get search => '搜尋...';

  @override
  String get no_recent_updates => '無最近更新';

  @override
  String get remove_everything => '刪除所有';

  @override
  String get remove_everything_msg => '你確定嗎？所有歷史將丟失';

  @override
  String get remove_all_update_msg => '你確定嗎？所有更新將被清除';

  @override
  String get ok => '好';

  @override
  String get cancel => '取消';

  @override
  String get remove => '移除';

  @override
  String get remove_history_msg => '這將移除此章節的閱讀日期。你確定嗎？';

  @override
  String get last_used => '最後使用';

  @override
  String get pinned => '已固定';

  @override
  String get sources => '來源';

  @override
  String get install => '安裝';

  @override
  String get update => '更新';

  @override
  String get latest => '最新';

  @override
  String get extensions => '擴充套件';

  @override
  String get migrate => '遷移';

  @override
  String get mass_migration_title => '批次遷移';

  @override
  String get mass_migration_preview_items => '選擇作品';

  @override
  String get mass_migration_destination_source => '目標來源';

  @override
  String get mass_migration_no_library_items => '書庫中暫無可遷移的作品。';

  @override
  String get mass_migration_no_destination_sources => '暫無可用的已安裝目標來源。';

  @override
  String get mass_migration_installed => '已安裝';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個專案準備好複檢',
      one: '1個專案準備好複檢',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 部作品',
      one: '1 部作品',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => '選擇目標來源';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return '正在 $source • $language 中尋找匹配項';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return '正在匹配第 $current / $total 部作品';
  }

  @override
  String get mass_migration_waiting_next_item => '等待2秒後處理下一個專案...';

  @override
  String get mass_migration_waiting_next_migration => '等待2秒後處理下一項遷移...';

  @override
  String mass_migration_matched_so_far(int count) {
    return '目前已匹配: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return '未匹配: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return '核對來自 $source 的匹配結果';
  }

  @override
  String mass_migration_found_matches(int count) {
    return '找到匹配項: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return '未找到匹配: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return '已選 $count 部作品';
  }

  @override
  String get mass_migration_finish_review => '結束核對';

  @override
  String mass_migration_migrate_selected(int count) {
    return '遷移所選作品（$count）';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return '正在將選定專案遷移至 $source';
  }

  @override
  String get mass_migration_no_items_selected => '未選擇任何作品進行遷移。';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return '正在遷移第 $current / $total 部作品';
  }

  @override
  String get mass_migration_complete => '批次遷移完成';

  @override
  String get mass_migration_complete_success_message => '所有選定專案均已處理成功。';

  @override
  String get mass_migration_complete_partial_message => '遷移結束，但部分專案仍需手動處理。';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => '已處理';

  @override
  String get mass_migration_matched => '已匹配';

  @override
  String get mass_migration_migrated => '已遷移';

  @override
  String get mass_migration_skipped => '已跳過';

  @override
  String get mass_migration_failed => '失敗';

  @override
  String get mass_migration_failed_items => '失敗專案';

  @override
  String get mass_migration_exit => '退出批次遷移';

  @override
  String get mass_migration_no_destination_match => '未找到目標匹配項';

  @override
  String mass_migration_query(Object query) {
    return '搜尋詞：$query';
  }

  @override
  String get mass_migration_skip => '跳過';

  @override
  String get mass_migration_loading => '正在載入...';

  @override
  String get mass_migration_choose_another_result => '選擇其他結果';

  @override
  String get mass_migration_source_chapters => '原章節';

  @override
  String get mass_migration_destination_chapters => '目標章節';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個章節',
      one: '1個章節',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個原章節',
      one: '1個原章節',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個目標章節',
      one: '1個目標章節',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => '未找到章節。';

  @override
  String mass_migration_and_more_chapters(int count) {
    return '以及更多 $count 個...';
  }

  @override
  String get mass_migration_unknown_title => '未知標題';

  @override
  String get mass_migration_unknown_match => '未知匹配';

  @override
  String get mass_migration_unknown_source => '未知來源';

  @override
  String get mass_migration_unknown_chapter => '未知章節';

  @override
  String get migrate_confirm => '遷移到另一個來源';

  @override
  String get clean_database => '清理資料庫';

  @override
  String cleaned_database(Object x) {
    return '資料庫已清理！已移除 $x 條目';
  }

  @override
  String get clean_database_desc => '這將移除所有未新增到圖書館的專案！';

  @override
  String get incognito_mode => '隱身模式';

  @override
  String get incognito_mode_description => '暫停閱讀歷史';

  @override
  String get downloaded_only => '僅已下載';

  @override
  String get downloaded_only_description => '僅顯示庫中已下載的條目';

  @override
  String get download_queue => '下載佇列';

  @override
  String get categories => '類別';

  @override
  String get statistics => '統計';

  @override
  String get settings => '設定';

  @override
  String get about => '關於';

  @override
  String get help => '幫助';

  @override
  String get no_downloads => '無下載';

  @override
  String get edit_categories => '編輯類別';

  @override
  String get edit_categories_description => '你還沒有類別。點選加號按鈕建立一個來組織你的圖書館';

  @override
  String get add => '新增';

  @override
  String get add_category => '新增類別';

  @override
  String get name => '名稱';

  @override
  String label_value(Object label, Object value) {
    return '$label：$value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*必填';

  @override
  String get add_category_error_exist => '此名稱的類別已存在！';

  @override
  String get delete_category => '刪除類別';

  @override
  String delete_category_msg(Object name) {
    return '你希望刪除類別 $name 嗎？';
  }

  @override
  String get rename_category => '重新命名類別';

  @override
  String get general => '通用';

  @override
  String get general_subtitle => '應用語言';

  @override
  String get app_language => '應用語言';

  @override
  String get default_subtitle_language => '預設字幕語言';

  @override
  String get appearance => '外觀';

  @override
  String get appearance_subtitle => '主題，日期和時間格式';

  @override
  String get theme => '主題';

  @override
  String get dark_mode => '暗模式';

  @override
  String get follow_system_theme => '跟隨系統主題';

  @override
  String get on => '開';

  @override
  String get off => '關';

  @override
  String get pure_black_dark_mode => '純黑暗模式';

  @override
  String get timestamp => '時間戳';

  @override
  String get relative_timestamp => '相對時間戳';

  @override
  String get relative_timestamp_short => '短（今天，昨天）';

  @override
  String get relative_timestamp_long => '長（短+，n天前）';

  @override
  String get date_format => '日期格式';

  @override
  String get reader => '閱讀器';

  @override
  String get refresh => '重新整理';

  @override
  String get reader_subtitle => '閱讀模式，顯示，導航';

  @override
  String get default_reading_mode => '預設閱讀模式';

  @override
  String get reading_mode_vertical => '垂直';

  @override
  String get reading_mode_horizontal => '水平';

  @override
  String get reading_mode_left_to_right => '從左到右';

  @override
  String get reading_mode_right_to_left => '從右到左';

  @override
  String get reading_mode_vertical_continuous => '垂直連續';

  @override
  String get reading_mode_webtoon => '網路漫畫';

  @override
  String get double_tap_animation_speed => '雙擊動畫速度';

  @override
  String get normal => '正常';

  @override
  String get fast => '快';

  @override
  String get no_animation => '無動畫';

  @override
  String get animate_page_transitions => '動畫頁面過渡';

  @override
  String get crop_borders => '裁剪邊框';

  @override
  String get downloads => '下載';

  @override
  String get downloads_subtitle => '下載設定';

  @override
  String get download_location => '下載位置';

  @override
  String get custom_location => '自定義位置';

  @override
  String get only_on_wifi => '僅在wifi下';

  @override
  String get save_as_cbz_archive => '儲存為CBZ檔案';

  @override
  String get delete_download_after_reading => '完成閱讀後刪除下載內容';

  @override
  String get concurrent_downloads => '併發下載';

  @override
  String get browse_subtitle => '來源，全球搜尋';

  @override
  String get only_include_pinned_sources => '僅包括固定來源';

  @override
  String get nsfw_sources => 'NSFW（18+）來源';

  @override
  String get nsfw_sources_show => '在來源和擴充套件列表中顯示';

  @override
  String get nsfw_sources_info => '這不會阻止非官方或可能被錯誤標記的擴充套件在應用內顯示NSFW（18+）內容';

  @override
  String get version => '版本';

  @override
  String beta_version(Object version) {
    return '測試版 ($version)';
  }

  @override
  String get check_for_update => '檢查更新';

  @override
  String get logs_on => '啟用日誌';

  @override
  String get share_app_logs => '分享應用日誌';

  @override
  String get no_app_logs => '沒有可用的 log.txt 檔案！';

  @override
  String get failed => '失敗！';

  @override
  String n_days_ago(Object days) {
    return '$days天前';
  }

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get a_week_ago => '一週前';

  @override
  String get next_week => '下週';

  @override
  String get add_to_library => '加入書架';

  @override
  String get completed => '已完成';

  @override
  String get ongoing => '進行中';

  @override
  String get on_hiatus => '暫停';

  @override
  String get canceled => '已取消';

  @override
  String get publishing_finished => '釋出完成';

  @override
  String get unknown => '未知';

  @override
  String get empty_placeholder => '空';

  @override
  String get error => '錯誤';

  @override
  String error_with_message(Object error) {
    return '錯誤：$error';
  }

  @override
  String get no_pages_available => '錯誤：無可用頁面';

  @override
  String get set_categories => '設定分類';

  @override
  String get edit => '編輯';

  @override
  String get in_library => '已在書架';

  @override
  String get filter_scanlator_groups => '漢化組';

  @override
  String get reset => '重置';

  @override
  String get by_source => '按來源';

  @override
  String get by_chapter_number => '按章節號';

  @override
  String get by_episode_number => '按集數';

  @override
  String get by_upload_date => '按上傳日期';

  @override
  String get source_title => '來源標題';

  @override
  String get create_extension => '建立擴充套件';

  @override
  String get developer_mode => '開發者模式';

  @override
  String get developer_mode_subtitle => '顯示擴充套件開發者工具（建立擴充套件、編輯程式碼）';

  @override
  String get choose_extension_language => '選擇擴充套件語言';

  @override
  String get lang => '語言';

  @override
  String get base_url => '基礎 URL';

  @override
  String get api_url_optional => 'API URL（可選）';

  @override
  String get icon_url => '圖示 URL';

  @override
  String get source_icon_url => '圖源圖示 URL';

  @override
  String get notes => '備註';

  @override
  String get extension_name_example => '例如：myAnime';

  @override
  String get language_code_example => '例如：zh';

  @override
  String get base_url_example => '例如：https://example.com';

  @override
  String get api_url_example => '例如：https://api.example.com';

  @override
  String get extension_notes_example => '例如：此擴充套件需要登入';

  @override
  String get type => '型別';

  @override
  String get target => '目標';

  @override
  String get source_type_single => '單一';

  @override
  String get source_type_multi => '多源';

  @override
  String get source_type_torrent => '種子 (Torrent)';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader 編譯 JS';

  @override
  String get source_created_successfully => '圖源建立成功';

  @override
  String get source_already_exists => '圖源已存在';

  @override
  String get error_when_creating_source => '建立圖源時出錯';

  @override
  String get cookies_deleted => 'Cookie 已刪除！';

  @override
  String get delete_all_cookies => '刪除所有 Cookie';

  @override
  String get chapter_number => '章節號';

  @override
  String get episode_number => '集數';

  @override
  String get share => '分享';

  @override
  String n_chapters(Object n) {
    return '$n章';
  }

  @override
  String missing_chapters(Object count) {
    return '缺少 $count 個章節';
  }

  @override
  String get no_description => '無描述';

  @override
  String get resume => '繼續';

  @override
  String get read => '閱讀';

  @override
  String get watch => '觀看';

  @override
  String get popular => '流行';

  @override
  String get open_in_browser => '在瀏覽器中開啟';

  @override
  String get clear_cookie => '清除Cookie';

  @override
  String get show_page_number => '顯示頁碼';

  @override
  String get from_library => '來自圖書館';

  @override
  String get downloaded_chapter => '已下載章節';

  @override
  String page(Object page) {
    return '頁面 $page';
  }

  @override
  String get global_search => '全域性搜尋';

  @override
  String get color_blend_level => '顏色混合級別';

  @override
  String current(Object char) {
    return '當前 $char';
  }

  @override
  String finished(Object char) {
    return '完成 $char';
  }

  @override
  String next(Object char) {
    return '下一個 $char';
  }

  @override
  String previous(Object char) {
    return '上一個 $char';
  }

  @override
  String get no_more_chapter => '沒有更多章節';

  @override
  String get no_result => '無結果';

  @override
  String get send => '傳送';

  @override
  String get delete => '刪除';

  @override
  String get start_downloading => '立即開始下載';

  @override
  String get retry => '重試';

  @override
  String get add_chapters => '新增章節';

  @override
  String get delete_chapters => '刪除章節？';

  @override
  String get default0 => '預設';

  @override
  String get total_chapters => '總章節數';

  @override
  String get total_episodes => '總集數';

  @override
  String get import_local_file => '匯入本地檔案';

  @override
  String get import_files => '檔案';

  @override
  String get split_epub_chapters => '分章節匯入';

  @override
  String get split_epub_chapters_description => '將每個EPUB章節作為單獨條目匯入';

  @override
  String get nothing_read_recently => '最近未閱讀';

  @override
  String get status => '狀態';

  @override
  String get not_started => '未開始';

  @override
  String get score => '評分';

  @override
  String get start_date => '開始日期';

  @override
  String get finish_date => '完成日期';

  @override
  String get reading => '閱讀';

  @override
  String get on_hold => '擱置';

  @override
  String get dropped => '已放棄';

  @override
  String get plan_to_read => '計劃閱讀';

  @override
  String get re_reading => '重讀';

  @override
  String get chapters => '章節';

  @override
  String get add_tracker => '新增追蹤';

  @override
  String get one_tracker => '1個追蹤器';

  @override
  String n_tracker(Object n) {
    return '$n個追蹤器';
  }

  @override
  String get tracking => '追蹤';

  @override
  String get syncing => '同步';

  @override
  String get sync_logged => '登入成功';

  @override
  String get syncing_subtitle => '填寫你使用的同步伺服器地址，透過瀏覽器登入後，在裝置間同步閱讀進度。';

  @override
  String get sync_service => '自建同步服務';

  @override
  String get last_sync => '上次同步時間：';

  @override
  String get sync_login_browser => '使用瀏覽器登入';

  @override
  String get sync_server => '同步伺服器地址';

  @override
  String get sync_starting => '開始同步...';

  @override
  String get sync_finished => '同步完成';

  @override
  String get sync_failed => '同步失敗';

  @override
  String get sync_restore_in_progress => '已跳過同步 — 正在恢復中';

  @override
  String sync_progress_percent(Object percent) {
    return '正在同步… $percent%';
  }

  @override
  String get sync_progress_indeterminate => '正在同步…';

  @override
  String get sync_button_sync => '同步進度';

  @override
  String get sync_button_upload => '僅上傳';

  @override
  String get sync_button_upload_info => '此操作將完全用本地資料替換遠端資料！';

  @override
  String get sync_button_download => '僅下載';

  @override
  String get sync_button_download_info => '此操作將完全用遠端資料替換本地資料！';

  @override
  String get sync_status_not_configured => '未連線';

  @override
  String get sync_status_checking => '正在檢查連線...';

  @override
  String get sync_status_connected => '已連線';

  @override
  String get sync_status_unauthorized => '會話已過期，請重新登入';

  @override
  String get sync_status_unreachable => '無法連線到伺服器';

  @override
  String get sync_section_general => '通用';

  @override
  String get sync_on => '啟用同步';

  @override
  String get sync_auto => '自動同步';

  @override
  String get sync_auto_warning => '自動同步目前是實驗性功能！';

  @override
  String get sync_auto_off => '關閉';

  @override
  String get sync_auto_5_minutes => '每5分鐘';

  @override
  String get sync_auto_10_minutes => '每10分鐘';

  @override
  String get sync_auto_30_minutes => '每30分鐘';

  @override
  String get sync_auto_1_hour => '每1小時';

  @override
  String get sync_auto_3_hours => '每3小時';

  @override
  String get sync_auto_6_hours => '每6小時';

  @override
  String get sync_auto_12_hours => '每12小時';

  @override
  String get server_error => '伺服器錯誤！';

  @override
  String get dialog_confirm => '確認';

  @override
  String get description => '描述';

  @override
  String get reorder_navigation => '自定義導航';

  @override
  String get reorder_navigation_description => '根據需要重新排序和切換每個導航。';

  @override
  String get floating_navigation_bar => '懸浮導航欄';

  @override
  String get floating_navigation_bar_description => '使用懸浮膠囊式導航欄。';

  @override
  String get full_screen_player => '使用全屏';

  @override
  String get full_screen_player_info => '播放影片時自動使用全屏。';

  @override
  String episode_progress(Object n) {
    return '進度：$n';
  }

  @override
  String n_episodes(int n) {
    return '$n集';
  }

  @override
  String missing_episodes(Object count) {
    return '缺少 $count 集';
  }

  @override
  String get manga_sources => '漫畫來源';

  @override
  String get anime_sources => '動畫來源';

  @override
  String get novel_sources => '小說來源';

  @override
  String get anime_extensions => '動畫擴充套件';

  @override
  String get manga_extensions => '漫畫擴充套件';

  @override
  String get novel_extensions => '小說擴充套件';

  @override
  String get extension_settings => '擴充套件設定';

  @override
  String get anime => '動畫';

  @override
  String get manga => '漫畫';

  @override
  String get novel => '小說';

  @override
  String get library_no_category_exist => '你還沒有任何類別';

  @override
  String get watching => '觀看中';

  @override
  String get plan_to_watch => '計劃觀看';

  @override
  String get re_watching => '重看';

  @override
  String get episodes => '集';

  @override
  String get download => '下載';

  @override
  String get new_update_available => '發現新版本';

  @override
  String app_version(Object v) {
    return '應用版本：v$v';
  }

  @override
  String get searching_for_updates => '正在搜尋更新...';

  @override
  String get no_new_updates_available => '沒有新的更新可用';

  @override
  String get uninstall => '解除安裝';

  @override
  String uninstall_extension(Object ext) {
    return '解除安裝 $ext 擴充套件？';
  }

  @override
  String double_tap_search_hint(Object type) {
    return '雙擊以搜尋全部 $type';
  }

  @override
  String get show_nav_double_tap_tooltip => '顯示雙擊搜尋提示';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      '在漫畫/動畫/小說導航欄上顯示提示，說明雙擊可開啟全域性搜尋。';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" 已透過 $source 新增到您的書架中。';
  }

  @override
  String get add_anyway => '仍然新增';

  @override
  String get langauage => '語言';

  @override
  String get extension_detail => '擴充套件詳情';

  @override
  String get scale_type => '縮放型別';

  @override
  String get scale_type_fit_screen => '適合螢幕';

  @override
  String get scale_type_stretch => '拉伸';

  @override
  String get scale_type_fit_width => '適合寬度';

  @override
  String get scale_type_fit_height => '適合高度';

  @override
  String get scale_type_original_size => '原始大小';

  @override
  String get scale_type_smart_fit => '智慧適配';

  @override
  String get page_preload_amount => '頁面預載入量';

  @override
  String get page_preload_amount_subtitle =>
      '閱讀時預載入的頁面數量。更高的值將導致更順暢的閱讀體驗，但會增加快取和網路使用。';

  @override
  String get image_loading_error => '無法載入此圖片';

  @override
  String get add_episodes => '新增集數';

  @override
  String get video_quality => '質量';

  @override
  String get video_subtitle => '字幕';

  @override
  String get check_for_extension_updates => '檢查第三方擴充套件更新';

  @override
  String get auto_extensions_updates => '自動更新第三方擴充套件';

  @override
  String get auto_extensions_updates_subtitle =>
      '自動更新已安裝的第三方擴充套件。官方外掛始終自動安裝和更新。';

  @override
  String get check_for_app_updates => '啟動時檢查應用更新';

  @override
  String get reading_mode => '閱讀模式';

  @override
  String get custom_filter => '自定義篩選';

  @override
  String get background_color => '背景顏色';

  @override
  String get white => '白色';

  @override
  String get black => '黑色';

  @override
  String get grey => '灰色';

  @override
  String get automaic => '自動';

  @override
  String get preferred_domain => '首選域';

  @override
  String get load_more => '載入更多';

  @override
  String get cancel_all_for_this_series => '為此係列取消所有';

  @override
  String get login => '登入';

  @override
  String login_into(Object tracker) {
    return '登入到 $tracker';
  }

  @override
  String get email_adress => '電子郵件地址';

  @override
  String get password => '密碼';

  @override
  String log_out_from(Object tracker) {
    return '從 $tracker 登出？';
  }

  @override
  String get log_out => '登出';

  @override
  String get update_pending => '更新待定';

  @override
  String get update_all => '更新全部';

  @override
  String get backup_and_restore => '備份和恢復';

  @override
  String get create_backup => '建立備份';

  @override
  String get create_backup_dialog_title => '你想要備份什麼？';

  @override
  String get create_backup_subtitle => '可用於恢復當前圖書館';

  @override
  String get restore_backup => '恢復備份';

  @override
  String get encrypt_backups => '加密備份';

  @override
  String get encrypt_backups_info => '使用 AES 加密和密碼保護備份檔案';

  @override
  String get no_secure_storage => '未找到安全儲存';

  @override
  String get no_keyring_warning => '當前系統沒有金鑰環服務，無法安全儲存密碼。\n\n是否以明文形式儲存在本地資料庫中？';

  @override
  String get enter_backup_password => '輸入備份密碼';

  @override
  String get incorrect_password_try_again => '密碼錯誤，請重試。';

  @override
  String get set_backup_password => '設定備份密碼';

  @override
  String get confirm_password => '確認密碼';

  @override
  String get passwords_do_not_match => '密碼不匹配';

  @override
  String get password_required_to_restore => '需要密碼才能恢復此備份。';

  @override
  String get restore_backup_subtitle => '從備份檔案恢復圖書館';

  @override
  String get automatic_backups => '自動備份';

  @override
  String get backup_frequency => '備份頻率';

  @override
  String get backup_location => '備份位置';

  @override
  String get backup_options => '備份選項';

  @override
  String get backup_options_dialog_title => '你想要備份什麼？';

  @override
  String get backup_options_subtitle => '包含在備份檔案中的資訊';

  @override
  String get backup_and_restore_warning_info => '你應該在其他地方儲存備份副本';

  @override
  String get library_entries => '圖書館條目';

  @override
  String get chapters_and_episode => '章節和集數';

  @override
  String get every_6_hours => '每6小時';

  @override
  String get every_12_hours => '每12小時';

  @override
  String get daily => '每日';

  @override
  String get every_2_days => '每2天';

  @override
  String get weekly => '每週';

  @override
  String get restore_backup_warning_title => '恢復備份將覆蓋所有現有資料。\n\n繼續恢復？';

  @override
  String get restore_sync_question_title => '是否同步此次恢復？';

  @override
  String get restore_sync_question_message => '此裝置已連線到同步伺服器。是否立即將恢復的資料上傳？';

  @override
  String get restore_sync_question_confirm => '是，進行同步';

  @override
  String get restore_sync_question_deny => '否，禁用同步';

  @override
  String get sync_disabled_after_restore => '同步已禁用。您可以在“設定”中重新開啟。';

  @override
  String get restore_sync_disabled_question_title => '同步當前已禁用';

  @override
  String get restore_sync_disabled_question_message =>
      '同步已關閉。是否重新開啟並將恢復的資料上傳到伺服器？';

  @override
  String get restore_sync_question_reenable => '是，重新開啟並同步';

  @override
  String get restore_sync_question_keep_disabled => '保持禁用';

  @override
  String get restore_sync_uploading => '正在同步恢復的資料到伺服器…';

  @override
  String get restore_sync_upload_success => '恢復的資料已同步到伺服器';

  @override
  String get services => '服務';

  @override
  String get tracking_warning_info => '單向同步以更新跟蹤服務中的章節進度。從它們的跟蹤按鈕為個別條目設定跟蹤。';

  @override
  String get use_page_tap_zones => '使用頁面點選區域';

  @override
  String get manage_trackers => '管理跟蹤器';

  @override
  String get restore => '恢復';

  @override
  String get backups => '備份';

  @override
  String get by_scanlator => '按翻譯者';

  @override
  String get by_name => '按名稱';

  @override
  String get installed => '已安裝';

  @override
  String get auto_scroll => '自動滾動';

  @override
  String get video_audio => '音訊';

  @override
  String get video_audio_info => '首選語言、音調校正、音訊通道';

  @override
  String get player => '播放器';

  @override
  String get markEpisodeAsSeenSetting => '標記劇集為已看的時間點';

  @override
  String get mark_duplicate_chapters_read => '將重複的章節號標記為已讀';

  @override
  String get default_skip_intro_length => '片頭跳過時長';

  @override
  String get default_playback_speed_length => '預設播放速度';

  @override
  String get updateProgressAfterReading => '閱讀後更新進度';

  @override
  String get no_sources_installed => '還沒有可用來源';

  @override
  String get show_extensions => '顯示擴充套件';

  @override
  String get default_skip_forward_skip_length => '雙擊快進／快退時長';

  @override
  String get aniskip_requires_info =>
      '使用 AniSkip 前，需要將動畫關聯到 MyAnimeList 或 AniList 追蹤。';

  @override
  String get enable_aniskip => '啟用 AniSkip';

  @override
  String get enable_auto_skip => '啟用自動跳過';

  @override
  String get aniskip_button_timeout => '按鈕超時';

  @override
  String get skip_opening => '跳過片頭';

  @override
  String get skip_ending => '跳過片尾';

  @override
  String get fullscreen => '全屏';

  @override
  String get update_library => '更新庫';

  @override
  String get next_chapter => '下一章';

  @override
  String get next_5_chapters => '下5章';

  @override
  String get next_10_chapters => '下10章';

  @override
  String get next_25_chapters => '下25章';

  @override
  String get all_chapters => '所有章節';

  @override
  String get next_episode => '下一集';

  @override
  String get next_5_episodes => '接下來的 5 集';

  @override
  String get next_10_episodes => '接下來的 10 集';

  @override
  String get next_25_episodes => '接下來的 25 集';

  @override
  String get all_episodes => '所有劇集';

  @override
  String get cover_saved => '封面已儲存';

  @override
  String get set_as_cover => '設定為封面';

  @override
  String get use_this_as_cover_art => '使用此作為封面？';

  @override
  String get save => '儲存';

  @override
  String get picture_saved => '圖片已儲存';

  @override
  String get cover_updated => '封面已更新';

  @override
  String get include_subtitles => '包含字幕';

  @override
  String get blend_mode_default => '預設';

  @override
  String get blend_mode_multiply => '正片疊底';

  @override
  String get blend_mode_screen => '濾色';

  @override
  String get blend_mode_overlay => '疊加';

  @override
  String get blend_mode_colorDodge => '顏色減淡';

  @override
  String get blend_mode_lighten => '變亮';

  @override
  String get blend_mode_colorBurn => '顏色加深';

  @override
  String get blend_mode_darken => '變暗';

  @override
  String get blend_mode_difference => '差異';

  @override
  String get blend_mode_saturation => '飽和度';

  @override
  String get blend_mode_softLight => '柔光';

  @override
  String get blend_mode_plus => '加';

  @override
  String get blend_mode_exclusion => '排除';

  @override
  String get custom_color_filter => '自定義顏色濾鏡';

  @override
  String get color_filter_blend_mode => '顏色濾鏡混合模式';

  @override
  String get enable_all => '啟用全部';

  @override
  String get disable_all => '禁用全部';

  @override
  String get font => '字型';

  @override
  String get color => '顏色';

  @override
  String get font_size => '字號';

  @override
  String get text => '文字';

  @override
  String get border => '邊框';

  @override
  String get background => '背景';

  @override
  String get no_subtite_warning_message => '由於此影片中沒有字幕軌道，因此無效。';

  @override
  String get grid_size => '網格大小';

  @override
  String n_per_row(Object n) {
    return '$n 每行';
  }

  @override
  String get horizontal_continious => '水平連續';

  @override
  String get edit_code => '編輯程式碼';

  @override
  String get use_libass => '啟用 libass';

  @override
  String get use_libass_info => '使用基於 libass 的字幕渲染作為本地後端。';

  @override
  String get libass_not_disable_message => '在播放器設定中禁用 `use libass` 以便自定義字幕。';

  @override
  String get override_ass_subtitles => '覆蓋 ASS 字幕樣式';

  @override
  String get override_ass_subtitles_info => '將自定義樣式應用到 ASS/SSA 字幕';

  @override
  String get torrent_stream => '種子流';

  @override
  String get add_torrent => '新增種子';

  @override
  String get enter_torrent_hint_text => '輸入磁力連結或種子檔案 URL';

  @override
  String get torrent_url => '種子 URL';

  @override
  String get or => '或';

  @override
  String get advanced => '高階';

  @override
  String get advanced_info => 'mpv 配置';

  @override
  String get use_native_http_client => '使用本地 HTTP 客戶端';

  @override
  String get use_native_http_client_info =>
      '它自動支援平臺特性，如 VPN，支援更多 HTTP 特性，如 HTTP/3 和自定義重定向處理';

  @override
  String n_hour_ago(Object hour) {
    return '$hour小時前';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours小時前';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute分鐘前';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes分鐘前';
  }

  @override
  String n_day_ago(Object day) {
    return '$day天前';
  }

  @override
  String get now => '現在';

  @override
  String library_last_updated(Object lastUpdated) {
    return '圖書館最近更新時間：$lastUpdated';
  }

  @override
  String get data_and_storage => '資料與儲存';

  @override
  String get download_location_info => '用於章節下載';

  @override
  String get storage => '儲存';

  @override
  String get clear_chapter_and_episode_cache => '清除章節和劇集快取';

  @override
  String get cache_cleared => '快取已清除';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch => '啟動應用時清除章節/劇集快取';

  @override
  String get app_settings => '應用設定';

  @override
  String get sources_settings => '來源設定';

  @override
  String get include_sensitive_settings => '包含敏感設定（例如追蹤器登入令牌）';

  @override
  String get create => '建立';

  @override
  String get downloads_are_limited_to_wifi => '下載僅限於WiFi';

  @override
  String get recommendations => '推薦';

  @override
  String get recommendations_similar => '相似';

  @override
  String get recommendations_weights => '推薦權重';

  @override
  String get recommendations_weights_genre => '型別相似度';

  @override
  String get recommendations_weights_setting => '設定相似度';

  @override
  String get recommendations_weights_synopsis => '故事相似度';

  @override
  String get recommendations_weights_theme => '主題相似度';

  @override
  String get manga_extensions_repo => '漫畫擴充套件庫';

  @override
  String get anime_extensions_repo => '動畫擴充套件庫';

  @override
  String get novel_extensions_repo => '小說擴充套件庫';

  @override
  String get custom_dns => '自定義 DNS（留空使用系統 DNS）';

  @override
  String get android_proxy_server => 'Android 代理伺服器（M-Extension-Server）';

  @override
  String get get_m_extension_server => '獲取 M-Extension-Server';

  @override
  String get undefined => '未定義';

  @override
  String get empty_extensions_repo => '擴充套件庫為空';

  @override
  String get add_extensions_repo => '新增擴充套件庫';

  @override
  String get remove_extensions_repo => '移除擴充套件庫';

  @override
  String get manage_manga_repo_urls => '管理漫畫庫URL';

  @override
  String get manage_anime_repo_urls => '管理動畫庫URL';

  @override
  String get manage_novel_repo_urls => '管理小說庫URL';

  @override
  String get url_cannot_be_empty => 'URL不能為空';

  @override
  String get url_must_end_with_dot_json_or_dot_pb => 'URL必須以.json結尾';

  @override
  String get repo_url => '庫URL';

  @override
  String get invalid_url_format => '無效的URL格式';

  @override
  String get clear_all_sources => '清除所有來源';

  @override
  String get clear_all_sources_msg => '你確定嗎？所有來源將被清除';

  @override
  String get sources_cleared => '來源已清除';

  @override
  String get repo_added => '庫已新增';

  @override
  String get repo_already_exists => '軟體源倉庫已存在！';

  @override
  String get add_repo => '新增庫';

  @override
  String get add_repo_sources_to_add => '將新增以下擴充套件列表：';

  @override
  String get add_repo_warning => '這些倉庫的擴充套件會在應用內執行。請僅新增可信的倉庫。';

  @override
  String get genre_search_library => '按類別搜尋圖書館';

  @override
  String get genre_search_source => '按類別搜尋來源';

  @override
  String get source_not_added => '來源未新增';

  @override
  String get load_own_subtitles => '載入自定義字幕';

  @override
  String get search_subtitles => '線上搜尋字幕...';

  @override
  String extension_notes(Object notes) {
    return '備註：$notes';
  }

  @override
  String get unsupported_repo => '無法新增此來源倉庫。請檢查倉庫地址，或聯絡該倉庫的維護者。';

  @override
  String get you_have_finished_reading => '您已讀完';

  @override
  String get hwdec => '硬體解碼器';

  @override
  String get enable_hardware_accel => '硬體加速';

  @override
  String get enable_hardware_accel_info => '如果遇到錯誤或崩潰，請開啟/關閉';

  @override
  String get track_library_navigate => '轉到現有本地條目';

  @override
  String get track_library_add => '新增到本地庫';

  @override
  String get track_library_add_confirm => '將跟蹤專案新增到本地庫';

  @override
  String get track_library_not_logged => '請登入相應的跟蹤器以使用此功能！';

  @override
  String get track_library_switch => '切換到另一個跟蹤器';

  @override
  String get go_back => '返回';

  @override
  String get merge_library_nav_mobile => '在移動裝置上合併庫導航';

  @override
  String get enable_discord_rpc => '啟用 Discord RPC';

  @override
  String get hide_discord_rpc_incognito => '隱身模式下隱藏 Discord RPC';

  @override
  String get rpc_show_reading_watching_progress => '在 Discord 中顯示當前章節（需要重啟）';

  @override
  String get rpc_show_title => '在 Discord 中顯示當前標題';

  @override
  String get rpc_show_cover_image => '在 Discord 中顯示當前封面圖片';

  @override
  String get enable_mpv => '啟用 mpv 著色器/指令碼';

  @override
  String get mpv_info => '支援 mpv/scripts/ 下的 .js 指令碼';

  @override
  String get mpv_redownload => '重新下載 mpv 配置檔案';

  @override
  String get mpv_redownload_info => '用新配置檔案替換舊配置檔案！';

  @override
  String get mpv_download => '需要 MPV 配置檔案！\n現在下載？';

  @override
  String get custom_buttons => '自定義按鈕';

  @override
  String get custom_buttons_info => '使用自定義按鈕執行 lua 程式碼';

  @override
  String get custom_buttons_edit => '編輯自定義按鈕';

  @override
  String get custom_buttons_add => '新增自定義按鈕';

  @override
  String get custom_buttons_added => '已新增自定義按鈕！';

  @override
  String get custom_buttons_delete => '刪除自定義按鈕';

  @override
  String get custom_buttons_text => '按鈕文字';

  @override
  String get custom_buttons_text_req => '按鈕文字必填';

  @override
  String get custom_buttons_js_code => 'lua 程式碼';

  @override
  String get custom_buttons_js_code_req => 'lua 程式碼必填';

  @override
  String get custom_buttons_js_code_long => 'lua 程式碼（長按時）';

  @override
  String get custom_buttons_startup => 'lua 程式碼（啟動時）';

  @override
  String get custom_buttons_add_warning =>
      '此按鈕會在影片播放器中執行下方 Lua 程式碼，可訪問檔案並執行程式。請僅在信任此連結來源時新增。';

  @override
  String n_days(Object n) {
    return '$n 天';
  }

  @override
  String get decoder => '解碼器';

  @override
  String get decoder_info => '硬體解碼、畫素格式、去色帶';

  @override
  String get enable_gpu_next => '啟用 gpu-next（僅限 Android）';

  @override
  String get enable_gpu_next_info => '新的影片渲染引擎';

  @override
  String get debanding => '去色帶';

  @override
  String get use_yuv420p => '使用 YUV420P 畫素格式';

  @override
  String get use_yuv420p_info => '可以修復某些影片編解碼器上的黑屏，也可以以質量為代價提高效能';

  @override
  String get audio_preferred_languages => '首選語言';

  @override
  String get audio_preferred_languages_info =>
      '在具有多個音訊流的影片上預設選擇的音訊語言，2/3 字母語言程式碼（例如：zh、en、ja）。多個值可以用逗號分隔。';

  @override
  String get enable_audio_pitch_correction => '啟用音訊音調校正';

  @override
  String get enable_audio_pitch_correction_info => '防止音訊在較快速度時變高音，在較慢速度時變低音';

  @override
  String get audio_channels => '音訊通道';

  @override
  String get volume_boost_cap => '音量增強上限';

  @override
  String get internal_player => '內部播放器';

  @override
  String get internal_player_info => '進度、控制、方向';

  @override
  String get subtitle_delay_text => '字幕延遲';

  @override
  String get subtitle_delay => '延遲（毫秒）';

  @override
  String get subtitle_speed => '速度';

  @override
  String get tracks => '軌道';

  @override
  String get playback_speed => '播放速度';

  @override
  String get shaders => '著色器';

  @override
  String get video_fit => '畫面適配';

  @override
  String get calendar => '日曆';

  @override
  String get calendar_no_data => '暫無資料。';

  @override
  String get calendar_info => '日曆只能根據舊的上傳預測下一章的上傳。某些資料可能不是 100% 準確！';

  @override
  String in_n_day(Object days) {
    return '$days 天后';
  }

  @override
  String in_n_days(Object days) {
    return '$days 天后';
  }

  @override
  String get clear_library => '清空庫';

  @override
  String get clear_library_desc => '選擇清除所有漫畫、動畫和/或小說條目';

  @override
  String get clear_library_input =>
      '輸入 \'manga\'、\'anime\' 和/或 \'novel\'（用逗號分隔）以刪除所有相關條目';

  @override
  String get watch_order => '觀看順序';

  @override
  String get watch_order_role_current => '當前';

  @override
  String get watch_order_role_previous => '上一部';

  @override
  String get watch_order_role_next => '下一部';

  @override
  String get watch_order_source_release_order => '發行順序';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name · 作者：$author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Trakt 官方合集：$name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt 合集：$name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return '《$title》的各季';
  }

  @override
  String get watch_order_select_source => '順序來源';

  @override
  String watch_order_season(int number) {
    return '第 $number 季';
  }

  @override
  String watch_order_episode(int number) {
    return '第 $number 集';
  }

  @override
  String get sequels => '續集';

  @override
  String get recommendations_similarity => '相似度：';

  @override
  String recommendation_rating_accessibility(String rating) {
    return '評分 $rating';
  }

  @override
  String get local_folder_structure => '本地資料夾結構';

  @override
  String get local_folder => '本地資料夾';

  @override
  String get add_local_folder => '新增本地資料夾';

  @override
  String get rescan_local_folder => '立即重新掃描所有本地資料夾';

  @override
  String get default_download_destination => '預設下載位置';

  @override
  String get ask_download_destination => '每次下載前詢問位置';

  @override
  String get ask_download_destination_desc => '每次開始下載時選擇本地資料夾。';

  @override
  String get select_download_destination => '選擇下載位置';

  @override
  String get clear_local_library => '清空本地書庫';

  @override
  String get clear_local_library_desc => '從書庫中移除本地資料夾和壓縮包條目。';

  @override
  String get clear_local_library_msg => '這將從書庫中移除本地條目，不會刪除磁碟上的檔案。';

  @override
  String get custom => '自定義';

  @override
  String get no_local_folder_available_for_downloads => '沒有可用於下載的本地資料夾';

  @override
  String failed_to_create_cbz(Object error) {
    return '建立 CBZ 失敗：$error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return '讀取封面出錯：$error';
  }

  @override
  String error_reading_metadata(Object error) {
    return '讀取後設資料出錯：$error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return '儲存到書庫時出錯：$error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return '讀取章節封面出錯：$error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return '讀取歸檔封面出錯：$error';
  }

  @override
  String error_getting_local_library(Object error) {
    return '獲取本地書庫時出錯：$error';
  }

  @override
  String get export_metadata => '匯出後設資料';

  @override
  String get exported => '已匯出';

  @override
  String failed_to_export_metadata(Object error) {
    return '匯出後設資料失敗：$error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '有 $count 個章節無法自動編號，可能在閱讀器中缺失或順序錯亂。';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      '無法啟動 Cloudflare 驗證 Webview 服務。';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker 令牌已過期';
  }

  @override
  String get video_list_empty => '影片列表為空';

  @override
  String playback_speed_multiplier(Object value) {
    return '${value}x';
  }

  @override
  String could_not_launch_url(Object url) {
    return '無法開啟 $url';
  }

  @override
  String get text_size => '文字大小：';

  @override
  String get text_align => '文字對齊';

  @override
  String get line_height => '行高';

  @override
  String get show_scroll_percentage => '顯示滾動百分比';

  @override
  String get remove_extra_paragraph_spacing => '刪除額外的段落間距';

  @override
  String select_label_color(Object label) {
    return '選擇 $label 顏色';
  }

  @override
  String get default_user_agent => '預設使用者代理';

  @override
  String get forceLandscapeMode => '強制橫屏模式';

  @override
  String get forceLandscapeModeSubtitle => '強制播放器使用橫屏方向。';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNS提供商';

  @override
  String get tracked => '已追蹤';

  @override
  String get auth_unlock_msg => '驗證以解鎖應用';

  @override
  String get app_locked => '應用已鎖定';

  @override
  String get auth_to_continue => '驗證以繼續';

  @override
  String get authenticating => '正在驗證...';

  @override
  String get lock => '鎖定';

  @override
  String get unlock => '解鎖';

  @override
  String get security => '安全';

  @override
  String get auth_to_change_security_setting => '驗證以更改安全設定';

  @override
  String get app_lock => '應用鎖';

  @override
  String get require_biometric_or_device_credential => '需要生物識別或裝置憑證才能開啟應用';

  @override
  String get biometric_or_device_credential_not_available =>
      '此裝置暫不可使用生物識別或裝置密碼驗證';

  @override
  String get app_lock_description => '啟用應用鎖後，每次開啟應用或從後臺返回時都會要求您進行身份驗證。';

  @override
  String get checking_device_authentication => '正在檢查裝置驗證方式…';

  @override
  String get device_authentication_incomplete => '驗證未完成，設定保持不變。';

  @override
  String get keep_screen_on => '保持螢幕開啟';

  @override
  String get webtoon_side_padding => 'Webtoon側邊填充';

  @override
  String get show_page_gaps => '顯示頁面間隙';

  @override
  String get invert_colors => '反轉顏色';

  @override
  String get grayscale => '灰度';

  @override
  String get brightness => '亮度';

  @override
  String get contrast => '對比度';

  @override
  String get saturation => '飽和度';

  @override
  String get navigation_layout => '導航佈局';

  @override
  String get nav_layout_default => '預設';

  @override
  String get nav_layout_l_shaped => 'L形';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => '邊緣';

  @override
  String get nav_layout_right_and_left => '右和左';

  @override
  String get nav_layout_disabled => '已禁用';

  @override
  String get color_enhancements => '色彩增強';

  @override
  String get total => '總計';

  @override
  String get mean_per_title => '單個標題平均';

  @override
  String get completion_rate => '完成率';

  @override
  String get watching_time => '觀看時間';

  @override
  String get reading_time => '閱讀時間';

  @override
  String average_chapters_per_title(Object title) {
    return '每部$title的平均章節數';
  }

  @override
  String get read_percentage => '閱讀百分比';

  @override
  String get entries => '條目';

  @override
  String get android_proxy_server_mihon => 'Android 代理伺服器（Mihon）';

  @override
  String get android_proxy_server_mihon_description =>
      '下載並配置使用 Mihon 擴充套件所需的代理伺服器。';

  @override
  String get mihon_proxy_server => 'Mihon 代理伺服器';

  @override
  String get extension_server_intro_with_jre =>
      '在使用 Mihon 擴充套件前請先下載代理伺服器包。該包內含 JRE 和擴充套件伺服器 JAR。';

  @override
  String get extension_server_intro_ios =>
      '在使用 Mihon 擴充套件前請先下載代理伺服器 JAR。iOS 僅需擴充套件伺服器 JAR。';

  @override
  String get checking_files => '正在檢查檔案';

  @override
  String get files_installed => '檔案已安裝';

  @override
  String get files_missing => '檔案缺失';

  @override
  String get update_files => '更新檔案';

  @override
  String get up_to_date => '已是最新';

  @override
  String get choose_location => '選擇路徑';

  @override
  String get import_existing_jar => '匯入現有 JAR';

  @override
  String get detect_files_in_selected_folder => '在選定資料夾中檢測檔案';

  @override
  String get preparing_download => '正在準備下載...';

  @override
  String get app_install_location => '應用安裝路徑';

  @override
  String get install_location => '安裝位置';

  @override
  String get jre_executable => 'JRE 可執行檔案';

  @override
  String get extension_server_jar => '擴充套件伺服器 JAR';

  @override
  String get installed_version => '當前版本';

  @override
  String get latest_version => '最新版本';

  @override
  String get m_extension_server_description =>
      '當您需要獨立的 Android 裝置代理時，請使用 M-Extension-Server。在此設定代理地址，並從 GitHub 下載 APK。';

  @override
  String get set_proxy_address => '設定代理地址';

  @override
  String get no_newer_proxy_server_release_available => '沒有可用的新代理伺服器版本。';

  @override
  String get could_not_check_proxy_server_updates => '無法檢查代理伺服器更新。';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      '當前平臺沒有可用的擴充套件伺服器包。';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return '下載包失敗 ($statusCode)。';
  }

  @override
  String get downloaded_bundle_missing_expected_files => '下載的專案不包含預期檔案。';

  @override
  String get extension_server_files_ready => '擴充套件伺服器檔案已就緒。';

  @override
  String get ios_extension_server_import_hint =>
      '在 iOS 上，伺服器安裝在應用沙盒內。請使用“匯入現有 JAR”來匯入已下載的檔案。';

  @override
  String get select_extension_server_folder => '選擇擴充套件伺服器資料夾';

  @override
  String get selected_folder_does_not_exist => '選定資料夾不存在。';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      '在選定資料夾中未找到擴充套件伺服器檔案。';

  @override
  String get extension_server_files_linked => '擴充套件伺服器檔案已連結。';

  @override
  String get select_extension_server_jar => '選擇擴充套件伺服器 JAR';

  @override
  String get selected_file_could_not_be_accessed => '選定檔案無法訪問。';

  @override
  String get extension_server_jar_imported => '擴充套件伺服器 JAR 已匯入。';

  @override
  String get could_not_launch_apk_bridge_page => '無法啟動 M-Extension-Server 頁面。';

  @override
  String get proxy_server_ip_hint =>
      '伺服器 IP（例如 10.0.0.5 或 https://example.com）';

  @override
  String get not_configured => '未配置';

  @override
  String get zero_interpreter => 'Zero 直譯器';

  @override
  String get zero_interpreter_description => '自動或手動控制 Zero 直譯器服務。';

  @override
  String get start_server_on_launch => '啟動時開啟服務';

  @override
  String get runtime_status => '執行狀態';

  @override
  String get running => '執行中';

  @override
  String get stopped => '已停止';

  @override
  String get start => '啟動';

  @override
  String get stop => '停止';

  @override
  String get webview => 'Webview';

  @override
  String get tts => '文字轉語音';

  @override
  String get tts_speed => '速度';

  @override
  String get tts_pitch => '音調';

  @override
  String get tts_language => '語言';

  @override
  String get tts_voice => '語音';

  @override
  String get tts_stop => '停止';

  @override
  String get tts_play => '播放';

  @override
  String get tts_pause => '暫停';

  @override
  String get tts_previous => '上一段';

  @override
  String get tts_next => '下一段';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return '第$current段，共$total段';
  }

  @override
  String get tts_settings => 'TTS設定';

  @override
  String get tts_default => '預設';

  @override
  String get webtoon_disable_zoom_out => 'Webtoon禁用縮小';

  @override
  String get webtoon_double_tap_zoom_enabled => 'Webtoon雙擊縮放';

  @override
  String get navigate_to_pan => '導航前移動已放大影象';

  @override
  String get navigate_to_pan_subtitle => '翻頁前先移動放大的影象';

  @override
  String get split_wide_pages => '拆分雙頁';

  @override
  String get dual_page_invert => '反轉拆分的半頁';

  @override
  String get dual_page_rotate_to_fit => '旋轉以適應';

  @override
  String get dual_page_rotate_to_fit_invert => '反轉旋轉方向';

  @override
  String get double_page_single_first_page => '首頁單頁顯示';

  @override
  String get double_page_single_first_page_subtitle => '在雙頁模式下單頁顯示第一頁（封面）';

  @override
  String get double_page_auto => '自動雙頁';

  @override
  String get double_page_auto_subtitle => '橫屏時自動切換到雙頁模式';

  @override
  String get landscape_zoom => '橫屏自動縮放';

  @override
  String get zoom_start_position => '縮放起始位置';

  @override
  String get zoom_start_left => '左';

  @override
  String get zoom_start_right => '右';

  @override
  String get zoom_start_center => '中';

  @override
  String get automatic_background => '自動背景';

  @override
  String get tapping_inversion => '點選反轉';

  @override
  String get tapping_inversion_none => '無';

  @override
  String get tapping_inversion_horizontal => '水平';

  @override
  String get tapping_inversion_vertical => '垂直';

  @override
  String get tapping_inversion_both => '兩者';

  @override
  String get flash_on_page_change => '翻頁時閃爍';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED 防燒屏輔助';

  @override
  String get flash_color => '閃爍顏色';

  @override
  String get flash_color_black => '黑色';

  @override
  String get flash_color_white => '白色';

  @override
  String get flash_color_white_black => '白與黑';

  @override
  String get flash_interval_label => '閃爍間隔';

  @override
  String flash_interval_value(String n) {
    return '$n頁';
  }

  @override
  String flash_interval(String n) {
    return '閃爍間隔：$n頁';
  }

  @override
  String get flash_duration_label => '閃爍持續時間';

  @override
  String flash_duration_value(String n) {
    return '$n毫秒';
  }

  @override
  String flash_duration(String n) {
    return '閃爍持續時間：$n毫秒';
  }

  @override
  String get show_navigation_overlay_on_start => '啟動時顯示導航浮層';

  @override
  String get reader_hide_threshold => '隱藏閱讀器介面的閾值';

  @override
  String get reader_hide_threshold_highest => '最高 (5 px)';

  @override
  String get reader_hide_threshold_high => '高 (13 px)';

  @override
  String get reader_hide_threshold_low => '低 (31 px)';

  @override
  String get reader_hide_threshold_lowest => '最低 (47 px)';

  @override
  String get error_no_pages_available => '錯誤：無可用頁面';

  @override
  String get app_ui_scale => '介面縮放';

  @override
  String get app_ui_scale_subtitle => '根據你的螢幕和觀看距離，使介面更大或更小。';

  @override
  String get allow_concurrent_downloads => '允許併發下載';

  @override
  String get allow_concurrent_downloads_subtitle =>
      '同時從不同來源下載。單個來源仍然一次下載一個章節，因此不會過載。關閉後，可在任何地方一次下載一個。';

  @override
  String get download_delay => '下載延遲';

  @override
  String get download_delay_subtitle => '關閉。在章節之間新增隨機抖動的等待，以便更溫柔地對待來源。';

  @override
  String get save_search => '儲存搜尋';

  @override
  String get saved_searches => '已儲存的搜尋';

  @override
  String get enter_search_to_save_first => '先輸入搜尋進行儲存';

  @override
  String get no_saved_searches => '此來源還沒有儲存的搜尋。\n執行搜尋，然後選擇\"儲存搜尋\"。';

  @override
  String get source => '來源';

  @override
  String get something_went_wrong => '出錯了';

  @override
  String get startup_failed => 'NodeLane漫譯 無法完成啟動';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個圖源無結果',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => '如何匯入此備份？';

  @override
  String get import_mode_message => '選擇將此備份合併到當前書庫，還是完全替換當前書庫。';

  @override
  String get import_mode_keep_existing => '合併';

  @override
  String get import_mode_keep_existing_subtitle => '新增新條目並更新匹配條目。不會刪除現有內容。';

  @override
  String get import_mode_replace => '替換';

  @override
  String get import_mode_replace_subtitle => '清空當前書庫並完全替換為備份內容。';

  @override
  String get replace_summary_title => '準備替換書庫';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return '這將刪除當前的所有條目（$currentCount 項），並替換為備份中的 $backupCount 項。';
  }

  @override
  String get replace_summary_confirm => '替換';

  @override
  String replace_result_message(Object count) {
    return '已將書庫替換為備份中的 $count 個條目。';
  }

  @override
  String get category_conflict_title => '發現已有分類';

  @override
  String get category_conflict_message => '備份中包含書庫中已存在的分類。';

  @override
  String get category_conflict_keep => '保留 — 合併到已有分類';

  @override
  String get category_conflict_delete => '刪除 — 歸為未分類';

  @override
  String get source_conflict_title => '未找到圖源';

  @override
  String get source_conflict_message => '備份中的部分圖源未安裝相應擴充套件。';

  @override
  String get source_conflict_keep => '保留原名';

  @override
  String get import_summary_title => '準備匯入';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '將匯入 $newSeries 個新條目，更新 $updatedSeries 個已有條目，並新增 $newChapters 個章節。';
  }

  @override
  String get import_summary_confirm => '匯入';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '已匯入 $newSeries 個新條目，更新 $updatedSeries 個條目，新增 $newChapters 個章節。';
  }

  @override
  String get roll_back => '回滾';

  @override
  String get roll_back_confirm_message => '將書庫恢復到本次更改前的安全快照。';

  @override
  String get roll_back_done => '已回滾至更改前的快照。';

  @override
  String get restoring_backup => '正在恢復書庫…';

  @override
  String get roll_back_last_change => '回滾上次更改';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return '快照時間：$date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '有 $count 個最近更改可供回滾';
  }

  @override
  String get delete_source_title => '刪除圖源及其漫畫';

  @override
  String get delete_source_subtitle => '從書庫中刪除指定圖源的所有內容（含章節、下載和歷史）。';

  @override
  String get delete_source_pick_title => '選擇要刪除的圖源';

  @override
  String get delete_source_empty => '書庫中沒有找到圖源。';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '刪除 $sourceName？';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return '將永久刪除 $mangaCount 部漫畫、$chapterCount 個章節、$historyCount 條歷史記錄和 $updateCount 條更新記錄。追蹤關聯將保留。除回滾外，此操作無法撤銷。';
  }

  @override
  String get delete_source_also_remove_extension => '同時解除安裝對應擴充套件';

  @override
  String get delete_source_keep_history => '保留閱讀歷史';

  @override
  String get delete_source_keep_downloads => '保留下載記錄';

  @override
  String get delete_source_button => '刪除';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '已從 $sourceName 中刪除 $mangaCount 部漫畫。';
  }

  @override
  String get merge_manga_title => '合併重複漫畫';

  @override
  String get merge_manga_subtitle => '查詢同圖源下標題相同的漫畫並進行合併。';

  @override
  String get merge_manga_none_found => '未找到重複漫畫。';

  @override
  String get merge_manga_pick_title => '可能重複的漫畫';

  @override
  String get merge_manga_choose_primary_title => '要合併到哪一部漫畫？';

  @override
  String get merge_manga_choose_primary_message => '其他條目的章節、歷史和追蹤將合併到所選項中。';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 章節',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => '合併';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '已將 $count 部重複漫畫合併到 $mangaName。';
  }

  @override
  String get merge_preview_title => '確認合併';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '在其他條目中共找到 $totalChapters 個章節。其中 $duplicateChapters 個為重複章節，將保留有閱讀進度的副本並移除其餘重複項；將新增 $keptChapters 個章節。同時將移除 $duplicateTracks 條重複的追蹤關聯。';
  }

  @override
  String get memory_overlay => '顯示記憶體佔用';

  @override
  String get memory_overlay_subtitle =>
      '實時顯示應用佔用的記憶體。可在滾動書架或閱讀章節時實時觀察裝置上的記憶體變化。';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => '錯誤報告';

  @override
  String get error_reports_subtitle => '應用捕獲的錯誤及反饋入口';

  @override
  String get error_reports_empty => '執行正常，無錯誤記錄。';

  @override
  String get error_reports_likely_cause => '可能原因';

  @override
  String get error_reports_report => '在 GitHub 上反饋';

  @override
  String get error_reports_banner => 'NodeLane漫譯 遇到了一個錯誤';

  @override
  String get error_reports_banner_action => '檢視';

  @override
  String get error_reports_copy => '複製';

  @override
  String get error_reports_copied => '已複製到剪貼簿';

  @override
  String get error_reports_clear => '清除';

  @override
  String get error_reports_extension_failure =>
      '此錯誤來自擴充套件外掛，而非 NodeLane漫譯 本身。擴充套件由外掛倉庫的維護者編寫和維護，因此需要在外掛倉庫中修復。請向他們提供外掛名稱和當時正在開啟的內容。';

  @override
  String get error_reports_already_reported => '已報告';

  @override
  String get error_reports_expected_failure =>
      '這通常是來源網站或網路問題，而非應用本身的問題（如連結已失效、伺服器宕機或網路連線中斷）。僅當在其他地方正常工作的來源上持續出現此問題時才有必要報告。';

  @override
  String get share_unavailable_copied => '此平臺不支援分享，已複製到剪貼簿。';

  @override
  String get onboarding_title => '歡迎使用 NodeLane漫譯';

  @override
  String get onboarding_libraries_body => '選擇您要閱讀和觀看的內容型別。';

  @override
  String get onboarding_nav_title => '您的書庫';

  @override
  String get onboarding_nav_body => '可以為每種型別設定獨立標籤頁，或合併在一個“書庫”標籤頁中。';

  @override
  String get onboarding_nav_split => '獨立標籤頁';

  @override
  String get onboarding_nav_merged => '統一書庫標籤頁';

  @override
  String get onboarding_nav_inside => '點選“書庫”可在各型別間切換';

  @override
  String get onboarding_next => '下一步';

  @override
  String get onboarding_restore => '恢復備份';

  @override
  String get onboarding_or_local => '或使用現有本地檔案';

  @override
  String get onboarding_local_folder => '新增資料夾';

  @override
  String onboarding_local_existing(Object count) {
    return '已設定 $count 個資料夾';
  }

  @override
  String get onboarding_local_any_type => '支援漫畫、動漫與輕小說。';

  @override
  String get onboarding_local_scanning => '正在掃描資料夾';

  @override
  String onboarding_local_found(Object count) {
    return '找到 $count 個作品';
  }

  @override
  String get onboarding_local_remove => '移除該資料夾';

  @override
  String get onboarding_local_in_downloads => '這是應用的下載資料夾。';

  @override
  String get onboarding_local_empty => '未找到內容。請選擇父級資料夾。';

  @override
  String get onboarding_repo_failed => '無法讀取該倉庫。';

  @override
  String get onboarding_repo_title => '新增圖源';

  @override
  String get onboarding_body => '新增倉庫即可瀏覽和安裝豐富的擴充套件外掛。';

  @override
  String get onboarding_add => '新增倉庫';

  @override
  String get onboarding_skip => '暫時跳過';

  @override
  String get onboarding_continue => '繼續';

  @override
  String get onboarding_later => '您可以稍後在“設定 > 瀏覽”中新增。';

  @override
  String get onboarding_replay => '顯示歡迎介面';

  @override
  String get onboarding_replay_subtitle => '重新開啟首次執行的引導設定介面。';

  @override
  String get missing_source_check_title => '檢查缺失圖源';

  @override
  String get missing_source_check_subtitle => '查詢未安裝對應擴充套件的書庫條目。';

  @override
  String get missing_source_check_none_found => '書庫中所有條目的圖源均已安裝。';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '缺少 $count 個圖源',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return '未安裝任何 $itemType 來源。';
  }

  @override
  String get global_search_no_sources_hint => '請在“瀏覽”中新增倉庫並安裝相應的擴充套件外掛。';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個來源',
    );
    return '您有 $_temp0，但僅會搜尋已固定的來源。';
  }

  @override
  String get global_search_only_pinned_hint => '請固定某個來源，或在瀏覽設定中關閉“僅包含固定的來源”。';

  @override
  String get global_search_all_nsfw => '該分類下的所有來源均被標記為 NSFW 並已被隱藏。';

  @override
  String get global_search_all_nsfw_hint => '請在瀏覽設定中開啟 NSFW 來源後再進行搜尋。';

  @override
  String get missing_source_check_result_message =>
      '這些條目關聯的圖源未安裝。點選可進行遷移或安裝對應擴充套件。';

  @override
  String get related_titles => '相關作品';

  @override
  String get related_none => '未找到該作品的相關作品。';

  @override
  String get relation_adaptation => '改編';

  @override
  String get relation_sequel => '續作';

  @override
  String get relation_prequel => '前傳';

  @override
  String get relation_parent => '原作/主線';

  @override
  String get relation_side_story => '外傳';

  @override
  String get relation_spin_off => '衍生作';

  @override
  String get relation_alternative => '平行/替代版本';

  @override
  String get auto_library_update => '書架自動更新';

  @override
  String get auto_library_update_subtitle => '在應用啟動時檢查書架中所有作品的最新章節。';

  @override
  String get auto_library_update_never => '從不';

  @override
  String get auto_library_update_12_hours => '每 12 小時';

  @override
  String get auto_library_update_daily => '每天';

  @override
  String get auto_library_update_2_days => '每 2 天';

  @override
  String get auto_library_update_weekly => '每週';

  @override
  String get auto_library_update_wifi_only => '僅限 Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle => '使用移動資料時跳過計劃更新。';

  @override
  String get padding => '內邊距';

  @override
  String get page_mode => '翻頁模式';

  @override
  String get single_page => '單頁';

  @override
  String get double_page => '雙頁';

  @override
  String get speed => '速度';

  @override
  String get theme_dark => '暗色';

  @override
  String get theme_light => '淺色';

  @override
  String get theme_black => '純黑';

  @override
  String get theme_sepia => '復古';

  @override
  String get decrease => '減少';

  @override
  String get increase => '增加';

  @override
  String get chapter_swipe_actions => '章節滑動操作';

  @override
  String get chapter_swipe_start => '向右滑動';

  @override
  String get chapter_swipe_end => '向左滑動';

  @override
  String get chapter_swipe_toggle_bookmark => '切換書籤';

  @override
  String get chapter_swipe_toggle_read => '切換已讀狀態';

  @override
  String get chapter_swipe_download => '下載';

  @override
  String get chapter_swipe_disabled => '已禁用';

  @override
  String get update_errors => '更新錯誤';

  @override
  String get no_update_errors => '沒有更新錯誤';

  @override
  String get clear_all => '全部清除';

  @override
  String get dismiss => '忽略';

  @override
  String get previous_episode => '上一集';

  @override
  String get clear_logs => '清空日誌';

  @override
  String get bold => '粗體';

  @override
  String get italic => '斜體';

  @override
  String get color_yellow => '黃色';

  @override
  String get color_cyan => '青色';

  @override
  String get color_green => '綠色';

  @override
  String get color_orange => '橙色';

  @override
  String get continue_watching => '繼續觀看';

  @override
  String get search_your_anime => '搜尋你的動畫';

  @override
  String get category => '分類';

  @override
  String get hidden_categories => '隱藏分類';

  @override
  String get new_category => '新建分類';

  @override
  String get local => '本地';

  @override
  String get tv_home_rows => '內容行';

  @override
  String get genre_rows => '題材行';

  @override
  String get share_backup_file => '分享 NodeLane Comics 備份檔案';

  @override
  String get close => '關閉';

  @override
  String get migrate_source => '遷移來源';

  @override
  String get cloudflare_bypass_proxy => 'Cloudflare 驗證代理';

  @override
  String get custom_doh_url => '自定義 DoH 地址';

  @override
  String get custom_doh_url_helper => '須為 HTTPS 的 DoH（JSON）服務地址';

  @override
  String get anime_only_tv_layout => '電視僅動畫布局';

  @override
  String get anime_only_beta => '僅限動畫（測試版）';

  @override
  String get tv_home_beta => '電視首頁（測試版）';

  @override
  String get tv_player_beta => '電視播放器（測試版）';

  @override
  String get network_settings => '網路';

  @override
  String get reader_page_layout => '頁面佈局';

  @override
  String get reader_continuous_options => '連續閱讀';

  @override
  String get reader_default_mode_hint => '預設閱讀模式用於尚未在閱讀時單獨設定模式的漫畫。';

  @override
  String get extension_service => '擴充套件服務';

  @override
  String get extension_service_description => '管理擴充套件執行服務與代理地址。';

  @override
  String get proxy_address => '代理地址';

  @override
  String get checking_runtime_status => '正在檢查狀態…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds 秒 + 隨機延遲';
  }

  @override
  String download_queue_count(int count) {
    return '$count 個章節';
  }

  @override
  String get download_queue_empty_hint => '從作品的章節列表新增下載';

  @override
  String get download_queue_order_hint => '拖動把手調整順序';

  @override
  String get download_queue_empty => '暫無下載任務';

  @override
  String get download_queue_actions => '下載操作';

  @override
  String get download_queue_cancel_chapter => '取消本章下載';

  @override
  String get download_queue_cancel_series => '取消本作品全部下載';

  @override
  String get download_queue_start => '開始下載';

  @override
  String get download_queue_retry => '重試下載';

  @override
  String get download_queue_active => '下載中';

  @override
  String get download_queue_waiting => '等待下載';

  @override
  String get download_queue_failed => '下載失敗';

  @override
  String get cf_proxy_helper => 'FlareSolverr / Byparr 服務地址，留空關閉。';

  @override
  String get mobile_navigation_description =>
      '拖動調整順序。漫畫、動畫和小說共用書架入口，首個顯示專案為啟動頁。瀏覽與更多始終顯示，多餘入口收進更多。';

  @override
  String get text_align_justify => '兩端對齊';

  @override
  String get novel_session_modes_hint => '閱讀模式與單／雙頁在開啟小說後設定。';

  @override
  String get tts_languages_failed => '無法讀取語音引擎的語言列表。';

  @override
  String get tts_languages_empty => '語音引擎沒有返回可選語言，已保留當前選擇。';

  @override
  String get tts_language_unavailable => '裝置當前的語言列表中沒有這個已儲存的語言。';

  @override
  String get tts_apply_failed => '未能向語音引擎應用此設定，可以重試。';

  @override
  String get player_controls => '控制';

  @override
  String get audio_channel_auto => '自動';

  @override
  String get audio_channel_auto_safe => '自動（安全模式）';

  @override
  String get audio_channel_mono => '單聲道';

  @override
  String get audio_channel_stereo => '立體聲';

  @override
  String get audio_channel_reverse_stereo => '交換左右聲道';

  @override
  String get mpv_bundled_config_hint => '恢復應用內建的配置、指令碼和著色器。同名檔案會被覆蓋。';

  @override
  String get mpv_restore_bundled => '恢復內建配置';

  @override
  String get mpv_restore_confirm => '恢復內建 MPV 配置？現有配置、指令碼和著色器的同名檔案會被覆蓋，其他檔案保留。';

  @override
  String get player_operation_incomplete => '未能完成操作，請檢查檔案訪問許可權後重試。';

  @override
  String get custom_buttons_empty_hint => '新增播放器按鈕，設定名稱和點選時執行的操作。';

  @override
  String get custom_button_primary => '預設按鈕';

  @override
  String get show_password => '顯示密碼';

  @override
  String get hide_password => '隱藏密碼';

  @override
  String get tracking_accounts_empty => '先在追蹤設定中登入服務，再管理其中的條目。';

  @override
  String get tracking_entries_empty => '此媒體型別暫無追蹤條目，可從作品詳情頁新增追蹤。';

  @override
  String get change_tracking_match => '更換匹配作品';

  @override
  String get remove_tracking => '移除追蹤';

  @override
  String remove_tracking_confirm(String title) {
    return '移除“$title”的追蹤關聯？追蹤服務中的條目會保留。';
  }

  @override
  String get tracking_refresh_required => '未能確認追蹤狀態，請重新整理後再進行修改。';

  @override
  String get tracking_entry_unlinked => '此記錄尚未關聯本地作品，無法在這裡編輯。';

  @override
  String get backup_selection_shared => '選擇會立即儲存，也用於自動備份。';

  @override
  String get library_snapshot_history => '恢復歷史快照';

  @override
  String get library_snapshot_empty => '暫無可恢復的安全快照。';

  @override
  String get library_snapshot_restore_message =>
      '當前資料將替換為此快照，快照後的更改會丟失。已刪除的下載檔案無法恢復。成功後會清除現有安全快照。';

  @override
  String get library_maintenance_working => '正在整理書庫…';

  @override
  String get library_safety_snapshot_note => '操作前會儲存安全快照。快照不包含下載檔案。';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return '此圖源包含 $mangaCount 個條目、$chapterCount 個章節、$historyCount 條歷史與 $updateCount 條更新。下方選項決定保留哪些內容。';
  }

  @override
  String get library_delete_pick_message => '選擇圖源，檢視其內容和刪除選項。';

  @override
  String get mobile_categories_hint => '拖動調整順序。開啟分類可重新命名，或設定顯示與更新。';

  @override
  String get mobile_category_visible => '在書架中顯示';

  @override
  String get mobile_category_hidden => '已從書架隱藏';

  @override
  String get mobile_category_updates => '參與書庫更新';

  @override
  String get statistics_watched => '已觀看';

  @override
  String get calendar_month => '月';

  @override
  String get calendar_two_weeks => '兩週';

  @override
  String get calendar_week => '周';

  @override
  String get calendar_show_all_dates => '檢視全部日期';

  @override
  String get update_check_no_result => '暫未找到可安裝更新，可稍後再試。';

  @override
  String get release_notes => '更新說明';

  @override
  String get no_release_notes => '未提供更新說明。';

  @override
  String get downloading_update => '正在下載更新…';

  @override
  String get preparing_installation => '正在準備安裝…';

  @override
  String get onboarding_mobile_libraries_body => '選擇閱讀內容，之後也可調整。';

  @override
  String get onboarding_content_title => '開始閱讀';

  @override
  String get onboarding_mobile_sources_body => '選擇一種方式，也可以稍後新增。';

  @override
  String onboarding_step_count(int step, int total) {
    return '第 $step 步，共 $total 步';
  }

  @override
  String global_search_results_for(String query) {
    return '“$query”的搜尋結果';
  }

  @override
  String global_search_scope(String type, int count) {
    return '$type · $count 個來源';
  }

  @override
  String get migration_search_prompt => '搜尋目標作品。';

  @override
  String get migration_original_item => '當前作品';

  @override
  String get migration_target_item => '目標作品';

  @override
  String get migration_partial_failure => '操作未完成，可能已儲存部分更改。請返回書架核對當前條目後再繼續。';

  @override
  String get migration_no_categories => '暫無分類，可直接新增到未分類書架。';

  @override
  String get mass_migration_select_source => '選擇當前來源';

  @override
  String get mass_migration_select_all => '全選';

  @override
  String get mass_migration_deselect_all => '取消全選';

  @override
  String get mass_migration_needs_review => '部分作品需要核對';

  @override
  String get bookshelf_actions => '書架操作';

  @override
  String get bookshelf_ignore_filters => '搜尋時忽略篩選';

  @override
  String get bookshelf_ignore_filters_hint => '搜尋當前分類中的全部作品，包括被篩選條件隱藏的作品。';

  @override
  String get bookshelf_stop_update => '停止書架更新';

  @override
  String bookshelf_selected_count(int count) {
    return '已選擇 $count 項';
  }

  @override
  String get bookshelf_remove_library => '從書架移除';

  @override
  String get bookshelf_remove_library_hint => '移除收藏記錄。本地匯入作品也會移除書架及閱讀記錄。';

  @override
  String get bookshelf_remove_downloads => '刪除下載檔案';

  @override
  String get bookshelf_remove_downloads_hint => '刪除下載檔案，保留作品資訊。';

  @override
  String get bookshelf_remove_local_files_hint =>
      '也會刪除所選本地匯入檔案，並移除對應書架記錄。這些檔案無法在此恢復。';

  @override
  String get bookshelf_remove_incomplete =>
      '操作未完成，部分作品或檔案可能已處理。請關閉後先核對書架和下載記錄，再繼續操作。';

  @override
  String get bookshelf_processing => '正在處理…';

  @override
  String get bookshelf_mark_read => '標為已讀';

  @override
  String get bookshelf_mark_unread => '標為未讀';

  @override
  String get bookshelf_select_all => '全選';

  @override
  String get bookshelf_invert_selection => '反選';

  @override
  String get bookshelf_settings => '書架設定';

  @override
  String get bookshelf_settings_live => '篩選、排序和顯示更改即時生效。';

  @override
  String get bookshelf_filter_any => '不限';

  @override
  String get bookshelf_filter_include => '包含';

  @override
  String get bookshelf_filter_exclude => '排除';

  @override
  String get bookshelf_all_sources => '全部來源';

  @override
  String bookshelf_sources_selected(int count) {
    return '已選 $count 個來源';
  }

  @override
  String get bookshelf_sort_ascending => '升序';

  @override
  String get bookshelf_sort_descending => '降序';

  @override
  String get bookshelf_layout => '書架佈局';

  @override
  String get bookshelf_sources_hint => '不選表示全部來源；點按“篩選”後生效。';

  @override
  String get bookshelf_choose_files => '選擇檔案';

  @override
  String get bookshelf_import_wait => '請在檔案選擇器中選擇檔案，並等待匯入完成。';

  @override
  String get bookshelf_import_incomplete =>
      '匯入未完成，部分檔案可能已加入書架。請關閉後先核對，再決定是否重新匯入。';

  @override
  String get bookshelf_categories_replace => '所選分類將統一替換這些作品原來的分類。';

  @override
  String get bookshelf_categories_hint => '可多選分類；留空則不分配分類。';

  @override
  String get bookshelf_categories_hidden => '該作品已有的隱藏分類會保留。';

  @override
  String get bookshelf_categories_incomplete => '分類未儲存完成。請關閉後先核對書架，再繼續操作。';

  @override
  String get bookshelf_categories_none_visible => '沒有可選分類，可前往管理分類檢視。';

  @override
  String get bookshelf_manage_categories => '管理分類';

  @override
  String get manga_actions => '漫畫操作';

  @override
  String get manga_download_scope => '下載章節';

  @override
  String get manga_download_scope_hint => '按當前目錄篩選選擇章節，已下載的章節會跳過。';

  @override
  String get manga_download_scope_empty => '當前篩選下沒有章節。請關閉並調整目錄篩選。';

  @override
  String get manga_action_incomplete => '操作未完成。請先核對當前狀態，再決定是否重新操作。';

  @override
  String get chapter_settings => '章節設定';

  @override
  String get chapter_settings_live => '篩選與排序即時生效，僅用於當前漫畫。';

  @override
  String get chapter_scanlators_all => '全部顯示';

  @override
  String get chapter_scanlators_hint => '勾選要隱藏的翻譯組，點按“篩選”後生效。';

  @override
  String chapter_scanlators_hidden(int count) {
    return '已隱藏 $count 個翻譯組';
  }

  @override
  String chapter_selected_count(int count) {
    return '已選 $count 章';
  }

  @override
  String get chapter_add_bookmark => '新增書籤';

  @override
  String get chapter_remove_bookmark => '取消書籤';

  @override
  String get chapter_read_following => '下方已讀';

  @override
  String get chapter_delete_records => '刪除章節記錄';

  @override
  String get chapter_delete_local_hint => '移除所選章節與閱讀進度，保留原始壓縮包，並清理已有下載副本。';

  @override
  String get chapter_delete_last_hint => '所選章節是這部漫畫的全部目錄，刪除後也會從書架移除這部漫畫。';

  @override
  String get chapter_action_incomplete => '操作未完成，部分更改可能已儲存。請關閉後先核對章節與下載，再繼續操作。';

  @override
  String get reader_display_scope => '閱讀模式和手動單雙頁應用於當前漫畫；選擇後返回閱讀。';

  @override
  String get reader_display_single_only => '橫向連續閱讀僅使用單頁。';

  @override
  String get reader_display_manual_pages => '切換單雙頁會關閉所有漫畫的自動雙頁。';

  @override
  String get reader_display_crop_scope => '應用於所有漫畫。';

  @override
  String get reader_chapter_locate => '定位當前章節';

  @override
  String get reader_chapter_search => '搜尋章節或翻譯組';

  @override
  String get reader_chapter_scope => '沿用漫畫詳情的篩選和排序，書籤即時儲存。';

  @override
  String get reader_chapter_current_hidden => '正在閱讀的章節不在當前篩選後的目錄中。';

  @override
  String get reader_chapter_current => '正在閱讀';

  @override
  String get reader_chapter_read => '已讀';

  @override
  String get reader_chapter_bookmark_failed => '未能確認書籤儲存結果，請關閉目錄後核對。';

  @override
  String get reader_image_actions => '圖片操作';

  @override
  String get reader_image_original => '使用原始整頁圖片，不含翻譯、裁剪或閱讀濾鏡。';

  @override
  String get reader_image_save_ios => '儲存到當前應用儲存位置的 Pictures 資料夾。';

  @override
  String get reader_image_save_android =>
      '儲存到裝置的 Pictures/nodelane-comics 資料夾。';

  @override
  String get reader_image_share => '開啟系統分享面板。';

  @override
  String get reader_image_cover => '確認後修改這本漫畫的封面。';

  @override
  String get reader_image_cover_limit => '封面圖片需小於 5 MB，仍可儲存或分享。';

  @override
  String get reader_image_action_failed => '未能確認操作結果，請關閉選單後核對，再決定是否重試。';

  @override
  String get reader_settings_book_scope => '以下設定僅用於當前漫畫。';

  @override
  String get reader_settings_global_scope => '以下設定用於所有漫畫，即時儲存。';

  @override
  String get reader_filters => '影象濾鏡';

  @override
  String get reader_filter_scope => '用於所有漫畫，只改變閱讀畫面，不修改原始圖片。';

  @override
  String get reader_auto_scroll_pause => '開啟設定期間暫停滾動。';

  @override
  String get manga_synopsis => '簡介';

  @override
  String manga_author(String author) {
    return '作者：$author';
  }

  @override
  String get manga_continue_reading => '繼續閱讀';

  @override
  String get reader_settings_title => '閱讀設定';

  @override
  String get reader_picker_book_scope => '僅用於當前漫畫';

  @override
  String get reader_picker_global_scope => '應用於所有漫畫';

  @override
  String get reader_picker_apply_hint => '點選即儲存並返回上一層。';

  @override
  String get reader_scale_fit_screen_hint => '整頁適配螢幕';

  @override
  String get reader_scale_stretch_hint => '鋪滿閱讀區域';

  @override
  String get reader_scale_fit_width_hint => '以頁面寬度適配';

  @override
  String get reader_scale_fit_height_hint => '以頁面高度適配';

  @override
  String get source_filter_active => '已應用';

  @override
  String get source_filter_apply => '應用篩選';

  @override
  String get source_filter_scope => '篩選僅用於當前網站。';

  @override
  String get source_filter_apply_hint => '應用篩選後生效。';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': '題材',
      'author': '作者',
      'artist': '畫師',
      'title': '標題',
      'year': '年份',
      'tags': '標籤',
      'format': '形式',
      'publisher': '出版社',
      'relevance': '相關度',
      'rating': '評分',
      'views': '瀏覽量',
      'random': '隨機',
      'all': '全部',
      'none': '無',
      'action': '動作',
      'adventure': '冒險',
      'comedy': '喜劇',
      'drama': '劇情',
      'fantasy': '奇幻',
      'romance': '愛情',
      'science_fiction': '科幻',
      'slice_of_life': '日常',
      'mystery': '懸疑',
      'horror': '恐怖',
      'psychological': '心理',
      'historical': '歷史',
      'sports': '運動',
      'supernatural': '超自然',
      'school_life': '校園',
      'tragedy': '悲劇',
      'shounen': '少年',
      'shoujo': '少女',
      'seinen': '青年',
      'josei': '女性',
      'isekai': '異世界',
      'martial_arts': '武俠',
      'mecha': '機甲',
      'music': '音樂',
      'doujinshi': '同人',
      'trending': '熱門趨勢',
      'new': '新上架',
      'adult_content': '成人內容',
      'only': '僅顯示',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => '更多顯示選項';

  @override
  String get bookshelf_more_display_hint => '徽章、來源與分類';

  @override
  String get bookshelf_download_count => '下載數量';

  @override
  String get bookshelf_source_global_hint => '來源顯示沿用全域性設定。';

  @override
  String get bookshelf_select_entries => '選擇作品';

  @override
  String get bookshelf_search_options => '搜尋選項';

  @override
  String get bookshelf_empty_hint => '從來源收藏作品，或匯入本地檔案。';

  @override
  String get bookshelf_no_match_hint => '試試其他關鍵詞，或調整當前篩選。';

  @override
  String get bookshelf_clear_query => '清空關鍵詞';

  @override
  String get bookshelf_view_selection => '檢視所選作品';

  @override
  String get bookshelf_import_formats => '選擇本地檔案，將作品加入書架。';

  @override
  String get bookshelf_import_canceled_hint => '取消檔案選擇後，可繼續重新選擇。';

  @override
  String get bookshelf_browse_sources => '瀏覽來源';

  @override
  String get bookshelf_empty_title => '書架還是空的';

  @override
  String get bookshelf_no_match_title => '沒有匹配的作品';

  @override
  String get bookshelf_mark_watched => '標為已看';

  @override
  String get bookshelf_mark_unwatched => '標為未看';

  @override
  String get nodelane_account => 'NodeLane 賬號';

  @override
  String get nodelane_sign_in => '登入 NodeLane';

  @override
  String get nodelane_account_intro => '檢視賬號、訂閱和翻譯額度';

  @override
  String get nodelane_login_action => '前往登入';

  @override
  String get nodelane_login_browser => '透過系統瀏覽器登入後返回應用';

  @override
  String get nodelane_account_id => '賬號 ID';

  @override
  String get nodelane_account_init_error => '暫時無法讀取賬號，請重新啟動應用後再試。';

  @override
  String get nodelane_account_refresh_error => '暫時無法更新賬號資訊';

  @override
  String get nodelane_account_auth_error => '登入已過期，請重新登入';

  @override
  String get nodelane_account_unknown => '暫未讀取到訂閱資訊';

  @override
  String get nodelane_account_current => '當前訂閱';

  @override
  String get nodelane_account_free => '免費賬戶';

  @override
  String get nodelane_account_no_subscription => '暫無有效訂閱';

  @override
  String get nodelane_account_active => '生效中';

  @override
  String get nodelane_account_expired => '已到期';

  @override
  String get nodelane_account_expiry => '有效期至';

  @override
  String get nodelane_account_renewal => '續費方式';

  @override
  String get nodelane_renewal_auto => '自動續費';

  @override
  String get nodelane_renewal_manual => '手動續費';

  @override
  String get nodelane_renewal_stopped => '已停止自動續費';

  @override
  String get nodelane_renewal_gift => '贈送會員';

  @override
  String get nodelane_renewal_attention => '續費狀態需要核對，請到官網檢視';

  @override
  String get nodelane_next_billing => '下次扣款';

  @override
  String get nodelane_billing_unavailable => '續費資訊暫時無法讀取';

  @override
  String get nodelane_manage_account => '在官網管理';

  @override
  String get nodelane_view_plans => '檢視訂閱方案';

  @override
  String get nodelane_translation_quota => '翻譯額度';

  @override
  String get nodelane_quota_free => '免費額度';

  @override
  String get nodelane_quota_subscription => '訂閱額度';

  @override
  String get nodelane_quota_purchase => '購買額度';

  @override
  String get nodelane_quota_details => '檢視額度明細';

  @override
  String get nodelane_quota_expanded => '額度明細';

  @override
  String get nodelane_quota_unlimited => '不限量';

  @override
  String get nodelane_quota_not_subscribed => '未開通';

  @override
  String get nodelane_quota_unknown => '暫不可用';

  @override
  String get nodelane_quota_used => '已使用';

  @override
  String get nodelane_quota_reserved => '處理中';

  @override
  String get nodelane_quota_reset => '下次重置';

  @override
  String get nodelane_quota_expiry => '最近到期';

  @override
  String get nodelane_quota_no_expiry => '無到期時間';

  @override
  String get nodelane_quota_reservation_note => '處理中頁數已從可用額度扣除';

  @override
  String nodelane_quota_available(int count) {
    return '剩餘 $count 頁';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count 頁';
  }

  @override
  String get nodelane_sign_out => '退出登入';

  @override
  String get nodelane_sign_out_confirm => '退出後暫停本機官方翻譯，書架與閱讀記錄保留。';

  @override
  String get settings_search_hint => '搜尋設定';

  @override
  String get settings_frequent => '常用';

  @override
  String get settings_reading_translation => '閱讀與翻譯';

  @override
  String get settings_app_preferences => '應用偏好';

  @override
  String get settings_data_management => '資料與管理';

  @override
  String get settings_more_tools => '更多工具';

  @override
  String get settings_more_tools_hint => '分類、統計、日曆';

  @override
  String get settings_appearance_interface => '外觀與介面';

  @override
  String get settings_security_privacy => '安全與隱私';

  @override
  String get settings_source_preferences => '來源設定';

  @override
  String get settings_about_help => '關於與幫助';

  @override
  String get settings_storage_backup => '儲存與備份';

  @override
  String settings_pending_downloads(int count) {
    return '$count 項待下載';
  }

  @override
  String get settings_translation_language => '翻譯目標語言';

  @override
  String get settings_translation_scope => '用於閱讀器和網頁翻譯';

  @override
  String get settings_immediate_choice => '選擇後立即生效';

  @override
  String get settings_translation_init_error => '暫時無法讀取翻譯設定，請重新啟動應用後再試。';

  @override
  String get settings_local_cache => '本機快取';

  @override
  String get settings_chapter_cache => '章節與劇集快取';

  @override
  String get settings_cover_cache => '封面快取';

  @override
  String get settings_translation_cache => '譯圖快取';

  @override
  String get settings_translation_cache_hint => '保留翻譯記錄，需要時重新讀取譯圖';

  @override
  String get settings_cache_clear => '清理';

  @override
  String get settings_translation_cache_done => '譯圖快取已清理，翻譯記錄已保留';

  @override
  String settings_cache_confirmation(String name) {
    return '清理 $name？需要時會重新讀取，不會移除書架作品。';
  }

  @override
  String get settings_advanced_options => '高階選項';

  @override
  String get settings_manga_reader => '漫畫閱讀';

  @override
  String get settings_novel_reader => '小說閱讀';

  @override
  String get settings_downloads => '下載設定';

  @override
  String get onboarding_welcome => '歡迎使用';

  @override
  String get onboarding_reading_content => '閱讀內容';

  @override
  String get onboarding_choose_one => '至少選擇一種';

  @override
  String get onboarding_restore_hint => '從已有備份恢復書庫';

  @override
  String get onboarding_browse_hint => '從支援的網站找到作品';

  @override
  String get onboarding_import_folder => '匯入本地資料夾';

  @override
  String get onboarding_import_folder_hint => '讀取裝置中的漫畫、小說和動畫';

  @override
  String get onboarding_third_party => '新增第三方來源庫';

  @override
  String get onboarding_third_party_hint => '已有來源庫地址時使用';

  @override
  String get onboarding_repository_hint => '輸入來源庫提供的地址。';

  @override
  String get onboarding_repository_address => '地址';

  @override
  String get onboarding_repository_address_hint => '輸入來源庫地址';

  @override
  String get onboarding_add_repository => '新增來源庫';

  @override
  String get onboarding_start => '開始使用';

  @override
  String get onboarding_open_library => '進入書架';

  @override
  String get onboarding_view_imports => '檢視匯入內容';

  @override
  String get onboarding_view_folders => '檢視資料夾';

  @override
  String get notice_backup_created => '備份已建立';

  @override
  String get notice_backup_ready => '可將備份檔案儲存到其他位置。';

  @override
  String get notice_backup_restored => '備份已恢復';

  @override
  String get notice_backup_unsupported => '不支援此備份格式。';

  @override
  String get notice_verification_required => '網站需要驗證';

  @override
  String get notice_verification_hint => '完成驗證後可繼續訪問。';

  @override
  String get notice_verify => '前往驗證';

  @override
  String get notice_action_incomplete => '操作未完成，請先核對結果再決定是否重試。';

  @override
  String get notice_library_updating => '正在更新書庫';

  @override
  String notice_library_progress(Object current, Object total) {
    return '已檢查 $current / $total 部作品';
  }

  @override
  String get notice_library_failed => '部分作品更新失敗';

  @override
  String get notice_import_completed => '匯入完成';

  @override
  String get notice_operation_incomplete => '操作未完成';

  @override
  String get subtitle_service => '線上字幕服務';

  @override
  String get subtitle_service_mode => '字幕來源';

  @override
  String get subtitle_service_disabled => '關閉並清除已存憑據';

  @override
  String get subtitle_personal_key => '我的 Wyzie Key';

  @override
  String get subtitle_custom_service => '我的字幕服務';

  @override
  String get subtitle_key => 'Wyzie API Key';

  @override
  String get subtitle_key_hint => '填寫你自己的 Wyzie Key，僅儲存在此裝置上，不隨應用備份匯出。';

  @override
  String get subtitle_get_key => '獲取個人 Key';

  @override
  String get subtitle_service_address => '字幕搜尋地址';

  @override
  String get subtitle_service_token => '服務訪問令牌（選填）';

  @override
  String get subtitle_custom_hint =>
      '填寫相容 Wyzie 的完整 HTTPS 搜尋地址，包含路徑（如 /search）。服務需要鑑權時，再填寫它的訪問令牌。';

  @override
  String get subtitle_service_off_hint => '線上字幕搜尋已關閉，仍可使用內嵌字幕、片源字幕和本地字幕。';

  @override
  String get subtitle_setup_required => '請先配置字幕服務，再搜尋字幕。';

  @override
  String get subtitle_invalid_key => '請填寫不含空白字元的 Key。';

  @override
  String get subtitle_invalid_address => '請填寫完整 HTTPS 地址，不包含查詢引數、片段或內嵌憑據。';

  @override
  String get subtitle_invalid_token => '訪問令牌不能包含空白字元。';

  @override
  String get subtitle_storage_failed => '字幕配置讀取或儲存失敗，請重試。';

  @override
  String get subtitle_auth_failed => '字幕服務拒絕訪問，請檢查 Key 或服務令牌。';

  @override
  String get subtitle_quota_exhausted => '字幕服務額度已用完，請到對應服務檢視個人賬戶。';

  @override
  String get subtitle_network_failed => '暫時無法連線字幕服務，請重試。';

  @override
  String get subtitle_response_invalid => '字幕服務返回了不支援的響應或檔案。';

  @override
  String get detail_loading_chapters => '載入章節…';

  @override
  String get reader_opening_chapter => '正在開啟章節';

  @override
  String get reader_open_chapter => '開啟章節';

  @override
  String get reader_loading_pages => '正在獲取本話圖片…';

  @override
  String get reader_loading_pages_hint => '載入完成後自動進入閱讀';

  @override
  String get reader_loading_failed => '暫時無法載入';

  @override
  String get reader_loading_retry_hint => '請檢查網路後重試';

  @override
  String get reader_no_pages => '本話暫無可閱讀圖片';

  @override
  String get reader_loading_previous => '正在載入上一章…';

  @override
  String get reader_previous_failed => '上一章暫時無法載入';

  @override
  String get reader_reached_start => '已到第一章';

  @override
  String get reader_loading_next => '正在載入下一章…';

  @override
  String get reader_next_failed => '下一章暫時無法載入';

  @override
  String get reader_image_loading => '正在載入圖片…';

  @override
  String get reader_image_failure_hint => '其他頁面仍可繼續閱讀';

  @override
  String get comic_paged => '翻頁';

  @override
  String get comic_scroll => '連續下滑';

  @override
  String get comic_book_scope => '僅本書生效 · 修改即儲存';

  @override
  String get comic_defaults_title => '預設與操作習慣';

  @override
  String get comic_defaults_hint => '預設值用於尚未單獨設定的書籍選項。';

  @override
  String get comic_habits_hint => '以下習慣對所有漫畫生效。';

  @override
  String get comic_turn => '滑向下一頁';

  @override
  String get comic_left => '向左';

  @override
  String get comic_right => '向右';

  @override
  String get comic_up => '向上';

  @override
  String get comic_fit => '畫面適配';

  @override
  String get comic_fit_contain => '完整顯示';

  @override
  String get comic_fit_width => '適合寬度';

  @override
  String get comic_fit_height => '適合高度';

  @override
  String get comic_layout => '頁面排布';

  @override
  String get comic_auto => '自動';

  @override
  String get comic_layout_hint => '自動根據可用寬度顯示單頁或雙頁。';

  @override
  String get comic_width => '內容寬度';

  @override
  String get comic_full => '鋪滿';

  @override
  String get comic_comfortable => '舒適';

  @override
  String get comic_narrow => '收窄';

  @override
  String get comic_gap => '頁間留白';

  @override
  String get comic_no_gap => '無縫';

  @override
  String get comic_small_gap => '少量';

  @override
  String get comic_image_title => '畫面微調';

  @override
  String get comic_image_hint => '裁邊與色調僅作用於本書。';

  @override
  String get comic_wide => '橫幅頁處理';

  @override
  String get comic_intact => '完整保留';

  @override
  String get comic_split => '拆為兩頁';

  @override
  String get comic_rotate => '旋轉適配';

  @override
  String get comic_wide_hint => '拆頁順序跟隨翻頁方向，僅用於單頁翻閱。';

  @override
  String get comic_cover => '每章首頁單獨顯示';

  @override
  String get comic_effects_reset => '重置畫面效果';

  @override
  String get comic_book_reset => '恢復本書預設';

  @override
  String get comic_book_reset_hint => '清除本書自定義閱讀設定，翻譯設定保持原樣。';

  @override
  String get comic_canvas => '閱讀背景';

  @override
  String get comic_system => '跟隨系統';

  @override
  String get comic_black => '純黑';

  @override
  String get comic_gray => '深灰';

  @override
  String get comic_paper => '紙白';

  @override
  String get comic_tap => '輕點翻頁';

  @override
  String get comic_tap_hint => '輕點兩側翻頁，中間顯示工具欄；下滑閱讀時輕點上、下方移動。';

  @override
  String get comic_scroll_start => '開始自動下滑';

  @override
  String get comic_scroll_pause => '暫停自動下滑';

  @override
  String get comic_scroll_speed => '下滑速度';

  @override
  String get comic_scroll_hint => '關閉面板後開始；離開應用會暫停。';

  @override
  String get comic_save_failed => '儲存失敗，請重試。';

  @override
  String get comic_reading => '閱讀';

  @override
  String get comic_chapter_habits_hint => '章節列表操作習慣對所有書籍生效。';

  @override
  String get browser_title => '瀏覽器';

  @override
  String get translation_image_display => '圖片顯示';

  @override
  String get translation_display_hint => '譯圖優先顯示已有結果，暫無譯圖時保留原圖。';

  @override
  String get translation_sign_in_required => '登入後開啟翻譯';

  @override
  String get translation_sign_in_hint => '登入後切換譯圖，即可自動翻譯';

  @override
  String get translation_automatic => '自動翻譯';

  @override
  String get translation_original_hint => '當前顯示原圖，切到譯圖後自動翻譯';

  @override
  String get translation_window_hint => '僅在顯示譯圖時處理當前及後續圖片';

  @override
  String get translation_channel => '翻譯渠道';

  @override
  String get translation_no_images => '當前頁面暫未發現可翻譯圖片';

  @override
  String get translation_waiting_image => '等待當前圖片';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues 張需要處理',
      zero: '',
    );
    return '已完成 $complete / $total 張$_temp0';
  }

  @override
  String get translation_image_actions_hint => '長按圖片開啟更多操作，可重新翻譯單張圖片。';

  @override
  String get translation_title => '漫畫翻譯';

  @override
  String get translation_system_sign_in => '透過系統瀏覽器登入';

  @override
  String get translation_target_language => '目標語言';

  @override
  String get translation_clear_cache => '清理譯圖快取';

  @override
  String get translation_cache_hint => '保留翻譯記錄，需要時重新讀取結果';

  @override
  String get translation_saved_read_failed => '已有譯圖讀取失敗';

  @override
  String get translation_read_failed => '譯圖讀取失敗';

  @override
  String get operation_retry => '操作未完成，請重試';

  @override
  String get translation_original => '原圖';

  @override
  String get translation_translated => '譯圖';

  @override
  String get translation_regenerate_image => '重新翻譯此圖';

  @override
  String get translation_read_image => '重新讀取譯圖';

  @override
  String get translation_image_actions => '圖片更多操作';

  @override
  String get translation_processing => '正在處理';

  @override
  String get translation_reading => '正在讀取譯圖';

  @override
  String get translation_waiting => '等待翻譯';

  @override
  String get translation_preparing => '準備翻譯';

  @override
  String get translation_uploading => '上傳原圖';

  @override
  String get translation_running => '正在翻譯';

  @override
  String get translation_uncertain => '狀態待確認';

  @override
  String get translation_failed => '翻譯失敗';

  @override
  String get translation_verify => '核實';

  @override
  String get translation_reread => '重新讀取';

  @override
  String get browser_back => '後退';

  @override
  String get browser_translation => '網頁翻譯';

  @override
  String get browser_new_tab_action => '新建標籤頁';

  @override
  String get browser_current_tab => '當前';

  @override
  String get browser_close_tab => '關閉標籤頁';

  @override
  String get browser_new_tab => '新標籤頁';

  @override
  String get browser_page => '網頁';

  @override
  String get browser_unopened => '尚未開啟網頁';

  @override
  String get browser_invalid_address => '請輸入有效的網址';

  @override
  String get browser_clear_address => '清空網址';

  @override
  String get browser_paste_address => '貼上網址';

  @override
  String get browser_open_address => '開啟網址';

  @override
  String browser_tab_count(int count) {
    return '標籤頁 · $count';
  }

  @override
  String get browser_load_failed => '網頁暫時無法開啟';

  @override
  String get browser_load_failed_hint => '檢查網路，或確認網址是否正確。';

  @override
  String get browser_edit_address => '編輯網址';

  @override
  String get browser_clear_cookies_confirm => '清除所有網站登入狀態？';

  @override
  String get browser_clear_cookies_hint => '所有標籤頁中的網站可能需要重新登入。';

  @override
  String get browser_clear_cookies_action => '清除登入狀態';

  @override
  String get browser_tab_limit => '最多保留 12 個標籤頁，請先關閉一個。';

  @override
  String get browser_forward => '前進';

  @override
  String get browser_clear_all_cookies => '清除所有網站登入狀態';

  @override
  String get browser_clear_failed => '清除失敗，請重試。';

  @override
  String get browser_save_failed => '標籤狀態儲存失敗，請重試。';

  @override
  String get browser_tabs_full => '已開啟 12 個標籤頁';

  @override
  String get browser_no_tabs => '還沒有開啟的標籤頁';

  @override
  String get browser_close_failed => '標籤狀態儲存失敗，請再次點選關閉重試。';

  @override
  String get source_pinned_websites => '常用網站';

  @override
  String get manage => '管理';

  @override
  String get translation_settings_hint => '自動翻譯、目標語言與渠道';

  @override
  String get translation_show_original => '點選切換為原圖';

  @override
  String get translation_show_translated => '點選切換為譯圖';

  @override
  String get source_display => '顯示方式';

  @override
  String get source_cover_title => '封面與標題';

  @override
  String get source_cover_only => '僅封面';

  @override
  String get source_save_search => '儲存當前搜尋';

  @override
  String get source_saved_searches => '已儲存搜尋';

  @override
  String get source_website_info => '網站說明';

  @override
  String source_saved_search_title(String title) {
    return '$title · 點選立即搜尋';
  }

  @override
  String get action_done => '完成';

  @override
  String source_search_keyword(String query) {
    return '關鍵詞：$query';
  }

  @override
  String get source_no_saved_searches => '還沒有儲存的搜尋';

  @override
  String get source_save_search_hint => '輸入關鍵詞搜尋後，可從網站操作中儲存。';

  @override
  String get source_saved_search_scope => '僅儲存當前網站的關鍵詞。';

  @override
  String get source_search_here => '搜尋本站作品';

  @override
  String get source_filter_results => '篩選結果';

  @override
  String get source_search_results => '搜尋結果';

  @override
  String get source_return_popular => '返回熱門';

  @override
  String get source_popular_titles => '熱門作品';

  @override
  String get source_no_titles => '沒有找到相關作品';

  @override
  String get source_no_titles_hint => '調整關鍵詞或篩選條件，也可返回熱門瀏覽。';

  @override
  String get source_load_more_failed => '載入更多失敗，請重試。';

  @override
  String get source_load_pull_retry => '網站暫時無法載入，可下拉重試。';

  @override
  String get source_clear_failed => '清理未完成，請重試。';

  @override
  String get source_uninstall_failed => '解除安裝未完成，請重試。';

  @override
  String get source_details => '來源詳情';

  @override
  String get source_repository_website => '倉庫網站';

  @override
  String get source_provided_settings => '來源提供的設定';

  @override
  String get source_advanced_actions => '高階操作';

  @override
  String get source_edit_metadata => '編輯來源資訊';

  @override
  String get source_clear_cookies => '清除此網站 Cookie';

  @override
  String get source_clear_cookies_hint => '下次訪問可能需要重新登入';

  @override
  String get source_uninstall => '解除安裝來源';

  @override
  String get source_settings_save_failed => '儲存未完成，請重新開啟來源設定核對。';

  @override
  String get repository_third_party => '第三方倉庫';

  @override
  String get repository_refresh_failed => '目錄重新整理失敗，已保留快取，可重試。';

  @override
  String get repository_show_sources => '顯示此倉庫的來源';

  @override
  String get repository_copy_catalog => '複製目錄連結';

  @override
  String get repository_remove => '移除倉庫';

  @override
  String get repository_remove_hint => '保留已安裝的來源，移除尚未安裝的目錄條目。';

  @override
  String get repository_empty => '還沒有新增第三方倉庫';

  @override
  String get repository_built_in => '內建官方目錄';

  @override
  String get repository_hidden => '已隱藏';

  @override
  String get repository_refreshing => '正在重新整理…';

  @override
  String get repository_refresh => '重新整理目錄';

  @override
  String get repository_manage_hint => '管理第三方來源的獲取地址';

  @override
  String get repository_invalid_address => '請輸入有效的 http 或 https 網址';

  @override
  String get repository_already_added => '此倉庫已新增';

  @override
  String get repository_unrecognized => '未識別到可用目錄，請檢查連結後重試。';

  @override
  String get repository_read_failed => '目錄讀取失敗，請重試。';

  @override
  String get repository_save_failed => '儲存未完成，請核對倉庫列表。';

  @override
  String get repository_paste_hint => '貼上第三方倉庫的目錄連結';

  @override
  String get repository_address => '倉庫地址';

  @override
  String get repository_paste_link => '貼上連結';

  @override
  String repository_recognized(String type) {
    return '$type · 目錄已識別';
  }

  @override
  String get repository_choose_sources_hint => '新增後可選擇需要的來源。';

  @override
  String get search_scope => '搜尋範圍';

  @override
  String get search_scope_hint => '選擇本次要搜尋的網站';

  @override
  String search_websites_action(int count) {
    return '搜尋這 $count 個網站';
  }

  @override
  String get search_find_website => '查詢網站';

  @override
  String search_selected_websites(int count) {
    return '已選 $count 個網站';
  }

  @override
  String get action_clear => '清空';

  @override
  String get search_deselect_results => '取消當前結果';

  @override
  String get search_select_results => '選中當前結果';

  @override
  String get search_no_websites_hint => '沒有匹配的網站，試試其他名稱或語言。';

  @override
  String get search_select_website_hint => '至少選擇一個網站後即可搜尋。';

  @override
  String get search_start_title => '輸入關鍵詞搜尋作品';

  @override
  String get search_start_hint => '一次搜尋多個網站，只展示找到的作品。';

  @override
  String get search_empty_scope => '當前範圍沒有可搜尋的網站';

  @override
  String get search_empty_scope_hint => '切換到全部網站，或重新選擇參與搜尋的網站。';

  @override
  String search_result_count(int count) {
    return '$count 個結果';
  }

  @override
  String get search_titles => '搜作品';

  @override
  String get search_actions => '搜尋操作';

  @override
  String get search_details => '搜尋詳情';

  @override
  String get search_title_hint => '搜尋作品名稱';

  @override
  String get search_searching => '正在搜尋';

  @override
  String search_found_results(int count) {
    return '找到 $count 個結果';
  }

  @override
  String get search_no_results => '沒有匹配結果';

  @override
  String get search_failed => '搜尋失敗';

  @override
  String search_found_titles(int count, int websites) {
    return '已找到 $count 個作品 · $websites 個網站';
  }

  @override
  String get search_finding_titles => '正在查詢作品';

  @override
  String get search_complete => '搜尋完成';

  @override
  String get search_in_progress => '搜尋中';

  @override
  String get search_finding_related => '正在尋找相關作品…';

  @override
  String get search_no_results_yet => '暫未取得搜尋結果';

  @override
  String get search_no_matching_titles => '未找到相關作品';

  @override
  String get search_results_appear_hint => '找到後會直接顯示在這裡。';

  @override
  String get search_failed_websites_hint => '有網站未能完成搜尋，可在搜尋詳情中重試。';

  @override
  String get search_change_keywords_hint => '試試更短的關鍵詞，或擴大搜尋範圍。';

  @override
  String get search_view_details => '檢視搜尋詳情';

  @override
  String get search_adjust_scope => '調整搜尋範圍';

  @override
  String search_query_websites(String query, int count) {
    return '$query · $count 個網站';
  }

  @override
  String search_completed_count(int completed, int total) {
    return '已完成 $completed / $total';
  }

  @override
  String get search_retry_website_hint => '失敗網站可單獨重試';

  @override
  String source_selected_count(int count) {
    return '已選擇 $count 項';
  }

  @override
  String get search_languages => '搜尋語言';

  @override
  String get source_deselect => '取消選擇';

  @override
  String get source_select => '選擇來源';

  @override
  String get source_multilingual => '多語言';

  @override
  String get source_language_unknown => '語言未標註';

  @override
  String get source_adult_content => '含 18+ 內容';

  @override
  String get source_classification_unknown => '分類未標註';

  @override
  String source_more_classifications(int count) {
    return '檢視全部來源資料，另有 $count 個分類';
  }

  @override
  String get source_loading_website => '正在載入網站';

  @override
  String get source_unpin => '取消常用';

  @override
  String get source_pin => '固定到常用';

  @override
  String get source_open => '進入';

  @override
  String get source_metadata_hint => '資料由來源目錄提供，分類描述網站覆蓋範圍。';

  @override
  String get source_region => '地區';

  @override
  String get source_format => '形式';

  @override
  String get source_creation => '創作';

  @override
  String get source_unspecified => '未標註';

  @override
  String get source_pricing => '收費';

  @override
  String get source_region_jp => '日漫';

  @override
  String get source_region_kr => '韓漫';

  @override
  String get source_region_cn => '國漫';

  @override
  String get source_region_hk_tw => '港臺漫畫';

  @override
  String get source_region_western => '歐美漫畫';

  @override
  String get source_region_other => '其他地區';

  @override
  String get source_format_page => '頁漫';

  @override
  String get source_format_vertical => '條漫';

  @override
  String get source_format_strip => '短篇條格';

  @override
  String get source_creation_original => '原創';

  @override
  String get source_creation_fan => '同人';

  @override
  String get source_free_watch => '免費觀看';

  @override
  String get source_free_read => '免費閱讀';

  @override
  String get source_partial_paid => '部分收費';

  @override
  String get source_paid_watch => '付費觀看';

  @override
  String get source_paid_read => '付費閱讀';

  @override
  String get source_pricing_unknown => '收費未標註';

  @override
  String get source_language_filter => '語言篩選';

  @override
  String get source_language_filter_hint => '僅篩選當前目錄，不影響已安裝來源';

  @override
  String get source_all_languages => '全部語言';

  @override
  String get action_apply => '應用';

  @override
  String get source_load_retry => '網站暫時無法載入，請重試。';

  @override
  String get source_catalog_refresh_failed => '目錄重新整理失敗，已保留當前內容，可下拉重試。';

  @override
  String source_uninstall_count(int count) {
    return '解除安裝 $count 個來源？';
  }

  @override
  String get source_uninstall_selected_hint =>
      '將解除安裝所選的已安裝來源並清除其來源設定，保留書架作品和下載。';

  @override
  String source_failed_count(int count) {
    return '$count 個來源操作失敗，已保留選擇，請重試。';
  }

  @override
  String get source_latest_content => '最新內容';

  @override
  String get source_actions => '來源操作';

  @override
  String get source_bulk_manage => '批次管理';

  @override
  String get source_update_installed => '更新已安裝來源';

  @override
  String get source_no_matching_websites => '沒有匹配的網站';

  @override
  String get source_no_websites => '暫無可用網站';

  @override
  String get source_search_installed_hint => '在已安裝來源中搜尋作品';

  @override
  String get source_global_search => '跨來源搜尋';

  @override
  String get source_manage_repositories => '管理倉庫';

  @override
  String get source_view_third_party => '檢視第三方';

  @override
  String get source_catalog_load_failed => '目錄載入失敗，可下拉重試。';

  @override
  String get source_all_websites => '全部網站';

  @override
  String get source_available => '可安裝';

  @override
  String get source_third_party => '第三方';

  @override
  String get source_name_or_title => '網站名或作品名';

  @override
  String get view_all => '檢視全部';

  @override
  String get search_searching_ellipsis => '正在搜尋…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · 待測試';
  }

  @override
  String get onboarding_untested => '待測試';

  @override
  String get source_custom_scope => '自選';

  @override
  String get source_custom_websites => '自選網站';

  @override
  String get tv_hidden_library_hint => '所有作品都在隱藏分類中。\n在「全部」上長按確認鍵可取消隱藏。';

  @override
  String get tv_no_matching_anime => '沒有匹配的動畫';

  @override
  String tv_no_matching_category(String category) {
    return '「$category」中沒有匹配的動畫';
  }

  @override
  String get tv_filtered_empty_hint => '沒有符合當前篩選條件的動畫。\n可透過搜尋旁的按鈕調整篩選。';

  @override
  String get tv_new_episodes => '最新劇集';

  @override
  String get tv_recently_added => '最近新增';

  @override
  String get tv_empty_category_hint => '此分類還沒有動畫。\n可在作品詳情頁新增。';

  @override
  String get tv_empty_library => '動畫書庫為空';

  @override
  String get tv_empty_library_hint => '從瀏覽頁面新增動畫，即可在此檢視';

  @override
  String get tv_browse_anime => '瀏覽動畫';

  @override
  String tv_new_count(int count) {
    return '$count 集未看';
  }

  @override
  String tv_category_hidden(String category) {
    return '已隱藏「$category」· 在「全部」上長按確認鍵可取消隱藏';
  }

  @override
  String get tv_no_hidden_categories => '沒有隱藏的分類';

  @override
  String get import_torrent_file => '匯入 .torrent 檔案';

  @override
  String get import_video_formats => '.mp4、.mkv、.avi 等格式';

  @override
  String get cloudflare_proxy_optional => 'FlareSolverr / Byparr 地址（可選）';

  @override
  String get tv_home_layout_hint => '按繼續觀看、最新劇集和分類分行顯示動畫主頁';

  @override
  String get tv_hide_libraries_hint => '隱藏漫畫和小說書庫（電視端預設開啟）';

  @override
  String get anime_only_hint => '在整個應用中隱藏漫畫和小說，關閉後顯示所有內容。';

  @override
  String get audio_auto_safe => '自動（安全）';

  @override
  String get tv_player_hint => '開啟時使用電視專用播放器；關閉時使用桌面播放器。';

  @override
  String get release_open_failed => '無法開啟發布頁面';

  @override
  String get tv_replay => '重新播放';

  @override
  String get tv_no_episodes => '暫無劇集';

  @override
  String get tracker_continue_series => '繼續觀看劇集';

  @override
  String get tracker_watchlist_series => '劇集待看列表';

  @override
  String get tracker_continue_movies => '繼續觀看電影';

  @override
  String get tracker_watchlist_movies => '電影待看列表';

  @override
  String get tracker_trending_series => '熱門趨勢劇集';

  @override
  String get tracker_trending_movies => '熱門趨勢電影';

  @override
  String get tracker_popular_series => '熱門劇集';

  @override
  String get tracker_popular_movies => '熱門電影';

  @override
  String get tracker_top_series => '劇集總榜';

  @override
  String get tracker_top_movies => '電影總榜';

  @override
  String get tracker_airing_series => '熱播劇集';

  @override
  String get tracker_airing_anime => '連載動畫';

  @override
  String get tracker_popular_anime => '熱門動畫';

  @override
  String get tracker_upcoming_anime => '即將播出的動畫';

  @override
  String get tracker_popular_manga => '熱門漫畫';

  @override
  String get tracker_top_manga => '日漫排行榜';

  @override
  String get tracker_top_manhwa => '韓漫排行榜';

  @override
  String get tracker_top_manhua => '國漫排行榜';

  @override
  String get tracker_latest_anime => '最新動畫';

  @override
  String get tracker_best_anime => '高分動畫';

  @override
  String get tracker_latest_manga => '最新漫畫';

  @override
  String get tracker_best_manga => '高分漫畫';

  @override
  String get tracker_trending_anime => '熱門趨勢動畫';

  @override
  String get tracker_upcoming_manga => '即將推出的漫畫';

  @override
  String get tracker_trending_manga => '熱門趨勢漫畫';

  @override
  String selection_progress(int selected, int total) {
    return '已選擇 $selected/$total';
  }

  @override
  String get source_code_editor => '程式碼編輯器';

  @override
  String get source_code_execute => '執行';

  @override
  String get source_console_logs => '控制檯日誌';

  @override
  String get source_no_logs => '暫無日誌';

  @override
  String get source_updated_successfully => '來源已更新';

  @override
  String get source_obsolete => '已過時';

  @override
  String player_seek_forward_seconds(int seconds) {
    return '向前跳轉 $seconds 秒';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return '向後跳轉 $seconds 秒';
  }

  @override
  String get player_autoplay_on => '自動播放下一集：開啟';

  @override
  String get player_autoplay_off => '自動播放下一集：關閉';

  @override
  String get player_no_other_quality => '沒有其他畫質';

  @override
  String get player_no_subtitles => '暫無字幕';

  @override
  String get player_no_audio_tracks => '暫無音軌';

  @override
  String get player_seek_forward => '向前跳轉';

  @override
  String get player_seek_backward => '向後跳轉';

  @override
  String player_seconds(int seconds) {
    return '$seconds 秒';
  }

  @override
  String get subtitle_preview => '字幕樣式預覽';

  @override
  String get subtitle_style => '樣式';

  @override
  String get translation_official_channel => 'NodeLane 官方';

  @override
  String get translation_auth_required => '請先登入翻譯賬號';

  @override
  String get translation_source_changed => '原圖已變化，請重新載入';

  @override
  String get translation_source_missing => '原圖暫不可用';

  @override
  String get translation_resource_limit => '當前圖片超出本機處理預算，已保留原圖';

  @override
  String get translation_storage_full => '翻譯儲存空間不足，請先清理譯圖';

  @override
  String get translation_invalid_image => '圖片格式或內容無效';

  @override
  String get translation_unsupported_image => '暫不支援此圖片的翻譯，已保留原圖';

  @override
  String get translation_invalid_result => '譯圖校驗失敗，請重新讀取';

  @override
  String get translation_result_unavailable => '譯圖暫不可用，請重新讀取';

  @override
  String get translation_result_expired => '譯圖已過期，請重新翻譯';

  @override
  String get translation_analysis_too_large => '圖片分析內容過多，請縮小圖片後再翻譯';

  @override
  String get translation_region_limit => '圖片文字區域過多，請拆分圖片後再翻譯';

  @override
  String get translation_text_limit => '圖片單段文字過長，請調整圖片後再翻譯';

  @override
  String get translation_unavailable => '此翻譯已不可用';

  @override
  String get translation_outcome_unknown => '結果待核實，未重新提交';

  @override
  String get translation_rate_limited => '請求受限，稍後自動恢復';

  @override
  String get translation_quota_exhausted => '當前翻譯額度不足';

  @override
  String get translation_unsupported_language => '服務暫不支援此目標語言';

  @override
  String get translation_upgrade_required => '翻譯協議不相容，請更新應用';

  @override
  String get translation_remote_failed => '本頁翻譯失敗，可手動重試';

  @override
  String get translation_bridge_invalid => '網頁已變化，請重新開啟翻譯';

  @override
  String get translation_connection_failed => '連線失敗，請重試';

  @override
  String get translation_paused => '翻譯已暫停，可核實進度';

  @override
  String get translation_preparing_ellipsis => '準備翻譯…';

  @override
  String get translation_checking_original => '核對原圖…';

  @override
  String get translation_submitting => '正在提交…';

  @override
  String get translation_uploading_ellipsis => '上傳原圖…';

  @override
  String get translation_waiting_ellipsis => '等待翻譯…';

  @override
  String get translation_running_ellipsis => '正在翻譯…';

  @override
  String get translation_verify_result => '結果待核實';

  @override
  String get translation_partial => '部分內容已翻譯';

  @override
  String get translation_ready => '譯圖已就緒';

  @override
  String get list_separator => '、';

  @override
  String get player_play => '播放';

  @override
  String get player_quality => '畫質';

  @override
  String get player_subtitles => '字幕';

  @override
  String get player_audio => '音訊';

  @override
  String get player_statistics => '播放統計';

  @override
  String get player_auto => '自動';

  @override
  String get source_information => '來源資料';

  @override
  String get source_code_page => '頁碼';

  @override
  String get source_code_query => '關鍵詞';

  @override
  String get repository_invalid_source => '無效來源，請移除';

  @override
  String get player_fit_contain => '完整';

  @override
  String get player_fit_cover => '覆蓋';

  @override
  String get player_fit_fill => '拉伸';

  @override
  String get player_fit_height => '高度';

  @override
  String get player_fit_width => '寬度';

  @override
  String get player_fit_scale => '縮小';

  @override
  String get player_fit_none => '原始';

  @override
  String get player_shader_clear => '關閉著色器';

  @override
  String get player_shader_luma => '亮度升取樣';

  @override
  String get player_decoder_auto => '自動（硬體）';

  @override
  String get player_decoder_software => '軟體解碼';

  @override
  String get player_stats_toggle => '顯示或隱藏統計';

  @override
  String get player_stats_general => '概覽';

  @override
  String get player_stats_frames => '幀耗時';

  @override
  String get player_stats_cache => '輸入快取';

  @override
  String get player_stats_filters => '啟用的濾鏡';

  @override
  String get player_stats_log => '日誌';

  @override
  String get source_mark_pinned => '設為常用';

  @override
  String translation_image_action(String action) {
    return '$action此圖片';
  }

  @override
  String get memory_waiting => '記憶體：等待取樣';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS   $current   峰值 $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return '快取 $current / $limit   峰值 $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return '圖片 $count / $limit   活躍 $live   峰值 $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    return '滿載 $percent% · $count 次取樣';
  }

  @override
  String get memory_reset_hint => '在設定中關閉後重新開啟即可重置';

  @override
  String get action_hide => '隱藏';

  @override
  String discord_get_app(String app) {
    return '獲取 $app';
  }

  @override
  String get discord_idle => '空閒';

  @override
  String discord_watching_title(String title) {
    return '正在觀看 $title';
  }

  @override
  String discord_reading_title(String title) {
    return '正在閱讀 $title';
  }
}
