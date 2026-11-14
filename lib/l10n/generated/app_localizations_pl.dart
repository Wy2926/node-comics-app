// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get browser_search_hint => 'Szukaj lub wpisz URL';

  @override
  String get browser_start_hint => 'Nowa strona dla nowych odkryć.';

  @override
  String get browser_search_engine => 'Wyszukiwarka';

  @override
  String get browser_bookmarks => 'Zakładki';

  @override
  String get browser_search_library => 'Szukaj tytułów lub adresów URL';

  @override
  String get browser_data_failed =>
      'Nie udało się odczytać lub zapisać danych przeglądarki. Spróbuj ponownie.';

  @override
  String get browser_clear_history => 'Wyczyść historię przeglądania';

  @override
  String get browser_clear_history_hint =>
      'Usunąć całą historię na tym urządzeniu? Zakładki i logowania do witryn zostaną zachowane.';

  @override
  String get browser_library_empty => 'Jeszcze nic tu nie ma';

  @override
  String get browser_bookmarks_hint =>
      'Dodaj stronę do zakładek z jej menu, aby znaleźć ją tutaj.';

  @override
  String get browser_history_hint =>
      'Odwiedzone strony pozostają tutaj nawet po zamknięciu kart.';

  @override
  String get browser_recent => 'Ostatnio odwiedzone';

  @override
  String get browser_pinned_hint =>
      'Przypnij ulubione witryny w Źródłach, aby mieć do nich szybki dostęp.';

  @override
  String get browser_start_page => 'Strona startowa';

  @override
  String get browser_remove_bookmark => 'Usuń zakładkę';

  @override
  String get browser_add_bookmark => 'Dodaj zakładkę';

  @override
  String get browser_find => 'Znajdź na stronie';

  @override
  String get browser_copy_link => 'Kopiuj link';

  @override
  String get browser_action_failed =>
      'Nie udało się ukończyć działania. Spróbuj ponownie.';

  @override
  String get browser_find_previous => 'Poprzednie dopasowanie';

  @override
  String get browser_find_next => 'Następne dopasowanie';

  @override
  String browser_find_matches(int current, int total) {
    return 'Dopasowanie $current z $total';
  }

  @override
  String get app_update_details_hint =>
      'Wyświetl uwagi do wydania i opcje instalacji';

  @override
  String get app_update_download => 'Pobierz aktualizację';

  @override
  String get app_update_download_hint =>
      'Po pobraniu postępuj zgodnie z instrukcjami, aby zainstalować aktualizację.';

  @override
  String get bookshelf_all => 'Wszystko';

  @override
  String get bookshelf_search => 'Przeszukiwanie biblioteki';

  @override
  String get app_update_allow_install =>
      'Zezwól na instalację aplikacji w ustawieniach systemu, a następnie wróć i dotknij Instaluj.';

  @override
  String get app_update_waiting => 'Oczekiwanie, aż system wznowi pobieranie…';

  @override
  String get app_update_cancel_download => 'Anuluj pobieranie';

  @override
  String get app_update_remove_package => 'Usuń pobrany pakiet';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'Brak pasujących ustawień';

  @override
  String get search_empty_hint =>
      'Wypróbuj inne słowo kluczowe lub wyczyść wyszukiwanie, aby zobaczyć wszystko.';

  @override
  String get search_clear => 'Wyczyść wyszukiwanie';

  @override
  String get app_updates => 'Aktualizacje aplikacji';

  @override
  String get app_update_auto => 'Sprawdź przy uruchomieniu';

  @override
  String get app_update_view => 'Wyświetl aktualizację';

  @override
  String get app_update_later => 'Później';

  @override
  String get app_update_external_hint =>
      'Otwiera łącze aktualizacji w przeglądarce';

  @override
  String get app_update_failed =>
      'Nie można sprawdzić dostępności aktualizacji. Spróbuj ponownie.';

  @override
  String get app_update_opened => 'Otwarto łącze aktualizacyjne';

  @override
  String get app_diagnostics => 'Diagnostyka i dzienniki';

  @override
  String get library => 'Biblioteka';

  @override
  String get updates_search => 'Wyszukaj aktualizacje';

  @override
  String get updates => 'Aktualizacje';

  @override
  String get history => 'Historia';

  @override
  String get browse => 'Przeglądaj';

  @override
  String get more => 'Więcej';

  @override
  String get open_random_entry => 'Otwórz losowy wpis';

  @override
  String get import => 'Import';

  @override
  String get filter => 'Filtr';

  @override
  String get ignore_filters => 'Ignoruj filtry';

  @override
  String get downloaded => 'Pobrano';

  @override
  String get unread => 'Nieprzeczytane';

  @override
  String get unwatched => 'Nieobejrzane';

  @override
  String get started => 'Rozpoczęto';

  @override
  String get bookmarked => 'Dodano zakładkę';

  @override
  String get sort => 'Sortowanie';

  @override
  String get alphabetically => 'Alfabetycznie';

  @override
  String get last_read => 'Ostatni odczyt';

  @override
  String get last_watched => 'Ostatnio oglądane';

  @override
  String get last_update_check => 'Kontrola ostatniej aktualizacji';

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
          'Usuwasz wszystkie $count $entryTypePlural tego $mediaType z biblioteki.',
      one: 'Usuwasz jedyny $entryType z tego $mediaType z biblioteki.',
    );
    return '$_temp0\nSpowoduje to również usunięcie całego $mediaType z twojej biblioteki.\n\nUwaga: same pliki nie zostaną usunięte.';
  }

  @override
  String get chapter => 'rozdział';

  @override
  String get episode => 'odcinek';

  @override
  String get unread_count => 'Nieprzeczytana liczba';

  @override
  String get unwatched_count => 'Liczba nieobserwowanych';

  @override
  String get latest_chapter => 'Najnowszy rozdział';

  @override
  String get latest_episode => 'Ostatni odcinek';

  @override
  String get date_added => 'Dodano datę';

  @override
  String get display => 'Wyświetlacz';

  @override
  String get display_mode => 'Tryb wyświetlania';

  @override
  String get compact_grid => 'Siatka zwarta';

  @override
  String get compression_level => 'Poziom kompresji';

  @override
  String compression_info(Object level) {
    return 'Im wyższa kompresja, tym mniej miejsca zajmuje plik kopii zapasowej, ale zużywa więcej procesora. Wartość domyślna: $level';
  }

  @override
  String get comfortable_grid => 'Wygodna siatka';

  @override
  String get cover_only_grid => 'Siatka tylko przykrywająca';

  @override
  String get list => 'Lista';

  @override
  String get badges => 'Odznaki';

  @override
  String get downloaded_chapters => 'Pobrane rozdziały';

  @override
  String get downloaded_episodes => 'Pobrane odcinki';

  @override
  String get language => 'Język';

  @override
  String get local_source => 'Źródło lokalne';

  @override
  String get tabs => 'Tabsy';

  @override
  String get show_category_tabs => 'Pokaż karty kategorii';

  @override
  String get show_numbers_of_items => 'Pokaż numery elementów';

  @override
  String get other => 'Inne';

  @override
  String get show_continue_reading_buttons =>
      'Pokaż przyciski kontynuacji czytania';

  @override
  String get show_continue_watching_buttons =>
      'Pokaż przyciski kontynuacji oglądania';

  @override
  String get empty_library => 'Pusta biblioteka';

  @override
  String get search => 'Szukaj...';

  @override
  String get no_recent_updates => 'Brak ostatnich aktualizacji';

  @override
  String get remove_everything => 'Usuń wszystko';

  @override
  String get remove_everything_msg =>
      'Czy jesteś pewien? Cała historia zostanie utracona';

  @override
  String get remove_all_update_msg =>
      'Czy jesteś pewien? Cała aktualizacja zostanie wyczyszczona';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Anuluj';

  @override
  String get remove => 'Usuń';

  @override
  String get remove_history_msg =>
      'Spowoduje to usunięcie daty przeczytania tego rozdziału. Czy jesteś pewien?';

  @override
  String get last_used => 'Ostatnio użyte';

  @override
  String get pinned => 'Przypięty';

  @override
  String get sources => 'Źródła';

  @override
  String get install => 'Zainstaluj';

  @override
  String get update => 'Aktualizacja';

  @override
  String get latest => 'Najnowsze';

  @override
  String get extensions => 'Rozszerzenia';

  @override
  String get migrate => 'Migracja';

  @override
  String get mass_migration_title => 'Masowa migracja';

  @override
  String get mass_migration_preview_items => 'Podgląd elementów';

  @override
  String get mass_migration_destination_source => 'Źródło docelowe';

  @override
  String get mass_migration_no_library_items =>
      'Żadne elementy biblioteki nie są dostępne do masowej migracji.';

  @override
  String get mass_migration_no_destination_sources =>
      'Nie są dostępne żadne zainstalowane źródła docelowe.';

  @override
  String get mass_migration_installed => 'Zainstalowano';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementy gotowe do przeglądu',
      one: '1 element gotowy do przeglądu',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementy',
      one: '1 pozycja',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Wybierz źródło docelowe';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Znajdowanie dopasowań w $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Przetwarzanie elementu $current z $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Oczekiwanie 2 sekundy przed następnym elementem...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Oczekiwanie 2 sekundy przed następną migracją...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Dotychczas dopasowane: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Brak dopasowania: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Przejrzyj dopasowania dla $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Znaleziono dopasowania: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Brak dopasowań: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Wybrano do migracji: $count';
  }

  @override
  String get mass_migration_finish_review => 'Zakończ przegląd';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migracja wybranych elementów ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Migracja wybranych elementów do $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Nie wybrano żadnych elementów do migracji.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migracja elementu $current z $total';
  }

  @override
  String get mass_migration_complete => 'Zakończono masową migrację';

  @override
  String get mass_migration_complete_success_message =>
      'Wszystkie wybrane elementy zostały pomyślnie przetworzone.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migracja zakończyła się kilkoma elementami, które nadal wymagają ręcznej uwagi.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Przetworzone';

  @override
  String get mass_migration_matched => 'Dopasowane';

  @override
  String get mass_migration_migrated => 'Migrowano';

  @override
  String get mass_migration_skipped => 'Pominięte';

  @override
  String get mass_migration_failed => 'Nie udało się';

  @override
  String get mass_migration_failed_items => 'Elementy nieudane';

  @override
  String get mass_migration_exit => 'Wyjdź z masowej migracji';

  @override
  String get mass_migration_no_destination_match =>
      'Nie znaleziono dopasowania miejsca docelowego';

  @override
  String mass_migration_query(Object query) {
    return 'Zapytanie: $query';
  }

  @override
  String get mass_migration_skip => 'Pomiń';

  @override
  String get mass_migration_loading => 'Ładowanie...';

  @override
  String get mass_migration_choose_another_result => 'Wybierz inny wynik';

  @override
  String get mass_migration_source_chapters => 'Rozdziały źródłowe';

  @override
  String get mass_migration_destination_chapters => 'Rozdziały docelowe';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rozdziałów',
      one: '1 rozdział',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rozdziały źródłowe',
      one: '1 rozdział źródłowy',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rozdziały docelowe',
      one: '1 rozdział docelowy',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Nie znaleziono rozdziałów.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'I $count więcej...';
  }

  @override
  String get mass_migration_unknown_title => 'Tytuł nieznany';

  @override
  String get mass_migration_unknown_match => 'Nieznane dopasowanie';

  @override
  String get mass_migration_unknown_source => 'Nieznane źródło';

  @override
  String get mass_migration_unknown_chapter => 'Nieznany rozdział';

  @override
  String get migrate_confirm => 'Migracja do innego źródła';

  @override
  String get clean_database => 'Wyczyść bazę danych';

  @override
  String cleaned_database(Object x) {
    return 'Baza danych wyczyszczona! Usunięto wpisy $x';
  }

  @override
  String get clean_database_desc =>
      'Spowoduje to usunięcie wszystkich elementów, które nie zostały dodane do biblioteki!';

  @override
  String get incognito_mode => 'Tryb incognito';

  @override
  String get incognito_mode_description => 'Wstrzymuje historię czytania';

  @override
  String get downloaded_only => 'Tylko pobrane';

  @override
  String get downloaded_only_description =>
      'Pokazuj tylko pobrane wpisy z Twojej biblioteki';

  @override
  String get download_queue => 'Kolejka pobierania';

  @override
  String get categories => 'Kategorie';

  @override
  String get statistics => 'Statystyka';

  @override
  String get settings => 'Ustawienia';

  @override
  String get about => 'Około';

  @override
  String get help => 'Pomoc';

  @override
  String get no_downloads => 'Brak pobierania';

  @override
  String get edit_categories => 'Edytuj kategorie';

  @override
  String get edit_categories_description =>
      'Nie masz kategorii. Stuknij przycisk plusa, aby utworzyć taki, który pozwoli uporządkować bibliotekę';

  @override
  String get add => 'Dodaj';

  @override
  String get add_category => 'Dodaj kategorię';

  @override
  String get name => 'Nazwa';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Wymagane';

  @override
  String get add_category_error_exist => 'Kategoria o tej nazwie już istnieje!';

  @override
  String get delete_category => 'Usuń kategorię';

  @override
  String delete_category_msg(Object name) {
    return 'Czy chcesz usunąć kategorię $name?';
  }

  @override
  String get rename_category => 'Zmień nazwę kategorii';

  @override
  String get general => 'Ogólne';

  @override
  String get general_subtitle => 'Język aplikacji';

  @override
  String get app_language => 'Język aplikacji';

  @override
  String get default_subtitle_language => 'Domyślny język napisów';

  @override
  String get appearance => 'Wygląd';

  @override
  String get appearance_subtitle => 'Temat, format daty i godziny';

  @override
  String get theme => 'Motyw';

  @override
  String get dark_mode => 'Tryb ciemny';

  @override
  String get follow_system_theme => 'Postępuj zgodnie z motywem systemu';

  @override
  String get on => 'Włączone';

  @override
  String get off => 'Wyłączone';

  @override
  String get pure_black_dark_mode => 'Tryb ciemnej czystej czerni';

  @override
  String get timestamp => 'Znacznik czasu';

  @override
  String get relative_timestamp => 'Względny znacznik czasu';

  @override
  String get relative_timestamp_short => 'Krótko (dzisiaj, wczoraj)';

  @override
  String get relative_timestamp_long => 'Długie (krótkie+, n dni temu)';

  @override
  String get date_format => 'Format daty';

  @override
  String get reader => 'Czytnik';

  @override
  String get refresh => 'Odśwież';

  @override
  String get reader_subtitle => 'Tryb odczytu, wyświetlacz, nawigacja';

  @override
  String get default_reading_mode => 'Domyślny tryb odczytu';

  @override
  String get reading_mode_vertical => 'Pionowo';

  @override
  String get reading_mode_horizontal => 'Poziomo';

  @override
  String get reading_mode_left_to_right => 'Od lewej do prawej';

  @override
  String get reading_mode_right_to_left => 'Od prawej do lewej';

  @override
  String get reading_mode_vertical_continuous => 'Ciągły w pionie';

  @override
  String get reading_mode_webtoon => 'Narzędzie internetowe';

  @override
  String get double_tap_animation_speed =>
      'Szybkość animacji podwójnego dotknięcia';

  @override
  String get normal => 'Normalny';

  @override
  String get fast => 'Szybko';

  @override
  String get no_animation => 'Brak animacji';

  @override
  String get animate_page_transitions => 'Animuj przejścia stron';

  @override
  String get crop_borders => 'Granice upraw';

  @override
  String get downloads => 'Pobieranie';

  @override
  String get downloads_subtitle => 'Ustawienia pobierania';

  @override
  String get download_location => 'Lokalizacja pobierania';

  @override
  String get custom_location => 'Lokalizacja niestandardowa';

  @override
  String get only_on_wifi => 'Tylko na Wi-Fi';

  @override
  String get save_as_cbz_archive => 'Zapisz jako archiwum CBZ';

  @override
  String get delete_download_after_reading =>
      'Usuń pobrane pliki po przeczytaniu';

  @override
  String get concurrent_downloads => 'Równoczesne pobieranie';

  @override
  String get browse_subtitle => 'Źródła, wyszukiwanie globalne';

  @override
  String get only_include_pinned_sources => 'Uwzględnij tylko przypięte źródła';

  @override
  String get nsfw_sources => 'Źródła NSFW (+18).';

  @override
  String get nsfw_sources_show => 'Wyświetlaj na listach źródeł i rozszerzeń';

  @override
  String get nsfw_sources_info =>
      'Nie zapobiega to wyświetlaniu w aplikacji treści NSFW (18+) dla nieoficjalnych lub potencjalnie błędnie oznaczonych rozszerzeń';

  @override
  String get version => 'Wersja';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Sprawdź dostępność aktualizacji';

  @override
  String get logs_on => 'Włącz rejestrowanie';

  @override
  String get share_app_logs => 'Udostępnij dzienniki aplikacji';

  @override
  String get no_app_logs => 'Brak pliku log.txt!';

  @override
  String get failed => 'Nie udało się!';

  @override
  String n_days_ago(Object days) {
    return '$days dni temu';
  }

  @override
  String get today => 'Dzisiaj';

  @override
  String get yesterday => 'Wczoraj';

  @override
  String get a_week_ago => 'Tydzień temu';

  @override
  String get next_week => 'W przyszłym tygodniu';

  @override
  String get add_to_library => 'Dodaj do biblioteki';

  @override
  String get completed => 'Zakończono';

  @override
  String get ongoing => 'W toku';

  @override
  String get on_hiatus => 'W przerwie';

  @override
  String get canceled => 'Anulowano';

  @override
  String get publishing_finished => 'Zakończono publikację';

  @override
  String get unknown => 'Nieznane';

  @override
  String get empty_placeholder => 'PUSTY\nMPTY\nMTY\nMT\n\n';

  @override
  String get error => 'Błąd';

  @override
  String error_with_message(Object error) {
    return 'Błąd: $error';
  }

  @override
  String get no_pages_available => 'Błąd: brak dostępnych stron';

  @override
  String get set_categories => 'Ustaw kategorie';

  @override
  String get edit => 'Edytuj';

  @override
  String get in_library => 'W bibliotece';

  @override
  String get filter_scanlator_groups => 'Filtruj grupy skanerów';

  @override
  String get reset => 'Resetuj';

  @override
  String get by_source => 'Według źródła';

  @override
  String get by_chapter_number => 'Według numeru rozdziału';

  @override
  String get by_episode_number => 'Według numeru odcinka';

  @override
  String get by_upload_date => 'Według daty przesłania';

  @override
  String get source_title => 'Tytuł źródła';

  @override
  String get create_extension => 'Utwórz rozszerzenie';

  @override
  String get developer_mode => 'Tryb programisty';

  @override
  String get developer_mode_subtitle =>
      'Pokaż narzędzia programistyczne rozszerzeń (utwórz rozszerzenie, edytuj kod)';

  @override
  String get choose_extension_language => 'Wybierz język rozszerzenia';

  @override
  String get lang => 'Dł';

  @override
  String get base_url => 'BaseUrl';

  @override
  String get api_url_optional => 'ApiUrl (opcjonalnie)';

  @override
  String get icon_url => 'iconUrl';

  @override
  String get source_icon_url => 'Adres URL ikony źródła';

  @override
  String get notes => 'notatki';

  @override
  String get extension_name_example => 'np.: mojeAnime';

  @override
  String get language_code_example => 'np.: en';

  @override
  String get base_url_example => 'np.: https://example.com';

  @override
  String get api_url_example => 'np.: https://api.example.com';

  @override
  String get extension_notes_example => 'np.: to rozszerzenie wymaga logowania';

  @override
  String get type => 'Typ';

  @override
  String get target => 'Cel';

  @override
  String get source_type_single => 'pojedynczy';

  @override
  String get source_type_multi => 'wiele';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader skompilował JS';

  @override
  String get source_created_successfully =>
      'Źródło zostało utworzone pomyślnie';

  @override
  String get source_already_exists => 'Źródło już istnieje';

  @override
  String get error_when_creating_source => 'Błąd podczas tworzenia źródła';

  @override
  String get cookies_deleted => 'Pliki cookie usunięte!';

  @override
  String get delete_all_cookies => 'Usuń wszystkie pliki cookie';

  @override
  String get chapter_number => 'Numer rozdziału';

  @override
  String get episode_number => 'Numer odcinka';

  @override
  String get share => 'Udostępnij';

  @override
  String n_chapters(Object n) {
    return '$n rozdziałów';
  }

  @override
  String missing_chapters(Object count) {
    return 'Brakujące rozdziały $count';
  }

  @override
  String get no_description => 'Brak opisu';

  @override
  String get resume => 'Wznów';

  @override
  String get read => 'Przeczytaj';

  @override
  String get watch => 'Oglądaj';

  @override
  String get popular => 'Popularne';

  @override
  String get open_in_browser => 'Otwórz w przeglądarce';

  @override
  String get clear_cookie => 'Wyczyść plik cookie';

  @override
  String get show_page_number => 'Pokaż numer strony';

  @override
  String get from_library => 'Z biblioteki';

  @override
  String get downloaded_chapter => 'Pobrany rozdział';

  @override
  String page(Object page) {
    return 'Strona $page';
  }

  @override
  String get global_search => 'Wyszukiwanie globalne';

  @override
  String get color_blend_level => 'Poziom mieszania kolorów';

  @override
  String current(Object char) {
    return 'Prąd $char';
  }

  @override
  String finished(Object char) {
    return 'Zakończono $char';
  }

  @override
  String next(Object char) {
    return 'Następny $char';
  }

  @override
  String previous(Object char) {
    return 'Poprzedni $char';
  }

  @override
  String get no_more_chapter => 'Nie ma już więcej rozdziału';

  @override
  String get no_result => 'Brak rezultatu';

  @override
  String get send => 'Wyślij';

  @override
  String get delete => 'Usuń';

  @override
  String get start_downloading => 'Rozpocznij pobieranie teraz';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get add_chapters => 'Dodaj rozdziały';

  @override
  String get delete_chapters => 'Usunąć rozdział?';

  @override
  String get default0 => 'Domyślnie';

  @override
  String get total_chapters => 'Całkowita liczba rozdziałów';

  @override
  String get total_episodes => 'Całkowita liczba odcinków';

  @override
  String get import_local_file => 'Importuj plik lokalny';

  @override
  String get import_files => 'Pliki';

  @override
  String get split_epub_chapters => 'Podzielony na rozdziały';

  @override
  String get split_epub_chapters_description =>
      'Zaimportuj każdy rozdział EPUB jako oddzielny wpis';

  @override
  String get nothing_read_recently => 'Ostatnio nic nie czytano';

  @override
  String get status => 'Stan';

  @override
  String get not_started => 'Nie rozpoczęto';

  @override
  String get score => 'Ocena';

  @override
  String get start_date => 'Data rozpoczęcia';

  @override
  String get finish_date => 'Data zakończenia';

  @override
  String get reading => 'Czytanie';

  @override
  String get on_hold => 'Wstrzymane';

  @override
  String get dropped => 'Upuszczono';

  @override
  String get plan_to_read => 'Zaplanuj czytanie';

  @override
  String get re_reading => 'Ponowne czytanie';

  @override
  String get chapters => 'Rozdziały';

  @override
  String get add_tracker => 'Dodaj śledzenie';

  @override
  String get one_tracker => '1 moduł śledzący';

  @override
  String n_tracker(Object n) {
    return 'Elementy śledzące $n';
  }

  @override
  String get tracking => 'Śledzenie';

  @override
  String get syncing => 'Synchronizacja';

  @override
  String get sync_logged => 'Logowanie powiodło się';

  @override
  String get syncing_subtitle =>
      'Wprowadź adres serwera synchronizacji i zaloguj się przez przeglądarkę, aby zsynchronizować postęp czytania na różnych urządzeniach.';

  @override
  String get sync_service => 'Synchronizacja na własnym serwerze';

  @override
  String get last_sync => 'Ostatnia synchronizacja o: ';

  @override
  String get sync_login_browser => 'Zaloguj się za pomocą przeglądarki';

  @override
  String get sync_server => 'Adres serwera synchronizacji';

  @override
  String get sync_starting => 'Rozpoczęcie synchronizacji...';

  @override
  String get sync_finished => 'Synchronizacja zakończona';

  @override
  String get sync_failed => 'Synchronizacja nie powiodła się';

  @override
  String get sync_restore_in_progress =>
      'Synchronizacja pominięta – przywracanie w toku';

  @override
  String sync_progress_percent(Object percent) {
    return 'Synchronizacja… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Synchronizowanie…';

  @override
  String get sync_button_sync => 'Postęp synchronizacji';

  @override
  String get sync_button_upload => 'Tylko przesyłanie';

  @override
  String get sync_button_upload_info =>
      'Dane tego urządzenia zastąpią dane serwera w związku z tym, co ono również posiada. Nic na serwerze nie zostanie usunięte.';

  @override
  String get sync_button_download => 'Tylko do pobrania';

  @override
  String get sync_button_download_info =>
      'Pobiera wszystko z serwera. Nic na tym urządzeniu nie zostanie usunięte.';

  @override
  String get sync_status_not_configured => 'Nie podłączony';

  @override
  String get sync_status_checking => 'Sprawdzanie połączenia...';

  @override
  String get sync_status_connected => 'Połączono';

  @override
  String get sync_status_unauthorized => 'Sesja wygasła, zaloguj się ponownie';

  @override
  String get sync_status_unreachable => 'Nie można połączyć się z serwerem';

  @override
  String get sync_section_general => 'Ogólne';

  @override
  String get sync_on => 'Włącz synchronizację';

  @override
  String get sync_auto => 'Automatyczna synchronizacja';

  @override
  String get sync_auto_warning =>
      'Automatyczna synchronizacja jest obecnie funkcją eksperymentalną!';

  @override
  String get sync_auto_off => 'Wyłączone';

  @override
  String get sync_auto_5_minutes => 'Co 5 minut';

  @override
  String get sync_auto_10_minutes => 'Co 10 minut';

  @override
  String get sync_auto_30_minutes => 'Co 30 minut';

  @override
  String get sync_auto_1_hour => 'Co 1 godzinę';

  @override
  String get sync_auto_3_hours => 'Co 3 godziny';

  @override
  String get sync_auto_6_hours => 'Co 6 godzin';

  @override
  String get sync_auto_12_hours => 'Co 12 godzin';

  @override
  String get server_error => 'Błąd serwera!';

  @override
  String get dialog_confirm => 'Potwierdzić';

  @override
  String get description => 'Opis';

  @override
  String get reorder_navigation => 'Dostosuj nawigację';

  @override
  String get reorder_navigation_description =>
      'Zmień kolejność i przełącz każdą nawigację do swoich potrzeb.';

  @override
  String get floating_navigation_bar => 'Pływający pasek nawigacyjny';

  @override
  String get floating_navigation_bar_description =>
      'Użyj pływającej kapsuły zamiast standardowo dołączonego paska nawigacyjnego.';

  @override
  String get full_screen_player => 'Użyj trybu pełnoekranowego';

  @override
  String get full_screen_player_info =>
      'Automatycznie używaj trybu pełnoekranowego podczas odtwarzania wideo.';

  @override
  String episode_progress(Object n) {
    return 'Postęp: $n';
  }

  @override
  String n_episodes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n epizody',
      one: '1 odcinek',
    );
    return '$_temp0';
  }

  @override
  String missing_episodes(Object count) {
    return 'Brakujące odcinki $count';
  }

  @override
  String get manga_sources => 'Źródła mangi';

  @override
  String get anime_sources => 'Źródła anime';

  @override
  String get novel_sources => 'Nowe źródła';

  @override
  String get anime_extensions => 'Rozszerzenia anime';

  @override
  String get manga_extensions => 'Rozszerzenia mangi';

  @override
  String get novel_extensions => 'Nowe rozszerzenia';

  @override
  String get extension_settings => 'Ustawienia rozszerzenia';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Powieść';

  @override
  String get library_no_category_exist => 'Nie masz jeszcze żadnych kategorii';

  @override
  String get watching => 'Oglądanie';

  @override
  String get plan_to_watch => 'Zaplanuj oglądanie';

  @override
  String get re_watching => 'Ponowne oglądanie';

  @override
  String get episodes => 'Epizody';

  @override
  String get download => 'Pobierz';

  @override
  String get new_update_available => 'Dostępna jest nowa aktualizacja';

  @override
  String app_version(Object v) {
    return 'Wersja aplikacji: v$v';
  }

  @override
  String get searching_for_updates => 'Wyszukiwanie aktualizacji...';

  @override
  String get no_new_updates_available => 'Brak dostępnych nowych aktualizacji';

  @override
  String get uninstall => 'Odinstaluj';

  @override
  String uninstall_extension(Object ext) {
    return 'Odinstalować rozszerzenie $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Kliknij dwukrotnie, aby przeszukać wszystkie $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Pokaż wskazówkę wyszukiwania po dwukrotnym dotknięciu';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Wyświetl podpowiedź w miejscach docelowych nawigacji Manga/Anime/Novel wyjaśniającą, że dwukrotne dotknięcie otwiera wyszukiwanie globalne.';

  @override
  String already_in_library(Object source, Object title) {
    return '„$title” jest już w Twojej bibliotece poprzez $source.';
  }

  @override
  String get add_anyway => 'Dodaj mimo to';

  @override
  String get langauage => 'Język';

  @override
  String get extension_detail => 'Szczegóły rozszerzenia';

  @override
  String get scale_type => 'Typ skali';

  @override
  String get scale_type_fit_screen => 'Dopasuj ekran';

  @override
  String get scale_type_stretch => 'Rozciąganie';

  @override
  String get scale_type_fit_width => 'Szerokość dopasowania';

  @override
  String get scale_type_fit_height => 'Wysokość dopasowania';

  @override
  String get scale_type_original_size => 'Rozmiar oryginalny';

  @override
  String get scale_type_smart_fit => 'Inteligentne dopasowanie';

  @override
  String get page_preload_amount => 'Wielkość wstępnego ładowania strony';

  @override
  String get page_preload_amount_subtitle =>
      'Ilość stron do wstępnego załadowania podczas czytania. Wyższe wartości zapewnią płynniejszy odczyt, kosztem większego zużycia pamięci podręcznej i sieci.';

  @override
  String get image_loading_error => 'Nie można załadować tego obrazu';

  @override
  String get add_episodes => 'Dodaj odcinki';

  @override
  String get video_quality => 'Jakość';

  @override
  String get video_subtitle => 'Podtytuł';

  @override
  String get check_for_extension_updates =>
      'Sprawdź aktualizacje rozszerzeń innych firm';

  @override
  String get auto_extensions_updates =>
      'Automatycznie aktualizuj rozszerzenia innych firm';

  @override
  String get auto_extensions_updates_subtitle =>
      'Automatycznie aktualizuj zainstalowane rozszerzenia innych firm. Oficjalne wtyczki są zawsze instalowane i aktualizowane automatycznie.';

  @override
  String get check_for_app_updates =>
      'Sprawdź dostępność aktualizacji aplikacji podczas uruchamiania';

  @override
  String get reading_mode => 'Tryb odczytu';

  @override
  String get custom_filter => 'Filtr niestandardowy';

  @override
  String get background_color => 'Kolor tła';

  @override
  String get white => 'Biały';

  @override
  String get black => 'Czarny';

  @override
  String get grey => 'Szary';

  @override
  String get automaic => 'Automatyczny';

  @override
  String get preferred_domain => 'Preferowana domena';

  @override
  String get load_more => 'Załaduj więcej';

  @override
  String get cancel_all_for_this_series => 'Anuluj wszystko dla tej serii';

  @override
  String get login => 'Zaloguj się';

  @override
  String login_into(Object tracker) {
    return 'Zaloguj się do $tracker';
  }

  @override
  String get email_adress => 'Adres e-mail';

  @override
  String get password => 'Hasło';

  @override
  String log_out_from(Object tracker) {
    return 'Wylogować się z $tracker?';
  }

  @override
  String get log_out => 'Wyloguj się';

  @override
  String get update_pending => 'Aktualizacja w toku';

  @override
  String get update_all => 'Zaktualizuj wszystko';

  @override
  String get backup_and_restore => 'Tworzenie kopii zapasowych i przywracanie';

  @override
  String get create_backup => 'Utwórz kopię zapasową';

  @override
  String get create_backup_dialog_title =>
      'Co chcesz wykonać w kopii zapasowej?';

  @override
  String get create_backup_subtitle =>
      'Można zastosować do przywrócenia bieżącej biblioteki';

  @override
  String get restore_backup => 'Przywróć kopię zapasową';

  @override
  String get encrypt_backups => 'Szyfruj kopie zapasowe';

  @override
  String get encrypt_backups_info =>
      'Pliki kopii zapasowych chroń hasłem przy użyciu szyfrowania AES';

  @override
  String get no_secure_storage => 'Nie znaleziono bezpiecznego magazynu';

  @override
  String get no_keyring_warning =>
      'Ten system nie ma dostępnej usługi pęku kluczy (np. gnome-keyring lub kwallet w systemie Linux), więc hasła nie można bezpiecznie przechowywać.\n\nZamiast tego zapisać go w postaci niezaszyfrowanej w lokalnej bazie danych aplikacji? Każda osoba mająca dostęp do danych aplikacji na tym urządzeniu będzie mogła je odczytać.';

  @override
  String get enter_backup_password => 'Wprowadź hasło zapasowe';

  @override
  String get incorrect_password_try_again =>
      'Nieprawidłowe hasło, spróbuj ponownie.';

  @override
  String get set_backup_password => 'Ustaw hasło zapasowe';

  @override
  String get confirm_password => 'Potwierdź hasło';

  @override
  String get passwords_do_not_match => 'Hasła nie pasują';

  @override
  String get password_required_to_restore =>
      'Do przywrócenia tej kopii zapasowej wymagane jest hasło.';

  @override
  String get restore_backup_subtitle =>
      'Przywróć bibliotekę z pliku kopii zapasowej';

  @override
  String get automatic_backups => 'Automatyczne kopie zapasowe';

  @override
  String get backup_frequency => 'Częstotliwość rezerwowa';

  @override
  String get backup_location => 'Lokalizacja zapasowa';

  @override
  String get backup_options => 'Opcje tworzenia kopii zapasowych';

  @override
  String get backup_options_dialog_title =>
      'Co chcesz wykonać w kopii zapasowej?';

  @override
  String get backup_options_subtitle =>
      'Jakie informacje uwzględnić w pliku kopii zapasowej?';

  @override
  String get backup_and_restore_warning_info =>
      'Kopie kopii zapasowych należy przechowywać także w innych miejscach';

  @override
  String get library_entries => 'Wpisy biblioteki';

  @override
  String get chapters_and_episode => 'Rozdziały i odcinki';

  @override
  String get every_6_hours => 'Co 6 godzin';

  @override
  String get every_12_hours => 'Co 12 godzin';

  @override
  String get daily => 'Codziennie';

  @override
  String get every_2_days => 'Co 2 dni';

  @override
  String get weekly => 'Co tydzień';

  @override
  String get restore_backup_warning_title =>
      'Przywracanie kopii zapasowej spowoduje zastąpienie wszystkich istniejących danych.\n\nKontynuować przywracanie?';

  @override
  String get restore_sync_question_title => 'Zsynchronizować to przywracanie?';

  @override
  String get restore_sync_question_message =>
      'To urządzenie jest podłączone do serwera synchronizacji. Przesłać do niego teraz przywrócone dane? Jeśli nie, synchronizacja zostanie wyłączona, aby stare dane serwera nie zastąpiły właśnie przywróconych danych.';

  @override
  String get restore_sync_question_confirm => 'Tak, synchronizacja';

  @override
  String get restore_sync_question_deny => 'Nie, wyłącz synchronizację';

  @override
  String get sync_disabled_after_restore =>
      'Synchronizacja jest wyłączona. Możesz włączyć tę funkcję ponownie w Ustawieniach.';

  @override
  String get restore_sync_disabled_question_title =>
      'Synchronizacja jest obecnie wyłączona';

  @override
  String get restore_sync_disabled_question_message =>
      'Synchronizacja jest wyłączona. Włączyć go ponownie i przesłać przywrócone dane na serwer?';

  @override
  String get restore_sync_question_reenable =>
      'Tak, włącz ponownie i zsynchronizuj';

  @override
  String get restore_sync_question_keep_disabled =>
      'Pozostaw tę opcję wyłączoną';

  @override
  String get restore_sync_uploading =>
      'Synchronizowanie przywróconych danych z serwerem…';

  @override
  String get restore_sync_upload_success =>
      'Przywrócone dane zsynchronizowane z serwerem';

  @override
  String get services => 'Usługi';

  @override
  String get tracking_warning_info =>
      'Synchronizacja jednokierunkowa w celu aktualizacji postępu rozdziału w usługach śledzenia. Skonfiguruj śledzenie poszczególnych wpisów za pomocą przycisku śledzenia.';

  @override
  String get use_page_tap_zones => 'Użyj stref dotknięcia strony';

  @override
  String get manage_trackers => 'Zarządzaj modułami śledzącymi';

  @override
  String get restore => 'Przywróć';

  @override
  String get backups => 'Kopie zapasowe';

  @override
  String get by_scanlator => 'Za pomocą skanera';

  @override
  String get by_name => 'Według nazwy';

  @override
  String get installed => 'Zainstalowano';

  @override
  String get auto_scroll => 'Automatyczne przewijanie';

  @override
  String get video_audio => 'Dźwięk';

  @override
  String get video_audio_info =>
      'Preferowane języki, korekcja wysokości tonu, kanały audio';

  @override
  String get player => 'Gracz';

  @override
  String get markEpisodeAsSeenSetting =>
      'W którym momencie oznaczyć odcinek jako widoczny';

  @override
  String get mark_duplicate_chapters_read =>
      'Oznacz zduplikowane numery rozdziałów jako przeczytane';

  @override
  String get default_skip_intro_length => 'Czas trwania pominięcia wstępu';

  @override
  String get default_playback_speed_length => 'Domyślna prędkość odtwarzania';

  @override
  String get updateProgressAfterReading => 'Aktualizuj postęp po przeczytaniu';

  @override
  String get no_sources_installed => 'Brak zainstalowanych źródeł!';

  @override
  String get show_extensions => 'Pokaż rozszerzenia';

  @override
  String get default_skip_forward_skip_length =>
      'Dwukrotne dotknięcie czasu wyszukiwania';

  @override
  String get aniskip_requires_info =>
      'Do działania AniSkip wymagane jest śledzenie anime za pomocą MAL lub Anilist.';

  @override
  String get enable_aniskip => 'Włącz AniSkip';

  @override
  String get enable_auto_skip => 'Włącz automatyczne pomijanie';

  @override
  String get aniskip_button_timeout => 'Limit czasu przycisku';

  @override
  String get skip_opening => 'Pomiń otwieranie';

  @override
  String get skip_ending => 'Pomiń zakończenie';

  @override
  String get fullscreen => 'Pełny ekran';

  @override
  String get update_library => 'Aktualizuj bibliotekę';

  @override
  String get next_chapter => 'Następny rozdział';

  @override
  String get next_5_chapters => 'Następnych 5 rozdziałów';

  @override
  String get next_10_chapters => 'Następnych 10 rozdziałów';

  @override
  String get next_25_chapters => 'Następnych 25 rozdziałów';

  @override
  String get all_chapters => 'Wszystkie rozdziały';

  @override
  String get next_episode => 'Następny odcinek';

  @override
  String get next_5_episodes => 'Następnych 5 odcinków';

  @override
  String get next_10_episodes => 'Następnych 10 odcinków';

  @override
  String get next_25_episodes => 'Następnych 25 odcinków';

  @override
  String get all_episodes => 'Wszystkie odcinki';

  @override
  String get cover_saved => 'Okładka zapisana';

  @override
  String get set_as_cover => 'Ustaw jako okładkę';

  @override
  String get use_this_as_cover_art => 'Użyć tego jako okładki?';

  @override
  String get save => 'Zapisz';

  @override
  String get picture_saved => 'Obraz zapisany';

  @override
  String get cover_updated => 'Zaktualizowano okładkę';

  @override
  String get include_subtitles => 'Dołącz napisy';

  @override
  String get blend_mode_default => 'Domyślnie';

  @override
  String get blend_mode_multiply => 'Pomnóż';

  @override
  String get blend_mode_screen => 'Ekran';

  @override
  String get blend_mode_overlay => 'Nakładka';

  @override
  String get blend_mode_colorDodge => 'ColorDodge';

  @override
  String get blend_mode_lighten => 'Rozjaśnić';

  @override
  String get blend_mode_colorBurn => 'ColorBurn';

  @override
  String get blend_mode_darken => 'Przyciemnić';

  @override
  String get blend_mode_difference => 'Różnica';

  @override
  String get blend_mode_saturation => 'Nasycenie';

  @override
  String get blend_mode_softLight => 'SoftLight';

  @override
  String get blend_mode_plus => 'Dodatkowo';

  @override
  String get blend_mode_exclusion => 'Wykluczenie';

  @override
  String get custom_color_filter => 'Niestandardowy filtr kolorów';

  @override
  String get color_filter_blend_mode => 'Tryb mieszania filtra kolorów';

  @override
  String get enable_all => 'Włącz wszystko';

  @override
  String get disable_all => 'Wyłącz wszystko';

  @override
  String get font => 'Czcionka';

  @override
  String get color => 'Kolor';

  @override
  String get font_size => 'Rozmiar czcionki';

  @override
  String get text => 'Tekst';

  @override
  String get border => 'Granica';

  @override
  String get background => 'Tło';

  @override
  String get no_subtite_warning_message =>
      'Nie ma żadnego efektu, ponieważ w tym filmie nie ma żadnych ścieżek napisów';

  @override
  String get grid_size => 'Rozmiar siatki';

  @override
  String n_per_row(Object n) {
    return '$n w wierszu';
  }

  @override
  String get horizontal_continious => 'Poziomy ciągły';

  @override
  String get edit_code => 'Edytuj kod';

  @override
  String get use_libass => 'Włącz libass';

  @override
  String get use_libass_info =>
      'Użyj renderowania napisów opartego na Libass dla natywnego backendu.';

  @override
  String get libass_not_disable_message =>
      'Wyłącz `use libass` w ustawieniach odtwarzacza, aby móc dostosować napisy.';

  @override
  String get override_ass_subtitles => 'Zastąp napisy ASS';

  @override
  String get override_ass_subtitles_info =>
      'Zastosuj niestandardową stylizację do napisów ASS/SSA';

  @override
  String get torrent_stream => 'Strumień torrenta';

  @override
  String get add_torrent => 'Dodaj torrent';

  @override
  String get enter_torrent_hint_text =>
      'Wprowadź adres URL pliku magnet lub torrent';

  @override
  String get torrent_url => 'Adres URL torrenta';

  @override
  String get or => 'LUB';

  @override
  String get advanced => 'Zaawansowane';

  @override
  String get advanced_info => 'mpv konfiguracja';

  @override
  String get use_native_http_client => 'Użyj natywnego klienta http';

  @override
  String get use_native_http_client_info =>
      'automatycznie obsługuje funkcje platformy, takie jak VPN, obsługuje więcej funkcji HTTP, takich jak HTTP/3 i niestandardową obsługę przekierowań';

  @override
  String n_hour_ago(Object hour) {
    return '$hour godzinę temu';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours godzin temu';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute minutę temu';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes minut temu';
  }

  @override
  String n_day_ago(Object day) {
    return '$day dzień temu';
  }

  @override
  String get now => 'teraz';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Ostatnia aktualizacja biblioteki: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Dane i przechowywanie';

  @override
  String get download_location_info => 'Używane do pobierania rozdziałów';

  @override
  String get storage => 'Przechowywanie';

  @override
  String get clear_chapter_and_episode_cache =>
      'Wyczyść pamięć podręczną rozdziałów i odcinków';

  @override
  String get cache_cleared => 'Pamięć podręczna została wyczyszczona';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Wyczyść pamięć podręczną rozdziałów/odcinków przy uruchomieniu aplikacji';

  @override
  String get app_settings => 'Ustawienia aplikacji';

  @override
  String get sources_settings => 'Ustawienia źródeł';

  @override
  String get include_sensitive_settings =>
      'Uwzględnij wrażliwe ustawienia (np. tokeny logowania modułu śledzącego)';

  @override
  String get create => 'Utwórz';

  @override
  String get downloads_are_limited_to_wifi =>
      'Pobieranie jest ograniczone wyłącznie do sieci Wi-Fi';

  @override
  String get recommendations => 'Zalecenia';

  @override
  String get recommendations_similar => 'podobne';

  @override
  String get recommendations_weights => 'Zalecenia Wagi';

  @override
  String get recommendations_weights_genre => 'Podobieństwo gatunkowe';

  @override
  String get recommendations_weights_setting => 'Ustawianie podobieństwa';

  @override
  String get recommendations_weights_synopsis => 'Podobieństwo historii';

  @override
  String get recommendations_weights_theme => 'Podobieństwo tematyczne';

  @override
  String get manga_extensions_repo => 'Repozytorium rozszerzeń Manga';

  @override
  String get anime_extensions_repo => 'Repozytorium rozszerzeń Anime';

  @override
  String get novel_extensions_repo => 'Repozytorium nowatorskich rozszerzeń';

  @override
  String get custom_dns =>
      'Niestandardowy DNS (pozostaw puste, aby użyć systemowego DNS)';

  @override
  String get android_proxy_server =>
      'Serwer proxy Android (serwer M-Extension)';

  @override
  String get get_m_extension_server => 'Uzyskaj serwer M-Extension';

  @override
  String get undefined => 'nieokreślony';

  @override
  String get empty_extensions_repo => 'Nie ma jeszcze repozytoriów rozszerzeń';

  @override
  String get add_extensions_repo => 'Dodaj repozytorium URL';

  @override
  String get remove_extensions_repo => 'Usuń repozytorium URL';

  @override
  String get manage_manga_repo_urls =>
      'Zarządzaj adresami URL repozytorium Manga';

  @override
  String get manage_anime_repo_urls =>
      'Zarządzaj adresami URL repozytorium Anime';

  @override
  String get manage_novel_repo_urls =>
      'Zarządzaj adresami URL repozytorium powieści';

  @override
  String get url_cannot_be_empty => 'URL nie może być pusty';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL musi kończyć się rozszerzeniem .json / .pb';

  @override
  String get repo_url => 'URL';

  @override
  String get invalid_url_format => 'Nieprawidłowy format URL';

  @override
  String get clear_all_sources => 'Wyczyść wszystkie źródła';

  @override
  String get clear_all_sources_msg =>
      'Spowoduje to całkowite usunięcie wszystkich źródeł aplikacji. Czy na pewno chcesz kontynuować?';

  @override
  String get sources_cleared => 'Źródła wyczyszczone!!!';

  @override
  String get repo_added => 'Dodano repozytorium źródłowe!';

  @override
  String get repo_already_exists => 'Repozytorium już istnieje!';

  @override
  String get add_repo => 'Dodać repozytorium?';

  @override
  String get add_repo_sources_to_add =>
      'Listy rozszerzeń, które zostaną dodane:';

  @override
  String get add_repo_warning =>
      'Rozszerzenia z tych repozytoriów działają wewnątrz aplikacji. Dodawaj tylko repozytoria, którym ufasz.';

  @override
  String get genre_search_library => 'Wyszukaj gatunek w bibliotece';

  @override
  String get genre_search_source => 'Przeglądaj źródło';

  @override
  String get source_not_added => 'Źródło nie jest zainstalowane!';

  @override
  String get load_own_subtitles => 'Załaduj własne napisy...';

  @override
  String get search_subtitles => 'Wyszukaj napisy w Internecie...';

  @override
  String extension_notes(Object notes) {
    return 'Uwagi: $notes';
  }

  @override
  String get unsupported_repo =>
      'Nie można dodać tego repozytorium źródłowego. Sprawdź adres repozytorium lub skontaktuj się z jego opiekunem.';

  @override
  String get you_have_finished_reading => 'Skończyłeś czytać';

  @override
  String get hwdec => 'Dekoder sprzętowy';

  @override
  String get enable_hardware_accel => 'Przyspieszenie sprzętowe';

  @override
  String get enable_hardware_accel_info =>
      'Włącz/wyłącz, jeśli występują błędy lub awarie';

  @override
  String get track_library_navigate =>
      'Przejdź do istniejącego wpisu lokalnego';

  @override
  String get track_library_add => 'Dodaj do lokalnej biblioteki';

  @override
  String get track_library_add_confirm =>
      'Dodaj śledzony element do lokalnej biblioteki';

  @override
  String get track_library_not_logged =>
      'Zaloguj się do odpowiedniego modułu śledzącego, aby skorzystać z tej funkcji!';

  @override
  String get track_library_switch => 'Przełącz na inny tracker';

  @override
  String get go_back => 'Wróć';

  @override
  String get merge_library_nav_mobile =>
      'Połącz nawigację po bibliotece na urządzeniu mobilnym';

  @override
  String get enable_discord_rpc => 'Włącz Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Ukryj Discord RPC w trybie incognito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Pokaż bieżący rozdział w Discord (wymaga ponownego uruchomienia)';

  @override
  String get rpc_show_title => 'Pokaż bieżący tytuł w Discord';

  @override
  String get rpc_show_cover_image => 'Pokaż bieżący obraz okładki w Discord';

  @override
  String get enable_mpv => 'Włącz shadery/skrypty mpv';

  @override
  String get mpv_info => 'Obsługuje skrypty .js w mpv/scripts/';

  @override
  String get mpv_redownload => 'Pobierz ponownie pliki konfiguracyjne mpv';

  @override
  String get mpv_redownload_info =>
      'Zastępuje stare pliki konfiguracyjne nowymi!';

  @override
  String get mpv_download => 'MPV!\nPobierz teraz?';

  @override
  String get custom_buttons => 'Przyciski niestandardowe';

  @override
  String get custom_buttons_info =>
      'Wykonaj kod Lua za pomocą niestandardowych przycisków';

  @override
  String get custom_buttons_edit => 'Edytuj przyciski niestandardowe';

  @override
  String get custom_buttons_add => 'Dodaj przycisk niestandardowy';

  @override
  String get custom_buttons_added => 'Dodano przycisk niestandardowy!';

  @override
  String get custom_buttons_delete => 'Usuń przycisk niestandardowy';

  @override
  String get custom_buttons_text => 'Tekst przycisku';

  @override
  String get custom_buttons_text_req => 'Wymagany tekst przycisku';

  @override
  String get custom_buttons_js_code => 'Kod lua';

  @override
  String get custom_buttons_js_code_req => 'Wymagany kod Lua';

  @override
  String get custom_buttons_js_code_long => 'Kod Lua (przy długim naciśnięciu)';

  @override
  String get custom_buttons_startup => 'Kod lua (przy uruchomieniu)';

  @override
  String get custom_buttons_add_warning =>
      'Ten przycisk uruchamia poniższy kod Lua w odtwarzaczu wideo, który może uzyskać dostęp do plików i uruchamiać programy. Dodaj go tylko wtedy, gdy masz pewność, skąd pochodzi ten link.';

  @override
  String n_days(Object n) {
    return '$n dni';
  }

  @override
  String get decoder => 'Dekoder';

  @override
  String get decoder_info =>
      'Dekodowanie sprzętowe, format pikseli, usuwanie pasm';

  @override
  String get enable_gpu_next => 'Włącz gpu-next (tylko Android)';

  @override
  String get enable_gpu_next_info => 'Nowy backend renderowania wideo';

  @override
  String get debanding => 'Usuwanie pasków';

  @override
  String get use_yuv420p => 'Użyj formatu pikseli YUV420P';

  @override
  String get use_yuv420p_info =>
      'Może naprawić czarne ekrany w niektórych kodekach wideo, może także poprawić wydajność kosztem jakości';

  @override
  String get audio_preferred_languages => 'Preferowane języki';

  @override
  String get audio_preferred_languages_info =>
      'Preferowane języki audio, gdy wideo ma wiele ścieżek audio. Użyj kodów dwu- lub trzyliterowych oddzielonych przecinkami (na przykład: ja, en).';

  @override
  String get enable_audio_pitch_correction =>
      'Włącz korekcję wysokości dźwięku';

  @override
  String get enable_audio_pitch_correction_info =>
      'Zapobiega temu, aby dźwięk stawał się wysoki przy większych prędkościach i niski przy niższych prędkościach';

  @override
  String get audio_channels => 'Kanały audio';

  @override
  String get volume_boost_cap => 'Ograniczenie zwiększania głośności';

  @override
  String get internal_player => 'Odtwarzacz wewnętrzny';

  @override
  String get internal_player_info => 'Postęp, kontrola, orientacja';

  @override
  String get subtitle_delay_text => 'Opóźnienie napisów';

  @override
  String get subtitle_delay => 'Opóźnienie (ms)';

  @override
  String get subtitle_speed => 'Prędkość';

  @override
  String get tracks => 'Utwory';

  @override
  String get playback_speed => 'Szybkość odtwarzania';

  @override
  String get shaders => 'Shadery';

  @override
  String get video_fit => 'Pasuje';

  @override
  String get calendar => 'Kalendarz';

  @override
  String get calendar_no_data => 'Brak jeszcze danych.';

  @override
  String get calendar_info =>
      'Kalendarz jest w stanie przewidzieć przesłanie następnego rozdziału jedynie na podstawie starszych przesłanych materiałów. Niektóre dane mogą nie być w 100% dokładne!';

  @override
  String in_n_day(Object days) {
    return 'w $days dniu';
  }

  @override
  String in_n_days(Object days) {
    return 'w $days dni';
  }

  @override
  String get clear_library => 'Wyczyść bibliotekę';

  @override
  String get clear_library_desc =>
      'Wybierz opcję usunięcia wszystkich wpisów dotyczących mangi, anime i/lub powieści';

  @override
  String get clear_library_input =>
      'Wpisz „manga”, „anime” i/lub „powieść” (oddzielone przecinkiem), aby usunąć wszystkie powiązane wpisy';

  @override
  String get watch_order => 'Kolejność oglądania';

  @override
  String get watch_order_role_current => 'Bieżąca';

  @override
  String get watch_order_role_previous => 'Poprzedni';

  @override
  String get watch_order_role_next => 'Następnie';

  @override
  String get watch_order_source_release_order => 'Polecenie zwolnienia';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name autorstwa $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Oficjalna kolekcja Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt kolekcja: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Pory roku dla $title';
  }

  @override
  String get watch_order_select_source => 'Źródło zamówienia';

  @override
  String watch_order_season(int number) {
    return 'Sezon $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Odcinek $number';
  }

  @override
  String get sequels => 'Sequele';

  @override
  String get recommendations_similarity => 'Podobieństwo:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Ocena $rating';
  }

  @override
  String get local_folder_structure => 'Struktura folderu lokalnego';

  @override
  String get local_folder => 'Foldery lokalne';

  @override
  String get add_local_folder => 'Dodaj folder lokalny';

  @override
  String get rescan_local_folder =>
      'Przeskanuj teraz ponownie wszystkie foldery lokalne';

  @override
  String get default_download_destination =>
      'Domyślne miejsce docelowe pobierania';

  @override
  String get ask_download_destination =>
      'Zapytaj o miejsce docelowe pobierania';

  @override
  String get ask_download_destination_desc =>
      'Wybierz folder lokalny przy każdym rozpoczęciu pobierania.';

  @override
  String get select_download_destination =>
      'Wybierz miejsce docelowe pobierania';

  @override
  String get clear_local_library => 'Wyczyść bibliotekę lokalną';

  @override
  String get clear_local_library_desc =>
      'Usuń foldery lokalne i wpisy archiwalne z biblioteki.';

  @override
  String get clear_local_library_msg =>
      'Spowoduje to usunięcie folderu lokalnego i wpisów archiwalnych z Twojej biblioteki. Nie usunie plików z dysku.';

  @override
  String get custom => 'Niestandardowe';

  @override
  String get no_local_folder_available_for_downloads =>
      'Żaden folder lokalny nie jest dostępny do pobrania';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Nie udało się utworzyć CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Błąd odczytu obrazu okładki: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Błąd odczytu metadanych: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Błąd podczas zapisywania rozdziału/odcinka w bibliotece: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Błąd podczas odczytywania obrazu okładki rozdziału: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Błąd odczytu obrazu okładki archiwum: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Błąd podczas pobierania biblioteki lokalnej: $error';
  }

  @override
  String get export_metadata => 'Eksportuj metadane';

  @override
  String get exported => 'Eksportowane';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Nie udało się wyeksportować metadanych: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count rozdział(y) nie mógł zostać automatycznie ponumerowany i mogą być nieodpowiednie lub niewidoczne w czytniku.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Nie można uruchomić serwera Webview Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker Token wygasł';
  }

  @override
  String get video_list_empty => 'Lista filmów wideo jest pusta';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Nie można uruchomić $url';
  }

  @override
  String get text_size => 'Rozmiar tekstu:';

  @override
  String get text_align => 'Wyrównanie tekstu';

  @override
  String get line_height => 'Wysokość linii';

  @override
  String get show_scroll_percentage => 'Pokaż procent przewijania';

  @override
  String get remove_extra_paragraph_spacing =>
      'Usuń dodatkowe odstępy między akapitami';

  @override
  String select_label_color(Object label) {
    return 'Wybierz $label Kolor';
  }

  @override
  String get default_user_agent => 'Domyślny agent użytkownika';

  @override
  String get forceLandscapeMode => 'Wymuś tryb poziomy';

  @override
  String get forceLandscapeModeSubtitle =>
      'Zmuś gracza do korzystania z orientacji poziomej.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Dostawca DNS';

  @override
  String get tracked => 'Śledzone';

  @override
  String get auth_unlock_msg => 'Uwierzytelnij, aby odblokować aplikację';

  @override
  String get app_locked => 'Aplikacja zablokowana';

  @override
  String get auth_to_continue => 'Uwierzytelnij, aby kontynuować';

  @override
  String get authenticating => 'Uwierzytelnianie...';

  @override
  String get lock => 'Blokada';

  @override
  String get unlock => 'Odblokuj';

  @override
  String get security => 'Bezpieczeństwo';

  @override
  String get auth_to_change_security_setting =>
      'Uwierzytelnij, aby zmienić ustawienia zabezpieczeń';

  @override
  String get app_lock => 'Blokada aplikacji';

  @override
  String get require_biometric_or_device_credential =>
      'Wymagaj danych biometrycznych lub danych uwierzytelniających urządzenia, aby otworzyć aplikację';

  @override
  String get biometric_or_device_credential_not_available =>
      'Uwierzytelnianie biometryczne lub uwierzytelnianie urządzenia nie jest dostępne na tym urządzeniu';

  @override
  String get app_lock_description =>
      'Gdy włączona jest blokada aplikacji, będziesz proszony o uwierzytelnienie za każdym razem, gdy otworzysz aplikację lub przełączysz się z powrotem do niej z tła.';

  @override
  String get checking_device_authentication =>
      'Sprawdzanie uwierzytelnienia urządzenia…';

  @override
  String get device_authentication_incomplete =>
      'Uwierzytelnianie nie zostało zakończone. Twoje ustawienie nie uległo zmianie.';

  @override
  String get keep_screen_on => 'Pozostaw ekran włączony';

  @override
  String get webtoon_side_padding => 'Wyściółka boczna Webtoon';

  @override
  String get show_page_gaps => 'Pokaż luki na stronach';

  @override
  String get invert_colors => 'Odwracanie kolorów';

  @override
  String get grayscale => 'Skala szarości';

  @override
  String get brightness => 'Jasność';

  @override
  String get contrast => 'Kontrast';

  @override
  String get saturation => 'Nasycenie';

  @override
  String get navigation_layout => 'Układ nawigacji';

  @override
  String get nav_layout_default => 'Domyślnie';

  @override
  String get nav_layout_l_shaped => 'W kształcie litery L';

  @override
  String get nav_layout_kindle => 'W stylu Kindle';

  @override
  String get nav_layout_edge => 'Krawędź';

  @override
  String get nav_layout_right_and_left => 'Prawo i lewo';

  @override
  String get nav_layout_disabled => 'Wyłączone';

  @override
  String get color_enhancements => 'Ulepszenia kolorów';

  @override
  String get total => 'Razem';

  @override
  String get mean_per_title => 'Średnia na tytuł';

  @override
  String get completion_rate => 'Stopień ukończenia';

  @override
  String get watching_time => 'Czas oglądania';

  @override
  String get reading_time => 'Czas odczytu';

  @override
  String average_chapters_per_title(Object title) {
    return 'Średnia liczba rozdziałów na $title';
  }

  @override
  String get read_percentage => 'Odczytaj wartość procentową';

  @override
  String get entries => 'Wpisy';

  @override
  String get android_proxy_server_mihon =>
      'Serwer proxy systemu Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Pobierz i skonfiguruj serwer proxy wymagany do korzystania z rozszerzeń Mihon.';

  @override
  String get mihon_proxy_server => 'Serwer proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Pobierz pakiet serwera proxy przed użyciem rozszerzeń Mihon. Pakiet zawiera środowisko JRE i serwer rozszerzeń JAR.';

  @override
  String get extension_server_intro_ios =>
      'Pobierz plik JAR serwera proxy przed użyciem rozszerzeń Mihon. iOS potrzebuje tylko pliku JAR serwera rozszerzeń.';

  @override
  String get checking_files => 'Sprawdzanie plików';

  @override
  String get files_installed => 'Zainstalowano pliki';

  @override
  String get files_missing => 'Brakuje plików';

  @override
  String get update_files => 'Aktualizuj pliki';

  @override
  String get up_to_date => 'Aktualne';

  @override
  String get choose_location => 'Wybierz lokalizację';

  @override
  String get import_existing_jar => 'Zaimportuj istniejący plik JAR';

  @override
  String get detect_files_in_selected_folder =>
      'Wykryj pliki w wybranym folderze';

  @override
  String get preparing_download => 'Przygotowywanie pobierania...';

  @override
  String get app_install_location => 'Lokalizacja instalacji aplikacji';

  @override
  String get install_location => 'Miejsce instalacji';

  @override
  String get jre_executable => 'Plik wykonywalny JRE';

  @override
  String get extension_server_jar => 'Serwer rozszerzeń JAR';

  @override
  String get installed_version => 'Wersja zainstalowana';

  @override
  String get latest_version => 'Najnowsza wersja';

  @override
  String get m_extension_server_description =>
      'Użyj M-Extension-Server, gdy potrzebujesz oddzielnego serwera proxy urządzenia z Androidem. Ustaw tutaj adres proxy i pobierz plik APK z GitHub.';

  @override
  String get set_proxy_address => 'Ustaw adres proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'Nie jest dostępna żadna nowsza wersja serwera proxy.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Nie można sprawdzić aktualizacji serwera proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Dla tej platformy nie jest dostępny żaden pakiet serwera rozszerzeń.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Nie udało się pobrać pakietu ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Pobrany pakiet nie zawiera oczekiwanych plików.';

  @override
  String get extension_server_files_ready =>
      'Pliki serwera rozszerzeń są gotowe.';

  @override
  String get ios_extension_server_import_hint =>
      'W systemie iOS serwer jest instalowany w piaskownicy aplikacji. Użyj opcji „Importuj istniejący plik JAR”, aby pobrać pobrany plik.';

  @override
  String get select_extension_server_folder =>
      'Wybierz folder serwera rozszerzeń';

  @override
  String get selected_folder_does_not_exist => 'Wybrany folder nie istnieje.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'W wybranym folderze nie znaleziono plików serwera rozszerzeń.';

  @override
  String get extension_server_files_linked =>
      'Pliki serwera rozszerzeń zostały połączone.';

  @override
  String get select_extension_server_jar => 'Wybierz JAR serwera rozszerzeń';

  @override
  String get selected_file_could_not_be_accessed =>
      'Nie można było uzyskać dostępu do wybranego pliku.';

  @override
  String get extension_server_jar_imported =>
      'Zaimportowano plik JAR serwera rozszerzeń.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Nie można uruchomić strony serwera M-Extension.';

  @override
  String get proxy_server_ip_hint =>
      'Adres IP serwera (np. 10.0.0.5 lub https://example.com)';

  @override
  String get not_configured => 'Nie skonfigurowano';

  @override
  String get zero_interpreter => 'Interpreter zera';

  @override
  String get zero_interpreter_description =>
      'Automatycznie lub ręcznie steruj serwerem interpretera zera.';

  @override
  String get start_server_on_launch => 'Uruchom serwer po uruchomieniu';

  @override
  String get runtime_status => 'Stan czasu wykonania';

  @override
  String get running => 'Bieganie';

  @override
  String get stopped => 'Zatrzymano';

  @override
  String get start => 'Rozpocznij';

  @override
  String get stop => 'Zatrzymaj się';

  @override
  String get webview => 'Widok internetowy';

  @override
  String get tts => 'Zamiana tekstu na mowę';

  @override
  String get tts_speed => 'Prędkość';

  @override
  String get tts_pitch => 'Smoła';

  @override
  String get tts_language => 'Język';

  @override
  String get tts_voice => 'Głos';

  @override
  String get tts_stop => 'Zatrzymaj się';

  @override
  String get tts_play => 'Odtwórz';

  @override
  String get tts_pause => 'Pauza';

  @override
  String get tts_previous => 'Poprzedni akapit';

  @override
  String get tts_next => 'Następny akapit';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Akapit $current z $total';
  }

  @override
  String get tts_settings => 'Ustawienia TTS';

  @override
  String get tts_default => 'Domyślnie';

  @override
  String get webtoon_disable_zoom_out => 'Webtoon wyłącza pomniejszanie';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Dwukrotne dotknięcie Webtoon przybliża';

  @override
  String get navigate_to_pan => 'Przejdź do przesuwania';

  @override
  String get navigate_to_pan_subtitle =>
      'Przesuń powiększony obraz przed przewróceniem strony';

  @override
  String get split_wide_pages => 'Podziel szerokie strony';

  @override
  String get dual_page_invert => 'Odwracanie przeciętych połówek stron';

  @override
  String get dual_page_rotate_to_fit => 'Obróć, aby dopasować';

  @override
  String get dual_page_rotate_to_fit_invert => 'Odwrócenie kierunku obrotu';

  @override
  String get double_page_single_first_page => 'Pojedyncza pierwsza strona';

  @override
  String get double_page_single_first_page_subtitle =>
      'Wyświetlaj samą pierwszą stronę w trybie podwójnej strony';

  @override
  String get double_page_auto => 'Automatyczna podwójna strona';

  @override
  String get double_page_auto_subtitle =>
      'Automatyczne przełączanie na tryb podwójnej strony w orientacji poziomej';

  @override
  String get landscape_zoom => 'Automatyczny zoom poziomy';

  @override
  String get zoom_start_position => 'Pozycja początkowa zoomu';

  @override
  String get zoom_start_left => 'Lewy';

  @override
  String get zoom_start_right => 'Jasne';

  @override
  String get zoom_start_center => 'Środek';

  @override
  String get automatic_background => 'Automatyczne tło';

  @override
  String get tapping_inversion => 'Inwersja stukania';

  @override
  String get tapping_inversion_none => 'Brak';

  @override
  String get tapping_inversion_horizontal => 'Poziomo';

  @override
  String get tapping_inversion_vertical => 'Pionowo';

  @override
  String get tapping_inversion_both => 'Obydwa';

  @override
  String get flash_on_page_change => 'Błysk przy zmianie strony';

  @override
  String get flash_on_page_change_subtitle =>
      'Pomocnik AMOLED zapobiegający zatrzymywaniu';

  @override
  String get flash_color => 'Kolor błyskowy';

  @override
  String get flash_color_black => 'Czarny';

  @override
  String get flash_color_white => 'Biały';

  @override
  String get flash_color_white_black => 'Biały i czarny';

  @override
  String get flash_interval_label => 'Przerwa między błyskami';

  @override
  String flash_interval_value(String n) {
    return '$n stron';
  }

  @override
  String flash_interval(String n) {
    return 'Interwał flashowania: $n stron';
  }

  @override
  String get flash_duration_label => 'Czas trwania błysku';

  @override
  String flash_duration_value(String n) {
    return '$n ms';
  }

  @override
  String flash_duration(String n) {
    return 'Czas trwania błysku: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Pokaż nakładkę nawigacyjną przy uruchomieniu';

  @override
  String get reader_hide_threshold => 'Próg ukrywania czytnika';

  @override
  String get reader_hide_threshold_highest => 'Najwyższy (5 pikseli)';

  @override
  String get reader_hide_threshold_high => 'Wysoka (13 pikseli)';

  @override
  String get reader_hide_threshold_low => 'Niska (31 pikseli)';

  @override
  String get reader_hide_threshold_lowest => 'Najniższy (47 pikseli)';

  @override
  String get error_no_pages_available => 'Błąd: brak dostępnych stron';

  @override
  String get app_ui_scale => 'Skala interfejsu';

  @override
  String get app_ui_scale_subtitle =>
      'Zwiększ lub zmniejsz interfejs, aby dopasować go do ekranu i odległości oglądania.';

  @override
  String get allow_concurrent_downloads => 'Zezwalaj na jednoczesne pobieranie';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Pobieraj jednocześnie z różnych źródeł. Jedno źródło nadal pobiera jeden rozdział na raz, więc nie jest przeciążone. Wyłącz, aby pobierać pojedynczo, wszędzie.';

  @override
  String get download_delay => 'Opóźnienie pobierania';

  @override
  String get download_delay_subtitle =>
      'Wyłączone. Dodaj czas oczekiwania z losowymi wahaniami między rozdziałami, aby zachować ostrożność w przypadku źródeł.';

  @override
  String get save_search => 'Zapisz wyszukiwanie';

  @override
  String get saved_searches => 'Zapisane wyszukiwania';

  @override
  String get enter_search_to_save_first =>
      'Wprowadź wyszukiwanie, które chcesz najpierw zapisać';

  @override
  String get no_saved_searches =>
      'Nie ma jeszcze zapisanych wyszukiwań dla tego źródła.\nUruchom wyszukiwanie, a następnie wybierz opcję „Zapisz wyszukiwanie”.';

  @override
  String get source => 'Źródło';

  @override
  String get something_went_wrong => 'Coś poszło nie tak';

  @override
  String get startup_failed =>
      'NodeLane Comics nie mógł dokończyć uruchamiania';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count źródła bez wyników',
      one: '1 źródło bez wyników',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Jak należy to importować?';

  @override
  String get import_mode_message =>
      'Wybierz, czy chcesz scalić tę kopię zapasową z bieżącą biblioteką, czy zastąpić nią całą bibliotekę.';

  @override
  String get import_mode_keep_existing => 'Połączyć';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Dodaje nowe serie i aktualizuje pasujące. Nic z bieżącej biblioteki nie zostanie usunięte.';

  @override
  String get import_mode_replace => 'Wymień';

  @override
  String get import_mode_replace_subtitle =>
      'Usuwa całą bieżącą bibliotekę i zastępuje ją tą kopią zapasową.';

  @override
  String get replace_summary_title => 'Gotowy do zastąpienia biblioteki';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Spowoduje to usunięcie całej bieżącej biblioteki (seria $currentCount) i zastąpienie jej serią $backupCount z tej kopii zapasowej. Można to cofnąć jedynie poprzez wycofanie się.';
  }

  @override
  String get replace_summary_confirm => 'Wymień';

  @override
  String replace_result_message(Object count) {
    return 'Zastąpiono bibliotekę serią $count z tej kopii zapasowej.';
  }

  @override
  String get category_conflict_title => 'Znaleziono istniejące kategorie';

  @override
  String get category_conflict_message =>
      'Kopia zapasowa zawiera kategorie, które już istnieją w Twojej bibliotece. Trzymaj nadchodzące serie w istniejącej kategorii lub usuń, aby zamiast tego pozostawić te serie bez kategorii.';

  @override
  String get category_conflict_keep =>
      'Zachowaj — połącz z istniejącą kategorią';

  @override
  String get category_conflict_delete => 'Usuń — pozostaw serię bez kategorii';

  @override
  String get source_conflict_title => 'Nie znaleziono źródeł';

  @override
  String get source_conflict_message =>
      'Te źródła kopii zapasowych nie odpowiadają zainstalowanemu rozszerzeniu. Zachowaj oryginalną nazwę (zaimportowaną bez działającego źródła) lub migruj do zainstalowanego rozszerzenia, aby móc zaktualizować te serie.';

  @override
  String get source_conflict_keep =>
      'Zachowaj oryginalną nazwę (brak źródła na żywo)';

  @override
  String get import_summary_title => 'Gotowy do importu';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries nowa seria, $updatedSeries istniejąca seria zostanie zaktualizowana i $newChapters zostaną dodane nowe rozdziały. Nic, co już znajduje się w Twojej bibliotece, nie zostanie usunięte.';
  }

  @override
  String get import_summary_confirm => 'Import';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Zaimportowano $newSeries nową serię, zaktualizowano $updatedSeries istniejącą, dodano $newChapters nowe rozdziały.';
  }

  @override
  String get roll_back => 'Cofnij się';

  @override
  String get roll_back_confirm_message =>
      'Spowoduje to przywrócenie biblioteki do migawki bezpieczeństwa wykonanej tuż przed tą zmianą, cofając wszystko, co właśnie zrobiło.';

  @override
  String get roll_back_done => 'Przywrócono migawkę sprzed zmiany.';

  @override
  String get restoring_backup => 'Przywracanie biblioteki…';

  @override
  String get roll_back_last_change => 'Cofnij ostatnią zmianę';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Migawka z $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count ostatnie zmiany, do których można wrócić';
  }

  @override
  String get delete_source_title => 'Usuń źródło i jego mangę';

  @override
  String get delete_source_subtitle =>
      'Wybierz źródło i usuń wszystkie mangi znajdujące się w Twojej bibliotece, wraz z ich rozdziałami, pobranymi plikami, historią i śledzeniem.';

  @override
  String get delete_source_pick_title => 'Wybierz źródło do usunięcia';

  @override
  String get delete_source_empty =>
      'W Twojej bibliotece nie znaleziono żadnych źródeł.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Usunąć $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Spowoduje to trwałe usunięcie $mangaCount mangi, $chapterCount rozdziałów, $historyCount wpisów historii i $updateCount wpisów aktualizacji. Linki śledzące są zachowywane. Nie da się tego cofnąć, chyba że przez wycofanie się.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Usuń także zainstalowane rozszerzenie';

  @override
  String get delete_source_keep_history => 'Czytaj dalej historię';

  @override
  String get delete_source_keep_downloads => 'Prowadź zapisy pobierania';

  @override
  String get delete_source_button => 'Usuń';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Usunięto mangę $mangaCount z $sourceName.';
  }

  @override
  String get merge_manga_title => 'Scal zduplikowane mangi';

  @override
  String get merge_manga_subtitle =>
      'Znajduje mangę o pasujących tytułach w tym samym źródle (np. po połączeniu zduplikowanych źródeł) i składa je w jedno, bez usuwania czegokolwiek, co chciałbyś zachować.';

  @override
  String get merge_manga_none_found =>
      'Nie znaleziono prawdopodobnych duplikatów mangi.';

  @override
  String get merge_manga_pick_title => 'Możliwe duplikaty mangi';

  @override
  String get merge_manga_choose_primary_title =>
      'W który z nich powinny się połączyć pozostałe?';

  @override
  String get merge_manga_choose_primary_message =>
      'Rozdziały, historia i śledzenie z innych wpisów zostaną dołączone do dowolnego, który wybierzesz – nic nie zostanie usunięte.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rozdziałów',
      one: '1 rozdział',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Połączyć';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Połączono duplikat mangi $count w $mangaName.';
  }

  @override
  String get merge_preview_title => 'Potwierdź połączenie';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters rozdziały znalezione w innych wpisach. $duplicateChapters są duplikatami i zostaną usunięte (zachowanie dowolnej kopii, w której znajduje się postęp w czytaniu); $keptChapters zostanie dodany. $duplicateTracks zduplikowane linki śledzące również zostaną usunięte.';
  }

  @override
  String get memory_overlay => 'Pokaż wykorzystanie pamięci';

  @override
  String get memory_overlay_subtitle =>
      'Odczyt na żywo zawartości aplikacji. Aby zmierzyć urządzenie zamiast zgadywać: obejrzyj je, przewijając bibliotekę lub czytając rozdział.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Raporty o błędach';

  @override
  String get error_reports_subtitle =>
      'Błędy wykryte przez aplikację i sposób ich zgłaszania';

  @override
  String get error_reports_empty =>
      'Nic nie poszło źle. Błędy wykryte przez aplikację są tutaj przechowywane, więc możesz je zgłosić.';

  @override
  String get error_reports_likely_cause => 'Prawdopodobna przyczyna';

  @override
  String get error_reports_report => 'Raport na GitHubie';

  @override
  String get error_reports_banner => 'NodeLane Comics napotkał błąd';

  @override
  String get error_reports_banner_action => 'Zobacz to';

  @override
  String get error_reports_copy => 'Kopia';

  @override
  String get error_reports_copied => 'Skopiowano do schowka';

  @override
  String get error_reports_clear => 'Przezroczysty';

  @override
  String get error_reports_extension_failure =>
      'To pochodzi z rozszerzenia, a nie z NodeLane Comics. Rozszerzenia są pisane i utrzymywane przez osobę uruchamiającą repozytorium, z którego zainstalowałeś to źródło, więc poprawka musi się tam znaleźć. Nazwa źródła i to, co otwierałeś, to przydatne szczegóły, które należy im podać.';

  @override
  String get error_reports_already_reported => 'Już zgłoszono';

  @override
  String get error_reports_expected_failure =>
      'Jest to zazwyczaj źródło lub sieć, a nie aplikacja: łącze, które wygasło, serwer nie działał lub połączenie zostało zerwane. Warto zgłaszać tylko wtedy, gdy dzieje się to nadal w źródle, które działa gdzie indziej.';

  @override
  String get share_unavailable_copied =>
      'Udostępnianie nie jest dostępne na tej platformie, więc zamiast tego zostało skopiowane do schowka.';

  @override
  String get onboarding_title => 'Witamy w NodeLane Comics';

  @override
  String get onboarding_libraries_body =>
      'Wybierz, co czytasz i oglądasz. Te, które pominiesz, pozostaną poza paskiem nawigacyjnym. Możesz to później zmienić w sekcji Wygląd.';

  @override
  String get onboarding_nav_title => 'Twoje biblioteki';

  @override
  String get onboarding_nav_body =>
      'Zachowaj zakładkę dla każdego z nich lub umieść je razem w jednej zakładce Biblioteki, do której możesz się przełączać.';

  @override
  String get onboarding_nav_split => 'Każda zakładka';

  @override
  String get onboarding_nav_merged => 'Jedna zakładka Biblioteka';

  @override
  String get onboarding_nav_inside =>
      'Kliknięcie Biblioteki powoduje zamianę paska na te';

  @override
  String get onboarding_next => 'Następnie';

  @override
  String get onboarding_restore => 'Przywróć kopię zapasową';

  @override
  String get onboarding_or_local => 'Lub użyj plików, które już posiadasz';

  @override
  String get onboarding_local_folder => 'Dodaj folder';

  @override
  String onboarding_local_existing(Object count) {
    return 'Foldery $count są już skonfigurowane';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime i powieści działają. Każdy tytuł trafia do odpowiedniej biblioteki na podstawie tego, co się w nim znajduje.';

  @override
  String get onboarding_local_scanning => 'Skanowanie folderu';

  @override
  String onboarding_local_found(Object count) {
    return 'Znaleziono $count tytułów';
  }

  @override
  String get onboarding_local_remove => 'Usuń ten folder';

  @override
  String get onboarding_local_in_downloads =>
      'Jest to folder pobierania aplikacji. Dodanie jej tworzy drugą, lokalną kopię biblioteki, którą aplikacja już zarządza.';

  @override
  String get onboarding_local_empty =>
      'Nic nie znaleziono. Wybierz folder, w którym znajdują się Twoje foldery z mangą, a nie jedna manga.';

  @override
  String get onboarding_repo_failed =>
      'Nie można odczytać tego repozytorium. Sprawdź adres i połączenie.';

  @override
  String get onboarding_repo_title => 'Dodaj źródło';

  @override
  String get onboarding_body =>
      'NodeLane Comics nie ma własnych źródeł. Dodaj repozytorium, a zawarte w nim rozszerzenia staną się dostępne do zainstalowania i przeglądania.';

  @override
  String get onboarding_add => 'Dodaj repozytorium';

  @override
  String get onboarding_skip => 'Na razie pomiń';

  @override
  String get onboarding_continue => 'Kontynuuj';

  @override
  String get onboarding_later =>
      'Możesz dodać je później w Ustawieniach, w obszarze Przeglądaj.';

  @override
  String get onboarding_replay => 'Pokaż ekran powitalny';

  @override
  String get onboarding_replay_subtitle =>
      'Otwiera ponownie ekran pierwszego uruchomienia, na którym rozpoczyna się nowa instalacja.';

  @override
  String get missing_source_check_title => 'Sprawdź brakujące źródła';

  @override
  String get missing_source_check_subtitle =>
      'Znajdź wpisy biblioteki, których rozszerzenie nie jest zainstalowane – przywrócenie kopii zapasowej może pozostawić wpisy wskazujące na źródło, którego nigdy nie instalowałeś na tym urządzeniu.';

  @override
  String get missing_source_check_none_found =>
      'Instalowane jest źródło każdego wpisu biblioteki.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Brak źródeł $count',
      one: 'Brakuje 1 źródła',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Nie zainstalowano żadnych źródeł $itemType.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Dodaj repozytorium w obszarze Przeglądaj, a następnie zainstaluj dla niego rozszerzenie.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Źródła $count',
      one: '1 źródło',
    );
    return 'Masz do tego $_temp0, ale przeszukiwane są tylko te przypięte.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Przypnij jedno lub wyłącz opcję „Uwzględnij tylko przypięte źródła” w ustawieniach przeglądania.';

  @override
  String get global_search_all_nsfw =>
      'Każde źródło, które posiadasz, jest oznaczone NSFW i jest ukryte.';

  @override
  String get global_search_all_nsfw_hint =>
      'Włącz źródła NSFW w ustawieniach przeglądania, aby je przeszukać.';

  @override
  String get missing_source_check_result_message =>
      'Te wpisy biblioteki wskazują źródło, które nie jest zainstalowane na tym urządzeniu. Kliknij jedno, aby przeprowadzić migrację do zainstalowanego źródła, zainstaluj pasujące rozszerzenie lub użyj opcji „Usuń źródło i jego mangę”, aby je usunąć.';

  @override
  String get related_titles => 'Powiązane';

  @override
  String get related_none => 'Nie znaleziono nic powiązanego z tym tytułem.';

  @override
  String get relation_adaptation => 'Adaptacja';

  @override
  String get relation_sequel => 'Ciąg dalszy';

  @override
  String get relation_prequel => 'Prequel';

  @override
  String get relation_parent => 'Historia rodziców';

  @override
  String get relation_side_story => 'Historia poboczna';

  @override
  String get relation_spin_off => 'Wydzielenie';

  @override
  String get relation_alternative => 'Wersja alternatywna';

  @override
  String get auto_library_update => 'Automatyczne aktualizacje biblioteki';

  @override
  String get auto_library_update_subtitle =>
      'Po uruchomieniu aplikacji sprawdź każdy wpis w swojej bibliotece pod kątem nowych rozdziałów.';

  @override
  String get auto_library_update_never => 'Nigdy';

  @override
  String get auto_library_update_12_hours => 'Co 12 godzin';

  @override
  String get auto_library_update_daily => 'Codziennie';

  @override
  String get auto_library_update_2_days => 'Co 2 dni';

  @override
  String get auto_library_update_weekly => 'Co tydzień';

  @override
  String get auto_library_update_wifi_only => 'Tylko w Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Pomiń zaplanowaną aktualizację podczas korzystania z mobilnej transmisji danych.';

  @override
  String get padding => 'Wyściółka';

  @override
  String get page_mode => 'Tryb strony';

  @override
  String get single_page => 'Pojedyncza strona';

  @override
  String get double_page => 'Podwójna strona';

  @override
  String get speed => 'Prędkość';

  @override
  String get theme_dark => 'Ciemny';

  @override
  String get theme_light => 'Światło';

  @override
  String get theme_black => 'Czarny';

  @override
  String get theme_sepia => 'Sepia';

  @override
  String get decrease => 'Zmniejszenie';

  @override
  String get increase => 'Wzrost';

  @override
  String get chapter_swipe_actions =>
      'Działania polegające na przesuwaniu rozdziału';

  @override
  String get chapter_swipe_start => 'Przesuń w prawo';

  @override
  String get chapter_swipe_end => 'Przesuń w lewo';

  @override
  String get chapter_swipe_toggle_bookmark => 'Przełącz zakładkę';

  @override
  String get chapter_swipe_toggle_read => 'Przełącz odczyt';

  @override
  String get chapter_swipe_download => 'Pobierz';

  @override
  String get chapter_swipe_disabled => 'Wyłączone';

  @override
  String get update_errors => 'Błędy aktualizacji';

  @override
  String get no_update_errors => 'Brak błędów aktualizacji';

  @override
  String get clear_all => 'Usuń wszystko';

  @override
  String get dismiss => 'Odrzucić';

  @override
  String get previous_episode => 'Poprzedni odcinek';

  @override
  String get clear_logs => 'Wyczyść dzienniki';

  @override
  String get bold => 'Pogrubienie';

  @override
  String get italic => 'Kursywa';

  @override
  String get color_yellow => 'Żółty';

  @override
  String get color_cyan => 'Cyjan';

  @override
  String get color_green => 'Zielony';

  @override
  String get color_orange => 'Pomarańczowy';

  @override
  String get continue_watching => 'Kontynuuj oglądanie';

  @override
  String get search_your_anime => 'Wyszukaj swoje anime';

  @override
  String get category => 'Kategoria';

  @override
  String get hidden_categories => 'Kategorie ukryte';

  @override
  String get new_category => 'Nowa kategoria';

  @override
  String get local => 'Lokalnie';

  @override
  String get tv_home_rows => 'Rzędy';

  @override
  String get genre_rows => 'Wiersze gatunków';

  @override
  String get share_backup_file =>
      'Udostępnij plik kopii zapasowej NodeLane Comics';

  @override
  String get close => 'Zamknij';

  @override
  String get migrate_source => 'Migruj źródło';

  @override
  String get cloudflare_bypass_proxy => 'Serwer proxy obejścia Cloudflare';

  @override
  String get custom_doh_url => 'Niestandardowy DoH URL';

  @override
  String get custom_doh_url_helper =>
      'Musi być punktem końcowym https DoH (JSON).';

  @override
  String get anime_only_tv_layout => 'Układ telewizora wyłącznie anime';

  @override
  String get anime_only_beta => 'Tylko anime (beta)';

  @override
  String get tv_home_beta => 'Dom telewizyjny (beta)';

  @override
  String get tv_player_beta => 'Odtwarzacz telewizyjny (beta)';

  @override
  String get network_settings => 'Sieć';

  @override
  String get reader_page_layout => 'Układ strony';

  @override
  String get reader_continuous_options => 'Odczyt ciągły';

  @override
  String get reader_default_mode_hint =>
      'Domyślny tryb czytania dotyczy tytułów, które nie mają ustawionego indywidualnego trybu podczas czytania.';

  @override
  String get extension_service => 'Usługa rozszerzenia';

  @override
  String get extension_service_description =>
      'Zarządzaj środowiskiem wykonawczym rozszerzenia i adresem proxy.';

  @override
  String get proxy_address => 'Adres proxy';

  @override
  String get checking_runtime_status => 'Sprawdzanie statusu…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + losowe opóźnienie';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rozdziałów',
      one: '1 rozdział',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Dodaj pliki do pobrania z listy rozdziałów tytułu.';

  @override
  String get download_queue_order_hint =>
      'Przeciągnij uchwyty, aby zmienić kolejność';

  @override
  String get download_queue_empty => 'W kolejce nie ma żadnych pobrań';

  @override
  String get download_queue_actions => 'Akcje pobierania';

  @override
  String get download_queue_cancel_chapter =>
      'Anuluj pobieranie tego rozdziału';

  @override
  String get download_queue_cancel_series =>
      'Anuluj wszystkie pobieranie tego tytułu';

  @override
  String get download_queue_start => 'Rozpocznij pobieranie';

  @override
  String get download_queue_retry => 'Ponów próbę pobrania';

  @override
  String get download_queue_active => 'Pobieranie';

  @override
  String get download_queue_waiting => 'Oczekiwanie na pobranie';

  @override
  String get download_queue_failed => 'Pobieranie nie powiodło się';

  @override
  String get cf_proxy_helper =>
      'Punkt końcowy FlareSolverr/Byparr. Pozostaw puste, aby wyłączyć.';

  @override
  String get mobile_navigation_description =>
      'Przeciągnij, aby zmienić kolejność. Manga, anime i powieści dzielą tę samą kartę Biblioteka. Pierwszy widoczny element otwiera się po uruchomieniu. Przeglądaj i nie tylko, pozostań widoczny; dodatkowe karty pojawią się w obszarze Więcej.';

  @override
  String get text_align_justify => 'Uzasadnij';

  @override
  String get novel_session_modes_hint =>
      'Ustaw tryb czytania oraz pojedyncze lub podwójne strony podczas czytania tytułu.';

  @override
  String get tts_languages_failed =>
      'Nie można załadować języków z silnika mowy.';

  @override
  String get tts_languages_empty =>
      'Silnik mowy nie zwrócił żadnych języków. Zapisany wybór zostanie zachowany.';

  @override
  String get tts_language_unavailable =>
      'Tego zapisanego języka nie ma na aktualnej liście urządzenia.';

  @override
  String get tts_apply_failed =>
      'Nie można zastosować tego ustawienia do silnika mowy. Możesz spróbować ponownie.';

  @override
  String get player_controls => 'Kontrole';

  @override
  String get audio_channel_auto => 'Automatyczny';

  @override
  String get audio_channel_auto_safe => 'Automatyczny (bezpieczny)';

  @override
  String get audio_channel_mono => 'Mono';

  @override
  String get audio_channel_stereo => 'Stereo';

  @override
  String get audio_channel_reverse_stereo => 'Odwrócony stereo';

  @override
  String get mpv_bundled_config_hint =>
      'Przywróć konfigurację, skrypty i moduły cieniujące dołączone do aplikacji. Pliki o tych samych nazwach zostaną nadpisane.';

  @override
  String get mpv_restore_bundled => 'Przywróć dołączoną konfigurację';

  @override
  String get mpv_restore_confirm =>
      'Przywrócić dołączoną konfigurację MPV? Istniejąca konfiguracja, skrypty i shadery o tych samych nazwach zostaną nadpisane. Inne pliki zostaną zachowane.';

  @override
  String get player_operation_incomplete =>
      'Operacja nie mogła zostać ukończona. Sprawdź dostęp do pliku i spróbuj ponownie.';

  @override
  String get custom_buttons_empty_hint =>
      'Dodaj przycisk odtwarzacza z etykietą i czynnością naciśnięcia.';

  @override
  String get custom_button_primary => 'Przycisk domyślny';

  @override
  String get show_password => 'Pokaż hasło';

  @override
  String get hide_password => 'Ukryj hasło';

  @override
  String get tracking_accounts_empty =>
      'Połącz usługę w Ustawieniach śledzenia, aby zarządzać jej wpisami.';

  @override
  String get tracking_entries_empty =>
      'Brak śledzonych wpisów dla tego typu multimediów. Dodaj śledzenie ze strony szczegółów tytułu.';

  @override
  String get change_tracking_match => 'Zmień pasujący tytuł';

  @override
  String get remove_tracking => 'Usuń śledzenie';

  @override
  String remove_tracking_confirm(String title) {
    return 'Usunąć link śledzący dla „$title”? Wpis w usłudze śledzenia zostanie zachowany.';
  }

  @override
  String get tracking_refresh_required =>
      'Nie można było potwierdzić stanu śledzenia. Odśwież przed wprowadzeniem kolejnej zmiany.';

  @override
  String get tracking_entry_unlinked =>
      'Ten rekord nie jest powiązany z tytułem lokalnym, więc nie można go tutaj edytować.';

  @override
  String get backup_selection_shared =>
      'Zmiany tych wyborów są zapisywane natychmiast i dotyczą także automatycznych kopii zapasowych.';

  @override
  String get library_snapshot_history => 'Przywróć migawkę biblioteki';

  @override
  String get library_snapshot_empty =>
      'Brak dostępnych migawek bezpieczeństwa.';

  @override
  String get library_snapshot_restore_message =>
      'Bieżące dane zostaną zastąpione tą migawką. Zmiany wprowadzone od tego czasu zostaną utracone. Usuniętych pobranych plików nie można przywrócić. Dostępne migawki bezpieczeństwa zostaną usunięte po pomyślnym wykonaniu.';

  @override
  String get library_maintenance_working => 'Aktualizacja biblioteki…';

  @override
  String get library_safety_snapshot_note =>
      'Przed tą operacją zapisana zostanie migawka bezpieczeństwa. Nie obejmuje pobranych plików.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Wpisy biblioteki: $mangaCount. Rozdziały: $chapterCount. Wpisy w historii: $historyCount. Aktualizacje: $updateCount.\n\nWybierz poniżej, co chcesz zachować.';
  }

  @override
  String get library_delete_pick_message =>
      'Wybierz źródło, aby sprawdzić jego zawartość i opcje usuwania.';

  @override
  String get mobile_categories_hint =>
      'Przeciągnij, aby zmienić kolejność. Otwórz kategorię, aby zmienić jej nazwę lub zmienić jej widoczność i aktualizacje.';

  @override
  String get mobile_category_visible => 'Pokaż w bibliotece';

  @override
  String get mobile_category_hidden => 'Ukryte w bibliotece';

  @override
  String get mobile_category_updates => 'Uwzględnij aktualizacje biblioteki';

  @override
  String get statistics_watched => 'Obejrzałem';

  @override
  String get calendar_month => 'Miesiąc';

  @override
  String get calendar_two_weeks => '2 tygodnie';

  @override
  String get calendar_week => 'Tydzień';

  @override
  String get calendar_show_all_dates => 'Pokaż wszystkie daty';

  @override
  String get update_check_no_result =>
      'Nie znaleziono aktualizacji nadającej się do zainstalowania. Możesz spróbować ponownie później.';

  @override
  String get release_notes => 'Informacje o wydaniu';

  @override
  String get no_release_notes => 'Nie przedstawiono żadnych uwag do wydania.';

  @override
  String get downloading_update => 'Pobieranie aktualizacji…';

  @override
  String get preparing_installation => 'Przygotowanie instalacji…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Wybierz, co chcesz przeczytać. Możesz to zmienić później.';

  @override
  String get onboarding_content_title => 'Rozpocznij czytanie';

  @override
  String get onboarding_mobile_sources_body =>
      'Wybierz sposób rozpoczęcia lub dodaj treść później.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Krok $step z $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'Wyniki dla „$query”';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Źródła $count',
      one: '1 źródło',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Wyszukaj tytuł docelowy.';

  @override
  String get migration_original_item => 'Bieżący element';

  @override
  String get migration_target_item => 'Wybrany element';

  @override
  String get migration_partial_failure =>
      'Operacja nie została zakończona. Niektóre zmiany mogły zostać zapisane. Zanim spróbujesz ponownie, sprawdź ten element w swojej bibliotece.';

  @override
  String get migration_no_categories =>
      'Brak kategorii. Możesz dodać ten przedmiot bez kategorii.';

  @override
  String get mass_migration_select_source => 'Wybierz bieżące źródło';

  @override
  String get mass_migration_select_all => 'Wybierz wszystko';

  @override
  String get mass_migration_deselect_all => 'Odznacz wszystko';

  @override
  String get mass_migration_needs_review => 'Przegląd niekompletnych migracji';

  @override
  String get bookshelf_actions => 'Działania na półce z książkami';

  @override
  String get bookshelf_ignore_filters => 'Ignoruj filtry podczas wyszukiwania';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Przeszukaj wszystkie prace w tej kategorii, łącznie z tymi ukrytymi za pomocą filtrów.';

  @override
  String get bookshelf_stop_update => 'Zatrzymaj aktualizację biblioteki';

  @override
  String bookshelf_selected_count(int count) {
    return 'Wybrano prace $count';
  }

  @override
  String get bookshelf_remove_library => 'Wyjmij z półki na książki';

  @override
  String get bookshelf_remove_library_hint =>
      'Usuwa ulubione. Lokalny import traci także swoje zapisy biblioteczne i czytelnicze.';

  @override
  String get bookshelf_remove_downloads => 'Usuń pobrane pliki';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Usuwa pobrane pliki, zachowując informacje służbowe.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Usuwa również wybrane pliki importowane lokalnie i usuwa ich zapisy biblioteczne. Tych plików nie można tutaj odzyskać.';

  @override
  String get bookshelf_remove_incomplete =>
      'Operacja nie została zakończona. Niektóre prace lub pliki mogły zostać przetworzone. Zamknij to okno dialogowe i zanim przejdziesz dalej, sprawdź swoją półkę z książkami i pobrane pliki.';

  @override
  String get bookshelf_processing => 'Przetwarzanie…';

  @override
  String get bookshelf_mark_read => 'Zaznacz jako przeczytane';

  @override
  String get bookshelf_mark_unread => 'Oznacz jako nieprzeczytane';

  @override
  String get bookshelf_select_all => 'Wybierz wszystko';

  @override
  String get bookshelf_invert_selection => 'Odwróć wybór';

  @override
  String get bookshelf_settings => 'Ustawienia półki na książki';

  @override
  String get bookshelf_settings_live =>
      'Zmiany w filtrowaniu, sortowaniu i wyświetlaniu zaczynają obowiązywać natychmiast.';

  @override
  String get bookshelf_filter_any => 'Dowolny';

  @override
  String get bookshelf_filter_include => 'Włącz';

  @override
  String get bookshelf_filter_exclude => 'Wykluczyć';

  @override
  String get bookshelf_all_sources => 'Wszystkie źródła';

  @override
  String bookshelf_sources_selected(int count) {
    return 'Wybrano źródła $count';
  }

  @override
  String get bookshelf_sort_ascending => 'Rosnąco';

  @override
  String get bookshelf_sort_descending => 'Malejąco';

  @override
  String get bookshelf_layout => 'Układ półki na książki';

  @override
  String get bookshelf_sources_hint =>
      'Wybierz brak, aby wyświetlić wszystkie źródła. Zmiany zostaną zastosowane po dotknięciu opcji Filtruj.';

  @override
  String get bookshelf_choose_files => 'Wybierz pliki';

  @override
  String get bookshelf_import_wait =>
      'Wybierz plik w selektorze i poczekaj na zakończenie importu.';

  @override
  String get bookshelf_import_incomplete =>
      'Import nie został zakończony. Niektóre pliki mogą już znajdować się na Twojej półce. Zamknij to okno dialogowe i sprawdź przed ponownym importowaniem.';

  @override
  String get bookshelf_categories_replace =>
      'Zapisanie przypisuje te kategorie do każdej wybranej pracy, zastępując ich poprzednie kategorie.';

  @override
  String get bookshelf_categories_hint =>
      'Wybierz jedną lub więcej kategorii lub pozostaw wybór pusty, aby nie przypisać żadnej.';

  @override
  String get bookshelf_categories_hidden =>
      'W przypadku tej pracy zachowane zostaną istniejące ukryte kategorie.';

  @override
  String get bookshelf_categories_incomplete =>
      'Nie można było całkowicie zapisać kategorii. Zamknij to okno dialogowe i sprawdź półkę z książkami, zanim spróbujesz ponownie.';

  @override
  String get bookshelf_categories_none_visible =>
      'Tutaj nie są dostępne żadne kategorie. Otwórz zarządzanie kategoriami, aby je przejrzeć.';

  @override
  String get bookshelf_manage_categories => 'Zarządzaj kategoriami';

  @override
  String get manga_actions => 'Działania komiczne';

  @override
  String get manga_download_scope => 'Pobierz rozdziały';

  @override
  String get manga_download_scope_hint =>
      'Wybierz rozdziały w ramach bieżących filtrów. Pobrane rozdziały są pomijane.';

  @override
  String get manga_download_scope_empty =>
      'Żaden rozdział nie pasuje do bieżących filtrów. Zamknij to menu i dostosuj filtry rozdziałów.';

  @override
  String get manga_action_incomplete =>
      'Akcja nie została zakończona. Sprawdź bieżący stan przed ponowną próbą.';

  @override
  String get chapter_settings => 'Ustawienia rozdziałów';

  @override
  String get chapter_settings_live =>
      'Zmiany dotyczące filtrowania i sortowania obowiązują natychmiast.';

  @override
  String get chapter_scanlators_all => 'Pokaż wszystkie grupy skanerów';

  @override
  String get chapter_scanlators_hint =>
      'Wybierz grupy, aby ukryć ich rozdziały. Zmiany zostaną zastosowane po dotknięciu opcji Filtruj.';

  @override
  String chapter_scanlators_hidden(int count) {
    return 'Grupy skanerów $count ukryte';
  }

  @override
  String chapter_selected_count(int count) {
    return 'Wybrano $count rozdziałów';
  }

  @override
  String get chapter_add_bookmark => 'Zakładka';

  @override
  String get chapter_remove_bookmark => 'Usuń zakładkę';

  @override
  String get chapter_read_following => 'Przeczytaj poniżej';

  @override
  String get chapter_delete_records => 'Usuń zapisy rozdziałów';

  @override
  String get chapter_delete_local_hint =>
      'Usuwa wybrane zapisy rozdziałów i postęp czytania. Zachowane są oryginalne archiwa lokalne; pobrane kopie są czyszczone.';

  @override
  String get chapter_delete_last_hint =>
      'To są wszystkie rozdziały tego komiksu. Usunięcie ich powoduje również usunięcie komiksu z półki z książkami.';

  @override
  String get chapter_action_incomplete =>
      'Akcja nie została zakończona. Niektóre zmiany mogą być już zapisane. Zanim przejdziesz dalej, zamknij i sprawdź rozdziały oraz pliki do pobrania.';

  @override
  String get reader_display_scope =>
      'Tryb czytania i układ strony podręcznika mają zastosowanie do tego komiksu. Wybierz zmianę, aby wrócić do czytania.';

  @override
  String get reader_display_single_only =>
      'Poziomy ciągły odczyt wykorzystuje pojedyncze strony.';

  @override
  String get reader_display_manual_pages =>
      'Zmiana układu strony wyłącza automatyczne tworzenie podwójnych stron dla wszystkich komiksów.';

  @override
  String get reader_display_crop_scope => 'Dotyczy wszystkich komiksów.';

  @override
  String get reader_chapter_locate => 'Znajdź bieżący rozdział';

  @override
  String get reader_chapter_search => 'Przeszukuj rozdziały lub skanery';

  @override
  String get reader_chapter_scope =>
      'Wykorzystuje filtry rozdziałów i porządek sortowania na podstawie szczegółów komiksu. Zakładki są zapisywane natychmiast.';

  @override
  String get reader_chapter_current_hidden =>
      'Rozdział, który czytasz, nie jest objęty bieżącymi filtrami.';

  @override
  String get reader_chapter_current => 'Czytam teraz';

  @override
  String get reader_chapter_read => 'Przeczytaj';

  @override
  String get reader_chapter_bookmark_failed =>
      'Nie można było potwierdzić zapisu zakładek. Zamknij listę i sprawdź jej aktualny stan.';

  @override
  String get reader_image_actions => 'Działania obrazu';

  @override
  String get reader_image_original =>
      'Wykorzystuje całą stronę oryginalną, bez tłumaczenia, przycinania i filtrów kolorów czytnika.';

  @override
  String get reader_image_save_ios =>
      'Zapisz w folderze Obrazy w bieżącej lokalizacji przechowywania aplikacji.';

  @override
  String get reader_image_save_android =>
      'Zapisz w folderze Pictures/nodelane-comics na urządzeniu.';

  @override
  String get reader_image_share => 'Otwórz arkusz udostępniania systemu.';

  @override
  String get reader_image_cover =>
      'Po potwierdzeniu zmień okładkę tego komiksu.';

  @override
  String get reader_image_cover_limit =>
      'Obrazy na okładce muszą być mniejsze niż 5 MB. Zapisywanie i udostępnianie pozostają dostępne.';

  @override
  String get reader_image_action_failed =>
      'Nie można było potwierdzić działania. Zamknij to menu i sprawdź wynik przed ponowną próbą.';

  @override
  String get reader_settings_book_scope =>
      'Te ustawienia dotyczą tylko tego komiksu.';

  @override
  String get reader_settings_global_scope =>
      'Te ustawienia dotyczą wszystkich komiksów i są natychmiast zapisywane.';

  @override
  String get reader_filters => 'Filtry obrazu';

  @override
  String get reader_filter_scope =>
      'Dotyczy wszystkich komiksów. Zmienia sposób wyświetlania odczytu bez modyfikowania oryginalnych obrazów.';

  @override
  String get reader_auto_scroll_pause =>
      'Przewijanie zostaje wstrzymane, gdy ustawienia są otwarte.';

  @override
  String get manga_synopsis => 'Streszczenie';

  @override
  String manga_author(String author) {
    return 'Autor: $author';
  }

  @override
  String get manga_continue_reading => 'Kontynuuj czytanie';

  @override
  String get reader_settings_title => 'Ustawienia czytnika';

  @override
  String get reader_picker_book_scope => 'Tylko dla tego komiksu';

  @override
  String get reader_picker_global_scope => 'Dotyczy wszystkich komiksów';

  @override
  String get reader_picker_apply_hint =>
      'Naciśnij, aby zapisać i powrócić do poprzedniego poziomu.';

  @override
  String get reader_scale_fit_screen_hint => 'Dopasuj całą stronę do ekranu';

  @override
  String get reader_scale_stretch_hint => 'Wypełnij obszar czytania';

  @override
  String get reader_scale_fit_width_hint => 'Dopasuj stronę do szerokości';

  @override
  String get reader_scale_fit_height_hint => 'Dopasuj stronę do wysokości';

  @override
  String get source_filter_active => 'Zastosowano';

  @override
  String get source_filter_apply => 'Zastosuj filtry';

  @override
  String get source_filter_scope =>
      'Filtry dotyczą tylko tej witryny internetowej.';

  @override
  String get source_filter_apply_hint =>
      'Zastosuj filtry, aby wykorzystać swoje wybory.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Gatunki',
      'author': 'Autor',
      'artist': 'Artysta',
      'title': 'Tytuł',
      'year': 'Rok',
      'tags': 'Znaczniki',
      'format': 'Format',
      'publisher': 'Wydawca',
      'relevance': 'Znaczenie',
      'rating': 'Ocena',
      'views': 'Widoki',
      'random': 'Losowo',
      'all': 'Wszystko',
      'none': 'Brak',
      'action': 'Działanie',
      'adventure': 'Przygoda',
      'comedy': 'Komedia',
      'drama': 'Dramat',
      'fantasy': 'Fantazja',
      'romance': 'Romans',
      'science_fiction': 'Science fiction',
      'slice_of_life': 'Kawałek życia',
      'mystery': 'Tajemnica',
      'horror': 'Przerażenie',
      'psychological': 'Psychologiczne',
      'historical': 'Historyczne',
      'sports': 'Sport',
      'supernatural': 'Nadprzyrodzone',
      'school_life': 'Życie szkolne',
      'tragedy': 'Tragedia',
      'shounen': 'Shounen',
      'shoujo': 'Shoujo',
      'seinen': 'Seinen',
      'josei': 'Josei',
      'isekai': 'Isekai',
      'martial_arts': 'Sztuki walki',
      'mecha': 'Mecha',
      'music': 'Muzyka',
      'doujinshi': 'Doujinshi',
      'trending': 'Trendy',
      'new': 'Nowy',
      'adult_content': 'Treści dla dorosłych',
      'only': 'Tylko',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'Więcej opcji wyświetlania';

  @override
  String get bookshelf_more_display_hint => 'Odznaki, źródła i kategorie';

  @override
  String get bookshelf_download_count => 'Liczba pobrań';

  @override
  String get bookshelf_source_global_hint =>
      'Widoczność źródła wykorzystuje preferencje wspólnego wyświetlania.';

  @override
  String get bookshelf_select_entries => 'Wybierz działa';

  @override
  String get bookshelf_search_options => 'Opcje wyszukiwania';

  @override
  String get bookshelf_empty_hint =>
      'Zbieraj prace ze źródeł lub importuj pliki lokalne.';

  @override
  String get bookshelf_no_match_hint =>
      'Wypróbuj inne słowa kluczowe lub dostosuj bieżące filtry.';

  @override
  String get bookshelf_clear_query => 'Wyczyść słowa kluczowe';

  @override
  String get bookshelf_view_selection => 'Zobacz wybrane prace';

  @override
  String get bookshelf_import_formats =>
      'Wybierz plik lokalny, aby dodać go do swojej półki z książkami.';

  @override
  String get bookshelf_import_canceled_hint =>
      'Możesz wybrać ponownie po anulowaniu selektora plików.';

  @override
  String get bookshelf_browse_sources => 'Przeglądaj źródła';

  @override
  String get bookshelf_empty_title => 'Twoja półka na książki jest pusta';

  @override
  String get bookshelf_no_match_title => 'Brak wyników dopasowania';

  @override
  String get bookshelf_mark_watched => 'Mark patrzył';

  @override
  String get bookshelf_mark_unwatched => 'Zaznacz jako nieobserwowane';

  @override
  String get nodelane_account => 'NodeLane';

  @override
  String get nodelane_sign_in => 'Zaloguj się do NodeLane';

  @override
  String get nodelane_account_intro =>
      'Wyświetl swoje konto, subskrypcję i limit tłumaczeń';

  @override
  String get nodelane_login_action => 'Kontynuuj logowanie';

  @override
  String get nodelane_login_browser =>
      'Zaloguj się poprzez przeglądarkę systemową, a następnie wróć do aplikacji';

  @override
  String get nodelane_account_id => 'Identyfikator konta';

  @override
  String get nodelane_account_init_error =>
      'Pamięć konta jest niedostępna. Uruchom ponownie aplikację i spróbuj ponownie.';

  @override
  String get nodelane_account_refresh_error =>
      'Nie można odświeżyć informacji o koncie';

  @override
  String get nodelane_account_auth_error =>
      'Twoja sesja wygasła. Zaloguj się ponownie';

  @override
  String get nodelane_account_unknown =>
      'Informacje o subskrypcji są niedostępne';

  @override
  String get nodelane_account_current => 'Bieżąca subskrypcja';

  @override
  String get nodelane_account_free => 'Konto bezpłatne';

  @override
  String get nodelane_account_no_subscription => 'Brak aktywnej subskrypcji';

  @override
  String get nodelane_account_active => 'Aktywny';

  @override
  String get nodelane_account_expired => 'Wygasło';

  @override
  String get nodelane_account_expiry => 'Ważne do';

  @override
  String get nodelane_account_renewal => 'Odnowienie';

  @override
  String get nodelane_renewal_auto => 'Automatyczne odnawianie';

  @override
  String get nodelane_renewal_manual => 'Odnawianie ręczne';

  @override
  String get nodelane_renewal_stopped => 'Automatyczne odnawianie zatrzymane';

  @override
  String get nodelane_renewal_gift => 'Członkostwo w prezencie';

  @override
  String get nodelane_renewal_attention =>
      'Sprawdź status odnowienia na stronie internetowej';

  @override
  String get nodelane_next_billing => 'Data następnego rozliczenia';

  @override
  String get nodelane_billing_unavailable =>
      'Informacje o odnowieniu są niedostępne';

  @override
  String get nodelane_manage_account => 'Zarządzaj na stronie internetowej';

  @override
  String get nodelane_view_plans => 'Wyświetl plany subskrypcji';

  @override
  String get nodelane_translation_quota => 'Limit tłumaczeń';

  @override
  String get nodelane_quota_free => 'Bezpłatna kwota';

  @override
  String get nodelane_quota_subscription => 'Limit subskrypcji';

  @override
  String get nodelane_quota_purchase => 'Zakupiona kwota';

  @override
  String get nodelane_quota_details => 'Wyświetl szczegóły kontyngentu';

  @override
  String get nodelane_quota_expanded => 'Szczegóły kwot';

  @override
  String get nodelane_quota_unlimited => 'Nieograniczona';

  @override
  String get nodelane_quota_not_subscribed => 'Nie subskrybowano';

  @override
  String get nodelane_quota_unknown => 'Niedostępne';

  @override
  String get nodelane_quota_used => 'Używany';

  @override
  String get nodelane_quota_reserved => 'W toku';

  @override
  String get nodelane_quota_reset => 'Następny reset';

  @override
  String get nodelane_quota_expiry => 'Następne wygaśnięcie';

  @override
  String get nodelane_quota_no_expiry => 'Brak daty ważności';

  @override
  String get nodelane_quota_reservation_note =>
      'Strony w toku są już odejmowane od dostępnego limitu';

  @override
  String nodelane_quota_available(int count) {
    return 'Pozostało $count stron';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count stron';
  }

  @override
  String get nodelane_sign_out => 'Wyloguj się';

  @override
  String get nodelane_sign_out_confirm =>
      'Wylogowanie wstrzymuje oficjalne tłumaczenie na tym urządzeniu. Twoja biblioteka i postęp czytania zostaną zachowane.';

  @override
  String get settings_search_hint => 'Ustawienia wyszukiwania';

  @override
  String get settings_frequent => 'Często stosowane';

  @override
  String get settings_reading_translation => 'Czytanie i tłumaczenie';

  @override
  String get settings_app_preferences => 'Preferencje aplikacji';

  @override
  String get settings_data_management => 'Dane i zarządzanie';

  @override
  String get settings_more_tools => 'Więcej narzędzi';

  @override
  String get settings_more_tools_hint => 'Kategorie, statystyki i kalendarz';

  @override
  String get settings_appearance_interface => 'Wygląd i interfejs';

  @override
  String get settings_security_privacy => 'Bezpieczeństwo i prywatność';

  @override
  String get settings_source_preferences => 'Ustawienia źródła';

  @override
  String get settings_about_help => 'Informacje i pomoc';

  @override
  String get settings_storage_backup =>
      'Przechowywanie i tworzenie kopii zapasowych';

  @override
  String settings_pending_downloads(int count) {
    return '$count w toku';
  }

  @override
  String get settings_translation_language => 'Język tłumaczenia';

  @override
  String get settings_translation_scope =>
      'Używany w czytniku i tłumaczeniu stron internetowych';

  @override
  String get settings_immediate_choice => 'Zmiany obowiązują natychmiast';

  @override
  String get settings_translation_init_error =>
      'Ustawienia tłumaczenia są niedostępne. Uruchom ponownie aplikację i spróbuj ponownie.';

  @override
  String get settings_local_cache => 'Lokalna pamięć podręczna';

  @override
  String get settings_chapter_cache => 'Pamięć podręczna rozdziałów i odcinków';

  @override
  String get settings_cover_cache => 'Okładka pamięci podręcznej';

  @override
  String get settings_translation_cache =>
      'Pamięć podręczna przetłumaczonych obrazów';

  @override
  String get settings_translation_cache_hint =>
      'Przechowuj zapisy tłumaczeń i w razie potrzeby ponownie pobieraj przetłumaczone obrazy';

  @override
  String get settings_cache_clear => 'Przezroczysty';

  @override
  String get settings_translation_cache_done =>
      'Wyczyszczono pamięć podręczną przetłumaczonego obrazu; prowadzone zapisy tłumaczeń';

  @override
  String settings_cache_confirmation(String name) {
    return 'Wyczyść $name? Zawartość buforowaną można odzyskać ponownie. Wpisy do biblioteki zostaną zachowane.';
  }

  @override
  String get settings_advanced_options => 'Opcje zaawansowane';

  @override
  String get settings_manga_reader => 'Czytnik mangi';

  @override
  String get settings_novel_reader => 'Czytelnik powieści';

  @override
  String get settings_downloads => 'Pobierz ustawienia';

  @override
  String get onboarding_welcome => 'Witamy w';

  @override
  String get onboarding_reading_content => 'Czytanie treści';

  @override
  String get onboarding_choose_one => 'Wybierz co najmniej jeden';

  @override
  String get onboarding_restore_hint => 'Przywróć bibliotekę z kopii zapasowej';

  @override
  String get onboarding_browse_hint =>
      'Znajdź tytuły na obsługiwanych stronach internetowych';

  @override
  String get onboarding_import_folder => 'Zaimportuj folder lokalny';

  @override
  String get onboarding_import_folder_hint =>
      'Czytaj mangę, powieści i anime na swoim urządzeniu';

  @override
  String get onboarding_third_party => 'Dodaj repozytorium strony trzeciej';

  @override
  String get onboarding_third_party_hint =>
      'Użyj adresu repozytorium, który już posiadasz';

  @override
  String get onboarding_repository_hint =>
      'Wprowadź adres dostarczony przez repozytorium.';

  @override
  String get onboarding_repository_address => 'Adres';

  @override
  String get onboarding_repository_address_hint =>
      'Wprowadź adres repozytorium';

  @override
  String get onboarding_add_repository => 'Dodaj repozytorium';

  @override
  String get onboarding_start => 'Zacznij';

  @override
  String get onboarding_open_library => 'Otwórz bibliotekę';

  @override
  String get onboarding_view_imports => 'Wyświetl zaimportowaną treść';

  @override
  String get onboarding_view_folders => 'Przeglądaj foldery';

  @override
  String get notice_backup_created => 'Utworzono kopię zapasową';

  @override
  String get notice_backup_ready =>
      'Zapisz lub udostępnij plik kopii zapasowej.';

  @override
  String get notice_backup_restored => 'Przywrócono kopię zapasową';

  @override
  String get notice_backup_unsupported =>
      'Ten format kopii zapasowej nie jest obsługiwany.';

  @override
  String get notice_verification_required =>
      'Wymagana weryfikacja strony internetowej';

  @override
  String get notice_verification_hint =>
      'Zakończ weryfikację, aby kontynuować przeglądanie.';

  @override
  String get notice_verify => 'Zweryfikuj witrynę internetową';

  @override
  String get notice_action_incomplete =>
      'Akcja nie została zakończona. Sprawdź wynik przed ponowną próbą.';

  @override
  String get notice_library_updating => 'Aktualizacja biblioteki';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'Sprawdzono tytuły $current / $total';
  }

  @override
  String get notice_library_failed =>
      'Niektórych tytułów nie można było zaktualizować';

  @override
  String get notice_import_completed => 'Import zakończony';

  @override
  String get notice_operation_incomplete => 'Działanie niekompletne';

  @override
  String get subtitle_service => 'Usługa napisów online';

  @override
  String get subtitle_service_mode => 'Źródło napisów';

  @override
  String get subtitle_service_disabled =>
      'Wył. · Wyczyść zapisane poświadczenia';

  @override
  String get subtitle_personal_key => 'Mój klucz Wyzie';

  @override
  String get subtitle_custom_service => 'Moja usługa napisów';

  @override
  String get subtitle_key => 'Wyzie API Klucz';

  @override
  String get subtitle_key_hint =>
      'Wprowadź własny klucz Wyzie. Pozostaje na tym urządzeniu i nie jest uwzględniany w kopiach zapasowych aplikacji.';

  @override
  String get subtitle_get_key => 'Zdobądź klucz osobisty';

  @override
  String get subtitle_service_address => 'Wyszukiwanie napisów URL';

  @override
  String get subtitle_service_token => 'Token dostępu do usługi (opcjonalnie)';

  @override
  String get subtitle_custom_hint =>
      'Użyj pełnego wyszukiwania HTTPS URL usługi Wyzie-compatible, łącznie z jej ścieżką (na przykład /search). Wprowadź token dostępu tylko wtedy, gdy Twoja usługa go wymaga.';

  @override
  String get subtitle_service_off_hint =>
      'Wyszukiwanie napisów online jest wyłączone. Napisy osadzone, udostępnione przez źródło i lokalne pozostają dostępne.';

  @override
  String get subtitle_setup_required =>
      'Przed wyszukiwaniem wybierz usługę napisów.';

  @override
  String get subtitle_invalid_key => 'Wprowadź klucz bez spacji.';

  @override
  String get subtitle_invalid_address =>
      'Użyj pełnego HTTPS URL bez zapytania, fragmentu lub osadzonych poświadczeń.';

  @override
  String get subtitle_invalid_token =>
      'Token dostępu nie może zawierać spacji.';

  @override
  String get subtitle_storage_failed =>
      'Nie można odczytać lub zapisać ustawień napisów. Spróbuj ponownie.';

  @override
  String get subtitle_auth_failed =>
      'Usługa napisów odmówiła dostępu. Sprawdź swój klucz lub token usługi.';

  @override
  String get subtitle_quota_exhausted =>
      'Limit usługi napisów został wyczerpany. Sprawdź swoje konto w tej usłudze.';

  @override
  String get subtitle_network_failed =>
      'Nie można było połączyć się z usługą napisów. Spróbuj ponownie.';

  @override
  String get subtitle_response_invalid =>
      'Usługa napisów zwróciła nieobsługiwaną odpowiedź lub plik.';

  @override
  String get detail_loading_chapters => 'Ładowanie rozdziałów…';

  @override
  String get reader_opening_chapter => 'Rozdział otwierający';

  @override
  String get reader_open_chapter => 'Otwórz rozdział';

  @override
  String get reader_loading_pages => 'Pobieranie obrazów rozdziałów…';

  @override
  String get reader_loading_pages_hint =>
      'Odczyt rozpocznie się automatycznie, gdy będzie gotowy.';

  @override
  String get reader_loading_failed => 'Nie można załadować tego rozdziału';

  @override
  String get reader_loading_retry_hint =>
      'Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get reader_no_pages => 'Nie znaleziono obrazów dla tego rozdziału';

  @override
  String get reader_loading_previous => 'Ładowanie poprzedniego rozdziału…';

  @override
  String get reader_previous_failed =>
      'Nie można załadować poprzedniego rozdziału';

  @override
  String get reader_reached_start => 'Dotarłeś do pierwszego rozdziału';

  @override
  String get reader_loading_next => 'Ładowanie następnego rozdziału…';

  @override
  String get reader_next_failed => 'Nie można załadować następnego rozdziału';

  @override
  String get reader_image_loading => 'Ładowanie obrazu…';

  @override
  String get reader_image_failure_hint => 'Możesz dalej czytać inne strony.';

  @override
  String get comic_paged => 'Strona po stronie';

  @override
  String get comic_scroll => 'Przewiń w dół';

  @override
  String get comic_book_scope =>
      'Dotyczy tylko tej książki · zmiany są zapisywane natychmiast';

  @override
  String get comic_defaults_title => 'Domyślne wartości i nawyki';

  @override
  String get comic_defaults_hint =>
      'Wartości domyślne dotyczą pól, których nie dostosowałeś dla książki.';

  @override
  String get comic_habits_hint => 'Te nawyki dotyczą każdego komiksu.';

  @override
  String get comic_turn => 'Przesuń do następnej strony';

  @override
  String get comic_left => 'Lewy';

  @override
  String get comic_right => 'Jasne';

  @override
  String get comic_up => 'W górę';

  @override
  String get comic_fit => 'Dopasowanie strony';

  @override
  String get comic_fit_contain => 'Cała strona';

  @override
  String get comic_fit_width => 'Szerokość dopasowania';

  @override
  String get comic_fit_height => 'Wysokość dopasowania';

  @override
  String get comic_layout => 'Układ strony';

  @override
  String get comic_auto => 'Automat';

  @override
  String get comic_layout_hint =>
      'Automatycznie pokazuje rozkład, gdy szerokość jest wystarczająca.';

  @override
  String get comic_width => 'Szerokość treści';

  @override
  String get comic_full => 'Pełne';

  @override
  String get comic_comfortable => 'Wygodny';

  @override
  String get comic_narrow => 'Wąskie';

  @override
  String get comic_gap => 'Odstępy między stronami';

  @override
  String get comic_no_gap => 'Bez szwu';

  @override
  String get comic_small_gap => 'Mały';

  @override
  String get comic_image_title => 'Dostosuj obraz';

  @override
  String get comic_image_hint =>
      'Kadrowanie i tonacja dotyczą tylko tej książki.';

  @override
  String get comic_wide => 'Szerokie strony';

  @override
  String get comic_intact => 'Przechowywać w całości';

  @override
  String get comic_split => 'Rozdzielenie';

  @override
  String get comic_rotate => 'Obróć';

  @override
  String get comic_wide_hint =>
      'Dzielenie następuje zgodnie z kierunkiem przewracania strony. Dotyczy czytania pojedynczych stron.';

  @override
  String get comic_cover => 'Jedna okładka na rozdział';

  @override
  String get comic_effects_reset => 'Zresetuj ustawienia obrazu';

  @override
  String get comic_book_reset => 'Przywróć domyślne ustawienia książki';

  @override
  String get comic_book_reset_hint =>
      'Czyści niestandardowe ustawienia czytania tej książki. Tłumaczenie bez zmian.';

  @override
  String get comic_canvas => 'Tło czytnika';

  @override
  String get comic_system => 'System';

  @override
  String get comic_black => 'Czarny';

  @override
  String get comic_gray => 'Szary';

  @override
  String get comic_paper => 'Papier';

  @override
  String get comic_tap => 'Stuknij, aby przewracać strony';

  @override
  String get comic_tap_hint =>
      'Stuknij krawędzie, aby je przesunąć; dotknij środka, aby wyświetlić elementy sterujące.';

  @override
  String get comic_scroll_start => 'Rozpocznij automatyczne przewijanie';

  @override
  String get comic_scroll_pause => 'Wstrzymaj automatyczne przewijanie';

  @override
  String get comic_scroll_speed => 'Szybkość przewijania';

  @override
  String get comic_scroll_hint =>
      'Uruchamia się po zamknięciu tego panelu. Zatrzymuje się, gdy aplikacja opuszcza pierwszy plan.';

  @override
  String get comic_save_failed => 'Nie można zapisać. Spróbuj ponownie.';

  @override
  String get comic_reading => 'Czytanie';

  @override
  String get comic_chapter_habits_hint =>
      'Zwyczaje związane z listami rozdziałów dotyczą wszystkich książek.';

  @override
  String get browser_title => 'Przeglądarka';

  @override
  String get translation_image_display => 'Wyświetlanie obrazu';

  @override
  String get translation_display_hint =>
      'Najpierw pokaż istniejące tłumaczenia. Zachowaj oryginał, jeśli nie jest dostępne tłumaczenie.';

  @override
  String get translation_sign_in_required =>
      'Zaloguj się, aby włączyć tłumaczenie';

  @override
  String get translation_sign_in_hint =>
      'Po zalogowaniu przełącz się na przetłumaczone obrazy, aby tłumaczenie było automatyczne.';

  @override
  String get translation_automatic => 'Tłumaczenie automatyczne';

  @override
  String get translation_original_hint =>
      'Pokazywanie oryginałów. Przełącz na przetłumaczone obrazy, aby tłumaczyć automatycznie.';

  @override
  String get translation_window_hint =>
      'Przetwarzaj bieżące i przyszłe obrazy tylko podczas wyświetlania tłumaczeń.';

  @override
  String get translation_channel => 'Kanał translacji';

  @override
  String get translation_no_images =>
      'Na tej stronie nie znaleziono jeszcze żadnych obrazów do przetłumaczenia';

  @override
  String get translation_waiting_image => 'Oczekiwanie na bieżący obraz';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues obrazu wymaga uwagi',
      many: ' · $issues obrazów wymaga uwagi',
      few: ' · $issues obrazy wymagają uwagi',
      one: ' · $issues obraz wymaga uwagi',
      zero: '',
    );
    return 'Przetworzone obrazy: $complete / $total$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'Dotknij i przytrzymaj obraz, aby wykonać więcej czynności, w tym ponownie go przetłumaczyć.';

  @override
  String get translation_title => 'Tłumaczenie mangi';

  @override
  String get translation_system_sign_in =>
      'Zaloguj się za pomocą przeglądarki systemowej';

  @override
  String get translation_target_language => 'Język docelowy';

  @override
  String get translation_clear_cache =>
      'Wyczyść pamięć podręczną przetłumaczonego obrazu';

  @override
  String get translation_cache_hint =>
      'Przechowuj zapisy tłumaczeń i w razie potrzeby ponownie pobieraj wyniki.';

  @override
  String get translation_saved_read_failed =>
      'Nie można załadować zapisanego tłumaczenia';

  @override
  String get translation_read_failed =>
      'Nie można załadować przetłumaczonego obrazu';

  @override
  String get operation_retry =>
      'Akcja nie została zakończona. Spróbuj ponownie.';

  @override
  String get translation_original => 'Oryginał';

  @override
  String get translation_translated => 'Przetłumaczone';

  @override
  String get translation_regenerate_image => 'Przetłumacz ten obraz ponownie';

  @override
  String get translation_read_image => 'Załaduj ponownie przetłumaczony obraz';

  @override
  String get translation_image_actions => 'Więcej działań wizerunkowych';

  @override
  String get translation_processing => 'Przetwarzanie';

  @override
  String get translation_reading => 'Ładowanie przetłumaczonego obrazu';

  @override
  String get translation_waiting => 'Oczekiwanie na tłumaczenie';

  @override
  String get translation_preparing => 'Przygotowanie tłumaczenia';

  @override
  String get translation_uploading => 'Przesyłanie oryginału';

  @override
  String get translation_running => 'Tłumaczenie';

  @override
  String get translation_uncertain => 'Status wymaga weryfikacji';

  @override
  String get translation_failed => 'Tłumaczenie nie powiodło się';

  @override
  String get translation_verify => 'Sprawdź';

  @override
  String get translation_reread => 'Załaduj ponownie';

  @override
  String get browser_back => 'Tył';

  @override
  String get browser_translation => 'Tłumaczenie stron internetowych';

  @override
  String get browser_new_tab_action => 'Otwórz nową kartę';

  @override
  String get browser_current_tab => 'Prąd';

  @override
  String get browser_close_tab => 'Zamknij kartę';

  @override
  String get browser_new_tab => 'Nowa zakładka';

  @override
  String get browser_page => 'Strona internetowa';

  @override
  String get browser_unopened => 'Żadna strona nie została jeszcze otwarta';

  @override
  String get browser_invalid_address => 'Wprowadź prawidłowy URL';

  @override
  String get browser_clear_address => 'Przezroczysty URL';

  @override
  String get browser_paste_address => 'Wklej URL';

  @override
  String get browser_open_address => 'Otwarte URL';

  @override
  String browser_tab_count(int count) {
    return 'Zakładki · $count';
  }

  @override
  String get browser_load_failed => 'Nie można otworzyć tej strony';

  @override
  String get browser_load_failed_hint => 'Sprawdź swoje połączenie i URL.';

  @override
  String get browser_edit_address => 'Edytuj URL';

  @override
  String get browser_clear_cookies_confirm =>
      'Wyczyścić sesje logowania dla wszystkich stron internetowych?';

  @override
  String get browser_clear_cookies_hint =>
      'Strony internetowe na wszystkich kartach mogą wymagać ponownego zalogowania się.';

  @override
  String get browser_clear_cookies_action => 'Wyczyść sesje logowania';

  @override
  String get browser_tab_limit =>
      'Możesz mieć otwartych maksymalnie 12 kart. Najpierw zamknij jeden.';

  @override
  String get browser_forward => 'Do przodu';

  @override
  String get browser_clear_all_cookies =>
      'Wyczyść wszystkie sesje logowania do witryny internetowej';

  @override
  String get browser_clear_failed =>
      'Nie można wyczyścić sesji. Spróbuj ponownie.';

  @override
  String get browser_save_failed =>
      'Nie można zapisać zakładek. Spróbuj ponownie.';

  @override
  String get browser_tabs_full => '12 zakładek jest już otwartych';

  @override
  String get browser_no_tabs => 'Nie ma jeszcze otwartych zakładek';

  @override
  String get browser_close_failed =>
      'Nie można zapisać zakładek. Kliknij ponownie, aby spróbować ponownie.';

  @override
  String get source_pinned_websites => 'Przypięte strony internetowe';

  @override
  String get manage => 'Zarządzaj';

  @override
  String get translation_settings_hint =>
      'Tłumaczenie automatyczne, język docelowy i kanał';

  @override
  String get translation_show_original => 'Stuknij, aby pokazać oryginał';

  @override
  String get translation_show_translated => 'Naciśnij, aby pokazać tłumaczenie';

  @override
  String get source_display => 'Wyświetlacz';

  @override
  String get source_cover_title => 'Okładka i tytuł';

  @override
  String get source_cover_only => 'Tylko okładka';

  @override
  String get source_save_search => 'Zapisz bieżące wyszukiwanie';

  @override
  String get source_saved_searches => 'Zapisane wyszukiwania';

  @override
  String get source_website_info => 'Informacje o witrynie internetowej';

  @override
  String source_saved_search_title(String title) {
    return '$title · Naciśnij, aby wyszukać';
  }

  @override
  String get action_done => 'Gotowe';

  @override
  String source_search_keyword(String query) {
    return 'Słowo kluczowe: $query';
  }

  @override
  String get source_no_saved_searches =>
      'Nie zapisano jeszcze żadnych wyszukiwań';

  @override
  String get source_save_search_hint =>
      'Wyszukaj słowo kluczowe, a następnie zapisz je z działań witryny.';

  @override
  String get source_saved_search_scope =>
      'Słowa kluczowe są zapisywane tylko dla tej witryny.';

  @override
  String get source_search_here =>
      'Wyszukaj tytuły na tej stronie internetowej';

  @override
  String get source_filter_results => 'Wyniki filtrowane';

  @override
  String get source_search_results => 'Wyniki wyszukiwania';

  @override
  String get source_return_popular => 'Powrót do popularnego';

  @override
  String get source_popular_titles => 'Popularne tytuły';

  @override
  String get source_no_titles => 'Nie znaleziono pasujących tytułów';

  @override
  String get source_no_titles_hint =>
      'Zmień słowa kluczowe lub filtry albo wróć do popularnych tytułów.';

  @override
  String get source_load_more_failed =>
      'Nie można załadować więcej. Spróbuj ponownie.';

  @override
  String get source_load_pull_retry =>
      'Nie można załadować tej witryny internetowej. Pociągnij w dół, aby spróbować ponownie.';

  @override
  String get source_clear_failed =>
      'Nie można dokończyć czyszczenia. Spróbuj ponownie.';

  @override
  String get source_uninstall_failed =>
      'Nie można dokończyć odinstalowywania. Spróbuj ponownie.';

  @override
  String get source_details => 'Szczegóły źródła';

  @override
  String get source_repository_website => 'Witryna internetowa repozytorium';

  @override
  String get source_provided_settings => 'Ustawienia dostarczone przez źródło';

  @override
  String get source_advanced_actions => 'Zaawansowane działania';

  @override
  String get source_edit_metadata => 'Edytuj informacje o źródle';

  @override
  String get source_clear_cookies => 'Wyczyść pliki cookie dla tej witryny';

  @override
  String get source_clear_cookies_hint =>
      'Podczas następnej wizyty może być konieczne ponowne zalogowanie się.';

  @override
  String get source_uninstall => 'Odinstaluj źródło';

  @override
  String get source_settings_save_failed =>
      'Zapisywanie nie zostało zakończone. Otwórz ponownie ustawienia źródła, aby je sprawdzić.';

  @override
  String get repository_third_party => 'Repozytoria stron trzecich';

  @override
  String get repository_refresh_failed =>
      'Nie można odświeżyć katalogu. Zawartość pamięci podręcznej zostaje zachowana. Spróbuj ponownie.';

  @override
  String get repository_show_sources => 'Pokaż źródła z tego repozytorium';

  @override
  String get repository_copy_catalog => 'Skopiuj łącze do katalogu';

  @override
  String get repository_remove => 'Usuń repozytorium';

  @override
  String get repository_remove_hint =>
      'Zachowaj zainstalowane źródła i usuń odinstalowane wpisy katalogu.';

  @override
  String get repository_empty =>
      'Nie dodano jeszcze żadnych repozytoriów stron trzecich';

  @override
  String get repository_built_in => 'Wbudowany oficjalny katalog';

  @override
  String get repository_hidden => 'Ukryte';

  @override
  String get repository_refreshing => 'Odświeżający…';

  @override
  String get repository_refresh => 'Odśwież katalog';

  @override
  String get repository_manage_hint =>
      'Zarządzaj, skąd pobierane są źródła zewnętrzne.';

  @override
  String get repository_invalid_address =>
      'Wprowadź poprawny HTTP lub HTTPS URL';

  @override
  String get repository_already_added => 'To repozytorium zostało już dodane';

  @override
  String get repository_unrecognized =>
      'Nie znaleziono obsługiwanego katalogu. Sprawdź link i spróbuj ponownie.';

  @override
  String get repository_read_failed =>
      'Nie można było odczytać katalogu. Spróbuj ponownie.';

  @override
  String get repository_save_failed =>
      'Zapisywanie nie zostało zakończone. Sprawdź listę repozytoriów.';

  @override
  String get repository_paste_hint =>
      'Wklej łącze do katalogu repozytorium strony trzeciej';

  @override
  String get repository_address => 'URL';

  @override
  String get repository_paste_link => 'Wklej link';

  @override
  String repository_recognized(String type) {
    return '$type · Katalog rozpoznany';
  }

  @override
  String get repository_choose_sources_hint =>
      'Po dodaniu repozytorium wybierz potrzebne źródła.';

  @override
  String get search_scope => 'Zakres wyszukiwania';

  @override
  String get search_scope_hint => 'Wybierz strony internetowe do przeszukania';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Przeszukaj $count witryny',
      many: 'Przeszukaj $count witryn',
      few: 'Przeszukaj $count witryny',
      one: 'Przeszukaj $count witrynę',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Znajdź stronę internetową';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wybrano $count witryny',
      many: 'Wybrano $count witryn',
      few: 'Wybrano $count witryny',
      one: 'Wybrano $count witrynę',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Przezroczysty';

  @override
  String get search_deselect_results => 'Odznacz pasujące strony internetowe';

  @override
  String get search_select_results => 'Wybierz pasujące strony internetowe';

  @override
  String get search_no_websites_hint =>
      'Brak pasujących witryn internetowych. Wypróbuj inną nazwę lub język.';

  @override
  String get search_select_website_hint =>
      'Wybierz co najmniej jedną witrynę internetową do przeszukania.';

  @override
  String get search_start_title =>
      'Wprowadź słowa kluczowe, aby znaleźć tytuły';

  @override
  String get search_start_hint =>
      'Przeszukuj wiele witryn jednocześnie i wyświetlaj pasujące tytuły.';

  @override
  String get search_empty_scope =>
      'Brak witryn internetowych z możliwością przeszukiwania w tym zakresie';

  @override
  String get search_empty_scope_hint =>
      'Przełącz do wszystkich witryn internetowych lub wybierz witryny do przeszukania.';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wyniku',
      many: '$count wyników',
      few: '$count wyniki',
      one: '$count wynik',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'Wyszukaj tytuły';

  @override
  String get search_actions => 'Działania wyszukiwania';

  @override
  String get search_details => 'Szczegóły wyszukiwania';

  @override
  String get search_title_hint => 'Szukaj według tytułu';

  @override
  String get search_searching => 'Wyszukiwanie';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znaleziono $count wyniku',
      many: 'Znaleziono $count wyników',
      few: 'Znaleziono $count wyniki',
      one: 'Znaleziono $count wynik',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'Brak pasujących wyników';

  @override
  String get search_failed => 'Wyszukiwanie nie powiodło się';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znaleziono $count tytułów',
      one: 'Znaleziono 1 tytuł',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: 'Strony internetowe $websites',
      one: '1 witryna internetowa',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Znajdowanie tytułów';

  @override
  String get search_complete => 'Wyszukiwanie zakończone';

  @override
  String get search_in_progress => 'Wyszukiwanie';

  @override
  String get search_finding_related => 'Szukam pasujących tytułów…';

  @override
  String get search_no_results_yet => 'Brak jeszcze wyników wyszukiwania';

  @override
  String get search_no_matching_titles => 'Nie znaleziono pasujących tytułów';

  @override
  String get search_results_appear_hint =>
      'Wyniki pojawią się tutaj w momencie ich znalezienia.';

  @override
  String get search_failed_websites_hint =>
      'Niektóre strony internetowe nie mogły zakończyć wyszukiwania. Spróbuj ponownie w szczegółach wyszukiwania.';

  @override
  String get search_change_keywords_hint =>
      'Wypróbuj krótsze słowa kluczowe lub wyszukaj więcej witryn internetowych.';

  @override
  String get search_view_details => 'Wyświetl szczegóły wyszukiwania';

  @override
  String get search_adjust_scope => 'Dostosuj zakres wyszukiwania';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Strony internetowe $count',
      one: '1 witryna internetowa',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Zakończono $completed / $total';
  }

  @override
  String get search_retry_website_hint =>
      'Ponów pojedynczą próbę w witrynach internetowych, które zakończyły się niepowodzeniem';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wybrano $count elementu',
      many: 'Wybrano $count elementów',
      few: 'Wybrano $count elementy',
      one: 'Wybrano $count element',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Szukaj języków';

  @override
  String get source_deselect => 'Odznacz';

  @override
  String get source_select => 'Wybierz źródło';

  @override
  String get source_multilingual => 'Wielojęzyczny';

  @override
  String get source_language_unknown => 'Nie określono języka';

  @override
  String get source_adult_content => 'Zawiera zawartość 18+';

  @override
  String get source_classification_unknown => 'Nie określono klasyfikacji';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wyświetl wszystkie informacje o źródle, $count więcej kategorii',
      one: 'Wyświetl wszystkie informacje o źródle, 1 dodatkowa kategoria',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Ładowanie strony internetowej';

  @override
  String get source_unpin => 'Odpiąć';

  @override
  String get source_pin => 'Kołek';

  @override
  String get source_open => 'Otwarte';

  @override
  String get source_metadata_hint =>
      'Informacje pochodzą z katalogu źródłowego. Kategorie opisują treści zawarte na stronie.';

  @override
  String get source_region => 'Region';

  @override
  String get source_format => 'Format';

  @override
  String get source_creation => 'Tworzenie';

  @override
  String get source_unspecified => 'Nie określono';

  @override
  String get source_pricing => 'Ceny';

  @override
  String get source_region_jp => 'Komiksy japońskie';

  @override
  String get source_region_kr => 'Komiksy koreańskie';

  @override
  String get source_region_cn => 'Komiksy chińskie';

  @override
  String get source_region_hk_tw => 'Komiksy z Hongkongu i Tajwanu';

  @override
  String get source_region_western => 'Komiksy zachodnie';

  @override
  String get source_region_other => 'Inne regiony';

  @override
  String get source_format_page => 'Komiksy stronicowane';

  @override
  String get source_format_vertical => 'Komiksy pionowe';

  @override
  String get source_format_strip => 'Paski komiksowe';

  @override
  String get source_creation_original => 'Oryginał';

  @override
  String get source_creation_fan => 'Wentylator działa';

  @override
  String get source_free_watch => 'Oglądanie za darmo';

  @override
  String get source_free_read => 'Do bezpłatnego czytania';

  @override
  String get source_partial_paid => 'Częściowo płatne';

  @override
  String get source_paid_watch => 'Oglądanie płatne';

  @override
  String get source_paid_read => 'Czytanie płatne';

  @override
  String get source_pricing_unknown => 'Nie określono ceny';

  @override
  String get source_language_filter => 'Filtruj według języka';

  @override
  String get source_language_filter_hint =>
      'Filtruj tylko ten katalog. Zainstalowane źródła pozostają nienaruszone.';

  @override
  String get source_all_languages => 'Wszystkie języki';

  @override
  String get action_apply => 'Zastosuj';

  @override
  String get source_load_retry =>
      'Nie można załadować tej witryny. Spróbuj ponownie.';

  @override
  String get source_catalog_refresh_failed =>
      'Nie można odświeżyć katalogu. Aktualna treść zostaje zachowana. Pociągnij w dół, aby spróbować ponownie.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odinstalować źródła $count?',
      one: 'Odinstalować 1 źródło?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Odinstaluj wybrane źródła i wyczyść ich ustawienia. Zachowaj tytuły z biblioteki i pliki do pobrania.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Działania nie powiodły się dla źródeł $count.',
      one: 'Działanie nie powiodło się dla 1 źródła.',
    );
    return '$_temp0 Wybór zachowany. Spróbuj ponownie.';
  }

  @override
  String get source_latest_content => 'Najnowsza treść';

  @override
  String get source_actions => 'Działania źródłowe';

  @override
  String get source_bulk_manage => 'Zarządzanie wieloma źródłami';

  @override
  String get source_update_installed => 'Aktualizacja zainstalowanych źródeł';

  @override
  String get source_no_matching_websites =>
      'Brak pasujących witryn internetowych';

  @override
  String get source_no_websites => 'Brak dostępnych stron internetowych';

  @override
  String get source_search_installed_hint =>
      'Wyszukiwanie tytułów w zainstalowanych źródłach';

  @override
  String get source_global_search => 'Wyszukiwanie w źródłach';

  @override
  String get source_manage_repositories => 'Zarządzaj repozytoriami';

  @override
  String get source_view_third_party => 'Wyświetl źródła zewnętrzne';

  @override
  String get source_catalog_load_failed =>
      'Nie można załadować katalogu. Pociągnij w dół, aby spróbować ponownie.';

  @override
  String get source_all_websites => 'Wszystkie strony internetowe';

  @override
  String get source_available => 'Dostępne do zainstalowania';

  @override
  String get source_third_party => 'Strona trzecia';

  @override
  String get source_name_or_title => 'Nazwa lub tytuł strony internetowej';

  @override
  String get view_all => 'Wyświetl wszystkie';

  @override
  String get search_searching_ellipsis => 'Wyszukiwanie…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · Nietestowane';
  }

  @override
  String get onboarding_untested => 'Nietestowane';

  @override
  String get source_custom_scope => 'Niestandardowe';

  @override
  String get source_custom_websites => 'Wybrane strony internetowe';

  @override
  String get tv_hidden_library_hint =>
      'Każdy tytuł znajduje się w ukrytej kategorii.\nPrzytrzymaj OK na „Wszystkie”, aby odkryć jedno.';

  @override
  String get tv_no_matching_anime => 'Brak pasującego anime';

  @override
  String tv_no_matching_category(String category) {
    return 'Brak pasującego anime w „$category”';
  }

  @override
  String get tv_filtered_empty_hint =>
      'Żadne anime nie pasuje do bieżących filtrów.\nZmień je za pomocą przycisku obok wyszukiwania.';

  @override
  String get tv_new_episodes => 'Nowe odcinki';

  @override
  String get tv_recently_added => 'Ostatnio dodane';

  @override
  String get tv_empty_category_hint =>
      'Nie ma jeszcze anime w tej kategorii.\nDodaj do niego tytuły ze strony szczegółów tytułu.';

  @override
  String get tv_empty_library => 'Twoja biblioteka anime jest pusta';

  @override
  String get tv_empty_library_hint =>
      'Dodaj anime z Przeglądaj, aby wypełnić swój dom';

  @override
  String get tv_browse_anime => 'Przeglądaj anime';

  @override
  String tv_new_count(int count) {
    return '$count nowy';
  }

  @override
  String tv_category_hidden(String category) {
    return 'Ukryto „$category” · Przytrzymaj OK na „Wszystkie”, aby odkryć';
  }

  @override
  String get tv_no_hidden_categories => 'Żadnych ukrytych kategorii';

  @override
  String get import_torrent_file => 'Zaimportuj plik .torrent';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi i inne';

  @override
  String get cloudflare_proxy_optional =>
      'Opcjonalny FlareSolverr / Byparr URL';

  @override
  String get tv_home_layout_hint =>
      'Strona główna anime oparta na wierszach (Kontynuacja · Nowe odcinki · kategorie) zamiast płaskiej siatki';

  @override
  String get tv_hide_libraries_hint =>
      'Ukryj biblioteki mangi i powieści (domyślnie włączone w telewizorze)';

  @override
  String get anime_only_hint =>
      'Ukryj mangę i powieść w całej aplikacji. Wyłącz, aby pokazać wszystko.';

  @override
  String get audio_auto_safe => 'Automatyczne zabezpieczenie';

  @override
  String get tv_player_hint =>
      'Wł.: dedykowany odtwarzacz telewizyjny.  Wył.: oryginalny odtwarzacz (na komputer stacjonarny).';

  @override
  String get release_open_failed => 'Nie można otworzyć wydania';

  @override
  String get tv_replay => 'Powtórka';

  @override
  String get tv_no_episodes => 'Nie ma jeszcze odcinków';

  @override
  String get tracker_continue_series => 'Kontynuuj oglądanie seriali';

  @override
  String get tracker_watchlist_series => 'Seria list obserwacyjnych';

  @override
  String get tracker_continue_movies => 'Kontynuuj oglądanie filmów';

  @override
  String get tracker_watchlist_movies => 'Lista filmów do obejrzenia';

  @override
  String get tracker_trending_series => 'Seria zyskująca popularność';

  @override
  String get tracker_trending_movies => 'Popularne filmy';

  @override
  String get tracker_popular_series => 'Seria popularna';

  @override
  String get tracker_popular_movies => 'Popularne filmy';

  @override
  String get tracker_top_series => 'Najlepsze serie (całe czasy)';

  @override
  String get tracker_top_movies => 'Najpopularniejsze filmy (całe czasy)';

  @override
  String get tracker_airing_series => 'Seria wietrzenia';

  @override
  String get tracker_airing_anime => 'Emitowanie anime';

  @override
  String get tracker_popular_anime => 'Popularne anime';

  @override
  String get tracker_upcoming_anime => 'Nadchodzące anime';

  @override
  String get tracker_popular_manga => 'Popularna manga';

  @override
  String get tracker_top_manga => 'Najlepsza manga';

  @override
  String get tracker_top_manhwa => 'Górna Manhwa';

  @override
  String get tracker_top_manhua => 'Top Manhua';

  @override
  String get tracker_latest_anime => 'Najnowsze anime';

  @override
  String get tracker_best_anime => 'Najwyżej oceniane anime';

  @override
  String get tracker_latest_manga => 'Najnowsza manga';

  @override
  String get tracker_best_manga => 'Najwyżej oceniana manga';

  @override
  String get tracker_trending_anime => 'Popularne anime';

  @override
  String get tracker_upcoming_manga => 'Nadchodząca manga';

  @override
  String get tracker_trending_manga => 'Popularna manga';

  @override
  String selection_progress(int selected, int total) {
    return 'Wybrano $selected/$total';
  }

  @override
  String get source_code_editor => 'Edytor kodu';

  @override
  String get source_code_execute => 'Wykonaj';

  @override
  String get source_console_logs => 'Dzienniki konsoli';

  @override
  String get source_no_logs => 'Nie ma jeszcze żadnych dzienników';

  @override
  String get source_updated_successfully =>
      'Źródło zostało pomyślnie zaktualizowane';

  @override
  String get source_obsolete => 'PRZESTARZAŁE';

  @override
  String player_seek_forward_seconds(int seconds) {
    return 'Wyszukiwanie do przodu $seconds sekund';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return 'Wyszukiwanie do tyłu o $seconds sekund';
  }

  @override
  String get player_autoplay_on =>
      'Automatyczne odtwarzanie następnego odcinka: włączone';

  @override
  String get player_autoplay_off =>
      'Automatyczne odtwarzanie następnego odcinka: wyłączone';

  @override
  String get player_no_other_quality => 'Żadna inna jakość';

  @override
  String get player_no_subtitles => 'Brak napisów';

  @override
  String get player_no_audio_tracks => 'Brak ścieżek audio';

  @override
  String get player_seek_forward => 'Szukaj do przodu';

  @override
  String get player_seek_backward => 'Szukaj do tyłu';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds sekundy',
      many: '$seconds sekund',
      few: '$seconds sekundy',
      one: '$seconds sekunda',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'Lorem ipsum dolor sit amet';

  @override
  String get subtitle_style => 'Styl';

  @override
  String get translation_official_channel => 'NodeLane Oficjalne';

  @override
  String get translation_auth_required =>
      'Najpierw zaloguj się na swoje konto tłumaczeniowe.';

  @override
  String get translation_source_changed =>
      'Oryginalny obraz został zmieniony. Załaduj go ponownie.';

  @override
  String get translation_source_missing =>
      'Oryginalny obraz jest obecnie niedostępny.';

  @override
  String get translation_resource_limit =>
      'Ten obraz przekracza limit przetwarzania urządzenia. Oryginał zostaje zachowany.';

  @override
  String get translation_storage_full =>
      'Pamięć tłumaczeń jest pełna. Najpierw usuń przetłumaczone obrazy.';

  @override
  String get translation_invalid_image =>
      'Nieprawidłowy format obrazu lub treść.';

  @override
  String get translation_unsupported_image =>
      'Tłumaczenie tego obrazu nie jest obsługiwane. Oryginał zostaje zachowany.';

  @override
  String get translation_invalid_result =>
      'Weryfikacja przetłumaczonego obrazu nie powiodła się. Załaduj go ponownie.';

  @override
  String get translation_result_unavailable =>
      'Przetłumaczony obraz jest niedostępny. Załaduj go ponownie.';

  @override
  String get translation_result_expired =>
      'Przetłumaczony obraz utracił ważność. Proszę przetłumaczyć to jeszcze raz.';

  @override
  String get translation_analysis_too_large =>
      'Treść obrazu jest zbyt duża do analizy. Zmniejsz rozmiar obrazu i spróbuj ponownie.';

  @override
  String get translation_region_limit =>
      'Obraz zawiera zbyt wiele obszarów tekstowych. Podziel go i spróbuj ponownie.';

  @override
  String get translation_text_limit =>
      'Obszar tekstowy jest za długi. Dostosuj obraz i spróbuj ponownie.';

  @override
  String get translation_unavailable => 'To tłumaczenie nie jest już dostępne.';

  @override
  String get translation_outcome_unknown =>
      'Wynik wymaga weryfikacji. Nie został przesłany ponownie.';

  @override
  String get translation_rate_limited =>
      'Żądania są ograniczone. Tłumaczenie zostanie wznowione automatycznie.';

  @override
  String get translation_quota_exhausted => 'Niewystarczający limit tłumaczeń.';

  @override
  String get translation_unsupported_language =>
      'Usługa nie obsługuje tego języka docelowego.';

  @override
  String get translation_upgrade_required =>
      'Protokół translacji jest niekompatybilny. Zaktualizuj aplikację.';

  @override
  String get translation_remote_failed =>
      'Tłumaczenie tej strony nie powiodło się. Możesz spróbować ponownie ręcznie.';

  @override
  String get translation_bridge_invalid =>
      'Strona internetowa uległa zmianie. Włącz tłumaczenie ponownie.';

  @override
  String get translation_connection_failed =>
      'Połączenie nie powiodło się. Spróbuj ponownie.';

  @override
  String get translation_paused =>
      'Tłumaczenie wstrzymane. Możesz sprawdzić jego postęp.';

  @override
  String get translation_preparing_ellipsis => 'Przygotowywanie tłumaczenia…';

  @override
  String get translation_checking_original =>
      'Sprawdzanie oryginalnego obrazu…';

  @override
  String get translation_submitting => 'Przesyłanie…';

  @override
  String get translation_uploading_ellipsis => 'Przesyłanie oryginału…';

  @override
  String get translation_waiting_ellipsis => 'Oczekiwanie na tłumaczenie…';

  @override
  String get translation_running_ellipsis => 'Tłumaczenie…';

  @override
  String get translation_verify_result => 'Wynik wymaga weryfikacji';

  @override
  String get translation_partial => 'Część treści została przetłumaczona';

  @override
  String get translation_ready => 'Przetłumaczony obraz gotowy';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Odtwórz';

  @override
  String get player_quality => 'Jakość';

  @override
  String get player_subtitles => 'Napisy';

  @override
  String get player_audio => 'Dźwięk';

  @override
  String get player_statistics => 'Statystyki dla kujonów';

  @override
  String get player_auto => 'Automat';

  @override
  String get source_information => 'Informacje źródłowe';

  @override
  String get source_code_page => 'Strona';

  @override
  String get source_code_query => 'Zapytanie';

  @override
  String get repository_invalid_source => 'Nieprawidłowe źródło - usuń je';

  @override
  String get player_fit_contain => 'Zawiera';

  @override
  String get player_fit_cover => 'Pokrywa';

  @override
  String get player_fit_fill => 'Wypełnienie';

  @override
  String get player_fit_height => 'Wysokość';

  @override
  String get player_fit_width => 'Szerokość';

  @override
  String get player_fit_scale => 'Skala';

  @override
  String get player_fit_none => 'Brak';

  @override
  String get player_shader_clear => 'Wyłączone (wyczyść shadery)';

  @override
  String get player_shader_luma => 'Zwiększanie Lumy';

  @override
  String get player_decoder_auto => 'Auto (sprzęt)';

  @override
  String get player_decoder_software => 'Oprogramowanie (bez sprzętu)';

  @override
  String get player_stats_toggle => 'Przełącz nakładkę';

  @override
  String get player_stats_general => 'Ogólne';

  @override
  String get player_stats_frames => 'Taktowanie ramek';

  @override
  String get player_stats_cache => 'Wejściowa pamięć podręczna';

  @override
  String get player_stats_filters => 'Filtry aktywne';

  @override
  String get player_stats_log => 'Dziennik';

  @override
  String get source_mark_pinned => 'Kołek';

  @override
  String translation_image_action(String action) {
    return '$action ten obraz';
  }

  @override
  String get memory_waiting => 'pamięć: oczekiwanie na próbkę';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current szczyt $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'pamięć podręczna $current / $limit szczyt $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'elementy $count / $limit na żywo $live szczyt $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Próbki $count',
      one: '1 próbka',
    );
    return 'pełne $percent% z $_temp0';
  }

  @override
  String get memory_reset_hint =>
      'wyłącz i włącz w ustawieniach, aby zresetować';

  @override
  String get action_hide => 'Ukryj';

  @override
  String discord_get_app(String app) {
    return 'Uzyskaj $app';
  }

  @override
  String get discord_idle => 'Bezczynność';

  @override
  String discord_watching_title(String title) {
    return 'Oglądanie $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'Odczyt $title';
  }
}
