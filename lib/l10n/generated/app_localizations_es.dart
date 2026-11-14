// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get browser_search_hint => 'Buscar o introducir una URL';

  @override
  String get browser_start_hint => 'Una nueva página para descubrir.';

  @override
  String get browser_search_engine => 'Motor de búsqueda';

  @override
  String get browser_bookmarks => 'Marcadores';

  @override
  String get browser_search_library => 'Buscar títulos o URL';

  @override
  String get browser_data_failed =>
      'No se pudieron leer o guardar los datos del navegador. Inténtalo de nuevo.';

  @override
  String get browser_clear_history => 'Borrar historial de navegación';

  @override
  String get browser_clear_history_hint =>
      '¿Borrar todo el historial de este dispositivo? Se conservarán los marcadores y las sesiones de los sitios.';

  @override
  String get browser_library_empty => 'Todavía no hay nada';

  @override
  String get browser_bookmarks_hint =>
      'Añade una página a marcadores desde su menú para encontrarla aquí.';

  @override
  String get browser_history_hint =>
      'Las páginas visitadas aparecen aquí, incluso después de cerrar sus pestañas.';

  @override
  String get browser_recent => 'Visitas recientes';

  @override
  String get browser_pinned_hint =>
      'Fija tus sitios favoritos en Fuentes para acceder rápidamente.';

  @override
  String get browser_start_page => 'Página de inicio';

  @override
  String get browser_remove_bookmark => 'Eliminar marcador';

  @override
  String get browser_add_bookmark => 'Añadir marcador';

  @override
  String get browser_find => 'Buscar en la página';

  @override
  String get browser_copy_link => 'Copiar enlace';

  @override
  String get browser_action_failed =>
      'No se pudo completar la acción. Inténtalo de nuevo.';

  @override
  String get browser_find_previous => 'Coincidencia anterior';

  @override
  String get browser_find_next => 'Coincidencia siguiente';

  @override
  String browser_find_matches(int current, int total) {
    return 'Coincidencia $current de $total';
  }

  @override
  String get app_update_details_hint =>
      'Ver notas de la versión y opciones de instalación';

  @override
  String get app_update_download => 'Descargar actualización';

  @override
  String get app_update_download_hint =>
      'Después de la descarga, siga las instrucciones para instalar la actualización.';

  @override
  String get bookshelf_all => 'Todos';

  @override
  String get bookshelf_search => 'Buscar biblioteca';

  @override
  String get app_update_allow_install =>
      'Permita la instalación de la aplicación en la configuración del sistema, luego regrese y toque Instalar.';

  @override
  String get app_update_waiting =>
      'Esperando que el sistema reanude la descarga…';

  @override
  String get app_update_cancel_download => 'Cancelar descarga';

  @override
  String get app_update_remove_package => 'Eliminar paquete descargado';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'No hay configuraciones coincidentes';

  @override
  String get search_empty_hint =>
      'Pruebe con otra palabra clave o borre la búsqueda para verlo todo.';

  @override
  String get search_clear => 'Borrar búsqueda';

  @override
  String get app_updates => 'Actualizaciones de aplicaciones';

  @override
  String get app_update_auto => 'Comprobar en el lanzamiento';

  @override
  String get app_update_view => 'Ver actualización';

  @override
  String get app_update_later => 'Más tarde';

  @override
  String get app_update_external_hint =>
      'Abre el enlace de actualización en su navegador';

  @override
  String get app_update_failed =>
      'No se pueden buscar actualizaciones. Por favor inténtalo de nuevo.';

  @override
  String get app_update_opened => 'Enlace de actualización abierto';

  @override
  String get app_diagnostics => 'Diagnósticos y registros';

  @override
  String get library => 'Biblioteca';

  @override
  String get updates_search => 'Buscar actualizaciones';

  @override
  String get updates => 'Actualizaciones';

  @override
  String get history => 'Historia';

  @override
  String get browse => 'Explorar';

  @override
  String get more => 'Más';

  @override
  String get open_random_entry => 'Abrir entrada aleatoria';

  @override
  String get import => 'Importar';

  @override
  String get filter => 'Filtrar';

  @override
  String get ignore_filters => 'Ignorar filtros';

  @override
  String get downloaded => 'Descargado';

  @override
  String get unread => 'Sin leer';

  @override
  String get unwatched => 'No visto';

  @override
  String get started => 'Comenzado';

  @override
  String get bookmarked => 'Marcado';

  @override
  String get sort => 'Ordenar';

  @override
  String get alphabetically => 'Alfabéticamente';

  @override
  String get last_read => 'Última lectura';

  @override
  String get last_watched => 'Visto por última vez';

  @override
  String get last_update_check => 'Última verificación de actualización';

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
          'Estás borrando los $count $entryTypePlural de este $mediaType de tu biblioteca.',
      one:
          'Estás borrando el único $entryType de este $mediaType de tu biblioteca.',
    );
    return '$_temp0\nEsto también quitará todo el $mediaType de tu biblioteca.\n\nNota: Los archivos en sí no se borrarán.';
  }

  @override
  String get chapter => 'capítulo';

  @override
  String get episode => 'episodio';

  @override
  String get unread_count => 'Cuenta de no leídos';

  @override
  String get unwatched_count => 'Número no visto';

  @override
  String get latest_chapter => 'Último capítulo';

  @override
  String get latest_episode => 'Último episodio';

  @override
  String get date_added => 'Fecha añadida';

  @override
  String get display => 'Mostrar';

  @override
  String get display_mode => 'Modo de visualización';

  @override
  String get compact_grid => 'Cuadrícula compacta';

  @override
  String get compression_level => 'Nivel de compresión';

  @override
  String compression_info(Object level) {
    return 'Cuanta más compresión, menos espacio ocupa el respaldo, pero más CPU consume. Predeterminado: $level';
  }

  @override
  String get comfortable_grid => 'Cuadrícula cómoda';

  @override
  String get cover_only_grid => 'Cuadrícula solo de portadas';

  @override
  String get list => 'Lista';

  @override
  String get badges => 'Insignias';

  @override
  String get downloaded_chapters => 'Capítulos descargados';

  @override
  String get downloaded_episodes => 'Episodios descargados';

  @override
  String get language => 'Idioma';

  @override
  String get local_source => 'Fuente local';

  @override
  String get tabs => 'Pestañas';

  @override
  String get show_category_tabs => 'Mostrar pestañas de categoría';

  @override
  String get show_numbers_of_items => 'Mostrar números de ítems';

  @override
  String get other => 'Otro';

  @override
  String get show_continue_reading_buttons =>
      'Mostrar botones de continuar leyendo';

  @override
  String get show_continue_watching_buttons =>
      'Mostrar botones de continuar viendo';

  @override
  String get empty_library => 'Biblioteca vacía';

  @override
  String get search => 'Buscar...';

  @override
  String get no_recent_updates => 'No hay actualizaciones recientes';

  @override
  String get remove_everything => 'Eliminar todo';

  @override
  String get remove_everything_msg =>
      '¿Estás seguro? Se perderá todo el historial';

  @override
  String get remove_all_update_msg =>
      '¿Estás seguro? Toda la actualización será eliminada';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Eliminar';

  @override
  String get remove_history_msg =>
      'Esto eliminará la fecha de lectura de este capítulo. ¿Estás seguro?';

  @override
  String get last_used => 'Último usado';

  @override
  String get pinned => 'Fijado';

  @override
  String get sources => 'Fuentes';

  @override
  String get install => 'Instalar';

  @override
  String get update => 'Actualizar';

  @override
  String get latest => 'Último';

  @override
  String get extensions => 'Extensiones';

  @override
  String get migrate => 'Migrar';

  @override
  String get mass_migration_title => 'Migración masiva';

  @override
  String get mass_migration_preview_items => 'Vista previa de elementos';

  @override
  String get mass_migration_destination_source => 'Fuente de destino';

  @override
  String get mass_migration_no_library_items =>
      'No hay elementos de la biblioteca disponibles para migración masiva.';

  @override
  String get mass_migration_no_destination_sources =>
      'No hay fuentes de destino instaladas.';

  @override
  String get mass_migration_installed => 'Instalado';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos listos para revisión',
      one: '1 elemento listo para revisión',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Seleccionar fuente de destino';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Buscando coincidencias en $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Procesando elemento $current de $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Esperando 2 segundos antes del siguiente elemento...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Esperando 2 segundos antes de la siguiente migración...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Coincidencias hasta ahora: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Sin coincidencia: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Revisar coincidencias de $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Coincidencias encontradas: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Sin coincidencias: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Seleccionados para migrar: $count';
  }

  @override
  String get mass_migration_finish_review => 'Finalizar revisión';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migrar elementos seleccionados ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Migrando elementos seleccionados a $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'No hay elementos seleccionados para migrar.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migrando elemento $current de $total';
  }

  @override
  String get mass_migration_complete => 'Migración masiva completada';

  @override
  String get mass_migration_complete_success_message =>
      'Todos los elementos seleccionados fueron procesados con éxito.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migración finalizada con algunos elementos que aún requieren atención manual.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Procesado';

  @override
  String get mass_migration_matched => 'Coincidente';

  @override
  String get mass_migration_migrated => 'Migrado';

  @override
  String get mass_migration_skipped => 'Omitido';

  @override
  String get mass_migration_failed => 'Fallido';

  @override
  String get mass_migration_failed_items => 'Elementos fallidos';

  @override
  String get mass_migration_exit => 'Salir de migración masiva';

  @override
  String get mass_migration_no_destination_match =>
      'No se encontró coincidencia en el destino';

  @override
  String mass_migration_query(Object query) {
    return 'Consulta: $query';
  }

  @override
  String get mass_migration_skip => 'Omitir';

  @override
  String get mass_migration_loading => 'Cargando...';

  @override
  String get mass_migration_choose_another_result => 'Elegir otro resultado';

  @override
  String get mass_migration_source_chapters => 'Capítulos de origen';

  @override
  String get mass_migration_destination_chapters => 'Capítulos de destino';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos',
      one: '1 capítulo',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos del origen',
      one: '1 capítulo del origen',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos del destino',
      one: '1 capítulo del destino',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'No se encontraron capítulos.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Y $count más...';
  }

  @override
  String get mass_migration_unknown_title => 'Título desconocido';

  @override
  String get mass_migration_unknown_match => 'Coincidencia desconocida';

  @override
  String get mass_migration_unknown_source => 'Fuente desconocida';

  @override
  String get mass_migration_unknown_chapter => 'Capítulo desconocido';

  @override
  String get migrate_confirm => 'Migrar a otra fuente';

  @override
  String get clean_database => 'Limpiar base de datos';

  @override
  String cleaned_database(Object x) {
    return '¡Base de datos limpiada! $x entradas eliminadas';
  }

  @override
  String get clean_database_desc =>
      '¡Esto eliminará todos los elementos que no se hayan agregado a la biblioteca!';

  @override
  String get incognito_mode => 'Modo incógnito';

  @override
  String get incognito_mode_description => 'Pausa el historial de lectura';

  @override
  String get downloaded_only => 'Solo descargados';

  @override
  String get downloaded_only_description =>
      'Mostrar solo entradas descargadas en tu biblioteca';

  @override
  String get download_queue => 'Cola de descarga';

  @override
  String get categories => 'Categorías';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get settings => 'Configuraciones';

  @override
  String get about => 'Acerca de';

  @override
  String get help => 'Ayuda';

  @override
  String get no_downloads => 'Sin descargas';

  @override
  String get edit_categories => 'Editar categorías';

  @override
  String get edit_categories_description =>
      'No tienes categorías. Toca el botón más para crear una para organizar tu biblioteca';

  @override
  String get add => 'Agregar';

  @override
  String get add_category => 'Agregar categoría';

  @override
  String get name => 'Nombre';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Requerido';

  @override
  String get add_category_error_exist =>
      '¡Ya existe una categoría con este nombre!';

  @override
  String get delete_category => 'Eliminar categoría';

  @override
  String delete_category_msg(Object name) {
    return '¿Deseas eliminar la categoría $name?';
  }

  @override
  String get rename_category => 'Renombrar categoría';

  @override
  String get general => 'General';

  @override
  String get general_subtitle => 'Idioma de la app';

  @override
  String get app_language => 'Idioma de la app';

  @override
  String get default_subtitle_language => 'Idioma predeterminado de subtítulos';

  @override
  String get appearance => 'Apariencia';

  @override
  String get appearance_subtitle => 'Tema, formato de fecha y hora';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Modo oscuro';

  @override
  String get follow_system_theme => 'Seguir el tema del sistema';

  @override
  String get on => 'Encendido';

  @override
  String get off => 'Apagado';

  @override
  String get pure_black_dark_mode => 'Modo oscuro negro puro';

  @override
  String get timestamp => 'Sello de tiempo';

  @override
  String get relative_timestamp => 'Sello de tiempo relativo';

  @override
  String get relative_timestamp_short => 'Corto (Hoy, Ayer)';

  @override
  String get relative_timestamp_long => 'Largo (Corto+, hace n días)';

  @override
  String get date_format => 'Formato de fecha';

  @override
  String get reader => 'Lector';

  @override
  String get refresh => 'Actualizar';

  @override
  String get reader_subtitle => 'Modo de lectura, visualización, navegación';

  @override
  String get default_reading_mode => 'Modo de lectura predeterminado';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'De izquierda a derecha';

  @override
  String get reading_mode_right_to_left => 'De derecha a izquierda';

  @override
  String get reading_mode_vertical_continuous => 'Vertical continuo';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Velocidad de animación de doble toque';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Rápido';

  @override
  String get no_animation => 'Sin animación';

  @override
  String get animate_page_transitions => 'Animar transiciones de página';

  @override
  String get crop_borders => 'Recortar bordes';

  @override
  String get downloads => 'Descargas';

  @override
  String get downloads_subtitle => 'Configuraciones de descargas';

  @override
  String get download_location => 'Ubicación de descarga';

  @override
  String get custom_location => 'Ubicación personalizada';

  @override
  String get only_on_wifi => 'Solo en wifi';

  @override
  String get save_as_cbz_archive => 'Guardar como archivo CBZ';

  @override
  String get delete_download_after_reading => 'Eliminar descarga tras leer';

  @override
  String get concurrent_downloads => 'Descargas simultáneas';

  @override
  String get browse_subtitle => 'Fuentes, búsqueda global';

  @override
  String get only_include_pinned_sources => 'Incluir solo fuentes fijadas';

  @override
  String get nsfw_sources => 'Fuentes NSFW (+18)';

  @override
  String get nsfw_sources_show => 'Mostrar en listas de fuentes y extensiones';

  @override
  String get nsfw_sources_info =>
      'Esto no evita que extensiones no oficiales o potencialmente mal etiquetadas muestren contenido NSFW (18+) dentro de la app';

  @override
  String get version => 'Versión';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Buscar actualizaciones';

  @override
  String get logs_on => 'Activar registro';

  @override
  String get share_app_logs => 'Compartir registros de la aplicación';

  @override
  String get no_app_logs => '¡No hay archivo log.txt disponible!';

  @override
  String get failed => '¡Fallido!';

  @override
  String n_days_ago(Object days) {
    return 'hace $days días';
  }

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get a_week_ago => 'Hace una semana';

  @override
  String get next_week => 'La próxima semana';

  @override
  String get add_to_library => 'Agregar a la biblioteca';

  @override
  String get completed => 'Completado';

  @override
  String get ongoing => 'En curso';

  @override
  String get on_hiatus => 'En pausa';

  @override
  String get canceled => 'Cancelado';

  @override
  String get publishing_finished => 'Publicación finalizada';

  @override
  String get unknown => 'Desconocido';

  @override
  String get empty_placeholder => 'VACÍO';

  @override
  String get error => 'Error';

  @override
  String error_with_message(Object error) {
    return 'Error: $error';
  }

  @override
  String get no_pages_available => 'Error: no hay páginas disponibles';

  @override
  String get set_categories => 'Establecer categorías';

  @override
  String get edit => 'Editar';

  @override
  String get in_library => 'En la biblioteca';

  @override
  String get filter_scanlator_groups => 'Filtrar grupos de scanlation';

  @override
  String get reset => 'Reiniciar';

  @override
  String get by_source => 'Por fuente';

  @override
  String get by_chapter_number => 'Por número de capítulo';

  @override
  String get by_episode_number => 'Por número de episodio';

  @override
  String get by_upload_date => 'Por fecha de subida';

  @override
  String get source_title => 'Título de fuente';

  @override
  String get create_extension => 'Crear extensión';

  @override
  String get developer_mode => 'Modo desarrollador';

  @override
  String get developer_mode_subtitle =>
      'Mostrar herramientas de desarrollador de extensiones (crear extensión, editar código)';

  @override
  String get choose_extension_language => 'Elegir idioma de la extensión';

  @override
  String get lang => 'Idioma';

  @override
  String get base_url => 'URL base';

  @override
  String get api_url_optional => 'URL de la API (opcional)';

  @override
  String get icon_url => 'URL del icono';

  @override
  String get source_icon_url => 'URL del icono de la fuente';

  @override
  String get notes => 'Notas';

  @override
  String get extension_name_example => 'ej: miAnime';

  @override
  String get language_code_example => 'ej: es';

  @override
  String get base_url_example => 'ej: https://ejemplo.com';

  @override
  String get api_url_example => 'ej: https://api.ejemplo.com';

  @override
  String get extension_notes_example =>
      'ej: esta extensión requiere inicio de sesión';

  @override
  String get type => 'Tipo';

  @override
  String get target => 'Destino';

  @override
  String get source_type_single => 'única';

  @override
  String get source_type_multi => 'múltiple';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS compilado de LNReader';

  @override
  String get source_created_successfully => 'Fuente creada con éxito';

  @override
  String get source_already_exists => 'La fuente ya existe';

  @override
  String get error_when_creating_source => 'Error al crear la fuente';

  @override
  String get cookies_deleted => '¡Cookies eliminadas!';

  @override
  String get delete_all_cookies => 'Eliminar todas las cookies';

  @override
  String get chapter_number => 'Número de capítulo';

  @override
  String get episode_number => 'Número de episodio';

  @override
  String get share => 'Compartir';

  @override
  String n_chapters(Object n) {
    return '$n capítulos';
  }

  @override
  String missing_chapters(Object count) {
    return 'Faltan $count capítulos';
  }

  @override
  String get no_description => 'Sin descripción';

  @override
  String get resume => 'Reanudar';

  @override
  String get read => 'Leer';

  @override
  String get watch => 'Ver';

  @override
  String get popular => 'Popular';

  @override
  String get open_in_browser => 'Abrir en navegador';

  @override
  String get clear_cookie => 'Limpiar cookie';

  @override
  String get show_page_number => 'Mostrar número de página';

  @override
  String get from_library => 'Desde la biblioteca';

  @override
  String get downloaded_chapter => 'Capítulo descargado';

  @override
  String page(Object page) {
    return 'Página $page';
  }

  @override
  String get global_search => 'Búsqueda global';

  @override
  String get color_blend_level => 'Nivel de mezcla de color';

  @override
  String current(Object char) {
    return 'Actual $char';
  }

  @override
  String finished(Object char) {
    return 'Terminado $char';
  }

  @override
  String next(Object char) {
    return 'Siguiente $char';
  }

  @override
  String previous(Object char) {
    return 'Anterior $char';
  }

  @override
  String get no_more_chapter => 'No hay más capítulos';

  @override
  String get no_result => 'Sin resultados';

  @override
  String get send => 'Enviar';

  @override
  String get delete => 'Eliminar';

  @override
  String get start_downloading => 'Comenzar a descargar ahora';

  @override
  String get retry => 'Reintentar';

  @override
  String get add_chapters => 'Agregar capítulos';

  @override
  String get delete_chapters => '¿Eliminar capítulo?';

  @override
  String get default0 => 'Predeterminado';

  @override
  String get total_chapters => 'Capítulos totales';

  @override
  String get total_episodes => 'Total de episodios';

  @override
  String get import_local_file => 'Importar archivo local';

  @override
  String get import_files => 'Archivos';

  @override
  String get split_epub_chapters => 'Dividir en capítulos';

  @override
  String get split_epub_chapters_description =>
      'Importar cada capítulo EPUB como una entrada separada';

  @override
  String get nothing_read_recently => 'Nada leído recientemente';

  @override
  String get status => 'Estado';

  @override
  String get not_started => 'No iniciado';

  @override
  String get score => 'Puntuación';

  @override
  String get start_date => 'Fecha de inicio';

  @override
  String get finish_date => 'Fecha de finalización';

  @override
  String get reading => 'Leyendo';

  @override
  String get on_hold => 'En espera';

  @override
  String get dropped => 'Abandonado';

  @override
  String get plan_to_read => 'Planear leer';

  @override
  String get re_reading => 'Releyendo';

  @override
  String get chapters => 'Capítulos';

  @override
  String get add_tracker => 'Añadir seguimiento';

  @override
  String get one_tracker => '1 seguimiento';

  @override
  String n_tracker(Object n) {
    return '$n seguimientos';
  }

  @override
  String get tracking => 'Seguimiento';

  @override
  String get syncing => 'Sincronizar';

  @override
  String get sync_logged => 'Inicio de sesión exitoso';

  @override
  String get syncing_subtitle =>
      'Introduce la dirección de tu servidor de sincronización e inicia sesión en el navegador para sincronizar tu progreso de lectura entre dispositivos.';

  @override
  String get sync_service => 'Sincronización autoalojada';

  @override
  String get last_sync => 'Última sincronización: ';

  @override
  String get sync_login_browser => 'Iniciar sesión con el navegador';

  @override
  String get sync_server => 'Dirección del servidor de sincronización';

  @override
  String get sync_starting => 'Empezando la sincronización...';

  @override
  String get sync_finished => 'Sincronización finalizada';

  @override
  String get sync_failed => 'Error de sincronización';

  @override
  String get sync_restore_in_progress =>
      'Sincronización omitida: restauración en curso';

  @override
  String sync_progress_percent(Object percent) {
    return 'Sincronizando… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Sincronizando…';

  @override
  String get sync_button_sync => 'Sincronizar progreso';

  @override
  String get sync_button_upload => 'Solo subir';

  @override
  String get sync_button_upload_info =>
      '¡Esta operación reemplazará completamente los datos remotos con los datos locales!';

  @override
  String get sync_button_download => 'Solo descargar';

  @override
  String get sync_button_download_info =>
      '¡Esta operación reemplazará completamente los datos locales con los datos remotos!';

  @override
  String get sync_status_not_configured => 'No conectado';

  @override
  String get sync_status_checking => 'Comprobando conexión...';

  @override
  String get sync_status_connected => 'Conectado';

  @override
  String get sync_status_unauthorized =>
      'Sesión expirada, por favor inicie sesión de nuevo';

  @override
  String get sync_status_unreachable => 'No se puede conectar al servidor';

  @override
  String get sync_section_general => 'General';

  @override
  String get sync_on => 'Habilitar sincronización';

  @override
  String get sync_auto => 'Sincronización automática';

  @override
  String get sync_auto_warning =>
      '¡La sincronización automática es una función experimental actualmente!';

  @override
  String get sync_auto_off => 'Desactivado';

  @override
  String get sync_auto_5_minutes => 'Cada 5 minutos';

  @override
  String get sync_auto_10_minutes => 'Cada 10 minutos';

  @override
  String get sync_auto_30_minutes => 'Cada 30 minutos';

  @override
  String get sync_auto_1_hour => 'Cada 1 hora';

  @override
  String get sync_auto_3_hours => 'Cada 3 horas';

  @override
  String get sync_auto_6_hours => 'Cada 6 horas';

  @override
  String get sync_auto_12_hours => 'Cada 12 horas';

  @override
  String get server_error => '¡Error del servidor!';

  @override
  String get dialog_confirm => 'Confirmar';

  @override
  String get description => 'Descripción';

  @override
  String get reorder_navigation => 'Personalizar navegación';

  @override
  String get reorder_navigation_description =>
      'Reordena y ajusta cada navegación según tus necesidades.';

  @override
  String get floating_navigation_bar => 'Barra de navegación flotante';

  @override
  String get floating_navigation_bar_description =>
      'Utilice una cápsula flotante en lugar de la barra de navegación adjunta estándar.';

  @override
  String get full_screen_player => 'Usar pantalla completa';

  @override
  String get full_screen_player_info =>
      'Usar automáticamente la pantalla completa al reproducir un video.';

  @override
  String episode_progress(Object n) {
    return 'Progreso: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n episodios';
  }

  @override
  String missing_episodes(Object count) {
    return 'Faltan $count episodios';
  }

  @override
  String get manga_sources => 'Fuentes de manga';

  @override
  String get anime_sources => 'Fuentes de anime';

  @override
  String get novel_sources => 'Fuentes de novelas';

  @override
  String get anime_extensions => 'Extensiones de anime';

  @override
  String get manga_extensions => 'Extensiones de manga';

  @override
  String get novel_extensions => 'Extensiones de novelas';

  @override
  String get extension_settings => 'Configuración de extensión';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novela';

  @override
  String get library_no_category_exist => 'Aún no tienes ninguna categoría';

  @override
  String get watching => 'Viendo';

  @override
  String get plan_to_watch => 'Planear ver';

  @override
  String get re_watching => 'Reviendo';

  @override
  String get episodes => 'Episodios';

  @override
  String get download => 'Descargar';

  @override
  String get new_update_available => 'Nueva actualización disponible';

  @override
  String app_version(Object v) {
    return 'Versión de la App : v$v';
  }

  @override
  String get searching_for_updates => 'Buscando actualizaciones...';

  @override
  String get no_new_updates_available =>
      'No hay nuevas actualizaciones disponibles';

  @override
  String get uninstall => 'Desinstalar';

  @override
  String uninstall_extension(Object ext) {
    return '¿Desinstalar extensión $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Toca dos veces para buscar todo en $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Mostrar sugerencia de búsqueda por doble toque';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Muestra un cuadro de información en los destinos de Manga/Anime/Novela explicando que tocar dos veces abre la búsqueda global.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" ya está en tu biblioteca a través de $source.';
  }

  @override
  String get add_anyway => 'Añadir de todos modos';

  @override
  String get langauage => 'Idioma';

  @override
  String get extension_detail => 'Detalle de extensión';

  @override
  String get scale_type => 'Tipo de escala';

  @override
  String get scale_type_fit_screen => 'Ajustar a pantalla';

  @override
  String get scale_type_stretch => 'Estirar';

  @override
  String get scale_type_fit_width => 'Ajustar al ancho';

  @override
  String get scale_type_fit_height => 'Ajustar al alto';

  @override
  String get scale_type_original_size => 'Tamaño original';

  @override
  String get scale_type_smart_fit => 'Ajuste inteligente';

  @override
  String get page_preload_amount => 'Cantidad de páginas a precargar';

  @override
  String get page_preload_amount_subtitle =>
      'La cantidad de páginas a precargar al leer. Valores más altos resultarán en una experiencia de lectura más fluida, a costa de un mayor uso de caché y red.';

  @override
  String get image_loading_error => 'Esta imagen no pudo cargarse';

  @override
  String get add_episodes => 'Agregar episodios';

  @override
  String get video_quality => 'Calidad';

  @override
  String get video_subtitle => 'Subtítulo';

  @override
  String get check_for_extension_updates =>
      'Buscar actualizaciones de extensión';

  @override
  String get auto_extensions_updates =>
      'Actualizaciones automáticas de extensión';

  @override
  String get auto_extensions_updates_subtitle =>
      'Actualizará automáticamente la extensión cuando haya una nueva versión disponible.';

  @override
  String get check_for_app_updates =>
      'Buscar actualizaciones de la aplicación al iniciar';

  @override
  String get reading_mode => 'Modo de lectura';

  @override
  String get custom_filter => 'Filtro personalizado';

  @override
  String get background_color => 'Color de fondo';

  @override
  String get white => 'Blanco';

  @override
  String get black => 'Negro';

  @override
  String get grey => 'Gris';

  @override
  String get automaic => 'Automático';

  @override
  String get preferred_domain => 'Dominio preferido';

  @override
  String get load_more => 'Cargar más';

  @override
  String get cancel_all_for_this_series => 'Cancelar todo para esta serie';

  @override
  String get login => 'Iniciar sesión';

  @override
  String login_into(Object tracker) {
    return 'Iniciar sesión en $tracker';
  }

  @override
  String get email_adress => 'Dirección de correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String log_out_from(Object tracker) {
    return '¿Cerrar sesión de $tracker?';
  }

  @override
  String get log_out => 'Cerrar sesión';

  @override
  String get update_pending => 'Actualización pendiente';

  @override
  String get update_all => 'Actualizar todo';

  @override
  String get backup_and_restore => 'Respaldo y restauración';

  @override
  String get create_backup => 'Crear respaldo';

  @override
  String get create_backup_dialog_title => '¿Qué quieres respaldar?';

  @override
  String get create_backup_subtitle =>
      'Puede ser usado para restaurar la biblioteca actual';

  @override
  String get restore_backup => 'Restaurar respaldo';

  @override
  String get encrypt_backups => 'Cifrar copias de seguridad';

  @override
  String get encrypt_backups_info =>
      'Proteger copias de seguridad con contraseña mediante cifrado AES';

  @override
  String get no_secure_storage => 'No se encontró almacenamiento seguro';

  @override
  String get no_keyring_warning =>
      'Este sistema no dispone de un servicio de llavero (ej. gnome-keyring o kwallet en Linux), por lo que la contraseña no se puede guardar de forma segura.\n\n¿Guardarla sin cifrar en la base de datos local de la aplicación? Cualquiera con acceso a los datos de la app podrá leerla.';

  @override
  String get enter_backup_password =>
      'Introduce la contraseña de la copia de seguridad';

  @override
  String get incorrect_password_try_again =>
      'Contraseña incorrecta, inténtalo de nuevo.';

  @override
  String get set_backup_password => 'Crear contraseña de copia de seguridad';

  @override
  String get confirm_password => 'Confirmar contraseña';

  @override
  String get passwords_do_not_match => 'Las contraseñas no coinciden';

  @override
  String get password_required_to_restore =>
      'Se requiere una contraseña para restaurar esta copia de seguridad.';

  @override
  String get restore_backup_subtitle =>
      'Restaurar biblioteca desde archivo de respaldo';

  @override
  String get automatic_backups => 'Respaldo automático';

  @override
  String get backup_frequency => 'Frecuencia de respaldo';

  @override
  String get backup_location => 'Ubicación de respaldo';

  @override
  String get backup_options => 'Opciones de respaldo';

  @override
  String get backup_options_dialog_title => '¿Qué quieres respaldar?';

  @override
  String get backup_options_subtitle =>
      'Qué información incluir en el archivo de respaldo';

  @override
  String get backup_and_restore_warning_info =>
      'Deberías mantener copias de los respaldos en otros lugares también';

  @override
  String get library_entries => 'Entradas de biblioteca';

  @override
  String get chapters_and_episode => 'Capítulos y episodios';

  @override
  String get every_6_hours => 'Cada 6 horas';

  @override
  String get every_12_hours => 'Cada 12 horas';

  @override
  String get daily => 'Diario';

  @override
  String get every_2_days => 'Cada 2 días';

  @override
  String get weekly => 'Semanal';

  @override
  String get restore_backup_warning_title =>
      'Restaurar una copia de seguridad sobrescribirá todos los datos existentes.\n\n¿Continuar con la restauración?';

  @override
  String get restore_sync_question_title => '¿Sincronizar esta restauración?';

  @override
  String get restore_sync_question_message =>
      'Este dispositivo está conectado a un servidor de sincronización. ¿Subir estos datos restaurados ahora? Si no, la sincronización se desactivará para evitar que los datos antiguos del servidor sobrescriban lo restaurado.';

  @override
  String get restore_sync_question_confirm => 'Sí, sincronizar';

  @override
  String get restore_sync_question_deny => 'No, desactivar sincronización';

  @override
  String get sync_disabled_after_restore =>
      'La sincronización está desactivada. Puedes activarla de nuevo en Ajustes.';

  @override
  String get restore_sync_disabled_question_title =>
      'La sincronización está desactivada';

  @override
  String get restore_sync_disabled_question_message =>
      'La sincronización está apagada. ¿Deseas activarla y subir estos datos restaurados a tu servidor?';

  @override
  String get restore_sync_question_reenable => 'Sí, reactivar y sincronizar';

  @override
  String get restore_sync_question_keep_disabled => 'Mantener desactivada';

  @override
  String get restore_sync_uploading =>
      'Sincronizando datos restaurados con el servidor…';

  @override
  String get restore_sync_upload_success =>
      'Datos restaurados sincronizados con el servidor';

  @override
  String get services => 'Servicios';

  @override
  String get tracking_warning_info =>
      'Sincronización unidireccional para actualizar el progreso de los capítulos en servicios de seguimiento. Configura el seguimiento para entradas individuales desde su botón de seguimiento.';

  @override
  String get use_page_tap_zones => 'Usar zonas de toque de página';

  @override
  String get manage_trackers => 'Gestionar rastreadores';

  @override
  String get restore => 'Restaurar';

  @override
  String get backups => 'Copias de seguridad';

  @override
  String get by_scanlator => 'Por scanlator';

  @override
  String get by_name => 'Por nombre';

  @override
  String get installed => 'Instalado';

  @override
  String get auto_scroll => 'Desplazamiento automático';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Idiomas preferidos, corrección de tono, canales de audio';

  @override
  String get player => 'Jugador';

  @override
  String get markEpisodeAsSeenSetting =>
      'En qué punto marcar el episodio como visto';

  @override
  String get mark_duplicate_chapters_read =>
      'Marcar números de capítulos duplicados como leídos';

  @override
  String get default_skip_intro_length =>
      'Duración predeterminada para saltar la introducción';

  @override
  String get default_playback_speed_length =>
      'Duración predeterminada de la velocidad de reproducción';

  @override
  String get updateProgressAfterReading =>
      'Actualizar el progreso después de leer';

  @override
  String get no_sources_installed => '¡No hay fuentes instaladas!';

  @override
  String get show_extensions => 'Mostrar extensiones';

  @override
  String get default_skip_forward_skip_length =>
      'Longitud de salto hacia adelante predeterminada';

  @override
  String get aniskip_requires_info =>
      'AniSkip requiere que el anime esté registrado en MAL o Anilist para funcionar.';

  @override
  String get enable_aniskip => 'Habilitar AniSkip';

  @override
  String get enable_auto_skip => 'Habilitar salto automático';

  @override
  String get aniskip_button_timeout => 'Tiempo de espera del botón';

  @override
  String get skip_opening => 'Omitir apertura';

  @override
  String get skip_ending => 'Omitir cierre';

  @override
  String get fullscreen => 'Pantalla completa';

  @override
  String get update_library => 'Actualizar biblioteca';

  @override
  String get next_chapter => 'Próximo capítulo';

  @override
  String get next_5_chapters => 'Próximos 5 capítulos';

  @override
  String get next_10_chapters => 'Próximos 10 capítulos';

  @override
  String get next_25_chapters => 'Próximos 25 capítulos';

  @override
  String get all_chapters => 'Todos los capítulos';

  @override
  String get next_episode => 'Siguiente episodio';

  @override
  String get next_5_episodes => 'Siguientes 5 episodios';

  @override
  String get next_10_episodes => 'Siguientes 10 episodios';

  @override
  String get next_25_episodes => 'Siguientes 25 episodios';

  @override
  String get all_episodes => 'Todos los episodios';

  @override
  String get cover_saved => 'Portada guardada';

  @override
  String get set_as_cover => 'Establecer como portada';

  @override
  String get use_this_as_cover_art => '¿Usar esto como portada?';

  @override
  String get save => 'Guardar';

  @override
  String get picture_saved => 'Imagen guardada';

  @override
  String get cover_updated => 'Portada actualizada';

  @override
  String get include_subtitles => 'Incluir subtítulos';

  @override
  String get blend_mode_default => 'Por defecto';

  @override
  String get blend_mode_multiply => 'Multiplicar';

  @override
  String get blend_mode_screen => 'Pantalla';

  @override
  String get blend_mode_overlay => 'Incrustar';

  @override
  String get blend_mode_colorDodge => 'Esquema de color';

  @override
  String get blend_mode_lighten => 'Aclarar';

  @override
  String get blend_mode_colorBurn => 'Quemadura de color';

  @override
  String get blend_mode_darken => 'Oscurecer';

  @override
  String get blend_mode_difference => 'Diferencia';

  @override
  String get blend_mode_saturation => 'Saturación';

  @override
  String get blend_mode_softLight => 'Luz suave';

  @override
  String get blend_mode_plus => 'Más';

  @override
  String get blend_mode_exclusion => 'Exclusión';

  @override
  String get custom_color_filter => 'Filtro de color personalizado';

  @override
  String get color_filter_blend_mode => 'Modo de mezcla de filtro de color';

  @override
  String get enable_all => 'Activar todo';

  @override
  String get disable_all => 'Desactivar todo';

  @override
  String get font => 'Fuente';

  @override
  String get color => 'Color';

  @override
  String get font_size => 'Tamaño de fuente';

  @override
  String get text => 'Texto';

  @override
  String get border => 'Borde';

  @override
  String get background => 'Fondo';

  @override
  String get no_subtite_warning_message =>
      'No tiene efecto porque no hay pistas de subtítulos en este vídeo';

  @override
  String get grid_size => 'Tamaño de la cuadrícula';

  @override
  String n_per_row(Object n) {
    return '$n por fila';
  }

  @override
  String get horizontal_continious => 'Horizontal continuo';

  @override
  String get edit_code => 'Editar código';

  @override
  String get use_libass => 'Habilitar libass';

  @override
  String get use_libass_info =>
      'Utilice la renderización de subtítulos basada en libass para el backend nativo.';

  @override
  String get libass_not_disable_message =>
      'Deshabilite `use libass` en la configuración del reproductor para poder personalizar los subtítulos.';

  @override
  String get override_ass_subtitles => 'Anular subtítulos ASS';

  @override
  String get override_ass_subtitles_info =>
      'Aplicar estilo personalizado a los subtítulos ASS/SSA';

  @override
  String get torrent_stream => 'Transmisión de torrent';

  @override
  String get add_torrent => 'Agregar torrent';

  @override
  String get enter_torrent_hint_text =>
      'Ingrese la URL del imán o del archivo torrent';

  @override
  String get torrent_url => 'URL del torrent';

  @override
  String get or => 'O';

  @override
  String get advanced => 'Avanzado';

  @override
  String get advanced_info => 'Configuración mpv';

  @override
  String get use_native_http_client => 'Utilizar cliente HTTP nativo';

  @override
  String get use_native_http_client_info =>
      'admite automáticamente las características de la plataforma como VPNs, admite más características HTTP como HTTP/3 y manejo de redirección personalizada';

  @override
  String n_hour_ago(Object hour) {
    return 'hace $hour hora';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'hace $hours horas';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'hace $minute minuto';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'hace $minutes minutos';
  }

  @override
  String n_day_ago(Object day) {
    return 'hace $day día';
  }

  @override
  String get now => 'ahora';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Última actualización de la biblioteca: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Datos y almacenamiento';

  @override
  String get download_location_info => 'Usado para descargas de capítulos';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get clear_chapter_and_episode_cache =>
      'Borrar caché de capítulos y episodios';

  @override
  String get cache_cleared => 'Caché borrada';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Borrar caché de capítulos/episodios al iniciar la aplicación';

  @override
  String get app_settings => 'Configuración de la aplicación';

  @override
  String get sources_settings => 'Configuración de fuentes';

  @override
  String get include_sensitive_settings =>
      'Incluir configuraciones sensibles (por ejemplo, tokens de inicio de sesión de rastreadores)';

  @override
  String get create => 'Crear';

  @override
  String get downloads_are_limited_to_wifi =>
      'Las descargas están limitadas solo a Wi-Fi';

  @override
  String get recommendations => 'Recomendaciones';

  @override
  String get recommendations_similar => 'similar';

  @override
  String get recommendations_weights => 'Pesos de recomendación';

  @override
  String get recommendations_weights_genre => 'Similaridad de género';

  @override
  String get recommendations_weights_setting => 'Similaridad de escenario';

  @override
  String get recommendations_weights_synopsis => 'Similaridad de historia';

  @override
  String get recommendations_weights_theme => 'Similaridad de tema';

  @override
  String get manga_extensions_repo => 'Repositorio de extensiones de manga';

  @override
  String get anime_extensions_repo => 'Repositorio de extensiones de anime';

  @override
  String get novel_extensions_repo => 'Repositorio de extensiones de novelas';

  @override
  String get custom_dns =>
      'DNS personalizado (dejar en blanco para usar DNS del sistema)';

  @override
  String get android_proxy_server =>
      'Servidor proxy de Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Obtener M-Extension-Server';

  @override
  String get undefined => 'Indefinido';

  @override
  String get empty_extensions_repo =>
      'No tienes ninguna URL de repositorio aquí. ¡Haz clic en el botón más para agregar una!';

  @override
  String get add_extensions_repo => 'Agregar URL del repositorio';

  @override
  String get remove_extensions_repo => 'Eliminar URL del repositorio';

  @override
  String get manage_manga_repo_urls =>
      'Gestionar URLs del repositorio de manga';

  @override
  String get manage_anime_repo_urls =>
      'Gestionar URLs del repositorio de anime';

  @override
  String get manage_novel_repo_urls =>
      'Gestionar URLs del repositorio de novelas';

  @override
  String get url_cannot_be_empty => 'La URL no puede estar vacía';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'La URL debe terminar con .json / .pb';

  @override
  String get repo_url => 'URL del repositorio';

  @override
  String get invalid_url_format => 'Formato de URL no válido';

  @override
  String get clear_all_sources => 'Borrar todas las fuentes';

  @override
  String get clear_all_sources_msg =>
      'Esto borrará completamente todas las fuentes de la aplicación. ¿Estás seguro de que deseas continuar?';

  @override
  String get sources_cleared => '¡Fuentes borradas!';

  @override
  String get repo_added => '¡Repositorio de fuentes agregado!';

  @override
  String get repo_already_exists => '¡El repositorio ya existe!';

  @override
  String get add_repo => '¿Agregar repositorio?';

  @override
  String get add_repo_sources_to_add =>
      'Listas de extensiones que se agregarán:';

  @override
  String get add_repo_warning =>
      'Las extensiones de estos repositorios se ejecutan dentro de la aplicación. Agregue solo repositorios en los que confíe.';

  @override
  String get genre_search_library => 'Buscar género en la biblioteca';

  @override
  String get genre_search_source => 'Explorar en la fuente';

  @override
  String get source_not_added => '¡La fuente no está instalada!';

  @override
  String get load_own_subtitles => 'Cargar tus propios subtítulos...';

  @override
  String get search_subtitles => 'Buscar subtítulos en línea...';

  @override
  String extension_notes(Object notes) {
    return 'Notas: $notes';
  }

  @override
  String get unsupported_repo =>
      'No se ha podido añadir este repositorio de fuentes. Comprueba su dirección o contacta con su responsable.';

  @override
  String get you_have_finished_reading => 'Has terminado de leer';

  @override
  String get hwdec => 'Decodificador de hardware';

  @override
  String get enable_hardware_accel => 'Aceleración de hardware';

  @override
  String get enable_hardware_accel_info =>
      'Actívalo/desactívalo si experimentas errores o bloqueos';

  @override
  String get track_library_navigate => 'Ir a la entrada local existente';

  @override
  String get track_library_add => 'Agregar a la biblioteca local';

  @override
  String get track_library_add_confirm =>
      'Agregar elemento rastreado a la biblioteca local';

  @override
  String get track_library_not_logged =>
      '¡Inicia sesión en el rastreador correspondiente para usar esta función!';

  @override
  String get track_library_switch => 'Cambiar a otro rastreador';

  @override
  String get go_back => 'Volver';

  @override
  String get merge_library_nav_mobile =>
      'Fusionar navegación de biblioteca en móvil';

  @override
  String get enable_discord_rpc => 'Activar Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Ocultar Discord RPC en modo Incógnito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Mostrar capítulo actual en Discord (requiere reinicio)';

  @override
  String get rpc_show_title => 'Mostrar título actual en Discord';

  @override
  String get rpc_show_cover_image =>
      'Mostrar imagen de portada actual en Discord';

  @override
  String get enable_mpv => 'Activar shaders / scripts de mpv';

  @override
  String get mpv_info => 'Soporta scripts .js en mpv/scripts/';

  @override
  String get mpv_redownload => 'Redescargar archivos de configuración mpv';

  @override
  String get mpv_redownload_info =>
      '¡Reemplaza archivos de configuración antiguos con nuevos!';

  @override
  String get mpv_download =>
      '¡Se requieren archivos de configuración MPV!\n¿Descargar ahora?';

  @override
  String get custom_buttons => 'Botones personalizados';

  @override
  String get custom_buttons_info =>
      'Ejecutar código lua con botones personalizados';

  @override
  String get custom_buttons_edit => 'Editar botones personalizados';

  @override
  String get custom_buttons_add => 'Agregar botón personalizado';

  @override
  String get custom_buttons_added => '¡Botón personalizado agregado!';

  @override
  String get custom_buttons_delete => 'Eliminar botón personalizado';

  @override
  String get custom_buttons_text => 'Texto del botón';

  @override
  String get custom_buttons_text_req => 'Texto del botón requerido';

  @override
  String get custom_buttons_js_code => 'Código lua';

  @override
  String get custom_buttons_js_code_req => 'Código lua requerido';

  @override
  String get custom_buttons_js_code_long => 'Código lua (en pulsación larga)';

  @override
  String get custom_buttons_startup => 'Código lua (al inicio)';

  @override
  String get custom_buttons_add_warning =>
      'Este botón ejecuta el código Lua a continuación en el reproductor de video, que puede acceder a sus archivos y ejecutar programas. Agréguelo solo si confía en el origen de este enlace.';

  @override
  String n_days(Object n) {
    return '$n días';
  }

  @override
  String get decoder => 'Decodificador';

  @override
  String get decoder_info =>
      'Decodificación de hardware, formato de píxeles, debanding';

  @override
  String get enable_gpu_next => 'Activar gpu-next (solo Android)';

  @override
  String get enable_gpu_next_info => 'Un nuevo motor de renderizado de video';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Usar formato de píxeles YUV420P';

  @override
  String get use_yuv420p_info =>
      'Puede solucionar pantallas negras en algunos códecs de video, también puede mejorar el rendimiento a costa de la calidad';

  @override
  String get audio_preferred_languages => 'Idiomas preferidos';

  @override
  String get audio_preferred_languages_info =>
      'Idioma(s) de audio para seleccionar por defecto en un video con múltiples flujos de audio, códigos de idioma de 2/3 letras (ej: es, en, de). Múltiples valores pueden estar delimitados por coma.';

  @override
  String get enable_audio_pitch_correction =>
      'Activar corrección de tono de audio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Evita que el audio se vuelva agudo a velocidades más rápidas y grave a velocidades más lentas';

  @override
  String get audio_channels => 'Canales de audio';

  @override
  String get volume_boost_cap => 'Límite de amplificación de volumen';

  @override
  String get internal_player => 'Reproductor interno';

  @override
  String get internal_player_info => 'Progreso, controles, orientación';

  @override
  String get subtitle_delay_text => 'Retraso de subtítulos';

  @override
  String get subtitle_delay => 'Retraso (ms)';

  @override
  String get subtitle_speed => 'Velocidad';

  @override
  String get tracks => 'Pistas';

  @override
  String get playback_speed => 'Velocidad de reproducción';

  @override
  String get shaders => 'Shaders';

  @override
  String get video_fit => 'Ajuste';

  @override
  String get calendar => 'Calendario';

  @override
  String get calendar_no_data => 'No hay datos aún.';

  @override
  String get calendar_info =>
      'El calendario solo puede predecir la próxima carga de capítulo basándose en las cargas anteriores. ¡Algunos datos pueden no ser 100% precisos!';

  @override
  String in_n_day(Object days) {
    return 'en $days día';
  }

  @override
  String in_n_days(Object days) {
    return 'en $days días';
  }

  @override
  String get clear_library => 'Limpiar biblioteca';

  @override
  String get clear_library_desc =>
      'Elige borrar todas las entradas de manga, anime y/o novela';

  @override
  String get clear_library_input =>
      'Escribe \'manga\', \'anime\' y/o \'novel\' (separados por coma) para eliminar todas las entradas relacionadas';

  @override
  String get watch_order => 'Orden de visualización';

  @override
  String get watch_order_role_current => 'Actual';

  @override
  String get watch_order_role_previous => 'Anterior';

  @override
  String get watch_order_role_next => 'Siguiente';

  @override
  String get watch_order_source_release_order => 'Orden de liberación';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name por $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Colección oficial Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt colección: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Estaciones para $title';
  }

  @override
  String get watch_order_select_source => 'Fuente de la orden';

  @override
  String watch_order_season(int number) {
    return 'Temporada $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Episodio $number';
  }

  @override
  String get sequels => 'Secuelas';

  @override
  String get recommendations_similarity => 'Similaridad:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Clasificación $rating';
  }

  @override
  String get local_folder_structure => 'Estructura de una carpeta local';

  @override
  String get local_folder => 'Carpetas locales';

  @override
  String get add_local_folder => 'Agregar carpeta local';

  @override
  String get rescan_local_folder =>
      'Reescanear todas las carpetas locales ahora';

  @override
  String get default_download_destination =>
      'Destino de descarga predeterminado';

  @override
  String get ask_download_destination => 'Preguntar destino de descarga';

  @override
  String get ask_download_destination_desc =>
      'Elegir una carpeta local cada vez que comience una descarga.';

  @override
  String get select_download_destination => 'Seleccionar destino de descarga';

  @override
  String get clear_local_library => 'Limpiar biblioteca local';

  @override
  String get clear_local_library_desc =>
      'Eliminar carpetas locales y archivos de la biblioteca.';

  @override
  String get clear_local_library_msg =>
      'Esto eliminará las entradas de carpetas y archivos locales de tu biblioteca. No borrará los archivos del disco.';

  @override
  String get custom => 'Personalizado';

  @override
  String get no_local_folder_available_for_downloads =>
      'No hay carpetas locales disponibles para descargas';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Error al crear CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Error al leer imagen de portada: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Error al leer metadatos: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Error al guardar capítulo/episodio en la biblioteca: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Error al leer portada del capítulo: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Error al leer portada del archivo: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Error al obtener biblioteca local: $error';
  }

  @override
  String get export_metadata => 'Exportar metadatos';

  @override
  String get exported => 'Exportado';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Error al exportar metadatos: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count capítulo(s) no se pudieron numerar automáticamente y pueden estar desordenados o faltar en el lector.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'No se pudo iniciar el servidor Webview de resolución de Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Token de $tracker expirado';
  }

  @override
  String get video_list_empty => 'La lista de vídeos está vacía';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'No se pudo abrir $url';
  }

  @override
  String get text_size => 'Tamaño del texto:';

  @override
  String get text_align => 'Alineación del texto';

  @override
  String get line_height => 'Altura de línea';

  @override
  String get show_scroll_percentage => 'Mostrar porcentaje de desplazamiento';

  @override
  String get remove_extra_paragraph_spacing =>
      'Eliminar espaciado extra de párrafos';

  @override
  String select_label_color(Object label) {
    return 'Seleccionar color de $label';
  }

  @override
  String get default_user_agent => 'Agente de usuario predeterminado';

  @override
  String get forceLandscapeMode => 'Forzar modo horizontal';

  @override
  String get forceLandscapeModeSubtitle =>
      'Fuerza el reproductor a usar la orientación horizontal.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Proveedor DNS';

  @override
  String get tracked => 'Rastreado';

  @override
  String get auth_unlock_msg =>
      'Autentifícate para desbloquear NodeLane Comics';

  @override
  String get app_locked => 'NodeLane Comics está bloqueado';

  @override
  String get auth_to_continue => 'Autentifícate para continuar';

  @override
  String get authenticating => 'Autenticando...';

  @override
  String get lock => 'Bloquear';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get security => 'Seguridad';

  @override
  String get auth_to_change_security_setting =>
      'Autentifícate para cambiar la configuración de seguridad';

  @override
  String get app_lock => 'Bloqueo de aplicación';

  @override
  String get require_biometric_or_device_credential =>
      'Se requiere autenticación biométrica o credenciales del dispositivo para abrir la aplicación';

  @override
  String get biometric_or_device_credential_not_available =>
      'La autenticación biométrica no está disponible en este dispositivo';

  @override
  String get app_lock_description =>
      'Cuando el bloqueo de aplicación está habilitado, se te pedirá que te autentiques\ncada vez que abras la aplicación o regreses desde el fondo.';

  @override
  String get checking_device_authentication =>
      'Comprobando la autenticación del dispositivo...';

  @override
  String get device_authentication_incomplete =>
      'La autenticación no se completó. Su configuración no ha cambiado.';

  @override
  String get keep_screen_on => 'Mantener pantalla encendida';

  @override
  String get webtoon_side_padding => 'Relleno lateral de Webtoon';

  @override
  String get show_page_gaps => 'Mostrar espacios entre páginas';

  @override
  String get invert_colors => 'Invertir colores';

  @override
  String get grayscale => 'Escala de grises';

  @override
  String get brightness => 'Brillo';

  @override
  String get contrast => 'Contraste';

  @override
  String get saturation => 'Saturación';

  @override
  String get navigation_layout => 'Diseño de navegación';

  @override
  String get nav_layout_default => 'Predeterminado';

  @override
  String get nav_layout_l_shaped => 'Forma de L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Borde';

  @override
  String get nav_layout_right_and_left => 'Derecha e izquierda';

  @override
  String get nav_layout_disabled => 'Deshabilitado';

  @override
  String get color_enhancements => 'Mejoras de color';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Promedio por título';

  @override
  String get completion_rate => 'Tasa de finalización';

  @override
  String get watching_time => 'Tiempo dedicado (Anime)';

  @override
  String get reading_time => 'Tiempo dedicado (Manga)';

  @override
  String average_chapters_per_title(Object title) {
    return 'Promedio de capítulos por $title';
  }

  @override
  String get read_percentage => 'Porcentaje de lectura';

  @override
  String get entries => 'Entradas';

  @override
  String get android_proxy_server_mihon => 'Servidor Proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Descargue y configure el servidor proxy necesario para usar las extensiones de Mihon.';

  @override
  String get mihon_proxy_server => 'Servidor proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Descarga el paquete del servidor proxy antes de usar extensiones Mihon. El paquete incluye JRE y el archivo JAR del servidor.';

  @override
  String get extension_server_intro_ios =>
      'Descarga el archivo JAR del servidor proxy antes de usar extensiones Mihon. iOS solo necesita el archivo JAR del servidor.';

  @override
  String get checking_files => 'Comprobando archivos';

  @override
  String get files_installed => 'Archivos instalados';

  @override
  String get files_missing => 'Archivos faltantes';

  @override
  String get update_files => 'Actualizar archivos';

  @override
  String get up_to_date => 'Actualizado';

  @override
  String get choose_location => 'Elegir ubicación';

  @override
  String get import_existing_jar => 'Importar JAR existente';

  @override
  String get detect_files_in_selected_folder =>
      'Detectar archivos en la carpeta seleccionada';

  @override
  String get preparing_download => 'Preparando descarga...';

  @override
  String get app_install_location => 'Ubicación de instalación de la app';

  @override
  String get install_location => 'Ubicación de instalación';

  @override
  String get jre_executable => 'Ejecutable JRE';

  @override
  String get extension_server_jar => 'JAR de servidor de extensiones';

  @override
  String get installed_version => 'Versión instalada';

  @override
  String get latest_version => 'Última versión';

  @override
  String get m_extension_server_description =>
      'Usa M-Extension-Server cuando necesites un proxy de dispositivo Android separado. Configura la dirección del proxy aquí y descarga el APK de GitHub.';

  @override
  String get set_proxy_address => 'Establecer dirección proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'No hay una versión más reciente del servidor proxy disponible.';

  @override
  String get could_not_check_proxy_server_updates =>
      'No se pudo comprobar si hay actualizaciones del servidor proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'No hay paquete de servidor de extensiones disponible para esta plataforma.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Error al descargar el paquete ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'El paquete descargado no contiene los archivos esperados.';

  @override
  String get extension_server_files_ready =>
      'Archivos del servidor de extensiones listos.';

  @override
  String get ios_extension_server_import_hint =>
      'En iOS el servidor se instala dentro del sandbox de la app. Usa \"Importar JAR existente\" para traer un archivo descargado.';

  @override
  String get select_extension_server_folder =>
      'Seleccionar carpeta del servidor de extensiones';

  @override
  String get selected_folder_does_not_exist =>
      'La carpeta seleccionada no existe.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'No se encontraron archivos en la carpeta seleccionada.';

  @override
  String get extension_server_files_linked =>
      'Archivos del servidor vinculados.';

  @override
  String get select_extension_server_jar =>
      'Seleccionar JAR del servidor de extensiones';

  @override
  String get selected_file_could_not_be_accessed =>
      'No se pudo acceder al archivo seleccionado.';

  @override
  String get extension_server_jar_imported =>
      'Archivo JAR importado con éxito.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'No se pudo abrir la página de M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP del servidor (ej: 10.0.0.5 o https://example.com)';

  @override
  String get not_configured => 'No configurado';

  @override
  String get zero_interpreter => 'Intérprete Zero';

  @override
  String get zero_interpreter_description =>
      'Controlar el servidor del intérprete Zero de forma automática o manual.';

  @override
  String get start_server_on_launch => 'Iniciar servidor al arrancar';

  @override
  String get runtime_status => 'Estado de ejecución';

  @override
  String get running => 'En ejecución';

  @override
  String get stopped => 'Detenido';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Detener';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Texto a voz';

  @override
  String get tts_speed => 'Velocidad';

  @override
  String get tts_pitch => 'Tono';

  @override
  String get tts_language => 'Idioma';

  @override
  String get tts_voice => 'Voz';

  @override
  String get tts_stop => 'Detener';

  @override
  String get tts_play => 'Reproducir';

  @override
  String get tts_pause => 'Pausa';

  @override
  String get tts_previous => 'Párrafo anterior';

  @override
  String get tts_next => 'Siguiente párrafo';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Párrafo $current de $total';
  }

  @override
  String get tts_settings => 'Configuración de TTS';

  @override
  String get tts_default => 'Predeterminado';

  @override
  String get webtoon_disable_zoom_out => 'Desactivar zoom out de Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Doble toque para zoom en Webtoon';

  @override
  String get navigate_to_pan => 'Navegar hacia el desplazamiento';

  @override
  String get navigate_to_pan_subtitle =>
      'Mover la imagen ampliada antes de cambiar de página';

  @override
  String get split_wide_pages => 'Dividir páginas dobles';

  @override
  String get dual_page_invert => 'Invertir mitad de páginas cortadas';

  @override
  String get dual_page_rotate_to_fit => 'Rotar para ajustar';

  @override
  String get dual_page_rotate_to_fit_invert => 'Invertir dirección de rotación';

  @override
  String get double_page_single_first_page => 'Primera página individual';

  @override
  String get double_page_single_first_page_subtitle =>
      'Mostrar la primera página sola en el modo de doble página';

  @override
  String get double_page_auto => 'Doble página automática';

  @override
  String get double_page_auto_subtitle =>
      'Cambiar automáticamente al modo de doble página en horizontal';

  @override
  String get landscape_zoom => 'Zoom automático en horizontal';

  @override
  String get zoom_start_position => 'Posición inicial del zoom';

  @override
  String get zoom_start_left => 'Izquierda';

  @override
  String get zoom_start_right => 'Derecha';

  @override
  String get zoom_start_center => 'Centro';

  @override
  String get automatic_background => 'Fondo automático';

  @override
  String get tapping_inversion => 'Inversión de toque';

  @override
  String get tapping_inversion_none => 'Ninguno';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertical';

  @override
  String get tapping_inversion_both => 'Ambos';

  @override
  String get flash_on_page_change => 'Destello al cambiar de página';

  @override
  String get flash_on_page_change_subtitle => 'Asistente anti-retención AMOLED';

  @override
  String get flash_color => 'Color del destello';

  @override
  String get flash_color_black => 'Negro';

  @override
  String get flash_color_white => 'Blanco';

  @override
  String get flash_color_white_black => 'Blanco y Negro';

  @override
  String get flash_interval_label => 'Intervalo de destello';

  @override
  String flash_interval_value(String n) {
    return '$n páginas';
  }

  @override
  String flash_interval(String n) {
    return 'Intervalo de destello: $n páginas';
  }

  @override
  String get flash_duration_label => 'Duración del destello';

  @override
  String flash_duration_value(String n) {
    return '$n ms';
  }

  @override
  String flash_duration(String n) {
    return 'Duración del destello: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Mostrar superposición de navegación al inicio';

  @override
  String get reader_hide_threshold => 'Límite para ocultar barra del lector';

  @override
  String get reader_hide_threshold_highest => 'El más alto (5 px)';

  @override
  String get reader_hide_threshold_high => 'Alto (13 px)';

  @override
  String get reader_hide_threshold_low => 'Bajo (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'El más bajo (47 px)';

  @override
  String get error_no_pages_available => 'Error: no hay páginas disponibles';

  @override
  String get app_ui_scale => 'Escala de interfaz';

  @override
  String get app_ui_scale_subtitle =>
      'Haga que la interfaz sea más grande o más pequeña para adaptarse a su pantalla y distancia de visualización.';

  @override
  String get allow_concurrent_downloads => 'Permitir descargas concurrentes';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Descargar de diferentes fuentes al mismo tiempo. Una sola fuente aún descarga un capítulo a la vez para que no se sobrecargue. Apague para descargar uno a la vez en todas partes.';

  @override
  String get download_delay => 'Retraso de descarga';

  @override
  String get download_delay_subtitle =>
      'Desactivado. Agregue una espera con variación aleatoria entre capítulos para ser más suave con las fuentes.';

  @override
  String get save_search => 'Guardar búsqueda';

  @override
  String get saved_searches => 'Búsquedas guardadas';

  @override
  String get enter_search_to_save_first =>
      'Ingrese una búsqueda para guardar primero';

  @override
  String get no_saved_searches =>
      'Aún no hay búsquedas guardadas para esta fuente.\nEjecute una búsqueda y luego elija \"Guardar búsqueda\".';

  @override
  String get source => 'Fuente';

  @override
  String get something_went_wrong => 'Algo salió mal';

  @override
  String get startup_failed => 'NodeLane Comics no pudo completar el inicio';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fuentes sin resultados',
      one: '1 fuente sin resultados',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => '¿Cómo importar esto?';

  @override
  String get import_mode_message =>
      'Elige si deseas fusionar esta copia de seguridad en tu biblioteca actual o reemplazar toda tu biblioteca con ella.';

  @override
  String get import_mode_keep_existing => 'Combinar';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Añade nuevas series y actualiza las coincidentes. Nada de tu biblioteca actual será eliminado.';

  @override
  String get import_mode_replace => 'Reemplazar';

  @override
  String get import_mode_replace_subtitle =>
      'Elimina toda tu biblioteca actual y la reemplaza con esta copia de seguridad.';

  @override
  String get replace_summary_title => 'Listo para reemplazar tu biblioteca';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Esto eliminará toda tu biblioteca actual ($currentCount series) y la reemplazará con $backupCount series de esta copia. Solo se puede deshacer restaurando un estado anterior.';
  }

  @override
  String get replace_summary_confirm => 'Reemplazar';

  @override
  String replace_result_message(Object count) {
    return 'Se reemplazó tu biblioteca con $count series de esta copia de seguridad.';
  }

  @override
  String get category_conflict_title => 'Categorías existentes encontradas';

  @override
  String get category_conflict_message =>
      'La copia contiene categorías que ya existen en tu biblioteca. Mantener para incluir las series en la categoría existente, o eliminar para dejarlas sin categoría.';

  @override
  String get category_conflict_keep =>
      'Mantener — fusionar en categoría existente';

  @override
  String get category_conflict_delete =>
      'Eliminar — dejar series sin categoría';

  @override
  String get source_conflict_title => 'Fuentes no encontradas';

  @override
  String get source_conflict_message =>
      'Estas fuentes de la copia no coinciden con ninguna extensión instalada. Conserva el nombre original o migra a una extensión instalada para permitir actualizaciones.';

  @override
  String get source_conflict_keep =>
      'Mantener nombre original (sin fuente activa)';

  @override
  String get import_summary_title => 'Listo para importar';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries nuevas series, $updatedSeries series existentes actualizadas y $newChapters nuevos capítulos añadidos. Nada de tu biblioteca actual será eliminado.';
  }

  @override
  String get import_summary_confirm => 'Importar';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Importadas $newSeries nuevas series, actualizadas $updatedSeries existentes, añadidos $newChapters nuevos capítulos.';
  }

  @override
  String get roll_back => 'Revertir cambios';

  @override
  String get roll_back_confirm_message =>
      'Esto restaura tu biblioteca a la instantánea de seguridad tomada justo antes de este cambio, deshaciendo todo lo realizado.';

  @override
  String get roll_back_done => 'Revertido a la instantánea previa al cambio.';

  @override
  String get restoring_backup => 'Restaurando tu biblioteca…';

  @override
  String get roll_back_last_change => 'Revertir último cambio';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Instantánea del $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count cambios recientes disponibles para revertir';
  }

  @override
  String get delete_source_title => 'Eliminar fuente y sus mangas';

  @override
  String get delete_source_subtitle =>
      'Elige una fuente y elimina todos sus mangas de tu biblioteca, junto con sus capítulos, descargas, historial y seguimiento.';

  @override
  String get delete_source_pick_title => 'Elige una fuente para eliminar';

  @override
  String get delete_source_empty =>
      'No se encontraron fuentes en tu biblioteca.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '¿Eliminar $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Esto eliminará permanentemente $mangaCount mangas, $chapterCount capítulos, $historyCount entradas de historial y $updateCount de actualizaciones. Se conservan los enlaces de seguimiento. No se puede deshacer salvo revirtiendo.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Eliminar también la extensión instalada';

  @override
  String get delete_source_keep_history => 'Conservar historial de lectura';

  @override
  String get delete_source_keep_downloads => 'Conservar registros de descargas';

  @override
  String get delete_source_button => 'Eliminar';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Se eliminaron $mangaCount mangas de $sourceName.';
  }

  @override
  String get merge_manga_title => 'Combinar mangas duplicados';

  @override
  String get merge_manga_subtitle =>
      'Busca mangas con títulos idénticos bajo la misma fuente y los combina en uno solo, sin borrar nada que quieras conservar.';

  @override
  String get merge_manga_none_found => 'No se encontraron mangas duplicados.';

  @override
  String get merge_manga_pick_title => 'Posibles mangas duplicados';

  @override
  String get merge_manga_choose_primary_title =>
      '¿En cuál deben combinarse los demás?';

  @override
  String get merge_manga_choose_primary_message =>
      'Los capítulos, historial y seguimiento de las otras entradas se combinarán en la que elijas — nada se elimina.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos',
      one: '1 capítulo',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Combinar';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Se combinaron $count mangas duplicados en $mangaName.';
  }

  @override
  String get merge_preview_title => 'Confirmar combinación';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters capítulos encontrados en las otras entradas. $duplicateChapters son duplicados y se descartarán (manteniendo la copia con progreso); $keptChapters se añadirán. $duplicateTracks enlace(s) de seguimiento duplicados también se descartarán.';
  }

  @override
  String get memory_overlay => 'Mostrar uso de memoria';

  @override
  String get memory_overlay_subtitle =>
      'Lectura en vivo del consumo de memoria de la app. Para medir en el dispositivo en lugar de adivinar: obsérvelo al desplazarse por la biblioteca o leer un capítulo.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Informes de errores';

  @override
  String get error_reports_subtitle =>
      'Errores detectados por la app y forma de notificarlos';

  @override
  String get error_reports_empty =>
      'Todo funciona correctamente. Los errores detectados se guardan aquí para que puedas informarlos.';

  @override
  String get error_reports_likely_cause => 'Causa probable';

  @override
  String get error_reports_report => 'Informar en GitHub';

  @override
  String get error_reports_banner => 'NodeLane Comics encontró un error';

  @override
  String get error_reports_banner_action => 'Ver';

  @override
  String get error_reports_copy => 'Copiar';

  @override
  String get error_reports_copied => 'Copiado al portapapeles';

  @override
  String get error_reports_clear => 'Limpiar';

  @override
  String get error_reports_extension_failure =>
      'Esto proviene de una extensión, no de NodeLane Comics. Las extensiones son desarrolladas y mantenidas por quienes administran el repositorio desde el que instaló esta fuente, por lo que la solución debe realizarse allí. El nombre de la fuente y lo que estaba abriendo son detalles útiles para proporcionarles.';

  @override
  String get error_reports_already_reported => 'Ya reportado';

  @override
  String get error_reports_expected_failure =>
      'Esto suele deberse a la fuente o a la red más que a la app: un enlace expirado, un servidor caído o una desconexión. Solo vale la pena reportarlo si sigue sucediendo en una fuente que funciona en otros lugares.';

  @override
  String get share_unavailable_copied =>
      'La función de compartir no está disponible en esta plataforma, por lo que se copió al portapapeles.';

  @override
  String get onboarding_title => 'Bienvenido a NodeLane Comics';

  @override
  String get onboarding_libraries_body =>
      'Elige lo que lees y ves. Lo que no elijas quedará fuera de la barra de navegación; podrás cambiarlo más tarde en Apariencia.';

  @override
  String get onboarding_nav_title => 'Tus bibliotecas';

  @override
  String get onboarding_nav_body =>
      'Mantén una pestaña para cada una, o únelas en una sola pestaña Biblioteca donde podrás alternar.';

  @override
  String get onboarding_nav_split => 'Una pestaña por tipo';

  @override
  String get onboarding_nav_merged => 'Una pestaña Biblioteca';

  @override
  String get onboarding_nav_inside =>
      'Al pulsar Biblioteca se cambian las pestañas por estas';

  @override
  String get onboarding_next => 'Siguiente';

  @override
  String get onboarding_restore => 'Restaurar una copia de seguridad';

  @override
  String get onboarding_or_local => 'O utiliza archivos que ya tienes';

  @override
  String get onboarding_local_folder => 'Añadir una carpeta';

  @override
  String onboarding_local_existing(Object count) {
    return '$count carpetas ya configuradas';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime y novelas son compatibles. Cada título irá a la biblioteca correcta según su contenido.';

  @override
  String get onboarding_local_scanning => 'Escaneando la carpeta';

  @override
  String onboarding_local_found(Object count) {
    return '$count títulos encontrados';
  }

  @override
  String get onboarding_local_remove => 'Eliminar esa carpeta';

  @override
  String get onboarding_local_in_downloads =>
      'Esa es la carpeta de descargas de la app. Añadirla crea una segunda copia local de una biblioteca que la app ya gestiona.';

  @override
  String get onboarding_local_empty =>
      'No se encontró nada. Elige la carpeta que contiene tus carpetas de manga, no un manga individual.';

  @override
  String get onboarding_repo_failed =>
      'No se pudo leer ese repositorio. Comprueba la dirección y tu conexión.';

  @override
  String get onboarding_repo_title => 'Añadir una fuente';

  @override
  String get onboarding_body =>
      'NodeLane Comics no incluye fuentes propias. Añade un repositorio para que sus extensiones estén disponibles para instalar y explorar.';

  @override
  String get onboarding_add => 'Añadir repositorio';

  @override
  String get onboarding_skip => 'Omitir por ahora';

  @override
  String get onboarding_continue => 'Continuar';

  @override
  String get onboarding_later =>
      'Puedes añadir uno más tarde en Ajustes > Explorar.';

  @override
  String get onboarding_replay => 'Mostrar pantalla de bienvenida';

  @override
  String get onboarding_replay_subtitle =>
      'Vuelve a abrir la pantalla de bienvenida inicial.';

  @override
  String get missing_source_check_title => 'Comprobar fuentes faltantes';

  @override
  String get missing_source_check_subtitle =>
      'Encuentra entradas cuya extensión no está instalada: restaurar una copia puede dejar entradas apuntando a una fuente no instalada en este dispositivo.';

  @override
  String get missing_source_check_none_found =>
      'La fuente de cada entrada de la biblioteca está instalada.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltan $count fuentes',
      one: 'Falta 1 fuente',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'No hay fuentes de $itemType instaladas.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Agregue un repositorio en Explorar e instale una extensión correspondiente.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fuentes',
      one: '1 fuente',
    );
    return 'Tiene $_temp0 para esto, pero solo se buscan las fijadas.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Fije una fuente o desactive \"Solo incluir fuentes fijadas\" en los ajustes de Explorar.';

  @override
  String get global_search_all_nsfw =>
      'Todas sus fuentes para esto están marcadas como NSFW y están ocultas.';

  @override
  String get global_search_all_nsfw_hint =>
      'Active las fuentes NSFW en los ajustes de Explorar para buscarlas.';

  @override
  String get missing_source_check_result_message =>
      'Estas entradas apuntan a una fuente no instalada en este dispositivo. Toca una para migrarla a una fuente instalada, instala la extensión correspondiente o usa \"Eliminar fuente y sus mangas\".';

  @override
  String get related_titles => 'Relacionados';

  @override
  String get related_none =>
      'No se encontraron títulos relacionados para esta obra.';

  @override
  String get relation_adaptation => 'Adaptación';

  @override
  String get relation_sequel => 'Secuela';

  @override
  String get relation_prequel => 'Precuela';

  @override
  String get relation_parent => 'Historia principal';

  @override
  String get relation_side_story => 'Historia paralela';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Versión alternativa';

  @override
  String get auto_library_update => 'Actualizaciones automáticas de biblioteca';

  @override
  String get auto_library_update_subtitle =>
      'Comprobar nuevos capítulos para cada entrada de su biblioteca al iniciar la app.';

  @override
  String get auto_library_update_never => 'Nunca';

  @override
  String get auto_library_update_12_hours => 'Cada 12 horas';

  @override
  String get auto_library_update_daily => 'Diariamente';

  @override
  String get auto_library_update_2_days => 'Cada 2 días';

  @override
  String get auto_library_update_weekly => 'Semanalmente';

  @override
  String get auto_library_update_wifi_only => 'Solo con Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Omitir la actualización programada cuando use datos móviles.';

  @override
  String get padding => 'Espaciado';

  @override
  String get page_mode => 'Modo de página';

  @override
  String get single_page => 'Página única';

  @override
  String get double_page => 'Doble página';

  @override
  String get speed => 'Velocidad';

  @override
  String get theme_dark => 'Oscuro';

  @override
  String get theme_light => 'Claro';

  @override
  String get theme_black => 'Negro';

  @override
  String get theme_sepia => 'Sepia';

  @override
  String get decrease => 'Disminuir';

  @override
  String get increase => 'Aumentar';

  @override
  String get chapter_swipe_actions => 'Acciones al deslizar capítulo';

  @override
  String get chapter_swipe_start => 'Deslizar a la derecha';

  @override
  String get chapter_swipe_end => 'Deslizar a la izquierda';

  @override
  String get chapter_swipe_toggle_bookmark => 'Alternar marcador';

  @override
  String get chapter_swipe_toggle_read => 'Marcar leído/no leído';

  @override
  String get chapter_swipe_download => 'Descargar';

  @override
  String get chapter_swipe_disabled => 'Desactivado';

  @override
  String get update_errors => 'Errores de actualización';

  @override
  String get no_update_errors => 'No hay errores de actualización';

  @override
  String get clear_all => 'Borrar todo';

  @override
  String get dismiss => 'Descartar';

  @override
  String get previous_episode => 'Episodio anterior';

  @override
  String get clear_logs => 'Borrar registros';

  @override
  String get bold => 'Negrita';

  @override
  String get italic => 'Cursiva';

  @override
  String get color_yellow => 'Amarillo';

  @override
  String get color_cyan => 'Cian';

  @override
  String get color_green => 'Verde';

  @override
  String get color_orange => 'Naranja';

  @override
  String get continue_watching => 'Continuar mirando';

  @override
  String get search_your_anime => 'Busca tu anime';

  @override
  String get category => 'Categoría';

  @override
  String get hidden_categories => 'Categorías ocultas';

  @override
  String get new_category => 'Nueva categoría';

  @override
  String get local => 'Locales';

  @override
  String get tv_home_rows => 'Filas';

  @override
  String get genre_rows => 'Filas de género';

  @override
  String get share_backup_file =>
      'Compartir archivo de copia de seguridad NodeLane Comics';

  @override
  String get close => 'Cerrar';

  @override
  String get migrate_source => 'Migrar fuente';

  @override
  String get cloudflare_bypass_proxy => 'Proxy de derivación de Cloudflare';

  @override
  String get custom_doh_url => 'DoH personalizado URL';

  @override
  String get custom_doh_url_helper =>
      'Debe ser un punto final https DoH (JSON)';

  @override
  String get anime_only_tv_layout => 'Diseño de TV solo de anime';

  @override
  String get anime_only_beta => 'Solo anime (beta)';

  @override
  String get tv_home_beta => 'TV en casa (beta)';

  @override
  String get tv_player_beta => 'Reproductor de TV (beta)';

  @override
  String get network_settings => 'Red';

  @override
  String get reader_page_layout => 'Diseño de página';

  @override
  String get reader_continuous_options => 'Lectura continua';

  @override
  String get reader_default_mode_hint =>
      'El modo de lectura predeterminado se aplica a títulos sin un modo individual establecido durante la lectura.';

  @override
  String get extension_service => 'Servicio de extensión';

  @override
  String get extension_service_description =>
      'Gestionar el tiempo de ejecución de la extensión y la dirección de proxy.';

  @override
  String get proxy_address => 'Dirección de proxy';

  @override
  String get checking_runtime_status => 'Comprobando el estado…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + retraso aleatorio';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos',
      one: '1 capítulo',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Agregar descargas de la lista de capítulos de un título.';

  @override
  String get download_queue_order_hint =>
      'Arrastre los controladores para reordenar';

  @override
  String get download_queue_empty => 'No hay descargas en cola';

  @override
  String get download_queue_actions => 'Acciones de descarga';

  @override
  String get download_queue_cancel_chapter =>
      'Cancelar la descarga de este capítulo';

  @override
  String get download_queue_cancel_series =>
      'Cancelar todas las descargas de este título';

  @override
  String get download_queue_start => 'Iniciar descargas';

  @override
  String get download_queue_retry => 'Reintentar descargas';

  @override
  String get download_queue_active => 'Descargando';

  @override
  String get download_queue_waiting => 'Esperando descargar';

  @override
  String get download_queue_failed => 'Descarga fallida';

  @override
  String get cf_proxy_helper =>
      'Punto final FlareSolverr/Byparr. Déjelo vacío para desactivarlo.';

  @override
  String get mobile_navigation_description =>
      'Arrastre para reordenar. Manga, anime y novelas comparten la pestaña Biblioteca. El primer elemento visible se abre en el momento del lanzamiento. Explorar y más permanecen visibles; Aparecen pestañas adicionales en Más.';

  @override
  String get text_align_justify => 'Justificar';

  @override
  String get novel_session_modes_hint =>
      'Configure el modo de lectura y páginas simples o dobles mientras lee un título.';

  @override
  String get tts_languages_failed =>
      'No se pudieron cargar idiomas desde el motor de voz.';

  @override
  String get tts_languages_empty =>
      'El motor de voz no devolvió ningún idioma. Su selección guardada se conserva.';

  @override
  String get tts_language_unavailable =>
      'Este idioma guardado no está en la lista actual del dispositivo.';

  @override
  String get tts_apply_failed =>
      'No se pudo aplicar esta configuración al motor de voz. Puedes volver a intentarlo.';

  @override
  String get player_controls => 'Controles';

  @override
  String get audio_channel_auto => 'Automático';

  @override
  String get audio_channel_auto_safe => 'Automático (seguro)';

  @override
  String get audio_channel_mono => 'Monocromo';

  @override
  String get audio_channel_stereo => 'Estéreo';

  @override
  String get audio_channel_reverse_stereo => 'Estéreo inverso';

  @override
  String get mpv_bundled_config_hint =>
      'Restaurar la configuración, scripts y sombreadores incluidos con la aplicación. Se sobrescribirán los archivos con el mismo nombre.';

  @override
  String get mpv_restore_bundled => 'Restaurar la configuración incluida';

  @override
  String get mpv_restore_confirm =>
      '¿Restaurar la configuración MPV incluida? Se sobrescribirán la configuración, los scripts y los sombreadores existentes con los mismos nombres. Se conservarán otros archivos.';

  @override
  String get player_operation_incomplete =>
      'La operación no pudo completarse. Verifique el acceso al archivo e inténtelo nuevamente.';

  @override
  String get custom_buttons_empty_hint =>
      'Añadir un botón de reproductor con una etiqueta y una acción de prensa.';

  @override
  String get custom_button_primary => 'Botón predeterminado';

  @override
  String get show_password => 'Mostrar contraseña';

  @override
  String get hide_password => 'Ocultar contraseña';

  @override
  String get tracking_accounts_empty =>
      'Conecte un servicio en la configuración de seguimiento para gestionar sus entradas.';

  @override
  String get tracking_entries_empty =>
      'No hay entradas rastreadas para este tipo de medio. Agregue seguimiento desde la página de detalles de un título.';

  @override
  String get change_tracking_match => 'Cambiar título coincidente';

  @override
  String get remove_tracking => 'Eliminar seguimiento';

  @override
  String remove_tracking_confirm(String title) {
    return '¿Eliminar el enlace de seguimiento para “$title”? Se mantendrá la entrada en el servicio de seguimiento.';
  }

  @override
  String get tracking_refresh_required =>
      'No se pudo confirmar el estado de seguimiento. Actualice antes de realizar otro cambio.';

  @override
  String get tracking_entry_unlinked =>
      'Este registro no está vinculado a un título local, por lo que no se puede editar aquí.';

  @override
  String get backup_selection_shared =>
      'Los cambios realizados en estas selecciones se guardan inmediatamente y también se aplican a las copias de seguridad automáticas.';

  @override
  String get library_snapshot_history =>
      'Restaurar una instantánea de la biblioteca';

  @override
  String get library_snapshot_empty =>
      'No hay instantáneas de seguridad disponibles.';

  @override
  String get library_snapshot_restore_message =>
      'Los datos actuales serán reemplazados por esta instantánea. Los cambios realizados desde entonces se perderán. Las descargas eliminadas no se pueden restaurar. Las instantáneas de seguridad disponibles se borrarán después del éxito.';

  @override
  String get library_maintenance_working => 'Actualizando biblioteca…';

  @override
  String get library_safety_snapshot_note =>
      'Se guardará una instantánea de seguridad antes de esta operación. No incluye archivos descargados.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Entradas de biblioteca: $mangaCount. Capítulos: $chapterCount. Entradas del historial: $historyCount. Actualizaciones: $updateCount.\n\nElija qué conservar a continuación.';
  }

  @override
  String get library_delete_pick_message =>
      'Elija una fuente para revisar su contenido y opciones de eliminación.';

  @override
  String get mobile_categories_hint =>
      'Arrastre para reordenar. Abra una categoría para cambiarle el nombre o cambiar su visibilidad y actualizaciones.';

  @override
  String get mobile_category_visible => 'Mostrar en la biblioteca';

  @override
  String get mobile_category_hidden => 'Oculto de la biblioteca';

  @override
  String get mobile_category_updates =>
      'Incluir en las actualizaciones de la biblioteca';

  @override
  String get statistics_watched => 'Observado';

  @override
  String get calendar_month => 'Mes';

  @override
  String get calendar_two_weeks => '2 semanas';

  @override
  String get calendar_week => 'Semana';

  @override
  String get calendar_show_all_dates => 'Mostrar todas las fechas';

  @override
  String get update_check_no_result =>
      'No se encontró ninguna actualización instalable. Puedes volver a intentarlo más tarde.';

  @override
  String get release_notes => 'Notas de versión';

  @override
  String get no_release_notes => 'No se proporcionan notas de la versión.';

  @override
  String get downloading_update => 'Descargando actualización…';

  @override
  String get preparing_installation => 'Preparando la instalación…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Elija qué leer. Puedes cambiar esto más tarde.';

  @override
  String get onboarding_content_title => 'Comenzar a leer';

  @override
  String get onboarding_mobile_sources_body =>
      'Elija una forma de comenzar o agregue contenido más tarde.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Paso $step de $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'Resultados para “$query”';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fuentes',
      one: '1 fuente',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Busque el título de destino.';

  @override
  String get migration_original_item => 'Artículo actual';

  @override
  String get migration_target_item => 'Elemento seleccionado';

  @override
  String get migration_partial_failure =>
      'La operación no terminó. Es posible que se hayan guardado algunos cambios. Consulta este artículo en tu biblioteca antes de volver a intentarlo.';

  @override
  String get migration_no_categories =>
      'Sin categorías. Puede agregar este artículo sin una categoría.';

  @override
  String get mass_migration_select_source => 'Elija la fuente actual';

  @override
  String get mass_migration_select_all => 'Seleccionar todo';

  @override
  String get mass_migration_deselect_all => 'Deseleccionar todo';

  @override
  String get mass_migration_needs_review => 'Revisar migraciones incompletas';

  @override
  String get bookshelf_actions => 'Acciones de estantería';

  @override
  String get bookshelf_ignore_filters => 'Ignorar filtros al buscar';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Buscar todas las obras de esta categoría, incluidas aquellas ocultas por filtros.';

  @override
  String get bookshelf_stop_update =>
      'Detener la actualización de la biblioteca';

  @override
  String bookshelf_selected_count(int count) {
    return '$count obras seleccionadas';
  }

  @override
  String get bookshelf_remove_library => 'Quitar de la estantería';

  @override
  String get bookshelf_remove_library_hint =>
      'Elimina favoritos. Las importaciones locales también pierden su biblioteca y sus registros de lectura.';

  @override
  String get bookshelf_remove_downloads => 'Eliminar archivos descargados';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Elimina archivos descargados manteniendo la información del trabajo.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'También elimina archivos importados locales seleccionados y elimina sus registros de biblioteca. Estos archivos no se pueden recuperar aquí.';

  @override
  String get bookshelf_remove_incomplete =>
      'La operación no terminó. Es posible que algunas obras o archivos hayan sido procesados. Cierre este cuadro de diálogo y revise su estantería y descargas antes de continuar.';

  @override
  String get bookshelf_processing => 'Procesamiento…';

  @override
  String get bookshelf_mark_read => 'Marcar leído';

  @override
  String get bookshelf_mark_unread => 'Marcar como no leído';

  @override
  String get bookshelf_select_all => 'Seleccionar todo';

  @override
  String get bookshelf_invert_selection => 'Invertir selección';

  @override
  String get bookshelf_settings => 'Configuración de estantería';

  @override
  String get bookshelf_settings_live =>
      'Los cambios de filtrado, clasificación y visualización entran en vigor inmediatamente.';

  @override
  String get bookshelf_filter_any => 'Cualquiera';

  @override
  String get bookshelf_filter_include => 'Incluir';

  @override
  String get bookshelf_filter_exclude => 'Excluir';

  @override
  String get bookshelf_all_sources => 'Todas las fuentes';

  @override
  String bookshelf_sources_selected(int count) {
    return '$count fuentes seleccionadas';
  }

  @override
  String get bookshelf_sort_ascending => 'Ascendente';

  @override
  String get bookshelf_sort_descending => 'Descendente';

  @override
  String get bookshelf_layout => 'Diseño de estantería';

  @override
  String get bookshelf_sources_hint =>
      'Seleccione ninguna para mostrar todas las fuentes. Los cambios se aplican cuando tocas Filtrar.';

  @override
  String get bookshelf_choose_files => 'Elegir archivos';

  @override
  String get bookshelf_import_wait =>
      'Elija un archivo en el selector y espere a que finalice la importación.';

  @override
  String get bookshelf_import_incomplete =>
      'La importación no finalizó. Es posible que algunos archivos ya estén en su estantería. Cierre este cuadro de diálogo y compruébelo antes de volver a importar.';

  @override
  String get bookshelf_categories_replace =>
      'Al guardar se asignan estas categorías a cada obra seleccionada, reemplazando sus categorías anteriores.';

  @override
  String get bookshelf_categories_hint =>
      'Elija una o más categorías, o deje la selección vacía para no asignar ninguna.';

  @override
  String get bookshelf_categories_hidden =>
      'Para este trabajo se mantienen las categorías ocultas existentes.';

  @override
  String get bookshelf_categories_incomplete =>
      'Las categorías no se pudieron guardar por completo. Cierre este cuadro de diálogo y revise la estantería antes de volver a intentarlo.';

  @override
  String get bookshelf_categories_none_visible =>
      'No hay categorías disponibles aquí. Abra la gestión de categorías para revisarlas.';

  @override
  String get bookshelf_manage_categories => 'Gestionar categorías';

  @override
  String get manga_actions => 'Acciones cómicas';

  @override
  String get manga_download_scope => 'Descargar capítulos';

  @override
  String get manga_download_scope_hint =>
      'Elegir capítulos dentro de los filtros actuales. Se omiten los capítulos descargados.';

  @override
  String get manga_download_scope_empty =>
      'Ningún capítulo coincide con los filtros actuales. Cierra este menú y ajusta los filtros de capítulos.';

  @override
  String get manga_action_incomplete =>
      'La acción no terminó. Verifique el estado actual antes de volver a intentarlo.';

  @override
  String get chapter_settings => 'Configuración del capítulo';

  @override
  String get chapter_settings_live =>
      'Los cambios de filtrado y clasificación se aplican inmediatamente.';

  @override
  String get chapter_scanlators_all => 'Mostrar todos los grupos de scanlator';

  @override
  String get chapter_scanlators_hint =>
      'Seleccionar grupos para ocultar sus capítulos. Los cambios se aplican cuando tocas Filtrar.';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count grupos de scanlator ocultos';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count capítulos seleccionados';
  }

  @override
  String get chapter_add_bookmark => 'Marcador';

  @override
  String get chapter_remove_bookmark => 'Quitar marcador';

  @override
  String get chapter_read_following => 'Lea a continuación';

  @override
  String get chapter_delete_records => 'Eliminar registros de capítulos';

  @override
  String get chapter_delete_local_hint =>
      'Elimina los registros del capítulo seleccionado y el progreso de lectura. Se conservan archivos locales originales; Las copias descargadas se limpian.';

  @override
  String get chapter_delete_last_hint =>
      'Estos son todos los capítulos de este cómic. Eliminarlos también elimina el cómic de tu estantería.';

  @override
  String get chapter_action_incomplete =>
      'La acción no terminó. Es posible que algunos cambios ya estén guardados. Cierra y revisa los capítulos y descargas antes de continuar.';

  @override
  String get reader_display_scope =>
      'El modo de lectura y el diseño de página manual se aplican a este cómic. Elija un cambio para volver a la lectura.';

  @override
  String get reader_display_single_only =>
      'La lectura continua horizontal utiliza páginas individuales.';

  @override
  String get reader_display_manual_pages =>
      'Al cambiar el diseño de página se desactiva la doble página automática para todos los cómics.';

  @override
  String get reader_display_crop_scope => 'Se aplica a todos los cómics.';

  @override
  String get reader_chapter_locate => 'Localizar el capítulo actual';

  @override
  String get reader_chapter_search => 'Buscar capítulos o escaneadores';

  @override
  String get reader_chapter_scope =>
      'Utiliza los filtros de capítulo y el orden de clasificación a partir de detalles de cómic. Los marcadores se guardan inmediatamente.';

  @override
  String get reader_chapter_current_hidden =>
      'El capítulo que estás leyendo está fuera de los filtros actuales.';

  @override
  String get reader_chapter_current => 'Leyendo ahora';

  @override
  String get reader_chapter_read => 'Leer';

  @override
  String get reader_chapter_bookmark_failed =>
      'No se pudo confirmar el guardado del marcador. Cierra la lista y comprueba su estado actual.';

  @override
  String get reader_image_actions => 'Acciones de imagen';

  @override
  String get reader_image_original =>
      'Utiliza la página original completa, sin traducción, recorte ni filtros de color del lector.';

  @override
  String get reader_image_save_ios =>
      'Guárdelo en la carpeta Imágenes en la ubicación de almacenamiento de la aplicación actual.';

  @override
  String get reader_image_save_android =>
      'Guárdelo en la carpeta Imágenes/nodelane-comics del dispositivo.';

  @override
  String get reader_image_share => 'Abra la hoja compartida del sistema.';

  @override
  String get reader_image_cover =>
      'Cambiar la portada de este cómic después de la confirmación.';

  @override
  String get reader_image_cover_limit =>
      'Las imágenes de portada deben tener un tamaño inferior a 5 MB. Guardar y compartir siguen estando disponibles.';

  @override
  String get reader_image_action_failed =>
      'La acción no pudo ser confirmada. Cierra este menú y comprueba el resultado antes de volver a intentarlo.';

  @override
  String get reader_settings_book_scope =>
      'Estas configuraciones se aplican únicamente a este cómic.';

  @override
  String get reader_settings_global_scope =>
      'Estas configuraciones se aplican a todos los cómics y se guardan inmediatamente.';

  @override
  String get reader_filters => 'Filtros de imagen';

  @override
  String get reader_filter_scope =>
      'Se aplica a todos los cómics. Cambia la visualización de lectura sin modificar las imágenes originales.';

  @override
  String get reader_auto_scroll_pause =>
      'El desplazamiento se detiene mientras la configuración está abierta.';

  @override
  String get manga_synopsis => 'Sinopsis';

  @override
  String manga_author(String author) {
    return 'Autor: $author';
  }

  @override
  String get manga_continue_reading => 'Continuar leyendo';

  @override
  String get reader_settings_title => 'Configuraciones del lector';

  @override
  String get reader_picker_book_scope => 'Sólo para este cómic';

  @override
  String get reader_picker_global_scope => 'Se aplica a todos los cómics.';

  @override
  String get reader_picker_apply_hint =>
      'Toque para guardar y volver al nivel anterior.';

  @override
  String get reader_scale_fit_screen_hint =>
      'Ajustar toda la página en pantalla';

  @override
  String get reader_scale_stretch_hint => 'Llenar el área de lectura';

  @override
  String get reader_scale_fit_width_hint => 'Ajustar la página al ancho';

  @override
  String get reader_scale_fit_height_hint => 'Ajustar la página a la altura.';

  @override
  String get source_filter_active => 'Aplicado';

  @override
  String get source_filter_apply => 'Aplicar filtros';

  @override
  String get source_filter_scope =>
      'Los filtros se aplican únicamente a este sitio web.';

  @override
  String get source_filter_apply_hint =>
      'Aplique filtros para utilizar sus selecciones.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Géneros',
      'author': 'Autor',
      'artist': 'Artista',
      'title': 'Título',
      'year': 'Año',
      'tags': 'Etiquetas',
      'format': 'Formato',
      'publisher': 'Editor',
      'relevance': 'Relevancia',
      'rating': 'Clasificación',
      'views': 'Vistas',
      'random': 'Aleatorio',
      'all': 'Todos',
      'none': 'Ninguno',
      'action': 'Acción',
      'adventure': 'Aventura',
      'comedy': 'Comedia',
      'drama': 'Drama',
      'fantasy': 'Fantasía',
      'romance': 'Romance',
      'science_fiction': 'Ciencia ficción',
      'slice_of_life': 'Recuentos de la vida',
      'mystery': 'Misterio',
      'horror': 'Terror',
      'psychological': 'Psicológico',
      'historical': 'Histórico',
      'sports': 'Deportes',
      'supernatural': 'Sobrenatural',
      'school_life': 'Vida escolar',
      'tragedy': 'Tragedia',
      'shounen': 'Shounen',
      'shoujo': 'Shoujo',
      'seinen': 'Seinen',
      'josei': 'Josei',
      'isekai': 'Isekai',
      'martial_arts': 'Artes marciales',
      'mecha': 'Mecha',
      'music': 'Música',
      'doujinshi': 'Doujinshi',
      'trending': 'Tendencia',
      'new': 'Nuevo',
      'adult_content': 'Contenido para adultos',
      'only': 'Sólo',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'Más opciones de visualización';

  @override
  String get bookshelf_more_display_hint => 'Insignias, fuentes y categorías';

  @override
  String get bookshelf_download_count => 'Recuento de descargas';

  @override
  String get bookshelf_source_global_hint =>
      'La visibilidad de la fuente utiliza la preferencia de visualización compartida.';

  @override
  String get bookshelf_select_entries => 'Seleccionar obras';

  @override
  String get bookshelf_search_options => 'Opciones de búsqueda';

  @override
  String get bookshelf_empty_hint =>
      'Recopile obras de fuentes o importe archivos locales.';

  @override
  String get bookshelf_no_match_hint =>
      'Pruebe otras palabras clave o ajuste los filtros actuales.';

  @override
  String get bookshelf_clear_query => 'Borrar palabras clave';

  @override
  String get bookshelf_view_selection => 'Ver obras seleccionadas';

  @override
  String get bookshelf_import_formats =>
      'Elija un archivo local para agregarlo a su estantería.';

  @override
  String get bookshelf_import_canceled_hint =>
      'Puede elegir nuevamente después de cancelar el selector de archivos.';

  @override
  String get bookshelf_browse_sources => 'Explorar fuentes';

  @override
  String get bookshelf_empty_title => 'Tu estantería está vacía';

  @override
  String get bookshelf_no_match_title => 'No hay trabajos coincidentes';

  @override
  String get bookshelf_mark_watched => 'Marcos miró';

  @override
  String get bookshelf_mark_unwatched => 'Marcar sin observar';

  @override
  String get nodelane_account => 'NodeLane';

  @override
  String get nodelane_sign_in => 'Iniciar sesión en NodeLane';

  @override
  String get nodelane_account_intro =>
      'Ver su cuenta, suscripción y cuota de traducción';

  @override
  String get nodelane_login_action => 'Continuar iniciando sesión';

  @override
  String get nodelane_login_browser =>
      'Inicie sesión a través del navegador del sistema y luego regrese a la aplicación';

  @override
  String get nodelane_account_id => 'ID de cuenta';

  @override
  String get nodelane_account_init_error =>
      'El almacenamiento de la cuenta no está disponible. Reinicie la aplicación y vuelva a intentarlo.';

  @override
  String get nodelane_account_refresh_error =>
      'No se pudo actualizar la información de la cuenta';

  @override
  String get nodelane_account_auth_error =>
      'Su sesión ha expirado. Iniciar sesión nuevamente';

  @override
  String get nodelane_account_unknown =>
      'La información de suscripción no está disponible';

  @override
  String get nodelane_account_current => 'Suscripción actual';

  @override
  String get nodelane_account_free => 'Cuenta gratuita';

  @override
  String get nodelane_account_no_subscription => 'Ninguna suscripción activa';

  @override
  String get nodelane_account_active => 'Activo';

  @override
  String get nodelane_account_expired => 'Caducado';

  @override
  String get nodelane_account_expiry => 'Válido hasta';

  @override
  String get nodelane_account_renewal => 'Renovación';

  @override
  String get nodelane_renewal_auto => 'Renovación automática';

  @override
  String get nodelane_renewal_manual => 'Renovación manual';

  @override
  String get nodelane_renewal_stopped => 'Renovación automática detenida';

  @override
  String get nodelane_renewal_gift => 'Membresía de regalo';

  @override
  String get nodelane_renewal_attention =>
      'Verifique el estado de su renovación en el sitio web';

  @override
  String get nodelane_next_billing => 'Próxima fecha de facturación';

  @override
  String get nodelane_billing_unavailable =>
      'La información de renovación no está disponible';

  @override
  String get nodelane_manage_account => 'Administrar en el sitio web';

  @override
  String get nodelane_view_plans => 'Ver planes de suscripción';

  @override
  String get nodelane_translation_quota => 'Cuota de traducción';

  @override
  String get nodelane_quota_free => 'Cuota libre';

  @override
  String get nodelane_quota_subscription => 'Cuota de suscripción';

  @override
  String get nodelane_quota_purchase => 'Cuota comprada';

  @override
  String get nodelane_quota_details => 'Ver detalles de cuota';

  @override
  String get nodelane_quota_expanded => 'Detalles de la cuota';

  @override
  String get nodelane_quota_unlimited => 'Ilimitado';

  @override
  String get nodelane_quota_not_subscribed => 'No suscrito';

  @override
  String get nodelane_quota_unknown => 'No disponible';

  @override
  String get nodelane_quota_used => 'Usado';

  @override
  String get nodelane_quota_reserved => 'En curso';

  @override
  String get nodelane_quota_reset => 'Siguiente reinicio';

  @override
  String get nodelane_quota_expiry => 'Próximo vencimiento';

  @override
  String get nodelane_quota_no_expiry => 'Sin fecha de caducidad';

  @override
  String get nodelane_quota_reservation_note =>
      'Las páginas en curso ya se deducen de la cuota disponible';

  @override
  String nodelane_quota_available(int count) {
    return '$count páginas restantes';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count páginas';
  }

  @override
  String get nodelane_sign_out => 'Cerrar sesión';

  @override
  String get nodelane_sign_out_confirm =>
      'Al cerrar sesión se detiene la traducción oficial en este dispositivo. Se conservan su biblioteca y su progreso de lectura.';

  @override
  String get settings_search_hint => 'Configuración de búsqueda';

  @override
  String get settings_frequent => 'Usado frecuentemente';

  @override
  String get settings_reading_translation => 'Lectura y traducción';

  @override
  String get settings_app_preferences => 'Preferencias de la aplicación';

  @override
  String get settings_data_management => 'Datos y gestión';

  @override
  String get settings_more_tools => 'Más herramientas';

  @override
  String get settings_more_tools_hint =>
      'Categorías, estadísticas y calendario';

  @override
  String get settings_appearance_interface => 'Apariencia e interfaz';

  @override
  String get settings_security_privacy => 'Seguridad y privacidad';

  @override
  String get settings_source_preferences => 'Configuraciones de fuente';

  @override
  String get settings_about_help => 'Acerca de y ayuda';

  @override
  String get settings_storage_backup => 'Almacenamiento y copia de seguridad';

  @override
  String settings_pending_downloads(int count) {
    return '$count pendiente';
  }

  @override
  String get settings_translation_language => 'Idioma de traducción';

  @override
  String get settings_translation_scope =>
      'Utilizado en el lector y en la traducción de páginas web.';

  @override
  String get settings_immediate_choice =>
      'Los cambios se aplican inmediatamente';

  @override
  String get settings_translation_init_error =>
      'Las configuraciones de traducción no están disponibles. Reinicie la aplicación y vuelva a intentarlo.';

  @override
  String get settings_local_cache => 'Caché local';

  @override
  String get settings_chapter_cache => 'Caché de capítulos y episodios';

  @override
  String get settings_cover_cache => 'Caché de portada';

  @override
  String get settings_translation_cache => 'Caché de imágenes traducidas';

  @override
  String get settings_translation_cache_hint =>
      'Mantenga registros de traducción y recupere imágenes traducidas nuevamente cuando sea necesario';

  @override
  String get settings_cache_clear => 'Borrar';

  @override
  String get settings_translation_cache_done =>
      'Se borró la caché de imágenes traducidas; registros de traducción mantenidos';

  @override
  String settings_cache_confirmation(String name) {
    return '¿Borrar $name? El contenido almacenado en caché se puede recuperar nuevamente. Se conservarán las entradas de la biblioteca.';
  }

  @override
  String get settings_advanced_options => 'Opciones avanzadas';

  @override
  String get settings_manga_reader => 'Lector de manga';

  @override
  String get settings_novel_reader => 'Lector de novelas';

  @override
  String get settings_downloads => 'Descargar configuraciones';

  @override
  String get onboarding_welcome => 'Bienvenido a';

  @override
  String get onboarding_reading_content => 'Lectura de contenido';

  @override
  String get onboarding_choose_one => 'Elija al menos uno';

  @override
  String get onboarding_restore_hint =>
      'Restaura tu biblioteca desde una copia de seguridad';

  @override
  String get onboarding_browse_hint =>
      'Buscar títulos en sitios web compatibles';

  @override
  String get onboarding_import_folder => 'Importar una carpeta local';

  @override
  String get onboarding_import_folder_hint =>
      'Lee manga, novelas y anime en tu dispositivo';

  @override
  String get onboarding_third_party => 'Agregar un repositorio de terceros';

  @override
  String get onboarding_third_party_hint =>
      'Utilice una dirección de repositorio que ya tenga';

  @override
  String get onboarding_repository_hint =>
      'Introduzca la dirección proporcionada por el repositorio.';

  @override
  String get onboarding_repository_address => 'Dirección';

  @override
  String get onboarding_repository_address_hint =>
      'Ingrese la dirección del repositorio';

  @override
  String get onboarding_add_repository => 'Agregar repositorio';

  @override
  String get onboarding_start => 'Comience';

  @override
  String get onboarding_open_library => 'Biblioteca abierta';

  @override
  String get onboarding_view_imports => 'Ver contenido importado';

  @override
  String get onboarding_view_folders => 'Ver carpetas';

  @override
  String get notice_backup_created => 'Copia de seguridad creada';

  @override
  String get notice_backup_ready =>
      'Guarde o comparta el archivo de copia de seguridad.';

  @override
  String get notice_backup_restored => 'Copia de seguridad restaurada';

  @override
  String get notice_backup_unsupported =>
      'Este formato de copia de seguridad no es compatible.';

  @override
  String get notice_verification_required =>
      'Se requiere verificación del sitio web';

  @override
  String get notice_verification_hint =>
      'Completar la verificación para continuar navegando.';

  @override
  String get notice_verify => 'Verificar sitio web';

  @override
  String get notice_action_incomplete =>
      'La acción no terminó. Comprueba su resultado antes de volver a intentarlo.';

  @override
  String get notice_library_updating => 'Actualización de biblioteca';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'Títulos $current / $total marcados';
  }

  @override
  String get notice_library_failed =>
      'Algunos títulos no se pudieron actualizar';

  @override
  String get notice_import_completed => 'Importación completada';

  @override
  String get notice_operation_incomplete => 'Acción incompleta';

  @override
  String get subtitle_service => 'Servicio de subtítulos en línea';

  @override
  String get subtitle_service_mode => 'Fuente de subtítulos';

  @override
  String get subtitle_service_disabled =>
      'Desactivado · borrar credenciales guardadas';

  @override
  String get subtitle_personal_key => 'Mi clave Wyzie';

  @override
  String get subtitle_custom_service => 'Mi servicio de subtítulos';

  @override
  String get subtitle_key => 'Wyzie API Clave';

  @override
  String get subtitle_key_hint =>
      'Ingrese su propia clave Wyzie. Permanece en este dispositivo y no se incluye en las copias de seguridad de la aplicación.';

  @override
  String get subtitle_get_key => 'Obtener una clave personal';

  @override
  String get subtitle_service_address => 'Búsqueda de subtítulos URL';

  @override
  String get subtitle_service_token => 'Token de acceso al servicio (opcional)';

  @override
  String get subtitle_custom_hint =>
      'Utilice la búsqueda HTTPS completa URL de un servicio Wyzie-compatible, incluida su ruta (por ejemplo, /search). Ingrese un token de acceso solo si su servicio lo requiere.';

  @override
  String get subtitle_service_off_hint =>
      'La búsqueda de subtítulos en línea está desactivada. Los subtítulos incrustados, proporcionados por la fuente y locales siguen estando disponibles.';

  @override
  String get subtitle_setup_required =>
      'Elija un servicio de subtítulos antes de realizar la búsqueda.';

  @override
  String get subtitle_invalid_key => 'Introduzca una clave sin espacios.';

  @override
  String get subtitle_invalid_address =>
      'Utilice un HTTPS URL completo sin consulta, fragmento o credenciales integradas.';

  @override
  String get subtitle_invalid_token =>
      'El token de acceso no puede contener espacios.';

  @override
  String get subtitle_storage_failed =>
      'No se pudo leer ni guardar la configuración de subtítulos. Por favor inténtalo de nuevo.';

  @override
  String get subtitle_auth_failed =>
      'El servicio de subtítulos rechazó el acceso. Verifique su clave o token de servicio.';

  @override
  String get subtitle_quota_exhausted =>
      'La cuota del servicio de subtítulos está agotada. Consulta tu cuenta con ese servicio.';

  @override
  String get subtitle_network_failed =>
      'No se pudo acceder al servicio de subtítulos. Por favor inténtalo de nuevo.';

  @override
  String get subtitle_response_invalid =>
      'El servicio de subtítulos devolvió una respuesta o un archivo no compatible.';

  @override
  String get detail_loading_chapters => 'Cargando capítulos…';

  @override
  String get reader_opening_chapter => 'Capítulo inicial';

  @override
  String get reader_open_chapter => 'Abrir capítulo';

  @override
  String get reader_loading_pages => 'Obteniendo imágenes de capítulos...';

  @override
  String get reader_loading_pages_hint =>
      'La lectura comenzará automáticamente cuando esté lista.';

  @override
  String get reader_loading_failed => 'No se pudo cargar este capítulo';

  @override
  String get reader_loading_retry_hint =>
      'Verifique su conexión e inténtelo nuevamente.';

  @override
  String get reader_no_pages =>
      'No se encontraron imágenes para este capítulo.';

  @override
  String get reader_loading_previous => 'Cargando capítulo anterior…';

  @override
  String get reader_previous_failed => 'No se pudo cargar el capítulo anterior';

  @override
  String get reader_reached_start => 'Has llegado al primer capítulo.';

  @override
  String get reader_loading_next => 'Cargando el siguiente capítulo…';

  @override
  String get reader_next_failed => 'No se pudo cargar el siguiente capítulo';

  @override
  String get reader_image_loading => 'Cargando imagen…';

  @override
  String get reader_image_failure_hint =>
      'Puedes seguir leyendo otras páginas.';

  @override
  String get comic_paged => 'Página por página';

  @override
  String get comic_scroll => 'Desplácese hacia abajo';

  @override
  String get comic_book_scope =>
      'Se aplica sólo a este libro · los cambios se guardan inmediatamente';

  @override
  String get comic_defaults_title => 'Valores predeterminados y hábitos';

  @override
  String get comic_defaults_hint =>
      'Los valores predeterminados se aplican a los campos que no ha personalizado para un libro.';

  @override
  String get comic_habits_hint =>
      'Estos hábitos se aplican a todos los cómics.';

  @override
  String get comic_turn => 'Pase a la página siguiente';

  @override
  String get comic_left => 'Izquierda';

  @override
  String get comic_right => 'Derecha';

  @override
  String get comic_up => 'Arriba';

  @override
  String get comic_fit => 'Ajuste de página';

  @override
  String get comic_fit_contain => 'Página completa';

  @override
  String get comic_fit_width => 'Ancho de ajuste';

  @override
  String get comic_fit_height => 'Altura de ajuste';

  @override
  String get comic_layout => 'Diseño de página';

  @override
  String get comic_auto => 'Automático';

  @override
  String get comic_layout_hint =>
      'Auto muestra una extensión cuando hay suficiente ancho.';

  @override
  String get comic_width => 'Ancho del contenido';

  @override
  String get comic_full => 'Completo';

  @override
  String get comic_comfortable => 'Cómodo';

  @override
  String get comic_narrow => 'Estrecho';

  @override
  String get comic_gap => 'Espaciado de página';

  @override
  String get comic_no_gap => 'Sin costuras';

  @override
  String get comic_small_gap => 'Pequeño';

  @override
  String get comic_image_title => 'Imagen de ajuste fino';

  @override
  String get comic_image_hint =>
      'El recorte y el tono afectan sólo a este libro.';

  @override
  String get comic_wide => 'Páginas anchas';

  @override
  String get comic_intact => 'Mantener entero';

  @override
  String get comic_split => 'Dividir';

  @override
  String get comic_rotate => 'Girar';

  @override
  String get comic_wide_hint =>
      'La división sigue la dirección de paso de página. Se aplica a la lectura de una sola página.';

  @override
  String get comic_cover => 'Una portada por capítulo';

  @override
  String get comic_effects_reset => 'Restablecer ajustes de imagen';

  @override
  String get comic_book_reset =>
      'Restaurar los valores predeterminados del libro';

  @override
  String get comic_book_reset_hint =>
      'Borra la configuración de lectura personalizada de este libro. La traducción no ha cambiado.';

  @override
  String get comic_canvas => 'Antecedentes del lector';

  @override
  String get comic_system => 'Sistema';

  @override
  String get comic_black => 'Negro';

  @override
  String get comic_gray => 'Gris';

  @override
  String get comic_paper => 'Papel';

  @override
  String get comic_tap => 'Toque para pasar páginas';

  @override
  String get comic_tap_hint =>
      'Toque los bordes para moverse; toque el centro para mostrar los controles.';

  @override
  String get comic_scroll_start => 'Iniciar desplazamiento automático';

  @override
  String get comic_scroll_pause => 'Pausar el desplazamiento automático';

  @override
  String get comic_scroll_speed => 'Velocidad de desplazamiento';

  @override
  String get comic_scroll_hint =>
      'Comienza cuando se cierra este panel. Se detiene cuando la aplicación sale del primer plano.';

  @override
  String get comic_save_failed =>
      'No se pudo guardar. Por favor inténtalo de nuevo.';

  @override
  String get comic_reading => 'Lectura';

  @override
  String get comic_chapter_habits_hint =>
      'Los hábitos de lista de capítulos se aplican a todos los libros.';

  @override
  String get browser_title => 'Navegador';

  @override
  String get translation_image_display => 'Visualización de imágenes';

  @override
  String get translation_display_hint =>
      'Mostrar primero las traducciones existentes. Conserve el original cuando no haya traducción disponible.';

  @override
  String get translation_sign_in_required =>
      'Inicie sesión para habilitar la traducción';

  @override
  String get translation_sign_in_hint =>
      'Después de iniciar sesión, cambie a imágenes traducidas para traducir automáticamente.';

  @override
  String get translation_automatic => 'Traducción automática';

  @override
  String get translation_original_hint =>
      'Mostrando originales. Cambie a imágenes traducidas para traducir automáticamente.';

  @override
  String get translation_window_hint =>
      'Procesar imágenes actuales y futuras sólo mientras se muestran las traducciones.';

  @override
  String get translation_channel => 'Canal de traducción';

  @override
  String get translation_no_images =>
      'Aún no se han encontrado imágenes traducibles en esta página';

  @override
  String get translation_waiting_image => 'Esperando la imagen actual';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues imágenes necesitan atención',
      one: ' · 1 imagen necesita atención',
      zero: '',
    );
    return 'Imágenes $complete / $total completadas$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'Toque y mantenga presionada una imagen para realizar más acciones, incluida traducirla nuevamente.';

  @override
  String get translation_title => 'Traducción manga';

  @override
  String get translation_system_sign_in =>
      'Inicie sesión utilizando el navegador de su sistema';

  @override
  String get translation_target_language => 'Idioma de destino';

  @override
  String get translation_clear_cache => 'Borrar caché de imágenes traducidas';

  @override
  String get translation_cache_hint =>
      'Mantenga registros de traducción y recupere resultados nuevamente cuando sea necesario.';

  @override
  String get translation_saved_read_failed =>
      'No se pudo cargar la traducción guardada';

  @override
  String get translation_read_failed => 'No se pudo cargar la imagen traducida';

  @override
  String get operation_retry =>
      'La acción no terminó. Por favor inténtalo de nuevo.';

  @override
  String get translation_original => 'Originales';

  @override
  String get translation_translated => 'Traducido';

  @override
  String get translation_regenerate_image => 'Traducir esta imagen nuevamente';

  @override
  String get translation_read_image => 'Recargar imagen traducida';

  @override
  String get translation_image_actions => 'Más acciones de imagen';

  @override
  String get translation_processing => 'Procesamiento';

  @override
  String get translation_reading => 'Cargando imagen traducida';

  @override
  String get translation_waiting => 'Esperando traducción';

  @override
  String get translation_preparing => 'Preparación de la traducción';

  @override
  String get translation_uploading => 'Cargando original';

  @override
  String get translation_running => 'Traducir';

  @override
  String get translation_uncertain => 'El estado necesita verificación';

  @override
  String get translation_failed => 'La traducción falló';

  @override
  String get translation_verify => 'Verificar';

  @override
  String get translation_reread => 'Recargar';

  @override
  String get browser_back => 'Volver';

  @override
  String get browser_translation => 'Traducción de páginas web';

  @override
  String get browser_new_tab_action => 'Abrir nueva pestaña';

  @override
  String get browser_current_tab => 'Actual';

  @override
  String get browser_close_tab => 'Cerrar pestaña';

  @override
  String get browser_new_tab => 'Nueva pestaña';

  @override
  String get browser_page => 'Página web';

  @override
  String get browser_unopened => 'Aún no se ha abierto ninguna página';

  @override
  String get browser_invalid_address => 'Ingrese un URL válido';

  @override
  String get browser_clear_address => 'Borrar URL';

  @override
  String get browser_paste_address => 'Pegar URL';

  @override
  String get browser_open_address => 'Abierto URL';

  @override
  String browser_tab_count(int count) {
    return 'Pestañas · $count';
  }

  @override
  String get browser_load_failed => 'No se pudo abrir esta página';

  @override
  String get browser_load_failed_hint => 'Verifique su conexión y el URL.';

  @override
  String get browser_edit_address => 'Editar URL';

  @override
  String get browser_clear_cookies_confirm =>
      '¿Borrar sesiones de inicio de sesión para todos los sitios web?';

  @override
  String get browser_clear_cookies_hint =>
      'Es posible que los sitios web en todas las pestañas requieran que inicie sesión nuevamente.';

  @override
  String get browser_clear_cookies_action =>
      'Borrar sesiones de inicio de sesión';

  @override
  String get browser_tab_limit =>
      'Puede mantener abiertas hasta 12 pestañas. Cierra uno primero.';

  @override
  String get browser_forward => 'Adelante';

  @override
  String get browser_clear_all_cookies =>
      'Borrar todas las sesiones de inicio de sesión del sitio web';

  @override
  String get browser_clear_failed =>
      'No se pudieron borrar las sesiones. Por favor inténtalo de nuevo.';

  @override
  String get browser_save_failed =>
      'No se pudieron guardar pestañas. Por favor inténtalo de nuevo.';

  @override
  String get browser_tabs_full => '12 pestañas ya están abiertas';

  @override
  String get browser_no_tabs => 'Aún no hay pestañas abiertas';

  @override
  String get browser_close_failed =>
      'No se pudieron guardar pestañas. Toca cerrar nuevamente para volver a intentarlo.';

  @override
  String get source_pinned_websites => 'Sitios web fijados';

  @override
  String get manage => 'Gestionar';

  @override
  String get translation_settings_hint =>
      'Traducción automática, idioma de destino y canal.';

  @override
  String get translation_show_original => 'Toque para mostrar el original';

  @override
  String get translation_show_translated => 'Toque para mostrar la traducción.';

  @override
  String get source_display => 'Pantalla';

  @override
  String get source_cover_title => 'Portada y título';

  @override
  String get source_cover_only => 'Sólo cubierta';

  @override
  String get source_save_search => 'Guardar la búsqueda actual';

  @override
  String get source_saved_searches => 'Búsquedas guardadas';

  @override
  String get source_website_info => 'Información del sitio web';

  @override
  String source_saved_search_title(String title) {
    return '$title · Toque para buscar';
  }

  @override
  String get action_done => 'Hecho';

  @override
  String source_search_keyword(String query) {
    return 'Palabra clave: $query';
  }

  @override
  String get source_no_saved_searches => 'Aún no hay búsquedas guardadas';

  @override
  String get source_save_search_hint =>
      'Busque una palabra clave y luego guárdela desde las acciones del sitio web.';

  @override
  String get source_saved_search_scope =>
      'Las palabras clave se guardan solo para este sitio web.';

  @override
  String get source_search_here => 'Buscar títulos en este sitio web';

  @override
  String get source_filter_results => 'Resultados filtrados';

  @override
  String get source_search_results => 'Resultados de la búsqueda';

  @override
  String get source_return_popular => 'Volver a lo popular';

  @override
  String get source_popular_titles => 'Títulos populares';

  @override
  String get source_no_titles => 'No se encontraron títulos coincidentes';

  @override
  String get source_no_titles_hint =>
      'Cambie sus palabras clave o filtros, o regrese a títulos populares.';

  @override
  String get source_load_more_failed =>
      'No se pudo cargar más. Por favor inténtalo de nuevo.';

  @override
  String get source_load_pull_retry =>
      'No se pudo cargar este sitio web. Tire hacia abajo para volver a intentarlo.';

  @override
  String get source_clear_failed =>
      'No se pudo terminar de borrar. Por favor inténtalo de nuevo.';

  @override
  String get source_uninstall_failed =>
      'No se pudo finalizar la desinstalación. Por favor inténtalo de nuevo.';

  @override
  String get source_details => 'Detalles de la fuente';

  @override
  String get source_repository_website => 'Sitio web del repositorio';

  @override
  String get source_provided_settings =>
      'Configuraciones proporcionadas por la fuente';

  @override
  String get source_advanced_actions => 'Acciones avanzadas';

  @override
  String get source_edit_metadata => 'Editar información de fuente';

  @override
  String get source_clear_cookies => 'Borrar cookies para este sitio web';

  @override
  String get source_clear_cookies_hint =>
      'Es posible que necesite iniciar sesión nuevamente en su próxima visita.';

  @override
  String get source_uninstall => 'Desinstalar fuente';

  @override
  String get source_settings_save_failed =>
      'El guardado no finalizó. Vuelva a abrir la configuración de código fuente para verificar.';

  @override
  String get repository_third_party => 'Repositorios de terceros';

  @override
  String get repository_refresh_failed =>
      'No se pudo actualizar el catálogo. El contenido almacenado en caché se mantiene. Por favor inténtalo de nuevo.';

  @override
  String get repository_show_sources => 'Mostrar fuentes de este repositorio';

  @override
  String get repository_copy_catalog => 'Copiar enlace del catálogo';

  @override
  String get repository_remove => 'Eliminar repositorio';

  @override
  String get repository_remove_hint =>
      'Mantenga las fuentes instaladas y elimine las entradas del catálogo desinstaladas.';

  @override
  String get repository_empty =>
      'Aún no se han agregado repositorios de terceros';

  @override
  String get repository_built_in => 'Catálogo oficial incorporado';

  @override
  String get repository_hidden => 'Oculto';

  @override
  String get repository_refreshing => 'Refrescante…';

  @override
  String get repository_refresh => 'Actualizar catálogo';

  @override
  String get repository_manage_hint =>
      'Administrar desde dónde se descargan las fuentes de terceros.';

  @override
  String get repository_invalid_address => 'Ingrese un HTTP o HTTPS URL válido';

  @override
  String get repository_already_added => 'Este repositorio ya ha sido agregado';

  @override
  String get repository_unrecognized =>
      'No se encontró ningún catálogo compatible. Comprueba el enlace y vuelve a intentarlo.';

  @override
  String get repository_read_failed =>
      'No se pudo leer el catálogo. Por favor inténtalo de nuevo.';

  @override
  String get repository_save_failed =>
      'El guardado no finalizó. Consulte su lista de repositorios.';

  @override
  String get repository_paste_hint =>
      'Pegue un enlace de catálogo de repositorio de terceros';

  @override
  String get repository_address => 'URL';

  @override
  String get repository_paste_link => 'Pegar enlace';

  @override
  String repository_recognized(String type) {
    return '$type · Catálogo reconocido';
  }

  @override
  String get repository_choose_sources_hint =>
      'Después de agregar el repositorio, elija las fuentes que necesita.';

  @override
  String get search_scope => 'Alcance de la búsqueda';

  @override
  String get search_scope_hint => 'Elija los sitios web para buscar';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Buscar sitios web $count',
      one: 'Buscar 1 sitio web',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Encontrar un sitio web';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sitios web seleccionados',
      one: '1 sitio web seleccionado',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Borrar';

  @override
  String get search_deselect_results => 'Deseleccionar sitios web coincidentes';

  @override
  String get search_select_results => 'Seleccionar sitios web coincidentes';

  @override
  String get search_no_websites_hint =>
      'No hay sitios web coincidentes. Pruebe con otro nombre o idioma.';

  @override
  String get search_select_website_hint =>
      'Seleccione al menos un sitio web para buscar.';

  @override
  String get search_start_title => 'Ingrese palabras clave para buscar títulos';

  @override
  String get search_start_hint =>
      'Busque en varios sitios web a la vez y muestre títulos coincidentes.';

  @override
  String get search_empty_scope =>
      'No hay sitios web con capacidad de búsqueda en este ámbito';

  @override
  String get search_empty_scope_hint =>
      'Cambie a todos los sitios web o elija sitios web para buscar.';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Resultados $count',
      one: '1 resultado',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'Buscar títulos';

  @override
  String get search_actions => 'Acciones de búsqueda';

  @override
  String get search_details => 'Detalles de búsqueda';

  @override
  String get search_title_hint => 'Buscar por título';

  @override
  String get search_searching => 'Buscando';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Resultados encontrados $count',
      one: 'Se encontró 1 resultado',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'No hay resultados coincidentes';

  @override
  String get search_failed => 'La búsqueda falló';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count títulos encontrados',
      one: '1 título encontrado',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: '$websites sitios web',
      one: '1 sitio web',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Encontrar títulos';

  @override
  String get search_complete => 'Búsqueda completa';

  @override
  String get search_in_progress => 'Buscando';

  @override
  String get search_finding_related => 'Buscando títulos coincidentes...';

  @override
  String get search_no_results_yet => 'Aún no hay resultados de búsqueda';

  @override
  String get search_no_matching_titles =>
      'No se encontraron títulos coincidentes';

  @override
  String get search_results_appear_hint =>
      'Los resultados aparecerán aquí a medida que se encuentren.';

  @override
  String get search_failed_websites_hint =>
      'Algunos sitios web no pudieron finalizar la búsqueda. Vuelva a intentarlo en los detalles de búsqueda.';

  @override
  String get search_change_keywords_hint =>
      'Pruebe con palabras clave más cortas o busque en más sitios web.';

  @override
  String get search_view_details => 'Ver detalles de búsqueda';

  @override
  String get search_adjust_scope => 'Ajustar el alcance de la búsqueda';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sitios web',
      one: '1 sitio web',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Completado $completed / $total';
  }

  @override
  String get search_retry_website_hint =>
      'Reintentar sitios web fallidos individualmente';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos seleccionados',
      one: '1 elemento seleccionado',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Idiomas de búsqueda';

  @override
  String get source_deselect => 'Deseleccionar';

  @override
  String get source_select => 'Seleccionar fuente';

  @override
  String get source_multilingual => 'Multilingüe';

  @override
  String get source_language_unknown => 'Idioma no especificado';

  @override
  String get source_adult_content =>
      'Contiene contenido para mayores de 18 años';

  @override
  String get source_classification_unknown => 'Clasificación no especificada';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ver toda la información fuente, $count más categorías',
      one: 'Ver toda la información fuente, 1 categoría más',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Cargando sitio web';

  @override
  String get source_unpin => 'Desanclar';

  @override
  String get source_pin => 'Pasador';

  @override
  String get source_open => 'Abrir';

  @override
  String get source_metadata_hint =>
      'La información proviene del catálogo fuente. Las categorías describen el contenido cubierto por el sitio web.';

  @override
  String get source_region => 'Región';

  @override
  String get source_format => 'Formato';

  @override
  String get source_creation => 'Creación';

  @override
  String get source_unspecified => 'No especificado';

  @override
  String get source_pricing => 'Precios';

  @override
  String get source_region_jp => 'cómics japoneses';

  @override
  String get source_region_kr => 'cómics coreanos';

  @override
  String get source_region_cn => 'cómics chinos';

  @override
  String get source_region_hk_tw => 'Cómics de Hong Kong y Taiwán';

  @override
  String get source_region_western => 'Cómics occidentales';

  @override
  String get source_region_other => 'Otras regiones';

  @override
  String get source_format_page => 'Cómics paginados';

  @override
  String get source_format_vertical => 'Cómics verticales';

  @override
  String get source_format_strip => 'Tiras cómicas';

  @override
  String get source_creation_original => 'Originales';

  @override
  String get source_creation_fan => 'El ventilador funciona';

  @override
  String get source_free_watch => 'Gratis para mirar';

  @override
  String get source_free_read => 'Libre para leer';

  @override
  String get source_partial_paid => 'Parcialmente pagado';

  @override
  String get source_paid_watch => 'Visualización paga';

  @override
  String get source_paid_read => 'Lectura pagada';

  @override
  String get source_pricing_unknown => 'Precio no especificado';

  @override
  String get source_language_filter => 'Filtrar por idioma';

  @override
  String get source_language_filter_hint =>
      'Filtrar este catálogo únicamente. Las fuentes instaladas no se ven afectadas.';

  @override
  String get source_all_languages => 'Todos los idiomas';

  @override
  String get action_apply => 'Aplicar';

  @override
  String get source_load_retry =>
      'No se pudo cargar este sitio web. Por favor inténtalo de nuevo.';

  @override
  String get source_catalog_refresh_failed =>
      'No se pudo actualizar el catálogo. Se mantiene el contenido actual. Tire hacia abajo para volver a intentarlo.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Desinstalar fuentes $count?',
      one: '¿Desinstalar 1 fuente?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Desinstale las fuentes seleccionadas y borre sus configuraciones. Mantenga los títulos y descargas de la biblioteca.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Las acciones fallaron para $count fuentes.',
      one: 'La acción falló para 1 fuente.',
    );
    return '$_temp0 Selección mantenida. Por favor inténtalo de nuevo.';
  }

  @override
  String get source_latest_content => 'Contenido más reciente';

  @override
  String get source_actions => 'Acciones fuente';

  @override
  String get source_bulk_manage => 'Gestionar múltiples fuentes';

  @override
  String get source_update_installed => 'Actualizar fuentes instaladas';

  @override
  String get source_no_matching_websites => 'No hay sitios web coincidentes';

  @override
  String get source_no_websites => 'No hay sitios web disponibles';

  @override
  String get source_search_installed_hint =>
      'Buscar títulos en fuentes instaladas';

  @override
  String get source_global_search => 'Búsqueda entre fuentes';

  @override
  String get source_manage_repositories => 'Administrar repositorios';

  @override
  String get source_view_third_party => 'Ver fuentes de terceros';

  @override
  String get source_catalog_load_failed =>
      'No se pudo cargar el catálogo. Tire hacia abajo para volver a intentarlo.';

  @override
  String get source_all_websites => 'Todos los sitios web';

  @override
  String get source_available => 'Disponible para instalar';

  @override
  String get source_third_party => 'Tercero';

  @override
  String get source_name_or_title => 'Nombre o título del sitio web';

  @override
  String get view_all => 'Ver todo';

  @override
  String get search_searching_ellipsis => 'Buscando…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · No probado';
  }

  @override
  String get onboarding_untested => 'No probado';

  @override
  String get source_custom_scope => 'Personalizado';

  @override
  String get source_custom_websites => 'Sitios web seleccionados';

  @override
  String get tv_hidden_library_hint =>
      'Cada título se encuentra en una categoría oculta.\nMantenga presionado OK en \"Todos\" para mostrar uno.';

  @override
  String get tv_no_matching_anime => 'No hay anime que coincida';

  @override
  String tv_no_matching_category(String category) {
    return 'No hay anime coincidente en “$category”';
  }

  @override
  String get tv_filtered_empty_hint =>
      'Ningún anime coincide con los filtros actuales.\nCámbielos desde el botón al lado de buscar.';

  @override
  String get tv_new_episodes => 'Nuevos episodios';

  @override
  String get tv_recently_added => 'Agregado recientemente';

  @override
  String get tv_empty_category_hint =>
      'Aún no hay anime en esta categoría.\nAgregue títulos desde la página de detalles de un título.';

  @override
  String get tv_empty_library => 'Tu biblioteca de anime está vacía';

  @override
  String get tv_empty_library_hint =>
      'Agrega anime desde Explorar para llenar tu hogar';

  @override
  String get tv_browse_anime => 'Explorar anime';

  @override
  String tv_new_count(int count) {
    return '$count nuevo';
  }

  @override
  String tv_category_hidden(String category) {
    return 'Oculté “$category” · mantén presionado OK en “Todos” para mostrar';
  }

  @override
  String get tv_no_hidden_categories => 'Sin categorías ocultas';

  @override
  String get import_torrent_file => 'importar archivo .torrent';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi y más';

  @override
  String get cloudflare_proxy_optional => 'FlareSolverr / Byparr opcional URL';

  @override
  String get tv_home_layout_hint =>
      'Inicio de anime basado en filas (Continuar · Nuevos episodios · categorías) en lugar de la cuadrícula plana';

  @override
  String get tv_hide_libraries_hint =>
      'Ocultar las bibliotecas de manga y novelas (activadas de forma predeterminada en la TV)';

  @override
  String get anime_only_hint =>
      'Ocultar manga y novela en toda la aplicación. Desactiva para mostrar todo.';

  @override
  String get audio_auto_safe => 'Auto-seguro';

  @override
  String get tv_player_hint =>
      'Encendido: reproductor de TV dedicado.  Apagado: reproductor original (escritorio).';

  @override
  String get release_open_failed => 'No se puede abrir la versión';

  @override
  String get tv_replay => 'Repetición';

  @override
  String get tv_no_episodes => 'Aún no hay episodios';

  @override
  String get tracker_continue_series => 'Continuar viendo series';

  @override
  String get tracker_watchlist_series => 'Serie de lista de vigilancia';

  @override
  String get tracker_continue_movies => 'Continuar viendo películas';

  @override
  String get tracker_watchlist_movies => 'Lista de seguimiento de películas';

  @override
  String get tracker_trending_series => 'Serie de tendencias';

  @override
  String get tracker_trending_movies => 'Películas de tendencia';

  @override
  String get tracker_popular_series => 'Serie Popular';

  @override
  String get tracker_popular_movies => 'Películas populares';

  @override
  String get tracker_top_series => 'Serie superior (de todos los tiempos)';

  @override
  String get tracker_top_movies => 'Mejores películas (de todos los tiempos)';

  @override
  String get tracker_airing_series => 'Serie de transmisión';

  @override
  String get tracker_airing_anime => 'Transmitiendo anime';

  @override
  String get tracker_popular_anime => 'Animes populares';

  @override
  String get tracker_upcoming_anime => 'Próximo anime';

  @override
  String get tracker_popular_manga => 'Manga Popular';

  @override
  String get tracker_top_manga => 'Manga superior';

  @override
  String get tracker_top_manhwa => 'Manhwa superior';

  @override
  String get tracker_top_manhua => 'Manhua Superior';

  @override
  String get tracker_latest_anime => 'Último anime';

  @override
  String get tracker_best_anime => 'Anime mejor valorado';

  @override
  String get tracker_latest_manga => 'Manga más reciente';

  @override
  String get tracker_best_manga => 'Manga mejor valorado';

  @override
  String get tracker_trending_anime => 'Anime de tendencia';

  @override
  String get tracker_upcoming_manga => 'Próximo manga';

  @override
  String get tracker_trending_manga => 'Manga de tendencia';

  @override
  String selection_progress(int selected, int total) {
    return '$selected/$total seleccionado';
  }

  @override
  String get source_code_editor => 'Editor de código';

  @override
  String get source_code_execute => 'Ejecutar';

  @override
  String get source_console_logs => 'Registros de la consola';

  @override
  String get source_no_logs => 'Aún no hay registros';

  @override
  String get source_updated_successfully => 'Fuente actualizada exitosamente';

  @override
  String get source_obsolete => 'OBSOLETO';

  @override
  String player_seek_forward_seconds(int seconds) {
    return 'Búsqueda hacia adelante $seconds segundos';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return 'Buscar hacia atrás $seconds segundos';
  }

  @override
  String get player_autoplay_on =>
      'Reproducción automática del siguiente episodio: activado';

  @override
  String get player_autoplay_off =>
      'Reproducción automática del siguiente episodio: desactivada';

  @override
  String get player_no_other_quality => 'Ninguna otra cualidad';

  @override
  String get player_no_subtitles => 'Sin subtítulos';

  @override
  String get player_no_audio_tracks => 'Sin pistas de audio';

  @override
  String get player_seek_forward => 'Buscar hacia adelante';

  @override
  String get player_seek_backward => 'Buscar hacia atrás';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds segundos',
      one: '1 segundo',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'Lorem ipsum dolor sit amet';

  @override
  String get subtitle_style => 'Estilo';

  @override
  String get translation_official_channel => 'NodeLane Oficial';

  @override
  String get translation_auth_required =>
      'Primero inicie sesión en su cuenta de traducción.';

  @override
  String get translation_source_changed =>
      'La imagen original cambió. Por favor recargalo.';

  @override
  String get translation_source_missing =>
      'La imagen original no está disponible actualmente.';

  @override
  String get translation_resource_limit =>
      'Esta imagen excede el límite de procesamiento del dispositivo. Se conserva el original.';

  @override
  String get translation_storage_full =>
      'El almacenamiento de traducción está lleno. Primero borre las imágenes traducidas.';

  @override
  String get translation_invalid_image =>
      'Formato o contenido de imagen no válido.';

  @override
  String get translation_unsupported_image =>
      'La traducción no es compatible con esta imagen. Se conserva el original.';

  @override
  String get translation_invalid_result =>
      'La validación de la imagen traducida falló. Por favor recargalo.';

  @override
  String get translation_result_unavailable =>
      'La imagen traducida no está disponible. Por favor recargalo.';

  @override
  String get translation_result_expired =>
      'La imagen traducida expiró. Por favor tradúcelo de nuevo.';

  @override
  String get translation_analysis_too_large =>
      'Hay demasiado contenido de imagen para analizar. Reduzca el tamaño de la imagen y vuelva a intentarlo.';

  @override
  String get translation_region_limit =>
      'La imagen tiene demasiadas regiones de texto. Divídelo y vuelve a intentarlo.';

  @override
  String get translation_text_limit =>
      'Una región de texto es demasiado larga. Ajusta la imagen y vuelve a intentarlo.';

  @override
  String get translation_unavailable =>
      'Esta traducción ya no está disponible.';

  @override
  String get translation_outcome_unknown =>
      'El resultado necesita verificación. No ha sido reenviado.';

  @override
  String get translation_rate_limited =>
      'Las solicitudes son limitadas. La traducción se reanudará automáticamente.';

  @override
  String get translation_quota_exhausted => 'Cuota de traducción insuficiente.';

  @override
  String get translation_unsupported_language =>
      'El servicio no admite este idioma de destino.';

  @override
  String get translation_upgrade_required =>
      'El protocolo de traducción es incompatible. Actualiza la aplicación.';

  @override
  String get translation_remote_failed =>
      'La traducción de esta página falló. Puedes volver a intentarlo manualmente.';

  @override
  String get translation_bridge_invalid =>
      'La ​​página web cambió. Habilite la traducción nuevamente.';

  @override
  String get translation_connection_failed =>
      'La conexión falló. Por favor inténtalo de nuevo.';

  @override
  String get translation_paused =>
      'Traducción en pausa. Puedes verificar su progreso.';

  @override
  String get translation_preparing_ellipsis => 'Preparando la traducción…';

  @override
  String get translation_checking_original =>
      'Comprobando la imagen original...';

  @override
  String get translation_submitting => 'Presentando…';

  @override
  String get translation_uploading_ellipsis => 'Subiendo original…';

  @override
  String get translation_waiting_ellipsis => 'Esperando traducción…';

  @override
  String get translation_running_ellipsis => 'Traduciendo…';

  @override
  String get translation_verify_result => 'El resultado necesita verificación';

  @override
  String get translation_partial => 'Algunos contenidos han sido traducidos.';

  @override
  String get translation_ready => 'Imagen traducida lista';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Jugar';

  @override
  String get player_quality => 'Calidad';

  @override
  String get player_subtitles => 'Subtítulos';

  @override
  String get player_audio => 'Sonido';

  @override
  String get player_statistics => 'Estadísticas para nerds';

  @override
  String get player_auto => 'Automático';

  @override
  String get source_information => 'Información fuente';

  @override
  String get source_code_page => 'Página';

  @override
  String get source_code_query => 'Consulta';

  @override
  String get repository_invalid_source => 'Fuente no válida - eliminarla';

  @override
  String get player_fit_contain => 'Contener';

  @override
  String get player_fit_cover => 'Cubierta';

  @override
  String get player_fit_fill => 'Llenar';

  @override
  String get player_fit_height => 'Altura';

  @override
  String get player_fit_width => 'Ancho';

  @override
  String get player_fit_scale => 'Escala';

  @override
  String get player_fit_none => 'Ninguno';

  @override
  String get player_shader_clear => 'Desactivado (borrar sombreadores)';

  @override
  String get player_shader_luma => 'Ampliación de Luma';

  @override
  String get player_decoder_auto => 'Automático (hardware)';

  @override
  String get player_decoder_software => 'Software (sin hardware)';

  @override
  String get player_stats_toggle => 'Alternar superposición';

  @override
  String get player_stats_general => 'Generalidades';

  @override
  String get player_stats_frames => 'Sincronizaciones de fotogramas';

  @override
  String get player_stats_cache => 'Caché de entrada';

  @override
  String get player_stats_filters => 'Filtros activos';

  @override
  String get player_stats_log => 'Registro';

  @override
  String get source_mark_pinned => 'Pasador';

  @override
  String translation_image_action(String action) {
    return '$action esta imagen';
  }

  @override
  String get memory_waiting => 'memoria: esperando una muestra';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current pico $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'caché $current / $limit pico $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'elementos $count / $limit vivo $live pico $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count muestras',
      one: '1 muestra',
    );
    return '$percent% completo de $_temp0';
  }

  @override
  String get memory_reset_hint =>
      'actívelo y desactívelo en la configuración para restablecerlo';

  @override
  String get action_hide => 'Ocultar';

  @override
  String discord_get_app(String app) {
    return 'Obtener $app';
  }

  @override
  String get discord_idle => 'Inactivo';

  @override
  String discord_watching_title(String title) {
    return 'Viendo $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'Lectura $title';
  }
}
