import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/identity.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/modules/translation/translation_display_switch.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/modules/translation/translation_image_status.dart';
import 'package:mangayomi/modules/translation/translation_image_actions.dart';
import 'package:mangayomi/modules/translation/translation_upgrade.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart';

import 'reader_page_image.dart';
import 'u_chap_data_preload.dart';
import 'widgets/reader_interactive_region.dart';

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
      if (data.pageUrl?.imageProcessing case final processing?)
        processing.toJson(),
      data.index,
    ]),
  );
}

class ReaderSourceImageReader implements SourceImageReader {
  ReaderSourceImageReader(this.data, this.providers);
  final UChapDataPreload data;
  final ProviderContainer providers;
  @override
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  ) async {
    cancellation.check();
    try {
      final file = await data.readerFile(providers);
      cancellation.check();
      if (file != null) return OriginalImageLease(file);
    } on TranslationCancelled {
      rethrow;
    } on FormatException {
      cancellation.check();
      throw const TranslationFailure('INVALID_IMAGE');
    } on FileSystemException catch (error) {
      cancellation.check();
      if (error is PathNotFoundException) {
        throw const TranslationFailure('SOURCE_MISSING');
      }
      throw const TranslationFailure('SOURCE_STORAGE');
    } catch (_) {
      cancellation.check();
    }
    throw const TranslationFailure('SOURCE_MISSING');
  }
}

class ReaderTranslationHost extends ConsumerStatefulWidget {
  const ReaderTranslationHost({
    super.key,
    required this.window,
    required this.child,
  });
  final ValueListenable<List<UChapDataPreload>> window;
  final Widget child;
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
  static Widget button(BuildContext context, {bool labeled = false}) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_ReaderTranslationScope>();
    if (scope == null) return const SizedBox.shrink();
    if (labeled) {
      final controller = scope.notifier!;
      return TranslationDisplayButton(
        translated: controller.showTranslation,
        onChanged: (value) => controller.configure(showTranslation: value),
      );
    }
    return Builder(
      builder: (anchor) => IconButton(
        tooltip: context.l10n.translation_title,
        icon: Icon(
          scope.notifier!.enabled ? Icons.translate : Icons.translate_outlined,
        ),
        onPressed: () => showTranslationControls(anchor, scope.notifier!),
      ),
    );
  }

  static TranslationViewController? controllerOf(BuildContext context) =>
      context
          .getInheritedWidgetOfExactType<_ReaderTranslationScope>()
          ?.notifier;

  static Widget withStatus(
    BuildContext context,
    UChapDataPreload original, {
    required Widget child,
    SubsamplingScaleImageViewController? imageController,
  }) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<_ReaderTranslationScope>()
        ?.notifier;
    final target = controller?.targetFor(readerTranslationPage(original));
    final visible =
        controller != null &&
        target != null &&
        controller.foreground &&
        controller.runtime != null;
    final status = visible
        ? TranslationImageStatus.forTarget(controller, target, context.l10n)
        : const TranslationImageStatus('', visible: false);
    // Keep the image at the same element depth when translation toggles.
    return Stack(
      children: [
        child,
        if (visible && status.visible)
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final badge = TranslationImageBadge(
                  status: status,
                  actionRegion: (button) =>
                      ReaderInteractiveRegion(child: button),
                  onAction: status.action == null
                      ? null
                      : status.action == TranslationAction.upgrade
                      ? () => openPricingPage(context)
                      : () => controller.perform(target, status.action!),
                );
                Widget position() {
                  final viewport = Offset.zero & constraints.biggest;
                  final rect = imageController == null
                      ? viewport
                      : imageController.imageViewRect;
                  if (rect == null || !rect.overlaps(viewport)) {
                    return const SizedBox.shrink();
                  }
                  final visible = rect
                      .intersect(viewport)
                      .deflate(NodeLaneTokens.space8);
                  if (visible.width <= 0 || visible.height <= 0) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                      left: visible.left,
                      top: visible.top,
                      right: viewport.right - visible.right,
                    ),
                    child: Align(alignment: Alignment.topLeft, child: badge),
                  );
                }

                return imageController == null
                    ? position()
                    : AnimatedBuilder(
                        animation: imageController,
                        builder: (context, _) => position(),
                      );
              },
            ),
          ),
      ],
    );
  }

  static Widget? imageActions(BuildContext context, UChapDataPreload original) {
    final controller = controllerOf(context);
    final target = controller?.targetFor(readerTranslationPage(original));
    if (controller == null || target == null) return null;
    return TranslationImageActions(controller: controller, target: target);
  }
}

class _ReaderTranslationHostState extends ConsumerState<ReaderTranslationHost>
    with WidgetsBindingObserver {
  final controller = TranslationViewController();
  final _projections = <String, UChapDataPreload>{};
  late final service = ref.read(translationServiceProvider);
  bool _foreground = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    service.addListener(_attach);
    controller.addListener(_releaseUnusedProjections);
    widget.window.addListener(_window);
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
        _projections.remove(key);
      }
    }
  }

  @override
  void didUpdateWidget(ReaderTranslationHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.window != widget.window) {
      oldWidget.window.removeListener(_window);
      widget.window.addListener(_window);
      _window();
    }
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
    final providers = ProviderScope.containerOf(context, listen: false);
    controller.window([
      for (final data in widget.window.value)
        TranslationTarget(
          readerTranslationPage(data),
          ReaderSourceImageReader(data, providers),
        ),
    ]);
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
    widget.window.removeListener(_window);
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
