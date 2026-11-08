// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get app_update_details_hint =>
      'Ver notas de versão e opções de instalação';

  @override
  String get app_update_download => 'Baixar atualização';

  @override
  String get app_update_download_hint =>
      'Após o download, siga as instruções para instalar a atualização.';

  @override
  String get bookshelf_all => 'Todos';

  @override
  String get bookshelf_search => 'Biblioteca de pesquisa';

  @override
  String get app_update_allow_install =>
      'Permita a instalação do aplicativo nas configurações do sistema, depois retorne e toque em Instalar.';

  @override
  String get app_update_waiting => 'Aguardando o sistema retomar o download…';

  @override
  String get app_update_cancel_download => 'Cancelar download';

  @override
  String get app_update_remove_package => 'Remover pacote baixado';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'Nenhuma configuração correspondente';

  @override
  String get search_empty_hint =>
      'Experimente outra palavra-chave ou limpe a pesquisa para ver tudo.';

  @override
  String get search_clear => 'Limpar pesquisa';

  @override
  String get app_updates => 'Atualizações de aplicativos';

  @override
  String get app_update_auto => 'Verificação no lançamento';

  @override
  String get app_update_view => 'Ver atualização';

  @override
  String get app_update_later => 'Mais tarde';

  @override
  String get app_update_external_hint =>
      'Abre o link de atualização no seu navegador';

  @override
  String get app_update_failed =>
      'Não é possível verificar atualizações. Por favor, tente novamente.';

  @override
  String get app_update_opened => 'Link de atualização aberto';

  @override
  String get app_diagnostics => 'Diagnósticos e registros';

  @override
  String get library => 'Biblioteca';

  @override
  String get updates_search => 'Atualizações de pesquisa';

  @override
  String get updates => 'Atualizações';

  @override
  String get history => 'Histórico';

  @override
  String get browse => 'Procurar';

  @override
  String get more => 'Mais';

  @override
  String get open_random_entry => 'Abrir entrada aleatória';

  @override
  String get import => 'Importar';

  @override
  String get filter => 'Filtro';

  @override
  String get ignore_filters => 'Ignorar filtros';

  @override
  String get downloaded => 'Baixado';

  @override
  String get unread => 'Não lido';

  @override
  String get unwatched => 'Não assistido';

  @override
  String get started => 'Iniciado';

  @override
  String get bookmarked => 'Marcado';

  @override
  String get sort => 'Ordenar';

  @override
  String get alphabetically => 'Alfabeticamente';

  @override
  String get last_read => 'Última leitura';

  @override
  String get last_watched => 'Último assistido';

  @override
  String get last_update_check => 'Última verificação de atualização';

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
          'Você está deletando todos os $count $entryTypePlural deste $mediaType da sua biblioteca.',
      one:
          'Você está deletando o único $entryType deste $mediaType da sua biblioteca.',
    );
    return '$_temp0\nIsso também vai remover todo o $mediaType da sua biblioteca.\n\nObs: Os arquivos em si não serão deletados.';
  }

  @override
  String get chapter => 'capítulo';

  @override
  String get episode => 'episódio';

  @override
  String get unread_count => 'Contagem de não lidos';

  @override
  String get unwatched_count => 'Contagem não assistidos';

  @override
  String get latest_chapter => 'Último capítulo';

  @override
  String get latest_episode => 'Último episódio';

  @override
  String get date_added => 'Data adicionada';

  @override
  String get display => 'Exibir';

  @override
  String get display_mode => 'Modo de exibição';

  @override
  String get compact_grid => 'Grade compacta';

  @override
  String get compression_level => 'Nível de compressão';

  @override
  String compression_info(Object level) {
    return 'Quanto maior a compressão, menos espaço o arquivo de backup ocupa, mas utiliza mais CPU. Padrão: $level';
  }

  @override
  String get comfortable_grid => 'Grade confortável';

  @override
  String get cover_only_grid => 'Grade somente de capas';

  @override
  String get list => 'Lista';

  @override
  String get badges => 'Distintivos';

  @override
  String get downloaded_chapters => 'Capítulos baixados';

  @override
  String get downloaded_episodes => 'Episódios baixados';

  @override
  String get language => 'Idioma';

  @override
  String get local_source => 'Fonte local';

  @override
  String get tabs => 'Abas';

  @override
  String get show_category_tabs => 'Mostrar abas de categoria';

  @override
  String get show_numbers_of_items => 'Mostrar números dos itens';

  @override
  String get other => 'Outro';

  @override
  String get show_continue_reading_buttons =>
      'Mostrar botões de continuar lendo';

  @override
  String get show_continue_watching_buttons =>
      'Mostrar botões para continuar assistindo';

  @override
  String get empty_library => 'Biblioteca vazia';

  @override
  String get search => 'Buscar...';

  @override
  String get no_recent_updates => 'Sem atualizações recentes';

  @override
  String get remove_everything => 'Remover tudo';

  @override
  String get remove_everything_msg =>
      'Tem certeza? Todo histórico será perdido';

  @override
  String get remove_all_update_msg =>
      'Você tem certeza? Toda a atualização será apagada';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Remover';

  @override
  String get remove_history_msg =>
      'Isso removerá a data de leitura deste capítulo. Tem certeza?';

  @override
  String get last_used => 'Último Usado';

  @override
  String get pinned => 'Fixado';

  @override
  String get sources => 'Fontes';

  @override
  String get install => 'Instalar';

  @override
  String get update => 'Atualizar';

  @override
  String get latest => 'Mais recente';

  @override
  String get extensions => 'Extensões';

  @override
  String get migrate => 'Migrar';

  @override
  String get mass_migration_title => 'Migração em massa';

  @override
  String get mass_migration_preview_items => 'Visualizar itens';

  @override
  String get mass_migration_destination_source => 'Fonte de destino';

  @override
  String get mass_migration_no_library_items =>
      'Nenhum item da biblioteca disponível para migração em massa.';

  @override
  String get mass_migration_no_destination_sources =>
      'Nenhuma fonte de destino instalada disponível.';

  @override
  String get mass_migration_installed => 'Instalado';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens prontos para revisão',
      one: '1 item pronto para revisão',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Selecionar fonte de destino';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Buscando correspondências em $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Processando item $current de $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Aguardando 2 segundos antes do próximo item...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Aguardando 2 segundos antes da próxima migração...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Correspondidos até agora: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Sem correspondência: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Revisar correspondências de $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Correspondências encontradas: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Sem correspondências: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Selecionados para migrar: $count';
  }

  @override
  String get mass_migration_finish_review => 'Finalizar revisão';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migrar itens selecionados ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Migrando itens selecionados para $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Nenhum item selecionado para migração.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migrando item $current de $total';
  }

  @override
  String get mass_migration_complete => 'Migração em massa concluída';

  @override
  String get mass_migration_complete_success_message =>
      'Todos os itens selecionados foram processados com sucesso.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migração finalizada com alguns itens que ainda requerem atenção manual.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Processado';

  @override
  String get mass_migration_matched => 'Correspondido';

  @override
  String get mass_migration_migrated => 'Migrado';

  @override
  String get mass_migration_skipped => 'Pulado';

  @override
  String get mass_migration_failed => 'Falhou';

  @override
  String get mass_migration_failed_items => 'Itens com Falha';

  @override
  String get mass_migration_exit => 'Sair da Migração em Massa';

  @override
  String get mass_migration_no_destination_match =>
      'Nenhuma correspondência de destino encontrada';

  @override
  String mass_migration_query(Object query) {
    return 'Consulta: $query';
  }

  @override
  String get mass_migration_skip => 'Pular';

  @override
  String get mass_migration_loading => 'Carregando...';

  @override
  String get mass_migration_choose_another_result => 'Escolher outro resultado';

  @override
  String get mass_migration_source_chapters => 'Capítulos de origem';

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
      other: '$count capítulos de origem',
      one: '1 capítulo de origem',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos de destino',
      one: '1 capítulo de destino',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Nenhum capítulo encontrado.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'E mais $count...';
  }

  @override
  String get mass_migration_unknown_title => 'Título desconhecido';

  @override
  String get mass_migration_unknown_match => 'Correspondência desconhecida';

  @override
  String get mass_migration_unknown_source => 'Fonte desconhecida';

  @override
  String get mass_migration_unknown_chapter => 'Capítulo desconhecido';

  @override
  String get migrate_confirm => 'Migrar para outra fonte';

  @override
  String get clean_database => 'Limpar banco de dados';

  @override
  String cleaned_database(Object x) {
    return 'Banco de dados limpo! $x entradas removidas';
  }

  @override
  String get clean_database_desc =>
      'Isso removerá todos os itens que não foram adicionados à biblioteca!';

  @override
  String get incognito_mode => 'Modo Incógnito';

  @override
  String get incognito_mode_description => 'Pausa o histórico de leitura';

  @override
  String get downloaded_only => 'Apenas baixados';

  @override
  String get downloaded_only_description =>
      'Mostrar apenas entradas baixadas na sua biblioteca';

  @override
  String get download_queue => 'Fila de Download';

  @override
  String get categories => 'Categorias';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get settings => 'Configurações';

  @override
  String get about => 'Sobre';

  @override
  String get help => 'Ajuda';

  @override
  String get no_downloads => 'Sem Downloads';

  @override
  String get edit_categories => 'Editar Categorias';

  @override
  String get edit_categories_description =>
      'Você não tem categorias. Toque no botão de mais para criar uma para organizar sua biblioteca';

  @override
  String get add => 'Adicionar';

  @override
  String get add_category => 'Adicionar Categoria';

  @override
  String get name => 'Nome';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Obrigatório';

  @override
  String get add_category_error_exist =>
      'Uma categoria com este nome já existe!';

  @override
  String get delete_category => 'Deletar Categoria';

  @override
  String delete_category_msg(Object name) {
    return 'Você deseja deletar a categoria $name?';
  }

  @override
  String get rename_category => 'Renomear Categoria';

  @override
  String get general => 'Geral';

  @override
  String get general_subtitle => 'Idioma do aplicativo';

  @override
  String get app_language => 'Idioma do aplicativo';

  @override
  String get default_subtitle_language => 'Idioma padrão das legendas';

  @override
  String get appearance => 'Aparência';

  @override
  String get appearance_subtitle => 'Tema, formato de data e hora';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Modo escuro';

  @override
  String get follow_system_theme => 'Seguir o tema do sistema';

  @override
  String get on => 'Ligado';

  @override
  String get off => 'Desligado';

  @override
  String get pure_black_dark_mode => 'Modo escuro preto puro';

  @override
  String get timestamp => 'Carimbo de data/hora';

  @override
  String get relative_timestamp => 'Carimbo de data/hora relativo';

  @override
  String get relative_timestamp_short => 'Curto (Hoje, Ontem)';

  @override
  String get relative_timestamp_long => 'Longo (Curto+, n dias atrás)';

  @override
  String get date_format => 'Formato de data';

  @override
  String get reader => 'Leitor';

  @override
  String get refresh => 'Atualizar';

  @override
  String get reader_subtitle => 'Modo de leitura, exibição, navegação';

  @override
  String get default_reading_mode => 'Modo de leitura padrão';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Da esquerda para a direita';

  @override
  String get reading_mode_right_to_left => 'Da direita para a esquerda';

  @override
  String get reading_mode_vertical_continuous => 'Vertical contínuo';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Velocidade da animação de duplo toque';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Rápido';

  @override
  String get no_animation => 'Sem animação';

  @override
  String get animate_page_transitions => 'Animar transições de página';

  @override
  String get crop_borders => 'Cortar bordas';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloads_subtitle => 'Configurações de download';

  @override
  String get download_location => 'Localização do download';

  @override
  String get custom_location => 'Localização personalizada';

  @override
  String get only_on_wifi => 'Somente no wifi';

  @override
  String get save_as_cbz_archive => 'Salvar como arquivo CBZ';

  @override
  String get delete_download_after_reading => 'Excluir download após a leitura';

  @override
  String get concurrent_downloads => 'Downloads simultâneos';

  @override
  String get browse_subtitle => 'Fontes, pesquisa global';

  @override
  String get only_include_pinned_sources => 'Incluir apenas fontes fixadas';

  @override
  String get nsfw_sources => 'Fontes NSFW (+18)';

  @override
  String get nsfw_sources_show => 'Mostrar nas listas de fontes e extensões';

  @override
  String get nsfw_sources_info =>
      'Isso não impede que extensões não oficiais ou potencialmente marcadas incorretamente exibam conteúdo NSFW (18+) dentro do aplicativo';

  @override
  String get version => 'Versão';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Verificar atualização';

  @override
  String get logs_on => 'Ativar registro';

  @override
  String get share_app_logs => 'Compartilhar logs do aplicativo';

  @override
  String get no_app_logs => 'Nenhum arquivo log.txt disponível!';

  @override
  String get failed => 'Falhou!';

  @override
  String n_days_ago(Object days) {
    return '$days dias atrás';
  }

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get a_week_ago => 'Uma semana atrás';

  @override
  String get next_week => 'Próxima semana';

  @override
  String get add_to_library => 'Adicionar à biblioteca';

  @override
  String get completed => 'Concluído';

  @override
  String get ongoing => 'Em andamento';

  @override
  String get on_hiatus => 'Em hiato';

  @override
  String get canceled => 'Cancelado';

  @override
  String get publishing_finished => 'Publicação concluída';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get empty_placeholder => 'VAZIO';

  @override
  String get error => 'Erro';

  @override
  String error_with_message(Object error) {
    return 'Erro: $error';
  }

  @override
  String get no_pages_available => 'Erro: nenhuma página disponível';

  @override
  String get set_categories => 'Definir categorias';

  @override
  String get edit => 'Editar';

  @override
  String get in_library => 'Na biblioteca';

  @override
  String get filter_scanlator_groups => 'Filtrar grupos de scanlator';

  @override
  String get reset => 'Redefinir';

  @override
  String get by_source => 'Por fonte';

  @override
  String get by_chapter_number => 'Por número de capítulo';

  @override
  String get by_episode_number => 'Por número do episódio';

  @override
  String get by_upload_date => 'Por data de upload';

  @override
  String get source_title => 'Título da fonte';

  @override
  String get create_extension => 'Criar extensão';

  @override
  String get developer_mode => 'Modo desenvolvedor';

  @override
  String get developer_mode_subtitle =>
      'Mostrar ferramentas de desenvolvedor de extensões (criar extensão, editar código)';

  @override
  String get choose_extension_language => 'Escolher idioma da extensão';

  @override
  String get lang => 'Idioma';

  @override
  String get base_url => 'URL base';

  @override
  String get api_url_optional => 'URL da API (opcional)';

  @override
  String get icon_url => 'URL do ícone';

  @override
  String get source_icon_url => 'URL do ícone da fonte';

  @override
  String get notes => 'Notas';

  @override
  String get extension_name_example => 'ex: meuAnime';

  @override
  String get language_code_example => 'ex: pt';

  @override
  String get base_url_example => 'ex: https://exemplo.com';

  @override
  String get api_url_example => 'ex: https://api.exemplo.com';

  @override
  String get extension_notes_example => 'ex: esta extensão requer login';

  @override
  String get type => 'Tipo';

  @override
  String get target => 'Destino';

  @override
  String get source_type_single => 'única';

  @override
  String get source_type_multi => 'múltipla';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS compilado do LNReader';

  @override
  String get source_created_successfully => 'Fonte criada com sucesso';

  @override
  String get source_already_exists => 'A fonte já existe';

  @override
  String get error_when_creating_source => 'Erro ao criar fonte';

  @override
  String get cookies_deleted => 'Cookies eliminados!';

  @override
  String get delete_all_cookies => 'Eliminar todos os cookies';

  @override
  String get chapter_number => 'Número do capítulo';

  @override
  String get episode_number => 'Número do episódio';

  @override
  String get share => 'Compartilhar';

  @override
  String n_chapters(Object n) {
    return '$n capítulos';
  }

  @override
  String missing_chapters(Object count) {
    return 'Faltam $count capítulos';
  }

  @override
  String get no_description => 'Sem descrição';

  @override
  String get resume => 'Continuar';

  @override
  String get read => 'Ler';

  @override
  String get watch => 'Assistir';

  @override
  String get popular => 'Popular';

  @override
  String get open_in_browser => 'Abrir no navegador';

  @override
  String get clear_cookie => 'Limpar cookie';

  @override
  String get show_page_number => 'Mostrar número da página';

  @override
  String get from_library => 'Da biblioteca';

  @override
  String get downloaded_chapter => 'Capítulo baixado';

  @override
  String page(Object page) {
    return 'Página $page';
  }

  @override
  String get global_search => 'Pesquisa global';

  @override
  String get color_blend_level => 'Nível de mistura de cor';

  @override
  String current(Object char) {
    return 'Atual $char';
  }

  @override
  String finished(Object char) {
    return 'Concluído $char';
  }

  @override
  String next(Object char) {
    return 'Próximo $char';
  }

  @override
  String previous(Object char) {
    return 'Anterior $char';
  }

  @override
  String get no_more_chapter => 'Não há mais capítulos';

  @override
  String get no_result => 'Sem resultados';

  @override
  String get send => 'Enviar';

  @override
  String get delete => 'Deletar';

  @override
  String get start_downloading => 'Começar a baixar agora';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get add_chapters => 'Adicionar Capítulos';

  @override
  String get delete_chapters => 'Deletar Capítulo?';

  @override
  String get default0 => 'Padrão';

  @override
  String get total_chapters => 'Total de Capítulos';

  @override
  String get total_episodes => 'Total de episódios';

  @override
  String get import_local_file => 'Importar arquivo local';

  @override
  String get import_files => 'Arquivos';

  @override
  String get split_epub_chapters => 'Dividir em capítulos';

  @override
  String get split_epub_chapters_description =>
      'Importar cada capítulo EPUB como uma entrada separada';

  @override
  String get nothing_read_recently => 'Nada lido recentemente';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Não iniciado';

  @override
  String get score => 'Pontuação';

  @override
  String get start_date => 'Data de início';

  @override
  String get finish_date => 'Data de conclusão';

  @override
  String get reading => 'Lendo';

  @override
  String get on_hold => 'Em espera';

  @override
  String get dropped => 'Desistido';

  @override
  String get plan_to_read => 'Planejando ler';

  @override
  String get re_reading => 'Relendo';

  @override
  String get chapters => 'Capítulos';

  @override
  String get add_tracker => 'Adicionar rastreador';

  @override
  String get one_tracker => '1 rastreador';

  @override
  String n_tracker(Object n) {
    return '$n rastreadores';
  }

  @override
  String get tracking => 'Rastreando';

  @override
  String get syncing => 'Sincronizar';

  @override
  String get sync_logged => 'Login bem-sucedido';

  @override
  String get syncing_subtitle =>
      'Informe o endereço do seu servidor de sincronização e entre pelo navegador para sincronizar o progresso de leitura entre dispositivos.';

  @override
  String get sync_service => 'Sincronização em servidor próprio';

  @override
  String get last_sync => 'Última sincronização às: ';

  @override
  String get sync_login_browser => 'Entrar com o navegador';

  @override
  String get sync_server => 'Endereço do servidor de sincronização';

  @override
  String get sync_starting => 'Iniciando a sincronização...';

  @override
  String get sync_finished => 'Sincronização concluída';

  @override
  String get sync_failed => 'Falha na sincronização';

  @override
  String get sync_restore_in_progress =>
      'Sincronização ignorada — restauro em curso';

  @override
  String sync_progress_percent(Object percent) {
    return 'Sincronizando… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Sincronizando…';

  @override
  String get sync_button_sync => 'Sincronizar progresso';

  @override
  String get sync_button_upload => 'Apenas enviar';

  @override
  String get sync_button_upload_info =>
      'Esta operação substituirá completamente os dados remotos pelos dados locais!';

  @override
  String get sync_button_download => 'Apenas baixar';

  @override
  String get sync_button_download_info =>
      'Esta operação substituirá completamente os dados locais pelos dados remotos!';

  @override
  String get sync_status_not_configured => 'Não conectado';

  @override
  String get sync_status_checking => 'A verificar ligação...';

  @override
  String get sync_status_connected => 'Conectado';

  @override
  String get sync_status_unauthorized =>
      'Sessão expirada, inicie sessão novamente';

  @override
  String get sync_status_unreachable => 'Servidor inacessível';

  @override
  String get sync_section_general => 'Geral';

  @override
  String get sync_on => 'Ativar sincronização';

  @override
  String get sync_auto => 'Sincronização automática';

  @override
  String get sync_auto_warning =>
      'A sincronização automática é atualmente um recurso experimental!';

  @override
  String get sync_auto_off => 'Desativado';

  @override
  String get sync_auto_5_minutes => 'A cada 5 minutos';

  @override
  String get sync_auto_10_minutes => 'A cada 10 minutos';

  @override
  String get sync_auto_30_minutes => 'A cada 30 minutos';

  @override
  String get sync_auto_1_hour => 'A cada 1 hora';

  @override
  String get sync_auto_3_hours => 'A cada 3 horas';

  @override
  String get sync_auto_6_hours => 'A cada 6 horas';

  @override
  String get sync_auto_12_hours => 'A cada 12 horas';

  @override
  String get server_error => 'Erro no servidor!';

  @override
  String get dialog_confirm => 'Confirmar';

  @override
  String get description => 'Descrição';

  @override
  String get reorder_navigation => 'Personalizar navegação';

  @override
  String get reorder_navigation_description =>
      'Reorganize e ajuste cada navegação conforme suas necessidades.';

  @override
  String get floating_navigation_bar => 'Barra de navegação flutuante';

  @override
  String get floating_navigation_bar_description =>
      'Use uma cápsula flutuante em vez da barra de navegação anexada padrão.';

  @override
  String get full_screen_player => 'Usar tela cheia';

  @override
  String get full_screen_player_info =>
      'Usar automaticamente tela cheia ao reproduzir um vídeo.';

  @override
  String episode_progress(Object n) {
    return 'Progresso: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n episódios';
  }

  @override
  String missing_episodes(Object count) {
    return 'Faltam $count episódios';
  }

  @override
  String get manga_sources => 'Fontes de Manga';

  @override
  String get anime_sources => 'Fontes de Anime';

  @override
  String get novel_sources => 'Fontes de novels';

  @override
  String get anime_extensions => 'Extensões de Anime';

  @override
  String get manga_extensions => 'Extensões de Manga';

  @override
  String get novel_extensions => 'Extensões de novels';

  @override
  String get extension_settings => 'Configurações de extensão';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'Você ainda não tem categorias';

  @override
  String get watching => 'Assistindo';

  @override
  String get plan_to_watch => 'Planejando assistir';

  @override
  String get re_watching => 'Reassistindo';

  @override
  String get episodes => 'Episódios';

  @override
  String get download => 'Baixar';

  @override
  String get new_update_available => 'Nova atualização disponível';

  @override
  String app_version(Object v) {
    return 'Versão do Aplicativo: v$v';
  }

  @override
  String get searching_for_updates => 'Procurando atualizações...';

  @override
  String get no_new_updates_available => 'Sem novas atualizações disponíveis';

  @override
  String get uninstall => 'Desinstalar';

  @override
  String uninstall_extension(Object ext) {
    return 'Desinstalar a extensão $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Toque duas vezes para pesquisar todos os $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Mostrar dica de pesquisa por toque duplo';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Mostra uma dica nos destinos Mangá/Anime/Novel explicando que o toque duplo abre a pesquisa global.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" já está na sua biblioteca através de $source.';
  }

  @override
  String get add_anyway => 'Adicionar mesmo assim';

  @override
  String get langauage => 'Idioma';

  @override
  String get extension_detail => 'Detalhe da extensão';

  @override
  String get scale_type => 'Tipo de escala';

  @override
  String get scale_type_fit_screen => 'Ajustar à tela';

  @override
  String get scale_type_stretch => 'Esticar';

  @override
  String get scale_type_fit_width => 'Ajustar à largura';

  @override
  String get scale_type_fit_height => 'Ajustar à altura';

  @override
  String get scale_type_original_size => 'Tamanho original';

  @override
  String get scale_type_smart_fit => 'Ajuste inteligente';

  @override
  String get page_preload_amount => 'Quantidade de páginas a pré-carregar';

  @override
  String get page_preload_amount_subtitle =>
      'A quantidade de páginas a ser pré-carregada durante a leitura. Valores maiores resultarão em uma experiência de leitura mais suave, ao custo de maior uso de cache e rede.';

  @override
  String get image_loading_error => 'Esta imagem não pôde ser carregada';

  @override
  String get add_episodes => 'Adicionar Episódios';

  @override
  String get video_quality => 'Qualidade';

  @override
  String get video_subtitle => 'Legenda';

  @override
  String get check_for_extension_updates =>
      'Verificar atualizações de extensões';

  @override
  String get auto_extensions_updates => 'Atualizações automáticas de extensões';

  @override
  String get auto_extensions_updates_subtitle =>
      'Atualizará automaticamente a extensão quando uma nova versão estiver disponível.';

  @override
  String get check_for_app_updates =>
      'Verificar atualizações do app na inicialização';

  @override
  String get reading_mode => 'Modo de leitura';

  @override
  String get custom_filter => 'Filtro personalizado';

  @override
  String get background_color => 'Cor de fundo';

  @override
  String get white => 'Branco';

  @override
  String get black => 'Preto';

  @override
  String get grey => 'Cinza';

  @override
  String get automaic => 'Automático';

  @override
  String get preferred_domain => 'Domínio preferido';

  @override
  String get load_more => 'Carregar mais';

  @override
  String get cancel_all_for_this_series => 'Cancelar tudo para esta série';

  @override
  String get login => 'Entrar';

  @override
  String login_into(Object tracker) {
    return 'Entrar no $tracker';
  }

  @override
  String get email_adress => 'Endereço de email';

  @override
  String get password => 'Senha';

  @override
  String log_out_from(Object tracker) {
    return 'Sair do $tracker?';
  }

  @override
  String get log_out => 'Sair';

  @override
  String get update_pending => 'Atualização pendente';

  @override
  String get update_all => 'Atualizar tudo';

  @override
  String get backup_and_restore => 'Backup e restauração';

  @override
  String get create_backup => 'Criar backup';

  @override
  String get create_backup_dialog_title => 'O que você deseja fazer backup?';

  @override
  String get create_backup_subtitle =>
      'Pode ser usado para restaurar a biblioteca atual';

  @override
  String get restore_backup => 'Restaurar backup';

  @override
  String get encrypt_backups => 'Encriptar cópias de segurança';

  @override
  String get encrypt_backups_info =>
      'Proteger cópias com palavra-passe através de encriptação AES';

  @override
  String get no_secure_storage => 'Armazenamento seguro não encontrado';

  @override
  String get no_keyring_warning =>
      'Este sistema não possui serviço de porta-chaves (ex. gnome-keyring ou kwallet no Linux), pelo que a palavra-passe não pode ser guardada com segurança.\n\nGuardar sem encriptação na base de dados local?';

  @override
  String get enter_backup_password => 'Introduza a palavra-passe da cópia';

  @override
  String get incorrect_password_try_again =>
      'Palavra-passe incorreta, tente novamente.';

  @override
  String get set_backup_password => 'Criar palavra-passe para a cópia';

  @override
  String get confirm_password => 'Confirmar palavra-passe';

  @override
  String get passwords_do_not_match => 'As palavras-passe não coincidem';

  @override
  String get password_required_to_restore =>
      'É necessária uma palavra-passe para restaurar esta cópia.';

  @override
  String get restore_backup_subtitle =>
      'Restaurar biblioteca a partir de arquivo de backup';

  @override
  String get automatic_backups => 'Backups automáticos';

  @override
  String get backup_frequency => 'Frequência de backup';

  @override
  String get backup_location => 'Localização do backup';

  @override
  String get backup_options => 'Opções de backup';

  @override
  String get backup_options_dialog_title => 'O que você deseja fazer backup?';

  @override
  String get backup_options_subtitle =>
      'Quais informações incluir no arquivo de backup';

  @override
  String get backup_and_restore_warning_info =>
      'Você deve manter cópias dos backups em outros locais também';

  @override
  String get library_entries => 'Entradas da biblioteca';

  @override
  String get chapters_and_episode => 'Capítulos e episódios';

  @override
  String get every_6_hours => 'A cada 6 horas';

  @override
  String get every_12_hours => 'A cada 12 horas';

  @override
  String get daily => 'Diariamente';

  @override
  String get every_2_days => 'A cada 2 dias';

  @override
  String get weekly => 'Semanalmente';

  @override
  String get restore_backup_warning_title =>
      'Restaurar um backup irá sobrescrever todos os dados existentes.\n\nContinuar restaurando?';

  @override
  String get restore_sync_question_title => 'Sincronizar este restauro?';

  @override
  String get restore_sync_question_message =>
      'Este dispositivo está ligado a um servidor de sincronização. Enviar os dados restaurados agora?';

  @override
  String get restore_sync_question_confirm => 'Sim, sincronizar';

  @override
  String get restore_sync_question_deny => 'Não, desativar sincronização';

  @override
  String get sync_disabled_after_restore =>
      'A sincronização está desativada. Pode reativá-la nas Definições.';

  @override
  String get restore_sync_disabled_question_title =>
      'A sincronização está desativada';

  @override
  String get restore_sync_disabled_question_message =>
      'A sincronização está desligada. Pretende ligá-la e enviar os dados restaurados?';

  @override
  String get restore_sync_question_reenable => 'Sim, reativar e sincronizar';

  @override
  String get restore_sync_question_keep_disabled => 'Manter desativada';

  @override
  String get restore_sync_uploading =>
      'A sincronizar dados restaurados com o servidor…';

  @override
  String get restore_sync_upload_success =>
      'Dados restaurados sincronizados com o servidor';

  @override
  String get services => 'Serviços';

  @override
  String get tracking_warning_info =>
      'Sincronização unidirecional para atualizar o progresso do capítulo em serviços de rastreamento. Configure o rastreamento para entradas individuais a partir do botão de rastreamento.';

  @override
  String get use_page_tap_zones => 'Usar zonas de toque da página';

  @override
  String get manage_trackers => 'Gerenciar rastreadores';

  @override
  String get restore => 'Restaurar';

  @override
  String get backups => 'Backups';

  @override
  String get by_scanlator => 'Por scanlator';

  @override
  String get by_name => 'Por nome';

  @override
  String get installed => 'Instalado';

  @override
  String get auto_scroll => 'Rolagem automática';

  @override
  String get video_audio => 'Áudio';

  @override
  String get video_audio_info =>
      'Idiomas preferidos, correção de tom, canais de áudio';

  @override
  String get player => 'Jogador';

  @override
  String get markEpisodeAsSeenSetting =>
      'Em que ponto marcar o episódio como visto';

  @override
  String get mark_duplicate_chapters_read =>
      'Marcar números de capítulos duplicados como lidos';

  @override
  String get default_skip_intro_length =>
      'Duração padrão para pular a introdução';

  @override
  String get default_playback_speed_length =>
      'Duração padrão da velocidade de reprodução';

  @override
  String get updateProgressAfterReading =>
      'Atualize o progresso após a leitura';

  @override
  String get no_sources_installed => 'Nenhuma fonte instalada!';

  @override
  String get show_extensions => 'Mostrar extensões';

  @override
  String get default_skip_forward_skip_length =>
      'Comprimento padrão do salto para frente';

  @override
  String get aniskip_requires_info =>
      'AniSkip requer que o anime seja rastreado com MAL ou Anilist para funcionar.';

  @override
  String get enable_aniskip => 'Habilitar AniSkip';

  @override
  String get enable_auto_skip => 'Habilitar auto skip';

  @override
  String get aniskip_button_timeout => 'Timeout do botão';

  @override
  String get skip_opening => 'Pular abertura';

  @override
  String get skip_ending => 'Pular encerramento';

  @override
  String get fullscreen => 'Tela cheia';

  @override
  String get update_library => 'Atualizar biblioteca';

  @override
  String get next_chapter => 'Próximo capítulo';

  @override
  String get next_5_chapters => 'Próximos 5 capítulos';

  @override
  String get next_10_chapters => 'Próximos 10 capítulos';

  @override
  String get next_25_chapters => 'Próximos 25 capítulos';

  @override
  String get all_chapters => 'Todos os capítulos';

  @override
  String get next_episode => 'Próximo episódio';

  @override
  String get next_5_episodes => 'Próximos 5 episódios';

  @override
  String get next_10_episodes => 'Próximos 10 episódios';

  @override
  String get next_25_episodes => 'Próximos 25 episódios';

  @override
  String get all_episodes => 'Todos os episódios';

  @override
  String get cover_saved => 'Capa salva';

  @override
  String get set_as_cover => 'Definir como capa';

  @override
  String get use_this_as_cover_art => 'Usar isso como arte de capa?';

  @override
  String get save => 'Salvar';

  @override
  String get picture_saved => 'Foto salva';

  @override
  String get cover_updated => 'Capa atualizada';

  @override
  String get include_subtitles => 'Incluir legendas';

  @override
  String get blend_mode_default => 'Padrão';

  @override
  String get blend_mode_multiply => 'Multiplicar';

  @override
  String get blend_mode_screen => 'Tela';

  @override
  String get blend_mode_overlay => 'Sobrepor';

  @override
  String get blend_mode_colorDodge => 'Desvio de cor';

  @override
  String get blend_mode_lighten => 'Clarear';

  @override
  String get blend_mode_colorBurn => 'Queimar cor';

  @override
  String get blend_mode_darken => 'Escurecer';

  @override
  String get blend_mode_difference => 'Diferença';

  @override
  String get blend_mode_saturation => 'Saturação';

  @override
  String get blend_mode_softLight => 'Luz suave';

  @override
  String get blend_mode_plus => 'Mais';

  @override
  String get blend_mode_exclusion => 'Exclusão';

  @override
  String get custom_color_filter => 'Filtro de cor personalizado';

  @override
  String get color_filter_blend_mode => 'Modo de mistura de filtro de cor';

  @override
  String get enable_all => 'Ativar todos';

  @override
  String get disable_all => 'Desativar todos';

  @override
  String get font => 'Fonte';

  @override
  String get color => 'Cor';

  @override
  String get font_size => 'Tamanho da fonte';

  @override
  String get text => 'Texto';

  @override
  String get border => 'Borda';

  @override
  String get background => 'Fundo';

  @override
  String get no_subtite_warning_message =>
      'Não tem efeito porque não há faixas de legenda neste vídeo';

  @override
  String get grid_size => 'Tamanho da grade';

  @override
  String n_per_row(Object n) {
    return '$n por linha';
  }

  @override
  String get horizontal_continious => 'Contínuo horizontal';

  @override
  String get edit_code => 'Editar código';

  @override
  String get use_libass => 'Ativar libass';

  @override
  String get use_libass_info =>
      'Use a renderização de legendas baseada em libass para o backend nativo.';

  @override
  String get libass_not_disable_message =>
      'Desative `usar libass` nas configurações do player para poder personalizar as legendas.';

  @override
  String get override_ass_subtitles => 'Substituir legendas ASS';

  @override
  String get override_ass_subtitles_info =>
      'Aplicar estilo personalizado às legendas ASS/SSA';

  @override
  String get torrent_stream => 'Transmissão de Torrent';

  @override
  String get add_torrent => 'Adicionar torrent';

  @override
  String get enter_torrent_hint_text =>
      'Digite o URL do magnet ou do arquivo torrent';

  @override
  String get torrent_url => 'URL do torrent';

  @override
  String get or => 'OU';

  @override
  String get advanced => 'Avançado';

  @override
  String get advanced_info => 'Configuração mpv';

  @override
  String get use_native_http_client => 'Usar cliente HTTP nativo';

  @override
  String get use_native_http_client_info =>
      'ele suporta automaticamente recursos da plataforma como VPNs, suporta mais recursos HTTP, como HTTP/3 e manuseio personalizado de redirecionamento';

  @override
  String n_hour_ago(Object hour) {
    return 'há $hour hora';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'há $hours horas';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'há $minute minuto';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'há $minutes minutos';
  }

  @override
  String n_day_ago(Object day) {
    return 'há $day dia';
  }

  @override
  String get now => 'agora';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Biblioteca atualizada pela última vez: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Dados e armazenamento';

  @override
  String get download_location_info => 'Usado para downloads de capítulos';

  @override
  String get storage => 'Armazenamento';

  @override
  String get clear_chapter_and_episode_cache =>
      'Limpar cache de capítulos e episódios';

  @override
  String get cache_cleared => 'Cache limpo';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Limpar cache de capítulos/episódios ao iniciar o aplicativo';

  @override
  String get app_settings => 'Configurações do aplicativo';

  @override
  String get sources_settings => 'Configurações de fontes';

  @override
  String get include_sensitive_settings =>
      'Incluir configurações sensíveis (ex.: tokens de login de rastreadores)';

  @override
  String get create => 'Criar';

  @override
  String get downloads_are_limited_to_wifi =>
      'Os downloads estão limitados apenas ao Wi-Fi';

  @override
  String get recommendations => 'Recomendações';

  @override
  String get recommendations_similar => 'semelhante';

  @override
  String get recommendations_weights => 'Pesos de recomendação';

  @override
  String get recommendations_weights_genre => 'Similaridade de gênero';

  @override
  String get recommendations_weights_setting => 'Similaridade de cenário';

  @override
  String get recommendations_weights_synopsis => 'Similaridade de história';

  @override
  String get recommendations_weights_theme => 'Similaridade de tema';

  @override
  String get manga_extensions_repo => 'Repositório de extensões de mangás';

  @override
  String get anime_extensions_repo => 'Repositório de extensões de animes';

  @override
  String get novel_extensions_repo => 'Repositório de extensões de romances';

  @override
  String get custom_dns =>
      'DNS personalizado (deixe em branco para usar DNS do sistema)';

  @override
  String get android_proxy_server =>
      'Servidor proxy Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Obter M-Extension-Server';

  @override
  String get undefined => 'Indefinido';

  @override
  String get empty_extensions_repo =>
      'Você não tem nenhum URL de repositório aqui. Clique no botão de adicionar para incluir um!';

  @override
  String get add_extensions_repo => 'Adicionar URL do repositório';

  @override
  String get remove_extensions_repo => 'Remover URL do repositório';

  @override
  String get manage_manga_repo_urls =>
      'Gerenciar URLs do repositório de mangás';

  @override
  String get manage_anime_repo_urls =>
      'Gerenciar URLs do repositório de animes';

  @override
  String get manage_novel_repo_urls =>
      'Gerenciar URLs do repositório de romances';

  @override
  String get url_cannot_be_empty => 'A URL não pode estar vazia';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'A URL deve terminar com .json / .pb';

  @override
  String get repo_url => 'URL do repositório';

  @override
  String get invalid_url_format => 'Formato de URL inválido';

  @override
  String get clear_all_sources => 'Limpar todas as fontes';

  @override
  String get clear_all_sources_msg =>
      'Isso limpará completamente todas as fontes do aplicativo. Tem certeza de que deseja continuar?';

  @override
  String get sources_cleared => 'Fontes limpas!';

  @override
  String get repo_added => 'Repositório de fontes adicionado!';

  @override
  String get repo_already_exists => 'O repositório já existe!';

  @override
  String get add_repo => 'Adicionar repositório?';

  @override
  String get add_repo_sources_to_add =>
      'Listas de extensões que serão adicionadas:';

  @override
  String get add_repo_warning =>
      'Extensões desses repositórios são executadas dentro do aplicativo. Adicione apenas repositórios em que você confia.';

  @override
  String get genre_search_library => 'Pesquisar gênero na biblioteca';

  @override
  String get genre_search_source => 'Explorar na fonte';

  @override
  String get source_not_added => 'A fonte não está instalada!';

  @override
  String get load_own_subtitles => 'Carregar suas próprias legendas...';

  @override
  String get search_subtitles => 'Pesquisar legendas online...';

  @override
  String extension_notes(Object notes) {
    return 'Notas: $notes';
  }

  @override
  String get unsupported_repo =>
      'Não foi possível adicionar este repositório de fontes. Verifique o endereço do repositório ou entre em contato com seu responsável.';

  @override
  String get you_have_finished_reading => 'Você terminou de ler';

  @override
  String get hwdec => 'Decodificador de hardware';

  @override
  String get enable_hardware_accel => 'Aceleração de hardware';

  @override
  String get enable_hardware_accel_info =>
      'Ative/desative se estiver enfrentando bugs ou travamentos';

  @override
  String get track_library_navigate => 'Ir para entrada local existente';

  @override
  String get track_library_add => 'Adicionar à biblioteca local';

  @override
  String get track_library_add_confirm =>
      'Adicionar item rastreado à biblioteca local';

  @override
  String get track_library_not_logged =>
      'Faça login no rastreador correspondente para usar este recurso!';

  @override
  String get track_library_switch => 'Mudar para outro rastreador';

  @override
  String get go_back => 'Voltar';

  @override
  String get merge_library_nav_mobile =>
      'Mesclar navegação da biblioteca no celular';

  @override
  String get enable_discord_rpc => 'Ativar Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Ocultar Discord RPC no modo Incógnito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Mostrar capítulo atual no Discord (requer reinicialização)';

  @override
  String get rpc_show_title => 'Mostrar título atual no Discord';

  @override
  String get rpc_show_cover_image => 'Mostrar imagem de capa atual no Discord';

  @override
  String get enable_mpv => 'Ativar shaders / scripts mpv';

  @override
  String get mpv_info => 'Suporta scripts .js em mpv/scripts/';

  @override
  String get mpv_redownload => 'Baixar novamente arquivos de configuração mpv';

  @override
  String get mpv_redownload_info =>
      'Substitui arquivos de configuração antigos por novos!';

  @override
  String get mpv_download =>
      'Arquivos de configuração MPV são necessários!\nBaixar agora?';

  @override
  String get custom_buttons => 'Botões personalizados';

  @override
  String get custom_buttons_info =>
      'Executar código lua com botões personalizados';

  @override
  String get custom_buttons_edit => 'Editar botões personalizados';

  @override
  String get custom_buttons_add => 'Adicionar botão personalizado';

  @override
  String get custom_buttons_added => 'Botão personalizado adicionado!';

  @override
  String get custom_buttons_delete => 'Excluir botão personalizado';

  @override
  String get custom_buttons_text => 'Texto do botão';

  @override
  String get custom_buttons_text_req => 'Texto do botão obrigatório';

  @override
  String get custom_buttons_js_code => 'Código lua';

  @override
  String get custom_buttons_js_code_req => 'Código lua obrigatório';

  @override
  String get custom_buttons_js_code_long =>
      'Código lua (em pressionamento longo)';

  @override
  String get custom_buttons_startup => 'Código lua (na inicialização)';

  @override
  String get custom_buttons_add_warning =>
      'Este botão executa o código Lua abaixo no reprodutor de vídeo, que pode acessar seus arquivos e executar programas. Adicione-o apenas se você confiar na origem deste link.';

  @override
  String n_days(Object n) {
    return '$n dias';
  }

  @override
  String get decoder => 'Decodificador';

  @override
  String get decoder_info =>
      'Decodificação de hardware, formato de pixel, debanding';

  @override
  String get enable_gpu_next => 'Ativar gpu-next (apenas Android)';

  @override
  String get enable_gpu_next_info =>
      'Um novo mecanismo de renderização de vídeo';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Usar formato de pixel YUV420P';

  @override
  String get use_yuv420p_info =>
      'Pode corrigir telas pretas em alguns codecs de vídeo, também pode melhorar o desempenho às custas da qualidade';

  @override
  String get audio_preferred_languages => 'Idiomas preferidos';

  @override
  String get audio_preferred_languages_info =>
      'Idioma(s) de áudio para selecionar por padrão em um vídeo com múltiplos fluxos de áudio, códigos de idioma de 2/3 letras (ex: pt, en, es). Múltiplos valores podem ser delimitados por vírgula.';

  @override
  String get enable_audio_pitch_correction => 'Ativar correção de tom de áudio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Impede que o áudio fique agudo em velocidades mais rápidas e grave em velocidades mais lentas';

  @override
  String get audio_channels => 'Canais de áudio';

  @override
  String get volume_boost_cap => 'Limite de amplificação de volume';

  @override
  String get internal_player => 'Reprodutor interno';

  @override
  String get internal_player_info => 'Progresso, controles, orientação';

  @override
  String get subtitle_delay_text => 'Atraso de legendas';

  @override
  String get subtitle_delay => 'Atraso (ms)';

  @override
  String get subtitle_speed => 'Velocidade';

  @override
  String get tracks => 'Faixas';

  @override
  String get playback_speed => 'Velocidade de reprodução';

  @override
  String get shaders => 'Shaders';

  @override
  String get video_fit => 'Ajustar';

  @override
  String get calendar => 'Calendário';

  @override
  String get calendar_no_data => 'Ainda não há dados.';

  @override
  String get calendar_info =>
      'O calendário só pode prever o próximo upload de capítulo com base nos uploads anteriores. Alguns dados podem não ser 100% precisos!';

  @override
  String in_n_day(Object days) {
    return 'em $days dia';
  }

  @override
  String in_n_days(Object days) {
    return 'em $days dias';
  }

  @override
  String get clear_library => 'Limpar biblioteca';

  @override
  String get clear_library_desc =>
      'Escolha limpar todas as entradas de manga, anime e/ou novel';

  @override
  String get clear_library_input =>
      'Digite \'manga\', \'anime\' e/ou \'novel\' (separados por vírgula) para remover todas as entradas relacionadas';

  @override
  String get watch_order => 'Ordem de visualização';

  @override
  String get watch_order_role_current => 'Atual';

  @override
  String get watch_order_role_previous => 'Anterior';

  @override
  String get watch_order_role_next => 'Próximo';

  @override
  String get watch_order_source_release_order => 'Ordem de liberação';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name por $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Coleção oficial Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Temporadas para $title';
  }

  @override
  String get watch_order_select_source => 'Fonte do pedido';

  @override
  String watch_order_season(int number) {
    return 'Temporada $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Episódio $number';
  }

  @override
  String get sequels => 'Sequências';

  @override
  String get recommendations_similarity => 'Similaridade:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Classificação $rating';
  }

  @override
  String get local_folder_structure => 'Estrutura de uma pasta local';

  @override
  String get local_folder => 'Pastas locais';

  @override
  String get add_local_folder => 'Adicionar pasta local';

  @override
  String get rescan_local_folder => 'Reescanear todas as pastas locais agora';

  @override
  String get default_download_destination =>
      'Destino predefinido das transferências';

  @override
  String get ask_download_destination => 'Perguntar destino das transferências';

  @override
  String get ask_download_destination_desc =>
      'Escolher uma pasta local cada vez que iniciar uma transferência.';

  @override
  String get select_download_destination =>
      'Selecionar pasta de transferências';

  @override
  String get clear_local_library => 'Limpar biblioteca local';

  @override
  String get clear_local_library_desc =>
      'Remover pastas e arquivos locais da biblioteca.';

  @override
  String get clear_local_library_msg =>
      'Isto removerá as pastas e arquivos da biblioteca sem apagar ficheiros do disco.';

  @override
  String get custom => 'Personalizado';

  @override
  String get no_local_folder_available_for_downloads =>
      'Nenhuma pasta local disponível para transferências';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Falha ao criar CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Erro ao ler capa: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Erro ao ler metadados: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Erro ao guardar na biblioteca: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Erro ao ler capa do capítulo: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Erro ao ler capa do arquivo: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Erro ao obter biblioteca local: $error';
  }

  @override
  String get export_metadata => 'Exportar metadados';

  @override
  String get exported => 'Exportado';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Falha ao exportar metadados: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count capítulos não numerados automaticamente.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Não foi possível iniciar o servidor Webview para Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Token de $tracker expirou';
  }

  @override
  String get video_list_empty => 'A lista de vídeos está vazia';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Não foi possível abrir $url';
  }

  @override
  String get text_size => 'Tamanho do texto:';

  @override
  String get text_align => 'Alinhamento do texto';

  @override
  String get line_height => 'Altura da linha';

  @override
  String get show_scroll_percentage => 'Mostrar porcentagem de rolagem';

  @override
  String get remove_extra_paragraph_spacing =>
      'Remover espaçamento extra de parágrafos';

  @override
  String select_label_color(Object label) {
    return 'Selecionar cor de $label';
  }

  @override
  String get default_user_agent => 'Agente do usuário padrão';

  @override
  String get forceLandscapeMode => 'Forçar modo paisagem';

  @override
  String get forceLandscapeModeSubtitle =>
      'Força o player a usar a orientação de paisagem.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Provedor DNS';

  @override
  String get tracked => 'Rastreado';

  @override
  String get auth_unlock_msg =>
      'Autentique-se para desbloquear NodeLane Comics';

  @override
  String get app_locked => 'NodeLane Comics está bloqueado';

  @override
  String get auth_to_continue => 'Autentique-se para continuar';

  @override
  String get authenticating => 'Autenticando...';

  @override
  String get lock => 'Bloquear';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get security => 'Segurança';

  @override
  String get auth_to_change_security_setting =>
      'Autentique-se para alterar as configurações de segurança';

  @override
  String get app_lock => 'Bloqueio do aplicativo';

  @override
  String get require_biometric_or_device_credential =>
      'Requer autenticação biométrica ou credenciais do dispositivo para abrir o aplicativo';

  @override
  String get biometric_or_device_credential_not_available =>
      'A autenticação biométrica não está disponível neste dispositivo';

  @override
  String get app_lock_description =>
      'Quando o bloqueio do aplicativo está ativado, você será solicitado a se autenticar\\na cada vez que você abrir o aplicativo ou retornar do fundo.';

  @override
  String get checking_device_authentication =>
      'Verificando a autenticação do dispositivo…';

  @override
  String get device_authentication_incomplete =>
      'A autenticação não foi concluída. Sua configuração não mudou.';

  @override
  String get keep_screen_on => 'Manter a tela ligada';

  @override
  String get webtoon_side_padding => 'Espaçamento lateral da Webtoon';

  @override
  String get show_page_gaps => 'Mostrar espaços de página';

  @override
  String get invert_colors => 'Inverter cores';

  @override
  String get grayscale => 'Escala de cinzas';

  @override
  String get brightness => 'Brilho';

  @override
  String get contrast => 'Contraste';

  @override
  String get saturation => 'Saturação';

  @override
  String get navigation_layout => 'Layout de navegação';

  @override
  String get nav_layout_default => 'Padrão';

  @override
  String get nav_layout_l_shaped => 'Em forma de L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Borda';

  @override
  String get nav_layout_right_and_left => 'Direita e esquerda';

  @override
  String get nav_layout_disabled => 'Desabilitado';

  @override
  String get color_enhancements => 'Aprimoramentos de cor';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Média por título';

  @override
  String get completion_rate => 'Taxa de conclusão';

  @override
  String get watching_time => 'Tempo assistido';

  @override
  String get reading_time => 'Tempo de leitura';

  @override
  String average_chapters_per_title(Object title) {
    return 'Média de capítulos por $title';
  }

  @override
  String get read_percentage => 'Percentual de leitura';

  @override
  String get entries => 'Entradas';

  @override
  String get android_proxy_server_mihon => 'Servidor Proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Baixe e configure o servidor proxy necessário para usar extensões Mihon.';

  @override
  String get mihon_proxy_server => 'Servidor proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Baixe o pacote do servidor proxy antes de usar as extensões Mihon. Inclui JRE e JAR do servidor.';

  @override
  String get extension_server_intro_ios =>
      'Baixe o arquivo JAR do servidor proxy antes de usar as extensões Mihon. iOS só precisa do JAR do servidor.';

  @override
  String get checking_files => 'Verificando arquivos';

  @override
  String get files_installed => 'Arquivos instalados';

  @override
  String get files_missing => 'Arquivos faltando';

  @override
  String get update_files => 'Atualizar arquivos';

  @override
  String get up_to_date => 'Atualizado';

  @override
  String get choose_location => 'Escolher local';

  @override
  String get import_existing_jar => 'Importar JAR existente';

  @override
  String get detect_files_in_selected_folder =>
      'Detectar arquivos na pasta selecionada';

  @override
  String get preparing_download => 'Preparando download...';

  @override
  String get app_install_location => 'Local de instalação do app';

  @override
  String get install_location => 'Local de instalação';

  @override
  String get jre_executable => 'Executável JRE';

  @override
  String get extension_server_jar => 'JAR do servidor de extensões';

  @override
  String get installed_version => 'Versão instalada';

  @override
  String get latest_version => 'Versão mais recente';

  @override
  String get m_extension_server_description =>
      'Use M-Extension-Server quando precisar de um proxy para dispositivo Android separado. Configure o endereço aqui e baixe o APK pelo GitHub.';

  @override
  String get set_proxy_address => 'Definir endereço do proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'Nenhuma versão mais recente do servidor proxy disponível.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Não foi possível verificar atualizações do servidor proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Nenhum pacote de servidor de extensões disponível para esta plataforma.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Falha ao baixar pacote ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'O pacote baixado não contém os arquivos esperados.';

  @override
  String get extension_server_files_ready =>
      'Arquivos do servidor de extensões prontos.';

  @override
  String get ios_extension_server_import_hint =>
      'No iOS, o servidor é instalado no sandbox do app. Use \"Importar JAR existente\" para trazer um arquivo baixado.';

  @override
  String get select_extension_server_folder =>
      'Selecionar pasta do servidor de extensões';

  @override
  String get selected_folder_does_not_exist =>
      'A pasta selecionada não existe.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Nenhum arquivo encontrado na pasta selecionada.';

  @override
  String get extension_server_files_linked =>
      'Arquivos do servidor vinculados.';

  @override
  String get select_extension_server_jar =>
      'Selecionar JAR do servidor de extensões';

  @override
  String get selected_file_could_not_be_accessed =>
      'Não foi possível acessar le arquivo selecionado.';

  @override
  String get extension_server_jar_imported =>
      'JAR do servidor de extensões importado.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Não foi possível abrir a página do M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP do servidor (ex: 10.0.0.5 ou https://example.com)';

  @override
  String get not_configured => 'Não configurado';

  @override
  String get zero_interpreter => 'Intérprete Zero';

  @override
  String get zero_interpreter_description =>
      'Controlar o servidor do intérprete Zero automática ou manualmente.';

  @override
  String get start_server_on_launch => 'Iniciar servidor ao arrancar';

  @override
  String get runtime_status => 'Estado do runtime';

  @override
  String get running => 'Em execução';

  @override
  String get stopped => 'Parado';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Parar';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Conversão de texto em fala';

  @override
  String get tts_speed => 'Velocidade';

  @override
  String get tts_pitch => 'Tom';

  @override
  String get tts_language => 'Linguagem';

  @override
  String get tts_voice => 'Voz';

  @override
  String get tts_stop => 'Parar';

  @override
  String get tts_play => 'Reproduzir';

  @override
  String get tts_pause => 'Pausa';

  @override
  String get tts_previous => 'Parágrafo anterior';

  @override
  String get tts_next => 'Próximo parágrafo';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Parágrafo $current de $total';
  }

  @override
  String get tts_settings => 'Configurações de TTS';

  @override
  String get tts_default => 'Padrão';

  @override
  String get webtoon_disable_zoom_out => 'Desativar zoom out do Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Toque duplo para zoom no Webtoon';

  @override
  String get navigate_to_pan => 'Navegar para arrastar';

  @override
  String get navigate_to_pan_subtitle =>
      'Mover a imagem ampliada antes de mudar de página';

  @override
  String get split_wide_pages => 'Dividir páginas duplas';

  @override
  String get dual_page_invert => 'Inverter metades de páginas cortadas';

  @override
  String get dual_page_rotate_to_fit => 'Rotacionar para caber';

  @override
  String get dual_page_rotate_to_fit_invert => 'Inverter direção de rotação';

  @override
  String get double_page_single_first_page => 'Primeira página individual';

  @override
  String get double_page_single_first_page_subtitle =>
      'Exibir a primeira página sozinha no modo de página dupla';

  @override
  String get double_page_auto => 'Página dupla automática';

  @override
  String get double_page_auto_subtitle =>
      'Mudar automaticamente para modo de página dupla em paisagem';

  @override
  String get landscape_zoom => 'Zoom automático em modo paisagem';

  @override
  String get zoom_start_position => 'Posição inicial do zoom';

  @override
  String get zoom_start_left => 'Esquerda';

  @override
  String get zoom_start_right => 'Direita';

  @override
  String get zoom_start_center => 'Centro';

  @override
  String get automatic_background => 'Fundo automático';

  @override
  String get tapping_inversion => 'Inversão de toque';

  @override
  String get tapping_inversion_none => 'Nenhum';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertical';

  @override
  String get tapping_inversion_both => 'Ambos';

  @override
  String get flash_on_page_change => 'Piscar ao mudar de página';

  @override
  String get flash_on_page_change_subtitle => 'Assistente anti-retenção AMOLED';

  @override
  String get flash_color => 'Cor do flash';

  @override
  String get flash_color_black => 'Preto';

  @override
  String get flash_color_white => 'Branco';

  @override
  String get flash_color_white_black => 'Branco e Preto';

  @override
  String get flash_interval_label => 'Intervalo do flash';

  @override
  String flash_interval_value(String n) {
    return '$n páginas';
  }

  @override
  String flash_interval(String n) {
    return 'Intervalo do flash: $n páginas';
  }

  @override
  String get flash_duration_label => 'Duração do flash';

  @override
  String flash_duration_value(String n) {
    return '$n ms';
  }

  @override
  String flash_duration(String n) {
    return 'Duração do flash: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Mostrar sobreposição de navegação ao iniciar';

  @override
  String get reader_hide_threshold => 'Limite de ocultação do leitor';

  @override
  String get reader_hide_threshold_highest => 'Mais alto (5 px)';

  @override
  String get reader_hide_threshold_high => 'Alto (13 px)';

  @override
  String get reader_hide_threshold_low => 'Baixo (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Mais baixo (47 px)';

  @override
  String get error_no_pages_available => 'Erro: nenhuma página disponível';

  @override
  String get app_ui_scale => 'Escala de interface';

  @override
  String get app_ui_scale_subtitle =>
      'Torne a interface maior ou menor para se adequar à sua tela e distância de visualização.';

  @override
  String get allow_concurrent_downloads => 'Permitir downloads simultâneos';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Baixe de diferentes fontes ao mesmo tempo. Uma única fonte ainda baixa um capítulo por vez para que não seja sobrecarregada. Desative para fazer download um por vez em todos os lugares.';

  @override
  String get download_delay => 'Atraso de download';

  @override
  String get download_delay_subtitle =>
      'Desativado. Adicione uma espera com jitter aleatório entre os capítulos para ser mais gentil nas fontes.';

  @override
  String get save_search => 'Salvar pesquisa';

  @override
  String get saved_searches => 'Pesquisas salvas';

  @override
  String get enter_search_to_save_first =>
      'Digite uma pesquisa para salvar primeiro';

  @override
  String get no_saved_searches =>
      'Nenhuma pesquisa salva para esta fonte ainda.\nExecute uma pesquisa e escolha \"Salvar pesquisa\".';

  @override
  String get source => 'Fonte';

  @override
  String get something_went_wrong => 'Algo correu mal';

  @override
  String get startup_failed =>
      'NodeLane Comics não conseguiu concluir a inicialização';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fontes sem resultados',
      one: '1 fonte sem resultados',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Como deseja importar?';

  @override
  String get import_mode_message =>
      'Escolha se pretende fundir esta cópia com a biblioteca atual ou substituir tudo.';

  @override
  String get import_mode_keep_existing => 'Fundir';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Adiciona novas séries e atualiza existentes. Nada será removido.';

  @override
  String get import_mode_replace => 'Substituir';

  @override
  String get import_mode_replace_subtitle =>
      'Apaga a biblioteca atual e substitui-a por esta cópia.';

  @override
  String get replace_summary_title => 'Pronto para substituir a biblioteca';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Isto apagará $currentCount séries e substituirá por $backupCount séries desta cópia.';
  }

  @override
  String get replace_summary_confirm => 'Substituir';

  @override
  String replace_result_message(Object count) {
    return 'Biblioteca substituída por $count séries da cópia.';
  }

  @override
  String get category_conflict_title => 'Categorias existentes encontradas';

  @override
  String get category_conflict_message =>
      'A cópia contém categorias que já existem na biblioteca.';

  @override
  String get category_conflict_keep => 'Manter — fundir na categoria existente';

  @override
  String get category_conflict_delete =>
      'Eliminar — deixar séries sem categoria';

  @override
  String get source_conflict_title => 'Fontes não encontradas';

  @override
  String get source_conflict_message =>
      'Algumas fontes não correspondem a extensões instaladas.';

  @override
  String get source_conflict_keep => 'Manter nome original';

  @override
  String get import_summary_title => 'Pronto para importar';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries novas séries, $updatedSeries séries atualizadas e $newChapters novos capítulos.';
  }

  @override
  String get import_summary_confirm => 'Importar';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Importadas $newSeries novas séries, $updatedSeries atualizadas, $newChapters novos capítulos adicionados.';
  }

  @override
  String get roll_back => 'Reverter';

  @override
  String get roll_back_confirm_message =>
      'Restaura a biblioteca para a cópia de segurança efetuada antes desta alteração.';

  @override
  String get roll_back_done => 'Revertido para o estado anterior.';

  @override
  String get restoring_backup => 'A restaurar a biblioteca…';

  @override
  String get roll_back_last_change => 'Reverter última alteração';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Instantâneo de $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count alterações recentes disponíveis para reverter';
  }

  @override
  String get delete_source_title => 'Eliminar fonte e os seus mangas';

  @override
  String get delete_source_subtitle =>
      'Remove todos os mangas de uma fonte juntamente com capítulos, transferências e histórico.';

  @override
  String get delete_source_pick_title => 'Escolher fonte para eliminar';

  @override
  String get delete_source_empty => 'Nenhuma fonte encontrada na biblioteca.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Eliminar $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Isso exclui permanentemente $mangaCount mangá, capítulos $chapterCount, entradas de histórico $historyCount e entradas de atualização $updateCount. Links de rastreamento são mantidos. Isso não pode ser desfeito, exceto revertendo.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Remover também a extensão instalada';

  @override
  String get delete_source_keep_history => 'Manter histórico de leitura';

  @override
  String get delete_source_keep_downloads =>
      'Manter registos de transferências';

  @override
  String get delete_source_button => 'Eliminar';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Eliminados $mangaCount mangas de $sourceName.';
  }

  @override
  String get merge_manga_title => 'Fundir mangas duplicados';

  @override
  String get merge_manga_subtitle =>
      'Encontra mangas com títulos idênticos sob a mesma fonte e junta-os.';

  @override
  String get merge_manga_none_found => 'Nenhum manga duplicado encontrado.';

  @override
  String get merge_manga_pick_title => 'Possíveis duplicados';

  @override
  String get merge_manga_choose_primary_title =>
      'Em qual entrada devem os outros fundir-se?';

  @override
  String get merge_manga_choose_primary_message =>
      'Capítulos, histórico e rastreio serão integrados na entrada escolhida.';

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
  String get merge_manga_button => 'Fundir';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Fundidos $count mangas duplicados em $mangaName.';
  }

  @override
  String get merge_preview_title => 'Confirmar fusão';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters capítulos encontrados em outras entradas. $duplicateChapters são duplicados e serão descartados (mantendo a cópia que tiver progresso de leitura); $keptChapters será adicionado. $duplicateTracks links de rastreamento duplicados também serão descartados.';
  }

  @override
  String get memory_overlay => 'Mostrar uso de memória';

  @override
  String get memory_overlay_subtitle =>
      'Leitura em tempo real da memória ocupada pelo aplicativo. Para medir no dispositivo em vez de adivinhar: observe enquanto navega pela biblioteca ou lê um capítulo.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Relatórios de erros';

  @override
  String get error_reports_subtitle =>
      'Erros detetados pela app e forma de os reportar';

  @override
  String get error_reports_empty => 'Nenhum erro registado.';

  @override
  String get error_reports_likely_cause => 'Causa provável';

  @override
  String get error_reports_report => 'Reportar no GitHub';

  @override
  String get error_reports_banner => 'NodeLane Comics encontrou um erro';

  @override
  String get error_reports_banner_action => 'Ver';

  @override
  String get error_reports_copy => 'Copiar';

  @override
  String get error_reports_copied => 'Copiado para a área de transferência';

  @override
  String get error_reports_clear => 'Limpar';

  @override
  String get error_reports_extension_failure =>
      'Isto veio de uma extensão, não do NodeLane Comics. As extensões são escritas e mantidas por quem gerencia o repositório de onde você instalou esta fonte, portanto a correção deve ser feita lá. O nome da fonte e o que você estava abrindo são detalhes úteis para enviar a eles.';

  @override
  String get error_reports_already_reported => 'Já reportado';

  @override
  String get error_reports_expected_failure =>
      'Geralmente é causado pela fonte ou rede e não pelo aplicativo: um link expirado, um servidor fora do ar ou uma queda de conexão. Vale a pena reportar apenas se continuar acontecendo em uma fonte que funciona em outros lugares.';

  @override
  String get share_unavailable_copied =>
      'Partilha indisponível, copiado para a área de transferência.';

  @override
  String get onboarding_title => 'Bem-vindo ao NodeLane Comics';

  @override
  String get onboarding_libraries_body =>
      'Escolha o que pretende ler e assistir.';

  @override
  String get onboarding_nav_title => 'As suas bibliotecas';

  @override
  String get onboarding_nav_body =>
      'Um separador para cada ou agrupadas num único separador Biblioteca.';

  @override
  String get onboarding_nav_split => 'Separadores individuais';

  @override
  String get onboarding_nav_merged => 'Um separador Biblioteca';

  @override
  String get onboarding_nav_inside =>
      'Tocar em Biblioteca alterna os separadores';

  @override
  String get onboarding_next => 'Seguinte';

  @override
  String get onboarding_restore => 'Restaurar cópia de segurança';

  @override
  String get onboarding_or_local => 'Ou utilize ficheiros existentes';

  @override
  String get onboarding_local_folder => 'Adicionar pasta';

  @override
  String onboarding_local_existing(Object count) {
    return '$count pastas configuradas';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime e novel são suportados.';

  @override
  String get onboarding_local_scanning => 'A analisar pasta';

  @override
  String onboarding_local_found(Object count) {
    return '$count títulos encontrados';
  }

  @override
  String get onboarding_local_remove => 'Remover pasta';

  @override
  String get onboarding_local_in_downloads =>
      'Esta é a pasta de transferências da app.';

  @override
  String get onboarding_local_empty =>
      'Nada encontrado. Escolha a pasta principal.';

  @override
  String get onboarding_repo_failed => 'Não foi possível ler o repositório.';

  @override
  String get onboarding_repo_title => 'Adicionar fonte';

  @override
  String get onboarding_body =>
      'Adicione um repositório para disponibilizar extensões.';

  @override
  String get onboarding_add => 'Adicionar repositório';

  @override
  String get onboarding_skip => 'Ignorar por agora';

  @override
  String get onboarding_continue => 'Continuar';

  @override
  String get onboarding_later =>
      'Pode adicionar mais tarde em Definições > Explorar.';

  @override
  String get onboarding_replay => 'Mostrar ecrã de boas-vindas';

  @override
  String get onboarding_replay_subtitle =>
      'Abre novamente o ecrã inicial de configuração.';

  @override
  String get missing_source_check_title => 'Verificar fontes em falta';

  @override
  String get missing_source_check_subtitle =>
      'Encontra entradas cuja extensão não está instalada.';

  @override
  String get missing_source_check_none_found =>
      'Todas as fontes da biblioteca estão instalada.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count fontes',
      one: 'Falta 1 fonte',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Nenhuma fonte de $itemType instalada.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Adicione um repositório em Procurar e, em seguida, instale uma extensão correspondente.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fontes',
      one: '1 fonte',
    );
    return 'Você tem $_temp0 para isto, mas apenas as fixadas são pesquisadas.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Fixe uma fonte ou desative \"Apenas incluir fontes fixadas\" nas configurações de Procurar.';

  @override
  String get global_search_all_nsfw =>
      'Todas as suas fontes para isto estão marcadas como NSFW e estão ocultas.';

  @override
  String get global_search_all_nsfw_hint =>
      'Ative as fontes NSFW nas configurações de Procurar para pesquisar nelas.';

  @override
  String get missing_source_check_result_message =>
      'Estas entradas apontam para fontes não instaladas. Toque para migrar ou instale a extensão.';

  @override
  String get related_titles => 'Relacionados';

  @override
  String get related_none =>
      'Nenhum título relacionado encontrado para esta obra.';

  @override
  String get relation_adaptation => 'Adaptação';

  @override
  String get relation_sequel => 'Sequência';

  @override
  String get relation_prequel => 'Prequência';

  @override
  String get relation_parent => 'História principal';

  @override
  String get relation_side_story => 'História paralela';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Versão alternativa';

  @override
  String get auto_library_update => 'Atualizações automáticas da biblioteca';

  @override
  String get auto_library_update_subtitle =>
      'Verificar novos capítulos para cada item da biblioteca ao iniciar o aplicativo.';

  @override
  String get auto_library_update_never => 'Nunca';

  @override
  String get auto_library_update_12_hours => 'A cada 12 horas';

  @override
  String get auto_library_update_daily => 'Diariamente';

  @override
  String get auto_library_update_2_days => 'A cada 2 dias';

  @override
  String get auto_library_update_weekly => 'Semanalmente';

  @override
  String get auto_library_update_wifi_only => 'Apenas no Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Ignorar a atualização agendada quando estiver em dados móveis.';

  @override
  String get padding => 'Espaçamento';

  @override
  String get page_mode => 'Modo de página';

  @override
  String get single_page => 'Página única';

  @override
  String get double_page => 'Página dupla';

  @override
  String get speed => 'Velocidade';

  @override
  String get theme_dark => 'Escuro';

  @override
  String get theme_light => 'Claro';

  @override
  String get theme_black => 'Preto';

  @override
  String get theme_sepia => 'Sépia';

  @override
  String get decrease => 'Diminuir';

  @override
  String get increase => 'Aumentar';

  @override
  String get chapter_swipe_actions => 'Ações de deslize de capítulo';

  @override
  String get chapter_swipe_start => 'Deslizar para a direita';

  @override
  String get chapter_swipe_end => 'Deslizar para a esquerda';

  @override
  String get chapter_swipe_toggle_bookmark => 'Alternar marcador';

  @override
  String get chapter_swipe_toggle_read => 'Alternar lido';

  @override
  String get chapter_swipe_download => 'Baixar';

  @override
  String get chapter_swipe_disabled => 'Desativado';

  @override
  String get update_errors => 'Erros de atualização';

  @override
  String get no_update_errors => 'Sem erros de atualização';

  @override
  String get clear_all => 'Limpar tudo';

  @override
  String get dismiss => 'Demitir';

  @override
  String get previous_episode => 'Episódio anterior';

  @override
  String get clear_logs => 'Limpar registros';

  @override
  String get bold => 'Negrito';

  @override
  String get italic => 'Itálico';

  @override
  String get color_yellow => 'Amarelo';

  @override
  String get color_cyan => 'Ciano';

  @override
  String get color_green => 'Verde';

  @override
  String get color_orange => 'Laranja';

  @override
  String get continue_watching => 'Continuar assistindo';

  @override
  String get search_your_anime => 'Pesquise seu anime';

  @override
  String get category => 'Categoria';

  @override
  String get hidden_categories => 'Categorias ocultas';

  @override
  String get new_category => 'Nova categoria';

  @override
  String get local => 'Locais';

  @override
  String get tv_home_rows => 'Linhas';

  @override
  String get genre_rows => 'Linhas de gênero';

  @override
  String get share_backup_file =>
      'Compartilhar arquivo de backup NodeLane Comics';

  @override
  String get close => 'Fechar';

  @override
  String get migrate_source => 'Fonte de migração';

  @override
  String get cloudflare_bypass_proxy => 'Proxy de desvio da Cloudflare';

  @override
  String get custom_doh_url => 'DoH personalizado URL';

  @override
  String get custom_doh_url_helper => 'Deve ser um endpoint https DoH (JSON)';

  @override
  String get anime_only_tv_layout => 'Layout de TV somente anime';

  @override
  String get anime_only_beta => 'Somente anime (beta)';

  @override
  String get tv_home_beta => 'TV doméstica (beta)';

  @override
  String get tv_player_beta => 'Reprodutor de TV (beta)';

  @override
  String get network_settings => 'Rede';

  @override
  String get reader_page_layout => 'Layout de página';

  @override
  String get reader_continuous_options => 'Leitura contínua';

  @override
  String get reader_default_mode_hint =>
      'O modo de leitura padrão aplica-se a títulos sem um modo individual definido durante a leitura.';

  @override
  String get extension_service => 'Serviço de extensão';

  @override
  String get extension_service_description =>
      'Gerenciar o tempo de execução da extensão e o endereço do proxy.';

  @override
  String get proxy_address => 'Endereço proxy';

  @override
  String get checking_runtime_status => 'Verificando status…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + atraso aleatório';
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
      'Adicionar downloads da lista de capítulos de um título.';

  @override
  String get download_queue_order_hint => 'Arraste as alças para reordenar';

  @override
  String get download_queue_empty => 'Nenhum download na fila';

  @override
  String get download_queue_actions => 'Ações de download';

  @override
  String get download_queue_cancel_chapter =>
      'Cancelar o download deste capítulo';

  @override
  String get download_queue_cancel_series =>
      'Cancelar todos os downloads deste título';

  @override
  String get download_queue_start => 'Iniciar downloads';

  @override
  String get download_queue_retry => 'Tentar novamente downloads';

  @override
  String get download_queue_active => 'Baixando';

  @override
  String get download_queue_waiting => 'Aguardando download';

  @override
  String get download_queue_failed => 'Falha no download';

  @override
  String get cf_proxy_helper =>
      'Ponto final FlareSolverr/Byparr. Deixe em branco para desabilitar.';

  @override
  String get mobile_navigation_description =>
      'Arraste para reordenar. Mangá, anime e romances compartilham a aba Biblioteca. O primeiro item visível é aberto no lançamento. Navegar e mais permanecem visíveis; guias extras aparecem em Mais.';

  @override
  String get text_align_justify => 'Justificar';

  @override
  String get novel_session_modes_hint =>
      'Definir modo de leitura e páginas simples ou duplas durante a leitura de um título.';

  @override
  String get tts_languages_failed =>
      'Não foi possível carregar idiomas do mecanismo de fala.';

  @override
  String get tts_languages_empty =>
      'O mecanismo de fala não retornou nenhum idioma. Sua seleção salva é mantida.';

  @override
  String get tts_language_unavailable =>
      'Este idioma salvo não está na lista atual do dispositivo.';

  @override
  String get tts_apply_failed =>
      'Não foi possível aplicar esta configuração ao mecanismo de fala. Você pode tentar novamente.';

  @override
  String get player_controls => 'Controles';

  @override
  String get audio_channel_auto => 'Automático';

  @override
  String get audio_channel_auto_safe => 'Automático (seguro)';

  @override
  String get audio_channel_mono => 'Mono';

  @override
  String get audio_channel_stereo => 'Estéreo';

  @override
  String get audio_channel_reverse_stereo => 'Estéreo reverso';

  @override
  String get mpv_bundled_config_hint =>
      'Restaure a configuração, scripts e shaders incluídos no aplicativo. Arquivos com os mesmos nomes serão substituídos.';

  @override
  String get mpv_restore_bundled => 'Restaurar configuração agrupada';

  @override
  String get mpv_restore_confirm =>
      'Restaurar a configuração MPV incluída? Configurações, scripts e shaders existentes com os mesmos nomes serão substituídos. Outros arquivos serão mantidos.';

  @override
  String get player_operation_incomplete =>
      'A operação não pôde ser concluída. Verifique o acesso ao arquivo e tente novamente.';

  @override
  String get custom_buttons_empty_hint =>
      'Adicionar um botão de player com um rótulo e uma ação de pressionar.';

  @override
  String get custom_button_primary => 'Botão padrão';

  @override
  String get show_password => 'Mostrar senha';

  @override
  String get hide_password => 'Ocultar senha';

  @override
  String get tracking_accounts_empty =>
      'Conecte um serviço nas configurações de Rastreamento para gerenciar suas entradas.';

  @override
  String get tracking_entries_empty =>
      'Nenhuma entrada rastreada para este tipo de mídia. Adicione rastreamento da página de detalhes de um título.';

  @override
  String get change_tracking_match => 'Alterar título correspondente';

  @override
  String get remove_tracking => 'Remover rastreamento';

  @override
  String remove_tracking_confirm(String title) {
    return 'Remover o link de rastreamento para “$title”? A entrada no serviço de rastreamento será mantida.';
  }

  @override
  String get tracking_refresh_required =>
      'O estado de rastreamento não pôde ser confirmado. Atualize antes de fazer outra alteração.';

  @override
  String get tracking_entry_unlinked =>
      'Este registro não está vinculado a um título local, portanto não pode ser editado aqui.';

  @override
  String get backup_selection_shared =>
      'As alterações nessas seleções são salvas imediatamente e também se aplicam a backups automáticos.';

  @override
  String get library_snapshot_history =>
      'Restaurar um instantâneo de biblioteca';

  @override
  String get library_snapshot_empty =>
      'Não há instantâneos de segurança disponíveis.';

  @override
  String get library_snapshot_restore_message =>
      'Os dados atuais serão substituídos por este instantâneo. As alterações feitas desde então serão perdidas. Os downloads excluídos não podem ser restaurados. Os instantâneos de segurança disponíveis serão apagados após sucesso.';

  @override
  String get library_maintenance_working => 'Atualizando biblioteca…';

  @override
  String get library_safety_snapshot_note =>
      'Um instantâneo de segurança será salvo antes desta operação. Não inclui arquivos baixados.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Entradas de biblioteca: $mangaCount. Capítulos: $chapterCount. Entradas do histórico: $historyCount. Atualizações: $updateCount.\n\nEscolha o que manter abaixo.';
  }

  @override
  String get library_delete_pick_message =>
      'Escolha uma fonte para revisar seu conteúdo e opções de exclusão.';

  @override
  String get mobile_categories_hint =>
      'Arraste para reordenar. Abra uma categoria para renomeá-la ou alterar sua visibilidade e atualizações.';

  @override
  String get mobile_category_visible => 'Mostrar na biblioteca';

  @override
  String get mobile_category_hidden => 'Escondido da biblioteca';

  @override
  String get mobile_category_updates =>
      'Incluir nas atualizações da biblioteca';

  @override
  String get statistics_watched => 'Assisti';

  @override
  String get calendar_month => 'Mês';

  @override
  String get calendar_two_weeks => '2 semanas';

  @override
  String get calendar_week => 'Semana';

  @override
  String get calendar_show_all_dates => 'Mostrar todas as datas';

  @override
  String get update_check_no_result =>
      'Nenhuma atualização instalável encontrada. Você pode tentar novamente mais tarde.';

  @override
  String get release_notes => 'Notas de lançamento';

  @override
  String get no_release_notes => 'Nenhuma nota de versão é fornecida.';

  @override
  String get downloading_update => 'Baixando atualização…';

  @override
  String get preparing_installation => 'Preparando a instalação…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Escolha o que ler. Você pode alterar isso mais tarde.';

  @override
  String get onboarding_content_title => 'Comece a ler';

  @override
  String get onboarding_mobile_sources_body =>
      'Escolha uma forma de começar ou adicione conteúdo mais tarde.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Etapa $step de $total';
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
      other: 'Fontes $count',
      one: '1 fonte',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Busca pelo título de destino.';

  @override
  String get migration_original_item => 'Item atual';

  @override
  String get migration_target_item => 'Item selecionado';

  @override
  String get migration_partial_failure =>
      'A operação não terminou. Algumas alterações podem ter sido salvas. Verifique este item na sua biblioteca antes de tentar novamente.';

  @override
  String get migration_no_categories =>
      'Sem categorias. Você pode adicionar este item sem uma categoria.';

  @override
  String get mass_migration_select_source => 'Escolha a fonte atual';

  @override
  String get mass_migration_select_all => 'Selecionar tudo';

  @override
  String get mass_migration_deselect_all => 'Desmarcar tudo';

  @override
  String get mass_migration_needs_review => 'Revisar migrações incompletas';

  @override
  String get bookshelf_actions => 'Ações de estante';

  @override
  String get bookshelf_ignore_filters => 'Ignorar filtros ao pesquisar';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Pesquisar todas as obras desta categoria, inclusive aquelas ocultadas por filtros.';

  @override
  String get bookshelf_stop_update => 'Parar atualização da biblioteca';

  @override
  String bookshelf_selected_count(int count) {
    return '$count trabalhos selecionados';
  }

  @override
  String get bookshelf_remove_library => 'Remover da estante';

  @override
  String get bookshelf_remove_library_hint =>
      'Remove favoritos. As importações locais também perdem sua biblioteca e registros de leitura.';

  @override
  String get bookshelf_remove_downloads => 'Excluir arquivos baixados';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Remove arquivos baixados enquanto mantém informações de trabalho.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Também exclui arquivos importados locais selecionados e remove seus registros de biblioteca. Esses arquivos não podem ser recuperados aqui.';

  @override
  String get bookshelf_remove_incomplete =>
      'A operação não terminou. Algumas obras ou arquivos podem ter sido processados. Feche esta caixa de diálogo e verifique sua estante e downloads antes de continuar.';

  @override
  String get bookshelf_processing => 'Processamento…';

  @override
  String get bookshelf_mark_read => 'Marcar lida';

  @override
  String get bookshelf_mark_unread => 'Marcar como não lida';

  @override
  String get bookshelf_select_all => 'Selecionar tudo';

  @override
  String get bookshelf_invert_selection => 'Inverter seleção';

  @override
  String get bookshelf_settings => 'Configurações da estante';

  @override
  String get bookshelf_settings_live =>
      'As alterações de filtragem, classificação e exibição entram em vigor imediatamente.';

  @override
  String get bookshelf_filter_any => 'Qualquer';

  @override
  String get bookshelf_filter_include => 'Incluir';

  @override
  String get bookshelf_filter_exclude => 'Excluir';

  @override
  String get bookshelf_all_sources => 'Todas as fontes';

  @override
  String bookshelf_sources_selected(int count) {
    return 'Fontes $count selecionadas';
  }

  @override
  String get bookshelf_sort_ascending => 'Ascendente';

  @override
  String get bookshelf_sort_descending => 'Descendente';

  @override
  String get bookshelf_layout => 'Layout de estante';

  @override
  String get bookshelf_sources_hint =>
      'Selecione nenhum para mostrar todas as fontes. As alterações se aplicam quando você toca em Filtro.';

  @override
  String get bookshelf_choose_files => 'Escolher arquivos';

  @override
  String get bookshelf_import_wait =>
      'Escolha um arquivo no seletor e aguarde o término da importação.';

  @override
  String get bookshelf_import_incomplete =>
      'A importação não foi concluída. Alguns arquivos podem já estar na sua estante. Feche esta caixa de diálogo e verifique antes de importar novamente.';

  @override
  String get bookshelf_categories_replace =>
      'Salvar atribui essas categorias a cada obra selecionada, substituindo suas categorias anteriores.';

  @override
  String get bookshelf_categories_hint =>
      'Escolha uma ou mais categorias, ou deixe a seleção vazia para não atribuir nenhuma.';

  @override
  String get bookshelf_categories_hidden =>
      'As categorias ocultas existentes são mantidas para este trabalho.';

  @override
  String get bookshelf_categories_incomplete =>
      'As categorias não puderam ser salvas completamente. Feche esta caixa de diálogo e verifique a estante antes de tentar novamente.';

  @override
  String get bookshelf_categories_none_visible =>
      'Nenhuma categoria está disponível aqui. Abra o gerenciamento de categorias para revisá-los.';

  @override
  String get bookshelf_manage_categories => 'Gerenciar categorias';

  @override
  String get manga_actions => 'Ações cômicas';

  @override
  String get manga_download_scope => 'Baixar capítulos';

  @override
  String get manga_download_scope_hint =>
      'Escolher capítulos dentro dos filtros atuais. Os capítulos baixados são ignorados.';

  @override
  String get manga_download_scope_empty =>
      'Nenhum capítulo corresponde aos filtros atuais. Feche este menu e ajuste os filtros dos capítulos.';

  @override
  String get manga_action_incomplete =>
      'A ação não terminou. Verifique o estado atual antes de tentar novamente.';

  @override
  String get chapter_settings => 'Configurações de capítulo';

  @override
  String get chapter_settings_live =>
      'As alterações de filtragem e classificação são aplicadas imediatamente.';

  @override
  String get chapter_scanlators_all => 'Mostrar todos os grupos de scanlators';

  @override
  String get chapter_scanlators_hint =>
      'Selecionar grupos para ocultar seus capítulos. As alterações se aplicam quando você toca em Filtro.';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count grupos de scanlator ocultos';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count capítulos selecionados';
  }

  @override
  String get chapter_add_bookmark => 'Marcador';

  @override
  String get chapter_remove_bookmark => 'Desmarcar';

  @override
  String get chapter_read_following => 'Leia abaixo';

  @override
  String get chapter_delete_records => 'Excluir registros de capítulo';

  @override
  String get chapter_delete_local_hint =>
      'Remove os registros do capítulo selecionado e o progresso da leitura. Os arquivos locais originais são mantidos; as cópias baixadas são limpas.';

  @override
  String get chapter_delete_last_hint =>
      'Todos esses são capítulos desta história em quadrinhos. Excluí-los também remove os quadrinhos da sua estante.';

  @override
  String get chapter_action_incomplete =>
      'A ação não terminou. Algumas alterações já podem estar salvas. Feche e verifique os capítulos e downloads antes de continuar.';

  @override
  String get reader_display_scope =>
      'Modo de leitura e layout de página manual se aplicam a esta história em quadrinhos. Escolha uma alteração para retornar à leitura.';

  @override
  String get reader_display_single_only =>
      'A leitura contínua horizontal utiliza páginas únicas.';

  @override
  String get reader_display_manual_pages =>
      'A alteração do layout da página desativa a página dupla automática para todos os quadrinhos.';

  @override
  String get reader_display_crop_scope => 'Aplica-se a todos os quadrinhos.';

  @override
  String get reader_chapter_locate => 'Localizar o capítulo atual';

  @override
  String get reader_chapter_search => 'Pesquisar capítulos ou scanlators';

  @override
  String get reader_chapter_scope =>
      'Utiliza os filtros de capítulo e a ordem de classificação dos detalhes dos quadrinhos. Os marcadores são salvos imediatamente.';

  @override
  String get reader_chapter_current_hidden =>
      'O capítulo que você está lendo está fora dos filtros atuais.';

  @override
  String get reader_chapter_current => 'Lendo agora';

  @override
  String get reader_chapter_read => 'Ler';

  @override
  String get reader_chapter_bookmark_failed =>
      'O salvamento do marcador não pôde ser confirmado. Feche a lista e verifique seu estado atual.';

  @override
  String get reader_image_actions => 'Ações de imagem';

  @override
  String get reader_image_original =>
      'Utiliza a página original completa, sem tradução, recorte ou filtros de cores do leitor.';

  @override
  String get reader_image_save_ios =>
      'Salve na pasta Imagens no local de armazenamento atual do aplicativo.';

  @override
  String get reader_image_save_android =>
      'Salve na pasta Pictures/nodelane-comics do dispositivo.';

  @override
  String get reader_image_share =>
      'Abra a planilha de compartilhamento do sistema.';

  @override
  String get reader_image_cover =>
      'Alterar a capa deste quadrinho após confirmação.';

  @override
  String get reader_image_cover_limit =>
      'As imagens de capa devem ser menores que 5 MB. Salvar e compartilhar permanecem disponíveis.';

  @override
  String get reader_image_action_failed =>
      'A ação não pôde ser confirmada. Feche este menu e verifique o resultado antes de tentar novamente.';

  @override
  String get reader_settings_book_scope =>
      'Essas configurações se aplicam apenas a esta história em quadrinhos.';

  @override
  String get reader_settings_global_scope =>
      'Essas configurações se aplicam a todos os quadrinhos e são salvas imediatamente.';

  @override
  String get reader_filters => 'Filtros de imagem';

  @override
  String get reader_filter_scope =>
      'Aplica-se a todos os quadrinhos. Altera a exibição de leitura sem modificar as imagens originais.';

  @override
  String get reader_auto_scroll_pause =>
      'A rolagem é pausada enquanto as configurações estão abertas.';

  @override
  String get manga_synopsis => 'Sinopse';

  @override
  String manga_author(String author) {
    return 'Autor: $author';
  }

  @override
  String get manga_continue_reading => 'Continue lendo';

  @override
  String get reader_settings_title => 'Configurações do leitor';

  @override
  String get reader_picker_book_scope =>
      'Somente para esta história em quadrinhos';

  @override
  String get reader_picker_global_scope => 'Aplica-se a todos os quadrinhos';

  @override
  String get reader_picker_apply_hint =>
      'Toque para salvar e retornar ao nível anterior.';

  @override
  String get reader_scale_fit_screen_hint => 'Ajustar a página inteira na tela';

  @override
  String get reader_scale_stretch_hint => 'Preencher a área de leitura';

  @override
  String get reader_scale_fit_width_hint => 'Ajustar a página à largura';

  @override
  String get reader_scale_fit_height_hint => 'Ajustar a página à altura';

  @override
  String get source_filter_active => 'Aplicado';

  @override
  String get source_filter_apply => 'Aplicar filtros';

  @override
  String get source_filter_scope => 'Os filtros se aplicam apenas a este site.';

  @override
  String get source_filter_apply_hint =>
      'Aplique filtros para usar suas seleções.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Gêneros',
      'author': 'Autor',
      'artist': 'Artista',
      'title': 'Título',
      'year': 'Ano',
      'tags': 'Etiquetas',
      'format': 'Formato',
      'publisher': 'Editora',
      'relevance': 'Relevância',
      'rating': 'Classificação',
      'views': 'Vistas',
      'random': 'Aleatório',
      'all': 'Todos',
      'none': 'Nenhum',
      'action': 'Ação',
      'adventure': 'Aventura',
      'comedy': 'Comédia',
      'drama': 'Drama',
      'fantasy': 'Fantasia',
      'romance': 'Romance',
      'science_fiction': 'Ficção científica',
      'slice_of_life': 'Fatia de vida',
      'mystery': 'Mistério',
      'horror': 'Terror',
      'psychological': 'Psicológico',
      'historical': 'Histórico',
      'sports': 'Esportes',
      'supernatural': 'Sobrenatural',
      'school_life': 'Vida escolar',
      'tragedy': 'Tragédia',
      'shounen': 'Shonen',
      'shoujo': 'Shojo',
      'seinen': 'Seinen',
      'josei': 'Josei',
      'isekai': 'Isekai',
      'martial_arts': 'Artes marciais',
      'mecha': 'Mecha',
      'music': 'Música',
      'doujinshi': 'Doujinshi',
      'trending': 'Tendências',
      'new': 'Novo',
      'adult_content': 'Conteúdo adulto',
      'only': 'Somente',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'Mais opções de exibição';

  @override
  String get bookshelf_more_display_hint => 'Emblemas, fontes e categorias';

  @override
  String get bookshelf_download_count => 'Contagem de downloads';

  @override
  String get bookshelf_source_global_hint =>
      'A visibilidade da fonte utiliza a preferência de exibição compartilhada.';

  @override
  String get bookshelf_select_entries => 'Selecionar obras';

  @override
  String get bookshelf_search_options => 'Opções de pesquisa';

  @override
  String get bookshelf_empty_hint =>
      'Colete obras de fontes ou importe arquivos locais.';

  @override
  String get bookshelf_no_match_hint =>
      'Experimente outras palavras-chave ou ajuste os filtros atuais.';

  @override
  String get bookshelf_clear_query => 'Limpar palavras-chave';

  @override
  String get bookshelf_view_selection => 'Visualizar trabalhos selecionados';

  @override
  String get bookshelf_import_formats =>
      'Escolha um arquivo local para adicioná-lo à sua estante.';

  @override
  String get bookshelf_import_canceled_hint =>
      'Você pode escolher novamente após cancelar o seletor de arquivos.';

  @override
  String get bookshelf_browse_sources => 'Procurar fontes';

  @override
  String get bookshelf_empty_title => 'Sua estante está vazia';

  @override
  String get bookshelf_no_match_title => 'Nenhuma correspondência funciona';

  @override
  String get bookshelf_mark_watched => 'Mark assistiu';

  @override
  String get bookshelf_mark_unwatched => 'Marcar não assistido';

  @override
  String get nodelane_account => 'NodeLane';

  @override
  String get nodelane_sign_in => 'Faça login em NodeLane';

  @override
  String get nodelane_account_intro =>
      'Visualize sua conta, assinatura e cota de tradução';

  @override
  String get nodelane_login_action => 'Continuar a fazer login';

  @override
  String get nodelane_login_browser =>
      'Faça login através do navegador do sistema e retorne ao aplicativo';

  @override
  String get nodelane_account_id => 'ID da conta';

  @override
  String get nodelane_account_init_error =>
      'O armazenamento da conta não está disponível. Reinicie o aplicativo e tente novamente.';

  @override
  String get nodelane_account_refresh_error =>
      'Não foi possível atualizar as informações da conta';

  @override
  String get nodelane_account_auth_error =>
      'Sua sessão expirou. Faça login novamente';

  @override
  String get nodelane_account_unknown =>
      'As informações de assinatura não estão disponíveis';

  @override
  String get nodelane_account_current => 'Assinatura atual';

  @override
  String get nodelane_account_free => 'Conta gratuita';

  @override
  String get nodelane_account_no_subscription => 'Nenhuma assinatura ativa';

  @override
  String get nodelane_account_active => 'Ativo';

  @override
  String get nodelane_account_expired => 'Expirado';

  @override
  String get nodelane_account_expiry => 'Válido até';

  @override
  String get nodelane_account_renewal => 'Renovação';

  @override
  String get nodelane_renewal_auto => 'Renovação automática';

  @override
  String get nodelane_renewal_manual => 'Renovação manual';

  @override
  String get nodelane_renewal_stopped => 'Renovação automática interrompida';

  @override
  String get nodelane_renewal_gift => 'Associação de presente';

  @override
  String get nodelane_renewal_attention =>
      'Verifique seu status de renovação no site';

  @override
  String get nodelane_next_billing => 'Próxima data de faturamento';

  @override
  String get nodelane_billing_unavailable =>
      'As informações de renovação não estão disponíveis';

  @override
  String get nodelane_manage_account => 'Gerenciar no site';

  @override
  String get nodelane_view_plans => 'Ver planos de assinatura';

  @override
  String get nodelane_translation_quota => 'Cota de tradução';

  @override
  String get nodelane_quota_free => 'Cota gratuita';

  @override
  String get nodelane_quota_subscription => 'Cota de assinatura';

  @override
  String get nodelane_quota_purchase => 'Cota adquirida';

  @override
  String get nodelane_quota_details => 'Ver detalhes da cota';

  @override
  String get nodelane_quota_expanded => 'Detalhes da cota';

  @override
  String get nodelane_quota_unlimited => 'Ilimitado';

  @override
  String get nodelane_quota_not_subscribed => 'Não inscrito';

  @override
  String get nodelane_quota_unknown => 'Indisponível';

  @override
  String get nodelane_quota_used => 'Usado';

  @override
  String get nodelane_quota_reserved => 'Em andamento';

  @override
  String get nodelane_quota_reset => 'Próxima reinicialização';

  @override
  String get nodelane_quota_expiry => 'Próximo vencimento';

  @override
  String get nodelane_quota_no_expiry => 'Sem prazo de validade';

  @override
  String get nodelane_quota_reservation_note =>
      'As páginas em andamento já são deduzidas da cota disponível';

  @override
  String nodelane_quota_available(int count) {
    return '$count páginas restantes';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count páginas';
  }

  @override
  String get nodelane_sign_out => 'Sair';

  @override
  String get nodelane_sign_out_confirm =>
      'Sair pausa a tradução oficial neste dispositivo. Sua biblioteca e o progresso da leitura são mantidos.';

  @override
  String get settings_search_hint => 'Configurações de pesquisa';

  @override
  String get settings_frequent => 'Frequentemente usado';

  @override
  String get settings_reading_translation => 'Leitura e tradução';

  @override
  String get settings_app_preferences => 'Preferências do aplicativo';

  @override
  String get settings_data_management => 'Dados e gerenciamento';

  @override
  String get settings_more_tools => 'Mais ferramentas';

  @override
  String get settings_more_tools_hint =>
      'Categorias, estatísticas e calendário';

  @override
  String get settings_appearance_interface => 'Aparência e interface';

  @override
  String get settings_security_privacy => 'Segurança e privacidade';

  @override
  String get settings_source_preferences => 'Configurações de fonte';

  @override
  String get settings_about_help => 'Sobre e ajuda';

  @override
  String get settings_storage_backup => 'Armazenamento e backup';

  @override
  String settings_pending_downloads(int count) {
    return '$count pendente';
  }

  @override
  String get settings_translation_language => 'Linguagem de tradução';

  @override
  String get settings_translation_scope =>
      'Usado no leitor e na tradução de páginas da web';

  @override
  String get settings_immediate_choice =>
      'As alterações aplicam-se imediatamente';

  @override
  String get settings_translation_init_error =>
      'As configurações de tradução não estão disponíveis. Reinicie o aplicativo e tente novamente.';

  @override
  String get settings_local_cache => 'Cache local';

  @override
  String get settings_chapter_cache => 'Cache de capítulos e episódios';

  @override
  String get settings_cover_cache => 'Cobrir cache';

  @override
  String get settings_translation_cache => 'Cache de imagens traduzidas';

  @override
  String get settings_translation_cache_hint =>
      'Manter registros de tradução e recuperar imagens traduzidas novamente quando necessário';

  @override
  String get settings_cache_clear => 'Limpar';

  @override
  String get settings_translation_cache_done =>
      'Cache de imagem traduzida limpo; registros de tradução mantidos';

  @override
  String settings_cache_confirmation(String name) {
    return 'Limpar $name? O conteúdo armazenado em cache pode ser recuperado novamente. As entradas da biblioteca serão mantidas.';
  }

  @override
  String get settings_advanced_options => 'Opções avançadas';

  @override
  String get settings_manga_reader => 'Leitor de mangá';

  @override
  String get settings_novel_reader => 'Leitor de romance';

  @override
  String get settings_downloads => 'Configurações de download';

  @override
  String get onboarding_welcome => 'Bem-vindo ao';

  @override
  String get onboarding_reading_content => 'Leitura de conteúdo';

  @override
  String get onboarding_choose_one => 'Escolha pelo menos um';

  @override
  String get onboarding_restore_hint =>
      'Restaure sua biblioteca a partir de um backup';

  @override
  String get onboarding_browse_hint => 'Encontre títulos em sites suportados';

  @override
  String get onboarding_import_folder => 'Importar uma pasta local';

  @override
  String get onboarding_import_folder_hint =>
      'Leia mangás, romances e animes no seu dispositivo';

  @override
  String get onboarding_third_party => 'Adicionar um repositório de terceiros';

  @override
  String get onboarding_third_party_hint =>
      'Use um endereço de repositório que você já possui';

  @override
  String get onboarding_repository_hint =>
      'Insira o endereço fornecido pelo repositório.';

  @override
  String get onboarding_repository_address => 'Endereço';

  @override
  String get onboarding_repository_address_hint =>
      'Insira o endereço do repositório';

  @override
  String get onboarding_add_repository => 'Adicionar repositório';

  @override
  String get onboarding_start => 'Comece';

  @override
  String get onboarding_open_library => 'Biblioteca aberta';

  @override
  String get onboarding_view_imports => 'Visualizar conteúdo importado';

  @override
  String get onboarding_view_folders => 'Ver pastas';

  @override
  String get notice_backup_created => 'Backup criado';

  @override
  String get notice_backup_ready => 'Salve ou compartilhe o arquivo de backup.';

  @override
  String get notice_backup_restored => 'Backup restaurado';

  @override
  String get notice_backup_unsupported =>
      'Este formato de backup não é suportado.';

  @override
  String get notice_verification_required => 'Verificação do site necessária';

  @override
  String get notice_verification_hint =>
      'Conclua a verificação para continuar navegando.';

  @override
  String get notice_verify => 'Verificar site';

  @override
  String get notice_action_incomplete =>
      'A ação não terminou. Verifique o resultado antes de tentar novamente.';

  @override
  String get notice_library_updating => 'Atualizando biblioteca';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'Títulos $current / $total verificados';
  }

  @override
  String get notice_library_failed =>
      'Alguns títulos não puderam ser atualizados';

  @override
  String get notice_import_completed => 'Importação concluída';

  @override
  String get notice_operation_incomplete => 'Ação incompleta';

  @override
  String get subtitle_service => 'Serviço de legendas on-line';

  @override
  String get subtitle_service_mode => 'Fonte de legenda';

  @override
  String get subtitle_service_disabled =>
      'Desligado · limpar credenciais salvas';

  @override
  String get subtitle_personal_key => 'Minha chave Wyzie';

  @override
  String get subtitle_custom_service => 'Meu serviço de legendas';

  @override
  String get subtitle_key => 'Wyzie API Chave';

  @override
  String get subtitle_key_hint =>
      'Insira sua própria chave Wyzie. Ele permanece neste dispositivo e não é incluído nos backups de aplicativos.';

  @override
  String get subtitle_get_key => 'Obtenha uma chave pessoal';

  @override
  String get subtitle_service_address => 'Pesquisa de legenda URL';

  @override
  String get subtitle_service_token => 'Token de acesso ao serviço (opcional)';

  @override
  String get subtitle_custom_hint =>
      'Use a pesquisa HTTPS URL completa de um serviço Wyzie-compatible, incluindo seu caminho (por exemplo, /search). Insira um token de acesso somente se o seu serviço exigir um.';

  @override
  String get subtitle_service_off_hint =>
      'A pesquisa de legendas online está desativada. Legendas incorporadas, fornecidas pela fonte e locais permanecem disponíveis.';

  @override
  String get subtitle_setup_required =>
      'Escolha um serviço de legenda antes de pesquisar.';

  @override
  String get subtitle_invalid_key => 'Insira uma chave sem espaços.';

  @override
  String get subtitle_invalid_address =>
      'Use um HTTPS URL completo sem consulta, fragmento ou credenciais incorporadas.';

  @override
  String get subtitle_invalid_token =>
      'O token de acesso não pode conter espaços.';

  @override
  String get subtitle_storage_failed =>
      'Não foi possível ler ou salvar as configurações de legenda. Por favor, tente novamente.';

  @override
  String get subtitle_auth_failed =>
      'O serviço de legendas recusou o acesso. Verifique sua chave ou token de serviço.';

  @override
  String get subtitle_quota_exhausted =>
      'A cota do serviço de legendas está esgotada. Verifique sua conta com esse serviço.';

  @override
  String get subtitle_network_failed =>
      'Não foi possível acessar o serviço de legendas. Por favor, tente novamente.';

  @override
  String get subtitle_response_invalid =>
      'O serviço de legenda retornou uma resposta ou arquivo não suportado.';

  @override
  String get detail_loading_chapters => 'Carregando capítulos…';

  @override
  String get reader_opening_chapter => 'Capítulo de abertura';

  @override
  String get reader_open_chapter => 'Abrir capítulo';

  @override
  String get reader_loading_pages => 'Obtendo imagens de capítulo…';

  @override
  String get reader_loading_pages_hint =>
      'A leitura começará automaticamente quando estiver pronta.';

  @override
  String get reader_loading_failed => 'Não foi possível carregar este capítulo';

  @override
  String get reader_loading_retry_hint =>
      'Verifique sua conexão e tente novamente.';

  @override
  String get reader_no_pages => 'Nenhuma imagem encontrada para este capítulo';

  @override
  String get reader_loading_previous => 'Carregando capítulo anterior…';

  @override
  String get reader_previous_failed =>
      'Não foi possível carregar o capítulo anterior';

  @override
  String get reader_reached_start => 'Você chegou ao primeiro capítulo';

  @override
  String get reader_loading_next => 'Carregando próximo capítulo…';

  @override
  String get reader_next_failed =>
      'Não foi possível carregar o próximo capítulo';

  @override
  String get reader_image_loading => 'Carregando imagem…';

  @override
  String get reader_image_failure_hint =>
      'Você pode continuar lendo outras páginas.';

  @override
  String get comic_paged => 'Página por página';

  @override
  String get comic_scroll => 'Role para baixo';

  @override
  String get comic_book_scope =>
      'Aplica-se apenas a este livro · alterações salvas imediatamente';

  @override
  String get comic_defaults_title => 'Padrões e hábitos';

  @override
  String get comic_defaults_hint =>
      'Os padrões se aplicam a campos que você não personalizou para um livro.';

  @override
  String get comic_habits_hint =>
      'Esses hábitos se aplicam a todos os quadrinhos.';

  @override
  String get comic_turn => 'Deslize para a próxima página';

  @override
  String get comic_left => 'Esquerda';

  @override
  String get comic_right => 'Certo';

  @override
  String get comic_up => 'Acima';

  @override
  String get comic_fit => 'Ajuste de página';

  @override
  String get comic_fit_contain => 'Página inteira';

  @override
  String get comic_fit_width => 'Ajustar largura';

  @override
  String get comic_fit_height => 'Altura de ajuste';

  @override
  String get comic_layout => 'Layout de página';

  @override
  String get comic_auto => 'Automático';

  @override
  String get comic_layout_hint =>
      'Auto mostra uma propagação quando há largura suficiente.';

  @override
  String get comic_width => 'Largura do conteúdo';

  @override
  String get comic_full => 'Completo';

  @override
  String get comic_comfortable => 'Confortável';

  @override
  String get comic_narrow => 'Estreito';

  @override
  String get comic_gap => 'Espaçamento entre páginas';

  @override
  String get comic_no_gap => 'Sem costura';

  @override
  String get comic_small_gap => 'Pequeno';

  @override
  String get comic_image_title => 'Ajustar imagem';

  @override
  String get comic_image_hint => 'O corte e o tom afetam apenas este livro.';

  @override
  String get comic_wide => 'Páginas largas';

  @override
  String get comic_intact => 'Manter inteiro';

  @override
  String get comic_split => 'Divisão';

  @override
  String get comic_rotate => 'Girar';

  @override
  String get comic_wide_hint =>
      'A divisão segue a direção de virada de página. Aplica-se à leitura de uma única página.';

  @override
  String get comic_cover => 'Uma capa por capítulo';

  @override
  String get comic_effects_reset => 'Redefinir ajustes de imagem';

  @override
  String get comic_book_reset => 'Restaurar padrões do livro';

  @override
  String get comic_book_reset_hint =>
      'Limpa as configurações de leitura personalizadas deste livro. A tradução permanece inalterada.';

  @override
  String get comic_canvas => 'Fundo do leitor';

  @override
  String get comic_system => 'Sistema';

  @override
  String get comic_black => 'Preto';

  @override
  String get comic_gray => 'Cinza';

  @override
  String get comic_paper => 'Papel';

  @override
  String get comic_tap => 'Toque para virar as páginas';

  @override
  String get comic_tap_hint =>
      'Toque nas bordas para mover; toque no centro para mostrar os controles.';

  @override
  String get comic_scroll_start => 'Iniciar rolagem automática';

  @override
  String get comic_scroll_pause => 'Pausar rolagem automática';

  @override
  String get comic_scroll_speed => 'Velocidade de rolagem';

  @override
  String get comic_scroll_hint =>
      'Inicia quando este painel fecha. Pausa quando o aplicativo sai do primeiro plano.';

  @override
  String get comic_save_failed =>
      'Não foi possível salvar. Por favor, tente novamente.';

  @override
  String get comic_reading => 'Leitura';

  @override
  String get comic_chapter_habits_hint =>
      'Os hábitos de lista de capítulos aplicam-se a todos os livros.';

  @override
  String get browser_title => 'Navegador';

  @override
  String get translation_image_display => 'Exibição de imagem';

  @override
  String get translation_display_hint =>
      'Mostrar primeiro as traduções existentes. Mantenha o original quando não houver tradução disponível.';

  @override
  String get translation_sign_in_required =>
      'Faça login para ativar a tradução';

  @override
  String get translation_sign_in_hint =>
      'Após fazer login, alterne para imagens traduzidas para traduzir automaticamente.';

  @override
  String get translation_automatic => 'Tradução automática';

  @override
  String get translation_original_hint =>
      'Mostrar originais. Mude para imagens traduzidas para traduzir automaticamente.';

  @override
  String get translation_window_hint =>
      'Processar imagens atuais e futuras apenas enquanto mostra traduções.';

  @override
  String get translation_channel => 'Canal de tradução';

  @override
  String get translation_no_images =>
      'Nenhuma imagem traduzível encontrada nesta página ainda';

  @override
  String get translation_waiting_image => 'Aguardando a imagem atual';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · Imagens $issues precisam de atenção',
      one: ' · 1 imagem precisa de atenção',
      zero: '',
    );
    return 'Imagens $complete / $total concluídas$_temp0 concluídas';
  }

  @override
  String get translation_image_actions_hint =>
      'Toque e segure uma imagem para mais ações, incluindo traduzi-la novamente.';

  @override
  String get translation_title => 'Tradução de mangá';

  @override
  String get translation_system_sign_in =>
      'Faça login usando o navegador do sistema';

  @override
  String get translation_target_language => 'Idioma alvo';

  @override
  String get translation_clear_cache => 'Limpar cache de imagens traduzidas';

  @override
  String get translation_cache_hint =>
      'Manter registros de tradução e recuperar resultados novamente quando necessário.';

  @override
  String get translation_saved_read_failed =>
      'Não foi possível carregar a tradução salva';

  @override
  String get translation_read_failed =>
      'Não foi possível carregar a imagem traduzida';

  @override
  String get operation_retry =>
      'A ação não terminou. Por favor, tente novamente.';

  @override
  String get translation_original => 'Originais';

  @override
  String get translation_translated => 'Traduzido';

  @override
  String get translation_regenerate_image => 'Traduzir esta imagem novamente';

  @override
  String get translation_read_image => 'Recarregar imagem traduzida';

  @override
  String get translation_image_actions => 'Mais ações de imagem';

  @override
  String get translation_processing => 'Processamento';

  @override
  String get translation_reading => 'Carregando imagem traduzida';

  @override
  String get translation_waiting => 'Aguardando tradução';

  @override
  String get translation_preparing => 'Preparando a tradução';

  @override
  String get translation_uploading => 'Carregando original';

  @override
  String get translation_running => 'Traduzindo';

  @override
  String get translation_uncertain => 'O status precisa de verificação';

  @override
  String get translation_failed => 'A tradução falhou';

  @override
  String get translation_verify => 'Verificar';

  @override
  String get translation_reread => 'Recarregar';

  @override
  String get browser_back => 'Voltar';

  @override
  String get browser_translation => 'Tradução de páginas da web';

  @override
  String get browser_new_tab_action => 'Abrir nova aba';

  @override
  String get browser_current_tab => 'Corrente';

  @override
  String get browser_close_tab => 'Fechar guia';

  @override
  String get browser_new_tab => 'Nova aba';

  @override
  String get browser_page => 'Página da Web';

  @override
  String get browser_unopened => 'Nenhuma página aberta ainda';

  @override
  String get browser_address_hint => 'Insira ou cole um URL';

  @override
  String get browser_invalid_address => 'Insira um URL válido';

  @override
  String get browser_clear_address => 'Limpar URL';

  @override
  String get browser_paste_address => 'Colar URL';

  @override
  String get browser_open_address => 'Abrir URL';

  @override
  String browser_tab_count(int count) {
    return 'Guias · $count';
  }

  @override
  String get browser_load_failed => 'Não foi possível abrir esta página';

  @override
  String get browser_load_failed_hint => 'Verifique sua conexão e o URL.';

  @override
  String get browser_edit_address => 'Editar URL';

  @override
  String get browser_clear_cookies_confirm =>
      'Limpar sessões de login para todos os sites?';

  @override
  String get browser_clear_cookies_hint =>
      'Sites em todas as guias podem exigir que você faça login novamente.';

  @override
  String get browser_clear_cookies_action => 'Limpar sessões de login';

  @override
  String get browser_tab_limit =>
      'Você pode manter até 12 abas abertas. Feche um primeiro.';

  @override
  String get browser_forward => 'Avançar';

  @override
  String get browser_clear_all_cookies =>
      'Limpar todas as sessões de login do site';

  @override
  String get browser_clear_failed =>
      'Não foi possível limpar sessões. Por favor, tente novamente.';

  @override
  String get browser_save_failed =>
      'Não foi possível salvar as guias. Por favor, tente novamente.';

  @override
  String get browser_tabs_full => '12 abas já estão abertas';

  @override
  String get browser_no_tabs => 'Ainda não há abas abertas';

  @override
  String get browser_close_failed =>
      'Não foi possível salvar as guias. Toque em fechar novamente para tentar novamente.';

  @override
  String get source_pinned_websites => 'Sites fixados';

  @override
  String get manage => 'Gerenciar';

  @override
  String get translation_settings_hint =>
      'Tradução automática, idioma alvo e canal';

  @override
  String get translation_show_original => 'Toque para mostrar o original';

  @override
  String get translation_show_translated => 'Toque para mostrar a tradução';

  @override
  String get source_display => 'Exibição';

  @override
  String get source_cover_title => 'Capa e título';

  @override
  String get source_cover_only => 'Apenas capa';

  @override
  String get source_save_search => 'Salvar pesquisa atual';

  @override
  String get source_saved_searches => 'Pesquisas salvas';

  @override
  String get source_website_info => 'Informações do site';

  @override
  String source_saved_search_title(String title) {
    return '$title · Toque para pesquisar';
  }

  @override
  String get action_done => 'Feito';

  @override
  String source_search_keyword(String query) {
    return 'Palavra-chave: $query';
  }

  @override
  String get source_no_saved_searches => 'Ainda não há pesquisas salvas';

  @override
  String get source_save_search_hint =>
      'Pesquise uma palavra-chave e salve-a nas ações do site.';

  @override
  String get source_saved_search_scope =>
      'As palavras-chave são salvas apenas para este site.';

  @override
  String get source_search_here => 'Pesquise títulos neste site';

  @override
  String get source_filter_results => 'Resultados filtrados';

  @override
  String get source_search_results => 'Resultados da pesquisa';

  @override
  String get source_return_popular => 'De volta ao popular';

  @override
  String get source_popular_titles => 'Títulos populares';

  @override
  String get source_no_titles => 'Nenhum título correspondente encontrado';

  @override
  String get source_no_titles_hint =>
      'Altere suas palavras-chave ou filtros, ou retorne aos títulos populares.';

  @override
  String get source_load_more_failed =>
      'Não foi possível carregar mais. Por favor, tente novamente.';

  @override
  String get source_load_pull_retry =>
      'Não foi possível carregar este site. Puxe para baixo para tentar novamente.';

  @override
  String get source_clear_failed =>
      'Não foi possível concluir a limpeza. Por favor, tente novamente.';

  @override
  String get source_uninstall_failed =>
      'Não foi possível concluir a desinstalação. Por favor, tente novamente.';

  @override
  String get source_details => 'Detalhes da fonte';

  @override
  String get source_repository_website => 'Site do repositório';

  @override
  String get source_provided_settings => 'Configurações fornecidas pela fonte';

  @override
  String get source_advanced_actions => 'Ações avançadas';

  @override
  String get source_edit_metadata => 'Editar informações de origem';

  @override
  String get source_clear_cookies => 'Limpar cookies deste site';

  @override
  String get source_clear_cookies_hint =>
      'Talvez seja necessário fazer login novamente em sua próxima visita.';

  @override
  String get source_uninstall => 'Desinstalar fonte';

  @override
  String get source_settings_save_failed =>
      'O salvamento não terminou. Reabra as configurações de origem para verificar.';

  @override
  String get repository_third_party => 'Repositórios de terceiros';

  @override
  String get repository_refresh_failed =>
      'Não foi possível atualizar o catálogo. O conteúdo armazenado em cache é mantido. Por favor, tente novamente.';

  @override
  String get repository_show_sources => 'Mostrar fontes deste repositório';

  @override
  String get repository_copy_catalog => 'Copiar link do catálogo';

  @override
  String get repository_remove => 'Remover repositório';

  @override
  String get repository_remove_hint =>
      'Mantenha as fontes instaladas e remova as entradas de catálogo desinstaladas.';

  @override
  String get repository_empty =>
      'Nenhum repositório de terceiros adicionado ainda';

  @override
  String get repository_built_in => 'Catálogo oficial integrado';

  @override
  String get repository_hidden => 'Oculto';

  @override
  String get repository_refreshing => 'Refrescante…';

  @override
  String get repository_refresh => 'Atualizar catálogo';

  @override
  String get repository_manage_hint =>
      'Gerenciar de onde as fontes de terceiros são baixadas.';

  @override
  String get repository_invalid_address => 'Insira um HTTP ou HTTPS URL válido';

  @override
  String get repository_already_added => 'Este repositório já foi adicionado';

  @override
  String get repository_unrecognized =>
      'Nenhum catálogo suportado encontrado. Verifique o link e tente novamente.';

  @override
  String get repository_read_failed =>
      'Não foi possível ler o catálogo. Por favor, tente novamente.';

  @override
  String get repository_save_failed =>
      'O salvamento não terminou. Verifique sua lista de repositórios.';

  @override
  String get repository_paste_hint =>
      'Colar um link de catálogo de repositório de terceiros';

  @override
  String get repository_address => 'URL';

  @override
  String get repository_paste_link => 'Colar link';

  @override
  String repository_recognized(String type) {
    return '$type · Catálogo reconhecido';
  }

  @override
  String get repository_choose_sources_hint =>
      'Após adicionar o repositório, escolha as fontes que você precisa.';

  @override
  String get search_scope => 'Escopo de pesquisa';

  @override
  String get search_scope_hint => 'Escolha os sites a serem pesquisados';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pesquisar sites $count',
      one: 'Pesquisar 1 site',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Encontrar um site';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sites selecionados',
      one: '1 site selecionado',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Limpar';

  @override
  String get search_deselect_results => 'Desmarcar sites correspondentes';

  @override
  String get search_select_results => 'Selecione sites correspondentes';

  @override
  String get search_no_websites_hint =>
      'Nenhum site correspondente. Tente outro nome ou idioma.';

  @override
  String get search_select_website_hint =>
      'Selecione pelo menos um site para pesquisar.';

  @override
  String get search_start_title =>
      'Insira palavras-chave para encontrar títulos';

  @override
  String get search_start_hint =>
      'Pesquise vários sites ao mesmo tempo e mostre títulos correspondentes.';

  @override
  String get search_empty_scope => 'Nenhum site pesquisável neste escopo';

  @override
  String get search_empty_scope_hint =>
      'Mude para todos os sites ou escolha sites para pesquisar.';

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
  String get search_titles => 'Pesquisar títulos';

  @override
  String get search_actions => 'Ações de busca';

  @override
  String get search_details => 'Detalhes da pesquisa';

  @override
  String get search_title_hint => 'Pesquisa por título';

  @override
  String get search_searching => 'Pesquisando';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Resultados $count encontrados',
      one: 'Encontrado 1 resultado',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'Nenhum resultado correspondente';

  @override
  String get search_failed => 'Pesquisa falhou';

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
      other: 'sites $websites',
      one: '1 site',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Encontrar títulos';

  @override
  String get search_complete => 'Pesquisa concluída';

  @override
  String get search_in_progress => 'Pesquisando';

  @override
  String get search_finding_related => 'Procurando títulos correspondentes…';

  @override
  String get search_no_results_yet => 'Ainda não há resultados de pesquisa';

  @override
  String get search_no_matching_titles =>
      'Nenhum título correspondente encontrado';

  @override
  String get search_results_appear_hint =>
      'Os resultados aparecerão aqui conforme forem encontrados.';

  @override
  String get search_failed_websites_hint =>
      'Alguns sites não conseguiram concluir a pesquisa. Tente novamente nos detalhes da pesquisa.';

  @override
  String get search_change_keywords_hint =>
      'Experimente palavras-chave mais curtas ou pesquise em mais sites.';

  @override
  String get search_view_details => 'Ver detalhes da pesquisa';

  @override
  String get search_adjust_scope => 'Ajustar o escopo da pesquisa';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sites $count',
      one: '1 site',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Concluído $completed / $total';
  }

  @override
  String get search_retry_website_hint =>
      'Tentar novamente sites com falha individualmente';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens selecionados',
      one: '1 item selecionado',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Idiomas de pesquisa';

  @override
  String get source_deselect => 'Desmarcar';

  @override
  String get source_select => 'Selecionar fonte';

  @override
  String get source_multilingual => 'Multilíngue';

  @override
  String get source_language_unknown => 'Idioma não especificado';

  @override
  String get source_adult_content => 'Contém conteúdo para maiores de 18 anos';

  @override
  String get source_classification_unknown => 'Classificação não especificada';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Visualizar todas as informações de origem, $count mais categorias',
      one: 'Visualizar todas as informações de origem, mais 1 categoria',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Carregando site';

  @override
  String get source_unpin => 'Desafixar';

  @override
  String get source_pin => 'Pino';

  @override
  String get source_open => 'Abrir';

  @override
  String get source_metadata_hint =>
      'As informações vêm do catálogo de origem. As categorias descrevem o conteúdo coberto pelo site.';

  @override
  String get source_region => 'Região';

  @override
  String get source_format => 'Formato';

  @override
  String get source_creation => 'Criação';

  @override
  String get source_unspecified => 'Não especificado';

  @override
  String get source_pricing => 'Preços';

  @override
  String get source_region_jp => 'Quadrinhos japoneses';

  @override
  String get source_region_kr => 'Quadrinhos coreanos';

  @override
  String get source_region_cn => 'Quadrinhos chineses';

  @override
  String get source_region_hk_tw => 'Quadrinhos de Hong Kong e Taiwan';

  @override
  String get source_region_western => 'Quadrinhos ocidentais';

  @override
  String get source_region_other => 'Outras regiões';

  @override
  String get source_format_page => 'Quadrinhos paginados';

  @override
  String get source_format_vertical => 'Quadrinhos verticais';

  @override
  String get source_format_strip => 'Histórias em quadrinhos';

  @override
  String get source_creation_original => 'Originais';

  @override
  String get source_creation_fan => 'Ventilador funciona';

  @override
  String get source_free_watch => 'Gratuito para assistir';

  @override
  String get source_free_read => 'Gratuito para leitura';

  @override
  String get source_partial_paid => 'Parcialmente pago';

  @override
  String get source_paid_watch => 'Visualização paga';

  @override
  String get source_paid_read => 'Leitura paga';

  @override
  String get source_pricing_unknown => 'Preço não especificado';

  @override
  String get source_language_filter => 'Filtrar por idioma';

  @override
  String get source_language_filter_hint =>
      'Filtre apenas este catálogo. As fontes instaladas não são afetadas.';

  @override
  String get source_all_languages => 'Todos os idiomas';

  @override
  String get action_apply => 'Aplicar';

  @override
  String get source_load_retry =>
      'Não foi possível carregar este site. Por favor, tente novamente.';

  @override
  String get source_catalog_refresh_failed =>
      'Não foi possível atualizar o catálogo. O conteúdo atual é mantido. Puxe para baixo para tentar novamente.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Desinstalar fontes $count?',
      one: 'Desinstalar 1 fonte?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Desinstale as fontes selecionadas e limpe suas configurações. Mantenha os títulos e downloads da biblioteca.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Falha nas ações para fontes $count.',
      one: 'Ação falhou para 1 fonte.',
    );
    return '$_temp0 Seleção mantida. Por favor, tente novamente.';
  }

  @override
  String get source_latest_content => 'Conteúdo mais recente';

  @override
  String get source_actions => 'Ações de origem';

  @override
  String get source_bulk_manage => 'Gerenciar múltiplas fontes';

  @override
  String get source_update_installed => 'Atualizar fontes instaladas';

  @override
  String get source_no_matching_websites => 'Nenhum site correspondente';

  @override
  String get source_no_websites => 'Nenhum site disponível';

  @override
  String get source_search_installed_hint =>
      'Pesquisar títulos em fontes instaladas';

  @override
  String get source_global_search => 'Pesquisar entre fontes';

  @override
  String get source_manage_repositories => 'Gerenciar repositórios';

  @override
  String get source_view_third_party => 'Ver fontes de terceiros';

  @override
  String get source_catalog_load_failed =>
      'Não foi possível carregar o catálogo. Puxe para baixo para tentar novamente.';

  @override
  String get source_all_websites => 'Todos os sites';

  @override
  String get source_available => 'Disponível para instalação';

  @override
  String get source_third_party => 'Terceiros';

  @override
  String get source_name_or_title => 'Nome ou título do site';

  @override
  String get view_all => 'Ver tudo';

  @override
  String get search_searching_ellipsis => 'Procurando…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · Não testado';
  }

  @override
  String get onboarding_untested => 'Não testado';

  @override
  String get source_custom_scope => 'Personalizado';

  @override
  String get source_custom_websites => 'Sites selecionados';

  @override
  String get tv_hidden_library_hint =>
      'Cada título fica em uma categoria oculta.\nSegure OK em “Todos” para exibir um.';

  @override
  String get tv_no_matching_anime => 'Nenhum anime correspondente';

  @override
  String tv_no_matching_category(String category) {
    return 'Nenhum anime correspondente em “$category”';
  }

  @override
  String get tv_filtered_empty_hint =>
      'Nenhum anime corresponde aos filtros atuais.\nAltere-os no botão ao lado da pesquisa.';

  @override
  String get tv_new_episodes => 'Novos Episódios';

  @override
  String get tv_recently_added => 'Adicionado recentemente';

  @override
  String get tv_empty_category_hint =>
      'Nenhum anime nesta categoria ainda.\nAdicione títulos a partir da página de detalhes de um título.';

  @override
  String get tv_empty_library => 'Sua biblioteca de anime está vazia';

  @override
  String get tv_empty_library_hint =>
      'Adicione anime do Browse para preencher sua casa';

  @override
  String get tv_browse_anime => 'Navegar anime';

  @override
  String tv_new_count(int count) {
    return '$count novo';
  }

  @override
  String tv_category_hidden(String category) {
    return 'Ocultou “$category” · segure OK em “Todos” para exibir';
  }

  @override
  String get tv_no_hidden_categories => 'Sem categorias ocultas';

  @override
  String get import_torrent_file => 'importar arquivo .torrent';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi e mais';

  @override
  String get cloudflare_proxy_optional => 'FlareSolverr / Byparr opcional URL';

  @override
  String get tv_home_layout_hint =>
      'Página inicial de anime baseada em linhas (Continuar · Novos episódios · categorias) em vez da grade plana';

  @override
  String get tv_hide_libraries_hint =>
      'Ocultar as bibliotecas de mangás e romances (ativado por padrão na TV)';

  @override
  String get anime_only_hint =>
      'Ocultar mangá e romance em todo o aplicativo. Desligue para mostrar tudo.';

  @override
  String get audio_auto_safe => 'Auto-seguro';

  @override
  String get tv_player_hint =>
      'Ligado: reprodutor de TV dedicado.  Desligado: player original (desktop).';

  @override
  String get release_open_failed => 'Não é possível abrir a liberação';

  @override
  String get tv_replay => 'Repetição';

  @override
  String get tv_no_episodes => 'Ainda não há episódios';

  @override
  String get tracker_continue_series => 'Continuar assistindo a série';

  @override
  String get tracker_watchlist_series => 'Série de listas de observação';

  @override
  String get tracker_continue_movies => 'Continuar assistindo filmes';

  @override
  String get tracker_watchlist_movies => 'Filmes da lista de observação';

  @override
  String get tracker_trending_series => 'Série de Tendências';

  @override
  String get tracker_trending_movies => 'Filmes em alta';

  @override
  String get tracker_popular_series => 'Série Popular';

  @override
  String get tracker_popular_movies => 'Filmes Populares';

  @override
  String get tracker_top_series => 'Principais Séries (Todos os Tempos)';

  @override
  String get tracker_top_movies => 'Principais filmes (de todos os tempos)';

  @override
  String get tracker_airing_series => 'Série de exibição';

  @override
  String get tracker_airing_anime => 'Exibição de Anime';

  @override
  String get tracker_popular_anime => 'Anime Popular';

  @override
  String get tracker_upcoming_anime => 'Próximos Animes';

  @override
  String get tracker_popular_manga => 'Mangá Popular';

  @override
  String get tracker_top_manga => 'Principais mangás';

  @override
  String get tracker_top_manhwa => 'Manhwa superior';

  @override
  String get tracker_top_manhua => 'Topo Manhua';

  @override
  String get tracker_latest_anime => 'Últimos animes';

  @override
  String get tracker_best_anime => 'Anime com melhor classificação';

  @override
  String get tracker_latest_manga => 'Mangá mais recente';

  @override
  String get tracker_best_manga => 'Mangá com melhor classificação';

  @override
  String get tracker_trending_anime => 'Tendências de Animes';

  @override
  String get tracker_upcoming_manga => 'Próximo mangá';

  @override
  String get tracker_trending_manga => 'Tendências de mangá';

  @override
  String selection_progress(int selected, int total) {
    return '$selected/$total selecionado';
  }

  @override
  String get source_code_editor => 'Editor de Código';

  @override
  String get source_code_execute => 'Executar';

  @override
  String get source_console_logs => 'Registros do console';

  @override
  String get source_no_logs => 'Nenhum registro ainda';

  @override
  String get source_updated_successfully => 'Fonte atualizada com sucesso';

  @override
  String get source_obsolete => 'OBSOLETO';

  @override
  String player_seek_forward_seconds(int seconds) {
    return 'Busca para frente $seconds segundos';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return 'Buscar $seconds segundos para trás';
  }

  @override
  String get player_autoplay_on =>
      'Reprodução automática do próximo episódio: ativado';

  @override
  String get player_autoplay_off =>
      'Reprodução automática do próximo episódio: desativado';

  @override
  String get player_no_other_quality => 'Nenhuma outra qualidade';

  @override
  String get player_no_subtitles => 'Sem legendas';

  @override
  String get player_no_audio_tracks => 'Sem faixas de áudio';

  @override
  String get player_seek_forward => 'Buscar adiante';

  @override
  String get player_seek_backward => 'Buscar para trás';

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
      'Faça login primeiro em sua conta de tradução.';

  @override
  String get translation_source_changed =>
      'A imagem original mudou. Por favor, recarregue-o.';

  @override
  String get translation_source_missing =>
      'A imagem original não está disponível no momento.';

  @override
  String get translation_resource_limit =>
      'Esta imagem excede o limite de processamento do dispositivo. O original é mantido.';

  @override
  String get translation_storage_full =>
      'O armazenamento de tradução está cheio. Limpe as imagens traduzidas primeiro.';

  @override
  String get translation_invalid_image =>
      'Formato de imagem ou conteúdo inválido.';

  @override
  String get translation_unsupported_image =>
      'A tradução não é suportada para esta imagem. O original é mantido.';

  @override
  String get translation_invalid_result =>
      'A validação da imagem traduzida falhou. Por favor, recarregue-o.';

  @override
  String get translation_result_unavailable =>
      'A imagem traduzida está indisponível. Por favor, recarregue-o.';

  @override
  String get translation_result_expired =>
      'A imagem traduzida expirou. Por favor traduza novamente.';

  @override
  String get translation_analysis_too_large =>
      'Há muito conteúdo de imagem para analisar. Reduza o tamanho da imagem e tente novamente.';

  @override
  String get translation_region_limit =>
      'A imagem tem muitas regiões de texto. Divida e tente novamente.';

  @override
  String get translation_text_limit =>
      'Uma região de texto é muito longa. Ajuste a imagem e tente novamente.';

  @override
  String get translation_unavailable =>
      'Esta tradução não está mais disponível.';

  @override
  String get translation_outcome_unknown =>
      'O resultado precisa de verificação. Não foi reenviado.';

  @override
  String get translation_rate_limited =>
      'As solicitações são limitadas. A tradução será retomada automaticamente.';

  @override
  String get translation_quota_exhausted => 'Cota de tradução insuficiente.';

  @override
  String get translation_unsupported_language =>
      'O serviço não suporta este idioma alvo.';

  @override
  String get translation_upgrade_required =>
      'O protocolo de tradução é incompatível. Atualize o aplicativo.';

  @override
  String get translation_remote_failed =>
      'A tradução falhou para esta página. Você pode tentar novamente manualmente.';

  @override
  String get translation_bridge_invalid =>
      'A página da web mudou. Ative a tradução novamente.';

  @override
  String get translation_connection_failed =>
      'Conexão falhou. Por favor, tente novamente.';

  @override
  String get translation_paused =>
      'Tradução pausada. Você pode verificar seu progresso.';

  @override
  String get translation_preparing_ellipsis => 'Preparando a tradução…';

  @override
  String get translation_checking_original => 'Verificando a imagem original…';

  @override
  String get translation_submitting => 'Enviando…';

  @override
  String get translation_uploading_ellipsis => 'Carregando original…';

  @override
  String get translation_waiting_ellipsis => 'Aguardando tradução…';

  @override
  String get translation_running_ellipsis => 'Traduzindo…';

  @override
  String get translation_verify_result => 'Resultado precisa de verificação';

  @override
  String get translation_partial => 'Algum conteúdo foi traduzido';

  @override
  String get translation_ready => 'Imagem traduzida pronta';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Jogar';

  @override
  String get player_quality => 'Qualidade';

  @override
  String get player_subtitles => 'Legendas';

  @override
  String get player_audio => 'Áudio';

  @override
  String get player_statistics => 'Estatísticas para nerds';

  @override
  String get player_auto => 'Automático';

  @override
  String get source_information => 'Informação de origem';

  @override
  String get source_code_page => 'Página';

  @override
  String get source_code_query => 'Consulta';

  @override
  String get repository_invalid_source => 'Fonte inválida - remova-a';

  @override
  String get player_fit_contain => 'Conter';

  @override
  String get player_fit_cover => 'Capa';

  @override
  String get player_fit_fill => 'Preencher';

  @override
  String get player_fit_height => 'Altura';

  @override
  String get player_fit_width => 'Largura';

  @override
  String get player_fit_scale => 'Escala';

  @override
  String get player_fit_none => 'Nenhum';

  @override
  String get player_shader_clear => 'Desligado (limpar shaders)';

  @override
  String get player_shader_luma => 'Aumento de escala Luma';

  @override
  String get player_decoder_auto => 'Automático (hardware)';

  @override
  String get player_decoder_software => 'Software (sem hardware)';

  @override
  String get player_stats_toggle => 'Alternar sobreposição';

  @override
  String get player_stats_general => 'Geral';

  @override
  String get player_stats_frames => 'Temporizações de quadro';

  @override
  String get player_stats_cache => 'Cache de entrada';

  @override
  String get player_stats_filters => 'Filtros ativos';

  @override
  String get player_stats_log => 'Registro';

  @override
  String get source_mark_pinned => 'Pino';

  @override
  String translation_image_action(String action) {
    return '$action esta imagem';
  }

  @override
  String get memory_waiting => 'memória: aguardando uma amostra';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current pico $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'cache $current / $limit pico $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'itens $count / $limit vivo $live pico $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'amostras $count',
      one: '1 amostra',
    );
    return '$percent% completo de $_temp0';
  }

  @override
  String get memory_reset_hint =>
      'ative e desative nas configurações para redefinir';

  @override
  String get action_hide => 'Ocultar';

  @override
  String discord_get_app(String app) {
    return 'Obtenha $app';
  }

  @override
  String get discord_idle => 'Inativo';

  @override
  String discord_watching_title(String title) {
    return 'Assistindo $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'Leitura $title';
  }
}
