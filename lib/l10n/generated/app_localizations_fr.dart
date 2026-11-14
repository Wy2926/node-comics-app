// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get browser_search_hint => 'Rechercher ou saisir une URL';

  @override
  String get browser_start_hint => 'Une nouvelle page pour vos découvertes.';

  @override
  String get browser_search_engine => 'Moteur de recherche';

  @override
  String get browser_bookmarks => 'Favoris';

  @override
  String get browser_search_library => 'Rechercher des titres ou des URL';

  @override
  String get browser_data_failed =>
      'Impossible de lire ou d’enregistrer les données du navigateur. Réessayez.';

  @override
  String get browser_clear_history => 'Effacer l’historique de navigation';

  @override
  String get browser_clear_history_hint =>
      'Supprimer tout l’historique sur cet appareil ? Les favoris et les connexions aux sites seront conservés.';

  @override
  String get browser_library_empty => 'Aucun élément pour le moment';

  @override
  String get browser_bookmarks_hint =>
      'Ajoutez une page aux favoris depuis son menu pour la retrouver ici.';

  @override
  String get browser_history_hint =>
      'Les pages visitées restent ici même après la fermeture de leurs onglets.';

  @override
  String get browser_recent => 'Visites récentes';

  @override
  String get browser_pinned_hint =>
      'Épinglez vos sites préférés dans Sources pour y accéder rapidement.';

  @override
  String get browser_start_page => 'Page d’accueil';

  @override
  String get browser_remove_bookmark => 'Retirer des favoris';

  @override
  String get browser_add_bookmark => 'Ajouter aux favoris';

  @override
  String get browser_find => 'Rechercher dans la page';

  @override
  String get browser_copy_link => 'Copier le lien';

  @override
  String get browser_action_failed =>
      'Impossible de terminer cette action. Réessayez.';

  @override
  String get browser_find_previous => 'Résultat précédent';

  @override
  String get browser_find_next => 'Résultat suivant';

  @override
  String browser_find_matches(int current, int total) {
    return 'Résultat $current sur $total';
  }

  @override
  String get app_update_details_hint =>
      'Afficher les notes de version et les options d\'installation';

  @override
  String get app_update_download => 'Télécharger la mise à jour';

  @override
  String get app_update_download_hint =>
      'Après le téléchargement, suivez les invites pour installer la mise à jour.';

  @override
  String get bookshelf_all => 'Tous';

  @override
  String get bookshelf_search => 'Bibliothèque de recherche';

  @override
  String get app_update_allow_install =>
      'Autorisez l\'installation de l\'application dans les paramètres système, puis revenez et appuyez sur Installer.';

  @override
  String get app_update_waiting =>
      'En attente que le système reprenne le téléchargement…';

  @override
  String get app_update_cancel_download => 'Annuler le téléchargement';

  @override
  String get app_update_remove_package => 'Supprimer le package téléchargé';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'Aucun paramètre correspondant';

  @override
  String get search_empty_hint =>
      'Essayez un autre mot-clé ou effacez la recherche pour tout voir.';

  @override
  String get search_clear => 'Effacer la recherche';

  @override
  String get app_updates => 'Mises à jour de l\'application';

  @override
  String get app_update_auto => 'Vérification au lancement';

  @override
  String get app_update_view => 'Afficher la mise à jour';

  @override
  String get app_update_later => 'Plus tard';

  @override
  String get app_update_external_hint =>
      'Ouvre le lien de mise à jour dans votre navigateur';

  @override
  String get app_update_failed =>
      'Impossible de vérifier les mises à jour. Veuillez réessayer.';

  @override
  String get app_update_opened => 'Lien de mise à jour ouvert';

  @override
  String get app_diagnostics => 'Diagnostics et journaux';

  @override
  String get library => 'Bibliothèque';

  @override
  String get updates_search => 'Rechercher des mises à jour';

  @override
  String get updates => 'Nouveautés';

  @override
  String get history => 'Historique';

  @override
  String get browse => 'Explorer';

  @override
  String get more => 'Plus';

  @override
  String get open_random_entry => 'Ouvrir une entrée au hasard';

  @override
  String get import => 'Importer';

  @override
  String get filter => 'Filtre';

  @override
  String get ignore_filters => 'Ignorer les filtres';

  @override
  String get downloaded => 'Téléchargé';

  @override
  String get unread => 'Non lus';

  @override
  String get unwatched => 'Non regardé';

  @override
  String get started => 'Commencé';

  @override
  String get bookmarked => 'Signets';

  @override
  String get sort => 'Trier';

  @override
  String get alphabetically => 'Alphabétiquement';

  @override
  String get last_read => 'Dernier lu';

  @override
  String get last_watched => 'Dernièrement regardé';

  @override
  String get last_update_check => 'Dernière mise à jour';

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
          'Tu es en train de supprimer les $count $entryTypePlural de ce $mediaType de ta bibliothèque.',
      one:
          'Tu es en train de supprimer le seul $entryType de ce $mediaType de ta bibliothèque.',
    );
    return '$_temp0\nÇa va aussi supprimer tout le $mediaType de ta bibliothèque.\n\nNote : Les fichiers ne seront pas supprimés.';
  }

  @override
  String get chapter => 'chapitre';

  @override
  String get episode => 'épisode';

  @override
  String get unread_count => 'Nombre de non-lus';

  @override
  String get unwatched_count => 'Nombre non vu';

  @override
  String get latest_chapter => 'Dernier chapitre';

  @override
  String get latest_episode => 'Dernier épisode';

  @override
  String get date_added => 'Date ajoutée';

  @override
  String get display => 'Affichage';

  @override
  String get display_mode => 'Mode d\'affichage';

  @override
  String get compact_grid => 'Grille compacte';

  @override
  String get compression_level => 'Niveau de compression';

  @override
  String compression_info(Object level) {
    return 'La compression plus élevée = moins d\'espace mais plus d\'utilisation CPU. Par défaut: $level';
  }

  @override
  String get comfortable_grid => 'Grille espacée';

  @override
  String get cover_only_grid => 'Grille avec seulement la couverture';

  @override
  String get list => 'Liste';

  @override
  String get badges => 'Badges';

  @override
  String get downloaded_chapters => 'Chapitres téléchargés';

  @override
  String get downloaded_episodes => 'Épisodes téléchargés';

  @override
  String get language => 'Langue';

  @override
  String get local_source => 'Source locale';

  @override
  String get tabs => 'Onglets';

  @override
  String get show_category_tabs => 'Afficher les onglets des catégories';

  @override
  String get show_numbers_of_items => 'Afficher le nombre d’entrées';

  @override
  String get other => 'Autre';

  @override
  String get show_continue_reading_buttons =>
      'Afficher le bouton Continuer la lecture';

  @override
  String get show_continue_watching_buttons =>
      'Afficher les boutons de reprise';

  @override
  String get empty_library => 'Votre bibliothèque est vide';

  @override
  String get search => 'Rechercher...';

  @override
  String get no_recent_updates => 'Aucune mise à jour disponible';

  @override
  String get remove_everything => 'Tout retirer';

  @override
  String get remove_everything_msg =>
      'Êtes-vous sûr(e) ? Tout l\'historique sera effacé.';

  @override
  String get remove_all_update_msg =>
      'Êtes-vous sûr ? Toute la mise à jour sera effacée';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get remove => 'Supprimer';

  @override
  String get remove_history_msg =>
      'Ceci enlèvera la date de lecture de ce chapitre. Êtes-vous sûr(e) ?';

  @override
  String get last_used => 'Dernière utilisée';

  @override
  String get pinned => 'Épinglé';

  @override
  String get sources => 'Sources';

  @override
  String get install => 'Installer';

  @override
  String get update => 'Mettre à jour';

  @override
  String get latest => 'Récents';

  @override
  String get extensions => 'Extensions';

  @override
  String get migrate => 'Migrer';

  @override
  String get mass_migration_title => 'Migration massive';

  @override
  String get mass_migration_preview_items => 'Aperçu des éléments';

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
  String get migrate_confirm => 'Migrer vers une autre source';

  @override
  String get clean_database => 'Nettoyer la base de données';

  @override
  String cleaned_database(Object x) {
    return 'Base de données nettoyée ! $x entrées supprimées';
  }

  @override
  String get clean_database_desc =>
      'Cela supprimera tous les éléments qui ne sont pas ajoutés à la bibliothèque !';

  @override
  String get incognito_mode => 'Mode navigation privée';

  @override
  String get incognito_mode_description => 'Suspend l\'historique de lecture';

  @override
  String get downloaded_only => 'Téléchargés uniquement';

  @override
  String get downloaded_only_description =>
      'Afficher uniquement les entrées téléchargées dans votre bibliothèque';

  @override
  String get download_queue => 'File de téléchargement';

  @override
  String get categories => 'Catégories';

  @override
  String get statistics => 'Statistiques';

  @override
  String get settings => 'Paramètres';

  @override
  String get about => 'À propos';

  @override
  String get help => 'Aide';

  @override
  String get no_downloads => 'Aucun téléchargement en cours';

  @override
  String get edit_categories => 'Modifier les catégories';

  @override
  String get edit_categories_description =>
      'Vous n\'avez aucune catégorie. Appuyez sur le bouton « + » pour en créer une afin d\'organiser votre bibliothèque.';

  @override
  String get add => 'Ajouter';

  @override
  String get add_category => 'Ajouter une catégorie';

  @override
  String get name => 'Nom';

  @override
  String label_value(Object label, Object value) {
    return '$label : $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*obligatoire';

  @override
  String get add_category_error_exist =>
      'Une catégorie avec ce nom existe déjà !';

  @override
  String get delete_category => 'Effacer catégorie';

  @override
  String delete_category_msg(Object name) {
    return 'Souhaitez-vous supprimer la catégorie $name?';
  }

  @override
  String get rename_category => 'Renommer la catégorie';

  @override
  String get general => 'Général';

  @override
  String get general_subtitle => 'Langue de l\'application';

  @override
  String get app_language => 'Langue de l\'application';

  @override
  String get default_subtitle_language => 'Langue des sous-titres par défaut';

  @override
  String get appearance => 'Apparence';

  @override
  String get appearance_subtitle => 'Thème, format de la date et de l\'heure';

  @override
  String get theme => 'Thème';

  @override
  String get dark_mode => 'Mode sombre';

  @override
  String get follow_system_theme => 'Suivre le thème du système';

  @override
  String get on => 'Activé';

  @override
  String get off => 'Desactivé';

  @override
  String get pure_black_dark_mode => 'Mode noir pur';

  @override
  String get timestamp => 'Horodatage';

  @override
  String get relative_timestamp => 'Horodatages relatifs';

  @override
  String get relative_timestamp_short => 'Court (Aujourd\'hui, Hier)';

  @override
  String get relative_timestamp_long => 'Long (Court+, il y a n jours)';

  @override
  String get date_format => 'Format de date';

  @override
  String get reader => 'Lecteur';

  @override
  String get refresh => 'Actualiser';

  @override
  String get reader_subtitle => 'Mode de lecture, affichage, navigation';

  @override
  String get default_reading_mode => 'Mode de lecture par défaut';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'De gauche à droite';

  @override
  String get reading_mode_right_to_left => 'De droite à gauche';

  @override
  String get reading_mode_vertical_continuous => 'Vertical continu';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Vitesse d\'animation du double-clic';

  @override
  String get normal => 'Normale';

  @override
  String get fast => 'Rapide';

  @override
  String get no_animation => 'Sans animation';

  @override
  String get animate_page_transitions => 'Activer les transitions';

  @override
  String get crop_borders => 'Rogner les bordures';

  @override
  String get downloads => 'Téléchargements';

  @override
  String get downloads_subtitle => 'Paramètres de téléchargement';

  @override
  String get download_location => 'Répertoire de téléchargement';

  @override
  String get custom_location => 'Répertoire personnalisé';

  @override
  String get only_on_wifi => 'Uniquement en Wi-Fi';

  @override
  String get save_as_cbz_archive => 'Enregistrer comme archive CBZ';

  @override
  String get delete_download_after_reading => 'Supprimer après la lecture';

  @override
  String get concurrent_downloads => 'Téléchargements simultanés';

  @override
  String get browse_subtitle => 'Sources, extensions, recherche globale';

  @override
  String get only_include_pinned_sources =>
      'N\'inclure que les sources épinglées';

  @override
  String get nsfw_sources => 'Contenu +18';

  @override
  String get nsfw_sources_show =>
      'Afficher dans les listes de sources et d\'extensions';

  @override
  String get nsfw_sources_info =>
      'Ceci n\'empêche pas les extensions non officielles ou potentiellement mal signalées de diffuser du contenu +18 dans l\'application.';

  @override
  String get version => 'Version';

  @override
  String beta_version(Object version) {
    return 'Bêta ($version)';
  }

  @override
  String get check_for_update => 'Rechercher des mises à jour';

  @override
  String get logs_on => 'Activer la journalisation';

  @override
  String get share_app_logs => 'Partager les journaux de l\'application';

  @override
  String get no_app_logs => 'Aucun fichier log.txt disponible !';

  @override
  String get failed => 'Échoué !';

  @override
  String n_days_ago(Object days) {
    return 'Il y a $days jours';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get a_week_ago => 'Il y a une semaine';

  @override
  String get next_week => 'La semaine prochaine';

  @override
  String get add_to_library => 'Ajouter à la bibliothèque';

  @override
  String get completed => 'Terminé';

  @override
  String get ongoing => 'En cours';

  @override
  String get on_hiatus => 'En pause';

  @override
  String get canceled => 'Annulé';

  @override
  String get publishing_finished => 'Publication terminée';

  @override
  String get unknown => 'Inconnue';

  @override
  String get empty_placeholder => 'VIDE';

  @override
  String get error => 'Erreur';

  @override
  String error_with_message(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get no_pages_available => 'Erreur : aucune page disponible';

  @override
  String get set_categories => 'Ajouter une catégorie';

  @override
  String get edit => 'Modifier';

  @override
  String get in_library => 'Dans la bibliothèque';

  @override
  String get filter_scanlator_groups => 'Filtrer les groupes des traducteurs';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get by_source => 'Par source';

  @override
  String get by_chapter_number => 'Par numéro de chapitre';

  @override
  String get by_episode_number => 'Par numéro d\'épisode';

  @override
  String get by_upload_date => 'Par date de téléversement';

  @override
  String get source_title => 'Titre de la source';

  @override
  String get create_extension => 'Créer une extension';

  @override
  String get developer_mode => 'Mode développeur';

  @override
  String get developer_mode_subtitle =>
      'Afficher les options pour créer une extension et modifier le code';

  @override
  String get choose_extension_language => 'Choisir la langue de l\'extension';

  @override
  String get lang => 'Langue';

  @override
  String get base_url => 'URL de base';

  @override
  String get api_url_optional => 'URL de l\'API (optionnel)';

  @override
  String get icon_url => 'URL de l\'icône';

  @override
  String get source_icon_url => 'URL de l\'icône de la source';

  @override
  String get notes => 'Remarques';

  @override
  String get extension_name_example => 'ex : monAnime';

  @override
  String get language_code_example => 'ex : fr';

  @override
  String get base_url_example => 'ex : https://exemple.com';

  @override
  String get api_url_example => 'ex : https://api.exemple.com';

  @override
  String get extension_notes_example =>
      'ex : cette extension nécessite une connexion';

  @override
  String get type => 'Type';

  @override
  String get target => 'Cible';

  @override
  String get source_type_single => 'unique';

  @override
  String get source_type_multi => 'multiple';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS compilé LNReader';

  @override
  String get source_created_successfully => 'Source créée avec succès';

  @override
  String get source_already_exists => 'La source existe déjà';

  @override
  String get error_when_creating_source =>
      'Erreur lors de la création de la source';

  @override
  String get cookies_deleted => 'Cookies supprimés !';

  @override
  String get delete_all_cookies => 'Supprimer tous les cookies';

  @override
  String get chapter_number => 'Numéro de chapitre';

  @override
  String get episode_number => 'Numéro d\'épisode';

  @override
  String get share => 'Partager';

  @override
  String n_chapters(Object n) {
    return '$n chapitres';
  }

  @override
  String missing_chapters(Object count) {
    return '$count chapitres manquants';
  }

  @override
  String get no_description => 'Aucune description';

  @override
  String get resume => 'Reprendre';

  @override
  String get read => 'Commencer';

  @override
  String get watch => 'Regarder';

  @override
  String get popular => 'Populaire';

  @override
  String get open_in_browser => 'Ouvrir dans le navigateur';

  @override
  String get clear_cookie => 'Effacer les cookies';

  @override
  String get show_page_number => 'Afficher le numéro des pages';

  @override
  String get from_library => 'De la bibliothèque';

  @override
  String get downloaded_chapter => 'Chapitres téléchargés';

  @override
  String page(Object page) {
    return 'Page $page';
  }

  @override
  String get global_search => 'Recherche globale';

  @override
  String get color_blend_level => 'Niveau de mélange des couleurs';

  @override
  String current(Object char) {
    return 'En cours $char';
  }

  @override
  String finished(Object char) {
    return 'Terminé $char';
  }

  @override
  String next(Object char) {
    return 'Suivant $char';
  }

  @override
  String previous(Object char) {
    return 'Précédent $char';
  }

  @override
  String get no_more_chapter => 'C\'était le dernier chapitre';

  @override
  String get no_result => 'Aucun résultat';

  @override
  String get send => 'Envoyer';

  @override
  String get delete => 'Supprimer';

  @override
  String get start_downloading => 'Commencer à télécharger';

  @override
  String get retry => 'Réessayer';

  @override
  String get add_chapters => 'Ajouter des chapitres';

  @override
  String get delete_chapters => 'Supprimer le chapitre ?';

  @override
  String get default0 => 'défaut';

  @override
  String get total_chapters => 'Nombre de chapitres';

  @override
  String get total_episodes => 'Total des épisodes';

  @override
  String get import_local_file => 'Importer des fichiers';

  @override
  String get import_files => 'Fichiers';

  @override
  String get split_epub_chapters => 'Diviser en chapitres';

  @override
  String get split_epub_chapters_description =>
      'Importer chaque chapitre EPUB comme une entrée séparée';

  @override
  String get nothing_read_recently => 'Rien de lu recemment';

  @override
  String get status => 'Statut';

  @override
  String get not_started => 'Pas commencé';

  @override
  String get score => 'Note';

  @override
  String get start_date => 'Date de début';

  @override
  String get finish_date => 'Date de fin';

  @override
  String get reading => 'En cours';

  @override
  String get on_hold => 'En pause';

  @override
  String get dropped => 'Abandonné';

  @override
  String get plan_to_read => 'À lire';

  @override
  String get re_reading => 'Relecture';

  @override
  String get chapters => 'Chapitres';

  @override
  String get add_tracker => 'Ajouter le suivi';

  @override
  String get one_tracker => 'Suivi par 1 service';

  @override
  String n_tracker(Object n) {
    return 'Suivi par $n services';
  }

  @override
  String get tracking => 'Suivi';

  @override
  String get syncing => 'Synchronisation';

  @override
  String get sync_logged => 'Connexion réussie';

  @override
  String get syncing_subtitle =>
      'Saisissez l’adresse de votre serveur de synchronisation et connectez-vous dans le navigateur pour synchroniser votre progression de lecture entre vos appareils.';

  @override
  String get sync_service => 'Synchronisation auto-hébergée';

  @override
  String get last_sync => 'Dernière synchronisation à : ';

  @override
  String get sync_login_browser => 'Se connecter avec le navigateur';

  @override
  String get sync_server => 'Adresse du serveur de synchronisation';

  @override
  String get sync_starting => 'Synchronisation de départ...';

  @override
  String get sync_finished => 'Synchronisation terminée';

  @override
  String get sync_failed => 'Échec de la synchronisation';

  @override
  String get sync_restore_in_progress =>
      'Synchronisation ignorée — restauration en cours';

  @override
  String sync_progress_percent(Object percent) {
    return 'Synchronisation… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Synchronisation…';

  @override
  String get sync_button_sync => 'Synchroniser les progrès';

  @override
  String get sync_button_upload => 'Téléverser uniquement';

  @override
  String get sync_button_upload_info =>
      'Cette opération remplacera complètement les données distantes par les données locales !';

  @override
  String get sync_button_download => 'Télécharger uniquement';

  @override
  String get sync_button_download_info =>
      'Cette opération remplacera complètement les données locales par les données distantes !';

  @override
  String get sync_status_not_configured => 'Non connecté';

  @override
  String get sync_status_checking => 'Vérification de la connexion...';

  @override
  String get sync_status_connected => 'Connecté';

  @override
  String get sync_status_unauthorized =>
      'Session expirée, veuillez vous reconnecter';

  @override
  String get sync_status_unreachable => 'Serveur inaccessible';

  @override
  String get sync_section_general => 'Général';

  @override
  String get sync_on => 'Activer la synchronisation';

  @override
  String get sync_auto => 'Synchronisation automatique';

  @override
  String get sync_auto_warning =>
      'La synchronisation automatique est actuellement une fonctionnalité expérimentale !';

  @override
  String get sync_auto_off => 'Désactivé';

  @override
  String get sync_auto_5_minutes => 'Toutes les 5 minutes';

  @override
  String get sync_auto_10_minutes => 'Toutes les 10 minutes';

  @override
  String get sync_auto_30_minutes => 'Toutes les 30 minutes';

  @override
  String get sync_auto_1_hour => 'Toutes les 1 heure';

  @override
  String get sync_auto_3_hours => 'Toutes les 3 heures';

  @override
  String get sync_auto_6_hours => 'Toutes les 6 heures';

  @override
  String get sync_auto_12_hours => 'Toutes les 12 heures';

  @override
  String get server_error => 'Erreur du serveur !';

  @override
  String get dialog_confirm => 'Confirmer';

  @override
  String get description => 'Description';

  @override
  String get reorder_navigation => 'Personnaliser la navigation';

  @override
  String get reorder_navigation_description =>
      'Réorganisez et ajustez chaque navigation selon vos besoins.';

  @override
  String get floating_navigation_bar => 'Barre de navigation flottante';

  @override
  String get floating_navigation_bar_description =>
      'Utilisez une capsule flottante au lieu de la barre de navigation standard attachée.';

  @override
  String get full_screen_player => 'Utiliser le mode plein écran';

  @override
  String get full_screen_player_info =>
      'Utiliser automatiquement le mode plein écran lors de la lecture d\'une vidéo.';

  @override
  String episode_progress(Object n) {
    return 'Progression: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n épisodes';
  }

  @override
  String missing_episodes(Object count) {
    return '$count épisodes manquants';
  }

  @override
  String get manga_sources => 'Sources des mangas';

  @override
  String get anime_sources => 'Sources d\'animés';

  @override
  String get novel_sources => 'Sources de romans';

  @override
  String get anime_extensions => 'Extensions d\'animés';

  @override
  String get manga_extensions => 'Extensions des mangas';

  @override
  String get novel_extensions => 'Extensions de romans';

  @override
  String get extension_settings => 'Paramètres de l\'extension';

  @override
  String get anime => 'Animé';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Roman';

  @override
  String get library_no_category_exist =>
      'Vous n\'avez pas encore de catégories';

  @override
  String get watching => 'En lecture';

  @override
  String get plan_to_watch => 'À regarder';

  @override
  String get re_watching => 'Revisionnage';

  @override
  String get episodes => 'Épisodes';

  @override
  String get download => 'Télécharger';

  @override
  String get new_update_available => 'Une nouvelle version est disponible';

  @override
  String app_version(Object v) {
    return 'Version de l\'application : v$v';
  }

  @override
  String get searching_for_updates => 'Vérification des mise à jours';

  @override
  String get no_new_updates_available => 'Aucune mise à jours disponible';

  @override
  String get uninstall => 'Désinstaller';

  @override
  String uninstall_extension(Object ext) {
    return 'Désinstaller l\'extension $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Appuyez deux fois pour rechercher tous les $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Afficher l\'astuce de recherche par double appui';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Afficher une info-bulle sur les onglets Manga/Anime/Roman expliquant qu\'un double appui ouvre la recherche globale.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" est déjà dans votre bibliothèque via $source.';
  }

  @override
  String get add_anyway => 'Ajouter quand même';

  @override
  String get langauage => 'Langue';

  @override
  String get extension_detail => 'Informations de l\'extension';

  @override
  String get scale_type => 'Type de mise à l\'échelle';

  @override
  String get scale_type_fit_screen => 'Adapter à l\'écran';

  @override
  String get scale_type_stretch => 'Étirer';

  @override
  String get scale_type_fit_width => 'Adapter à la largeur';

  @override
  String get scale_type_fit_height => 'Adapter à la hauteur';

  @override
  String get scale_type_original_size => 'Taille originale';

  @override
  String get scale_type_smart_fit => 'Adaptation intelligente';

  @override
  String get page_preload_amount => 'Nombre de page à précharger';

  @override
  String get page_preload_amount_subtitle =>
      'Le nombre de pages à précharger pendant la lecture. De plus grandes valeurs rendront la lecture plus fluide au coût d\'un plus grand cache et d\'une plus grande utilisation de données.';

  @override
  String get image_loading_error => 'L\'image n\'a pas pu être chargée';

  @override
  String get add_episodes => 'Ajouter Épisodes';

  @override
  String get video_quality => 'Qualité';

  @override
  String get video_subtitle => 'Sous-titre';

  @override
  String get check_for_extension_updates =>
      'Vérifier les mise à jour d\'extensions';

  @override
  String get auto_extensions_updates => 'Mises à jour auto des extensions';

  @override
  String get auto_extensions_updates_subtitle =>
      'Mettra automatiquement à jour l\'extension lorsqu\'une nouvelle version est disponible.';

  @override
  String get check_for_app_updates =>
      'Vérifier les mises à jour de l\'application au démarrage';

  @override
  String get reading_mode => 'Mode de lecture';

  @override
  String get custom_filter => 'Filtre personnalisé';

  @override
  String get background_color => 'Couleur de fond';

  @override
  String get white => 'Blanc';

  @override
  String get black => 'Noir';

  @override
  String get grey => 'Gris';

  @override
  String get automaic => 'Automatique';

  @override
  String get preferred_domain => 'Domaine préféré';

  @override
  String get load_more => 'Charger plus';

  @override
  String get cancel_all_for_this_series => 'Tout annuler pour cette serie';

  @override
  String get login => 'Connexion';

  @override
  String login_into(Object tracker) {
    return 'Connexion à $tracker';
  }

  @override
  String get email_adress => 'Adresse couriel';

  @override
  String get password => 'Mot de passe';

  @override
  String log_out_from(Object tracker) {
    return 'Se déconnecter de $tracker ?';
  }

  @override
  String get log_out => 'Se déconnecter';

  @override
  String get update_pending => 'Mises à jour en attente';

  @override
  String get update_all => 'Tout mettre à jour';

  @override
  String get backup_and_restore => 'Sauvegarder et restaurer';

  @override
  String get create_backup => 'Créer une sauvegarde';

  @override
  String get create_backup_dialog_title => 'Que voulez-vous sauvegarder ?';

  @override
  String get create_backup_subtitle =>
      'Peut être utilisé pour restaurer la bibliothèque actuelle';

  @override
  String get restore_backup => 'Restaurer une sauvegarde';

  @override
  String get encrypt_backups => 'Chiffrer les sauvegardes';

  @override
  String get encrypt_backups_info =>
      'Protéger les sauvegardes par mot de passe avec le chiffrement AES';

  @override
  String get no_secure_storage => 'Aucun stockage sécurisé trouvé';

  @override
  String get no_keyring_warning =>
      'Ce système ne dispose pas d\'un service de trousseau de clés (ex. gnome-keyring ou kwallet sur Linux), le mot de passe ne peut donc pas être stocké de façon sécurisée.\n\nLe stocker en clair dans la base de données locale de l\'application ? Toute personne ayant accès aux données de l\'application pourra le lire.';

  @override
  String get enter_backup_password => 'Entrer le mot de passe de la sauvegarde';

  @override
  String get incorrect_password_try_again =>
      'Mot de passe incorrect, réessayez.';

  @override
  String get set_backup_password => 'Définir le mot de passe de sauvegarde';

  @override
  String get confirm_password => 'Confirmer le mot de passe';

  @override
  String get passwords_do_not_match => 'Les mots de passe ne correspondent pas';

  @override
  String get password_required_to_restore =>
      'Un mot de passe est requis pour restaurer cette sauvegarde.';

  @override
  String get restore_backup_subtitle =>
      'Restaurer la bibliothèque à partir d\'un fichier de sauvegarde';

  @override
  String get automatic_backups => 'Sauvegardes automatiques';

  @override
  String get backup_frequency => 'Fréquence de sauvegarde';

  @override
  String get backup_location => 'Dossier de sauvegarde';

  @override
  String get backup_options => 'Options de sauvegarde';

  @override
  String get backup_options_dialog_title => 'Que voulez-vous sauvegarder ?';

  @override
  String get backup_options_subtitle =>
      'Quelle information inclure dans le fichier de sauvegarde';

  @override
  String get backup_and_restore_warning_info =>
      'Vous devez égalemement conserver des copies des sauvegardes à d\'atures endroits';

  @override
  String get library_entries => 'Entrées de la bibliothèque';

  @override
  String get chapters_and_episode => 'Chapitres et épisodes';

  @override
  String get every_6_hours => 'Toutes les 6 heures';

  @override
  String get every_12_hours => 'Toutes les 12 heures';

  @override
  String get daily => 'Tous les jours';

  @override
  String get every_2_days => 'Tous les 2 jours';

  @override
  String get weekly => 'Chaque semaine';

  @override
  String get restore_backup_warning_title =>
      'La restauration d\'une sauvegarde écrasera toutes les données existantes.\n\nContinuer la restauration ?';

  @override
  String get restore_sync_question_title => 'Synchroniser cette restauration ?';

  @override
  String get restore_sync_question_message =>
      'Cet appareil est connecté à un serveur de synchronisation. Envoyer ces données restaurées maintenant ? Sinon, la synchronisation sera désactivée pour éviter que les anciennes données du serveur n\'écrasent ce que vous venez de restaurer.';

  @override
  String get restore_sync_question_confirm => 'Oui, synchroniser';

  @override
  String get restore_sync_question_deny => 'Non, désactiver la synchro';

  @override
  String get sync_disabled_after_restore =>
      'La synchronisation est désactivée. Vous pouvez la réactiver dans les Paramètres.';

  @override
  String get restore_sync_disabled_question_title =>
      'La synchronisation est actuellement désactivée';

  @override
  String get restore_sync_disabled_question_message =>
      'La synchronisation est coupée. La réactiver et envoyer ces données restaurées sur votre serveur ?';

  @override
  String get restore_sync_question_reenable => 'Oui, réactiver et synchroniser';

  @override
  String get restore_sync_question_keep_disabled => 'Laisser désactivée';

  @override
  String get restore_sync_uploading =>
      'Synchronisation des données restaurées vers le serveur…';

  @override
  String get restore_sync_upload_success =>
      'Données restaurées synchronisées avec le serveur';

  @override
  String get services => 'Services';

  @override
  String get tracking_warning_info =>
      'Synchronisation à sens unique pour mettre à jour la progression du chapitre dans les services de suivi. Configurez le suivi des entrées individuelles à partir de leur boutton de suivi.';

  @override
  String get use_page_tap_zones => 'Utiliser les zones tactiles';

  @override
  String get manage_trackers => 'Gérer les suivis';

  @override
  String get restore => 'Restaurer';

  @override
  String get backups => 'Sauvegardes';

  @override
  String get by_scanlator => 'Par traducteur';

  @override
  String get by_name => 'Par nom';

  @override
  String get installed => 'Installé';

  @override
  String get auto_scroll => 'Défilement automatique';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Langues préférées, correction de la hauteur tonale, canaux audio';

  @override
  String get player => 'Lecteur';

  @override
  String get markEpisodeAsSeenSetting =>
      'À quel moment marquer l\'épisode comme vu';

  @override
  String get mark_duplicate_chapters_read =>
      'Marquer les numéros de chapitres en double comme lus';

  @override
  String get default_skip_intro_length =>
      'Longueur par défaut du passage de l\'intro';

  @override
  String get default_playback_speed_length =>
      'Longueur par défaut de la vitesse de lecture';

  @override
  String get updateProgressAfterReading =>
      'Synchroniser la progression après lecture';

  @override
  String get no_sources_installed => 'Aucune source installée !';

  @override
  String get show_extensions => 'Afficher les extensions';

  @override
  String get default_skip_forward_skip_length => 'Longueur de saut par défaut';

  @override
  String get aniskip_requires_info =>
      'AniSkip nécessite que l\'anime soit suivi sur MAL ou Anilist pour fonctionner.';

  @override
  String get enable_aniskip => 'Activer AniSkip';

  @override
  String get enable_auto_skip => 'Activer le saut automatique';

  @override
  String get aniskip_button_timeout => 'Délai du bouton';

  @override
  String get skip_opening => 'Passer l\'opening';

  @override
  String get skip_ending => 'Passer l\'ending';

  @override
  String get fullscreen => 'Plein écran';

  @override
  String get update_library => 'Mettre à jour la bibliothèque';

  @override
  String get next_chapter => 'Chapitre suivant';

  @override
  String get next_5_chapters => '5 chapitres suivants';

  @override
  String get next_10_chapters => '10 chapitres suivants';

  @override
  String get next_25_chapters => '25 chapitres suivants';

  @override
  String get all_chapters => 'Tous les chapitres';

  @override
  String get next_episode => 'Épisode suivant';

  @override
  String get next_5_episodes => '5 épisodes suivants';

  @override
  String get next_10_episodes => '10 épisodes suivants';

  @override
  String get next_25_episodes => '25 épisodes suivants';

  @override
  String get all_episodes => 'Tous les épisodes';

  @override
  String get cover_saved => 'Couverture enregistrée';

  @override
  String get set_as_cover => 'Définir comme couverture';

  @override
  String get use_this_as_cover_art =>
      'Utiliser ceci comme illustration de couverture ?';

  @override
  String get save => 'Enregistrer';

  @override
  String get picture_saved => 'Image enregistrée';

  @override
  String get cover_updated => 'Couverture mise à jour';

  @override
  String get include_subtitles => 'Inclure les sous-titres';

  @override
  String get blend_mode_default => 'Par défaut';

  @override
  String get blend_mode_multiply => 'Multiplier';

  @override
  String get blend_mode_screen => 'Écran';

  @override
  String get blend_mode_overlay => 'Incrustation';

  @override
  String get blend_mode_colorDodge => 'Densité Couleur';

  @override
  String get blend_mode_lighten => 'Éclaircir';

  @override
  String get blend_mode_colorBurn => 'Incandescence';

  @override
  String get blend_mode_darken => 'Assombrir';

  @override
  String get blend_mode_difference => 'Différence';

  @override
  String get blend_mode_saturation => 'Saturation';

  @override
  String get blend_mode_softLight => 'Lumière Douce';

  @override
  String get blend_mode_plus => 'Ajout';

  @override
  String get blend_mode_exclusion => 'Exclusion';

  @override
  String get custom_color_filter => 'Filtre de couleur personnalisé';

  @override
  String get color_filter_blend_mode => 'Mode de fusion du filtre de couleur';

  @override
  String get enable_all => 'Activer tout';

  @override
  String get disable_all => 'Désactiver tout';

  @override
  String get font => 'Police';

  @override
  String get color => 'Couleur';

  @override
  String get font_size => 'Taille de police';

  @override
  String get text => 'Texte';

  @override
  String get border => 'Bordure';

  @override
  String get background => 'Arrière-plan';

  @override
  String get no_subtite_warning_message =>
      'N\'a aucun effet car il n\'y a pas de pistes de sous-titres dans cette vidéo';

  @override
  String get grid_size => 'Taille de la grille';

  @override
  String n_per_row(Object n) {
    return '$n par ligne';
  }

  @override
  String get horizontal_continious => 'Horizontal continu';

  @override
  String get edit_code => 'Modifier le code';

  @override
  String get use_libass => 'Activer libass';

  @override
  String get use_libass_info =>
      'Utilisez le rendu des sous-titres basé sur libass pour le backend natif.';

  @override
  String get libass_not_disable_message =>
      'Désactivez `use libass` dans les paramètres du lecteur pour pouvoir personnaliser les sous-titres.';

  @override
  String get override_ass_subtitles =>
      'Forcer le style sur les sous-titres ASS';

  @override
  String get override_ass_subtitles_info =>
      'Appliquer le style personnalisé aux sous-titres ASS/SSA';

  @override
  String get torrent_stream => 'Flux Torrent';

  @override
  String get add_torrent => 'Ajouter un torrent';

  @override
  String get enter_torrent_hint_text =>
      'Entrez l\'URL du fichier magnet ou torrent';

  @override
  String get torrent_url => 'URL du torrent';

  @override
  String get or => 'OU';

  @override
  String get advanced => 'Avancé';

  @override
  String get advanced_info => 'Configuration mpv';

  @override
  String get use_native_http_client => 'Utiliser le client HTTP natif';

  @override
  String get use_native_http_client_info =>
      'Il supporte automatiquement les fonctionnalités de la plateforme telles que les VPN, et prend en charge plus de fonctionnalités HTTP telles que HTTP/3 et la gestion personnalisée des redirections.';

  @override
  String n_hour_ago(Object hour) {
    return 'Il y a $hour heure';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'Il y a $hours heures';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'Il y a $minute minute';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'Il y a $minutes minutes';
  }

  @override
  String n_day_ago(Object day) {
    return 'Il y a $day jour';
  }

  @override
  String get now => 'maintenant';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Dernière mise à jour de la bibliothèque : $lastUpdated';
  }

  @override
  String get data_and_storage => 'Données et stockage';

  @override
  String get download_location_info =>
      'Utilisé pour les téléchargements de chapitres';

  @override
  String get storage => 'Stockage';

  @override
  String get clear_chapter_and_episode_cache =>
      'Effacer le cache des chapitres et épisodes';

  @override
  String get cache_cleared => 'Cache effacé';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Effacer le cache des chapitres/épisodes au lancement de l\'application';

  @override
  String get app_settings => 'Paramètres de l\'application';

  @override
  String get sources_settings => 'Paramètres des sources';

  @override
  String get include_sensitive_settings =>
      'Inclure les paramètres sensibles (par ex., jetons de connexion des traceurs)';

  @override
  String get create => 'Créer';

  @override
  String get downloads_are_limited_to_wifi =>
      'Les téléchargements sont limités au Wi-Fi uniquement';

  @override
  String get recommendations => 'Recommandations';

  @override
  String get recommendations_similar => 'similaire';

  @override
  String get recommendations_weights => 'Poids des recommandations';

  @override
  String get recommendations_weights_genre => 'Similarité de genre';

  @override
  String get recommendations_weights_setting => 'Similarité de cadre';

  @override
  String get recommendations_weights_synopsis => 'Similarité d\'histoire';

  @override
  String get recommendations_weights_theme => 'Similarité de thème';

  @override
  String get manga_extensions_repo => 'Dépôt d\'extensions de mangas';

  @override
  String get anime_extensions_repo => 'Dépôt d\'extensions d\'anime';

  @override
  String get novel_extensions_repo => 'Dépôt d\'extensions de romans';

  @override
  String get custom_dns =>
      'DNS personnalisé (laisser vide pour utiliser le DNS système)';

  @override
  String get android_proxy_server =>
      'Serveur proxy Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Obtenir M-Extension-Server';

  @override
  String get undefined => 'Indéfini';

  @override
  String get empty_extensions_repo =>
      'Vous n\'avez aucune URL de dépôt ici. Cliquez sur le bouton plus pour en ajouter une !';

  @override
  String get add_extensions_repo => 'Ajouter une URL de dépôt';

  @override
  String get remove_extensions_repo => 'Supprimer l\'URL du dépôt';

  @override
  String get manage_manga_repo_urls => 'Gérer les URL du dépôt de mangas';

  @override
  String get manage_anime_repo_urls => 'Gérer les URL du dépôt d\'anime';

  @override
  String get manage_novel_repo_urls => 'Gérer les URL du dépôt de romans';

  @override
  String get url_cannot_be_empty => 'L\'URL ne peut pas être vide';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'L\'URL doit se terminer par .json / .pb';

  @override
  String get repo_url => 'URL du dépôt';

  @override
  String get invalid_url_format => 'Format d\'URL invalide';

  @override
  String get clear_all_sources => 'Effacer toutes les sources';

  @override
  String get clear_all_sources_msg =>
      'Cela effacera complètement toutes les sources de l\'application. Êtes-vous sûr de vouloir continuer ?';

  @override
  String get sources_cleared => 'Sources effacées !';

  @override
  String get repo_added => 'Dépôt de sources ajouté !';

  @override
  String get repo_already_exists => 'Le dépôt existe déjà !';

  @override
  String get add_repo => 'Ajouter un dépôt ?';

  @override
  String get add_repo_sources_to_add =>
      'Listes d\'extensions qui seront ajoutées :';

  @override
  String get add_repo_warning =>
      'Les extensions de ces dépôts s\'exécutent dans l\'application. N\'ajoutez que des dépôts de confiance.';

  @override
  String get genre_search_library => 'Rechercher un genre dans la bibliothèque';

  @override
  String get genre_search_source => 'Explorer dans la source';

  @override
  String get source_not_added => 'La source n\'est pas installée !';

  @override
  String get load_own_subtitles => 'Charger vos propres sous-titres...';

  @override
  String get search_subtitles => 'Rechercher des sous-titres en ligne...';

  @override
  String extension_notes(Object notes) {
    return 'Notes : $notes';
  }

  @override
  String get unsupported_repo =>
      'Impossible d’ajouter ce dépôt de sources. Vérifiez son adresse ou contactez la personne qui le maintient.';

  @override
  String get you_have_finished_reading => 'Vous avez terminé la lecture';

  @override
  String get hwdec => 'Décodeur matériel';

  @override
  String get enable_hardware_accel => 'Accélération matérielle';

  @override
  String get enable_hardware_accel_info =>
      'Activez/désactivez si vous rencontrez des bugs ou des plantages';

  @override
  String get track_library_navigate => 'Accéder à l\'entrée locale existante';

  @override
  String get track_library_add => 'Ajouter à la bibliothèque locale';

  @override
  String get track_library_add_confirm =>
      'Ajouter l\'élément suivi à la bibliothèque locale';

  @override
  String get track_library_not_logged =>
      'Connectez-vous au tracker correspondant pour utiliser cette fonctionnalité !';

  @override
  String get track_library_switch => 'Changer pour un autre tracker';

  @override
  String get go_back => 'Retour';

  @override
  String get merge_library_nav_mobile =>
      'Fusionner la navigation de la bibliothèque sur mobile';

  @override
  String get enable_discord_rpc => 'Activer Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Masquer Discord RPC en mode Incognito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Afficher le chapitre actuel dans Discord (nécessite un redémarrage)';

  @override
  String get rpc_show_title => 'Afficher le titre actuel dans Discord';

  @override
  String get rpc_show_cover_image =>
      'Afficher l\'image de couverture actuelle dans Discord';

  @override
  String get enable_mpv => 'Activer les shaders / scripts mpv';

  @override
  String get mpv_info => 'Supporte les scripts .js sous mpv/scripts/';

  @override
  String get mpv_redownload =>
      'Retélécharger les fichiers de configuration mpv';

  @override
  String get mpv_redownload_info =>
      'Remplace les anciens fichiers de configuration par les nouveaux !';

  @override
  String get mpv_download =>
      'Les fichiers de configuration MPV sont requis !\nTélécharger maintenant ?';

  @override
  String get custom_buttons => 'Boutons personnalisés';

  @override
  String get custom_buttons_info =>
      'Exécuter du code lua avec des boutons personnalisés';

  @override
  String get custom_buttons_edit => 'Modifier les boutons personnalisés';

  @override
  String get custom_buttons_add => 'Ajouter un bouton personnalisé';

  @override
  String get custom_buttons_added => 'Bouton personnalisé ajouté !';

  @override
  String get custom_buttons_delete => 'Supprimer le bouton personnalisé';

  @override
  String get custom_buttons_text => 'Texte du bouton';

  @override
  String get custom_buttons_text_req => 'Texte du bouton requis';

  @override
  String get custom_buttons_js_code => 'Code lua';

  @override
  String get custom_buttons_js_code_req => 'Code lua requis';

  @override
  String get custom_buttons_js_code_long => 'Code lua (sur appui long)';

  @override
  String get custom_buttons_startup => 'Code lua (au démarrage)';

  @override
  String get custom_buttons_add_warning =>
      'Ce bouton exécute le code Lua ci-dessous dans le lecteur vidéo, qui peut accéder à vos fichiers et lancer des programmes. Ne l\'ajoutez que si vous faites confiance à la source de ce lien.';

  @override
  String n_days(Object n) {
    return '$n jours';
  }

  @override
  String get decoder => 'Décodeur';

  @override
  String get decoder_info => 'Décodage matériel, format de pixel, debanding';

  @override
  String get enable_gpu_next => 'Activer gpu-next (Android uniquement)';

  @override
  String get enable_gpu_next_info => 'Un nouveau moteur de rendu vidéo';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Utiliser le format de pixel YUV420P';

  @override
  String get use_yuv420p_info =>
      'Peut corriger les écrans noirs sur certains codecs vidéo, peut également améliorer les performances au détriment de la qualité';

  @override
  String get audio_preferred_languages => 'Langues préférées';

  @override
  String get audio_preferred_languages_info =>
      'Langue(s) audio à sélectionner par défaut sur une vidéo avec plusieurs flux audio, codes de langue à 2/3 lettres (par exemple : fr, en, de). Plusieurs valeurs peuvent être délimitées par une virgule.';

  @override
  String get enable_audio_pitch_correction =>
      'Activer la correction de hauteur tonale audio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Empêche l\'audio de devenir aigu à des vitesses plus rapides et grave à des vitesses plus lentes';

  @override
  String get audio_channels => 'Canaux audio';

  @override
  String get volume_boost_cap => 'Limite d\'amplification du volume';

  @override
  String get internal_player => 'Lecteur interne';

  @override
  String get internal_player_info => 'Progression, contrôles, orientation';

  @override
  String get subtitle_delay_text => 'Délai des sous-titres';

  @override
  String get subtitle_delay => 'Délai (ms)';

  @override
  String get subtitle_speed => 'Vitesse';

  @override
  String get tracks => 'Pistes';

  @override
  String get playback_speed => 'Vitesse de lecture';

  @override
  String get shaders => 'Shaders';

  @override
  String get video_fit => 'Ajustement';

  @override
  String get calendar => 'Calendrier';

  @override
  String get calendar_no_data => 'Aucune donnée pour l\'instant.';

  @override
  String get calendar_info =>
      'Le calendrier ne peut prédire le prochain téléversement de chapitre que sur la base des téléversements précédents. Certaines données peuvent ne pas être précises à 100% !';

  @override
  String in_n_day(Object days) {
    return 'dans $days jour';
  }

  @override
  String in_n_days(Object days) {
    return 'dans $days jours';
  }

  @override
  String get clear_library => 'Vider la bibliothèque';

  @override
  String get clear_library_desc =>
      'Choisissez d\'effacer toutes les entrées manga, anime et/ou roman';

  @override
  String get clear_library_input =>
      'Tapez \'manga\', \'anime\' et/ou \'novel\' (séparés par une virgule) pour supprimer toutes les entrées associées';

  @override
  String get watch_order => 'Ordre de visionnage';

  @override
  String get watch_order_role_current => 'Actuel';

  @override
  String get watch_order_role_previous => 'Précédent';

  @override
  String get watch_order_role_next => 'Suivant';

  @override
  String get watch_order_source_release_order => 'Ordre de libération';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name par $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Collection officielle Trakt : $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt collection : $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Saisons pour $title';
  }

  @override
  String get watch_order_select_source => 'Origine de la commande';

  @override
  String watch_order_season(int number) {
    return 'Saison $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Épisode $number';
  }

  @override
  String get sequels => 'Suites';

  @override
  String get recommendations_similarity => 'Similarité :';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Notation $rating';
  }

  @override
  String get local_folder_structure => 'Structure d\'un dossier local';

  @override
  String get local_folder => 'Dossiers locaux';

  @override
  String get add_local_folder => 'Ajouter un dossier local';

  @override
  String get rescan_local_folder =>
      'Réanalyser tous les dossiers locaux maintenant';

  @override
  String get default_download_destination =>
      'Dossier de téléchargement par défaut';

  @override
  String get ask_download_destination =>
      'Demander le dossier de téléchargement';

  @override
  String get ask_download_destination_desc =>
      'Choisir un dossier local à chaque début de téléchargement.';

  @override
  String get select_download_destination =>
      'Choisir le dossier de téléchargement';

  @override
  String get clear_local_library => 'Vider la bibliothèque locale';

  @override
  String get clear_local_library_desc =>
      'Supprimer les dossiers locaux et les archives de la bibliothèque.';

  @override
  String get clear_local_library_msg =>
      'Cela supprimera les dossiers locaux et les archives de votre bibliothèque. Les fichiers sur le disque ne seront pas supprimés.';

  @override
  String get custom => 'Personnalisé';

  @override
  String get no_local_folder_available_for_downloads =>
      'Aucun dossier local disponible pour les téléchargements';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Échec de la création du CBZ : $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Erreur de lecture de l\'image de couverture : $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Erreur de lecture des métadonnées : $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Erreur lors de l\'enregistrement du chapitre/épisode dans la bibliothèque : $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Erreur de lecture de la couverture du chapitre : $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Erreur de lecture de la couverture de l\'archive : $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Erreur lors de la récupération de la bibliothèque locale : $error';
  }

  @override
  String get export_metadata => 'Exporter les métadonnées';

  @override
  String get exported => 'Exporté';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Échec de l\'exportation des métadonnées : $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count chapitre(s) n\'ont pas pu être numérotés automatiquement et peuvent être désordonnés ou manquants dans le lecteur.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Impossible de démarrer le serveur Webview de résolution Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Jeton $tracker expiré';
  }

  @override
  String get video_list_empty => 'La liste des vidéos est vide';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Impossible d\'ouvrir $url';
  }

  @override
  String get text_size => 'Taille du texte :';

  @override
  String get text_align => 'Alignement du texte';

  @override
  String get line_height => 'Hauteur de ligne';

  @override
  String get show_scroll_percentage => 'Afficher le pourcentage de défilement';

  @override
  String get remove_extra_paragraph_spacing =>
      'Supprimer l\'espacement supplémentaire des paragraphes';

  @override
  String select_label_color(Object label) {
    return 'Sélectionner la couleur $label';
  }

  @override
  String get default_user_agent => 'Agent utilisateur par défaut';

  @override
  String get forceLandscapeMode => 'Forcer le mode paysage';

  @override
  String get forceLandscapeModeSubtitle =>
      'Forcer le lecteur à utiliser l\'orientation paysage.';

  @override
  String get dns_over_https => 'DNS-sur-HTTPS (DoH)';

  @override
  String get dns_provider => 'Fournisseur DNS';

  @override
  String get tracked => 'Suivi';

  @override
  String get auth_unlock_msg =>
      'Authentifiez-vous pour déverrouiller NodeLane Comics';

  @override
  String get app_locked => 'NodeLane Comics est verrouillé';

  @override
  String get auth_to_continue => 'Authentifiez-vous pour continuer';

  @override
  String get authenticating => 'Authentification en cours...';

  @override
  String get lock => 'Verrouiller';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get security => 'Sécurité';

  @override
  String get auth_to_change_security_setting =>
      'Authentifiez-vous pour modifier les paramètres de sécurité';

  @override
  String get app_lock => 'Verrouillage de l\'application';

  @override
  String get require_biometric_or_device_credential =>
      'Exiger l\'authentification biométrique ou les identifiants de l\'appareil pour ouvrir l\'application';

  @override
  String get biometric_or_device_credential_not_available =>
      'L\'authentification biométrique n\'est pas disponible sur cet appareil';

  @override
  String get app_lock_description =>
      'Lorsque le verrouillage de l\'application est activé, vous serez invité à vous authentifier\nchaque fois que vous ouvrez l\'application ou que vous la restaurez à partir de l\'arrière-plan.';

  @override
  String get checking_device_authentication =>
      'Vérification de l\'authentification de l\'appareil…';

  @override
  String get device_authentication_incomplete =>
      'L\'authentification n\'a pas été effectuée. Votre paramètre n\'a pas changé.';

  @override
  String get keep_screen_on => 'Garder l\'écran allumé';

  @override
  String get webtoon_side_padding => 'Remplissage latéral Webtoon';

  @override
  String get show_page_gaps => 'Afficher les écarts entre les pages';

  @override
  String get invert_colors => 'Inverser les couleurs';

  @override
  String get grayscale => 'Niveaux de gris';

  @override
  String get brightness => 'Luminosité';

  @override
  String get contrast => 'Contraste';

  @override
  String get saturation => 'Saturation';

  @override
  String get navigation_layout => 'Disposition de navigation';

  @override
  String get nav_layout_default => 'Défaut';

  @override
  String get nav_layout_l_shaped => 'En forme de L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Bord';

  @override
  String get nav_layout_right_and_left => 'Droite et gauche';

  @override
  String get nav_layout_disabled => 'Désactivé';

  @override
  String get color_enhancements => 'Améliorations des couleurs';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Moyenne par titre';

  @override
  String get completion_rate => 'Taux de réussite';

  @override
  String get watching_time => 'Temps de visionnage';

  @override
  String get reading_time => 'Temps de lecture';

  @override
  String average_chapters_per_title(Object title) {
    return 'Chapitres moyens par $title';
  }

  @override
  String get read_percentage => 'Pourcentage lu';

  @override
  String get entries => 'Entrées';

  @override
  String get android_proxy_server_mihon => 'Serveur proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Téléchargez et configurez le serveur proxy requis pour utiliser les extensions Mihon.';

  @override
  String get mihon_proxy_server => 'Serveur proxy Mihon';

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
      'Aucune nouvelle version du serveur proxy disponible.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Impossible de vérifier les mises à jour du serveur proxy.';

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
  String get select_extension_server_jar =>
      'Sélectionner le JAR du serveur d\'extension';

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
      'IP du serveur (ex: 10.0.0.5 ou https://example.com)';

  @override
  String get not_configured => 'Not configured';

  @override
  String get zero_interpreter => 'Interpréteur Zero';

  @override
  String get zero_interpreter_description =>
      'Contrôler le serveur de l\'interpréteur Zero automatiquement ou manuellement.';

  @override
  String get start_server_on_launch => 'Démarrer le serveur au lancement';

  @override
  String get runtime_status => 'État du runtime';

  @override
  String get running => 'En cours d\'exécution';

  @override
  String get stopped => 'Arrêté';

  @override
  String get start => 'Démarrer';

  @override
  String get stop => 'Arrêter';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Synthèse vocale';

  @override
  String get tts_speed => 'Vitesse';

  @override
  String get tts_pitch => 'Tonalité';

  @override
  String get tts_language => 'Langue';

  @override
  String get tts_voice => 'Voix';

  @override
  String get tts_stop => 'Arrêter';

  @override
  String get tts_play => 'Lire';

  @override
  String get tts_pause => 'Pause';

  @override
  String get tts_previous => 'Paragraphe précédent';

  @override
  String get tts_next => 'Paragraphe suivant';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Paragraphe $current sur $total';
  }

  @override
  String get tts_settings => 'Paramètres TTS';

  @override
  String get tts_default => 'Par défaut';

  @override
  String get webtoon_disable_zoom_out => 'Désactiver le zoom arrière Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Double-tap pour zoomer Webtoon';

  @override
  String get navigate_to_pan => 'Naviguer vers le panoramique';

  @override
  String get navigate_to_pan_subtitle =>
      'Déplace d\'abord l\'image zoomée avant de tourner la page';

  @override
  String get split_wide_pages => 'Découper les pages doubles';

  @override
  String get dual_page_invert => 'Inverser les demi-pages découpées';

  @override
  String get dual_page_rotate_to_fit => 'Faire pivoter pour adapter';

  @override
  String get dual_page_rotate_to_fit_invert => 'Inverser le sens de rotation';

  @override
  String get double_page_single_first_page => 'Première page seule';

  @override
  String get double_page_single_first_page_subtitle =>
      'Afficher la première page isolée en mode double page';

  @override
  String get double_page_auto => 'Double page automatique';

  @override
  String get double_page_auto_subtitle =>
      'Passer automatiquement en mode double page en mode paysage';

  @override
  String get landscape_zoom => 'Zoom paysage automatique';

  @override
  String get zoom_start_position => 'Position de départ du zoom';

  @override
  String get zoom_start_left => 'Gauche';

  @override
  String get zoom_start_right => 'Droite';

  @override
  String get zoom_start_center => 'Centre';

  @override
  String get automatic_background => 'Arrière-plan automatique';

  @override
  String get tapping_inversion => 'Inversion du tap';

  @override
  String get tapping_inversion_none => 'Aucune';

  @override
  String get tapping_inversion_horizontal => 'Horizontale';

  @override
  String get tapping_inversion_vertical => 'Verticale';

  @override
  String get tapping_inversion_both => 'Les deux';

  @override
  String get flash_on_page_change => 'Flash au changement de page';

  @override
  String get flash_on_page_change_subtitle => 'Assistant anti-rétention AMOLED';

  @override
  String get flash_color => 'Couleur du flash';

  @override
  String get flash_color_black => 'Noir';

  @override
  String get flash_color_white => 'Blanc';

  @override
  String get flash_color_white_black => 'Blanc & Noir';

  @override
  String get flash_interval_label => 'Intervalle de flash';

  @override
  String flash_interval_value(String n) {
    return '$n pages';
  }

  @override
  String flash_interval(String n) {
    return 'Intervalle de flash : $n pages';
  }

  @override
  String get flash_duration_label => 'Durée de flash';

  @override
  String flash_duration_value(String n) {
    return '$n ms';
  }

  @override
  String flash_duration(String n) {
    return 'Durée de flash : $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Afficher les zones de navigation au démarrage';

  @override
  String get reader_hide_threshold => 'Seuil de masquage de l\'interface';

  @override
  String get reader_hide_threshold_highest => 'Le plus sensible (5 px)';

  @override
  String get reader_hide_threshold_high => 'Sensible (13 px)';

  @override
  String get reader_hide_threshold_low => 'Faible (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Le moins sensible (47 px)';

  @override
  String get error_no_pages_available => 'Erreur : aucune page disponible';

  @override
  String get app_ui_scale => 'Échelle de l\'interface';

  @override
  String get app_ui_scale_subtitle =>
      'Rendez l\'interface plus grande ou plus petite pour adapter votre écran et votre distance de visionnage.';

  @override
  String get allow_concurrent_downloads =>
      'Autoriser les téléchargements simultanés';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Télécharger à partir de différentes sources en même temps. Une seule source télécharge encore un chapitre à la fois pour qu\'elle ne soit pas surchargée. Désactivez pour télécharger un à la fois partout.';

  @override
  String get download_delay => 'Délai de téléchargement';

  @override
  String get download_delay_subtitle =>
      'Désactivé. Ajouter une attente avec un dégradé aléatoire entre les chapitres pour être plus doux sur les sources.';

  @override
  String get save_search => 'Enregistrer la recherche';

  @override
  String get saved_searches => 'Recherches enregistrées';

  @override
  String get enter_search_to_save_first =>
      'Entrez une recherche à enregistrer en premier';

  @override
  String get no_saved_searches =>
      'Aucune recherche enregistrée pour cette source pour le moment.\nEffectuez une recherche, puis choisissez \"Enregistrer la recherche\".';

  @override
  String get source => 'Source';

  @override
  String get something_went_wrong => 'Une erreur est survenue';

  @override
  String get startup_failed =>
      'NodeLane Comics n\'a pas pu terminer son démarrage';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources sans résultat',
      one: '1 source sans résultat',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Comment effectuer l\'importation ?';

  @override
  String get import_mode_message =>
      'Choisissez de fusionner cette sauvegarde avec votre bibliothèque actuelle ou de remplacer toute votre bibliothèque par celle-ci.';

  @override
  String get import_mode_keep_existing => 'Fusionner';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Ajoute les nouvelles séries et met à jour celles correspondantes. Rien n\'est supprimé de votre bibliothèque actuelle.';

  @override
  String get import_mode_replace => 'Remplacer';

  @override
  String get import_mode_replace_subtitle =>
      'Supprime toute votre bibliothèque actuelle et la remplace par cette sauvegarde.';

  @override
  String get replace_summary_title => 'Prêt à remplacer votre bibliothèque';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Cela supprimera l\'intégralité de votre bibliothèque actuelle ($currentCount séries) et la remplacera par $backupCount séries de cette sauvegarde. Cette action ne peut être annulée que par une restauration précédente.';
  }

  @override
  String get replace_summary_confirm => 'Remplacer';

  @override
  String replace_result_message(Object count) {
    return 'Bibliothèque remplacée par $count séries de cette sauvegarde.';
  }

  @override
  String get category_conflict_title => 'Catégories existantes trouvées';

  @override
  String get category_conflict_message =>
      'La sauvegarde contient des catégories qui existent déjà dans votre bibliothèque. Conserver pour fusionner les séries entrantes dans la catégorie existante, ou supprimer pour laisser ces séries sans catégorie.';

  @override
  String get category_conflict_keep =>
      'Conserver — fusionner dans la catégorie existante';

  @override
  String get category_conflict_delete =>
      'Supprimer — laisser les séries sans catégorie';

  @override
  String get source_conflict_title => 'Sources introuvables';

  @override
  String get source_conflict_message =>
      'Ces sources de sauvegarde ne correspondent à aucune extension installée. Conserver le nom original (importé sans source active), ou migrer vers une extension installée pour permettre les mises à jour.';

  @override
  String get source_conflict_keep =>
      'Conserver le nom original (aucune source active)';

  @override
  String get import_summary_title => 'Prêt à importer';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries nouvelles séries, $updatedSeries séries existantes seront mises à jour, et $newChapters nouveaux chapitres seront ajoutés. Rien dans votre bibliothèque actuelle ne sera supprimé.';
  }

  @override
  String get import_summary_confirm => 'Importer';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries nouvelles séries importées, $updatedSeries existantes mises à jour, $newChapters nouveaux chapitres ajoutés.';
  }

  @override
  String get roll_back => 'Restaurer l\'état précédent';

  @override
  String get roll_back_confirm_message =>
      'Cela restaure votre bibliothèque à l\'instantané de sécurité pris juste avant cette modification, annulant tout ce qui vient d\'être fait.';

  @override
  String get roll_back_done =>
      'Retour effectué à l\'instantané précédant la modification.';

  @override
  String get restoring_backup => 'Restauration de votre bibliothèque…';

  @override
  String get roll_back_last_change => 'Annuler la dernière modification';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Instantané du $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count modifications récentes disponibles pour restauration';
  }

  @override
  String get delete_source_title => 'Supprimer une source et ses mangas';

  @override
  String get delete_source_subtitle =>
      'Choisissez une source et supprimez tous ses mangas de votre bibliothèque, ainsi que leurs chapitres, téléchargements, historique et suivi.';

  @override
  String get delete_source_pick_title => 'Choisir une source à supprimer';

  @override
  String get delete_source_empty =>
      'Aucune source trouvée dans votre bibliothèque.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Supprimer $sourceName ?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Cela supprimera définitivement $mangaCount mangas, $chapterCount chapitres, $historyCount entrées d\'historique et $updateCount entrées de mise à jour. Les liens de suivi sont conservés. Cette action est irréversible sauf en cas de restauration.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Supprimer également l\'extension installée';

  @override
  String get delete_source_keep_history => 'Conserver l\'historique de lecture';

  @override
  String get delete_source_keep_downloads =>
      'Conserver les enregistrements de téléchargement';

  @override
  String get delete_source_button => 'Supprimer';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '$mangaCount mangas supprimés de $sourceName.';
  }

  @override
  String get merge_manga_title => 'Fusionner les mangas en double';

  @override
  String get merge_manga_subtitle =>
      'Recherche les mangas ayant des titres identiques sous la même source (par exemple après avoir fusionné des sources en double) et les regroupe en un seul, sans rien supprimer de ce que vous souhaitez conserver.';

  @override
  String get merge_manga_none_found =>
      'Aucun manga en double potentiel trouvé.';

  @override
  String get merge_manga_pick_title => 'Mangas en double possibles';

  @override
  String get merge_manga_choose_primary_title =>
      'Dans lequel les autres doivent-ils être fusionnés ?';

  @override
  String get merge_manga_choose_primary_message =>
      'Les chapitres, l\'historique et le suivi des autres entrées seront intégrés à celle que vous choisissez — rien n\'est supprimé.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapitres',
      one: '1 chapitre',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Fusionner';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '$count mangas en double fusionnés dans $mangaName.';
  }

  @override
  String get merge_preview_title => 'Confirmer la fusion';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters chapitres trouvés dans les autres entrées. $duplicateChapters sont des doublons et seront ignorés (en gardant la copie avec progression de lecture) ; $keptChapters seront ajoutés. $duplicateTracks lien(s) de suivi en double seront également ignorés.';
  }

  @override
  String get memory_overlay => 'Afficher l\'utilisation de la mémoire';

  @override
  String get memory_overlay_subtitle =>
      'Affichage en direct de ce que l\'application conserve en mémoire. Pour mesurer sur l\'appareil au lieu de deviner : observez pendant le défilement de la bibliothèque ou la lecture d\'un chapitre.';

  @override
  String get beta => 'Bêta';

  @override
  String get error_reports => 'Rapports d\'erreur';

  @override
  String get error_reports_subtitle =>
      'Erreurs interceptées par l\'application et moyen de les signaler';

  @override
  String get error_reports_empty =>
      'Aucun problème rencontré. Les erreurs interceptées par l\'application sont conservées ici afin que vous puissiez les signaler.';

  @override
  String get error_reports_likely_cause => 'Cause probable';

  @override
  String get error_reports_report => 'Signaler sur GitHub';

  @override
  String get error_reports_banner => 'NodeLane Comics a rencontré une erreur';

  @override
  String get error_reports_banner_action => 'Voir';

  @override
  String get error_reports_copy => 'Copier';

  @override
  String get error_reports_copied => 'Copié dans le presse-papiers';

  @override
  String get error_reports_clear => 'Effacer';

  @override
  String get error_reports_extension_failure =>
      'Ceci provient d\'une extension et non de NodeLane Comics. Les extensions sont développées et maintenues par les gestionnaires du dépôt depuis lequel vous avez installé cette source, la correction doit donc y être apportée. Le nom de la source et ce que vous ouvriez sont des détails utiles à leur fournir.';

  @override
  String get error_reports_already_reported => 'Déjà signalé';

  @override
  String get error_reports_expected_failure =>
      'Ceci est généralement dû à la source ou au réseau plutôt qu\'à l\'application : un lien expiré, un serveur indisponible ou une coupure de connexion. À ne signaler que si le problème persiste sur une source qui fonctionne par ailleurs.';

  @override
  String get share_unavailable_copied =>
      'Le partage n\'est pas disponible sur cette plateforme, le lien a donc été copié dans le presse-papiers.';

  @override
  String get onboarding_title => 'Bienvenue sur NodeLane Comics';

  @override
  String get onboarding_libraries_body =>
      'Choisissez ce que vous lisez et regardez. Les éléments que vous laissez de côté n\'apparaîtront pas dans la barre de navigation, vous pourrez modifier cela plus tard dans Apparence.';

  @override
  String get onboarding_nav_title => 'Vos bibliothèques';

  @override
  String get onboarding_nav_body =>
      'Gardez un onglet pour chacune d\'elles, ou regroupez-les sous un seul onglet Bibliothèque dans lequel vous pourrez basculer.';

  @override
  String get onboarding_nav_split => 'Un onglet par catégorie';

  @override
  String get onboarding_nav_merged => 'Un seul onglet Bibliothèque';

  @override
  String get onboarding_nav_inside =>
      'Appuyer sur Bibliothèque échange la barre pour ceux-ci';

  @override
  String get onboarding_next => 'Suivant';

  @override
  String get onboarding_restore => 'Restaurer une sauvegarde';

  @override
  String get onboarding_or_local =>
      'Ou utilisez les fichiers que vous avez déjà';

  @override
  String get onboarding_local_folder => 'Ajouter un dossier';

  @override
  String onboarding_local_existing(Object count) {
    return '$count dossiers déjà configurés';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime et romans fonctionnent tous. Chaque titre est placé dans la bonne bibliothèque selon son contenu.';

  @override
  String get onboarding_local_scanning => 'Analyse du dossier en cours';

  @override
  String onboarding_local_found(Object count) {
    return '$count titres trouvés';
  }

  @override
  String get onboarding_local_remove => 'Supprimer ce dossier';

  @override
  String get onboarding_local_in_downloads =>
      'C\'est le dossier des téléchargements de l\'application. L\'ajouter crée une seconde copie locale d\'une bibliothèque déjà gérée par l\'application.';

  @override
  String get onboarding_local_empty =>
      'Rien trouvé. Choisissez le dossier qui contient vos dossiers de mangas, pas un manga individuel.';

  @override
  String get onboarding_repo_failed =>
      'Impossible de lire ce dépôt. Vérifiez l\'adresse et votre connexion.';

  @override
  String get onboarding_repo_title => 'Ajouter une source';

  @override
  String get onboarding_body =>
      'NodeLane Comics ne contient aucune source intégrée. Ajoutez un dépôt pour rendre ses extensions disponibles à l\'installation et à l\'exploration.';

  @override
  String get onboarding_add => 'Ajouter un dépôt';

  @override
  String get onboarding_skip => 'Ignorer pour l\'instant';

  @override
  String get onboarding_continue => 'Continuer';

  @override
  String get onboarding_later =>
      'Vous pourrez en ajouter plus tard dans Paramètres > Explorer.';

  @override
  String get onboarding_replay => 'Afficher l\'écran de bienvenue';

  @override
  String get onboarding_replay_subtitle =>
      'Ouvre à nouveau l\'écran du premier lancement, celui sur lequel démarre une nouvelle installation.';

  @override
  String get missing_source_check_title => 'Vérifier les sources manquantes';

  @override
  String get missing_source_check_subtitle =>
      'Trouver les entrées dont l\'extension n\'est pas installée — restaurer une sauvegarde peut laisser des entrées pointant vers une source jamais installée sur cet appareil.';

  @override
  String get missing_source_check_none_found =>
      'La source de chaque entrée de la bibliothèque est installée.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources manquantes',
      one: '1 source manquante',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Aucune source $itemType n\'est installée.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Ajoutez un dépôt dans Explorer, puis installez une extension correspondante.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
    );
    return 'Vous avez $_temp0 pour ceci, mais seules les sources épinglées sont recherchées.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Épinglez-en une, ou désactivez « Inclure uniquement les sources épinglées » dans les paramètres d\'exploration.';

  @override
  String get global_search_all_nsfw =>
      'Toutes les sources dont vous disposez pour ceci sont marquées NSFW et sont masquées.';

  @override
  String get global_search_all_nsfw_hint =>
      'Activez les sources NSFW dans les paramètres d\'exploration pour les rechercher.';

  @override
  String get missing_source_check_result_message =>
      'Ces entrées de bibliothèque pointent vers une source non installée sur cet appareil. Touchez-en une pour la migrer vers une source installée, installez l\'extension correspondante ou utilisez « Supprimer une source et ses mangas » pour les retirer.';

  @override
  String get related_titles => 'Titres associés';

  @override
  String get related_none =>
      'Aucun titre associé n\'a été trouvé pour cette œuvre.';

  @override
  String get relation_adaptation => 'Adaptation';

  @override
  String get relation_sequel => 'Suite';

  @override
  String get relation_prequel => 'Préquelle';

  @override
  String get relation_parent => 'Histoire principale';

  @override
  String get relation_side_story => 'Histoire parallèle';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Version alternative';

  @override
  String get auto_library_update =>
      'Mises à jour automatiques de la bibliothèque';

  @override
  String get auto_library_update_subtitle =>
      'Vérifier la présence de nouveaux chapitres pour chaque élément de votre bibliothèque au démarrage de l\'application.';

  @override
  String get auto_library_update_never => 'Jamais';

  @override
  String get auto_library_update_12_hours => 'Toutes les 12 heures';

  @override
  String get auto_library_update_daily => 'Quotidiennement';

  @override
  String get auto_library_update_2_days => 'Tous les 2 jours';

  @override
  String get auto_library_update_weekly => 'Hebdomadairement';

  @override
  String get auto_library_update_wifi_only => 'Uniquement en Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Ignorer la mise à jour planifiée lors de l\'utilisation des données mobiles.';

  @override
  String get padding => 'Espacement';

  @override
  String get page_mode => 'Mode de page';

  @override
  String get single_page => 'Page simple';

  @override
  String get double_page => 'Double page';

  @override
  String get speed => 'Vitesse';

  @override
  String get theme_dark => 'Sombre';

  @override
  String get theme_light => 'Clair';

  @override
  String get theme_black => 'Noir';

  @override
  String get theme_sepia => 'Sépia';

  @override
  String get decrease => 'Diminuer';

  @override
  String get increase => 'Augmenter';

  @override
  String get chapter_swipe_actions => 'Actions de glissement de chapitre';

  @override
  String get chapter_swipe_start => 'Glisser vers la droite';

  @override
  String get chapter_swipe_end => 'Glisser vers la gauche';

  @override
  String get chapter_swipe_toggle_bookmark => 'Basculer le signet';

  @override
  String get chapter_swipe_toggle_read => 'Marquer lu/non lu';

  @override
  String get chapter_swipe_download => 'Télécharger';

  @override
  String get chapter_swipe_disabled => 'Désactivé';

  @override
  String get update_errors => 'Erreurs de mise à jour';

  @override
  String get no_update_errors => 'Aucune erreur de mise à jour';

  @override
  String get clear_all => 'Tout effacer';

  @override
  String get dismiss => 'Ignorer';

  @override
  String get previous_episode => 'Épisode précédent';

  @override
  String get clear_logs => 'Effacer les journaux';

  @override
  String get bold => 'Gras';

  @override
  String get italic => 'Italique';

  @override
  String get color_yellow => 'Jaune';

  @override
  String get color_cyan => 'Cyan';

  @override
  String get color_green => 'Vert';

  @override
  String get color_orange => 'Orange';

  @override
  String get continue_watching => 'Continuer à regarder';

  @override
  String get search_your_anime => 'Rechercher dans vos animes';

  @override
  String get category => 'Catégorie';

  @override
  String get hidden_categories => 'Catégories masquées';

  @override
  String get new_category => 'Nouvelle catégorie';

  @override
  String get local => 'Local';

  @override
  String get tv_home_rows => 'Rangées';

  @override
  String get genre_rows => 'Rangées par genre';

  @override
  String get share_backup_file =>
      'Partager le fichier de sauvegarde NodeLane Comics';

  @override
  String get close => 'Fermer';

  @override
  String get migrate_source => 'Migrer la source';

  @override
  String get cloudflare_bypass_proxy => 'Proxy de contournement Cloudflare';

  @override
  String get custom_doh_url => 'URL DoH personnalisée';

  @override
  String get custom_doh_url_helper =>
      'Doit être un point d\'accès DoH (JSON) en https';

  @override
  String get anime_only_tv_layout => 'Disposition TV anime uniquement';

  @override
  String get anime_only_beta => 'Anime uniquement (bêta)';

  @override
  String get tv_home_beta => 'Accueil TV (bêta)';

  @override
  String get tv_player_beta => 'Lecteur TV (bêta)';

  @override
  String get network_settings => 'Réseau';

  @override
  String get reader_page_layout => 'Mise en page';

  @override
  String get reader_continuous_options => 'Lecture continue';

  @override
  String get reader_default_mode_hint =>
      'Le mode de lecture par défaut s\'applique aux titres sans mode individuel défini lors de la lecture.';

  @override
  String get extension_service => 'Service de vulgarisation';

  @override
  String get extension_service_description =>
      'Gérer le runtime de l\'extension et l\'adresse proxy.';

  @override
  String get proxy_address => 'Adresse proxy';

  @override
  String get checking_runtime_status => 'Vérification de l\'état…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + retard aléatoire';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chapitres $count',
      one: '1 chapitre',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Ajoutez des téléchargements à partir de la liste des chapitres d’un titre.';

  @override
  String get download_queue_order_hint =>
      'Faites glisser les poignées pour réorganiser';

  @override
  String get download_queue_empty => 'Aucun téléchargement en file d\'attente';

  @override
  String get download_queue_actions => 'Actions de téléchargement';

  @override
  String get download_queue_cancel_chapter =>
      'Annuler le téléchargement de ce chapitre';

  @override
  String get download_queue_cancel_series =>
      'Annuler tous les téléchargements pour ce titre';

  @override
  String get download_queue_start => 'Démarrer les téléchargements';

  @override
  String get download_queue_retry => 'Réessayer les téléchargements';

  @override
  String get download_queue_active => 'Téléchargement';

  @override
  String get download_queue_waiting => 'En attente de téléchargement';

  @override
  String get download_queue_failed => 'Échec du téléchargement';

  @override
  String get cf_proxy_helper =>
      'Point de terminaison FlareSolverr/Byparr. Laissez vide pour désactiver.';

  @override
  String get mobile_navigation_description =>
      'Faites glisser pour réorganiser. Les mangas, anime et romans partagent l’onglet Bibliothèque. Le premier élément visible s\'ouvre au lancement. Parcourir et Plus restent visibles ; des onglets supplémentaires apparaissent sous Plus.';

  @override
  String get text_align_justify => 'Justifier';

  @override
  String get novel_session_modes_hint =>
      'Définir le mode de lecture et les pages simples ou doubles lors de la lecture d\'un titre.';

  @override
  String get tts_languages_failed =>
      'Impossible de charger les langues à partir du moteur vocal.';

  @override
  String get tts_languages_empty =>
      'Le moteur vocal n\'a renvoyé aucune langue. Votre sélection enregistrée est conservée.';

  @override
  String get tts_language_unavailable =>
      'Cette langue enregistrée ne figure pas dans la liste actuelle de l’appareil.';

  @override
  String get tts_apply_failed =>
      'Impossible d\'appliquer ce paramètre au moteur vocal. Vous pouvez réessayer.';

  @override
  String get player_controls => 'Contrôles';

  @override
  String get audio_channel_auto => 'Automatique';

  @override
  String get audio_channel_auto_safe => 'Automatique (sûr)';

  @override
  String get audio_channel_mono => 'Mono';

  @override
  String get audio_channel_stereo => 'Stéréo';

  @override
  String get audio_channel_reverse_stereo => 'Stéréo inversée';

  @override
  String get mpv_bundled_config_hint =>
      'Restaurez la configuration, les scripts et les shaders inclus avec l\'application. Les fichiers portant les mêmes noms seront écrasés.';

  @override
  String get mpv_restore_bundled => 'Restaurer la configuration groupée';

  @override
  String get mpv_restore_confirm =>
      'Restaurer la configuration MPV fournie ? La configuration existante, les scripts et les shaders portant les mêmes noms seront écrasés. Les autres fichiers seront conservés.';

  @override
  String get player_operation_incomplete =>
      'L\'opération n\'a pas pu être complétée. Vérifiez l\'accès au fichier et réessayez.';

  @override
  String get custom_buttons_empty_hint =>
      'Ajout d\'un bouton joueur avec un label et une action d\'appui.';

  @override
  String get custom_button_primary => 'Bouton par défaut';

  @override
  String get show_password => 'Afficher le mot de passe';

  @override
  String get hide_password => 'Masquer le mot de passe';

  @override
  String get tracking_accounts_empty =>
      'Connectez un service dans les paramètres de Tracking pour gérer ses entrées.';

  @override
  String get tracking_entries_empty =>
      'Aucune entrée suivie pour ce type de média. Ajoutez un suivi à partir de la page de détail d’un titre.';

  @override
  String get change_tracking_match => 'Changer le titre correspondant';

  @override
  String get remove_tracking => 'Supprimer le suivi';

  @override
  String remove_tracking_confirm(String title) {
    return 'Supprimer le lien de suivi pour « $title » ? L\'inscription dans le service de suivi sera conservée.';
  }

  @override
  String get tracking_refresh_required =>
      'L\'état de suivi n\'a pas pu être confirmé. Actualisez avant d’effectuer une autre modification.';

  @override
  String get tracking_entry_unlinked =>
      'Cet enregistrement n\'est pas lié à un titre local, il ne peut donc pas être édité ici.';

  @override
  String get backup_selection_shared =>
      'Les modifications de ces sélections sont enregistrées immédiatement et s\'appliquent également aux sauvegardes automatiques.';

  @override
  String get library_snapshot_history =>
      'Restaurer un instantané de bibliothèque';

  @override
  String get library_snapshot_empty =>
      'Aucun instantané de sécurité disponible.';

  @override
  String get library_snapshot_restore_message =>
      'Les données actuelles seront remplacées par cet instantané. Les modifications apportées depuis seront perdues. Les téléchargements supprimés ne peuvent pas être restaurés. Les instantanés de sécurité disponibles seront effacés après le succès.';

  @override
  String get library_maintenance_working => 'Mise à jour de la bibliothèque…';

  @override
  String get library_safety_snapshot_note =>
      'Un instantané de sécurité sera enregistré avant cette opération. Il n\'inclut pas les fichiers téléchargés.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Entrées de bibliothèque : $mangaCount. Chapitres : $chapterCount. Entrées d\'historique : $historyCount. Mises à jour : $updateCount.\n\nChoisissez ce que vous souhaitez conserver ci-dessous.';
  }

  @override
  String get library_delete_pick_message =>
      'Choisissez une source pour examiner son contenu et ses options de suppression.';

  @override
  String get mobile_categories_hint =>
      'Faites glisser pour réorganiser. Ouvrez une catégorie pour la renommer ou modifier sa visibilité et ses mises à jour.';

  @override
  String get mobile_category_visible => 'Afficher dans la bibliothèque';

  @override
  String get mobile_category_hidden => 'Masqué de la bibliothèque';

  @override
  String get mobile_category_updates =>
      'Inclure dans les mises à jour de la bibliothèque';

  @override
  String get statistics_watched => 'Regardé';

  @override
  String get calendar_month => 'Mois';

  @override
  String get calendar_two_weeks => '2 semaines';

  @override
  String get calendar_week => 'Semaine';

  @override
  String get calendar_show_all_dates => 'Afficher toutes les dates';

  @override
  String get update_check_no_result =>
      'Aucune mise à jour installable trouvée. Vous pourrez réessayer plus tard.';

  @override
  String get release_notes => 'Notes de version';

  @override
  String get no_release_notes => 'Aucune note de version n\'est fournie.';

  @override
  String get downloading_update => 'Téléchargement de la mise à jour…';

  @override
  String get preparing_installation => 'Préparation de l\'installation…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Choisissez ce que vous voulez lire. Vous pourrez modifier cela plus tard.';

  @override
  String get onboarding_content_title => 'Commencer la lecture';

  @override
  String get onboarding_mobile_sources_body =>
      'Choisissez une manière de démarrer ou ajoutez du contenu plus tard.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Étape $step de $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'Résultats pour « $query »';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sources $count',
      one: '1 source',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Rechercher le titre de destination.';

  @override
  String get migration_original_item => 'Article actuel';

  @override
  String get migration_target_item => 'Elément sélectionné';

  @override
  String get migration_partial_failure =>
      'L\'opération n\'est pas terminée. Certaines modifications peuvent avoir été enregistrées. Vérifiez cet élément dans votre bibliothèque avant de réessayer.';

  @override
  String get migration_no_categories =>
      'Aucune catégorie. Vous pouvez ajouter cet élément sans catégorie.';

  @override
  String get mass_migration_select_source => 'Choisir la source actuelle';

  @override
  String get mass_migration_select_all => 'Sélectionner tout';

  @override
  String get mass_migration_deselect_all => 'Tout désélectionner';

  @override
  String get mass_migration_needs_review =>
      'Examiner les migrations incomplètes';

  @override
  String get bookshelf_actions => 'Actions de bibliothèque';

  @override
  String get bookshelf_ignore_filters =>
      'Ignorer les filtres lors de la recherche';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Rechercher toutes les œuvres de cette catégorie, y compris celles masquées par les filtres.';

  @override
  String get bookshelf_stop_update =>
      'Arrêter la mise à jour de la bibliothèque';

  @override
  String bookshelf_selected_count(int count) {
    return '$count œuvres sélectionnées';
  }

  @override
  String get bookshelf_remove_library => 'Supprimer de l\'étagère';

  @override
  String get bookshelf_remove_library_hint =>
      'Supprime les favoris. Les importations locales perdent également leur bibliothèque et leurs enregistrements de lecture.';

  @override
  String get bookshelf_remove_downloads => 'Supprimer les fichiers téléchargés';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Supprime les fichiers téléchargés tout en conservant les informations de travail.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Supprime également les fichiers importés locaux sélectionnés et supprime leurs enregistrements de bibliothèque. Ces fichiers ne peuvent pas être récupérés ici.';

  @override
  String get bookshelf_remove_incomplete =>
      'L\'opération n\'est pas terminée. Certaines œuvres ou fichiers peuvent avoir été traités. Fermez cette boîte de dialogue et vérifiez votre bibliothèque et vos téléchargements avant de continuer.';

  @override
  String get bookshelf_processing => 'Traitement…';

  @override
  String get bookshelf_mark_read => 'Marquer lu';

  @override
  String get bookshelf_mark_unread => 'Marquer comme non lu';

  @override
  String get bookshelf_select_all => 'Sélectionner tout';

  @override
  String get bookshelf_invert_selection => 'Inverser la sélection';

  @override
  String get bookshelf_settings => 'Paramètres de la bibliothèque';

  @override
  String get bookshelf_settings_live =>
      'Les modifications de filtrage, de tri et d’affichage prennent effet immédiatement.';

  @override
  String get bookshelf_filter_any => 'N\'importe quel';

  @override
  String get bookshelf_filter_include => 'Inclure';

  @override
  String get bookshelf_filter_exclude => 'Exclure';

  @override
  String get bookshelf_all_sources => 'Toutes sources';

  @override
  String bookshelf_sources_selected(int count) {
    return 'Sources $count sélectionnées';
  }

  @override
  String get bookshelf_sort_ascending => 'Ascendant';

  @override
  String get bookshelf_sort_descending => 'Descendant';

  @override
  String get bookshelf_layout => 'Disposition en bibliothèque';

  @override
  String get bookshelf_sources_hint =>
      'Sélectionnez Aucun pour afficher toutes les sources. Les modifications s\'appliquent lorsque vous appuyez sur Filtrer.';

  @override
  String get bookshelf_choose_files => 'Choisir des fichiers';

  @override
  String get bookshelf_import_wait =>
      'Choisissez un fichier dans le sélecteur et attendez la fin de l\'importation.';

  @override
  String get bookshelf_import_incomplete =>
      'L\'importation n\'a pas été terminée. Certains fichiers se trouvent peut-être déjà dans votre bibliothèque. Fermez cette boîte de dialogue et vérifiez avant d\'importer à nouveau.';

  @override
  String get bookshelf_categories_replace =>
      'La sauvegarde attribue ces catégories à chaque œuvre sélectionnée, en remplacement de leurs catégories précédentes.';

  @override
  String get bookshelf_categories_hint =>
      'Choisissez une ou plusieurs catégories, ou laissez la sélection vide pour n\'en attribuer aucune.';

  @override
  String get bookshelf_categories_hidden =>
      'Les catégories cachées existantes sont conservées pour ce travail.';

  @override
  String get bookshelf_categories_incomplete =>
      'Les catégories n\'ont pas pu être enregistrées complètement. Fermez cette boîte de dialogue et vérifiez la bibliothèque avant de réessayer.';

  @override
  String get bookshelf_categories_none_visible =>
      'Aucune catégorie n\'est disponible ici. Ouvrez la gestion des catégories pour les examiner.';

  @override
  String get bookshelf_manage_categories => 'Gérer les catégories';

  @override
  String get manga_actions => 'Actions comiques';

  @override
  String get manga_download_scope => 'Télécharger les chapitres';

  @override
  String get manga_download_scope_hint =>
      'Choisissez des chapitres dans les filtres actuels. Les chapitres téléchargés sont ignorés.';

  @override
  String get manga_download_scope_empty =>
      'Aucun chapitre ne correspond aux filtres actuels. Fermez ce menu et ajustez les filtres de chapitre.';

  @override
  String get manga_action_incomplete =>
      'L\'action n\'est pas terminée. Vérifiez l\'état actuel avant de réessayer.';

  @override
  String get chapter_settings => 'Paramètres de chapitre';

  @override
  String get chapter_settings_live =>
      'Les modifications de filtrage et de tri s’appliquent immédiatement.';

  @override
  String get chapter_scanlators_all => 'Afficher tous les groupes de scanners';

  @override
  String get chapter_scanlators_hint =>
      'Sélectionnez des groupes pour masquer leurs chapitres. Les modifications s\'appliquent lorsque vous appuyez sur Filtrer.';

  @override
  String chapter_scanlators_hidden(int count) {
    return 'Groupes de scanlateurs $count masqués';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count chapitres sélectionnés';
  }

  @override
  String get chapter_add_bookmark => 'Marque-page';

  @override
  String get chapter_remove_bookmark => 'Supprimer le signet';

  @override
  String get chapter_read_following => 'Lire ci-dessous';

  @override
  String get chapter_delete_records =>
      'Supprimer les enregistrements de chapitre';

  @override
  String get chapter_delete_local_hint =>
      'Supprime les enregistrements de chapitre sélectionnés et la progression de la lecture. Les archives locales originales sont conservées ; les copies téléchargées sont nettoyées.';

  @override
  String get chapter_delete_last_hint =>
      'Ce sont tous les chapitres de cette bande dessinée. Les supprimer supprime également la bande dessinée de votre bibliothèque.';

  @override
  String get chapter_action_incomplete =>
      'L\'action n\'est pas terminée. Certaines modifications peuvent déjà être enregistrées. Fermez et vérifiez les chapitres et les téléchargements avant de continuer.';

  @override
  String get reader_display_scope =>
      'Le mode de lecture et la mise en page manuelle s\'appliquent à cette bande dessinée. Choisissez un changement pour revenir à la lecture.';

  @override
  String get reader_display_single_only =>
      'La lecture continue horizontale utilise des pages uniques.';

  @override
  String get reader_display_manual_pages =>
      'La modification de la mise en page désactive la double page automatique pour toutes les bandes dessinées.';

  @override
  String get reader_display_crop_scope =>
      'S\'applique à toutes les bandes dessinées.';

  @override
  String get reader_chapter_locate => 'Localiser le chapitre actuel';

  @override
  String get reader_chapter_search =>
      'Rechercher des chapitres ou des scanlateurs';

  @override
  String get reader_chapter_scope =>
      'Utilise les filtres de chapitre et l\'ordre de tri à partir des détails de la bande dessinée. Les signets sont enregistrés immédiatement.';

  @override
  String get reader_chapter_current_hidden =>
      'Le chapitre que vous lisez est en dehors des filtres actuels.';

  @override
  String get reader_chapter_current => 'Lire maintenant';

  @override
  String get reader_chapter_read => 'Lire';

  @override
  String get reader_chapter_bookmark_failed =>
      'L\'enregistrement du signet n\'a pas pu être confirmé. Fermez la liste et vérifiez son état actuel.';

  @override
  String get reader_image_actions => 'Actions sur les images';

  @override
  String get reader_image_original =>
      'Utilise la page originale complète, sans traduction, recadrage ou filtres de couleur du lecteur.';

  @override
  String get reader_image_save_ios =>
      'Enregistrez dans le dossier Images dans l\'emplacement de stockage actuel de l\'application.';

  @override
  String get reader_image_save_android =>
      'Enregistrez dans le dossier Images/nodelane-comics de l’appareil.';

  @override
  String get reader_image_share => 'Ouvrez la feuille de partage système.';

  @override
  String get reader_image_cover =>
      'Changez la couverture de cette bande dessinée après confirmation.';

  @override
  String get reader_image_cover_limit =>
      'Les images de couverture doivent être inférieures à 5 Mo. La sauvegarde et le partage restent disponibles.';

  @override
  String get reader_image_action_failed =>
      'L\'action n\'a pas pu être confirmée. Fermez ce menu et vérifiez le résultat avant de réessayer.';

  @override
  String get reader_settings_book_scope =>
      'Ces paramètres s\'appliquent uniquement à cette bande dessinée.';

  @override
  String get reader_settings_global_scope =>
      'Ces paramètres s\'appliquent à toutes les bandes dessinées et sont enregistrés immédiatement.';

  @override
  String get reader_filters => 'Filtres d\'images';

  @override
  String get reader_filter_scope =>
      'S\'applique à toutes les bandes dessinées. Modifie l\'affichage de la lecture sans modifier les images originales.';

  @override
  String get reader_auto_scroll_pause =>
      'Le défilement s\'arrête pendant que les paramètres sont ouverts.';

  @override
  String get manga_synopsis => 'Résumé';

  @override
  String manga_author(String author) {
    return 'Auteur : $author';
  }

  @override
  String get manga_continue_reading => 'Continuer la lecture';

  @override
  String get reader_settings_title => 'Paramètres du lecteur';

  @override
  String get reader_picker_book_scope => 'Uniquement pour cette bande dessinée';

  @override
  String get reader_picker_global_scope =>
      'S\'applique à toutes les bandes dessinées';

  @override
  String get reader_picker_apply_hint =>
      'Appuyez pour enregistrer et revenir au niveau précédent.';

  @override
  String get reader_scale_fit_screen_hint => 'Ajuster toute la page à l\'écran';

  @override
  String get reader_scale_stretch_hint => 'Remplir la zone de lecture';

  @override
  String get reader_scale_fit_width_hint => 'Ajuster la page à la largeur';

  @override
  String get reader_scale_fit_height_hint => 'Ajuster la page à la hauteur';

  @override
  String get source_filter_active => 'Appliqué';

  @override
  String get source_filter_apply => 'Appliquer des filtres';

  @override
  String get source_filter_scope =>
      'Les filtres s\'appliquent uniquement à ce site Web.';

  @override
  String get source_filter_apply_hint =>
      'Appliquez des filtres pour utiliser vos sélections.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Genres',
      'author': 'Auteur',
      'artist': 'Artiste',
      'title': 'Titre',
      'year': 'Année',
      'tags': 'Balises',
      'format': 'Formater',
      'publisher': 'Éditeur',
      'relevance': 'Pertinence',
      'rating': 'Notation',
      'views': 'Vues',
      'random': 'Aléatoire',
      'all': 'Tous',
      'none': 'Aucun',
      'action': 'Action',
      'adventure': 'Aventure',
      'comedy': 'Comédie',
      'drama': 'Drame',
      'fantasy': 'Fantaisie',
      'romance': 'Romance',
      'science_fiction': 'Science-fiction',
      'slice_of_life': 'Tranche de vie',
      'mystery': 'Mystère',
      'horror': 'Horreur',
      'psychological': 'Psychologique',
      'historical': 'Historique',
      'sports': 'Sport',
      'supernatural': 'Surnaturel',
      'school_life': 'Vie scolaire',
      'tragedy': 'Tragédie',
      'shounen': 'Shounen',
      'shoujo': 'Shojo',
      'seinen': 'Seinen',
      'josei': 'Joséi',
      'isekai': 'Isekaï',
      'martial_arts': 'Arts martiaux',
      'mecha': 'Mécha',
      'music': 'Musique',
      'doujinshi': 'Doujinshi',
      'trending': 'Tendances',
      'new': 'Nouveau',
      'adult_content': 'Contenu adulte',
      'only': 'Seulement',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'Plus d\'options d\'affichage';

  @override
  String get bookshelf_more_display_hint => 'Badges, sources et catégories';

  @override
  String get bookshelf_download_count => 'Nombre de téléchargements';

  @override
  String get bookshelf_source_global_hint =>
      'La visibilité de la source utilise la préférence d\'affichage partagée.';

  @override
  String get bookshelf_select_entries => 'Sélectionner les œuvres';

  @override
  String get bookshelf_search_options => 'Options de recherche';

  @override
  String get bookshelf_empty_hint =>
      'Collectez des œuvres à partir de sources ou importez des fichiers locaux.';

  @override
  String get bookshelf_no_match_hint =>
      'Essayez d\'autres mots-clés ou ajustez les filtres actuels.';

  @override
  String get bookshelf_clear_query => 'Effacer les mots-clés';

  @override
  String get bookshelf_view_selection => 'Visualiser les œuvres sélectionnées';

  @override
  String get bookshelf_import_formats =>
      'Choisissez un fichier local pour l\'ajouter à votre bibliothèque.';

  @override
  String get bookshelf_import_canceled_hint =>
      'Vous pouvez choisir à nouveau après avoir annulé le sélecteur de fichiers.';

  @override
  String get bookshelf_browse_sources => 'Parcourir les sources';

  @override
  String get bookshelf_empty_title => 'Votre bibliothèque est vide';

  @override
  String get bookshelf_no_match_title => 'Aucune œuvre correspondante';

  @override
  String get bookshelf_mark_watched => 'Mark a regardé';

  @override
  String get bookshelf_mark_unwatched => 'Marquer sans surveillance';

  @override
  String get nodelane_account => 'NodeLane';

  @override
  String get nodelane_sign_in => 'Connectez-vous à NodeLane';

  @override
  String get nodelane_account_intro =>
      'Visualisez votre compte, votre abonnement et votre quota de traduction';

  @override
  String get nodelane_login_action => 'Continuer à vous connecter';

  @override
  String get nodelane_login_browser =>
      'Connectez-vous via le navigateur système, puis revenez à l\'application';

  @override
  String get nodelane_account_id => 'Identifiant du compte';

  @override
  String get nodelane_account_init_error =>
      'Le stockage du compte n\'est pas disponible. Redémarrez l\'application et réessayez.';

  @override
  String get nodelane_account_refresh_error =>
      'Impossible d\'actualiser les informations du compte';

  @override
  String get nodelane_account_auth_error =>
      'Votre session a expiré. Connectez-vous à nouveau';

  @override
  String get nodelane_account_unknown =>
      'Les informations d\'abonnement ne sont pas disponibles';

  @override
  String get nodelane_account_current => 'Abonnement en cours';

  @override
  String get nodelane_account_free => 'Compte gratuit';

  @override
  String get nodelane_account_no_subscription => 'Aucun abonnement actif';

  @override
  String get nodelane_account_active => 'Actif';

  @override
  String get nodelane_account_expired => 'Expiré';

  @override
  String get nodelane_account_expiry => 'Valable jusqu\'au';

  @override
  String get nodelane_account_renewal => 'Renouvellement';

  @override
  String get nodelane_renewal_auto => 'Renouvellement automatique';

  @override
  String get nodelane_renewal_manual => 'Renouvellement manuel';

  @override
  String get nodelane_renewal_stopped => 'Renouvellement automatique arrêté';

  @override
  String get nodelane_renewal_gift => 'Cadeau d\'adhésion';

  @override
  String get nodelane_renewal_attention =>
      'Vérifiez votre statut de renouvellement sur le site Web';

  @override
  String get nodelane_next_billing => 'Prochaine date de facturation';

  @override
  String get nodelane_billing_unavailable =>
      'Les informations de renouvellement ne sont pas disponibles';

  @override
  String get nodelane_manage_account => 'Gérer sur le site Web';

  @override
  String get nodelane_view_plans => 'Afficher les plans d\'abonnement';

  @override
  String get nodelane_translation_quota => 'Quota de traduction';

  @override
  String get nodelane_quota_free => 'Quota gratuit';

  @override
  String get nodelane_quota_subscription => 'Quota d\'abonnement';

  @override
  String get nodelane_quota_purchase => 'Quota acheté';

  @override
  String get nodelane_quota_details => 'Afficher les détails du quota';

  @override
  String get nodelane_quota_expanded => 'Détails des quotas';

  @override
  String get nodelane_quota_unlimited => 'Illimité';

  @override
  String get nodelane_quota_not_subscribed => 'Non abonné';

  @override
  String get nodelane_quota_unknown => 'Indisponible';

  @override
  String get nodelane_quota_used => 'Utilisé';

  @override
  String get nodelane_quota_reserved => 'En cours';

  @override
  String get nodelane_quota_reset => 'Prochaine réinitialisation';

  @override
  String get nodelane_quota_expiry => 'Prochaine expiration';

  @override
  String get nodelane_quota_no_expiry => 'Pas de date d\'expiration';

  @override
  String get nodelane_quota_reservation_note =>
      'Les pages en cours sont déjà déduites du quota disponible';

  @override
  String nodelane_quota_available(int count) {
    return '$count pages restantes';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '${count}pages';
  }

  @override
  String get nodelane_sign_out => 'Se déconnecter';

  @override
  String get nodelane_sign_out_confirm =>
      'La déconnexion interrompt la traduction officielle sur cet appareil. Votre bibliothèque et vos progrès en lecture sont conservés.';

  @override
  String get settings_search_hint => 'Paramètres de recherche';

  @override
  String get settings_frequent => 'Fréquemment utilisé';

  @override
  String get settings_reading_translation => 'Lecture et traduction';

  @override
  String get settings_app_preferences => 'Préférences d\'application';

  @override
  String get settings_data_management => 'Données et gestion';

  @override
  String get settings_more_tools => 'Plus d\'outils';

  @override
  String get settings_more_tools_hint =>
      'Catégories, statistiques et calendrier';

  @override
  String get settings_appearance_interface => 'Apparence et interface';

  @override
  String get settings_security_privacy => 'Sécurité et confidentialité';

  @override
  String get settings_source_preferences => 'Paramètres des sources';

  @override
  String get settings_about_help => 'A propos et aide';

  @override
  String get settings_storage_backup => 'Stockage et sauvegarde';

  @override
  String settings_pending_downloads(int count) {
    return '$count en attente';
  }

  @override
  String get settings_translation_language => 'Langue de traduction';

  @override
  String get settings_translation_scope =>
      'Utilisé dans le lecteur et la traduction de pages Web';

  @override
  String get settings_immediate_choice =>
      'Les modifications s\'appliquent immédiatement';

  @override
  String get settings_translation_init_error =>
      'Les paramètres de traduction ne sont pas disponibles. Redémarrez l\'application et réessayez.';

  @override
  String get settings_local_cache => 'Cache local';

  @override
  String get settings_chapter_cache => 'Cache de chapitres et d\'épisodes';

  @override
  String get settings_cover_cache => 'Cache cache';

  @override
  String get settings_translation_cache => 'Cache d\'images traduites';

  @override
  String get settings_translation_cache_hint =>
      'Conservez les enregistrements de traduction et récupérez à nouveau les images traduites si nécessaire';

  @override
  String get settings_cache_clear => 'Effacer';

  @override
  String get settings_translation_cache_done =>
      'Cache d\'images traduites vidé ; dossiers de traduction conservés';

  @override
  String settings_cache_confirmation(String name) {
    return 'Effacer $name ? Le contenu mis en cache peut être récupéré à nouveau. Les entrées de la bibliothèque seront conservées.';
  }

  @override
  String get settings_advanced_options => 'Options avancées';

  @override
  String get settings_manga_reader => 'Lecteur de mangas';

  @override
  String get settings_novel_reader => 'Lecteur de roman';

  @override
  String get settings_downloads => 'Paramètres de téléchargement';

  @override
  String get onboarding_welcome => 'Bienvenue à';

  @override
  String get onboarding_reading_content => 'Lecture de contenu';

  @override
  String get onboarding_choose_one => 'Choisissez au moins un';

  @override
  String get onboarding_restore_hint =>
      'Restaurez votre bibliothèque à partir d\'une sauvegarde';

  @override
  String get onboarding_browse_hint =>
      'Rechercher des titres sur les sites Web pris en charge';

  @override
  String get onboarding_import_folder => 'Importer un dossier local';

  @override
  String get onboarding_import_folder_hint =>
      'Lisez des mangas, des romans et des anime sur votre appareil';

  @override
  String get onboarding_third_party => 'Ajouter un référentiel tiers';

  @override
  String get onboarding_third_party_hint =>
      'Utilisez une adresse de référentiel que vous possédez déjà';

  @override
  String get onboarding_repository_hint =>
      'Saisissez l\'adresse fournie par le référentiel.';

  @override
  String get onboarding_repository_address => 'Adresse';

  @override
  String get onboarding_repository_address_hint =>
      'Entrez l\'adresse du référentiel';

  @override
  String get onboarding_add_repository => 'Ajouter un référentiel';

  @override
  String get onboarding_start => 'Commencer';

  @override
  String get onboarding_open_library => 'Bibliothèque ouverte';

  @override
  String get onboarding_view_imports => 'Afficher le contenu importé';

  @override
  String get onboarding_view_folders => 'Afficher les dossiers';

  @override
  String get notice_backup_created => 'Sauvegarde créée';

  @override
  String get notice_backup_ready =>
      'Enregistrez ou partagez le fichier de sauvegarde.';

  @override
  String get notice_backup_restored => 'Sauvegarde restaurée';

  @override
  String get notice_backup_unsupported =>
      'Ce format de sauvegarde n\'est pas supporté.';

  @override
  String get notice_verification_required => 'Vérification du site Web requise';

  @override
  String get notice_verification_hint =>
      'Terminez la vérification pour continuer la navigation.';

  @override
  String get notice_verify => 'Vérifier le site Web';

  @override
  String get notice_action_incomplete =>
      'L\'action n\'est pas terminée. Vérifiez son résultat avant de réessayer.';

  @override
  String get notice_library_updating => 'Mise à jour de la bibliothèque';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'Titres $current / $total vérifiés';
  }

  @override
  String get notice_library_failed =>
      'Certains titres n\'ont pas pu être mis à jour';

  @override
  String get notice_import_completed => 'Importation terminée';

  @override
  String get notice_operation_incomplete => 'Action incomplète';

  @override
  String get subtitle_service => 'Service de sous-titrage en ligne';

  @override
  String get subtitle_service_mode => 'Source des sous-titres';

  @override
  String get subtitle_service_disabled =>
      'Désactivé · effacer les informations d\'identification enregistrées';

  @override
  String get subtitle_personal_key => 'Ma clé Wyzie';

  @override
  String get subtitle_custom_service => 'Mon service de sous-titres';

  @override
  String get subtitle_key => 'Wyzie API Clé';

  @override
  String get subtitle_key_hint =>
      'Entrez votre propre clé Wyzie. Il reste sur cet appareil et n\'est pas inclus dans les sauvegardes de l\'application.';

  @override
  String get subtitle_get_key => 'Obtenir une clé personnelle';

  @override
  String get subtitle_service_address => 'Recherche de sous-titres URL';

  @override
  String get subtitle_service_token => 'Jeton d\'accès au service (facultatif)';

  @override
  String get subtitle_custom_hint =>
      'Utilisez la recherche HTTPS complète URL d\'un service Wyzie-compatible, y compris son chemin (par exemple, /search). Saisissez un jeton d\'accès uniquement si votre service en nécessite un.';

  @override
  String get subtitle_service_off_hint =>
      'La recherche de sous-titres en ligne est désactivée. Les sous-titres intégrés, fournis par la source et locaux restent disponibles.';

  @override
  String get subtitle_setup_required =>
      'Choisissez un service de sous-titres avant de rechercher.';

  @override
  String get subtitle_invalid_key => 'Entrez une clé sans espaces.';

  @override
  String get subtitle_invalid_address =>
      'Utilisez un HTTPS URL complet sans requête, fragment ou informations d\'identification intégrées.';

  @override
  String get subtitle_invalid_token =>
      'Le jeton d\'accès ne peut pas contenir d\'espaces.';

  @override
  String get subtitle_storage_failed =>
      'Impossible de lire ou d\'enregistrer les paramètres de sous-titres. Veuillez réessayer.';

  @override
  String get subtitle_auth_failed =>
      'Le service de sous-titrage a refusé l\'accès. Vérifiez votre clé ou votre jeton de service.';

  @override
  String get subtitle_quota_exhausted =>
      'Le quota du service de sous-titres est épuisé. Vérifiez votre compte avec ce service.';

  @override
  String get subtitle_network_failed =>
      'Impossible d\'accéder au service de sous-titres. Veuillez réessayer.';

  @override
  String get subtitle_response_invalid =>
      'Le service de sous-titres a renvoyé une réponse ou un fichier non pris en charge.';

  @override
  String get detail_loading_chapters => 'Chargement des chapitres…';

  @override
  String get reader_opening_chapter => 'Chapitre d\'ouverture';

  @override
  String get reader_open_chapter => 'Chapitre ouvert';

  @override
  String get reader_loading_pages => 'Obtenir des images de chapitre…';

  @override
  String get reader_loading_pages_hint =>
      'La lecture démarrera automatiquement lorsqu\'elle sera prête.';

  @override
  String get reader_loading_failed => 'Impossible de charger ce chapitre';

  @override
  String get reader_loading_retry_hint =>
      'Vérifiez votre connexion et réessayez.';

  @override
  String get reader_no_pages => 'Aucune image trouvée pour ce chapitre';

  @override
  String get reader_loading_previous => 'Chargement du chapitre précédent…';

  @override
  String get reader_previous_failed =>
      'Impossible de charger le chapitre précédent';

  @override
  String get reader_reached_start => 'Vous avez atteint le premier chapitre';

  @override
  String get reader_loading_next => 'Chargement du chapitre suivant…';

  @override
  String get reader_next_failed => 'Impossible de charger le chapitre suivant';

  @override
  String get reader_image_loading => 'Chargement de l’image…';

  @override
  String get reader_image_failure_hint =>
      'Vous pouvez continuer à lire d\'autres pages.';

  @override
  String get comic_paged => 'Page par page';

  @override
  String get comic_scroll => 'Faites défiler vers le bas';

  @override
  String get comic_book_scope =>
      'S\'applique uniquement à ce livre · les modifications sont enregistrées immédiatement';

  @override
  String get comic_defaults_title => 'Paramètres par défaut et habitudes';

  @override
  String get comic_defaults_hint =>
      'Les valeurs par défaut s\'appliquent aux champs que vous n\'avez pas personnalisés pour un livre.';

  @override
  String get comic_habits_hint =>
      'Ces habitudes s\'appliquent à chaque bande dessinée.';

  @override
  String get comic_turn => 'Glisser vers la page suivante';

  @override
  String get comic_left => 'Gauche';

  @override
  String get comic_right => 'Droite';

  @override
  String get comic_up => 'Vers le haut';

  @override
  String get comic_fit => 'Ajustement de la page';

  @override
  String get comic_fit_contain => 'Page entière';

  @override
  String get comic_fit_width => 'Largeur d\'ajustement';

  @override
  String get comic_fit_height => 'Hauteur d\'ajustement';

  @override
  String get comic_layout => 'Mise en page';

  @override
  String get comic_auto => 'Automatique';

  @override
  String get comic_layout_hint =>
      'Auto affiche un écart lorsqu\'il y a suffisamment de largeur.';

  @override
  String get comic_width => 'Largeur du contenu';

  @override
  String get comic_full => 'Plein';

  @override
  String get comic_comfortable => 'Confortable';

  @override
  String get comic_narrow => 'Étroit';

  @override
  String get comic_gap => 'Espacement des pages';

  @override
  String get comic_no_gap => 'Sans couture';

  @override
  String get comic_small_gap => 'Petit';

  @override
  String get comic_image_title => 'Affiner l\'image';

  @override
  String get comic_image_hint =>
      'Le recadrage et le ton affectent uniquement ce livre.';

  @override
  String get comic_wide => 'Pages larges';

  @override
  String get comic_intact => 'Conserver entier';

  @override
  String get comic_split => 'Diviser';

  @override
  String get comic_rotate => 'Rotation';

  @override
  String get comic_wide_hint =>
      'Le fractionnement suit le sens de changement de page. S\'applique à la lecture d\'une seule page.';

  @override
  String get comic_cover => 'Une couverture par chapitre';

  @override
  String get comic_effects_reset => 'Réinitialiser les réglages de l\'image';

  @override
  String get comic_book_reset => 'Restaurer les paramètres par défaut du livre';

  @override
  String get comic_book_reset_hint =>
      'Efface les paramètres de lecture personnalisés de ce livre. La traduction est inchangée.';

  @override
  String get comic_canvas => 'Contexte du lecteur';

  @override
  String get comic_system => 'Système';

  @override
  String get comic_black => 'Noir';

  @override
  String get comic_gray => 'Gris';

  @override
  String get comic_paper => 'Papier';

  @override
  String get comic_tap => 'Appuyez pour tourner les pages';

  @override
  String get comic_tap_hint =>
      'Tapez sur les bords pour vous déplacer ; appuyez au centre pour afficher les commandes.';

  @override
  String get comic_scroll_start => 'Démarrer le défilement automatique';

  @override
  String get comic_scroll_pause => 'Suspendre le défilement automatique';

  @override
  String get comic_scroll_speed => 'Vitesse de défilement';

  @override
  String get comic_scroll_hint =>
      'Démarre à la fermeture de ce panneau. Se met en pause lorsque l\'application quitte le premier plan.';

  @override
  String get comic_save_failed =>
      'Impossible de sauvegarder. Veuillez réessayer.';

  @override
  String get comic_reading => 'Lecture';

  @override
  String get comic_chapter_habits_hint =>
      'Les habitudes de liste de chapitres s’appliquent à tous les livres.';

  @override
  String get browser_title => 'Navigateur';

  @override
  String get translation_image_display => 'Affichage d\'images';

  @override
  String get translation_display_hint =>
      'Afficher d\'abord les traductions existantes. Conservez l’original lorsqu’aucune traduction n’est disponible.';

  @override
  String get translation_sign_in_required =>
      'Connectez-vous pour activer la traduction';

  @override
  String get translation_sign_in_hint =>
      'Après vous être connecté, passez aux images traduites pour les traduire automatiquement.';

  @override
  String get translation_automatic => 'Traduction automatique';

  @override
  String get translation_original_hint =>
      'Affichage des originaux. Passez aux images traduites pour les traduire automatiquement.';

  @override
  String get translation_window_hint =>
      'Traitez les images actuelles et à venir uniquement tout en affichant les traductions.';

  @override
  String get translation_channel => 'Canal de traduction';

  @override
  String get translation_no_images =>
      'Aucune image traduisible trouvée sur cette page pour le moment';

  @override
  String get translation_waiting_image => 'En attente de l\'image actuelle';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · Les images $issues nécessitent une attention particulière',
      one: ' · 1 image nécessite une attention particulière',
      zero: '',
    );
    return 'Images $complete / $total terminées$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'Touchez et maintenez une image pour effectuer d\'autres actions, y compris sa nouvelle traduction.';

  @override
  String get translation_title => 'Traduction de mangas';

  @override
  String get translation_system_sign_in =>
      'Connectez-vous à l\'aide de votre navigateur système';

  @override
  String get translation_target_language => 'Langue cible';

  @override
  String get translation_clear_cache => 'Effacer le cache des images traduites';

  @override
  String get translation_cache_hint =>
      'Conservez les enregistrements de traduction et récupérez à nouveau les résultats si nécessaire.';

  @override
  String get translation_saved_read_failed =>
      'Impossible de charger la traduction enregistrée';

  @override
  String get translation_read_failed =>
      'Impossible de charger l\'image traduite';

  @override
  String get operation_retry =>
      'L\'action n\'est pas terminée. Veuillez réessayer.';

  @override
  String get translation_original => 'Origine';

  @override
  String get translation_translated => 'Traduit';

  @override
  String get translation_regenerate_image => 'Traduisez à nouveau cette image';

  @override
  String get translation_read_image => 'Recharger l\'image traduite';

  @override
  String get translation_image_actions => 'Plus d\'actions d\'image';

  @override
  String get translation_processing => 'Traitement';

  @override
  String get translation_reading => 'Chargement de l\'image traduite';

  @override
  String get translation_waiting => 'En attente de traduction';

  @override
  String get translation_preparing => 'Préparation de la traduction';

  @override
  String get translation_uploading => 'Téléchargement de l\'original';

  @override
  String get translation_running => 'Traduire';

  @override
  String get translation_uncertain => 'Le statut doit être vérifié';

  @override
  String get translation_failed => 'La traduction a échoué';

  @override
  String get translation_verify => 'Vérifier';

  @override
  String get translation_reread => 'Recharger';

  @override
  String get browser_back => 'Retour';

  @override
  String get browser_translation => 'Traduction de pages Web';

  @override
  String get browser_new_tab_action => 'Ouvrir un nouvel onglet';

  @override
  String get browser_current_tab => 'Courant';

  @override
  String get browser_close_tab => 'Fermer l\'onglet';

  @override
  String get browser_new_tab => 'Nouvel onglet';

  @override
  String get browser_page => 'Page Internet';

  @override
  String get browser_unopened => 'Aucune page ouverte pour le moment';

  @override
  String get browser_invalid_address => 'Entrez un URL valide';

  @override
  String get browser_clear_address => 'Effacer URL';

  @override
  String get browser_paste_address => 'Coller URL';

  @override
  String get browser_open_address => 'Ouvert URL';

  @override
  String browser_tab_count(int count) {
    return 'Onglets · $count';
  }

  @override
  String get browser_load_failed => 'Impossible d\'ouvrir cette page';

  @override
  String get browser_load_failed_hint => 'Vérifiez votre connexion et le URL.';

  @override
  String get browser_edit_address => 'Modifier URL';

  @override
  String get browser_clear_cookies_confirm =>
      'Effacer les sessions de connexion pour tous les sites Web ?';

  @override
  String get browser_clear_cookies_hint =>
      'Les sites Web dans tous les onglets peuvent vous demander de vous reconnecter.';

  @override
  String get browser_clear_cookies_action =>
      'Effacer les sessions de connexion';

  @override
  String get browser_tab_limit =>
      'Vous pouvez conserver jusqu\'à 12 onglets ouverts. Fermez-en un d’abord.';

  @override
  String get browser_forward => 'Avant';

  @override
  String get browser_clear_all_cookies =>
      'Effacer toutes les sessions de connexion au site Web';

  @override
  String get browser_clear_failed =>
      'Impossible d\'effacer les sessions. Veuillez réessayer.';

  @override
  String get browser_save_failed =>
      'Impossible de sauvegarder les onglets. Veuillez réessayer.';

  @override
  String get browser_tabs_full => '12 onglets sont déjà ouverts';

  @override
  String get browser_no_tabs => 'Aucun onglet ouvert pour l\'instant';

  @override
  String get browser_close_failed =>
      'Impossible de sauvegarder les onglets. Appuyez à nouveau sur Fermer pour réessayer.';

  @override
  String get source_pinned_websites => 'Sites Web épinglés';

  @override
  String get manage => 'Gérer';

  @override
  String get translation_settings_hint =>
      'Traduction automatique, langue cible et canal';

  @override
  String get translation_show_original => 'Appuyez pour afficher l\'original';

  @override
  String get translation_show_translated =>
      'Appuyez pour afficher la traduction';

  @override
  String get source_display => 'Affichage';

  @override
  String get source_cover_title => 'Couverture et titre';

  @override
  String get source_cover_only => 'Couverture seulement';

  @override
  String get source_save_search => 'Sauvegarder la recherche en cours';

  @override
  String get source_saved_searches => 'Recherches sauvegardées';

  @override
  String get source_website_info => 'Informations sur le site Web';

  @override
  String source_saved_search_title(String title) {
    return '$title · Appuyez pour rechercher';
  }

  @override
  String get action_done => 'Terminé';

  @override
  String source_search_keyword(String query) {
    return 'Mot clé : $query';
  }

  @override
  String get source_no_saved_searches =>
      'Aucune recherche enregistrée pour l\'instant';

  @override
  String get source_save_search_hint =>
      'Recherchez un mot-clé, puis enregistrez-le à partir des actions du site Web.';

  @override
  String get source_saved_search_scope =>
      'Les mots-clés sont enregistrés uniquement pour ce site Web.';

  @override
  String get source_search_here => 'Rechercher des titres sur ce site Web';

  @override
  String get source_filter_results => 'Résultats filtrés';

  @override
  String get source_search_results => 'Résultats de recherche';

  @override
  String get source_return_popular => 'Retour aux populaires';

  @override
  String get source_popular_titles => 'Titres populaires';

  @override
  String get source_no_titles => 'Aucun titre correspondant trouvé';

  @override
  String get source_no_titles_hint =>
      'Modifiez vos mots-clés ou filtres, ou revenez aux titres populaires.';

  @override
  String get source_load_more_failed =>
      'Impossible de charger davantage. Veuillez réessayer.';

  @override
  String get source_load_pull_retry =>
      'Impossible de charger ce site Web. Tirez vers le bas pour réessayer.';

  @override
  String get source_clear_failed =>
      'Impossible de terminer la suppression. Veuillez réessayer.';

  @override
  String get source_uninstall_failed =>
      'Impossible de terminer la désinstallation. Veuillez réessayer.';

  @override
  String get source_details => 'Détails de la source';

  @override
  String get source_repository_website => 'Site Web du référentiel';

  @override
  String get source_provided_settings => 'Paramètres fournis par la source';

  @override
  String get source_advanced_actions => 'Actions avancées';

  @override
  String get source_edit_metadata => 'Modifier les informations sur la source';

  @override
  String get source_clear_cookies => 'Supprimer les cookies de ce site Web';

  @override
  String get source_clear_cookies_hint =>
      'Vous devrez peut-être vous reconnecter lors de votre prochaine visite.';

  @override
  String get source_uninstall => 'Désinstaller la source';

  @override
  String get source_settings_save_failed =>
      'La sauvegarde n\'est pas terminée. Rouvrez les paramètres source pour vérifier.';

  @override
  String get repository_third_party => 'Référentiels tiers';

  @override
  String get repository_refresh_failed =>
      'Impossible d\'actualiser le catalogue. Le contenu mis en cache est conservé. Veuillez réessayer.';

  @override
  String get repository_show_sources =>
      'Afficher les sources de ce référentiel';

  @override
  String get repository_copy_catalog => 'Copier le lien du catalogue';

  @override
  String get repository_remove => 'Supprimer le référentiel';

  @override
  String get repository_remove_hint =>
      'Conserver les sources installées et supprimer les entrées de catalogue désinstallées.';

  @override
  String get repository_empty =>
      'Aucun référentiel tiers n\'a encore été ajouté';

  @override
  String get repository_built_in => 'Catalogue officiel intégré';

  @override
  String get repository_hidden => 'Caché';

  @override
  String get repository_refreshing => 'Rafraîchissant…';

  @override
  String get repository_refresh => 'Actualiser le catalogue';

  @override
  String get repository_manage_hint =>
      'Gérez l\'endroit à partir duquel les sources tierces sont téléchargées.';

  @override
  String get repository_invalid_address => 'Entrez un HTTP ou HTTPS URL valide';

  @override
  String get repository_already_added => 'Ce référentiel a déjà été ajouté';

  @override
  String get repository_unrecognized =>
      'Aucun catalogue pris en charge trouvé. Vérifiez le lien et réessayez.';

  @override
  String get repository_read_failed =>
      'Impossible de lire le catalogue. Veuillez réessayer.';

  @override
  String get repository_save_failed =>
      'La sauvegarde n\'est pas terminée. Vérifiez votre liste de référentiels.';

  @override
  String get repository_paste_hint =>
      'Coller un lien vers un catalogue de référentiel tiers';

  @override
  String get repository_address => 'URL';

  @override
  String get repository_paste_link => 'Coller le lien';

  @override
  String repository_recognized(String type) {
    return '$type · Catalogue reconnu';
  }

  @override
  String get repository_choose_sources_hint =>
      'Après avoir ajouté le référentiel, choisissez les sources dont vous avez besoin.';

  @override
  String get search_scope => 'Portée de recherche';

  @override
  String get search_scope_hint =>
      'Choisir les sites Web sur lesquels rechercher';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rechercher des sites Web $count',
      one: 'Rechercher 1 site Web',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Trouver un site Internet';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sites $count sélectionnés',
      one: '1 site internet sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Effacer';

  @override
  String get search_deselect_results =>
      'Désélectionner les sites Web correspondants';

  @override
  String get search_select_results =>
      'Sélectionnez les sites Web correspondants';

  @override
  String get search_no_websites_hint =>
      'Aucun site Web correspondant. Essayez un autre nom ou une autre langue.';

  @override
  String get search_select_website_hint =>
      'Sélectionnez au moins un site Web à rechercher.';

  @override
  String get search_start_title =>
      'Saisir des mots-clés pour rechercher des titres';

  @override
  String get search_start_hint =>
      'Recherchez plusieurs sites Web à la fois et affichez les titres correspondants.';

  @override
  String get search_empty_scope =>
      'Aucun site Web consultable dans ce périmètre';

  @override
  String get search_empty_scope_hint =>
      'Basculez vers tous les sites Web ou choisissez les sites Web sur lesquels effectuer la recherche.';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Résultats $count',
      one: '1 résultat',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'Rechercher des titres';

  @override
  String get search_actions => 'Actions de recherche';

  @override
  String get search_details => 'Détails de la recherche';

  @override
  String get search_title_hint => 'Recherche par titre';

  @override
  String get search_searching => 'Recherche';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Résultats $count trouvés',
      one: 'Trouvé 1 résultat',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'Aucun résultat correspondant';

  @override
  String get search_failed => 'La recherche a échoué';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres trouvés',
      one: '1 titre trouvé',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: 'Sites $websites',
      one: '1 site Internet',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Recherche de titres';

  @override
  String get search_complete => 'Recherche terminée';

  @override
  String get search_in_progress => 'Recherche';

  @override
  String get search_finding_related =>
      'Vous recherchez des titres correspondants…';

  @override
  String get search_no_results_yet =>
      'Aucun résultat de recherche pour l\'instant';

  @override
  String get search_no_matching_titles => 'Aucun titre correspondant trouvé';

  @override
  String get search_results_appear_hint =>
      'Les résultats apparaîtront ici au fur et à mesure qu’ils seront trouvés.';

  @override
  String get search_failed_websites_hint =>
      'Certains sites Web n\'ont pas pu terminer la recherche. Réessayez-les dans les détails de la recherche.';

  @override
  String get search_change_keywords_hint =>
      'Essayez des mots-clés plus courts ou recherchez davantage de sites Web.';

  @override
  String get search_view_details => 'Afficher les détails de la recherche';

  @override
  String get search_adjust_scope => 'Ajuster la portée de la recherche';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sites $count',
      one: '1 site Internet',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Terminé $completed / $total';
  }

  @override
  String get search_retry_website_hint =>
      'Réessayez individuellement les sites Web ayant échoué';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments sélectionnés',
      one: '1 élément sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Langues de recherche';

  @override
  String get source_deselect => 'Désélectionner';

  @override
  String get source_select => 'Sélectionner la source';

  @override
  String get source_multilingual => 'Multilingue';

  @override
  String get source_language_unknown => 'Langue non précisée';

  @override
  String get source_adult_content => 'Contient plus de 18 contenus';

  @override
  String get source_classification_unknown => 'Classement non précisé';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Afficher toutes les informations sources, $count plus de catégories',
      one: 'Afficher toutes les informations sources, 1 catégorie supplémentaire',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Chargement du site Web';

  @override
  String get source_unpin => 'Désépingler';

  @override
  String get source_pin => 'Épingle';

  @override
  String get source_open => 'Ouvrir';

  @override
  String get source_metadata_hint =>
      'Les informations proviennent du catalogue source. Les catégories décrivent le contenu couvert par le site Web.';

  @override
  String get source_region => 'Région';

  @override
  String get source_format => 'Formater';

  @override
  String get source_creation => 'Création';

  @override
  String get source_unspecified => 'Non précisé';

  @override
  String get source_pricing => 'Tarification';

  @override
  String get source_region_jp => 'Bandes dessinées japonaises';

  @override
  String get source_region_kr => 'Bandes dessinées coréennes';

  @override
  String get source_region_cn => 'Bandes dessinées chinoises';

  @override
  String get source_region_hk_tw =>
      'Bandes dessinées de Hong Kong et de Taiwan';

  @override
  String get source_region_western => 'Bandes dessinées occidentales';

  @override
  String get source_region_other => 'Autres régions';

  @override
  String get source_format_page => 'Bandes dessinées paginées';

  @override
  String get source_format_vertical => 'Bandes dessinées verticales';

  @override
  String get source_format_strip => 'Bandes dessinées';

  @override
  String get source_creation_original => 'Origine';

  @override
  String get source_creation_fan => 'Le ventilateur fonctionne';

  @override
  String get source_free_watch => 'Regarder gratuitement';

  @override
  String get source_free_read => 'Lecture gratuite';

  @override
  String get source_partial_paid => 'Partiellement payé';

  @override
  String get source_paid_watch => 'Visionnage payant';

  @override
  String get source_paid_read => 'Lecture payante';

  @override
  String get source_pricing_unknown => 'Prix non précisé';

  @override
  String get source_language_filter => 'Filtrer par langue';

  @override
  String get source_language_filter_hint =>
      'Filtrer ce catalogue uniquement. Les sources installées ne sont pas affectées.';

  @override
  String get source_all_languages => 'Toutes les langues';

  @override
  String get action_apply => 'Appliquer';

  @override
  String get source_load_retry =>
      'Impossible de charger ce site Web. Veuillez réessayer.';

  @override
  String get source_catalog_refresh_failed =>
      'Impossible d\'actualiser le catalogue. Le contenu actuel est conservé. Tirez vers le bas pour réessayer.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Désinstaller les sources $count ?',
      one: 'Désinstaller 1 source ?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Désinstallez les sources sélectionnées et effacez leurs paramètres. Conservez les titres de bibliothèque et les téléchargements.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Les actions ont échoué pour les sources $count.',
      one: 'L’action a échoué pour 1 source.',
    );
    return '$_temp0 Sélection conservée. Veuillez réessayer.';
  }

  @override
  String get source_latest_content => 'Dernier contenu';

  @override
  String get source_actions => 'Actions sources';

  @override
  String get source_bulk_manage => 'Gérer plusieurs sources';

  @override
  String get source_update_installed => 'Mettre à jour les sources installées';

  @override
  String get source_no_matching_websites => 'Aucun site Web correspondant';

  @override
  String get source_no_websites => 'Aucun site Web disponible';

  @override
  String get source_search_installed_hint =>
      'Rechercher des titres dans les sources installées';

  @override
  String get source_global_search => 'Recherche parmi les sources';

  @override
  String get source_manage_repositories => 'Gérer les référentiels';

  @override
  String get source_view_third_party => 'Afficher les sources tierces';

  @override
  String get source_catalog_load_failed =>
      'Impossible de charger le catalogue. Tirez vers le bas pour réessayer.';

  @override
  String get source_all_websites => 'Tous les sites Internet';

  @override
  String get source_available => 'Disponible pour l\'installation';

  @override
  String get source_third_party => 'Tiers';

  @override
  String get source_name_or_title => 'Nom ou titre du site Web';

  @override
  String get view_all => 'Tout voir';

  @override
  String get search_searching_ellipsis => 'Recherche…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · Non testé';
  }

  @override
  String get onboarding_untested => 'Non testé';

  @override
  String get source_custom_scope => 'Personnalisé';

  @override
  String get source_custom_websites => 'Sites Web sélectionnés';

  @override
  String get tv_hidden_library_hint =>
      'Chaque titre se trouve dans une catégorie cachée.\nMaintenez OK sur « Tous » pour en afficher un.';

  @override
  String get tv_no_matching_anime => 'Aucun anime correspondant';

  @override
  String tv_no_matching_category(String category) {
    return 'Aucun anime correspondant dans « $category »';
  }

  @override
  String get tv_filtered_empty_hint =>
      'Aucun anime ne correspond aux filtres actuels.\nModifiez-les à partir du bouton à côté de la recherche.';

  @override
  String get tv_new_episodes => 'Nouveaux épisodes';

  @override
  String get tv_recently_added => 'Récemment ajouté';

  @override
  String get tv_empty_category_hint =>
      'Aucun anime dans cette catégorie pour l\'instant.\nAjoutez-y des titres à partir de la page de détail d\'un titre.';

  @override
  String get tv_empty_library => 'Votre bibliothèque d\'anime est vide';

  @override
  String get tv_empty_library_hint =>
      'Ajoutez un anime depuis Parcourir pour remplir votre maison';

  @override
  String get tv_browse_anime => 'Parcourir les anime';

  @override
  String tv_new_count(int count) {
    return '$count nouveau';
  }

  @override
  String tv_category_hidden(String category) {
    return 'Hid « $category » · maintenez OK sur « All » pour afficher';
  }

  @override
  String get tv_no_hidden_categories => 'Pas de catégories cachées';

  @override
  String get import_torrent_file => 'importer un fichier .torrent';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi et plus';

  @override
  String get cloudflare_proxy_optional => 'FlareSolverr / Byparr en option URL';

  @override
  String get tv_home_layout_hint =>
      'Accueil d\'anime basé sur des lignes (Continuer · Nouveaux épisodes · catégories) au lieu de la grille plate';

  @override
  String get tv_hide_libraries_hint =>
      'Masquer les bibliothèques mangas & romans (activé par défaut sur TV)';

  @override
  String get anime_only_hint =>
      'Masquez les mangas et les romans dans l\'application. Éteignez pour tout afficher.';

  @override
  String get audio_auto_safe => 'Sécurité automatique';

  @override
  String get tv_player_hint =>
      'Allumé : lecteur TV dédié.  Désactivé : lecteur original (de bureau).';

  @override
  String get release_open_failed => 'Impossible d\'ouvrir la version';

  @override
  String get tv_replay => 'Relecture';

  @override
  String get tv_no_episodes => 'Aucun épisode pour l\'instant';

  @override
  String get tracker_continue_series => 'Continuer à regarder des séries';

  @override
  String get tracker_watchlist_series => 'Série de listes de surveillance';

  @override
  String get tracker_continue_movies => 'Continuer à regarder des films';

  @override
  String get tracker_watchlist_movies => 'Liste de films à surveiller';

  @override
  String get tracker_trending_series => 'Série tendance';

  @override
  String get tracker_trending_movies => 'Films tendances';

  @override
  String get tracker_popular_series => 'Séries populaires';

  @override
  String get tracker_popular_movies => 'Films populaires';

  @override
  String get tracker_top_series => 'Meilleures séries (tous les temps)';

  @override
  String get tracker_top_movies => 'Meilleurs films (tous les temps)';

  @override
  String get tracker_airing_series => 'Série de diffusion';

  @override
  String get tracker_airing_anime => 'Diffusion d\'anime';

  @override
  String get tracker_popular_anime => 'Anime populaire';

  @override
  String get tracker_upcoming_anime => 'Anime à venir';

  @override
  String get tracker_popular_manga => 'Mangas populaires';

  @override
  String get tracker_top_manga => 'Meilleurs Mangas';

  @override
  String get tracker_top_manhwa => 'Haut Manhwa';

  @override
  String get tracker_top_manhua => 'Haut Manhua';

  @override
  String get tracker_latest_anime => 'Dernier Anime';

  @override
  String get tracker_best_anime => 'Anime le mieux noté';

  @override
  String get tracker_latest_manga => 'Derniers mangas';

  @override
  String get tracker_best_manga => 'Mangas les mieux notés';

  @override
  String get tracker_trending_anime => 'Anime tendance';

  @override
  String get tracker_upcoming_manga => 'Mangas à venir';

  @override
  String get tracker_trending_manga => 'Mangas Tendances';

  @override
  String selection_progress(int selected, int total) {
    return '$selected/$total sélectionné';
  }

  @override
  String get source_code_editor => 'Éditeur de codes';

  @override
  String get source_code_execute => 'Exécuter';

  @override
  String get source_console_logs => 'Journaux de la console';

  @override
  String get source_no_logs => 'Aucun journal pour l\'instant';

  @override
  String get source_updated_successfully => 'Source mise à jour avec succès';

  @override
  String get source_obsolete => 'OBSOLÈTE';

  @override
  String player_seek_forward_seconds(int seconds) {
    return 'Recherche en avant de $seconds secondes';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return 'Recherche en arrière de $seconds secondes';
  }

  @override
  String get player_autoplay_on =>
      'Lecture automatique de l\'épisode suivant : activé';

  @override
  String get player_autoplay_off =>
      'Lecture automatique de l\'épisode suivant : désactivée';

  @override
  String get player_no_other_quality => 'Aucune autre qualité';

  @override
  String get player_no_subtitles => 'Pas de sous-titres';

  @override
  String get player_no_audio_tracks => 'Aucune piste audio';

  @override
  String get player_seek_forward => 'Recherche en avant';

  @override
  String get player_seek_backward => 'Recherche en arrière';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds secondes',
      one: '1 seconde',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'Lorem ipsum dolor sit amet';

  @override
  String get subtitle_style => 'Style';

  @override
  String get translation_official_channel => 'NodeLane Officiel';

  @override
  String get translation_auth_required =>
      'Connectez-vous d\'abord à votre compte de traduction.';

  @override
  String get translation_source_changed =>
      'L\'image originale a changé. Veuillez le recharger.';

  @override
  String get translation_source_missing =>
      'L\'image originale est actuellement indisponible.';

  @override
  String get translation_resource_limit =>
      'Cette image dépasse la limite de traitement du dispositif. L\'original est conservé.';

  @override
  String get translation_storage_full =>
      'Le stockage de traduction est plein. Effacez d’abord les images traduites.';

  @override
  String get translation_invalid_image =>
      'Format ou contenu d\'image invalide.';

  @override
  String get translation_unsupported_image =>
      'La traduction n\'est pas prise en charge pour cette image. L\'original est conservé.';

  @override
  String get translation_invalid_result =>
      'La validation de l’image traduite a échoué. Veuillez le recharger.';

  @override
  String get translation_result_unavailable =>
      'L\'image traduite n\'est pas disponible. Veuillez le recharger.';

  @override
  String get translation_result_expired =>
      'L\'image traduite a expiré. Veuillez le traduire à nouveau.';

  @override
  String get translation_analysis_too_large =>
      'Il y a trop de contenu d’image à analyser. Réduisez la taille de l’image et réessayez.';

  @override
  String get translation_region_limit =>
      'L\'image comporte trop de zones de texte. Divisez-le et réessayez.';

  @override
  String get translation_text_limit =>
      'Une région de texte est trop longue. Ajustez l\'image et réessayez.';

  @override
  String get translation_unavailable =>
      'Cette traduction n\'est plus disponible.';

  @override
  String get translation_outcome_unknown =>
      'Le résultat doit être vérifié. Il n\'a pas été soumis à nouveau.';

  @override
  String get translation_rate_limited =>
      'Les demandes sont limitées. La traduction reprendra automatiquement.';

  @override
  String get translation_quota_exhausted => 'Quota de traduction insuffisant.';

  @override
  String get translation_unsupported_language =>
      'Le service ne prend pas en charge cette langue cible.';

  @override
  String get translation_upgrade_required =>
      'Le protocole de traduction est incompatible. Mettez à jour l\'application.';

  @override
  String get translation_remote_failed =>
      'La traduction a échoué pour cette page. Vous pouvez réessayer manuellement.';

  @override
  String get translation_bridge_invalid =>
      'La page Web a changé. Activez à nouveau la traduction.';

  @override
  String get translation_connection_failed =>
      'La connexion a échoué. Veuillez réessayer.';

  @override
  String get translation_paused =>
      'Traduction interrompue. Vous pouvez vérifier sa progression.';

  @override
  String get translation_preparing_ellipsis => 'Préparation de la traduction…';

  @override
  String get translation_checking_original =>
      'Vérification de l’image originale…';

  @override
  String get translation_submitting => 'Soumission…';

  @override
  String get translation_uploading_ellipsis => 'Téléchargement de l’original…';

  @override
  String get translation_waiting_ellipsis => 'En attente de traduction…';

  @override
  String get translation_running_ellipsis => 'Traduire…';

  @override
  String get translation_verify_result => 'Le résultat doit être vérifié';

  @override
  String get translation_partial => 'Certains contenus ont été traduits';

  @override
  String get translation_ready => 'Image traduite prête';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Jouer';

  @override
  String get player_quality => 'Qualité';

  @override
  String get player_subtitles => 'Sous-titres';

  @override
  String get player_audio => 'Audio';

  @override
  String get player_statistics => 'Statistiques pour les nerds';

  @override
  String get player_auto => 'Automatique';

  @override
  String get source_information => 'Informations sur la source';

  @override
  String get source_code_page => 'Pages';

  @override
  String get source_code_query => 'Requête';

  @override
  String get repository_invalid_source => 'Source invalide - supprimez-la';

  @override
  String get player_fit_contain => 'Contenir';

  @override
  String get player_fit_cover => 'Couverture';

  @override
  String get player_fit_fill => 'Remplir';

  @override
  String get player_fit_height => 'Hauteur';

  @override
  String get player_fit_width => 'Largeur';

  @override
  String get player_fit_scale => 'Échelle';

  @override
  String get player_fit_none => 'Aucun';

  @override
  String get player_shader_clear => 'Désactivé (effacer les shaders)';

  @override
  String get player_shader_luma => 'Mise à l\'échelle de la luminance';

  @override
  String get player_decoder_auto => 'Automatique (matériel)';

  @override
  String get player_decoder_software => 'Logiciel (pas de matériel)';

  @override
  String get player_stats_toggle => 'Basculer la superposition';

  @override
  String get player_stats_general => 'Général';

  @override
  String get player_stats_frames => 'Synchronisations de trame';

  @override
  String get player_stats_cache => 'Cache d\'entrée';

  @override
  String get player_stats_filters => 'Filtres actifs';

  @override
  String get player_stats_log => 'Journal';

  @override
  String get source_mark_pinned => 'Épingle';

  @override
  String translation_image_action(String action) {
    return '$action cette image';
  }

  @override
  String get memory_waiting => 'mémoire : attente d\'un échantillon';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current pic $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'cache $current / $limit pic $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'items $count / $limit live $live pic $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Échantillons $count',
      one: '1 échantillon',
    );
    return '$percent% complet de $_temp0';
  }

  @override
  String get memory_reset_hint =>
      'activez-le et désactivez-le dans les paramètres pour réinitialiser';

  @override
  String get action_hide => 'Masquer';

  @override
  String discord_get_app(String app) {
    return 'Obtenez $app';
  }

  @override
  String get discord_idle => 'Au repos';

  @override
  String discord_watching_title(String title) {
    return 'Regarder $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'Lecture de $title';
  }
}
