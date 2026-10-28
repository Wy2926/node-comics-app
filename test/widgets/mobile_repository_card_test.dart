import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_repository_card.dart';

void main() {
  testWidgets(
    'repository actions and visibility remain independent at large text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var visible = true;
      var copied = 0, removed = 0, opened = 0;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: StatefulBuilder(
            builder: (context, setState) => MobileBrowsePage(
              title: 'Manga extensions repositories',
              body: ListView(
                children: [
                  MobileRepositoryCard(
                    name: 'A long repository name',
                    host: 'extensions.example.test',
                    visible: visible,
                    visibilityLabel: 'Show extensions',
                    onVisibilityChanged: (value) =>
                        setState(() => visible = value),
                    copyLabel: 'Copy',
                    onCopy: () => copied++,
                    removeLabel: 'Remove repository',
                    onRemove: () => removed++,
                    browserLabel: 'Open in browser',
                    onOpenBrowser: () => opened++,
                  ),
                ],
              ),
              bottomAction: FilledButton(
                onPressed: () {},
                child: const Text('Add repository'),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Show extensions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Show extensions'));
      await tester.pumpAndSettle();
      expect(visible, isFalse);
      await tester.ensureVisible(find.text('Copy'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Copy'));
      await tester.ensureVisible(find.byTooltip('Remove repository'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Remove repository'));
      expect(copied, 1);
      expect(removed, 1);
      expect(opened, 0);
      expect(visible, isFalse);
      expect(tester.takeException(), isNull);
    },
  );
}
