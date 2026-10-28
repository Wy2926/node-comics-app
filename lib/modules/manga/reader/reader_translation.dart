import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/identity.dart';
import 'package:mangayomi/services/translation/source_file.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/headers.dart';

import 'u_chap_data_preload.dart';

TranslationPage readerTranslationPage(UChapDataPreload data) {
  final manga = data.chapter?.manga.value;
  return TranslationPage(
    translationKey([
      'reader',
      manga?.sourceId,
      manga?.source,
      manga?.lang,
      manga?.id,
      data.chapter?.id,
      data.chapter?.url,
      data.index,
    ]),
    translationKey([
      data.chapter?.archivePath,
      data.localImagePath,
      data.pageUrl?.url,
      data.index,
    ]),
  );
}

class ReaderSourceImageReader implements SourceImageReader {
  ReaderSourceImageReader(this.data, this.headers);
  final UChapDataPreload data;
  final Map<String, String> headers;
  @override
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  ) async {
    cancellation.check();
    // Local/archive bytes are owned by the existing reader, not the channel.
    if (data.isLocale == true ||
        data.localImagePath != null ||
        data.archiveImage != null) {
      final path = await data.getLocalFilePath;
      if (path == null) throw const TranslationFailure('SOURCE_MISSING');
      cancellation.check();
      return OriginalImageLease(File(path));
    }
    // This path is the original currently decoded by the reader. It is never
    // replaced with a translation path, and avoids a second source download.
    if (data.resolvedFilePath != null &&
        await File(data.resolvedFilePath!).exists()) {
      return OriginalImageLease(File(data.resolvedFilePath!));
    }
    final uri = Uri.tryParse(data.pageUrl?.url ?? '');
    if (uri == null) throw const TranslationFailure('SOURCE_MISSING');
    return HttpSourceImageReader(
      uri,
      headers: (target) async {
        final cookies = await CookieManager.instance().getCookies(
          url: WebUri(target.toString()),
        );
        return {
          if (target.origin == uri.origin && cookies.isNotEmpty)
            'Cookie': cookies
                .map((cookie) => '${cookie.name}=${cookie.value}')
                .join('; '),
          for (final entry in headers.entries)
            if (target.origin == uri.origin ||
                {
                  'accept',
                  'accept-language',
                  'user-agent',
                  'referer',
                }.contains(entry.key.toLowerCase()))
              entry.key: entry.value,
        };
      },
    ).acquire(page, cancellation);
  }
}

class ReaderTranslationHost extends ConsumerStatefulWidget {
  const ReaderTranslationHost({
    super.key,
    required this.pages,
    required this.currentIndex,
    required this.visibleCount,
    required this.child,
    required this.pageListenable,
    required this.actualIndex,
  });
  final List<UChapDataPreload> pages;
  final int currentIndex, visibleCount;
  final Widget child;
  final ValueListenable<int?> pageListenable;
  final int Function() actualIndex;
  @override
  ConsumerState<ReaderTranslationHost> createState() =>
      _ReaderTranslationHostState();
  static UChapDataPreload display(
    BuildContext context,
    UChapDataPreload original,
  ) =>
      context
          .dependOnInheritedWidgetOfExactType<_ReaderTranslationScope>()
          ?.owner
          .display(original) ??
      original;
  static Widget button(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_ReaderTranslationScope>();
    if (scope == null) return const SizedBox.shrink();
    return IconButton(
      tooltip: '漫画翻译',
      icon: Icon(
        scope.notifier!.enabled ? Icons.translate : Icons.translate_outlined,
      ),
      onPressed: () => showTranslationControls(context, scope.notifier!),
    );
  }
}

