import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  testWidgets(
    'repeated expansion refreshes single-subscription streams and releases them',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final streams = <StreamController<String>>[];
      var active = 0, listens = 0, cancels = 0;
      var account = 'No tracking account';

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: NodeLaneSurface(
            child: Scaffold(
              body: NodeLaneDisclosure(
                title: 'More',
                child: Builder(
                  builder: (context) {
                    // Like an Isar query watch, each instance permits only one listener.
                    final stream = StreamController<String>(
                      onListen: () {
                        active++;
                        listens++;
                      },
                      onCancel: () {
                        active--;
                        cancels++;
                      },
                    )..add(account);
                    streams.add(stream);
                    return StreamBuilder<String>(
                      stream: stream.stream,
                      builder: (context, snapshot) =>
                          Text(snapshot.data ?? 'Loading'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Creating an Isar watch already allocates a native watcher, even before
      // listening. Closed content must not create it in the first place.
      expect(streams, isEmpty);
      // Do not rebuild the parent between toggles: that hid the original failure.
      for (var cycle = 0; cycle < 5; cycle++) {
        account = 'Tracking account $cycle';
        await tester.tap(find.text('More'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(active, 1);
        expect(find.text(account), findsOneWidget);
        streams.last.add('Updated account $cycle');
        await tester.pumpAndSettle();
        expect(find.text('Updated account $cycle'), findsOneWidget);

        await tester.tap(find.text('More'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(active, 0);
        expect(find.byType(StreamBuilder<String>), findsNothing);
      }
      expect(listens, 5);
      expect(cancels, 5);

      // Leaving the route while expanded also releases its listener.
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      expect(active, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(active, 0);
      expect(cancels, 6);
      expect(streams, hasLength(6));
      for (final stream in streams) {
        unawaited(stream.close());
        expect(stream.isClosed, isTrue);
      }
      await tester.pumpAndSettle();
    },
  );
}
