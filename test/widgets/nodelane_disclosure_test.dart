import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  Widget app(Widget child, {bool reducedMotion = false}) => MaterialApp(
    theme: ThemeData(platform: TargetPlatform.iOS),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: reducedMotion),
      child: child!,
    ),
    home: Scaffold(body: child),
  );

  testWidgets(
    'disclosure animates both ways, releases closed content and restores state',
    (tester) async {
      final bucket = PageStorageBucket();
      var mounts = 0, releases = 0;
      Widget page() => PageStorage(
        bucket: bucket,
        child: ListView(
          children: [
            NodeLaneDisclosure(
              key: const PageStorageKey('advanced'),
              title: 'Advanced',
              child: _Lifetime(
                onMount: () => mounts++,
                onDispose: () => releases++,
              ),
            ),
          ],
        ),
      );
      await tester.pumpWidget(app(page()));
      final disclosure = find.byType(NodeLaneDisclosure);
      final closed = tester.getSize(disclosure).height;
      expect(mounts, 0);
      await tester.tap(find.text('Advanced'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final middle = tester.getSize(disclosure).height;
      expect(middle, greaterThan(closed));
      await tester.pumpAndSettle();
      final open = tester.getSize(disclosure).height;
      expect(open, greaterThan(middle));
      expect(mounts, 1);
      await tester.tap(find.text('Advanced'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getSize(disclosure).height, lessThan(open));
      expect(tester.getSize(disclosure).height, greaterThan(closed));
      expect(releases, 0);
      await tester.pumpAndSettle();
      expect(releases, 1);
      expect(find.text('Detail'), findsNothing);
      await tester.tap(find.text('Advanced'));
      await tester.pumpAndSettle();
      await tester.pumpWidget(app(const SizedBox()));
      await tester.pumpWidget(app(page()));
      await tester.pumpAndSettle();
      expect(find.text('Detail'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('reduced motion and rapid toggles settle on the last action', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        const NodeLaneDisclosure(
          title: 'Advanced',
          child: SizedBox(height: 120, child: Text('Detail')),
        ),
        reducedMotion: true,
      ),
    );
    await tester.tap(find.text('Advanced'));
    await tester.pump();
    expect(find.text('Detail').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Advanced'));
    await tester.tap(find.text('Advanced'));
    await tester.tap(find.text('Advanced'));
    await tester.pumpAndSettle();
    expect(find.text('Detail'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('slider drafts commit once and refresh from external values', (
    tester,
  ) async {
    final writes = <double>[];
    Widget slider(double value) => NodeLaneSliderRow(
      title: 'Speed',
      value: value,
      min: 0,
      max: 100,
      onChanged: writes.add,
    );
    await tester.pumpWidget(app(slider(20)));
    var control = tester.widget<Slider>(find.byType(Slider));
    control.onChanged!(40);
    control.onChanged!(60);
    await tester.pump();
    expect(writes, isEmpty);
    expect(tester.widget<Slider>(find.byType(Slider)).value, 60);
    control.onChangeEnd!(60);
    expect(writes, [60]);
    await tester.pumpWidget(app(slider(80)));
    expect(tester.widget<Slider>(find.byType(Slider)).value, 80);
  });

  testWidgets(
    'expanded input scroll state stays separate from the disclosure state',
    (tester) async {
      final draft = TextEditingController();
      addTearDown(draft.dispose);
      await tester.pumpWidget(
        app(
          ListView(
            children: [
              NodeLaneDisclosure(
                key: const PageStorageKey('code-options'),
                title: 'Advanced',
                child: NodeLaneTextField(
                  controller: draft,
                  code: true,
                  minLines: 4,
                  maxLines: 4,
                ),
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Advanced'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.enterText(
        find.byType(NodeLaneTextField),
        'first()\nsecond()',
      );
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.tap(find.text('Advanced'));
      await tester.pumpAndSettle();
      expect(find.byType(NodeLaneTextField), findsNothing);
      await tester.tap(find.text('Advanced'));
      await tester.pumpAndSettle();
      expect(find.text('first()\nsecond()'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'ordinary settings icons use the More ink color and shared geometry',
    (tester) async {
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => Column(
              children: [
                NodeLaneRow(
                  title: 'Link',
                  icon: NodeLaneIcons.of(context).settings,
                  onTap: () {},
                ),
                NodeLaneSwitchRow(
                  title: 'Switch',
                  icon: NodeLaneIcons.of(context).settings,
                  value: true,
                  onChanged: (_) {},
                ),
                NodeLaneDisclosure(
                  title: 'Advanced',
                  icon: NodeLaneIcons.of(context).settings,
                  child: const Text('Detail'),
                ),
              ],
            ),
          ),
        ),
      );
      final context = tester.element(find.byType(Column).first);
      final icons = tester.widgetList<Icon>(
        find.byIcon(NodeLaneIcons.of(context).settings),
      );
      expect(icons, hasLength(3));
      for (final icon in icons) {
        expect(icon.color, NodeLaneTokens.of(context).ink);
        expect(icon.size, NodeLaneTokens.iconSize);
      }
    },
  );
}

class _Lifetime extends StatefulWidget {
  const _Lifetime({required this.onMount, required this.onDispose});
  final VoidCallback onMount, onDispose;
  @override
  State<_Lifetime> createState() => _LifetimeState();
}

class _LifetimeState extends State<_Lifetime> {
  @override
  void initState() {
    super.initState();
    widget.onMount();
  }

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      const SizedBox(height: 160, child: Text('Detail'));
}