class _ReaderTranslationHostState extends ConsumerState<ReaderTranslationHost>
    with WidgetsBindingObserver {
  final controller = TranslationViewController();
  final _projections = <String, UChapDataPreload>{};
  late final service = ref.read(translationServiceProvider);
  bool _foreground = true;
  bool _windowScheduled = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    service.addListener(_attach);
    controller.addListener(_releaseUnusedProjections);
    widget.pageListenable.addListener(_scheduleWindow);
    service
        .initialize()
        .then((_) {
          if (mounted) _attach();
        })
        .catchError((_) {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _window();
    });
  }

  void _attach() {
    if (mounted) controller.attach(service.runtime);
  }

  void _releaseUnusedProjections() {
    final retainedPaths = controller.foreground && controller.showTranslation
        ? controller.images.values.map((image) => image.file.path).toSet()
        : <String>{};
    for (final key in _projections.keys.toList()) {
      if (!retainedPaths.contains(_projections[key]!.localImagePath)) {
        _projections.remove(key)?.decodedImage?.dispose();
      }
    }
  }

  void _scheduleWindow() {
    if (_windowScheduled) return;
    _windowScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _windowScheduled = false;
      if (mounted) _window();
    });
  }

  @override
  void didUpdateWidget(ReaderTranslationHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _window();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.configure(
          foreground: _foreground && TickerMode.valuesOf(context).enabled,
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    controller.configure(
      foreground: _foreground && TickerMode.valuesOf(context).enabled,
    );
  }

  void _window() {
    final targets = <TranslationTarget>[];
    final seen = <String>{};
    for (final data in widget.pages.skip(
      widget.actualIndex().clamp(0, widget.pages.length),
    )) {
      if (data.isTransitionPage) continue;
      final page = readerTranslationPage(data);
      if (!seen.add(page.identity)) continue;
      final manga = data.chapter?.manga.value;
      final headers = <String, String>{
        ...data.pageUrl?.headers ?? {},
        if (data.isLocale != true &&
            manga?.source != null &&
            manga?.lang != null)
          ...ref.read(
            headersProvider(
              source: manga!.source!,
              lang: manga.lang!,
              sourceId: manga.sourceId,
            ),
          ),
      };
      targets.add(
        TranslationTarget(page, ReaderSourceImageReader(data, headers)),
      );
      if (targets.length >= widget.visibleCount + 2 || targets.length >= 4) {
        break;
      }
    }
    final keep = targets.map((t) => t.page.key).toSet();
    for (final key in _projections.keys.toList()) {
      if (!keep.any((page) => key.startsWith(page))) {
        _projections.remove(key)?.decodedImage?.dispose();
      }
    }
    controller.window(targets);
  }

  UChapDataPreload display(UChapDataPreload original) {
    if (!controller.showTranslation ||
        !controller.foreground ||
        original.isTransitionPage) {
      return original;
    }
    final page = readerTranslationPage(original);
    final image = controller.images[page.identity];
    if (image == null) return original;
    final key = '${page.key}:${original.srcRect}';
    final previous = _projections[key];
    if (previous?.localImagePath == image.file.path) return previous!;
    previous?.decodedImage?.dispose();
    final rect = original.srcRect;
    final factor = rect == null ? 1.0 : image.height / rect.height;
    return _projections[key] =
        UChapDataPreload(
            original.chapter,
            original.directory,
            original.pageUrl,
            true,
            null,
            original.index,
            original.chapterUrlModel,
            original.pageIndex,
            localImagePath: image.file.path,
            srcRect: rect == null
                ? null
                : Rect.fromLTWH(
                    rect.left * factor,
                    rect.top * factor,
                    rect.width * factor,
                    rect.height * factor,
                  ),
          )
          ..resolvedFilePath = image.file.path
          ..loadedWidth = original.loadedWidth ?? image.width.toDouble()
          ..loadedHeight = original.loadedHeight ?? image.height.toDouble();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    service.removeListener(_attach);
    controller.removeListener(_releaseUnusedProjections);
    controller.dispose();
    widget.pageListenable.removeListener(_scheduleWindow);
    for (final data in _projections.values) {
      data.decodedImage?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _ReaderTranslationScope(
    owner: this,
    notifier: controller,
    child: widget.child,
  );
}

class _ReaderTranslationScope
    extends InheritedNotifier<TranslationViewController> {
  const _ReaderTranslationScope({
    required this.owner,
    required super.notifier,
    required super.child,
  });
  final _ReaderTranslationHostState owner;
}
