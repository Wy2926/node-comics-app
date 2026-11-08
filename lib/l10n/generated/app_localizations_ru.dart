// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get app_update_details_hint =>
      'Просмотр примечаний к выпуску и вариантов установки';

  @override
  String get app_update_download => 'Скачать обновление';

  @override
  String get app_update_download_hint =>
      'После загрузки следуйте инструкциям для установки обновления.';

  @override
  String get bookshelf_all => 'Все';

  @override
  String get bookshelf_search => 'Поиск в библиотеке';

  @override
  String get app_update_allow_install =>
      'Разрешите установку приложения в настройках системы, затем вернитесь и нажмите «Установить».';

  @override
  String get app_update_waiting => 'Ожидание возобновления загрузки системой…';

  @override
  String get app_update_cancel_download => 'Отменить загрузку';

  @override
  String get app_update_remove_package => 'Удалить загруженный пакет';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'Нет соответствующих настроек';

  @override
  String get search_empty_hint =>
      'Попробуйте другое ключевое слово или очистите поиск, чтобы увидеть все.';

  @override
  String get search_clear => 'Очистить поиск';

  @override
  String get app_updates => 'Обновления приложения';

  @override
  String get app_update_auto => 'Проверка при запуске';

  @override
  String get app_update_view => 'Посмотреть обновление';

  @override
  String get app_update_later => 'Позже';

  @override
  String get app_update_external_hint =>
      'Открывает ссылку на обновление в вашем браузере.';

  @override
  String get app_update_failed =>
      'Невозможно проверить наличие обновлений. Пожалуйста, попробуйте еще раз.';

  @override
  String get app_update_opened => 'Открыта ссылка на обновление';

  @override
  String get app_diagnostics => 'Диагностика и журналы';

  @override
  String get library => 'Библиотека';

  @override
  String get updates_search => 'Поиск обновлений';

  @override
  String get updates => 'Обновления';

  @override
  String get history => 'История';

  @override
  String get browse => 'Обзор';

  @override
  String get more => 'Еще';

  @override
  String get open_random_entry => 'Открыть случайную запись';

  @override
  String get import => 'Импорт';

  @override
  String get filter => 'Фильтр';

  @override
  String get ignore_filters => 'Игнорировать фильтры';

  @override
  String get downloaded => 'Загружено';

  @override
  String get unread => 'Непрочитанное';

  @override
  String get unwatched => 'Непросмотренный';

  @override
  String get started => 'Начато';

  @override
  String get bookmarked => 'В закладках';

  @override
  String get sort => 'Сортировать';

  @override
  String get alphabetically => 'По алфавиту';

  @override
  String get last_read => 'Последнее чтение';

  @override
  String get last_watched => 'Последний просмотр';

  @override
  String get last_update_check => 'Последняя проверка обновлений';

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
          'Ты удаляешь все $count $entryTypePlural этого $mediaType из библиотеки.',
      one:
          'Ты удаляешь единственный $entryType этого $mediaType из библиотеки.',
    );
    return '$_temp0\nЭто также удалит весь $mediaType из твоей библиотеки.\n\nПримечание: Сами файлы удалены не будут.';
  }

  @override
  String get chapter => 'глава';

  @override
  String get episode => 'эпизод';

  @override
  String get unread_count => 'Количество непрочитанных';

  @override
  String get unwatched_count => 'Количество непросмотренных';

  @override
  String get latest_chapter => 'Последняя глава';

  @override
  String get latest_episode => 'Последний эпизод';

  @override
  String get date_added => 'Дата добавления';

  @override
  String get display => 'Отображение';

  @override
  String get display_mode => 'Режим отображения';

  @override
  String get compact_grid => 'Компактная сетка';

  @override
  String get compression_level => 'Уровень сжатия';

  @override
  String compression_info(Object level) {
    return 'Чем выше степень сжатия, тем меньше места занимает файл резервной копии, но используется больше ресурсов процессора. По умолчанию: $level';
  }

  @override
  String get comfortable_grid => 'Комфортная сетка';

  @override
  String get cover_only_grid => 'Только обложки';

  @override
  String get list => 'Список';

  @override
  String get badges => 'Значки';

  @override
  String get downloaded_chapters => 'Загруженные главы';

  @override
  String get downloaded_episodes => 'Загруженные эпизоды';

  @override
  String get language => 'Язык';

  @override
  String get local_source => 'Локальный источник';

  @override
  String get tabs => 'Вкладки';

  @override
  String get show_category_tabs => 'Показать вкладки категорий';

  @override
  String get show_numbers_of_items => 'Показать количество элементов';

  @override
  String get other => 'Другое';

  @override
  String get show_continue_reading_buttons =>
      'Показать кнопки продолжения чтения';

  @override
  String get show_continue_watching_buttons =>
      'Показать кнопки продолжения просмотра';

  @override
  String get empty_library => 'Пустая библиотека';

  @override
  String get search => 'Поиск...';

  @override
  String get no_recent_updates => 'Нет недавних обновлений';

  @override
  String get remove_everything => 'Удалить все';

  @override
  String get remove_everything_msg => 'Вы уверены? Вся история будет потеряна';

  @override
  String get remove_all_update_msg =>
      'Вы уверены? Все обновления будут удалены';

  @override
  String get ok => 'ОК';

  @override
  String get cancel => 'Отмена';

  @override
  String get remove => 'Удалить';

  @override
  String get remove_history_msg =>
      'Это удалит дату чтения этой главы. Вы уверены?';

  @override
  String get last_used => 'Последнее использование';

  @override
  String get pinned => 'Закреплено';

  @override
  String get sources => 'Источники';

  @override
  String get install => 'Установить';

  @override
  String get update => 'Обновить';

  @override
  String get latest => 'Последнее';

  @override
  String get extensions => 'Расширения';

  @override
  String get migrate => 'Перенести';

  @override
  String get mass_migration_title => 'Массовая миграция';

  @override
  String get mass_migration_preview_items => 'Предпросмотр элементов';

  @override
  String get mass_migration_destination_source => 'Исходный код назначения';

  @override
  String get mass_migration_no_library_items =>
      'Нет элементов библиотеки, доступных для массовой миграции.';

  @override
  String get mass_migration_no_destination_sources =>
      'Нет установленных источников назначения.';

  @override
  String get mass_migration_installed => 'Установлено';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count элементов готовы к просмотру',
      many: '$count элементов готовы к просмотру',
      few: '$count элемента готовы к просмотру',
      one: '$count элемент готов к просмотру',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count элементов',
      many: '$count элементов',
      few: '$count элемента',
      one: '$count элемент',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Выберите источник назначения';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Поиск совпадений в $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Обработка элемента $current из $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Ожидание 2 секунд перед следующим элементом...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Ожидание 2 секунд перед следующей миграцией...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Найдено совпадений: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Нет совпадений: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Просмотр совпадений для $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Найдено совпадений: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Нет совпадений: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Выбрано для миграции: $count';
  }

  @override
  String get mass_migration_finish_review => 'Завершить просмотр';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Миграция выбранных элементов ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Миграция выбранных элементов в $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Элементы для миграции не выбраны.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Миграция элемента $current из $total';
  }

  @override
  String get mass_migration_complete => 'Массовая миграция завершена';

  @override
  String get mass_migration_complete_success_message =>
      'Все выбранные элементы были успешно обработаны.';

  @override
  String get mass_migration_complete_partial_message =>
      'Миграция завершена, но некоторые элементы все еще требуют ручного вмешательства.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Обработано';

  @override
  String get mass_migration_matched => 'Совпало';

  @override
  String get mass_migration_migrated => 'Перенесено';

  @override
  String get mass_migration_skipped => 'Пропущено';

  @override
  String get mass_migration_failed => 'Ошибка';

  @override
  String get mass_migration_failed_items => 'Проблемные элементы';

  @override
  String get mass_migration_exit => 'Выйти из массовой миграции';

  @override
  String get mass_migration_no_destination_match =>
      'Совпадений в источнике назначения не найдено';

  @override
  String mass_migration_query(Object query) {
    return 'Запрос: $query';
  }

  @override
  String get mass_migration_skip => 'Пропустить';

  @override
  String get mass_migration_loading => 'Загрузка...';

  @override
  String get mass_migration_choose_another_result => 'Выбрать другой результат';

  @override
  String get mass_migration_source_chapters => 'Главы источника';

  @override
  String get mass_migration_destination_chapters => 'Главы назначения';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count глав',
      many: '$count глав',
      few: '$count главы',
      one: '$count глава',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count глав источника',
      many: '$count глав источника',
      few: '$count главы источника',
      one: '$count глава источника',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count глав назначения',
      many: '$count глав назначения',
      few: '$count главы назначения',
      one: '$count глава назначения',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Главы не найдены.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'И еще $count...';
  }

  @override
  String get mass_migration_unknown_title => 'Неизвестное название';

  @override
  String get mass_migration_unknown_match => 'Неизвестное совпадение';

  @override
  String get mass_migration_unknown_source => 'Неизвестный источник';

  @override
  String get mass_migration_unknown_chapter => 'Неизвестная глава';

  @override
  String get migrate_confirm => 'Перенести на другой источник';

  @override
  String get clean_database => 'Очистить базу данных';

  @override
  String cleaned_database(Object x) {
    return 'База данных очищена! Удалено $x записей';
  }

  @override
  String get clean_database_desc =>
      'Это удалит все элементы, которые не добавлены в библиотеку!';

  @override
  String get incognito_mode => 'Инкогнито режим';

  @override
  String get incognito_mode_description => 'Пауза в истории чтения';

  @override
  String get downloaded_only => 'Только загруженные';

  @override
  String get downloaded_only_description =>
      'Показывать только загруженные записи в вашей библиотеке';

  @override
  String get download_queue => 'Очередь загрузки';

  @override
  String get categories => 'Категории';

  @override
  String get statistics => 'Статистика';

  @override
  String get settings => 'Настройки';

  @override
  String get about => 'О приложении';

  @override
  String get help => 'Помощь';

  @override
  String get no_downloads => 'Нет загрузок';

  @override
  String get edit_categories => 'Изменить категории';

  @override
  String get edit_categories_description =>
      'У вас нет категорий. Нажмите на кнопку плюса, чтобы создать одну для организации вашей библиотеки';

  @override
  String get add => 'Добавить';

  @override
  String get add_category => 'Добавить категорию';

  @override
  String get name => 'Имя';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Требуется';

  @override
  String get add_category_error_exist =>
      'Категория с этим именем уже существует!';

  @override
  String get delete_category => 'Удалить категорию';

  @override
  String delete_category_msg(Object name) {
    return 'Вы хотите удалить категорию $name?';
  }

  @override
  String get rename_category => 'Переименовать категорию';

  @override
  String get general => 'Общее';

  @override
  String get general_subtitle => 'Язык приложения';

  @override
  String get app_language => 'Язык приложения';

  @override
  String get default_subtitle_language => 'Язык субтитров по умолчанию';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get appearance_subtitle => 'Тема, формат даты и времени';

  @override
  String get theme => 'Тема';

  @override
  String get dark_mode => 'Темный режим';

  @override
  String get follow_system_theme => 'Следовать системной теме';

  @override
  String get on => 'Включено';

  @override
  String get off => 'Выключено';

  @override
  String get pure_black_dark_mode => 'Чисто черный темный режим';

  @override
  String get timestamp => 'Временная метка';

  @override
  String get relative_timestamp => 'Относительная временная метка';

  @override
  String get relative_timestamp_short => 'Краткая (Сегодня, Вчера)';

  @override
  String get relative_timestamp_long => 'Длинная (Краткая+, n дней назад)';

  @override
  String get date_format => 'Формат даты';

  @override
  String get reader => 'Читатель';

  @override
  String get refresh => 'Обновить';

  @override
  String get reader_subtitle => 'Режим чтения, отображение, навигация';

  @override
  String get default_reading_mode => 'Режим чтения по умолчанию';

  @override
  String get reading_mode_vertical => 'Вертикальный';

  @override
  String get reading_mode_horizontal => 'Горизонтальный';

  @override
  String get reading_mode_left_to_right => 'Слева направо';

  @override
  String get reading_mode_right_to_left => 'Справа налево';

  @override
  String get reading_mode_vertical_continuous => 'Вертикальный непрерывный';

  @override
  String get reading_mode_webtoon => 'Вебтун';

  @override
  String get double_tap_animation_speed => 'Скорость анимации двойного касания';

  @override
  String get normal => 'Обычная';

  @override
  String get fast => 'Быстрая';

  @override
  String get no_animation => 'Без анимации';

  @override
  String get animate_page_transitions =>
      'Анимированные переходы между страницами';

  @override
  String get crop_borders => 'Обрезать края';

  @override
  String get downloads => 'Загрузки';

  @override
  String get downloads_subtitle => 'Настройки загрузок';

  @override
  String get download_location => 'Место загрузки';

  @override
  String get custom_location => 'Пользовательское место';

  @override
  String get only_on_wifi => 'Только по Wi-Fi';

  @override
  String get save_as_cbz_archive => 'Сохранить как архив CBZ';

  @override
  String get delete_download_after_reading => 'Удалять загрузку после чтения';

  @override
  String get concurrent_downloads => 'Одновременные загрузки';

  @override
  String get browse_subtitle => 'Источники, глобальный поиск';

  @override
  String get only_include_pinned_sources =>
      'Включать только закрепленные источники';

  @override
  String get nsfw_sources => 'Источники NSFW (+18)';

  @override
  String get nsfw_sources_show =>
      'Показывать в списках источников и расширений';

  @override
  String get nsfw_sources_info =>
      'Это не предотвращает появление контента NSFW (18+) в приложении от неофициальных или неправильно помеченных расширений';

  @override
  String get version => 'Версия';

  @override
  String beta_version(Object version) {
    return 'Бета ($version)';
  }

  @override
  String get check_for_update => 'Проверить обновления';

  @override
  String get logs_on => 'Включить ведение журнала';

  @override
  String get share_app_logs => 'Поделиться журналами приложения';

  @override
  String get no_app_logs => 'Файл log.txt недоступен!';

  @override
  String get failed => 'Не удалось!';

  @override
  String n_days_ago(Object days) {
    return '$days дней назад';
  }

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get a_week_ago => 'Неделю назад';

  @override
  String get next_week => 'На следующей неделе';

  @override
  String get add_to_library => 'Добавить в библиотеку';

  @override
  String get completed => 'Завершено';

  @override
  String get ongoing => 'В процессе';

  @override
  String get on_hiatus => 'На паузе';

  @override
  String get canceled => 'Отменено';

  @override
  String get publishing_finished => 'Публикация завершена';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get empty_placeholder => 'ПУСТО';

  @override
  String get error => 'Ошибка';

  @override
  String error_with_message(Object error) {
    return 'Ошибка: $error';
  }

  @override
  String get no_pages_available => 'Ошибка: нет доступных страниц';

  @override
  String get set_categories => 'Установить категории';

  @override
  String get edit => 'Редактировать';

  @override
  String get in_library => 'В библиотеке';

  @override
  String get filter_scanlator_groups => 'Фильтр групп переводчиков';

  @override
  String get reset => 'Сброс';

  @override
  String get by_source => 'По источнику';

  @override
  String get by_chapter_number => 'По номеру главы';

  @override
  String get by_episode_number => 'По номеру эпизода';

  @override
  String get by_upload_date => 'По дате загрузки';

  @override
  String get source_title => 'Название источника';

  @override
  String get create_extension => 'Создать расширение';

  @override
  String get developer_mode => 'Режим разработчика';

  @override
  String get developer_mode_subtitle =>
      'Показывать инструменты разработчика расширений (создание расширения, редактирование кода)';

  @override
  String get choose_extension_language => 'Выберите язык расширения';

  @override
  String get lang => 'Язык';

  @override
  String get base_url => 'Базовый URL';

  @override
  String get api_url_optional => 'URL API (необязательно)';

  @override
  String get icon_url => 'URL значка';

  @override
  String get source_icon_url => 'URL значка источника';

  @override
  String get notes => 'Примечания';

  @override
  String get extension_name_example => 'напр.: myAnime';

  @override
  String get language_code_example => 'напр.: ru';

  @override
  String get base_url_example => 'напр.: https://example.com';

  @override
  String get api_url_example => 'напр.: https://api.example.com';

  @override
  String get extension_notes_example =>
      'напр.: для этого расширения требуется вход';

  @override
  String get type => 'Тип';

  @override
  String get target => 'Цель';

  @override
  String get source_type_single => 'одиночный';

  @override
  String get source_type_multi => 'множественный';

  @override
  String get source_type_torrent => 'торрент';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js =>
      'Скомпилированный JS LNReader';

  @override
  String get source_created_successfully => 'Источник успешно создан';

  @override
  String get source_already_exists => 'Источник уже существует';

  @override
  String get error_when_creating_source => 'Ошибка при создании источника';

  @override
  String get cookies_deleted => 'Файлы cookie удалены!';

  @override
  String get delete_all_cookies => 'Удалить все cookie';

  @override
  String get chapter_number => 'Номер главы';

  @override
  String get episode_number => 'Номер эпизода';

  @override
  String get share => 'Поделиться';

  @override
  String n_chapters(Object n) {
    return '$n глав';
  }

  @override
  String missing_chapters(Object count) {
    return 'Отсутствует глав: $count';
  }

  @override
  String get no_description => 'Нет описания';

  @override
  String get resume => 'Продолжить';

  @override
  String get read => 'Читать';

  @override
  String get watch => 'Смотреть';

  @override
  String get popular => 'Популярное';

  @override
  String get open_in_browser => 'Открыть в браузере';

  @override
  String get clear_cookie => 'Очистить cookie';

  @override
  String get show_page_number => 'Показать номер страницы';

  @override
  String get from_library => 'Из библиотеки';

  @override
  String get downloaded_chapter => 'Загруженная глава';

  @override
  String page(Object page) {
    return 'Страница $page';
  }

  @override
  String get global_search => 'Глобальный поиск';

  @override
  String get color_blend_level => 'Уровень смешивания цветов';

  @override
  String current(Object char) {
    return 'Текущий $char';
  }

  @override
  String finished(Object char) {
    return 'Завершенный $char';
  }

  @override
  String next(Object char) {
    return 'Следующий $char';
  }

  @override
  String previous(Object char) {
    return 'Предыдущий $char';
  }

  @override
  String get no_more_chapter => 'Больше нет глав';

  @override
  String get no_result => 'Нет результатов';

  @override
  String get send => 'Отправить';

  @override
  String get delete => 'Удалить';

  @override
  String get start_downloading => 'Начать загрузку сейчас';

  @override
  String get retry => 'Повторить';

  @override
  String get add_chapters => 'Добавить главы';

  @override
  String get delete_chapters => 'Удалить главу?';

  @override
  String get default0 => 'По умолчанию';

  @override
  String get total_chapters => 'Всего глав';

  @override
  String get total_episodes => 'Общее количество эпизодов';

  @override
  String get import_local_file => 'Импортировать локальный файл';

  @override
  String get import_files => 'Файлы';

  @override
  String get split_epub_chapters => 'Разделить на главы';

  @override
  String get split_epub_chapters_description =>
      'Импортировать каждую главу EPUB как отдельную запись';

  @override
  String get nothing_read_recently => 'Недавно ничего не читалось';

  @override
  String get status => 'Статус';

  @override
  String get not_started => 'Не начато';

  @override
  String get score => 'Оценка';

  @override
  String get start_date => 'Дата начала';

  @override
  String get finish_date => 'Дата окончания';

  @override
  String get reading => 'Чтение';

  @override
  String get on_hold => 'На паузе';

  @override
  String get dropped => 'Брошено';

  @override
  String get plan_to_read => 'Планирую прочитать';

  @override
  String get re_reading => 'Перечитывание';

  @override
  String get chapters => 'Главы';

  @override
  String get add_tracker => 'Добавить трекер';

  @override
  String get one_tracker => '1 трекер';

  @override
  String n_tracker(Object n) {
    return '$n трекеров';
  }

  @override
  String get tracking => 'Отслеживание';

  @override
  String get syncing => 'Синхронизация';

  @override
  String get sync_logged => 'Вход выполнен успешно';

  @override
  String get syncing_subtitle =>
      'Введите адрес сервера синхронизации и войдите через браузер, чтобы синхронизировать прогресс чтения между устройствами.';

  @override
  String get sync_service => 'Синхронизация на своём сервере';

  @override
  String get last_sync => 'Последняя синхронизация: ';

  @override
  String get sync_login_browser => 'Войти через браузер';

  @override
  String get sync_server => 'Адрес сервера синхронизации';

  @override
  String get sync_starting => 'Начало синхронизации...';

  @override
  String get sync_finished => 'Синхронизация завершена';

  @override
  String get sync_failed => 'Не удалось синхронизировать';

  @override
  String get sync_restore_in_progress =>
      'Синхронизация пропущена — идет восстановление';

  @override
  String sync_progress_percent(Object percent) {
    return 'Синхронизация… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Синхронизация…';

  @override
  String get sync_button_sync => 'Синхронизировать прогресс';

  @override
  String get sync_button_upload => 'Только выгрузить';

  @override
  String get sync_button_upload_info =>
      'Эта операция полностью заменит удаленные данные локальными данными!';

  @override
  String get sync_button_download => 'Только загрузить';

  @override
  String get sync_button_download_info =>
      'Эта операция полностью заменит локальные данные удаленными данными!';

  @override
  String get sync_status_not_configured => 'Не подключено';

  @override
  String get sync_status_checking => 'Проверка соединения...';

  @override
  String get sync_status_connected => 'Подключено';

  @override
  String get sync_status_unauthorized => 'Сессия истекла, войдите снова';

  @override
  String get sync_status_unreachable => 'Сервер недоступен';

  @override
  String get sync_section_general => 'Общие';

  @override
  String get sync_on => 'Включить синхронизацию';

  @override
  String get sync_auto => 'Автосинхронизация';

  @override
  String get sync_auto_warning =>
      'Автосинхронизация в настоящее время является экспериментальной функцией!';

  @override
  String get sync_auto_off => 'Выключено';

  @override
  String get sync_auto_5_minutes => 'Каждые 5 минут';

  @override
  String get sync_auto_10_minutes => 'Каждые 10 минут';

  @override
  String get sync_auto_30_minutes => 'Каждые 30 минут';

  @override
  String get sync_auto_1_hour => 'Каждый час';

  @override
  String get sync_auto_3_hours => 'Каждые 3 часа';

  @override
  String get sync_auto_6_hours => 'Каждые 6 часов';

  @override
  String get sync_auto_12_hours => 'Каждые 12 часов';

  @override
  String get server_error => 'Ошибка сервера!';

  @override
  String get dialog_confirm => 'Подтвердить';

  @override
  String get description => 'Описание';

  @override
  String get reorder_navigation => 'Настроить навигацию';

  @override
  String get reorder_navigation_description =>
      'Перестройте и настройте каждую навигацию в соответствии с вашими потребностями.';

  @override
  String get floating_navigation_bar => 'Плавающая панель навигации';

  @override
  String get floating_navigation_bar_description =>
      'Используйте плавающую капсулу вместо стандартной прикрепленной навигационной панели.';

  @override
  String get full_screen_player => 'Использовать полноэкранный режим';

  @override
  String get full_screen_player_info =>
      'Автоматически использовать полноэкранный режим при воспроизведении видео.';

  @override
  String episode_progress(Object n) {
    return 'Прогресс: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n эпизодов';
  }

  @override
  String missing_episodes(Object count) {
    return 'Отсутствует эпизодов: $count';
  }

  @override
  String get manga_sources => 'Источники манги';

  @override
  String get anime_sources => 'Источники аниме';

  @override
  String get novel_sources => 'Источники романов';

  @override
  String get anime_extensions => 'Расширения аниме';

  @override
  String get manga_extensions => 'Расширения манги';

  @override
  String get novel_extensions => 'Расширения для романов';

  @override
  String get extension_settings => 'Настройки расширения';

  @override
  String get anime => 'Аниме';

  @override
  String get manga => 'Манга';

  @override
  String get novel => 'Роман';

  @override
  String get library_no_category_exist => 'У вас еще нет категорий';

  @override
  String get watching => 'Смотрят';

  @override
  String get plan_to_watch => 'Планируют смотреть';

  @override
  String get re_watching => 'Пересмотр';

  @override
  String get episodes => 'Эпизоды';

  @override
  String get download => 'Скачать';

  @override
  String get new_update_available => 'Доступно новое обновление';

  @override
  String app_version(Object v) {
    return 'Версия приложения: v$v';
  }

  @override
  String get searching_for_updates => 'Поиск обновлений...';

  @override
  String get no_new_updates_available => 'Новых обновлений нет';

  @override
  String get uninstall => 'Удалить';

  @override
  String uninstall_extension(Object ext) {
    return 'Удалить расширение $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Дважды коснитесь для поиска по всем $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Подсказка о поиске двойным касанием';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Показывать подсказку во вкладках Манга/Аниме/Новеллы о том, что двойное нажатие открывает глобальный поиск.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" уже в вашей библиотеке из $source.';
  }

  @override
  String get add_anyway => 'Всё равно добавить';

  @override
  String get langauage => 'Язык';

  @override
  String get extension_detail => 'Подробности расширения';

  @override
  String get scale_type => 'Тип масштабирования';

  @override
  String get scale_type_fit_screen => 'По размеру экрана';

  @override
  String get scale_type_stretch => 'Растягивание';

  @override
  String get scale_type_fit_width => 'По ширине';

  @override
  String get scale_type_fit_height => 'По высоте';

  @override
  String get scale_type_original_size => 'Оригинальный размер';

  @override
  String get scale_type_smart_fit => 'Умное подгонка';

  @override
  String get page_preload_amount => 'Количество предзагружаемых страниц';

  @override
  String get page_preload_amount_subtitle =>
      'Количество страниц для предварительной загрузки при чтении. Большие значения обеспечивают более плавное чтение, но требуют больше кэша и сетевого трафика.';

  @override
  String get image_loading_error => 'Это изображение не удалось загрузить';

  @override
  String get add_episodes => 'Добавить эпизоды';

  @override
  String get video_quality => 'Качество';

  @override
  String get video_subtitle => 'Субтитры';

  @override
  String get check_for_extension_updates => 'Проверить обновления расширений';

  @override
  String get auto_extensions_updates => 'Автоматические обновления расширений';

  @override
  String get auto_extensions_updates_subtitle =>
      'Автоматически обновлять расширение при появлении новой версии.';

  @override
  String get check_for_app_updates =>
      'Проверять обновления приложения при запуске';

  @override
  String get reading_mode => 'Режим чтения';

  @override
  String get custom_filter => 'Пользовательский фильтр';

  @override
  String get background_color => 'Цвет фона';

  @override
  String get white => 'Белый';

  @override
  String get black => 'Черный';

  @override
  String get grey => 'Серый';

  @override
  String get automaic => 'Автоматический';

  @override
  String get preferred_domain => 'Предпочтительный домен';

  @override
  String get load_more => 'Загрузить еще';

  @override
  String get cancel_all_for_this_series => 'Отменить все для этой серии';

  @override
  String get login => 'Вход';

  @override
  String login_into(Object tracker) {
    return 'Войти в $tracker';
  }

  @override
  String get email_adress => 'Адрес электронной почты';

  @override
  String get password => 'Пароль';

  @override
  String log_out_from(Object tracker) {
    return 'Выйти из $tracker?';
  }

  @override
  String get log_out => 'Выйти';

  @override
  String get update_pending => 'Ожидается обновление';

  @override
  String get update_all => 'Обновить все';

  @override
  String get backup_and_restore => 'Резервное копирование и восстановление';

  @override
  String get create_backup => 'Создать резервную копию';

  @override
  String get create_backup_dialog_title =>
      'Что вы хотите сохранить в резервной копии?';

  @override
  String get create_backup_subtitle =>
      'Может использоваться для восстановления текущей библиотеки';

  @override
  String get restore_backup => 'Восстановить из резервной копии';

  @override
  String get encrypt_backups => 'Шифровать резервные копии';

  @override
  String get encrypt_backups_info =>
      'Защитить резервные копии паролем с использованием шифрования AES';

  @override
  String get no_secure_storage => 'Безопасное хранилище не найдено';

  @override
  String get no_keyring_warning =>
      'В системе нет службы связки ключей (напр. gnome-keyring или kwallet в Linux), пароль не может быть сохранен безопасно.\n\nСохранить в незашифрованном виде в базе данных приложения?';

  @override
  String get enter_backup_password => 'Введите пароль резервной копии';

  @override
  String get incorrect_password_try_again =>
      'Неверный пароль, попробуйте еще раз.';

  @override
  String get set_backup_password => 'Установить пароль резервной копии';

  @override
  String get confirm_password => 'Подтвердите пароль';

  @override
  String get passwords_do_not_match => 'Пароли не совпадают';

  @override
  String get password_required_to_restore =>
      'Для восстановления резервной копии требуется пароль.';

  @override
  String get restore_backup_subtitle =>
      'Восстановить библиотеку из резервной копии';

  @override
  String get automatic_backups => 'Автоматические резервные копии';

  @override
  String get backup_frequency => 'Частота создания резервных копий';

  @override
  String get backup_location => 'Место хранения резервных копий';

  @override
  String get backup_options => 'Опции резервного копирования';

  @override
  String get backup_options_dialog_title =>
      'Что вы хотите включить в резервную копию?';

  @override
  String get backup_options_subtitle =>
      'Какую информацию включить в резервную копию';

  @override
  String get backup_and_restore_warning_info =>
      'Следует хранить копии резервных копий в других местах';

  @override
  String get library_entries => 'Записи библиотеки';

  @override
  String get chapters_and_episode => 'Главы и эпизоды';

  @override
  String get every_6_hours => 'Каждые 6 часов';

  @override
  String get every_12_hours => 'Каждые 12 часов';

  @override
  String get daily => 'Ежедневно';

  @override
  String get every_2_days => 'Каждые 2 дня';

  @override
  String get weekly => 'Еженедельно';

  @override
  String get restore_backup_warning_title =>
      'Восстановление резервной копии перезапишет все существующие данные.\n\nПродолжить восстановление?';

  @override
  String get restore_sync_question_title => 'Синхронизировать восстановление?';

  @override
  String get restore_sync_question_message =>
      'Устройство подключено к серверу синхронизации. Загрузить восстановленные данные сейчас?';

  @override
  String get restore_sync_question_confirm => 'Да, синхронизировать';

  @override
  String get restore_sync_question_deny => 'Нет, отключить синхронизацию';

  @override
  String get sync_disabled_after_restore =>
      'Синхронизация отключена. Вы можете включить ее в Настройках.';

  @override
  String get restore_sync_disabled_question_title => 'Синхронизация отключена';

  @override
  String get restore_sync_disabled_question_message =>
      'Синхронизация выключена. Включить ее и загрузить восстановленные данные на сервер?';

  @override
  String get restore_sync_question_reenable =>
      'Да, включить и синхронизировать';

  @override
  String get restore_sync_question_keep_disabled => 'Оставить отключенной';

  @override
  String get restore_sync_uploading =>
      'Синхронизация восстановленных данных с сервером…';

  @override
  String get restore_sync_upload_success =>
      'Восстановленные данные синхронизированы с сервером';

  @override
  String get services => 'Сервисы';

  @override
  String get tracking_warning_info =>
      'Односторонняя синхронизация для обновления прогресса чтения в службах отслеживания. Настройте отслеживание для отдельных записей из их кнопки отслеживания.';

  @override
  String get use_page_tap_zones => 'Использовать зоны касания страницы';

  @override
  String get manage_trackers => 'Управление трекерами';

  @override
  String get restore => 'Восстановить';

  @override
  String get backups => 'Резервные копии';

  @override
  String get by_scanlator => 'По сканлейтору';

  @override
  String get by_name => 'По имени';

  @override
  String get installed => 'Установлено';

  @override
  String get auto_scroll => 'Автопрокрутка';

  @override
  String get video_audio => 'Аудио';

  @override
  String get video_audio_info =>
      'Предпочитаемые языки, коррекция высоты тона, аудиоканалы';

  @override
  String get player => 'Плеер';

  @override
  String get markEpisodeAsSeenSetting =>
      'В какой момент отметить эпизод как просмотренный';

  @override
  String get mark_duplicate_chapters_read =>
      'Отметить повторяющиеся номера глав как прочитанные';

  @override
  String get default_skip_intro_length =>
      'Стандартная длина пропуска вступления';

  @override
  String get default_playback_speed_length =>
      'Стандартная длина скорости воспроизведения';

  @override
  String get updateProgressAfterReading => 'Обновить прогресс после чтения';

  @override
  String get no_sources_installed => 'Источники не установлены!';

  @override
  String get show_extensions => 'Показать расширения';

  @override
  String get default_skip_forward_skip_length =>
      'Длина пропуска вперед по умолчанию';

  @override
  String get aniskip_requires_info =>
      'AniSkip требует отслеживания аниме с использованием MAL или Anilist для работы.';

  @override
  String get enable_aniskip => 'Включить AniSkip';

  @override
  String get enable_auto_skip => 'Включить автоматическое пропускание';

  @override
  String get aniskip_button_timeout => 'Тайм-аут кнопки';

  @override
  String get skip_opening => 'Пропустить вступление';

  @override
  String get skip_ending => 'Пропустить концовку';

  @override
  String get fullscreen => 'Полноэкранный режим';

  @override
  String get update_library => 'Обновить библиотеку';

  @override
  String get next_chapter => 'Следующая глава';

  @override
  String get next_5_chapters => 'Следующие 5 глав';

  @override
  String get next_10_chapters => 'Следующие 10 глав';

  @override
  String get next_25_chapters => 'Следующие 25 глав';

  @override
  String get all_chapters => 'Все главы';

  @override
  String get next_episode => 'Следующий эпизод';

  @override
  String get next_5_episodes => 'Следующие 5 эпизодов';

  @override
  String get next_10_episodes => 'Следующие 10 эпизодов';

  @override
  String get next_25_episodes => 'Следующие 25 эпизодов';

  @override
  String get all_episodes => 'Все эпизоды';

  @override
  String get cover_saved => 'Обложка сохранена';

  @override
  String get set_as_cover => 'Установить как обложку';

  @override
  String get use_this_as_cover_art => 'Использовать это как обложку?';

  @override
  String get save => 'Сохранить';

  @override
  String get picture_saved => 'Изображение сохранено';

  @override
  String get cover_updated => 'Обложка обновлена';

  @override
  String get include_subtitles => 'Включить субтитры';

  @override
  String get blend_mode_default => 'По умолчанию';

  @override
  String get blend_mode_multiply => 'Умножение';

  @override
  String get blend_mode_screen => 'Экран';

  @override
  String get blend_mode_overlay => 'Наложение';

  @override
  String get blend_mode_colorDodge => 'Увеличение яркости';

  @override
  String get blend_mode_lighten => 'Осветление';

  @override
  String get blend_mode_colorBurn => 'Уменьшение яркости';

  @override
  String get blend_mode_darken => 'Затемнение';

  @override
  String get blend_mode_difference => 'Разность';

  @override
  String get blend_mode_saturation => 'Насыщенность';

  @override
  String get blend_mode_softLight => 'Мягкое свечение';

  @override
  String get blend_mode_plus => 'Плюс';

  @override
  String get blend_mode_exclusion => 'Исключение';

  @override
  String get custom_color_filter => 'Пользовательский цветной фильтр';

  @override
  String get color_filter_blend_mode => 'Режим смешивания цветового фильтра';

  @override
  String get enable_all => 'Включить все';

  @override
  String get disable_all => 'Отключить все';

  @override
  String get font => 'Шрифт';

  @override
  String get color => 'Цвет';

  @override
  String get font_size => 'Размер шрифта';

  @override
  String get text => 'Текст';

  @override
  String get border => 'Граница';

  @override
  String get background => 'Фон';

  @override
  String get no_subtite_warning_message =>
      'Не имеет эффекта, потому что в этом видео нет субтитров';

  @override
  String get grid_size => 'Размер сетки';

  @override
  String n_per_row(Object n) {
    return '$n в ряд';
  }

  @override
  String get horizontal_continious => 'Горизонтальное непрерывное';

  @override
  String get edit_code => 'Редактировать код';

  @override
  String get use_libass => 'Включить libass';

  @override
  String get use_libass_info =>
      'Используйте рендеринг субтитров на основе libass для нативного бэкенда.';

  @override
  String get libass_not_disable_message =>
      'Отключите `use libass` в настройках плеера, чтобы иметь возможность настраивать субтитры.';

  @override
  String get override_ass_subtitles => 'Переопределить субтитры ASS';

  @override
  String get override_ass_subtitles_info =>
      'Применить собственный стиль к субтитрам ASS/SSA';

  @override
  String get torrent_stream => 'Торрент-стрим';

  @override
  String get add_torrent => 'Добавить торрент';

  @override
  String get enter_torrent_hint_text =>
      'Введите magnet-ссылку или URL торрент-файла';

  @override
  String get torrent_url => 'URL торрента';

  @override
  String get or => 'ИЛИ';

  @override
  String get advanced => 'Продвинутые';

  @override
  String get advanced_info => 'Конфигурация mpv';

  @override
  String get use_native_http_client => 'Использовать нативный HTTP-клиент';

  @override
  String get use_native_http_client_info =>
      'он автоматически поддерживает функции платформы, такие как VPN, поддерживает больше функций HTTP, таких как HTTP/3 и пользовательская обработка перенаправлений';

  @override
  String n_hour_ago(Object hour) {
    return '$hour час назад';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours часов назад';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute минуту назад';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes минут назад';
  }

  @override
  String n_day_ago(Object day) {
    return '$day день назад';
  }

  @override
  String get now => 'сейчас';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Библиотека обновлена: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Данные и хранилище';

  @override
  String get download_location_info => 'Используется для скачивания глав';

  @override
  String get storage => 'Хранилище';

  @override
  String get clear_chapter_and_episode_cache => 'Очистить кэш глав и эпизодов';

  @override
  String get cache_cleared => 'Кэш очищен';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Очистить кэш глав/эпизодов при запуске приложения';

  @override
  String get app_settings => 'Настройки приложения';

  @override
  String get sources_settings => 'Настройки источников';

  @override
  String get include_sensitive_settings =>
      'Включить чувствительные настройки (например, токены для входа в трекер)';

  @override
  String get create => 'Создать';

  @override
  String get downloads_are_limited_to_wifi =>
      'Загрузки ограничены только Wi-Fi';

  @override
  String get recommendations => 'Рекомендации';

  @override
  String get recommendations_similar => 'похожий';

  @override
  String get recommendations_weights => 'Веса рекомендаций';

  @override
  String get recommendations_weights_genre => 'Сходство жанра';

  @override
  String get recommendations_weights_setting => 'Сходство сеттинга';

  @override
  String get recommendations_weights_synopsis => 'Сходство сюжета';

  @override
  String get recommendations_weights_theme => 'Сходство темы';

  @override
  String get manga_extensions_repo => 'Репозиторий расширений манги';

  @override
  String get anime_extensions_repo => 'Репозиторий расширений аниме';

  @override
  String get novel_extensions_repo => 'Репозиторий расширений новелл';

  @override
  String get custom_dns =>
      'Пользовательский DNS (оставьте пустым для использования системного DNS)';

  @override
  String get android_proxy_server =>
      'Прокси-сервер Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Получить M-Extension-Server';

  @override
  String get undefined => 'Не определено';

  @override
  String get empty_extensions_repo =>
      'У вас здесь нет URL-адресов репозитория. Нажмите кнопку добавления, чтобы добавить один!';

  @override
  String get add_extensions_repo => 'Добавить URL репозитория';

  @override
  String get remove_extensions_repo => 'Удалить URL репозитория';

  @override
  String get manage_manga_repo_urls =>
      'Управление URL-адресами репозитория манги';

  @override
  String get manage_anime_repo_urls =>
      'Управление URL-адресами репозитория аниме';

  @override
  String get manage_novel_repo_urls =>
      'Управление URL-адресами репозитория новелл';

  @override
  String get url_cannot_be_empty => 'URL не может быть пустым';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL должен заканчиваться на .json / .pb';

  @override
  String get repo_url => 'URL репозитория';

  @override
  String get invalid_url_format => 'Неверный формат URL';

  @override
  String get clear_all_sources => 'Очистить все источники';

  @override
  String get clear_all_sources_msg =>
      'Это полностью очистит все источники приложения. Вы уверены, что хотите продолжить?';

  @override
  String get sources_cleared => 'Источники очищены!';

  @override
  String get repo_added => 'Репозиторий источников добавлен!';

  @override
  String get repo_already_exists => 'Репозиторий уже существует!';

  @override
  String get add_repo => 'Добавить репозиторий?';

  @override
  String get add_repo_sources_to_add =>
      'Списки расширений, которые будут добавлены:';

  @override
  String get add_repo_warning =>
      'Расширения из этих репозиториев запускаются внутри приложения. Добавляйте только репозитории, которым вы доверяете.';

  @override
  String get genre_search_library => 'Поиск жанра в библиотеке';

  @override
  String get genre_search_source => 'Просмотр в источнике';

  @override
  String get source_not_added => 'Источник не установлен!';

  @override
  String get load_own_subtitles => 'Загрузить свои собственные субтитры...';

  @override
  String get search_subtitles => 'Искать субтитры онлайн...';

  @override
  String extension_notes(Object notes) {
    return 'Примечания: $notes';
  }

  @override
  String get unsupported_repo =>
      'Не удалось добавить этот репозиторий источников. Проверьте его адрес или свяжитесь с его сопровождающим.';

  @override
  String get you_have_finished_reading => 'Вы закончили чтение';

  @override
  String get hwdec => 'Аппаратный декодер';

  @override
  String get enable_hardware_accel => 'Аппаратное ускорение';

  @override
  String get enable_hardware_accel_info =>
      'Включите/выключите, если возникают ошибки или сбои';

  @override
  String get track_library_navigate =>
      'Перейти к существующей локальной записи';

  @override
  String get track_library_add => 'Добавить в локальную библиотеку';

  @override
  String get track_library_add_confirm =>
      'Добавить отслеживаемый элемент в локальную библиотеку';

  @override
  String get track_library_not_logged =>
      'Войдите в соответствующий трекер, чтобы использовать эту функцию!';

  @override
  String get track_library_switch => 'Переключиться на другой трекер';

  @override
  String get go_back => 'Назад';

  @override
  String get merge_library_nav_mobile =>
      'Объединить навигацию библиотеки на мобильном';

  @override
  String get enable_discord_rpc => 'Включить Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Скрыть Discord RPC в режиме Инкогнито';

  @override
  String get rpc_show_reading_watching_progress =>
      'Показывать текущую главу в Discord (требуется перезапуск)';

  @override
  String get rpc_show_title => 'Показывать текущий заголовок в Discord';

  @override
  String get rpc_show_cover_image =>
      'Показывать текущее изображение обложки в Discord';

  @override
  String get enable_mpv => 'Включить шейдеры / скрипты mpv';

  @override
  String get mpv_info => 'Поддерживает скрипты .js в mpv/scripts/';

  @override
  String get mpv_redownload => 'Перезагрузить файлы конфигурации mpv';

  @override
  String get mpv_redownload_info =>
      'Заменяет старые файлы конфигурации на новые!';

  @override
  String get mpv_download =>
      'Требуются файлы конфигурации MPV!\nЗагрузить сейчас?';

  @override
  String get custom_buttons => 'Пользовательские кнопки';

  @override
  String get custom_buttons_info =>
      'Выполнить код lua с пользовательскими кнопками';

  @override
  String get custom_buttons_edit => 'Редактировать пользовательские кнопки';

  @override
  String get custom_buttons_add => 'Добавить пользовательскую кнопку';

  @override
  String get custom_buttons_added => 'Пользовательская кнопка добавлена!';

  @override
  String get custom_buttons_delete => 'Удалить пользовательскую кнопку';

  @override
  String get custom_buttons_text => 'Текст кнопки';

  @override
  String get custom_buttons_text_req => 'Требуется текст кнопки';

  @override
  String get custom_buttons_js_code => 'Код lua';

  @override
  String get custom_buttons_js_code_req => 'Требуется код lua';

  @override
  String get custom_buttons_js_code_long => 'Код lua (при долгом нажатии)';

  @override
  String get custom_buttons_startup => 'Код lua (при запуске)';

  @override
  String get custom_buttons_add_warning =>
      'Эта кнопка запускает приведенный ниже код Lua в видеоплеере, который может получить доступ к вашим файлам и запускать программы. Добавляйте ее только в том случае, если вы уверены, откуда взялась эта ссылка.';

  @override
  String n_days(Object n) {
    return '$n дней';
  }

  @override
  String get decoder => 'Декодер';

  @override
  String get decoder_info =>
      'Аппаратное декодирование, формат пикселей, устранение полос';

  @override
  String get enable_gpu_next => 'Включить gpu-next (только Android)';

  @override
  String get enable_gpu_next_info => 'Новый движок рендеринга видео';

  @override
  String get debanding => 'Устранение полос';

  @override
  String get use_yuv420p => 'Использовать формат пикселей YUV420P';

  @override
  String get use_yuv420p_info =>
      'Может исправить черные экраны на некоторых видеокодеках, также может улучшить производительность за счет качества';

  @override
  String get audio_preferred_languages => 'Предпочитаемые языки';

  @override
  String get audio_preferred_languages_info =>
      'Аудиоязык(и) для выбора по умолчанию на видео с несколькими аудиопотоками, 2/3-буквенные коды языков (например: ru, en, de). Несколько значений могут быть разделены запятой.';

  @override
  String get enable_audio_pitch_correction =>
      'Включить коррекцию высоты тона аудио';

  @override
  String get enable_audio_pitch_correction_info =>
      'Предотвращает высокий тон аудио на более высоких скоростях и низкий на более низких скоростях';

  @override
  String get audio_channels => 'Аудиоканалы';

  @override
  String get volume_boost_cap => 'Предел усиления громкости';

  @override
  String get internal_player => 'Внутренний плеер';

  @override
  String get internal_player_info =>
      'Прогресс, элементы управления, ориентация';

  @override
  String get subtitle_delay_text => 'Задержка субтитров';

  @override
  String get subtitle_delay => 'Задержка (мс)';

  @override
  String get subtitle_speed => 'Скорость';

  @override
  String get tracks => 'Дорожки';

  @override
  String get playback_speed => 'Скорость воспроизведения';

  @override
  String get shaders => 'Шейдеры';

  @override
  String get video_fit => 'Масштабирование';

  @override
  String get calendar => 'Календарь';

  @override
  String get calendar_no_data => 'Пока нет данных.';

  @override
  String get calendar_info =>
      'Календарь может предсказать следующую загрузку главы только на основе предыдущих загрузок. Некоторые данные могут быть неточными на 100%!';

  @override
  String in_n_day(Object days) {
    return 'через $days день';
  }

  @override
  String in_n_days(Object days) {
    return 'через $days дней';
  }

  @override
  String get clear_library => 'Очистить библиотеку';

  @override
  String get clear_library_desc =>
      'Выберите очистку всех записей манги, аниме и/или новелл';

  @override
  String get clear_library_input =>
      'Введите \'manga\', \'anime\' и/или \'novel\' (разделенные запятой), чтобы удалить все связанные записи';

  @override
  String get watch_order => 'Порядок просмотра';

  @override
  String get watch_order_role_current => 'Текущее';

  @override
  String get watch_order_role_previous => 'Предыдущий';

  @override
  String get watch_order_role_next => 'Далее';

  @override
  String get watch_order_source_release_order => 'Порядок освобождения';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name от $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Официальная коллекция Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Времена года для $title';
  }

  @override
  String get watch_order_select_source => 'Источник заказа';

  @override
  String watch_order_season(int number) {
    return 'Сезон $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Эпизод $number';
  }

  @override
  String get sequels => 'Продолжения';

  @override
  String get recommendations_similarity => 'Сходство:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Рейтинг $rating';
  }

  @override
  String get local_folder_structure => 'Структура локальной папки';

  @override
  String get local_folder => 'Локальные папки';

  @override
  String get add_local_folder => 'Добавить локальную папку';

  @override
  String get rescan_local_folder =>
      'Пересканировать все локальные папки сейчас';

  @override
  String get default_download_destination => 'Место загрузки по умолчанию';

  @override
  String get ask_download_destination => 'Запрашивать место загрузки';

  @override
  String get ask_download_destination_desc =>
      'Выбирать локальную папку перед началом каждой загрузки.';

  @override
  String get select_download_destination => 'Выбрать место загрузки';

  @override
  String get clear_local_library => 'Очистить локальную библиотеку';

  @override
  String get clear_local_library_desc =>
      'Удалить локальные папки и архивы из библиотеки.';

  @override
  String get clear_local_library_msg =>
      'Локальные папки и архивы будут удалены из библиотеки. Файлы на диске останутся нетронутыми.';

  @override
  String get custom => 'Пользовательский';

  @override
  String get no_local_folder_available_for_downloads =>
      'Нет доступных локальных папок для загрузок';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Не удалось создать CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Ошибка чтения обложки: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Ошибка чтения метаданных: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Ошибка сохранения в библиотеку: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Ошибка чтения обложки главы: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Ошибка чтения обложки архива: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Ошибка получения локальной библиотеки: $error';
  }

  @override
  String get export_metadata => 'Экспортировать метаданные';

  @override
  String get exported => 'Экспортировано';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Ошибка экспорта метаданных: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return 'Для $count глав не удалось определить номер автоматически.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Не удалось запустить сервер разрешения Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Срок действия токена $tracker истек';
  }

  @override
  String get video_list_empty => 'Список видео пуст';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Не удалось открыть $url';
  }

  @override
  String get text_size => 'Размер текста:';

  @override
  String get text_align => 'Выравнивание текста';

  @override
  String get line_height => 'Высота строки';

  @override
  String get show_scroll_percentage => 'Показывать процент прокрутки';

  @override
  String get remove_extra_paragraph_spacing =>
      'Удалить дополнительный интервал между параграфами';

  @override
  String select_label_color(Object label) {
    return 'Выбрать цвет $label';
  }

  @override
  String get default_user_agent => 'Агент пользователя по умолчанию';

  @override
  String get forceLandscapeMode => 'Принудительно переднй режим';

  @override
  String get forceLandscapeModeSubtitle =>
      'Принудительно использовать ландшафтную ориентацию плеера.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Поставщик DNS';

  @override
  String get tracked => 'Отслеживается';

  @override
  String get auth_unlock_msg =>
      'Аутентифицируйтесь, чтобы разблокировать NodeLane Comics';

  @override
  String get app_locked => 'NodeLane Comics заблокирован';

  @override
  String get auth_to_continue => 'Аутентифицируйтесь, чтобы продолжить';

  @override
  String get authenticating => 'Идет аутентификация...';

  @override
  String get lock => 'Заблокировать';

  @override
  String get unlock => 'Разблокировать';

  @override
  String get security => 'Безопасность';

  @override
  String get auth_to_change_security_setting =>
      'Аутентифицируйтесь, чтобы изменить настройки безопасности';

  @override
  String get app_lock => 'Блокировка приложения';

  @override
  String get require_biometric_or_device_credential =>
      'Требуется биометрическая аутентификация или учетные данные устройства для открытия приложения';

  @override
  String get biometric_or_device_credential_not_available =>
      'Биометрическая аутентификация недоступна на этом устройстве';

  @override
  String get app_lock_description =>
      'Когда блокировка приложения включена, вам будет предложено пройти аутентификацию\\nкаждый раз, когда вы открываете приложение или возвращаетесь из фона.';

  @override
  String get checking_device_authentication =>
      'Проверка аутентификации устройства…';

  @override
  String get device_authentication_incomplete =>
      'Аутентификация не была завершена. Ваши настройки не изменились.';

  @override
  String get keep_screen_on => 'Держать экран включённым';

  @override
  String get webtoon_side_padding => 'Боковой отступ Webtoon';

  @override
  String get show_page_gaps => 'Показывать пробелы между страницами';

  @override
  String get invert_colors => 'Инвертировать цвета';

  @override
  String get grayscale => 'Оттенки серого';

  @override
  String get brightness => 'Яркость';

  @override
  String get contrast => 'Контраст';

  @override
  String get saturation => 'Насыщенность';

  @override
  String get navigation_layout => 'Макет навигации';

  @override
  String get nav_layout_default => 'По умолчанию';

  @override
  String get nav_layout_l_shaped => 'L-образный';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Краевой';

  @override
  String get nav_layout_right_and_left => 'Справа и слева';

  @override
  String get nav_layout_disabled => 'Отключена';

  @override
  String get color_enhancements => 'Улучшение цвета';

  @override
  String get total => 'Всего';

  @override
  String get mean_per_title => 'Среднее на название';

  @override
  String get completion_rate => 'Процент завершения';

  @override
  String get watching_time => 'Время просмотра';

  @override
  String get reading_time => 'Время чтения';

  @override
  String average_chapters_per_title(Object title) {
    return 'Среднее количество глав на $title';
  }

  @override
  String get read_percentage => 'Процент прочитанного';

  @override
  String get entries => 'Записи';

  @override
  String get android_proxy_server_mihon => 'Android прокси-сервер (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Загрузите и настройте прокси-сервер, необходимый для использования расширений Mihon.';

  @override
  String get mihon_proxy_server => 'Прокси-сервер Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Загрузите пакет прокси-сервера перед использованием расширений Mihon. Пакет включает в себя JRE и JAR-файл сервера расширений.';

  @override
  String get extension_server_intro_ios =>
      'Загрузите JAR-файл прокси-сервера перед использованием расширений Mihon. Для iOS требуется только JAR-файл сервера расширений.';

  @override
  String get checking_files => 'Проверка файлов';

  @override
  String get files_installed => 'Файлы установлены';

  @override
  String get files_missing => 'Файлы отсутствуют';

  @override
  String get update_files => 'Обновить файлы';

  @override
  String get up_to_date => 'Обновлено';

  @override
  String get choose_location => 'Выберите местоположение';

  @override
  String get import_existing_jar => 'Импортировать существующий JAR';

  @override
  String get detect_files_in_selected_folder =>
      'Обнаружить файлы в выбранной папке';

  @override
  String get preparing_download => 'Подготовка к загрузке...';

  @override
  String get app_install_location => 'Место установки приложения';

  @override
  String get install_location => 'Месть установки';

  @override
  String get jre_executable => 'Исполняемый файл JRE';

  @override
  String get extension_server_jar => 'JAR сервера расширений';

  @override
  String get installed_version => 'Установленная версия';

  @override
  String get latest_version => 'Последняя версия';

  @override
  String get m_extension_server_description =>
      'Используйте M-Extension-Server, когда вам нужен отдельный прокси-сервер для Android-устройства. Установите адрес прокси здесь и загрузите APK с GitHub.';

  @override
  String get set_proxy_address => 'Установить адрес прокси';

  @override
  String get no_newer_proxy_server_release_available =>
      'Нет доступных новых версий прокси-сервера.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Не удалось проверить обновления прокси-сервера.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Для этой платформы нет доступного пакета сервера расширений.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Ошибка загрузки пакета ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Загруженный пакет не содержит ожидаемых файлов.';

  @override
  String get extension_server_files_ready => 'Файлы сервера расширений готовы.';

  @override
  String get ios_extension_server_import_hint =>
      'На iOS сервер устанавливается внутри песочницы приложения. Используйте «Импортировать существующий JAR», чтобы добавить загруженный файл.';

  @override
  String get select_extension_server_folder =>
      'Выберите папку сервера расширений';

  @override
  String get selected_folder_does_not_exist => 'Выбранная папка не существует.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Файлы сервера расширений в выбранной папке не найдены.';

  @override
  String get extension_server_files_linked =>
      'Файлы сервера расширений привязаны.';

  @override
  String get select_extension_server_jar => 'Выбрать JAR-файл сервера';

  @override
  String get selected_file_could_not_be_accessed =>
      'Не удалось получить доступ к выбранному файлу.';

  @override
  String get extension_server_jar_imported =>
      'JAR-файл сервера расширений импортирован.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Не удалось запустить страницу M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP-адрес сервера (например, 10.0.0.5 или https://example.com)';

  @override
  String get not_configured => 'Не настроено';

  @override
  String get zero_interpreter => 'Интерпретатор Zero';

  @override
  String get zero_interpreter_description =>
      'Управление сервером интерпретатора Zero автоматически или вручную.';

  @override
  String get start_server_on_launch => 'Запускать сервер при старте';

  @override
  String get runtime_status => 'Состояние среды';

  @override
  String get running => 'Работает';

  @override
  String get stopped => 'Остановлен';

  @override
  String get start => 'Запустить';

  @override
  String get stop => 'Остановить';

  @override
  String get webview => 'Веб-просмотр';

  @override
  String get tts => 'Преобразование текста в речь';

  @override
  String get tts_speed => 'Скорость';

  @override
  String get tts_pitch => 'Высота тона';

  @override
  String get tts_language => 'Язык';

  @override
  String get tts_voice => 'Голос';

  @override
  String get tts_stop => 'Остановить';

  @override
  String get tts_play => 'Воспроизведение';

  @override
  String get tts_pause => 'Пауза';

  @override
  String get tts_previous => 'Предыдущий абзац';

  @override
  String get tts_next => 'Следующий абзац';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Абзац $current из $total';
  }

  @override
  String get tts_settings => 'Параметры TTS';

  @override
  String get tts_default => 'По умолчанию';

  @override
  String get webtoon_disable_zoom_out =>
      'Отключить уменьшение масштаба Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Двойное касание для масштабирования Webtoon';

  @override
  String get navigate_to_pan => 'Навигация перетаскиванием';

  @override
  String get navigate_to_pan_subtitle =>
      'Сначала сдвигать увеличенное изображение перед сменой страницы';

  @override
  String get split_wide_pages => 'Разделять двойные страницы';

  @override
  String get dual_page_invert => 'Инвертировать разделенные половины страниц';

  @override
  String get dual_page_rotate_to_fit => 'Поворачивать для соответствия';

  @override
  String get dual_page_rotate_to_fit_invert => 'Обратное направление вращения';

  @override
  String get double_page_single_first_page => 'Первая страница отдельно';

  @override
  String get double_page_single_first_page_subtitle =>
      'Отображать первую страницу отдельно в двухстраничном режиме';

  @override
  String get double_page_auto => 'Автоматический двухстраничный режим';

  @override
  String get double_page_auto_subtitle =>
      'Автоматически переключаться на двухстраничный режим в альбомной ориентации';

  @override
  String get landscape_zoom => 'Автоматическое масштабирование в альбоме';

  @override
  String get zoom_start_position => 'Начальная позиция масштабирования';

  @override
  String get zoom_start_left => 'Слева';

  @override
  String get zoom_start_right => 'Справа';

  @override
  String get zoom_start_center => 'По центру';

  @override
  String get automatic_background => 'Автоматический фон';

  @override
  String get tapping_inversion => 'Инверсия касаний';

  @override
  String get tapping_inversion_none => 'Нет';

  @override
  String get tapping_inversion_horizontal => 'По горизонтали';

  @override
  String get tapping_inversion_vertical => 'По вертикали';

  @override
  String get tapping_inversion_both => 'Оба';

  @override
  String get flash_on_page_change => 'Вспышка при смене страницы';

  @override
  String get flash_on_page_change_subtitle =>
      'Помощник против выгорания AMOLED';

  @override
  String get flash_color => 'Цвет вспышки';

  @override
  String get flash_color_black => 'Черный';

  @override
  String get flash_color_white => 'Белый';

  @override
  String get flash_color_white_black => 'Белый и Черный';

  @override
  String get flash_interval_label => 'Интервал вспышки';

  @override
  String flash_interval_value(String n) {
    return '$n страниц';
  }

  @override
  String flash_interval(String n) {
    return 'Интервал вспышки: $n страниц';
  }

  @override
  String get flash_duration_label => 'Длительность вспышки';

  @override
  String flash_duration_value(String n) {
    return '$n мс';
  }

  @override
  String flash_duration(String n) {
    return 'Длительность вспышки: $n мс';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Показывать навигационную панель при запуске';

  @override
  String get reader_hide_threshold => 'Порог скрытия интерфейса';

  @override
  String get reader_hide_threshold_highest => 'Самый высокий (5 px)';

  @override
  String get reader_hide_threshold_high => 'Высокий (13 px)';

  @override
  String get reader_hide_threshold_low => 'Низкий (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Самый низкий (47 px)';

  @override
  String get error_no_pages_available => 'Ошибка: нет доступных страниц';

  @override
  String get app_ui_scale => 'Масштаб интерфейса';

  @override
  String get app_ui_scale_subtitle =>
      'Сделайте интерфейс больше или меньше в соответствии с вашим экраном и расстоянием просмотра.';

  @override
  String get allow_concurrent_downloads => 'Разрешить одновременные загрузки';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Загружайте из разных источников одновременно. Один источник по-прежнему загружает одну главу за раз, чтобы не перегружать. Отключите, чтобы загружать по одному везде.';

  @override
  String get download_delay => 'Задержка загрузки';

  @override
  String get download_delay_subtitle =>
      'Выключен. Добавьте ожидание со случайной дрожью между главами, чтобы быть мягче к источникам.';

  @override
  String get save_search => 'Сохранить поиск';

  @override
  String get saved_searches => 'Сохраненные поиски';

  @override
  String get enter_search_to_save_first =>
      'Сначала введите поиск для сохранения';

  @override
  String get no_saved_searches =>
      'Для этого источника еще нет сохраненных поисков.\nВыполните поиск, а затем выберите \"Сохранить поиск\".';

  @override
  String get source => 'Источник';

  @override
  String get something_went_wrong => 'Что-то пошло не так';

  @override
  String get startup_failed => 'NodeLane Comics не удалось завершить запуск';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count источников без результатов',
      few: '$count источника без результатов',
      one: '1 источник без результатов',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Как импортировать данные?';

  @override
  String get import_mode_message =>
      'Выберите: объединить резервную копию с текущей библиотекой или полностью заменить ее.';

  @override
  String get import_mode_keep_existing => 'Объединить';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Добавляет новые тайтлы и обновляет существующие. Ничего не удаляется.';

  @override
  String get import_mode_replace => 'Заменить';

  @override
  String get import_mode_replace_subtitle =>
      'Удаляет текущую библиотеку и заменяет ее резервной копией.';

  @override
  String get replace_summary_title => 'Готово к замене библиотеки';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Это удалит текущую библиотеку ($currentCount тайтлов) и заменит ее на $backupCount тайтлов из копии.';
  }

  @override
  String get replace_summary_confirm => 'Заменить';

  @override
  String replace_result_message(Object count) {
    return 'Библиотека заменена на $count тайтлов из копии.';
  }

  @override
  String get category_conflict_title => 'Найдены существующие категории';

  @override
  String get category_conflict_message =>
      'Резервная копия содержит категории, которые уже существуют в библиотеке.';

  @override
  String get category_conflict_keep =>
      'Сохранить — объединить с существующей категорией';

  @override
  String get category_conflict_delete =>
      'Удалить — оставить тайтлы без категории';

  @override
  String get source_conflict_title => 'Источники не найдены';

  @override
  String get source_conflict_message =>
      'Некоторые источники не соответствуют установленным расширениям.';

  @override
  String get source_conflict_keep => 'Сохранить исходное название';

  @override
  String get import_summary_title => 'Готово к импорту';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Новых тайтлов: $newSeries, обновлено: $updatedSeries, добавлено глав: $newChapters.';
  }

  @override
  String get import_summary_confirm => 'Импортировать';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Импортировано $newSeries новых тайтлов, обновлено $updatedSeries, добавлено $newChapters глав.';
  }

  @override
  String get roll_back => 'Откатить';

  @override
  String get roll_back_confirm_message =>
      'Восстанавливает библиотеку до момента перед этим изменением.';

  @override
  String get roll_back_done => 'Выполнен откат к предыдущему снимку.';

  @override
  String get restoring_backup => 'Восстановление библиотеки…';

  @override
  String get roll_back_last_change => 'Откатить последнее изменение';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Снимок от $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return 'Доступно для отката изменений: $count';
  }

  @override
  String get delete_source_title => 'Удалить источник и его мангу';

  @override
  String get delete_source_subtitle =>
      'Удаляет из библиотеки все тайтлы источника с главами, загрузками и историей.';

  @override
  String get delete_source_pick_title => 'Выберите источник для удаления';

  @override
  String get delete_source_empty => 'Источники в библиотеке не найдены.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Удалить $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'При этом безвозвратно удаляются манга $mangaCount, главы $chapterCount, записи истории $historyCount и записи обновлений $updateCount. Ссылки для отслеживания сохраняются. Это нельзя отменить, кроме как путем отката.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Также удалить установленное расширение';

  @override
  String get delete_source_keep_history => 'Сохранить историю чтения';

  @override
  String get delete_source_keep_downloads => 'Сохранить записи загрузок';

  @override
  String get delete_source_button => 'Удалить';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Удалено $mangaCount тайтлов из $sourceName.';
  }

  @override
  String get merge_manga_title => 'Объединить дубликаты манги';

  @override
  String get merge_manga_subtitle =>
      'Находит мангу с одинаковыми названиями в одном источнике и объединяет их.';

  @override
  String get merge_manga_none_found => 'Дубликаты манги не найдены.';

  @override
  String get merge_manga_pick_title => 'Возможные дубликаты';

  @override
  String get merge_manga_choose_primary_title =>
      'В какой тайтл объединить остальные?';

  @override
  String get merge_manga_choose_primary_message =>
      'Главы, история и трекинг будут перенесены в выбранный тайтл.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count глав',
      few: '$count главы',
      one: '1 глава',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Объединить';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Объединено $count дубликатов в $mangaName.';
  }

  @override
  String get merge_preview_title => 'Подтверждение объединения';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters главы найдены в других записях. $duplicateChapters являются дубликатами и будут удалены (с сохранением копии, на которой выполняется чтение); $keptChapters будет добавлен. $duplicateTracks дублирующиеся ссылки для отслеживания также будут удалены.';
  }

  @override
  String get memory_overlay => 'Показывать использование памяти';

  @override
  String get memory_overlay_subtitle =>
      'Индикатор использования памяти приложением в реальном времени. Для точного измерения на устройстве: наблюдайте за ним во время прокрутки библиотеки или чтения главы.';

  @override
  String get beta => 'Бета';

  @override
  String get error_reports => 'Отчеты об ошибках';

  @override
  String get error_reports_subtitle =>
      'Ошибки, зафиксированные приложением, и способ их отправки';

  @override
  String get error_reports_empty => 'Ошибок нет.';

  @override
  String get error_reports_likely_cause => 'Вероятная причина';

  @override
  String get error_reports_report => 'Сообщить на GitHub';

  @override
  String get error_reports_banner => 'NodeLane Comics столкнулся с ошибкой';

  @override
  String get error_reports_banner_action => 'Посмотреть';

  @override
  String get error_reports_copy => 'Копировать';

  @override
  String get error_reports_copied => 'Скопировано в буфер обмена';

  @override
  String get error_reports_clear => 'Очистить';

  @override
  String get error_reports_extension_failure =>
      'Эта ошибка вызвана расширением, а не NodeLane Comics. Расширения разрабатываются и поддерживаются владельцами репозитория, из которого был установлен источник. Название источника и открываемый контент помогут им исправить проблему.';

  @override
  String get error_reports_already_reported => 'Уже отправлено';

  @override
  String get error_reports_expected_failure =>
      'Обычно это проблема на стороне источника или сети, а не приложения: истекшая ссылка, сбой сервера или обрыв соединения. Имеет смысл сообщать, только если ошибка повторяется на источнике, работающем в других местах.';

  @override
  String get share_unavailable_copied =>
      'Отправка недоступна, скопировано в буфер обмена.';

  @override
  String get onboarding_title => 'Добро пожаловать в NodeLane Comics';

  @override
  String get onboarding_libraries_body =>
      'Выберите, что вы читаете и смотрите.';

  @override
  String get onboarding_nav_title => 'Ваши библиотеки';

  @override
  String get onboarding_nav_body =>
      'Отдельная вкладка для каждой или объединение в общую вкладку Библиотека.';

  @override
  String get onboarding_nav_split => 'Отдельные вкладки';

  @override
  String get onboarding_nav_merged => 'Одна вкладка Библиотека';

  @override
  String get onboarding_nav_inside =>
      'Нажатие на Библиотеку переключает эти вкладки';

  @override
  String get onboarding_next => 'Далее';

  @override
  String get onboarding_restore => 'Восстановить резервную копию';

  @override
  String get onboarding_or_local => 'Или используйте имеющиеся файлы';

  @override
  String get onboarding_local_folder => 'Добавить папку';

  @override
  String onboarding_local_existing(Object count) {
    return 'Настроено папок: $count';
  }

  @override
  String get onboarding_local_any_type =>
      'Поддерживаются манга, аниме и новеллы.';

  @override
  String get onboarding_local_scanning => 'Сканирование папки';

  @override
  String onboarding_local_found(Object count) {
    return 'Найдено тайтлов: $count';
  }

  @override
  String get onboarding_local_remove => 'Удалить эту папку';

  @override
  String get onboarding_local_in_downloads => 'Это папка загрузок приложения.';

  @override
  String get onboarding_local_empty =>
      'Ничего не найдено. Выберите родительскую папку.';

  @override
  String get onboarding_repo_failed => 'Не удалось прочитать репозиторий.';

  @override
  String get onboarding_repo_title => 'Добавить источник';

  @override
  String get onboarding_body =>
      'Добавьте репозиторий, чтобы устанавливать расширения.';

  @override
  String get onboarding_add => 'Добавить репозиторий';

  @override
  String get onboarding_skip => 'Пропустить';

  @override
  String get onboarding_continue => 'Продолжить';

  @override
  String get onboarding_later =>
      'Вы можете добавить его позже в Настройки > Обзор.';

  @override
  String get onboarding_replay => 'Показать экран приветствия';

  @override
  String get onboarding_replay_subtitle =>
      'Повторно открывает экран начальной настройки.';

  @override
  String get missing_source_check_title => 'Проверка отсутствующих источников';

  @override
  String get missing_source_check_subtitle =>
      'Поиск тайтлов, чьи расширения не установлены.';

  @override
  String get missing_source_check_none_found =>
      'Источники для всех тайтлов установлены.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Отсутствуют $count источников',
      few: 'Отсутствуют $count источника',
      one: 'Отсутствует 1 источник',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Источники $itemType не установлены.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Добавьте репозиторий в разделе «Обзор», затем установите для него расширение.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count источников',
      few: '$count источника',
      one: '1 источник',
    );
    return 'У вас $_temp0 для этого, но поиск выполняется только по закрепленным.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Закрепите источник или отключите «Только закрепленные источники» в настройках обзора.';

  @override
  String get global_search_all_nsfw =>
      'Все источники для этого помечены как NSFW и скрыты.';

  @override
  String get global_search_all_nsfw_hint =>
      'Включите источники NSFW в настройках обзора для поиска по ним.';

  @override
  String get missing_source_check_result_message =>
      'Эти тайтлы привязаны к неустановленным источникам. Нажмите для миграции или установите расширение.';

  @override
  String get related_titles => 'Связанное';

  @override
  String get related_none => 'Связанных произведений не найдено.';

  @override
  String get relation_adaptation => 'Адаптация';

  @override
  String get relation_sequel => 'Продолжение';

  @override
  String get relation_prequel => 'Предыстория';

  @override
  String get relation_parent => 'Основная история';

  @override
  String get relation_side_story => 'Ответвление сюжета';

  @override
  String get relation_spin_off => 'Спин-офф';

  @override
  String get relation_alternative => 'Альтернативная версия';

  @override
  String get auto_library_update => 'Автообновление библиотеки';

  @override
  String get auto_library_update_subtitle =>
      'Проверять новые главы для каждого тайтла библиотеки при запуске приложения.';

  @override
  String get auto_library_update_never => 'Никогда';

  @override
  String get auto_library_update_12_hours => 'Каждые 12 часов';

  @override
  String get auto_library_update_daily => 'Ежедневно';

  @override
  String get auto_library_update_2_days => 'Каждые 2 дня';

  @override
  String get auto_library_update_weekly => 'Еженедельно';

  @override
  String get auto_library_update_wifi_only => 'Только по Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Пропускать запланированное обновление при использовании мобильных данных.';

  @override
  String get padding => 'Отступ';

  @override
  String get page_mode => 'Режим страниц';

  @override
  String get single_page => 'Одиночная страница';

  @override
  String get double_page => 'Две страницы';

  @override
  String get speed => 'Скорость';

  @override
  String get theme_dark => 'Тёмная';

  @override
  String get theme_light => 'Светлая';

  @override
  String get theme_black => 'Чёрная';

  @override
  String get theme_sepia => 'Сепия';

  @override
  String get decrease => 'Уменьшить';

  @override
  String get increase => 'Увеличить';

  @override
  String get chapter_swipe_actions => 'Действия при свайпе главы';

  @override
  String get chapter_swipe_start => 'Свайп вправо';

  @override
  String get chapter_swipe_end => 'Свайп влево';

  @override
  String get chapter_swipe_toggle_bookmark => 'Закладка';

  @override
  String get chapter_swipe_toggle_read => 'Прочитано/Не прочитано';

  @override
  String get chapter_swipe_download => 'Скачать';

  @override
  String get chapter_swipe_disabled => 'Отключено';

  @override
  String get update_errors => 'Ошибки обновления';

  @override
  String get no_update_errors => 'Отсутствие ошибок обновления.';

  @override
  String get clear_all => 'Очистить все';

  @override
  String get dismiss => 'Отклонить';

  @override
  String get previous_episode => 'Предыдущий эпизод';

  @override
  String get clear_logs => 'Очистить журналы';

  @override
  String get bold => 'Жирный';

  @override
  String get italic => 'Курсив';

  @override
  String get color_yellow => 'Желтый';

  @override
  String get color_cyan => 'Голубой';

  @override
  String get color_green => 'Зеленый';

  @override
  String get color_orange => 'Оранжевый';

  @override
  String get continue_watching => 'Продолжить просмотр';

  @override
  String get search_your_anime => 'Найдите свое аниме';

  @override
  String get category => 'Категория';

  @override
  String get hidden_categories => 'Скрытые категории';

  @override
  String get new_category => 'Новая категория';

  @override
  String get local => 'Местный';

  @override
  String get tv_home_rows => 'Ряды';

  @override
  String get genre_rows => 'Жанровые ряды';

  @override
  String get share_backup_file =>
      'Поделиться файлом резервной копии NodeLane Comics';

  @override
  String get close => 'Закрыть';

  @override
  String get migrate_source => 'Перенос источника';

  @override
  String get cloudflare_bypass_proxy => 'Обход прокси-сервера Cloudflare';

  @override
  String get custom_doh_url => 'Пользовательский DoH URL';

  @override
  String get custom_doh_url_helper =>
      'Должна быть конечной точкой https DoH (JSON).';

  @override
  String get anime_only_tv_layout => 'Макет телевизора только для аниме';

  @override
  String get anime_only_beta => 'Только аниме (бета)';

  @override
  String get tv_home_beta => 'Домашний телевизор (бета)';

  @override
  String get tv_player_beta => 'ТВ-плеер (бета)';

  @override
  String get network_settings => 'Сеть';

  @override
  String get reader_page_layout => 'Макет страницы';

  @override
  String get reader_continuous_options => 'Непрерывное чтение';

  @override
  String get reader_default_mode_hint =>
      'Режим чтения по умолчанию применяется к заголовкам без установки индивидуального режима во время чтения.';

  @override
  String get extension_service => 'Служба расширения';

  @override
  String get extension_service_description =>
      'Управляйте временем выполнения расширения и адресом прокси.';

  @override
  String get proxy_address => 'Адрес прокси';

  @override
  String get checking_runtime_status => 'Проверка статуса…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds с + случайная задержка';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count глав',
      one: '1 глава',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Добавляйте загрузки из списка глав названия.';

  @override
  String get download_queue_order_hint =>
      'Перетащите маркеры, чтобы изменить порядок';

  @override
  String get download_queue_empty => 'Нет загрузок в очереди';

  @override
  String get download_queue_actions => 'Действия по загрузке';

  @override
  String get download_queue_cancel_chapter => 'Отменить загрузку этой главы.';

  @override
  String get download_queue_cancel_series =>
      'Отменить все загрузки для этого названия.';

  @override
  String get download_queue_start => 'Начать загрузку';

  @override
  String get download_queue_retry => 'Повторить загрузку';

  @override
  String get download_queue_active => 'Загрузка';

  @override
  String get download_queue_waiting => 'Ожидание загрузки';

  @override
  String get download_queue_failed => 'Загрузка не удалась';

  @override
  String get cf_proxy_helper =>
      'Конечная точка FlareSolverr/Byparr. Оставьте пустым, чтобы отключить.';

  @override
  String get mobile_navigation_description =>
      'Перетащите, чтобы изменить порядок. Манга, аниме и романы находятся на вкладке «Библиотека». Первый видимый элемент открывается при запуске. Просмотр и многое другое остаются видимыми; дополнительные вкладки появятся в разделе «Дополнительно».';

  @override
  String get text_align_justify => 'Обоснование';

  @override
  String get novel_session_modes_hint =>
      'Установите режим чтения и одну или две страницы при чтении заголовка.';

  @override
  String get tts_languages_failed =>
      'Не удалось загрузить языки из речевого движка.';

  @override
  String get tts_languages_empty =>
      'Речевой механизм не возвратил ни одного языка. Ваш сохраненный выбор сохраняется.';

  @override
  String get tts_language_unavailable =>
      'Этого сохраненного языка нет в текущем списке устройства.';

  @override
  String get tts_apply_failed =>
      'Не удалось применить эту настройку к речевому механизму. Вы можете повторить попытку.';

  @override
  String get player_controls => 'Органы управления';

  @override
  String get audio_channel_auto => 'Автоматический';

  @override
  String get audio_channel_auto_safe => 'Автоматический (безопасный)';

  @override
  String get audio_channel_mono => 'Моно';

  @override
  String get audio_channel_stereo => 'Стерео';

  @override
  String get audio_channel_reverse_stereo => 'Обратное стерео';

  @override
  String get mpv_bundled_config_hint =>
      'Восстановите конфигурацию, скрипты и шейдеры, включенные в приложение. Файлы с такими же именами будут перезаписаны.';

  @override
  String get mpv_restore_bundled => 'Восстановление комплектной конфигурации';

  @override
  String get mpv_restore_confirm =>
      'Восстановить встроенную конфигурацию MPV? Существующая конфигурация, скрипты и шейдеры с такими же именами будут перезаписаны. Остальные файлы сохранятся.';

  @override
  String get player_operation_incomplete =>
      'Операцию не удалось завершить. Проверьте доступ к файлу и повторите попытку.';

  @override
  String get custom_buttons_empty_hint =>
      'Добавьте кнопку проигрывателя с меткой и действием нажатия.';

  @override
  String get custom_button_primary => 'Кнопка по умолчанию';

  @override
  String get show_password => 'Показать пароль';

  @override
  String get hide_password => 'Скрыть пароль';

  @override
  String get tracking_accounts_empty =>
      'Подключите услугу в настройках отслеживания, чтобы управлять ее записями.';

  @override
  String get tracking_entries_empty =>
      'Для этого типа носителя нет отслеживаемых записей. Добавьте отслеживание со страницы сведений о заголовке.';

  @override
  String get change_tracking_match => 'Изменить соответствующий заголовок';

  @override
  String get remove_tracking => 'Удалить отслеживание';

  @override
  String remove_tracking_confirm(String title) {
    return 'Удалить ссылку отслеживания для «$title»? Запись в сервисе отслеживания сохранится.';
  }

  @override
  String get tracking_refresh_required =>
      'Состояние отслеживания не удалось подтвердить. Обновите перед внесением еще одного изменения.';

  @override
  String get tracking_entry_unlinked =>
      'Эта запись не связана с локальным заголовком, поэтому ее нельзя редактировать здесь.';

  @override
  String get backup_selection_shared =>
      'Изменения этих выборов сохраняются немедленно, а также применяются к автоматическому резервному копированию.';

  @override
  String get library_snapshot_history => 'Восстановление снимка библиотеки';

  @override
  String get library_snapshot_empty => 'Снимки безопасности отсутствуют.';

  @override
  String get library_snapshot_restore_message =>
      'Текущие данные будут заменены этим снимком. Изменения, сделанные с тех пор, будут потеряны. Удаленные загрузки невозможно восстановить. После успешного завершения доступные снимки безопасности будут удалены.';

  @override
  String get library_maintenance_working => 'Обновление библиотеки…';

  @override
  String get library_safety_snapshot_note =>
      'Перед этой операцией будет сохранен снимок безопасности. Он не включает загруженные файлы.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Записи библиотеки: $mangaCount. Главы: $chapterCount. Записи истории: $historyCount. Обновления: $updateCount.\n\nВыберите, что оставить ниже.';
  }

  @override
  String get library_delete_pick_message =>
      'Выберите источник, чтобы просмотреть его содержимое и варианты удаления.';

  @override
  String get mobile_categories_hint =>
      'Перетащите, чтобы изменить порядок. Откройте категорию, чтобы переименовать ее или изменить ее видимость и обновления.';

  @override
  String get mobile_category_visible => 'Показать в библиотеке';

  @override
  String get mobile_category_hidden => 'Скрыто из библиотеки';

  @override
  String get mobile_category_updates => 'Включить в обновления библиотеки';

  @override
  String get statistics_watched => 'Смотрел';

  @override
  String get calendar_month => 'Месяц';

  @override
  String get calendar_two_weeks => '2 недели';

  @override
  String get calendar_week => 'Неделя';

  @override
  String get calendar_show_all_dates => 'Показать все даты';

  @override
  String get update_check_no_result =>
      'Не найдено устанавливаемое обновление. Вы можете попробовать еще раз позже.';

  @override
  String get release_notes => 'Примечания к выпуску';

  @override
  String get no_release_notes => 'Примечания к выпуску не предоставлены.';

  @override
  String get downloading_update => 'Загрузка обновления…';

  @override
  String get preparing_installation => 'Подготовка к установке…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Выбирайте, что читать. Вы можете изменить это позже.';

  @override
  String get onboarding_content_title => 'Начать чтение';

  @override
  String get onboarding_mobile_sources_body =>
      'Выберите способ начала или добавьте контент позже.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Шаг $step из $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'Результаты для «$query»';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count источники',
      one: '1 источник',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Поиск заголовка назначения.';

  @override
  String get migration_original_item => 'Текущий элемент';

  @override
  String get migration_target_item => 'Выбранный элемент';

  @override
  String get migration_partial_failure =>
      'Операция не завершилась. Некоторые изменения могли быть сохранены. Прежде чем повторить попытку, проверьте этот объект в своей библиотеке.';

  @override
  String get migration_no_categories =>
      'Никаких категорий. Вы можете добавить этот товар без категории.';

  @override
  String get mass_migration_select_source => 'Выбор текущего источника';

  @override
  String get mass_migration_select_all => 'Выбрать все';

  @override
  String get mass_migration_deselect_all => 'Отменить выбор всех';

  @override
  String get mass_migration_needs_review => 'Просмотр неполных миграций';

  @override
  String get bookshelf_actions => 'Действия с книжной полкой';

  @override
  String get bookshelf_ignore_filters => 'Игнорировать фильтры при поиске';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Поиск всех работ в этой категории, включая скрытые фильтрами.';

  @override
  String get bookshelf_stop_update => 'Остановить обновление библиотеки.';

  @override
  String bookshelf_selected_count(int count) {
    return '$count выбраны работы';
  }

  @override
  String get bookshelf_remove_library => 'Убрать с книжной полки';

  @override
  String get bookshelf_remove_library_hint =>
      'Удаляет избранное. Местный импорт также теряет свою библиотеку и записи о прочтении.';

  @override
  String get bookshelf_remove_downloads => 'Удалить загруженные файлы';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Удаляет загруженные файлы, сохраняя при этом рабочую информацию.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Также удаляет выбранные локальные импортированные файлы и удаляет их библиотечные записи. Эти файлы невозможно восстановить здесь.';

  @override
  String get bookshelf_remove_incomplete =>
      'Операция не завершилась. Некоторые работы или файлы могли быть обработаны. Закройте это диалоговое окно и проверьте свою книжную полку и загрузки, прежде чем продолжить.';

  @override
  String get bookshelf_processing => 'Обработка…';

  @override
  String get bookshelf_mark_read => 'Отметить как прочитанное';

  @override
  String get bookshelf_mark_unread => 'Отметить как непрочитанное';

  @override
  String get bookshelf_select_all => 'Выбрать все';

  @override
  String get bookshelf_invert_selection => 'Инвертировать выбор';

  @override
  String get bookshelf_settings => 'Настройки книжной полки';

  @override
  String get bookshelf_settings_live =>
      'Изменения фильтрации, сортировки и отображения вступают в силу немедленно.';

  @override
  String get bookshelf_filter_any => 'Любой';

  @override
  String get bookshelf_filter_include => 'Включить';

  @override
  String get bookshelf_filter_exclude => 'Исключить';

  @override
  String get bookshelf_all_sources => 'Все источники';

  @override
  String bookshelf_sources_selected(int count) {
    return 'Выбраны источники $count';
  }

  @override
  String get bookshelf_sort_ascending => 'По возрастанию';

  @override
  String get bookshelf_sort_descending => 'По убыванию';

  @override
  String get bookshelf_layout => 'Компоновка книжной полки';

  @override
  String get bookshelf_sources_hint =>
      'Выберите «Нет», чтобы отобразить все источники. Изменения вступают в силу, когда вы нажимаете «Фильтр».';

  @override
  String get bookshelf_choose_files => 'Выбор файлов';

  @override
  String get bookshelf_import_wait =>
      'Выберите файл в средстве выбора и дождитесь завершения импорта.';

  @override
  String get bookshelf_import_incomplete =>
      'Импорт не завершился. Некоторые файлы могут уже находиться на вашей книжной полке. Закройте это диалоговое окно и проверьте перед повторным импортом.';

  @override
  String get bookshelf_categories_replace =>
      'Сохранение присваивает эти категории каждому выбранному произведению, заменяя их предыдущие категории.';

  @override
  String get bookshelf_categories_hint =>
      'Выберите одну или несколько категорий или оставьте выбор пустым, чтобы не назначить ни одной.';

  @override
  String get bookshelf_categories_hidden =>
      'Существующие скрытые категории сохраняются для этой работы.';

  @override
  String get bookshelf_categories_incomplete =>
      'Категории не удалось сохранить полностью. Закройте это диалоговое окно и проверьте книжную полку, прежде чем повторить попытку.';

  @override
  String get bookshelf_categories_none_visible =>
      'Здесь нет доступных категорий. Откройте управление категориями, чтобы просмотреть их.';

  @override
  String get bookshelf_manage_categories => 'Управление категориями';

  @override
  String get manga_actions => 'Комические действия';

  @override
  String get manga_download_scope => 'Скачать главы';

  @override
  String get manga_download_scope_hint =>
      'Выберите главы в текущих фильтрах. Загруженные главы пропускаются.';

  @override
  String get manga_download_scope_empty =>
      'Ни одна глава не соответствует текущим фильтрам. Закройте это меню и настройте фильтры глав.';

  @override
  String get manga_action_incomplete =>
      'Действие не завершилось. Прежде чем повторить попытку, проверьте текущее состояние.';

  @override
  String get chapter_settings => 'Настройки главы';

  @override
  String get chapter_settings_live =>
      'Изменения фильтрации и сортировки применяются немедленно.';

  @override
  String get chapter_scanlators_all => 'Показать все группы сканляторов';

  @override
  String get chapter_scanlators_hint =>
      'Выберите группы, чтобы скрыть их главы. Изменения вступают в силу, когда вы нажимаете «Фильтр».';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count группы сканеров скрыты';
  }

  @override
  String chapter_selected_count(int count) {
    return 'Выбрано $count глав';
  }

  @override
  String get chapter_add_bookmark => 'Закладка';

  @override
  String get chapter_remove_bookmark => 'Удалить из закладок';

  @override
  String get chapter_read_following => 'Читайте ниже';

  @override
  String get chapter_delete_records => 'Удаление записей главы';

  @override
  String get chapter_delete_local_hint =>
      'Удаляет выбранные записи главы и прогресс чтения. Сохраняются оригинальные местные архивы; загруженные копии очищаются.';

  @override
  String get chapter_delete_last_hint =>
      'Это все главы этого комикса. Их удаление также удалит комикс с вашей книжной полки.';

  @override
  String get chapter_action_incomplete =>
      'Действие не закончилось. Некоторые изменения могут уже быть сохранены. Прежде чем продолжить, закройте и проверьте главы и загрузки.';

  @override
  String get reader_display_scope =>
      'Режим чтения и макет страницы вручную применимы к этому комиксу. Выберите изменение, чтобы вернуться к чтению.';

  @override
  String get reader_display_single_only =>
      'При непрерывном горизонтальном чтении используются отдельные страницы.';

  @override
  String get reader_display_manual_pages =>
      'Изменение макета страницы отключает автоматическое развертывание двойной страницы для всех комиксов.';

  @override
  String get reader_display_crop_scope => 'Применяется ко всем комиксам.';

  @override
  String get reader_chapter_locate => 'Найти текущую главу';

  @override
  String get reader_chapter_search => 'Поиск разделов или сканляторов';

  @override
  String get reader_chapter_scope =>
      'Использует фильтры глав и порядок сортировки деталей комикса. Закладки сохраняются сразу.';

  @override
  String get reader_chapter_current_hidden =>
      'Глава, которую вы читаете, находится за пределами текущих фильтров.';

  @override
  String get reader_chapter_current => 'Читаю сейчас';

  @override
  String get reader_chapter_read => 'Читать';

  @override
  String get reader_chapter_bookmark_failed =>
      'Не удалось подтвердить сохранение закладки. Закройте список и проверьте его текущее состояние.';

  @override
  String get reader_image_actions => 'Действия с изображением';

  @override
  String get reader_image_original =>
      'Использует полную исходную страницу без перевода, обрезки или цветных фильтров чтения.';

  @override
  String get reader_image_save_ios =>
      'Сохранение в папке «Изображения» в текущем месте хранения приложения.';

  @override
  String get reader_image_save_android =>
      'Сохраните в папку Pictures/nodelane-comics устройства.';

  @override
  String get reader_image_share => 'Откройте общий доступ к системе.';

  @override
  String get reader_image_cover =>
      'Измените обложку этого комикса после подтверждения.';

  @override
  String get reader_image_cover_limit =>
      'Изображения обложки должны быть меньше 5 МБ. Сохранение и обмен остаются доступными.';

  @override
  String get reader_image_action_failed =>
      'Действие не удалось подтвердить. Закройте это меню и проверьте результат, прежде чем повторить попытку.';

  @override
  String get reader_settings_book_scope =>
      'Эти настройки применимы только к этому комиксу.';

  @override
  String get reader_settings_global_scope =>
      'Эти настройки применяются ко всем комиксам и сохраняются немедленно.';

  @override
  String get reader_filters => 'Фильтры изображений';

  @override
  String get reader_filter_scope =>
      'Применяется ко всем комиксам. Изменяет отображение чтения без изменения исходных изображений.';

  @override
  String get reader_auto_scroll_pause =>
      'Прокрутка приостанавливается, пока настройки открыты.';

  @override
  String get manga_synopsis => 'Краткое описание';

  @override
  String manga_author(String author) {
    return 'Автор: $author';
  }

  @override
  String get manga_continue_reading => 'Продолжить чтение';

  @override
  String get reader_settings_title => 'Настройки считывателя';

  @override
  String get reader_picker_book_scope => 'Только для этого комикса';

  @override
  String get reader_picker_global_scope => 'Применяется ко всем комиксам.';

  @override
  String get reader_picker_apply_hint =>
      'Нажмите, чтобы сохранить и вернуться на предыдущий уровень.';

  @override
  String get reader_scale_fit_screen_hint => 'Поместить всю страницу на экран';

  @override
  String get reader_scale_stretch_hint => 'Заполните область чтения';

  @override
  String get reader_scale_fit_width_hint => 'Подогнать страницу по ширине';

  @override
  String get reader_scale_fit_height_hint => 'Подогнать страницу по высоте';

  @override
  String get source_filter_active => 'Применено';

  @override
  String get source_filter_apply => 'Применить фильтры';

  @override
  String get source_filter_scope =>
      'Фильтры применяются только к этому веб-сайту.';

  @override
  String get source_filter_apply_hint =>
      'Примените фильтры, чтобы использовать свой выбор.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Жанры',
      'author': 'Автор',
      'artist': 'Художник',
      'title': 'Название',
      'year': 'Год',
      'tags': 'Теги',
      'format': 'Формат',
      'publisher': 'Издатель',
      'relevance': 'Актуальность',
      'rating': 'Рейтинг',
      'views': 'Просмотры',
      'random': 'Случайный',
      'all': 'Все',
      'none': 'Нет',
      'action': 'Действие',
      'adventure': 'Приключение',
      'comedy': 'Комедия',
      'drama': 'Драма',
      'fantasy': 'Фэнтези',
      'romance': 'Романтика',
      'science_fiction': 'Научная фантастика',
      'slice_of_life': 'Кусочек жизни',
      'mystery': 'Тайна',
      'horror': 'Ужасы',
      'psychological': 'Психологический',
      'historical': 'Исторический',
      'sports': 'Спорт',
      'supernatural': 'Сверхъестественное',
      'school_life': 'Школьная жизнь',
      'tragedy': 'Трагедия',
      'shounen': 'Сёнен',
      'shoujo': 'Сёдзё',
      'seinen': 'Сэйнен',
      'josei': 'Джосей',
      'isekai': 'Исэкай',
      'martial_arts': 'Боевые искусства',
      'mecha': 'Меха',
      'music': 'Музыка',
      'doujinshi': 'Додзинси',
      'trending': 'Тенденции',
      'new': 'Новый',
      'adult_content': 'Контент для взрослых',
      'only': 'Только',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'Дополнительные варианты отображения';

  @override
  String get bookshelf_more_display_hint => 'Значки, источники и категории';

  @override
  String get bookshelf_download_count => 'Счетчик загрузок';

  @override
  String get bookshelf_source_global_hint =>
      'Видимость источника использует предпочтение совместного отображения.';

  @override
  String get bookshelf_select_entries => 'Избранные произведения';

  @override
  String get bookshelf_search_options => 'Параметры поиска';

  @override
  String get bookshelf_empty_hint =>
      'Собирайте работы из источников или импортируйте локальные файлы.';

  @override
  String get bookshelf_no_match_hint =>
      'Попробуйте другие ключевые слова или настройте текущие фильтры.';

  @override
  String get bookshelf_clear_query => 'Очистить ключевые слова';

  @override
  String get bookshelf_view_selection => 'Просмотр избранных работ';

  @override
  String get bookshelf_import_formats =>
      'Выберите локальный файл, чтобы добавить его на свою книжную полку.';

  @override
  String get bookshelf_import_canceled_hint =>
      'Вы можете выбрать снова после отмены средства выбора файла.';

  @override
  String get bookshelf_browse_sources => 'Просмотр источников';

  @override
  String get bookshelf_empty_title => 'Ваша книжная полка пуста';

  @override
  String get bookshelf_no_match_title => 'Никакие сопоставления не работают';

  @override
  String get bookshelf_mark_watched => 'Марк смотрел';

  @override
  String get bookshelf_mark_unwatched => 'Отметить как непросмотренное';

  @override
  String get nodelane_account => 'NodeLane аккаунт';

  @override
  String get nodelane_sign_in => 'Войдите в NodeLane.';

  @override
  String get nodelane_account_intro =>
      'Просмотр вашей учетной записи, подписки и квоты на переводы';

  @override
  String get nodelane_login_action => 'Продолжить вход в систему';

  @override
  String get nodelane_login_browser =>
      'Войдите через системный браузер, затем вернитесь в приложение.';

  @override
  String get nodelane_account_id => 'Идентификатор учетной записи';

  @override
  String get nodelane_account_init_error =>
      'Хранилище учетной записи недоступно. Перезапустите приложение и повторите попытку.';

  @override
  String get nodelane_account_refresh_error =>
      'Не удалось обновить информацию об учетной записи.';

  @override
  String get nodelane_account_auth_error =>
      'Срок действия вашей сессии истек. Войдите снова';

  @override
  String get nodelane_account_unknown => 'Информация о подписке недоступна.';

  @override
  String get nodelane_account_current => 'Текущая подписка';

  @override
  String get nodelane_account_free => 'Бесплатный аккаунт';

  @override
  String get nodelane_account_no_subscription => 'Нет активной подписки';

  @override
  String get nodelane_account_active => 'Активный';

  @override
  String get nodelane_account_expired => 'Срок действия истек';

  @override
  String get nodelane_account_expiry => 'Действительно до';

  @override
  String get nodelane_account_renewal => 'Обновление';

  @override
  String get nodelane_renewal_auto => 'Автоматическое продление';

  @override
  String get nodelane_renewal_manual => 'Ручное продление';

  @override
  String get nodelane_renewal_stopped =>
      'Автоматическое продление остановлено.';

  @override
  String get nodelane_renewal_gift => 'Подарочное членство';

  @override
  String get nodelane_renewal_attention =>
      'Проверьте статус продления на веб-сайте.';

  @override
  String get nodelane_next_billing => 'Следующая дата выставления счета';

  @override
  String get nodelane_billing_unavailable =>
      'Информация о продлении недоступна';

  @override
  String get nodelane_manage_account => 'Управление на сайте';

  @override
  String get nodelane_view_plans => 'Просмотр планов подписки';

  @override
  String get nodelane_translation_quota => 'Квота на перевод';

  @override
  String get nodelane_quota_free => 'Бесплатная квота';

  @override
  String get nodelane_quota_subscription => 'Квота подписки';

  @override
  String get nodelane_quota_purchase => 'Приобретенная квота';

  @override
  String get nodelane_quota_details => 'Просмотр сведений о квоте';

  @override
  String get nodelane_quota_expanded => 'Детали квоты';

  @override
  String get nodelane_quota_unlimited => 'Неограниченно';

  @override
  String get nodelane_quota_not_subscribed => 'Не подписан';

  @override
  String get nodelane_quota_unknown => 'Недоступно';

  @override
  String get nodelane_quota_used => 'Использовано';

  @override
  String get nodelane_quota_reserved => 'В процессе';

  @override
  String get nodelane_quota_reset => 'Следующий сброс';

  @override
  String get nodelane_quota_expiry => 'Следующий срок действия';

  @override
  String get nodelane_quota_no_expiry => 'Нет срока годности';

  @override
  String get nodelane_quota_reservation_note =>
      'Незавершенные страницы уже вычтены из доступной квоты.';

  @override
  String nodelane_quota_available(int count) {
    return 'Осталось $count страниц';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count страниц';
  }

  @override
  String get nodelane_sign_out => 'Выход';

  @override
  String get nodelane_sign_out_confirm =>
      'Выход из системы приостанавливает официальный перевод на этом устройстве. Ваша библиотека и прогресс чтения сохраняются.';

  @override
  String get settings_search_hint => 'Настройки поиска';

  @override
  String get settings_frequent => 'Часто используемый';

  @override
  String get settings_reading_translation => 'Чтение и перевод';

  @override
  String get settings_app_preferences => 'Настройки приложения';

  @override
  String get settings_data_management => 'Данные и управление';

  @override
  String get settings_more_tools => 'Дополнительные инструменты';

  @override
  String get settings_more_tools_hint => 'Категории, статистика и календарь';

  @override
  String get settings_appearance_interface => 'Внешний вид и интерфейс';

  @override
  String get settings_security_privacy => 'Безопасность и конфиденциальность';

  @override
  String get settings_source_preferences => 'Настройки источника';

  @override
  String get settings_about_help => 'О проекте и помощь';

  @override
  String get settings_storage_backup => 'Хранение и резервное копирование';

  @override
  String settings_pending_downloads(int count) {
    return '$count на рассмотрении';
  }

  @override
  String get settings_translation_language => 'Язык перевода';

  @override
  String get settings_translation_scope =>
      'Используется в программе чтения и переводе веб-страниц.';

  @override
  String get settings_immediate_choice =>
      'Изменения вступают в силу немедленно.';

  @override
  String get settings_translation_init_error =>
      'Настройки перевода недоступны. Перезапустите приложение и повторите попытку.';

  @override
  String get settings_local_cache => 'Локальный кэш';

  @override
  String get settings_chapter_cache => 'Кэш глав и эпизодов';

  @override
  String get settings_cover_cache => 'Крышка тайника';

  @override
  String get settings_translation_cache => 'Кэш переведенного изображения';

  @override
  String get settings_translation_cache_hint =>
      'Сохраняйте записи о переводах и при необходимости снова извлекайте переведенные изображения.';

  @override
  String get settings_cache_clear => 'Очистить';

  @override
  String get settings_translation_cache_done =>
      'Кэш переведенного изображения очищен; записи о переводах сохраняются';

  @override
  String settings_cache_confirmation(String name) {
    return 'Очистить $name? Кэшированный контент можно получить снова. Записи в библиотеке будут сохранены.';
  }

  @override
  String get settings_advanced_options => 'Расширенные параметры';

  @override
  String get settings_manga_reader => 'Читатель манги';

  @override
  String get settings_novel_reader => 'Читатель романов';

  @override
  String get settings_downloads => 'Загрузка настроек';

  @override
  String get onboarding_welcome => 'Добро пожаловать в';

  @override
  String get onboarding_reading_content => 'Чтение контента';

  @override
  String get onboarding_choose_one => 'Выберите хотя бы один';

  @override
  String get onboarding_restore_hint =>
      'Восстановите свою библиотеку из резервной копии.';

  @override
  String get onboarding_browse_hint =>
      'Поиск заголовков на поддерживаемых веб-сайтах.';

  @override
  String get onboarding_import_folder => 'Импортировать локальную папку';

  @override
  String get onboarding_import_folder_hint =>
      'Читайте мангу, романы и аниме на своем устройстве.';

  @override
  String get onboarding_third_party => 'Добавить сторонний репозиторий';

  @override
  String get onboarding_third_party_hint =>
      'Используйте адрес репозитория, который у вас уже есть.';

  @override
  String get onboarding_repository_hint =>
      'Введите адрес, предоставленный хранилищем.';

  @override
  String get onboarding_repository_address => 'Адрес';

  @override
  String get onboarding_repository_address_hint => 'Введите адрес репозитория';

  @override
  String get onboarding_add_repository => 'Добавить репозиторий';

  @override
  String get onboarding_start => 'Начало работы';

  @override
  String get onboarding_open_library => 'Открытая библиотека';

  @override
  String get onboarding_view_imports => 'Просмотр импортированного контента';

  @override
  String get onboarding_view_folders => 'Просмотр папок';

  @override
  String get notice_backup_created => 'Резервная копия создана';

  @override
  String get notice_backup_ready =>
      'Сохраните или поделитесь файлом резервной копии.';

  @override
  String get notice_backup_restored => 'Резервная копия восстановлена';

  @override
  String get notice_backup_unsupported =>
      'Этот формат резервного копирования не поддерживается.';

  @override
  String get notice_verification_required => 'Требуется проверка сайта';

  @override
  String get notice_verification_hint =>
      'Завершите проверку, чтобы продолжить просмотр.';

  @override
  String get notice_verify => 'Проверка веб-сайта';

  @override
  String get notice_action_incomplete =>
      'Действие не закончилось. Проверьте результат, прежде чем повторить попытку.';

  @override
  String get notice_library_updating => 'Обновление библиотеки';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'Проверены заголовки $current / $total.';
  }

  @override
  String get notice_library_failed =>
      'Некоторые заголовки не удалось обновить.';

  @override
  String get notice_import_completed => 'Импорт завершен';

  @override
  String get notice_operation_incomplete => 'Действие не завершено';

  @override
  String get subtitle_service => 'Онлайн-сервис субтитров';

  @override
  String get subtitle_service_mode => 'Источник субтитров';

  @override
  String get subtitle_service_disabled =>
      'Выкл · очистить сохраненные учетные данные';

  @override
  String get subtitle_personal_key => 'Мой ключ Wyzie';

  @override
  String get subtitle_custom_service => 'Мой сервис субтитров';

  @override
  String get subtitle_key => 'Wyzie API Ключ';

  @override
  String get subtitle_key_hint =>
      'Введите свой собственный ключ Wyzie. Он остается на этом устройстве и не включается в резервные копии приложений.';

  @override
  String get subtitle_get_key => 'Получите персональный ключ';

  @override
  String get subtitle_service_address => 'Поиск субтитров URL';

  @override
  String get subtitle_service_token => 'Токен доступа к услуге (необязательно)';

  @override
  String get subtitle_custom_hint =>
      'Используйте полный поиск HTTPS URL службы Wyzie-compatible, включая ее путь (например, /search). Введите токен доступа, только если он требуется для вашей службы.';

  @override
  String get subtitle_service_off_hint =>
      'Онлайн-поиск субтитров отключен. Встроенные, предоставленные источником и локальные субтитры остаются доступными.';

  @override
  String get subtitle_setup_required =>
      'Перед поиском выберите службу субтитров.';

  @override
  String get subtitle_invalid_key => 'Введите ключ без пробелов.';

  @override
  String get subtitle_invalid_address =>
      'Используйте полный HTTPS URL без запроса, фрагмента или встроенных учетных данных.';

  @override
  String get subtitle_invalid_token =>
      'Маркер доступа не может содержать пробелы.';

  @override
  String get subtitle_storage_failed =>
      'Не удалось прочитать или сохранить настройки субтитров. Пожалуйста, попробуйте еще раз.';

  @override
  String get subtitle_auth_failed =>
      'Служба субтитров отказала в доступе. Проверьте свой ключ или токен службы.';

  @override
  String get subtitle_quota_exhausted =>
      'Квота на обслуживание субтитров исчерпана. Проверьте свой аккаунт в этом сервисе.';

  @override
  String get subtitle_network_failed =>
      'Не удалось связаться со службой субтитров. Пожалуйста, попробуйте еще раз.';

  @override
  String get subtitle_response_invalid =>
      'Служба субтитров вернула неподдерживаемый ответ или файл.';

  @override
  String get detail_loading_chapters => 'Загрузка глав…';

  @override
  String get reader_opening_chapter => 'Вступительная глава';

  @override
  String get reader_open_chapter => 'Открыть главу';

  @override
  String get reader_loading_pages => 'Получение изображений глав…';

  @override
  String get reader_loading_pages_hint =>
      'Чтение начнется автоматически, когда все будет готово.';

  @override
  String get reader_loading_failed => 'Не удалось загрузить эту главу.';

  @override
  String get reader_loading_retry_hint =>
      'Проверьте подключение и повторите попытку.';

  @override
  String get reader_no_pages => 'Для этой главы изображений не найдено.';

  @override
  String get reader_loading_previous => 'Загрузка предыдущей главы…';

  @override
  String get reader_previous_failed => 'Не удалось загрузить предыдущую главу.';

  @override
  String get reader_reached_start => 'Вы дошли до первой главы.';

  @override
  String get reader_loading_next => 'Загрузка следующей главы…';

  @override
  String get reader_next_failed => 'Не удалось загрузить следующую главу.';

  @override
  String get reader_image_loading => 'Загрузка изображения…';

  @override
  String get reader_image_failure_hint =>
      'Вы можете продолжать читать другие страницы.';

  @override
  String get comic_paged => 'Страница за страницей';

  @override
  String get comic_scroll => 'Прокрутите вниз';

  @override
  String get comic_book_scope =>
      'Применимо только к этой книге · изменения сохраняются немедленно';

  @override
  String get comic_defaults_title => 'Установки и привычки';

  @override
  String get comic_defaults_hint =>
      'Значения по умолчанию применяются к полям, которые вы не настроили для книги.';

  @override
  String get comic_habits_hint => 'Эти привычки применимы к каждому комиксу.';

  @override
  String get comic_turn => 'Переход на следующую страницу.';

  @override
  String get comic_left => 'Левый';

  @override
  String get comic_right => 'Верно';

  @override
  String get comic_up => 'Вверх';

  @override
  String get comic_fit => 'По размеру страницы';

  @override
  String get comic_fit_contain => 'Вся страница';

  @override
  String get comic_fit_width => 'Подходящая ширина';

  @override
  String get comic_fit_height => 'Высота установки';

  @override
  String get comic_layout => 'Макет страницы';

  @override
  String get comic_auto => 'Авто';

  @override
  String get comic_layout_hint =>
      'Авто показывает разброс, когда имеется достаточная ширина.';

  @override
  String get comic_width => 'Ширина контента';

  @override
  String get comic_full => 'Полный';

  @override
  String get comic_comfortable => 'Удобный';

  @override
  String get comic_narrow => 'Узкий';

  @override
  String get comic_gap => 'Межстраничный интервал';

  @override
  String get comic_no_gap => 'Бесшовный';

  @override
  String get comic_small_gap => 'Маленький';

  @override
  String get comic_image_title => 'Точная настройка изображения';

  @override
  String get comic_image_hint => 'Обрезка и тон влияют только на эту книгу.';

  @override
  String get comic_wide => 'Широкие страницы';

  @override
  String get comic_intact => 'Хранить в целости';

  @override
  String get comic_split => 'Сплит';

  @override
  String get comic_rotate => 'Поворот';

  @override
  String get comic_wide_hint =>
      'Разделение следует направлению перелистывания страниц. Применяется к чтению одной страницы.';

  @override
  String get comic_cover => 'Одна обложка на главу';

  @override
  String get comic_effects_reset => 'Сброс настроек изображения';

  @override
  String get comic_book_reset => 'Восстановление настроек книги по умолчанию';

  @override
  String get comic_book_reset_hint =>
      'Очищает пользовательские настройки чтения этой книги. Перевод без изменений.';

  @override
  String get comic_canvas => 'Фон считывателя';

  @override
  String get comic_system => 'Система';

  @override
  String get comic_black => 'Черный';

  @override
  String get comic_gray => 'Серый';

  @override
  String get comic_paper => 'Бумага';

  @override
  String get comic_tap => 'Нажмите, чтобы перелистывать страницы.';

  @override
  String get comic_tap_hint =>
      'Коснитесь краев для перемещения; коснитесь центра, чтобы отобразить элементы управления.';

  @override
  String get comic_scroll_start => 'Запуск автоматической прокрутки';

  @override
  String get comic_scroll_pause => 'Пауза автоматической прокрутки';

  @override
  String get comic_scroll_speed => 'Скорость прокрутки';

  @override
  String get comic_scroll_hint =>
      'Начинается, когда эта панель закрывается. Приостанавливается, когда приложение покидает передний план.';

  @override
  String get comic_save_failed =>
      'Не удалось сохранить. Пожалуйста, попробуйте еще раз.';

  @override
  String get comic_reading => 'Чтение';

  @override
  String get comic_chapter_habits_hint =>
      'Привычки списка глав применимы ко всем книгам.';

  @override
  String get browser_title => 'Браузер';

  @override
  String get translation_image_display => 'Отображение изображения';

  @override
  String get translation_display_hint =>
      'Сначала покажите существующие переводы. Сохраняйте оригинал, если перевода нет.';

  @override
  String get translation_sign_in_required => 'Войдите, чтобы включить перевод.';

  @override
  String get translation_sign_in_hint =>
      'После входа в систему переключитесь на переведенные изображения для автоматического перевода.';

  @override
  String get translation_automatic => 'Автоматический перевод';

  @override
  String get translation_original_hint =>
      'Показ оригиналов. Переключитесь на переведенные изображения для автоматического перевода.';

  @override
  String get translation_window_hint =>
      'Обрабатывайте текущие и предстоящие изображения только во время показа переводов.';

  @override
  String get translation_channel => 'Канал трансляции';

  @override
  String get translation_no_images =>
      'На этой странице пока не найдено переводимых изображений.';

  @override
  String get translation_waiting_image => 'Ожидание текущего изображения';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues изображения требуют внимания',
      many: ' · $issues изображений требуют внимания',
      few: ' · $issues изображения требуют внимания',
      one: ' · $issues изображение требует внимания',
      zero: '',
    );
    return 'Обработано изображений: $complete / $total$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'Коснитесь и удерживайте изображение, чтобы выполнить дополнительные действия, включая его повторный перевод.';

  @override
  String get translation_title => 'Перевод манги';

  @override
  String get translation_system_sign_in =>
      'Войдите в систему с помощью системного браузера.';

  @override
  String get translation_target_language => 'Целевой язык';

  @override
  String get translation_clear_cache =>
      'Очистить кэш переведенных изображений.';

  @override
  String get translation_cache_hint =>
      'Сохраняйте записи о переводах и при необходимости извлекайте результаты снова.';

  @override
  String get translation_saved_read_failed =>
      'Не удалось загрузить сохраненный перевод.';

  @override
  String get translation_read_failed =>
      'Не удалось загрузить переведенное изображение.';

  @override
  String get operation_retry =>
      'Действие не завершилось. Пожалуйста, попробуйте еще раз.';

  @override
  String get translation_original => 'Оригинал';

  @override
  String get translation_translated => 'Переведено';

  @override
  String get translation_regenerate_image =>
      'Переведите это изображение еще раз';

  @override
  String get translation_read_image =>
      'Перезагрузить переведенное изображение.';

  @override
  String get translation_image_actions =>
      'Дополнительные действия с изображениями';

  @override
  String get translation_processing => 'Обработка';

  @override
  String get translation_reading => 'Загрузка переведенного изображения';

  @override
  String get translation_waiting => 'Ожидание перевода';

  @override
  String get translation_preparing => 'Подготовка перевода';

  @override
  String get translation_uploading => 'Загрузка оригинала';

  @override
  String get translation_running => 'Перевод';

  @override
  String get translation_uncertain => 'Статус требует проверки';

  @override
  String get translation_failed => 'Не удалось выполнить перевод';

  @override
  String get translation_verify => 'Проверка';

  @override
  String get translation_reread => 'Перезагрузить';

  @override
  String get browser_back => 'Назад';

  @override
  String get browser_translation => 'Перевод веб-страницы';

  @override
  String get browser_new_tab_action => 'Открыть новую вкладку';

  @override
  String get browser_current_tab => 'Ток';

  @override
  String get browser_close_tab => 'Закрыть вкладку';

  @override
  String get browser_new_tab => 'Новая вкладка';

  @override
  String get browser_page => 'Веб-страница';

  @override
  String get browser_unopened => 'Ни одна страница еще не открыта';

  @override
  String get browser_address_hint => 'Введите или вставьте URL';

  @override
  String get browser_invalid_address => 'Введите действительный URL.';

  @override
  String get browser_clear_address => 'Очистить URL';

  @override
  String get browser_paste_address => 'Вставьте URL';

  @override
  String get browser_open_address => 'Открыть URL';

  @override
  String browser_tab_count(int count) {
    return 'Вкладки · $count';
  }

  @override
  String get browser_load_failed => 'Не удалось открыть эту страницу.';

  @override
  String get browser_load_failed_hint => 'Проверьте подключение и URL.';

  @override
  String get browser_edit_address => 'Редактировать URL';

  @override
  String get browser_clear_cookies_confirm =>
      'Очистить сеансы входа для всех веб-сайтов?';

  @override
  String get browser_clear_cookies_hint =>
      'Веб-сайты на всех вкладках могут потребовать повторного входа в систему.';

  @override
  String get browser_clear_cookies_action => 'Очистить сеансы входа в систему';

  @override
  String get browser_tab_limit =>
      'Вы можете держать открытыми до 12 вкладок. Сначала закройте один.';

  @override
  String get browser_forward => 'Вперед';

  @override
  String get browser_clear_all_cookies =>
      'Очистить все сеансы входа на веб-сайт.';

  @override
  String get browser_clear_failed =>
      'Не удалось очистить сеансы. Пожалуйста, попробуйте еще раз.';

  @override
  String get browser_save_failed =>
      'Не удалось сохранить вкладки. Пожалуйста, попробуйте еще раз.';

  @override
  String get browser_tabs_full => 'Уже открыто 12 вкладок';

  @override
  String get browser_no_tabs => 'Открытых вкладок пока нет';

  @override
  String get browser_close_failed =>
      'Не удалось сохранить вкладки. Нажмите «Закрыть» еще раз, чтобы повторить попытку.';

  @override
  String get source_pinned_websites => 'Закрепленные веб-сайты';

  @override
  String get manage => 'Управление';

  @override
  String get translation_settings_hint =>
      'Автоматический перевод, целевой язык и канал';

  @override
  String get translation_show_original => 'Нажмите, чтобы показать оригинал';

  @override
  String get translation_show_translated => 'Нажмите, чтобы показать перевод';

  @override
  String get source_display => 'Дисплей';

  @override
  String get source_cover_title => 'Обложка и название';

  @override
  String get source_cover_only => 'Только крышка';

  @override
  String get source_save_search => 'Сохранить текущий поиск';

  @override
  String get source_saved_searches => 'Сохраненные поисковые запросы';

  @override
  String get source_website_info => 'Информация о веб-сайте';

  @override
  String source_saved_search_title(String title) {
    return '$title · Нажмите, чтобы найти';
  }

  @override
  String get action_done => 'Готово';

  @override
  String source_search_keyword(String query) {
    return 'Ключевое слово: $query';
  }

  @override
  String get source_no_saved_searches =>
      'Сохраненных результатов поиска пока нет.';

  @override
  String get source_save_search_hint =>
      'Найдите ключевое слово, затем сохраните его из действий веб-сайта.';

  @override
  String get source_saved_search_scope =>
      'Ключевые слова сохраняются только для этого веб-сайта.';

  @override
  String get source_search_here => 'Поиск по заголовкам на этом сайте';

  @override
  String get source_filter_results => 'Отфильтрованные результаты';

  @override
  String get source_search_results => 'Результаты поиска';

  @override
  String get source_return_popular => 'Вернуться к популярному';

  @override
  String get source_popular_titles => 'Популярные названия';

  @override
  String get source_no_titles => 'Соответствующие заголовки не найдены';

  @override
  String get source_no_titles_hint =>
      'Измените ключевые слова или фильтры или вернитесь к популярным заголовкам.';

  @override
  String get source_load_more_failed =>
      'Не удалось загрузить больше. Пожалуйста, попробуйте еще раз.';

  @override
  String get source_load_pull_retry =>
      'Не удалось загрузить этот сайт. Потяните вниз, чтобы повторить попытку.';

  @override
  String get source_clear_failed =>
      'Не удалось завершить очистку. Пожалуйста, попробуйте еще раз.';

  @override
  String get source_uninstall_failed =>
      'Не удалось завершить удаление. Пожалуйста, попробуйте еще раз.';

  @override
  String get source_details => 'Подробности источника';

  @override
  String get source_repository_website => 'Веб-сайт репозитория';

  @override
  String get source_provided_settings => 'Настройки предоставлены источником';

  @override
  String get source_advanced_actions => 'Расширенные действия';

  @override
  String get source_edit_metadata => 'Редактирование исходной информации';

  @override
  String get source_clear_cookies =>
      'Очистить файлы cookie для этого веб-сайта.';

  @override
  String get source_clear_cookies_hint =>
      'Возможно, вам придется снова войти в систему при следующем посещении.';

  @override
  String get source_uninstall => 'Удаление источника';

  @override
  String get source_settings_save_failed =>
      'Сохранение не завершилось. Снова откройте настройки исходного кода, чтобы проверить.';

  @override
  String get repository_third_party => 'Сторонние репозитории';

  @override
  String get repository_refresh_failed =>
      'Не удалось обновить каталог. Кэшированный контент сохраняется. Пожалуйста, попробуйте еще раз.';

  @override
  String get repository_show_sources =>
      'Показать исходники из этого репозитория';

  @override
  String get repository_copy_catalog => 'Скопировать ссылку на каталог';

  @override
  String get repository_remove => 'Удалить репозиторий';

  @override
  String get repository_remove_hint =>
      'Сохраните установленные источники и удалите неустановленные записи каталога.';

  @override
  String get repository_empty => 'Сторонние репозитории пока не добавлены.';

  @override
  String get repository_built_in => 'Встроенный официальный каталог.';

  @override
  String get repository_hidden => 'Скрытый';

  @override
  String get repository_refreshing => 'Обновление…';

  @override
  String get repository_refresh => 'Обновить каталог';

  @override
  String get repository_manage_hint =>
      'Управляйте тем, откуда загружаются сторонние источники.';

  @override
  String get repository_invalid_address =>
      'Введите действительный HTTP или HTTPS URL.';

  @override
  String get repository_already_added => 'Этот репозиторий уже добавлен';

  @override
  String get repository_unrecognized =>
      'Поддерживаемый каталог не найден. Проверьте ссылку и повторите попытку.';

  @override
  String get repository_read_failed =>
      'Не удалось прочитать каталог. Пожалуйста, попробуйте еще раз.';

  @override
  String get repository_save_failed =>
      'Сохранение не завершилось. Проверьте список репозиториев.';

  @override
  String get repository_paste_hint =>
      'Вставьте ссылку на каталог стороннего репозитория.';

  @override
  String get repository_address => 'Репозиторий URL';

  @override
  String get repository_paste_link => 'Вставить ссылку';

  @override
  String repository_recognized(String type) {
    return '$type · Каталог признан';
  }

  @override
  String get repository_choose_sources_hint =>
      'После добавления репозитория выберите нужные вам источники.';

  @override
  String get search_scope => 'Область поиска';

  @override
  String get search_scope_hint => 'Выберите веб-сайты для поиска';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Поиск на $count сайта',
      many: 'Поиск на $count сайтах',
      few: 'Поиск на $count сайтах',
      one: 'Поиск на $count сайте',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Найти веб-сайт';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано $count сайта',
      many: 'Выбрано $count сайтов',
      few: 'Выбрано $count сайта',
      one: 'Выбран $count сайт',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Очистить';

  @override
  String get search_deselect_results =>
      'Отмените выбор соответствующих веб-сайтов.';

  @override
  String get search_select_results => 'Выбор подходящих веб-сайтов';

  @override
  String get search_no_websites_hint =>
      'Нет подходящих веб-сайтов. Попробуйте другое имя или язык.';

  @override
  String get search_select_website_hint =>
      'Выберите по меньшей мере один веб-сайт для поиска.';

  @override
  String get search_start_title =>
      'Введите ключевые слова, чтобы найти заголовки.';

  @override
  String get search_start_hint =>
      'Выполняйте поиск по нескольким веб-сайтам одновременно и показывайте соответствующие заголовки.';

  @override
  String get search_empty_scope =>
      'В этой области нет доступных для поиска веб-сайтов.';

  @override
  String get search_empty_scope_hint =>
      'Переключитесь на все веб-сайты или выберите веб-сайты для поиска.';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count результата',
      many: '$count результатов',
      few: '$count результата',
      one: '$count результат',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'Поиск по заголовкам';

  @override
  String get search_actions => 'Поисковые действия';

  @override
  String get search_details => 'Детали поиска';

  @override
  String get search_title_hint => 'Поиск по названию';

  @override
  String get search_searching => 'Поиск';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count результата',
      many: 'Найдено $count результатов',
      few: 'Найдено $count результата',
      one: 'Найден $count результат',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'Нет соответствующих результатов';

  @override
  String get search_failed => 'Поиск не удался';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count названий',
      one: 'Найдено 1 название',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: '$websites веб-сайты',
      one: '1 веб-сайт',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Поиск заголовков';

  @override
  String get search_complete => 'Поиск завершен';

  @override
  String get search_in_progress => 'Поиск';

  @override
  String get search_finding_related => 'Ищем подходящие названия…';

  @override
  String get search_no_results_yet => 'Пока нет результатов поиска';

  @override
  String get search_no_matching_titles =>
      'Соответствующие заголовки не найдены';

  @override
  String get search_results_appear_hint =>
      'Результаты будут появляться здесь по мере их обнаружения.';

  @override
  String get search_failed_websites_hint =>
      'Некоторые веб-сайты не смогли завершить поиск. Повторите их в деталях поиска.';

  @override
  String get search_change_keywords_hint =>
      'Попробуйте использовать более короткие ключевые слова или выполните поиск на большем количестве веб-сайтов.';

  @override
  String get search_view_details => 'Просмотр деталей поиска';

  @override
  String get search_adjust_scope => 'Настройка области поиска';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count веб-сайты',
      one: '1 веб-сайт',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Завершено $completed / $total';
  }

  @override
  String get search_retry_website_hint =>
      'Повторите неудачные веб-сайты по отдельности.';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано $count элемента',
      many: 'Выбрано $count элементов',
      few: 'Выбрано $count элемента',
      one: 'Выбран $count элемент',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Языки поиска';

  @override
  String get source_deselect => 'Отменить выбор';

  @override
  String get source_select => 'Выбор источника';

  @override
  String get source_multilingual => 'Многоязычный';

  @override
  String get source_language_unknown => 'Язык не указан';

  @override
  String get source_adult_content => 'Содержит контент 18+';

  @override
  String get source_classification_unknown => 'Классификация не указана';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Просмотр всей исходной информации, $count дополнительных категорий',
      one: 'Посмотреть всю исходную информацию, еще 1 категорию',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Загрузка веб-сайта';

  @override
  String get source_unpin => 'Открепить';

  @override
  String get source_pin => 'Штифт';

  @override
  String get source_open => 'Открыть';

  @override
  String get source_metadata_hint =>
      'Информация взята из исходного каталога. Категории описывают контент, представленный на веб-сайте.';

  @override
  String get source_region => 'Регион';

  @override
  String get source_format => 'Формат';

  @override
  String get source_creation => 'Создание';

  @override
  String get source_unspecified => 'Не указано';

  @override
  String get source_pricing => 'Ценообразование';

  @override
  String get source_region_jp => 'Японские комиксы';

  @override
  String get source_region_kr => 'Корейские комиксы';

  @override
  String get source_region_cn => 'Китайские комиксы';

  @override
  String get source_region_hk_tw => 'Комиксы о Гонконге и Тайване';

  @override
  String get source_region_western => 'Вестерн-комиксы';

  @override
  String get source_region_other => 'Другие регионы';

  @override
  String get source_format_page => 'Страничные комиксы';

  @override
  String get source_format_vertical => 'Вертикальные комиксы';

  @override
  String get source_format_strip => 'Комиксы';

  @override
  String get source_creation_original => 'Оригинал';

  @override
  String get source_creation_fan => 'Вентилятор работает';

  @override
  String get source_free_watch => 'Бесплатно для просмотра';

  @override
  String get source_free_read => 'Бесплатное чтение';

  @override
  String get source_partial_paid => 'Частично оплачено';

  @override
  String get source_paid_watch => 'Платный просмотр';

  @override
  String get source_paid_read => 'Платное чтение';

  @override
  String get source_pricing_unknown => 'Цена не указана';

  @override
  String get source_language_filter => 'Фильтр по языку';

  @override
  String get source_language_filter_hint =>
      'Фильтровать только этот каталог. Установленные источники не затрагиваются.';

  @override
  String get source_all_languages => 'Все языки';

  @override
  String get action_apply => 'Применить';

  @override
  String get source_load_retry =>
      'Не удалось загрузить этот сайт. Пожалуйста, попробуйте еще раз.';

  @override
  String get source_catalog_refresh_failed =>
      'Не удалось обновить каталог. Текущий контент сохраняется. Потяните вниз, чтобы повторить попытку.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалить исходники $count?',
      one: 'Удалить 1 источник?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Удалите выбранные источники и очистите их настройки. Сохраняйте названия библиотек и загрузки.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не удалось выполнить действия для источников $count.',
      one: 'Не удалось выполнить действие для 1 источника.',
    );
    return '$_temp0 Выбор сохранен. Пожалуйста, попробуйте еще раз.';
  }

  @override
  String get source_latest_content => 'Последний контент';

  @override
  String get source_actions => 'Исходные действия';

  @override
  String get source_bulk_manage => 'Управление несколькими источниками';

  @override
  String get source_update_installed => 'Обновление установленных источников';

  @override
  String get source_no_matching_websites => 'Нет подходящих веб-сайтов';

  @override
  String get source_no_websites => 'Нет доступных веб-сайтов';

  @override
  String get source_search_installed_hint =>
      'Поиск по заголовкам в установленных источниках';

  @override
  String get source_global_search => 'Поиск по источникам';

  @override
  String get source_manage_repositories => 'Управление репозиториями';

  @override
  String get source_view_third_party => 'Просмотр сторонних источников';

  @override
  String get source_catalog_load_failed =>
      'Не удалось загрузить каталог. Потяните вниз, чтобы повторить попытку.';

  @override
  String get source_all_websites => 'Все веб-сайты';

  @override
  String get source_available => 'Доступен для установки';

  @override
  String get source_third_party => 'Третья сторона';

  @override
  String get source_name_or_title => 'Название или заголовок веб-сайта';

  @override
  String get view_all => 'Посмотреть все';

  @override
  String get search_searching_ellipsis => 'Поиск…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · Непроверено';
  }

  @override
  String get onboarding_untested => 'Непроверено';

  @override
  String get source_custom_scope => 'Пользовательский';

  @override
  String get source_custom_websites => 'Избранные веб-сайты';

  @override
  String get tv_hidden_library_hint =>
      'Каждый заголовок находится в скрытой категории.\nУдерживайте кнопку «Все», чтобы отобразить один.';

  @override
  String get tv_no_matching_anime => 'Нет подходящего аниме';

  @override
  String tv_no_matching_category(String category) {
    return 'В «$category» нет подходящего аниме.';
  }

  @override
  String get tv_filtered_empty_hint =>
      'Ни одно аниме не соответствует текущим фильтрам.\nИзмените их с помощью кнопки рядом с поиском.';

  @override
  String get tv_new_episodes => 'Новые эпизоды';

  @override
  String get tv_recently_added => 'Недавно добавлено';

  @override
  String get tv_empty_category_hint =>
      'В этой категории пока нет аниме.\nДобавьте к нему заголовки со страницы сведений о заголовке.';

  @override
  String get tv_empty_library => 'Ваша библиотека аниме пуста.';

  @override
  String get tv_empty_library_hint =>
      'Добавьте аниме из Обзора, чтобы заполнить свой дом';

  @override
  String get tv_browse_anime => 'Просмотр аниме';

  @override
  String tv_new_count(int count) {
    return '$count новый';
  }

  @override
  String tv_category_hidden(String category) {
    return 'Спрятал «$category» · удерживайте ОК на «Все», чтобы отобразить';
  }

  @override
  String get tv_no_hidden_categories => 'Нет скрытых категорий';

  @override
  String get import_torrent_file => 'импортировать файл .torrent';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi и т. д.';

  @override
  String get cloudflare_proxy_optional =>
      'Дополнительный FlareSolverr/Byparr URL';

  @override
  String get tv_home_layout_hint =>
      'Главная страница аниме на основе строк (Продолжение · Новые эпизоды · категории) вместо плоской сетки.';

  @override
  String get tv_hide_libraries_hint =>
      'Скрыть библиотеки манги и романов (на ТВ включено по умолчанию)';

  @override
  String get anime_only_hint =>
      'Скрыть мангу и романы в приложении. Выключите, чтобы показать все.';

  @override
  String get audio_auto_safe => 'Автоматический сейф';

  @override
  String get tv_player_hint =>
      'Включено: выделенный ТВ-плеер.  Выкл.: оригинальный (настольный) плеер.';

  @override
  String get release_open_failed => 'Невозможно открыть релиз.';

  @override
  String get tv_replay => 'Повтор';

  @override
  String get tv_no_episodes => 'Серий пока нет';

  @override
  String get tracker_continue_series => 'Продолжить просмотр сериала';

  @override
  String get tracker_watchlist_series => 'Серия «Список наблюдения»';

  @override
  String get tracker_continue_movies => 'Продолжить просмотр фильмов';

  @override
  String get tracker_watchlist_movies => 'Фильмы из списка просмотра';

  @override
  String get tracker_trending_series => 'Серия трендов';

  @override
  String get tracker_trending_movies => 'Популярные фильмы';

  @override
  String get tracker_popular_series => 'Популярный сериал';

  @override
  String get tracker_popular_movies => 'Популярные фильмы';

  @override
  String get tracker_top_series => 'Лучшие серии (за все время)';

  @override
  String get tracker_top_movies => 'Лучшие фильмы (за все время)';

  @override
  String get tracker_airing_series => 'Серия проветривания';

  @override
  String get tracker_airing_anime => 'Проветривание аниме';

  @override
  String get tracker_popular_anime => 'Популярное аниме';

  @override
  String get tracker_upcoming_anime => 'Предстоящее аниме';

  @override
  String get tracker_popular_manga => 'Популярная манга';

  @override
  String get tracker_top_manga => 'Топ манги';

  @override
  String get tracker_top_manhwa => 'Топ Манхва';

  @override
  String get tracker_top_manhua => 'Верх Маньхуа';

  @override
  String get tracker_latest_anime => 'Последнее аниме';

  @override
  String get tracker_best_anime => 'Аниме с лучшим рейтингом';

  @override
  String get tracker_latest_manga => 'Последняя манга';

  @override
  String get tracker_best_manga => 'Манга с лучшим рейтингом';

  @override
  String get tracker_trending_anime => 'Популярное аниме';

  @override
  String get tracker_upcoming_manga => 'Предстоящая манга';

  @override
  String get tracker_trending_manga => 'Популярная манга';

  @override
  String selection_progress(int selected, int total) {
    return 'Выбран $selected/$total';
  }

  @override
  String get source_code_editor => 'Редактор кода';

  @override
  String get source_code_execute => 'Выполнить';

  @override
  String get source_console_logs => 'Журналы консоли';

  @override
  String get source_no_logs => 'Журналов пока нет';

  @override
  String get source_updated_successfully => 'Исходный код успешно обновлен.';

  @override
  String get source_obsolete => 'УСТАРЕЛО';

  @override
  String player_seek_forward_seconds(int seconds) {
    return 'Поиск вперед на $seconds секунд.';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return 'Поиск назад на $seconds секунд.';
  }

  @override
  String get player_autoplay_on =>
      'Автовоспроизведение следующего эпизода: вкл.';

  @override
  String get player_autoplay_off =>
      'Автовоспроизведение следующего эпизода: выключено.';

  @override
  String get player_no_other_quality => 'Никакого другого качества';

  @override
  String get player_no_subtitles => 'Никаких субтитров';

  @override
  String get player_no_audio_tracks => 'Нет звуковых дорожек';

  @override
  String get player_seek_forward => 'Поиск вперед';

  @override
  String get player_seek_backward => 'Поиск назад';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds секунды',
      many: '$seconds секунд',
      few: '$seconds секунды',
      one: '$seconds секунда',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'Lorem ipsum dolor sit amet';

  @override
  String get subtitle_style => 'Стиль';

  @override
  String get translation_official_channel => 'NodeLane Официальный';

  @override
  String get translation_auth_required =>
      'Сначала войдите в свою учетную запись перевода.';

  @override
  String get translation_source_changed =>
      'Исходное изображение изменилось. Пожалуйста, перезагрузите его.';

  @override
  String get translation_source_missing =>
      'Исходное изображение в настоящее время недоступно.';

  @override
  String get translation_resource_limit =>
      'Это изображение превышает предел обработки устройства. Оригинал сохраняется.';

  @override
  String get translation_storage_full =>
      'Хранилище переводов заполнено. Сначала очистите переведенные изображения.';

  @override
  String get translation_invalid_image =>
      'Неверный формат изображения или содержимое.';

  @override
  String get translation_unsupported_image =>
      'Для этого изображения перевод не поддерживается. Оригинал сохраняется.';

  @override
  String get translation_invalid_result =>
      'Проверка переведенного изображения не удалась. Пожалуйста, перезагрузите его.';

  @override
  String get translation_result_unavailable =>
      'Переведенное изображение недоступно. Пожалуйста, перезагрузите его.';

  @override
  String get translation_result_expired =>
      'Срок действия переведенного изображения истек. Пожалуйста, переведите еще раз.';

  @override
  String get translation_analysis_too_large =>
      'Слишком много изображений для анализа. Уменьшите размер изображения и повторите попытку.';

  @override
  String get translation_region_limit =>
      'Изображение имеет слишком много текстовых областей. Разделите его и попробуйте еще раз.';

  @override
  String get translation_text_limit =>
      'Текстовая область слишком длинная. Настройте изображение и повторите попытку.';

  @override
  String get translation_unavailable => 'Этот перевод больше не доступен.';

  @override
  String get translation_outcome_unknown =>
      'Результат требует проверки. Оно не было отправлено повторно.';

  @override
  String get translation_rate_limited =>
      'Запросы ограничены. Перевод возобновится автоматически.';

  @override
  String get translation_quota_exhausted => 'Недостаточная квота перевода.';

  @override
  String get translation_unsupported_language =>
      'Сервис не поддерживает этот целевой язык.';

  @override
  String get translation_upgrade_required =>
      'Протокол трансляции несовместим. Обновите приложение.';

  @override
  String get translation_remote_failed =>
      'Не удалось перевести эту страницу. Вы можете повторить попытку вручную.';

  @override
  String get translation_bridge_invalid =>
      'Веб-страница изменилась. Включите перевод снова.';

  @override
  String get translation_connection_failed =>
      'Соединение не удалось. Пожалуйста, попробуйте еще раз.';

  @override
  String get translation_paused =>
      'Перевод приостановлен. Вы можете проверить его ход.';

  @override
  String get translation_preparing_ellipsis => 'Готовим перевод…';

  @override
  String get translation_checking_original => 'Проверка исходного изображения…';

  @override
  String get translation_submitting => 'Отправка…';

  @override
  String get translation_uploading_ellipsis => 'Загрузка оригинала…';

  @override
  String get translation_waiting_ellipsis => 'Ожидание перевода…';

  @override
  String get translation_running_ellipsis => 'Перевод…';

  @override
  String get translation_verify_result => 'Результат требует проверки.';

  @override
  String get translation_partial => 'Некоторый контент был переведен';

  @override
  String get translation_ready => 'Переведенное изображение готово';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Играть';

  @override
  String get player_quality => 'Качество';

  @override
  String get player_subtitles => 'Субтитры';

  @override
  String get player_audio => 'Аудио';

  @override
  String get player_statistics => 'Статистика для ботаников';

  @override
  String get player_auto => 'Авто';

  @override
  String get source_information => 'Исходная информация';

  @override
  String get source_code_page => 'Страница';

  @override
  String get source_code_query => 'Запрос';

  @override
  String get repository_invalid_source => 'Неверный источник – удалите его.';

  @override
  String get player_fit_contain => 'Содержать';

  @override
  String get player_fit_cover => 'Крышка';

  @override
  String get player_fit_fill => 'Заполнить';

  @override
  String get player_fit_height => 'Высота';

  @override
  String get player_fit_width => 'Ширина';

  @override
  String get player_fit_scale => 'Масштаб';

  @override
  String get player_fit_none => 'Нет';

  @override
  String get player_shader_clear => 'Выкл. (очистить шейдеры)';

  @override
  String get player_shader_luma => 'Увеличение яркости';

  @override
  String get player_decoder_auto => 'Авто (аппаратное обеспечение)';

  @override
  String get player_decoder_software =>
      'Программное обеспечение (без аппаратного обеспечения)';

  @override
  String get player_stats_toggle => 'Переключение наложения';

  @override
  String get player_stats_general => 'Общие сведения';

  @override
  String get player_stats_frames => 'Тайминги кадров';

  @override
  String get player_stats_cache => 'Входной кэш';

  @override
  String get player_stats_filters => 'Активные фильтры';

  @override
  String get player_stats_log => 'Журнал';

  @override
  String get source_mark_pinned => 'Штифт';

  @override
  String translation_image_action(String action) {
    return '$action это изображение';
  }

  @override
  String get memory_waiting => 'Память: ожидание образца';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current пик $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'кэш $current/$limit пик $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'элементы $count/$limit живой $live пик $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count образцы',
      one: '1 образец',
    );
    return 'полный $percent% от $_temp0';
  }

  @override
  String get memory_reset_hint =>
      'Включите и выключите его в настройках для сброса';

  @override
  String get action_hide => 'Скрыть';

  @override
  String discord_get_app(String app) {
    return 'Получите $app';
  }

  @override
  String get discord_idle => 'Холостой ход';

  @override
  String discord_watching_title(String title) {
    return 'Смотрю $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'Чтение $title';
  }
}
