import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

Widget app(Widget child) => MaterialApp(
  theme: ThemeData(brightness: Brightness.dark),
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
    child: child!,
  ),
  home: Scaffold(body: child),
);

void main() {
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
          app(
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
