// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get app_update_details_hint =>
      'Xem ghi chú phát hành và tùy chọn cài đặt';

  @override
  String get app_update_download => 'Tải xuống bản cập nhật';

  @override
  String get app_update_download_hint =>
      'Sau khi tải xuống, hãy làm theo lời nhắc để cài đặt bản cập nhật.';

  @override
  String get bookshelf_all => 'Tất cả';

  @override
  String get bookshelf_search => 'Thư viện tìm kiếm';

  @override
  String get app_update_allow_install =>
      'Cho phép cài đặt ứng dụng trong cài đặt hệ thống, sau đó quay lại và nhấn Cài đặt.';

  @override
  String get app_update_waiting => 'Đang chờ hệ thống tiếp tục tải xuống…';

  @override
  String get app_update_cancel_download => 'Hủy tải xuống';

  @override
  String get app_update_remove_package => 'Xóa gói đã tải xuống';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'Không có cài đặt phù hợp';

  @override
  String get search_empty_hint =>
      'Hãy thử từ khóa khác hoặc xóa tìm kiếm để xem mọi thứ.';

  @override
  String get search_clear => 'Xóa tìm kiếm';

  @override
  String get app_updates => 'Cập nhật ứng dụng';

  @override
  String get app_update_auto => 'Kiểm tra khi khởi chạy';

  @override
  String get app_update_view => 'Xem cập nhật';

  @override
  String get app_update_later => 'Sau này';

  @override
  String get app_update_external_hint =>
      'Mở liên kết cập nhật trong trình duyệt của bạn';

  @override
  String get app_update_failed =>
      'Không thể kiểm tra cập nhật. Vui lòng thử lại.';

  @override
  String get app_update_opened => 'Đã mở liên kết cập nhật';

  @override
  String get app_diagnostics => 'Chẩn đoán và nhật ký';

  @override
  String get library => 'Thư viện';

  @override
  String get updates_search => 'Cập nhật tìm kiếm';

  @override
  String get updates => 'Cập nhật';

  @override
  String get history => 'Lịch sử';

  @override
  String get browse => 'Duyệt qua';

  @override
  String get more => 'Thêm';

  @override
  String get open_random_entry => 'Mở mục ngẫu nhiên';

  @override
  String get import => 'Nhập khẩu';

  @override
  String get filter => 'Bộ lọc';

  @override
  String get ignore_filters => 'Bỏ qua bộ lọc';

  @override
  String get downloaded => 'Đã tải xuống';

  @override
  String get unread => 'Chưa đọc';

  @override
  String get unwatched => 'Chưa xem';

  @override
  String get started => 'Đã bắt đầu';

  @override
  String get bookmarked => 'Đã đánh dấu';

  @override
  String get sort => 'Sắp xếp';

  @override
  String get alphabetically => 'Theo thứ tự bảng chữ cái';

  @override
  String get last_read => 'Đọc lần cuối';

  @override
  String get last_watched => 'Đã xem lần cuối';

  @override
  String get last_update_check => 'Kiểm tra cập nhật lần cuối';

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
          'Bạn đang xóa tất cả $count $entryTypePlural của $mediaType này khỏi thư viện.',
      one: 'Bạn đang xóa $entryType duy nhất của $mediaType này khỏi thư viện.',
    );
    return '$_temp0\nThao tác này cũng sẽ xóa toàn bộ $mediaType khỏi thư viện của bạn.\n\nLưu ý: Bản thân các tập tin sẽ không bị xóa.';
  }

  @override
  String get chapter => 'chương';

  @override
  String get episode => 'tập';

  @override
  String get unread_count => 'Số lượng chưa đọc';

  @override
  String get unwatched_count => 'Số lượng chưa xem';

  @override
  String get latest_chapter => 'Chương mới nhất';

  @override
  String get latest_episode => 'Tập mới nhất';

  @override
  String get date_added => 'Ngày thêm';

  @override
  String get display => 'Hiển thị';

  @override
  String get display_mode => 'Chế độ hiển thị';

  @override
  String get compact_grid => 'Lưới nhỏ gọn';

  @override
  String get compression_level => 'Mức nén';

  @override
  String compression_info(Object level) {
    return 'Độ nén càng cao thì tệp sao lưu càng chiếm ít dung lượng nhưng lại sử dụng nhiều CPU hơn. Mặc định: $level';
  }

  @override
  String get comfortable_grid => 'Lưới thoải mái';

  @override
  String get cover_only_grid => 'Lưới chỉ che';

  @override
  String get list => 'Danh sách';

  @override
  String get badges => 'Huy hiệu';

  @override
  String get downloaded_chapters => 'Các chương đã tải xuống';

  @override
  String get downloaded_episodes => 'Các tập đã tải xuống';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get local_source => 'Nguồn cục bộ';

  @override
  String get tabs => 'Tab';

  @override
  String get show_category_tabs => 'Hiển thị tab danh mục';

  @override
  String get show_numbers_of_items => 'Hiển thị số lượng mục';

  @override
  String get other => 'Khác';

  @override
  String get show_continue_reading_buttons => 'Hiển thị nút tiếp tục đọc';

  @override
  String get show_continue_watching_buttons => 'Hiển thị nút tiếp tục xem';

  @override
  String get empty_library => 'Thư viện trống';

  @override
  String get search => 'Tìm kiếm...';

  @override
  String get no_recent_updates => 'Không có cập nhật gần đây';

  @override
  String get remove_everything => 'Xóa mọi thứ';

  @override
  String get remove_everything_msg =>
      'Bạn có chắc không? Tất cả lịch sử sẽ bị mất';

  @override
  String get remove_all_update_msg =>
      'Bạn có chắc không? Toàn bộ bản cập nhật sẽ bị xóa';

  @override
  String get ok => 'Được rồi';

  @override
  String get cancel => 'Hủy bỏ';

  @override
  String get remove => 'Xóa';

  @override
  String get remove_history_msg =>
      'Thao tác này sẽ xóa ngày đọc của chương này. Bạn có chắc không?';

  @override
  String get last_used => 'Được sử dụng lần cuối';

  @override
  String get pinned => 'Đã ghim';

  @override
  String get sources => 'Nguồn';

  @override
  String get install => 'Cài đặt';

  @override
  String get update => 'Cập nhật';

  @override
  String get latest => 'Mới nhất';

  @override
  String get extensions => 'Phần mở rộng';

  @override
  String get migrate => 'Di chuyển';

  @override
  String get mass_migration_title => 'Di cư hàng loạt';

  @override
  String get mass_migration_preview_items => 'Xem trước các mục';

  @override
  String get mass_migration_destination_source => 'Nguồn đích';

  @override
  String get mass_migration_no_library_items =>
      'Không có mục thư viện nào có sẵn để di chuyển hàng loạt.';

  @override
  String get mass_migration_no_destination_sources =>
      'Không có nguồn đích được cài đặt nào.';

  @override
  String get mass_migration_installed => 'Đã cài đặt';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mục sẵn sàng để xem xét',
      one: '1 mục đã sẵn sàng để xem xét',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mục',
      one: '1 sản phẩm',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'Chọn nguồn đích';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Tìm kết quả trùng khớp trong $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Đang xử lý mục $current của $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Chờ 2 giây trước mục tiếp theo...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Chờ 2 giây trước lần di chuyển tiếp theo...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Đã khớp cho đến nay: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Không khớp: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Xem lại kết quả phù hợp cho $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Đã tìm thấy kết quả phù hợp: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Không có kết quả trùng khớp: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Đã chọn để di chuyển: $count';
  }

  @override
  String get mass_migration_finish_review => 'Kết thúc đánh giá';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Di chuyển các mục đã chọn ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Đang di chuyển các mục đã chọn sang $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Không có mục nào được chọn để di chuyển.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Đang di chuyển mục $current của $total';
  }

  @override
  String get mass_migration_complete => 'Di chuyển hàng loạt hoàn tất';

  @override
  String get mass_migration_complete_success_message =>
      'Tất cả các mục được chọn đã được xử lý thành công.';

  @override
  String get mass_migration_complete_partial_message =>
      'Quá trình di chuyển đã hoàn tất với một số mục vẫn cần được xử lý theo cách thủ công.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Đã xử lý';

  @override
  String get mass_migration_matched => 'Đã khớp';

  @override
  String get mass_migration_migrated => 'Đã di chuyển';

  @override
  String get mass_migration_skipped => 'Đã bỏ qua';

  @override
  String get mass_migration_failed => 'Thất bại';

  @override
  String get mass_migration_failed_items => 'Các mục bị lỗi';

  @override
  String get mass_migration_exit => 'Thoát khỏi di cư hàng loạt';

  @override
  String get mass_migration_no_destination_match =>
      'Không tìm thấy điểm đến phù hợp';

  @override
  String mass_migration_query(Object query) {
    return 'Truy vấn: $query';
  }

  @override
  String get mass_migration_skip => 'Bỏ qua';

  @override
  String get mass_migration_loading => 'Đang tải...';

  @override
  String get mass_migration_choose_another_result => 'Chọn kết quả khác';

  @override
  String get mass_migration_source_chapters => 'Nguồn chương';

  @override
  String get mass_migration_destination_chapters => 'Chương đích';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chương',
      one: '1 chương',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chương nguồn',
      one: '1 chương nguồn',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chương đích',
      one: '1 chương đích',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Không tìm thấy chương nào.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Và $count thêm...';
  }

  @override
  String get mass_migration_unknown_title => 'Tiêu đề không rõ';

  @override
  String get mass_migration_unknown_match => 'Trận đấu không xác định';

  @override
  String get mass_migration_unknown_source => 'Nguồn không xác định';

  @override
  String get mass_migration_unknown_chapter => 'Chương không xác định';

  @override
  String get migrate_confirm => 'Di chuyển sang nguồn khác';

  @override
  String get clean_database => 'Làm sạch cơ sở dữ liệu';

  @override
  String cleaned_database(Object x) {
    return 'Cơ sở dữ liệu đã được làm sạch! $x mục đã bị xóa';
  }

  @override
  String get clean_database_desc =>
      'Thao tác này sẽ xóa tất cả các mục chưa được thêm vào thư viện!';

  @override
  String get incognito_mode => 'Chế độ ẩn danh';

  @override
  String get incognito_mode_description => 'Tạm dừng lịch sử đọc';

  @override
  String get downloaded_only => 'Chỉ được tải xuống';

  @override
  String get downloaded_only_description =>
      'Chỉ hiển thị các mục đã tải xuống trong thư viện của bạn';

  @override
  String get download_queue => 'Hàng đợi tải xuống';

  @override
  String get categories => 'Danh mục';

  @override
  String get statistics => 'Thống kê';

  @override
  String get settings => 'Cài đặt';

  @override
  String get about => 'Giới thiệu';

  @override
  String get help => 'Trợ giúp';

  @override
  String get no_downloads => 'Không tải xuống';

  @override
  String get edit_categories => 'Chỉnh sửa danh mục';

  @override
  String get edit_categories_description =>
      'Bạn không có danh mục nào. Nhấn vào nút dấu cộng để tạo một nút để sắp xếp thư viện của bạn';

  @override
  String get add => 'Thêm';

  @override
  String get add_category => 'Thêm danh mục';

  @override
  String get name => 'Tên';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Bắt buộc';

  @override
  String get add_category_error_exist => 'Một danh mục có tên này đã tồn tại!';

  @override
  String get delete_category => 'Xóa danh mục';

  @override
  String delete_category_msg(Object name) {
    return 'Bạn có muốn xóa danh mục $name không?';
  }

  @override
  String get rename_category => 'Đổi tên danh mục';

  @override
  String get general => 'Tổng quát';

  @override
  String get general_subtitle => 'Ngôn ngữ ứng dụng';

  @override
  String get app_language => 'Ngôn ngữ ứng dụng';

  @override
  String get default_subtitle_language => 'Ngôn ngữ phụ đề mặc định';

  @override
  String get appearance => 'Ngoại hình';

  @override
  String get appearance_subtitle => 'Chủ đề, định dạng ngày và giờ';

  @override
  String get theme => 'Chủ đề';

  @override
  String get dark_mode => 'Chế độ tối';

  @override
  String get follow_system_theme => 'Theo chủ đề hệ thống';

  @override
  String get on => 'Bật';

  @override
  String get off => 'Tắt';

  @override
  String get pure_black_dark_mode => 'Chế độ tối đen tuyền';

  @override
  String get timestamp => 'Dấu thời gian';

  @override
  String get relative_timestamp => 'Dấu thời gian tương đối';

  @override
  String get relative_timestamp_short => 'Ngắn (Hôm nay, Hôm qua)';

  @override
  String get relative_timestamp_long => 'Dài (Ngắn+, n ngày trước)';

  @override
  String get date_format => 'Định dạng ngày';

  @override
  String get reader => 'Người đọc';

  @override
  String get refresh => 'Làm mới';

  @override
  String get reader_subtitle => 'Chế độ đọc, hiển thị, điều hướng';

  @override
  String get default_reading_mode => 'Chế độ đọc mặc định';

  @override
  String get reading_mode_vertical => 'Dọc';

  @override
  String get reading_mode_horizontal => 'Ngang';

  @override
  String get reading_mode_left_to_right => 'Trái sang phải';

  @override
  String get reading_mode_right_to_left => 'Phải sang trái';

  @override
  String get reading_mode_vertical_continuous => 'Theo chiều dọc liên tục';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Tốc độ hoạt ảnh chạm hai lần';

  @override
  String get normal => 'Bình thường';

  @override
  String get fast => 'Nhanh';

  @override
  String get no_animation => 'Không có hoạt ảnh';

  @override
  String get animate_page_transitions => 'Tạo hiệu ứng chuyển tiếp trang';

  @override
  String get crop_borders => 'Cắt đường viền';

  @override
  String get downloads => 'Tải xuống';

  @override
  String get downloads_subtitle => 'Cài đặt tải xuống';

  @override
  String get download_location => 'Vị trí tải xuống';

  @override
  String get custom_location => 'Vị trí tùy chỉnh';

  @override
  String get only_on_wifi => 'Chỉ trên wifi';

  @override
  String get save_as_cbz_archive => 'Lưu dưới dạng kho lưu trữ CBZ';

  @override
  String get delete_download_after_reading => 'Xóa tải xuống sau khi đọc';

  @override
  String get concurrent_downloads => 'Tải xuống đồng thời';

  @override
  String get browse_subtitle => 'Nguồn, tìm kiếm toàn cầu';

  @override
  String get only_include_pinned_sources => 'Chỉ bao gồm các nguồn được ghim';

  @override
  String get nsfw_sources => 'Nguồn NSFW (+18)';

  @override
  String get nsfw_sources_show =>
      'Hiển thị trong danh sách nguồn và tiện ích mở rộng';

  @override
  String get nsfw_sources_info =>
      'Điều này không ngăn các tiện ích mở rộng không chính thức hoặc có thể bị gắn cờ không chính xác hiển thị nội dung NSFW (18+) trong ứng dụng';

  @override
  String get version => 'Phiên bản';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Kiểm tra cập nhật';

  @override
  String get logs_on => 'Kích hoạt tính năng ghi nhật ký';

  @override
  String get share_app_logs => 'Chia sẻ nhật ký ứng dụng';

  @override
  String get no_app_logs => 'Không có log.txt!';

  @override
  String get failed => 'Thất bại!';

  @override
  String n_days_ago(Object days) {
    return '$days ngày trước';
  }

  @override
  String get today => 'Hôm nay';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get a_week_ago => 'Một tuần trước';

  @override
  String get next_week => 'Tuần sau';

  @override
  String get add_to_library => 'Thêm vào thư viện';

  @override
  String get completed => 'Đã hoàn thành';

  @override
  String get ongoing => 'Đang tiến hành';

  @override
  String get on_hiatus => 'Đang tạm dừng';

  @override
  String get canceled => 'Đã hủy';

  @override
  String get publishing_finished => 'Xuất bản xong';

  @override
  String get unknown => 'Không rõ';

  @override
  String get empty_placeholder => 'TRỐNG\nMPTY\nMTY\nMT\n\n';

  @override
  String get error => 'Lỗi';

  @override
  String error_with_message(Object error) {
    return 'Lỗi: $error';
  }

  @override
  String get no_pages_available => 'Lỗi: không có trang nào';

  @override
  String get set_categories => 'Đặt danh mục';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get in_library => 'Trong thư viện';

  @override
  String get filter_scanlator_groups => 'Nhóm máy quét bộ lọc';

  @override
  String get reset => 'Đặt lại';

  @override
  String get by_source => 'Theo nguồn';

  @override
  String get by_chapter_number => 'Theo số chương';

  @override
  String get by_episode_number => 'Theo số tập';

  @override
  String get by_upload_date => 'Theo ngày tải lên';

  @override
  String get source_title => 'Tiêu đề nguồn';

  @override
  String get create_extension => 'Tạo tiện ích mở rộng';

  @override
  String get developer_mode => 'Chế độ nhà phát triển';

  @override
  String get developer_mode_subtitle =>
      'Hiển thị công cụ dành cho nhà phát triển tiện ích mở rộng (tạo tiện ích mở rộng, chỉnh sửa mã)';

  @override
  String get choose_extension_language => 'Chọn ngôn ngữ mở rộng';

  @override
  String get lang => 'Lang';

  @override
  String get base_url => 'Url cơ sở';

  @override
  String get api_url_optional => 'ApiUrl (tùy chọn)';

  @override
  String get icon_url => 'iconUrl';

  @override
  String get source_icon_url => 'Url biểu tượng nguồn';

  @override
  String get notes => 'ghi chú';

  @override
  String get extension_name_example => 'ví dụ: myAnime';

  @override
  String get language_code_example => 'ví dụ: vi';

  @override
  String get base_url_example => 'ví dụ: https://example.com';

  @override
  String get api_url_example => 'ví dụ: https://api.example.com';

  @override
  String get extension_notes_example =>
      'ví dụ: tiện ích mở rộng này yêu cầu đăng nhập';

  @override
  String get type => 'Loại';

  @override
  String get target => 'Mục tiêu';

  @override
  String get source_type_single => 'độc thân';

  @override
  String get source_type_multi => 'đa';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Phi tiêu';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader biên soạn JS';

  @override
  String get source_created_successfully => 'Nguồn được tạo thành công';

  @override
  String get source_already_exists => 'Nguồn đã tồn tại';

  @override
  String get error_when_creating_source => 'Lỗi khi tạo nguồn';

  @override
  String get cookies_deleted => 'Đã xóa cookie!';

  @override
  String get delete_all_cookies => 'Xóa tất cả cookie';

  @override
  String get chapter_number => 'Số chương';

  @override
  String get episode_number => 'Số tập';

  @override
  String get share => 'Chia sẻ';

  @override
  String n_chapters(Object n) {
    return '$n chương';
  }

  @override
  String missing_chapters(Object count) {
    return 'Thiếu $count chương';
  }

  @override
  String get no_description => 'Không có mô tả';

  @override
  String get resume => 'Tiếp tục';

  @override
  String get read => 'Đọc';

  @override
  String get watch => 'Đồng hồ đeo tay';

  @override
  String get popular => 'Phổ biến';

  @override
  String get open_in_browser => 'Mở trong trình duyệt';

  @override
  String get clear_cookie => 'Xóa cookie';

  @override
  String get show_page_number => 'Hiển thị số trang';

  @override
  String get from_library => 'Từ thư viện';

  @override
  String get downloaded_chapter => 'Đã tải chương';

  @override
  String page(Object page) {
    return 'Trang $page';
  }

  @override
  String get global_search => 'Tìm kiếm toàn cầu';

  @override
  String get color_blend_level => 'Mức độ hòa trộn màu';

  @override
  String current(Object char) {
    return 'Hiện tại $char';
  }

  @override
  String finished(Object char) {
    return 'Đã hoàn thành $char';
  }

  @override
  String next(Object char) {
    return 'Tiếp theo $char';
  }

  @override
  String previous(Object char) {
    return 'Trước $char';
  }

  @override
  String get no_more_chapter => 'Không còn chương nào nữa';

  @override
  String get no_result => 'Không có kết quả';

  @override
  String get send => 'Gửi';

  @override
  String get delete => 'Xóa';

  @override
  String get start_downloading => 'Bắt đầu tải xuống ngay bây giờ';

  @override
  String get retry => 'Thử lại';

  @override
  String get add_chapters => 'Thêm chương';

  @override
  String get delete_chapters => 'Xóa chương?';

  @override
  String get default0 => 'Mặc định';

  @override
  String get total_chapters => 'Tổng số chương';

  @override
  String get total_episodes => 'Tổng số tập';

  @override
  String get import_local_file => 'Nhập tệp cục bộ';

  @override
  String get import_files => 'Tập tin';

  @override
  String get split_epub_chapters => 'Chia thành các chương';

  @override
  String get split_epub_chapters_description =>
      'Nhập từng chương EPUB dưới dạng một mục riêng biệt';

  @override
  String get nothing_read_recently => 'Gần đây không có gì đọc';

  @override
  String get status => 'Trạng thái';

  @override
  String get not_started => 'Chưa bắt đầu';

  @override
  String get score => 'Điểm';

  @override
  String get start_date => 'Ngày bắt đầu';

  @override
  String get finish_date => 'Ngày kết thúc';

  @override
  String get reading => 'Đọc sách';

  @override
  String get on_hold => 'Đang chờ';

  @override
  String get dropped => 'Đã đánh rơi';

  @override
  String get plan_to_read => 'Lên kế hoạch đọc sách';

  @override
  String get re_reading => 'Đọc lại';

  @override
  String get chapters => 'Chương';

  @override
  String get add_tracker => 'Thêm theo dõi';

  @override
  String get one_tracker => '1 người theo dõi';

  @override
  String n_tracker(Object n) {
    return '$n máy theo dõi';
  }

  @override
  String get tracking => 'Theo dõi';

  @override
  String get syncing => 'Đồng bộ hóa';

  @override
  String get sync_logged => 'Đăng nhập thành công';

  @override
  String get syncing_subtitle =>
      'Nhập địa chỉ máy chủ đồng bộ hóa của bạn và đăng nhập thông qua trình duyệt để đồng bộ hóa tiến trình đọc trên các thiết bị.';

  @override
  String get sync_service => 'Đồng bộ hóa tự lưu trữ';

  @override
  String get last_sync => 'Đồng bộ hóa lần cuối lúc: ';

  @override
  String get sync_login_browser => 'Đăng nhập bằng trình duyệt';

  @override
  String get sync_server => 'Địa chỉ máy chủ đồng bộ hóa';

  @override
  String get sync_starting => 'Đang bắt đầu đồng bộ hóa...';

  @override
  String get sync_finished => 'Đồng bộ hóa đã hoàn tất';

  @override
  String get sync_failed => 'Đồng bộ hóa không thành công';

  @override
  String get sync_restore_in_progress =>
      'Đồng bộ hóa bị bỏ qua — đang khôi phục';

  @override
  String sync_progress_percent(Object percent) {
    return 'Đang đồng bộ hóa… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Đang đồng bộ hóa…';

  @override
  String get sync_button_sync => 'Tiến trình đồng bộ hóa';

  @override
  String get sync_button_upload => 'Chỉ tải lên';

  @override
  String get sync_button_upload_info =>
      'Dữ liệu của thiết bị này sẽ ghi đè lên máy chủ đối với mọi thứ mà nó có. Không có gì trên máy chủ bị xóa.';

  @override
  String get sync_button_download => 'Chỉ tải xuống';

  @override
  String get sync_button_download_info =>
      'Lấy mọi thứ từ máy chủ. Không có gì trên thiết bị này bị xóa.';

  @override
  String get sync_status_not_configured => 'Chưa kết nối';

  @override
  String get sync_status_checking => 'Đang kiểm tra kết nối...';

  @override
  String get sync_status_connected => 'Đã kết nối';

  @override
  String get sync_status_unauthorized =>
      'Phiên đã hết hạn, vui lòng đăng nhập lại';

  @override
  String get sync_status_unreachable => 'Không thể truy cập máy chủ';

  @override
  String get sync_section_general => 'Tổng quát';

  @override
  String get sync_on => 'Bật đồng bộ hóa';

  @override
  String get sync_auto => 'Tự động đồng bộ hóa';

  @override
  String get sync_auto_warning =>
      'Tự động đồng bộ hóa hiện là tính năng thử nghiệm!';

  @override
  String get sync_auto_off => 'Tắt';

  @override
  String get sync_auto_5_minutes => 'Cứ sau 5 phút';

  @override
  String get sync_auto_10_minutes => 'Cứ sau 10 phút';

  @override
  String get sync_auto_30_minutes => '30 phút một lần';

  @override
  String get sync_auto_1_hour => 'Cứ sau 1 giờ';

  @override
  String get sync_auto_3_hours => 'Cứ sau 3 giờ';

  @override
  String get sync_auto_6_hours => 'Cứ sau 6 giờ';

  @override
  String get sync_auto_12_hours => 'Cứ sau 12 giờ';

  @override
  String get server_error => 'Lỗi máy chủ!';

  @override
  String get dialog_confirm => 'Xác nhận';

  @override
  String get description => 'Mô tả';

  @override
  String get reorder_navigation => 'Tùy chỉnh điều hướng';

  @override
  String get reorder_navigation_description =>
      'Sắp xếp lại và chuyển đổi từng điều hướng theo nhu cầu của bạn.';

  @override
  String get floating_navigation_bar => 'Thanh điều hướng nổi';

  @override
  String get floating_navigation_bar_description =>
      'Sử dụng hộp nổi thay vì thanh điều hướng kèm theo tiêu chuẩn.';

  @override
  String get full_screen_player => 'Sử dụng Toàn màn hình';

  @override
  String get full_screen_player_info =>
      'Tự động sử dụng toàn màn hình khi phát video.';

  @override
  String episode_progress(Object n) {
    return 'Tiến độ: $n';
  }

  @override
  String n_episodes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tập',
      one: '1 tập',
    );
    return '$_temp0';
  }

  @override
  String missing_episodes(Object count) {
    return 'Thiếu $count tập';
  }

  @override
  String get manga_sources => 'Nguồn truyện tranh';

  @override
  String get anime_sources => 'Nguồn Anime';

  @override
  String get novel_sources => 'Nguồn tiểu thuyết';

  @override
  String get anime_extensions => 'Phần mở rộng Anime';

  @override
  String get manga_extensions => 'Phần mở rộng truyện tranh';

  @override
  String get novel_extensions => 'Phần mở rộng tiểu thuyết';

  @override
  String get extension_settings => 'Cài đặt tiện ích mở rộng';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Truyện tranh';

  @override
  String get novel => 'Tiểu thuyết';

  @override
  String get library_no_category_exist => 'Bạn chưa có danh mục nào';

  @override
  String get watching => 'Đang xem';

  @override
  String get plan_to_watch => 'Lên kế hoạch xem';

  @override
  String get re_watching => 'Xem lại';

  @override
  String get episodes => 'Tập';

  @override
  String get download => 'Tải xuống';

  @override
  String get new_update_available => 'Đã có bản cập nhật mới';

  @override
  String app_version(Object v) {
    return 'Phiên bản ứng dụng: v$v';
  }

  @override
  String get searching_for_updates => 'Đang tìm kiếm thông tin cập nhật...';

  @override
  String get no_new_updates_available => 'Không có bản cập nhật mới';

  @override
  String get uninstall => 'Gỡ cài đặt';

  @override
  String uninstall_extension(Object ext) {
    return 'Gỡ cài đặt tiện ích mở rộng $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Nhấn đúp để tìm kiếm tất cả $type';
  }

  @override
  String get show_nav_double_tap_tooltip => 'Hiển thị gợi ý tìm kiếm nhấn đúp';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Hiển thị chú giải công cụ về đích điều hướng Manga/Anime/Tiểu thuyết giải thích rằng việc nhấn đúp sẽ mở Tìm kiếm chung.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" đã có trong thư viện của bạn qua $source.';
  }

  @override
  String get add_anyway => 'Dù sao cũng thêm';

  @override
  String get langauage => 'Ngôn ngữ';

  @override
  String get extension_detail => 'Chi tiết phần mở rộng';

  @override
  String get scale_type => 'Loại thang đo';

  @override
  String get scale_type_fit_screen => 'Vừa vặn với màn hình';

  @override
  String get scale_type_stretch => 'Căng';

  @override
  String get scale_type_fit_width => 'Chiều rộng phù hợp';

  @override
  String get scale_type_fit_height => 'Chiều cao phù hợp';

  @override
  String get scale_type_original_size => 'Kích thước gốc';

  @override
  String get scale_type_smart_fit => 'Phù hợp thông minh';

  @override
  String get page_preload_amount => 'Lượng tải trước trang';

  @override
  String get page_preload_amount_subtitle =>
      'Số lượng trang cần tải trước khi đọc. Giá trị cao hơn sẽ mang lại trải nghiệm đọc mượt mà hơn nhưng phải trả giá bằng mức sử dụng mạng và bộ nhớ đệm cao hơn.';

  @override
  String get image_loading_error => 'Không thể tải được hình ảnh này';

  @override
  String get add_episodes => 'Thêm tập';

  @override
  String get video_quality => 'Chất lượng';

  @override
  String get video_subtitle => 'Phụ đề';

  @override
  String get check_for_extension_updates =>
      'Kiểm tra các bản cập nhật tiện ích mở rộng của bên thứ ba';

  @override
  String get auto_extensions_updates =>
      'Tự động cập nhật tiện ích mở rộng của bên thứ ba';

  @override
  String get auto_extensions_updates_subtitle =>
      'Tự động cập nhật các tiện ích mở rộng đã cài đặt của bên thứ ba. Các plugin chính thức luôn được cài đặt và cập nhật tự động.';

  @override
  String get check_for_app_updates =>
      'Kiểm tra cập nhật ứng dụng khi khởi động';

  @override
  String get reading_mode => 'Chế độ đọc';

  @override
  String get custom_filter => 'Bộ lọc tùy chỉnh';

  @override
  String get background_color => 'Màu nền';

  @override
  String get white => 'Trắng';

  @override
  String get black => 'Đen';

  @override
  String get grey => 'Màu xám';

  @override
  String get automaic => 'Tự động';

  @override
  String get preferred_domain => 'Tên miền ưa thích';

  @override
  String get load_more => 'Tải thêm';

  @override
  String get cancel_all_for_this_series => 'Hủy tất cả cho loạt bài này';

  @override
  String get login => 'Đăng nhập';

  @override
  String login_into(Object tracker) {
    return 'Đăng nhập vào $tracker';
  }

  @override
  String get email_adress => 'Địa chỉ Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String log_out_from(Object tracker) {
    return 'Đăng xuất khỏi $tracker?';
  }

  @override
  String get log_out => 'Đăng xuất';

  @override
  String get update_pending => 'Đang chờ cập nhật';

  @override
  String get update_all => 'Cập nhật tất cả';

  @override
  String get backup_and_restore => 'Sao lưu và khôi phục';

  @override
  String get create_backup => 'Tạo bản sao lưu';

  @override
  String get create_backup_dialog_title => 'Bạn muốn sao lưu cái gì?';

  @override
  String get create_backup_subtitle =>
      'Có thể được sử dụng để khôi phục thư viện hiện tại';

  @override
  String get restore_backup => 'Khôi phục bản sao lưu';

  @override
  String get encrypt_backups => 'Mã hóa bản sao lưu';

  @override
  String get encrypt_backups_info =>
      'Tệp sao lưu được bảo vệ bằng mật khẩu bằng mã hóa AES';

  @override
  String get no_secure_storage => 'Không tìm thấy bộ nhớ an toàn';

  @override
  String get no_keyring_warning =>
      'Hệ thống này không có sẵn dịch vụ tạo khóa (ví dụ: gnome-keyring hoặc kwallet trên Linux), vì vậy mật khẩu không thể được lưu trữ an toàn.\n\nLưu trữ nó ở trạng thái không mã hóa trong cơ sở dữ liệu ứng dụng cục bộ? Bất kỳ ai có quyền truy cập vào dữ liệu ứng dụng của thiết bị này đều có thể đọc được.';

  @override
  String get enter_backup_password => 'Nhập mật khẩu dự phòng';

  @override
  String get incorrect_password_try_again =>
      'Mật khẩu không chính xác, hãy thử lại.';

  @override
  String get set_backup_password => 'Đặt mật khẩu sao lưu';

  @override
  String get confirm_password => 'Xác nhận mật khẩu';

  @override
  String get passwords_do_not_match => 'Mật khẩu không khớp';

  @override
  String get password_required_to_restore =>
      'Cần có mật khẩu để khôi phục bản sao lưu này.';

  @override
  String get restore_backup_subtitle => 'Khôi phục thư viện từ tập tin sao lưu';

  @override
  String get automatic_backups => 'Sao lưu tự động';

  @override
  String get backup_frequency => 'Tần số dự phòng';

  @override
  String get backup_location => 'Vị trí sao lưu';

  @override
  String get backup_options => 'Tùy chọn sao lưu';

  @override
  String get backup_options_dialog_title => 'Bạn muốn sao lưu cái gì?';

  @override
  String get backup_options_subtitle =>
      'Thông tin nào cần đưa vào tập tin sao lưu?';

  @override
  String get backup_and_restore_warning_info =>
      'Bạn cũng nên giữ bản sao lưu ở những nơi khác';

  @override
  String get library_entries => 'Mục thư viện';

  @override
  String get chapters_and_episode => 'Chương và tập';

  @override
  String get every_6_hours => 'Cứ sau 6 giờ';

  @override
  String get every_12_hours => 'Cứ sau 12 giờ';

  @override
  String get daily => 'Hàng ngày';

  @override
  String get every_2_days => '2 ngày một lần';

  @override
  String get weekly => 'Hàng tuần';

  @override
  String get restore_backup_warning_title =>
      'Khôi phục bản sao lưu sẽ ghi đè lên tất cả dữ liệu hiện có.\n\nTiếp tục khôi phục?';

  @override
  String get restore_sync_question_title =>
      'Đồng bộ hóa quá trình khôi phục này?';

  @override
  String get restore_sync_question_message =>
      'Thiết bị này được kết nối với máy chủ đồng bộ. Tải dữ liệu đã khôi phục này lên ngay bây giờ? Nếu không, đồng bộ hóa sẽ bị tắt để dữ liệu cũ của máy chủ không ghi đè lên những gì bạn vừa khôi phục.';

  @override
  String get restore_sync_question_confirm => 'Có, đồng bộ';

  @override
  String get restore_sync_question_deny => 'Không, tắt đồng bộ hóa';

  @override
  String get sync_disabled_after_restore =>
      'Đồng bộ hóa bị tắt. Bạn có thể bật lại trong Cài đặt.';

  @override
  String get restore_sync_disabled_question_title => 'Đồng bộ hóa hiện bị tắt';

  @override
  String get restore_sync_disabled_question_message =>
      'Đồng bộ hóa bị tắt. Bật lại và tải dữ liệu đã khôi phục này lên máy chủ của bạn?';

  @override
  String get restore_sync_question_reenable => 'Có, kích hoạt lại và đồng bộ';

  @override
  String get restore_sync_question_keep_disabled => 'Giữ nó bị vô hiệu hóa';

  @override
  String get restore_sync_uploading =>
      'Đang đồng bộ hóa dữ liệu đã khôi phục với máy chủ…';

  @override
  String get restore_sync_upload_success =>
      'Đã khôi phục dữ liệu được đồng bộ hóa với máy chủ';

  @override
  String get services => 'Dịch vụ';

  @override
  String get tracking_warning_info =>
      'Đồng bộ một chiều để cập nhật tiến trình chương trong các dịch vụ theo dõi. Thiết lập theo dõi cho từng mục từ nút theo dõi của chúng.';

  @override
  String get use_page_tap_zones => 'Sử dụng vùng nhấn trang';

  @override
  String get manage_trackers => 'Quản lý trình theo dõi';

  @override
  String get restore => 'Khôi phục';

  @override
  String get backups => 'Sao lưu';

  @override
  String get by_scanlator => 'Bằng máy scan';

  @override
  String get by_name => 'Theo tên';

  @override
  String get installed => 'Đã cài đặt';

  @override
  String get auto_scroll => 'Tự động cuộn';

  @override
  String get video_audio => 'Âm thanh';

  @override
  String get video_audio_info =>
      'Ngôn ngữ ưa thích, hiệu chỉnh cao độ, kênh âm thanh';

  @override
  String get player => 'Người chơi';

  @override
  String get markEpisodeAsSeenSetting =>
      'Tại thời điểm nào để đánh dấu tập phim là đã xem';

  @override
  String get mark_duplicate_chapters_read =>
      'Đánh dấu số chương trùng lặp là đã đọc';

  @override
  String get default_skip_intro_length => 'Thời lượng bỏ qua phần giới thiệu';

  @override
  String get default_playback_speed_length => 'Tốc độ phát lại mặc định';

  @override
  String get updateProgressAfterReading => 'Cập nhật tiến trình sau khi đọc';

  @override
  String get no_sources_installed => 'Không có nguồn nào được cài đặt!';

  @override
  String get show_extensions => 'Hiển thị tiện ích mở rộng';

  @override
  String get default_skip_forward_skip_length => 'Thời lượng tìm kiếm nhấn đúp';

  @override
  String get aniskip_requires_info =>
      'AniSkip yêu cầu anime phải được theo dõi bằng MAL hoặc Anilist để hoạt động.';

  @override
  String get enable_aniskip => 'Kích hoạt AniSkip';

  @override
  String get enable_auto_skip => 'Bật tự động bỏ qua';

  @override
  String get aniskip_button_timeout => 'Hết thời gian chờ nút';

  @override
  String get skip_opening => 'Bỏ qua việc mở';

  @override
  String get skip_ending => 'Bỏ qua phần kết';

  @override
  String get fullscreen => 'Toàn màn hình';

  @override
  String get update_library => 'Cập nhật thư viện';

  @override
  String get next_chapter => 'Chương tiếp theo';

  @override
  String get next_5_chapters => '5 chương tiếp theo';

  @override
  String get next_10_chapters => '10 chương tiếp theo';

  @override
  String get next_25_chapters => '25 chương tiếp theo';

  @override
  String get all_chapters => 'Tất cả các chương';

  @override
  String get next_episode => 'Tập tiếp theo';

  @override
  String get next_5_episodes => '5 tập tiếp theo';

  @override
  String get next_10_episodes => '10 tập tiếp theo';

  @override
  String get next_25_episodes => '25 tập tiếp theo';

  @override
  String get all_episodes => 'Tất cả các tập';

  @override
  String get cover_saved => 'Đã lưu bìa';

  @override
  String get set_as_cover => 'Đặt làm bìa';

  @override
  String get use_this_as_cover_art => 'Dùng cái này làm ảnh bìa?';

  @override
  String get save => 'Lưu';

  @override
  String get picture_saved => 'Đã lưu ảnh';

  @override
  String get cover_updated => 'Đã cập nhật bìa';

  @override
  String get include_subtitles => 'Bao gồm phụ đề';

  @override
  String get blend_mode_default => 'Mặc định';

  @override
  String get blend_mode_multiply => 'Nhân';

  @override
  String get blend_mode_screen => 'Màn hình';

  @override
  String get blend_mode_overlay => 'Lớp phủ';

  @override
  String get blend_mode_colorDodge => 'ColorDodge';

  @override
  String get blend_mode_lighten => 'Làm sáng';

  @override
  String get blend_mode_colorBurn => 'ColorBurn';

  @override
  String get blend_mode_darken => 'Làm tối';

  @override
  String get blend_mode_difference => 'Sự khác biệt';

  @override
  String get blend_mode_saturation => 'Độ bão hòa';

  @override
  String get blend_mode_softLight => 'Ánh Sáng Mềm Mại';

  @override
  String get blend_mode_plus => 'cộng thêm';

  @override
  String get blend_mode_exclusion => 'Loại trừ';

  @override
  String get custom_color_filter => 'Bộ lọc màu tùy chỉnh';

  @override
  String get color_filter_blend_mode => 'Chế độ hòa trộn bộ lọc màu';

  @override
  String get enable_all => 'Kích hoạt tất cả';

  @override
  String get disable_all => 'Tắt tất cả';

  @override
  String get font => 'Phông chữ';

  @override
  String get color => 'Màu sắc';

  @override
  String get font_size => 'Cỡ chữ';

  @override
  String get text => 'Văn bản';

  @override
  String get border => 'Biên giới';

  @override
  String get background => 'Bối cảnh';

  @override
  String get no_subtite_warning_message =>
      'Không có tác dụng vì không có bản phụ đề nào trong video này';

  @override
  String get grid_size => 'Kích thước lưới';

  @override
  String n_per_row(Object n) {
    return '$n mỗi hàng';
  }

  @override
  String get horizontal_continious => 'Ngang liên tục';

  @override
  String get edit_code => 'Chỉnh sửa mã';

  @override
  String get use_libass => 'Kích hoạt libass';

  @override
  String get use_libass_info =>
      'Sử dụng kết xuất phụ đề dựa trên libass cho phần phụ trợ gốc.';

  @override
  String get libass_not_disable_message =>
      'Tắt `use libass` trong cài đặt trình phát để có thể tùy chỉnh phụ đề.';

  @override
  String get override_ass_subtitles => 'Ghi đè phụ đề ASS';

  @override
  String get override_ass_subtitles_info =>
      'Áp dụng kiểu tùy chỉnh cho phụ đề ASS/SSA';

  @override
  String get torrent_stream => 'Dòng torrent';

  @override
  String get add_torrent => 'Thêm torrent';

  @override
  String get enter_torrent_hint_text => 'Nhập url tập tin magnet hoặc torrent';

  @override
  String get torrent_url => 'Url torrent';

  @override
  String get or => 'HOẶC';

  @override
  String get advanced => 'Nâng cao';

  @override
  String get advanced_info => 'mpv';

  @override
  String get use_native_http_client => 'Sử dụng ứng dụng khách http gốc';

  @override
  String get use_native_http_client_info =>
      'nó tự động hỗ trợ các tính năng nền tảng như VPN, hỗ trợ nhiều tính năng HTTP hơn như HTTP/3 và xử lý chuyển hướng tùy chỉnh';

  @override
  String n_hour_ago(Object hour) {
    return '$hour giờ trước';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours giờ trước';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute phút trước';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes phút trước';
  }

  @override
  String n_day_ago(Object day) {
    return '$day ngày trước';
  }

  @override
  String get now => 'bây giờ';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Thư viện cập nhật lần cuối: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Dữ liệu và lưu trữ';

  @override
  String get download_location_info => 'Được sử dụng để tải chương';

  @override
  String get storage => 'Lưu trữ';

  @override
  String get clear_chapter_and_episode_cache => 'Xóa bộ nhớ đệm chương và tập';

  @override
  String get cache_cleared => 'Đã xóa bộ nhớ đệm';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Xóa bộ nhớ đệm chương/tập khi khởi chạy ứng dụng';

  @override
  String get app_settings => 'Cài đặt ứng dụng';

  @override
  String get sources_settings => 'Cài đặt nguồn';

  @override
  String get include_sensitive_settings =>
      'Bao gồm các cài đặt nhạy cảm (ví dụ: mã thông báo đăng nhập trình theo dõi)';

  @override
  String get create => 'Tạo';

  @override
  String get downloads_are_limited_to_wifi => 'Tải xuống chỉ giới hạn ở Wi-Fi';

  @override
  String get recommendations => 'Khuyến nghị';

  @override
  String get recommendations_similar => 'tương tự';

  @override
  String get recommendations_weights => 'Trọng lượng khuyến nghị';

  @override
  String get recommendations_weights_genre => 'Sự tương đồng về thể loại';

  @override
  String get recommendations_weights_setting => 'Thiết lập tính tương tự';

  @override
  String get recommendations_weights_synopsis => 'Sự tương đồng của câu chuyện';

  @override
  String get recommendations_weights_theme => 'Tính tương đồng của chủ đề';

  @override
  String get manga_extensions_repo => 'Kho mở rộng manga';

  @override
  String get anime_extensions_repo => 'Kho phần mở rộng anime';

  @override
  String get novel_extensions_repo => 'Kho lưu trữ tiện ích mở rộng mới';

  @override
  String get custom_dns => 'DNS tùy chỉnh (để trống để sử dụng DNS hệ thống)';

  @override
  String get android_proxy_server =>
      'Máy chủ proxy Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Nhận M-Extension-Server';

  @override
  String get undefined => 'không xác định';

  @override
  String get empty_extensions_repo => 'Chưa có kho mở rộng';

  @override
  String get add_extensions_repo => 'Thêm kho lưu trữ URL';

  @override
  String get remove_extensions_repo => 'Xóa kho lưu trữ URL';

  @override
  String get manage_manga_repo_urls => 'Quản lý URL kho truyện tranh';

  @override
  String get manage_anime_repo_urls => 'Quản lý URL Repo Anime';

  @override
  String get manage_novel_repo_urls => 'Quản lý URL Repo mới';

  @override
  String get url_cannot_be_empty => 'URL không được để trống';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL phải kết thúc bằng .json / .pb';

  @override
  String get repo_url => 'URL';

  @override
  String get invalid_url_format => 'Định dạng URL không hợp lệ';

  @override
  String get clear_all_sources => 'Xóa tất cả các nguồn';

  @override
  String get clear_all_sources_msg =>
      'Thao tác này sẽ xóa hoàn toàn tất cả nguồn của ứng dụng. Bạn có chắc chắn muốn tiếp tục không?';

  @override
  String get sources_cleared => 'Đã xóa nguồn!!!';

  @override
  String get repo_added => 'Đã thêm kho lưu trữ nguồn!';

  @override
  String get repo_already_exists => 'Kho lưu trữ đã tồn tại!';

  @override
  String get add_repo => 'Thêm kho lưu trữ?';

  @override
  String get add_repo_sources_to_add =>
      'Danh sách tiện ích mở rộng sẽ được thêm vào:';

  @override
  String get add_repo_warning =>
      'Các tiện ích mở rộng từ các kho lưu trữ này chạy bên trong ứng dụng. Chỉ thêm các kho lưu trữ mà bạn tin tưởng.';

  @override
  String get genre_search_library => 'Tìm kiếm thể loại trong thư viện';

  @override
  String get genre_search_source => 'Duyệt trong nguồn';

  @override
  String get source_not_added => 'Nguồn chưa được cài đặt!';

  @override
  String get load_own_subtitles => 'Tải phụ đề của riêng bạn...';

  @override
  String get search_subtitles => 'Tìm kiếm phụ đề trực tuyến...';

  @override
  String extension_notes(Object notes) {
    return 'Ghi chú: $notes';
  }

  @override
  String get unsupported_repo =>
      'Không thể thêm kho lưu trữ nguồn này. Kiểm tra địa chỉ kho lưu trữ hoặc liên hệ với người bảo trì nó.';

  @override
  String get you_have_finished_reading => 'Bạn đã đọc xong';

  @override
  String get hwdec => 'Bộ giải mã phần cứng';

  @override
  String get enable_hardware_accel => 'Tăng tốc phần cứng';

  @override
  String get enable_hardware_accel_info =>
      'Bật/tắt nó nếu bạn gặp lỗi hoặc treo máy';

  @override
  String get track_library_navigate => 'Đi tới mục cục bộ hiện có';

  @override
  String get track_library_add => 'Thêm vào thư viện địa phương';

  @override
  String get track_library_add_confirm =>
      'Thêm mục được theo dõi vào thư viện cục bộ';

  @override
  String get track_library_not_logged =>
      'Đăng nhập vào trình theo dõi tương ứng để sử dụng tính năng này!';

  @override
  String get track_library_switch => 'Chuyển sang trình theo dõi khác';

  @override
  String get go_back => 'Quay lại';

  @override
  String get merge_library_nav_mobile =>
      'Hợp nhất điều hướng thư viện trên thiết bị di động';

  @override
  String get enable_discord_rpc => 'Kích hoạt Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Ẩn Discord RPC khi ở chế độ Ẩn danh';

  @override
  String get rpc_show_reading_watching_progress =>
      'Hiển thị chương hiện tại trong Discord (yêu cầu khởi động lại)';

  @override
  String get rpc_show_title => 'Hiển thị tiêu đề hiện tại trong Discord';

  @override
  String get rpc_show_cover_image => 'Hiển thị ảnh bìa hiện tại trong Discord';

  @override
  String get enable_mpv => 'Kích hoạt mpv trình đổ bóng / tập lệnh';

  @override
  String get mpv_info => 'Hỗ trợ tập lệnh .js trong mpv/scripts/';

  @override
  String get mpv_redownload => 'Tải xuống lại tập tin cấu hình mpv';

  @override
  String get mpv_redownload_info =>
      'Thay thế tập tin cấu hình cũ bằng tập tin mới!';

  @override
  String get mpv_download => 'MPV!\nTải xuống ngay bây giờ?';

  @override
  String get custom_buttons => 'Nút tùy chỉnh';

  @override
  String get custom_buttons_info => 'Thực thi mã lua bằng các nút tùy chỉnh';

  @override
  String get custom_buttons_edit => 'Chỉnh sửa các nút tùy chỉnh';

  @override
  String get custom_buttons_add => 'Thêm nút tùy chỉnh';

  @override
  String get custom_buttons_added => 'Đã thêm nút tùy chỉnh!';

  @override
  String get custom_buttons_delete => 'Xóa nút tùy chỉnh';

  @override
  String get custom_buttons_text => 'Văn bản nút';

  @override
  String get custom_buttons_text_req => 'Cần có văn bản nút';

  @override
  String get custom_buttons_js_code => 'mã lua';

  @override
  String get custom_buttons_js_code_req => 'yêu cầu mã lua';

  @override
  String get custom_buttons_js_code_long => 'mã lua (nhấn lâu)';

  @override
  String get custom_buttons_startup => 'mã lua (khi khởi động)';

  @override
  String get custom_buttons_add_warning =>
      'Nút này chạy mã Lua bên dưới trong trình phát video, mã này có thể truy cập các tệp của bạn và chạy chương trình. Chỉ thêm nó nếu bạn tin tưởng liên kết này đến từ đâu.';

  @override
  String n_days(Object n) {
    return '$n ngày';
  }

  @override
  String get decoder => 'Bộ giải mã';

  @override
  String get decoder_info => 'Giải mã phần cứng, định dạng pixel, gỡ lỗi';

  @override
  String get enable_gpu_next => 'Kích hoạt gpu-next (chỉ dành cho Android)';

  @override
  String get enable_gpu_next_info => 'Phần phụ trợ kết xuất video mới';

  @override
  String get debanding => 'Gỡ bỏ';

  @override
  String get use_yuv420p => 'Sử dụng định dạng pixel YUV420P';

  @override
  String get use_yuv420p_info =>
      'Có thể khắc phục màn hình đen trên một số codec video, cũng có thể cải thiện hiệu suất nhưng phải trả giá bằng chất lượng';

  @override
  String get audio_preferred_languages => 'Ngôn ngữ ưa thích';

  @override
  String get audio_preferred_languages_info =>
      'Ngôn ngữ âm thanh cần ưu tiên khi video có nhiều bản âm thanh. Sử dụng mã gồm hai hoặc ba chữ cái, phân tách bằng dấu phẩy (ví dụ: ja, en).';

  @override
  String get enable_audio_pitch_correction => 'Bật hiệu chỉnh cao độ âm thanh';

  @override
  String get enable_audio_pitch_correction_info =>
      'Ngăn âm thanh trở nên có âm vực cao ở tốc độ nhanh hơn và âm vực thấp ở tốc độ chậm hơn';

  @override
  String get audio_channels => 'Kênh âm thanh';

  @override
  String get volume_boost_cap => 'Giới hạn tăng âm lượng';

  @override
  String get internal_player => 'Trình phát nội bộ';

  @override
  String get internal_player_info => 'Tiến độ, điều khiển, định hướng';

  @override
  String get subtitle_delay_text => 'Độ trễ phụ đề';

  @override
  String get subtitle_delay => 'Độ trễ (ms)';

  @override
  String get subtitle_speed => 'Tốc độ';

  @override
  String get tracks => 'Bài hát';

  @override
  String get playback_speed => 'Tốc độ phát lại';

  @override
  String get shaders => 'Trình đổ bóng';

  @override
  String get video_fit => 'Phù hợp';

  @override
  String get calendar => 'Lịch';

  @override
  String get calendar_no_data => 'Chưa có dữ liệu.';

  @override
  String get calendar_info =>
      'Lịch chỉ có thể dự đoán chương tải lên tiếp theo dựa trên các chương trình tải lên cũ hơn. Một số dữ liệu có thể không chính xác 100%!';

  @override
  String in_n_day(Object days) {
    return 'trong $days ngày';
  }

  @override
  String in_n_days(Object days) {
    return 'sau $days ngày';
  }

  @override
  String get clear_library => 'Xóa thư viện';

  @override
  String get clear_library_desc =>
      'Chọn xóa tất cả các mục manga, anime và/hoặc tiểu thuyết';

  @override
  String get clear_library_input =>
      'Nhập \'manga\', \'anime\' và/hoặc \'tiểu thuyết\' (cách nhau bằng dấu phẩy) để xóa tất cả các mục liên quan';

  @override
  String get watch_order => 'Thứ tự xem';

  @override
  String get watch_order_role_current => 'Hiện tại';

  @override
  String get watch_order_role_previous => 'Trước đó';

  @override
  String get watch_order_role_next => 'Tiếp theo';

  @override
  String get watch_order_source_release_order => 'Lệnh phát hành';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name bởi $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Bộ sưu tập chính thức Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Các mùa cho $title';
  }

  @override
  String get watch_order_select_source => 'Nguồn đặt hàng';

  @override
  String watch_order_season(int number) {
    return 'Mùa $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Tập $number';
  }

  @override
  String get sequels => 'Phần tiếp theo';

  @override
  String get recommendations_similarity => 'Điểm tương đồng:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Đánh giá $rating';
  }

  @override
  String get local_folder_structure => 'Cấu trúc của một thư mục cục bộ';

  @override
  String get local_folder => 'Thư mục cục bộ';

  @override
  String get add_local_folder => 'Thêm thư mục cục bộ';

  @override
  String get rescan_local_folder =>
      'Quét lại tất cả các thư mục cục bộ ngay bây giờ';

  @override
  String get default_download_destination => 'Đích tải xuống mặc định';

  @override
  String get ask_download_destination => 'Hỏi đích tải xuống';

  @override
  String get ask_download_destination_desc =>
      'Chọn thư mục cục bộ mỗi lần bắt đầu tải xuống.';

  @override
  String get select_download_destination => 'Chọn đích tải xuống';

  @override
  String get clear_local_library => 'Xóa thư viện cục bộ';

  @override
  String get clear_local_library_desc =>
      'Xóa thư mục cục bộ và lưu trữ các mục khỏi thư viện.';

  @override
  String get clear_local_library_msg =>
      'Thao tác này sẽ xóa thư mục cục bộ và các mục lưu trữ khỏi thư viện của bạn. Nó sẽ không xóa các tập tin khỏi đĩa.';

  @override
  String get custom => 'Tùy chỉnh';

  @override
  String get no_local_folder_available_for_downloads =>
      'Không có thư mục cục bộ nào để tải xuống';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Không tạo được CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Lỗi đọc ảnh bìa: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Lỗi đọc siêu dữ liệu: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Lỗi lưu chương/tập vào thư viện: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Lỗi đọc ảnh bìa chương: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Lỗi đọc ảnh bìa kho lưu trữ: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Lỗi nhận thư viện cục bộ: $error';
  }

  @override
  String get export_metadata => 'Xuất siêu dữ liệu';

  @override
  String get exported => 'Đã xuất khẩu';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Không thể xuất siêu dữ liệu: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count (các) chương không thể được đánh số tự động và có thể không đúng thứ tự hoặc bị thiếu đối với người đọc.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Không thể khởi động Máy chủ Webview độ phân giải Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker Mã thông báo đã hết hạn';
  }

  @override
  String get video_list_empty => 'Danh sách video trống';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Không thể khởi chạy $url';
  }

  @override
  String get text_size => 'Kích thước văn bản:';

  @override
  String get text_align => 'Căn chỉnh văn bản';

  @override
  String get line_height => 'Chiều cao dòng';

  @override
  String get show_scroll_percentage => 'Hiển thị phần trăm cuộn';

  @override
  String get remove_extra_paragraph_spacing => 'Xóa khoảng cách đoạn bổ sung';

  @override
  String select_label_color(Object label) {
    return 'Chọn $label Màu';
  }

  @override
  String get default_user_agent => 'Tác nhân người dùng mặc định';

  @override
  String get forceLandscapeMode => 'Buộc chế độ ngang';

  @override
  String get forceLandscapeModeSubtitle =>
      'Buộc người chơi sử dụng hướng ngang.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Nhà cung cấp DNS';

  @override
  String get tracked => 'Đã theo dõi';

  @override
  String get auth_unlock_msg => 'Xác thực để mở khóa ứng dụng';

  @override
  String get app_locked => 'Ứng dụng đã bị khóa';

  @override
  String get auth_to_continue => 'Xác thực để tiếp tục';

  @override
  String get authenticating => 'Đang xác thực...';

  @override
  String get lock => 'Khóa';

  @override
  String get unlock => 'Mở khóa';

  @override
  String get security => 'Bảo mật';

  @override
  String get auth_to_change_security_setting =>
      'Xác thực để thay đổi cài đặt bảo mật';

  @override
  String get app_lock => 'Khóa ứng dụng';

  @override
  String get require_biometric_or_device_credential =>
      'Yêu cầu thông tin sinh trắc học hoặc thông tin xác thực thiết bị để mở ứng dụng';

  @override
  String get biometric_or_device_credential_not_available =>
      'Xác thực sinh trắc học hoặc thông tin xác thực thiết bị không khả dụng trên thiết bị này';

  @override
  String get app_lock_description =>
      'Khi khóa ứng dụng được bật, bạn sẽ được yêu cầu xác thực mỗi khi bạn mở ứng dụng hoặc quay lại ứng dụng đó từ nền.';

  @override
  String get checking_device_authentication =>
      'Đang kiểm tra xác thực thiết bị…';

  @override
  String get device_authentication_incomplete =>
      'Xác thực chưa hoàn tất. Cài đặt của bạn không thay đổi.';

  @override
  String get keep_screen_on => 'Giữ màn hình luôn bật';

  @override
  String get webtoon_side_padding => 'Phần đệm bên webtoon';

  @override
  String get show_page_gaps => 'Hiển thị khoảng trống trang';

  @override
  String get invert_colors => 'Đảo ngược màu sắc';

  @override
  String get grayscale => 'Thang màu xám';

  @override
  String get brightness => 'Độ sáng';

  @override
  String get contrast => 'Độ tương phản';

  @override
  String get saturation => 'Độ bão hòa';

  @override
  String get navigation_layout => 'Bố cục điều hướng';

  @override
  String get nav_layout_default => 'Mặc định';

  @override
  String get nav_layout_l_shaped => 'Hình chữ L';

  @override
  String get nav_layout_kindle => 'Kindle-ish';

  @override
  String get nav_layout_edge => 'Cạnh';

  @override
  String get nav_layout_right_and_left => 'Phải và trái';

  @override
  String get nav_layout_disabled => 'Bị vô hiệu hóa';

  @override
  String get color_enhancements => 'Cải tiến màu sắc';

  @override
  String get total => 'Tổng cộng';

  @override
  String get mean_per_title => 'Trung bình mỗi Tiêu đề';

  @override
  String get completion_rate => 'Tỷ lệ hoàn thành';

  @override
  String get watching_time => 'Thời gian xem';

  @override
  String get reading_time => 'Giờ đọc';

  @override
  String average_chapters_per_title(Object title) {
    return 'Số chương trung bình trên $title';
  }

  @override
  String get read_percentage => 'Tỷ lệ đọc';

  @override
  String get entries => 'Mục nhập';

  @override
  String get android_proxy_server_mihon => 'Máy chủ proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Tải xuống và định cấu hình máy chủ proxy cần thiết để sử dụng tiện ích mở rộng Mihon.';

  @override
  String get mihon_proxy_server => 'Máy chủ proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Tải xuống gói máy chủ proxy trước khi sử dụng tiện ích mở rộng Mihon. Gói này bao gồm JRE và JAR máy chủ mở rộng.';

  @override
  String get extension_server_intro_ios =>
      'Tải xuống JAR máy chủ proxy trước khi sử dụng tiện ích mở rộng Mihon. iOS chỉ cần máy chủ mở rộng JAR.';

  @override
  String get checking_files => 'Đang kiểm tra tập tin';

  @override
  String get files_installed => 'Các tập tin đã được cài đặt';

  @override
  String get files_missing => 'Thiếu tập tin';

  @override
  String get update_files => 'Cập nhật tập tin';

  @override
  String get up_to_date => 'Cập nhật';

  @override
  String get choose_location => 'Chọn vị trí';

  @override
  String get import_existing_jar => 'Nhập JAR hiện có';

  @override
  String get detect_files_in_selected_folder =>
      'Phát hiện tập tin trong thư mục đã chọn';

  @override
  String get preparing_download => 'Đang chuẩn bị tải xuống...';

  @override
  String get app_install_location => 'Vị trí cài đặt ứng dụng';

  @override
  String get install_location => 'Vị trí cài đặt';

  @override
  String get jre_executable => 'JRE có thể thực thi được';

  @override
  String get extension_server_jar => 'JAR máy chủ mở rộng';

  @override
  String get installed_version => 'Phiên bản đã cài đặt';

  @override
  String get latest_version => 'Phiên bản mới nhất';

  @override
  String get m_extension_server_description =>
      'Sử dụng M-Extension-Server khi bạn cần proxy thiết bị Android riêng. Đặt địa chỉ proxy tại đây và tải xuống APK từ GitHub.';

  @override
  String get set_proxy_address => 'Đặt địa chỉ proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'Không có bản phát hành máy chủ proxy mới hơn.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Không thể kiểm tra các bản cập nhật máy chủ proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Không có gói máy chủ mở rộng nào có sẵn cho nền tảng này.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Không tải được gói xuống ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Gói đã tải xuống không chứa các tệp dự kiến.';

  @override
  String get extension_server_files_ready => 'Tệp máy chủ mở rộng đã sẵn sàng.';

  @override
  String get ios_extension_server_import_hint =>
      'Trên iOS, máy chủ được cài đặt bên trong hộp cát ứng dụng. Sử dụng \"Nhập JAR hiện có\" để đưa tệp đã tải xuống vào.';

  @override
  String get select_extension_server_folder => 'Chọn thư mục máy chủ mở rộng';

  @override
  String get selected_folder_does_not_exist => 'Thư mục đã chọn không tồn tại.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Không tìm thấy tệp máy chủ mở rộng nào trong thư mục đã chọn.';

  @override
  String get extension_server_files_linked =>
      'Các tệp máy chủ mở rộng đã được liên kết.';

  @override
  String get select_extension_server_jar => 'Chọn máy chủ mở rộng JAR';

  @override
  String get selected_file_could_not_be_accessed =>
      'Không thể truy cập được tệp đã chọn.';

  @override
  String get extension_server_jar_imported =>
      'JAR máy chủ mở rộng đã được nhập.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Không thể khởi chạy trang M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP máy chủ (ví dụ: 10.0.0.5 hoặc https://example.com)';

  @override
  String get not_configured => 'Chưa được định cấu hình';

  @override
  String get zero_interpreter => 'Không có thông dịch viên';

  @override
  String get zero_interpreter_description =>
      'Điều khiển máy chủ thông dịch Zero tự động hoặc thủ công.';

  @override
  String get start_server_on_launch => 'Khởi động máy chủ khi khởi chạy';

  @override
  String get runtime_status => 'Trạng thái thời gian chạy';

  @override
  String get running => 'Đang chạy';

  @override
  String get stopped => 'Đã dừng';

  @override
  String get start => 'Bắt đầu';

  @override
  String get stop => 'Dừng lại';

  @override
  String get webview => 'Xem web';

  @override
  String get tts => 'Chuyển văn bản thành giọng nói';

  @override
  String get tts_speed => 'Tốc độ';

  @override
  String get tts_pitch => 'Sân';

  @override
  String get tts_language => 'Ngôn ngữ';

  @override
  String get tts_voice => 'Giọng nói';

  @override
  String get tts_stop => 'Dừng lại';

  @override
  String get tts_play => 'Chơi';

  @override
  String get tts_pause => 'Tạm dừng';

  @override
  String get tts_previous => 'Đoạn trước';

  @override
  String get tts_next => 'Đoạn tiếp theo';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Đoạn $current của $total';
  }

  @override
  String get tts_settings => 'Cài đặt TTS';

  @override
  String get tts_default => 'Mặc định';

  @override
  String get webtoon_disable_zoom_out => 'Webtoon vô hiệu hóa thu nhỏ';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Nhấn đúp vào webtoon để thu phóng';

  @override
  String get navigate_to_pan => 'Điều hướng đến xoay';

  @override
  String get navigate_to_pan_subtitle =>
      'Di chuyển hình ảnh đã phóng to trước khi lật trang';

  @override
  String get split_wide_pages => 'Chia trang rộng';

  @override
  String get dual_page_invert => 'Đảo ngược cắt nửa trang';

  @override
  String get dual_page_rotate_to_fit => 'Xoay cho vừa';

  @override
  String get dual_page_rotate_to_fit_invert => 'Đảo ngược hướng quay';

  @override
  String get double_page_single_first_page => 'Trang đầu tiên';

  @override
  String get double_page_single_first_page_subtitle =>
      'Chỉ hiển thị trang đầu tiên ở chế độ trang đôi';

  @override
  String get double_page_auto => 'Trang đôi tự động';

  @override
  String get double_page_auto_subtitle =>
      'Tự động chuyển sang chế độ trang đôi theo chiều ngang';

  @override
  String get landscape_zoom => 'Tự động thu phóng phong cảnh';

  @override
  String get zoom_start_position => 'Vị trí bắt đầu thu phóng';

  @override
  String get zoom_start_left => 'Còn lại';

  @override
  String get zoom_start_right => 'Đúng rồi';

  @override
  String get zoom_start_center => 'Trung tâm';

  @override
  String get automatic_background => 'Nền tự động';

  @override
  String get tapping_inversion => 'Khai thác đảo ngược';

  @override
  String get tapping_inversion_none => 'Không có';

  @override
  String get tapping_inversion_horizontal => 'Ngang';

  @override
  String get tapping_inversion_vertical => 'Dọc';

  @override
  String get tapping_inversion_both => 'Cả hai';

  @override
  String get flash_on_page_change => 'Flash khi thay đổi trang';

  @override
  String get flash_on_page_change_subtitle => 'Trợ giúp chống lưu giữ AMOLED';

  @override
  String get flash_color => 'Màu đèn nháy';

  @override
  String get flash_color_black => 'Đen';

  @override
  String get flash_color_white => 'Trắng';

  @override
  String get flash_color_white_black => 'Trắng & Đen';

  @override
  String get flash_interval_label => 'Khoảng thời gian nhấp nháy';

  @override
  String flash_interval_value(String n) {
    return '$n trang';
  }

  @override
  String flash_interval(String n) {
    return 'Khoảng thời gian flash: $n trang';
  }

  @override
  String get flash_duration_label => 'Thời lượng Flash';

  @override
  String flash_duration_value(String n) {
    return '$n ms';
  }

  @override
  String flash_duration(String n) {
    return 'Thời lượng flash: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Hiển thị lớp phủ điều hướng khi khởi động';

  @override
  String get reader_hide_threshold => 'Ngưỡng ẩn đầu đọc';

  @override
  String get reader_hide_threshold_highest => 'Cao nhất (5 px)';

  @override
  String get reader_hide_threshold_high => 'Cao (13 px)';

  @override
  String get reader_hide_threshold_low => 'Thấp (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Thấp nhất (47 px)';

  @override
  String get error_no_pages_available => 'Lỗi: không có trang nào';

  @override
  String get app_ui_scale => 'Thang đo giao diện';

  @override
  String get app_ui_scale_subtitle =>
      'Làm cho giao diện lớn hơn hoặc nhỏ hơn để phù hợp với màn hình và khoảng cách xem của bạn.';

  @override
  String get allow_concurrent_downloads => 'Cho phép tải xuống đồng thời';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Tải xuống từ nhiều nguồn khác nhau cùng một lúc. Một nguồn vẫn tải từng chương một nên không bị quá tải. Tắt để tải xuống từng cái một ở mọi nơi.';

  @override
  String get download_delay => 'Độ trễ tải xuống';

  @override
  String get download_delay_subtitle =>
      'Tắt. Thêm thời gian chờ với hiện tượng giật ngẫu nhiên giữa các chương để sử dụng nguồn nhẹ nhàng hơn.';

  @override
  String get save_search => 'Lưu tìm kiếm';

  @override
  String get saved_searches => 'Tìm kiếm đã lưu';

  @override
  String get enter_search_to_save_first => 'Nhập tìm kiếm để lưu trước';

  @override
  String get no_saved_searches =>
      'Chưa có tìm kiếm nào được lưu cho nguồn này.\nThực hiện tìm kiếm rồi chọn \"Lưu tìm kiếm\".';

  @override
  String get source => 'Nguồn';

  @override
  String get something_went_wrong => 'Đã xảy ra lỗi';

  @override
  String get startup_failed =>
      'NodeLane Comics không thể hoàn tất quá trình khởi động';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nguồn không có kết quả',
      one: '1 nguồn không có kết quả',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Cái này nên được nhập như thế nào?';

  @override
  String get import_mode_message =>
      'Chọn hợp nhất bản sao lưu này vào thư viện hiện tại của bạn hay thay thế toàn bộ thư viện của bạn bằng nó.';

  @override
  String get import_mode_keep_existing => 'Hợp nhất';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Thêm chuỗi mới và cập nhật các chuỗi phù hợp. Không có gì trong thư viện hiện tại của bạn bị xóa.';

  @override
  String get import_mode_replace => 'Thay thế';

  @override
  String get import_mode_replace_subtitle =>
      'Xóa toàn bộ thư viện hiện tại của bạn và thay thế nó bằng bản sao lưu này.';

  @override
  String get replace_summary_title => 'Sẵn sàng thay thế thư viện của bạn';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Thao tác này sẽ xóa toàn bộ thư viện hiện tại của bạn (chuỗi $currentCount) và thay thế nó bằng chuỗi $backupCount từ bản sao lưu này. Điều này chỉ có thể được hoàn tác bằng cách quay lại.';
  }

  @override
  String get replace_summary_confirm => 'Thay thế';

  @override
  String replace_result_message(Object count) {
    return 'Đã thay thế thư viện của bạn bằng chuỗi $count từ bản sao lưu này.';
  }

  @override
  String get category_conflict_title => 'Đã tìm thấy danh mục hiện có';

  @override
  String get category_conflict_message =>
      'Bản sao lưu có các danh mục đã tồn tại trong thư viện của bạn. Tiếp tục xếp các loạt bài sắp tới vào danh mục hiện có hoặc xóa để thay vào đó, các loạt bài đó không được phân loại.';

  @override
  String get category_conflict_keep => 'Keep — hợp nhất vào danh mục hiện có';

  @override
  String get category_conflict_delete =>
      'Xóa — để lại chuỗi không được phân loại';

  @override
  String get source_conflict_title => 'Không tìm thấy nguồn';

  @override
  String get source_conflict_message =>
      'Các nguồn dự phòng này không khớp với tiện ích mở rộng đã cài đặt. Giữ nguyên tên gốc (được nhập mà không có nguồn hoạt động) hoặc di chuyển sang tiện ích mở rộng đã cài đặt để có thể cập nhật các chuỗi này.';

  @override
  String get source_conflict_keep =>
      'Giữ nguyên tên gốc (không có nguồn trực tiếp)';

  @override
  String get import_summary_title => 'Sẵn sàng nhập khẩu';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries bộ truyện mới, $updatedSeries bộ truyện hiện có sẽ được cập nhật và $newChapters chương mới sẽ được thêm vào. Không có nội dung nào đã có trong thư viện của bạn sẽ bị xóa.';
  }

  @override
  String get import_summary_confirm => 'Nhập khẩu';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Đã nhập $newSeries bộ truyện mới, cập nhật $updatedSeries hiện có, thêm $newChapters chương mới.';
  }

  @override
  String get roll_back => 'Quay lại';

  @override
  String get roll_back_confirm_message =>
      'Thao tác này sẽ khôi phục thư viện của bạn về ảnh chụp nhanh an toàn được thực hiện ngay trước khi thay đổi này, hoàn tác mọi thao tác vừa thực hiện.';

  @override
  String get roll_back_done =>
      'Được khôi phục về ảnh chụp nhanh trước khi thay đổi.';

  @override
  String get restoring_backup => 'Đang khôi phục thư viện của bạn…';

  @override
  String get roll_back_last_change => 'Quay lại thay đổi cuối cùng';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Ảnh chụp nhanh từ $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count những thay đổi gần đây có sẵn để quay lại';
  }

  @override
  String get delete_source_title => 'Xóa một nguồn và manga của nó';

  @override
  String get delete_source_subtitle =>
      'Chọn một nguồn và xóa mọi manga có trong thư viện của bạn, cùng với các chương, nội dung tải xuống, lịch sử và theo dõi của chúng.';

  @override
  String get delete_source_pick_title => 'Chọn nguồn cần xóa';

  @override
  String get delete_source_empty =>
      'Không tìm thấy nguồn nào trong thư viện của bạn.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Xóa $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Thao tác này sẽ xóa vĩnh viễn $mangaCount manga, $chapterCount chương, $historyCount mục lịch sử và $updateCount mục cập nhật. Liên kết theo dõi được lưu giữ. Điều này không thể được hoàn tác ngoại trừ bằng cách quay lại.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Đồng thời xóa tiện ích mở rộng đã cài đặt';

  @override
  String get delete_source_keep_history => 'Giữ lịch sử đọc';

  @override
  String get delete_source_keep_downloads => 'Lưu giữ hồ sơ tải xuống';

  @override
  String get delete_source_button => 'Xóa';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Đã xóa truyện tranh $mangaCount khỏi $sourceName.';
  }

  @override
  String get merge_manga_title => 'Hợp nhất các manga trùng lặp';

  @override
  String get merge_manga_subtitle =>
      'Tìm manga có tựa đề phù hợp trong cùng một nguồn (ví dụ: sau khi hợp nhất các nguồn trùng lặp) và gộp chúng lại thành một mà không xóa bất kỳ nội dung nào bạn muốn giữ lại.';

  @override
  String get merge_manga_none_found => 'Không tìm thấy manga trùng lặp.';

  @override
  String get merge_manga_pick_title => 'Manga có thể bị trùng lặp';

  @override
  String get merge_manga_choose_primary_title =>
      'Những cái khác nên hợp nhất vào cái nào?';

  @override
  String get merge_manga_choose_primary_message =>
      'Các chương, lịch sử và theo dõi từ các mục khác sẽ được xếp vào bất kỳ mục nào bạn chọn - không có gì bị xóa.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chương',
      one: '1 chương',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Hợp nhất';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Hợp nhất $count manga trùng lặp vào $mangaName.';
  }

  @override
  String get merge_preview_title => 'Xác nhận hợp nhất';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters chương được tìm thấy trong các mục khác. $duplicateChapters là bản sao và sẽ bị loại bỏ (giữ bản sao nào có tiến trình đọc); $keptChapters sẽ được thêm vào. $duplicateTracks (các) liên kết theo dõi trùng lặp cũng sẽ bị loại bỏ.';
  }

  @override
  String get memory_overlay => 'Hiển thị mức sử dụng bộ nhớ';

  @override
  String get memory_overlay_subtitle =>
      'Bản đọc trực tiếp về nội dung mà ứng dụng đang nắm giữ. Để đo trên thiết bị thay vì đoán: xem nó trong khi cuộn thư viện hoặc đọc một chương.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Báo cáo lỗi';

  @override
  String get error_reports_subtitle => 'Ứng dụng gặp lỗi và cách báo cáo';

  @override
  String get error_reports_empty =>
      'Không có gì sai cả. Các lỗi mà ứng dụng phát hiện được lưu giữ ở đây để bạn có thể báo cáo.';

  @override
  String get error_reports_likely_cause => 'Nguyên nhân có thể';

  @override
  String get error_reports_report => 'Báo cáo trên GitHub';

  @override
  String get error_reports_banner => 'NodeLane Comics đã gặp lỗi';

  @override
  String get error_reports_banner_action => 'Xem nó';

  @override
  String get error_reports_copy => 'Sao chép';

  @override
  String get error_reports_copied => 'Đã sao chép vào bảng nhớ tạm';

  @override
  String get error_reports_clear => 'Xóa';

  @override
  String get error_reports_extension_failure =>
      'Điều này đến từ một tiện ích mở rộng, không phải từ NodeLane Comics. Tiện ích mở rộng được viết và duy trì bởi bất kỳ ai chạy kho lưu trữ mà bạn đã cài đặt nguồn này từ đó, vì vậy cần phải có bản sửa lỗi ở đó. Tên nguồn và nội dung bạn đang mở là những chi tiết hữu ích để cung cấp cho họ.';

  @override
  String get error_reports_already_reported => 'Đã báo cáo';

  @override
  String get error_reports_expected_failure =>
      'Đây thường là nguồn hoặc mạng chứ không phải là ứng dụng: liên kết đã hết hạn, máy chủ không hoạt động hoặc kết nối bị ngắt. Chỉ đáng báo cáo nếu nó tiếp tục xảy ra trên một nguồn hoạt động ở nơi khác.';

  @override
  String get share_unavailable_copied =>
      'Tính năng chia sẻ không khả dụng trên nền tảng này nên thay vào đó, nó đã được sao chép vào bảng nhớ tạm.';

  @override
  String get onboarding_title => 'Chào mừng đến với NodeLane Comics';

  @override
  String get onboarding_libraries_body =>
      'Chọn những gì bạn đọc và xem. Những cái bạn loại bỏ sẽ nằm ngoài thanh điều hướng và bạn có thể thay đổi điều này sau trong Giao diện.';

  @override
  String get onboarding_nav_title => 'Thư viện của bạn';

  @override
  String get onboarding_nav_body =>
      'Giữ một tab cho mỗi tab hoặc đặt chúng lại với nhau sau một tab Thư viện mà bạn có thể chuyển đổi bên trong.';

  @override
  String get onboarding_nav_split => 'Mỗi tab một tab';

  @override
  String get onboarding_nav_merged => 'Một tab Thư viện';

  @override
  String get onboarding_nav_inside =>
      'Khai thác Thư viện sẽ hoán đổi thanh cho những thứ này';

  @override
  String get onboarding_next => 'Tiếp theo';

  @override
  String get onboarding_restore => 'Khôi phục bản sao lưu';

  @override
  String get onboarding_or_local => 'Hoặc sử dụng các file bạn đã có';

  @override
  String get onboarding_local_folder => 'Thêm thư mục';

  @override
  String onboarding_local_existing(Object count) {
    return '$count thư mục đã được thiết lập';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime và tiểu thuyết đều có tác dụng. Mỗi tiêu đề sẽ được chuyển đến đúng thư viện dựa trên nội dung bên trong nó.';

  @override
  String get onboarding_local_scanning => 'Đang quét thư mục';

  @override
  String onboarding_local_found(Object count) {
    return '$count tìm thấy tiêu đề';
  }

  @override
  String get onboarding_local_remove => 'Xóa thư mục đó';

  @override
  String get onboarding_local_in_downloads =>
      'Đó là thư mục tải xuống của ứng dụng. Việc thêm nó sẽ tạo ra bản sao cục bộ thứ hai của thư viện mà ứng dụng đã quản lý.';

  @override
  String get onboarding_local_empty =>
      'Không tìm thấy gì. Chọn thư mục chứa các thư mục manga của bạn chứ không phải một manga.';

  @override
  String get onboarding_repo_failed =>
      'Không thể đọc kho lưu trữ đó. Kiểm tra địa chỉ và kết nối của bạn.';

  @override
  String get onboarding_repo_title => 'Thêm nguồn';

  @override
  String get onboarding_body =>
      'NodeLane Comics không có nguồn riêng. Thêm một kho lưu trữ và các tiện ích mở rộng trong đó sẽ có sẵn để cài đặt và duyệt qua.';

  @override
  String get onboarding_add => 'Thêm kho lưu trữ';

  @override
  String get onboarding_skip => 'Tạm thời bỏ qua';

  @override
  String get onboarding_continue => 'Tiếp tục';

  @override
  String get onboarding_later =>
      'Bạn có thể thêm một tài khoản sau trong Cài đặt, trong Duyệt.';

  @override
  String get onboarding_replay => 'Hiển thị màn hình chào mừng';

  @override
  String get onboarding_replay_subtitle =>
      'Mở lại màn hình chạy lần đầu, màn hình cài đặt mới sẽ bắt đầu.';

  @override
  String get missing_source_check_title => 'Kiểm tra các nguồn bị thiếu';

  @override
  String get missing_source_check_subtitle =>
      'Tìm các mục trong thư viện có tiện ích mở rộng chưa được cài đặt - việc khôi phục bản sao lưu có thể để lại các mục trỏ đến nguồn mà bạn chưa từng cài đặt trên thiết bị này.';

  @override
  String get missing_source_check_none_found =>
      'Nguồn của mọi mục thư viện đều được cài đặt.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nguồn bị thiếu',
      one: 'Thiếu 1 nguồn',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Không có nguồn $itemType nào được cài đặt.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Thêm kho lưu trữ trong Duyệt qua, sau đó cài đặt tiện ích mở rộng cho nó.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nguồn',
      one: '1 nguồn',
    );
    return 'Bạn có $_temp0 cho mục này nhưng chỉ những cái được ghim mới được tìm kiếm.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Ghim một hoặc tắt \"Chỉ bao gồm các nguồn được ghim\" trong cài đặt Duyệt.';

  @override
  String get global_search_all_nsfw =>
      'Mọi nguồn bạn có cho việc này đều được đánh dấu NSFW và những nguồn đó đều bị ẩn.';

  @override
  String get global_search_all_nsfw_hint =>
      'Bật nguồn NSFW trong cài đặt Duyệt để tìm kiếm chúng.';

  @override
  String get missing_source_check_result_message =>
      'Các mục nhập thư viện này trỏ đến một nguồn chưa được cài đặt trên thiết bị này. Nhấn vào một cái để di chuyển nó sang nguồn đã cài đặt, cài đặt tiện ích mở rộng phù hợp hoặc sử dụng \"Xóa nguồn và manga của nó\" để xóa chúng.';

  @override
  String get related_titles => 'Liên quan';

  @override
  String get related_none => 'Không tìm thấy gì liên quan cho tiêu đề này.';

  @override
  String get relation_adaptation => 'Chuyển thể';

  @override
  String get relation_sequel => 'Phần tiếp theo';

  @override
  String get relation_prequel => 'Phần tiền truyện';

  @override
  String get relation_parent => 'Chuyện cha mẹ';

  @override
  String get relation_side_story => 'Chuyện bên lề';

  @override
  String get relation_spin_off => 'Ngoại truyện';

  @override
  String get relation_alternative => 'Phiên bản thay thế';

  @override
  String get auto_library_update => 'Cập nhật thư viện tự động';

  @override
  String get auto_library_update_subtitle =>
      'Kiểm tra mọi mục trong thư viện của bạn để tìm các chương mới khi ứng dụng khởi động.';

  @override
  String get auto_library_update_never => 'Không bao giờ';

  @override
  String get auto_library_update_12_hours => 'Cứ sau 12 giờ';

  @override
  String get auto_library_update_daily => 'Hàng ngày';

  @override
  String get auto_library_update_2_days => '2 ngày một lần';

  @override
  String get auto_library_update_weekly => 'Hàng tuần';

  @override
  String get auto_library_update_wifi_only => 'Chỉ trên Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Bỏ qua cập nhật theo lịch khi sử dụng dữ liệu di động.';

  @override
  String get padding => 'Đệm';

  @override
  String get page_mode => 'Chế độ trang';

  @override
  String get single_page => 'Trang đơn';

  @override
  String get double_page => 'Trang đôi';

  @override
  String get speed => 'Tốc độ';

  @override
  String get theme_dark => 'Tối';

  @override
  String get theme_light => 'Ánh sáng';

  @override
  String get theme_black => 'Đen';

  @override
  String get theme_sepia => 'Màu nâu đỏ';

  @override
  String get decrease => 'Giảm';

  @override
  String get increase => 'Tăng';

  @override
  String get chapter_swipe_actions => 'Thao tác vuốt chương';

  @override
  String get chapter_swipe_start => 'Vuốt sang phải';

  @override
  String get chapter_swipe_end => 'Vuốt sang trái';

  @override
  String get chapter_swipe_toggle_bookmark => 'Chuyển đổi dấu trang';

  @override
  String get chapter_swipe_toggle_read => 'Chuyển đổi đọc';

  @override
  String get chapter_swipe_download => 'Tải xuống';

  @override
  String get chapter_swipe_disabled => 'Bị vô hiệu hóa';

  @override
  String get update_errors => 'Lỗi cập nhật';

  @override
  String get no_update_errors => 'Không có lỗi cập nhật';

  @override
  String get clear_all => 'Xóa tất cả';

  @override
  String get dismiss => 'Loại bỏ';

  @override
  String get previous_episode => 'Tập trước';

  @override
  String get clear_logs => 'Xóa nhật ký';

  @override
  String get bold => 'Đậm';

  @override
  String get italic => 'Nghiêng';

  @override
  String get color_yellow => 'Màu vàng';

  @override
  String get color_cyan => 'Lục lam';

  @override
  String get color_green => 'Màu xanh lá cây';

  @override
  String get color_orange => 'Cam';

  @override
  String get continue_watching => 'Tiếp tục xem';

  @override
  String get search_your_anime => 'Tìm kiếm phim hoạt hình của bạn';

  @override
  String get category => 'Danh mục';

  @override
  String get hidden_categories => 'Danh mục ẩn';

  @override
  String get new_category => 'Danh mục mới';

  @override
  String get local => 'Địa phương';

  @override
  String get tv_home_rows => 'Hàng';

  @override
  String get genre_rows => 'Hàng thể loại';

  @override
  String get share_backup_file => 'Chia sẻ tập tin sao lưu NodeLane Comics';

  @override
  String get close => 'Đóng';

  @override
  String get migrate_source => 'Di chuyển nguồn';

  @override
  String get cloudflare_bypass_proxy => 'Proxy bỏ qua Cloudflare';

  @override
  String get custom_doh_url => 'DoH tùy chỉnh URL';

  @override
  String get custom_doh_url_helper => 'Phải là điểm cuối https DoH (JSON)';

  @override
  String get anime_only_tv_layout => 'Bố cục TV chỉ dành cho anime';

  @override
  String get anime_only_beta => 'Chỉ anime (beta)';

  @override
  String get tv_home_beta => 'TV gia đình (beta)';

  @override
  String get tv_player_beta => 'Trình phát TV (beta)';

  @override
  String get network_settings => 'Mạng';

  @override
  String get reader_page_layout => 'Bố cục trang';

  @override
  String get reader_continuous_options => 'Đọc liên tục';

  @override
  String get reader_default_mode_hint =>
      'Chế độ đọc mặc định áp dụng cho các tiêu đề không có chế độ riêng được đặt trong khi đọc.';

  @override
  String get extension_service => 'Dịch vụ mở rộng';

  @override
  String get extension_service_description =>
      'Quản lý thời gian chạy tiện ích mở rộng và địa chỉ proxy.';

  @override
  String get proxy_address => 'Địa chỉ proxy';

  @override
  String get checking_runtime_status => 'Đang kiểm tra trạng thái…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + độ trễ ngẫu nhiên';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chương',
      one: '1 chương',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Thêm các bản tải xuống từ danh sách chương của tiêu đề.';

  @override
  String get download_queue_order_hint => 'Kéo tay cầm để sắp xếp lại';

  @override
  String get download_queue_empty =>
      'Không có lượt tải xuống nào được xếp hàng đợi';

  @override
  String get download_queue_actions => 'Hành động tải xuống';

  @override
  String get download_queue_cancel_chapter => 'Hủy tải xuống chương này';

  @override
  String get download_queue_cancel_series =>
      'Hủy tất cả các lượt tải xuống cho tựa sách này';

  @override
  String get download_queue_start => 'Bắt đầu tải xuống';

  @override
  String get download_queue_retry => 'Thử tải xuống lại';

  @override
  String get download_queue_active => 'Đang tải xuống';

  @override
  String get download_queue_waiting => 'Đang chờ tải xuống';

  @override
  String get download_queue_failed => 'Tải xuống không thành công';

  @override
  String get cf_proxy_helper =>
      'Điểm cuối FlareSolverr / Byparr. Để trống để vô hiệu hóa.';

  @override
  String get mobile_navigation_description =>
      'Kéo để sắp xếp lại. Manga, anime và tiểu thuyết chia sẻ tab Thư viện. Mục hiển thị đầu tiên sẽ mở ra khi khởi chạy. Duyệt và nhiều hơn nữa vẫn hiển thị; các tab bổ sung xuất hiện trong Thêm.';

  @override
  String get text_align_justify => 'Biện minh';

  @override
  String get novel_session_modes_hint =>
      'Đặt chế độ đọc và trang đơn hoặc trang đôi trong khi đọc tiêu đề.';

  @override
  String get tts_languages_failed =>
      'Không thể tải ngôn ngữ từ công cụ lời nói.';

  @override
  String get tts_languages_empty =>
      'Công cụ phát âm không trả về ngôn ngữ nào. Lựa chọn đã lưu của bạn được giữ lại.';

  @override
  String get tts_language_unavailable =>
      'Ngôn ngữ đã lưu này không có trong danh sách hiện tại của thiết bị.';

  @override
  String get tts_apply_failed =>
      'Không thể áp dụng cài đặt này cho công cụ giọng nói. Bạn có thể thử lại.';

  @override
  String get player_controls => 'Điều khiển';

  @override
  String get audio_channel_auto => 'Tự động';

  @override
  String get audio_channel_auto_safe => 'Tự động (an toàn)';

  @override
  String get audio_channel_mono => 'Đơn sắc';

  @override
  String get audio_channel_stereo => 'Âm thanh nổi';

  @override
  String get audio_channel_reverse_stereo => 'Âm thanh nổi đảo ngược';

  @override
  String get mpv_bundled_config_hint =>
      'Khôi phục cấu hình, tập lệnh và trình đổ bóng đi kèm với ứng dụng. Các tập tin có cùng tên sẽ bị ghi đè.';

  @override
  String get mpv_restore_bundled => 'Khôi phục cấu hình đi kèm';

  @override
  String get mpv_restore_confirm =>
      'Khôi phục cấu hình MPV đi kèm? Cấu hình hiện tại, tập lệnh và trình đổ bóng có cùng tên sẽ bị ghi đè. Các tập tin khác sẽ được giữ lại.';

  @override
  String get player_operation_incomplete =>
      'Thao tác không thể hoàn thành. Hãy kiểm tra quyền truy cập tệp và thử lại.';

  @override
  String get custom_buttons_empty_hint =>
      'Thêm nút trình phát có nhãn và thao tác nhấn.';

  @override
  String get custom_button_primary => 'Nút mặc định';

  @override
  String get show_password => 'Hiển thị mật khẩu';

  @override
  String get hide_password => 'Ẩn mật khẩu';

  @override
  String get tracking_accounts_empty =>
      'Kết nối dịch vụ trong cài đặt Theo dõi để quản lý các mục nhập của dịch vụ đó.';

  @override
  String get tracking_entries_empty =>
      'Không có mục được theo dõi cho loại phương tiện này. Thêm theo dõi từ trang chi tiết của tiêu đề.';

  @override
  String get change_tracking_match => 'Thay đổi tiêu đề phù hợp';

  @override
  String get remove_tracking => 'Xóa theo dõi';

  @override
  String remove_tracking_confirm(String title) {
    return 'Xóa liên kết theo dõi cho “$title”? Mục nhập trong dịch vụ theo dõi sẽ được lưu giữ.';
  }

  @override
  String get tracking_refresh_required =>
      'Không thể xác nhận trạng thái theo dõi. Làm mới trước khi thực hiện thay đổi khác.';

  @override
  String get tracking_entry_unlinked =>
      'Bản ghi này không được liên kết với tiêu đề địa phương nên không thể chỉnh sửa nó ở đây.';

  @override
  String get backup_selection_shared =>
      'Những thay đổi đối với những lựa chọn này sẽ được lưu ngay lập tức và cũng áp dụng cho việc sao lưu tự động.';

  @override
  String get library_snapshot_history => 'Khôi phục ảnh chụp nhanh thư viện';

  @override
  String get library_snapshot_empty => 'Không có ảnh chụp nhanh về an toàn.';

  @override
  String get library_snapshot_restore_message =>
      'Dữ liệu hiện tại sẽ được thay thế bằng ảnh chụp nhanh này. Những thay đổi được thực hiện kể từ đó sẽ bị mất. Không thể khôi phục các bản tải xuống đã xóa. Ảnh chụp nhanh an toàn có sẵn sẽ bị xóa sau khi thành công.';

  @override
  String get library_maintenance_working => 'Đang cập nhật thư viện…';

  @override
  String get library_safety_snapshot_note =>
      'Ảnh chụp nhanh an toàn sẽ được lưu trước thao tác này. Nó không bao gồm các tập tin tải về.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Mục thư viện: $mangaCount. Các chương: $chapterCount. Mục lịch sử: $historyCount. Cập nhật: $updateCount.\n\nChọn nội dung cần giữ bên dưới.';
  }

  @override
  String get library_delete_pick_message =>
      'Chọn một nguồn để xem lại nội dung của nó và các tùy chọn xóa.';

  @override
  String get mobile_categories_hint =>
      'Kéo để sắp xếp lại. Mở một danh mục để đổi tên hoặc thay đổi mức độ hiển thị và cập nhật của nó.';

  @override
  String get mobile_category_visible => 'Hiển thị trong thư viện';

  @override
  String get mobile_category_hidden => 'Ẩn khỏi thư viện';

  @override
  String get mobile_category_updates => 'Bao gồm trong bản cập nhật thư viện';

  @override
  String get statistics_watched => 'Đã xem';

  @override
  String get calendar_month => 'Tháng';

  @override
  String get calendar_two_weeks => '2 tuần';

  @override
  String get calendar_week => 'Tuần';

  @override
  String get calendar_show_all_dates => 'Hiển thị tất cả các ngày';

  @override
  String get update_check_no_result =>
      'Không tìm thấy bản cập nhật có thể cài đặt nào. Bạn có thể thử lại sau.';

  @override
  String get release_notes => 'Ghi chú phát hành';

  @override
  String get no_release_notes =>
      'Không có ghi chú phát hành nào được cung cấp.';

  @override
  String get downloading_update => 'Đang tải xuống bản cập nhật…';

  @override
  String get preparing_installation => 'Đang chuẩn bị cài đặt…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Chọn nội dung cần đọc. Bạn có thể thay đổi điều này sau.';

  @override
  String get onboarding_content_title => 'Bắt đầu đọc';

  @override
  String get onboarding_mobile_sources_body =>
      'Chọn cách bắt đầu hoặc thêm nội dung sau.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Bước $step của $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'Kết quả cho “$query”';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nguồn',
      one: '1 nguồn',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Tìm kiếm tiêu đề đích.';

  @override
  String get migration_original_item => 'Mục hiện tại';

  @override
  String get migration_target_item => 'Mục đã chọn';

  @override
  String get migration_partial_failure =>
      'Thao tác chưa kết thúc. Một số thay đổi có thể đã được lưu. Hãy kiểm tra mục này trong thư viện của bạn trước khi thử lại.';

  @override
  String get migration_no_categories =>
      'Không có danh mục nào. Bạn có thể thêm mục này mà không cần danh mục.';

  @override
  String get mass_migration_select_source => 'Chọn nguồn hiện tại';

  @override
  String get mass_migration_select_all => 'Chọn tất cả';

  @override
  String get mass_migration_deselect_all => 'Bỏ chọn tất cả';

  @override
  String get mass_migration_needs_review =>
      'Xem lại quá trình di chuyển chưa hoàn tất';

  @override
  String get bookshelf_actions => 'Hành động của kệ sách';

  @override
  String get bookshelf_ignore_filters => 'Bỏ qua bộ lọc khi tìm kiếm';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Tìm kiếm tất cả tác phẩm trong danh mục này, bao gồm cả những tác phẩm bị bộ lọc ẩn.';

  @override
  String get bookshelf_stop_update => 'Dừng cập nhật thư viện';

  @override
  String bookshelf_selected_count(int count) {
    return '$count tác phẩm được chọn';
  }

  @override
  String get bookshelf_remove_library => 'Xóa khỏi giá sách';

  @override
  String get bookshelf_remove_library_hint =>
      'Xóa mục yêu thích. Nhập khẩu địa phương cũng mất thư viện và hồ sơ đọc.';

  @override
  String get bookshelf_remove_downloads => 'Xóa các tập tin đã tải xuống';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Xóa các tệp đã tải xuống trong khi vẫn giữ thông tin công việc.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Đồng thời xóa các tệp được nhập cục bộ đã chọn và xóa các bản ghi thư viện của chúng. Những tập tin này không thể được phục hồi ở đây.';

  @override
  String get bookshelf_remove_incomplete =>
      'Thao tác chưa kết thúc. Một số tác phẩm hoặc tập tin có thể đã được xử lý. Đóng hộp thoại này và kiểm tra giá sách cũng như nội dung tải xuống của bạn trước khi tiếp tục.';

  @override
  String get bookshelf_processing => 'Đang xử lý…';

  @override
  String get bookshelf_mark_read => 'Đánh dấu đã đọc';

  @override
  String get bookshelf_mark_unread => 'Đánh dấu là chưa đọc';

  @override
  String get bookshelf_select_all => 'Chọn tất cả';

  @override
  String get bookshelf_invert_selection => 'Đảo ngược lựa chọn';

  @override
  String get bookshelf_settings => 'Cài đặt giá sách';

  @override
  String get bookshelf_settings_live =>
      'Các thay đổi về lọc, sắp xếp và hiển thị sẽ có hiệu lực ngay lập tức.';

  @override
  String get bookshelf_filter_any => 'Bất kỳ';

  @override
  String get bookshelf_filter_include => 'Bao gồm';

  @override
  String get bookshelf_filter_exclude => 'Loại trừ';

  @override
  String get bookshelf_all_sources => 'Tất cả các nguồn';

  @override
  String bookshelf_sources_selected(int count) {
    return '$count nguồn được chọn';
  }

  @override
  String get bookshelf_sort_ascending => 'Tăng dần';

  @override
  String get bookshelf_sort_descending => 'Giảm dần';

  @override
  String get bookshelf_layout => 'Bố trí giá sách';

  @override
  String get bookshelf_sources_hint =>
      'Chọn không có để hiển thị tất cả các nguồn. Các thay đổi sẽ được áp dụng khi bạn nhấn vào Bộ lọc.';

  @override
  String get bookshelf_choose_files => 'Chọn tập tin';

  @override
  String get bookshelf_import_wait =>
      'Chọn một tệp trong bộ chọn và đợi quá trình nhập hoàn tất.';

  @override
  String get bookshelf_import_incomplete =>
      'Quá trình nhập chưa hoàn tất. Một số tệp có thể đã có trong giá sách của bạn. Đóng hộp thoại này và kiểm tra trước khi nhập lại.';

  @override
  String get bookshelf_categories_replace =>
      'Việc lưu chỉ định các danh mục này cho mọi tác phẩm đã chọn, thay thế các danh mục trước đó của chúng.';

  @override
  String get bookshelf_categories_hint =>
      'Chọn một hoặc nhiều danh mục hoặc để trống lựa chọn để không chỉ định danh mục nào.';

  @override
  String get bookshelf_categories_hidden =>
      'Các danh mục ẩn hiện có được giữ lại cho tác phẩm này.';

  @override
  String get bookshelf_categories_incomplete =>
      'Không thể lưu hoàn toàn các danh mục. Đóng hộp thoại này và kiểm tra giá sách trước khi thử lại.';

  @override
  String get bookshelf_categories_none_visible =>
      'Không có danh mục nào ở đây. Mở quản lý danh mục để xem xét chúng.';

  @override
  String get bookshelf_manage_categories => 'Quản lý danh mục';

  @override
  String get manga_actions => 'Truyện tranh hành động';

  @override
  String get manga_download_scope => 'Tải chương';

  @override
  String get manga_download_scope_hint =>
      'Chọn các chương trong bộ lọc hiện tại. Các chương đã tải xuống sẽ bị bỏ qua.';

  @override
  String get manga_download_scope_empty =>
      'Không có chương nào phù hợp với bộ lọc hiện tại. Đóng menu này và điều chỉnh bộ lọc chương.';

  @override
  String get manga_action_incomplete =>
      'Hành động chưa kết thúc. Kiểm tra trạng thái hiện tại trước khi thử lại.';

  @override
  String get chapter_settings => 'Cài đặt chương';

  @override
  String get chapter_settings_live =>
      'Các thay đổi về bộ lọc và sắp xếp sẽ được áp dụng ngay lập tức.';

  @override
  String get chapter_scanlators_all => 'Hiển thị tất cả các nhóm máy quét';

  @override
  String get chapter_scanlators_hint =>
      'Chọn nhóm để ẩn chương của họ. Các thay đổi sẽ được áp dụng khi bạn nhấn vào Bộ lọc.';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count nhóm máy quét bị ẩn';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count chương được chọn';
  }

  @override
  String get chapter_add_bookmark => 'Đánh dấu';

  @override
  String get chapter_remove_bookmark => 'Bỏ đánh dấu';

  @override
  String get chapter_read_following => 'Đọc bên dưới';

  @override
  String get chapter_delete_records => 'Xóa bản ghi chương';

  @override
  String get chapter_delete_local_hint =>
      'Loại bỏ các bản ghi chương đã chọn và tiến trình đọc. Các tài liệu lưu trữ gốc của địa phương được lưu giữ; các bản sao đã tải xuống sẽ được dọn sạch.';

  @override
  String get chapter_delete_last_hint =>
      'Đây là tất cả các chương trong truyện tranh này. Xóa chúng cũng sẽ xóa truyện tranh khỏi giá sách của bạn.';

  @override
  String get chapter_action_incomplete =>
      'Hành động chưa kết thúc. Một số thay đổi có thể đã được lưu. Đóng và kiểm tra các chương cũng như nội dung tải xuống trước khi tiếp tục.';

  @override
  String get reader_display_scope =>
      'Chế độ đọc và bố cục trang thủ công áp dụng cho truyện tranh này. Chọn một thay đổi để quay lại đọc.';

  @override
  String get reader_display_single_only =>
      'Đọc liên tục theo chiều ngang sử dụng các trang đơn.';

  @override
  String get reader_display_manual_pages =>
      'Thay đổi bố cục trang sẽ tắt trang đôi tự động cho tất cả truyện tranh.';

  @override
  String get reader_display_crop_scope => 'Áp dụng cho tất cả truyện tranh.';

  @override
  String get reader_chapter_locate => 'Xác định vị trí chương hiện tại';

  @override
  String get reader_chapter_search => 'Tìm kiếm chương hoặc máy quét';

  @override
  String get reader_chapter_scope =>
      'Sử dụng bộ lọc chương và sắp xếp thứ tự từ các chi tiết truyện tranh. Dấu trang được lưu ngay lập tức.';

  @override
  String get reader_chapter_current_hidden =>
      'Chương bạn đang đọc nằm ngoài bộ lọc hiện tại.';

  @override
  String get reader_chapter_current => 'Đang đọc';

  @override
  String get reader_chapter_read => 'Đọc';

  @override
  String get reader_chapter_bookmark_failed =>
      'Không thể xác nhận việc lưu dấu trang. Đóng danh sách và kiểm tra trạng thái hiện tại của nó.';

  @override
  String get reader_image_actions => 'Hành động hình ảnh';

  @override
  String get reader_image_original =>
      'Sử dụng toàn bộ trang gốc, không có bộ lọc dịch, cắt xén hoặc màu của trình đọc.';

  @override
  String get reader_image_save_ios =>
      'Lưu vào thư mục Ảnh ở vị trí lưu trữ ứng dụng hiện tại.';

  @override
  String get reader_image_save_android =>
      'Lưu vào thư mục Pictures/nodelane-comics của thiết bị.';

  @override
  String get reader_image_share => 'Mở bảng chia sẻ hệ thống.';

  @override
  String get reader_image_cover =>
      'Thay đổi bìa truyện tranh này sau khi xác nhận.';

  @override
  String get reader_image_cover_limit =>
      'Ảnh bìa phải nhỏ hơn 5 MB. Lưu và chia sẻ vẫn có sẵn.';

  @override
  String get reader_image_action_failed =>
      'Hành động không thể được xác nhận. Đóng menu này và kiểm tra kết quả trước khi thử lại.';

  @override
  String get reader_settings_book_scope =>
      'Những cài đặt này chỉ áp dụng cho truyện tranh này.';

  @override
  String get reader_settings_global_scope =>
      'Các cài đặt này áp dụng cho tất cả truyện tranh và lưu ngay lập tức.';

  @override
  String get reader_filters => 'Bộ lọc hình ảnh';

  @override
  String get reader_filter_scope =>
      'Áp dụng cho tất cả truyện tranh. Thay đổi màn hình đọc mà không sửa đổi hình ảnh gốc.';

  @override
  String get reader_auto_scroll_pause =>
      'Quá trình cuộn tạm dừng khi cài đặt đang mở.';

  @override
  String get manga_synopsis => 'Tóm tắt';

  @override
  String manga_author(String author) {
    return 'Tác giả: $author';
  }

  @override
  String get manga_continue_reading => 'Tiếp tục đọc';

  @override
  String get reader_settings_title => 'Cài đặt đầu đọc';

  @override
  String get reader_picker_book_scope => 'Chỉ dành cho truyện tranh này';

  @override
  String get reader_picker_global_scope => 'Áp dụng cho tất cả truyện tranh';

  @override
  String get reader_picker_apply_hint =>
      'Nhấn để lưu và quay lại mức trước đó.';

  @override
  String get reader_scale_fit_screen_hint => 'Vừa toàn bộ trang trên màn hình';

  @override
  String get reader_scale_stretch_hint => 'Lấp đầy khu vực đọc';

  @override
  String get reader_scale_fit_width_hint => 'Điều chỉnh trang theo chiều rộng';

  @override
  String get reader_scale_fit_height_hint => 'Điều chỉnh trang theo chiều cao';

  @override
  String get source_filter_active => 'Đã áp dụng';

  @override
  String get source_filter_apply => 'Áp dụng bộ lọc';

  @override
  String get source_filter_scope => 'Bộ lọc chỉ áp dụng cho trang web này.';

  @override
  String get source_filter_apply_hint =>
      'Áp dụng bộ lọc để sử dụng các lựa chọn của bạn.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Thể loại',
      'author': 'Tác giả',
      'artist': 'Nghệ sĩ',
      'title': 'Tiêu đề',
      'year': 'Năm',
      'tags': 'Thẻ',
      'format': 'định dạng',
      'publisher': 'Nhà xuất bản',
      'relevance': 'Sự liên quan',
      'rating': 'Đánh giá',
      'views': 'Lượt xem',
      'random': 'Ngẫu nhiên',
      'all': 'Tất cả',
      'none': 'Không có',
      'action': 'Hành động',
      'adventure': 'Cuộc phiêu lưu',
      'comedy': 'Hài kịch',
      'drama': 'Kịch',
      'fantasy': 'Ảo tưởng',
      'romance': 'Lãng mạn',
      'science_fiction': 'Khoa học viễn tưởng',
      'slice_of_life': 'Lát cắt cuộc đời',
      'mystery': 'Bí ẩn',
      'horror': 'Kinh dị',
      'psychological': 'Tâm lý',
      'historical': 'Lịch sử',
      'sports': 'Thể thao',
      'supernatural': 'Siêu nhiên',
      'school_life': 'Cuộc sống học đường',
      'tragedy': 'Bi kịch',
      'shounen': 'Shounen',
      'shoujo': 'Shoujo',
      'seinen': 'Seinen',
      'josei': 'Josei',
      'isekai': 'Isekai',
      'martial_arts': 'Võ thuật',
      'mecha': 'Cơ Khí',
      'music': 'Âm nhạc',
      'doujinshi': 'Doujinshi',
      'trending': 'Đang thịnh hành',
      'new': 'Mới',
      'adult_content': 'Nội dung người lớn',
      'only': 'Chỉ',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'Thêm tùy chọn hiển thị';

  @override
  String get bookshelf_more_display_hint => 'Huy hiệu, nguồn và danh mục';

  @override
  String get bookshelf_download_count => 'Số lượt tải xuống';

  @override
  String get bookshelf_source_global_hint =>
      'Khả năng hiển thị nguồn sử dụng tùy chọn hiển thị được chia sẻ.';

  @override
  String get bookshelf_select_entries => 'Chọn tác phẩm';

  @override
  String get bookshelf_search_options => 'Tùy chọn tìm kiếm';

  @override
  String get bookshelf_empty_hint =>
      'Thu thập tác phẩm từ các nguồn hoặc nhập tệp cục bộ.';

  @override
  String get bookshelf_no_match_hint =>
      'Hãy thử các từ khóa khác hoặc điều chỉnh các bộ lọc hiện tại.';

  @override
  String get bookshelf_clear_query => 'Xóa từ khóa';

  @override
  String get bookshelf_view_selection => 'Xem các tác phẩm đã chọn';

  @override
  String get bookshelf_import_formats =>
      'Chọn tệp cục bộ để thêm nó vào giá sách của bạn.';

  @override
  String get bookshelf_import_canceled_hint =>
      'Bạn có thể chọn lại sau khi hủy bộ chọn tệp.';

  @override
  String get bookshelf_browse_sources => 'Duyệt nguồn';

  @override
  String get bookshelf_empty_title => 'Giá sách của bạn trống rỗng';

  @override
  String get bookshelf_no_match_title => 'Không có tác phẩm phù hợp';

  @override
  String get bookshelf_mark_watched => 'Mark đã xem';

  @override
  String get bookshelf_mark_unwatched => 'Đánh dấu là chưa xem';

  @override
  String get nodelane_account => 'NodeLane';

  @override
  String get nodelane_sign_in => 'Đăng nhập vào NodeLane';

  @override
  String get nodelane_account_intro =>
      'Xem tài khoản, đăng ký và hạn ngạch dịch thuật của bạn';

  @override
  String get nodelane_login_action => 'Tiếp tục đăng nhập';

  @override
  String get nodelane_login_browser =>
      'Đăng nhập thông qua trình duyệt hệ thống, sau đó quay lại ứng dụng';

  @override
  String get nodelane_account_id => 'ID tài khoản';

  @override
  String get nodelane_account_init_error =>
      'Bộ nhớ tài khoản không khả dụng. Khởi động lại ứng dụng và thử lại.';

  @override
  String get nodelane_account_refresh_error =>
      'Không thể làm mới thông tin tài khoản';

  @override
  String get nodelane_account_auth_error =>
      'Phiên của bạn đã hết hạn. Đăng nhập lại';

  @override
  String get nodelane_account_unknown => 'Thông tin đăng ký không có sẵn';

  @override
  String get nodelane_account_current => 'Đăng ký hiện tại';

  @override
  String get nodelane_account_free => 'Tài khoản miễn phí';

  @override
  String get nodelane_account_no_subscription => 'Không có đăng ký hoạt động';

  @override
  String get nodelane_account_active => 'Đang hoạt động';

  @override
  String get nodelane_account_expired => 'Đã hết hạn';

  @override
  String get nodelane_account_expiry => 'Có hiệu lực đến';

  @override
  String get nodelane_account_renewal => 'Gia hạn';

  @override
  String get nodelane_renewal_auto => 'Tự động gia hạn';

  @override
  String get nodelane_renewal_manual => 'Gia hạn thủ công';

  @override
  String get nodelane_renewal_stopped => 'Đã dừng gia hạn tự động';

  @override
  String get nodelane_renewal_gift => 'Quà tặng thành viên';

  @override
  String get nodelane_renewal_attention =>
      'Kiểm tra trạng thái gia hạn của bạn trên trang web';

  @override
  String get nodelane_next_billing => 'Ngày thanh toán tiếp theo';

  @override
  String get nodelane_billing_unavailable => 'Không có thông tin gia hạn';

  @override
  String get nodelane_manage_account => 'Quản lý trên website';

  @override
  String get nodelane_view_plans => 'Xem gói thuê bao';

  @override
  String get nodelane_translation_quota => 'Hạn ngạch dịch thuật';

  @override
  String get nodelane_quota_free => 'Hạn ngạch miễn phí';

  @override
  String get nodelane_quota_subscription => 'Hạn ngạch đăng ký';

  @override
  String get nodelane_quota_purchase => 'Hạn ngạch đã mua';

  @override
  String get nodelane_quota_details => 'Xem chi tiết hạn ngạch';

  @override
  String get nodelane_quota_expanded => 'Chi tiết hạn ngạch';

  @override
  String get nodelane_quota_unlimited => 'Không giới hạn';

  @override
  String get nodelane_quota_not_subscribed => 'Chưa đăng ký';

  @override
  String get nodelane_quota_unknown => 'Không có sẵn';

  @override
  String get nodelane_quota_used => 'Đã qua sử dụng';

  @override
  String get nodelane_quota_reserved => 'Đang tiến hành';

  @override
  String get nodelane_quota_reset => 'Đặt lại tiếp theo';

  @override
  String get nodelane_quota_expiry => 'Hạn sử dụng tiếp theo';

  @override
  String get nodelane_quota_no_expiry => 'Không có hạn sử dụng';

  @override
  String get nodelane_quota_reservation_note =>
      'Các trang đang thực hiện đã được khấu trừ khỏi hạn ngạch hiện có';

  @override
  String nodelane_quota_available(int count) {
    return '$count trang còn lại';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count trang';
  }

  @override
  String get nodelane_sign_out => 'Đăng xuất';

  @override
  String get nodelane_sign_out_confirm =>
      'Việc đăng xuất sẽ tạm dừng bản dịch chính thức trên thiết bị này. Thư viện và tiến trình đọc của bạn được lưu giữ.';

  @override
  String get settings_search_hint => 'Cài đặt tìm kiếm';

  @override
  String get settings_frequent => 'Thường xuyên sử dụng';

  @override
  String get settings_reading_translation => 'Đọc và dịch thuật';

  @override
  String get settings_app_preferences => 'Tùy chọn ứng dụng';

  @override
  String get settings_data_management => 'Dữ liệu và quản lý';

  @override
  String get settings_more_tools => 'Thêm công cụ';

  @override
  String get settings_more_tools_hint => 'Danh mục, thống kê và lịch';

  @override
  String get settings_appearance_interface => 'Ngoại hình và giao diện';

  @override
  String get settings_security_privacy => 'Bảo mật và quyền riêng tư';

  @override
  String get settings_source_preferences => 'Cài đặt nguồn';

  @override
  String get settings_about_help => 'Giới thiệu và trợ giúp';

  @override
  String get settings_storage_backup => 'Lưu trữ và sao lưu';

  @override
  String settings_pending_downloads(int count) {
    return '$count đang chờ xử lý';
  }

  @override
  String get settings_translation_language => 'Ngôn ngữ dịch thuật';

  @override
  String get settings_translation_scope =>
      'Được sử dụng trong trình đọc và dịch trang web';

  @override
  String get settings_immediate_choice =>
      'Các thay đổi được áp dụng ngay lập tức';

  @override
  String get settings_translation_init_error =>
      'Cài đặt dịch không khả dụng. Khởi động lại ứng dụng và thử lại.';

  @override
  String get settings_local_cache => 'Bộ đệm cục bộ';

  @override
  String get settings_chapter_cache => 'Bộ đệm chương và tập';

  @override
  String get settings_cover_cache => 'Che bộ đệm';

  @override
  String get settings_translation_cache => 'Bộ đệm hình ảnh đã dịch';

  @override
  String get settings_translation_cache_hint =>
      'Lưu giữ bản ghi dịch và truy xuất lại hình ảnh đã dịch khi cần';

  @override
  String get settings_cache_clear => 'Xóa';

  @override
  String get settings_translation_cache_done =>
      'Đã xóa bộ nhớ đệm hình ảnh được dịch; hồ sơ dịch thuật được lưu giữ';

  @override
  String settings_cache_confirmation(String name) {
    return 'Xóa $name? Nội dung được lưu trong bộ nhớ đệm có thể được truy xuất lại. Các mục trong thư viện sẽ được lưu giữ.';
  }

  @override
  String get settings_advanced_options => 'Tùy chọn nâng cao';

  @override
  String get settings_manga_reader => 'Người đọc truyện tranh';

  @override
  String get settings_novel_reader => 'Người đọc tiểu thuyết';

  @override
  String get settings_downloads => 'Cài đặt tải xuống';

  @override
  String get onboarding_welcome => 'Chào mừng đến với';

  @override
  String get onboarding_reading_content => 'Đọc nội dung';

  @override
  String get onboarding_choose_one => 'Chọn ít nhất một';

  @override
  String get onboarding_restore_hint =>
      'Khôi phục thư viện của bạn từ bản sao lưu';

  @override
  String get onboarding_browse_hint =>
      'Tìm tiêu đề trên các trang web được hỗ trợ';

  @override
  String get onboarding_import_folder => 'Nhập thư mục cục bộ';

  @override
  String get onboarding_import_folder_hint =>
      'Đọc manga, tiểu thuyết và anime trên thiết bị của bạn';

  @override
  String get onboarding_third_party => 'Thêm kho lưu trữ của bên thứ ba';

  @override
  String get onboarding_third_party_hint =>
      'Sử dụng địa chỉ kho lưu trữ mà bạn đã có';

  @override
  String get onboarding_repository_hint =>
      'Nhập địa chỉ được cung cấp bởi kho lưu trữ.';

  @override
  String get onboarding_repository_address => 'Địa chỉ';

  @override
  String get onboarding_repository_address_hint => 'Nhập địa chỉ kho lưu trữ';

  @override
  String get onboarding_add_repository => 'Thêm kho lưu trữ';

  @override
  String get onboarding_start => 'Bắt đầu';

  @override
  String get onboarding_open_library => 'Mở thư viện';

  @override
  String get onboarding_view_imports => 'Xem nội dung đã nhập';

  @override
  String get onboarding_view_folders => 'Xem thư mục';

  @override
  String get notice_backup_created => 'Đã tạo bản sao lưu';

  @override
  String get notice_backup_ready => 'Lưu hoặc chia sẻ tệp sao lưu.';

  @override
  String get notice_backup_restored => 'Đã khôi phục bản sao lưu';

  @override
  String get notice_backup_unsupported =>
      'Định dạng sao lưu này không được hỗ trợ.';

  @override
  String get notice_verification_required => 'Yêu cầu xác minh trang web';

  @override
  String get notice_verification_hint => 'Hoàn tất xác minh để tiếp tục duyệt.';

  @override
  String get notice_verify => 'Xác minh trang web';

  @override
  String get notice_action_incomplete =>
      'Hành động chưa kết thúc. Kiểm tra kết quả của nó trước khi thử lại.';

  @override
  String get notice_library_updating => 'Đang cập nhật thư viện';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'Đã kiểm tra tiêu đề $current / $total';
  }

  @override
  String get notice_library_failed => 'Một số tựa sách không thể cập nhật được';

  @override
  String get notice_import_completed => 'Đã nhập xong';

  @override
  String get notice_operation_incomplete => 'Hành động chưa hoàn thành';

  @override
  String get subtitle_service => 'Dịch vụ phụ đề trực tuyến';

  @override
  String get subtitle_service_mode => 'Nguồn phụ đề';

  @override
  String get subtitle_service_disabled => 'Tắt · xóa thông tin xác thực đã lưu';

  @override
  String get subtitle_personal_key => 'Khóa Wyzie của tôi';

  @override
  String get subtitle_custom_service => 'Dịch vụ phụ đề của tôi';

  @override
  String get subtitle_key => 'Wyzie API';

  @override
  String get subtitle_key_hint =>
      'Nhập khóa Wyzie của riêng bạn. Nó vẫn ở trên thiết bị này và không được đưa vào bản sao lưu ứng dụng.';

  @override
  String get subtitle_get_key => 'Nhận chìa khóa cá nhân';

  @override
  String get subtitle_service_address => 'Tìm kiếm phụ đề URL';

  @override
  String get subtitle_service_token =>
      'Mã thông báo truy cập dịch vụ (tùy chọn)';

  @override
  String get subtitle_custom_hint =>
      'Sử dụng tìm kiếm HTTPS đầy đủ URL của dịch vụ Wyzie-compatible, bao gồm cả đường dẫn của nó (ví dụ: /search). Chỉ nhập mã thông báo truy cập nếu dịch vụ của bạn yêu cầu.';

  @override
  String get subtitle_service_off_hint =>
      'Tìm kiếm phụ đề trực tuyến bị tắt. Phụ đề nhúng, do nguồn cung cấp và phụ đề cục bộ vẫn có sẵn.';

  @override
  String get subtitle_setup_required =>
      'Chọn dịch vụ phụ đề trước khi tìm kiếm.';

  @override
  String get subtitle_invalid_key => 'Nhập khóa không có dấu cách.';

  @override
  String get subtitle_invalid_address =>
      'Sử dụng HTTPS URL hoàn chỉnh mà không có truy vấn, đoạn hoặc thông tin xác thực được nhúng.';

  @override
  String get subtitle_invalid_token =>
      'Mã thông báo truy cập không được chứa dấu cách.';

  @override
  String get subtitle_storage_failed =>
      'Không thể đọc hoặc lưu cài đặt phụ đề. Vui lòng thử lại.';

  @override
  String get subtitle_auth_failed =>
      'Dịch vụ phụ đề từ chối truy cập. Kiểm tra mã thông báo khóa hoặc dịch vụ của bạn.';

  @override
  String get subtitle_quota_exhausted =>
      'Hạn ngạch dịch vụ phụ đề đã hết. Kiểm tra tài khoản của bạn với dịch vụ đó.';

  @override
  String get subtitle_network_failed =>
      'Không thể truy cập dịch vụ phụ đề. Vui lòng thử lại.';

  @override
  String get subtitle_response_invalid =>
      'Dịch vụ phụ đề trả về phản hồi hoặc tệp không được hỗ trợ.';

  @override
  String get detail_loading_chapters => 'Đang tải chương…';

  @override
  String get reader_opening_chapter => 'Chương mở đầu';

  @override
  String get reader_open_chapter => 'Chương mở';

  @override
  String get reader_loading_pages => 'Đang lấy hình ảnh chương…';

  @override
  String get reader_loading_pages_hint =>
      'Quá trình đọc sẽ tự động bắt đầu khi sẵn sàng.';

  @override
  String get reader_loading_failed => 'Không thể tải chương này';

  @override
  String get reader_loading_retry_hint =>
      'Hãy kiểm tra kết nối của bạn và thử lại.';

  @override
  String get reader_no_pages => 'Không tìm thấy hình ảnh cho chương này';

  @override
  String get reader_loading_previous => 'Đang tải chương trước…';

  @override
  String get reader_previous_failed => 'Không thể tải chương trước';

  @override
  String get reader_reached_start => 'Bạn đã đọc đến chương đầu tiên';

  @override
  String get reader_loading_next => 'Đang tải chương tiếp theo…';

  @override
  String get reader_next_failed => 'Không thể tải chương tiếp theo';

  @override
  String get reader_image_loading => 'Đang tải hình ảnh…';

  @override
  String get reader_image_failure_hint =>
      'Bạn có thể tiếp tục đọc các trang khác.';

  @override
  String get comic_paged => 'Từng trang';

  @override
  String get comic_scroll => 'Cuộn xuống';

  @override
  String get comic_book_scope =>
      'Chỉ áp dụng cho cuốn sách này · lưu thay đổi ngay lập tức';

  @override
  String get comic_defaults_title => 'Mặc định & thói quen';

  @override
  String get comic_defaults_hint =>
      'Giá trị mặc định áp dụng cho các trường bạn chưa tùy chỉnh cho sách.';

  @override
  String get comic_habits_hint =>
      'Những thói quen này áp dụng cho mọi truyện tranh.';

  @override
  String get comic_turn => 'Vuốt sang trang tiếp theo';

  @override
  String get comic_left => 'Còn lại';

  @override
  String get comic_right => 'Đúng rồi';

  @override
  String get comic_up => 'Lên';

  @override
  String get comic_fit => 'Trang phù hợp';

  @override
  String get comic_fit_contain => 'Toàn bộ trang';

  @override
  String get comic_fit_width => 'Chiều rộng phù hợp';

  @override
  String get comic_fit_height => 'Chiều cao phù hợp';

  @override
  String get comic_layout => 'Bố cục trang';

  @override
  String get comic_auto => 'Tự động';

  @override
  String get comic_layout_hint =>
      'Tự động hiển thị độ rộng khi có đủ chiều rộng.';

  @override
  String get comic_width => 'Độ rộng nội dung';

  @override
  String get comic_full => 'Đầy đủ';

  @override
  String get comic_comfortable => 'Thoải mái';

  @override
  String get comic_narrow => 'Thu hẹp';

  @override
  String get comic_gap => 'Giãn cách trang';

  @override
  String get comic_no_gap => 'Liền mạch';

  @override
  String get comic_small_gap => 'Nhỏ';

  @override
  String get comic_image_title => 'Tinh chỉnh hình ảnh';

  @override
  String get comic_image_hint =>
      'Cắt xén và tông màu chỉ ảnh hưởng đến cuốn sách này.';

  @override
  String get comic_wide => 'Trang rộng';

  @override
  String get comic_intact => 'Giữ nguyên';

  @override
  String get comic_split => 'Tách';

  @override
  String get comic_rotate => 'Xoay';

  @override
  String get comic_wide_hint =>
      'Việc chia tách theo hướng lật trang. Áp dụng cho việc đọc một trang.';

  @override
  String get comic_cover => 'Mỗi chương một bìa';

  @override
  String get comic_effects_reset => 'Đặt lại điều chỉnh hình ảnh';

  @override
  String get comic_book_reset => 'Khôi phục mặc định sách';

  @override
  String get comic_book_reset_hint =>
      'Xóa cài đặt đọc tùy chỉnh của cuốn sách này. Bản dịch không thay đổi.';

  @override
  String get comic_canvas => 'Nền tảng đầu đọc';

  @override
  String get comic_system => 'Hệ thống';

  @override
  String get comic_black => 'Đen';

  @override
  String get comic_gray => 'Màu xám';

  @override
  String get comic_paper => 'Giấy';

  @override
  String get comic_tap => 'Nhấn để lật trang';

  @override
  String get comic_tap_hint =>
      'Chạm vào các cạnh để di chuyển; chạm vào giữa để hiển thị các điều khiển.';

  @override
  String get comic_scroll_start => 'Bắt đầu cuộn tự động';

  @override
  String get comic_scroll_pause => 'Tạm dừng cuộn tự động';

  @override
  String get comic_scroll_speed => 'Tốc độ cuộn';

  @override
  String get comic_scroll_hint =>
      'Bắt đầu khi bảng này đóng lại. Tạm dừng khi ứng dụng rời khỏi nền trước.';

  @override
  String get comic_save_failed => 'Không thể lưu. Vui lòng thử lại.';

  @override
  String get comic_reading => 'Đọc sách';

  @override
  String get comic_chapter_habits_hint =>
      'Thói quen liệt kê chương áp dụng cho tất cả các cuốn sách.';

  @override
  String get browser_title => 'Trình duyệt';

  @override
  String get translation_image_display => 'Hiển thị hình ảnh';

  @override
  String get translation_display_hint =>
      'Hiển thị bản dịch hiện có trước tiên. Giữ bản gốc khi không có bản dịch.';

  @override
  String get translation_sign_in_required => 'Đăng nhập để bật dịch';

  @override
  String get translation_sign_in_hint =>
      'Sau khi đăng nhập, chuyển sang hình ảnh đã dịch để dịch tự động.';

  @override
  String get translation_automatic => 'Dịch tự động';

  @override
  String get translation_original_hint =>
      'Hiển thị bản gốc. Chuyển sang hình ảnh đã dịch để dịch tự động.';

  @override
  String get translation_window_hint =>
      'Chỉ xử lý hình ảnh hiện tại và sắp tới trong khi hiển thị bản dịch.';

  @override
  String get translation_channel => 'Kênh dịch thuật';

  @override
  String get translation_no_images =>
      'Chưa tìm thấy hình ảnh có thể dịch được trên trang này';

  @override
  String get translation_waiting_image => 'Đang chờ hình ảnh hiện tại';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues hình ảnh cần chú ý',
      one: ' · 1 hình ảnh cần chú ý',
      zero: '',
    );
    return 'Đã hoàn thành $complete / $total hình ảnh$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'Chạm và giữ hình ảnh để thực hiện thêm thao tác, bao gồm dịch lại hình ảnh đó.';

  @override
  String get translation_title => 'Dịch truyện tranh';

  @override
  String get translation_system_sign_in =>
      'Đăng nhập bằng trình duyệt hệ thống của bạn';

  @override
  String get translation_target_language => 'Ngôn ngữ đích';

  @override
  String get translation_clear_cache => 'Xóa bộ đệm hình ảnh đã dịch';

  @override
  String get translation_cache_hint =>
      'Lưu giữ hồ sơ dịch và truy xuất lại kết quả khi cần.';

  @override
  String get translation_saved_read_failed => 'Không thể tải bản dịch đã lưu';

  @override
  String get translation_read_failed => 'Không thể tải hình ảnh đã dịch';

  @override
  String get operation_retry => 'Hành động chưa kết thúc. Vui lòng thử lại.';

  @override
  String get translation_original => 'Bản gốc';

  @override
  String get translation_translated => 'Đã dịch';

  @override
  String get translation_regenerate_image => 'Dịch lại ảnh này';

  @override
  String get translation_read_image => 'Tải lại ảnh đã dịch';

  @override
  String get translation_image_actions => 'Thêm hành động hình ảnh';

  @override
  String get translation_processing => 'Đang xử lý';

  @override
  String get translation_reading => 'Đang tải hình ảnh đã dịch';

  @override
  String get translation_waiting => 'Đang chờ dịch';

  @override
  String get translation_preparing => 'Đang chuẩn bị dịch';

  @override
  String get translation_uploading => 'Tải lên bản gốc';

  @override
  String get translation_running => 'Dịch thuật';

  @override
  String get translation_uncertain => 'Trạng thái cần xác minh';

  @override
  String get translation_failed => 'Dịch không thành công';

  @override
  String get translation_verify => 'Xác minh';

  @override
  String get translation_reread => 'Tải lại';

  @override
  String get browser_back => 'Trở lại';

  @override
  String get browser_translation => 'Dịch trang web';

  @override
  String get browser_new_tab_action => 'Mở tab mới';

  @override
  String get browser_current_tab => 'Hiện tại';

  @override
  String get browser_close_tab => 'Đóng tab';

  @override
  String get browser_new_tab => 'Tab mới';

  @override
  String get browser_page => 'Trang web';

  @override
  String get browser_unopened => 'Chưa có trang nào được mở';

  @override
  String get browser_address_hint => 'Nhập hoặc dán URL';

  @override
  String get browser_invalid_address => 'Nhập URL hợp lệ';

  @override
  String get browser_clear_address => 'Xóa URL';

  @override
  String get browser_paste_address => 'URL';

  @override
  String get browser_open_address => 'Mở URL';

  @override
  String browser_tab_count(int count) {
    return 'Tab · $count';
  }

  @override
  String get browser_load_failed => 'Không thể mở trang này';

  @override
  String get browser_load_failed_hint => 'Kiểm tra kết nối của bạn và URL.';

  @override
  String get browser_edit_address => 'Chỉnh sửa URL';

  @override
  String get browser_clear_cookies_confirm =>
      'Xóa phiên đăng nhập cho tất cả các trang web?';

  @override
  String get browser_clear_cookies_hint =>
      'Các trang web trong tất cả các tab có thể yêu cầu bạn đăng nhập lại.';

  @override
  String get browser_clear_cookies_action => 'Xóa phiên đăng nhập';

  @override
  String get browser_tab_limit =>
      'Bạn có thể mở tối đa 12 tab. Đóng một cái trước.';

  @override
  String get browser_forward => 'Chuyển tiếp';

  @override
  String get browser_clear_all_cookies =>
      'Xóa tất cả các phiên đăng nhập trang web';

  @override
  String get browser_clear_failed => 'Không thể xóa phiên. Vui lòng thử lại.';

  @override
  String get browser_save_failed => 'Không thể lưu tab. Vui lòng thử lại.';

  @override
  String get browser_tabs_full => '12 tab đã được mở';

  @override
  String get browser_no_tabs => 'Chưa có tab nào được mở';

  @override
  String get browser_close_failed =>
      'Không thể lưu tab. Nhấn vào đóng lại để thử lại.';

  @override
  String get source_pinned_websites => 'Trang web được ghim';

  @override
  String get manage => 'Quản lý';

  @override
  String get translation_settings_hint => 'Dịch tự động, ngôn ngữ đích và kênh';

  @override
  String get translation_show_original => 'Nhấn để hiển thị bản gốc';

  @override
  String get translation_show_translated => 'Nhấn để hiển thị bản dịch';

  @override
  String get source_display => 'Hiển thị';

  @override
  String get source_cover_title => 'Bìa và tựa đề';

  @override
  String get source_cover_only => 'Chỉ bìa';

  @override
  String get source_save_search => 'Lưu tìm kiếm hiện tại';

  @override
  String get source_saved_searches => 'Tìm kiếm đã lưu';

  @override
  String get source_website_info => 'Thông tin trang web';

  @override
  String source_saved_search_title(String title) {
    return '$title · Nhấn để tìm kiếm';
  }

  @override
  String get action_done => 'Xong';

  @override
  String source_search_keyword(String query) {
    return 'Từ khóa: $query';
  }

  @override
  String get source_no_saved_searches => 'Chưa lưu tìm kiếm nào';

  @override
  String get source_save_search_hint =>
      'Tìm kiếm từ khóa, sau đó lưu nó từ các thao tác trên trang web.';

  @override
  String get source_saved_search_scope =>
      'Từ khóa chỉ được lưu cho trang web này.';

  @override
  String get source_search_here => 'Tìm kiếm tiêu đề trên trang web này';

  @override
  String get source_filter_results => 'Kết quả đã lọc';

  @override
  String get source_search_results => 'Kết quả tìm kiếm';

  @override
  String get source_return_popular => 'Trở lại phổ biến';

  @override
  String get source_popular_titles => 'Danh hiệu phổ biến';

  @override
  String get source_no_titles => 'Không tìm thấy tiêu đề phù hợp';

  @override
  String get source_no_titles_hint =>
      'Thay đổi từ khóa hoặc bộ lọc của bạn hoặc quay lại các tiêu đề phổ biến.';

  @override
  String get source_load_more_failed => 'Không thể tải thêm. Vui lòng thử lại.';

  @override
  String get source_load_pull_retry =>
      'Không thể tải trang web này. Kéo xuống để thử lại.';

  @override
  String get source_clear_failed =>
      'Không thể hoàn tất việc xóa. Vui lòng thử lại.';

  @override
  String get source_uninstall_failed =>
      'Không thể hoàn tất việc gỡ cài đặt. Vui lòng thử lại.';

  @override
  String get source_details => 'Chi tiết nguồn';

  @override
  String get source_repository_website => 'Trang web lưu trữ';

  @override
  String get source_provided_settings => 'Cài đặt do nguồn cung cấp';

  @override
  String get source_advanced_actions => 'Hành động nâng cao';

  @override
  String get source_edit_metadata => 'Chỉnh sửa thông tin nguồn';

  @override
  String get source_clear_cookies => 'Xóa cookie cho trang web này';

  @override
  String get source_clear_cookies_hint =>
      'Bạn có thể cần phải đăng nhập lại vào lần truy cập tiếp theo.';

  @override
  String get source_uninstall => 'Gỡ cài đặt nguồn';

  @override
  String get source_settings_save_failed =>
      'Quá trình lưu chưa hoàn tất. Mở lại cài đặt nguồn để kiểm tra.';

  @override
  String get repository_third_party => 'Kho lưu trữ của bên thứ ba';

  @override
  String get repository_refresh_failed =>
      'Không thể làm mới danh mục. Nội dung được lưu trong bộ nhớ đệm sẽ được lưu giữ. Vui lòng thử lại.';

  @override
  String get repository_show_sources => 'Hiển thị nguồn từ kho lưu trữ này';

  @override
  String get repository_copy_catalog => 'Sao chép liên kết danh mục';

  @override
  String get repository_remove => 'Xóa kho lưu trữ';

  @override
  String get repository_remove_hint =>
      'Giữ các nguồn đã cài đặt và xóa các mục danh mục đã gỡ cài đặt.';

  @override
  String get repository_empty =>
      'Chưa có kho lưu trữ của bên thứ ba nào được thêm vào';

  @override
  String get repository_built_in => 'Danh mục chính thức tích hợp';

  @override
  String get repository_hidden => 'Ẩn';

  @override
  String get repository_refreshing => 'Đang làm mới…';

  @override
  String get repository_refresh => 'Làm mới danh mục';

  @override
  String get repository_manage_hint =>
      'Quản lý nơi tải xuống nguồn của bên thứ ba.';

  @override
  String get repository_invalid_address => 'Nhập HTTP hoặc HTTPS URL hợp lệ';

  @override
  String get repository_already_added => 'Kho lưu trữ này đã được thêm vào';

  @override
  String get repository_unrecognized =>
      'Không tìm thấy danh mục được hỗ trợ. Hãy kiểm tra liên kết và thử lại.';

  @override
  String get repository_read_failed =>
      'Không thể đọc được danh mục. Vui lòng thử lại.';

  @override
  String get repository_save_failed =>
      'Quá trình lưu chưa hoàn tất. Kiểm tra danh sách kho lưu trữ của bạn.';

  @override
  String get repository_paste_hint =>
      'Dán liên kết danh mục kho lưu trữ của bên thứ ba';

  @override
  String get repository_address => 'URL';

  @override
  String get repository_paste_link => 'Dán liên kết';

  @override
  String repository_recognized(String type) {
    return '$type · Danh mục được công nhận';
  }

  @override
  String get repository_choose_sources_hint =>
      'Sau khi thêm kho lưu trữ, hãy chọn nguồn bạn cần.';

  @override
  String get search_scope => 'Phạm vi tìm kiếm';

  @override
  String get search_scope_hint => 'Chọn các trang web cần tìm kiếm';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tìm kiếm $count website',
      one: 'Tìm kiếm 1 trang web',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Tìm một trang web';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trang web được chọn',
      one: '1 trang web được chọn',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Xóa';

  @override
  String get search_deselect_results => 'Bỏ chọn các trang web phù hợp';

  @override
  String get search_select_results => 'Chọn trang web phù hợp';

  @override
  String get search_no_websites_hint =>
      'Không có trang web phù hợp. Hãy thử tên hoặc ngôn ngữ khác.';

  @override
  String get search_select_website_hint =>
      'Chọn ít nhất một trang web để tìm kiếm.';

  @override
  String get search_start_title => 'Nhập từ khóa tìm tiêu đề';

  @override
  String get search_start_hint =>
      'Tìm kiếm nhiều trang web cùng một lúc và hiển thị tiêu đề phù hợp.';

  @override
  String get search_empty_scope =>
      'Không có trang web nào có thể tìm kiếm được trong phạm vi này';

  @override
  String get search_empty_scope_hint =>
      'Chuyển sang tất cả các trang web hoặc chọn trang web để tìm kiếm.';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kết quả',
      one: '1 kết quả',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'Tìm kiếm tiêu đề';

  @override
  String get search_actions => 'Hành động tìm kiếm';

  @override
  String get search_details => 'Chi tiết tìm kiếm';

  @override
  String get search_title_hint => 'Tìm kiếm theo tiêu đề';

  @override
  String get search_searching => 'Đang tìm kiếm';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã tìm thấy $count kết quả',
      one: 'Tìm thấy 1 kết quả',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'Không có kết quả phù hợp';

  @override
  String get search_failed => 'Tìm kiếm không thành công';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tìm thấy tiêu đề',
      one: '1 tiêu đề được tìm thấy',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: '$websites trang web',
      one: '1 trang web',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Tìm tiêu đề';

  @override
  String get search_complete => 'Tìm kiếm hoàn tất';

  @override
  String get search_in_progress => 'Đang tìm kiếm';

  @override
  String get search_finding_related => 'Đang tìm kiếm tiêu đề phù hợp…';

  @override
  String get search_no_results_yet => 'Chưa có kết quả tìm kiếm';

  @override
  String get search_no_matching_titles => 'Không tìm thấy tiêu đề phù hợp';

  @override
  String get search_results_appear_hint =>
      'Kết quả sẽ xuất hiện ở đây khi chúng được tìm thấy.';

  @override
  String get search_failed_websites_hint =>
      'Một số trang web không thể hoàn tất tìm kiếm. Hãy thử lại chúng trong chi tiết tìm kiếm.';

  @override
  String get search_change_keywords_hint =>
      'Hãy thử từ khóa ngắn hơn hoặc tìm kiếm nhiều trang web hơn.';

  @override
  String get search_view_details => 'Xem chi tiết tìm kiếm';

  @override
  String get search_adjust_scope => 'Điều chỉnh phạm vi tìm kiếm';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trang web',
      one: '1 trang web',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Đã hoàn thành $completed / $total';
  }

  @override
  String get search_retry_website_hint => 'Thử lại từng trang web bị lỗi';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mục được chọn',
      one: 'Đã chọn 1 mục',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Tìm kiếm ngôn ngữ';

  @override
  String get source_deselect => 'Bỏ chọn';

  @override
  String get source_select => 'Chọn nguồn';

  @override
  String get source_multilingual => 'Đa ngôn ngữ';

  @override
  String get source_language_unknown => 'Ngôn ngữ không được chỉ định';

  @override
  String get source_adult_content => 'Chứa nội dung 18+';

  @override
  String get source_classification_unknown => 'Phân loại không được chỉ định';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xem tất cả thông tin nguồn, $count danh mục khác',
      one: 'Xem tất cả thông tin nguồn, thêm 1 danh mục',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Đang tải trang web';

  @override
  String get source_unpin => 'Bỏ ghim';

  @override
  String get source_pin => 'Ghim';

  @override
  String get source_open => 'Mở';

  @override
  String get source_metadata_hint =>
      'Thông tin đến từ danh mục nguồn. Các danh mục mô tả nội dung được bao phủ bởi trang web.';

  @override
  String get source_region => 'Vùng';

  @override
  String get source_format => 'định dạng';

  @override
  String get source_creation => 'Sáng tạo';

  @override
  String get source_unspecified => 'Không được chỉ định';

  @override
  String get source_pricing => 'Giá cả';

  @override
  String get source_region_jp => 'truyện tranh Nhật Bản';

  @override
  String get source_region_kr => 'truyện tranh Hàn Quốc';

  @override
  String get source_region_cn => 'Truyện tranh Trung Quốc';

  @override
  String get source_region_hk_tw => 'Truyện tranh Hồng Kông và Đài Loan';

  @override
  String get source_region_western => 'Truyện tranh phương Tây';

  @override
  String get source_region_other => 'Các vùng khác';

  @override
  String get source_format_page => 'Truyện tranh phân trang';

  @override
  String get source_format_vertical => 'Truyện tranh dọc';

  @override
  String get source_format_strip => 'Truyện tranh';

  @override
  String get source_creation_original => 'Bản gốc';

  @override
  String get source_creation_fan => 'Tác phẩm của quạt';

  @override
  String get source_free_watch => 'Xem miễn phí';

  @override
  String get source_free_read => 'Đọc miễn phí';

  @override
  String get source_partial_paid => 'Đã thanh toán một phần';

  @override
  String get source_paid_watch => 'Xem trả phí';

  @override
  String get source_paid_read => 'Đọc trả phí';

  @override
  String get source_pricing_unknown => 'Giá cả không được chỉ định';

  @override
  String get source_language_filter => 'Lọc theo ngôn ngữ';

  @override
  String get source_language_filter_hint =>
      'Chỉ lọc danh mục này. Các nguồn được cài đặt không bị ảnh hưởng.';

  @override
  String get source_all_languages => 'Tất cả ngôn ngữ';

  @override
  String get action_apply => 'Áp dụng';

  @override
  String get source_load_retry =>
      'Không thể tải trang web này. Vui lòng thử lại.';

  @override
  String get source_catalog_refresh_failed =>
      'Không thể làm mới danh mục. Nội dung hiện tại được lưu giữ. Kéo xuống để thử lại.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gỡ cài đặt $count nguồn?',
      one: 'Gỡ bỏ 1 nguồn?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Gỡ cài đặt các nguồn đã chọn và xóa cài đặt của chúng. Giữ tiêu đề thư viện và nội dung tải xuống.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hành động không thành công đối với nguồn $count.',
      one: 'Hành động không thành công đối với 1 nguồn.',
    );
    return '$_temp0 Lựa chọn được giữ lại. Vui lòng thử lại.';
  }

  @override
  String get source_latest_content => 'Nội dung mới nhất';

  @override
  String get source_actions => 'Hành động nguồn';

  @override
  String get source_bulk_manage => 'Quản lý nhiều nguồn';

  @override
  String get source_update_installed => 'Cập nhật các nguồn đã cài đặt';

  @override
  String get source_no_matching_websites => 'Không có trang web phù hợp';

  @override
  String get source_no_websites => 'Không có trang web nào';

  @override
  String get source_search_installed_hint =>
      'Tìm kiếm tiêu đề trong các nguồn đã cài đặt';

  @override
  String get source_global_search => 'Tìm kiếm trên các nguồn';

  @override
  String get source_manage_repositories => 'Quản lý kho lưu trữ';

  @override
  String get source_view_third_party => 'Xem nguồn của bên thứ ba';

  @override
  String get source_catalog_load_failed =>
      'Không thể tải danh mục. Kéo xuống để thử lại.';

  @override
  String get source_all_websites => 'Tất cả các trang web';

  @override
  String get source_available => 'Có sẵn để cài đặt';

  @override
  String get source_third_party => 'Bên thứ ba';

  @override
  String get source_name_or_title => 'Tên hoặc tiêu đề trang web';

  @override
  String get view_all => 'Xem tất cả';

  @override
  String get search_searching_ellipsis => 'Đang tìm kiếm…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · Chưa được kiểm tra';
  }

  @override
  String get onboarding_untested => 'Chưa được kiểm tra';

  @override
  String get source_custom_scope => 'Tùy chỉnh';

  @override
  String get source_custom_websites => 'Các trang web được chọn';

  @override
  String get tv_hidden_library_hint =>
      'Mỗi tiêu đề đều nằm trong một danh mục ẩn.\nGiữ OK ở “Tất cả” để hiện một mục.';

  @override
  String get tv_no_matching_anime => 'Không có anime phù hợp';

  @override
  String tv_no_matching_category(String category) {
    return 'Không có anime phù hợp trong “$category”';
  }

  @override
  String get tv_filtered_empty_hint =>
      'Không có anime nào phù hợp với bộ lọc hiện tại.\nThay đổi chúng từ nút bên cạnh tìm kiếm.';

  @override
  String get tv_new_episodes => 'Tập Mới';

  @override
  String get tv_recently_added => 'Đã thêm gần đây';

  @override
  String get tv_empty_category_hint =>
      'Chưa có anime nào trong danh mục này.\nThêm tiêu đề cho nó từ trang chi tiết của tiêu đề.';

  @override
  String get tv_empty_library => 'Thư viện anime của bạn trống';

  @override
  String get tv_empty_library_hint =>
      'Thêm anime từ Duyệt để lấp đầy ngôi nhà của bạn';

  @override
  String get tv_browse_anime => 'Duyệt phim hoạt hình';

  @override
  String tv_new_count(int count) {
    return '$count mới';
  }

  @override
  String tv_category_hidden(String category) {
    return 'Ẩn “$category” · giữ OK ở “All” để hiện';
  }

  @override
  String get tv_no_hidden_categories => 'Không có danh mục ẩn';

  @override
  String get import_torrent_file => 'nhập tập tin .torrent';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi, v.v.';

  @override
  String get cloudflare_proxy_optional => 'FlareSolverr tùy chọn / Byparr URL';

  @override
  String get tv_home_layout_hint =>
      'Trang chủ anime theo hàng (Tiếp tục · Tập mới · danh mục) thay vì lưới phẳng';

  @override
  String get tv_hide_libraries_hint =>
      'Ẩn thư viện manga & tiểu thuyết (bật theo mặc định trên TV)';

  @override
  String get anime_only_hint =>
      'Ẩn manga & tiểu thuyết trên ứng dụng. Tắt để hiển thị mọi thứ.';

  @override
  String get audio_auto_safe => 'Tự động an toàn';

  @override
  String get tv_player_hint =>
      'Bật: đầu phát TV chuyên dụng.  Tắt: trình phát gốc (máy tính để bàn).';

  @override
  String get release_open_failed => 'Không thể mở bản phát hành';

  @override
  String get tv_replay => 'Phát lại';

  @override
  String get tv_no_episodes => 'Chưa có tập nào';

  @override
  String get tracker_continue_series => 'Tiếp tục xem loạt phim';

  @override
  String get tracker_watchlist_series => 'Chuỗi danh sách theo dõi';

  @override
  String get tracker_continue_movies => 'Tiếp tục xem phim';

  @override
  String get tracker_watchlist_movies => 'Danh sách phim theo dõi';

  @override
  String get tracker_trending_series => 'Dòng Xu Hướng';

  @override
  String get tracker_trending_movies => 'Phim thịnh hành';

  @override
  String get tracker_popular_series => 'Series nổi tiếng';

  @override
  String get tracker_popular_movies => 'Phim Nổi Tiếng';

  @override
  String get tracker_top_series => 'Top Series (Mọi Thời Đại)';

  @override
  String get tracker_top_movies => 'Phim Hay Nhất (Mọi Thời Đại)';

  @override
  String get tracker_airing_series => 'Loạt phim đang phát sóng';

  @override
  String get tracker_airing_anime => 'Anime đang phát sóng';

  @override
  String get tracker_popular_anime => 'Anime nổi tiếng';

  @override
  String get tracker_upcoming_anime => 'Anime sắp ra mắt';

  @override
  String get tracker_popular_manga => 'Manga nổi tiếng';

  @override
  String get tracker_top_manga => 'Manga hàng đầu';

  @override
  String get tracker_top_manhwa => 'Manhwa hàng đầu';

  @override
  String get tracker_top_manhua => 'Manhua hàng đầu';

  @override
  String get tracker_latest_anime => 'Anime mới nhất';

  @override
  String get tracker_best_anime => 'Anime được đánh giá tốt nhất';

  @override
  String get tracker_latest_manga => 'Manga mới nhất';

  @override
  String get tracker_best_manga => 'Manga được đánh giá hay nhất';

  @override
  String get tracker_trending_anime => 'Anime thịnh hành';

  @override
  String get tracker_upcoming_manga => 'Manga sắp ra mắt';

  @override
  String get tracker_trending_manga => 'Manga thịnh hành';

  @override
  String selection_progress(int selected, int total) {
    return '$selected/$total đã chọn';
  }

  @override
  String get source_code_editor => 'Trình soạn thảo mã';

  @override
  String get source_code_execute => 'Thực hiện';

  @override
  String get source_console_logs => 'Nhật ký bảng điều khiển';

  @override
  String get source_no_logs => 'Chưa có nhật ký nào';

  @override
  String get source_updated_successfully => 'Đã cập nhật nguồn thành công';

  @override
  String get source_obsolete => 'LỖI NGÀY';

  @override
  String player_seek_forward_seconds(int seconds) {
    return 'Tua tới $seconds giây';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return 'Tua lùi $seconds giây';
  }

  @override
  String get player_autoplay_on => 'Tự động phát tập tiếp theo: bật';

  @override
  String get player_autoplay_off => 'Tự động phát tập tiếp theo: tắt';

  @override
  String get player_no_other_quality => 'Không có chất lượng khác';

  @override
  String get player_no_subtitles => 'Không có phụ đề';

  @override
  String get player_no_audio_tracks => 'Không có bản âm thanh';

  @override
  String get player_seek_forward => 'Tìm về phía trước';

  @override
  String get player_seek_backward => 'Tìm về phía sau';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds giây',
      one: '1 giây',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'Lorem ipsum dolor ngồi amet';

  @override
  String get subtitle_style => 'Phong cách';

  @override
  String get translation_official_channel => 'NodeLane Chính thức';

  @override
  String get translation_auth_required =>
      'Trước tiên hãy đăng nhập vào tài khoản dịch của bạn.';

  @override
  String get translation_source_changed =>
      'Hình ảnh gốc đã thay đổi. Vui lòng tải lại nó.';

  @override
  String get translation_source_missing => 'Hình ảnh gốc hiện không có sẵn.';

  @override
  String get translation_resource_limit =>
      'Hình ảnh này vượt quá giới hạn xử lý của thiết bị. Bản gốc được giữ lại.';

  @override
  String get translation_storage_full =>
      'Bộ nhớ dịch đã đầy. Xóa hình ảnh đã dịch trước.';

  @override
  String get translation_invalid_image =>
      'Định dạng hoặc nội dung hình ảnh không hợp lệ.';

  @override
  String get translation_unsupported_image =>
      'Bản dịch không được hỗ trợ cho hình ảnh này. Bản gốc được giữ lại.';

  @override
  String get translation_invalid_result =>
      'Xác thực hình ảnh đã dịch không thành công. Vui lòng tải lại nó.';

  @override
  String get translation_result_unavailable =>
      'Hình ảnh đã dịch không có sẵn. Vui lòng tải lại nó.';

  @override
  String get translation_result_expired =>
      'Hình ảnh đã dịch đã hết hạn. Hãy dịch lại lần nữa.';

  @override
  String get translation_analysis_too_large =>
      'Có quá nhiều nội dung hình ảnh cần phân tích. Hãy giảm kích thước hình ảnh và thử lại.';

  @override
  String get translation_region_limit =>
      'Hình ảnh có quá nhiều vùng văn bản. Hãy tách nó ra và thử lại.';

  @override
  String get translation_text_limit =>
      'Vùng văn bản quá dài. Điều chỉnh hình ảnh và thử lại.';

  @override
  String get translation_unavailable => 'Bản dịch này không còn nữa.';

  @override
  String get translation_outcome_unknown =>
      'Kết quả cần được xác minh. Nó chưa được gửi lại.';

  @override
  String get translation_rate_limited =>
      'Yêu cầu bị hạn chế. Quá trình dịch sẽ tự động tiếp tục.';

  @override
  String get translation_quota_exhausted => 'Hạn ngạch dịch không đủ.';

  @override
  String get translation_unsupported_language =>
      'Dịch vụ không hỗ trợ ngôn ngữ đích này.';

  @override
  String get translation_upgrade_required =>
      'Giao thức dịch thuật không tương thích. Cập nhật ứng dụng.';

  @override
  String get translation_remote_failed =>
      'Dịch trang này không thành công. Bạn có thể thử lại bằng tay.';

  @override
  String get translation_bridge_invalid =>
      'Trang web đã thay đổi. Bật dịch lại.';

  @override
  String get translation_connection_failed =>
      'Kết nối không thành công. Vui lòng thử lại.';

  @override
  String get translation_paused =>
      'Bản dịch bị tạm dừng. Bạn có thể xác minh tiến trình của nó.';

  @override
  String get translation_preparing_ellipsis => 'Đang chuẩn bị dịch…';

  @override
  String get translation_checking_original => 'Đang kiểm tra ảnh gốc…';

  @override
  String get translation_submitting => 'Đang gửi…';

  @override
  String get translation_uploading_ellipsis => 'Đang tải lên bản gốc…';

  @override
  String get translation_waiting_ellipsis => 'Đang chờ dịch…';

  @override
  String get translation_running_ellipsis => 'Dịch…';

  @override
  String get translation_verify_result => 'Kết quả cần xác minh';

  @override
  String get translation_partial => 'Một số nội dung đã được dịch';

  @override
  String get translation_ready => 'Hình ảnh đã được dịch sẵn';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Chơi';

  @override
  String get player_quality => 'Chất lượng';

  @override
  String get player_subtitles => 'Phụ đề';

  @override
  String get player_audio => 'Âm thanh';

  @override
  String get player_statistics => 'Thống kê cho người mọt sách';

  @override
  String get player_auto => 'Tự động';

  @override
  String get source_information => 'Nguồn thông tin';

  @override
  String get source_code_page => 'Trang';

  @override
  String get source_code_query => 'Truy vấn';

  @override
  String get repository_invalid_source => 'Nguồn không hợp lệ - hãy xóa nó';

  @override
  String get player_fit_contain => 'Chứa';

  @override
  String get player_fit_cover => 'Bìa';

  @override
  String get player_fit_fill => 'Điền vào';

  @override
  String get player_fit_height => 'Chiều cao';

  @override
  String get player_fit_width => 'Chiều rộng';

  @override
  String get player_fit_scale => 'Cân';

  @override
  String get player_fit_none => 'Không có';

  @override
  String get player_shader_clear => 'Tắt (xóa bóng đổ)';

  @override
  String get player_shader_luma => 'Nâng cấp Luma';

  @override
  String get player_decoder_auto => 'Tự động (phần cứng)';

  @override
  String get player_decoder_software => 'Phần mềm (không có phần cứng)';

  @override
  String get player_stats_toggle => 'Chuyển đổi lớp phủ';

  @override
  String get player_stats_general => 'Tổng quát';

  @override
  String get player_stats_frames => 'Định giờ khung hình';

  @override
  String get player_stats_cache => 'Bộ đệm đầu vào';

  @override
  String get player_stats_filters => 'Bộ lọc hoạt động';

  @override
  String get player_stats_log => 'Nhật ký';

  @override
  String get source_mark_pinned => 'Ghim';

  @override
  String translation_image_action(String action) {
    return '$action hình ảnh này';
  }

  @override
  String get memory_waiting => 'bộ nhớ: chờ mẫu';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current đỉnh $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'bộ đệm $current / $limit đỉnh $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'mặt hàng $count / $limit trực tiếp $live đỉnh cao $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mẫu',
      one: '1 mẫu',
    );
    return 'đầy $percent% của $_temp0';
  }

  @override
  String get memory_reset_hint => 'tắt và bật nó trong cài đặt để đặt lại';

  @override
  String get action_hide => 'Ẩn';

  @override
  String discord_get_app(String app) {
    return 'Nhận $app';
  }

  @override
  String get discord_idle => 'Nhàn rỗi';

  @override
  String discord_watching_title(String title) {
    return 'Đang xem $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'Đọc $title';
  }
}
