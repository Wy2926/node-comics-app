import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/detail/manga_details_view.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_loading.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MangaReaderDetail extends ConsumerStatefulWidget {
  final int mangaId;
  const MangaReaderDetail({super.key, required this.mangaId});

  @override
  ConsumerState<MangaReaderDetail> createState() => _MangaReaderDetailState();
}

class _MangaReaderDetailState extends ConsumerState<MangaReaderDetail> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Wait for the widget tree to settle before loading detail
    await WidgetsBinding.instance.endOfFrame;
    await _updateDetail(isInit: true);
  }

  Future<void> _updateDetail({bool isInit = false}) async {
    if (!mounted || (_isLoading && !isInit)) return;
    if (!isInit) setState(() => _isLoading = true);
    try {
      await ref.read(
        updateMangaDetailProvider(
          mangaId: widget.mangaId,
          isInit: isInit,
        ).future,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    final manga = ref.watch(
      getMangaDetailStreamProvider(mangaId: widget.mangaId),
    );
    return Scaffold(
      body: manga.when(
        data: (manga) {
          if (manga == null) {
            return _loadingPage();
          }
          final hasSourceInfo = manga.lang != null && manga.source != null;
          return StreamBuilder<List<Source>>(
            initialData: hasSourceInfo
                ? sourceRepository.getActiveByItemTypeLangName(
                    manga.itemType,
                    manga.lang!,
                    manga.source!,
                  )
                : const [],
            stream: hasSourceInfo
                ? sourceRepository.watchActiveByItemTypeLangName(
                    manga.itemType,
                    manga.lang!,
                    manga.source!,
                  )
                : const Stream.empty(),
            builder: (context, snapshot) {
              final sourceExist = snapshot.hasData && snapshot.data!.isNotEmpty;
              Future<void> refreshDetail() async {
                if (sourceExist) await _updateDetail();
              }

              return RefreshIndicator(
                onRefresh: refreshDetail,
                child: MangaDetailsView(
                  manga: manga,
                  loading: _isLoading,
                  sourceExist: sourceExist,
                  onRefresh: refreshDetail,
                ),
              );
            },
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return ErrorText(error);
        },
        loading: () {
          return _loadingPage();
        },
      ),
    );
  }

  Widget _loadingPage() => isMobile && !isTv
      ? const MobileDetailLoadingPage()
      : const ProgressCenter();
}
