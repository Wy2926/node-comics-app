// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get browser_search_hint => 'Arayın veya URL girin';

  @override
  String get browser_start_hint => 'Yeni keşifler için yeni bir sayfa.';

  @override
  String get browser_search_engine => 'Arama motoru';

  @override
  String get browser_bookmarks => 'Yer imleri';

  @override
  String get browser_search_library => 'Başlık veya URL ara';

  @override
  String get browser_data_failed =>
      'Tarayıcı verileri okunamadı veya kaydedilemedi. Lütfen tekrar deneyin.';

  @override
  String get browser_clear_history => 'Tarama geçmişini temizle';

  @override
  String get browser_clear_history_hint =>
      'Bu cihazdaki tüm geçmiş silinsin mi? Yer imleri ve site oturumları korunur.';

  @override
  String get browser_library_empty => 'Henüz bir şey yok';

  @override
  String get browser_bookmarks_hint =>
      'Bir sayfayı burada bulmak için menüsünden yer imlerine ekleyin.';

  @override
  String get browser_history_hint =>
      'Ziyaret ettiğiniz sayfalar, sekmeler kapatılsa da burada kalır.';

  @override
  String get browser_recent => 'Son ziyaretler';

  @override
  String get browser_pinned_hint =>
      'Hızlı erişim için favori sitelerinizi Kaynaklar bölümünde sabitleyin.';

  @override
  String get browser_start_page => 'Başlangıç sayfası';

  @override
  String get browser_remove_bookmark => 'Yer imini kaldır';

  @override
  String get browser_add_bookmark => 'Yer imi ekle';

  @override
  String get browser_find => 'Sayfada bul';

  @override
  String get browser_copy_link => 'Bağlantıyı kopyala';

  @override
  String get browser_action_failed =>
      'İşlem tamamlanamadı. Lütfen tekrar deneyin.';

  @override
  String get browser_find_previous => 'Önceki eşleşme';

  @override
  String get browser_find_next => 'Sonraki eşleşme';

  @override
  String browser_find_matches(int current, int total) {
    return '$total eşleşmeden $current.';
  }

  @override
  String get app_update_details_hint =>
      'Sürüm notlarını ve yükleme seçeneklerini görüntüleyin';

  @override
  String get app_update_download => 'Güncellemeyi indir';

  @override
  String get app_update_download_hint =>
      'İndirdikten sonra güncellemeyi yüklemek için talimatları izleyin.';

  @override
  String get bookshelf_all => 'Hepsi';

  @override
  String get bookshelf_search => 'Kütüphanede arama yapın';

  @override
  String get app_update_allow_install =>
      'Sistem ayarlarında uygulama kurulumuna izin verin, ardından geri dönün ve Yükle\'ye dokunun.';

  @override
  String get app_update_waiting => 'Sistemin indirmeyi sürdürmesi bekleniyor…';

  @override
  String get app_update_cancel_download => 'İndirmeyi iptal et';

  @override
  String get app_update_remove_package => 'İndirilen paketi kaldır';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'Eşleşen ayar yok';

  @override
  String get search_empty_hint =>
      'Başka bir anahtar kelime deneyin veya her şeyi görmek için aramayı temizleyin.';

  @override
  String get search_clear => 'Aramayı temizle';

  @override
  String get app_updates => 'Uygulama güncellemeleri';

  @override
  String get app_update_auto => 'Başlatma sırasında kontrol edin';

  @override
  String get app_update_view => 'Güncellemeyi görüntüle';

  @override
  String get app_update_later => 'Daha sonra';

  @override
  String get app_update_external_hint =>
      'Tarayıcınızda güncelleme bağlantısını açar';

  @override
  String get app_update_failed =>
      'Güncellemeler kontrol edilemiyor. Lütfen tekrar deneyin.';

  @override
  String get app_update_opened => 'Güncelleme bağlantısı açıldı';

  @override
  String get app_diagnostics => 'Teşhis ve günlükler';

  @override
  String get library => 'Kütüphane';

  @override
  String get updates_search => 'Arama güncellemeleri';

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
  String get floating_navigation_bar => 'Kayan gezinme çubuğu';

  @override
  String get floating_navigation_bar_description =>
      'Standart olarak takılı gezinme çubuğu yerine yüzen bir kapsül kullanın.';

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
  String get add_repo_sources_to_add => 'Eklenecek uzantı listeleri:';

  @override
  String get add_repo_warning =>
      'Bu depolardaki uzantılar uygulamanın içinde çalışır. Yalnızca güvendiğiniz depoları ekleyin.';

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
      'Bu düğme, dosyalarınıza erişebilen ve programları çalıştırabilen video oynatıcıda aşağıdaki Lua kodunu çalıştırır. Yalnızca bu bağlantının nereden geldiğine güveniyorsanız ekleyin.';

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
  String get watch_order_role_current => 'Geçerli';

  @override
  String get watch_order_role_previous => 'Önceki';

  @override
  String get watch_order_role_next => 'Sonraki';

  @override
  String get watch_order_source_release_order => 'Serbest bırakma emri';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name by $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Resmi Trakt koleksiyonu: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt koleksiyonu: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return '$title için Mevsimler';
  }

  @override
  String get watch_order_select_source => 'Sipariş kaynağı';

  @override
  String watch_order_season(int number) {
    return 'Sezon $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Bölüm $number';
  }

  @override
  String get sequels => 'Devam filmleri';

  @override
  String get recommendations_similarity => 'Benzerlik:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Derecelendirme $rating';
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
      'Cihaz kimlik doğrulaması kontrol ediliyor…';

  @override
  String get device_authentication_incomplete =>
      'Kimlik doğrulama tamamlanmadı. Ayarınız değişmedi.';

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
    return '$title başına Ortalama Bölüm Sayısı';
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
    return 'Bu, $mangaCount mangayı, $chapterCount bölümlerini, $historyCount geçmiş girişlerini ve $updateCount güncelleme girişlerini kalıcı olarak siler. İzleme bağlantıları tutulur. Bu, geri alma dışında geri alınamaz.';
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
    return '$totalChapters bölümleri diğer girişlerde bulundu. $duplicateChapters kopyalardır ve bırakılacaktır (hangi kopyanın okuma ilerlemesi varsa tutulacaktır); $keptChapters eklenecek. $duplicateTracks yinelenen izleme bağlantıları da kaldırılacak.';
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
  String get update_errors => 'Güncelleme hataları';

  @override
  String get no_update_errors => 'Güncelleme hatası yok';

  @override
  String get clear_all => 'Hepsini temizle';

  @override
  String get dismiss => 'Reddet';

  @override
  String get previous_episode => 'Önceki bölüm';

  @override
  String get clear_logs => 'Günlükleri temizle';

  @override
  String get bold => 'Kalın';

  @override
  String get italic => 'İtalik';

  @override
  String get color_yellow => 'Sarı';

  @override
  String get color_cyan => 'Camgöbeği';

  @override
  String get color_green => 'Yeşil';

  @override
  String get color_orange => 'Turuncu';

  @override
  String get continue_watching => 'İzlemeye Devam Et';

  @override
  String get search_your_anime => 'Animenizi arayın';

  @override
  String get category => 'Kategori';

  @override
  String get hidden_categories => 'Gizli kategoriler';

  @override
  String get new_category => 'Yeni kategori';

  @override
  String get local => 'Yerel';

  @override
  String get tv_home_rows => 'Satırlar';

  @override
  String get genre_rows => 'Tür satırları';

  @override
  String get share_backup_file => 'NodeLane Comics yedekleme dosyasını paylaş';

  @override
  String get close => 'Kapat';

  @override
  String get migrate_source => 'Kaynağı taşı';

  @override
  String get cloudflare_bypass_proxy => 'Cloudflare bypass proxy\'si';

  @override
  String get custom_doh_url => 'Özel DoH URL';

  @override
  String get custom_doh_url_helper => 'https DoH (JSON) uç noktası olmalıdır';

  @override
  String get anime_only_tv_layout => 'Yalnızca anime TV düzeni';

  @override
  String get anime_only_beta => 'Yalnızca anime (beta)';

  @override
  String get tv_home_beta => 'TV evi (beta)';

  @override
  String get tv_player_beta => 'TV oynatıcısı (beta)';

  @override
  String get network_settings => 'Ağ';

  @override
  String get reader_page_layout => 'Sayfa düzeni';

  @override
  String get reader_continuous_options => 'Sürekli okuma';

  @override
  String get reader_default_mode_hint =>
      'Varsayılan okuma modu, okuma sırasında ayrı bir mod ayarı yapılmayan başlıklar için geçerlidir.';

  @override
  String get extension_service => 'Uzatma hizmeti';

  @override
  String get extension_service_description =>
      'Uzantı çalışma zamanını ve proxy adresini yönetin.';

  @override
  String get proxy_address => 'Proxy adresi';

  @override
  String get checking_runtime_status => 'Durum kontrol ediliyor…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + rastgele gecikme';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bölümler',
      one: '1 bölüm',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Bir başlığın bölüm listesinden indirilenleri ekleyin.';

  @override
  String get download_queue_order_hint =>
      'Yeniden sıralamak için tutamaçları sürükleyin';

  @override
  String get download_queue_empty => 'Sıraya alınmış indirme yok';

  @override
  String get download_queue_actions => 'İndirme işlemleri';

  @override
  String get download_queue_cancel_chapter =>
      'Bu bölümün indirilmesini iptal et';

  @override
  String get download_queue_cancel_series =>
      'Bu başlık için tüm indirmeleri iptal et';

  @override
  String get download_queue_start => 'İndirmeleri başlat';

  @override
  String get download_queue_retry => 'İndirmeleri yeniden deneyin';

  @override
  String get download_queue_active => 'İndiriliyor';

  @override
  String get download_queue_waiting => 'İndirme bekleniyor';

  @override
  String get download_queue_failed => 'İndirme başarısız oldu';

  @override
  String get cf_proxy_helper =>
      'FlareSolverr / Byparr uç noktası. Devre dışı bırakmak için boş bırakın.';

  @override
  String get mobile_navigation_description =>
      'Yeniden sıralamak için sürükleyin. Manga, anime ve romanlar Kütüphane sekmesini paylaşır. İlk görünür öğe açılışta açılır. Göz Atın ve Daha Fazlası görünür kalır; Diğer\'in altında ekstra sekmeler görünür.';

  @override
  String get text_align_justify => 'Gerekçelendir';

  @override
  String get novel_session_modes_hint =>
      'Bir başlığı okurken okuma modunu ve tek veya çift sayfaları ayarlayın.';

  @override
  String get tts_languages_failed => 'Konuşma motorundan diller yüklenemedi.';

  @override
  String get tts_languages_empty =>
      'Konuşma motoru hiçbir dil döndürmedi. Kaydedilen seçiminiz korunur.';

  @override
  String get tts_language_unavailable =>
      'Kaydedilen bu dil cihazın mevcut listesinde yok.';

  @override
  String get tts_apply_failed =>
      'Bu ayar konuşma motoruna uygulanamadı. Tekrar deneyebilirsiniz.';

  @override
  String get player_controls => 'Kontroller';

  @override
  String get audio_channel_auto => 'Otomatik';

  @override
  String get audio_channel_auto_safe => 'Otomatik (güvenli)';

  @override
  String get audio_channel_mono => 'Mono';

  @override
  String get audio_channel_stereo => 'Stereo';

  @override
  String get audio_channel_reverse_stereo => 'Ters stereo';

  @override
  String get mpv_bundled_config_hint =>
      'Uygulamaya dahil edilen yapılandırmayı, komut dosyalarını ve gölgelendiricileri geri yükleyin. Aynı adlara sahip dosyaların üzerine yazılacaktır.';

  @override
  String get mpv_restore_bundled => 'Paketlenmiş konfigürasyonu geri yükleyin';

  @override
  String get mpv_restore_confirm =>
      'Birlikte verilen MPV yapılandırması geri yüklensin mi? Aynı adlara sahip mevcut konfigürasyonun, komut dosyalarının ve gölgelendiricilerin üzerine yazılacaktır. Diğer dosyalar saklanacaktır.';

  @override
  String get player_operation_incomplete =>
      'İşlem tamamlanamadı. Dosya erişimini kontrol edip tekrar deneyin.';

  @override
  String get custom_buttons_empty_hint =>
      'Etiketi ve basma eylemi olan bir oynatıcı düğmesi ekleyin.';

  @override
  String get custom_button_primary => 'Varsayılan düğme';

  @override
  String get show_password => 'Şifreyi göster';

  @override
  String get hide_password => 'Şifreyi gizle';

  @override
  String get tracking_accounts_empty =>
      'Girişlerini yönetmek için İzleme ayarlarında bir hizmete bağlanın.';

  @override
  String get tracking_entries_empty =>
      'Bu ortam türü için izlenen giriş yok. Bir başlığın ayrıntı sayfasından izleme ekleyin.';

  @override
  String get change_tracking_match => 'Eşleşen başlığı değiştir';

  @override
  String get remove_tracking => 'İzlemeyi kaldır';

  @override
  String remove_tracking_confirm(String title) {
    return '“$title” için izleme bağlantısı kaldırılsın mı? Takip hizmetindeki giriş saklanacaktır.';
  }

  @override
  String get tracking_refresh_required =>
      'İzleme durumu doğrulanamadı. Başka bir değişiklik yapmadan önce yenileyin.';

  @override
  String get tracking_entry_unlinked =>
      'Bu kayıt yerel bir başlığa bağlı değildir, dolayısıyla burada düzenlenemez.';

  @override
  String get backup_selection_shared =>
      'Bu seçimlerde yapılan değişiklikler anında kaydedilir ve otomatik yedeklemelere de uygulanır.';

  @override
  String get library_snapshot_history =>
      'Kitaplık anlık görüntüsünü geri yükleme';

  @override
  String get library_snapshot_empty =>
      'Hiçbir güvenlik anlık görüntüsü mevcut değildir.';

  @override
  String get library_snapshot_restore_message =>
      'Mevcut veriler bu anlık görüntüyle değiştirilecektir. O zamandan bu yana yapılan değişiklikler kaybolacak. Silinen indirmeler geri yüklenemez. Başarının ardından mevcut güvenlik anlık görüntüleri silinecektir.';

  @override
  String get library_maintenance_working => 'Kitaplık güncelleniyor…';

  @override
  String get library_safety_snapshot_note =>
      'Bu işlemden önce bir güvenlik anlık görüntüsü kaydedilecektir. İndirilen dosyaları içermez.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Kitaplık girişleri: $mangaCount. Bölümler: $chapterCount. Geçmiş girişleri: $historyCount. Güncellemeler: $updateCount.\n\nAşağıda nelerin saklanacağını seçin.';
  }

  @override
  String get library_delete_pick_message =>
      'İçeriğini ve silme seçeneklerini gözden geçirmek için bir kaynak seçin.';

  @override
  String get mobile_categories_hint =>
      'Yeniden sıralamak için sürükleyin. Yeniden adlandırmak veya görünürlüğünü ve güncellemelerini değiştirmek için bir kategoriyi açın.';

  @override
  String get mobile_category_visible => 'Kütüphanede göster';

  @override
  String get mobile_category_hidden => 'Kütüphaneden gizlenmiş';

  @override
  String get mobile_category_updates => 'Kitaplık güncellemelerine dahil etme';

  @override
  String get statistics_watched => 'İzlendi';

  @override
  String get calendar_month => 'Ay';

  @override
  String get calendar_two_weeks => '2 hafta';

  @override
  String get calendar_week => 'Hafta';

  @override
  String get calendar_show_all_dates => 'Tüm tarihleri ​​göster';

  @override
  String get update_check_no_result =>
      'Yüklenebilir güncelleme bulunamadı. Daha sonra tekrar deneyebilirsiniz.';

  @override
  String get release_notes => 'Sürüm notları';

  @override
  String get no_release_notes => 'Hiçbir sürüm notu sağlanmamıştır.';

  @override
  String get downloading_update => 'Güncelleme indiriliyor…';

  @override
  String get preparing_installation => 'Kurulum hazırlanıyor…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Ne okuyacağınızı seçin. Bunu daha sonra değiştirebilirsiniz.';

  @override
  String get onboarding_content_title => 'Okumaya başla';

  @override
  String get onboarding_mobile_sources_body =>
      'Başlamak için bir yol seçin veya içeriği daha sonra ekleyin.';

  @override
  String onboarding_step_count(int step, int total) {
    return '$total Adımı $step';
  }

  @override
  String global_search_results_for(String query) {
    return '“$query” için sonuçlar';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaynaklar',
      one: '1 kaynak',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Hedef başlığı arayın.';

  @override
  String get migration_original_item => 'Geçerli öğe';

  @override
  String get migration_target_item => 'Seçilen öğe';

  @override
  String get migration_partial_failure =>
      'İşlem tamamlanmadı. Bazı değişiklikler kaydedilmiş olabilir. Tekrar denemeden önce bu öğeyi kitaplığınızda kontrol edin.';

  @override
  String get migration_no_categories =>
      'Kategori yok. Bu öğeyi kategori olmadan ekleyebilirsiniz.';

  @override
  String get mass_migration_select_source => 'Geçerli kaynağı seçin';

  @override
  String get mass_migration_select_all => 'Tümünü seç';

  @override
  String get mass_migration_deselect_all => 'Tümünün seçimini kaldır';

  @override
  String get mass_migration_needs_review =>
      'Tamamlanmamış geçişleri gözden geçirin';

  @override
  String get bookshelf_actions => 'Kitaplık eylemleri';

  @override
  String get bookshelf_ignore_filters =>
      'Arama sırasında filtreleri göz ardı et';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Filtrelerle gizlenenler dahil, bu kategorideki tüm çalışmaları arayın.';

  @override
  String get bookshelf_stop_update => 'Kitaplık güncellemesini durdur';

  @override
  String bookshelf_selected_count(int count) {
    return '$count seçili işler';
  }

  @override
  String get bookshelf_remove_library => 'Kitaplıktan kaldır';

  @override
  String get bookshelf_remove_library_hint =>
      'Favorileri kaldırır. Yerel ithalatlar da kütüphanelerini ve okuma kayıtlarını kaybediyor.';

  @override
  String get bookshelf_remove_downloads => 'İndirilen dosyaları sil';

  @override
  String get bookshelf_remove_downloads_hint =>
      'İş bilgilerini korurken indirilen dosyaları kaldırır.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Ayrıca seçilen yerel içe aktarılan dosyaları da siler ve bunların kitaplık kayıtlarını kaldırır. Bu dosyalar burada kurtarılamaz.';

  @override
  String get bookshelf_remove_incomplete =>
      'İşlem tamamlanmadı. Bazı çalışmalar veya dosyalar işlenmiş olabilir. Devam etmeden önce bu iletişim kutusunu kapatın ve kitaplığınızı ve indirilenleri kontrol edin.';

  @override
  String get bookshelf_processing => 'İşleniyor…';

  @override
  String get bookshelf_mark_read => 'Okumayı işaretle';

  @override
  String get bookshelf_mark_unread => 'Okunmadı olarak işaretle';

  @override
  String get bookshelf_select_all => 'Tümünü seç';

  @override
  String get bookshelf_invert_selection => 'Seçimi tersine çevir';

  @override
  String get bookshelf_settings => 'Kitaplık ayarları';

  @override
  String get bookshelf_settings_live =>
      'Filtreleme, sıralama ve görüntüleme değişiklikleri hemen etkili olur.';

  @override
  String get bookshelf_filter_any => 'Herhangi biri';

  @override
  String get bookshelf_filter_include => 'Dahil Et';

  @override
  String get bookshelf_filter_exclude => 'Hariç Tut';

  @override
  String get bookshelf_all_sources => 'Tüm kaynaklar';

  @override
  String bookshelf_sources_selected(int count) {
    return '$count kaynak seçildi';
  }

  @override
  String get bookshelf_sort_ascending => 'Artan';

  @override
  String get bookshelf_sort_descending => 'Azalan';

  @override
  String get bookshelf_layout => 'Kitaplık düzeni';

  @override
  String get bookshelf_sources_hint =>
      'Tüm kaynakları göstermek için hiçbirini seçin. Filtrele\'ye dokunduğunuzda değişiklikler geçerli olur.';

  @override
  String get bookshelf_choose_files => 'Dosyaları seç';

  @override
  String get bookshelf_import_wait =>
      'Seçiciden bir dosya seçin ve içe aktarmanın bitmesini bekleyin.';

  @override
  String get bookshelf_import_incomplete =>
      'İçe aktarma tamamlanmadı. Bazı dosyalar zaten kitaplığınızda olabilir. Bu iletişim kutusunu kapatın ve tekrar içe aktarmadan önce kontrol edin.';

  @override
  String get bookshelf_categories_replace =>
      'Kaydetme, bu kategorileri seçilen her çalışmaya atar ve önceki kategorilerin yerine geçer.';

  @override
  String get bookshelf_categories_hint =>
      'Bir veya daha fazla kategori seçin veya hiçbirini atamamak için seçimi boş bırakın.';

  @override
  String get bookshelf_categories_hidden =>
      'Bu çalışma için mevcut gizli kategoriler korunur.';

  @override
  String get bookshelf_categories_incomplete =>
      'Kategoriler tamamen kaydedilemedi. Bu iletişim kutusunu kapatın ve tekrar denemeden önce kitap rafını kontrol edin.';

  @override
  String get bookshelf_categories_none_visible =>
      'Burada hiçbir kategori mevcut değildir. Bunları incelemek için kategori yönetimini açın.';

  @override
  String get bookshelf_manage_categories => 'Kategorileri yönet';

  @override
  String get manga_actions => 'Komik eylemler';

  @override
  String get manga_download_scope => 'Bölümleri indir';

  @override
  String get manga_download_scope_hint =>
      'Mevcut filtreler içindeki bölümleri seçin. İndirilen bölümler atlanır.';

  @override
  String get manga_download_scope_empty =>
      'Mevcut filtrelerle eşleşen bölüm yok. Bu menüyü kapatın ve bölüm filtrelerini ayarlayın.';

  @override
  String get manga_action_incomplete =>
      'Eylem tamamlanmadı. Tekrar denemeden önce mevcut durumu kontrol edin.';

  @override
  String get chapter_settings => 'Bölüm ayarları';

  @override
  String get chapter_settings_live =>
      'Filtreleme ve sıralama değişiklikleri anında uygulanır.';

  @override
  String get chapter_scanlators_all => 'Tüm tarayıcı gruplarını göster';

  @override
  String get chapter_scanlators_hint =>
      'Bölümlerini gizlemek için grupları seçin. Filtrele\'ye dokunduğunuzda değişiklikler geçerli olur.';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count tarayıcı grupları gizlendi';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count bölümler seçildi';
  }

  @override
  String get chapter_add_bookmark => 'Yer İşareti';

  @override
  String get chapter_remove_bookmark => 'Yer işaretini kaldır';

  @override
  String get chapter_read_following => 'Aşağıyı okuyun';

  @override
  String get chapter_delete_records => 'Bölüm kayıtlarını sil';

  @override
  String get chapter_delete_local_hint =>
      'Seçilen bölüm kayıtlarını ve okuma ilerlemesini kaldırır. Orijinal yerel arşivler tutulur; indirilen kopyalar temizlenir.';

  @override
  String get chapter_delete_last_hint =>
      'Bunların hepsi bu çizgi romandaki bölümler. Bunları silmek aynı zamanda çizgi romanı kitaplığınızdan da kaldırır.';

  @override
  String get chapter_action_incomplete =>
      'Eylem tamamlanmadı. Bazı değişiklikler zaten kaydedilmiş olabilir. Devam etmeden önce bölümleri ve indirilenleri kapatıp kontrol edin.';

  @override
  String get reader_display_scope =>
      'Okuma modu ve manuel sayfa düzeni bu çizgi roman için geçerlidir. Okumaya geri dönmek için bir değişiklik seçin.';

  @override
  String get reader_display_single_only =>
      'Yatay sürekli okuma tek sayfaları kullanır.';

  @override
  String get reader_display_manual_pages =>
      'Sayfa düzeninin değiştirilmesi tüm çizgi romanlar için otomatik çift sayfayı kapatır.';

  @override
  String get reader_display_crop_scope => 'Tüm çizgi romanlara uygulanır.';

  @override
  String get reader_chapter_locate => 'Geçerli bölümü bulun';

  @override
  String get reader_chapter_search => 'Bölümleri veya tarayıcıları arayın';

  @override
  String get reader_chapter_scope =>
      'Bölüm filtrelerini ve çizgi roman ayrıntılarından sıralama düzenini kullanır. Yer imleri hemen kaydedilir.';

  @override
  String get reader_chapter_current_hidden =>
      'Okuduğunuz bölüm mevcut filtrelerin dışındadır.';

  @override
  String get reader_chapter_current => 'Şimdi okuyorum';

  @override
  String get reader_chapter_read => 'Okuma';

  @override
  String get reader_chapter_bookmark_failed =>
      'Yer iminin kaydedilmesi onaylanamadı. Listeyi kapatın ve mevcut durumunu kontrol edin.';

  @override
  String get reader_image_actions => 'Resim eylemleri';

  @override
  String get reader_image_original =>
      'Çeviri, kırpma veya okuyucu renk filtreleri olmadan tam orijinal sayfayı kullanır.';

  @override
  String get reader_image_save_ios =>
      'Geçerli uygulama depolama konumundaki Resimler klasörüne kaydedin.';

  @override
  String get reader_image_save_android =>
      'Cihazın Resimler/düğüm-çizgi roman klasörüne kaydedin.';

  @override
  String get reader_image_share => 'Sistem paylaşım sayfasını açın.';

  @override
  String get reader_image_cover =>
      'Onaylandıktan sonra bu çizgi romanın kapağını değiştirin.';

  @override
  String get reader_image_cover_limit =>
      'Kapak görselleri 5 MB\'tan küçük olmalıdır. Kaydetme ve paylaşma kullanılabilir durumda kalır.';

  @override
  String get reader_image_action_failed =>
      'Eylem onaylanamadı. Bu menüyü kapatın ve tekrar denemeden önce sonucu kontrol edin.';

  @override
  String get reader_settings_book_scope =>
      'Bu ayarlar yalnızca bu çizgi roman için geçerlidir.';

  @override
  String get reader_settings_global_scope =>
      'Bu ayarlar tüm çizgi romanlara uygulanır ve hemen kaydedilir.';

  @override
  String get reader_filters => 'Görüntü filtreleri';

  @override
  String get reader_filter_scope =>
      'Tüm çizgi romanlara uygulanır. Orijinal görüntüleri değiştirmeden okuma ekranını değiştirir.';

  @override
  String get reader_auto_scroll_pause =>
      'Ayarlar açıkken kaydırma duraklatılır.';

  @override
  String get manga_synopsis => 'Özet';

  @override
  String manga_author(String author) {
    return 'Yazar: $author';
  }

  @override
  String get manga_continue_reading => 'Okumaya devam et';

  @override
  String get reader_settings_title => 'Okuyucu ayarları';

  @override
  String get reader_picker_book_scope => 'Yalnızca bu çizgi roman için';

  @override
  String get reader_picker_global_scope => 'Tüm çizgi romanlar için geçerlidir';

  @override
  String get reader_picker_apply_hint =>
      'Kaydetmek ve önceki seviyeye dönmek için dokunun.';

  @override
  String get reader_scale_fit_screen_hint => 'Tüm sayfayı ekrana sığdır';

  @override
  String get reader_scale_stretch_hint => 'Okuma alanını doldurun';

  @override
  String get reader_scale_fit_width_hint => 'Sayfayı genişliğe sığdır';

  @override
  String get reader_scale_fit_height_hint => 'Sayfayı yüksekliğe sığdır';

  @override
  String get source_filter_active => 'Uygulandı';

  @override
  String get source_filter_apply => 'Filtreleri uygula';

  @override
  String get source_filter_scope =>
      'Filtreler yalnızca bu web sitesi için geçerlidir.';

  @override
  String get source_filter_apply_hint =>
      'Seçimlerinizi kullanmak için filtreler uygulayın.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Türler',
      'author': 'Yazar',
      'artist': 'Sanatçı',
      'title': 'Başlık',
      'year': 'Yıl',
      'tags': 'Etiketler',
      'format': 'Biçim',
      'publisher': 'Yayımcı',
      'relevance': 'Uygunluk',
      'rating': 'Derecelendirme',
      'views': 'Görünümler',
      'random': 'Rastgele',
      'all': 'Hepsi',
      'none': 'Hiçbiri',
      'action': 'Eylem',
      'adventure': 'Macera',
      'comedy': 'Komedi',
      'drama': 'Dram',
      'fantasy': 'Fantezi',
      'romance': 'Romantik',
      'science_fiction': 'Bilim kurgu',
      'slice_of_life': 'Hayattan kesit',
      'mystery': 'Gizem',
      'horror': 'Korku',
      'psychological': 'Psikolojik',
      'historical': 'Tarihsel',
      'sports': 'Spor',
      'supernatural': 'Doğaüstü',
      'school_life': 'Okul hayatı',
      'tragedy': 'Trajedi',
      'shounen': 'Shounen',
      'shoujo': 'Shoujo',
      'seinen': 'Seinen',
      'josei': 'Josei',
      'isekai': 'Isekai',
      'martial_arts': 'Dövüş sanatları',
      'mecha': 'Meka',
      'music': 'Müzik',
      'doujinshi': 'Doujinşi',
      'trending': 'Trend Olan',
      'new': 'Yeni',
      'adult_content': 'Yetişkinlere yönelik içerik',
      'only': 'Yalnızca',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'Daha fazla görüntüleme seçeneği';

  @override
  String get bookshelf_more_display_hint =>
      'Rozetler, kaynaklar ve kategoriler';

  @override
  String get bookshelf_download_count => 'İndirme sayısı';

  @override
  String get bookshelf_source_global_hint =>
      'Kaynak görünürlüğü, paylaşılan görüntüleme tercihini kullanır.';

  @override
  String get bookshelf_select_entries => 'İşleri seç';

  @override
  String get bookshelf_search_options => 'Arama seçenekleri';

  @override
  String get bookshelf_empty_hint =>
      'Kaynaklardan eserleri toplayın veya yerel dosyaları içe aktarın.';

  @override
  String get bookshelf_no_match_hint =>
      'Diğer anahtar kelimeleri deneyin veya mevcut filtreleri ayarlayın.';

  @override
  String get bookshelf_clear_query => 'Anahtar kelimeleri temizle';

  @override
  String get bookshelf_view_selection => 'Seçilen çalışmaları görüntüle';

  @override
  String get bookshelf_import_formats =>
      'Kitap rafınıza eklemek için yerel bir dosya seçin.';

  @override
  String get bookshelf_import_canceled_hint =>
      'Dosya seçiciyi iptal ettikten sonra tekrar seçim yapabilirsiniz.';

  @override
  String get bookshelf_browse_sources => 'Kaynaklara göz atın';

  @override
  String get bookshelf_empty_title => 'Kitaplığınız boş';

  @override
  String get bookshelf_no_match_title => 'Eşleşen çalışma yok';

  @override
  String get bookshelf_mark_watched => 'Mark izledi';

  @override
  String get bookshelf_mark_unwatched => 'İzlenmedi olarak işaretle';

  @override
  String get nodelane_account => 'NodeLane hesabı';

  @override
  String get nodelane_sign_in => 'NodeLane\'da oturum açın';

  @override
  String get nodelane_account_intro =>
      'Hesabınızı, aboneliğinizi ve çeviri kotanızı görüntüleyin';

  @override
  String get nodelane_login_action => 'Oturum açmaya devam edin';

  @override
  String get nodelane_login_browser =>
      'Sistem tarayıcısı aracılığıyla oturum açın ve ardından uygulamaya geri dönün';

  @override
  String get nodelane_account_id => 'Hesap Kimliği';

  @override
  String get nodelane_account_init_error =>
      'Hesap depolama alanı mevcut değil. Uygulamayı yeniden başlatın ve tekrar deneyin.';

  @override
  String get nodelane_account_refresh_error => 'Hesap bilgileri yenilenemedi';

  @override
  String get nodelane_account_auth_error =>
      'Oturumunuzun süresi doldu. Tekrar oturum açın';

  @override
  String get nodelane_account_unknown => 'Abonelik bilgisi mevcut değil';

  @override
  String get nodelane_account_current => 'Mevcut abonelik';

  @override
  String get nodelane_account_free => 'Ücretsiz hesap';

  @override
  String get nodelane_account_no_subscription => 'Aktif abonelik yok';

  @override
  String get nodelane_account_active => 'Aktif';

  @override
  String get nodelane_account_expired => 'Süresi dolmuş';

  @override
  String get nodelane_account_expiry => 'Geçerlilik tarihi:';

  @override
  String get nodelane_account_renewal => 'Yenileme';

  @override
  String get nodelane_renewal_auto => 'Otomatik yenileme';

  @override
  String get nodelane_renewal_manual => 'Manuel yenileme';

  @override
  String get nodelane_renewal_stopped => 'Otomatik yenileme durduruldu';

  @override
  String get nodelane_renewal_gift => 'Hediye üyelik';

  @override
  String get nodelane_renewal_attention =>
      'Web sitesinde yenileme durumunuzu kontrol edin';

  @override
  String get nodelane_next_billing => 'Sonraki fatura tarihi';

  @override
  String get nodelane_billing_unavailable => 'Yenileme bilgisi mevcut değil';

  @override
  String get nodelane_manage_account => 'Web sitesinde yönet';

  @override
  String get nodelane_view_plans => 'Abonelik planlarını görüntüleyin';

  @override
  String get nodelane_translation_quota => 'Çeviri kotası';

  @override
  String get nodelane_quota_free => 'Ücretsiz kota';

  @override
  String get nodelane_quota_subscription => 'Abonelik kotası';

  @override
  String get nodelane_quota_purchase => 'Satın alınan kota';

  @override
  String get nodelane_quota_details => 'Kota ayrıntılarını görüntüle';

  @override
  String get nodelane_quota_expanded => 'Kota ayrıntıları';

  @override
  String get nodelane_quota_unlimited => 'Sınırsız';

  @override
  String get nodelane_quota_not_subscribed => 'Abone olunmadı';

  @override
  String get nodelane_quota_unknown => 'Kullanılamaz';

  @override
  String get nodelane_quota_used => 'Kullanılmış';

  @override
  String get nodelane_quota_reserved => 'Devam ediyor';

  @override
  String get nodelane_quota_reset => 'Sonraki sıfırlama';

  @override
  String get nodelane_quota_expiry => 'Sonraki sona erme tarihi';

  @override
  String get nodelane_quota_no_expiry => 'Son kullanma tarihi yok';

  @override
  String get nodelane_quota_reservation_note =>
      'Devam eden sayfalar halihazırda mevcut kotadan düşülmüştür';

  @override
  String nodelane_quota_available(int count) {
    return '$count sayfa kaldı';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count sayfalar';
  }

  @override
  String get nodelane_sign_out => 'Oturumu kapat';

  @override
  String get nodelane_sign_out_confirm =>
      'Oturumun kapatılması bu cihazdaki resmi çeviriyi duraklatır. Kitaplığınız ve okuma ilerlemeniz tutulur.';

  @override
  String get settings_search_hint => 'Arama ayarları';

  @override
  String get settings_frequent => 'Sıklıkla kullanılan';

  @override
  String get settings_reading_translation => 'Okuma ve çeviri';

  @override
  String get settings_app_preferences => 'Uygulama tercihleri';

  @override
  String get settings_data_management => 'Veri ve yönetim';

  @override
  String get settings_more_tools => 'Daha fazla araç';

  @override
  String get settings_more_tools_hint => 'Kategoriler, istatistikler ve takvim';

  @override
  String get settings_appearance_interface => 'Görünüm ve arayüz';

  @override
  String get settings_security_privacy => 'Güvenlik ve gizlilik';

  @override
  String get settings_source_preferences => 'Kaynak ayarları';

  @override
  String get settings_about_help => 'Hakkında ve yardım';

  @override
  String get settings_storage_backup => 'Depolama ve yedekleme';

  @override
  String settings_pending_downloads(int count) {
    return '$count beklemede';
  }

  @override
  String get settings_translation_language => 'Çeviri dili';

  @override
  String get settings_translation_scope =>
      'Okuyucu ve web sayfası çevirisinde kullanılır';

  @override
  String get settings_immediate_choice => 'Değişiklikler hemen uygulanır';

  @override
  String get settings_translation_init_error =>
      'Çeviri ayarları mevcut değil. Uygulamayı yeniden başlatın ve tekrar deneyin.';

  @override
  String get settings_local_cache => 'Yerel önbellek';

  @override
  String get settings_chapter_cache => 'Bölüm ve bölüm önbelleği';

  @override
  String get settings_cover_cache => 'Kapak önbelleği';

  @override
  String get settings_translation_cache => 'Çevrilmiş görüntü önbelleği';

  @override
  String get settings_translation_cache_hint =>
      'Çeviri kayıtlarını saklayın ve gerektiğinde çevrilmiş görüntüleri tekrar alın';

  @override
  String get settings_cache_clear => 'Temizle';

  @override
  String get settings_translation_cache_done =>
      'Çevrilen görselin önbelleği temizlendi; tutulan çeviri kayıtları';

  @override
  String settings_cache_confirmation(String name) {
    return '$name silinsin mi? Önbelleğe alınan içerik tekrar alınabilir. Kütüphane girişleri saklanacaktır.';
  }

  @override
  String get settings_advanced_options => 'Gelişmiş seçenekler';

  @override
  String get settings_manga_reader => 'Manga Okuyucu';

  @override
  String get settings_novel_reader => 'Roman Okuyucusu';

  @override
  String get settings_downloads => 'İndirme ayarları';

  @override
  String get onboarding_welcome => 'Hoş Geldiniz';

  @override
  String get onboarding_reading_content => 'İçeriğin okunması';

  @override
  String get onboarding_choose_one => 'En az birini seçin';

  @override
  String get onboarding_restore_hint =>
      'Kitaplığınızı bir yedekten geri yükleyin';

  @override
  String get onboarding_browse_hint =>
      'Desteklenen web sitelerinde başlıkları bulun';

  @override
  String get onboarding_import_folder => 'Yerel bir klasörü içe aktar';

  @override
  String get onboarding_import_folder_hint =>
      'Cihazınızda manga, roman ve anime okuyun';

  @override
  String get onboarding_third_party => 'Üçüncü taraf bir depo ekleyin';

  @override
  String get onboarding_third_party_hint =>
      'Zaten sahip olduğunuz bir depo adresini kullanın';

  @override
  String get onboarding_repository_hint =>
      'Depo tarafından sağlanan adresi girin.';

  @override
  String get onboarding_repository_address => 'Adres';

  @override
  String get onboarding_repository_address_hint => 'Depo adresini girin';

  @override
  String get onboarding_add_repository => 'Depo ekle';

  @override
  String get onboarding_start => 'Başlayın';

  @override
  String get onboarding_open_library => 'Kütüphaneyi aç';

  @override
  String get onboarding_view_imports => 'İçe aktarılan içeriği görüntüle';

  @override
  String get onboarding_view_folders => 'Klasörleri görüntüle';

  @override
  String get notice_backup_created => 'Yedekleme oluşturuldu';

  @override
  String get notice_backup_ready =>
      'Yedekleme dosyasını kaydedin veya paylaşın.';

  @override
  String get notice_backup_restored => 'Yedekleme geri yüklendi';

  @override
  String get notice_backup_unsupported =>
      'Bu yedekleme formatı desteklenmemektedir.';

  @override
  String get notice_verification_required => 'Web sitesi doğrulaması gerekli';

  @override
  String get notice_verification_hint =>
      'Göz atmaya devam etmek için doğrulamayı tamamlayın.';

  @override
  String get notice_verify => 'Web sitesini doğrulayın';

  @override
  String get notice_action_incomplete =>
      'Eylem tamamlanmadı. Tekrar denemeden önce sonucunu kontrol edin.';

  @override
  String get notice_library_updating => 'Kitaplığın güncellenmesi';

  @override
  String notice_library_progress(Object current, Object total) {
    return '$current / $total başlıkları kontrol edildi';
  }

  @override
  String get notice_library_failed => 'Bazı başlıklar güncellenemedi';

  @override
  String get notice_import_completed => 'İçe aktarma tamamlandı';

  @override
  String get notice_operation_incomplete => 'Eylem tamamlanmadı';

  @override
  String get subtitle_service => 'Çevrimiçi altyazı hizmeti';

  @override
  String get subtitle_service_mode => 'Altyazı kaynağı';

  @override
  String get subtitle_service_disabled =>
      'Kapalı · kayıtlı kimlik bilgilerini temizle';

  @override
  String get subtitle_personal_key => 'Wyzie anahtarım';

  @override
  String get subtitle_custom_service => 'Altyazı hizmetim';

  @override
  String get subtitle_key => 'Wyzie API Anahtar';

  @override
  String get subtitle_key_hint =>
      'Kendi Wyzie anahtarınızı girin. Bu cihazda kalır ve uygulama yedeklemelerine dahil edilmez.';

  @override
  String get subtitle_get_key => 'Kişisel bir anahtar alın';

  @override
  String get subtitle_service_address => 'Altyazı arama URL';

  @override
  String get subtitle_service_token => 'Hizmet erişim belirteci (isteğe bağlı)';

  @override
  String get subtitle_custom_hint =>
      'Bir Wyzie-compatible hizmetinin, yolu da dahil olmak üzere (örneğin, /search) HTTPS aramasının URL tamamını kullanın. Yalnızca hizmetiniz gerektiriyorsa bir erişim belirteci girin.';

  @override
  String get subtitle_service_off_hint =>
      'Çevrimiçi altyazı araması kapalı. Gömülü, kaynak tarafından sağlanan ve yerel altyazılar kullanılabilir durumda kalır.';

  @override
  String get subtitle_setup_required =>
      'Aramadan önce bir altyazı hizmeti seçin.';

  @override
  String get subtitle_invalid_key => 'Boşluksuz bir anahtar girin.';

  @override
  String get subtitle_invalid_address =>
      'Sorgu, parça veya yerleşik kimlik bilgileri olmadan tam bir HTTPS URL kullanın.';

  @override
  String get subtitle_invalid_token => 'Erişim belirteci boşluk içeremez.';

  @override
  String get subtitle_storage_failed =>
      'Altyazı ayarları okunamadı veya kaydedilemedi. Lütfen tekrar deneyin.';

  @override
  String get subtitle_auth_failed =>
      'Altyazı hizmeti erişimi reddetti. Anahtarınızı veya hizmet jetonunuzu kontrol edin.';

  @override
  String get subtitle_quota_exhausted =>
      'Altyazı hizmet kotası doldu. Bu hizmetteki hesabınızı kontrol edin.';

  @override
  String get subtitle_network_failed =>
      'Altyazı hizmetine ulaşılamadı. Lütfen tekrar deneyin.';

  @override
  String get subtitle_response_invalid =>
      'Altyazı hizmeti desteklenmeyen bir yanıt veya dosya döndürdü.';

  @override
  String get detail_loading_chapters => 'Bölümler yükleniyor…';

  @override
  String get reader_opening_chapter => 'Açılış bölümü';

  @override
  String get reader_open_chapter => 'Bölümü aç';

  @override
  String get reader_loading_pages => 'Bölüm görüntüleri alınıyor…';

  @override
  String get reader_loading_pages_hint =>
      'Okuma hazır olduğunda otomatik olarak başlayacaktır.';

  @override
  String get reader_loading_failed => 'Bu bölüm yüklenemedi';

  @override
  String get reader_loading_retry_hint =>
      'Bağlantınızı kontrol edin ve tekrar deneyin.';

  @override
  String get reader_no_pages => 'Bu bölüm için resim bulunamadı';

  @override
  String get reader_loading_previous => 'Önceki bölüm yükleniyor…';

  @override
  String get reader_previous_failed => 'Önceki bölüm yüklenemedi';

  @override
  String get reader_reached_start => 'İlk bölüme ulaştınız';

  @override
  String get reader_loading_next => 'Sonraki bölüm yükleniyor…';

  @override
  String get reader_next_failed => 'Sonraki bölüm yüklenemedi';

  @override
  String get reader_image_loading => 'Resim yükleniyor…';

  @override
  String get reader_image_failure_hint =>
      'Diğer sayfaları okumaya devam edebilirsiniz.';

  @override
  String get comic_paged => 'Sayfa sayfa';

  @override
  String get comic_scroll => 'Aşağı kaydır';

  @override
  String get comic_book_scope =>
      'Yalnızca bu kitap için geçerlidir · değişiklikler hemen kaydedilir';

  @override
  String get comic_defaults_title => 'Varsayılanlar ve alışkanlıklar';

  @override
  String get comic_defaults_hint =>
      'Varsayılanlar, bir kitap için özelleştirmediğiniz alanlara uygulanır.';

  @override
  String get comic_habits_hint =>
      'Bu alışkanlıklar her çizgi roman için geçerlidir.';

  @override
  String get comic_turn => 'Sonraki sayfaya kaydırın';

  @override
  String get comic_left => 'Sol';

  @override
  String get comic_right => 'Sağ';

  @override
  String get comic_up => 'Yukarı';

  @override
  String get comic_fit => 'Sayfaya sığdırma';

  @override
  String get comic_fit_contain => 'Tüm sayfa';

  @override
  String get comic_fit_width => 'Uygun genişlik';

  @override
  String get comic_fit_height => 'Montaj yüksekliği';

  @override
  String get comic_layout => 'Sayfa düzeni';

  @override
  String get comic_auto => 'Otomatik';

  @override
  String get comic_layout_hint =>
      'Otomatik, yeterli genişlik olduğunda bir yayılma gösterir.';

  @override
  String get comic_width => 'İçerik genişliği';

  @override
  String get comic_full => 'Tam';

  @override
  String get comic_comfortable => 'Rahat';

  @override
  String get comic_narrow => 'Dar';

  @override
  String get comic_gap => 'Sayfa aralığı';

  @override
  String get comic_no_gap => 'Kesintisiz';

  @override
  String get comic_small_gap => 'Küçük';

  @override
  String get comic_image_title => 'Görüntüye ince ayar yapın';

  @override
  String get comic_image_hint => 'Kırpma ve ton yalnızca bu kitabı etkiler.';

  @override
  String get comic_wide => 'Geniş sayfalar';

  @override
  String get comic_intact => 'Bütün olarak saklayın';

  @override
  String get comic_split => 'Bölünmüş';

  @override
  String get comic_rotate => 'Döndür';

  @override
  String get comic_wide_hint =>
      'Bölme, sayfa çevirme yönünü takip eder. Tek sayfalık okuma için geçerlidir.';

  @override
  String get comic_cover => 'Bölüm başına bir kapak';

  @override
  String get comic_effects_reset => 'Görüntü ayarlarını sıfırla';

  @override
  String get comic_book_reset => 'Kitap varsayılanlarını geri yükleme';

  @override
  String get comic_book_reset_hint =>
      'Bu kitabın özel okuma ayarlarını temizler. Çeviri değişmedi.';

  @override
  String get comic_canvas => 'Okuyucu arka planı';

  @override
  String get comic_system => 'Sistem';

  @override
  String get comic_black => 'Siyah';

  @override
  String get comic_gray => 'Gri';

  @override
  String get comic_paper => 'Kağıt';

  @override
  String get comic_tap => 'Sayfaları çevirmek için dokunun';

  @override
  String get comic_tap_hint =>
      'Taşımak için kenarlara hafifçe vurun; Kontrolleri göstermek için ortaya dokunun.';

  @override
  String get comic_scroll_start => 'Otomatik kaydırmayı başlat';

  @override
  String get comic_scroll_pause => 'Otomatik kaydırmayı duraklat';

  @override
  String get comic_scroll_speed => 'Kaydırma hızı';

  @override
  String get comic_scroll_hint =>
      'Bu panel kapandığında başlar. Uygulama ön plandan çıktığında duraklar.';

  @override
  String get comic_save_failed => 'Kaydedilemedi. Lütfen tekrar deneyin.';

  @override
  String get comic_reading => 'Okuma';

  @override
  String get comic_chapter_habits_hint =>
      'Bölüm listesi alışkanlıkları tüm kitaplar için geçerlidir.';

  @override
  String get browser_title => 'Tarayıcı';

  @override
  String get translation_image_display => 'Görüntü ekranı';

  @override
  String get translation_display_hint =>
      'Önce mevcut çevirileri göster. Çeviri olmadığında orijinali saklayın.';

  @override
  String get translation_sign_in_required =>
      'Çeviriyi etkinleştirmek için oturum açın';

  @override
  String get translation_sign_in_hint =>
      'Oturum açtıktan sonra otomatik olarak çevrilecek çevrilmiş görüntülere geçin.';

  @override
  String get translation_automatic => 'Otomatik çeviri';

  @override
  String get translation_original_hint =>
      'Orijinaller gösteriliyor. Otomatik olarak çevirmek için çevrilmiş resimlere geçin.';

  @override
  String get translation_window_hint =>
      'Mevcut ve gelecek görüntüleri yalnızca çevirileri gösterirken işleyin.';

  @override
  String get translation_channel => 'Çeviri kanalı';

  @override
  String get translation_no_images =>
      'Bu sayfada henüz çevrilebilir resim bulunamadı';

  @override
  String get translation_waiting_image => 'Mevcut görüntü bekleniyor';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · $issues resimlere dikkat edilmesi gerekiyor',
      one: ' · 1 görselin ilgilenilmesi gerekiyor',
      zero: '',
    );
    return 'Tamamlanan $complete / $total resimler$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'Tekrar çevirmek de dahil olmak üzere daha fazla işlem için bir resme dokunun ve basılı tutun.';

  @override
  String get translation_title => 'Manga çevirisi';

  @override
  String get translation_system_sign_in =>
      'Sistem tarayıcınızı kullanarak oturum açın';

  @override
  String get translation_target_language => 'Hedef dil';

  @override
  String get translation_clear_cache => 'Çevrilen resim önbelleğini temizle';

  @override
  String get translation_cache_hint =>
      'Çeviri kayıtlarını saklayın ve gerektiğinde sonuçları tekrar alın.';

  @override
  String get translation_saved_read_failed => 'Kaydedilen çeviri yüklenemedi';

  @override
  String get translation_read_failed => 'Çevrilmiş görüntü yüklenemedi';

  @override
  String get operation_retry => 'Eylem tamamlanmadı. Lütfen tekrar deneyin.';

  @override
  String get translation_original => 'Orijinal';

  @override
  String get translation_translated => 'Çevrilmiş';

  @override
  String get translation_regenerate_image => 'Bu görüntüyü tekrar çevir';

  @override
  String get translation_read_image => 'Çevrilmiş görüntüyü yeniden yükle';

  @override
  String get translation_image_actions => 'Daha fazla görüntü eylemi';

  @override
  String get translation_processing => 'İşleme';

  @override
  String get translation_reading => 'Çevrilmiş görüntü yükleniyor';

  @override
  String get translation_waiting => 'Çeviri bekleniyor';

  @override
  String get translation_preparing => 'Çevirinin hazırlanması';

  @override
  String get translation_uploading => 'Orijinal yükleniyor';

  @override
  String get translation_running => 'Çeviri';

  @override
  String get translation_uncertain => 'Durumun doğrulanması gerekiyor';

  @override
  String get translation_failed => 'Çeviri başarısız oldu';

  @override
  String get translation_verify => 'Doğrula';

  @override
  String get translation_reread => 'Yeniden yükle';

  @override
  String get browser_back => 'Geri';

  @override
  String get browser_translation => 'Web sayfası çevirisi';

  @override
  String get browser_new_tab_action => 'Yeni sekme aç';

  @override
  String get browser_current_tab => 'Akım';

  @override
  String get browser_close_tab => 'Sekmeyi kapat';

  @override
  String get browser_new_tab => 'Yeni sekme';

  @override
  String get browser_page => 'Web sayfası';

  @override
  String get browser_unopened => 'Henüz sayfa açılmadı';

  @override
  String get browser_invalid_address => 'Geçerli bir URL girin';

  @override
  String get browser_clear_address => 'Temizle URL';

  @override
  String get browser_paste_address => 'Yapıştır URL';

  @override
  String get browser_open_address => 'Açık URL';

  @override
  String browser_tab_count(int count) {
    return 'Sekmeler · $count';
  }

  @override
  String get browser_load_failed => 'Bu sayfa açılamadı';

  @override
  String get browser_load_failed_hint =>
      'Bağlantınızı ve URL öğesini kontrol edin.';

  @override
  String get browser_edit_address => 'Düzenle URL';

  @override
  String get browser_clear_cookies_confirm =>
      'Tüm web siteleri için oturum açma oturumları temizlensin mi?';

  @override
  String get browser_clear_cookies_hint =>
      'Tüm sekmelerdeki web siteleri yeniden oturum açmanızı gerektirebilir.';

  @override
  String get browser_clear_cookies_action => 'Oturum açma oturumlarını temizle';

  @override
  String get browser_tab_limit =>
      'En fazla 12 sekmeyi açık tutabilirsiniz. Önce birini kapat.';

  @override
  String get browser_forward => 'İleri';

  @override
  String get browser_clear_all_cookies =>
      'Tüm web sitesinde oturum açma oturumlarını temizle';

  @override
  String get browser_clear_failed =>
      'Oturumlar temizlenemedi. Lütfen tekrar deneyin.';

  @override
  String get browser_save_failed =>
      'Sekmeler kaydedilemedi. Lütfen tekrar deneyin.';

  @override
  String get browser_tabs_full => '12 sekme zaten açık';

  @override
  String get browser_no_tabs => 'Henüz açık sekme yok';

  @override
  String get browser_close_failed =>
      'Sekmeler kaydedilemedi. Yeniden denemek için kapat\'a tekrar dokunun.';

  @override
  String get source_pinned_websites => 'Sabitlenmiş web siteleri';

  @override
  String get manage => 'Yönet';

  @override
  String get translation_settings_hint => 'Otomatik çeviri, hedef dil ve kanal';

  @override
  String get translation_show_original => 'Orijinali göstermek için dokunun';

  @override
  String get translation_show_translated => 'Çeviriyi göstermek için dokunun';

  @override
  String get source_display => 'Ekran';

  @override
  String get source_cover_title => 'Kapak ve başlık';

  @override
  String get source_cover_only => 'Yalnızca kapak';

  @override
  String get source_save_search => 'Mevcut aramayı kaydet';

  @override
  String get source_saved_searches => 'Kayıtlı aramalar';

  @override
  String get source_website_info => 'Web sitesi bilgisi';

  @override
  String source_saved_search_title(String title) {
    return '$title · Aramak için dokunun';
  }

  @override
  String get action_done => 'Bitti';

  @override
  String source_search_keyword(String query) {
    return 'Anahtar kelime: $query';
  }

  @override
  String get source_no_saved_searches => 'Henüz kayıtlı arama yok';

  @override
  String get source_save_search_hint =>
      'Bir anahtar kelimeyi arayın ve ardından bunu web sitesi eylemlerinden kaydedin.';

  @override
  String get source_saved_search_scope =>
      'Anahtar kelimeler yalnızca bu web sitesi için kaydedildi.';

  @override
  String get source_search_here => 'Bu web sitesindeki başlıkları arayın';

  @override
  String get source_filter_results => 'Filtrelenmiş sonuçlar';

  @override
  String get source_search_results => 'Arama sonuçları';

  @override
  String get source_return_popular => 'Popülere geri dön';

  @override
  String get source_popular_titles => 'Popüler başlıklar';

  @override
  String get source_no_titles => 'Eşleşen başlık bulunamadı';

  @override
  String get source_no_titles_hint =>
      'Anahtar kelimelerinizi veya filtrelerinizi değiştirin veya popüler başlıklara dönün.';

  @override
  String get source_load_more_failed =>
      'Daha fazlası yüklenemedi. Lütfen tekrar deneyin.';

  @override
  String get source_load_pull_retry =>
      'Bu web sitesi yüklenemedi. Yeniden denemek için aşağı çekin.';

  @override
  String get source_clear_failed =>
      'Temizleme tamamlanamadı. Lütfen tekrar deneyin.';

  @override
  String get source_uninstall_failed =>
      'Kaldırma işlemi tamamlanamadı. Lütfen tekrar deneyin.';

  @override
  String get source_details => 'Kaynak ayrıntıları';

  @override
  String get source_repository_website => 'Depo web sitesi';

  @override
  String get source_provided_settings => 'Kaynak tarafından sağlanan ayarlar';

  @override
  String get source_advanced_actions => 'Gelişmiş eylemler';

  @override
  String get source_edit_metadata => 'Kaynak bilgisini düzenle';

  @override
  String get source_clear_cookies => 'Bu web sitesine ait çerezleri temizle';

  @override
  String get source_clear_cookies_hint =>
      'Bir sonraki ziyaretinizde yeniden oturum açmanız gerekebilir.';

  @override
  String get source_uninstall => 'Kaynağı kaldır';

  @override
  String get source_settings_save_failed =>
      'Kaydetme işlemi tamamlanmadı. Kontrol etmek için kaynak ayarlarını yeniden açın.';

  @override
  String get repository_third_party => 'Üçüncü taraf veri havuzları';

  @override
  String get repository_refresh_failed =>
      'Katalog yenilenemedi. Önbelleğe alınan içerik tutulur. Lütfen tekrar deneyin.';

  @override
  String get repository_show_sources => 'Bu depodaki kaynakları göster';

  @override
  String get repository_copy_catalog => 'Katalog bağlantısını kopyala';

  @override
  String get repository_remove => 'Depoyu kaldır';

  @override
  String get repository_remove_hint =>
      'Kurulu kaynakları koruyun ve kaldırılan katalog girişlerini kaldırın.';

  @override
  String get repository_empty =>
      'Henüz hiçbir üçüncü taraf veri havuzu eklenmedi';

  @override
  String get repository_built_in => 'Yerleşik resmi katalog';

  @override
  String get repository_hidden => 'Gizli';

  @override
  String get repository_refreshing => 'Yenileniyor…';

  @override
  String get repository_refresh => 'Kataloğu yenile';

  @override
  String get repository_manage_hint =>
      'Üçüncü taraf kaynaklarının nereden indirildiğini yönetin.';

  @override
  String get repository_invalid_address =>
      'Geçerli bir HTTP veya HTTPS URL girin';

  @override
  String get repository_already_added => 'Bu depo zaten eklenmiş';

  @override
  String get repository_unrecognized =>
      'Desteklenen katalog bulunamadı. Bağlantıyı kontrol edip tekrar deneyin.';

  @override
  String get repository_read_failed =>
      'Katalog okunamadı. Lütfen tekrar deneyin.';

  @override
  String get repository_save_failed =>
      'Kaydetme işlemi tamamlanmadı. Depo listenizi kontrol edin.';

  @override
  String get repository_paste_hint =>
      'Üçüncü taraf veri havuzu katalog bağlantısını yapıştırın';

  @override
  String get repository_address => 'Deposu URL';

  @override
  String get repository_paste_link => 'Bağlantıyı yapıştır';

  @override
  String repository_recognized(String type) {
    return '$type · Katalog tanındı';
  }

  @override
  String get repository_choose_sources_hint =>
      'Depoyu ekledikten sonra ihtiyacınız olan kaynakları seçin.';

  @override
  String get search_scope => 'Arama kapsamı';

  @override
  String get search_scope_hint => 'Aranacak web sitelerini seçin';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count web sitelerinde arama yapın',
      one: '1 web sitesinde arama yapın',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Bir web sitesi bulun';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count web siteleri seçildi',
      one: '1 web sitesi seçildi',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Temizle';

  @override
  String get search_deselect_results =>
      'Eşleşen web sitelerinin seçimini kaldırın';

  @override
  String get search_select_results => 'Eşleşen web sitelerini seçin';

  @override
  String get search_no_websites_hint =>
      'Eşleşen web sitesi yok. Başka bir ad veya dil deneyin.';

  @override
  String get search_select_website_hint =>
      'Aramak için en az bir web sitesi seçin.';

  @override
  String get search_start_title =>
      'Başlıkları bulmak için anahtar kelimeleri girin';

  @override
  String get search_start_hint =>
      'Aynı anda birden fazla web sitesinde arama yapın ve eşleşen başlıkları gösterin.';

  @override
  String get search_empty_scope => 'Bu kapsamda aranabilir web sitesi yok';

  @override
  String get search_empty_scope_hint =>
      'Tüm web sitelerine geçin veya aranacak web sitelerini seçin.';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sonuçlar',
      one: '1 sonuç',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'Başlıkları ara';

  @override
  String get search_actions => 'Arama eylemleri';

  @override
  String get search_details => 'Arama ayrıntıları';

  @override
  String get search_title_hint => 'Başlığa göre ara';

  @override
  String get search_searching => 'Arama';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sonuç bulundu',
      one: '1 sonuç bulundu',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'Eşleşen sonuç yok';

  @override
  String get search_failed => 'Arama başarısız oldu';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count başlık bulundu',
      one: '1 başlık bulundu',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: '$websites web siteleri',
      one: '1 web sitesi',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Başlıkları bulma';

  @override
  String get search_complete => 'Arama tamamlandı';

  @override
  String get search_in_progress => 'Arama';

  @override
  String get search_finding_related => 'Eşleşen başlıklar aranıyor…';

  @override
  String get search_no_results_yet => 'Henüz arama sonucu yok';

  @override
  String get search_no_matching_titles => 'Eşleşen başlık bulunamadı';

  @override
  String get search_results_appear_hint =>
      'Sonuçlar bulundukça burada görünecektir.';

  @override
  String get search_failed_websites_hint =>
      'Bazı web siteleri aramayı tamamlayamadı. Bunları arama ayrıntılarında yeniden deneyin.';

  @override
  String get search_change_keywords_hint =>
      'Daha kısa anahtar kelimeler deneyin veya daha fazla web sitesinde arama yapın.';

  @override
  String get search_view_details => 'Arama ayrıntılarını görüntüle';

  @override
  String get search_adjust_scope => 'Arama kapsamını ayarlayın';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count web siteleri',
      one: '1 web sitesi',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Tamamlandı $completed / $total';
  }

  @override
  String get search_retry_website_hint =>
      'Başarısız olan web sitelerini tek tek yeniden deneyin';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe seçildi',
      one: '1 öğe seçildi',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Arama dilleri';

  @override
  String get source_deselect => 'Seçimi kaldır';

  @override
  String get source_select => 'Kaynağı seç';

  @override
  String get source_multilingual => 'Çok dilli';

  @override
  String get source_language_unknown => 'Dil belirtilmemiş';

  @override
  String get source_adult_content => '18+ içerik içerir';

  @override
  String get source_classification_unknown => 'Sınıflandırma belirtilmemiş';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Tüm kaynak bilgilerini, $count daha fazla kategoriyi görüntüleyin',
      one: 'Tüm kaynak bilgilerini görüntüle, 1 kategori daha',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Web sitesi yükleniyor';

  @override
  String get source_unpin => 'Sabitlemeyi kaldır';

  @override
  String get source_pin => 'Pim';

  @override
  String get source_open => 'Aç';

  @override
  String get source_metadata_hint =>
      'Bilgi kaynak katalogdan gelir. Kategoriler web sitesinin kapsadığı içeriği tanımlar.';

  @override
  String get source_region => 'Bölge';

  @override
  String get source_format => 'Biçim';

  @override
  String get source_creation => 'Yaratılış';

  @override
  String get source_unspecified => 'Belirtilmedi';

  @override
  String get source_pricing => 'Fiyatlandırma';

  @override
  String get source_region_jp => 'Japon çizgi romanları';

  @override
  String get source_region_kr => 'Kore çizgi romanları';

  @override
  String get source_region_cn => 'Çin çizgi romanları';

  @override
  String get source_region_hk_tw => 'Hong Kong ve Tayvan çizgi romanları';

  @override
  String get source_region_western => 'Batılı çizgi romanlar';

  @override
  String get source_region_other => 'Diğer bölgeler';

  @override
  String get source_format_page => 'Sayfalandırılmış çizgi romanlar';

  @override
  String get source_format_vertical => 'Dikey çizgi romanlar';

  @override
  String get source_format_strip => 'Çizgi romanlar';

  @override
  String get source_creation_original => 'Orijinal';

  @override
  String get source_creation_fan => 'Fan çalışıyor';

  @override
  String get source_free_watch => 'İzlemesi ücretsiz';

  @override
  String get source_free_read => 'Okuması ücretsiz';

  @override
  String get source_partial_paid => 'Kısmen ödenmiş';

  @override
  String get source_paid_watch => 'Ücretli görüntüleme';

  @override
  String get source_paid_read => 'Ücretli okuma';

  @override
  String get source_pricing_unknown => 'Fiyatlandırma belirtilmemiş';

  @override
  String get source_language_filter => 'Dile göre filtrele';

  @override
  String get source_language_filter_hint =>
      'Yalnızca bu kataloğu filtreleyin. Yüklü kaynaklar etkilenmez.';

  @override
  String get source_all_languages => 'Tüm diller';

  @override
  String get action_apply => 'Uygula';

  @override
  String get source_load_retry =>
      'Bu web sitesi yüklenemedi. Lütfen tekrar deneyin.';

  @override
  String get source_catalog_refresh_failed =>
      'Katalog yenilenemedi. Mevcut içerik korunur. Yeniden denemek için aşağı çekin.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaynakları kaldırılsın mı?',
      one: '1 kaynak kaldırılsın mı?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Seçilen kaynakları kaldırın ve ayarlarını temizleyin. Kitaplık başlıklarını ve indirilenleri saklayın.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaynakları için eylemler başarısız oldu.',
      one: '1 kaynak için eylem başarısız oldu.',
    );
    return '$_temp0 Seçim tutuldu. Lütfen tekrar deneyin.';
  }

  @override
  String get source_latest_content => 'En son içerik';

  @override
  String get source_actions => 'Kaynak eylemleri';

  @override
  String get source_bulk_manage => 'Birden fazla kaynağı yönetin';

  @override
  String get source_update_installed => 'Yüklü kaynakları güncelleyin';

  @override
  String get source_no_matching_websites => 'Eşleşen web sitesi yok';

  @override
  String get source_no_websites => 'Web sitesi mevcut değil';

  @override
  String get source_search_installed_hint =>
      'Yüklü kaynaklarda başlıkları arayın';

  @override
  String get source_global_search => 'Kaynaklar arasında arama yapın';

  @override
  String get source_manage_repositories => 'Depoları yönet';

  @override
  String get source_view_third_party => 'Üçüncü taraf kaynakları görüntüleyin';

  @override
  String get source_catalog_load_failed =>
      'Katalog yüklenemedi. Yeniden denemek için aşağı çekin.';

  @override
  String get source_all_websites => 'Tüm web siteleri';

  @override
  String get source_available => 'Kuruluma hazır';

  @override
  String get source_third_party => 'Üçüncü taraf';

  @override
  String get source_name_or_title => 'Web sitesi adı veya başlığı';

  @override
  String get view_all => 'Tümünü görüntüle';

  @override
  String get search_searching_ellipsis => 'Aranıyor…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · Test edilmemiş';
  }

  @override
  String get onboarding_untested => 'Test Edilmemiş';

  @override
  String get source_custom_scope => 'Özel';

  @override
  String get source_custom_websites => 'Seçilen web siteleri';

  @override
  String get tv_hidden_library_hint =>
      'Her başlık gizli bir kategoride bulunur.\nBirini göstermek için “Tümü” üzerinde Tamam\'ı basılı tutun.';

  @override
  String get tv_no_matching_anime => 'Eşleşen anime yok';

  @override
  String tv_no_matching_category(String category) {
    return '“$category”da eşleşen anime yok';
  }

  @override
  String get tv_filtered_empty_hint =>
      'Mevcut filtrelerle eşleşen anime yok.\nAramanın yanındaki düğmeden bunları değiştirin.';

  @override
  String get tv_new_episodes => 'Yeni Bölümler';

  @override
  String get tv_recently_added => 'Son Eklenenler';

  @override
  String get tv_empty_category_hint =>
      'Bu kategoride henüz anime yok.\nBir başlığın ayrıntı sayfasından ona başlık ekleyin.';

  @override
  String get tv_empty_library => 'Anime kitaplığınız boş';

  @override
  String get tv_empty_library_hint =>
      'Evinizi doldurmak için Gözat\'tan anime ekleyin';

  @override
  String get tv_browse_anime => 'Animelere göz atın';

  @override
  String tv_new_count(int count) {
    return '$count yeni';
  }

  @override
  String tv_category_hidden(String category) {
    return '“$category”yi gizle · göstermek için “Tümü” üzerinde Tamam\'ı basılı tutun';
  }

  @override
  String get tv_no_hidden_categories => 'Gizli kategori yok';

  @override
  String get import_torrent_file => 'içe aktarma .torrent dosyası';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi ve daha fazlası';

  @override
  String get cloudflare_proxy_optional =>
      'İsteğe Bağlı FlareSolverr / Byparr URL';

  @override
  String get tv_home_layout_hint =>
      'Düz ızgara yerine satır tabanlı anime ana sayfası (Devam · Yeni Bölümler · kategoriler)';

  @override
  String get tv_hide_libraries_hint =>
      'Manga ve roman kitaplıklarını gizle (TV\'de varsayılan olarak açıktır)';

  @override
  String get anime_only_hint =>
      'Uygulama genelinde manga ve romanı gizleyin. Her şeyi göstermek için kapatın.';

  @override
  String get audio_auto_safe => 'Otomatik güvenli';

  @override
  String get tv_player_hint =>
      'Açık: özel TV oynatıcısı.  Kapalı: orijinal (masaüstü) oynatıcı.';

  @override
  String get release_open_failed => 'Sürüm açılamıyor';

  @override
  String get tv_replay => 'Tekrar Oynatma';

  @override
  String get tv_no_episodes => 'Henüz bölüm yok';

  @override
  String get tracker_continue_series => 'Diziyi izlemeye devam edin';

  @override
  String get tracker_watchlist_series => 'İzleme Listesi serisi';

  @override
  String get tracker_continue_movies => 'Film izlemeye devam edin';

  @override
  String get tracker_watchlist_movies => 'İzleme listesi filmleri';

  @override
  String get tracker_trending_series => 'Trend Serisi';

  @override
  String get tracker_trending_movies => 'Trend Olan Filmler';

  @override
  String get tracker_popular_series => 'Popüler Seri';

  @override
  String get tracker_popular_movies => 'Popüler Filmler';

  @override
  String get tracker_top_series => 'En İyi Seri (Tüm Zamanlar)';

  @override
  String get tracker_top_movies => 'En İyi Filmler (Tüm Zamanların)';

  @override
  String get tracker_airing_series => 'Havalandırma Serisi';

  @override
  String get tracker_airing_anime => 'Yayınlanan Anime';

  @override
  String get tracker_popular_anime => 'Popüler Anime';

  @override
  String get tracker_upcoming_anime => 'Yaklaşan Anime';

  @override
  String get tracker_popular_manga => 'Popüler Manga';

  @override
  String get tracker_top_manga => 'En İyi Manga';

  @override
  String get tracker_top_manhwa => 'En İyi Manhwa';

  @override
  String get tracker_top_manhua => 'En İyi Manhua';

  @override
  String get tracker_latest_anime => 'En Son Anime';

  @override
  String get tracker_best_anime => 'En Çok Puan Alan Anime';

  @override
  String get tracker_latest_manga => 'En Son Manga';

  @override
  String get tracker_best_manga => 'En Çok Puan Alan Manga';

  @override
  String get tracker_trending_anime => 'Trend Olan Anime';

  @override
  String get tracker_upcoming_manga => 'Yaklaşan Manga';

  @override
  String get tracker_trending_manga => 'Trend Olan Manga';

  @override
  String selection_progress(int selected, int total) {
    return '$selected/$total seçildi';
  }

  @override
  String get source_code_editor => 'Kod Düzenleyici';

  @override
  String get source_code_execute => 'Yürüt';

  @override
  String get source_console_logs => 'Konsol Günlükleri';

  @override
  String get source_no_logs => 'Henüz kayıt yok';

  @override
  String get source_updated_successfully => 'Kaynak başarıyla güncellendi';

  @override
  String get source_obsolete => 'ESKİ';

  @override
  String player_seek_forward_seconds(int seconds) {
    return '$seconds saniye ileri arama';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return '$seconds saniye geriye doğru arama';
  }

  @override
  String get player_autoplay_on => 'Otomatik oynatma sonraki bölüm: açık';

  @override
  String get player_autoplay_off =>
      'Sonraki bölümün otomatik oynatılması: kapalı';

  @override
  String get player_no_other_quality => 'Başka kalite yok';

  @override
  String get player_no_subtitles => 'Altyazı yok';

  @override
  String get player_no_audio_tracks => 'Ses parçası yok';

  @override
  String get player_seek_forward => 'İleriye doğru arama';

  @override
  String get player_seek_backward => 'Geriye doğru arama';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds saniye',
      one: '1 saniye',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'Lorem ipsum dolor sit amet';

  @override
  String get subtitle_style => 'Tarzı';

  @override
  String get translation_official_channel => 'NodeLane Resmi';

  @override
  String get translation_auth_required =>
      'Önce çeviri hesabınızda oturum açın.';

  @override
  String get translation_source_changed =>
      'Orijinal görüntü değişti. Lütfen yeniden yükleyin.';

  @override
  String get translation_source_missing =>
      'Orijinal görüntü şu anda kullanılamıyor.';

  @override
  String get translation_resource_limit =>
      'Bu resim cihazın işleme sınırını aşıyor. Orijinali saklanır.';

  @override
  String get translation_storage_full =>
      'Çeviri deposu dolu. Önce çevrilmiş görselleri temizleyin.';

  @override
  String get translation_invalid_image =>
      'Geçersiz resim formatı veya içeriği.';

  @override
  String get translation_unsupported_image =>
      'Çeviri bu görsel için desteklenmiyor. Orijinali saklanır.';

  @override
  String get translation_invalid_result =>
      'Çevrilen görselin doğrulanması başarısız oldu. Lütfen yeniden yükleyin.';

  @override
  String get translation_result_unavailable =>
      'Çevrilen resim kullanılamıyor. Lütfen yeniden yükleyin.';

  @override
  String get translation_result_expired =>
      'Çevrilen resmin süresi doldu. Lütfen tekrar tercüme edin.';

  @override
  String get translation_analysis_too_large =>
      'Analiz edilecek çok fazla görüntü içeriği var. Görüntü boyutunu küçültüp tekrar deneyin.';

  @override
  String get translation_region_limit =>
      'Resimde çok fazla metin bölgesi var. Bölün ve tekrar deneyin.';

  @override
  String get translation_text_limit =>
      'Bir metin bölgesi çok uzun. Görüntüyü ayarlayıp tekrar deneyin.';

  @override
  String get translation_unavailable => 'Bu çeviri artık mevcut değil.';

  @override
  String get translation_outcome_unknown =>
      'Sonucun doğrulanması gerekiyor. Tekrar gönderilmedi.';

  @override
  String get translation_rate_limited =>
      'İstekler sınırlıdır. Çeviri otomatik olarak devam edecektir.';

  @override
  String get translation_quota_exhausted => 'Yetersiz çeviri kotası.';

  @override
  String get translation_unsupported_language =>
      'Hizmet bu hedef dili desteklemiyor.';

  @override
  String get translation_upgrade_required =>
      'Çeviri protokolü uyumsuz. Uygulamayı güncelleyin.';

  @override
  String get translation_remote_failed =>
      'Bu sayfanın çevirisi başarısız oldu. Manuel olarak tekrar deneyebilirsiniz.';

  @override
  String get translation_bridge_invalid =>
      'Web sayfası değişti. Çeviriyi tekrar etkinleştirin.';

  @override
  String get translation_connection_failed =>
      'Bağlantı başarısız oldu. Lütfen tekrar deneyin.';

  @override
  String get translation_paused =>
      'Çeviri duraklatıldı. İlerlemesini doğrulayabilirsiniz.';

  @override
  String get translation_preparing_ellipsis => 'Çeviri hazırlanıyor…';

  @override
  String get translation_checking_original =>
      'Orijinal görüntü kontrol ediliyor…';

  @override
  String get translation_submitting => 'Gönderiliyor…';

  @override
  String get translation_uploading_ellipsis => 'Orijinal yükleniyor…';

  @override
  String get translation_waiting_ellipsis => 'Çeviri bekleniyor…';

  @override
  String get translation_running_ellipsis => 'Çeviriliyor…';

  @override
  String get translation_verify_result => 'Sonucun doğrulanması gerekiyor';

  @override
  String get translation_partial => 'Bazı içerik çevrildi';

  @override
  String get translation_ready => 'Çevrilmiş resim hazır';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Oynat';

  @override
  String get player_quality => 'Kalite';

  @override
  String get player_subtitles => 'Altyazılar';

  @override
  String get player_audio => 'Ses';

  @override
  String get player_statistics => 'Meraklıları için istatistikler';

  @override
  String get player_auto => 'Otomatik';

  @override
  String get source_information => 'Kaynak bilgisi';

  @override
  String get source_code_page => 'Page';

  @override
  String get source_code_query => 'Sorgu';

  @override
  String get repository_invalid_source => 'Geçersiz kaynak - kaldırın';

  @override
  String get player_fit_contain => 'İçerir';

  @override
  String get player_fit_cover => 'Cover';

  @override
  String get player_fit_fill => 'Doldur';

  @override
  String get player_fit_height => 'Yükseklik';

  @override
  String get player_fit_width => 'Genişlik';

  @override
  String get player_fit_scale => 'Terazisi';

  @override
  String get player_fit_none => 'Hiçbiri';

  @override
  String get player_shader_clear => 'Kapalı (gölgelendiricileri temizle)';

  @override
  String get player_shader_luma => 'Luma Yükseltme';

  @override
  String get player_decoder_auto => 'Otomatik (donanım)';

  @override
  String get player_decoder_software => 'Yazılımı (donanım yok)';

  @override
  String get player_stats_toggle => 'Yer paylaşımını değiştir';

  @override
  String get player_stats_general => 'General';

  @override
  String get player_stats_frames => 'Çerçeve zamanlamaları';

  @override
  String get player_stats_cache => 'Giriş önbelleği';

  @override
  String get player_stats_filters => 'Aktif filtreler';

  @override
  String get player_stats_log => 'Günlüğü';

  @override
  String get source_mark_pinned => 'Pim';

  @override
  String translation_image_action(String action) {
    return '$action bu resim';
  }

  @override
  String get memory_waiting => 'belleği: örnek bekleniyor';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current zirve $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'önbellek $current / $limit zirve $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'öğeler $count / $limit canlı $live zirve $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count örnekleri',
      one: '1 sample',
    );
    return 'tam $percent / $_temp0';
  }

  @override
  String get memory_reset_hint => 'sıfırlamak için ayarlardan kapatıp açın';

  @override
  String get action_hide => 'Gizle';

  @override
  String discord_get_app(String app) {
    return 'Get $app';
  }

  @override
  String get discord_idle => 'Boşta';

  @override
  String discord_watching_title(String title) {
    return 'İzleniyor $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'Okuma $title';
  }
}
