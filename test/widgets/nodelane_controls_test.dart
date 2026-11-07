import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/modules/widgets/nodelane_glass_surface.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Widget _app(
  Widget child, {
  bool dark = false,
  double scale = 1,
  TargetPlatform platform = TargetPlatform.iOS,
}) => MaterialApp(
  theme: ThemeData(
    platform: platform,
    brightness: dark ? Brightness.dark : Brightness.light,
  ),
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
  locale: const Locale('en'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: NodeLaneSurface(
    child: Scaffold(body: SafeArea(child: child)),
  ),
);

void main() {
  testWidgets(
    'selection header keeps all and invert adjacent on narrow screens',
    (tester) async {
      _phone(tester);
      tester.view.physicalSize = const Size(320, 740);
      for (final scale in [1.0, 2.0]) {
        for (final direction in TextDirection.values) {
          final actions = <String>[];
          final all = scale == 1 ? '全选' : 'Select all';
          final invert = scale == 1 ? '反选' : 'Invert selection';
          await tester.pumpWidget(
            _app(
              Directionality(
                textDirection: direction,
                child: Builder(
                  builder: (context) => Scaffold(
                    appBar: nodeLaneSelectionAppBar(
                      context,
                      title: scale == 1 ? '已选180章' : '180 selected',
                      cancelLabel: '取消',
                      selectAllLabel: all,
                      invertLabel: invert,
                      onCancel: () => actions.add('cancel'),
                      onSelectAll: () => actions.add('all'),
                      onInvert: () => actions.add('invert'),
                    ),
                  ),
                ),
              ),
              scale: scale,
            ),
          );
          await tester.pumpAndSettle();
          final allButton = scale == 1 ? find.text(all) : find.byTooltip(all);
          final invertButton = scale == 1
              ? find.text(invert)
              : find.byTooltip(invert);
          expect(
            tester.getCenter(allButton).dy,
            tester.getCenter(invertButton).dy,
          );
          expect(
            tester.getCenter(allButton).dx < tester.getCenter(invertButton).dx,
            direction == TextDirection.ltr,
          );
          await tester.tap(allButton);
          await tester.tap(invertButton);
          await tester.tap(find.text('取消'));
          expect(actions, ['all', 'invert', 'cancel']);
          expect(tester.takeException(), isNull);
        }
      }
    },
  );

  testWidgets('progress menu keeps cancellation available during work', (
    tester,
  ) async {
    _phone(tester);
    var cancelled = false;
    await tester.pumpWidget(
      _app(
        NodeLaneMenuButton<int>(
          icon: Icons.download,
          tooltip: 'Download',
          busy: true,
          progress: .4,
          itemBuilder: (_) => [
            const PopupMenuItem(value: 0, child: Text('Cancel download')),
          ],
          onSelected: (_) => cancelled = true,
        ),
      ),
    );
    await tester.tap(find.byTooltip('Download'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel download'));
    await tester.pumpAndSettle();
    expect(cancelled, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('failure retry stays reachable in a short large-text panel', (
    tester,
  ) async {
    _phone(tester);
    var attempts = 0;
    await tester.pumpWidget(
      _app(
        SizedBox(
          height: 180,
          child: NodeLaneEmptyState.error(
            title: 'Request failed',
            message: 'Technical cause ' * 30,
            compact: true,
            onRetry: () => attempts++,
          ),
        ),
        scale: 2.5,
      ),
    );
    await tester.ensureVisible(find.text('Retry'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retry'));
    expect(attempts, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(
      _app(
        NodeLaneEmptyState.error(
          onRetry: () => attempts++,
          autofocusRetry: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(Focus.of(tester.element(find.text('Retry'))).hasFocus, isTrue);
  });

  testWidgets('mobile platforms share control geometry, materials and glyphs', (
    tester,
  ) async {
    _phone(tester);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final snapshots = <Object>[];
    for (final dark in [false, true]) {
      for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
        await tester.pumpWidget(
          _app(
            Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    NodeLaneTextField.search(
                      controller: controller,
                      hint: 'Search',
                      onChanged: (_) {},
                    ),
                    NodeLaneIconButton(
                      icon: NodeLaneIcons.of(context).more,
                      tooltip: 'More',
                      onPressed: () {},
                    ),
                    NodeLaneSwitchRow(
                      title: 'Enabled',
                      value: true,
                      onChanged: (_) {},
                    ),
                    NodeLaneSegments<int>(
                      value: 0,
                      segments: const [
                        ButtonSegment(value: 0, label: Text('One')),
                        ButtonSegment(value: 1, label: Text('Two')),
                      ],
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
            ),
            dark: dark,
            platform: platform,
          ),
        );
        await tester.pumpAndSettle();
        snapshots.add([
          tester.getRect(find.byType(TextField)),
          tester.getRect(find.byType(NodeLaneIconButton)),
          tester.getRect(find.byType(NodeLaneSwitch)),
          tester.getRect(find.byType(NodeLaneSegments<int>)),
          tester
              .widgetList<Icon>(find.byType(Icon))
              .map((e) => (e.icon, e.size, e.color))
              .toList(),
          tester
              .widgetList<DecoratedBox>(
                find.descendant(
                  of: find.byType(NodeLaneGlassSurface),
                  matching: find.byType(DecoratedBox),
                ),
              )
              .map((e) => e.decoration)
              .toList(),
        ]);
        expect(find.byType(BackdropFilter), findsNWidgets(2));
        expect(tester.takeException(), isNull);
      }
    }
    expect(snapshots[0], snapshots[1]);
    expect(snapshots[2], snapshots[3]);
  });

  for (final direction in TextDirection.values) {
    testWidgets(
      'setting values and descriptions keep separate space in $direction',
      (tester) async {
        tester.view.physicalSize = const Size(320, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        const title = 'Custom network address';
        const value = 'https://example.com/a/very/long/custom/path';
        const description =
            'Used for connections. Leave empty to use the default.';
        await tester.pumpWidget(
          _app(
            Directionality(
              textDirection: direction,
              child: ListView(
                children: [
                  NodeLaneGroupSurface(
                    children: [
                      NodeLaneRow(
                        title: title,
                        value: value,
                        subtitle: description,
                        icon: Icons.public,
                        onTap: () {},
                      ),
                      NodeLaneSliderRow(
                        title: 'Scale',
                        value: 100,
                        min: 85,
                        max: 125,
                        label: (value) => '${value.round()}%',
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            dark: true,
            scale: 2,
          ),
        );
        final titleRect = tester.getRect(find.text(title));
        final valueRect = tester.getRect(find.text(value));
        final descriptionRect = tester.getRect(find.text(description));
        expect(descriptionRect.top, greaterThan(titleRect.bottom));
        expect(descriptionRect.top, greaterThan(valueRect.bottom));
        expect(
          descriptionRect.width,
          greaterThan(titleRect.width + valueRect.width),
        );
        if (direction == TextDirection.ltr) {
          expect(valueRect.left, greaterThan(titleRect.right));
          expect(descriptionRect.left, titleRect.left);
          expect(descriptionRect.right, valueRect.right);
        } else {
          expect(valueRect.right, lessThan(titleRect.left));
          expect(descriptionRect.right, titleRect.right);
          expect(descriptionRect.left, valueRect.left);
        }
        await tester.ensureVisible(find.text('Scale'));
        await tester.pumpAndSettle();
        final sliderTitle = tester.getRect(find.text('Scale'));
        final sliderValue = tester.getRect(find.text('100%'));
        expect(sliderTitle.center.dy, sliderValue.center.dy);
        expect(
          sliderValue.center.dx,
          direction == TextDirection.ltr
              ? greaterThan(sliderTitle.right)
              : lessThan(sliderTitle.left),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
