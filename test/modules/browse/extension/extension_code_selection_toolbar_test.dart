import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/browse/extension/edit_code.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/app_font_family.dart';
import 'package:mangayomi/utils/log/log.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_code_selection_toolbar.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  testWidgets(
    'editor survives resize, clears visible logs and releases its subscription',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(820, 1000);
      addTearDown(tester.view.reset);
      for (var i = 0; i < 2; i++) {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [appFontFamilyProvider.overrideWith(_DefaultFont.new)],
            child: MaterialApp(
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const CodeEditorPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        Logger.add(LoggerLevel.info, 'Editor test log');
        await tester.pumpAndSettle();
        expect(find.text('Editor test log'), findsOneWidget);
        await tester.tap(find.byTooltip('Clear logs'));
        await tester.pumpAndSettle();
        expect(find.text('Editor test log'), findsNothing);
        tester.view.physicalSize = const Size(390, 844);
        await tester.pumpAndSettle();
        expect(find.byType(CodeEditor), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        Logger.add(LoggerLevel.info, 'After closing editor');
        await tester.pump();
        expect(tester.takeException(), isNull);
        tester.view.physicalSize = const Size(820, 1000);
      }
      Logger.clear();
    },
  );

  testWidgets('the mobile code selection toolbar copies the selected code', (
    tester,
  ) async {
    String? copiedText;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            copiedText =
                (call.arguments as Map<Object?, Object?>)['text'] as String?;
          }
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );

    final controller = CodeLineEditingController.fromText('extensionCode');
    addTearDown(controller.dispose);
    controller.selection = const CodeLineSelection(
      baseIndex: 0,
      baseOffset: 0,
      extentIndex: 0,
      extentOffset: 9,
    );

    final toolbar = createExtensionCodeSelectionToolbar();
    final layerLink = LayerLink();
    final visibility = ValueNotifier(true);
    addTearDown(visibility.dispose);
    late BuildContext toolbarContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            toolbarContext = context;
            return Scaffold(
              body: CompositedTransformTarget(
                link: layerLink,
                child: const SizedBox(width: 320, height: 160),
              ),
            );
          },
        ),
      ),
    );

    toolbar.show(
      context: toolbarContext,
      controller: controller,
      anchors: const TextSelectionToolbarAnchors(primaryAnchor: Offset(50, 24)),
      renderRect: const Rect.fromLTWH(0, 0, 320, 160),
      layerLink: layerLink,
      visibility: visibility,
    );
    await tester.pumpAndSettle();

    final selectedText = controller.selectedText;
    expect(selectedText, 'extension');
    expect(find.text('Copy'), findsOneWidget);

    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();

    expect(copiedText, selectedText);
  });

  testWidgets('Select All refreshes the menu with the full extension code', (
    tester,
  ) async {
    final controller = CodeLineEditingController.fromText('extensionCode');
    addTearDown(controller.dispose);

    final toolbar = createExtensionCodeSelectionToolbar();
    final layerLink = LayerLink();
    final visibility = ValueNotifier(true);
    addTearDown(visibility.dispose);
    late BuildContext toolbarContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            toolbarContext = context;
            return Scaffold(
              body: CompositedTransformTarget(
                link: layerLink,
                child: const SizedBox(width: 320, height: 160),
              ),
            );
          },
        ),
      ),
    );

    toolbar.show(
      context: toolbarContext,
      controller: controller,
      anchors: const TextSelectionToolbarAnchors(primaryAnchor: Offset(50, 24)),
      renderRect: const Rect.fromLTWH(0, 0, 320, 160),
      layerLink: layerLink,
      visibility: visibility,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Select all'));
    await tester.pumpAndSettle();

    expect(controller.selectedText, 'extensionCode');
    expect(find.text('Copy'), findsOneWidget);
  });
}

class _DefaultFont extends AppFontFamily {
  @override
  (String?, String?) build() => (null, null);
}
