import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/cover_grid_skeleton.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';

Widget _host(Widget child, {bool disableAnimations = false}) {
  return MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  testWidgets(
    'keeps grid geometry and settles when reduced motion is requested',
    (tester) async {
      await tester.pumpWidget(
        _host(
          const CoverGridSkeleton(
            gridSize: 3,
            itemCount: 6,
            childAspectRatio: 0.642,
          ),
          disableAnimations: true,
        ),
      );

      // pumpAndSettle times out against a repeating animation, so this failing
      // is the signal that the reduce-motion path stopped being honoured.
      await tester.pumpAndSettle();
      final grid = tester.widget<GridViewWidget>(find.byType(GridViewWidget));
      expect(
        (grid.gridSize, grid.itemCount, grid.childAspectRatio),
        (3, 6, 0.642),
      );
    },
  );
}
