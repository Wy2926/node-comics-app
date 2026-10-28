import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/main_view/widgets/mode_bars.dart';

void main() {
  testWidgets(
    'mode status consumes the top inset once and keeps the page alive',
    (tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final modes = ValueNotifier((false, false, 47.0));
      final scroll = ScrollController();
      addTearDown(modes.dispose);
      addTearDown(scroll.dispose);
      var builds = 0;
      EdgeInsets? pagePadding;
      final page = _KeptPage(
        scroll: scroll,
        onInit: () => builds++,
        onPadding: (value) => pagePadding = value,
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) => ValueListenableBuilder(
              valueListenable: modes,
              builder: (_, value, _) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  padding: EdgeInsets.only(top: value.$3, bottom: 34),
                  viewPadding: EdgeInsets.only(top: value.$3, bottom: 34),
                  textScaler: TextScaler.linear(2.5),
                ),
                child: ModeBarsLayout(
                  mobile: true,
                  downloadedOnly: value.$1,
                  incognitoMode: value.$2,
                  l10n: AppLocalizations.of(context)!,
                  child: page,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.text('Page 0')).dy, 47);
      modes.value = (true, false, 47.0);
      await tester.pumpAndSettle();
      final bannerSafeArea = find
          .ancestor(
            of: find.text('Downloaded only'),
            matching: find.byType(SafeArea),
          )
          .first;
      expect(
        tester.getTopLeft(find.text('Page 0')).dy,
        tester.getBottomLeft(bannerSafeArea).dy,
      );
      expect(pagePadding, const EdgeInsets.only(bottom: 34));
      modes.value = (true, true, 47.0);
      await tester.pumpAndSettle();
      expect(find.text('Downloaded only'), findsOneWidget);
      expect(find.text('Incognito Mode'), findsOneWidget);
      expect(tester.takeException(), isNull);

      scroll.jumpTo(400);
      await tester.pumpAndSettle();
      modes.value = (false, true, 0.0);
      await tester.pumpAndSettle();
      expect(find.text('Downloaded only'), findsNothing);
      expect(
        tester.getSize(find.text('Incognito Mode')).height,
        greaterThan(0),
      );
      expect(scroll.offset, 400);
      modes.value = (false, false, 47.0);
      await tester.pumpAndSettle();
      expect(find.text('Incognito Mode'), findsNothing);
      expect(pagePadding, const EdgeInsets.only(top: 47, bottom: 34));
      expect(scroll.offset, 400);
      expect(builds, 1);
      expect(tester.takeException(), isNull);
    },
  );
}

class _KeptPage extends StatefulWidget {
  const _KeptPage({
    required this.scroll,
    required this.onInit,
    required this.onPadding,
  });
  final ScrollController scroll;
  final VoidCallback onInit;
  final ValueChanged<EdgeInsets> onPadding;
  @override
  State<_KeptPage> createState() => _KeptPageState();
}

class _KeptPageState extends State<_KeptPage> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  Widget build(BuildContext context) {
    widget.onPadding(MediaQuery.paddingOf(context));
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          controller: widget.scroll,
          itemCount: 60,
          itemExtent: 80,
          itemBuilder: (_, index) => Text('Page $index'),
        ),
      ),
    );
  }
}
