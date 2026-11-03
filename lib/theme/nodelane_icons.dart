import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Semantic icon roles. iOS content uses the already bundled Cupertino font;
/// the native tab bar continues to render SF Symbols in UIKit independently.
class NodeLaneIcons {
  const NodeLaneIcons._(this._cupertino);
  final bool _cupertino;

  static NodeLaneIcons of(BuildContext context) => NodeLaneIcons._(
    Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS,
  );

  IconData _pick(IconData ios, IconData material) =>
      _cupertino ? ios : material;
  IconData get manga => _pick(CupertinoIcons.book, Icons.auto_stories_outlined);
  IconData get mangaSelected =>
      _pick(CupertinoIcons.book_fill, Icons.auto_stories_rounded);
  IconData get anime =>
      _pick(CupertinoIcons.play_circle, Icons.play_circle_outline_rounded);
  IconData get novel => _pick(CupertinoIcons.doc_text, Icons.menu_book_rounded);
  IconData get add => _pick(CupertinoIcons.plus, Icons.add_rounded);
  IconData get more => _pick(CupertinoIcons.ellipsis, Icons.more_horiz_rounded);
  IconData get filter =>
      _pick(CupertinoIcons.line_horizontal_3_decrease, Icons.tune_rounded);
  IconData get search => _pick(CupertinoIcons.search, Icons.search_rounded);
  IconData get clear =>
      _pick(CupertinoIcons.clear_circled_solid, Icons.cancel_rounded);
  IconData get down =>
      _pick(CupertinoIcons.chevron_down, Icons.expand_more_rounded);
  IconData get forward =>
      _pick(CupertinoIcons.chevron_forward, Icons.chevron_right_rounded);
  IconData get check => _pick(CupertinoIcons.check_mark, Icons.check_rounded);
  IconData get close => _pick(CupertinoIcons.xmark, Icons.close_rounded);
  IconData get webLink => _pick(CupertinoIcons.link, Icons.link);
  IconData get recommend =>
      _pick(CupertinoIcons.hand_thumbsup, Icons.thumb_up_outlined);
  IconData get web => _pick(CupertinoIcons.globe, Icons.public_rounded);
  IconData get browser =>
      _pick(CupertinoIcons.square_on_square, Icons.tab_outlined);
  IconData get browserStart =>
      _pick(CupertinoIcons.macwindow, Icons.web_asset_outlined);
  IconData get external =>
      _pick(CupertinoIcons.arrow_up_right_square, Icons.open_in_new);
  IconData get code =>
      _pick(CupertinoIcons.chevron_left_slash_chevron_right, Icons.code);
  IconData get cookies =>
      _pick(CupertinoIcons.circle_grid_hex, Icons.cookie_outlined);
  IconData get clipboard =>
      _pick(CupertinoIcons.doc_on_clipboard, Icons.content_paste);
  IconData get lock => _pick(CupertinoIcons.lock_fill, Icons.lock_outline);
  IconData get repository =>
      _pick(CupertinoIcons.cube_box, Icons.storage_outlined);
  IconData get extensions =>
      _pick(CupertinoIcons.square_grid_2x2, Icons.extension_outlined);
  IconData get folderOutline =>
      _pick(CupertinoIcons.folder, Icons.folder_outlined);
  IconData get folder =>
      _pick(CupertinoIcons.folder_fill, Icons.folder_outlined);
  IconData get settings => _pick(CupertinoIcons.gear, Icons.settings_outlined);
  IconData get translate =>
      _pick(CupertinoIcons.textformat, Icons.translate_rounded);
  IconData get account =>
      _pick(CupertinoIcons.person_fill, Icons.person_rounded);
  IconData get download =>
      _pick(CupertinoIcons.arrow_down_to_line, Icons.download_outlined);
  IconData get incognito =>
      _pick(CupertinoIcons.eyeglasses, Icons.visibility_off_outlined);
  IconData get reorder =>
      _pick(CupertinoIcons.line_horizontal_3, Icons.drag_handle_rounded);
  IconData get visible => _pick(CupertinoIcons.eye, Icons.visibility_outlined);
  IconData get categories =>
      _pick(CupertinoIcons.layers_alt, Icons.label_outline_rounded);
  IconData get storage =>
      _pick(CupertinoIcons.archivebox, Icons.storage_outlined);
  IconData get statistics =>
      _pick(CupertinoIcons.chart_bar, Icons.query_stats_outlined);
  IconData get calendar =>
      _pick(CupertinoIcons.calendar, Icons.calendar_month_outlined);
  IconData get info => _pick(CupertinoIcons.info, Icons.info_outline_rounded);
  IconData get history => _pick(CupertinoIcons.clock, Icons.history_rounded);
  IconData get stop =>
      _pick(CupertinoIcons.stop_circle, Icons.stop_circle_outlined);
  IconData get latest =>
      _pick(CupertinoIcons.sparkles, Icons.new_releases_outlined);
  IconData get pin => _pick(CupertinoIcons.pin, Icons.push_pin_outlined);
  IconData get pinSelected =>
      _pick(CupertinoIcons.pin_fill, Icons.push_pin_rounded);
  IconData get ascending => _pick(CupertinoIcons.arrow_up, Icons.arrow_upward);
  IconData get descending =>
      _pick(CupertinoIcons.arrow_down, Icons.arrow_downward);
  IconData get count => _pick(CupertinoIcons.number, Icons.numbers);
  IconData get refresh => _pick(CupertinoIcons.refresh, Icons.refresh);
  IconData get shuffle => _pick(CupertinoIcons.shuffle, Icons.shuffle_rounded);
  IconData get delete =>
      _pick(CupertinoIcons.trash, Icons.delete_outline_rounded);
  IconData get back => _pick(CupertinoIcons.chevron_back, Icons.arrow_back);
  IconData get share => _pick(CupertinoIcons.share, Icons.ios_share_outlined);
  IconData get migrate =>
      _pick(CupertinoIcons.arrow_right_arrow_left, Icons.swap_horiz_rounded);
  IconData get export =>
      _pick(CupertinoIcons.arrow_up_doc, Icons.file_upload_outlined);
  IconData get groups => _pick(CupertinoIcons.person_2, Icons.groups_outlined);
  IconData get bookmark =>
      _pick(CupertinoIcons.bookmark_fill, Icons.bookmark_rounded);
  IconData get selected =>
      _pick(CupertinoIcons.checkmark_circle_fill, Icons.check_circle);
  IconData get unselected =>
      _pick(CupertinoIcons.circle, Icons.radio_button_unchecked);
  IconData get unread => _pick(CupertinoIcons.circle_fill, Icons.circle);
  IconData get downloaded =>
      _pick(CupertinoIcons.checkmark_circle, Icons.check_circle_outline);
  IconData get error =>
      _pick(CupertinoIcons.exclamationmark_circle, Icons.error_outline);
  IconData get edit => _pick(CupertinoIcons.pencil, Icons.edit_outlined);
  IconData get tracking =>
      _pick(CupertinoIcons.arrow_2_circlepath, Icons.sync_outlined);
  IconData get related =>
      _pick(CupertinoIcons.book, Icons.account_tree_outlined);
  IconData get bookmarkOutline =>
      _pick(CupertinoIcons.bookmark, Icons.bookmark_border_rounded);
  IconData get chapters =>
      _pick(CupertinoIcons.list_bullet, Icons.format_list_bulleted_rounded);
  IconData get adjustments =>
      _pick(CupertinoIcons.slider_horizontal_3, Icons.tune_rounded);
  IconData get previousChapter =>
      _pick(CupertinoIcons.backward_end_fill, Icons.skip_previous_rounded);
  IconData get nextChapter =>
      _pick(CupertinoIcons.forward_end_fill, Icons.skip_next_rounded);
  IconData get locate => _pick(CupertinoIcons.scope, Icons.my_location);
  IconData get timer => _pick(CupertinoIcons.timer, Icons.timer_outlined);
  IconData get crop => _pick(CupertinoIcons.crop, Icons.crop_rounded);
  IconData get pageLayout =>
      _pick(CupertinoIcons.rectangle_grid_1x2, Icons.view_week_outlined);
  IconData get palette =>
      _pick(CupertinoIcons.paintbrush, Icons.palette_outlined);
  IconData get pageNumber =>
      _pick(CupertinoIcons.doc_text, Icons.format_list_numbered_rounded);
  IconData get brightness =>
      _pick(CupertinoIcons.sun_max, Icons.light_mode_outlined);
  IconData get animation => _pick(CupertinoIcons.film, Icons.animation_rounded);
  IconData get navigation =>
      _pick(CupertinoIcons.compass, Icons.explore_outlined);
  IconData get flash => _pick(CupertinoIcons.bolt, Icons.flash_on_outlined);
  IconData get contrast =>
      _pick(CupertinoIcons.circle_lefthalf_fill, Icons.contrast_rounded);
  IconData get grayscale => _pick(CupertinoIcons.drop, Icons.tonality_rounded);
  IconData get image => _pick(CupertinoIcons.photo, Icons.image_outlined);
  IconData get saveImage =>
      _pick(CupertinoIcons.square_arrow_down, Icons.file_download_outlined);
  IconData get reset =>
      _pick(CupertinoIcons.arrow_counterclockwise, Icons.replay);
  IconData get readingLeft => _pick(CupertinoIcons.arrow_left, Icons.west);
  IconData get readingRight => _pick(CupertinoIcons.arrow_right, Icons.east);
  IconData get continuousVertical =>
      _pick(CupertinoIcons.arrow_up_down_square, Icons.swap_vert);
  IconData get horizontalPages =>
      _pick(CupertinoIcons.square_split_2x1, Icons.view_week_outlined);

