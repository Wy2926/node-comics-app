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
}
