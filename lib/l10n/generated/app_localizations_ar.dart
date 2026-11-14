// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get browser_search_hint => 'ابحث أو أدخل عنوان URL';

  @override
  String get browser_start_hint => 'صفحة جديدة لاكتشافات جديدة.';

  @override
  String get browser_search_engine => 'محرك البحث';

  @override
  String get browser_bookmarks => 'الإشارات المرجعية';

  @override
  String get browser_search_library => 'ابحث في العناوين أو الروابط';

  @override
  String get browser_data_failed =>
      'تعذرت قراءة بيانات المتصفح أو حفظها. حاول مجددًا.';

  @override
  String get browser_clear_history => 'مسح سجل التصفح';

  @override
  String get browser_clear_history_hint =>
      'هل تريد حذف سجل التصفح بالكامل على هذا الجهاز؟ ستبقى الإشارات المرجعية وجلسات تسجيل الدخول.';

  @override
  String get browser_library_empty => 'لا توجد عناصر بعد';

  @override
  String get browser_bookmarks_hint =>
      'أضف الصفحة إلى الإشارات المرجعية من قائمتها لتجدها هنا.';

  @override
  String get browser_history_hint =>
      'تبقى الصفحات التي تزورها هنا حتى بعد إغلاق علامات تبويبها.';

  @override
  String get browser_recent => 'الزيارات الأخيرة';

  @override
  String get browser_pinned_hint =>
      'ثبّت مواقعك المفضلة في المصادر للوصول السريع إليها.';

  @override
  String get browser_start_page => 'صفحة البداية';

  @override
  String get browser_remove_bookmark => 'إزالة الإشارة المرجعية';

  @override
  String get browser_add_bookmark => 'إضافة إشارة مرجعية';

  @override
  String get browser_find => 'البحث في الصفحة';

  @override
  String get browser_copy_link => 'نسخ الرابط';

  @override
  String get browser_action_failed => 'تعذر إكمال الإجراء. حاول مجددًا.';

  @override
  String get browser_find_previous => 'التطابق السابق';

  @override
  String get browser_find_next => 'التطابق التالي';

  @override
  String browser_find_matches(int current, int total) {
    return 'التطابق $current من $total';
  }

  @override
  String get app_update_details_hint => 'عرض ملاحظات الإصدار وخيارات التثبيت';

  @override
  String get app_update_download => 'تنزيل التحديث';

  @override
  String get app_update_download_hint =>
      'بعد التنزيل، اتبع المطالبات لتثبيت التحديث.';

  @override
  String get bookshelf_all => 'الكل';

  @override
  String get bookshelf_search => 'مكتبة البحث';

  @override
  String get app_update_allow_install =>
      'السماح بتثبيت التطبيق في إعدادات النظام، ثم العودة والضغط على تثبيت.';

  @override
  String get app_update_waiting => 'في انتظار النظام لاستئناف التحميل...';

  @override
  String get app_update_cancel_download => 'إلغاء التنزيل';

  @override
  String get app_update_remove_package => 'إزالة الحزمة التي تم تنزيلها';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'لا توجد إعدادات مطابقة';

  @override
  String get search_empty_hint =>
      'جرب كلمة رئيسية أخرى، أو امسح البحث لترى كل شيء.';

  @override
  String get search_clear => 'مسح البحث';

  @override
  String get app_updates => 'تحديثات التطبيق';

  @override
  String get app_update_auto => 'التحقق من الإطلاق';

  @override
  String get app_update_view => 'عرض التحديث';

  @override
  String get app_update_later => 'لاحقا';

  @override
  String get app_update_external_hint => 'يفتح رابط التحديث في متصفحك';

  @override
  String get app_update_failed =>
      'غير قادر على التحقق من وجود تحديثات. يرجى المحاولة مرة أخرى.';

  @override
  String get app_update_opened => 'تم فتح رابط التحديث';

  @override
  String get app_diagnostics => 'التشخيص والسجلات';

  @override
  String get library => 'المكتبة';

  @override
  String get updates_search => 'تحديثات البحث';

  @override
  String get updates => 'التحديثات';

  @override
  String get history => 'التاريخ';

  @override
  String get browse => 'تصفح';

  @override
  String get more => 'المزيد';

  @override
  String get open_random_entry => 'فتح مدخل عشوائي';

  @override
  String get import => 'استيراد';

  @override
  String get filter => 'مرشح';

  @override
  String get ignore_filters => 'تجاهل مرشح';

  @override
  String get downloaded => 'تم التحميل';

  @override
  String get unread => 'غير مقروء';

  @override
  String get unwatched => 'لم يشاهد';

  @override
  String get started => 'بدأ';

  @override
  String get bookmarked => 'مُرجع';

  @override
  String get sort => 'ترتيب';

  @override
  String get alphabetically => 'أبجدياً';

  @override
  String get last_read => 'آخر قراءة';

  @override
  String get last_watched => 'آخر مشاهدة';

  @override
  String get last_update_check => 'آخر فحص للتحديثات';

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
          'أنت بتحذف كل الـ$count $entryTypePlural من هذا الـ$mediaType من المكتبة.',
      one: 'أنت بتحذف الـ$entryType الوحيد من هذا الـ$mediaType من المكتبة.',
    );
    return '$_temp0\nهذا كمان هيشيل الـ$mediaType بالكامل من مكتبتك.\n\nملاحظة: الملفات نفسها مش هتتحذف.';
  }

  @override
  String get chapter => 'فصل';

  @override
  String get episode => 'حلقة';

  @override
  String get unread_count => 'عدد غير المقروء';

  @override
  String get unwatched_count => 'عدد غير المشاهد';

  @override
  String get latest_chapter => 'أحدث فصل';

  @override
  String get latest_episode => 'الحلقة الأخيرة';

  @override
  String get date_added => 'تاريخ الإضافة';

  @override
  String get display => 'عرض';

  @override
  String get display_mode => 'وضع العرض';

  @override
  String get compact_grid => 'شبكة مضغوطة';

  @override
  String get compression_level => 'مستوى الضغط';

  @override
  String compression_info(Object level) {
    return 'كلما زاد الضغط، قل حجم ملف النسخة الاحتياطية، ولكنه يستهلك المزيد من المعالج. الافتراضي: $level';
  }

  @override
  String get comfortable_grid => 'شبكة مريحة';

  @override
  String get cover_only_grid => 'شبكة الغلاف فقط';

  @override
  String get list => 'قائمة';

  @override
  String get badges => 'شارات';

  @override
  String get downloaded_chapters => 'الفصول المحملة';

  @override
  String get downloaded_episodes => 'الحلقات المحملة';

  @override
  String get language => 'اللغة';

  @override
  String get local_source => 'مصدر محلي';

  @override
  String get tabs => 'التبويبات';

  @override
  String get show_category_tabs => 'إظهار تبويبات الفئة';

  @override
  String get show_numbers_of_items => 'إظهار عدد العناصر';

  @override
  String get other => 'آخر';

  @override
  String get show_continue_reading_buttons =>
      'إظهار أزرار الاستمرار في القراءة';

  @override
  String get show_continue_watching_buttons => 'إظهار أزرار المتابعة';

  @override
  String get empty_library => 'مكتبة فارغة';

  @override
  String get search => 'بحث...';

  @override
  String get no_recent_updates => 'لا تحديثات حديثة';

  @override
  String get remove_everything => 'إزالة كل شيء';

  @override
  String get remove_everything_msg => 'هل أنت متأكد؟ سيتم فقدان كل التاريخ';

  @override
  String get remove_all_update_msg => 'هل أنت متأكد؟ سيتم مسح التحديث بالكامل';

  @override
  String get ok => 'حسنًا';

  @override
  String get cancel => 'إلغاء';

  @override
  String get remove => 'إزالة';

  @override
  String get remove_history_msg =>
      'سيتم إزالة تاريخ القراءة لهذا الفصل. هل أنت متأكد؟';

  @override
  String get last_used => 'آخر استخدام';

  @override
  String get pinned => 'مثبت';

  @override
  String get sources => 'المصادر';

  @override
  String get install => 'تثبيت';

  @override
  String get update => 'تحديث';

  @override
  String get latest => 'الأحدث';

  @override
  String get extensions => 'الإضافات';

  @override
  String get migrate => 'ترحيل';

  @override
  String get mass_migration_title => 'الهجرة الجماعية';

  @override
  String get mass_migration_preview_items => 'معاينة العناصر';

  @override
  String get mass_migration_destination_source => 'المصدر الوجهة';

  @override
  String get mass_migration_no_library_items =>
      'لا توجد عناصر مكتبة متاحة للهجرة الجماعية.';

  @override
  String get mass_migration_no_destination_sources =>
      'لا توجد مصادر وجهة مثبتة متاحة.';

  @override
  String get mass_migration_installed => 'تم التثبيت';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر جاهز للمراجعة',
      many: '$count عنصر جاهز للمراجعة',
      few: '$count عناصر جاهزة للمراجعة',
      two: 'عنصران جاهزان للمراجعة',
      one: 'عنصر واحد جاهز للمراجعة',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصر',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'اختر المصدر الوجهة';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'البحث عن مطابقات في $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'جاري معالجة العنصر $current من $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'الانتظار لمدة ثانيتين قبل العنصر التالي...';

  @override
  String get mass_migration_waiting_next_migration =>
      'الانتظار لمدة ثانيتين قبل الهجرة التالية...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'المطابقات حتى الآن: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'لا يوجد تطابق: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'مراجعة المطابقات لـ $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'المطابقات التي تم العثور عليها: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'لا توجد مطابقات: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'المختارة للهجرة: $count';
  }

  @override
  String get mass_migration_finish_review => 'إنهاء المراجعة';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'هجرة العناصر المختارة ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'جاري هجرة العناصر المختارة إلى $source';
  }

  @override
  String get mass_migration_no_items_selected => 'لم يتم اختيار عناصر للهجرة.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'جاري هجرة العنصر $current من $total';
  }

  @override
  String get mass_migration_complete => 'اكتملت الهجرة الجماعية';

  @override
  String get mass_migration_complete_success_message =>
      'تمت معالجة جميع العناصر المختارة بنجاح.';

  @override
  String get mass_migration_complete_partial_message =>
      'انتهت الهجرة مع بقاء بعض العناصر التي لا تزال بحاجة إلى اهتمام يدوي.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source ← $destination';
  }

  @override
  String get mass_migration_processed => 'تمت المعالجة';

  @override
  String get mass_migration_matched => 'متطابق';

  @override
  String get mass_migration_migrated => 'تمت الهجرة';

  @override
  String get mass_migration_skipped => 'تم التخطي';

  @override
  String get mass_migration_failed => 'فشل';

  @override
  String get mass_migration_failed_items => 'العناصر الفاشلة';

  @override
  String get mass_migration_exit => 'الخروج من الهجرة الجماعية';

  @override
  String get mass_migration_no_destination_match =>
      'لم يتم العثور على تطابق في الوجهة';

  @override
  String mass_migration_query(Object query) {
    return 'الاستعلام: $query';
  }

  @override
  String get mass_migration_skip => 'تخطي';

  @override
  String get mass_migration_loading => 'جاري التحميل...';

  @override
  String get mass_migration_choose_another_result => 'اختر نتيجة أخرى';

  @override
  String get mass_migration_source_chapters => 'فصول المصدر';

  @override
  String get mass_migration_destination_chapters => 'فصول الوجهة';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل',
      many: '$count فصل',
      few: '$count فصول',
      two: 'فصلان',
      one: 'فصل واحد',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل مصدر',
      many: '$count فصل مصدر',
      few: '$count فصول مصدر',
      two: 'فصلان للمصدر',
      one: 'فصل مصدر واحد',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل وجهة',
      many: '$count فصل وجهة',
      few: '$count فصول وجهة',
      two: 'فصلان للوجهة',
      one: 'فصل وجهة واحد',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'لم يتم العثور على فصول.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'و $count أكثر...';
  }

  @override
  String get mass_migration_unknown_title => 'عنوان غير معروف';

  @override
  String get mass_migration_unknown_match => 'تطابق غير معروف';

  @override
  String get mass_migration_unknown_source => 'مصدر غير معروف';

  @override
  String get mass_migration_unknown_chapter => 'فصل غير معروف';

  @override
  String get migrate_confirm => 'الانتقال إلى مصدر آخر';

  @override
  String get clean_database => 'تنظيف قاعدة البيانات';

  @override
  String cleaned_database(Object x) {
    return 'تم تنظيف قاعدة البيانات! تمت إزالة $x إدخالات';
  }

  @override
  String get clean_database_desc =>
      'سيؤدي هذا إلى إزالة جميع العناصر التي لم تتم إضافتها إلى المكتبة!';

  @override
  String get incognito_mode => 'وضع التخفي';

  @override
  String get incognito_mode_description => 'يوقف سجل القراءة';

  @override
  String get downloaded_only => 'المحملة فقط';

  @override
  String get downloaded_only_description =>
      'إظهار الإدخالات المحملة فقط في مكتبتك';

  @override
  String get download_queue => 'قائمة الانتظار للتحميل';

  @override
  String get categories => 'الفئات';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get about => 'حول';

  @override
  String get help => 'مساعدة';

  @override
  String get no_downloads => 'لا توجد تحميلات';

  @override
  String get edit_categories => 'تحرير الفئات';

  @override
  String get edit_categories_description =>
      'ليس لديك أي فئات. اضغط على زر الإضافة لإنشاء واحدة لتنظيم مكتبتك';

  @override
  String get add => 'إضافة';

  @override
  String get add_category => 'إضافة فئة';

  @override
  String get name => 'اسم';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'الرابط';

  @override
  String get category_name_required => '*مطلوب';

  @override
  String get add_category_error_exist => 'فئة بهذا الاسم موجودة بالفعل!';

  @override
  String get delete_category => 'حذف الفئة';

  @override
  String delete_category_msg(Object name) {
    return 'هل ترغب في حذف الفئة $name؟';
  }

  @override
  String get rename_category => 'إعادة تسمية الفئة';

  @override
  String get general => 'عام';

  @override
  String get general_subtitle => 'لغة التطبيق';

  @override
  String get app_language => 'لغة التطبيق';

  @override
  String get default_subtitle_language => 'لغة الترجمة الافتراضية';

  @override
  String get appearance => 'المظهر';

  @override
  String get appearance_subtitle => 'الثيم، تنسيق التاريخ والوقت';

  @override
  String get theme => 'الثيم';

  @override
  String get dark_mode => 'الوضع المظلم';

  @override
  String get follow_system_theme => 'اتبع سمة النظام';

  @override
  String get on => 'مفعل';

  @override
  String get off => 'معطل';

  @override
  String get pure_black_dark_mode => 'الوضع المظلم الأسود النقي';

  @override
  String get timestamp => 'طابع الوقت';

  @override
  String get relative_timestamp => 'طابع الوقت النسبي';

  @override
  String get relative_timestamp_short => 'قصير (اليوم، أمس)';

  @override
  String get relative_timestamp_long => 'طويل (قصير+، منذ عدة أيام)';

  @override
  String get date_format => 'تنسيق التاريخ';

  @override
  String get reader => 'القارئ';

  @override
  String get refresh => 'تحديث';

  @override
  String get reader_subtitle => 'وضع القراءة، العرض، التنقل';

  @override
  String get default_reading_mode => 'وضع القراءة الافتراضي';

  @override
  String get reading_mode_vertical => 'عمودي';

  @override
  String get reading_mode_horizontal => 'أفقي';

  @override
  String get reading_mode_left_to_right => 'من اليسار إلى اليمين';

  @override
  String get reading_mode_right_to_left => 'من اليمين إلى اليسار';

  @override
  String get reading_mode_vertical_continuous => 'عمودي مستمر';

  @override
  String get reading_mode_webtoon => 'ويبتون';

  @override
  String get double_tap_animation_speed => 'سرعة النقر المزدوج';

  @override
  String get normal => 'عادي';

  @override
  String get fast => 'سريع';

  @override
  String get no_animation => 'بدون رسوم متحركة';

  @override
  String get animate_page_transitions => 'تحريك انتقالات الصفحة';

  @override
  String get crop_borders => 'قص الحواف';

  @override
  String get downloads => 'التحميلات';

  @override
  String get downloads_subtitle => 'إعدادات التحميل';

  @override
  String get download_location => 'موقع التحميل';

  @override
  String get custom_location => 'موقع مخصص';

  @override
  String get only_on_wifi => 'فقط على الواي فاي';

  @override
  String get save_as_cbz_archive => 'حفظ كأرشيف CBZ';

  @override
  String get delete_download_after_reading => 'حذف التحميل بعد القراءة';

  @override
  String get concurrent_downloads => 'التحميلات المتزامنة';

  @override
  String get browse_subtitle => 'المصادر، البحث العام';

  @override
  String get only_include_pinned_sources => 'تضمين المصادر المثبتة فقط';

  @override
  String get nsfw_sources => 'مصادر NSFW (+18)';

  @override
  String get nsfw_sources_show => 'إظهار في قوائم المصادر والإضافات';

  @override
  String get nsfw_sources_info =>
      'هذا لا يمنع الإضافات غير الرسمية أو المصنفة بشكل غير صحيح من عرض محتوى NSFW (18+) داخل التطبيق';

  @override
  String get version => 'الإصدار';

  @override
  String beta_version(Object version) {
    return 'تجريبي ($version)';
  }

  @override
  String get check_for_update => 'التحقق من التحديثات';

  @override
  String get logs_on => 'تفعيل التسجيل';

  @override
  String get share_app_logs => 'مشاركة سجلات التطبيق';

  @override
  String get no_app_logs => 'لا يوجد ملف log.txt!';

  @override
  String get failed => 'فشل!';

  @override
  String n_days_ago(Object days) {
    return 'منذ $days أيام';
  }

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get a_week_ago => 'منذ أسبوع';

  @override
  String get next_week => 'الأسبوع القادم';

  @override
  String get add_to_library => 'إضافة إلى المكتبة';

  @override
  String get completed => 'مكتمل';

  @override
  String get ongoing => 'جاري';

  @override
  String get on_hiatus => 'في فترة توقف';

  @override
  String get canceled => 'ملغى';

  @override
  String get publishing_finished => 'انتهاء النشر';

  @override
  String get unknown => 'غير معروف';

  @override
  String get empty_placeholder => 'فارغ';

  @override
  String get error => 'خطأ';

  @override
  String error_with_message(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get no_pages_available => 'خطأ: لا توجد صفحات متاحة';

  @override
  String get set_categories => 'ضبط الفئات';

  @override
  String get edit => 'تحرير';

  @override
  String get in_library => 'في المكتبة';

  @override
  String get filter_scanlator_groups => 'تصفية مجموعات المترجمين';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get by_source => 'حسب المصدر';

  @override
  String get by_chapter_number => 'حسب رقم الفصل';

  @override
  String get by_episode_number => 'حسب رقم الحلقة';

  @override
  String get by_upload_date => 'حسب تاريخ الرفع';

  @override
  String get source_title => 'عنوان المصدر';

  @override
  String get create_extension => 'إنشاء إضافة';

  @override
  String get developer_mode => 'وضع المطور';

  @override
  String get developer_mode_subtitle =>
      'إظهار أدوات مطور الإضافات (إنشاء إضافة، تعديل الكود)';

  @override
  String get choose_extension_language => 'اختر لغة الإضافة';

  @override
  String get lang => 'اللغة';

  @override
  String get base_url => 'الرابط الأساسي';

  @override
  String get api_url_optional => 'رابط API (اختياري)';

  @override
  String get icon_url => 'رابط الأيقونة';

  @override
  String get source_icon_url => 'رابط أيقونة المصدر';

  @override
  String get notes => 'ملاحظات';

  @override
  String get extension_name_example => 'مثال: myAnime';

  @override
  String get language_code_example => 'مثال: ar';

  @override
  String get base_url_example => 'مثال: https://example.com';

  @override
  String get api_url_example => 'مثال: https://api.example.com';

  @override
  String get extension_notes_example => 'مثال: هذه الإضافة تتطلب تسجيل الدخول';

  @override
  String get type => 'النوع';

  @override
  String get target => 'الهدف';

  @override
  String get source_type_single => 'فردي';

  @override
  String get source_type_multi => 'متعدد';

  @override
  String get source_type_torrent => 'تورنت';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS مجمع لـ LNReader';

  @override
  String get source_created_successfully => 'تم إنشاء المصدر بنجاح';

  @override
  String get source_already_exists => 'المصدر موجود بالفعل';

  @override
  String get error_when_creating_source => 'خطأ أثناء إنشاء المصدر';

  @override
  String get cookies_deleted => 'تم حذف ملفات تعريف الارتباط!';

  @override
  String get delete_all_cookies => 'حذف جميع ملفات تعريف الارتباط';

  @override
  String get chapter_number => 'رقم الفصل';

  @override
  String get episode_number => 'رقم الحلقة';

  @override
  String get share => 'مشاركة';

  @override
  String n_chapters(Object n) {
    return '$n فصول';
  }

  @override
  String missing_chapters(Object count) {
    return 'فصول مفقودة: $count';
  }

  @override
  String get no_description => 'لا يوجد وصف';

  @override
  String get resume => 'استئناف';

  @override
  String get read => 'قراءة';

  @override
  String get watch => 'مشاهدة';

  @override
  String get popular => 'شائع';

  @override
  String get open_in_browser => 'فتح في المتصفح';

  @override
  String get clear_cookie => 'مسح الكوكي';

  @override
  String get show_page_number => 'عرض رقم الصفحة';

  @override
  String get from_library => 'من المكتبة';

  @override
  String get downloaded_chapter => 'الفصل المحمل';

  @override
  String page(Object page) {
    return 'الصفحة $page';
  }

  @override
  String get global_search => 'البحث العام';

  @override
  String get color_blend_level => 'مستوى خلط الألوان';

  @override
  String current(Object char) {
    return 'الحالي $char';
  }

  @override
  String finished(Object char) {
    return 'منتهي $char';
  }

  @override
  String next(Object char) {
    return 'التالي $char';
  }

  @override
  String previous(Object char) {
    return 'السابق $char';
  }

  @override
  String get no_more_chapter => 'لا يوجد المزيد من الفصول';

  @override
  String get no_result => 'لا نتائج';

  @override
  String get send => 'إرسال';

  @override
  String get delete => 'حذف';

  @override
  String get start_downloading => 'ابدأ التحميل الآن';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get add_chapters => 'إضافة فصول';

  @override
  String get delete_chapters => 'حذف الفصل؟';

  @override
  String get default0 => 'الافتراضي';

  @override
  String get total_chapters => 'مجموع الفصول';

  @override
  String get total_episodes => 'إجمالي الحلقات';

  @override
  String get import_local_file => 'استيراد ملف محلي';

  @override
  String get import_files => 'ملفات';

  @override
  String get split_epub_chapters => 'تقسيم إلى فصول';

  @override
  String get split_epub_chapters_description =>
      'استيراد كل فصل EPUB كإدخال منفصل';

  @override
  String get nothing_read_recently => 'لم يتم قراءة شيء مؤخراً';

  @override
  String get status => 'الحالة';

  @override
  String get not_started => 'لم يبدأ';

  @override
  String get score => 'التقييم';

  @override
  String get start_date => 'تاريخ البدء';

  @override
  String get finish_date => 'تاريخ الانتهاء';

  @override
  String get reading => 'قراءة';

  @override
  String get on_hold => 'معلق';

  @override
  String get dropped => 'متوقف';

  @override
  String get plan_to_read => 'خطط للقراءة';

  @override
  String get re_reading => 'إعادة القراءة';

  @override
  String get chapters => 'الفصول';

  @override
  String get add_tracker => 'إضافة تتبع';

  @override
  String get one_tracker => '1 تتبع';

  @override
  String n_tracker(Object n) {
    return '$n تتبعات';
  }

  @override
  String get tracking => 'تتبع';

  @override
  String get syncing => 'مزامنة';

  @override
  String get sync_logged => 'تم تسجيل الدخول بنجاح';

  @override
  String get syncing_subtitle =>
      'أدخل عنوان خادم المزامنة وسجّل الدخول عبر المتصفح لمزامنة تقدّم القراءة بين أجهزتك.';

  @override
  String get sync_service => 'المزامنة على خادم ذاتي الاستضافة';

  @override
  String get last_sync => 'آخر مزامنة في: ';

  @override
  String get sync_login_browser => 'تسجيل الدخول باستخدام المتصفح';

  @override
  String get sync_server => 'عنوان خادم المزامنة';

  @override
  String get sync_starting => 'بدء المزامنة...';

  @override
  String get sync_finished => 'تم الانتهاء من المزامنة';

  @override
  String get sync_failed => 'فشل المزامنة';

  @override
  String get sync_restore_in_progress =>
      'تم تخطي المزامنة — الاستعادة قيد التقدم';

  @override
  String sync_progress_percent(Object percent) {
    return 'جارٍ المزامنة… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'جارٍ المزامنة…';

  @override
  String get sync_button_sync => 'مزامنة التقدم';

  @override
  String get sync_button_upload => 'رفع فقط';

  @override
  String get sync_button_upload_info =>
      'ستستبدل هذه العملية البيانات البعيدة بالكامل بالبيانات المحلية!';

  @override
  String get sync_button_download => 'تنزيل فقط';

  @override
  String get sync_button_download_info =>
      'ستستبدل هذه العملية البيانات المحلية بالكامل بالبيانات البعيدة!';

  @override
  String get sync_status_not_configured => 'غير متصل';

  @override
  String get sync_status_checking => 'جارٍ التحقق من الاتصال...';

  @override
  String get sync_status_connected => 'متصل';

  @override
  String get sync_status_unauthorized =>
      'انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى';

  @override
  String get sync_status_unreachable => 'تعذر الوصول إلى الخادم';

  @override
  String get sync_section_general => 'عام';

  @override
  String get sync_on => 'تمكين المزامنة';

  @override
  String get sync_auto => 'المزامنة التلقائية';

  @override
  String get sync_auto_warning => 'المزامنة التلقائية هي ميزة تجريبية حاليًا!';

  @override
  String get sync_auto_off => 'إيقاف';

  @override
  String get sync_auto_5_minutes => 'كل 5 دقائق';

  @override
  String get sync_auto_10_minutes => 'كل 10 دقائق';

  @override
  String get sync_auto_30_minutes => 'كل 30 دقيقة';

  @override
  String get sync_auto_1_hour => 'كل ساعة';

  @override
  String get sync_auto_3_hours => 'كل 3 ساعات';

  @override
  String get sync_auto_6_hours => 'كل 6 ساعات';

  @override
  String get sync_auto_12_hours => 'كل 12 ساعة';

  @override
  String get server_error => 'خطأ في الخادم!';

  @override
  String get dialog_confirm => 'تأكيد';

  @override
  String get description => 'الوصف';

  @override
  String get reorder_navigation => 'تخصيص التنقل';

  @override
  String get reorder_navigation_description =>
      'أعد ترتيب وتبديل كل تنقل حسب احتياجاتك.';

  @override
  String get floating_navigation_bar => 'شريط التنقل العائم';

  @override
  String get floating_navigation_bar_description =>
      'استخدم كبسولة عائمة بدلاً من شريط التنقل القياسي المرفق.';

  @override
  String get full_screen_player => 'استخدام الشاشة الكاملة';

  @override
  String get full_screen_player_info =>
      'استخدام الشاشة الكاملة تلقائيًا عند تشغيل الفيديو.';

  @override
  String episode_progress(Object n) {
    return 'التقدم: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n حلقات';
  }

  @override
  String missing_episodes(Object count) {
    return 'حلقات مفقودة: $count';
  }

  @override
  String get manga_sources => 'مصادر المانغا';

  @override
  String get anime_sources => 'مصادر الأنمي';

  @override
  String get novel_sources => 'مصادر الروايات';

  @override
  String get anime_extensions => 'إضافات الأنمي';

  @override
  String get manga_extensions => 'إضافات المانغا';

  @override
  String get novel_extensions => 'إضافات الروايات';

  @override
  String get extension_settings => 'إعدادات الإضافة';

  @override
  String get anime => 'أنمي';

  @override
  String get manga => 'مانغا';

  @override
  String get novel => 'رواية';

  @override
  String get library_no_category_exist => 'ليس لديك أي فئات بعد';

  @override
  String get watching => 'مشاهدة';

  @override
  String get plan_to_watch => 'خطة للمشاهدة';

  @override
  String get re_watching => 'إعادة المشاهدة';

  @override
  String get episodes => 'الحلقات';

  @override
  String get download => 'تحميل';

  @override
  String get new_update_available => 'تحديث جديد متاح';

  @override
  String app_version(Object v) {
    return 'إصدار التطبيق : v$v';
  }

  @override
  String get searching_for_updates => 'جارٍ البحث عن التحديثات...';

  @override
  String get no_new_updates_available => 'لا يوجد تحديثات جديدة متاحة';

  @override
  String get uninstall => 'إلغاء التثبيت';

  @override
  String uninstall_extension(Object ext) {
    return 'هل ترغب في إلغاء تثبيت امتداد $ext؟';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'انقر مرتين للبحث في كل $type';
  }

  @override
  String get show_nav_double_tap_tooltip => 'إظهار تلميح البحث بالنقر المزدوج';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'إظهار تلميح على وجهات مانغا/أنمي/روايات يوضح أن النقر المزدوج يفتح البحث الشامل.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" موجود بالفعل في مكتبتك عبر $source.';
  }

  @override
  String get add_anyway => 'إضافة على أي حال';

  @override
  String get langauage => 'اللغة';

  @override
  String get extension_detail => 'تفاصيل الامتداد';

  @override
  String get scale_type => 'نوع التحجيم';

  @override
  String get scale_type_fit_screen => 'ملاءمة الشاشة';

  @override
  String get scale_type_stretch => 'تمديد';

  @override
  String get scale_type_fit_width => 'ملاءمة العرض';

  @override
  String get scale_type_fit_height => 'ملاءمة الارتفاع';

  @override
  String get scale_type_original_size => 'الحجم الأصلي';

  @override
  String get scale_type_smart_fit => 'ملاءمة ذكية';

  @override
  String get page_preload_amount => 'كمية تحميل الصفحات مسبقاً';

  @override
  String get page_preload_amount_subtitle =>
      'عدد الصفحات التي يتم تحميلها مسبقاً أثناء القراءة. القيم الأعلى توفر تجربة قراءة أكثر سلاسة، ولكنها تتطلب استخدام أكبر للذاكرة المؤقتة والشبكة.';

  @override
  String get image_loading_error => 'تعذر تحميل هذه الصورة';

  @override
  String get add_episodes => 'إضافة حلقات';

  @override
  String get video_quality => 'الجودة';

  @override
  String get video_subtitle => 'الترجمة';

  @override
  String get check_for_extension_updates => 'البحث عن تحديثات الامتداد';

  @override
  String get auto_extensions_updates => 'تحديثات الامتداد التلقائية';

  @override
  String get auto_extensions_updates_subtitle =>
      'سيتم تحديث الامتداد تلقائياً عند توفر إصدار جديد.';

  @override
  String get check_for_app_updates => 'تحقق من تحديثات التطبيق عند بدء التشغيل';

  @override
  String get reading_mode => 'وضع القراءة';

  @override
  String get custom_filter => 'فلتر مخصص';

  @override
  String get background_color => 'لون الخلفية';

  @override
  String get white => 'أبيض';

  @override
  String get black => 'أسود';

  @override
  String get grey => 'رمادي';

  @override
  String get automaic => 'تلقائي';

  @override
  String get preferred_domain => 'النطاق المفضل';

  @override
  String get load_more => 'تحميل المزيد';

  @override
  String get cancel_all_for_this_series => 'إلغاء الكل لهذه السلسلة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String login_into(Object tracker) {
    return 'تسجيل الدخول إلى $tracker';
  }

  @override
  String get email_adress => 'عنوان البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String log_out_from(Object tracker) {
    return 'هل تريد تسجيل الخروج من $tracker؟';
  }

  @override
  String get log_out => 'تسجيل الخروج';

  @override
  String get update_pending => 'تحديث معلق';

  @override
  String get update_all => 'تحديث الكل';

  @override
  String get backup_and_restore => 'النسخ الاحتياطي والاستعادة';

  @override
  String get create_backup => 'إنشاء نسخة احتياطية';

  @override
  String get create_backup_dialog_title =>
      'ما الذي ترغب في أخذ نسخة احتياطية منه؟';

  @override
  String get create_backup_subtitle =>
      'يمكن استخدامها لاستعادة المكتبة الحالية';

  @override
  String get restore_backup => 'استعادة النسخة الاحتياطية';

  @override
  String get encrypt_backups => 'تشفير النسخ الاحتياطية';

  @override
  String get encrypt_backups_info =>
      'حماية النسخ بكلمة مرور باستخدام تشفير AES';

  @override
  String get no_secure_storage => 'لم يتم العثور على تخزين آمن';

  @override
  String get no_keyring_warning =>
      'لا يتوفر في النظام خدمة إدارة المفاتيح، لذا لا يمكن حفظ كلمة المرور بأمان.\n\nهل تريد حفظها غير مشفرة في قاعدة البيانات المحلية؟';

  @override
  String get enter_backup_password => 'أدخل كلمة مرور النسخة الاحتياطية';

  @override
  String get incorrect_password_try_again =>
      'كلمة المرور غير صحيحة، حاول مجدداً.';

  @override
  String get set_backup_password => 'تعيين كلمة مرور النسخة الاحتياطية';

  @override
  String get confirm_password => 'تأكيد كلمة المرور';

  @override
  String get passwords_do_not_match => 'كلمتا المرور غير متطابقتين';

  @override
  String get password_required_to_restore =>
      'يلزم إدخال كلمة المرور لاستعادة هذه النسخة.';

  @override
  String get restore_backup_subtitle =>
      'استعادة المكتبة من ملف النسخة الاحتياطية';

  @override
  String get automatic_backups => 'النسخ الاحتياطي التلقائي';

  @override
  String get backup_frequency => 'تكرار النسخ الاحتياطي';

  @override
  String get backup_location => 'موقع النسخ الاحتياطي';

  @override
  String get backup_options => 'خيارات النسخ الاحتياطي';

  @override
  String get backup_options_dialog_title =>
      'ما الذي ترغب في أخذ نسخة احتياطية منه؟';

  @override
  String get backup_options_subtitle =>
      'المعلومات التي يجب تضمينها في ملف النسخة الاحتياطية';

  @override
  String get backup_and_restore_warning_info =>
      'يجب الاحتفاظ بنسخ من النسخ الاحتياطية في أماكن أخرى كذلك';

  @override
  String get library_entries => 'مدخلات المكتبة';

  @override
  String get chapters_and_episode => 'الفصول والحلقات';

  @override
  String get every_6_hours => 'كل 6 ساعات';

  @override
  String get every_12_hours => 'كل 12 ساعة';

  @override
  String get daily => 'يومياً';

  @override
  String get every_2_days => 'كل يومين';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get restore_backup_warning_title =>
      'استعادة النسخة الاحتياطية ستؤدي إلى الكتابة فوق جميع البيانات الحالية.\n\nهل تريد الاستمرار في الاستعادة؟';

  @override
  String get restore_sync_question_title => 'مزامنة هذه الاستعادة؟';

  @override
  String get restore_sync_question_message =>
      'هذا الجهاز متصل بخادم مزامنة. هل تريد رفع البيانات المستعادة الآن؟';

  @override
  String get restore_sync_question_confirm => 'نعم، مزامنة';

  @override
  String get restore_sync_question_deny => 'لا، تعطيل المزامنة';

  @override
  String get sync_disabled_after_restore =>
      'تم تعطيل المزامنة. يمكنك تفعيلها من الإعدادات.';

  @override
  String get restore_sync_disabled_question_title => 'المزامنة معطلة حالياً';

  @override
  String get restore_sync_disabled_question_message =>
      'المزامنة متوقفة. هل تريد إعادة تفعيلها ورفع البيانات المستعادة إلى الخادم؟';

  @override
  String get restore_sync_question_reenable => 'نعم، إعادة تفعيل ومزامنة';

  @override
  String get restore_sync_question_keep_disabled => 'الإبقاء معطلة';

  @override
  String get restore_sync_uploading =>
      'جارٍ مزامنة البيانات المستعادة مع الخادم…';

  @override
  String get restore_sync_upload_success =>
      'تمت مزامنة البيانات المستعادة مع الخادم';

  @override
  String get services => 'الخدمات';

  @override
  String get tracking_warning_info =>
      'مزامنة في اتجاه واحد لتحديث تقدم الفصول في خدمات التتبع. قم بإعداد التتبع لكل مدخل على حدة من خلال زر التتبع الخاص به.';

  @override
  String get use_page_tap_zones => 'استخدام مناطق النقر في الصفحة';

  @override
  String get manage_trackers => 'إدارة أدوات التتبع';

  @override
  String get restore => 'استعادة';

  @override
  String get backups => 'النسخ الاحتياطية';

  @override
  String get by_scanlator => 'حسب المترجم';

  @override
  String get by_name => 'حسب الاسم';

  @override
  String get installed => 'مثبت';

  @override
  String get auto_scroll => 'التمرير التلقائي';

  @override
  String get video_audio => 'الصوت';

  @override
  String get video_audio_info =>
      'اللغات المفضلة، تصحيح طبقة الصوت، قنوات الصوت';

  @override
  String get player => 'لاعب';

  @override
  String get markEpisodeAsSeenSetting =>
      'في أي نقطة لوضع علامة على الحلقة كمشاهدة';

  @override
  String get mark_duplicate_chapters_read =>
      'ضع علامة على أرقام الفصول المكررة كمقروءة';

  @override
  String get default_skip_intro_length => 'طول تخطي المقدمة الافتراضي';

  @override
  String get default_playback_speed_length => 'طول سرعة التشغيل الافتراضية';

  @override
  String get updateProgressAfterReading => 'تحديث التقدم بعد القراءة';

  @override
  String get no_sources_installed => 'لم يتم تثبيت مصادر!';

  @override
  String get show_extensions => 'عرض الإضافات';

  @override
  String get default_skip_forward_skip_length => 'طول التخطي الافتراضي للأمام';

  @override
  String get aniskip_requires_info =>
      'AniSkip يتطلب تتبع الأنمي باستخدام MAL أو Anilist للعمل.';

  @override
  String get enable_aniskip => 'تمكين AniSkip';

  @override
  String get enable_auto_skip => 'تمكين التخطي التلقائي';

  @override
  String get aniskip_button_timeout => 'مهلة زر';

  @override
  String get skip_opening => 'تخطي البداية';

  @override
  String get skip_ending => 'تخطي النهاية';

  @override
  String get fullscreen => 'شاشة كاملة';

  @override
  String get update_library => 'تحديث المكتبة';

  @override
  String get next_chapter => 'الفصل التالي';

  @override
  String get next_5_chapters => 'الفصول الخمسة التالية';

  @override
  String get next_10_chapters => 'الفصول العشرة التالية';

  @override
  String get next_25_chapters => 'الفصول الخمسة والعشرون التالية';

  @override
  String get all_chapters => 'كل الفصول';

  @override
  String get next_episode => 'الحلقة التالية';

  @override
  String get next_5_episodes => 'الحلقات الخمس التالية';

  @override
  String get next_10_episodes => 'العشر حلقات التالية';

  @override
  String get next_25_episodes => 'الخمسة وعشرون حلقة التالية';

  @override
  String get all_episodes => 'كل الحلقات';

  @override
  String get cover_saved => 'الغلاف المحفوظ';

  @override
  String get set_as_cover => 'تعيين كغطاء';

  @override
  String get use_this_as_cover_art => 'هل تريد استخدام هذا كفن الغلاف؟';

  @override
  String get save => 'حفظ';

  @override
  String get picture_saved => 'الصورة المحفوظة';

  @override
  String get cover_updated => 'تم تحديث الغلاف';

  @override
  String get include_subtitles => 'تضمين الترجمة';

  @override
  String get blend_mode_default => 'الافتراضي';

  @override
  String get blend_mode_multiply => 'ضرب';

  @override
  String get blend_mode_screen => 'الشاشة';

  @override
  String get blend_mode_overlay => 'تراكيب';

  @override
  String get blend_mode_colorDodge => 'تفادي اللون';

  @override
  String get blend_mode_lighten => 'تفتيح';

  @override
  String get blend_mode_colorBurn => 'حرق اللون';

  @override
  String get blend_mode_darken => 'تظليل';

  @override
  String get blend_mode_difference => 'الفرق';

  @override
  String get blend_mode_saturation => 'التشبع';

  @override
  String get blend_mode_softLight => 'ضوء ناعم';

  @override
  String get blend_mode_plus => 'زائد';

  @override
  String get blend_mode_exclusion => 'استثناء';

  @override
  String get custom_color_filter => 'مرشح اللون المخصص';

  @override
  String get color_filter_blend_mode => 'وضع امتزاج مرشح اللون';

  @override
  String get enable_all => 'تمكين الكل';

  @override
  String get disable_all => 'تعطيل الكل';

  @override
  String get font => 'الخط';

  @override
  String get color => 'اللون';

  @override
  String get font_size => 'حجم الخط';

  @override
  String get text => 'النص';

  @override
  String get border => 'الحدود';

  @override
  String get background => 'الخلفية';

  @override
  String get no_subtite_warning_message =>
      'لا تؤثر لأنه لا توجد مسارات ترجمة في هذا الفيديو';

  @override
  String get grid_size => 'حجم الشبكة';

  @override
  String n_per_row(Object n) {
    return '$n في الصف الواحد';
  }

  @override
  String get horizontal_continious => 'مستمر أفقياً';

  @override
  String get edit_code => 'تحرير الكود';

  @override
  String get use_libass => 'تفعيل libass';

  @override
  String get use_libass_info =>
      'استخدام عرض الترجمة المستندة إلى libass للواجهة الخلفية الأصلية.';

  @override
  String get libass_not_disable_message =>
      'عطل `استخدام libass` في إعدادات المشغل لتتمكن من تخصيص الترجمة.';

  @override
  String get override_ass_subtitles => 'تجاوز ترجمات ASS';

  @override
  String get override_ass_subtitles_info => 'تطبيق نمط مخصص على ترجمات ASS/SSA';

  @override
  String get torrent_stream => 'بث التورنت';

  @override
  String get add_torrent => 'إضافة تورنت';

  @override
  String get enter_torrent_hint_text => 'أدخل رابط ملف التورنت أو المغناطيس';

  @override
  String get torrent_url => 'رابط التورنت';

  @override
  String get or => 'أو';

  @override
  String get advanced => 'متقدم';

  @override
  String get advanced_info => 'تكوين mpv';

  @override
  String get use_native_http_client => 'استخدام عميل HTTP الأصلي';

  @override
  String get use_native_http_client_info =>
      'يدعم تلقائيًا ميزات المنصة مثل الشبكات الافتراضية الخاصة (VPNs)، ويدعم ميزات HTTP أكثر مثل HTTP/3 ومعالجة إعادة التوجيه المخصصة';

  @override
  String n_hour_ago(Object hour) {
    return 'قبل $hour ساعة';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'قبل $hours ساعات';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'قبل $minute دقيقة';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'قبل $minutes دقائق';
  }

  @override
  String n_day_ago(Object day) {
    return 'قبل $day يوم';
  }

  @override
  String get now => 'الآن';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'آخر تحديث للمكتبة: $lastUpdated';
  }

  @override
  String get data_and_storage => 'البيانات والتخزين';

  @override
  String get download_location_info => 'تُستخدم لتنزيل الفصول';

  @override
  String get storage => 'التخزين';

  @override
  String get clear_chapter_and_episode_cache =>
      'مسح ذاكرة التخزين المؤقت للفصول والحلقات';

  @override
  String get cache_cleared => 'تم مسح ذاكرة التخزين المؤقت';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'مسح ذاكرة التخزين المؤقت للفصول/الحلقات عند فتح التطبيق';

  @override
  String get app_settings => 'إعدادات التطبيق';

  @override
  String get sources_settings => 'إعدادات المصادر';

  @override
  String get include_sensitive_settings =>
      'تضمين الإعدادات الحساسة (مثل رموز تسجيل الدخول للمتعقب)';

  @override
  String get create => 'إنشاء';

  @override
  String get downloads_are_limited_to_wifi => 'التنزيلات مقتصرة على Wi-Fi فقط';

  @override
  String get recommendations => 'التوصيات';

  @override
  String get recommendations_similar => 'مشابه';

  @override
  String get recommendations_weights => 'أوزان التوصية';

  @override
  String get recommendations_weights_genre => 'تشابه النوع';

  @override
  String get recommendations_weights_setting => 'تشابه الإعداد';

  @override
  String get recommendations_weights_synopsis => 'تشابه القصة';

  @override
  String get recommendations_weights_theme => 'تشابه الموضوع';

  @override
  String get manga_extensions_repo => 'مستودع إضافات المانجا';

  @override
  String get anime_extensions_repo => 'مستودع إضافات الأنمي';

  @override
  String get novel_extensions_repo => 'مستودع إضافات الروايات';

  @override
  String get custom_dns => 'DNS مخصص (اتركه فارغًا لاستخدام DNS النظام)';

  @override
  String get android_proxy_server => 'خادم بروكسي Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'احصل على M-Extension-Server';

  @override
  String get undefined => 'غير محدد';

  @override
  String get empty_extensions_repo =>
      'ليس لديك أي عناوين URL للمستودع هنا. انقر على زر الإضافة لإضافة واحد!';

  @override
  String get add_extensions_repo => 'إضافة عنوان URL للمستودع';

  @override
  String get remove_extensions_repo => 'إزالة عنوان URL للمستودع';

  @override
  String get manage_manga_repo_urls => 'إدارة عناوين URL لمستودع المانجا';

  @override
  String get manage_anime_repo_urls => 'إدارة عناوين URL لمستودع الأنمي';

  @override
  String get manage_novel_repo_urls => 'إدارة عناوين URL لمستودع الروايات';

  @override
  String get url_cannot_be_empty => 'لا يمكن أن يكون عنوان URL فارغًا';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'يجب أن ينتهي عنوان URL بـ .json / .pb';

  @override
  String get repo_url => 'عنوان URL للمستودع';

  @override
  String get invalid_url_format => 'تنسيق عنوان URL غير صالح';

  @override
  String get clear_all_sources => 'مسح جميع المصادر';

  @override
  String get clear_all_sources_msg =>
      'سيؤدي هذا إلى مسح جميع مصادر التطبيق تمامًا. هل أنت متأكد أنك تريد المتابعة؟';

  @override
  String get sources_cleared => 'تم مسح المصادر!!!';

  @override
  String get repo_added => 'تمت إضافة مستودع المصدر!';

  @override
  String get repo_already_exists => 'المستودع موجود بالفعل!';

  @override
  String get add_repo => 'إضافة مستودع؟';

  @override
  String get add_repo_sources_to_add => 'قوائم الامتدادات التي سيتم إضافتها:';

  @override
  String get add_repo_warning =>
      'يتم تشغيل الملحقات من هذه المستودعات داخل التطبيق. قم بإضافة المستودعات التي تثق بها فقط.';

  @override
  String get genre_search_library => 'بحث النوع في المكتبة';

  @override
  String get genre_search_source => 'تصفح في المصدر';

  @override
  String get source_not_added => 'المصدر غير مثبت!';

  @override
  String get load_own_subtitles => 'تحميل الترجمة الخاصة بك...';

  @override
  String get search_subtitles => 'البحث عن ترجمات عبر الإنترنت...';

  @override
  String extension_notes(Object notes) {
    return 'ملاحظات: $notes';
  }

  @override
  String get unsupported_repo =>
      'تعذّرت إضافة مستودع المصادر هذا. تحقّق من عنوان المستودع أو تواصل مع القائم على صيانته.';

  @override
  String get you_have_finished_reading => 'لقد انتهيت من القراءة';

  @override
  String get hwdec => 'فك تشفير الأجهزة';

  @override
  String get enable_hardware_accel => 'تسريع الأجهزة';

  @override
  String get enable_hardware_accel_info =>
      'قم بتشغيله/إيقافه إذا كنت تواجه أخطاء أو أعطال';

  @override
  String get track_library_navigate => 'انتقل إلى الإدخال المحلي الموجود';

  @override
  String get track_library_add => 'أضف إلى المكتبة المحلية';

  @override
  String get track_library_add_confirm =>
      'إضافة العنصر المتتبع إلى المكتبة المحلية';

  @override
  String get track_library_not_logged =>
      'قم بتسجيل الدخول إلى المتتبع المقابل لاستخدام هذه الميزة!';

  @override
  String get track_library_switch => 'التبديل إلى متتبع آخر';

  @override
  String get go_back => 'العودة';

  @override
  String get merge_library_nav_mobile =>
      'دمج التنقل في المكتبة على الهاتف المحمول';

  @override
  String get enable_discord_rpc => 'تمكين Discord RPC';

  @override
  String get hide_discord_rpc_incognito => 'إخفاء Discord RPC في وضع التخفي';

  @override
  String get rpc_show_reading_watching_progress =>
      'إظهار الفصل الحالي في Discord (يتطلب إعادة التشغيل)';

  @override
  String get rpc_show_title => 'إظهار العنوان الحالي في Discord';

  @override
  String get rpc_show_cover_image => 'إظهار صورة الغلاف الحالية في Discord';

  @override
  String get enable_mpv => 'تمكين تظليل / سكريبتات mpv';

  @override
  String get mpv_info => 'يدعم سكريبتات .js تحت mpv/scripts/';

  @override
  String get mpv_redownload => 'إعادة تنزيل ملفات تكوين mpv';

  @override
  String get mpv_redownload_info => 'يستبدل ملفات التكوين القديمة بأخرى جديدة!';

  @override
  String get mpv_download => 'ملفات تكوين MPV مطلوبة!\nتنزيل الآن؟';

  @override
  String get custom_buttons => 'أزرار مخصصة';

  @override
  String get custom_buttons_info => 'تنفيذ كود lua بأزرار مخصصة';

  @override
  String get custom_buttons_edit => 'تحرير الأزرار المخصصة';

  @override
  String get custom_buttons_add => 'إضافة زر مخصص';

  @override
  String get custom_buttons_added => 'تمت إضافة الزر المخصص!';

  @override
  String get custom_buttons_delete => 'حذف الزر المخصص';

  @override
  String get custom_buttons_text => 'نص الزر';

  @override
  String get custom_buttons_text_req => 'نص الزر مطلوب';

  @override
  String get custom_buttons_js_code => 'كود lua';

  @override
  String get custom_buttons_js_code_req => 'كود lua مطلوب';

  @override
  String get custom_buttons_js_code_long => 'كود lua (عند الضغط لفترة طويلة)';

  @override
  String get custom_buttons_startup => 'كود lua (عند بدء التشغيل)';

  @override
  String get custom_buttons_add_warning =>
      'يقوم هذا الزر بتشغيل الكود Lua الموجود أدناه في مشغل الفيديو، والذي يمكنه الوصول إلى ملفاتك وتشغيل البرامج. قم بإضافته فقط إذا كنت تثق في مصدر هذا الرابط.';

  @override
  String n_days(Object n) {
    return '$n أيام';
  }

  @override
  String get decoder => 'فك التشفير';

  @override
  String get decoder_info => 'فك تشفير الأجهزة، تنسيق البكسل، إزالة التدرج';

  @override
  String get enable_gpu_next => 'تمكين gpu-next (Android فقط)';

  @override
  String get enable_gpu_next_info => 'محرك عرض فيديو جديد';

  @override
  String get debanding => 'إزالة التدرج';

  @override
  String get use_yuv420p => 'استخدام تنسيق بكسل YUV420P';

  @override
  String get use_yuv420p_info =>
      'قد يصلح الشاشات السوداء على بعض برامج ترميز الفيديو، ويمكن أيضًا تحسين الأداء على حساب الجودة';

  @override
  String get audio_preferred_languages => 'اللغات المفضلة';

  @override
  String get audio_preferred_languages_info =>
      'لغة (لغات) الصوت المراد تحديدها افتراضيًا على فيديو يحتوي على تدفقات صوت متعددة، رموز لغة من 2/3 أحرف (مثل: ar، en، ja). يمكن فصل القيم المتعددة بفاصلة.';

  @override
  String get enable_audio_pitch_correction => 'تمكين تصحيح طبقة الصوت';

  @override
  String get enable_audio_pitch_correction_info =>
      'يمنع الصوت من أن يصبح حادًا بسرعات أسرع وعميقًا بسرعات أبطأ';

  @override
  String get audio_channels => 'قنوات الصوت';

  @override
  String get volume_boost_cap => 'حد تعزيز الصوت';

  @override
  String get internal_player => 'المشغل الداخلي';

  @override
  String get internal_player_info => 'التقدم، عناصر التحكم، الاتجاه';

  @override
  String get subtitle_delay_text => 'تأخير الترجمة';

  @override
  String get subtitle_delay => 'التأخير (ms)';

  @override
  String get subtitle_speed => 'السرعة';

  @override
  String get tracks => 'المسارات';

  @override
  String get playback_speed => 'سرعة التشغيل';

  @override
  String get shaders => 'المظللات (Shaders)';

  @override
  String get video_fit => 'ملاءمة';

  @override
  String get calendar => 'التقويم';

  @override
  String get calendar_no_data => 'لا توجد بيانات حتى الآن.';

  @override
  String get calendar_info =>
      'لا يمكن للتقويم التنبؤ بتحميل الفصل التالي إلا بناءً على التحميلات القديمة. قد لا تكون بعض البيانات دقيقة بنسبة 100٪!';

  @override
  String in_n_day(Object days) {
    return 'في $days يوم';
  }

  @override
  String in_n_days(Object days) {
    return 'في $days أيام';
  }

  @override
  String get clear_library => 'مسح المكتبة';

  @override
  String get clear_library_desc =>
      'اختر مسح جميع إدخالات المانجا والأنمي و/أو الرواية';

  @override
  String get clear_library_input =>
      'اكتب \'manga\' و \'anime\' و/أو \'novel\' (مفصولة بفاصلة) لإزالة جميع الإدخالات ذات الصلة';

  @override
  String get watch_order => 'ترتيب المشاهدة';

  @override
  String get watch_order_role_current => 'الحالي';

  @override
  String get watch_order_role_previous => 'السابق';

  @override
  String get watch_order_role_next => 'التالي';

  @override
  String get watch_order_source_release_order => 'أمر الإصدار';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name بواسطة $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'الرسمية Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'مواسم $title';
  }

  @override
  String get watch_order_select_source => 'مصدر الأمر';

  @override
  String watch_order_season(int number) {
    return 'الموسم $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'الحلقة $number';
  }

  @override
  String get sequels => 'الأجزاء التالية';

  @override
  String get recommendations_similarity => 'التشابه:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'التقييم $rating';
  }

  @override
  String get local_folder_structure => 'هيكل المجلد المحلي';

  @override
  String get local_folder => 'المجلدات المحلية';

  @override
  String get add_local_folder => 'إضافة مجلد محلي';

  @override
  String get rescan_local_folder => 'إعادة فحص جميع المجلدات المحلية الآن';

  @override
  String get default_download_destination => 'مجلد التنزيل الافتراضي';

  @override
  String get ask_download_destination => 'السؤال عن وجهة التنزيل';

  @override
  String get ask_download_destination_desc => 'اختيار مجلد محلي عند كل تنزيل.';

  @override
  String get select_download_destination => 'تحديد وجهة التنزيل';

  @override
  String get clear_local_library => 'مسح المكتبة المحلية';

  @override
  String get clear_local_library_desc =>
      'إزالة المجلدات والأرشيفات المحلية من المكتبة.';

  @override
  String get clear_local_library_msg =>
      'سيؤدي هذا إلى إزالة المجلدات المحلية من المكتبة دون حذف الملفات من القرص.';

  @override
  String get custom => 'مخصص';

  @override
  String get no_local_folder_available_for_downloads =>
      'لا يوجد مجلد محلي متاح للتنزيلات';

  @override
  String failed_to_create_cbz(Object error) {
    return 'فشل إنشاء CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'خطأ في قراءة صورة الغلاف: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'خطأ في قراءة البيانات الوصفية: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'خطأ في الحفظ بالمكتبة: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'خطأ في قراءة غلاف الفصل: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'خطأ في قراءة غلاف الأرشيف: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'خطأ في جلب المكتبة المحلية: $error';
  }

  @override
  String get export_metadata => 'تصدير البيانات الوصفية';

  @override
  String get exported => 'تم التصدير';

  @override
  String failed_to_export_metadata(Object error) {
    return 'فشل تصدير البيانات الوصفية: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return 'تعذر ترقيم $count فصول تلقائياً.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'تعذر بدء خادم حل Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'انتهت صلاحية رمز $tracker';
  }

  @override
  String get video_list_empty => 'قائمة الفيديو فارغة';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'تعذر فتح $url';
  }

  @override
  String get text_size => 'حجم النص:';

  @override
  String get text_align => 'محاذاة النص';

  @override
  String get line_height => 'ارتفاع السطر';

  @override
  String get show_scroll_percentage => 'إظهار نسبة التمرير';

  @override
  String get remove_extra_paragraph_spacing =>
      'إزالة المسافات الإضافية بين الفقرات';

  @override
  String select_label_color(Object label) {
    return 'تحديد لون $label';
  }

  @override
  String get default_user_agent => 'وكيل المستخدم الافتراضي';

  @override
  String get forceLandscapeMode => 'فرض وضع المناظر الطبيعية';

  @override
  String get forceLandscapeModeSubtitle =>
      'فرض المشغل لاستخدام اتجاه المناظر الطبيعية.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'مزود DNS';

  @override
  String get tracked => 'تتبع';

  @override
  String get auth_unlock_msg => 'المصادقة لفتح قفل NodeLane Comics';

  @override
  String get app_locked => 'NodeLane Comics مقفول';

  @override
  String get auth_to_continue => 'المصادقة للمتابعة';

  @override
  String get authenticating => 'جاري المصادقة...';

  @override
  String get lock => 'قفل';

  @override
  String get unlock => 'فتح القفل';

  @override
  String get security => 'الأمان';

  @override
  String get auth_to_change_security_setting =>
      'المصادقة لتغيير إعدادات الأمان';

  @override
  String get app_lock => 'قفل التطبيق';

  @override
  String get require_biometric_or_device_credential =>
      'يتطلب المصادقة البيومترية أو بيانات اعتماد الجهاز لفتح التطبيق';

  @override
  String get biometric_or_device_credential_not_available =>
      'المصادقة البيومترية غير متاحة على هذا الجهاز';

  @override
  String get app_lock_description =>
      'عند تفعيل قفل التطبيق، سيُطلب منك المصادقة\nفي كل مرة تفتح التطبيق أو تعود إليه من الخلفية.';

  @override
  String get checking_device_authentication =>
      'جارٍ التحقق من مصادقة الجهاز...';

  @override
  String get device_authentication_incomplete =>
      'لم تكتمل المصادقة. الإعداد الخاص بك لم يتغير.';

  @override
  String get keep_screen_on => 'إبقاء الشاشة مضاءة';

  @override
  String get webtoon_side_padding => 'حشو جانب الويب توون';

  @override
  String get show_page_gaps => 'إظهار فجوات الصفحات';

  @override
  String get invert_colors => 'عكس الألوان';

  @override
  String get grayscale => 'تدرج رمادي';

  @override
  String get brightness => 'السطوع';

  @override
  String get contrast => 'التباين';

  @override
  String get saturation => 'التشبع';

  @override
  String get navigation_layout => 'تخطيط الملاحة';

  @override
  String get nav_layout_default => 'افتراضي';

  @override
  String get nav_layout_l_shaped => 'على شكل L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'الحافة';

  @override
  String get nav_layout_right_and_left => 'اليمين واليسار';

  @override
  String get nav_layout_disabled => 'معطل';

  @override
  String get color_enhancements => 'تحسينات اللون';

  @override
  String get total => 'الإجمالي';

  @override
  String get mean_per_title => 'المتوسط لكل عنوان';

  @override
  String get completion_rate => 'معدل الإكمال';

  @override
  String get watching_time => 'وقت المشاهدة';

  @override
  String get reading_time => 'وقت القراءة';

  @override
  String average_chapters_per_title(Object title) {
    return 'متوسط الفصول لكل $title';
  }

  @override
  String get read_percentage => 'نسبة القراءة';

  @override
  String get entries => 'الإدخالات';

  @override
  String get android_proxy_server_mihon => 'خادم بروكسي أندرويد (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'قم بتنزيل وتكوين خادم البروكسي المطلوب لاستخدام امتدادات Mihon.';

  @override
  String get mihon_proxy_server => 'خادم بروكسي Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'قم بتحميل حزمة خادم الوكيل قبل استخدام إضافات Mihon. تتضمن الحزمة JRE ومعلف JAR الخاص بخادم الإضافات.';

  @override
  String get extension_server_intro_ios =>
      'قم بتحميل ملف JAR الخاص بخادم الوكيل قبل استخدام إضافات Mihon. يحتاج نظام iOS فقط إلى ملف JAR الخاص بخادم الإضافات.';

  @override
  String get checking_files => 'جاري فحص الملفات';

  @override
  String get files_installed => 'الملفات المثبتة';

  @override
  String get files_missing => 'الملفات المفقودة';

  @override
  String get update_files => 'تحديث الملفات';

  @override
  String get up_to_date => 'محدث';

  @override
  String get choose_location => 'اختر الموقع';

  @override
  String get import_existing_jar => 'استيراد ملف JAR موجود';

  @override
  String get detect_files_in_selected_folder => 'كشف الملفات في المجلد المختار';

  @override
  String get preparing_download => 'جاري تحضير التحميل...';

  @override
  String get app_install_location => 'موقع تثبيت التطبيق';

  @override
  String get install_location => 'موقع التثبيت';

  @override
  String get jre_executable => 'JRE قابل للتنفيذ';

  @override
  String get extension_server_jar => 'ملف JAR لخادم الإضافات';

  @override
  String get installed_version => 'الإصدار المثبت';

  @override
  String get latest_version => 'أحدث إصدار';

  @override
  String get m_extension_server_description =>
      'استخدم M-Extension-Server عندما تحتاج إلى وكيل جهاز أندرويد منفصل. اضبط عنوان الوكيل هنا وقم بتحميل APK من GitHub.';

  @override
  String get set_proxy_address => 'ضبط عنوان الوكيل';

  @override
  String get no_newer_proxy_server_release_available =>
      'لا يوجد إصدار أحدث من خادم البروكسي متاح.';

  @override
  String get could_not_check_proxy_server_updates =>
      'تعذر التحقق من تحديثات خادم البروكسي.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'لا تتوفر حزمة خادم إضافات لهذا النظام.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'فشل تحميل الحزمة ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'الحزمة المحملة لا تحتوي على الملفات المتوقعة.';

  @override
  String get extension_server_files_ready => 'ملفات خادم الإضافات جاهزة.';

  @override
  String get ios_extension_server_import_hint =>
      'في نظام iOS يتم تثبيت الخادم داخل صندوق رمال التطبيق. استخدم \"استيراد ملف JAR موجود\" لجلب ملف محمل.';

  @override
  String get select_extension_server_folder => 'اختر مجلد خادم الإضافات';

  @override
  String get selected_folder_does_not_exist => 'المجلد المختار غير موجود.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'لم يتم العثور على ملفات خادم الإضافات في المجلد المختار.';

  @override
  String get extension_server_files_linked => 'تم ربط ملفات خادم الإضافات.';

  @override
  String get select_extension_server_jar => 'اختر ملف JAR لخادم الامتداد';

  @override
  String get selected_file_could_not_be_accessed =>
      'تعذر الوصول إلى الملف المختار.';

  @override
  String get extension_server_jar_imported =>
      'تم استيراد ملف JAR لخادم الإضافات.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'تعذر تشغيل صفحة M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'عنوان IP للخادم (مثلاً 10.0.0.5 أو https://example.com)';

  @override
  String get not_configured => 'غير مهيأ';

  @override
  String get zero_interpreter => 'مترجم Zero';

  @override
  String get zero_interpreter_description =>
      'التحكم في خادم مترجم Zero تلقائياً أو يدوياً.';

  @override
  String get start_server_on_launch => 'تشغيل الخادم عند بدء التطبيق';

  @override
  String get runtime_status => 'حالة التشغيل';

  @override
  String get running => 'قيد التشغيل';

  @override
  String get stopped => 'متوقف';

  @override
  String get start => 'بدء';

  @override
  String get stop => 'إيقاف';

  @override
  String get webview => 'عرض الويب';

  @override
  String get tts => 'تحويل النص إلى كلام';

  @override
  String get tts_speed => 'السرعة';

  @override
  String get tts_pitch => 'التيمبر';

  @override
  String get tts_language => 'اللغة';

  @override
  String get tts_voice => 'الصوت';

  @override
  String get tts_stop => 'إيقاف';

  @override
  String get tts_play => 'تشغيل';

  @override
  String get tts_pause => 'إيقاف مؤقت';

  @override
  String get tts_previous => 'الفقرة السابقة';

  @override
  String get tts_next => 'الفقرة التالية';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'الفقرة $current من $total';
  }

  @override
  String get tts_settings => 'إعدادات TTS';

  @override
  String get tts_default => 'افتراضي';

  @override
  String get webtoon_disable_zoom_out => 'تعطيل التصغير في الويب تون';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'النقر المزدوج للتكبير في الويب تون';

  @override
  String get navigate_to_pan => 'التنقل للسحب';

  @override
  String get navigate_to_pan_subtitle => 'تحريك الصورة المكبرة قبل قلب الصفحة';

  @override
  String get split_wide_pages => 'تقسيم الصفحات العريضة';

  @override
  String get dual_page_invert => 'عكس نصفي الصفحات المقسمة';

  @override
  String get dual_page_rotate_to_fit => 'التدوير للملاءمة';

  @override
  String get dual_page_rotate_to_fit_invert => 'عكس اتجاه التدوير';

  @override
  String get double_page_single_first_page => 'الصفحة الأولى مفردة';

  @override
  String get double_page_single_first_page_subtitle =>
      'عرض الصفحة الأولى بمفردها في وضع الصفحتين';

  @override
  String get double_page_auto => 'صفحة مزدوجة تلقائياً';

  @override
  String get double_page_auto_subtitle =>
      'التبديل إلى وضع الصفحة المزدوجة تلقائياً في الوضع الأفقي';

  @override
  String get landscape_zoom => 'تكبير تلقائي للوضع الأفقي';

  @override
  String get zoom_start_position => 'موضع بدء التكبير';

  @override
  String get zoom_start_left => 'اليسار';

  @override
  String get zoom_start_right => 'اليمين';

  @override
  String get zoom_start_center => 'الوسط';

  @override
  String get automatic_background => 'خلفية تلقائية';

  @override
  String get tapping_inversion => 'عكس النقر';

  @override
  String get tapping_inversion_none => 'لا شيء';

  @override
  String get tapping_inversion_horizontal => 'أفقي';

  @override
  String get tapping_inversion_vertical => 'عمودي';

  @override
  String get tapping_inversion_both => 'كلاهما';

  @override
  String get flash_on_page_change => 'وميض عند تغيير الصفحة';

  @override
  String get flash_on_page_change_subtitle => 'مساعد منع احتراق شاشة AMOLED';

  @override
  String get flash_color => 'لون الوميض';

  @override
  String get flash_color_black => 'أسود';

  @override
  String get flash_color_white => 'أبيض';

  @override
  String get flash_color_white_black => 'أبيض وأسود';

  @override
  String get flash_interval_label => 'معدل الوميض';

  @override
  String flash_interval_value(String n) {
    return 'كل $n صفحات';
  }

  @override
  String flash_interval(String n) {
    return 'معدل الوميض: كل $n صفحات';
  }

  @override
  String get flash_duration_label => 'مدة الوميض';

  @override
  String flash_duration_value(String n) {
    return '$n مللي ثانية';
  }

  @override
  String flash_duration(String n) {
    return 'مدة الوميض: $n مللي ثانية';
  }

  @override
  String get show_navigation_overlay_on_start => 'إظهار واجهة التنقل عند البدء';

  @override
  String get reader_hide_threshold => 'حد إخفاء القارئ';

  @override
  String get reader_hide_threshold_highest => 'الأعلى (5 بكسل)';

  @override
  String get reader_hide_threshold_high => 'مرتفع (13 بكسل)';

  @override
  String get reader_hide_threshold_low => 'منخفض (31 بكسل)';

  @override
  String get reader_hide_threshold_lowest => 'الأدنى (47 بكسل)';

  @override
  String get error_no_pages_available => 'خطأ: لا توجد صفحات متاحة';

  @override
  String get app_ui_scale => 'حجم الواجهة';

  @override
  String get app_ui_scale_subtitle =>
      'اجعل الواجهة أكبر أو أصغر لتناسب شاشتك ومسافة المشاهدة.';

  @override
  String get allow_concurrent_downloads => 'السماح بالتنزيلات المتزامنة';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'قم بالتنزيل من مصادر مختلفة في نفس الوقت. يقوم مصدر واحد فقط بتنزيل فصل واحد في المرة حتى لا يتم الإرهاق. أطفئها للتنزيل واحدة تلو الأخرى في كل مكان.';

  @override
  String get download_delay => 'تأخير التنزيل';

  @override
  String get download_delay_subtitle =>
      'إيقاف. أضف انتظارًا مع اهتزاز عشوائي بين الفصول لتكون أكثر لطفًا على المصادر.';

  @override
  String get save_search => 'حفظ البحث';

  @override
  String get saved_searches => 'عمليات البحث المحفوظة';

  @override
  String get enter_search_to_save_first => 'أدخل بحثًا لحفظه أولاً';

  @override
  String get no_saved_searches =>
      'لا توجد عمليات بحث محفوظة لهذا المصدر حتى الآن.\nقم بإجراء بحث، ثم اختر \"حفظ البحث\".';

  @override
  String get source => 'المصدر';

  @override
  String get something_went_wrong => 'حدث خطأ ما';

  @override
  String get startup_failed => 'تعذر على NodeLane Comics إكمال بدء التشغيل';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مصدراً بلا نتائج',
      few: '$count مصادر بلا نتائج',
      one: 'مصدر واحد بلا نتائج',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'كيف تريد الاستيراد؟';

  @override
  String get import_mode_message =>
      'اختر دمج هذه النسخة مع المكتبة الحالية أو استبدال المكتبة بأكملها.';

  @override
  String get import_mode_keep_existing => 'دمج';

  @override
  String get import_mode_keep_existing_subtitle =>
      'إضافة السلاسل الجديدة وتحديث المطابقة. لن يتم حذف أي شيء.';

  @override
  String get import_mode_replace => 'استبدال';

  @override
  String get import_mode_replace_subtitle =>
      'حذف المكتبة الحالية واستبدالها بهذه النسخة.';

  @override
  String get replace_summary_title => 'جاهز لاستبدال المكتبة';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'سيؤدي هذا إلى حذف $currentCount سلسلة واستبدالها بـ $backupCount سلسلة.';
  }

  @override
  String get replace_summary_confirm => 'استبدال';

  @override
  String replace_result_message(Object count) {
    return 'تم استبدال المكتبة بـ $count سلسلة من النسخة الاحتياطية.';
  }

  @override
  String get category_conflict_title => 'تم العثور على تصنيفات موجودة';

  @override
  String get category_conflict_message =>
      'تحتوي النسخة على تصنيفات موجودة بالفعل في المكتبة.';

  @override
  String get category_conflict_keep => 'احتفاظ — دمج في التصنيف الموجود';

  @override
  String get category_conflict_delete => 'حذف — ترك السلاسل بدون تصنيف';

  @override
  String get source_conflict_title => 'المصادر غير موجودة';

  @override
  String get source_conflict_message => 'بعض المصادر لا تطابق أي إضافة مثبتة.';

  @override
  String get source_conflict_keep => 'الاحتفاظ بالاسم الأصلي';

  @override
  String get import_summary_title => 'جاهز للاستيراد';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries سلسلة جديدة، وتحديث $updatedSeries، وإضافة $newChapters فصول.';
  }

  @override
  String get import_summary_confirm => 'استيراد';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'تم استيراد $newSeries جديدة، وتحديث $updatedSeries، وإضافة $newChapters فصول.';
  }

  @override
  String get roll_back => 'تراجع';

  @override
  String get roll_back_confirm_message =>
      'استعادة المكتبة إلى اللقطة المحفوظة قبل هذا التغيير مباشرة.';

  @override
  String get roll_back_done => 'تم التراجع إلى اللقطة السابقة.';

  @override
  String get restoring_backup => 'جارٍ استعادة المكتبة…';

  @override
  String get roll_back_last_change => 'التراجع عن آخر تغيير';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'لقطة من $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count تغييرات متاحة للتراجع';
  }

  @override
  String get delete_source_title => 'حذف مصدر ومانغاته';

  @override
  String get delete_source_subtitle =>
      'حذف جميع مانغات المصدر وفصوله وتنزيلاته وسجله من المكتبة.';

  @override
  String get delete_source_pick_title => 'اختر مصدراً لحذفه';

  @override
  String get delete_source_empty => 'لم يتم العثور على مصادر في المكتبة.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'حذف $sourceName؟';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'يؤدي هذا إلى حذف $mangaCount مانغا، $chapterCount الفصول، $historyCount إدخالات التاريخ و$updateCount إدخالات التحديث بشكل دائم. يتم الاحتفاظ بروابط التتبع. ولا يمكن التراجع عن هذا إلا بالتراجع.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'إزالة الإضافة المثبتة أيضاً';

  @override
  String get delete_source_keep_history => 'الاحتفاظ بسجل القراءة';

  @override
  String get delete_source_keep_downloads => 'الاحتفاظ بسجلات التنزيل';

  @override
  String get delete_source_button => 'حذف';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'تم حذف $mangaCount مانغا من $sourceName.';
  }

  @override
  String get merge_manga_title => 'دمج المانغا المكررة';

  @override
  String get merge_manga_subtitle =>
      'البحث عن مانغا بنفس العنوان تحت نفس المصدر ودمجها معاً.';

  @override
  String get merge_manga_none_found => 'لم يتم العثور على مانغا مكررة.';

  @override
  String get merge_manga_pick_title => 'مانغا مكررة محتملة';

  @override
  String get merge_manga_choose_primary_title => 'إلى أي مانغا يجب دمج البقية؟';

  @override
  String get merge_manga_choose_primary_message =>
      'سيتم دمج الفصول والسجل والتتبع في المانغا المختارة دون حذف شيء.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصلاً',
      few: '$count فصول',
      one: 'فصل واحد',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'دمج';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'تم دمج $count مانغا مكررة في $mangaName.';
  }

  @override
  String get merge_preview_title => 'تأكيد الدمج';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters عبر الإدخالات الأخرى. $duplicateChapters هي نسخ مكررة وسيتم إسقاطها (مع الاحتفاظ بأي نسخة بها تقدم في القراءة)؛ ستتم إضافة $keptChapters. $duplicateTracks سيتم أيضًا إسقاط رابط (روابط) التتبع المكررة.';
  }

  @override
  String get memory_overlay => 'إظهار استخدام الذاكرة';

  @override
  String get memory_overlay_subtitle =>
      'قراءة مباشرة لاستهلاك الذاكرة في التطبيق. للقياس على الجهاز بدلاً من التخمين: راقبها أثناء التمرير في المكتبة أو قراءة فصل.';

  @override
  String get beta => 'تجريبي';

  @override
  String get error_reports => 'تقارير الأخطاء';

  @override
  String get error_reports_subtitle => 'الأخطاء المسجلة وطريقة الإبلاغ عنها';

  @override
  String get error_reports_empty => 'لم تحدث أي أخطاء.';

  @override
  String get error_reports_likely_cause => 'السبب المحتمل';

  @override
  String get error_reports_report => 'إبلاغ على GitHub';

  @override
  String get error_reports_banner => 'واجه NodeLane Comics خطأ';

  @override
  String get error_reports_banner_action => 'عرض';

  @override
  String get error_reports_copy => 'نسخ';

  @override
  String get error_reports_copied => 'تم النسخ إلى الحافظة';

  @override
  String get error_reports_clear => 'مسح';

  @override
  String get error_reports_extension_failure =>
      'هذا الخطأ ناتج عن إضافة وليس من تطبيق NodeLane Comics. تتم كتابة الإضافات وصيانتها بواسطة مسؤولي المستودع الذي قمت بتثبيت هذا المصدر منه، لذا يجب إصلاحه هناك. اسم المصدر وما كنت تفتحه هي تفاصيل مفيدة لتقديمها لهم.';

  @override
  String get error_reports_already_reported => 'تم الإبلاغ مسبقاً';

  @override
  String get error_reports_expected_failure =>
      'عادةً ما يعود هذا إلى المصدر أو الشبكة وليس التطبيق: رابط منتهي الصلاحية، أو خادم معطل، أو انقطاع في الاتصال. يستحق الإبلاغ فقط إذا استمر في الحدوث على مصدر يعمل في أماكن أخرى.';

  @override
  String get share_unavailable_copied =>
      'المشاركة غير متاحة، تم النسخ إلى الحافظة.';

  @override
  String get onboarding_title => 'مرحباً بك في NodeLane Comics';

  @override
  String get onboarding_libraries_body => 'اختر ما تقرأه وتشاهده.';

  @override
  String get onboarding_nav_title => 'مكتباتك';

  @override
  String get onboarding_nav_body =>
      'تبويب لكل منها أو تجميعها في تبويب مكتبة واحد.';

  @override
  String get onboarding_nav_split => 'تبويب لكل نوع';

  @override
  String get onboarding_nav_merged => 'تبويب مكتبة موحد';

  @override
  String get onboarding_nav_inside => 'الضغط على المكتبة يبدل هذه التبويبات';

  @override
  String get onboarding_next => 'التالي';

  @override
  String get onboarding_restore => 'استعادة نسخة احتياطية';

  @override
  String get onboarding_or_local => 'أو استخدام ملفات موجودة لديك';

  @override
  String get onboarding_local_folder => 'إضافة مجلد';

  @override
  String onboarding_local_existing(Object count) {
    return '$count مجلدات معدة بالفعل';
  }

  @override
  String get onboarding_local_any_type => 'يدعم المانغا والأنمي والروايات.';

  @override
  String get onboarding_local_scanning => 'جارٍ فحص المجلد';

  @override
  String onboarding_local_found(Object count) {
    return 'تم العثور على $count عناوين';
  }

  @override
  String get onboarding_local_remove => 'إزالة المجلد';

  @override
  String get onboarding_local_in_downloads => 'هذا مجلد تنزيلات التطبيق.';

  @override
  String get onboarding_local_empty =>
      'لم يتم العثور على شيء. اختر المجلد الرئيسي.';

  @override
  String get onboarding_repo_failed => 'تعذر قراءة المستودع.';

  @override
  String get onboarding_repo_title => 'إضافة مصدر';

  @override
  String get onboarding_body =>
      'أضف مستودعاً لتتمكن من تثبيت الإضافات وتصفحها.';

  @override
  String get onboarding_add => 'إضافة مستودع';

  @override
  String get onboarding_skip => 'تخطي الآن';

  @override
  String get onboarding_continue => 'متابعة';

  @override
  String get onboarding_later => 'يمكنك إضافته لاحقاً من الإعدادات > تصفح.';

  @override
  String get onboarding_replay => 'عرض شاشة الترحيب';

  @override
  String get onboarding_replay_subtitle => 'فتح شاشة الإعداد الأولى مجدداً.';

  @override
  String get missing_source_check_title => 'فحص المصادر المفقودة';

  @override
  String get missing_source_check_subtitle =>
      'العثور على عناصر لم يتم تثبيت إضافاتها.';

  @override
  String get missing_source_check_none_found => 'جميع مصادر المكتبة مثبتة.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مصدراً مفقوداً',
      few: '$count مصادر مفقودة',
      one: 'مصدر واحد مفقود',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'لا توجد مصادر $itemType مثبتة.';
  }

  @override
  String get global_search_no_sources_hint =>
      'أضف مستودعاً ضمن قسم التصفح، ثم قم بتثبيت إضافة له.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مصدراً',
      few: '$count مصادر',
      one: 'مصدر واحد',
    );
    return 'لديك $_temp0 لهذا، ولكن يتم البحث في المصادر المثبتة فقط.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'قم بتثبيت أحدها، أو أوقف تشغيل \"تضمين المصادر المثبتة فقط\" في إعدادات التصفح.';

  @override
  String get global_search_all_nsfw =>
      'جميع مصادرك لهذا مصنفة كـ NSFW وهي مخفية.';

  @override
  String get global_search_all_nsfw_hint =>
      'قم بتفعيل مصادر NSFW في إعدادات التصفح للبحث فيها.';

  @override
  String get missing_source_check_result_message =>
      'تشير هذه العناصر إلى مصادر غير مثبتة. اضغط لنقلها أو ثبت الإضافة.';

  @override
  String get related_titles => 'ذات صلة';

  @override
  String get related_none => 'لم يتم العثور على أي أعمال ذات صلة بهذا العنوان.';

  @override
  String get relation_adaptation => 'اقتباس';

  @override
  String get relation_sequel => 'تكملة';

  @override
  String get relation_prequel => 'جزء سابق';

  @override
  String get relation_parent => 'القصة الرئيسية';

  @override
  String get relation_side_story => 'قصة جانبية';

  @override
  String get relation_spin_off => 'عمل مشتق (Spin-off)';

  @override
  String get relation_alternative => 'نسخة بديلة';

  @override
  String get auto_library_update => 'تحديثات المكتبة التلقائية';

  @override
  String get auto_library_update_subtitle =>
      'التحقق من وجود فصول جديدة لكل عنصر في مكتبتك عند بدء تشغيل التطبيق.';

  @override
  String get auto_library_update_never => 'أبداً';

  @override
  String get auto_library_update_12_hours => 'كل 12 ساعة';

  @override
  String get auto_library_update_daily => 'يومياً';

  @override
  String get auto_library_update_2_days => 'كل يومين';

  @override
  String get auto_library_update_weekly => 'أسبوعياً';

  @override
  String get auto_library_update_wifi_only => 'عبر Wi-Fi فقط';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'تخطي التحديث المجدول أثناء استخدام بيانات الجوال.';

  @override
  String get padding => 'الهامش';

  @override
  String get page_mode => 'وضع الصفحة';

  @override
  String get single_page => 'صفحة مفردة';

  @override
  String get double_page => 'صفحة مزدوجة';

  @override
  String get speed => 'السرعة';

  @override
  String get theme_dark => 'داكن';

  @override
  String get theme_light => 'فاتح';

  @override
  String get theme_black => 'أسود';

  @override
  String get theme_sepia => 'سيبيا';

  @override
  String get decrease => 'تقليل';

  @override
  String get increase => 'زيادة';

  @override
  String get chapter_swipe_actions => 'إجراءات سحب الفصل';

  @override
  String get chapter_swipe_start => 'السحب لليمين';

  @override
  String get chapter_swipe_end => 'السحب لليسار';

  @override
  String get chapter_swipe_toggle_bookmark => 'تبديل الإشارة المرجعية';

  @override
  String get chapter_swipe_toggle_read => 'تبديل حالة القراءة';

  @override
  String get chapter_swipe_download => 'تنزيل';

  @override
  String get chapter_swipe_disabled => 'معطل';

  @override
  String get update_errors => 'أخطاء التحديث';

  @override
  String get no_update_errors => 'لا توجد أخطاء في التحديث';

  @override
  String get clear_all => 'مسح الكل';

  @override
  String get dismiss => 'استبعاد';

  @override
  String get previous_episode => 'الحلقة السابقة';

  @override
  String get clear_logs => 'مسح السجلات';

  @override
  String get bold => 'غامق';

  @override
  String get italic => 'مائل';

  @override
  String get color_yellow => 'أصفر';

  @override
  String get color_cyan => 'سماوي';

  @override
  String get color_green => 'أخضر';

  @override
  String get color_orange => 'برتقالي';

  @override
  String get continue_watching => 'تابع المشاهدة';

  @override
  String get search_your_anime => 'ابحث في الأنمي الخاص بك';

  @override
  String get category => 'الفئة';

  @override
  String get hidden_categories => 'الفئات المخفية';

  @override
  String get new_category => 'فئة جديدة';

  @override
  String get local => 'محلي';

  @override
  String get tv_home_rows => 'الصفوف';

  @override
  String get genre_rows => 'صفوف النوع';

  @override
  String get share_backup_file => 'مشاركة ملف النسخ الاحتياطي NodeLane Comics';

  @override
  String get close => 'إغلاق';

  @override
  String get migrate_source => 'ترحيل المصدر';

  @override
  String get cloudflare_bypass_proxy => 'تجاوز وكيل Cloudflare';

  @override
  String get custom_doh_url => 'مخصص DoH URL';

  @override
  String get custom_doh_url_helper =>
      'يجب أن يكون نقطة نهاية https DoH (JSON).';

  @override
  String get anime_only_tv_layout => 'تخطيط تلفزيون الأنيمي فقط';

  @override
  String get anime_only_beta => 'الأنمي فقط (بيتا)';

  @override
  String get tv_home_beta => 'تلفزيون المنزل (بيتا)';

  @override
  String get tv_player_beta => 'مشغل التلفاز (بيتا)';

  @override
  String get network_settings => 'الشبكة';

  @override
  String get reader_page_layout => 'تخطيط الصفحة';

  @override
  String get reader_continuous_options => 'القراءة المستمرة';

  @override
  String get reader_default_mode_hint =>
      'ينطبق وضع القراءة الافتراضي على العناوين دون تعيين وضع فردي أثناء القراءة.';

  @override
  String get extension_service => 'خدمة الإرشاد';

  @override
  String get extension_service_description =>
      'إدارة وقت تشغيل الامتداد وعنوان الوكيل.';

  @override
  String get proxy_address => 'عنوان الوكيل';

  @override
  String get checking_runtime_status => 'التحقق من الحالة...';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + تأخير عشوائي';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count الفصول',
      one: '1 فصل',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'إضافة التنزيلات من قائمة فصول العنوان.';

  @override
  String get download_queue_order_hint => 'اسحب المقابض لإعادة الترتيب';

  @override
  String get download_queue_empty => 'لم يتم وضع أي تنزيلات في قائمة الانتظار';

  @override
  String get download_queue_actions => 'تنزيل الإجراءات';

  @override
  String get download_queue_cancel_chapter => 'إلغاء تنزيل هذا الفصل';

  @override
  String get download_queue_cancel_series =>
      'إلغاء كافة التنزيلات لهذا العنوان';

  @override
  String get download_queue_start => 'بدء التنزيلات';

  @override
  String get download_queue_retry => 'إعادة محاولة التنزيلات';

  @override
  String get download_queue_active => 'التحميل';

  @override
  String get download_queue_waiting => 'في انتظار التحميل';

  @override
  String get download_queue_failed => 'فشل التحميل';

  @override
  String get cf_proxy_helper =>
      'نقطة نهاية FlareSolverr / Byparr. اتركه فارغًا للتعطيل.';

  @override
  String get mobile_navigation_description =>
      'اسحب لإعادة الترتيب. تشترك المانغا والأنيمي والروايات في علامة تبويب المكتبة. يتم فتح العنصر المرئي الأول عند الإطلاق. التصفح والمزيد يبقى مرئيًا؛ تظهر علامات التبويب الإضافية ضمن المزيد.';

  @override
  String get text_align_justify => 'تبرير';

  @override
  String get novel_session_modes_hint =>
      'ضبط وضع القراءة والصفحات المفردة أو المزدوجة أثناء قراءة العنوان.';

  @override
  String get tts_languages_failed => 'تعذر تحميل اللغات من محرك الكلام.';

  @override
  String get tts_languages_empty =>
      'لم يُرجع محرك الكلام أي لغة. يتم الاحتفاظ باختيارك المحفوظ.';

  @override
  String get tts_language_unavailable =>
      'هذه اللغة المحفوظة ليست موجودة في القائمة الحالية للجهاز.';

  @override
  String get tts_apply_failed =>
      'لا يمكن تطبيق هذا الإعداد على محرك الكلام. يمكنك إعادة المحاولة.';

  @override
  String get player_controls => 'الضوابط';

  @override
  String get audio_channel_auto => 'تلقائي';

  @override
  String get audio_channel_auto_safe => 'تلقائي (آمن)';

  @override
  String get audio_channel_mono => 'مونو';

  @override
  String get audio_channel_stereo => 'ستيريو';

  @override
  String get audio_channel_reverse_stereo => 'ستيريو عكسي';

  @override
  String get mpv_bundled_config_hint =>
      'قم باستعادة التكوين والبرامج النصية والتظليل المضمن في التطبيق. سيتم الكتابة فوق الملفات التي تحمل نفس الأسماء.';

  @override
  String get mpv_restore_bundled => 'استعادة التكوين المجمع';

  @override
  String get mpv_restore_confirm =>
      'هل تريد استعادة تكوين MPV المجمع؟ سيتم الكتابة فوق التكوين الحالي والبرامج النصية والتظليل الذي يحمل نفس الأسماء. سيتم الاحتفاظ بالملفات الأخرى.';

  @override
  String get player_operation_incomplete =>
      'لا يمكن إكمال العملية. تحقق من الوصول إلى الملف وحاول مرة أخرى.';

  @override
  String get custom_buttons_empty_hint => 'أضف زر مشغل مع تسمية وإجراء ضغط.';

  @override
  String get custom_button_primary => 'الزر الافتراضي';

  @override
  String get show_password => 'إظهار كلمة المرور';

  @override
  String get hide_password => 'إخفاء كلمة المرور';

  @override
  String get tracking_accounts_empty =>
      'قم بتوصيل الخدمة في إعدادات التتبع لإدارة إدخالاتها.';

  @override
  String get tracking_entries_empty =>
      'لا توجد إدخالات متعقبة لنوع الوسائط هذا. أضف تتبعًا من صفحة تفاصيل العنوان.';

  @override
  String get change_tracking_match => 'تغيير العنوان المطابق';

  @override
  String get remove_tracking => 'إزالة التتبع';

  @override
  String remove_tracking_confirm(String title) {
    return 'هل تريد إزالة رابط التتبع لـ \"$title\"؟ سيتم الاحتفاظ بالإدخال في خدمة التتبع.';
  }

  @override
  String get tracking_refresh_required =>
      'لا يمكن تأكيد حالة التتبع. قم بالتحديث قبل إجراء تغيير آخر.';

  @override
  String get tracking_entry_unlinked =>
      'هذا السجل غير مرتبط بعنوان محلي، لذلك لا يمكن تحريره هنا.';

  @override
  String get backup_selection_shared =>
      'يتم حفظ التغييرات التي يتم إجراؤها على هذه التحديدات على الفور ويتم تطبيقها أيضًا على النسخ الاحتياطية التلقائية.';

  @override
  String get library_snapshot_history => 'استعادة لقطة المكتبة';

  @override
  String get library_snapshot_empty => 'لا تتوفر لقطات أمان.';

  @override
  String get library_snapshot_restore_message =>
      'سيتم استبدال البيانات الحالية بهذه اللقطة. سيتم فقدان التغييرات التي تم إجراؤها منذ ذلك الحين. لا يمكن استعادة التنزيلات المحذوفة. سيتم مسح لقطات السلامة المتوفرة بعد النجاح.';

  @override
  String get library_maintenance_working => 'تحديث المكتبة...';

  @override
  String get library_safety_snapshot_note =>
      'سيتم حفظ لقطة السلامة قبل هذه العملية. ولا يشمل الملفات التي تم تنزيلها.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'إدخالات المكتبة: $mangaCount. الفصول: $chapterCount. إدخالات التاريخ: $historyCount. التحديثات: $updateCount.\n\nاختر ما تريد الاحتفاظ به أدناه.';
  }

  @override
  String get library_delete_pick_message =>
      'اختر مصدرًا لمراجعة محتوياته وخيارات الحذف.';

  @override
  String get mobile_categories_hint =>
      'اسحب لإعادة الترتيب. افتح فئة لإعادة تسميتها أو تغيير رؤيتها وتحديثاتها.';

  @override
  String get mobile_category_visible => 'العرض في المكتبة';

  @override
  String get mobile_category_hidden => 'مخفي من المكتبة';

  @override
  String get mobile_category_updates => 'تضمين تحديثات المكتبة';

  @override
  String get statistics_watched => 'شاهد';

  @override
  String get calendar_month => 'الشهر';

  @override
  String get calendar_two_weeks => 'أسبوعين';

  @override
  String get calendar_week => 'الأسبوع';

  @override
  String get calendar_show_all_dates => 'إظهار كافة التواريخ';

  @override
  String get update_check_no_result =>
      'لم يتم العثور على تحديث قابل للتثبيت. يمكنك المحاولة مرة أخرى لاحقًا.';

  @override
  String get release_notes => 'ملاحظات الإصدار';

  @override
  String get no_release_notes => 'لم يتم توفير ملاحظات الإصدار.';

  @override
  String get downloading_update => 'جارٍ تنزيل التحديث...';

  @override
  String get preparing_installation => 'جارٍ تحضير التثبيت...';

  @override
  String get onboarding_mobile_libraries_body =>
      'اختر ما تريد قراءته. يمكنك تغيير هذا لاحقا.';

  @override
  String get onboarding_content_title => 'ابدأ القراءة';

  @override
  String get onboarding_mobile_sources_body =>
      'اختر طريقة للبدء، أو أضف محتوى لاحقًا.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'الخطوة $step من $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'نتائج لـ “$query”';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count المصادر',
      one: 'مصدر واحد',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'ابحث عن عنوان الوجهة.';

  @override
  String get migration_original_item => 'العنصر الحالي';

  @override
  String get migration_target_item => 'العنصر المحدد';

  @override
  String get migration_partial_failure =>
      'لم تنتهي العملية. ربما تم حفظ بعض التغييرات. تحقق من هذا العنصر في مكتبتك قبل المحاولة مرة أخرى.';

  @override
  String get migration_no_categories =>
      'لا توجد فئات. يمكنك إضافة هذا العنصر بدون فئة.';

  @override
  String get mass_migration_select_source => 'اختر المصدر الحالي';

  @override
  String get mass_migration_select_all => 'اختر الكل';

  @override
  String get mass_migration_deselect_all => 'قم بإلغاء تحديد الكل';

  @override
  String get mass_migration_needs_review =>
      'مراجعة عمليات الترحيل غير المكتملة';

  @override
  String get bookshelf_actions => 'إجراءات رف الكتب';

  @override
  String get bookshelf_ignore_filters => 'تجاهل عوامل التصفية عند البحث';

  @override
  String get bookshelf_ignore_filters_hint =>
      'ابحث في جميع الأعمال في هذه الفئة، بما في ذلك تلك المخفية بواسطة المرشحات.';

  @override
  String get bookshelf_stop_update => 'إيقاف تحديث المكتبة';

  @override
  String bookshelf_selected_count(int count) {
    return '$count الأعمال المختارة';
  }

  @override
  String get bookshelf_remove_library => 'قم بإزالته من رف الكتب';

  @override
  String get bookshelf_remove_library_hint =>
      'إزالة المفضلة. كما تفقد الواردات المحلية مكتبتها وسجلات القراءة الخاصة بها.';

  @override
  String get bookshelf_remove_downloads => 'حذف الملفات التي تم تنزيلها';

  @override
  String get bookshelf_remove_downloads_hint =>
      'إزالة الملفات التي تم تنزيلها مع الاحتفاظ بمعلومات العمل.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'يقوم أيضًا بحذف الملفات المستوردة المحلية المحددة وإزالة سجلات المكتبة الخاصة بها. لا يمكن استرداد هذه الملفات هنا.';

  @override
  String get bookshelf_remove_incomplete =>
      'لم تنتهي العملية. ربما تمت معالجة بعض الأعمال أو الملفات. أغلق مربع الحوار هذا وتحقق من رف الكتب والتنزيلات قبل المتابعة.';

  @override
  String get bookshelf_processing => 'المعالجة…';

  @override
  String get bookshelf_mark_read => 'ضع علامة للقراءة';

  @override
  String get bookshelf_mark_unread => 'وضع علامة كغير مقروءة';

  @override
  String get bookshelf_select_all => 'اختر الكل';

  @override
  String get bookshelf_invert_selection => 'عكس التحديد';

  @override
  String get bookshelf_settings => 'إعدادات رف الكتب';

  @override
  String get bookshelf_settings_live =>
      'تسري تغييرات التصفية والفرز والعرض على الفور.';

  @override
  String get bookshelf_filter_any => 'أي';

  @override
  String get bookshelf_filter_include => 'تضمين';

  @override
  String get bookshelf_filter_exclude => 'استبعاد';

  @override
  String get bookshelf_all_sources => 'جميع المصادر';

  @override
  String bookshelf_sources_selected(int count) {
    return '$count المصادر المحددة';
  }

  @override
  String get bookshelf_sort_ascending => 'تصاعدي';

  @override
  String get bookshelf_sort_descending => 'تنازلي';

  @override
  String get bookshelf_layout => 'تخطيط رف الكتب';

  @override
  String get bookshelf_sources_hint =>
      'حدد لا شيء لإظهار كافة المصادر. يتم تطبيق التغييرات عند النقر فوق \"تصفية\".';

  @override
  String get bookshelf_choose_files => 'اختر الملفات';

  @override
  String get bookshelf_import_wait =>
      'اختر ملفًا في المنتقي وانتظر حتى تنتهي عملية الاستيراد.';

  @override
  String get bookshelf_import_incomplete =>
      'لم يتم الانتهاء من الاستيراد. قد تكون بعض الملفات موجودة بالفعل في رف كتبك. أغلق مربع الحوار هذا وتحقق قبل الاستيراد مرة أخرى.';

  @override
  String get bookshelf_categories_replace =>
      'يؤدي الحفظ إلى تعيين هذه الفئات لكل عمل محدد، واستبدال فئاتها السابقة.';

  @override
  String get bookshelf_categories_hint =>
      'اختر فئة واحدة أو أكثر، أو اترك التحديد فارغًا لعدم تعيين أي فئة.';

  @override
  String get bookshelf_categories_hidden =>
      'يتم الاحتفاظ بالفئات المخفية الموجودة لهذا العمل.';

  @override
  String get bookshelf_categories_incomplete =>
      'لا يمكن حفظ الفئات بالكامل. أغلق مربع الحوار هذا وتحقق من رف الكتب قبل المحاولة مرة أخرى.';

  @override
  String get bookshelf_categories_none_visible =>
      'لا توجد فئات متاحة هنا. افتح إدارة الفئات لمراجعتها.';

  @override
  String get bookshelf_manage_categories => 'إدارة الفئات';

  @override
  String get manga_actions => 'أفعال كوميدية';

  @override
  String get manga_download_scope => 'تحميل الفصول';

  @override
  String get manga_download_scope_hint =>
      'اختر الفصول ضمن المرشحات الحالية. يتم تخطي الفصول التي تم تنزيلها.';

  @override
  String get manga_download_scope_empty =>
      'لا توجد فصول تتطابق مع عوامل التصفية الحالية. أغلق هذه القائمة واضبط مرشحات الفصل.';

  @override
  String get manga_action_incomplete =>
      'لم ينته الإجراء. تحقق من الحالة الحالية قبل المحاولة مرة أخرى.';

  @override
  String get chapter_settings => 'إعدادات الفصل';

  @override
  String get chapter_settings_live =>
      'يتم تطبيق تغييرات التصفية والفرز على الفور.';

  @override
  String get chapter_scanlators_all => 'إظهار كافة مجموعات الماسح الضوئي';

  @override
  String get chapter_scanlators_hint =>
      'حدد المجموعات لإخفاء فصولها. يتم تطبيق التغييرات عند النقر فوق \"تصفية\".';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count مجموعات الماسح الضوئي مخفية';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count الفصول مختارة';
  }

  @override
  String get chapter_add_bookmark => 'إشارة مرجعية';

  @override
  String get chapter_remove_bookmark => 'إلغاء الإشارة المرجعية';

  @override
  String get chapter_read_following => 'اقرأ أدناه';

  @override
  String get chapter_delete_records => 'حذف سجلات الفصل';

  @override
  String get chapter_delete_local_hint =>
      'إزالة سجلات الفصل المحدد وتقدم القراءة. يتم الاحتفاظ بالأرشيفات المحلية الأصلية؛ يتم تنظيف النسخ التي تم تنزيلها.';

  @override
  String get chapter_delete_last_hint =>
      'هذه كلها فصول في هذا الكتاب الهزلي. يؤدي حذفها أيضًا إلى إزالة القصص المصورة من رف كتبك.';

  @override
  String get chapter_action_incomplete =>
      'لم ينته الإجراء. ربما تم حفظ بعض التغييرات بالفعل. أغلق الفصول والتنزيلات وتحقق منها قبل المتابعة.';

  @override
  String get reader_display_scope =>
      'ينطبق وضع القراءة والتخطيط اليدوي للصفحة على هذه القصة المصورة. اختر تغييرًا للعودة إلى القراءة.';

  @override
  String get reader_display_single_only =>
      'تستخدم القراءة المستمرة الأفقية الصفحات المفردة.';

  @override
  String get reader_display_manual_pages =>
      'يؤدي تغيير تخطيط الصفحة إلى إيقاف تشغيل الصفحة المزدوجة التلقائية لجميع القصص المصورة.';

  @override
  String get reader_display_crop_scope => 'ينطبق على جميع القصص المصورة.';

  @override
  String get reader_chapter_locate => 'حدد موقع الفصل الحالي';

  @override
  String get reader_chapter_search => 'البحث في الفصول أو الماسحات الضوئية';

  @override
  String get reader_chapter_scope =>
      'يستخدم مرشحات الفصل وترتيب الفرز من التفاصيل المصورة. يتم حفظ الإشارات المرجعية على الفور.';

  @override
  String get reader_chapter_current_hidden =>
      'الفصل الذي تقرأه يقع خارج المرشحات الحالية.';

  @override
  String get reader_chapter_current => 'القراءة الآن';

  @override
  String get reader_chapter_read => 'إقرأ';

  @override
  String get reader_chapter_bookmark_failed =>
      'لا يمكن تأكيد حفظ الإشارة المرجعية. أغلق القائمة وتحقق من حالتها الحالية.';

  @override
  String get reader_image_actions => 'إجراءات الصورة';

  @override
  String get reader_image_original =>
      'يستخدم الصفحة الأصلية الكاملة، بدون مرشحات الترجمة أو الاقتصاص أو ألوان القارئ.';

  @override
  String get reader_image_save_ios =>
      'احفظ في مجلد الصور في موقع تخزين التطبيق الحالي.';

  @override
  String get reader_image_save_android =>
      'احفظ في مجلد الصور/nodelane-comics الخاص بالجهاز.';

  @override
  String get reader_image_share => 'افتح ورقة مشاركة النظام.';

  @override
  String get reader_image_cover =>
      'قم بتغيير غلاف هذه القصة المصورة بعد التأكيد.';

  @override
  String get reader_image_cover_limit =>
      'يجب أن يكون حجم صور الغلاف أصغر من 5 ميجابايت. يبقى الحفظ والمشاركة متاحين.';

  @override
  String get reader_image_action_failed =>
      'لا يمكن تأكيد الإجراء. أغلق هذه القائمة وتحقق من النتيجة قبل المحاولة مرة أخرى.';

  @override
  String get reader_settings_book_scope =>
      'تنطبق هذه الإعدادات على هذا الفيلم الهزلي فقط.';

  @override
  String get reader_settings_global_scope =>
      'تنطبق هذه الإعدادات على كافة القصص المصورة ويتم حفظها على الفور.';

  @override
  String get reader_filters => 'مرشحات الصور';

  @override
  String get reader_filter_scope =>
      'ينطبق على جميع القصص المصورة. يقوم بتغيير عرض القراءة دون تعديل الصور الأصلية.';

  @override
  String get reader_auto_scroll_pause =>
      'يتوقف التمرير مؤقتًا أثناء فتح الإعدادات.';

  @override
  String get manga_synopsis => 'ملخص';

  @override
  String manga_author(String author) {
    return 'المؤلف: $author';
  }

  @override
  String get manga_continue_reading => 'أكمل القراءة';

  @override
  String get reader_settings_title => 'إعدادات القارئ';

  @override
  String get reader_picker_book_scope => 'فقط لهذا الفيلم الهزلي';

  @override
  String get reader_picker_global_scope => 'ينطبق على جميع القصص المصورة';

  @override
  String get reader_picker_apply_hint =>
      'اضغط للحفظ والعودة إلى المستوى السابق.';

  @override
  String get reader_scale_fit_screen_hint => 'احتواء الصفحة بأكملها على الشاشة';

  @override
  String get reader_scale_stretch_hint => 'املأ منطقة القراءة';

  @override
  String get reader_scale_fit_width_hint => 'ملائمة الصفحة للعرض';

  @override
  String get reader_scale_fit_height_hint => 'ملائمة الصفحة للارتفاع';

  @override
  String get source_filter_active => 'مطبق';

  @override
  String get source_filter_apply => 'تطبيق المرشحات';

  @override
  String get source_filter_scope =>
      'تنطبق عوامل التصفية على موقع الويب هذا فقط.';

  @override
  String get source_filter_apply_hint =>
      'قم بتطبيق المرشحات لاستخدام اختياراتك.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'الأنواع',
      'author': 'المؤلف',
      'artist': 'فنان',
      'title': 'العنوان',
      'year': 'السنة',
      'tags': 'العلامات',
      'format': 'التنسيق',
      'publisher': 'الناشر',
      'relevance': 'الصلة',
      'rating': 'التقييم',
      'views': 'المشاهدات',
      'random': 'عشوائي',
      'all': 'الكل',
      'none': 'لا شيء',
      'action': 'الإجراء',
      'adventure': 'المغامرة',
      'comedy': 'كوميديا',
      'drama': 'الدراما',
      'fantasy': 'الخيال',
      'romance': 'الرومانسية',
      'science_fiction': 'الخيال العلمي',
      'slice_of_life': 'شريحة من الحياة',
      'mystery': 'الغموض',
      'horror': 'الرعب',
      'psychological': 'نفسي',
      'historical': 'تاريخي',
      'sports': 'الرياضة',
      'supernatural': 'خارق للطبيعة',
      'school_life': 'الحياة المدرسية',
      'tragedy': 'المأساة',
      'shounen': 'الشونين',
      'shoujo': 'شوجو',
      'seinen': 'سينين',
      'josei': 'جوزي',
      'isekai': 'إيسيكاي',
      'martial_arts': 'الفنون القتالية',
      'mecha': 'ميكا',
      'music': 'الموسيقى',
      'doujinshi': 'دوجينشي',
      'trending': 'تتجه',
      'new': 'جديد',
      'adult_content': 'محتوى للبالغين',
      'only': 'فقط',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'المزيد من خيارات العرض';

  @override
  String get bookshelf_more_display_hint => 'الشارات والمصادر والفئات';

  @override
  String get bookshelf_download_count => 'عدد التنزيلات';

  @override
  String get bookshelf_source_global_hint =>
      'تستخدم رؤية المصدر تفضيلات العرض المشتركة.';

  @override
  String get bookshelf_select_entries => 'حدد الأعمال';

  @override
  String get bookshelf_search_options => 'خيارات البحث';

  @override
  String get bookshelf_empty_hint =>
      'جمع الأعمال من المصادر أو استيراد الملفات المحلية.';

  @override
  String get bookshelf_no_match_hint =>
      'جرب كلمات أساسية أخرى أو اضبط عوامل التصفية الحالية.';

  @override
  String get bookshelf_clear_query => 'مسح الكلمات الأساسية';

  @override
  String get bookshelf_view_selection => 'عرض الأعمال المختارة';

  @override
  String get bookshelf_import_formats =>
      'اختر ملفًا محليًا لإضافته إلى رف الكتب الخاص بك.';

  @override
  String get bookshelf_import_canceled_hint =>
      'يمكنك الاختيار مرة أخرى بعد إلغاء منتقي الملفات.';

  @override
  String get bookshelf_browse_sources => 'تصفح المصادر';

  @override
  String get bookshelf_empty_title => 'رف الكتب الخاص بك فارغ';

  @override
  String get bookshelf_no_match_title => 'لا توجد أعمال مطابقة';

  @override
  String get bookshelf_mark_watched => 'شاهد مارك';

  @override
  String get bookshelf_mark_unwatched => 'مارك غير مراقب';

  @override
  String get nodelane_account => 'NodeLane';

  @override
  String get nodelane_sign_in => 'قم بتسجيل الدخول إلى NodeLane';

  @override
  String get nodelane_account_intro =>
      'عرض حسابك واشتراكك وحصة الترجمة الخاصة بك';

  @override
  String get nodelane_login_action => 'متابعة تسجيل الدخول';

  @override
  String get nodelane_login_browser =>
      'قم بتسجيل الدخول من خلال متصفح النظام ثم قم بالعودة إلى التطبيق';

  @override
  String get nodelane_account_id => 'معرف الحساب';

  @override
  String get nodelane_account_init_error =>
      'تخزين الحساب غير متوفر. أعد تشغيل التطبيق وحاول مرة أخرى.';

  @override
  String get nodelane_account_refresh_error => 'لا يمكن تحديث معلومات الحساب';

  @override
  String get nodelane_account_auth_error =>
      'انتهت صلاحية جلستك. قم بتسجيل الدخول مرة أخرى';

  @override
  String get nodelane_account_unknown => 'معلومات الاشتراك غير متوفرة';

  @override
  String get nodelane_account_current => 'الاشتراك الحالي';

  @override
  String get nodelane_account_free => 'حساب مجاني';

  @override
  String get nodelane_account_no_subscription => 'لا يوجد اشتراك نشط';

  @override
  String get nodelane_account_active => 'نشط';

  @override
  String get nodelane_account_expired => 'انتهت صلاحيته';

  @override
  String get nodelane_account_expiry => 'صالح حتى';

  @override
  String get nodelane_account_renewal => 'التجديد';

  @override
  String get nodelane_renewal_auto => 'التجديد التلقائي';

  @override
  String get nodelane_renewal_manual => 'التجديد اليدوي';

  @override
  String get nodelane_renewal_stopped => 'توقف التجديد التلقائي';

  @override
  String get nodelane_renewal_gift => 'عضوية هدية';

  @override
  String get nodelane_renewal_attention =>
      'تحقق من حالة التجديد الخاصة بك على الموقع';

  @override
  String get nodelane_next_billing => 'تاريخ الفاتورة التالي';

  @override
  String get nodelane_billing_unavailable => 'معلومات التجديد غير متوفرة';

  @override
  String get nodelane_manage_account => 'الإدارة على موقع الويب';

  @override
  String get nodelane_view_plans => 'عرض خطط الاشتراك';

  @override
  String get nodelane_translation_quota => 'حصة الترجمة';

  @override
  String get nodelane_quota_free => 'حصة مجانية';

  @override
  String get nodelane_quota_subscription => 'حصة الاشتراك';

  @override
  String get nodelane_quota_purchase => 'الحصة المشتراة';

  @override
  String get nodelane_quota_details => 'عرض تفاصيل الحصة النسبية';

  @override
  String get nodelane_quota_expanded => 'تفاصيل الحصة النسبية';

  @override
  String get nodelane_quota_unlimited => 'غير محدود';

  @override
  String get nodelane_quota_not_subscribed => 'غير مشترك';

  @override
  String get nodelane_quota_unknown => 'غير متاح';

  @override
  String get nodelane_quota_used => 'مستخدم';

  @override
  String get nodelane_quota_reserved => 'قيد التقدم';

  @override
  String get nodelane_quota_reset => 'إعادة التعيين التالي';

  @override
  String get nodelane_quota_expiry => 'انتهاء الصلاحية التالي';

  @override
  String get nodelane_quota_no_expiry => 'لا يوجد تاريخ انتهاء الصلاحية';

  @override
  String get nodelane_quota_reservation_note =>
      'تم بالفعل خصم الصفحات قيد التقدم من الحصة المتوفرة';

  @override
  String nodelane_quota_available(int count) {
    return '$count الصفحات المتبقية';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count صفحات';
  }

  @override
  String get nodelane_sign_out => 'تسجيل الخروج';

  @override
  String get nodelane_sign_out_confirm =>
      'يؤدي تسجيل الخروج إلى إيقاف الترجمة الرسمية مؤقتًا على هذا الجهاز. يتم الاحتفاظ بمكتبتك وتقدم القراءة.';

  @override
  String get settings_search_hint => 'إعدادات البحث';

  @override
  String get settings_frequent => 'يستخدم بشكل متكرر';

  @override
  String get settings_reading_translation => 'القراءة والترجمة';

  @override
  String get settings_app_preferences => 'تفضيلات التطبيق';

  @override
  String get settings_data_management => 'البيانات والإدارة';

  @override
  String get settings_more_tools => 'المزيد من الأدوات';

  @override
  String get settings_more_tools_hint => 'الفئات والإحصائيات والتقويم';

  @override
  String get settings_appearance_interface => 'المظهر والواجهة';

  @override
  String get settings_security_privacy => 'الأمان والخصوصية';

  @override
  String get settings_source_preferences => 'إعدادات المصدر';

  @override
  String get settings_about_help => 'حول والمساعدة';

  @override
  String get settings_storage_backup => 'التخزين والنسخ الاحتياطي';

  @override
  String settings_pending_downloads(int count) {
    return '$count معلق';
  }

  @override
  String get settings_translation_language => 'لغة الترجمة';

  @override
  String get settings_translation_scope =>
      'يُستخدم في ترجمة القارئ وصفحات الويب';

  @override
  String get settings_immediate_choice => 'يتم تطبيق التغييرات على الفور';

  @override
  String get settings_translation_init_error =>
      'إعدادات الترجمة غير متوفرة. أعد تشغيل التطبيق وحاول مرة أخرى.';

  @override
  String get settings_local_cache => 'ذاكرة التخزين المؤقت المحلية';

  @override
  String get settings_chapter_cache => 'ذاكرة التخزين المؤقت للفصل والحلقة';

  @override
  String get settings_cover_cache => 'غطاء ذاكرة التخزين المؤقت';

  @override
  String get settings_translation_cache =>
      'ذاكرة التخزين المؤقتة للصور المترجمة';

  @override
  String get settings_translation_cache_hint =>
      'احتفظ بسجلات الترجمة واسترجاع الصور المترجمة مرة أخرى عند الحاجة';

  @override
  String get settings_cache_clear => 'واضح';

  @override
  String get settings_translation_cache_done =>
      'تم مسح ذاكرة التخزين المؤقت للصورة المترجمة؛ تم الاحتفاظ بسجلات الترجمة';

  @override
  String settings_cache_confirmation(String name) {
    return 'مسح $name؟ يمكن استرداد المحتوى المخزن مؤقتًا مرة أخرى. سيتم الاحتفاظ بإدخالات المكتبة.';
  }

  @override
  String get settings_advanced_options => 'الخيارات المتقدمة';

  @override
  String get settings_manga_reader => 'قارئ المانغا';

  @override
  String get settings_novel_reader => 'قارئ الرواية';

  @override
  String get settings_downloads => 'إعدادات التنزيل';

  @override
  String get onboarding_welcome => 'مرحباً بك';

  @override
  String get onboarding_reading_content => 'محتوى القراءة';

  @override
  String get onboarding_choose_one => 'اختر واحدًا على الأقل';

  @override
  String get onboarding_restore_hint => 'استعادة مكتبتك من نسخة احتياطية';

  @override
  String get onboarding_browse_hint =>
      'ابحث عن العناوين على مواقع الويب المدعومة';

  @override
  String get onboarding_import_folder => 'قم باستيراد مجلد محلي';

  @override
  String get onboarding_import_folder_hint =>
      'اقرأ المانغا والروايات والأنمي على جهازك';

  @override
  String get onboarding_third_party => 'إضافة مستودع جهة خارجية';

  @override
  String get onboarding_third_party_hint =>
      'استخدم عنوان المستودع الموجود لديك بالفعل';

  @override
  String get onboarding_repository_hint => 'أدخل العنوان المقدم من المستودع.';

  @override
  String get onboarding_repository_address => 'العنوان';

  @override
  String get onboarding_repository_address_hint => 'أدخل عنوان المستودع';

  @override
  String get onboarding_add_repository => 'إضافة مستودع';

  @override
  String get onboarding_start => 'ابدأ';

  @override
  String get onboarding_open_library => 'المكتبة المفتوحة';

  @override
  String get onboarding_view_imports => 'عرض المحتوى المستورد';

  @override
  String get onboarding_view_folders => 'عرض المجلدات';

  @override
  String get notice_backup_created => 'تم إنشاء النسخة الاحتياطية';

  @override
  String get notice_backup_ready => 'احفظ ملف النسخة الاحتياطية أو شاركه.';

  @override
  String get notice_backup_restored => 'تمت استعادة النسخة الاحتياطية';

  @override
  String get notice_backup_unsupported =>
      'تنسيق النسخ الاحتياطي هذا غير مدعوم.';

  @override
  String get notice_verification_required => 'مطلوب التحقق من موقع الويب';

  @override
  String get notice_verification_hint => 'أكمل عملية التحقق لمواصلة التصفح.';

  @override
  String get notice_verify => 'التحقق من الموقع';

  @override
  String get notice_action_incomplete =>
      'لم ينته الإجراء. تحقق من نتيجته قبل المحاولة مرة أخرى.';

  @override
  String get notice_library_updating => 'تحديث المكتبة';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'تم تحديد عناوين $current / $total';
  }

  @override
  String get notice_library_failed => 'لا يمكن تحديث بعض العناوين';

  @override
  String get notice_import_completed => 'اكتمل الاستيراد';

  @override
  String get notice_operation_incomplete => 'الإجراء غير مكتمل';

  @override
  String get subtitle_service => 'خدمة الترجمة عبر الإنترنت';

  @override
  String get subtitle_service_mode => 'مصدر الترجمة';

  @override
  String get subtitle_service_disabled =>
      'متوقف عن العمل · مسح بيانات الاعتماد المحفوظة';

  @override
  String get subtitle_personal_key => 'مفتاح Wyzie الخاص بي';

  @override
  String get subtitle_custom_service => 'خدمة الترجمة الخاصة بي';

  @override
  String get subtitle_key => 'Wyzie API مفتاح';

  @override
  String get subtitle_key_hint =>
      'أدخل مفتاح Wyzie الخاص بك. ويبقى على هذا الجهاز ولا يتم تضمينه في النسخ الاحتياطية للتطبيقات.';

  @override
  String get subtitle_get_key => 'احصل على مفتاح شخصي';

  @override
  String get subtitle_service_address => 'بحث الترجمة URL';

  @override
  String get subtitle_service_token => 'رمز الوصول إلى الخدمة (اختياري)';

  @override
  String get subtitle_custom_hint =>
      'استخدم بحث HTTPS الكامل URL لخدمة Wyzie-compatible، بما في ذلك مسارها (على سبيل المثال، /search). أدخل رمز الوصول فقط إذا كانت الخدمة تتطلب واحدًا.';

  @override
  String get subtitle_service_off_hint =>
      'تم إيقاف البحث عن الترجمة عبر الإنترنت. تظل الترجمات المضمنة والمقدمة من المصدر والمحلية متاحة.';

  @override
  String get subtitle_setup_required => 'اختر خدمة الترجمة قبل البحث.';

  @override
  String get subtitle_invalid_key => 'أدخل مفتاحًا بدون مسافات.';

  @override
  String get subtitle_invalid_address =>
      'استخدم HTTPS URL كاملة بدون استعلام أو جزء أو بيانات اعتماد مضمنة.';

  @override
  String get subtitle_invalid_token =>
      'لا يمكن أن يحتوي رمز الوصول على مسافات.';

  @override
  String get subtitle_storage_failed =>
      'لا يمكن قراءة أو حفظ إعدادات الترجمة. يرجى المحاولة مرة أخرى.';

  @override
  String get subtitle_auth_failed =>
      'تم رفض الوصول إلى خدمة الترجمة. تحقق من المفتاح أو رمز الخدمة الخاص بك.';

  @override
  String get subtitle_quota_exhausted =>
      'تم استنفاد حصة خدمة الترجمة. تحقق من حسابك مع تلك الخدمة.';

  @override
  String get subtitle_network_failed =>
      'لا يمكن الوصول إلى خدمة الترجمة. يرجى المحاولة مرة أخرى.';

  @override
  String get subtitle_response_invalid =>
      'قامت خدمة الترجمة بإرجاع استجابة أو ملف غير مدعوم.';

  @override
  String get detail_loading_chapters => 'تحميل الفصول...';

  @override
  String get reader_opening_chapter => 'الفصل الافتتاحي';

  @override
  String get reader_open_chapter => 'الفصل المفتوح';

  @override
  String get reader_loading_pages => 'الحصول على صور الفصل...';

  @override
  String get reader_loading_pages_hint =>
      'ستبدأ القراءة تلقائيًا عندما تصبح جاهزة.';

  @override
  String get reader_loading_failed => 'لا يمكن تحميل هذا الفصل';

  @override
  String get reader_loading_retry_hint => 'تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get reader_no_pages => 'لم يتم العثور على صور لهذا الفصل';

  @override
  String get reader_loading_previous => 'تحميل الفصل السابق...';

  @override
  String get reader_previous_failed => 'تعذر تحميل الفصل السابق';

  @override
  String get reader_reached_start => 'لقد وصلت إلى الفصل الأول';

  @override
  String get reader_loading_next => 'جاري تحميل الفصل التالي...';

  @override
  String get reader_next_failed => 'لا يمكن تحميل الفصل التالي';

  @override
  String get reader_image_loading => 'تحميل الصورة...';

  @override
  String get reader_image_failure_hint =>
      'يمكنك الاستمرار في قراءة الصفحات الأخرى.';

  @override
  String get comic_paged => 'صفحة بصفحة';

  @override
  String get comic_scroll => 'قم بالتمرير لأسفل';

  @override
  String get comic_book_scope =>
      'ينطبق فقط على هذا الكتاب · يتم حفظ التغييرات على الفور';

  @override
  String get comic_defaults_title => 'الافتراضات والعادات';

  @override
  String get comic_defaults_hint =>
      'تنطبق الإعدادات الافتراضية على الحقول التي لم تقم بتخصيصها لكتاب ما.';

  @override
  String get comic_habits_hint => 'تنطبق هذه العادات على كل قصة كوميدية.';

  @override
  String get comic_turn => 'اسحب إلى الصفحة التالية';

  @override
  String get comic_left => 'اليسار';

  @override
  String get comic_right => 'صحيح';

  @override
  String get comic_up => 'أعلى';

  @override
  String get comic_fit => 'احتواء الصفحة';

  @override
  String get comic_fit_contain => 'الصفحة بأكملها';

  @override
  String get comic_fit_width => 'عرض مناسب';

  @override
  String get comic_fit_height => 'الارتفاع المناسب';

  @override
  String get comic_layout => 'تخطيط الصفحة';

  @override
  String get comic_auto => 'تلقائي';

  @override
  String get comic_layout_hint =>
      'يُظهر الانتشار تلقائيًا عندما يكون هناك عرض كافٍ.';

  @override
  String get comic_width => 'عرض المحتوى';

  @override
  String get comic_full => 'كامل';

  @override
  String get comic_comfortable => 'مريح';

  @override
  String get comic_narrow => 'ضيق';

  @override
  String get comic_gap => 'تباعد الصفحات';

  @override
  String get comic_no_gap => 'سلس';

  @override
  String get comic_small_gap => 'صغير';

  @override
  String get comic_image_title => 'ضبط الصورة بدقة';

  @override
  String get comic_image_hint => 'يؤثر القص والنغمة على هذا الكتاب فقط.';

  @override
  String get comic_wide => 'صفحات واسعة';

  @override
  String get comic_intact => 'حافظ على كامل';

  @override
  String get comic_split => 'سبليت';

  @override
  String get comic_rotate => 'تدوير';

  @override
  String get comic_wide_hint =>
      'يتبع التقسيم اتجاه قلب الصفحة. ينطبق على قراءة صفحة واحدة.';

  @override
  String get comic_cover => 'غلاف واحد لكل فصل';

  @override
  String get comic_effects_reset => 'إعادة ضبط تعديلات الصورة';

  @override
  String get comic_book_reset => 'استعادة الإعدادات الافتراضية للكتاب';

  @override
  String get comic_book_reset_hint =>
      'مسح إعدادات القراءة المخصصة لهذا الكتاب. الترجمة لم تتغير.';

  @override
  String get comic_canvas => 'خلفية القارئ';

  @override
  String get comic_system => 'النظام';

  @override
  String get comic_black => 'أسود';

  @override
  String get comic_gray => 'رمادي';

  @override
  String get comic_paper => 'ورق';

  @override
  String get comic_tap => 'اضغط لقلب الصفحات';

  @override
  String get comic_tap_hint =>
      'اضغط على الحواف للتحرك؛ اضغط على المركز لإظهار عناصر التحكم.';

  @override
  String get comic_scroll_start => 'بدء التمرير التلقائي';

  @override
  String get comic_scroll_pause => 'إيقاف التمرير التلقائي مؤقتًا';

  @override
  String get comic_scroll_speed => 'سرعة التمرير';

  @override
  String get comic_scroll_hint =>
      'يبدأ عند إغلاق هذه اللوحة. يتوقف مؤقتًا عندما يترك التطبيق المقدمة.';

  @override
  String get comic_save_failed => 'لا يمكن الحفظ. يرجى المحاولة مرة أخرى.';

  @override
  String get comic_reading => 'القراءة';

  @override
  String get comic_chapter_habits_hint =>
      'تنطبق عادات قائمة الفصول على كافة الكتب.';

  @override
  String get browser_title => 'المتصفح';

  @override
  String get translation_image_display => 'عرض الصورة';

  @override
  String get translation_display_hint =>
      'إظهار الترجمات الموجودة أولاً. احتفظ بالأصل في حالة عدم توفر ترجمة.';

  @override
  String get translation_sign_in_required => 'قم بتسجيل الدخول لتمكين الترجمة';

  @override
  String get translation_sign_in_hint =>
      'بعد تسجيل الدخول، قم بالتبديل إلى الصور المترجمة لترجمتها تلقائيًا.';

  @override
  String get translation_automatic => 'الترجمة الآلية';

  @override
  String get translation_original_hint =>
      'عرض النسخ الأصلية. قم بالتبديل إلى الصور المترجمة لترجمتها تلقائيًا.';

  @override
  String get translation_window_hint =>
      'معالجة الصور الحالية والقادمة فقط أثناء عرض الترجمات.';

  @override
  String get translation_channel => 'قناة الترجمة';

  @override
  String get translation_no_images =>
      'لم يتم العثور على صور قابلة للترجمة في هذه الصفحة حتى الآن';

  @override
  String get translation_waiting_image => 'في انتظار الصورة الحالية';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues صورة تحتاج إلى مراجعة',
      many: ' · $issues صورة تحتاج إلى مراجعة',
      few: ' · $issues صور تحتاج إلى مراجعة',
      two: ' · صورتان تحتاجان إلى مراجعة',
      one: ' · صورة واحدة تحتاج إلى مراجعة',
      zero: '',
    );
    return 'الصور المكتملة: $complete / $total$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'المس الصورة مع الاستمرار لمزيد من الإجراءات، بما في ذلك ترجمتها مرة أخرى.';

  @override
  String get translation_title => 'ترجمة المانجا';

  @override
  String get translation_system_sign_in =>
      'قم بتسجيل الدخول باستخدام متصفح النظام الخاص بك';

  @override
  String get translation_target_language => 'اللغة الهدف';

  @override
  String get translation_clear_cache =>
      'مسح ذاكرة التخزين المؤقت للصورة المترجمة';

  @override
  String get translation_cache_hint =>
      'احتفظ بسجلات الترجمة واستخرج النتائج مرة أخرى عند الحاجة.';

  @override
  String get translation_saved_read_failed => 'تعذر تحميل الترجمة المحفوظة';

  @override
  String get translation_read_failed => 'لا يمكن تحميل الصورة المترجمة';

  @override
  String get operation_retry => 'لم ينته الإجراء. يرجى المحاولة مرة أخرى.';

  @override
  String get translation_original => 'الأصل';

  @override
  String get translation_translated => 'مترجم';

  @override
  String get translation_regenerate_image => 'ترجم هذه الصورة مرة أخرى';

  @override
  String get translation_read_image => 'إعادة تحميل الصورة المترجمة';

  @override
  String get translation_image_actions => 'المزيد من إجراءات الصورة';

  @override
  String get translation_processing => 'المعالجة';

  @override
  String get translation_reading => 'تحميل الصورة المترجمة';

  @override
  String get translation_waiting => 'في انتظار الترجمة';

  @override
  String get translation_preparing => 'تحضير الترجمة';

  @override
  String get translation_uploading => 'رفع الأصل';

  @override
  String get translation_running => 'الترجمة';

  @override
  String get translation_uncertain => 'الحالة تحتاج إلى التحقق';

  @override
  String get translation_failed => 'فشلت الترجمة';

  @override
  String get translation_verify => 'التحقق';

  @override
  String get translation_reread => 'إعادة التحميل';

  @override
  String get browser_back => 'العودة';

  @override
  String get browser_translation => 'ترجمة صفحة الويب';

  @override
  String get browser_new_tab_action => 'فتح علامة تبويب جديدة';

  @override
  String get browser_current_tab => 'الحالي';

  @override
  String get browser_close_tab => 'إغلاق علامة التبويب';

  @override
  String get browser_new_tab => 'علامة تبويب جديدة';

  @override
  String get browser_page => 'صفحة ويب';

  @override
  String get browser_unopened => 'لم يتم فتح أي صفحة بعد';

  @override
  String get browser_invalid_address => 'أدخل URL صالحًا';

  @override
  String get browser_clear_address => 'واضح URL';

  @override
  String get browser_paste_address => 'لصق URL';

  @override
  String get browser_open_address => 'مفتوح URL';

  @override
  String browser_tab_count(int count) {
    return 'علامات التبويب · $count';
  }

  @override
  String get browser_load_failed => 'لا يمكن فتح هذه الصفحة';

  @override
  String get browser_load_failed_hint => 'تحقق من اتصالك وURL.';

  @override
  String get browser_edit_address => 'تحرير URL';

  @override
  String get browser_clear_cookies_confirm =>
      'هل تريد مسح جلسات تسجيل الدخول لجميع مواقع الويب؟';

  @override
  String get browser_clear_cookies_hint =>
      'قد تطلب منك مواقع الويب الموجودة في جميع علامات التبويب تسجيل الدخول مرة أخرى.';

  @override
  String get browser_clear_cookies_action => 'مسح جلسات تسجيل الدخول';

  @override
  String get browser_tab_limit =>
      'يمكنك الاحتفاظ بما يصل إلى 12 علامة تبويب مفتوحة. أغلق واحدًا أولاً.';

  @override
  String get browser_forward => 'إلى الأمام';

  @override
  String get browser_clear_all_cookies =>
      'مسح جميع جلسات تسجيل الدخول إلى موقع الويب';

  @override
  String get browser_clear_failed =>
      'لا يمكن مسح الجلسات. يرجى المحاولة مرة أخرى.';

  @override
  String get browser_save_failed =>
      'لا يمكن حفظ علامات التبويب. يرجى المحاولة مرة أخرى.';

  @override
  String get browser_tabs_full => '12 علامة تبويب مفتوحة بالفعل';

  @override
  String get browser_no_tabs => 'لا توجد علامات تبويب مفتوحة بعد';

  @override
  String get browser_close_failed =>
      'تعذر حفظ علامات التبويب. انقر فوق إغلاق مرة أخرى لإعادة المحاولة.';

  @override
  String get source_pinned_websites => 'المواقع المثبتة';

  @override
  String get manage => 'إدارة';

  @override
  String get translation_settings_hint => 'الترجمة الآلية واللغة الهدف والقناة';

  @override
  String get translation_show_original => 'اضغط لإظهار الأصل';

  @override
  String get translation_show_translated => 'اضغط لإظهار الترجمة';

  @override
  String get source_display => 'العرض';

  @override
  String get source_cover_title => 'الغلاف والعنوان';

  @override
  String get source_cover_only => 'الغلاف فقط';

  @override
  String get source_save_search => 'حفظ البحث الحالي';

  @override
  String get source_saved_searches => 'عمليات البحث المحفوظة';

  @override
  String get source_website_info => 'معلومات الموقع';

  @override
  String source_saved_search_title(String title) {
    return '$title · اضغط للبحث';
  }

  @override
  String get action_done => 'تم';

  @override
  String source_search_keyword(String query) {
    return 'الكلمة الأساسية: $query';
  }

  @override
  String get source_no_saved_searches => 'لا توجد عمليات بحث محفوظة حتى الآن';

  @override
  String get source_save_search_hint =>
      'ابحث عن كلمة أساسية، ثم احفظها من إجراءات موقع الويب.';

  @override
  String get source_saved_search_scope =>
      'يتم حفظ الكلمات الأساسية لموقع الويب هذا فقط.';

  @override
  String get source_search_here => 'ابحث عن العناوين في هذا الموقع';

  @override
  String get source_filter_results => 'النتائج التي تمت تصفيتها';

  @override
  String get source_search_results => 'نتائج البحث';

  @override
  String get source_return_popular => 'العودة إلى الشعبية';

  @override
  String get source_popular_titles => 'العناوين الشعبية';

  @override
  String get source_no_titles => 'لم يتم العثور على عناوين مطابقة';

  @override
  String get source_no_titles_hint =>
      'قم بتغيير كلماتك الأساسية أو عوامل التصفية أو العودة إلى العناوين الشائعة.';

  @override
  String get source_load_more_failed =>
      'لا يمكن تحميل المزيد. يرجى المحاولة مرة أخرى.';

  @override
  String get source_load_pull_retry =>
      'تعذر تحميل هذا الموقع. اسحب للأسفل لإعادة المحاولة.';

  @override
  String get source_clear_failed =>
      'لا يمكن إنهاء عملية المسح. يرجى المحاولة مرة أخرى.';

  @override
  String get source_uninstall_failed =>
      'تعذر إنهاء عملية إلغاء التثبيت. يرجى المحاولة مرة أخرى.';

  @override
  String get source_details => 'تفاصيل المصدر';

  @override
  String get source_repository_website => 'موقع المستودع';

  @override
  String get source_provided_settings => 'الإعدادات المقدمة من المصدر';

  @override
  String get source_advanced_actions => 'الإجراءات المتقدمة';

  @override
  String get source_edit_metadata => 'تحرير معلومات المصدر';

  @override
  String get source_clear_cookies => 'مسح ملفات تعريف الارتباط لهذا الموقع';

  @override
  String get source_clear_cookies_hint =>
      'قد تحتاج إلى تسجيل الدخول مرة أخرى في زيارتك القادمة.';

  @override
  String get source_uninstall => 'إلغاء تثبيت المصدر';

  @override
  String get source_settings_save_failed =>
      'لم ينته الحفظ. أعد فتح إعدادات المصدر للتحقق.';

  @override
  String get repository_third_party => 'مستودعات الطرف الثالث';

  @override
  String get repository_refresh_failed =>
      'لا يمكن تحديث الكتالوج. يتم الاحتفاظ بالمحتوى المخزن مؤقتًا. يرجى المحاولة مرة أخرى.';

  @override
  String get repository_show_sources => 'عرض المصادر من هذا المستودع';

  @override
  String get repository_copy_catalog => 'انسخ رابط الكتالوج';

  @override
  String get repository_remove => 'إزالة المستودع';

  @override
  String get repository_remove_hint =>
      'احتفظ بالمصادر المثبتة وقم بإزالة إدخالات الكتالوج التي تم إلغاء تثبيتها.';

  @override
  String get repository_empty =>
      'لم تتم إضافة أي مستودعات تابعة لجهات خارجية حتى الآن';

  @override
  String get repository_built_in => 'الكتالوج الرسمي المدمج';

  @override
  String get repository_hidden => 'مخفي';

  @override
  String get repository_refreshing => 'منعش…';

  @override
  String get repository_refresh => 'تحديث الكتالوج';

  @override
  String get repository_manage_hint =>
      'إدارة المكان الذي يتم تنزيل مصادر الجهات الخارجية منه.';

  @override
  String get repository_invalid_address => 'أدخل HTTP أو HTTPS URL صالحًا';

  @override
  String get repository_already_added => 'تمت إضافة هذا المستودع بالفعل';

  @override
  String get repository_unrecognized =>
      'لم يتم العثور على كتالوج مدعوم. تحقق من الرابط وحاول مرة أخرى.';

  @override
  String get repository_read_failed =>
      'لا يمكن قراءة الكتالوج. يرجى المحاولة مرة أخرى.';

  @override
  String get repository_save_failed =>
      'لم ينته الحفظ. تحقق من قائمة المستودعات الخاصة بك.';

  @override
  String get repository_paste_hint => 'قم بلصق رابط كتالوج مستودع الطرف الثالث';

  @override
  String get repository_address => 'URL';

  @override
  String get repository_paste_link => 'الصق الرابط';

  @override
  String repository_recognized(String type) {
    return '$type · تم التعرف على الكتالوج';
  }

  @override
  String get repository_choose_sources_hint =>
      'بعد إضافة المستودع، اختر المصادر التي تحتاجها.';

  @override
  String get search_scope => 'نطاق البحث';

  @override
  String get search_scope_hint => 'اختيار المواقع المراد البحث فيها';

  @override
  String search_websites_action(int count) {
    return 'البحث في المواقع: $count';
  }

  @override
  String get search_find_website => 'البحث عن موقع على الانترنت';

  @override
  String search_selected_websites(int count) {
    return 'المواقع المحددة: $count';
  }

  @override
  String get action_clear => 'واضح';

  @override
  String get search_deselect_results => 'قم بإلغاء تحديد مواقع الويب المطابقة';

  @override
  String get search_select_results => 'تحديد مواقع الويب المطابقة';

  @override
  String get search_no_websites_hint =>
      'لا توجد مواقع مطابقة. جرّب اسمًا أو لغة أخرى.';

  @override
  String get search_select_website_hint =>
      'حدد موقع ويب واحدًا على الأقل للبحث فيه.';

  @override
  String get search_start_title => 'أدخل الكلمات الأساسية للعثور على العناوين';

  @override
  String get search_start_hint =>
      'ابحث في مواقع ويب متعددة مرة واحدة وأظهر العناوين المتطابقة.';

  @override
  String get search_empty_scope =>
      'لا توجد مواقع ويب قابلة للبحث في هذا النطاق';

  @override
  String get search_empty_scope_hint =>
      'قم بالتبديل إلى كافة مواقع الويب أو اختر مواقع الويب للبحث فيها.';

  @override
  String search_result_count(int count) {
    return 'النتائج: $count';
  }

  @override
  String get search_titles => 'عناوين البحث';

  @override
  String get search_actions => 'إجراءات البحث';

  @override
  String get search_details => 'تفاصيل البحث';

  @override
  String get search_title_hint => 'البحث حسب العنوان';

  @override
  String get search_searching => 'البحث';

  @override
  String search_found_results(int count) {
    return 'عدد النتائج التي تم العثور عليها: $count';
  }

  @override
  String get search_no_results => 'لا توجد نتائج مطابقة';

  @override
  String get search_failed => 'فشل البحث';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم العثور على عناوين $count',
      one: 'تم العثور على عنوان واحد',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: '$websites مواقع الويب',
      one: 'موقع واحد',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'البحث عن العناوين';

  @override
  String get search_complete => 'اكتمل البحث';

  @override
  String get search_in_progress => 'البحث';

  @override
  String get search_finding_related => 'البحث عن العناوين المطابقة...';

  @override
  String get search_no_results_yet => 'لا توجد نتائج بحث بعد';

  @override
  String get search_no_matching_titles => 'لم يتم العثور على عناوين مطابقة';

  @override
  String get search_results_appear_hint =>
      'ستظهر النتائج هنا كما تم العثور عليها.';

  @override
  String get search_failed_websites_hint =>
      'لم تتمكن بعض مواقع الويب من إنهاء البحث. أعد المحاولة في تفاصيل البحث.';

  @override
  String get search_change_keywords_hint =>
      'جرّب كلمات رئيسية أقصر أو ابحث في المزيد من مواقع الويب.';

  @override
  String get search_view_details => 'عرض تفاصيل البحث';

  @override
  String get search_adjust_scope => 'ضبط نطاق البحث';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مواقع الويب',
      one: 'موقع واحد',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'مكتمل $completed / $total';
  }

  @override
  String get search_retry_website_hint =>
      'أعد محاولة مواقع الويب الفاشلة بشكل فردي';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم تحديد $count عنصر',
      many: 'تم تحديد $count عنصرًا',
      few: 'تم تحديد $count عناصر',
      two: 'تم تحديد عنصرين',
      one: 'تم تحديد عنصر واحد',
      zero: 'لم يتم تحديد أي عناصر',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'لغات البحث';

  @override
  String get source_deselect => 'قم بإلغاء التحديد';

  @override
  String get source_select => 'حدد المصدر';

  @override
  String get source_multilingual => 'متعدد اللغات';

  @override
  String get source_language_unknown => 'اللغة غير محددة';

  @override
  String get source_adult_content => 'يحتوي على أكثر من 18 محتوى';

  @override
  String get source_classification_unknown => 'التصنيف غير محدد';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عرض كافة معلومات المصدر، $count المزيد من الفئات',
      one: 'عرض كافة معلومات المصدر، فئة واحدة إضافية',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'تحميل الموقع';

  @override
  String get source_unpin => 'إلغاء التثبيت';

  @override
  String get source_pin => 'دبوس';

  @override
  String get source_open => 'مفتوح';

  @override
  String get source_metadata_hint =>
      'تأتي المعلومات من كتالوج المصدر. تصف الفئات المحتوى الذي يغطيه الموقع.';

  @override
  String get source_region => 'المنطقة';

  @override
  String get source_format => 'التنسيق';

  @override
  String get source_creation => 'الخلق';

  @override
  String get source_unspecified => 'غير محدد';

  @override
  String get source_pricing => 'التسعير';

  @override
  String get source_region_jp => 'القصص المصورة اليابانية';

  @override
  String get source_region_kr => 'القصص المصورة الكورية';

  @override
  String get source_region_cn => 'القصص المصورة الصينية';

  @override
  String get source_region_hk_tw => 'كاريكاتير هونج كونج وتايوان';

  @override
  String get source_region_western => 'القصص المصورة الغربية';

  @override
  String get source_region_other => 'مناطق أخرى';

  @override
  String get source_format_page => 'صفحات كاريكاتورية';

  @override
  String get source_format_vertical => 'كاريكاتير عمودي';

  @override
  String get source_format_strip => 'القصص المصورة';

  @override
  String get source_creation_original => 'الأصل';

  @override
  String get source_creation_fan => 'تعمل المروحة';

  @override
  String get source_free_watch => 'المشاهدة مجانية';

  @override
  String get source_free_read => 'حرية القراءة';

  @override
  String get source_partial_paid => 'مدفوع جزئيًا';

  @override
  String get source_paid_watch => 'المشاهدة مدفوعة الأجر';

  @override
  String get source_paid_read => 'القراءة المدفوعة';

  @override
  String get source_pricing_unknown => 'التسعير غير محدد';

  @override
  String get source_language_filter => 'التصفية حسب اللغة';

  @override
  String get source_language_filter_hint =>
      'قم بتصفية هذا الكتالوج فقط. المصادر المثبتة لا تتأثر.';

  @override
  String get source_all_languages => 'جميع اللغات';

  @override
  String get action_apply => 'التقديم';

  @override
  String get source_load_retry =>
      'تعذر تحميل هذا الموقع. يرجى المحاولة مرة أخرى.';

  @override
  String get source_catalog_refresh_failed =>
      'لا يمكن تحديث الكتالوج. يتم الاحتفاظ بالمحتوى الحالي. اسحب للأسفل لإعادة المحاولة.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إلغاء تثبيت مصادر $count؟',
      one: 'إلغاء تثبيت مصدر واحد؟',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'قم بإلغاء تثبيت المصادر المحددة ومسح إعداداتها. احتفظ بعناوين المكتبة وتنزيلاتها.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'فشلت الإجراءات لمصادر $count.',
      one: 'فشل الإجراء لمصدر واحد.',
    );
    return '$_temp0 تم الاحتفاظ بالاختيار. يرجى المحاولة مرة أخرى.';
  }

  @override
  String get source_latest_content => 'أحدث المحتوى';

  @override
  String get source_actions => 'إجراءات المصدر';

  @override
  String get source_bulk_manage => 'إدارة مصادر متعددة';

  @override
  String get source_update_installed => 'تحديث المصادر المثبتة';

  @override
  String get source_no_matching_websites => 'لا توجد مواقع مطابقة';

  @override
  String get source_no_websites => 'لا توجد مواقع متاحة';

  @override
  String get source_search_installed_hint =>
      'البحث عن العناوين في المصادر المثبتة';

  @override
  String get source_global_search => 'البحث عبر المصادر';

  @override
  String get source_manage_repositories => 'إدارة المستودعات';

  @override
  String get source_view_third_party => 'عرض مصادر الطرف الثالث';

  @override
  String get source_catalog_load_failed =>
      'تعذر تحميل الكتالوج. اسحب للأسفل لإعادة المحاولة.';

  @override
  String get source_all_websites => 'جميع المواقع';

  @override
  String get source_available => 'متاح للتثبيت';

  @override
  String get source_third_party => 'الطرف الثالث';

  @override
  String get source_name_or_title => 'اسم الموقع أو عنوانه';

  @override
  String get view_all => 'عرض الكل';

  @override
  String get search_searching_ellipsis => 'البحث...';

  @override
  String onboarding_untested_content(String type) {
    return '$type · لم يتم اختباره';
  }

  @override
  String get onboarding_untested => 'لم يتم اختباره';

  @override
  String get source_custom_scope => 'مخصص';

  @override
  String get source_custom_websites => 'مواقع مختارة';

  @override
  String get tv_hidden_library_hint =>
      'يقع كل عنوان في فئة مخفية.\nاضغط باستمرار على \"الكل\" لإظهار أحد العناصر.';

  @override
  String get tv_no_matching_anime => 'لا يوجد أنمي مطابق';

  @override
  String tv_no_matching_category(String category) {
    return 'لا يوجد أنمي مطابق في “$category”';
  }

  @override
  String get tv_filtered_empty_hint =>
      'لا يوجد أنمي يطابق المرشحات الحالية.\nقم بتغييرها من الزر الموجود بجانب البحث.';

  @override
  String get tv_new_episodes => 'حلقات جديدة';

  @override
  String get tv_recently_added => 'أضيفت مؤخرا';

  @override
  String get tv_empty_category_hint =>
      'لا يوجد أنمي في هذه الفئة حتى الآن.\nأضف عناوين إليه من صفحة تفاصيل العنوان.';

  @override
  String get tv_empty_library => 'مكتبة الأنمي الخاصة بك فارغة';

  @override
  String get tv_empty_library_hint => 'أضف أنيمي من التصفح لملء منزلك';

  @override
  String get tv_browse_anime => 'تصفح الانمي';

  @override
  String tv_new_count(int count) {
    return '$count جديد';
  }

  @override
  String tv_category_hidden(String category) {
    return 'اختبأ \"$category\" · استمر في الضغط على \"موافق\" على \"الكل\" لإظهاره';
  }

  @override
  String get tv_no_hidden_categories => 'لا توجد فئات مخفية';

  @override
  String get import_torrent_file => 'استيراد ملف تورنت';

  @override
  String get import_video_formats => '.mp4، .mkv، .avi، والمزيد';

  @override
  String get cloudflare_proxy_optional => 'اختياري FlareSolverr / Byparr URL';

  @override
  String get tv_home_layout_hint =>
      'صفحة الأنمي الرئيسية القائمة على الصفوف (تابع · حلقات جديدة · الفئات) بدلاً من الشبكة المسطحة';

  @override
  String get tv_hide_libraries_hint =>
      'إخفاء مكتبات المانجا والروايات (يتم تشغيلها افتراضيًا على التلفزيون)';

  @override
  String get anime_only_hint =>
      'إخفاء المانجا والرواية عبر التطبيق. إيقاف لإظهار كل شيء.';

  @override
  String get audio_auto_safe => 'آمن تلقائي';

  @override
  String get tv_player_hint =>
      'تشغيل: مشغل تلفزيون مخصص.  مطفأ: مشغل أصلي (سطح المكتب).';

  @override
  String get release_open_failed => 'غير قادر على فتح الإصدار';

  @override
  String get tv_replay => 'إعادة التشغيل';

  @override
  String get tv_no_episodes => 'لا توجد حلقات بعد';

  @override
  String get tracker_continue_series => 'متابعة مشاهدة المسلسل';

  @override
  String get tracker_watchlist_series => 'سلسلة قائمة المراقبة';

  @override
  String get tracker_continue_movies => 'متابعة مشاهدة الأفلام';

  @override
  String get tracker_watchlist_movies => 'قائمة مشاهدة الأفلام';

  @override
  String get tracker_trending_series => 'السلسلة الشائعة';

  @override
  String get tracker_trending_movies => 'الأفلام الرائجة';

  @override
  String get tracker_popular_series => 'السلسلة الشعبية';

  @override
  String get tracker_popular_movies => 'الأفلام الشعبية';

  @override
  String get tracker_top_series => 'أفضل سلسلة (كل العصور)';

  @override
  String get tracker_top_movies => 'أفضل الأفلام (كل العصور)';

  @override
  String get tracker_airing_series => 'سلسلة البث';

  @override
  String get tracker_airing_anime => 'بث الأنمي';

  @override
  String get tracker_popular_anime => 'الرسوم المتحركة الشعبية';

  @override
  String get tracker_upcoming_anime => 'الأنمي القادم';

  @override
  String get tracker_popular_manga => 'المانغا الشعبية';

  @override
  String get tracker_top_manga => 'أعلى المانجا';

  @override
  String get tracker_top_manhwa => 'توب مانهوا';

  @override
  String get tracker_top_manhua => 'توب مانهوا';

  @override
  String get tracker_latest_anime => 'أحدث الأنمي';

  @override
  String get tracker_best_anime => 'أفضل الأنمي تقييمًا';

  @override
  String get tracker_latest_manga => 'أحدث المانجا';

  @override
  String get tracker_best_manga => 'أفضل تصنيف للمانجا';

  @override
  String get tracker_trending_anime => 'الأنمي الرائج';

  @override
  String get tracker_upcoming_manga => 'المانجا القادمة';

  @override
  String get tracker_trending_manga => 'المانجا الرائجة';

  @override
  String selection_progress(int selected, int total) {
    return '$selected/$total محدد';
  }

  @override
  String get source_code_editor => 'محرر الكود';

  @override
  String get source_code_execute => 'تنفيذ';

  @override
  String get source_console_logs => 'سجلات وحدة التحكم';

  @override
  String get source_no_logs => 'لا توجد سجلات حتى الآن';

  @override
  String get source_updated_successfully => 'تم تحديث المصدر بنجاح';

  @override
  String get source_obsolete => 'عفا عليه الزمن';

  @override
  String player_seek_forward_seconds(int seconds) {
    return 'تقدم للأمام $seconds ثانية';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return 'البحث للخلف بمقدار $seconds ثانية';
  }

  @override
  String get player_autoplay_on => 'التشغيل التلقائي للحلقة التالية: تشغيل';

  @override
  String get player_autoplay_off => 'التشغيل التلقائي للحلقة التالية: متوقف';

  @override
  String get player_no_other_quality => 'لا توجد نوعية أخرى';

  @override
  String get player_no_subtitles => 'لا توجد ترجمة';

  @override
  String get player_no_audio_tracks => 'لا توجد مسارات صوتية';

  @override
  String get player_seek_forward => 'السعي للأمام';

  @override
  String get player_seek_backward => 'البحث للخلف';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds ثانية',
      many: '$seconds ثانية',
      few: '$seconds ثوانٍ',
      two: 'ثانيتان',
      one: 'ثانية واحدة',
      zero: '$seconds ثانية',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'لوريم إيبسوم دولور يجلس أميت';

  @override
  String get subtitle_style => 'النمط';

  @override
  String get translation_official_channel => 'NodeLane رسمي';

  @override
  String get translation_auth_required =>
      'قم بتسجيل الدخول إلى حساب الترجمة الخاص بك أولاً.';

  @override
  String get translation_source_changed =>
      'تم تغيير الصورة الأصلية. يرجى إعادة تحميله.';

  @override
  String get translation_source_missing => 'الصورة الأصلية غير متوفرة حاليًا.';

  @override
  String get translation_resource_limit =>
      'هذه الصورة تتجاوز حد معالجة الجهاز. يتم الاحتفاظ بالأصل.';

  @override
  String get translation_storage_full =>
      'مساحة تخزين الترجمة ممتلئة. مسح الصور المترجمة أولا.';

  @override
  String get translation_invalid_image => 'تنسيق الصورة أو المحتوى غير صالح.';

  @override
  String get translation_unsupported_image =>
      'الترجمة غير مدعومة لهذه الصورة. يتم الاحتفاظ بالأصل.';

  @override
  String get translation_invalid_result =>
      'فشل التحقق من صحة الصورة المترجمة. يرجى إعادة تحميله.';

  @override
  String get translation_result_unavailable =>
      'الصورة المترجمة غير متوفرة. يرجى إعادة تحميله.';

  @override
  String get translation_result_expired =>
      'انتهت صلاحية الصورة المترجمة. يرجى ترجمتها مرة أخرى.';

  @override
  String get translation_analysis_too_large =>
      'يوجد قدر كبير جدًا من محتوى الصورة الذي يتعين تحليله. قلل حجم الصورة وحاول مرة أخرى.';

  @override
  String get translation_region_limit =>
      'تحتوي الصورة على عدد كبير جدًا من مناطق النص. قم بتقسيمها وحاول مرة أخرى.';

  @override
  String get translation_text_limit =>
      'منطقة النص طويلة جدًا. اضبط الصورة وحاول مرة أخرى.';

  @override
  String get translation_unavailable => 'هذه الترجمة لم تعد متوفرة.';

  @override
  String get translation_outcome_unknown =>
      'النتيجة تحتاج إلى التحقق. لم يتم إعادة تقديمه.';

  @override
  String get translation_rate_limited =>
      'الطلبات محدودة. سيتم استئناف الترجمة تلقائيًا.';

  @override
  String get translation_quota_exhausted => 'حصة الترجمة غير كافية.';

  @override
  String get translation_unsupported_language =>
      'الخدمة لا تدعم هذه اللغة الهدف.';

  @override
  String get translation_upgrade_required =>
      'بروتوكول الترجمة غير متوافق. قم بتحديث التطبيق.';

  @override
  String get translation_remote_failed =>
      'فشلت الترجمة لهذه الصفحة. يمكنك إعادة المحاولة يدويًا.';

  @override
  String get translation_bridge_invalid =>
      'تم تغيير صفحة الويب. تمكين الترجمة مرة أخرى.';

  @override
  String get translation_connection_failed =>
      'فشل الاتصال. يرجى المحاولة مرة أخرى.';

  @override
  String get translation_paused =>
      'توقفت الترجمة مؤقتًا. يمكنك التحقق من تقدمها.';

  @override
  String get translation_preparing_ellipsis => 'جارٍ تحضير الترجمة…';

  @override
  String get translation_checking_original =>
      'جارٍ التحقق من الصورة الأصلية...';

  @override
  String get translation_submitting => 'تقديم...';

  @override
  String get translation_uploading_ellipsis => 'جاري رفع الأصل...';

  @override
  String get translation_waiting_ellipsis => 'في انتظار الترجمة...';

  @override
  String get translation_running_ellipsis => 'ترجمة…';

  @override
  String get translation_verify_result => 'النتيجة تحتاج إلى التحقق';

  @override
  String get translation_partial => 'تمت ترجمة بعض المحتوى';

  @override
  String get translation_ready => 'الصورة المترجمة جاهزة';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'العب';

  @override
  String get player_quality => 'الجودة';

  @override
  String get player_subtitles => 'الترجمة';

  @override
  String get player_audio => 'الصوت';

  @override
  String get player_statistics => 'إحصائيات المهووسين';

  @override
  String get player_auto => 'تلقائي';

  @override
  String get source_information => 'معلومات المصدر';

  @override
  String get source_code_page => 'الصفحة';

  @override
  String get source_code_query => 'الاستعلام';

  @override
  String get repository_invalid_source => 'مصدر غير صالح - قم بإزالته';

  @override
  String get player_fit_contain => 'احتواء';

  @override
  String get player_fit_cover => 'الغلاف';

  @override
  String get player_fit_fill => 'تعبئة';

  @override
  String get player_fit_height => 'الارتفاع';

  @override
  String get player_fit_width => 'العرض';

  @override
  String get player_fit_scale => 'مقياس';

  @override
  String get player_fit_none => 'لا شيء';

  @override
  String get player_shader_clear => 'إيقاف (تظليل واضح)';

  @override
  String get player_shader_luma => 'ترقية لوما';

  @override
  String get player_decoder_auto => 'تلقائي (الأجهزة)';

  @override
  String get player_decoder_software => 'البرامج (بدون أجهزة)';

  @override
  String get player_stats_toggle => 'تبديل التراكب';

  @override
  String get player_stats_general => 'عام';

  @override
  String get player_stats_frames => 'توقيتات الإطار';

  @override
  String get player_stats_cache => 'ذاكرة التخزين المؤقت للإدخال';

  @override
  String get player_stats_filters => 'المرشحات النشطة';

  @override
  String get player_stats_log => 'السجل';

  @override
  String get source_mark_pinned => 'دبوس';

  @override
  String translation_image_action(String action) {
    return '$action هذه الصورة';
  }

  @override
  String get memory_waiting => 'الذاكرة: في انتظار العينة';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current الذروة $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'ذاكرة التخزين المؤقت $current / $limit الذروة $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'العناصر $count / $limit مباشر $live الذروة $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count العينات',
      one: 'عينة واحدة',
    );
    return 'كامل $percent% من $_temp0';
  }

  @override
  String get memory_reset_hint =>
      'قم بتبديله وتشغيله في الإعدادات لإعادة التعيين';

  @override
  String get action_hide => 'إخفاء';

  @override
  String discord_get_app(String app) {
    return 'احصل على $app';
  }

  @override
  String get discord_idle => 'خاملاً';

  @override
  String discord_watching_title(String title) {
    return 'مشاهدة $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'القراءة $title';
  }
}
