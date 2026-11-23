import '../u_chap_data_preload.dart';

/// Speculative work starts at the first visible image, never at the progress
/// label (which can already say "finished"). Extra visible strips are demand.
class ReaderPageWindow {
  static const lookAhead = 6;
  final forward = <UChapDataPreload>[];
  final prefetch = <UChapDataPreload>[];
  bool needsNextChapter = false;

  ReaderPageWindow(
    List<UChapDataPreload> pages,
    int first,
    int last, {
    required bool backward,
  }) {
    if (pages.isEmpty) return;
    first = first.clamp(0, pages.length - 1);
    last = last.clamp(first, pages.length - 1);
    final seen = <(int?, int?)>{};
    bool add(UChapDataPreload p) =>
        !p.isTransitionPage && seen.add((p.chapter?.id, p.index));
    for (int i = first; i <= last; i++) {
      if (add(pages[i])) forward.add(pages[i].original);
    }
    final visible = forward.length;
    for (
      int i = last + 1;
      i < pages.length && forward.length < lookAhead + 1;
      i++
    ) {
      if (add(pages[i])) forward.add(pages[i].original);
    }
    needsNextChapter =
        forward.length < lookAhead + 1 || last >= pages.length - 1;
    final behind = <UChapDataPreload>[];
    for (int i = first - 1; i >= 0 && behind.length < (backward ? 3 : 2); i--) {
      if (add(pages[i])) behind.add(pages[i].original);
    }
    prefetch.addAll([
      ...forward.take(visible),
      if (backward) ...behind,
      ...forward.skip(visible),
      if (!backward) ...behind,
    ]);
  }
}
