import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/reader/mobile_reader_screen.dart';
import 'package:mangayomi/modules/more/settings/reader/mobile_reader_picker.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';

final _writes = <(String, Object)>[];

void main() {
  var scale = 1.0;
  Widget app(ProviderContainer container) => UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(scale),
          padding: const EdgeInsets.only(top: 24, bottom: 34),
        ),
        child: child!,
      ),
      home: const MobileReaderScreen(),
    ),
  );
  ProviderContainer preferences(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        defaultReadingModeStateProvider.overrideWith(_DefaultReadingMode.new),
        scaleTypeStateProvider.overrideWith(_ScaleType.new),
        backgroundColorStateProvider.overrideWith(_BackgroundColor.new),
        showPagesNumberStateProvider.overrideWith(_ShowPagesNumber.new),
        keepScreenOnReaderStateProvider.overrideWith(_KeepScreenOnReader.new),
        cropBordersStateProvider.overrideWith(_CropBorders.new),
        splitWidePagesStateProvider.overrideWith(_SplitWidePages.new),
        dualPageInvertStateProvider.overrideWith(_DualPageInvert.new),
        dualPageRotateToFitStateProvider.overrideWith(_DualPageRotateToFit.new),
        dualPageRotateToFitInvertStateProvider.overrideWith(
          _DualPageRotateToFitInvert.new,
        ),
        doublePageSingleFirstPageStateProvider.overrideWith(
          _DoublePageSingleFirstPage.new,
        ),
        doublePageAutoStateProvider.overrideWith(_DoublePageAuto.new),
        landscapeZoomStateProvider.overrideWith(_LandscapeZoom.new),
        zoomStartPositionStateProvider.overrideWith(_ZoomStartPosition.new),
        webtoonDisableZoomOutStateProvider.overrideWith(
          _WebtoonDisableZoomOut.new,
        ),
        webtoonDoubleTapZoomEnabledStateProvider.overrideWith(
          _WebtoonDoubleTapZoomEnabled.new,
        ),
        showPageGapsStateProvider.overrideWith(_ShowPageGaps.new),
        webtoonSidePaddingStateProvider.overrideWith(_WebtoonSidePadding.new),
        usePageTapZonesStateProvider.overrideWith(_UsePageTapZones.new),
        readerNavigationLayoutStateProvider.overrideWith(
          _ReaderNavigationLayout.new,
        ),
        tappingInversionStateProvider.overrideWith(_TappingInversion.new),
        readerHideThresholdStateProvider.overrideWith(_ReaderHideThreshold.new),
        showNavigationOverlayOnStartStateProvider.overrideWith(
          _ShowNavigationOverlayOnStart.new,
        ),
        navigateToPanStateProvider.overrideWith(_NavigateToPan.new),
        chapterSwipeStartActionStateProvider.overrideWith(
          _ChapterSwipeStartAction.new,
        ),
        chapterSwipeEndActionStateProvider.overrideWith(
          _ChapterSwipeEndAction.new,
        ),
        pagePreloadAmountStateProvider.overrideWith(_PagePreloadAmount.new),
        animatePageTransitionsStateProvider.overrideWith(
          _AnimatePageTransitions.new,
        ),
        doubleTapAnimationSpeedStateProvider.overrideWith(
          _DoubleTapAnimationSpeed.new,
        ),
        autoReadDuplicateChaptersStateProvider.overrideWith(
          _AutoReadDuplicateChapters.new,
        ),
        flashOnPageChangeStateProvider.overrideWith(_FlashOnPageChange.new),
        flashColorStateProvider.overrideWith(_FlashColor.new),
        flashIntervalStateProvider.overrideWith(_FlashInterval.new),
        flashDurationStateProvider.overrideWith(_FlashDuration.new),
      ],
    );
    addTearDown(container.dispose);
    // The real providers persist settings. Keep these in-memory replacements
    // alive when a dependent row or an entire section is temporarily hidden.
    addTearDown(
      container.listen(defaultReadingModeStateProvider, (_, _) {}).close,
    );
    addTearDown(container.listen(scaleTypeStateProvider, (_, _) {}).close);
    addTearDown(
      container.listen(backgroundColorStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(showPagesNumberStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(keepScreenOnReaderStateProvider, (_, _) {}).close,
    );
    addTearDown(container.listen(cropBordersStateProvider, (_, _) {}).close);
    addTearDown(container.listen(splitWidePagesStateProvider, (_, _) {}).close);
    addTearDown(container.listen(dualPageInvertStateProvider, (_, _) {}).close);
    addTearDown(
      container.listen(dualPageRotateToFitStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(dualPageRotateToFitInvertStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(doublePageSingleFirstPageStateProvider, (_, _) {}).close,
    );
    addTearDown(container.listen(doublePageAutoStateProvider, (_, _) {}).close);
    addTearDown(container.listen(landscapeZoomStateProvider, (_, _) {}).close);
    addTearDown(
      container.listen(zoomStartPositionStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(webtoonDisableZoomOutStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container
          .listen(webtoonDoubleTapZoomEnabledStateProvider, (_, _) {})
          .close,
    );
    addTearDown(container.listen(showPageGapsStateProvider, (_, _) {}).close);
    addTearDown(
      container.listen(webtoonSidePaddingStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(usePageTapZonesStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(readerNavigationLayoutStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(tappingInversionStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(readerHideThresholdStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container
          .listen(showNavigationOverlayOnStartStateProvider, (_, _) {})
          .close,
    );
    addTearDown(container.listen(navigateToPanStateProvider, (_, _) {}).close);
    addTearDown(
      container.listen(chapterSwipeStartActionStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(chapterSwipeEndActionStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(pagePreloadAmountStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(animatePageTransitionsStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(doubleTapAnimationSpeedStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(autoReadDuplicateChaptersStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(flashOnPageChangeStateProvider, (_, _) {}).close,
    );
    addTearDown(container.listen(flashColorStateProvider, (_, _) {}).close);
    addTearDown(container.listen(flashIntervalStateProvider, (_, _) {}).close);
    addTearDown(container.listen(flashDurationStateProvider, (_, _) {}).close);
    return container;
  }

  setUp(() {
    scale = 1;
    _writes.clear();
  });

  Future<void> reveal(
    WidgetTester tester,
    Finder target, {
    double delta = 260,
  }) async {
    await tester.scrollUntilVisible(
      target,
      delta,
      scrollable: find.byType(Scrollable).last,
    );
    await Scrollable.ensureVisible(tester.element(target), alignment: 0.5);
    await tester.pumpAndSettle();
    expect(target.hitTestable(), findsOneWidget);
  }

  Future<void> section(
    WidgetTester tester,
    String label, {
    double delta = 260,
  }) async {
    final target = find.widgetWithText(NodeLaneDisclosure, label);
    await reveal(tester, target, delta: delta);
    await tester.tap(
      find.descendant(of: target, matching: find.text(label)).first,
    );
    await tester.pumpAndSettle();
  }

  Future<void> toggle(
    WidgetTester tester,
    String label, {
    double delta = 260,
  }) async {
    final target = find.widgetWithText(NodeLaneSwitchRow, label);
    await reveal(tester, target, delta: delta);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> openChoice(
    WidgetTester tester,
    String title, {
    double delta = 260,
  }) async {
    final target = find.byWidgetPredicate(
      (w) => w is NodeLaneRow && w.title == title && w.value != null,
    );
    await reveal(tester, target, delta: delta);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> choose(WidgetTester tester, String title, String option) async {
    await openChoice(tester, title);
    final target = find.descendant(
      of: find.byWidgetPredicate((widget) => widget is MobileReaderPicker),
      matching: find.widgetWithText(NodeLaneRow, option),
    );
    await reveal(tester, target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'reading and navigation choices cancel safely and write only their original preference',
    (tester) async {
      final container = preferences(tester);
      await tester.pumpWidget(app(container));
      await tester.pumpAndSettle();
      await openChoice(tester, 'Default reading mode');
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(_writes, isEmpty);
      await choose(tester, 'Default reading mode', 'Webtoon');
      expect(
        container.read(defaultReadingModeStateProvider),
        ReaderMode.webtoon,
      );
      expect(
        container.read(backgroundColorStateProvider),
        BackgroundColor.black,
      );
      await section(tester, 'Navigation layout');
      expect(_writes, [('defaultReadingMode', ReaderMode.webtoon)]);
      await choose(tester, 'Navigation layout', 'Kindle-ish');
      await choose(tester, 'Tapping Inversion', 'Vertical');
      await choose(tester, 'Swipe right', 'Download');
      await choose(tester, 'Swipe left', 'Disabled');
      expect(_writes, [
        ('defaultReadingMode', ReaderMode.webtoon),
        ('readerNavigationLayout', 2),
        ('tappingInversion', 2),
        ('chapterSwipeStartAction', ChapterSwipeAction.download),
        ('chapterSwipeEndAction', ChapterSwipeAction.disabled),
      ]);
      expect(container.read(usePageTapZonesStateProvider), isTrue);
      expect(container.read(readerHideThresholdStateProvider), 1);
      expect(
        container.read(showNavigationOverlayOnStartStateProvider),
        isFalse,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'scale and background choices preserve existing values and dismiss without writing',
    (tester) async {
      final container = preferences(tester);
      await tester.pumpWidget(app(container));
      await tester.pumpAndSettle();
      await openChoice(tester, 'Scale type');
      expect(find.widgetWithText(NodeLaneRow, 'Original size'), findsNothing);
      expect(find.widgetWithText(NodeLaneRow, 'Smart fit'), findsNothing);
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(_writes, isEmpty);
      await choose(tester, 'Scale type', 'Fit height');
      await choose(tester, 'Scale type', 'Fit height');
      expect(_writes, [('scaleType', ScaleType.fitHeight)]);
      await choose(tester, 'Background color', 'Automatic');
      expect(container.read(scaleTypeStateProvider), ScaleType.fitHeight);
      expect(
        container.read(backgroundColorStateProvider),
        BackgroundColor.automatic,
      );
      expect(_writes, [
        ('scaleType', ScaleType.fitHeight),
        ('backgroundColor', BackgroundColor.automatic),
      ]);
      await openChoice(tester, 'Background color');
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(_writes, hasLength(2));
      expect(find.byType(MobileReaderScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'large text keeps dependent layout values and continuous sliders commit once per drag',
    (tester) async {
      scale = 2.5;
      final container = preferences(tester);
      await tester.pumpWidget(app(container));
      await tester.pumpAndSettle();
      await section(tester, 'Page layout');
      expect(_writes, isEmpty);
      await toggle(tester, 'Split wide pages');
      expect(find.text('Invert cut half pages'), findsNothing);
      expect(container.read(dualPageInvertStateProvider), isTrue);
      await toggle(tester, 'Split wide pages');
      expect(container.read(dualPageInvertStateProvider), isTrue);
      await toggle(tester, 'Rotate to fit');
      await toggle(tester, 'Invert rotation direction');
      await toggle(tester, 'Rotate to fit', delta: -260);
      await toggle(tester, 'Rotate to fit');
      expect(container.read(dualPageRotateToFitInvertStateProvider), isFalse);
      await toggle(tester, 'Automatic landscape zoom');
      await choose(tester, 'Zoom start position', 'Left');
      await toggle(tester, 'Automatic landscape zoom', delta: -260);
      await toggle(tester, 'Automatic landscape zoom');
      expect(container.read(zoomStartPositionStateProvider), 0);
      expect(container.read(doublePageSingleFirstPageStateProvider), isTrue);
      expect(container.read(doublePageAutoStateProvider), isFalse);
      // Collapse by the header, without tapping a child in the expanded section.
      final header = find.text('Page layout');
      await reveal(tester, header, delta: -260);
      await tester.tap(header);
      await tester.pumpAndSettle();
      await section(tester, 'Continuous reading');
      final slider = find.byType(Slider);
      await reveal(tester, slider);
      final before = _writes.length;
      final gesture = await tester.startGesture(tester.getCenter(slider));
      await gesture.moveBy(const Offset(45, 0));
      await tester.pump();
      expect(_writes, hasLength(before));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(_writes, hasLength(before + 1));
      expect(_writes.last.$1, 'webtoonSidePadding');
      expect(container.read(webtoonSidePaddingStateProvider), isNot(10));
      expect(container.read(webtoonDoubleTapZoomEnabledStateProvider), isTrue);
      expect(container.read(showPageGapsStateProvider), isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'preload input validates its original bounds and hidden flash options keep independent values',
    (tester) async {
      scale = 2.5;
      final container = preferences(tester);
      await tester.pumpWidget(app(container));
      await tester.pumpAndSettle();
      await section(tester, 'Advanced');
      await openChoice(tester, 'Page preload amount');
      tester.view.viewInsets = const FakeViewPadding(bottom: 180);
      await tester.pumpAndSettle();
      for (final value in ['0', '21']) {
        await tester.enterText(find.byType(TextField), value);
        await tester.pumpAndSettle();
        expect(
          tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
          isNull,
        );
      }
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(container.read(pagePreloadAmountStateProvider), 6);
      expect(_writes, isEmpty);
      tester.view.viewInsets = const FakeViewPadding();
      await tester.pumpAndSettle();
      await openChoice(tester, 'Page preload amount');
      await tester.enterText(find.byType(TextField), '12');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(_writes, [('pagePreloadAmount', 12)]);
      await toggle(tester, 'Flash on page change');
      await choose(tester, 'Flash Color', 'Black');
      final interval = find.byType(Slider).first;
      await reveal(tester, interval);
      final before = _writes.length;
      await tester.drag(interval, const Offset(40, 0));
      await tester.pumpAndSettle();
      expect(_writes, hasLength(before + 1));
      final savedInterval = container.read(flashIntervalStateProvider);
      expect(savedInterval, isNot(3));
      expect(container.read(flashDurationStateProvider), 150);
      await toggle(tester, 'Flash on page change', delta: -260);
      expect(find.text('Flash Color'), findsNothing);
      await toggle(tester, 'Flash on page change');
      expect(container.read(flashColorStateProvider), 0);
      expect(container.read(flashIntervalStateProvider), savedInterval);
      expect(container.read(flashDurationStateProvider), 150);
      expect(container.read(autoReadDuplicateChaptersStateProvider), isFalse);
      expect(tester.takeException(), isNull);
    },
  );
}

class _DefaultReadingMode extends DefaultReadingModeState {
  @override
  ReaderMode build() => ReaderMode.rtl;
  @override
  void set(ReaderMode value) {
    state = value;
    _writes.add(('defaultReadingMode', value));
  }
}

class _ScaleType extends ScaleTypeState {
  @override
  ScaleType build() => ScaleType.fitScreen;
  @override
  void set(ScaleType value) {
    state = value;
    _writes.add(('scaleType', value));
  }
}

class _BackgroundColor extends BackgroundColorState {
  @override
  BackgroundColor build() => BackgroundColor.black;
  @override
  void set(BackgroundColor value) {
    state = value;
    _writes.add(('backgroundColor', value));
  }
}

class _ShowPagesNumber extends ShowPagesNumberState {
  @override
  bool build() => true;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('showPagesNumber', value));
  }
}

class _KeepScreenOnReader extends KeepScreenOnReaderState {
  @override
  bool build() => true;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('keepScreenOnReader', value));
  }
}

class _CropBorders extends CropBordersState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('cropBorders', value));
  }
}

class _SplitWidePages extends SplitWidePagesState {
  @override
  bool build() => true;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('splitWidePages', value));
  }
}

class _DualPageInvert extends DualPageInvertState {
  @override
  bool build() => true;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('dualPageInvert', value));
  }
}

class _DualPageRotateToFit extends DualPageRotateToFitState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('dualPageRotateToFit', value));
  }
}

class _DualPageRotateToFitInvert extends DualPageRotateToFitInvertState {
  @override
  bool build() => true;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('dualPageRotateToFitInvert', value));
  }
}

class _DoublePageSingleFirstPage extends DoublePageSingleFirstPageState {
  @override
  bool build() => true;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('doublePageSingleFirstPage', value));
  }
}

class _DoublePageAuto extends DoublePageAutoState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('doublePageAuto', value));
  }
}

class _LandscapeZoom extends LandscapeZoomState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('landscapeZoom', value));
  }
}

class _ZoomStartPosition extends ZoomStartPositionState {
  @override
  int build() => 2;
  @override
  void set(int value) {
    state = value;
    _writes.add(('zoomStartPosition', value));
  }
}

class _WebtoonDisableZoomOut extends WebtoonDisableZoomOutState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('webtoonDisableZoomOut', value));
  }
}

