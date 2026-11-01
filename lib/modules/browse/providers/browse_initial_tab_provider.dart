import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';

enum BrowseTabKind { sources, extensions }

class BrowseTab {
  final ItemType type;
  final BrowseTabKind kind;

  const BrowseTab(this.type, this.kind);
}

/// A source section to open on mobile, desktop or TV.
///
/// Read on the way in and [clear]ed after that frame, so a request steers only
/// the one visit it was made for and an ordinary trip to Browse still opens
/// where it always did. The clear has to wait: Riverpod counts initState as
/// part of the build and refuses a write there.
class BrowseInitialTab extends Notifier<BrowseTab?> {
  @override
  BrowseTab? build() => null;

  void request(BrowseTab tab) => state = tab;

  void clear() {
    if (state != null) state = null;
  }
}

final browseInitialTabProvider = NotifierProvider<BrowseInitialTab, BrowseTab?>(
  BrowseInitialTab.new,
);
