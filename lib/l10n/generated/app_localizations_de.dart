// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get browser_search_hint => 'Suchen oder URL eingeben';

  @override
  String get browser_start_hint => 'Eine neue Seite für deine Entdeckungen.';

  @override
  String get browser_search_engine => 'Suchmaschine';

  @override
  String get browser_bookmarks => 'Lesezeichen';

  @override
  String get browser_search_library => 'Titel oder URLs suchen';

  @override
  String get browser_data_failed =>
      'Browserdaten konnten nicht gelesen oder gespeichert werden. Bitte erneut versuchen.';

  @override
  String get browser_clear_history => 'Browserverlauf löschen';

  @override
  String get browser_clear_history_hint =>
      'Den gesamten Verlauf auf diesem Gerät löschen? Lesezeichen und Website-Anmeldungen bleiben erhalten.';

  @override
  String get browser_library_empty => 'Noch keine Einträge';

  @override
  String get browser_bookmarks_hint =>
      'Speichere eine Seite über ihr Menü als Lesezeichen, um sie hier zu finden.';

  @override
  String get browser_history_hint =>
      'Besuchte Seiten bleiben hier sichtbar, auch nachdem ihre Tabs geschlossen wurden.';

  @override
  String get browser_recent => 'Zuletzt besucht';

  @override
  String get browser_pinned_hint =>
      'Hefte häufig besuchte Websites unter Quellen für den Schnellzugriff an.';

  @override
  String get browser_start_page => 'Startseite';

  @override
  String get browser_remove_bookmark => 'Lesezeichen entfernen';

  @override
  String get browser_add_bookmark => 'Lesezeichen hinzufügen';

  @override
  String get browser_find => 'Auf Seite suchen';

  @override
  String get browser_copy_link => 'Link kopieren';

  @override
  String get browser_action_failed =>
      'Die Aktion konnte nicht abgeschlossen werden. Bitte erneut versuchen.';

  @override
  String get browser_find_previous => 'Vorheriger Treffer';

  @override
  String get browser_find_next => 'Nächster Treffer';

  @override
  String browser_find_matches(int current, int total) {
    return 'Treffer $current von $total';
  }

  @override
  String get app_update_details_hint =>
      'Versionshinweise und Installationsoptionen anzeigen';

  @override
  String get app_update_download => 'Update herunterladen';

  @override
  String get app_update_download_hint =>
      'Befolgen Sie nach dem Herunterladen die Anweisungen zur Installation des Updates.';

  @override
  String get bookshelf_all => 'Alle';

  @override
  String get bookshelf_search => 'Bibliothek durchsuchen';

  @override
  String get app_update_allow_install =>
      'Erlauben Sie die App-Installation in den Systemeinstellungen, kehren Sie dann zurück und tippen Sie auf „Installieren“.';

  @override
  String get app_update_waiting =>
      'Warten darauf, dass das System den Download fortsetzt …';

  @override
  String get app_update_cancel_download => 'Download abbrechen';

  @override
  String get app_update_remove_package => 'Heruntergeladenes Paket entfernen';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'Keine passenden Einstellungen';

  @override
  String get search_empty_hint =>
      'Versuchen Sie es mit einem anderen Schlüsselwort oder löschen Sie die Suche, um alles zu sehen.';

  @override
  String get search_clear => 'Suche löschen';

  @override
  String get app_updates => 'App-Updates';

  @override
  String get app_update_auto => 'Beim Start prüfen';

  @override
  String get app_update_view => 'Update anzeigen';

  @override
  String get app_update_later => 'Später';

  @override
  String get app_update_external_hint =>
      'Öffnet den Update-Link in Ihrem Browser';

  @override
  String get app_update_failed =>
      'Es kann nicht nach Updates gesucht werden. Bitte versuchen Sie es erneut.';

  @override
  String get app_update_opened => 'Update-Link geöffnet';

  @override
  String get app_diagnostics => 'Diagnose und Protokolle';

  @override
  String get library => 'Bibliothek';

  @override
  String get updates_search => 'Aktualisierungen suchen';

  @override
  String get updates => 'Aktualisierungen';

  @override
  String get history => 'Verlauf';

  @override
  String get browse => 'Durchsuchen';

  @override
  String get more => 'Mehr';

  @override
  String get open_random_entry => 'Zufälligen Eintrag öffnen';

  @override
  String get import => 'Importieren';

  @override
  String get filter => 'Filter';

  @override
  String get ignore_filters => 'Filter ignorieren';

  @override
  String get downloaded => 'Heruntergeladen';

  @override
  String get unread => 'Ungelesen';

  @override
  String get unwatched => 'Nicht angeschaut';

  @override
  String get started => 'Begonnen';

  @override
  String get bookmarked => 'Markiert';

  @override
  String get sort => 'Sortieren';

  @override
  String get alphabetically => 'Alphabetisch';

  @override
  String get last_read => 'Zuletzt gelesen';

  @override
  String get last_watched => 'Zuletzt angeschaut';

  @override
  String get last_update_check => 'Letzte Aktualisierungsprüfung';

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
          'Du löschst alle $count $entryTypePlural dieses ${mediaType}s aus deiner Bibliothek.',
      one:
          'Du löschst das einzige $entryType dieses ${mediaType}s aus deiner Bibliothek.',
    );
    return '$_temp0\nDadurch wird auch der ganze $mediaType aus deiner Bibliothek entfernt.\n\nHinweis: Die Dateien selbst werden nicht gelöscht.';
  }

  @override
  String get chapter => 'Kapitel';

  @override
  String get episode => 'Episode';

  @override
  String get unread_count => 'Ungelesene Anzahl';

  @override
  String get unwatched_count => 'Ungesehene Anzahl';

  @override
  String get latest_chapter => 'Letztes Kapitel';

  @override
  String get latest_episode => 'Letzte Episode';

  @override
  String get date_added => 'Hinzugefügt am';

  @override
  String get display => 'Anzeige';

  @override
  String get display_mode => 'Anzeigemodus';

  @override
  String get compact_grid => 'Kompaktes Gitter';

  @override
  String get compression_level => 'Kompressionsstufe';

  @override
  String compression_info(Object level) {
    return 'Je höher die Kompression, desto weniger Platz nimmt die Backup-Datei ein, benötigt aber mehr CPU. Standard: $level';
  }

  @override
  String get comfortable_grid => 'Bequemes Gitter';

  @override
  String get cover_only_grid => 'Nur-Cover-Gitter';

  @override
  String get list => 'Liste';

  @override
  String get badges => 'Abzeichen';

  @override
  String get downloaded_chapters => 'Heruntergeladene Kapitel';

  @override
  String get downloaded_episodes => 'Heruntergeladene Episoden';

  @override
  String get language => 'Sprache';

  @override
  String get local_source => 'Lokale Quelle';

  @override
  String get tabs => 'Tabs';

  @override
  String get show_category_tabs => 'Kategorietabs anzeigen';

  @override
  String get show_numbers_of_items => 'Artikelanzahl anzeigen';

  @override
  String get other => 'Andere';

  @override
  String get show_continue_reading_buttons => 'Weiterlesen-Buttons anzeigen';

  @override
  String get show_continue_watching_buttons => 'Weiterschauen-Buttons anzeigen';

  @override
  String get empty_library => 'Leere Bibliothek';

  @override
  String get search => 'Suche...';

  @override
  String get no_recent_updates => 'Keine kürzlichen Aktualisierungen';

  @override
  String get remove_everything => 'Alles entfernen';

  @override
  String get remove_everything_msg =>
      'Bist du dir sicher? Alle Verläufe werden gelöscht';

  @override
  String get remove_all_update_msg =>
      'Bist du dir sicher? Alle Updates werden gelöscht';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get remove => 'Entfernen';

  @override
  String get remove_history_msg =>
      'Das wird das Lesedatum dieses Kapitels entfernen. Bist du dir sicher?';

  @override
  String get last_used => 'Zuletzt verwendet';

  @override
  String get pinned => 'Fixiert';

  @override
  String get sources => 'Quellen';

  @override
  String get install => 'Installieren';

  @override
  String get update => 'Aktualisieren';

  @override
  String get latest => 'Neueste';

  @override
  String get extensions => 'Erweiterungen';

  @override
  String get migrate => 'Migrieren';

  @override
  String get mass_migration_title => 'Massenmigration';

  @override
  String get mass_migration_preview_items => 'Vorschau';

  @override
  String get mass_migration_destination_source => 'Zielquelle';

  @override
  String get mass_migration_no_library_items =>
      'Keine Bibliothekseinträge für die Massenmigration verfügbar.';

  @override
  String get mass_migration_no_destination_sources =>
      'Keine installierten Zielquellen verfügbar.';

  @override
  String get mass_migration_installed => 'Installiert';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge zur Überprüfung bereit',
      one: '1 Eintrag zur Überprüfung bereit',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'Zielquelle auswählen';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Suche Übereinstimmungen in $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Verarbeite Eintrag $current von $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Warte 2 Sekunden vor dem nächsten Eintrag...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Warte 2 Sekunden vor der nächsten Migration...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Bisher übereinstimmend: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Keine Übereinstimmung: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Übereinstimmungen für $source überprüfen';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Gefundene Übereinstimmungen: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Keine Übereinstimmungen: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Zur Migration ausgewählt: $count';
  }

  @override
  String get mass_migration_finish_review => 'Überprüfung abschließen';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Ausgewählte Einträge migrieren ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Ausgewählte Einträge nach $source migrieren';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Keine Einträge zur Migration ausgewählt.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migriere Eintrag $current von $total';
  }

  @override
  String get mass_migration_complete => 'Massenmigration abgeschlossen';

  @override
  String get mass_migration_complete_success_message =>
      'Alle ausgewählten Einträge wurden erfolgreich verarbeitet.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migration abgeschlossen, aber einige Einträge erfordern manuelle Aufmerksamkeit.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Verarbeitet';

  @override
  String get mass_migration_matched => 'Übereinstimmend';

  @override
  String get mass_migration_migrated => 'Migriert';

  @override
  String get mass_migration_skipped => 'Übersprungen';

  @override
  String get mass_migration_failed => 'Fehlgeschlagen';

  @override
  String get mass_migration_failed_items => 'Fehlgeschlagene Einträge';

  @override
  String get mass_migration_exit => 'Massenmigration verlassen';

  @override
  String get mass_migration_no_destination_match =>
      'Keine Ziel-Übereinstimmung gefunden';

  @override
  String mass_migration_query(Object query) {
    return 'Abfrage: $query';
  }

  @override
  String get mass_migration_skip => 'Überspringen';

  @override
  String get mass_migration_loading => 'Lade...';

  @override
  String get mass_migration_choose_another_result => 'Anderes Ergebnis wählen';

  @override
  String get mass_migration_source_chapters => 'Quellkapitel';

  @override
  String get mass_migration_destination_chapters => 'Zielkapitel';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel',
      one: '1 Kapitel',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellkapitel',
      one: '1 Quellkapitel',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zielkapitel',
      one: '1 Zielkapitel',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Keine Kapitel gefunden.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Und $count weitere...';
  }

  @override
  String get mass_migration_unknown_title => 'Unbekannter Titel';

  @override
  String get mass_migration_unknown_match => 'Unbekannte Übereinstimmung';

  @override
  String get mass_migration_unknown_source => 'Unbekannte Quelle';

  @override
  String get mass_migration_unknown_chapter => 'Unbekanntes Kapitel';

  @override
  String get migrate_confirm => 'Zu einer anderen Erweiterung migrieren';

  @override
  String get clean_database => 'Datenbank säubern';

  @override
  String cleaned_database(Object x) {
    return 'Datenbank wurde gesäubert! $x Einträge gelöscht';
  }

  @override
  String get clean_database_desc =>
      'Diese Aktion löscht alle Einträge, die nicht im Bibliothek sind!';

  @override
  String get incognito_mode => 'Inkognito-Modus';

  @override
  String get incognito_mode_description => 'Pausiert den Leseverlauf';

  @override
  String get downloaded_only => 'Nur heruntergeladene';

  @override
  String get downloaded_only_description =>
      'Nur heruntergeladene Einträge in deiner Bibliothek anzeigen';

  @override
  String get download_queue => 'Download-Warteschlange';

  @override
  String get categories => 'Kategorien';

  @override
  String get statistics => 'Statistiken';

  @override
  String get settings => 'Einstellungen';

  @override
  String get about => 'Über';

  @override
  String get help => 'Hilfe';

  @override
  String get no_downloads => 'Keine Downloads';

  @override
  String get edit_categories => 'Kategorien bearbeiten';

  @override
  String get edit_categories_description =>
      'Du hast keine Kategorien. Tippe auf den Plus-Button, um eine zu erstellen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get add_category => 'Kategorie hinzufügen';

  @override
  String get name => 'Name';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Erforderlich';

  @override
  String get add_category_error_exist =>
      'Eine Kategorie mit diesem Namen existiert bereits!';

  @override
  String get delete_category => 'Kategorie löschen';

  @override
  String delete_category_msg(Object name) {
    return 'Möchtest du die Kategorie $name wirklich löschen?';
  }

  @override
  String get rename_category => 'Kategorie umbenennen';

  @override
  String get general => 'Allgemein';

  @override
  String get general_subtitle => 'App-Sprache';

  @override
  String get app_language => 'App-Sprache';

  @override
  String get default_subtitle_language => 'Standard Untertitel-Sprache';

  @override
  String get appearance => 'Aussehen';

  @override
  String get appearance_subtitle => 'Thema, Datum- & Zeitformat';

  @override
  String get theme => 'Thema';

  @override
  String get dark_mode => 'Dunkler Modus';

  @override
  String get follow_system_theme => 'System Hell/Dunkel-Modus folgen';

  @override
  String get on => 'An';

  @override
  String get off => 'Aus';

  @override
  String get pure_black_dark_mode => 'Rein schwarzer Dunkler Modus';

  @override
  String get timestamp => 'Zeitstempel';

  @override
  String get relative_timestamp => 'Relativer Zeitstempel';

  @override
  String get relative_timestamp_short => 'Kurz (Heute, Gestern)';

  @override
  String get relative_timestamp_long => 'Lang (Kurz+, vor n Tagen)';

  @override
  String get date_format => 'Datumsformat';

  @override
  String get reader => 'Reader';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get reader_subtitle => 'Lesemodus, Anzeige, Navigation';

  @override
  String get default_reading_mode => 'Standard-Lesemodus';

  @override
  String get reading_mode_vertical => 'Vertikal';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Links nach Rechts';

  @override
  String get reading_mode_right_to_left => 'Rechts nach Links';

  @override
  String get reading_mode_vertical_continuous => 'Vertikal kontinuierlich';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Doppel-Tipp-Animationsgeschwindigkeit';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Schnell';

  @override
  String get no_animation => 'Keine Animation';

  @override
  String get animate_page_transitions => 'Seitenübergänge animieren';

  @override
  String get crop_borders => 'Ränder beschneiden';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloads_subtitle => 'Download-Einstellungen';

  @override
  String get download_location => 'Download-Ort';

  @override
  String get custom_location => 'Benutzerdefinierter Ort';

  @override
  String get only_on_wifi => 'Nur über WLAN';

  @override
  String get save_as_cbz_archive => 'Als CBZ-Archiv speichern';

  @override
  String get delete_download_after_reading => 'Download nach dem Lesen löschen';

  @override
  String get concurrent_downloads => 'Gleichzeitige Downloads';

  @override
  String get browse_subtitle => 'Quellen, globale Suche';

  @override
  String get only_include_pinned_sources => 'Nur fixierte Quellen einbeziehen';

  @override
  String get nsfw_sources => 'NSFW (+18) Quellen';

  @override
  String get nsfw_sources_show => 'In Quellen- und Erweiterungslisten anzeigen';

  @override
  String get nsfw_sources_info =>
      'Dies verhindert nicht, dass inoffizielle oder möglicherweise falsch gekennzeichnete Erweiterungen NSFW (18+) Inhalte in der App anzeigen';

  @override
  String get version => 'Version';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Auf Aktualisierung prüfen';

  @override
  String get logs_on => 'Protokollierung aktivieren';

  @override
  String get share_app_logs => 'App-Protokolle teilen';

  @override
  String get no_app_logs => 'Keine log.txt Datei verfügbar!';

  @override
  String get failed => 'Fehlgeschlagen!';

  @override
  String n_days_ago(Object days) {
    return 'Vor $days Tagen';
  }

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get a_week_ago => 'Vor einer Woche';

  @override
  String get next_week => 'Nächste Woche';

  @override
  String get add_to_library => 'Zur Bibliothek hinzufügen';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get ongoing => 'Laufend';

  @override
  String get on_hiatus => 'In Pause';

  @override
  String get canceled => 'Abgebrochen';

  @override
  String get publishing_finished => 'Veröffentlichung abgeschlossen';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get empty_placeholder => 'LEER';

  @override
  String get error => 'Fehler';

  @override
  String error_with_message(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get no_pages_available => 'Fehler: keine Seiten verfügbar';

  @override
  String get set_categories => 'Kategorien festlegen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get in_library => 'In der Bibliothek';

  @override
  String get filter_scanlator_groups => 'Scanlator-Gruppen filtern';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get by_source => 'Nach Quelle';

  @override
  String get by_chapter_number => 'Nach Kapitelnummer';

  @override
  String get by_episode_number => 'Nach Episodennummer';

  @override
  String get by_upload_date => 'Nach Upload-Datum';

  @override
  String get source_title => 'Quellentitel';

  @override
  String get create_extension => 'Erweiterung erstellen';

  @override
  String get developer_mode => 'Entwicklermodus';

  @override
  String get developer_mode_subtitle =>
      'Entwicklerwerkzeuge für Erweiterungen anzeigen (Erweiterung erstellen, Code bearbeiten)';

  @override
  String get choose_extension_language => 'Sprache der Erweiterung wählen';

  @override
  String get lang => 'Sprache';

  @override
  String get base_url => 'Basis-URL';

  @override
  String get api_url_optional => 'API-URL (optional)';

  @override
  String get icon_url => 'Icon-URL';

  @override
  String get source_icon_url => 'Quell-Icon-URL';

  @override
  String get notes => 'Hinweise';

  @override
  String get extension_name_example => 'z. B.: meinAnime';

  @override
  String get language_code_example => 'z. B.: de';

  @override
  String get base_url_example => 'z. B.: https://beispiel.de';

  @override
  String get api_url_example => 'z. B.: https://api.beispiel.de';

  @override
  String get extension_notes_example =>
      'z. B.: Diese Erweiterung erfordert eine Anmeldung';

  @override
  String get type => 'Typ';

  @override
  String get target => 'Ziel';

  @override
  String get source_type_single => 'einzeln';

  @override
  String get source_type_multi => 'mehrfach';

  @override
  String get source_type_torrent => 'Torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader kompiliertes JS';

  @override
  String get source_created_successfully => 'Quelle erfolgreich erstellt';

  @override
  String get source_already_exists => 'Quelle existiert bereits';

  @override
  String get error_when_creating_source => 'Fehler beim Erstellen der Quelle';

  @override
  String get cookies_deleted => 'Cookies gelöscht!';

  @override
  String get delete_all_cookies => 'Alle Cookies löschen';

  @override
  String get chapter_number => 'Kapitelnummer';

  @override
  String get episode_number => 'Episodennummer';

  @override
  String get share => 'Teilen';

  @override
  String n_chapters(Object n) {
    return '$n Kapitel';
  }

  @override
  String missing_chapters(Object count) {
    return '$count fehlende Kapitel';
  }

  @override
  String get no_description => 'Keine Beschreibung';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get read => 'Lesen';

  @override
  String get watch => 'Anschauen';

  @override
  String get popular => 'Beliebt';

  @override
  String get open_in_browser => 'Im Browser öffnen';

  @override
  String get clear_cookie => 'Cookie löschen';

  @override
  String get show_page_number => 'Seitenzahl anzeigen';

  @override
  String get from_library => 'Aus der Bibliothek';

  @override
  String get downloaded_chapter => 'Heruntergeladenes Kapitel';

  @override
  String page(Object page) {
    return 'Seite $page';
  }

  @override
  String get global_search => 'Globale Suche';

  @override
  String get color_blend_level => 'Farbmischungsstufe';

  @override
  String current(Object char) {
    return 'Aktuell $char';
  }

  @override
  String finished(Object char) {
    return 'Fertig $char';
  }

  @override
  String next(Object char) {
    return 'Nächste $char';
  }

  @override
  String previous(Object char) {
    return 'Vorherige $char';
  }

  @override
  String get no_more_chapter => 'Es gibt keine weiteren Kapitel';

  @override
  String get no_result => 'Kein Ergebnis';

  @override
  String get send => 'Senden';

  @override
  String get delete => 'Löschen';

  @override
  String get start_downloading => 'Jetzt mit dem Herunterladen beginnen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get add_chapters => 'Kapitel hinzufügen';

  @override
  String get delete_chapters => 'Kapitel löschen?';

  @override
  String get default0 => 'Standard';

  @override
  String get total_chapters => 'Gesamtkapitel';

  @override
  String get total_episodes => 'Gesamtepisoden';

  @override
  String get import_local_file => 'Lokale Datei importieren';

  @override
  String get import_files => 'Dateien';

  @override
  String get split_epub_chapters => 'In Kapitel aufteilen';

  @override
  String get split_epub_chapters_description =>
      'Jedes EPUB-Kapitel als separaten Eintrag importieren';

  @override
  String get nothing_read_recently => 'Kürzlich nichts gelesen';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Nicht begonnen';

  @override
  String get score => 'Bewertung';

  @override
  String get start_date => 'Startdatum';

  @override
  String get finish_date => 'Enddatum';

  @override
  String get reading => 'Lesend';

  @override
  String get on_hold => 'In Warteschleife';

  @override
  String get dropped => 'Abgebrochen';

  @override
  String get plan_to_read => 'Geplant zu lesen';

  @override
  String get re_reading => 'Wiederlesen';

  @override
  String get chapters => 'Kapitel';

  @override
  String get add_tracker => 'Tracker hinzufügen';

  @override
  String get one_tracker => '1 Tracker';

  @override
  String n_tracker(Object n) {
    return '$n Tracker';
  }

  @override
  String get tracking => 'Tracking';

  @override
  String get syncing => 'Synchronisierung';

  @override
  String get sync_logged => 'Login erfolgreich!';

  @override
  String get syncing_subtitle =>
      'Gib die Adresse deines Synchronisierungsservers ein und melde dich im Browser an, um deinen Lesefortschritt geräteübergreifend zu synchronisieren.';

  @override
  String get sync_service => 'Selbst gehostete Synchronisierung';

  @override
  String get last_sync => 'Letzte Synchronisierung um: ';

  @override
  String get sync_login_browser => 'Im Browser anmelden';

  @override
  String get sync_server => 'Sync Server IP Adresse / Domain';

  @override
  String get sync_starting => 'Sync gestartet...';

  @override
  String get sync_finished => 'Sync erfolgreich abgeschlossen!';

  @override
  String get sync_failed => 'Sync fehlgeschlagen!';

  @override
  String get sync_restore_in_progress =>
      'Synchronisierung übersprungen – Wiederherstellung läuft';

  @override
  String sync_progress_percent(Object percent) {
    return 'Synchronisierung… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Synchronisierung…';

  @override
  String get sync_button_sync => 'Jetzt synchronisieren';

  @override
  String get sync_button_upload => 'Nur hochladen';

  @override
  String get sync_button_upload_info =>
      'Dieser Vorgang ersetzt die Remote-Daten vollständig durch die lokalen Daten!';

  @override
  String get sync_button_download => 'Nur herunterladen';

  @override
  String get sync_button_download_info =>
      'Dieser Vorgang ersetzt die lokalen Daten vollständig durch die Remote-Daten!';

  @override
  String get sync_status_not_configured => 'Nicht verbunden';

  @override
  String get sync_status_checking => 'Verbindung wird überprüft...';

  @override
  String get sync_status_connected => 'Verbunden';

  @override
  String get sync_status_unauthorized =>
      'Sitzung abgelaufen, bitte erneut anmelden';

  @override
  String get sync_status_unreachable => 'Server nicht erreichbar';

  @override
  String get sync_section_general => 'Allgemein';

  @override
  String get sync_on => 'Sync aktivieren';

  @override
  String get sync_auto => 'Auto Sync';

  @override
  String get sync_auto_warning =>
      'Auto Sync ist derzeit ein experimentelles Feature!';

  @override
  String get sync_auto_off => 'Aus';

  @override
  String get sync_auto_5_minutes => 'Alle 5 Minuten';

  @override
  String get sync_auto_10_minutes => 'Alle 10 Minuten';

  @override
  String get sync_auto_30_minutes => 'Alle 30 Minuten';

  @override
  String get sync_auto_1_hour => 'Jede Stunde';

  @override
  String get sync_auto_3_hours => 'Alle 3 Stunden';

  @override
  String get sync_auto_6_hours => 'Alle 6 Stunden';

  @override
  String get sync_auto_12_hours => 'Alle 12 Stunden';

  @override
  String get server_error => 'Server Fehler!';

  @override
  String get dialog_confirm => 'Fortfahren';

  @override
  String get description => 'Beschreibung';

  @override
  String get reorder_navigation => 'Navigation anpassen';

  @override
  String get reorder_navigation_description =>
      'Du kannst die Anordnung und Sichbarheit der Navigation für dich selber anpassen.';

  @override
  String get floating_navigation_bar => 'Schwebende Navigationsleiste';

  @override
  String get floating_navigation_bar_description =>
      'Verwenden Sie eine schwebende Kapsel anstelle der standardmäßig angebrachten Navigationsleiste.';

  @override
  String get full_screen_player => 'Vollbildmodus aktivieren';

  @override
  String get full_screen_player_info =>
      'Vollbildmodus in Videos automatisch aktivieren.';

  @override
  String episode_progress(Object n) {
    return 'Fortschritt: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n Episoden';
  }

  @override
  String missing_episodes(Object count) {
    return '$count fehlende Episoden';
  }

  @override
  String get manga_sources => 'Manga-Quellen';

  @override
  String get anime_sources => 'Anime-Quellen';

  @override
  String get novel_sources => 'Novel-Quellen';

  @override
  String get anime_extensions => 'Anime-Erweiterungen';

  @override
  String get manga_extensions => 'Manga-Erweiterungen';

  @override
  String get novel_extensions => 'Novel-Erweiterungen';

  @override
  String get extension_settings => 'Erweiterungseinstellungen';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'Du hast noch keine Kategorien';

  @override
  String get watching => 'Am Schauen';

  @override
  String get plan_to_watch => 'Plan zu schauen';

  @override
  String get re_watching => 'Erneutes Schauen';

  @override
  String get episodes => 'Episoden';

  @override
  String get download => 'Herunterladen';

  @override
  String get new_update_available => 'Neue Aktualisierung verfügbar';

  @override
  String app_version(Object v) {
    return 'App-Version: v$v';
  }

  @override
  String get searching_for_updates => 'Suche nach Aktualisierungen...';

  @override
  String get no_new_updates_available =>
      'Keine neuen Aktualisierungen verfügbar';

  @override
  String get uninstall => 'Deinstallieren';

  @override
  String uninstall_extension(Object ext) {
    return 'Erweiterung $ext deinstallieren?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Doppeltippen, um alle $type zu durchsuchen';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Suchtipp für Doppeltippen anzeigen';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Einen Tooltip auf den Reitern Manga/Anime/Roman anzeigen, der erklärt, dass ein Doppeltippen die globale Suche öffnet.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" ist bereits über $source in Ihrer Bibliothek.';
  }

  @override
  String get add_anyway => 'Trotzdem hinzufügen';

  @override
  String get langauage => 'Sprache';

  @override
  String get extension_detail => 'Erweiterungsdetail';

  @override
  String get scale_type => 'Skalierungstyp';

  @override
  String get scale_type_fit_screen => 'An Bildschirm anpassen';

  @override
  String get scale_type_stretch => 'Strecken';

  @override
  String get scale_type_fit_width => 'Breite anpassen';

  @override
  String get scale_type_fit_height => 'Höhe anpassen';

  @override
  String get scale_type_original_size => 'Originalgröße';

  @override
  String get scale_type_smart_fit => 'Intelligente Anpassung';

  @override
  String get page_preload_amount => 'Seitenvorlademenge';

  @override
  String get page_preload_amount_subtitle =>
      'Die Anzahl der Seiten, die beim Lesen vorgeladen werden. Höhere Werte resultieren in einem flüssigeren Leseerlebnis, verbrauchen jedoch mehr Speicherplatz und Netzwerkressourcen.';

  @override
  String get image_loading_error => 'Dieses Bild konnte nicht geladen werden';

  @override
  String get add_episodes => 'Episoden hinzufügen';

  @override
  String get video_quality => 'Qualität';

  @override
  String get video_subtitle => 'Untertitel';

  @override
  String get check_for_extension_updates => 'Nach Erweiterungsupdates suchen';

  @override
  String get auto_extensions_updates =>
      'Erweiterungen automatisch aktualisieren';

  @override
  String get auto_extensions_updates_subtitle =>
      'Aktualisiert die Erweiterung automatisch, wenn eine neue Version verfügbar ist.';

  @override
  String get check_for_app_updates => 'Beim Start nach App-Updates suchen';

  @override
  String get reading_mode => 'Lesemodus';

  @override
  String get custom_filter => 'Benutzerdefinierter Filter';

  @override
  String get background_color => 'Hintergrundfarbe';

  @override
  String get white => 'Weiß';

  @override
  String get black => 'Schwarz';

  @override
  String get grey => 'Grau';

  @override
  String get automaic => 'Automatisch';

  @override
  String get preferred_domain => 'Bevorzugte Domain';

  @override
  String get load_more => 'Mehr laden';

  @override
  String get cancel_all_for_this_series => 'Alle für diese Serie abbrechen';

  @override
  String get login => 'Anmelden';

  @override
  String login_into(Object tracker) {
    return 'Anmelden bei $tracker';
  }

  @override
  String get email_adress => 'E-Mail-Adresse';

  @override
  String get password => 'Passwort';

  @override
  String log_out_from(Object tracker) {
    return 'Abmelden von $tracker?';
  }

  @override
  String get log_out => 'Abmelden';

  @override
  String get update_pending => 'Aktualisierung ausstehend';

  @override
  String get update_all => 'Alle aktualisieren';

  @override
  String get backup_and_restore => 'Sichern und Wiederherstellen';

  @override
  String get create_backup => 'Backup erstellen';

  @override
  String get create_backup_dialog_title => 'Was möchtest du sichern?';

  @override
  String get create_backup_subtitle =>
      'Kann verwendet werden, um die aktuelle Bibliothek wiederherzustellen';

  @override
  String get restore_backup => 'Backup wiederherstellen';

  @override
  String get encrypt_backups => 'Backups verschlüsseln';

  @override
  String get encrypt_backups_info =>
      'Backups mittels AES Verfahren verschlüsseln';

  @override
  String get no_secure_storage => 'Keinen geschützten Speicher gefunden';

  @override
  String get no_keyring_warning =>
      'Auf diesem System ist kein Schlüsselbund verfügbar (z. B. gnome-keyring oder KWallet unter Linux), daher kann das Passwort nicht sicher gespeichert werden.\n\nSoll es stattdessen unverschlüsselt in der lokalen App-Datenbank gespeichert werden? Jeder, der Zugriff auf die App-Daten dieses Geräts hat, könnte es lesen.';

  @override
  String get enter_backup_password => 'Backup-Passwort eingeben';

  @override
  String get incorrect_password_try_again =>
      'Falsches Passwort, versuche es erneut.';

  @override
  String get set_backup_password => 'Backup-Passwort festlegen';

  @override
  String get confirm_password => 'Passwort bestätigen';

  @override
  String get passwords_do_not_match => 'Passwörter stimmen nicht überein';

  @override
  String get password_required_to_restore =>
      'Zum Wiederherstellen dieses Backups ist ein Passwort erforderlich.';

  @override
  String get restore_backup_subtitle =>
      'Bibliothek aus Backup-Datei wiederherstellen';

  @override
  String get automatic_backups => 'Automatische Sicherungen';

  @override
  String get backup_frequency => 'Sicherungshäufigkeit';

  @override
  String get backup_location => 'Sicherungsort';

  @override
  String get backup_options => 'Sicherungsoptionen';

  @override
  String get backup_options_dialog_title => 'Was möchtest du sichern?';

  @override
  String get backup_options_subtitle =>
      'Welche Informationen sollen in die Sicherungsdatei aufgenommen werden?';

  @override
  String get backup_and_restore_warning_info =>
      'Du solltest Kopien der Sicherungen auch an anderen Orten aufbewahren';

  @override
  String get library_entries => 'Bibliothekseinträge';

  @override
  String get chapters_and_episode => 'Kapitel und Episode';

  @override
  String get every_6_hours => 'Alle 6 Stunden';

  @override
  String get every_12_hours => 'Alle 12 Stunden';

  @override
  String get daily => 'Täglich';

  @override
  String get every_2_days => 'Alle 2 Tage';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get restore_backup_warning_title =>
      'Das Wiederherstellen einer Sicherung überschreibt alle vorhandenen Daten.\n\nFortfahren mit der Wiederherstellung?';

  @override
  String get restore_sync_question_title =>
      'Diese Wiederherstellung synchronisieren?';

  @override
  String get restore_sync_question_message =>
      'Dieses Gerät ist mit einem Synchronisationsserver verbunden. Sollen die wiederhergestellten Daten jetzt hochgeladen werden? Andernfalls wird die Synchronisation deaktiviert.';

  @override
  String get restore_sync_question_confirm => 'Ja, synchronisieren';

  @override
  String get restore_sync_question_deny => 'Nein, Synchronisation deaktivieren';

  @override
  String get sync_disabled_after_restore =>
      'Synchronisation ist deaktiviert. Sie kann in den Einstellungen wieder aktiviert werden.';

  @override
  String get restore_sync_disabled_question_title =>
      'Synchronisation ist derzeit deaktiviert';

  @override
  String get restore_sync_disabled_question_message =>
      'Synchronisation ist ausgeschaltet. Wieder aktivieren und Daten auf den Server hochladen?';

  @override
  String get restore_sync_question_reenable =>
      'Ja, reaktivieren und synchronisieren';

  @override
  String get restore_sync_question_keep_disabled => 'Deaktiviert lassen';

  @override
  String get restore_sync_uploading =>
      'Wiederhergestellte Daten werden synchronisiert…';

  @override
  String get restore_sync_upload_success =>
      'Wiederhergestellte Daten erfolgreich synchronisiert';

  @override
  String get services => 'Dienste';

  @override
  String get tracking_warning_info =>
      'Einweg-Synchronisierung zum Aktualisieren des Kapitelfortschritts in Tracking-Diensten. Richte das Tracking für einzelne Einträge über deren Tracking-Schaltfläche ein.';

  @override
  String get use_page_tap_zones => 'Seiten-Tippzonen verwenden';

  @override
  String get manage_trackers => 'Tracker verwalten';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get backups => 'Sicherungen';

  @override
  String get by_scanlator => 'Nach Scanlator';

  @override
  String get by_name => 'Nach Name';

  @override
  String get installed => 'Installiert';

  @override
  String get auto_scroll => 'Automatisches Scrollen';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Bevorzugte Sprachen, Tonhöhenkorrektur, Audiokanäle';

  @override
  String get player => 'Player';

  @override
  String get markEpisodeAsSeenSetting =>
      'Zu welchem Zeitpunkt die Episode als gesehen markieren';

  @override
  String get mark_duplicate_chapters_read =>
      'Doppelte Kapitelnummern als gelesen markieren';

  @override
  String get default_skip_intro_length =>
      'Standardlänge für Intro überspringen';

  @override
  String get default_playback_speed_length =>
      'Standardlänge für Wiedergabegeschwindigkeit';

  @override
  String get updateProgressAfterReading =>
      'Fortschritt nach dem Lesen aktualisieren';

  @override
  String get no_sources_installed => 'Keine Quellen installiert!';

  @override
  String get show_extensions => 'Erweiterungen anzeigen';

  @override
  String get default_skip_forward_skip_length =>
      'Standardmäßige Länge des Vorwärtsspringens';

  @override
  String get aniskip_requires_info =>
      'MAL oder Anilist tracking muss konfiguriert werden, damit AniSkip funktioniert.';

  @override
  String get enable_aniskip => 'AniSkip aktivieren';

  @override
  String get enable_auto_skip => 'Automatisches Überspringen aktivieren';

  @override
  String get aniskip_button_timeout => 'Timeout für Taste';

  @override
  String get skip_opening => 'Opening überspringen';

  @override
  String get skip_ending => 'Ending überspringen';

  @override
  String get fullscreen => 'Vollbild';

  @override
  String get update_library => 'Bibliothek aktualisieren';

  @override
  String get next_chapter => 'Nächstes Kapitel';

  @override
  String get next_5_chapters => 'Nächsten 5 Kapitel';

  @override
  String get next_10_chapters => 'Nächsten 10 Kapitel';

  @override
  String get next_25_chapters => 'Nächsten 25 Kapitel';

  @override
  String get all_chapters => 'Alle Kapitel';

  @override
  String get next_episode => 'Nächste Episode';

  @override
  String get next_5_episodes => 'Nächsten 5 Episoden';

  @override
  String get next_10_episodes => 'Nächsten 10 Episoden';

  @override
  String get next_25_episodes => 'Nächsten 25 Episoden';

  @override
  String get all_episodes => 'Alle Episoden';

  @override
  String get cover_saved => 'Titelbild gespeichert';

  @override
  String get set_as_cover => 'Als Titelbild festlegen';

  @override
  String get use_this_as_cover_art => 'Dies als Titelbild verwenden?';

  @override
  String get save => 'Speichern';

  @override
  String get picture_saved => 'Bild gespeichert';

  @override
  String get cover_updated => 'Cover aktualisiert';

  @override
  String get include_subtitles => 'Mit Untertiteln speichern';

  @override
  String get blend_mode_default => 'Standard';

  @override
  String get blend_mode_multiply => 'Multiplizieren';

  @override
  String get blend_mode_screen => 'Bildschirm';

  @override
  String get blend_mode_overlay => 'Überlagern';

  @override
  String get blend_mode_colorDodge => 'Farbüberlagerung';

  @override
  String get blend_mode_lighten => 'Aufhellen';

  @override
  String get blend_mode_colorBurn => 'Farbverbrennung';

  @override
  String get blend_mode_darken => 'Abdunkeln';

  @override
  String get blend_mode_difference => 'Differenz';

  @override
  String get blend_mode_saturation => 'Sättigung';

  @override
  String get blend_mode_softLight => 'Weiches Licht';

  @override
  String get blend_mode_plus => 'Plus';

  @override
  String get blend_mode_exclusion => 'Ausschluss';

  @override
  String get custom_color_filter => 'Benutzerdefinierter Farbfilter';

  @override
  String get color_filter_blend_mode => 'Farbfilter-Mischmodus';

  @override
  String get enable_all => 'Alle aktivieren';

  @override
  String get disable_all => 'Alle deaktivieren';

  @override
  String get font => 'Schriftart';

  @override
  String get color => 'Farbe';

  @override
  String get font_size => 'Schriftgröße';

  @override
  String get text => 'Text';

  @override
  String get border => 'Rand';

  @override
  String get background => 'Hintergrund';

  @override
  String get no_subtite_warning_message =>
      'Hat keine Wirkung, da in diesem Video keine Untertitelspuren vorhanden sind';

  @override
  String get grid_size => 'Rastergröße';

  @override
  String n_per_row(Object n) {
    return '$n pro Zeile';
  }

  @override
  String get horizontal_continious => 'Horizontal kontinuierlich';

  @override
  String get edit_code => 'Code bearbeiten';

  @override
  String get use_libass => 'Libass aktivieren';

  @override
  String get use_libass_info =>
      'Libass-basierte Untertitel-Wiedergabe für natives Backend verwenden.';

  @override
  String get libass_not_disable_message =>
      'Deaktiviere \"Libass aktivieren\" in den Playereinstellungen, um die Untertitel anpassen zu können.';

  @override
  String get override_ass_subtitles => 'ASS-Untertitel überschreiben';

  @override
  String get override_ass_subtitles_info =>
      'Benutzerdefinierten Stil auf ASS/SSA-Untertitel anwenden';

  @override
  String get torrent_stream => 'Torrent-Stream';

  @override
  String get add_torrent => 'Torrent hinzufügen';

  @override
  String get enter_torrent_hint_text =>
      'Magnet- oder Torrent-Datei-URL eingeben';

  @override
  String get torrent_url => 'Torrent-URL';

  @override
  String get or => 'ODER';

  @override
  String get advanced => 'Erweitert';

  @override
  String get advanced_info => 'mpv-Konfiguration';

  @override
  String get use_native_http_client => 'Nativen HTTP-Client verwenden';

  @override
  String get use_native_http_client_info =>
      'Unterstützt automatisch Plattformfunktionen wie VPNs, unterstützt mehr HTTP-Funktionen wie HTTP/3 und benutzerdefinierte Umleitungshandhabung.';

  @override
  String n_hour_ago(Object hour) {
    return 'Vor $hour Stunde';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'Vor $hours Stunden';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'Vor $minute Minute';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'Vor $minutes Minuten';
  }

  @override
  String n_day_ago(Object day) {
    return 'Vor $day Tag';
  }

  @override
  String get now => 'jetzt';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Bibliothek zuletzt am $lastUpdated aktualisiert.';
  }

  @override
  String get data_and_storage => 'Daten und Speicher';

  @override
  String get download_location_info => 'Wird für Kapitel-Downloads verwendet';

  @override
  String get storage => 'Speicher';

  @override
  String get clear_chapter_and_episode_cache =>
      'Kapitel- und Episoden-Cache löschen';

  @override
  String get cache_cleared => 'Cache gelöscht';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Kapitel-/Episoden-Cache beim Start der App löschen';

  @override
  String get app_settings => 'App-Einstellungen';

  @override
  String get sources_settings => 'Quellen-Einstellungen';

  @override
  String get include_sensitive_settings =>
      'Sensible Einstellungen einbeziehen (z. B. Tracker-Login-Tokens)';

  @override
  String get create => 'Erstellen';

  @override
  String get downloads_are_limited_to_wifi =>
      'Downloads sind nur über WLAN verfügbar';

  @override
  String get recommendations => 'Empfehlungen';

  @override
  String get recommendations_similar => 'ähnlich';

  @override
  String get recommendations_weights => 'Empfehlungsgewichte';

  @override
  String get recommendations_weights_genre => 'Genre-Ähnlichkeit';

  @override
  String get recommendations_weights_setting => 'Setting-Ähnlichkeit';

  @override
  String get recommendations_weights_synopsis => 'Geschichten-Ähnlichkeit';

  @override
  String get recommendations_weights_theme => 'Themen-Ähnlichkeit';

  @override
  String get manga_extensions_repo => 'Manga-Erweiterungs-Repository';

  @override
  String get anime_extensions_repo => 'Anime-Erweiterungs-Repository';

  @override
  String get novel_extensions_repo => 'Roman-Erweiterungs-Repository';

  @override
  String get custom_dns =>
      'Benutzerdefiniertes DNS (leer lassen, um System-DNS zu verwenden)';

  @override
  String get android_proxy_server =>
      'Android Proxy Server (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'M-Extension-Server herunterladen';

  @override
  String get undefined => 'Nicht definiert';

  @override
  String get empty_extensions_repo =>
      'Du hast derzeit keinen Repository-Link hier. Klicke auf das Plus-Symbol, um einen hinzuzufügen!';

  @override
  String get add_extensions_repo => 'Repository-Link hinzufügen';

  @override
  String get remove_extensions_repo => 'Repository-Link entfernen';

  @override
  String get manage_manga_repo_urls => 'Manga-Repository-URLs verwalten';

  @override
  String get manage_anime_repo_urls => 'Anime-Repository-URLs verwalten';

  @override
  String get manage_novel_repo_urls => 'Roman-Repository-URLs verwalten';

  @override
  String get url_cannot_be_empty => 'URL darf nicht leer sein';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL muss mit .json / .pb enden';

  @override
  String get repo_url => 'Repository-URL';

  @override
  String get invalid_url_format => 'Ungültiges URL-Format';

  @override
  String get clear_all_sources => 'Alle Quellen löschen';

  @override
  String get clear_all_sources_msg =>
      'Dies wird alle Quellen der Anwendung vollständig löschen. Möchten Sie wirklich fortfahren?';

  @override
  String get sources_cleared => 'Quellen gelöscht!';

  @override
  String get repo_added => 'Erweiterungs-Repository hinzugefügt!';

  @override
  String get repo_already_exists => 'Repository existiert bereits!';

  @override
  String get add_repo => 'Repository hinzufügen?';

  @override
  String get add_repo_sources_to_add =>
      'Erweiterungslisten, die hinzugefügt werden:';

  @override
  String get add_repo_warning =>
      'Erweiterungen aus diesen Repositories werden innerhalb der App ausgeführt. Fügen Sie nur Repositorys hinzu, denen Sie vertrauen.';

  @override
  String get genre_search_library => 'Genre im Bibliothek suchen';

  @override
  String get genre_search_source => 'Zur Erweiterung navigieren';

  @override
  String get source_not_added => 'Die Erweiterung ist nicht installiert!';

  @override
  String get load_own_subtitles => 'Deine eigene Untertiteln laden...';

  @override
  String get search_subtitles => 'Untertitel online suchen...';

  @override
  String extension_notes(Object notes) {
    return 'Hinweis: $notes';
  }

  @override
  String get unsupported_repo =>
      'Dieses Quellen-Repository konnte nicht hinzugefügt werden. Prüfe die Adresse oder kontaktiere die Person, die das Repository betreut.';

  @override
  String get you_have_finished_reading => 'Du hast es fertig gelesen';

  @override
  String get hwdec => 'Hardware Decoder';

  @override
  String get enable_hardware_accel => 'Hardware-Beschleunigung';

  @override
  String get enable_hardware_accel_info =>
      'Aktivieren/Deaktivieren, wenn Bugs oder Abstürze auftreten';

  @override
  String get track_library_navigate => 'Zum vorhandenen lokalen Eintrag gehen';

  @override
  String get track_library_add => 'Zur lokalen Bibliothek hinzufügen';

  @override
  String get track_library_add_confirm =>
      'Eintrag zur lokalen Bibliothek hinzufügen';

  @override
  String get track_library_not_logged =>
      'Du musst dich zuerst beim entsprechenden Tracker anmelden, bevor du diese Funktion nutzen kannst!';

  @override
  String get track_library_switch => 'Zu einen anderen Tracker wechseln';

  @override
  String get go_back => 'Zurück';

  @override
  String get merge_library_nav_mobile =>
      'Bibliotheksnavigation auf Mobilgeräten zusammenführen';

  @override
  String get enable_discord_rpc => 'Discord RPC aktivieren';

  @override
  String get hide_discord_rpc_incognito =>
      'Discord RPC im Inkognito-Modus ausblenden';

  @override
  String get rpc_show_reading_watching_progress =>
      'Aktuelles Kapitel in Discord anzeigen (erfordert Neustart)';

  @override
  String get rpc_show_title => 'Aktuellen Titel in Discord anzeigen';

  @override
  String get rpc_show_cover_image => 'Aktuelles Cover-Bild in Discord anzeigen';

  @override
  String get enable_mpv => 'mpv Shader / Skripte aktivieren';

  @override
  String get mpv_info => 'Unterstützt .js-Skripte unter mpv/scripts/';

  @override
  String get mpv_redownload => 'mpv-Konfigurationsdateien erneut herunterladen';

  @override
  String get mpv_redownload_info =>
      'Ersetzt alte Konfigurationsdateien durch neue!';

  @override
  String get mpv_download =>
      'MPV-Konfigurationsdateien sind erforderlich!\nJetzt herunterladen?';

  @override
  String get custom_buttons => 'Benutzerdefinierte Schaltflächen';

  @override
  String get custom_buttons_info =>
      'Lua-Code mit benutzerdefinierten Schaltflächen ausführen';

  @override
  String get custom_buttons_edit =>
      'Benutzerdefinierte Schaltflächen bearbeiten';

  @override
  String get custom_buttons_add => 'Benutzerdefinierte Schaltfläche hinzufügen';

  @override
  String get custom_buttons_added =>
      'Benutzerdefinierte Schaltfläche hinzugefügt!';

  @override
  String get custom_buttons_delete => 'Benutzerdefinierte Schaltfläche löschen';

  @override
  String get custom_buttons_text => 'Schaltflächentext';

  @override
  String get custom_buttons_text_req => 'Schaltflächentext erforderlich';

  @override
  String get custom_buttons_js_code => 'Lua-Code';

  @override
  String get custom_buttons_js_code_req => 'Lua-Code erforderlich';

  @override
  String get custom_buttons_js_code_long => 'Lua-Code (bei langem Drücken)';

  @override
  String get custom_buttons_startup => 'Lua-Code (beim Start)';

  @override
  String get custom_buttons_add_warning =>
      'Diese Schaltfläche führt den folgenden Code Lua im Videoplayer aus, der auf Ihre Dateien zugreifen und Programme ausführen kann. Fügen Sie es nur hinzu, wenn Sie der Herkunft dieses Links vertrauen.';

  @override
  String n_days(Object n) {
    return '$n Tage';
  }

  @override
  String get decoder => 'Decoder';

  @override
  String get decoder_info => 'Hardware-Dekodierung, Pixelformat, Debanding';

  @override
  String get enable_gpu_next => 'gpu-next aktivieren (nur Android)';

  @override
  String get enable_gpu_next_info => 'Eine neue Video-Rendering-Engine';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'YUV420P-Pixelformat verwenden';

  @override
  String get use_yuv420p_info =>
      'Kann schwarze Bildschirme bei einigen Video-Codecs beheben, kann auch die Leistung auf Kosten der Qualität verbessern';

  @override
  String get audio_preferred_languages => 'Bevorzugte Sprachen';

  @override
  String get audio_preferred_languages_info =>
      'Audiosprache(n), die standardmäßig bei einem Video mit mehreren Audiostreams ausgewählt werden, 2/3-Buchstaben-Sprachcodes (z.B.: de, en, fr). Mehrere Werte können durch Komma getrennt werden.';

  @override
  String get enable_audio_pitch_correction =>
      'Audio-Tonhöhenkorrektur aktivieren';

  @override
  String get enable_audio_pitch_correction_info =>
      'Verhindert, dass der Ton bei höheren Geschwindigkeiten hoch und bei niedrigeren Geschwindigkeiten tief wird';

  @override
  String get audio_channels => 'Audiokanäle';

  @override
  String get volume_boost_cap => 'Lautstärkeverstärkungsgrenze';

  @override
  String get internal_player => 'Interner Player';

  @override
  String get internal_player_info => 'Fortschritt, Steuerung, Ausrichtung';

  @override
  String get subtitle_delay_text => 'Untertitelverzögerung';

  @override
  String get subtitle_delay => 'Verzögerung (ms)';

  @override
  String get subtitle_speed => 'Geschwindigkeit';

  @override
  String get tracks => 'Spuren';

  @override
  String get playback_speed => 'Wiedergabegeschwindigkeit';

  @override
  String get shaders => 'Shader';

  @override
  String get video_fit => 'Anpassen';

  @override
  String get calendar => 'Kalender';

  @override
  String get calendar_no_data => 'Noch keine Daten.';

  @override
  String get calendar_info =>
      'Der Kalender kann das nächste Kapitel-Upload nur auf Basis der älteren Uploads vorhersagen. Einige Daten sind möglicherweise nicht zu 100% genau!';

  @override
  String in_n_day(Object days) {
    return 'in $days Tag';
  }

  @override
  String in_n_days(Object days) {
    return 'in $days Tagen';
  }

  @override
  String get clear_library => 'Bibliothek leeren';

  @override
  String get clear_library_desc =>
      'Wähle, ob alle Manga-, Anime- und/oder Novel-Einträge gelöscht werden sollen';

  @override
  String get clear_library_input =>
      'Gib \'manga\', \'anime\' und/oder \'novel\' ein (durch Komma getrennt), um alle zugehörigen Einträge zu entfernen';

  @override
  String get watch_order => 'Anzeigereihenfolge';

  @override
  String get watch_order_role_current => 'Aktuell';

  @override
  String get watch_order_role_previous => 'Zurück';

  @override
  String get watch_order_role_next => 'Als nächstes';

  @override
  String get watch_order_source_release_order => 'Freigabebefehl';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name von $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Offizielle Trakt-Kollektion: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt Sammlung: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Jahreszeiten für $title';
  }

  @override
  String get watch_order_select_source => 'Bestellquelle';

  @override
  String watch_order_season(int number) {
    return 'Staffel $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Folge $number';
  }

  @override
  String get sequels => 'Fortsetzungen';

  @override
  String get recommendations_similarity => 'Ähnlichkeit:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Bewertung $rating';
  }

  @override
  String get local_folder_structure => 'Struktur eines lokalen Ordners';

  @override
  String get local_folder => 'Lokale Ordner';

  @override
  String get add_local_folder => 'Lokalen Ordner hinzufügen';

  @override
  String get rescan_local_folder => 'Alle lokalen Ordner jetzt neu scannen';

  @override
  String get default_download_destination => 'Standard-Download-Ziel';

  @override
  String get ask_download_destination => 'Nach Download-Ziel fragen';

  @override
  String get ask_download_destination_desc =>
      'Bei jedem Download nach einem lokalen Ordner fragen.';

  @override
  String get select_download_destination => 'Download-Ziel auswählen';

  @override
  String get clear_local_library => 'Lokale Bibliothek leeren';

  @override
  String get clear_local_library_desc =>
      'Lokale Ordner- und Archiveinträge aus der Bibliothek entfernen.';

  @override
  String get clear_local_library_msg =>
      'Dadurch werden lokale Ordner- und Archiveinträge aus der Bibliothek entfernt. Dateien auf dem Speicher werden nicht gelöscht.';

  @override
  String get custom => 'Benutzerdefiniert';

  @override
  String get no_local_folder_available_for_downloads =>
      'Kein lokaler Ordner für Downloads verfügbar';

  @override
  String failed_to_create_cbz(Object error) {
    return 'CBZ konnte nicht erstellt werden: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Fehler beim Lesen des Titelbilds: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Fehler beim Lesen der Metadaten: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Fehler beim Speichern in der Bibliothek: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Fehler beim Lesen des Kapitel-Covers: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Fehler beim Lesen des Archiv-Covers: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Fehler beim Laden der lokalen Bibliothek: $error';
  }

  @override
  String get export_metadata => 'Metadaten exportieren';

  @override
  String get exported => 'Exportiert';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Fehler beim Exportieren der Metadaten: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count Kapitel konnten nicht nummeriert werden und fehlen möglicherweise im Reader.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Cloudflare Resolution Webview Server konnte nicht gestartet werden.';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker-Token abgelaufen';
  }

  @override
  String get video_list_empty => 'Videoliste ist leer';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return '$url konnte nicht geöffnet werden';
  }

  @override
  String get text_size => 'Textgröße:';

  @override
  String get text_align => 'Textausrichtung';

  @override
  String get line_height => 'Zeilenhöhe';

  @override
  String get show_scroll_percentage => 'Scroll-Prozentsatz anzeigen';

  @override
  String get remove_extra_paragraph_spacing =>
      'Zusätzlichen Absatzabstand entfernen';

  @override
  String select_label_color(Object label) {
    return 'Farbe für $label auswählen';
  }

  @override
  String get default_user_agent => 'Standardbenutzer-Agent';

  @override
  String get forceLandscapeMode => 'Landschaftsmodus erzwingen';

  @override
  String get forceLandscapeModeSubtitle =>
      'Erzwingt, dass der Player die Landschaftsorientierung verwendet.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNS-Anbieter';

  @override
  String get tracked => 'Verfolgt';

  @override
  String get auth_unlock_msg =>
      'Authentifizieren Sie sich, um NodeLane Comics freizuschalten';

  @override
  String get app_locked => 'NodeLane Comics ist gesperrt';

  @override
  String get auth_to_continue => 'Authentifizieren Sie sich, um fortzufahren';

  @override
  String get authenticating => 'Authentifizierung läuft...';

  @override
  String get lock => 'Sperren';

  @override
  String get unlock => 'Entsperren';

  @override
  String get security => 'Sicherheit';

  @override
  String get auth_to_change_security_setting =>
      'Authentifizieren Sie sich, um die Sicherheitseinstellungen zu ändern';

  @override
  String get app_lock => 'App-Sperre';

  @override
  String get require_biometric_or_device_credential =>
      'Biometrische Authentifizierung oder Geräteanmeldedaten erforderlich, um die App zu öffnen';

  @override
  String get biometric_or_device_credential_not_available =>
      'Biometrische Authentifizierung auf diesem Gerät nicht verfügbar';

  @override
  String get app_lock_description =>
      'Wenn die App-Sperre aktiviert ist, werden Sie aufgefordert, sich zu authentifizieren\njedes Mal, wenn Sie die App öffnen oder von der Hintergrund zurückkehren.';

  @override
  String get checking_device_authentication =>
      'Überprüfung der Geräteauthentifizierung…';

  @override
  String get device_authentication_incomplete =>
      'Die Authentifizierung wurde nicht abgeschlossen. Ihre Einstellung hat sich nicht geändert.';

  @override
  String get keep_screen_on => 'Bildschirm bleibt an';

  @override
  String get webtoon_side_padding => 'Webtoon-Seitenabstand';

  @override
  String get show_page_gaps => 'Seitenlücken anzeigen';

  @override
  String get invert_colors => 'Farben invertieren';

  @override
  String get grayscale => 'Graustufen';

  @override
  String get brightness => 'Helligkeit';

  @override
  String get contrast => 'Kontrast';

  @override
  String get saturation => 'Sättigung';

  @override
  String get navigation_layout => 'Navigations-Layout';

  @override
  String get nav_layout_default => 'Standard';

  @override
  String get nav_layout_l_shaped => 'L-förmig';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Kante';

  @override
  String get nav_layout_right_and_left => 'Rechts und Links';

  @override
  String get nav_layout_disabled => 'Deaktiviert';

  @override
  String get color_enhancements => 'Farbverbesserungen';

  @override
  String get total => 'Gesamt';

  @override
  String get mean_per_title => 'Mittelwert pro Titel';

  @override
  String get completion_rate => 'Abschlussrate';

  @override
  String get watching_time => 'Gesamtzeit (Video)';

  @override
  String get reading_time => 'Gesamtzeit (Manga)';

  @override
  String average_chapters_per_title(Object title) {
    return 'Durchschnittliche Kapitel pro $title';
  }

  @override
  String get read_percentage => 'Gelesen (Prozent)';

  @override
  String get entries => 'Einträge';

  @override
  String get android_proxy_server_mihon => 'Android Proxy Server (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Laden Sie den für die Nutzung von Mihon-Erweiterungen erforderlichen Proxy-Server herunter und konfigurieren Sie ihn.';

  @override
  String get mihon_proxy_server => 'Mihon Proxy Server';

  @override
  String get extension_server_intro_with_jre =>
      'Laden Sie das Proxy-Server-Bundle herunter, bevor Sie Mihon-Erweiterungen verwenden. Das Bundle enthält das JRE und die Extension Server JAR.';

  @override
  String get extension_server_intro_ios =>
      'Laden Sie die Proxy-Server-JAR herunter, bevor Sie Mihon-Erweiterungen verwenden. iOS benötigt nur die Extension Server JAR.';

  @override
  String get checking_files => 'Dateien werden geprüft';

  @override
  String get files_installed => 'Dateien installiert';

  @override
  String get files_missing => 'Dateien fehlen';

  @override
  String get update_files => 'Dateien aktualisieren';

  @override
  String get up_to_date => 'Aktuell';

  @override
  String get choose_location => 'Speicherort wählen';

  @override
  String get import_existing_jar => 'Vorhandene JAR importieren';

  @override
  String get detect_files_in_selected_folder =>
      'Dateien im gewählten Ordner suchen';

  @override
  String get preparing_download => 'Download wird vorbereitet...';

  @override
  String get app_install_location => 'Installationsort der App';

  @override
  String get install_location => 'Installationsort';

  @override
  String get jre_executable => 'JRE-Programmdatei';

  @override
  String get extension_server_jar => 'Extension Server JAR';

  @override
  String get installed_version => 'Installierte Version';

  @override
  String get latest_version => 'Neueste Version';

  @override
  String get m_extension_server_description =>
      'Verwenden Sie M-Extension-Server, wenn Sie einen separaten Android-Geräte-Proxy benötigen. Stellen Sie die Proxy-Adresse hier ein und laden Sie die APK von GitHub herunter.';

  @override
  String get set_proxy_address => 'Proxy-Adresse festlegen';

  @override
  String get no_newer_proxy_server_release_available =>
      'Keine neuere Proxy-Server-Version verfügbar.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Proxy-Server-Updates konnten nicht überprüft werden.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Kein Extension Server Bundle für diese Plattform verfügbar.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Bundle konnte nicht heruntergeladen werden ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Das heruntergeladene Bundle enthält nicht die erwarteten Dateien.';

  @override
  String get extension_server_files_ready =>
      'Extension Server-Dateien sind bereit.';

  @override
  String get ios_extension_server_import_hint =>
      'Auf iOS wird der Server in der Sandbox der App installiert. Verwenden Sie \"Vorhandene JAR importieren\", um eine heruntergeladene Datei zu laden.';

  @override
  String get select_extension_server_folder => 'Extension Server-Ordner wählen';

  @override
  String get selected_folder_does_not_exist =>
      'Der gewählte Ordner existiert nicht.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Keine Extension Server-Dateien im gewählten Ordner gefunden.';

  @override
  String get extension_server_files_linked =>
      'Extension Server-Dateien wurden verknüpft.';

  @override
  String get select_extension_server_jar => 'Erweiterungsserver-JAR auswählen';

  @override
  String get selected_file_could_not_be_accessed =>
      'Auf die gewählte Datei konnte nicht zugegriffen werden.';

  @override
  String get extension_server_jar_imported =>
      'Extension Server JAR wurde importiert.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'M-Extension-Server-Seite konnte nicht geöffnet werden.';

  @override
  String get proxy_server_ip_hint =>
      'Server-IP (z.B. 10.0.0.5 oder https://example.com)';

  @override
  String get not_configured => 'Nicht konfiguriert';

  @override
  String get zero_interpreter => 'Zero-Interpreter';

  @override
  String get zero_interpreter_description =>
      'Zero-Interpreter-Server automatisch oder manuell steuern.';

  @override
  String get start_server_on_launch => 'Server beim Start starten';

  @override
  String get runtime_status => 'Laufzeitstatus';

  @override
  String get running => 'Läuft';

  @override
  String get stopped => 'Angehalten';

  @override
  String get start => 'Starten';

  @override
  String get stop => 'Stoppen';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Text-to-Speech';

  @override
  String get tts_speed => 'Geschwindigkeit';

  @override
  String get tts_pitch => 'Tonhöhe';

  @override
  String get tts_language => 'Sprache';

  @override
  String get tts_voice => 'Stimme';

  @override
  String get tts_stop => 'Stopp';

  @override
  String get tts_play => 'Wiedergabe';

  @override
  String get tts_pause => 'Pause';

  @override
  String get tts_previous => 'Vorheriger Absatz';

  @override
  String get tts_next => 'Nächster Absatz';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Absatz $current von $total';
  }

  @override
  String get tts_settings => 'TTS-Einstellungen';

  @override
  String get tts_default => 'Standard';

  @override
  String get webtoon_disable_zoom_out => 'Webtoon-Herauszoomen deaktivieren';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Webtoon-Doppeltippen zum Zoomen';

  @override
  String get navigate_to_pan => 'Navigieren zum Schwenken';

  @override
  String get navigate_to_pan_subtitle =>
      'Gezoomtes Bild vor dem Umblättern verschieben';

  @override
  String get split_wide_pages => 'Doppelseiten aufteilen';

  @override
  String get dual_page_invert => 'Geschnittene Seitenhälften umkehren';

  @override
  String get dual_page_rotate_to_fit => 'Zum Einpassen drehen';

  @override
  String get dual_page_rotate_to_fit_invert => 'Drehrichtung umkehren';

  @override
  String get double_page_single_first_page => 'Erste Seite einzeln';

  @override
  String get double_page_single_first_page_subtitle =>
      'Erste Seite im Doppelseitenmodus einzeln anzeigen';

  @override
  String get double_page_auto => 'Automatische Doppelseite';

  @override
  String get double_page_auto_subtitle =>
      'Im Querformat automatisch in den Doppelseitenmodus wechseln';

  @override
  String get landscape_zoom => 'Automatischer Querformat-Zoom';

  @override
  String get zoom_start_position => 'Zoom-Startposition';

  @override
  String get zoom_start_left => 'Links';

  @override
  String get zoom_start_right => 'Rechts';

  @override
  String get zoom_start_center => 'Mitte';

  @override
  String get automatic_background => 'Automatischer Hintergrund';

  @override
  String get tapping_inversion => 'Tipp-Invertierung';

  @override
  String get tapping_inversion_none => 'Keine';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertikal';

  @override
  String get tapping_inversion_both => 'Beide';

  @override
  String get flash_on_page_change => 'Blinken bei Seitenwechsel';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED-Einbrennschutz-Assistent';

  @override
  String get flash_color => 'Blinkfarbe';

  @override
  String get flash_color_black => 'Schwarz';

  @override
  String get flash_color_white => 'Weiß';

  @override
  String get flash_color_white_black => 'Weiß & Schwarz';

  @override
  String get flash_interval_label => 'Blinkintervall';

  @override
  String flash_interval_value(String n) {
    return '$n Seiten';
  }

  @override
  String flash_interval(String n) {
    return 'Blinkintervall: $n Seiten';
  }

  @override
  String get flash_duration_label => 'Blinkdauer';

  @override
  String flash_duration_value(String n) {
    return '$n ms';
  }

  @override
  String flash_duration(String n) {
    return 'Blinkdauer: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Navigations-Overlay beim Start anzeigen';

  @override
  String get reader_hide_threshold => 'Schwellenwert zum Ausblenden des Lesers';

  @override
  String get reader_hide_threshold_highest => 'Am höchsten (5 px)';

  @override
  String get reader_hide_threshold_high => 'Hoch (13 px)';

  @override
  String get reader_hide_threshold_low => 'Niedrig (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Am niedrigsten (47 px)';

  @override
  String get error_no_pages_available => 'Fehler: Keine Seiten verfügbar';

  @override
  String get app_ui_scale => 'Schnittstellenskalierung';

  @override
  String get app_ui_scale_subtitle =>
      'Passen Sie die Schnittstelle Ihrer Bildschirmgröße und Betrachtungsentfernung an.';

  @override
  String get allow_concurrent_downloads => 'Gleichzeitige Downloads erlauben';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Laden Sie gleichzeitig von verschiedenen Quellen herunter. Eine einzelne Quelle lädt immer noch ein Kapitel auf einmal herunter, um nicht überfordert zu werden. Deaktivieren Sie diese Option, um überall einzeln herunterzuladen.';

  @override
  String get download_delay => 'Download-Verzögerung';

  @override
  String get download_delay_subtitle =>
      'Aus. Fügen Sie zwischen den Kapiteln eine Wartezeit mit zufälliger Jitter hinzu, um Quellen sanfter zu behandeln.';

  @override
  String get save_search => 'Suche speichern';

  @override
  String get saved_searches => 'Gespeicherte Suchen';

  @override
  String get enter_search_to_save_first =>
      'Geben Sie zuerst eine Suche ein, um sie zu speichern';

  @override
  String get no_saved_searches =>
      'Für diese Quelle gibt es noch keine gespeicherten Suchen.\nFühren Sie eine Suche durch und wählen Sie dann \"Suche speichern\".';

  @override
  String get source => 'Quelle';

  @override
  String get something_went_wrong => 'Etwas ist schiefgelaufen';

  @override
  String get startup_failed => 'NodeLane Comics konnte nicht gestartet werden';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen ohne Ergebnisse',
      one: '1 Quelle ohne Ergebnisse',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Wie soll importiert werden?';

  @override
  String get import_mode_message =>
      'Wähle, ob das Backup in die aktuelle Bibliothek zusammengeführt oder die gesamte Bibliothek ersetzt werden soll.';

  @override
  String get import_mode_keep_existing => 'Zusammenführen';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Fügt neue Serien hinzu und aktualisiert vorhandene. Es wird nichts gelöscht.';

  @override
  String get import_mode_replace => 'Ersetzen';

  @override
  String get import_mode_replace_subtitle =>
      'Löscht die aktuelle Bibliothek und ersetzt sie durch das Backup.';

  @override
  String get replace_summary_title => 'Bereit zum Ersetzen der Bibliothek';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Dies löscht die gesamte aktuelle Bibliothek ($currentCount Serien) und ersetzt sie durch $backupCount Serien. Dies kann nur durch ein Rollback rückgängig gemacht werden.';
  }

  @override
  String get replace_summary_confirm => 'Ersetzen';

  @override
  String replace_result_message(Object count) {
    return 'Bibliothek durch $count Serien aus dem Backup ersetzt.';
  }

  @override
  String get category_conflict_title => 'Bestehende Kategorien gefunden';

  @override
  String get category_conflict_message =>
      'Das Backup enthält Kategorien, die bereits existieren. Zusammenführen oder löschen?';

  @override
  String get category_conflict_keep =>
      'Behalten – in bestehende Kategorie zusammenführen';

  @override
  String get category_conflict_delete =>
      'Löschen – Serien ohne Kategorie belassen';

  @override
  String get source_conflict_title => 'Quellen nicht gefunden';

  @override
  String get source_conflict_message =>
      'Einige Quellen stimmen mit keiner installierten Erweiterung überein.';

  @override
  String get source_conflict_keep => 'Ursprünglichen Namen behalten';

  @override
  String get import_summary_title => 'Bereit zum Importieren';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries neue Serien, $updatedSeries aktualisierte Serien und $newChapters neue Kapitel werden hinzugefügt.';
  }

  @override
  String get import_summary_confirm => 'Importieren';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries neue Serien importiert, $updatedSeries aktualisiert, $newChapters neue Kapitel hinzugefügt.';
  }

  @override
  String get roll_back => 'Zurücksetzen';

  @override
  String get roll_back_confirm_message =>
      'Stellt die Bibliothek auf den Sicherheits-Schnappschuss vor dieser Änderung zurück.';

  @override
  String get roll_back_done => 'Auf vorherigen Zustand zurückgesetzt.';

  @override
  String get restoring_backup => 'Bibliothek wird wiederhergestellt…';

  @override
  String get roll_back_last_change => 'Letzte Änderung rückgängig machen';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Schnappschuss vom $date – $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count verfügbare Änderungen zum Zurücksetzen';
  }

  @override
  String get delete_source_title => 'Quelle und deren Manga löschen';

  @override
  String get delete_source_subtitle =>
      'Entfernt alle Einträge einer Quelle samt Kapiteln, Downloads und Verlauf.';

  @override
  String get delete_source_pick_title => 'Zu löschende Quelle wählen';

  @override
  String get delete_source_empty => 'Keine Quellen in der Bibliothek gefunden.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '$sourceName löschen?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Löscht $mangaCount Manga, $chapterCount Kapitel, $historyCount Verlaufseinträge und $updateCount Updates.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Installierte Erweiterung ebenfalls entfernen';

  @override
  String get delete_source_keep_history => 'Leseverlauf behalten';

  @override
  String get delete_source_keep_downloads => 'Downloads behalten';

  @override
  String get delete_source_button => 'Löschen';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '$mangaCount Manga von $sourceName gelöscht.';
  }

  @override
  String get merge_manga_title => 'Doppelte Manga zusammenführen';

  @override
  String get merge_manga_subtitle =>
      'Findet gleiche Titel unter derselben Quelle und führt sie zusammen.';

  @override
  String get merge_manga_none_found => 'Keine doppelten Manga gefunden.';

  @override
  String get merge_manga_pick_title => 'Mögliche Duplikate';

  @override
  String get merge_manga_choose_primary_title =>
      'In welchen Eintrag soll zusammengeführt werden?';

  @override
  String get merge_manga_choose_primary_message =>
      'Kapitel, Verlauf und Tracking werden in den gewählten Eintrag übernommen.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel',
      one: '1 Kapitel',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Zusammenführen';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '$count Duplikate in $mangaName zusammengeführt.';
  }

  @override
  String get merge_preview_title => 'Zusammenführung bestätigen';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters Kapitel, die in den anderen Einträgen gefunden wurden. $duplicateChapters sind Duplikate und werden gelöscht (die Kopie mit Lesefortschritt bleibt erhalten); $keptChapters wird hinzugefügt. $duplicateTracks doppelte Tracking-Links werden ebenfalls entfernt.';
  }

  @override
  String get memory_overlay => 'Speichernutzung anzeigen';

  @override
  String get memory_overlay_subtitle =>
      'Live-Anzeige der Speicherauslastung der App. Zum Messen auf dem Gerät: beobachten Sie die Anzeige beim Scrollen in der Bibliothek oder Lesen eines Kapitels.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Fehlerberichte';

  @override
  String get error_reports_subtitle =>
      'Aufgetretene Fehler und Möglichkeit zur Meldung';

  @override
  String get error_reports_empty => 'Keine Fehler aufgetreten.';

  @override
  String get error_reports_likely_cause => 'Wahrscheinliche Ursache';

  @override
  String get error_reports_report => 'Auf GitHub melden';

  @override
  String get error_reports_banner =>
      'NodeLane Comics hat einen Fehler festgestellt';

  @override
  String get error_reports_banner_action => 'Anzeigen';

  @override
  String get error_reports_copy => 'Kopieren';

  @override
  String get error_reports_copied => 'In die Zwischenablage kopiert';

  @override
  String get error_reports_clear => 'Löschen';

  @override
  String get error_reports_extension_failure =>
      'Dies wurde durch eine Erweiterung verursacht, nicht durch NodeLane Comics. Erweiterungen werden von den Betreibern des Repositories gewartet, aus dem diese Quelle installiert wurde. Der Quellenname und die geöffnete Seite sind hilfreiche Details für einen Fehlerbericht.';

  @override
  String get error_reports_already_reported => 'Bereits gemeldet';

  @override
  String get error_reports_expected_failure =>
      'Dies liegt normalerweise an der Quelle oder am Netzwerk und nicht an der App: ein abgelaufener Link, ein Serverausfall oder ein Verbindungsabbruch. Sollte nur gemeldet werden, wenn es bei einer ansonsten funktionierenden Quelle dauerhaft auftritt.';

  @override
  String get share_unavailable_copied =>
      'Teilen nicht verfügbar, in Zwischenablage kopiert.';

  @override
  String get onboarding_title => 'Willkommen bei NodeLane Comics';

  @override
  String get onboarding_libraries_body =>
      'Wähle aus, was du lesen und ansehen möchtest.';

  @override
  String get onboarding_nav_title => 'Deine Bibliotheken';

  @override
  String get onboarding_nav_body =>
      'Eigener Tab für jede Bibliothek oder alle unter einem Bibliothek-Tab bündeln.';

  @override
  String get onboarding_nav_split => 'Getrennte Tabs';

  @override
  String get onboarding_nav_merged => 'Ein Bibliothek-Tab';

  @override
  String get onboarding_nav_inside =>
      'Tippen auf Bibliothek wechselt die Leiste';

  @override
  String get onboarding_next => 'Weiter';

  @override
  String get onboarding_restore => 'Backup wiederherstellen';

  @override
  String get onboarding_or_local => 'Oder vorhandene Dateien nutzen';

  @override
  String get onboarding_local_folder => 'Ordner hinzufügen';

  @override
  String onboarding_local_existing(Object count) {
    return '$count Ordner bereits eingerichtet';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, Anime und Novels werden unterstützt.';

  @override
  String get onboarding_local_scanning => 'Ordner wird durchsucht';

  @override
  String onboarding_local_found(Object count) {
    return '$count Titel gefunden';
  }

  @override
  String get onboarding_local_remove => 'Ordner entfernen';

  @override
  String get onboarding_local_in_downloads =>
      'Dies ist der Download-Ordner der App.';

  @override
  String get onboarding_local_empty =>
      'Nichts gefunden. Wähle den übergeordneten Ordner.';

  @override
  String get onboarding_repo_failed =>
      'Repository konnte nicht geladen werden.';

  @override
  String get onboarding_repo_title => 'Quelle hinzufügen';

  @override
  String get onboarding_body =>
      'Füge ein Repository hinzu, um Erweiterungen zu installieren.';

  @override
  String get onboarding_add => 'Repository hinzufügen';

  @override
  String get onboarding_skip => 'Jetzt überspringen';

  @override
  String get onboarding_continue => 'Fortfahren';

  @override
  String get onboarding_later =>
      'Kann später unter Einstellungen > Durchsuchen hinzugefügt werden.';

  @override
  String get onboarding_replay => 'Willkommensbildschirm anzeigen';

  @override
  String get onboarding_replay_subtitle =>
      'Öffnet den Einrichtungsbildschirm erneut.';

  @override
  String get missing_source_check_title => 'Auf fehlende Quellen prüfen';

  @override
  String get missing_source_check_subtitle =>
      'Findet Einträge, deren Erweiterung nicht installiert ist.';

  @override
  String get missing_source_check_none_found =>
      'Alle Quellen der Bibliothek sind installiert.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen fehlen',
      one: '1 Quelle fehlt',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Keine $itemType-Quellen installiert.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Fügen Sie unter Durchsuchen ein Repository hinzu und installieren Sie eine Erweiterung dafür.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen',
      one: '1 Quelle',
    );
    return 'Sie haben $_temp0 hierfür, aber es werden nur angepinnte Quellen durchsucht.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Pinnen Sie eine Quelle an oder deaktivieren Sie \"Nur angepinnte Quellen einbeziehen\" in den Durchsuchen-Einstellungen.';

  @override
  String get global_search_all_nsfw =>
      'Alle Ihre Quellen hierfür sind als NSFW markiert und ausgeblendet.';

  @override
  String get global_search_all_nsfw_hint =>
      'Aktivieren Sie NSFW-Quellen in den Durchsuchen-Einstellungen, um sie zu durchsuchen.';

  @override
  String get missing_source_check_result_message =>
      'Diese Einträge verweisen auf nicht installierte Quellen. Tippe auf einen Eintrag zur Migration oder installiere die Erweiterung.';

  @override
  String get related_titles => 'Verwandt';

  @override
  String get related_none =>
      'Keine verwandten Titel für diesen Eintrag gefunden.';

  @override
  String get relation_adaptation => 'Adaption';

  @override
  String get relation_sequel => 'Fortsetzung';

  @override
  String get relation_prequel => 'Prequel';

  @override
  String get relation_parent => 'Hauptgeschichte';

  @override
  String get relation_side_story => 'Nebengeschichte';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Alternative Version';

  @override
  String get auto_library_update => 'Automatische Bibliotheksaktualisierungen';

  @override
  String get auto_library_update_subtitle =>
      'Beim Starten der App jeden Eintrag in Ihrer Bibliothek auf neue Kapitel überprüfen.';

  @override
  String get auto_library_update_never => 'Nie';

  @override
  String get auto_library_update_12_hours => 'Alle 12 Stunden';

  @override
  String get auto_library_update_daily => 'Täglich';

  @override
  String get auto_library_update_2_days => 'Alle 2 Tage';

  @override
  String get auto_library_update_weekly => 'Wöchentlich';

  @override
  String get auto_library_update_wifi_only => 'Nur über WLAN';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Geplante Aktualisierung bei mobiler Datenverbindung überspringen.';

  @override
  String get padding => 'Abstand';

  @override
  String get page_mode => 'Seitenmodus';

  @override
  String get single_page => 'Einzelseite';

  @override
  String get double_page => 'Doppelseite';

  @override
  String get speed => 'Geschwindigkeit';

  @override
  String get theme_dark => 'Dunkel';

  @override
  String get theme_light => 'Hell';

  @override
  String get theme_black => 'Schwarz';

  @override
  String get theme_sepia => 'Sepia';

  @override
  String get decrease => 'Verringern';

  @override
  String get increase => 'Erhöhen';

  @override
  String get chapter_swipe_actions => 'Wischaktionen für Kapitel';

  @override
  String get chapter_swipe_start => 'Nach rechts wischen';

  @override
  String get chapter_swipe_end => 'Nach links wischen';

  @override
  String get chapter_swipe_toggle_bookmark => 'Lesezeichen umschalten';

  @override
  String get chapter_swipe_toggle_read => 'Gelesen/Ungelesen umschalten';

  @override
  String get chapter_swipe_download => 'Herunterladen';

  @override
  String get chapter_swipe_disabled => 'Deaktiviert';

  @override
  String get update_errors => 'Update-Fehler';

  @override
  String get no_update_errors => 'Keine Update-Fehler';

  @override
  String get clear_all => 'Alles löschen';

  @override
  String get dismiss => 'Ablehnen';

  @override
  String get previous_episode => 'Vorherige Folge';

  @override
  String get clear_logs => 'Protokolle löschen';

  @override
  String get bold => 'Fett';

  @override
  String get italic => 'Kursiv';

  @override
  String get color_yellow => 'Gelb';

  @override
  String get color_cyan => 'Cyan';

  @override
  String get color_green => 'Grün';

  @override
  String get color_orange => 'Orange';

  @override
  String get continue_watching => 'Weiter ansehen';

  @override
  String get search_your_anime => 'Suchen Sie Ihren Anime';

  @override
  String get category => 'Kategorie';

  @override
  String get hidden_categories => 'Versteckte Kategorien';

  @override
  String get new_category => 'Neue Kategorie';

  @override
  String get local => 'Lokal';

  @override
  String get tv_home_rows => 'Reihen';

  @override
  String get genre_rows => 'Genrereihen';

  @override
  String get share_backup_file => 'NodeLane Comics-Sicherungsdatei freigeben';

  @override
  String get close => 'Schließen';

  @override
  String get migrate_source => 'Quelle migrieren';

  @override
  String get cloudflare_bypass_proxy => 'Cloudflare-Bypass-Proxy';

  @override
  String get custom_doh_url => 'Benutzerdefinierte DoH URL';

  @override
  String get custom_doh_url_helper => 'Muss ein https-DoH-Endpunkt (JSON) sein';

  @override
  String get anime_only_tv_layout => 'Nur-Anime-TV-Layout';

  @override
  String get anime_only_beta => 'Nur Anime (Beta)';

  @override
  String get tv_home_beta => 'TV-Heim (Beta)';

  @override
  String get tv_player_beta => 'TV-Player (Beta)';

  @override
  String get network_settings => 'Netzwerk';

  @override
  String get reader_page_layout => 'Seitenlayout';

  @override
  String get reader_continuous_options => 'Kontinuierliches Lesen';

  @override
  String get reader_default_mode_hint =>
      'Der Standard-Lesemodus gilt für Titel, für die beim Lesen kein individueller Modus festgelegt wurde.';

  @override
  String get extension_service => 'Erweiterungsdienst';

  @override
  String get extension_service_description =>
      'Verwalten Sie die Erweiterungslaufzeit und die Proxy-Adresse.';

  @override
  String get proxy_address => 'Proxy-Adresse';

  @override
  String get checking_runtime_status => 'Status prüfen…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + zufällige Verzögerung';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel',
      one: '1 Kapitel',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Downloads aus der Kapitelliste eines Titels hinzufügen.';

  @override
  String get download_queue_order_hint =>
      'Ziehen Sie die Griffe, um sie neu anzuordnen';

  @override
  String get download_queue_empty => 'Keine Downloads in der Warteschlange';

  @override
  String get download_queue_actions => 'Download-Aktionen';

  @override
  String get download_queue_cancel_chapter =>
      'Brechen Sie den Download dieses Kapitels ab';

  @override
  String get download_queue_cancel_series =>
      'Alle Downloads für diesen Titel abbrechen';

  @override
  String get download_queue_start => 'Downloads starten';

  @override
  String get download_queue_retry => 'Wiederholen Sie die Downloads';

  @override
  String get download_queue_active => 'Herunterladen';

  @override
  String get download_queue_waiting => 'Warten auf Download';

  @override
  String get download_queue_failed => 'Download fehlgeschlagen';

  @override
  String get cf_proxy_helper =>
      'FlareSolverr/Byparr-Endpunkt. Zum Deaktivieren leer lassen.';

  @override
  String get mobile_navigation_description =>
      'Zum Neuordnen ziehen. Manga, Anime und Romane teilen sich die Registerkarte „Bibliothek“. Das erste sichtbare Element wird beim Start geöffnet. Durchsuchen und mehr bleiben sichtbar; Unter „Mehr“ werden zusätzliche Registerkarten angezeigt.';

  @override
  String get text_align_justify => 'Begründen';

  @override
  String get novel_session_modes_hint =>
      'Legen Sie beim Lesen eines Titels den Lesemodus und Einzel- oder Doppelseiten fest.';

  @override
  String get tts_languages_failed =>
      'Sprachen konnten nicht von der Sprach-Engine geladen werden.';

  @override
  String get tts_languages_empty =>
      'Die Sprachmaschine hat keine Sprachen zurückgegeben. Ihre gespeicherte Auswahl bleibt erhalten.';

  @override
  String get tts_language_unavailable =>
      'Diese gespeicherte Sprache ist nicht in der aktuellen Liste des Geräts.';

  @override
  String get tts_apply_failed =>
      'Diese Einstellung konnte nicht auf die Sprach-Engine angewendet werden. Sie können es erneut versuchen.';

  @override
  String get player_controls => 'Kontrollen';

  @override
  String get audio_channel_auto => 'Automatisch';

  @override
  String get audio_channel_auto_safe => 'Automatisch (sicher)';

  @override
  String get audio_channel_mono => 'Mono';

  @override
  String get audio_channel_stereo => 'Stereo';

  @override
  String get audio_channel_reverse_stereo => 'Reverse-Stereo';

  @override
  String get mpv_bundled_config_hint =>
      'Stellen Sie die in der App enthaltene Konfiguration, Skripte und Shader wieder her. Dateien mit demselben Namen werden überschrieben.';

  @override
  String get mpv_restore_bundled => 'Gebündelte Konfiguration wiederherstellen';

  @override
  String get mpv_restore_confirm =>
      'Die gebündelte MPV-Konfiguration wiederherstellen? Vorhandene Konfigurationen, Skripte und Shader mit demselben Namen werden überschrieben. Andere Dateien bleiben erhalten.';

  @override
  String get player_operation_incomplete =>
      'Der Vorgang konnte nicht abgeschlossen werden. Überprüfen Sie den Dateizugriff und versuchen Sie es erneut.';

  @override
  String get custom_buttons_empty_hint =>
      'Fügen Sie eine Player-Schaltfläche mit einer Beschriftung und einer Druckaktion hinzu.';

  @override
  String get custom_button_primary => 'Standardschaltfläche';

  @override
  String get show_password => 'Passwort anzeigen';

  @override
  String get hide_password => 'Passwort verbergen';

  @override
  String get tracking_accounts_empty =>
      'Verbinden Sie einen Dienst in den Tracking-Einstellungen, um seine Einträge zu verwalten.';

  @override
  String get tracking_entries_empty =>
      'Keine verfolgten Einträge für diesen Medientyp. Fügen Sie Tracking über die Detailseite eines Titels hinzu.';

  @override
  String get change_tracking_match => 'Passenden Titel ändern';

  @override
  String get remove_tracking => 'Tracking entfernen';

  @override
  String remove_tracking_confirm(String title) {
    return 'Den Tracking-Link für „$title“ entfernen? Der Eintrag im Trackingdienst bleibt erhalten.';
  }

  @override
  String get tracking_refresh_required =>
      'Der Tracking-Status konnte nicht bestätigt werden. Aktualisieren Sie, bevor Sie eine weitere Änderung vornehmen.';

  @override
  String get tracking_entry_unlinked =>
      'Dieser Datensatz ist nicht mit einem lokalen Titel verknüpft und kann daher hier nicht bearbeitet werden.';

  @override
  String get backup_selection_shared =>
      'Änderungen dieser Auswahl werden sofort gespeichert und gelten auch für automatische Backups.';

  @override
  String get library_snapshot_history =>
      'Einen Bibliotheks-Snapshot wiederherstellen';

  @override
  String get library_snapshot_empty =>
      'Keine Sicherheitsmomentaufnahmen verfügbar.';

  @override
  String get library_snapshot_restore_message =>
      'Aktuelle Daten werden durch diesen Snapshot ersetzt. Seitdem vorgenommene Änderungen gehen verloren. Gelöschte Downloads können nicht wiederhergestellt werden. Verfügbare Sicherheits-Snapshots werden nach Erfolg gelöscht.';

  @override
  String get library_maintenance_working => 'Bibliothek wird aktualisiert…';

  @override
  String get library_safety_snapshot_note =>
      'Vor diesem Vorgang wird ein Sicherheits-Snapshot gespeichert. Heruntergeladene Dateien sind nicht enthalten.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Bibliothekseinträge: $mangaCount. Kapitel: $chapterCount. Verlaufseinträge: $historyCount. Aktualisierungen: $updateCount.\n\nWählen Sie unten aus, was Sie behalten möchten.';
  }

  @override
  String get library_delete_pick_message =>
      'Wählen Sie eine Quelle aus, um deren Inhalt und Löschoptionen zu überprüfen.';

  @override
  String get mobile_categories_hint =>
      'Zum Neuordnen ziehen. Öffnen Sie eine Kategorie, um sie umzubenennen oder ihre Sichtbarkeit und Aktualisierungen zu ändern.';

  @override
  String get mobile_category_visible => 'In der Bibliothek anzeigen';

  @override
  String get mobile_category_hidden => 'Aus der Bibliothek ausgeblendet';

  @override
  String get mobile_category_updates =>
      'In Bibliotheksaktualisierungen einbeziehen';

  @override
  String get statistics_watched => 'Beobachtet';

  @override
  String get calendar_month => 'Monat';

  @override
  String get calendar_two_weeks => '2 Wochen';

  @override
  String get calendar_week => 'Woche';

  @override
  String get calendar_show_all_dates => 'Alle Termine anzeigen';

  @override
  String get update_check_no_result =>
      'Kein installierbares Update gefunden. Sie können es später noch einmal versuchen.';

  @override
  String get release_notes => 'Versionshinweise';

  @override
  String get no_release_notes => 'Keine Versionshinweise bereitgestellt.';

  @override
  String get downloading_update => 'Update wird heruntergeladen…';

  @override
  String get preparing_installation => 'Installation wird vorbereitet…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Wählen Sie aus, was Sie lesen möchten. Sie können dies später ändern.';

  @override
  String get onboarding_content_title => 'Beginnen Sie mit dem Lesen';

  @override
  String get onboarding_mobile_sources_body =>
      'Wählen Sie eine Startmethode oder fügen Sie später Inhalte hinzu.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Schritt $step von $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'Ergebnisse für „$query“';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen',
      one: '1 Quelle',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Nach dem Zieltitel suchen.';

  @override
  String get migration_original_item => 'Aktueller Artikel';

  @override
  String get migration_target_item => 'Ausgewähltes Element';

  @override
  String get migration_partial_failure =>
      'Der Vorgang wurde nicht abgeschlossen. Möglicherweise wurden einige Änderungen gespeichert. Überprüfen Sie dieses Element in Ihrer Bibliothek, bevor Sie es erneut versuchen.';

  @override
  String get migration_no_categories =>
      'Keine Kategorien. Sie können diesen Artikel ohne Kategorie hinzufügen.';

  @override
  String get mass_migration_select_source => 'Wählen Sie die aktuelle Quelle';

  @override
  String get mass_migration_select_all => 'Alles auswählen';

  @override
  String get mass_migration_deselect_all => 'Alle abwählen';

  @override
  String get mass_migration_needs_review =>
      'Überprüfen Sie unvollständige Migrationen';

  @override
  String get bookshelf_actions => 'Bücherregalaktionen';

  @override
  String get bookshelf_ignore_filters => 'Filter bei der Suche ignorieren';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Durchsuchen Sie alle Werke in dieser Kategorie, einschließlich der durch Filter ausgeblendeten.';

  @override
  String get bookshelf_stop_update => 'Bibliotheksaktualisierung stoppen';

  @override
  String bookshelf_selected_count(int count) {
    return '$count Werke ausgewählt';
  }

  @override
  String get bookshelf_remove_library => 'Aus dem Bücherregal entfernen';

  @override
  String get bookshelf_remove_library_hint =>
      'Entfernt Favoriten. Auch lokale Importe verlieren ihre Bibliotheks- und Lesedatensätze.';

  @override
  String get bookshelf_remove_downloads => 'Heruntergeladene Dateien löschen';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Entfernt heruntergeladene Dateien unter Beibehaltung der Arbeitsinformationen.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Löscht außerdem ausgewählte lokal importierte Dateien und entfernt ihre Bibliothekseinträge. Diese Dateien können hier nicht wiederhergestellt werden.';

  @override
  String get bookshelf_remove_incomplete =>
      'Der Vorgang wurde nicht abgeschlossen. Möglicherweise wurden einige Werke oder Dateien verarbeitet. Schließen Sie dieses Dialogfeld und überprüfen Sie Ihr Bücherregal und Ihre Downloads, bevor Sie fortfahren.';

  @override
  String get bookshelf_processing => 'Verarbeitung…';

  @override
  String get bookshelf_mark_read => 'Als gelesen markieren';

  @override
  String get bookshelf_mark_unread => 'Als ungelesen markieren';

  @override
  String get bookshelf_select_all => 'Alles auswählen';

  @override
  String get bookshelf_invert_selection => 'Auswahl umkehren';

  @override
  String get bookshelf_settings => 'Bücherregaleinstellungen';

  @override
  String get bookshelf_settings_live =>
      'Filter-, Sortier- und Anzeigeänderungen werden sofort wirksam.';

  @override
  String get bookshelf_filter_any => 'Beliebig';

  @override
  String get bookshelf_filter_include => 'Einschließen';

  @override
  String get bookshelf_filter_exclude => 'Ausschließen';

  @override
  String get bookshelf_all_sources => 'Alle Quellen';

  @override
  String bookshelf_sources_selected(int count) {
    return '$count Quellen ausgewählt';
  }

  @override
  String get bookshelf_sort_ascending => 'Aufsteigend';

  @override
  String get bookshelf_sort_descending => 'Absteigend';

  @override
  String get bookshelf_layout => 'Bücherregal-Layout';

  @override
  String get bookshelf_sources_hint =>
      'Wählen Sie „Keine“, um alle Quellen anzuzeigen. Änderungen werden übernommen, wenn Sie auf Filter tippen.';

  @override
  String get bookshelf_choose_files => 'Dateien auswählen';

  @override
  String get bookshelf_import_wait =>
      'Wählen Sie eine Datei in der Auswahl aus und warten Sie, bis der Import abgeschlossen ist.';

  @override
  String get bookshelf_import_incomplete =>
      'Der Import wurde nicht abgeschlossen. Einige Dateien befinden sich möglicherweise bereits in Ihrem Bücherregal. Schließen Sie dieses Dialogfeld und überprüfen Sie es, bevor Sie erneut importieren.';

  @override
  String get bookshelf_categories_replace =>
      'Durch das Speichern werden diese Kategorien jedem ausgewählten Werk zugewiesen und ersetzen ihre vorherigen Kategorien.';

  @override
  String get bookshelf_categories_hint =>
      'Wählen Sie eine oder mehrere Kategorien aus oder lassen Sie die Auswahl leer, um keine zuzuweisen.';

  @override
  String get bookshelf_categories_hidden =>
      'Vorhandene versteckte Kategorien bleiben für diese Arbeit erhalten.';

  @override
  String get bookshelf_categories_incomplete =>
      'Kategorien konnten nicht vollständig gespeichert werden. Schließen Sie dieses Dialogfeld und überprüfen Sie das Bücherregal, bevor Sie es erneut versuchen.';

  @override
  String get bookshelf_categories_none_visible =>
      'Hier sind keine Kategorien verfügbar. Öffnen Sie die Kategorieverwaltung, um sie zu überprüfen.';

  @override
  String get bookshelf_manage_categories => 'Kategorien verwalten';

  @override
  String get manga_actions => 'Komische Aktionen';

  @override
  String get manga_download_scope => 'Kapitel herunterladen';

  @override
  String get manga_download_scope_hint =>
      'Wählen Sie Kapitel innerhalb der aktuellen Filter aus. Heruntergeladene Kapitel werden übersprungen.';

  @override
  String get manga_download_scope_empty =>
      'Keine Kapitel entsprechen den aktuellen Filtern. Schließen Sie dieses Menü und passen Sie die Kapitelfilter an.';

  @override
  String get manga_action_incomplete =>
      'Die Aktion wurde nicht beendet. Überprüfen Sie den aktuellen Status, bevor Sie es erneut versuchen.';

  @override
  String get chapter_settings => 'Kapiteleinstellungen';

  @override
  String get chapter_settings_live =>
      'Filter- und Sortieränderungen werden sofort wirksam.';

  @override
  String get chapter_scanlators_all => 'Alle Scanlator-Gruppen anzeigen';

  @override
  String get chapter_scanlators_hint =>
      'Wählen Sie Gruppen aus, um deren Kapitel auszublenden. Änderungen werden übernommen, wenn Sie auf Filter tippen.';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count Scanlator-Gruppen ausgeblendet';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count Kapitel ausgewählt';
  }

  @override
  String get chapter_add_bookmark => 'Lesezeichen';

  @override
  String get chapter_remove_bookmark => 'Lesezeichen aufheben';

  @override
  String get chapter_read_following => 'Lesen Sie weiter unten';

  @override
  String get chapter_delete_records => 'Kapiteldatensätze löschen';

  @override
  String get chapter_delete_local_hint =>
      'Entfernt die ausgewählten Kapiteldatensätze und den Lesefortschritt. Die ursprünglichen lokalen Archive bleiben erhalten; Heruntergeladene Kopien werden bereinigt.';

  @override
  String get chapter_delete_last_hint =>
      'Dies sind alles Kapitel in diesem Comic. Durch das Löschen wird auch der Comic aus Ihrem Bücherregal entfernt.';

  @override
  String get chapter_action_incomplete =>
      'Die Aktion wurde nicht beendet. Einige Änderungen sind möglicherweise bereits gespeichert. Schließen Sie die Kapitel und Downloads und überprüfen Sie sie, bevor Sie fortfahren.';

  @override
  String get reader_display_scope =>
      'Der Lesemodus und das Layout der Handbuchseite gelten für diesen Comic. Wählen Sie eine Änderung, um zum Lesen zurückzukehren.';

  @override
  String get reader_display_single_only =>
      'Beim horizontalen kontinuierlichen Lesen werden einzelne Seiten verwendet.';

  @override
  String get reader_display_manual_pages =>
      'Durch Ändern des Seitenlayouts wird die automatische Doppelseite für alle Comics deaktiviert.';

  @override
  String get reader_display_crop_scope => 'Gilt für alle Comics.';

  @override
  String get reader_chapter_locate => 'Aktuelles Kapitel suchen';

  @override
  String get reader_chapter_search => 'Kapitel oder Scanlatoren durchsuchen';

  @override
  String get reader_chapter_scope =>
      'Verwendet die Kapitelfilter und Sortierreihenfolge anhand von Comic-Details. Lesezeichen werden sofort gespeichert.';

  @override
  String get reader_chapter_current_hidden =>
      'Das Kapitel, das Sie lesen, liegt außerhalb der aktuellen Filter.';

  @override
  String get reader_chapter_current => 'Jetzt lesen';

  @override
  String get reader_chapter_read => 'Lesen';

  @override
  String get reader_chapter_bookmark_failed =>
      'Das Speichern des Lesezeichens konnte nicht bestätigt werden. Schließen Sie die Liste und überprüfen Sie den aktuellen Status.';

  @override
  String get reader_image_actions => 'Bildaktionen';

  @override
  String get reader_image_original =>
      'Verwendet die gesamte Originalseite, ohne Übersetzung, Zuschneiden oder Farbfilter des Lesers.';

  @override
  String get reader_image_save_ios =>
      'Im Ordner „Bilder“ am aktuellen Speicherort der App speichern.';

  @override
  String get reader_image_save_android =>
      'Im Ordner „Bilder/nodelane-comics“ des Geräts speichern.';

  @override
  String get reader_image_share => 'Öffnen Sie das Systemfreigabeblatt.';

  @override
  String get reader_image_cover =>
      'Ändern Sie das Cover dieses Comics nach der Bestätigung.';

  @override
  String get reader_image_cover_limit =>
      'Titelbilder müssen kleiner als 5 MB sein. Speichern und Teilen bleiben weiterhin möglich.';

  @override
  String get reader_image_action_failed =>
      'Die Aktion konnte nicht bestätigt werden. Schließen Sie dieses Menü und überprüfen Sie das Ergebnis, bevor Sie es erneut versuchen.';

  @override
  String get reader_settings_book_scope =>
      'Diese Einstellungen gelten nur für diesen Comic.';

  @override
  String get reader_settings_global_scope =>
      'Diese Einstellungen gelten für alle Comics und werden sofort gespeichert.';

  @override
  String get reader_filters => 'Bildfilter';

  @override
  String get reader_filter_scope =>
      'Gilt für alle Comics. Ändert die Leseanzeige, ohne die Originalbilder zu verändern.';

  @override
  String get reader_auto_scroll_pause =>
      'Das Scrollen pausiert, während die Einstellungen geöffnet sind.';

  @override
  String get manga_synopsis => 'Inhaltsangabe';

  @override
  String manga_author(String author) {
    return 'Autor: $author';
  }

  @override
  String get manga_continue_reading => 'Lesen Sie weiter';

  @override
  String get reader_settings_title => 'Reader-Einstellungen';

  @override
  String get reader_picker_book_scope => 'Nur für diesen Comic';

  @override
  String get reader_picker_global_scope => 'Gilt für alle Comics';

  @override
  String get reader_picker_apply_hint =>
      'Tippen Sie, um zu speichern und zur vorherigen Ebene zurückzukehren.';

  @override
  String get reader_scale_fit_screen_hint =>
      'Passen Sie die gesamte Seite auf den Bildschirm an';

  @override
  String get reader_scale_stretch_hint => 'Füllen Sie den Lesebereich';

  @override
  String get reader_scale_fit_width_hint =>
      'Passen Sie die Seite an die Breite an';

  @override
  String get reader_scale_fit_height_hint =>
      'Passen Sie die Seite an die Höhe an';

  @override
  String get source_filter_active => 'Angewendet';

  @override
  String get source_filter_apply => 'Filter anwenden';

  @override
  String get source_filter_scope => 'Filter gelten nur für diese Website.';

  @override
  String get source_filter_apply_hint =>
      'Wenden Sie Filter an, um Ihre Auswahl zu verwenden.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Genres',
      'author': 'Autor',
      'artist': 'Künstler',
      'title': 'Titel',
      'year': 'Jahr',
      'tags': 'Tags',
      'format': 'Format',
      'publisher': 'Herausgeber',
      'relevance': 'Relevanz',
      'rating': 'Bewertung',
      'views': 'Ansichten',
      'random': 'Zufällig',
      'all': 'Alle',
      'none': 'Keine',
      'action': 'Aktion',
      'adventure': 'Abenteuer',
      'comedy': 'Komödie',
      'drama': 'Drama',
      'fantasy': 'Fantasie',
      'romance': 'Romantik',
      'science_fiction': 'Science-Fiction',
      'slice_of_life': 'Stück Leben',
      'mystery': 'Geheimnis',
      'horror': 'Horror',
      'psychological': 'Psychologisch',
      'historical': 'Historisch',
      'sports': 'Sport',
      'supernatural': 'Übernatürlich',
      'school_life': 'Schulleben',
      'tragedy': 'Tragödie',
      'shounen': 'Shounen',
      'shoujo': 'Shoujo',
      'seinen': 'Seinen',
      'josei': 'Josei',
      'isekai': 'Isekai',
      'martial_arts': 'Kampfkunst',
      'mecha': 'Mecha',
      'music': 'Musik',
      'doujinshi': 'Doujinshi',
      'trending': 'Im Trend',
      'new': 'Neu',
      'adult_content': 'Inhalte für Erwachsene',
      'only': 'Nur',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'Weitere Anzeigeoptionen';

  @override
  String get bookshelf_more_display_hint => 'Abzeichen, Quellen und Kategorien';

  @override
  String get bookshelf_download_count => 'Download-Zähler';

  @override
  String get bookshelf_source_global_hint =>
      'Die Sichtbarkeit der Quelle nutzt die gemeinsame Anzeigepräferenz.';

  @override
  String get bookshelf_select_entries => 'Werke auswählen';

  @override
  String get bookshelf_search_options => 'Suchoptionen';

  @override
  String get bookshelf_empty_hint =>
      'Sammeln Sie Werke aus Quellen oder importieren Sie lokale Dateien.';

  @override
  String get bookshelf_no_match_hint =>
      'Probieren Sie andere Schlüsselwörter aus oder passen Sie die aktuellen Filter an.';

  @override
  String get bookshelf_clear_query => 'Klare Schlüsselwörter';

  @override
  String get bookshelf_view_selection => 'Ausgewählte Werke ansehen';

  @override
  String get bookshelf_import_formats =>
      'Wählen Sie eine lokale Datei aus, um sie Ihrem Bücherregal hinzuzufügen.';

  @override
  String get bookshelf_import_canceled_hint =>
      'Nach dem Abbrechen der Dateiauswahl können Sie erneut auswählen.';

  @override
  String get bookshelf_browse_sources => 'Quellen durchsuchen';

  @override
  String get bookshelf_empty_title => 'Ihr Bücherregal ist leer';

  @override
  String get bookshelf_no_match_title => 'Keine passenden Werke';

  @override
  String get bookshelf_mark_watched => 'Mark sah zu';

  @override
  String get bookshelf_mark_unwatched => 'Unbeobachtet markieren';

  @override
  String get nodelane_account => 'NodeLane Konto';

  @override
  String get nodelane_sign_in => 'Anmelden bei NodeLane';

  @override
  String get nodelane_account_intro =>
      'Sehen Sie sich Ihr Konto, Ihr Abonnement und Ihr Übersetzungskontingent an';

  @override
  String get nodelane_login_action => 'Fahren Sie mit der Anmeldung fort';

  @override
  String get nodelane_login_browser =>
      'Melden Sie sich über den Systembrowser an und kehren Sie dann zur App zurück';

  @override
  String get nodelane_account_id => 'Konto-ID';

  @override
  String get nodelane_account_init_error =>
      'Der Kontospeicher ist nicht verfügbar. Starten Sie die App neu und versuchen Sie es erneut.';

  @override
  String get nodelane_account_refresh_error =>
      'Kontoinformationen konnten nicht aktualisiert werden';

  @override
  String get nodelane_account_auth_error =>
      'Ihre Sitzung ist abgelaufen. Melden Sie sich erneut an';

  @override
  String get nodelane_account_unknown =>
      'Abonnementinformationen sind nicht verfügbar';

  @override
  String get nodelane_account_current => 'Aktuelles Abonnement';

  @override
  String get nodelane_account_free => 'Kostenloses Konto';

  @override
  String get nodelane_account_no_subscription => 'Kein aktives Abonnement';

  @override
  String get nodelane_account_active => 'Aktiv';

  @override
  String get nodelane_account_expired => 'Abgelaufen';

  @override
  String get nodelane_account_expiry => 'Gültig bis';

  @override
  String get nodelane_account_renewal => 'Erneuerung';

  @override
  String get nodelane_renewal_auto => 'Automatische Verlängerung';

  @override
  String get nodelane_renewal_manual => 'Manuelle Erneuerung';

  @override
  String get nodelane_renewal_stopped => 'Automatische Erneuerung gestoppt';

  @override
  String get nodelane_renewal_gift => 'Geschenkmitgliedschaft';

  @override
  String get nodelane_renewal_attention =>
      'Überprüfen Sie Ihren Verlängerungsstatus auf der Website';

  @override
  String get nodelane_next_billing => 'Nächstes Abrechnungsdatum';

  @override
  String get nodelane_billing_unavailable =>
      'Informationen zur Verlängerung sind nicht verfügbar';

  @override
  String get nodelane_manage_account => 'Auf der Website verwalten';

  @override
  String get nodelane_view_plans => 'Abonnementpläne anzeigen';

  @override
  String get nodelane_translation_quota => 'Übersetzungsquote';

  @override
  String get nodelane_quota_free => 'Kostenloses Kontingent';

  @override
  String get nodelane_quota_subscription => 'Abonnementkontingent';

  @override
  String get nodelane_quota_purchase => 'Gekaufte Quote';

  @override
  String get nodelane_quota_details => 'Kontingentdetails anzeigen';

  @override
  String get nodelane_quota_expanded => 'Kontingentdetails';

  @override
  String get nodelane_quota_unlimited => 'Unbegrenzt';

  @override
  String get nodelane_quota_not_subscribed => 'Nicht abonniert';

  @override
  String get nodelane_quota_unknown => 'Nicht verfügbar';

  @override
  String get nodelane_quota_used => 'Gebraucht';

  @override
  String get nodelane_quota_reserved => 'In Bearbeitung';

  @override
  String get nodelane_quota_reset => 'Nächster Reset';

  @override
  String get nodelane_quota_expiry => 'Nächster Ablauf';

  @override
  String get nodelane_quota_no_expiry => 'Kein Ablaufdatum';

  @override
  String get nodelane_quota_reservation_note =>
      'In Bearbeitung befindliche Seiten werden bereits vom verfügbaren Kontingent abgezogen';

  @override
  String nodelane_quota_available(int count) {
    return '$count Seiten verbleiben';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count Seiten';
  }

  @override
  String get nodelane_sign_out => 'Abmelden';

  @override
  String get nodelane_sign_out_confirm =>
      'Durch das Abmelden wird die offizielle Übersetzung auf diesem Gerät angehalten. Ihre Bibliothek und Ihr Lesefortschritt werden gespeichert.';

  @override
  String get settings_search_hint => 'Sucheinstellungen';

  @override
  String get settings_frequent => 'Häufig verwendet';

  @override
  String get settings_reading_translation => 'Lesen und Übersetzen';

  @override
  String get settings_app_preferences => 'App-Einstellungen';

  @override
  String get settings_data_management => 'Daten und Verwaltung';

  @override
  String get settings_more_tools => 'Weitere Werkzeuge';

  @override
  String get settings_more_tools_hint => 'Kategorien, Statistiken und Kalender';

  @override
  String get settings_appearance_interface => 'Aussehen und Schnittstelle';

  @override
  String get settings_security_privacy => 'Sicherheit und Datenschutz';

  @override
  String get settings_source_preferences => 'Quelleneinstellungen';

  @override
  String get settings_about_help => 'Über und Hilfe';

  @override
  String get settings_storage_backup => 'Speicherung und Sicherung';

  @override
  String settings_pending_downloads(int count) {
    return '$count ausstehend';
  }

  @override
  String get settings_translation_language => 'Übersetzungssprache';

  @override
  String get settings_translation_scope =>
      'Wird im Reader und bei der Übersetzung von Webseiten verwendet';

  @override
  String get settings_immediate_choice => 'Änderungen gelten sofort';

  @override
  String get settings_translation_init_error =>
      'Übersetzungseinstellungen sind nicht verfügbar. Starten Sie die App neu und versuchen Sie es erneut.';

  @override
  String get settings_local_cache => 'Lokaler Cache';

  @override
  String get settings_chapter_cache => 'Kapitel- und Episoden-Cache';

  @override
  String get settings_cover_cache => 'Cache abdecken';

  @override
  String get settings_translation_cache => 'Cache für übersetzte Bilder';

  @override
  String get settings_translation_cache_hint =>
      'Bewahren Sie Übersetzungsaufzeichnungen auf und rufen Sie übersetzte Bilder bei Bedarf erneut ab';

  @override
  String get settings_cache_clear => 'Klar';

  @override
  String get settings_translation_cache_done =>
      'Cache für übersetzte Bilder gelöscht; Übersetzungsaufzeichnungen werden aufbewahrt';

  @override
  String settings_cache_confirmation(String name) {
    return '$name löschen? Zwischengespeicherte Inhalte können wieder abgerufen werden. Bibliothekseinträge bleiben erhalten.';
  }

  @override
  String get settings_advanced_options => 'Erweiterte Optionen';

  @override
  String get settings_manga_reader => 'Manga-Reader';

  @override
  String get settings_novel_reader => 'Romanleser';

  @override
  String get settings_downloads => 'Einstellungen herunterladen';

  @override
  String get onboarding_welcome => 'Willkommen bei';

  @override
  String get onboarding_reading_content => 'Inhalte lesen';

  @override
  String get onboarding_choose_one => 'Wählen Sie mindestens eine aus';

  @override
  String get onboarding_restore_hint =>
      'Stellen Sie Ihre Bibliothek aus einem Backup wieder her';

  @override
  String get onboarding_browse_hint =>
      'Finden Sie Titel auf unterstützten Websites';

  @override
  String get onboarding_import_folder => 'Importieren Sie einen lokalen Ordner';

  @override
  String get onboarding_import_folder_hint =>
      'Lesen Sie Mangas, Romane und Animes auf Ihrem Gerät';

  @override
  String get onboarding_third_party =>
      'Fügen Sie ein Drittanbieter-Repository hinzu';

  @override
  String get onboarding_third_party_hint =>
      'Verwenden Sie eine Repository-Adresse, die Sie bereits haben';

  @override
  String get onboarding_repository_hint =>
      'Geben Sie die vom Repository bereitgestellte Adresse ein.';

  @override
  String get onboarding_repository_address => 'Adresse';

  @override
  String get onboarding_repository_address_hint =>
      'Geben Sie die Repository-Adresse ein';

  @override
  String get onboarding_add_repository => 'Repository hinzufügen';

  @override
  String get onboarding_start => 'Fangen Sie an';

  @override
  String get onboarding_open_library => 'Bibliothek öffnen';

  @override
  String get onboarding_view_imports => 'Importierte Inhalte anzeigen';

  @override
  String get onboarding_view_folders => 'Ordner anzeigen';

  @override
  String get notice_backup_created => 'Backup erstellt';

  @override
  String get notice_backup_ready =>
      'Speichern oder teilen Sie die Sicherungsdatei.';

  @override
  String get notice_backup_restored => 'Sicherung wiederhergestellt';

  @override
  String get notice_backup_unsupported =>
      'Dieses Sicherungsformat wird nicht unterstützt.';

  @override
  String get notice_verification_required =>
      'Website-Verifizierung erforderlich';

  @override
  String get notice_verification_hint =>
      'Schließen Sie die Verifizierung ab, um mit dem Surfen fortzufahren.';

  @override
  String get notice_verify => 'Website überprüfen';

  @override
  String get notice_action_incomplete =>
      'Die Aktion wurde nicht beendet. Überprüfen Sie das Ergebnis, bevor Sie es erneut versuchen.';

  @override
  String get notice_library_updating => 'Bibliothek aktualisieren';

  @override
  String notice_library_progress(Object current, Object total) {
    return '$current / $total Titel überprüft';
  }

  @override
  String get notice_library_failed =>
      'Einige Titel konnten nicht aktualisiert werden';

  @override
  String get notice_import_completed => 'Import abgeschlossen';

  @override
  String get notice_operation_incomplete => 'Aktion unvollständig';

  @override
  String get subtitle_service => 'Online-Untertiteldienst';

  @override
  String get subtitle_service_mode => 'Untertitelquelle';

  @override
  String get subtitle_service_disabled =>
      'Aus · gespeicherte Anmeldeinformationen löschen';

  @override
  String get subtitle_personal_key => 'Mein Wyzie-Schlüssel';

  @override
  String get subtitle_custom_service => 'Mein Untertiteldienst';

  @override
  String get subtitle_key => 'Wyzie API Schlüssel';

  @override
  String get subtitle_key_hint =>
      'Geben Sie Ihren eigenen Wyzie-Schlüssel ein. Es verbleibt auf diesem Gerät und ist nicht in App-Backups enthalten.';

  @override
  String get subtitle_get_key => 'Holen Sie sich einen persönlichen Schlüssel';

  @override
  String get subtitle_service_address => 'Untertitelsuche URL';

  @override
  String get subtitle_service_token => 'Dienstzugriffstoken (optional)';

  @override
  String get subtitle_custom_hint =>
      'Verwenden Sie die vollständige HTTPS-Suche URL eines Wyzie-compatible-Dienstes, einschließlich seines Pfads (z. B. /search). Geben Sie nur dann ein Zugriffstoken ein, wenn Ihr Dienst eines erfordert.';

  @override
  String get subtitle_service_off_hint =>
      'Die Online-Untertitelsuche ist deaktiviert. Eingebettete, von der Quelle bereitgestellte und lokale Untertitel bleiben weiterhin verfügbar.';

  @override
  String get subtitle_setup_required =>
      'Wählen Sie vor der Suche einen Untertiteldienst.';

  @override
  String get subtitle_invalid_key =>
      'Geben Sie einen Schlüssel ohne Leerzeichen ein.';

  @override
  String get subtitle_invalid_address =>
      'Verwenden Sie einen vollständigen HTTPS URL ohne Abfrage, Fragment oder eingebettete Anmeldeinformationen.';

  @override
  String get subtitle_invalid_token =>
      'Das Zugriffstoken darf keine Leerzeichen enthalten.';

  @override
  String get subtitle_storage_failed =>
      'Die Untertiteleinstellungen konnten nicht gelesen oder gespeichert werden. Bitte versuchen Sie es erneut.';

  @override
  String get subtitle_auth_failed =>
      'Der Untertiteldienst verweigerte den Zugriff. Überprüfen Sie Ihren Schlüssel oder Service-Token.';

  @override
  String get subtitle_quota_exhausted =>
      'Das Kontingent für den Untertiteldienst ist erschöpft. Überprüfen Sie Ihr Konto bei diesem Dienst.';

  @override
  String get subtitle_network_failed =>
      'Der Untertiteldienst konnte nicht erreicht werden. Bitte versuchen Sie es erneut.';

  @override
  String get subtitle_response_invalid =>
      'Der Untertiteldienst hat eine nicht unterstützte Antwort oder Datei zurückgegeben.';

  @override
  String get detail_loading_chapters => 'Kapitel werden geladen…';

  @override
  String get reader_opening_chapter => 'Eröffnungskapitel';

  @override
  String get reader_open_chapter => 'Kapitel öffnen';

  @override
  String get reader_loading_pages => 'Kapitelbilder abrufen…';

  @override
  String get reader_loading_pages_hint =>
      'Das Lesen beginnt automatisch, wenn es bereit ist.';

  @override
  String get reader_loading_failed =>
      'Dieses Kapitel konnte nicht geladen werden';

  @override
  String get reader_loading_retry_hint =>
      'Überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get reader_no_pages =>
      'Für dieses Kapitel wurden keine Bilder gefunden';

  @override
  String get reader_loading_previous => 'Vorheriges Kapitel wird geladen…';

  @override
  String get reader_previous_failed =>
      'Das vorherige Kapitel konnte nicht geladen werden';

  @override
  String get reader_reached_start => 'Sie haben das erste Kapitel erreicht';

  @override
  String get reader_loading_next => 'Nächstes Kapitel wird geladen…';

  @override
  String get reader_next_failed =>
      'Das nächste Kapitel konnte nicht geladen werden';

  @override
  String get reader_image_loading => 'Bild wird geladen…';

  @override
  String get reader_image_failure_hint =>
      'Sie können weiterhin andere Seiten lesen.';

  @override
  String get comic_paged => 'Seite für Seite';

  @override
  String get comic_scroll => 'Nach unten scrollen';

  @override
  String get comic_book_scope =>
      'Gilt nur für dieses Buch · Änderungen werden sofort gespeichert';

  @override
  String get comic_defaults_title => 'Vorgaben und Gewohnheiten';

  @override
  String get comic_defaults_hint =>
      'Die Standardeinstellungen gelten für Felder, die Sie nicht für ein Buch angepasst haben.';

  @override
  String get comic_habits_hint => 'Diese Gewohnheiten gelten für jeden Comic.';

  @override
  String get comic_turn => 'Wischen Sie zur nächsten Seite';

  @override
  String get comic_left => 'Links';

  @override
  String get comic_right => 'Richtig';

  @override
  String get comic_up => 'Aufwärts';

  @override
  String get comic_fit => 'Seitenanpassung';

  @override
  String get comic_fit_contain => 'Ganze Seite';

  @override
  String get comic_fit_width => 'Passbreite';

  @override
  String get comic_fit_height => 'Passhöhe';

  @override
  String get comic_layout => 'Seitenlayout';

  @override
  String get comic_auto => 'Auto';

  @override
  String get comic_layout_hint =>
      'Auto zeigt eine Spreizung an, wenn genügend Breite vorhanden ist.';

  @override
  String get comic_width => 'Inhaltsbreite';

  @override
  String get comic_full => 'Voll';

  @override
  String get comic_comfortable => 'Bequem';

  @override
  String get comic_narrow => 'Schmal';

  @override
  String get comic_gap => 'Seitenabstand';

  @override
  String get comic_no_gap => 'Nahtlos';

  @override
  String get comic_small_gap => 'Klein';

  @override
  String get comic_image_title => 'Bild feinabstimmen';

  @override
  String get comic_image_hint =>
      'Zuschnitt und Ton beeinflussen nur dieses Buch.';

  @override
  String get comic_wide => 'Breite Seiten';

  @override
  String get comic_intact => 'Ganz bleiben';

  @override
  String get comic_split => 'Geteilt';

  @override
  String get comic_rotate => 'Drehen';

  @override
  String get comic_wide_hint =>
      'Die Aufteilung folgt der Seitenwechselrichtung. Gilt für das Lesen einer einzelnen Seite.';

  @override
  String get comic_cover => 'Ein Cover pro Kapitel';

  @override
  String get comic_effects_reset => 'Bildeinstellungen zurücksetzen';

  @override
  String get comic_book_reset => 'Buchstandards wiederherstellen';

  @override
  String get comic_book_reset_hint =>
      'Löscht die benutzerdefinierten Leseeinstellungen dieses Buchs. Die Übersetzung bleibt unverändert.';

  @override
  String get comic_canvas => 'Leserhintergrund';

  @override
  String get comic_system => 'System';

  @override
  String get comic_black => 'Schwarz';

  @override
  String get comic_gray => 'Grau';

  @override
  String get comic_paper => 'Papier';

  @override
  String get comic_tap => 'Tippen Sie, um Seiten umzublättern';

  @override
  String get comic_tap_hint =>
      'Tippen Sie auf die Kanten, um sie zu verschieben. Tippen Sie auf die Mitte, um die Steuerelemente anzuzeigen.';

  @override
  String get comic_scroll_start => 'Automatisches Scrollen starten';

  @override
  String get comic_scroll_pause => 'Automatisches Scrollen anhalten';

  @override
  String get comic_scroll_speed => 'Scrollgeschwindigkeit';

  @override
  String get comic_scroll_hint =>
      'Startet, wenn dieses Panel geschlossen wird. Pausiert, wenn die App den Vordergrund verlässt.';

  @override
  String get comic_save_failed =>
      'Speichern konnte nicht erfolgen. Bitte versuchen Sie es erneut.';

  @override
  String get comic_reading => 'Lesen';

  @override
  String get comic_chapter_habits_hint =>
      'Kapitellistengewohnheiten gelten für alle Bücher.';

  @override
  String get browser_title => 'Browser';

  @override
  String get translation_image_display => 'Bildanzeige';

  @override
  String get translation_display_hint =>
      'Vorhandene Übersetzungen zuerst anzeigen. Behalten Sie das Original, wenn keine Übersetzung verfügbar ist.';

  @override
  String get translation_sign_in_required =>
      'Melden Sie sich an, um die Übersetzung zu aktivieren';

  @override
  String get translation_sign_in_hint =>
      'Wechseln Sie nach der Anmeldung zu übersetzten Bildern, um sie automatisch zu übersetzen.';

  @override
  String get translation_automatic => 'Automatische Übersetzung';

  @override
  String get translation_original_hint =>
      'Originale anzeigen. Wechseln Sie zu übersetzten Bildern, um sie automatisch zu übersetzen.';

  @override
  String get translation_window_hint =>
      'Aktuelle und kommende Bilder nur verarbeiten, während Übersetzungen angezeigt werden.';

  @override
  String get translation_channel => 'Übersetzungskanal';

  @override
  String get translation_no_images =>
      'Auf dieser Seite wurden noch keine übersetzbaren Bilder gefunden';

  @override
  String get translation_waiting_image => 'Warten auf das aktuelle Bild';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues Bilder brauchen Aufmerksamkeit',
      one: ' · 1 Bild benötigt Aufmerksamkeit',
      zero: '',
    );
    return 'Abgeschlossene $complete / $total Bilder$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'Berühren und halten Sie ein Bild für weitere Aktionen, einschließlich einer erneuten Übersetzung.';

  @override
  String get translation_title => 'Manga-Übersetzung';

  @override
  String get translation_system_sign_in =>
      'Melden Sie sich mit Ihrem Systembrowser an';

  @override
  String get translation_target_language => 'Zielsprache';

  @override
  String get translation_clear_cache => 'Cache für übersetzte Bilder löschen';

  @override
  String get translation_cache_hint =>
      'Bewahren Sie Übersetzungsaufzeichnungen auf und rufen Sie die Ergebnisse bei Bedarf erneut ab.';

  @override
  String get translation_saved_read_failed =>
      'Die gespeicherte Übersetzung konnte nicht geladen werden';

  @override
  String get translation_read_failed =>
      'Das übersetzte Bild konnte nicht geladen werden';

  @override
  String get operation_retry =>
      'Die Aktion wurde nicht beendet. Bitte versuchen Sie es erneut.';

  @override
  String get translation_original => 'Original';

  @override
  String get translation_translated => 'Übersetzt';

  @override
  String get translation_regenerate_image =>
      'Übersetzen Sie dieses Bild erneut';

  @override
  String get translation_read_image => 'Übersetztes Bild neu laden';

  @override
  String get translation_image_actions => 'Weitere Bildaktionen';

  @override
  String get translation_processing => 'Verarbeitung';

  @override
  String get translation_reading => 'Übersetztes Bild wird geladen';

  @override
  String get translation_waiting => 'Warten auf Übersetzung';

  @override
  String get translation_preparing => 'Vorbereitung der Übersetzung';

  @override
  String get translation_uploading => 'Original hochladen';

  @override
  String get translation_running => 'Übersetzen';

  @override
  String get translation_uncertain => 'Der Status muss überprüft werden';

  @override
  String get translation_failed => 'Übersetzung fehlgeschlagen';

  @override
  String get translation_verify => 'Überprüfen';

  @override
  String get translation_reread => 'Neu laden';

  @override
  String get browser_back => 'Zurück';

  @override
  String get browser_translation => 'Webseitenübersetzung';

  @override
  String get browser_new_tab_action => 'Neue Registerkarte öffnen';

  @override
  String get browser_current_tab => 'Strom';

  @override
  String get browser_close_tab => 'Tab schließen';

  @override
  String get browser_new_tab => 'Neuer Tab';

  @override
  String get browser_page => 'Webseite';

  @override
  String get browser_unopened => 'Noch keine Seite geöffnet';

  @override
  String get browser_invalid_address => 'Geben Sie einen gültigen URL ein.';

  @override
  String get browser_clear_address => 'Löschen URL';

  @override
  String get browser_paste_address => 'Einfügen URL';

  @override
  String get browser_open_address => 'Öffnen URL';

  @override
  String browser_tab_count(int count) {
    return 'Tabs · $count';
  }

  @override
  String get browser_load_failed => 'Diese Seite konnte nicht geöffnet werden';

  @override
  String get browser_load_failed_hint =>
      'Überprüfen Sie Ihre Verbindung und den URL.';

  @override
  String get browser_edit_address => 'Bearbeiten URL';

  @override
  String get browser_clear_cookies_confirm =>
      'Anmeldesitzungen für alle Websites löschen?';

  @override
  String get browser_clear_cookies_hint =>
      'Websites auf allen Registerkarten erfordern möglicherweise eine erneute Anmeldung.';

  @override
  String get browser_clear_cookies_action => 'Anmeldesitzungen löschen';

  @override
  String get browser_tab_limit =>
      'Sie können bis zu 12 Tabs geöffnet lassen. Schließen Sie zuerst eines.';

  @override
  String get browser_forward => 'Vorwärts';

  @override
  String get browser_clear_all_cookies =>
      'Löschen Sie alle Website-Anmeldesitzungen';

  @override
  String get browser_clear_failed =>
      'Sitzungen konnten nicht gelöscht werden. Bitte versuchen Sie es erneut.';

  @override
  String get browser_save_failed =>
      'Tabs konnten nicht gespeichert werden. Bitte versuchen Sie es erneut.';

  @override
  String get browser_tabs_full => '12 Tabs sind bereits geöffnet';

  @override
  String get browser_no_tabs => 'Noch keine geöffneten Tabs';

  @override
  String get browser_close_failed =>
      'Tabs konnten nicht gespeichert werden. Tippen Sie erneut auf „Schließen“, um es noch einmal zu versuchen.';

  @override
  String get source_pinned_websites => 'Angepinnte Websites';

  @override
  String get manage => 'Verwalten';

  @override
  String get translation_settings_hint =>
      'Automatische Übersetzung, Zielsprache und Kanal';

  @override
  String get translation_show_original =>
      'Tippen Sie, um das Original anzuzeigen';

  @override
  String get translation_show_translated =>
      'Tippen Sie, um die Übersetzung anzuzeigen';

  @override
  String get source_display => 'Anzeige';

  @override
  String get source_cover_title => 'Cover und Titel';

  @override
  String get source_cover_only => 'Nur Abdeckung';

  @override
  String get source_save_search => 'Aktuelle Suche speichern';

  @override
  String get source_saved_searches => 'Gespeicherte Suchen';

  @override
  String get source_website_info => 'Website-Informationen';

  @override
  String source_saved_search_title(String title) {
    return '$title · Zum Suchen tippen';
  }

  @override
  String get action_done => 'Fertig';

  @override
  String source_search_keyword(String query) {
    return 'Schlüsselwort: $query';
  }

  @override
  String get source_no_saved_searches => 'Noch keine gespeicherten Suchen';

  @override
  String get source_save_search_hint =>
      'Suchen Sie nach einem Schlüsselwort und speichern Sie es dann aus den Website-Aktionen.';

  @override
  String get source_saved_search_scope =>
      'Schlüsselwörter werden nur für diese Website gespeichert.';

  @override
  String get source_search_here => 'Suchen Sie nach Titeln auf dieser Website';

  @override
  String get source_filter_results => 'Gefilterte Ergebnisse';

  @override
  String get source_search_results => 'Suchergebnisse';

  @override
  String get source_return_popular => 'Zurück zu beliebt';

  @override
  String get source_popular_titles => 'Beliebte Titel';

  @override
  String get source_no_titles => 'Keine passenden Titel gefunden';

  @override
  String get source_no_titles_hint =>
      'Ändern Sie Ihre Schlüsselwörter oder Filter oder kehren Sie zu beliebten Titeln zurück.';

  @override
  String get source_load_more_failed =>
      'Es konnte nicht mehr geladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get source_load_pull_retry =>
      'Diese Website konnte nicht geladen werden. Zum erneuten Versuch nach unten ziehen.';

  @override
  String get source_clear_failed =>
      'Das Löschen konnte nicht abgeschlossen werden. Bitte versuchen Sie es erneut.';

  @override
  String get source_uninstall_failed =>
      'Die Deinstallation konnte nicht abgeschlossen werden. Bitte versuchen Sie es erneut.';

  @override
  String get source_details => 'Quellenangaben';

  @override
  String get source_repository_website => 'Repository-Website';

  @override
  String get source_provided_settings =>
      'Von der Quelle bereitgestellte Einstellungen';

  @override
  String get source_advanced_actions => 'Erweiterte Aktionen';

  @override
  String get source_edit_metadata => 'Quellinformationen bearbeiten';

  @override
  String get source_clear_cookies => 'Cookies für diese Website löschen';

  @override
  String get source_clear_cookies_hint =>
      'Möglicherweise müssen Sie sich bei Ihrem nächsten Besuch erneut anmelden.';

  @override
  String get source_uninstall => 'Quelle deinstallieren';

  @override
  String get source_settings_save_failed =>
      'Der Speichervorgang wurde nicht abgeschlossen. Öffnen Sie die Quelleinstellungen erneut, um sie zu überprüfen.';

  @override
  String get repository_third_party => 'Repositories von Drittanbietern';

  @override
  String get repository_refresh_failed =>
      'Der Katalog konnte nicht aktualisiert werden. Zwischengespeicherte Inhalte bleiben erhalten. Bitte versuchen Sie es erneut.';

  @override
  String get repository_show_sources =>
      'Quellen aus diesem Repository anzeigen';

  @override
  String get repository_copy_catalog => 'Katalog-Link kopieren';

  @override
  String get repository_remove => 'Repository entfernen';

  @override
  String get repository_remove_hint =>
      'Behalten Sie installierte Quellen bei und entfernen Sie deinstallierte Katalogeinträge.';

  @override
  String get repository_empty =>
      'Es wurden noch keine Repositories von Drittanbietern hinzugefügt';

  @override
  String get repository_built_in => 'Eingebauter offizieller Katalog';

  @override
  String get repository_hidden => 'Versteckt';

  @override
  String get repository_refreshing => 'Erfrischend…';

  @override
  String get repository_refresh => 'Katalog aktualisieren';

  @override
  String get repository_manage_hint =>
      'Verwalten Sie, woher Drittanbieterquellen heruntergeladen werden.';

  @override
  String get repository_invalid_address =>
      'Geben Sie einen gültigen HTTP oder HTTPS URL ein.';

  @override
  String get repository_already_added =>
      'Dieses Repository wurde bereits hinzugefügt';

  @override
  String get repository_unrecognized =>
      'Kein unterstützter Katalog gefunden. Überprüfen Sie den Link und versuchen Sie es erneut.';

  @override
  String get repository_read_failed =>
      'Der Katalog konnte nicht gelesen werden. Bitte versuchen Sie es erneut.';

  @override
  String get repository_save_failed =>
      'Der Speichervorgang wurde nicht abgeschlossen. Überprüfen Sie Ihre Repository-Liste.';

  @override
  String get repository_paste_hint =>
      'Fügen Sie einen Link zum Repository-Katalog eines Drittanbieters ein';

  @override
  String get repository_address => '-Repository URL';

  @override
  String get repository_paste_link => 'Link einfügen';

  @override
  String repository_recognized(String type) {
    return '$type · Katalog erkannt';
  }

  @override
  String get repository_choose_sources_hint =>
      'Wählen Sie nach dem Hinzufügen des Repositorys die benötigten Quellen aus.';

  @override
  String get search_scope => 'Suchumfang';

  @override
  String get search_scope_hint =>
      'Wählen Sie die zu durchsuchenden Websites aus';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Durchsuchen Sie $count-Websites',
      one: '1 Website durchsuchen',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Eine Website finden';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Websites ausgewählt',
      one: '1 Website ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Klar';

  @override
  String get search_deselect_results => 'Passende Websites abwählen';

  @override
  String get search_select_results => 'Passende Websites auswählen';

  @override
  String get search_no_websites_hint =>
      'Keine passenden Websites. Versuchen Sie es mit einem anderen Namen oder einer anderen Sprache.';

  @override
  String get search_select_website_hint =>
      'Wählen Sie mindestens eine Website zum Durchsuchen aus.';

  @override
  String get search_start_title =>
      'Geben Sie Schlüsselwörter ein, um Titel zu finden';

  @override
  String get search_start_hint =>
      'Durchsuchen Sie mehrere Websites gleichzeitig und zeigen Sie passende Titel an.';

  @override
  String get search_empty_scope =>
      'Keine durchsuchbaren Websites in diesem Bereich';

  @override
  String get search_empty_scope_hint =>
      'Wechseln Sie zu allen Websites oder wählen Sie Websites zum Durchsuchen aus.';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ergebnisse',
      one: '1 Ergebnis',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'Titel suchen';

  @override
  String get search_actions => 'Suchaktionen';

  @override
  String get search_details => 'Suchdetails';

  @override
  String get search_title_hint => 'Suche nach Titel';

  @override
  String get search_searching => 'Suchen';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ergebnisse gefunden',
      one: '1 Ergebnis gefunden',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'Keine passenden Ergebnisse';

  @override
  String get search_failed => 'Suche fehlgeschlagen';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Titel gefunden',
      one: '1 Titel gefunden',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: '$websites Websites',
      one: '1 Website',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Titel finden';

  @override
  String get search_complete => 'Suche abgeschlossen';

  @override
  String get search_in_progress => 'Suchen';

  @override
  String get search_finding_related => 'Auf der Suche nach passenden Titeln…';

  @override
  String get search_no_results_yet => 'Noch keine Suchergebnisse';

  @override
  String get search_no_matching_titles => 'Keine passenden Titel gefunden';

  @override
  String get search_results_appear_hint =>
      'Die Ergebnisse werden hier angezeigt, sobald sie gefunden wurden.';

  @override
  String get search_failed_websites_hint =>
      'Einige Websites konnten die Suche nicht abschließen. Versuchen Sie es erneut in den Suchdetails.';

  @override
  String get search_change_keywords_hint =>
      'Versuchen Sie es mit kürzeren Schlüsselwörtern oder durchsuchen Sie weitere Websites.';

  @override
  String get search_view_details => 'Suchdetails anzeigen';

  @override
  String get search_adjust_scope => 'Passen Sie den Suchumfang an';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Websites',
      one: '1 Website',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Abgeschlossen $completed / $total';
  }

  @override
  String get search_retry_website_hint =>
      'Versuchen Sie fehlgeschlagene Websites einzeln erneut';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Elemente ausgewählt',
      one: '1 Element ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Sprachen suchen';

  @override
  String get source_deselect => 'Abwählen';

  @override
  String get source_select => 'Quelle auswählen';

  @override
  String get source_multilingual => 'Mehrsprachig';

  @override
  String get source_language_unknown => 'Sprache nicht angegeben';

  @override
  String get source_adult_content => 'Enthält 18+ Inhalte';

  @override
  String get source_classification_unknown => 'Klassifizierung nicht angegeben';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle Quellinformationen anzeigen, $count weitere Kategorien',
      one: 'Alle Quellinformationen anzeigen, 1 weitere Kategorie',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Website wird geladen';

  @override
  String get source_unpin => 'Lösen';

  @override
  String get source_pin => 'Stift';

  @override
  String get source_open => 'Öffnen';

  @override
  String get source_metadata_hint =>
      'Informationen stammen aus dem Quellkatalog. Kategorien beschreiben den von der Website abgedeckten Inhalt.';

  @override
  String get source_region => 'Region';

  @override
  String get source_format => 'Format';

  @override
  String get source_creation => 'Schöpfung';

  @override
  String get source_unspecified => 'Nicht angegeben';

  @override
  String get source_pricing => 'Preise';

  @override
  String get source_region_jp => 'Japanische Comics';

  @override
  String get source_region_kr => 'Koreanische Comics';

  @override
  String get source_region_cn => 'Chinesische Comics';

  @override
  String get source_region_hk_tw => 'Comics aus Hongkong und Taiwan';

  @override
  String get source_region_western => 'Western-Comics';

  @override
  String get source_region_other => 'Andere Regionen';

  @override
  String get source_format_page => 'Seitliche Comics';

  @override
  String get source_format_vertical => 'Vertikale Comics';

  @override
  String get source_format_strip => 'Comicstrips';

  @override
  String get source_creation_original => 'Original';

  @override
  String get source_creation_fan => 'Lüfter funktioniert';

  @override
  String get source_free_watch => 'Kostenlos anzusehen';

  @override
  String get source_free_read => 'Frei lesbar';

  @override
  String get source_partial_paid => 'Teilweise bezahlt';

  @override
  String get source_paid_watch => 'Bezahlte Besichtigung';

  @override
  String get source_paid_read => 'Bezahlte Lektüre';

  @override
  String get source_pricing_unknown => 'Preise nicht angegeben';

  @override
  String get source_language_filter => 'Nach Sprache filtern';

  @override
  String get source_language_filter_hint =>
      'Filtern Sie nur diesen Katalog. Installierte Quellen sind davon nicht betroffen.';

  @override
  String get source_all_languages => 'Alle Sprachen';

  @override
  String get action_apply => 'Anwenden';

  @override
  String get source_load_retry =>
      'Diese Website konnte nicht geladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get source_catalog_refresh_failed =>
      'Der Katalog konnte nicht aktualisiert werden. Aktuelle Inhalte bleiben erhalten. Zum erneuten Versuch nach unten ziehen.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-Quellen deinstallieren?',
      one: '1 Quelle deinstallieren?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Deinstallieren Sie die ausgewählten Quellen und löschen Sie ihre Einstellungen. Behalten Sie Bibliothekstitel und Downloads.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aktionen für $count-Quellen sind fehlgeschlagen.',
      one: 'Aktion für 1 Quelle fehlgeschlagen.',
    );
    return '$_temp0 Auswahl beibehalten. Bitte versuchen Sie es erneut.';
  }

  @override
  String get source_latest_content => 'Aktueller Inhalt';

  @override
  String get source_actions => 'Quellaktionen';

  @override
  String get source_bulk_manage => 'Mehrere Quellen verwalten';

  @override
  String get source_update_installed => 'Installierte Quellen aktualisieren';

  @override
  String get source_no_matching_websites => 'Keine passenden Websites';

  @override
  String get source_no_websites => 'Keine Websites verfügbar';

  @override
  String get source_search_installed_hint =>
      'Titel in installierten Quellen suchen';

  @override
  String get source_global_search => 'Quellenübergreifend suchen';

  @override
  String get source_manage_repositories => 'Repositories verwalten';

  @override
  String get source_view_third_party => 'Quellen von Drittanbietern anzeigen';

  @override
  String get source_catalog_load_failed =>
      'Der Katalog konnte nicht geladen werden. Zum erneuten Versuch nach unten ziehen.';

  @override
  String get source_all_websites => 'Alle Websites';

  @override
  String get source_available => 'Zur Installation verfügbar';

  @override
  String get source_third_party => 'Drittanbieter';

  @override
  String get source_name_or_title => 'Name oder Titel der Website';

  @override
  String get view_all => 'Alle anzeigen';

  @override
  String get search_searching_ellipsis => 'Suche...';

  @override
  String onboarding_untested_content(String type) {
    return '$type · Ungetestet';
  }

  @override
  String get onboarding_untested => 'Ungetestet';

  @override
  String get source_custom_scope => 'Benutzerdefiniert';

  @override
  String get source_custom_websites => 'Ausgewählte Websites';

  @override
  String get tv_hidden_library_hint =>
      'Jeder Titel befindet sich in einer versteckten Kategorie.\nHalten Sie OK bei „Alle“ gedrückt, um eines einzublenden.';

  @override
  String get tv_no_matching_anime => 'Kein passender Anime';

  @override
  String tv_no_matching_category(String category) {
    return 'Kein passender Anime in „$category“';
  }

  @override
  String get tv_filtered_empty_hint =>
      'Kein Anime entspricht den aktuellen Filtern.\nÄndern Sie sie über die Schaltfläche neben der Suche.';

  @override
  String get tv_new_episodes => 'Neue Episoden';

  @override
  String get tv_recently_added => 'Kürzlich hinzugefügt';

  @override
  String get tv_empty_category_hint =>
      'Noch kein Anime in dieser Kategorie.\nFügen Sie Titel über die Detailseite eines Titels hinzu.';

  @override
  String get tv_empty_library => 'Deine Anime-Bibliothek ist leer';

  @override
  String get tv_empty_library_hint =>
      'Fügen Sie Anime aus „Durchsuchen“ hinzu, um Ihr Zuhause zu füllen';

  @override
  String get tv_browse_anime => 'Anime durchsuchen';

  @override
  String tv_new_count(int count) {
    return '$count neu';
  }

  @override
  String tv_category_hidden(String category) {
    return '„$category“ ausgeblendet · Halten Sie OK bei „Alle“ gedrückt, um es einzublenden';
  }

  @override
  String get tv_no_hidden_categories => 'Keine versteckten Kategorien';

  @override
  String get import_torrent_file => '.torrent-Datei importieren';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi und mehr';

  @override
  String get cloudflare_proxy_optional => 'Optional FlareSolverr / Byparr URL';

  @override
  String get tv_home_layout_hint =>
      'Zeilenbasiertes Anime-Home (Weiter · Neue Episoden · Kategorien) anstelle des flachen Rasters';

  @override
  String get tv_hide_libraries_hint =>
      'Manga- und Romanbibliotheken ausblenden (im Fernsehen standardmäßig aktiviert)';

  @override
  String get anime_only_hint =>
      'Mangas und Romane in der App ausblenden. Schalten Sie die Option aus, um alles anzuzeigen.';

  @override
  String get audio_auto_safe => 'Automatisch sicher';

  @override
  String get tv_player_hint =>
      'Ein: dedizierter TV-Player.  Aus: Original-(Desktop-)Player.';

  @override
  String get release_open_failed => 'Release konnte nicht geöffnet werden';

  @override
  String get tv_replay => 'Wiederholung';

  @override
  String get tv_no_episodes => 'Noch keine Folgen';

  @override
  String get tracker_continue_series => 'Serien weiterhin ansehen';

  @override
  String get tracker_watchlist_series => 'Watchlist-Serie';

  @override
  String get tracker_continue_movies => 'Schauen Sie sich weiterhin Filme an';

  @override
  String get tracker_watchlist_movies => 'Watchlist-Filme';

  @override
  String get tracker_trending_series => 'Trendserie';

  @override
  String get tracker_trending_movies => 'Trendfilme';

  @override
  String get tracker_popular_series => 'Beliebte Serien';

  @override
  String get tracker_popular_movies => 'Beliebte Filme';

  @override
  String get tracker_top_series => 'Top-Serie (aller Zeiten)';

  @override
  String get tracker_top_movies => 'Top-Filme (aller Zeiten)';

  @override
  String get tracker_airing_series => 'Ausstrahlungsserie';

  @override
  String get tracker_airing_anime => 'Ausstrahlung von Anime';

  @override
  String get tracker_popular_anime => 'Beliebter Anime';

  @override
  String get tracker_upcoming_anime => 'Kommender Anime';

  @override
  String get tracker_popular_manga => 'Beliebter Manga';

  @override
  String get tracker_top_manga => 'Top Manga';

  @override
  String get tracker_top_manhwa => 'Top Manhwa';

  @override
  String get tracker_top_manhua => 'Oberes Manhua';

  @override
  String get tracker_latest_anime => 'Neuester Anime';

  @override
  String get tracker_best_anime => 'Am besten bewerteter Anime';

  @override
  String get tracker_latest_manga => 'Neuester Manga';

  @override
  String get tracker_best_manga => 'Bestbewerteter Manga';

  @override
  String get tracker_trending_anime => 'Trend-Anime';

  @override
  String get tracker_upcoming_manga => 'Kommender Manga';

  @override
  String get tracker_trending_manga => 'Trend-Manga';

  @override
  String selection_progress(int selected, int total) {
    return '$selected/$total ausgewählt';
  }

  @override
  String get source_code_editor => 'Code-Editor';

  @override
  String get source_code_execute => 'Ausführen';

  @override
  String get source_console_logs => 'Konsolenprotokolle';

  @override
  String get source_no_logs => 'Noch keine Protokolle';

  @override
  String get source_updated_successfully => 'Quelle erfolgreich aktualisiert';

  @override
  String get source_obsolete => 'VERALTET';

  @override
  String player_seek_forward_seconds(int seconds) {
    return '$seconds Sekunden vorwärts suchen';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return '$seconds Sekunden rückwärts suchen';
  }

  @override
  String get player_autoplay_on => 'Nächste Folge automatisch abspielen: Ein';

  @override
  String get player_autoplay_off => 'Nächste Folge automatisch abspielen: aus';

  @override
  String get player_no_other_quality => 'Keine andere Qualität';

  @override
  String get player_no_subtitles => 'Keine Untertitel';

  @override
  String get player_no_audio_tracks => 'Keine Audiospuren';

  @override
  String get player_seek_forward => 'Nach vorne schauen';

  @override
  String get player_seek_backward => 'Rückwärts suchen';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds Sekunden',
      one: '1 Sekunde',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'Lorem ipsum dolor sit amet';

  @override
  String get subtitle_style => 'Stil';

  @override
  String get translation_official_channel => 'NodeLane Offiziell';

  @override
  String get translation_auth_required =>
      'Melden Sie sich zunächst bei Ihrem Übersetzungskonto an.';

  @override
  String get translation_source_changed =>
      'Das Originalbild wurde geändert. Bitte laden Sie es neu.';

  @override
  String get translation_source_missing =>
      'Das Originalbild ist derzeit nicht verfügbar.';

  @override
  String get translation_resource_limit =>
      'Dieses Bild überschreitet die Verarbeitungsgrenze des Geräts. Das Original bleibt erhalten.';

  @override
  String get translation_storage_full =>
      'Der Übersetzungsspeicher ist voll. Löschen Sie zunächst die übersetzten Bilder.';

  @override
  String get translation_invalid_image => 'Ungültiges Bildformat oder Inhalt.';

  @override
  String get translation_unsupported_image =>
      'Die Übersetzung wird für dieses Bild nicht unterstützt. Das Original bleibt erhalten.';

  @override
  String get translation_invalid_result =>
      'Die Validierung des übersetzten Bildes ist fehlgeschlagen. Bitte laden Sie es neu.';

  @override
  String get translation_result_unavailable =>
      'Das übersetzte Bild ist nicht verfügbar. Bitte laden Sie es neu.';

  @override
  String get translation_result_expired =>
      'Das übersetzte Bild ist abgelaufen. Bitte übersetzen Sie es noch einmal.';

  @override
  String get translation_analysis_too_large =>
      'Es ist zu viel Bildinhalt für die Analyse vorhanden. Reduzieren Sie die Bildgröße und versuchen Sie es erneut.';

  @override
  String get translation_region_limit =>
      'Das Bild enthält zu viele Textbereiche. Teilen Sie es auf und versuchen Sie es erneut.';

  @override
  String get translation_text_limit =>
      'Ein Textbereich ist zu lang. Passen Sie das Bild an und versuchen Sie es erneut.';

  @override
  String get translation_unavailable =>
      'Diese Übersetzung ist nicht mehr verfügbar.';

  @override
  String get translation_outcome_unknown =>
      'Das Ergebnis muss überprüft werden. Es wurde nicht erneut eingereicht.';

  @override
  String get translation_rate_limited =>
      'Die Anfragen sind begrenzt. Die Übersetzung wird automatisch fortgesetzt.';

  @override
  String get translation_quota_exhausted => 'Unzureichende Übersetzungsquote.';

  @override
  String get translation_unsupported_language =>
      'Der Dienst unterstützt diese Zielsprache nicht.';

  @override
  String get translation_upgrade_required =>
      'Das Übersetzungsprotokoll ist inkompatibel. Aktualisieren Sie die App.';

  @override
  String get translation_remote_failed =>
      'Die Übersetzung dieser Seite ist fehlgeschlagen. Sie können es manuell erneut versuchen.';

  @override
  String get translation_bridge_invalid =>
      'Die Webseite hat sich geändert. Aktivieren Sie die Übersetzung erneut.';

  @override
  String get translation_connection_failed =>
      'Verbindung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get translation_paused =>
      'Übersetzung pausiert. Sie können den Fortschritt überprüfen.';

  @override
  String get translation_preparing_ellipsis => 'Übersetzung wird vorbereitet…';

  @override
  String get translation_checking_original => 'Originalbild prüfen…';

  @override
  String get translation_submitting => 'Einreichen…';

  @override
  String get translation_uploading_ellipsis => 'Original wird hochgeladen…';

  @override
  String get translation_waiting_ellipsis => 'Warten auf Übersetzung…';

  @override
  String get translation_running_ellipsis => 'Übersetzen…';

  @override
  String get translation_verify_result => 'Das Ergebnis muss überprüft werden';

  @override
  String get translation_partial => 'Einige Inhalte wurden übersetzt';

  @override
  String get translation_ready => 'Übersetztes Bild bereit';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Spielen';

  @override
  String get player_quality => 'Qualität';

  @override
  String get player_subtitles => 'Untertitel';

  @override
  String get player_audio => 'Audio';

  @override
  String get player_statistics => 'Statistiken für Nerds';

  @override
  String get player_auto => 'Auto';

  @override
  String get source_information => 'Quellenangaben';

  @override
  String get source_code_page => 'Seite';

  @override
  String get source_code_query => 'Abfrage';

  @override
  String get repository_invalid_source =>
      'Ungültige Quelle – entfernen Sie sie';

  @override
  String get player_fit_contain => 'Enthalten';

  @override
  String get player_fit_cover => 'Abdeckung';

  @override
  String get player_fit_fill => 'Füllen';

  @override
  String get player_fit_height => 'Höhe';

  @override
  String get player_fit_width => 'Breite';

  @override
  String get player_fit_scale => 'Maßstab';

  @override
  String get player_fit_none => 'Keine';

  @override
  String get player_shader_clear => 'Aus (Shader löschen)';

  @override
  String get player_shader_luma => 'Luma-Upscaling';

  @override
  String get player_decoder_auto => 'Auto (Hardware)';

  @override
  String get player_decoder_software => 'Software (keine Hardware)';

  @override
  String get player_stats_toggle => 'Overlay umschalten';

  @override
  String get player_stats_general => 'Allgemein';

  @override
  String get player_stats_frames => 'Frame-Timings';

  @override
  String get player_stats_cache => 'Eingabecache';

  @override
  String get player_stats_filters => 'Aktive Filter';

  @override
  String get player_stats_log => 'Protokoll';

  @override
  String get source_mark_pinned => 'Stift';

  @override
  String translation_image_action(String action) {
    return '$action dieses Bild';
  }

  @override
  String get memory_waiting => 'Speicher: Warten auf eine Probe';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current Spitze $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'Cache $current / $limit Peak $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'Artikel $count / $limit live $live Peak $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Proben',
      one: '1 Probe',
    );
    return 'volle $percent% von $_temp0';
  }

  @override
  String get memory_reset_hint =>
      'Schalten Sie es in den Einstellungen aus und wieder ein, um es zurückzusetzen';

  @override
  String get action_hide => 'Verstecken';

  @override
  String discord_get_app(String app) {
    return 'Holen Sie sich $app';
  }

  @override
  String get discord_idle => 'Leerlauf';

  @override
  String discord_watching_title(String title) {
    return '$title ansehen';
  }

  @override
  String discord_reading_title(String title) {
    return 'Lesen von $title';
  }
}