class _WebtoonDoubleTapZoomEnabled extends WebtoonDoubleTapZoomEnabledState {
  @override
  bool build() => true;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('webtoonDoubleTapZoomEnabled', value));
  }
}

class _ShowPageGaps extends ShowPageGapsState {
  @override
  bool build() => true;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('showPageGaps', value));
  }
}

class _WebtoonSidePadding extends WebtoonSidePaddingState {
  @override
  int build() => 10;
  @override
  void set(int value) {
    state = value;
    _writes.add(('webtoonSidePadding', value));
  }
}

class _UsePageTapZones extends UsePageTapZonesState {
  @override
  bool build() => true;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('usePageTapZones', value));
  }
}

class _ReaderNavigationLayout extends ReaderNavigationLayoutState {
  @override
  int build() => 0;
  @override
  void set(int value) {
    state = value;
    _writes.add(('readerNavigationLayout', value));
  }
}

class _TappingInversion extends TappingInversionState {
  @override
  int build() => 0;
  @override
  void set(int value) {
    state = value;
    _writes.add(('tappingInversion', value));
  }
}

class _ReaderHideThreshold extends ReaderHideThresholdState {
  @override
  int build() => 1;
  @override
  void set(int value) {
    state = value;
    _writes.add(('readerHideThreshold', value));
  }
}

