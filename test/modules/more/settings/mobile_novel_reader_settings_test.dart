import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/reader/mobile_novel_reader_screen.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';

final _writes = <(String, Object?)>[];

void main() {
  var scale = 1.0;
  var ttsOpens = 0;
  var ttsSupported = true;
  Widget app(ProviderContainer container) => UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(scale),
          padding: const EdgeInsets.only(top: 24, bottom: 34),
        ),
        child: child!,
      ),
      home: MobileNovelReaderScreen(
        onOpenTts: ttsSupported ? () => ttsOpens++ : null,
      ),
    ),
  );

  ProviderContainer preferences(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        novelFontSizeStateProvider.overrideWith(_NovelFontSize.new),
        novelTextAlignStateProvider.overrideWith(_NovelTextAlign.new),
        novelReaderThemeStateProvider.overrideWith(_NovelReaderTheme.new),
        novelReaderTextColorStateProvider.overrideWith(
          _NovelReaderTextColor.new,
        ),
        novelReaderPaddingStateProvider.overrideWith(_NovelReaderPadding.new),
        novelReaderLineHeightStateProvider.overrideWith(
          _NovelReaderLineHeight.new,
        ),
        novelFontFamilyStateProvider.overrideWith(_NovelFontFamily.new),
        novelShowScrollPercentageStateProvider.overrideWith(
          _NovelShowScrollPercentage.new,
        ),
        novelRemoveExtraParagraphSpacingStateProvider.overrideWith(
          _NovelRemoveExtraParagraphSpacing.new,
        ),
        novelTapToScrollStateProvider.overrideWith(_NovelTapToScroll.new),
        keepScreenOnReaderStateProvider.overrideWith(_KeepScreenOnReader.new),
        doublePageAutoStateProvider.overrideWith(_DoublePageAuto.new),
      ],
    );
    addTearDown(container.dispose);
    // Model persisted preferences while collapsed sections release consumers.
    addTearDown(container.listen(novelFontSizeStateProvider, (_, _) {}).close);
    addTearDown(container.listen(novelTextAlignStateProvider, (_, _) {}).close);
    addTearDown(
      container.listen(novelReaderThemeStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(novelReaderTextColorStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(novelReaderPaddingStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(novelReaderLineHeightStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(novelFontFamilyStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(novelShowScrollPercentageStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container
          .listen(novelRemoveExtraParagraphSpacingStateProvider, (_, _) {})
          .close,
    );
    addTearDown(
      container.listen(novelTapToScrollStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container.listen(keepScreenOnReaderStateProvider, (_, _) {}).close,
    );
    addTearDown(container.listen(doublePageAutoStateProvider, (_, _) {}).close);
    return container;
  }

  setUp(() {
    scale = 1;
    ttsOpens = 0;
    ttsSupported = true;
    _writes.clear();
  });

  Future<void> reveal(
    WidgetTester tester,
    Finder target, {
    double delta = 280,
  }) async {
    await tester.scrollUntilVisible(
      target,
      delta,
      scrollable: find.byType(Scrollable).first,
    );
    await Scrollable.ensureVisible(tester.element(target), alignment: 0.5);
    await tester.pumpAndSettle();
  }

  Future<void> open(
    WidgetTester tester,
    String title, {
    double delta = 280,
  }) async {
    final target = find.widgetWithText(MobileSettingsLink, title);
    await reveal(tester, target, delta: delta);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> choose(
    WidgetTester tester,
    String title,
    String option, {
    double delta = 280,
  }) async {
    await open(tester, title, delta: delta);
    final target = find.widgetWithText(ListTile, option);
    await reveal(tester, target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> expand(
    WidgetTester tester,
    String label, {
    double delta = 280,
  }) async {
    final target = find.text(label);
    await reveal(tester, target, delta: delta);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> toggle(
    WidgetTester tester,
    String title, {
    double delta = 280,
  }) async {
    final target = find.widgetWithText(MobileSettingsSwitch, title);
    await reveal(tester, target, delta: delta);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'font cancel differs from default and theme presets preserve independent custom colors',
    (tester) async {
      final container = preferences(tester);
      await tester.pumpWidget(app(container));
      await tester.pumpAndSettle();
      await open(tester, 'Font');
      expect(find.text('Atkinson Hyperlegible'), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(_writes, isEmpty);
      await choose(tester, 'Font', 'Default');
      expect(container.read(novelFontFamilyStateProvider), isNull);
      await choose(tester, 'Font', 'Lexend');
      expect(_writes, [
        ('novelFontFamily', null),
        ('novelFontFamily', 'Lexend'),
      ]);
      await choose(tester, 'Theme', 'Dark');
      // Matching only the background is not enough: selecting Dark restores
      // its paired text color, without rewriting the unchanged background.
      expect(_writes.last, ('novelReaderTextColor', '#CCCCCC'));
      expect(_writes, hasLength(3));
      await choose(tester, 'Theme', 'Sepia');
      expect(_writes.skip(3), [
        ('novelReaderTheme', '#F5E6D3'),
        ('novelReaderTextColor', '#5F4B32'),
      ]);
      await expand(tester, 'Custom');
      await open(tester, 'Background');
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(_writes, hasLength(5));
      await choose(tester, 'Background', '#FFFFFF');
      expect(container.read(novelReaderThemeStateProvider), '#FFFFFF');
      expect(container.read(novelReaderTextColorStateProvider), '#5F4B32');
      await choose(tester, 'Text', '#000000');
      expect(container.read(novelReaderThemeStateProvider), '#FFFFFF');
      expect(container.read(novelReaderTextColorStateProvider), '#000000');
      expect(_writes, hasLength(7));
      expect(ttsOpens, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'large text layouts save sliders at release and keep reading preferences independent',
    (tester) async {
      scale = 2.5;
      final container = preferences(tester);
      await tester.pumpWidget(app(container));
      await tester.pumpAndSettle();
      Future<void> dragSlider(Finder slider, String preference) async {
        await reveal(tester, slider);
        final before = _writes.length;
        final gesture = await tester.startGesture(tester.getCenter(slider));
        await gesture.moveBy(const Offset(35, 0));
        await tester.pump();
        expect(_writes, hasLength(before));
        await gesture.up();
        await tester.pumpAndSettle();
        expect(_writes, hasLength(before + 1));
        expect(_writes.last.$1, preference);
      }

      await dragSlider(find.byType(Slider).first, 'novelFontSize');
      expect(
        container.read(novelFontSizeStateProvider),
        inInclusiveRange(8, 40),
      );
      expect(container.read(novelReaderPaddingStateProvider), 16);
      await toggle(tester, 'Keep screen on');
      await toggle(tester, 'Show Scroll Percentage');
      await open(tester, 'Text-to-Speech');
      expect(ttsOpens, 1);
      final beforeExpand = _writes.length;
      await expand(tester, 'Page layout');
      expect(_writes, hasLength(beforeExpand));
      await choose(tester, 'Text Align', 'Justify');
      final paddingSlider = find.byWidgetPredicate(
        (widget) => widget is Slider && widget.min == 0 && widget.max == 50,
      );
      await dragSlider(paddingSlider, 'novelReaderPadding');
      final lineHeightSlider = find.byWidgetPredicate(
        (widget) => widget is Slider && widget.min == 1 && widget.max == 3,
      );
      await dragSlider(lineHeightSlider, 'novelReaderLineHeight');
      expect(
        container.read(novelReaderLineHeightStateProvider),
        inInclusiveRange(1, 3),
      );
      await toggle(tester, 'Remove Extra Paragraph Spacing');
      await toggle(tester, 'Use page tap zones');
      await toggle(tester, 'Automatic double page');
      final hint = find.text(
        'Set reading mode and single or double pages while reading a title.',
      );
      await reveal(tester, hint);
      expect(tester.getBottomRight(hint).dy, lessThanOrEqualTo(740 - 34));
      expect(container.read(novelTextAlignStateProvider), NovelTextAlign.block);
      expect(container.read(novelTapToScrollStateProvider), isTrue);
      expect(container.read(doublePageAutoStateProvider), isTrue);
      expect(container.read(keepScreenOnReaderStateProvider), isFalse);
      expect(container.read(novelShowScrollPercentageStateProvider), isFalse);
      final saved = List.of(_writes);
      await expand(tester, 'Page layout', delta: -280);
      await expand(tester, 'Page layout');
      expect(_writes, saved);
      expect(container.read(novelTextAlignStateProvider), NovelTextAlign.block);
      expect(container.read(novelReaderThemeStateProvider), '#292832');
      ttsSupported = false;
      await tester.pumpWidget(app(container));
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(MobileSettingsLink, 'Text-to-Speech'),
        findsNothing,
      );
      expect(ttsOpens, 1);
      expect(tester.takeException(), isNull);
    },
  );
}

class _NovelFontSize extends NovelFontSizeState {
  @override
  int build() => 14;
  @override
  void set(int value) {
    state = value;
    _writes.add(('novelFontSize', value));
  }
}

class _NovelTextAlign extends NovelTextAlignState {
  @override
  NovelTextAlign build() => NovelTextAlign.left;
  @override
  void set(NovelTextAlign value) {
    state = value;
    _writes.add(('novelTextAlign', value));
  }
}

class _NovelReaderTheme extends NovelReaderThemeState {
  @override
  String build() => '#292832';
  @override
  void set(String value) {
    state = value;
    _writes.add(('novelReaderTheme', value));
  }
}

class _NovelReaderTextColor extends NovelReaderTextColorState {
  @override
  String build() => '#EEEEEE';
  @override
  void set(String value) {
    state = value;
    _writes.add(('novelReaderTextColor', value));
  }
}

class _NovelReaderPadding extends NovelReaderPaddingState {
  @override
  int build() => 16;
  @override
  void set(int value) {
    state = value;
    _writes.add(('novelReaderPadding', value));
  }
}

class _NovelReaderLineHeight extends NovelReaderLineHeightState {
  @override
  double build() => 1.5;
  @override
  void set(double value) {
    state = value;
    _writes.add(('novelReaderLineHeight', value));
  }
}

class _NovelFontFamily extends NovelFontFamilyState {
  @override
  String? build() => 'AtkinsonHyperlegible';
  @override
  void set(String? value) {
    state = value;
    _writes.add(('novelFontFamily', value));
  }
}

class _NovelShowScrollPercentage extends NovelShowScrollPercentageState {
  @override
  bool build() => true;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('novelShowScrollPercentage', value));
  }
}

class _NovelRemoveExtraParagraphSpacing
    extends NovelRemoveExtraParagraphSpacingState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('novelRemoveExtraParagraphSpacing', value));
  }
}

class _NovelTapToScroll extends NovelTapToScrollState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('novelTapToScroll', value));
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

class _DoublePageAuto extends DoublePageAutoState {
  @override
  bool build() => false;
  @override
  void set(bool value) {
    state = value;
    _writes.add(('doublePageAuto', value));
  }
}
