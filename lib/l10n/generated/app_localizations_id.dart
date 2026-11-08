// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get app_update_details_hint =>
      'Lihat catatan rilis dan opsi instalasi';

  @override
  String get app_update_download => 'Unduh pembaruan';

  @override
  String get app_update_download_hint =>
      'Setelah mengunduh, ikuti petunjuk untuk menginstal pembaruan.';

  @override
  String get bookshelf_all => 'Semua';

  @override
  String get bookshelf_search => 'Cari perpustakaan';

  @override
  String get app_update_allow_install =>
      'Izinkan instalasi aplikasi dalam pengaturan sistem, lalu kembali dan ketuk Instal.';

  @override
  String get app_update_waiting => 'Menunggu sistem melanjutkan pengunduhan…';

  @override
  String get app_update_cancel_download => 'Batalkan pengunduhan';

  @override
  String get app_update_remove_package => 'Hapus paket yang diunduh';

  @override
  String get app_name => 'NodeLane Comics';

  @override
  String get settings_search_empty => 'Tidak ada pengaturan yang cocok';

  @override
  String get search_empty_hint =>
      'Coba kata kunci lain, atau hapus pencarian untuk melihat semuanya.';

  @override
  String get search_clear => 'Hapus pencarian';

  @override
  String get app_updates => 'Pembaruan aplikasi';

  @override
  String get app_update_auto => 'Periksa peluncurannya';

  @override
  String get app_update_view => 'Lihat pembaruan';

  @override
  String get app_update_later => 'Nanti';

  @override
  String get app_update_external_hint =>
      'Membuka tautan pembaruan di browser Anda';

  @override
  String get app_update_failed =>
      'Tidak dapat memeriksa pembaruan. Silakan coba lagi.';

  @override
  String get app_update_opened => 'Tautan pembaruan dibuka';

  @override
  String get app_diagnostics => 'Diagnostik dan log';

  @override
  String get library => 'Perpustakaan';

  @override
  String get updates_search => 'Pembaruan pencarian';

  @override
  String get updates => 'Pembaruan';

  @override
  String get history => 'Riwayat';

  @override
  String get browse => 'Jelajahi';

  @override
  String get more => 'Lainnya';

  @override
  String get open_random_entry => 'Buka Entri Acak';

  @override
  String get import => 'Impor';

  @override
  String get filter => 'Filter';

  @override
  String get ignore_filters => 'Abaikan filter';

  @override
  String get downloaded => 'Telah Diunduh';

  @override
  String get unread => 'Belum Dibaca';

  @override
  String get unwatched => 'Belum ditonton';

  @override
  String get started => 'Dimulai';

  @override
  String get bookmarked => 'Ditandai';

  @override
  String get sort => 'Urutkan';

  @override
  String get alphabetically => 'Secara Abjad';

  @override
  String get last_read => 'Bacaan Terakhir';

  @override
  String get last_watched => 'Terakhir ditonton';

  @override
  String get last_update_check => 'Pemeriksaan Pembaruan Terakhir';

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
          'Kamu sedang menghapus semua $count $entryTypePlural dari $mediaType ini di perpustakaan kamu.',
      one:
          'Kamu sedang menghapus satu-satunya $entryType dari $mediaType ini di perpustakaan kamu.',
    );
    return '$_temp0\nIni juga akan menghapus seluruh $mediaType dari perpustakaanmu.\n\nCatatan: File-nya sendiri tidak akan dihapus.';
  }

  @override
  String get chapter => 'bab';

  @override
  String get episode => 'episode';

  @override
  String get unread_count => 'Jumlah Belum Dibaca';

  @override
  String get unwatched_count => 'Jumlah belum ditonton';

  @override
  String get latest_chapter => 'Bab Terbaru';

  @override
  String get latest_episode => 'Episode terbaru';

  @override
  String get date_added => 'Tanggal Ditambahkan';

  @override
  String get display => 'Tampilan';

  @override
  String get display_mode => 'Mode Tampilan';

  @override
  String get compact_grid => 'Grid Kompak';

  @override
  String get compression_level => 'Tingkat kompresi';

  @override
  String compression_info(Object level) {
    return 'Semakin tinggi kompresi, semakin sedikit ruang yang digunakan file backup, tetapi menggunakan lebih banyak CPU. Default: $level';
  }

  @override
  String get comfortable_grid => 'Grid Nyaman';

  @override
  String get cover_only_grid => 'Grid Hanya Sampul';

  @override
  String get list => 'Daftar';

  @override
  String get badges => 'Lencana';

  @override
  String get downloaded_chapters => 'Bab yang Diunduh';

  @override
  String get downloaded_episodes => 'Episode yang diunduh';

  @override
  String get language => 'Bahasa';

  @override
  String get local_source => 'Sumber Lokal';

  @override
  String get tabs => 'Tab';

  @override
  String get show_category_tabs => 'Tampilkan Tab Kategori';

  @override
  String get show_numbers_of_items => 'Tampilkan Jumlah Item';

  @override
  String get other => 'Lainnya';

  @override
  String get show_continue_reading_buttons =>
      'Tampilkan Tombol Lanjutkan Membaca';

  @override
  String get show_continue_watching_buttons =>
      'Tampilkan tombol lanjut menonton';

  @override
  String get empty_library => 'Perpustakaan Kosong';

  @override
  String get search => 'Cari...';

  @override
  String get no_recent_updates => 'Tidak Ada Pembaruan Terbaru';

  @override
  String get remove_everything => 'Hapus Semua';

  @override
  String get remove_everything_msg =>
      'Apakah Anda yakin? Semua riwayat akan hilang';

  @override
  String get remove_all_update_msg =>
      'Apakah Anda yakin? Seluruh pembaruan akan dihapus';

  @override
  String get ok => 'Baik';

  @override
  String get cancel => 'Batal';

  @override
  String get remove => 'Hapus';

  @override
  String get remove_history_msg =>
      'Riwayat bacaan untuk bab ini akan dihapus. Apakah Anda yakin?';

  @override
  String get last_used => 'Terakhir Digunakan';

  @override
  String get pinned => 'Ditandai';

  @override
  String get sources => 'Sumber';

  @override
  String get install => 'Pasang';

  @override
  String get update => 'Perbarui';

  @override
  String get latest => 'Terbaru';

  @override
  String get extensions => 'Ekstensi';

  @override
  String get migrate => 'Migrasi';

  @override
  String get mass_migration_title => 'Migrasi massal';

  @override
  String get mass_migration_preview_items => 'Pratinjau item';

  @override
  String get mass_migration_destination_source => 'Sumber tujuan';

  @override
  String get mass_migration_no_library_items =>
      'Tidak ada item pustaka yang tersedia untuk migrasi massal.';

  @override
  String get mass_migration_no_destination_sources =>
      'Tidak ada sumber tujuan terpasang yang tersedia.';

  @override
  String get mass_migration_installed => 'Terpasang';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item siap ditinjau',
      one: '1 item siap ditinjau',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'Pilih sumber tujuan';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Mencari kecocokan di $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Memproses item $current dari $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Menunggu 2 detik sebelum item berikutnya...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Menunggu 2 detik sebelum migrasi berikutnya...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Cocok sejauh ini: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Tidak ada kecocokan: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Tinjau kecocokan untuk $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Kecocokan ditemukan: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Tidak ada kecocokan: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Dipilih untuk migrasi: $count';
  }

  @override
  String get mass_migration_finish_review => 'Selesai meninjau';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migrasi item terpilih ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Memigrasi item terpilih ke $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Tidak ada item yang dipilih untuk migrasi.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Memigrasi item $current dari $total';
  }

  @override
  String get mass_migration_complete => 'Migrasi massal selesai';

  @override
  String get mass_migration_complete_success_message =>
      'Semua item terpilih berhasil diproses.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migrasi selesai dengan beberapa item yang masih memerlukan perhatian manual.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Diproses';

  @override
  String get mass_migration_matched => 'Cocok';

  @override
  String get mass_migration_migrated => 'Dimigrasikan';

  @override
  String get mass_migration_skipped => 'Dilompati';

  @override
  String get mass_migration_failed => 'Gagal';

  @override
  String get mass_migration_failed_items => 'Item Gagal';

  @override
  String get mass_migration_exit => 'Keluar dari Migrasi Massal';

  @override
  String get mass_migration_no_destination_match =>
      'Tidak ditemukan kecocokan tujuan';

  @override
  String mass_migration_query(Object query) {
    return 'Kueri: $query';
  }

  @override
  String get mass_migration_skip => 'Lompati';

  @override
  String get mass_migration_loading => 'Memuat...';

  @override
  String get mass_migration_choose_another_result => 'Pilih hasil lain';

  @override
  String get mass_migration_source_chapters => 'Bab sumber';

  @override
  String get mass_migration_destination_chapters => 'Bab tujuan';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab',
      one: '1 bab',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab sumber',
      one: '1 bab sumber',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab tujuan',
      one: '1 bab tujuan',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Tidak ada bab ditemukan.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Dan $count lagi...';
  }

  @override
  String get mass_migration_unknown_title => 'Judul tidak dikenal';

  @override
  String get mass_migration_unknown_match => 'Kecocokan tidak dikenal';

  @override
  String get mass_migration_unknown_source => 'Sumber tidak dikenal';

  @override
  String get mass_migration_unknown_chapter => 'Bab tidak dikenal';

  @override
  String get migrate_confirm => 'Migrasi ke sumber lain';

  @override
  String get clean_database => 'Bersihkan basis data';

  @override
  String cleaned_database(Object x) {
    return 'Basis data dibersihkan! $x entri dihapus';
  }

  @override
  String get clean_database_desc =>
      'Ini akan menghapus semua item yang tidak ditambahkan ke perpustakaan!';

  @override
  String get incognito_mode => 'Mode Incognito';

  @override
  String get incognito_mode_description => 'Menghentikan catatan bacaan';

  @override
  String get downloaded_only => 'Hanya yang diunduh';

  @override
  String get downloaded_only_description =>
      'Hanya tampilkan entri yang diunduh di perpustakaan Anda';

  @override
  String get download_queue => 'Antrian Unduhan';

  @override
  String get categories => 'Kategori';

  @override
  String get statistics => 'Statistik';

  @override
  String get settings => 'Pengaturan';

  @override
  String get about => 'Tentang';

  @override
  String get help => 'Bantuan';

  @override
  String get no_downloads => 'Tidak Ada Unduhan';

  @override
  String get edit_categories => 'Edit Kategori';

  @override
  String get edit_categories_description =>
      'Anda belum memiliki kategori. Tekan tombol tambah untuk membuat satu dan mengatur perpustakaan Anda';

  @override
  String get add => 'Tambah';

  @override
  String get add_category => 'Tambah Kategori';

  @override
  String get name => 'Nama';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Diperlukan';

  @override
  String get add_category_error_exist => 'Kategori dengan nama ini sudah ada!';

  @override
  String get delete_category => 'Hapus Kategori';

  @override
  String delete_category_msg(Object name) {
    return 'Apakah Anda ingin menghapus kategori $name?';
  }

  @override
  String get rename_category => 'Ubah Nama Kategori';

  @override
  String get general => 'Umum';

  @override
  String get general_subtitle => 'Bahasa Aplikasi';

  @override
  String get app_language => 'Bahasa Aplikasi';

  @override
  String get default_subtitle_language => 'Bahasa subtitle default';

  @override
  String get appearance => 'Tampilan';

  @override
  String get appearance_subtitle => 'Tema, Format Tanggal dan Waktu';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Mode Gelap';

  @override
  String get follow_system_theme => 'Ikuti tema sistem';

  @override
  String get on => 'Aktif';

  @override
  String get off => 'Nonaktif';

  @override
  String get pure_black_dark_mode => 'Mode Gelap Hitam Murni';

  @override
  String get timestamp => 'Cap Waktu';

  @override
  String get relative_timestamp => 'Cap Waktu Relatif';

  @override
  String get relative_timestamp_short => 'Singkat (Hari Ini, Kemarin)';

  @override
  String get relative_timestamp_long =>
      'Panjang (Singkat+, Beberapa Hari Lalu)';

  @override
  String get date_format => 'Format Tanggal';

  @override
  String get reader => 'Pembaca';

  @override
  String get refresh => 'Segarkan';

  @override
  String get reader_subtitle => 'Mode Baca, Tampilan, Navigasi';

  @override
  String get default_reading_mode => 'Mode Baca Default';

  @override
  String get reading_mode_vertical => 'Vertikal';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Dari Kiri ke Kanan';

  @override
  String get reading_mode_right_to_left => 'Dari Kanan ke Kiri';

  @override
  String get reading_mode_vertical_continuous => 'Vertikal Berkelanjutan';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Kecepatan Animasi Double Tap';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Cepat';

  @override
  String get no_animation => 'Tanpa Animasi';

  @override
  String get animate_page_transitions => 'Animasikan Transisi Halaman';

  @override
  String get crop_borders => 'Potong Batas';

  @override
  String get downloads => 'Unduhan';

  @override
  String get downloads_subtitle => 'Pengaturan Unduhan';

  @override
  String get download_location => 'Lokasi Unduhan';

  @override
  String get custom_location => 'Lokasi Khusus';

  @override
  String get only_on_wifi => 'Hanya di Wi-Fi';

  @override
  String get save_as_cbz_archive => 'Simpan sebagai Arsip CBZ';

  @override
  String get delete_download_after_reading => 'Hapus unduhan setelah dibaca';

  @override
  String get concurrent_downloads => 'Unduhan bersamaan';

  @override
  String get browse_subtitle => 'Sumber, Pencarian Umum';

  @override
  String get only_include_pinned_sources =>
      'Hanya Sertakan Sumber yang Ditandai';

  @override
  String get nsfw_sources => 'Sumber NSFW (+18)';

  @override
  String get nsfw_sources_show => 'Tampilkan di Daftar Sumber dan Ekstensi';

  @override
  String get nsfw_sources_info =>
      'Ini tidak menghentikan ekstensi tidak resmi atau yang salah klasifikasi dari menampilkan konten NSFW (18+) dalam aplikasi';

  @override
  String get version => 'Versi';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Periksa Pembaruan';

  @override
  String get logs_on => 'Aktifkan pencatatan';

  @override
  String get share_app_logs => 'Bagikan log aplikasi';

  @override
  String get no_app_logs => 'Tidak ada file log.txt tersedia!';

  @override
  String get failed => 'Gagal!';

  @override
  String n_days_ago(Object days) {
    return '$days Hari yang Lalu';
  }

  @override
  String get today => 'Hari Ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get a_week_ago => 'Seminggu yang Lalu';

  @override
  String get next_week => 'Minggu depan';

  @override
  String get add_to_library => 'Tambahkan ke Perpustakaan';

  @override
  String get completed => 'Selesai';

  @override
  String get ongoing => 'Berlangsung';

  @override
  String get on_hiatus => 'Ditunda';

  @override
  String get canceled => 'Dibatalkan';

  @override
  String get publishing_finished => 'Penerbitan selesai';

  @override
  String get unknown => 'Tidak diketahui';

  @override
  String get empty_placeholder => 'KOSONG';

  @override
  String get error => 'Kesalahan';

  @override
  String error_with_message(Object error) {
    return 'Kesalahan: $error';
  }

  @override
  String get no_pages_available => 'Kesalahan: tidak ada halaman tersedia';

  @override
  String get set_categories => 'Tetapkan kategori';

  @override
  String get edit => 'Edit';

  @override
  String get in_library => 'Di perpustakaan';

  @override
  String get filter_scanlator_groups => 'Saring grup scanlator';

  @override
  String get reset => 'Atur ulang';

  @override
  String get by_source => 'Berdasarkan sumber';

  @override
  String get by_chapter_number => 'Berdasarkan nomor bab';

  @override
  String get by_episode_number => 'Menurut nomor episode';

  @override
  String get by_upload_date => 'Berdasarkan tanggal unggah';

  @override
  String get source_title => 'Judul sumber';

  @override
  String get create_extension => 'Buat Ekstensi';

  @override
  String get developer_mode => 'Mode pengembang';

  @override
  String get developer_mode_subtitle =>
      'Tampilkan alat pengembang ekstensi (buat ekstensi, edit kode)';

  @override
  String get choose_extension_language => 'Pilih bahasa ekstensi';

  @override
  String get lang => 'Bahasa';

  @override
  String get base_url => 'URL Dasar';

  @override
  String get api_url_optional => 'URL API (opsional)';

  @override
  String get icon_url => 'URL Ikon';

  @override
  String get source_icon_url => 'URL Ikon Sumber';

  @override
  String get notes => 'Catatan';

  @override
  String get extension_name_example => 'contoh: Animeku';

  @override
  String get language_code_example => 'contoh: id';

  @override
  String get base_url_example => 'contoh: https://contoh.com';

  @override
  String get api_url_example => 'contoh: https://api.contoh.com';

  @override
  String get extension_notes_example => 'contoh: ekstensi ini memerlukan login';

  @override
  String get type => 'Tipe';

  @override
  String get target => 'Target';

  @override
  String get source_type_single => 'tunggal';

  @override
  String get source_type_multi => 'multi';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS terkompilasi LNReader';

  @override
  String get source_created_successfully => 'Sumber berhasil dibuat';

  @override
  String get source_already_exists => 'Sumber sudah ada';

  @override
  String get error_when_creating_source => 'Kesalahan saat membuat sumber';

  @override
  String get cookies_deleted => 'Cookie dihapus!';

  @override
  String get delete_all_cookies => 'Hapus semua cookie';

  @override
  String get chapter_number => 'Nomor bab';

  @override
  String get episode_number => 'Nomor episode';

  @override
  String get share => 'Bagikan';

  @override
  String n_chapters(Object n) {
    return '$n bab';
  }

  @override
  String missing_chapters(Object count) {
    return '$count bab hilang';
  }

  @override
  String get no_description => 'Tidak ada deskripsi';

  @override
  String get resume => 'Lanjutkan';

  @override
  String get read => 'Baca';

  @override
  String get watch => 'Tonton';

  @override
  String get popular => 'Populer';

  @override
  String get open_in_browser => 'Buka di peramban';

  @override
  String get clear_cookie => 'Bersihkan cookie';

  @override
  String get show_page_number => 'Tampilkan nomor halaman';

  @override
  String get from_library => 'Dari perpustakaan';

  @override
  String get downloaded_chapter => 'Bab yang diunduh';

  @override
  String page(Object page) {
    return 'Halaman $page';
  }

  @override
  String get global_search => 'Pencarian global';

  @override
  String get color_blend_level => 'Tingkat campuran warna';

  @override
  String current(Object char) {
    return 'Saat ini $char';
  }

  @override
  String finished(Object char) {
    return 'Selesai $char';
  }

  @override
  String next(Object char) {
    return 'Selanjutnya $char';
  }

  @override
  String previous(Object char) {
    return 'Sebelumnya $char';
  }

  @override
  String get no_more_chapter => 'Tidak ada lagi bab';

  @override
  String get no_result => 'Tidak ada hasil';

  @override
  String get send => 'Kirim';

  @override
  String get delete => 'Hapus';

  @override
  String get start_downloading => 'Mulai mengunduh sekarang';

  @override
  String get retry => 'Coba lagi';

  @override
  String get add_chapters => 'Tambahkan Bab';

  @override
  String get delete_chapters => 'Hapus Bab?';

  @override
  String get default0 => 'Bawaan';

  @override
  String get total_chapters => 'Total Bab';

  @override
  String get total_episodes => 'Total episode';

  @override
  String get import_local_file => 'Impor File Lokal';

  @override
  String get import_files => 'File';

  @override
  String get split_epub_chapters => 'Bagi menjadi bab';

  @override
  String get split_epub_chapters_description =>
      'Impor setiap bab EPUB sebagai entri terpisah';

  @override
  String get nothing_read_recently => 'Tidak ada yang dibaca baru-baru ini';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Belum dimulai';

  @override
  String get score => 'Skor';

  @override
  String get start_date => 'Tanggal mulai';

  @override
  String get finish_date => 'Tanggal selesai';

  @override
  String get reading => 'Membaca';

  @override
  String get on_hold => 'Ditunda';

  @override
  String get dropped => 'Dihentikan';

  @override
  String get plan_to_read => 'Rencana untuk membaca';

  @override
  String get re_reading => 'Membaca ulang';

  @override
  String get chapters => 'Bab';

  @override
  String get add_tracker => 'Tambah pelacak';

  @override
  String get one_tracker => '1 pelacak';

  @override
  String n_tracker(Object n) {
    return '$n pelacak';
  }

  @override
  String get tracking => 'Pelacakan';

  @override
  String get syncing => 'Sinkronisasi';

  @override
  String get sync_logged => 'Berhasil masuk';

  @override
  String get syncing_subtitle =>
      'Masukkan alamat server sinkronisasi Anda dan masuk melalui browser untuk menyinkronkan progres membaca di berbagai perangkat.';

  @override
  String get sync_service => 'Sinkronisasi mandiri';

  @override
  String get last_sync => 'Sinkronisasi terakhir pada: ';

  @override
  String get sync_login_browser => 'Masuk dengan peramban';

  @override
  String get sync_server => 'Alamat Server Sinkronisasi';

  @override
  String get sync_starting => 'Memulai sinkronisasi...';

  @override
  String get sync_finished => 'Sinkronisasi selesai';

  @override
  String get sync_failed => 'Sinkronisasi gagal';

  @override
  String get sync_restore_in_progress =>
      'Sinkronisasi dilewati — pemulihan sedang berlangsung';

  @override
  String sync_progress_percent(Object percent) {
    return 'Menyinkronkan… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Menyinkronkan…';

  @override
  String get sync_button_sync => 'Sinkronkan progres';

  @override
  String get sync_button_upload => 'Hanya unggah';

  @override
  String get sync_button_upload_info =>
      'Operasi ini akan sepenuhnya menggantikan data jarak jauh dengan data lokal!';

  @override
  String get sync_button_download => 'Hanya unduh';

  @override
  String get sync_button_download_info =>
      'Operasi ini akan sepenuhnya menggantikan data lokal dengan data jarak jauh!';

  @override
  String get sync_status_not_configured => 'Tidak terhubung';

  @override
  String get sync_status_checking => 'Memeriksa koneksi...';

  @override
  String get sync_status_connected => 'Terhubung';

  @override
  String get sync_status_unauthorized => 'Sesi berakhir, silakan masuk kembali';

  @override
  String get sync_status_unreachable => 'Server tidak dapat dijangkau';

  @override
  String get sync_section_general => 'Umum';

  @override
  String get sync_on => 'Aktifkan sinkronisasi';

  @override
  String get sync_auto => 'Sinkronisasi otomatis';

  @override
  String get sync_auto_warning =>
      'Sinkronisasi otomatis saat ini adalah fitur eksperimental!';

  @override
  String get sync_auto_off => 'Mati';

  @override
  String get sync_auto_5_minutes => 'Setiap 5 menit';

  @override
  String get sync_auto_10_minutes => 'Setiap 10 menit';

  @override
  String get sync_auto_30_minutes => 'Setiap 30 menit';

  @override
  String get sync_auto_1_hour => 'Setiap 1 jam';

  @override
  String get sync_auto_3_hours => 'Setiap 3 jam';

  @override
  String get sync_auto_6_hours => 'Setiap 6 jam';

  @override
  String get sync_auto_12_hours => 'Setiap 12 jam';

  @override
  String get server_error => 'Kesalahan server!';

  @override
  String get dialog_confirm => 'Konfirmasi';

  @override
  String get description => 'Deskripsi';

  @override
  String get reorder_navigation => 'Sesuaikan navigasi';

  @override
  String get reorder_navigation_description =>
      'Atur ulang dan sesuaikan setiap navigasi sesuai kebutuhan Anda.';

  @override
  String get floating_navigation_bar => 'Bilah navigasi mengambang';

  @override
  String get floating_navigation_bar_description =>
      'Gunakan kapsul terapung sebagai pengganti bilah navigasi standar yang terpasang.';

  @override
  String get full_screen_player => 'Gunakan Layar Penuh';

  @override
  String get full_screen_player_info =>
      'Otomatis gunakan layar penuh saat memutar video.';

  @override
  String episode_progress(Object n) {
    return 'Kemajuan: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n episode';
  }

  @override
  String missing_episodes(Object count) {
    return '$count episode hilang';
  }

  @override
  String get manga_sources => 'Sumber Manga';

  @override
  String get anime_sources => 'Sumber Anime';

  @override
  String get novel_sources => 'Sumber Novel';

  @override
  String get anime_extensions => 'Ekstensi Anime';

  @override
  String get manga_extensions => 'Ekstensi Manga';

  @override
  String get novel_extensions => 'Ekstensi Novel';

  @override
  String get extension_settings => 'Pengaturan ekstensi';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'Anda belum memiliki kategori';

  @override
  String get watching => 'Menonton';

  @override
  String get plan_to_watch => 'Rencana untuk menonton';

  @override
  String get re_watching => 'Menonton ulang';

  @override
  String get episodes => 'Episode';

  @override
  String get download => 'Unduh';

  @override
  String get new_update_available => 'Pembaruan baru tersedia';

  @override
  String app_version(Object v) {
    return 'Versi Aplikasi : v$v';
  }

  @override
  String get searching_for_updates => 'Mencari pembaruan...';

  @override
  String get no_new_updates_available => 'Tidak ada pembaruan baru';

  @override
  String get uninstall => 'Copot pemasangan';

  @override
  String uninstall_extension(Object ext) {
    return 'Copot pemasangan ekstensi $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Ketuk dua kali untuk mencari semua $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Tampilkan petunjuk pencarian ketuk dua kali';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Tampilkan tooltip pada navigasi Manga/Anime/Novel yang menjelaskan bahwa mengetuk dua kali akan membuka Pencarian Global.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" sudah ada di pustaka Anda melalui $source.';
  }

  @override
  String get add_anyway => 'Tetap Tambahkan';

  @override
  String get langauage => 'Bahasa';

  @override
  String get extension_detail => 'Detail ekstensi';

  @override
  String get scale_type => 'Tipe skala';

  @override
  String get scale_type_fit_screen => 'Sesuai layar';

  @override
  String get scale_type_stretch => 'Regangkan';

  @override
  String get scale_type_fit_width => 'Sesuai lebar';

  @override
  String get scale_type_fit_height => 'Sesuai tinggi';

  @override
  String get scale_type_original_size => 'Ukuran asli';

  @override
  String get scale_type_smart_fit => 'Sesuai pintar';

  @override
  String get page_preload_amount => 'Jumlah pramuat halaman';

  @override
  String get page_preload_amount_subtitle =>
      'Jumlah halaman yang akan dimuat sebelumnya saat membaca. Nilai yang lebih tinggi akan menghasilkan pengalaman membaca yang lebih lancar, dengan biaya penggunaan cache dan jaringan yang lebih tinggi.';

  @override
  String get image_loading_error => 'Gambar ini tidak dapat dimuat';

  @override
  String get add_episodes => 'Tambah Episode';

  @override
  String get video_quality => 'Kualitas';

  @override
  String get video_subtitle => 'Subtitle';

  @override
  String get check_for_extension_updates => 'Periksa pembaruan ekstensi';

  @override
  String get auto_extensions_updates => 'Pembaruan ekstensi otomatis';

  @override
  String get auto_extensions_updates_subtitle =>
      'Akan secara otomatis memperbarui ekstensi ketika versi baru tersedia.';

  @override
  String get check_for_app_updates => 'Periksa pembaruan aplikasi saat mulai';

  @override
  String get reading_mode => 'Mode membaca';

  @override
  String get custom_filter => 'Filter khusus';

  @override
  String get background_color => 'Warna latar belakang';

  @override
  String get white => 'Putih';

  @override
  String get black => 'Hitam';

  @override
  String get grey => 'Abu-abu';

  @override
  String get automaic => 'Otomatis';

  @override
  String get preferred_domain => 'Domain pilihan';

  @override
  String get load_more => 'Muat lebih banyak';

  @override
  String get cancel_all_for_this_series => 'Batalkan semua untuk seri ini';

  @override
  String get login => 'Masuk';

  @override
  String login_into(Object tracker) {
    return 'Masuk ke $tracker';
  }

  @override
  String get email_adress => 'Alamat Email';

  @override
  String get password => 'Kata Sandi';

  @override
  String log_out_from(Object tracker) {
    return 'Keluar dari $tracker?';
  }

  @override
  String get log_out => 'Keluar';

  @override
  String get update_pending => 'Pembaruan tertunda';

  @override
  String get update_all => 'Perbarui semua';

  @override
  String get backup_and_restore => 'Cadangan dan Pulihkan';

  @override
  String get create_backup => 'Buat cadangan';

  @override
  String get create_backup_dialog_title => 'Apa yang ingin Anda cadangkan?';

  @override
  String get create_backup_subtitle =>
      'Dapat digunakan untuk memulihkan perpustakaan saat ini';

  @override
  String get restore_backup => 'Pulihkan cadangan';

  @override
  String get encrypt_backups => 'Enkripsi cadangan';

  @override
  String get encrypt_backups_info =>
      'Lindungi file cadangan dengan kata sandi menggunakan enkripsi AES';

  @override
  String get no_secure_storage => 'Penyimpanan aman tidak ditemukan';

  @override
  String get no_keyring_warning =>
      'Sistem ini tidak memiliki layanan keyring, kata sandi tidak dapat disimpan dengan aman.\n\nSimpan tanpa enkripsi di database aplikasi?';

  @override
  String get enter_backup_password => 'Masukkan kata sandi cadangan';

  @override
  String get incorrect_password_try_again => 'Kata sandi salah, coba lagi.';

  @override
  String get set_backup_password => 'Atur kata sandi cadangan';

  @override
  String get confirm_password => 'Konfirmasi kata sandi';

  @override
  String get passwords_do_not_match => 'Kata sandi tidak cocok';

  @override
  String get password_required_to_restore =>
      'Kata sandi diperlukan untuk memulihkan cadangan ini.';

  @override
  String get restore_backup_subtitle =>
      'Pulihkan perpustakaan dari berkas cadangan';

  @override
  String get automatic_backups => 'Cadangan otomatis';

  @override
  String get backup_frequency => 'Frekuensi cadangan';

  @override
  String get backup_location => 'Lokasi cadangan';

  @override
  String get backup_options => 'Opsi cadangan';

  @override
  String get backup_options_dialog_title => 'Apa yang ingin Anda cadangkan?';

  @override
  String get backup_options_subtitle =>
      'Informasi apa yang akan disertakan dalam berkas cadangan';

  @override
  String get backup_and_restore_warning_info =>
      'Anda harus menyimpan salinan cadangan di tempat lain juga';

  @override
  String get library_entries => 'Entri perpustakaan';

  @override
  String get chapters_and_episode => 'Bab dan episode';

  @override
  String get every_6_hours => 'Setiap 6 jam';

  @override
  String get every_12_hours => 'Setiap 12 jam';

  @override
  String get daily => 'Setiap hari';

  @override
  String get every_2_days => 'Setiap 2 hari';

  @override
  String get weekly => 'Mingguan';

  @override
  String get restore_backup_warning_title =>
      'Memulihkan cadangan akan menimpa semua data yang ada.\n\nLanjutkan pemulihan?';

  @override
  String get restore_sync_question_title => 'Sinkronkan pemulihan ini?';

  @override
  String get restore_sync_question_message =>
      'Perangkat terhubung ke server sinkronisasi. Unggah data yang dipulihkan sekarang?';

  @override
  String get restore_sync_question_confirm => 'Ya, sinkronkan';

  @override
  String get restore_sync_question_deny => 'Tidak, nonaktifkan sinkronisasi';

  @override
  String get sync_disabled_after_restore =>
      'Sinkronisasi dinonaktifkan. Anda dapat mengaktifkannya di Pengaturan.';

  @override
  String get restore_sync_disabled_question_title =>
      'Sinkronisasi dinonaktifkan';

  @override
  String get restore_sync_disabled_question_message =>
      'Sinkronisasi mati. Aktifkan kembali dan unggah ke server?';

  @override
  String get restore_sync_question_reenable => 'Ya, aktifkan dan sinkronkan';

  @override
  String get restore_sync_question_keep_disabled => 'Biarkan dinonaktifkan';

  @override
  String get restore_sync_uploading => 'Menyinkronkan data ke server…';

  @override
  String get restore_sync_upload_success =>
      'Data berhasil disinkronkan ke server';

  @override
  String get services => 'Layanan';

  @override
  String get tracking_warning_info =>
      'Sinkronisasi satu arah untuk memperbarui kemajuan bab dalam layanan pelacakan. Atur pelacakan untuk entri individu dari tombol pelacakannya.';

  @override
  String get use_page_tap_zones => 'Gunakan zona ketukan halaman';

  @override
  String get manage_trackers => 'Kelola pelacak';

  @override
  String get restore => 'Pulihkan';

  @override
  String get backups => 'Cadangan';

  @override
  String get by_scanlator => 'Oleh scanlator';

  @override
  String get by_name => 'Berdasarkan nama';

  @override
  String get installed => 'Terpasang';

  @override
  String get auto_scroll => 'Gulir otomatis';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info => 'Bahasa pilihan, koreksi nada, kanal audio';

  @override
  String get player => 'Pemain';

  @override
  String get markEpisodeAsSeenSetting =>
      'Pada titik mana menandai episode sebagai terlihat';

  @override
  String get mark_duplicate_chapters_read =>
      'Tandai nomor bab duplikat sebagai dibaca';

  @override
  String get default_skip_intro_length => 'Panjang lewati intro default';

  @override
  String get default_playback_speed_length =>
      'Panjang kecepatan pemutaran default';

  @override
  String get updateProgressAfterReading => 'Perbarui kemajuan setelah membaca';

  @override
  String get no_sources_installed => 'Tidak ada sumber yang terpasang!';

  @override
  String get show_extensions => 'Tampilkan ekstensi';

  @override
  String get default_skip_forward_skip_length =>
      'Panjang lompatan maju default';

  @override
  String get aniskip_requires_info =>
      'AniSkip memerlukan informasi anime dilacak dengan MAL atau Anilist untuk berfungsi.';

  @override
  String get enable_aniskip => 'Aktifkan AniSkip';

  @override
  String get enable_auto_skip => 'Aktifkan pengabaian otomatis';

  @override
  String get aniskip_button_timeout => 'Timeout tombol';

  @override
  String get skip_opening => 'Lewati pembukaan';

  @override
  String get skip_ending => 'Lewati penutupan';

  @override
  String get fullscreen => 'Layar Penuh';

  @override
  String get update_library => 'Perbarui perpustakaan';

  @override
  String get next_chapter => 'Berikutnya bab';

  @override
  String get next_5_chapters => '5 bab berikutnya';

  @override
  String get next_10_chapters => '10 bab berikutnya';

  @override
  String get next_25_chapters => '25 bab berikutnya';

  @override
  String get all_chapters => 'Semua bab';

  @override
  String get next_episode => 'Episode berikutnya';

  @override
  String get next_5_episodes => '5 episode berikutnya';

  @override
  String get next_10_episodes => '10 episode berikutnya';

  @override
  String get next_25_episodes => '25 episode berikutnya';

  @override
  String get all_episodes => 'Semua episode';

  @override
  String get cover_saved => 'Sampul disimpan';

  @override
  String get set_as_cover => 'Atur sebagai sampul';

  @override
  String get use_this_as_cover_art => 'Gunakan ini sebagai seni sampul?';

  @override
  String get save => 'Simpan';

  @override
  String get picture_saved => 'Gambar disimpan';

  @override
  String get cover_updated => 'Penutup diperbarui';

  @override
  String get include_subtitles => 'Sertakan subtitle';

  @override
  String get blend_mode_default => 'Standar';

  @override
  String get blend_mode_multiply => 'Kalikan';

  @override
  String get blend_mode_screen => 'Layar';

  @override
  String get blend_mode_overlay => 'Tumpang tindih';

  @override
  String get blend_mode_colorDodge => 'Menghindari warna';

  @override
  String get blend_mode_lighten => 'Mencerahkan';

  @override
  String get blend_mode_colorBurn => 'Bakar warna';

  @override
  String get blend_mode_darken => 'Menggelapkan';

  @override
  String get blend_mode_difference => 'Perbedaan';

  @override
  String get blend_mode_saturation => 'Saturasi';

  @override
  String get blend_mode_softLight => 'Cahaya lembut';

  @override
  String get blend_mode_plus => 'Tambah';

  @override
  String get blend_mode_exclusion => 'Pengecualian';

  @override
  String get custom_color_filter => 'Filter warna kustom';

  @override
  String get color_filter_blend_mode => 'Mode pencampuran filter warna';

  @override
  String get enable_all => 'Aktifkan semua';

  @override
  String get disable_all => 'Nonaktifkan semua';

  @override
  String get font => 'Jenis Huruf';

  @override
  String get color => 'Warna';

  @override
  String get font_size => 'Ukuran Huruf';

  @override
  String get text => 'Teks';

  @override
  String get border => 'Batas';

  @override
  String get background => 'Latar Belakang';

  @override
  String get no_subtite_warning_message =>
      'Tidak berpengaruh karena tidak ada trek subtitle dalam video ini';

  @override
  String get grid_size => 'Ukuran Grid';

  @override
  String n_per_row(Object n) {
    return '$n per baris';
  }

  @override
  String get horizontal_continious => 'Lanjutan Horizontal';

  @override
  String get edit_code => 'Kode Edit';

  @override
  String get use_libass => 'Aktifkan libass';

  @override
  String get use_libass_info =>
      'Gunakan rendering subtitle berbasis libass untuk backend asli.';

  @override
  String get libass_not_disable_message =>
      'Nonaktifkan `gunakan libass` di pengaturan pemutar untuk dapat menyesuaikan subtitle.';

  @override
  String get override_ass_subtitles => 'Ganti teks film ASS';

  @override
  String get override_ass_subtitles_info =>
      'Terapkan gaya khusus ke teks film ASS/SSA';

  @override
  String get torrent_stream => 'Aliran Torrent';

  @override
  String get add_torrent => 'Tambahkan torrent';

  @override
  String get enter_torrent_hint_text => 'Masukkan magnet atau URL file torrent';

  @override
  String get torrent_url => 'URL torrent';

  @override
  String get or => 'ATAU';

  @override
  String get advanced => 'Lanjutan';

  @override
  String get advanced_info => 'Konfigurasi mpv';

  @override
  String get use_native_http_client => 'Gunakan klien http asli';

  @override
  String get use_native_http_client_info =>
      'secara otomatis mendukung fitur platform seperti VPN, mendukung lebih banyak fitur HTTP seperti HTTP/3 dan penanganan pengalihan khusus';

  @override
  String n_hour_ago(Object hour) {
    return '$hour jam yang lalu';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours jam yang lalu';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute menit yang lalu';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes menit yang lalu';
  }

  @override
  String n_day_ago(Object day) {
    return '$day hari yang lalu';
  }

  @override
  String get now => 'sekarang';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Pembaruan terakhir perpustakaan: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Data dan penyimpanan';

  @override
  String get download_location_info => 'Digunakan untuk unduhan bab';

  @override
  String get storage => 'Penyimpanan';

  @override
  String get clear_chapter_and_episode_cache => 'Hapus cache bab dan episode';

  @override
  String get cache_cleared => 'Cache dihapus';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Hapus cache bab/episode saat aplikasi dibuka';

  @override
  String get app_settings => 'Pengaturan aplikasi';

  @override
  String get sources_settings => 'Pengaturan sumber';

  @override
  String get include_sensitive_settings =>
      'Sertakan pengaturan sensitif (misalnya, token login pelacak)';

  @override
  String get create => 'Buat';

  @override
  String get downloads_are_limited_to_wifi =>
      'Unduhan dibatasi hanya untuk Wi-Fi';

  @override
  String get recommendations => 'Rekomendasi';

  @override
  String get recommendations_similar => 'serupa';

  @override
  String get recommendations_weights => 'Bobot rekomendasi';

  @override
  String get recommendations_weights_genre => 'Kesamaan genre';

  @override
  String get recommendations_weights_setting => 'Kesamaan latar';

  @override
  String get recommendations_weights_synopsis => 'Kesamaan cerita';

  @override
  String get recommendations_weights_theme => 'Kesamaan tema';

  @override
  String get manga_extensions_repo => 'Repositori ekstensi manga';

  @override
  String get anime_extensions_repo => 'Repositori ekstensi anime';

  @override
  String get novel_extensions_repo => 'Repositori ekstensi novel';

  @override
  String get custom_dns =>
      'DNS kustom (biarkan kosong untuk menggunakan DNS sistem)';

  @override
  String get android_proxy_server =>
      'Server Proxy Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Dapatkan M-Extension-Server';

  @override
  String get undefined => 'Tidak terdefinisi';

  @override
  String get empty_extensions_repo =>
      'Anda tidak memiliki URL repositori di sini. Klik tombol tambah untuk menambahkan satu!';

  @override
  String get add_extensions_repo => 'Tambahkan URL repositori';

  @override
  String get remove_extensions_repo => 'Hapus URL repositori';

  @override
  String get manage_manga_repo_urls => 'Kelola URL repositori manga';

  @override
  String get manage_anime_repo_urls => 'Kelola URL repositori anime';

  @override
  String get manage_novel_repo_urls => 'Kelola URL repositori novel';

  @override
  String get url_cannot_be_empty => 'URL tidak boleh kosong';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL harus diakhiri dengan .json / .pb';

  @override
  String get repo_url => 'URL repositori';

  @override
  String get invalid_url_format => 'Format URL tidak valid';

  @override
  String get clear_all_sources => 'Hapus semua sumber';

  @override
  String get clear_all_sources_msg =>
      'Ini akan sepenuhnya menghapus semua sumber dari aplikasi. Apakah Anda yakin ingin melanjutkan?';

  @override
  String get sources_cleared => 'Sumber dihapus!';

  @override
  String get repo_added => 'Repositori sumber ditambahkan!';

  @override
  String get repo_already_exists => 'Repositori sudah ada!';

  @override
  String get add_repo => 'Tambahkan repositori?';

  @override
  String get add_repo_sources_to_add =>
      'Daftar ekstensi yang akan ditambahkan:';

  @override
  String get add_repo_warning =>
      'Ekstensi dari repositori ini dijalankan di dalam aplikasi. Hanya tambahkan repositori yang Anda percayai.';

  @override
  String get genre_search_library => 'Cari genre di perpustakaan';

  @override
  String get genre_search_source => 'Jelajahi di sumber';

  @override
  String get source_not_added => 'Sumber tidak diinstal!';

  @override
  String get load_own_subtitles => 'Muat subtitle Anda sendiri...';

  @override
  String get search_subtitles => 'Cari subtitle online...';

  @override
  String extension_notes(Object notes) {
    return 'Catatan: $notes';
  }

  @override
  String get unsupported_repo =>
      'Repositori sumber ini tidak dapat ditambahkan. Periksa alamat repositori atau hubungi pengelolanya.';

  @override
  String get you_have_finished_reading => 'Anda telah selesai membaca';

  @override
  String get hwdec => 'Dekoder perangkat keras';

  @override
  String get enable_hardware_accel => 'Akselerasi perangkat keras';

  @override
  String get enable_hardware_accel_info =>
      'Aktifkan/nonaktifkan jika Anda mengalami bug atau crash';

  @override
  String get track_library_navigate => 'Pergi ke entri lokal yang ada';

  @override
  String get track_library_add => 'Tambahkan ke perpustakaan lokal';

  @override
  String get track_library_add_confirm =>
      'Tambahkan item yang dilacak ke perpustakaan lokal';

  @override
  String get track_library_not_logged =>
      'Masuk ke pelacak yang sesuai untuk menggunakan fitur ini!';

  @override
  String get track_library_switch => 'Beralih ke pelacak lain';

  @override
  String get go_back => 'Kembali';

  @override
  String get merge_library_nav_mobile =>
      'Gabungkan navigasi perpustakaan di ponsel';

  @override
  String get enable_discord_rpc => 'Aktifkan Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Sembunyikan Discord RPC saat Inkognito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Tampilkan bab saat ini di Discord (memerlukan restart)';

  @override
  String get rpc_show_title => 'Tampilkan judul saat ini di Discord';

  @override
  String get rpc_show_cover_image =>
      'Tampilkan gambar sampul saat ini di Discord';

  @override
  String get enable_mpv => 'Aktifkan shader / skrip mpv';

  @override
  String get mpv_info => 'Mendukung skrip .js di bawah mpv/scripts/';

  @override
  String get mpv_redownload => 'Unduh ulang file konfigurasi mpv';

  @override
  String get mpv_redownload_info =>
      'Mengganti file konfigurasi lama dengan yang baru!';

  @override
  String get mpv_download =>
      'File konfigurasi MPV diperlukan!\nUnduh sekarang?';

  @override
  String get custom_buttons => 'Tombol kustom';

  @override
  String get custom_buttons_info => 'Jalankan kode lua dengan tombol kustom';

  @override
  String get custom_buttons_edit => 'Edit tombol kustom';

  @override
  String get custom_buttons_add => 'Tambah tombol kustom';

  @override
  String get custom_buttons_added => 'Tombol kustom ditambahkan!';

  @override
  String get custom_buttons_delete => 'Hapus tombol kustom';

  @override
  String get custom_buttons_text => 'Teks tombol';

  @override
  String get custom_buttons_text_req => 'Teks tombol diperlukan';

  @override
  String get custom_buttons_js_code => 'Kode lua';

  @override
  String get custom_buttons_js_code_req => 'Kode lua diperlukan';

  @override
  String get custom_buttons_js_code_long => 'Kode lua (pada tekan lama)';

  @override
  String get custom_buttons_startup => 'Kode lua (saat startup)';

  @override
  String get custom_buttons_add_warning =>
      'Tombol ini menjalankan kode Lua di bawah ini pada pemutar video, yang dapat mengakses file Anda dan menjalankan program. Hanya tambahkan jika Anda yakin dari mana tautan ini berasal.';

  @override
  String n_days(Object n) {
    return '$n hari';
  }

  @override
  String get decoder => 'Dekoder';

  @override
  String get decoder_info =>
      'Dekoding perangkat keras, format piksel, debanding';

  @override
  String get enable_gpu_next => 'Aktifkan gpu-next (khusus Android)';

  @override
  String get enable_gpu_next_info => 'Mesin rendering video baru';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Gunakan format piksel YUV420P';

  @override
  String get use_yuv420p_info =>
      'Dapat memperbaiki layar hitam pada beberapa codec video, juga dapat meningkatkan kinerja dengan mengorbankan kualitas';

  @override
  String get audio_preferred_languages => 'Bahasa pilihan';

  @override
  String get audio_preferred_languages_info =>
      'Bahasa audio untuk dipilih secara default pada video dengan beberapa streaming audio, kode bahasa 2/3 huruf (mis: id, en, ja). Beberapa nilai dapat dipisahkan dengan koma.';

  @override
  String get enable_audio_pitch_correction => 'Aktifkan koreksi nada audio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Mencegah audio menjadi bernada tinggi pada kecepatan lebih cepat dan bernada rendah pada kecepatan lebih lambat';

  @override
  String get audio_channels => 'Kanal audio';

  @override
  String get volume_boost_cap => 'Batas peningkatan volume';

  @override
  String get internal_player => 'Pemutar internal';

  @override
  String get internal_player_info => 'Kemajuan, kontrol, orientasi';

  @override
  String get subtitle_delay_text => 'Penundaan subtitle';

  @override
  String get subtitle_delay => 'Penundaan (ms)';

  @override
  String get subtitle_speed => 'Kecepatan';

  @override
  String get tracks => 'Trek';

  @override
  String get playback_speed => 'Kecepatan pemutaran';

  @override
  String get shaders => 'Shader';

  @override
  String get video_fit => 'Kesesuaian';

  @override
  String get calendar => 'Kalender';

  @override
  String get calendar_no_data => 'Belum ada data.';

  @override
  String get calendar_info =>
      'Kalender hanya dapat memprediksi unggahan bab berikutnya berdasarkan unggahan yang lebih lama. Beberapa data mungkin tidak 100% akurat!';

  @override
  String in_n_day(Object days) {
    return 'dalam $days hari';
  }

  @override
  String in_n_days(Object days) {
    return 'dalam $days hari';
  }

  @override
  String get clear_library => 'Bersihkan perpustakaan';

  @override
  String get clear_library_desc =>
      'Pilih untuk menghapus semua entri manga, anime dan/atau novel';

  @override
  String get clear_library_input =>
      'Ketik \'manga\', \'anime\' dan/atau \'novel\' (dipisahkan dengan koma) untuk menghapus semua entri terkait';

  @override
  String get watch_order => 'Urutan menonton';

  @override
  String get watch_order_role_current => 'Saat ini';

  @override
  String get watch_order_role_previous => 'Sebelumnya';

  @override
  String get watch_order_role_next => 'Selanjutnya';

  @override
  String get watch_order_source_release_order => 'Perintah rilis';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name oleh $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Musim untuk $title';
  }

  @override
  String get watch_order_select_source => 'Sumber pesanan';

  @override
  String watch_order_season(int number) {
    return 'Musim $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Episode $number';
  }

  @override
  String get sequels => 'Sekuel';

  @override
  String get recommendations_similarity => 'Kesamaan:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Peringkat $rating';
  }

  @override
  String get local_folder_structure => 'Struktur folder lokal';

  @override
  String get local_folder => 'Folder lokal';

  @override
  String get add_local_folder => 'Tambah folder lokal';

  @override
  String get rescan_local_folder => 'Pindai ulang semua folder lokal sekarang';

  @override
  String get default_download_destination => 'Tujuan unduhan default';

  @override
  String get ask_download_destination => 'Tanyakan tujuan unduhan';

  @override
  String get ask_download_destination_desc =>
      'Pilih folder lokal setiap kali unduhan dimulai.';

  @override
  String get select_download_destination => 'Pilih tujuan unduhan';

  @override
  String get clear_local_library => 'Bersihkan pustaka lokal';

  @override
  String get clear_local_library_desc =>
      'Hapus entri folder dan arsip lokal dari pustaka.';

  @override
  String get clear_local_library_msg =>
      'Ini akan menghapus entri folder dan arsip lokal dari pustaka. File tidak akan dihapus dari disk.';

  @override
  String get custom => 'Kustom';

  @override
  String get no_local_folder_available_for_downloads =>
      'Tidak ada folder lokal untuk unduhan';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Gagal membuat CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Gagal membaca gambar sampul: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Gagal membaca metadata: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Gagal menyimpan ke pustaka: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Gagal membaca sampul bab: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Gagal membaca sampul arsip: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Gagal memuat pustaka lokal: $error';
  }

  @override
  String get export_metadata => 'Ekspor metadata';

  @override
  String get exported => 'Diekspor';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Gagal mengekspor metadata: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count bab tidak dapat diberi nomor otomatis.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Gagal memulai server webview Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Token $tracker kedaluwarsa';
  }

  @override
  String get video_list_empty => 'Daftar video kosong';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Tidak dapat membuka $url';
  }

  @override
  String get text_size => 'Ukuran Teks:';

  @override
  String get text_align => 'Perataan Teks';

  @override
  String get line_height => 'Tinggi Baris';

  @override
  String get show_scroll_percentage => 'Tampilkan Persentase Scroll';

  @override
  String get remove_extra_paragraph_spacing => 'Hapus Spasi Ekstra Paragraf';

  @override
  String select_label_color(Object label) {
    return 'Pilih Warna $label';
  }

  @override
  String get default_user_agent => 'Agen Pengguna Bawaan';

  @override
  String get forceLandscapeMode => 'Paksa Mode Lanskap';

  @override
  String get forceLandscapeModeSubtitle =>
      'Paksa pemain untuk menggunakan orientasi lanskap.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Penyedia DNS';

  @override
  String get tracked => 'Dilacak';

  @override
  String get auth_unlock_msg =>
      'Autentikasi untuk membuka kunci NodeLane Comics';

  @override
  String get app_locked => 'NodeLane Comics terkunci';

  @override
  String get auth_to_continue => 'Autentikasi untuk melanjutkan';

  @override
  String get authenticating => 'Mengautentikasi...';

  @override
  String get lock => 'Kunci';

  @override
  String get unlock => 'Buka';

  @override
  String get security => 'Keamanan';

  @override
  String get auth_to_change_security_setting =>
      'Autentikasi untuk mengubah pengaturan keamanan';

  @override
  String get app_lock => 'Kunci Aplikasi';

  @override
  String get require_biometric_or_device_credential =>
      'Memerlukan autentikasi biometrik atau kredensial perangkat untuk membuka aplikasi';

  @override
  String get biometric_or_device_credential_not_available =>
      'Autentikasi biometrik tidak tersedia di perangkat ini';

  @override
  String get app_lock_description =>
      'Ketika kunci aplikasi diaktifkan, Anda akan diminta untuk mengautentikasi\\nsetiap kali Anda membuka aplikasi atau kembali dari latar belakang.';

  @override
  String get checking_device_authentication =>
      'Memeriksa otentikasi perangkat…';

  @override
  String get device_authentication_incomplete =>
      'Otentikasi belum selesai. Pengaturan Anda tidak berubah.';

  @override
  String get keep_screen_on => 'Jaga Layar Tetap Menyala';

  @override
  String get webtoon_side_padding => 'Padding Samping Webtoon';

  @override
  String get show_page_gaps => 'Tampilkan Celah Halaman';

  @override
  String get invert_colors => 'Balik Warna';

  @override
  String get grayscale => 'Skala Abu-abu';

  @override
  String get brightness => 'Kecerahan';

  @override
  String get contrast => 'Kontras';

  @override
  String get saturation => 'Saturasi';

  @override
  String get navigation_layout => 'Tata Letak Navigasi';

  @override
  String get nav_layout_default => 'Bawaan';

  @override
  String get nav_layout_l_shaped => 'Bentuk L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Tepi';

  @override
  String get nav_layout_right_and_left => 'Kanan dan Kiri';

  @override
  String get nav_layout_disabled => 'Dinonaktifkan';

  @override
  String get color_enhancements => 'Peningkatan Warna';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Rerata per judul';

  @override
  String get completion_rate => 'Tingkat penyelesaian';

  @override
  String get watching_time => 'Waktu menonton';

  @override
  String get reading_time => 'Waktu membaca';

  @override
  String average_chapters_per_title(Object title) {
    return 'Rata-rata Bab per $title';
  }

  @override
  String get read_percentage => 'Persentase baca';

  @override
  String get entries => 'Entri';

  @override
  String get android_proxy_server_mihon => 'Server Proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Unduh dan konfigurasikan server proxy yang diperlukan untuk menggunakan ekstensi Mihon.';

  @override
  String get mihon_proxy_server => 'Server proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Unduh bundel server proxy sebelum menggunakan ekstensi Mihon. Bundel tersebut mencakup JRE dan JAR server ekstensi.';

  @override
  String get extension_server_intro_ios =>
      'Unduh JAR server proxy sebelum menggunakan ekstensi Mihon. iOS hanya memerlukan JAR server ekstensi.';

  @override
  String get checking_files => 'Memeriksa file';

  @override
  String get files_installed => 'File terpasang';

  @override
  String get files_missing => 'File hilang';

  @override
  String get update_files => 'Perbarui file';

  @override
  String get up_to_date => 'Sudah terbaru';

  @override
  String get choose_location => 'Pilih lokasi';

  @override
  String get import_existing_jar => 'Impor JAR yang ada';

  @override
  String get detect_files_in_selected_folder =>
      'Deteksi file di folder yang dipilih';

  @override
  String get preparing_download => 'Menyiapkan unduhan...';

  @override
  String get app_install_location => 'Lokasi pemasangan aplikasi';

  @override
  String get install_location => 'Lokasi pemasangan';

  @override
  String get jre_executable => 'Executable JRE';

  @override
  String get extension_server_jar => 'JAR server ekstensi';

  @override
  String get installed_version => 'Versi terpasang';

  @override
  String get latest_version => 'Versi terbaru';

  @override
  String get m_extension_server_description =>
      'Gunakan M-Extension-Server saat Anda memerlukan proxy perangkat Android terpisah. Atur alamat proxy di sini dan unduh APK dari GitHub.';

  @override
  String get set_proxy_address => 'Atur alamat proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'Tidak ada versi server proxy baru yang tersedia.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Tidak dapat memeriksa pembaruan server proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Tidak ada bundel server ekstensi yang tersedia untuk platform ini.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Gagal mengunduh bundel ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Bundel yang diunduh tidak berisi file yang diharapkan.';

  @override
  String get extension_server_files_ready => 'File server ekstensi sudah siap.';

  @override
  String get ios_extension_server_import_hint =>
      'Di iOS, server dipasang di dalam sandbox aplikasi. Gunakan \"Impor JAR yang ada\" untuk memasukkan file yang diunduh.';

  @override
  String get select_extension_server_folder => 'Pilih folder server ekstensi';

  @override
  String get selected_folder_does_not_exist => 'Folder yang dipilih tidak ada.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Tidak ada file server ekstensi ditemukan di folder yang dipilih.';

  @override
  String get extension_server_files_linked =>
      'File server ekstensi telah ditautkan.';

  @override
  String get select_extension_server_jar => 'Pilih JAR server ekstensi';

  @override
  String get selected_file_could_not_be_accessed =>
      'File yang dipilih tidak dapat diakses.';

  @override
  String get extension_server_jar_imported =>
      'JAR server ekstensi berhasil diimpor.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Tidak dapat meluncurkan halaman M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP Server (mis. 10.0.0.5 atau https://example.com)';

  @override
  String get not_configured => 'Belum dikonfigurasi';

  @override
  String get zero_interpreter => 'Penerjemah Zero';

  @override
  String get zero_interpreter_description =>
      'Kendalikan server penerjemah Zero secara otomatis atau manual.';

  @override
  String get start_server_on_launch => 'Mulai server saat aplikasi dibuka';

  @override
  String get runtime_status => 'Status runtime';

  @override
  String get running => 'Berjalan';

  @override
  String get stopped => 'Berhenti';

  @override
  String get start => 'Mulai';

  @override
  String get stop => 'Berhenti';

  @override
  String get webview => 'Tampilan Web';

  @override
  String get tts => 'Teks ke Suara';

  @override
  String get tts_speed => 'Kecepatan';

  @override
  String get tts_pitch => 'Nada';

  @override
  String get tts_language => 'Bahasa';

  @override
  String get tts_voice => 'Suara';

  @override
  String get tts_stop => 'Hentikan';

  @override
  String get tts_play => 'Mainkan';

  @override
  String get tts_pause => 'Jeda';

  @override
  String get tts_previous => 'Paragraf sebelumnya';

  @override
  String get tts_next => 'Paragraf berikutnya';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Paragraf $current dari $total';
  }

  @override
  String get tts_settings => 'Pengaturan TTS';

  @override
  String get tts_default => 'Bawaan';

  @override
  String get webtoon_disable_zoom_out => 'Nonaktifkan perkecil Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Ketuk ganda untuk zoom Webtoon';

  @override
  String get navigate_to_pan => 'Navigasi untuk menggeser';

  @override
  String get navigate_to_pan_subtitle =>
      'Pindahkan gambar dizoom sebelum membalik halaman';

  @override
  String get split_wide_pages => 'Bagi halaman ganda';

  @override
  String get dual_page_invert => 'Balikkan potongan setengah halaman';

  @override
  String get dual_page_rotate_to_fit => 'Putar agar pas';

  @override
  String get dual_page_rotate_to_fit_invert => 'Balikkan arah rotasi';

  @override
  String get double_page_single_first_page => 'Halaman pertama tunggal';

  @override
  String get double_page_single_first_page_subtitle =>
      'Tampilkan halaman pertama sendirian dalam mode halaman ganda';

  @override
  String get double_page_auto => 'Halaman ganda otomatis';

  @override
  String get double_page_auto_subtitle =>
      'Beralih ke mode halaman ganda secara otomatis saat lanskap';

  @override
  String get landscape_zoom => 'Zoom lanskap otomatis';

  @override
  String get zoom_start_position => 'Posisi awal zoom';

  @override
  String get zoom_start_left => 'Kiri';

  @override
  String get zoom_start_right => 'Kanan';

  @override
  String get zoom_start_center => 'Tengah';

  @override
  String get automatic_background => 'Latar belakang otomatis';

  @override
  String get tapping_inversion => 'Inversi pengetukan';

  @override
  String get tapping_inversion_none => 'Tidak ada';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertikal';

  @override
  String get tapping_inversion_both => 'Keduanya';

  @override
  String get flash_on_page_change => 'Flash saat ganti halaman';

  @override
  String get flash_on_page_change_subtitle => 'Pembantu anti-retensi AMOLED';

  @override
  String get flash_color => 'Warna flash';

  @override
  String get flash_color_black => 'Hitam';

  @override
  String get flash_color_white => 'Putih';

  @override
  String get flash_color_white_black => 'Putih & Hitam';

  @override
  String get flash_interval_label => 'Interval flash';

  @override
  String flash_interval_value(String n) {
    return '$n halaman';
  }

  @override
  String flash_interval(String n) {
    return 'Interval flash: $n halaman';
  }

  @override
  String get flash_duration_label => 'Durasi flash';

  @override
  String flash_duration_value(String n) {
    return '$n ms';
  }

  @override
  String flash_duration(String n) {
    return 'Durasi flash: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Tampilkan overlay navigasi saat memulai';

  @override
  String get reader_hide_threshold => 'Ambang batas menyembunyikan pembaca';

  @override
  String get reader_hide_threshold_highest => 'Tertinggi (5 px)';

  @override
  String get reader_hide_threshold_high => 'Tinggi (13 px)';

  @override
  String get reader_hide_threshold_low => 'Rendah (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Terendah (47 px)';

  @override
  String get error_no_pages_available =>
      'Kesalahan: tidak ada halaman tersedia';

  @override
  String get app_ui_scale => 'Skala antarmuka';

  @override
  String get app_ui_scale_subtitle =>
      'Buat antarmuka lebih besar atau lebih kecil agar sesuai dengan layar dan jarak pandang Anda.';

  @override
  String get allow_concurrent_downloads => 'Izinkan pengunduhan bersamaan';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Unduh dari berbagai sumber pada waktu yang sama. Satu sumber masih mengunduh satu bab pada satu waktu sehingga tidak kelebihan beban. Matikan untuk mengunduh satu per satu di mana-mana.';

  @override
  String get download_delay => 'Penundaan pengunduhan';

  @override
  String get download_delay_subtitle =>
      'Mati. Tambahkan penundaan dengan jitter acak antar bab agar lebih lembut di sumber.';

  @override
  String get save_search => 'Simpan pencarian';

  @override
  String get saved_searches => 'Pencarian tersimpan';

  @override
  String get enter_search_to_save_first =>
      'Masukkan pencarian untuk disimpan terlebih dahulu';

  @override
  String get no_saved_searches =>
      'Belum ada pencarian tersimpan untuk sumber ini.\nJalankan pencarian, lalu pilih \"Simpan pencarian\".';

  @override
  String get source => 'Sumber';

  @override
  String get something_went_wrong => 'Terjadi kesalahan';

  @override
  String get startup_failed => 'NodeLane Comics gagal menyelesaikan peluncuran';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sumber tanpa hasil',
      one: '1 sumber tanpa hasil',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Bagaimana data diimpor?';

  @override
  String get import_mode_message =>
      'Pilih untuk menggabungkan cadangan ini dengan pustaka saat ini atau mengganti seluruhnya.';

  @override
  String get import_mode_keep_existing => 'Gabungkan';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Menambahkan seri baru dan memperbarui yang cocok. Tidak ada yang dihapus.';

  @override
  String get import_mode_replace => 'Ganti';

  @override
  String get import_mode_replace_subtitle =>
      'Menghapus seluruh pustaka saat ini dan menggantinya dengan cadangan ini.';

  @override
  String get replace_summary_title => 'Siap mengganti pustaka';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Ini akan menghapus $currentCount seri dan menggantinya dengan $backupCount seri.';
  }

  @override
  String get replace_summary_confirm => 'Ganti';

  @override
  String replace_result_message(Object count) {
    return 'Pustaka diganti dengan $count seri dari cadangan.';
  }

  @override
  String get category_conflict_title => 'Kategori yang sudah ada ditemukan';

  @override
  String get category_conflict_message =>
      'Cadangan berisi kategori yang sudah ada di pustaka.';

  @override
  String get category_conflict_keep =>
      'Simpan — gabungkan ke kategori yang ada';

  @override
  String get category_conflict_delete => 'Hapus — biarkan tanpa kategori';

  @override
  String get source_conflict_title => 'Sumber tidak ditemukan';

  @override
  String get source_conflict_message =>
      'Beberapa sumber tidak cocok dengan ekstensi yang terpasang.';

  @override
  String get source_conflict_keep => 'Pertahankan nama asli';

  @override
  String get import_summary_title => 'Siap mengimpor';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries seri baru, $updatedSeries diperbarui, dan $newChapters bab baru.';
  }

  @override
  String get import_summary_confirm => 'Impor';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Diimpor $newSeries seri baru, diperbarui $updatedSeries, ditambahkan $newChapters bab.';
  }

  @override
  String get roll_back => 'Kembalikan';

  @override
  String get roll_back_confirm_message =>
      'Mengembalikan pustaka ke snapshot sebelum perubahan ini dibuat.';

  @override
  String get roll_back_done => 'Berhasil dikembalikan ke snapshot sebelumnya.';

  @override
  String get restoring_backup => 'Memulihkan pustaka…';

  @override
  String get roll_back_last_change => 'Kembalikan perubahan terakhir';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Snapshot dari $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count perubahan terbaru tersedia untuk dikembalikan';
  }

  @override
  String get delete_source_title => 'Hapus sumber dan manganya';

  @override
  String get delete_source_subtitle =>
      'Hapus semua manga dari suatu sumber beserta bab, unduhan, dan riwayatnya.';

  @override
  String get delete_source_pick_title => 'Pilih sumber yang akan dihapus';

  @override
  String get delete_source_empty => 'Tidak ada sumber di pustaka.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Hapus $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Ini secara permanen menghapus $mangaCount manga, $chapterCount bab, $historyCount entri riwayat dan $updateCount entri pembaruan. Tautan pelacakan disimpan. Hal ini tidak dapat dibatalkan kecuali dengan memutar kembali.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Hapus juga ekstensi yang terpasang';

  @override
  String get delete_source_keep_history => 'Pertahankan riwayat membaca';

  @override
  String get delete_source_keep_downloads => 'Pertahankan riwayat unduhan';

  @override
  String get delete_source_button => 'Hapus';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Dihapus $mangaCount manga dari $sourceName.';
  }

  @override
  String get merge_manga_title => 'Gabungkan manga duplikat';

  @override
  String get merge_manga_subtitle =>
      'Temukan manga dengan judul yang sama di bawah sumber yang sama dan gabungkan.';

  @override
  String get merge_manga_none_found => 'Tidak ada manga duplikat ditemukan.';

  @override
  String get merge_manga_pick_title => 'Manga yang mungkin duplikat';

  @override
  String get merge_manga_choose_primary_title =>
      'Gabungkan ke entri yang mana?';

  @override
  String get merge_manga_choose_primary_message =>
      'Bab, riwayat, dan pelacakan akan digabungkan ke entri yang dipilih.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab',
      one: '1 bab',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Gabungkan';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Digabungkan $count manga duplikat ke $mangaName.';
  }

  @override
  String get merge_preview_title => 'Konfirmasi penggabungan';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters bab ditemukan di entri lainnya. $duplicateChapters adalah duplikat dan akan dihapus (simpan salinan mana pun yang mengalami kemajuan pembacaan); $keptChapters akan ditambahkan. $duplicateTracks tautan pelacakan duplikat juga akan dihapus.';
  }

  @override
  String get memory_overlay => 'Tampilkan penggunaan memori';

  @override
  String get memory_overlay_subtitle =>
      'Tampilan langsung memori yang digunakan aplikasi. Untuk mengukur langsung pada perangkat: pantau saat menggulir perpustakaan atau membaca bab.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Laporan kesalahan';

  @override
  String get error_reports_subtitle =>
      'Kesalahan yang ditangkap aplikasi dan cara melaporkannya';

  @override
  String get error_reports_empty => 'Tidak ada kesalahan.';

  @override
  String get error_reports_likely_cause => 'Kemungkinan penyebab';

  @override
  String get error_reports_report => 'Laporkan di GitHub';

  @override
  String get error_reports_banner => 'NodeLane Comics mengalami kesalahan';

  @override
  String get error_reports_banner_action => 'Lihat';

  @override
  String get error_reports_copy => 'Salin';

  @override
  String get error_reports_copied => 'Disalin ke papan klip';

  @override
  String get error_reports_clear => 'Bersihkan';

  @override
  String get error_reports_extension_failure =>
      'Ini berasal dari ekstensi, bukan dari NodeLane Comics. Ekstensi ditulis dan dikelola oleh pengelola repositori tempat Anda memasang sumber ini, jadi perbaikan harus dilakukan di sana. Nama sumber dan apa yang Anda buka adalah informasi yang berguna untuk diberikan.';

  @override
  String get error_reports_already_reported => 'Sudah dilaporkan';

  @override
  String get error_reports_expected_failure =>
      'Hal ini biasanya disebabkan oleh sumber atau jaringan dan bukan aplikasi: tautan kedaluwarsa, server mati, atau koneksi terputus. Hanya perlu dilaporkan jika terus terjadi pada sumber yang berfungsi di tempat lain.';

  @override
  String get share_unavailable_copied =>
      'Berbagi tidak tersedia, disalin ke papan klip.';

  @override
  String get onboarding_title => 'Selamat datang di NodeLane Comics';

  @override
  String get onboarding_libraries_body =>
      'Pilih apa yang ingin Anda baca dan tonton.';

  @override
  String get onboarding_nav_title => 'Pustaka Anda';

  @override
  String get onboarding_nav_body =>
      'Tab terpisah untuk masing-masing atau digabung di bawah satu tab Pustaka.';

  @override
  String get onboarding_nav_split => 'Tab terpisah';

  @override
  String get onboarding_nav_merged => 'Satu tab Pustaka';

  @override
  String get onboarding_nav_inside => 'Mengetuk Pustaka akan mengganti tab ini';

  @override
  String get onboarding_next => 'Berikutnya';

  @override
  String get onboarding_restore => 'Pulihkan cadangan';

  @override
  String get onboarding_or_local => 'Atau gunakan file yang sudah Anda miliki';

  @override
  String get onboarding_local_folder => 'Tambah folder';

  @override
  String onboarding_local_existing(Object count) {
    return '$count folder sudah diatur';
  }

  @override
  String get onboarding_local_any_type => 'Manga, anime, dan novel didukung.';

  @override
  String get onboarding_local_scanning => 'Memindai folder';

  @override
  String onboarding_local_found(Object count) {
    return '$count judul ditemukan';
  }

  @override
  String get onboarding_local_remove => 'Hapus folder';

  @override
  String get onboarding_local_in_downloads =>
      'Ini adalah folder unduhan aplikasi.';

  @override
  String get onboarding_local_empty =>
      'Tidak ada yang ditemukan. Pilih folder induk.';

  @override
  String get onboarding_repo_failed => 'Gagal membaca repositori.';

  @override
  String get onboarding_repo_title => 'Tambah sumber';

  @override
  String get onboarding_body =>
      'Tambahkan repositori untuk menginstal ekstensi.';

  @override
  String get onboarding_add => 'Tambah repositori';

  @override
  String get onboarding_skip => 'Lewati untuk sekarang';

  @override
  String get onboarding_continue => 'Lanjutkan';

  @override
  String get onboarding_later =>
      'Anda dapat menambahkannya nanti di Pengaturan > Jelajah.';

  @override
  String get onboarding_replay => 'Tampilkan layar selamat datang';

  @override
  String get onboarding_replay_subtitle =>
      'Buka kembali layar pengaturan awal.';

  @override
  String get missing_source_check_title => 'Periksa sumber yang hilang';

  @override
  String get missing_source_check_subtitle =>
      'Temukan entri yang ekstensinya belum terpasang.';

  @override
  String get missing_source_check_none_found =>
      'Semua sumber entri pustaka terpasang.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sumber hilang',
      one: '1 sumber hilang',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Tidak ada sumber $itemType yang terpasang.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Tambahkan repositori di bagian Jelajahi, lalu pasang ekstensi untuk sumber tersebut.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sumber',
    );
    return 'Anda memiliki $_temp0 untuk ini, namun hanya sumber yang disematkan yang dicari.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Sematkan salah satu, atau matikan \"Hanya sertakan sumber yang disematkan\" di pengaturan Jelajahi.';

  @override
  String get global_search_all_nsfw =>
      'Semua sumber yang Anda miliki untuk ini ditandai NSFW dan disembunyikan.';

  @override
  String get global_search_all_nsfw_hint =>
      'Aktifkan sumber NSFW di pengaturan Jelajahi untuk mencarinya.';

  @override
  String get missing_source_check_result_message =>
      'Entri ini mengarah ke sumber yang tidak terpasang. Ketuk untuk memigrasikan atau pasang ekstensi.';

  @override
  String get related_titles => 'Terkait';

  @override
  String get related_none =>
      'Tidak ada judul terkait yang ditemukan untuk karya ini.';

  @override
  String get relation_adaptation => 'Adaptasi';

  @override
  String get relation_sequel => 'Sekuel';

  @override
  String get relation_prequel => 'Prequel';

  @override
  String get relation_parent => 'Cerita utama';

  @override
  String get relation_side_story => 'Cerita sampingan';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Versi alternatif';

  @override
  String get auto_library_update => 'Pembaruan perpustakaan otomatis';

  @override
  String get auto_library_update_subtitle =>
      'Periksa bab baru untuk setiap entri di perpustakaan Anda saat aplikasi dimulai.';

  @override
  String get auto_library_update_never => 'Jangan pernah';

  @override
  String get auto_library_update_12_hours => 'Setiap 12 jam';

  @override
  String get auto_library_update_daily => 'Harian';

  @override
  String get auto_library_update_2_days => 'Setiap 2 hari';

  @override
  String get auto_library_update_weekly => 'Mingguan';

  @override
  String get auto_library_update_wifi_only => 'Hanya lewat Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Lewati pembaruan terjadwal saat menggunakan data seluler.';

  @override
  String get padding => 'Bantalan';

  @override
  String get page_mode => 'Mode halaman';

  @override
  String get single_page => 'Halaman tunggal';

  @override
  String get double_page => 'Halaman ganda';

  @override
  String get speed => 'Kecepatan';

  @override
  String get theme_dark => 'Gelap';

  @override
  String get theme_light => 'Terang';

  @override
  String get theme_black => 'Hitam';

  @override
  String get theme_sepia => 'Sepia';

  @override
  String get decrease => 'Kurangi';

  @override
  String get increase => 'Tambah';

  @override
  String get chapter_swipe_actions => 'Aksi usap bab';

  @override
  String get chapter_swipe_start => 'Usap ke kanan';

  @override
  String get chapter_swipe_end => 'Usap ke kiri';

  @override
  String get chapter_swipe_toggle_bookmark => 'Alihkan penanda';

  @override
  String get chapter_swipe_toggle_read => 'Alihkan status baca';

  @override
  String get chapter_swipe_download => 'Unduh';

  @override
  String get chapter_swipe_disabled => 'Dinonaktifkan';

  @override
  String get update_errors => 'Perbarui kesalahan';

  @override
  String get no_update_errors => 'Tidak ada kesalahan pembaruan';

  @override
  String get clear_all => 'Hapus semua';

  @override
  String get dismiss => 'Singkirkan';

  @override
  String get previous_episode => 'Episode sebelumnya';

  @override
  String get clear_logs => 'Hapus log';

  @override
  String get bold => 'Berani';

  @override
  String get italic => 'Miring';

  @override
  String get color_yellow => 'Kuning';

  @override
  String get color_cyan => 'Sian';

  @override
  String get color_green => 'Hijau';

  @override
  String get color_orange => 'Oranye';

  @override
  String get continue_watching => 'Lanjutkan Menonton';

  @override
  String get search_your_anime => 'Cari anime Anda';

  @override
  String get category => 'Kategori';

  @override
  String get hidden_categories => 'Kategori tersembunyi';

  @override
  String get new_category => 'Kategori baru';

  @override
  String get local => 'Lokal';

  @override
  String get tv_home_rows => 'Baris';

  @override
  String get genre_rows => 'Baris genre';

  @override
  String get share_backup_file => 'Bagikan file cadangan NodeLane Comics';

  @override
  String get close => 'Tutup';

  @override
  String get migrate_source => 'Migrasi sumber';

  @override
  String get cloudflare_bypass_proxy => 'Proksi bypass Cloudflare';

  @override
  String get custom_doh_url => 'DoH Kustom URL';

  @override
  String get custom_doh_url_helper =>
      'Harus berupa titik akhir https DoH (JSON).';

  @override
  String get anime_only_tv_layout => 'Tata letak TV khusus anime';

  @override
  String get anime_only_beta => 'Khusus anime (beta)';

  @override
  String get tv_home_beta => 'Rumah TV (beta)';

  @override
  String get tv_player_beta => 'Pemutar TV (beta)';

  @override
  String get network_settings => 'Jaringan';

  @override
  String get reader_page_layout => 'Tata letak halaman';

  @override
  String get reader_continuous_options => 'Membaca terus menerus';

  @override
  String get reader_default_mode_hint =>
      'Mode membaca default berlaku untuk judul tanpa mode individual yang diatur saat membaca.';

  @override
  String get extension_service => 'Layanan penyuluhan';

  @override
  String get extension_service_description =>
      'Kelola waktu proses ekstensi dan alamat proksi.';

  @override
  String get proxy_address => 'Alamat proksi';

  @override
  String get checking_runtime_status => 'Memeriksa status…';

  @override
  String download_delay_value(int seconds) {
    return '$seconds s + penundaan acak';
  }

  @override
  String download_queue_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab',
      one: '1 bab',
    );
    return '$_temp0';
  }

  @override
  String get download_queue_empty_hint =>
      'Tambahkan unduhan dari daftar bab judul.';

  @override
  String get download_queue_order_hint => 'Tarik pegangan untuk menyusun ulang';

  @override
  String get download_queue_empty => 'Tidak ada unduhan yang antri';

  @override
  String get download_queue_actions => 'Unduh tindakan';

  @override
  String get download_queue_cancel_chapter => 'Batalkan pengunduhan bab ini';

  @override
  String get download_queue_cancel_series =>
      'Batalkan semua unduhan untuk judul ini';

  @override
  String get download_queue_start => 'Mulai pengunduhan';

  @override
  String get download_queue_retry => 'Coba lagi unduh';

  @override
  String get download_queue_active => 'Mengunduh';

  @override
  String get download_queue_waiting => 'Menunggu untuk diunduh';

  @override
  String get download_queue_failed => 'Pengunduhan gagal';

  @override
  String get cf_proxy_helper =>
      'Titik akhir FlareSolverr / Byparr. Biarkan kosong untuk menonaktifkan.';

  @override
  String get mobile_navigation_description =>
      'Tarik untuk menyusun ulang. Manga, anime, dan novel berbagi tab Perpustakaan. Item pertama yang terlihat terbuka saat peluncuran. Telusuri dan Lainnya tetap terlihat; tab tambahan muncul di bawah Lainnya.';

  @override
  String get text_align_justify => 'Benarkan';

  @override
  String get novel_session_modes_hint =>
      'Mengatur mode membaca dan halaman tunggal atau ganda saat membaca judul.';

  @override
  String get tts_languages_failed =>
      'Tidak dapat memuat bahasa dari mesin ucapan.';

  @override
  String get tts_languages_empty =>
      'Mesin ucapan tidak menghasilkan bahasa. Pilihan Anda yang disimpan disimpan.';

  @override
  String get tts_language_unavailable =>
      'Bahasa yang disimpan ini tidak ada dalam daftar perangkat saat ini.';

  @override
  String get tts_apply_failed =>
      'Tidak dapat menerapkan pengaturan ini pada mesin ucapan. Anda dapat mencoba lagi.';

  @override
  String get player_controls => 'Kontrol';

  @override
  String get audio_channel_auto => 'Otomatis';

  @override
  String get audio_channel_auto_safe => 'Otomatis (aman)';

  @override
  String get audio_channel_mono => 'Mono';

  @override
  String get audio_channel_stereo => 'Stereo';

  @override
  String get audio_channel_reverse_stereo => 'Membalikkan stereo';

  @override
  String get mpv_bundled_config_hint =>
      'Pulihkan konfigurasi, skrip, dan shader yang disertakan dengan aplikasi. File dengan nama yang sama akan ditimpa.';

  @override
  String get mpv_restore_bundled => 'Pulihkan konfigurasi yang dibundel';

  @override
  String get mpv_restore_confirm =>
      'Kembalikan konfigurasi MPV yang dibundel? Konfigurasi yang ada, skrip dan shader dengan nama yang sama akan ditimpa. File lain akan disimpan.';

  @override
  String get player_operation_incomplete =>
      'Operasi tidak dapat diselesaikan. Periksa akses file dan coba lagi.';

  @override
  String get custom_buttons_empty_hint =>
      'Tambahkan tombol pemutar dengan label dan tindakan pers.';

  @override
  String get custom_button_primary => 'Tombol bawaan';

  @override
  String get show_password => 'Tampilkan kata sandi';

  @override
  String get hide_password => 'Sembunyikan kata sandi';

  @override
  String get tracking_accounts_empty =>
      'Hubungkan layanan dalam pengaturan Pelacakan untuk mengelola entrinya.';

  @override
  String get tracking_entries_empty =>
      'Tidak ada entri terlacak untuk jenis media ini. Tambahkan pelacakan dari halaman detail judul.';

  @override
  String get change_tracking_match => 'Ubah judul yang cocok';

  @override
  String get remove_tracking => 'Hapus pelacakan';

  @override
  String remove_tracking_confirm(String title) {
    return 'Hapus tautan pelacakan untuk “$title”? Entri dalam layanan pelacakan akan disimpan.';
  }

  @override
  String get tracking_refresh_required =>
      'Status pelacakan tidak dapat dikonfirmasi. Segarkan sebelum melakukan perubahan lainnya.';

  @override
  String get tracking_entry_unlinked =>
      'Catatan ini tidak ditautkan ke judul lokal, jadi tidak dapat diedit di sini.';

  @override
  String get backup_selection_shared =>
      'Perubahan pada pilihan ini segera disimpan dan juga berlaku pada pencadangan otomatis.';

  @override
  String get library_snapshot_history => 'Memulihkan snapshot perpustakaan';

  @override
  String get library_snapshot_empty =>
      'Tidak ada snapshot keselamatan yang tersedia.';

  @override
  String get library_snapshot_restore_message =>
      'Data saat ini akan digantikan oleh cuplikan ini. Perubahan yang dilakukan sejak saat itu akan hilang. Unduhan yang dihapus tidak dapat dipulihkan. Snapshot keselamatan yang tersedia akan dihapus setelah berhasil.';

  @override
  String get library_maintenance_working => 'Memperbarui perpustakaan…';

  @override
  String get library_safety_snapshot_note =>
      'Cuplikan keselamatan akan disimpan sebelum operasi ini. Itu tidak termasuk file yang diunduh.';

  @override
  String library_delete_summary(
    int mangaCount,
    int chapterCount,
    int historyCount,
    int updateCount,
  ) {
    return 'Entri perpustakaan: $mangaCount. Bab: $chapterCount. Entri sejarah: $historyCount. Pembaruan: $updateCount.\n\nPilih apa yang ingin disimpan di bawah.';
  }

  @override
  String get library_delete_pick_message =>
      'Pilih sumber untuk meninjau konten dan opsi penghapusannya.';

  @override
  String get mobile_categories_hint =>
      'Tarik untuk menyusun ulang. Buka kategori untuk mengganti namanya atau mengubah visibilitas dan pembaruannya.';

  @override
  String get mobile_category_visible => 'Tampilkan di perpustakaan';

  @override
  String get mobile_category_hidden => 'Tersembunyi dari perpustakaan';

  @override
  String get mobile_category_updates => 'Sertakan dalam pembaruan perpustakaan';

  @override
  String get statistics_watched => 'Menonton';

  @override
  String get calendar_month => 'Bulan';

  @override
  String get calendar_two_weeks => '2 minggu';

  @override
  String get calendar_week => 'Minggu';

  @override
  String get calendar_show_all_dates => 'Tampilkan semua tanggal';

  @override
  String get update_check_no_result =>
      'Tidak ditemukan pembaruan yang dapat diinstal. Anda dapat mencoba lagi nanti.';

  @override
  String get release_notes => 'Catatan rilis';

  @override
  String get no_release_notes => 'Tidak ada catatan rilis yang disediakan.';

  @override
  String get downloading_update => 'Mengunduh pembaruan…';

  @override
  String get preparing_installation => 'Mempersiapkan instalasi…';

  @override
  String get onboarding_mobile_libraries_body =>
      'Pilih apa yang akan dibaca. Anda dapat mengubahnya nanti.';

  @override
  String get onboarding_content_title => 'Mulailah membaca';

  @override
  String get onboarding_mobile_sources_body =>
      'Pilih cara untuk memulai, atau menambahkan konten nanti.';

  @override
  String onboarding_step_count(int step, int total) {
    return 'Langkah $step dari $total';
  }

  @override
  String global_search_results_for(String query) {
    return 'Hasil untuk “$query”';
  }

  @override
  String global_search_scope(String type, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sumber',
      one: '1 sumber',
    );
    return '$type · $_temp0';
  }

  @override
  String get migration_search_prompt => 'Cari judul tujuan.';

  @override
  String get migration_original_item => 'Barang saat ini';

  @override
  String get migration_target_item => 'Barang yang dipilih';

  @override
  String get migration_partial_failure =>
      'Operasinya belum selesai. Beberapa perubahan mungkin telah disimpan. Periksa item ini di perpustakaan Anda sebelum mencoba lagi.';

  @override
  String get migration_no_categories =>
      'Tidak ada kategori. Anda dapat menambahkan item ini tanpa kategori.';

  @override
  String get mass_migration_select_source => 'Pilih sumber saat ini';

  @override
  String get mass_migration_select_all => 'Pilih semua';

  @override
  String get mass_migration_deselect_all => 'Batalkan pilihan semua';

  @override
  String get mass_migration_needs_review => 'Tinjau migrasi yang tidak lengkap';

  @override
  String get bookshelf_actions => 'Tindakan rak buku';

  @override
  String get bookshelf_ignore_filters => 'Abaikan filter saat mencari';

  @override
  String get bookshelf_ignore_filters_hint =>
      'Cari semua karya dalam kategori ini, termasuk yang disembunyikan oleh filter.';

  @override
  String get bookshelf_stop_update => 'Hentikan pembaruan perpustakaan';

  @override
  String bookshelf_selected_count(int count) {
    return '$count karya dipilih';
  }

  @override
  String get bookshelf_remove_library => 'Hapus dari rak buku';

  @override
  String get bookshelf_remove_library_hint =>
      'Menghapus favorit. Impor lokal juga kehilangan perpustakaan dan catatan bacaannya.';

  @override
  String get bookshelf_remove_downloads => 'Hapus file yang diunduh';

  @override
  String get bookshelf_remove_downloads_hint =>
      'Menghapus file yang diunduh sambil menyimpan informasi pekerjaan.';

  @override
  String get bookshelf_remove_local_files_hint =>
      'Juga menghapus file lokal yang diimpor dan menghapus catatan perpustakaannya. File-file ini tidak dapat dipulihkan di sini.';

  @override
  String get bookshelf_remove_incomplete =>
      'Operasinya belum selesai. Beberapa karya atau file mungkin telah diproses. Tutup dialog ini dan periksa rak buku dan unduhan Anda sebelum melanjutkan.';

  @override
  String get bookshelf_processing => 'Memproses…';

  @override
  String get bookshelf_mark_read => 'Tandai sudah dibaca';

  @override
  String get bookshelf_mark_unread => 'Tandai belum dibaca';

  @override
  String get bookshelf_select_all => 'Pilih semua';

  @override
  String get bookshelf_invert_selection => 'Balikkan pilihan';

  @override
  String get bookshelf_settings => 'Pengaturan rak buku';

  @override
  String get bookshelf_settings_live =>
      'Perubahan filter, pengurutan, dan tampilan akan segera berlaku.';

  @override
  String get bookshelf_filter_any => 'Apa saja';

  @override
  String get bookshelf_filter_include => 'Sertakan';

  @override
  String get bookshelf_filter_exclude => 'Kecualikan';

  @override
  String get bookshelf_all_sources => 'Semua sumber';

  @override
  String bookshelf_sources_selected(int count) {
    return '$count sumber dipilih';
  }

  @override
  String get bookshelf_sort_ascending => 'Naik';

  @override
  String get bookshelf_sort_descending => 'Turun';

  @override
  String get bookshelf_layout => 'Tata letak rak buku';

  @override
  String get bookshelf_sources_hint =>
      'Pilih tidak ada untuk menampilkan semua sumber. Perubahan berlaku saat Anda mengetuk Filter.';

  @override
  String get bookshelf_choose_files => 'Pilih file';

  @override
  String get bookshelf_import_wait =>
      'Pilih file di pemilih dan tunggu hingga impor selesai.';

  @override
  String get bookshelf_import_incomplete =>
      'Impor belum selesai. Beberapa file mungkin sudah ada di rak buku Anda. Tutup dialog ini dan periksa sebelum mengimpor lagi.';

  @override
  String get bookshelf_categories_replace =>
      'Menyimpan menetapkan kategori ini ke setiap karya yang dipilih, menggantikan kategori sebelumnya.';

  @override
  String get bookshelf_categories_hint =>
      'Pilih satu atau lebih kategori, atau biarkan pilihan kosong agar tidak menetapkan satu pun kategori.';

  @override
  String get bookshelf_categories_hidden =>
      'Kategori tersembunyi yang ada disimpan untuk pekerjaan ini.';

  @override
  String get bookshelf_categories_incomplete =>
      'Kategori tidak dapat disimpan sepenuhnya. Tutup dialog ini dan periksa rak buku sebelum mencoba lagi.';

  @override
  String get bookshelf_categories_none_visible =>
      'Tidak ada kategori yang tersedia di sini. Buka manajemen kategori untuk meninjaunya.';

  @override
  String get bookshelf_manage_categories => 'Kelola kategori';

  @override
  String get manga_actions => 'Aksi komik';

  @override
  String get manga_download_scope => 'Unduh bab';

  @override
  String get manga_download_scope_hint =>
      'Pilih bab dalam filter saat ini. Bab yang diunduh dilewati.';

  @override
  String get manga_download_scope_empty =>
      'Tidak ada bab yang cocok dengan filter saat ini. Tutup menu ini dan sesuaikan filter bab.';

  @override
  String get manga_action_incomplete =>
      'Aksinya belum selesai. Periksa status saat ini sebelum mencoba lagi.';

  @override
  String get chapter_settings => 'Pengaturan bab';

  @override
  String get chapter_settings_live =>
      'Filter dan pengurutan perubahan segera diterapkan.';

  @override
  String get chapter_scanlators_all => 'Tampilkan semua grup pemindai';

  @override
  String get chapter_scanlators_hint =>
      'Pilih grup untuk menyembunyikan babnya. Perubahan berlaku saat Anda mengetuk Filter.';

  @override
  String chapter_scanlators_hidden(int count) {
    return '$count grup pemindai disembunyikan';
  }

  @override
  String chapter_selected_count(int count) {
    return '$count bab dipilih';
  }

  @override
  String get chapter_add_bookmark => 'Penanda';

  @override
  String get chapter_remove_bookmark => 'Hapus penanda';

  @override
  String get chapter_read_following => 'Baca di bawah';

  @override
  String get chapter_delete_records => 'Hapus catatan bab';

  @override
  String get chapter_delete_local_hint =>
      'Menghapus catatan bab yang dipilih dan kemajuan membaca. Arsip lokal asli disimpan; salinan yang diunduh dibersihkan.';

  @override
  String get chapter_delete_last_hint =>
      'Ini semua adalah bab dalam komik ini. Menghapusnya juga akan menghapus komik dari rak buku Anda.';

  @override
  String get chapter_action_incomplete =>
      'Aksinya belum selesai. Beberapa perubahan mungkin sudah disimpan. Tutup dan periksa bab dan unduhan sebelum melanjutkan.';

  @override
  String get reader_display_scope =>
      'Mode membaca dan tata letak halaman manual berlaku untuk komik ini. Pilih perubahan untuk kembali membaca.';

  @override
  String get reader_display_single_only =>
      'Pembacaan horizontal terus menerus menggunakan satu halaman.';

  @override
  String get reader_display_manual_pages =>
      'Mengubah tata letak halaman mematikan halaman ganda otomatis untuk semua komik.';

  @override
  String get reader_display_crop_scope => 'Berlaku untuk semua komik.';

  @override
  String get reader_chapter_locate => 'Temukan bab saat ini';

  @override
  String get reader_chapter_search => 'Cari bab atau pemindai';

  @override
  String get reader_chapter_scope =>
      'Menggunakan filter bab dan urutan dari detail komik. Bookmark segera disimpan.';

  @override
  String get reader_chapter_current_hidden =>
      'Bab yang Anda baca berada di luar filter saat ini.';

  @override
  String get reader_chapter_current => 'Membaca sekarang';

  @override
  String get reader_chapter_read => 'Baca';

  @override
  String get reader_chapter_bookmark_failed =>
      'Penyimpanan bookmark tidak dapat dikonfirmasi. Tutup daftar dan periksa statusnya saat ini.';

  @override
  String get reader_image_actions => 'Tindakan gambar';

  @override
  String get reader_image_original =>
      'Menggunakan halaman asli lengkap, tanpa terjemahan, pemotongan, atau filter warna pembaca.';

  @override
  String get reader_image_save_ios =>
      'Simpan ke folder Gambar di lokasi penyimpanan aplikasi saat ini.';

  @override
  String get reader_image_save_android =>
      'Simpan ke folder Pictures/nodelane-comics perangkat.';

  @override
  String get reader_image_share => 'Buka lembar pembagian sistem.';

  @override
  String get reader_image_cover => 'Ubah sampul komik ini setelah konfirmasi.';

  @override
  String get reader_image_cover_limit =>
      'Gambar sampul harus lebih kecil dari 5 MB. Menyimpan dan berbagi tetap tersedia.';

  @override
  String get reader_image_action_failed =>
      'Tindakan tersebut tidak dapat dikonfirmasi. Tutup menu ini dan periksa hasilnya sebelum mencoba lagi.';

  @override
  String get reader_settings_book_scope =>
      'Pengaturan ini hanya berlaku untuk komik ini.';

  @override
  String get reader_settings_global_scope =>
      'Pengaturan ini berlaku untuk semua komik dan segera disimpan.';

  @override
  String get reader_filters => 'Filter gambar';

  @override
  String get reader_filter_scope =>
      'Berlaku untuk semua komik. Mengubah tampilan bacaan tanpa mengubah gambar asli.';

  @override
  String get reader_auto_scroll_pause =>
      'Pengguliran dijeda saat pengaturan terbuka.';

  @override
  String get manga_synopsis => 'Sinopsis';

  @override
  String manga_author(String author) {
    return 'Penulis: $author';
  }

  @override
  String get manga_continue_reading => 'Lanjutkan membaca';

  @override
  String get reader_settings_title => 'Pengaturan pembaca';

  @override
  String get reader_picker_book_scope => 'Hanya untuk komik ini';

  @override
  String get reader_picker_global_scope => 'Berlaku untuk semua komik';

  @override
  String get reader_picker_apply_hint =>
      'Ketuk untuk menyimpan dan kembali ke level sebelumnya.';

  @override
  String get reader_scale_fit_screen_hint =>
      'Sesuaikan seluruh halaman di layar';

  @override
  String get reader_scale_stretch_hint => 'Isi area baca';

  @override
  String get reader_scale_fit_width_hint => 'Sesuaikan halaman dengan lebarnya';

  @override
  String get reader_scale_fit_height_hint =>
      'Sesuaikan halaman dengan tingginya';

  @override
  String get source_filter_active => 'Diterapkan';

  @override
  String get source_filter_apply => 'Terapkan filter';

  @override
  String get source_filter_scope => 'Filter hanya berlaku untuk situs web ini.';

  @override
  String get source_filter_apply_hint =>
      'Terapkan filter untuk menggunakan pilihan Anda.';

  @override
  String source_filter_term(String term) {
    String _temp0 = intl.Intl.selectLogic(term, {
      'genres': 'Genre',
      'author': 'Penulis',
      'artist': 'Artis',
      'title': 'Judul',
      'year': 'Tahun',
      'tags': 'Tag',
      'format': 'Bentuknya',
      'publisher': 'Penerbit',
      'relevance': 'Relevansi',
      'rating': 'Peringkat',
      'views': 'Tampilan',
      'random': 'Acak',
      'all': 'Semua',
      'none': 'Tidak ada',
      'action': 'Aksi',
      'adventure': 'Petualangan',
      'comedy': 'Komedi',
      'drama': 'Drama',
      'fantasy': 'Fantasi',
      'romance': 'Romantis',
      'science_fiction': 'Fiksi ilmiah',
      'slice_of_life': 'Sepotong kehidupan',
      'mystery': 'Misteri',
      'horror': 'Horor',
      'psychological': 'Psikologis',
      'historical': 'Bersejarah',
      'sports': 'Olahraga',
      'supernatural': 'Supernatural',
      'school_life': 'Kehidupan sekolah',
      'tragedy': 'Tragedi',
      'shounen': 'Shounen',
      'shoujo': 'Shoujo',
      'seinen': 'Seinen',
      'josei': 'Josei',
      'isekai': 'Isekai',
      'martial_arts': 'Seni bela diri',
      'mecha': 'Mekanisme',
      'music': 'Musik',
      'doujinshi': 'Doujinshi',
      'trending': 'Sedang tren',
      'new': 'Baru',
      'adult_content': 'Konten dewasa',
      'only': 'Hanya',
      'other': '$term',
    });
    return '$_temp0';
  }

  @override
  String get bookshelf_more_display => 'Opsi tampilan lainnya';

  @override
  String get bookshelf_more_display_hint => 'Lencana, sumber dan kategori';

  @override
  String get bookshelf_download_count => 'Jumlah unduhan';

  @override
  String get bookshelf_source_global_hint =>
      'Visibilitas sumber menggunakan preferensi tampilan bersama.';

  @override
  String get bookshelf_select_entries => 'Pilih karya';

  @override
  String get bookshelf_search_options => 'Opsi pencarian';

  @override
  String get bookshelf_empty_hint =>
      'Kumpulkan karya dari sumber atau impor file lokal.';

  @override
  String get bookshelf_no_match_hint =>
      'Coba kata kunci lain atau sesuaikan filter saat ini.';

  @override
  String get bookshelf_clear_query => 'Hapus kata kunci';

  @override
  String get bookshelf_view_selection => 'Melihat karya yang dipilih';

  @override
  String get bookshelf_import_formats =>
      'Pilih file lokal untuk ditambahkan ke rak buku Anda.';

  @override
  String get bookshelf_import_canceled_hint =>
      'Anda dapat memilih lagi setelah membatalkan pemilih file.';

  @override
  String get bookshelf_browse_sources => 'Telusuri sumber';

  @override
  String get bookshelf_empty_title => 'Rak bukumu kosong';

  @override
  String get bookshelf_no_match_title => 'Tidak ada hasil yang cocok';

  @override
  String get bookshelf_mark_watched => 'Markus memperhatikan';

  @override
  String get bookshelf_mark_unwatched => 'Tandai belum ditonton';

  @override
  String get nodelane_account => 'NodeLane';

  @override
  String get nodelane_sign_in => 'Masuk ke NodeLane';

  @override
  String get nodelane_account_intro =>
      'Lihat akun, langganan, dan kuota terjemahan Anda';

  @override
  String get nodelane_login_action => 'Lanjutkan masuk';

  @override
  String get nodelane_login_browser =>
      'Masuk melalui browser sistem, lalu kembali ke aplikasi';

  @override
  String get nodelane_account_id => 'ID Akun';

  @override
  String get nodelane_account_init_error =>
      'Penyimpanan akun tidak tersedia. Mulai ulang aplikasi dan coba lagi.';

  @override
  String get nodelane_account_refresh_error =>
      'Tidak dapat menyegarkan informasi akun';

  @override
  String get nodelane_account_auth_error =>
      'Sesi Anda telah berakhir. Masuk lagi';

  @override
  String get nodelane_account_unknown =>
      'Informasi berlangganan tidak tersedia';

  @override
  String get nodelane_account_current => 'Langganan saat ini';

  @override
  String get nodelane_account_free => 'Akun gratis';

  @override
  String get nodelane_account_no_subscription => 'Tidak ada langganan aktif';

  @override
  String get nodelane_account_active => 'Aktif';

  @override
  String get nodelane_account_expired => 'Kedaluwarsa';

  @override
  String get nodelane_account_expiry => 'Berlaku sampai';

  @override
  String get nodelane_account_renewal => 'Pembaruan';

  @override
  String get nodelane_renewal_auto => 'Perpanjangan otomatis';

  @override
  String get nodelane_renewal_manual => 'Pembaruan manual';

  @override
  String get nodelane_renewal_stopped => 'Perpanjangan otomatis dihentikan';

  @override
  String get nodelane_renewal_gift => 'Hadiah keanggotaan';

  @override
  String get nodelane_renewal_attention =>
      'Periksa status perpanjangan Anda di situs web';

  @override
  String get nodelane_next_billing => 'Tanggal penagihan berikutnya';

  @override
  String get nodelane_billing_unavailable =>
      'Informasi pembaruan tidak tersedia';

  @override
  String get nodelane_manage_account => 'Kelola di situs web';

  @override
  String get nodelane_view_plans => 'Lihat paket berlangganan';

  @override
  String get nodelane_translation_quota => 'Kuota terjemahan';

  @override
  String get nodelane_quota_free => 'Kuota gratis';

  @override
  String get nodelane_quota_subscription => 'Kuota berlangganan';

  @override
  String get nodelane_quota_purchase => 'Kuota yang dibeli';

  @override
  String get nodelane_quota_details => 'Lihat detail kuota';

  @override
  String get nodelane_quota_expanded => 'Detail kuota';

  @override
  String get nodelane_quota_unlimited => 'Tidak terbatas';

  @override
  String get nodelane_quota_not_subscribed => 'Tidak berlangganan';

  @override
  String get nodelane_quota_unknown => 'Tidak tersedia';

  @override
  String get nodelane_quota_used => 'Digunakan';

  @override
  String get nodelane_quota_reserved => 'Sedang berlangsung';

  @override
  String get nodelane_quota_reset => 'Setel ulang berikutnya';

  @override
  String get nodelane_quota_expiry => 'Kedaluwarsa berikutnya';

  @override
  String get nodelane_quota_no_expiry => 'Tidak ada tanggal kadaluwarsa';

  @override
  String get nodelane_quota_reservation_note =>
      'Halaman yang sedang diproses sudah dikurangi dari kuota yang tersedia';

  @override
  String nodelane_quota_available(int count) {
    return '$count halaman tersisa';
  }

  @override
  String nodelane_quota_pages(int count) {
    return '$count halaman';
  }

  @override
  String get nodelane_sign_out => 'Keluar';

  @override
  String get nodelane_sign_out_confirm =>
      'Keluar menjeda terjemahan resmi pada perangkat ini. Perpustakaan dan kemajuan membaca Anda disimpan.';

  @override
  String get settings_search_hint => 'Pengaturan pencarian';

  @override
  String get settings_frequent => 'Sering digunakan';

  @override
  String get settings_reading_translation => 'Membaca dan menerjemahkan';

  @override
  String get settings_app_preferences => 'Preferensi aplikasi';

  @override
  String get settings_data_management => 'Data dan manajemen';

  @override
  String get settings_more_tools => 'Lebih banyak alat';

  @override
  String get settings_more_tools_hint => 'Kategori, statistik dan kalender';

  @override
  String get settings_appearance_interface => 'Penampilan dan antarmuka';

  @override
  String get settings_security_privacy => 'Keamanan dan privasi';

  @override
  String get settings_source_preferences => 'Pengaturan sumber';

  @override
  String get settings_about_help => 'Tentang dan bantuan';

  @override
  String get settings_storage_backup => 'Penyimpanan dan pencadangan';

  @override
  String settings_pending_downloads(int count) {
    return '$count tertunda';
  }

  @override
  String get settings_translation_language => 'Bahasa terjemahan';

  @override
  String get settings_translation_scope =>
      'Digunakan dalam pembaca dan terjemahan halaman web';

  @override
  String get settings_immediate_choice => 'Perubahan segera berlaku';

  @override
  String get settings_translation_init_error =>
      'Pengaturan terjemahan tidak tersedia. Mulai ulang aplikasi dan coba lagi.';

  @override
  String get settings_local_cache => 'Tembolok lokal';

  @override
  String get settings_chapter_cache => 'Cache bab dan episode';

  @override
  String get settings_cover_cache => 'Tutupi tembolok';

  @override
  String get settings_translation_cache => 'Cache gambar yang diterjemahkan';

  @override
  String get settings_translation_cache_hint =>
      'Simpan catatan terjemahan dan ambil kembali gambar terjemahan bila diperlukan';

  @override
  String get settings_cache_clear => 'Jelas';

  @override
  String get settings_translation_cache_done =>
      'Cache gambar yang diterjemahkan dibersihkan; catatan terjemahan disimpan';

  @override
  String settings_cache_confirmation(String name) {
    return 'Hapus $name? Konten yang di-cache dapat diambil kembali. Entri perpustakaan akan disimpan.';
  }

  @override
  String get settings_advanced_options => 'Opsi lanjutan';

  @override
  String get settings_manga_reader => 'Pembaca Manga';

  @override
  String get settings_novel_reader => 'Pembaca Novel';

  @override
  String get settings_downloads => 'Unduh pengaturan';

  @override
  String get onboarding_welcome => 'Selamat datang di';

  @override
  String get onboarding_reading_content => 'Membaca konten';

  @override
  String get onboarding_choose_one => 'Pilih setidaknya satu';

  @override
  String get onboarding_restore_hint =>
      'Pulihkan perpustakaan Anda dari cadangan';

  @override
  String get onboarding_browse_hint =>
      'Temukan judul di situs web yang didukung';

  @override
  String get onboarding_import_folder => 'Impor folder lokal';

  @override
  String get onboarding_import_folder_hint =>
      'Baca manga, novel, dan anime di perangkat Anda';

  @override
  String get onboarding_third_party => 'Tambahkan repositori pihak ketiga';

  @override
  String get onboarding_third_party_hint =>
      'Gunakan alamat repositori yang sudah Anda miliki';

  @override
  String get onboarding_repository_hint =>
      'Masukkan alamat yang disediakan oleh repositori.';

  @override
  String get onboarding_repository_address => 'Alamat';

  @override
  String get onboarding_repository_address_hint => 'Masukkan alamat repositori';

  @override
  String get onboarding_add_repository => 'Tambahkan repositori';

  @override
  String get onboarding_start => 'Mulailah';

  @override
  String get onboarding_open_library => 'Buka perpustakaan';

  @override
  String get onboarding_view_imports => 'Lihat konten yang diimpor';

  @override
  String get onboarding_view_folders => 'Lihat folder';

  @override
  String get notice_backup_created => 'Cadangan dibuat';

  @override
  String get notice_backup_ready => 'Simpan atau bagikan file cadangan.';

  @override
  String get notice_backup_restored => 'Cadangan dipulihkan';

  @override
  String get notice_backup_unsupported => 'Format cadangan ini tidak didukung.';

  @override
  String get notice_verification_required => 'Verifikasi situs web diperlukan';

  @override
  String get notice_verification_hint =>
      'Selesaikan verifikasi untuk melanjutkan penjelajahan.';

  @override
  String get notice_verify => 'Verifikasi situs web';

  @override
  String get notice_action_incomplete =>
      'Aksinya belum selesai. Periksa hasilnya sebelum mencoba lagi.';

  @override
  String get notice_library_updating => 'Memperbarui perpustakaan';

  @override
  String notice_library_progress(Object current, Object total) {
    return 'Memeriksa judul $current / $total';
  }

  @override
  String get notice_library_failed => 'Beberapa judul tidak dapat diperbarui';

  @override
  String get notice_import_completed => 'Impor selesai';

  @override
  String get notice_operation_incomplete => 'Tindakan tidak selesai';

  @override
  String get subtitle_service => 'Layanan subtitle online';

  @override
  String get subtitle_service_mode => 'Sumber subtitle';

  @override
  String get subtitle_service_disabled =>
      'Mati · hapus kredensial yang disimpan';

  @override
  String get subtitle_personal_key => 'Kunci Wyzie saya';

  @override
  String get subtitle_custom_service => 'Layanan subtitle saya';

  @override
  String get subtitle_key => 'Wyzie API Kunci';

  @override
  String get subtitle_key_hint =>
      'Masukkan kunci Wyzie Anda sendiri. Itu tetap ada di perangkat ini dan tidak disertakan dalam cadangan aplikasi.';

  @override
  String get subtitle_get_key => 'Dapatkan kunci pribadi';

  @override
  String get subtitle_service_address => 'Pencarian subtitle URL';

  @override
  String get subtitle_service_token => 'Token akses layanan (opsional)';

  @override
  String get subtitle_custom_hint =>
      'Gunakan HTTPS pencarian URL lengkap dari layanan Wyzie-compatible, termasuk jalurnya (misalnya, /search). Masukkan token akses hanya jika layanan Anda memerlukannya.';

  @override
  String get subtitle_service_off_hint =>
      'Pencarian subtitle online tidak aktif. Subtitle yang tersemat, disediakan sumber, dan lokal tetap tersedia.';

  @override
  String get subtitle_setup_required =>
      'Pilih layanan subtitle sebelum mencari.';

  @override
  String get subtitle_invalid_key => 'Masukkan kunci tanpa spasi.';

  @override
  String get subtitle_invalid_address =>
      'Gunakan HTTPS URL lengkap tanpa kueri, fragmen, atau kredensial yang disematkan.';

  @override
  String get subtitle_invalid_token => 'Token akses tidak boleh berisi spasi.';

  @override
  String get subtitle_storage_failed =>
      'Tidak dapat membaca atau menyimpan pengaturan subtitle. Silakan coba lagi.';

  @override
  String get subtitle_auth_failed =>
      'Layanan subtitle menolak akses. Periksa kunci atau token layanan Anda.';

  @override
  String get subtitle_quota_exhausted =>
      'Kuota layanan subtitle telah habis. Periksa akun Anda dengan layanan itu.';

  @override
  String get subtitle_network_failed =>
      'Tidak dapat menjangkau layanan subtitle. Silakan coba lagi.';

  @override
  String get subtitle_response_invalid =>
      'Layanan subtitle mengembalikan respons atau file yang tidak didukung.';

  @override
  String get detail_loading_chapters => 'Memuat bab…';

  @override
  String get reader_opening_chapter => 'Bab pembuka';

  @override
  String get reader_open_chapter => 'Buka bab';

  @override
  String get reader_loading_pages => 'Mendapatkan gambar bab…';

  @override
  String get reader_loading_pages_hint =>
      'Membaca akan dimulai secara otomatis jika sudah siap.';

  @override
  String get reader_loading_failed => 'Tidak dapat memuat bab ini';

  @override
  String get reader_loading_retry_hint => 'Periksa koneksi Anda dan coba lagi.';

  @override
  String get reader_no_pages => 'Tidak ada gambar yang ditemukan untuk bab ini';

  @override
  String get reader_loading_previous => 'Memuat bab sebelumnya…';

  @override
  String get reader_previous_failed => 'Tidak dapat memuat bab sebelumnya';

  @override
  String get reader_reached_start => 'Anda telah mencapai bab pertama';

  @override
  String get reader_loading_next => 'Memuat bab berikutnya…';

  @override
  String get reader_next_failed => 'Tidak dapat memuat bab berikutnya';

  @override
  String get reader_image_loading => 'Memuat gambar…';

  @override
  String get reader_image_failure_hint =>
      'Anda dapat terus membaca halaman lainnya.';

  @override
  String get comic_paged => 'Halaman demi halaman';

  @override
  String get comic_scroll => 'Gulir ke bawah';

  @override
  String get comic_book_scope =>
      'Hanya berlaku untuk buku ini · perubahan segera simpan';

  @override
  String get comic_defaults_title => 'Default & kebiasaan';

  @override
  String get comic_defaults_hint =>
      'Default berlaku untuk bidang yang belum Anda sesuaikan untuk sebuah buku.';

  @override
  String get comic_habits_hint => 'Kebiasaan ini berlaku pada setiap komik.';

  @override
  String get comic_turn => 'Geser ke halaman berikutnya';

  @override
  String get comic_left => 'Kiri';

  @override
  String get comic_right => 'Benar';

  @override
  String get comic_up => 'Naik';

  @override
  String get comic_fit => 'Kesesuaian halaman';

  @override
  String get comic_fit_contain => 'Seluruh halaman';

  @override
  String get comic_fit_width => 'Lebar pas';

  @override
  String get comic_fit_height => 'Tinggi pas';

  @override
  String get comic_layout => 'Tata letak halaman';

  @override
  String get comic_auto => 'Otomatis';

  @override
  String get comic_layout_hint =>
      'Otomatis menunjukkan penyebaran ketika lebarnya cukup.';

  @override
  String get comic_width => 'Lebar konten';

  @override
  String get comic_full => 'Penuh';

  @override
  String get comic_comfortable => 'Nyaman';

  @override
  String get comic_narrow => 'Sempit';

  @override
  String get comic_gap => 'Spasi halaman';

  @override
  String get comic_no_gap => 'Mulus';

  @override
  String get comic_small_gap => 'Kecil';

  @override
  String get comic_image_title => 'Sempurnakan gambar';

  @override
  String get comic_image_hint => 'Pangkas dan nada hanya memengaruhi buku ini.';

  @override
  String get comic_wide => 'Halaman lebar';

  @override
  String get comic_intact => 'Tetap utuh';

  @override
  String get comic_split => 'Berpisah';

  @override
  String get comic_rotate => 'Putar';

  @override
  String get comic_wide_hint =>
      'Pemisahan mengikuti arah pergantian halaman. Berlaku untuk membaca satu halaman.';

  @override
  String get comic_cover => 'Satu sampul per bab';

  @override
  String get comic_effects_reset => 'Reset penyesuaian gambar';

  @override
  String get comic_book_reset => 'Kembalikan default buku';

  @override
  String get comic_book_reset_hint =>
      'Menghapus pengaturan bacaan khusus buku ini. Terjemahan tidak berubah.';

  @override
  String get comic_canvas => 'Latar belakang pembaca';

  @override
  String get comic_system => 'Sistem';

  @override
  String get comic_black => 'Hitam';

  @override
  String get comic_gray => 'Abu-abu';

  @override
  String get comic_paper => 'Makalah';

  @override
  String get comic_tap => 'Ketuk untuk membalik halaman';

  @override
  String get comic_tap_hint =>
      'Ketuk tepinya untuk bergerak; ketuk bagian tengah untuk menampilkan kontrol.';

  @override
  String get comic_scroll_start => 'Mulai gulir otomatis';

  @override
  String get comic_scroll_pause => 'Jeda gulir otomatis';

  @override
  String get comic_scroll_speed => 'Kecepatan gulir';

  @override
  String get comic_scroll_hint =>
      'Dimulai saat panel ini ditutup. Jeda saat aplikasi meninggalkan latar depan.';

  @override
  String get comic_save_failed => 'Tidak dapat menyimpan. Silakan coba lagi.';

  @override
  String get comic_reading => 'Membaca';

  @override
  String get comic_chapter_habits_hint =>
      'Kebiasaan daftar bab berlaku untuk semua buku.';

  @override
  String get browser_title => 'Peramban';

  @override
  String get translation_image_display => 'Tampilan gambar';

  @override
  String get translation_display_hint =>
      'Tampilkan terjemahan yang ada terlebih dahulu. Simpan yang asli bila tidak ada terjemahan yang tersedia.';

  @override
  String get translation_sign_in_required =>
      'Masuk untuk mengaktifkan terjemahan';

  @override
  String get translation_sign_in_hint =>
      'Setelah masuk, alihkan ke gambar yang diterjemahkan untuk menerjemahkan secara otomatis.';

  @override
  String get translation_automatic => 'Terjemahan otomatis';

  @override
  String get translation_original_hint =>
      'Menampilkan yang asli. Beralih ke gambar yang diterjemahkan untuk menerjemahkan secara otomatis.';

  @override
  String get translation_window_hint =>
      'Memproses gambar saat ini dan yang akan datang hanya sambil menampilkan terjemahan.';

  @override
  String get translation_channel => 'Saluran terjemahan';

  @override
  String get translation_no_images =>
      'Belum ada gambar yang dapat diterjemahkan di halaman ini';

  @override
  String get translation_waiting_image => 'Menunggu gambar saat ini';

  @override
  String translation_progress(int complete, int total, int issues) {
    String _temp0 = intl.Intl.pluralLogic(
      issues,
      locale: localeName,
      other: ' · Gambar $issues perlu perhatian',
      one: ' · 1 gambar perlu perhatian',
      zero: '',
    );
    return 'Selesai $complete / $total gambar$_temp0';
  }

  @override
  String get translation_image_actions_hint =>
      'Sentuh dan tahan gambar untuk tindakan lebih lanjut, termasuk menerjemahkannya lagi.';

  @override
  String get translation_title => 'Terjemahan manga';

  @override
  String get translation_system_sign_in =>
      'Masuk menggunakan browser sistem Anda';

  @override
  String get translation_target_language => 'Bahasa sasaran';

  @override
  String get translation_clear_cache => 'Hapus cache gambar yang diterjemahkan';

  @override
  String get translation_cache_hint =>
      'Simpan catatan terjemahan dan ambil kembali hasilnya bila diperlukan.';

  @override
  String get translation_saved_read_failed =>
      'Tidak dapat memuat terjemahan yang disimpan';

  @override
  String get translation_read_failed => 'Tidak dapat memuat gambar terjemahan';

  @override
  String get operation_retry => 'Aksinya belum selesai. Silakan coba lagi.';

  @override
  String get translation_original => 'Asli';

  @override
  String get translation_translated => 'Diterjemahkan';

  @override
  String get translation_regenerate_image => 'Terjemahkan lagi gambar ini';

  @override
  String get translation_read_image => 'Muat ulang gambar yang diterjemahkan';

  @override
  String get translation_image_actions => 'Tindakan gambar lainnya';

  @override
  String get translation_processing => 'Pemrosesan';

  @override
  String get translation_reading => 'Memuat gambar yang diterjemahkan';

  @override
  String get translation_waiting => 'Menunggu terjemahan';

  @override
  String get translation_preparing => 'Mempersiapkan terjemahan';

  @override
  String get translation_uploading => 'Mengunggah yang asli';

  @override
  String get translation_running => 'Menerjemahkan';

  @override
  String get translation_uncertain => 'Status memerlukan verifikasi';

  @override
  String get translation_failed => 'Terjemahan gagal';

  @override
  String get translation_verify => 'Verifikasi';

  @override
  String get translation_reread => 'Muat ulang';

  @override
  String get browser_back => 'Kembali';

  @override
  String get browser_translation => 'Terjemahan halaman web';

  @override
  String get browser_new_tab_action => 'Buka tab baru';

  @override
  String get browser_current_tab => 'Saat ini';

  @override
  String get browser_close_tab => 'Tutup tab';

  @override
  String get browser_new_tab => 'Tab baru';

  @override
  String get browser_page => 'Halaman web';

  @override
  String get browser_unopened => 'Belum ada halaman yang dibuka';

  @override
  String get browser_address_hint => 'Masukkan atau tempel URL';

  @override
  String get browser_invalid_address => 'Masukkan URL yang valid';

  @override
  String get browser_clear_address => 'Hapus URL';

  @override
  String get browser_paste_address => 'Tempel URL';

  @override
  String get browser_open_address => 'Buka URL';

  @override
  String browser_tab_count(int count) {
    return 'Tab · $count';
  }

  @override
  String get browser_load_failed => 'Tidak dapat membuka halaman ini';

  @override
  String get browser_load_failed_hint => 'Periksa koneksi Anda dan URL.';

  @override
  String get browser_edit_address => 'Sunting URL';

  @override
  String get browser_clear_cookies_confirm =>
      'Hapus sesi masuk untuk semua situs web?';

  @override
  String get browser_clear_cookies_hint =>
      'Situs web di semua tab mungkin mengharuskan Anda masuk lagi.';

  @override
  String get browser_clear_cookies_action => 'Hapus sesi masuk';

  @override
  String get browser_tab_limit =>
      'Anda dapat membuka hingga 12 tab. Tutup satu dulu.';

  @override
  String get browser_forward => 'Maju';

  @override
  String get browser_clear_all_cookies => 'Hapus semua sesi masuk situs web';

  @override
  String get browser_clear_failed =>
      'Tidak dapat menghapus sesi. Silakan coba lagi.';

  @override
  String get browser_save_failed =>
      'Tidak dapat menyimpan tab. Silakan coba lagi.';

  @override
  String get browser_tabs_full => '12 tab sudah terbuka';

  @override
  String get browser_no_tabs => 'Belum ada tab yang terbuka';

  @override
  String get browser_close_failed =>
      'Tidak dapat menyimpan tab. Ketuk tutup lagi untuk mencoba lagi.';

  @override
  String get source_pinned_websites => 'Situs web yang disematkan';

  @override
  String get manage => 'Kelola';

  @override
  String get translation_settings_hint =>
      'Terjemahan otomatis, bahasa target, dan saluran';

  @override
  String get translation_show_original => 'Ketuk untuk menampilkan yang asli';

  @override
  String get translation_show_translated =>
      'Ketuk untuk menampilkan terjemahannya';

  @override
  String get source_display => 'Tampilan';

  @override
  String get source_cover_title => 'Sampul dan judul';

  @override
  String get source_cover_only => 'Penutup saja';

  @override
  String get source_save_search => 'Simpan pencarian saat ini';

  @override
  String get source_saved_searches => 'Pencarian tersimpan';

  @override
  String get source_website_info => 'Informasi situs web';

  @override
  String source_saved_search_title(String title) {
    return '$title · Ketuk untuk mencari';
  }

  @override
  String get action_done => 'Selesai';

  @override
  String source_search_keyword(String query) {
    return 'Kata Kunci: $query';
  }

  @override
  String get source_no_saved_searches => 'Belum ada pencarian tersimpan';

  @override
  String get source_save_search_hint =>
      'Cari kata kunci, lalu simpan dari tindakan situs web.';

  @override
  String get source_saved_search_scope =>
      'Kata kunci disimpan hanya untuk situs web ini.';

  @override
  String get source_search_here => 'Cari judul di website ini';

  @override
  String get source_filter_results => 'Hasil yang difilter';

  @override
  String get source_search_results => 'Hasil pencarian';

  @override
  String get source_return_popular => 'Kembali ke populer';

  @override
  String get source_popular_titles => 'Judul populer';

  @override
  String get source_no_titles => 'Tidak ditemukan judul yang cocok';

  @override
  String get source_no_titles_hint =>
      'Ubah kata kunci atau filter Anda, atau kembali ke judul populer.';

  @override
  String get source_load_more_failed =>
      'Tidak dapat memuat lagi. Silakan coba lagi.';

  @override
  String get source_load_pull_retry =>
      'Tidak dapat memuat situs web ini. Tarik ke bawah untuk mencoba lagi.';

  @override
  String get source_clear_failed =>
      'Tidak dapat menyelesaikan penyelesaian. Silakan coba lagi.';

  @override
  String get source_uninstall_failed =>
      'Tidak dapat menyelesaikan pencopotan pemasangan. Silakan coba lagi.';

  @override
  String get source_details => 'Detail sumber';

  @override
  String get source_repository_website => 'Situs web repositori';

  @override
  String get source_provided_settings => 'Pengaturan disediakan oleh sumber';

  @override
  String get source_advanced_actions => 'Tindakan lanjutan';

  @override
  String get source_edit_metadata => 'Edit informasi sumber';

  @override
  String get source_clear_cookies => 'Hapus cookie untuk situs web ini';

  @override
  String get source_clear_cookies_hint =>
      'Anda mungkin perlu masuk lagi pada kunjungan berikutnya.';

  @override
  String get source_uninstall => 'Copot pemasangan sumber';

  @override
  String get source_settings_save_failed =>
      'Penghematan belum selesai. Buka kembali pengaturan sumber untuk memeriksa.';

  @override
  String get repository_third_party => 'Repositori pihak ketiga';

  @override
  String get repository_refresh_failed =>
      'Tidak dapat menyegarkan katalog. Konten cache disimpan. Silakan coba lagi.';

  @override
  String get repository_show_sources => 'Tampilkan sumber dari repositori ini';

  @override
  String get repository_copy_catalog => 'Salin tautan katalog';

  @override
  String get repository_remove => 'Hapus repositori';

  @override
  String get repository_remove_hint =>
      'Simpan sumber yang terpasang dan hapus entri katalog yang dihapus.';

  @override
  String get repository_empty =>
      'Belum ada repositori pihak ketiga yang ditambahkan';

  @override
  String get repository_built_in => 'Katalog resmi bawaan';

  @override
  String get repository_hidden => 'Tersembunyi';

  @override
  String get repository_refreshing => 'Menyegarkan…';

  @override
  String get repository_refresh => 'Segarkan katalog';

  @override
  String get repository_manage_hint =>
      'Kelola dari mana sumber pihak ketiga diunduh.';

  @override
  String get repository_invalid_address =>
      'Masukkan HTTP atau HTTPS URL yang valid';

  @override
  String get repository_already_added => 'Repositori ini telah ditambahkan';

  @override
  String get repository_unrecognized =>
      'Katalog yang didukung tidak ditemukan. Periksa tautannya dan coba lagi.';

  @override
  String get repository_read_failed =>
      'Tidak dapat membaca katalog. Silakan coba lagi.';

  @override
  String get repository_save_failed =>
      'Penghematan belum selesai. Periksa daftar repositori Anda.';

  @override
  String get repository_paste_hint =>
      'Tempel tautan katalog repositori pihak ketiga';

  @override
  String get repository_address => 'URL';

  @override
  String get repository_paste_link => 'Tempel tautan';

  @override
  String repository_recognized(String type) {
    return '$type · Katalog dikenali';
  }

  @override
  String get repository_choose_sources_hint =>
      'Setelah menambahkan repositori, pilih sumber yang Anda perlukan.';

  @override
  String get search_scope => 'Ruang lingkup pencarian';

  @override
  String get search_scope_hint => 'Pilih situs web yang akan dicari';

  @override
  String search_websites_action(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Telusuri situs web $count',
      one: 'Cari 1 situs web',
    );
    return '$_temp0';
  }

  @override
  String get search_find_website => 'Temukan situs web';

  @override
  String search_selected_websites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count situs web dipilih',
      one: '1 situs web dipilih',
    );
    return '$_temp0';
  }

  @override
  String get action_clear => 'Jelas';

  @override
  String get search_deselect_results => 'Batalkan pilihan situs web yang cocok';

  @override
  String get search_select_results => 'Pilih situs web yang cocok';

  @override
  String get search_no_websites_hint =>
      'Tidak ada situs web yang cocok. Coba nama atau bahasa lain.';

  @override
  String get search_select_website_hint =>
      'Pilih setidaknya satu situs web untuk dicari.';

  @override
  String get search_start_title => 'Masukkan kata kunci untuk menemukan judul';

  @override
  String get search_start_hint =>
      'Telusuri beberapa situs web sekaligus dan tampilkan judul yang cocok.';

  @override
  String get search_empty_scope =>
      'Tidak ada situs web yang dapat dicari dalam cakupan ini';

  @override
  String get search_empty_scope_hint =>
      'Beralih ke semua situs web atau pilih situs web yang akan dicari.';

  @override
  String search_result_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hasil',
      one: '1 hasil',
    );
    return '$_temp0';
  }

  @override
  String get search_titles => 'Cari judul';

  @override
  String get search_actions => 'Tindakan pencarian';

  @override
  String get search_details => 'Detail pencarian';

  @override
  String get search_title_hint => 'Cari berdasarkan judul';

  @override
  String get search_searching => 'Mencari';

  @override
  String search_found_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ditemukan hasil $count',
      one: 'Menemukan 1 hasil',
    );
    return '$_temp0';
  }

  @override
  String get search_no_results => 'Tidak ada hasil yang cocok';

  @override
  String get search_failed => 'Pencarian gagal';

  @override
  String search_found_titles(int count, int websites) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count judul ditemukan',
      one: '1 judul ditemukan',
    );
    String _temp1 = intl.Intl.pluralLogic(
      websites,
      locale: localeName,
      other: '$websites situs web',
      one: '1 situs web',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get search_finding_titles => 'Menemukan judul';

  @override
  String get search_complete => 'Pencarian selesai';

  @override
  String get search_in_progress => 'Mencari';

  @override
  String get search_finding_related => 'Mencari judul yang cocok…';

  @override
  String get search_no_results_yet => 'Belum ada hasil pencarian';

  @override
  String get search_no_matching_titles => 'Tidak ditemukan judul yang cocok';

  @override
  String get search_results_appear_hint =>
      'Hasil akan muncul di sini saat ditemukan.';

  @override
  String get search_failed_websites_hint =>
      'Beberapa situs web tidak dapat menyelesaikan pencarian. Coba lagi di detail pencarian.';

  @override
  String get search_change_keywords_hint =>
      'Coba kata kunci yang lebih pendek atau cari lebih banyak situs web.';

  @override
  String get search_view_details => 'Lihat detail pencarian';

  @override
  String get search_adjust_scope => 'Sesuaikan cakupan pencarian';

  @override
  String search_query_websites(String query, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count situs web',
      one: '1 situs web',
    );
    return '$query · $_temp0';
  }

  @override
  String search_completed_count(int completed, int total) {
    return 'Selesai $completed / $total';
  }

  @override
  String get search_retry_website_hint =>
      'Coba lagi situs web yang gagal satu per satu';

  @override
  String source_selected_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item dipilih',
      one: '1 item dipilih',
    );
    return '$_temp0';
  }

  @override
  String get search_languages => 'Cari bahasa';

  @override
  String get source_deselect => 'Batalkan pilihan';

  @override
  String get source_select => 'Pilih sumber';

  @override
  String get source_multilingual => 'Multibahasa';

  @override
  String get source_language_unknown => 'Bahasa tidak ditentukan';

  @override
  String get source_adult_content => 'Berisi 18+ konten';

  @override
  String get source_classification_unknown => 'Klasifikasi tidak ditentukan';

  @override
  String source_more_classifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lihat semua informasi sumber, $count kategori lainnya',
      one: 'Lihat semua informasi sumber, 1 kategori lagi',
    );
    return '$_temp0';
  }

  @override
  String get source_loading_website => 'Memuat situs web';

  @override
  String get source_unpin => 'Lepas sematan';

  @override
  String get source_pin => 'Sematkan';

  @override
  String get source_open => 'Buka';

  @override
  String get source_metadata_hint =>
      'Informasi berasal dari katalog sumber. Kategori menggambarkan konten yang dicakup oleh situs web.';

  @override
  String get source_region => 'Wilayah';

  @override
  String get source_format => 'Bentuknya';

  @override
  String get source_creation => 'Penciptaan';

  @override
  String get source_unspecified => 'Tidak ditentukan';

  @override
  String get source_pricing => 'Penetapan harga';

  @override
  String get source_region_jp => 'Komik Jepang';

  @override
  String get source_region_kr => 'Komik Korea';

  @override
  String get source_region_cn => 'Komik Tiongkok';

  @override
  String get source_region_hk_tw => 'Komik Hong Kong dan Taiwan';

  @override
  String get source_region_western => 'Komik Barat';

  @override
  String get source_region_other => 'Daerah lain';

  @override
  String get source_format_page => 'Komik berhalaman';

  @override
  String get source_format_vertical => 'Komik vertikal';

  @override
  String get source_format_strip => 'Komik strip';

  @override
  String get source_creation_original => 'Asli';

  @override
  String get source_creation_fan => 'Kipas bekerja';

  @override
  String get source_free_watch => 'Gratis untuk ditonton';

  @override
  String get source_free_read => 'Gratis untuk dibaca';

  @override
  String get source_partial_paid => 'Dibayar sebagian';

  @override
  String get source_paid_watch => 'Penayangan berbayar';

  @override
  String get source_paid_read => 'Bacaan berbayar';

  @override
  String get source_pricing_unknown => 'Harga tidak ditentukan';

  @override
  String get source_language_filter => 'Filter menurut bahasa';

  @override
  String get source_language_filter_hint =>
      'Filter katalog ini saja. Sumber yang diinstal tidak terpengaruh.';

  @override
  String get source_all_languages => 'Semua bahasa';

  @override
  String get action_apply => 'Lamar';

  @override
  String get source_load_retry =>
      'Tidak dapat memuat situs web ini. Silakan coba lagi.';

  @override
  String get source_catalog_refresh_failed =>
      'Tidak dapat menyegarkan katalog. Konten saat ini disimpan. Tarik ke bawah untuk mencoba lagi.';

  @override
  String source_uninstall_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Copot pemasangan sumber $count?',
      one: 'Hapus instalasi 1 sumber?',
    );
    return '$_temp0';
  }

  @override
  String get source_uninstall_selected_hint =>
      'Copot pemasangan sumber yang dipilih dan hapus pengaturannya. Simpan judul dan unduhan perpustakaan.';

  @override
  String source_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tindakan gagal untuk sumber $count.',
      one: 'Tindakan gagal untuk 1 sumber.',
    );
    return '$_temp0 Seleksi dilanjutkan. Silakan coba lagi.';
  }

  @override
  String get source_latest_content => 'Konten terbaru';

  @override
  String get source_actions => 'Tindakan sumber';

  @override
  String get source_bulk_manage => 'Kelola berbagai sumber';

  @override
  String get source_update_installed => 'Perbarui sumber yang diinstal';

  @override
  String get source_no_matching_websites => 'Tidak ada situs web yang cocok';

  @override
  String get source_no_websites => 'Tidak ada situs web yang tersedia';

  @override
  String get source_search_installed_hint =>
      'Cari judul di sumber yang diinstal';

  @override
  String get source_global_search => 'Cari di seluruh sumber';

  @override
  String get source_manage_repositories => 'Kelola repositori';

  @override
  String get source_view_third_party => 'Lihat sumber pihak ketiga';

  @override
  String get source_catalog_load_failed =>
      'Tidak dapat memuat katalog. Tarik ke bawah untuk mencoba lagi.';

  @override
  String get source_all_websites => 'Semua situs web';

  @override
  String get source_available => 'Tersedia untuk dipasang';

  @override
  String get source_third_party => 'Pihak ketiga';

  @override
  String get source_name_or_title => 'Nama atau judul situs web';

  @override
  String get view_all => 'Lihat semua';

  @override
  String get search_searching_ellipsis => 'Mencari…';

  @override
  String onboarding_untested_content(String type) {
    return '$type · Belum diuji';
  }

  @override
  String get onboarding_untested => 'Belum teruji';

  @override
  String get source_custom_scope => 'Adat';

  @override
  String get source_custom_websites => 'Situs web terpilih';

  @override
  String get tv_hidden_library_hint =>
      'Setiap judul berada dalam kategori tersembunyi.\nTahan OK pada “Semua” untuk menampilkan satu.';

  @override
  String get tv_no_matching_anime => 'Tidak ada anime yang cocok';

  @override
  String tv_no_matching_category(String category) {
    return 'Tidak ada anime yang cocok di “$category”';
  }

  @override
  String get tv_filtered_empty_hint =>
      'Tidak ada anime yang cocok dengan filter saat ini.\nUbah dari tombol di samping pencarian.';

  @override
  String get tv_new_episodes => 'Episode Baru';

  @override
  String get tv_recently_added => 'Baru Ditambahkan';

  @override
  String get tv_empty_category_hint =>
      'Belum ada anime dalam kategori ini.\nTambahkan judul dari halaman detail judul.';

  @override
  String get tv_empty_library => 'Perpustakaan animemu kosong';

  @override
  String get tv_empty_library_hint =>
      'Tambahkan anime dari Telusuri untuk memenuhi rumah Anda';

  @override
  String get tv_browse_anime => 'Telusuri anime';

  @override
  String tv_new_count(int count) {
    return '$count baru';
  }

  @override
  String tv_category_hidden(String category) {
    return 'Sembunyikan “$category” · tahan OK pada “Semua” untuk memperlihatkan';
  }

  @override
  String get tv_no_hidden_categories => 'Tidak ada kategori tersembunyi';

  @override
  String get import_torrent_file => 'impor berkas .torrent';

  @override
  String get import_video_formats => '.mp4, .mkv, .avi, dan banyak lagi';

  @override
  String get cloudflare_proxy_optional => 'Opsional FlareSolverr / Byparr URL';

  @override
  String get tv_home_layout_hint =>
      'Beranda anime berbasis baris (Lanjutkan · Episode Baru · kategori) alih-alih kotak datar';

  @override
  String get tv_hide_libraries_hint =>
      'Sembunyikan perpustakaan manga & novel (diaktifkan secara default di TV)';

  @override
  String get anime_only_hint =>
      'Sembunyikan manga & novel di seluruh aplikasi. Matikan untuk menampilkan semuanya.';

  @override
  String get audio_auto_safe => 'Aman otomatis';

  @override
  String get tv_player_hint =>
      'Aktif: pemutar TV khusus.  Mati: pemutar asli (desktop).';

  @override
  String get release_open_failed => 'Tidak dapat membuka rilis';

  @override
  String get tv_replay => 'Putar ulang';

  @override
  String get tv_no_episodes => 'Belum ada episode';

  @override
  String get tracker_continue_series => 'Lanjutkan menonton serial';

  @override
  String get tracker_watchlist_series => 'Seri daftar pantauan';

  @override
  String get tracker_continue_movies => 'Lanjutkan menonton film';

  @override
  String get tracker_watchlist_movies => 'Film daftar tontonan';

  @override
  String get tracker_trending_series => 'Seri Sedang Tren';

  @override
  String get tracker_trending_movies => 'Film Trending';

  @override
  String get tracker_popular_series => 'Serial Populer';

  @override
  String get tracker_popular_movies => 'Film Populer';

  @override
  String get tracker_top_series => 'Seri Teratas (Sepanjang Masa)';

  @override
  String get tracker_top_movies => 'Film Teratas (Sepanjang Masa)';

  @override
  String get tracker_airing_series => 'Serial Tayang';

  @override
  String get tracker_airing_anime => 'Menayangkan Anime';

  @override
  String get tracker_popular_anime => 'Anime Populer';

  @override
  String get tracker_upcoming_anime => 'Anime Mendatang';

  @override
  String get tracker_popular_manga => 'Manga Populer';

  @override
  String get tracker_top_manga => 'Manga Teratas';

  @override
  String get tracker_top_manhwa => 'Manhwa Teratas';

  @override
  String get tracker_top_manhua => 'Manhua Teratas';

  @override
  String get tracker_latest_anime => 'Anime Terbaru';

  @override
  String get tracker_best_anime => 'Anime dengan Nilai Terbaik';

  @override
  String get tracker_latest_manga => 'Manga Terbaru';

  @override
  String get tracker_best_manga => 'Manga dengan Nilai Terbaik';

  @override
  String get tracker_trending_anime => 'Anime yang Sedang Tren';

  @override
  String get tracker_upcoming_manga => 'Manga Mendatang';

  @override
  String get tracker_trending_manga => 'Manga yang Sedang Tren';

  @override
  String selection_progress(int selected, int total) {
    return '$selected/$total dipilih';
  }

  @override
  String get source_code_editor => 'Editor Kode';

  @override
  String get source_code_execute => 'Jalankan';

  @override
  String get source_console_logs => 'Log Konsol';

  @override
  String get source_no_logs => 'Belum ada log';

  @override
  String get source_updated_successfully => 'Sumber berhasil diperbarui';

  @override
  String get source_obsolete => 'Usang';

  @override
  String player_seek_forward_seconds(int seconds) {
    return 'Maju $seconds detik';
  }

  @override
  String player_seek_backward_seconds(int seconds) {
    return 'Cari mundur $seconds detik';
  }

  @override
  String get player_autoplay_on => 'Putar otomatis episode berikutnya: aktif';

  @override
  String get player_autoplay_off => 'Putar otomatis episode berikutnya: mati';

  @override
  String get player_no_other_quality => 'Tidak ada kualitas lain';

  @override
  String get player_no_subtitles => 'Tidak ada subtitle';

  @override
  String get player_no_audio_tracks => 'Tidak ada trek audio';

  @override
  String get player_seek_forward => 'Majulah';

  @override
  String get player_seek_backward => 'Carilah kebelakang';

  @override
  String player_seconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds detik',
      one: '1 detik',
    );
    return '$_temp0';
  }

  @override
  String get subtitle_preview => 'Lorem ipsum dolor duduk amet';

  @override
  String get subtitle_style => 'Gaya';

  @override
  String get translation_official_channel => 'NodeLane Resmi';

  @override
  String get translation_auth_required =>
      'Masuk ke akun terjemahan Anda terlebih dahulu.';

  @override
  String get translation_source_changed =>
      'Gambar aslinya berubah. Silakan muat ulang.';

  @override
  String get translation_source_missing =>
      'Gambar asli saat ini tidak tersedia.';

  @override
  String get translation_resource_limit =>
      'Gambar ini melebihi batas pemrosesan perangkat. Yang asli disimpan.';

  @override
  String get translation_storage_full =>
      'Penyimpanan terjemahan penuh. Hapus gambar terjemahan terlebih dahulu.';

  @override
  String get translation_invalid_image =>
      'Format atau konten gambar tidak valid.';

  @override
  String get translation_unsupported_image =>
      'Terjemahan tidak didukung untuk gambar ini. Yang asli disimpan.';

  @override
  String get translation_invalid_result =>
      'Validasi gambar yang diterjemahkan gagal. Silakan muat ulang.';

  @override
  String get translation_result_unavailable =>
      'Gambar yang diterjemahkan tidak tersedia. Silakan muat ulang.';

  @override
  String get translation_result_expired =>
      'Gambar yang diterjemahkan kedaluwarsa. Tolong terjemahkan lagi.';

  @override
  String get translation_analysis_too_large =>
      'Ada terlalu banyak konten gambar untuk dianalisis. Kurangi ukuran gambar dan coba lagi.';

  @override
  String get translation_region_limit =>
      'Gambar mempunyai terlalu banyak wilayah teks. Pisahkan dan coba lagi.';

  @override
  String get translation_text_limit =>
      'Wilayah teks terlalu panjang. Sesuaikan gambar dan coba lagi.';

  @override
  String get translation_unavailable => 'Terjemahan ini tidak lagi tersedia.';

  @override
  String get translation_outcome_unknown =>
      'Hasilnya perlu verifikasi. Itu belum diserahkan kembali.';

  @override
  String get translation_rate_limited =>
      'Permintaan terbatas. Terjemahan akan dilanjutkan secara otomatis.';

  @override
  String get translation_quota_exhausted => 'Kuota terjemahan tidak mencukupi.';

  @override
  String get translation_unsupported_language =>
      'Layanan tidak mendukung bahasa target ini.';

  @override
  String get translation_upgrade_required =>
      'Protokol terjemahan tidak kompatibel. Perbarui aplikasi.';

  @override
  String get translation_remote_failed =>
      'Terjemahan gagal untuk halaman ini. Anda dapat mencoba lagi secara manual.';

  @override
  String get translation_bridge_invalid =>
      'Halaman web berubah. Aktifkan terjemahan lagi.';

  @override
  String get translation_connection_failed =>
      'Koneksi gagal. Silakan coba lagi.';

  @override
  String get translation_paused =>
      'Terjemahan dijeda. Anda dapat memverifikasi kemajuannya.';

  @override
  String get translation_preparing_ellipsis => 'Mempersiapkan terjemahan…';

  @override
  String get translation_checking_original => 'Memeriksa gambar asli…';

  @override
  String get translation_submitting => 'Mengirimkan…';

  @override
  String get translation_uploading_ellipsis => 'Mengunggah yang asli…';

  @override
  String get translation_waiting_ellipsis => 'Menunggu terjemahan…';

  @override
  String get translation_running_ellipsis => 'Menerjemahkan…';

  @override
  String get translation_verify_result => 'Hasil memerlukan verifikasi';

  @override
  String get translation_partial => 'Beberapa konten telah diterjemahkan';

  @override
  String get translation_ready => 'Gambar terjemahan sudah siap';

  @override
  String get list_separator => ', ';

  @override
  String get player_play => 'Mainkan';

  @override
  String get player_quality => 'Kualitas';

  @override
  String get player_subtitles => 'Terjemahan';

  @override
  String get player_audio => 'Audio';

  @override
  String get player_statistics => 'Statistik untuk kutu buku';

  @override
  String get player_auto => 'Otomatis';

  @override
  String get source_information => 'Sumber informasi';

  @override
  String get source_code_page => 'Halaman';

  @override
  String get source_code_query => 'Pertanyaan';

  @override
  String get repository_invalid_source => 'Sumber tidak valid - hapus';

  @override
  String get player_fit_contain => 'Berisi';

  @override
  String get player_fit_cover => 'Sampul';

  @override
  String get player_fit_fill => 'Isi';

  @override
  String get player_fit_height => 'Tinggi';

  @override
  String get player_fit_width => 'Lebar';

  @override
  String get player_fit_scale => 'Skala';

  @override
  String get player_fit_none => 'Tidak ada';

  @override
  String get player_shader_clear => 'Mati (hapus shader)';

  @override
  String get player_shader_luma => 'Peningkatan Luma';

  @override
  String get player_decoder_auto => 'Otomatis (perangkat keras)';

  @override
  String get player_decoder_software =>
      'Perangkat Lunak (tanpa perangkat keras)';

  @override
  String get player_stats_toggle => 'Alihkan hamparan';

  @override
  String get player_stats_general => 'Umum';

  @override
  String get player_stats_frames => 'Pengaturan waktu bingkai';

  @override
  String get player_stats_cache => 'Masukkan cache';

  @override
  String get player_stats_filters => 'Filter aktif';

  @override
  String get player_stats_log => 'Catatan';

  @override
  String get source_mark_pinned => 'Sematkan';

  @override
  String translation_image_action(String action) {
    return '$action gambar ini';
  }

  @override
  String get memory_waiting => 'memori: menunggu sampel';

  @override
  String memory_rss(String current, String peak) {
    return 'RSS $current puncak $peak';
  }

  @override
  String memory_cache(String current, String limit, String peak) {
    return 'cache $current / $limit puncak $peak';
  }

  @override
  String memory_items(int count, int limit, int live, int peak) {
    return 'item $count / $limit hidup $live puncak $peak';
  }

  @override
  String memory_full_samples(String percent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sampel',
      one: '1 sampel',
    );
    return 'penuh $percent% dari $_temp0';
  }

  @override
  String get memory_reset_hint =>
      'matikan dan hidupkan dalam pengaturan untuk mengatur ulang';

  @override
  String get action_hide => 'Sembunyikan';

  @override
  String discord_get_app(String app) {
    return 'Dapatkan $app';
  }

  @override
  String get discord_idle => 'Menganggur';

  @override
  String discord_watching_title(String title) {
    return 'Menonton $title';
  }

  @override
  String discord_reading_title(String title) {
    return 'Membaca $title';
  }
}