class _ShowNavigationOverlayOnStart extends ShowNavigationOverlayOnStartState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('showNavigationOverlayOnStart', value));
  }
}

class _NavigateToPan extends NavigateToPanState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('navigateToPan', value));
  }
}

class _ChapterSwipeStartAction extends ChapterSwipeStartActionState {
  @override
  ChapterSwipeAction build() => ChapterSwipeAction.toggleBookmark;
  @override
  void set(ChapterSwipeAction value) {
    state = value;
    _writes.add(('chapterSwipeStartAction', value));
  }
}

class _ChapterSwipeEndAction extends ChapterSwipeEndActionState {
  @override
  ChapterSwipeAction build() => ChapterSwipeAction.toggleRead;
  @override
  void set(ChapterSwipeAction value) {
    state = value;
    _writes.add(('chapterSwipeEndAction', value));
  }
}

class _PagePreloadAmount extends PagePreloadAmountState {
  @override
  int build() => 6;
  @override
  void set(int value) {
    state = value;
    _writes.add(('pagePreloadAmount', value));
  }
}

class _AnimatePageTransitions extends AnimatePageTransitionsState {
  @override
  bool build() => true;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('animatePageTransitions', value));
  }
}

class _DoubleTapAnimationSpeed extends DoubleTapAnimationSpeedState {
  @override
  int build() => 1;
  @override
  void set(int value) {
    state = value;
    _writes.add(('doubleTapAnimationSpeed', value));
  }
}

class _AutoReadDuplicateChapters extends AutoReadDuplicateChaptersState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('autoReadDuplicateChapters', value));
  }
}

class _FlashOnPageChange extends FlashOnPageChangeState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('flashOnPageChange', value));
  }
}

class _FlashColor extends FlashColorState {
  @override
  int build() => 2;
  @override
  void set(int value) {
    state = value;
    _writes.add(('flashColor', value));
  }
}

class _FlashInterval extends FlashIntervalState {
  @override
  int build() => 3;
  @override
  void set(int value) {
    state = value;
    _writes.add(('flashInterval', value));
  }
}

class _FlashDuration extends FlashDurationState {
  @override
  int build() => 150;
  @override
  void set(int value) {
    state = value;
    _writes.add(('flashDuration', value));
  }
}
