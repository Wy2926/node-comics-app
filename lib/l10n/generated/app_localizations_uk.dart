// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get app_update_details_hint =>
      'Переглянути примітки до випуску та параметри встановлення';

  @override
  String get app_update_download => 'Завантажити оновлення';

  @override
  String get app_update_download_hint =>
      'Після завантаження дотримуйтесь підказок, щоб установити оновлення.';

  @override
  String get bookshelf_all => 'Всі';

  @override
  String get bookshelf_search => 'Пошукова бібліотека';

  @override
  String get app_update_allow_install =>
      'Дозвольте встановлення програми в налаштуваннях системи, потім поверніться та торкніться «Встановити».';

  @override
  String get app_update_waiting =>
      'Очікування, поки система відновить завантаження…';

  @override
  String get app_update_cancel_download => 'Скасувати завантаження';

  @override
  String get app_update_remove_package => 'Видалити завантажений пакет';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'Немає відповідних налаштувань';

  @override
  String get search_empty_hint =>
      'Спробуйте інше ключове слово або очистіть пошук, щоб побачити все.';

  @override
  String get search_clear => 'Очистити пошук';

  @override
  String get app_updates => 'Оновлення програми';

  @override
  String get app_update_auto => 'Перевірка при запуску';

  @override
  String get app_update_view => 'Переглянути оновлення';

  @override
  String get app_update_later => 'Пізніше';

  @override
  String get app_update_external_hint =>
      'Відкриває посилання на оновлення у вашому браузері';

  @override
  String get app_update_failed =>
      'Не вдалося перевірити наявність оновлень. Спробуйте ще раз.';

  @override
  String get app_update_opened => 'Відкрито посилання на оновлення';

  @override
  String get app_diagnostics => 'Діагностика та журнали';

  @override
  String get library => 'Бібліотека';

  @override
  String get updates_search => 'Оновлення пошуку';

  @override
  String get updates => 'Оновлення';

  @override
  String get history => 'Історія';

  @override
  String get browse => 'Огляд';

  @override
  String get more => 'Більше';

  @override
  String get open_random_entry => 'Відкрити випадковий запис';

  @override
  String get import => 'Імпорт';

  @override
  String get filter => 'Фільтр';

  @override
  String get ignore_filters => 'Ігнорувати фільтри';

  @override
  String get downloaded => 'Завантажено';

  @override
  String get unread => 'Не прочитано';

  @override
  String get unwatched => 'Непереглянуто';

  @override
  String get started => 'Розпочато';

  @override
  String get bookmarked => 'Додано в закладки';

  @override
  String get sort => 'Сортувати';

  @override
  String get alphabetically => 'За алфавітом';

  @override
  String get last_read => 'Останнє прочитання';

  @override
  String get last_watched => 'Останній перегляд';

  @override
  String get last_update_check => 'Перевірка останнього оновлення';

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
          'Ви видаляєте всі $count $entryTypePlural цього $mediaType з бібліотеки.',
      one: 'Ви видаляєте лише $entryType з цього $mediaType з бібліотеки.',
    );
    return '$_temp0\nЦе також видалить весь $mediaType з вашої бібліотеки.\n\nПримітка: Самі файли не будуть видалені.';
  }

  @override
  String get chapter => 'розділ';

  @override
  String get episode => 'епізод';

  @override
  String get unread_count => 'Кількість непрочитаних';

  @override
  String get unwatched_count => 'Неперевірена кількість';

  @override
  String get latest_chapter => 'Останній розділ';

  @override
  String get latest_episode => 'Останній епізод';

  @override
  String get date_added => 'Дата додана';

  @override
  String get display => 'Дисплей';

  @override
  String get display_mode => 'Режим відображення';

  @override
  String get compact_grid => 'Компактна сітка';

  @override
  String get compression_level => 'Рівень стиснення';

  @override
  String compression_info(Object level) {
    return 'Чим вище стиснення, тим менше місця займає файл резервної копії, але він використовує більше ЦП. За замовчуванням: $level';
  }

  @override
  String get comfortable_grid => 'Зручна сітка';

  @override
  String get cover_only_grid => 'Сітка лише для покриття';

  @override
  String get list => 'Список';

  @override
  String get badges => 'Значки';

  @override
  String get downloaded_chapters => 'Завантажені розділи';

  @override
  String get downloaded_episodes => 'Завантажені епізоди';

  @override
  String get language => 'Мова';

  @override
  String get local_source => 'Місцеве джерело';

  @override
  String get tabs => 'Вкладки';

  @override
  String get show_category_tabs => 'Показати вкладки категорії';

  @override
  String get show_numbers_of_items => 'Показати кількість предметів';

  @override
  String get other => 'Інше';

  @override
  String get show_continue_reading_buttons =>
      'Показати кнопки продовження читання';

  @override
  String get show_continue_watching_buttons =>
      'Показати кнопки продовження перегляду';

  @override
  String get empty_library => 'Порожня бібліотека';

  @override
  String get search => 'Пошук...';

  @override
  String get no_recent_updates => 'Немає останніх оновлень';

  @override
  String get remove_everything => 'Видалити все';

  @override
  String get remove_everything_msg => 'Ви впевнені? Вся історія буде втрачена';

  @override
  String get remove_all_update_msg =>
      'Ви впевнені? Усе оновлення буде видалено';

  @override
  String get ok => 'Добре';

  @override
  String get cancel => 'Скасувати';

  @override
  String get remove => 'Видалити';

  @override
  String get remove_history_msg =>
      'Це видалить дату читання цієї глави. Ви впевнені?';

  @override
  String get last_used => 'Останнє використання';

  @override
  String get pinned => 'Прикріплений';

  @override
  String get sources => 'Джерела';

  @override
  String get install => 'Встановити';

  @override
  String get update => 'Оновлення';

  @override
  String get latest => 'Останній';

  @override
  String get extensions => 'Розширення';

  @override
  String get migrate => 'Мігрувати';

  @override
  String get mass_migration_title => 'Масова міграція';

  @override
  String get mass_migration_preview_items => 'Елементи попереднього перегляду';

  @override
  String get mass_migration_destination_source => 'Джерело призначення';

  @override
  String get mass_migration_no_library_items =>
      'Немає елементів бібліотеки, доступних для масової міграції.';

  @override
  String get mass_migration_no_destination_sources =>
      'Немає встановлених джерел призначення.';

  @override
  String get mass_migration_installed => 'Встановлено';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count елементів, готових до перегляду',
      one: '1 елемент готовий до перегляду',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count предметів',
      one: '1 шт',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Виберіть джерело призначення';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Пошук збігів у $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Обробка елемента $current з $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Очікування 2 секунд перед наступним елементом...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Очікування 2 секунд перед наступною міграцією...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'На даний момент знайдено: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Немає відповідності: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Перегляд збігів для $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Знайдено збігів: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Немає збігів: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Вибрано для міграції: $count';
  }

  @override
  String get mass_migration_finish_review => 'Закінчити огляд';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Перенести вибрані елементи ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Перенесення вибраних елементів до $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Для міграції не вибрано елементів.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Перенесення елемента $current з $total';
  }

  @override
  String get mass_migration_complete => 'Масова міграція завершена';

  @override
  String get mass_migration_complete_success_message =>
      'Усі вибрані елементи успішно оброблено.';

  @override
  String get mass_migration_complete_partial_message =>
      'Перенесення завершено з кількома елементами, які все ще потребують ручної обробки.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Оброблено';

  @override
  String get mass_migration_matched => 'Збіг';

  @override
  String get mass_migration_migrated => 'Мігрували';

  @override
  String get mass_migration_skipped => 'Пропущено';

  @override
  String get mass_migration_failed => 'Помилка';

  @override
  String get mass_migration_failed_items => 'Невдалі елементи';

  @override
  String get mass_migration_exit => 'Вихід з масової міграції';

  @override
  String get mass_migration_no_destination_match => 'Немає збігів призначення';

  @override
  String mass_migration_query(Object query) {
    return 'Запит: $query';
  }

  @override
  String get mass_migration_skip => 'Пропустити';

  @override
  String get mass_migration_loading => 'Завантаження...';

  @override
  String get mass_migration_choose_another_result => 'Виберіть інший результат';

  @override
  String get mass_migration_source_chapters => 'Вихідні розділи';

  @override
  String get mass_migration_destination_chapters => 'Розділи призначення';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count розділів',
      one: '1 розділ',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вихідні розділи',
      one: '1 розділ джерела',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count розділи призначення',
      one: '1 розділ призначення',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Розділів не знайдено.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'І ще $count...';
  }

  @override
  String get mass_migration_unknown_title => 'Невідома назва';

  @override
  String get mass_migration_unknown_match => 'Невідомий збіг';

  @override
  String get mass_migration_unknown_source => 'Невідоме джерело';

  @override
  String get mass_migration_unknown_chapter => 'Невідомий розділ';

  @override
  String get migrate_confirm => 'Перехід до іншого джерела';

  @override
  String get clean_database => 'Чиста база даних';

  @override
  String cleaned_database(Object x) {
    return 'Базу даних очищено! Видалено $x записів';
  }

  @override
  String get clean_database_desc =>
      'Це видалить усі елементи, які не додано до бібліотеки!';

  @override
  String get incognito_mode => 'Режим анонімного перегляду';

  @override
  String get incognito_mode_description => 'Призупиняє читання історії';

  @override
  String get downloaded_only => 'Лише завантажено';

  @override
  String get downloaded_only_description =>
      'Показувати лише завантажені записи у вашій бібліотеці';

  @override
  String get download_queue => 'Черга завантаження';

  @override
  String get categories => 'Категорії';

  @override
  String get statistics => 'Статистика';

  @override
  String get settings => 'Налаштування';

  @override
  String get about => 'Про';

  @override
  String get help => 'Допомога';

  @override
  String get no_downloads => 'Немає завантажень';

  @override
  String get edit_categories => 'Редагувати категорії';

  @override
  String get edit_categories_description =>
      'У вас немає категорій. Торкніться кнопки з плюсом, щоб створити її для організації вашої бібліотеки';

  @override
  String get add => 'Додати';

  @override
  String get add_category => 'Додати категорію';

  @override
  String get name => 'Ім\'я';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Обов\'язково';

  @override
  String get add_category_error_exist => 'Категорія з такою назвою вже існує!';

  @override
  String get delete_category => 'Видалити категорію';

  @override
  String delete_category_msg(Object name) {
    return 'Ви бажаєте видалити категорію $name?';
  }

  @override
  String get rename_category => 'Перейменувати категорію';

  @override
  String get general => 'Загальне';

  @override
  String get general_subtitle => 'Мова програми';

  @override
  String get app_language => 'Мова програми';

  @override
  String get default_subtitle_language => 'Мова субтитрів за замовчуванням';

  @override
  String get appearance => 'Зовнішній вигляд';

  @override
  String get appearance_subtitle => 'Тема, формат дати й часу';

  @override
  String get theme => 'Тема';

  @override
  String get dark_mode => 'Темний режим';

  @override
  String get follow_system_theme => 'Дотримуйтеся системної теми';

  @override
  String get on => 'Увімкнено';

  @override
  String get off => 'Вимкнено';

  @override
  String get pure_black_dark_mode => 'Чистий чорний темний режим';

  @override
  String get timestamp => 'Мітка часу';

  @override
  String get relative_timestamp => 'Відносна позначка часу';

  @override
  String get relative_timestamp_short => 'Короткий (сьогодні, вчора)';

  @override
  String get relative_timestamp_long => 'Довгий (Короткий+, n днів тому)';

  @override
  String get date_format => 'Формат дати';

  @override
  String get reader => 'Читач';

  @override
  String get refresh => 'Оновити';

  @override
  String get reader_subtitle => 'Режим читання, дисплей, навігація';

  @override
  String get default_reading_mode => 'Режим читання за замовчуванням';

  @override
  String get reading_mode_vertical => 'Вертикальний';

  @override
  String get reading_mode_horizontal => 'Горизонтальний';

  @override
  String get reading_mode_left_to_right => 'Зліва направо';

  @override
  String get reading_mode_right_to_left => 'Справа наліво';

  @override
  String get reading_mode_vertical_continuous => 'Вертикальний безперервний';

  @override
  String get reading_mode_webtoon => 'Мультфільм';

  @override
  String get double_tap_animation_speed =>
      'Швидкість анімації подвійним дотиком';

  @override
  String get normal => 'Нормальний';

  @override
  String get fast => 'Швидко';

  @override
  String get no_animation => 'Без анімації';

  @override
  String get animate_page_transitions => 'Анімація переходів сторінок';

  @override
  String get crop_borders => 'Межі кадрування';

  @override
  String get downloads => 'Завантаження';

  @override
  String get downloads_subtitle => 'Налаштування завантажень';

  @override
  String get download_location => 'Місце завантаження';

  @override
  String get custom_location => 'Спеціальне розташування';

  @override
  String get only_on_wifi => 'Тільки по wifi';

  @override
  String get save_as_cbz_archive => 'Зберегти як архів CBZ';

  @override
  String get delete_download_after_reading =>
      'Видалити завантаження після прочитання';

  @override
  String get concurrent_downloads => 'Паралельні завантаження';

  @override
  String get browse_subtitle => 'Джерела, глобальний пошук';

  @override
  String get only_include_pinned_sources => 'Включати лише закріплені джерела';

  @override
  String get nsfw_sources => 'NSFW (+18) джерел';

  @override
  String get nsfw_sources_show => 'Показати в джерелах і списках розширень';

  @override
  String get nsfw_sources_info =>
      'Це не заважає неофіційним або потенційно неправильно позначеним розширенням відображати вміст NSFW (18+) у програмі';

  @override
  String get version => 'Version';

  @override
  String beta_version(Object version) {
    return 'Бета ($version)';
  }

  @override
  String get check_for_update => 'Перевірте наявність оновлень';

  @override
  String get logs_on => 'Увімкнути журналювання';

  @override
  String get share_app_logs => 'Поділитися журналами програм';

  @override
  String get no_app_logs => 'Немає log.txt!';

  @override
  String get failed => 'Не вдалося!';

  @override
  String n_days_ago(Object days) {
    return '$days днів тому';
  }

  @override
  String get today => 'Сьогодні';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get a_week_ago => 'Тиждень тому';

  @override
  String get next_week => 'Наступного тижня';

  @override
  String get add_to_library => 'Додати до бібліотеки';

  @override
  String get completed => 'Completed';

  @override
  String get ongoing => 'Триває';

  @override
  String get on_hiatus => 'На перерві';

  @override
  String get canceled => 'Скасовано';

  @override
  String get publishing_finished => 'Видання завершено';

  @override
  String get unknown => 'Невідомо';

  @override
  String get empty_placeholder => 'EMPTY\nMPTY\nMTY\nMT\n\n';

  @override
  String get error => 'Помилка';

  @override
  String error_with_message(Object error) {
    return 'Помилка: $error';
  }

  @override
  String get no_pages_available => 'Помилка: немає доступних сторінок';

  @override
  String get set_categories => 'Встановити категорії';

  @override
  String get edit => 'Edit';

  @override
  String get in_library => 'У бібліотеці';

  @override
  String get filter_scanlator_groups => 'Групи сканатора фільтрів';

  @override
  String get reset => 'Скидання';

  @override
  String get by_source => 'За джерелом';

  @override
  String get by_chapter_number => 'За номером глави';

  @override
  String get by_episode_number => 'За номером епізоду';

  @override
  String get by_upload_date => 'За датою завантаження';

  @override
  String get source_title => 'Назва джерела';

  @override
  String get create_extension => 'Створити розширення';

  @override
  String get developer_mode => 'Режим розробника';

  @override
  String get developer_mode_subtitle =>
      'Показати інструменти розробника розширень (створити розширення, редагувати код)';

  @override
  String get choose_extension_language => 'Виберіть мову розширення';

  @override
  String get lang => 'Ланг';

  @override
  String get base_url => 'BaseUrl';

  @override
  String get api_url_optional => 'ApiUrl (необов’язково)';

  @override
  String get icon_url => 'iconUrl';

  @override
  String get source_icon_url => 'URL-адреса значка джерела';

  @override
  String get notes => 'примітки';

  @override
  String get extension_name_example => 'наприклад: myAnime';

  @override
  String get language_code_example => 'наприклад: en';

  @override
  String get base_url_example => 'наприклад: https://example.com';

  @override
  String get api_url_example => 'наприклад: https://api.example.com';

  @override
  String get extension_notes_example => 'напр.: це розширення потребує входу';

  @override
  String get type => 'Тип';

  @override
  String get target => 'Ціль';

  @override
  String get source_type_single => 'одинарний';

  @override
  String get source_type_multi => 'multi';

  @override
  String get source_type_torrent => 'торрент';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader зібрав JS';

  @override
  String get source_created_successfully => 'Джерело створено успішно';

  @override
  String get source_already_exists => 'Джерело вже існує';

  @override
  String get error_when_creating_source => 'Помилка під час створення джерела';

  @override
  String get cookies_deleted => 'Файли cookie видалено!';

  @override
  String get delete_all_cookies => 'Видалити всі файли cookie';

  @override
  String get chapter_number => 'Номер розділу';

  @override
  String get episode_number => 'Номер епізоду';

  @override
  String get share => 'Share';

  @override
  String n_chapters(Object n) {
    return '$n розділів';
  }

  @override
  String missing_chapters(Object count) {
    return 'Відсутні $count розділи';
  }

  @override
  String get no_description => 'Без опису';

  @override
  String get resume => 'Резюме';

  @override
  String get read => 'Read';

  @override
  String get watch => 'Дивитися';

  @override
  String get popular => 'Популярний';

  @override
  String get open_in_browser => 'Відкрити в браузері';

  @override
  String get clear_cookie => 'Очистити cookie';

  @override
  String get show_page_number => 'Показати номер сторінки';

  @override
  String get from_library => 'З бібліотеки';

  @override
  String get downloaded_chapter => 'Завантажений розділ';

  @override
  String page(Object page) {
    return 'Page $page';
  }

  @override
  String get global_search => 'Глобальний пошук';

  @override
  String get color_blend_level => 'Рівень змішування кольорів';

  @override
  String current(Object char) {
    return 'Поточний $char';
  }

  @override
  String finished(Object char) {
    return 'Finished $char';
  }

  @override
  String next(Object char) {
    return 'Далі $char';
  }

  @override
  String previous(Object char) {
    return 'Previous $char';
  }

  @override
  String get no_more_chapter => 'Більше немає розділу';

  @override
  String get no_result => 'Немає результату';

  @override
  String get send => 'Надіслати';

  @override
  String get delete => 'Видалити';

  @override
  String get start_downloading => 'Розпочніть завантаження зараз';

  @override
  String get retry => 'Повторіть спробу';

  @override
  String get add_chapters => 'Додати розділи';

  @override
  String get delete_chapters => 'Видалити розділ?';

  @override
  String get default0 => 'За замовчуванням';

  @override
  String get total_chapters => 'Загальна кількість розділів';

  @override
  String get total_episodes => 'Всього епізодів';

  @override
  String get import_local_file => 'Імпортувати локальний файл';

  @override
  String get import_files => 'Файли';

  @override
  String get split_epub_chapters => 'Розбити на глави';

  @override
  String get split_epub_chapters_description =>
      'Імпортуйте кожен розділ EPUB як окремий запис';

  @override
  String get nothing_read_recently => 'Останнім часом нічого не читав';

  @override
  String get status => 'Статус';

  @override
  String get not_started => 'Не розпочато';

  @override
  String get score => 'Оцінка';

  @override
  String get start_date => 'Дата початку';

  @override
  String get finish_date => 'Дата закінчення';

  @override
  String get reading => 'Читання';

  @override
  String get on_hold => 'На утриманні';

  @override
  String get dropped => 'Впав';

  @override
  String get plan_to_read => 'План читання';

  @override
  String get re_reading => 'Перечитування';

  @override
  String get chapters => 'Розділи';

  @override
  String get add_tracker => 'Додати відстеження';

  @override
  String get one_tracker => '1 трекер';

  @override
  String n_tracker(Object n) {
    return '$n трекерів';
  }

  @override
  String get tracking => 'Відстеження';

  @override
  String get syncing => 'Синхр';

  @override
  String get sync_logged => 'Вхід успішний';

  @override
  String get syncing_subtitle =>
      'Введіть адресу свого сервера синхронізації та ввійдіть через браузер, щоб синхронізувати процес читання на всіх пристроях.';

  @override
  String get sync_service => 'Власна синхронізація';

  @override
  String get last_sync => 'Остання синхронізація: ';

  @override
  String get sync_login_browser => 'Увійдіть за допомогою браузера';

  @override
  String get sync_server => 'Адреса сервера синхронізації';

  @override
  String get sync_starting => 'Початок синхронізації...';

  @override
  String get sync_finished => 'Синхронізацію завершено';

  @override
  String get sync_failed => 'Помилка синхронізації';

  @override
  String get sync_restore_in_progress =>
      'Синхронізація пропущена — триває відновлення';

  @override
  String sync_progress_percent(Object percent) {
    return 'Синхронізація… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Синхронізація…';

  @override
  String get sync_button_sync => 'Хід синхронізації';

  @override
  String get sync_button_upload => 'Лише завантаження';

  @override
  String get sync_button_upload_info =>
      'Дані цього пристрою перезапишуть дані сервера для всього, що він також має. На сервері нічого не видаляється.';

  @override
  String get sync_button_download => 'Лише завантаження';

  @override
  String get sync_button_download_info =>
      'Завантажує все з сервера. На цьому пристрої нічого не видаляється.';

  @override
  String get sync_status_not_configured => 'Не підключено';

  @override
  String get sync_status_checking => 'Перевірка підключення...';

  @override
  String get sync_status_connected => 'Підключено';

  @override
  String get sync_status_unauthorized => 'Сеанс закінчився, увійдіть знову';

  @override
  String get sync_status_unreachable => 'Неможливо підключитися до сервера';

  @override
  String get sync_section_general => 'Загальне';

  @override
  String get sync_on => 'Увімкнути синхронізацію';

  @override
  String get sync_auto => 'Автоматична синхронізація';

  @override
  String get sync_auto_warning =>
      'Автоматична синхронізація наразі є експериментальною функцією!';

  @override
  String get sync_auto_off => 'Вимкнено';

  @override
  String get sync_auto_5_minutes => 'Кожні 5 хвилин';

  @override
  String get sync_auto_10_minutes => 'Кожні 10 хвилин';

  @override
  String get sync_auto_30_minutes => 'Кожні 30 хвилин';

  @override
  String get sync_auto_1_hour => 'Кожну 1 годину';

  @override
  String get sync_auto_3_hours => 'Кожні 3 години';

  @override
  String get sync_auto_6_hours => 'Кожні 6 годин';

  @override
  String get sync_auto_12_hours => 'Кожні 12 годин';

  @override
  String get server_error => 'Помилка сервера!';

  @override
  String get dialog_confirm => 'Підтвердити';

  @override
  String get description => 'Опис';

  @override
  String get reorder_navigation => 'Налаштувати навігацію';

  @override
  String get reorder_navigation_description =>
      'Змініть порядок і перемикайте кожну навігацію відповідно до ваших потреб.';

  @override
  String get floating_navigation_bar => 'Плаваюча панель навігації';

  @override
  String get floating_navigation_bar_description =>
      'Використовуйте плаваючу капсулу замість стандартної прикріпленої панелі навігації.';

  @override
  String get full_screen_player => 'Використовувати повноекранний режим';

  @override
  String get full_screen_player_info =>
      'Автоматично використовувати повноекранний режим під час відтворення відео.';

  @override
  String episode_progress(Object n) {
    return 'Прогрес: $n';
  }

  @override
  String n_episodes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n епізоди',
      one: '1 епізод',
    );
    return '$_temp0';
  }

  @override
  String missing_episodes(Object count) {
    return 'Відсутні $count епізоди';
  }

  @override
  String get manga_sources => 'Джерела манги';

  @override
  String get anime_sources => 'Джерела аніме';

  @override
  String get novel_sources => 'Нові джерела';

  @override
  String get anime_extensions => 'Розширення аніме';

  @override
  String get manga_extensions => 'Розширення манги';

  @override
  String get novel_extensions => 'Нові розширення';

  @override
  String get extension_settings => 'Параметри розширення';

  @override
  String get anime => 'Аніме';

  @override
  String get manga => 'Манга';

  @override
  String get novel => 'Роман';

  @override
  String get library_no_category_exist => 'У вас ще немає категорій';

  @override
  String get watching => 'Дивитися';

  @override
  String get plan_to_watch => 'План перегляду';

  @override
  String get re_watching => 'Перегляд';

  @override
  String get episodes => 'Епізоди';

  @override
  String get download => 'Завантажити';

  @override
  String get new_update_available => 'Доступне нове оновлення';

  @override
  String app_version(Object v) {
    return 'Версія програми: v$v';
  }

  @override
  String get searching_for_updates => 'Пошук оновлень...';

  @override
  String get no_new_updates_available => 'Немає доступних нових оновлень';

  @override
  String get uninstall => 'Видалити';

  @override
  String uninstall_extension(Object ext) {
    return 'Видалити розширення $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Двічі торкніться, щоб знайти все $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Показати пошукову підказку подвійним дотиком';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Показувати спливаючу підказку для навігаційних місць манги/аніме/романів із поясненням того, що подвійне торкання відкриває глобальний пошук.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" вже у вашій бібліотеці через $source.';
  }

  @override
  String get add_anyway => 'Усе одно додати';

  @override
  String get langauage => 'Мова';

  @override
  String get extension_detail => 'Деталь розширення';

  @override
  String get scale_type => 'Тип шкали';

  @override
  String get scale_type_fit_screen => 'Припасувати екран';

  @override
  String get scale_type_stretch => 'Розтяжка';

  @override
  String get scale_type_fit_width => 'Підходить ширина';

  @override
  String get scale_type_fit_height => 'Відповідна висота';

  @override
  String get scale_type_original_size => 'Оригінальний розмір';

  @override
  String get scale_type_smart_fit => 'Розумна посадка';

  @override
  String get page_preload_amount =>
      'Величина попереднього завантаження сторінки';

  @override
  String get page_preload_amount_subtitle =>
      'Кількість сторінок для попереднього завантаження під час читання. Вищі значення сприятимуть більш плавному читанню за рахунок більшого використання кешу та мережі.';

  @override
  String get image_loading_error => 'Не вдалося завантажити це зображення';

  @override
  String get add_episodes => 'Додати епізоди';

  @override
  String get video_quality => 'Якість';

  @override
  String get video_subtitle => 'Підзаголовок';

  @override
  String get check_for_extension_updates =>
      'Перевірте наявність оновлень розширень сторонніх розробників';

  @override
  String get auto_extensions_updates =>
      'Автоматичне оновлення сторонніх розширень';

  @override
  String get auto_extensions_updates_subtitle =>
      'Автоматичне оновлення встановлених сторонніх розширень. Офіційні плагіни завжди встановлюються та оновлюються автоматично.';

  @override
  String get check_for_app_updates =>
      'Перевірте наявність оновлень програми під час запуску';

  @override
  String get reading_mode => 'Режим читання';

  @override
  String get custom_filter => 'Спеціальний фільтр';

  @override
  String get background_color => 'Колір фону';

  @override
  String get white => 'Білий';

  @override
  String get black => 'Чорний';

  @override
  String get grey => 'Сірий';

  @override
  String get automaic => 'Автоматичний';

  @override
  String get preferred_domain => 'Бажаний домен';

  @override
  String get load_more => 'Завантажити більше';

  @override
  String get cancel_all_for_this_series => 'Скасувати все для цієї серії';

  @override
  String get login => 'Логін';

  @override
  String login_into(Object tracker) {
    return 'Увійти в $tracker';
  }

  @override
  String get email_adress => 'Адреса електронної пошти';

  @override
  String get password => 'Пароль';

  @override
  String log_out_from(Object tracker) {
    return 'Вийти з $tracker?';
  }

  @override
  String get log_out => 'Вийти';

  @override
  String get update_pending => 'Очікується оновлення';

  @override
  String get update_all => 'Оновити все';

  @override
  String get backup_and_restore => 'Резервне копіювання та відновлення';

  @override
  String get create_backup => 'Створити резервну копію';

  @override
  String get create_backup_dialog_title =>
      'Що ви хочете створити резервну копію?';

  @override
  String get create_backup_subtitle =>
      'Може використовуватися для відновлення поточної бібліотеки';

  @override
  String get restore_backup => 'Відновити резервну копію';

  @override
  String get encrypt_backups => 'Шифрування резервних копій';

  @override
  String get encrypt_backups_info =>
      'Захист паролем файлів резервних копій за допомогою шифрування AES';

  @override
  String get no_secure_storage => 'Захищене сховище не знайдено';

  @override
  String get no_keyring_warning =>
      'У цій системі немає доступної служби зв’язку ключів (наприклад, gnome-keyring або kwallet у Linux), тому пароль не можна надійно зберегти.\n\nЗберігати його незашифрованим у локальній базі даних програми? Будь-хто, хто має доступ до даних програми цього пристрою, зможе їх прочитати.';

  @override
  String get enter_backup_password => 'Введіть резервний пароль';

  @override
  String get incorrect_password_try_again =>
      'Неправильний пароль, повторіть спробу.';

  @override
  String get set_backup_password => 'Встановити резервний пароль';

  @override
  String get confirm_password => 'Підтвердити пароль';

  @override
  String get passwords_do_not_match => 'Паролі не збігаються';

  @override
  String get password_required_to_restore =>
      'Для відновлення цієї резервної копії потрібен пароль.';

  @override
  String get restore_backup_subtitle =>
      'Відновити бібліотеку з файлу резервної копії';

  @override
  String get automatic_backups => 'Автоматичне резервне копіювання';

  @override
  String get backup_frequency => 'Резервна частота';

  @override
  String get backup_location => 'Розташування резервної копії';

  @override
  String get backup_options => 'Резервні варіанти';

  @override
  String get backup_options_dialog_title =>
      'Що ви хочете створити резервну копію?';

  @override
  String get backup_options_subtitle =>
      'Яку інформацію включити у файл резервної копії?';

  @override
  String get backup_and_restore_warning_info =>
      'Ви також повинні зберігати копії резервних копій в інших місцях';

  @override
  String get library_entries => 'Записи бібліотеки';

  @override
  String get chapters_and_episode => 'Розділи та епізод';

  @override
  String get every_6_hours => 'Кожні 6 годин';

  @override
  String get every_12_hours => 'Кожні 12 годин';

  @override
  String get daily => 'Щодня';

  @override
  String get every_2_days => 'Кожні 2 дні';

  @override
  String get weekly => 'Щотижня';

  @override
  String get restore_backup_warning_title =>
      'Відновлення резервної копії перезапише всі наявні дані.\n\nПродовжити відновлення?';

  @override
  String get restore_sync_question_title => 'Синхронізувати це відновлення?';

  @override
  String get restore_sync_question_message =>
      'Цей пристрій підключено до сервера синхронізації. Завантажити на нього ці відновлені дані зараз? Якщо ні, синхронізацію буде вимкнено, щоб старі дані сервера не перезаписували те, що ви щойно відновили.';

  @override
  String get restore_sync_question_confirm => 'Так, синхронізувати';

  @override
  String get restore_sync_question_deny => 'Ні, вимкнути синхронізацію';

  @override
  String get sync_disabled_after_restore =>
      'Синхронізацію вимкнено. Ви можете знову ввімкнути його в налаштуваннях.';

  @override
  String get restore_sync_disabled_question_title =>
      'Синхронізацію наразі вимкнено';

  @override
  String get restore_sync_disabled_question_message =>
      'Синхронізацію вимкнено. Увімкнути його знову та завантажити ці відновлені дані на ваш сервер?';

  @override
  String get restore_sync_question_reenable =>
      'Так, увімкнути повторно та синхронізувати';

  @override
  String get restore_sync_question_keep_disabled => 'Тримайте його вимкненим';

  @override
  String get restore_sync_uploading =>
      'Синхронізація відновлених даних із сервером…';

  @override
  String get restore_sync_upload_success =>
      'Відновлені дані, синхронізовані з сервером';

  @override
  String get services => 'Послуги';

  @override
  String get tracking_warning_info =>
      'Одностороння синхронізація для оновлення прогресу глави в службах відстеження. Налаштуйте відстеження для окремих записів за допомогою відповідної кнопки відстеження.';

  @override
  String get use_page_tap_zones => 'Використовуйте зони натискання сторінок';

  @override
  String get manage_trackers => 'Керування трекерами';

  @override
  String get restore => 'Відновити';

  @override
  String get backups => 'Резервні копії';

  @override
  String get by_scanlator => 'За допомогою сканатора';

  @override
  String get by_name => 'По імені';

  @override
  String get installed => 'Встановлено';

  @override
  String get auto_scroll => 'Автоматична прокрутка';

  @override
  String get video_audio => 'Аудіо';

  @override
  String get video_audio_info => 'Бажані мови, корекція висоти, аудіоканали';

  @override
  String get player => 'Гравець';

  @override
  String get markEpisodeAsSeenSetting =>
      'У який момент позначити епізод як побачений';

  @override
  String get mark_duplicate_chapters_read =>
      'Позначити повторювані номери розділів як прочитані';

  @override
  String get default_skip_intro_length => 'Тривалість пропуску вступу';

  @override
  String get default_playback_speed_length =>
      'Швидкість відтворення за замовчуванням';

  @override
  String get updateProgressAfterReading => 'Оновлення прогресу після читання';

  @override
  String get no_sources_installed => 'Джерела не встановлено!';

  @override
  String get show_extensions => 'Показати розширення';

  @override
  String get default_skip_forward_skip_length =>
      'Тривалість пошуку подвійним дотиком';

  @override
  String get aniskip_requires_info =>
      'Для роботи AniSkip потрібно, щоб аніме відстежувалося за допомогою MAL або Anilist.';

  @override
  String get enable_aniskip => 'Увімкнути AniSkip';

  @override
  String get enable_auto_skip => 'Увімкнути автоматичний пропуск';

  @override
  String get aniskip_button_timeout => 'Час очікування кнопки';

  @override
  String get skip_opening => 'Відкриття скіпу';

  @override
  String get skip_ending => 'Пропустити закінчення';

  @override
  String get fullscreen => 'Повний екран';

  @override
  String get update_library => 'Оновлення бібліотеки';

  @override
  String get next_chapter => 'Наступна глава';

  @override
  String get next_5_chapters => 'Наступні 5 розділів';

  @override
  String get next_10_chapters => 'Наступні 10 розділів';

  @override
  String get next_25_chapters => 'Наступні 25 розділів';

  @override
  String get all_chapters => 'Усі глави';

  @override
  String get next_episode => 'Наступний епізод';

  @override
  String get next_5_episodes => 'Наступні 5 епізодів';

  @override
  String get next_10_episodes => 'Наступні 10 епізодів';

  @override
  String get next_25_episodes => 'Наступні 25 епізодів';

  @override
  String get all_episodes => 'Усі епізоди';

  @override
  String get cover_saved => 'Обкладинку збережено';

  @override
  String get set_as_cover => 'Встановити як кришку';

  @override
  String get use_this_as_cover_art => 'Використовувати це як обкладинку?';

  @override
  String get save => 'Зберегти';

  @override
  String get picture_saved => 'Зображення збережено';

  @override
  String get cover_updated => 'Обкладинка оновлена';

  @override
  String get include_subtitles => 'Додайте субтитри';

  @override
  String get blend_mode_default => 'За замовчуванням';

  @override
  String get blend_mode_multiply => 'Помножити';

  @override
  String get blend_mode_screen => 'Екран';

  @override
  String get blend_mode_overlay => 'Накладання';

  @override
  String get blend_mode_colorDodge => 'ColorDodge';

  @override
  String get blend_mode_lighten => 'Освітлити';

  @override
  String get blend_mode_colorBurn => 'ColorBurn';

  @override
  String get blend_mode_darken => 'Темніти';

  @override
  String get blend_mode_difference => 'Різниця';

  @override
  String get blend_mode_saturation => 'Насиченість';

  @override
  String get blend_mode_softLight => 'SoftLight';

  @override
  String get blend_mode_plus => 'Плюс';

  @override
  String get blend_mode_exclusion => 'Виключення';

  @override
  String get custom_color_filter => 'Спеціальний кольоровий фільтр';

  @override
  String get color_filter_blend_mode => 'Режим змішування кольорового фільтра';

  @override
  String get enable_all => 'Увімкнути все';

  @override
  String get disable_all => 'Вимкнути все';

  @override
  String get font => 'Шрифт';

  @override
  String get color => 'Колір';

  @override
  String get font_size => 'Розмір шрифту';

  @override
  String get text => 'Текст';

  @override
  String get border => 'Кордон';

  @override
  String get background => 'Передумови';

  @override
  String get no_subtite_warning_message =>
      'Не має ефекту, оскільки в цьому відео немає доріжок субтитрів';

  @override
  String get grid_size => 'Розмір сітки';

  @override
  String n_per_row(Object n) {
    return '$n на рядок';
  }

  @override
  String get horizontal_continious => 'Горизонтальний безперервний';

  @override
  String get edit_code => 'Редагувати код';

  @override
  String get use_libass => 'Увімкнути libass';

  @override
  String get use_libass_info =>
      'Використовуйте візуалізацію субтитрів на основі libass для рідної серверної частини.';

  @override
  String get libass_not_disable_message =>
      'Вимкніть `use libass` в налаштуваннях програвача, щоб мати можливість налаштувати субтитри.';

  @override
  String get override_ass_subtitles => 'Заміна субтитрів ASS';

  @override
  String get override_ass_subtitles_info =>
      'Застосувати власний стиль до субтитрів ASS/SSA';

  @override
  String get torrent_stream => 'Торрент-потік';

  @override
  String get add_torrent => 'Додати торрент';

  @override
  String get enter_torrent_hint_text =>
      'Введіть URL-адресу магнітного або торрент-файлу';

  @override
  String get torrent_url => 'URL-адреса торрента';

  @override
  String get or => 'АБО';

  @override
  String get advanced => 'Розширений';

  @override
  String get advanced_info => 'mpv конфіг';

  @override
  String get use_native_http_client => 'Використовуйте рідний http-клієнт';

  @override
  String get use_native_http_client_info =>
      'автоматично підтримує такі функції платформи, як VPN, підтримує більше функцій HTTP, таких як HTTP/3, і спеціальну обробку перенаправлення';

  @override
  String n_hour_ago(Object hour) {
    return '$hour годину тому';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours годин тому';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute хвилин тому';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes хвилин тому';
  }

  @override
  String n_day_ago(Object day) {
    return '$day день тому';
  }

  @override
  String get now => 'зараз';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Останнє оновлення бібліотеки: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Дані та зберігання';

  @override
  String get download_location_info =>
      'Використовується для завантаження розділів';

  @override
  String get storage => 'Зберігання';

  @override
  String get clear_chapter_and_episode_cache =>
      'Очистити кеш розділів і епізодів';

  @override
  String get cache_cleared => 'Кеш очищено';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Очистити кеш розділів/серій під час запуску програми';

  @override
  String get app_settings => 'Налаштування програми';

  @override
  String get sources_settings => 'Налаштування джерел';

  @override
  String get include_sensitive_settings =>
      'Включати конфіденційні налаштування (наприклад, маркери входу в трекер)';

  @override
  String get create => 'Створити';

  @override
  String get downloads_are_limited_to_wifi =>
      'Завантаження обмежені лише Wi-Fi';

  @override
  String get recommendations => 'Рекомендації';

  @override
  String get recommendations_similar => 'подібне';

  @override
  String get recommendations_weights => 'Рекомендовані ваги';

  @override
  String get recommendations_weights_genre => 'Жанрова подібність';

  @override
  String get recommendations_weights_setting => 'Встановлення подібності';

  @override
  String get recommendations_weights_synopsis => 'Подібність історії';

  @override
  String get recommendations_weights_theme => 'Подібність теми';

  @override
  String get manga_extensions_repo => 'Сховище розширень манги';

  @override
  String get anime_extensions_repo => 'Репо розширень аніме';

  @override
  String get novel_extensions_repo => 'Нове сховище розширень';

  @override
  String get custom_dns =>
      'Спеціальний DNS (залиште порожнім, щоб використовувати системний DNS)';

  @override
  String get android_proxy_server =>
      'Проксі-сервер Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Отримати M-Extension-Server';

  @override
  String get undefined => 'не визначено';

  @override
  String get empty_extensions_repo => 'Поки немає сховищ розширень';

  @override
  String get add_extensions_repo => 'Додати репо URL';

  @override
  String get remove_extensions_repo => 'Видалити репо URL';

  @override
  String get manage_manga_repo_urls => 'Керування URL-адресами Manga Repo';

  @override
  String get manage_anime_repo_urls => 'Керування URL-адресами Repo аніме';

  @override
  String get manage_novel_repo_urls => 'Керування новими URL-адресами репо';

  @override
  String get url_cannot_be_empty => 'URL не може бути порожнім';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL має закінчуватися на .json / .pb';

  @override
  String get repo_url => 'Repo URL';

  @override
  String get invalid_url_format => 'Недійсний формат URL';

  @override
  String get clear_all_sources => 'Очистити всі джерела';

  @override
  String get clear_all_sources_msg =>
      'Це повністю видалить усі джерела програми. Ви впевнені, що бажаєте продовжити?';

  @override
  String get sources_cleared => 'Джерела очищені!!!';

  @override
  String get repo_added => 'Додано вихідний репозиторій!';

  @override
  String get repo_already_exists => 'Репозиторій вже існує!';

  @override
  String get add_repo => 'Додати репозиторій?';

  @override
  String get add_repo_sources_to_add => 'Списки розширень, які будуть додані:';

  @override
  String get add_repo_warning =>
      'Розширення з цих репозиторіїв запускаються всередині програми. Додавайте лише ті сховища, яким довіряєте.';

  @override
  String get genre_search_library => 'Пошук жанру в бібліотеці';

  @override
  String get genre_search_source => 'Перегляньте джерело';

  @override
  String get source_not_added => 'Джерело не встановлено!';

  @override
  String get load_own_subtitles => 'Завантажте власні субтитри...';

  @override
  String get search_subtitles => 'Пошук субтитрів в Інтернеті...';

  @override
  String extension_notes(Object notes) {
    return 'Примітки: $notes';
  }

  @override
  String get unsupported_repo =>
      'Неможливо додати це вихідне сховище. Перевірте адресу сховища або зверніться до його менеджера.';

  @override
  String get you_have_finished_reading => 'Ви закінчили читати';

  @override
  String get hwdec => 'Апаратний декодер';

  @override
  String get enable_hardware_accel => 'Апаратне прискорення';

  @override
  String get enable_hardware_accel_info =>
      'Увімкніть/вимкніть його, якщо у вас виникають помилки або збої';

  @override
  String get track_library_navigate => 'Перейти до існуючого локального запису';

  @override
  String get track_library_add => 'Додати до місцевої бібліотеки';

  @override
  String get track_library_add_confirm =>
      'Додати відстежуваний елемент до локальної бібліотеки';

  @override
  String get track_library_not_logged =>
      'Увійдіть у відповідний трекер, щоб скористатися цією функцією!';

  @override
  String get track_library_switch => 'Переключитися на інший трекер';

  @override
  String get go_back => 'Повернись назад';

  @override
  String get merge_library_nav_mobile =>
      'Навігація по бібліотеці на мобільному пристрої';

  @override
  String get enable_discord_rpc => 'Увімкнути Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Сховати Discord RPC у режимі анонімного перегляду';

  @override
  String get rpc_show_reading_watching_progress =>
      'Показати поточний розділ у Discord (потрібно перезапустити)';

  @override
  String get rpc_show_title => 'Показати поточну назву в Discord';

  @override
  String get rpc_show_cover_image =>
      'Показати поточне зображення обкладинки в Discord';

  @override
  String get enable_mpv => 'Увімкнути mpv шейдери / сценарії';

  @override
  String get mpv_info => 'Підтримує сценарії .js у mpv/scripts/';

  @override
  String get mpv_redownload => 'Повторно завантажити файли конфігурації mpv';

  @override
  String get mpv_redownload_info =>
      'Замінює старі конфігураційні файли на нові!';

  @override
  String get mpv_download => 'MPV!\nЗавантажити зараз?';

  @override
  String get custom_buttons => 'Спеціальні кнопки';

  @override
  String get custom_buttons_info =>
      'Виконайте код lua за допомогою спеціальних кнопок';

  @override
  String get custom_buttons_edit => 'Редагувати спеціальні кнопки';

  @override
  String get custom_buttons_add => 'Додати спеціальну кнопку';

  @override
  String get custom_buttons_added => 'Додано спеціальну кнопку!';

  @override
  String get custom_buttons_delete => 'Видалити спеціальну кнопку';

  @override
  String get custom_buttons_text => 'Текст кнопки';

  @override
  String get custom_buttons_text_req => 'Необхідний текст кнопки';

  @override
  String get custom_buttons_js_code => 'код lua';

  @override
  String get custom_buttons_js_code_req => 'необхідний код lua';

  @override
  String get custom_buttons_js_code_long =>
      'код lua (при тривалому натисканні)';

  @override
  String get custom_buttons_startup => 'код lua (під час запуску)';

  @override
  String get custom_buttons_add_warning =>
      'Ця кнопка запускає код Lua нижче у відеопрогравачі, який може отримати доступ до ваших файлів і запускати програми. Додайте його, лише якщо ви вірите, звідки надійшло це посилання.';

  @override
  String n_days(Object n) {
    return '$n днів';
  }

  @override
  String get decoder => 'Декодер';

  @override
  String get decoder_info =>
      'Апаратне декодування, піксельний формат, дебандування';

  @override
  String get enable_gpu_next => 'Увімкнути gpu-next (лише Android)';

  @override
  String get enable_gpu_next_info => 'Новий сервер обробки відео';

  @override
  String get debanding => 'Дебандування';

  @override
  String get use_yuv420p => 'Використовуйте піксельний формат YUV420P';

  @override
  String get use_yuv420p_info =>
      'Може виправляти чорні екрани на деяких відеокодеках, також може підвищити продуктивність ціною якості';

  @override
  String get audio_preferred_languages => 'Бажані мови';

  @override
  String get audio_preferred_languages_info =>
      'Мови аудіо, яким слід віддавати перевагу, коли відео має кілька звукових доріжок. Використовуйте дво- або трибуквені коди, розділені комами (наприклад: ja, en).';

  @override
  String get enable_audio_pitch_correction => 'Увімкнути корекцію висоти звуку';

  @override
  String get enable_audio_pitch_correction_info =>
      'Запобігає тому, щоб звук став високим на вищих швидкостях і низьким на низьких швидкостях';

  @override
  String get audio_channels => 'Аудіоканали';

  @override
  String get volume_boost_cap => 'Кришка збільшення об’єму';

  @override
  String get internal_player => 'Внутрішній плеєр';

  @override
  String get internal_player_info => 'Прогрес, елементи керування, орієнтація';

  @override
  String get subtitle_delay_text => 'Затримка субтитрів';

  @override
  String get subtitle_delay => 'Затримка (мс)';

  @override
  String get subtitle_speed => 'Швидкість';

  @override
  String get tracks => 'Треки';

  @override
  String get playback_speed => 'Швидкість відтворення';

  @override
  String get shaders => 'Шейдери';

  @override
  String get video_fit => 'Fit';

  @override
  String get calendar => 'Календар';

  @override
  String get calendar_no_data => 'Даних ще немає.';

  @override
  String get calendar_info =>
      'Календар може передбачити завантаження наступного розділу лише на основі попередніх завантажень. Деякі дані можуть бути неточними на 100%!';

  @override
  String in_n_day(Object days) {
    return 'через $days день';
  }

  @override
  String in_n_days(Object days) {
    return 'через $days днів';
  }

  @override
  String get clear_library => 'Очистити бібліотеку';

  @override
  String get clear_library_desc =>
      'Виберіть видалення всіх записів манги, аніме та/або романів';

  @override
  String get clear_library_input =>
      'Введіть «манга», «аніме» та/або «роман» (розділивши їх комою), щоб видалити всі пов’язані записи';

  @override
  String get watch_order => 'Порядок перегляду';

  @override
  String get watch_order_role_current => 'Поточне';

  @override
  String get watch_order_role_previous => 'Попередній';

  @override
  String get watch_order_role_next => 'Далі';

  @override
  String get watch_order_source_release_order => 'Наказ про звільнення';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name від $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Офіційна колекція Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt колекція: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Пори року для $title';
  }

  @override
  String get watch_order_select_source => 'Джерело замовлення';

  @override
  String watch_order_season(int number) {
    return 'Сезон $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Епізод $number';
  }

  @override
  String get sequels => 'Продовження';

  @override
  String get recommendations_similarity => 'Подібність:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Рейтинг $rating';
  }

  @override
  String get local_folder_structure => 'Структура локальної папки';

  @override
  String get local_folder => 'Локальні папки';

  @override
  String get add_local_folder => 'Додати локальну папку';

  @override
  String get rescan_local_folder => 'Перескануйте всі локальні папки зараз';

  @override
  String get default_download_destination =>
      'Пункт призначення завантаження за замовчуванням';

  @override
  String get ask_download_destination => 'Запитати призначення завантаження';

  @override
  String get ask_download_destination_desc =>
      'Вибирайте локальну папку кожного разу, коли починається завантаження.';

  @override
  String get select_download_destination =>
      'Виберіть пункт призначення для завантаження';

  @override
  String get clear_local_library => 'Очистити локальну бібліотеку';

  @override
  String get clear_local_library_desc =>
      'Видаліть локальну папку та записи архіву з бібліотеки.';

  @override
  String get clear_local_library_msg =>
      'Це видалить локальні папки та записи архіву з вашої бібліотеки. Він не видаляє файли з диска.';

  @override
  String get custom => 'Custom';

  @override
  String get no_local_folder_available_for_downloads =>
      'Локальна папка недоступна для завантаження';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Не вдалося створити CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Помилка читання обкладинки: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Помилка читання метаданих: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Помилка збереження розділу/серіалу в бібліотеці: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Помилка читання зображення обкладинки розділу: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Помилка читання зображення обкладинки архіву: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Помилка отримання локальної бібліотеки: $error';
  }

  @override
  String get export_metadata => 'Експорт метаданих';

  @override
  String get exported => 'Експортовано';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Не вдалося експортувати метадані: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count розділ(и) не може бути автоматично пронумерований і може бути не в порядку або відсутній у читача.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Не вдалося запустити Cloudflare Resolution Webview Server.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Термін дії маркера $tracker минув';
  }

  @override
  String get video_list_empty => 'Список відео порожній';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Не вдалося запустити $url';
  }

  @override
  String get text_size => 'Розмір тексту:';

  @override
  String get text_align => 'Вирівнювання тексту';

  @override
  String get line_height => 'Висота лінії';

  @override
  String get show_scroll_percentage => 'Показати відсоток прокручування';

  @override
  String get remove_extra_paragraph_spacing =>
      'Видалити зайві інтервали між абзацами';

  @override
  String select_label_color(Object label) {
    return 'Виберіть колір $label';
  }

  @override
  String get default_user_agent => 'Типовий агент користувача';

  @override
  String get forceLandscapeMode => 'Примусовий ландшафтний режим';

  @override
  String get forceLandscapeModeSubtitle =>
      'Змусити гравця використовувати альбомну орієнтацію.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Постачальник DNS';

  @override
  String get tracked => 'Відстежено';

  @override
  String get auth_unlock_msg =>
      'Пройдіть автентифікацію, щоб розблокувати програму';

  @override
  String get app_locked => 'Додаток заблоковано';

  @override
  String get auth_to_continue => 'Щоб продовжити, пройдіть автентифікацію';

  @override
  String get authenticating => 'Автентифікація...';

  @override
  String get lock => 'Замок';

  @override
  String get unlock => 'Розблокувати';

  @override
  String get security => 'Безпека';

  @override
  String get auth_to_change_security_setting =>
      'Пройдіть автентифікацію, щоб змінити налаштування безпеки';

  @override
  String get app_lock => 'Блокування програми';

  @override
  String get require_biometric_or_device_credential =>
      'Для відкриття програми потрібні біометричні дані або дані пристрою';

  @override
  String get biometric_or_device_credential_not_available =>
      'Біометрична автентифікація або автентифікація облікових даних пристрою недоступна на цьому пристрої';

  @override
  String get app_lock_description =>
      'Коли блокування програми ввімкнено, вас запитуватимуть про автентифікацію кожного разу, коли ви відкриватимете програму або повертатиметеся до неї у фоновому режимі.';

  @override
  String get checking_device_authentication =>
      'Перевірка автентифікації пристрою…';

  @override
  String get device_authentication_incomplete =>
      'Автентифікацію не завершено. Ваші налаштування не змінилися.';

  @override
  String get keep_screen_on => 'Тримайте екран увімкненим';

  @override
  String get webtoon_side_padding => 'Бокова оббивка Webtoon';

  @override
  String get show_page_gaps => 'Показати пропуски сторінок';

  @override
  String get invert_colors => 'Інвертувати кольори';

  @override
  String get grayscale => 'Відтінки сірого';

  @override
  String get brightness => 'Яскравість';

  @override
  String get contrast => 'Контраст';

  @override
  String get saturation => 'Насиченість';

  @override
  String get navigation_layout => 'Схема навігації';

  @override
  String get nav_layout_default => 'За замовчуванням';

  @override
  String get nav_layout_l_shaped => 'Г-подібна';

  @override
  String get nav_layout_kindle => 'Подібний Kindle';

  @override
  String get nav_layout_edge => 'Край';

  @override
  String get nav_layout_right_and_left => 'Вправо і вліво';

  @override
  String get nav_layout_disabled => 'Вимкнено';

  @override
  String get color_enhancements => 'Покращення кольору';

  @override
  String get total => 'Всього';

  @override
  String get mean_per_title => 'Середнє значення на заголовок';

  @override
  String get completion_rate => 'Швидкість завершення';

  @override
  String get watching_time => 'Час перегляду';

  @override
  String get reading_time => 'Час читання';

  @override
  String average_chapters_per_title(Object title) {
    return 'Середня кількість розділів на $title';
  }

  @override
  String get read_percentage => 'Прочитати відсоток';

  @override
  String get entries => 'Записи';

  @override
  String get android_proxy_server_mihon => 'Проксі-сервер Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Завантажте та налаштуйте проксі-сервер, необхідний для використання розширень Mihon.';

  @override
  String get mihon_proxy_server => 'Проксі-сервер Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Перед використанням розширень Mihon завантажте комплект проксі-сервера. Пакет включає JRE та сервер розширення JAR.';

  @override
  String get extension_server_intro_ios =>
      'Перед використанням розширень Mihon завантажте проксі-сервер JAR. iOS потрібен лише JAR сервера розширення.';

  @override
  String get checking_files => 'Перевірка файлів';

  @override
  String get files_installed => 'Встановлені файли';

  @override
  String get files_missing => 'Файли відсутні';

  @override
  String get update_files => 'Оновлення файлів';

  @override
  String get up_to_date => 'Актуально';

  @override
  String get choose_location => 'Виберіть місце розташування';

  @override
  String get import_existing_jar => 'Імпорт існуючого JAR';

  @override
  String get detect_files_in_selected_folder =>
      'Виявлення файлів у вибраній папці';

  @override
  String get preparing_download => 'Підготовка завантаження...';

  @override
  String get app_install_location => 'Місце встановлення програми';

  @override
  String get install_location => 'Місце установки';

  @override
  String get jre_executable => 'Виконуваний файл JRE';

  @override
  String get extension_server_jar => 'JAR сервера розширення';

  @override
  String get installed_version => 'Встановлена версія';

  @override
  String get latest_version => 'Остання версія';

  @override
  String get m_extension_server_description =>
      'Використовуйте M-Extension-Server, коли вам потрібен окремий проксі-сервер пристрою Android. Встановіть тут адресу проксі-сервера та завантажте файл APK із GitHub.';

  @override
  String get set_proxy_address => 'Встановити адресу проксі';

  @override
  String get no_newer_proxy_server_release_available =>
      'Новий випуск проксі-сервера недоступний.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Не вдалося перевірити наявність оновлень проксі-сервера.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Для цієї платформи не доступний пакет серверів розширення.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Не вдалося завантажити комплект ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Завантажений пакет не містить очікуваних файлів.';

  @override
  String get extension_server_files_ready => 'Файли сервера розширення готові.';

  @override
  String get ios_extension_server_import_hint =>
      'В iOS сервер встановлено всередині ізольованого програмного середовища. Використовуйте «Імпортувати наявний JAR», щоб додати завантажений файл.';

  @override
  String get select_extension_server_folder =>
      'Виберіть папку сервера розширення';

  @override
  String get selected_folder_does_not_exist => 'Вибрана папка не існує.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'У вибраній папці не знайдено файлів сервера розширення.';

  @override
  String get extension_server_files_linked =>
      'Файли сервера розширення були пов’язані.';

  @override
  String get select_extension_server_jar => 'Виберіть JAR сервера розширення';

  @override
  String get selected_file_could_not_be_accessed =>
      'Не вдалося отримати доступ до вибраного файлу.';

  @override
  String get extension_server_jar_imported =>
      'JAR сервера розширення було імпортовано.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Не вдалося запустити сторінку M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP-адреса сервера (наприклад, 10.0.0.5 або https://example.com)';

  @override
  String get not_configured => 'Не налаштовано';

  @override
  String get zero_interpreter => 'Нульовий інтерпретатор';

  @override
  String get zero_interpreter_description =>
      'Керуйте сервером інтерпретатора Zero автоматично або вручну.';

  @override
  String get start_server_on_launch => 'Запустити сервер під час запуску';

  @override
  String get runtime_status => 'Статус виконання';

  @override
  String get running => 'Біг';

  @override
  String get stopped => 'Зупинено';

  @override
  String get start => 'Початок';

  @override
  String get stop => 'Стоп';

  @override
  String get webview => 'Веб-перегляд';

  @override
  String get tts => 'Перетворення тексту в мову';

  @override
  String get tts_speed => 'Швидкість';

  @override
  String get tts_pitch => 'Висота';

  @override
  String get tts_language => 'Мова';

  @override
  String get tts_voice => 'Голос';

  @override
  String get tts_stop => 'Стоп';

  @override
  String get tts_play => 'Гра';

  @override
  String get tts_pause => 'Пауза';

  @override
  String get tts_previous => 'Попередній абзац';

  @override
  String get tts_next => 'Наступний абзац';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Параграф $current з $total';
  }

  @override
  String get tts_settings => 'Налаштування TTS';

  @override
  String get tts_default => 'За замовчуванням';

  @override
  String get webtoon_disable_zoom_out => 'Webtoon вимикає зменшення масштабу';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Подвійне торкання веб-мультфільму';

  @override
  String get navigate_to_pan => 'Перейти до панорамування';

  @override
  String get navigate_to_pan_subtitle =>
      'Перемістіть збільшене зображення перед перегортанням сторінки';

  @override
  String get split_wide_pages => 'Розділіть широкі сторінки';

  @override
  String get dual_page_invert => 'Перевернути вирізані половини сторінки';

  @override
  String get dual_page_rotate_to_fit => 'Поверніть, щоб підігнати';

  @override
  String get dual_page_rotate_to_fit_invert => 'Інвертувати напрямок обертання';

  @override
  String get double_page_single_first_page => 'Одна перша сторінка';

  @override
  String get double_page_single_first_page_subtitle =>
      'Відображення лише першої сторінки в режимі подвійної сторінки';

  @override
  String get double_page_auto => 'Автоматична подвійна сторінка';

  @override
  String get double_page_auto_subtitle =>
      'Автоматичний перехід у режим подвійної сторінки в альбомній орієнтації';

  @override
  String get landscape_zoom => 'Автоматичне ландшафтне масштабування';

  @override
  String get zoom_start_position => 'Початкова позиція масштабування';

  @override
  String get zoom_start_left => 'Ліворуч';

  @override
  String get zoom_start_right => 'Правильно';

  @override
  String get zoom_start_center => 'Центр';

  @override
  String get automatic_background => 'Автоматичний фон';

  @override
  String get tapping_inversion => 'Інверсія постукування';

  @override
  String get tapping_inversion_none => 'Жодного';

  @override
  String get tapping_inversion_horizontal => 'Горизонтальний';

  @override
  String get tapping_inversion_vertical => 'Вертикальний';

  @override
  String get tapping_inversion_both => 'Обидва';

  @override
  String get flash_on_page_change => 'Зміна Flash на сторінці';

  @override
  String get flash_on_page_change_subtitle => 'Помічник AMOLED проти затримки';

  @override
  String get flash_color => 'Колір спалаху';

  @override
  String get flash_color_black => 'Чорний';

  @override
  String get flash_color_white => 'Білий';

  @override
  String get flash_color_white_black => 'Білий і чорний';

  @override
  String get flash_interval_label => 'Інтервал спалаху';

  @override
  String flash_interval_value(String n) {
    return '$n сторінок';
  }

  @override
  String flash_interval(String n) {
    return 'Інтервал Flash: $n сторінок';
  }

  @override
  String get flash_duration_label => 'Тривалість спалаху';

  @override
  String flash_duration_value(String n) {
    return '$n мс';
  }

  @override
  String flash_duration(String n) {
    return 'Тривалість спалаху: $n мс';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Показувати накладення навігації під час запуску';

  @override
  String get reader_hide_threshold => 'Поріг приховування зчитувача';

  @override
  String get reader_hide_threshold_highest => 'Найвищий (5 пікселів)';

  @override
  String get reader_hide_threshold_high => 'Високий (13 пікселів)';

  @override
  String get reader_hide_threshold_low => 'Низький (31 пікс.)';

  @override
  String get reader_hide_threshold_lowest => 'Найнижчий (47 пікселів)';

  @override
  String get error_no_pages_available => 'Помилка: немає доступних сторінок';

  @override
  String get app_ui_scale => 'Інтерфейс шкали';

  @override
  String get app_ui_scale_subtitle =>
      'Зробіть інтерфейс більшим або меншим відповідно до вашого екрана та відстані перегляду.';

  @override
  String get allow_concurrent_downloads => 'Дозволити одночасне завантаження';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Завантажуйте з різних джерел одночасно. Одне джерело все одно завантажує по одній главі, тому не перевантажується. Вимкніть, щоб завантажувати всюди по одному.';

  @override
  String get download_delay => 'Затримка завантаження';

  @override
  String get download_delay_subtitle =>
      'Вимкнено. Додайте очікування з випадковим тремтінням між розділами, щоб дбайливо ставитися до джерел.';

  @override
  String get save_search => 'Зберегти пошук';

  @override
  String get saved_searches => 'Збережені пошуки';

  @override
  String get enter_search_to_save_first =>
      'Спочатку введіть пошуковий запит, щоб зберегти';

  @override
  String get no_saved_searches =>
      'Ще немає збережених пошуків для цього джерела.\nЗапустіть пошук, а потім виберіть «Зберегти пошук».';

  @override
  String get source => 'Джерело';

  @override
  String get something_went_wrong => 'Щось пішло не так';

  @override
  String get startup_failed => 'NodeLane Comics не вдалося завершити запуск';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count джерел без результатів',
      one: '1 джерело без результатів',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Як це слід імпортувати?';

  @override
  String get import_mode_message =>
      'Виберіть, чи об’єднати цю резервну копію з поточною бібліотекою, чи замінити нею всю бібліотеку.';

  @override
  String get import_mode_keep_existing => 'Злиття';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Додає нові серії та оновлює відповідні. У вашій поточній бібліотеці нічого не видалено.';

  @override
  String get import_mode_replace => 'Замінити';

  @override
  String get import_mode_replace_subtitle =>
      'Видаляє всю поточну бібліотеку та замінює її цією резервною копією.';

  @override
  String get replace_summary_title => 'Готовий замінити вашу бібліотеку';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Це видаляє всю вашу поточну бібліотеку (серію $currentCount) і замінює її серією $backupCount з цієї резервної копії. Це можна скасувати лише шляхом відкоту.';
  }

  @override
  String get replace_summary_confirm => 'Замінити';

  @override
  String replace_result_message(Object count) {
    return 'Замінено вашу бібліотеку серіями $count з цієї резервної копії.';
  }

  @override
  String get category_conflict_title => 'Знайдено існуючі категорії';

  @override
  String get category_conflict_message =>
      'Резервна копія містить категорії, які вже існують у вашій бібліотеці. Продовжуйте, щоб згорнути вхідні серії до наявної категорії, або видаліть, щоб залишити ці серії без категорії.';

  @override
  String get category_conflict_keep =>
      'Зберегти — об’єднати в існуючу категорію';

  @override
  String get category_conflict_delete =>
      'Видалити — залишити серію без категорії';

  @override
  String get source_conflict_title => 'Джерела не знайдені';

  @override
  String get source_conflict_message =>
      'Ці резервні джерела не відповідають встановленому розширенню. Збережіть оригінальну назву (імпортовану без робочого джерела) або перейдіть на встановлене розширення, щоб ці серії можна було оновити.';

  @override
  String get source_conflict_keep =>
      'Зберегти оригінальну назву (немає живого джерела)';

  @override
  String get import_summary_title => 'Готовий до імпорту';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries нових серій, $updatedSeries існуючих серій буде оновлено, а $newChapters нових розділів буде додано. Нічого, що вже є у вашій бібліотеці, не буде видалено.';
  }

  @override
  String get import_summary_confirm => 'Імпорт';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Імпортовано $newSeries нових серій, оновлено $updatedSeries існуючих, додано $newChapters нових розділів.';
  }

  @override
  String get roll_back => 'Відкат';

  @override
  String get roll_back_confirm_message =>
      'Це відновить вашу бібліотеку до моментального знімка безпеки, зробленого безпосередньо перед цією зміною, скасовуючи все, що вона щойно робила.';

  @override
  String get roll_back_done => 'Відкат до моментального знімка перед зміною.';

  @override
  String get restoring_backup => 'Відновлення вашої бібліотеки…';

  @override
  String get roll_back_last_change => 'Скасувати останню зміну';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Знімок з $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count доступні останні зміни, до яких можна повернутися';
  }

  @override
  String get delete_source_title => 'Видалити джерело та його мангу';

  @override
  String get delete_source_subtitle =>
      'Виберіть джерело та видаліть усі манги, які містяться у вашій бібліотеці, разом із їхніми розділами, завантаженнями, історією та відстеженням.';

  @override
  String get delete_source_pick_title => 'Виберіть джерело для видалення';

  @override
  String get delete_source_empty => 'У вашій бібліотеці не знайдено джерел.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Видалити $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Це назавжди видаляє $mangaCount мангу, $chapterCount розділи, $historyCount записи історії та $updateCount записи оновлень. Посилання для відстеження зберігаються. Цю дію неможливо скасувати, окрім як повернути назад.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Також видаліть встановлене розширення';

  @override
  String get delete_source_keep_history => 'Продовжуйте читати історію';

  @override
  String get delete_source_keep_downloads =>
      'Зберігайте записи про завантаження';

  @override
  String get delete_source_button => 'Видалити';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Видалено мангу $mangaCount з $sourceName.';
  }

  @override
  String get merge_manga_title => 'Об’єднати дублікати манги';

  @override
  String get merge_manga_subtitle =>
      'Знаходить мангу з відповідними назвами в одному джерелі (наприклад, після об’єднання повторюваних джерел) і згортає їх в одне, не видаляючи нічого, що ви хотіли б зберегти.';

  @override
  String get merge_manga_none_found =>
      'Імовірних дублікатів манги не знайдено.';

  @override
  String get merge_manga_pick_title => 'Можливі дублікати манги';

  @override
  String get merge_manga_choose_primary_title =>
      'У який з них мають об’єднатися інші?';

  @override
  String get merge_manga_choose_primary_message =>
      'Розділи, історія та відстеження з інших записів будуть згорнуті в той, який ви виберете — нічого не видаляється.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count розділів',
      one: '1 розділ',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Злиття';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Об’єднано $count дублікатів манги в $mangaName.';
  }

  @override
  String get merge_preview_title => 'Підтвердити злиття';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters розділів, знайдених в інших записах. $duplicateChapters є дублікатами, і їх буде видалено (збереження будь-якої копії, яка має прогрес читання); $keptChapters буде додано. $duplicateTracks повторюваних посилань відстеження також буде видалено.';
  }

  @override
  String get memory_overlay => 'Показати використання пам\'яті';

  @override
  String get memory_overlay_subtitle =>
      'Живе зчитування того, що зберігає додаток. Щоб вимірювати на пристрої, а не вгадувати: дивіться, прокручуючи бібліотеку або читаючи розділ.';

  @override
  String get beta => 'Бета';

  @override
  String get error_reports => 'Звіти про помилки';

  @override
  String get error_reports_subtitle =>
      'Помилки, виявлені програмою, і спосіб повідомити про них';

  @override
  String get error_reports_empty =>
      'Нічого не пішло не так. Помилки, які виявляє програма, зберігаються тут, тому ви можете повідомити про них.';

  @override
  String get error_reports_likely_cause => 'Ймовірна причина';

  @override
  String get error_reports_report => 'Звіт на GitHub';

  @override
  String get error_reports_banner => 'NodeLane Comics сталася помилка';

  @override
  String get error_reports_banner_action => 'Подивіться';

  @override
  String get error_reports_copy => 'Копія';

  @override
  String get error_reports_copied => 'Скопійовано в буфер обміну';

  @override
  String get error_reports_clear => 'Прозоро';

  @override
  String get error_reports_extension_failure =>
      'Це надійшло з розширення, а не з NodeLane Comics. Розширення пише та обслуговує той, хто керує репозиторієм, з якого ви встановили це джерело, тому виправлення має бути там. Назва джерела та те, що ви відкриваєте, є корисними деталями, які потрібно надати.';

  @override
  String get error_reports_already_reported => 'Вже повідомлялося';

  @override
  String get error_reports_expected_failure =>
      'Зазвичай це джерело або мережа, а не програма: посилання, термін дії якого закінчився, сервер, який не працює, або з’єднання, яке обірвалося. Варто повідомляти, лише якщо це продовжує відбуватися з джерела, яке працює в іншому місці.';

  @override
  String get share_unavailable_copied =>
      'Спільний доступ недоступний на цій платформі, тому його було скопійовано в буфер обміну.';

  @override
  String get onboarding_title => 'Ласкаво просимо до NodeLane Comics';

  @override
  String get onboarding_libraries_body =>
      'Вибирайте те, що ви читаєте, і дивіться. Ті, які ви пропускаєте, залишаються поза панеллю навігації, і ви можете змінити це пізніше в розділі «Вигляд».';

  @override
  String get onboarding_nav_title => 'Ваші бібліотеки';

  @override
  String get onboarding_nav_body =>
      'Зберігайте вкладку для кожного з них або об’єднайте їх за однією вкладкою «Бібліотека», яку можна перемикати всередині.';

  @override
  String get onboarding_nav_split => 'По вкладці кожен';

  @override
  String get onboarding_nav_merged => 'Одна вкладка бібліотеки';

  @override
  String get onboarding_nav_inside =>
      'Торкання Бібліотеки змінює смужку на них';

  @override
  String get onboarding_next => 'Далі';

  @override
  String get onboarding_restore => 'Відновити резервну копію';

  @override
  String get onboarding_or_local => 'Або використовуйте файли, які у вас уже є';

  @override
  String get onboarding_local_folder => 'Додати папку';

  @override
  String onboarding_local_existing(Object count) {
    return '$count папок уже налаштовано';
  }

  @override
  String get onboarding_local_any_type =>
      'Манга, аніме та романи працюють. Кожен заголовок потрапляє до відповідної бібліотеки залежно від того, що в ньому міститься.';

  @override
  String get onboarding_local_scanning => 'Сканування папки';

  @override
  String onboarding_local_found(Object count) {
    return 'Знайдено $count назв';
  }

  @override
  String get onboarding_local_remove => 'Видаліть цю папку';

  @override
  String get onboarding_local_in_downloads =>
      'Це папка завантажень програми. Його додавання створює другу локальну копію бібліотеки, якою вже керує програма.';

  @override
  String get onboarding_local_empty =>
      'Нічого не знайдено. Виберіть папку, яка містить ваші папки манги, а не одну мангу.';

  @override
  String get onboarding_repo_failed =>
      'Не вдалося прочитати це сховище. Перевірте адресу та підключення.';

  @override
  String get onboarding_repo_title => 'Додайте джерело';

  @override
  String get onboarding_body =>
      'NodeLane Comics не має власних джерел. Додайте репозиторій, і розширення, які він містить, стануть доступними для встановлення та перегляду.';

  @override
  String get onboarding_add => 'Додати сховище';

  @override
  String get onboarding_skip => 'Наразі пропустити';

  @override
  String get onboarding_continue => 'Продовжуйте';

  @override
  String get onboarding_later =>
      'Ви можете додати його пізніше в налаштуваннях у розділі «Огляд».';

  @override
  String get onboarding_replay => 'Показати екран привітання';

  @override
  String get onboarding_replay_subtitle =>
      'Знову відкриває екран першого запуску, з якого починається нова інсталяція.';

  @override
  String get missing_source_check_title => 'Перевірка відсутніх джерел';

  @override
  String get missing_source_check_subtitle =>
      'Знайдіть записи бібліотеки, чиє розширення не встановлено - відновлення резервної копії може залишити записи, що вказують на джерело, яке ви ніколи не встановлювали на цьому пристрої.';

  @override
  String get missing_source_check_none_found =>
      'Джерело кожного запису бібліотеки встановлено.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Відсутні джерела $count',
      one: 'Відсутнє 1 джерело',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Джерела $itemType не встановлені.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Додайте репозиторій у розділі «Огляд», а потім інсталюйте для нього розширення.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count джерел',
      one: '1 джерело',
    );
    return 'Для цього у вас є $_temp0, але шукаються лише закріплені.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Закріпіть один або вимкніть «Включати лише закріплені джерела» в налаштуваннях перегляду.';

  @override
  String get global_search_all_nsfw =>
      'Кожне джерело, яке ви маєте для цього, позначено NSFW, і вони приховані.';

  @override
  String get global_search_all_nsfw_hint =>
      'Увімкніть джерела NSFW у налаштуваннях перегляду, щоб шукати їх.';

  @override
  String get missing_source_check_result_message =>
      'Ці записи бібліотеки вказують на джерело, яке не встановлено на цьому пристрої. Торкніться одного, щоб перенести його до встановленого джерела, установіть відповідне розширення або скористайтеся функцією «Видалити джерело та його мангу», щоб видалити їх.';

  @override
  String get related_titles => 'Пов\'язане';

  @override
  String get related_none => 'Для цієї назви не знайдено нічого пов’язаного.';

  @override
  String get relation_adaptation => 'Адаптація';

  @override
  String get relation_sequel => 'Продовження';

  @override
  String get relation_prequel => 'Приквел';

  @override
  String get relation_parent => 'Історія батьків';

  @override
  String get relation_side_story => 'Додаткова історія';

  @override
  String get relation_spin_off => 'Побічний ефект';

  @override
  String get relation_alternative => 'Альтернативна версія';

  @override
  String get auto_library_update => 'Автоматичне оновлення бібліотеки';

  @override
  String get auto_library_update_subtitle =>
      'Перевірте кожен запис у своїй бібліотеці на наявність нових розділів під час запуску програми.';

  @override
  String get auto_library_update_never => 'Ніколи';

  @override
  String get auto_library_update_12_hours => 'Кожні 12 годин';

  @override
  String get auto_library_update_daily => 'Щодня';

  @override
  String get auto_library_update_2_days => 'Кожні 2 дні';

  @override
  String get auto_library_update_weekly => 'Щотижня';

  @override
  String get auto_library_update_wifi_only => 'Тільки по Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Пропустити заплановане оновлення під час використання мобільних даних.';

  @override
  String get padding => 'Підкладка';

  @override
  String get page_mode => 'Режим сторінки';

  @override
  String get single_page => 'Одна сторінка';

  @override
  String get double_page => 'Подвійна сторінка';

  @override
  String get speed => 'Швидкість';

  @override
  String get theme_dark => 'Темний';

  @override
  String get theme_light => 'Світло';

  @override
  String get theme_black => 'Чорний';

  @override
  String get theme_sepia => 'Сепія';

  @override
  String get decrease => 'Зменшення';

  @override
  String get increase => 'Збільшення';

  @override
  String get chapter_swipe_actions => 'Дії гортання розділу';

  @override
  String get chapter_swipe_start => 'Проведіть праворуч';

  @override
  String get chapter_swipe_end => 'Проведіть ліворуч';

  @override
  String get chapter_swipe_toggle_bookmark => 'Перемкнути закладку';

  @override
  String get chapter_swipe_toggle_read => 'Перемкнути читання';

  @override
  String get chapter_swipe_download => 'Завантажити';

  @override
  String get chapter_swipe_disabled => 'Вимкнено';

  @override
  String get update_errors => 'Помилки оновлення';

  @override
  String get no_update_errors => 'Немає помилок оновлення';

  @override
  String get clear_all => 'Очистити все';

  @override
  String get dismiss => 'Відхилити';

  @override
  String get previous_episode => 'Попередній епізод';

  @override
  String get clear_logs => 'Очистити журнали';

  @override
  String get bold => 'Жирний';

  @override
  String get italic => 'Курсив';

  @override
  String get color_yellow => 'Жовтий';

  @override
  String get color_cyan => 'Блакитний';

  @override
  String get color_green => 'Зелений';

  @override
  String get color_orange => 'Апельсин';

  @override
  String get continue_watching => 'Продовжуйте перегляд';

  @override
  String get search_your_anime => 'Пошук у вашому аніме';

  @override
  String get category => 'Категорія';

  @override
  String get hidden_categories => 'Приховані категорії';

  @override
  String get new_category => 'Нова категорія';

  @override
  String get local => 'Місцевий';

  @override
  String get tv_home_rows => 'Рядки';

  @override
  String get genre_rows => 'Жанрові ряди';

  @override
  String get share_backup_file =>
      'Поділитися файлом резервної копії NodeLane Comics';

  @override
  String get close => 'Закрити';

  @override
  String get migrate_source => 'Джерело міграції';

  @override
  String get cloudflare_bypass_proxy => 'Обхідний проксі Cloudflare';

  @override
  String get custom_doh_url => 'Власна URL-адреса DoH';

  @override
  String get custom_doh_url_helper =>
      'Має бути кінцевою точкою https DoH (JSON).';

  @override
  String get anime_only_tv_layout => 'Телевізійний макет лише для аніме';

  @override
  String get anime_only_beta => 'Тільки аніме (бета)';

  @override
  String get tv_home_beta => 'TV home (бета)';

  @override
  String get tv_player_beta => 'Телепрогравач (бета)';

  @override
  String get network_settings => 'Мережа';

  @override
  String get reader_page_layout => 'Макет сторінки';

  @override
  String get reader_continuous_options => 'Безперервне читання';

  @override
  String get reader_default_mode_hint =>
      'Стандартний режим читання застосовується до заголовків без індивідуального режиму, встановленого під час читання.';

  @override
  String get extension_service => 'Служба розширення';

  @override
  String get extension_service_description =>
      'Керуйте часом виконання розширення та адресою проксі.';

  @override
  String get proxy_address => 'Адреса проксі';

  @override
  String get checking_runtime_status => 'Перевірка статусу…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds с + випадкова затримка';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count розділів',
      one: '1 розділ',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Додати завантаження зі списку розділів назви.';

  @override
  String get download_queue_order_hint =>
      'Перетягніть маркери, щоб змінити порядок';

  @override
  String get download_queue_empty => 'Немає завантажень у черзі';

  @override
  String get download_queue_actions => 'Дії завантаження';

  @override
  String get download_queue_cancel_chapter =>
      'Скасувати завантаження цього розділу';

  @override
  String get download_queue_cancel_series =>
      'Скасувати всі завантаження для цієї назви';

  @override
  String get download_queue_start => 'Розпочати завантаження';

  @override
  String get download_queue_retry => 'Повторити завантаження';

  @override
  String get download_queue_active => 'Завантаження';

  @override
  String get download_queue_waiting => 'Очікування завантаження';

  @override
  String get download_queue_failed => 'Помилка завантаження';

  @override
  String get cf_proxy_helper =>
      'Кінцева точка FlareSolverr / Byparr. Залиште пустим, щоб вимкнути.';

  @override
  String get mobile_navigation_description =>
      'Перетягніть, щоб змінити порядок. Манга, аніме та романи мають спільну вкладку «Бібліотека». Перший видимий елемент відкривається під час запуску. Перегляд і більше залишаються видимими; додаткові вкладки відображаються в розділі Більше.';

  @override
  String get text_align_justify => 'Обґрунтуйте';

  @override
  String get novel_session_modes_hint =>
      'Встановити режим читання та одну або подвійну сторінку під час читання заголовка.';

  @override
  String get tts_languages_failed =>
      'Не вдалося завантажити мови з мовного механізму.';

  @override
  String get tts_languages_empty =>
      'Механізм мовлення не повернув жодної мови. Ваш збережений вибір зберігається.';

  @override
  String get tts_language_unavailable =>
      'Цієї збереженої мови немає в поточному списку пристрою.';

  @override
  String get tts_apply_failed =>
      'Не вдалося застосувати це налаштування до мовного механізму. Ви можете повторити спробу.';

  @override
  String get player_controls => 'Елементи управління';

  @override
  String get audio_channel_auto => 'Автоматичний';

  @override
  String get audio_channel_auto_safe => 'Автоматичний (безпечний)';

  @override
  String get audio_channel_mono => 'Моно';

  @override
  String get audio_channel_stereo => 'Стерео';

  @override
  String get audio_channel_reverse_stereo => 'Зворотне стерео';

  @override
  String get mpv_bundled_config_hint =>
      'Відновити конфігурацію, сценарії та шейдери, включені в додаток. Файли з однаковими іменами буде перезаписано.';

  @override
  String get mpv_restore_bundled => 'Відновити комплектну конфігурацію';

  @override
  String get mpv_restore_confirm =>
      'Відновити комплектну конфігурацію MPV? Існуючу конфігурацію, сценарії та шейдери з однаковими назвами буде перезаписано. Інші файли будуть збережені.';

  @override
  String get player_operation_incomplete =>
      'Операцію не вдалося завершити. Перевірте доступ до файлу та повторіть спробу.';

  @override
  String get custom_buttons_empty_hint =>
      'Додайте кнопку гравця з міткою та дією натискання.';

  @override
  String get custom_button_primary => 'Кнопка за замовчуванням';

  @override
  String get show_password => 'Показати пароль';

  @override
  String get hide_password => 'Приховати пароль';

  @override
  String get tracking_accounts_empty =>
      'Підключіть службу в налаштуваннях відстеження, щоб керувати її записами.';

  @override
  String get tracking_entries_empty =>
      'Немає відстежених записів для цього типу медіа. Додайте відстеження зі сторінки інформації про назву.';

  @override
  String get change_tracking_match => 'Змінити відповідний заголовок';

  @override
  String get remove_tracking => 'Видалити відстеження';

  @override
  String remove_tracking_confirm(String title) {
    return 'Видалити посилання відстеження для “$title”? Запис у сервісі відстеження буде збережено.';
  }

  @override
  String get tracking_refresh_required =>
      'Не вдалося підтвердити стан відстеження. Оновіть перед внесенням наступних змін.';

  @override
  String get tracking_entry_unlinked =>
      'Цей запис не пов’язано з місцевим заголовком, тому його не можна редагувати тут.';

  @override
  String get backup_selection_shared =>
      'Зміни до цих виборів зберігаються негайно, а також застосовуються до автоматичного резервного копіювання.';

  @override
  String get library_snapshot_history => 'Відновити знімок бібліотеки';

  @override
  String get library_snapshot_empty => 'Миттєві знімки безпеки відсутні.';

  @override
  String get library_snapshot_restore_message =>
      'Поточні дані буде замінено цим знімком. Зміни, внесені з того часу, буде втрачено. Видалені завантаження неможливо відновити. Доступні знімки безпеки буде видалено після успіху.';

  @override
  String get library_maintenance_working => 'Оновлення бібліотеки…';

  @override
  String get library_safety_snapshot_note =>
      'Перед цією операцією буде збережено знімок безпеки. Він не включає завантажені файли.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Записи бібліотеки: $mangaCount. Розділи: $chapterCount. Записи історії: $historyCount. Оновлення: $updateCount.\n\nВиберіть, що залишити нижче.';
  }

  @override
  String get library_delete_pick_message =>
      'Виберіть джерело, щоб переглянути його вміст і параметри видалення.';

  @override
  String get mobile_categories_hint =>
      'Перетягніть, щоб змінити порядок. Відкрийте категорію, щоб перейменувати її або змінити її видимість і оновлення.';

  @override
  String get mobile_category_visible => 'Показати в бібліотеці';

  @override
  String get mobile_category_hidden => 'Приховано від бібліотеки';

  @override
  String get mobile_category_updates => 'Включити в оновлення бібліотеки';

  @override
  String get statistics_watched => 'Дивився';

  @override
  String get calendar_month => 'Місяць';

  @override
  String get calendar_two_weeks => '2 тижні';

  @override
  String get calendar_week => 'Тиждень';

  @override
  String get calendar_show_all_dates => 'Показати всі дати';

  @override
  String get update_check_no_result =>
      'Оновлення, яке можна встановити, не знайдено. Ви можете спробувати ще раз пізніше.';

  @override
  String get release_notes => 'Примітки до випуску';

  @override
  String get no_release_notes => 'Приміток до випуску не надано.';

  @override
  String get downloading_update => 'Завантаження оновлення…';

  @override
  String get preparing_installation => 'Підготовка встановлення…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Виберіть, що читати. Ви можете змінити це пізніше.';

  @override
  String get onboarding_content_title => 'Почніть читати';

  @override
  String get onboarding_mobile_sources_body =>
      'Виберіть спосіб початку або додайте вміст пізніше.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Крок $step з $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'Результати для “$query”';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count джерел',
      one: '1 джерело',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Пошук заголовка призначення.';

  @override
  String get migration_original_item => 'Поточний елемент';

  @override
  String get migration_target_item => 'Вибраний елемент';

  @override
  String get migration_partial_failure =>
      'Операція не завершена. Деякі зміни могли бути збережені. Перш ніж повторити спробу, перевірте цей елемент у своїй бібліотеці.';

  @override
  String get migration_no_categories =>
      'Без категорій. Ви можете додати цей елемент без категорії.';

  @override
  String get mass_migration_select_source => 'Виберіть поточне джерело';

  @override
  String get mass_migration_select_all => 'Вибрати все';

  @override
  String get mass_migration_deselect_all => 'Скасувати вибір усіх';

  @override
  String get mass_migration_needs_review => 'Перегляньте незавершені міграції';

  @override
  String get bookshelf_actions => 'Дії книжкової полиці';

  @override
  String get bookshelf_ignore_filters => 'Ігнорувати фільтри під час пошуку';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Шукайте всі роботи в цій категорії, включаючи ті, що приховані фільтрами.';

  @override
  String get bookshelf_stop_update => 'Зупинити оновлення бібліотеки';

  @override
  String bookshelf_selected_count(int count) {
    return 'Вибрано $count робіт';
  }

  @override
  String get bookshelf_remove_library => 'Зняти з книжкової полиці';

  @override
  String get bookshelf_remove_library_hint =>
      'Видаляє улюблені. Місцеві імпортовані файли також втрачають свою бібліотеку та записи читання.';

  @override
  String get bookshelf_remove_downloads => 'Видалити завантажені файли';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Видаляє завантажені файли, зберігаючи робочу інформацію.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Також видаляє вибрані локальні імпортовані файли та видаляє їх бібліотечні записи. Ці файли не можна відновити тут.';

  @override
  String get bookshelf_remove_incomplete =>
      'Операція не завершена. Деякі роботи чи файли могли бути оброблені. Закрийте це діалогове вікно та перевірте свою книжкову полицю та завантаження, перш ніж продовжити.';

  @override
  String get bookshelf_processing => 'Обробка…';

  @override
  String get bookshelf_mark_read => 'Позначити прочитаним';

  @override
  String get bookshelf_mark_unread => 'Позначити як непрочитане';

  @override
  String get bookshelf_select_all => 'Вибрати все';

  @override
  String get bookshelf_invert_selection => 'Інвертувати виділення';

  @override
  String get bookshelf_settings => 'Налаштування книжкової полиці';

  @override
  String get bookshelf_settings_live =>
      'Зміни фільтрації, сортування та відображення набувають чинності негайно.';

  @override
  String get bookshelf_filter_any => 'Будь-який';

  @override
  String get bookshelf_filter_include => 'Включити';

  @override
  String get bookshelf_filter_exclude => 'Виключити';

  @override
  String get bookshelf_all_sources => 'Усі джерела';

  @override
  String bookshelf_sources_selected(int count) {
    return 'Вибрано $count джерел';
  }

  @override
  String get bookshelf_sort_ascending => 'За зростанням';

  @override
  String get bookshelf_sort_descending => 'Спускається';

  @override
  String get bookshelf_layout => 'Макет книжкової полиці';

  @override
  String get bookshelf_sources_hint =>
      'Не виберіть жодного, щоб показати всі джерела. Зміни застосовуються, коли ви натискаєте «Фільтр».';

  @override
  String get bookshelf_choose_files => 'Виберіть файли';

  @override
  String get bookshelf_import_wait =>
      'Виберіть файл у засобі вибору та дочекайтеся завершення імпорту.';

  @override
  String get bookshelf_import_incomplete =>
      'Імпорт не завершено. Деякі файли вже можуть бути на вашій книжковій полиці. Закрийте це діалогове вікно та перевірте перед повторним імпортом.';

  @override
  String get bookshelf_categories_replace =>
      'Збереження призначає ці категорії для кожної вибраної роботи, замінюючи їхні попередні категорії.';

  @override
  String get bookshelf_categories_hint =>
      'Виберіть одну або більше категорій або залиште вибір порожнім, щоб не призначати жодної.';

  @override
  String get bookshelf_categories_hidden =>
      'Існуючі приховані категорії зберігаються для цієї роботи.';

  @override
  String get bookshelf_categories_incomplete =>
      'Категорії не вдалося зберегти повністю. Закрийте це діалогове вікно та перевірте книжкову полицю перед повторною спробою.';

  @override
  String get bookshelf_categories_none_visible =>
      'Тут недоступні категорії. Відкрийте керування категоріями, щоб переглянути їх.';

  @override
  String get bookshelf_manage_categories => 'Керування категоріями';

  @override
  String get manga_actions => 'Комічні дії';

  @override
  String get manga_download_scope => 'Завантажити розділи';

  @override
  String get manga_download_scope_hint =>
      'Виберіть розділи в поточних фільтрах. Завантажені розділи пропускаються.';

  @override
  String get manga_download_scope_empty =>
      'Жоден розділ не відповідає поточним фільтрам. Закрийте це меню та налаштуйте фільтри розділів.';

  @override
  String get manga_action_incomplete =>
      'Дія не завершена. Перевірте поточний стан перед повторною спробою.';

  @override
  String get chapter_settings => 'Параметри глави';

  @override
  String get chapter_settings_live =>
      'Зміни фільтрації та сортування застосовуються негайно.';

  @override
  String get chapter_scanlators_all => 'Показати всі групи сканатора';

  @override
  String get chapter_scanlators_hint =>
      'Виберіть групи, щоб приховати їхні розділи. Зміни застосовуються, коли ви натискаєте «Фільтр».';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count груп сканатора приховано';
  }

  @override
  String chapter_selected_count(int count) {
    return 'Вибрано $count розділів';
  }

  @override
  String get chapter_add_bookmark => 'Закладка';

  @override
  String get chapter_remove_bookmark => 'Скасувати закладку';

  @override
  String get chapter_read_following => 'Читайте нижче';

  @override
  String get chapter_delete_records => 'Видалити записи розділів';

  @override
  String get chapter_delete_local_hint =>
      'Видаляє вибрані записи розділів і хід читання. Зберігаються оригінали місцевих архівів; завантажені копії очищаються.';

  @override
  String get chapter_delete_last_hint =>
      'Це всі розділи цього коміксу. Якщо їх видалити, комікс також буде видалено з книжкової полиці.';

  @override
  String get chapter_action_incomplete =>
      'Дія не завершена. Можливо, деякі зміни вже збережено. Перш ніж продовжити, закрийте та перевірте розділи та завантаження.';

  @override
  String get reader_display_scope =>
      'До цього коміксу застосовуються режим читання та макет сторінки вручну. Виберіть зміну, щоб повернутися до читання.';

  @override
  String get reader_display_single_only =>
      'Горизонтальне безперервне читання використовує окремі сторінки.';

  @override
  String get reader_display_manual_pages =>
      'Зміна макета сторінки вимикає автоматичне створення двох сторінок для всіх коміксів.';

  @override
  String get reader_display_crop_scope => 'Застосовується до всіх коміксів.';

  @override
  String get reader_chapter_locate => 'Знайти поточний розділ';

  @override
  String get reader_chapter_search => 'Пошук розділів або сканаторів';

  @override
  String get reader_chapter_scope =>
      'Використовує фільтри розділів і порядок сортування комічних деталей. Закладки зберігаються відразу.';

  @override
  String get reader_chapter_current_hidden =>
      'Розділ, який ви читаєте, знаходиться поза поточними фільтрами.';

  @override
  String get reader_chapter_current => 'Читаю зараз';

  @override
  String get reader_chapter_read => 'Read';

  @override
  String get reader_chapter_bookmark_failed =>
      'Не вдалося підтвердити збереження закладки. Закрийте список і перевірте його поточний стан.';

  @override
  String get reader_image_actions => 'Дії зображення';

  @override
  String get reader_image_original =>
      'Використовується повна оригінальна сторінка без перекладу, кадрування чи кольорових фільтрів читача.';

  @override
  String get reader_image_save_ios =>
      'Збережіть у папці Pictures у поточному місці зберігання програми.';

  @override
  String get reader_image_save_android =>
      'Збережіть у папці Pictures/nodelane-comics пристрою.';

  @override
  String get reader_image_share =>
      'Відкрийте аркуш спільного використання системи.';

  @override
  String get reader_image_cover =>
      'Змініть обкладинку цього коміксу після підтвердження.';

  @override
  String get reader_image_cover_limit =>
      'Зображення обкладинки мають бути меншими за 5 Мб. Збереження та спільний доступ залишаються доступними.';

  @override
  String get reader_image_action_failed =>
      'Дію не вдалося підтвердити. Закрийте це меню та перевірте результат перед повторною спробою.';

  @override
  String get reader_settings_book_scope =>
      'Ці налаштування застосовуються лише до цього коміксу.';

  @override
  String get reader_settings_global_scope =>
      'Ці налаштування застосовуються до всіх коміксів і зберігаються негайно.';

  @override
  String get reader_filters => 'Фільтри зображення';

  @override
  String get reader_filter_scope =>
      'Застосовується до всіх коміксів. Змінює відображення для читання без зміни оригінальних зображень.';

  @override
  String get reader_auto_scroll_pause =>
      'Прокручування призупиняється, поки налаштування відкриті.';

  @override
  String get manga_synopsis => 'Синопсис';

  @override
  String manga_author(String author) {
    return 'Автор: $author';
  }

  @override
  String get manga_continue_reading => 'Читати далі';

  @override
  String get reader_settings_title => 'Параметри зчитувача';

  @override
  String get reader_picker_book_scope => 'Тільки для цього коміксу';

  @override
  String get reader_picker_global_scope => 'Застосовується до всіх коміксів';

  @override
  String get reader_picker_apply_hint =>
      'Натисніть, щоб зберегти та повернутися до попереднього рівня.';

  @override
  String get reader_scale_fit_screen_hint =>
      'Розмістити всю сторінку на екрані';

  @override
  String get reader_scale_stretch_hint => 'Заповніть область читання';

  @override
  String get reader_scale_fit_width_hint => 'Підігнати сторінку по ширині';

  @override
  String get reader_scale_fit_height_hint => 'Підігнати сторінку по висоті';

  @override
  String get source_filter_active => 'Застосовано';

  @override
  String get source_filter_apply => 'Застосувати фільтри';

  @override
  String get source_filter_scope =>
      'Фільтри застосовуються лише до цього веб-сайту.';

  @override
  String get source_filter_apply_hint =>
      'Застосуйте фільтри, щоб використовувати свій вибір.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Жанри',
      'author': 'Автор',
      'artist': 'Художник',
      'title': 'Назва',
      'year': 'Рік',
      'tags': 'Теги',
      'format': 'Формат',
      'publisher': 'Видавець',
      'relevance': 'Відповідність',
      'rating': 'Рейтинг',
      'views': 'Перегляди',
      'random': 'Випадковий',
      'all': 'Всі',
      'none': 'Жодного',
      'action': 'Дія',
      'adventure': 'Пригода',
      'comedy': 'Комедія',
      'drama': 'Драма',
      'fantasy': 'Фантазія',
      'romance': 'Романтика',
      'science_fiction': 'Наукова фантастика',
      'slice_of_life': 'Зріз життя',
      'mystery': 'Таємниця',
      'horror': 'Жах',
      'psychological': 'Психологічний',
      'historical': 'Історичний',
      'sports': 'Спорт',
      'supernatural': 'Надприродне',
      'school_life': 'Шкільне життя',
      'tragedy': 'Трагедія',
      'shounen': 'Шунен',
      'shoujo': 'Сьодзьо',
      'seinen': 'Сейнен',
      'josei': 'Хосей',
      'isekai': 'Ісекай',
      'martial_arts': 'Бойові мистецтва',
      'mecha': 'Механіка',
      'music': 'Музика',
      'doujinshi': 'Додзіньші',
      'trending': 'У тренді',
      'new': 'Нове',
      'adult_content': 'Вміст для дорослих',
      'only': 'Тільки',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'Більше параметрів відображення';

  @override
  String get bookshelf_more_display_hint => 'Значки, джерела та категорії';

  @override
  String get bookshelf_download_count => 'Кількість завантажень';

  @override
  String get bookshelf_source_global_hint =>
      'Видимість джерела використовує параметри загального відображення.';

  @override
  String get bookshelf_select_entries => 'Вибрані твори';

  @override
  String get bookshelf_search_options => 'Параметри пошуку';

  @override
  String get bookshelf_empty_hint =>
      'Збирайте роботи з джерел або імпортуйте локальні файли.';

  @override
  String get bookshelf_no_match_hint =>
      'Спробуйте інші ключові слова або налаштуйте поточні фільтри.';

  @override
  String get bookshelf_clear_query => 'Очистити ключові слова';

  @override
  String get bookshelf_view_selection => 'Переглянути вибрані роботи';

  @override
  String get bookshelf_import_formats =>
      'Виберіть локальний файл, щоб додати його на свою книжкову полицю.';

  @override
  String get bookshelf_import_canceled_hint =>
      'Ви можете вибрати знову після скасування засобу вибору файлів.';

  @override
  String get bookshelf_browse_sources => 'Огляд джерел';

  @override
  String get bookshelf_empty_title => 'Ваша книжкова полиця порожня';

  @override
  String get bookshelf_no_match_title => 'Немає відповідних результатів';

  @override
  String get bookshelf_mark_watched => 'Марк спостерігав';

  @override
  String get bookshelf_mark_unwatched => 'Позначити як непереглянуте';

  @override
  String get nodelane_account => 'NodeLane';

  @override
  String get nodelane_sign_in => 'Увійдіть до NodeLane';

  @override
  String get nodelane_account_intro =>
      'Перегляд вашого облікового запису, підписки та квоти перекладу';

  @override
  String get nodelane_login_action => 'Продовжити вхід';

  @override
  String get nodelane_login_browser =>
      'Увійдіть через системний браузер, а потім поверніться до програми';

  @override
  String get nodelane_account_id => 'Ідентифікатор облікового запису';

  @override
  String get nodelane_account_init_error =>
      'Сховище облікового запису недоступне. Перезапустіть програму та повторіть спробу.';

  @override
  String get nodelane_account_refresh_error =>
      'Не вдалося оновити інформацію облікового запису';

  @override
  String get nodelane_account_auth_error =>
      'Ваш сеанс закінчився. Увійдіть знову';

  @override
  String get nodelane_account_unknown => 'Інформація про підписку недоступна';

  @override
  String get nodelane_account_current => 'Поточна підписка';

  @override
  String get nodelane_account_free => 'Безкоштовний акаунт';

  @override
  String get nodelane_account_no_subscription => 'Немає активної підписки';

  @override
  String get nodelane_account_active => 'Активний';

  @override
  String get nodelane_account_expired => 'Термін дії минув';

  @override
  String get nodelane_account_expiry => 'Дійсний до';

  @override
  String get nodelane_account_renewal => 'Оновлення';

  @override
  String get nodelane_renewal_auto => 'Автоматичне оновлення';

  @override
  String get nodelane_renewal_manual => 'Оновлення вручну';

  @override
  String get nodelane_renewal_stopped => 'Автоматичне оновлення зупинено';

  @override
  String get nodelane_renewal_gift => 'Подарункове членство';

  @override
  String get nodelane_renewal_attention =>
      'Перевірте статус поновлення на веб-сайті';

  @override
  String get nodelane_next_billing => 'Наступна дата виставлення рахунку';

  @override
  String get nodelane_billing_unavailable =>
      'Інформація про оновлення недоступна';

  @override
  String get nodelane_manage_account => 'Керування на веб-сайті';

  @override
  String get nodelane_view_plans => 'Переглянути плани підписки';

  @override
  String get nodelane_translation_quota => 'Квота перекладу';

  @override
  String get nodelane_quota_free => 'Безкоштовна квота';

  @override
  String get nodelane_quota_subscription => 'Квота підписки';

  @override
  String get nodelane_quota_purchase => 'Придбана квота';

  @override
  String get nodelane_quota_details => 'Переглянути деталі квоти';

  @override
  String get nodelane_quota_expanded => 'Деталі квоти';

  @override
  String get nodelane_quota_unlimited => 'Необмежено';

  @override
  String get nodelane_quota_not_subscribed => 'Не підписаний';

  @override
  String get nodelane_quota_unknown => 'Недоступний';

  @override
  String get nodelane_quota_used => 'Б';

  @override
  String get nodelane_quota_reserved => 'В процесі';

  @override
  String get nodelane_quota_reset => 'Наступне скидання';

  @override
  String get nodelane_quota_expiry => 'Наступний термін дії';

  @override
  String get nodelane_quota_no_expiry => 'Немає терміну придатності';

  @override
  String get nodelane_quota_reservation_note =>
      'Незавершені сторінки вже вираховуються з доступної квоти';

  @override
  String nodelane_quota_available(int count) {
    return 'Залишилося $count сторінок';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count сторінок';
  }

  @override
  String get nodelane_sign_out => 'Вийти';

  @override
  String get nodelane_sign_out_confirm =>
      'Вихід призупиняє офіційний переклад на цьому пристрої. Ваша бібліотека та прогрес читання зберігаються.';

  @override
  String get settings_search_hint => 'Налаштування пошуку';

  @override
  String get settings_frequent => 'Часто використовується';

  @override
  String get settings_reading_translation => 'Читання та переклад';

  @override
  String get settings_app_preferences => 'Налаштування програми';

  @override
  String get settings_data_management => 'Дані та управління';

  @override
  String get settings_more_tools => 'Більше інструментів';

  @override
  String get settings_more_tools_hint => 'Категорії, статистика та календар';

  @override
  String get settings_appearance_interface => 'Зовнішній вигляд та інтерфейс';

  @override
  String get settings_security_privacy => 'Безпека та конфіденційність';

  @override
  String get settings_source_preferences => 'Налаштування джерела';

  @override
  String get settings_about_help => 'Про та допомога';

  @override
  String get settings_storage_backup => 'Зберігання та резервне копіювання';

  @override
  String settings_pending_downloads(int count) {
    return '$count очікує на розгляд';
  }

  @override
  String get settings_translation_language => 'Мова перекладу';

  @override
  String get settings_translation_scope =>
      'Використовується в програмі читання та перекладі веб-сторінок';

  @override
  String get settings_immediate_choice => 'Зміни застосовуються негайно';

  @override
  String get settings_translation_init_error =>
      'Налаштування перекладу недоступні. Перезапустіть програму та повторіть спробу.';

  @override
  String get settings_local_cache => 'Локальний кеш';

  @override
  String get settings_chapter_cache => 'Кеш розділів і епізодів';

  @override
  String get settings_cover_cache => 'Кеш обкладинки';

  @override
  String get settings_translation_cache => 'Кеш перекладених зображень';

  @override
  String get settings_translation_cache_hint =>
      'Зберігайте записи перекладу та за потреби знову витягуйте перекладені зображення';

  @override
  String get settings_cache_clear => 'Прозоро';

  @override
  String get settings_translation_cache_done =>
      'Кеш перекладеного зображення очищено; зберігаються записи перекладів';

  @override
  String settings_cache_confirmation(String name) {
    return 'Очистити $name? Кешований вміст можна отримати знову. Бібліотечні записи будуть збережені.';
  }

  @override
  String get settings_advanced_options => 'Розширені параметри';

  @override
  String get settings_manga_reader => 'Читачка манги';

  @override
  String get settings_novel_reader => 'Читанка романів';

  @override
  String get settings_downloads => 'Налаштування завантаження';

  @override
  String get onboarding_welcome => 'Ласкаво просимо до';

  @override
  String get onboarding_reading_content => 'Читання вмісту';

  @override
  String get onboarding_choose_one => 'Виберіть принаймні один';

  @override
  String get onboarding_restore_hint =>
      'Відновіть бібліотеку з резервної копії';

  @override
  String get onboarding_browse_hint =>
      'Знайти заголовки на підтримуваних веб-сайтах';

  @override
  String get onboarding_import_folder => 'Імпорт локальної папки';

  @override
  String get onboarding_import_folder_hint =>
      'Читайте мангу, романи та аніме на своєму пристрої';

  @override
  String get onboarding_third_party => 'Додайте сторонній репозиторій';

  @override
  String get onboarding_third_party_hint =>
      'Використовуйте адресу сховища, яку ви вже маєте';

  @override
  String get onboarding_repository_hint => 'Введіть адресу, надану сховищем.';

  @override
  String get onboarding_repository_address => 'Адреса';

  @override
  String get onboarding_repository_address_hint => 'Введіть адресу сховища';

  @override
  String get onboarding_add_repository => 'Додати сховище';

  @override
  String get onboarding_start => 'Почніть';

  @override
  String get onboarding_open_library => 'Відкрита бібліотека';

  @override
  String get onboarding_view_imports => 'Перегляд імпортованого вмісту';

  @override
  String get onboarding_view_folders => 'Перегляд папок';

  @override
  String get notice_backup_created => 'Резервну копію створено';

  @override
  String get notice_backup_ready =>
      'Збережіть або поділіться файлом резервної копії.';

  @override
  String get notice_backup_restored => 'Резервну копію відновлено';

  @override
  String get notice_backup_unsupported =>
      'Цей формат резервної копії не підтримується.';

  @override
  String get notice_verification_required => 'Потрібна перевірка веб-сайту';

  @override
  String get notice_verification_hint =>
      'Завершіть перевірку, щоб продовжити перегляд.';

  @override
  String get notice_verify => 'Підтвердити веб-сайт';

  @override
  String get notice_action_incomplete =>
      'Дія не завершена. Перевірте його результат перед повторною спробою.';

  @override
  String get notice_library_updating => 'Оновлення бібліотеки';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'Перевірено $current / $total заголовків';
  }

  @override
  String get notice_library_failed => 'Деякі заголовки не вдалося оновити';

  @override
  String get notice_import_completed => 'Імпорт завершено';

  @override
  String get notice_operation_incomplete => 'Дія не завершена';

  @override
  String get subtitle_service => 'Сервіс онлайн-субтитрів';

  @override
  String get subtitle_service_mode => 'Джерело субтитрів';

  @override
  String get subtitle_service_disabled =>
      'Вимк. · очистити збережені облікові дані';

  @override
  String get subtitle_personal_key => 'Мій ключ Wyzie';

  @override
  String get subtitle_custom_service => 'Моя служба субтитрів';

  @override
  String get subtitle_key => 'Wyzie API Ключ';

  @override
  String get subtitle_key_hint =>
      'Введіть власний ключ Wyzie. Він залишається на цьому пристрої та не включається в резервні копії програми.';

  @override
  String get subtitle_get_key => 'Отримати особистий ключ';

  @override
  String get subtitle_service_address => 'Пошук субтитрів URL';

  @override
  String get subtitle_service_token =>
      'Маркер доступу до служби (необов’язково)';

  @override
  String get subtitle_custom_hint =>
      'Використовуйте повний HTTPS пошук URL служби Wyzie-compatible, включаючи шлях до неї (наприклад, /search). Введіть маркер доступу, лише якщо він потрібен вашій службі.';

  @override
  String get subtitle_service_off_hint =>
      'Онлайн-пошук субтитрів вимкнено. Вбудовані субтитри, субтитри, надані джерелом, і місцеві субтитри залишаються доступними.';

  @override
  String get subtitle_setup_required =>
      'Виберіть послугу субтитрів перед пошуком.';

  @override
  String get subtitle_invalid_key => 'Введіть ключ без пробілів.';

  @override
  String get subtitle_invalid_address =>
      'Використовуйте повний HTTPS URL без запиту, фрагмента чи вбудованих облікових даних.';

  @override
  String get subtitle_invalid_token =>
      'Маркер доступу не може містити пробіли.';

  @override
  String get subtitle_storage_failed =>
      'Не вдалося прочитати або зберегти налаштування субтитрів. Спробуйте ще раз.';

  @override
  String get subtitle_auth_failed =>
      'Служба субтитрів відмовила в доступі. Перевірте свій ключ або маркер служби.';

  @override
  String get subtitle_quota_exhausted =>
      'Квота служби субтитрів вичерпана. Перевірте свій обліковий запис у цьому сервісі.';

  @override
  String get subtitle_network_failed =>
      'Не вдалося отримати доступ до служби субтитрів. Спробуйте ще раз.';

  @override
  String get subtitle_response_invalid =>
      'Служба субтитрів повернула непідтримувану відповідь або файл.';

  @override
  String get detail_loading_chapters => 'Завантаження розділів…';

  @override
  String get reader_opening_chapter => 'Початковий розділ';

  @override
  String get reader_open_chapter => 'Відкритий розділ';

  @override
  String get reader_loading_pages => 'Отримання зображень розділів…';

  @override
  String get reader_loading_pages_hint =>
      'Зчитування розпочнеться автоматично, коли буде готове.';

  @override
  String get reader_loading_failed => 'Не вдалося завантажити цю главу';

  @override
  String get reader_loading_retry_hint =>
      'Перевірте підключення та повторіть спробу.';

  @override
  String get reader_no_pages => 'Для цього розділу не знайдено зображень';

  @override
  String get reader_loading_previous => 'Завантаження попереднього розділу…';

  @override
  String get reader_previous_failed =>
      'Не вдалося завантажити попередній розділ';

  @override
  String get reader_reached_start => 'Ви дійшли до першого розділу';

  @override
  String get reader_loading_next => 'Завантаження наступної глави…';

  @override
  String get reader_next_failed => 'Не вдалося завантажити наступний розділ';

  @override
  String get reader_image_loading => 'Завантаження зображення…';

  @override
  String get reader_image_failure_hint =>
      'Ви можете продовжувати читати інші сторінки.';

  @override
  String get comic_paged => 'Сторінка за сторінкою';

  @override
  String get comic_scroll => 'Прокрутіть вниз';

  @override
  String get comic_book_scope =>
      'Застосовується лише до цієї книги · зміни зберігати негайно';

  @override
  String get comic_defaults_title => 'Типові налаштування та звички';

  @override
  String get comic_defaults_hint =>
      'Значення за замовчуванням застосовуються до полів, які ви не налаштували для книги.';

  @override
  String get comic_habits_hint => 'Ці звички стосуються кожного коміксу.';

  @override
  String get comic_turn => 'Перейдіть до наступної сторінки';

  @override
  String get comic_left => 'Ліворуч';

  @override
  String get comic_right => 'Правильно';

  @override
  String get comic_up => 'Вгору';

  @override
  String get comic_fit => 'Підгонка сторінки';

  @override
  String get comic_fit_contain => 'Ціла сторінка';

  @override
  String get comic_fit_width => 'Підходить ширина';

  @override
  String get comic_fit_height => 'Відповідна висота';

  @override
  String get comic_layout => 'Макет сторінки';

  @override
  String get comic_auto => 'Авто';

  @override
  String get comic_layout_hint =>
      'Авто показує розкид, коли є достатня ширина.';

  @override
  String get comic_width => 'Ширина вмісту';

  @override
  String get comic_full => 'Повний';

  @override
  String get comic_comfortable => 'Зручно';

  @override
  String get comic_narrow => 'Вузький';

  @override
  String get comic_gap => 'Інтервал між сторінками';

  @override
  String get comic_no_gap => 'Безшовні';

  @override
  String get comic_small_gap => 'Маленький';

  @override
  String get comic_image_title => 'Тонка настройка зображення';

  @override
  String get comic_image_hint => 'Обтинання та тон впливають лише на цю книгу.';

  @override
  String get comic_wide => 'Широкі сторінки';

  @override
  String get comic_intact => 'Зберігати цілим';

  @override
  String get comic_split => 'Спліт';

  @override
  String get comic_rotate => 'Обертання';

  @override
  String get comic_wide_hint =>
      'Поділ відбувається за напрямком перегортання сторінки. Застосовується для читання однієї сторінки.';

  @override
  String get comic_cover => 'Одна обкладинка на главу';

  @override
  String get comic_effects_reset => 'Скидання налаштувань зображення';

  @override
  String get comic_book_reset => 'Відновити стандартні налаштування книги';

  @override
  String get comic_book_reset_hint =>
      'Очищає спеціальні налаштування читання цієї книги. Переклад без змін.';

  @override
  String get comic_canvas => 'Фон читача';

  @override
  String get comic_system => 'Система';

  @override
  String get comic_black => 'Чорний';

  @override
  String get comic_gray => 'Сірий';

  @override
  String get comic_paper => 'Папір';

  @override
  String get comic_tap => 'Натисніть, щоб гортати сторінки';

  @override
  String get comic_tap_hint =>
      'Торкайтеся країв, щоб рухатися; торкніться центру, щоб показати елементи керування.';

  @override
  String get comic_scroll_start => 'Почати автоматичне прокручування';

  @override
  String get comic_scroll_pause => 'Призупинити автоматичне прокручування';

  @override
  String get comic_scroll_speed => 'Швидкість прокручування';

  @override
  String get comic_scroll_hint =>
      'Починається, коли ця панель закривається. Призупиняється, коли програма виходить на передній план.';

  @override
  String get comic_save_failed => 'Не вдалося зберегти. Спробуйте ще раз.';

  @override
  String get comic_reading => 'Читання';

  @override
  String get comic_chapter_habits_hint =>
      'Звички щодо списку розділів застосовуються до всіх книг.';

  @override
  String get browser_title => 'Браузер';

  @override
  String get translation_image_display => 'Дисплей зображення';

  @override
  String get translation_display_hint =>
      'Спочатку покажіть існуючі переклади. Зберігайте оригінал, якщо немає перекладу.';

  @override
  String get translation_sign_in_required => 'Увійдіть, щоб увімкнути переклад';

  @override
  String get translation_sign_in_hint =>
      'Після входу перейдіть до перекладених зображень для автоматичного перекладу.';

  @override
  String get translation_automatic => 'Автоматичний переклад';

  @override
  String get translation_original_hint =>
      'Показ оригіналів. Перейдіть до перекладених зображень для автоматичного перекладу.';

  @override
  String get translation_window_hint =>
      'Обробляти поточні та майбутні зображення лише під час показу перекладів.';

  @override
  String get translation_channel => 'Канал перекладу';

  @override
  String get translation_no_images =>
      'На цій сторінці ще не знайдено зображень, які можна перекладати';

  @override
  String get translation_waiting_image => 'Очікування поточного зображення';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues зображення потребують уваги',
      many: ' · $issues зображень потребують уваги',
      few: ' · $issues зображення потребують уваги',
      one: ' · $issues зображення потребує уваги',
      zero: '',
    );
    return 'Оброблено зображень: $complete / $total$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'Торкніться й утримуйте зображення для інших дій, у тому числі для повторного перекладу.';

  @override
  String get translation_title => 'Переклад манги';

  @override
  String get translation_system_sign_in =>
      'Увійдіть за допомогою системного браузера';

  @override
  String get translation_target_language => 'Цільова мова';

  @override
  String get translation_clear_cache => 'Очистити кеш перекладених зображень';

  @override
  String get translation_cache_hint =>
      'Зберігайте записи перекладів і за потреби знову витягайте результати.';

  @override
  String get translation_saved_read_failed =>
      'Не вдалося завантажити збережений переклад';

  @override
  String get translation_read_failed =>
      'Не вдалося завантажити перекладене зображення';

  @override
  String get operation_retry => 'Дія не завершена. Спробуйте ще раз.';

  @override
  String get translation_original => 'Оригінал';

  @override
  String get translation_translated => 'Переклад';

  @override
  String get translation_regenerate_image => 'Перекладіть це зображення ще раз';

  @override
  String get translation_read_image => 'Перезавантажити перекладене зображення';

  @override
  String get translation_image_actions => 'Більше дій із зображеннями';

  @override
  String get translation_processing => 'Обробка';

  @override
  String get translation_reading => 'Завантаження перекладеного зображення';

  @override
  String get translation_waiting => 'Очікування перекладу';

  @override
  String get translation_preparing => 'Готується переклад';

  @override
  String get translation_uploading => 'Завантаження оригіналу';

  @override
  String get translation_running => 'Переклад';

  @override
  String get translation_uncertain => 'Статус потребує перевірки';

  @override
  String get translation_failed => 'Помилка перекладу';

  @override
  String get translation_verify => 'Перевірити';

  @override
  String get translation_reread => 'Перезавантажити';

  @override
  String get browser_back => 'Назад';

  @override
  String get browser_translation => 'Переклад веб-сторінки';

  @override
  String get browser_new_tab_action => 'Відкрити нову вкладку';

  @override
  String get browser_current_tab => 'Струм';

  @override
  String get browser_close_tab => 'Закрити вкладку';

  @override
  String get browser_new_tab => 'Нова вкладка';

  @override
  String get browser_page => 'Веб-сторінка';

  @override
  String get browser_unopened => 'Сторінка ще не відкрита';

  @override
  String get browser_address_hint => 'Введіть або вставте URL';

  @override
  String get browser_invalid_address => 'Введіть дійсний URL';

  @override
  String get browser_clear_address => 'Очистити URL';

  @override
  String get browser_paste_address => 'Вставити URL';

  @override
  String get browser_open_address => 'Відкрити URL';

  @override
  String browser_tab_count(int count) {
    return 'Вкладки · $count';
  }

  @override
  String get browser_load_failed => 'Не вдалося відкрити цю сторінку';

  @override
  String get browser_load_failed_hint => 'Перевірте підключення та URL.';

  @override
  String get browser_edit_address => 'Редагувати URL';

  @override
  String get browser_clear_cookies_confirm =>
      'Очистити сеанси входу для всіх веб-сайтів?';

  @override
  String get browser_clear_cookies_hint =>
      'Веб-сайти на всіх вкладках можуть вимагати повторного входу.';

  @override
  String get browser_clear_cookies_action => 'Очистити сеанси входу';

  @override
  String get browser_tab_limit =>
      'Ви можете тримати відкритими до 12 вкладок. Спочатку закрийте один.';

  @override
  String get browser_forward => 'Вперед';

  @override
  String get browser_clear_all_cookies =>
      'Очистити всі сеанси входу на веб-сайті';

  @override
  String get browser_clear_failed =>
      'Не вдалося очистити сесії. Спробуйте ще раз.';

  @override
  String get browser_save_failed =>
      'Не вдалося зберегти вкладки. Спробуйте ще раз.';

  @override
  String get browser_tabs_full => '12 вкладок вже відкрито';

  @override
  String get browser_no_tabs => 'Ще немає відкритих вкладок';

  @override
  String get browser_close_failed =>
      'Не вдалося зберегти вкладки. Натисніть «Закрити» ще раз, щоб повторити спробу.';

  @override
  String get source_pinned_websites => 'Закріплені веб-сайти';

  @override
  String get manage => 'Керувати';

  @override
  String get translation_settings_hint =>
      'Автоматичний переклад, цільова мова та канал';

  @override
  String get translation_show_original => 'Торкніться, щоб показати оригінал';

  @override
  String get translation_show_translated => 'Натисніть, щоб показати переклад';

  @override
  String get source_display => 'Дисплей';

  @override
  String get source_cover_title => 'Обкладинка та назва';

  @override
  String get source_cover_only => 'Тільки обкладинка';

  @override
  String get source_save_search => 'Зберегти поточний пошук';

  @override
  String get source_saved_searches => 'Збережені пошуки';

  @override
  String get source_website_info => 'Інформація про веб-сайт';

  @override
  String source_saved_search_title(String title) {
    return '$title · Натисніть, щоб шукати';
  }

  @override
  String get action_done => 'Готово';

  @override
  String source_search_keyword(String query) {
    return 'Ключове слово: $query';
  }

  @override
  String get source_no_saved_searches => 'Ще немає збережених пошуків';

  @override
  String get source_save_search_hint =>
      'Знайдіть ключове слово, а потім збережіть його з дій веб-сайту.';

  @override
  String get source_saved_search_scope =>
      'Ключові слова зберігаються лише для цього веб-сайту.';

  @override
  String get source_search_here => 'Пошук заголовків на цьому веб-сайті';

  @override
  String get source_filter_results => 'Відфільтровані результати';

  @override
  String get source_search_results => 'Результати пошуку';

  @override
  String get source_return_popular => 'Повернутися до популярного';

  @override
  String get source_popular_titles => 'Популярні назви';

  @override
  String get source_no_titles => 'Відповідних назв не знайдено';

  @override
  String get source_no_titles_hint =>
      'Змініть ключові слова чи фільтри або поверніться до популярних заголовків.';

  @override
  String get source_load_more_failed =>
      'Не вдалося завантажити більше. Спробуйте ще раз.';

  @override
  String get source_load_pull_retry =>
      'Не вдалося завантажити цей веб-сайт. Потягніть вниз, щоб повторити спробу.';

  @override
  String get source_clear_failed =>
      'Не вдалося завершити очищення. Спробуйте ще раз.';

  @override
  String get source_uninstall_failed =>
      'Не вдалося завершити видалення. Спробуйте ще раз.';

  @override
  String get source_details => 'Деталі джерела';

  @override
  String get source_repository_website => 'Веб-сайт репозиторію';

  @override
  String get source_provided_settings => 'Параметри, надані джерелом';

  @override
  String get source_advanced_actions => 'Розширені дії';

  @override
  String get source_edit_metadata => 'Редагувати вихідну інформацію';

  @override
  String get source_clear_cookies =>
      'Очистити файли cookie для цього веб-сайту';

  @override
  String get source_clear_cookies_hint =>
      'Можливо, під час наступного візиту вам доведеться ввійти знову.';

  @override
  String get source_uninstall => 'Видалити джерело';

  @override
  String get source_settings_save_failed =>
      'Збереження не завершено. Повторно відкрийте налаштування джерела, щоб перевірити.';

  @override
  String get repository_third_party => 'Сторонні репозиторії';

  @override
  String get repository_refresh_failed =>
      'Не вдалося оновити каталог. Кешований вміст зберігається. Спробуйте ще раз.';

  @override
  String get repository_show_sources => 'Показати джерела з цього сховища';

  @override
  String get repository_copy_catalog => 'Копіювати посилання на каталог';

  @override
  String get repository_remove => 'Видалити сховище';

  @override
  String get repository_remove_hint =>
      'Зберігайте встановлені джерела та видаляйте невстановлені записи каталогу.';

  @override
  String get repository_empty => 'Ще не додано сторонніх репозиторіїв';

  @override
  String get repository_built_in => 'Вбудований офіційний каталог';

  @override
  String get repository_hidden => 'Прихований';

  @override
  String get repository_refreshing => 'Оновлення…';

  @override
  String get repository_refresh => 'Оновити каталог';

  @override
  String get repository_manage_hint =>
      'Керуйте джерелами завантаження сторонніх розробників.';

  @override
  String get repository_invalid_address => 'Введіть дійсний HTTP або HTTPS URL';

  @override
  String get repository_already_added => 'Це сховище вже додано';

  @override
  String get repository_unrecognized =>
      'Підтримуваний каталог не знайдено. Перевірте посилання та повторіть спробу.';

  @override
  String get repository_read_failed =>
      'Не вдалося прочитати каталог. Спробуйте ще раз.';

  @override
  String get repository_save_failed =>
      'Збереження не завершено. Перевірте свій список сховищ.';

  @override
  String get repository_paste_hint =>
      'Вставте посилання на каталог стороннього сховища';

  @override
  String get repository_address => 'URL';

  @override
  String get repository_paste_link => 'Вставити посилання';

  @override
  String repository_recognized(String type) {
    return '$type · Каталог визнано';
  }

  @override
  String get repository_choose_sources_hint =>
      'Після додавання репозиторію виберіть потрібні джерела.';

  @override
  String get search_scope => 'Обсяг пошуку';

  @override
  String get search_scope_hint => 'Виберіть веб-сайти для пошуку';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Пошук на $count сайта',
      many: 'Пошук на $count сайтах',
      few: 'Пошук на $count сайтах',
      one: 'Пошук на $count сайті',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Знайдіть веб-сайт';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вибрано $count сайта',
      many: 'Вибрано $count сайтів',
      few: 'Вибрано $count сайти',
      one: 'Вибрано $count сайт',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Прозоро';

  @override
  String get search_deselect_results => 'Скасуйте вибір відповідних веб-сайтів';

  @override
  String get search_select_results => 'Виберіть відповідні веб-сайти';

  @override
  String get search_no_websites_hint =>
      'Немає відповідних веб-сайтів. Спробуйте іншу назву чи мову.';

  @override
  String get search_select_website_hint =>
      'Виберіть принаймні один веб-сайт для пошуку.';

  @override
  String get search_start_title =>
      'Введіть ключові слова, щоб знайти заголовки';

  @override
  String get search_start_hint =>
      'Шукайте на кількох веб-сайтах одночасно та показуйте відповідні заголовки.';

  @override
  String get search_empty_scope =>
      'У цьому обсязі немає веб-сайтів з можливістю пошуку';

  @override
  String get search_empty_scope_hint =>
      'Перейдіть на всі веб-сайти або виберіть веб-сайти для пошуку.';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count результата',
      many: '$count результатів',
      few: '$count результати',
      one: '$count результат',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'Пошук заголовків';

  @override
  String get search_actions => 'Пошукові дії';

  @override
  String get search_details => 'Деталі пошуку';

  @override
  String get search_title_hint => 'Пошук за назвою';

  @override
  String get search_searching => 'Пошук';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Знайдено $count результата',
      many: 'Знайдено $count результатів',
      few: 'Знайдено $count результати',
      one: 'Знайдено $count результат',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'Немає відповідних результатів';

  @override
  String get search_failed => 'Помилка пошуку';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Знайдено $count назв',
      one: 'Знайдено 1 назву',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: '$websites websites',
      one: '1 веб-сайт',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Пошук заголовків';

  @override
  String get search_complete => 'Пошук завершено';

  @override
  String get search_in_progress => 'Пошук';

  @override
  String get search_finding_related => 'Пошук відповідних назв…';

  @override
  String get search_no_results_yet => 'Результатів пошуку ще немає';

  @override
  String get search_no_matching_titles => 'Відповідних назв не знайдено';

  @override
  String get search_results_appear_hint =>
      'Результати з’являтимуться тут, коли їх буде знайдено.';

  @override
  String get search_failed_websites_hint =>
      'Деякі веб-сайти не можуть завершити пошук. Повторіть спробу в деталях пошуку.';

  @override
  String get search_change_keywords_hint =>
      'Спробуйте коротші ключові слова або знайдіть більше веб-сайтів.';

  @override
  String get search_view_details => 'Переглянути деталі пошуку';

  @override
  String get search_adjust_scope => 'Налаштувати область пошуку';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count websites',
      one: '1 веб-сайт',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Completed $completed / $total';
  }

  @override
  String get search_retry_website_hint =>
      'Повторіть спробу окремо для невдалих веб-сайтів';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вибрано $count елемента',
      many: 'Вибрано $count елементів',
      few: 'Вибрано $count елементи',
      one: 'Вибрано $count елемент',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Пошук мов';

  @override
  String get source_deselect => 'Deselect';

  @override
  String get source_select => 'Виберіть джерело';

  @override
  String get source_multilingual => 'Multilingual';

  @override
  String get source_language_unknown => 'Мова не вказана';

  @override
  String get source_adult_content => 'Містить вміст 18+';

  @override
  String get source_classification_unknown => 'Класифікація не визначена';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Переглянути всю інформацію про джерело, $count більше категорій',
      one: 'Переглянути всю інформацію про джерело, ще 1 категорія',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Завантаження веб-сайту';

  @override
  String get source_unpin => 'Відкріпити';

  @override
  String get source_pin => 'Булавка';

  @override
  String get source_open => 'Open';

  @override
  String get source_metadata_hint =>
      'Інформація надходить з вихідного каталогу. Категорії описують вміст веб-сайту.';

  @override
  String get source_region => 'Область';

  @override
  String get source_format => 'Формат';

  @override
  String get source_creation => 'Creation';

  @override
  String get source_unspecified => 'Не вказано';

  @override
  String get source_pricing => 'Ціноутворення';

  @override
  String get source_region_jp => 'Японські комікси';

  @override
  String get source_region_kr => 'Корейські комікси';

  @override
  String get source_region_cn => 'Китайські комікси';

  @override
  String get source_region_hk_tw => 'Комікси Гонконгу та Тайваню';

  @override
  String get source_region_western => 'Вестерн-комікси';

  @override
  String get source_region_other => 'Інші регіони';

  @override
  String get source_format_page => 'Страничні комікси';

  @override
  String get source_format_vertical => 'Вертикальні комікси';

  @override
  String get source_format_strip => 'Комікси';

  @override
  String get source_creation_original => 'Оригінал';

  @override
  String get source_creation_fan => 'Вентилятор працює';

  @override
  String get source_free_watch => 'Дивитися безкоштовно';

  @override
  String get source_free_read => 'Вільний для читання';

  @override
  String get source_partial_paid => 'Частково оплачено';

  @override
  String get source_paid_watch => 'Платний перегляд';

  @override
  String get source_paid_read => 'Платне читання';

  @override
  String get source_pricing_unknown => 'Ціна не вказана';

  @override
  String get source_language_filter => 'Фільтрувати за мовою';

  @override
  String get source_language_filter_hint =>
      'Відфільтрувати лише цей каталог. Встановлені джерела не впливають.';

  @override
  String get source_all_languages => 'Усі мови';

  @override
  String get action_apply => 'Застосувати';

  @override
  String get source_load_retry =>
      'Не вдалося завантажити цей веб-сайт. Спробуйте ще раз.';

  @override
  String get source_catalog_refresh_failed =>
      'Не вдалося оновити каталог. Поточний вміст зберігається. Потягніть вниз, щоб повторити спробу.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Видалити джерела $count?',
      one: 'Видалити 1 джерело?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Видалити вибрані джерела та очистити їхні налаштування. Зберігайте бібліотечні назви та завантаження.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не вдалося виконати дії для $count джерел.',
      one: 'Не вдалося виконати дію для 1 джерела.',
    );
    return '$_temp0 Вибір збережено. Спробуйте ще раз.';
  }

  @override
  String get source_latest_content => 'Останній вміст';

  @override
  String get source_actions => 'Дії джерела';

  @override
  String get source_bulk_manage => 'Керування кількома джерелами';

  @override
  String get source_update_installed => 'Оновлення встановлених джерел';

  @override
  String get source_no_matching_websites => 'Немає відповідних веб-сайтів';

  @override
  String get source_no_websites => 'Немає доступних веб-сайтів';

  @override
  String get source_search_installed_hint =>
      'Пошук заголовків у встановлених джерелах';

  @override
  String get source_global_search => 'Пошук у джерелах';

  @override
  String get source_manage_repositories => 'Керування сховищами';

  @override
  String get source_view_third_party => 'Переглянути сторонні джерела';

  @override
  String get source_catalog_load_failed =>
      'Не вдалося завантажити каталог. Потягніть вниз, щоб повторити спробу.';

  @override
  String get source_all_websites => 'Усі веб-сайти';

  @override
  String get source_available => 'Доступний для встановлення';

  @override
  String get source_third_party => 'Третя сторона';

  @override
  String get source_name_or_title => 'Назва або назва веб-сайту';

  @override
  String get view_all => 'Переглянути все';

  @override
  String get search_searching_ellipsis => 'Пошук…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · Неперевірено';
  }

  @override
  String get onboarding_untested => 'Неперевірено';

  @override
  String get source_custom_scope => 'Custom';

  @override
  String get source_custom_websites => 'Вибрані веб-сайти';

  @override
  String get tv_hidden_library_hint =>
      'Кожен заголовок знаходиться в прихованій категорії.\nУтримуйте OK на «Усі», щоб показати один.';

  @override
  String get tv_no_matching_anime => 'Немає відповідних аніме';

  @override
  String tv_no_matching_category(String category) {
    return 'Немає відповідних аніме в «$category»';
  }

  @override
  String get tv_filtered_empty_hint =>
      'Жодне аніме не відповідає поточним фільтрам.\nЗмініть їх за допомогою кнопки поруч із пошуком.';

  @override
  String get tv_new_episodes => 'Нові епізоди';

  @override
  String get tv_recently_added => 'Нещодавно доданий';

  @override
  String get tv_empty_category_hint =>
      'У цій категорії ще немає аніме.\nДодайте до нього заголовки зі сторінки інформації про заголовок.';

  @override
  String get tv_empty_library => 'Ваша бібліотека аніме порожня';

  @override
  String get tv_empty_library_hint =>
      'Додайте аніме з Огляду, щоб наповнити свій дім';

  @override
  String get tv_browse_anime => 'Перегляд аніме';

  @override
  String tv_new_count(int count) {
    return '$count новий';
  }

  @override
  String tv_category_hidden(String category) {
    return 'Приховано “$category” · утримуйте OK на “Усі”, щоб показати';
  }

  @override
  String get tv_no_hidden_categories => 'Немає прихованих категорій';

  @override
  String get import_torrent_file => 'імпорт файлу .torrent';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi тощо';

  @override
  String get cloudflare_proxy_optional => 'Додатково FlareSolverr / Byparr URL';

  @override
  String get tv_home_layout_hint =>
      'Домашня сторінка аніме на основі рядків (Продовжити · Нові епізоди · категорії) замість плоскої сітки';

  @override
  String get tv_hide_libraries_hint =>
      'Приховати бібліотеки манги та романів (увімкнено за замовчуванням на телевізорі)';

  @override
  String get anime_only_hint =>
      'Сховати мангу та роман у програмі. Вимкніть, щоб показати все.';

  @override
  String get audio_auto_safe => 'Автосейф';

  @override
  String get tv_player_hint =>
      'Увімкнено: спеціальний телепрогравач.  Вимкнено: оригінальний (настільний) програвач.';

  @override
  String get release_open_failed => 'Неможливо відкрити випуск';

  @override
  String get tv_replay => 'Повтор';

  @override
  String get tv_no_episodes => 'Епізодів ще немає';

  @override
  String get tracker_continue_series => 'Продовжити перегляд серіалу';

  @override
  String get tracker_watchlist_series => 'Серія списку спостереження';

  @override
  String get tracker_continue_movies => 'Продовжуйте перегляд фільмів';

  @override
  String get tracker_watchlist_movies => 'Фільми зі списку перегляду';

  @override
  String get tracker_trending_series => 'Трендові серії';

  @override
  String get tracker_trending_movies => 'Популярні фільми';

  @override
  String get tracker_popular_series => 'Популярна серія';

  @override
  String get tracker_popular_movies => 'Популярні фільми';

  @override
  String get tracker_top_series => 'Кращі серії (за весь час)';

  @override
  String get tracker_top_movies => 'Найкращі фільми (за всі часи)';

  @override
  String get tracker_airing_series => 'Серія Провітрювання';

  @override
  String get tracker_airing_anime => 'Трансляція аніме';

  @override
  String get tracker_popular_anime => 'Популярне аніме';

  @override
  String get tracker_upcoming_anime => 'Майбутнє аніме';

  @override
  String get tracker_popular_manga => 'Популярна манга';

  @override
  String get tracker_top_manga => 'Топ манги';

  @override
  String get tracker_top_manhwa => 'Топ Manhwa';

  @override
  String get tracker_top_manhua => 'Топ Манхуа';

  @override
  String get tracker_latest_anime => 'Останнє аніме';

  @override
  String get tracker_best_anime => 'Аніме з найкращим рейтингом';

  @override
  String get tracker_latest_manga => 'Остання манга';

  @override
  String get tracker_best_manga => 'Манга з найкращим рейтингом';

  @override
  String get tracker_trending_anime => 'Популярне аніме';

  @override
  String get tracker_upcoming_manga => 'Майбутня манга';

  @override
  String get tracker_trending_manga => 'Популярна манга';

  @override
  String selection_progress(int selected, int total) {
    return 'Вибрано $selected/$total';
  }

  @override
  String get source_code_editor => 'Редактор коду';

  @override
  String get source_code_execute => 'Виконати';

  @override
  String get source_console_logs => 'Журнали консолі';

  @override
  String get source_no_logs => 'Журналів ще немає';

  @override
  String get source_updated_successfully => 'Джерело успішно оновлено';

  @override
  String get source_obsolete => 'ЗАСТАРІЛО';

  @override
  String player_seek_forward_seconds(int seconds) {
    return 'Перейти вперед на $seconds секунд';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return 'Перейти назад на $seconds секунд';
  }

  @override
  String get player_autoplay_on =>
      'Автоматичне відтворення наступного епізоду: увімкнено';

  @override
  String get player_autoplay_off =>
      'Автоматичне відтворення наступного епізоду: вимкнено';

  @override
  String get player_no_other_quality => 'Жодної іншої якості';

  @override
  String get player_no_subtitles => 'Без субтитрів';

  @override
  String get player_no_audio_tracks => 'Немає звукових доріжок';

  @override
  String get player_seek_forward => 'Перейти вперед';

  @override
  String get player_seek_backward => 'Перейти назад';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds секунди',
      many: '$seconds секунд',
      few: '$seconds секунди',
      one: '$seconds секунда',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'Lorem ipsum dolor sit amet';

  @override
  String get subtitle_style => 'Стиль';

  @override
  String get translation_official_channel => 'NodeLane Офіційно';

  @override
  String get translation_auth_required =>
      'Спочатку увійдіть у свій обліковий запис перекладу.';

  @override
  String get translation_source_changed =>
      'Початкове зображення змінено. Перезавантажте його.';

  @override
  String get translation_source_missing =>
      'Оригінальне зображення наразі недоступне.';

  @override
  String get translation_resource_limit =>
      'Це зображення перевищує ліміт обробки пристрою. Оригінал зберігається.';

  @override
  String get translation_storage_full =>
      'Пам\'ять перекладу заповнена. Спочатку очистіть перекладені зображення.';

  @override
  String get translation_invalid_image =>
      'Недійсний формат або вміст зображення.';

  @override
  String get translation_unsupported_image =>
      'Переклад не підтримується для цього зображення. Оригінал зберігається.';

  @override
  String get translation_invalid_result =>
      'Помилка перевірки перекладеного зображення. Перезавантажте його.';

  @override
  String get translation_result_unavailable =>
      'Перекладене зображення недоступне. Перезавантажте його.';

  @override
  String get translation_result_expired =>
      'Термін дії перекладеного зображення минув. Перекладіть, будь ласка, ще раз.';

  @override
  String get translation_analysis_too_large =>
      'Забагато вмісту зображення для аналізу. Зменшіть розмір зображення та повторіть спробу.';

  @override
  String get translation_region_limit =>
      'Зображення має занадто багато текстових областей. Розділіть його та спробуйте ще раз.';

  @override
  String get translation_text_limit =>
      'Область тексту занадто довга. Відкоригуйте зображення та повторіть спробу.';

  @override
  String get translation_unavailable => 'Цей переклад більше не доступний.';

  @override
  String get translation_outcome_unknown =>
      'Результат потребує перевірки. Він не був повторно поданий.';

  @override
  String get translation_rate_limited =>
      'Кількість запитів обмежена. Переклад відновиться автоматично.';

  @override
  String get translation_quota_exhausted => 'Недостатня квота перекладу.';

  @override
  String get translation_unsupported_language =>
      'Служба не підтримує цю цільову мову.';

  @override
  String get translation_upgrade_required =>
      'Протокол трансляції несумісний. Оновіть програму.';

  @override
  String get translation_remote_failed =>
      'Помилка перекладу для цієї сторінки. Ви можете повторити спробу вручну.';

  @override
  String get translation_bridge_invalid =>
      'Веб-сторінка змінена. Увімкніть переклад знову.';

  @override
  String get translation_connection_failed =>
      'Помилка підключення. Спробуйте ще раз.';

  @override
  String get translation_paused =>
      'Переклад призупинено. Ви можете перевірити його прогрес.';

  @override
  String get translation_preparing_ellipsis => 'Підготовка перекладу…';

  @override
  String get translation_checking_original =>
      'Перевірка оригінального зображення…';

  @override
  String get translation_submitting => 'Подання…';

  @override
  String get translation_uploading_ellipsis => 'Завантаження оригіналу…';

  @override
  String get translation_waiting_ellipsis => 'Чекаємо на переклад…';

  @override
  String get translation_running_ellipsis => 'Перекладаю…';

  @override
  String get translation_verify_result => 'Результат потребує перевірки';

  @override
  String get translation_partial => 'Деякий вміст було перекладено';

  @override
  String get translation_ready => 'Перекладене зображення готове';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Гра';

  @override
  String get player_quality => 'Якість';

  @override
  String get player_subtitles => 'Субтитри';

  @override
  String get player_audio => 'Аудіо';

  @override
  String get player_statistics => 'Статистика для ботанів';

  @override
  String get player_auto => 'Авто';

  @override
  String get source_information => 'Вихідна інформація';

  @override
  String get source_code_page => 'Сторінка';

  @override
  String get source_code_query => 'Запит';

  @override
  String get repository_invalid_source => 'Недійсне джерело - видаліть його';

  @override
  String get player_fit_contain => 'Містять';

  @override
  String get player_fit_cover => 'Обкладинка';

  @override
  String get player_fit_fill => 'Заповнити';

  @override
  String get player_fit_height => 'Висота';

  @override
  String get player_fit_width => 'Ширина';

  @override
  String get player_fit_scale => 'Масштаб';

  @override
  String get player_fit_none => 'Жодного';

  @override
  String get player_shader_clear => 'Вимк. (чіткі шейдери)';

  @override
  String get player_shader_luma => 'Підвищення масштабу яскравості';

  @override
  String get player_decoder_auto => 'Авто (апаратне забезпечення)';

  @override
  String get player_decoder_software =>
      'Програмне забезпечення (без апаратного забезпечення)';

  @override
  String get player_stats_toggle => 'Перемикання накладання';

  @override
  String get player_stats_general => 'Загальне';

  @override
  String get player_stats_frames => 'Таймінг кадрів';

  @override
  String get player_stats_cache => 'Кеш введення';

  @override
  String get player_stats_filters => 'Активні фільтри';

  @override
  String get player_stats_log => 'Журнал';

  @override
  String get source_mark_pinned => 'Булавка';

  @override
  String translation_image_action(String action) {
    return '$action це зображення';
  }

  @override
  String get memory_waiting => 'пам\'ять: очікування зразка';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current пік $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'кеш $current / $limit пік $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'елементи $count / $limit живі $live пік $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зразків',
      one: '1 зразок',
    );
    return 'повний $percent% з $_temp0';
  }

  @override
  String get memory_reset_hint =>
      'вимкніть і ввімкніть його в налаштуваннях, щоб скинути налаштування';

  @override
  String get action_hide => 'Сховати';

  @override
  String discord_get_app(String app) {
    return 'Отримати $app';
  }

  @override
  String get discord_idle => 'Бездіяльність';

  @override
  String discord_watching_title(String title) {
    return 'Перегляд $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'Читання $title';
  }
}
