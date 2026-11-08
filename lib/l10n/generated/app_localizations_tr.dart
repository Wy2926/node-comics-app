// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get bookshelf_all => 'All';

  @override
  String get bookshelf_search => 'Search library';

  @override
  String get app_update_allow_install =>
      'Allow app installation in system settings, then return and tap Install.';

  @override
  String get app_update_waiting =>
      'Waiting for the system to resume the download…';

  @override
  String get app_update_cancel_download => 'Cancel download';

  @override
  String get app_update_remove_package => 'Remove downloaded package';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'No matching settings';

  @override
  String get search_empty_hint =>
      'Try another keyword, or clear the search to see everything.';

  @override
  String get search_clear => 'Clear search';

  @override
  String get app_updates => 'App updates';

  @override
  String get app_update_auto => 'Check on launch';

  @override
  String get app_update_view => 'View update';

  @override
  String get app_update_later => 'Later';

  @override
  String get app_update_external_hint =>
      'Opens the release page in your browser';

  @override
  String get app_update_failed =>
      'Unable to check for updates. Please try again.';

  @override
  String get app_update_opened => 'Release page opened';

  @override
  String get app_diagnostics => 'Diagnostics and logs';

  @override
  String get library => 'Kütüphane';

  @override
  String get updates_search => 'Search updates';

  @override
  String get updates => 'Güncellemeler';

  @override
  String get history => 'Geçmiş';

  @override
  String get browse => 'Gözat';

  @override
  String get more => 'Daha Fazla';

  @override
  String get open_random_entry => 'Rastgele Giriş Aç';

  @override
  String get import => 'İçe Aktar';

  @override
  String get filter => 'Filtre';

  @override
  String get ignore_filters => 'Filtreleri yok say';

  @override
  String get downloaded => 'İndirildi';

  @override
  String get unread => 'Okunmamış';

  @override
  String get unwatched => 'İzlenmemiş';

  @override
  String get started => 'Başladı';

  @override
  String get bookmarked => 'Yer İmleri';

  @override
  String get sort => 'Sırala';

  @override
  String get alphabetically => 'Alfabetik Olarak';

  @override
  String get last_read => 'Son Okunan';

  @override
  String get last_watched => 'Son İzlenen';

  @override
  String get last_update_check => 'Son Güncelleme Kontrolü';

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
          'Kitaplığından bu $mediaType’nin tüm $count $entryTypePlural’ini siliyorsun.',
      one: 'Kitaplığından bu $mediaType’nin tek $entryType’ünü siliyorsun.',
    );
    return '$_temp0\nBu işlem $mediaType’nin tamamını da kütüphanenden kaldıracak.\n\nNot: Dosyalar silinmeyecek.';
  }

  @override
  String get chapter => 'bölüm';

  @override
  String get episode => 'bölüm';

  @override
  String get unread_count => 'Okunmamış Sayısı';

  @override
  String get unwatched_count => 'İzlenmemiş Sayısı';

  @override
  String get latest_chapter => 'Son Bölüm';

  @override
  String get latest_episode => 'Son Bölüm';

  @override
  String get date_added => 'Eklenme Tarihi';

  @override
  String get display => 'Görüntüle';

  @override
  String get display_mode => 'Görüntüleme Modu';

  @override
  String get compact_grid => 'Kompakt Izgara';

  @override
  String get compression_level => 'Sıkıştırma düzeyi';

  @override
  String compression_info(Object level) {
    return 'Sıkıştırma ne kadar yüksek olursa, yedekleme dosyası o kadar az yer kaplar ancak daha fazla CPU kullanır. Varsayılan: $level';
  }

  @override
  String get comfortable_grid => 'Rahat Izgara';

  @override
  String get cover_only_grid => 'Sadece Kapak Izgarası';

  @override
  String get list => 'Liste';

  @override
  String get badges => 'Rozetler';

  @override
  String get downloaded_chapters => 'İndirilen Bölümler';

  @override
  String get downloaded_episodes => 'İndirilen Bölümler';

  @override
  String get language => 'Dil';

  @override
  String get local_source => 'Yerel Kaynak';

  @override
  String get tabs => 'Sekmeler';

  @override
  String get show_category_tabs => 'Kategori Sekmelerini Göster';

  @override
  String get show_numbers_of_items => 'Öğe Sayılarını Göster';

  @override
  String get other => 'Diğer';

  @override
  String get show_continue_reading_buttons =>
      'Okumaya Devam Et Düğmelerini Göster';

  @override
  String get show_continue_watching_buttons =>
      'İzlemeye Devam Et Düğmelerini Göster';

  @override
  String get empty_library => 'Boş Kütüphane';

  @override
  String get search => 'Ara...';

  @override
  String get no_recent_updates => 'Yakın Zamanda Güncelleme Yok';

  @override
  String get remove_everything => 'Her Şeyi Kaldır';

  @override
  String get remove_everything_msg => 'Emin misiniz? Tüm geçmiş silinecek';

  @override
  String get remove_all_update_msg => 'Emin misiniz? Tüm güncelleme silinecek';

  @override
  String get ok => 'Tamam';

  @override
  String get cancel => 'İptal';

  @override
  String get remove => 'Kaldır';

  @override
  String get remove_history_msg =>
      'Bu, bu bölümün okunma tarihini kaldıracaktır. Emin misiniz?';

  @override
  String get last_used => 'Son Kullanılan';

  @override
  String get pinned => 'Sabitle';

  @override
  String get sources => 'Kaynaklar';

  @override
  String get install => 'Yükle';

  @override
  String get update => 'Güncelle';

  @override
  String get latest => 'En Yeni';

  @override
  String get extensions => 'Uzantılar';

  @override
  String get migrate => 'Taşı';

  @override
  String get mass_migration_title => 'Toplu taşıma';

  @override
  String get mass_migration_preview_items => 'Öğeleri önizle';

  @override
  String get mass_migration_destination_source => 'Hedef kaynak';

  @override
  String get mass_migration_no_library_items =>
      'Toplu taşıma için uygun kütüphane öğesi yok.';

  @override
  String get mass_migration_no_destination_sources =>
      'Yüklü hedef kaynak bulunamadı.';

  @override
  String get mass_migration_installed => 'Yüklendi';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe incelenmeye hazır',
      one: '1 öğe incelenmeye hazır',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe',
      one: '1 öğe',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'Hedef kaynağı seçin';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return '$source • $language içinde eşleşmeler aranıyor';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Öğe işleniyor: $current / $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Sıradaki öğeden önce 2 saniye bekleniyor...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Sıradaki taşımadan önce 2 saniye bekleniyor...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Şu ana kadar eşleşen: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Eşleşme yok: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return '$source için eşleşmeleri incele';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Bulunan eşleşmeler: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Eşleşme yok: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Taşınmak üzere seçilen: $count';
  }

  @override
  String get mass_migration_finish_review => 'İncelemeyi bitir';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Seçilen öğeleri taşı ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Seçilen öğeler $source kaynağına taşınıyor';
  }

  @override
  String get mass_migration_no_items_selected => 'Taşıma için öğe seçilmedi.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Öğe taşınıyor: $current / $total';
  }

  @override
  String get mass_migration_complete => 'Toplu taşıma tamamlandı';

  @override
  String get mass_migration_complete_success_message =>
      'Seçilen tüm öğeler başarıyla işlendi.';

  @override
  String get mass_migration_complete_partial_message =>
      'Taşıma bitti ancak bazı öğeler hala manuel ilgi gerektiriyor.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'İşlendi';

  @override
  String get mass_migration_matched => 'Eşleşti';

  @override
  String get mass_migration_migrated => 'Taşındı';

  @override
  String get mass_migration_skipped => 'Atlandı';

  @override
  String get mass_migration_failed => 'Başarısız';

  @override
  String get mass_migration_failed_items => 'Başarısız Öğeler';

  @override
  String get mass_migration_exit => 'Toplu Taşımadan Çık';

  @override
  String get mass_migration_no_destination_match =>
      'Hedef eşleşmesi bulunamadı';

  @override
  String mass_migration_query(Object query) {
    return 'Sorgu: $query';
  }

  @override
  String get mass_migration_skip => 'Atla';

  @override
  String get mass_migration_loading => 'Yükleniyor...';

  @override
  String get mass_migration_choose_another_result => 'Başka bir sonuç seçin';

  @override
  String get mass_migration_source_chapters => 'Kaynak bölümler';

  @override
  String get mass_migration_destination_chapters => 'Hedef bölümler';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bölüm',
      one: '1 bölüm',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaynak bölümü',
      one: '1 kaynak bölümü',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hedef bölümü',
      one: '1 hedef bölümü',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Bölüm bulunamadı.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Ve $count tane daha...';
  }

  @override
  String get mass_migration_unknown_title => 'Bilinmeyen başlık';

  @override
  String get mass_migration_unknown_match => 'Bilinmeyen eşleşme';

  @override
  String get mass_migration_unknown_source => 'Bilinmeyen kaynak';

  @override
  String get mass_migration_unknown_chapter => 'Bilinmeyen bölüm';

  @override
  String get migrate_confirm => 'Başka bir kaynağa geç';

  @override
  String get clean_database => 'Veritabanını temizle';

  @override
  String cleaned_database(Object x) {
    return 'Veritabanı temizlendi! $x giriş kaldırıldı';
  }

  @override
  String get clean_database_desc =>
      'Bu, kütüphaneye eklenmeyen tüm öğeleri kaldıracaktır!';

  @override
  String get incognito_mode => 'Gizli Mod';

  @override
  String get incognito_mode_description => 'Okuma geçmişini duraklatır';

  @override
  String get downloaded_only => 'Sadece indirilmiş';

  @override
  String get downloaded_only_description =>
      'Kütüphanenizde yalnızca indirilmiş girişleri göster';

  @override
  String get download_queue => 'İndirme Kuyruğu';

  @override
  String get categories => 'Kategoriler';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get settings => 'Ayarlar';

  @override
  String get about => 'Hakkında';

  @override
  String get help => 'Yardım';

  @override
  String get no_downloads => 'İndirme Yok';

  @override
  String get edit_categories => 'Kategorileri Düzenle';

  @override
  String get edit_categories_description =>
      'Henüz kategoriniz yok. Kütüphanenizi organize etmek için bir tane oluşturmak için artı düğmesine dokunun';

  @override
  String get add => 'Ekle';

  @override
  String get add_category => 'Kategori Ekle';

  @override
  String get name => 'İsim';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Gerekli';

  @override
  String get add_category_error_exist => 'Bu isimde zaten bir kategori var!';

  @override
  String get delete_category => 'Kategoriyi Sil';

  @override
  String delete_category_msg(Object name) {
    return '$name kategorisini silmek istiyor musunuz?';
  }

  @override
  String get rename_category => 'Kategoriyi Yeniden Adlandır';

  @override
  String get general => 'Genel';

  @override
  String get general_subtitle => 'Uygulama dili';

  @override
  String get app_language => 'Uygulama dili';

  @override
  String get default_subtitle_language => 'Varsayılan altyazı dili';

  @override
  String get appearance => 'Görünüm';

  @override
  String get appearance_subtitle => 'Tema, tarih ve saat formatı';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Karanlık Mod';

  @override
  String get follow_system_theme => 'Sistem temasını takip et';

  @override
  String get on => 'Açık';

  @override
  String get off => 'Kapalı';

  @override
  String get pure_black_dark_mode => 'Saf Siyah Karanlık Mod';

  @override
  String get timestamp => 'Zaman Damgası';

  @override
  String get relative_timestamp => 'Göreceli Zaman Damgası';

  @override
  String get relative_timestamp_short => 'Kısa (Bugün, Dün)';

  @override
  String get relative_timestamp_long => 'Uzun (Kısa+, n gün önce)';

  @override
  String get date_format => 'Tarih Formatı';

  @override
  String get reader => 'Okuyucu';

  @override
  String get refresh => 'Yenile';

  @override
  String get reader_subtitle => 'Okuma modu, görüntüleme, navigasyon';

  @override
  String get default_reading_mode => 'Varsayılan Okuma Modu';

  @override
  String get reading_mode_vertical => 'Dikey';

  @override
  String get reading_mode_horizontal => 'Yatay';

  @override
  String get reading_mode_left_to_right => 'Soldan Sağa';

  @override
  String get reading_mode_right_to_left => 'Sağdan Sola';

  @override
  String get reading_mode_vertical_continuous => 'Sürekli Dikey';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Çift Dokunma Animasyon Hızı';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Hızlı';

  @override
  String get no_animation => 'Animasyon Yok';

  @override
  String get animate_page_transitions => 'Sayfa Geçişlerini Animasyonla';

  @override
  String get crop_borders => 'Kenarları Kırp';

  @override
  String get downloads => 'İndirilenler';

  @override
  String get downloads_subtitle => 'İndirme ayarları';

  @override
  String get download_location => 'İndirme Yeri';

  @override
  String get custom_location => 'Özel Yer';

  @override
  String get only_on_wifi => 'Sadece Wifi Üzerinde';

  @override
  String get save_as_cbz_archive => 'CBZ Arşivi Olarak Kaydet';

  @override
  String get delete_download_after_reading => 'Okuduktan sonra indirmeyi sil';

  @override
  String get concurrent_downloads => 'Eş zamanlı indirmeler';

  @override
  String get browse_subtitle => 'Kaynaklar, genel arama';

  @override
  String get only_include_pinned_sources =>
      'Sadece Sabitlenmiş Kaynakları Dahil Et';

  @override
  String get nsfw_sources => 'NSFW (+18) Kaynaklar';

  @override
  String get nsfw_sources_show => 'Kaynak ve uzantı listelerinde göster';

  @override
  String get nsfw_sources_info =>
      'Bu, resmi olmayan veya potansiyel olarak yanlış işaretlenmiş uzantıların uygulama içinde NSFW (18+) içerikleri yüzeye çıkarmasını engellemez';

  @override
  String get version => 'Versiyon';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Güncelleme Kontrol Et';

  @override
  String get logs_on => 'Günlük kaydını etkinleştir';

  @override
  String get share_app_logs => 'Uygulama günlüklerini paylaş';

  @override
  String get no_app_logs => 'log.txt dosyası yok!';

  @override
  String get failed => 'Başarısız!';

  @override
  String n_days_ago(Object days) {
    return '$days gün önce';
  }

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get a_week_ago => 'Bir Hafta Önce';

  @override
  String get next_week => 'Gelecek hafta';

  @override
  String get add_to_library => 'Kütüphaneye Ekle';

  @override
  String get completed => 'Tamamlandı';

  @override
  String get ongoing => 'Devam Ediyor';

  @override
  String get on_hiatus => 'Ara Verildi';

  @override
  String get canceled => 'İptal Edildi';

  @override
  String get publishing_finished => 'Yayımlama Tamamlandı';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get empty_placeholder => 'BOŞ';

  @override
  String get error => 'Hata';

  @override
  String error_with_message(Object error) {
    return 'Hata: $error';
  }

  @override
  String get no_pages_available => 'Hata: kullanılabilir sayfa yok';

  @override
  String get set_categories => 'Kategorileri Ayarla';

  @override
  String get edit => 'Düzenle';

  @override
  String get in_library => 'Kütüphanede';

  @override
  String get filter_scanlator_groups => 'Tarama Gruplarını Filtrele';

  @override
  String get reset => 'Sıfırla';

  @override
  String get by_source => 'Kaynağa Göre';

  @override
  String get by_chapter_number => 'Bölüm Numarasına Göre';

  @override
  String get by_episode_number => 'Bölüm Sayısına Göre';

  @override
  String get by_upload_date => 'Yükleme Tarihine Göre';

  @override
  String get source_title => 'Kaynak Başlığı';

  @override
  String get create_extension => 'Eklenti Oluştur';

  @override
  String get developer_mode => 'Geliştirici modu';

  @override
  String get developer_mode_subtitle =>
      'Uzantı geliştirici araçlarını göster (uzantı oluştur, kodu düzenle)';

  @override
  String get choose_extension_language => 'Eklenti dilini seçin';

  @override
  String get lang => 'Dil';

  @override
  String get base_url => 'Temel URL';

  @override
  String get api_url_optional => 'API URL (isteğe bağlı)';

  @override
  String get icon_url => 'Simge URL';

  @override
  String get source_icon_url => 'Kaynak simge URL';

  @override
  String get notes => 'Notlar';

  @override
  String get extension_name_example => 'ör: AnimeAdım';

  @override
  String get language_code_example => 'ör: tr';

  @override
  String get base_url_example => 'ör: https://ornek.com';

  @override
  String get api_url_example => 'ör: https://api.ornek.com';

  @override
  String get extension_notes_example => 'ör: bu eklenti giriş gerektirir';

  @override
  String get type => 'Tür';

  @override
  String get target => 'Hedef';

  @override
  String get source_type_single => 'tekli';

  @override
  String get source_type_multi => 'çoklu';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader derlenmiş JS';

  @override
  String get source_created_successfully => 'Kaynak başarıyla oluşturuldu';

  @override
  String get source_already_exists => 'Kaynak zaten mevcut';

  @override
  String get error_when_creating_source => 'Kaynak oluşturulurken hata oluştu';

  @override
  String get cookies_deleted => 'Çerezler silindi!';

  @override
  String get delete_all_cookies => 'Tüm çerezleri sil';

  @override
  String get chapter_number => 'Bölüm Numarası';

  @override
  String get episode_number => 'Bölüm Sayısı';

  @override
  String get share => 'Paylaş';

  @override
  String n_chapters(Object n) {
    return '$n bölüm';
  }

  @override
  String missing_chapters(Object count) {
    return '$count eksik bölüm';
  }

  @override
  String get no_description => 'Açıklama Yok';

  @override
  String get resume => 'Devam Et';

  @override
  String get read => 'Oku';

  @override
  String get watch => 'İzle';

  @override
  String get popular => 'Popüler';

  @override
  String get open_in_browser => 'Tarayıcıda Aç';

  @override
  String get clear_cookie => 'Çerezi Temizle';

  @override
  String get show_page_number => 'Sayfa Numarasını Göster';

  @override
  String get from_library => 'Kütüphaneden';

  @override
  String get downloaded_chapter => 'İndirilen Bölüm';

  @override
  String page(Object page) {
    return 'Sayfa $page';
  }

  @override
  String get global_search => 'Genel Arama';

  @override
  String get color_blend_level => 'Renk Karışımı Seviyesi';

  @override
  String current(Object char) {
    return 'Şu Anki $char';
  }

  @override
  String finished(Object char) {
    return 'Bitmiş $char';
  }

  @override
  String next(Object char) {
    return 'Sonraki $char';
  }

  @override
  String previous(Object char) {
    return 'Önceki $char';
  }

  @override
  String get no_more_chapter => 'Başka Bölüm Yok';

  @override
  String get no_result => 'Sonuç Yok';

  @override
  String get send => 'Gönder';

  @override
  String get delete => 'Sil';

  @override
  String get start_downloading => 'İndirmeye Hemen Başla';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get add_chapters => 'Bölümler Ekle';

  @override
  String get delete_chapters => 'Bölüm Sil?';

  @override
  String get default0 => 'Varsayılan';

  @override
  String get total_chapters => 'Toplam Bölümler';

  @override
  String get total_episodes => 'Toplam Bölümler';

  @override
  String get import_local_file => 'Yerel Dosya İçe Aktar';

  @override
  String get import_files => 'Dosyalar';

  @override
  String get split_epub_chapters => 'Bölümlere ayır';

  @override
  String get split_epub_chapters_description =>
      'Her EPUB bölümünü ayrı bir giriş olarak içe aktar';

  @override
  String get nothing_read_recently => 'Son Zamanlarda Okunan Bir Şey Yok';

  @override
  String get status => 'Durum';

  @override
  String get not_started => 'Başlamadı';

  @override
  String get score => 'Puan';

  @override
  String get start_date => 'Başlangıç Tarihi';

  @override
  String get finish_date => 'Bitiş Tarihi';

  @override
  String get reading => 'Okuyor';

  @override
  String get on_hold => 'Beklemede';

  @override
  String get dropped => 'Bırakıldı';

  @override
  String get plan_to_read => 'Okumak İçin Planla';

  @override
  String get re_reading => 'Tekrar Okuyor';

  @override
  String get chapters => 'Bölümler';

  @override
  String get add_tracker => 'Takip Ekle';

  @override
  String get one_tracker => '1 Takip';

  @override
  String n_tracker(Object n) {
    return '$n Takip';
  }

  @override
  String get tracking => 'Takip Ediliyor';

  @override
  String get syncing => 'Senkrone etme';

  @override
  String get sync_logged => 'Giriş başarılı';

  @override
  String get syncing_subtitle =>
      'Okuma ilerlemenizi cihazlar arasında senkronize etmek için sunucu adresinizi girin ve tarayıcı üzerinden oturum açın.';

  @override
  String get sync_service => 'Kendi sunucunuzda senkronizasyon';

  @override
  String get last_sync => 'Son senkronizasyon: ';

  @override
  String get sync_login_browser => 'Tarayıcı ile giriş yap';

  @override
  String get sync_server => 'Senkronizasyon Sunucu Adresi';

  @override
  String get sync_starting => 'Senkronizasyonu başlatıyorum.';

  @override
  String get sync_finished => 'Senkronizasyon tamamlandı';

  @override
  String get sync_failed => 'Senkronizasyon başarısız';

  @override
  String get sync_restore_in_progress =>
      'Senkronizasyon atlandı — geri yükleme sürüyor';

  @override
  String sync_progress_percent(Object percent) {
    return 'Senkronize ediliyor… %$percent';
  }

  @override
  String get sync_progress_indeterminate => 'Senkronize ediliyor…';

  @override
  String get sync_button_sync => 'İlerlemeyi senkronize et';

  @override
  String get sync_button_upload => 'Sadece yükle';

  @override
  String get sync_button_upload_info =>
      'Bu işlem uzak verileri yerel verilerle tamamen değiştirecektir!';

  @override
  String get sync_button_download => 'Sadece indir';

  @override
  String get sync_button_download_info =>
      'Bu işlem yerel verileri uzak verilerle tamamen değiştirecektir!';

  @override
  String get sync_status_not_configured => 'Bağlı değil';

  @override
  String get sync_status_checking => 'Bağlantı kontrol ediliyor...';

  @override
  String get sync_status_connected => 'Bağlandı';

  @override
  String get sync_status_unauthorized =>
      'Oturum süresi doldu, lütfen tekrar giriş yapın';

  @override
  String get sync_status_unreachable => 'Sunucuya ulaşılamıyor';

  @override
  String get sync_section_general => 'Genel';

  @override
  String get sync_on => 'Senkronizasyonu etkinleştir';

  @override
  String get sync_auto => 'Otomatik senkronizasyon';

  @override
  String get sync_auto_warning =>
      'Otomatik senkronizasyon şu anda deneysel bir özelliktir!';

  @override
  String get sync_auto_off => 'Kapalı';

  @override
  String get sync_auto_5_minutes => 'Her 5 dakikada bir';

  @override
  String get sync_auto_10_minutes => 'Her 10 dakikada bir';

  @override
  String get sync_auto_30_minutes => 'Her 30 dakikada bir';

  @override
  String get sync_auto_1_hour => 'Her 1 saatte bir';

  @override
  String get sync_auto_3_hours => 'Her 3 saatte bir';

  @override
  String get sync_auto_6_hours => 'Her 6 saatte bir';

  @override
  String get sync_auto_12_hours => 'Her 12 saatte bir';

  @override
  String get server_error => 'Sunucu hatası!';

  @override
  String get dialog_confirm => 'Onayla';

  @override
  String get description => 'Açıklama';

  @override
  String get reorder_navigation => 'Gezinmeyi özelleştir';

  @override
  String get reorder_navigation_description =>
      'Gezinmeyi ihtiyaçlarınıza göre yeniden düzenleyin ve ayarlayın.';

  @override
  String get floating_navigation_bar => 'Floating navigation bar';

  @override
  String get floating_navigation_bar_description =>
      'Use a floating capsule instead of the standard attached navigation bar.';

  @override
  String get full_screen_player => 'Tam ekran kullan';

  @override
  String get full_screen_player_info =>
      'Bir video oynatıldığında otomatik olarak tam ekran kullan.';

  @override
  String episode_progress(Object n) {
    return 'İlerleme: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n bölüm';
  }

  @override
  String missing_episodes(Object count) {
    return '$count eksik bölüm';
  }

  @override
  String get manga_sources => 'Manga Kaynakları';

  @override
  String get anime_sources => 'Anime Kaynakları';

  @override
  String get novel_sources => 'Hikaye Kaynakları';

  @override
  String get anime_extensions => 'Anime Uzantıları';

  @override
  String get manga_extensions => 'Manga Uzantıları';

  @override
  String get novel_extensions => 'Hikaye Uzantıları';

  @override
  String get extension_settings => 'Uzantı ayarları';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Hikaye';

  @override
  String get library_no_category_exist => 'Henüz hiç kategoriniz yok';

  @override
  String get watching => 'İzliyor';

  @override
  String get plan_to_watch => 'İzlemek İçin Planla';

  @override
  String get re_watching => 'Tekrar İzliyor';

  @override
  String get episodes => 'Bölümler';

  @override
  String get download => 'İndir';

  @override
  String get new_update_available => 'Yeni güncelleme mevcut';

  @override
  String app_version(Object v) {
    return 'Uygulama Sürümü : v$v';
  }

  @override
  String get searching_for_updates => 'Güncellemeler aranıyor...';

  @override
  String get no_new_updates_available => 'Yeni güncelleme yok';

  @override
  String get uninstall => 'Kaldır';

  @override
  String uninstall_extension(Object ext) {
    return '$ext uzantısını kaldır?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Tüm $type aramak için çift dokunun';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Çift dokunarak arama ipucunu göster';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Manga/Anime/Roman sekmelerinde çift dokunmanın Genel Aramayı açtığını açıklayan bir ipucu göster.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" zaten $source üzerinden kütüphanenizde var.';
  }

  @override
  String get add_anyway => 'Yine de Ekle';

  @override
  String get langauage => 'Dil';

  @override
  String get extension_detail => 'Uzantı detayı';

  @override
  String get scale_type => 'Ölçek Türü';

  @override
  String get scale_type_fit_screen => 'Ekrana Sığdır';

  @override
  String get scale_type_stretch => 'Esnet';

  @override
  String get scale_type_fit_width => 'Genişliğe Sığdır';

  @override
  String get scale_type_fit_height => 'Yüksekliğe Sığdır';

  @override
  String get scale_type_original_size => 'Orijinal Boyut';

  @override
  String get scale_type_smart_fit => 'Akıllı Sığdırma';

  @override
  String get page_preload_amount => 'Sayfa Ön Yükleme Miktarı';

  @override
  String get page_preload_amount_subtitle =>
      'Okurken ön yüklenen sayfa miktarı. Daha yüksek değerler, daha yüksek önbellek ve ağ kullanımı pahasına daha pürüzsüz bir okuma deneyimi sağlar.';

  @override
  String get image_loading_error => 'Bu resim yüklenemedi';

  @override
  String get add_episodes => 'Bölümler Ekle';

  @override
  String get video_quality => 'Kalite';

  @override
  String get video_subtitle => 'Altyazı';

  @override
  String get check_for_extension_updates =>
      'Uzantı güncellemelerini kontrol et';

  @override
  String get auto_extensions_updates => 'Otomatik Uzantı Güncellemeleri';

  @override
  String get auto_extensions_updates_subtitle =>
      'Yeni bir sürümü mevcut olduğunda uzantıyı otomatik olarak günceller.';

  @override
  String get check_for_app_updates =>
      'Uygulama başlatıldığında güncellemeleri kontrol et';

  @override
  String get reading_mode => 'Okuma Modu';

  @override
  String get custom_filter => 'Özel Filtre';

  @override
  String get background_color => 'Arka Plan Rengi';

  @override
  String get white => 'Beyaz';

  @override
  String get black => 'Siyah';

  @override
  String get grey => 'Gri';

  @override
  String get automaic => 'Otomatik';

  @override
  String get preferred_domain => 'Tercih Edilen Alan';

  @override
  String get load_more => 'Daha Fazla Yükle';

  @override
  String get cancel_all_for_this_series => 'Bu Seri İçin Tümünü İptal Et';

  @override
  String get login => 'Giriş Yap';

  @override
  String login_into(Object tracker) {
    return '$tracker Oturum Aç';
  }

  @override
  String get email_adress => 'E-posta Adresi';

  @override
  String get password => 'Şifre';

  @override
  String log_out_from(Object tracker) {
    return '$tracker Oturumu Kapat?';
  }

  @override
  String get log_out => 'Oturumu Kapat';

  @override
  String get update_pending => 'Güncelleme Bekleniyor';

  @override
  String get update_all => 'Tümünü Güncelle';

  @override
  String get backup_and_restore => 'Yedekle ve Geri Yükle';

  @override
  String get create_backup => 'Yedek Oluştur';

  @override
  String get create_backup_dialog_title => 'Ne yedeklemek istiyorsun?';

  @override
  String get create_backup_subtitle =>
      'Mevcut kütüphaneyi geri yüklemek için kullanılabilir';

  @override
  String get restore_backup => 'Yedeği Geri Yükle';

  @override
  String get encrypt_backups => 'Yedekleri şifrele';

  @override
  String get encrypt_backups_info =>
      'Yedekleme dosyalarını AES şifreleme ile parolayla koruyun';

  @override
  String get no_secure_storage => 'Güvenli depolama bulunamadı';

  @override
  String get no_keyring_warning =>
      'Bu sistemde anahtarlık hizmeti yok, parola güvenli şekilde saklanamaz.\n\nUygulama veritabanında şifresiz saklansın mı?';

  @override
  String get enter_backup_password => 'Yedekleme parolasını girin';

  @override
  String get incorrect_password_try_again => 'Hatalı parola, tekrar deneyin.';

  @override
  String get set_backup_password => 'Yedekleme parolası belirle';

  @override
  String get confirm_password => 'Parolayı onayla';

  @override
  String get passwords_do_not_match => 'Parolalar eşleşmiyor';

  @override
  String get password_required_to_restore =>
      'Bu yedeği geri yüklemek için parola gereklidir.';

  @override
  String get restore_backup_subtitle =>
      'Yedek dosyasından kütüphaneyi geri yükle';

  @override
  String get automatic_backups => 'Otomatik Yedeklemeler';

  @override
  String get backup_frequency => 'Yedekleme Sıklığı';

  @override
  String get backup_location => 'Yedekleme Konumu';

  @override
  String get backup_options => 'Yedekleme Seçenekleri';

  @override
  String get backup_options_dialog_title => 'Ne yedeklemek istiyorsun?';

  @override
  String get backup_options_subtitle =>
      'Yedek dosyasına hangi bilgilerin dahil edileceği';

  @override
  String get backup_and_restore_warning_info =>
      'Yedeklerin başka yerlerde de kopyalarını tutmalısınız';

  @override
  String get library_entries => 'Kütüphane Girişleri';

  @override
  String get chapters_and_episode => 'Bölümler ve Bölüm';

  @override
  String get every_6_hours => 'Her 6 Saatte Bir';

  @override
  String get every_12_hours => 'Her 12 Saatte Bir';

  @override
  String get daily => 'Günlük';

  @override
  String get every_2_days => 'Her 2 Günde Bir';

  @override
  String get weekly => 'Haftalık';

  @override
  String get restore_backup_warning_title =>
      'Bir yedeği geri yüklemek mevcut tüm verilerin üzerine yazacaktır.\n\nGeri yüklemeye devam et?';

  @override
  String get restore_sync_question_title =>
      'Bu geri yükleme senkronize edilsin mi?';

  @override
  String get restore_sync_question_message =>
      'Cihaz bir senkronizasyon sunucusuna bağlı. Geri yüklenen veriler sunucuya yüklensin mi?';

  @override
  String get restore_sync_question_confirm => 'Evet, senkronize et';

  @override
  String get restore_sync_question_deny => 'Hayır, senkronizasyonu kapat';

  @override
  String get sync_disabled_after_restore =>
      'Senkronizasyon devre dışı bırakıldı. Ayarlar\'dan tekrar açabilirsiniz.';

  @override
  String get restore_sync_disabled_question_title =>
      'Senkronizasyon devre dışı';

  @override
  String get restore_sync_disabled_question_message =>
      'Senkronizasyon kapalı. Tekrar açıp sunucuya yüklemek ister misiniz?';

  @override
  String get restore_sync_question_reenable =>
      'Evet, etkinleştir ve senkronize et';

  @override
  String get restore_sync_question_keep_disabled => 'Kapalı tut';

  @override
  String get restore_sync_uploading =>
      'Geri yüklenen veriler sunucuyla senkronize ediliyor…';

  @override
  String get restore_sync_upload_success =>
      'Veriler sunucuyla senkronize edildi';

  @override
  String get services => 'Hizmetler';

  @override
  String get tracking_warning_info =>
      'İzleme hizmetlerinde bölüm ilerlemesini güncellemek için tek yönlü senkronizasyon. Bireysel girişler için izlemeyi, izleme düğmesinden ayarlayın.';

  @override
  String get use_page_tap_zones => 'Sayfa Dokunma Bölgelerini Kullan';

  @override
  String get manage_trackers => 'İzleyicileri Yönet';

  @override
  String get restore => 'Geri Yükle';

  @override
  String get backups => 'Yedekler';

  @override
  String get by_scanlator => 'Taramacıya Göre';

  @override
  String get by_name => 'İsme Göre';

  @override
  String get installed => 'Yüklendi';

  @override
  String get auto_scroll => 'Otomatik Kaydırma';

  @override
  String get video_audio => 'Ses';

  @override
  String get video_audio_info =>
      'Tercih edilen diller, perde düzeltmesi, ses kanalları';

  @override
  String get player => 'Oyuncu';

  @override
  String get markEpisodeAsSeenSetting =>
      'Bölümün izlendiği olarak işaretleneceği nokta';

  @override
  String get mark_duplicate_chapters_read =>
      'Yinelenen bölüm numaralarını okunmuş olarak işaretleyin';

  @override
  String get default_skip_intro_length => 'Varsayılan Giriş Atla süresi';

  @override
  String get default_playback_speed_length => 'Varsayılan Oynatma hızı süresi';

  @override
  String get updateProgressAfterReading =>
      'Okuduktan Sonra İlerlemeyi Güncelle';

  @override
  String get no_sources_installed => 'Hiçbir kaynak yüklü değil!';

  @override
  String get show_extensions => 'uzantıları göster';

  @override
  String get default_skip_forward_skip_length =>
      'Varsayılan ileri atlama atlama uzunluğu';

  @override
  String get aniskip_requires_info =>
      'AniSkip, çalışması için animenin MAL veya Anilist ile takip edilmesini gerektirir.';

  @override
  String get enable_aniskip => 'AniSkip\'i Etkinleştir';

  @override
  String get enable_auto_skip => 'Otomatik Atla\'yı Etkinleştir';

  @override
  String get aniskip_button_timeout => 'Düğme Zaman Aşımı';

  @override
  String get skip_opening => 'Açılışı atla';

  @override
  String get skip_ending => 'Sonu atla';

  @override
  String get fullscreen => 'Tam ekran';

  @override
  String get update_library => 'Kütüphaneyi güncelle';

  @override
  String get next_chapter => 'Sonraki bölüm';

  @override
  String get next_5_chapters => 'Sonraki 5 bölüm';

  @override
  String get next_10_chapters => 'Sonraki 10 bölüm';

  @override
  String get next_25_chapters => 'Sonraki 25 bölüm';

  @override
  String get all_chapters => 'Tüm bölümler';

  @override
  String get next_episode => 'Sonraki Bölüm';

  @override
  String get next_5_episodes => 'Sonraki 5 Bölüm';

  @override
  String get next_10_episodes => 'Sonraki 10 Bölüm';

  @override
  String get next_25_episodes => 'Sonraki 25 Bölüm';

  @override
  String get all_episodes => 'Tüm bölümler';

  @override
  String get cover_saved => 'Kapak kaydedildi';

  @override
  String get set_as_cover => 'Kapak olarak ayarla';

  @override
  String get use_this_as_cover_art => 'Bu resmi kapak sanatı olarak kullan?';

  @override
  String get save => 'Kaydet';

  @override
  String get picture_saved => 'Resim kaydedildi';

  @override
  String get cover_updated => 'Kapak güncellendi';

  @override
  String get include_subtitles => 'Altyazıları dahil et';

  @override
  String get blend_mode_default => 'Varsayılan';

  @override
  String get blend_mode_multiply => 'Çarpma';

  @override
  String get blend_mode_screen => 'Ekran';

  @override
  String get blend_mode_overlay => 'Örtüşme';

  @override
  String get blend_mode_colorDodge => 'RenkDodge';

  @override
  String get blend_mode_lighten => 'Açık';

  @override
  String get blend_mode_colorBurn => 'RenkYakma';

  @override
  String get blend_mode_darken => 'Karart';

  @override
  String get blend_mode_difference => 'Fark';

  @override
  String get blend_mode_saturation => 'Doygunluk';

  @override
  String get blend_mode_softLight => 'YumuşakIşık';

  @override
  String get blend_mode_plus => 'Artı';

  @override
  String get blend_mode_exclusion => 'Dışlama';

  @override
  String get custom_color_filter => 'Özel renk filtresi';

  @override
  String get color_filter_blend_mode => 'Renk filtresi karışım modu';

  @override
  String get enable_all => 'Tümünü Etkinleştir';

  @override
  String get disable_all => 'Tümünü Devre Dışı Bırak';

  @override
  String get font => 'Yazı Tipi';

  @override
  String get color => 'Renk';

  @override
  String get font_size => 'Yazı Boyutu';

  @override
  String get text => 'Metin';

  @override
  String get border => 'Kenarlık';

  @override
  String get background => 'Arka Plan';

  @override
  String get no_subtite_warning_message =>
      'Bu videoda altyazı parçaları olmadığı için etkisi yok';

  @override
  String get grid_size => 'Kılavuz Boyutu';

  @override
  String n_per_row(Object n) {
    return '$n satır başına';
  }

  @override
  String get horizontal_continious => 'Yatay sürekli';

  @override
  String get edit_code => 'Kodu düzenle';

  @override
  String get use_libass => 'libass\'ı etkinleştir';

  @override
  String get use_libass_info =>
      'Yerel arka uç için libass tabanlı altyazı rendere etmeyi kullanın.';

  @override
  String get libass_not_disable_message =>
      'Altyazıları özelleştirmek için oyuncu ayarlarında `libass kullan` seçeneğini devre dışı bırakın.';

  @override
  String get override_ass_subtitles => 'ASS altyazılarını geçersiz kıl';

  @override
  String get override_ass_subtitles_info =>
      'ASS/SSA altyazılarına özel stil uygula';

  @override
  String get torrent_stream => 'Torrent Akışı';

  @override
  String get add_torrent => 'Torrent ekle';

  @override
  String get enter_torrent_hint_text =>
      'Manyetik veya torrent dosyası URL\'sini girin';

  @override
  String get torrent_url => 'Torrent URL\'si';

  @override
  String get or => 'VEYA';

  @override
  String get advanced => 'Gelişmiş';

  @override
  String get advanced_info => 'mpv yapılandırması';

  @override
  String get use_native_http_client => 'Yerel http istemcisini kullan';

  @override
  String get use_native_http_client_info =>
      'otomatik olarak VPN\'ler gibi platform özelliklerini destekler, HTTP/3 gibi daha fazla HTTP özelliğini ve özel yönlendirme işlemlerini destekler';

  @override
  String n_hour_ago(Object hour) {
    return '$hour saat önce';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours saat önce';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute dakika önce';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes dakika önce';
  }

  @override
  String n_day_ago(Object day) {
    return '$day gün önce';
  }

  @override
  String get now => 'şimdi';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Kütüphane son güncelleme: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Veri ve depolama';

  @override
  String get download_location_info => 'Bölüm indirmeleri için kullanılır';

  @override
  String get storage => 'Depolama';

  @override
  String get clear_chapter_and_episode_cache =>
      'Bölüm ve bölüm önbelleğini temizle';

  @override
  String get cache_cleared => 'Önbellek temizlendi';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Uygulama açıldığında bölüm/bölüm önbelleğini temizle';

  @override
  String get app_settings => 'Uygulama ayarları';

  @override
  String get sources_settings => 'Kaynak ayarları';

  @override
  String get include_sensitive_settings =>
      'Hassas ayarları dahil et (ör. izleyici giriş token\'ları)';

  @override
  String get create => 'Oluştur';

  @override
  String get downloads_are_limited_to_wifi =>
      'İndirmeler yalnızca Wi-Fi ile sınırlıdır';

  @override
  String get recommendations => 'Öneriler';

  @override
  String get recommendations_similar => 'benzer';

  @override
  String get recommendations_weights => 'Öneri ağırlıkları';

  @override
  String get recommendations_weights_genre => 'Tür benzerliği';

  @override
  String get recommendations_weights_setting => 'Ortam benzerliği';

  @override
  String get recommendations_weights_synopsis => 'Hikaye benzerliği';

  @override
  String get recommendations_weights_theme => 'Tema benzerliği';

  @override
  String get manga_extensions_repo => 'Manga uzantıları deposu';

  @override
  String get anime_extensions_repo => 'Anime uzantıları deposu';

  @override
  String get novel_extensions_repo => 'Roman uzantıları deposu';

  @override
  String get custom_dns =>
      'Özel DNS (sistem DNS\'ini kullanmak için boş bırakın)';

  @override
  String get android_proxy_server =>
      'Android Proxy Sunucusu (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'M-Extension-Server\'i edinin';

  @override
  String get undefined => 'Tanımsız';

  @override
  String get empty_extensions_repo =>
      'Burada hiçbir depo URL\'si yok. Bir tane eklemek için artı düğmesine tıklayın!';

  @override
  String get add_extensions_repo => 'Depo URL\'si ekle';

  @override
  String get remove_extensions_repo => 'Depo URL\'sini kaldır';

  @override
  String get manage_manga_repo_urls => 'Manga depo URL\'lerini yönet';

  @override
  String get manage_anime_repo_urls => 'Anime depo URL\'lerini yönet';

  @override
  String get manage_novel_repo_urls => 'Roman depo URL\'lerini yönet';

  @override
  String get url_cannot_be_empty => 'URL boş olamaz';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL .json / .pb ile bitmelidir';

  @override
  String get repo_url => 'Depo URL\'si';

  @override
  String get invalid_url_format => 'Geçersiz URL formatı';

  @override
  String get clear_all_sources => 'Tüm kaynakları temizle';

  @override
  String get clear_all_sources_msg =>
      'Bu, uygulamadaki tüm kaynakları tamamen temizleyecektir. Devam etmek istediğinizden emin misiniz?';

  @override
  String get sources_cleared => 'Kaynaklar temizlendi!';

  @override
  String get repo_added => 'Kaynak deposu eklendi!';

  @override
  String get repo_already_exists => 'Depo zaten mevcut!';

  @override
  String get add_repo => 'Depo ekle?';

  @override
  String get add_repo_sources_to_add => 'Extension lists that will be added:';

  @override
  String get add_repo_warning =>
      'Extensions from these repositories run inside the app. Only add repositories you trust.';

  @override
  String get genre_search_library => 'Kütüphanede tür ara';

  @override
  String get genre_search_source => 'Kaynağı keşfet';

  @override
  String get source_not_added => 'Kaynak yüklenmedi!';

  @override
  String get load_own_subtitles => 'Kendi altyazılarınızı yükleyin...';

  @override
  String get search_subtitles => 'Çevrimiçi altyazı ara...';

  @override
  String extension_notes(Object notes) {
    return 'Notlar: $notes';
  }

  @override
  String get unsupported_repo =>
      'Bu kaynak deposu eklenemedi. Depo adresini kontrol edin veya deponun bakımını yapan kişiyle iletişime geçin.';

  @override
  String get you_have_finished_reading => 'Okumayı bitirdiniz';

  @override
  String get hwdec => 'Donanım kod çözücü';

  @override
  String get enable_hardware_accel => 'Donanım hızlandırma';

  @override
  String get enable_hardware_accel_info =>
      'Hata veya çökmelerle karşılaşırsanız açın/kapatın';

  @override
  String get track_library_navigate => 'Mevcut yerel girişe git';

  @override
  String get track_library_add => 'Yerel kütüphaneye ekle';

  @override
  String get track_library_add_confirm =>
      'İzlenen öğeyi yerel kütüphaneye ekle';

  @override
  String get track_library_not_logged =>
      'Bu özelliği kullanmak için ilgili izleyicide oturum açın!';

  @override
  String get track_library_switch => 'Başka bir izleyiciye geç';

  @override
  String get go_back => 'Geri dön';

  @override
  String get merge_library_nav_mobile =>
      'Mobilde kütüphane gezinmesini birleştir';

  @override
  String get enable_discord_rpc => 'Discord RPC\'yi etkinleştir';

  @override
  String get hide_discord_rpc_incognito => 'Gizli modda Discord RPC\'yi gizle';

  @override
  String get rpc_show_reading_watching_progress =>
      'Discord\'da mevcut bölümü göster (yeniden başlatma gerektirir)';

  @override
  String get rpc_show_title => 'Discord\'da mevcut başlığı göster';

  @override
  String get rpc_show_cover_image => 'Discord\'da mevcut kapak resmini göster';

  @override
  String get enable_mpv => 'mpv gölgelendiricilerini / betiklerini etkinleştir';

  @override
  String get mpv_info => 'mpv/scripts/ altında .js betiklerini destekler';

  @override
  String get mpv_redownload => 'mpv yapılandırma dosyalarını yeniden indir';

  @override
  String get mpv_redownload_info =>
      'Eski yapılandırma dosyalarını yenileriyle değiştirir!';

  @override
  String get mpv_download =>
      'MPV yapılandırma dosyaları gerekli!\nŞimdi indir?';

  @override
  String get custom_buttons => 'Özel düğmeler';

  @override
  String get custom_buttons_info => 'Özel düğmelerle lua kodu çalıştır';

  @override
  String get custom_buttons_edit => 'Özel düğmeleri düzenle';

  @override
  String get custom_buttons_add => 'Özel düğme ekle';

  @override
  String get custom_buttons_added => 'Özel düğme eklendi!';

  @override
  String get custom_buttons_delete => 'Özel düğmeyi sil';

  @override
  String get custom_buttons_text => 'Düğme metni';

  @override
  String get custom_buttons_text_req => 'Düğme metni gerekli';

  @override
  String get custom_buttons_js_code => 'lua kodu';

  @override
  String get custom_buttons_js_code_req => 'lua kodu gerekli';

  @override
  String get custom_buttons_js_code_long => 'lua kodu (uzun basışta)';

  @override
  String get custom_buttons_startup => 'lua kodu (başlangıçta)';

  @override
  String get custom_buttons_add_warning =>
      'This button runs the Lua code below in the video player, which can access your files and run programs. Only add it if you trust where this link came from.';

  @override
  String n_days(Object n) {
    return '$n gün';
  }

  @override
  String get decoder => 'Kod çözücü';

  @override
  String get decoder_info => 'Donanım kod çözme, piksel formatı, debanding';

  @override
  String get enable_gpu_next => 'gpu-next\'i etkinleştir (sadece Android)';

  @override
  String get enable_gpu_next_info => 'Yeni video işleme motoru';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'YUV420P piksel formatını kullan';

  @override
  String get use_yuv420p_info =>
      'Bazı video codec\'lerinde siyah ekranları düzeltebilir, kalite pahasına performansı da artırabilir';

  @override
  String get audio_preferred_languages => 'Tercih edilen diller';

  @override
  String get audio_preferred_languages_info =>
      'Birden fazla ses akışına sahip bir videoda varsayılan olarak seçilecek ses dil(ler)i, 2/3 harfli dil kodları (örn: tr, en, ja). Birden fazla değer virgülle ayrılabilir.';

  @override
  String get enable_audio_pitch_correction =>
      'Ses perdesi düzeltmeyi etkinleştir';

  @override
  String get enable_audio_pitch_correction_info =>
      'Daha yüksek hızlarda sesin tiz, daha düşük hızlarda pes olmasını önler';

  @override
  String get audio_channels => 'Ses kanalları';

  @override
  String get volume_boost_cap => 'Ses yükseltme sınırı';

  @override
  String get internal_player => 'Dahili oynatıcı';

  @override
  String get internal_player_info => 'İlerleme, kontroller, yönelim';

  @override
  String get subtitle_delay_text => 'Altyazı gecikmesi';

  @override
  String get subtitle_delay => 'Gecikme (ms)';

  @override
  String get subtitle_speed => 'Hız';

  @override
  String get tracks => 'Parçalar';

  @override
  String get playback_speed => 'Oynatma hızı';

  @override
  String get shaders => 'Gölgelendiriciler';

  @override
  String get video_fit => 'Sığdır';

  @override
  String get calendar => 'Takvim';

  @override
  String get calendar_no_data => 'Henüz veri yok.';

  @override
  String get calendar_info =>
      'Takvim, bir sonraki bölüm yüklemesini yalnızca eski yüklemelere göre tahmin edebilir. Bazı veriler %100 doğru olmayabilir!';

  @override
  String in_n_day(Object days) {
    return '$days gün içinde';
  }

  @override
  String in_n_days(Object days) {
    return '$days gün içinde';
  }

  @override
  String get clear_library => 'Kütüphaneyi temizle';

  @override
  String get clear_library_desc =>
      'Tüm manga, anime ve/veya roman girişlerini temizlemeyi seçin';

  @override
  String get clear_library_input =>
      'İlgili tüm girişleri kaldırmak için \'manga\', \'anime\' ve/veya \'novel\' yazın (virgülle ayrılmış)';

  @override
  String get watch_order => 'İzleme sırası';

  @override
  String get watch_order_role_current => 'Current';

  @override
  String get watch_order_role_previous => 'Previous';

  @override
  String get watch_order_role_next => 'Next';

  @override
  String get watch_order_source_release_order => 'Release order';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name by $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Official Trakt collection: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt collection: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Seasons for $title';
  }

  @override
  String get watch_order_select_source => 'Order source';

  @override
  String watch_order_season(int number) {
    return 'Season $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Episode $number';
  }

  @override
  String get sequels => 'Devam filmleri';

  @override
  String get recommendations_similarity => 'Benzerlik:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Rating $rating';
  }

  @override
  String get local_folder_structure => 'Yerel klasör yapısı';

  @override
  String get local_folder => 'Yerel klasörler';

  @override
  String get add_local_folder => 'Yerel klasör ekle';

  @override
  String get rescan_local_folder => 'Tüm yerel klasörleri şimdi yeniden tara';

  @override
  String get default_download_destination => 'Varsayılan indirme konumu';

  @override
  String get ask_download_destination => 'İndirme konumunu sor';

  @override
  String get ask_download_destination_desc =>
      'Her indirme başladığında yerel bir klasör seçin.';

  @override
  String get select_download_destination => 'İndirme konumunu seçin';

  @override
  String get clear_local_library => 'Yerel kitaplığı temizle';

  @override
  String get clear_local_library_desc =>
      'Yerel klasör ve arşiv girdilerini kitaplıktan kaldırın.';

  @override
  String get clear_local_library_msg =>
      'Yerel klasör ve arşivler kitaplıktan kaldırılacak. Disk üzerindeki dosyalar silinmez.';

  @override
  String get custom => 'Özel';

  @override
  String get no_local_folder_available_for_downloads =>
      'İndirmeler için yerel klasör bulunamadı';

  @override
  String failed_to_create_cbz(Object error) {
    return 'CBZ oluşturulamadı: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Kapak resmi okunamadı: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Meta veri okunamadı: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Kitaplığa kaydedilirken hata: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Bölüm kapağı okunamadı: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Arşiv kapağı okunamadı: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Yerel kitaplık alınamadı: $error';
  }

  @override
  String get export_metadata => 'Meta verileri dışa aktar';

  @override
  String get exported => 'Dışa aktarıldı';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Meta veri dışa aktarılamadı: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count bölüm otomatik numaralandırılamadı.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Cloudflare çözüm sunucusu başlatılamadı.';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker belirtecinin süresi doldu';
  }

  @override
  String get video_list_empty => 'Video listesi boş';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return '$url açılamadı';
  }

  @override
  String get text_size => 'Metin Boyutu:';

  @override
  String get text_align => 'Metin Hizalama';

  @override
  String get line_height => 'Satır Yüksekliği';

  @override
  String get show_scroll_percentage => 'Kaydırma Yüzdesini Göster';

  @override
  String get remove_extra_paragraph_spacing =>
      'Ekstra Paragraf Aralığını Kaldır';

  @override
  String select_label_color(Object label) {
    return '$label Rengini Seç';
  }

  @override
  String get default_user_agent => 'Varsayılan Kullanıcı Aracısı';

  @override
  String get forceLandscapeMode => 'Yatay Modu Zorla';

  @override
  String get forceLandscapeModeSubtitle =>
      'Oynatıcıyı yatay yönelim kullanmaya zorla.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNS Sağlayıcısı';

  @override
  String get tracked => 'İzlendi';

  @override
  String get auth_unlock_msg =>
      'NodeLane Comics\'yi kilitlemek için kimliğinizi doğrulayın';

  @override
  String get app_locked => 'NodeLane Comics kilitli';

  @override
  String get auth_to_continue => 'Devam etmek için kimliğinizi doğrulayın';

  @override
  String get authenticating => 'Kimlik doğrulanıyor...';

  @override
  String get lock => 'Kilitle';

  @override
  String get unlock => 'Kilit Aç';

  @override
  String get security => 'Güvenlik';

  @override
  String get auth_to_change_security_setting =>
      'Güvenlik ayarlarını değiştirmek için kimliğinizi doğrulayın';

  @override
  String get app_lock => 'Uygulama Kilidi';

  @override
  String get require_biometric_or_device_credential =>
      'Uygulamayı açmak için biyometrik kimlik doğrulamak veya cihaz kimlik bilgileri gerekir';

  @override
  String get biometric_or_device_credential_not_available =>
      'Biyometrik kimlik doğrulama bu cihazda kullanılamaz';

  @override
  String get app_lock_description =>
      'Uygulama kilidi etkinleştirildiğinde, uygulamayı her açtığınızda veya arka plandan döndüğünüzde kimlik doğrulaması yapmanız istenir.';

  @override
  String get checking_device_authentication =>
      'Checking device authentication…';

  @override
  String get device_authentication_incomplete =>
      'Authentication was not completed. Your setting has not changed.';

  @override
  String get keep_screen_on => 'Ekranı Açık Tut';

  @override
  String get webtoon_side_padding => 'Webtoon Yan Dolgusu';

  @override
  String get show_page_gaps => 'Sayfa Boşluklarını Göster';

  @override
  String get invert_colors => 'Renkleri Ters Çevir';

  @override
  String get grayscale => 'Gri Tonlama';

  @override
  String get brightness => 'Parlaklık';

  @override
  String get contrast => 'Kontrast';

  @override
  String get saturation => 'Doyum';

  @override
  String get navigation_layout => 'Navigasyon Düzeni';

  @override
  String get nav_layout_default => 'Varsayılan';

  @override
  String get nav_layout_l_shaped => 'L Şekil';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Kenar';

  @override
  String get nav_layout_right_and_left => 'Sağ ve Sol';

  @override
  String get nav_layout_disabled => 'Devre Dışı';

  @override
  String get color_enhancements => 'Renk İyileştirmeleri';

  @override
  String get total => 'Toplam';

  @override
  String get mean_per_title => 'Başlık başına ortalama';

  @override
  String get completion_rate => 'Tamamlanma oranı';

  @override
  String get watching_time => 'İzleme süresi';

  @override
  String get reading_time => 'Okuma süresi';

  @override
  String average_chapters_per_title(Object title) {
    return 'Başlık başına ortalama bölüm';
  }

  @override
  String get read_percentage => 'Okuma yüzdesi';

  @override
  String get entries => 'Girdiler';

  @override
  String get android_proxy_server_mihon => 'Android Proxy Sunucusu (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Mihon eklentilerini kullanmak için gereken proxy sunucusunu indirin ve yapılandırın.';

  @override
  String get mihon_proxy_server => 'Mihon proxy sunucusu';

  @override
  String get extension_server_intro_with_jre =>
      'Mihon eklentilerini kullanmadan önce proxy sunucu paketini indirin. Paket, JRE ve eklenti sunucusu JAR dosyasını içerir.';

  @override
  String get extension_server_intro_ios =>
      'Mihon eklentilerini kullanmadan önce proxy sunucusu JAR dosyasını indirin. iOS için sadece eklenti sunucusu JAR dosyası gereklidir.';

  @override
  String get checking_files => 'Dosyalar kontrol ediliyor';

  @override
  String get files_installed => 'Dosyalar yüklendi';

  @override
  String get files_missing => 'Dosyalar eksik';

  @override
  String get update_files => 'Dosyaları güncelle';

  @override
  String get up_to_date => 'Güncel';

  @override
  String get choose_location => 'Konum seç';

  @override
  String get import_existing_jar => 'Mevcut JAR dosyasını içe aktar';

  @override
  String get detect_files_in_selected_folder =>
      'Seçilen klasördeki dosyaları algıla';

  @override
  String get preparing_download => 'İndirme hazırlanıyor...';

  @override
  String get app_install_location => 'Uygulama yükleme konumu';

  @override
  String get install_location => 'Yükleme konumu';

  @override
  String get jre_executable => 'JRE yürütülebilir dosyası';

  @override
  String get extension_server_jar => 'Eklenti sunucusu JAR\'ı';

  @override
  String get installed_version => 'Yüklü sürüm';

  @override
  String get latest_version => 'Son sürüm';

  @override
  String get m_extension_server_description =>
      'Ayrı bir Android cihaz proxy\'sine ihtiyacınız olduğunda M-Extension-Server kullanın. Proxy adresini buradan ayarlayın ve APK\'yı GitHub\'dan indirin.';

  @override
  String get set_proxy_address => 'Proxy adresini ayarla';

  @override
  String get no_newer_proxy_server_release_available =>
      'Daha yeni bir proxy sunucusu sürümü mevcut değil.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Proxy sunucusu güncellemeleri kontrol edilemedi.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Bu platform için sunucu paketi mevcut değil.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Paket indirme başarısız oldu ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'İndirilen paket beklenen dosyaları içermiyor.';

  @override
  String get extension_server_files_ready =>
      'Eklenti sunucusu dosyaları hazır.';

  @override
  String get ios_extension_server_import_hint =>
      'iOS\'ta sunucu uygulama sandbox\'ı içine yüklenir. İndirilen bir dosyayı getirmek için \"Mevcut JAR dosyasını içe aktar\" seçeneğini kullanın.';

  @override
  String get select_extension_server_folder =>
      'Eklenti sunucusu klasörünü seçin';

  @override
  String get selected_folder_does_not_exist => 'Seçilen klasör mevcut değil.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Seçilen klasörde eklenti sunucusu dosyası bulunamadı.';

  @override
  String get extension_server_files_linked =>
      'Eklenti sunucusu dosyaları bağlandı.';

  @override
  String get select_extension_server_jar =>
      'Eklenti sunucusu JAR dosyasını seçin';

  @override
  String get selected_file_could_not_be_accessed =>
      'Seçilen dosyaya erişilemedi.';

  @override
  String get extension_server_jar_imported =>
      'Eklenti sunucusu JAR\'ı içe aktarıldı.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'M-Extension-Server sayfası başlatılamadı.';

  @override
  String get proxy_server_ip_hint =>
      'Sunucu IP\'si (örn. 10.0.0.5 veya https://example.com)';

  @override
  String get not_configured => 'Yapılandırılmadı';

  @override
  String get zero_interpreter => 'Zero yorumlayıcı';

  @override
  String get zero_interpreter_description =>
      'Zero yorumlayıcı sunucusunu otomatik veya manuel kontrol edin.';

  @override
  String get start_server_on_launch => 'Başlangıçta sunucuyu başlat';

  @override
  String get runtime_status => 'Çalışma durumu';

  @override
  String get running => 'Çalışıyor';

  @override
  String get stopped => 'Durduruldu';

  @override
  String get start => 'Başlat';

  @override
  String get stop => 'Durdur';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Metinden Sese';

  @override
  String get tts_speed => 'Hız';

  @override
  String get tts_pitch => 'Perde';

  @override
  String get tts_language => 'Dil';

  @override
  String get tts_voice => 'Ses';

  @override
  String get tts_stop => 'Dur';

  @override
  String get tts_play => 'Oynat';

  @override
  String get tts_pause => 'Duraklat';

  @override
  String get tts_previous => 'Önceki paragraf';

  @override
  String get tts_next => 'Sonraki paragraf';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Paragraf $current / $total';
  }

  @override
  String get tts_settings => 'TTS Ayarları';

  @override
  String get tts_default => 'Varsayılan';

  @override
  String get webtoon_disable_zoom_out =>
      'Webtoon uzaklaştırmayı devre dışı bırak';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Webtoon yakınlaştırma için çift dokun';

  @override
  String get navigate_to_pan => 'Kaydırmak için gezin';

  @override
  String get navigate_to_pan_subtitle =>
      'Sayfa çevirmeden önce yakınlaştırılmış resmi hareket ettir';

  @override
  String get split_wide_pages => 'Geniş sayfaları böl';

  @override
  String get dual_page_invert => 'Bölünen yarım sayfaları ters çevir';

  @override
  String get dual_page_rotate_to_fit => 'Sığdırmak için döndür';

  @override
  String get dual_page_rotate_to_fit_invert => 'Döndürme yönünü tersine çevir';

  @override
  String get double_page_single_first_page => 'İlk sayfa tekli';

  @override
  String get double_page_single_first_page_subtitle =>
      'Çift sayfa modunda ilk sayfayı tek başına göster';

  @override
  String get double_page_auto => 'Otomatik çift sayfa';

  @override
  String get double_page_auto_subtitle =>
      'Yatay modda otomatik olarak çift sayfa moduna geç';

  @override
  String get landscape_zoom => 'Otomatik yatay yakınlaştırma';

  @override
  String get zoom_start_position => 'Yakınlaştırma başlangıç konumu';

  @override
  String get zoom_start_left => 'Sol';

  @override
  String get zoom_start_right => 'Sağ';

  @override
  String get zoom_start_center => 'Orta';

  @override
  String get automatic_background => 'Otomatik arka plan';

  @override
  String get tapping_inversion => 'Dokunma tersine çevirme';

  @override
  String get tapping_inversion_none => 'Hiçbiri';

  @override
  String get tapping_inversion_horizontal => 'Yatay';

  @override
  String get tapping_inversion_vertical => 'Dikey';

  @override
  String get tapping_inversion_both => 'Her ikisi';

  @override
  String get flash_on_page_change => 'Sayfa geçişinde flaş';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED iz önleme yardımcısı';

  @override
  String get flash_color => 'Flaş Rengi';

  @override
  String get flash_color_black => 'Siyah';

  @override
  String get flash_color_white => 'Beyaz';

  @override
  String get flash_color_white_black => 'Beyaz & Siyah';

  @override
  String get flash_interval_label => 'Flaş Aralığı';

  @override
  String flash_interval_value(String n) {
    return '$n sayfa';
  }

  @override
  String flash_interval(String n) {
    return 'Flaş Aralığı: $n sayfa';
  }

  @override
  String get flash_duration_label => 'Flaş Süresi';

  @override
  String flash_duration_value(String n) {
    return '$n ms';
  }

  @override
  String flash_duration(String n) {
    return 'Flaş Süresi: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Başlangıçta gezinme panelini göster';

  @override
  String get reader_hide_threshold => 'Okuyucu Gizleme Eşiği';

  @override
  String get reader_hide_threshold_highest => 'En yüksek (5 px)';

  @override
  String get reader_hide_threshold_high => 'Yüksek (13 px)';

  @override
  String get reader_hide_threshold_low => 'Düşük (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'En düşük (47 px)';

  @override
  String get error_no_pages_available => 'Hata: kullanılabilir sayfa yok';

  @override
  String get app_ui_scale => 'Arayüz ölçeği';

  @override
  String get app_ui_scale_subtitle =>
      'Arayüzü ekranınıza ve görüntüleme mesafenize uyacak şekilde büyütün veya küçültün.';

  @override
  String get allow_concurrent_downloads => 'Eş zamanlı indirmelere izin ver';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Farklı kaynaklardan aynı anda indirin. Tek bir kaynak yine de bir seferde bir bölümü indirir, böylece yükü aşmaz. Her yerde tek tek indirmek için kapatın.';

  @override
  String get download_delay => 'İndirme gecikmesi';

  @override
  String get download_delay_subtitle =>
      'Kapalı. Kaynaklar için daha yumuşak olmak için bölümler arasında rastgele titreme ile bir bekleme ekleyin.';

  @override
  String get save_search => 'Aramayı kaydet';

  @override
  String get saved_searches => 'Kaydedilen aramalar';

  @override
  String get enter_search_to_save_first => 'Kaydedilecek bir arama girin';

  @override
  String get no_saved_searches =>
      'Bu kaynak için kaydedilen arama henüz yok.\nBir arama yapın, ardından \"Aramayı kaydet\" i seçin.';

  @override
  String get source => 'Kaynak';

  @override
  String get something_went_wrong => 'Bir şeyler ters gitti';

  @override
  String get startup_failed => 'NodeLane Comics başlatılamadı';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sonuçsuz $count kaynak',
      one: 'Sonuçsuz 1 kaynak',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Nasıl içe aktarılsın?';

  @override
  String get import_mode_message =>
      'Bu yedeği mevcut kitaplıkla birleştirin veya tüm kitaplığı bununla değiştirin.';

  @override
  String get import_mode_keep_existing => 'Birleştir';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Yeni serileri ekler ve eşleşenleri günceller. Hiçbir şey silinmez.';

  @override
  String get import_mode_replace => 'Değiştir';

  @override
  String get import_mode_replace_subtitle =>
      'Mevcut kitaplığı siler ve bu yedekle değiştirir.';

  @override
  String get replace_summary_title => 'Kitaplık değiştirilmeye hazır';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Bu işlem mevcut $currentCount seriyi silecek ve $backupCount seri ile değiştirecektir.';
  }

  @override
  String get replace_summary_confirm => 'Değiştir';

  @override
  String replace_result_message(Object count) {
    return 'Kitaplık yedekten gelen $count seri ile değiştirildi.';
  }

  @override
  String get category_conflict_title => 'Mevcut kategoriler bulundu';

  @override
  String get category_conflict_message =>
      'Yedekte zaten var olan kategoriler bulundu.';

  @override
  String get category_conflict_keep => 'Koru — mevcut kategoriye birleştir';

  @override
  String get category_conflict_delete => 'Sil — serileri kategorisiz bırak';

  @override
  String get source_conflict_title => 'Kaynaklar bulunamadı';

  @override
  String get source_conflict_message =>
      'Bazı kaynaklar yüklü eklentilerle eşleşmiyor.';

  @override
  String get source_conflict_keep => 'Orijinal adı koru';

  @override
  String get import_summary_title => 'İçe aktarılmaya hazır';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries yeni seri, $updatedSeries güncellenen seri ve $newChapters yeni bölüm.';
  }

  @override
  String get import_summary_confirm => 'İçe aktar';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries yeni seri aktarıldı, $updatedSeries güncellendi, $newChapters bölüm eklendi.';
  }

  @override
  String get roll_back => 'Geri al';

  @override
  String get roll_back_confirm_message =>
      'Kitaplığı bu değişiklikten hemen önceki anlık görüntüye döndürür.';

  @override
  String get roll_back_done => 'Önceki duruma geri dönüldü.';

  @override
  String get restoring_backup => 'Kitaplık geri yükleniyor…';

  @override
  String get roll_back_last_change => 'Son değişikliği geri al';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return '$date tarihli anlık görüntü — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return 'Geri alınabilir $count son değişiklik mevcut';
  }

  @override
  String get delete_source_title => 'Kaynağı ve mangalarını sil';

  @override
  String get delete_source_subtitle =>
      'Bir kaynak seçerek tüm mangalarını, bölümlerini, indirmelerini ve geçmişini kaldırın.';

  @override
  String get delete_source_pick_title => 'Silinecek kaynağı seçin';

  @override
  String get delete_source_empty => 'Kitaplıkta kaynak bulunamadı.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '$sourceName silinsin mi?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return '$mangaCount manga, $chapterCount bölüm, $historyCount geçmiş kaydı kalıcı olarak silinecek.';
  }

  @override
  String get delete_source_also_remove_extension => 'Yüklü eklentiyi de kaldır';

  @override
  String get delete_source_keep_history => 'Okuma geçmişini koru';

  @override
  String get delete_source_keep_downloads => 'İndirme kayıtlarını koru';

  @override
  String get delete_source_button => 'Sil';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '$sourceName kaynağından $mangaCount manga silindi.';
  }

  @override
  String get merge_manga_title => 'Yinelenen mangaları birleştir';

  @override
  String get merge_manga_subtitle =>
      'Aynı kaynak altındaki aynı başlıklı mangaları bulur ve birleştirir.';

  @override
  String get merge_manga_none_found => 'Yinelenen manga bulunamadı.';

  @override
  String get merge_manga_pick_title => 'Olası yinelenen mangalar';

  @override
  String get merge_manga_choose_primary_title =>
      'Diğerleri hangisinde birleştirilsin?';

  @override
  String get merge_manga_choose_primary_message =>
      'Bölümler, geçmiş ve takip seçilen girdiye aktarılacaktır.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bölüm',
      one: '1 bölüm',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Birleştir';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '$count yinelenen manga $mangaName içinde birleştirildi.';
  }

  @override
  String get merge_preview_title => 'Birleştirmeyi onayla';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters bölüm bulundu. $duplicateChapters yinelenen atılacak, $keptChapters eklenecek.';
  }

  @override
  String get memory_overlay => 'Bellek kullanımını göster';

  @override
  String get memory_overlay_subtitle =>
      'Uygulamanın kullandığı belleğin canlı gösterimi. Tahmin etmek yerine cihaz üzerinde ölçüm yapın: kitaplıkta gezinirken veya bir bölüm okurken izleyin.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Hata raporları';

  @override
  String get error_reports_subtitle =>
      'Uygulamanın yakaladığı hatalar ve bildirme yolu';

  @override
  String get error_reports_empty => 'Hata oluşmadı.';

  @override
  String get error_reports_likely_cause => 'Olası neden';

  @override
  String get error_reports_report => 'GitHub\'da Bildir';

  @override
  String get error_reports_banner => 'NodeLane Comics bir hatayla karşılaştı';

  @override
  String get error_reports_banner_action => 'Görüntüle';

  @override
  String get error_reports_copy => 'Kopyala';

  @override
  String get error_reports_copied => 'Panoya kopyalandı';

  @override
  String get error_reports_clear => 'Temizle';

  @override
  String get error_reports_extension_failure =>
      'Bu hata NodeLane Comics\'den değil, bir uzantıdan kaynaklandı. Uzantılar bu kaynağı yüklediğiniz deponun yöneticileri tarafından yazılır ve sürdürülür, bu nedenle düzeltmenin oraya yapılması gerekir.';

  @override
  String get error_reports_already_reported => 'Zaten bildirildi';

  @override
  String get error_reports_expected_failure =>
      'Bu durum genellikle uygulamadan ziyade kaynak veya ağdan kaynaklanır: süresi dolmuş bir bağlantı, çökmüş bir sunucu veya kopan bir bağlantı.';

  @override
  String get share_unavailable_copied =>
      'Paylaşım kullanılamıyor, panoya kopyalandı.';

  @override
  String get onboarding_title => 'NodeLane Comics\'ye Hoş Geldiniz';

  @override
  String get onboarding_libraries_body =>
      'Okumak ve izlemek istediklerinizi seçin.';

  @override
  String get onboarding_nav_title => 'Kitaplıklarınız';

  @override
  String get onboarding_nav_body =>
      'Her biri için ayrı sekme veya tek bir Kitaplık sekmesi altında toplayın.';

  @override
  String get onboarding_nav_split => 'Ayrı sekmeler';

  @override
  String get onboarding_nav_merged => 'Tek Kitaplık sekmesi';

  @override
  String get onboarding_nav_inside =>
      'Kitaplık\'a dokunmak sekmeleri değiştirir';

  @override
  String get onboarding_next => 'İleri';

  @override
  String get onboarding_restore => 'Yedekten geri yükle';

  @override
  String get onboarding_or_local => 'Veya mevcut dosyaları kullanın';

  @override
  String get onboarding_local_folder => 'Klasör ekle';

  @override
  String onboarding_local_existing(Object count) {
    return '$count klasör zaten ayarlanmış';
  }

  @override
  String get onboarding_local_any_type => 'Manga, anime ve novel desteklenir.';

  @override
  String get onboarding_local_scanning => 'Klasör taranıyor';

  @override
  String onboarding_local_found(Object count) {
    return '$count başlık bulundu';
  }

  @override
  String get onboarding_local_remove => 'Klasörü kaldır';

  @override
  String get onboarding_local_in_downloads =>
      'Bu uygulamanın indirme klasörüdür.';

  @override
  String get onboarding_local_empty =>
      'Hiçbir şey bulunamadı. Ana klasörü seçin.';

  @override
  String get onboarding_repo_failed => 'Depo okunamadı.';

  @override
  String get onboarding_repo_title => 'Kaynak ekle';

  @override
  String get onboarding_body => 'Eklentileri yüklemek için bir depo ekleyin.';

  @override
  String get onboarding_add => 'Depo ekle';

  @override
  String get onboarding_skip => 'Şimdilik atla';

  @override
  String get onboarding_continue => 'Devam et';

  @override
  String get onboarding_later =>
      'Daha sonra Ayarlar > Gözat bölümünden ekleyebilirsiniz.';

  @override
  String get onboarding_replay => 'Karşılama ekranını göster';

  @override
  String get onboarding_replay_subtitle => 'İlk kurulum ekranını yeniden açar.';

  @override
  String get missing_source_check_title => 'Eksik kaynakları kontrol et';

  @override
  String get missing_source_check_subtitle =>
      'Eklentisi yüklü olmayan girdileri bulur.';

  @override
  String get missing_source_check_none_found => 'Tüm kaynaklar yüklü.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaynak eksik',
      one: '1 kaynak eksik',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Hiçbir $itemType kaynağı yüklü değil.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Gözat altından bir depo ekleyin ve ardından bunun için bir uzantı yükleyin.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaynak',
      one: '1 kaynak',
    );
    return 'Bunun için $_temp0 var, ancak yalnızca sabitlenenler aranır.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Birini sabitleyin veya Gözat ayarlarından \"Yalnızca sabitlenmiş kaynakları dahil et\" seçeneğini kapatın.';

  @override
  String get global_search_all_nsfw =>
      'Bunun için sahip olduğunuz tüm kaynaklar NSFW olarak işaretlenmiş ve gizlenmiştir.';

  @override
  String get global_search_all_nsfw_hint =>
      'Arama yapabilmek için Gözat ayarlarından NSFW kaynaklarını açın.';

  @override
  String get missing_source_check_result_message =>
      'Bu girdiler yüklü olmayan kaynaklara işaret ediyor. Taşımak için dokunun veya eklentiyi yükleyin.';

  @override
  String get related_titles => 'İlgili';

  @override
  String get related_none => 'Bu başlık için ilgili bir şey bulunamadı.';

  @override
  String get relation_adaptation => 'Uyarlama';

  @override
  String get relation_sequel => 'Devam';

  @override
  String get relation_prequel => 'Öncesi';

  @override
  String get relation_parent => 'Ana hikaye';

  @override
  String get relation_side_story => 'Yan hikaye';

  @override
  String get relation_spin_off => 'Yan ürün';

  @override
  String get relation_alternative => 'Alternatif sürüm';

  @override
  String get auto_library_update => 'Otomatik kütüphane güncellemeleri';

  @override
  String get auto_library_update_subtitle =>
      'Uygulama başladığında kütüphanenizdeki her öğeyi yeni bölümler için kontrol edin.';

  @override
  String get auto_library_update_never => 'Asla';

  @override
  String get auto_library_update_12_hours => '12 saatte bir';

  @override
  String get auto_library_update_daily => 'Günlük';

  @override
  String get auto_library_update_2_days => '2 günde bir';

  @override
  String get auto_library_update_weekly => 'Haftalık';

  @override
  String get auto_library_update_wifi_only => 'Yalnızca Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Hücresel verideyken planlanan güncellemeyi atlayın.';

  @override
  String get padding => 'Kenar Boşluğu';

  @override
  String get page_mode => 'Sayfa modu';

  @override
  String get single_page => 'Tek sayfa';

  @override
  String get double_page => 'Çift sayfa';

  @override
  String get speed => 'Hız';

  @override
  String get theme_dark => 'Koyu';

  @override
  String get theme_light => 'Açık';

  @override
  String get theme_black => 'Siyah';

  @override
  String get theme_sepia => 'Sepya';

  @override
  String get decrease => 'Azalt';

  @override
  String get increase => 'Artır';

  @override
  String get chapter_swipe_actions => 'Bölüm kaydırma eylemleri';

  @override
  String get chapter_swipe_start => 'Sağa kaydır';

  @override
  String get chapter_swipe_end => 'Sola kaydır';

  @override
  String get chapter_swipe_toggle_bookmark => 'Yer işaretini aç/kapat';

  @override
  String get chapter_swipe_toggle_read => 'Okundu durumunu değiştir';

  @override
  String get chapter_swipe_download => 'İndir';

  @override
  String get chapter_swipe_disabled => 'Devre dışı';

  @override
  String get update_errors => 'Update errors';

  @override
  String get no_update_errors => 'No update errors';

  @override
  String get clear_all => 'Clear all';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get previous_episode => 'Previous episode';

  @override
  String get clear_logs => 'Clear logs';

  @override
  String get bold => 'Bold';

  @override
  String get italic => 'Italic';

  @override
  String get color_yellow => 'Yellow';

  @override
  String get color_cyan => 'Cyan';

  @override
  String get color_green => 'Green';

  @override
  String get color_orange => 'Orange';

  @override
  String get continue_watching => 'Continue Watching';

  @override
  String get search_your_anime => 'Search your anime';

  @override
  String get category => 'Category';

  @override
  String get hidden_categories => 'Hidden categories';

  @override
  String get new_category => 'New category';

  @override
  String get local => 'Local';

  @override
  String get tv_home_rows => 'Rows';

  @override
  String get genre_rows => 'Genre rows';

  @override
  String get share_backup_file => 'Share NodeLane Comics backup file';

  @override
  String get close => 'Close';

  @override
  String get migrate_source => 'Migrate source';

  @override
  String get cloudflare_bypass_proxy => 'Cloudflare bypass proxy';

  @override
  String get custom_doh_url => 'Custom DoH URL';

  @override
  String get custom_doh_url_helper => 'Must be an https DoH (JSON) endpoint';

  @override
  String get anime_only_tv_layout => 'Anime-only TV layout';

  @override
  String get anime_only_beta => 'Anime only (beta)';

  @override
  String get tv_home_beta => 'TV home (beta)';

  @override
  String get tv_player_beta => 'TV player (beta)';

  @override
  String get network_settings => 'Network';

  @override
  String get reader_page_layout => 'Page layout';

  @override
  String get reader_continuous_options => 'Continuous reading';

  @override
  String get reader_default_mode_hint =>
      'The default reading mode applies to titles without an individual mode set while reading.';

  @override
  String get extension_service => 'Extension service';

  @override
  String get extension_service_description =>
      'Manage the extension runtime and proxy address.';

  @override
  String get proxy_address => 'Proxy address';

  @override
  String get checking_runtime_status => 'Checking status…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + random delay';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Add downloads from a title’s chapter list.';

  @override
  String get download_queue_order_hint => 'Drag handles to reorder';

  @override
  String get download_queue_empty => 'No downloads queued';

  @override
  String get download_queue_actions => 'Download actions';

  @override
  String get download_queue_cancel_chapter => 'Cancel this chapter’s download';

  @override
  String get download_queue_cancel_series =>
      'Cancel all downloads for this title';

  @override
  String get download_queue_start => 'Start downloads';

  @override
  String get download_queue_retry => 'Retry downloads';

  @override
  String get download_queue_active => 'Downloading';

  @override
  String get download_queue_waiting => 'Waiting to download';

  @override
  String get download_queue_failed => 'Download failed';

  @override
  String get cf_proxy_helper =>
      'FlareSolverr / Byparr endpoint. Leave empty to disable.';

  @override
  String get mobile_navigation_description =>
      'Drag to reorder. Manga, anime and novels share the Library tab. The first visible item opens at launch. Browse and More stay visible; extra tabs appear under More.';

  @override
  String get text_align_justify => 'Justify';

  @override
  String get novel_session_modes_hint =>
      'Set reading mode and single or double pages while reading a title.';

  @override
  String get tts_languages_failed =>
      'Could not load languages from the speech engine.';

  @override
  String get tts_languages_empty =>
      'The speech engine returned no languages. Your saved selection is kept.';

  @override
  String get tts_language_unavailable =>
      'This saved language is not in the device’s current list.';

  @override
  String get tts_apply_failed =>
      'Could not apply this setting to the speech engine. You can retry.';

  @override
  String get player_controls => 'Controls';

  @override
  String get audio_channel_auto => 'Automatic';

  @override
  String get audio_channel_auto_safe => 'Automatic (safe)';

  @override
  String get audio_channel_mono => 'Mono';

  @override
  String get audio_channel_stereo => 'Stereo';

  @override
  String get audio_channel_reverse_stereo => 'Reverse stereo';

  @override
  String get mpv_bundled_config_hint =>
      'Restore the configuration, scripts and shaders included with the app. Files with the same names will be overwritten.';

  @override
  String get mpv_restore_bundled => 'Restore bundled configuration';

  @override
  String get mpv_restore_confirm =>
      'Restore the bundled MPV configuration? Existing configuration, scripts and shaders with the same names will be overwritten. Other files will be kept.';

  @override
  String get player_operation_incomplete =>
      'The operation could not be completed. Check file access and try again.';

  @override
  String get custom_buttons_empty_hint =>
      'Add a player button with a label and a press action.';

  @override
  String get custom_button_primary => 'Default button';

  @override
  String get show_password => 'Show password';

  @override
  String get hide_password => 'Hide password';

  @override
  String get tracking_accounts_empty =>
      'Connect a service in Tracking settings to manage its entries.';

  @override
  String get tracking_entries_empty =>
      'No tracked entries for this media type. Add tracking from a title’s detail page.';

  @override
  String get change_tracking_match => 'Change matching title';

  @override
  String get remove_tracking => 'Remove tracking';

  @override
  String remove_tracking_confirm(String title) {
    return 'Remove the tracking link for “$title”? The entry in the tracking service will be kept.';
  }

  @override
  String get tracking_refresh_required =>
      'The tracking state could not be confirmed. Refresh before making another change.';

  @override
  String get tracking_entry_unlinked =>
      'This record is not linked to a local title, so it cannot be edited here.';

  @override
  String get backup_selection_shared =>
      'Changes to these selections are saved immediately and also apply to automatic backups.';

  @override
  String get library_snapshot_history => 'Restore a library snapshot';

  @override
  String get library_snapshot_empty => 'No safety snapshots available.';

  @override
  String get library_snapshot_restore_message =>
      'Current data will be replaced by this snapshot. Changes made since then will be lost. Deleted downloads cannot be restored. Available safety snapshots will be cleared after success.';

  @override
  String get library_maintenance_working => 'Updating library…';

  @override
  String get library_safety_snapshot_note =>
      'A safety snapshot will be saved before this operation. It does not include downloaded files.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Library entries: $mangaCount. Chapters: $chapterCount. History entries: $historyCount. Updates: $updateCount.\n\nChoose what to keep below.';
  }

  @override
  String get library_delete_pick_message =>
      'Choose a source to review its contents and deletion options.';

  @override
  String get mobile_categories_hint =>
      'Drag to reorder. Open a category to rename it or change its visibility and updates.';

  @override
  String get mobile_category_visible => 'Show in library';

  @override
  String get mobile_category_hidden => 'Hidden from library';

  @override
  String get mobile_category_updates => 'Include in library updates';

  @override
  String get statistics_watched => 'Watched';

  @override
  String get calendar_month => 'Month';

  @override
  String get calendar_two_weeks => '2 weeks';

  @override
  String get calendar_week => 'Week';

  @override
  String get calendar_show_all_dates => 'Show all dates';

  @override
  String get update_check_no_result =>
      'No installable update found. You can try again later.';

  @override
  String get release_notes => 'Release notes';

  @override
  String get no_release_notes => 'No release notes provided.';

  @override
  String get downloading_update => 'Downloading update…';

  @override
  String get preparing_installation => 'Preparing installation…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Choose what to read. You can change this later.';

  @override
  String get onboarding_content_title => 'Start reading';

  @override
  String get onboarding_mobile_sources_body =>
      'Choose a way to start, or add content later.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'Results for “$query”';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Search for the destination title.';

  @override
  String get migration_original_item => 'Current item';

  @override
  String get migration_target_item => 'Selected item';

  @override
  String get migration_partial_failure =>
      'The operation did not finish. Some changes may have been saved. Check this item in your library before trying again.';

  @override
  String get migration_no_categories =>
      'No categories. You can add this item without a category.';

  @override
  String get mass_migration_select_source => 'Choose the current source';

  @override
  String get mass_migration_select_all => 'Select all';

  @override
  String get mass_migration_deselect_all => 'Deselect all';

  @override
  String get mass_migration_needs_review => 'Review incomplete migrations';

  @override
  String get bookshelf_actions => 'Bookshelf actions';

  @override
  String get bookshelf_ignore_filters => 'Ignore filters when searching';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Search all works in this category, including those hidden by filters.';

  @override
  String get bookshelf_stop_update => 'Stop library update';

  @override
  String bookshelf_selected_count(int count) {
    return '$count works selected';
  }

  @override
  String get bookshelf_remove_library => 'Remove from bookshelf';

  @override
  String get bookshelf_remove_library_hint =>
      'Removes favorites. Local imports also lose their library and reading records.';

  @override
  String get bookshelf_remove_downloads => 'Delete downloaded files';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Removes downloaded files while keeping work information.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Also deletes selected local imported files and removes their library records. These files cannot be recovered here.';

  @override
  String get bookshelf_remove_incomplete =>
      'The operation did not finish. Some works or files may have been processed. Close this dialog and check your bookshelf and downloads before continuing.';

  @override
  String get bookshelf_processing => 'Processing…';

  @override
  String get bookshelf_mark_read => 'Mark read';

  @override
  String get bookshelf_mark_unread => 'Mark unread';

  @override
  String get bookshelf_select_all => 'Select all';

  @override
  String get bookshelf_invert_selection => 'Invert selection';

  @override
  String get bookshelf_settings => 'Bookshelf settings';

  @override
  String get bookshelf_settings_live =>
      'Filter, sort and display changes take effect immediately.';

  @override
  String get bookshelf_filter_any => 'Any';

  @override
  String get bookshelf_filter_include => 'Include';

  @override
  String get bookshelf_filter_exclude => 'Exclude';

  @override
  String get bookshelf_all_sources => 'All sources';

  @override
  String bookshelf_sources_selected(int count) {
    return '$count sources selected';
  }

  @override
  String get bookshelf_sort_ascending => 'Ascending';

  @override
  String get bookshelf_sort_descending => 'Descending';

  @override
  String get bookshelf_layout => 'Bookshelf layout';

  @override
  String get bookshelf_sources_hint =>
      'Select none to show all sources. Changes apply when you tap Filter.';

  @override
  String get bookshelf_choose_files => 'Choose files';

  @override
  String get bookshelf_import_wait =>
      'Choose a file in the picker and wait for the import to finish.';

  @override
  String get bookshelf_import_incomplete =>
      'Import did not finish. Some files may already be in your bookshelf. Close this dialog and check before importing again.';

  @override
  String get bookshelf_categories_replace =>
      'Saving assigns these categories to every selected work, replacing their previous categories.';

  @override
  String get bookshelf_categories_hint =>
      'Choose one or more categories, or leave the selection empty to assign none.';

  @override
  String get bookshelf_categories_hidden =>
      'Existing hidden categories are kept for this work.';

  @override
  String get bookshelf_categories_incomplete =>
      'Categories could not be saved completely. Close this dialog and check the bookshelf before trying again.';

  @override
  String get bookshelf_categories_none_visible =>
      'No categories are available here. Open category management to review them.';

  @override
  String get bookshelf_manage_categories => 'Manage categories';

  @override
  String get manga_actions => 'Comic actions';

  @override
  String get manga_download_scope => 'Download chapters';

  @override
  String get manga_download_scope_hint =>
      'Choose chapters within the current filters. Downloaded chapters are skipped.';

  @override
  String get manga_download_scope_empty =>
      'No chapters match the current filters. Close this menu and adjust the chapter filters.';

  @override
  String get manga_action_incomplete =>
      'The action did not finish. Check the current state before trying again.';

  @override
  String get chapter_settings => 'Chapter settings';

  @override
  String get chapter_settings_live =>
      'Filter and sort changes apply immediately.';

  @override
  String get chapter_scanlators_all => 'Show all scanlator groups';

  @override
  String get chapter_scanlators_hint =>
      'Select groups to hide their chapters. Changes apply when you tap Filter.';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count scanlator groups hidden';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count chapters selected';
  }

  @override
  String get chapter_add_bookmark => 'Bookmark';

  @override
  String get chapter_remove_bookmark => 'Unbookmark';

  @override
  String get chapter_read_following => 'Read below';

  @override
  String get chapter_delete_records => 'Delete chapter records';

  @override
  String get chapter_delete_local_hint =>
      'Removes the selected chapter records and reading progress. Original local archives are kept; downloaded copies are cleaned up.';

  @override
  String get chapter_delete_last_hint =>
      'These are all chapters in this comic. Deleting them also removes the comic from your bookshelf.';

  @override
  String get chapter_action_incomplete =>
      'The action did not finish. Some changes may already be saved. Close and check the chapters and downloads before continuing.';

  @override
  String get reader_display_scope =>
      'Reading mode and manual page layout apply to this comic. Choose a change to return to reading.';

  @override
  String get reader_display_single_only =>
      'Horizontal continuous reading uses single pages.';

  @override
  String get reader_display_manual_pages =>
      'Changing page layout turns off automatic double page for all comics.';

  @override
  String get reader_display_crop_scope => 'Applies to all comics.';

  @override
  String get reader_chapter_locate => 'Locate current chapter';

  @override
  String get reader_chapter_search => 'Search chapters or scanlators';

  @override
  String get reader_chapter_scope =>
      'Uses the chapter filters and sort order from comic details. Bookmarks are saved immediately.';

  @override
  String get reader_chapter_current_hidden =>
      'The chapter you are reading is outside the current filters.';

  @override
  String get reader_chapter_current => 'Reading now';

  @override
  String get reader_chapter_read => 'Read';

  @override
  String get reader_chapter_bookmark_failed =>
      'Bookmark save could not be confirmed. Close the list and check its current state.';

  @override
  String get reader_image_actions => 'Image actions';

  @override
  String get reader_image_original =>
      'Uses the full original page, without translation, cropping or reader color filters.';

  @override
  String get reader_image_save_ios =>
      'Save to the Pictures folder in the current app storage location.';

  @override
  String get reader_image_save_android =>
      'Save to the device’s Pictures/nodelane-comics folder.';

  @override
  String get reader_image_share => 'Open the system share sheet.';

  @override
  String get reader_image_cover =>
      'Change this comic’s cover after confirmation.';

  @override
  String get reader_image_cover_limit =>
      'Cover images must be smaller than 5 MB. Saving and sharing remain available.';

  @override
  String get reader_image_action_failed =>
      'The action could not be confirmed. Close this menu and check the result before trying again.';

  @override
  String get reader_settings_book_scope =>
      'These settings apply only to this comic.';

  @override
  String get reader_settings_global_scope =>
      'These settings apply to all comics and save immediately.';

  @override
  String get reader_filters => 'Image filters';

  @override
  String get reader_filter_scope =>
      'Applies to all comics. Changes the reading display without modifying original images.';

  @override
  String get reader_auto_scroll_pause =>
      'Scrolling pauses while settings are open.';

  @override
  String get manga_synopsis => 'Synopsis';

  @override
  String manga_author(String author) {
    return 'Author: $author';
  }

  @override
  String get manga_continue_reading => 'Continue reading';

  @override
  String get reader_settings_title => 'Reader settings';

  @override
  String get reader_picker_book_scope => 'Only for this comic';

  @override
  String get reader_picker_global_scope => 'Applies to all comics';

  @override
  String get reader_picker_apply_hint =>
      'Tap to save and return to the previous level.';

  @override
  String get reader_scale_fit_screen_hint => 'Fit the whole page on screen';

  @override
  String get reader_scale_stretch_hint => 'Fill the reading area';

  @override
  String get reader_scale_fit_width_hint => 'Fit the page to the width';

  @override
  String get reader_scale_fit_height_hint => 'Fit the page to the height';

  @override
  String get source_filter_active => 'Applied';

  @override
  String get source_filter_apply => 'Apply filters';

  @override
  String get source_filter_scope => 'Filters apply to this website only.';

  @override
  String get source_filter_apply_hint =>
      'Apply filters to use your selections.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Genres',
      'author': 'Author',
      'artist': 'Artist',
      'title': 'Title',
      'year': 'Year',
      'tags': 'Tags',
      'format': 'Format',
      'publisher': 'Publisher',
      'relevance': 'Relevance',
      'rating': 'Rating',
      'views': 'Views',
      'random': 'Random',
      'all': 'All',
      'none': 'None',
      'action': 'Action',
      'adventure': 'Adventure',
      'comedy': 'Comedy',
      'drama': 'Drama',
      'fantasy': 'Fantasy',
      'romance': 'Romance',
      'science_fiction': 'Science fiction',
      'slice_of_life': 'Slice of life',
      'mystery': 'Mystery',
      'horror': 'Horror',
      'psychological': 'Psychological',
      'historical': 'Historical',
      'sports': 'Sports',
      'supernatural': 'Supernatural',
      'school_life': 'School life',
      'tragedy': 'Tragedy',
      'shounen': 'Shounen',
      'shoujo': 'Shoujo',
      'seinen': 'Seinen',
      'josei': 'Josei',
      'isekai': 'Isekai',
      'martial_arts': 'Martial arts',
      'mecha': 'Mecha',
      'music': 'Music',
      'doujinshi': 'Doujinshi',
      'trending': 'Trending',
      'new': 'New',
      'adult_content': 'Adult content',
      'only': 'Only',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'More display options';

  @override
  String get bookshelf_more_display_hint => 'Badges, sources and categories';

  @override
  String get bookshelf_download_count => 'Download count';

  @override
  String get bookshelf_source_global_hint =>
      'Source visibility uses the shared display preference.';

  @override
  String get bookshelf_select_entries => 'Select works';

  @override
  String get bookshelf_search_options => 'Search options';

  @override
  String get bookshelf_empty_hint =>
      'Collect works from sources or import local files.';

  @override
  String get bookshelf_no_match_hint =>
      'Try other keywords or adjust the current filters.';

  @override
  String get bookshelf_clear_query => 'Clear keywords';

  @override
  String get bookshelf_view_selection => 'View selected works';

  @override
  String get bookshelf_import_formats =>
      'Choose a local file to add it to your bookshelf.';

  @override
  String get bookshelf_import_canceled_hint =>
      'You can choose again after cancelling the file picker.';

  @override
  String get bookshelf_browse_sources => 'Browse sources';

  @override
  String get bookshelf_empty_title => 'Your bookshelf is empty';

  @override
  String get bookshelf_no_match_title => 'No matching works';

  @override
  String get bookshelf_mark_watched => 'Mark watched';

  @override
  String get bookshelf_mark_unwatched => 'Mark unwatched';

  @override
  String get nodelane_account => 'NodeLane account';

  @override
  String get nodelane_sign_in => 'Sign in to NodeLane';

  @override
  String get nodelane_account_intro =>
      'View your account, subscription and translation quota';

  @override
  String get nodelane_login_action => 'Continue to sign in';

  @override
  String get nodelane_login_browser =>
      'Sign in through the system browser, then return to the app';

  @override
  String get nodelane_account_id => 'Account ID';

  @override
  String get nodelane_account_init_error =>
      'Account storage is unavailable. Restart the app and try again.';

  @override
  String get nodelane_account_refresh_error =>
      'Could not refresh account information';

  @override
  String get nodelane_account_auth_error =>
      'Your session has expired. Sign in again';

  @override
  String get nodelane_account_unknown =>
      'Subscription information is unavailable';

  @override
  String get nodelane_account_current => 'Current subscription';

  @override
  String get nodelane_account_free => 'Free account';

  @override
  String get nodelane_account_no_subscription => 'No active subscription';

  @override
  String get nodelane_account_active => 'Active';

  @override
  String get nodelane_account_expired => 'Expired';

  @override
  String get nodelane_account_expiry => 'Valid until';

  @override
  String get nodelane_account_renewal => 'Renewal';

  @override
  String get nodelane_renewal_auto => 'Automatic renewal';

  @override
  String get nodelane_renewal_manual => 'Manual renewal';

  @override
  String get nodelane_renewal_stopped => 'Automatic renewal stopped';

  @override
  String get nodelane_renewal_gift => 'Gift membership';

  @override
  String get nodelane_renewal_attention =>
      'Check your renewal status on the website';

  @override
  String get nodelane_next_billing => 'Next billing date';

  @override
  String get nodelane_billing_unavailable =>
      'Renewal information is unavailable';

  @override
  String get nodelane_manage_account => 'Manage on website';

  @override
  String get nodelane_view_plans => 'View subscription plans';

  @override
  String get nodelane_translation_quota => 'Translation quota';

  @override
  String get nodelane_quota_free => 'Free quota';

  @override
  String get nodelane_quota_subscription => 'Subscription quota';

  @override
  String get nodelane_quota_purchase => 'Purchased quota';

  @override
  String get nodelane_quota_details => 'View quota details';

  @override
  String get nodelane_quota_expanded => 'Quota details';

  @override
  String get nodelane_quota_unlimited => 'Unlimited';

  @override
  String get nodelane_quota_not_subscribed => 'Not subscribed';

  @override
  String get nodelane_quota_unknown => 'Unavailable';

  @override
  String get nodelane_quota_used => 'Used';

  @override
  String get nodelane_quota_reserved => 'In progress';

  @override
  String get nodelane_quota_reset => 'Next reset';

  @override
  String get nodelane_quota_expiry => 'Next expiry';

  @override
  String get nodelane_quota_no_expiry => 'No expiry date';

  @override
  String get nodelane_quota_reservation_note =>
      'Pages in progress are already deducted from the available quota';

  @override
  String nodelane_quota_available(int count) {
    return '$count pages remaining';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count pages';
  }

  @override
  String get nodelane_sign_out => 'Sign out';

  @override
  String get nodelane_sign_out_confirm =>
      'Signing out pauses official translation on this device. Your library and reading progress are kept.';

  @override
  String get settings_search_hint => 'Search settings';

  @override
  String get settings_frequent => 'Frequently used';

  @override
  String get settings_reading_translation => 'Reading and translation';

  @override
  String get settings_app_preferences => 'App preferences';

  @override
  String get settings_data_management => 'Data and management';

  @override
  String get settings_more_tools => 'More tools';

  @override
  String get settings_more_tools_hint => 'Categories, statistics and calendar';

  @override
  String get settings_appearance_interface => 'Appearance and interface';

  @override
  String get settings_security_privacy => 'Security and privacy';

  @override
  String get settings_source_preferences => 'Source settings';

  @override
  String get settings_about_help => 'About and help';

  @override
  String get settings_storage_backup => 'Storage and backup';

  @override
  String settings_pending_downloads(int count) {
    return '$count pending';
  }

  @override
  String get settings_translation_language => 'Translation language';

  @override
  String get settings_translation_scope =>
      'Used in the reader and web page translation';

  @override
  String get settings_immediate_choice => 'Changes apply immediately';

  @override
  String get settings_translation_init_error =>
      'Translation settings are unavailable. Restart the app and try again.';

  @override
  String get settings_local_cache => 'Local cache';

  @override
  String get settings_chapter_cache => 'Chapter and episode cache';

  @override
  String get settings_cover_cache => 'Cover cache';

  @override
  String get settings_translation_cache => 'Translated image cache';

  @override
  String get settings_translation_cache_hint =>
      'Keep translation records and retrieve translated images again when needed';

  @override
  String get settings_cache_clear => 'Clear';

  @override
  String get settings_translation_cache_done =>
      'Translated image cache cleared; translation records kept';

  @override
  String settings_cache_confirmation(String name) {
    return 'Clear $name? Cached content can be retrieved again. Library entries will be kept.';
  }

  @override
  String get settings_advanced_options => 'Advanced options';

  @override
  String get settings_manga_reader => 'Manga Reader';

  @override
  String get settings_novel_reader => 'Novel Reader';

  @override
  String get settings_downloads => 'Download settings';

  @override
  String get onboarding_welcome => 'Welcome to';

  @override
  String get onboarding_reading_content => 'Reading content';

  @override
  String get onboarding_choose_one => 'Choose at least one';

  @override
  String get onboarding_restore_hint => 'Restore your library from a backup';

  @override
  String get onboarding_browse_hint => 'Find titles on supported websites';

  @override
  String get onboarding_import_folder => 'Import a local folder';

  @override
  String get onboarding_import_folder_hint =>
      'Read manga, novels and anime on your device';

  @override
  String get onboarding_third_party => 'Add a third-party repository';

  @override
  String get onboarding_third_party_hint =>
      'Use a repository address you already have';

  @override
  String get onboarding_repository_hint =>
      'Enter the address provided by the repository.';

  @override
  String get onboarding_repository_address => 'Address';

  @override
  String get onboarding_repository_address_hint => 'Enter repository address';

  @override
  String get onboarding_add_repository => 'Add repository';

  @override
  String get onboarding_start => 'Get started';

  @override
  String get onboarding_open_library => 'Open library';

  @override
  String get onboarding_view_imports => 'View imported content';

  @override
  String get onboarding_view_folders => 'View folders';

  @override
  String get notice_backup_created => 'Backup created';

  @override
  String get notice_backup_ready => 'Save or share the backup file.';

  @override
  String get notice_backup_restored => 'Backup restored';

  @override
  String get notice_backup_unsupported =>
      'This backup format is not supported.';

  @override
  String get notice_verification_required => 'Website verification required';

  @override
  String get notice_verification_hint =>
      'Complete verification to continue browsing.';

  @override
  String get notice_verify => 'Verify website';

  @override
  String get notice_action_incomplete =>
      'The action did not finish. Check its result before trying again.';

  @override
  String get notice_library_updating => 'Updating library';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'Checked $current / $total titles';
  }

  @override
  String get notice_library_failed => 'Some titles could not be updated';

  @override
  String get notice_import_completed => 'Import completed';

  @override
  String get notice_operation_incomplete => 'Action incomplete';

  @override
  String get subtitle_service => 'Online subtitle service';

  @override
  String get subtitle_service_mode => 'Subtitle source';

  @override
  String get subtitle_service_disabled => 'Off · clear saved credentials';

  @override
  String get subtitle_personal_key => 'My Wyzie key';

  @override
  String get subtitle_custom_service => 'My subtitle service';

  @override
  String get subtitle_key => 'Wyzie API Key';

  @override
  String get subtitle_key_hint =>
      'Enter your own Wyzie key. It stays on this device and is not included in app backups.';

  @override
  String get subtitle_get_key => 'Get a personal key';

  @override
  String get subtitle_service_address => 'Subtitle search URL';

  @override
  String get subtitle_service_token => 'Service access token (optional)';

  @override
  String get subtitle_custom_hint =>
      'Use the full HTTPS search URL of a Wyzie-compatible service, including its path (for example, /search). Enter an access token only if your service requires one.';

  @override
  String get subtitle_service_off_hint =>
      'Online subtitle search is off. Embedded, source-provided and local subtitles remain available.';

  @override
  String get subtitle_setup_required =>
      'Choose a subtitle service before searching.';

  @override
  String get subtitle_invalid_key => 'Enter a key without spaces.';

  @override
  String get subtitle_invalid_address =>
      'Use a complete HTTPS URL without a query, fragment or embedded credentials.';

  @override
  String get subtitle_invalid_token =>
      'The access token cannot contain spaces.';

  @override
  String get subtitle_storage_failed =>
      'Could not read or save subtitle settings. Please try again.';

  @override
  String get subtitle_auth_failed =>
      'The subtitle service refused access. Check your key or service token.';

  @override
  String get subtitle_quota_exhausted =>
      'The subtitle service quota is exhausted. Check your account with that service.';

  @override
  String get subtitle_network_failed =>
      'Could not reach the subtitle service. Please try again.';

  @override
  String get subtitle_response_invalid =>
      'The subtitle service returned an unsupported response or file.';

  @override
  String get detail_loading_chapters => 'Loading chapters…';

  @override
  String get reader_opening_chapter => 'Opening chapter';

  @override
  String get reader_open_chapter => 'Open chapter';

  @override
  String get reader_loading_pages => 'Getting chapter images…';

  @override
  String get reader_loading_pages_hint =>
      'Reading will start automatically when ready.';

  @override
  String get reader_loading_failed => 'Could not load this chapter';

  @override
  String get reader_loading_retry_hint =>
      'Check your connection and try again.';

  @override
  String get reader_no_pages => 'No images found for this chapter';

  @override
  String get reader_loading_previous => 'Loading previous chapter…';

  @override
  String get reader_previous_failed => 'Could not load the previous chapter';

  @override
  String get reader_reached_start => 'You have reached the first chapter';

  @override
  String get reader_loading_next => 'Loading next chapter…';

  @override
  String get reader_next_failed => 'Could not load the next chapter';

  @override
  String get reader_image_loading => 'Loading image…';

  @override
  String get reader_image_failure_hint => 'You can keep reading other pages.';

  @override
  String get comic_paged => 'Page by page';

  @override
  String get comic_scroll => 'Scroll down';

  @override
  String get comic_book_scope =>
      'Applies only to this book · changes save immediately';

  @override
  String get comic_defaults_title => 'Defaults & habits';

  @override
  String get comic_defaults_hint =>
      'Defaults apply to fields you have not customized for a book.';

  @override
  String get comic_habits_hint => 'These habits apply to every comic.';

  @override
  String get comic_turn => 'Swipe to the next page';

  @override
  String get comic_left => 'Left';

  @override
  String get comic_right => 'Right';

  @override
  String get comic_up => 'Up';

  @override
  String get comic_fit => 'Page fit';

  @override
  String get comic_fit_contain => 'Whole page';

  @override
  String get comic_fit_width => 'Fit width';

  @override
  String get comic_fit_height => 'Fit height';

  @override
  String get comic_layout => 'Page layout';

  @override
  String get comic_auto => 'Auto';

  @override
  String get comic_layout_hint =>
      'Auto shows a spread when there is enough width.';

  @override
  String get comic_width => 'Content width';

  @override
  String get comic_full => 'Full';

  @override
  String get comic_comfortable => 'Comfortable';

  @override
  String get comic_narrow => 'Narrow';

  @override
  String get comic_gap => 'Page spacing';

  @override
  String get comic_no_gap => 'Seamless';

  @override
  String get comic_small_gap => 'Small';

  @override
  String get comic_image_title => 'Fine-tune image';

  @override
  String get comic_image_hint => 'Crop and tone affect only this book.';

  @override
  String get comic_wide => 'Wide pages';

  @override
  String get comic_intact => 'Keep whole';

  @override
  String get comic_split => 'Split';

  @override
  String get comic_rotate => 'Rotate';

  @override
  String get comic_wide_hint =>
      'Splitting follows the page-turn direction. Applies to single-page reading.';

  @override
  String get comic_cover => 'One cover per chapter';

  @override
  String get comic_effects_reset => 'Reset image adjustments';

  @override
  String get comic_book_reset => 'Restore book defaults';

  @override
  String get comic_book_reset_hint =>
      'Clears this book’s custom reading settings. Translation is unchanged.';

  @override
  String get comic_canvas => 'Reader background';

  @override
  String get comic_system => 'System';

  @override
  String get comic_black => 'Black';

  @override
  String get comic_gray => 'Gray';

  @override
  String get comic_paper => 'Paper';

  @override
  String get comic_tap => 'Tap to turn pages';

  @override
  String get comic_tap_hint =>
      'Tap the edges to move; tap the center to show controls.';

  @override
  String get comic_scroll_start => 'Start auto scroll';

  @override
  String get comic_scroll_pause => 'Pause auto scroll';

  @override
  String get comic_scroll_speed => 'Scroll speed';

  @override
  String get comic_scroll_hint =>
      'Starts when this panel closes. Pauses when the app leaves the foreground.';

  @override
  String get comic_save_failed => 'Could not save. Please try again.';

  @override
  String get comic_reading => 'Reading';

  @override
  String get comic_chapter_habits_hint =>
      'Chapter list habits apply to all books.';
}
