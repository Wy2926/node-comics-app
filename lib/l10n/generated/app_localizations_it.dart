// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get app_update_details_hint =>
      'Visualizza le note sulla versione e le opzioni di installazione';

  @override
  String get app_update_download => 'Scarica l\'aggiornamento';

  @override
  String get app_update_download_hint =>
      'Dopo il download, seguire le istruzioni per installare l\'aggiornamento.';

  @override
  String get bookshelf_all => 'Tutti';

  @override
  String get bookshelf_search => 'Cerca nella libreria';

  @override
  String get app_update_allow_install =>
      'Consenti l\'installazione dell\'app nelle impostazioni di sistema, quindi torna indietro e tocca Installa.';

  @override
  String get app_update_waiting =>
      'In attesa che il sistema riprenda il download…';

  @override
  String get app_update_cancel_download => 'Annullare il download';

  @override
  String get app_update_remove_package => 'Rimuovere il pacchetto scaricato';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'Nessuna impostazione corrispondente';

  @override
  String get search_empty_hint =>
      'Prova un\'altra parola chiave o cancella la ricerca per vedere tutto.';

  @override
  String get search_clear => 'Cancella ricerca';

  @override
  String get app_updates => 'Aggiornamenti dell\'app';

  @override
  String get app_update_auto => 'Controllo al lancio';

  @override
  String get app_update_view => 'Visualizza aggiornamento';

  @override
  String get app_update_later => 'Più tardi';

  @override
  String get app_update_external_hint =>
      'Apre il collegamento di aggiornamento nel browser';

  @override
  String get app_update_failed =>
      'Impossibile verificare la presenza di aggiornamenti. Per favore riprova.';

  @override
  String get app_update_opened => 'Collegamento di aggiornamento aperto';

  @override
  String get app_diagnostics => 'Diagnostica e registri';

  @override
  String get library => 'Biblioteca';

  @override
  String get updates_search => 'Aggiornamenti della ricerca';

  @override
  String get updates => 'Aggiornamenti';

  @override
  String get history => 'Cronologia';

  @override
  String get browse => 'Sfoglia';

  @override
  String get more => 'Altro';

  @override
  String get open_random_entry => 'Apri voce casuale';

  @override
  String get import => 'Importa';

  @override
  String get filter => 'Filtro';

  @override
  String get ignore_filters => 'Ignora filtri';

  @override
  String get downloaded => 'Scaricato';

  @override
  String get unread => 'Non letto';

  @override
  String get unwatched => 'Non guardato';

  @override
  String get started => 'Iniziato';

  @override
  String get bookmarked => 'Segnalibro';

  @override
  String get sort => 'Ordina';

  @override
  String get alphabetically => 'Alfabeticamente';

  @override
  String get last_read => 'Ultima lettura';

  @override
  String get last_watched => 'Ultima visione';

  @override
  String get last_update_check => 'Ultimo controllo aggiornamenti';

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
          'Stai eliminando tutti e $count $entryTypePlural di questo $mediaType dalla tua libreria.',
      one:
          'Stai eliminando l’unico $entryType di questo $mediaType dalla tua libreria.',
    );
    return '$_temp0\nQuesto rimuoverà anche tutto il $mediaType dalla tua libreria.\n\nNota: I file non saranno eliminati.';
  }

  @override
  String get chapter => 'capitolo';

  @override
  String get episode => 'episodio';

  @override
  String get unread_count => 'Conteggio non letti';

  @override
  String get unwatched_count => 'Conteggio non guardati';

  @override
  String get latest_chapter => 'Ultimo capitolo';

  @override
  String get latest_episode => 'Ultimo episodio';

  @override
  String get date_added => 'Data aggiunta';

  @override
  String get display => 'Visualizza';

  @override
  String get display_mode => 'Modalità visualizzazione';

  @override
  String get compact_grid => 'Griglia compatta';

  @override
  String get compression_level => 'Livello di compressione';

  @override
  String compression_info(Object level) {
    return 'Maggiore è la compressione, minore sarà lo spazio occupato dal backup, ma richiederà più CPU. Predefinito: $level';
  }

  @override
  String get comfortable_grid => 'Griglia confortevole';

  @override
  String get cover_only_grid => 'Griglia solo copertina';

  @override
  String get list => 'Lista';

  @override
  String get badges => 'Distintivi';

  @override
  String get downloaded_chapters => 'Capitoli scaricati';

  @override
  String get downloaded_episodes => 'Episodi scaricati';

  @override
  String get language => 'Lingua';

  @override
  String get local_source => 'Fonte locale';

  @override
  String get tabs => 'Schede';

  @override
  String get show_category_tabs => 'Mostra schede categoria';

  @override
  String get show_numbers_of_items => 'Mostra numeri degli elementi';

  @override
  String get other => 'Altro';

  @override
  String get show_continue_reading_buttons =>
      'Mostra pulsanti di lettura continua';

  @override
  String get show_continue_watching_buttons =>
      'Mostra pulsanti continua a guardare';

  @override
  String get empty_library => 'Biblioteca vuota';

  @override
  String get search => 'Cerca...';

  @override
  String get no_recent_updates => 'Nessun aggiornamento recente';

  @override
  String get remove_everything => 'Rimuovi tutto';

  @override
  String get remove_everything_msg =>
      'Sei sicuro? Tutta la cronologia sarà persa';

  @override
  String get remove_all_update_msg =>
      'Sei sicuro? L\'intero aggiornamento verrà eliminato';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annulla';

  @override
  String get remove => 'Rimuovi';

  @override
  String get remove_history_msg =>
      'Questo rimuoverà la data di lettura di questo capitolo. Sei sicuro?';

  @override
  String get last_used => 'Ultimo usato';

  @override
  String get pinned => 'Fissato';

  @override
  String get sources => 'Fonti';

  @override
  String get install => 'Installa';

  @override
  String get update => 'Aggiorna';

  @override
  String get latest => 'Più recente';

  @override
  String get extensions => 'Estensioni';

  @override
  String get migrate => 'Migra';

  @override
  String get mass_migration_title => 'Migrazione di massa';

  @override
  String get mass_migration_preview_items => 'Anteprima elementi';

  @override
  String get mass_migration_destination_source => 'Fonte di destinazione';

  @override
  String get mass_migration_no_library_items =>
      'Nessun elemento della libreria disponibile per la migrazione di massa.';

  @override
  String get mass_migration_no_destination_sources =>
      'Nessuna fonte di destinazione installata disponibile.';

  @override
  String get mass_migration_installed => 'Installato';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementi pronti per la revisione',
      one: '1 elemento pronto per la revisione',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementi',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Seleziona fonte di destinazione';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Ricerca corrispondenze in $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Elaborazione elemento $current di $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Attesa di 2 secondi prima del prossimo elemento...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Attesa di 2 secondi prima della prossima migrazione...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Corrispondenze trovate finora: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Nessuna corrispondenza: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Rivedi corrispondenze per $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Corrispondenze trovate: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Nessuna corrispondenza: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Selezionati per la migrazione: $count';
  }

  @override
  String get mass_migration_finish_review => 'Termina revisione';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migra elementi selezionati ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Migrazione degli elementi selezionati verso $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Nessun elemento selezionato per la migrazione.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migrazione elemento $current di $total';
  }

  @override
  String get mass_migration_complete => 'Migrazione di massa completata';

  @override
  String get mass_migration_complete_success_message =>
      'Tutti gli elementi selezionati sono stati elaborati correttamente.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migrazione terminata con alcuni elementi che richiedono attenzione manuale.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Elaborati';

  @override
  String get mass_migration_matched => 'Corrispondenti';

  @override
  String get mass_migration_migrated => 'Migrati';

  @override
  String get mass_migration_skipped => 'Salati';

  @override
  String get mass_migration_failed => 'Falliti';

  @override
  String get mass_migration_failed_items => 'Elementi falliti';

  @override
  String get mass_migration_exit => 'Esci dalla migrazione di massa';

  @override
  String get mass_migration_no_destination_match =>
      'Nessuna corrispondenza nella destinazione';

  @override
  String mass_migration_query(Object query) {
    return 'Query: $query';
  }

  @override
  String get mass_migration_skip => 'Salta';

  @override
  String get mass_migration_loading => 'Caricamento...';

  @override
  String get mass_migration_choose_another_result =>
      'Scegli un altro risultato';

  @override
  String get mass_migration_source_chapters => 'Capitoli sorgente';

  @override
  String get mass_migration_destination_chapters => 'Capitoli destinazione';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capitoli',
      one: '1 capitolo',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capitoli sorgente',
      one: '1 capitolo sorgente',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capitoli destinazione',
      one: '1 capitolo destinazione',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Nessun capitolo trovato.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'E altri $count...';
  }

  @override
  String get mass_migration_unknown_title => 'Titolo sconosciuto';

  @override
  String get mass_migration_unknown_match => 'Corrispondenza sconosciuta';

  @override
  String get mass_migration_unknown_source => 'Fonte sconosciuta';

  @override
  String get mass_migration_unknown_chapter => 'Capitolo sconosciuto';

  @override
  String get migrate_confirm => 'Migrare a un\'altra fonte';

  @override
  String get clean_database => 'Pulire il database';

  @override
  String cleaned_database(Object x) {
    return 'Database pulito! $x voci rimosse';
  }

  @override
  String get clean_database_desc =>
      'Questo eliminerà tutti gli elementi che non sono stati aggiunti alla libreria!';

  @override
  String get incognito_mode => 'Modalità Incognito';

  @override
  String get incognito_mode_description => 'Sospende la cronologia di lettura';

  @override
  String get downloaded_only => 'Solo scaricati';

  @override
  String get downloaded_only_description =>
      'Mostra solo le voci scaricate nella tua libreria';

  @override
  String get download_queue => 'Coda di download';

  @override
  String get categories => 'Categorie';

  @override
  String get statistics => 'Statistiche';

  @override
  String get settings => 'Impostazioni';

  @override
  String get about => 'Informazioni';

  @override
  String get help => 'Aiuto';

  @override
  String get no_downloads => 'Nessun download';

  @override
  String get edit_categories => 'Modifica categorie';

  @override
  String get edit_categories_description =>
      'Non hai categorie. Tocca il pulsante più per crearne una per organizzare la tua biblioteca';

  @override
  String get add => 'Aggiungi';

  @override
  String get add_category => 'Aggiungi categoria';

  @override
  String get name => 'Nome';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Richiesto';

  @override
  String get add_category_error_exist =>
      'Una categoria con questo nome esiste già!';

  @override
  String get delete_category => 'Elimina categoria';

  @override
  String delete_category_msg(Object name) {
    return 'Vuoi eliminare la categoria $name?';
  }

  @override
  String get rename_category => 'Rinomina categoria';

  @override
  String get general => 'Generale';

  @override
  String get general_subtitle => 'Lingua app';

  @override
  String get app_language => 'Lingua app';

  @override
  String get default_subtitle_language => 'Lingua predefinita dei sottotitoli';

  @override
  String get appearance => 'Aspetto';

  @override
  String get appearance_subtitle => 'Tema, formato data e ora';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Modalità scura';

  @override
  String get follow_system_theme => 'Segui il tema del sistema';

  @override
  String get on => 'Attivo';

  @override
  String get off => 'Disattivo';

  @override
  String get pure_black_dark_mode => 'Modalità scura nero puro';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get relative_timestamp => 'Timestamp relativo';

  @override
  String get relative_timestamp_short => 'Breve (Oggi, Ieri)';

  @override
  String get relative_timestamp_long => 'Lungo (Breve+, n giorni fa)';

  @override
  String get date_format => 'Formato data';

  @override
  String get reader => 'Lettore';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get reader_subtitle =>
      'Modalità di lettura, visualizzazione, navigazione';

  @override
  String get default_reading_mode => 'Modalità di lettura predefinita';

  @override
  String get reading_mode_vertical => 'Verticale';

  @override
  String get reading_mode_horizontal => 'Orizzontale';

  @override
  String get reading_mode_left_to_right => 'Da sinistra a destra';

  @override
  String get reading_mode_right_to_left => 'Da destra a sinistra';

  @override
  String get reading_mode_vertical_continuous => 'Verticale continuo';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Velocità animazione doppio tocco';

  @override
  String get normal => 'Normale';

  @override
  String get fast => 'Veloce';

  @override
  String get no_animation => 'Nessuna animazione';

  @override
  String get animate_page_transitions => 'Anima transizioni pagina';

  @override
  String get crop_borders => 'Taglia bordi';

  @override
  String get downloads => 'Download';

  @override
  String get downloads_subtitle => 'Impostazioni download';

  @override
  String get download_location => 'Posizione download';

  @override
  String get custom_location => 'Posizione personalizzata';

  @override
  String get only_on_wifi => 'Solo su wifi';

  @override
  String get save_as_cbz_archive => 'Salva come archivio CBZ';

  @override
  String get delete_download_after_reading =>
      'Elimina download dopo la lettura';

  @override
  String get concurrent_downloads => 'Download simultanei';

  @override
  String get browse_subtitle => 'Fonti, ricerca globale';

  @override
  String get only_include_pinned_sources => 'Includi solo fonti fissate';

  @override
  String get nsfw_sources => 'Fonti NSFW (+18)';

  @override
  String get nsfw_sources_show => 'Mostra nelle liste di fonti ed estensioni';

  @override
  String get nsfw_sources_info =>
      'Ciò non impedisce che estensioni non ufficiali o potenzialmente contrassegnate in modo errato mostrino contenuti NSFW (18+) all\'interno dell\'app';

  @override
  String get version => 'Versione';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Controlla aggiornamenti';

  @override
  String get logs_on => 'Abilita registrazione';

  @override
  String get share_app_logs => 'Condividi i log dell\'app';

  @override
  String get no_app_logs => 'Nessun file log.txt disponibile!';

  @override
  String get failed => 'Fallito!';

  @override
  String n_days_ago(Object days) {
    return '$days giorni fa';
  }

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get a_week_ago => 'Una settimana fa';

  @override
  String get next_week => 'Prossima settimana';

  @override
  String get add_to_library => 'Aggiungi alla biblioteca';

  @override
  String get completed => 'Completato';

  @override
  String get ongoing => 'In corso';

  @override
  String get on_hiatus => 'In pausa';

  @override
  String get canceled => 'Annullato';

  @override
  String get publishing_finished => 'Pubblicazione completata';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get empty_placeholder => 'VUOTO';

  @override
  String get error => 'Errore';

  @override
  String error_with_message(Object error) {
    return 'Errore: $error';
  }

  @override
  String get no_pages_available => 'Errore: nessuna pagina disponibile';

  @override
  String get set_categories => 'Imposta categorie';

  @override
  String get edit => 'Modifica';

  @override
  String get in_library => 'Nella libreria';

  @override
  String get filter_scanlator_groups => 'Filtra gruppi scanlator';

  @override
  String get reset => 'Reset';

  @override
  String get by_source => 'Per fonte';

  @override
  String get by_chapter_number => 'Per numero di capitolo';

  @override
  String get by_episode_number => 'Per numero di episodio';

  @override
  String get by_upload_date => 'Per data di caricamento';

  @override
  String get source_title => 'Titolo della fonte';

  @override
  String get create_extension => 'Crea estensione';

  @override
  String get developer_mode => 'Modalità sviluppatore';

  @override
  String get developer_mode_subtitle =>
      'Mostra gli strumenti di sviluppo per estensioni (crea estensione, modifica codice)';

  @override
  String get choose_extension_language => 'Scegli lingua dell\'estensione';

  @override
  String get lang => 'Lingua';

  @override
  String get base_url => 'URL base';

  @override
  String get api_url_optional => 'URL API (opzionale)';

  @override
  String get icon_url => 'URL icona';

  @override
  String get source_icon_url => 'URL icona sorgente';

  @override
  String get notes => 'Note';

  @override
  String get extension_name_example => 'es: mioAnime';

  @override
  String get language_code_example => 'es: it';

  @override
  String get base_url_example => 'es: https://esempio.it';

  @override
  String get api_url_example => 'es: https://api.esempio.it';

  @override
  String get extension_notes_example =>
      'es: questa estensione richiede l\'accesso';

  @override
  String get type => 'Tipo';

  @override
  String get target => 'Destinazione';

  @override
  String get source_type_single => 'singola';

  @override
  String get source_type_multi => 'multipla';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS compilato LNReader';

  @override
  String get source_created_successfully => 'Sorgente creata con successo';

  @override
  String get source_already_exists => 'La sorgente esiste già';

  @override
  String get error_when_creating_source =>
      'Errore durante la creazione della sorgente';

  @override
  String get cookies_deleted => 'Cookie eliminati!';

  @override
  String get delete_all_cookies => 'Elimina tutti i cookie';

  @override
  String get chapter_number => 'Numero del capitolo';

  @override
  String get episode_number => 'Numero dell\'episodio';

  @override
  String get share => 'Condividi';

  @override
  String n_chapters(Object n) {
    return '$n capitoli';
  }

  @override
  String missing_chapters(Object count) {
    return '$count capitoli mancanti';
  }

  @override
  String get no_description => 'Nessuna descrizione';

  @override
  String get resume => 'Riprendi';

  @override
  String get read => 'Leggi';

  @override
  String get watch => 'Guarda';

  @override
  String get popular => 'Popolare';

  @override
  String get open_in_browser => 'Apri nel browser';

  @override
  String get clear_cookie => 'Cancella cookie';

  @override
  String get show_page_number => 'Mostra numero di pagina';

  @override
  String get from_library => 'Dalla libreria';

  @override
  String get downloaded_chapter => 'Capitolo scaricato';

  @override
  String page(Object page) {
    return 'Pagina $page';
  }

  @override
  String get global_search => 'Ricerca globale';

  @override
  String get color_blend_level => 'Livello di fusione colore';

  @override
  String current(Object char) {
    return 'Corrente $char';
  }

  @override
  String finished(Object char) {
    return 'Finito $char';
  }

  @override
  String next(Object char) {
    return 'Prossimo $char';
  }

  @override
  String previous(Object char) {
    return 'Precedente $char';
  }

  @override
  String get no_more_chapter => 'Non ci sono altri capitoli';

  @override
  String get no_result => 'Nessun risultato';

  @override
  String get send => 'Invia';

  @override
  String get delete => 'Elimina';

  @override
  String get start_downloading => 'Inizia a scaricare ora';

  @override
  String get retry => 'Riprova';

  @override
  String get add_chapters => 'Aggiungi capitoli';

  @override
  String get delete_chapters => 'Eliminare capitolo?';

  @override
  String get default0 => 'Predefinito';

  @override
  String get total_chapters => 'Totale capitoli';

  @override
  String get total_episodes => 'Episodi totali';

  @override
  String get import_local_file => 'Importa file locale';

  @override
  String get import_files => 'File';

  @override
  String get split_epub_chapters => 'Dividi in capitoli';

  @override
  String get split_epub_chapters_description =>
      'Importa ogni capitolo EPUB come voce separata';

  @override
  String get nothing_read_recently => 'Niente letto di recente';

  @override
  String get status => 'Stato';

  @override
  String get not_started => 'Non iniziato';

  @override
  String get score => 'Punteggio';

  @override
  String get start_date => 'Data di inizio';

  @override
  String get finish_date => 'Data di fine';

  @override
  String get reading => 'In lettura';

  @override
  String get on_hold => 'In attesa';

  @override
  String get dropped => 'Abbandonato';

  @override
  String get plan_to_read => 'Da leggere';

  @override
  String get re_reading => 'Rilettura';

  @override
  String get chapters => 'Capitoli';

  @override
  String get add_tracker => 'Aggiungi tracciamento';

  @override
  String get one_tracker => '1 tracciamento';

  @override
  String n_tracker(Object n) {
    return '$n tracciamenti';
  }

  @override
  String get tracking => 'Tracciamento';

  @override
  String get syncing => 'Sincronizzazione';

  @override
  String get sync_logged => 'Accesso riuscito';

  @override
  String get syncing_subtitle =>
      'Inserisci l’indirizzo del tuo server di sincronizzazione e accedi dal browser per sincronizzare i progressi di lettura tra i dispositivi.';

  @override
  String get sync_service => 'Sincronizzazione su server proprio';

  @override
  String get last_sync => 'Ultima sincronizzazione alle: ';

  @override
  String get sync_login_browser => 'Accedi con il browser';

  @override
  String get sync_server => 'Indirizzo del server di sincronizzazione';

  @override
  String get sync_starting => 'Avvio della sincronizzazione...';

  @override
  String get sync_finished => 'Sincronizzazione terminata';

  @override
  String get sync_failed => 'Sincronizzazione fallita';

  @override
  String get sync_restore_in_progress =>
      'Sincronizzazione saltata — ripristino in corso';

  @override
  String sync_progress_percent(Object percent) {
    return 'Sincronizzazione in corso… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Sincronizzazione in corso…';

  @override
  String get sync_button_sync => 'Sincronizza progressi';

  @override
  String get sync_button_upload => 'Solo carica';

  @override
  String get sync_button_upload_info =>
      'Questa operazione sostituirà completamente i dati remoti con i dati locali!';

  @override
  String get sync_button_download => 'Solo scarica';

  @override
  String get sync_button_download_info =>
      'Questa operazione sostituirà completamente i dati locali con i dati remoti!';

  @override
  String get sync_status_not_configured => 'Non connesso';

  @override
  String get sync_status_checking => 'Verifica connessione...';

  @override
  String get sync_status_connected => 'Connesso';

  @override
  String get sync_status_unauthorized =>
      'Sessione scaduta, effettua nuovamente l\'accesso';

  @override
  String get sync_status_unreachable => 'Server non raggiungibile';

  @override
  String get sync_section_general => 'Generale';

  @override
  String get sync_on => 'Abilita sincronizzazione';

  @override
  String get sync_auto => 'Sincronizzazione automatica';

  @override
  String get sync_auto_warning =>
      'La sincronizzazione automatica è attualmente una funzione sperimentale!';

  @override
  String get sync_auto_off => 'Disattivato';

  @override
  String get sync_auto_5_minutes => 'Ogni 5 minuti';

  @override
  String get sync_auto_10_minutes => 'Ogni 10 minuti';

  @override
  String get sync_auto_30_minutes => 'Ogni 30 minuti';

  @override
  String get sync_auto_1_hour => 'Ogni 1 ora';

  @override
  String get sync_auto_3_hours => 'Ogni 3 ore';

  @override
  String get sync_auto_6_hours => 'Ogni 6 ore';

  @override
  String get sync_auto_12_hours => 'Ogni 12 ore';

  @override
  String get server_error => 'Errore del server!';

  @override
  String get dialog_confirm => 'Conferma';

  @override
  String get description => 'Descrizione';

  @override
  String get reorder_navigation => 'Personalizza navigazione';

  @override
  String get reorder_navigation_description =>
      'Riorganizza e regola ogni navigazione in base alle tue esigenze.';

  @override
  String get floating_navigation_bar => 'Barra di navigazione mobile';

  @override
  String get floating_navigation_bar_description =>
      'Utilizzare una capsula mobile invece della barra di navigazione standard allegata.';

  @override
  String get full_screen_player => 'Usa schermo intero';

  @override
  String get full_screen_player_info =>
      'Usa automaticamente lo schermo intero durante la riproduzione di un video.';

  @override
  String episode_progress(Object n) {
    return 'Progresso: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n episodi';
  }

  @override
  String missing_episodes(Object count) {
    return '$count episodi mancanti';
  }

  @override
  String get manga_sources => 'Fonti Manga';

  @override
  String get anime_sources => 'Fonti Anime';

  @override
  String get novel_sources => 'Fonti romanzo';

  @override
  String get anime_extensions => 'Estensioni Anime';

  @override
  String get manga_extensions => 'Estensioni Manga';

  @override
  String get novel_extensions => 'Estensioni romanzo';

  @override
  String get extension_settings => 'Impostazioni estensione';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Romanzo';

  @override
  String get library_no_category_exist => 'Non hai ancora nessuna categoria';

  @override
  String get watching => 'Guardando';

  @override
  String get plan_to_watch => 'In programma di guardare';

  @override
  String get re_watching => 'Rivisualizzazione';

  @override
  String get episodes => 'Episodi';

  @override
  String get download => 'Scarica';

  @override
  String get new_update_available => 'Nuovo aggiornamento disponibile';

  @override
  String app_version(Object v) {
    return 'Versione dell\'app: v$v';
  }

  @override
  String get searching_for_updates => 'Ricerca aggiornamenti in corso...';

  @override
  String get no_new_updates_available =>
      'Nessun nuovo aggiornamento disponibile';

  @override
  String get uninstall => 'Disinstalla';

  @override
  String uninstall_extension(Object ext) {
    return 'Disinstallare estensione $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Tocca due volte per cercare in tutti i $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Mostra suggerimento ricerca con doppio tocco';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Mostra un suggerimento sulle destinazioni Manga/Anime/Romanzi spiegando che il doppio tocco apre la ricerca globale.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" è già nella tua libreria tramite $source.';
  }

  @override
  String get add_anyway => 'Aggiungi comunque';

  @override
  String get langauage => 'Lingua';

  @override
  String get extension_detail => 'Dettaglio estensione';

  @override
  String get scale_type => 'Tipo di scala';

  @override
  String get scale_type_fit_screen => 'Adatta allo schermo';

  @override
  String get scale_type_stretch => 'Stira';

  @override
  String get scale_type_fit_width => 'Adatta alla larghezza';

  @override
  String get scale_type_fit_height => 'Adatta all\'altezza';

  @override
  String get scale_type_original_size => 'Dimensione originale';

  @override
  String get scale_type_smart_fit => 'Adattamento intelligente';

  @override
  String get page_preload_amount => 'Quantità di pagine da precaricare';

  @override
  String get page_preload_amount_subtitle =>
      'Il numero di pagine da precaricare durante la lettura. Valori più alti risultano in un\'esperienza di lettura più fluida, a costo di un maggiore uso di cache e di rete.';

  @override
  String get image_loading_error => 'Questa immagine non può essere caricata';

  @override
  String get add_episodes => 'Aggiungi episodi';

  @override
  String get video_quality => 'Qualità';

  @override
  String get video_subtitle => 'Sottotitolo';

  @override
  String get check_for_extension_updates => 'Verifica aggiornamenti estensione';

  @override
  String get auto_extensions_updates =>
      'Aggiornamenti automatici delle estensioni';

  @override
  String get auto_extensions_updates_subtitle =>
      'Aggiorna automaticamente l\'estensione quando è disponibile una nuova versione.';

  @override
  String get check_for_app_updates =>
      'Controlla gli aggiornamenti dell\'app all\'avvio';

  @override
  String get reading_mode => 'Modalità di lettura';

  @override
  String get custom_filter => 'Filtro personalizzato';

  @override
  String get background_color => 'Colore di sfondo';

  @override
  String get white => 'Bianco';

  @override
  String get black => 'Nero';

  @override
  String get grey => 'Grigio';

  @override
  String get automaic => 'Automatico';

  @override
  String get preferred_domain => 'Dominio preferito';

  @override
  String get load_more => 'Carica altri';

  @override
  String get cancel_all_for_this_series => 'Annulla tutto per questa serie';

  @override
  String get login => 'Accedi';

  @override
  String login_into(Object tracker) {
    return 'Accedi a $tracker';
  }

  @override
  String get email_adress => 'Indirizzo email';

  @override
  String get password => 'Password';

  @override
  String log_out_from(Object tracker) {
    return 'Esci da $tracker?';
  }

  @override
  String get log_out => 'Esci';

  @override
  String get update_pending => 'Aggiornamento in attesa';

  @override
  String get update_all => 'Aggiorna tutto';

  @override
  String get backup_and_restore => 'Backup e ripristino';

  @override
  String get create_backup => 'Crea backup';

  @override
  String get create_backup_dialog_title => 'Cosa vuoi eseguire il backup?';

  @override
  String get create_backup_subtitle =>
      'Può essere utilizzato per ripristinare la libreria corrente';

  @override
  String get restore_backup => 'Ripristina backup';

  @override
  String get encrypt_backups => 'Crittografa backup';

  @override
  String get encrypt_backups_info =>
      'Proteggi i backup con password tramite crittografia AES';

  @override
  String get no_secure_storage => 'Nessuna memoria protetta trovata';

  @override
  String get no_keyring_warning =>
      'Questo sistema non dispone di un servizio portachiavi (es. gnome-keyring o kwallet su Linux), quindi la password non può essere salvata in sicurezza.\n\nSalvarla non crittografata nel database locale dell\'app?';

  @override
  String get enter_backup_password => 'Inserisci la password del backup';

  @override
  String get incorrect_password_try_again => 'Password non corretta, riprova.';

  @override
  String get set_backup_password => 'Crea password per il backup';

  @override
  String get confirm_password => 'Conferma password';

  @override
  String get passwords_do_not_match => 'Le password non coincidono';

  @override
  String get password_required_to_restore =>
      'È necessaria una password per ripristinare questo backup.';

  @override
  String get restore_backup_subtitle =>
      'Ripristina la libreria dal file di backup';

  @override
  String get automatic_backups => 'Backup automatici';

  @override
  String get backup_frequency => 'Frequenza di backup';

  @override
  String get backup_location => 'Posizione del backup';

  @override
  String get backup_options => 'Opzioni di backup';

  @override
  String get backup_options_dialog_title => 'Cosa vuoi eseguire il backup?';

  @override
  String get backup_options_subtitle =>
      'Quali informazioni includere nel file di backup';

  @override
  String get backup_and_restore_warning_info =>
      'È consigliabile conservare copie dei backup in altri luoghi';

  @override
  String get library_entries => 'Voci della libreria';

  @override
  String get chapters_and_episode => 'Capitoli ed episodi';

  @override
  String get every_6_hours => 'Ogni 6 ore';

  @override
  String get every_12_hours => 'Ogni 12 ore';

  @override
  String get daily => 'Giornaliero';

  @override
  String get every_2_days => 'Ogni 2 giorni';

  @override
  String get weekly => 'Settimanale';

  @override
  String get restore_backup_warning_title =>
      'Ripristinare un backup sovrascriverà tutti i dati esistenti.\n\nContinuare il ripristino?';

  @override
  String get restore_sync_question_title => 'Sincronizzare questo ripristino?';

  @override
  String get restore_sync_question_message =>
      'Questo dispositivo è connesso a un server di sincronizzazione. Caricare ora i dati ripristinati?';

  @override
  String get restore_sync_question_confirm => 'Sì, sincronizza';

  @override
  String get restore_sync_question_deny => 'No, disattiva sincronizzazione';

  @override
  String get sync_disabled_after_restore =>
      'La sincronizzazione è disattivata. Puoi riattivarla nelle Impostazioni.';

  @override
  String get restore_sync_disabled_question_title =>
      'La sincronizzazione è disattivata';

  @override
  String get restore_sync_disabled_question_message =>
      'La sincronizzazione è spenta. Vuoi riattivarla e caricare questi dati ripristinati sul server?';

  @override
  String get restore_sync_question_reenable => 'Sì, riattiva e sincronizza';

  @override
  String get restore_sync_question_keep_disabled => 'Mantieni disattivata';

  @override
  String get restore_sync_uploading =>
      'Sincronizzazione dati ripristinati con il server…';

  @override
  String get restore_sync_upload_success =>
      'Dati ripristinati sincronizzati con il server';

  @override
  String get services => 'Servizi';

  @override
  String get tracking_warning_info =>
      'Sincronizzazione unidirezionale per aggiornare il progresso dei capitoli nei servizi di tracciamento. Imposta il tracciamento per le singole voci dal loro pulsante di tracciamento.';

  @override
  String get use_page_tap_zones => 'Usa zone di tocco pagina';

  @override
  String get manage_trackers => 'Gestisci tracciatori';

  @override
  String get restore => 'Ripristina';

  @override
  String get backups => 'Backup';

  @override
  String get by_scanlator => 'Per scanlator';

  @override
  String get by_name => 'Per nome';

  @override
  String get installed => 'Installato';

  @override
  String get auto_scroll => 'Scorrimento automatico';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Lingue preferite, correzione dell\'intonazione, canali audio';

  @override
  String get player => 'Giocatore';

  @override
  String get markEpisodeAsSeenSetting =>
      'In quale momento contrassegnare l\'episodio come visto';

  @override
  String get mark_duplicate_chapters_read =>
      'Contrassegna i numeri di capitoli duplicati come letti';

  @override
  String get default_skip_intro_length =>
      'Durata predefinita per saltare l\'introduzione';

  @override
  String get default_playback_speed_length =>
      'Durata predefinita per la velocità di riproduzione';

  @override
  String get updateProgressAfterReading =>
      'Aggiorna il progresso dopo aver letto';

  @override
  String get no_sources_installed => 'Nessuna fonte installata!';

  @override
  String get show_extensions => 'Mostra estensioni';

  @override
  String get default_skip_forward_skip_length =>
      'Lunghezza predefinita del salto in avanti';

  @override
  String get aniskip_requires_info =>
      'AniSkip richiede che l\'anime sia tracciato con MAL o Anilist per funzionare.';

  @override
  String get enable_aniskip => 'Abilita AniSkip';

  @override
  String get enable_auto_skip => 'Abilita l\'auto-skip';

  @override
  String get aniskip_button_timeout => 'Timeout del pulsante';

  @override
  String get skip_opening => 'Salta apertura';

  @override
  String get skip_ending => 'Salta finale';

  @override
  String get fullscreen => 'Schermo intero';

  @override
  String get update_library => 'Aggiorna libreria';

  @override
  String get next_chapter => 'Capitolo successivo';

  @override
  String get next_5_chapters => 'Prossimi 5 capitoli';

  @override
  String get next_10_chapters => 'Prossimi 10 capitoli';

  @override
  String get next_25_chapters => 'Prossimi 25 capitoli';

  @override
  String get all_chapters => 'Tutti i capitoli';

  @override
  String get next_episode => 'Prossimo episodio';

  @override
  String get next_5_episodes => 'Prossimi 5 episodi';

  @override
  String get next_10_episodes => 'Prossimi 10 episodi';

  @override
  String get next_25_episodes => 'Prossimi 25 episodi';

  @override
  String get all_episodes => 'Tutti gli episodi';

  @override
  String get cover_saved => 'Copertina salvata';

  @override
  String get set_as_cover => 'Imposta come copertina';

  @override
  String get use_this_as_cover_art => 'Usare questo come copertina?';

  @override
  String get save => 'Salva';

  @override
  String get picture_saved => 'Immagine salvata';

  @override
  String get cover_updated => 'Copertina aggiornata';

  @override
  String get include_subtitles => 'Includi sottotitoli';

  @override
  String get blend_mode_default => 'Predefinito';

  @override
  String get blend_mode_multiply => 'Moltiplicare';

  @override
  String get blend_mode_screen => 'Schermo';

  @override
  String get blend_mode_overlay => 'Sovrapposizione';

  @override
  String get blend_mode_colorDodge => 'Schiarire colore';

  @override
  String get blend_mode_lighten => 'Schiarire';

  @override
  String get blend_mode_colorBurn => 'Bruciare colore';

  @override
  String get blend_mode_darken => 'Scurire';

  @override
  String get blend_mode_difference => 'Differenza';

  @override
  String get blend_mode_saturation => 'Saturazione';

  @override
  String get blend_mode_softLight => 'Luce soffusa';

  @override
  String get blend_mode_plus => 'Più';

  @override
  String get blend_mode_exclusion => 'Esclusione';

  @override
  String get custom_color_filter => 'Filtro colore personalizzato';

  @override
  String get color_filter_blend_mode =>
      'Modalità di miscelazione del filtro colore';

  @override
  String get enable_all => 'Abilita tutto';

  @override
  String get disable_all => 'Disabilita tutto';

  @override
  String get font => 'Carattere';

  @override
  String get color => 'Colore';

  @override
  String get font_size => 'Dimensione del carattere';

  @override
  String get text => 'Testo';

  @override
  String get border => 'Bordo';

  @override
  String get background => 'Sfondo';

  @override
  String get no_subtite_warning_message =>
      'Non ha effetto perché non ci sono tracce sottotitoli in questo video';

  @override
  String get grid_size => 'Dimensione griglia';

  @override
  String n_per_row(Object n) {
    return '$n per riga';
  }

  @override
  String get horizontal_continious => 'Orizzontale continuo';

  @override
  String get edit_code => 'Modifica codice';

  @override
  String get use_libass => 'Abilita libass';

  @override
  String get use_libass_info =>
      'Usa il rendering dei sottotitoli basato su libass per il backend nativo.';

  @override
  String get libass_not_disable_message =>
      'Disabilita `use libass` nelle impostazioni del lettore per poter personalizzare i sottotitoli.';

  @override
  String get override_ass_subtitles => 'Sovrascrivi sottotitoli ASS';

  @override
  String get override_ass_subtitles_info =>
      'Applica uno stile personalizzato ai sottotitoli ASS/SSA';

  @override
  String get torrent_stream => 'Streaming Torrent';

  @override
  String get add_torrent => 'Aggiungi torrent';

  @override
  String get enter_torrent_hint_text =>
      'Inserisci magnet o URL del file torrent';

  @override
  String get torrent_url => 'URL torrent';

  @override
  String get or => 'O';

  @override
  String get advanced => 'Avanzate';

  @override
  String get advanced_info => 'Configurazione mpv';

  @override
  String get use_native_http_client => 'Usa il client HTTP nativo';

  @override
  String get use_native_http_client_info =>
      'Supporta automaticamente le funzionalità della piattaforma come le VPN, supporta più funzionalità HTTP come HTTP/3 e la gestione dei reindirizzamenti personalizzati.';

  @override
  String n_hour_ago(Object hour) {
    return '$hour ora fa';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours ore fa';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute minuto fa';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes minuti fa';
  }

  @override
  String n_day_ago(Object day) {
    return '$day giorno fa';
  }

  @override
  String get now => 'adesso';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Libreria aggiornata l\'ultima volta: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Dati e archiviazione';

  @override
  String get download_location_info => 'Usato per i download dei capitoli';

  @override
  String get storage => 'Archiviazione';

  @override
  String get clear_chapter_and_episode_cache =>
      'Cancella cache dei capitoli ed episodi';

  @override
  String get cache_cleared => 'Cache cancellata';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Cancella cache dei capitoli/episodi all\'avvio dell\'app';

  @override
  String get app_settings => 'Impostazioni app';

  @override
  String get sources_settings => 'Impostazioni fonti';

  @override
  String get include_sensitive_settings =>
      'Includi impostazioni sensibili (es. token di login del tracker)';

  @override
  String get create => 'Crea';

  @override
  String get downloads_are_limited_to_wifi =>
      'I download sono limitati solo al Wi-Fi';

  @override
  String get recommendations => 'Raccomandazioni';

  @override
  String get recommendations_similar => 'simile';

  @override
  String get recommendations_weights => 'Pesi di raccomandazione';

  @override
  String get recommendations_weights_genre => 'Similarità di genere';

  @override
  String get recommendations_weights_setting => 'Similarità di ambientazione';

  @override
  String get recommendations_weights_synopsis => 'Similarità di storia';

  @override
  String get recommendations_weights_theme => 'Similarità di tema';

  @override
  String get manga_extensions_repo => 'Repository delle estensioni manga';

  @override
  String get anime_extensions_repo => 'Repository delle estensioni anime';

  @override
  String get novel_extensions_repo => 'Repository delle estensioni romanzi';

  @override
  String get custom_dns =>
      'DNS personalizzato (lascia vuoto per usare il DNS di sistema)';

  @override
  String get android_proxy_server =>
      'Server proxy Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Ottieni M-Extension-Server';

  @override
  String get undefined => 'Non definito';

  @override
  String get empty_extensions_repo =>
      'Non hai alcun URL di repository qui. Fai clic sul pulsante più per aggiungerne uno!';

  @override
  String get add_extensions_repo => 'Aggiungi URL del repository';

  @override
  String get remove_extensions_repo => 'Rimuovi URL del repository';

  @override
  String get manage_manga_repo_urls => 'Gestisci gli URL del repository manga';

  @override
  String get manage_anime_repo_urls => 'Gestisci gli URL del repository anime';

  @override
  String get manage_novel_repo_urls =>
      'Gestisci gli URL del repository romanzi';

  @override
  String get url_cannot_be_empty => 'L\'URL non può essere vuoto';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'L\'URL deve terminare con .json / .pb';

  @override
  String get repo_url => 'URL del repository';

  @override
  String get invalid_url_format => 'Formato URL non valido';

  @override
  String get clear_all_sources => 'Cancella tutte le fonti';

  @override
  String get clear_all_sources_msg =>
      'Questo cancellerà completamente tutte le fonti dall\'app. Sei sicuro di voler continuare?';

  @override
  String get sources_cleared => 'Fonti cancellate!';

  @override
  String get repo_added => 'Repository delle fonti aggiunto!';

  @override
  String get repo_already_exists => 'Il repository esiste già!';

  @override
  String get add_repo => 'Aggiungere repository?';

  @override
  String get add_repo_sources_to_add =>
      'Elenchi di estensioni che verranno aggiunte:';

  @override
  String get add_repo_warning =>
      'Le estensioni di questi repository vengono eseguite all\'interno dell\'app. Aggiungi solo repository di cui ti fidi.';

  @override
  String get genre_search_library => 'Cerca genere nella libreria';

  @override
  String get genre_search_source => 'Esplora nella fonte';

  @override
  String get source_not_added => 'La fonte non è installata!';

  @override
  String get load_own_subtitles => 'Carica i tuoi sottotitoli...';

  @override
  String get search_subtitles => 'Cerca sottotitoli online...';

  @override
  String extension_notes(Object notes) {
    return 'Note: $notes';
  }

  @override
  String get unsupported_repo =>
      'Impossibile aggiungere questo repository di fonti. Controlla l’indirizzo del repository o contatta chi lo gestisce.';

  @override
  String get you_have_finished_reading => 'Hai finito di leggere';

  @override
  String get hwdec => 'Decodificatore hardware';

  @override
  String get enable_hardware_accel => 'Accelerazione hardware';

  @override
  String get enable_hardware_accel_info =>
      'Attiva/disattiva se stai riscontrando bug o crash';

  @override
  String get track_library_navigate => 'Vai alla voce locale esistente';

  @override
  String get track_library_add => 'Aggiungi alla libreria locale';

  @override
  String get track_library_add_confirm =>
      'Aggiungi elemento tracciato alla libreria locale';

  @override
  String get track_library_not_logged =>
      'Accedi al tracker corrispondente per usare questa funzione!';

  @override
  String get track_library_switch => 'Passa a un altro tracker';

  @override
  String get go_back => 'Indietro';

  @override
  String get merge_library_nav_mobile =>
      'Unisci navigazione libreria su mobile';

  @override
  String get enable_discord_rpc => 'Attiva Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Nascondi Discord RPC in modalità Incognito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Mostra capitolo corrente su Discord (richiede riavvio)';

  @override
  String get rpc_show_title => 'Mostra titolo corrente su Discord';

  @override
  String get rpc_show_cover_image =>
      'Mostra immagine di copertina corrente su Discord';

  @override
  String get enable_mpv => 'Attiva shader / script mpv';

  @override
  String get mpv_info => 'Supporta script .js in mpv/scripts/';

  @override
  String get mpv_redownload => 'Riscarica file di configurazione mpv';

  @override
  String get mpv_redownload_info =>
      'Sostituisce i vecchi file di configurazione con quelli nuovi!';

  @override
  String get mpv_download =>
      'I file di configurazione MPV sono richiesti!\nScarica ora?';

  @override
  String get custom_buttons => 'Pulsanti personalizzati';

  @override
  String get custom_buttons_info =>
      'Esegui codice lua con pulsanti personalizzati';

  @override
  String get custom_buttons_edit => 'Modifica pulsanti personalizzati';

  @override
  String get custom_buttons_add => 'Aggiungi pulsante personalizzato';

  @override
  String get custom_buttons_added => 'Pulsante personalizzato aggiunto!';

  @override
  String get custom_buttons_delete => 'Elimina pulsante personalizzato';

  @override
  String get custom_buttons_text => 'Testo del pulsante';

  @override
  String get custom_buttons_text_req => 'Testo del pulsante richiesto';

  @override
  String get custom_buttons_js_code => 'Codice lua';

  @override
  String get custom_buttons_js_code_req => 'Codice lua richiesto';

  @override
  String get custom_buttons_js_code_long =>
      'Codice lua (su pressione prolungata)';

  @override
  String get custom_buttons_startup => 'Codice lua (all\'avvio)';

  @override
  String get custom_buttons_add_warning =>
      'Questo pulsante esegue il codice Lua riportato di seguito nel lettore video, che può accedere ai tuoi file ed eseguire programmi. Aggiungilo solo se sei sicuro della provenienza di questo collegamento.';

  @override
  String n_days(Object n) {
    return '$n giorni';
  }

  @override
  String get decoder => 'Decodificatore';

  @override
  String get decoder_info => 'Decodifica hardware, formato pixel, debanding';

  @override
  String get enable_gpu_next => 'Attiva gpu-next (solo Android)';

  @override
  String get enable_gpu_next_info => 'Un nuovo motore di rendering video';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Usa formato pixel YUV420P';

  @override
  String get use_yuv420p_info =>
      'Può risolvere schermi neri su alcuni codec video, può anche migliorare le prestazioni a scapito della qualità';

  @override
  String get audio_preferred_languages => 'Lingue preferite';

  @override
  String get audio_preferred_languages_info =>
      'Lingua(e) audio da selezionare per impostazione predefinita su un video con più flussi audio, codici lingua di 2/3 lettere (es: it, en, es). Valori multipli possono essere delimitati da virgola.';

  @override
  String get enable_audio_pitch_correction =>
      'Attiva correzione intonazione audio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Impedisce all\'audio di diventare acuto a velocità più elevate e grave a velocità più basse';

  @override
  String get audio_channels => 'Canali audio';

  @override
  String get volume_boost_cap => 'Limite amplificazione volume';

  @override
  String get internal_player => 'Lettore interno';

  @override
  String get internal_player_info => 'Progresso, controlli, orientamento';

  @override
  String get subtitle_delay_text => 'Ritardo sottotitoli';

  @override
  String get subtitle_delay => 'Ritardo (ms)';

  @override
  String get subtitle_speed => 'Velocità';

  @override
  String get tracks => 'Tracce';

  @override
  String get playback_speed => 'Velocità di riproduzione';

  @override
  String get shaders => 'Shader';

  @override
  String get video_fit => 'Adatta';

  @override
  String get calendar => 'Calendario';

  @override
  String get calendar_no_data => 'Nessun dato ancora.';

  @override
  String get calendar_info =>
      'Il calendario può solo prevedere il prossimo caricamento del capitolo in base ai caricamenti precedenti. Alcuni dati potrebbero non essere accurati al 100%!';

  @override
  String in_n_day(Object days) {
    return 'tra $days giorno';
  }

  @override
  String in_n_days(Object days) {
    return 'tra $days giorni';
  }

  @override
  String get clear_library => 'Cancella libreria';

  @override
  String get clear_library_desc =>
      'Scegli di cancellare tutte le voci di manga, anime e/o novel';

  @override
  String get clear_library_input =>
      'Digita \'manga\', \'anime\' e/o \'novel\' (separati da virgola) per rimuovere tutte le voci correlate';

  @override
  String get watch_order => 'Ordine di visione';

  @override
  String get watch_order_role_current => 'Attuale';

  @override
  String get watch_order_role_previous => 'Precedente';

  @override
  String get watch_order_role_next => 'Successivo';

  @override
  String get watch_order_source_release_order => 'Ordine di rilascio';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name di $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Collezione ufficiale Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt collezione: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Stagioni per $title';
  }

  @override
  String get watch_order_select_source => 'Origine dell\'ordine';

  @override
  String watch_order_season(int number) {
    return 'Stagione $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Episodio $number';
  }

  @override
  String get sequels => 'Sequel';

  @override
  String get recommendations_similarity => 'Similarità:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Valutazione $rating';
  }

  @override
  String get local_folder_structure => 'Struttura di una cartella locale';

  @override
  String get local_folder => 'Cartelle locali';

  @override
  String get add_local_folder => 'Aggiungi cartella locale';

  @override
  String get rescan_local_folder => 'Rianalizza tutte le cartelle locali ora';

  @override
  String get default_download_destination =>
      'Destinazione download predefinita';

  @override
  String get ask_download_destination => 'Chiedi destinazione download';

  @override
  String get ask_download_destination_desc =>
      'Scegli una cartella locale ogni volta che avvii un download.';

  @override
  String get select_download_destination => 'Seleziona destinazione download';

  @override
  String get clear_local_library => 'Svuota libreria locale';

  @override
  String get clear_local_library_desc =>
      'Rimuovi cartelle locali e archivi dalla libreria.';

  @override
  String get clear_local_library_msg =>
      'Questo rimuoverà cartelle e archivi dalla libreria senza eliminare i file dal disco.';

  @override
  String get custom => 'Personalizzato';

  @override
  String get no_local_folder_available_for_downloads =>
      'Nessuna cartella locale disponibile per i download';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Creazione CBZ non riuscita: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Errore durante la lettura della copertina: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Errore durante la lettura dei metadati: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Errore salvataggio capitolo/episodio nella libreria: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Errore lettura copertina capitolo: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Errore lettura copertina archivio: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Errore recupero libreria locale: $error';
  }

  @override
  String get export_metadata => 'Esporta metadati';

  @override
  String get exported => 'Esportato';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Esportazione metadati non riuscita: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count capitoli non numerati automaticamente.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Impossibile avviare il server Webview per Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Token di $tracker scaduto';
  }

  @override
  String get video_list_empty => 'La lista dei video è vuota';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Impossibile aprire $url';
  }

  @override
  String get text_size => 'Dimensione testo:';

  @override
  String get text_align => 'Allineamento testo';

  @override
  String get line_height => 'Altezza linea';

  @override
  String get show_scroll_percentage => 'Mostra percentuale di scorrimento';

  @override
  String get remove_extra_paragraph_spacing =>
      'Rimuovi spaziatura extra tra paragrafi';

  @override
  String select_label_color(Object label) {
    return 'Seleziona colore $label';
  }

  @override
  String get default_user_agent => 'Agente predefinito';

  @override
  String get forceLandscapeMode => 'Forza modalità paesaggio';

  @override
  String get forceLandscapeModeSubtitle =>
      'Forza il lettore a utilizzare l\'orientamento orizzontale.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Provider DNS';

  @override
  String get tracked => 'Monitorato';

  @override
  String get auth_unlock_msg => 'Autenticati per sbloccare NodeLane Comics';

  @override
  String get app_locked => 'NodeLane Comics è bloccato';

  @override
  String get auth_to_continue => 'Autenticati per continuare';

  @override
  String get authenticating => 'Autenticazione in corso...';

  @override
  String get lock => 'Blocca';

  @override
  String get unlock => 'Sblocca';

  @override
  String get security => 'Sicurezza';

  @override
  String get auth_to_change_security_setting =>
      'Autenticati per modificare le impostazioni di sicurezza';

  @override
  String get app_lock => 'Blocco app';

  @override
  String get require_biometric_or_device_credential =>
      'Richiede l\'autenticazione biometrica o le credenziali del dispositivo per aprire l\'app';

  @override
  String get biometric_or_device_credential_not_available =>
      'L\'autenticazione biometrica non è disponibile su questo dispositivo';

  @override
  String get app_lock_description =>
      'Quando il blocco dell\'app è abilitato, ti verrà richiesto di autenticarti\\ndevice ogni volta che apri l\'app o torni ad essa dallo sfondo.';

  @override
  String get checking_device_authentication =>
      'Verifica dell\'autenticazione del dispositivo…';

  @override
  String get device_authentication_incomplete =>
      'L\'autenticazione non è stata completata. La tua impostazione non è cambiata.';

  @override
  String get keep_screen_on => 'Mantieni lo schermo acceso';

  @override
  String get webtoon_side_padding => 'Spaziatura laterale Webtoon';

  @override
  String get show_page_gaps => 'Mostra spazi tra pagine';

  @override
  String get invert_colors => 'Colori invertiti';

  @override
  String get grayscale => 'Scala di grigi';

  @override
  String get brightness => 'Luminosità';

  @override
  String get contrast => 'Contrasto';

  @override
  String get saturation => 'Saturazione';

  @override
  String get navigation_layout => 'Layout di navigazione';

  @override
  String get nav_layout_default => 'Predefinito';

  @override
  String get nav_layout_l_shaped => 'A forma di L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Bordo';

  @override
  String get nav_layout_right_and_left => 'Destra e sinistra';

  @override
  String get nav_layout_disabled => 'Disabilitato';

  @override
  String get color_enhancements => 'Miglioramenti dei colori';

  @override
  String get total => 'Totale';

  @override
  String get mean_per_title => 'Media per titolo';

  @override
  String get completion_rate => 'Tasso di completamento';

  @override
  String get watching_time => 'Tempo di visione';

  @override
  String get reading_time => 'Tempo di lettura';

  @override
  String average_chapters_per_title(Object title) {
    return 'Media capitoli per $title';
  }

  @override
  String get read_percentage => 'Percentuale di lettura';

  @override
  String get entries => 'Voci';

  @override
  String get android_proxy_server_mihon => 'Server Proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Scarica e configura il server proxy necessario per utilizzare le estensioni Mihon.';

  @override
  String get mihon_proxy_server => 'Server proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Scarica il pacchetto server proxy prima di usare le estensioni Mihon. Include JRE e JAR del server.';

  @override
  String get extension_server_intro_ios =>
      'Scarica il file JAR del server proxy prima di usare le estensioni Mihon. Su iOS serve solo il JAR del server.';

  @override
  String get checking_files => 'Controllo file';

  @override
  String get files_installed => 'File installati';

  @override
  String get files_missing => 'File mancanti';

  @override
  String get update_files => 'Aggiorna file';

  @override
  String get up_to_date => 'Aggiornato';

  @override
  String get choose_location => 'Scegli posizione';

  @override
  String get import_existing_jar => 'Importa JAR esistente';

  @override
  String get detect_files_in_selected_folder =>
      'Rileva file nella cartella selezionata';

  @override
  String get preparing_download => 'Preparazione download...';

  @override
  String get app_install_location => 'Posizione installazione app';

  @override
  String get install_location => 'Posizione installazione';

  @override
  String get jre_executable => 'Eseguibile JRE';

  @override
  String get extension_server_jar => 'JAR server estensioni';

  @override
  String get installed_version => 'Versione installata';

  @override
  String get latest_version => 'Ultima versione';

  @override
  String get m_extension_server_description =>
      'Usa M-Extension-Server quando ti serve un proxy separato per il dispositivo Android. Imposta l\'indirizzo qui e scarica l\'APK da GitHub.';

  @override
  String get set_proxy_address => 'Imposta indirizzo proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'Nessuna nuova versione del server proxy disponibile.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Impossibile verificare gli aggiornamenti del server proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Nessun pacchetto server estensioni disponibile per questa piattaforma.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Download del pacchetto fallito ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Il pacchetto scaricato non contiene i file previsti.';

  @override
  String get extension_server_files_ready =>
      'File del server estensioni pronti.';

  @override
  String get ios_extension_server_import_hint =>
      'Su iOS il server è installato nella sandbox dell\'app. Usa \"Importa JAR esistente\" per caricare un file scaricato.';

  @override
  String get select_extension_server_folder =>
      'Seleziona cartella del server estensioni';

  @override
  String get selected_folder_does_not_exist =>
      'La cartella selezionata non esiste.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Nessun file trovato nella cartella selezionata.';

  @override
  String get extension_server_files_linked =>
      'File del server estensioni collegati.';

  @override
  String get select_extension_server_jar =>
      'Seleziona JAR del server estensioni';

  @override
  String get selected_file_could_not_be_accessed =>
      'Impossibile accedere al file selezionato.';

  @override
  String get extension_server_jar_imported =>
      'JAR del server estensioni importato.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Impossibile aprire la pagina di M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP del server (es. 10.0.0.5 o https://example.com)';

  @override
  String get not_configured => 'Non configurato';

  @override
  String get zero_interpreter => 'Interprete Zero';

  @override
  String get zero_interpreter_description =>
      'Controlla il server interprete Zero automaticamente o manualmente.';

  @override
  String get start_server_on_launch => 'Avvia server all\'avvio';

  @override
  String get runtime_status => 'Stato runtime';

  @override
  String get running => 'In esecuzione';

  @override
  String get stopped => 'Fermato';

  @override
  String get start => 'Avvia';

  @override
  String get stop => 'Ferma';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Da testo a voce';

  @override
  String get tts_speed => 'Velocità';

  @override
  String get tts_pitch => 'Tonalità';

  @override
  String get tts_language => 'Lingua';

  @override
  String get tts_voice => 'Voce';

  @override
  String get tts_stop => 'Ferma';

  @override
  String get tts_play => 'Riproduci';

  @override
  String get tts_pause => 'Pausa';

  @override
  String get tts_previous => 'Paragrafo precedente';

  @override
  String get tts_next => 'Paragrafo successivo';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Paragrafo $current di $total';
  }

  @override
  String get tts_settings => 'Impostazioni TTS';

  @override
  String get tts_default => 'Predefinito';

  @override
  String get webtoon_disable_zoom_out => 'Disattiva zoom indietro Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Doppio tocco per zoomare Webtoon';

  @override
  String get navigate_to_pan => 'Naviga per panoramica';

  @override
  String get navigate_to_pan_subtitle =>
      'Sposta l\'immagine zoomata prima di girare pagina';

  @override
  String get split_wide_pages => 'Dividi pagine doppie';

  @override
  String get dual_page_invert => 'Inverti le mezze pagine tagliate';

  @override
  String get dual_page_rotate_to_fit => 'Ruota per adattare';

  @override
  String get dual_page_rotate_to_fit_invert =>
      'Inverti la direzione di rotazione';

  @override
  String get double_page_single_first_page => 'Prima pagina singola';

  @override
  String get double_page_single_first_page_subtitle =>
      'Mostra la prima pagina da sola nella modalità a doppia pagina';

  @override
  String get double_page_auto => 'Doppia pagina automatica';

  @override
  String get double_page_auto_subtitle =>
      'Passa automaticamente alla modalità doppia pagina in orizzontale';

  @override
  String get landscape_zoom => 'Zoom automatico in orizzontale';

  @override
  String get zoom_start_position => 'Posisi di inizio zoom';

  @override
  String get zoom_start_left => 'Sinistra';

  @override
  String get zoom_start_right => 'Destra';

  @override
  String get zoom_start_center => 'Centro';

  @override
  String get automatic_background => 'Sfondo automatico';

  @override
  String get tapping_inversion => 'Inversione del tocco';

  @override
  String get tapping_inversion_none => 'Nessuna';

  @override
  String get tapping_inversion_horizontal => 'Orizzontale';

  @override
  String get tapping_inversion_vertical => 'Verticale';

  @override
  String get tapping_inversion_both => 'Entrambi';

  @override
  String get flash_on_page_change => 'Flash al cambio pagina';

  @override
  String get flash_on_page_change_subtitle =>
      'Assistente anti-ritenzione AMOLED';

  @override
  String get flash_color => 'Colore del flash';

  @override
  String get flash_color_black => 'Nero';

  @override
  String get flash_color_white => 'Bianco';

  @override
  String get flash_color_white_black => 'Bianco e Nero';

  @override
  String get flash_interval_label => 'Intervallo del flash';

  @override
  String flash_interval_value(String n) {
    return '$n pagine';
  }

  @override
  String flash_interval(String n) {
    return 'Intervallo del flash: $n pagine';
  }

  @override
  String get flash_duration_label => 'Durata del flash';

  @override
  String flash_duration_value(String n) {
    return '$n ms';
  }

  @override
  String flash_duration(String n) {
    return 'Durata del flash: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Mostra l\'overlay di navigazione all\'avvio';

  @override
  String get reader_hide_threshold => 'Soglia per nascondere il lettore';

  @override
  String get reader_hide_threshold_highest => 'Massimo (5 px)';

  @override
  String get reader_hide_threshold_high => 'Alto (13 px)';

  @override
  String get reader_hide_threshold_low => 'Basso (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Minimo (47 px)';

  @override
  String get error_no_pages_available => 'Errore: nessuna pagina disponibile';

  @override
  String get app_ui_scale => 'Scala interfaccia';

  @override
  String get app_ui_scale_subtitle =>
      'Rendi l\'interfaccia più grande o più piccola per adattarsi allo schermo e alla distanza di visualizzazione.';

  @override
  String get allow_concurrent_downloads => 'Consenti download simultanei';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Scarica da diverse fonti contemporaneamente. Una singola fonte scarica comunque un capitolo alla volta in modo da non essere sovraccaricata. Spegni per scaricare uno alla volta ovunque.';

  @override
  String get download_delay => 'Ritardo di download';

  @override
  String get download_delay_subtitle =>
      'Spento. Aggiungere un\'attesa con jitter casuale tra i capitoli per essere più delicati sulle fonti.';

  @override
  String get save_search => 'Salva ricerca';

  @override
  String get saved_searches => 'Ricerche salvate';

  @override
  String get enter_search_to_save_first =>
      'Inserisci una ricerca da salvare per prima';

  @override
  String get no_saved_searches =>
      'Ancora nessuna ricerca salvata per questa fonte.\nEseguire una ricerca e quindi scegliere \"Salva ricerca\".';

  @override
  String get source => 'Fonte';

  @override
  String get something_went_wrong => 'Qualcosa è andato storto';

  @override
  String get startup_failed => 'NodeLane Comics non è riuscito ad avviarsi';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sorgenti senza risultati',
      one: '1 sorgente senza risultati',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Come importare il backup?';

  @override
  String get import_mode_message =>
      'Scegli se unire questo backup alla libreria attuale o sostituirla completamente.';

  @override
  String get import_mode_keep_existing => 'Unisci';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Aggiunge nuove serie e aggiorna quelle corrispondenti. Nulla viene eliminato.';

  @override
  String get import_mode_replace => 'Sostituisci';

  @override
  String get import_mode_replace_subtitle =>
      'Elimina l\'intera libreria attuale e la sostituisce con il backup.';

  @override
  String get replace_summary_title => 'Pronto a sostituire la libreria';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Questo eliminerà $currentCount serie e le sostituirà con $backupCount serie.';
  }

  @override
  String get replace_summary_confirm => 'Sostituisci';

  @override
  String replace_result_message(Object count) {
    return 'Libreria sostituita con $count serie dal backup.';
  }

  @override
  String get category_conflict_title => 'Categorie esistenti trovate';

  @override
  String get category_conflict_message =>
      'Il backup contiene categorie già esistenti.';

  @override
  String get category_conflict_keep =>
      'Mantieni — unisci nella categoria esistente';

  @override
  String get category_conflict_delete =>
      'Elimina — lascia serie senza categoria';

  @override
  String get source_conflict_title => 'Sorgenti non trovate';

  @override
  String get source_conflict_message =>
      'Alcune sorgenti non corrispondono a estensioni installate.';

  @override
  String get source_conflict_keep => 'Mantieni nome originale';

  @override
  String get import_summary_title => 'Pronto per l\'importazione';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries nuove serie, $updatedSeries serie aggiornate e $newChapters nuovi capitoli.';
  }

  @override
  String get import_summary_confirm => 'Importa';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Importate $newSeries nuove serie, aggiornate $updatedSeries, aggiunti $newChapters capitoli.';
  }

  @override
  String get roll_back => 'Ripristina stato precedente';

  @override
  String get roll_back_confirm_message =>
      'Ripristina la libreria allo snapshot precedente a questa modifica.';

  @override
  String get roll_back_done => 'Ripristinato allo snapshot precedente.';

  @override
  String get restoring_backup => 'Ripristino libreria in corso…';

  @override
  String get roll_back_last_change => 'Annulla ultima modifica';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Snapshot del $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count modifiche recenti disponibili per il ripristino';
  }

  @override
  String get delete_source_title => 'Elimina sorgente e i suoi manga';

  @override
  String get delete_source_subtitle =>
      'Rimuove tutti i manga di una sorgente con capitoli, download e cronologia.';

  @override
  String get delete_source_pick_title => 'Scegli sorgente da eliminare';

  @override
  String get delete_source_empty => 'Nessuna sorgente trovata nella libreria.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Eliminare $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Questo elimina permanentemente $mangaCount manga, $chapterCount capitoli, $historyCount voci di cronologia e $updateCount voci di aggiornamento. I collegamenti di tracciamento vengono mantenuti. Questo non può essere annullato se non eseguendo il rollback.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Rimuovi anche l\'estensione installata';

  @override
  String get delete_source_keep_history => 'Conserva cronologia di lettura';

  @override
  String get delete_source_keep_downloads => 'Conserva record dei download';

  @override
  String get delete_source_button => 'Elimina';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Eliminati $mangaCount manga da $sourceName.';
  }

  @override
  String get merge_manga_title => 'Unisci manga duplicati';

  @override
  String get merge_manga_subtitle =>
      'Trova titoli corrispondenti sotto la stessa sorgente e li unisce in uno solo.';

  @override
  String get merge_manga_none_found => 'Nessun manga duplicato trovato.';

  @override
  String get merge_manga_pick_title => 'Possibili duplicati';

  @override
  String get merge_manga_choose_primary_title =>
      'In quale voce unire le altre?';

  @override
  String get merge_manga_choose_primary_message =>
      'Capitoli, cronologia e tracking confluiranno nella voce scelta.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capitoli',
      one: '1 capitolo',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Unisci';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Uniti $count manga duplicati in $mangaName.';
  }

  @override
  String get merge_preview_title => 'Conferma unione';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters capitoli trovati nelle altre voci. $duplicateChapters sono duplicati e verranno eliminati (mantenendo la copia con avanzamento di lettura); Verrà aggiunto $keptChapters. Verranno eliminati anche i $duplicateTracks link di tracciamento duplicati.';
  }

  @override
  String get memory_overlay => 'Mostra utilizzo memoria';

  @override
  String get memory_overlay_subtitle =>
      'Lettura in tempo reale della memoria utilizzata dall\'app. Per misurare sul dispositivo invece di tirare a indovinare: osservalo durante lo scorrimento della libreria o la lettura di un capitolo.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Segnalazioni errori';

  @override
  String get error_reports_subtitle =>
      'Errori rilevati dall\'app e modalità di segnalazione';

  @override
  String get error_reports_empty => 'Nessun errore riscontrato.';

  @override
  String get error_reports_likely_cause => 'Causa probabile';

  @override
  String get error_reports_report => 'Segnala su GitHub';

  @override
  String get error_reports_banner => 'NodeLane Comics ha riscontrato un errore';

  @override
  String get error_reports_banner_action => 'Mostra';

  @override
  String get error_reports_copy => 'Copia';

  @override
  String get error_reports_copied => 'Copiato negli appunti';

  @override
  String get error_reports_clear => 'Cancella';

  @override
  String get error_reports_extension_failure =>
      'Questo errore proviene da un\'estensione, non da NodeLane Comics. Le estensioni sono sviluppate e mantenute da chi gestisce il repository da cui hai installato questa fonte, quindi la correzione deve essere fatta lì. Il nome della fonte e ciò che stavi aprendo sono dettagli utili da fornire.';

  @override
  String get error_reports_already_reported => 'Già segnalato';

  @override
  String get error_reports_expected_failure =>
      'Questo problema è solitamente dovuto alla fonte o alla rete piuttosto che all\'app: un link scaduto, un server non disponibile o una connessione interrotta. Vale la pena segnalarlo solo se continua a verificarsi su una fonte che altrove funziona.';

  @override
  String get share_unavailable_copied =>
      'Condivisione non disponibile, copiato negli appunti.';

  @override
  String get onboarding_title => 'Benvenuto in NodeLane Comics';

  @override
  String get onboarding_libraries_body => 'Scegli cosa leggere e guardare.';

  @override
  String get onboarding_nav_title => 'Le tue librerie';

  @override
  String get onboarding_nav_body =>
      'Una scheda per ciascuna o raggruppate in una sola scheda Libreria.';

  @override
  String get onboarding_nav_split => 'Schede separate';

  @override
  String get onboarding_nav_merged => 'Una scheda Libreria';

  @override
  String get onboarding_nav_inside =>
      'Toccando Libreria si scambiano le schede';

  @override
  String get onboarding_next => 'Avanti';

  @override
  String get onboarding_restore => 'Ripristina backup';

  @override
  String get onboarding_or_local => 'Oppure usa file già presenti';

  @override
  String get onboarding_local_folder => 'Aggiungi cartella';

  @override
  String onboarding_local_existing(Object count) {
    return '$count cartelle già impostate';
  }

  @override
  String get onboarding_local_any_type => 'Manga, anime e novel supportati.';

  @override
  String get onboarding_local_scanning => 'Scansione cartella';

  @override
  String onboarding_local_found(Object count) {
    return '$count titoli trovati';
  }

  @override
  String get onboarding_local_remove => 'Rimuovi cartella';

  @override
  String get onboarding_local_in_downloads =>
      'Questa è la cartella dei download dell\'app.';

  @override
  String get onboarding_local_empty =>
      'Nessun elemento trovato. Scegli la cartella principale.';

  @override
  String get onboarding_repo_failed => 'Impossibile leggere il repository.';

  @override
  String get onboarding_repo_title => 'Aggiungi sorgente';

  @override
  String get onboarding_body =>
      'Aggiungi un repository per installare ed esplorare le estensioni.';

  @override
  String get onboarding_add => 'Aggiungi repository';

  @override
  String get onboarding_skip => 'Salta per ora';

  @override
  String get onboarding_continue => 'Continua';

  @override
  String get onboarding_later =>
      'Puoi aggiungerlo più tardi in Impostazioni > Esplora.';

  @override
  String get onboarding_replay => 'Mostra schermata di benvenuto';

  @override
  String get onboarding_replay_subtitle =>
      'Riapre la schermata di prima configurazione.';

  @override
  String get missing_source_check_title => 'Controlla sorgenti mancanti';

  @override
  String get missing_source_check_subtitle =>
      'Trova voci la cui estensione non è installata.';

  @override
  String get missing_source_check_none_found =>
      'Tutte le sorgenti della libreria sono installate.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sorgenti mancanti',
      one: '1 sorgente mancante',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Nessuna fonte di $itemType installata.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Aggiungi un repository in Sfoglia, quindi installa la relativa estensione.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fonti',
      one: '1 fonte',
    );
    return 'Hai $_temp0 per questo, ma vengono cercate solo quelle fissate.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Fissa una fonte o disattiva \"Includi solo fonti fissate\" nelle impostazioni di Sfoglia.';

  @override
  String get global_search_all_nsfw =>
      'Tutte le fonti disponibili per questo sono contrassegnate come NSFW e sono nascoste.';

  @override
  String get global_search_all_nsfw_hint =>
      'Attiva le fonti NSFW nelle impostazioni di Sfoglia per cercarle.';

  @override
  String get missing_source_check_result_message =>
      'Queste voci puntano a sorgenti non installate. Tocca per migrare o installare l\'estensione.';

  @override
  String get related_titles => 'Correlati';

  @override
  String get related_none =>
      'Nessun titolo correlato trovato per questa opera.';

  @override
  String get relation_adaptation => 'Adattamento';

  @override
  String get relation_sequel => 'Sequel';

  @override
  String get relation_prequel => 'Prequel';

  @override
  String get relation_parent => 'Storia principale';

  @override
  String get relation_side_story => 'Storia secondaria';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Versione alternativa';

  @override
  String get auto_library_update => 'Aggiornamenti automatici libreria';

  @override
  String get auto_library_update_subtitle =>
      'Controlla la presenza di nuovi capitoli per ogni elemento della libreria all\'avvio dell\'app.';

  @override
  String get auto_library_update_never => 'Mai';

  @override
  String get auto_library_update_12_hours => 'Ogni 12 ore';

  @override
  String get auto_library_update_daily => 'Giornalmente';

  @override
  String get auto_library_update_2_days => 'Ogni 2 giorni';

  @override
  String get auto_library_update_weekly => 'Settimanalmente';

  @override
  String get auto_library_update_wifi_only => 'Solo con Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Salta l\'aggiornamento pianificato quando si usano i dati mobili.';

  @override
  String get padding => 'Spaziatura';

  @override
  String get page_mode => 'Modalità pagina';

  @override
  String get single_page => 'Pagina singola';

  @override
  String get double_page => 'Doppia pagina';

  @override
  String get speed => 'Velocità';

  @override
  String get theme_dark => 'Scuro';

  @override
  String get theme_light => 'Chiaro';

  @override
  String get theme_black => 'Nero';

  @override
  String get theme_sepia => 'Seppia';

  @override
  String get decrease => 'Diminuisci';

  @override
  String get increase => 'Aumenta';

  @override
  String get chapter_swipe_actions => 'Azioni di scorrimento capitolo';

  @override
  String get chapter_swipe_start => 'Scorri verso destra';

  @override
  String get chapter_swipe_end => 'Scorri verso sinistra';

  @override
  String get chapter_swipe_toggle_bookmark => 'Attiva/disattiva segnalibro';

  @override
  String get chapter_swipe_toggle_read => 'Segna come letto/non letto';

  @override
  String get chapter_swipe_download => 'Scarica';

  @override
  String get chapter_swipe_disabled => 'Disabilitato';

  @override
  String get update_errors => 'Errori di aggiornamento';

  @override
  String get no_update_errors => 'Nessun errore di aggiornamento';

  @override
  String get clear_all => 'Cancella tutto';

  @override
  String get dismiss => 'Ignorare';

  @override
  String get previous_episode => 'Episodio precedente';

  @override
  String get clear_logs => 'Cancella i registri';

  @override
  String get bold => 'Grassetto';

  @override
  String get italic => 'Corsivo';

  @override
  String get color_yellow => 'Giallo';

  @override
  String get color_cyan => 'Ciano';

  @override
  String get color_green => 'Verde';

  @override
  String get color_orange => 'Arancione';

  @override
  String get continue_watching => 'Continua a guardare';

  @override
  String get search_your_anime => 'Cerca il tuo anime';

  @override
  String get category => 'Categoria';

  @override
  String get hidden_categories => 'Categorie nascoste';

  @override
  String get new_category => 'Nuova categoria';

  @override
  String get local => 'Locale';

  @override
  String get tv_home_rows => 'Righe';

  @override
  String get genre_rows => 'Righe di genere';

  @override
  String get share_backup_file => 'Condividi il file di backup NodeLane Comics';

  @override
  String get close => 'Chiudi';

  @override
  String get migrate_source => 'Migra fonte';

  @override
  String get cloudflare_bypass_proxy => 'Proxy di bypass di Cloudflare';

  @override
  String get custom_doh_url => 'DoH personalizzato URL';

  @override
  String get custom_doh_url_helper =>
      'Deve essere un endpoint https DoH (JSON).';

  @override
  String get anime_only_tv_layout => 'Layout TV solo anime';

  @override
  String get anime_only_beta => 'Solo anime (beta)';

  @override
  String get tv_home_beta => 'TV domestica (beta)';

  @override
  String get tv_player_beta => 'Lettore TV (beta)';

  @override
  String get network_settings => 'Rete';

  @override
  String get reader_page_layout => 'Impaginazione';

  @override
  String get reader_continuous_options => 'Lettura continua';

  @override
  String get reader_default_mode_hint =>
      'La modalità di lettura predefinita si applica ai titoli senza una modalità individuale impostata durante la lettura.';

  @override
  String get extension_service => 'Servizio di estensione';

  @override
  String get extension_service_description =>
      'Gestire il runtime dell\'estensione e l\'indirizzo proxy.';

  @override
  String get proxy_address => 'Indirizzo proxy';

  @override
  String get checking_runtime_status => 'Verifica dello stato…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + ritardo casuale';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capitoli',
      one: '1 capitolo',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Aggiungere i download dall\'elenco dei capitoli di un titolo.';

  @override
  String get download_queue_order_hint =>
      'Trascinare le maniglie per riordinare';

  @override
  String get download_queue_empty => 'Nessun download in coda';

  @override
  String get download_queue_actions => 'Azioni di download';

  @override
  String get download_queue_cancel_chapter =>
      'Annullare il download di questo capitolo';

  @override
  String get download_queue_cancel_series =>
      'Annulla tutti i download per questo titolo';

  @override
  String get download_queue_start => 'Avvia i download';

  @override
  String get download_queue_retry => 'Riprovare i download';

  @override
  String get download_queue_active => 'Scaricamento';

  @override
  String get download_queue_waiting => 'In attesa di download';

  @override
  String get download_queue_failed => 'Download fallito';

  @override
  String get cf_proxy_helper =>
      'Punto finale FlareSolverr/Byparr. Lascia vuoto per disabilitare.';

  @override
  String get mobile_navigation_description =>
      'Trascina per riordinare. Manga, anime e romanzi condividono la scheda Libreria. Il primo elemento visibile si apre all\'avvio. Sfoglia e altro rimani visibile; vengono visualizzate schede aggiuntive in Altro.';

  @override
  String get text_align_justify => 'Giustificare';

  @override
  String get novel_session_modes_hint =>
      'Impostare la modalità di lettura e le pagine singole o doppie durante la lettura di un titolo.';

  @override
  String get tts_languages_failed =>
      'Impossibile caricare le lingue dal motore vocale.';

  @override
  String get tts_languages_empty =>
      'Il motore vocale non ha restituito alcuna lingua. La selezione salvata viene mantenuta.';

  @override
  String get tts_language_unavailable =>
      'Questa lingua salvata non è nell\'elenco corrente del dispositivo.';

  @override
  String get tts_apply_failed =>
      'Impossibile applicare questa impostazione al motore vocale. Puoi riprovare.';

  @override
  String get player_controls => 'Controlli';

  @override
  String get audio_channel_auto => 'Automatico';

  @override
  String get audio_channel_auto_safe => 'Automatico (sicuro)';

  @override
  String get audio_channel_mono => 'Mono';

  @override
  String get audio_channel_stereo => 'Stereotipia';

  @override
  String get audio_channel_reverse_stereo => 'Stereotipia inversa';

  @override
  String get mpv_bundled_config_hint =>
      'Ripristinare la configurazione, gli script e gli shader inclusi nell\'app. I file con gli stessi nomi verranno sovrascritti.';

  @override
  String get mpv_restore_bundled => 'Ripristina la configurazione in bundle';

  @override
  String get mpv_restore_confirm =>
      'Ripristinare la configurazione MPV in bundle? La configurazione esistente, gli script e gli shader con gli stessi nomi verranno sovrascritti. Gli altri file verranno conservati.';

  @override
  String get player_operation_incomplete =>
      'Non è stato possibile completare l\'operazione. Controlla l\'accesso al file e riprova.';

  @override
  String get custom_buttons_empty_hint =>
      'Aggiungere un pulsante del giocatore con un\'etichetta e un\'azione di stampa.';

  @override
  String get custom_button_primary => 'Pulsante predefinito';

  @override
  String get show_password => 'Mostra la password';

  @override
  String get hide_password => 'Nascondi la password';

  @override
  String get tracking_accounts_empty =>
      'Collegare un servizio nelle Impostazioni di tracciamento per gestirne le voci.';

  @override
  String get tracking_entries_empty =>
      'Nessuna voce tracciata per questo tipo di supporto. Aggiungi il monitoraggio dalla pagina dei dettagli di un titolo.';

  @override
  String get change_tracking_match => 'Cambia il titolo corrispondente';

  @override
  String get remove_tracking => 'Rimuovere il tracciamento';

  @override
  String remove_tracking_confirm(String title) {
    return 'Rimuovere il collegamento di tracciamento per “$title”? La voce nel servizio di tracciamento verrà conservata.';
  }

  @override
  String get tracking_refresh_required =>
      'Non è stato possibile confermare lo stato di tracciamento. Aggiorna prima di apportare un\'altra modifica.';

  @override
  String get tracking_entry_unlinked =>
      'Questo record non è collegato ad un titolo locale, quindi non può essere modificato qui.';

  @override
  String get backup_selection_shared =>
      'Le modifiche a queste selezioni vengono salvate immediatamente e si applicano anche ai backup automatici.';

  @override
  String get library_snapshot_history =>
      'Ripristina un\'istantanea della libreria';

  @override
  String get library_snapshot_empty =>
      'Nessuna istantanea di sicurezza disponibile.';

  @override
  String get library_snapshot_restore_message =>
      'I dati attuali verranno sostituiti da questa istantanea. Le modifiche apportate da allora andranno perse. I download eliminati non possono essere ripristinati. Le istantanee di sicurezza disponibili verranno cancellate una volta completata l\'operazione.';

  @override
  String get library_maintenance_working => 'Aggiornamento libreria…';

  @override
  String get library_safety_snapshot_note =>
      'Prima di questa operazione verrà salvata un\'istantanea di sicurezza. Non include i file scaricati.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Voci di libreria: $mangaCount. Capitoli: $chapterCount. Voci della cronologia: $historyCount. Aggiornamenti: $updateCount.\n\nScegli cosa tenere qui sotto.';
  }

  @override
  String get library_delete_pick_message =>
      'Scegliere una fonte per esaminarne i contenuti e le opzioni di cancellazione.';

  @override
  String get mobile_categories_hint =>
      'Trascina per riordinare. Apri una categoria per rinominarla o modificarne la visibilità e gli aggiornamenti.';

  @override
  String get mobile_category_visible => 'Mostra nella libreria';

  @override
  String get mobile_category_hidden => 'Nascosto dalla libreria';

  @override
  String get mobile_category_updates =>
      'Includere negli aggiornamenti della libreria';

  @override
  String get statistics_watched => 'Osservato';

  @override
  String get calendar_month => 'Mese';

  @override
  String get calendar_two_weeks => '2 settimane';

  @override
  String get calendar_week => 'Settimana';

  @override
  String get calendar_show_all_dates => 'Mostra tutte le date';

  @override
  String get update_check_no_result =>
      'Nessun aggiornamento installabile trovato. Puoi riprovare più tardi.';

  @override
  String get release_notes => 'Note sulla versione';

  @override
  String get no_release_notes => 'Nessuna nota di rilascio fornita.';

  @override
  String get downloading_update => 'Download dell\'aggiornamento in corso…';

  @override
  String get preparing_installation => 'Preparazione dell\'installazione…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Scegli cosa leggere. Puoi modificarlo in seguito.';

  @override
  String get onboarding_content_title => 'Inizia a leggere';

  @override
  String get onboarding_mobile_sources_body =>
      'Scegli un modo per iniziare o aggiungi contenuti in un secondo momento.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Passaggio $step di $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'Risultati per “$query”';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fonti',
      one: '1 fonte',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Cercare il titolo di destinazione.';

  @override
  String get migration_original_item => 'Articolo corrente';

  @override
  String get migration_target_item => 'Voce selezionata';

  @override
  String get migration_partial_failure =>
      'L\'operazione non è terminata. Alcune modifiche potrebbero essere state salvate. Controlla questo elemento nella tua libreria prima di riprovare.';

  @override
  String get migration_no_categories =>
      'Nessuna categoria. Puoi aggiungere questo articolo senza una categoria.';

  @override
  String get mass_migration_select_source => 'Scegli la sorgente corrente';

  @override
  String get mass_migration_select_all => 'Seleziona tutto';

  @override
  String get mass_migration_deselect_all => 'Deseleziona tutto';

  @override
  String get mass_migration_needs_review =>
      'Revisione delle migrazioni incomplete';

  @override
  String get bookshelf_actions => 'Azioni da scaffale';

  @override
  String get bookshelf_ignore_filters => 'Ignora i filtri durante la ricerca';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Cerca tutte le opere di questa categoria, comprese quelle nascoste dai filtri.';

  @override
  String get bookshelf_stop_update =>
      'Interrompe l\'aggiornamento della libreria';

  @override
  String bookshelf_selected_count(int count) {
    return '$count opere selezionate';
  }

  @override
  String get bookshelf_remove_library => 'Rimuovere dallo scaffale';

  @override
  String get bookshelf_remove_library_hint =>
      'Rimuove i preferiti. Anche le importazioni locali perdono la loro biblioteca e i loro record di lettura.';

  @override
  String get bookshelf_remove_downloads => 'Elimina i file scaricati';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Rimuove i file scaricati mantenendo le informazioni di lavoro.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Elimina anche i file importati locali selezionati e rimuove i relativi record dalla libreria. Questi file non possono essere recuperati qui.';

  @override
  String get bookshelf_remove_incomplete =>
      'L\'operazione non è terminata. Alcuni lavori o file potrebbero essere stati elaborati. Chiudi questa finestra di dialogo e controlla la libreria e i download prima di continuare.';

  @override
  String get bookshelf_processing => 'Elaborazione…';

  @override
  String get bookshelf_mark_read => 'Segna letto';

  @override
  String get bookshelf_mark_unread => 'Segna come non letto';

  @override
  String get bookshelf_select_all => 'Seleziona tutto';

  @override
  String get bookshelf_invert_selection => 'Inverte la selezione';

  @override
  String get bookshelf_settings => 'Impostazioni della libreria';

  @override
  String get bookshelf_settings_live =>
      'Le modifiche al filtro, all\'ordinamento e alla visualizzazione hanno effetto immediato.';

  @override
  String get bookshelf_filter_any => 'Qualsiasi';

  @override
  String get bookshelf_filter_include => 'Includi';

  @override
  String get bookshelf_filter_exclude => 'Escludere';

  @override
  String get bookshelf_all_sources => 'Tutte le fonti';

  @override
  String bookshelf_sources_selected(int count) {
    return 'Sorgenti $count selezionate';
  }

  @override
  String get bookshelf_sort_ascending => 'Crescente';

  @override
  String get bookshelf_sort_descending => 'Discendente';

  @override
  String get bookshelf_layout => 'Disposizione della libreria';

  @override
  String get bookshelf_sources_hint =>
      'Selezionare nessuno per mostrare tutte le sorgenti. Le modifiche vengono applicate quando tocchi Filtra.';

  @override
  String get bookshelf_choose_files => 'Scegli i file';

  @override
  String get bookshelf_import_wait =>
      'Scegliere un file nel selettore e attendere il completamento dell\'importazione.';

  @override
  String get bookshelf_import_incomplete =>
      'L\'importazione non è terminata. Alcuni file potrebbero già essere nella tua libreria. Chiudi questa finestra di dialogo e controlla prima di importare nuovamente.';

  @override
  String get bookshelf_categories_replace =>
      'Il salvataggio assegna queste categorie ad ogni opera selezionata, sostituendo le loro categorie precedenti.';

  @override
  String get bookshelf_categories_hint =>
      'Scegliere una o più categorie oppure lasciare vuota la selezione per non assegnarne nessuna.';

  @override
  String get bookshelf_categories_hidden =>
      'Per questo lavoro vengono mantenute le categorie nascoste esistenti.';

  @override
  String get bookshelf_categories_incomplete =>
      'Le categorie non possono essere salvate completamente. Chiudi questa finestra di dialogo e controlla lo scaffale prima di riprovare.';

  @override
  String get bookshelf_categories_none_visible =>
      'Nessuna categoria è disponibile qui. Apri la gestione delle categorie per esaminarle.';

  @override
  String get bookshelf_manage_categories => 'Gestire le categorie';

  @override
  String get manga_actions => 'Azioni comiche';

  @override
  String get manga_download_scope => 'Scaricare capitoli';

  @override
  String get manga_download_scope_hint =>
      'Scegliere i capitoli all\'interno dei filtri attuali. I capitoli scaricati vengono saltati.';

  @override
  String get manga_download_scope_empty =>
      'Nessun capitolo corrisponde ai filtri attuali. Chiudi questo menu e regola i filtri dei capitoli.';

  @override
  String get manga_action_incomplete =>
      'L\'azione non è terminata. Controlla lo stato attuale prima di riprovare.';

  @override
  String get chapter_settings => 'Impostazioni del capitolo';

  @override
  String get chapter_settings_live =>
      'Le modifiche al filtro e all\'ordinamento si applicano immediatamente.';

  @override
  String get chapter_scanlators_all => 'Mostra tutti i gruppi di scanner';

  @override
  String get chapter_scanlators_hint =>
      'Selezionare i gruppi per nascondere i loro capitoli. Le modifiche vengono applicate quando tocchi Filtra.';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count gruppi scanner nascosti';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count capitoli selezionati';
  }

  @override
  String get chapter_add_bookmark => 'Segnalibro';

  @override
  String get chapter_remove_bookmark => 'Annulla segnalibro';

  @override
  String get chapter_read_following => 'Leggi sotto';

  @override
  String get chapter_delete_records =>
      'Cancellare le registrazioni dei capitoli';

  @override
  String get chapter_delete_local_hint =>
      'Rimuove le registrazioni dei capitoli selezionati e l\'avanzamento della lettura. Sono conservati gli archivi locali originali; le copie scaricate vengono ripulite.';

  @override
  String get chapter_delete_last_hint =>
      'Questi sono tutti i capitoli di questo fumetto. Se li elimini, il fumetto verrà rimosso anche dalla libreria.';

  @override
  String get chapter_action_incomplete =>
      'L\'azione non è terminata. Alcune modifiche potrebbero essere già salvate. Chiudi e controlla i capitoli e i download prima di continuare.';

  @override
  String get reader_display_scope =>
      'A questo fumetto si applicano la modalità di lettura e l\'impaginazione manuale. Scegli una modifica per tornare alla lettura.';

  @override
  String get reader_display_single_only =>
      'La lettura continua orizzontale utilizza pagine singole.';

  @override
  String get reader_display_manual_pages =>
      'La modifica del layout di pagina disattiva la doppia pagina automatica per tutti i fumetti.';

  @override
  String get reader_display_crop_scope => 'Si applica a tutti i fumetti.';

  @override
  String get reader_chapter_locate => 'Individua il capitolo corrente';

  @override
  String get reader_chapter_search => 'Cerca capitoli o scanner';

  @override
  String get reader_chapter_scope =>
      'Utilizza i filtri dei capitoli e l\'ordinamento dai dettagli del fumetto. I segnalibri vengono salvati immediatamente.';

  @override
  String get reader_chapter_current_hidden =>
      'Il capitolo che stai leggendo è fuori dai filtri attuali.';

  @override
  String get reader_chapter_current => 'Leggo ora';

  @override
  String get reader_chapter_read => 'Leggi';

  @override
  String get reader_chapter_bookmark_failed =>
      'Non è stato possibile confermare il salvataggio del segnalibro. Chiudi l\'elenco e controlla il suo stato attuale.';

  @override
  String get reader_image_actions => 'Azioni di immagine';

  @override
  String get reader_image_original =>
      'Utilizza l\'intera pagina originale, senza traduzione, ritaglio o filtri colorati di lettura.';

  @override
  String get reader_image_save_ios =>
      'Salva nella cartella Immagini nella posizione di archiviazione corrente dell\'app.';

  @override
  String get reader_image_save_android =>
      'Salvare nella cartella Pictures/nodelane-comics del dispositivo.';

  @override
  String get reader_image_share =>
      'Aprire il foglio di condivisione del sistema.';

  @override
  String get reader_image_cover =>
      'Cambia la copertina di questo fumetto dopo la conferma.';

  @override
  String get reader_image_cover_limit =>
      'Le immagini di copertina devono essere inferiori a 5 MB. Il salvataggio e la condivisione rimangono disponibili.';

  @override
  String get reader_image_action_failed =>
      'Non è stato possibile confermare l\'azione. Chiudi questo menu e controlla il risultato prima di riprovare.';

  @override
  String get reader_settings_book_scope =>
      'Queste impostazioni si applicano solo a questo fumetto.';

  @override
  String get reader_settings_global_scope =>
      'Queste impostazioni si applicano a tutti i fumetti e vengono salvate immediatamente.';

  @override
  String get reader_filters => 'Filtri di immagine';

  @override
  String get reader_filter_scope =>
      'Si applica a tutti i fumetti. Cambia la visualizzazione della lettura senza modificare le immagini originali.';

  @override
  String get reader_auto_scroll_pause =>
      'Lo scorrimento si ferma mentre le impostazioni sono aperte.';

  @override
  String get manga_synopsis => 'Sinossi';

  @override
  String manga_author(String author) {
    return 'Autore: $author';
  }

  @override
  String get manga_continue_reading => 'Continua a leggere';

  @override
  String get reader_settings_title => 'Impostazioni del lettore';

  @override
  String get reader_picker_book_scope => 'Solo per questo fumetto';

  @override
  String get reader_picker_global_scope => 'Si applica a tutti i fumetti';

  @override
  String get reader_picker_apply_hint =>
      'Toccare per salvare e tornare al livello precedente.';

  @override
  String get reader_scale_fit_screen_hint =>
      'Adatta l\'intera pagina allo schermo';

  @override
  String get reader_scale_stretch_hint => 'Riempire l\'area di lettura';

  @override
  String get reader_scale_fit_width_hint => 'Adattare la pagina alla larghezza';

  @override
  String get reader_scale_fit_height_hint => 'Adattare la pagina all\'altezza';

  @override
  String get source_filter_active => 'Applicato';

  @override
  String get source_filter_apply => 'Applicare filtri';

  @override
  String get source_filter_scope =>
      'I filtri si applicano solo a questo sito web.';

  @override
  String get source_filter_apply_hint =>
      'Applica filtri per utilizzare le tue selezioni.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Generi',
      'author': 'Autore',
      'artist': 'Artista',
      'title': 'Titolo',
      'year': 'Anno',
      'tags': 'Tag',
      'format': 'Formato',
      'publisher': 'Editore',
      'relevance': 'Rilevanza',
      'rating': 'Valutazione',
      'views': 'Viste',
      'random': 'Casuale',
      'all': 'Tutti',
      'none': 'Nessuno',
      'action': 'Azione',
      'adventure': 'Avventura',
      'comedy': 'Commedia',
      'drama': 'Dramma',
      'fantasy': 'Fantasia',
      'romance': 'Romanticismo',
      'science_fiction': 'Fantascienza',
      'slice_of_life': 'Spaccato di vita',
      'mystery': 'Mistero',
      'horror': 'Orrore',
      'psychological': 'Psicologico',
      'historical': 'Storico',
      'sports': 'Sport',
      'supernatural': 'Soprannaturale',
      'school_life': 'Vita scolastica',
      'tragedy': 'Tragedia',
      'shounen': 'Shonen',
      'shoujo': 'Shojo',
      'seinen': 'Seinen',
      'josei': 'Josei',
      'isekai': 'Isekai',
      'martial_arts': 'Arti marziali',
      'mecha': 'Meccanismo',
      'music': 'Musica',
      'doujinshi': 'Doujinshi',
      'trending': 'Tendenza',
      'new': 'Nuovo',
      'adult_content': 'Contenuti per adulti',
      'only': 'Solo',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'Ulteriori opzioni di visualizzazione';

  @override
  String get bookshelf_more_display_hint => 'Distintivi, fonti e categorie';

  @override
  String get bookshelf_download_count => 'Conteggio download';

  @override
  String get bookshelf_source_global_hint =>
      'La visibilità della fonte utilizza la preferenza di visualizzazione condivisa.';

  @override
  String get bookshelf_select_entries => 'Selezionare le opere';

  @override
  String get bookshelf_search_options => 'Opzioni di ricerca';

  @override
  String get bookshelf_empty_hint =>
      'Raccogliere opere da fonti o importare file locali.';

  @override
  String get bookshelf_no_match_hint =>
      'Prova altre parole chiave o modifica i filtri attuali.';

  @override
  String get bookshelf_clear_query => 'Cancellare le parole chiave';

  @override
  String get bookshelf_view_selection => 'Visualizza le opere selezionate';

  @override
  String get bookshelf_import_formats =>
      'Scegli un file locale per aggiungerlo alla tua libreria.';

  @override
  String get bookshelf_import_canceled_hint =>
      'È possibile scegliere nuovamente dopo aver annullato la selezione file.';

  @override
  String get bookshelf_browse_sources => 'Sfoglia le fonti';

  @override
  String get bookshelf_empty_title => 'La tua libreria è vuota';

  @override
  String get bookshelf_no_match_title => 'Nessun lavoro corrispondente';

  @override
  String get bookshelf_mark_watched => 'Mark osservava';

  @override
  String get bookshelf_mark_unwatched => 'Segna inosservato';

  @override
  String get nodelane_account => 'NodeLane conto';

  @override
  String get nodelane_sign_in => 'Accedi a NodeLane';

  @override
  String get nodelane_account_intro =>
      'Visualizza il tuo account, l\'abbonamento e la quota di traduzione';

  @override
  String get nodelane_login_action => 'Continuare ad accedere';

  @override
  String get nodelane_login_browser =>
      'Accedere tramite il browser del sistema, quindi tornare all\'app';

  @override
  String get nodelane_account_id => 'Identificativo del conto';

  @override
  String get nodelane_account_init_error =>
      'L\'archiviazione dell\'account non è disponibile. Riavvia l\'app e riprova.';

  @override
  String get nodelane_account_refresh_error =>
      'Impossibile aggiornare le informazioni sull\'account';

  @override
  String get nodelane_account_auth_error =>
      'La tua sessione è scaduta. Accedi di nuovo';

  @override
  String get nodelane_account_unknown =>
      'Le informazioni sull\'abbonamento non sono disponibili';

  @override
  String get nodelane_account_current => 'Abbonamento attuale';

  @override
  String get nodelane_account_free => 'Conto gratuito';

  @override
  String get nodelane_account_no_subscription => 'Nessun abbonamento attivo';

  @override
  String get nodelane_account_active => 'Attivo';

  @override
  String get nodelane_account_expired => 'Scaduto';

  @override
  String get nodelane_account_expiry => 'Valido fino al';

  @override
  String get nodelane_account_renewal => 'Rinnovo';

  @override
  String get nodelane_renewal_auto => 'Rinnovo automatico';

  @override
  String get nodelane_renewal_manual => 'Rinnovo manuale';

  @override
  String get nodelane_renewal_stopped => 'Rinnovo automatico interrotto';

  @override
  String get nodelane_renewal_gift => 'Regala iscrizione';

  @override
  String get nodelane_renewal_attention =>
      'Controlla lo stato del tuo rinnovo sul sito web';

  @override
  String get nodelane_next_billing => 'Data di fatturazione successiva';

  @override
  String get nodelane_billing_unavailable =>
      'Le informazioni sul rinnovo non sono disponibili';

  @override
  String get nodelane_manage_account => 'Gestire sul sito web';

  @override
  String get nodelane_view_plans => 'Visualizza i piani di abbonamento';

  @override
  String get nodelane_translation_quota => 'Quota di traduzione';

  @override
  String get nodelane_quota_free => 'Quota libera';

  @override
  String get nodelane_quota_subscription => 'Quota di abbonamento';

  @override
  String get nodelane_quota_purchase => 'Quota acquistata';

  @override
  String get nodelane_quota_details => 'Visualizza i dettagli delle quote';

  @override
  String get nodelane_quota_expanded => 'Dettagli quota';

  @override
  String get nodelane_quota_unlimited => 'Illimitato';

  @override
  String get nodelane_quota_not_subscribed => 'Non iscritto';

  @override
  String get nodelane_quota_unknown => 'Non disponibile';

  @override
  String get nodelane_quota_used => 'Usato';

  @override
  String get nodelane_quota_reserved => 'In corso';

  @override
  String get nodelane_quota_reset => 'Prossimo ripristino';

  @override
  String get nodelane_quota_expiry => 'Prossima scadenza';

  @override
  String get nodelane_quota_no_expiry => 'Nessuna data di scadenza';

  @override
  String get nodelane_quota_reservation_note =>
      'Le pagine in lavorazione sono già detratte dalla quota disponibile';

  @override
  String nodelane_quota_available(int count) {
    return '$count pagine rimanenti';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count pagine';
  }

  @override
  String get nodelane_sign_out => 'Esci';

  @override
  String get nodelane_sign_out_confirm =>
      'La disconnessione sospende la traduzione ufficiale su questo dispositivo. La tua libreria e i progressi nella lettura vengono mantenuti.';

  @override
  String get settings_search_hint => 'Impostazioni di ricerca';

  @override
  String get settings_frequent => 'Utilizzato frequentemente';

  @override
  String get settings_reading_translation => 'Lettura e traduzione';

  @override
  String get settings_app_preferences => 'Preferenze dell\'app';

  @override
  String get settings_data_management => 'Dati e gestione';

  @override
  String get settings_more_tools => 'Altri strumenti';

  @override
  String get settings_more_tools_hint => 'Categorie, statistiche e calendario';

  @override
  String get settings_appearance_interface => 'Aspetto e interfaccia';

  @override
  String get settings_security_privacy => 'Sicurezza e privacy';

  @override
  String get settings_source_preferences => 'Impostazioni della sorgente';

  @override
  String get settings_about_help => 'Informazioni e aiuto';

  @override
  String get settings_storage_backup => 'Archiviazione e backup';

  @override
  String settings_pending_downloads(int count) {
    return '$count in sospeso';
  }

  @override
  String get settings_translation_language => 'Linguaggio di traduzione';

  @override
  String get settings_translation_scope =>
      'Utilizzato nel lettore e nella traduzione di pagine web';

  @override
  String get settings_immediate_choice =>
      'Le modifiche si applicano immediatamente';

  @override
  String get settings_translation_init_error =>
      'Le impostazioni di traduzione non sono disponibili. Riavvia l\'app e riprova.';

  @override
  String get settings_local_cache => 'Cache locale';

  @override
  String get settings_chapter_cache => 'Cache di capitoli ed episodi';

  @override
  String get settings_cover_cache => 'Cache di copertura';

  @override
  String get settings_translation_cache => 'Cache di immagini tradotte';

  @override
  String get settings_translation_cache_hint =>
      'Conservare i registri delle traduzioni e recuperare nuovamente le immagini tradotte quando necessario';

  @override
  String get settings_cache_clear => 'Cancella';

  @override
  String get settings_translation_cache_done =>
      'La cache delle immagini tradotte è stata cancellata; registri di traduzione conservati';

  @override
  String settings_cache_confirmation(String name) {
    return 'Cancella $name? Il contenuto memorizzato nella cache può essere nuovamente recuperato. Le voci della biblioteca verranno conservate.';
  }

  @override
  String get settings_advanced_options => 'Opzioni avanzate';

  @override
  String get settings_manga_reader => 'Lettore di manga';

  @override
  String get settings_novel_reader => 'Lettore di romanzi';

  @override
  String get settings_downloads => 'Scarica le impostazioni';

  @override
  String get onboarding_welcome => 'Benvenuto a';

  @override
  String get onboarding_reading_content => 'Lettura del contenuto';

  @override
  String get onboarding_choose_one => 'Scegline almeno uno';

  @override
  String get onboarding_restore_hint =>
      'Ripristina la tua libreria da un backup';

  @override
  String get onboarding_browse_hint => 'Trovare titoli sui siti Web supportati';

  @override
  String get onboarding_import_folder => 'Importare una cartella locale';

  @override
  String get onboarding_import_folder_hint =>
      'Leggi manga, romanzi e anime sul tuo dispositivo';

  @override
  String get onboarding_third_party =>
      'Aggiungere un repository di terze parti';

  @override
  String get onboarding_third_party_hint =>
      'Utilizza un indirizzo di repository che già possiedi';

  @override
  String get onboarding_repository_hint =>
      'Inserire l\'indirizzo fornito dal repository.';

  @override
  String get onboarding_repository_address => 'Indirizzo';

  @override
  String get onboarding_repository_address_hint =>
      'Immettere l\'indirizzo del repository';

  @override
  String get onboarding_add_repository => 'Aggiungi archivio';

  @override
  String get onboarding_start => 'Inizia';

  @override
  String get onboarding_open_library => 'Apri la libreria';

  @override
  String get onboarding_view_imports => 'Visualizzare il contenuto importato';

  @override
  String get onboarding_view_folders => 'Visualizza le cartelle';

  @override
  String get notice_backup_created => 'Backup creato';

  @override
  String get notice_backup_ready => 'Salvare o condividere il file di backup.';

  @override
  String get notice_backup_restored => 'Backup ripristinato';

  @override
  String get notice_backup_unsupported =>
      'Questo formato di backup non è supportato.';

  @override
  String get notice_verification_required =>
      'È richiesta la verifica del sito web';

  @override
  String get notice_verification_hint =>
      'Completa la verifica per continuare la navigazione.';

  @override
  String get notice_verify => 'Verificare il sito web';

  @override
  String get notice_action_incomplete =>
      'L\'azione non è terminata. Controlla il risultato prima di riprovare.';

  @override
  String get notice_library_updating => 'Aggiornamento della libreria';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'Titoli $current / $total controllati';
  }

  @override
  String get notice_library_failed =>
      'Alcuni titoli non possono essere aggiornati';

  @override
  String get notice_import_completed => 'Importazione completata';

  @override
  String get notice_operation_incomplete => 'Azione incompleta';

  @override
  String get subtitle_service => 'Servizio di sottotitoli in linea';

  @override
  String get subtitle_service_mode => 'Sorgente dei sottotitoli';

  @override
  String get subtitle_service_disabled =>
      'Spento · cancella le credenziali salvate';

  @override
  String get subtitle_personal_key => 'La mia chiave Wyzie';

  @override
  String get subtitle_custom_service => 'Il mio servizio di sottotitoli';

  @override
  String get subtitle_key => 'Wyzie API Chiave';

  @override
  String get subtitle_key_hint =>
      'Inserisci la tua chiave Wyzie. Rimane su questo dispositivo e non è incluso nei backup delle app.';

  @override
  String get subtitle_get_key => 'Procurarsi una chiave personale';

  @override
  String get subtitle_service_address => 'Ricerca sottotitoli URL';

  @override
  String get subtitle_service_token =>
      'Token di accesso al servizio (facoltativo)';

  @override
  String get subtitle_custom_hint =>
      'Utilizza la ricerca HTTPS completa URL di un servizio Wyzie-compatible, incluso il relativo percorso (ad esempio, /search). Inserisci un token di accesso solo se il tuo servizio ne richiede uno.';

  @override
  String get subtitle_service_off_hint =>
      'La ricerca dei sottotitoli online è disattivata. I sottotitoli incorporati, forniti dalla fonte e locali rimangono disponibili.';

  @override
  String get subtitle_setup_required =>
      'Scegliere un servizio di sottotitoli prima della ricerca.';

  @override
  String get subtitle_invalid_key => 'Inserire una chiave senza spazi.';

  @override
  String get subtitle_invalid_address =>
      'Utilizza un HTTPS URL completo senza query, frammenti o credenziali incorporate.';

  @override
  String get subtitle_invalid_token =>
      'Il token di accesso non può contenere spazi.';

  @override
  String get subtitle_storage_failed =>
      'Impossibile leggere o salvare le impostazioni dei sottotitoli. Per favore riprova.';

  @override
  String get subtitle_auth_failed =>
      'Il servizio di sottotitoli ha rifiutato l\'accesso. Controlla la tua chiave o token di servizio.';

  @override
  String get subtitle_quota_exhausted =>
      'La quota del servizio sottotitoli è esaurita. Controlla il tuo account con quel servizio.';

  @override
  String get subtitle_network_failed =>
      'Impossibile raggiungere il servizio di sottotitoli. Per favore riprova.';

  @override
  String get subtitle_response_invalid =>
      'Il servizio di sottotitoli ha restituito una risposta o un file non supportato.';

  @override
  String get detail_loading_chapters => 'Caricamento capitoli…';

  @override
  String get reader_opening_chapter => 'Capitolo di apertura';

  @override
  String get reader_open_chapter => 'Capitolo aperto';

  @override
  String get reader_loading_pages => 'Ottenere le immagini dei capitoli…';

  @override
  String get reader_loading_pages_hint =>
      'La lettura inizierà automaticamente quando sarà pronta.';

  @override
  String get reader_loading_failed => 'Impossibile caricare questo capitolo';

  @override
  String get reader_loading_retry_hint => 'Controlla la connessione e riprova.';

  @override
  String get reader_no_pages => 'Nessuna immagine trovata per questo capitolo';

  @override
  String get reader_loading_previous => 'Caricamento del capitolo precedente…';

  @override
  String get reader_previous_failed =>
      'Impossibile caricare il capitolo precedente';

  @override
  String get reader_reached_start => 'Siete arrivati al primo capitolo';

  @override
  String get reader_loading_next => 'Caricamento del capitolo successivo…';

  @override
  String get reader_next_failed =>
      'Impossibile caricare il capitolo successivo';

  @override
  String get reader_image_loading => 'Caricamento immagine…';

  @override
  String get reader_image_failure_hint =>
      'Puoi continuare a leggere altre pagine.';

  @override
  String get comic_paged => 'Pagina per pagina';

  @override
  String get comic_scroll => 'Scorrere verso il basso';

  @override
  String get comic_book_scope =>
      'Si applica solo a questo libro · le modifiche vengono salvate immediatamente';

  @override
  String get comic_defaults_title => 'Default e abitudini';

  @override
  String get comic_defaults_hint =>
      'Le impostazioni predefinite si applicano ai campi non personalizzati per un libro.';

  @override
  String get comic_habits_hint => 'Queste abitudini valgono per ogni fumetto.';

  @override
  String get comic_turn => 'Scorri alla pagina successiva';

  @override
  String get comic_left => 'Sinistra';

  @override
  String get comic_right => 'Giusto';

  @override
  String get comic_up => 'Su';

  @override
  String get comic_fit => 'Adattamento della pagina';

  @override
  String get comic_fit_contain => 'Pagina intera';

  @override
  String get comic_fit_width => 'Adatta larghezza';

  @override
  String get comic_fit_height => 'Adatta l\'altezza';

  @override
  String get comic_layout => 'Impaginazione';

  @override
  String get comic_auto => 'Automatico';

  @override
  String get comic_layout_hint =>
      'Auto mostra uno spread quando c\'è abbastanza larghezza.';

  @override
  String get comic_width => 'Larghezza del contenuto';

  @override
  String get comic_full => 'Pieno';

  @override
  String get comic_comfortable => 'Comodo';

  @override
  String get comic_narrow => 'Stretto';

  @override
  String get comic_gap => 'Spaziatura delle pagine';

  @override
  String get comic_no_gap => 'Senza soluzione di continuità';

  @override
  String get comic_small_gap => 'Piccolo';

  @override
  String get comic_image_title => 'Sintonizzare l\'immagine';

  @override
  String get comic_image_hint =>
      'Il ritaglio e il tono influiscono solo su questo libro.';

  @override
  String get comic_wide => 'Pagine larghe';

  @override
  String get comic_intact => 'Conservare intero';

  @override
  String get comic_split => 'Divisione';

  @override
  String get comic_rotate => 'Ruota';

  @override
  String get comic_wide_hint =>
      'La suddivisione segue il senso di rotazione della pagina. Si applica alla lettura di una sola pagina.';

  @override
  String get comic_cover => 'Una copertina per capitolo';

  @override
  String get comic_effects_reset => 'Ripristina le regolazioni dell\'immagine';

  @override
  String get comic_book_reset =>
      'Ripristina le impostazioni predefinite del libro';

  @override
  String get comic_book_reset_hint =>
      'Cancella le impostazioni di lettura personalizzate di questo libro. La traduzione è invariata.';

  @override
  String get comic_canvas => 'Background del lettore';

  @override
  String get comic_system => 'Sistema';

  @override
  String get comic_black => 'Nero';

  @override
  String get comic_gray => 'Grigio';

  @override
  String get comic_paper => 'Carta';

  @override
  String get comic_tap => 'Toccare per girare le pagine';

  @override
  String get comic_tap_hint =>
      'Toccare i bordi per spostarsi; tocca il centro per mostrare i controlli.';

  @override
  String get comic_scroll_start => 'Avvia lo scorrimento automatico';

  @override
  String get comic_scroll_pause => 'Sospende lo scorrimento automatico';

  @override
  String get comic_scroll_speed => 'Velocità di scorrimento';

  @override
  String get comic_scroll_hint =>
      'Si avvia quando questo pannello si chiude. Va in pausa quando l\'app lascia il primo piano.';

  @override
  String get comic_save_failed => 'Impossibile salvare. Per favore riprova.';

  @override
  String get comic_reading => 'Lettura';

  @override
  String get comic_chapter_habits_hint =>
      'Le abitudini relative all\'elenco dei capitoli si applicano a tutti i libri.';

  @override
  String get browser_title => 'Navigatore';

  @override
  String get translation_image_display => 'Visualizzazione delle immagini';

  @override
  String get translation_display_hint =>
      'Mostra prima le traduzioni esistenti. Conserva l\'originale quando non è disponibile alcuna traduzione.';

  @override
  String get translation_sign_in_required =>
      'Accedi per abilitare la traduzione';

  @override
  String get translation_sign_in_hint =>
      'Dopo aver effettuato l\'accesso, passa alle immagini tradotte per tradurre automaticamente.';

  @override
  String get translation_automatic => 'Traduzione automatica';

  @override
  String get translation_original_hint =>
      'Mostrare gli originali. Passa alle immagini tradotte per tradurre automaticamente.';

  @override
  String get translation_window_hint =>
      'Elaborare le immagini attuali e future solo durante la visualizzazione delle traduzioni.';

  @override
  String get translation_channel => 'Canale di traduzione';

  @override
  String get translation_no_images =>
      'Ancora nessuna immagine traducibile trovata in questa pagina';

  @override
  String get translation_waiting_image => 'In attesa dell\'immagine corrente';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · Le immagini $issues richiedono attenzione',
      one: ' · 1 immagine richiede attenzione',
      zero: '',
    );
    return 'Completato $complete / $total immagini$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'Toccare e tenere premuta un\'immagine per ulteriori azioni, inclusa la sua nuova traduzione.';

  @override
  String get translation_title => 'Traduzione Manga';

  @override
  String get translation_system_sign_in =>
      'Accedere utilizzando il browser di sistema';

  @override
  String get translation_target_language => 'Lingua di destinazione';

  @override
  String get translation_clear_cache =>
      'Cancella la cache delle immagini tradotte';

  @override
  String get translation_cache_hint =>
      'Conservare i registri delle traduzioni e recuperare nuovamente i risultati quando necessario.';

  @override
  String get translation_saved_read_failed =>
      'Impossibile caricare la traduzione salvata';

  @override
  String get translation_read_failed =>
      'Impossibile caricare l\'immagine tradotta';

  @override
  String get operation_retry =>
      'L\'azione non è terminata. Per favore riprova.';

  @override
  String get translation_original => 'Originale';

  @override
  String get translation_translated => 'Tradotto';

  @override
  String get translation_regenerate_image =>
      'Traduci nuovamente questa immagine';

  @override
  String get translation_read_image => 'Ricarica l\'immagine tradotta';

  @override
  String get translation_image_actions => 'Altre azioni relative alle immagini';

  @override
  String get translation_processing => 'Elaborazione';

  @override
  String get translation_reading => 'Caricamento dell\'immagine tradotta';

  @override
  String get translation_waiting => 'In attesa di traduzione';

  @override
  String get translation_preparing => 'Preparazione della traduzione';

  @override
  String get translation_uploading => 'Caricamento dell\'originale';

  @override
  String get translation_running => 'Traduzione';

  @override
  String get translation_uncertain => 'Lo stato necessita di verifica';

  @override
  String get translation_failed => 'Traduzione fallita';

  @override
  String get translation_verify => 'Verifica';

  @override
  String get translation_reread => 'Ricaricare';

  @override
  String get browser_back => 'Indietro';

  @override
  String get browser_translation => 'Traduzione di pagine Web';

  @override
  String get browser_new_tab_action => 'Apri una nuova scheda';

  @override
  String get browser_current_tab => 'Corrente';

  @override
  String get browser_close_tab => 'Chiudi scheda';

  @override
  String get browser_new_tab => 'Nuova scheda';

  @override
  String get browser_page => 'Pagina Web';

  @override
  String get browser_unopened => 'Nessuna pagina ancora aperta';

  @override
  String get browser_address_hint => 'Inserisci o incolla un URL';

  @override
  String get browser_invalid_address => 'Inserisci un URL valido';

  @override
  String get browser_clear_address => 'Cancella URL';

  @override
  String get browser_paste_address => 'Incolla URL';

  @override
  String get browser_open_address => 'Aperto URL';

  @override
  String browser_tab_count(int count) {
    return 'Schede · $count';
  }

  @override
  String get browser_load_failed => 'Impossibile aprire questa pagina';

  @override
  String get browser_load_failed_hint => 'Controlla la connessione e URL.';

  @override
  String get browser_edit_address => 'Modifica URL';

  @override
  String get browser_clear_cookies_confirm =>
      'Cancellare le sessioni di accesso per tutti i siti web?';

  @override
  String get browser_clear_cookies_hint =>
      'I siti web in tutte le schede potrebbero richiedere di effettuare nuovamente l\'accesso.';

  @override
  String get browser_clear_cookies_action => 'Cancella sessioni di accesso';

  @override
  String get browser_tab_limit =>
      'Si possono tenere aperte fino a 12 schede. Prima chiudine uno.';

  @override
  String get browser_forward => 'Avanti';

  @override
  String get browser_clear_all_cookies =>
      'Cancella tutte le sessioni di accesso al sito web';

  @override
  String get browser_clear_failed =>
      'Impossibile cancellare le sessioni. Per favore riprova.';

  @override
  String get browser_save_failed =>
      'Impossibile salvare le schede. Per favore riprova.';

  @override
  String get browser_tabs_full => '12 schede sono già aperte';

  @override
  String get browser_no_tabs => 'Ancora nessuna scheda aperta';

  @override
  String get browser_close_failed =>
      'Impossibile salvare le schede. Tocca di nuovo chiudi per riprovare.';

  @override
  String get source_pinned_websites => 'Siti web appuntati';

  @override
  String get manage => 'Gestire';

  @override
  String get translation_settings_hint =>
      'Traduzione automatica, lingua di destinazione e canale';

  @override
  String get translation_show_original => 'Toccare per mostrare l\'originale';

  @override
  String get translation_show_translated =>
      'Toccare per mostrare la traduzione';

  @override
  String get source_display => 'Display';

  @override
  String get source_cover_title => 'Copertina e titolo';

  @override
  String get source_cover_only => 'Solo copertura';

  @override
  String get source_save_search => 'Salva la ricerca corrente';

  @override
  String get source_saved_searches => 'Ricerche salvate';

  @override
  String get source_website_info => 'Informazioni sul sito web';

  @override
  String source_saved_search_title(String title) {
    return '$title · Tocca per cercare';
  }

  @override
  String get action_done => 'Fatto';

  @override
  String source_search_keyword(String query) {
    return 'Keyword: $query';
  }

  @override
  String get source_no_saved_searches => 'Nessuna ricerca ancora salvata';

  @override
  String get source_save_search_hint =>
      'Cerca una parola chiave, quindi salvala dalle azioni del sito web.';

  @override
  String get source_saved_search_scope =>
      'Le parole chiave vengono salvate solo per questo sito web.';

  @override
  String get source_search_here => 'Cercare titoli su questo sito';

  @override
  String get source_filter_results => 'Risultati filtrati';

  @override
  String get source_search_results => 'Risultati della ricerca';

  @override
  String get source_return_popular => 'Torna a popolare';

  @override
  String get source_popular_titles => 'Titoli popolari';

  @override
  String get source_no_titles => 'Nessun titolo corrispondente trovato';

  @override
  String get source_no_titles_hint =>
      'Modifica le parole chiave o i filtri o torna ai titoli popolari.';

  @override
  String get source_load_more_failed =>
      'Impossibile caricare di più. Per favore riprova.';

  @override
  String get source_load_pull_retry =>
      'Impossibile caricare questo sito Web. Tirare verso il basso per riprovare.';

  @override
  String get source_clear_failed =>
      'Impossibile completare la cancellazione. Per favore riprova.';

  @override
  String get source_uninstall_failed =>
      'Impossibile completare la disinstallazione. Per favore riprova.';

  @override
  String get source_details => 'Dettagli sulla fonte';

  @override
  String get source_repository_website => 'Sito web dell\'archivio';

  @override
  String get source_provided_settings => 'Impostazioni fornite dalla sorgente';

  @override
  String get source_advanced_actions => 'Azioni avanzate';

  @override
  String get source_edit_metadata => 'Modificare le informazioni sulla fonte';

  @override
  String get source_clear_cookies => 'Cancella i cookie per questo sito web';

  @override
  String get source_clear_cookies_hint =>
      'Potrebbe essere necessario effettuare nuovamente l\'accesso alla prossima visita.';

  @override
  String get source_uninstall => 'Disinstalla sorgente';

  @override
  String get source_settings_save_failed =>
      'Il salvataggio non è terminato. Riapri le impostazioni dell\'origine per verificare.';

  @override
  String get repository_third_party => 'Repository di terze parti';

  @override
  String get repository_refresh_failed =>
      'Impossibile aggiornare il catalogo. Cached content is kept. Per favore riprova.';

  @override
  String get repository_show_sources => 'Mostra le fonti da questo repository';

  @override
  String get repository_copy_catalog => 'Copia collegamento al catalogo';

  @override
  String get repository_remove => 'Rimuovere il repository';

  @override
  String get repository_remove_hint =>
      'Mantenere le fonti installate e rimuovere le voci di catalogo disinstallate.';

  @override
  String get repository_empty =>
      'Nessun repository di terze parti ancora aggiunto';

  @override
  String get repository_built_in => 'Catalogo ufficiale integrato';

  @override
  String get repository_hidden => 'Hidden';

  @override
  String get repository_refreshing => 'Refreshing…';

  @override
  String get repository_refresh => 'Aggiorna catalogo';

  @override
  String get repository_manage_hint =>
      'Gestire da dove vengono scaricate le fonti di terze parti.';

  @override
  String get repository_invalid_address =>
      'Inserisci un valore HTTP o HTTPS URL valido';

  @override
  String get repository_already_added =>
      'Questo repository è già stato aggiunto';

  @override
  String get repository_unrecognized =>
      'Nessun catalogo supportato trovato. Controlla il collegamento e riprova.';

  @override
  String get repository_read_failed =>
      'Impossibile leggere il catalogo. Per favore riprova.';

  @override
  String get repository_save_failed =>
      'Il salvataggio non è terminato. Controlla l\'elenco dei tuoi repository.';

  @override
  String get repository_paste_hint =>
      'Incollare un collegamento al catalogo di repository di terze parti';

  @override
  String get repository_address => 'URL';

  @override
  String get repository_paste_link => 'Incolla collegamento';

  @override
  String repository_recognized(String type) {
    return '$type · Catalogo riconosciuto';
  }

  @override
  String get repository_choose_sources_hint =>
      'Dopo aver aggiunto il repository, scegli le fonti che ti servono.';

  @override
  String get search_scope => 'Ambito di ricerca';

  @override
  String get search_scope_hint => 'Scegliere i siti web da ricercare';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cerca siti web $count',
      one: 'Cerca 1 sito web',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Trovare un sito web';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count siti web selezionati',
      one: '1 sito web selezionato',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Cancella';

  @override
  String get search_deselect_results =>
      'Deselezionare i siti web corrispondenti';

  @override
  String get search_select_results => 'Selezionare i siti web corrispondenti';

  @override
  String get search_no_websites_hint =>
      'Nessun sito web corrispondente. Prova un altro nome o lingua.';

  @override
  String get search_select_website_hint =>
      'Selezionare almeno un sito web da cercare.';

  @override
  String get search_start_title =>
      'Immettere le parole chiave per trovare i titoli';

  @override
  String get search_start_hint =>
      'Cerca più siti web contemporaneamente e mostra i titoli corrispondenti.';

  @override
  String get search_empty_scope =>
      'Nessun sito web ricercabile in questo ambito';

  @override
  String get search_empty_scope_hint =>
      'Passare a tutti i siti Web o scegliere i siti Web in cui effettuare la ricerca.';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count risultati',
      one: '1 risultato',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'Cerca titoli';

  @override
  String get search_actions => 'Azioni di ricerca';

  @override
  String get search_details => 'Ricerca dettagli';

  @override
  String get search_title_hint => 'Ricerca per titolo';

  @override
  String get search_searching => 'Ricerca';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Trovato $count risultati',
      one: 'Trovato 1 risultato',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'Nessun risultato corrispondente';

  @override
  String get search_failed => 'Ricerca fallita';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titoli trovati',
      one: '1 titolo trovato',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: '$websites siti web',
      one: '1 sito web',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Ricerca di titoli';

  @override
  String get search_complete => 'Ricerca completata';

  @override
  String get search_in_progress => 'Ricerca';

  @override
  String get search_finding_related => 'Ricerca di titoli corrispondenti…';

  @override
  String get search_no_results_yet => 'Ancora nessun risultato della ricerca';

  @override
  String get search_no_matching_titles =>
      'Nessun titolo corrispondente trovato';

  @override
  String get search_results_appear_hint =>
      'I risultati appariranno qui così come vengono trovati.';

  @override
  String get search_failed_websites_hint =>
      'Alcuni siti web non sono riusciti a completare la ricerca. Riprovali nei dettagli della ricerca.';

  @override
  String get search_change_keywords_hint =>
      'Prova parole chiave più brevi o cerca più siti web.';

  @override
  String get search_view_details => 'Visualizza i dettagli della ricerca';

  @override
  String get search_adjust_scope => 'Regola l\'ambito della ricerca';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count siti web',
      one: '1 sito web',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Completato $completed / $total';
  }

  @override
  String get search_retry_website_hint =>
      'Riprovare singolarmente i siti Web non riusciti';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementi selezionati',
      one: '1 elemento selezionato',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Cerca lingue';

  @override
  String get source_deselect => 'Deseleziona';

  @override
  String get source_select => 'Seleziona la sorgente';

  @override
  String get source_multilingual => 'Multilingue';

  @override
  String get source_language_unknown => 'Lingua non specificata';

  @override
  String get source_adult_content => 'Contiene oltre 18 contenuti';

  @override
  String get source_classification_unknown => 'Classificazione non specificata';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Visualizza tutte le informazioni sulla fonte, $count altre categorie',
      one: 'Visualizza tutte le informazioni sulla fonte, 1 categoria in più',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Caricamento del sito web';

  @override
  String get source_unpin => 'Sblocca';

  @override
  String get source_pin => 'Perno';

  @override
  String get source_open => 'Apri';

  @override
  String get source_metadata_hint =>
      'Le informazioni provengono dal catalogo di origine. Le categorie descrivono il contenuto coperto dal sito web.';

  @override
  String get source_region => 'Regione';

  @override
  String get source_format => 'Formato';

  @override
  String get source_creation => 'Creazione';

  @override
  String get source_unspecified => 'Non specificato';

  @override
  String get source_pricing => 'Prezzi';

  @override
  String get source_region_jp => 'Fumetti giapponesi';

  @override
  String get source_region_kr => 'Fumetti coreani';

  @override
  String get source_region_cn => 'Fumetti cinesi';

  @override
  String get source_region_hk_tw => 'Fumetti di Hong Kong e Taiwan';

  @override
  String get source_region_western => 'Fumetti occidentali';

  @override
  String get source_region_other => 'Altre regioni';

  @override
  String get source_format_page => 'Fumetti impaginati';

  @override
  String get source_format_vertical => 'Fumetti verticali';

  @override
  String get source_format_strip => 'Fumetti';

  @override
  String get source_creation_original => 'Originale';

  @override
  String get source_creation_fan => 'La ventola funziona';

  @override
  String get source_free_watch => 'Visione gratuita';

  @override
  String get source_free_read => 'Gratuito di lettura';

  @override
  String get source_partial_paid => 'Parzialmente pagato';

  @override
  String get source_paid_watch => 'Visione a pagamento';

  @override
  String get source_paid_read => 'Lettura a pagamento';

  @override
  String get source_pricing_unknown => 'Prezzo non specificato';

  @override
  String get source_language_filter => 'Filtra per lingua';

  @override
  String get source_language_filter_hint =>
      'Filtra solo questo catalogo. Le origini installate non sono interessate.';

  @override
  String get source_all_languages => 'Tutte le lingue';

  @override
  String get action_apply => 'Applicare';

  @override
  String get source_load_retry =>
      'Impossibile caricare questo sito Web. Per favore riprova.';

  @override
  String get source_catalog_refresh_failed =>
      'Impossibile aggiornare il catalogo. Il contenuto attuale viene mantenuto. Tirare verso il basso per riprovare.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Disinstallare i sorgenti $count?',
      one: 'Disinstallare 1 sorgente?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Disinstallare le fonti selezionate e cancellare le loro impostazioni. Conserva i titoli e i download della libreria.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Azioni non riuscite per le origini $count.',
      one: 'Azione non riuscita per 1 sorgente.',
    );
    return '$_temp0 Selezione mantenuta. Per favore riprova.';
  }

  @override
  String get source_latest_content => 'Ultimi contenuti';

  @override
  String get source_actions => 'Azioni di origine';

  @override
  String get source_bulk_manage => 'Gestire più fonti';

  @override
  String get source_update_installed => 'Aggiorna le sorgenti installate';

  @override
  String get source_no_matching_websites => 'Nessun sito web corrispondente';

  @override
  String get source_no_websites => 'Nessun sito web disponibile';

  @override
  String get source_search_installed_hint =>
      'Ricerca titoli nelle fonti installate';

  @override
  String get source_global_search => 'Ricerca tra le fonti';

  @override
  String get source_manage_repositories => 'Gestire i repository';

  @override
  String get source_view_third_party => 'Visualizza fonti di terze parti';

  @override
  String get source_catalog_load_failed =>
      'Impossibile caricare il catalogo. Tirare verso il basso per riprovare.';

  @override
  String get source_all_websites => 'Tutti i siti web';

  @override
  String get source_available => 'Disponibile per l\'installazione';

  @override
  String get source_third_party => 'Terze parti';

  @override
  String get source_name_or_title => 'Nome o titolo del sito web';

  @override
  String get view_all => 'Visualizza tutto';

  @override
  String get search_searching_ellipsis => 'Ricerca…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · Non testato';
  }

  @override
  String get onboarding_untested => 'Non testato';

  @override
  String get source_custom_scope => 'Personalizzato';

  @override
  String get source_custom_websites => 'Siti web selezionati';

  @override
  String get tv_hidden_library_hint =>
      'Ogni titolo si trova in una categoria nascosta.\nTieni premuto OK su \"Tutti\" per mostrarne uno.';

  @override
  String get tv_no_matching_anime => 'Nessun anime corrispondente';

  @override
  String tv_no_matching_category(String category) {
    return 'Nessun anime corrispondente in “$category”';
  }

  @override
  String get tv_filtered_empty_hint =>
      'Nessun anime corrisponde ai filtri attuali.\nCambiali dal pulsante accanto alla ricerca.';

  @override
  String get tv_new_episodes => 'Nuovi Episodi';

  @override
  String get tv_recently_added => 'Aggiunto di recente';

  @override
  String get tv_empty_category_hint =>
      'Ancora nessun anime in questa categoria.\nAggiungi titoli dalla pagina dei dettagli di un titolo.';

  @override
  String get tv_empty_library => 'La tua libreria di anime è vuota';

  @override
  String get tv_empty_library_hint =>
      'Aggiungi anime da Sfoglia per riempire la tua casa';

  @override
  String get tv_browse_anime => 'Sfoglia gli anime';

  @override
  String tv_new_count(int count) {
    return '$count nuovo';
  }

  @override
  String tv_category_hidden(String category) {
    return 'Nascosto “$category” · tieni premuto OK su “Tutto” per mostrarlo';
  }

  @override
  String get tv_no_hidden_categories => 'Nessuna categoria nascosta';

  @override
  String get import_torrent_file => 'importare il file .torrent';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi e altro';

  @override
  String get cloudflare_proxy_optional => 'FlareSolverr/Byparr opzionale URL';

  @override
  String get tv_home_layout_hint =>
      'Home anime basato su righe (Continua · Nuovi episodi · categorie) invece della griglia piatta';

  @override
  String get tv_hide_libraries_hint =>
      'Nascondi le librerie di manga e romanzi (attivata per impostazione predefinita sulla TV)';

  @override
  String get anime_only_hint =>
      'Nascondi manga e romanzi nell\'app. Disattiva per mostrare tutto.';

  @override
  String get audio_auto_safe => 'Auto-sicurezza';

  @override
  String get tv_player_hint =>
      'Acceso: lettore TV dedicato.  Spento: lettore originale (desktop).';

  @override
  String get release_open_failed => 'Impossibile aprire lo sblocco';

  @override
  String get tv_replay => 'Riproduzione';

  @override
  String get tv_no_episodes => 'Ancora nessun episodio';

  @override
  String get tracker_continue_series => 'Continua a guardare la serie';

  @override
  String get tracker_watchlist_series => 'Serie di watchlist';

  @override
  String get tracker_continue_movies => 'Continua a guardare i film';

  @override
  String get tracker_watchlist_movies => 'Film della lista di controllo';

  @override
  String get tracker_trending_series => 'Serie di tendenza';

  @override
  String get tracker_trending_movies => 'Film di tendenza';

  @override
  String get tracker_popular_series => 'Serie popolari';

  @override
  String get tracker_popular_movies => 'Film popolari';

  @override
  String get tracker_top_series => 'Serie principali (di tutti i tempi)';

  @override
  String get tracker_top_movies => 'Migliori film (di tutti i tempi)';

  @override
  String get tracker_airing_series => 'Serie di aerazione';

  @override
  String get tracker_airing_anime => 'Anime in onda';

  @override
  String get tracker_popular_anime => 'Anime popolari';

  @override
  String get tracker_upcoming_anime => 'Anime in arrivo';

  @override
  String get tracker_popular_manga => 'Manga popolari';

  @override
  String get tracker_top_manga => 'Miglior Manga';

  @override
  String get tracker_top_manhwa => 'Top Manhwa';

  @override
  String get tracker_top_manhua => 'Manhua superiore';

  @override
  String get tracker_latest_anime => 'Ultimi anime';

  @override
  String get tracker_best_anime => 'Anime più votato';

  @override
  String get tracker_latest_manga => 'Ultimo Manga';

  @override
  String get tracker_best_manga => 'Manga più votato';

  @override
  String get tracker_trending_anime => 'Anime di tendenza';

  @override
  String get tracker_upcoming_manga => 'Manga in arrivo';

  @override
  String get tracker_trending_manga => 'Manga di tendenza';

  @override
  String selection_progress(int selected, int total) {
    return '$selected/$total selezionato';
  }

  @override
  String get source_code_editor => 'Editor del codice';

  @override
  String get source_code_execute => 'Esegui';

  @override
  String get source_console_logs => 'Registri della console';

  @override
  String get source_no_logs => 'Ancora nessun registro';

  @override
  String get source_updated_successfully => 'Sorgente aggiornata con successo';

  @override
  String get source_obsolete => 'OBSOLETO';

  @override
  String player_seek_forward_seconds(int seconds) {
    return 'Ricerca in avanti di $seconds secondi';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return 'Ricerca indietro di $seconds secondi';
  }

  @override
  String get player_autoplay_on =>
      'Riproduzione automatica episodio successivo: on';

  @override
  String get player_autoplay_off =>
      'Riproduzione automatica episodio successivo: disattivata';

  @override
  String get player_no_other_quality => 'Nessun\'altra qualità';

  @override
  String get player_no_subtitles => 'Nessun sottotitolo';

  @override
  String get player_no_audio_tracks => 'Nessuna traccia audio';

  @override
  String get player_seek_forward => 'Cercare avanti';

  @override
  String get player_seek_backward => 'Ricerca all\'indietro';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds secondi',
      one: '1 secondo',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'Lorem ipsum dolor sit amet';

  @override
  String get subtitle_style => 'Stile';

  @override
  String get translation_official_channel => 'NodeLane Ufficiale';

  @override
  String get translation_auth_required =>
      'Accedi prima al tuo account di traduzione.';

  @override
  String get translation_source_changed =>
      'L\'immagine originale è cambiata. Per favore ricaricalo.';

  @override
  String get translation_source_missing =>
      'L\'immagine originale non è attualmente disponibile.';

  @override
  String get translation_resource_limit =>
      'Questa immagine supera il limite di elaborazione del dispositivo. L\'originale viene mantenuto.';

  @override
  String get translation_storage_full =>
      'La memoria di traduzione è piena. Cancella prima le immagini tradotte.';

  @override
  String get translation_invalid_image =>
      'Formato immagine o contenuto non valido.';

  @override
  String get translation_unsupported_image =>
      'La traduzione non è supportata per questa immagine. L\'originale viene mantenuto.';

  @override
  String get translation_invalid_result =>
      'La convalida dell\'immagine tradotta non è riuscita. Per favore ricaricalo.';

  @override
  String get translation_result_unavailable =>
      'L\'immagine tradotta non è disponibile. Per favore ricaricalo.';

  @override
  String get translation_result_expired =>
      'L\'immagine tradotta è scaduta. Per favore traducilo di nuovo.';

  @override
  String get translation_analysis_too_large =>
      'C\'è troppo contenuto dell\'immagine da analizzare. Ridurre le dimensioni dell\'immagine e riprovare.';

  @override
  String get translation_region_limit =>
      'L\'immagine ha troppe regioni di testo. Dividilo e riprova.';

  @override
  String get translation_text_limit =>
      'Una regione di testo è troppo lunga. Regola l\'immagine e riprova.';

  @override
  String get translation_unavailable =>
      'Questa traduzione non è più disponibile.';

  @override
  String get translation_outcome_unknown =>
      'Il risultato necessita di verifica. Non è stato inviato nuovamente.';

  @override
  String get translation_rate_limited =>
      'Le richieste sono limitate. La traduzione riprenderà automaticamente.';

  @override
  String get translation_quota_exhausted =>
      'Quota di traduzione insufficiente.';

  @override
  String get translation_unsupported_language =>
      'Il servizio non supporta questa lingua di destinazione.';

  @override
  String get translation_upgrade_required =>
      'Il protocollo di traduzione è incompatibile. Aggiorna l\'app.';

  @override
  String get translation_remote_failed =>
      'Traduzione non riuscita per questa pagina. Puoi riprovare manualmente.';

  @override
  String get translation_bridge_invalid =>
      'La ​​pagina web è cambiata. Abilita nuovamente la traduzione.';

  @override
  String get translation_connection_failed =>
      'Connessione fallita. Per favore riprova.';

  @override
  String get translation_paused =>
      'Traduzione in pausa. Puoi verificarne l\'avanzamento.';

  @override
  String get translation_preparing_ellipsis =>
      'Preparazione della traduzione...';

  @override
  String get translation_checking_original =>
      'Controllo dell\'immagine originale…';

  @override
  String get translation_submitting => 'Invio…';

  @override
  String get translation_uploading_ellipsis => 'Caricamento originale…';

  @override
  String get translation_waiting_ellipsis => 'In attesa di traduzione…';

  @override
  String get translation_running_ellipsis => 'Traduzione…';

  @override
  String get translation_verify_result => 'Il risultato necessita di verifica';

  @override
  String get translation_partial => 'Alcuni contenuti sono stati tradotti';

  @override
  String get translation_ready => 'Immagine tradotta pronta';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Giocare';

  @override
  String get player_quality => 'Qualità';

  @override
  String get player_subtitles => 'Sottotitoli';

  @override
  String get player_audio => 'Audio';

  @override
  String get player_statistics => 'Statistiche per nerd';

  @override
  String get player_auto => 'Automatico';

  @override
  String get source_information => 'Informazioni sulla fonte';

  @override
  String get source_code_page => 'Pagina';

  @override
  String get source_code_query => 'Interrogazione';

  @override
  String get repository_invalid_source => 'Fonte non valida: rimuoverla';

  @override
  String get player_fit_contain => 'Contenere';

  @override
  String get player_fit_cover => 'Copertura';

  @override
  String get player_fit_fill => 'Riempi';

  @override
  String get player_fit_height => 'Altezza';

  @override
  String get player_fit_width => 'Larghezza';

  @override
  String get player_fit_scale => 'Scala';

  @override
  String get player_fit_none => 'Nessuno';

  @override
  String get player_shader_clear => 'Disattivato (cancella shader)';

  @override
  String get player_shader_luma => 'Aumento della luminanza';

  @override
  String get player_decoder_auto => 'Automatico (hardware)';

  @override
  String get player_decoder_software => 'Software (nessun hardware)';

  @override
  String get player_stats_toggle => 'Attiva/disattiva la sovrapposizione';

  @override
  String get player_stats_general => 'Generale';

  @override
  String get player_stats_frames => 'Tempistiche dei frame';

  @override
  String get player_stats_cache => 'Cache di input';

  @override
  String get player_stats_filters => 'Filtri attivi';

  @override
  String get player_stats_log => 'Registro';

  @override
  String get source_mark_pinned => 'Perno';

  @override
  String translation_image_action(String action) {
    return '$action questa immagine';
  }

  @override
  String get memory_waiting => 'memoria: attesa di un campione';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current picco $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'cache $current / $limit picco $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'elementi $count / $limit in tempo reale $live picco $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count campioni',
      one: '1 campione',
    );
    return 'pieno $percent% di $_temp0';
  }

  @override
  String get memory_reset_hint =>
      'attivarlo e disattivarlo nelle impostazioni per ripristinare';

  @override
  String get action_hide => 'Nascondi';

  @override
  String discord_get_app(String app) {
    return 'Ottieni $app';
  }

  @override
  String get discord_idle => 'Inattivo';

  @override
  String discord_watching_title(String title) {
    return 'Guardando $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'Lettura $title';
  }
}