  IconData readerSetting(IconData icon) => switch (icon) {
    Icons.chrome_reader_mode_outlined => manga,
    Icons.auto_stories_outlined => pageLayout,
    Icons.timer_outlined => timer,
    Icons.crop_rounded => crop,
    Icons.view_day_outlined || Icons.layers_outlined => categories,
    Icons.fit_screen_rounded || Icons.zoom_in_rounded => search,
    Icons.palette_outlined => palette,
    Icons.color_lens_outlined => image,
    Icons.format_list_numbered_rounded => pageNumber,
    Icons.light_mode_outlined => brightness,
    Icons.animation_rounded => animation,
    Icons.touch_app_outlined || Icons.pan_tool_alt_outlined => navigation,
    Icons.flash_on_outlined => flash,
    Icons.invert_colors_rounded || Icons.contrast_rounded => contrast,
    Icons.tonality_rounded => grayscale,
    Icons.vertical_split_outlined || Icons.view_week_outlined => pageLayout,
    Icons.swap_horiz_rounded || Icons.horizontal_distribute_rounded => migrate,
    Icons.screen_rotation_outlined => _pick(CupertinoIcons.rotate_right, icon),
    Icons.rotate_left_rounded => _pick(CupertinoIcons.rotate_left, icon),
    Icons.first_page_rounded => _pick(CupertinoIcons.doc, icon),
    Icons.zoom_out_rounded => _pick(CupertinoIcons.zoom_out, icon),
    Icons.format_line_spacing_rounded || Icons.swipe_vertical_rounded => _pick(
      CupertinoIcons.arrow_up_arrow_down,
      icon,
    ),
    Icons.view_quilt_outlined || Icons.grid_view_outlined => extensions,
    _ => icon,
  };
}
